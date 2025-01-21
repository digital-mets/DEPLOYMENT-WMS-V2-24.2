<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDashboardCFO.aspx.cs" Inherits="GWL.frmDashboardCFO" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
    <!-- third party css -->
    <link href="assets/css/vendor/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
    <!-- third party css end -->

    <!-- App css -->
    <link href="assets/css/icons.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/app.min.css" rel="stylesheet" type="text/css" />

    <link href="assets/css/vendor/dataTables.bootstrap4.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">

                  <div class="modal fade" id="TotalAssetmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog  modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Unbilled Clients</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" style="overflow-y: auto">

                        <%--  Table Content--%>

                        <table id="basic-datatable" class="table dt-responsive nowrap w-100">
                        </table>



                        <table id="basic-datatableexport" style="display:none" >
                        </table>
                       
                         

                    </div>
                    <div class="modal-footer">
                          
                        <button onclick="exportTableToExcel('basic-datatableexport','')" type="button" class="btn btn-info" >Extract</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        
                    </div>
                </div>
            </div>
        </div>
        <!-- Begin page -->
        <div class="wrapper">
            <!-- Start Content-->
            <div class="container-fluid">

                <div class="row">
                                      <div class="col-lg-12">
                        <div class="page-title-box">
                            <div class="page-title-right">
                                <div class="form-inline">
                                    <div class="form-group">
                                          <div class="input-group" >
                                            <input type="text" class="form-control form-control-light" id="dash-period"  />
                                            <div class="input-group-append">
                                                <span class="input-group-text bg-primary border-primary text-white">
                                                    <i class="mdi mdi-calendar-range font-13"></i>
                                                </span>
                                            </div>
                                        </div>

                                       <div class="input-group date" style="display:none">
                                            <input type="text" class="form-control form-control-light" id="daterangetrans" style="text-align: center; width:20rem" />
                                             <div class="input-group-append">
                                                <span class="input-group-text bg-primary border-primary text-white">
                                                    <i class="mdi mdi-calendar-range font-13"></i>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <a href="javascript:  Dashboard();" class="btn btn-primary ml-2">
                                        <i class="mdi mdi-autorenew"></i>
                                    </a>
                                </div>
                            </div>
                            <h4 class="page-title">CFO Dashboard</h4>
                        </div>
                    </div>
                         <div class="col-12">
                        <div class="card widget-inline">
                            <div class="card-body p-0">
                                <div class="row no-gutters">
                                    <div class="col-sm-6 col-xl-3">
                                        <a  onclick="cardClick(0,'Income')" data-toggle="modal" style="cursor: pointer;">
                                        <div class="card shadow-none m-0">
                                            <div class="card-body text-center">
                                                <i class=" dripicons-arrow-up  text-success" style="font-size: 24px;"></i>
                                                <h3><span id="income">0</span></h3>
                                                <p class="text-muted font-15 mb-0">Income <span id="incomeperc" class="text-success mr-2"><i class="mdi mdi-arrow-up-bold"></i> 3.37%</span></p>
                                               
                                            </div>
                                        </div>
                                            </a>
                                    </div>

                                    <div class="col-sm-6 col-xl-3">
                                        <a  onclick="cardClick(1,'Cost of Goods')" data-toggle="modal" style="cursor: pointer;">
                                        <div class="card shadow-none m-0 border-left">
                                            <div class="card-body text-center">
                                                <i class=" dripicons-arrow-down text-warning" style="font-size: 24px;"></i>
                                                <h3><span id="cogs">0</span></h3>
                                                <p class="text-muted font-15 mb-0">Cost of Goods <span id="cogsperc" class="text-warning mr-2"><i class="mdi mdi-arrow-down-bold"></i> 5.47%</span></p>
                                            </div>
                                        </div>
                                            </a>
                                    </div>

                                    <div class="col-sm-6 col-xl-3">
                                        <a  onclick="cardClick(2,'Expenses')" data-toggle="modal" style="cursor: pointer;">
                                        <div class="card shadow-none m-0 border-left">
                                            <div class="card-body text-center">
                                                <i class="dripicons-user-group text-danger" style="font-size: 24px;"></i>
                                                <h3><span id="expense">0</span></h3>
                                                <p class="text-muted font-15 mb-0">Expenses <span id="expenseperc" class="text-warning mr-2"><i class="mdi mdi-arrow-up-bold"></i> 5.47%</span></p>
                                            </div>
                                        </div>
                                            </a>
                                    </div>

                                   <div class="col-sm-6 col-xl-3">
                                       <a  onclick="cardClick(3,'Net Profit')" data-toggle="modal" style="cursor: pointer;">
                                        <div class="card shadow-none m-0 border-left">
                                            <div class="card-body text-center">
                                                <i class=" dripicons-graph-line  text-warning" style="font-size: 24px;"></i>
                                                <h3><span id="netprofit">0</span></h3>
                                                <p class="text-muted font-15 mb-0">Net Profit <span id="netprofitperc" class="text-success mr-2"><i class="mdi mdi-arrow-up-bold"></i> 5.47%</span></p>
                                            </div>
                                        </div>
                                           </a>
                                    </div>
                                   

                                </div>
                                <!-- end row -->
                            </div>
                        </div>
                        <!-- end card-box-->
                    </div>
                      
                    
                    <!-- end col -->

                </div>
                <div class="row mt-3">
                    
                    <div class="col-xl-8 col-lg-8">
                        <div class="card">
                            <div class="card-body">
                               
                               
                                <h4 class="header-title mb-3">Income and Expense</h4>

                                <div id="high-performing-product2" class="apex-charts"
                                    data-colors="#727cf5,#e3eaef">
                                </div>
                            </div>
                            <!-- end card-body-->
                        </div>
                        <!-- end card-->
                    </div>

                    <div class="col-xl-4     col-lg-4">
                    <div class="card">
                        <div class="card-body">
                                <a onclick="cardClick(12,'AR')" class="p-0 float-right mb-3">Data <i class="mdi mdi-download ml-1"></i></a>
                            <h4 class="header-title">Payable and Receivables</h4>

                            <div id="sessions-os" class="apex-charts mt-3" data-colors="#727cf5,#0acf97,#fa5c7c,#ffbc00"></div>

                            <div class="row text-center mt-2">
                                <div class="col-6">
                                    <h4 class="font-weight-normal">
                                        <span id="ap">0</span>
                                    </h4>
                                    <p class="text-muted mb-0">Payable</p>
                                </div>
                                <div class="col-6">
                                    <h4 class="font-weight-normal">
                                        <span id="ar">0</span>
                                    </h4>
                                    <p class="text-muted mb-0">Receivable</p>
                                </div>
                            </div>

                        </div>
                        <!-- end card-body-->
                    </div>
                    <!-- end card-->
                </div>
                    </div>

              <div class="row">
                    <div class="col-lg-6">
                        <div class="card">
                            <div class="card-body">
                                <a  onclick="cardClick(6,'AR Aging Summary')" class="btn btn-sm btn-link float-right mb-3">Details
                                    <i class="mdi mdi-download ml-1"></i>
                                </a>
                                <h4 class="header-title mt-2">AR Aging Summary</h4>

                                <div class="table-responsive" style="overflow: auto; height: 20rem">
                                    <table class="table table-centered table-nowrap table-hover mb-0">
                                        <tbody id="araging" style="overflow: auto">
                                        </tbody>
                                    </table>
                                </div>
                                <!-- end table-responsive-->
                            </div>
                            <!-- end card-body-->
                        </div>
                        <!-- end card-->
                    </div>
                    <!-- end col-->
                  <div class="col-lg-6">
                        <div class="card">
                            <div class="card-body">
                                <a  onclick="cardClick(7,'AP Aging Summary')" class="btn btn-sm btn-link float-right mb-3">Details
                                    <i class="mdi mdi-download ml-1"></i>
                                </a>
                                <h4 class="header-title mt-2">AP Aging Summary</h4>

                                <div class="table-responsive" style="overflow: auto; height: 20rem ">
                                    <table class="table table-centered table-nowrap table-hover mb-0">
                                        <tbody id="apaging" style="overflow: auto">
                                        </tbody>
                                    </table>
                                </div>
                                <!-- end table-responsive-->
                            </div>
                            <!-- end card-body-->
                        </div>
                        <!-- end card-->
                    </div>
                </div>
         

            <div class="row">
                <div class="col-xl-4 col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <a onclick="cardClick(9,'Banks')" class="p-0 float-right mb-3">Data <i class="mdi mdi-download ml-1"></i></a>
                            <h4 class="header-title mt-1">Bank Accounts</h4>

                            <div class="table-responsive" >
                                <table class="table table-sm table-centered mb-0 font-14">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Bank</th>
                                            <th>Balance</th>
                                            <th style="width: 40%;"></th>
                                        </tr>
                                    </thead>
                                    <tbody id="bank" style="overflow:auto">
                                   <%--     <tr>
                                            <td>Banco De Oro</td>
                                            <td>2,050</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar" role="progressbar"
                                                        style="width: 65%; height: 20px;" aria-valuenow="65"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Metrobank</td>
                                            <td>1,405</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar bg-info" role="progressbar"
                                                        style="width: 45%; height: 20px;" aria-valuenow="45"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>UCPB</td>
                                            <td>750</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar bg-warning" role="progressbar"
                                                        style="width: 30%; height: 20px;" aria-valuenow="30"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Chinabank</td>
                                            <td>540</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar bg-danger" role="progressbar"
                                                        style="width: 25%; height: 20px;" aria-valuenow="25"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>--%>
                                    </tbody>
                                </table>
                            </div>
                            <!-- end table-responsive-->
                        </div>
                        <!-- end card-body-->
                    </div>
                    <!-- end card-->
                </div>
                <!-- end col-->

                <div class="col-xl-4 col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <a onclick="cardClick(9,'Budget')" class="p-0 float-right mb-3">Data <i class="mdi mdi-download ml-1"></i></a>
                            <h4 class="header-title mt-1">Expense vs Budget</h4>

                            <div class="table-responsive">
                                <table class="table table-sm table-centered mb-0 font-14">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Cost Center</th>
                                            <th>Expenses</th>
                                            <th style="width: 40%;"></th>
                                        </tr>
                                    </thead>
                                    <tbody id="budget">
                                    <%--    <tr>
                                            <td>Cebu Office</td>
                                            <td>2,250</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar" role="progressbar"
                                                        style="width: 65%; height: 20px;" aria-valuenow="65"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Subic Office</td>
                                            <td>1,501</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar" role="progressbar"
                                                        style="width: 45%; height: 20px;" aria-valuenow="45"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Clark Office</td>
                                            <td>750</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar" role="progressbar"
                                                        style="width: 30%; height: 20px;" aria-valuenow="30"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Manila Office</td>
                                            <td>540</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar" role="progressbar"
                                                        style="width: 25%; height: 20px;" aria-valuenow="25"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>--%>
                                    </tbody>
                                </table>
                            </div>
                            <!-- end table-responsive-->
                        </div>
                        <!-- end card-body-->
                    </div>
                    <!-- end card-->
                </div>
                <!-- end col-->

            
                <!-- end col-->

            </div>
            <!-- end row -->

            </div>
            <!-- container -->


        </div>
        <!-- END wrapper -->
    </form>

        <!-- Common JS -->
    <script src="../js/PerfSender.js" type="text/javascript"></script>


    <!-- bundle -->
    <script src="assets/js/vendor.min.js"></script>
    <script src="assets/js/app.min.js"></script>

    <!-- third party js -->
    <!-- <script src="assets/js/vendor/Chart.bundle.min.js"></script> -->
    <script src="assets/js/vendor/apexcharts.min.js"></script>
    <script src="assets/js/vendor/jquery-jvectormap-1.2.2.min.js"></script>
    <script src="assets/js/vendor/jquery-jvectormap-world-mill-en.js"></script>
    <!-- third party js ends -->

 

    
   <!-- Datatables js -->
    <script src="//cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>
    <script src="assets/js/vendor/dataTables.bootstrap4.js"></script>
    <script src="assets/js/vendor/dataTables.responsive.min.js"></script>
    <script src="assets/js/vendor/responsive.bootstrap4.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>

    <script>

        
      document.addEventListener("DOMContentLoaded", () => {

            $('#daterangetrans').daterangepicker({
                opens: 'center'
            }, function (start, end, label) {
                console.log("A new date selection was made: " + start.format('YYYY-MM-DD') + ' to ' + end.format('YYYY-MM-DD'));
              //  reinitializeWithDateRange(start.format('MM/DD/YYYY'), end.format('MM/DD/YYYY'));
                });
     
          
            $("#dash-period").datepicker({
                format: "M-yyyy",
                viewMode: "months",
                minViewMode: "months",
                autoclose: true
            });

            $('#dash-period').datepicker( 'option' , 'onSelect', function (date) { // 'onSelect' here, but could be any datepicker event
                    //$(this).change(); // Lauch the "change" evenet of the <input> everytime someone click a new date
              
                });

            var strArray=['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

            $.ajax({
                type: "POST",
                data: JSON.stringify({ Code: "BOOKDATE" }),
                url: "/PerformSender.aspx/SS",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    bookdate = result.d;
                    var d = new Date(bookdate);
                    $('#dash-period').val(strArray[d.getMonth()] + '-' + d.getFullYear());

                    var datesd = new Date(bookdate);
                    var dateEd = new Date();

                    $('#daterangetrans').data('daterangepicker').setStartDate(datesd);
                    $('#daterangetrans').data('daterangepicker').setEndDate(dateEd);

                    Dashboard();
                }

            });


        });

        function reinitChart() {

            !(function (i) {
                "use strict";
                function e() {
                    (this.$body = i("body")), (this.charts = []);
                }
                (e.prototype.initCharts = function () {
                    window.Apex = { chart: { parentHeightOffset: 0, toolbar: { show: !1 } }, grid: { padding: { left: 0, right: 0 } }, colors: ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"] };
                    var e = new Date(),
                        t = (function (e, t) {
                            for (var a = new Date(t, e, 1), o = [], r = 0; a.getMonth() === e && r < 15;) {
                                var s = new Date(a);
                                o.push(s.getDate() + " " + s.toLocaleString("en-us", { month: "short" })), a.setDate(a.getDate() + 1), (r += 1);
                            }
                            return o;
                        })(e.getMonth() + 1, e.getFullYear()),
                        a = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"],
                        o = i("#sessions-overview2").data("colors");
                    o && (a = o.split(","));
                    var r = {
                        chart: { height: 309, type: "area" },
                        dataLabels: { enabled: !1 },
                        stroke: { curve: "smooth", width: 4 },
                        series: [{ name: "Cash", data: eval(Total) }],
                        // series: [{ name: "Cash", data: [100,150] }],
                        zoom: { enabled: !1 },
                        legend: { show: !1 },
                        colors: a,
               xaxis: { type: "string", categories: eval(cashdate), tooltip: { enabled: !1 }, axisBorder: { show: !1 }, labels: {} },
            //            xaxis: { type: "string", categories: ['11/23/2020','11/24/2020'], tooltip: { enabled: !1 }, axisBorder: { show: !1 }, labels: {} },
                        yaxis: {
                            labels: {
                                formatter: function (e) {
                                    return e + "";
                                },
                                offsetX: -15,
                            },
                        },
                        fill: { type: "gradient", gradient: { type: "vertical", shadeIntensity: 1, inverseColors: !1, opacityFrom: 0.45, opacityTo: 0.05, stops: [45, 100] } },
                    };
                    new ApexCharts(document.querySelector("#sessions-overview2"), r).render();
                    for (var s = [], n = 10; 1 <= n; n--) s.push(n + " min ago");
                    a = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
                    (o = i("#views-min").data("colors")) && (a = o.split(","));
                    r = {
                        chart: { height: 150, type: "bar", stacked: !0 },
                        plotOptions: { bar: { horizontal: !1, endingShape: "rounded", columnWidth: "22%", dataLabels: { position: "top" } } },
                        dataLabels: { enabled: !0, offsetY: -24, style: { fontSize: "12px", colors: ["#98a6ad"] } },
                        series: [
                            {
                                name: "Views",
                                data: (function (e) {
                                    for (var t = [], a = 0; a < e; a++) t.push(Math.floor(90 * Math.random()) + 10);
                                    return t;
                                })(10),
                            },
                        ],
                        zoom: { enabled: !1 },
                        legend: { show: !1 },
                        colors: a,
                        xaxis: { categories: s, labels: { show: !1 }, axisTicks: { show: !1 }, axisBorder: { show: !1 } },
                        yaxis: { labels: { show: !1 } },
                        fill: { type: "gradient", gradient: { inverseColors: !0, shade: "light", type: "horizontal", shadeIntensity: 0.25, gradientToColors: void 0, opacityFrom: 1, opacityTo: 1, stops: [0, 100, 100, 100] } },
                        tooltip: {
                            y: {
                                formatter: function (e) {
                                    return e;
                                },
                            },
                        },
                    };
                    new ApexCharts(document.querySelector("#views-min"), r).render();
                    a = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
                    (o = i("#sessions-browser").data("colors")) && (a = o.split(","));
                    r = {
                        chart: { height: 343, type: "radar" },
                        series: [{ name: "Usage", data: [80, 50, 30, 40, 60, 20] }],
                        labels: ["Chrome", "Firefox", "Safari", "Opera", "Edge", "Explorer"],
                        plotOptions: { radar: { size: 130, polygons: { strokeColor: "#e9e9e9", fill: { colors: ["#f8f8f8", "#fff"] } } } },
                        colors: a,
                        yaxis: {
                            labels: {
                                formatter: function (e) {
                                    return e + "%";
                                },
                            },
                        },
                        dataLabels: { enabled: !0 },
                        markers: { size: 4, colors: ["#fff"], strokeColor: a[0], strokeWidth: 2 },
                    };
                    new ApexCharts(document.querySelector("#sessions-browser"), r).render();
                    a = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
                    (o = i("#country-chart").data("colors")) && (a = o.split(","));
                    r = {
                        chart: { height: 320, type: "bar" },
                        plotOptions: { bar: { horizontal: !0 } },
                        colors: a,
                        dataLabels: { enabled: !1 },
                        series: [{ name: "Cash", data: [90, 75, 60, 50, 45, 36, 28, 20, 15, 12] }],
                        xaxis: {
                            categories: ["India", "China", "United States", "Japan", "France", "Italy", "Netherlands", "United Kingdom", "Canada", "South Korea"],
                            axisBorder: { show: !1 },
                            labels: {
                                formatter: function (e) {
                                    return e + "%";
                                },
                            },
                        },
                        grid: { strokeDashArray: [5] },
                    };
                    new ApexCharts(document.querySelector("#country-chart"), r).render();
                    a = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
                    (o = i("#sessions-os").data("colors")) && (a = o.split(","));
                    r = {
                        chart: { height: 268, type: "radialBar" },
                        plotOptions: {
                            radialBar: {
                                dataLabels: {
                                    name: { fontSize: "22px" },
                                    value: { fontSize: "16px" },
                                    total: {
                                        show: !0,
                                        label: "AP/AR",
                                        formatter: function (e) {
                                            return '';
                                        },
                                    },
                                },
                            },
                        },
                        colors: a,
                        series: [arp, app],
                        labels: ["Receivables", "Payables"]
                    };
                    new ApexCharts(document.querySelector("#sessions-os"), r).render();
                }),
                    (e.prototype.initMaps = function () {
                        0 < i("#world-map-markers").length &&
                            i("#world-map-markers").vectorMap({
                                map: "world_mill_en",
                                normalizeFunction: "polynomial",
                                hoverOpacity: 0.7,
                                hoverColor: !1,
                                regionStyle: { initial: { fill: "rgba(93,106,120,0.2)" } },
                                series: { regions: [{ values: { KR: "#e6ebff", CA: "#b3c3ff", GB: "#809bfe", NL: "#4d73fe", IT: "#1b4cfe", FR: "#727cf5", JP: "#e7fef7", US: "#e7e9fd", CN: "#8890f7", IN: "#727cf5" }, attribute: "fill" }] },
                                backgroundColor: "transparent",
                                zoomOnScroll: !1,
                            });
                    }),
                    (e.prototype.init = function () {
                        i("#dash-daterange").daterangepicker({ singleDatePicker: !0 }),
                            this.initCharts(),
                            this.initMaps(),
                            window.setInterval(function () {
                                var e = Math.floor(600 * Math.random() + 150);
                                i("#active-users-count").text(e), i("#active-views-count").text(Math.floor(Math.random() * e + 200));
                            }, 2e3);
                    }),
                    (i.AnalyticsDashboard = new e()),
                    (i.AnalyticsDashboard.Constructor = e);
            })(window.jQuery),
                (function () {
                    "use strict";
                    window.jQuery.AnalyticsDashboard.init();
                })();



        
        }

function cardClick(type, title, withselect=0) {
         
            var objDetails = DBData[type];
            if (objDetails.length > 0) {
                  document.getElementById("exampleModalLabel").innerHTML = title;
            $('#TotalAssetmodal').modal("show");

            let tHead = document.createElement("thead");
            let tBody = document.createElement("tbody");// CREATE TABLE BODY .
            let hTr = document.createElement("tr"); // CREATE ROW FOR TABLE HEAD .

                let col = []; // define an empty array
                if (withselect == 1) {
                    col.push('Select');
                }

            for (var i = 0; i < objDetails.length; i++) {
                 
                for (var key in objDetails[i]) {
                    if (col.indexOf(key) === -1) {
                        col.push(key);
                    }
                }
            }


            // ADD COLUMN HEADER TO ROW OF TABLE HEAD.
            for (var i = 0; i < col.length; i++) {
                let th = document.createElement("th");
                th.setAttribute('class', 'th-lg');
                th.scope = "col";
                th.innerHTML = col[i];
                hTr.appendChild(th);
            }
            tHead.appendChild(hTr);


                console.log(col);
            for (var i = 0; i < objDetails.length; i++) {
                let bTr = document.createElement("tr"); // CREATE ROW FOR EACH RECORD .


                for (var j = 0; j < col.length; j++) {

                    if (j == 0 && withselect==1) {
                        let td = document.createElement("td");
                        let ti = document.createElement("input");
                        ti.setAttribute("type", "checkbox");
                       
                        td.appendChild(ti);
                        bTr.appendChild(td);
                    } else {
                        let td = document.createElement("td");

                        if (isNaN(objDetails[i][col[j]]) || objDetails[i][col[j]] == null || objDetails[i][col[j]] == true || objDetails[i][col[j]] == false) {
                            
                           td.innerHTML = objDetails[i][col[j]];
                            if (Object.prototype.toString.call(objDetails[i][col[j]]) === "[object String]" && (objDetails[i][col[j]]).substring((objDetails[i][col[j]]).length-4) === "000Z") {
                                var Dateval = new Date(objDetails[i][col[j]]);
                                td.innerHTML = Dateval.toLocaleDateString();
                                 td.style.textAlign = "center";
                            }
                            else {
                                td.innerHTML = objDetails[i][col[j]];
                                 td.style.textAlign = "left";
                            }
                           
                           
                        } else {
                           
                                  if (tChar.has(col[j])) {
                               
                                 td.innerHTML = objDetails[i][col[j]];
                                 td.style.textAlign = "left";
                            } else {
                                td.innerHTML = numberWithCommas(objDetails[i][col[j]]);
                                td.style.textAlign = "right";
                            }
                            
                          //  alert( objDetails[i][col[j]]);
                        }
                        bTr.appendChild(td);
                    }

                }
                tBody.appendChild(bTr)
            }
            //$('#basic-datatable table thead').remove();
            //$('#basic-datatable table tbody').remove();

           
            if ($.fn.DataTable.isDataTable('#basic-datatable')) {
                $('#basic-datatable').DataTable().destroy();
            }
                $('#basic-datatable').empty();
               

            // document.getElementById("basic-datatable").removeChild();
            $('#basic-datatable').append(tHead);

            $('#basic-datatable').append(tBody);
            $('#basic-datatable').DataTable({
                "orderCellsTop": true,
                "fixedHeader": true,
               
                "scrollX": true,
                "sScrollY": "310px",
                "render": true,
                "pageLength": 5,
                
                "autoWidth": false,
                "columnDefs": [{

                    "searchable": true,
                    "orderable": false,

                }],
                });


            }

          


            let tHead = document.createElement("thead");
            let tBody = document.createElement("tbody");// CREATE TABLE BODY .
            let hTr = document.createElement("tr"); // CREATE ROW FOR TABLE HEAD .

            let col = []; // define an empty array
            for (var i = 0; i < objDetails.length; i++) {
                for (var key in objDetails[i]) {
                    if (col.indexOf(key) === -1) {
                        col.push(key);
                    }
                }
            }


            // ADD COLUMN HEADER TO ROW OF TABLE HEAD.
            for (var i = 0; i < col.length; i++) {
                let th = document.createElement("th");
                th.setAttribute('class', 'th-lg');
                th.scope = "col";
                th.innerHTML = col[i];
                hTr.appendChild(th);
            }
            tHead.appendChild(hTr);



            for (var i = 0; i < objDetails.length; i++) {
                let bTr = document.createElement("tr"); // CREATE ROW FOR EACH RECORD .


     for (var j = 0; j < col.length; j++) {

                    if (j == 0 && withselect==1) {
                        let td = document.createElement("td");
                        let ti = document.createElement("input");
                        ti.setAttribute("type", "checkbox");
                        ti.checked = true;
                        td.appendChild(ti);
                        bTr.appendChild(td);
                    } else {
                        let td = document.createElement("td");

                   if (isNaN(objDetails[i][col[j]]) || objDetails[i][col[j]] == null || objDetails[i][col[j]] == true || objDetails[i][col[j]] == false) {
                            
                           td.innerHTML = objDetails[i][col[j]];
                            if (Object.prototype.toString.call(objDetails[i][col[j]]) === "[object String]" && (objDetails[i][col[j]]).substring((objDetails[i][col[j]]).length-4) === "000Z") {
                                var Dateval = new Date(objDetails[i][col[j]]);
                                td.innerHTML = Dateval.toLocaleDateString();
                                 td.style.textAlign = "center";
                            }
                            else {
                                td.innerHTML = objDetails[i][col[j]];
                                 td.style.textAlign = "left";
                            }
                           
                           
                        } else {
                            if (tChar.has(col[j])) {
                               
                                 td.innerHTML = objDetails[i][col[j]];
                                 td.style.textAlign = "left";
                            } else {
                                td.innerHTML = numberWithCommas(objDetails[i][col[j]]);
                                td.style.textAlign = "right";
                            }
                          //  alert( objDetails[i][col[j]]);
                        }
                        bTr.appendChild(td);
                    }

                }
                tBody.appendChild(bTr)
            }

            $('#basic-datatableexport').empty();
            $('#basic-datatableexport').append(tHead);
            $('#basic-datatableexport').append(tBody);
      





        }

        var ou = 0, ob = 0, ov = 0, arp = 0, app = 0, arap = 0, Total = "[]", cashdate = "[]";
        function Dashboard() {
            let items;

            var vUserID = '<%=Session["userid"] %>';
            var vType = 'DashboardCFO';
            var vParam = $("#dash-period").val();
          //  var vParam = $("#daterangetrans").val();
            var vScheama = '<%=Session["schemaname"] %>';
            var extsession = '<%=Session["token"]%>';
           

            fetch('<%=Session["APIURL"] %>'+"/GetDashboard", {
                method: "POST",
                //body: "{}",
                async: true,
                body: JSON.stringify({ UserID: vUserID, Scheama: vScheama, Type: vType, Param: vParam, session: extsession }),
                headers: {
                    "Content-Type": "application/json"
                },
            }).then(function (response) {
                return response.json()
            }).then(function (data) {
                console.log(data);

                 DBData = data;

                $('#income').text(numberWithCommas(data[0][0].NetIncome));
                $('#cogs').text(numberWithCommas(data[1][0].CostOfGoods));
                $('#expense').text(numberWithCommas(data[2][0].Expenses));
                $('#netprofit').text(numberWithCommas(data[3][0].NetProfit));

                $('#incomeperc').text(numberWithCommas(data[0][0].perc)+"%") ;
                $('#cogsperc').text(numberWithCommas(data[1][0].perc)+"%");
                $('#expenseperc').text(numberWithCommas(data[2][0].perc)+"%");
                $('#netprofitperc').text(numberWithCommas(data[3][0].perc)+"%");

                $('#ar').text(numberWithCommas((data[5][0].TotalAmount-data[5][0].TotalApplied).toFixed(2)));
                $('#ap').text(numberWithCommas((data[5][1].TotalAmount-data[5][1].TotalApplied).toFixed(2)));
                arp = data[5][0].Perc;
                app = data[5][1].Perc;

                 var table = ""
                for (var i = 0; i < data[6].length; i++) {



                    table += " <tr> ";
                    table += "     <td> ";
                    table += "         <h5 class='font - 14 my - 1 font - weight - normal'>" + data[6][i].CustomerCode + "</h5> ";
                    table += "         <span class='text - muted font - 13'>Terms: " + data[6][i].Terms + " Days</span> ";
                    table += "     </td> ";
                    table += "     <td> ";
                    table += "         <h5 class='font - 14 my - 1 font - weight - normal'>" + data[6][i].CustomerName.substring(0, 15); + "</h5> ";
                    table += "         <span class='text - muted font - 13'>Customer</span> ";
                    table += "     </td> ";
                    table += "     <td> ";
                    table += "         <h5 class='font - 14 my - 1 font - weight - normal'>Php " + numberWithCommas(data[6][i].ARTotal.toFixed(2)) + "</h5> ";
                    table += "         <span class='text - muted font - 13'>Total AR</span> ";
                    table += "     </td> ";
                    table += "     <td> ";
                    table += "         <h5 class='font - 14 my - 1 font - weight - normal'>Php " + numberWithCommas(data[6][i].Checks.toFixed(2)) + "</h5> ";
                    table += "         <span class='text - muted font - 13'>Post Dated Checks</span> ";
                    table += "     </td> ";
                    table += " </tr> ";

                }
                $('#araging').empty();

                $('#araging').append(table);
                 var table = ""
                                var APTotal = 0
                for (var i = 0; i < data[7].length; i++) {

                    

                    table += " <tr> ";
                    table += "     <td> ";
                    table += "         <h5 class='font - 14 my - 1 font - weight - normal'>"+data[7][i].Code.substring(0, 15)+"</h5> ";
                    table += "         <span class='text - muted font - 13'>Terms: "+data[7][i].Terms+" Days</span> ";
                    table += "     </td> ";
                    table += "     <td> ";
                    table += "         <h5 class='font - 14 my - 1 font - weight - normal'>Php "+ numberWithCommas(data[7][i].APTotal.toFixed(2))+"</h5> ";
                    table += "         <span class='text - muted font - 13'>Total AP</span> ";
                    table += "     </td> ";
                    table += "     <td> ";
                    table += "         <h5 class='font - 14 my - 1 font - weight - normal'>Php "+numberWithCommas(data[7][i].APTotal.toFixed(2))+"</h5> ";
                    table += "         <span class='text - muted font - 13'>Post Dated Checks</span> ";
                    table += "     </td> ";
                    table += " </tr> ";

                

                }
                $('#apaging').empty();
                $('#apaging').append(table);


                var table = "";
                  for (var i = 0; i < data[8].length; i++) {


                    table += " <tr> ";
                    table += " <td>"+data[8][i].Description+"</td> ";
                    table += " <td>"+numberWithCommas(data[8][i].Balance)+"</td> ";
                    table += " <td> ";
                    table += " <div class='progress' style='height: 3px;'> ";
                    table += " <div class='progress-bar' role='progressbar' ";
                    table += " style='width: "+data[8][i].Prc+"%; height: 20px;' aria-valuenow='"+data[8][i].Prc+"' ";
                    table += " aria-valuemin='0' aria-valuemax='100'> ";
                    table += "  </div> ";
                    table += "  </div> ";
                    table += " </td> ";table += " </tr> ";

                }
                 $('#bank').empty();
                $('#bank').append(table);

                 var table = "";
                  for (var i = 0; i < data[9].length; i++) {

                      var max = data[9][i].Perc > 100 ? 100 : data[9][i].Perc;
                     

                    table += " <tr> ";
                    table += " <td>"+data[9][i].Description+"</td> ";
                    table += " <td>"+numberWithCommas(data[9][i].Expense)+"</td> ";
                    table += " <td> ";
                    table += " <div class='progress' style='height: 3px;'> ";
                    table += " <div class='progress-bar' role='progressbar' ";
                    table += " style='width: "+data[9][i].Perc+"%; height: 20px;' aria-valuenow='"+data[9][i].Perc+"' ";
                    table += " aria-valuemin='0' aria-valuemax='"+max+"'> ";
                    table += "  </div> ";
                    table += "  </div> ";
                    table += " </td> ";table += " </tr> ";

                }
                $('#budget').empty();
                $('#budget').append(table);

               
                  var table = "";
                  for (var i = 0; i < data[9].length; i++) {

                      var max = data[9][i].Perc > 100 ? 100 : data[9][i].Perc;
                     

                    table += " <tr> ";
                    table += " <td>"+data[9][i].Description+"</td> ";
                    table += " <td>"+numberWithCommas(data[9][i].Expense)+"</td> ";
                    table += " <td> ";
                    table += " <div class='progress' style='height: 3px;'> ";
                    table += " <div class='progress-bar' role='progressbar' ";
                    table += " style='width: "+data[9][i].Perc+"%; height: 20px;' aria-valuenow='"+data[9][i].Perc+"' ";
                    table += " aria-valuemin='0' aria-valuemax='"+max+"'> ";
                    table += "  </div> ";
                    table += "  </div> ";
                    table += " </td> ";table += " </tr> ";

                }
                $('#sales').empty();
                $('#sales').append(table);
           
                 
                
                
                received = "[" 
                order = "[" 
                armonth = "["
                for (var i = 0; i < data[4].length; i++) {
                    received += data[4][i].ReceivedQty
                    order += (data[4][i].OrderQty )
                    armonth += "'"+data[4][i].Month+"'"
                    if (data[4].length > i + 1) {
                        received += ", "
                        order += ", "
                        armonth +=", "
                    }

                }

                received += "]"
                order += "]" 
                armonth += "]"

                e = ["#727cf5", "#e3eaef"];
                (t = $("#high-performing-product2").data("colors")) && (e = t.split(","));
                r = {
                    chart: { height: 257, type: "bar", stacked: !0 },
                    plotOptions: { bar: { horizontal: !1, columnWidth: "20%" } },
                    dataLabels: { enabled: !1 },
                    stroke: { show: !0, width: 2, colors: ["transparent"] },
                    series: [
                        //{ name: "Collected", data: [65, 59, 80, 81, 56, 89, 40, 32, 65, 59, 80, 81] },
                        //{ name: "Receivables", data: [89, 40, 32, 65, 59, 80, 81, 56, 89, 40, 65, 59] },
                        { name: "Expenses", data: eval(received) },
                        { name: "Income", data: eval(order) },
                    ],
                    zoom: { enabled: !1 },
                    legend: { show: !1 },
                    colors: e,
                    //xaxis: { categories: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"], axisBorder: { show: !1 } },
                    xaxis: { categories: eval(armonth), axisBorder: { show: !1 } },
                    yaxis: {
                        labels: {
                            formatter: function (e) {
                                return e + "";
                            },
                            offsetX: -15,
                        },
                    },
                    fill: { opacity: 1 },
                    tooltip: {
                        y: {
                            formatter: function (e) {
                                return "" + e + "";
                            },
                        },
                    },
                };
                new ApexCharts(document.querySelector("#high-performing-product2"), r).render();


              

       
              
                
                 reinitChart();


            }

            ).catch(function (error) {
                console.log(error);
            })
        
    }



    </script>

</body>
</html>
