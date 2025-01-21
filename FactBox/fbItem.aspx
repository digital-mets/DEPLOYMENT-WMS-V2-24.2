<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="fbItem.aspx.cs" Inherits="GWL.FactBox.fbItem" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
<title></title>
    <script type="text/javascript">
        var keyValue;
        function OnMoreInfoClick(element, key) {

            cp.SetContentHtml("");
            //popup.ShowAtElement(element);

            //if(PopStateEvent==true)
            keyValue = key;
            cp.PerformCallback(keyValue);
            //popup.ShowAtPos(578, 8);
        }
        function popup_Shown(s, e) {

        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
<%--    <dx:ASPxPopupControl ID="popup" ClientInstanceName="popup" runat="server" AllowDragging="True" 
         CloseOnEscape="false" ShowCloseButton="false" CloseAction="None" ShowOnPageLoad="True"
         ShowCollapseButton="true" ShowPinButton="true" HeaderText="BizPartner info" ShowShadow="False" Pinned="true"
         Width="200px" Height="100px">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">--%>
                <dx:ASPxCallbackPanel ID="callbackPanel" ClientInstanceName="cp" runat="server"
                    Width="170px" Height="200px" OnCallback="callbackPanel_Callback" RenderMode="Table">
                    <PanelCollection>
                        <dx:PanelContent runat="server">
                            <table class="InfoTable">
                                <tr>
                                    <td>
                                        <asp:Literal ID="litText" runat="server" Text=""></asp:Literal>
                                    </td>
                                </tr>
                            </table>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
<%--            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents/>
    </dx:ASPxPopupControl>--%>

    </div>
    </form>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>"></asp:SqlDataSource>
</body>
</html>
