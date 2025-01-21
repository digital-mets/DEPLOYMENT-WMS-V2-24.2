<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDashboardBasic.aspx.cs" Inherits="GWL.frmDashboardBasic" %>

<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title></title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- favicon
		============================================ -->
    <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
    <!-- Google Fonts
		============================================ -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,700,700i,800" rel="stylesheet">
    <!-- Bootstrap CSS
		============================================ -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <!-- Bootstrap CSS
		============================================ -->
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <!-- adminpro icon CSS
		============================================ -->
    <link rel="stylesheet" href="css/adminpro-custon-icon.css">
    <!-- meanmenu icon CSS
		============================================ -->
    <link rel="stylesheet" href="css/meanmenu.min.css">
    <!-- mCustomScrollbar CSS
		============================================ -->
    <link rel="stylesheet" href="css/jquery.mCustomScrollbar.min.css">
    <!-- animate CSS
		============================================ -->
    <link rel="stylesheet" href="css/animate.css">
    <!-- jvectormap CSS
		============================================ -->
    <link rel="stylesheet" href="css/jvectormap/jquery-jvectormap-2.0.3.css">
    <!-- normalize CSS
		============================================ -->
    <link rel="stylesheet" href="css/data-table/bootstrap-table.css">
    <link rel="stylesheet" href="css/data-table/bootstrap-editable.css">
    <!-- normalize CSS
		============================================ -->
    <link rel="stylesheet" href="css/normalize.css">
    <!-- charts CSS
		============================================ -->
    <link rel="stylesheet" href="css/c3.min.css">
    <!-- style CSS
		============================================ -->
    <link rel="stylesheet" href="style.css">
    <!-- responsive CSS
		============================================ -->
    <link rel="stylesheet" href="css/responsive.css">
    <!-- modernizr JS
		============================================ -->
    <script src="js/vendor/modernizr-2.8.3.min.js"></script>

        <!-- notifications CSS
		============================================ -->
    <link rel="stylesheet" href="css/Lobibox.min.css"/>
    <link rel="stylesheet" href="css/notifications.css"/>

    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>



    <script>
        $(document).ready(function () {

            setTimeout(function () {
                Refresh();
               
            }, 1500);
        });

         


        function CounterUp()
        {
            //$('.counter').counterUp({
            //    delay: 10,
            //    time: 1000
            //});
          
        }


        function TransCount() {


            var Submitted = 0;
            var Unsubmitted = 0;
            var Unposted = 0;
            var Cancelled = 0;
            var Result = '';
            var arr 
            $.ajax({
                type: "POST",
                url: "frmDashboardBasic.aspx/GetValue",
                data: '{name: "' + 'Unsubmitted' + '" ,value: "' + '0' + '"} ',
                datatype: 'text',
                contentType: "application/json; charset=utf-8",
                success: function (result) {

                   

                    Result = result.d+'';
                    arr = Result.split('|');


                    Submitted = arr[0];
                    Unsubmitted = arr[1];
                    Cancelled = arr[2];
                    Unposted = arr[3];

                    $('#unsubmitted').text(Unsubmitted);
                    $('#submitted').text(Submitted);
                    $('#unposted').text(Unposted);
                    $('#cancelled').text(Cancelled);

                    
                }
            });




            
         

            //$.ajax({
            //    type: "POST",
            //    url: "frmDashboard.aspx/GetValue",
            //    data: '{name: "' + 'Submitted' + '" ,value: "' + '0' + '"} ',
            //    datatype: 'text',
            //    contentType: "application/json; charset=utf-8",
            //    success: function (result) {
            //        Submitted = parseInt(result.d, 0.0000);
                   
            //            $('#submitted').text(Submitted);
                    
            //    }
            //});

            //$.ajax({
            //    type: "POST",
            //    url: "frmDashboard.aspx/GetValue",
            //    data: '{name: "' + 'Unposted' + '" ,value: "' + '0' + '"} ',
            //    datatype: 'text',
            //    contentType: "application/json; charset=utf-8",
            //    success: function (result) {
            //        Unposted = parseInt(result.d, 0.0000);

                
            //            $('#unposted').text(Unposted);
                    

            //    }
            //});

            //$.ajax({
            //    type: "POST",
            //    url: "frmDashboard.aspx/GetValue",
            //    data: '{name: "' + 'Cancelled' + '" ,value: "' + '0' + '"} ',
            //    datatype: 'text',
            //    contentType: "application/json; charset=utf-8",
            //    success: function (result) {
            //        Cancelled = parseInt(result.d, 0.0000);
                   

            //            $('#cancelled').text(Cancelled);
                    

                       

            //    }
            //});

        }

        function DB() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmDashboardBasic.aspx/GetDashboard",
                data: '{ID: "' + '' + '"}',
                dataType: "json",
                success: function (data) {


                    for (var i = 0; i < data.d.length; i++) {

                      //  $('#' + data.d[i].Code).text = data.d[i].Value;

                        document.getElementById(data.d[i].Code).innerText = data.d[i].Value;
                        
                    }

                },
                error: function (data) {
                    console.log(data)
                }
            });

          
        }

        function FuncGroup()
        {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmDashboardBasic.aspx/GetFunc",
                data: '{ID: "' + '' + '"}',
                dataType: "json",
                success: function (data) {
                    str = "";

                    for (var i = 0; i < data.d.length; i++) {

                        //  $('#' + data.d[i].Code).text(data.d[i].Status);
                        //////$('#' + data.d[i].Code).text('');

                        //if (data.d[i].Status == 'Pending') {
                        //    $('#' + data.d[i].Code).css({ "background": "#ed5565", "color": "white" });
                        //    $('#' + data.d[i].Code).html('<span class="adminpro-icon adminpro-danger-error admin-check-sucess admin-check-pro-clr3" ></span>');
                        //}
                        //else {
                        //    $('#' + data.d[i].Code).css({ "background": "#1ab394", "color": "white" });
                        //    $('#' + data.d[i].Code).html('<span class="adminpro-icon adminpro-checked-pro admin-check-pro admin-check-pro-none"></span>');
                        //}

                        //$('#' + data.d[i].Code + 'HEAD').text(data.d[i].Head);
                        //$('#' + data.d[i].Code + 'DATE').text(data.d[i].Value);

                         str+= "<tr>"
                         str+= "<td></td>"
                        str += "<td>" + data.d[i].Code + "</td>"

                        if (data.d[i].Status == 'Pending') {
                            str += "<td class='adminpro-icon adminpro-danger-error admin-check-sucess admin-check-pro-clr3' id='" + data.d[i].Code + "' style='width: 10px; background:#ed5565 '></td>"
                        }
                        else {
                            str += "<td class='adminpro-icon adminpro-checked-pro admin-check-pro admin-check-pro-none' id='" + data.d[i].Code + "' style='width: 10px; background:#1ab394'></td>"

                        }



                         str+= "<td >"+data.d[i].Value+"</td>"
                         str+= "<td >"+data.d[i].Head+"</td>"
                         str+= "</tr>"

                    }

                    $('#functable').empty();
                    $('#functable').append(str);

                },
                error: function (data) {
                    console.log(data)
                }
            });
        }
    

        function Notes() {
            var str = ''
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmDashboardBasic.aspx/GetNote",
                data: '{ID: "' + '' + '"}',
                dataType: "json",
                success: function (data) {


                    for (var i = 0; i < data.d.length; i++) {
                        //2020-10-26 RA Added code to view transaction under notes. Comment code under button function
                        //2020-10-27 RA Change approach due to not recognize script
                        str += '<div class="comment-phara">' +
                                        '<div class="comment-adminpr">' +
                                        '<a class="dashtwo-messsage-title" >' + data.d[i].Fromuser + '</a>' +
                                        ' <a class="comment-content"  href="' + data.d[i].CommandString + '" target="_blank"  >' + data.d[i].Message + '</a> ' +
                                        '</div>' +
                                        '<div class="admin-comment-month">' +
                                        '    <p class="comment-clock"><i class="fa fa-clock-o"></i> ' + data.d[i].Date + '</p>' +
                                        '    <a class="comment-setting"  href="' + data.d[i].CommandString + '" target="_blank"> View</a>' +
                                        //'    <ul id="adminpro-demo5" class="comment-action-st collapse">' +
                                        //'        <li><a href="#" View</a>' +
                                        //'        </li>' +
                                        //'        <li><a href="#">Report</a>' +
                                        //'        </li>' +
                                        //'        <li><a href="#">Hide Message</a>' +
                                        //'        </li>' +
                                        //'        <li><a href="#">Turn on Message</a>' +
                                        //'        </li>' +
                                        //'        <li><a href="#">Turn off Message</a>' +
                                        //'        </li>' +
                                        //'    </ul>' +
                                        '</div>' +
                                        '</div>'

                    }
                    $('#Notes').empty();
                    $('#Notes').append(str);
                    $('#Notes').css('overflow', 'auto');
                },
                error: function (data) {
                    console.log(data)
                }
            });

        }

        function Refresh() {
    
            setTimeout(function () {
                TransCount();
                DB();


                FuncGroup();
                Notes();
            }, 500);
            setTimeout(function () { CounterUp(); }, 500);

 
          
            
       
            

     


          

        }

      
               
                   
             
    </script>

    <style>
        .adminpro-icon {
    font-size: 25px;
    margin-left:20%;

}
    </style>
</head>

<body class="materialdesign">

    
    <div class="wrapper-pro" style="margin-top:10px">
     
        <!-- Header top area start-->
        <div class="content-inner-all">
          

            <!-- income order visit user Start -->
            <div class="income-order-visit-user-area">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-3">
                            <div class="income-dashone-total shadow-reset nt-mg-b-30">
                                <div class="income-title">
                                    <div class="main-income-head">
                                        <h2 style="font-size:medium">Unsubmitted</h2>
                                        <div class="main-income-phara">
                                            <p id="Refresh" onclick="Refresh();">Monthly</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="income-dashone-pro">
                                    <div class="income-rate-total">
                                        <div class="price-adminpro-rate">
                                            <h3><span class="counter" id="unsubmitted">0</span></h3>
                                        </div>
                                        <div class="price-graph">
                                            <span id="sparkline1"></span>
                                        </div>
                                    </div>
                                    <div class="income-range">
                                        <p>Total Unsubmitted</p>
                                        <span class="income-percentange">98% <i class="fa fa-bolt"></i></span>
                                    </div>
                                    <div class="clear"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="income-dashone-total shadow-reset nt-mg-b-30">
                                <div class="income-title">
                                    <div class="main-income-head">
                                        <h2>Submitted</h2>
                                        <div class="main-income-phara order-cl">
                                            <p>Monthly</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="income-dashone-pro">
                                    <div class="income-rate-total">
                                        <div class="price-adminpro-rate">
                                            <h3><span class="counter" id="submitted">0</span></h3>
                                        </div>
                                        <div class="price-graph">
                                            <span id="sparkline6"></span>
                                        </div>
                                    </div>
                                    <div class="income-range order-cl">
                                        <p>Total Submitted</p>
                                        <span class="income-percentange">66% <i class="fa fa-level-up"></i></span>
                                    </div>
                                    <div class="clear"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="income-dashone-total shadow-reset nt-mg-b-30">
                                <div class="income-title">
                                    <div class="main-income-head">
                                        <h2>Cancelled</h2>
                                        <div class="main-income-phara visitor-cl">
                                            <p>Monthly</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="income-dashone-pro">
                                    <div class="income-rate-total">
                                        <div class="price-adminpro-rate">
                                            <h3><span class="counter" id="cancelled">0</span></h3>
                                        </div>
                                        <div class="price-graph">
                                            <span id="sparkline2"></span>
                                        </div>
                                    </div>
                                    <div class="income-range visitor-cl">
                                        <p>Total Cancelled</p>
                                        <span class="income-percentange">55% <i class="fa fa-level-up"></i></span>
                                    </div>
                                    <div class="clear"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="income-dashone-total shadow-reset nt-mg-b-30">
                                <div class="income-title">
                                    <div class="main-income-head">
                                        <h2>For Sync to Portal</h2>
                                        <div class="main-income-phara low-value-cl">
                                            <p>Monthly</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="income-dashone-pro">
                                    <div class="income-rate-total">
                                        <div class="price-adminpro-rate">
                                            <h3><span class="counter" id="unposted">0</span></h3>
                                        </div>
                                        <div class="price-graph">
                                            <span id="sparkline5"></span>
                                        </div>
                                    </div>
                                    <div class="income-range low-value-cl">
                                        <p>Total Unposted </p>
                                        <span class="income-percentange">33% <i class="fa fa-level-down"></i></span>
                                    </div>
                                    <div class="clear"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- income order visit user End -->
            <div class="dashtwo-order-area">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="dashtwo-order-list shadow-reset">
                                <div class="row">
                                    <div class="col-lg-9">
                                        <div class="flot-chart flot-chart-dashtwo">
                                            <div class="flot-chart-content" id="flot-dashboard-chart" style="color: black "></div>
                                        </div>
                                    </div>
                                    <div class="col-lg-3">
                                        <div class="skill-content-3">
                                            <div class="skill">
                                                <div class="progress">
                                                    <div class="lead-content">
                                                        <h3 ><span class="counter" id="Orders">0</span></h3>
                                                        <p>Total orders in period</p>
                                                    </div>
                                                    <div class="progress-bar wow fadeInLeft" data-progress="95%" style="width: 95%;" data-wow-duration="1.5s" data-wow-delay="1.2s"> <span>95%</span>
                                                    </div>
                                                </div>
                                                <div class="progress">
                                                    <div class="lead-content">
                                                        <h3 ><span class="counter" id="LOrder">0</span></h3>
                                                        <p>Orders in last month</p>
                                                    </div>
                                                    <div class="progress-bar wow fadeInLeft" data-progress="85%" style="width: 85%;" data-wow-duration="1.5s" data-wow-delay="1.2s"><span>85%</span> </div>
                                                </div>
                                                <div class="progress progress-bt">
                                                    <div class="lead-content">
                                                        <h3 ><span class="counter" id="Sales">0</span></h3>
                                                        <p>Monthly Sales (Qty)</p>
                                                    </div>
                                                    <div class="progress-bar wow fadeInLeft" data-progress="93%" style="width: 93%;" data-wow-duration="1.5s" data-wow-delay="1.2s"><span>93%</span> </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="feed-mesage-project-area">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-4">
                            <div class="sparkline11-list shadow-reset mg-tb-30">
                                <div class="sparkline11-hd">
                                    <div class="main-sparkline11-hd">
                                        <h1>Orders for Approval</h1>
                                        <div class="sparkline11-outline-icon">
                                            <span class="sparkline11-collapse-link"><i class="fa fa-chevron-up"></i></span>
                                            <span><i class="fa fa-wrench"></i></span>
                                            <span class="sparkline11-collapse-close"><i class="fa fa-times"></i></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="sparkline11-graph dashone-comment dashtwo-comment comment-scrollbar">
                                    <div class="daily-feed-list">
                                        <div class="daily-feed-img">
                                            <a href="#"><img src="img/notification/1.jpg" alt="" />
                                            </a>
                                        </div>
                                        <div class="daily-feed-content">
                                            <h4><span class="feed-author" style="margin-top:30px" >System Administrator</span> posted system update </h4>
                                            <p class="res-ds-n-t" style="margin-bottom:50px">6:50 pm - 09.18.2019</p>
                                            <span class="feed-ago" >8h ago</span>
                                            <pre class="comment-content" style="display: block; white-space: pre; border:none; background-color:white; font-family: 'Open Sans', sans-serif;">

                                           

                                            </pre>
                                        </div>
                                    </div>
                                    <div class="clear"></div>

                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4" >
                            <div class="sparkline9-list shadow-reset mg-tb-30">
                                <div class="sparkline9-hd">
                                    <div class="main-sparkline9-hd">
                                        <h1>Functional Group</h1>
                                        <div class="sparkline9-outline-icon">
                                            <span class="sparkline9-collapse-link"><i class="fa fa-chevron-up"></i></span>
                                            <span><i class="fa fa-wrench"></i></span>
                                            <span class="sparkline9-collapse-close"><i class="fa fa-times"></i></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="sparkline9-graph dashone-comment">
                                    <div class="datatable-dashv1-list custom-datatable-overright dashtwo-project-list-data">
                               
                                        <table id="table1" data-toggle="table" data-pagination="true" data-search="false" data-show-columns="false" data-resizable="true" data-cookie="true" data-page-size="5" data-page-list="[5, 10, 15, 20, 25]" data-cookie-id-table="saveId" data-show-export="false">
                                            <thead>
                                                <tr>
                                                    <th data-field="state" data-checkbox="true"></th>
                                                    <th data-field="id">ID</th>
                                                    <th data-field="status" data-editable="true" >Status</th>
                                                    <th data-field="date" data-editable="true">Date Closed</th>
                                                    <th data-field="phone" data-editable="true">Head</th>
                                                </tr>
                                            </thead>
                                            <tbody id="functable">
                                                <tr>
                                                    <td></td>
                                                    <td>Sales</td>
                                                    <td class="canceled-project-dashtwo" id="SASO" style="width: 10px"></td>
                                                    <td id="SASODATE"> </td>
                                                    <td id="SASOHEAD"></td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td>IMS/Sourcing </td>
                                                    <td class="complete-project-dashtwo" id="IMSSOURC"></td>
                                                    <td id="IMSSOURCDATE">9/18/2019</td>
                                                    <td id="IMSSOURCHEAD" ></td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td>Accounting</td>
                                                    <td class="canceled-project-dashtwo" id="ACCTG"></td>
                                                    <td id="ACCTGDATE" > </td>
                                                    <td id="ACCTGHEAD" ></td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td>Production</td>
                                                    <td class="canceled-project-dashtwo" id="PROD"></td>
                                                    <td id="PRODDATE"> </td>
                                                    <td id="PRODHEAD"></td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td>Monthend</td>
                                                    <td class="canceled-project-dashtwo" id="MONTHEND"></td>
                                                    <td id="MONTHENDDATE">    </td>
                                                    <td id="MONTHENDHEAD"></td>
                                                </tr>
                                              

                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="sparkline8-list shadow-reset mg-tb-30"  >
                                <div class="sparkline8-hd">
                                    <div class="main-sparkline8-hd">
                                        <h1>Notes</h1>
                                        <div class="sparkline8-outline-icon">
                                            <span class="sparkline8-collapse-link"><i class="fa fa-chevron-up"></i></span>
                                            <span><i class="fa fa-wrench"></i></span>
                                            <span class="sparkline8-collapse-close"><i class="fa fa-times"></i></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="sparkline8-graph dashone-comment messages-scrollbar dashtwo-messages" id="Notes"  >
                            <%--        <div class="comment-phara">
                                        <div class="comment-adminpr">
                                            <a class="dashtwo-messsage-title" href="#">Toman Alva</a>
                                            <p class="comment-content">Start each day with a prayer and end your day with a prayer and thank God for a another day.</p>
                                        </div>
                                        <div class="admin-comment-month">
                                            <p class="comment-clock"><i class="fa fa-clock-o"></i> 1 minuts ago</p>
                                            <button class="comment-setting" data-toggle="collapse" data-target="#adminpro-demo1">...</button>
                                            <ul id="adminpro-demo1" class="comment-action-st collapse">
                                                <li><a href="#">Add</a>
                                                </li>
                                                <li><a href="#">Report</a>
                                                </li>
                                                <li><a href="#">Hide Message</a>
                                                </li>
                                                <li><a href="#">Turn on Message</a>
                                                </li>
                                                <li><a href="#">Turn off Message</a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="comment-phara">
                                        <div class="comment-adminpr">
                                            <a class="dashtwo-messsage-title" href="#">William Jon</a>
                                            <p class="comment-content">Simple & easy online tools to increase the website visitors, improve SEO, marketing & sales, automatic blog!</p>
                                        </div>
                                        <div class="admin-comment-month">
                                            <p class="comment-clock"><i class="fa fa-clock-o"></i> 5 minuts ago</p>
                                            <button class="comment-setting" data-toggle="collapse" data-target="#adminpro-demo2">...</button>
                                            <ul id="adminpro-demo2" class="comment-action-st collapse">
                                                <li><a href="#">Add</a>
                                                </li>
                                                <li><a href="#">Report</a>
                                                </li>
                                                <li><a href="#">Hide Message</a>
                                                </li>
                                                <li><a href="#">Turn on Message</a>
                                                </li>
                                                <li><a href="#">Turn off Message</a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="comment-phara">
                                        <div class="comment-adminpr">
                                            <a class="dashtwo-messsage-title" href="#">Mexicano</a>
                                            <p class="comment-content">Soy cursi, twitteo frases pedorras y vendo antojitos mexicanos. Santa Rosa, La Pampa, Argentina</p>
                                        </div>
                                        <div class="admin-comment-month">
                                            <p class="comment-clock"><i class="fa fa-clock-o"></i> 15 minuts ago</p>
                                            <button class="comment-setting" data-toggle="collapse" data-target="#adminpro-demo3">...</button>
                                            <ul id="adminpro-demo3" class="comment-action-st collapse">
                                                <li><a href="#">Add</a>
                                                </li>
                                                <li><a href="#">Report</a>
                                                </li>
                                                <li><a href="#">Hide Message</a>
                                                </li>
                                                <li><a href="#">Turn on Message</a>
                                                </li>
                                                <li><a href="#">Turn off Message</a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="comment-phara">
                                        <div class="comment-adminpr">
                                            <a class="dashtwo-messsage-title" href="#">Bhadkamkar</a>
                                            <p class="comment-content">News love and follow Jesus and my family and friends l hope God bless you always.</p>
                                        </div>
                                        <div class="admin-comment-month">
                                            <p class="comment-clock"><i class="fa fa-clock-o"></i> 20 minuts ago</p>
                                            <button class="comment-setting" data-toggle="collapse" data-target="#adminpro-demo4">...</button>
                                            <ul id="adminpro-demo4" class="comment-action-st collapse">
                                                <li><a href="#">Add</a>
                                                </li>
                                                <li><a href="#">Report</a>
                                                </li>
                                                <li><a href="#">Hide Message</a>
                                                </li>
                                                <li><a href="#">Turn on Message</a>
                                                </li>
                                                <li><a href="#">Turn off Message</a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="comment-phara">
                                        <div class="comment-adminpr">
                                            <a class="dashtwo-messsage-title" href="#">SHAKHAWAT</a>
                                            <p class="comment-content">Make the Best Use of What You Have.You Never Know When & Where You Find Yourself..</p>
                                        </div>
                                        <div class="admin-comment-month">
                                            <p class="comment-clock"><i class="fa fa-clock-o"></i> 25 minuts ago</p>
                                            <button class="comment-setting" data-toggle="collapse" data-target="#adminpro-demo5">...</button>
                                            <ul id="adminpro-demo5" class="comment-action-st collapse">
                                                <li><a href="#">Add</a>
                                                </li>
                                                <li><a href="#">Report</a>
                                                </li>
                                                <li><a href="#">Hide Message</a>
                                                </li>
                                                <li><a href="#">Turn on Message</a>
                                                </li>
                                                <li><a href="#">Turn off Message</a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="comment-phara comment-bd-phara">
                                        <div class="comment-adminpr">
                                            <a class="dashtwo-messsage-title" href="#">Sarah</a>
                                            <p class="comment-content">A 'Power Chick' committed to using my superpowers for good. Author, speaker, radio host.</p>
                                        </div>
                                        <div class="admin-comment-month">
                                            <p class="comment-clock"><i class="fa fa-clock-o"></i> 27 minuts ago</p>
                                            <button class="comment-setting" data-toggle="collapse" data-target="#adminpro-demo6">...</button>
                                            <ul id="adminpro-demo6" class="comment-action-st collapse">
                                                <li><a href="#">Add</a>
                                                </li>
                                                <li><a href="#">Report</a>
                                                </li>
                                                <li><a href="#">Hide Message</a>
                                                </li>
                                                <li><a href="#">Turn on Message</a>
                                                </li>
                                                <li><a href="#">Turn off Message</a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>--%>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
         
        </div>
    </div>
    <!-- Footer Start-->

    <!-- Footer End-->
    <!-- Chat Box Start-->
  <%--  <div class="chat-list-wrap">
        <div class="chat-list-adminpro">
            <div class="chat-button">
                <span data-toggle="collapse" data-target="#chat" class="chat-icon-link"><i class="fa fa-comments"></i></span>
            </div>
            <div id="chat" class="collapse chat-box-wrap shadow-reset animated zoomInLeft">
                <div class="chat-main-list">
                    <div class="chat-heading">
                        <h2>FreshDesk Ticket</h2>
                    </div>
                    <div class="chat-content chat-scrollbar">
                        <div class="author-chat">
                            <h3>Mets HelpDesk<span class="chat-date" >GWL</span></h3>
                            <p>How we can help you?</p>
                        </div>
                    <%--    <div class="client-chat">
                            <h3>Mamun <span class="chat-date">10:10 am</span></h3>
                            <p>Now working in graphic design with coding and you?</p>
                        </div>
                        <div class="author-chat">
                            <h3>Monica <span class="chat-date">10:05 am</span></h3>
                            <p>Practice in programming</p>
                        </div>
                        <div class="client-chat">
                            <h3>Mamun <span class="chat-date">10:02 am</span></h3>
                            <p>That's good man! carry on...</p>
                        </div>--%>
                 <%--   </div>
                    <div class="chat-send">
                        <input type="text" placeholder="Type..." />
                        <span><button type="submit" style="width:30%"  onclick="window.open('https://metsit.freshdesk.com/a/tickets/new')">Send</button></span>
                    </div>
                </div>
            </div>
        </div>
    </div>--%>
    <!-- Chat Box End-->
    <!-- jquery
		============================================ -->
    <script src="js/vendor/jquery-1.11.3.min.js"></script>
    <!-- bootstrap JS
		============================================ -->
    <script src="js/bootstrap.min.js"></script>
    <!-- meanmenu JS
		============================================ -->
    <script src="js/jquery.meanmenu.js"></script>
    <!-- mCustomScrollbar JS
		============================================ -->
    <script src="js/jquery.mCustomScrollbar.concat.min.js"></script>
    <!-- sticky JS
		============================================ -->
    <script src="js/jquery.sticky.js"></script>
    <!-- scrollUp JS
		============================================ -->
    <script src="js/jquery.scrollUp.min.js"></script>
    <!-- scrollUp JS
		============================================ -->
    <script src="js/wow/wow.min.js"></script>
    <!-- counterup JS
		============================================ -->
    <script src="js/counterup/jquery.counterup.min.js"></script>
    <script src="js/counterup/waypoints.min.js"></script>
    <script src="js/counterup/counterup-active.js"></script>
    <!-- jvectormap JS
		============================================ -->
    <script src="js/jvectormap/jquery-jvectormap-2.0.2.min.js"></script>
    <script src="js/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <script src="js/jvectormap/jvectormap-active.js"></script>
    <!-- peity JS
		============================================ -->
    <script src="js/peity/jquery.peity.min.js"></script>
    <script src="js/peity/peity-active.js"></script>
    <!-- sparkline JS
		============================================ -->
    <script src="js/sparkline/jquery.sparkline.min.js"></script>
    <script src="js/sparkline/sparkline-active.js"></script>
    <!-- flot JS
		============================================ -->
    <script src="js/flot/jquery.flot.js"></script>
    <script src="js/flot/jquery.flot.tooltip.min.js"></script>
    <script src="js/flot/jquery.flot.spline.js"></script>
    <script src="js/flot/jquery.flot.resize.js"></script>
    <script src="js/flot/jquery.flot.pie.js"></script>
    <script src="js/flot/jquery.flot.symbol.js"></script>
    <script src="js/flot/jquery.flot.time.js"></script>
    <script src="js/flot/dashtwo-flot-active.js"></script>
    <!-- data table JS
		============================================ -->
    <script src="js/data-table/bootstrap-table.js"></script>
    <script src="js/data-table/tableExport.js"></script>
    <script src="js/data-table/data-table-active.js"></script>
    <script src="js/data-table/bootstrap-table-editable.js"></script>
    <script src="js/data-table/bootstrap-editable.js"></script>
    <script src="js/data-table/bootstrap-table-resizable.js"></script>
    <script src="js/data-table/colResizable-1.5.source.js"></script>
    <script src="js/data-table/bootstrap-table-export.js"></script>

        <!-- notification JS
		============================================ -->
    <script src="js/Lobibox.js"></script>
    <script src="js/notification-active.js"></script>
    <!-- main JS
		============================================ -->
    <script src="js/main.js"></script>

</body>

</html>