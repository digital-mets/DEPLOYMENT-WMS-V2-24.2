<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmPutaway.aspx.cs" Inherits="GWL.frmPutaway" %>

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
            height: 800px; /*Change this whenever needed*/
        }

         .Entry {
         padding: 20px;
         margin: 10px auto;
         background: #FFF;
         }

        .dxeButtonEditSys input,
        .dxeTextBoxSys input{
            text-transform:uppercase;
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
     var isValid = false;
     var counterror = 0;

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
         if (btnmode == "Delete") {
             cp.PerformCallback("Delete");
         }
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
             if (s.cp_forceclose) {//NEWADD
                 delete (s.cp_forceclose);
                 window.close();
             }
         }

         if (s.cp_close) {
             var btnmode = btn.GetText();
             if (s.cp_message != null) {
                 alert(s.cp_message);
                 delete (s.cp_message);
             }
             if (glcheck.GetChecked() && btnmode != "Close") {
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

         if (s.cp_result != null) {
             alert(s.cp_result);
             delete (s.cp_result)
             //window.location.reload();
         }
     }

     var itemc; //variable required for lookup
     var currentColumn = null;
     var isSetTextRequired = false;
     var linecount = 1;
     function OnStartEditing(s, e) {//On start edit grid function     
         currentColumn = e.focusedColumn;
         var cellInfo = e.rowValues[e.focusedColumn.index];
         itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
         //if (e.visibleIndex < 0) {//new row
         //    var linenumber = s.GetColumnByField("LineNumber");
         //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
         //}
         var entry = getParameterByName('entry');

         if (entry == "V") {
             e.cancel = true;
         }

         if (s.batchEditApi.GetCellValue(e.visibleIndex, "Status") == "S") {
             //if (e.focusedColumn.fieldName != "ToLocation") {
                 e.cancel = true;
             //}
         }

         if (entry != "V") {
             if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                 gl.GetInputElement().value = cellInfo.value; //Gets the column value
                 isSetTextRequired = true;
             }
             if (e.focusedColumn.fieldName === "ColorCode") {
                 gl2.GetInputElement().value = cellInfo.value;
             }
             if (e.focusedColumn.fieldName === "ClassCode") {
                 gl3.GetInputElement().value = cellInfo.value;
             }

             //if (e.focusedColumn.fieldName === "ToLocation") { //Check the column name
             //    glloc.GetInputElement().value = cellInfo.value; //Gets the column value
             //    isSetTextRequired = true;
             //}
             if (e.focusedColumn.fieldName === "Strategy") { //Check the column name
                 glStrat.GetInputElement().value = cellInfo.value; //Gets the column value
                 isSetTextRequired = true;
             }

             if (glStrategy.GetText() != "M") {
                 e.cancel = true;
             }
         }
     }

     function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
         var cellInfo = e.rowValues[currentColumn.index];
         if (currentColumn.fieldName === "ItemCode") {
             cellInfo.value = gl.GetValue();
             cellInfo.text = gl.GetText().toUpperCase();
         }
         if (currentColumn.fieldName === "ColorCode") {
             cellInfo.value = gl2.GetValue();
             cellInfo.text = gl2.GetText().toUpperCase();
         }
         if (currentColumn.fieldName === "ClassCode") {
             cellInfo.value = gl3.GetValue();
             cellInfo.text = gl3.GetText().toUpperCase();
         }

         //if (currentColumn.fieldName === "ToLocation") {
         //    cellInfo.value = glloc.GetValue();
         //    cellInfo.text = glloc.GetText().toUpperCase();
         //}
         if (currentColumn.fieldName === "Strategy") {
             cellInfo.value = glStrat.GetValue();
             cellInfo.text = glStrat.GetText().toUpperCase();
         }
     }

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

     function OnCustomClick(s, e) {
         if (e.buttonID == "Details") {
             var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
             var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
             var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
             var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
             factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
             + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode);
         }

         if (e.buttonID == "CountSheet") {
             CSheet.Show();
             var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
             var docnumber = getParameterByName('docnumber');
             var transtype = getParameterByName('transtype');
             var entry = getParameterByName('entry');

             if (glStrategy.GetText() == "M") {
                 CSheet.SetContentUrl('frmCountSheet.aspx?entry=' + entry + '&docnumber=' + docnumber + '&transtype=' + transtype +
                        '&linenumber=' + linenum + '&type=PutawayM', '_blank');
             }
             else {
                 CSheet.SetContentUrl('frmCountSheet.aspx?entry=' + entry + '&docnumber=' + docnumber + '&transtype=' + transtype +
                        '&linenumber=' + linenum + '&type=Putaway', '_blank');
             }
         }

     }

     function OnChange(s, e) {
         if (glStrategy.GetText() == "M") {
             Generatebtn.SetEnabled(false);
             gv1.PerformCallback("MStrat");
         } else {
             Generatebtn.SetEnabled(true);
             //cp.PerformCallback("MStrat");
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
         var height = Math.max(0, document.documentElement.clientHeight);
         gv1.SetWidth(width - 120);
         gv1.SetHeight(height - 120);
     }

     //#region For future reference JS 

     //Debugging purposes
     //function start(s, e) {
     //    pass = fieldValue;
     //    console.log("start callback " + pass);
     //}

     //function end(s, e) {
     //    console.log("end callback");
     //}
     //function rowclick(s, e) {
     //    s.GetRowValues(e.visibleIndex, 'ItemCode;ColorCode;ClassCode;SizeCode', function (data) {
     //        console.log(data[0], data[1], data[2], data[3]);
     //        //splitter.GetPaneByName("Factbox").SetContentUrl('../FactBox/fbBizPartner.aspx?itemcode=' + data[0]
     //        //+ '&colorcode='+data[1]+'&classcode='+data[2]+'&sizecode='+data[3]);
     //        factbox.SetContentUrl('../FactBox/fbBizPartner.aspx?itemcode=' + data[0]
     //        + '&colorcode=' + data[1] + '&classcode=' + data[2] + '&sizecode=' + data[3]);
     //    });
     //}

     //function getParameterByName(name) {
     //    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
     //    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
     //        results = regex.exec(location.search);
     //    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
     //}

     //function OnControlInitialized(event) {
     //    var entry = getParameterByName('entry');
     //    if (entry == "N") {
     //        splitter.GetPaneByName("Factbox").SetContentUrl('../FactBox/fbBizPartner.aspx');
     //        //splitter.GetPaneByName("Factbox2").SetContentUrl('../FactBox/fbBizPartner.aspx');
     //        //splitter.GetPaneByName("Factbox3").SetContentUrl('../FactBox/fbBizPartner.aspx');
     //        //splitter.GetPaneByName("Factbox4").SetContentUrl('../FactBox/fbBizPartner.aspx');
     //    }
     //}
     //#endregion

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
                                <dx:ASPxLabel runat="server" Text="Putaway" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
    <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="90"
         ShowCloseButton="False" ShowCollapseButton="True" Collapsed="true" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
         ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents CloseUp="function (s, e) { cp.PerformCallback('refgrid') }" />
    </dx:ASPxPopupControl>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="850px" Height="338px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="form1_layout" runat="server" Height="716px" Width="850px" style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocNumber" runat="server" AutoCompleteType="Disabled" Width="170px"
                                                         ReadOnly="true">
                                                            <ClientSideEvents Validation="function(){isValid=true;}" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="PutAway Strategy" Name="putawaystrat">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup Width="170px" ID="gvStrategy" runat="server"  AutoGenerateColumns="False" ClientInstanceName="glStrategy" DataSourceID="PutAwayStrategy" KeyFieldName="Code" OnLoad="LookupLoad" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="Code" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Room">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup Width="170px" ID="glRoom" runat="server" KeyFieldName="RoomCode" DataSourceID="roomsql" TextFormatString="{0}" AutoGenerateColumns="true">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxButton Width="170px" ID="Generatebtn" runat="server" UseSubmitBehavior="false"  AutoPostBack="False" ClientInstanceName="Generatebtn" Text="Generate Location">
                                                            <ClientSideEvents Click="function (s, e){
                                                                if(glStrategy.GetText() != ''){
                                                                var generate = confirm('Are you sure that you want to generate locations?');
                                                                                if (generate) {
                                                                                    cp.PerformCallback('generate');
                                                                                }
                                                                    }
                                                                else{
                                                                
                                                                    alert('No strategy selected!');
                                                                    }
                                                                }" />
                                                        </dx:ASPxButton>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                </Items>
                            </dx:TabbedLayoutGroup>
                            
                            <dx:LayoutGroup Caption="Inbound Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="850px" OnCustomButtonInitialize="gv1_CustomButtonInitialize"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" OnInit="gv1_Init"
                                                    OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber" OnCustomCallback="gv1_CustomCallback"
                                                    SettingsBehavior-AllowSort="false" StylesEditors-Native="true">
                                                    <ClientSideEvents Init="OnInitTrans" />
                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False" PropertiesTextEdit-Native="true"
                                                            VisibleIndex="0">
                                                        </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="80px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False" Native="true">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="3" Width="120px" Name="glItemCode"  ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" Caption="ItemDesc" VisibleIndex="4" Width="250px" ReadOnly="true"   >
                                                        </dx:GridViewDataTextColumn>
                                                        <%--<dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="4" Width="80px" UnboundType="String"  ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" VisibleIndex="5" Width="80px" UnboundType="String"  ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn ShowInCustomizationForm="True" VisibleIndex="6" FieldName="SizeCode" Width="80px"  ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>--%>
                                                        <dx:GridViewDataTextColumn FieldName="BulkQty" VisibleIndex="8" Width="80px" Caption="Qty"  ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BulkUnit" VisibleIndex="9" Name="BulkUnit" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                            <PropertiesTextEdit NullDisplayText="0">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Name="ReceivedQty" Caption="Kilos" ShowInCustomizationForm="True" VisibleIndex="10" FieldName="ReceivedQty" ReadOnly="true" PropertiesTextEdit-Native="true" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Name="PalletID" ShowInCustomizationForm="True" VisibleIndex="15" FieldName="PalletID" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BaseQty" Name="BaseQty" ShowInCustomizationForm="True" VisibleIndex="20" UnboundType="Decimal"  ReadOnly="true"  PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                    <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="80px">
                                                        <CustomButtons>
                                                            <dx:GridViewCommandColumnCustomButton ID="Details">
                                                               <Image IconID="support_info_16x16"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                            <dx:GridViewCommandColumnCustomButton ID="CountSheet">
                                                               <Image IconID="arrange_withtextwrapping_topleft_16x16" ToolTip="Countsheet"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                        </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Unit" Name="Unit" ShowInCustomizationForm="True" VisibleIndex="10" UnboundType="String" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Name="ToLocation" ShowInCustomizationForm="True" VisibleIndex="13" FieldName="ToLocation" PropertiesTextEdit-Native="true">
                                                            <%--<EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glLocation" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="glloc" DataSourceID="locationsql" KeyFieldName="LocationCode" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="LocationCode" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="WarehouseCode" ReadOnly="True" VisibleIndex="1" />
                                                                        <dx:GridViewDataTextColumn FieldName="RoomCode" ReadOnly="True" VisibleIndex="2" />
                                                                    </Columns>
                                                                    <ClientSideEvents RowClick="function(s,e){
                                                                     setTimeout(function(){
                                                                        gv1.batchEditApi.EndEdit();
                                                                    }, 500);
                                                                  }"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>--%>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Strategy"  Caption="Strategy" Name="Strategy" ShowInCustomizationForm="True" VisibleIndex="14"  PropertiesTextEdit-Native="true">
                                                            <EditItemTemplate>
                                                                 <dx:ASPxGridLookup Width="80px" ID="glStrategy" runat="server" AutoGenerateColumns="False" DataSourceID="PutAwayStrategy" KeyFieldName="Code" TextFormatString="{0}"
                                                                ClientInstanceName="glStrat" GridViewStylesEditors-Native="true">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="Code" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                                    <ClientSideEvents RowClick="function(s,e){
                                                                     setTimeout(function(){
                                                                        gv1.batchEditApi.EndEdit();
                                                                    }, 500);
                                                                  }"/>
                                                        </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1"  Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="23" UnboundType="Bound" ReadOnly="true"  PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Caption="Field2"  Name="Field2" ShowInCustomizationForm="True" VisibleIndex="24" UnboundType="Bound" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Caption="Field3"  Name="Field3" ShowInCustomizationForm="True" VisibleIndex="25" UnboundType="Bound" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Caption="Field4"  Name="Field4" ShowInCustomizationForm="True" VisibleIndex="26" UnboundType="Bound" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Caption="Field5"  Name="Field5" ShowInCustomizationForm="True" VisibleIndex="27" UnboundType="Bound" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Caption="Field6"  Name="Field6" ShowInCustomizationForm="True" VisibleIndex="28" UnboundType="Bound" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Caption="Field7"  Name="Field7" ShowInCustomizationForm="True" VisibleIndex="29" UnboundType="Bound" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8"  Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="30" UnboundType="Bound" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9"  Caption="Field9"  Name="Field9" ShowInCustomizationForm="True" VisibleIndex="31" UnboundType="Bound" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn FieldName="ManufacturingDate" ShowInCustomizationForm="True" VisibleIndex="15" UnboundType="String" Name="dtpManufacturingDate" ReadOnly="true">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BatchNumber" Name="BatchNumber" ShowInCustomizationForm="True" VisibleIndex="11" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LotID" ShowInCustomizationForm="True" VisibleIndex="12" Name="LotID" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="StatusCode" ShowInCustomizationForm="True" VisibleIndex="21" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BarcodeNo" ShowInCustomizationForm="True" VisibleIndex="22" Caption="Barcode Number" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn FieldName="ExpiryDate" ShowInCustomizationForm="True" VisibleIndex="16" Name="dtpExpiryDate" ReadOnly="true">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn FieldName="RRDocDate" ShowInCustomizationForm="True" VisibleIndex="17" Name="dtpRRDocDate" ReadOnly="true">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn FieldName="PickedQty" Name="PickedQty" ShowInCustomizationForm="True" VisibleIndex="18" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Remarks" Name="Remarks" ShowInCustomizationForm="True" VisibleIndex="19" ReadOnly="true" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Status" ShowInCustomizationForm="True" VisibleIndex="20" Width="0px" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="OriginalLineNumber" ShowInCustomizationForm="True" VisibleIndex="31" Width="0px" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SubLineNumber" ShowInCustomizationForm="True" VisibleIndex="32" Width="0px" PropertiesTextEdit-Native="true">
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                                     <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager Mode="ShowAllRecords" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" VerticalScrollableHeight="530" ShowFooter="True" /> 
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                            <SettingsEditing Mode="Batch" />
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
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
                             </dx:ASPxButton>
                         <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                             <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                             </dx:ASPxButton>  
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
    <!--#region Region Datasource-->
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.Putaway+PutawayDetail" SelectMethod="getdetail" UpdateMethod="UpdatePutawayDetail" TypeName="Entity.Putaway+PutawayDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  wms.InboundDetail where DocNumber  is null " OnInit ="Connection_Init"></asp:SqlDataSource>
    
    <asp:SqlDataSource ID="Warehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WareHouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,'')=0" OnInit ="Connection_Init"></asp:SqlDataSource>
     <asp:SqlDataSource ID="PutAwayStrategy" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Code,Description FROM IT.GenericLookup WHERE LookUpKey = 'PTSTR'" OnInit ="Connection_Init"></asp:SqlDataSource>
<%--    <asp:SqlDataSource ID="locationsql" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select LocationCode,WarehouseCode,RoomCode from masterfile.location" OnInit ="Connection_Init"></asp:SqlDataSource>--%>
    <asp:SqlDataSource ID="roomsql" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>
</form>
    </body>
</html>


