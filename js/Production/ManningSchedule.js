var table;
var table1;
var table2;
var childEditors = {};  // Globally track created chid editors
var childTable;
var childTable2;
var childTable3;
var childTable4;
var childTable5;
var generate = 0;
var finalized = 1;
var editor;
var date;
var date2;
var date3;
var day;
var tablename;
let paramdate;
let url_string = window.location.href;
let url = new URL(url_string);
let entry = url.searchParams.get("entry");
let currentDocnumber = url.searchParams.get("docnumber");
let isView = entry == 'V' ? "view" : "";
let docnumber = currentDocnumber;
let year;
let workweek;
let dayno;

$(document).ready(async function () {
    // -- ENTRY EDIT START -- // 
    if (entry == 'N') {
        yearParameter(); // Get Year options
        weekParameter(); // Get WeekNo options

    }
    else {
        year = docnumber.split('Y')[1].split('-')[0];
        workweek = docnumber.split('-')[2];
        dayno = docnumber.split('-D')[1];

        $('#yearparam').replaceWith('<input type="text" name="yearparam" id="yearparam" class="" style="border-style:none;width: 40px;" disabled>');
        $('#weeknoparam').replaceWith('<input type="text" name="yearparam" id="weeknoparam" class="" style="border-style:none;width: 25px;" disabled>');

        $('#yearparam').val(year);
        $('#weeknoparam').val(workweek);

        $('#paramYear').html(year);
        $('#paramWorkWeek').html(workweek);

        paramdate = getDateOfISOWeek(workweek, year);
        paramdate = moment(paramdate).add(dayno, 'days').format('LL');

        setTimeout(async () => {
            await $('#searchBtn').click();
        });
    }

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

    // View Option event
    $('#ViewOption').change(function () {
        var showID = '#masterTable' + $('#CapacityPlanningFor').find(":selected").val();

        $('.table-responsive').css("display", "none");
        $(showID).closest('.table-responsive').css("display", "");
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

    // Search Event Button
    $('#searchBtn').click(function () {
        var paramYear = $('#yearparam').val();
        var paramWorkWeek = $('#weeknoparam').val();

        if (paramYear != "" && paramWorkWeek != "") {
            status(paramYear, paramWorkWeek);

            $(this).attr("disabled", "disabled");
        }
    });

    // Generate Event Button
    $("#generateBtn").click(function () {

        var action = {
            Year: $('#yearparam').val(),
            WorkWeek: $('#weeknoparam').val(),
            Action: 'generate'
        }

        $.ajax({
            url: "frmManningSchedule.aspx/SP_Call",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: '{_ms:' + JSON.stringify(action) + '}',
            success: function (data) {
                var data = JSON.parse(data.d);

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
                        if (result.isConfirmed) $("#searchBtn").click();
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

    // Finalize Event Button
    $("#finalizeBtn").click(function () {

        let Dayno = entry != 'E' ? "" : dayno;

        let action = {
            Year: $('#yearparam').val(),
            WorkWeek: $('#weeknoparam').val(),
            Dayno,
            Action: 'submit'
        }
            
        $.ajax({
            url: "frmManningSchedule.aspx/SP_Call",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: '{_ms:' + JSON.stringify(action) + '}',
            success: function (data) {
                var data = JSON.parse(data.d);

                if (data[0].d.search("error") != -1) {
                    swalWithBootstrapButtons.fire({
                        title: "Error",
                        text: data.d,
                        icon: "error"
                    });
                } else {
                    swalWithBootstrapButtons.fire({
                        title: "Finalized Successfully",
                        text: data[0].d,
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

    // Shifts Table
    $('#masterTableMachine tbody').on('click', 'td.details-control', function () {
        var tr = $(this).closest('tr');
        var row = table.row(tr);
        var rowData = row.data();
        console.log(rowData.Date);
        var id = 'md' + rowData.Date.split('|')[1];
        var id2 = 'md2' + rowData.Date.split('|')[1];
        var id3 = 'md3' + rowData.Date.split('|')[1];
        var id4 = 'md4' + rowData.Date.split('|')[1];
        date = rowData.Date.split('|')[1] + 1;

        if (row.child.isShown()) {
            // This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');

            // Destroy the Child Datatable
            $('#' + id).DataTable().destroy();
            $('#' + id2).DataTable().destroy();
            $('#' + id3).DataTable().destroy();
            $('#' + id4).DataTable().destroy();
        }
        else {
            // Open this row
            row.child(format3(id, id2, id3, id4)).show();

            weekly(id, id2, id3, id4);

            tr.addClass('shown');
        }
    });

    // Manning Details Table
    $('tbody').on('click', 'td.details-control1', function () {
        var tr = $(this).closest('tr');
        var row = childTable.row(tr);
        var rowData = row.data();
        var id = 'md' + rowData.Date;
        var id2 = 'md2' + rowData.Date;
        var id3 = 'md3' + rowData.Date;
        var id4 = 'md4' + rowData.Date;
        day = rowData.Day;

        if (row.child.isShown()) {
            // This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');

            // Destroy the Child Datatable
            $('#' + id).DataTable().destroy();
        }
        else {
            // Open this row
            row.child(format3(id, id2, id3, id4)).show();

            childTable2 = $('#' + id).DataTable({
                processing: true,
                serverSide: true,
                paging: false,
                searching: false,
                scrollX: false,
                info: false,
                ajax: {
                    url: "frmManningSchedule.aspx/SP_Call",
                    type: "POST",
                    contentType: "application/json",
                    dataType: "json",
                    data: function (d) {
                        var currDate = parseInt(id.split('md')[1]);
                        var param = {
                            Action: "shift",
                            Year: $('#yearparam').val(),
                            WorkWeek: $('#weeknoparam').val(),
                            DayNo: currDate,
                            Filter: rowData.Shift
                        };

                        d._ms = param;

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
                        title: "Day Shift",
                        data: "Position",
                        width: '13.57%'
                    },
                    {
                        title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Plan</a></h5><span class= "text-muted font-13" > Direct</span>',
                        data: "DirectPlan",
                        width: '13.57%'
                    },
                    {
                        title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Actual</a></h5><span class= "text-muted font-13" > Direct</span>',
                        data: "DirectActual",
                        width: '13.57%',
                        className: 'editable DirectActual ' + isView
                    },
                    {
                        title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Percentage</a></h5><span class= "text-muted font-13" > Direct</span>',
                        data: "DirectPercent",
                        width: '13.57%',
                        className: 'DirectPercent'
                    },
                    {
                        title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Plan</a></h5><span class= "text-muted font-13" > Agency</span>',
                        data: "AgencyPlan",
                        width: '13.57%'
                    },
                    {
                        title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Actual</a></h5><span class= "text-muted font-13" > Agency</span>',
                        data: "AgencyActual",
                        width: '13.57%',
                        className: 'editable AgencyActual ' + isView
                    },
                    {
                        title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Percentage</a></h5><span class= "text-muted font-13" > Agency</span>',
                        data: "AgencyPercent",
                        className: 'AgencyPercent',
                        width: '13.57%'
                    }
                ],
                footerCallback: function (row, data, start, end, display) {
                    var api = this.api(), data;

                    var intVal = function (i) {
                        return typeof i === 'string' ?
                            i.replace(/[\$,%]/g, '') * 1 :
                            typeof i === 'number' ?
                                i : 0;
                    };

                    var DPlan = api
                        .column(3)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    var DActual = api
                        .column(4)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    var DPercent = api
                        .column(5)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    var DPercentCount = 0;
                    data.forEach(function (item) {
                        if (item.DirectPercent != null || item.DirectPercent != "") DPercentCount += 1;
                    });
                    DPercent /= DPercentCount;

                    var APlan = api
                        .column(6)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    var AActual = api
                        .column(7)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    var APercent = api
                        .column(8)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    var APercentCount = 0;
                    data.forEach(function (item) {
                        if (item.APercent != null || item.APercent != "") APercentCount += 1;
                    });
                    APercent /= APercentCount;
                    
                    $(api.column(2).footer()).html('Total');
                    $(api.column(3).footer()).html(DPlan);
                    $(api.column(4).footer()).html(DActual);
                    $(api.column(5).footer()).html(DPercent + '%');
                    $(api.column(6).footer()).html(APlan);
                    $(api.column(7).footer()).html(AActual);
                    $(api.column(8).footer()).html(APercent + '%');
                }
            });

            childTable3 = $('#' + id2).DataTable({
                processing: true,
                serverSide: true,
                paging: false,
                searching: false,
                scrollX: false,
                info: false,
                ajax: {
                    url: "frmManningSchedule.aspx/SP_Call",
                    type: "POST",
                    contentType: "application/json",
                    dataType: "json",
                    data: function (d) {
                        var currDate = parseInt(id.split('md')[1]);
                        var param = {
                            Action: "shiftdesignation",
                            Year: $('#yearparam').val(),
                            WorkWeek: $('#weeknoparam').val(),
                            DayNo: currDate,
                            Filter: rowData.Shift
                        };

                        d._ms = param;

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
                        //title: "Position",
                        data: "Position",
                        className: "Position",
                        width: '13.57%'
                    },
                    {
                        //title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Plan</a></h5><span class= "text-muted font-13" > Direct</span>',
                        data: "DirectPlan",
                        className: "DirectPlan",
                        width: '13.57%'
                    },
                    {
                        //title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Actual</a></h5><span class= "text-muted font-13" > Direct</span>',
                        data: "DirectActual",
                        className: "DirectActual",
                        width: '13.57%'
                    },
                    {
                        //title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Percentage</a></h5><span class= "text-muted font-13" > Direct</span>',
                        data: "DirectPercent",
                        className: "DirectPercent",
                        width: '13.57%'
                    },
                    {
                        //title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Plan</a></h5><span class= "text-muted font-13" > Agency</span>',
                        data: "AgencyPlan",
                        className: "AgencyPlan",
                        width: '13.57%'
                    },
                    {
                        //title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Actual</a></h5><span class= "text-muted font-13" > Agency</span>',
                        data: "AgencyActual",
                        className: "editable select AgencyActual " + isView,
                        width: '13.57%'
                    },
                    {
                        //title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Percentage</a></h5><span class= "text-muted font-13" > Agency</span>',
                        data: "AgencyPercent",
                        width: '13.57%'
                    }
                ],
                footerCallback: function (row, data, start, end, display) {
                    var api = this.api(), data;

                    var intVal = function (i) {
                        return typeof i === 'string' ?
                            i.replace(/[\$,%]/g, '') * 1 :
                            typeof i === 'number' ?
                                i : 0;
                    };

                    var DPlan = api
                        .column(3)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    var DActual = api
                        .column(4)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    var DPercent = api
                        .column(5)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    var DPercentCount = 0;
                    data.forEach(function (item) {
                        if (item.DirectPercent != null || item.DirectPercent != "") DPercentCount += 1;
                    });
                    DPercent /= DPercentCount;

                    var APlan = api
                        .column(6)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    var AActual = api
                        .column(7)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    var APercent = api
                        .column(8)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    var APercentCount = 0;
                    data.forEach(function (item) {
                        if (item.APercent != null || item.APercent != "") APercentCount += 1;
                    });
                    APercent /= APercentCount;

                    $(api.column(2).footer()).html('Total');
                    $(api.column(3).footer()).html(DPlan);
                    $(api.column(4).footer()).html(DActual);
                    $(api.column(5).footer()).html(DPercent + '%');
                    $(api.column(6).footer()).html(APlan);
                    $(api.column(7).footer()).html(AActual);
                    $(api.column(8).footer()).html(APercent + '%');
                }
            });

            tr.addClass('shown');
        }
    });

    // Add event listener for opening and closing details
    $('#masterTableMachine tbody').on('click', 'td.details-control2', function () {
        var tr = $(this).closest('tr');
        var row = tables.row(tr);

        if (row.child.isShown()) {
            // This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');
        }
        else {
            // Open this row
            createChild(row);
            tr.addClass('shown');
        }
    });

    // Editable Table Event
    $(document).on("click", ".DayShiftSelect", function () {
        //$(this).select2({
        //    width: "100%",
        //    dropdownCssClass: "dropdown",
        //    templateResult: templateResult,
        //    templateSelection: templateSelection,
        //    matcher: matchStart
        //});

        //$(this).change();
    });

    // Editable Event
    var pastValue = "";
    $('tbody').on('click', 'td.editable', function () {
        if (entry != 'V') {
            var filter = "";
            var shift = "";

            if ($(this).hasClass("ProcessCode")) filter = "ProcessCode";

            if ($(this).hasClass("Designation")) {
                filter = "Designation";
                shift = $(this).hasClass("Day") ? "Day" : "Night";
            }

            var action = {
                Year: $('#yearparam').val(),
                WorkWeek: $('#weeknoparam').val(),
                Action: 'position',
                Filter: filter,
                Shift: shift
            }

            if (generate > 0 && finalized == 0) {
                var this1 = $(this);
                var data = $(this).text() == "" ? 0 : $(this).text();
                var tableID = $(this).closest('table').attr('id');
                var rowID = $('#' + tableID).DataTable().row($(this).closest('tr')).index();
                var rowData = $('#' + tableID).DataTable().row($(this).closest('tr')).data();

                if (!$(this).hasClass('select')) {
                    if (data != "") $(this).html("<input id='" + tableID + rowID + "' type='number' class='form-control-sm editVal col-12' value='" + data + "' min='0' />");
                }
                else {
                    if (!$(this).hasClass('start')) {
                        $(this).addClass('start');

                        let items = '<option value="Section" disabled="disabled">Cost Center</option>';
                        $.ajax({
                            type: "POST",
                            url: "frmManningSchedule.aspx/SP_Call",
                            data: '{_ms:' + JSON.stringify(action) + '}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (data1) {
                                var data1 = JSON.parse(data1.d);
                                console.log(data1);
                                var options = "";

                                data1.forEach(function (item, i) {
                                    var selected = data == item.Code ? "selected='selected'" : "";
                                    options += "<option value='" + item.Code + "' " + selected + ">" + item.Description + "</option>";
                                });

                                this1.html("<select id='" + tableID + rowID + "' class='form-select-sm editVal col-12' value='" + data + "'>" + options + "</select>")

                                $('#' + tableID + rowID).html(options);

                                $('#' + tableID + rowID).select2({
                                    width: "100%",
                                    dropdownCssClass: "dropdown",
                                    templateResult: templateResult,
                                    templateSelection: templateSelection,
                                    matcher: matchStart
                                });

                                //$('.DayShiftSelect').val().change();
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
                }

                $('#' + tableID + rowID).focus();
            }
        }
    });

    // On blur or change Event
    $('tbody').on('blur change', '.editVal', function () {
        var Year = $('#yearparam').val();
        var WorkWeek = $('#weeknoparam').val();
        $(this).closest('td').removeClass('start');
        var tableID = $(this).closest('table').attr('id');
        var val = $(this).val();
        var row = $(this).closest('tr');
        var classes = $(this).closest('td');
        var index = $('#' + tableID).DataTable().cell(classes).index().columnVisible;


        var rowData = $('#' + tableID).DataTable().row(row).data();

        var DirectPlan = index == 2 ? val : rowData.DirectPlan;
        var DirectActual = index == 3 ? val : rowData.DirectActual;
        var DirectPercent = (DirectActual == 0 || DirectPlan == 0) ? 0 : Math.round((parseFloat(DirectActual) / parseFloat(DirectPlan)) * 100);
        DirectPercent = DirectPercent || 0;
        var AgencyPlan = index == 5 ? val : rowData.AgencyPlan;
        var AgencyActual = index == 6 ? val : rowData.AgencyActual;
        var AgencyPercent = (AgencyActual == 0 || AgencyPlan == 0) ? 0 : Math.round((parseFloat(AgencyActual) / parseFloat(AgencyPlan)) * 100);
        AgencyPercent = AgencyPercent || 0;

        var action = {
            RecordID: rowData.RecordID,
            Position: rowData.Position,
            DirectPlan,
            DirectActual,
            DirectPercent,
            AgencyPlan,
            AgencyActual,
            AgencyPercent
        }

        if (val != "") {
            $(this).closest("td").html(val);

            $.ajax({
                url: "frmManningSchedule.aspx/Update",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: '{_ms:' + JSON.stringify(action) + '}',
                success: function (data) {
                    $('td .dataTable').DataTable().ajax.reload();
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

    // -- EVENTS END -- // 

    

    // -- ENTRY EDIT END -- //

});


// -- FUNCTIONS START -- // 

// Update Machine Table
function weekly(id, id2, id3, id4) {
    childTable2 = $('#' + id).DataTable({
        processing: true,
        serverSide: true,
        paging: false,
        searching: false,
        scrollX: false,
        info: false,
        ajax: {
            url: "frmManningSchedule.aspx/SP_Call",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: function (d) {
                var currDate = parseInt(id.split('md')[1]) + parseInt(1);
                var param = {
                    Action: "shift",
                    Year: $('#yearparam').val(),
                    WorkWeek: $('#weeknoparam').val(),
                    DayNo: currDate,
                    Filter: 'DS',
                    Generate: generate
                };

                d._ms = param;

                return JSON.stringify(d);
            },
            dataSrc: function (res) {
                var parsed = JSON.parse(res.d);
                return parsed;
            },
        },
        columns: [
            {
                title: '<button data-toggle="tooltip" data-placement="top" title="Generate" id="generateBtn" type="button" class="" style="width:100%;background: #39afd1;border:none;display:none"><i class="mdi mdi-check"></i></button>' +
                    '<button data-toggle="tooltip" data-placement="top" title="Submit" id="finalizeBtn" type="button" class="" style="width:100%;background: #0acf97;border:none;display:none"><i class="mdi mdi-content-save"></i></button>',
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
                title: "Day Shift",
                data: "Position",
                width: '13.57%',
                className: 'select ProcessCode Day'
            },
            {
                title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Plan</a></h5><span class= "text-muted font-13" > Direct</span>',
                data: "DirectPlan",
                width: '13.57%'
            },
            {
                title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Actual</a></h5><span class= "text-muted font-13" > Direct</span>',
                data: "DirectActual",
                width: '13.57%',
                className: 'editable ' + isView
            },
            {
                title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Percentage</a></h5><span class= "text-muted font-13" > Direct</span>',
                data: "DirectPercent",
                width: '13.57%'
            },
            {
                title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Plan</a></h5><span class= "text-muted font-13" > Agency</span>',
                data: "AgencyPlan",
                width: '13.57%'
            },
            {
                title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Actual</a></h5><span class= "text-muted font-13" > Agency</span>',
                data: "AgencyActual",
                width: '13.57%',
                className: 'editable ' + isView
            },
            {
                title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Percentage</a></h5><span class= "text-muted font-13" > Agency</span>',
                data: "AgencyPercent",
                width: '13.57%'
            }
        ],
        footerCallback: function (row, data, start, end, display) {
            var api = this.api(), data;

            var intVal = function (i) {
                return typeof i === 'string' ?
                    i.replace(/[\$,%]/g, '') * 1 :
                    typeof i === 'number' ?
                        i : 0;
            };

            var DPlan = api
                .column(3)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var DActual = api
                .column(4)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var DPercent = DPlan == 0 ? 0 : (parseFloat(DActual) / parseFloat(DPlan)) * 100;
            DPercent = DPercent || 0;

            var APlan = api
                .column(6)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var AActual = api
                .column(7)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var APercent = APlan == 0 ? 0 : (parseFloat(AActual) / parseFloat(APlan)) * 100;
            APercent = APercent || 0;

            $(api.column(2).footer()).html('Total');
            $(api.column(3).footer()).html(DPlan);
            $(api.column(4).footer()).html(DActual);
            $(api.column(5).footer()).html(Math.round(DPercent) + '%');
            $(api.column(6).footer()).html(APlan);
            $(api.column(7).footer()).html(AActual);
            $(api.column(8).footer()).html(Math.round(APercent) + '%');
        }
    });

    childTable3 = $('#' + id2).DataTable({
        processing: true,
        serverSide: true,
        paging: false,
        searching: false,
        scrollX: false,
        info: false,
        ajax: {
            url: "frmManningSchedule.aspx/SP_Call",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: function (d) {
                var currDate = parseInt(id.split('md')[1]) + parseInt(1);
                var param = {
                    Action: "shiftdesignation",
                    Year: $('#yearparam').val(),
                    WorkWeek: $('#weeknoparam').val(),
                    DayNo: currDate,
                    Filter: 'DS',
                    Generate: generate
                };

                d._ms = param;

                return JSON.stringify(d);
            },
            dataSrc: function (res) {
                var parsed = JSON.parse(res.d);
                return parsed;
            },
        },
        columns: [
            {
                title: '',
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
                data: "Position",
                width: '13.57%'
            },
            {
                data: "DirectPlan",
                width: '13.57%',
            },
            {
                data: "DirectActual",
                width: '13.57%',
                className: 'editable ' + isView
            },
            {
                data: "DirectPercent",
                width: '13.57%'
            },
            {
                data: "AgencyPlan",
                width: '13.57%'
            },
            {
                data: "AgencyActual",
                width: '13.57%',
                className: 'editable ' + isView
            },
            {
                data: "AgencyPercent",
                width: '13.57%'
            }
        ],
        footerCallback: function (row, data, start, end, display) {
            var api = this.api(), data;

            var intVal = function (i) {
                return typeof i === 'string' ?
                    i.replace(/[\$,%]/g, '') * 1 :
                    typeof i === 'number' ?
                        i : 0;
            };

            var DPlan = api
                .column(3)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var DActual = api
                .column(4)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var DPercent = DPlan == 0 ? 0 : (parseFloat(DActual) / parseFloat(DPlan)) * 100;
            DPercent = DPercent || 0;

            var APlan = api
                .column(6)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var AActual = api
                .column(7)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var APercent = APlan == 0 ? 0 : (parseFloat(AActual) / parseFloat(APlan)) * 100;
            APercent = APercent || 0;

            var GTDPlan = parseInt($('#f' + id + ' th:eq(2)').html()) + parseInt(DPlan);
            var GTDActual = parseInt($('#f' + id + ' th:eq(3)').html()) + parseInt(DActual);
            var GTDPercent = GTDPlan == 0 ? 0 : (parseFloat(GTDActual) / parseFloat(GTDPlan)) * 100;
            GTDPercent = GTDPercent || 0;
            var GTAPlan = parseInt($('#f' + id + ' th:eq(5)').html()) + parseInt(APlan);
            var GTAActual = parseInt($('#f' + id + ' th:eq(6)').html()) + parseInt(AActual);
            var GTAPercent = GTAPlan == 0 ? 0 : (parseFloat(GTAActual) / parseFloat(GTAPlan)) * 100;
            GTAPercent = GTAPercent || 0;

            $('tr:eq(0) th:eq(1)', api.table().footer()).html('Total');
            $('tr:eq(0) th:eq(2)', api.table().footer()).html(DPlan);
            $('tr:eq(0) th:eq(3)', api.table().footer()).html(DActual);
            $('tr:eq(0) th:eq(4)', api.table().footer()).html(Math.round(DPercent) + '%');
            $('tr:eq(0) th:eq(5)', api.table().footer()).html(APlan);
            $('tr:eq(0) th:eq(6)', api.table().footer()).html(AActual);
            $('tr:eq(0) th:eq(7)', api.table().footer()).html(Math.round(APercent) + '%');

            $('tr:eq(1) th:eq(1)', api.table().footer()).html('Grand Total');
            $('tr:eq(1) th:eq(2)', api.table().footer()).html(GTDPlan);
            $('tr:eq(1) th:eq(3)', api.table().footer()).html(GTDActual);
            $('tr:eq(1) th:eq(4)', api.table().footer()).html(Math.round(GTDPercent) + '%');
            $('tr:eq(1) th:eq(5)', api.table().footer()).html(GTAPlan);
            $('tr:eq(1) th:eq(6)', api.table().footer()).html(GTAActual);
            $('tr:eq(1) th:eq(7)', api.table().footer()).html(Math.round(GTAPercent) + '%');
        }
    });

    childTable4 = $('#' + id3).DataTable({
        processing: true,
        serverSide: true,
        paging: false,
        searching: false,
        scrollX: false,
        info: false,
        ajax: {
            url: "frmManningSchedule.aspx/SP_Call",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: function (d) {
                var currDate = parseInt(id.split('md')[1]) + parseInt(1);
                var param = {
                    Action: "shift",
                    Year: $('#yearparam').val(),
                    WorkWeek: $('#weeknoparam').val(),
                    DayNo: currDate,
                    Filter: 'NS',
                    Generate: generate
                };

                d._ms = param;

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
                title: "Night Shift",
                data: "Position",
                width: '13.57%'
            },
            {
                title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Plan</a></h5><span class= "text-muted font-13" > Direct</span>',
                data: "DirectPlan",
                width: '13.57%',
            },
            {
                title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Actual</a></h5><span class= "text-muted font-13" > Direct</span>',
                data: "DirectActual",
                width: '13.57%',
                className: 'editable ' + isView
            },
            {
                title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Percentage</a></h5><span class= "text-muted font-13" > Direct</span>',
                data: "DirectPercent",
                width: '13.57%'
            },
            {
                title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Plan</a></h5><span class= "text-muted font-13" > Agency</span>',
                data: "AgencyPlan",
                width: '13.57%',
            },
            {
                title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Actual</a></h5><span class= "text-muted font-13" > Agency</span>',
                data: "AgencyActual",
                width: '13.57%',
                className: 'editable ' + isView
            },
            {
                title: '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Percentage</a></h5><span class= "text-muted font-13" > Agency</span>',
                data: "AgencyPercent",
                width: '13.57%'
            }
        ],
        footerCallback: function (row, data, start, end, display) {
            var api = this.api(), data;

            var intVal = function (i) {
                return typeof i === 'string' ?
                    i.replace(/[\$,%]/g, '') * 1 :
                    typeof i === 'number' ?
                        i : 0;
            };

            var DPlan = api
                .column(3)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var DActual = api
                .column(4)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var DPercent = DPlan == 0 ? 0 : (parseFloat(DActual) / parseFloat(DPlan)) * 100;
            DPercent = DPercent || 0;

            var APlan = api
                .column(6)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var AActual = api
                .column(7)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var APercent = APlan == 0 ? 0 : (parseFloat(AActual) / parseFloat(APlan)) * 100;
            APercent = APercent || 0;

            $(api.column(2).footer()).html('Total');
            $(api.column(3).footer()).html(DPlan);
            $(api.column(4).footer()).html(DActual);
            $(api.column(5).footer()).html(Math.round(DPercent) + '%');
            $(api.column(6).footer()).html(APlan);
            $(api.column(7).footer()).html(AActual);
            $(api.column(8).footer()).html(Math.round(APercent) + '%');
        }
    });

    childTable5 = $('#' + id4).DataTable({
        processing: true,
        serverSide: true,
        paging: false,
        searching: false,
        scrollX: false,
        info: false,
        ajax: {
            url: "frmManningSchedule.aspx/SP_Call",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: function (d) {
                var currDate = parseInt(id.split('md')[1]) + parseInt(1);
                var param = {
                    Action: "shiftdesignation",
                    Year: $('#yearparam').val(),
                    WorkWeek: $('#weeknoparam').val(),
                    DayNo: currDate,
                    Filter: 'NS',
                    Generate: generate
                };

                d._ms = param;

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
                data: "Position",
                width: '13.57%'
            },
            {
                data: "DirectPlan",
                width: '13.57%',
            },
            {
                data: "DirectActual",
                width: '13.57%',
                className: 'editable ' + isView
            },
            {
                data: "DirectPercent",
                width: '13.57%'
            },
            {
                data: "AgencyPlan",
                width: '13.57%',
            },
            {
                data: "AgencyActual",
                width: '13.57%',
                className: 'editable ' + isView
            },
            {
                data: "AgencyPercent",
                width: '13.57%'
            }
        ],
        footerCallback: function (row, data, start, end, display) {
            var api = this.api(), data;

            var intVal = function (i) {
                return typeof i === 'string' ?
                    i.replace(/[\$,%]/g, '') * 1 :
                    typeof i === 'number' ?
                        i : 0;
            };

            var DPlan = api
                .column(3)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var DActual = api
                .column(4)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var DPercent = DPlan == 0 ? 0 : (parseFloat(DActual) / parseFloat(DPlan)) * 100;
            DPercent = DPercent || 0;

            var APlan = api
                .column(6)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var AActual = api
                .column(7)
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);

            var APercent = APlan == 0 ? 0 : (parseFloat(AActual) / parseFloat(APlan)) * 100;
            APercent = APercent || 0;

            setTimeout(function () {
                var GTDPlan = parseInt($('#f' + id3 + ' th:eq(2)').html()) + parseInt(DPlan);
                var GTDActual = parseInt($('#f' + id3 + ' th:eq(3)').html()) + parseInt(DActual);
                var GTDPercent = GTDPlan == 0 ? 0 : (GTDActual / GTDPlan) * 100;
                GTDPercent = GTDPercent || 0;
                var GTAPlan = parseInt($('#f' + id3 + ' th:eq(5)').html()) + parseInt(APlan);
                var GTAActual = parseInt($('#f' + id3 + ' th:eq(6)').html()) + parseInt(AActual);
                var GTAPercent = GTAPlan == 0 ? 0 : (GTAActual / GTAPlan) * 100;
                GTAPercent = GTAPercent || 0;

                var WDDPlan = parseInt($('#fg' + id2 + ' th:eq(2)').html()) + parseInt(GTDPlan);
                var WDDActual = parseInt($('#fg' + id2 + ' th:eq(3)').html()) + parseInt(GTDActual);
                var WDDPercent = WDDPlan == 0 ? 0 : (parseFloat(WDDActual) / parseFloat(WDDPlan)) * 100;
                WDDPercent = WDDPercent || 0;
                var WDAPlan = parseInt($('#fg' + id2 + ' th:eq(5)').html()) + parseInt(GTAPlan);
                var WDAActual = parseInt($('#fg' + id2 + ' th:eq(6)').html()) + parseInt(GTAActual);
                var WDAPercent = WDAPlan == 0 ? 0 : (parseFloat(WDAActual) / parseFloat(WDAPlan)) * 100;
                WDAPercent = WDAPercent || 0;

                $('tr:eq(0) th:eq(1)', api.table().footer()).html('Total');
                $('tr:eq(0) th:eq(2)', api.table().footer()).html(DPlan);
                $('tr:eq(0) th:eq(3)', api.table().footer()).html(DActual);
                $('tr:eq(0) th:eq(4)', api.table().footer()).html(Math.round(DPercent) + '%');
                $('tr:eq(0) th:eq(5)', api.table().footer()).html(APlan);
                $('tr:eq(0) th:eq(6)', api.table().footer()).html(AActual);
                $('tr:eq(0) th:eq(7)', api.table().footer()).html(Math.round(APercent) + '%');

                $('tr:eq(1) th:eq(1)', api.table().footer()).html('Grand Total');
                $('tr:eq(1) th:eq(2)', api.table().footer()).html(GTDPlan);
                $('tr:eq(1) th:eq(3)', api.table().footer()).html(GTDActual);
                $('tr:eq(1) th:eq(4)', api.table().footer()).html(Math.round(GTDPercent) + '%');
                $('tr:eq(1) th:eq(5)', api.table().footer()).html(GTAPlan);
                $('tr:eq(1) th:eq(6)', api.table().footer()).html(GTAActual);
                $('tr:eq(1) th:eq(7)', api.table().footer()).html(Math.round(GTAPercent) + '%');

                $('tr:eq(2) th:eq(1)', api.table().footer()).html('WHOLE DAY');
                $('tr:eq(2) th:eq(2)', api.table().footer()).html(WDDPlan);
                $('tr:eq(2) th:eq(3)', api.table().footer()).html(WDDActual);
                $('tr:eq(2) th:eq(4)', api.table().footer()).html(Math.round(WDDPercent) + '%');
                $('tr:eq(2) th:eq(5)', api.table().footer()).html(WDAPlan);
                $('tr:eq(2) th:eq(6)', api.table().footer()).html(WDAActual);
                $('tr:eq(2) th:eq(7)', api.table().footer()).html(Math.round(WDAPercent) + '%');
            }, 1000);
        }
    });
}

function machineTable() {
    //table.clear().draw();
    table.destroy();

    var data = [
        { Date: "Monday|0", Day: 1 },
        { Date: "Tuesday|1", Day: 2 },
        { Date: "Wednesday|2", Day: 3 },
        { Date: "Thursday|3", Day: 4 },
        { Date: "Friday|4", Day: 5 },
        { Date: "Saturday|5", Day: 6 },
        { Date: "Sunday|6", Day: 7 },
    ]

    table = $('#masterTableMachine').DataTable({
        paging: false,
        //searching: false,
        scrollX: false,
        info: false,
        data: data,
        columns: [
            {
                className: 'details-control',
                orderable: false,
                data: null,
                defaultContent: '',
                title: "",
                width: "5%"
            },
            {
                title: "Date",
                data: "Date",
                width: '80%',
                orderable: false,
                render: function (d) {
                    let paramYear = $('#yearparam').val();
                    let paramWorkWeek = $('#weeknoparam').val();
                    let data = d.split('|')[0];
                    let count = d.split('|')[1];
                    let d1 = getDateOfISOWeek(paramWorkWeek, paramYear);

                    var output = '<h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">' + data + '</a></h5><span class="text-muted font-13">' + moment(d1).add(count, 'days').format('LL'); + '</span>';
                    return output;
                }
            },
            {
                title: "Day",
                data: "Day",
                visible: false
            }
        ]
    });
    

    if (entry == 'N') {
        table.columns.adjust().draw();
    }
    else {
        var filteredArray = table.column(2).data().filter(function (value, index) {
            console.log(value == dayno);

            return value == dayno ? true : false;
        }).draw();

        $.fn.dataTableExt.afnFiltering.push(
            function (oSettings, aData, iDataIndex) {
                return aData[2] == dayno;
            }
        );

        table.draw();

        $('#masterTableMachine tbody td.details-control').click();

        if (entry == 'V') $('.editable').css({ "background-color": "transparent !important", "cursor": "pointer !important" }); 
        //$('#masterTableMachine tbody').on('click', 'td.details-control'
    }
}

// Return table with id generated from row's name field
function format(id) {
    var childTable = '<table id="' + id + '" class="table table-centered ' + id + '" width="100%">' +
        //'<thead style="display:none"></thead >' +
        '</table>';
    return $(childTable).toArray();
}

function format2(id) {
    var childTable = '<table id="' + id + '" class="table tablechild table-centered' + id + '" width="100%">' +
        '<tfoot style="text-align:inherit"><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tfoot>' +
        '</table>';
    return $(childTable).toArray();
}

function format3(id, id2, id3, id4) {
    var childTable = '<table id="' + id + '" class="table tablechild table-centered' + id + '" width="100%">' +
        '<tfoot style="text-align:inherit"><tr id="f' + id + '"><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr></tfoot>' +
        '</table>' +
        '<table id="' + id2 + '" class="table table-centered hideheader ' + id2 + '" width="100%">' +
        '<thead></thead>' +
        '<tfoot style="text-align:inherit">' +
        '<tr id="f' + id2 + '"><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr>' +
        '<tr id="fg' + id2 + '"><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr>' +
        '</tfoot > ' +
        '</table>' +
        '<table id="' + id3 + '" class="table table-centered' + id3 + '" width="100%">' +
        '<tfoot style="text-align:inherit"><tr id="f' + id3 + '"><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr></tfoot>' +
        '</table>' +
        '<table id="' + id4 + '" class="table table-centered hideheader ' + id4 + '" width="100%">' +
        '<thead></thead>' +
        '<tfoot style="text-align:inherit">' +
        '<tr id="f' + id4 + '"><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr>' +
        '<tr id="fg' + id4 + '"><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr>' +
        '<tr><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr>' +
        '</tfoot>' +
        '</table>';
    return $(childTable).toArray();
}

function createSelect() {
    var respo;
    let items = '<option value="" disabled="disabled">Positions</option>';
    $.ajax({
        type: "POST",
        url: "frmManningSchedule.aspx/SP_Call",
        data: {},
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var data = JSON.parse(data.d);
            for (var i = 0; i < data.length; i++) {
                items += "<option value='" + data[i].Position + "' id='" + data[i].Position + "'>" + data[i].Position + "</option>";
            };

            options = items;
            
            //$('.DayShiftSelect').html(items);

            //$('.DayShiftSelect').select2({
            //    width: "100%",
            //    dropdownCssClass: "dropdown",
            //    templateResult: templateResult,
            //    templateSelection: templateSelection,
            //    matcher: matchStart
            //});

            //$('.DayShiftSelect').val().change();
        },
        error: function (err) {
            alert(err);
        }
    });
    return respo;
}

// Select 2 Funtion
function templateSelection(result) {
    return result.id;
}

// Select 2 Funtion
function templateResult(result) {
    var $result = $(
        '<div class="row m-0 p-0">' +
            '<div class="col-md-12 m-0 p-0">' + result.text + '</div>' +
        '</div>'
    );
    return $result;
}

// Select 2 Funtion
function matchStart(params, data) {
    // If there are no search terms, return all of the data
    if ($.trim(params.term) === '') { return data; }

    // Do not display the item if there is no 'text' property
    if (typeof data.text === 'undefined') { return null; }

    // `params.term` is the user's search term
    // `data.id` should be checked against
    // `data.text` should be checked against
    var q = params.term.toLowerCase();
    if (data.text.toLowerCase().indexOf(q) > -1 || data.id.toLowerCase().indexOf(q) > -1) {
        return $.extend({}, data, true);
    }

    // Return `null` if the term should not be displayed
    return null;
}

// Function yearParameter, to set options of Year Parameter
function yearParameter() {
    $.ajax({
        type: 'POST',
        url: 'frmManningSchedule.aspx/YearParameter',
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

// Function weekParameter, to set options of Week Parameter
function weekParameter() {
    $.ajax({
        type: 'POST',
        url: 'frmManningSchedule.aspx/WeekParameter',
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

// Function weekParameter, to set options of Week Parameter
function daynoParameter() {
    let action = {
        Year: $('#yearparam').val(),
        WorkWeek: $('#weeknoparam').val(),
        Action: 'DayNoParam'
    }

    $.ajax({
        type: 'POST',
        url: 'frmManningSchedule.aspx/SP_Call',
        contentType: 'application/json',
        dataType: 'json',
        data: '{_ms:' + JSON.stringify(action) + '}',
        success: function (data) {
            var data = JSON.parse(data.d);
            var d = new Date();
            var n = d.getDay() == 0 ? 7 : d.getDay();
            var options = "";
            data.forEach(function (item, index) {
                var selected = item.DayNo == n ? "selected='selected'" : "";

                options += "<option value='" + item.DayNo + "' " + selected + ">" + item.DayNo + "</option>";
            });

            $('#daynoparam').html(options);
            $("#paramDayNo").text($('#daynoparam').val());
        },
        error: function (err) {
            console.log(err);
        }
    });
}

// Function Check Status
function status(year, workweek) {

    let Dayno = entry == 'N' ? "" : dayno;

    var action = {
        Year: year,
        WorkWeek: workweek,
        Dayno,
        Action: 'status'
    }

    $.ajax({
        url: "frmManningSchedule.aspx/SP_Call",
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        data: '{_ms:' + JSON.stringify(action) + '}',
        success: function (data) {
            var data = JSON.parse(data.d);


            if (data.length == 0) data.push({ isGenerated: 0, isFinalized: 0}); 

            // For Generate Button
            (data[0].isGenerated > 0) ? $('#generateBtn').css("display", "none") : $('#generateBtn').css("display", "unset");

            // For Finalize Button
            (data[0].isFinalized > 0 || data[0].isGenerated == 0) ? $('#finalizeBtn').css("display", "none") : $('#finalizeBtn').css("display", "unset");

            let withDay = entry == 'N' ? year + "-" + workweek : year + "-" + workweek + "-" + dayno; 

            // For Finalized Status
            if (data[0].isFinalized == 1) $("#final").html("This work week [" + withDay + "] of Manning Schedule is already finalized on " + moment(data[0].FinalizedDate).format('LLL')).removeAttr("class").addClass("badge badge-success-lighten");
            if (data[0].isGenerated == 1 && data[0].isFinalized == 0) $("#final").html("This work week [" + withDay + "] of Manning Schedule is already generated on " + moment(data[0].GeneratedDate).format('LLL')).removeAttr("class").addClass("badge badge-info-lighten");
            if (data[0].isGenerated == 0 && data[0].isFinalized == 0) $("#final").html("This work week [" + withDay + "] of Manning Schedule is not generated").removeAttr("class").addClass("badge badge-danger-lighten");

            // Is Generated/Is Finalized Status
            generate = (data[0].isGenerated > 0) ? 1 : 0;
            finalized = (data[0].isFinalized > 0) ? 1 : 0;

            machineTable(); // Table for Machine
            //manpowerSpecificTable(year, workweek); // Table for Manpower Specific
            //manpowerGeneralTable(year, workweek); // Table for Manpower General
        }
    });
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