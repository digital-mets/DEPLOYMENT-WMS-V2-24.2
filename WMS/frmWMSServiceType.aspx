<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmWMSServiceType.aspx.cs" Inherits="GWL.frmWMSServiceType" %>

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
            height: 300px; /*Change this whenever needed*/
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
             //alert(s.cp_valmsg);
             alert(s.cp_message);
             //delete (s.cp_valmsg);
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
     function ComboboxChanged(s, e) {
         var Type = cboServType.GetText();
         console.log(Type);
         
         if (Type == "Storage") {
             console.log('test');
             txtField1.SetEnabled(false);
             txtField1.SetText(null);
             txtField2.SetEnabled(false);
             txtField2.SetText(null);
             txtField3.SetEnabled(false);
             txtField3.SetText(null);
             txtField4.SetEnabled(false);
             txtField4.SetText(null);
             //txtField5.SetEnabled(false);
             txtField5.SetText(null);
             txtField6.SetEnabled(false);
             txtField6.SetText(null);
             txtField7.SetEnabled(false);
             txtField7.SetText(null);
             txtField8.SetEnabled(false);
             txtField8.SetText(null);
             txtField9.SetEnabled(false);
             txtField9.SetText(null);
         }
         else {
             txtField1.SetEnabled(true);
             txtField2.SetEnabled(true);
             txtField3.SetEnabled(true);
             txtField4.SetEnabled(true);
             txtField5.SetText('Rate');
             txtField6.SetEnabled(true);
             txtField7.SetEnabled(true);
             txtField8.SetEnabled(true);
             txtField9.SetEnabled(true);
         }
     }

     function RestrictSpace(s, e) {


         var str = txtCode.GetText();
         var result = '';
         for (var i = 0; i < str.length; i++) {
             if (str[i] != ' ') {
                 console.log(str[i])
                 result += str[i]
             }
         }
         txtCode.SetText(result)

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

     var preventEndEditOnLostFocus = false;
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
     function initlayout() {
         ComboboxChanged();
     }
     function OnInitTrans(s, e) {
         AdjustSize();
     }

     function OnControlsInitialized(s, e) {
         //ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
         //    AdjustSize();
         //});
     }

     function AdjustSize() {
         var width = Math.max(0, document.documentElement.clientWidth);
        // gv1.SetWidth(width - 120);
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
                                <dx:ASPxLabel runat="server" Text="WMS Service Type" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
    
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="850px" Height="220px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="form1_layout" runat="server" Height="287px" Width="850px" style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>


                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Type of Service">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="cboServType" runat="server" Width="170px" ClientInstanceName="cboServType" OnLoad="Comboboxload">
                                                            <ClientSideEvents Validation="OnValidation"  />
                                                            <Items>
                                                                <dx:ListEditItem Text="Storage" Value="STORAGE" />
                                                                <dx:ListEditItem Text="Non Storage" Value="NONSTORAGE" />
                                                            </Items>
                                                            <ClientSideEvents SelectedIndexChanged="ComboboxChanged" Init="ComboboxChanged"/>
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtField1" runat="server" Width="170px" ClientInstanceName="txtField1" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                        
                                            <dx:LayoutItem Caption="Service Type Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCode" runat="server" Width="170px" ClientInstanceName="txtCode" OnLoad="TextboxLoad" >
                                                            <ClientSideEvents Validation="OnValidation" TextChanged ="RestrictSpace"/>
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                     
                                            <dx:LayoutItem Caption="Field2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtField2" runat="server" Width="170px" ClientInstanceName="txtField2" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Service Type Description">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDesc" runat="server" Width="170px" OnLoad="TextboxLoad" >
                                                         <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtField3" runat="server" Width="170px" ClientInstanceName="txtField3" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Sequence Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSeq" runat="server" Width="170px" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtField4" runat="server" Width="170px" ClientInstanceName="txtField4" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Service Rate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtRate" runat="server" Number="0" Width="170px" MinValue="0" MaxValue="99999999999" SpinButtons-ShowIncrementButtons="false" OnLoad="SpinEdit_Load" >
                                                        <SpinButtons ShowIncrementButtons ="false" />
                                                         <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtField5" runat="server" Width="170px" Text="Rate" ClientInstanceName="txtField5" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Service Type Category">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="cboCat" runat="server" Width="170px" OnLoad="Comboboxload" >                                                           
                                                           <ClientSideEvents Validation="OnValidation"  />
                                                             <Items>
                                                                <dx:ListEditItem Text="Service" Value="S" />
                                                                <dx:ListEditItem Text="Rent" Value="R" />
                                                            </Items>
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="txtField6" runat="server" Width="170px" ClientInstanceName="txtField6" OnLoad="Comboboxload" >
                                                               <Items>
                                                                <dx:ListEditItem Text="Vat" Value="Vat" />
                                                                <dx:ListEditItem Text="Non Vat" Value="NonVat" />
                                                            </Items>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Sales GLCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glSalesGL" runat="server" Width="170px"  AutoGenerateColumns="True" DataSourceID="SalesGLCode" KeyFieldName="AccountCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e) {
                                                                    var grid = subsi.GetGridView();
                                                                    subsi.GetGridView().PerformCallback(s.GetInputElement().value);
                                                                     
                                                                }"/>
                                                                
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="txtField7" runat="server" Width="170px" ClientInstanceName="txtField7" OnLoad="Comboboxload" >
                                                             <Items>
                                                                <dx:ListEditItem Text="Amount" Value="Amount" />
                                                                <dx:ListEditItem Text="Total Charges" Value="TotalCharges" />
                                                            </Items>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Sales GLSubsiCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glSalesSubsi" runat="server" Width="170px" ClientInstanceName="subsi" OnInit="glRevSubsi_Init" AutoGenerateColumns="False" DataSourceID="SubsiCode" KeyFieldName="SubsiCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                                <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="SubsiCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                          
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtField8" runat="server" Width="170px" ClientInstanceName="txtField8" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="AR GLCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glARGL" runat="server" Width="170px"  AutoGenerateColumns="True" DataSourceID="SalesGLCode" KeyFieldName="AccountCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e) {
                                                                    var grid = subsi2.GetGridView();
                                                                    subsi2.GetGridView().PerformCallback(s.GetInputElement().value);
                                                                     
                                                                }"/>
                                                             
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtField9" runat="server" Width="170px" ClientInstanceName="txtField9" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="AR GLSubsiCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glARSubsi" runat="server" Width="170px" ClientInstanceName="subsi2" OnInit="glRevSubsi2_Init" AutoGenerateColumns="False" DataSourceID="SubsiCode2" KeyFieldName="SubsiCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                                 <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="SubsiCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                           
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="IsStandard">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkStandard" runat="server" CheckState="Unchecked" OnLoad="CheckboxLoad">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                <dx:LayoutItem Caption="IsInactive">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkIsInactive" ClientInstanceName="chkIsInactive" OnLoad="CheckboxLoad" runat="server" CheckState="Unchecked" Text=" ">
                                                        </dx:ASPxCheckBox>
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
    </form>
    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.WMSServiceType" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.WMSServiceType" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="" Name="DocNumber" SessionField="DocNumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.WMSServiceType+TransactionDetail" SelectMethod="getdetail" UpdateMethod="UpdateTransactionDetail" TypeName="Entity.Transaction+TransactionDetail" DeleteMethod="DeleteTransactionDetail" InsertMethod="AddTransactionDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  wms.TransactionDetail where DocNumber  is null " OnInit = "Connection_init">
     
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item]" OnInit = "Connection_init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SubsiCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select A.AccountCode,B.SubsiCode,B.Description from Accounting.ChartOfAccount A inner join Accounting.GLSubsiCode B on A.AccountCode = B.AccountCode" OnInit = "Connection_init">
    </asp:SqlDataSource>
        <asp:SqlDataSource ID="SubsiCode2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select A.AccountCode,B.SubsiCode,B.Description from Accounting.ChartOfAccount A inner join Accounting.GLSubsiCode B on A.AccountCode = B.AccountCode" OnInit = "Connection_init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="ServiceType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand= "select ServiceType,Description from  Masterfile.WMSServiceType B  WHERE ISNULL(IsInActive,0)=0 and ISNULL(B.Type,0) = 'STORAGE'" OnInit = "Connection_init"></asp:SqlDataSource>
      <asp:SqlDataSource ID="SalesGLCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT AccountCode,Description FROM Accounting.ChartOfAccount WHERE ISNULL(IsInactive,0) = 0 ORDER BY AccountCode" OnInit = "Connection_init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="ARGLCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select AccountCode,Description from Accounting.ChartOfAccount where AccountCode like ('12%')" OnInit = "Connection_init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="UnitOfMeasure" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT UnitOfMeasure,Description from Masterfile.WMSUnitOfMeasure" OnInit = "Connection_init"></asp:SqlDataSource>
  <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BPCustomerInfo] where isnull(IsInactive,0)=0" OnInit = "Connection_init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilebizcustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,0)=0 and IsCustomer='1'" OnInit = "Connection_init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Bizpartner" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select BizPartnerCode,Name from Masterfile.BizPartner where IsInactive=0 and IsCustomer=1 " OnInit = "Connection_init"></asp:SqlDataSource>

    <!--#endregion-->
    </body>
</html>


