let buildingFilterIsLoaded = false;
let clientFilterIsLoaded = false;
let loadingTimer = null;

// On load
$(document).ready(() => {
    toggleMain(false);
    loadingTimer = setTimeout(() => {
        playLoadingAnimation();
    }, 1000);

    createIconProgressBar('#inbound-dwell-time-chart', 0, 'mdi mdi-truck-check', 148);
    createIconProgressBar('#inbound-submission-chart', 0, 'mdi mdi-clock-check', 140);
    createCircularProgressbar('#inbound-attachment-chart', 0);

    createIconProgressBar('#outbound-dwell-time-chart', 0, 'mdi mdi-truck-check', 148);
    createIconProgressBar('#outbound-submission-chart', 0, 'mdi mdi-clock-check', 140);
    createCircularProgressbar('#outbound-attachment-chart', 0);

    createCircularProgressbar('#midbound-ira-chart', 0);
    createCircularProgressbar('#midbound-lra-chart', 0);
    createIconProgressBar('#midbound-submission-chart', 0, 'mdi mdi-clock-check', 140);

    $('#date-filter > span').text(`${moment().startOf('month').format('MMM D')} - ${moment().format('MMM D')}`);

    $('#client-filter').select2({
        width: "200px",
        closeOnSelect: true,
        templateResult: templateResult2,
        templateSelection: (result) => result.id,
        matcher: matchStart
    });

    $('#date-filter').daterangepicker(
        {
            startDate: moment().startOf('month'),
            endDate: moment(),
            opens: 'left',
            applyClass: 'btn-primary',
            cancelClass: 'btn-light-primary',
            ranges: {
                'Today': [moment(), moment()],
                'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                'This Month': [moment().startOf('month'), moment().endOf('month')],
                'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
            }
        },
        onDateRangePickerChange
    );

    // Load building options then on sucess load client options
    $.ajax({
        type: 'GET',
        cache: false,
        url: "frmKPIDashboard.aspx/GetBuildings",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: (response) => {
            let unwrappedResponse = JSON.parse(unwrapResponse(response));
            if (!unwrappedResponse.success) {
                buildingFilterIsLoaded = false;
                toggleFilters(buildingFilterIsLoaded && clientFilterIsLoaded);
                displayError(unwrappedResponse.data);
                return;
            }

            let data = JSON.parse(unwrappedResponse.data);

            $('#building-filter').empty();
            if (data.length <= 0) {
                $('#building-filter').append('<option disabled">No data</option>');
                return;
            }
            else {
                $('#building-filter').append('<option value="ALL" selected>ALL</option>');
                data.forEach((building) => {
                    $('#building-filter').append(`<option value="${building['Value']}">${building['Description']}</option>`);
                });
            }

            // Load all client filter options after loading building
            setClientFilterOptions('ALL', () => {
                // The client filter's change event will fetch and set new values for the charts.
                $('#client-filter').val(['ALL']).trigger('change');
            });
        },
        error: (_xhr, _status, error) => {
            toggleFilters(false);
            clearTimeout(loadingTimer);
            stopLoadingAnimation();
            toggleMain(true);
            displayError(error);
        }
    });
});


// Event listeners and handlers

$('#client-filter').on('select2:select', (event) => {
    if (event.params.data.id.toUpperCase() === 'ALL') {
        $('#client-filter').val(['ALL']).trigger('change');
        return;
    }

    let selected = $('#client-filter').val();
    $('#client-filter').val(selected.filter(option => option !== 'ALL')).trigger('change');
});

$('#client-filter').on('change', () => {
    const building = $('#building-filter').val();
    const clients = $('#client-filter').val();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');

    toggleMain(false);
    loadingTimer = setTimeout(() => {
        playLoadingAnimation();
    }, 1000);

    setChartsData(building, clients, dateRangeStart, dateRangeEnd);
});

$('#building-filter').on('change', () => {
    const building = $('#building-filter').val();
    let selectedClient = $('#client-filter').val();

    toggleMain(false);
    loadingTimer = setTimeout(() => {
        playLoadingAnimation();
    }, 1000);

    setClientFilterOptions(building, (data) => {
        selectedClient = selectedClient.filter(option => data.some(item => item['Value'] === option));
        // The client filter's change event will update the charts.
        if (selectedClient.length > 0) $('#client-filter').val(selectedClient).trigger('change');
        else $('#client-filter').val(['ALL']).trigger('change');
    });
});

function onDateRangePickerChange(startDate, endDate, label) {
    let title = '';
    let range = '';

    if ((endDate - startDate) < 100 || label == 'Today') {
        title = 'Today';
        range = startDate.format('MMM D');
    } else if (label == 'Yesterday') {
        title = 'Yesterday';
        range = startDate.format('MMM D');
    } else {
        range = startDate.format('MMM D') + ' - ' + endDate.format('MMM D');
    }

    $('#date-filter>span:first-child').text(`${title} ${title !== '' ? ':' : ''} ${range}`);

    toggleMain(false);
    loadingTimer = setTimeout(() => {
        playLoadingAnimation();
    }, 1000);
    const building = $('#building-filter').val();
    const clients = $('#client-filter').val();
    const dateRangeStart = moment(startDate).format('YYYY-MM-DD');
    const dateRangeEnd = moment(endDate).format('YYYY-MM-DD')
    setChartsData(building, clients, dateRangeStart, dateRangeEnd);
}

$('#inbound-dwell-time-chart').on('click', () => {
    const building = $('#building-filter').val();
    const clients = $('#client-filter').val();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');
    showBreakdownDatatable('Inbound Dwell Time', 'inbound dwell time', building, clients, dateRangeStart, dateRangeEnd);
});

$('#inbound-attachment-chart').on('click', () => {
    const building = $('#building-filter').val();
    const clients = $('#client-filter').val();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');
    showBreakdownDatatable('Inbound Attachment', 'inbound attachment', building, clients, dateRangeStart, dateRangeEnd);
});

$('#inbound-submission-chart').on('click', () => {
    const building = $('#building-filter').val();
    const clients = $('#client-filter').val();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');
    showBreakdownDatatable('Inbound On-time Submission', 'inbound submission', building, clients, dateRangeStart, dateRangeEnd);
});

$('#outbound-dwell-time-chart').on('click', () => {
    const building = $('#building-filter').val();
    const clients = $('#client-filter').val();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');
    showBreakdownDatatable('Outbound Dwell Time', 'outbound dwell time', building, clients, dateRangeStart, dateRangeEnd);
});

$('#outbound-in-full-section').on('click', () => {
    const building = $('#building-filter').val();
    const clients = $('#client-filter').val();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');
    showBreakdownDatatable('Outbound In Full', 'outbound in full', building, clients, dateRangeStart, dateRangeEnd);
});

$('#outbound-attachment-chart').on('click', () => {
    const building = $('#building-filter').val();
    const clients = $('#client-filter').val();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');
    showBreakdownDatatable('Outbound Attachment', 'outbound attachment', building, clients, dateRangeStart, dateRangeEnd);
});

$('#outbound-submission-chart').on('click', () => {
    const building = $('#building-filter').val();
    const clients = $('#client-filter').val();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');
    showBreakdownDatatable('Outbound On-time Submission', 'outbound submission', building, clients, dateRangeStart, dateRangeEnd);
});

$('#midbound-ira-chart').on('click', () => {
    const building = $('#building-filter').val();
    const clients = $('#client-filter').val();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');
    showBreakdownDatatable('IRA', 'midbound ira', building, clients, dateRangeStart, dateRangeEnd);
});

$('#midbound-lra-chart').on('click', () => {
    const building = $('#building-filter').val();
    const clients = $('#client-filter').val();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');
    showBreakdownDatatable('LRA', 'midbound lra', building, clients, dateRangeStart, dateRangeEnd);
});

$('#midbound-submission-chart').on('click', () => {
    const building = $('#building-filter').val();
    const clients = $('#client-filter').val();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');
    showBreakdownDatatable('Midbound On-time Submission', 'midbound submission', building, clients, dateRangeStart, dateRangeEnd);
});

$('#breakdown-modal .btn-export-excel').on('click', () => {
    const title = $('#breakdown-modal-title').text().replaceAll(' ', '_').toLowerCase();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');
    $('#breakdown-table').tableExport({ type: 'xls', fileName: `${title}_${dateRangeStart}-${dateRangeEnd}`, ignoreColumn: [3] });
});

$('#breakdown-modal .btn-export-csv').on('click', () => {
    const title = $('#breakdown-modal-title').text().replaceAll(' ', '_').toLowerCase();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');
    $('#breakdown-table').tableExport({ type: 'csv', fileName: `${title}_${dateRangeStart}-${dateRangeEnd}`, ignoreColumn: [3] });
});

$('body').on('click', '.view-btn', function () {
    $('#breakdown-modal').modal('hide');
    const metric = $('#breakdown-modal #breakdown-table').data('metric');
    const title = $('#breakdown-modal #breakdown-table').data('title');
    const client = $(this).data('id');
    const building = $('#building-filter').val();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');
    showMissesDatatable(`${client} - ${title} Miss`, metric, building, client, dateRangeStart, dateRangeEnd);
});

$('#misses-modal').on('hidden.bs.modal', () => {
    $('#breakdown-modal').modal('show');
});

$('#misses-modal .btn-export-excel').on('click', () => {
    const title = $('#misses-modal-title').text().replaceAll(' ', '_').toLowerCase();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');
    $('#misses-table').tableExport({ type: 'xls', fileName: `${title}_${dateRangeStart}-${dateRangeEnd}`, ignoreColumn: [3] });
});

$('#misses-modal .btn-export-csv').on('click', () => {
    const title = $('#misses-modal-title').text().replaceAll(' ', '_').toLowerCase();
    const dateRangeStart = moment($('#date-filter').data('daterangepicker').startDate._d).format('YYYY-MM-DD');
    const dateRangeEnd = moment($('#date-filter').data('daterangepicker').endDate._d).format('YYYY-MM-DD');
    $('#misses-table').tableExport({ type: 'csv', fileName: `${title}_${dateRangeStart}-${dateRangeEnd}`, ignoreColumn: [3] });
});



function toggleFilters(isEnabled) {
    $('#building-filter').prop('disabled', !isEnabled);
    $('#client-filter').prop('disabled', !isEnabled);
    $('#date-filter').prop('disabled', !isEnabled);
}

function unwrapResponse(response) {
    return response.d;
};

function displayError(errorMsg) {
    alert(errorMsg);
}

// select2 template
function templateResult(result) {
    return $(
        '<div class="row m-0 p-0">' +
        '<div class="col-md-12 m-0 p-0">' + result.text + '</div>' +
        '</div>'
    );
}

// select2 template
function templateResult2(result) {
    return $(
        '<div class="row m-0 p-0">' +
        '<div class="col-md-4 m-0 p-0">' + result.id + '</div>' +
        '<div class="col-md-8 m-0 p-0">' + result.text + '</div>' +
        '</div>'
    );
}

// select2 search
function matchStart(params, data) {
    if ($.trim(params.term) === '') return data;

    if (typeof data.text === 'undefined') return null;

    var q = params.term.toLowerCase();
    if (data.text.toLowerCase().indexOf(q) > -1 || data.id.toLowerCase().indexOf(q) > -1) return $.extend({}, data, true);

    return null;
}

function createCircularProgressbar(elementQuerySelector, value, onClick = () => { }) {
    let $progressbar = $(`<div class="circular-progress-bar">
            <div class="circle-drop">
                <p>${value ? value : 0}%</p>
            </div>
            <div class="circle-track"></div>
       </div>
    `);
    $(elementQuerySelector).css('--bar-fill', `${value ? value * 3.6 : 0}deg`);
    $(elementQuerySelector).append($progressbar);
}

function updateCircularProgressbar(elementQuerySelector, value) {
    $(`${elementQuerySelector} .circular-progress-bar>div.circle-drop>p`).text(`${value ? value : 0}%`);
    $(`${elementQuerySelector} .circular-progress-bar`).css('--bar-fill', `${value ? value * 3.6 : 0}deg`);

    if (value == null) {
        $(`${elementQuerySelector}`).parent('.sub-section').find('.chart-value').show();
        $(`${elementQuerySelector}`).parent('.sub-section').find('.chart-value').text('No data');
        return;
    }

    $(`${elementQuerySelector}`).parent('.sub-section').find('.chart-value').hide();
}

function createIconProgressBar(elementQuerySelector, value, icon, iconSize, fillOffset = 0) {
    let $progressBar = $(`
        <div class="icon-progress-bar">
            <div class=icon-container>
                <div class="progress-icon ${icon}"></div>
            </div>
            <div class="icon-drop">
        </div>
    `);
    $(elementQuerySelector).css('--bar-fill-percentage', `${value ? value : 0}%`);
    $(elementQuerySelector).css('--icon-size', `${iconSize}px`);
    $(elementQuerySelector).append($progressBar);
}

function updateIconProgressBar(elementQuerySelector, value) {
    $(`${elementQuerySelector}`).css('--bar-fill-percentage', `${value ? value : 0}%`);

    if (value == null) {
        $(`${elementQuerySelector}`).parent('.sub-section').find('.chart-value').text('No data');
        return;
    }

    $(`${elementQuerySelector}`).parent('.sub-section').find('.chart-value').text(`${value ? value : 0}%`);
}

function setClientFilterOptions(building, onSuccess = () => { }) {
    $.ajax({
        type: 'POST',
        url: "frmKPIDashboard.aspx/GetClients",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ building: building }),
        success: (response) => {
            let unwrappedResponse = JSON.parse(unwrapResponse(response));
            if (!unwrappedResponse.success) {
                clearTimeout(loadingTimer);
                stopLoadingAnimation();
                toggleMain(true);
                toggleFilters(false);
                displayError(unwrappedResponse.data);
                return;
            }

            let data = JSON.parse(unwrappedResponse.data);

            $('#client-filter').empty();
            if (data.length <= 0) {
                $('#client-filter').append('<option disabled">No data</option>');
                $('#client-filter').val([]);
            }
            else {
                $('#client-filter').append('<option value="ALL">All</option>');
                data.forEach((client) => {
                    $('#client-filter').append(`<option value="${client['Value']}">${client['Description']}</option>`);
                });
            }

            toggleFilters(true);

            onSuccess(data);
        },
        error: (_xhr, _status, error) => {
            clearTimeout(loadingTimer);
            stopLoadingAnimation();
            toggleMain(true);
            toggleFilters(false);
            displayError(error);
        }
    });
}

function setChartsData(building, clients, dateFrom, dateTo) {
    if (building == null || building.trim() === ''
        || clients == null || clients.length === 0
        || dateFrom == null || dateTo == null) {
        return;
    }

    $.ajax({
        type: 'POST',
        url: "frmKPIDashboard.aspx/GetChartsData",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ building: building, clients: clients, dateFrom: dateFrom, dateTo: dateTo }),
        success: (response) => {
            clearTimeout(loadingTimer);
            stopLoadingAnimation();
            toggleMain(true);

            let unwrappedResponse = JSON.parse(unwrapResponse(response));
            if (!unwrappedResponse.success) {
                clearTimeout(loadingTimer);
                stopLoadingAnimation();
                toggleMain(true);
                displayError(unwrappedResponse.data);
                return;
            }

            let data = JSON.parse(unwrappedResponse.data);
            let kpi = data.length > 0 ? data[0] : {
                InboundDwellTime: 0,
                InboundAttachment: 0,
                InboundOnTimeSubmission: 0,
                OutboundDwellTime: 0,
                OutboundAttachment: 0,
                OutboundOnTimeSubmission: 0,
                OutboundInFull: 0,
                MidboundIRA: 0,
                MidboundLRA: 0,
                MidboundOnTimeSubmission: 0
            };

            updateCircularProgressbar('#inbound-attachment-chart', kpi.InboundAttachment);
            updateIconProgressBar('#inbound-dwell-time-chart', kpi.InboundDwellTime);
            updateIconProgressBar('#inbound-submission-chart', kpi.InboundOnTimeSubmission);

            updateIconProgressBar('#outbound-dwell-time-chart', kpi.OutboundDwellTime);
            updateIconProgressBar('#outbound-submission-chart', kpi.OutboundOnTimeSubmission);
            updateCircularProgressbar('#outbound-attachment-chart', kpi.OutboundAttachment);
            $('#outbound-section div.cargo-body').css('--bar-fill-percentage', `${kpi.OutboundInFull}%`);
            $('#outbound-in-full').text(`${kpi.OutboundInFull ? kpi.OutboundInFull + '%' : 'No data'}`);

            updateCircularProgressbar('#midbound-ira-chart', kpi.MidboundIRA);
            updateCircularProgressbar('#midbound-lra-chart', kpi.MidboundLRA);
            updateIconProgressBar('#midbound-submission-chart', kpi.MidboundOnTimeSubmission);
        },
        error: (_xhr, _status, error) => {
            clearTimeout(loadingTimer);
            stopLoadingAnimation();
            toggleMain(true);
            displayError(error);
        }
    });
}

function toggleMain(isEnabled) {
    $('main').css('pointer-events', isEnabled ? 'auto' : 'none');
}

function playLoadingAnimation() {
    $('#loading-indicator').show();
    $('main').css('filter', 'brightness(80%)');
}

function stopLoadingAnimation() {
    $('#loading-indicator').hide();
    $('main').css('filter', 'unset');
}

async function getClientBreakdown(metric, building, clients, dateFrom, dateTo) {
    return $.ajax({
        type: 'POST',
        cache: false,
        url: "frmKPIDashboard.aspx/GetClientBreakdown",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ metric: metric, building: building, clients: clients, dateFrom: dateFrom, dateTo: dateTo }),
    });
}

function showBreakdownDatatable(title, metric, building, clients, dateFrom, dateTo) {
    $('#breakdown-modal').modal('show');
    $('#breakdown-modal-title').text(title);

    if ($.fn.DataTable.isDataTable('table#breakdown-table')) {
        $("table#breakdown-table").DataTable().clear();
        $("table#breakdown-table").DataTable().destroy();
    }

    $('table#breakdown-table tbody').empty();
    $('#breakdown-table tbody').append('<tr><td colspan="4" class="text-center font-weight-bold">Loading...</td></tr>');
    $("table#breakdown-table").data('metric', metric);
    $("table#breakdown-table").data('title', title);

    (async () => {
        let unwrappedResponse = JSON.parse(unwrapResponse(await getClientBreakdown(metric, building, clients, dateFrom, dateTo)));

        if (!unwrappedResponse.success) {
            displayError(unwrappedResponse.data);
            $('#breakdown-table tbody').append('<tr><td class="text-center" colspan="4">No data to display</td></tr>');
            return;
        }

        $(`table#breakdown-table tbody`).empty();

        let data = JSON.parse(unwrappedResponse.data);
        if (data.length <= 0) {
            $('#breakdown-table tbody').append('<tr><td class="text-center" colspan="4">No data to display</td></tr>');
            return;
        }

        $("table#breakdown-table").DataTable({
            processing: true,
            orderCellsTop: true,
            searching: false,
            paging: false,
            info: false,
            data: data,
            columns: [
                { data: 'Client' },
                {
                    data: 'Hit',
                    render: (data, _type, _row) => {
                        if (isNaN(data)) {
                            return data;
                        }
                        return `<b>${data}%</b>`
                    }
                },
                { data: 'Total' },
                {
                    orderable: false,
                    render: (data, type, row) => {
                        return `
                        <button class="btn btn-secondary view-btn" ${row['Hit'] == '100' ? 'disabled' : ''} data-id="${row['CustomerCode']}">View Misses</button>`;
                    }
                }
            ]
        });
    })();
}

async function getMissedTransactions(metric, building, client, dateFrom, dateTo) {
    return $.ajax({
        type: 'POST',
        cache: false,
        url: "frmKPIDashboard.aspx/GetMissedTransactions",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ metric: metric, building: building, client: client, dateFrom: dateFrom, dateTo: dateTo }),
    });
}

function showMissesDatatable(title, metric, building, client, dateFrom, dateTo) {
    $('#misses-modal').modal('show');
    $('#misses-modal-title').text(title);

    if ($.fn.DataTable.isDataTable('table#misses-table')) {
        $("table#misses-table").DataTable().clear();
        $("table#misses-table").DataTable().destroy();
    }

    $(`table#misses-table tbody`).empty();
    $(`table#misses-table thead`).empty();
    $('#misses-table tbody').append('<tr><td class="text-center font-weight-bold">Loading...</td></tr>');

    (async () => {
        let unwrappedResponse = JSON.parse(unwrapResponse(await getMissedTransactions(metric, building, client, dateFrom, dateTo)));

        if (!unwrappedResponse.success) {
            displayError(unwrappedResponse.data);
            $('#misses-table tbody').append('<tr><td class="text-center">No data to display</td></tr>');
            return;
        }

        $(`table#misses-table tbody`).empty();

        let data = JSON.parse(unwrappedResponse.data);
        if (data.length <= 0) {
            $('#misses-table tbody').append('<tr><td class="text-center">No data to display</td></tr>');
            return;
        }

        const columns = Object.keys(data[0]);
        let dataTableColumns = [];
        columns.forEach((column) => {
            dataTableColumns.push({ data: column });
        });

        let dateCols = ['Arrival', 'Departure', 'Date Submitted', 'Date Added', 'Date', 'Doc Date', 'Docking Time', ];
        let dateColIndexes = [];
        columns.forEach((column, index) => {
            if (dateCols.includes(column)) dateColIndexes.push(index);
        });

        createHeaders(columns, 'misses-table');

        $("table#misses-table").DataTable({
            processing: true,
            orderCellsTop: true,
            searching: false,
            paging: false,
            info: false,
            data: data,
            columns: dataTableColumns,
            columnDefs: [
                {
                    targets: dateColIndexes,
                    type: 'date',
                    render: function (data, type, row) {
                        if (type === 'sort' || type === 'type') {
                            return moment(data).format('YYYY-MM-DD HH:mm:ss');
                        }
                        return data;
                    }
                }
            ]
        });
    })();
}

function createHeaders(columns, tableID) {
    $(`#${tableID} thead`).empty();
    $(`#${tableID} thead`).append('<tr></tr>');
    columns.forEach((column) => {
        $(`#${tableID} thead tr:first-child`).append(`<th>${column}</th>`)
    });
}