<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmCheckRelease.aspx.cs" Inherits="GWL.frmCheckRelease" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <title>Release Checks</title>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 800px; /*Change this whenever needed*/
        }

        .Entry {
            /*width: 1280px;*/ /*Change this whenever needed*/
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
            /*border-radius: 10px;
            -webkit-border-radius: 10px;
            -moz-border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
            -moz-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
            -webkit-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);*/
        }

        /*.dxeButtonEditSys input,
        .dxeTextBoxSys input{
            text-transform:uppercase;
        }*/

        .uppercase .dxeEditAreaSys
        {
            text-transform: uppercase;
        }

        .pnl-content
        {
            text-align: right;
        }
    </style>
    <!--#endregion-->
    <script>
        var isValid = true;
        var entry = getParameterByName('entry');

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

               function getParameterByName(name) {
           name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
           var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
               results = regex.exec(location.search);
           return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
       }

var module = getParameterByName("transtype");
        var id = getParameterByName("docnumber");
        var entry = getParameterByName("entry");

        $(document).ready(function () {
            PerfStart(module, entry, id);
        });

function OnValidation(s, e) { //Validation function for header controls (Set this for each header controls)
            if ((s.GetText() == "" || e.value == "" || e.value == null)) {
                isValid = false;
            }
        }

        function OnUpdateClick(s, e) { //Add/Edit/Close button function

            var btnmode = btn.GetText(); //gets text of button

            if (isValid || btnmode == "Close") { //check if there's no error then proceed to callback
                //Sends request to server side
                if (btnmode == "Add") {
                    cp.PerformCallback("Add");
                }
                else if (btnmode == "Update") {
                    cp.PerformCallback("Update");
                }
                else if (btnmode == "Close") {
                    cp.PerformCallback("Close");
                }
            }
            else {
                isValid = true;
                alert('Please check all the fields!');
            }

            if (btnmode == "Release") {
                cp.PerformCallback("Release");
            }
        }

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        function OnEndCallback(s, e) {//End callback function if (s.cp_success) {
            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);
            }
            else if (s.cp_message != null) {
                alert(s.cp_message);
                delete (s.cp_message);
            }
            if (s.cp_close) {
                if (s.cp_valmsg != null) {
                    alert(s.cp_valmsg);
                    delete (s.cp_valmsg);
                }
                if (glcheck.GetChecked()) {
                    delete (cp_close);
                    window.location.reload();
                }
                else {
                    delete (cp_close);
                    window.close();//close window if callback successful
                }
            }
            if (s.cp_delete) {
                delete (s.cp_delete);
                DeleteControl.Show();
            }
        }
    </script>
    <!--#endregion-->
</head>

<body style="height: 565px">
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel ID="FormTitle" runat="server" Text="Release Checks" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="850px" Height="565px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="OnEndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="_FormLayout" runat="server" Height="565px" Width="850px" style="margin-left: -3px" ClientInstanceName="frmlayout">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                          <%--<!--#region Region Header --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Voucher No.">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocNumber" runat="server" ClientEnabled="false"
                                                                        Width="170px" CssClass="uppercase" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Release Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dteReleaseDate" runat="server" OnLoad="Date_Load" Width="170px" HorizontalAlign="Center">
                                                            <ClientSideEvents Validation="
                                                                function(s,e) 
                                                                {
                                                                    if (e.value == '' || e.value == null)
                                                                    {
                                                                        isValid = false;
                                                                    }
                                                                    else if (e.value < dteDocDate.GetValue())
                                                                    {
                                                                        e.isValid = false;
                                                                        isValid = false;
                                                                        e.errorText = 'Release date cannot be earlier that CV date'
                                                                    }
                                                                }"
                                                            />
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" ErrorText="Please specify a valid release date"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink" />
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Supplier Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSupplierCode" runat="server" ClientEnabled="false"
                                                                        Width="170px" CssClass="uppercase" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                           
                                            <dx:LayoutItem Caption="OR Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtORNumber" runat="server" OnLoad="Textbox_Load" Width="170px">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" ErrorText="OR number must not be blank"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Supplier Name">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSupplierName" runat="server" ClientEnabled="false"
                                                                        Width="250px" CssClass="uppercase" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                           
                                            <dx:LayoutItem Caption="OR Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dteORDate" runat="server" OnLoad="Date_Load" Width="170px" HorizontalAlign="Center">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" ErrorText="Please specify an OR date"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink" />
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Remarks" Width="700px" ColSpan="2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxMemo ID="txtRemarks" runat="server" OnLoad="Memo_Load" Width="450px" Height="100px" />
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:EmptyLayoutItem Height="0">
                                            </dx:EmptyLayoutItem>

                                            <dx:LayoutItem Caption="Doc Date" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dteDocDate" runat="server" ClientInstanceName="dteDocDate" ClientVisible="false">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="" Width="500px" ColSpan="2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView runat="server" AutoGenerateColumns="False" Width="600px" 
                                                            KeyFieldName="DocNumber;LineNumber" DataSourceID="sdsCheckDetail">
                                                            <Settings HorizontalScrollBarMode="Auto" VerticalScrollBarMode="Auto" ColumnMinWidth="50" VerticalScrollableHeight="200" /> 
                                                            <SettingsPager Mode="ShowAllRecords" />
                                                            <SettingsBehavior AllowSort="false" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="Bank" VisibleIndex="1" Width="60px" ReadOnly="true" />
                                                                <dx:GridViewDataTextColumn FieldName="Branch" VisibleIndex="2" Width="120px" ReadOnly="true" />
                                                                <dx:GridViewDataTextColumn FieldName="CheckNumber" VisibleIndex="3" Width="120px" ReadOnly="true" />
                                                                <dx:GridViewDataDateColumn FieldName="CheckDate" VisibleIndex="5" Width="100px" ReadOnly="true" />
                                                                <dx:GridViewDataTextColumn FieldName="CheckAmount" VisibleIndex="6" Width="120px" ReadOnly="true">
                                                                    <CellStyle HorizontalAlign="Right" />
                                                                    <PropertiesTextEdit DisplayFormatString="#,0.00" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                </Items>
                           </dx:TabbedLayoutGroup>
                           <%-- <!--#endregion --> --%>
                        </Items>
                    </dx:ASPxFormLayout>
                    <dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                                <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
                                    UseSubmitBehavior="false" CausesValidation="true">
                                    <ClientSideEvents Click="OnUpdateClick" />
                                </dx:ASPxButton>
                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
        <dx:ASPxPopupControl ID="DeleteControl" runat="server" Width="250px" Height="100px" HeaderText="Warning!"
            CloseAction="CloseButton" CloseOnEscape="True" Modal="True" ClientInstanceName="DeleteControl"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Are you sure you want to delete this specific document?" />
                    <table>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                           <td><dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                             <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                             </dx:ASPxButton></td>
                         <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                             <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                             </dx:ASPxButton> </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
    </form>

    <!--#region Region Datasource-->
    <%-- put all datasource codeblock here --%>
    <asp:SqlDataSource ID="sdsCheckDetail" runat="server" 
        SelectCommand="SELECT DocNumber, LineNumber, Bank, Branch, CheckNumber, CheckDate, CheckAmount FROM Accounting.CheckVoucherDetail WHERE DocNumber=@DocNumber" 
        OnInit="Connection_Init">
        <SelectParameters>
            <asp:Parameter Name="DocNumber" Type="String" DefaultValue="???"/>
        </SelectParameters>
    </asp:SqlDataSource>

    <!--#endregion-->
</body>
</html>


