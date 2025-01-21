<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDashboardMLI.aspx.cs" Inherits="GWL.frmDashboardMLI" %>

<%@ Register assembly="DevExpress.Dashboard.v24.2.Web.WebForms, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.DashboardWeb" tagprefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml"  style="height:100%;width:100%">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title></title>
   
</head>
<body style="height:100%;width:100%">
    <form id="form1" runat="server"  style="height:100%;width:100%">

        <dx:ASPxDashboardViewer ID="ASPxDashboardViewer1" runat="server" Height="100%"   Width="100%" DashboardSource="~/IT/MLI DashBoard.xml" OnConfigureDataConnection="ASPxDashboardViewer1_ConfigureDataConnection" FullscreenMode="True">
        </dx:ASPxDashboardViewer>

    </form>
</body>
</html>
