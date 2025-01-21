<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmAssetDashboard.aspx.cs" Inherits="GWL.frmAssetDashboard" %>

<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Dashboard v.2.0 | Adminpro - Admin Template</title>
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
        <!-- modals CSS
		============================================ -->
    <link rel="stylesheet" href="css/modals.css">

    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>

    <script type="text/javascript" src="https://assets.freshdesk.com/widget/freshwidget.js"></script><script type="text/javascript">
FreshWidget.init("", { "queryString": "&helpdesk_ticket[requester]=&helpdesk_ticket[subject]=&helpdesk_ticket[custom_field][phone_number]={{user.phone}}", "utf8": "✓", "widgetType": "popup", "buttonType": "text", "buttonText": "Support", "buttonColor": "white", "buttonBg": "#02b875", "alignment": "2", "offset": "85%", "formHeight": "500px", "url": "https://metsit.freshdesk.com" });

   </script>

    <script>

       

        $(document).ready(function () {
            Refresh();
         //   window.location.href = '../Translist.aspx?val=%7eg+DNUHlpMLOg2AvjvMlEdvzd73AFAnzvCwXeQx7BMJz8HkWFoxjF7WtlVblHHTtW8OWFdDpftMbw5o3A8pmpQEYgG7UL9fjByZO4ZSok2sSjcRrP%2f9BeP+h0HHaWwsi2&prompt=Asset+Disposal&frm=.%5cAccounting%5cfrmAssetDisposal.aspx&date1=7%2f1%2f2019&date2=10%2f5%2f2019&ribbon=RNew%3aRSubmit%3aRCancel%3aRExport%3aRPost&transtype=ACTADI&moduleid=ACTADI&sp=AssetDisposal_Submit&access=AEDVCRPIGQQP%5eAEDVCRPIGQQP%5e&parameters=&glpost=AssetDisposal_Post&funcg=ACCTGm';
        });



        function CounterUp()
        {
            $('.counter').counterUp({
                delay: 10,
                time: 1000
            });
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
                url: "frmAssetDashboard.aspx/GetValue",
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

                    CounterUp();
                    
                }
            });


        }

        function DB() {

            $('#ASSDEP').empty();
            $('#TOTASS').empty();
            $('#ASSDIS').empty();
            $('#ASSFST').empty();

            var str = ''
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmAssetDashboard.aspx/GetDashboard",
                data: '{ID: "' + '' + '"}',
                dataType: "json",
                success: function (data) {


                    for (var i = 0; i < data.d.length; i++) {

                    
                        //str += '<div class="comment-phara">' +
                        //                '<div class="comment-adminpr">' +
                        //                '<a class="dashtwo-messsage-title" href="#">' + '' + '</a>' +
                        //                '<p class="comment-content">' + data.d[i].Code + '</p>' +
                        //                '</div>' +
                        //                '<div class="admin-comment-month">' +
                        //                '    <p class="comment-clock"><i class="fa fa-clock-o"></i> ' + data.d[i].Description + '</p>' +
                        //                '    <button class="comment-setting" data-toggle="collapse" data-target="#adminpro-demo5">...</button>' +
                        //                '</div>' +
                        //                '</div>'

                        str = '<tr> '+
                            '<td>'+data.d[i].Category+'</td>' +
                            '<td class="counter">' + data.d[i].Value + '</td>' +
                            ' </tr>'

                        $('#' + data.d[i].Code).append(str);
                                                
                       
                    }
                    //$('#Notes').empty();
                    //$('#Notes').append(str);

                },
                error: function (data) {
                    console.log(data)
                }
            });

      


          
        }

        function PieAsset() {

            var str = ''
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmAssetDashboard.aspx/GetAssetInfo",
                data: '{ID: "' + '' + '"}',
                dataType: "json",
                success: function (data) {

                    var ctx = document.getElementById("assetpie");
                   
                    //var val = [999, 230, 320, 420, 600];
                    var str = "[";
                    for (var i = 0; i < data.d.length; i++) {
                        if (i >= 5) {
                            str += "'Others'";
                            break;
                        }else
                        {
                            str += "'" + data.d[i].Description + "',";
                        }
                    }


                    str += "]"

                    console.log(str);
                    var Col = eval(str);

                    var str = "[";
                    var oth = 0.00;
                    for (var i = 0; i < data.d.length; i++) {

                        if (i >= 5) {
                            oth += parseFloat(data.d[i].RunningValue);
                        } else {
                            str += data.d[i].RunningValue + ",";
                        }
                       

                    }
                    console.log(oth);
                    if (oth != 0)
                    {
                        str += oth.toFixed(2)+"]"
                    } else {
                        str += "]"
                    }


                   
                    console.log(str);
                    var val = eval(str);


            var piechart = new Chart(ctx, {
                type: 'pie',
                data: {
                    toolTipContent: "{y} (#percent%)",
                    labels: Col,
                    datasets: [{
                        indexLabel: "{1}",
                        indexLabelPlacement: "outside",
                        label: 'pie Chart',
                        backgroundColor: [
                            'rgba(240, 3, 3, 0.6)',
                            'rgba(28, 132, 198, 0.6)',
                            'rgba(26, 179, 148, 0.6)',
                            'rgba(255, 127, 14, 0.6)',
                            'rgba(153, 102, 255, 0.6)'
                        ],
                        borderColor: [
                        'rgba(240, 3, 3,1)',
                        'rgba(28, 132, 198, 1)',
                        'rgba(26, 179, 148, 1)',
                        'rgba(255, 127, 14, 1)',
                        'rgba(153, 102, 255, 1)'
                        ],
                        borderWidth: 1,
                        data: val
                    }]
                },
                options: {
                    responsive: true,
                    legend: {
                        display: false,
                        position: 'left',
                        
                    },
                    title: {
                        display: true,
                        text: 'Asset Group %'
                    },
                    animation: {
                        animateRotate: true,
                        animateScale: true
                    }
                }
            });


                },
                error: function (data) {
                    console.log(data)
                }
            });
        }

        function BarAsset() {

            var str = ''
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmAssetDashboard.aspx/GetAssetInfo",
                data: '{ID: "' + '' + '"}',
                dataType: "json",
                success: function (data) {

                    var ctx = document.getElementById("assetbar");

                    //var val = [999, 230, 320, 420, 600];
                    var str = "[";
                    for (var i = 0; i < data.d.length; i++) {
                        str += "'" + data.d[i].Description + "',";
                    }


                    str += "]"
                    console.log(str);
                    var Col = eval(str);

                    var str = "[";
                    for (var i = 0; i < data.d.length; i++) {
                        str += data.d[i].Completion + ",";
                    }


                    str += "]"
                    console.log(str);
                    var val = eval(str);


                    //var ctx = document.getElementById("barchart1");
                    var barchart1 = new Chart(ctx, {
                        type: 'horizontalBar',
                        data: {
                            labels: Col,
                            datasets: [{
                                label: 'Depreciation',
                                data: val,
                                backgroundColor: [
                                        'rgba(240, 3, 3, 0.6)',
                                    'rgba(28, 132, 198, 0.6)',
                                    'rgba(26, 179, 148, 0.6)',
                                    'rgba(255, 127, 14, 0.6)',
                                    'rgba(153, 102, 255, 0.6)'
                                ],
                                borderColor: [
                                        'rgba(240, 3, 3, 1)',
                                    'rgba(28, 132, 198, 1)',
                                    'rgba(26, 179, 148, 1)',
                                    'rgba(255, 127, 14, 1)',
                                    'rgba(153, 102, 255, 1)'
                                ],
                                borderWidth: 1
                            }]
                        },
                        options: {
                            legend: {
                                display: false
                            },
                            title: {
                                display: true,
                                text: 'Depreciation Summary %'
                            },
                            scales: {
                                xAxes: [{
                                    ticks: {
                                        autoSkip: false,
                                        maxRotation: 0,
                                        fontColor: "#000"

                                    }
                                }],
                                yAxes: [{
                                    ticks: {
                                        barPercentage: 0.5,
                                        autoSkip: false,
                                        maxRotation: 0,
                                        fontColor: "#000"
                                    }
                                }]
                            }
                        }
                    });


                },
                error: function (data) {
                    console.log(data)
                }
            });
        }

        function BarStacked() {
            var ctx = document.getElementById("AssetDept");

            var str = ''
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmAssetDashboard.aspx/GetLocation",
                data: '{ID: "' + '' + '"}',
                dataType: "json",
                success: function (data) {

                    eval(data.d[0].Location);
         
                    console.log(data.d[0].Location);

            //var barchart5 = new Chart(ctx, {
            //    type: 'bar',
            //    data: {
            //        labels: ["Transportations", "Office", "Furnitures", "Building", "Software"],


            //        datasets: [
            //        {
            //            label: 'Sales',
            //            backgroundColor: 'rgba(240, 3, 3, 0.6)',
            //            borderColor: 'rgba(240, 3, 3,1)',
            //            borderWidth: 1,
            //            data: [12, 19, 3, 5, 13]
            //        }, {
            //            label: 'Accounting',
            //            backgroundColor: 'rgba(54, 162, 235, 0.6)',
            //            borderColor: 'rgba(54, 162, 235, 1)',
            //            borderWidth: 1,
            //            data: [10, 15, 7, 7, 4]

            //        }, {
            //            label: 'Purchasing',
            //            backgroundColor: 'rgba(75, 192, 192, 0.6)',
            //            borderColor: 'rgba(75, 192, 192, 1)',
            //            borderWidth: 1,
            //            data: [15, 18, 3, 6, 5]

            //        }

            //        ]

            //    },

            //    options: {
            //        title: {
            //            display: true,
            //            text: "Assets per Location"
            //        },
            //        tooltips: {
            //            mode: 'index',
            //            intersect: true
            //        },
            //        responsive: true,
            //        scales: {
            //            xAxes: [{
            //                ticks: {
            //                    autoSkip: false,
            //                    maxRotation: 0,
            //                    fontColor: "#000"
            //                },
            //                stacked: true
            //            }],
            //            yAxes: [{
            //                ticks: {
            //                    autoSkip: false,
            //                    maxRotation: 0,
            //                    fontColor: "#000"
            //                },
            //                stacked: true
            //            }]
            //        }
            //    }
                    //});
               
                  
                },
                error: function (data) {
                    console.log(data)
                }
            });
        }
   

        function Refresh() {
    
            PieAsset();
            BarAsset();
            BarStacked();
            TransCount();
            DB();

        }
   
             
    </script>

    <style>
        .adminpro-icon {
    font-size: 25px;
    margin-left:20%;

}

        .button {
  display: inline-block;
  border-radius: 4px;
  background-color: #03a9f0;
  border: none;
  color: #FFFFFF;
  text-align: center;
  font-size: 14px;
  padding: 1px 10px 1px  10px;
  
  transition: all 0.5s;
  cursor: pointer;
  margin: 5px;
}

.button span {
  cursor: pointer;
  display: inline-block;
  position: relative;
  transition: 0.5s;
}

.button span:after {
  content: '\00bb';
  position: absolute;
  opacity: 0;
  top: 0;
  right: -10px;
  transition: 0.5s;
}

.button:hover span {
  padding-right: 10px;
}

.button:hover span:after {
  opacity: 1;
  right: 0;
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
                                        <h2 >Assets</h2>
                                        <div class="main-income-phara">
                                            <p id="Refresh" onclick="Refresh(); "  >All</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="income-dashone-pro">
                                    <div class="income-rate-total">
                                        <div class="price-adminpro-rate">
                                            <h3><a class="counter" id="unsubmitted" data-target="#TotalAssetmodal" data-toggle="modal">0</a></h3>
                                        </div>
                                        <div class="price-graph">
                                            <span><img class="manImg" src="../images/barcode.png" style="height:40px"></img></span>
                                        </div>
                                    </div>
                                    <div class="income-range">
                                        <p>Total Assets</p>
                                       
                                    </div>
                                    <div class="clear"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="income-dashone-total shadow-reset nt-mg-b-30">
                                <div class="income-title">
                                    <div class="main-income-head">
                                        <h2>For Setup</h2>
                                        <div class="main-income-phara order-cl" onclick="PieAsset(); BarAsset(); BarStacked();">
                                            <p>Monthly</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="income-dashone-pro">
                                    <div class="income-rate-total">
                                        <div class="price-adminpro-rate">
                                            <h3><a class="counter" id="submitted" data-target="#ForSetup" data-toggle="modal">0</a></h3>
                                        </div>
                                        <div class="price-graph">
                                           <img class="manImg" src="../images/checklist.png" style="height:40px"></img>
                                        </div>
                                    </div>
                                    <div class="income-range order-cl">
                                        <p>Pending for Setup</p>
                                        
                                    </div>
                                    <div class="clear"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="income-dashone-total shadow-reset nt-mg-b-30">
                                <div class="income-title">
                                    <div class="main-income-head">
                                        <h2>Depreciated</h2>
                                        <div class="main-income-phara visitor-cl" >
                                            <p>All</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="income-dashone-pro">
                                    <div class="income-rate-total">
                                        <div class="price-adminpro-rate">
                                            <h3><a class="counter" id="cancelled" data-target="#Depreciated" data-toggle="modal">0</a></h3>
                                        </div>
                                        <div class="price-graph">
                                           <img class="manImg" src="../images/arrow.png" style="height:40px"></img>
                                        </div>
                                    </div>
                                    <div class="income-range visitor-cl">
                                        <p>Fully Depreciated</p>
                                       
                                    </div>
                                    <div class="clear"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="income-dashone-total shadow-reset nt-mg-b-30">
                                <div class="income-title">
                                    <div class="main-income-head">
                                        <h2>Disposal</h2>
                                        <div class="main-income-phara low-value-cl">
                                            <p>Annual</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="income-dashone-pro">
                                    <div class="income-rate-total">
                                        <div class="price-adminpro-rate">
                                            <h3><a class="counter" id="unposted" data-target="#Disposed" data-toggle="modal">0</a></h3>
                                        </div>
                                        <div class="price-graph">
                                           <img class="manImg" src="../images/trash.png" style="height:40px"></img>
                                        </div>
                                    </div>
                                    <div class="income-range low-value-cl">
                                        <p>Disposed</p>
                                      
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
                        <div class="col-lg-4">
                   
                            <div class="dashtwo-order-list shadow-reset" >
                                 
                                <div class="row" style="margin: 5px" >
                                            <div id="pie-chart">
                                    <canvas id="assetpie"></canvas>
                                </div>

                                               
                                   
                                </div>
                            </div>

                            
                        </div>
                        
                                       <div class="col-lg-8">
                                         
                            <div class="dashtwo-order-list shadow-reset">
                                
                                <div class="row">
                                     <div id="bar1-chart">
                                    <canvas id="assetbar"></canvas>
                                </div>
                                  
                                </div>
                            </div>
                        </div>
                         <div class="clear"></div>
                    </div>
                </div>
            </div>  
            <div class="feed-mesage-project-area">
                <div class="container-fluid">
                    <div class="row">
                      
                        <div class="col-lg-12" >
                            <div class="sparkline9-list shadow-reset mg-tb-30">
                                
                                <div class="sparkline9-graph dashone-comment">
                                    <div class="datatable-dashv1-list custom-datatable-overright dashtwo-project-list-data">
                               
                                   
                                       
                                       
                                          
                                
                                <div class="sparkline9-graph dashone-comment">
                                    <div class="datatable-dashv1-list custom-datatable-overright dashtwo-project-list-data">
                               
                                <%--                <div   class="sparkline8-graph">
                                    <div id="stocked"> </div>
                                </div>--%>

                                           <div id="bar5-chart">
                                    <canvas id="AssetDept"></canvas>
                                    </div>

                                        
                                </div>
                                     </div>
                                    </div>
                                </div>
                            </div>

                             <div class="dashtwo-order-list shadow-reset" style="visibility:hidden;">
                                 
                                 <div id="pie-chart2">
                                    <canvas id="piechart2"></canvas>
                                </div>
                            </div>
                        </div>
                     
                    </div>
                </div>
            </div>
         

             <!-- MODALS-->
           
                            <div id="TotalAssetmodal" class="modal modal-adminpro-general default-popup-PrimaryModal fade" role="dialog">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-close-area modal-close-df"  >
                                           
                                        </div>
                                        
                                            <div class="modal-header header-color-modal bg-color-1" style="background-color:#f9f9f9; height:40px; padding: 10px">
                                                 <a class="close" data-dismiss="modal" href="#" ><i class="fa fa-close"></i></a>
                                            <h5 class="modal-title" style="color:black; font-weight:600" >Total Assets</h5>
                                           
                                        </div>

                                        <div class="modal-body" style="padding: 0px ">
                                                   <div class="sparkline10-graph">
                                    <div class="static-table-list">


                                        <table class="table sparkle-table" style="text-align:left"">
                                            <thead>
                                                <tr>
                                                    <th style="width:70%;">Category</th>
                                                    <th  style="text-align:left">Count</th>
                                                </tr>
                                            </thead>
                                            <tbody id="TOTASS">
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                        </div>
                                        <div class="modal-footer">
                                           
                                      <button id="btnAssets" class="button" style="vertical-align:middle" 
                                                ><span>View All Assets</span></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
            
                            <div id="ForSetup" class="modal modal-adminpro-general default-popup-PrimaryModal fade" role="dialog">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-close-area modal-close-df"  >
                                           
                                                    </div>
                                        
                                                        <div class="modal-header header-color-modal bg-color-1" style="background-color:#f9f9f9; height:40px; padding: 10px">
                                                             <a class="close" data-dismiss="modal" href="#" ><i class="fa fa-close"></i></a>
                                                        <h5 class="modal-title" style="color:black; font-weight:600" >Asset for Setup</h5>
                                           
                                                    </div>

                                                    <div class="modal-body" style="padding: 0px ">
                                                               <div class="sparkline10-graph">
                                                <div class="static-table-list">


                                                    <table class="table sparkle-table" style="text-align:left"">
                                                        <thead>
                                                            <tr>
                                                                <th style="width:70%;">Category</th>
                                                                <th  style="text-align:left">Count</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody  id="ASSFST">
                                                        
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>

                                                    </div>
                                                    <div class="modal-footer">
                                                                                 <button class="button" style="vertical-align:middle" 
                                                Onclick="  document.getElementById('ctl00_ctl00_ASPxSplitter1_Content_ASPxSplitter1_1_CC').src = '../Translist.aspx?val=~E6YO0BPtmj4lisOP7sUG7w0OR9Im1pW6fe/7Z6io7So6r1FxGaGJ/1vCNRA47bmw06p8HqWqbr0lZuh9l5D9g9p4dc9weTTli0+5F4RYwrGFNFGDc2e/8viuV5yifnX89hxGJknPp+a28W4Ngrki4D8WhoSLrKKC4QvnL5mmJ1qKwrzHVHXQFgORrpHL0P3oaiEimzZwOaWHJveAuGo5FmBRTXTDQS+GtEdG/HhBZSPuhwEkiVxJhiEYS7hGLDJNa/cg8DnWff4WVx1EEeAzlMTlfpg5bDFJdS+NE441xxT7Ltqjtv8BVk5nZTG4MxOTwocVBkDCGOk0nLBlQgsp+6Kfp43LZVOrCb2t9+tLQtdvk3pyMBlgDZwJ7Nj4WUNPp8dn66Hks2r9tKOxaWsc2S6NDglQMB77KdZDiRRKst/dcPYKuP0WWxJbK1CNXDjUhfpS16zrxixKgEuat23VYYAqR+QKejFThWOLcDHRI9Y3YpX+11vCV9jKDOmPi/iOoBjgofOerOngcLs/WamJta/yIHID/HIC/p2SUT5olATA1jzoHTgAKf0oiRsWW6vG3dNvjWYUnW9IiwEk2kXnaAXAeBwsTOKQk6wOn0xk4VWje/mfpYMIIgmMUcVuF81e++T+OxYA3ylCig3X6vcEq5JFyofchJiVAOm/gVd9W8iW6jHsTiaQglVhrGkhgn0E65Wxu5n10ciSGlt0pHchmXLs31YqRUg+sgY7sg3HSgc=&prompt=Asset%20Acquisition&frm=.\Procurement\frmReceivingReport.aspx&date1=7/1/2019&date2=10/5/2019&ribbon=RNew:RSubmit:RACCTGEdit:RACCTGSubmit:RPropertySetup:RCancel:RPrint:RExport:RAutoAPVouch:RPost&transtype=ACTAQT&moduleid=ACTAQT&sp=ReceivingReport_Submit&access=AEDVCRPIGQQP^XWFAEDVCRPIGQQP^ZXW&parameters=R&glpost=ReceivingReportEntry_Post&funcg=ACCTG';
";
                                                ><span>Setup an Asset</span></button>
                                
                                                    </div>
                                                </div>
                                            </div>
                                        </div>


              <div id="Disposed" class="modal modal-adminpro-general default-popup-PrimaryModal fade" role="dialog">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-close-area modal-close-df"  >
                                           
                                                    </div>
                                        
                                                        <div class="modal-header header-color-modal bg-color-1" style="background-color:#f9f9f9; height:40px; padding: 10px">
                                                             <a class="close" data-dismiss="modal" href="#" ><i class="fa fa-close"></i></a>
                                                        <h5 class="modal-title" style="color:black; font-weight:600" >Disposed Assets</h5>
                                            
                                                    </div>

                                                    <div class="modal-body" style="padding: 0px ">
                                                               <div class="sparkline10-graph">
                                                <div class="static-table-list">


                                                    <table class="table sparkle-table" style="text-align:left"">
                                                        <thead>
                                                            <tr>
                                                                <th style="width:70%;">Category</th>
                                                                <th  style="text-align:left">Count</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody  id="ASSDIS">
                                                        
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>

                                                    </div>
                                                    <div class="modal-footer">
                                            <button class="button" style="vertical-align:middle" 
                                                Onclick="           document.getElementById('ctl00_ctl00_ASPxSplitter1_Content_ASPxSplitter1_1_CC').src = '../Translist.aspx?val=%7eg+DNUHlpMLOg2AvjvMlEdvzd73AFAnzvCwXeQx7BMJz8HkWFoxjF7WtlVblHHTtW8OWFdDpftMbw5o3A8pmpQEYgG7UL9fjByZO4ZSok2sSjcRrP%2f9BeP+h0HHaWwsi2&prompt=Asset+Disposal&frm=.%5cAccounting%5cfrmAssetDisposal.aspx&date1=7%2f1%2f2019&date2=10%2f5%2f2019&ribbon=RNew%3aRSubmit%3aRCancel%3aRExport%3aRPost&transtype=ACTADI&moduleid=ACTADI&sp=AssetDisposal_Submit&access=AEDVCRPIGQQP%5eAEDVCRPIGQQP%5e&parameters=&glpost=AssetDisposal_Post&funcg=ACCTGm';
";
                                                ><span>Asset Disposal </span></button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>


              <div id="Depreciated" class="modal modal-adminpro-general default-popup-PrimaryModal fade" role="dialog">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-close-area modal-close-df"  >
                                           
                                                    </div>
                                        
                                                        <div class="modal-header header-color-modal bg-color-1" style="background-color:#f9f9f9; height:40px; padding: 10px">
                                                             <a class="close" data-dismiss="modal" href="#" ><i class="fa fa-close"></i></a>
                                                        <h5 class="modal-title" style="color:black; font-weight:600" >Depreciated Assets</h5>
                                           
                                                    </div>

                                                    <div class="modal-body" style="padding: 0px ">
                                                               <div class="sparkline10-graph">
                                                <div class="static-table-list">


                                                    <table class="table sparkle-table" style="text-align:left"">
                                                        <thead>
                                                            <tr>
                                                                <th style="width:70%;">Category</th>
                                                                <th  style="text-align:left">Count</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody  id="ASSDEP">
                                                        
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>

                                                    </div>
                                                    <div class="modal-footer">
                                          
                             
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
        <!-- Common JS -->
    <script src="../js/PerfSender.js" type="text/javascript"></script>


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
        <!-- Charts JS
		============================================ -->
    <script src="js/charts/Chart.js"></script>
    <script src="js/charts/rounded-chart.js"></script>
        <script src="js/charts/bar-chart.js"></script>

           <!-- c3 JS
		============================================ -->
    <script src="js/c3-charts/d3.min.js"></script>
    <script src="js/c3-charts/c3.min.js"></script>
    <script src="js/c3-charts/c3-active.js"></script>

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

       <!-- modal JS
		============================================ -->
    <script src="js/modal-active.js"></script>
    <!-- main JS
		============================================ -->
    <script src="js/main.js"></script>
    <script>
        document.getElementById("btnAssets").addEventListener('click', function () {
            alert(11);
            document.getElementById('ctl00_ctl00_ASPxSplitter1_Content_ASPxSplitter1_1_CC').src = '../Translist.aspx?val=~E6YO0BPtmj4lisOP7sUG7w0OR9Im1pW6fe/7Z6io7So6r1FxGaGJ/1vCNRA47bmw06p8HqWqbr0lZuh9l5D9g9p4dc9weTTli0+5F4RYwrGFNFGDc2e/8viuV5yifnX89hxGJknPp+a28W4Ngrki4D8WhoSLrKKC4QvnL5mmJ1qMTuqgUBEuLCUe30MfD2F5NF3+rWIfnZDqH+OGAEk/HHwktRwg65Et6bJSVbiQfaqrO3kTxjne839d5r3+bz2Vk+IvC9KIWu+gYiPpyQyPrI4BvRVfr51dJd3sMi6nzC2r0CrHyFGF21PsR5DqHvVvEer8thiMgpEijCMBbRmaPgZuruCJLei6peqymY55M26vBUOvrhRE2ENHG7PvWmjMdccA5BSa1LxN9HFSjkn4H12W9x9KGZQaNxaDc4AXddQDhihrdJD65mqXb2wgj22n4TKUh8EX9PFRqZ3DyF5MNvOMN8/vJ8CM0OkPVCpd56IfVoW1W47210mGsP8jy4FQVoJqCGmd0Bu6vCW4Yo0Q3nnxBRlUytduVVwAZ19w0YG9PMwmplI16w3Uz1mScxfjUZiDbL+wnCaLMSgmGaKALPRASoJYWtV4pjv/NawZm6t6/Kk1SnqmUlV84zEPukVk81Ao7JxiIYZrsJT71Ddw2xIy4DddH91YNuoIdABuNjZXYzKAlHl+BKp7/v6mVX/GfA+wO6erAGRvVL18x67p14hjQz6J1KlzXeYRhUWRtmg=&prompt=Asset%20Acquisition&frm=.\Procurement\frmReceivingReport.aspx&date1=9/1/2020&date2=11/6/2020&ribbon=RACCTGEdit:RACCTGSubmit:RCancel:RPrint:RExport:RAutoAPVouch:RPost:RMultiPrint:RExtract&transtype=ACTAQT&moduleid=ACTAQT&sp=ReceivingReport_Submit&access=AEV^YNAECPVGQZUX^FGAEDVCRPIGQQP^XWF[&parameters=R&glpost=ReceivingReportEntry_Post&schemaname=METSIT';
        })
    </script>
</body>

</html>