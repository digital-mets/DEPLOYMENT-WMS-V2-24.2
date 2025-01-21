<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SSRSViewer.aspx.cs" Inherits="GWL.WebReports.SSRSViewer" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title></title>
</head>
<body>
    <form id="frmReportViewer" runat="server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Release" LoadScriptsBeforeUI="true" EnablePageMethods="true">
        </asp:ScriptManager>
        <rsweb:ReportViewer id="ReportViewer1" runat="server" Font-Names="Verdana" Font-Size="8pt" 
            ProcessingMode="Remote" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt"
            Width="100%" Height="100%" KeepSessionAlive="true" OnReportRefresh="ReportViewer1_ReportRefresh">
            <ServerReport ReportServerUrl="http://192.168.180.9/ReportServer"/>
        </rsweb:ReportViewer>

        <script type="text/javascript">
            ResizeReport();

            function ResizeReport() {
                var viewer = document.getElementById("<%= ReportViewer1.ClientID %>");
                var htmlheight = document.documentElement.clientHeight;
                viewer.style.height = (htmlheight - 50) + "px";
                PageMethods.SetViewerHeight(viewer.style.height);
            }

            window.onresize = function resize() { ResizeReport(); }
        </script>
    </div>
    </form>
</body>
</html>
