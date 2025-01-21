<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="fbNotes.aspx.cs" Inherits="GWL.FactBox.fbNotes" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
 .TFtable{
  width:245px; 
  border-collapse:collapse; 
 }
 .TFtable td{ 
  padding:5px; border:#4e95f4 1px solid;
 }
 /* provide some minimal visual accomodation for IE8 and below */
 .TFtable tr{
  background: #b8d1f3;
 }
 /*  Define the background color for all the ODD background rows  */
 .TFtable tr:nth-child(odd){ 
  background: #b8d1f3;
 }
 /*  Define the background color for all the EVEN background rows  */
 .TFtable tr:nth-child(even){
  background: #dae5f4;
 }

 #TableDiv{
  height: 265px;
  overflow-y: auto;
  overflow-x: hidden;
 }
</style>
<script>
    function hide(elements) {
        elements = elements.length ? elements : [elements];
        for (var index = 0; index < elements.length; index++) {
            elements[index].style.display = 'none';
        }
    }

    function show(elements, specifiedDisplay) {
        elements = elements.length ? elements : [elements];
        for (var index = 0; index < elements.length; index++) {
            elements[index].style.display = specifiedDisplay || 'block';
        }  
    }

    function tablescroll() {
        document.getElementById("TableDiv").style.overflowY = "auto";
        document.getElementById("TableDiv").style.overflowX = "hidden";
        document.getElementById("TableDiv").style.height = "150px";
    }
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <dx:ASPxCallbackPanel ID="callbackPanel" ClientInstanceName="cp" runat="server"
                    Width="170px" Height="200px" RenderMode="Table" OnCallback="callbackPanel_Callback">
            <ClientSideEvents EndCallback="function(){window.location.reload();}" />
                    <PanelCollection>
                        <dx:PanelContent runat="server">
                            <span id="create">
                                <dx:ASPxHyperLink runat="server" Text="Click here to create a new note" NavigateUrl="javascript:void(0)">
                                <ClientSideEvents Click="function(){show(document.getElementById('hiddenmes'));
                                                                    hide(document.getElementById('create'));
                                                                    tablescroll()}" />
                            </dx:ASPxHyperLink></span>
                            <div class="target" id="hiddenmes" style="display: none">
                                <dx:ASPxMemo ID="Memo" runat="server" Height="45px" Width="246px">
                                </dx:ASPxMemo>
                                <div style="height:5px"></div>
                                <dx:ASPxGridLookup runat="server" ID="ToUser" Width="190px" Caption="To:" CaptionCellStyle-Paddings-PaddingRight="40px"
                                DataSourceID="Users" AutoGenerateColumns="false" TextFormatString="{0}" KeyFieldName="UserId" GridViewProperties-Settings-ShowFilterRow="true"
                                    GridViewProperties-SettingsPager-PageSize="5" GridViewProperties-Settings-HorizontalScrollBarMode="Visible" GridViewProperties-Settings-VerticalScrollBarMode="Visible"
                                    GridViewProperties-SettingsPager-Mode="ShowAllRecords">
                                    <Columns>
                                        <dx:GridViewDataColumn FieldName="UserId" Width="50px">
                                            <Settings AutoFilterCondition="Contains" />
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn FieldName="UserName" Width="150px">
                                            <Settings AutoFilterCondition="Contains" />
                                        </dx:GridViewDataColumn>
                                    </Columns>
                                </dx:ASPxGridLookup>
                                <div style="height:5px"></div>
                                <dx:ASPxComboBox ID="Type" runat="server" ValueType="System.String" Caption="Alert" CaptionCellStyle-Paddings-PaddingRight="28px" Width="100px">
                                    <Items>
                                        <dx:ListEditItem Text="Don't Notify" Value="False" Selected="true"/>
                                        <dx:ListEditItem Text="Notify" Value="True"/>
                                        <dx:ListEditItem Text="Priority" Value="True"/>
                                    </Items>
                                </dx:ASPxComboBox>
                                <div style="padding-left:144px">
                                <div style="height:5px"></div>
                                <table border="0">
                                    <tr><td style="padding:0 1px 0 0px;">
                                        <dx:ASPxButton ID="Save" runat="server" Text="Save"  AutoPostBack="false" UseSubmitBehavior="false">
                                            <ClientSideEvents Click="function(){
                                                                    cp.PerformCallback();
                                                                    hide(document.getElementById('hiddenmes'));
                                                                    show(document.getElementById('create'));
                                                                    document.getElementById('TableDiv').style.height = '265px';
                                                                    }" />
                                        </dx:ASPxButton>     
                                        </td>
                                        <td>
                                        <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" AutoPostBack="false" UseSubmitBehavior="false">
                                            <ClientSideEvents Click="function(){hide(document.getElementById('hiddenmes'));
                                                                    show(document.getElementById('create'));
                                                                    document.getElementById('TableDiv').style.height = '265px';
                                                                    }" />
                                        </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                                </div>
                                </div>
                            <div style="height:5px"></div>
                            <div id="TableDiv">
                                        <asp:Literal ID="litText" runat="server" Text=""></asp:Literal>
                                </div>
                        </dx:PanelContent>
                    </PanelCollection>
        </dx:ASPxCallbackPanel>
    </div>
    </form>
    <asp:SqlDataSource ID="Users" SelectCommand="Select UserId,UserName from it.users" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>"></asp:SqlDataSource>
</body>
</html>
