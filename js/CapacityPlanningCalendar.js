var calendar;
var date = (new Date()).toISOString().split('T')[0]+'T';
var title;
var resources;
var events;
let isCP;

document.addEventListener('DOMContentLoaded', function () {

    const urlString = window.location.href;
    const url = new URL(urlString);
    const transtype = url.searchParams.get("transtype");

    if (transtype == "PRDMSC") document.title = "Manning Schedule Calendar";

    title = transtype != "PRDMSC" ? "Machines" : "Manpower";

    var action = transtype != "PRDMSC" ? { action: 'machineresources' } : { action: 'manpowerresourcesall' };
    var action1 = transtype != "PRDMSC" ? { action: 'machineevents' } : { action: 'manpowerevents' };

    $.ajax({
        url: "frmCapacityPlanningCalendar.aspx/SP_Call",
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        data: '{_cp:' + JSON.stringify(action) + '}',
        success: function (data) {
            var data = JSON.parse(data.d);
            resources = data;

            $.ajax({
                url: "frmCapacityPlanningCalendar.aspx/SP_Call",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: '{_cp:' + JSON.stringify(action1) + '}',
                success: function (data) {
                    var data = JSON.parse(data.d);
                    var startHrs = 0;
                    var endHrs = 0;
                    var eventarray = [];

                    data.forEach(function (item) {
                        endHrs += item.Hr;
                        var start = moment(getDateOfISOWeek(item.WorkWeek, item.Year)).add(item.DayNo - 1, 'days').add(startHrs, 'hours').format();
                        var end = moment(getDateOfISOWeek(item.WorkWeek, item.Year)).add(item.DayNo - 1, 'days').add(endHrs, 'hours').format();
                        var resourceId = item.resourceId;
                        var resourceGroupField = item.resourceGroupField;
                        var title = item.title;
                        var color = item.color;
                        var RecordID = item.RecordID;
                        startHrs += item.Hr;

                        eventarray.push(
                            {
                                resourceId,
                                resourceGroupField,
                                title,
                                start,
                                end,
                                color,
                                extendedProps: {
                                    RecordID,
                                    resourceId
                                }
                            }
                        );
                    });

                    events = eventarray;

                    isCP = transtype != "PRDMSC" ?
                        "<button class='fc-button fc-button-primary custom fc-button-active' type='button' id='machine'>Machines</button>" +
                        "<button class='fc-button fc-button-primary custom' type='button' id='summary'>Summary</button>" +
                        "<button class='fc-button fc-button-primary custom' type='button' id='manpower'>Manpower</button>" :
                        "<button class='fc-button fc-button-primary custom d-none' type='button' id='manpowerd'>Day Shift</button>" +
                        "<button class='fc-button fc-button-primary custom d-none' type='button' id='manpowern'>Night Shift</button>";

                    var tablesGroup = "<div class='fc-button-group'>" +
                        isCP +
                        "</div>";

                    calendar1(tablesGroup);

                    $('#calendar').removeAttr("class");

                    var defaultVal = transtype != "PRDMSC" ? "calendar-machine" : "calendar-manpower";

                    $('#calendar').attr("class", "container-fluid p-2 fc fc-media-screen fc-direction-ltr fc-theme-standard " + defaultVal);
                }
            });
        }
    });

    // Add Customized Buttons
    //var tablesGroup = "<div class='fc-button-group'>" +
    //                    "<button class='fc-button fc-button-primary custom fc-button-active' type='button' id='machine'>Machines</button>" + 
    //                    "<button class='fc-button fc-button-primary custom' type='button' id='summary'>Summary</button>" + 
    //                    "<button class='fc-button fc-button-primary custom' type='button' id='manpower'>Manpower</button>" + 
    //    "</div>";
    ////if (resp)
    //    calendar1(tablesGroup);
});

// -- FUNCTIONS START -- //

// Run Calendar Data
function calendar1(tablesGroup, grouping = "") {
    const urlString = window.location.href;
    const url = new URL(urlString);
    const transtype = url.searchParams.get("transtype") ?? "";
    let header = "";

    let initialV = transtype != "PRDMSC" ? "resourceTimelineDay" : "customWeek";
    
    $.ajax({
        url: "frmCapacityPlanningCalendar.aspx/InitialTime",
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        success: function (resp) {
            var resp = JSON.parse(resp.d);
            header = {
                type: 'resourceTimelineWeek',
                buttonText: 'Day',
                scrollTime: resp[0].Value
            };

            DynamicCalendar(initialV, header, tablesGroup, grouping, transtype);
        },
        error: function (err) {
            alert(error);
        }
    });
}

// Dynamic Calendar
function DynamicCalendar(initialV, header, tablesGroup, grouping, transtype) {
    const calendarEl = document.getElementById('calendar');

    let group = transtype == "PRDMSC" ? "resourceGroupField" : "";

    let resourceTimelineDay = {
        type: 'resourceTimelineWeek',
        buttonText: 'Day'
    }

    if (header != null) resourceTimelineDay = header;

    calendar = new FullCalendar.Calendar(calendarEl, {
        timeZone: 'PHT',
        initialView: initialV,
        aspectRatio: 1.5,
        headerToolbar: {
            left: 'today prev,next',
            center: 'title',
            right: 'resourceTimelineDay,customWeek'
        },
        firstDay: 1,
        views: {
            customWeek: {
                type: 'resourceTimelineWeek',
                duration: { weeks: 1 },
                slotDuration: { days: 1 },
                buttonText: 'Week',
                displayEventTime: false
            },
            resourceTimelineDay: resourceTimelineDay
        },
        editable: false,
        resourceAreaHeaderContent: title,
        resourceGroupField: group,
        resources: resources,
        events: events,
        eventClick: function (info) {
            var data = info.event.extendedProps;
            var dateStart = moment(info.event._instance.range.start).subtract(8, 'hours').format('lll');
            var dateEnd = moment(info.event._instance.range.end).subtract(8, 'hours').format('lll');
            var isMachine = $('#calendar.calendar-machine').length;
            var isSummary = $('#calendar.calendar-summary').length;
            var isManpower = $('#calendar.calendar-manpower').length;

            if (isMachine > 0) {
                var action = { action: 'machineview', filter: data.RecordID };

                $.ajax({
                    url: "frmCapacityPlanningCalendar.aspx/SP_Call",
                    type: "POST",
                    contentType: "application/json",
                    dataType: "json",
                    data: '{_cp:' + JSON.stringify(action) + '}',
                    success: function (resp) {
                        var resp = JSON.parse(resp.d);

                        $('#processData').html(resp[0].Process);
                        $('#skuData').html(resp[0].title);
                        $('#BOMData').html(resp[0].BOM);
                        $('#machineData').html(resp[0].machine);
                        $('#manpowerData').html(resp[0].NoMan);
                        $('#machineModal').modal('show');
                    }
                });
                return;
            }

            if (isSummary > 0) {
                var action = { action: 'summaryview', filter: data.RecordID };

                $.ajax({
                    url: "frmCapacityPlanningCalendar.aspx/SP_Call",
                    type: "POST",
                    contentType: "application/json",
                    dataType: "json",
                    data: '{_cp:' + JSON.stringify(action) + '}',
                    success: function (resp) {
                        var resp = JSON.parse(resp.d);
                        var endHrs = 0;
                        var startHrs = 0;
                        var body = "";

                        resp.forEach(function (d) {
                            endHrs += d.Duration;
                            var start = moment(getDateOfISOWeek(d.WorkWeek, d.Year)).add(d.DayNo - 1, 'days').add(startHrs, 'hours').format('LLL');
                            var end = moment(getDateOfISOWeek(d.WorkWeek, d.Year)).add(d.DayNo - 1, 'days').add(endHrs, 'hours').format('LLL');
                            startHrs += d.Duration;
                            var Schudule = start + ' - ' + end;


                            body += "<tr> " +
                                "<td>" + d.Sequence + "</td>" +
                                "<td>" + d.Machine + "</td>" +
                                "<td>" + Schudule + "</td>" +
                                "<td>" + d.Duration + "</td>" +
                                "</tr > ";
                        });

                        $('#summaryModal table tbody').html(body);
                        $('#summaryModal').modal('show');
                    }
                });
                return;
            }

            if (isManpower > 0) {
                if (transtype == "PRDMSC") {
                    var action = { action: 'manpowerview1', filter: data.RecordID };
                    $.ajax({
                        url: "frmCapacityPlanningCalendar.aspx/SP_Call",
                        type: "POST",
                        contentType: "application/json",
                        dataType: "json",
                        data: '{_cp:' + JSON.stringify(action) + '}',
                        success: function (resp) {
                            var resp = JSON.parse(resp.d);
                            var body = "";
                            console.log(resp[0].SubmittedDate)
                            if (resp[0].SubmittedDate == "" || resp[0].SubmittedDate == null) {
                                resp.forEach(function (obj) {
                                    body += "<tr><td class='d-none'><input class='form-control form-control-sm getData' type='text' value='" + obj.RecordID + "' /></td>";
                                    body += "<td><input class='form-control form-control-sm' type='text' value='" + obj.ProcessCode + "' disabled /></td>";
                                    body += "<td><input class='form-control form-control-sm' type='text' value='" + obj.DPlan + "' disabled /></td>";
                                    body += "<td><input class='form-control form-control-sm getData' type='number' min='0' value='" + obj.DActual + "' /></td>";
                                    body += "<td><input class='form-control form-control-sm' type='text' value='" + obj.APlan + "' disabled /></td>";
                                    body += "<td><input class='form-control form-control-sm getData' type='number' min='0' value='" + obj.AActual + "' /></td>";
                                    body += "<td style='width:150px; text-align:center'><button type='button' class='btn btn-success editManpowerBtn' data-id='" + obj.RecordID + "' style='font-size: small'>Save Changes</button></td></tr>";
                                });

                                $('#manpowerModal1 table tbody').html(body);
                                $('#manpowerModal1').modal('show');
                            }
                            else {
                                Swal.fire(
                                    'Unable to Edit',
                                    `Submitted Date: ${moment(resp[0].SubmittedDate).format('MMMM Do YYYY, h:mm:ss a')}`,
                                    'info'
                                )
                            }
                        }
                    });
                }
                else {
                    var action = { action: 'manpowerview', filter: data.RecordID };

                    $.ajax({
                        url: "frmCapacityPlanningCalendar.aspx/SP_Call",
                        type: "POST",
                        contentType: "application/json",
                        dataType: "json",
                        data: '{_cp:' + JSON.stringify(action) + '}',
                        success: function (resp) {
                            var resp = JSON.parse(resp.d);
                            var body = "";

                            var here = resp.reduce(function (r, a) {
                                r[a.Machines] = r[a.Machines] || [];
                                r[a.Machines].push(a);
                                return r;
                            }, Object.create(null));

                            var index = [];
                            for (var x in here) {
                                index.push(x);
                            }

                            index.forEach(function (item, index) {
                                var Position = "";
                                var Total = 0;
                                var NoManpower = "";

                                here[item].forEach(function (d) {
                                    if (item = d.Machines) {
                                        Position += "<div class='col-12'>" + d.Position + "</div>";
                                        NoManpower += "<div class='col-12 editableManpower' data-noman='" + d.NoManpower + "' data-id='" + item + "'>" + d.NoManpower + "</div>";
                                        Total += d.NoManpower;
                                    }
                                });

                                body += "<tr>" +
                                    //"<td>" + item + "</td>" +
                                    "<td>" + Position + "</td>" +
                                    "<td>" + NoManpower + "</td>" +
                                    "<td>" + Total + "</td>" +
                                    "</tr > ";
                            });

                            let editManpower = transtype != "PRDMSC" ? "" :
                                "<button id='editManpowerBtn' class='btn btn-sm btn-success'>Edit Manpower</button>";

                            $('#manpowerModal table tbody').html(body);
                            $('#manpowerModal').modal('show');
                            $('#manpowerModal .modal-header').html(editManpower);
                        }
                    });
                }

                return;
            }
        }
    });
    calendar.render();

    if (transtype == "PRDMSC") $(".fc-resourceTimelineDay-button").addClass("d-none");

    $('.fc-header-toolbar .fc-toolbar-chunk:first-child').append(tablesGroup);
}

// Get Data
function Data(action, filter = "") {
    var data;

    if (!action == 'summaryevent') {
        data = { action: action }
    }
    else {
        data = { action: action, SKUCode: filter }
    }

    return $.ajax({
        url: "frmCapacityPlanningCalendar.aspx/SP_Call",
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        data: '{_cp:' + JSON.stringify(data) + '}',
        success: function (data) {
            var data = JSON.parse(data.d);

            resources = data;
        }
    });
}

// Get Date
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

// Get Random Color
function randColor() {
    return Math.floor(Math.random() * 16777215).toString(16);
}

// Function to get WorkWeek
Date.prototype.getWeek = function () {
    var onejan = new Date(this.getFullYear(), 0, 1);
    var today = new Date(this.getFullYear(), this.getMonth(), this.getDate());
    var dayOfYear = ((today - onejan + 1) / 86400000);
    return Math.ceil(dayOfYear / 7)
};

function Percent(data) {
    return data + '%';
}

// -- FUNCTIONS END -- //


// -- EVENTS START -- //

// Machine Data
$("body").on("click", "#machine", function() {

    title = 'Machines';
    var action = { action: 'machineresources' };
    var action1 = { action: 'machineevents' };

    $.ajax({
        url: "frmCapacityPlanningCalendar.aspx/SP_Call",
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        data: '{_cp:' + JSON.stringify(action) + '}',
        success: function (data) {
            var data = JSON.parse(data.d);

            resources = data;

            $.ajax({
                url: "frmCapacityPlanningCalendar.aspx/SP_Call",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: '{_cp:' + JSON.stringify(action1) + '}',
                success: function (data) {
                    var data = JSON.parse(data.d);
                    let startHrs = 0;
                    let endHrs = 0;
                    let eventarray = [];

                    data.forEach(function (item) {
                        endHrs += item.Hr;
                        let start = moment(getDateOfISOWeek(item.WorkWeek, item.Year)).add(item.DayNo - 1, 'days').add(startHrs, 'hours').format();
                        let end = moment(getDateOfISOWeek(item.WorkWeek, item.Year)).add(item.DayNo - 1, 'days').add(endHrs, 'hours').format();
                        let resourceId = item.resourceId;
                        let title = item.title;
                        let color = item.color
                        startHrs += item.Hr;

                        eventarray.push(
                            {
                                resourceId,
                                title,
                                start,
                                end,
                                color,
                                extendedProps: {
                                    RecordID: item.RecordID
                                }
                            }
                        );
                    });

                    events = eventarray;
                    calendar.destroy();

                    var tablesGroup = "<div class='fc-button-group'>" +
                        "<button class='fc-button fc-button-primary custom fc-button-active' type='button' id='machine'>Machines</button>" +
                        "<button class='fc-button fc-button-primary custom' type='button' id='summary'>Summary</button>" +
                        "<button class='fc-button fc-button-primary custom' type='button' id='manpower'>Manpower</button>" +
                        "</div>";

                    calendar1(tablesGroup);

                    $('#calendar').removeAttr("class");
                    $('#calendar').attr("class", "container-fluid p-2 calendar-machine fc fc-media-screen fc-direction-ltr fc-theme-standard");
                }
            });
        }
    });
});

// Summary Data
$("body").on("click", "#summary", function() {
    title = 'Summary';

    var action = { action: 'summaryresources' };
    var action1 = { action: 'summaryevent' };

    $.ajax({
        url: "frmCapacityPlanningCalendar.aspx/SP_Call",
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        data: '{_cp:' + JSON.stringify(action) + '}',
        success: function (data) {
            var data = JSON.parse(data.d);

            resources = data;

            $.ajax({
                url: "frmCapacityPlanningCalendar.aspx/SP_Call",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: '{_cp:' + JSON.stringify(action1) + '}',
                success: function (data) {
                    var data = JSON.parse(data.d);
                    var startHrs = 0;
                    var endHrs = 0;
                    var eventarray = [];

                    data.forEach(function (item) {
                        endHrs += item.Hr;
                        var start = moment(getDateOfISOWeek(item.WorkWeek, item.Year)).add(item.DayNo - 1, 'days').add(startHrs, 'hours').format();
                        var end = moment(getDateOfISOWeek(item.WorkWeek, item.Year)).add(item.DayNo - 1, 'days').add(endHrs, 'hours').format();
                        var resourceId = item.resourceId;
                        var title = item.title;
                        var color = '#' + randColor();
                        startHrs += item.Hr;

                        eventarray.push(
                            {
                                resourceId,
                                title,
                                start,
                                end,
                                color,
                                extendedProps: {
                                    RecordID: item.RecordID
                                }
                            }
                        );
                    });

                    events = eventarray;
                    calendar.destroy();

                    var tablesGroup = "<div class='fc-button-group'>" +
                        "<button class='fc-button fc-button-primary custom' type='button' id='machine'>Machines</button>" +
                        "<button class='fc-button fc-button-primary custom fc-button-active' type='button' id='summary'>Summary</button>" +
                        "<button class='fc-button fc-button-primary custom' type='button' id='manpower'>Manpower</button>" +
                        "</div>";

                    calendar1(tablesGroup, "grp");

                    $('#calendar').removeAttr("class");
                    $('#calendar').attr("class", "container-fluid p-2 calendar-summary fc fc-media-screen fc-direction-ltr fc-theme-standard");
                }
            });
        }
    });
});

// Manpower Data
$("body").on("click", "#manpower", function() {

    title = 'Manpower';
    var action = { action: 'manpowerresources' };
    var action1 = { action: 'manpowerevent' };

    $.ajax({
        url: "frmCapacityPlanningCalendar.aspx/SP_Call",
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        data: '{_cp:' + JSON.stringify(action) + '}',
        success: function (data) {
            var data = JSON.parse(data.d);

            resources = data;

            $.ajax({
                url: "frmCapacityPlanningCalendar.aspx/SP_Call",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: '{_cp:' + JSON.stringify(action1) + '}',
                success: function (data) {
                    var data = JSON.parse(data.d);
                    var startHrs = 0;
                    var endHrs = 0;
                    var eventarray = [];

                    data.forEach(function (item) {
                        endHrs += item.Hr;
                        var start = moment(getDateOfISOWeek(item.WorkWeek, item.Year)).add(item.DayNo - 1, 'days').add(startHrs, 'hours').format();
                        var end = moment(getDateOfISOWeek(item.WorkWeek, item.Year)).add(item.DayNo - 1, 'days').add(endHrs, 'hours').format();
                        var resourceId = item.resourceId;
                        var title = item.title;
                        var color = '#' + randColor();
                        startHrs += item.Hr;

                        eventarray.push(
                            {
                                resourceId,
                                title,
                                start,
                                end,
                                color,
                                extendedProps: {
                                    RecordID: item.RecordID
                                }
                            }
                        );
                    });

                    events = eventarray;
                    calendar.destroy();

                    var tablesGroup = "<div class='fc-button-group'>" +
                        "<button class='fc-button fc-button-primary custom' type='button' id='machine'>Machines</button>" +
                        "<button class='fc-button fc-button-primary custom' type='button' id='summary'>Summary</button>" +
                        "<button class='fc-button fc-button-primary custom fc-button-active' type='button' id='manpower'>Manpower</button>" +
                        "</div>";

                    calendar1(tablesGroup);

                    $('#calendar').removeAttr("class");
                    $('#calendar').attr("class", "container-fluid p-2 calendar-manpower fc fc-media-screen fc-direction-ltr fc-theme-standard");
                }
            });
        }
    });
});

// Manpower Day/Night Shift Data
$("body").on("click", ".custom", function () {
    let manpowerShift = $(this);
    let action;
    let action1;

    action = { action: 'manpowerresourcesall' };

    if (manpowerShift.attr('id') == "manpowerd") {
        title = 'Manpower Day Shift';
        action1 = { action: 'manpowerevent' };
    }
    else if (manpowerShift.attr('id') == "manpowern") {
        title = 'Manpower Night Shift';
        action1 = { action: 'manpowerevent' };
    }
    else {
        return false;
    }

    $.ajax({
        url: "frmCapacityPlanningCalendar.aspx/SP_Call",
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        data: '{_cp:' + JSON.stringify(action) + '}',
        success: function (data) {
            var data = JSON.parse(data.d);

            resources = data;

            $.ajax({
                url: "frmCapacityPlanningCalendar.aspx/SP_Call",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                data: '{_cp:' + JSON.stringify(action1) + '}',
                success: function (data) {
                    var data = JSON.parse(data.d);
                    var startHrs = 0;
                    var endHrs = 0;
                    var eventarray = [];

                    data.forEach(function (item) {
                        endHrs += item.Hr;
                        var start = moment(getDateOfISOWeek(item.WorkWeek, item.Year)).add(item.DayNo - 1, 'days').add(startHrs, 'hours').format();
                        var end = moment(getDateOfISOWeek(item.WorkWeek, item.Year)).add(item.DayNo - 1, 'days').add(endHrs, 'hours').format();
                        var resourceId = item.resourceId;
                        var title = item.title;
                        var color = '#' + randColor();
                        startHrs += item.Hr;

                        eventarray.push(
                            {
                                resourceId,
                                title,
                                start,
                                end,
                                color,
                                extendedProps: {
                                    RecordID: item.RecordID
                                }
                            }
                        );
                    });

                    events = eventarray;
                    calendar.destroy();

                    //let buttonsD = manpowerShift.attr('id') == "manpowerd" ? "fc-button-active" : "";
                    //let buttonsN = manpowerShift.attr('id') == "manpowern" ? "fc-button-active" : "";

                    var tablesGroup = "<div class='fc-button-group'>" +
                        //"<button class='fc-button fc-button-primary custom " + buttonsD + "' type='button' id='manpowerd'>Day Shift</button>" +
                        //"<button class='fc-button fc-button-primary custom " + buttonsN + "' type='button' id='manpowern'>Night Shift</button>";
                        "</div>";

                    calendar1(tablesGroup);

                    $('#calendar').removeAttr("class");
                    $('#calendar').attr("class", "container-fluid p-2 calendar-manpower fc fc-media-screen fc-direction-ltr fc-theme-standard");
                }
            });
        }
    });
});

$("body").on("click", ".editManpowerBtn", function () {
    let filter = $(this).closest('tr').find('.getData').eq(0).val();
    let DActual = $(this).closest('tr').find('.getData').eq(1).val();
    let AActual = $(this).closest('tr').find('.getData').eq(2).val();

    let action = { action: 'EditManpower', filter, DActual, AActual }

    $.ajax({
        url: "frmCapacityPlanningCalendar.aspx/SP_Call",
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        data: '{_cp:' + JSON.stringify(action) + '}',
        success: function (data) {
            let response = JSON.parse(data.d);

            Swal.fire(
                response[0].message,
                '',
                'success'
            )
        },
        error: function (error) {
            Swal.fire(
                "Error",
                error.message,
                'error'
            )
        }
    });
});

$("body").on("click", ".modalClose", function () {
    $('#manpowerModal1').modal('hide');
});

// -- EVENTS END -- //