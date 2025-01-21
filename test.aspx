<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="test.aspx.cs" Inherits="GWL.test" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title></title>
    <script>
        function cp_endcallback(s,e) {
            //s.cp_connection
            //window.open("./debugRepViewer.aspx?val=~" + s.cp_report + '&transtype=' + s.cp_transtype + '&docnumber='+ '' +'&connection=' + s.cp_connection, '_blank');
            console.log(s.cp_result);
            delete (s.cp_result);
            setTimeout(function () {
                cp.PerformCallback(cbox.GetText());
            }, 500);
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="200px" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="cp_endcallback" />
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxLabel runat="server" Text ="Connection"></dx:ASPxLabel>
                    <dx:ASPxComboBox ClientInstanceName="cbox" ID="connection" runat="server" ValueType="System.String" OnLoad="connection_Load"></dx:ASPxComboBox>
                    <dx:ASPxButton ID="submit" runat="server" Text="Submit" UseSubmitBehavior="false" AutoPostBack="false">
                        <ClientSideEvents Click="function(){cp.PerformCallback(cbox.GetText());}" />
                    </dx:ASPxButton>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </div>
    </form>
</body>
</html>
