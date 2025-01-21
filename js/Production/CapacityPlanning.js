var table;
var table0;
var table1;
var table2;
var childEditors = {};  // Globally track created chid editors
var childTable;
var childTable2;
var generate = 0;
var finalized = 1;
var editor;
var date;
var date2;
var date3;
var Stages = "";
var SKUCodeval = "";
var isMachine = false;
var currDate;

$(document).ready(() => {

    yearParameter(); // Get Year options
    weekParameter(); // Get WeekNo options

    // -- Variables START -- //

    const swalWithBootstrapButtons = Swal.mixin({
        customClass: {
            confirmButton: 'btn btn-success',
            cancelButton: 'btn btn-danger'
        },
        buttonsStyling: false
    });

    const swalWithBootstrapButtons2 = Swal.mixin({
        customClass: {
            confirmButton: 'btn btn-success col-3 ms-3',
            cancelButton: 'btn btn-danger col-3'
        },
        buttonsStyling: false
    });

    // Set Datatable START
    table = $('#masterTableMachine').DataTable({
        paging: false,
        searching: false,
        info: false,
        columnDefs: [
            {
                orderable: false,
                targets: 0,
                width: '5%'
            }
        ],
    });

    table1 = $('#masterTableManpowerSpecific').DataTable({
        paging: false,
        searching: false,
        info: false,
        columnDefs: [
            {
                orderable: false,
                targets: 0,
                width: '5%'
            }
        ]
    });

    table2 = $('#masterTableManpowerGeneral').DataTable({
        paging: false,
        searching: false,
        info: false,
        columnDefs: [
            {
                orderable: false,
                targets: 0,
                width: '5%'
            }
        ]
    });
    // Set Datatable END

    // -- Variables END -- //

    // -- EVENTS START -- // 

    // Capacity Planning For Event Select
    $('#CapacityPlanningFor').change(() => {
        var showID = '#masterTable' + $('#CapacityPlanningFor').find(":selected").val();

        $('.table-responsive').css("display", "none");
        $(showID).closest('.table-responsive').css("display", "block");

        if (showID == "#masterTableMachine") table.columns.adjust().draw();

        if (showID == "#masterTableManpowerSpecific") table1.columns.adjust().draw();

        if (showID == "#masterTableManpowerGeneral") table2.columns.adjust().draw();
    });

    // View Event Select
    $('#view').change(function () {
        console.log('asd');
        var isDay = $(this).val() == "Day" ? "unset" : "none";

        $('#daynoparam').parent().css("display", isDay);
        $('.dayhide').toggleClass("d-none");
    });

    // Parameter Event Select
    $('#yearparam').change(function () {
        $('#paramYear').text($(this).val());

        $('#searchBtn').removeAttr("disabled");
    });

    // Parameter Event Select
    $('#weeknoparam').change(function () {
        $('#paramWorkWeek').text($(this).val());

        $('#searchBtn').removeAttr("disabled");
    });

    // Parameter Event Select
    $('#daynoparam').change(function () {
        $('#paramDayNo').text($(this).val());

        $('#searchBtn').removeAttr("disabled");
    });

    // Search Event Button
    $('#searchBtn').click(function () {
        var paramYear = $('#yearparam').val();
        var paramWorkWeek = $('#weeknoparam').val();
        var paramDayNo = $('#daynoparam').val();
        
        if (paramYear != "" && paramWorkWeek != "") {
            $('#view').val() == "Week" ? statusChecker(paramYear, paramWorkWeek) : statusChecker(paramYear, paramWorkWeek, paramDayNo);
        }
        else {
            swalWithBootstrapButtons.fire({
                title: "",
                text: "No data available",
                icon: "info"
            });
        }
        $(this).attr("disabled", "disabled");
    });

    // Generate Event Button
    $("#generateBtn").click(function () {
        var paramYear = $('#yearparam').val();
        var paramWorkWeek = $('#weeknoparam').val();

        $.ajax({
            url: "frmCapacityPlanning.aspx/SP_Call",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: '{year:' + paramYear + ', workweek:' + paramWorkWeek + ', table:"Generate", dayno:0, skucode:"",generate:"0",stages:""}',
            success: function (data) {
                var data = JSON.parse(data.d);
                console.log(data);
                if (data[0].d.search("error") != -1) {
                    swalWithBootstrapButtons.fire({
                        title: "Error",
                        text: data.d,
                        icon: "error"
                    });
                } else {
                    swalWithBootstrapButtons.fire({
                        title: "Generated Successfully",
                        text: data[0].d,
                        icon: "success"
                    }).then(function (result) {
                        if (result.isConfirmed) {
                            $("#searchBtn").click();
                        }
                    });
                }
            },
            error: function(err) {
                swalWithBootstrapButtons.fire({
                    title: "Error",
                    text: err,
                    icon: "error"
                });
            }
        });
    });

    // Finalize Event Button
    $("#finalizeBtn").click(function () {
        var paramYear = $('#yearparam').val();
        var paramWorkWeek = $('#weeknoparam').val();

        $.ajax({
            url: "frmCapacityPlanning.aspx/SP_Call",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: '{year:' + paramYear + ', workweek:' + paramWorkWeek + ', table:"Finalized", dayno:0, skucode:"",generate:"0",stages:""}',
            success: function (data) {
                var data = JSON.parse(data.d);
                if (data[0].Column1.search("error") != -1) {
                    swalWithBootstrapButtons.fire({
                        title: "Error",
                        text: data.d,
                        icon: "error"
                    });
                } else {
                    swalWithBootstrapButtons.fire({
                        title: "Finalized Successfully",
                        text: data[0].Column1,
                        icon: "success"
                    }).then(function (result) {
                        if (result.isConfirmed) {
                            $("#searchBtn").click();
                        }
                    });
                }
            },
            error: function (err) {
                swalWithBootstrapButtons.fire({
                    title: "Error",
                    text: err,
                    icon: "error"
                });
            }
        });
    });


    // Stages
    $('tbody').on('click', 'td.details-control0', function () {
        var tr = $(this).closest('tr');
        var row = table.row(tr);
        var rowData = row.data();
        var id = 'mt0' + rowData.Stages;
        Stages = rowData.Stages;

        if (row.child.isShown()) {
            // This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');

            // Destroy the Child Datatable
            $('#' + id).DataTable().destroy();
        }
        else {
            machineTable(tr, row, id, Stages);

            tr.addClass('shown');
        }
    });

    // Machine Header
    $('#masterTableMachine tbody').on('click', 'td.details-control', function () {
        var tr = $(this).closest('tr');
        var row = childTable0.row(tr);
        var rowData = row.data();
        var id = $('#view').val() == "Week" ? 'cl' + rowData.MachineType.replaceAll(/\s/g, '') : 'mt' + $('#daynoparam').val();
        SKUCodeval = rowData.MachineType;
        isMachine = true;
        if (row.child.isShown()) {
            // This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');

            // Destroy the Child Datatable
            $('#' + id).DataTable().destroy();
        }
        else {
            if ($('#view').val() == "Week") {
                // Open this row
                row.child(format(id)).show();
                weekly(id, 'details-control1', rowData.MachineType, SKUCodeval);
            }
            else {
                machineDetails(tr, row, id, SKUCodeval, Stages);
            }

            tr.addClass('shown');
        }
    });

    // Machine Details
    $('tbody').on('click', 'td.details-control1', function () {
        var tr = $(this).closest('tr');
        var row = childTable.row(tr);
        var rowData = row.data();
        var id = 'mt' + rowData.Date.split('|')[1]; 
        date = rowData.Date.split('|')[1] + 1;
        machineDetails(tr, row, id, SKUCodeval, Stages);
    });

    // Manpower Specific Header
    $('#masterTableManpowerSpecific tbody').on('click', 'td.details-control', function () {
        var tr = $(this).closest('tr');
        var row = table1.row(tr);
        var rowData = row.data();
        var id = $('#view').val() == "Week" ? 'mp' + rowData.Name.replace(/[^A-Z0-9]/ig, "") : 'mp' + $('#daynoparam').val();
        SKUCodeval = rowData.Name;
        isMachine = false;
        if (row.child.isShown()) {
            // This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');

            // Destroy the Child Datatable
            $('#' + id).DataTable().destroy();
        }
        else {
            // Open this row
            //row.child(format(id)).show();

            //weekly(id, 'details-control2');
            if ($('#view').val() == "Week") {
                // Open this row
                row.child(format(id)).show();
                weekly(id, 'details-control2')
            }
            else {
                specificManpowerDetails(tr, row, rowData, id, $('#daynoparam').val() + 1, SKUCodeval);
            }

            tr.addClass('shown');
        }
    });

    // Manpower Specific Details
    $('tbody').on('click', 'td.details-control2', function () {
        var tr = $(this).closest('tr');
        var row = childTable.row(tr);
        var rowData = row.data();
        var id = 'mp' + rowData.Date.split('|')[1];
        date2 = rowData.Date.split('|')[1] + 1;

        specificManpowerDetails(tr, row, rowData, id, $('#daynoparam').val() + 1, SKUCodeval);
    });

    // Manpower General Header
    $('#masterTableManpowerGeneral tbody').on('click', 'td.details-control', function () {
        var tr = $(this).closest('tr');
        var row = table2.row(tr);
        var rowData = row.data();
        var id = $('#view').val() == "Week" ? 'mg' + rowData.Name.replace(/[^A-Z0-9]/ig, "") : 'mg' + $('#daynoparam').val();
        SKUCodeval = rowData.Name;
        isMachine = false;
        if (row.child.isShown()) {
            // This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');

            // Destroy the Child Datatable
            $('#' + id).DataTable().destroy();
        }
        else {
            // Open this row
            //row.child(format(id)).show();

            //weekly(id, 'details-control3');
            if ($('#view').val() == "Week") {
                // Open this row
                row.child(format(id)).show();
                weekly(id, 'details-control3')
            }
            else {
                generalManpowerDetails(tr, row, rowData, id, $('#daynoparam').val() + 1, SKUCodeval);
            }

            tr.addClass('shown');
        }
    });

    // Manpower General Details
    $('tbody').on('click', 'td.details-control3', function () {
        var tr = $(this).closest('tr');
        var row = childTable.row(tr);
        var rowData = row.data();
        var id = 'mg' + rowData.Date.split('|')[1];
        date3 = rowData.Date.split('|')[1] + 1;

        generalManpowerDetails(tr, row, rowData, id, $('#daynoparam').val() + 1, SKUCodeval);
    });

    // Editable Event
    $('tbody').on('click', '.editable', function () {
        if (generate == 1 && finalized == 0) {
            var this1 = $(this);
            var data = $(this).text();
            var tableID = $(this).closest('table').attr('id');
            var rowID = $('#' + tableID).DataTable().row($(this).closest('tr')).index();
            var rowData = $('#' + tableID).DataTable().row($(this).closest('tr')).data();

            if (!$(this).hasClass('select')) {
                if (data != "") $(this).html("<input id='" + tableID + rowID + "' type='number' class='form-control-sm editVal col-12' value='" + data + "' min='1' />");
            }
            else {
                if (!$(this).hasClass('start')) {
                    $(this).addClass('start');
                    $.ajax({
                        url: "frmCapacityPlanning.aspx/Machine",
                        type: "POST",
                        contentType: "application/json",
                        dataType: "json",
                        data: '{MachineType:"' + rowData.AvailableMachine + '"}',
                        success: function (data1) {
                            var data1 = JSON.parse(data1.d);
                            var options = "";

                            data1.forEach(function (item, i) {
                                var selected = data == item.Code ? "selected='selected'" : "";
                                options += "<option value='" + item.Code + "' " + selected + ">" + item.Description + "</option>";
                            });

                            this1.html("<select id='" + tableID + rowID + "' class='form-select-sm editVal col-12' value='" + data + "'>" + options + "</select>")
                        },
                        error: function (err) {
                            console.log(err);
                            swalWithBootstrapButtons.fire({
                                title: "Error",
                                text: err.message,
                                icon: "error"
                            });
                        }
                    });
                }
            }

            $('#' + tableID + rowID).focus();
        }
    });

    // On blur or change Event
    $('tbody').on('blur change', '.editVal', function () {
        var Year = $('#yearparam').val();
        var WorkWeek = $('#weeknoparam').val();
        $(this).closest('td').removeClass('start');
        var tableID = $(this).closest('table').attr('id');
        var rowData = $('#' + tableID).DataTable().row($(this).closest('tr')).data();
        var val = $(this).val();
        var data;

        if (tableID == "masterTableMachine") {
            var RecordID = rowData.RecordID;
            tableID = "MachineH";
            data = {
                RecordID,
                SequenceDay: val,

            }
        }

        else if (tableID.includes('mt')) {
            tableID = "MachineD";
            var RecordID = rowData.RecordID;

            data = {
                RecordID,
                AvailableMachine: val,
                Year,
                WorkWeek
            }
        }

        else if (tableID.includes('mp')) {
            tableID = "ManpowerS";
            var RecordID = rowData.RecordID;

            data = {
                RecordID,
                NoManpower: val,
                Year,
                WorkWeek
            }
        }

        else {
            tableID = "ManpowerG";
            var RecordID = rowData.RecordID;

            data = {
                RecordID,
                NoManpower: val,
                Year,
                WorkWeek
            }
        }

        if (val != "") {
            $(this).closest("td").html(val);

            $.ajax({
                url: "frmCapacityPlanning.aspx/Update",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: '{_cp:' + JSON.stringify(data) + ', table: "' + tableID + '"}',
                success: function (data) {
                    console.log(data);
                    if (data.d.search("error") != -1) {
                        swalWithBootstrapButtons.fire({
                            title: "Error",
                            text: data.d,
                            icon: "error"
                        });
                    }
                },
                error: function (err) {
                    swalWithBootstrapButtons.fire({
                        title: "Error",
                        text: err,
                        icon: "error"
                    });
                }
            });
        }
        else {
            swalWithBootstrapButtons.fire({
                title: "",
                text: "Field cannot be empty",
                icon: "info"
            })
        }

    });

    $('tbody').on('click', '.viewMachineBtn', function () {
        let viewMachineSummaryBtn = $(this);
        let machineSummary = $('#viewMachines');
        let value = 0;
        let dayno = new Date(viewMachineSummaryBtn.attr("data-date"));
        dayno = dayno.getDay() + 1;

        machineSummary.modal('toggle');

        $('#viewMachines--Title').html("Available Machines: " + viewMachineSummaryBtn.attr("data-date"));
        console.log(currDate);

        if (machineSummary.hasClass('show')) {
            $('#SKUsTable').DataTable({
                processing: true,
                serverSide: true,
                paging: false,
                searching: false,
                scrollX: false,
                info: false,
                destroy: true,
                ajax: {
                    url: "frmCapacityPlanning.aspx/SP_Call",
                    type: "POST",
                    contentType: "application/json",
                    dataType: "json",
                    data: function (d) {
                        d.year = $('#yearparam').val();
                        d.workweek = $('#weeknoparam').val();
                        d.table = "ViewSKUs";
                        d.dayno = dayno;
                        d.skucode = viewMachineSummaryBtn.attr("data-type");
                        d.generate = generate;
                        d.stages = '';
                        return JSON.stringify(d);
                    },
                    dataSrc: function (res) {
                        var parsed = JSON.parse(res.d);
                        return parsed;
                    },
                },
                columns: [
                    {
                        title: "SKUCode",
                        data: "SKUCode",
                    },
                    {
                        title: "Quantity",
                        data: "Qty",
                    }
                ],
                footerCallback: function (row, data, start, end, display) {
                    var api = this.api(), data;

                    // Total over all pages
                    var total = api
                        .column(1)
                        .data()
                        .reduce(function (a, b) {

                            return a + b
                        }, 0);

                    value = total;

                    // Update footer
                    $(api.column(1).footer()).html(
                        total.toFixed(2)
                    );
                }
            });
            console.log(Stages);
            let availableMachinesTable = $('#availableMachinesTable').DataTable({
                processing: true,
                serverSide: true,
                paging: false,
                searching: false,
                scrollX: false,
                info: false,
                destroy: true,
                ajax: {
                    url: "frmCapacityPlanning.aspx/SP_Call",
                    type: "POST",
                    contentType: "application/json",
                    dataType: "json",
                    data: function (d) {
                        d.year = $('#yearparam').val();
                        d.workweek = $('#weeknoparam').val();
                        d.table = "ViewAvailableMachines";
                        d.dayno = "";
                        d.skucode = viewMachineSummaryBtn.attr("data-type");
                        d.generate = generate;
                        d.stages = Stages;
                        return JSON.stringify(d);
                    },
                    dataSrc: function (res) {
                        var parsed = JSON.parse(res.d);
                        return parsed;
                    },
                },
                columns: [
                    {
                        title: "MachineName",
                        data: "MachineName",
                    },
                    {
                        title: "CapacityQty",
                        data: "CapacityQty",
                    },
                    {
                        title: "Machine Status",
                        data: "Status",
                        render: function (data) {
                            let output = "";

                            output = data.toLowerCase() != "down" ? "<p>Operational</p>"
                                : "<p class='text-danger'>Down</p>";

                            return output;
                        }
                    },
                    {
                        title: "Remarks",
                        data: null,
                        render: function (row) {
                            let output = "";

                            if (row.Status.toLowerCase() != "down") {
                                if (value >= row.CapacityQty) output = "<p class='text-success'>Machine is in full capacity</p>";
                                if (value <= row.CapacityQty) output = "<p class='text-info'>Machine is not in full capacity</p>";
                                if (value <= 0) output = "<p>Machine is Available</p>";
                            }
                            else {
                                output = "<p>Machine is not Available</p>";
                            }
                            

                            value -= row.CapacityQty;

                            return output;
                        }
                    }
                ],
                createdRow: function (row, data, index) {
                    if (data.Status.toLowerCase() == "down") $(row).addClass('text-danger');
                    
                },
                footerCallback: function (row, data, start, end, display) {
                    var api = this.api(), data;
                    let sum = 0;

                    availableMachinesTable.rows(function (index, data, node) {
                        if (data.Status.toLowerCase() != 'down') sum += data.CapacityQty
                    });

                    // Update footer
                    $(api.column(1).footer()).html(
                        sum.toFixed(2)
                    );
                }
            });
        }
    });
    // -- EVENTS END -- // 
}); 


// -- FUNCTIONS START -- // 

// 1 Function yearParameter, to set options of Year Parameter
function yearParameter() {
    $.ajax({
        type: 'POST',
        url: 'frmCapacityPlanning.aspx/YearParameter',
        contentType: 'application/json',
        dataType: 'json',
        success: function (data) {
            var data = JSON.parse(data.d);
            var d = new Date();
            var n = d.getFullYear();
            var options = "";

            data.forEach(function (item, index) {
                var selected = item.Year == n ? "selected='selected'" : "";

                options += "<option value='" + item.Year + "' " + selected + ">" + item.Year + "</option>";
            });

            $('#yearparam').html(options);
            $("#paramYear").text($('#yearparam').val());
        },
        error: function (err) {
            console.log(err);
        }
    });
}

// 1 Function weekParameter, to set options of Week Parameter
function weekParameter() {
    $.ajax({
        type: 'POST',
        url: 'frmCapacityPlanning.aspx/WeekParameter',
        contentType: 'application/json',
        dataType: 'json',
        success: function (data) {
            var data = JSON.parse(data.d);
            var d = new Date();
            var n = d.getWeek();
            var options = "";
            data.forEach(function (item, index) {
                var selected = item.WorkWeek == n ? "selected='selected'" : "";

                options += "<option value='" + item.WorkWeek + "' " + selected + ">" + item.WorkWeek + "</option>";
            });

            $('#weeknoparam').html(options);
            $("#paramWorkWeek").text($('#weeknoparam').val());
        },
        error: function (err) {
            console.log(err);
        }
    });
}

// 2 Checking Data Status
function statusChecker(year, workweek, dayno = 0) {
    $.ajax({
        url: "frmCapacityPlanning.aspx/SP_Call",
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        data: '{year:' + year + ', workweek:' + workweek + ', table:"Status", dayno:' + dayno + ', skucode:"", generate:"",stages:""}',
        success: function (data) {
            var data = JSON.parse(data.d);

            if (data.length == 0) data.push({ isGenerated: 0, isFinalized: 0 }); 

            // For Generate Button
            (data[0].isGenerated == 1) ? $('#generateBtn').css("display", "none") : $('#generateBtn').css("display", "unset");

            // For Finalize Button
            (data[0].isFinalized == 1 || data[0].isGenerated == 0) ? $('#finalizeBtn').css("display", "none") : $('#finalizeBtn').css("display", "unset");

            // For Finalized Status
            if (data[0].isFinalized == 1) $("#final").html("This Work week [" + workweek + "-" + year + "] of Capacity Planning is already finalized on " + moment(data[0].FinalizedDate).format('LLL')).removeAttr("class").addClass("badge badge-success-lighten");
            if (data[0].isGenerated == 1 && data[0].isFinalized == 0) $("#final").html("This Work week [" + workweek + "-" + year + "] of Capacity Planning is already generated on " + moment(data[0].GeneratedDate).format('LLL')).removeAttr("class").addClass("badge badge-info-lighten");
            if (data[0].isGenerated == 0 && data[0].isFinalized == 0) $("#final").html("This Work week [" + workweek + "-" + year + "] of Capacity Planning is not generated").removeAttr("class").addClass("badge badge-danger-lighten");

            // Is Generated/Is Finalized Status
            generate = (data[0].isGenerated == 1) ? 1 : 0;
            finalized = (data[0].isFinalized == 1) ? 1 : 0;

            machineNRTERTE(); // Table for Machine
            manpowerSpecificTable(year, workweek); // Table for Manpower Specific
            manpowerGeneralTable(year, workweek); // Table for Manpower General
        }
    });
}

// 3 Stages Table
function machineNRTERTE() {
    table.clear().draw();
    table.destroy();

    var data = [
        { Stages: "NRTE" },
        { Stages: "RTE" },
    ]

    table = $('#masterTableMachine').DataTable({
        paging: false,
        searching: false,
        scrollX: false,
        info: false,
        data: data,
        columns: [
            {
                className: 'details-control0',
                orderable: false,
                data: null,
                defaultContent: '',
                width: '5%'
            },
            {
                title: "Stages",
                data: "Stages",
                width: '95%'
            }
        ],
    });
}

// 4 Machine Table
function machineTable(tr, row, id, stages) {
    if (row.child.isShown()) {
        // This row is already open - close it
        row.child.hide();
        tr.removeClass('shown');

        // Destroy the Child Datatable
        $('#' + id).DataTable().destroy();
    }
    else {
        // Open this row
        row.child(format0(id)).show();
        childTable0 = $('#' + id).DataTable({
            processing: true,
            serverSide: true,
            paging: false,
            searching: false,
            scrollX: false,
            info: false,
            ajax: {
                url: "frmCapacityPlanning.aspx/SP_Call",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: function (d) {
                    d.year = $('#yearparam').val();
                    d.workweek = $('#weeknoparam').val();
                    d.table = "MachineHeader1";
                    d.dayno = "";
                    d.skucode = "";
                    d.generate = generate;
                    d.stages = stages;
                    return JSON.stringify(d);
                },
                dataSrc: function (res) {
                    var parsed = JSON.parse(res.d);
                    return parsed;
                },
            },
            columns: [
                {
                    className: 'details-control',
                    orderable: false,
                    data: null,
                    defaultContent: '',
                    width: '5%'
                },
                {
                    data: "RecordID",
                    visible: false
                },
                {
                    title: "Machine Type",
                    data: "MachineType",
                    width: '95%'
                }
            ]
        });
    }
};

// 4 Manpower Specific Table
function manpowerSpecificTable(year, workweek) {
    //console.log($.fn.DataTable.isDataTable('#masterTableManpowerSpecific'));
    //if ($.fn.DataTable.isDataTable('#masterTableManpowerSpecific')) {
    table1.clear().draw();
    table1.destroy();
    //}

    table1 = $('#masterTableManpowerSpecific').DataTable({
        processing: true,
        serverSide: true,
        paging: false,
        searching: false,
        scrollX: false,
        info: false,
        ajax: {
            url: "frmCapacityPlanning.aspx/SP_Call",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: function (d) {
                d.year = year;
                d.workweek = workweek;
                d.table = "ManpowerHeader";
                d.dayno = "";
                d.skucode = "";
                d.generate = generate;
                d.stages = '';
                return JSON.stringify(d);
            },
            dataSrc: function (res) {
                var parsed = JSON.parse(res.d);
                return parsed;
            },
        },
        columns: [
            {
                className: 'details-control',
                orderable: false,
                data: null,
                defaultContent: '',
                width: '5%'
            },
            {
                data: "Name",
                width: '95%'
            }
        ],
    });
}

// 4 Manpower General Table
function manpowerGeneralTable(year, workweek) {
    if ($.fn.DataTable.isDataTable('#masterTableManpowerGeneral')) {
        table2.clear().draw();
        table2.destroy();
    }

    table2 = $('#masterTableManpowerGeneral').DataTable({
        processing: true,
        serverSide: true,
        paging: false,
        searching: false,
        scrollX: false,
        info: false,
        ajax: {
            url: "frmCapacityPlanning.aspx/SP_Call",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: function (d) {
                d.year = year;
                d.workweek = workweek;
                d.table = "ManpowerHeader";
                d.dayno = "";
                d.skucode = "";
                d.generate = generate;
                d.stages = '';
                return JSON.stringify(d);
            },
            dataSrc: function (res) {
                var parsed = JSON.parse(res.d);
                return parsed;
            },
        },
        columns: [
            {
                className: 'details-control',
                orderable: false,
                data: null,
                defaultContent: '',
                width: '5%'
            },
            {
                data: "Name",
                width: '95%'
            }
        ],
    });
}

// 5 Weekly Table
function weekly(id, className, type = "", Sku = "") {
    var data = [
        { Date: "Monday|0" },
        { Date: "Tuesday|1" },
        { Date: "Wednesday|2" },
        { Date: "Thursday|3" },
        { Date: "Friday|4" },
        { Date: "Saturday|5" },
        { Date: "Sunday|6" },
    ]

    childTable = $('#' + id).DataTable({
        paging: false,
        searching: false,
        scrollX: false,
        info: false,
        data: data,
        columns: [
            {
                className: className,
                orderable: false,
                data: null,
                defaultContent: '',
                title: "",
                width: "5%"
            },
            {
                title: "Date",
                data: "Date",
                width: '90%',
                render: function (d) {
                    var paramYear = $('#yearparam').val();
                    var paramWorkWeek = $('#weeknoparam').val();
                    var data = d.split('|')[0];
                    var count = d.split('|')[1];
                    d1 = getDateOfISOWeek(paramWorkWeek, paramYear);

                    var output = '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">' + data + '</a></h5><span class="text-muted font-13">' + moment(d1).add(count, 'days').format('LL'); + '</span>';
                    return output;
                }
            },
            {
                data: "Date",
                width: '5%',
                render: function (d, type1, full, meta) {
                    var paramYear = $('#yearparam').val();
                    var paramWorkWeek = $('#weeknoparam').val();
                    var data = d.split('|')[0];
                    var count = d.split('|')[1];
                    d1 = getDateOfISOWeek(paramWorkWeek, paramYear);
                    console.log(type);
                    var isMachine = type == "" ? "d-none" : "";
                    var dayno = parseInt(count) + 1;
                    var currentCell = $('#' + id).DataTable().cells({ "row": meta.row, "column": meta.col }).nodes(0);

                    if (type != "") {
                        $.ajax({
                            url: "frmCapacityPlanning.aspx/SP_Call",
                            type: "POST",
                            contentType: "application/json",
                            dataType: "json",
                            data: '{year:' + paramYear + ',workweek:' + paramWorkWeek + ',table:"MachineAlert",dayno:' + dayno + ',skucode:"' + SKUCodeval + '",generate:"0",stages:""}',
                            success: function (data) {
                                var data = JSON.parse(data.d);

                                let disable = "";
                                let CapacityLeft;
                                let Down;
                                let Warning = "";
                                let Color = "";
                                let Message;

                                //var output = '<button type="button" class="btn btn-primary viewMachineBtn ' + isMachine +
                                //    '" data-date="' + moment(d1).add(count, 'days').format('LL') + '" data-type="' + type + '">View</button>';
                                //console.log(data);

                                disable = data[0].Qty == null ? "disabled='disabled'" : ""; // Disable
                                Warning = (((data[0].CapacityLeft <= 0 && data[0].CapacityLeft != null) ||
                                    data[0].Down > 0) && data[0].Qty != null) ? '<i class="fas fa-exclamation" style="margin-right:2px"></i>' : ""; // Icon
                                Color = (((data[0].CapacityLeft <= 0 && data[0].CapacityLeft != null) ||
                                    data[0].Down > 0) && data[0].Qty != null) ? "btn-danger" : "btn-info"; // Color
                                CapacityLeft = (data[0].CapacityLeft <= 0 && data[0].CapacityLeft != null) ? "Machines are in full capacity\n" : ""; // Message
                                Down = data[0].Down > 1 ? "Some machines are down\n" : ""; // Message
                                Message = CapacityLeft + Down;
                                var output = '<button type="button" class="btn ' + Color + '  viewMachineBtn ' + isMachine +
                                    '" data-date="' + moment(d1).add(count, 'days').format('LL') + '" data-type="' + Sku +
                                    '" data-toggle="tooltip" data-placement="left" title="' + Message + '" ' + disable + '>' + Warning + ' View</button>';

                                $(currentCell).html(output);

                            },
                            error: function (err) {
                                console.log(err);
                            }
                        });

                        return null;
                    }
                    else {
                        //var hide = isMachine ? "" : "d-none";
                        var output = '<button type="button" class="btn btn-primary viewMachineBtn ' + isMachine + '" data-date="' + moment(d1).add(count, 'days').format('LL') + '" data-type="' + type + '">View</button>';

                        return output;
                    }
                }
            }
        ]
    });
}

// 6 Machine Details Table
function machineDetails(tr, row, id, SKUCodeval, stages) {
    if (row.child.isShown()) {
        // This row is already open - close it
        row.child.hide();
        tr.removeClass('shown');

        // Destroy the Child Datatable
        $('#' + id).DataTable().destroy();
    }
    else {
        // Open this row
        row.child(format(id)).show();
        childTable2 = $('#' + id).DataTable({
            processing: true,
            serverSide: true,
            paging: false,
            searching: false,
            scrollX: false,
            info: false,
            ajax: {
                url: "frmCapacityPlanning.aspx/SP_Call",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: function (d) {
                    currDate = ((parseInt(id.split('mt')[1]) + 1));
                    d.year = $('#yearparam').val();
                    d.workweek = $('#weeknoparam').val();
                    d.table = "MachineDetail";
                    d.dayno = currDate;
                    d.skucode = SKUCodeval;
                    d.generate = generate;
                    d.stages = stages;
                    return JSON.stringify(d);
                },
                dataSrc: function (res) {
                    var parsed = JSON.parse(res.d);
                    return parsed;
                },
            },
            columns: [
                {
                    title: "",
                    data: null,
                    orderable: false,
                    width: '5%',
                    render: function () {
                        return '';
                    }
                },
                {
                    title: "",
                    data: "RecordID",
                    visible: false
                },
                {
                    title: "SKUCode",
                    data: "SKUCode",
                    width: '15%'
                },
                {
                    title: "Process Sequence",
                    data: "ProcessSequence",
                    width: '20%'
                },
                {
                    title: "Number of Batch",
                    data: "NoBatch",
                    width: '20%'
                },
                {
                    title: "Yielded Batch Wt",
                    data: "YieldedBatchWt",
                    width: '20%'
                },
                {
                    title: "Process Code",
                    data: "ProcessCode",
                    width: '20%'
                },
                //{
                //    title: "Available Machine",
                //    data: "AvailableMachine",
                //    className: "editable select",
                //    width: '0%'
                //},
                //{
                //    title: "Machine Details",
                //    data: "MachineDetails",
                //    width: '11.88%'
                //},
                //{
                //    title: "Capacity/hr per Batch",
                //    data: "CapacityHrPerBatch",
                //    width: '11.88%'
                //},
            ],
            "order": [1, 'asc']
        });
        tr.addClass('shown');
    }
}

// 6 Manpower Specific Details Table
function specificManpowerDetails(tr, row, rowData, id, date, SKUCodeval) {
    if (row.child.isShown()) {
        // This row is already open - close it
        row.child.hide();
        tr.removeClass('shown');

        // Destroy the Child Datatable
        $('#' + id).DataTable().destroy();
    }
    else {
        // Open this row
        row.child(format2(id)).show();

        childTable2 = $('#' + id).DataTable({
            processing: true,
            serverSide: true,
            paging: false,
            searching: false,
            scrollX: false,
            info: false,
            ajax: {
                url: "frmCapacityPlanning.aspx/SP_Call",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: function (d) {
                    currDate = ((parseInt(id.split('mp')[1]) + 1));
                    d.year = $('#yearparam').val();
                    d.workweek = $('#weeknoparam').val();
                    d.table = "ManpowerSpecific";
                    d.dayno = currDate;
                    d.skucode = SKUCodeval;
                    d.generate = generate;
                    d.stages = '';
                    return JSON.stringify(d);
                },
                dataSrc: function (res) {
                    var parsed = JSON.parse(res.d);
                    return parsed;
                },
            },
            columns: [
                {
                    title: "",
                    data: null,
                    orderable: false,
                    width: '5%',
                    render: function () {
                        return '';
                    }
                },
                {
                    title: "",
                    data: "RecordID",
                    visible: false
                },
                {
                    title: "SKUCode",
                    data: "SKUCode",
                    width: '31.67%'
                },
                {
                    title: "Process Code",
                    data: "ProcessCode",
                    width: '31.67%'
                },
                {
                    title: "Number of Manpower",
                    data: "NoManpower",
                    className: "editable",
                    width: '31.67%'
                }
            ],
            footerCallback: function (row, data, start, end, display) {
                var api = this.api(), data;

                var intVal = function (i) {
                    return typeof i === 'string' ?
                        i.replace(/[\$,]/g, '') * 1 :
                        typeof i === 'number' ?
                            i : 0;
                };

                var specificProcess = 0;
                var generalManpower = 0;

                if (api.column(1).data()[0] != undefined) {
                    data.forEach(function (item, index) {
                        if (item.ProcessCode.toLowerCase() != 'packaging') {
                            specificProcess += item.NoManpower;
                        }
                        else {
                            generalManpower += item.NoManpower;
                        }
                    });

                    $(api.column(3).footer()).html();
                    $(api.column(4).footer()).html('Specific Process: ' + (specificProcess != undefined ? specificProcess : 0) + ' General Manpower: ' + (generalManpower != undefined ? generalManpower : 0));
                }
            }
        });
        tr.addClass('shown');
    }
}

// 6 Manpower General Details Table
function generalManpowerDetails(tr, row, rowData, id, date, SKUCodeval) {

    if (row.child.isShown()) {
        // This row is already open - close it
        row.child.hide();
        tr.removeClass('shown');

        // Destroy the Child Datatable
        $('#' + id).DataTable().destroy();
    }
    else {
        // Open this row
        row.child(format2(id)).show();

        childTable2 = $('#' + id).DataTable({
            processing: true,
            serverSide: true,
            paging: false,
            searching: false,
            scrollX: false,
            info: false,
            ajax: {
                url: "frmCapacityPlanning.aspx/SP_Call",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: function (d) {
                    currDate = ((parseInt(id.split('mg')[1]) + 1));
                    d.year = $('#yearparam').val();
                    d.workweek = $('#weeknoparam').val();
                    d.table = "ManpowerGeneral";
                    d.dayno = currDate;
                    d.skucode = SKUCodeval;
                    d.generate = generate;
                    d.stages = '';
                    return JSON.stringify(d);
                },
                dataSrc: function (res) {
                    var parsed = JSON.parse(res.d);
                    return parsed;
                },
            },
            columns: [
                {
                    title: "",
                    data: null,
                    orderable: false,
                    width: '5%',
                    render: function () {
                        return '';
                    }
                },
                {
                    title: "",
                    data: "RecordID",
                    visible: false
                },
                {
                    title: "SKUCode",
                    data: "SKUCode",
                    width: '23.75%'
                },
                {
                    title: "Process",
                    data: "ProcessCode",
                    width: '23.75%'
                },
                {
                    title: "Line Assignment",
                    data: "LineAssignment",
                    width: '23.75%'
                },
                {
                    title: "Number of Manpower",
                    data: "NoManpower",
                    className: "editable",
                    width: '23.75%'
                }
            ],
        });
        tr.addClass('shown');
    }
}

// Return table with id generated from row's name field
function format(id) {
    var childTable = '<table id="' + id + '" class="table table-centered '+id+'" width="100%">' +
        //'<thead style="display:none"></thead >' +
        '</table>';
    return $(childTable).toArray();
}

function format0(id) {
    var childTable0 = '<table id="' + id + '" class="table table-centered ' + id + '" width="100%">' +
        //'<thead style="display:none"></thead >' +
        '</table>';
    return $(childTable0).toArray();
}

function format2(id) {
    var childTable = '<table id="' + id + '" class="table table-centered'+id+'" width="100%">' +
        '<tfoot style="text-align:end"><th></th><th></th><th></th><th></th><th></th></tfoot>' +
        '</table>';
    return $(childTable).toArray();
}

function format3(rowData) {
    var childTable = '<table id="in' + rowData.invoice + '" class="table table-centered table-nowrap table-hover" width="100%">' +
        //'<thead style="display:none"></thead >' +
        '</table>';
    return $(childTable).toArray();
}

// Function childtable, Datatable child row creation
function childtable(d) {

    var output = "";

    output =    '<table class="table table-centered" style="margin-left: 3rem;">' +
                    '<thead>' +
                        '<tr></tr>' +
                        '<tr>' +
                            '<th></th>' +
                            '<th>Process Sequence</th>' +
                            '<th>Process Code</th>' +
                            '<th>Type of Machine</th>' +
                            '<th>Available Machine</th>' +
                            '<th>Machine Details</th>' +
                            '<th>Capacity / Hr (per Batch)</th> ' +
                        '</tr>' +
                    '</thead>' +
                    '<tbody>' +
                        '<tr>' +
                            '<td></td>' +
                            '<td>1</td>' +
                            '<td>2</td>' +
                            '<td>3</td>' +
                            '<td>4</td>' +
                            '<td>5</td>' +
                            '<td>6</td>' +
                        '</tr>' +
                    '</tbody>' +
                '</table>';

    return output;
}

// Function getDateOfISOWeek, Get Dates of the week
function getDateOfISOWeek(w, y) {
    var simple = new Date(y, 0, 1 + (w - 1) * 7);
    var dow = simple.getDay();
    var ISOweekStart = simple;
    if (dow <= 4)
        ISOweekStart.setDate(simple.getDate() - simple.getDay() + 1);
    else
        ISOweekStart.setDate(simple.getDate() + 8 - simple.getDay());
    return ISOweekStart;
}

// Function to get Week
Date.prototype.getWeek = function () {
    var onejan = new Date(this.getFullYear(), 0, 1);
    var today = new Date(this.getFullYear(), this.getMonth(), this.getDate());
    var dayOfYear = ((today - onejan + 1) / 86400000);
    return Math.ceil(dayOfYear / 7)
};

// -- FUNCTIONS END -- // 