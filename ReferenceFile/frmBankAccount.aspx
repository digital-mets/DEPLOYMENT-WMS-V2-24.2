<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmBankAccount.aspx.cs" Inherits="GWL.frmBankAccount" %>

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
height: 250px; /*Change this whenever needed*/
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
    <!--#endregion-->
    
    <!--#region Region Javascript-->
   <!--#region Region Javascript-->
 <script>
     var isValid = true;
     var counterror = 0;

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
     function OnCustomClick(s, e) {
         //if (e.buttonID == "Details") {
         //    var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
         //    var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
         //    var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
         //    var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
         //    factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
         //    + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode);
         //}
     }
     //var preventEndEditOnLostFocus = false;
     //function gridLookup_KeyDown(s, e) { //Allows tabbing between gridlookup on details
     //    isSetTextRequired = false;
     //    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
     //    if (keyCode !== ASPxKey.Tab) return;
     //    var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
     //    if (gv1.batchEditApi[moveActionName]()) {
     //        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
     //    }
     //}

     //function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
     //    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
     //    if (keyCode == ASPxKey.Enter)
     //        gv1.batchEditApi.EndEdit();
     //    //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
     //}

     //function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
     //    gv1.batchEditApi.EndEdit();
     //}

     //validation
     function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
         //for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
         //    var column = s.GetColumn(i);
         //    if (column != s.GetColumn(6) && column != s.GetColumn(1) && column != s.GetColumn(7) && column != s.GetColumn(5) && column != s.GetColumn(8) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23) && column != s.GetColumn(24) && column != s.GetColumn(13)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
         //        var cellValidationInfo = e.validationInfo[column.index];
         //        if (!cellValidationInfo) continue;
         //        var value = cellValidationInfo.value;
         //        if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
         //            cellValidationInfo.isValid = false;
         //            cellValidationInfo.errorText = column.fieldName + " is required";
         //            isValid = false;
         //        }
         //        else {
         //            isValid = true;
         //        }
         //    }
         //}
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
         //gv1.SetWidth(width - 120);
     }
     function autocalculate(s, e) {
         OnInitTrans();
        
         var rate = 0;
         var num1 = 0;
         var num2 = 0;

         if (oh.GetText() == null || oh.GetText() == "") {
             num1 = 0;
         }
         else {
             num1 = oh.GetText();
         }

         if (qtyalloc.GetText() == null || qtyalloc.GetText() == "") {
             num2 = 0;
         }
         else {
             if (qtyalloc.GetText() != null) {
                 num2 = qtyalloc.GetText();
                 rate = num1 / num2;
                 ohrate.SetText(rate);
             }
             
         }
         
         
     }
    </script>
    
    <!--#endregion-->
</head>
<body style="height: 910px">
        <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
<form id="form1" runat="server" class="Entry">
    <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Bank Account" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
    
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="1050px" Height="338px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="form1_layout" runat="server" Height="184px" Width="850px" style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>


                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" >
                                        <Items>
                                            <dx:LayoutGroup Caption="Information" ColCount="2">
                                                <Items>
                                            <dx:LayoutItem Caption="Bank Account Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtbankaccountcode" runat="server"  Width="170px" OnLoad="TextboxLoad">
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

                                                      <dx:LayoutItem Caption="Account Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtaccountnumber" runat="server"  Width="170px" OnLoad="TextboxLoad">
                                                      
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:LayoutItem Caption="Bank Code">
                                                <LayoutItemNestedControlCollection> <%--here jay--%>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glBankCode" runat="server" AutoGenerateColumns="False" Width="170px" DataSourceID="dsBankCode" OnLoad="LookupLoad" TextFormatString="{0}" KeyFieldName="BankCode">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="BankCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                                     <dx:LayoutItem Caption="Account Name">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtaccountname" runat="server"  Width="170px" OnLoad="TextboxLoad">
                                                        
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                                        
                                          <dx:LayoutItem Caption="Branch">
                                                <LayoutItemNestedControlCollection> <%--here jay--%>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glBranch" runat="server" AutoGenerateColumns="False" Width="170px" DataSourceID="dsBranch" OnLoad="LookupLoad" TextFormatString="{0}" KeyFieldName="Code">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Type">
                                                <LayoutItemNestedControlCollection> <%--here jay--%>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gltype" runat="server" AutoGenerateColumns="False" Width="170px" DataSourceID="dsType" OnLoad="LookupLoad" TextFormatString="{0}" KeyFieldName="Code">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                                     
                                            <dx:LayoutItem Caption="Description">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtdescription" runat="server"  Width="170px" OnLoad="TextboxLoad">
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


                                                    <dx:LayoutItem Caption="GL Code">
                                                <LayoutItemNestedControlCollection> <%--here jay--%>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glglcode" runat="server" AutoGenerateColumns="False" Width="170px" DataSourceID="dsglcode" OnLoad="LookupLoad" TextFormatString="{0}" KeyFieldName="AccountCode">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                                     <dx:LayoutItem Caption="Signatory1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSignatory1" runat="server"  Width="170px" OnLoad="TextboxLoad">
                                                       
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                                     <dx:LayoutItem Caption="Date Open">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpdateopen" runat="server"  Width="170px" >
                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                                     <dx:LayoutItem Caption="Signatory2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSignatory2" runat="server"  Width="170px" OnLoad="TextboxLoad">
                                                     
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Maintaining Balance">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtMbalance" runat="server" ClientInstanceName="mbal" MaxValue="999999999" Number="0.0" OnLoad="SpinEdit_Load" Width="170px">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                                     <dx:LayoutItem Caption="Signatory3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSignatory3" runat="server"  Width="170px" OnLoad="TextboxLoad">
                                                       </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                                    <dx:LayoutItem Caption="Last Recon Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtprecondate" runat="server"  Width="170px" ReadOnly="false">
                                                         
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                                     <dx:LayoutItem Caption="Signatory4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSignatory4" runat="server"  Width="170px" OnLoad="TextboxLoad">
                                                          </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                                     <dx:LayoutItem Caption="Balance">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">

                                                        <dx:ASPxSpinEdit ID="txtbalance" runat="server" ClientInstanceName="bal" MaxValue="999999999" Number="0.00"  Width="170px" ReadOnly="true">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                        
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                                 <dx:LayoutItem Caption="Starting Cheque Series">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="startseries" runat="server" ClientInstanceName="start" Number="0" OnLoad="SpinEdit_Load" Width="170px" DecimalPlaces="0"
                                                            AllowMouseWheel ="false" MaxLength="15">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>                                                            
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                                     <dx:LayoutItem Caption="Next Cheque Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="nextcheck" runat="server"  Width="170px" OnLoad="TextboxLoad">
                                                         </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                                <dx:LayoutItem Caption="Ending Cheque Series">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="endseries" runat="server" ClientInstanceName="end" Number="0" OnLoad="SpinEdit_Load" Width="170px" DecimalPlaces="0"
                                                            AllowMouseWheel ="false" MaxLength="15">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="IsInactive">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkIsInactive" runat="server" CheckState="Unchecked" OnLoad="CheckboxLoad" Text="  ">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                            

                                            <%--jay--%>
                                    
                                  </Items>

                            </dx:LayoutGroup>

                                    <dx:LayoutGroup Caption="Cheque Information" ColCount="3">
                                        <Items>
                                            <dx:LayoutItem Caption="Date:" Name="txtHField1" >
                                                <LayoutItemNestedControlCollection>
<dx:LayoutItemNestedControlContainer runat="server"></dx:LayoutItemNestedControlContainer>
</LayoutItemNestedControlCollection>
                                             </dx:LayoutItem>
                                           <%-- <dx:LayoutItem Caption="X:" Name="txtDateX" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDateX" runat="server"  ReadOnly="False" Width="75px" Text="0" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>


                                                <dx:LayoutItem Caption="X:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="sptxtDateX" runat="server" MaxValue="999999999" Number="0.0" OnLoad="SpinEdit_Load" Width="75px">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="False" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



                                         <%--   <dx:LayoutItem Caption="Y:" Name="txtDateY">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDateY" runat="server"   ReadOnly="False"  Width="75px" Text="0">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>



                                                   <dx:LayoutItem Caption="Y:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="sptxtDateY" runat="server" MaxValue="999999999" Number="0.0" OnLoad="SpinEdit_Load" Width="75px">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="False" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                           <dx:LayoutItem Caption="Amount in Words:" Name="lblamtwrds" >
                                               <LayoutItemNestedControlCollection>
<dx:LayoutItemNestedControlContainer runat="server"></dx:LayoutItemNestedControlContainer>
</LayoutItemNestedControlCollection>
                                             </dx:LayoutItem>
                                           <%--  <dx:LayoutItem Caption="X:" Name="txtAmtX">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAmtX" runat="server"  ReadOnly="False"  Width="75px" Text="0">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>

                                                     <dx:LayoutItem Caption="X:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="sptxtAmtX" runat="server" MaxValue="999999999" Number="0.0" OnLoad="SpinEdit_Load" Width="75px">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="False" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>




                                          <%--  <dx:LayoutItem Caption="Y:" Name="txtAmtY">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAmtY" runat="server"  ReadOnly="False"  Width="75px" Text="0">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                             <dx:LayoutItem Caption="Y:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="sptxtAmtY" runat="server" MaxValue="999999999" Number="0.0" OnLoad="SpinEdit_Load" Width="75px">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="False" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            


                                            <dx:LayoutItem Caption="Payee:" Name="lblPayee" >
                                                <LayoutItemNestedControlCollection>
<dx:LayoutItemNestedControlContainer runat="server"></dx:LayoutItemNestedControlContainer>
</LayoutItemNestedControlCollection>
                                             </dx:LayoutItem>
                                          <%--  <dx:LayoutItem Caption="X:" Name="txtPayeeX">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPayeeX" runat="server"   ReadOnly="False"  Width="75px" Text="0">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                               <dx:LayoutItem Caption="X:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="sptxtPayeeX" runat="server" MaxValue="999999999" Number="0.0" OnLoad="SpinEdit_Load" Width="75px">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="False" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                         <%--   <dx:LayoutItem Caption="Y:" Name="txtPayeeY">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPayeeY" runat="server"   ReadOnly="False"  Width="75px" Text="0">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>


                                                  <dx:LayoutItem Caption="Y:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="sptxtPayeeY" runat="server" MaxValue="999999999" Number="0.0" OnLoad="SpinEdit_Load" Width="75px">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="False" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                          

                                            <dx:LayoutItem Caption="Remarks:" Name="lblremarks" >
                                                <LayoutItemNestedControlCollection>
<dx:LayoutItemNestedControlContainer runat="server"></dx:LayoutItemNestedControlContainer>
</LayoutItemNestedControlCollection>
                                             </dx:LayoutItem>
                                           <%-- <dx:LayoutItem Caption="X:" Name="txtRemarksX" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRemarksX" runat="server" ReadOnly="False" Width="75px" Text="0">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>

                                            
                                                  <dx:LayoutItem Caption="X:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="sptxtRemarksX" runat="server" MaxValue="999999999" Number="0.0" OnLoad="SpinEdit_Load" Width="75px">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="False" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>




                                         <%--   <dx:LayoutItem Caption="Y:" Name="txtRemarksY">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRemarksY" runat="server"   ReadOnly="False" Width="75px" Text="0">
                                                        </dx:ASPxTextBox>



                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                             <dx:LayoutItem Caption="Y:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="sptxtRemarksY" runat="server" MaxValue="999999999" Number="0.0" OnLoad="SpinEdit_Load" Width="75px">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="False"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                               <dx:LayoutItem Caption="Amount in Numbers:" Name="lblamtno" >
                                                   <LayoutItemNestedControlCollection>
<dx:LayoutItemNestedControlContainer runat="server"></dx:LayoutItemNestedControlContainer>
</LayoutItemNestedControlCollection>
                                             </dx:LayoutItem>
                                           <%-- <dx:LayoutItem Caption="X:" Name="txtAmtnoX">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAmtnoX" runat="server"  ReadOnly="False" Width="75px" Text="0">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                               <dx:LayoutItem Caption="X:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="sptxtAmtnoX" runat="server" MaxValue="999999999" Number="0.0" OnLoad="SpinEdit_Load" Width="75px">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="False" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

<%--                                            <dx:LayoutItem Caption="Y:" Name="txtAmtnoY">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAmtnoY" runat="server"  ReadOnly="False" Width="75px" Text="0">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Y:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="sptxtAmtnoY" runat="server" MaxValue="999999999" Number="0.0" OnLoad="SpinEdit_Load" Width="75px">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="False" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            


                                              <dx:LayoutItem Caption="Check:" Name="lblCheck" >
                                                  <LayoutItemNestedControlCollection>
<dx:LayoutItemNestedControlContainer runat="server"></dx:LayoutItemNestedControlContainer>
</LayoutItemNestedControlCollection>
                                             </dx:LayoutItem>
                                             <%--  <dx:LayoutItem Caption="Height:" Name="txtHeight">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHeight" runat="server"   ReadOnly="false" Width="75px" Text="0">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>


                                              <dx:LayoutItem Caption="Height:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="sptxtHeight" runat="server" MaxValue="999999999" Number="0.0" OnLoad="SpinEdit_Load" Width="75px">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="False" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            




                                         <%--   <dx:LayoutItem Caption="Width:" Name="txtCheckWidth">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCheckWidth" runat="server"  ReadOnly="false" Width="75px" Text="0">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                         --%>
                                               <dx:LayoutItem Caption="Width:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="sptxtCheckWidth" runat="server" MaxValue="999999999" Number="0.0" OnLoad="SpinEdit_Load" Width="75px">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="False" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            


                                        </Items>
                                    </dx:LayoutGroup>



                                        <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field1" Name="txtHField1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server"  OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field6" Name="txtHField6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server"  OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field2" Name="txtHField2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server"  OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field7" Name="txtHField7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server"  OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field3" Name="txtHField3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server"  OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field8" Name="txtHField8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server"  OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field4" Name="txtHField4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server"  OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field9" Name="txtHField9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server"  OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Field5" Name="txtHField5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server"  OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>


                                        


                                <dx:LayoutGroup Caption="Audit Trail" ColCount="2" ColSpan="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Added By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAddedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Added Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAddedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLastEditedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLastEditedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Approved By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtApprovedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Approved Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtApprovedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Activated By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActivatedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Activated Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActivatedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="DeActivated By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDeActivatedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="DeActivated Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDeActivatedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                </Items>
                            </dx:TabbedLayoutGroup>
                            
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
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.BankAccount" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.BankAccount" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:Parameter Name="BankAccount" Type="String" />
            <asp:Parameter Name="Conn" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
  <%--  <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.PredeterminedOHRate+TransactionDetail" SelectMethod="getdetail" UpdateMethod="UpdateTransactionDetail" TypeName="Entity.Transaction+TransactionDetail" DeleteMethod="DeleteTransactionDetail" InsertMethod="AddTransactionDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
         <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>--%>

   
     <%-- <asp:ObjectDataSource ID="odsKate" runat="server" SelectMethod="getreftransaction" TypeName="Entity.PredeterminedOHRate+RateHistory" >
        <SelectParameters>
            <asp:QueryStringParameter Name="RateCode" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>--%>

       <%-- <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  wms.TransactionDetail where DocNumber  is null ">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item]"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [ColorCode], [ClassCode], [SizeCode] FROM Masterfile.[ItemDetail] WHERE ISNULL(IsInactive,0)=0">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] where isnull(IsInactive,'')=0"></asp:SqlDataSource>
        <asp:SqlDataSource ID="Masterfilebizcustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,'')=0 and IsCustomer='1'"></asp:SqlDataSource>
        <asp:SqlDataSource ID="CostCenterCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select CostCenterCode,Description from Accounting.CostCenter" OnInit = "Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="PredeterminedOHRateType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select Code,Description from It.GenericLookup where LookUpKey = 'LOCTY'"></asp:SqlDataSource>
        <asp:SqlDataSource ID="AccountCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT AccountCode,Description from Accounting.ChartOfAccount where isnull(IsInactive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
        --%>
    <asp:SqlDataSource ID="dsglcode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT AccountCode,Description FROM Accounting.ChartOfAccount WHERE (ISNULL(IsInactive,1)=1 or IsInactive=0) order by 1" OnInit = "Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="dsType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Code, Description From IT.GenericLookUp WHERE LookUpKey = 'BNTYP' ORDER BY Code" OnInit = "Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="dsBranch" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Code, Description From IT.GenericLookUp WHERE LookUpKey = 'BRNCH' and IsInactive != 1 ORDER BY Code" OnInit = "Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="dsBankCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BankCode,Description From MasterFile.Bank where ISNULL(IsInactive,0) !=1" OnInit = "Connection_Init"></asp:SqlDataSource>

    </form>

    <!--#endregion-->
    </body>
</html>


