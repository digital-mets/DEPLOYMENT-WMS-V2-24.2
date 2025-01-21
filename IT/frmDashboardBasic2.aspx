<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDashboardBasic2.aspx.cs" Inherits="GWL.IT.frmDashboardBasic2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
    <!-- App css -->
    <link href="assets/css/icons.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/app.min.css" rel="stylesheet" type="text/css" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
    <link href="assets/css/vendor/dataTables.bootstrap4.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/apexcharts@3.54.1/dist/apexcharts.min.css"/>
    <link href="css/frmDashboardBasic2.css" rel="stylesheet" type="text/css" />

</head>
<body>
    <form id="form1" runat="server">

        <%--<div class="modal fade" id="TotalAssetmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog  modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Unbilled Clients</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" style="overflow-y: auto">

                        <table id="basic-datatable" class="table dt-responsive nowrap w-100">
                        </table>

                        <table id="basic-datatableexport" style="display: none">
                        </table>

                    </div>
                    <div class="modal-footer">

                        <button onclick="exportTableToExcel('basic-datatableexport','')" type="button" class="btn btn-info">Extract</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>

                    </div>
                </div>
            </div>
        </div>--%>

        <div class="modal fade" id="datatable-modal" tabindex="-1" role="dialog" aria-labelledby="datatable-modal-label" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-scrollable" role="document">
                <div class="modal-content">
                    <div class="modal-header align-items-center">
                        <h5 class="modal-title" id="datatable-modal-label"></h5>
                        <button type="button" class="btn btn-sm btn-outline-success ml-2" id="chart-excel-export-btn">Export</button>
                        <button type="button" class="close align-self-start" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body p-0">
                        <table class="table table-hover m-0" id="chart-datatable"></table>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="row-detail-modal" tabindex="-1" role="dialog" aria-labelledby="datatable-modal-label" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-scrollable" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="row-detail-modal-label"></h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body p-0">
                        <h4 class="text-center"></h4>
                    </div>
                </div>
            </div>
        </div>

        <!-- Begin page -->
        <div class="wrapper min-h-100">
            <div class="d-flex flex-column min-h-100 h-100">
                <%--<div class="">
                    <div class="col-12">
                        <div class="page-title-box">
                            <div class="page-title-right">
                                <div class="form-inline">
                                    
                                    <a href="javascript:  Dashboard();" class="btn btn-primary ml-2" id="reviewDash">
                                        <i class="mdi mdi-autorenew"></i>
                                    </a>
                                    <a href="javascript:  Dashboard();" class="btn btn-primary ml-2">
                                          <i class="tiny material-icons">cached</i>
                                    </a>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="col-12">
                        <h4 class="page-title"></h4>
                    </div> 
                </div>--%>

                <div class="filter-group form-inline p-2 justify-content-start">
                    <div class="form-group">
                        <%--<label for="customer"class="mr-1">Customer : </label>--%>
                        <%--<select id="customer" class="form-control form-control-md" data-toggle="tooltip" title="">
                        </select>--%>
                        <div id="customer" class="input-group">
                            <div class="input-group-prepend">
                                <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Customer</button>
                                <div class="dropdown-menu">
                                    <a class="dropdown-item selected" data-code="all">All</a>
                                </div>
                            </div>
                            <input id="customer-input" type="text" class="form-control" data-toggle="tooltip" title="All" data-trigger="hover" autocomplete="@(false)" value="All" />
                        </div>
                    </div>
                    <%--<div class="form-group">
                        <div id="warehouse" class="input-group">
                            <div class="input-group-prepend">
                                <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Warehouse</button>
                                <div class="dropdown-menu">
                                    <a class="dropdown-item selected" data-code="All">All</a>
                                </div>
                            </div>
                            <input id="warehouse-input" type="text" class="form-control" data-toggle="tooltip" title="All" data-trigger="hover" readonly="@(true)" value="All" />
                        </div>
                    </div>--%>
                    <div class="input-group">
                        <input type="text" class="form-control form-control-light  form-control-range text-center px-2" id="daterangetrans" />
                        <div class="input-group-append">
                            <span class="input-group-text bg-primary border-primary text-white">
                                <i class="mdi mdi-calendar-range font-13"></i>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="flex-grow-1 flex-shrink-1 overflow-auto">
                    <div class="col-12 min-h-100 h-100">
                        <div class="tabbable-panel min-h-100 h-100" style="padding: 0; margin: 0; border: 0;">
                            <div class="tabbable-line min-h-100 h-100 d-flex flex-column">
                                <nav>
                                    <div class="nav nav-tabs" id="nav-tab" role="tablist">
                                        <a class="nav-link tab active" id="tab-monitoring" data-toggle="tab" role="tab" href="#monitoring-tab-pane">MONITORING</a>
                                        <a class="nav-link tab" id="tab-inbound" data-toggle="tab" role="tab" href="#inbound-tab-pane">INBOUND</a>
                                        <a class="nav-link tab" id="tab-outbound" data-toggle="tab" role="tab" href="#outbound-tab-pane">OUTBOUND</a>
                                        <a class="nav-link tab" id="tab-productivity" data-toggle="tab" role="tab" href="#productivity-tab-pane">PRODUCTIVITY</a>
                                        <a class="nav-link tab" id="tab-truck-transaction" data-toggle="tab" role="tab" href="#truck-transaction-tab-pane">TRUCK TRANSACTION</a>
                                        <a class="nav-link tab" id="tab-contract" data-toggle="tab" role="tab" href="#contract-tab-pane">CONTRACT</a>
                                        <a class="nav-link tab" id="tab-perfect-shipment" data-toggle="tab" role="tab" href="#perfect-shipment-tab-pane">PERFECT SHIPMENT</a>
                                        <a class="nav-link tab" id="tab-queue" data-toggle="tab" role="tab" href="#queue-tab-pane">QUEUE</a>
                                    </div>
                                </nav>

                                <div class="tab-content flex-grow-1 flex-shrink-1 overflow-auto" id="tabcontent">
                                    <div id="inbound-tab-pane" class="tab-pane fade">
                                        <div class="row m-0">
                                            <div class="d-flex d-inline-flex col-12 p-0">
                                                <div class="flex-grow-1 p-0 mt-2">
                                                    <div class="card border p-2 mb-0" id="total-count-container">
                                                        <h3 class="text-center m-0" id="total-count">Loading...</h3>
                                                        <h4 class="text-center m-0">Total</h4>
                                                    </div>
                                                </div>
                                                <div class="flex-grow-1 p-0 mt-2 mx-2">
                                                    <div class="card border p-2 mb-0" id="billed-count-container">
                                                        <h3 class="text-center m-0" id="billed-count">Loading...</h3>
                                                        <h4 class="text-center m-0">Billed</h4>
                                                    </div>
                                                </div>
                                                <div class="flex-grow-1 p-0 mt-2">
                                                    <div class="card border p-2 mb-0" id="unbilled-count-container">
                                                        <h3 class="text-center m-0" id="unbilled-count">Loading...</h3>
                                                        <h4 class="text-center m-0">Unbilled</h4>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="d-flex flex-column col-12 col-md-6 p-0 mt-2">
                                                <div class="flex-grow-1  justify-content-center card border m-0 p-2 mt-0 mr-1">
                                                    <div id="transaction-chart"></div>
                                                    <span class="m-2">Loading...</span>
                                                </div>
                                            </div>
                                            <div class="d-flex flex-column col-md-6 p-0 m-0">
                                                <div class="flex-grow-1 justify-content-center row card border m-0 my-2 ml-0 ml-md-1">
                                                    <div class="d-flex justify-content-center">
                                                        <div id="progress-status-chart"></div>
                                                        <span class="m-2">Loading...</span>
                                                    </div>
                                                </div>
                                                <div class="flex-grow-1  justify-content-center row card border m-0  ml-0 ml-md-1">
                                                    <div class="d-flex justify-content-center">
                                                        <div id="storage-chart"></div>
                                                        <span class="m-2">Loading...</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="d-flex mt-4 mb-1 px-4 justify-content-between">
                                            <h4 class="">Transaction Trails</h4>
                                            <button type="button" class="btn btn-sm btn-outline-success ml-2" id="inbound-excel-export-btn">Export</button>
                                        </div>
                                        <div class="col-12 m-0 mb-2 data-table-height-wrapper">
                                            <table class="table" id="inbound-trails-datatable">
                                                <tr>
                                                    <td><span class="m-2">Loading...</span></td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                    <div id="outbound-tab-pane" class="tab-pane fade">
                                        <div class="row m-0">
                                            <div class="d-flex flex-column col-12 col-md-6 p-0 mt-2">
                                                <div class="flex-grow-1  justify-content-center card border m-0 p-2 mt-0 mr-1">
                                                    <div id="outbound-transaction-chart"></div>
                                                    <span class="m-2">Loading...</span>
                                                </div>
                                            </div>
                                            <div class="d-flex flex-column col-md-6 p-0 m-0">
                                                <div class="flex-grow-1 justify-content-center row card border m-0 my-2 ml-0 ml-md-1">
                                                    <div class="d-flex justify-content-center">
                                                        <div id="outbound-status-chart"></div>
                                                        <span class="m-2">Loading...</span>
                                                    </div>
                                                </div>
                                                <div class="flex-grow-1  justify-content-center row card border m-0  ml-0 ml-md-1">
                                                    <div class="d-flex justify-content-center">
                                                        <div id="shipment-type-chart"></div>
                                                        <span class="m-2">Loading...</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="d-flex mt-4 mb-1 px-4 justify-content-between">
                                            <h4 class="">Transaction Trails</h4>
                                            <button type="button" class="btn btn-sm btn-outline-success ml-2" id="outbound-excel-export-btn">Export</button>
                                        </div>
                                        <div class="col-12 m-0 mb-2 data-table-height-wrapper">
                                            <table class="table" id="outbound-trails-datatable">
                                                <tr>
                                                    <td><span class="m-2">Loading...</span></td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                    <div id="productivity-tab-pane" class="tab-pane fade">
                                        <div class="row m-0">
                                            <div class="d-flex flex-column col-12 p-0 mt-2">
                                                <div class="form-inline mb-2">
                                                    <label for="sort-by" class="ml-2 mr-2">Sort by</label>
                                                    <select id="sort-by" class="form-control form-control-sm">
                                                        <%--<option value="Assigned">Assigned</option>--%>
                                                        <option value="Rank">Rank</option>
                                                        <option value="Fullname">Fullname</option>
                                                        <%--<option value="Completed">Completed</option>
                                                            <option value="Ongoing">Ongoing</option>--%>
                                                    </select>
                                                    <label for="sort-direction" class="ml-4 mr-2">Sort by</label>
                                                    <select id="sort-direction" class="form-control form-control-sm">
                                                        <option value="asc">Ascending</option>
                                                        <option value="desc">Descending</option>
                                                    </select>
                                                    <label for="month" class="ml-4 mr-2">Month</label>
                                                    <select id="month" class="form-control form-control-sm">
                                                        <option value="All">All</option>
                                                        <option value="0">January</option>
                                                        <option value="1">February</option>
                                                        <option value="2">March</option>
                                                        <option value="3">April</option>
                                                        <option value="4">May</option>
                                                        <option value="5">June</option>
                                                        <option value="6">July</option>
                                                        <option value="7">August</option>
                                                        <option value="8">September</option>
                                                        <option value="9">October</option>
                                                        <option value="10">November</option>
                                                        <option value="11">December</option>
                                                    </select>
                                                </div>
                                                <div id="productivity-chart" class="mt-2"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="truck-transaction-tab-pane" class="tab-pane fade">
                                        <div class="filter-group form-inline my-2 mx-1">
                                            <div id="doc-number" class="input-group">
                                                <div class="input-group-prepend">
                                                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Doc number</button>
                                                    <div class="dropdown-menu">
                                                        <a class="dropdown-item selected" data-code="All">...</a>
                                                    </div>
                                                </div>
                                                <input id="doc-number-input" type="text" class="form-control" title="" value="" autocomplete="@(false)" />
                                            </div>
                                            <div class="form-group">
                                                <label for="transaction-type-select" class="form-label mr-2">Transaction Type</label>
                                                <select id="transaction-type-select" class="form-control">
                                                    <option value="All">All</option>
                                                    <option value="Inbound">Inbound</option>
                                                    <option value="Outbound">Outbound</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="overflow-wrapper">
                                            <div class="row-container">
                                                <div id="request-created" class="truck-status-container">
                                                    <div class="tear-drop">
                                                        <div class="icon-container circle m-4">
                                                            <span class="mdi mdi-file-plus mdi-48px"></span>
                                                        </div>
                                                    </div>
                                                    <h4 class="text-nowrap text-center status-label">Request Created</h4>
                                                    <h5 class="mt-0 text-center" id="request-created-date">&nbsp;</h5>
                                                </div>
                                                <div class="line"></div>
                                                <div id="truck-arrival" class="truck-status-container">
                                                    <div class="tear-drop">
                                                        <div class="icon-container circle m-4">
                                                            <span class="mdi mdi-truck mdi-48px"></span>
                                                        </div>
                                                    </div>
                                                    <h4 class="text-nowrap text-center status-label">Truck Arrival</h4>
                                                    <h5 class="mt-0 text-center" id="truck-arrival-date">&nbsp;</h5>
                                                </div>
                                                <div class="line"></div>
                                                <div id="docking" class="truck-status-container">
                                                    <div class="tear-drop">
                                                        <div class="icon-container circle m-4">
                                                            <span class="mdi mdi-warehouse mdi-48px"></span>
                                                        </div>
                                                    </div>
                                                    <h4 class="text-nowrap text-center status-label">Docking</h4>
                                                    <h5 class="mt-0 text-center" id="docking-date">&nbsp;</h5>
                                                </div>
                                                <div class="line"></div>
                                                <div id="start-loading" class="truck-status-container">
                                                    <div class="tear-drop">
                                                        <div class="icon-container circle m-4">
                                                            <span class="mdi mdi-forklift mdi-48px"></span>
                                                        </div>
                                                    </div>
                                                    <h4 class="text-nowrap text-center status-label">Start Loading</h4>
                                                    <h5 class="mt-0 text-center" id="start-loading-date">&nbsp;</h5>
                                                </div>
                                                <div class="line"></div>
                                                <div id="start-checking" class="truck-status-container">
                                                    <div class="tear-drop">
                                                        <div class="icon-container circle m-4">
                                                            <span class="mdi mdi-magnify mdi-48px"></span>
                                                        </div>
                                                    </div>
                                                    <h4 class="text-nowrap text-center status-label">Start Checking</h4>
                                                    <h5 class="mt-0 text-center" id="start-checking-date">&nbsp;</h5>
                                                </div>
                                            </div>
                                            <div class="row-container">
                                                <div id="end-checking" class="truck-status-container">
                                                    <div class="tear-drop">
                                                        <div class="icon-container circle m-4">
                                                            <span class="mdi mdi-magnify mdi-48px"></span>
                                                            <span class="check-mark mdi mdi-check-bold mdi-24px"></span>
                                                        </div>
                                                    </div>
                                                    <h4 class="text-nowrap text-center status-label">End Checking</h4>
                                                    <h5 class="mt-0 text-center" id="end-checking-date">&nbsp;</h5>
                                                </div>
                                                <div class="line"></div>
                                                <div id="end-loading" class="truck-status-container">
                                                    <div class="tear-drop">
                                                        <div class="icon-container circle m-4">
                                                            <span class="mdi mdi-forklift mdi-48px"></span>
                                                            <span class="check-mark mdi mdi-check-bold mdi-24px"></span>
                                                        </div>
                                                    </div>
                                                    <h4 class="text-nowrap text-center status-label">End Loading</h4>
                                                    <h5 class="mt-0 text-center" id="end-loading-date">&nbsp;</h5>
                                                </div>
                                                <div class="line"></div>
                                                <div id="start-processing" class="truck-status-container">
                                                    <div class="tear-drop">
                                                        <div class="icon-container circle m-4">
                                                            <span class="mdi mdi-file-sync mdi-48px"></span>
                                                        </div>
                                                    </div>
                                                    <h4 class="text-nowrap text-center status-label">Start Processing</h4>
                                                    <h5 class="mt-0 text-center" id="start-processing-date">&nbsp;</h5>
                                                </div>
                                                <div class="line"></div>
                                                <div id="end-processing" class="truck-status-container">
                                                    <div class="tear-drop">
                                                        <div class="icon-container circle m-4">
                                                            <span class="mdi mdi-file-check mdi-48px"></span>
                                                        </div>
                                                    </div>
                                                    <h4 class="text-nowrap text-center status-label">End Processing</h4>
                                                    <h5 class="mt-0 text-center" id="end-processing-date">&nbsp;</h5>
                                                </div>
                                                <div class="line"></div>
                                                <div id="departure" class="truck-status-container">
                                                    <div class="tear-drop">
                                                        <div class="icon-container circle m-4">
                                                            <span class="mdi mdi-truck-fast mdi-48px"></span>
                                                        </div>
                                                    </div>
                                                    <h4 class="text-nowrap text-center status-label">Departure</h4>
                                                    <h5 class="mt-0 text-center" id="departure-date">&nbsp;</h5>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="d-flex mt-4 mb-1 px-4 justify-content-between">
                                            <h4 class="">Transactions</h4>
                                            <button type="button" class="btn btn-sm btn-outline-success ml-2" id="truck-transactions-excel-export-btn">Export</button>
                                        </div>
                                        <div class="col-12 m-0 mb-2 data-table-height-wrapper">
                                            <table class="table" id="truck-transactions-datatable">
                                                <tr>
                                                    <td><span class="m-2">Loading...</span></td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                    <div id="contract-tab-pane" class="tab-pane fade">
                                        <div class="form-inline mt-2">
                                            <label for="expiration-input" class="ml-2 mr-2">About to expire on</label>
                                            <input type="date" id="expiration-input" class="form-control form-control-sm" />
                                        </div>
                                        <div class="row m-0">
                                            <div class="d-flex col-12 col-md-6 p-0 mt-2">
                                                <div class="flex-grow-1  justify-content-center card border m-0 p-2 mt-0 mr-0 mr-md-1" style="min-height: 248px;">
                                                    <div class="d-flex flex-grow-1 justify-content-center align-items-center">
                                                        <div id="contract-type-chart"></div>
                                                        <span class="m-2">Loading...</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="d-flex col-md-6 p-0 mt-2">
                                                <div class="flex-grow-1  justify-content-center row card border m-0  ml-0 ml-md-1" style="min-height: 248px;">
                                                    <div class="d-flex flex-grow-1 justify-content-center align-items-center">
                                                        <div id="contract-status-chart"></div>
                                                        <span class="m-2">Loading...</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="d-flex mt-4 mb-1 px-4 justify-content-between">
                                            <h4 class="">Contracts</h4>
                                            <button type="button" class="btn btn-sm btn-outline-success ml-2" id="contracts-excel-export-btn">Export</button>
                                        </div>
                                        <div class="col-12 m-0 mb-2 data-table-height-wrapper">
                                            <table class="table" id="contracts-datatable">
                                                <tr>
                                                    <td><span class="m-2">Loading...</span></td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                    <div id="perfect-shipment-tab-pane" class="tab-pane fade">
                                        <div class="row m-0">
                                            <div class="d-flex col-md-4 p-0 mt-2">
                                                <div class="flex-grow-1 card border p-2 justify-content-center m-0 mr-0 mr-md-1" style="max-height: 248px;">
                                                    <h4>Total KPI Score</h4>
                                                    <div class="d-flex flex-grow-1 justify-content-center align-items-center">
                                                        <div id="shipment-total-donut-chart"></div>
                                                        <span class="m-2">Loading...</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="d-flex col-md-4 p-0 mt-2">
                                                <div class="flex-grow-1 card border p-2 justify-content-center m-0 mx-0 mx-md-1" style="max-height: 248px;">
                                                    <h4>Inbound KPI Score</h4>
                                                    <div class="d-flex flex-grow-1 justify-content-center align-items-center">
                                                        <div id="shipment-inbound-donut-chart"></div>
                                                        <span class="m-2">Loading...</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="d-flex col-md-4 p-0 mt-2">
                                                <div class="flex-grow-1 card border p-2 justify-content-center m-0 ml-0 ml-md-1" style="max-height: 248px;">
                                                    <h4>Outbound KPI Score</h4>
                                                    <div class="d-flex flex-grow-1 justify-content-center align-items-center">
                                                        <div id="shipment-outbound-donut-chart"></div>
                                                        <span class="m-2">Loading...</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row m-0">
                                            <div class="d-flex col-md-6 px-0 mt-2">
                                                <div class="flex-grow-1 card border p-2 justify-content-center m-0 mr-0 mr-md-1">
                                                    <div id="shipment-inbound-column-chart"></div>
                                                    <span class="m-2">Loading...</span>
                                                </div>
                                            </div>
                                            <div class="d-flex col-md-6 px-0 mt-2">
                                                <div class="flex-grow-1 card border p-2 justify-content-center m-0 ml-0 ml-md-1">
                                                    <div id="shipment-outbound-column-chart"></div>
                                                    <span class="m-2">Loading...</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="d-flex mt-4 mb-1 px-4 justify-content-between">
                                            <h4>Inbound</h4>
                                            <button type="button" class="btn btn-sm btn-outline-success ml-2" id="shipment-inbound-excel-export-btn">Export</button>
                                        </div>
                                        <div class="col-12 m-0 mb-2 data-table-height-wrapper">
                                            <table class="table" id="shipment-inbound-datatable">
                                                <tr>
                                                    <td><span class="m-2">Loading...</span></td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div class="d-flex mt-4 mb-1 px-4 justify-content-between">
                                            <h4>Outbound</h4>
                                            <button type="button" class="btn btn-sm btn-outline-success ml-2" id="shipment-outbound-excel-export-btn">Export</button>
                                        </div>
                                        <div class="col-12 m-0 mb-2 data-table-height-wrapper">
                                            <table class="table" id="shipment-outbound-datatable">
                                                <tr>
                                                    <td><span class="m-2">Loading...</span></td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                    <div id="queue-tab-pane" class="tab-pane fade">
                                        <h3 class="mx-3 mt-4">Inbound</h3>
                                        <div id="queue-inbound" class="queue-table">
                                            <div class="queue-header">
                                                <div class="font-weight-bold">Queuing No.</div>
                                                <div class="font-weight-bold">Client Name</div>
                                                <div class="font-weight-bold">Arrival</div>
                                                <div class="font-weight-bold">Plate No.</div>
                                                <div class="font-weight-bold">Container No.</div>
                                                <div class="font-weight-bold">Truck Type</div>
                                                <div class="font-weight-bold">Dock No.</div>
                                                <div class="font-weight-bold">Plug-in No.</div>
                                                <div class="font-weight-bold">Temperature</div>
                                                <div class="font-weight-bold">Departure</div>
                                                <div class="font-weight-bold">Status</div>
                                            </div>
                                            <div class="queue-body"></div>
                                        </div>
                                        <h3 class="mx-3 mt-4">Outbound</h3>
                                        <div id="queue-outbound" class="queue-table">
                                            <div class="queue-header">
                                                <div class="font-weight-bold px-2">Queuing No.</div>
                                                <div class="font-weight-bold px-2">Client Name</div>
                                                <div class="font-weight-bold px-2">Arrival</div>
                                                <div class="font-weight-bold px-2">Plate No.</div>
                                                <div class="font-weight-bold px-2">Container No.</div>
                                                <div class="font-weight-bold px-2">Truck Type</div>
                                                <div class="font-weight-bold px-2">Dock No.</div>
                                                <div class="font-weight-bold px-2">Plug-in No.</div>
                                                <div class="font-weight-bold px-2">Temperature</div>
                                                <div class="font-weight-bold px-2">Departure</div>
                                                <div class="font-weight-bold px-2">Status</div>
                                            </div>
                                            <%--<div class="queue-body"></div>--%>
                                        </div>
                                    </div>
                                    <div id="monitoring-tab-pane" class="tab-pane active bg-white">
                                        <div id="monitoring-chart-group1" class="d-flex flex-column">
                                            <div class="d-flex flex-1 align-baseline align-items-center">
                                                <div class="gray-box flex-1 rounded d-flex flex-column pb-2 h-100">
                                                    <h5 class="mx-2 text-center">Transactions</h5>
                                                    <div class=" d-flex flex-column align-items-center justify-content-center flex-1">
                                                        <div id="monitoring-transactions-pie-chart"></div>
                                                    </div>
                                                </div>
                                                <div class="gray-box flex-1 rounded d-flex flex-column pb-2 h-100">
                                                    <h5 class="mx-2 text-center">Truck Status</h5>
                                                    <div class=" d-flex flex-column align-items-center justify-content-center flex-1">
                                                        <div id="monitoring-truck-status-chart"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row justify-content-center m-0">
                                                <div class="col-2 d-flex flex-1 flex-column justify-content-center align-items-center text-center p-0 mr-1">
                                                    <h5>ARRIVED</h5>
                                                    <div class="count-card card d-flex justify-content-center w-100">
                                                        <h1 id="arrived-count">0</h1>
                                                    </div>
                                                </div>
                                                <div class="col-2 d-flex flex-1 flex-column justify-content-center align-items-center text-center p-0 mx-1">
                                                    <h5>DOCKED</h5>
                                                    <div class="count-card card d-flex justify-content-center w-100">
                                                        <h1 id="docked-count">0</h1>
                                                    </div>
                                                </div>
                                                <div class="col-2 d-flex flex-1 flex-column justify-content-center align-items-center text-center p-0 mx-1">
                                                    <h5>LOADING</h5>
                                                    <div class="count-card card d-flex justify-content-center w-100">
                                                        <h1 id="loading-count">0</h1>
                                                    </div>
                                                </div>
                                                <div class="col-2 d-flex flex-1 flex-column justify-content-center align-items-center text-center p-0 mx-1">
                                                    <h5>DOCS</h5>
                                                    <div class="count-card card d-flex justify-content-center w-100">
                                                        <h1 id="docs-count">0</h1>
                                                    </div>
                                                </div>
                                                <div class="col-2 d-flex flex-1 flex-column justify-content-center align-items-center text-center p-0 mx-1">
                                                    <h5>DEPARTED</h5>
                                                    <div class="count-card card d-flex justify-content-center w-100">
                                                        <h1 id="departed-count">0</h1>
                                                    </div>
                                                </div>
                                                <div class="col-2 d-flex flex-1 flex-column justify-content-center align-items-center text-center p-0 ml-4">
                                                    <h5>TOTAL</h5>
                                                    <div class="count-card card d-flex justify-content-center w-100">
                                                        <h1 id="total-monitoring-count">0</h1>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="monitoring-chart-group2">
                                            <div class="rounded gray-box row m-0 p-0">
                                                <div class="col-3 text-center py-1 d-flex flex-column">
                                                    <h5 class="m-0 p-0 pb-1 mb-auto">Active Clients</h5>
                                                    <div class="text-bg m-0 p-1 rounded">
                                                        <span class="mdi mdi-handshake-outline mdi-36px text-orange"></span>
                                                        <h4 id="monitoring-clients" class="m-0">0</h4>
                                                    </div>
                                                </div>
                                                <div class="col-3 text-center py-1 d-flex flex-column">
                                                    <h5 class="m-0 p-0 pb-1 mb-auto">Active SKUs</h5>
                                                    <div class="text-bg m-0 p-1 rounded">
                                                        <span class="mdi mdi-package-variant-closed mdi-36px text-orange"></span>
                                                        <h4 id="monitoring-skus" class="m-0">0</h4>
                                                    </div>
                                                </div>
                                                <div class="col-3 text-center py-1 d-flex flex-column">
                                                    <h5 class="m-0 p-0 pb-1 mb-auto">Active WMS Users</h5>
                                                    <div class="text-bg m-0 p-1 rounded">
                                                        <span class="mdi mdi-monitor-dashboard mdi-36px text-orange"></span>
                                                        <h4 id="monitoring-wms-users" class="m-0">0</h4>
                                                    </div>
                                                </div>
                                                <div class="col-3 text-center py-1 d-flex flex-column">
                                                    <h5 class="m-0 p-0 pb-1 mb-auto">Active RF Users</h5>
                                                    <div class="text-bg m-0 p-1 rounded">
                                                        <span class="mdi mdi-cellphone mdi-36px text-orange"></span>
                                                        <h4 id="monitoring-rf-users" class="m-0">0</h4>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="rounded gray-box row m-0 p-0">
                                                <div class="col-3 text-center py-1 d-flex flex-column">
                                                    <h5 class="m-0 p-0 pb-1 mb-auto">Warehouse Capacity</h5>
                                                    <div class="text-bg m-0 p-1 rounded d-flex flex-column justify-content-center align-items-center position-relative overflow-hidden">
                                                        <div class="warehouse-bg"></div>
                                                        <%--<div class="progress-icon-container">
                                                            <i class="mdi mdi-warehouse left"></i>
                                                            <i class="mdi mdi-warehouse right"></i>
                                                        </div>--%>
                                                        <span class="mdi mdi-warehouse mdi-36px text-orange"></span>
                                                        <h4 id="monitoring-warehouse-capacity" class="m-0">0</h4>
                                                    </div>
                                                </div>
                                                <div class="col-3 text-center py-1 d-flex flex-column">
                                                    <h5 class="m-0 p-0 pb-1 mb-auto">Pallet</h5>
                                                    <div class="text-bg m-0 p-1 rounded">
                                                        <span class="uil uil-wall mdi-36px text-orange"></span>
                                                        <h4 id="monitoring-pallet" class="m-0">0</h4>
                                                    </div>
                                                </div>
                                                <div class="col-3 text-center py-1 d-flex flex-column">
                                                    <h5 class="m-0 p-0 pb-1 mb-auto">Unit</h5>
                                                    <div class="text-bg m-0 p-1 rounded">
                                                        <span class="uil uil-package mdi-36px text-orange"></span>
                                                        <h4 id="monitoring-unit" class="m-0">0</h4>
                                                    </div>
                                                </div>
                                                <div class="col-3 text-center py-1 d-flex flex-column">
                                                    <h5 class="m-0 p-0 pb-1 mb-auto">Weight</h5>
                                                    <div class="text-bg m-0 p-1 rounded">
                                                        <span class="mdi mdi-scale mdi-36px text-orange"></span>
                                                        <h4 id="monitoring-weight" class="m-0">0</h4>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="rounded gray-box row m-0 p-0">
                                                <div class="col-3 text-center py-1 d-flex flex-column">
                                                    <h5 class="m-0 p-0 pb-1 mb-auto">Processed Requests</h5>
                                                    <h3 class="text-bg m-0 p-1 rounded">
                                                        <span class="mdi mdi-file-check mdi-24px text-orange"></span>
                                                        &nbsp;<span id="monitoring-processed-requests">0</span>
                                                    </h3>
                                                </div>
                                                <div class="col-3 text-center py-1 d-flex flex-column">
                                                    <h5 class="m-0 p-0 pb-1 mb-auto">Pending Requests</h5>
                                                    <h3 class="text-bg m-0 p-1 rounded">
                                                        <span class="mdi mdi-sync mdi-24px text-orange"></span>
                                                        &nbsp;<span id="monitoring-pending-requests">0</span>
                                                    </h3>
                                                </div>
                                                <div class="col-3 text-center py-1 d-flex flex-column">
                                                    <h5 class="m-0 p-0 pb-1 mb-auto">Cancelled Requests</h5>
                                                    <h3 class="text-bg m-0 p-1 rounded">
                                                        <span class="mdi mdi-cancel mdi-24px text-orange"></span>
                                                        &nbsp;<span id="monitoring-cancelled-requests">0</span>
                                                    </h3>
                                                </div>
                                                <div class="col-3 text-center py-1 d-flex flex-column">
                                                    <h5 class="m-0 p-0 pb-1 mb-auto">Internal</h5>
                                                    <h3 class="text-bg m-0 p-1 rounded">
                                                        <span class="mdi mdi-swap-horizontal mdi-24px text-orange"></span>
                                                        &nbsp;<span id="monitoring-internal-transactions">0</span>
                                                    </h3>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="monitoring-chart-group3">
                                            <div class="rounded gray-box h-100">
                                                <div class="text-center p-1 d-flex flex-column">
                                                    <div id="monitoring-ontime-submission"></div>
                                                    <h5 class="m-0 p-0">On-time Submission</h5>
                                                </div>
                                                <div class="text-center p-1 d-flex flex-column">
                                                    <div id="monitoring-order-fulfillment"></div>
                                                    <h5 class="m-0 p-0">Order Fulfillment</h5>
                                                </div>
                                                <div class="text-center p-1 d-flex flex-column">
                                                    <div id="monitoring-dwell-time"></div>
                                                    <h5 class="m-0 p-0">Dwell Time</h5>
                                                </div>
                                                <div class="text-center p-1 d-flex flex-column">
                                                    <div id="monitoring-attachment"></div>
                                                    <h5 class="m-0 p-0">Attachment</h5>
                                                </div>
                                                <div class="text-center p-1 d-flex flex-column">
                                                    <div id="monitoring-ira"></div>
                                                    <h5 class="m-0 p-0">IRA</h5>
                                                </div>
                                                <div class="text-center p-1 d-flex flex-column">
                                                    <div id="monitoring-lra"></div>
                                                    <h5 class="m-0 p-0">LRA</h5>
                                                </div>
                                                <div class="text-center p-1 d-flex flex-column">
                                                    <div id="monitoring-billing-submission"></div>
                                                    <h5 class="m-0 p-0">Billing Submission</h5>
                                                </div>
                                                <div class="text-center p-1 d-flex flex-column">
                                                    <div id="monitoring-billing-invoice"></div>
                                                    <h5 class="m-0 p-0">Billing Invoice</h5>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="monitoring-list-container">
                                            <div class="overflow-auto">
                                                <div class="above-the-fold-spacer"></div>
                                                <div class="container-row header align-self-start">
                                                    <div class="container-col">DOC#</div>
                                                    <div class="container-col">ARRIVED</div>
                                                    <div class="container-col">DOCKED</div>
                                                    <div class="container-col">LOADING</div>
                                                    <div class="container-col">DOCS</div>
                                                    <div class="container-col">DEPARTED</div>
                                                    <div class="container-col">DWELL TIME</div>
                                                </div>
                                                <ul class="p-0" id="monitoring-list"></ul>
                                            </div>
                                        </div>
                                        <div id="monitoring-box-chart-container1" class="d-flex">
                                            <div class="rounded gray-box d-flex flex-column flex-1">
                                                <h5 class="mx-2 mb-0 text-center">Transactions</h5>
                                                <div class=" d-flex flex-column align-items-center justify-content-center flex-1 pb-2 px-2">
                                                    <div id="monitoring-transactions-treemap-chart"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="monitoring-box-chart-container2" class="d-flex">
                                            <div class="rounded gray-box d-flex flex-column flex-1">
                                                <h5 class="mx-2 mb-0 text-center">Inventory Volume</h5>
                                                <div class=" d-flex flex-column align-items-center justify-content-center flex-1 pb-2 px-2">
                                                    <div id="monitoring-inventory-treemap-chart"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="monitoring-line-chart-container">
                                            <div id="monitoring-line-chart" class="gray-box rounded"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- Common JS -->
    <script src="../js/PerfSender.js" type="text/javascript"></script>


    <!-- bundle -->
    <script src="assets/js/vendor.min.js"></script>
    <script src="assets/js/app.min.js"></script>

    <!-- third party js -->
    <%--<script src="assets/js/vendor/Chart.bundle.min.js"></script>
    <script src="assets/js/vendor/apexcharts.min.js"></script>--%>
    <script src="https://cdn.jsdelivr.net/npm/apexcharts@3.54.1/dist/apexcharts.min.js"></script>
    <script src="assets/js/vendor/jquery-jvectormap-1.2.2.min.js"></script>
    <script src="assets/js/vendor/jquery-jvectormap-world-mill-en.js"></script>
    <script src="js/data-table/tableExport.js"></script>
    <!-- third party js ends -->

    <!-- demo app -->

    <!-- end demo js-->

    <!-- Datatables js -->
    <script src="//cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>
    <script src="assets/js/vendor/dataTables.bootstrap4.js"></script>
    <script src="assets/js/vendor/dataTables.responsive.min.js"></script>
    <%--<script src="assets/js/vendor/responsive.bootstrap4.min.js"></script>--%>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>

    <!-- Custom js -->
    <script src="../js/Dash.js" type="text/javascript"></script>
    <%-- TABLES--%>
    <script src="../js/ConstructTable.js"></script>
    <%-- CHARTS--%>
    <script src="../js/ConstructChart.js"></script>

</body>
</html>