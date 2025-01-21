<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmCapacityPlanning.aspx.cs" Inherits="GWL.IT.frmCapacityPlanning" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>GEARS - Capacity Planning</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
    <!-- App css -->
    <link href="assets/css/icons.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/app.min.css" rel="stylesheet" type="text/css" />
    <link href="../Assets/enjoyhint/css/overlay.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/vendor/dataTables.bootstrap4.css" rel="stylesheet" type="text/css" />
    <link href="../css/datepicker.min.css" rel="stylesheet" type="text/css" />
    <link href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" rel="stylesheet" type="text/css"  />

    <style>
        .table td, .table th {
            vertical-align: middle;
        }
        #final {
            text-overflow: unset;
        }
        tbody .editable:hover {
            cursor: pointer;
            background: #f1f1f1;
        }
        .editVal {
            border: none;
            outline: none;
        }
        .center {
            text-align: center !important;
        }
        #searchBtn:disabled {
            cursor: not-allowed;
        }   

        table thead tr:first-child {
            height: 3rem !important;
        }
        td.details-control, td.details-control0  {
            background: url('../icons/details_open.png') no-repeat center center;
            cursor: pointer;
            transition: .5s;
        }

        tr.shown td.details-control, tr.shown td.details-control0 {
            background: url('../icons/details_close.png') no-repeat center center;
            cursor: pointer;
            transition: .5s;
        }

        td.details-control1{
            background: url('../icons/details_open.png') no-repeat center center;
            cursor: pointer;
            transition: .5s;
        }

        tr.shown td.details-control1 {
            background: url('../icons/details_close.png') no-repeat center center;
            transition: .5s;
        }

        td.details-control2 {
            background: url('../icons/details_open.png') no-repeat center center;
            cursor: pointer;
            transition: .5s;
        }

        tr.shown td.details-control2 {
            background: url('../icons/details_close.png') no-repeat center center;
            width: 0px
        }

        td.details-control3 {
            background: url('../icons/details_open.png') no-repeat center center;
            cursor: pointer;
            transition: .5s;
        }

        tr.shown td.details-control3 {
            background: url('../icons/details_close.png') no-repeat center center;
            width: 0px
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
            border: none;
            width: 7rem;
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
            background-color: #F1F3FA;
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
    </style>

    <!-- Common JS -->
    <%--<script src="../js/PerfSender.js" type="text/javascript"></script>--%>
    <script src="../js/jquery-3.6.0.min.js"></script>

    <!-- third party js -->
    <script src="../js/datepicker.min.js" type="text/javascript"></script>
    <!-- third party js ends -->

     <!-- Datatables js -->
    <script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <script src="../js/sweetalert2.min.js" ></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    <script src="../js/disableIns.js" ></script> <%-- Custom JS --%>
    <%-- Capacity Planning JS --%>
    <script src="../js/Production/CapacityPlanning.js" defer="defer" ></script>
</head>
    
<body>
    <div id="newtab" onclick="offnewtab()">
        <div id="text">
            Capacity Planning
            <p style="font-size: 14px;">
               <br /> Capacity Planning has been open into a new tab, please click to refresh.
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

        <div id="viewMachines" class="modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="viewMachines--Title">Available Machines</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" style="overflow-y: auto">
                        <%--  Table Content--%>
                        <div class="row">
                            <div class="col-sm-12 col-md-4">
                                <table id="SKUsTable" class="table dt-responsive table-striped table-centered w-100">
                                    <tfoot>
                                        <tr>
                                            <th>Total:</th>
                                            <th></th>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                            <div class="col-sm-12 col-md-8">
                                <table id="availableMachinesTable" class="table dt-responsive table-striped table-centered w-100">
                                    <tfoot>
                                        <tr>
                                            <th>Total:</th>
                                            <th></th>
                                            <th></th>
                                            <th></th>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
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
                                    <%--<a href="#" class="btn btn-warning ml-2">
                                        <i class="mdi mdi-import"></i>
                                    </a>
                                     <a href="#" class="btn btn-danger ml-2">
                                        <i class="mdi mdi-check-circle"></i>
                                    </a>
                                    <a href="#" class="btn btn-primary ml-2">
                                        <i class="mdi mdi-email"></i>
                                    </a>--%>
                                   <button id="finalizeBtn" type="button" class="btn btn-success ml-2" style="display:none">
                                        <i class="mdi mdi-content-save">Finalize</i>
                                    </button>
                                    <a id="calendarBtn" href="../Production/frmCapacityPlanningCalendar.aspx" class="btn btn-success ml-2">
                                        <i class="mdi mdi-calendar">View Calendar</i>
                                    </a>
                                </div>
                            </div>
                            <h4 class="page-title">
                                <a href="..\IT\frmCapacityPlanning.aspx" target="_blank" onclick="onnewtab();">Capacity Planning</a>
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
                                         <asp:Label Text="Day No:" runat="server" CssClass="dayhide d-none"/>
                                         <span id="paramDayNo" class="paramVal dayhide d-none">1</span>
                                     </span>
                                </div>

                                <h4 class="header-title mb-3">
                                    <span style="padding-left:10px">
                                          Capacity Planning for:
                                          <select id="CapacityPlanningFor" style="border-style:none">
                                            <option value="Machine">Machine</option>
                                            <option value="ManpowerSpecific">Specific Manpower</option>
                                            <option value="ManpowerGeneral">General Manpower</option>
                                        </select>
                                    </span>

                                    <span style="padding-left:10px">
                                          View:
                                          <select id="view" style="border-style:none">
                                            <option value="Week">Week</option>
                                            <option value="Day">Day</option>
                                        </select>
                                    </span>

                                    <span style="padding-left:10px">
                                        Year:
                                        <select name="yearparam" id="yearparam" style="border-style:none"></select>
                                    </span>
                                    <span style="padding-left:10px">
                                        WeekNo:
                                        <select name="weeknoparam" id="weeknoparam" style="border-style:none"></select>
                                    </span>
                                    <span style="padding-left:10px; display: none;">
                                        Day:
                                        <select name="daynoparam" id="daynoparam" style="border-style:none">
                                            <option value="0">1</option>
                                            <option value="1">2</option>
                                            <option value="2">3</option>
                                            <option value="3">4</option>
                                            <option value="4">5</option>
                                            <option value="5">6</option>
                                            <option value="6">7</option>
                                        </select>
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
                                    <table id="masterTableMachine" class="table table-centered table-nowrap mb-0" style="width:100%">
                                        <thead>
                                            <tr>
                                                <th></th>
                                                <%--<th style="display:none"><h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">SKU</a></h5></th>--%>
                                                <th><h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Stages</a></h5></th>
                                             </tr>  
                                        </thead>
                                        <tbody id="detpo"></tbody>
                                    </table>
                                </div>

                                <%-- Specific Manpower --%>
                                <div class="table-responsive" style="display: none;">
                                    <table id="masterTableManpowerSpecific" class="table table-centered table-nowrap mb-0" style="width:100%">
                                        <thead>
                                            <tr>
                                                <th style="width:5% !important"></th>    
                                                <th><h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Designation</a></h5></th>
                                             </tr>  
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>

                                <%-- General Manpower --%>
                                <div class="table-responsive" style="display: none;">
                                    <table id="masterTableManpowerGeneral" class="table table-centered table-nowrap mb-0" style="width:100%">
                                        <thead>
                                            <tr>
                                                <th></th>
                                                <th><h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Designation</a></h5></th>
                                             </tr>  
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
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
