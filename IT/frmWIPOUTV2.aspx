<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmWIPOUTV2.aspx.cs" Inherits="GWL.IT.frmWIPOUTV2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>GEARS - WIP</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
    <!-- App css -->
    <link href="assets/css/icons.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/app.min.css" rel="stylesheet" type="text/css" />
    <link href="../Assets/enjoyhint/css/overlay.css" rel="stylesheet" />
    <link href="assets/css/vendor/dataTables.bootstrap4.css" rel="stylesheet" type="text/css" />
    <link href="../css/select2.min.css" rel="stylesheet" type="text/css" />
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

<style>
    #DTbl tbody td:first-child {
        text-align: center;
    }
    #CookingStageSmokehouse {
        min-height: 32px !important;
    }
    .select2-container--default 
    .select2-selection--multiple 
    .select2-selection__choice__display {
         color: #000;
    }
    #DTbl2 .select2-container .select2-selection,
    #DTbl3 .select2-container .select2-selection{
        height: calc(1.5rem + 1px) !important;
        overflow: auto;
        display: none !important;
    }
    .required {
        border-color: #dc3545 !important;
    }
    table th {
        z-index: 12 !important;
    }
    .center {
        text-align: center;
    }
    .form-control-sm {
        height: calc(1.5rem + 1px) !important;
    }
    input[type='checkbox'].form-control-sm {
        height: calc(1rem + 1px) !important;
    }
    td.details-control, td.details-control1 {
        background: url('../icons/details_open.png') no-repeat center center;
        cursor: pointer;
        transition: .5s;
    }
    tr.shown td.details-control, tr.shown td.details-control1 {
        background: url('../icons/details_close.png') no-repeat center center;
        cursor: pointer;
        transition: .5s;
    }
    .params, #SAPNo {
        border-style: none;
        outline: none;
    }
    #SAPNo {
        background-color: aliceblue;
        border-radius: 5px;
    }
    button:disabled, input:disabled, select:disabled {
        cursor: not-allowed;
    }
    .header-title .select2-container {
        width: 120px !important;
    }
    .header-title .select2-selection {
        border: none !important;
    }
    table .select2-selection, table .select2-container--default .select2-selection--single {
       border: 1px solid #dee2e6;
    }
    .select2-container--open .select2-dropdown--below {
        border-top: 1px solid #aaa !important;
    }
    .dropdowncss {
        width: 300px !important;
    }
    .table td, .table th {
        padding: .30rem;
        vertical-align: top;
        border-top: 1px solid #eef2f7;
    }

    th {
        position: sticky;
        top: 0;
        background-color: white;
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

    .OLD { 
        background-color: white;
    }

   .NEW { 
        background-color: lightblue;
    }

   .smallsku {
       color: red;
   }
  .chicken {
       color: blue;
   }
   .footlong {
       color: green;
   }

   /*--------------------------------------------------------------
# Email button
--------------------------------------------------------------*/

.emailBtn {
    position: fixed;
    top: 35%;
    right: 0;
    width: 20px;
    height: 130px;
    background-color: #143d8d;
    border: none;
    outline: none;
    text-align: left;
    font-weight: 500;
    text-align: center;
    transition: 1s;
}

.emailLabel {
    writing-mode: vertical-rl;
    text-orientation: mixed;
    transform: rotate(180deg);
    letter-spacing: 1px;
    position: relative;
    right: 10px;
    top: 3px;
    color: #fff;
}

.emailBtn:hover > .emailBox {
  box-shadow: -3px 0px 0px 0px #143d8d;
}

.emailBox {
    z-index:99999;
    position:fixed;
    top:15%;
    right:-353px;
    width:350px;
    height:450px;
    border-radius:5px;
    background-color: #ecf0f1;
    transition: 1s;
    box-shadow: -3px 0px 0px 0px #143d8d;
    /* display:none; */
}

.emailBtn.active {
    right: 353px !important;
}

.emailBox.active {
    right: 2px !important;
}

.emailBox header {
    text-align: end;
}

.response_email {
    position:absolute;
    width:100%;
    height:21px;
    text-align:center;
    background-color:#28a745;
    border-bottom-left-radius:5px;
    border-bottom-right-radius:5px;
    top: 0;
    left: 0;
    color: #fff;
    display:none;
}

#failed_email {
    background-color:#dc3545;
}

.input {
    border: none;
    width: 100%;
    height: 35px;
    border-radius: 5px;
    padding: 10px;
    color: black;
    font-size: 12px;
}

.input:focus {
    border: none;
    outline: none;
}

#emailform label {
    color: black;
    font-weight: 100;
    display: block;
    margin-bottom: 2px;
    font-size: 12px;
}

#description {
    height: 120px;
}

#logofooter {
    position: absolute;
    left: 5px;
    bottom: 11px;
    width: 155px;
    height: 31px;
}

#emailform footer {
    position:absolute;
    bottom:15px;
    right:24px;
    background:none !important;
}

#loadingSendMail {
    position:relative;
    left:-10px;
    display:none;
}

#sendMail {
    background-color:#143d8d;
    width:85px;
    height:35px;
    border-radius:5px;
    font-size: 13px;
    border: none;
    color: #fff
}

#sendMail {
    outline: none;
}


/* Chat containers */
.container {
  border: 2px solid #dedede;
  background-color: #f1f1f1;
  border-radius: 5px;
  padding: 10px;
  margin: 10px 0;
   font-size: 12px;
}

/* Darker chat container */
.darker {
  border-color: #ccc;
  background-color: #ddd;
}

/* Clear floats */
.container::after {
  content: "";
  clear: both;
  display: table;
}

/* Style images */
.container img {
  float: left;
  max-width: 60px;
  width: 100%;
  margin-right: 20px;
  border-radius: 50%;
}

/* Style the right image */
.container img.right {
  float: right;
  margin-left: 20px;
  margin-right:0;
}

/* Style time text */
.time-right {
  float: right;
  color: #aaa;
}

/* Style time text */
.time-left {
  float: left;
  color: #999;
}


</style>
</head>
    
<body>
    <div id="newtab" onclick="offnewtab()">
        <div id="text">
            WIP
            <p style="font-size: 14px;">
                <br /> WIP has been open into a new tab, please click to refresh.
            </p>
        </div>
    </div>
    <form id="form1" runat="server">
        <%-- Cooking Stage Modal --%>
        <div class="modal fade" id="CookingStageModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog  modal-xl" role="document">
             <div class="modal-content">
                <div class="modal-header">
                   <h5 class="modal-title" id="CookingStageSelect">Cooking Stage </h5>
                   <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="overflow-y: auto">
                    <div class="row">
                        <div class="col-md-8">
                            <label for="CookingStageBatch" class="form-label">Batch Number: </label>
                            <select class="form-control form-control-sm batch" id="CookingStageBatch" multiple="multiple"></select>
                        </div>
                        <div class="col-md-4">
                            <label for="CookingStageSmokehouse" class="form-label">Smokehouse Number: </label>
                            <input class="form-control form-control-sm" type="number" id="CookingStageSmokehouse" value="" disabled="disabled"/>
                        </div>
                    </div>
                    
                    <div class="table-responsive" style="overflow:auto; height:25rem">
                        <table id='DTbl2' class="table table-centered table-nowrap table-hover mb-0"></table>
                    </div>
                </div>
                <div class="modal-footer">
                   <button id="btnSaveCookingStage" type="button" class="btn btn-info">Save</button>
                   <button id="btnClose" type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
             </div>
          </div>
       </div>
        <%-- New Cooking Stage Modal --%>
        <div class="modal fade" id="NewCookingStageModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog  modal-xl" role="document">
             <div class="modal-content">
                <div class="modal-header">
                   <h5 class="modal-title" id="NewCookingStageSelect">Cooking Stage </h5>
                   <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="overflow-y: auto">
                    <label for="NewCookingStageBatch" class="form-label">Batch Number: </label>
                    <select class="form-control form-control-sm batch" id="NewCookingStageBatch" multiple="multiple"></select>
                    <div class="table-responsive" style="overflow:auto; height:25rem">
                        <table id='DTbl3' class="table table-centered table-nowrap table-hover mb-0"></table>
                    </div>
                </div>
                <div class="modal-footer">
                   <button id="btnNewSaveCookingStage" type="button" class="btn btn-info">Save</button>
                   <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
             </div>
          </div>
       </div>
        <%-- Cooking Stage Select Modal --%>
        <div class="modal fade CookingStageSelectModal" id="CookingStageSelectModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog  modal-sm" role="document">
             <div class="modal-content">
                <div class="modal-header">
                   <h5 class="modal-title" id="CookingStageTitle">CookingStage</h5>
                   <button type="button" class="close" aria-label="Close" data-bs-target="#CookingStageModal" data-bs-toggle="modal">
                      <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <select id="CookStageSelection" class="form-control"></select>
                </div>
                <div class="modal-footer">
                   <button id="btnSaveCookingStageSelect" type="button" class="btn btn-info" data-bs-target="#CookingStageModal" data-bs-toggle="modal">Select</button>
                   <button type="button" class="btn btn-secondary" data-bs-target="#CookingStageModal" data-bs-toggle="modal">Close</button>
                </div>
             </div>
          </div>
       </div>
           <%-- View For Send to Portal Modal --%>
        <div class="modal fade CookingStageSelectModal" id="ViewSendDataModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog  modal-xl" role="document">
             <div class="modal-content">
                <div class="modal-header">
                   <h5 class="modal-title" id="ViewSendDataTitle">FG Dispatch Sent Data</h5>
                   <button type="button" class="close" aria-label="Close" data-bs-target="#ViewSendDataModal" data-bs-toggle="modal">
                      <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="table-responsive" style="overflow:auto; height:40rem ">
                        <table id='DTblV0' class="table table-centered table-nowrap table-hover mb-0"></table>
                    </div>
                </div>
                <div class="modal-footer">
                     <button onclick="Exportsent('DTblV0','')" type="button" class="btn btn-info" >Extract</button>
                     <button onclick="sendto()" type="button" id='btnSendData' class="btn btn-primary ml-2 actionBtn" >Send</button>
                   <button type="button" class="btn btn-secondary" data-bs-target="#ViewSendDataModal" data-bs-toggle="modal">Close</button>
                </div>
             </div>
          </div>
       </div>
        
        <%-- View Sent to Portal Modal --%>
        <div class="modal fade CookingStageSelectModal" id="ViewSentDataModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog  modal-xl" role="document">
             <div class="modal-content">
                <div class="modal-header">
                   <h5 class="modal-title" id="ViewSentDataTitle">FG Dispatch Sent Data</h5>
                   <button type="button" class="close" aria-label="Close" data-bs-target="#ViewSentDataModal" data-bs-toggle="modal">
                      <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="table-responsive" style="overflow:auto; height:40rem ">
                        <table id='DTblV' class="table table-centered table-nowrap table-hover mb-0"></table>
                    </div>
                </div>
                <div class="modal-footer">
                     <button onclick="Exportsent('DTblV','')" type="button" class="btn btn-info" >Extract</button>
                   <button type="button" class="btn btn-secondary" data-bs-target="#ViewSentDataModal" data-bs-toggle="modal">Close</button>
                </div>
             </div>
          </div>
       </div>

        <%-- View ICN Detail Modal --%>
        <div class="modal fade CookingStageSelectModal" id="ViewICNModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog  modal-xl" role="document">
             <div class="modal-content">
                <div class="modal-header">
                   <h5 class="modal-title" id="ViewICNTitle">ICN Detail Data</h5>
                   <button type="button" class="close btnicn" aria-label="Close" data-bs-target="#ViewICNModal" data-bs-toggle="CookingStageSelectModal">
                      <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="table-responsive" style="overflow:auto; height:40rem ">
                        <table id='DTblV2' class="table table-centered table-nowrap table-hover mb-0"></table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button onclick="Export('DTblV2','')" type="button" class="btn btn-info" >Extract</button>
                   <button type="button" class="btn btnicn btn-secondary" data-bs-target="#ViewICNModal" data-bs-toggle="CookingStageSelectModal">Close</button>
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

                             <%-- BUTTON: View for send to Portal --%>
                            <button type="button" id='btnViewSendData' class="btn btn-primary ml-2 d-none" data-toggle="button" aria-pressed="false">
                                <i class="mdi mdi-magnify">View for send to portal</i>
                            </button>
                             <%-- BUTTON: View Sent to Portal --%>
                            <button type="button" id='btnViewSentData' class="btn btn-primary ml-2 d-none" data-toggle="button" aria-pressed="false">
                                <i class="mdi mdi-magnify">View sent data</i>
                            </button>
                             
                             <%-- BUTTON: Send --%>
                            <button type="button" id='btnSendToPortal' class="btn btn-primary ml-2 d-none actionBtn" onclick="SendToPortal();" disabled="disabled">
                                <i class="mdi mdi-truck-fast">Send to Portal</i>
                            </button>
                             <%-- BUTTON: Save --%>
                            <button type="button" id='btnSave' class="btn btn-success ml-2 actionBtn" onclick="Save();" disabled="disabled">
                                <i class="mdi mdi-content-save">Save</i>
                            </button>
                             <%-- BUTTON: Submit --%>
                            <button type="button" id='btnSubmit' class="btn btn-info ml-2 actionBtn" onclick="Submit();" disabled="disabled">
                                <i class="mdi mdi-book">Submit</i>
                            </button>
                              <%-- BUTTON: Submit --%>
                            <button type="button" id='btnPrint' class="btn btn-info ml-2 actionBtn" onclick="Print();" disabled="disabled">
                                <i class="mdi mdi-book">Print</i>
                            </button>
                             <%-- BUTTON: Cancel --%>
                            <button type="button" id='btnCancel' class="btn btn-danger ml-2 actionBtn d-none" onclick="Cancel();" disabled="disabled">
                                <i class="mdi mdi-cancel">Cancel</i>
                            </button>
                         </div>
                      </div>
                      <h4 class="page-title">
                         <a href="..\IT\frmWIPOUTV2.aspx" target="_blank" onclick="onnewtab();">WIP</a>
                         <span id="final" class="badge badge-danger-lighten">Please select the data for Production Date, SKU and Step</span> 
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
                         <h4 class="header-title mb-3">
                            <%-- PARAMETER: Production Date --%>
                            <span style="padding-left:10px">
                                Production Date:
                                <input id="paramDate" class="params" type="date" name="paramDate"/>
                            </span>
                            <%-- PARAMETER: SKU --%>
                            <span style="padding-left:10px">
                                SKU:
                                <select id="paramSKU" class="params" name="paramSKU"></select>
                            </span>
                            <%-- PARAMETER: Step --%>
                            <span style="padding-left:10px">
                                Step:
                                <select id="paramStep" class="params" name="paramStep"></select>
                            </span>
                            <%-- PARAMETER: SAP # --%>
                            <span style="padding-left:10px" class="d-none">
                                SAP#:
                                <input id="SAPNo" class="SAPNo" type="text" name="SAPNo" maxlength="20"/>
                            </span>
                             <%-- BUTTON: View --%>
                            <button type="button" id="btnView" onclick="View();" class="btn btn-success ml-2 actionBtn" disabled="disabled">
                                <i class="mdi mdi-check">View</i>
                            </button>
                             <%-- BUTTON: Generate --%>
                            <button type="button" id="btnGenerate" onclick="Generate();" class="btn btn-info ml-2 actionBtn" disabled="disabled">
                                <i class="mdi mdi-check">Generate</i>
                            </button>
                         </h4>
                         <div class="table-responsive" style="overflow:auto; height:40rem ">
                            <table id='DTbl' class="table table-centered table-nowrap table-hover mb-0"></table>
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

    <script src="../js/PerfSender.js" type="text/javascript"></script> <!-- Common JS -->
    <script src="../js/jquery-3.6.0.min.js"></script> <%-- Jquery JS v3.6.0 --%>
    <script src="../js/select2.min.js" ></script> <%-- Select2 JS --%>
    <%--<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>--%>
    <script src="../js/sweetalert2.min.js" ></script> <%-- SweetAlert2 JS --%>
    <script type="text/javascript" src="../js/moment.min.js"></script> <%-- Moment JS --%>
    <script type="text/javascript" src="../js/daterangepickerv3.14.min.js"></script> <%-- Datepicker JS --%>

    <!-- Datatables js -->
    <!-- JavaScript Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
    <script src="//cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>
    <script src="assets/js/vendor/dataTables.bootstrap4.js"></script>
    <script src="assets/js/vendor/dataTables.responsive.min.js"></script>
   
    <script src="../js/Production/WIPV2.js" ></script> <%-- Custom JS --%>
    <script src="../js/disableIns.js" ></script> <%-- Custom JS --%>
 

</body>
</html>
