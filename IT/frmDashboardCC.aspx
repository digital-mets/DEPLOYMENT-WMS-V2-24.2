<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDashboardCC.aspx.cs" Inherits="GWL.IT.frmDashboardCC" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
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

                <div class="row ">
                     <div class="col-lg-12">
                        <div class="page-title-box">
                            <div class="page-title-right">
                                <div class="form-inline">
                                    <div class="form-group">
                                          <div class="input-group" style="display:none">
                                            <input type="text" class="form-control form-control-light" id="dash-period"  />
                                            <div class="input-group-append">
                                                <span class="input-group-text bg-primary border-primary text-white">
                                                    <i class="mdi mdi-calendar-range font-13"></i>
                                                </span>
                                            </div>
                                        </div>

                                       <div class="input-group date" >
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
                            <h4 class="page-title">Credit and Collection</h4>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="card widget-inline">
                            <div class="card-body p-0">
                                <div class="row no-gutters">
                                    <div class="col-sm-6 col-xl-3">
                                        <a  onclick="cardClick(0,'Unallocated Receipts')" data-toggle="modal" style="cursor: pointer;">
                                        <div class="card shadow-none m-0">
                                            <div class="card-body text-center">
                                                <i class="dripicons-briefcase text-info" style="font-size: 24px;"></i>
                                                <h3><span id="unallocrec">0</span></h3>
                                                <p class="text-muted font-15 mb-0">Unallocated Receipt</p>
                                            </div>
                                        </div>
                                            </a>
                                    </div>

                                    <div class="col-sm-6 col-xl-3">
                                        <a  onclick="cardClick(1,'Unidentified Receipt')" data-toggle="modal" style="cursor: pointer;">
                                        <div class="card shadow-none m-0 border-left">
                                            <div class="card-body text-center">
                                                <i class="dripicons-checklist text-danger" style="font-size: 24px;"></i>
                                                <h3><span id="unidetrec">0</span></h3>
                                                <p class="text-muted font-15 mb-0">Unidentified Receipt</p>
                                            </div>
                                        </div>
                                            </a>
                                    </div>

                                    <div class="col-sm-6 col-xl-3">
                                        <a  onclick="cardClick(2,'Unposted Receipt')" data-toggle="modal" style="cursor: pointer;">
                                        <div class="card shadow-none m-0 border-left">
                                            <div class="card-body text-center">
                                                <i class="dripicons-user-group text-info" style="font-size: 24px;"></i>
                                                <h3><span id="unprec">0</span></h3>
                                                <p class="text-muted font-15 mb-0">Unposted Receipt</p>
                                            </div>
                                        </div>
                                            </a>
                                    </div>

                                   <div class="col-sm-6 col-xl-3">
                                       <a  onclick="cardClick(7,'Days of Receivable Outstanding')" data-toggle="modal" style="cursor: pointer;">
                                        <div class="card shadow-none m-0 border-left">
                                            <div class="card-body text-center">
                                                <i class=" dripicons-calendar  text-warning" style="font-size: 24px;"></i>
                                                <h3><span id="dro">0</span></h3>
                                                <p class="text-muted font-15 mb-0">Days of Receivable Oustanding</p>
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
                    <!-- end col-->
                </div>
                <!-- end row-->


                <div class="row">
                    <div class="col-lg-4">
                        <div class="card">
                            <div class="card-body">
                                <div class="dropdown float-right">
                                    <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                        <i class="mdi mdi-dots-vertical"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Weekly Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Monthly Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                    </div>
                                </div>
                                <h4 class="header-title mb-4">Collection</h4>

                                <div class="my-4 chartjs-chart" style="height: 202px;">
                                    <canvas id="project-status-chart2" data-colors="#0acf97,#727cf5,#fa5c7c"></canvas>
                                </div>

                                <div class="row text-center mt-2 py-2">
                                    <div class="col-4">
                                        <i class="mdi mdi-trending-up text-success mt-3 h3"></i>
                                        <h3 class="font-weight-normal">
                                            <span id="ob">0</span>
                                        </h3>
                                        <p class="text-muted mb-0">Collected</p>
                                    </div>
                                    <div class="col-4">
                                        <i class="mdi mdi-trending-down text-primary mt-3 h3"></i>
                                        <h3 class="font-weight-normal">
                                            <span id ="ou">0</span>
                                        </h3>
                                        <p class="text-muted mb-0">Receivables</p>
                                    </div>
                                    <div class="col-4">
                                        <i class="mdi mdi-trending-down text-danger mt-3 h3"></i>
                                        <h3 class="font-weight-normal">
                                            <span id="ov">0</span>
                                        </h3>
                                        <p class="text-muted mb-0">Overdue</p>
                                    </div>
                                </div>
                                <!-- end row-->

                            </div>
                            <!-- end card body-->
                        </div>
                        <!-- end card -->
                    </div>
                    <!-- end col-->

                     <div class="col-xl-8  col-lg-8">
                        <div class="card">
                            <div class="card-body">
                                <div class="dropdown float-right">
                                    <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                        <i class="mdi mdi-dots-vertical"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Sales Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Export Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Profit</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                    </div>
                                </div>
                                <h4 class="header-title mb-3">Collection vs Receivables</h4>

                                <div id="inv-col" class="apex-charts"
                                    data-colors="#727cf5,#e3eaef">
                                </div>

                            </div>
                            <!-- end card-body-->
                        </div>
                        <!-- end card-->

                    </div>
                  
                    <!-- end col-->
                </div>
                <!-- end row-->


            


                <div class="row">
                    <div class="col-xl-5">
                        <div class="card">
                            <div class="card-body">
                                <div class="dropdown float-right">
                                    <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                        <i class="mdi mdi-dots-vertical"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Weekly Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Monthly Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                    </div>
                                </div>
                                <h4 class="header-title mb-3">Accounts Receivables</h4>

                                <div class="table-responsive" style="overflow:auto; height:20rem">
                                    <table class="table table-centered table-nowrap table-hover mb-0">
                                        <tbody id="aging" style="overflow:auto">
                                          <%--  <tr>
                                                <td>
                                                    <div class="media">
                                                        <img class="mr-2 rounded-circle" src="assets/images/users/avatar-2.jpg" width="40" alt="Generic placeholder image">
                                                        <div class="media-body">
                                                            <h5 class="mt-0 mb-1">Customer 1<small class="font-weight-normal ml-3">18 Jan 2019 11:28 pm</small></h5>
                                                            <span class="font-13">Completed "Design new idea"...</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Amount</span>
                                                    <br />
                                                    <p class="mb-0">1.1M</p>
                                                </td>
                                                <td class="table-action" style="width: 50px;">
                                                    <div class="dropdown">
                                                        <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                                            <i class="mdi mdi-dots-horizontal"></i>
                                                        </a>
                                                        <div class="dropdown-menu dropdown-menu-right">
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>
                                                    <div class="media">
                                                        <img class="mr-2 rounded-circle" src="assets/images/users/avatar-6.jpg" width="40" alt="Generic placeholder image">
                                                        <div class="media-body">
                                                            <h5 class="mt-0 mb-1">Customer 2<small class="font-weight-normal ml-3">18 Jan 2019 11:09 pm</small></h5>
                                                            <span class="font-13">Assigned task "Poster illustation design"...</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Amount</span>
                                                    <br />
                                                    <p class="mb-0">2M</p>
                                                </td>
                                                <td class="table-action" style="width: 50px;">
                                                    <div class="dropdown">
                                                        <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                                            <i class="mdi mdi-dots-horizontal"></i>
                                                        </a>
                                                        <div class="dropdown-menu dropdown-menu-right">
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>
                                                    <div class="media">
                                                        <img class="mr-2 rounded-circle" src="assets/images/users/avatar-3.jpg" width="40" alt="Generic placeholder image">
                                                        <div class="media-body">
                                                            <h5 class="mt-0 mb-1">Customer 3<small class="font-weight-normal ml-3">15 Jan 2019 09:29 pm</small></h5>
                                                            <span class="font-13">Completed "Drinking bottle graphics"...</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Amount</span>
                                                    <br />
                                                    <p class="mb-0">335K</p>
                                                </td>
                                                <td class="table-action" style="width: 50px;">
                                                    <div class="dropdown">
                                                        <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                                            <i class="mdi mdi-dots-horizontal"></i>
                                                        </a>
                                                        <div class="dropdown-menu dropdown-menu-right">
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>
                                                    <div class="media">
                                                        <img class="mr-2 rounded-circle" src="assets/images/users/avatar-4.jpg" width="40" alt="Generic placeholder image">
                                                        <div class="media-body">
                                                            <h5 class="mt-0 mb-1">Customer 4<small class="font-weight-normal ml-3">10 Jan 2019 08:36 pm</small></h5>
                                                            <span class="font-13">Completed "Design new idea"...</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Amount</span>
                                                    <br />
                                                    <p class="mb-0">100K</p>
                                                </td>
                                                <td class="table-action" style="width: 50px;">
                                                    <div class="dropdown">
                                                        <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                                            <i class="mdi mdi-dots-horizontal"></i>
                                                        </a>
                                                        <div class="dropdown-menu dropdown-menu-right">
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>
                                                    <div class="media">
                                                        <img class="mr-2 rounded-circle" src="assets/images/users/avatar-5.jpg" width="40" alt="Generic placeholder image">
                                                        <div class="media-body">
                                                            <h5 class="mt-0 mb-1">Customer 5<small class="font-weight-normal ml-3">08 Jan 2019 12:28 pm</small></h5>
                                                            <span class="font-13">Assigned task "Hyper app design"...</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Amount</span>
                                                    <br />
                                                    <p class="mb-0">10K</p>
                                                </td>
                                                <td class="table-action" style="width: 50px;">
                                                    <div class="dropdown">
                                                        <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                                            <i class="mdi mdi-dots-horizontal"></i>
                                                        </a>
                                                        <div class="dropdown-menu dropdown-menu-right">
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>--%>

                                        </tbody>
                                    </table>
                                </div>
                                <!-- end table-responsive-->

                            </div>
                            <!-- end card body-->
                        </div>
                        <!-- end card -->
                    </div>
                    <!-- end col-->

                   <div class="col-xl-7 col-lg-7">
                    <div class="card">
                        <div class="card-body">
                            <a onclick="cardClick(5,'Aging Summary')" class="p-0 float-right mb-3">Details <i class="mdi mdi-download ml-1"></i></a>
                            <h4 class="header-title mt-1">Aging Analysis</h4>

                            <div class="table-responsive">
                                <table class="table table-sm table-centered mb-0 font-14">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Days</th>
                                            <th>Receivable</th>
                                            <th style="width: 40%;"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>0-30</td>
                                            <td id="Day1to30">0</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div id="Day1to30p" class="progress-bar" role="progressbar"
                                                        style="width: 0%; height: 20px;" aria-valuenow="0"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>31-60</td>
                                            <td id="Day31to60">0</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div id="Day31to60p" class="progress-bar" role="progressbar"
                                                        style="width: 0%; height: 20px;" aria-valuenow="0"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>61-90</td>
                                            <td id="Day61to90">0</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div id="Day61to90p" class="progress-bar" role="progressbar"
                                                        style="width: 0%; height: 20px;" aria-valuenow="0"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>91-120</td>
                                            <td id="Day91to120">0</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div id="Day91to120p" class="progress-bar" role="progressbar"
                                                        style="width: 0%; height: 20px;" aria-valuenow="0"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                         <tr>
                                            <td>121-150</td>
                                            <td id="Day121to150">0</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div id="Day121to150p" class="progress-bar" role="progressbar"
                                                        style="width: 0%; height: 20px;" aria-valuenow="0"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                      <tr>
                                            <td>151-180</td>
                                            <td id="Day151to180">0</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div id="Day151to180p" class="progress-bar" role="progressbar"
                                                        style="width: 0%; height: 20px;" aria-valuenow="0"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                       <tr>
                                            <td>180 or More</td>
                                            <td id="Day181More">0</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div id="Day181Morep" class="progress-bar" role="progressbar"
                                                        style="width: 0%; height: 20px;" aria-valuenow="0"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
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

                </div>
                <!-- end row-->


            </div>
            <!-- container -->


        </div>
        <!-- END wrapper -->
    </form>

        <!-- Common JS -->
    <script src="../js/PerfSender.js" type="text/javascript"></script>

    
    <script src="assets/js/vendor.min.js"></script>
    <script src="assets/js/app.min.js"></script>

    <!-- third party js -->
    <script src="assets/js/vendor/Chart.bundle.min.js"></script>
        <script src="assets/js/vendor/apexcharts.min.js"></script>
    <script src="assets/js/vendor/jquery-jvectormap-1.2.2.min.js"></script>
    <script src="assets/js/vendor/jquery-jvectormap-world-mill-en.js"></script>
    <!-- third party js ends -->

    <!-- demo app -->

    <!-- end demo js-->



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
            
            var t,
                r,
                databill,
                e = [];
            databill = {
                    labels: ["Open", "Partial", "Behind"],
                    datasets: [{ data: [64, 26, 10], backgroundColor: (r = $("#project-status-chart2").data("colors")) ? r.split(",") : ["#0acf97", "#727cf5", "#fa5c7c"], borderColor: "transparent", borderWidth: "3" }]
                 }
             
          //  respChart($("#project-status-chart2"), "Doughnut", databill, { maintainAspectRatio: !1, cutoutPercentage: 80, legend: { display: !1 } })
                
            reinitChart();

            $("#dash-period").datepicker({
                format: "M-yyyy",
                viewMode: "months",
                minViewMode: "months",
                autoclose: true
            });

            $('#dash-period').datepicker( 'option' , 'onSelect', function (date) { // 'onSelect' here, but could be any datepicker event
                    //$(this).change(); // Lauch the "change" evenet of the <input> everytime someone click a new date
                alert('test');
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
                    $('#dash-period').val(strArray[d.getMonth()-1] + '-' + d.getFullYear());

                    var datesd = new Date(bookdate);
                    var dateEd = new Date();

                    $('#daterangetrans').data('daterangepicker').setStartDate(datesd);
                    $('#daterangetrans').data('daterangepicker').setEndDate(dateEd);

               //     Dashboard();
                }

            });


        });

        function reinitChart() {
            !(function (o) {
    function t() {
        (this.$body = o("body")), (this.charts = []);
    }
    (t.prototype.respChart = function (r, a, e, n) {
        (Chart.defaults.global.defaultFontColor = "#8391a2"), (Chart.defaults.scale.gridLines.color = "#8391a2");
        var i = r.get(0).getContext("2d"),
            s = o(r).parent();
        return (function () {
            var t;
            switch ((r.attr("width", o(s).width()), a)) {
                case "Line":
                    t = new Chart(i, { type: "line", data: e, options: n });
                    break;
                case "Bar":
                    t = new Chart(i, { type: "bar", data: e, options: n });
                    break;
                case "Doughnut":
                    t = new Chart(i, { type: "doughnut", data: e, options: n });
            }
            return t;
        })();
    }),
        (t.prototype.initCharts = function () {
            var t,
                r,
                a,
                e = [];
            return (
                
                0 < o("#project-status-chart2").length &&
                ((a = {
                    labels: ["Collected", "Receivable", "Overdue"],
                    datasets: [{ data: [ob, ou, ov], backgroundColor: (r = o("#project-status-chart2").data("colors")) ? r.split(",") : ["#0acf97", "#727cf5", "#fa5c7c"], borderColor: "transparent", borderWidth: "3" }],
                }),
                    e.push(this.respChart(o("#project-status-chart2"), "Doughnut", a, { maintainAspectRatio: !1, cutoutPercentage: 80, legend: { display: !1 } }))),
                e
            );
        }),
        (t.prototype.init = function () {
            var r = this;
            (Chart.defaults.global.defaultFontFamily = '-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif'),
                (r.charts = this.initCharts()),
                o(window).on("resize", function (t) {
                    o.each(r.charts, function (t, r) {
                        try {
                            r.destroy();
                        } catch (t) { }
                    }),
                        (r.charts = r.initCharts());
                });
        }),
        (o.ChartJs = new t()),
        (o.ChartJs.Constructor = t);
})(window.jQuery),
    (function () {
        "use strict";
        window.jQuery.ChartJs.init();
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


           var ou=0, ob=0, ov=0;
        function Dashboard() {
            let items;

            var vUserID = '<%=Session["userid"] %>';
            var vType = 'DashboardCC';
           // var vParam = $("#dash-period").val();
            var vParam = $("#daterangetrans").val();
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

                $('#unallocrec').text(numberWithCommas(data[0].length));
                $('#unidetrec').text(numberWithCommas(data[1].length));
                $('#unprec').text(numberWithCommas(data[2].length));

                $('#dro').text(numberWithCommas(data[7][0].dro));
                var arcollected = "[" 
                var arreceivable = "[" 
                var armonth = "["
                for (var i = 0; i < data[4].length; i++) {
                    arcollected += data[4][i].Collected
                    arreceivable += data[4][i].Receivable
                    armonth += "'"+data[4][i].Month+"'"
                    if (data[4].length > i + 1) {
                        arcollected += ", "
                        arreceivable += ", "
                        armonth +=", "
                    }

                }

                arcollected += "]"
                arreceivable += "]" 
                armonth +="]"

                
                e = ["#727cf5", "#e3eaef"];
                (t = $("#inv-col").data("colors")) && (e = t.split(","));
                r = {
                    chart: { height: 355, type: "bar", stacked: !0 },
                    plotOptions: { bar: { horizontal: !1, columnWidth: "20%" } },
                    dataLabels: { enabled: !1 },
                    stroke: { show: !0, width: 2, colors: ["transparent"] },
                    series: [
                        //{ name: "Collected", data: [65, 59, 80, 81, 56, 89, 40, 32, 65, 59, 80, 81] },
                        //{ name: "Receivables", data: [89, 40, 32, 65, 59, 80, 81, 56, 89, 40, 65, 59] },
                        { name: "Collected", data: eval(arcollected) },
                        { name: "Receivables", data: eval(arreceivable) },
                    ],
                    zoom: { enabled: !1 },
                    legend: { show: !1 },
                    colors: e,
                    //xaxis: { categories: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"], axisBorder: { show: !1 } },
                    xaxis: { categories: eval(armonth), axisBorder: { show: !1 } },
                    yaxis: {
                        labels: {
                            formatter: function (e) {
                                return e + "k";
                            },
                            offsetX: -15,
                        },
                    },
                    fill: { opacity: 1 },
                    tooltip: {
                        y: {
                            formatter: function (e) {
                                return "Php" + e + "k";
                            },
                        },
                    },
                };
                new ApexCharts(document.querySelector("#inv-col"), r).render();

                var table = ""

                var	Day1to30	=0
                var	Day31to60	=0
                var	Day61to90	=0
                var	Day91to120	=0
                var	Day121to150	=0
                var	Day151to180	=0
                var	Day181More	=0

                var ARTotal = 0
                for (var i = 0; i < data[5].length; i++) {

                    

                    //table += " <tr> ";
                    //table += "     <td> ";
                    //table += "         <h5 class='font - 14 my - 1 font - weight - normal'>"+data[5][i].Code+"</h5> ";
                    //table += "         <span class='text - muted font - 13'>Terms: "+data[5][i].Terms+" Days</span> ";
                    //table += "     </td> ";
                    //table += "     <td> ";
                    //table += "         <h5 class='font - 14 my - 1 font - weight - normal'>Php "+data[5][i].ARTotal.toFixed(2)+"</h5> ";
                    //table += "         <span class='text - muted font - 13'>Total AP</span> ";
                    //table += "     </td> ";
                    //table += "     <td> ";
                    //table += "         <h5 class='font - 14 my - 1 font - weight - normal'>Php "+data[5][i].ARTotal.toFixed(2)+"</h5> ";
                    //table += "         <span class='text - muted font - 13'>Post Dated Checks</span> ";
                    //table += "     </td> ";
                    //table += " </tr> ";

                    table += " <tr> ";
                    table += " <td> ";
                    table += " <div class='media'> ";
                    table += " <img class='mr-2 rounded-circle' src='./assets/images/users/user.png' width='40' alt=''> ";
                    table += " <div class='media-body'> ";
                    table += " <h5 class='mt-0 mb-1'> "+data[5][i].CustomerCode+" <small class='font-weight-normal ml-3'>18 Jan 2019 11:28 pm</small></h5> ";
                    table += " <span class='font-13'> "+data[5][i].CustomerName+" </span> ";
                    table += " </div> ";
                    table += " </div> ";
                    table += " </td> ";
                    table += " <td> ";
                    table += " <p class='text-muted font-13' style='text-align:right'>Amount</p> ";

                    table += " <p class='mb-0' style='text-align:right'>"+numberWithCommas(data[5][i].ARTotal.toFixed(2))+"</p> ";
                    table += " </td> ";
                    table += " <td class='table-action' style='width: 50px;'> ";
                    table += " <div class='dropdown'>  ";
                    table += " <a href='#' class='dropdown-toggle arrow-none card-drop' data-toggle='dropdown' aria-expanded='false'>  ";
                    table += " <i class='mdi mdi-dots-horizontal'></i>  ";
                    table += " </a>  ";
                    table += " <div class='dropdown-menu dropdown-menu-right'>  ";
                    table += " <!-- item-->  ";
                    table += " <a href='javascript:void(0);' class='dropdown-item'>Settings</a>  ";
                    table += " <!-- item-->  ";
                    table += " <a href='javascript:void(0);' class='dropdown-item'>Action</a> ";
                    table += " </div> ";
                    table += " </div> ";
                    table += " </td> ";
                    table += " </tr> ";






                    Day1to30	+=	data[5][i].Day1to30
                    Day31to60	+=	data[5][i].Day31to60
                    Day61to90	+=	data[5][i].Day61to90
                    Day91to120	+=	data[5][i].Day91to120
                    Day121to150	+=	data[5][i].Day121to150
                    Day151to180	+=	data[5][i].Day151to180
                    Day181More	+=	data[5][i].Day180
                    ARTotal     +=  data[5][i].ARTotal

                }
                 $('#aging').empty();
                $('#aging').append(table);

                
                document.getElementById("Day1to30").innerHTML = numberWithCommas(Day1to30.toFixed(2));
                document.getElementById("Day31to60").innerHTML = numberWithCommas(Day31to60.toFixed(2));
                document.getElementById("Day61to90").innerHTML = numberWithCommas(Day61to90.toFixed(2));
                document.getElementById("Day91to120").innerHTML = numberWithCommas(Day91to120.toFixed(2));
                document.getElementById("Day121to150").innerHTML = numberWithCommas(Day121to150.toFixed(2));
                document.getElementById("Day151to180").innerHTML = numberWithCommas(Day151to180.toFixed(2));
                document.getElementById("Day181More").innerHTML = numberWithCommas(Day181More.toFixed(2));


                bar = document.getElementById('Day1to30p');
                bar.setAttribute('aria-valuenow', ((Day1to30 / ARTotal)*100));
                bar.setAttribute('aria-valuemax', ARTotal);
                bar.style.width = ((Day1to30 / ARTotal) * 100) + "%";

                bar = document.getElementById('Day31to60p');
                bar.setAttribute('aria-valuenow', ((Day31to60 / ARTotal)*100));
                bar.setAttribute('aria-valuemax', ARTotal);
                bar.style.width = ((Day31to60 / ARTotal) * 100) + "%";

                bar = document.getElementById('Day61to90p');
                bar.setAttribute('aria-valuenow', ((Day61to90 / ARTotal)*100));
                bar.setAttribute('aria-valuemax', ARTotal);
                bar.style.width = ((Day61to90 / ARTotal) * 100) + "%";

                bar = document.getElementById('Day91to120p');
                bar.setAttribute('aria-valuenow', ((Day91to120 / ARTotal)*100));
                bar.setAttribute('aria-valuemax', ARTotal);
                bar.style.width = ((Day91to120 / ARTotal) * 100) + "%";

                bar = document.getElementById('Day121to150p');
                bar.setAttribute('aria-valuenow', ((Day121to150 / ARTotal)*100));
                bar.setAttribute('aria-valuemax', ARTotal);
                bar.style.width = ((Day121to150 / ARTotal) * 100) + "%";                

                bar = document.getElementById('Day151to180p');
                bar.setAttribute('aria-valuenow', ((Day151to180 / ARTotal)*100));
                bar.setAttribute('aria-valuemax', ARTotal);
                bar.style.width = ((Day151to180 / ARTotal) * 100) + "%";  

                bar = document.getElementById('Day181Morep');
                bar.setAttribute('aria-valuenow', ((Day181More / ARTotal)*100));
                bar.setAttribute('aria-valuemax', ARTotal);
                bar.style.width = ((Day181More / ARTotal) * 100) + "%";  


               for (var i = 0; i < data[3].length; i++) {
                   
                   ob = data[3][i].Collected;
                   ou = data[3][i].Receivable;
                   ov = data[3][i].Overdue;

                   $('#ob').text(numberWithCommas(ob));
                   $('#ou').text(numberWithCommas(ou));
                   $('#ov').text(numberWithCommas(ov));

                }
               
                reinitChart();
            }

            ).catch(function (error) {
                console.log(error);
            })
        
    }


    </script>




</body>
</html>
