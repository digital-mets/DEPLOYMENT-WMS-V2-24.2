<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ErrorPage.aspx.cs" Inherits="GWL.ErrorPage" %>
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, user-scalable=no, maximum-scale=1.0, minimum-scale=1.0" />
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat ="server">
       <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <script>

        function Close()
        {
            window.close();
        }

    </script>
    <title></title>
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height:500px;
            width:100%;/*Change this whenever needed*/
    
            text-align: left;
        }

         .Entry {
         padding: 20px;
         margin: 10px auto;
         /*background: #FF0099;*/
         }

        .pnl-content
        {
            text-align: right;
        }
   
        .auto-style1 {
            text-align: left;
        }
   
    </style>
</head>
<body id="Mybody" runat="server" style="background-color:#2A80B9; text-align: center;" >
    <form id="form1" runat="server">
    <%--    <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Error" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>--%>

    <%--<h2>Error:</h2>--%>
    
       

<%--    <<%--dx:ASPxFor<%--mLayout ID="form1_layout" runat="server" Height="269px" Width="1052px" style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />--%>
                        
<%--        <Items>


                            <dx:TabbedLayoutGroup>
                                <Items>

                                    <dx:LayoutGroup Caption="FriendlyErrorMsg" >
                                        <Items>
                                            <asp:Label ID="FriendlyErrorMsg" runat="server" Text="Label" Font-Size="Large" style="color: red">
                                            </asp:Label>
                                           
                                             </Items>
                                        </dx:LayoutGroup>
                                    
                                    <dx:LayoutGroup Caption="Detailed Error" >
                                        <Items>
                                            <asp:Label ID="ErrorDetailedMsg" runat="server" Text="Label1" Font-Size="Small" >
                                            <%--<br />--%>
        <%--                                   </asp:Label>
                                             </Items>
                                        </dx:LayoutGroup>
                                         <dx:LayoutGroup Caption="Error Handler:">
                                        <Items>
                                            <asp:Label ID="ErrorHandler" runat="server" Text="Label1" Font-Size="Small" >
                                            <%--<br />--%>
                                            <%--<br />--%>
                      <%--                     </asp:Label>
                                             </Items>
                                        </dx:LayoutGroup>
                                         <dx:LayoutGroup Caption="Detailed Error Message:" >
                                        <Items>
                                           <asp:Label ID="InnerMessage" runat="server" Text="Label1" Font-Size="Small" >
                                            <%--<br />--%>
        <%--                                   <asp:Label ID="InnerTrace" runat="server"  />
                                               </asp:Label>
                                             </Items>
                                             
                                        </dx:LayoutGroup>
                                    </Items>
                                </dx:TabbedLayoutGroup>
                            </Items>

      
        </dx:ASPxFormLayout>--%>

    <p></p>

    <asp:Panel ID="DetailedErrorPanel" runat="server" Visible="false" style="margin-left: 350px; margin-top:100px" Font-Names="Segoe UI" ForeColor="White" Width="600px">
          <p class="auto-style1">
            <asp:Label ID="Title" runat="server" Font-Size="70px"  style="color: white; text-align: center;" Text="Label" Font-Names="Segoe UI Semibold" ForeColor="White" ></asp:Label>
        </p>
        <p class="auto-style1">
            <asp:Label ID="FriendlyErrorMsg" runat="server" Font-Size="X-Large" style="color: white;  text-align: center;" Text="Label" Font-Names="Segoe UI Semibold" ForeColor="White" ></asp:Label>
        </p>
        <%--<h4 aria-hidden="False" class="auto-style1">Error Message:</h4>--%>
        <p class="auto-style1">
            <asp:Label ID="ErrorDetailedMsg" runat="server" Font-Size="Medium" /><br />
        </p>

        <%--<h4 class="auto-style1">Recommendation:</h4>--%>
        <p class="auto-style1">
            <asp:Label ID="ErrorHandler" runat="server" Font-Size="Medium" /><br />
        </p>

          <p class="auto-style1">
              <asp:Button ID="Button1" runat="server" Font-Names="Segoe UI" Height="30px" Text="Go to Home Page" Width="120px" 
                  
                   OnClientClick="Close()" />
         
               </p>

        <%--<h4 class="auto-style1">Technical Message:</h4>--%>
<%--        <p class="auto-style1">
            <asp:Label ID="InnerMessage" runat="server" Font-Size="Medium" /><br />
        </p>
        <p class="auto-style1">
            <asp:Label ID="InnerTrace" runat="server"  />
        </p>--%>
    </asp:Panel>


    </form>


</body>
    </html>