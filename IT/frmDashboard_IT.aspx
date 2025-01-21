<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDashboard_IT.aspx.cs" Inherits="GWL.frmDashboard_IT" %>

<%@ Register assembly="DevExpress.Dashboard.v24.2.Web.WebForms, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.DashboardWeb" tagprefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title></title>

        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,700,700i,800" rel="stylesheet"/>
    <!-- Bootstrap CSS
		============================================ -->
    <link rel="stylesheet" href="css/bootstrap.min.css"/>
    <!-- Bootstrap CSS
		============================================ -->
    <link rel="stylesheet" href="css/font-awesome.min.css"/>
    <!-- adminpro icon CSS
		============================================ -->
    <link rel="stylesheet" href="css/adminpro-custon-icon.css"/>
    <!-- meanmenu icon CSS
		============================================ -->
    <link rel="stylesheet" href="css/meanmenu.min.css"/>
    <!-- mCustomScrollbar CSS
		============================================ -->
    <link rel="stylesheet" href="css/jquery.mCustomScrollbar.min.css"/>
    <!-- animate CSS
		============================================ -->
    <link rel="stylesheet" href="css/animate.css"/>
    <!-- normalize CSS
		============================================ -->
    <link rel="stylesheet" href="css/normalize.css"/>
    <!-- notifications CSS
		============================================ -->
    <link rel="stylesheet" href="css/Lobibox.min.css"/>
    <link rel="stylesheet" href="css/notifications.css"/>
    <!-- style CSS
		============================================ -->
    <link rel="stylesheet" href="style.css"/>
    <!-- responsive CSS
		============================================ -->
    <link rel="stylesheet" href="css/responsive.css"/>
    <!-- modernizr JS
		============================================ -->
    <script src="js/vendor/modernizr-2.8.3.min.js"></script>

    <style type="text/css">
                
        table {
            border-collapse: collapse;
        }

        table, th, td {
            border: 3px solid white;
        }

    </style>
    <script>


        $(document).ready(function () {
            setTimeout(function () {
                notify();
            }, 500);






        });

        function notify() {

            $.ajax({
                type: "POST",
                url: "frmDashboard.aspx/GetProjects",
                data: '{name: "' + 'Unsubmitted' + '" ,value: "' + '0' + '"} ',
                datatype: 'text',
                contentType: "application/json; charset=utf-8",
                success: function (result) {



                    Result = result.d + '';

                    if (Result != "0") {
                        Lobibox.notify('error', {
                            msg: 'There are (' + Result + ') Projects pending for billing',



                            position: 'top right',

                            title: 'Reminder',
                            onClick: function (Lobibox) {
                                window.open("http://192.168.180.7:9023/Translist.aspx?val=~2ySEN8Vl2k3U+W88kzFgc6hrL3oMP+3fGzOVUSfmnsGgNvRVb2YxLK/ZAOUmlAPEG2X6fCto/rWKarQXDuSYz0XHAEgGAFdfb9eeSSEIY7eTgTiMk0h9ITAZjTkykkcctvm6klkKzyrGJPOVUnRJtXn+fn6dL50NeQGOaxQdnAurE35ZsU4UZGxEzynWWLQlqTnTKYGRKz5bsarCFYKlsB/CYemPwmgFSxEB/N+kD8SXwKpzxsxXXZdL1yOdUmMhgDJ5mlHDkgc2HlXrtVaUSFFSVgz3eYD6MYurjLBNCveAEZATJWs5zGXklt5qiOL35rYy+dvRwxC5f1eY1tJyRMVNfebsmHZ+fwWPPi72sLUlFSG9jT6pezwIF8RXhpR+mf4CpNX0zV3nT/Ny8uqhH4Cl/hXJiyPxgQMI4oX+v1/H2hXhmei5HBkITtJlFB5Ogo+xWgqIUhf0TMF6XMmqVGo9v9rjcTPNAg2wl5XZqgu0mPo/nA1vSkbpgHAGA+yhvDFdr7GI6SMGs9X4JlTjHPEgvjOJ8cTAbPc21/aIyF/eEi25xjkczyDykhwd0cF0J9C/if3vuQ0sbShTYXP/h6WNOKzrXHU56toExvIjS7FrtpeC5Kt7Pr9cqsblhGX+JLGpkwO1HSieaBOxXfq218RtmnLi88LpsiaRYu5Pr1fiikFHAPNcUhj5Dv2WxOYIv4eUn7Jqh2y9TKpR5u1PUSzO1rvcz+Alr9wT0LyFnpN9xUlHKS2HoPnGxKFGGKWYSCuDvWBsrJsAtpEqjJX78smUIe4TqRiNsICaoxoqR5hHsEpOemLFarzZMUGiyxsTSRz2vPdrFkNR0M96gIJiTw4ptshEHMSuB089g0y43yid0HHchOBOA+wGvWK5XkpFoLUwvbDeO3jRrNn1dIS69UcnvYo+PAx1EEaPkhggJ6YtANQl3z/jSFetx7nck6JGFhbbNrU8iayl+7SxVVjFk+M4af1sc4NdWlzmRn9KkIZQUyzNZ7X16hKguG50cpKfDfHq3oCeEdwJsbpsrfd2ny4FClFZjncSV9BjUQuNDlc5lDblA+dPiJQcJAn4dktf57BMf5y63/wFNPD9ou7LThVXTG7IXKj7edjSYoGsEk/jUNf+Wun8rUvR1IiKIemA&prompt=Project%20Billing&frm=.\Service\frmProjectBilling.aspx&date1=10/1/2019&date2=10/15/2019&ribbon=RUnbilled:RGeneratePB&transtype=&moduleid=PRJBLNG&sp=&access=EV&parameters=&glpost=", "_self");
                            }
                        });
                    }


                }
            });



        }
    </script>
</head>
<body style="height: 107px; background-color:transparent"">
    <form id="form1" runat="server">
        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" ></asp:DropDownList>

        <asp:Panel ID="Panel1" runat="server" Height="557px">

        <%--    <dx:ASPxDashboardViewer ID="dbvMainViewer" runat="server" Height="100%" Width="98%" 
                OnDashboardLoaded="dbvMainViewer_DashboardLoaded"
                OnCustomParameters="dbvMainViewer_CustomParameters"
                OnConfigureDataConnection="dbvMainViewer_ConfigureDataConnection">
            </dx:ASPxDashboardViewer>--%>
        </asp:Panel>

    </form>

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
    <!-- notification JS
		============================================ -->
    <script src="js/Lobibox.js"></script>
    <script src="js/notification-active.js"></script>
    <!-- main JS
		============================================ -->
    <script src="js/main.js"></script>
</body>
</html>
