<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDashboard.aspx.cs" Inherits="GWL.frmDashboard" %>


<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>
    
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
      <script src="../js/PerfSender.js" type="text/javascript"></script>
     <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">



    <link rel="stylesheet" href="css/c3.min.css">
    
    <!-- responsive CSS
		============================================ -->
    <link rel="stylesheet" href="css/responsive.css">
   

     <!-- notifications CSS
		============================================ -->
    <link rel="stylesheet" href="css/Lobibox.min.css"/>
    <link rel="stylesheet" href="css/notifications.css"/>


    <title></title>

          <style>
         .tabbable-panel {
         border:1px solid #eee;
         padding: 10px;
         }Gene
         .tabbable-line > .nav-tabs {
         border: none;
         margin: 0px;
         }
         .tabbable-line > .nav-tabs > li {
         margin-right: 2px;
         }
         .tabbable-line > .nav-tabs > li > a {
         border: 0;
         margin-right: 0;
         color: #737373;
         }
         .tabbable-line > .nav-tabs > li > a > i {
         color: #a6a6a6;
         }
         .tabbable-line > .nav-tabs > li.open, .tabbable-line > .nav-tabs > li:hover {
         border-bottom: 4px solid rgb(80,144,247);
         }
         .tabbable-line > .nav-tabs > li.open > a, .tabbable-line > .nav-tabs > li:hover > a {
         border: 0;
         background: none !important;
         color: #333333;
         }
         .tabbable-line > .nav-tabs > li.open > a > i, .tabbable-line > .nav-tabs > li:hover > a > i {
         color: #a6a6a6;
         }
         .tabbable-line > .nav-tabs > li.open .dropdown-menu, .tabbable-line > .nav-tabs > li:hover .dropdown-menu {
         margin-top: 0px;
         }
         .tabbable-line > .nav-tabs > li.active {
         border-bottom: 4px solid #32465B;
         position: relative;
         }
         .tabbable-line > .nav-tabs > li.active > a {
         border: 0;
         color: #333333;
         }
         .tabbable-line > .nav-tabs > li.active > a > i {
         color: #404040;
         }
         .tabbable-line > .tab-content {
         margin-top: -3px;
         background-color: #fff;
         border: 0;
         border-top: 1px solid #eee;
         padding: 15px 0;
         }
         .portlet .tabbable-line > .tab-content {
         padding-bottom: 0;
         }
      </style>

</head>
<body style="height: 107px; background-color:transparent">
<div class="container-fluid">
         <div class="row">
            <div class="col-md-12" style="padding: 0">
             
               <div class="tabbable-panel" style="padding:0">
                  <div class="tabbable-line">
                     <ul class="nav nav-tabs " id="tabheader">
                    <%--    <li class="">
                           <a href="#tab_default_1" data-toggle="tab" aria-expanded="true">
                           Basic Dashboard </a>
                        </li>
                        <li class="active" >
                           <a href="#tab_default_2" data-toggle="tab" aria-expanded="false">
                           CFO Dashboard </a>
                        </li>
                        <li class="">
                           <a  href="#tab_default_7" " data-toggle="tab" aria-expanded="false">
                           General Accounting </a>
                        </li>
                        <li class="">
                           <a href="#tab_default_3" data-toggle="tab" aria-expanded="false">
                           Accounts Receivable </a>
                        </li>
                        <li class="">
                           <a href="#tab_default_4" data-toggle="tab" aria-expanded="false">
                           Accounts Payable </a>
                        </li>
                        <li class="">
                           <a href="#tab_default_5" data-toggle="tab" aria-expanded="false">
                           Cash Management  </a>
                        </li>
                        <li class="">
                           <a href="#tab_default_6" data-toggle="tab" aria-expanded="false">
                           Asset Management  </a>
                        </li>--%>
                     </ul>
                     <div class="tab-content" style="padding:0" id="tabcontent">
                      <%--  <div class="tab-pane" id="tab_default_1"  >
                           <iframe class="MyFrame" src="frmDashboardBasic.aspx"  width="100%" style="padding:0; border:none"></iframe>
                        </div>
                        <div class="tab-pane active" id="tab_default_2">
                            <iframe class="MyFrame" src="frmDashboardCFO.aspx"  width="100%" style="padding:0; border:none"></iframe>
                        </div>
                        <div class="tab-pane" id="tab_default_3">
                           <iframe class="MyFrame" src="frmDashboardAR.aspx"  width="100%" style="padding:0; border:none"></iframe>
                        </div>
                        <div class="tab-pane" id="tab_default_4">
                           <iframe class="MyFrame" src="frmDashboardAP.aspx"  width="100%" style="padding:0; border:none"></iframe>
                        </div>
                        <div class="tab-pane" id="tab_default_5">
                           <iframe class="MyFrame" src="frmDashboardCM.aspx"  width="100%" style="padding:0; border:none"></iframe>
                        </div>
                       <div class="tab-pane" id="tab_default_6">
                           <iframe class="MyFrame" src="frmAssetDashboard.aspx"  width="100%" style="padding:0; border:none"></iframe>
                        </div>
                         <div class="tab-pane" id="tab_default_7">
                           <iframe class="MyFrame" src = "../Dashboard/GeneralAccounting/GeneralAccounting.html?schemaname=<%=Session["schemaname"] %>"  width="100%" style="padding:0; border:none"></iframe>
                        </div>--%>
                        
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <script>
        const setElementHeight = function () {
                var height = $(window).height();
                $(".MyFrame").css("min-height", height-50);
            };
            $(window)
                .on("resize", function () {
                    setElementHeight();
                })
            .resize();


          document.addEventListener('DOMContentLoaded', function () {
              SetupDashboard();
              notify();
        });


        function SetupDashboard() {

            fetch("frmDashboard.aspx/RetrieveDashboard", {
                method: "POST",
                body: "{}",
                headers: {
                    "Content-Type": "application/json"
                },
            }).then(function (response) {
                return response.json()
            }).then(function (result) {

                var header = "";
                var content = "";
                var activecnt = 0,active="";
                console.table(result.d);
                for (var i = 0; i < result.d.length; i++) {

                    if (result.d[i].Active == "active") {
                        activecnt++;
                       
                    }
                   
                    if (activecnt > 1) {
                        active =""
                    } else {
                        active = result.d[i].Active;
                    }

                    if (result.d.length == 1) {
                        active = "active";

                    }

                   header += "<li class='"+active+"'> <a href='#"+ result.d[i].RoleID+"' data-toggle='tab' aria-expanded='true'>"+ result.d[i].Caption+" </a> </li>";
                   content += "  <div class='tab-pane "+active+"' id='"+result.d[i].RoleID+"'  >  <iframe class='MyFrame' src='"+result.d[i].DashboardName+"'  width='100%' style='padding:0; border:none'></iframe> </div>"
            
                }

                document.getElementById("tabheader").innerHTML = header;
                document.getElementById("tabcontent").innerHTML = content   ;

                setElementHeight();
            }).catch(function (error) {
                console.log(error);
            })
        }

         function notify() {

            $.ajax({
                type: "POST",
                url: "frmDashboard.aspx/GetProjects",
                data: '{name: "' + 'Unsubmitted' + '" ,value: "' + '0' + '"} ',
                datatype: 'text',
                contentType: "application/json; charset=utf-8",
                success: function (result) {


                   
                    Result = result.d + '';
                    
                    if(Result != "0")
                    {
                        Lobibox.notify('info', {
                            msg: 'There are (' + Result + ') Orders for approval',



                            position: 'top right',

                            title: 'Reminder',
                            onClick: function (Lobibox) {
                                window.open("", "_self");
                            }
                        });
                    }


                }
            });


           
        }
   



            
        </script>

        <!-- Common JS -->
    <script src="../js/PerfSender.js" type="text/javascript"></script>

            <!-- notification JS
		============================================ -->
    <script src="js/Lobibox.js"></script>
    <script src="js/notification-active.js"></script>

        <script type="text/javascript" src="https://assets.freshdesk.com/widget/freshwidget.js"></script><script type="text/javascript">
FreshWidget.init("", { "queryString": "&helpdesk_ticket[requester]=&helpdesk_ticket[subject]=&helpdesk_ticket[custom_field][phone_number]={{user.phone}}", "utf8": "✓", "widgetType": "popup", "buttonType": "text", "buttonText": "Support", "buttonColor": "white", "buttonBg": "#02b875", "alignment": "2", "offset": "85%", "formHeight": "500px", "url": "https://metsit.freshdesk.com" });

   </script>
       
</body>
</html>
