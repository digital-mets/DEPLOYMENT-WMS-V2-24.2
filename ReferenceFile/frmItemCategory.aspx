<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmItemCategory.aspx.cs" Inherits="GWL.frmItemCategory" %>

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
     function Oncheckboxchanged(s, e) {
         var IsAsset = chkAsset.GetChecked();
         if (IsAsset == false) {
             console.log('test');
             gvAccGL.SetEnabled(false);
             gvAccGL.SetValue(null);
             gvDepGL.SetEnabled(false);
             gvDepGL.SetValue(null);
             txtAsset.SetEnabled(false);
             txtAsset.SetText(null);
         }
         else {
             gvAccGL.SetEnabled(true);
             gvDepGL.SetEnabled(true);
             txtAsset.SetEnabled(true);
         }
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
      
     }

     function initlayout() {
         Oncheckboxchanged();
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
                                <dx:ASPxLabel runat="server" Text="ItemCategory" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
    
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="1050px" Height="338px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="form_01" runat="server" Height="269px" Width="850px" style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>


                            <dx:TabbedLayoutGroup >
                                <Items>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>
                                            <dx:LayoutGroup Caption="Information" ColCount="2">
                                                <Items>
                                            <dx:LayoutItem Caption="ItemCategory Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtItemCat" runat="server" AutoCompleteType="Disabled"  Width="170px" OnLoad="TextboxLoad">
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
                                            <dx:LayoutItem Caption="Threshold">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtThres" runat="server" Number="0" MinValue="0" MaxValue="999999999999" Width="170px" OnLoad="SpinEdit_Load">
                                                        <SpinButtons ShowIncrementButtons="false" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                        
                                            <dx:LayoutItem Caption="Description">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDesc" runat="server" Width="170px" OnLoad="TextboxLoad">
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
                                                     
                                            <dx:LayoutItem Caption="Base Unit">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvBase" runat="server" Width="170px" AutoGenerateColumns="False" OnLoad="LookupLoad" DataSourceID="Unit" KeyFieldName="UnitCode" TextFormatString="{0}">
                                                             <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

<Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                  <dx:LayoutItem Caption="ItemCode Format">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtItemForm" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Bulk Unit">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvBulk" runat="server" Width="170px" OnLoad="LookupLoad" AutoGenerateColumns="False" DataSourceID="Unit" KeyFieldName="UnitCode" TextFormatString="{0}">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

<Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Inventory GLCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvInvGL" runat="server" Width="170px" DataSourceID="ChartOfAccount" KeyFieldName="AccountCode" OnLoad="LookupLoad" TextFormatString="{0}">
<%--                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e) {
                                                                    var grid = subsi.GetGridView();
                                                                    subsi.GetGridView().PerformCallback(s.GetInputElement().value);
                                                                     
                                                                }"/>--%>
                                                                                                                     <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                             <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                          <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e) {
                                                                   cp.PerformCallback('glcode');
                                                                   e.processOnServer = false;
                                                                }"/>
                                                                                                                     <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
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
                                            <dx:LayoutItem Caption="Costing Method">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" >
                                                        <dx:ASPxComboBox ID="cboCost" runat="server" Width="170px" OnLoad="Comboboxload">
                                                            <Items>
                                                                <dx:ListEditItem Text="First In First Out" Value="FIFO" />
                                                                <dx:ListEditItem Text="Moving Average Costing" Value="MAC" />
                                                                <dx:ListEditItem Text="Specific Identification" Value="SI" />
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
                                            <dx:LayoutItem Caption="GL SubsiCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvGLSubsi" DataSourceID="GLSubsiCode" runat="server" Width="170px" KeyFieldName="SubsiCode" TextFormatString="{0}" AutoGenerateColumns="True" OnLoad="LookupLoad" >
                                                           
                                                             <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle> <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

<Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="IsAllowNega">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkAllowNega" runat="server" CheckState="Unchecked" Text=" " OnLoad="CheckboxLoad">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Adjustment GLCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvAdjGL" runat="server" Width="170px" OnLoad="LookupLoad" TextFormatString="{0}" KeyFieldName="AccountCode" DataSourceID="ChartOfAccount">
                                                              <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle> <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

<Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Allow ZeroCost">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkAllowZero" runat="server" CheckState="Unchecked" Text="   " OnLoad="CheckboxLoad">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Allocation">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="cboAllocation" runat="server" OnLoad="Comboboxload" Width="170px">
                                                            <Items>
                                                                <dx:ListEditItem Text="Allocation by Order" Value="Allocation by Order" />
                                                                <dx:ListEditItem Text="Allocation by Onhand" Value="Allocation by Onhand" />
                                                                <dx:ListEditItem Text="No Allocation" Value="No Allocation" />
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
                                            <dx:LayoutItem Caption="IsForecasted">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkForecasted" runat="server" CheckState="Unchecked" Text=" " OnLoad="CheckboxLoad">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="IsInactive">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkIsInactive" runat="server" CheckState="Unchecked" OnLoad="CheckboxLoad" ReadOnly="True" Text=" ">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="IsStock">
                                                      <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" >
                                                        <dx:ASPxCheckBox ID="chkIsStock" runat="server" CheckState="Unchecked">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Sales Account" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Sales GLCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvSalesGL" runat="server" Width="170px" AutoGenerateColumns="false" OnLoad="LookupLoad" DataSourceID="ChartOfAccount" KeyFieldName="AccountCode" TextFormatString="{0}">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                            <Settings ShowFilterRow="True"></Settings>
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
                                            <dx:LayoutItem Caption="AR GLCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtARGL" runat="server" Width="170px" AutoGenerateColumns="true" DataSourceID="ChartOfAccount" OnLoad="LookupLoad" KeyFieldName="AccountCode" TextFormatString="{0}">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                               <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Sales Return GLCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvSalesReturn" runat="server" Width="170px" AutoGenerateColumns="true" DataSourceID="ChartOfAccount" OnLoad="LookupLoad" KeyFieldName="AccountCode" TextFormatString="{0}">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                               <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cost Of Goods GLCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvCostGL" runat="server" Width="170px" AutoGenerateColumns="false" OnLoad="LookupLoad" DataSourceID="ChartOfAccount" KeyFieldName="AccountCode" TextFormatString="{0}">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                                <%--<Settings ShowFilterRow="True"></Settings>--%>

<Settings ShowFilterRow="True"></Settings>
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
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Assets Account" ColCount="2">
                                        <Items>
                                              <dx:LayoutItem Caption="IsAsset">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkAsset" runat="server" CheckState="Unchecked" Text=" " ClientInstanceName="chkAsset" OnLoad="CheckboxLoad">
                                                            <ClientSideEvents Init="Oncheckboxchanged" ValueChanged="Oncheckboxchanged"/>
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Accumulated GLCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvAccGL" ClientInstanceName="gvAccGL" OnLoad="LookupLoad" runat="server" Width="170px" AutoGenerateColumns="False" DataSourceID="ChartOfAccount" KeyFieldName="AccountCode" TextFormatString="{0}">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                            <Settings ShowFilterRow="True"></Settings>
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
                                            <dx:LayoutItem Caption="Depreciation GLCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvDepGL" ClientInstanceName="gvDepGL" OnLoad="LookupLoad" runat="server" Width="170px" AutoGenerateColumns="false" DataSourceID="ChartOfAccount" KeyFieldName="AccountCode" TextFormatString="{0}">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                            <Settings ShowFilterRow="True"></Settings>
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
                                            <dx:LayoutItem Caption="Asset Life in Months">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtAsset" ClientInstanceName="txtAsset" OnLoad="SpinEdit_Load" runat="server" Number="0" MinValue="0" MaxValue="999999999999" Width="170px">
                                                        <SpinButtons ShowIncrementButtons="false" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>

                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                                <dx:LayoutItem Caption="Look Up Caption">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLookCap" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field4" Name="txtHField4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Look Up Key">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLookKey" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field5" Name="txtHField5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Required">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkReq" runat="server" CheckState="Unchecked" Text=" " OnLoad="CheckboxLoad">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field6" Name="txtHField6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field1" Name="txtHField1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field7" Name="txtHField7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field2" Name="txtHField2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field8" Name="txtHField8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field3" Name="txtHField3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field9" Name="txtHField9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" OnLoad="TextboxLoad" >
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
    <%--                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e) {
                                                                    var grid = subsi.GetGridView();
                                                                    subsi.GetGridView().PerformCallback(s.GetInputElement().value);
                                                                     
                                                                }"/>--%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.ItemCategory" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.ItemCategory" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="" Name="DocNumber" SessionField="DocNumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.ItemCategory+TransactionDetail" SelectMethod="getdetail" UpdateMethod="UpdateTransactionDetail" TypeName="Entity.Transaction+TransactionDetail" DeleteMethod="DeleteTransactionDetail" InsertMethod="AddTransactionDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
             <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>


    <%--<Settings ShowFilterRow="True"></Settings>--%><%--                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e) {
                                                                    var grid = subsi.GetGridView();
                                                                    subsi.GetGridView().PerformCallback(s.GetInputElement().value);
                                                                     
                                                                }"/>--%>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  wms.TransactionDetail where DocNumber  is null "
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="GLSubsiCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select SubsiCode, Description from Accounting.GLSubsiCode where ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>

    
    <asp:SqlDataSource ID="ChartOfAccount" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT AccountCode, Description from Accounting.ChartofAccount WHERE ISNULL(IsInactive,0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    
<%--<Settings ShowFilterRow="True"></Settings>--%><%--<!--#region Region Header --> --%>
    <asp:SqlDataSource ID="Unit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT UnitCode, Description FROM Masterfile.Unit WHERE ISNULL(IsInactive,0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    </form>

    <!--#endregion-->
    </body>
</html>


