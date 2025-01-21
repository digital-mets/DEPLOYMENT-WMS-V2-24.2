<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="error.aspx.cs" Inherits="GWL.error" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <dx:ASPxPopupControl ID="Success" ShowOnPageLoad="true" ContentStyle-HorizontalAlign="Center" runat="server" ShowHeader="False" ClientInstanceName="pop2" CloseAction="None" Theme="iOS" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
                        <ClientSideEvents PopUp="function(s, e) {
                        setTimeout(function(){
                            window.close();
                            } , 2000); 
                        }" />

<ContentStyle HorizontalAlign="Center"></ContentStyle>
                   <ContentCollection>
                     <dx:PopupControlContentControl runat="server">
                        <dx:ASPxLabel ID="ASPxLabel2" runat="server" ForeColor="Red" Text="You are not authorized to access this page!" ClientInstanceName="label2"></dx:ASPxLabel>
                         <br />
                        <dx:ASPxLabel ID="ASPxLabel1" runat="server" ForeColor="Green" Text="You will be redirected back in a bit..." ClientInstanceName="label1"></dx:ASPxLabel>
                     </dx:PopupControlContentControl>
                 </ContentCollection>
                    </dx:ASPxPopupControl>
    </div>
    </form>
</body>
</html>
