<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmMaterialPlanning.aspx.cs" Inherits="GWL.IT.frmMaterialPlanning" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>GEARS - Material Requirement Planning</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
    <!-- App css -->
    <link href="assets/css/icons.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/app.min.css" rel="stylesheet" type="text/css" />
    <link href="../Assets/enjoyhint/css/overlay.css" rel="stylesheet" />
     <link href="assets/css/vendor/dataTables.bootstrap4.css" rel="stylesheet" type="text/css" />
<style>
    .table td, .table th {
    padding: .05rem;
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

    td.details-control {
        background: url(https://www.datatables.net/examples/resources/details_open.png) no-repeat center center;
        cursor: pointer;

        transition: .5s;
    }

    tr.shown td.details-control {
        background: url(https://www.datatables.net/examples/resources/details_close.png) no-repeat center center;

        transition: .5s;
    }


    
   /*--------------------------------------------------------------
# Email button
--------------------------------------------------------------*/

.emailBtn {
    position: fixed;
    right: 0;
    width: 20px;
    height: 130px;
    border: none;
    outline: none;
    text-align: center;
    font-weight: 500;
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

.itembutt {
    
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
            Material Requirements Planning
            <p style="font-size: 14px;">
               <br /> MRP has been open into a new tab, please click to refresh.
            </p>

        </div>s
    </div>

    <form id="form1" runat="server">

          <div class="modal fade" id="TotalAssetmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" onshow="fixheader()">
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
                        <button onclick="Generate(ExpType);" type="button" class="btn btn-success" >Generate</button>
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
                                  
                                    <a id='material' href="javascript:   cardClick(0,'Material Request');" class="btn btn-info ml-2" style="display:none">
                                        <i class="mdi mdi-import">Material Request</i>
                                    </a>
                                     <a id='spice' href="javascript: cardClick(1,'Spice Request');" class="btn btn-warning ml-2" style="display:none">
                                        <i class="mdi mdi-import">Spice Request</i>
                                    </a>
                                     <a id='purchase' href="javascript:  cardClick(2,'Purchase Request');" class="btn btn-danger ml-2" style="display:none">
                                        <i class="mdi mdi-import">Purchase Request</i>
                                    </a>
                                    <a id='portal' href="javascript: cardClick(3,'Transfer to Portal');" class="btn btn-primary ml-2" style="display:none">
                                        <i class="mdi mdi-email">Transfer to Portal</i>
                                    </a>
                                   <a id='finalize' href="javascript:  final();" class="btn btn-success ml-2" style="display:none">
                                        <i class="mdi mdi-content-save">Finalize</i>
                                    </a>
                                </div>
                            </div>
                            <h4 class="page-title">
                                <a href="..\IT\frmMaterialPlanning.aspx" target="_blank" onclick="onnewtab();">Material Requirement Planning</a>
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
                                        <a onclick="cardClick(9,'MRP Details')" class="dropdown-item">Extract Details</a>

                                    </div>
                                </div>
                               <div class="label float-right" style="padding-right:10px">
                                    
                                     <span id="param">Year:  Week No: </span>
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
                                      
                                     <a href="javascript:  ViewMRP();" class="btn btn-success ml-2" style="height:2rem; ">
                                        <i class="mdi mdi-check" >View</i>
                                    </a>

                                   <a id="generate" href="javascript:  GenerateMRP();" class="btn btn-info ml-2" style="height:2rem; display:none ">
                                        <i class="mdi mdi-check">Generate</i>
                                    </a>
                                </h4> 

                             

                                <div class="table-responsive" style="overflow:auto; height:25rem " >
                                    <table class="table table-centered table-nowrap table-hover mb-0">
                                        <tbody id="MRPTable" >
                                         
                                    

                                        </tbody>
                                    </table>
                                </div>
                                <!-- end table-responsive-->

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

        
           <a type="button" class="emailBtn notes btn btn-info" style="top: 40%;"><div class="emailLabel">Progress Notes</div></a>

          <div class="emailBox notebox">
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

          <a type="button" class="emailBtn scrap btn btn-danger" id="addnewitem"  style="top: 20%;"><div class="emailLabel">Add New Item</div></a>

         <div class="emailBox scrapbox">
            <header><button class="messagehide btn btn-default" type="button" name="button"><i class="ri-close-fill"></i></button></header>
            <div class="container-fluid" >
                <div id="success_email" class="container-fluid response_email" style="">
                    Email Sent
                </div>
                <div id="failed_email" class="container-fluid response_email">
                    Failed to send email
                </div>
                <div  id="emailform">
                    <div data-ref="offline-name" class="field div-text" style="margin: 0 10px 10px 10px;">
                      
                             <label class="offline-textarea-label desc_label" for="description">Old Item Code (for swap material)</label>
                        <select  id="olditem" name="description"  multiple="multiple" style="border-style: none;"  placeholder="Input Old Item" ></select>

                        
                       
                             <label class="offline-textarea-label desc_label" for="description">Item Code<span  class="required-symbol">*</span></label>
                        <select  id="itemcode" name="description"  multiple="multiple" style="border-style: none;" placeholder="Input Item Code"></select>

                       
                    </div>
                   
                    <div data-ref="offline-description" class="field div-textarea" style="margin: 9px 0px;">
                        <label class="offline-textarea-label desc_label" for="description">Qty Requirement<span id="required_desc" class="required-symbol">*</span></label>
                        <input class="input" id="Qty" name="description" type="number" label="Your Message" placeholder="Qty Requirement" required="true"></input>
                    </div>
                    
                    <footer>
                        <img id="loadingSendMail" src="./img/gif/loading.gif" alt="">
                        <button id="additem" class="itembutt btn-success" type="button" onclick="Item('Add');" name="button">Add</button>
                        <button id="deleteitem" class="itembutt btn-danger" type="button" onclick="Item('Delete');" name="button">Delete</button>
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
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.js"></script>
     <script>

         var  DBData, xDBData
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

  $('#itemcode').multiselect({
                  
                    enableCaseInsensitiveFiltering: true,
                    enableFiltering: true,
                    maxHeight: '300',
                    buttonWidth: '235',
                    onChange: function(element, checked) {
                     itemcode =   this.$select.val();
                    }
         }); 
 $('#olditem').multiselect({
                  
                    enableCaseInsensitiveFiltering: true,
                    enableFiltering: true,
                    maxHeight: '300',
                    buttonWidth: '235',
                    onChange: function(element, checked) {
                        olditem = this.$select.val();

                        if (olditem != "") {
                            $("#Qty").css("display", "none");
                            $("#deleteitem").css("display", "none");
                            $("#additem").html("Swap Item");
                        }
                        else {
                             $("#Qty").css("display", "unset");
                            $("#additem").css("display", "unset");
                             $("#additem").html("Add Item");
                              $("#deleteitem").css("display", "unset");
                        }

                    }
         }); 


                      // Email Button
    $('.notes').click(function(e) {
        $(this).toggleClass('active');
        $('.notebox').toggleClass('active');
         });

     // Email Button
    $('.scrap').click(function(e) {
        $(this).toggleClass('active');
        $('.scrapbox').toggleClass('active');
         });      
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
           
           var vParams = '';
           // var vParam = $("#dash-period").val();

            
             fetch('frmMaterialPlanning.aspx/ViewNotes', {
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
                    url: "frmMaterialPlanning.aspx/SaveNotes",
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


         var ExpType = 0;
         var itemcode = "", olditem = "";
         function cardClick(type, title, withselect = 0) {
           
           
              ExpType = type;
             var objDetails;

             if (type == 9) {
                 objDetails = JSON.parse(xDBData[0]);
             } else {
                 objDetails = JSON.parse(DBData[type]);
             }


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
                      th.setAttribute('id',col[i] );
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
                      "destroy" : true,
                      "scrollX": true,
                      "sScrollY": "310px",
                      "render": true,
                      "pageLength": 20,

                      "autoWidth": false,
                      "columnDefs": [{

                          "searchable": true,
                          "orderable": false,

                      }],
                  }).columns.adjust().draw();


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
           
             //FIX HEADER ALLIGNMENT
            document.getElementById("TotalAssetmodal").setAttribute("onmouseover", "fixheader()");
      
        

        }
        //FIX HEADER ALLIGNMENT
            function fixheader() {
                 document.getElementById("TargetDelivery").click();
                 document.getElementById("TargetDelivery").click();
                 document.getElementById("TotalAssetmodal").removeAttribute("onmouseover");
             }

          function Parameters() {
            let items;
            
            var vUserID = '<%=Session["userid"] %>';
           var vProductionSite = 'MLI';
           var vYear = '2021';
           var vWorkWeek = '1';
           var vLevel = '1';
           var vParams = '';
           // var vParam = $("#dash-period").val();
           
          
            
            fetch('frmMaterialPlanning.aspx/Parameter', {
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


                dataN = JSON.parse(data.d[3]);
                table = "";
                for (var i = 0; i < dataN.length; i++) {
                    table += " <option value='" + dataN[i].ItemCode + "' >" + dataN[i].ItemCode + ' - ' + dataN[i].ShortDesc + "</option>";

                    if (i == 0) {
                      
                    }

                }
               
                //$('#itemcode').append(table);
                //$('#itemcode').multiselect('rebuild'); 

                //$('#olditem').append(table);
                //$('#olditem').multiselect('rebuild'); 
            }

            ).catch(function (error) {
                console.log(error);
                })

            

         }

        function GenerateMRP() {
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
           
            
            
            fetch('frmMaterialPlanning.aspx/GenerateMRP', {
                method: "POST",
                async: true,
                body: JSON.stringify({  ProductionSite: vProductionSite , Year: vYear, WorkWeek: vWorkWeek, UserID: vUserID  }),
                headers: {
                    "Content-Type": "application/json"
                },
            }).then(function (response) {
                return response.json()
            }).then(function (data) {
               
                ViewMRP();
            }

            ).catch(function (error) {
               alert(error);
                })

            

        }


       function ViewMRP() {
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
           var vParams = '';
           // var vParam = $("#dash-period").val();

          
          
            
            fetch('frmMaterialPlanning.aspx/ViewMRP', {
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
               
            xDBData = data.d;
               
                //Initial
                $('#MRPTable').empty();
                $("#final").html("");
                document.getElementById("final").className = "badge badge-danger-lighten";
                document.getElementById("generate").style.display = "unset";
                document.getElementById("spice").style.display = "none";
                document.getElementById("material").style.display = "none";
                document.getElementById("purchase").style.display = "none";
                document.getElementById("portal").style.display = "none";
                document.getElementById("finalize").style.display = "none";
                document.getElementById("addnewitem").style.display = "unset";
                

                ViewNotes();
                
                dataN = JSON.parse(data.d[5]);
              
               
                table = "";
                for (var i = 0; i < dataN.length; i++) {
                    table += " <option value='" + dataN[i].ItemCode + "' >" + dataN[i].ItemCode + ' - ' + dataN[i].ShortDesc + "</option>";

                    if (i == 0) {
                      
                    }

                }
                
                $('#itemcode').append(table);
                $('#itemcode').multiselect('rebuild'); 

               dataN = JSON.parse(data.d[6]);
                table = "";
                for (var i = 0; i < dataN.length; i++) {
                    table += " <option value='" + dataN[i].ItemCode + "' >" + dataN[i].ItemCode + ' - ' + dataN[i].ShortDesc + "</option>";

                    if (i == 0) {
                      
                    }

                }


                $('#olditem').append(table);
                $('#olditem').multiselect('rebuild'); 



                if (JSON.parse(data.d[3]).length == 0) {
                    alert("Material Planning for the Week:"+vWorkWeek+" Year:"+vYear+" Site:"+vProductionSite+" is not yet created, please click Generate to extract MRP Details");
                    return;

                }

                if (JSON.parse(data.d[3])[0].SubmittedBy != null)
                {
                    $("#final").html("This Work week [" + vWorkWeek + "-" + vYear + "] of [" + vProductionSite + "] is already finalized");
                    $("#date").html("Generate["+JSON.parse(data.d[3])[0].GeneratedDate+"] Finalized["+JSON.parse(data.d[3])[0].SubmittedDate+"]");
                    document.getElementById("final").className = "badge badge-success-lighten";
                    document.getElementById("generate").style.display = "none";
                    document.getElementById("spice").style.display = "unset";
                     document.getElementById("material").style.display = "unset";
                    document.getElementById("purchase").style.display = "unset";
                    document.getElementById("portal").style.display = "unset";
                    document.getElementById("finalize").style.display = "none";
                    document.getElementById("addnewitem").style.display = "none";

                }
               else {
                    $("#final").html("This Work week [" + vWorkWeek + "-" + vYear + "] of [" + vProductionSite + "] is not yet finalized");
                    $("#date").html("Generate["+JSON.parse(data.d[3])[0].GeneratedDate+"] Finalized["+JSON.parse(data.d[3])[0].SubmittedDate+"]");
                    document.getElementById("finalize").style.display = "unset";
                    document.getElementById("addnewitem").style.display = "unset";
                }

                $("#param").html("Date: " + left(JSON.parse(data.d[3])[0].DateFrom,10) + "-" + left(JSON.parse(data.d[3])[0].DateTo,10));

                dataN = JSON.parse(data.d[0]);

                
                table = "";
                table += "<tr>"
                table += "<th  style='width:2rem'></th>"
                table +=	"    <th  style='width:18rem'>"
                table +=	"        Item Code"
                table +=	"    </th>"
                table +=	"    <th style='border-right-style:solid; border-right-width:thin'>"
                table +=	"       <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>Quantity <br/> Requirement </a></h5>"
  
                table +=	"    </th>"
                table +=	"    <th>"
                table +=	"       <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>Client</a></h5>"
                table +=	"       <span class='text-muted font-13'>Warehouse</span>"
                table +=	"    </th>"
                table +=	"    <th>"
                table +=	"       <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>Toll</a></h5>"
                table +=	"       <span class='text-muted font-13'>Warehouse</span>"
                table += "    </th>"
                table +=	"    <th>"
                table +=	"       <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>TP Floor</a></h5>"
                table +=	"       <span class='text-muted font-13'>Warehouse</span>"
                table +=	"    </th>"
                table +=	"    <th style='border-right-style:solid; border-right-width:thin' >"
                table +=	"       <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>Available</a></h5>"
                table +=	"       <span class='text-muted font-13'>Quantity</span>"
                table +=	"    </th>"
                table +=	"    <th>"
                table +=	"       <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>Lacking</a></h5>"
                table +=	"       <span class='text-muted font-13'>Quantity</span>"
                table +=	"    </th>"
                table +=	"    <th  style='border-right-style:solid; border-right-width:thin'>"
                table +=	"       <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>OCN</a></h5>"
                table +=	"       <span class='text-muted font-13'>Quantity</span>"
                table +=	"    </th>"
                table +=	"    <th>"
                table +=	"       <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>Request Qty</a></h5>"
                table +=	"       <span class='text-muted font-13'>Toll WH</span>"
                table +=	"    </th>"
                table +=	"    <th>"
                table +=	"       <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>MOQ</a></h5>"
                table +=	"       <span class='text-muted font-13'>in Batches</span>"
                table +=	"    </th>"
                table +=	"      <th>"
                table +=	"       <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>Unit</a></h5>"
                table +=	"       <span class='text-muted font-13'>in Batches</span>"
                table +=	"    </th>"
                table +=	"                                                   <th>"
                table +=	"       <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>Factor</a></h5>"
                table +=	"       <span class='text-muted font-13'></span>"
                table +=	"    </th>"
                table +=	"    <th>"
                table +=	"       <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>Order Qty</a></h5>"
                table +=	"       <span class='text-muted font-13'>Toll Wh</span>"
                table +=	"    </th>"
                                               
                table +=	"</tr>  "
              $('#MRPTable').append(table);
                for (var i = 0; i < dataN.length; i++) {
                table = "";
                    tabled = "";
                   
                    table += "	    <tr  id='i" + dataN[i].ItemCode + "' style='padding-left: 30px;' >	"
                    
                                table +=	"<td class='details-control'   data-toggle='collapse'  data-target='.i" + dataN[i].ItemCode + "'></td>"
                                 table +=	"	<td>	"
                                 table +=	"	    <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>"+dataN[i].ItemCode+" - "+dataN[i].ShortDesc+"</a></h5>	"
                                 table +=	"	    <span class='text-muted font-13'>"+dataN[i].FullDesc+"</span>	"
                                 table +=	"	   	"
                                 table +=	"	</td>	"
                                 table +=	"	<td>	"
                                 table +=	"	   <span style='width:5rem; border-style:none'>"+numberWithCommas(dataN[i].RequiredQty)+"</span>	"
                                 table +=	"	   	"
                                 table +=	"	</td>	"
                                 table +=	"		"
                                 table +=	"	<td>	"
                                 table +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataN[i].MainWH)+"</span>	"
                                 table +=	"	   	"
                                 table +=	"	</td>	"
                                 table +=	"	<td>	"
                                 table +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataN[i].TollWH)+"</span>	"
                                 table +=	"	   	"
                                 table += "	</td>	"
                                 table +=	"	<td>	"
                                 table +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataN[i].TPFWH)+"</span>	"
                                 table +=	"	   	"
                                 table +=	"	</td>	"
                                 table +=	"	<td>	"
                                 table +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataN[i].Available)+"</span>	"
                                 table +=	"	   	"
                                 table +=	"	</td>	"
                                 table += "	<td>	"

                                if (dataN[i].Lacking > 0) {
                                    table += "	     <span class='text-danger mr-2'>	"
                                    table += "	           <i class='mdi mdi-arrow-down-bold'>	"
                                }
                                else
                                {
                                    table += "	     <span class='text-success mr-2'>	"
                                    table += "	           <i class='mdi mdi-arrow-up-bold'>	"
                                }


                                 table +=	"		"
                                 table +=	"	       </i>	"
                                 table +=	"	    "+numberWithCommas(dataN[i].Lacking)+"‬	"
                                 table +=	"	   </span>	"
                                 table +=	"	</td>	"
                                 table +=	"	<td>	"
                                 table +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataN[i].OCN)+"</span>	"
                                 table +=	"	   	"
                                 table +=	"	</td>	"
                                 table +=	"	<td>	"
                                 table +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataN[i].RequestQty)+"</span>	"
                                 table +=	"	   	"
                                 table +=	"	</td>	"
                                 table +=	"	       <td>	"
                                 table +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataN[i].MOQ)+"</span>	"
                                 table +=	"	   	"
                                 table +=	"	</td>	"
                                 table +=	"	<td>	"
                                 table +=	"	    <span style='width:5rem; border-style:none'>"+(dataN[i].Unit)+"</span>	"
                                 table +=	"	   	"
                                 table +=	"	</td>	"
                                 table +=	"	 <td>	"
                                 table +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataN[i].UnitFactor)+"</span>	"
                                 table +=	"	   	"
                                 table +=	"	</td>	"
                                 table +=	"	 <td>	"
                                 table +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataN[i].OrderQty)+"</span>	"
                                 table +=	"	   	"
                                 table +=	"	</td>	"
                                 table +=	"	                                               	"
                                table += "	</tr>	"

                            
                            dataND = JSON.parse(data.d[1]);
                   
                            for (var idx = 0; idx < dataND.length; idx++) {
                                if (dataN[i].ItemCode == dataND[idx].ItemCode) {
                                
                                 tabled +=	"	    <tr class='collapse i"+dataND[idx].ItemCode+"'   id='i"+dataND[idx].ItemCode+dataND[idx].WeekName+"' >	"
                                   
                                    tabled += "	<td class='details-control'  data-toggle='collapse'  data-target='.i" + dataND[idx].ItemCode + dataND[idx].WeekName + "'>	</td>"
                                 tabled += "	<td>	"
                                 tabled +=	"	    <h5 class='font-14 my-1'><a href='javascript:void(0);' class='text-body'>"+dataND[idx].WeekName+"</a></h5>	"
                                 tabled +=	"	    <span class='text-muted font-13'>"+dataND[idx].Date+"</span>	"
                                 tabled +=	"	   	"
                                 tabled +=	"	</td>	"
                                 tabled +=	"	<td>	"
                                 tabled +=	"	   <span style='width:5rem; border-style:none'>"+numberWithCommas(dataND[idx].RequiredQty)+"</span>	"
                                 tabled +=	"	   	"
                                 tabled +=	"	</td>	"
                                 tabled +=	"		"
                                 tabled +=	"	<td>	"
                                 tabled +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataND[idx].MainWH)+"</span>	"
                                 tabled +=	"	   	"
                                 tabled +=	"	</td>	"
                                 tabled +=	"	<td>	"
                                 tabled +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataND[idx].TollWH)+"</span>	"
                                 tabled +=	"	   	"
                                 tabled += "	</td>	"
                                 tabled +=	"	<td>	"
                                 tabled +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataND[idx].TPFWH)+"</span>	"
                                 tabled +=	"	   	"
                                 tabled +=	"	</td>	"
                                 tabled +=	"	<td>	"
                                 tabled +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataND[idx].Available)+"</span>	"
                                 tabled +=	"	   	"
                                 tabled +=	"	</td>	"
                                 tabled += "	<td>	"

                                if (dataND[idx].Lacking > 0) {
                                    tabled += "	     <span class='text-danger mr-2'>	"
                                    tabled += "	           <i class='mdi mdi-arrow-down-bold'>	"
                                }
                                else
                                {
                                    tabled += "	     <span class='text-success mr-2'>	"
                                    tabled += "	           <i class='mdi mdi-arrow-up-bold'>	"
                                }


                                 tabled +=	"		"
                                 tabled +=	"	       </i>	"
                                 tabled +=	"	    "+numberWithCommas(dataND[idx].Lacking)+"‬	"
                                 tabled +=	"	   </span>	"
                                 tabled +=	"	</td>	"
                                 tabled +=	"	<td>	"
                                 tabled +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataND[idx].OCN)+"</span>	"
                                 tabled +=	"	   	"
                                 tabled +=	"	</td>	"
                                 tabled +=	"	<td>	"
                                 tabled +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataND[idx].RequestQty)+"</span>	"
                                 tabled +=	"	   	"
                                 tabled +=	"	</td>	"
                                 tabled +=	"	       <td>	"
                                 tabled +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataND[idx].MOQ)+"</span>	"
                                 tabled +=	"	   	"
                                 tabled +=	"	</td>	"
                                 tabled +=	"	<td>	"
                                 tabled +=	"	    <span style='width:5rem; border-style:none'>"+(dataND[idx].Unit)+"</span>	"
                                 tabled +=	"	   	"
                                 tabled +=	"	</td>	"
                                 tabled +=	"	 <td>	"
                                 tabled +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataND[idx].UnitFactor)+"</span>	"
                                 tabled +=	"	   	"
                                 tabled +=	"	</td>	"
                                 tabled +=	"	 <td>	"
                                 tabled +=	"	    <span style='width:5rem; border-style:none'>"+numberWithCommas(dataND[idx].OrderQty)+"</span>	"
                                 tabled +=	"	   	"
                                 tabled +=	"	</td>	"
                                 tabled +=	"	                                               	"
                                 tabled += "	</tr>	"




                                            tabled += "	<tr class='collapse i"+dataND[idx].ItemCode+dataND[idx].WeekName+"'> "
                                             tabled += "<td colspan='999'>"
                                             tabled += "<div>"
                                             tabled += "<table class='table table-striped'>"
                                             tabled += "<thead>"
                                             tabled += "<tr>"
                                             tabled += "<th>Counter Plan</th>"
                                             tabled += "<th>SKU Code</th>"
                                             tabled += "<th>Order Qty per SKU (in Batches)</th>"
                                             tabled += "<th>Standard Usage</th>"
                                             tabled += "<th>Allowance</th>"
                                             tabled += "<th>Quantity Requirement</th>"
                                             tabled += "</tr>"
                                            tabled += "</thead>"
                                            tabled += "<tbody>"
                                      Total=0  
                                     dataNDs = JSON.parse(data.d[2]);
                                    for (var idxs = 0; idxs < dataNDs.length; idxs++) {
                                        if (dataND[idx].ItemCode == dataNDs[idxs].ItemCode && dataND[idx].Date == dataNDs[idxs].Date) {


                                             
                                            tabled += " <tr> "
                                             tabled += " <td>"+dataNDs[idxs].CounterPlan+"</td> "
                                             tabled += " <td>"+dataNDs[idxs].SKUCode+" - "+dataNDs[idxs].FullDesc+"  <span class='badge badge-danger-lighten'>S</span></td> "
                                             tabled += " <td>"+numberWithCommas(dataNDs[idxs].OrderPerSKU)+"</td> "
                                             tabled += " <td>"+numberWithCommas(dataNDs[idxs].StandardUsage)+"</td> "
                                             tabled += " <td>"+numberWithCommas(dataNDs[idxs].Allowance)+"</td> "
                                             tabled += " <td>"+numberWithCommas(dataNDs[idxs].Requirement)+"</td> "
                                             tabled += " </tr> "
                                                          
                                            Total += dataNDs[idxs].Requirement;            
                                                            


                                        }
                                    }

                                                tabled += " <tr> "
                                                tabled += " <td></td> "
                                             tabled += " <td></td> "
                                             tabled += " <td></td> "
                                             tabled += " <td></td> "
                                             tabled += " <td></td> "
                                             tabled += " <td><b>"+numberWithCommas(Total)+"</b></td> "
                                             tabled += " </tr> "


                                              tabled += "</tbody>"
                                              tabled += "</table>"
                                              tabled += "</div>"
                                              tabled += "</td>"
                                              tabled += "</tr>"
                                }
                               
                                
                            }
                    
                                
                $('#MRPTable').append(table);
                $('#MRPTable').append(tabled);

               

                }

 
               
               



            }

            ).catch(function (error) {
                console.log(error);
                })

            
            MRPDetails();
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
           
            
            
            fetch('frmMaterialPlanning.aspx/Submit', {
                method: "POST",
                async: true,
                body: JSON.stringify({  ProductionSite: vProductionSite , Year: vYear, WorkWeek: vWorkWeek, UserID: vUserID  }),
                headers: {
                    "Content-Type": "application/json"
                },
            }).then(function (response) {
                return response.json()
            }).then(function (data) {
               
                ViewMRP();
            }

            ).catch(function (error) {
               alert(error);
                })
         }

         function Generate(param)
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
           
            
            
            fetch('frmMaterialPlanning.aspx/GeneratePR', {
                method: "POST",
                async: true,
                body: JSON.stringify({  ProductionSite: vProductionSite , Year: vYear, WorkWeek: vWorkWeek, UserID: vUserID, Param: param  }),
                headers: {
                    "Content-Type": "application/json"
                },
            }).then(function (response) {
                return response.json()
            }).then(function (data) {
               alert('Generated Succesfully!')
                ViewMRP();
            }

            ).catch(function (error) {
               alert(error);
                })


         }

        function MRPDetails()
         {
          
            
            
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

           
            fetch('frmMaterialPlanning.aspx/ExtractMRPDetail', {
                method: "POST",
                //body: "{}",
                async: true,
                body: JSON.stringify({ ProductionSite: vProductionSite , Year: vYear, WorkWeek: vWorkWeek, UserID: vUserID }),
                headers: {
                    "Content-Type": "application/json"
                },
            }).then(function (response) {
                return response.json()
                }).then(function (data) {

               DBData = data.d;
            }

            ).catch(function (error) {
               alert(error);
                })

            

         }

        function Item(vType)
         {
          
            
            
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

            var vOldItem = olditem.toString();
            var vItemCode = itemcode.toString();
            var vQty = $("#Qty").val();


            if (olditem.includes(',') || itemcode.includes(',')) {
                alert('Multime Item Selected');
                return;
            }
           
            fetch('frmMaterialPlanning.aspx/Item', {
                method: "POST",
                //body: "{}",
                async: true,
                body: JSON.stringify({ ProductionSite: vProductionSite , Year: vYear, WorkWeek: vWorkWeek, UserID: vUserID, olditemcode: vOldItem, itemcode: vItemCode, qty: vQty, type: vType   }),
                headers: {
                    "Content-Type": "application/json"
                },
            }).then(function (response) {
                return response.json()
                }).then(function (data) {

                    alert(data.d);
                  
                    GenerateMRP();

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
