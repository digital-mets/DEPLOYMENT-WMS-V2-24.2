let modules = {};
let tableFilters = [];
let moduleTable = null;
let moduleParameters = [];

$(document).ready(
    () => {
        $.ajax({
            type: "GET",
            cache: false,
            url: "frmModuleExtraction.aspx/GetModules",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: (response) => {
                modules = parseResponse(response);
                fillModulesDropdown(modules);
            },
            error: (xhr, status, error) => {
                toast(error);
            }
        });
    }
);

// Event handlers

$('#btn-toggle-params').on('click', () => {
    if ($('#params-panel.collapsible').hasClass('expand')) {
        collapseParameters();
    }
    else {
        expandParameters();
    }
});

$('#module-dropdown input').on('keyup paste', (e) => {
    const searchKeyword = $('#module-dropdown input').val().trim().toLowerCase();
    let options = [];
    if (searchKeyword === '') {
        options = modules;
    }
    else {
        options = modules.filter((option) => {
            return option['DisplayName'].toLowerCase().includes(searchKeyword);
        });
    }

    fillModulesDropdown(options);

    $('#module-dropdown .dropdown-toggle').dropdown('show');
    $('#module-dropdown input').focus();
    $('#module-dropdown .dropdown-item.selected').removeClass('selected');
    $('#btn-generate').prop('disabled', true);
    $('#params-panel div.form-row').empty();
    $('#params-panel div.form-row').append($('<p class="col-12 text-center mb-1">No parameter</p>'));

    if (e.which == 13 && options.length === 1) {
        $('#module-dropdown input').blur();
        $('#module-dropdown .dropdown-toggle').dropdown('hide');
        const selectedOption = $('#module-dropdown .dropdown-item')[0];
        const module = $(selectedOption).data('value');
        const isServerSide = $(selectedOption).data('serverside') == 1;

        // recreate dropdown
        fillModulesDropdown(modules);
        const match = $("#module-dropdown .dropdown-menu").find(`div[data-value='${module}']`);
        $(match).addClass('selected');
        $('#module-dropdown input').val($(match).text());

        destroyTable();

        if (isServerSide) {
            collapseParameters();
            $('#btn-toggle-params').prop('disabled', true);
            clearParameters();
            getColumns(optionValue, createDataTable, true);
        }
        else {
            getModuleParameters(optionValue, createParameters);
            $('#btn-toggle-params').prop('disabled', false);
            expandParameters();
        }
    }

    $('#module-dropdown input').attr('data-original-title', $('#module-dropdown input').val().trim());
})

$('#module-dropdown div.dropdown-menu').on('click', '.dropdown-item', function () {
    const optionValue = $(this).attr('data-value');
    // recreate dropdown options if filtered previously
    if ($('#module-dropdown .dropdown-item').length !== modules.length) {
        fillModulesDropdown(modules);
    }

    $('#params-panel div.form-row').empty();
    $('#params-panel div.form-row').append($('<p class="col-12 text-center mb-1">No parameter</p>'));
    $('#btn-generate').prop('disabled', true);
    $('#module-dropdown .dropdown-item.selected').removeClass('selected');
    const match = $('#module-dropdown .dropdown-menu').find(`.dropdown-item[data-value='${optionValue}']`);
    $(match).addClass('selected');
    $('#module-dropdown input').val($(this).text());
    $('#module-dropdown input').attr('data-original-title', $(this).text());
    const isServerSide = $(match).data('serverside') == 1;

    destroyTable();

    if (isServerSide) {
        collapseParameters();
        $('#btn-toggle-params').prop('disabled', true);
        clearParameters();
        getColumns(optionValue, createDataTable, true);
    }
    else {
        getModuleParameters(optionValue, createParameters);
        $('#btn-toggle-params').prop('disabled', false);
        expandParameters();
    }
});

$('#btn-generate').on('click', () => {
    $('#btn-generate').prop('disabled', true);
    tableFilters = [];
    const module = $('#module-dropdown .dropdown-item.selected').data('value');
    let isValidForm = true;

    $('#params-panel div.form-row input').each(function () {
        if ($(this).data('is-required') == 1 && $(this).val().trim() === '') {
            toast('Please fill all required fields.');
            moduleParameters = [];
            isValidForm = false;
            $('#btn-generate').prop('disabled', false);
            return false;
        }
        switch ($(this).prop('type')) {
            case 'text':
                moduleParameters[parseInt($(this).data('index'))] = $(this).val().trim();
                break;
            case 'date':
                moduleParameters[parseInt($(this).data('index'))] = moment($(this).val().trim()).format('YYYY-MM-DD');
                break;
            case 'datetime-local':
                moduleParameters[parseInt($(this).data('index'))] = moment($(this).val().trim()).format('YYYY-MM-DD HH:mm:ss.SSS');
                break;
            default:
                moduleParameters[parseInt($(this).data('index'))] = $(this).val().trim();
                break;
        }
    });

    if (isValidForm) {
        destroyTable();
        getColumns(module, createDataTable, false);
    }
});

$(document).on('keyup', '.dataTables_scrollHead table[name="tblModule"] input.dtFilters', function (event) {
    var $this = $(this);
    if (event.keyCode != 13) return;
    tableFilters = [];
    $('.dataTables_scrollHead table[name="tblModule"] input.dtFilters').each(function (index, obj) {
        const colIndex = parseInt($(obj).data("index"));
        const strValue = $(obj).val().trim();
        tableFilters[colIndex] = strValue
    });
    if (moduleTable.column($this.data("index")).search() !== $this.val()) {
        moduleTable.column($this.data("index")).search(this.value).draw();
    }
});

$('body').on('keyup', '#params-panel div.form-row input.input-int', function () {
    $(this).val($(this).val().replace(/([^-\d]|(?!^)-)/g, ''));
});

$('body').on('keyup', '#params-panel div.form-row input.input-decimal', function () {
    let inputVal = $(this).val();
    let decimalFound = false;
    inputVal = inputVal.replace(/\./g, (match) => {
        if (decimalFound) {
            return '';
        } else {
            decimalFound = true;
            return match;
        }
    });
    inputVal = inputVal.replace(/([^.\d-]|(?!^)-)/g, '');
    $(this).val(inputVal);
});


function collapseParameters() {
    $('#params-panel.collapsible').removeClass('expand');
    $('#params-panel.collapsible').addClass('hide');
    $('#btn-toggle-params>span').removeClass('mdi-chevron-double-up')
    $('#btn-toggle-params>span').addClass('mdi-chevron-double-down')
}

function expandParameters() {
    $('#params-panel.collapsible').removeClass('hide');
    $('#params-panel.collapsible').addClass('expand');
    $('#btn-toggle-params>span').removeClass('mdi-chevron-double-down')
    $('#btn-toggle-params>span').addClass('mdi-chevron-double-up')
}

function getModuleParameters(module, onSuccess) {
    $('#btn-generate').prop('disabled', false);
    $.ajax({
        type: "POST",
        cache: false,
        url: "frmModuleExtraction.aspx/GetModuleParameters",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ module: module }),
        success: (response) => {
            const parameters = parseResponse(response);
            onSuccess(parameters);
        },
        error: (xhr, status, error) => {
            toast(error);
        }
    });
}

function clearParameters() {
    $('#params-panel div.form-row').empty()
    moduleParameters = [];
}

function createParameters(parameters) {
    clearParameters();

    if (parameters.length === 0) {
        $('#params-panel div.form-row').append($('<p class="col-12 text-center mb-1">No parameter</p>'));
        return;
    }

    parameters.forEach((parameter) => {
        let $parameterInputGroup = $(`<div class="form-group col-12 col-sm-6 col-md-4"><label for="${parameter['ColumnName']}">${parameter['Label']}
            ${parameter['IsRequired'] == 1 ? '<span class="text-danger">&nbsp;*</span>' : ''}</label></div>`);
        switch (parameter['Type'].toLowerCase()) {
            case 'string':
                $parameterInputGroup.append($(`
                        <input id="${parameter['ColumnName']}" class="form-control" name="${parameter['ColumnName']}" type="text" data-index="${parameter['Order']}" data-is-required="${parameter['IsRequired'] == 1}">
                `));
                break;
            case 'date':
                $parameterInputGroup.append($(`
                        <input id="${parameter['ColumnName']}" class="form-control" name="${parameter['ColumnName']}" type="date" data-index="${parameter['Order']}" data-is-required="${parameter['IsRequired'] == 1}">
                `));
                break;
            case 'dateTime':
                $parameterInputGroup.append($(`
                        <input id="${parameter['ColumnName']}" class="form-control" name="${parameter['ColumnName']}" type="datetime-local" data-index="${parameter['Order']}" data-is-required="${parameter['IsRequired'] == 1}">
                `));
                break;
            case 'int':
                $parameterInputGroup.append($(`
                        <input id="${parameter['ColumnName']}" class="form-control input-int" name="${parameter['ColumnName']}" type="text" data-index="${parameter['Order']}" data-is-required="${parameter['IsRequired'] == 1}">
                `));
                break;
            case 'decimal':
                $parameterInputGroup.append($(`
                        <input id="${parameter['ColumnName']}" class="form-control input-decimal" name="${parameter['ColumnName']}" type="text" data-index="${parameter['Order']}" data-is-required="${parameter['IsRequired'] == 1}">
                `));
                break;
            default:
                $parameterInputGroup.append($(`
                        <input id="${parameter['ColumnName']}" class="form-control" name="${parameter['ColumnName']}" type="text" data-index="${parameter['Order']}" data-is-required="${parameter['IsRequired'] == 1}">
                `));
                break;
        }
        $('#params-panel div.form-row').append($parameterInputGroup);
    })
}

function fillModulesDropdown(options) {
    $('#module-dropdown div.dropdown-menu').empty();

    if (options.length === 0) {
        $($('#module-dropdown div.dropdown-menu').append(`<div class="dropdown-item disabled">No module matched</div>`))
        return;
    }

    options.forEach((option) => {
        $($('#module-dropdown div.dropdown-menu').append(
            `<div class="dropdown-item" data-value="${option['Value'].toLowerCase()}" data-serverside="${option['IsServerSide']}">
                ${option['DisplayName']}
            </div>`
        ));
    })
}

function parseResponse(response) {
    return JSON.parse(response.d);
}

function getColumns(module, onSuccess, isServerSide) {
    $.ajax({
        type: "POST",
        cache: false,
        url: "frmModuleExtraction.aspx/GetModuleColumns",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ module: module }),
        success: (response) => {
            const columns = parseResponse(response);
            onSuccess(module, columns, isServerSide);
        },
        error: (xhr, status, error) => {
            toast(error);
        }
    });
}

function createHeaders(columns) {
    $('#tblModule thead').empty();
    $('#tblModule thead').append('<tr></tr>');
    columns.forEach((column) => {
        $('#tblModule thead tr:first-child').append(`<th>${column['Label']}</th>`)
    });

}

function createDataTable(module, columns, isServerSide) {
    createHeaders(columns);
    const dataTableColumns = generateColumns(columns);
    if (isServerSide) {
        loadServerSideDataTable(module, dataTableColumns);
    }
    else loadClientSideDataTable(module, dataTableColumns);
}

function destroyTable() {
    if (!$.fn.DataTable.isDataTable('table#tblModule')) return;
    $("table#tblModule").DataTable().clear();
    $("table#tblModule").DataTable().destroy();
    $('#tblModule thead tr').empty();
    $('#tblModule tbody').empty();
}

function generateColumns(columns) {
    let dataTableColumns = [];
    columns.forEach((column) => {
        dataTableColumns.push({ data: column['ColumnName'], orderable: column['Sortable'] == 1 ? true : false, width: column['Width'], searchable: column['Searchable'] == 1 ? true : false });
    });
    return dataTableColumns;
}

function loadClientSideDataTable(module, columns) {
    let defaultOrder = columns.findIndex(function (column) {
        return column['orderable'];
    });
    defaultOrder = defaultOrder === -1 ? 0 : defaultOrder;

    $.ajax({
        type: "POST",
        url: "frmModuleExtraction.aspx/GetWholeTable",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        cache: false,
        data: JSON.stringify({ module: module, moduleParameters: JSON.stringify(moduleParameters) }),
        success: (response) => {
            const wholeTable = parseResponse(response);

            if (columns.length <= 0 && wholeTable.length > 0) {
                const columnNames = Object.keys(wholeTable[0]);
                let columnLabels = [];
                columnNames.forEach((column) => {
                    columns.push({ data: column, orderable: true, searchable: true });
                    columnLabels.push({Label: column});
                });
                createHeaders(columnLabels);
            }

            moduleTable = $("table#tblModule").DataTable({
                data: wholeTable,
                processing: true,
                scrollX: true,
                scrollY: '400px',
                orderCellsTop: true,
                order: [[defaultOrder, 'asc']],
                columns: columns,
                dom: '<"d-flex justify-content-space-between"<"col p-0"B><"d-flex"l>>rtip',
                buttons: [
                    {
                        text: 'CSV <span class="ml-2 spinner-border spinner-border-sm" role="status" aria-hidden="true"></span><span class="sr-only"> Loading...</span>',
                        extend: 'csv',
                        className: "btn btn-md btn-success btn-csv",
                        filename: () => { return module; }
                    },
                    {
                        text: 'Excel <span class="ml-2 spinner-border spinner-border-sm" role="status" aria-hidden="true"></span><span class="sr-only"> Loading...</span>',
                        extend: 'excel',
                        className: "btn btn-md btn-success btn-excel",
                        filename: () => { return module; }
                    },
                ],
                initComplete: (settings, json) => {
                    $('#btn-generate').prop('disabled', false);
                }
            });
        },
        error: (xhr, status, error) => {
            toast(error);
        }
    });
}

function loadServerSideDataTable(module, columns) {
    let defaultOrder = columns.findIndex(function (column) {
        return column['orderable'];
    });
    defaultOrder = defaultOrder === -1 ? 0 : defaultOrder;

    $("table#tblModule thead tr").clone(true).appendTo("table#tblModule thead");
    $("table#tblModule thead tr:eq(1) th").each(function (index) {
        const title = $(this).text();
        $(this).html(`<input data-index="${index}" data-name="${columns[index]['data']}" class="dtFilters" type="text" placeholder="${title}" ${columns[index]['searchable'] ? '' : 'disabled'}>`);
    });

    moduleTable = $("table#tblModule").DataTable({
        serverSide: true,
        processing: true,
        scrollX: true,
        scrollY: '400px',
        orderCellsTop: true,
        order: [[defaultOrder, 'asc']],
        dom: '<"d-flex justify-content-space-between"<"col p-0"B><"d-flex"l>>rtip',
        buttons: [
            //{ extend: 'colvis', text: 'Columns' },
            {
                text: 'CSV <span class="ml-2 spinner-border spinner-border-sm" role="status" aria-hidden="true"></span><span class="sr-only"> Loading...</span>',
                extend: 'csv',
                className: "btn btn-md btn-success btn-csv",
                action: function (e, dt, button, config) { exportTable(e, dt, button, config, columns, { module: module, filters: JSON.stringify(tableFilters), moduleParameters: JSON.stringify(moduleParameters), fileType: 'csv' }) }
            },
            {
                text: 'Excel <span class="ml-2 spinner-border spinner-border-sm" role="status" aria-hidden="true"></span><span class="sr-only"> Loading...</span>',
                extend: 'excel',
                className: "btn btn-md btn-success btn-excel",
                action: function (e, dt, button, config) { exportTable(e, dt, button, config, columns, { module: module, filters: JSON.stringify(tableFilters), moduleParameters: JSON.stringify(moduleParameters), fileType: 'excel' }) }
            },
        ],
        ajax: {
            type: "POST",
            url: "frmModuleExtraction.aspx/GetTable",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            cache: false,
            data: function (d) {
                return JSON.stringify({
                    draw: d.draw,
                    start: d.start,
                    length: d.length,
                    searchValue: d.search.value,
                    orderColumn: columns[d.order[0].column]['data'],
                    orderDir: d.order[0].dir,
                    parameters: JSON.stringify({ module: module, filters: JSON.stringify(tableFilters), moduleParameters: JSON.stringify(moduleParameters) })
                });
            },
            dataFilter: function (response) {
                const parsed = JSON.parse(response);
                return parsed.d;
            },
            dataSrc: function (json) {
                return JSON.parse(json['data']);
            },
            error: function (xhr, status, error) {
                toast(error);
                $('#btn-generate').prop('disabled', false);
            }
        },
        columns: columns,
    });
}

function exportTable(e, dt, button, config, columns, parameters) {
    let api = '';
    let btnClass = '';
    switch (parameters['fileType']) {
        case 'excel':
            api = 'DownloadExcelTable';
            btnClass = 'btn-excel';
            break;
        case 'csv':
            api = 'DownloadCsv'
            btnClass = 'btn-csv';
            break;
        default:
            api = 'DownloadExcelTable'
            btnClass = 'btn-excel';
            break;
    }

    $(`.${btnClass} .spinner-border`).css('display', 'inline-block');
    $(`.${btnClass}`).prop('disabled', true);
    $.ajax({
        type: "POST",
        cache: false,
        url: 'frmModuleExtraction.aspx/' + api,
        contentType: "application/json; charset=utf-8",
        xhrFields: {
            responseType: 'blob'
        },
        data: JSON.stringify({
            draw: 0,
            start: 0,
            length: -1,
            searchValue: '',
            orderColumn: columns[dt.order()[0][0]]['data'],
            orderDir: dt.order()[0][1],
            parameters: JSON.stringify(parameters)
        }),
        success: (data, status, xhr) => {
            const module = parameters['module'];
            const disposition = xhr.getResponseHeader('Content-Disposition');
            let filename = module + '.xlsx'; // Default filename
            // use original file extension
            if (disposition && disposition.indexOf('attachment') !== -1) {
                const matches = /filename="([^"]*)"/.exec(disposition);
                if (matches != null && matches[1]) filename = `${module}.${matches[1].split('.')[1]}`;
            }

            const blob = new Blob([data], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel' });
            const url = window.URL.createObjectURL(blob);

            let anchor = $('<a></a>')
                .attr('href', url)
                .attr('download', filename)
                .css('display', 'none');

            $('body').append(anchor);
            anchor[0].click();
            anchor.remove();

            window.URL.revokeObjectURL(url);
            $(`.${btnClass} .spinner-border`).hide();
            $(`.${btnClass}`).prop('disabled', false);
        },
        error: (xhr, status, error) => {
            toast(error);
            $(`.${btnClass} .spinner-border`).hide();
            $(`.${btnClass}`).prop('disabled', false);
        }
    });
}

function toast(message) {
    alert(message);
}