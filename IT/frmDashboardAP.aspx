<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDashboardAP.aspx.cs" Inherits="GWL.IT.frmDashboardAP" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
            <!-- third party css -->
        <link href="assets/css/vendor/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
        <!-- third party css end -->
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

                <div class="row">
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
                                    <a href="javascript:  Dashboard();" class="btn btn-info ml-2">
                                        <i class="mdi mdi-autorenew"></i>
                                    </a>
                                </div>
                            </div>
                            <h4 class="page-title">Accounts Payable</h4>
                        </div>
                    </div>
                    <div class="col-xl-5 col-lg-6">

                        <div class="row">
                          

                            <div class="col-lg-6">
                                <a  onclick="cardClick(0,'Uninvoiced Goods Received')" data-toggle="modal" style="cursor: pointer;">
                                <div class="card widget-flat">
                                    <div class="card-body">
                                        <div class="float-right">
                                            <i class="mdi mdi-account-multiple widget-icon"></i>
                                        </div>
                                        <h5 class="text-muted font-weight-normal mt-0" title="Number of Unbilled Clients">Uninvoiced Goods Received</h5>
                                        <h3 id="cuc" class="mt-3 mb-3 text-warning">0</h3>
                                      
                                    </div>
                                    <!-- end card-body-->
                                </div>
                                 </a>
                                <!-- end card-->
                            </div>
                            <!-- end col-->

                            <div class="col-lg-6">
                                 <a  onclick="cardClick(1,'Parked APV')" data-toggle="modal" style="cursor: pointer;">
                                <div class="card widget-flat">
                                    <div class="card-body">
                                        <div class="float-right">
                                            <i class="mdi mdi-cart-plus widget-icon"></i>
                                        </div>
                                        <h5 class="text-muted font-weight-normal mt-0" title="No. of parked billing (including aging)">Parked APV</h5>
                                        <h3 id="pb" class="mt-3 mb-3 text-info">0</h3>
                                       
                                    </div>
                                    <!-- end card-body-->
                                </div>
                                     </a>
                                <!-- end card-->
                            </div>
                            <!-- end col-->
                        </div>
                        <!-- end row -->

                        <div class="row">
                            <div class="col-lg-6">
                                 <a  onclick="cardClick(2,'Successful Invoice')" data-toggle="modal" style="cursor: pointer;">
                                <div class="card widget-flat">
                                    <div class="card-body">
                                        <div class="float-right">
                                            <i class="mdi mdi-currency-usd widget-icon"></i>
                                        </div>
                                        <h5 class="text-muted font-weight-normal mt-0" title="Proccessed Billing">Successful Invoice</h5>
                                        <h3 id="si" class="mt-3 mb-3 text-success">0</h3>
                                       
                                    </div>
                                    <!-- end card-body-->
                                </div>
                                     </a>
                                <!-- end card-->
                            </div>
                            <!-- end col-->

                            <div class="col-lg-6">
                                 <a  onclick="cardClick(3,'Unsuccessful Invoice')" data-toggle="modal" style="cursor: pointer;">
                                <div class="card widget-flat">
                                    <div class="card-body">
                                        <div class="float-right">
                                            <i class="mdi mdi-currency-usd widget-icon"></i>
                                        </div>
                                        <h5 class="text-muted font-weight-normal mt-0" title="Growth">Unsuccessful Invoice</h5>
                                        <h3 id="ui" class="mt-3 mb-3 text-danger">0</h3>
                                      
                                    </div>
                                    <!-- end card-body-->
                                </div>
                                <!-- end card-->
                                     </a>
                            </div>
                            <!-- end col-->
                        </div>
                        <!-- end row -->

                    </div>
                    <!-- end col -->

                    <div class="col-xl-7  col-lg-6">
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
                                <h4 class="header-title mb-3">Payables vs Paid Vouchers </h4>

                                <div id="pay-vou" class="apex-charts"
                                    data-colors="#727cf5,#e3eaef">
                                </div>

                            </div>
                            <!-- end card-body-->
                        </div>
                        <!-- end card-->

                    </div>
                    <!-- end col -->
                </div>
                <!-- end row -->

                <div class="row">
                   <div class="col-lg-8">
                        <div class="card">
                            <div class="card-body">
                                <a onclick="cardClick(5,'AP Aging Summary')" class="btn btn-sm btn-link float-right mb-3">Details
                                    <i class="mdi mdi-download ml-1"></i>
                                </a>
                                <h4 class="header-title mt-2">AP Aging Summary</h4>

                                <div class="table-responsive" style="overflow:auto; height:30rem">
                                    <table class="table table-centered table-nowrap table-hover mb-0">
                                        <tbody  id="aging" style="overflow:auto">
                                         

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
                   
                   <div class="col-lg-4">
                    <div class="card">
                        <div class="card-body">
                            <a href="" class="p-0 float-right mb-3">Export <i class="mdi mdi-download ml-1"></i></a>
                            <h4 class="header-title mt-1">Aging</h4>

                            <div class="table-responsive">
                                <table class="table table-sm table-centered mb-0 font-14">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Days</th>
                                            <th style="width: 30%;text-align:right">Amount</th>
                                            <th style="width: 30%;text-align:right">%</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td >0-30</td>
                                            <td id="Day1to30" style="text-align:right">2,250</td>
                                            <td id="Day1to30p" style="text-align:right">4,250</td>
                                        </tr>
                                        <tr>
                                            <td>31-60</td>
                                            <td id="Day31to60" style="text-align:right">1,501</td>
                                            <td id="Day31to60p" style="text-align:right">2,050</td>
                                        </tr>
                                        <tr>
                                            <td>61-90</td>
                                            <td id="Day61to90" style="text-align:right">750</td>
                                            <td id="Day61to90p" style="text-align:right">1,600</td>
                                        </tr>
                                        <tr>
                                            <td>91-120</td>
                                            <td id="Day91to120" style="text-align:right">540</td>
                                            <td id="Day91to120p" style="text-align:right">1,040</td>
                                        </tr>
                                        <tr>
                                            <td>121-150</td>
                                            <td id="Day121to150" style="text-align:right">540</td>
                                            <td id="Day121to150p" style="text-align:right">1,040</td>
                                        </tr>
                                        <tr>
                                            <td>151-180</td>
                                            <td id="Day151to180" style="text-align:right">540</td>
                                            <td id="Day151to180p" style="text-align:right">1,040</td>
                                        </tr>
                                        <tr>
                                            <td>181 or more</td>
                                            <td id="Day181More" style="text-align:right">540</td>
                                            <td id="Day181Morep" style="text-align:right">1,040</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <!-- end table-responsive-->

                            
                            <div class="col-lg-12" style="display:none">
                                <a  onclick="cardClick(7,'Days of Payable Outstanding')" data-toggle="modal" style="cursor: pointer;">
                                <div class="card widget-flat">
                                    <div class="card-body">
                                        <div class="float-right">
                                            <i class="mdi mdi-account-multiple widget-icon"></i>
                                        </div>
                                        <h5 class="text-muted font-weight-normal mt-0" title="">Days of Payable Outstanding</h5>
                                        <h3 id="dpo" class="mt-3 mb-3 text-danger">0</h3>
                                      
                                    </div>
                                    <!-- end card-body-->
                                </div>
                                 </a>
                                <!-- end card-->
                            </div>
                        </div>
                        <!-- end card-body-->
                    </div>
                    <!-- end card-->
                </div>
                    <!-- end col-->
                        
                </div>
                <!-- end row -->


                <div class="row">
                 
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
    <script src="assets/js/vendor/apexcharts.min.js"></script>
    <script src="assets/js/vendor/jquery-jvectormap-1.2.2.min.js"></script>
    <script src="assets/js/vendor/jquery-jvectormap-world-mill-en.js"></script>
    <!-- third party js ends -->

    <!-- demo app -->
    <script src="assets/js/pages/demo.dashboard.js"></script>
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
                autoclose: true,
                onSelect: function(dateText) {

    }
            });

            $("#dash-period").mouseup(function (e) {

                $("#dash-period").Close();

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

                  //  Dashboard();
                }

            });

  });

   
     
         function cardClick(type, title, withselect = 0) {

            
         
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


        function Dashboard() {
            let items;

            var vUserID = '<%=Session["userid"] %>';
            var vType = 'DashboardAP';
           // var vParam = $("#dash-period").val();
            var vParam = $("#daterangetrans").val();
            var vScheama = '<%=Session["schemaname"] %>';
            var extsession = '<%=Session["token"]%>';
           
             fetch('<%=Session["APIURL"] %>'+"/GetDashboard", {
            //fetch('<%=Session["APIURL"] %>'+":1110/GetDashboard", {
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

                DBData = data;
               
                $('#cuc').text(numberWithCommas(data[0].length));
                $('#pb').text(numberWithCommas(data[1].length));
                $('#si').text(numberWithCommas(data[2].length));
                $('#ui').text(numberWithCommas(data[3].length));
                $('#dpo').text(numberWithCommas(data[7][0].dpo));
                var arcollected = "[" 
                var arreceivable = "[" 
                var armonth = "["
                for (var i = 0; i < data[4].length; i++) {
                    arcollected += data[4][i].Paid
                    arreceivable += data[4][i].Payable
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
                (t = $("#pay-vou").data("colors")) && (e = t.split(","));
                r = {
                    chart: { height: 210, type: "bar", stacked: !0 },
                    plotOptions: { bar: { horizontal: !1, columnWidth: "20%" } },
                    dataLabels: { enabled: !1 },
                    stroke: { show: !0, width: 2, colors: ["transparent"] },
                    series: [
                        //{ name: "Collected", data: [65, 59, 80, 81, 56, 89, 40, 32, 65, 59, 80, 81] },
                        //{ name: "Receivables", data: [89, 40, 32, 65, 59, 80, 81, 56, 89, 40, 65, 59] },
                        { name: "Paid", data: eval(arcollected) },
                        { name: "Payable", data: eval(arreceivable) },
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
                new ApexCharts(document.querySelector("#pay-vou"), r).render();

                var table = ""

                var	Day1to30	=0
                var	Day31to60	=0
                var	Day61to90	=0
                var	Day91to120	=0
                var	Day121to150	=0
                var	Day151to180	=0
                var	Day181More	=0

                var APTotal = 0
                for (var i = 0; i < data[5].length; i++) {

                    

                    table += " <tr> ";
                    table += "     <td> ";
                    table += "         <h5 class='font - 14 my - 1 font - weight - normal'>"+data[5][i].Code.substring(0, 20)+"</h5> ";
                    table += "         <span class='text - muted font - 13'>Terms: "+data[5][i].Terms+" Days</span> ";
                    table += "     </td> ";
                    table += "     <td> ";
                    table += "         <h5 class='font - 14 my - 1 font - weight - normal'>Php "+ numberWithCommas(data[5][i].APTotal.toFixed(2))+"</h5> ";
                    table += "         <span class='text - muted font - 13'>Total AP</span> ";
                    table += "     </td> ";
                    table += "     <td> ";
                    table += "         <h5 class='font - 14 my - 1 font - weight - normal'>Php "+numberWithCommas(data[5][i].APTotal.toFixed(2))+"</h5> ";
                    table += "         <span class='text - muted font - 13'>Post Dated Checks</span> ";
                    table += "     </td> ";
                    table += " </tr> ";

                    Day1to30	+=	data[5][i].Day1to30
                    Day31to60	+=	data[5][i].Day31to60
                    Day61to90	+=	data[5][i].Day61to90
                    Day91to120	+=	data[5][i].Day91to120
                    Day121to150	+=	data[5][i].Day121to150
                    Day151to180	+=	data[5][i].Day151to180
                    Day181More	+=	data[5][i].Day180More
                    APTotal     +=  data[5][i].APTotal

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

                document.getElementById("Day1to30p").innerHTML = ((Day1to30 / APTotal)*100).toFixed(2) ;
                document.getElementById("Day31to60p").innerHTML = ((Day31to60 / APTotal)*100).toFixed(2)  ;
                document.getElementById("Day61to90p").innerHTML = ((Day61to90 / APTotal)*100).toFixed(2)  ;
                document.getElementById("Day91to120p").innerHTML = ((Day91to120 / APTotal)*100).toFixed(2)  ;
                document.getElementById("Day121to150p").innerHTML = ((Day121to150 / APTotal)*100).toFixed(2)  ;
                document.getElementById("Day151to180p").innerHTML = ((Day151to180 / APTotal)*100).toFixed(2)  ;
                document.getElementById("Day181Morep").innerHTML = ((Day181More / APTotal)*100).toFixed(2)  ;
                

            }

            ).catch(function (error) {
                console.log(error);
            })
        
    }


    </script>

   
</body>
</html>
