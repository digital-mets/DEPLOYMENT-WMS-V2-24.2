<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmKPIDashboard.aspx.cs" Inherits="GWL.IT.frmKPIDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="assets/css/icons.min.css" />
    <link rel="stylesheet" type="text/css" href="assets/css/app.min.css" />
    <link rel="stylesheet" type="text/css" href="assets/css/vendor/dataTables.bootstrap4.css" />
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
    <link rel="stylesheet" type="text/css" href="css/frmKPIDashboard.css" />

    <script src="../js/PerfSender.js" type="text/javascript" defer="defer"></script>
    <script src="assets/js/vendor.min.js" type="text/javascript" defer="defer"></script>
    <script type="text/javascript" src="assets/js/app.min.js" defer="defer"></script>
    <script type="text/javascript" src="//cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js" defer="defer"></script>
    <script type="text/javascript" src="assets/js/vendor/dataTables.bootstrap4.js" defer="defer"></script>
    <script type="text/javascript" src="assets/js/vendor/dataTables.responsive.min.js" defer="defer"></script>
    <script type="text/javascript" src="js/data-table/tableExport.js" defer="defer"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/moment@2.30.1/moment.min.js" defer="defer"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js" defer="defer"></script>
    <script type="text/javascript" src="js/frmKPIDashboard.js" defer="defer"></script>

</head>
<body>
    <div class="row filters">
        <div class="row col-12">
            <div class="col-12 col-md-4 col-lg-3 form-inline">
                <label for="building-filter" class="mr-1">Building:</label>
                <select id="building-filter" class="form-control form-control-md flex-grow-1" disabled="disabled">
                </select>
            </div>
            <div class="col-12 col-md-4 col-lg-3 form-inline">
                <label for="client-filter" class="mr-1">Client:</label>
                <select id="client-filter" class="form-control form-control-md" disabled="disabled" multiple="multiple">
                </select>
            </div>
            <div class="col-12 col-md-4 col-lg-3">
                <button type="button" id="date-filter" class="btn btn-sm btn-outline-secondary col-12 d-flex justify-content-between" disabled="disabled">
                    <span class="text-center"></span>
                    <i class="mdi mdi-calendar"></i>
                </button>
            </div>
        </div>
    </div>
    <main>
        <div id="sections-container">
            <div id="inbound-section" class="row section">
                <h4 class="section-title col-12">Inbound</h4>
                <div class="sub-section col-12 d-flex flex-row justify-content-between py-1">
                    <div class="ml-1 flex-fill">
                        <p class="sub-section-title">Dwell Time</p>
                        <div id="inbound-dwell-time" class="chart-value text-center">0%</div>
                    </div>
                    <div id="inbound-dwell-time-chart" class="chart-container"></div>
                </div>
                <div class="sub-section col-12 d-flex flex-row justify-content-between py-1 half-circle">
                    <div class="ml-1 flex-fill">
                        <p class="sub-section-title">Attachment</p>
                        <div id="inbound-attachment" class="chart-value text-center"></div>
                    </div>
                    <div id="inbound-attachment-chart" class="chart-container"></div>
                    <div class="background-container attachment">
                        <span class="mdi mdi-paperclip"></span>
                        <span class="mdi mdi-paperclip"></span>
                    </div>
                </div>
                <div class="sub-section col-12 d-flex flex-row justify-content-between py-1">
                    <div class="ml-1 flex-fill">
                        <p class="sub-section-title">On-time Submission</p>
                        <p id="inbound-submission" class="chart-value text-center">0%</p>
                    </div>
                    <div id="inbound-submission-chart" class="chart-container"></div>
                </div>
            </div>

            <div id="outbound-section" class="row section">
                <h4 class="section-title col-12">Outbound</h4>
                <div class="sub-section col-12 d-flex flex-row justify-content-between py-1">
                    <div class="ml-1 flex-fill">
                        <p class="sub-section-title">Dwell Time</p>
                        <div id="outbound-dwell-time" class="chart-value text-center">0%</div>
                    </div>
                    <div id="outbound-dwell-time-chart" class="chart-container"></div>
                </div>
                <div id="outbound-in-full-section" class="sub-section col-12 d-flex flex-row justify-content-between my-1">
                    <div class="pl-1 flex-fill">
                        <p class="sub-section-title">In Full</p>
                        <div id="outbound-in-full" class="chart-value text-center">0%</div>
                    </div>
                    <div class="cargo-body">
                        <div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                            <div class="cargo-beam"></div>
                        </div>
                        <div class="cargo-corner top-left"></div>
                        <div class="cargo-corner top-right"></div>
                        <div class="cargo-corner bottom-left"></div>
                        <div class="cargo-corner bottom-right"></div>
                    </div>
                </div>
                <div class="sub-section col-12 d-flex flex-row justify-content-between py-1 half-circle">
                    <div class="ml-1 flex-fill">
                        <p class="sub-section-title">Attachment</p>
                        <div id="outbound-attachment" class="chart-value text-center"></div>
                    </div>
                    <div id="outbound-attachment-chart" class="chart-container"></div>
                    <div class="background-container attachment">
                        <span class="mdi mdi-paperclip"></span>
                        <span class="mdi mdi-paperclip"></span>
                    </div>
                </div>
                <div class="sub-section col-12 d-flex flex-row justify-content-between py-1">
                    <div class="ml-1 flex-fill">
                        <p class="sub-section-title">On-time Submission</p>
                        <p id="outbound-submission" class="chart-value text-center">0%</p>
                    </div>
                    <div id="outbound-submission-chart" class="chart-container"></div>
                </div>
            </div>

            <div id="midbound-section" class="row section">
                <h4 class="section-title col-12">Midbound</h4>
                <div class="sub-section col-12 d-flex flex-row justify-content-between py-1 half-circle">
                    <div class="ml-1 flex-fill">
                        <p class="sub-section-title">IRA</p>
                        <p class="sub-section-sub-title">(Inventory Replenishment Accuracy)</p>
                        <div id="midbound-ira" class="chart-value text-center"></div>
                    </div>
                    <div id="midbound-ira-chart" class="chart-container"></div>
                    <div class="background-container ira">
                        <span class="uil uil-box"></span>
                        <span class="uil uil-box"></span>
                    </div>
                </div>
                <div class="sub-section col-12 d-flex flex-row justify-content-between py-1 half-circle">
                    <div class="ml-1 flex-fill">
                        <p class="sub-section-title">LRA</p>
                        <p class="sub-section-sub-title">(Location Replenishment Accuracy)</p>
                        <div id="midbound-lra" class="chart-value text-center"></div>
                    </div>
                    <div id="midbound-lra-chart" class="chart-container"></div>
                    <div class="background-container lra">
                        <span class="mdi mdi-map-marker"></span>
                        <span class="mdi mdi-map-marker"></span>
                    </div>
                </div>
                <div class="sub-section col-12 d-flex flex-row justify-content-between py-1">
                    <div class="ml-1 flex-fill">
                        <p class="sub-section-title">On-time Submission</p>
                        <p id="midbound-submission" class="chart-value text-center">0%</p>
                    </div>
                    <div id="midbound-submission-chart" class="chart-container"></div>
                </div>
            </div>
        </div>
    </main>

    <div id="loading-indicator">
        <div class="loader"></div>
    </div>

    <div id="breakdown-modal" class="modal" tabindex="-1">
        <div class="modal-dialog modal-dialog-scrollable modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 id="breakdown-modal-title" class="modal-title ml-1">Modal title</h5>
                    <div class="ml-auto">
                        <button type="button" class="btn btn-primary btn-export btn-export-excel">Excel</button>
                        <button type="button" class="btn btn-primary btn-export btn-export-csv">CSV</button>
                    </div>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body px-0 pt-0">
                    <table name="breakdown-table" class="table dataTable w-100" id="breakdown-table" data-metric="" data-title="">
                        <thead>
                            <tr>
                                <th>Client</th>
                                <th>Hit Percentage</th>
                                <th>Total Count</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="misses-modal" class="modal" tabindex="-1">
        <div class="modal-dialog modal-dialog-scrollable modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 id="misses-modal-title" class="modal-title ml-1">Modal title</h5>
                    <div class="ml-auto">
                        <button type="button" class="btn btn-primary btn-export btn-export-excel">Excel</button>
                        <button type="button" class="btn btn-primary btn-export btn-export-csv">CSV</button>
                    </div>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body px-0 pt-0">
                    <table name="misses-table" class="table dataTable w-100" id="misses-table">
                        <thead></thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
