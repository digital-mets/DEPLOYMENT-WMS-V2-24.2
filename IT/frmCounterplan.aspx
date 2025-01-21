<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmCounterplan.aspx.cs" Inherits="GWL.IT.frmCounterplan" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>GEARS - Counter Plan</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
    <!-- App css -->
    <link href="assets/css/icons.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/app.min.css" rel="stylesheet" type="text/css" />
    <link href="../Assets/enjoyhint/css/overlay.css" rel="stylesheet" />
     <link href="assets/css/vendor/dataTables.bootstrap4.css" rel="stylesheet" type="text/css" />
<style>
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

    .OLD{ 
        background-color: white;
    }

   .NEW{ 
        background-color: lightblue;
    }

   .smallsku{
       color: red;
   }
  .chicken{
       color: blue;
   }
   .footlong{
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
            Counter Plan
            <p style="font-size: 14px;">
               <br /> Counter Plan has been open into a new tab, please click to refresh.
            </p>

        </div>s
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
                                      <a id='save' href="javascript:  Save();" class="btn btn-success ml-2" style="display:none" >
                                        <i class="mdi mdi-content-save">Save</i>
                                    </a>
                                    <a id='material' href="javascript: cardClick(5,'Material Order');" class="btn btn-info ml-2" >
                                        <i class="mdi mdi-file">Material Order</i>
                                    </a>
  
                                     <a id='import' href="javascript:  cardClick(0,'Export Data');" class="btn btn-warning ml-2" style="display:none">
                                        <i class="mdi mdi-import">Export</i>
                                    </a>
                                    <a id='email' href="javascript:  Dashboard();" class="btn btn-primary ml-2" style="display:none">
                                        <i class="mdi mdi-email">Email</i>
                                    </a>
                                   <a  id='finalize' href="javascript:  final();" class="btn btn-danger ml-2" style="display:none">
                                        <i class="mdi mdi-book">Finalize</i>
                                    </a>
                                </div>
                            </div>
                            <h4 class="page-title">
                                <a href="..\IT\frmCounterplan.aspx" target="_blank" onclick="onnewtab();">Counter Plan</a>
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
                                    <span style="padding-left:10px">
                                    Metric Ton:
                                           <input id="metric" type="number" value="0" style="width:5rem; border-style:none; font-weight: bold;" onchange="TotalGrid();"/>
                                    </span>
                                     <span style="padding-left:10px">
                                    Customer:
                                          <select  name="cars" id="cars" style="border-style:none">
                                        <option value="volvo">ALL</option>
                                        <option value="saab">FBC - Frabelle</option>
     
                                      </select>
                                    </span>

                                   


                                     <span style="padding-left:10px">
                                         Quantity Type:  
                                    <select name="cars" id="unit" style="border-style:none" onchange="ViewCounterPlan()">
                                        <option value="BATCHES">BATCHES</option>
                                        <option value="KILO">KILO</option>
                                        <option value="NO OF LOAD">NO OF LOAD</option>
                                      </select>
                                    </span>

                                </div>

                                <h4 class="header-title mb-3">
                                    
                                  
                                     <span style="padding-left:10px">
                                          Production Site:  
                                    <select name="cars" id="prodsite" style="border-style:none">
                                      </select>
                                    </span>

                                   
                                      <span style="padding-left:10px">
                                    Year:
                                        <select  name="years" id="years" style="border-style:none">
     
                                      </select>
                                    </span>
                                         <span style="padding-left:10px">
                                    WeekNo:
                                          <select  name="week" id="week" style="border-style:none">

     
                                      </select>
                                    </span>
                                      
                                     <a href="javascript:  ViewCounterPlan();" class="btn btn-success ml-2" style="height:2rem; ">
                                        <i class="mdi mdi-check" >View</i>
                                    </a>

                                   <a id="generate" href="javascript:  GenerateCounterPlan();" class="btn btn-info ml-2" style="height:2rem; display:none ">
                                        <i class="mdi mdi-check">Generate</i>
                                    </a>
                                </h4> 
                                <div class="table-responsive" style="overflow:auto; height:25rem " >
                                    <table id='TBDATA' class="table table-centered table-nowrap table-hover mb-0">
                                        <tbody id="CPTABLE">
                                        </tbody>
                                    </table>
                                </div>
                                <!-- end table-responsive-->

                                <div class="table-responsive" style="overflow:auto; height:15rem; background-color:#F1F3FA " >
                                    <table class="table table-centered table-nowrap table-hover mb-0">
                                        <tbody id="totals">
                                             
                                            <tr>
                                                <td style="width:30%">
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Total</a></h5>
                                           
                                                </td>
                                                <td>
                                                   <input id="TotalDay1" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                
                                                <td>
                                                   <input id="TotalDay2" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                   <input id="TotalDay3" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                   <input id="TotalDay4" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                   <input id="TotalDay5" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                   <input id="TotalDay6" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                   <input id="TotalDay7" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                       <td>
                                                   <input id="Total" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                  
                                                   
                                                </td>
                                             
                                            </tr>
                                         <tr>
                                                <td>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Total Orders</a></h5>
                
                                                   
                                                </td>
                                                <td>
                                                   <input id="MODay1" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                
                                                <td>
                                                   <input id="MODay2" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                   <input id="MODay3" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                   <input id="MODay4" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                   <input id="MODay5" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                   <input id="MODay6" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                   <input id="MODay7" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                       <td>
                                                   <input  id="TotalMO" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                   
                                                   
                                                </td>
                                              
                                                <td class="table-action" style="width: 90px;">
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi  mdi-open-in-app"></i></a>
                                                </td>
                                            </tr>

                                              <tr>
                                                <td>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body"></a></h5>
                                                    
                                                </td>
                                                <td id="diff1">
                                                    <span class="text-success mr-2">
                                                       <i class="mdi mdi-arrow-up-bold">
                                                       </i> 5
                                                   </span>
                                                   
                                                </td>
                                                
                                                <td id="diff2">
                                                    <span class="text-danger mr-2">
                                                       <i class="mdi mdi-arrow-down-bold">
                                                       </i> 5
                                                   </span>                                                   
                                                </td>
                                                <td id="diff3">
                                                    <span class="text-success mr-2">
                                                       <i class="mdi mdi-arrow-up-bold">
                                                       </i> 5
                                                   </span>                                                   
                                                </td>
                                                <td id="diff4">
                                                    <span class="text-danger mr-2">
                                                       <i class="mdi mdi-arrow-down-bold">
                                                       </i> 5
                                                   </span>                                                   
                                                </td>
                                                <td id="diff5">
                                                    <span class="text-danger mr-2">
                                                       <i class="mdi mdi-arrow-down-bold">
                                                       </i> 5
                                                   </span>                                                   
                                                </td>
                                                <td id="diff6">
                                                    <span class="text-danger mr-2">
                                                       <i class="mdi mdi-arrow-down-bold">
                                                       </i> 5
                                                   </span>                                                   
                                                </td>
                                                <td id="diff7">
                                                    <span class="text-danger mr-2">
                                                       <i class="mdi mdi-arrow-down-bold">
                                                       </i> 5
                                                   </span>                                                   
                                                </td>
                                                       <td id="difftot">
                                                    <span class="text-danger mr-2">
                                                       <i class="mdi mdi-arrow-down-bold">
                                                       </i> 5
                                                   </span>                                                   
                                                </td>
                                                <td>
                                                                                                     
                                                </td>
                                             
                                                <td class="table-action" style="width: 90px;">
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi  mdi-open-in-app"></i></a>
                                                </td>
                                            </tr>

                                              <tr id="chz">
                                                <td>
                                    
                                                       <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Percent with Cheese</a>

                                                              <span class="badge badge-warning-lighten">C</span>
                                                       </h5>
                                                </td>
                                                <td>
                                                   <input id="ChzDay1" type="text" readonly="true" value="0%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                
                                                <td>
                                                    <input id="ChzDay2" type="text" readonly="true" value="0%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                    <input id="ChzDay3" type="text" readonly="true" value="0%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                     <input id="ChzDay4" type="text" readonly="true" value="0%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                    <input id="ChzDay5" type="text" readonly="true" value="0%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                      <input id="ChzDay6" type="text" readonly="true" value="0%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                     <input id="ChzDay7" type="text" readonly="true" value="0%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                       <td>
                                                     <input id="ChzDayTotal" type="text" readonly="true" value="0%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                    
                                                   
                                                </td>
                                              
                                                <td class="table-action" style="width: 90px;">
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi  mdi-open-in-app"></i></a>
                                                </td>
                                            </tr>

                                              <tr>
                                                <td>
                                                      <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Percent Small SKU</a>
                                                             <span class="badge badge-danger-lighten">S</span>

                                                      </h5>
                                                </td>
                                                <td>
                                                    <input id="SmallDay1" type="text" readonly="true" value="0%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                
                                                <td>
                                                     <input id="SmallDay2" type="text" readonly="true" value="0%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                     <input id="SmallDay3" type="text" readonly="true" value="8%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                    <input id="SmallDay4" type="text" readonly="true" value="0%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                    <input id="SmallDay5" type="text" readonly="true" value="0%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                     <input id="SmallDay6" type="text" readonly="true" value="0%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                   <input id="SmallDay7" type="text" readonly="true" value="0%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                       <td>
                                                    <input id="SmallDayTotal" type="text" readonly="true" value="0%" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                   
                                                   
                                                </td>
                                              
                                                <td class="table-action" style="width: 90px;">
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi  mdi-open-in-app"></i></a>
                                                </td>
                                            </tr>

                                              <tr>
                                                <td>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">Total Metric Ton</a></h5>
                                                </td>
                                                <td>
                                                   <input id="TMTDay1" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                
                                                <td>
                                                  <input id="TMTDay2" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                  <input id="TMTDay3" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                  <input id="TMTDay4" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                  <input id="TMTDay5" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                <input id="TMTDay6" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                 <input id="TMTDay7" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                 <td>
                                                 <input id="TMTDayTotal" type="number" readonly="true" value="0" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                                <td>
                                                 <input type="number" readonly="true" value="" style="width:5rem; border-style:none; font-weight: bold;"/>
                                                   
                                                </td>
                                             
                                                <td class="table-action" style="width: 90px;">
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi  mdi-open-in-app"></i></a>
                                                </td>
                                            </tr>

                                         

                                         

                                        </tbody>
                                    </table>
                                </div>
                                <span id="date" class="badge badge-danger-lighten"></span> 
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

           <a type="button" class="emailBtn btn btn-default"><div class="emailLabel">Progress Notes</div></a>
          <div class="emailBox">
            <header><button class="messagehide btn btn-default" type="button" name="button"><i class="ri-close-fill"></i></button></header>
            <div class="container-fluid" >
                <div id="success_email" class="container-fluid response_email" style="">
                    Email Sent
                </div>
                <div id="failed_email" class="container-fluid response_email">
                    Failed to send email
                </div>
                <div id="emailform">
                    <div data-ref="offline-name" class="field div-text" style="margin: 0 10px 10px 10px;">
                        <label class="offline-textinput-label" for="name">Notes</label>
                        <div id="notes" style="height:12rem; overflow:auto;">
                           <div class="container darker">
                              <p>Click View First before creating Notes</p>
                              <span class="time-left"></span>
                                <span class="time-right">System Admin</span>
                            </div>

                            

                        </div>
                    </div>
                   
                    <div data-ref="offline-description" class="field div-textarea" style="margin: 9px 0px;">
                        <label class="offline-textarea-label desc_label" for="description">Your Message<span id="required_desc" class="required-symbol">*</span></label>
                        <textarea class="input" id="description" name="description" type="textarea" label="Your Message" placeholder="Place your notes in here" required="true"></textarea>
                    </div>
                    
                    <footer>
                        <img id="loadingSendMail" src="./img/gif/loading.gif" alt="">
                        <button id="sendMail" type="button" onclick="SaveNotes();" name="button">Save</button>
                    </footer>
                </div>
            </div>
        </div><!-- End Email -->

    </form>



    <!-- Common JS -->
    <script src="../js/PerfSender.js" type="text/javascript"></script>


    <!-- bundle -->
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

         var DBData 
         var cheeselimit = 999;
         var smalllimit = 999;
    var tChar = new Set(["SupplierCode", "AddedBy", "LastEditedBy"
    , "PostedBy", "SubmittedBy", "CancelledBy", "ReversedBy"
    , "ItemCode", "AccountNo", "CheckNumber", "AccountCode"
    , "CostCenter", "CostCenterCode", "ProfitCenter", "ProfitCenterCode"
    , "Field1", "Field2", "Field3", "Field4", "Field5", "Field6"
    , "Field7", "Field8", "Field9", "ColorCode", "ClassCode", "SizeCode"
    , "Docnumber", "Remarks","ORNumber","DocNumber","PlateNumber"


         ])

      document.addEventListener("DOMContentLoaded", () => {

          Parameters();
          
         });

             // Email Button
    $('.emailBtn').click(function(e) {
        $(this).toggleClass('active');
        $('.emailBox').toggleClass('active');
    });

          function Parameters() {
            let items;
            
            var vUserID = '<%=Session["userid"] %>';
           var vProductionSite = 'MLI';
           var vYear = '2021';
           var vWorkWeek = '1';
           var vLevel = '1';
           var vParams = '';
           // var vParam = $("#dash-period").val();
           
          
            
            fetch('frmCounterplan.aspx/Parameter', {
                method: "POST",
                async: true,
                body: JSON.stringify({  UserID: vUserID  }),
                headers: {
                    "Content-Type": "application/json"
                },
            }).then(function (response) {
                return response.json()
            }).then(function (data) {
               
         

                
                dataN = JSON.parse(data.d[0]);
                table = "";
                for (var i = 0; i < dataN.length; i++) {
                    table += " <option value='"+dataN[i].ProductionSite+"'>"+dataN[i].ProductionSite+"</option>";
                }
                 $('#prodsite').append(table);
               
                dataN = JSON.parse(data.d[1]);
                table = "";
                for (var i = 0; i < dataN.length; i++) {
                    table += " <option value='"+dataN[i].ProductionSite+"'>"+dataN[i].Year+"</option>";
                }
                $('#years').append(table);

                dataN = JSON.parse(data.d[2]);
                table = "";
                for (var i = 0; i < dataN.length; i++) {
                    table += " <option value='"+dataN[i].ProductionSite+"'>"+dataN[i].WorkWeek+"</option>";
                }
                 $('#week').append(table);

            }

            ).catch(function (error) {
                console.log(error);
                })

            $.ajax({
                type: "POST",
                data: JSON.stringify({ Code: "CHEESE" }),
                url: "/PerformSender.aspx/SS",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    cheeselimit = result.d;
                }

              });

            $.ajax({
                type: "POST",
                data: JSON.stringify({ Code: "SMALLSKU" }),
                url: "/PerformSender.aspx/SS",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    smalllimit = result.d;
                }

              });

                $.ajax({
                type: "POST",
                data: JSON.stringify({ Code: "METRIC" }),
                url: "/PerformSender.aspx/SS",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    $('#metric').val(result.d);
                }

              });

         }

     
          function cardClick(type, title, withselect=0) {
         
        var objDetails = JSON.parse(DBData[type]);
        console.log(objDetails);
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

                          if (j == 0 && withselect == 1) {
                              let td = document.createElement("td");
                              let ti = document.createElement("input");
                              ti.setAttribute("type", "checkbox");

                              td.appendChild(ti);
                              bTr.appendChild(td);
                          } else {
                              let td = document.createElement("td");

                              if (isNaN(objDetails[i][col[j]]) || objDetails[i][col[j]] == null || objDetails[i][col[j]] == true || objDetails[i][col[j]] == false) {

                                  td.innerHTML = objDetails[i][col[j]];
                                  if (Object.prototype.toString.call(objDetails[i][col[j]]) === "[object String]" && (objDetails[i][col[j]]).substring((objDetails[i][col[j]]).length - 4) === "0:00") {
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
                      "pageLength": 20,

                      "autoWidth": false,
                      "columnDefs": [{

                          "searchable": true,
                          "orderable": false,

                      }],
                  });


              }
              else {
                  alert('No Data to be Extract');
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

         

         
         
        function GenerateCounterPlan() {
            let items;
            
            var vUserID = '<%=Session["userid"] %>';

           var e = document.getElementById("prodsite");
           var strUser = e.options[e.selectedIndex].text;
           var vProductionSite = strUser;

           e = document.getElementById("years");
           strUser = e.options[e.selectedIndex].text;
           var vYear = strUser;

           e = document.getElementById("week");
           strUser = e.options[e.selectedIndex].text;
           var vWorkWeek = strUser;

           // var vParam = $("#dash-period").val();
           
            
            
            fetch('frmCounterplan.aspx/GenerateCounterPlan', {
                method: "POST",
                async: true,
                body: JSON.stringify({  ProductionSite: vProductionSite , Year: vYear, WorkWeek: vWorkWeek, UserID: vUserID  }),
                headers: {
                    "Content-Type": "application/json"
                },
            }).then(function (response) {
                return response.json()
                }).then(function (data) {
               
                    alert("Successfully Generated");               
                ViewCounterPlan();
            }

            ).catch(function (error) {
               alert(error);
                })

            

        }


       function ViewCounterPlan() {
            let items;
            
           var vUserID = '<%=Session["userid"] %>';

           var e = document.getElementById("prodsite");
           var strUser = e.options[e.selectedIndex].text;
           var vProductionSite = strUser;

           e = document.getElementById("years");
           strUser = e.options[e.selectedIndex].text;
           var vYear = strUser;

           e = document.getElementById("week");
           strUser = e.options[e.selectedIndex].text;
           var vWorkWeek = strUser;


           var vLevel = '1';
           var readonly = '';
           e = document.getElementById("unit");
           strUser = e.options[e.selectedIndex].text;
           var vParams = strUser;
           // var vParam = $("#dash-period").val();

           

           var TotalDay1 = 0, TotalDay2 = 0, TotalDay3 = 0, TotalDay4 = 0, TotalDay5 = 0, TotalDay6 = 0, TotalDay7 = 0 ;            
            var MOTotalDay1 = 0, MOTotalDay2 = 0, MOTotalDay3 = 0, MOTotalDay4 = 0, MOTotalDay5 = 0, MOTotalDay6 = 0, MOTotalDay7 = 0 ;     
          
            
            fetch('frmCounterplan.aspx/ViewCounterPlan', {
                method: "POST",
                //body: "{}",
                async: true,
                body: JSON.stringify({ ProductionSite: vProductionSite , Year: vYear, WorkWeek: vWorkWeek, UserID: vUserID, Level: vLevel, Params: vParams  }),
                headers: {
                    "Content-Type": "application/json"
                },
            }).then(function (response) {
                return response.json()
            }).then(function (data) {
               
           
                DBData = data.d;
                //Initial
                $('#CPTABLE').empty();
                $("#final").html("");
                document.getElementById("final").className = "badge badge-danger-lighten";
                document.getElementById("generate").style.display = "unset";
                
                document.getElementById("import").style.display = "unset";
                document.getElementById("email").style.display = "unset";
                document.getElementById("finalize").style.display = "unset";

                if (JSON.parse(data.d[3]).length == 0) {
                    alert("Counter Plan for the Week:"+vWorkWeek+" Year:"+vYear+" Site:"+vProductionSite+" is not yet created, please click Generate to extract MO Details");
                    return;

                }

                if (JSON.parse(data.d[3])[0].Status == 'F')
                {
                    $("#final").html("This Work week [" + vWorkWeek + "-" + vYear + "] of [" + vProductionSite + "] is already locked for editting. <br> Generate["+JSON.parse(data.d[3])[0].GeneratedDate+"] Finalized["+JSON.parse(data.d[3])[0].SubmittedDate+"]");
                    $("#date").html("Generate["+JSON.parse(data.d[3])[0].GeneratedDate+"] Finalized["+JSON.parse(data.d[3])[0].SubmittedDate+"]");

                    document.getElementById("final").className = "badge badge-success-lighten";
                    document.getElementById("generate").style.display = "none";
                    document.getElementById("import").style.display = "none";
                    
                    document.getElementById("save").style.display = "none";
                    document.getElementById("finalize").style.display = "none";
                    readonly = 'readonly'

                }
               else {
                    $("#final").html("This Work week [" + vWorkWeek + "-" + vYear + "] of [" + vProductionSite + "] is open for editting.");
                    $("#date").html("Generate Date["+JSON.parse(data.d[3])[0].GeneratedDate+"] Finalized Date["+JSON.parse(data.d[3])[0].SubmittedDate+"]");
                    document.getElementById("finalize").style.display = "unset";
                    document.getElementById("save").style.display = "unset";
                    if (vParams == 'BATCHES') {
                        readonly = ''
                    } else {
                        readonly = 'readonly'
                    }
                }

               // $("#param").html("Date: " + left(JSON.parse(data.d[3])[0].DateFrom,10) + "-" + left(JSON.parse(data.d[3])[0].DateTo,10));
                $("#metric").val(JSON.parse(data.d[3])[0].MetricTon);
                dataN = JSON.parse(data.d[0]);

                
                table = "";
                table += "<tr>"
                table += "	<th  style='width:30%'>"
                table += " <a>SKU</a>"
                table += "	</th>"
                table += "	<th>"
                table += "  <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>"+JSON.parse(data.d[1])[0].Day1w+"</a></h5>"
                table += "  <span class='text-muted font-13'>"+JSON.parse(data.d[1])[0].Day1+"</span>"
                table += "	</th>"
                table += "	<th>"
                table += "  <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>"+JSON.parse(data.d[1])[0].Day2w+"</a></h5>"
                table += "  <span class='text-muted font-13'>"+JSON.parse(data.d[1])[0].Day2+"</span>"
                table += "	</th>"
                table += "	<th>"
                table += "  <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>"+JSON.parse(data.d[1])[0].Day3w+"</a></h5>"
                table += "  <span class='text-muted font-13'>"+JSON.parse(data.d[1])[0].Day3+"</span>"
                table += "	</th>"
                table += "	<th>"
                table += "  <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>"+JSON.parse(data.d[1])[0].Day4w+"</a></h5>"
                table += "  <span class='text-muted font-13'>"+JSON.parse(data.d[1])[0].Day4+"</span>"
                table += "	</th>"
                  table += "	<th>"
                table += "  <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>"+JSON.parse(data.d[1])[0].Day5w+"</a></h5>"
                table += "  <span class='text-muted font-13'>"+JSON.parse(data.d[1])[0].Day5+"</span>"
                table += "	</th>"
                table += "	<th>"
                table += "  <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>"+JSON.parse(data.d[1])[0].Day6w+"</a></h5>"
                table += "  <span class='text-muted font-13'>"+JSON.parse(data.d[1])[0].Day6+"</span>"
                table += "	</th>"
                table += "	<th>"
                table += "  <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>"+JSON.parse(data.d[1])[0].Day7w+"</a></h5>"
                table += "  <span class='text-muted font-13'>"+JSON.parse(data.d[1])[0].Day7+"</span>"
                table += "	</th>"
                table += "	<th>"
                table += "  <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>Total</a></h5>"
                table += "  <span class='text-muted font-13'>in "+vParams+"</span>"
                table += "	</th>"
                table += " <th>"
                table += "  <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>Total Order</a></h5>"
                table += "  <span class='text-muted font-13'>in "+vParams+"</span>"
                table += "	</th>"
                table += "	<th></th>"
                table += "	</tr>  "



                $('#CPTABLE').append(table);
                console.log(dataN);
                for (var i = 0; i < dataN.length; i++) {
                table = "";

                    var style = dataN[i].PackagingType + " " + (dataN[i].WithCheese ? 'cheese' : '') + " " + (dataN[i].SmallSKU ? 'smallsku' : '') + " " + (dataN[i].Chicken ? 'chicken' : '') + " " + (dataN[i].Footlong ? 'footlong' : '')+" ";

                         table+="  <tr id='" + dataN[i].ItemCode+dataN[i].PackagingType+ "' class='"+dataN[i].PackagingType+"'>"
                        table+="	<td >"
                        table+="   <h5 class='font-14 my-1'><a style='display:none; word-wrap: break-word;'>"+dataN[i].RecordID+"</a>" + dataN[i].ItemCode+'-'+dataN[i].ShortDesc.substring(0,40)+ "</h5>"
                        table+="   <span class='text-muted font-13' >" + dataN[i].FullDesc+ "</span>"
                        if (dataN[i].WithCheese) { table += "   <span class='badge badge-warning-lighten'>C</span>" };
                        if (dataN[i].SmallSKU) { table += "   <span class='badge badge-danger-lighten'>S</span>" };
                        if (dataN[i].Chicken) { table += "   <span class='badge badge-info-lighten'>K</span>" };
                        if (dataN[i].Footlong) { table += "   <span class='badge badge-success-lighten'>F</span>" };

                        table+="	</td>"
                        table+="	<td>"
                        table+="  <a><input id='"+ dataN[i].RecordID+'-'+'1'+"' type='number' name='"+dataN[i].UnitFactor+"' class='day1 "+style+" ' style='width:5rem; border-style:none; font-weight: bold; ' "+readonly+" /></a>"
                        table+="	</td>"
                        table+="	<td>"
                        table+="  <a><input id='"+ dataN[i].RecordID+'-'+'2'+"' type='number' name='"+dataN[i].UnitFactor+"' class='day2 "+style+" ' style='width:5rem; border-style:none; font-weight: bold; ' "+readonly+"/></a>"
                        table+="	</td>"
                        table+="	<td>"
                        table+="  <a><input id='"+ dataN[i].RecordID+'-'+'3'+"' type='number' name='"+dataN[i].UnitFactor+"' class='day3 "+style+" ' style='width:5rem; border-style:none; font-weight: bold; ' "+readonly+"/></a>"
                        table+="	</td>"
                        table+="	<td>"
                        table+="  <a><input id='"+ dataN[i].RecordID+'-'+'4'+"' type='number' name='"+dataN[i].UnitFactor+"' class='day4 "+style+" ' style='width:5rem; border-style:none; font-weight: bold; ' "+readonly+"/></a>"
                        table+="	</td>"
                        table+="	<td>"
                        table+="  <a><input id='"+ dataN[i].RecordID+'-'+'5'+"' type='number' name='"+dataN[i].UnitFactor+"' class='day5 "+style+" ' style='width:5rem; border-style:none; font-weight: bold; ' "+readonly+"/></a>"
                        table+="	</td>"
                        table+="	<td>"
                        table+="  <a><input id='"+ dataN[i].RecordID+'-'+'6'+"' type='number' name='"+dataN[i].UnitFactor+"' class='day6 "+style+" ' style='width:5rem; border-style:none; font-weight: bold; ' "+readonly+"/></a>"
                        table+="	</td>"
                        table+="	<td>"
                        table+="  <a><input id='"+ dataN[i].RecordID+'-'+'7'+"' type='number' name='"+dataN[i].UnitFactor+"' class='day7 "+style+" ' style='width:5rem; border-style:none; font-weight: bold; ' "+readonly+"/></a>"
                        table+="	</td>"
                        table+="      <td>"
                        table+="  <input id='"+ dataN[i].RecordID+'-'+'TOTAL'+"'  class='total "+style+"'  style='width:5rem; border-style:none; background-color: unset; font-weight: bold;' readonly />"
                        table+="	</td>"
                        table+="	<td>"
                        table+="  <span id='"+ dataN[i].RecordID+'-'+'MO'+"' style='width:5rem; border-style:none; font-weight: bold;' class='"+style+"'>" + dataN[i].TotalMO+ "</span>"
                        table+="  "
                        table+="	</td>"
                        table+="	<td id='"+ dataN[i].RecordID+'-'+'VAR'+"' class='table-action' style='width: 90px;'>"
                        table+="  <span class='text-danger mr-2'>"
                        table+="      "
                        table+="      </i>  "
                        table+="  </span>"
                        table+="	</td>"
                        table+="</tr>"


                            
                    TotalDay1 += dataN[i].Day1;    
                    TotalDay2 += dataN[i].Day2;    
                    TotalDay3 += dataN[i].Day3;    
                    TotalDay4 += dataN[i].Day4;    
                    TotalDay5 += dataN[i].Day5;    
                    TotalDay6 += dataN[i].Day6;    
                    TotalDay7 += dataN[i].Day7;    

                    MOTotalDay1 += dataN[i].MODay1;    
                    MOTotalDay2 += dataN[i].MODay2;    
                    MOTotalDay3 += dataN[i].MODay3;    
                    MOTotalDay4 += dataN[i].MODay4;    
                    MOTotalDay5 += dataN[i].MODay5;    
                    MOTotalDay6 += dataN[i].MODay6;    
                    MOTotalDay7 += dataN[i].MODay7;  

                                
                    $('#CPTABLE').append(table);
                    document.getElementById(dataN[i].RecordID + '-1').value = dataN[i].Day1;
                    document.getElementById(dataN[i].RecordID + '-2').value = dataN[i].Day2;
                    document.getElementById(dataN[i].RecordID + '-3').value = dataN[i].Day3;
                    document.getElementById(dataN[i].RecordID + '-4').value = dataN[i].Day4;
                    document.getElementById(dataN[i].RecordID + '-5').value = dataN[i].Day5;
                    document.getElementById(dataN[i].RecordID + '-6').value = dataN[i].Day6;
                    document.getElementById(dataN[i].RecordID + '-7').value = dataN[i].Day7;
                    document.getElementById(dataN[i].RecordID + '-TOTAL').value = (dataN[i].Day1 + dataN[i].Day2 + dataN[i].Day3 + dataN[i].Day4 + dataN[i].Day5 + dataN[i].Day6 + dataN[i].Day7).toFixed(2);
                   
                }

                $('#TotalDay1').val(TotalDay1.toFixed(2));   
                $('#TotalDay2').val(TotalDay2.toFixed(2));   
                $('#TotalDay3').val(TotalDay3.toFixed(2));   
                $('#TotalDay4').val(TotalDay4.toFixed(2));   
                $('#TotalDay5').val(TotalDay5.toFixed(2));   
                $('#TotalDay6').val(TotalDay6.toFixed(2));   
                $('#TotalDay7').val(TotalDay7.toFixed(2));   

                $('#MODay1').val(MOTotalDay1.toFixed(2));   
                $('#MODay2').val(MOTotalDay2.toFixed(2));   
                $('#MODay3').val(MOTotalDay3.toFixed(2));   
                $('#MODay4').val(MOTotalDay4.toFixed(2));   
                $('#MODay5').val(MOTotalDay5.toFixed(2));   
                $('#MODay6').val(MOTotalDay6.toFixed(2));   
                $('#MODay7').val(MOTotalDay7.toFixed(2));   
               
                
                TotalGrid();

                //Notes
                ViewNotes();

            }

            ).catch(function (error) {
                console.log(error);
                })

            
           
         }

         function ViewNotes() {

                        let items;
            
           var vUserID = '<%=Session["userid"] %>';

           var e = document.getElementById("prodsite");
           var strUser = e.options[e.selectedIndex].text;
           var vProductionSite = strUser;

           e = document.getElementById("years");
           strUser = e.options[e.selectedIndex].text;
           var vYear = strUser;

           e = document.getElementById("week");
           strUser = e.options[e.selectedIndex].text;
           var vWorkWeek = strUser;


           var vLevel = '1';
           var readonly = '';
           e = document.getElementById("unit");
           strUser = e.options[e.selectedIndex].text;
           var vParams = strUser;
           // var vParam = $("#dash-period").val();

            
             fetch('frmCounterplan.aspx/ViewNotes', {
                 method: "POST",
                 //body: "{}",
                 async: true,
                 body: JSON.stringify({ ProductionSite: vProductionSite, Year: vYear, WorkWeek: vWorkWeek, UserID: vUserID, Level: vLevel, Params: vParams }),
                 headers: {
                     "Content-Type": "application/json"
                 },
             }).then(function (response) {
                 return response.json()
             }).then(function (data) {

                 var dataN = JSON.parse(data.d[4]);
                 var table = "";
                 for (var i = 0; i < dataN.length; i++) {

                     today = new Date(dataN[i].DateTime);
                     table += "<div class='container darker'>"
                     table += "<p>" + dataN[i].Message + "</p>"
                     table += "<span class='time-left'>" + today.toLocaleDateString("en-US") + "</span>"
                     table += "<span class='time-right'>" + dataN[i].UserName + "</span>"
                     table += "</div>"

                 }

                 $('#notes').html(table);
                 var objDiv = document.getElementById("notes");
                objDiv.scrollTop = objDiv.scrollHeight;
                 }
                 ).catch(function (error) {
                console.log(error);
                })
         }

         $('#CPTABLE').change(function (ev)
         {
             console.log('start');
             console.log(ev.target.id);

             console.log(ev.target.id.substring(0, ev.target.id.length - 2) + '-TOTAL');
             var Cid = ev.target.id.substring(0, ev.target.id.length - 2);

             var CTotal = parseInt(document.getElementById(Cid + '-1').value) +
                 parseInt(document.getElementById(Cid + '-2').value) +
                 parseInt(document.getElementById(Cid + '-3').value) +
                 parseInt(document.getElementById(Cid + '-4').value) +
                 parseInt(document.getElementById(Cid + '-5').value) +
                 parseInt(document.getElementById(Cid + '-6').value) +
                 parseInt(document.getElementById(Cid + '-7').value);


             document.getElementById(Cid + '-TOTAL').value = CTotal;
             var MOTot = parseInt(document.getElementById(Cid + '-MO').innerHTML);


            if (parseFloat(CTotal.toFixed(2)) > parseFloat(MOTot.toFixed(2))) {
                     diff = "<span class='text-success mr-2'><i class='mdi mdi-arrow-up-bold'></i> " +(CTotal.toFixed(2) -MOTot.toFixed(2)) + " </span>"
                 }
                 else if (parseFloat(CTotal.toFixed(2)) == parseFloat(MOTot.toFixed(2))) {
                     diff = "<span class=' mr-2'><i class=''></i> " + (CTotal.toFixed(2) -MOTot.toFixed(2))  + " </span>"
                 } else {
                     diff = "<span class='text-danger mr-2'><i class='mdi mdi-arrow-down-bold'></i> "+(CTotal.toFixed(2) -MOTot.toFixed(2)) +" </span>"
             }


             $('#' + Cid + '-VAR').html(diff);




              if (ev.target.classList.contains('day1'))
              { var total = 0;  $('.day1').each(function ()  { total += Number($(this).val()) || 0; });
                  $('#TotalDay1').val(total.toFixed(2));
                
             }
              if (ev.target.classList.contains('day2'))
              { var total = 0;  $('.day2').each(function ()  { total += Number($(this).val()) || 0; });
                 $('#TotalDay2').val(total.toFixed(2));
             }
              if (ev.target.classList.contains('day3'))
              { var total = 0;  $('.day3').each(function ()  { total += Number($(this).val()) || 0; });
                 $('#TotalDay3').val(total.toFixed(2));
             }
              if (ev.target.classList.contains('day4'))
              { var total = 0;  $('.day4').each(function ()  { total += Number($(this).val()) || 0; });
                 $('#TotalDay4').val(total.toFixed(2));
             }
              if (ev.target.classList.contains('day5'))
              { var total = 0;  $('.day5').each(function ()  { total += Number($(this).val()) || 0; });
                 $('#TotalDay5').val(total.toFixed(2));
             }
              if (ev.target.classList.contains('day6'))
              { var total = 0;  $('.day6').each(function ()  { total += Number($(this).val()) || 0; });
                 $('#TotalDay6').val(total.toFixed(2));
             }
              if (ev.target.classList.contains('day7'))
              { var total = 0;  $('.day7').each(function ()  { total += Number($(this).val()) || 0; });
                 $('#TotalDay7').val(total.toFixed(2));
             }


            
             TotalGrid();
         });

      

         function TotalGrid() {
             Total = 0.00;
             TotalOrder = 0.00;
             totalChz = 0;
             totalsml = 0;
             totalMT = 0;

             for (var a = 1; a <= 7; a++)
             {
                 Total += parseFloat($("#TotalDay" + a).val());
                 TotalOrder += parseFloat($("#MODay" + a).val());
                 
                 var diff = "";
                
                 if (parseFloat($("#TotalDay" + a).val()) > parseFloat($("#MODay" + a).val())) {
                     diff = "<span class='text-success mr-2'><i class='mdi mdi-arrow-up-bold'></i> " + (parseFloat($("#TotalDay" + a).val()) - parseFloat($("#MODay" + a).val())).toFixed(2) + " </span>"
                 }
                 else if (parseFloat($("#TotalDay" + a).val()) == parseFloat($("#MODay" + a).val())) {
                     diff = "<span class=' mr-2'><i class=''></i> " + (parseFloat($("#TotalDay" + a).val()) - parseFloat($("#MODay" + a).val())).toFixed(2) + " </span>"
                 } else {
                     diff = "<span class='text-danger mr-2'><i class='mdi mdi-arrow-down-bold'></i> "+(parseFloat($("#TotalDay" + a).val()) - parseFloat($("#MODay" + a).val())).toFixed(2)+" </span>"
                 }
                
                 $('#diff' + a).html(diff);


                 //CHEESE
                     var total = 0; $('.cheese').each(function () {
                         if ($(this)[0].classList.contains('day'+a)) {
                             total += Number($(this).val()) || 0;
                             totalChz +=Number($(this).val()) || 0;
                         }
                         
                     });
                 var perc = (total / $('#TotalDay' + a).val())*100;
                 $('#ChzDay' + a).val(perc.toFixed(0) + '%');
                 if (perc > cheeselimit) {
                   
                      $('#ChzDay' + a).css("color","red");
                 }
                 else {
                       $('#ChzDay' + a).css("color","black");
                 }

                 //SMALLSKU
                     var total = 0; $('.smallsku').each(function () {
                         if ($(this)[0].classList.contains('day'+a)) {
                             total += Number($(this).val()) || 0;
                             totalsml +=Number($(this).val()) || 0;
                         }
                         
                     });
                 var perc = (total / $('#TotalDay' + a).val())*100;
                 $('#SmallDay' + a).val(perc.toFixed(0) + '%');
                 if (perc > smalllimit) {
                   
                      $('#SmallDay' + a).css("color","red");
                 }
                 else {
                       $('#SmallDay' + a).css("color","black");
                 }

        
                 total = 0;
                 $('.day' + a).each(function () {
                     if ($('#unit').val() == "KILO") {
                         total += (Number($(this).val()) * 0.001)
                     } else if ($('#unit').val() == "BATCHES") {
                          total += (Number($(this).val()) * Number($(this)[0].name))* 0.001 ;
                     }
                 });

                 $('#TMTDay' + a).val(total.toFixed(2));
                 totalMT += Number(total.toFixed(2));

                 
                 if (Number( $('#TMTDay'+a).val()) >  Number($('#metric').val())) {
                   
                      $('#TMTDay'+a).css("color","red");
                 }
                 else {
                       $('#TMTDay'+a).css("color","black");
                 }


             }
           
              $('#TMTDayTotal').val(totalMT.toFixed(2));
            

             $('#Total').val(Total.toFixed(2));
             $('#TotalMO').val(TotalOrder.toFixed(2));
             $('#ChzDayTotal').val(((totalChz/Total)*100).toFixed(0)+'%');

                 if ( $('#ChzDayTotal').val() > cheeselimit) {
                   
                      $('#ChzDayTotal').css("color","red");
                 }
                 else {
                       $('#ChzDayTotal').css("color","black");
                 }

              $('#SmallDayTotal').val(((totalsml/Total)*100).toFixed(0)+'%');

                 if ( $('#SmallDayTotal').val() > smalllimit) {
                   
                      $('#SmallDayTotal').css("color","red");
                 }
                 else {
                       $('#SmallDayTotal').css("color","black");
                 }
           
                if (parseFloat(Total.toFixed(2)) > parseFloat(TotalOrder.toFixed(2))) {
                     diff = "<span class='text-success mr-2'><i class='mdi mdi-arrow-up-bold'></i> " +(Total.toFixed(2) - TotalOrder.toFixed(2)) + " </span>"
                 }
                 else if (parseFloat(Total.toFixed(2)) == parseFloat(TotalOrder.toFixed(2))) {
                     diff = "<span class=' mr-2'><i class=''></i> " + (Total.toFixed(2) - TotalOrder.toFixed(2)).toFixed(2)  + " </span>"
                 } else {
                     diff = "<span class='text-danger mr-2'><i class='mdi mdi-arrow-down-bold'></i> "+(Total.toFixed(2) - TotalOrder.toFixed(2)).toFixed(2) +" </span>"
                 }
                
          $('#difftot').html(diff);

         }

         function Save() {
                let items;
            
           var vMetric = $('#metric').val();

           var e = document.getElementById("prodsite");
           var strUser = e.options[e.selectedIndex].text;
           var vProductionSite = strUser;

           e = document.getElementById("years");
           strUser = e.options[e.selectedIndex].text;
           var vYear = strUser;

           e = document.getElementById("week");
           strUser = e.options[e.selectedIndex].text;
           var vWorkWeek = strUser;


           var vLevel = '1';
           var readonly = '';
           e = document.getElementById("unit");
           strUser = e.options[e.selectedIndex].text;
           var vParams = strUser;
           // var vParam = $("#dash-period").val();
          

           
             var text = JSON.stringify(tableToJSON($("#TBDATA")));
                   $.ajax({
                 type: "POST",
                 data:JSON.stringify({  ProductionSite: vProductionSite , Year: vYear, WorkWeek: vWorkWeek, UserID: vMetric,  ItemStr: text }) ,
                    url: "frmCounterplan.aspx/Save",
                    dataType: "json",
                  contentType: "application/json; charset=utf-8",
                  success: function (data) {

                      alert(data.d);

               
                  
                },
                 error: function (data) {
                      alert(data.d);
                   
                }
             });
         
         }


          function SaveNotes() {
                let items;
         
           var vUserID = '<%=Session["userid"] %>';

           var e = document.getElementById("prodsite");
           var strUser = e.options[e.selectedIndex].text;
           var vProductionSite = strUser;

           e = document.getElementById("years");
           strUser = e.options[e.selectedIndex].text;
           var vYear = strUser;

           e = document.getElementById("week");
           strUser = e.options[e.selectedIndex].text;
           var vWorkWeek = strUser;


           var vLevel = '1';
              var readonly = '';

          
              var text = $('#description').val();;
             

           
             

                   $.ajax({
                 type: "POST",
                 data:JSON.stringify({  ProductionSite: vProductionSite , Year: vYear, WorkWeek: vWorkWeek, UserID: vUserID,  Message: text }) ,
                    url: "frmCounterplan.aspx/SaveNotes",
                    dataType: "json",
                  contentType: "application/json; charset=utf-8",
                       success: function (data) {
                         
                           document.getElementById("description").value = "";
                           ViewNotes();
                  
                },
                 error: function (data) {
                      alert(data.d);
                   
                }
             });
         
         }


         var vid;
         function tableToJSON(tblObj){  
               var data = [];
               var $headers = $(tblObj).find("th a");
             var $rows = $(tblObj).find("tbody tr").each(function (index) {

                 //var inputElements = document.getElementById('38-1')
                // console.log(inputElements.value)
               $cells = $(this).find("td a");
               data[index] = {};
                 $cells.each(function (cellIndex) {
                    
                 
                     if (cellIndex == 0) {
                         vid = $(this).html();
                         data[index][$($headers[cellIndex]).html()] = $(this).html();
                     }
                     else {
                         if (document.getElementById(vid + '-' + (parseInt(cellIndex) )) == null) {
                             data[index][$($headers[cellIndex]).html()] =$(this).html();
                         } else {
                             data[index][$($headers[cellIndex]).html()] = document.getElementById(vid + '-' + (parseInt(cellIndex) )).value;
                         }
                     }
                     //console.log('vid:'+vid);
                     // console.log('index:'+cellIndex+1);
                     //console.log(document.getElementById(vid+'-'+(parseInt(cellIndex)+1)).value);
               });    
            });
              return data;
            }

           function final()
         {
             let items;
            
            var vUserID = '<%=Session["userid"] %>';

           var e = document.getElementById("prodsite");
           var strUser = e.options[e.selectedIndex].text;
           var vProductionSite = strUser;

           e = document.getElementById("years");
           strUser = e.options[e.selectedIndex].text;
           var vYear = strUser;

           e = document.getElementById("week");
           strUser = e.options[e.selectedIndex].text;
           var vWorkWeek = strUser;

           // var vParam = $("#dash-period").val();
           
            
            
            fetch('frmCounterplan.aspx/Submit', {
                method: "POST",
                async: true,
                body: JSON.stringify({  ProductionSite: vProductionSite , Year: vYear, WorkWeek: vWorkWeek, UserID: vUserID  }),
                headers: {
                    "Content-Type": "application/json"
                },
            }).then(function (response) {
                return response.json()
            }).then(function (data) {
               
                ViewCounterPlan();
            }

            ).catch(function (error) {
               alert(error);
                })
         }

         

              function numberWithCommas(x) {
            var parts = x.toString().split(".");
                  parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                
            return parts.join(".");
         }

         function right(str, chr) {
  return str.slice(str.length-chr,str.length);
}
 
function left(str, chr) {
  return str.slice(0, chr - str.length);
}
      

         function onnewtab() {
    document.getElementById("newtab").style.display = "block";
        }

function offnewtab() {
    document.getElementById("newtab").style.display = "none";
   window.location.reload();
}

                 
var tableToExcel = (function () {
    var uri = 'data:application/vnd.ms-excel;base64,'
        , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>'
        , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
        , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }
    return function (table, name) {
        if (!table.nodeType) table = document.getElementById(table)
        var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
        window.location.href = uri + base64(format(template, ctx))
    }
})()

function exportTableToExcel(tableID, filename = '') {

    var downloadLink;
    var dataType = 'application/vnd.ms-excel';
    var tableSelect = document.getElementById(tableID);
    var tableHTML = tableSelect.outerHTML.replace(/ /g, '%20');

    // Specify file name
    filename = filename ? filename + '.xls' : 'excel_data.xls';

    // Create download link element
    downloadLink = document.createElement("a");

    document.body.appendChild(downloadLink);

    if (navigator.msSaveOrOpenBlob) {
        var blob = new Blob(['\ufeff', tableHTML], {
            type: dataType
        });
        navigator.msSaveOrOpenBlob(blob, filename);
    } else {
        // Create a link to the file
        downloadLink.href = 'data:' + dataType + ', ' + tableHTML;

        // Setting the file name
        downloadLink.download = filename;

        //triggering the function
        downloadLink.click();
    }
}

    </script>

</body>
</html>
