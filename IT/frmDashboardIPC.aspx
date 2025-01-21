<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDashboardIPC.aspx.cs" Inherits="GWL.IT.frmDashboardIPC" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
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
                       
                        <table runat="server" id="basicdatatable" class="table dt-responsive nowrap w-100">
                        </table>
                        <table  id="basic-datatableexport" style="display:none" >
                        </table>
                       
                         

                    </div>
                    <div class="modal-footer">
                          <button onclick="CreatePR(); " type="button" class="btn btn-warning" >Create PR</button>
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
                                        <div class="input-group">
                                            <input type="text" class="form-control form-control-light" id="dash-period" />
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
                            <h4 class="page-title">Inventory Planning and Control</h4>
                        </div>
                    </div>
                    <div class="col-lg-6 col-xl-3">
                        <div class="card">
                            <div class="card-body">
                                  <a  onclick="cardClick(0,'Material Request')" data-toggle="modal" style="cursor: pointer;">
                                <div class="row align-items-center">
                                    <div class="col-6">
                                        <h5 class="text-muted font-weight-normal mt-0 text-truncate" title="Open Material Request">Open Material Request</h5>
                                        <h3 class="my-2 py-1" id="omr">0</h3>
                                        <p class="mb-0 text-muted">
                                            <span class="text-success mr-2"><i class="mdi mdi-arrow-up-bold"></i> 0 new Request</span>
                                        </p>
                                    </div>
                                    <div class="col-6">
                                        <div class="text-right">
                                            <div id="campaign-sent-chart" data-colors="#727cf5"></div>
                                        </div>
                                    </div>
                                </div> <!-- end row-->
                                      </a>
                            </div> <!-- end card-body -->
                        </div> <!-- end card -->
                    </div> <!-- end col -->

                    <div class="col-lg-6 col-xl-3">
                        <div class="card">
                            <div class="card-body">
                                 <a  onclick="cardClick(1,'Purchase Request')" data-toggle="modal" style="cursor: pointer;">
                                <div class="row align-items-center">
                                    <div class="col-6">
                                        <h5 class="text-muted font-weight-normal mt-0 text-truncate" title="Open Purchase Request">Open Purchase Request</h5>
                                        <h3 class="my-2 py-1" id="opr">0</h3>
                                        <p class="mb-0 text-muted">
                                            <span class="text-danger mr-2"><i class="mdi mdi-arrow-down-bold"></i> 0 Late on target</span>
                                        </p>
                                    </div>
                                    <div class="col-6">
                                        <div class="text-right">
                                            <div id="new-leads-chart" data-colors="#0acf97"></div>
                                        </div>
                                    </div>
                                </div> <!-- end row-->
                                     </a>
                            </div> <!-- end card-body -->
                        </div> <!-- end card -->
                    </div> <!-- end col -->

                    <div class="col-lg-6 col-xl-3">
                        <div class="card">
                            <div class="card-body">
                                 <a  onclick="cardClick(2,'Purchase Order')" data-toggle="modal" style="cursor: pointer;">
                                <div class="row align-items-center">
                                    <div class="col-6">
                                        <h5 class="text-muted font-weight-normal mt-0 text-truncate" title="Spice Request">Open Spice Request</h5>
                                        <h3 class="my-2 py-1" id="po">0</h3>
                                        <p class="mb-0 text-muted">
                                            <span class="text-info mr-2">0 Items</span>
                                        </p>
                                    </div>
                                    <div class="col-6">
                                        <div class="text-right">
                                            <div id="deals-chart" data-colors="#727cf5"></div>
                                        </div>
                                    </div>
                                </div> <!-- end row-->
                                     </a>
                            </div> <!-- end card-body -->
                        </div> <!-- end card -->
                    </div> <!-- end col -->

                    <div class="col-lg-6 col-xl-3">
                        <div class="card">
                            <div class="card-body">
                                <a  onclick="cardClick(2,'Delayed Orders')" data-toggle="modal" style="cursor: pointer;">
                                <div class="row align-items-center">
                                    <div class="col-6">
                                        <h5 class="text-muted font-weight-normal mt-0 text-truncate" title="Pending Delivery Status">Pending Delivery Status</h5>
                                        <h3 class="text-danger my-2 py-1" id="pds">0</h3>
                                        <p class="mb-0 text-muted">
                                            <span class="text-info mr-2">0 Items</span>
                                        </p>
                                    </div>
                                    <div class="col-6">
                                        <div class="text-right">
                                            <div id="booked-revenue-chart" data-colors="#0acf97"></div>
                                        </div>
                                    </div>
                                </div> <!-- end row-->
                                    </a>
                            </div> <!-- end card-body -->
                        </div> <!-- end card -->
                    </div> <!-- end col -->
                </div>
                <!-- end row -->

                <div class="row">
                    <div class="col-lg-5">
                        <div class="card">
                            <div class="card-body">
                                <div class="dropdown float-right">
                                    <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                        <i class="mdi mdi-dots-vertical"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <!-- item-->
                                        <a onclick="cardClick(4,'Categories')" class="dropdown-item">Details</a>

                                    </div>
                                </div>

                                <h4 class="header-title mb-1">Categories</h4>

                                <div id="dash-campaigns-chart2" class="apex-charts" data-colors="#ffbc00,#727cf5,#0acf97"></div>

                                <div class="row text-center mt-2">
                                    <div class="col-md-4">
                                        <i class="mdi mdi-send widget-icon rounded-circle bg-light-lighten text-muted"></i>
                                        <h3 class="font-weight-normal mt-3">
                                            <span id="rmr">0</span>
                                        </h3>
                                        <p class="text-muted mb-0 mb-2"><i class="mdi mdi-checkbox-blank-circle text-warning"></i> Material Request</p>
                                    </div>
                                    <div class="col-md-4">
                                        <i class="mdi mdi-flag-variant widget-icon rounded-circle bg-light-lighten text-muted"></i>
                                        <h3 class="font-weight-normal mt-3">
                                            <span id="rpr">0</span>
                                        </h3>
                                        <p class="text-muted mb-0 mb-2"><i class="mdi mdi-checkbox-blank-circle text-primary"></i> Purchase Request</p>
                                    </div>
                                    <div class="col-md-4">
                                        <i class="mdi mdi-email-open widget-icon rounded-circle bg-light-lighten text-muted"></i>
                                        <h3 class="font-weight-normal mt-3">
                                            <span id="rpo">0</span>
                                        </h3>
                                        <p class="text-muted mb-0 mb-2"><i class="mdi mdi-checkbox-blank-circle text-success"></i> Purchase Order</p>
                                    </div>
                                </div>
                                
                            </div>
                            <!-- end card body-->
                        </div>
                        <!-- end card -->
                    </div>
                    <!-- end col-->

                    <div class="col-lg-7">
                        <div class="card">
                            <div class="card-body">
                                <div class="dropdown float-right">
                                    <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                        <i class="mdi mdi-dots-vertical"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <!-- item-->
                                        <a onclick="cardClick(9,'Critical Level',1)" class="dropdown-item">Details</a>
                                    </div>
                                </div>
                                
                                <h4 class="header-title mb-3">Inventory Critical Level</h4>

                                <div class="chart-content-bg">
                                    <div class="row text-center">
                                        <div class="col-md-6">
                                            <p class="text-muted mb-0 mt-3">Current Quarter</p>
                                            <h2 class="font-weight-normal mb-3">
                                                <span id="currentQ">0</span>
                                            </h2>
                                        </div>
                                        <div class="col-md-6">
                                            <p class="text-muted mb-0 mt-3">Previous Quarter</p>
                                            <h2 class="font-weight-normal mb-3">
                                                <span id="previousQ">0</span>
                                            </h2>
                                        </div>
                                    </div>
                                </div>

                                <div id="dash-revenue-chart" class="apex-charts" data-colors="#0acf97,#fa5c7c"></div>

                            </div>
                            <!-- end card body-->
                        </div>
                        <!-- end card -->
                    </div>
                    <!-- end col-->
                </div>
                <!-- end row-->


                <div class="row">
                    <div class="col-xl-4 col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <div class="dropdown float-right">
                                    <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                        <i class="mdi mdi-dots-vertical"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <!-- item-->
                                        <a onclick="cardClick(6,'Items')" class="dropdown-item">Details</a>

                                    </div>
                                </div>
                                <h4 class="header-title mb-3">Items with Pending Deliveries</h4>

                                <div class="table-responsive" style="height:27rem">
                                    <table class="table table-striped table-sm table-nowrap table-centered mb-0">
                                        <thead>
                                            <tr>
                                                <th>Items</th>
                                                <th>MR</th>
                                                <th>PR</th>
                                                <th>PO</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody id="ipd">
                 <%--                           <tr>
                                                <td>
                                                    <h5 class="font-15 mb-1 font-weight-normal">2020 Montero Sports GLS</h5>
                                                    <span class="text-muted font-13">MT DSL WHITE</span>
                                                </td>
                                                <td>187</td>
                                                <td>154</td>
                                                <td>49</td>
                                                <td class="table-action">
                                                    <a href="javascript: void(0);" class="action-icon"> <i class="mdi mdi-eye"></i></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <h5 class="font-15 mb-1 font-weight-normal">2021 Toyota Fortuner AT</h5>
                                                    <span class="text-muted font-13">DSL BLACK</span>
                                                </td>
                                                <td>235</td>
                                                <td>127</td>
                                                <td>83</td>
                                                <td class="table-action">
                                                    <a href="javascript: void(0);" class="action-icon"> <i class="mdi mdi-eye"></i></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <h5 class="font-15 mb-1 font-weight-normal">2020 MITSUBISHI XPANDER CROSS</h5>
                                                    <span class="text-muted font-13">1.5 GAS PEAR WHITE</span>
                                                </td>
                                                <td>365</td>
                                                <td>148</td>
                                                <td>62</td>
                                                <td class="table-action">
                                                    <a href="javascript: void(0);" class="action-icon"> <i class="mdi mdi-eye"></i></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <h5 class="font-15 mb-1 font-weight-normal">2020 SUZUKI ERTIGA GLX</h5>
                                                    <span class="text-muted font-13">BLACK EDITION AT 1.5</span>
                                                </td>
                                                <td>753</td>
                                                <td>159</td>
                                                <td>258</td>
                                                <td class="table-action">
                                                    <a href="javascript: void(0);" class="action-icon"> <i class="mdi mdi-eye"></i></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <h5 class="font-15 mb-1 font-weight-normal">MG ZS ALPHA</h5>
                                                    <span class="text-muted font-13">1.5 AT RED</span>
                                                </td>
                                                <td>458</td>
                                                <td>126</td>
                                                <td>73</td>
                                                <td class="table-action">
                                                    <a href="javascript: void(0);" class="action-icon"> <i class="mdi mdi-eye"></i></a>
                                                </td>
                                            </tr>--%>
                                        </tbody>
                                    </table>
                                </div> <!-- end table-responsive-->

                            </div> <!-- end card-body-->
                        </div> <!-- end card-->
                    </div>
                    <!-- end col-->

               <div class="col-xl-4 col-lg-12">
                    <div class="card">
                        <div class="card-body">
                            <a href="" class="p-0 float-right mb-3">Export <i class="mdi mdi-download ml-1"></i></a>
                            <h4 class="header-title mt-1">Inventory per Category</h4>

                            <div class="table-responsive" style="height:27rem">
                                <table class="table table-sm table-centered mb-0 font-14">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Item Category</th>
                                            <th>Inventory</th>
                                            <th style="width: 40%;"></th>
                                        </tr>
                                    </thead>
                                    <tbody id="ipc">
                      <%--                  <tr>
                                            <td>CENTRAL OFFICE EQUIPMENT(PRE-2018)</td>
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
                                            <td>SERVER & SYSTEM UPGRADE</td>
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
                                            <td>TOWER AND ANTENNAES MASTS AND CABLES</td>
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
                                            <td>CENTRAL OFFICE EQUIPMENT FD</td>
                                            <td>540</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar" role="progressbar"
                                                        style="width: 25%; height: 20px;" aria-valuenow="25"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>CABLES AND WIRES FACILITIES (PRE-2018)</td>
                                            <td>540</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar" role="progressbar"
                                                        style="width: 25%; height: 20px;" aria-valuenow="25"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                         <tr>
                                            <td>CLIENT PREMISES EQUIPMENT (C P E)</td>
                                            <td>540</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar" role="progressbar"
                                                        style="width: 25%; height: 20px;" aria-valuenow="25"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                                                                 <tr>
                                            <td>OUTSIDE PLANT (O S P)</td>
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
                    <!-- end col -->  
                    
                    <div class="col-xl-4 col-lg-6">
                        
                        <div class="card cta-box bg-primary text-white">
                            <a href="../WebReports/ReportViewer.aspx?val=~GEARS_Reports.R_RemainingInv2&param=PView&rep=LCgWqnmvJEdr4weikw34/SimULDECpJa3K8iwGjBeWZReJlbgMqucIX/z+SEeIPUzARmHUHvGYIM4GHgIhibdT4Pc/4FUBZzRuwi9+Qg1ltBgS61fLn1WcUx/b6BrsYp&transtype=REMRINV&userid=<%=Session["userid"] %>&schemaname=<%=Session["schemaname"] %>" target="_blank" class="btn btn-primary ml-2">
                            <div class="card-body">
                                <div class="media align-items-center">
                                    <div class="media-body">
                                        <h2 class="mt-0"><i class="mdi mdi-bullhorn-outline"></i>&nbsp;</h2>
                                        <h3 class="m-0 font-weight-normal cta-box-title">View <b>Remaining Inventory</b> for per item inventory <i class="mdi mdi-arrow-right"></i></h3>
                                    </div>
                                   
                                </div>
                            </div>
                            <!-- end card-body -->
                            </a>
                        </div>
                        <!-- end card-->

                        <div class="card cta-box bg-danger text-white">
                        <a href="../WebReports/ReportViewer.aspx?val=~GEARS_Reports.R_CriticalInventory&param=PView&rep=LCgWqnmvJEdr4weikw34/SimULDECpJa3K8iwGjBeWZReJlbgMqucIX/z+SEeIPUzARmHUHvGYIM4GHgIhibdT4Pc/4FUBZzRuwi9+Qg1ltBgS61fLn1WcUx/b6BrsYp&transtype=CRTREP&userid=<%=Session["userid"] %>&schemaname=<%=Session["schemaname"] %>" target="_blank" class="btn btn-danger ml-2">

                            <div class="card-body">
                                <div class="media align-items-center">
                                    <div class="media-body">
                                        <h2 class="mt-0"><i class="mdi mdi-bullhorn-outline"></i>&nbsp;</h2>
                                        <h3 class="m-0 font-weight-normal cta-box-title">View <b>Critical Inventory</b> for detailed information <i class="mdi mdi-arrow-right"></i></h3>
                                    </div>
                                   
                                </div>
                            </div>
                            <!-- end card-body -->
                                                            </a>
                        </div>

                       <div class="card cta-box bg-success text-white">
                       <a href="../WebReports/ReportViewer.aspx?val=~GEARS_Reports.R_AgingOfInv&param=PView&rep=LCgWqnmvJEdr4weikw34/SimULDECpJa3K8iwGjBeWZReJlbgMqucIX/z+SEeIPUzARmHUHvGYIM4GHgIhibdT4Pc/4FUBZzRuwi9+Qg1ltBgS61fLn1WcUx/b6BrsYp&transtype=AGR&userid=<%=Session["userid"] %>&schemaname=<%=Session["schemaname"] %>" target="_blank" class="btn btn-success ml-2">

                            <div class="card-body">
                                <div class="media align-items-center">
                                    <div class="media-body">
                                        <h2 class="mt-0"><i class="mdi mdi-bullhorn-outline"></i>&nbsp;</h2>
                                        <h3 class="m-0 font-weight-normal cta-box-title">View <b>Aging of Inventory</b> for detailed information <i class="mdi mdi-arrow-right"></i></h3>
                                    </div>
                                   
                                </div>
                            </div>
                            <!-- end card-body -->
                                                           </a>
                        </div>

                    </div>
                    <!-- end col -->  
                </div>
                <!-- end row-->
                
            </div> <!-- container -->


        </div>
        <!-- END wrapper -->
    </form>
    
        <!-- Common JS -->
    <script src="../js/PerfSender.js" type="text/javascript"></script>


        <!-- bundle -->
        <script src="assets/js/vendor.min.js"></script>
        <script src="assets/js/app.min.js"></script>

        <!-- Apex js -->
        <script src="assets/js/vendor/apexcharts.min.js"></script>

        <!-- Todo js -->
        <script src="assets/js/ui/component.todo.js"></script>

<%--        <script src="assets/js/pages/demo.dashboard-crm.js"></script>--%>
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
                    $('#dash-period').val(strArray[d.getMonth() ] + '-' + d.getFullYear());
                   // $('#dash-period').data('daterangepicker').setMonth(d.getMonth());


                  //  Dashboard();
                }

            });


        });

        function reinitChart() {
                                var colors = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"],
                        dataColors = $("#campaign-sent-chart").data("colors");
                    dataColors && (colors = dataColors.split(","));
                    var options1 = {
                        chart: { type: "bar", height: 60, sparkline: { enabled: !0 } },
                        plotOptions: { bar: { columnWidth: "60%" } },
                        colors: colors,
                        series: [{ data: [25, 66, 41, 89, 63, 25, 44, 12, 36, 9, 54] }],
                        labels: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
                        xaxis: { crosshairs: { width: 1 } },
                        tooltip: {
                            fixed: { enabled: !1 },
                            x: { show: !1 },
                            y: {
                                title: {
                                    formatter: function (o) {
                                        return "";
                                    },
                                },
                            },
                            marker: { show: !1 },
                        },
                    };

                    new ApexCharts(document.querySelector("#campaign-sent-chart"), options1).render();
                    colors = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
                    (dataColors = $("#new-leads-chart").data("colors")) && (colors = dataColors.split(","));
                    var options2 = {
                        chart: { type: "line", height: 60, sparkline: { enabled: !0 } },
                        series: [{ data: [25, 66, 41, 89, 63, 25, 44, 12, 36, 9, 54] }],
                        stroke: { width: 2, curve: "smooth" },
                        markers: { size: 0 },
                        colors: colors,
                        tooltip: {
                            fixed: { enabled: !1 },
                            x: { show: !1 },
                            y: {
                                title: {
                                    formatter: function (o) {
                                        return "";
                                    },
                                },
                            },
                            marker: { show: !1 },
                        },
                    };
                    new ApexCharts(document.querySelector("#new-leads-chart"), options2).render();
                    colors = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
                    (dataColors = $("#deals-chart").data("colors")) && (colors = dataColors.split(","));
                    var options3 = {
                        chart: { type: "bar", height: 60, sparkline: { enabled: !0 } },
                        plotOptions: { bar: { columnWidth: "60%" } },
                        colors: colors,
                        series: [{ data: [12, 14, 2, 47, 42, 15, 47, 75, 65, 19, 14] }],
                        labels: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
                        xaxis: { crosshairs: { width: 1 } },
                        tooltip: {
                            fixed: { enabled: !1 },
                            x: { show: !1 },
                            y: {
                                title: {
                                    formatter: function (o) {
                                        return "";
                                    },
                                },
                            },
                            marker: { show: !1 },
                        },
                    };
                    new ApexCharts(document.querySelector("#deals-chart"), options3).render();
                    colors = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
                    (dataColors = $("#booked-revenue-chart").data("colors")) && (colors = dataColors.split(","));
                    var options4 = {
                        chart: { type: "bar", height: 60, sparkline: { enabled: !0 } },
                        plotOptions: { bar: { columnWidth: "60%" } },
                        colors: colors,
                        series: [{ data: [47, 45, 74, 14, 56, 74, 14, 11, 7, 39, 82] }],
                        labels: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
                        xaxis: { crosshairs: { width: 1 } },
                        tooltip: {
                            fixed: { enabled: !1 },
                            x: { show: !1 },
                            y: {
                                title: {
                                    formatter: function (o) {
                                        return "";
                                    },
                                },
                            },
                            marker: { show: !1 },
                        },
                    };
                    new ApexCharts(document.querySelector("#booked-revenue-chart"), options4).render();
                    colors = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
                    (dataColors = $("#dash-campaigns-chart2").data("colors")) && (colors = dataColors.split(","));
                    var options = { chart: { height: 304, type: "radialBar" }, colors: colors, series: [mrp.toFixed(2), prp.toFixed(2), pop.toFixed(2)], labels: ["Material Request", "Purchase Request", "Purchase Order"], plotOptions: { radialBar: { track: { margin: 8 } } } },
                        chart = new ApexCharts(document.querySelector("#dash-campaigns-chart2"), options);
                    chart.render();
                    colors = ["#727cf5", "#0acf97", "#fa5c7c", "#ffbc00"];
                    (dataColors = $("#dash-revenue-chart").data("colors")) && (colors = dataColors.split(","));
                    options = {
                        chart: { height: 321, type: "line", toolbar: { show: !1 } },
                        stroke: { curve: "smooth", width: 2 },
                        series: [
                            { name: "Inventory", type: "area", data: eval(Inv) },
                            { name: "Level", type: "line", data: eval(Level) },
                        ],
                        fill: { type: "solid", opacity: [0.35, 1] },
                       // labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                        labels: eval(armonth),
                        markers: { size: 0 },
                        colors: colors,
                        yaxis: [{ title: { text: "Inventory" }, min: 0 }],
                        tooltip: {
                            shared: !0,
                            intersect: !1,
                            y: {
                                formatter: function (o) {
                                    return void 0 !== o ? o.toFixed(0) + "" : o;
                                },
                            },
                        },
                        grid: { borderColor: "#f1f3fa", padding: { bottom: 5 } },
                        legend: { fontSize: "14px", fontFamily: "14px", offsetY: 5 },
                        responsive: [{ breakpoint: 600, options: { yaxis: { show: !1 }, legend: { show: !1 } } }],
                    };
                    (chart = new ApexCharts(document.querySelector("#dash-revenue-chart"), options)).render();

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

                        
                        ti.type = "checkbox";
                        ti.name = "name" + i;
                        ti.value = "value";
                        ti.id = "id" + i;


                        //ti.setAttribute("type", "checkbox");
                        //ti.checked = true;
                        
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

           
            if ($.fn.DataTable.isDataTable('#basicdatatable')) {
                $('#basicdatatable').DataTable().destroy();
            }
                $('#basicdatatable').empty();
               

            // document.getElementById("basicdatatable").removeChild();
            $('#basicdatatable').append(tHead);

            $('#basicdatatable').append(tBody);
            $('#basicdatatable').DataTable({
                "orderCellsTop": true,
                "fixedHeader": true,
               
                "scrollX": true,
                "sScrollY": "310px",
                "render": true,
                "pageLength": 5,
                "paging": false,
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


                //for (var j = 0; j < col.length; j++) {
                //    let td = document.createElement("td");

                //    td.innerHTML = objDetails[i][col[j]];
                //    bTr.appendChild(td);
                //}
                
                for (var j = 0; j < col.length; j++) {

                    if (j == 0 && withselect==1) {
                        let td = document.createElement("td");
                        let ti = document.createElement("input");
                        ti.setAttribute("type", "checkbox");
                        ti.id="c" + i
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

         function CreatePR() {

              
         var table = $('#basicdatatable').DataTable();

             var text = ' [';

        var data = table.rows().data();
             data.each(function (value, index) {

                 var inputElements = document.getElementById('id' + index);
                 //console.log(inputElements.checked);             

                 if (inputElements.checked) {
                     console.log(`For index $ {index}, data value is ${value}`);
                     console.log('item: ' + value[1]);
                     console.log('Request: ' + value[8]);

                     text += '{ "ItemCode":"'+value[1]+'" ,"ColorCode":"'+value[2]+'" ,"ClassCode":"'+value[3]+'" ,"SizeCode":"'+value[4]+'" , "RequestQty":"'+ value[8]+'" },';
                 }
             });

             text += ' {"ItemCode":"","ColorCode":"" ,"ClassCode":"" ,"SizeCode":"" ,"RequestQty":0 }]';

             var javascriptObject = JSON.parse(text);
             console.log(javascriptObject);

             $.ajax({
                 type: "POST",
                 data:JSON.stringify({ ItemStr: text }) ,
                    url: "/IT/frmDashboardIPC.aspx/GetDashboard",
                    dataType: "json",
                  contentType: "application/json; charset=utf-8",
                  success: function (data) {

                      alert(data.d);

               
                  
                },
                 error: function (data) {
                      alert(data.d);
                   
                }
             });

            


             //console.log(JSON.stringify(tableToJSON($("#basicdatatable"))));
         }

         function tableToJSON(tblObj){  
               var data = [];
               var $headers = $(tblObj).find("th");
               var $rows = $(tblObj).find("tbody tr").each(function(index) {
               $cells = $(this).find("td");
               data[index] = {};
               $cells.each(function(cellIndex) {
                 data[index][$($headers[cellIndex]).html()] = $(this).html();
               });    
            });
              return data;
            }

        var mrp = 0, prp = 0, pop = 0, arp = 0, app = 0, arap = 0, Total = "[]", cashdate = "[]",Inv="[]",Level="[]", armonth="[]";
        function Dashboard() {
            let items;

            var vUserID = '<%=Session["userid"] %>';
            var vType = 'DashboardIPC';
            var vParam = $("#dash-period").val();
            var vScheama = '<%=Session["schemaname"] %>';
            var extsession = '<%=Session["token"]%>';
           

            fetch('<%=Session["APIURL"] %>' + "/GetDashboard", {
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

                $('#omr').text(numberWithCommas(data[0].length));
                $('#opr').text(numberWithCommas(data[1].length));
                $('#po').text(numberWithCommas(data[2].length));
                $('#pds').text(numberWithCommas(data[3].length));


                for (var i = 0; i < data[4].length; i++) {

                    switch (data[4][i].Trans) {
                        case 'Material Request': $('#rmr').text(numberWithCommas(data[4][i].Total)); mrp = (data[4][i].Actual / data[4][i].Total) * 100;  break;
                        case 'Purchase Request': $('#rpr').text(numberWithCommas(data[4][i].Total)); prp = (data[4][i].Actual / data[4][i].Total) * 100;break;
                        case 'Purchase Order': $('#rpo').text(numberWithCommas(data[4][i].Total)); pop = (data[4][i].Actual / data[4][i].Total) * 100;break;



                    }
               
                }

                 Inv = "[" 
                 Level = "[" 
                 armonth = "["
                for (var i = 0; i < data[5].length; i++) {
                    Inv += data[5][i].Inv
                    Level += data[5][i].Level
                    armonth += "'"+data[5][i].Month+"'"
                    if (data[5].length > i + 1) {
                        Inv += ", "
                        Level += ", "
                        armonth +=", "
                    }

                }

                
                Inv += "]"
                Level += "]" 
                armonth +="]"


                
                table = "";
                for (var i = 0; i < data[6].length; i++) {

          

                 table += "<tr>"
                 table += "    <td>"
                 table += "        <h5 class='font-15 mb-1 font-weight-normal'>"+data[6][i].ShortDesc+"</h5>"
                 table += "        <span class='text-muted font-13'>"+data[6][i].ItemCode+"</span>"
                 table += "    </td>"
                 table += "    <td>"+numberWithCommas(data[6][i].MRQty)+"</td>"
                 table += "    <td>"+numberWithCommas(data[6][i].PRQty)+"</td>"
                 table += "    <td>"+numberWithCommas(data[6][i].POQty)+"</td>"
                 table += "    <td class='table-action'>"
                 table += "        <a href='javascript: void(0);' class='action-icon'> <i class='mdi mdi-eye'></i></a>"
                 table += "    </td>"
                 table += "</tr>"                   
               
                }

                $('#ipd').empty();
                $('#ipd').append(table);
              
                table = "";
                total = 0;
                for (var i = 0; i < data[7].length; i++) {
                    total+= data[7][i].Total
                }
                for (var i = 0; i < data[7].length; i++) {

          

                 table += "<tr>"
                 table += "<td>"+data[7][i].Description+"</td>"
                 table += "<td>"+numberWithCommas(data[7][i].Total)+"</td>"
                 table += "<td>"
                 table += "    <div class='progress' style='height: 3px;'>"
                 table += "        <div class='progress-bar' role='progressbar'"
                 table += "            style='width: "+((data[7][i].Total/total)*100)+"%; height: 20px;' aria-valuenow='"+((data[7][i].Total/total)*100)+"'"
                 table += "            aria-valuemin='0' aria-valuemax='100'>"
                 table += "        </div>"
                 table += "        </div>"
                 table += "    </td>"
                 table += "</tr>"                   
               
                }

                $('#ipc').empty();
                $('#ipc').append(table);
               

                $('#currentq').text(numberWithCommas(data[8][0].CurrentQ));
                $('#previousq').text(numberWithCommas(data[8][0].PreviousQ));


                reinitChart();
            }

            ).catch(function (error) {
                console.log(error);
            })
        
    }



    </script>
</body>
</html>
