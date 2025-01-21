<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDashboardAR.aspx.cs" Inherits="GWL.IT.frmDashboardAR" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
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
                            <h4 class="page-title">Accounts Receivables</h4>
                        </div>
                    </div>

                    <div class="col-xl-5 col-lg-6">

                        <div class="row">
                            <div class="col-lg-6">
                                <a  onclick="cardClick(0,'Unbilled Clients')" data-toggle="modal" style="cursor: pointer;">
                                    <div class="card widget-flat">
                                        <div class="card-body">
                                            <div class="float-right">
                                                <i class="mdi mdi-account-multiple widget-icon"></i>
                                            </div>
                                            <h5 class="text-muted font-weight-normal mt-0" title="Number of Unbilled Clients">Unbilled Clients</h5>
                                            <h3 id="cuc" class="mt-3 mb-3 text-warning"></h3>

                                        </div>
                                        <!-- end card-body-->
                                    </div>
                                </a>
                                <!-- end card-->

                            </div>
                            <!-- end col-->

                            <div class="col-lg-6">
                                <a  onclick="cardClick(1,'Park Billing')" data-toggle="modal" style="cursor: pointer;">
                                    <div class="card widget-flat">
                                        <div class="card-body">
                                            <div class="float-right">
                                                <i class="mdi mdi-cart-plus widget-icon"></i>
                                            </div>
                                            <h5 class="text-muted font-weight-normal mt-0" title="No. of parked billing (including aging)">Park Billing</h5>
                                            <h3 id="pb" class="mt-3 mb-3 text-info">0</h3>


                                        </div>
                                        <!-- end card-body-->
                                    </div>
                                    <!-- end card-->
                                </a>
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
                                     </a>
                                <!-- end card-->
                            </div>
                            <!-- end col-->
                        </div>
                        <!-- end row -->
                        <div class="row">
                             <div class="col-lg-12" >
                                <a  onclick="cardClick(8,'Expiring Contracts')" data-toggle="modal" style="cursor: pointer;">
                                <div class="card widget-flat">
                                    <div class="card-body">
                                        <div class="float-right">
                                            <i class="mdi mdi-account-multiple widget-icon"></i>
                                        </div>
                                        <h5 class="text-muted font-weight-normal mt-0" title="">Expiring Contracts</h5>
                                        <h3 id="dpo" class="mt-3 mb-3 text-danger">0</h3>
                                      
                                    </div>
                                    <!-- end card-body-->
                                </div>
                                 </a>
                                <!-- end card-->
                            </div>
                        </div>

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
                                        <a href="javascript:void(0);" class="dropdown-item">Details</a>
                                        <!-- item-->
                                  
                                    </div>
                                </div>
                                <h4 class="header-title mb-3">Invoices vs Collected</h4>

                                <div id="inv-col" class="apex-charts"
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
                                <a  onclick="cardClick(5,'AR Aging Summary')" class="btn btn-sm btn-link float-right mb-3">Details
                                    <i class="mdi mdi-download ml-1"></i>
                                </a>
                                <h4 class="header-title mt-2">AR Aging Summary</h4>

                                <div class="table-responsive" style="overflow: auto; height: 43rem">
                                    <table class="table table-centered table-nowrap table-hover mb-0">
                                        <tbody id="aging" style="overflow: auto">
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
                      <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <div class="dropdown float-right">
                                    <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                        <i class="mdi mdi-dots-vertical"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Details</a>
                                        <!-- item-->
                                    </div>
                                </div>
                                <h4 class="header-title mb-4">Billing Status</h4>

                                <div class="my-4 chartjs-chart" style="height: 202px;">
                                    <canvas id="project-status-chart2" data-colors="#0acf97,#727cf5,#fa5c7c"></canvas>
                                </div>

                                <div class="row text-center mt-2 py-2">
                                    <div class="col-4">
                                        <i class="mdi mdi-trending-up text-success mt-3 h3"></i>
                                        <h3 class="font-weight-normal">
                                            <span id="ob">0</span>
                                        </h3>
                                        <p class="text-muted mb-0">Billed</p>
                                    </div>
                                    <div class="col-4">
                                        <i class="mdi mdi-trending-down text-primary mt-3 h3"></i>
                                        <h3 class="font-weight-normal">
                                            <span id="ou">0</span>
                                        </h3>
                                        <p class="text-muted mb-0">Unbilled</p>
                                    </div>
                                    <div class="col-4">
                                        <i class="mdi mdi-trending-down text-danger mt-3 h3"></i>
                                        <h3 class="font-weight-normal">
                                            <span id="ov">0</span>
                                        </h3>
                                        <p class="text-muted mb-0">Voided</p>
                                    </div>
                                </div>
                                <!-- end row-->

                            </div>
                            <!-- end card body-->
                        </div>
                        <!-- end card -->
                    </div>
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <div class="dropdown float-right">
                                    <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                        <i class="mdi mdi-dots-vertical"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Details</a>

                                    </div>
                                </div>
                                <h4 class="header-title" >Printing Status Report</h4>
                                <div id="location" style="height:15rem; overflow:auto" >
                                <h5 id='pslocation' class="mb-1 mt-0 font-weight-normal">New York</h5>
                                <div class="progress-w-percent">
                                    <span class="progress-value font-weight-bold">72k </span>
                                    <div class="progress progress-sm">
                                        <div class="progress-bar" role="progressbar" style="width: 72%;" aria-valuenow="72" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                             </div>
                            </div>
                            <!-- end card-body-->
                        </div>
                        <!-- end card-->
                    </div>
                                    
                    <!-- end col-->
                        </div>
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
    <script src="assets/js/vendor/Chart.bundle.min.js"></script>
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

        <script src="assets/js/pages/demo.dashboard-projects.js"></script>
     <script src="assets/js/pages/demo.dashboard.js"></script>
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

                    Dashboard();
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
                    labels: ["Billed", "Unbilled", "Voided"],
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
            var vType = 'DashboardAR';
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
               
                DBData = data;
                console.log(DBData);
                $('#cuc').text(numberWithCommas(data[0].length));
                $('#pb').text(numberWithCommas(data[1].length));
                $('#si').text(numberWithCommas(data[2].length));
                $('#ui').text(numberWithCommas(data[3].length));

                var arcollected = "["
                var arreceivable = "["
                var armonth = "["
                for (var i = 0; i < data[4].length; i++) {
                    arcollected += data[4][i].Collected
                    arreceivable += data[4][i].Receivable
                    armonth += "'" + data[4][i].Month + "'"
                    if (data[4].length > i + 1) {
                        arcollected += ", "
                        arreceivable += ", "
                        armonth += ", "
                    }

                }

                arcollected += "]"
                arreceivable += "]"
                armonth += "]"


                e = ["#727cf5", "#e3eaef"];
                (t = $("#inv-col").data("colors")) && (e = t.split(","));
                r = {
                    chart: { height: 370, type: "bar", stacked: !0 },
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
                for (var i = 0; i < data[5].length; i++) {



                    table += " <tr> ";
                    table += "     <td> ";
                    table += "         <h5 class='font - 14 my - 1 font - weight - normal'>" + data[5][i].CustomerCode + "</h5> ";
                    table += "         <span class='text - muted font - 13'>Terms: " + data[5][i].Terms + " Days</span> ";
                    table += "     </td> ";
                    table += "     <td> ";
                    table += "         <h5 class='font - 14 my - 1 font - weight - normal'>" + data[5][i].CustomerName.substring(0, 15) + "</h5> ";
                    table += "         <span class='text - muted font - 13'>Customer</span> ";
                    table += "     </td> ";
                    table += "     <td> ";
                    table += "         <h5 class='font - 14 my - 1 font - weight - normal'>Php " + numberWithCommas(data[5][i].ARTotal.toFixed(2)) + "</h5> ";
                    table += "         <span class='text - muted font - 13'>Total AR</span> ";
                    table += "     </td> ";
                    table += "     <td> ";
                    table += "         <h5 class='font - 14 my - 1 font - weight - normal'>Php " + numberWithCommas(data[5][i].Checks.toFixed(2)) + "</h5> ";
                    table += "         <span class='text - muted font - 13'>Post Dated Checks</span> ";
                    table += "     </td> ";
                    table += " </tr> ";

                }
                $('#aging').empty();

                $('#aging').append(table);

                table ="";
                for (var i = 0; i < data[6].length; i++) {

                    table += "  <h5  class='mb-1 mt-0 font-weight-normal'>"+ data[6][i].Location+"</h5> ";
                    table += "  <div class='progress-w-percent'>";
                    table += "  <span class='progress-value font-weight-bold'>"+numberWithCommas(data[6][i].Total)+" </span>";
                    table += " <div class='progress progress-sm'> ";
                    var perc = (  parseFloat(data[6][i].Emailed) /parseFloat(data[6][i].Total)) * 100
                
                    table += " <div class='progress-bar' role='progressbar' style='width: "+perc+"%;' aria-valuenow='"+data[6][i].Emailed+"' aria-valuemin='0' aria-valuemax='"+data[6][i].Total+"'></div>";
                    table += " </div> ";
                    table += " </div> ";

                }

                $('#location').empty();

                $('#location').append(table);

                var table = ""
                for (var i = 0; i < data[7].length; i++) {
                    switch (data[7][i].oType) {
                        case 'Billed': ob = numberWithCommas(data[7][i].oCount); $('#ob').text(numberWithCommas(data[7][i].oCount)); break;
                        case 'Unbilled': ou = numberWithCommas(data[7][i].oCount); $('#ou').text(numberWithCommas(data[7][i].oCount)); break;
                        case 'Voided': ov = numberWithCommas(data[7][i].oCount); $('#ov').text(numberWithCommas(data[7][i].oCount)); break;
                    }
                }

                $('#dpo').text(numberWithCommas(data[8].length));

                reinitChart();
                
            }

            ).catch(function (error) {
                console.log(error);
                })

            

        }


    </script>






</body>
</html>
