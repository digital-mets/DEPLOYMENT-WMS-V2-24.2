<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmManningSchedule.aspx.cs" Inherits="GWL.IT.frmManningSchedule" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>GEARS - Manning Schedule</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
    <!-- App css -->
    <link href="assets/css/icons.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/app.min.css" rel="stylesheet" type="text/css" />
    <link href="../Assets/enjoyhint/css/overlay.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/vendor/dataTables.bootstrap4.css" rel="stylesheet" type="text/css" />
    <link href="../css/datepicker.min.css" rel="stylesheet" type="text/css" />
    <link href="../css/select2.min.css" rel="stylesheet" type="text/css" />

    <style>
        .dataTables_filter { 
            display: none;
        }

        td.editable {
            cursor: pointer;
            background-color: #d1d1d1;
        }

        td.editable.view {
            cursor: default !important;
            background-color: transparent;
        }
        table tbody td, table tfoot td {
            padding: 0 .5rem;
        }
        select, params {
            -webkit-appearance: none;
            -moz-appearance: none;
            text-indent: 1px;
            text-overflow: '';
        }
        .hide {
        display:none;
        }
        table thead tr:first-child {
            height: 3rem;
        }
        .hideheader thead tr {
            height: 0 !important;
        }
        .hideheader thead th, .hideheader thead th::before, .hideheader thead th::after {
            border: none;
        }
        .hideheader thead th::before, .hideheader thead th::after {
            display: none !important;
        }
        td.details-control, td.details-control1,
        td.details-control2, td.details-control3,
        td.details-control4{
            background: url('../icons/details_open.png') no-repeat center center;
            cursor: pointer;
            transition: .5s;
        }
        tr.shown td.details-control, tr.shown td.details-control1,
        tr.shown  td.details-control2, tr.shown td.details-control3,
        tr.shown td.details-control4 {
            background: url('../icons/details_close.png') no-repeat center center;
            cursor: pointer;
            transition: .5s;
        }
        .params {
            height: calc(2.25rem + 2px);
            padding: .45rem .9rem;
            font-size: .9rem;
            font-weight: 400;
            line-height: 1.5;
            color: #6c757d;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid #dee2e6;
            border-radius: .25rem;
            -webkit-transition: border-color .15s ease-in-out,-webkit-box-shadow .15s ease-in-out;
            transition: border-color .15s ease-in-out,-webkit-box-shadow .15s ease-in-out;
            transition: border-color .15s ease-in-out,box-shadow .15s ease-in-out;
            transition: border-color .15s ease-in-out,box-shadow .15s ease-in-out,-webkit-box-shadow .15s ease-in-out;
        }

        .paramVal {
            font-size: large;
            padding-right: 10px;
            font-weight: bold;
        }

        .table td, .table th {
            padding: .05rem;
            vertical-align: top;
            border-top: 1px solid #eef2f7;
        }

        input:read-only {
            /*background-color: #F1F3FA;*/
        }

        #newtab {
            position: fixed; /* Sit on top of the page content */
            display: none; /* Hidden by default */
            width: 100%; /* Full width (cover the whole page) */
            height: 100%; /* Full height (cover the whole page) */
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0,0,0,0.5); /* Black background with opacity */
            z-index: 2; /* Specify a stack order in case you're using a different order for other elements */
            cursor: pointer; /* Add a pointer on hover */
        }
        
        /*.dropdown {
            z-index: 9999999;
            width: 150px;
        }*/
    </style>

    <!-- Common JS -->
    <%--<script src="../js/PerfSender.js" type="text/javascript"></script>--%>
    <script src="../js/jquery-3.6.0.min.js"></script>

    <!-- bundle -->
    <%--<script src="assets/js/vendor.min.js"></script>
    <script src="assets/js/app.min.js"></script>--%>

    <!-- third party js -->
    <%--<script src="assets/js/vendor/Chart.bundle.min.js" type="text/javascript"></script>--%>
    <%--<script src="assets/js/vendor/apexcharts.min.js" type="text/javascript"></script>--%>
    <%--<script src="assets/js/vendor/jquery-jvectormap-1.2.2.min.js" type="text/javascript"></script>--%>
<%--    <script src="assets/js/vendor/jquery-jvectormap-world-mill-en.js" type="text/javascript"></script>--%>
    <script src="../js/datepicker.min.js" type="text/javascript"></script>
    <!-- third party js ends -->

    <!-- demo app -->

    <!-- end demo js-->

     <!-- Datatables js -->
    <%--<script src="//cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>--%>
    <script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
    <script src="assets/js/vendor/dataTables.bootstrap4.js"></script>
    <script src="assets/js/vendor/dataTables.responsive.min.js"></script>
    <%--<script src="assets/js/vendor/responsive.bootstrap4.min.js"></script>--%>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <script src="../js/select2.min.js" ></script>
    <script src="../js/sweetalert2.min.js" ></script>

    <%-- Capacity Planning JS --%>
    <script src="../js/Production/ManningSchedule.js" ></script>
</head>
    
<body>
    <div id="newtab" onclick="offnewtab()">
        <div id="text">
            Manning Schedule
            <p style="font-size: 14px;">
               <br /> Manning Schedule has been open into a new tab, please click to refresh.
            </p>
        </div>
    </div>

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
                        <div class="page-title-box" >
                            <div class="page-title-right">
                                <div class="form-inline">
                                    <%--<a href="javascript:  Dashboard();" class="btn btn-warning ml-2">
                                        <i class="mdi mdi-import"></i>
                                    </a>
                                     <a href="javascript:  Dashboard();" class="btn btn-danger ml-2">
                                        <i class="mdi mdi-check-circle"></i>
                                    </a>
                                    <a href="javascript:  Dashboard();" class="btn btn-primary ml-2">
                                        <i class="mdi mdi-email"></i>
                                    </a>
                                   <a href="javascript:  Dashboard();" class="btn btn-success ml-2">
                                        <i class="mdi mdi-content-save"></i>
                                    </a>--%>
                                    <button id="finalizeBtn" type="button" class="btn btn-success ml-2" style="display:none">
                                        <i class="mdi mdi-content-save">Finalize</i>
                                    </button>
                                </div>
                            </div>
                            <h4 class="page-title">
                                <a href="..\IT\frmManningSchedule.aspx" target="_blank" onclick="onnewtab();">Manning Schedule</a>
                                <span id="final" class="badge badge-danger-lighten">Please select Work week and Year</span>
                            </h4> 
                        </div>
                    </div>
                    <!-- end col-->
                </div>
                <!-- end row-->

                <div class="row">
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <div class="dropdown float-right">
                                    <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                        <i class="mdi mdi-dots-vertical"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <!-- item-->
                                        <a onclick="cardClick(5,'Pending Orders')" class="dropdown-item">Details</a>
                                    </div>
                                </div>
                                <div class="label float-right" style="padding-right:10px">
                                     <span>
                                         <asp:Label Text="YEAR:" runat="server" />
                                         <span id="paramYear" class="paramVal"></span>
                                         <asp:Label Text="Week No:" runat="server" />
                                         <span id="paramWorkWeek" class="paramVal"></span>
                                     </span>
                                </div>

                                <h4 class="header-title mb-3">
                                    <span style="padding-left:10px">
                                          View Option:
                                          <select id="ViewOption" style="border-style:none">
                                            <option value="Week">Week</option>
                                            <option value="Day" style="display:none">Day</option>
                                        </select>
                                    </span>

                                    <span style="padding-left:10px">
                                        Year:
                                        <select  name="cars" id="yearparam" style="border-style:none"></select>
                                    </span>
                                    <span style="padding-left:10px">
                                        WeekNo:
                                        <select  name="weeknoparam" id="weeknoparam" style="border-style:none"></select>
                                    </span>

                                    <button id="searchBtn" type="button" class="btn btn-success ml-2" style="height:2rem; ">
                                        <i class="mdi mdi-check">View</i>
                                    </button>

                                    <button id="generateBtn" type="button" class="btn btn-info ml-2" style="height:2rem; display:none ">
                                        <i class="mdi mdi-check">Generate</i>
                                    </button>
                                </h4> 

                                <%-- Machine Table --%>
                                <div class="table-responsive">
                                    <table id="masterTableMachine" class="table table-centered table-nowrap mb-0">
                                        <thead>
                                            <tr style="height:3rem;">
                                                <th style="width:5%;"></th>
                                                <th>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Date</a></h5>
                                                </th>
                                                <th>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Action</a></h5>
                                                </th>
                                             </tr>  
                                        </thead>
                                        <tbody id="detpo"></tbody>
                                    </table>
                                </div>

                                <%-- Specific Manpower --%>
                                <div class="table-responsive" style="overflow:auto; height:25rem; display: none;">
                                    <table id="masterTableManpowerSpecific" class="table table-centered table-nowrap table-hover mb-0">
                                        <thead>
                                            <tr>
                                                <th>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">SKU</a></h5>
                                                </th>
                                                <th>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Process Code</a></h5>
                                                </th>
                                                 <th>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Position</a></h5>
                                                 </th>
                                                 <th>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Manpower</a></h5>
                                                    <span class="text-muted font-13">Number</span>
                                                 </th>
                                             </tr>  
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">MT00001 - Meat Code</a></h5>
                                                    <span class="text-muted font-13">Pork Meat</span>
                                                </td>
                                                <td>
                                                   <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">100</a></h5>
                                                </td>
                                                <td>
                                                   <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">150</a></h5>
                                                </td>
                                                <td>
                                                   <input type="number" value="4000" style="width:5rem; border-style:none"/>
                                                   
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>

                                <%-- General Manpower --%>
                                <div class="table-responsive" style="overflow:auto; height:25rem; display: none;">
                                    <table id="masterTableManpowerGeneral" class="table table-centered table-nowrap mb-0">
                                        <thead>
                                            <tr>
                                                <th>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Process Code</a></h5>
                                                </th>
                                                <th>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Line Assignment</a></h5>
                                                </th>
                                                 <th>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Position</a></h5>
                                                 </th>
                                                 <th>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Manpower</a></h5>
                                                    <span class="text-muted font-13">Number</span>
                                                 </th>
                                             </tr>  
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">MT00001 - Meat Code</a></h5>
                                                    <span class="text-muted font-13">Pork Meat</span>
                                                </td>
                                                <td>
                                                   <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">100</a></h5>
                                                </td>
                                                <td>
                                                   <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">150</a></h5>
                                                </td>
                                                <td>
                                                   <input type="number" value="4000" style="width:5rem; border-style:none"/>
                                                   
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>

                                <%-- Edit --%>
                                <div class="table-responsive edittable" style="overflow:auto; height:25rem; display: none;">
                                    <table id="edit1" class="table tablechild table-centered edit1">
                                    <tfoot style="text-align:inherit"><tr id="f' + id + '"><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr></tfoot>
                                    </table>
                                    <table id="edit2" class="table table-centered hideheader edit2">
                                    <thead></thead>
                                    <tfoot style="text-align:inherit">
                                    <tr id="fedit2"><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr>
                                    <tr id="fgedit2"><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr>
                                    </tfoot >
                                    </table>
                                    <table id="edit3" class="table table-centered edit3">
                                    <tfoot style="text-align:inherit"><tr id="fedit3"><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr></tfoot>
                                    </table>
                                    <table id="edit4" class="table table-centered hideheader edit4">
                                    <thead></thead>
                                    <tfoot style="text-align:inherit">
                                    <tr id="fedit4"><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr>
                                    <tr id="fgedit4"><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr>
                                    <tr><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr>
                                    </tfoot>
                                    </table>
                                </div>



                                <!-- end table-responsive-->
                            </div>
                            <!-- end card body-->
                        </div>
                        <!-- end card -->
                    </div>
                    <!-- end col-->
                </div>
                <!-- end row-->
            </div>
            <!-- container -->
        </div>
        <!-- END wrapper -->
    </form>
</body>
</html>
