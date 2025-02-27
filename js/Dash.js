const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
let DateStart;
let DateEnd;
let customers = [];
let warehouseCode = '';
let pollingInterval = 5 * 60 * 1000;

// Inbound chart data
let transactions = {};
let categories = [];
let statusTotals = {};
let storageTypeTotals = {};

// Inbound chart
let inboundStatusDonutChart;
let inboundStorageDonutChart;
let inboundTransactionStackChart;

// Outbound chart data
let outboundTransactions = {};
let outboundTransactionCategories = [];
let outboundStatusTotals = {};
let shipmentTypeTotals = {};

// Outbound chart
let outboundStatusDonutChart;
let outboundShipmentTypeDonutChart;
let outboundTransactionStackChart;

// Truck transaction
let docNumbers = [];

// Productivity chart data
let checkersActivities = [];
let checkers = [];
let checkerIDs = [];

// Productivity chart
let productivityStackBarChart;

// Contracts chart data
let contractStatusTotals = {};
let contractTypeTotals = {};

// Contracts chart
let contractStatusesDonutChart;
let contractTypesDonutChart;

// Perfect shipment charts
let shipmentTotalDonutChart;
let shipmentInboundDonutChart;
let shipmentOutboundDonutChart;
let shipmentInboundColumnChart;
let shipmentOutboundColumnChart;

// Queue
let queue = [];
let inboundQueuingNumbers = [];
let outboundQueuingNumbers = [];
let dragging = null;

// Monitoring
let monitoringTransactions = [];
let durationTimers = [];
let monitoringTruckStatusChart;
let monitoringLineChart;
let monitoringTransactionsPieChart;
let monitoringTransactionsTreeMapChart;
let monitoringInventoryTreeMapChart;
let monitoringCounts;
let monitoringOrderFulfillmentChart;
let monitoringDwellTimeChart;
let monitoringAttachmentChart;
let monitoringIRAChart;
let monitoringLRAChart;
let monitoringBillingSubmissionChart;
let monitoringBillingInvoiceChart;
let monitoringOnTimeSubmissionChart;
const listItemShownCount = 30;
let lastIndex = listItemShownCount;
let startIndex = 0;
const scrollItemIncrement = 10; 
let monitoringRows = [];

// reponses of datatable requests
let responses = {};

$(document).ready(async function () {
    $('body').tooltip({
        selector: '[data-toggle="tooltip"]'
    });

    await Parameters(); // Setup parameters

    const shortMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    $.ajax({
        type: "POST",
        data: JSON.stringify({ Code: "BOOKDATE" }),
        url: "/PerformSender.aspx/SS",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (result) {
            const bookDate = new Date(result.d);
            $('#dash-period').val(shortMonths[bookDate.getMonth() - 1] + '-' + bookDate.getFullYear());

            //var datesd = new Date(bookdate);
            var currentDate = new Date();
            var datesd = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);;
            var dateEd = new Date();

            $('select#month').val(currentDate.getMonth());

            $('#daterangetrans').data('daterangepicker').setStartDate(datesd);
            $('#daterangetrans').data('daterangepicker').setEndDate(dateEd);
            DateStart = datesd.getFullYear() + '-' + ('0' + (datesd.getMonth() + 1)).slice(-2) + '-' + ('0' + datesd.getDate()).slice(-2);
            DateEnd = dateEd.getFullYear() + '-' + ('0' + (dateEd.getMonth() + 1)).slice(-2) + '-' + ('0' + dateEd.getDate()).slice(-2);

            const tab = $('a.nav-link.active').attr('id');
            loadTab(tab);

            setInterval(() => {
                const tab = $('a.nav-link.active').attr('id');
                if (tab != 'tab-queue' && tab != 'tab-monitoring') return;
                loadTab(tab);
            }, pollingInterval);
        }
    });

    $('#expiration-input').val(moment().add(30, 'days').format('YYYY-MM-DD'));

    $('#daterangetrans').daterangepicker({ opens: 'center' }, (start, end, label) => {
        DateStart = start.format('YYYY-MM-DD');
        DateEnd = end.format('YYYY-MM-DD');

        const tab = $('a.nav-link.active').attr('id');
        clearMonitoringCharts(tab);
        loadTab(tab);
    });

    $('.nav-link.tab').on('click', (event) => {
        const tab = event.target.id;
        clearMonitoringCharts(tab);
        loadTab(tab);
    })

    $("#dash-period").datepicker({
        format: "M-yyyy",
        viewMode: "months",
        minViewMode: "months",
        autoclose: true
    });

    $('#dash-period').datepicker('option', 'onSelect', function (date) { // 'onSelect' here, but could be any datepicker event
        //$(this).change(); // Lauch the "change" evenet of the <input> everytime someone click a new date

    });

    $('#customer-input').on('keyup paste', (e) => {
        const inputValue = $('#customer-input').val().toLowerCase();
        let options = [];
        if (inputValue === '') {
            options = customers;
        }
        else {
            options = getFilteredCustomers();
        }

        fillCustomersDropdown(options);

        $('#customer .dropdown-toggle').dropdown('show');
        $('#customer-input').focus();

        if (e.which == 13 && options.length === 1) {
            $('#customer-input').blur();
            $('#customer .dropdown-toggle').dropdown('hide');
            const selectedOption = $("#customer .dropdown-menu a")[0];
            const customer = $(selectedOption).data('code');

            // recreate dropdown
            fillCustomersDropdown(customers);
            $('#customer a.selected').removeClass('selected');
            const match = $("#customer .dropdown-menu").find(`a[data-code='${customer}']`);
            $(match).addClass('selected');
            $('#customer-input').val($(match).text());
            $('#customer input').attr('data-original-title', $(match).text());

            const tab = $('a.nav-link.active').attr('id');
            clearMonitoringCharts(tab);
            loadTab(tab);
        }
    });

    $('#customer div.dropdown-menu').on('click', 'a.dropdown-item', function () {
        $('#customer a.selected').removeClass('selected');
        $(this).addClass('selected');
        $('#customer input').val($(this).text());
        $('#customer input').attr('data-original-title', $(this).text());
        const optionCode = $(this).attr('data-code');

        // recreate dropdown options if filtered previously
        if ($('#customer a').length !== docNumbers.length) {
            fillCustomersDropdown(customers);
            $('#customer a.selected').removeClass('selected');
            const match = $("#customer .dropdown-menu").find(`a[data-code='${optionCode}']`);
            $(match).addClass('selected');
        }

        const tab = $('a.nav-link.active').attr('id');
        clearMonitoringCharts(tab);
        loadTab(tab);
    });

    $('#warehouse div.dropdown-menu').on('click', 'a.dropdown-item', function () {
        $('#warehouse a.selected').removeClass('selected');
        $(this).addClass('selected');
        $('#warehouse input').val($(this).text());
        $('#warehouse input').attr('data-original-title', $(this).text());

        const tab = $('a.nav-link.active').attr('id');
        clearMonitoringCharts(tab);
        loadTab(tab);
    });


    // Inbound cards click event handlers
    $('#total-count-container').on('click', () => {
        inboundCardOnClick('Total', 'All');
    });

    $('#billed-count-container').on('click', () => {
        inboundCardOnClick('Billed', 'Billed');
    });

    $('#unbilled-count-container').on('click', () => {
        inboundCardOnClick('Unbilled', 'Unbilled');
    });

    // export datatable click handler
    $('table#inbound-trails-datatable').on('click', 'td', function () {
        const colIndex = $(this).index();

        if (colIndex == 0) return;

        const warehouseCode = getWarehouseCode();
        const statuses = ['New', 'Cancelled', 'Blast Checker Assigned', 'Blast Checker Accepted', 'Blasting', 'For After Blast', 'Checker Assigned', 'Checker Accepted', 'Checker Ongoing Unloading',
            'Docs Inbound Pending Submission', 'RF Ongoing Putaway', 'Docs Putaway Pending Submission', 'Completed'];
        const customerCode = $($(this).parent('tr').children()[0]).attr('id');

        $('#datatable-modal-label').text(`${customerCode} - ${statuses[colIndex - 1]}`);
        $('#datatable-modal').modal('show');
        getTransactionTrailsModalDatatable(customerCode, warehouseCode, DateStart, DateEnd, statuses[colIndex - 1], 'Inbound',
            (response) => {
                const datatable = parseData(response.d);
                displayModalDatatable(datatable, 2)
            }
        );
    })

    $('table#outbound-trails-datatable').on('click', 'td', function () {
        const colIndex = $(this).index();

        if (colIndex == 0) return;

        const warehouseCode = getWarehouseCode();
        const statuses = ['New', 'Cancelled', 'Checker Assigned', 'Checker Ongoing Picking',
            'Docs Picklist Pending Submission', 'RF Ongoing Outbound', 'Docs Outbound Pending Submission', 'Completed'];
        const customerCode = $($(this).parent('tr').children()[0]).attr('id');

        $('#datatable-modal-label').text(`${customerCode} - ${statuses[colIndex - 1]}`);
        $('#datatable-modal').modal('show');
        getTransactionTrailsModalDatatable(customerCode, warehouseCode, DateStart, DateEnd, statuses[colIndex - 1], 'Outbound',
            (response) => {
                const datatable = parseData(response.d);
                displayModalDatatable(datatable, 2)
            }
        );
    })

    $('#chart-excel-export-btn').on('click', () => {
        const label = $('.modal h5#datatable-modal-label').text();
        $('#chart-datatable').tableExport({ type: 'excel', fileName: label, });
    });

    $('#inbound-excel-export-btn').on('click', () => {
        $('#inbound-trails-datatable').tableExport({ type: 'excel', fileName: 'InboundTransactionTrails', });
    });

    $('#outbound-excel-export-btn').on('click', () => {
        $('#outbound-trails-datatable').tableExport({ type: 'excel', fileName: 'OutboundTransactionTrails', });
    });

    $('#contracts-excel-export-btn').on('click', () => {
        $('#contracts-datatable').tableExport({ type: 'excel', fileName: 'Contracts', });
    });

    $('#truck-transactions-excel-export-btn').on('click', () => {
        $('#truck-transactions-datatable').tableExport({ type: 'excel', fileName: 'TruckTransactions', });
    });

    $('#shipment-inbound-excel-export-btn').on('click', () => {
        $('#shipment-inbound-datatable').tableExport({ type: 'excel', fileName: 'InboundPerfectShipment', });
    });

    $('#shipment-outbound-excel-export-btn').on('click', () => {
        $('#shipment-outbound-datatable').tableExport({ type: 'excel', fileName: 'OutboundPerfectShipment', });
    });

    // Truck transaction event handlers
    $('#doc-number-input').on('keyup paste', (e) => {
        const inputValue = $('#doc-number-input').val().toLowerCase();
        let options = [];
        if (inputValue === '') {
            options = docNumbers;
        }
        else {
            options = getFilteredDocNumbers();
        }

        fillDocNumberDropdown(options);

        $('#doc-number .dropdown-toggle').dropdown('show');
        $('#doc-number-input').focus();

        if (e.which == 13 && options.length === 1) {
            $('#doc-number-input').blur();
            $('#doc-number .dropdown-toggle').dropdown('hide');
            const selectedOption = $("#doc-number .dropdown-menu a")[0];
            const docNumber = $(selectedOption).data('code');

            // recreate dropdown
            fillDocNumberDropdown(docNumbers);
            $('#doc-number a.selected').removeClass('selected');
            const match = $("#doc-number .dropdown-menu").find(`a[data-code='${docNumber}']`);
            $(match).addClass('selected');
            // load view
            const transactionType = $('select#transaction-type-select').val();
            getTruckingTransaction(docNumber, transactionType, (response) => {
                const transaction = parseData(response.d)[0];
                fillTruckTransactionStatuses(transaction);
            });
        }
    });

    $('#doc-number div.dropdown-menu').on('click', 'a.dropdown-item', function () {
        $('#doc-number a.selected').removeClass('selected');
        $(this).addClass('selected');
        $('#doc-number input').val($(this).text());
        const optionDocNumber = $(this).attr('data-code');

        // recreate dropdown options if filtered previously
        if ($('#doc-number a').length !== docNumbers.length) {
            fillDocNumberDropdown(docNumbers);
            $('#doc-number a.selected').removeClass('selected');
            const match = $("#doc-number .dropdown-menu").find(`a[data-code='${optionDocNumber}']`);
            $(match).addClass('selected');
        }

        const docNumber = getSelectedDocNumber();
        const transactionType = $('select#transaction-type-select').val();
        getTruckingTransaction(docNumber, transactionType, (response) => {
            const transaction = parseData(response.d)[0];
            fillTruckTransactionStatuses(transaction);
        });
    });

    $('select#transaction-type-select').on('change', () => {
        resetTruckTransactionGraph();
        let customerCode = getCustomerCode();
        let warehouseCode = getWarehouseCode();
        let transactionType = $('#transaction-type-select').val() ? $('#transaction-type-select').val() : 'ALL';
        changeTruckTransactionGraphLabel(transactionType);
        getDocNumbers(customerCode, warehouseCode, DateStart, DateEnd, transactionType, (response) => {
            docNumbers = parseData(response.d);
            fillDocNumberDropdown(docNumbers);
            $("#doc-number-input").val("");
        });

        getTransactionDatatable(customerCode, warehouseCode, DateStart, DateEnd, transactionType, (datatable) => {
            $('#inbound-trails-datatable_wrapper table').empty();
            $('#inbound-trails-datatable').empty();

            if (datatable.length === 0) {
                $('#inbound-trails-datatable').append('<h4 class="text-muted ml-2 my-2">No transaction</h4>');
                return;
            }

            (async () => {
                await ConstTABLE(1, datatable, 'truck-transactions-datatable', 0, 'asc');
                $('div#truck-transactions-datatable_wrapper div.dataTables_scrollBody').css('max-height', '348px');
                $('div#truck-transactions-datatable_wrapper div.dataTables_scrollHead th:nth-child(8)').text('StartLoading/Unloading');
                $('div#truck-transactions-datatable_wrapper div.dataTables_scrollHead th:nth-child(11)').text('EndLoading/Unloading');
            })();
        })
    })

    $('#truck-transactions-datatable').on('click', 'tr', function () {
        const primaryColTD = $(this).children()[0];
        const docNumber = $(primaryColTD).attr('id');
        const transactionType = $('select#transaction-type-select').val();

        getTruckingTransaction(docNumber, transactionType, (response) => {
            const transaction = parseData(response.d)[0];
            fillTruckTransactionStatuses(transaction);
        });

        $('#doc-number a.selected').removeClass('selected');
        const match = $("#doc-number .dropdown-menu").find(`a[data-code='${docNumber.toLowerCase()}']`);
        $(match).addClass('selected');
        $('#doc-number input').val($(match).text());
    });

    // Productivity event handlers
    $("#sort-by, #sort-direction, #month").on('click', () => {
        let customerCode = getCustomerCode();
        let warehouseCode = getWarehouseCode();
        //getProductivityData(customerCode, warehouseCode, DateStart, DateEnd, (chart) => {
        //    renderProductivityCharts(chart);
        //});
        getProductivityData(customerCode, warehouseCode, (response) => {
            renderProductivityCharts(response);
        });
    });

    $('#expiration-input').on('change', () => {
        const tab = $('a.nav-link.active').attr('id');
        clearMonitoringCharts(tab);
        loadTab(tab);
    });

    //$('div').on('dragstart', '.draggable', onDragStart);
});

function parseData(data) {
    return JSON.parse(data);
}

function titleCase(str) {
    str = str.toLowerCase().split(' ');
    for (var i = 0; i < str.length; i++) {
        str[i] = str[i].charAt(0).toUpperCase() + str[i].slice(1);
    }
    return str.join(' ');
}

function getCustomerCode() {
    //return $('#customer').val() ? $('#customer').val() : 'ALL';
    return $('#customer a.dropdown-item.selected').data('code') ? $('#customer a.dropdown-item.selected').data('code') : 'ALL';
}

function getWarehouseCode() {
    //return $('#warehouse').val() ? $('#warehouse').val() : 'ALL';
    //return $('#warehouse a.dropdown-item.selected').data('code') ? $('#warehouse a.dropdown-item.selected').data('code') : 'ALL';
    return warehouseCode;
}

function getSelectedDocNumber() {
    return $('#doc-number a.dropdown-item.selected').data('code');
}

function renderStackChart(chart, title, series, categories, elementQuerySelector, onClick, full = false, colors = null) {
    if (series.length === 0) return

    const chartOptions = {
        series: series,
        chart: {
            type: 'bar',
            height: 400,
            stacked: true,
            toolbar: { show: true },
            zoom: { enabled: true },
            events: { dataPointSelection: onClick },
            offsetY: 10
        },
        responsive: [{
            breakpoint: 480,
            options: {
                legend: {
                    position: 'bottom',
                    offsetX: -10,
                    offsetY: 0
                }
            }
        }],
        plotOptions: {
            bar: {
                horizontal: false,
                borderRadius: 10,
                dataLabels: {
                    total: {
                        enabled: true,
                        style: {
                            fontSize: '13px',
                            fontWeight: 900
                        }
                    }
                }
            },
        },
        xaxis: {
            categories: categories.map((category) => { return category.toUpperCase() }),
            //tickPlacement: 'on',
        },
        fill: { opacity: 1 },
        title: {
            text: title,
            align: 'left',
            margin: 10,
            offsetX: 0,
            offsetY: 10,
            floating: false,
            style: {
                fontSize: '1.125rem',
                fontWeight: '700',
                fontFamily: 'Nunito, sans-serif',
                color: '#6c757d'
            },
        }
    };

    if (full) {
        chartOptions.plotOptions.bar.dataLabels = {};
        chartOptions.chart['stackType'] = '100%';
    }

    if (colors !== null) {
        chartOptions['colors'] = colors;
    }

    if (!chart) {
        $(`${elementQuerySelector} + span`).remove();
        chart = new ApexCharts(document.querySelector(elementQuerySelector), chartOptions);
        chart.render();
    }
    else {
        chart.updateOptions(chartOptions);
    }
    return chart;
}

function renderProductivityStackBarChart(chart, series, categories, elementQuerySelector, onClick) {
    if (series.length === 0) return

    const chartOptions = {
        series: series,
        chart: {
            type: 'bar',
            height: categories.length <= 1 ? 248 : categories.length * 28,
            stacked: true,
            toolbar: {
                show: true,
                offsetX: -10
            },
            zoom: { enabled: true },
            events: { dataPointSelection: onClick },
            //stackType: '100%'
        },
        responsive: [{
            breakpoint: 480,
            options: {
                legend: {
                    position: 'bottom',
                    offsetX: -10,
                    offsetY: 0
                }
            }
        }],
        plotOptions: {
            bar: {
                horizontal: true,
                borderRadius: 10,
                dataLabels: {
                    total: {
                        enabled: true,
                        style: {
                            fontSize: '13px',
                            fontWeight: 900
                        }
                    },
                    position: 'bottom'
                }
            },
        },
        colors: ['#0acf97', '#2c8ef8'],
        dataLabels: {
            enabled: true,
            textAnchor: 'start',
            //formatter: function (val, opt) {
            //    return `${(opt.seriesIndex == 1 ? 'Ongoing' : 'Completed')}: ${opt.w.globals.series[opt.seriesIndex][opt.dataPointIndex]}`
            //},
            offsetX: 0,
        },
        xaxis: {
            categories: categories,
        },
        yaxis: {
            labels: {
                style: {
                    fontSize: '14px',
                }
            }
        },
        legend: {
            position: 'top',
        },
        fill: { opacity: 1 },
        title: {
            align: 'left',
            margin: 10,
            offsetX: 0,
            offsetY: 10,
            floating: false,
            style: {
                fontSize: '1.125rem',
                fontWeight: '700',
                fontFamily: 'Nunito, sans-serif',
                color: '#6c757d'
            },
        },
        tooltip: {
            y: {
                formatter: function (value, opts) {
                    return value
                },
            },
        }
    };

    if (!chart) {
        $(`${elementQuerySelector} + span`).remove();
        chart = new ApexCharts(document.querySelector(elementQuerySelector), chartOptions);
        chart.render();
    }
    else {
        chart.updateOptions(chartOptions);
    }
    return chart;
}

function renderDonutChart(chart, series, labels, elementQuerySelector, onClick, colors = null) {
    if (series.length === 0) return;

    const chartOptions = {
        series: series,
        chart: {
            height: '400px',
            type: 'donut',
            events: { dataPointSelection: onClick },
            offsetY: 0,
        },
        plotOptions: {
            pie: {
                donut: {
                    labels: {
                        show: true,
                        total: {
                            showAlways: true,
                            show: true
                        }
                    }
                }
            }
        },
        labels: labels,
        responsive: [{
            breakpoint: 480,
            options: {
                legend: { position: 'bottom' }
            }
        }]
    };

    if (colors !== null) chartOptions['colors'] = colors;

    if (!chart) {
        $(`${elementQuerySelector} + span`).remove();
        chart = new ApexCharts(document.querySelector(elementQuerySelector), chartOptions);
        chart.render();
    }
    else {
        chart.updateOptions(chartOptions);
    }

    return chart;
}

function renderPieChart(chart, series, labels, elementQuerySelector, onClick = () => { }, options = null) {
    if (series.length === 0) return;

    let chartOptions = {
        series: series,
        chart: {
            type: 'pie',
            height: 'auto',
            width: '90%',
            events: { dataPointSelection: onClick },
        },
        labels: labels,
    };

    if (options !== null) {
        chartOptions = { ...chartOptions, ...options };
    }

    if (!chart) {
        $(`${elementQuerySelector} + span`).remove();
        chart = new ApexCharts(document.querySelector(elementQuerySelector), chartOptions);
        chart.render();
    }
    else {
        chart.updateOptions(chartOptions);
    }

    return chart;
}

function renderLineChart(chart, series, elementQuerySelector, onClick = () => { }, options = null) {
    let chartOptions = {
        series: series,
        chart: {
            height: '100%',
            type: 'line',
            events: {
                markerClick: onClick
            },
            animations: {
                enabled: true,
                easing: 'linear',
                dynamicAnimation: {
                    speed: 1000
                }
            },
            toolbar: {
                show: true,
                tools: {
                    download: true,
                    selection: true,
                    zoom: false,
                    zoomin: true,
                    zoomout: true,
                    pan: true,
                }
            },
            zoom: {
                enabled: true,
                zoomedArea: {
                    enable: false
                }
            },
        },
        xaxis: {
            labels: {
                style: {
                    colors: ['#fff'],
                },
                class: 'black'
            }
        },
        stroke: {
            curve: 'straight'
        },
        legend: {
            show: false
        },
    };

    if (options !== null) {
        chartOptions = { ...chartOptions, ...options };
    }

    if (!chart) {
        $(`${elementQuerySelector} + span`).remove();
        chart = new ApexCharts(document.querySelector(elementQuerySelector), chartOptions);
        chart.render();
    }
    else {
        //chart.updateOptions(chartOptions);
        chart.destroy();
        chart = new ApexCharts(document.querySelector(elementQuerySelector), chartOptions);
        chart.render();
    }

    return chart;
}

function renderTreeMapChart(chart, series, elementQuerySelector, onClick = () => { }, options = null) {
    let chartOptions = {
        series: [
            { data: series }
        ],
        legend: { show: false },
        chart: {
            type: 'treemap',
            height: '100%',
            toolbar: { show: false },
            events: {
                dataPointSelection: onClick
            }
        },
        colors: [
            'rgb(255, 87, 51)',
            'rgb(0, 102, 204)',
            'rgb(255, 215, 0)',
            'rgb(50, 205, 50)',
            'rgb(255, 20, 147)',
            'rgb(32, 178, 170)',
            'rgb(128, 0, 128)',
            'rgb(255, 99, 71)',
            'rgb(60, 179, 113)',
            'rgb(255, 255, 0)'
        ],
        plotOptions: {
            treemap: {
                distributed: true,
                enableShades: false,
            }
        }
    };

    if (options !== null) {
        chartOptions = { ...chartOptions, ...options };
    }

    if (!chart) {
        $(`${elementQuerySelector} + span`).remove();
        chart = new ApexCharts(document.querySelector(elementQuerySelector), chartOptions);
        chart.render();
    }
    else {
        chart.updateOptions(chartOptions, true);
    }

    return chart;
}

function renderRadialBarChart(chart, series, labels, elementQuerySelector, onClick = () => { }, options = null) {
    let chartOptions = {
        series: series,
        chart: {
            height: 120,
            width: 120,
            type: 'radialBar',
            margin: 0,
            padding: 0,
            useHtmlLabels: false,
            events: {
                dataPointSelection: onClick
            }
        },
        plotOptions: {
            radialBar: {
                size: 120,
                track: {
                    strokeWidth: '90',
                    dropShadow: {
                        enabled: true,
                        top: 2,
                        left: 0,
                        blur: 4,
                        opacity: 0.15
                    }
                },
                hollow: {
                    size: '30%',
                    margin: 0
                },
                dataLabels: {
                    value: {
                        fontSize: '20px',  // Font size for the value
                        fontWeight: 'bold',
                        offsetY: -10, // Adjust if needed to center vertically
                        show: true
                    }
                }
            }
        },
        stroke: {
            lineCap: series[0] === 0 || series[0] > 93 ? 'butt' : 'round',
            width: 0,
        },
        colors: ['rgb(255, 140, 0)'],
        labels: labels
    };

    if (options !== null) {
        chartOptions = { ...chartOptions, ...options };
    }

    if (!chart) {
        $(`${elementQuerySelector} + span`).remove();
        chart = new ApexCharts(document.querySelector(elementQuerySelector), chartOptions);
        setTimeout(() => { chart.render(); }, 300);
    }
    else {
        chart.updateOptions(chartOptions, true);
    }

    return chart;
}

function fixHeaderAlignment(tableID) {
    setTimeout(function () {
        $(`div#${tableID}_wrapper div.dataTables_scrollHeadInner`).css('width', '100%');
        $(`div#${tableID}_wrapper div.dataTables_scrollHeadInner table`).css('width', '100%');
        $(`#${tableID}`).css('width', '100%');
        $($.fn.dataTable.tables(true)).DataTable().columns.adjust();
    }, 200);
}

function displayModalDatatable(datatable, primaryColumn, onRowClick = null) {
    $('#chart-datatable_wrapper table').empty();
    $('#chart-datatable tbody').off('click', 'tr');
    $('#chart-datatable h4').remove();

    if (datatable.length === 0) {
        $('#chart-datatable').append('<h4 class="text-muted text-center my-2">No transaction</h4>');
        return;
    }

    (async () => {
        if (datatable[0]['Date']) {
            datatable = datatable.map((row) => {
                const date = Date.parse(row['Date']);
                return { ...row, Date: moment(date).format('MMM D YYYY') }
            })
        }

        await ConstTABLE(1, datatable, 'chart-datatable', 0, 'asc');

        // Fix datatable size and header alignment
        //$('div#chart-datatable_wrapper div.row:nth-child(2)').removeClass('row').addClass('d-flex');
        //$('div#chart-datatable_wrapper div.d-flex div.col-sm-12').removeClass('col-sm-12').addClass('flex-grow-1');
        fixHeaderAlignment('chart-datatable');

        $('#chart-datatable tbody').on('click', 'tr', function () {
            const primaryColTD = $(this).children()[primaryColumn - 1];
            if (onRowClick) onRowClick($(primaryColTD).attr('id'));
        });
    })();
}

function shouldRerender(key, response) {
    if (responses.hasOwnProperty(key) && responses[key] === response) {
        return false;
    }
    responses[key] = response;
    return true;
}

function showAllFilters() {
    $('div.input-group:has(#daterangetrans)').css('visibility', 'visible');
    $('div.input-group:has(#customer-input)').css('visibility', 'visible');
    //$('.filter-group').removeClass('justify-content-start');
    //$('.filter-group').addClass('justify-content-between');
    $('div.input-group:has(#daterangetrans)').css('width', 'auto');
    $('div.input-group:has(#daterangetrans)').css('height', 'auto');
    $('div.input-group:has(#customer-input)').css('width', 'auto');
    $('div.input-group:has(#customer-input)').css('height', 'auto');
    $('div.input-group:has(#warehouse-input) a.dropdown-item[data-code="All"]').css('display', 'block');
}

function loadTab(tab) {
    let customerCode = getCustomerCode();
    let warehouseCode = getWarehouseCode();
    collapseAll();
    switch (tab) {
        case 'tab-inbound': {
            showAllFilters();
            getInboundData((chartsData) => {
                renderInboundCharts(chartsData);
            });

            getTrailsCountTable(customerCode, warehouseCode, DateStart, DateEnd, 'Inbound', (response) => {
                const datatable = parseData(response.d);
                $('#inbound-trails-datatable_wrapper table').empty();
                $('#inbound-trails-datatable').empty();

                if (datatable.length === 0) {
                    $('#inbound-trails-datatable').append('<h4 class="text-muted ml-2 my-2">No transaction</h4>');
                    return;
                }

                (async () => {
                    await ConstTABLE(1, datatable, 'inbound-trails-datatable', 0, 'asc');
                    $('div#inbound-trails-datatable_wrapper div.dataTables_scrollBody').css('max-height', '400px');
                    fixHeaderAlignment('inbound-trails-datatable');
                })();
            });
            break;
        }
        case 'tab-outbound': {
            showAllFilters();
            getOutboundData((chartsData) => {
                renderOutboundCharts(chartsData);
            });

            getTrailsCountTable(customerCode, warehouseCode, DateStart, DateEnd, 'Outbound', (response) => {
                const datatable = parseData(response.d);
                $('#outbound-trails-datatable_wrapper table').empty();
                $('#outbound-trails-datatable').empty();

                if (datatable.length === 0) {
                    $('#outbound-trails-datatable').append('<h4 class="text-muted ml-2 my-2">No transaction</h4>');
                    return;
                }

                (async () => {
                    await ConstTABLE(1, datatable, 'outbound-trails-datatable', 0, 'asc');
                    $('div#outbound-trails-datatable_wrapper div.dataTables_scrollBody').css('max-height', '400px');
                    fixHeaderAlignment('outbound-trails-datatable');
                })();
            });
            break;
        }
        case 'tab-productivity': {
            showAllFilters();
            $('div.input-group:has(#daterangetrans)').css('visibility', 'hidden');
            $('div.input-group:has(#daterangetrans)').css('width', '0');
            $('div.input-group:has(#daterangetrans)').css('height', '0');
            //getProductivityData(customerCode, warehouseCode, DateStart, DateEnd, (chart) => {
            //    renderProductivityCharts(chart);
            //});
            getProductivityData(customerCode, warehouseCode, (response) => {
                renderProductivityCharts(response);
            });
            break;
        }
        case 'tab-truck-transaction': {
            showAllFilters();
            let transactionType = $('#transaction-type-select').val() ? $('#transaction-type-select').val() : 'ALL';
            const prevDocNumber = $("#doc-number-input").val();
            getDocNumbers(customerCode, warehouseCode, DateStart, DateEnd, transactionType, (response) => {
                docNumbers = parseData(response.d)
                const filteredDocNumbers = getFilteredDocNumbers();
                fillDocNumberDropdown(filteredDocNumbers);
                $("#doc-number-input").val('');
            });

            getTransactionDatatable(customerCode, warehouseCode, DateStart, DateEnd, transactionType, (datatable) => {
                $('#truck-transactions-datatable_wrapper table').empty();
                $('#truck-transactions-datatable').empty();

                if (datatable.length === 0) {
                    $('#truck-transactions-datatable').append('<h4 class="text-muted ml-2 my-2">No transaction</h4>');
                    return;
                }

                $("#doc-number-input").val(prevDocNumber);
                if (prevDocNumber != '') {
                    $(function () {
                        let e = $.Event('keyup');
                        e.which = 13;
                        $('#doc-number-input').trigger(e);
                    });
                }

                (async () => {
                    await ConstTABLE(1, datatable, 'truck-transactions-datatable', 9, 'asc');
                    $('div#truck-transactions-datatable_wrapper div.dataTables_scrollBody').css('max-height', '400px');
                    $('div#truck-transactions-datatable_wrapper div.dataTables_scrollHead th:nth-child(13)').text('StartLoad/UnloadTime');
                    $('div#truck-transactions-datatable_wrapper div.dataTables_scrollHead th:nth-child(14)').text('EndLoad/UnloadTime');
                    $('div#truck-transactions-datatable_wrapper div.dataTables_scrollHead th:nth-child(17)').text('StartRR/WRProcessingTime');
                    $('div#truck-transactions-datatable_wrapper div.dataTables_scrollHead th:nth-child(18)').text('EndRR/WRProcessingTime');
                    fixHeaderAlignment('truck-transactions-datatable');
                })();
            })
            break;
        }
        case 'tab-contract': {
            $('div.input-group:has(#daterangetrans)').css('visibility', 'hidden');
            $('div.input-group:has(#customer-input)').css('visibility', 'visible');
            //$('.filter-group').removeClass('justify-content-start');
            //$('.filter-group').addClass('justify-content-between');
            $('div.input-group:has(#daterangetrans)').css('width', '0');
            $('div.input-group:has(#daterangetrans)').css('height', '0');
            $('div.input-group:has(#customer-input)').css('width', 'auto');
            $('div.input-group:has(#customer-input)').css('height', 'auto');
            let expiratioNear = $('#expiration-input').val();
            getContracts(customerCode, warehouseCode, 'All', 'All', expiratioNear, (contracts) => {
                getContractTotals(contracts);
                contractStatusesDonutChart = renderDonutChart(contractStatusesDonutChart, Object.values(contractStatusTotals),
                    Object.keys(contractStatusTotals), '#contract-status-chart',
                    (event, chartContext, config) => { contractChartOnClick(event, chartContext, config, 'contract-status-donut-chart') },
                    ['#8950FC', '#fd7e14', '#dc3545']
                );
                contractTypesDonutChart = renderDonutChart(contractTypesDonutChart, Object.values(contractTypeTotals),
                    Object.keys(contractTypeTotals), '#contract-type-chart',
                    (event, chartContext, config) => { contractChartOnClick(event, chartContext, config, 'contract-type-donut-chart') }
                );

                $('#contracts-datatable_wrapper table').empty();
                $('#contracts-datatable').empty();

                if (contracts.length === 0) {
                    $('#contracts-datatable').append('<h4 class="text-muted ml-2 my-2">No transaction</h4>');
                    return;
                }

                (async () => {
                    await ConstTABLE(1, contracts, 'contracts-datatable', 0, 'asc');
                    $('div#contracts-datatable_wrapper div.dataTables_scrollBody').css('max-height', '400px');
                    fixHeaderAlignment('contracts-datatable');
                })();
            }, 'datatable')
            break;
        }
        case 'tab-perfect-shipment': {
            showAllFilters();
            getPerfectShipmentScores(customerCode, warehouseCode, DateStart, DateEnd, (data) => {
                renderPerfectShipmentCharts(data);
            })

            getPerfectShipmentDataTable(customerCode, warehouseCode, DateStart, DateEnd, 'All', 'All', 'All', 'All', 'All', (transactions) => {
                const outboundDatatable = transactions.outbound;
                const inboundDatatable = transactions.inbound;

                $('#shipment-outbound-datatable_wrapper table').empty();
                $('#shipment-outbound-datatable').empty();
                $('#shipment-inbound-datatable_wrapper table').empty();
                $('#shipment-inbound-datatable').empty();

                if (outboundDatatable.length === 0) {
                    $('#shipment-outbound-datatable').append('<h4 class="text-muted ml-2 my-2">No transaction</h4>');
                }
                else {
                    (async () => {
                        await ConstTABLE(1, outboundDatatable, 'shipment-outbound-datatable', 0, 'asc');
                        $('div#shipment-outbound-datatable_wrapper div.dataTables_scrollBody').css('max-height', '400px');
                        fixHeaderAlignment('shipment-outbound-datatable');
                    })();
                }

                if (inboundDatatable.length === 0) {
                    $('#shipment-inbound-datatable').append('<h4 class="text-muted ml-2 my-2">No transaction</h4>');
                }
                else {
                    (async () => {
                        await ConstTABLE(1, inboundDatatable, 'shipment-inbound-datatable', 0, 'asc');
                        $('div#shipment-inbound-datatable_wrapper div.dataTables_scrollBody').css('max-height', '400px');
                        fixHeaderAlignment('shipment-inbound-datatable');
                    })();
                }
            }, 'datatable');
            break;
        }
        case 'tab-queue': {
            $('div.input-group:has(#daterangetrans)').css('visibility', 'hidden');
            $('div.input-group:has(#customer-input)').css('visibility', 'hidden');
            //$('.filter-group').removeClass('justify-content-between');
            //$('.filter-group').addClass('justify-content-start');
            $('div.input-group:has(#daterangetrans)').css('width', '0');
            $('div.input-group:has(#daterangetrans)').css('height', '0');
            $('div.input-group:has(#customer-input)').css('width', '0');
            $('div.input-group:has(#customer-input)').css('height', '0');
            $('div.input-group:has(#warehouse-input) a.dropdown-item[data-code="All"]').css('display', 'none');
            getQueue(warehouseCode, (rows) => fillQueueTable(rows))
            break;
        }
        case 'tab-monitoring':
            showAllFilters();
            getMonitoringTruckStatus(customerCode, DateStart, DateEnd, async (rows) => {
                monitoringRows = rows;
                fillMonitoringCounts(monitoringRows);
                fillMonitoringList(monitoringRows);
            });
            setMonitoringLineChart(customerCode, DateStart, DateEnd);
            setMonitoringTransactionsPieChart(customerCode, DateStart, DateEnd);
            setMonitoringTransactionsTreeChart(customerCode, DateStart, DateEnd);
            setMonitoringInventoryTreeChart(customerCode, DateStart, DateEnd);
            setMonitoringCounts(customerCode, DateStart, DateEnd);
            setMonitoringRadialCharts(customerCode, DateStart, DateEnd);
            break;
        default:
            //show error dialog
            break;
    }
}

function getInboundData(onSuccess) {
    let Customer = getCustomerCode();
    let Warehouse = getWarehouseCode();
    let TransType = 'INBOUND';

    let requestParams = {
        DateStart,
        DateEnd,
        TransType,
        Customer,
        Warehouse,
    }

    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetData",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: '{_data:' + JSON.stringify(requestParams) + '}',
        success: (responseData) => {
            //if (!shouldRerender('inboundTransactions', responseData.d[0])
            //    && !shouldRerender('inboundCounts', responseData.d[1])) {
            //    return;
            //}

            const transactionDataList = parseData(responseData.d[0]);
            const counts = parseData(responseData.d[1])[0];

            transactions = {};
            categories = [];
            statusTotals = {};
            storageTypeTotals = {};


            transactionDataList.forEach((transactionData) => {
                const storageType = transactionData['x'].charAt(0) + transactionData['x'].slice(1).toLowerCase();
                const progressStatus = transactionData['name'].charAt(0) + transactionData['name'].slice(1).toLowerCase();

                if (!categories.includes(storageType)) categories.push(storageType);

                if (typeof transactions[progressStatus] === "undefined") {
                    transactions[progressStatus] = {};
                    transactions[progressStatus][storageType] = transactionData.y;
                    statusTotals[progressStatus] = transactionData.y;
                }
                else {
                    transactions[progressStatus][storageType] = transactions[progressStatus][storageType] ?
                        transactions[progressStatus][storageType] + transactionData.y : transactionData.y;
                    statusTotals[progressStatus] = statusTotals[progressStatus] ?
                        statusTotals[progressStatus] + transactionData.y : transactionData.y;
                }

                storageTypeTotals[storageType] = storageTypeTotals[storageType] ?
                    storageTypeTotals[storageType] + transactionData.y : transactionData.y;
            });

            let transactionChartSeries = [];
            Object.keys(transactions).forEach((status) => {
                transactionChartSeries.push({ name: status, data: Object.values(transactions[status]) });
            });

            onSuccess({
                transactionChartSeries: transactionChartSeries,
                categories: categories,
                statusTotals: statusTotals,
                storageTypeTotals: storageTypeTotals,
                counts: counts
            });

        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });

}

function getOutboundData(onSuccess) {
    let Customer = getCustomerCode();
    let Warehouse = getWarehouseCode();
    let TransType = 'OUTBOUND';

    let requestParams = {
        DateStart,
        DateEnd,
        TransType,
        Customer,
        Warehouse,
    }

    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetData",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: '{_data:' + JSON.stringify(requestParams) + '}',
        success: (responseData) => {
            //if (!shouldRerender('outboundTransactions', responseData.d[0])) return;

            outboundTransactions = {};
            outboundTransactionCategories = [];
            outboundStatusTotals = {};
            shipmentTypeTotals = {};

            const dataList = parseData(responseData.d[0]);

            dataList.forEach((transactionData) => {
                const shipmentType = transactionData['shipment_type'].charAt(0) + transactionData['shipment_type'].slice(1).toLowerCase();
                const status = transactionData['status'].charAt(0) + transactionData['status'].slice(1).toLowerCase();

                if (!outboundTransactionCategories.includes(shipmentType)) outboundTransactionCategories.push(shipmentType);

                if (typeof outboundTransactions[status] === "undefined") {
                    outboundTransactions[status] = {};
                    outboundTransactions[status][shipmentType] = transactionData.count;
                    outboundStatusTotals[status] = transactionData.count;
                }
                else {
                    outboundTransactions[status][shipmentType] = outboundTransactions[status][shipmentType] ?
                        outboundTransactions[status][shipmentType] + transactionData.count : transactionData.count;
                    outboundStatusTotals[status] = outboundStatusTotals[status] ?
                        outboundStatusTotals[status] + transactionData.count : transactionData.count;
                }

                shipmentTypeTotals[shipmentType] = shipmentTypeTotals[shipmentType] ?
                    shipmentTypeTotals[shipmentType] + transactionData.count : transactionData.count;
            });

            let transactionChartSeries = [];

            Object.keys(outboundTransactions).forEach((status) => {
                transactionChartSeries.push({ name: status, data: Object.values(outboundTransactions[status]) });
            });

            onSuccess({
                transactionChartSeries: transactionChartSeries,
                categories: outboundTransactionCategories,
                statusTotals: outboundStatusTotals,
                shipmentTypeTotals: shipmentTypeTotals,
            });
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function getTrailsCountTable(customerCode, warehouseCode, dateFrom, dateTo, transactionType, onSuccess) {
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetTrailsCount",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            customerCode: customerCode,
            warehouseCode: warehouseCode,
            dateFrom: dateFrom,
            dateTo: dateTo,
            transactionType: transactionType
        }),
        success: (response) => {
            //if (!shouldRerender(`transactionTrails${transactionType}`, response.d)) return;

            onSuccess(response);
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function getInboundChartDatatable(customerCode, warehouseCode, dateFrom, dateTo, storage, status, billing, onSuccess) {
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetInboundDatatable",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            customerCode: customerCode,
            warehouseCode: warehouseCode,
            dateFrom: DateStart,
            dateTo: DateEnd,
            storage: storage,
            status: status,
            billing: billing,
        }),
        success: (response) => {
            onSuccess(response);
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function getOutboundChartDatatable(customerCode, warehouseCode, dateFrom, dateTo, shipmentType, status, onSuccess) {
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetOutboundDatatable",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            customerCode: customerCode,
            warehouseCode: warehouseCode,
            dateFrom: DateStart,
            dateTo: DateEnd,
            shipmentType: shipmentType,
            status: status,
        }),
        success: (response) => {
            onSuccess(response);
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function renderInboundCharts({ transactionChartSeries, categories, statusTotals, storageTypeTotals, counts }) {
    inboundTransactionStackChart = renderStackChart(
        inboundTransactionStackChart,
        'Transactions',
        transactionChartSeries,
        categories,
        '#transaction-chart',
        (event, chartContext, config) => { inboundChartOnClick(event, chartContext, config, 'inbound-stack-chart') }
    );

    inboundStorageDonutChart = renderDonutChart(
        inboundStorageDonutChart,
        Object.values(storageTypeTotals),
        Object.keys(storageTypeTotals),
        '#storage-chart',
        (event, chartContext, config) => { inboundChartOnClick(event, chartContext, config, 'inbound-storage-donut-chart') }
    );

    inboundStatusDonutChart = renderDonutChart(
        inboundStatusDonutChart,
        Object.values(statusTotals),
        Object.keys(statusTotals),
        '#progress-status-chart',
        (event, chartContext, config) => { inboundChartOnClick(event, chartContext, config, 'inbound-status-donut-chart') }
    );

    const billedCount = counts['BilledCount'] ? counts['BilledCount'] : 0;
    const totalCount = counts['TotalTransactions'] ? counts['TotalTransactions'] : 0;
    const unbilledCount = totalCount - billedCount;
    $('#billed-count').text(billedCount);
    $('#total-count').text(totalCount);
    $('#unbilled-count').text(unbilledCount);
}

function renderOutboundCharts({ transactionChartSeries, categories, statusTotals, shipmentTypeTotals }) {
    outboundTransactionStackChart = renderStackChart(
        outboundTransactionStackChart,
        'Transactions',
        transactionChartSeries,
        categories,
        '#outbound-transaction-chart',
        (event, chartContext, config) => { outboundChartOnClick(event, chartContext, config, 'outbound-stack-chart') }
    );

    outboundShipmentTypeDonutChart = renderDonutChart(
        outboundShipmentTypeDonutChart,
        Object.values(shipmentTypeTotals),
        Object.keys(shipmentTypeTotals),
        '#shipment-type-chart',
        (event, chartContext, config) => { outboundChartOnClick(event, chartContext, config, 'outbound-shipment-donut-chart') }
    );

    outboundStatusDonutChart = renderDonutChart(
        outboundStatusDonutChart,
        Object.values(statusTotals),
        Object.keys(statusTotals),
        '#outbound-status-chart',
        (event, chartContext, config) => { outboundChartOnClick(event, chartContext, config, 'outbound-status-donut-chart') }
    );
}

function inboundChartOnClick(event, chartContext, config, chart) {
    let customerCode = getCustomerCode();
    let warehouseCode = getWarehouseCode();
    let storageType = '';
    let status = '';
    let modalLabel = '';

    switch (chart) {
        case 'inbound-stack-chart':
            storageType = categories[config.dataPointIndex];
            status = Object.keys(statusTotals)[config.seriesIndex];
            modalLabel = `${storageType} - ${status}`;
            break;
        case 'inbound-status-donut-chart':
            status = Object.keys(statusTotals)[config.dataPointIndex];
            storageType = 'All';
            modalLabel = status;
            break;
        case 'inbound-storage-donut-chart':
            storageType = categories[config.dataPointIndex];
            status = 'All';
            modalLabel = storageType;
            break;
        default:
            break;
    }

    $('#datatable-modal-label').text(modalLabel);
    $('#datatable-modal').modal('show');

    getInboundChartDatatable(customerCode, warehouseCode, DateStart, DateEnd, storageType, status, 'All',
        (response) => {
            //displayModalDatatable(parseData(response.d), 2, inboundModalRowOnClick);
            displayModalDatatable(parseData(response.d), 2);
        }
    );
}

function outboundChartOnClick(event, chartContext, config, chart) {
    let customerCode = getCustomerCode();
    let warehouseCode = getWarehouseCode();
    let shipmentType = '';
    let status = '';
    let modalLabel = '';

    switch (chart) {
        case 'outbound-stack-chart':
            shipmentType = outboundTransactionCategories[config.dataPointIndex];
            status = Object.keys(outboundStatusTotals)[config.seriesIndex];
            modalLabel = `${shipmentType} - ${status}`;
            break;
        case 'outbound-status-donut-chart':
            status = Object.keys(outboundStatusTotals)[config.dataPointIndex];
            shipmentType = 'All';
            modalLabel = status;
            break;
        case 'outbound-shipment-donut-chart':
            shipmentType = outboundTransactionCategories[config.dataPointIndex];
            status = 'All';
            modalLabel = shipmentType;
            break;
        default:
            break;
    }

    $('#datatable-modal-label').text(modalLabel);
    $('#datatable-modal').modal('show');

    getOutboundChartDatatable(customerCode, warehouseCode, DateStart, DateEnd, shipmentType, status,
        (response) => {
            displayModalDatatable(parseData(response.d), 2);
        }
    );
}

function inboundCardOnClick(label, billing) {
    let customerCode = getCustomerCode();
    let warehouseCode = getWarehouseCode();

    $('#datatable-modal-label').text(label);
    $('#datatable-modal').modal('show');

    getInboundChartDatatable(customerCode, warehouseCode, DateStart, DateEnd, 'All', 'All', billing,
        (response) => {
            //displayModalDatatable(parseData(response.d), 2, inboundModalRowOnClick);
            displayModalDatatable(parseData(response.d), 2);
        }
    );
}

function inboundModalRowOnClick(data) {
    $('#row-detail-modal-label').text('Transaction Details');
    $('#row-detail-modal .modal-body h4').empty();
    $('#row-detail-modal .modal-body h4').text(data);
    $('#datatable-modal').modal('hide');
    $('#row-detail-modal').modal('show');
}

function getTransactionTrailsModalDatatable(customerCode, warehouseCode, dateFrom, dateTo, status, transactionType, onSuccess) {
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetStatusFilteredTransactions",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            customerCode: customerCode,
            warehouseCode: warehouseCode,
            dateFrom: dateFrom,
            dateTo: dateTo,
            status: status,
            transactionType: transactionType
        }),
        success: (response) => {
            onSuccess(response);
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function getDocNumbers(customerCode, warehouseCode, dateFrom, dateTo, transactionType, onSuccess) {
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetDocumentNumber",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            customerCode: customerCode,
            warehouseCode: warehouseCode,
            dateFrom: dateFrom,
            dateTo: dateTo,
            transactionType: transactionType
        }),
        success: (response) => {
            if (!shouldRerender('truckTransactionDocNumbers', response.d)) return;
            resetTruckTransactionGraph();
            onSuccess(response);
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function fillDocNumberDropdown(options) {
    $('#doc-number div.dropdown-menu').empty();

    if (options.length === 0) {
        $('#doc-number div.dropdown-menu').append('<a class="dropdown-item selected" data-code="">No transaction matched</a>')
    }
    options.forEach((option) => {
        $('#doc-number div.dropdown-menu').append(`<a class="dropdown-item" data-code="${option.DocNumber.toLowerCase()}">${option.DocNumber}</a>`);
    });
}

function getFilteredDocNumbers() {
    const filter = $('#doc-number-input').val().toLowerCase();
    return docNumbers.filter((docNumber) => {
        return docNumber.DocNumber.toLowerCase().includes(filter)
    });
}

function getTruckingTransaction(docNumber, transactionType, onSuccess) {
    if (docNumber == '') return;

    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetTruckingTransaction",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            docNumber: docNumber,
            transactionType: transactionType
        }),
        success: (response) => {
            onSuccess(response);
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function fillTruckTransactionStatuses(transaction) {
    resetTruckTransactionGraph();

    changeTruckTransactionGraphLabel(transaction['TransactionType']);

    if (transaction['AddedDate']) {
        $('#request-created').addClass('completed');
        const date = Date.parse(transaction['AddedDate']);
        $('#request-created-date').html(moment(date).format('MMM D YYYY, h:mm a'));
    }

    if (transaction['Arrival']) {
        $('#truck-arrival').addClass('completed');
        const date = Date.parse(transaction['Arrival']);
        $('#truck-arrival-date').html(moment(date).format('MMM D YYYY, h:mm a'));
    }

    if (transaction['DockingTime']) {
        $('#docking').addClass('completed');
        const date = Date.parse(transaction['DockingTime']);
        $('#docking-date').html(moment(date).format('MMM D YYYY, h:mm a'));
    }

    if (transaction['StartLoading']) {
        $('#start-loading').addClass('completed');
        const date = Date.parse(transaction['StartLoading']);
        $('#start-loading-date').html(moment(date).format('MMM D YYYY, h:mm a'));
    }

    if (transaction['CheckingStart']) {
        $('#start-checking').addClass('completed');
        const date = Date.parse(transaction['CheckingStart']);
        $('#start-checking-date').html(moment(date).format('MMM D YYYY, h:mm a'));
    }

    if (transaction['CheckingEnd']) {
        $('#end-checking').addClass('completed');
        const date = Date.parse(transaction['CheckingEnd']);
        $('#end-checking-date').html(moment(date).format('MMM D YYYY, h:mm a'));
    }

    if (transaction['EndLoading']) {
        $('#end-loading').addClass('completed');
        const date = Date.parse(transaction['EndLoading']);
        $('#end-loading-date').html(moment(date).format('MMM D YYYY, h:mm a'));
    }

    if (transaction['StartProcessing']) {
        $('#start-processing').addClass('completed');
        const date = Date.parse(transaction['StartProcessing']);
        $('#start-processing-date').html(moment(date).format('MMM D YYYY, h:mm a'));
    }

    if (transaction['EndProcessing']) {
        $('#end-processing').addClass('completed');
        const date = Date.parse(transaction['EndProcessing']);
        $('#end-processing-date').html(moment(date).format('MMM D YYYY, h:mm a'));
    }

    if (transaction['Departure']) {
        $('#departure').addClass('completed');
        const date = Date.parse(transaction['Departure']);
        $('#departure-date').html(moment(date).format('MMM D YYYY, h:mm a'));
    }

}

function changeTruckTransactionGraphLabel(transactionType) {
    if (transactionType == 'Inbound' || transactionType == 'All') {
        $('#start-loading .status-label').text('Start Unloading');
        $('#end-loading .status-label').text('End Unloading');
        $('#start-processing .status-label').text('Start Processing RR');
        $('#end-processing .status-label').text('End Processing RR');
    }
    else {
        $('#start-loading .status-label').text('Start Loading');
        $('#end-loading .status-label').text('End Loading');
        $('#start-processing .status-label').text('Start Processing WR');
        $('#end-processing .status-label').text('End Processing WR');
    }
}

function resetTruckTransactionGraph() {
    $('#request-created').removeClass('completed');
    $('#request-created-date').html('&nbsp;');

    $('#truck-arrival').removeClass('completed');
    $('#truck-arrival-date').html('&nbsp;');

    $('#truck-arrival').removeClass('completed');
    $('#truck-arrival-date').html('&nbsp;');

    $('#docking').removeClass('completed');
    $('#docking-date').html('&nbsp;');

    $('#start-loading').removeClass('completed');
    $('#start-loading-date').html('&nbsp;');

    $('#start-checking').removeClass('completed');
    $('#start-checking-date').html('&nbsp;');

    $('#end-checking').removeClass('completed');
    $('#end-checking-date').html('&nbsp;');

    $('#end-loading').removeClass('completed');
    $('#end-loading-date').html('&nbsp;');

    $('#start-processing').removeClass('completed');
    $('#start-processing-date').html('&nbsp;');

    $('#end-processing').removeClass('completed');
    $('#end-processing-date').html('&nbsp;');

    $('#departure').removeClass('completed');
    $('#departure-date').html('&nbsp;');
}

function getFilteredCustomers() {
    const filter = $('#customer-input').val().toLowerCase();

    if (filter === 'all') return customers;

    return customers.filter((customer) => {
        return `${customer.Name.toLowerCase()} - ${customer.Code.toLowerCase()}`.includes(filter);
    });
}

function fillCustomersDropdown(options) {
    $('#customer div.dropdown-menu').empty();

    if (options.length === 0) {
        $('#customer div.dropdown-menu').append('<a class="dropdown-item selected" data-code="">No customer matched</a>');
        return;
    }
    else if (options.length > 1) {
        $('#customer div.dropdown-menu').append('<a class="dropdown-item selected" data-code="all">All</a>');
    }

    options.forEach((option) => {
        $('#customer div.dropdown-menu').append(`<a class="dropdown-item" data-code="${option.Code.toLowerCase()}">${option.Name} - ${option.Code}</a>`);
    });
}

function getTransactionDatatable(customerCode, warehouseCode, dateFrom, dateTo, transactionType, onSuccess) {
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetTruckTransactionsDataTable",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            customerCode: customerCode,
            warehouseCode: warehouseCode,
            dateFrom: dateFrom,
            dateTo: dateTo,
            transactionType: transactionType
        }),
        success: (response) => {
            //if (!shouldRerender('truckTransactions', response.d)) return;
            resetTruckTransactionGraph();

            const table = parseData(response.d);
            table.forEach((row) => {
                row['TransactionDate'] = row['TransactionDate'] ? moment(Date.parse(row['TransactionDate'])).format('MMM D YYYY') : '';
                row['ArrivalTime'] = row['ArrivalTime'] ? moment(Date.parse(row['ArrivalTime'])).format('MMM D YYYY, h:mm a') : '';
                row['DockingTime'] = row['DockingTime'] ? moment(Date.parse(row['DockingTime'])).format('MMM D YYYY, h:mm a') : '';
                row['StartLoad'] = row['StartLoad'] ? moment(Date.parse(row['StartLoad'])).format('MMM D YYYY, h:mm a') : '';
                row['EndLoad'] = row['EndLoad'] ? moment(Date.parse(row['EndLoad'])).format('MMM D YYYY, h:mm a') : '';
                row['StartCheckingTime'] = row['StartCheckingTime'] ? moment(Date.parse(row['StartCheckingTime'])).format('MMM D YYYY, h:mm a') : '';
                row['EndCheckingTime'] = row['EndCheckingTime'] ? moment(Date.parse(row['EndCheckingTime'])).format('MMM D YYYY, h:mm a') : '';
                row['StartProcessing'] = row['StartProcessing'] ? moment(Date.parse(row['StartProcessing'])).format('MMM D YYYY, h:mm a') : '';
                row['EndProcessing'] = row['EndProcessing'] ? moment(Date.parse(row['EndProcessing'])).format('MMM D YYYY, h:mm a') : '';
                row['DepartureTime'] = row['DepartureTime'] ? moment(Date.parse(row['DepartureTime'])).format('MMM D YYYY, h:mm a') : '';
                row['HoldDate'] = row['HoldDate'] ? moment(Date.parse(row['HoldDate'])).format('MMM D YYYY, h:mm a') : '';
                row['UnHoldDate'] = row['UnHoldDate'] ? moment(Date.parse(row['UnHoldDate'])).format('MMM D YYYY, h:mm a') : '';
                row['LoadingTime'] = row['LoadingTime'] ? moment(Date.parse(row['LoadingTime'])).format('MMM D YYYY, h:mm a') : '';
                row['CancelledDate'] = row['CancelledDate'] ? moment(Date.parse(row['CancelledDate'])).format('MMM D YYYY') : '';
                row['AddedDate'] = row['AddedDate'] ? moment(Date.parse(row['AddedDate'])).format('MMM D YYYY') : '';
            });

            onSuccess(table);
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function getProductivityData(customerCode, warehouseCode, onSuccess) {
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetProductivity",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            customerCode: customerCode,
            warehouseCode: warehouseCode,
            //dateFrom: dateFrom,
            //dateTo: dateTo,
            sortBy: $('#sort-by').val(),
            sortDirection: $('#sort-direction').val(),
            visibleMonth: $('#month').val(),
        }),
        success: (response) => {
            //if (!shouldRerender('checkerProductivity', response.d[0]) && !shouldRerender('docsProductivity', response.d[1])) return;

            onSuccess(response)
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

async function renderProductivityCharts(/*{ productivityChartSeries, categories }*/ data) {
    $('#productivity-chart').empty();

    const checkersData = parseData(data.d[0]);
    const docsData = parseData(data.d[1]);
    const operatorsData = parseData(data.d[2]);
    const imsData = parseData(data.d[3]);

    for (let month = 0; month < 12; month++) {
        if (checkersData[month] === null) continue;

        const checkersCard = $(`
            <div class="d-flex flex-grow-1 p-2 card border m-0">
                <div class="d-flex justify-content-center">
                    <h5 class="d-flex m-2">Checker</h5>
                    <h3 class="d-flex m-2  mr-auto ml-auto">${months[month]}</h3>
                </div>
            </div >
        `);
        checkersCard.css('flex-basis', '600px');
        const checkersChart = await createBarChart(checkersData[month], (userName, userID) => { productivityChartOnClick(userName, userID, 'Checker', month) });
        checkersCard.append(checkersChart);
        $('#productivity-chart').append(checkersCard);
    }

    for (let month = 0; month < 12; month++) {
        if (docsData[month] === null) continue;

        const docsCard = $(`
            <div class="d-flex flex-grow-1 p-2 card border m-0">
                <div class="d-flex justify-content-center">
                    <h5 class="d-flex m-2">Documentation</h5>
                    <h3 class="d-flex m-2  mr-auto ml-auto">${months[month]}</h3>
                </div>
            </div >
        `);
        docsCard.css('flex-basis', '600px');
        const docsChart = await createBarChart(docsData[month], (userName, userID) => { productivityChartOnClick(userName, userID, 'Docs', month) });
        docsCard.append(docsChart);
        $('#productivity-chart').append(docsCard);
    }

    for (let month = 0; month < 12; month++) {
        if (operatorsData[month] === null) continue;

        const operatorsCard = $(`
            <div class="d-flex flex-grow-1 p-2 card border m-0">
                <div class="d-flex justify-content-center">
                    <h5 class="d-flex m-2">Operator Picker</h5>
                    <h3 class="d-flex m-2  mr-auto ml-auto">${months[month]}</h3>
                </div>
            </div >
        `);
        operatorsCard.css('flex-basis', '600px');
        const operatorsChart = await createBarChart(operatorsData[month], (userName, userID) => { productivityChartOnClick(userName, userID, 'Operator', month) });
        operatorsCard.append(operatorsChart);
        $('#productivity-chart').append(operatorsCard);
    }

    for (let month = 0; month < 12; month++) {
        if (imsData[month] === null) continue;

        const imsCard = $(`
            <div class="d-flex flex-grow-1 p-2 card border m-0">
                <div class="d-flex justify-content-center">
                    <h5 class="d-flex m-2">IM</h5>
                    <h3 class="d-flex m-2  mr-auto ml-auto">${months[month]}</h3>
                </div>
            </div >
        `);
        imsCard.css('flex-basis', '600px');
        const imsChart = await createBarChart(imsData[month], (userName, userID) => { productivityChartOnClick(userName, userID, 'IM', month) });
        imsCard.append(imsChart);
        $('#productivity-chart').append(imsCard);
    }
}

function productivityChartOnClick(userName, userID, userRole, month) {
    //const status = config.seriesIndex == 0 ? 'Completed' : 'Ongoing';
    $('#datatable-modal-label').text(`${titleCase(userName)} - ${months[month]}`);
    $('#datatable-modal').modal('show');
    let customerCode = getCustomerCode();
    let warehouseCode = getWarehouseCode();
    //const userID = checkerIDs[config.dataPointIndex];

    getProductivityChartDatatable(userID, userRole, customerCode, warehouseCode, month,
        (response) => {
            const datatable = parseData(response.d);
            displayModalDatatable(parseData(response.d), 2);
        }
    );
}

function getProductivityChartDatatable(userID, userRole, customerCode, warehouseCode, month, onSuccess) {
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetProductivityTransactions",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            customerCode: customerCode,
            warehouseCode: warehouseCode,
            userID: userID,
            userRole: userRole,
            month: month
        }),
        success: (response) => {
            onSuccess(response);
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function getContracts(customerCode, warehouseCode, status, type, expirationNear, onSuccess, initiator) {
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetContracts",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            customerCode: customerCode,
            warehouseCode: warehouseCode,
            status: status,
            type: type,
            expirationNearDate: expirationNear
        }),
        success: (responseData) => {
            //if (initiator === 'datatable' && !shouldRerender(`${initiator}contracts`, responseData.d)) return;

            let contracts = parseData(responseData.d);
            contracts.forEach((contract) => {
                contract['EffectivityDate'] = contract['EffectivityDate'] ? moment(Date.parse(contract['EffectivityDate'])).format('MMM D YYYY') : '';
                contract['DateFrom'] = contract['DateFrom'] ? moment(Date.parse(contract['DateFrom'])).format('MMM D YYYY') : '';
                contract['DateTo'] = contract['DateTo'] ? moment(Date.parse(contract['DateTo'])).format('MMM D YYYY') : '';
            })
            onSuccess(contracts);
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function getContractTotals(contracts) {
    contractStatusTotals = { 'Active': 0, 'About to Expire': 0, 'Expired': 0 };
    contractTypeTotals = {};

    contracts.forEach((contract) => {
        let contractType = titleCase(contract['ContractType']);
        switch (contract['Status']) {
            case 'Active':
                contractStatusTotals['Active'] += 1;
                break;
            case 'About to Expire':
                contractStatusTotals['About to Expire'] += 1;
                break;
            case 'Expired':
                contractStatusTotals['Expired'] += 1;
                break;
        }

        contractTypeTotals[contractType] = contractTypeTotals[contractType] ? contractTypeTotals[contractType] + 1 : 1;
    });

    contractTypeTotals = Object.keys(contractTypeTotals).length > 0 ? contractTypeTotals : { 'New Contract': 0, 'Revision': 0, 'Renewal': 0 }

    return {
        contractStatusTotals: contractStatusTotals,
        contractTypeTotals: contractTypeTotals
    };
}

function contractChartOnClick(event, chartContext, config, chart) {
    let customerCode = getCustomerCode();
    let warehouseCode = getWarehouseCode();
    let expiratioNear = $('#expiration-input').val();
    let type = '';
    let status = '';
    let modalLabel = '';

    switch (chart) {
        case 'contract-status-donut-chart':
            status = Object.keys(contractStatusTotals)[config.dataPointIndex];
            type = 'All';
            modalLabel = status;
            break;
        case 'contract-type-donut-chart':
            type = Object.keys(contractTypeTotals)[config.dataPointIndex];
            status = 'All';
            modalLabel = type;
            break;
        default:
            break;
    }

    $('#datatable-modal-label').text(modalLabel);
    $('#datatable-modal').modal('show');

    getContracts(customerCode, warehouseCode, status, type, expiratioNear, (contracts) => {
        displayModalDatatable(contracts, 1);
    }, chart)
}

async function Parameters() {
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/Parameter",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            customers = parseData(data.d[0]);
            customers.forEach((customer) => {
                $('#customer div.dropdown-menu').append(`<a class="dropdown-item" data-code="${customer.Code.toLowerCase()}">${customer.Name} - ${customer.Code}</a>`);
            });

            //let warehouse = parseData(data.d[1]);
            warehouseCode = data.d[2];
            //if (companyCode != 'All') {
            //    $('#warehouse a.selected').removeClass('selected');
            //}

            //warehouse.forEach((obj) => {
            //    if (companyCode == obj.Code) {
            //        $('#warehouse input').val(obj.Description);
            //        $('#warehouse input').attr('data-original-title', obj.Description);
            //    }
            //    $('#warehouse div.dropdown-menu').append(`<a class="dropdown-item ${companyCode == obj.Code ? 'selected' : ''}" data-code="${obj.Code}">${obj.Description} &nbsp;</a>`);
            //});

        },
        error: function (error) {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON.Message}`);
        }
    });
}

async function createBarChart(rows, onRowClick) {
    let bar = $('<div class="bar"></div>');
    bar.css('width', '100%');

    const overFlowWrapper = $('<div class="overflow-auto"></div>');
    const chartContainer = $('<div class="chart-container p-2"></div>');
    const yLeftTitle = $('<h6 class="text-center m-0">Names</h6>');
    const yRightTitle = $('<h6 class="text-center m-0">Rank</h6>');
    const countTitle = $('<h6 class="text-center m-0">Count</h6>');
    countTitle.css('border-right', '1px solid lightgray');
    const yLeftLabels = $('<div class="chart-ylabel-left-container"></div>');
    const yRightLabels = $('<div class="chart-ylabel-right-container"></div>');
    const countLabels = $('<div class="chart-ylabel-right-container"></div>');
    const barContainers = $('<div class="chart-data-container"></div>');
    const xLabels = $(`<div class="chart-xlabel-container"></div>`);
    xLabels.append($('<h6>0</h6>'));
    let largestNumber = 0;
    const highlightColor = 'rgba(200, 200, 255, 0.5)';

    rows.forEach((row, index) => {
        const yLeftLabel = $(`<h6>${titleCase(row['FullName'])}</h6>`);
        yLeftLabels.append(yLeftLabel);

        const yRightLabel = $(`<h6>${parseInt(row['Rank']) > 20 || parseInt(row['Completed']) === 0 ? '' : parseInt(row['Rank'])}</h6>`);
        yRightLabels.append(yRightLabel);

        const countLabel = $(`<h6 class="m-0">${formatNumberWithCommas(row['Completed'])}</h6>`);
        countLabel.css('border-right', '1px solid lightgray');
        countLabels.append(countLabel);

        const completed = parseFloat(row['Completed']);
        largestNumber = largestNumber > completed ? largestNumber : completed;

        yLeftLabel.on('click', () => {
            onRowClick(row['FullName'], row['UserID']);
        });

        yRightLabel.on('click', () => {
            onRowClick(row['FullName'], row['UserID']);
        });

        const onMouseEnter = () => {
            yLeftLabel.css('background-color', highlightColor);
            yRightLabel.css('background-color', highlightColor);
            countLabel.css('background-color', highlightColor);
            $($(barContainers).children()[index]).css('background-color', highlightColor);
        };

        const onMouseLeave = () => {
            yLeftLabel.css('background-color', 'transparent');
            yRightLabel.css('background-color', 'transparent');
            countLabel.css('background-color', 'transparent');
            $(barContainers.children()[index]).css('background-color', 'transparent');
        };

        yLeftLabel.on('mouseenter', onMouseEnter).on('mouseleave', onMouseLeave);
        yRightLabel.on('mouseenter', onMouseEnter).on('mouseleave', onMouseLeave);
        countLabel.on('mouseenter', onMouseEnter).on('mouseleave', onMouseLeave);

        countLabel.on('click', () => {
            onRowClick(row['FullName'], row['UserID']);
        });
    });

    const maxNumber = (Math.trunc(largestNumber / 10) * 10) + 10;
    const maxNumber10Percent = maxNumber * 0.10;

    for (let counter = 1; counter < 10; counter++) {
        const xLabel = maxNumber10Percent * counter;
        const actualLabel = xLabel < 1000 ? `${xLabel}` : `${(xLabel / 1000).toFixed(2)}k`;
        xLabels.append($(`<h6>${actualLabel}</h6>`));
    }

    rows.forEach((row, index) => {
        const percentage = (parseFloat(row['Completed']) / maxNumber) * 100;
        const bar = $('<div class="bar"></div>');
        bar.css('width', '100%');
        const barFilled = $(`<div class="bar-filled"></div>`);
        //<h6 class="m-0 ${row['Completed'] ? " text-light" : "text - secondary"}" > ${ row['Completed'] }</h6 >
        barFilled.css('width', `${percentage}%`);
        barFilled.css('height', '100%');
        bar.append(barFilled);
        barContainers.append(bar);

        const onMouseEnter = () => {
            $(yLeftLabels.children()[index]).css('background-color', highlightColor);
            $(yRightLabels.children()[index]).css('background-color', highlightColor);
            $(countLabels.children()[index]).css('background-color', highlightColor);
            bar.css('background-color', highlightColor);
        };

        const onMouseLeave = () => {
            $(yLeftLabels.children()[index]).css('background-color', 'transparent');
            $(yRightLabels.children()[index]).css('background-color', 'transparent');
            $(countLabels.children()[index]).css('background-color', 'transparent');
            bar.css('background-color', 'transparent');
        };

        bar.on('mouseenter', onMouseEnter).on('mouseleave', onMouseLeave);

        bar.on('click', () => {
            onRowClick(row['FullName'], row['UserID']);
        });
    });

    if (rows.length === 0) {
        barContainers.append($('<h5 class="ml-4 text-muted mt-3 mb-1">No Data</h5>'));
    }

    chartContainer.append(yLeftTitle);
    chartContainer.append(xLabels);
    chartContainer.append(countTitle);
    chartContainer.append(yRightTitle);
    chartContainer.append(yLeftLabels);
    chartContainer.append(barContainers);
    chartContainer.append(countLabels);
    chartContainer.append(yRightLabels);
    overFlowWrapper.append(chartContainer)

    return overFlowWrapper;
}

function getPerfectShipmentDataTable(customerCode, warehouseCode, dateFrom, dateTo, transactionType, cleanInvoice, onTime, inFull, perfectShipment, onSuccess, initiator) {
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetPerfectShipmentTransactions",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            customerCode: customerCode,
            warehouseCode: warehouseCode,
            dateFrom: dateFrom,
            dateTo: dateTo,
            transactionType: transactionType,
            cleanInvoice: cleanInvoice,
            onTime: onTime,
            inFull: inFull,
            perfectShipment: perfectShipment
        }),
        success: (responseData) => {
            //if (initiator === 'datatable' && !shouldRerender(`${initiator}perfectShipment${transactionType}`, responseData.d)) return;

            let transactions = parseData(responseData.d);
            transactions.inbound.forEach((transaction) => {
                transaction['UnloadingDwellTime'] = transaction['UnloadingDwellTime'] ? moment.utc(moment.duration(parseFloat(transaction['UnloadingDwellTime']), 'minutes').asMilliseconds()).format("HH:mm") : '00:00';
                transaction['DwellTime'] = transaction['DwellTime'] ? moment.utc(moment.duration(parseFloat(transaction['DwellTime']), 'minutes').asMilliseconds()).format("HH:mm") : '00:00';
                transaction['TargetDwellTime'] = transaction['TargetDwellTime'] ? moment.utc(moment.duration(parseFloat(transaction['TargetDwellTime']), 'minutes').asMilliseconds()).format("HH:mm") : '';
                transaction['Date'] = transaction['Date'] ? moment(Date.parse(transaction['Date'])).format('MMM D YYYY') : '';
                transaction['Arrival'] = transaction['Arrival'] ? moment(Date.parse(transaction['Arrival'])).format('MMM D YYYY, h:mm a') : '';
                transaction['Departure'] = transaction['Departure'] ? moment(Date.parse(transaction['Departure'])).format('MMM D YYYY, h:mm a') : '';
                transaction['StartUnloading'] = transaction['StartUnloading'] ? moment(Date.parse(transaction['StartUnloading'])).format('MMM D YYYY, h:mm a') : '';
                transaction['CompleteUnloading'] = transaction['CompleteUnloading'] ? moment(Date.parse(transaction['CompleteUnloading'])).format('MMM D YYYY, h:mm a') : '';
                transaction['PerfectShipment'] = `<h4><span class="badge badge-${transaction['PerfectShipment'].toLowerCase() === 'hit' ? 'primary' : 'danger'}">
                                                        ${transaction['PerfectShipment']}</span></h4>`;
                transaction['CleanInvoice'] = `<h4><span class="badge badge-${transaction['CleanInvoice'].toLowerCase() === 'hit' ? 'primary' : 'danger'}">
                                                        ${transaction['CleanInvoice']}</span></h4>`;
                transaction['OnTime'] = `<h4><span class="badge badge-${transaction['OnTime'].toLowerCase() === 'hit' ? 'primary' : 'danger'}">
                                                        ${transaction['OnTime']}</span></h4>`;
                transaction['InFull'] = `<h4><span class="badge badge-${transaction['InFull'].toLowerCase() === 'hit' ? 'primary' : 'danger'}">
                                                        ${transaction['InFull']}</span></h4>`;
            });
            transactions.outbound.forEach((transaction) => {
                transaction['LoadingDwellTime'] = transaction['LoadingDwellTime'] ? moment.utc(moment.duration(parseFloat(transaction['LoadingDwellTime']), 'minutes').asMilliseconds()).format("HH:mm") : '00:00';
                transaction['DwellTime'] = transaction['DwellTime'] ? moment.utc(moment.duration(parseFloat(transaction['DwellTime']), 'minutes').asMilliseconds()).format("HH:mm") : '00:00';
                transaction['TargetDwellTime'] = transaction['TargetDwellTime'] ? moment.utc(moment.duration(parseFloat(transaction['TargetDwellTime']), 'minutes').asMilliseconds()).format("HH:mm") : '';
                transaction['Date'] = transaction['Date'] ? moment(Date.parse(transaction['Date'])).format('MMM D YYYY') : '';
                transaction['Arrival'] = transaction['Arrival'] ? moment(Date.parse(transaction['Arrival'])).format('MMM D YYYY, h:mm a') : '';
                transaction['Departure'] = transaction['Departure'] ? moment(Date.parse(transaction['Departure'])).format('MMM D YYYY, h:mm a') : '';
                transaction['StartLoading'] = transaction['StartLoading'] ? moment(Date.parse(transaction['StartLoading'])).format('MMM D YYYY, h:mm a') : '';
                transaction['CompleteLoading'] = transaction['CompleteLoading'] ? moment(Date.parse(transaction['CompleteLoading'])).format('MMM D YYYY, h:mm a') : '';
                transaction['PerfectShipment'] = `<h4><span class="badge badge-${transaction['PerfectShipment'].toLowerCase() === 'hit' ? 'primary' : 'danger'}">
                                                        ${transaction['PerfectShipment']}</span></h4>`;
                //transaction['CleanInvoice'] = `<h4><span class="badge badge-${transaction['CleanInvoice'].toLowerCase() === 'hit' ? 'primary' : 'danger'}">
                //                                        ${transaction['CleanInvoice']}</span></h4>`;
                transaction['OnTime'] = `<h4><span class="badge badge-${transaction['OnTime'].toLowerCase() === 'hit' ? 'primary' : 'danger'}">
                                                        ${transaction['OnTime']}</span></h4>`;
                transaction['InFull'] = `<h4><span class="badge badge-${transaction['InFull'].toLowerCase() === 'hit' ? 'primary' : 'danger'}">
                                                        ${transaction['InFull']}</span></h4>`;
            });
            onSuccess(transactions);
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function getPerfectShipmentScores(customerCode, warehouseCode, dateFrom, dateTo, onSuccess) {
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetPerfectShipmentScores",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            customerCode: customerCode,
            warehouseCode: warehouseCode,
            dateFrom: dateFrom,
            dateTo: dateTo,
        }),
        success: (responseData) => {
            //if (!shouldRerender(`perfectShipmentCharts`, responseData.d)) return;
            onSuccess(parseData(responseData.d));
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function renderPerfectShipmentCharts(data) {
    const totals = data.totals;
    const perParam = data.perParam;
    const inbound = totals[0];
    const outbound = totals[1];
    const inboundHit = inbound['Hit'] ? inbound['Hit'] : 0;
    const outboundHit = outbound['Hit'] ? outbound['Hit'] : 0;
    const inboundMiss = inbound['Miss'] ? inbound['Miss'] : 0;
    const outboundMiss = outbound['Miss'] ? outbound['Miss'] : 0;
    const totalHit = inboundHit + outboundHit;
    const totalMiss = inboundMiss + outboundMiss;
    const inboundParamScores = perParam[0];
    const outboundParamScores = perParam[1];

    shipmentTotalDonutChart = renderDonutChart(shipmentTotalDonutChart, [totalHit, totalMiss], ['Hit', 'Miss'],
        '#shipment-total-donut-chart', (event, chartContext, config) => { perfectShipmentChartOnClick(event, chartContext, config, 'shipmentTotalDonutChart') },
        ['#2c8ef8', '#fa5c7c']);
    shipmentInboundDonutChart = renderDonutChart(shipmentInboundDonutChart, [inboundHit, inboundMiss], ['Hit', 'Miss'],
        '#shipment-inbound-donut-chart', (event, chartContext, config) => { perfectShipmentChartOnClick(event, chartContext, config, 'shipmentInboundDonutChart') },
        ['#2c8ef8', '#fa5c7c']);
    shipmentOutboundDonutChart = renderDonutChart(shipmentOutboundDonutChart, [outboundHit, outboundMiss], ['Hit', 'Miss'],
        '#shipment-outbound-donut-chart', (event, chartContext, config) => { perfectShipmentChartOnClick(event, chartContext, config, 'shipmentOutboundDonutChart') },
        ['#2c8ef8', '#fa5c7c']);
    const inboundSeries = [
        {
            name: 'Hit', data: [inboundParamScores['CleanInvoiceHit'] ? inboundParamScores['CleanInvoiceHit'] : 0,
            inboundParamScores['InFullHit'] ? inboundParamScores['InFullHit'] : 0,
            inboundParamScores['OnTimeHit'] ? inboundParamScores['OnTimeHit'] : 0
            ]
        },
        {
            name: 'Miss', data: [inboundParamScores['CleanInvoiceMiss'],
            inboundParamScores['InFullMiss'] ? inboundParamScores['InFullMiss'] : 0,
            inboundParamScores['OnTimeMiss'] ? inboundParamScores['OnTimeMiss'] : 0
            ]
        },
    ];

    const outboundSeries = [
        {
            name: 'Hit', data: [
                outboundParamScores['InFullHit'] ? outboundParamScores['InFullHit'] : 0,
                outboundParamScores['OnTimeHit'] ? outboundParamScores['OnTimeHit'] : 0
            ]
        },
        {
            name: 'Miss', data: [
                outboundParamScores['InFullMiss'] ? outboundParamScores['InFullMiss'] : 0,
                outboundParamScores['OnTimeMiss'] ? outboundParamScores['OnTimeMiss'] : 0
            ]
        },
    ];

    const inboundCategories = ['Clean Invoice', 'In Full', 'On Time'];
    const outboundCategories = ['In Full', 'On Time'];

    shipmentInboundColumnChart = renderStackChart(shipmentInboundColumnChart, 'Inbound', inboundSeries, inboundCategories,
        '#shipment-inbound-column-chart',
        (event, chartContext, config) => { perfectShipmentChartOnClick(event, chartContext, config, 'shipmentInboundColumnChart') },
        true, ['#2c8ef8', '#fa5c7c']);
    shipmentOutboundColumnChart = renderStackChart(shipmentOutboundColumnChart, 'Outbound', outboundSeries, outboundCategories,
        '#shipment-outbound-column-chart',
        (event, chartContext, config) => { perfectShipmentChartOnClick(event, chartContext, config, 'shipmentOutboundColumnChart') },
        true, ['#2c8ef8', '#fa5c7c']);
}

function perfectShipmentChartOnClick(event, chartContext, config, chart) {
    let customerCode = getCustomerCode();
    let warehouseCode = getWarehouseCode();
    let category = '';
    let type = '';
    let modalLabel = '';
    let cleanInvoice = '';
    let onTime = '';
    let inFull = '';
    let perfectShipment = '';
    switch (chart) {
        case 'shipmentTotalDonutChart':
            category = config.dataPointIndex == 0 ? 'Hit' : 'Miss';
            type = 'All';
            modalLabel = 'All - ' + category;
            cleanInvoice = 'All';
            onTime = 'All';
            inFull = 'All';
            perfectShipment = category;
            break;
        case 'shipmentInboundDonutChart':
            category = config.dataPointIndex == 0 ? 'Hit' : 'Miss';
            type = 'Inbound';
            modalLabel = 'Inbound - ' + category;
            cleanInvoice = 'All';
            onTime = 'All';
            inFull = 'All';
            perfectShipment = category;
            break;
        case 'shipmentOutboundDonutChart':
            category = config.dataPointIndex == 0 ? 'Hit' : 'Miss';
            type = 'Outbound';
            modalLabel = 'Outbound - ' + category;
            cleanInvoice = 'All';
            onTime = 'All';
            inFull = 'All';
            perfectShipment = category;
            break;
        case 'shipmentInboundColumnChart': {
            category = config.seriesIndex == 0 ? 'Hit' : 'Miss';
            let param = '';
            if (config.dataPointIndex == 0) param = 'Clean Invoice';
            else if (config.dataPointIndex == 1) param = 'In Full';
            else param = 'On Time';
            type = 'Inbound';
            modalLabel = `Inbound-${param}-${category}`;
            cleanInvoice = config.dataPointIndex == 0 ? category : 'All';
            onTime = config.dataPointIndex == 2 ? category : 'All';
            inFull = config.dataPointIndex == 1 ? category : 'All';
            perfectShipment = 'All';
            break;
        }
        case 'shipmentOutboundColumnChart': {
            category = config.seriesIndex == 0 ? 'Hit' : 'Miss';
            let param = (config.dataPointIndex == 0) ? 'In Full' : 'On Time';
            type = 'Outbound';
            modalLabel = `Outbound-${param}-${category}`;
            onTime = config.dataPointIndex == 1 ? category : 'All';
            inFull = config.dataPointIndex == 0 ? category : 'All';
            perfectShipment = 'All';
            break;
        }
    }

    $('#datatable-modal-label').text(modalLabel);
    $('#datatable-modal').modal('show');

    getPerfectShipmentDataTable(customerCode, warehouseCode, DateStart, DateEnd, type, cleanInvoice, onTime, inFull, perfectShipment, (transactions) => {
        let outboundDatatable = transactions.outbound;
        let inboundDatatable = transactions.inbound;
        let dataTable = [];

        switch (type) {
            case 'All':
                inboundDatatable = inboundDatatable.map((row) => {
                    row['ICN/OCNQty'] = row['ICNQty'];
                    row['RR/WRQty'] = row['RRQty'];
                    row['StartLoading/Unloading'] = row['StartUnloading'];
                    row['CompleteLoading/Unloading'] = row['CompleteUnloading'];
                    row['Loading/UnloadingDwellTime'] = row['UnloadingDwellTime'];
                    delete row['ICNQty'];
                    delete row['RRQty'];
                    delete row['StartUnloading'];
                    delete row['CompleteUnloading'];
                    delete row['UnloadingDwellTime'];

                    return {
                        'Date': row['Date'], 'DocNumber': row['DocNumber'], 'WarehouseCode': row['WarehouseCode'],
                        'CustomerCode': row['CustomerCode'], 'TruckingCompany': row['TruckingCompany'],
                        'TruckType': row['TruckType'], 'Arrival': row['Arrival'], 'StartLoading/Unloading': row['StartLoading/Unloading'],
                        'CompleteLoading/Unloading': row['CompleteLoading/Unloading'], 'Departure': row['Departure'],
                        'Loading/UnloadingDwellTime': row['Loading/UnloadingDwellTime'], 'DwellTime': row['DwellTime'],
                        'TargetDwellTime': row['TargetDwellTime'], 'ICN/OCNQty': row['ICN/OCNQty'], 'RR/WRQty': row['RR/WRQty'],
                        'CleanInvoice': row['CleanInvoice'], 'OnTime': row['OnTime'], 'InFull': row['InFull'],
                        'PerfectShipment': row['PerfectShipment'],
                    };
                });

                outboundDatatable = outboundDatatable.map((row) => {
                    row['ICN/OCNQty'] = row['OCNQty'];
                    row['RR/WRQty'] = row['WRQty'];
                    row['StartLoading/Unloading'] = row['StartLoading'];
                    row['CompleteLoading/Unloading'] = row['CompleteLoading'];
                    row['Loading/UnloadingDwellTime'] = row['LoadingDwellTime'];
                    delete row['OCNQty'];
                    delete row['WRQty'];
                    delete row['StartLoading'];
                    delete row['CompleteLoading'];
                    delete row['LoadingDwellTime'];
                    return {
                        'Date': row['Date'], 'DocNumber': row['DocNumber'], 'WarehouseCode': row['WarehouseCode'],
                        'CustomerCode': row['CustomerCode'], 'TruckingCompany': row['TruckingCompany'],
                        'TruckType': row['TruckType'], 'Arrival': row['Arrival'], 'StartLoading/Unloading': row['StartLoading/Unloading'],
                        'CompleteLoading/Unloading': row['CompleteLoading/Unloading'], 'Departure': row['Departure'],
                        'Loading/UnloadingDwellTime': row['Loading/UnloadingDwellTime'], 'DwellTime': row['DwellTime'],
                        'TargetDwellTime': row['TargetDwellTime'], 'ICN/OCNQty': row['ICN/OCNQty'], 'RR/WRQty': row['RR/WRQty'],
                        'CleanInvoice': '', 'OnTime': row['OnTime'], 'InFull': row['InFull'],
                        'PerfectShipment': row['PerfectShipment'],
                    };
                });

                dataTable = inboundDatatable.concat(outboundDatatable);
                break;
            case 'Inbound':
                dataTable = inboundDatatable;
                break;
            case 'Outbound':
                dataTable = outboundDatatable;
                break;
        }
        displayModalDatatable(dataTable, 1);
    }, chart)
}

function getQueue(warehouseCode, onSuccess) {
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetQueue",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ warehouseCode: warehouseCode }),
        success: (responseData) => {
            if (!shouldRerender('getQueue', responseData.d)) return;
            onSuccess(parseData(responseData.d));
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function fillQueueTable(rows) {
    let tempQueue = [];
    inboundQueuingNumbers = [];
    outboundQueuingNumbers = [];

    rows.forEach((row) => {
        if (row['TransType'].toLowerCase() == 'inbound') {
            inboundQueuingNumbers.push(parseInt(row['QueuingNo']));
        }
        else {
            outboundQueuingNumbers.push(parseInt(row['QueuingNo']));
        }

        tempQueue.push(row['DocNumber']);

        if (queue.includes(row['DocNumber'])) {
            let change = 0;
            change += $(`[data-doc="${row['DocNumber']}"]>div:first-child`).text() == row['QueuingNo'] ? 0 : 1;
            change += $(`[data-doc="${row['DocNumber']}"]>div:nth-child(2)`).text() == row['Client'] ? 0 : 1;
            change += $(`[data-doc="${row['DocNumber']}"]>div:nth-child(3)`).text()
                == (row['Arrival'] ? moment(row['Arrival']).format('MMM D YYYY, h:mm a') : '') ? 0 : 1;
            change += $(`[data-doc="${row['DocNumber']}"]>div:nth-child(4)`).text() == (row['PlateNo'] ? row['PlateNo'] : '') ? 0 : 1;
            change += $(`[data-doc="${row['DocNumber']}"]>div:nth-child(5)`).text() == (row['ContainerNo'] ? row['ContainerNo'] : '') ? 0 : 1;
            change += $(`[data-doc="${row['DocNumber']}"]>div:nth-child(6)`).text() == (row['TruckType'] ? row['TruckType'] : '') ? 0 : 1;
            change += $(`[data-doc="${row['DocNumber']}"]>div:nth-child(7)`).text() == (row['Docking'] ? row['Docking'] : '') ? 0 : 1;
            change += $(`[data-doc="${row['DocNumber']}"]>div:nth-child(8)`).text() == (row['PluginNo'] ? row['PluginNo'] : '') ? 0 : 1;
            change += $(`[data-doc="${row['DocNumber']}"]>div:nth-child(9)`).text() == (row['Temperature'] ? row['Temperature'] : '') ? 0 : 1;
            change += $(`[data-doc="${row['DocNumber']}"]>div:nth-child(10)`).text()
                == (row['Departure'] ? moment(row['Departure']).format('MMM D YYYY, h:mm a') : '') ? 0 : 1;
            change += $(`[data-doc="${row['DocNumber']}"]>div:last-child`).text() == (row['Status'] ? row['Status'] : '') ? 0 : 1;

            if (change > 0) {
                $(`[data-doc="${row['DocNumber']}"]`).css('background-color', 'var(--info)');

                $(`[data-doc="${row['DocNumber']}"]>div:first-child`).text(row['QueuingNo']);
                $(`[data-doc="${row['DocNumber']}"]>div:nth-child(2)`).text(row['Client']);
                $(`[data-doc="${row['DocNumber']}"]>div:nth-child(3)`).text(row['Arrival'] ? moment(row['Arrival']).format('MMM D YYYY, h:mm a') : '');
                $(`[data-doc="${row['DocNumber']}"]>div:nth-child(4)`).text(row['PlateNo']);
                $(`[data-doc="${row['DocNumber']}"]>div:nth-child(5)`).text(row['ContainerNo']);
                $(`[data-doc="${row['DocNumber']}"]>div:nth-child(6)`).text(row['TruckType']);
                $(`[data-doc="${row['DocNumber']}"]>div:nth-child(7)`).text(row['Docking']);
                $(`[data-doc="${row['DocNumber']}"]>div:nth-child(8)`).text(row['PluginNo']);
                $(`[data-doc="${row['DocNumber']}"]>div:nth-child(9)`).text(row['Temperature']);
                $(`[data-doc="${row['DocNumber']}"]>div:nth-child(10)`).text(row['Departure'] ? moment(row['Departure']).format('MMM D YYYY, h:mm a') : '')
                $(`[data-doc="${row['DocNumber']}"]>div:last-child`).text(row['Status']);

                setTimeout(() => { $(`[data-doc="${row['DocNumber']}"]`).css('background-color', 'var(--light)') }, 1000)
            }
        }
        else {
            const tableRow = $(
                `<div class="queue-body-row slide-in draggable transition" draggable="true" 
                  data-doc="${row['DocNumber']}" data-trans="${row['TransType']}" data-queue="${row['QueuingNo']}">
                     <div class="px-2 d-flex align-items-center">${row['QueuingNo'] ? row['QueuingNo'] : ''}</div>
                     <div class="px-2 align-middle text-truncate" data-toggle="tooltip" title="${row['Client']}">${row['Client']}</div>
                     <div class="px-2 align-middle">${row['Arrival'] ? moment(row['Arrival']).format('MMM D YYYY, h:mm a') : ''}</div>
                     <div class="px-2 align-middle">${row['PlateNo'] ? row['PlateNo'] : ''}</div>
                     <div class="px-2 align-middle">${row['ContainerNo'] ? row['ContainerNo'] : ''}</div>
                     <div class="px-2 align-middle">${row['TruckType'] ? row['TruckType'] : ''}</div>
                     <div class="px-2 align-middle">${row['Docking'] ? row['Docking'] : ''}</div>
                     <div class="px-2 align-middle">${row['PluginNo'] ? row['PluginNo'] : ''}</div>
                     <div class="px-2 align-middle">${row['Temperature'] ? row['Temperature'] : ''}</div>
                     <div class="px-2 align-middle">${row['Departure'] ? moment(row['Departure']).format('MMM D YYYY, h:mm a') : ''}</div>
                     <div class="px-2 align-middle" data-toggle="tooltip" title="${row['Status']}">${row['Status'] ? row['Status'] : ''}</div>
                </div>`);
            $(`#queue-${row['TransType'].toLowerCase()}`).append(tableRow);
            setTimeout(() => {
                $(`[data-doc="${row['DocNumber']}"]`).removeClass('slide-in');
                $(`[data-doc="${row['DocNumber']}"]`).css('background-color', 'var(--info)');
                setTimeout(() => { $(`[data-doc="${row['DocNumber']}"]`).css('background-color', 'var(--light)') }, 1000);
            }, 1000)
        }

        // remove items in queue so that only inexisting items in new queue will remain
        var index = queue.indexOf(row['DocNumber']);
        if (index !== -1) {
            queue.splice(index, 1);
        }
    });

    // remove remaining items from old queue in table
    queue.forEach((docNumber) => {
        $(`[data-doc="${docNumber}"]`).addClass('slide-out');
        setTimeout(() => { $(`[data-doc="${docNumber}"]`).remove() }, 1000)
    });

    queue = tempQueue;

    const inboundSortableList = document.querySelector("#queue-inbound");
    const outboundSortableList = document.querySelector("#queue-outbound");
    const inboundItems = inboundSortableList.querySelectorAll(".queue-body-row");
    const outboundItems = outboundSortableList.querySelectorAll(".queue-body-row");

    addDragEvents(inboundItems, inboundSortableList);
    addDragEvents(outboundItems, outboundSortableList);
}

function addDragEvents(items, sortableList) {
    items.forEach(item => {
        item.addEventListener("dragstart", () => {
            dragging = $(item);
            setTimeout(() => {
                $(item).addClass('dragging')
                $(item).css('color', 'black')
            }, 0);
        });

        item.addEventListener("dragend", () => {
            $(item).removeClass('dragging');
            $(item).css('color', 'var(--secondary)');
        });


    });

    sortableList.addEventListener("dragover", (e) => {
        e.preventDefault();
        const transType = $(dragging).data("trans").toLowerCase();
        const dropZoneTransType = $(sortableList).attr('id') == 'queue-inbound' ? 'inbound' : 'outbound';
        if (dropZoneTransType !== transType) {
            e.dataTransfer.dropEffect = 'none';
            return;
        }
        const draggingItem = document.querySelector(".dragging");
        let siblings = [...sortableList.querySelectorAll(".queue-body-row:not(.dragging)")];

        let nextSibling = siblings.find(sibling => {
            const rect = sibling.getBoundingClientRect();
            return e.clientY <= rect.top;
        });

        sortableList.insertBefore(draggingItem, nextSibling);
    });

    sortableList.addEventListener("dragenter", e => {
        e.preventDefault()
    });

    sortableList.addEventListener('drop', (e) => {
        e.stopImmediatePropagation();
        const transType = $(dragging).data("trans").toLowerCase();
        const dropZoneTransType = $(sortableList).attr('id') == 'queue-inbound' ? 'inbound' : 'outbound';
        if (dropZoneTransType !== transType) return;

        let toUpdateDocNumbers = [];
        const queuingNumbers = dropZoneTransType == 'inbound' ? inboundQueuingNumbers : outboundQueuingNumbers;
        queuingNumbers.sort((a, b) => a - b);
        $(sortableList).children('.queue-body-row').each(function (index) {
            const queuingNumChanged = $(this).children(":first").text() != queuingNumbers[index];
            $(this).children(":first").text(queuingNumbers[index]);

            if (queuingNumChanged) {
                const docNumber = $(this).data("doc");
                toUpdateDocNumbers.push({ docNumber: docNumber, queuingNo: queuingNumbers[index].toString() });
            }
        });

        if (toUpdateDocNumbers.length == 0) return;
        const warehouseCode = getWarehouseCode();
        $.ajax({
            type: "POST",
            url: "frmDashboardBasic2.aspx/UpdateQueuingNo",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({ warehouseCode: warehouseCode, queueItems: toUpdateDocNumbers }),
            error: (error) => {
                //Swal.fire("", error.responseJSON.Message, "error");
                alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
            }
        });
    })
}

function formatNumberWithCommas(number) {
    return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function getMonitoringTruckStatus(customerCode, dateFrom, dateTo, onSuccess) {
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetMonitoringTruckStatus",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ customerCode: customerCode, dateFrom: dateFrom, dateTo: dateTo }),
        success: (responseData) => {
            onSuccess(parseData(responseData.d));
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function setMonitoringTransactionsPieChart(customerCode, dateFrom, dateTo) {
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetMonitoringTransactions",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ customerCode: customerCode, dateFrom: dateFrom, dateTo: dateTo }),
        success: (responseData) => {
            const data = parseData(responseData.d);
            let transactions = {};

            data.forEach((transaction) => {
                transactions[transaction['Type']] = transaction['Count'];
            });

            monitoringTransactionsPieChart = renderPieChart(monitoringTransactionsPieChart,
                Object.values(transactions),
                Object.keys(transactions),
                '#monitoring-transactions-pie-chart',
                transactionStatusChartOnClick,
                { colors: ['rgb(0, 51, 102)', 'rgb(102, 179, 255)', 'rgb(255, 102, 0)', 'rgb(60, 179, 113)', 'rgb(210, 180, 140)'] }
            );

        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function setMonitoringTransactionsTreeChart(customerCode, dateFrom, dateTo) {
    if (monitoringTransactionsTreeMapChart) return;
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetMonitoringTransactionsPerClient",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ customerCode: customerCode, dateFrom: dateFrom, dateTo: dateTo }),
        success: (responseData) => {
            const series = parseData(responseData.d);
            monitoringTransactionsTreeMapChart = renderTreeMapChart(monitoringTransactionsTreeMapChart, series,
                '#monitoring-transactions-treemap-chart', transactionTreeMapOnClick);

        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function setMonitoringInventoryTreeChart(customerCode, dateFrom, dateTo) {
    if (monitoringInventoryTreeMapChart) return;

    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetMonitoringInventoryVolume",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ customerCode: customerCode, dateFrom: dateFrom, dateTo: dateTo }),
        success: (responseData) => {
            const series = parseData(responseData.d);
            monitoringInventoryTreeMapChart = renderTreeMapChart(monitoringInventoryTreeMapChart, series,
                '#monitoring-inventory-treemap-chart', inventoryTreeMapOnClick)
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function setMonitoringCounts(customerCode, dateFrom, dateTo) {
    if (monitoringCounts) return;
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetMonitoringCounts",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ customerCode: customerCode, dateFrom: dateFrom, dateTo: dateTo }),
        success: (responseData) => {
            const list = parseData(responseData.d);
            let counts = {};
            monitoringCounts = true;
            list.forEach((item) => {
                counts[item['Key']] = item['Value'];
            });

            const warehouseFilledVolume = 100 - ((counts['Pallet'] / counts['Warehouse Capacity']) * 100);

            $('#monitoring-clients').text(formatNumberWithCommas(counts['ActiveCustomers']));
            $('#monitoring-skus').text(formatNumberWithCommas(counts['ActiveSKUs']));
            $('#monitoring-wms-users').text(formatNumberWithCommas(counts['ActiveUsers']));
            $('#monitoring-rf-users').text(formatNumberWithCommas(counts['ActiveRFUsers']));

            $('#monitoring-warehouse-capacity').text(formatNumberWithCommas(counts['Warehouse Capacity']));
            $('#monitoring-pallet').text(formatNumberWithCommas(counts['Pallet']));
            $('#monitoring-unit').text(formatNumberWithCommas(counts['Unit']));
            $('#monitoring-weight').text(formatNumberWithCommas(counts['Weight']));

            $('#monitoring-processed-requests').text(formatNumberWithCommas(counts['ProcessedRequests']));
            $('#monitoring-pending-requests').text(formatNumberWithCommas(counts['PendingRequests']));
            $('#monitoring-cancelled-requests').text(formatNumberWithCommas(counts['CancelledRequests']));
            $('#monitoring-internal-transactions').text(formatNumberWithCommas(counts['InternalTransactions']));

            $('.warehouse-bg').css('width', `${warehouseFilledVolume}%`);
            //$('.left').css('clip-path', `polygon(0% 0%, ${leftPercentage}% 0%, ${leftPercentage}% 100%, 0% 100%)`);
            //$('.right').css('clip-path', `polygon(${leftPercentage}% 0%, 100% 0%, 100% 100%, ${leftPercentage}% 100%)`);
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function setMonitoringLineChart(customerCode, dateFrom, dateTo) {
    if (monitoringLineChart) return;
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetTransactionCountPerDay",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ customerCode: customerCode, dateFrom: dateFrom, dateTo: dateTo }),
        success: (responseData) => {
            const data = parseData(responseData.d);
            //const series = data.map(obj => [new Date(obj['DocDate']).getTime(), obj['Transactions']]);
            const series = data;
            const minDate = new Date(data[data.length - 1]['DocDate']);
            monitoringLineChart = renderLineChart(monitoringLineChart,
                [{ data: series, name: 'Inbound and Outbound Transactions' }],
                '#monitoring-line-chart', transactionsLineChartOnClick
            );

        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function setMonitoringRadialCharts(customerCode, dateFrom, dateTo) {
    if (monitoringOrderFulfillmentChart) return;
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetMonitoringPercentages",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ customerCode: customerCode, dateFrom: dateFrom, dateTo: dateTo }),
        success: (responseData) => {
            const list = parseData(responseData.d);
            let percentages = {};
            list.forEach((item) => {
                percentages[item['Key']] = item['Value'];
            });

            monitoringOnTimeSubmissionChart = renderRadialBarChart(monitoringOnTimeSubmissionChart, [percentages['OnTimeSubmission']], [''], '#monitoring-ontime-submission',
                (_event, _chartContext, _config) => { kpiRedialBarsOnClick('On-time Submission', 'OnTimeSubmission') });
            monitoringOrderFulfillmentChart = renderRadialBarChart(monitoringOrderFulfillmentChart, [percentages['OrderFulfillment']], [''], '#monitoring-order-fulfillment',
                (_event, _chartContext, _config) => { kpiRedialBarsOnClick('Order Fulfillment', 'OrderFulfillment') });
            monitoringDwellTimeChart = renderRadialBarChart(monitoringDwellTimeChart, [percentages['DwellTime']], [''], '#monitoring-dwell-time',
                (_event, _chartContext, _config) => { kpiRedialBarsOnClick('Dwell Time', 'DwellTime') });
            monitoringAttachmentChart = renderRadialBarChart(monitoringAttachmentChart, [percentages['Attachment']], [''], '#monitoring-attachment',
                (_event, _chartContext, _config) => { kpiRedialBarsOnClick('Attachment', 'Attachment') });
            monitoringIRAChart = renderRadialBarChart(monitoringIRAChart, [percentages['IRA']], [''], '#monitoring-ira',
                (_event, _chartContext, _config) => { kpiRedialBarsOnClick('Inventory Replenishment Accuracy(IRA)', 'IRA') });
            monitoringLRAChart = renderRadialBarChart(monitoringLRAChart, [percentages['LRA']], [''], '#monitoring-lra',
                (_event, _chartContext, _config) => { kpiRedialBarsOnClick('Location Replenishment Accuracy(LRA)', 'LRA') });
            monitoringBillingSubmissionChart = renderRadialBarChart(monitoringBillingSubmissionChart, [percentages['BillingSubmission']], [''], '#monitoring-billing-submission',
                (_event, _chartContext, _config) => { kpiRedialBarsOnClick('Billing Submission', 'BillingSubmission') });
            monitoringBillingInvoiceChart = renderRadialBarChart(monitoringBillingInvoiceChart, [percentages['BillingInvoice']], [''], '#monitoring-billing-invoice',
                (_event, _chartContext, _config) => { kpiRedialBarsOnClick('Billing Invoice', 'BillingInvoice') });
        },
        error: (error) => {
            //Swal.fire("", error.responseJSON.Message, "error");
            alert(`Error: ${error.responseJSON ? error.responseJSON.Message : error.statusText}`);
        }
    });
}

function fillMonitoringCounts(rows) {
    let total = rows.length;
    let arrived = 0;
    let docked = 0;
    let loading = 0;
    let docs = 0;
    let departed = 0;
    let newTransaction = 0;
    rows.forEach((row) => {
        let progress = parseInt(row['Arrived']) + parseInt(row['Docked']) + parseInt(row['Loading']) + parseInt(row['Docs']) + parseInt(row['Departed']);
        switch (progress) {
            case 1:
                arrived++;
                break;
            case 2:
                docked++;
                break;
            case 3:
                loading++;
                break;
            case 4:
                docs++;
                break;
            case 5:
                departed++;
                break;
            default:
                newTransaction++;
                break;
        }
    });
    total -= newTransaction;
    elementTextChanged($('.count-card #total-monitoring-count'), total, ($element) => {
        flipParent($element, 'div', total);
    });
    elementTextChanged($('.count-card #departed-count'), departed, ($element) => {
        flipParent($element, 'div', departed);
    });
    elementTextChanged($('.count-card #docs-count'), docs, ($element) => {
        flipParent($element, 'div', docs);
    });
    elementTextChanged($('.count-card #loading-count'), loading, ($element) => {
        flipParent($element, 'div', loading);
    });
    elementTextChanged($('.count-card #docked-count'), docked, ($element) => {
        flipParent($element, 'div', docked);
    });
    elementTextChanged($('.count-card #arrived-count'), arrived, ($element) => {
        flipParent($element, 'div', arrived);
    });

    monitoringTruckStatusChart = renderPieChart(monitoringTruckStatusChart,
        [newTransaction, arrived, docked, loading, docs, departed],
        ['New', 'Arrived', 'Docked', 'Loading', 'Docs', 'Departed'],
        '#monitoring-truck-status-chart',
        null,
        {
            colors: ['rgb(144, 238, 144)', 'rgb(173, 216, 230)', 'rgb(100, 149, 237)', 'rgb(255, 102, 0)', 'rgb(255, 165, 0)', 'rgb(255, 69, 0)'],
            chart: {
                type: 'donut',
                width: '90%',
                events: { dataPointSelection: truckStatusChartOnClick },
            },
        }
    );
}

$('#monitoring-list-container>div').on('scroll', function () {
    const currentScrollTop = Math.ceil((this).scrollTop); // Current vertical scroll position
    const lastScrollTop = $(this).data('last-scroll-top') || 0;
    const scrollHeight = this.scrollHeight;
    const clientHeight = this.clientHeight;
    let scrollPoint = 0;
    if (currentScrollTop === lastScrollTop) return;

    $(this).data('last-scroll-top', currentScrollTop);
    if (currentScrollTop === 0 && startIndex !== 0) {
        startIndex -= scrollItemIncrement;
        lastIndex -= scrollItemIncrement;
        monitoringTransactions = [];
        $('#monitoring-list').empty();
        scrollPoint = (scrollHeight - clientHeight) * (1 / 4);
        fillMonitoringList(monitoringRows, scrollPoint);
    }
    else if (currentScrollTop + clientHeight >= scrollHeight && lastIndex !== monitoringRows.length) {
        startIndex += scrollItemIncrement;
        lastIndex += scrollItemIncrement;
        monitoringTransactions = [];
        $('#monitoring-list').empty();
        scrollPoint = (scrollHeight - clientHeight) * (3 / 4);
        fillMonitoringList(monitoringRows, scrollPoint);
    }
});

async function fillMonitoringList(rows, scroll = null) {
    let docNumbers = [];
    const rowHeight = 34; // on pixels
    lastIndex = rows.length > lastIndex ? lastIndex : rows.length;
    if ((lastIndex <= 0 || lastIndex < listItemShownCount)) lastIndex = rows.length >= listItemShownCount ? listItemShownCount : rows.length;
    startIndex = startIndex > lastIndex - listItemShownCount ? lastIndex - listItemShownCount : startIndex;
    startIndex = startIndex < 0 ? 0 : startIndex;

    for (let index = startIndex; index < lastIndex; index++) {
        let row = rows[index];
        let docNumber = row['DocNumber'];
        let progress = parseInt(row['Arrived']) + parseInt(row['Docked']) + parseInt(row['Loading']) + parseInt(row['Docs']) + parseInt(row['Departed']);
        docNumbers.push(docNumber);

        if (monitoringTransactions.includes(docNumber)) {
            const $listItem = $(`#monitoring-list li[data-uid='${docNumber}']`);
            const prevIndex = parseInt($listItem.data('position'));
            const prevProgress = parseInt($listItem.data('progress'));
            const $arrived = $(`#monitoring-list li[data-uid='${docNumber}'] div.container-row div.container-col:nth-child(2)`);
            const $docked = $(`#monitoring-list li[data-uid='${docNumber}'] div.container-row div.container-col:nth-child(3)`);
            const $loading = $(`#monitoring-list li[data-uid='${docNumber}'] div.container-row div.container-col:nth-child(4)`);
            const $docs = $(`#monitoring-list li[data-uid='${docNumber}'] div.container-row div.container-col:nth-child(5)`)
            const $departed = $(`#monitoring-list li[data-uid='${docNumber}'] div.container-row div.container-col:nth-child(6)`);
            const $dwellTime = $(`#monitoring-list li[data-uid='${docNumber}'] div.container-row div.container-col:nth-child(7)`);

           $listItem.data('progress', progress);
            $(`#monitoring-list li[data-uid='${docNumber}'] div.filled.end`).removeClass('end');

            //Do progress fill animation
            (() => {
                const fillAnimationTiming = 250;
                const delayVar = Math.abs(progress - prevProgress);
                if (prevProgress < progress) {
                    for (let index = prevProgress; index < progress; index++) {
                        if (index + 1 == progress) {
                            $(`#monitoring-list li[data-uid='${docNumber}'] div.container-row div.container-col:nth-child(${index + 2}) div.bar-filler`).addClass('end');
                        }
                        setTimeout(() => {
                            $(`#monitoring-list li[data-uid='${docNumber}'] div.container-row div.container-col:nth-child(${index + 2}) div.bar-filler`).addClass('filled');
                        }, (index - prevProgress) * fillAnimationTiming);
                    }
                }
                else if (prevProgress > progress) {
                    for (let index = prevProgress; index >= progress; index--) {
                        setTimeout(() => {
                            if (index == progress) {
                                $(`#monitoring-list li[data-uid='${docNumber}'] div.container-row div.container-col:nth-child(${index + 1}) div.bar-filler`).addClass('end');
                                return;
                            }
                            $(`#monitoring-list li[data-uid='${docNumber}'] div.container-row div.container-col:nth-child(${index + 1}) div.bar-filler`).removeClass('filled');
                        }, (prevProgress - index) * fillAnimationTiming);
                    }
                }
                else {
                    switch (progress) {
                        case 1:
                            $arrived.find('div.bar-filler').addClass('end');
                            break;
                        case 2:
                            $docked.find('div.bar-filler').addClass('end');
                            break;
                        case 3:
                            $loading.find('div.bar-filler').addClass('end');
                            break;
                        case 4:
                            $docs.find('div.bar-filler').addClass('end');
                            break;
                        case 5:
                            $departed.find('div.bar-filler').addClass('end');
                            break;
                        default:
                            break;
                    }
                }
            })();

            //Reorder the list
            if (prevIndex > index) {
                $listItem.css('top', ((index - startIndex) * rowHeight).toString() + 'px');
                $listItem.data('position', index);
                $listItem.addClass('go-down');
                setTimeout(() => { $listItem.removeClass('go-down') }, 500);
            }
            else if (prevIndex < index) {
                $listItem.css('top', ((index - startIndex) * rowHeight).toString() + 'px');
                $listItem.data('position', index);
                $listItem.addClass('go-up');
                setTimeout(() => { $listItem.removeClass('go-up') }, 500);
            }
            
            //Set dwellTime
            if (row['DockingTime'] != null && row['LatestProgressTime'] != null) {
                const timeDiff = getDateTimeDifference(new Date(row['LatestProgressTime']), new Date(row['DockingTime']));
                const duration = timeDiff <= 0 ? '' : formatDuration(timeDiff);
                elementTextChanged($dwellTime, duration);
            }
            
            //Set dwellTime and timers
            //if (row['Docked'] == 1 && row['Departed'] !== 1 && row['DockingTime'] != $dwellTime.data('docking')) {
            //    const timeDiff = getDateTimeDifference(Date.now(), new Date(row['DockingTime']));
            //    const duration = formatDuration(timeDiff);
            //    //$duration.addClass('progress-ongoing');
            //    $dwellTime.text(duration);

            //    let time = new Date(), secondsRemaining = (60 - time.getSeconds()) * 1000;
            //    setTimeout(() => {
            //        const interval = setInterval(() => { flipDuration($dwellTime, row['DockingTime']) }, 60000);
            //        durationTimers[docNumber] = interval;
            //    }, secondsRemaining);
            //}
            //else if (row['Docked'] == 1 && row['Departed'] == 1) {
            //    const timeDiff = getDateTimeDifference(new Date(row['DockingTime']), new Date(row['Departure']));
            //    const duration = formatDuration(timeDiff);
            //    elementTextChanged($dwellTime, duration);
            //    if (durationTimers[docNumber] !== null && durationTimers[docNumber] !== undefined) clearInterval(durationTimers[docNumber]);
            //    delete durationTimers[docNumber];
            //}
        }
        else {
            let progress = parseInt(row['Arrived']) + parseInt(row['Docked']) + parseInt(row['Loading']) + parseInt(row['Docs']) + parseInt(row['Departed']);
            let $listItem = $(`<li data-uid="${docNumber}" data-position="${index}" data-progress="${progress}">
                    <div class="container-row">
                        <div class="container-col">${docNumber}</div>
                        <div class="container-col"><div class="bar"><div class="bar-filler${row['Arrived'] == 1 ? ' filled' : ''}${progress == 1 ? ' end' : ''}"></div></div></div>
                        <div class="container-col"><div class="bar"><div class="bar-filler${row['Docked'] == 1 ? ' filled' : ''}${progress == 2 ? ' end' : ''}"></div></div></div>
                        <div class="container-col"><div class="bar"><div class="bar-filler${row['Loading'] == 1 ? ' filled' : ''}${progress == 3 ? ' end' : ''}"></div></div></div>
                        <div class="container-col"><div class="bar"><div class="bar-filler${row['Docs'] == 1 ? ' filled' : ''}${progress == 4 ? ' end' : ''}"></div></div></div>
                        <div class="container-col"><div class="bar"><div class="bar-filler${row['Departed'] == 1 ? ' filled' : ''}${progress == 5 ? ' end' : ''}"></div></div></div>
                        <div class="container-col" data-docking="${row['DockingTime']}"></div>
                    </div>
                </li>`);
            $listItem.css('top', ((index - startIndex) * rowHeight).toString() + 'px');

            $('ul#monitoring-list').append($listItem);
            setTimeout(() => { $(`ul#monitoring-list li[data-uid="${docNumber}"]`).addClass('show'); }, 100);

            //Set dwellTime
            if (row['DockingTime'] != null && row['LatestProgressTime'] != null) {
                const $dwellTime = $(`#monitoring-list li[data-uid='${docNumber}'] div.container-row div.container-col:nth-child(7)`);
                const timeDiff = getDateTimeDifference(new Date(row['LatestProgressTime']), new Date(row['DockingTime']));
                const duration = timeDiff <= 0 ? '' : formatDuration(timeDiff);
                $dwellTime.text(duration);
            }

            //Set dwellTime and timers
            //const $dwellTime = $(`#monitoring-list li[data-uid='${docNumber}'] div.container-row div.container-col:nth-child(7)`);
            //if (row['Docked'] == 1 && row['Departed'] !== 1) {
            //    const timeDiff = getDateTimeDifference(Date.now(), new Date(row['DockingTime']));
            //    const duration = formatDuration(timeDiff);
            //    //$duration.addClass('progress-ongoing');
            //    $dwellTime.text(duration);

            //    let time = new Date(), secondsRemaining = (60 - time.getSeconds()) * 1000;
            //    setTimeout(() => {
            //        const interval = setInterval(() => { flipDuration($dwellTime, row['DockingTime']) }, 60000);
            //        durationTimers[docNumber] = interval;
            //    }, secondsRemaining);
            //}
            //else if (row['Docked'] == 1 && row['Departed'] == 1) {
            //    const timeDiff = getDateTimeDifference(new Date(row['DockingTime']), new Date(row['Departure']));
            //    const duration = formatDuration(timeDiff);
            //    $dwellTime.text(duration);
            //}
        }
    };

    // Remove items not existing in the updated list
    const toRemove = monitoringTransactions.filter((docNumber) => { return !docNumbers.includes(docNumber); });
    toRemove.forEach(async (docNumber) => {
        $(`#monitoring-list li[data-uid='${docNumber}']`).removeClass('show');
        setTimeout(() => { $(`#monitoring-list li[data-uid='${docNumber}']`).animate({ height: "0" }, { speed: 500 }) }, 300);
        setTimeout(() => { $(`#monitoring-list li[data-uid='${docNumber}']`).remove() }, 700);
        //if (durationTimers[docNumber] !== null && durationTimers[docNumber] !== undefined) clearInterval(durationTimers[docNumber]);
        //delete durationTimers[docNumber];
    });

    monitoringTransactions = [...docNumbers];

    //function flipDuration($element, startTimeStr) {
    //    const duration = moment.duration(getDateTimeDifference(Date.now(), new Date(startTimeStr)));
    //    const formattedDuration = Math.floor(duration.asHours()).toString().padStart(2, "0") + moment.utc(duration.asMilliseconds()).format(":mm")
    //    flip($element, formattedDuration);
    //}

    if (startIndex !== 0 && lastIndex !== rows.length) {
        $('#monitoring-list-container>div.overflow-auto').data('last-scroll-top', scroll);
        $('#monitoring-list-container>div.overflow-auto').scrollTop(scroll);
    }
}

function elementTextChanged($element, newText, callback) {
    if (callback === undefined || callback === null) {
        callback = ($element) => {
            flip($element, newText);
        }
    }
    if ($element.text().trim() != newText) {
        callback($element);
    }
}

function flip($element, newHTML) {
    $element.css('animation-name', 'flip');
    $element.css('animation-duration', '1s');
    setTimeout(() => { $element.html(newHTML); }, 500);
    setTimeout(() => {
        $element.css('animation-name', 'none');
        $element.css('animation-duration', '0');
    }, 1000);
}

function flipParent($element, parentSelector, newHTML) {
    $element.parent(parentSelector).css('animation-name', 'flip');
    $element.parent(parentSelector).css('animation-duration', '1s');
    setTimeout(() => { $element.html(newHTML); }, 500);
    setTimeout(() => {
        $element.parent(parentSelector).css('animation-name', 'none');
        $element.parent(parentSelector).css('animation-duration', '0');
    }, 1000);
}

function getDateTimeDifference(date1, date2) {
    return Math.abs(date1 - date2);
}

function formatDuration(durationMs) {
    const duration = moment.duration(durationMs);
    return Math.floor(duration.asHours()).toString().padStart(2, "0") + moment.utc(duration.asMilliseconds()).format(":mm");
}

function clearMonitoringCharts(tab = 'tab-monitoring') {
    if (monitoringTruckStatusChart) monitoringTruckStatusChart.destroy();
    if (monitoringLineChart) monitoringLineChart.destroy();
    if (monitoringTransactionsPieChart) monitoringTransactionsPieChart.destroy();
    if (monitoringTransactionsTreeMapChart) monitoringTransactionsTreeMapChart.destroy();
    if (monitoringInventoryTreeMapChart) monitoringInventoryTreeMapChart.destroy();
    if (monitoringOnTimeSubmissionChart) monitoringOnTimeSubmissionChart.destroy();
    if (monitoringOrderFulfillmentChart) monitoringOrderFulfillmentChart.destroy();
    if (monitoringDwellTimeChart) monitoringDwellTimeChart.destroy();
    if (monitoringAttachmentChart) monitoringAttachmentChart.destroy();
    if (monitoringIRAChart) monitoringIRAChart.destroy();
    if (monitoringLRAChart) monitoringLRAChart.destroy();
    if (monitoringBillingSubmissionChart) monitoringBillingSubmissionChart.destroy();
    if (monitoringBillingInvoiceChart) monitoringBillingInvoiceChart.destroy();
    monitoringTruckStatusChart = null;
    monitoringLineChart = null;
    monitoringTransactionsPieChart = null;
    monitoringTransactionsTreeMapChart = null;
    monitoringInventoryTreeMapChart = null;
    monitoringCounts = null;
    monitoringOnTimeSubmissionChart = null;
    monitoringOrderFulfillmentChart = null;
    monitoringDwellTimeChart = null;
    monitoringAttachmentChart = null;
    monitoringIRAChart = null;
    monitoringLRAChart = null;
    monitoringBillingSubmissionChart = null;
    monitoringBillingInvoiceChart = null;
}

function transactionStatusChartOnClick(_event, _chartContext, config) {
    const customerCode = getCustomerCode();
    const filterValue = config.w.config.labels[config.dataPointIndex];
    showMonitoringDatatable('Transactions Status', customerCode, DateStart, DateEnd, 'TransactionStatus', filterValue);
}
function truckStatusChartOnClick(_event, _chartContext, config) {
    const customerCode = getCustomerCode();
    const filterValue = config.w.config.labels[config.dataPointIndex];
    showMonitoringDatatable('Truck Status', customerCode, DateStart, DateEnd, 'TruckStatus', filterValue);
}

function transactionTreeMapOnClick(_event, _chartContext, config) {
    const customerCode = getCustomerCode();
    const filterValue = config.w.config.series[0].data[config.dataPointIndex]['x'];
    showMonitoringDatatable('Transactions', customerCode, DateStart, DateEnd, 'Transactions per Client', filterValue);
}

function inventoryTreeMapOnClick(_event, _chartContext, config) {
    const customerCode = getCustomerCode();
    const filterValue = config.w.config.series[0].data[config.dataPointIndex]['x'];
    showMonitoringDatatable('Inventory Volume', customerCode, DateStart, DateEnd, 'Inventory Volume', filterValue);
}

function kpiRedialBarsOnClick(title, filter) {
    const customerCode = getCustomerCode();
    showMonitoringDatatable(title, customerCode, DateStart, DateEnd, filter, '');
}

function transactionsLineChartOnClick(_event, _chartContext, config) {
    const customerCode = getCustomerCode();
    const filterValue = config.w.config.series[0].data[config.dataPointIndex]['x'];
    showMonitoringDatatable(`${filterValue} Transactions`, customerCode, DateStart, DateEnd, 'Transactions per Day', filterValue);
}

$('#total-monitoring-count').parent('div.count-card').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Truck Status', customerCode, DateStart, DateEnd, 'TruckStatus', 'All');
});

$('#arrived-count').parent('div.count-card').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Truck Status', customerCode, DateStart, DateEnd, 'TruckStatus', 'Arrived');
});

$('#docked-count').parent('div.count-card').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Truck Status', customerCode, DateStart, DateEnd, 'TruckStatus', 'Docked');
});

$('#loading-count').parent('div.count-card').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Truck Status', customerCode, DateStart, DateEnd, 'TruckStatus', 'Loading');
});

$('#docs-count').parent('div.count-card').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Truck Status', customerCode, DateStart, DateEnd, 'TruckStatus', 'Docs');
});

$('#departed-count').parent('div.count-card').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Truck Status', customerCode, DateStart, DateEnd, 'TruckStatus', 'Departed');
});

$('#monitoring-clients').parent('div').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Active Clients', customerCode, DateStart, DateEnd, 'Clients', null);
});

$('#monitoring-skus').parent('div').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Active SKUs', customerCode, DateStart, DateEnd, 'SKUs', null);
});

$('#monitoring-wms-users').parent('div').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Active WMS Users', customerCode, DateStart, DateEnd, 'WMS Users', null);
});

$('#monitoring-rf-users').parent('div').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Active RF Users', customerCode, DateStart, DateEnd, 'RF Users', null);
});

$('#monitoring-warehouse-capacity').parent('div').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Warehouse Capacity', customerCode, DateStart, DateEnd, 'Warehouse Capacity', null);
});

$('#monitoring-pallet, #monitoring-unit, #monitoring-weight').parent('div').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Pallet Details', customerCode, DateStart, DateEnd, 'Pallet', null);
});

$('#monitoring-processed-requests').parent('h3').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Processed Requests', customerCode, DateStart, DateEnd, 'Processed Requests', null);
});

$('#monitoring-pending-requests').parent('h3').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Pending Requests', customerCode, DateStart, DateEnd, 'Pending Requests', null);
});

$('#monitoring-cancelled-requests').parent('h3').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Cancelled Requests', customerCode, DateStart, DateEnd, 'Cancelled Requests', null);
})

$('#monitoring-internal-transactions').parent('h3').on('click', () => {
    const customerCode = getCustomerCode();
    showMonitoringDatatable('Internal Transactions', customerCode, DateStart, DateEnd, 'Internal', null);
});

$('#monitoring-list-container>button.expand-btn').on('click', () => {
    $('#monitoring-list-container').toggleClass('expanded');
    dimBackground('#monitoring-tab-pane');
    $('#monitoring-list-container>button.expand-btn>span').toggleClass('mdi mdi-arrow-expand');
    $('#monitoring-list-container>button.expand-btn>span').toggleClass('mdi mdi-arrow-collapse');
});

$('#monitoring-chart-group1>div:first-child>div:first-child button.expand-btn').on('click', () => {
    let $chart = $('#monitoring-transactions-pie-chart');
    $('#monitoring-chart-group1>div:first-child>div:first-child').toggleClass('expanded');
    $('#group1-filler').toggleClass('d-none');
    $('#monitoring-chart-group1>div:first-child>div:first-child>button.expand-btn>span').toggleClass('mdi mdi-arrow-expand');
    $('#monitoring-chart-group1>div:first-child>div:first-child>button.expand-btn>span').toggleClass('mdi mdi-arrow-collapse');
    $chart.toggleClass('chart-expand');
    dimBackground('#monitoring-tab-pane');

    if ($chart.hasClass('chart-expand')) {
        let prevHeight = monitoringTransactionsPieChart.w.config.chart.height;
        let prevWidth = monitoringTransactionsPieChart.w.config.chart.width;
        $chart.data('normal-height', prevHeight);
        $chart.data('normal-width', prevWidth);
        const expandedHeight = parseInt($('#monitoring-chart-group1>div:first-child>div:first-child').height()) * 0.9;
        monitoringTransactionsPieChart.updateOptions({
            chart: {
                height: expandedHeight,
                width: expandedHeight
            }
        });
    }
    else {
        monitoringTransactionsPieChart.updateOptions({
            chart: {
                height: $chart.data('normal-height'),
                width: $chart.data('normal-width')
            }
        });
    }
});

$('#monitoring-chart-group1>div:first-child>div:last-child button.expand-btn').on('click', () => {
    let $chart = $('#monitoring-truck-status-chart');
    $('#monitoring-chart-group1>div:first-child>div:last-child').toggleClass('expanded');
    $('#group1-filler').toggleClass('d-none');
    $('#monitoring-chart-group1>div:first-child>div:last-child>button.expand-btn>span').toggleClass('mdi mdi-arrow-expand');
    $('#monitoring-chart-group1>div:first-child>div:last-child>button.expand-btn>span').toggleClass('mdi mdi-arrow-collapse');
    $chart.toggleClass('chart-expand');
    dimBackground('#monitoring-tab-pane');

    if ($chart.hasClass('chart-expand')) {
        let prevHeight = monitoringTruckStatusChart.w.config.chart.height;
        let prevWidth = monitoringTruckStatusChart.w.config.chart.width;
        $chart.data('normal-height', prevHeight);
        $chart.data('normal-width', prevWidth);
        const expandedHeight = parseInt($('#monitoring-chart-group1>div:first-child>div:last-child').height()) * 0.9;
        monitoringTruckStatusChart.updateOptions({
            chart: {
                height: expandedHeight,
                width: expandedHeight
            }
        });
    }
    else {
        monitoringTruckStatusChart.updateOptions({
            chart: {
                height: $chart.data('normal-height'),
                width: $chart.data('normal-width')
            }
        });
    }
});

$('#monitoring-box-chart-container1 button.expand-btn').on('click', () => {
    let $chart = $('#monitoring-transactions-treemap-chart');
    $('#monitoring-box-chart-container1').toggleClass('expanded');
    dimBackground('#monitoring-tab-pane');
    $('#monitoring-box-chart-container1 button.expand-btn>span').toggleClass('mdi mdi-arrow-expand');
    $('#monitoring-box-chart-container1 button.expand-btn>span').toggleClass('mdi mdi-arrow-collapse');
    $chart.toggleClass('chart-expand');

    if ($chart.hasClass('chart-expand')) {
        let prevHeight = monitoringTransactionsTreeMapChart.w.config.chart.height;
        let prevWidth = monitoringTransactionsTreeMapChart.w.config.chart.width;
        $chart.data('normal-height', prevHeight);
        $chart.data('normal-width', prevWidth);
        const expandedWidth = parseInt($('#monitoring-box-chart-container1').width()) * 0.9;
        monitoringTransactionsTreeMapChart.updateOptions({
            chart: {
                width: expandedWidth,
            },
            plotOptions: {
                treemap: {
                    layout: 'horizontal'
                }
            },
        });
    }
    else {
        monitoringTransactionsTreeMapChart.updateOptions({
            chart: {
                height: $chart.data('normal-height'),
                width: $chart.data('normal-width')
            },
            plotOptions: {
                treemap: {
                    layout: 'vertical'
                }
            },
        });
    }
});

$('#monitoring-box-chart-container2 button.expand-btn').on('click', () => {
    let $chart = $('#monitoring-inventory-treemap-chart');
    $('#monitoring-box-chart-container2').toggleClass('expanded');
    dimBackground('#monitoring-tab-pane');
    $('#monitoring-box-chart-container2 button.expand-btn>span').toggleClass('mdi mdi-arrow-expand');
    $('#monitoring-box-chart-container2 button.expand-btn>span').toggleClass('mdi mdi-arrow-collapse');
    $chart.toggleClass('chart-expand');

    if ($chart.hasClass('chart-expand')) {
        let prevHeight = monitoringInventoryTreeMapChart.w.config.chart.height;
        let prevWidth = monitoringInventoryTreeMapChart.w.config.chart.width;
        $chart.data('normal-height', prevHeight);
        $chart.data('normal-width', prevWidth);
        const expandedWidth = parseInt($('#monitoring-box-chart-container2').width()) * 0.9;
        monitoringInventoryTreeMapChart.updateOptions({
            chart: {
                width: expandedWidth,
            },
            plotOptions: {
                treemap: {
                    layout: 'horizontal'
                }
            },
        });
    }
    else {
        monitoringInventoryTreeMapChart.updateOptions({
            chart: {
                height: $chart.data('normal-height'),
                width: $chart.data('normal-width')
            },
            plotOptions: {
                treemap: {
                    layout: 'vertical'
                }
            },
        });
    }
});

$('#monitoring-line-chart-container>button.expand-btn').on('click', () => {
    $('#monitoring-line-chart-container').toggleClass('expanded');
    dimBackground('#monitoring-tab-pane');
    $('#monitoring-line-chart-container>button.expand-btn>span').toggleClass('mdi mdi-arrow-expand');
    $('#monitoring-line-chart-container>button.expand-btn>span').toggleClass('mdi mdi-arrow-collapse');
});

function dimBackground(selector) {
    let height = parseInt($(selector).prop('scrollHeight'));
    let paddingTop = parseInt($(selector).css('padding-top'));
    let paddingBottom = parseInt($(selector).css('padding-bottom'));
    $('body').css('--dim-height', (height + paddingTop + paddingBottom) + 'px');
    $(selector).toggleClass('dim');
}

function collapseAll() {
    $('#monitoring-tab-pane').removeClass('dim');
    $('#monitoring-list-container').removeClass('expanded');
    $('#monitoring-list-container>button.expand-btn>span').addClass('mdi-arrow-expand');
    $('#monitoring-list-container>button.expand-btn>span').removeClass('mdi-arrow-collapse');

    $('#monitoring-line-chart-container').removeClass('expanded');
    $('#monitoring-line-chart-container>button.expand-btn>span').addClass('mdi-arrow-expand');
    $('#monitoring-line-chart-container>button.expand-btn>span').removeClass('mdi-arrow-collapse');

    $('#monitoring-transactions-pie-chart').removeClass('chart-expand');
    $('#monitoring-chart-group1>div:first-child>div:first-child').removeClass('expanded');
    $('#group1-filler').addClass('d-none');
    $('#monitoring-chart-group1>div:first-child>div:first-child>button.expand-btn>span').addClass('mdi-arrow-expand');
    $('#monitoring-chart-group1>div:first-child>div:first-child>button.expand-btn>span').removeClass('mdi-arrow-collapse');
    $('#monitoring-truck-status-chart').removeClass('chart-expand');
    $('#monitoring-chart-group1>div:first-child>div:last-child').removeClass('expanded');
    $('#monitoring-chart-group1>div:first-child>div:last-child>button.expand-btn>span').addClass('mdi-arrow-expand');
    $('#monitoring-chart-group1>div:first-child>div:last-child>button.expand-btn>span').removeClass('mdi-arrow-collapse');

    $('#monitoring-transactions-treemap-chart').removeClass('chart-expand');
    $('#monitoring-box-chart-container1').removeClass('expanded');
    $('#monitoring-box-chart-container1 button.expand-btn>span').addClass('mdi-arrow-expand');
    $('#monitoring-box-chart-container1 button.expand-btn>span').removeClass('mdi-arrow-collapse');

    $('#monitoring-inventory-treemap-chart').removeClass('chart-expand');
    $('#monitoring-box-chart-container2').removeClass('expanded');
    $('#monitoring-box-chart-container2 button.expand-btn>span').addClass('mdi-arrow-expand');
    $('#monitoring-box-chart-container2 button.expand-btn>span').removeClass('mdi-arrow-collapse');
}

async function getTransactions(customerCode, dateFrom, dateTo, filter, filterValue) {
    return $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetMonitoringDetailedTransactions",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        cache: false,
        data: JSON.stringify({ customerCode: customerCode, dateFrom: dateFrom, dateTo: dateTo, filter: filter, filterValue: filterValue }),
    });
}

function createHeaders(columns, tableID) {
    $(`#${tableID} thead`).empty();
    $(`#${tableID} thead`).append('<tr></tr>');
    columns.forEach((column) => {
        $(`#${tableID} thead tr:first-child`).append(`<th>${column}</th>`)
    });
}

function showMonitoringDatatable(title, customerCode, dateFrom, dateTo, filter, filterValue) {
    $('#export-modal').modal('show');
    $('#export-modal-title').text(title);

    if ($.fn.DataTable.isDataTable('table#export-table')) {
        $("table#export-table").DataTable().clear();
        $("table#export-table").DataTable().destroy();
    }

    $(`table#export-table thead`).empty();

    (async () => {
        let data = parseData((await getTransactions(customerCode, dateFrom, dateTo, filter, filterValue)).d);
        if (data.length <= 0) {
            $('#export-table').empty();
            $('#export-table').append(`<tbody><tr><td>No data to display</td></tr></tbody>`);
            return;
        }

        if (data[0]['Date']) {
            data = data.map((row) => {
                const date = Date.parse(row['Date']);
                return { ...row, Date: moment(date).format('MMM D YYYY') }
            })
        }

        const columns = Object.keys(data[0]);
        let dataTableColumns = [];
        columns.forEach((column) => {
            dataTableColumns.push({ data: column });
        });

        $('#export-table').empty();
        $('#export-table').append(`<thead></thead><tbody></tbody>`);

        createHeaders(columns, 'export-table');

        exportTable = $("table#export-table").DataTable({
            processing: true,
            orderCellsTop: true,
            searching: false,
            paging: false,
            info: false,
            data: data,
            columns: dataTableColumns
        });
    })();
}

$('#btn-export-excel').on('click', () => {
    const title = $('#export-modal-title').text();
    $('#export-table').tableExport({ type: 'xls', fileName: `${title}-${moment(Date.now()).format('MM-DD-YYYY')}`, });
});

$('#btn-export-csv').on('click', () => {
    const title = $('#export-modal-title').text();
    $('#export-table').tableExport({ type: 'csv', fileName: `${title}-${moment(Date.now()).format('MM-DD-YYYY')}`, });
});