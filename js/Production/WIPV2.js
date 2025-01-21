// Global variables
let paramDate;
let paramSKU;
let paramStep;
let generated = 0;
let submitted = 0;
let cancelled = 0;
let initsubmitted = 0;
let userfound = 0;
let steps;
let stepOpt;
let DT;
let DTV;
let DTCookingStage;
let DTCookingStage2;
let dataCount;
let dataCountCooking;
let BatchOpt;
let cooking;
let cookingOpt;
let cookingStage;
let cookingStageOpt;
let customerCode;
let customerCodeOpt;
let warehouseCode;
let warehouseCodeOpt;
let itemCode;
let itemCodeOpt;
let isDisabled = true;
let doc;
let start = 0
let until = 4;
let limit = 5;
let gSmokeHouseNo;
let gITAfterCooking;
let gITValidationQA;
let BatchCooking = [];
let RecCount = 0;
BatchNum = {};

// Page Onload
document.addEventListener("DOMContentLoaded", () => {
    Parameters();
});

// VARIABLES START

const swalWithBootstrapButtons = Swal.mixin({
    customClass: {
        confirmButton: 'btn btn-success',
        cancelButton: 'btn btn-danger'
    },
    buttonsStyling: false
});

const swalWithBootstrapButtons2 = Swal.mixin({
    customClass: {
        confirmButton: 'btn btn-success col-3 mr-1',
        cancelButton: 'btn btn-danger col-3'
    },
    buttonsStyling: false
});

const swalWithBootstrapButtons3 = Swal.mixin({
    customClass: {
        confirmButton: 'btn btn-success col-3 mr-1',
        denyButton: 'btn btn-info col-3'
    },
    buttonsStyling: false
});

// VARIABLES END


// EVENTS START

// EVENT: Email Button
$('.emailBtn').click(function (e) {
    $(this).toggleClass('active');
    $('.emailBox').toggleClass('active');
});

// EVENT: Parameters
$('.params').on('change', function (e) {
    paramDate = $('.params').eq(0).val();
    paramSKU = $('.params').eq(1).val();
    paramStep = $('.params').eq(2).val();

    if (paramDate && paramSKU && paramStep) $('#btnView').removeAttr("disabled");

    paramStep == "FG Dispatch" ? $('#SAPNo').closest("span").removeClass("d-none") : $('#SAPNo').closest("span").addClass("d-none")
});

// EVENT: Production Date Parameter
$('#paramDate').on('change', function (e) {
    let date = new Date($('#paramDate').val());

    let parameters = {
        Year: date.getFullYear(),
        WorkWeek: date.getWeek()
    }

    $.ajax({
        type: "POST",
        url: "frmWIPOUTV2.aspx/FilteredParameter",
        contentType: "application/json; charset=utf-8",
        data: '{_data:' + JSON.stringify(parameters) + '}',
        dataType: "json",
        success: function (data) {
            dataN = JSON.parse(data.d[0]);
            table = "<option value='Code' disabled='disabled'>Description</option><option ></option>";

            dataN.forEach((obj) => {
                table += "<option value='" + obj.Code + "'>" + obj.Name + "</option>";
            });

            $('#paramSKU').html(table);

            $('#paramSKU').select2({
                width: "200px",
                placeholder: "Select a SKU",
                dropdownCssClass: "dropdowncss",
                templateResult: templateResult2,
                templateSelection: templateSelection,
                matcher: matchStart
            });
        },
        error: function (error) {
            swalWithBootstrapButtons.fire({
                title: "Error",
                text: error,
                icon: "error"
            });
        }

    });
});

// EVENT: Update fields color
$(document).on('keydown change', '.editable', function () {
    $(this).is("input") ?
        $(this).removeClass("required") :
        $(this).siblings("span").find(".select2-selection").removeClass("required");
});

// EVENT: Auto calculate Total Scrap
$(document).on('input', '.calculate', function () {
    let row = $(this).closest('tr');
    let toSum = row.find('.calculate');
    let total = row.find('.calculatetotal');
    let sum = 0;

    toSum.each(function (i, obj) {
        let val = $(obj).val() == "" ? 0 : $(obj).val();
        sum = parseFloat(sum) + parseFloat(val);
    });

    total.val(sum);
});

// EVENT: Auto calculate Total Packs
$(document).on('input', '.calculate1', function () {
    let row = $(this).closest('tr');
    let toMult = row.find('.calculate1');
    let total = row.find('.totalcalculate1');
    let mult = 1;

    toMult.each(function (i, obj) {
        let val = $(obj).val() == "" ? 1 : $(obj).val();
        mult = (parseFloat(mult) * parseFloat(val)).toFixed(4);
    });

    total.val(mult);
});

// EVENT: Button show cooking stage modal
$(document).on('click', '.btnViewCookingStage', function () {
    let BatchNo = DT.row($(this).closest('tr')).data().BatchNo;
    let DocNumber = DT.row($(this).closest('tr')).data().DocNumber;
    let SmokeHouseNo = DT.row($(this).closest('tr')).data().SmokeHouseNo;
    let Rerun = DT.row($(this).closest('tr')).data().Rerun;
    let ITAfterCooking = $(this).closest('tr').find('.itaftercooking').val();
    let ITValidationQA = $(this).closest('tr').find('.itvalidationqa').val();
    $('#CookingStageModal').modal('toggle');

    GetCookingStage(dataCountCooking, "disabled='disabled'", BatchNo, SmokeHouseNo, ITAfterCooking, ITValidationQA, DocNumber, 'CookingStage2', Rerun);
});

$(document).on('click', '.btnEditCookingStage', async function () {
    let SmokeHouseNo = $(this).closest('tr').find('.smokehouseno').val();
    let ITAfterCooking = $(this).closest('tr').find('.itaftercooking').val();
    let ITValidationQA = $(this).closest('tr').find('.itvalidationqa').val();
    let BatchNo = DT.row($(this).closest('tr')).data().BatchNo;
    let DocNo = DT.row($(this).closest('tr')).data().DocNumber;
    let Rerun = DT.row($(this).closest('tr')).data().Rerun;
    let msg = "";

    console.log(Rerun);

    //if (SmokeHouseNo && ITAfterCooking) {
        if (SmokeHouseNo) {
        $.ajax({
            type: "POST",
            url: "frmWIPOUTV2.aspx/CheckIfCookingStageExist",
            data: '{ _data:' + JSON.stringify({ DocNumber: paramSKU, SmokeHouseNo: SmokeHouseNo }) + '}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: async function (data) {
                if (data.d) {
                    $('#CookingStageSmokehouse').val(SmokeHouseNo);
                    $('#CookingStageModal').modal('toggle');
                    GetCookingStage(dataCountCooking, "", BatchNo, SmokeHouseNo, ITAfterCooking, ITValidationQA, DocNo, 'CookingStage', Rerun);
                }
                else {
                    Message("No Existing Data", "Setup the masterfile cooking stage for " + paramSKU, "warning");
                }
            },
            error: function (error) {
                Message("Error", error.responseJSON.Message, "error");
            }
        });

    }
    else {
        if (!SmokeHouseNo) msg += "Smokehouse number is needed </br>";
        //if (!ITAfterCooking) msg += "IT After Cooking is needed </br>";
        //if (!ITValidationQA) msg += "IT Validation QA is needed </br>";

        Message("Field required", "", "warning", true, msg);
    }

});

$(document).on('click', '.btnAddCookingStage', async function () {
    let batchno = $(this).attr("data-batchno");
    let docno = $(this).attr("data-docno");
    let batchesH = "";
    doc = DT.row().data().DocNumber;

    swalWithBootstrapButtons3.fire({
        title: "Option",
        html: "Add to current cooking stages or create a new one?",
        showDenyButton: true,
        confirmButtonText: 'Add',
        denyButtonText: 'New',
    }).then(async (result) => {
        // Add Cooking Stage
        if (result.isConfirmed) {
            if (!$.fn.DataTable.isDataTable('#DTbl3')) GetCookingStage2(dataCountCooking, isDisabled, doc);

            $('#NewCookingStageModal').modal('toggle');

            let batches = $('#DTbl3').find(".batch");

            batches.each(function (i, obj) {
                let val = $(obj).val();
                let allVal = val.length > 0 ? val + "," + batchno : batchno;
                let arrayVal = new Array();

                allVal.split(",").forEach(function (obj, i) {
                    arrayVal.push("'" + obj + "'");
                });

                batchesH = allVal.split(",");
                $(obj).val(allVal.split(",")).trigger('change');
            });

            $('#NewCookingStageBatch').val(batchesH).trigger('change');
        }
        // New Cooking Stage
        else if (result.isDenied) {
            if ($.fn.DataTable.isDataTable('#DTbl3')) $('#btnNewSaveCookingStage').click();

            let date = new Date(paramDate);
            let parameters = {
                Year: date.getFullYear(),
                WorkWeek: date.getWeek(),
                DayNo: date.getDay(),
                ProductionDate: paramDate,
                SKUCode: paramSKU,
                StepCode: paramStep,
                Action: "CreateCookingStage",
                DocNumber: docno
            }

            $.ajax({
                type: "POST",
                url: "frmWIPOUTV2.aspx/SP_Call",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: '{_data:' + JSON.stringify(parameters) + '}',
                success: async function (data) {
                    await GetCookingStage2(dataCountCooking, isDisabled, docno, batchno);

                    $('#NewCookingStageModal').modal('toggle');
                },
                error: function (error) {
                    Message("Error", error.responseJSON.Message, "error");
                }
            });
        }
    });
});

$(document).on('change', '#CookingStageBatch', async function () {
    let value = $(this).val();
    let batches = $('#DTbl2').find(".batch");

    batches.each(function (i, obj) {
        $(obj).val(value).trigger('change');
    });
});

$(document).on('change', '#NewCookingStageBatch', async function () {
    let value = $(this).val();
    let batches = $('#DTbl3').find(".batch");

    batches.each(function (i, obj) {
        $(obj).val(value).trigger('change');
    });
});

// EVENT: Button show cooking stage modal
$(document).on('click', '#btnSelectCookingStage', function () {
    let doc = $(this).attr("data-doc");

    $('#btnSaveCookingStageSelect').attr("data-doc", doc);
});

// EVENT: Button show cooking stage select modal
$(document).on('click', '#btnSaveCookingStageSelect', function () {
    let CookingStageValue = $('#CookStageSelection').val();
    let parameters = {
        DocNumber: $(this).attr("data-doc"),
        SKUCode: paramSKU,
        CookingStage: CookingStageValue
    }

    try {
        if (CookingStageValue) {
            $.ajax({
                type: "POST",
                url: "frmWIPOUTV2.aspx/SaveNewCookingStage",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: '{_data:' + JSON.stringify(parameters) + '}',
                success: function (data) {
                    GetCookingStage(dataCount, isDisabled, doc);
                },
                error: function (error) {
                    Message("Error", error.responseJSON.Message, "error");
                }
            });
        }
        else {
            Message("", "No selected cooking stage", "info");
        }
    } catch (e) {
        Message("Error", e, "error");
    }
});

// EVENT: Button save cooking stage
$(document).on('click', '#btnSaveCookingStage', async function () {
    let rowCooking = $('#DTbl2 tbody tr');
    let arrayDataCooking = [];

    await Promise.all($.map(rowCooking, async (tr, trindex) => {
        let objects = {}
        await Promise.all($.map($(tr).find("td"), async (td, tdindex) => {
            let obj = $(td).find("input, select");

            objects[$(obj).attr("data-id")] = $(obj).attr("data-id") != "BatchNo" ? $(obj).val() : $(obj).val().join();

            objects = Object.assign(objects);
        }));

        arrayDataCooking.push(objects);
        console.log('cooking data');
        console.log(arrayDataCooking);
    }));

    $.ajax({
        type: "POST",
        url: "frmWIPOUTV2.aspx/SaveCooking",
        data: '{ _data:' + JSON.stringify(arrayDataCooking) + '}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            Message("Success", "Data has been saved", "success");
            GetData(generated);

            $('#CookingStageModal').modal("toggle");
        },
        error: function (error) {
            Message("Error", error.responseJSON.Message, "error");
        }
    });
});

$(document).on('click', '#btnNewSaveCookingStage', async function () {
    let rowCooking = $('#DTbl3 tbody tr');
    let arrayDataCooking = [];

    await Promise.all($.map(rowCooking, async (tr, trindex) => {
        let objects = {}
        await Promise.all($.map($(tr).find("td"), async (td, tdindex) => {
            let obj = $(td).find("input, select");

            objects[$(obj).attr("data-id")] = $(obj).attr("data-id") != "BatchNo" ? $(obj).val() : $(obj).val().join();

            objects = Object.assign(objects);
        }));

        arrayDataCooking.push(objects);
    }));

    $.ajax({
        type: "POST",
        url: "frmWIPOUTV2.aspx/SaveCooking",
        data: '{ _data:' + JSON.stringify(arrayDataCooking) + '}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            Message("Success", "Data has been saved", "success");
            GetData(generated);

            $('#NewCookingStageModal').modal("toggle");
        },
        error: function (error) {
            Message("Error", error.responseJSON.Message, "error");
        }
    });
});

$(document).on('click', '#btnNewSaveCookingStage2', async function () {
    let rowCooking = $('#DTbl3 tbody tr');
    let arrayDataCooking = [];

    await Promise.all($.map(rowCooking, async (tr, trindex) => {
        let objects = {}
        await Promise.all($.map($(tr).find("td"), async (td, tdindex) => {
            let obj = $(td).find("input, select");

            objects[$(obj).attr("data-id")] = $(obj).attr("data-id") != "BatchNo" ? $(obj).val() : $(obj).val().join();

            objects = Object.assign(objects);
        }));

        arrayDataCooking.push(objects);
    }));

    $.ajax({
        type: "POST",
        url: "frmWIPOUTV2.aspx/SaveCooking",
        data: '{ _data:' + JSON.stringify(arrayDataCooking) + '}',
        contentType: "application/json; charset=utf-8",
        dataType: "json"
    });
});

$(document).on('click', '#addNewBatch', async function () {
    swalWithBootstrapButtons2.fire({
        title: "Create New Batch",
        text: "Do you want to continue?",
        icon: "info",
        showCancelButton: true,
    }).then(async (result) => {
        if (result.isConfirmed) {
            let parameters = {
                Action: "CreateBatch",
                DocNumber: $(this).attr("data-doc"),
                ProductionDate: paramDate,
                SKUCode: paramSKU,
                StepCode: paramStep,
            }

            $.ajax({
                type: "POST",
                url: "frmWIPOUTV2.aspx/SP_Call",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: '{_data:' + JSON.stringify(parameters) + '}',
                success: function () {
                    Message("Success", "New batch created", "success");
                    DT.ajax.reload();
                },
                error: function (error) {
                    Message("Error", error.responseJSON.Message, "error");
                }
            });

        }
    });
});


            // EVENT: Button close cooking stage
            $(document).on('click', '#btnClose', async function () {
                let rowCooking = $('#DTbl2 tbody tr');
                let arrayDataCooking = [];

                await Promise.all($.map(rowCooking, async (tr, trindex) => {
                    let objects = {}
                    await Promise.all($.map($(tr).find("td"), async (td, tdindex) => {
                        let obj = $(td).find("input, select");

                objects[$(obj).attr("data-id")] = $(obj).attr("data-id") != "BatchNo" ? $(obj).val() : $(obj).val().join();

                objects = Object.assign(objects);
            }));

            arrayDataCooking.push(objects);
            console.log('cooking data');
            console.log(arrayDataCooking);
            }));

            $.ajax({
                type: "POST",
                url: "frmWIPOUTV2.aspx/CloseCookingStage",
                data: '{ _data:' + JSON.stringify(arrayDataCooking) + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    //Message("Success", "Data has been saved", "success");
                    //GetData(generated);

                    //$('#CookingStageModal').modal("toggle");
                },
                error: function (error) {
                    Message("Error", error.responseJSON.Message, "error");
                }
            });
            });
$(document).on('click', '#btnViewSendData', async function () {
    $('#ViewSendDataModal').modal('toggle');
    ViewForSendToPortal();
});


$(document).on('click', '#btnViewSentData', async function () {
    $('#ViewSentDataModal').modal('toggle');
    ViewSentToPortal();
});

$(document).on('change', '.timeEnd', async function () {
    let val = $(this).val();

    $(this).closest('tr').next().find('.timeStart').val(val);
});


$(".btnicn").click(function () {
    $("#ViewICNModal").modal('hide');
});
// EVENTS END   


// FUNCTIONS START

// FUNCTION: Select2 selected value
function templateSelection(result) {
    return result.id;
}

// FUNCTION: Select2 UI
function templateResult(result) {
    var $result = $(
        '<div class="row m-0 p-0">' +
        '<div class="col-md-12 m-0 p-0">' + result.text + '</div>' +
        '</div>'
    );
    return $result;
}
function templateResult2(result) {
    var $result = $(
        '<div class="row m-0 p-0">' +
        '<div class="col-md-4 m-0 p-0">' + result.id + '</div>' +
        '<div class="col-md-8 m-0 p-0">' + result.text + '</div>' +
        '</div>'
    );
    return $result;
}

// FUNCTION: Select2 search
function matchStart(params, data) {
    // If there are no search terms, return all of the data
    if ($.trim(params.term) === '') return data;

    // Do not display the item if there is no 'text' property
    if (typeof data.text === 'undefined') return null;

    // `params.term` is the user's search term
    // `data.id` should be checked against
    // `data.text` should be checked against
    var q = params.term.toLowerCase();
    if (data.text.toLowerCase().indexOf(q) > -1 || data.id.toLowerCase().indexOf(q) > -1) return $.extend({}, data, true);

    // Return `null` if the term should not be displayed
    return null;
}

// FUNCTION: Fetch and setup parameters data
function Parameters() {
    $.ajax({
        type: "POST",
        url: "frmWIPOUTV2.aspx/Parameter",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            dataN = JSON.parse(data.d[0]);
            table = "<option value='Code' disabled='disabled'>Description</option><option ></option>";

            dataN.forEach((obj) => {
                table += "<option value='" + obj.Code + "'>" + obj.Name + "</option>";
            });

            $('#paramSKU').append(table);

            $('#paramSKU').select2({
                width: "200px",
                placeholder: "Select a SKU",
                dropdownCssClass: "dropdowncss",
                templateResult: templateResult2,
                templateSelection: templateSelection,
                matcher: matchStart
            });

            dataN = JSON.parse(data.d[1]);
            table = "<option value='Code' disabled='disabled'>Description</option><option></option>";

            dataN.forEach((obj) => {
                table += "<option value='" + obj.Code + "'>" + obj.Name + "</option>";
            });

            $('#paramStep').append(table);

            $('#paramStep').select2({
                width: "200px",
                placeholder: "Select a Step",
                dropdownCssClass: "dropdowncss",
                templateResult: templateResult,
                templateSelection: templateSelection,
                matcher: matchStart
            });
        },
        error: function (error) {
            swalWithBootstrapButtons.fire({
                title: "Error",
                text: error,
                icon: "error"
            });
        }

    });
}

// FUCNTION: View Button
function View(generate = false) {
    let date = new Date(paramDate);

    let parameters = {
        ProductionDate: paramDate,
        SKUCode: paramSKU,
        StepCode: paramStep,
        Action: "Status"
    }

    let title = !generate ? 'Gathering data' : 'Generating data';

    Swal.fire({
        title,
        html: 'Please wait...',
        timer: 2000,
        didOpen: () => {
            Swal.showLoading();

    $.ajax({
        type: "POST",
        url: "frmWIPOUTV2.aspx/SP_Call",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: '{_data:' + JSON.stringify(parameters) + '}',
        success: function (data) {
            let result = JSON.parse(data.d);

            generated = result.length > 0 ? result[0].generated : 0;
            submitted = result.length > 0 ? result[0].submitted : 0;
            cancelled = result.length > 0 ? result[0].cancelled : 0;
            initsubmitted = result.length > 0 ? result[0].Initsubmitted : 0;
            userfound = result.length > 0 ? result[0].UserFound : 0;
            console.log(userfound);
            if (generated == 0 && submitted == 0 && cancelled == 0) {
                GetData(generated);

                $('#btnGenerate').removeAttr("disabled");
                $('#btnSave').attr("disabled", "disabled");
                $('#btnSubmit').attr("disabled", "disabled");
                $('#btnCancel').attr("disabled", "disabled");

                $("#final").html("The Production Date [" + moment(date).format('L') + "], SKU [" + paramSKU + "], Step [" + paramStep + "] is not generated").removeAttr("class").addClass("badge badge-danger-lighten");

                //paramStep == "FG Dispatch" ? $('#btnSendToPortal').removeAttr("disabled") : $('#btnSendToPortal').attr("disabled", "disabled");
            }
            else if (generated != 0 && submitted == 0 && cancelled == 0) {
                GetData(generated);

                $('#btnGenerate').attr("disabled", "disabled");
                $('#btnSave').removeAttr("disabled");
                $('#btnSubmit').removeAttr("disabled");
                $('#btnCancel').removeAttr("disabled");
                $('#btnPrint').removeAttr("disabled") 
                console.log('dito naman');
                paramStep == "FG Dispatch" || paramStep == "Weighing" || paramStep == "Cooking" ? $('#btnPrint').removeAttr("disabled") : $('#btnPrint').attr("disabled", "disabled");
                $("#final").html("The Production Date [" + moment(date).format('ll') + "], SKU [" + paramSKU + "], Step [" + paramStep + "] is generated").removeAttr("class").addClass("badge badge-info-lighten");
            }
            else if (submitted != 0) {
                GetData(generated);

                $('#btnGenerate').attr("disabled", "disabled");
                $('#btnSave').attr("disabled", "disabled");
                $('#btnSubmit').attr("disabled", "disabled");
                $('#btnCancel').attr("disabled", "disabled");
                $('#btnPrint').removeAttr("disabled");

                $("#final").html("The Production Date [" + moment(date).format('ll') + "], SKU [" + paramSKU + "], Step [" + paramStep + "] is already been submitted on [" + moment(result[0].SubmittedDate).format('ll') + "]").removeAttr("class").addClass("badge badge-success-lighten");

                paramStep == "FG Dispatch" ? $('#btnSendToPortal').removeAttr("disabled") : $('#btnSendToPortal').attr("disabled", "disabled");
               
            }
            else if (cancelled != 0) {
                GetData(generated);

                $('#btnGenerate').attr("disabled", "disabled");
                $('#btnSave').attr("disabled", "disabled");
                $('#btnSubmit').attr("disabled", "disabled");
                $('#btnCancel').attr("disabled", "disabled");

                $("#final").html("The Production Date [" + moment(date).format('ll') + "], SKU [" + paramSKU + "], Step [" + paramStep + "] is already been cancelled on [" + moment(result[0].CancelledDate).format('ll') + "]").removeAttr("class").addClass("badge badge-danger-lighten");
            }
  

            $('#btnView').attr("disabled", "disabled");
                  
        },
                error: function (error) {
                    Message("Error", error.responseJSON.Message, "error");
                }
            });
        }
    });

    $.ajax({
        type: "POST",
        url: "frmWIPOUTV2.aspx/SendToPortalLimit",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            limit = JSON.parse(data.d[0]);
        }
    });
}

// FUNCTION: Get Data
    function GetData(isGenerated) {
     
    if ($.fn.DataTable.isDataTable('#DTbl')) {
        $('#DTbl').DataTable().destroy();
        $('#DTbl').empty();
    }

    isDisabled = (generated == 0 || submitted == 1) ? "disabled='disabled'" : "";
    paramStep == "Cooking" ? $('#DTbl2').parent().removeClass('d-none') : $('#DTbl2').parent().addClass('d-none');

    //paramStep == "FG Dispatch" ? $('#btnSendToPortal').removeClass("d-none") : $('#btnSendToPortal').addClass("d-none");
    paramStep == "FG Dispatch" ? $('#btnViewSentData').removeClass('d-none') : $('#btnViewSentData').addClass('d-none');
    paramStep == "FG Dispatch" ? $('#btnViewSendData').removeClass('d-none') : $('#btnViewSentData').addClass('d-none');
    // WIP IN
    if (paramStep == "Weighing") {
        $.ajax({
            type: "POST",
            url: "frmWIPOUTV2.aspx/GetShift",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                steps = JSON.parse(data.d[0]);
            }
        });

            DT = $('#DTbl').DataTable({
                processing: true,
                serverSide: true,
                paging: false,
                searching: false,
                scrollX: false,
                info: false,
                ajax: {
                    url: "frmWIPOUTV2.aspx/SP_Call",
                    type: "POST",
                    contentType: "application/json",
                    dataType: "json",
                    data: function (d) {
                        let date = new Date(paramDate);
                        let parameters = {
                            Year: date.getFullYear(),
                            WorkWeek: date.getWeek(),
                            DayNo: date.getDay(),
                            ProductionDate: paramDate,
                            SKUCode: paramSKU,
                            StepCode: paramStep
                        }
                        d._data = parameters;
                        return JSON.stringify(d);
                    },
                    dataSrc: function (res) {
                        return JSON.parse(res.d);
                    },
                },
                columns: [
                    {
                        title: "",
                        data: "RecordID",
                        orderable: false,
                        width: "0px",
                        render: function (d) {
                            return "<input class='editable d-none' type='text' value='" + d + "' data-id='RecordID'/>";
                        }
                    },
                    {
                        title: "",
                        data: "DocNumber",
                        orderable: false,
                        width: "0px",
                        render: function (d) {
                            return "<input class='editable d-none' type='text' value='" + d + "' data-id='DocNumber' />";
                        }
                    },
                    {
                        title: "Batch Number",
                        orderable: false,
                        data: "BatchNo",
                        render: function (d) {
                            let val = d ? d : "";
                            let editable = (val != "" || submitted == 1) ? "disabled='disabled'" : "";
                            return "<input class='editable form-control form-control-sm' " + editable + " type='text' value='" + val + "' data-id='BatchNo' />";
                        }
                    },
                    {
                        title: "Stuffing Machine Used",
                        orderable: false,
                        data: "StuffingMachineUsed",
                        render: function (d) {
                            return "<input class='editable form-control form-control-sm' type='number' min='0' step='1' " + isDisabled + " value='" + d + "' data-id='StuffingMachineUsed' />";
                        }
                    },
                    {
                        title: "No of Strands",
                        orderable: false,
                        data: "NoStrands",
                        render: function (d) {
                            return "<input class='editable form-control form-control-sm' type='number' min='0' step='1' " + isDisabled + " value='" + d + "' data-id='NoStrands' />";
                        }
                    },
                    {
                        title: "Weight of Smokecart",
                        orderable: false,
                        data: "WeightSmokecart",
                        render: function (d) {
                            return "<input class='editable form-control form-control-sm' type='number' min='0' step='0.1' " + isDisabled + " value='" + d + "' data-id='WeightSmokecart' />";
                        }
                    },
                    {
                        title: "Weight Before Cooking",
                        orderable: false,
                        data: "WeightBeforeCooking",
                        render: function (d) {
                            return "<input class='editable form-control form-control-sm' type='number' min='0' step='0.1' " + isDisabled + " value='" + d + "' data-id='WeightBeforeCooking' />";
                        }
                    },
                    {
                        title: "Shift",
                        orderable: false,
                        data: "Shift",
                        width: "150px",
                        render: function (d) {
                            stepOpt = "<option value='Code' disabled='disabled'>Description</option><option></option>";

                            steps.forEach((obj) => {
                                let selected = obj.Code == d ? "selected='selected'" : "";
                                stepOpt += "<option value='" + obj.Code + "' " + selected + ">" + obj.Name + "</option>";
                            });

                            return "<select class='editable shift form-control form-control-sm' style='width:150px' " + isDisabled + " value='" + d + "' data-id='Shift'>" + stepOpt + "</select>";
                        }
                    },
                    {
                        title: "Checked By",
                        orderable: false,
                        data: "CheckedBy",
                        render: function (d) {
                            let val = d ? d : "";
                            return "<input class='editable form-control form-control-sm CheckedBy' type='text' disabled='disabled' value='" + val + "' data-id='CheckedBy' />";
                        }
                    },
                    {
                        title: "Stick Properly Arranged",
                        orderable: false,
                        data: "StickProperlyArranged",
                        render: function (d) {
                            let val = d == 1 ? "checked='checked'" : "";
                            return "<input class='editable form-control form-control-sm' type='checkbox' " + isDisabled + " " + val + " data-id='StickProperlyArranged' />";
                        }
                    },
                    {
                        title: "Free From Unlink/Untwist",
                        orderable: false,
                        data: "FreeFromUnlinkUntwist",
                        render: function (d) {
                            let val = d == 1 ? "checked='checked'" : "";
                            return "<input class='editable form-control form-control-sm' type='checkbox' " + isDisabled + " " + val + " data-id='FreeFromUnlinkUntwist' />";
                        }
                    },
                    {
                        title: "Hotdog Arranged Properly",
                        orderable: false,
                        data: "HotdogArrangedProperly",
                        render: function (d) {
                            let val = d == 1 ? "checked='checked'" : "";
                            return "<input class='editable form-control form-control-sm' type='checkbox' " + isDisabled + " " + val + " data-id='HotdogArrangedProperly' />";
                        }
                    },
                    {
                        title: "Remarks",
                        orderable: false,
                        data: "Remarks",
                        width: "250px",
                        render: function (d) {
                            let val = d ? d : "";
                            return "<input class='editable form-control form-control-sm' type='text'style='width:150px' " + isDisabled + " value='" + val + "' data-id='Remarks' />";
                        }
                    }
                ],
                initComplete: function () {
                    let api = this.api();
                    dataCount = api.rows().data().length;

                    if (isGenerated == 0 && dataCount > 0) Message("", "Data is not yet created", "info");
                    if (dataCount == 0) {
                        Message("Empty", "No data available", "info");
                        $('#btnGenerate').attr("disabled", "disabled");
                    } 

                    $('.shift').select2({
                        width: "150px",
                        placeholder: "Select a Shift",
                        dropdownCssClass: "dropdowncss",
                        templateResult: templateResult2,
                        templateSelection: templateSelection,
                        matcher: matchStart
                    });

                    $('#DTbl').find("th:first").html("<button id='addNewBatch' type='button' class='btn btn-sm btn-success' data-doc='" + api.rows().data()[0].DocNumber + "'><i class='mdi mdi-plus'></i></button>");
                }
            });
    }
    else if (paramStep == "Spiral Freezing") {
        $.ajax({
            type: "POST",
            url: "frmWIPOUTV2.aspx/GetShift",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                steps = JSON.parse(data.d[0]);
                stepOpt = "<option value='Code' disabled='disabled'>Description</option><option></option>";

                steps.forEach((obj) => {
                    stepOpt += "<option value='" + obj.Code + "'>" + obj.Name + "</option>";
                });
            }
        });

        DT = $('#DTbl').DataTable({
            processing: true,
            serverSide: true,
            paging: false,
            searching: false,
            scrollX: false,
            info: false,
            ajax: {
                url: "frmWIPOUTV2.aspx/SP_Call",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: function (d) {
                    let date = new Date(paramDate);
                    let parameters = {
                        Year: date.getFullYear(),
                        WorkWeek: date.getWeek(),
                        DayNo: date.getDay(),
                        ProductionDate: paramDate,
                        SKUCode: paramSKU,
                        StepCode: paramStep
                    }
                    d._data = parameters;
                    return JSON.stringify(d);
                },
                dataSrc: function (res) {
                    return JSON.parse(res.d);
                },
            },
            columns: [
                {
                    title: "",
                    data: "RecordID",
                    orderable: false,
                    width: "0px",
                    render: function (d) {
                        return "<input class='editable d-none' type='text' value='" + d + "' data-id='RecordID'/>";
                    }
                },
                {
                    title: "",
                    data: "DocNumber",
                    orderable: false,
                    width: "0px",
                    render: function (d) {
                        return "<input class='editable d-none' type='text' value='" + d + "' data-id='DocNumber' />";
                    }
                },
                {
                    title: "Batch Number",
                    orderable: false,
                    data: "BatchNo",
                    render: function (d) {
                        let val = d ? d : "";
                        let editable = (val != "" && submitted == 0) ? "disabled='disabled'" : "";
                        return "<input class='editable form-control form-control-sm' " + editable + " type='text' value='" + val + "' data-id='BatchNo' />";
                    }
                },
                //{
                //    title: "Spiral Machine Used",
                //    orderable: false,
                //    data: "SpiralMachineUsed",
                //    render: function (d) {
                //        return "<input class='editable form-control form-control-sm' type='number' min='0' " + isDisabled + " value='" + d + "' data-id='SpiralMachineUsed' />";
                //    }
                //},
                {
                    title: "Machine Speed",
                    orderable: false,
                    data: "MachineSpeed",
                    render: function (d) {
                        return "<input class='editable form-control form-control-sm' type='number' min='0' " + isDisabled + " value='" + d + "' data-id='MachineSpeed' />";
                    }
                },
                {
                    title: "No of Packs",
                    orderable: false,
                    data: "NoPacks",
                    render: function (d) {
                        return "<input class='editable form-control form-control-sm' type='number' min='0' " + isDisabled + " value='" + d + "' data-id='NoPacks' />";
                    }
                },
                {
                    title: "IT Prior Loading",
                    orderable: false,
                    data: "ITPriorLoading",
                    render: function (d) {
                        return "<input class='editable form-control form-control-sm' type='number' min='0' " + isDisabled + " value='" + d + "' data-id='ITPriorLoading' />";
                    }
                },
                {
                    title: "No Loose Packs",
                    orderable: false,
                    data: "NoLoosePacks",
                    render: function (d) {
                        return "<input class='editable form-control form-control-sm' type='number' min='0' " + isDisabled + " value='" + d + "' data-id='NoLoosePacks' />";
                    }
                },
                {
                    title: "Shift",
                    orderable: false,
                    data: "Shift",
                    width: "150px",
                    render: function (d) {
                        stepOpt = "<option value='Code' disabled='disabled'>Description</option><option></option>";

                        steps.forEach((obj) => {
                            let selected = obj.Code == d ? "selected='selected'" : "";
                            stepOpt += "<option value='" + obj.Code + "' " + selected + ">" + obj.Name + "</option>";
                        });

                        return "<select class='editable shift form-control form-control-sm' style='width:150px' " + isDisabled + " value='" + d + "' data-id='Shift'>" + stepOpt + "</select>";
                    }
                },
                {
                    title: "Time Started",
                    orderable: false,
                    data: "TimeStarted",
                    render: function (d) {
                        let val = d ? d : "";
                        return "<input class='editable form-control form-control-sm time' onkeypress='timeFormat(this)' type='text' placeholder='HH:MM' MaxLength='5' " + isDisabled + " value='" + val + "' data-id='TimeStarted' />";
                        //let val = d == null ? "" : moment().format("HH:mm");
                        //return "<input class='editable form-control form-control-sm' type='time' " + isDisabled + " value='" + val + "' data-id='TimeStarted' />";
                    }
                },
                {
                    title: "Time Finished",
                    orderable: false,
                    data: "TimeFinished",
                    render: function (d) {
                        let val = d ? d : "";
                        return "<input class='editable form-control form-control-sm time' onkeypress='timeFormat(this)' type='text' placeholder='HH:MM' MaxLength='5' " + isDisabled + " value='" + val + "' data-id='TimeFinished' />";
                        //let val = d == null ? "" : moment().format("HH:mm");
                        //return "<input class='editable form-control form-control-sm' type='time' " + isDisabled + " value='" + val + "' data-id='TimeFinished' />";
                    }
                },
                {
                    title: "RoomTemp",
                    orderable: false,
                    data: "RoomTemp",
                    render: function (d) {
                        return "<input class='editable form-control form-control-sm' type='number' min='-45' " + isDisabled + " value='" + d + "' data-id='RoomTemp' />";
                    }
                },
                {
                    title: "SpiralTemp QA",
                    orderable: false,
                    data: "SpiralTempQA",
                    render: function (d) {
                        let val = d == 1 ? "checked='checked'" : "";
                        return "<input class='editable form-control form-control-sm' type='number' min='-45' " + isDisabled + " value='" + d + "' data-id='SpiralTempQA' />";
                    }
                },
                {
                    title: "IT Prior Loading QA",
                    orderable: false,
                    data: "ITPriorLoadingQA",
                    render: function (d) {
                        let val = d ? d : "";
                        return "<input class='editable form-control form-control-sm' type='number min='0' step='1' " + isDisabled + " value='" + val + "' data-id='ITPriorLoadingQA' />";
                    }
                },
                {
                    title: "Remarks",
                    orderable: false,
                    data: "Remarks",
                    width: "250px",
                    render: function (d) {
                        let val = d ? d : "";
                        return "<input class='editable form-control form-control-sm' type='text'style='width:150px' " + isDisabled + " value='" + val + "' data-id='Remarks' />";
                    }
                },
                {
                    title: "Checked By",
                    orderable: false,
                    data: "CheckedBy",
                    render: function (d) {
                        let val = d ? d : "";
                        return "<input class='editable form-control form-control-sm CheckedBy' type='text' disabled='disabled' value='" + val + "' data-id='CheckedBy' />";
                    }
                }
            ],
            initComplete: function (dt) {
                let api = this.api();
                let dataCount = api.rows().data().length;

                if (isGenerated == 0 && dataCount > 0) Message("", "Data is not yet created", "info");
                if (dataCount == 0) {
                    Message("Empty", "No data available", "info");
                    $('#btnGenerate').attr("disabled", "disabled");
                } 

                $('.shift').select2({
                    width: "150px",
                    placeholder: "Select a Shift",
                    dropdownCssClass: "dropdowncss",
                    templateResult: templateResult2,
                    templateSelection: templateSelection,
                    matcher: matchStart
                });

                $('#DTbl').find("th:first").html("<button id='addNewBatch' type='button' class='btn btn-sm btn-success' data-doc='" + api.rows().data()[0].DocNumber + "'><i class='mdi mdi-plus'></i></button>");
            }
        });
    }
    else if (paramStep == "Blast Freezing") {
        $.ajax({
            type: "POST",
            url: "frmWIPOUTV2.aspx/GetShift",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                steps = JSON.parse(data.d[0]);
                stepOpt = "<option value='Code' disabled='disabled'>Description</option><option></option>";

                steps.forEach((obj) => {
                    stepOpt += "<option value='" + obj.Code + "'>" + obj.Name + "</option>";
                });
            }
        });

        DT = $('#DTbl').DataTable({
            processing: true,
            serverSide: true,
            paging: false,
            searching: false,
            scrollX: false,
            info: false,
            ajax: {
                url: "frmWIPOUTV2.aspx/SP_Call",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: function (d) {
                    let date = new Date(paramDate);
                    let parameters = {
                        Year: date.getFullYear(),
                        WorkWeek: date.getWeek(),
                        DayNo: date.getDay(),
                        ProductionDate: paramDate,
                        SKUCode: paramSKU,
                        StepCode: paramStep
                    }
                    d._data = parameters;
                    return JSON.stringify(d);
                },
                dataSrc: function (res) {
                    return JSON.parse(res.d);
                },
            },
            columns: [
                {
                    title: "",
                    data: "RecordID",
                    orderable: false,
                    width: "0px",
                    render: function (d) {
                        return "<input class='editable d-none' type='text' value='" + d + "' data-id='RecordID'/>";
                    }
                },
                {
                    title: "",
                    data: "DocNumber",
                    orderable: false,
                    width: "0px",
                    render: function (d) {
                        return "<input class='editable d-none' type='text' value='" + d + "' data-id='DocNumber' />";
                    }
                },
                {
                    title: "Batch Number",
                    orderable: false,
                    data: "BatchNo",
                    render: function (d) {
                        let val = d ? d : "";
                        let editable = (val != "" && submitted == 0) ? "disabled='disabled'" : "";
                        return "<input class='editable form-control form-control-sm' " + editable + " type='text' value='" + val + "' data-id='BatchNo' />";
                    }
                },
                {
                    title: "No of Packs",
                    orderable: false,
                    data: "NoPacks",
                    render: function (d) {
                        return "<input class='editable form-control form-control-sm' type='number' min='0' step='1' " + isDisabled + " value='" + d + "' data-id='NoPacks' />";
                    }
                },
                {
                    title: "LoadedBy",
                    orderable: false,
                    data: "LoadedBy",
                    render: function (d) {
                        let val = d ? d : "";
                        return "<input class='editable form-control form-control-sm' type='text' " + isDisabled + " value='" + val + "' data-id='LoadedBy' />";
                    }
                },
                {
                    title: "Time Switched ON",
                    orderable: false,
                    data: "TimeSwitchedON",
                    render: function (d) {
                        let val = d ? d : "";
                        return "<input class='editable form-control form-control-sm time' onkeypress='timeFormat(this)' type='text' placeholder='HH:MM' MaxLength='5' " + isDisabled + " value='" + val + "' data-id='TimeSwitchedON' />";
                    }
                },
                {
                    title: "Time Switched OFF",
                    orderable: false,
                    data: "TimeSwitchedOFF",
                    render: function (d) {
                        let val = d ? d : "";
                        return "<input class='editable form-control form-control-sm time' onkeypress='timeFormat(this)' type='text' placeholder='HH:MM' MaxLength='5' " + isDisabled + " value='" + val + "' data-id='TimeSwitchedOFF' />";
                    }
                },
                {
                    title: "Blast Temp",
                    orderable: false,
                    data: "BlastTemp",
                    render: function (d) {
                        return "<input class='editable form-control form-control-sm' type='number' min='-45' " + isDisabled + " value='" + d + "' data-id='BlastTemp' />";
                    }
                },
                {
                    title: "Boxed By",
                    orderable: false,
                    data: "BoxedBy",
                    render: function (d) {
                        let val = d ? d : "";
                        return "<input class='editable form-control form-control-sm' type='text' " + isDisabled + " value='" + val + "' data-id='BoxedBy' />";
                    }
                },
                {
                    title: "Remarks",
                    orderable: false,
                    data: "Remarks",
                    render: function (d) {
                        let val = d ? d : "";
                        return "<input class='editable form-control form-control-sm' type='text'style='width:150px' " + isDisabled + " value='" + val + "' data-id='Remarks' />";
                    }
                },
                {
                    title: "Shift",
                    orderable: false,
                    data: "Shift",
                    render: function (d) {
                        stepOpt = "<option value='Code' disabled='disabled'>Description</option><option></option>";

                        steps.forEach((obj) => {
                            let selected = obj.Code == d ? "selected='selected'" : "";
                            stepOpt += "<option value='" + obj.Code + "' " + selected + ">" + obj.Name + "</option>";
                        });

                        return "<select class='editable shift form-control form-control-sm' style='width:150px' " + isDisabled + " value='" + d + "' data-id='Shift'>" + stepOpt + "</select>";
                    }
                }
            ],
            initComplete: function () {
                let api = this.api();
                dataCount = api.rows().data().length;

                if (isGenerated == 0 && dataCount > 0) Message("", "Data is not yet created", "info");
                if (dataCount == 0) {
                    Message("Empty", "No data available", "info");
                    $('#btnGenerate').attr("disabled", "disabled");
                } 

                $('.shift').select2({
                    width: "150px",
                    placeholder: "Select a Shift",
                    dropdownCssClass: "dropdowncss",
                    templateResult: templateResult2,
                    templateSelection: templateSelection,
                    matcher: matchStart
                });

                $('#DTbl').find("th:first").html("<button id='addNewBatch' type='button' class='btn btn-sm btn-success' data-doc='" + api.rows().data()[0].DocNumber + "'><i class='mdi mdi-plus'></i></button>");
            }
        });
    }
    // WIP OUT
else if (paramStep == "Cooking") {
    console.log('test');
    BatchCooking = [];
        $.ajax({
            type: "POST",
            url: "frmWIPOUTV2.aspx/GetCookingSelects",
            contentType: "application/json; charset=utf-8",
            data: '{_data: ' + JSON.stringify({ SKUCode: paramSKU}) + '}',
            dataType: "json",
            success: function (data) {
                steps = JSON.parse(data.d[0]);
                stepOpt = "<option value='Code' disabled='disabled'>Description</option><option></option>";

                steps.forEach((obj) => {
                    stepOpt += "<option value='" + obj.Code + "'>" + obj.Name + "</option>";
                });

                cooking = JSON.parse(data.d[1]);
                cookingOpt = "<option value='Code' disabled='disabled'>Description</option><option></option>";

                cooking.forEach((obj) => {
                    cookingOpt += "<option value='" + obj.Code + "'>" + obj.Name + "</option>";
                });

                cookingStage = JSON.parse(data.d[2]);
                cookingStageOpt = "<option value='Code' disabled='disabled'>Description</option><option></option>";

                cookingStage.forEach((obj) => {
                    cookingStageOpt += "<option value='" + obj.Code + "'>" + obj.Name + "</option>";
                });
            }
        });

        DT = $('#DTbl').DataTable({
            processing: true,
            serverSide: true,
            paging: false,
            searching: false,
            scrollX: false,
            info: false,
            ajax: {
                url: "frmWIPOUTV2.aspx/SP_Call",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: function (d) {
                    let date = new Date(paramDate);
                    let parameters = {
                        Year: date.getFullYear(),
                        WorkWeek: date.getWeek(),
                        DayNo: date.getDay(),
                        ProductionDate: paramDate,
                        SKUCode: paramSKU,
                        StepCode: paramStep
                    }
                    d._data = parameters;
                    return JSON.stringify(d);
                },
                dataSrc: function (res) {
                    return JSON.parse(res.d);
                },
            },
            columns: [
                {
                    title: "",
                    data: "BatchNo",
                    orderable: false,
                    width: "5%",
                    render: function (d, type, row, meta) {
                        let viewDisabled = (submitted == 1 || generated == 1) ? "" : "disabled='disabled'"
                        return '<button type="button" class="btn btn-sm btn-info ml-2 actionBtn btnViewCookingStage" ' + viewDisabled + 'data-batchno="' + d + '" data-docno="' + row.DocNumber +'"><i class="mdi mdi-magnify"></i></button>' +
                            '<button type="button" class="btn btn-sm btn-danger ml-2 actionBtn btnEditCookingStage" ' + isDisabled + ' data-batchno="' + d + '" data-docno="' + row.DocNumber +'"><i class="mdi mdi-pencil"></i></button>' +
                            '<button type="button" class="btn btn-sm btn-success ml-2 actionBtn btnAddCookingStage d-none" ' + isDisabled + ' data-batchno="' + d + '" data-docno="' + row.DocNumber +'"><i class="mdi mdi-plus"></i></button>';
                    }
                },
                {
                    title: "",
                    data: "Rerun",
                    orderable: false,
                    width: "0px",
                    render: function (d) {
                        return "<input class='editable d-none' type='text' value='" + d + "' data-id='Rerun'/>";
                    }
                },
                {
                    title: "",
                    data: "RecordID",
                    orderable: false,
                    width: "0px",
                    render: function (d) {
                        return "<input class='editable d-none' type='text' value='" + d + "' data-id='RecordID'/>";
                    }
                },
                {
                    title: "",
                    data: "DocNumber",
                    orderable: false,
                    width: "0px",
                    render: function (d) {
                        return "<input class='editable d-none' type='text' value='" + d + "' data-id='DocNumber' />";
                    }
                },
                {
                    title: "Batch Number",
                    orderable: false,
                    data: "BatchNo",
                    render: function (d) {
                        let val = d ? d : "";
                        let editable = (val != "" && submitted == 0) ? "disabled='disabled'" : "";
                        return "<input class='editable form-control form-control-sm' " + editable + " type='text' value='" + val + "' data-id='BatchNo' />";
                    }
                },
                {
                    title: "Smokehouse No",
                    orderable: false,
                    data: "SmokeHouseNo",
                    render: function (d) {
                        return "<input class='editable form-control form-control-sm smokehouseno' type='number' min='0' " + isDisabled + " value='" + d + "' data-id='SmokeHouseNo' />";
                    }
                },
                {
                    title: "Shift",
                    orderable: false,
                    data: "Shift",
                    render: function (d) {
                        stepOpt = "<option value='Code' disabled='disabled'>Description</option><option></option>";

                        steps.forEach((obj) => {
                            let selected = obj.Code == d ? "selected='selected'" : "";
                            stepOpt += "<option value='" + obj.Code + "' " + selected + ">" + obj.Name + "</option>";
                        });

                        return "<select class='editable shift form-control form-control-sm' style='width:150px' " + isDisabled + " value='" + d + "' data-id='Shift'>" + stepOpt + "</select>";
                    }
                },
                {
                    title: "IT After Cooking",
                    orderable: false,
                    data: "ITAfterCooking",
                    render: function (d) {
                        return "<input class='editable form-control form-control-sm itaftercooking' min='0' type='number' " + isDisabled + " value='" + d + "' data-id='ITAfterCooking' />";
                    }
                },
                {
                    title: "Weight After Cooking",
                    orderable: false,
                    data: "WeightAfterCooking",
                    render: function (d) {
                        return "<input class='editable form-control form-control-sm' min='0' type='number' " + isDisabled + " value='" + d + "' data-id='WeightAfterCooking' />";
                    }
                },
                {
                    title: "IT Validation QA",
                    orderable: false,
                    data: "ITValidationQA",
                    render: function (d) {
                        return "<input class='editable form-control form-control-sm itvalidationqa' min='0' type='number' " + isDisabled + " value='" + d + "' data-id='ITValidationQA' />";
                    }
                },
                {
                    title: "Monitored By",
                    orderable: false,
                    data: "MonitoredBy",
                    render: function (d) {
                        let val = d ? d : "";
                        return "<input class='editable form-control form-control-sm' type='text' disabled='disabled' value='" + val + "' data-id='MonitoredBy' />";
                    }
                }
            ],
            initComplete: function (dt) {
                let api = this.api();
                dataCountCooking = api.rows().data().length;

                if (isGenerated == 0 && dataCountCooking > 0) Message("", "Data is not yet created", "info");
                if (dataCountCooking == 0) {
                    Message("Empty", "No data available", "info");
                    $('#btnGenerate').attr("disabled", "disabled");
                } 
                else {
                    $('.shift').select2({
                        width: "200px",
                        placeholder: "Select a Shift",
                        dropdownCssClass: "dropdowncss",
                        templateResult: templateResult2,
                        templateSelection: templateSelection,
                        matcher: matchStart
                    });
                    var row = api.rows().data();
                 
                 
         
                    for (var i = 0; i <= dataCountCooking - 1; i++) {
                       
                        BatchNum = row[i].BatchNo;
                        BatchCooking.push(BatchNum);
                    }
                 
            
                    $('#CookStageSelection').html(cookingStageOpt);

                    $('#CookStageSelection').select2({
                        width: "200px",
                        placeholder: "Select a cooking stage",
                        dropdownCssClass: "dropdowncss",
                        templateResult: templateResult,
                        templateSelection: templateSelection,
                        matcher: matchStart
                    });
                }

                $('#DTbl').find("th:first").html("<button id='addNewBatch' type='button' class='btn btn-sm btn-success' data-doc='" + api.rows().data()[0].DocNumber + "'><i class='mdi mdi-plus'></i></button>");
            }
        });
    }
    else if (paramStep == "FG Dispatch") {
        submitted == 1 ? $('#SAPNo').attr('disabled', 'disabled') : $('#SAPNo').removeAttr('disabled');

        let parameters = {
            ProductionDate: paramDate,
            SKUCode: paramSKU
        }

        $.ajax({
            type: "POST",
            url: "frmWIPOUTV2.aspx/GetFGDispatch",
            contentType: "application/json; charset=utf-8",
            data: '{_data:' + JSON.stringify(parameters) + '}',
            dataType: "json",
            success: function (data) {
                customerCode = JSON.parse(data.d[0]);
                warehouseCode = JSON.parse(data.d[1]);
                itemCode = JSON.parse(data.d[2]);
                steps = JSON.parse(data.d[3]);
                let SAPNo = JSON.parse(data.d[4]).length > 0 ? JSON.parse(data.d[4])[0].SAPNo : "";

                $('#SAPNo').val(SAPNo);
            }
        });

        DT = $('#DTbl').DataTable({
            processing: true,
            serverSide: true,
            paging: false,
            searching: false,
            scrollX: false,
            info: false,
            ajax: {
                url: "frmWIPOUTV2.aspx/SP_Call",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: function (d) {
                    let date = new Date(paramDate);
                    let parameters = {
                        Year: date.getFullYear(),
                        WorkWeek: date.getWeek(),
                        DayNo: date.getDay(),
                        ProductionDate: paramDate,
                        SKUCode: paramSKU,
                        StepCode: paramStep
                    }
                    d._data = parameters;
                    return JSON.stringify(d);
                },
                dataSrc: function (res) {
                    return JSON.parse(res.d);
                },   
            },
            columns: [
                {
                    title: "",
                    data: "RecordID",
                    orderable: false,
                    width: "0px",
                    render: function (d) {
                        return "<input class='editable d-none' type='text' value='" + d + "' data-id='RecordID'/>";
                    }
                },
                {
                    title: "",
                    data: "PortalSent",
                    orderable: false,
                    width: "0px",
                    render: function (d) {
                        return "<input class='editable d-none PortalSent' type='text' value='" + d + "' data-id='PortalSent'/>";
                    }
                },
                {
                    title: "",
                    data: "DocNumber",
                    orderable: false,
                    width: "0px",
                    render: function (d) {
                        return "<input class='editable d-none' type='text' value='" + d + "' data-id='DocNumber' />";
                    }
                },
                {
                    title: "Batch No",
                    data: "BatchNo",
                    orderable: false,
                    render: function (d) {
                        let val = d ? d : "";
                        let editable = (val != "" && submitted == 0) ? "disabled='disabled'" : "";
                        return "<input class='editable form-control form-control-sm' " + editable + " type='text' value='" + val + "' data-id='BatchNo' />";
                    }
                },
                {
                    title: "Pallet Number",
                    orderable: false,
                    data: "PalletNumber",
                    render: function (d, type, row, meta) {
                        let val = d ? d : "";
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                       
                        return "<input class='editable form-control form-control-sm' type='text' " + isDisabled + " value='" + val + "' data-id='PalletNumber' />";
                    }
                },
                {
                    title: "No. of box per batch",
                    orderable: false,
                    data: "NoBoxPerBatch",
                    render: function (d, type, row, meta) {
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : "";
                        isDisabled = (initsubmitted == 0) ? "" : isDisabled;
                        isDisabled = (userfound == 0) ? "disabled='disabled'" : isDisabled;
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? isDisabled : "";
                        return "<input class='editable form-control form-control-sm calculate1' type='number' min='0' " + isDisabled + " value='" + d + "' data-id='NoBoxPerBatch' />";
                    }
                },
                {
                    title: "No. of packs per box",
                    orderable: false,
                    data: "NoPacks",
                    render: function (d, type, row, meta) {
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                        return "<input class='editable form-control form-control-sm calculate1' min='0' type='number' " + isDisabled + " value='" + d + "' data-id='NoPacks' />";
                    }
                },
                {
                    title: "Total Packs",
                    orderable: false,
                    data: "TotalPacks",
                    render: function (d, type, row, meta) {
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                        return "<input class='editable form-control form-control-sm totalcalculate1' min='0' type='number' disabled='disabled' value='" + d + "' data-id='TotalPacks' />";
                    }
                },
                {
                    title: "Shift",
                    orderable: false,
                    data: "Shift",
                    render: function (d, type, row, meta) {
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                        stepOpt = "<option value='Code' disabled='disabled'>Description</option><option></option>";

                        steps.forEach((obj) => {
                            let selected = obj.Code == d ? "selected='selected'" : "";
                            stepOpt += "<option value='" + obj.Code + "' " + selected + ">" + obj.Name + "</option>";
                        });

                        return "<select class='editable shift form-control form-control-sm' style='width:150px' " + isDisabled + " value='" + d + "' data-id='Shift'>" + stepOpt + "</select>";
                    }
                },
                {
                    title: "Box Date",
                    orderable: false,
                    data: "BestBeforeDate",
                    render: function (d, type, row, meta) {
                        let val = d ? d : "";
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                        return "<input class='editable form-control form-control-sm' type='date' " + isDisabled + "' value='" + val + "' data-id='BestBeforeDate' />";
                    }
                },
                {
                    title: "Product Name",
                    orderable: false,
                    data: "ProductNameCk",
                    render: function (d, type, row, meta) {
                        let val = d == 1 ? "checked='checked'" : "";
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                        return "<input class='editable form-control form-control-sm' type='checkbox' " + isDisabled + " " + val + " data-id='ProductNameCk' />";
                    }
                },
                {
                    title: "SKU Code",
                    orderable: false,
                    data: "SKUCodeCk",
                    render: function (d, type, row, meta) {
                        let val = d == 1 ? "checked='checked'" : "";
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                        return "<input class='editable form-control form-control-sm' type='checkbox' " + isDisabled + " " + val + " data-id='SKUCodeCk' />";
                    }
                },
                {
                    title: "PD",
                    orderable: false,
                    data: "PDCk",
                    render: function (d, type, row, meta) {
                        let val = d == 1 ? "checked='checked'" : "";
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                        return "<input class='editable form-control form-control-sm' type='checkbox' " + isDisabled + " " + val + " data-id='PDCk' />";
                    }
                },
                {
                    title: "ED",
                    orderable: false,
                    data: "EDCk",
                    render: function (d, type, row, meta) {
                        let val = d == 1 ? "checked='checked'" : "";
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                        return "<input class='editable form-control form-control-sm' type='checkbox' " + isDisabled + " " + val + " data-id='EDCk' />";
                    }
                },
                {
                    title: "Batch No.",
                    orderable: false,
                    data: "BatchNoCk",
                    render: function (d, type, row, meta) {
                        let val = d == 1 ? "checked='checked'" : "";
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                        return "<input class='editable form-control form-control-sm' type='checkbox' " + isDisabled + " " + val + " data-id='BatchNoCk' />";
                    }
                },
                {
                    title: "No. of Packs",
                    orderable: false,
                    data: "NoPacksCk",
                    render: function (d, type, row, meta) {
                        let val = d == 1 ? "checked='checked'" : "";
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                        return "<input class='editable form-control form-control-sm' type='checkbox' " + isDisabled + " " + val + " data-id='NoPacksCk' />";
                    }
                },
                {
                    title: "Box Used",
                    orderable: false,
                    data: "BoxUsed",
                    render: function (d, type, row, meta) {
                        let val = d ? d : "";
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                        return "<input class='editable form-control form-control-sm' type='text' MaxLength='1' " + isDisabled + " value='" + val + "' data-id='BoxUsed' />";
                    }
                },
                {
                    title: "Spiral Machine No.",
                    orderable: false,
                    data: "SpiralMachineUsed",
                    render: function (d, type, row, meta) {
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                        return "<input class='editable form-control form-control-sm' type='number' min='0' " + isDisabled + " value='" + d + "' data-id='SpiralMachineUsed' />";
                    }
                },
                {
                    title: "Blast Machine No.",
                    orderable: false,
                    data: "BlastMachineUsed",
                    render: function (d, type, row, meta) {
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                        return "<input class='editable form-control form-control-sm' type='number' min='0' " + isDisabled + " value='" + d + "' data-id='BlastMachineUsed' />";
                    }
                },
                {
                    title: "Time of Inspection",
                    orderable: false,
                    data: "TimeOfInspection",
                    render: function (d, type, row, meta) {
                        let val = d ? d : "";
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                        return "<input class='editable form-control form-control-sm time' onkeypress='timeFormat(this)' type='text' placeholder='HH:MM' MaxLength='5' " + isDisabled + " value='" + val + "' data-id='TimeOfInspection' />";
                    }
                },
                {
                    title: "Remarks",
                    orderable: false,
                    data: "Remarks",
                    render: function (d, type, row, meta) {
                        let val = d ? d : "";
                        isDisabled = (row.IsSubmitted == 1 || isGenerated == 0) ? "disabled='disabled'" : ""; 
                        return "<input class='editable form-control form-control-sm exclude' type='text' " + isDisabled + " value='" + val + "' data-id='Remarks' />";
                    }
                },
            ],
            initComplete: function (dt) {
                let api = this.api();
                let dataCount = api.rows().data().length;

                if (isGenerated == 0 && dataCount > 0) Message("", "Data is not yet created", "info");
                if (dataCount == 0) {
                    Message("Empty", "No data available", "info");
                    $('#btnGenerate').attr("disabled", "disabled");
                }
                else {
                    $('.shift').select2({
                        width: "200px",
                        placeholder: "Select data",
                        dropdownCssClass: "dropdowncss",
                        templateResult: templateResult2,
                        templateSelection: templateSelection,
                        matcher: matchStart
                    });
                }
            
                isAllSubmitted = true;
                isSendToPortal = false;

                api.rows().data().each(function (obj) {
                    if (!$(obj)[0].IsSubmitted) isAllSubmitted = false;
                    if ($(obj)[0].IsSubmitted && !$(obj)[0].PortalSent) isSendToPortal = true;
                });
              
                if (!isAllSubmitted) $('#btnSubmit').removeAttr("disabled");
                if (!isAllSubmitted) $('#btnSave').removeAttr("disabled");
                isSendToPortal ? $('#btnSendToPortal').removeAttr("disabled") : $('#btnSendToPortal').attr("disabled", "disabled");

                $('#DTbl').find("th:first").html("<button id='addNewBatch' type='button' class='btn btn-sm btn-success' data-doc='" + api.rows().data()[0].DocNumber+"'><i class='mdi mdi-plus'></i></button>");
           
            }
        });
    }
    // SCRAP Generation
    else if (paramStep == "SG Brine Chilling" || paramStep == "SG Packaging" || paramStep == "SG Cooking") {
        let noWidth = "";

        if (paramStep == "SG Brine Chilling") noWidth = "0px";

        $.ajax({
            type: "POST",
            url: "frmWIPOUTV2.aspx/GetSGSelects",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                steps = JSON.parse(data.d[0]);
                stepOpt = "<option value='Code' disabled='disabled'>Description</option><option></option>";

                steps.forEach((obj) => {
                    stepOpt += "<option value='" + obj.Code + "'>" + obj.Name + "</option>";
                });

                scraps = JSON.parse(data.d[1]);
                scrapOpt = "<option value='Code' disabled='disabled'>Description</option><option></option>";

                scraps.forEach((obj) => {
                    scrapOpt += "<option value='" + obj.Code + "'>" + obj.Name + "</option>";
                });
            }
        });

        DT = $('#DTbl').DataTable({
            processing: true,
            serverSide: true,
            paging: false,
            searching: false,
            scrollX: false,
            info: false,
            ajax: {
                url: "frmWIPOUTV2.aspx/SP_Call",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: function (d) {
                    let date = new Date(paramDate);
                    let parameters = {
                        Year: date.getFullYear(),
                        WorkWeek: date.getWeek(),
                        DayNo: date.getDay(),
                        ProductionDate: paramDate,
                        SKUCode: paramSKU,
                        StepCode: paramStep
                    }
                    d._data = parameters;
                    return JSON.stringify(d);
                },
                dataSrc: function (res) {
                    return JSON.parse(res.d);
                },
            },
            columns: [
                {
                    title: "",
                    data: "RecordID",
                    orderable: false,
                    width: "0px",
                    render: function (d) {
                        return "<input class='editable d-none' type='text' value='" + d + "' data-id='RecordID'/>";
                    }
                },
                {
                    title: "",
                    data: "DocNumber",
                    orderable: false,
                    width: "0px",
                    render: function (d) {
                        return "<input class='editable d-none' type='text' value='" + d + "' data-id='DocNumber' />";
                    }
                },
                {
                    title: "Batch Number",
                    orderable: false,
                    data: "BatchNo",
                    width: noWidth,
                    render: function (d) {
                        let val = d ? d : "";
                        let editable = (val != "" && submitted == 0) ? "disabled='disabled'" : "";
                        return "<input class='editable form-control form-control-sm' " + editable + " type='text' value='" + val + "' data-id='BatchNo' />";
                    }
                },
                {
                    title: "Shift",
                    orderable: false,
                    data: "Shift",
                    render: function (d) {
                        stepOpt = "<option value='Code' disabled='disabled'>Description</option><option></option>";

                        steps.forEach((obj) => {
                            let selected = obj.Code == d ? "selected='selected'" : "";
                            stepOpt += "<option value='" + obj.Code + "' " + selected + ">" + obj.Name + "</option>";
                        });

                        return "<select class='editable shift form-control form-control-sm' style='width:100px' " + isDisabled + " value='" + d + "' data-id='Shift'>" + stepOpt + "</select>";
                    }
                },
                {
                    title: "Scrap Code",
                    orderable: false,
                    data: "ScrapCode",
                    render: function (d) {
                        scrapOpt = "<option value='Code' disabled='disabled'>Description</option><option></option>";

                        scraps.forEach((obj) => {
                            let selected = obj.Code == d ? "selected='selected'" : "";
                            scrapOpt += "<option value='" + obj.Code + "' " + selected + ">" + obj.Name + "</option>";
                        });

                        return "<select class='editable shift form-control form-control-sm' style='width:100px' " + isDisabled + " value='" + d + "' data-id='ScrapCode'>" + scrapOpt + "</select>";
                    }
                },
                {
                    title: "Unlink/Untwist",
                    orderable: false,
                    data: "UnlinkUntwist",
                    render: function (d) {
                      
                        isDisabled = (initsubmitted == 0) ? "" : isDisabled;
                        isDisabled = (userfound == 0) ? "disabled='disabled'" : isDisabled;
                        
                        return "<input class='editable form-control form-control-sm UnlinkUnTwist calculate' min='0' type='number' " + isDisabled + " value='" + d + "' data-id='UnlinkUnTwist' />";
                    }
                },
                {
                    title: "Miscut",
                    orderable: false,
                    data: "Miscut",
                    render: function (d) {
                        return "<input class='editable form-control form-control-sm Miscut calculate' min='0' type='number' " + isDisabled + " value='" + d + "' data-id='Miscut' />";
                    }
                },
                {
                    title: "Deform",
                    orderable: false,
                    data: "Deform",
                    render: function (d) {
                        let val = d ? d : "";
                        return "<input class='editable form-control form-control-sm Deform calculate' min='0' type='number' " + isDisabled + " value='" + d + "' data-id='Deform' />";
                    }
                },
                {
                    title: "Others",
                    orderable: false,
                    data: "Others",
                    render: function (d) {
                        return "<input class='editable form-control form-control-sm Others calculate' min='0' type='number' " + isDisabled + " value='" + d + "' data-id='Others' />";
                    }
                },
                {
                    title: "Total Reject Scrap",
                    orderable: false,
                    data: "TotalRejectScrap",
                    render: function (d) {
                        return "<input class='editable form-control form-control-sm TotalRejectScrap calculatetotal' min='0' type='number' disabled='disabled' value='" + d + "' data-id='TotalRejectScrap' />";
                    }
                },
                {
                    title: "Total Fallen",
                    orderable: false,
                    data: "TotalFallen",
                    render: function (d) {
                        return "<input class='editable form-control form-control-sm' min='0' type='number' " + isDisabled + " value='" + d + "' data-id='TotalFallen' />";
                    }
                },
                {
                    title: "Remarks",
                    orderable: false,
                    data: "Remarks",
                    render: function (d) {
                        let val = d ? d : "";
                        return "<input class='editable form-control form-control-sm' type='text' " + isDisabled + " value='" + val + "' data-id='Remarks' />";
                    }
                }
            ],
            initComplete: function (dt) {
                let api = this.api();
                let dataCount = api.rows().data().length;

                if (isGenerated == 0 && dataCount > 0) Message("", "Data is not yet created", "info");

                if (dataCount == 0) {
                    Message("Empty", "No data available", "info");
                    $('#btnGenerate').attr("disabled", "disabled");
                }

                $('.shift').select2({
                    width: "150px",
                    placeholder: "Select a Shift",
                    dropdownCssClass: "dropdowncss",
                    templateResult: templateResult2,
                    templateSelection: templateSelection,
                    matcher: matchStart
                });
                console.log(userfound);
                if (userfound != 0) $('#btnSubmit').removeAttr("disabled");
                if (userfound != 0) $('#btnSave').removeAttr("disabled");

                $('#DTbl').find("th:first").html("<button id='addNewBatch' type='button' class='btn btn-sm btn-success' data-doc='" + api.rows().data()[0].DocNumber + "'><i class='mdi mdi-plus'></i></button>");
            }
        });
    }
}

// FUNCTION: Get Cooking Stage Data
function GetCookingStage(count, isDisabled, batchNo, smokehouseNo, ITAfterCooking, ITValidationQA, doc, cooking, Rerun=null) {
    DTCookingStage = $('#DTbl2').DataTable({
        processing: true,
        serverSide: true,
        paging: false,
        searching: false,
        scrollX: false,
        info: false,
        destroy: true,
        ajax: {
            url: "frmWIPOUTV2.aspx/SP_Call",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: function (d) {
                let date = new Date(paramDate);
                let parameters = {
                    Year: date.getFullYear(),
                    WorkWeek: date.getWeek(),
                    DayNo: date.getDay(),
                    ProductionDate: paramDate,
                    SKUCode: paramSKU,
                    StepCode: paramStep,
                    Action2: cooking,
                    BatchNo: batchNo,
                    SmokeHouseNo: smokehouseNo,
                    ITAfterCooking: ITAfterCooking,
                    ITValidationQA: ITValidationQA,
                    DocNumber: doc,
                    Rerun
                }
                d._data = parameters;
                return JSON.stringify(d);
            },
            dataSrc: function (res) {
                return JSON.parse(res.d);
            },
        },
        columns: [
            {
                title: "",
                data: null,
                orderable: false,
                width: "5%",
                render: function (d) {
                    return "";
                }
            },
            {
                title: "",
                data: "Rerun",
                width: "0px",
                render: function (d) {
                    return "<input class='editable d-none' type='text' value='" + d + "' data-id='Rerun'/>";
                }
            },
            {
                title: "",
                data: "RecordID",
                orderable: false,
                width: "0px",
                render: function (d) {
                    return "<input class='editable d-none' type='text' value='" + d + "' data-id='RecordID'/>";
                }
            },
            {
                title: "",
                data: "DocNumber",
                orderable: false,
                width: "0px",
                render: function (d) {
                    return "<input class='editable d-none' type='text' value='" + d + "' data-id='DocNumber' />";
                }
            },
            {
                title: "",
                orderable: false,
                data: "SmokehouseNo",
                width: "0px",
                render: function (d) {
                    gSmokeHouseNo = d;
                    return "<input class='editable form-control form-control-sm smokehouseno d-none' type='number' value='" + d + "' data-id='SmokeHouseNo' />";
                }
            },
            {
                title: "",
                orderable: false,
                data: "ITAfterCooking",
                width: "0px",
                render: function (d) {
                    gITAfterCooking = d;
                    return "<input class='editable form-control form-control-sm itaftercooking d-none' type='number' value='" + d + "' data-id='ITAfterCooking' />";
                }
            },
            {
                title: "",
                orderable: false,
                data: "ITValidationQA",
                width: "0px",
                render: function (d) {
                    gITValidationQA = d;
                    return "<input class='editable form-control form-control-sm itvalidationqa d-none' type='number' value='" + d + "' data-id='ITValidationQA' />";
                }
            },
            {
                title: "",
                orderable: false,
                data: "BatchNo",
                width: "0px",
                render: function (d) {
                    console.log(d);

                    d=(d == null) ? d:'"'+d.replace(/,/g, '","')+'"';

                    console.log(d);
                    let opts = (d != null && d != "") ? "[" + d.split(',') + "]" : []
                    BatchOpt = "<option disabled='disabled'>Batch No</option><option value=''></option>";
                    console.log(opts);
          
                    //console.log(BatchCooking.length);
                    for (var i = 0; i <= count -1; i++) {
                        //console.log(BatchCooking[i]);
                        let isSelected = isEqual(opts, BatchCooking[i]) ? "selected='selected'" : "";
                        BatchOpt += "<option value='" + BatchCooking[i] + "' " + isSelected + ">" + BatchCooking[i] + "</option>";
                    }

                    return "<select class='editable batch form-control form-control-sm d-none' style='width:0px' " + isDisabled + " value='" + d + "' data-id='BatchNo' multiple='multiple'>" + BatchOpt + "</select>";
                }
            },
            {
                title: "Cooking Stage",
                orderable: false,
                data: "CookingStage",
                render: function (d) {
                    let val = d ? d : "";
                    return "<input class='editable form-control form-control-sm' type='text' disabled='disabled' value='" + val + "' data-id='CookingStage' />";
                }
            },
            {
                title: "Standard Cooking Time",
                orderable: false,
                data: "StdCookingTime",
                render: function (d) {
                    let val = d ? d : "";
                    return "<input class='editable form-control form-control-sm' onkeypress='timeFormat(this)' type='text' placeholder='HH:MM' MaxLength='5' disabled='disabled' value='" + val + "' data-id='StdCookingTime' />";
                }
            },
            {
                title: "Time Start",
                orderable: false,
                data: "TimeStart",
                render: function (d) {
                    let val = d ? d : "";
                    return "<input class='editable form-control form-control-sm time timeStart' onkeypress='timeFormat(this)' type='text' placeholder='HH:MM' MaxLength='5' " + isDisabled + " value='" + val + "' data-id='TimeStart' />";
                    //return "<input class='editable form-control form-control-sm' type='time' " + isDisabled + " value='" + d + "' data-id='TimeStart' />";
                }
            },
            {
                title: "Time End",
                orderable: false,
                data: "TimeEnd",
                render: function (d) {
                    let val = d ? d : "";
                    return "<input class='editable form-control form-control-sm time timeEnd' onkeypress='timeFormat(this)' type='text' placeholder='HH:MM' MaxLength='5' " + isDisabled + " value='" + val + "' data-id='TimeEnd' />";
                    //return "<input class='editable form-control form-control-sm' type='time' " + isDisabled + " value='" + d + "' data-id='TimeEnd' />";
                }
            },
            {
                title: "Stove Temp Standard",
                orderable: false,
                data: "StoveTempStd",
                render: function (d) {
                    return "<input class='editable form-control form-control-sm' min='0' type='number' disabled='disabled' value='" + d + "' data-id='StoveTempStd' />";
                }
            },
            {
                title: "Stove Temp Actual",
                orderable: false,
                data: "StoveTempActual",
                render: function (d) {
                    return "<input class='editable form-control form-control-sm' min='0' type='number' " + isDisabled + " value='" + d + "' data-id='StoveTempActual' />";
                }
            },
            {
                title: "Percent Humidity Standard",
                orderable: false,
                data: "PercentHumidityStd",
                render: function (d) {
                    return "<input class='editable form-control form-control-sm' min='0' type='number' disabled='disabled' value='" + d + "' data-id='PercentHumidityStd' />";
                }
            },
            {
                title: "Percent Humidity Actual",
                orderable: false,
                data: "PercentHumidityActual",
                render: function (d) {
                    return "<input class='editable form-control form-control-sm' min='0' type='number' " + isDisabled + " value='" + d + "' data-id='PercentHumidityActual' />";
                }
            },
        ],
        initComplete: function (dt) {
            let api = this.api();
            dataCount = api.rows().data().length;

            $('.batch').select2({
                width: "200px",
                placeholder: "Select a batch",
                dropdownCssClass: "dropdowncss",
                templateResult: templateResult,
                templateSelection: templateSelection,
                matcher: matchStart
            });
         
            //console.log(BatchOpt);
            $('#CookingStageBatch').html(BatchOpt).trigger('change');

            isDisabled != "" ? $('#CookingStageBatch').attr("disabled", "disabled") : $('#CookingStageBatch').removeAttr("disabled");
            isDisabled != "" ? $('#btnSaveCookingStage').addClass("d-none") : $('#btnSaveCookingStage').removeClass("d-none");

            if (isDisabled != "") $('#CookingStageSmokehouse').val(gSmokeHouseNo);
        }
    });
}

function GetCookingStage2(count, isDisabled, doc, newbatch = null) {
    DTCookingStage2 = $('#DTbl3').DataTable({
        processing: true,
        serverSide: true,
        paging: false,
        searching: false,
        scrollX: false,
        info: false,
        destroy: true,
        ajax: {
            url: "frmWIPOUTV2.aspx/SP_Call",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: function (d) {
                let date = new Date(paramDate);
                let parameters = {
                    Year: date.getFullYear(),
                    WorkWeek: date.getWeek(),
                    DayNo: date.getDay(),
                    ProductionDate: paramDate,
                    SKUCode: paramSKU,
                    StepCode: paramStep,
                    Action2: 'CookingStage2'
                }
                d._data = parameters;
                return JSON.stringify(d);
            },
            dataSrc: function (res) {
                return JSON.parse(res.d);
            },
        },
        columns: [
            {
                title: "",
                data: null,
                orderable: false,
                width: "5%",
                render: function (d) {
                    return "";
                }
            },
            {
                title: "",
                data: "RecordID",
                orderable: false,
                width: "0px",
                render: function (d) {
                    return "<input class='editable d-none' type='text' value='" + d + "' data-id='RecordID'/>";
                }
            },
            {
                title: "",
                data: "DocNumber",
                orderable: false,
                width: "0px",
                render: function (d) {
                    return "<input class='editable d-none' type='text' value='" + d + "' data-id='DocNumber' />";
                }
            },
            {
                title: "",
                orderable: false,
                data: "BatchNo",
                width: "0px",
                render: function (d) {
                    let val = d == null ? "" : d;
                    val = newbatch != null ? newbatch : val;
                    let opts = val.length > 0 ? "[" + val.split(',') + "]" : [];

                    BatchOpt = "<option disabled='disabled'>Batch No</option><option value=''></option>";

                    for (var i = 1; i <= count; i++) {
                        let isSelected = opts.indexOf(i) > 0 ? "selected='selected'" : "";

                        BatchOpt += "<option value='" + i + "' " + isSelected + ">" + i + "</option>";
                    }

                    return "<select class='editable batch form-control form-control-sm d-none' style='width:0px' " + isDisabled + " value='" + d + "' data-id='BatchNo' multiple='multiple'>" + BatchOpt + "</select>";
                }
            },
            {
                title: "Cooking Stage",
                orderable: false,
                data: "CookingStage",
                render: function (d) {
                    let val = d ? d : "";
                    return "<input class='editable form-control form-control-sm' type='text' disabled='disabled' value='" + val + "' data-id='CookingStage' />";
                }
            },
            {
                title: "Standard Cooking Time",
                orderable: false,
                data: "StdCookingTime",
                render: function (d) {
                    let val = d ? d : "";
                    return "<input class='editable form-control form-control-sm' onkeypress='timeFormat(this)' type='text' placeholder='HH:MM' MaxLength='5' disabled='disabled' value='" + val + "' data-id='StdCookingTime' />";
                }
            },
            {
                title: "Time Start",
                orderable: false,
                data: "TimeStart",
                render: function (d) {
                    let val = d ? d : "";
                    return "<input class='editable form-control form-control-sm time' onkeypress='timeFormat(this)' type='text' placeholder='HH:MM' MaxLength='5' " + isDisabled + " value='" + val + "' data-id='TimeStart' />";
                    //return "<input class='editable form-control form-control-sm' type='time' " + isDisabled + " value='" + d + "' data-id='TimeStart' />";
                }
            },
            {
                title: "Time End",
                orderable: false,
                data: "TimeEnd",
                render: function (d) {
                    let val = d ? d : "";
                    return "<input class='editable form-control form-control-sm time' onkeypress='timeFormat(this)' type='text' placeholder='HH:MM' MaxLength='5' " + isDisabled + " value='" + val + "' data-id='TimeEnd' />";
                    //return "<input class='editable form-control form-control-sm' type='time' " + isDisabled + " value='" + d + "' data-id='TimeEnd' />";
                }
            },
            {
                title: "Stove Temp Standard",
                orderable: false,
                data: "StoveTempStd",
                render: function (d) {
                    return "<input class='editable form-control form-control-sm' min='0' type='number' disabled='disabled' value='" + d + "' data-id='StoveTempStd' />";
                }
            },
            {
                title: "Stove Temp Actual",
                orderable: false,
                data: "StoveTempActual",
                render: function (d) {
                    return "<input class='editable form-control form-control-sm' min='0' type='number' " + isDisabled + " value='" + d + "' data-id='StoveTempActual' />";
                }
            },
            {
                title: "Percent Humidity Standard",
                orderable: false,
                data: "PercentHumidityStd",
                render: function (d) {
                    return "<input class='editable form-control form-control-sm' min='0' type='number' disabled='disabled' value='" + d + "' data-id='PercentHumidityStd' />";
                }
            },
            {
                title: "Percent Humidity Actual",
                orderable: false,
                data: "PercentHumidityActual",
                render: function (d) {
                    return "<input class='editable form-control form-control-sm' min='0' type='number' " + isDisabled + " value='" + d + "' data-id='PercentHumidityActual' />";
                }
            },
        ],
        initComplete: function (dt) {
            let api = this.api();
            dataCount = api.rows().data().length;

            $('.batch').select2({
                width: "200px",
                placeholder: "Select a batch",
                dropdownCssClass: "dropdowncss",
                templateResult: templateResult,
                templateSelection: templateSelection,
                matcher: matchStart
            });

            $('#NewCookingStageBatch').html(BatchOpt);
        }
    });
}

// FUNCTION: Generate Data
function Generate() {
    let date = new Date(paramDate);
    let parameters = {
        Year: date.getFullYear(),
        WorkWeek: date.getWeek(),
        DayNo: date.getDay(),
        ProductionDate: paramDate,
        SKUCode: paramSKU,
        StepCode: paramStep,
        Action: "Generate"
    }

    $.ajax({
        type: "POST",
        url: "frmWIPOUTV2.aspx/SP_Call",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: '{_data:' + JSON.stringify(parameters) + '}',
        success: function (data) {
            View(true);
        },
        error: function (error) {
            Message("Error", error.responseJSON.Message, "error");
        }
    });
}



function Checklimit(){
    RecCount = 0
    $('#DTblV0').DataTable().$("input[name='checkOnlyOne']:checked").each(function () {
        RecCount++
    });

    RecCount>0 ? $('#btnSendData').removeAttr("disabled") : $('#btnSendData').attr("disabled", "disabled");
  
    console.log(RecCount);
    console.log(limit[0].Value);

}



// FUNCTION: Save data
async function sendto() {
    //let row = $('#DTblV0 tbody tr');
    //let arrayData = [];

    //let parameters = {
    //    ProductionDate: paramDate,
    //    SKUCode: paramSKU,
    //    StepCode: paramStep,
    //    SAPNo: $('#SAPNo').val()
    //}

    //await Promise.all($.map(row, async (tr, trindex) => {
    //    let objects = {}
        
    //        await Promise.all($.map($(tr).find("td"), async (td, tdindex) => {
    //            let obj = $(td).find("input, select");
    //            console.log((obj).val());
    //            objects[$(obj).attr("data-id")] = $(obj).is("input[type=checkbox]") ? ($(obj).is(":checked") ? (obj).val() : 0) : $(obj).val();
                
    //            objects = Object.assign(objects);
    //        }));

    //        arrayData.push(objects);
        
    //}));

    //console.log(arrayData);

    var docList = [];
    var formattedDocNumber = "";

    $('#DTblV0').DataTable().$("input[name='checkOnlyOne']:checked").each(function () {
        docList.push("'" + $(this).attr('data-docnumber') + "'");
    });

    formattedDocNumber = docList.join(",");
    console.log(docList);


    const Item = {
        RecordID: formattedDocNumber
    }
    swalWithBootstrapButtons2.fire({
                title: "",
                text: "Do you want to continue?",
                icon: "info",
                showCancelButton: true,
                    }).then(async (result) => {
                        if (result.isConfirmed) {
                           

                            if (RecCount > limit[0].Value) {
                                Message("Failed", "Data are exceeded the allowed pallet count", "warning");
                                return; 
                            }

                                    Swal.fire({
                                        title: "Sending Data",
                                        html: 'Please wait...',
                                        //timer: 5000,
                                        didOpen: () => {
                                            Swal.showLoading();

                                    $.ajax({
                                        type: "POST",
                                        url: "frmWIPOUTV2.aspx/SendToPortal",
                                        contentType: "application/json; charset=utf-8",
                                        dataType: "json",
                                        data: '{_data:' + JSON.stringify(Item) + '}',
                                        success: function (data) {
                                            swalWithBootstrapButtons.fire({
                                                title: "",
                                                text: "Data Sent Successfully",
                                                icon: "success",
                                            }).then(async (result) => {
                                                if (result.isConfirmed) {
                                                    ViewForSendToPortal();
                                        }
                                    });
                                },
                                    error: function (error) {
                                        Message("Error", error.responseJSON.Message, "error");
                                    }
                                });
                        }
                });
        }
});


}



// FUNCTION: Save data
async function Save() {
    let row = $('#DTbl tbody tr');
    let arrayData = [];

    let parameters = {
        ProductionDate: paramDate,
        SKUCode: paramSKU,
        StepCode: paramStep,
        SAPNo: $('#SAPNo').val()
    }

    await Promise.all($.map(row, async (tr, trindex) => {
        let objects = {}
        let isIncluded = null

        if (paramStep == "Blast Freezing")
            isIncluded = $(tr).find("td:nth-child(4)").find("input, select").val();
        if (paramStep == "Weighing" || paramStep == "Spiral Freezing"
            || paramStep == "Cooking" || paramStep == "FG Dispatch")
            isIncluded = $(tr).find("td:nth-child(5)").find("input, select").val();
        if (paramStep == "SG Cooking" || paramStep == "SG Brine Chilling"
            || paramStep == "SG Packaging")
            isIncluded = $(tr).find("td:nth-child(6)").find("input, select").val();
            
        if (isIncluded) {
            await Promise.all($.map($(tr).find("td"), async (td, tdindex) => {
                let obj = $(td).find("input, select");

                objects[$(obj).attr("data-id")] = $(obj).is("input[type=checkbox]") ? ($(obj).is(":checked") ? 1 : 0) : $(obj).val();

                objects = Object.assign(objects);
            }));

            arrayData.push(objects);
        }
    }));

    Swal.fire({
        title: "Saving Data",
        html: 'Please wait...',
        didOpen: () => {
            Swal.showLoading();

            $.ajax({
                type: "POST",
                url: "frmWIPOUTV2.aspx/Save",
                data: '{ _d:' + JSON.stringify(parameters) + ', _data:' + JSON.stringify(arrayData) + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: async function (data) {
                    Message("Success", "Data has been saved", "success");
                    GetData(generated);
                },
                error: function (error) {
                    Message("Error", error.responseJSON.Message, "error");
                }
            });
        }
    });
}

// FUNCTION: Submit data
async function Submit() {
    let parameters = {
        ProductionDate: paramDate,
        SKUCode: paramSKU,
        StepCode: paramStep,
        Action: "Submit"
    }

    swalWithBootstrapButtons2.fire({
        title: "Submitting Data",
        text: "Do you want to continue submitting the data?",
        icon: "warning",
        showCancelButton: true,
    }).then(async (result) => {
        if (result.isConfirmed) {
            let required = $('#DTbl input.editable, #DTbl select.editable');
            let pass = true;

            await Promise.all($.map(required, async (obj, index) => {
                // If StepCode is Weighing validate first half of the form.
                if (paramStep == "Weighing") {
                    let ifWeighing = required.length / 4;
                    if (index <= ifWeighing) {
                        if ($(obj).val() == "") {
                            pass = false;

                            ($(obj).is("input") && !$(obj).is("input.CheckedBy") && !$(obj).is("input.exclude")) ?
                                $(obj).addClass("required") :
                                $(obj).siblings("span").find(".select2-selection").addClass("required");
                        }
                    }
                }
                else if (paramStep == "Cooking") {
                    //if ($.fn.DataTable.isDataTable('#DTbl2')) {

                    //    pass = DTCookingStage.data().count() > 0 ? true : false;
                    //}
                    //else {
                    //    pass = false;
                    //}
                }

               

                 else if (paramStep == "FG Dispatch") {
                    var SAPNo = $('#SAPNo').val()
                    pass = SAPNo != '' ? true : false;
                    console.log(SAPNo);
                    console.log(pass);

                }
            }));

            if (pass) {
                Swal.fire({
                    title: "Submitting Data",
                    html: 'Please wait...',
                    //timer: 5000,
                    didOpen: () => {
                        Swal.showLoading();

                        $.ajax({
                            type: "POST",
                            url: "frmWIPOUTV2.aspx/SP_Call",
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            data: '{_data:' + JSON.stringify(parameters) + '}',
                            success: function (data) {
                                let response = JSON.parse(data.d);

                                try {
                                    if (response[0].Success) Message("Success", response[0].Success, "success", false); // Success message
                                    if (response[0].Warning) Message("Warning", response[0].Warning, "warning"); // Warning message
                                } catch (e) {
                                    Message("Error", e, "error");
                                }
                            },
                            error: function (error) {
                                Message("Error", error.responseJSON.Message, "error");
                            }
                        });
                    }
                });
            }
            else if (!pass && paramStep == "Cooking") {
                Message("Cooking table is empty", "Please create a data for cooking stage", "warning");
            }
            else if (!pass && paramStep == "FG Dispatch") {
                Message("SAPNo Field is empty", "Please input SAPNo for Portal Batch Number", "warning");
            }
            else {
                Message("Warning", "Please fill out all required fields", "warning");
            }
            
        }
    });
}

// FUNCTION: Cancel data
function Cancel() {
    let parameters = {
        ProductionDate: paramDate,
        SKUCode: paramSKU,
        StepCode: paramStep,
        Action: "Cancel"
    }

    swalWithBootstrapButtons2.fire({
        title: "Cancelling Data",
        text: "Do you want to continue cancelling the data?",
        icon: "warning",
        showCancelButton: true,
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                type: "POST",
                url: "frmWIPOUTV2.aspx/SP_Call",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: '{_data:' + JSON.stringify(parameters) + '}',
                success: function (data) {
                    let response = JSON.parse(data.d);

                    if (response[0].Success) Message("Success", response[0].Success, "success"); // Success message
                    if (response[0].Warning) Message("Warning", response[0].Warning, "warning"); // Warning message
                },
                error: function (error) {
                    Message("Error", error.responseJSON.Message, "error");
                }
            });
        }
    });
}

// FUNCTION: Send to Portal
function SendToPortal() {
    let parameters = {
        ProductionDate: paramDate,
        SKUCode: paramSKU,
        StepCode: paramStep
    }

    swalWithBootstrapButtons2.fire({
        title: "",
        text: "Do you want to continue?",
        icon: "info",
        showCancelButton: true,
    }).then(async (result) => {
        if (result.isConfirmed) {
            let limitCount = 0;

            DT.rows().data().each(function (obj, i) {
                if ($(obj).PortalSent == 0 || $(obj).PortalSent == null) limitCount++;
            });

            if (limitCount > limit) {
                Message("Failed", "Data are exceeded the allowed pallet count", "warning");
                return; 
            }

            Swal.fire({
                title: "Sending Data",
                html: 'Please wait...',
                //timer: 5000,
                didOpen: () => {
                    Swal.showLoading();

                    $.ajax({
                        type: "POST",
                        url: "frmWIPOUTV2.aspx/SendToPortal",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: '{_data:' + JSON.stringify(parameters) + '}',
                        success: function (data) {
                            swalWithBootstrapButtons.fire({
                                title: "",
                                text: "Data Sent Successfully",
                                icon: "success",
                            }).then(async (result) => {
                                if (result.isConfirmed) {
                                    View();
                                }
                            });
                        },
                        error: function (error) {
                            Message("Error", error.responseJSON.Message, "error");
                        }
                    });
                }
            });
        }
    });
}

//FUNCTION: PRINT
function Print(){
    var PrintName = ''
    var transtype = ''
    var SGStep = ''

    if (paramStep == 'Weighing'){ PrintName = 'CookingMonitoring1'};
    if (paramStep == 'Spiral Freezing'){ PrintName = 'SpiralFreezingMonitoring'};
    if (paramStep == 'Spiral Freezing'){ PrintName = 'SpiralFreezingMonitoring'};
    if (paramStep == 'Blast Freezing'){ PrintName = 'BlastFreezingMonitoring'};
    if (paramStep == 'Cooking'){ PrintName = 'CookingMonitoring2'};
    if (paramStep == 'FG Dispatch'){ PrintName = 'FGDispatchingMonitoring'};
    if (paramStep == 'SG Cooking' || paramStep == 'SG Brine Chilling' || paramStep == 'SG Packaging'){ PrintName = 'HotdogRejectionMonitoring'};

    if (paramStep == 'SG Cooking' || paramStep == 'SG Brine Chilling' || paramStep == 'SG Packaging'){ 
        window.open ('../WebReports/ReportViewer.aspx?val=~GEARS_Printout.P_'+PrintName+'&tag=False&transtype=&txtpd='+paramDate+'&SKUCode='+paramSKU+'&StepC='+paramStep+'');
    }
    else{
        //var today = new Date();
        //var dd = String(today.getDate()).padStart(2, '0');
        //var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        //var yyyy = today.getFullYear();

        //today = mm + '/' + dd + '/' + yyyy;
        //document.write(today);
        window.open ('../WebReports/ReportViewer.aspx?val=~GEARS_Printout.P_'+PrintName+'&tag=False&transtype=&txtpd='+paramDate+'&SKUCode='+paramSKU+'');
    };
  
};


// FUNCTION: View send to Portal
function ViewForSendToPortal() {
    if ($.fn.DataTable.isDataTable('#DTblV0')) {
        $('#DTblV0').DataTable().destroy();
        $('#DTblV0').empty();
    }

    DTV = $('#DTblV0').DataTable({
        processing: true,
        serverSide: true,
        paging: false,
        searching: false,
        scrollX: false,
        info: false,
        ajax: {
            url: "frmWIPOUTV2.aspx/SP_Call",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: function (d) {
                let date = new Date(paramDate);
                let parameters = {
                    Year: date.getFullYear(),
                    WorkWeek: date.getWeek(),
                    DayNo: date.getDay(),
                    ProductionDate: paramDate,
                    SKUCode: paramSKU,
                    StepCode: paramStep,
                    Action: 'ForSend'
                }
                d._data = parameters;
                return JSON.stringify(d);
               
            },
            dataSrc: function (res) {
                return JSON.parse(res.d);
            },
        },
        columns: [
            {
                title: "",
                orderable: false,
                data: "RecordID",
                render: function (d, type, row, meta) {
                    let val = d == 1 ? "checked='checked'" : "";
                    return "<input class='editable form-control form-control-sm' onchange='Checklimit()' name='checkOnlyOne' data-docnumber='"+ d +"' value = '" + d + "' type='checkbox'  " + val + " data-id='RecordID' />";
                }
            },
            {
                title: "PD",
                orderable: false,
                data: "PD"
            },
            {
                title: "SKUCode",
                orderable: false,
                data: "SKUCode"
            },
           
            {
                title: "Batch No",
                orderable: false,
                data: "BatchNo"
            },
            {
                title: "Pallet Number",
                orderable: false,
                data: "PalletNumber"
            },
            {
                title: "No. Box Per Packs",
                orderable: false,
                data: "NoBoxPerBatch"
            },
            {
                title: "No. Packs Per Batch",
                data: "NoPacks",
                orderable: false,
                defaultContent: "-"
            },
            {
                title: "Total Packs",
                data: "TotalPacks",
                orderable: false,
                defaultContent: "-"
            },
            {
                title: "Shift",
                data: "Shift",
                orderable: false,
                defaultContent: "-"
            },
            {
                title: "Box Date",
                orderable: false,
                defaultContent: "-"
            },
            {
                title: "Product Name",
                orderable: false,
                data: "ProductNameCk",
                render: function (d, type, row, meta) {
                    let val = d == 1 ? "checked='checked'" : "";
                    return "<input class='editable form-control form-control-sm' type='checkbox' disabled='disabled' " + val + " data-id='ProductNameCk' />";
                }
            },
            {
                title: "SKU Code",
                orderable: false,
                data: "SKUCodeCk",
                render: function (d, type, row, meta) {
                    let val = d == 1 ? "checked='checked'" : "";
                    return "<input class='editable form-control form-control-sm' type='checkbox' disabled='disabled' " + val + " data-id='SKUCodeCk' />";
                }
            },
            {
                title: "PD",
                orderable: false,
                data: "PDCk",
                render: function (d, type, row, meta) {
                    let val = d == 1 ? "checked='checked'" : "";
                    return "<input class='editable form-control form-control-sm' type='checkbox' disabled='disabled' " + val + " data-id='PDCk' />";
                }
            },
            {
                title: "ED",
                orderable: false,
                data: "EDCk",
                render: function (d, type, row, meta) {
                    let val = d == 1 ? "checked='checked'" : "";
                    return "<input class='editable form-control form-control-sm' type='checkbox' disabled='disabled' " + val + " data-id='EDCk' />";
                }
            },
            {
                title: "Batch No.",
                orderable: false,
                data: "BatchNoCk",
                render: function (d, type, row, meta) {
                    let val = d == 1 ? "checked='checked'" : "";
                    return "<input class='editable form-control form-control-sm' type='checkbox' disabled='disabled' " + val + " data-id='BatchNoCk' />";
                }
            },
            {
                title: "No. of Packs",
                orderable: false,
                data: "NoPacksCk",
                render: function (d, type, row, meta) {
                    let val = d == 1 ? "checked='checked'" : "";
                    isDisabled = (row.IsSubmitted == 1) ? "disabled='disabled'" : "";
                    return "<input class='editable form-control form-control-sm' type='checkbox' disabled='disabled' " + val + " data-id='NoPacksCk' />";
                }
            },
            {
                title: "Box Used",
                orderable: false,
                data: "BoxUsed",
                defaultContent: "-"
            },
            {
                title: "Spiral Machine No.",
                orderable: false,
                data: "SpiralMachineUsed",
                defaultContent: "-"
            },
            {
                title: "Blast Machine No.",
                orderable: false,
                data: "BlastMachineUsed",
                defaultContent: "-"
            },
            {
                title: "Time of Inspection",
                orderable: false,
                data: "TimeOfInspection",
                defaultContent: "-"
            },
            {
                title: "Remarks",
                orderable: false,
                data: "Remarks",
                defaultContent: "-"
            },



        ],
        initComplete: function (dt) {
            $('.actionBtn').attr('disabled', 'disabled');
            $('#btnView').removeAttr('disabled');
            $('#btnSave').removeAttr("disabled");
        }
    });
}




// FUNCTION: View Sent to Portal
function ViewSentToPortal() {
    if ($.fn.DataTable.isDataTable('#DTblV')) {
        $('#DTblV').DataTable().destroy();
        $('#DTblV').empty();
    }

    DTV = $('#DTblV').DataTable({
        processing: true,
        serverSide: true,
        paging: false,
        searching: false,
        scrollX: false,
        info: false,
        ajax: {
            url: "frmWIPOUTV2.aspx/SP_Call",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: function (d) {
                let date = new Date(paramDate);
                let parameters = {
                    Year: date.getFullYear(),
                    WorkWeek: date.getWeek(),
                    DayNo: date.getDay(),
                    ProductionDate: paramDate,
                    SKUCode: paramSKU,
                    StepCode: paramStep,
                    Action: 'FG Dispatch View'
                }
                d._data = parameters;
                return JSON.stringify(d);
            },
            dataSrc: function (res) {
                return JSON.parse(res.d);
            },
        },
        columns: [
            
            {
                title: "SKUCode",
                orderable: false,
                data: "SKUCode"
            },
            {
                title: "ICNNumber",
                orderable: false,
                data: "ICNNumber",
                defaultContent: "-",
                render: function (d, type, row, meta) {
                    let val = d == null ? "" : d;
                    return "<a onclick='ViewDetail(\"" + val + "\"); ' style='text - align: center; cursor: pointer; color: darkblue;'>" + val + "</a>";
                }
            }, 
            {
                title: "Batch No",
                orderable: false,
                data: "BatchNo"
            },
            {
                title: "Pallet Number",
                orderable: false,
                data: "PalletNumber"
            },
            {
                title: "No. Box Per Packs",
                orderable: false,
                data: "NoBoxPerBatch"
            },
            {
                title: "No. Packs Per Batch",
                data: "NoPacks",
                orderable: false,
                defaultContent: "-"
            },
            {
                title: "Total Packs",
                data: "TotalPacks",
                orderable: false,
                defaultContent: "-"
            },
            {
                title: "Shift",
                data: "Shift",
                orderable: false,
                defaultContent: "-"
            },
            {
                title: "Box Date",
                orderable: false,
                defaultContent: "-"
            },
            {
                title: "Product Name",
                orderable: false,
                data: "ProductNameCk",
                render: function (d, type, row, meta) {
                    let val = d == 1 ? "checked='checked'" : "";
                    return "<input class='editable form-control form-control-sm' type='checkbox' disabled='disabled' " + val + " data-id='ProductNameCk' />";
                }
            },
            {
                title: "SKU Code",
                orderable: false,
                data: "SKUCodeCk",
                render: function (d, type, row, meta) {
                    let val = d == 1 ? "checked='checked'" : "";
                    return "<input class='editable form-control form-control-sm' type='checkbox' disabled='disabled' " + val + " data-id='SKUCodeCk' />";
                }
            },
            {
                title: "PD",
                orderable: false,
                data: "PDCk",
                render: function (d, type, row, meta) {
                    let val = d == 1 ? "checked='checked'" : "";
                    return "<input class='editable form-control form-control-sm' type='checkbox' disabled='disabled' " + val + " data-id='PDCk' />";
                }
            },
            {
                title: "ED",
                orderable: false,
                data: "EDCk",
                render: function (d, type, row, meta) {
                    let val = d == 1 ? "checked='checked'" : "";
                    return "<input class='editable form-control form-control-sm' type='checkbox' disabled='disabled' " + val + " data-id='EDCk' />";
                }
            },
            {
                title: "Batch No.",
                orderable: false,
                data: "BatchNoCk",
                render: function (d, type, row, meta) {
                    let val = d == 1 ? "checked='checked'" : "";
                    return "<input class='editable form-control form-control-sm' type='checkbox' disabled='disabled' " + val + " data-id='BatchNoCk' />";
                }
            },
            {
                title: "No. of Packs",
                orderable: false,
                data: "NoPacksCk",
                render: function (d, type, row, meta) {
                    let val = d == 1 ? "checked='checked'" : "";
                    isDisabled = (row.IsSubmitted == 1) ? "disabled='disabled'" : "";
                    return "<input class='editable form-control form-control-sm' type='checkbox' disabled='disabled' " + val + " data-id='NoPacksCk' />";
                }
            },
            {
                title: "Box Used",
                orderable: false,
                data: "BoxUsed",
                defaultContent: "-"
            },
            {
                title: "Spiral Machine No.",
                orderable: false,
                data: "SpiralMachineUsed",
                defaultContent: "-"
            },
            {
                title: "Blast Machine No.",
                orderable: false,
                data: "BlastMachineUsed",
                defaultContent: "-"
            },
            {
                title: "Time of Inspection",
                orderable: false,
                data: "TimeOfInspection",
                defaultContent: "-"
            },
            {
                title: "Remarks",
                orderable: false,
                data: "Remarks",
                defaultContent: "-"
            },
           
            
         
        ],
        initComplete: function (dt) {
            $('.actionBtn').attr('disabled', 'disabled');
            $('#btnView').removeAttr('disabled');
            $('#btnSave').removeAttr("disabled");
        }
    });

}





// FUNCTION: View Sent to Portal
function ViewDetail(ICN) {
    $('#ViewICNModal').modal('toggle');
    if ($.fn.DataTable.isDataTable('#DTblV2')) {
        $('#DTblV2').DataTable().destroy();
        $('#DTblV2').empty();
    }
    console.log(ICN);
    DTV = $('#DTblV2').DataTable({
        processing: true,
        serverSide: true,
        paging: false,
        searching: false,
        scrollX: false,
        info: false,

        ajax: {
            url: "frmWIPOUTV2.aspx/ViewICN",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: function (d) {
             
                let parameters = {
                    ICNNumber: ICN,
                   
                }
                d._data = parameters;
                return JSON.stringify(d);
            },
            dataSrc: function (res) {
                return JSON.parse(res.d);
            },
        },
        columns: [

            {
                title: "DocNumber",
                orderable: false,
                data: "DocNumber"
            },
            
            {
                title: "ItemCode",
                orderable: false,
                data: "ItemCode",
                defaultContent: "-"
            },
            {
                title: "BatchNumber",
                orderable: false,
                data: "BatchNumber",
                defaultContent: "-"
            },
            {
                title: "LotNo",
                orderable: false,
                data: "LotNo",
                defaultContent: "-"
            },
            {
                title: "MfgDate",
                orderable: false,
                data: "MfgDate",
                defaultContent: "-"
            },
            {
                title: "ExpDate",
                orderable: false,
                data: "ExpDate",
                defaultContent: "-"
            },
            {
                title: "Qty",
                orderable: false,
                data: "Qty",
                defaultContent: "-"
            },
            {
                title: "Packing",
                orderable: false,
                data: "Packing",
                defaultContent: "-"
            },
            {
                title: "SpecialHandlingInstruc",
                orderable: false,
                data: "SpecialHandlingInstruc",
                defaultContent: "-"
            },
            {
                title: "CustomerCode",
                orderable: false,
                data: "CustomerCode",
                defaultContent: "-"
            },
            {
                title: "WarehouseCode",
                orderable: false,
                data: "WarehouseCode",
                defaultContent: "-"
            },
            {
                title: "APIStatus",
                orderable: false,
                data: "APIStatus",
                defaultContent: "-"
            },
            {
                title: "ReceivedQty",
                orderable: false,
                data: "ReceivedQty",
                defaultContent: "-"
            },
            {
                title: "UDF01",
                orderable: false,
                data: "UDF01",
                defaultContent: "-"
            },
            {
                title: "UDF02",
                orderable: false,
                data: "UDF02",
                defaultContent: "-"
            },
            {
                title: "MLIRemarks01",
                orderable: false,
                data: "MLIRemarks01",
                defaultContent: "-"
            },
            {
                title: "Weight",
                orderable: false,
                data: "Weight",
                defaultContent: "-"
            },
           
        ],
        initComplete: function (dt) {
            $('.actionBtn').attr('disabled', 'disabled');
            $('#btnView').removeAttr('disabled');
            $('#btnSave').removeAttr("disabled");
        }
    });
}



// FUNCTION: Message notification
function Message(title, text, icon, Nreset = true, html = null) {
    swalWithBootstrapButtons.fire({ title, text, html, icon })
        .then((result) => {
            if (result.isConfirmed)
                if (!Nreset) View();
        });
}

// FUNCTION: Time validation
function timeFormat(input) {
    let intValidNum = input.value;
    let regExp = /^\d+$/;
    let isNumber = regExp.test(intValidNum);

    // Number validation
    if (!isNumber) {
        return false
    }

    // HOUR validation
    if (intValidNum < 24 && intValidNum.length == 2 && isNumber) {
        input.value = intValidNum + ":";
        return false;
    }
    if (intValidNum == 24 && intValidNum.length == 2 && isNumber) {
        input.value = intValidNum.length - 2 + "0:";
        return false;
    }
    if (intValidNum > 24 && intValidNum.length == 2 && isNumber) {
        input.value = "";
        return false;
    }

    // MINUTE validation
    if (intValidNum.length == 5 && intValidNum.slice(-2) < 60 && isNumber) {
        input.value = intValidNum + ":";
        return false;
    }
    if (intValidNum.length == 5 && intValidNum.slice(-2) == 60 && isNumber) {
        input.value = intValidNum.slice(0, 2) + ":00";
        return false;
    }
}   

// FUNCTION: Get week value
Date.prototype.getWeek = function () {
    // Copy date so don't modify original
    let d = new Date(Date.UTC(this.getFullYear(), this.getMonth(), this.getDate()));
    // Set to nearest Thursday: current date + 4 - current day number
    // Make Sunday's day number 7
    d.setUTCDate(d.getUTCDate() + 4 - (d.getUTCDay() || 7));
    // Get first day of year
    let yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
    // Calculate full weeks to nearest Thursday
    let weekNo = Math.ceil((((d - yearStart) / 86400000) + 1) / 7) -1;
    // Return week number
    return weekNo ;
};

const isEqual = (first,second) => {
    console.log("second:"+second);
console.log("first:"+first+"");
    let response = false;
if (first.length > 0) {
    console.log(first);
    //console.log(second);
        JSON.parse(first).forEach(function (obj) {
            console.log("obj:"+obj+"");
            console.log("second:"+second);
           // if(obj=="A") obj='"A"';
            if (('"'+obj+'"') === '"'+second+'"') response = true;
        });
    }

    return response;
}

function Export(tableID, filename = '') {

    var downloadLink;
    var dataType = 'application/vnd.ms-excel';
    var tableSelect = document.getElementById(tableID);

    var tableHTML = tableSelect.outerHTML.replace(/ /g, '%20');

    // Specify file name
    filename = filename ? filename + '.xls' : 'ICNDetail_data.xls';

    // Create download link element
    downloadLink = document.createElement("a");

    document.body.appendChild(downloadLink);

    if (navigator.msSaveOrOpenBlob) {
        var blob = new Blob(['\ufeff', tableHTML], {
            type: dataType
        });
        navigator.msSaveOrOpenBlob(blob, filename);
    } else {
        // Create a link to the file
        downloadLink.href = 'data:' + dataType + ', ' + tableHTML;

        // Setting the file name
        downloadLink.download = filename;

        //triggering the function
        downloadLink.click();
    }
}


function Exportsent(tableID, filename = '') {

    var downloadLink;
    var dataType = 'application/vnd.ms-excel';
    var tableSelect = document.getElementById(tableID);

    var tableHTML = tableSelect.outerHTML.replace(/ /g, '%20');

    // Specify file name
    filename = filename ? filename + '.xls' : 'SentToPortal_data.xls';

    // Create download link element
    downloadLink = document.createElement("a");

    document.body.appendChild(downloadLink);

    if (navigator.msSaveOrOpenBlob) {
        var blob = new Blob(['\ufeff', tableHTML], {
            type: dataType
        });
        navigator.msSaveOrOpenBlob(blob, filename);
    } else {
        // Create a link to the file
        downloadLink.href = 'data:' + dataType + ', ' + tableHTML;

        // Setting the file name
        downloadLink.download = filename;

        //triggering the function
        downloadLink.click();
    }
}


// FUNCTIONS END