<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmPallet.aspx.cs" Inherits="GWL.frmPallet" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title></title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
#form1 {
height: 350px; /*Change this whenever needed*/
}

 .Entry {
 padding: 20px;
 margin: 10px auto;
 background: #FFF;
 }
        .pnl-content
        {
            text-align: right;
        }
   
    </style>
     <script>
         var isValid = true;
         var counterror = 0;

         function getParameterByName(name) {
             name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
             var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                 results = regex.exec(Pallet.search);
             return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
         }

         var module = getParameterByName("transtype");
         var id = getParameterByName("PalletID");
         var entry = getParameterByName("entry");

         $(document).ready(function () {
             PerfStart(module, entry, id);
         });

         function OnValidation(s, e) { //Validation function for header controls (Set this for each header controls)
             if (s.GetText() == "" || e.value == "" || e.value == null) {
                 counterror++;
                 isValid = false
             }
             else {
                 isValid = true;
             }
         }

         function OnUpdateClick(s, e) { //Add/Edit/Close button function
             var btnmode = btn.GetText(); //gets text of button
             if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
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
                 counterror = 0;
                 alert('Please check all the fields!');
             }

             if (btnmode == "Delete") {
                 cp.PerformCallback("Delete");
             }
         }

         function OnConfirm(s, e) {//function upon saving entry
             if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                 e.cancel = true;
         }

         function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
             if (s.cp_success) {

                 alert(s.cp_message);

                 delete (s.cp_success);//deletes cache variables' data
                 delete (s.cp_message);
             }

             if (s.cp_close) {
                 if (s.cp_message != null) {
                     alert(s.cp_message);
                     delete (s.cp_message);
                 }
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
                 delete (cp_delete);
                 DeleteControl.Show();
             }
         }

         var itemc; //variable required for lookup
         var currentColumn = null;
         var isSetTextRequired = false;
         var linecount = 1;


         function lookup(s, e) {
             if (isSetTextRequired) {//Sets the text during lookup for item code
                 s.SetText(s.GetInputElement().value);
                 isSetTextRequired = false;
             }
         }

         //var preventEndEditOnLostFocus = false;
         function gridLookup_KeyDown(s, e) { //Allows tabbing between gridlookup on details
             isSetTextRequired = false;
             var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
             if (keyCode !== ASPxKey.Tab) return;
             var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
             if (gv1.batchEditApi[moveActionName]()) {
                 ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
             }
         }

         function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
             var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
             if (keyCode == ASPxKey.Enter)
                 gv1.batchEditApi.EndEdit();
             //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
         }

         function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
             gv1.batchEditApi.EndEdit();
         }

         //validation
         function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
             for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                 var column = s.GetColumn(i);
                 if (column != s.GetColumn(6) && column != s.GetColumn(1) && column != s.GetColumn(7) && column != s.GetColumn(5) && column != s.GetColumn(8) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23) && column != s.GetColumn(24) && column != s.GetColumn(13)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                     var cellValidationInfo = e.validationInfo[column.index];
                     if (!cellValidationInfo) continue;
                     var value = cellValidationInfo.value;
                     if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                         cellValidationInfo.isValid = false;
                         cellValidationInfo.errorText = column.fieldName + " is required";
                         isValid = false;
                     }
                     else {
                         isValid = true;
                     }
                 }
             }
         }
         function OnInitTrans(s, e) {
             AdjustSize();
         }

         function OnControlsInitialized(s, e) {
             ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                 AdjustSize();
             });
         }

         function AdjustSize() {
             var width = Math.max(0, document.documentElement.clientWidth);
             gv1.SetWidth(width - 120);
         }

    </script>
</head>
<body style="height: 910px">
        <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
            <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Pallet" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
    
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="1050px" Height="338px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="form1_layout" runat="server" Height="269px" Width="850px" style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                           <dx:LayoutItem Caption="PalletID">
                               <LayoutItemNestedControlCollection>
                                   <dx:LayoutItemNestedControlContainer runat="server">
                                       <dx:ASPxTextBox ID="txtPallet" runat="server" Width="170px" ReadOnly="true">
                                          <ClientSideEvents Validation="OnValidation" />
                                           <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                               <RequiredField IsRequired="True" />
                                           </ValidationSettings>
                                           <InvalidStyle BackColor="Pink">
                                           </InvalidStyle>
                                       </dx:ASPxTextBox>
                                   </dx:LayoutItemNestedControlContainer>
                               </LayoutItemNestedControlCollection>
                           </dx:LayoutItem>
                            <dx:LayoutItem Caption="Area Code">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxGridLookup ID="CustomerCode" runat="server" Width="170px" OnLoad="LookupLoad" ClientInstanceName="AreaCode" DataSourceID="AreaCode" KeyFieldName="CustomerCode" TextFormatString="{0}" >
                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e) {cp.PerformCallback('SUP');}"/>
                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                <RequiredField IsRequired="True" />
                                            </ValidationSettings>
                                            <InvalidStyle BackColor="Pink">
                                            </InvalidStyle>
                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                <Settings ShowFilterRow="True"></Settings>
                                            </GridViewProperties>
                                        </dx:ASPxGridLookup>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Case Tier">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxSpinEdit ID="txtCaseTier" runat="server" OnLoad="SpinEdit_Load" Number="0" Width="170px">
                                        <SpinButtons ShowIncrementButtons="false" />
                                        </dx:ASPxSpinEdit>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Tier Pallet">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxSpinEdit ID="txtTierPallet" runat="server" OnLoad="SpinEdit_Load" Number="0" Width="170px">
                                        <SpinButtons ShowIncrementButtons="false" />
                                        </dx:ASPxSpinEdit>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Packaging">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxGridLookup ID="txtPackaging" runat="server" Width="170px" DataSourceID="Packaging" Onload="LookupLoad" KeyFieldName="Packaging">
                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                <Settings ShowFilterRow="True"></Settings>
                                            </GridViewProperties>
                                        </dx:ASPxGridLookup>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Width">
                               <LayoutItemNestedControlCollection>
                                   <dx:LayoutItemNestedControlContainer runat="server">
                                       <dx:ASPxSpinEdit ID="txtWidth" runat="server" OnLoad="SpinEdit_Load" Number="0" Width="170px">
                                       <SpinButtons ShowIncrementButtons="false" />
                                       </dx:ASPxSpinEdit>
                                   </dx:LayoutItemNestedControlContainer>
                               </LayoutItemNestedControlCollection>
                           </dx:LayoutItem>
                           <dx:LayoutItem Caption="Length">
                               <LayoutItemNestedControlCollection>
                                   <dx:LayoutItemNestedControlContainer runat="server">
                                       <dx:ASPxSpinEdit ID="txtLength" runat="server" OnLoad="SpinEdit_Load" Number="0" Width="170px">
                                       <SpinButtons ShowIncrementButtons="false" />
                                       </dx:ASPxSpinEdit>
                                   </dx:LayoutItemNestedControlContainer>
                               </LayoutItemNestedControlCollection>
                           </dx:LayoutItem>
                           <dx:LayoutItem Caption="Height">
                               <LayoutItemNestedControlCollection>
                                   <dx:LayoutItemNestedControlContainer runat="server">
                                       <dx:ASPxSpinEdit ID="txtHeight" runat="server" OnLoad="SpinEdit_Load" Number="0" Width="170px">
                                       <SpinButtons ShowIncrementButtons="false" />
                                       </dx:ASPxSpinEdit>
                                   </dx:LayoutItemNestedControlContainer>
                               </LayoutItemNestedControlCollection>
                           </dx:LayoutItem>
                           <dx:LayoutItem Caption="Unit Weight">
                               <LayoutItemNestedControlCollection>
                                   <dx:LayoutItemNestedControlContainer runat="server">
                                       <dx:ASPxSpinEdit ID="txtUnitWeight" runat="server" OnLoad="SpinEdit_Load" Number="0" Width="170px">
                                       <SpinButtons ShowIncrementButtons="false" />
                                       </dx:ASPxSpinEdit>
                                   </dx:LayoutItemNestedControlContainer>
                               </LayoutItemNestedControlCollection>
                           </dx:LayoutItem>
                           <dx:LayoutItem Caption="Pallet Type">
                              <LayoutItemNestedControlCollection>
                                  <dx:LayoutItemNestedControlContainer runat="server">
                                      <dx:ASPxTextBox ID="txtPalletType" runat="server" AutoCompleteType="Disabled"  Width="170px" OnLoad="TextboxLoad">
                                         <ClientSideEvents Validation="OnValidation" />
                                          <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                              <RequiredField IsRequired="True" />
                                          </ValidationSettings>
                                          <InvalidStyle BackColor="Pink">
                                          </InvalidStyle>
                                      </dx:ASPxTextBox>
                                  </dx:LayoutItemNestedControlContainer>
                              </LayoutItemNestedControlCollection>
                          </dx:LayoutItem>
                        </Items>
                    </dx:ASPxFormLayout>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>

<dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                                <dx:ASPxButton ID="updateBtn" runat="server" Text="Add" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
                                    UseSubmitBehavior="false" CausesValidation="true">
                                    <ClientSideEvents Click="OnUpdateClick" />
                                </dx:ASPxButton>
                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
        
        
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
                         <td><dx:ASPxButton ID="Ok" runat="server" Text="Ok" AutoPostBack="False" UseSubmitBehavior="false">
                             <ClientSideEvents Click="function (s, e){  cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                             </dx:ASPxButton>
                         <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel">
                             <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                             </dx:ASPxButton> 
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

      <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.Pallet" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.Pallet" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="" Name="DocNumber" SessionField="DocNumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.Location+TransactionDetail" SelectMethod="getdetail" UpdateMethod="UpdateTransactionDetail" TypeName="Entity.Transaction+TransactionDetail" DeleteMethod="DeleteTransactionDetail" InsertMethod="AddTransactionDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
             <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:SqlDataSource ID="AreaCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT CustomerCode,StorageType FROM PORTAL.IT.PalletInfo"
         OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="Customer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT CustomerCode, StorageType FROM PORTAL.it.PalletInfo where DocNumber is not null"
         OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="Packaging" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT 'Box' AS Packaging UNION ALL SELECT 'Pack' AS Packaging UNION ALL SELECT 'Carcass etc' AS Packaging"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

<%--    <asp:SqlDataSource ID="PalletID" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT CustomerCode,StorageType FROM PORTAL.IT.PalletInfo"
         OnInit = "Connection_Init">
    </asp:SqlDataSource>--%>

    </form>
</body>
</html>
