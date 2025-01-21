<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmPreProductionOut.aspx.cs" Inherits="GWL.frmPreProductionOut" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
<title> Material Order</title>
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

        .dxeButtonEditSys input,
        .dxeTextBoxSys input{
          
        }

         .pnl-content
        {
            text-align: right;
        }
    </style>
    <!--#endregion-->
    <script>
        var isValid = true;
        var counterror = 0;


        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        var entry = getParameterByName('entry');



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
                if (s.cp_message != null) {
                    alert(s.cp_message);
                    delete (s.cp_message);
                }
                if (s.cp_valmsg != null && s.cp_valmsg != "" && s.cp_valmsg != undefined) {
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

        var itemc;
        var index;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "JobOrder"); //needed var for all lookups; this is where the lookups vary for

            index = e.visibleIndex;
            var entry = getParameterByName('entry');

            if (entry == "V" || entry == "D") {
                e.cancel = true; //this will made the gridview readonly
            }

            if (e.focusedColumn.fieldName === "ProductOrder" ) { //Check the column name
                e.cancel = true;
            }

            //if (e.focusedColumn.fieldName === "ColorCode") {
            //    gl2.GetInputElement().value = cellInfo.value;
            //}
            //if (e.focusedColumn.fieldName === "ClassCode") {
            //    gl3.GetInputElement().value = cellInfo.value;
            //}
            if (e.focusedColumn.fieldName === "JobOrder") {
                gl4.GetInputElement().value = cellInfo.value;
            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            //if (currentColumn.fieldName === "ItemCategoryCode") {
            //    cellInfo.value = gl.GetValue();
            //    cellInfo.text = gl.GetText();
            //}
            //if (currentColumn.fieldName === "ColorCode") {
            //    cellInfo.value = gl2.GetValue();
            //    cellInfo.text = gl2.GetText();
            //}
            //if (currentColumn.fieldName === "ClassCode") {
            //    cellInfo.value = gl3.GetValue();
            //    cellInfo.text = gl3.GetText();
            //}
            if (currentColumn.fieldName === "JobOrder") {
                cellInfo.value = gl4.GetValue();
                cellInfo.text = gl4.GetText();
            }
        }

        function lookup(s, e) {
            if (isSetTextRequired) {//Sets the text during lookup for item code
                s.SetText(s.GetInputElement().value);
                isSetTextRequired = false;
            }
        }

        var val;
        var temp;
        function GridEnd(s, e) {

            val = s.GetGridView().cp_codes;

            if (val != null) {
                temp = val.split(';');
                delete (s.GetGridView().cp_codes);
            }
            else {
                val = "";
                delete (s.GetGridView().cp_codes);
            }

            if (valchange && (val != null && val != 'undefined' && val != '')) {
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, e, column, gv1);
                    gv1.batchEditApi.EndEdit();
                }
            }
        }

        function ProcessCells(selectedIndex, e, column, s) {
            if (val == null) {
                val = ";;";
                temp = val.split(';');
            }

            if (temp[0] == null) {
                temp[0] = "";
            }


            if (selectedIndex == 0) {
                if (column.fieldName == "ProductOrder") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                }
               
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
                //if (column.fieldName == "ATCCode") {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                //    
                //    var cellValidationInfo = e.validationInfo[column.index];
                //    if (!cellValidationInfo) continue;
                //    var value = cellValidationInfo.value;
                //    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                //        cellValidationInfo.isValid = false;
                //        cellValidationInfo.errorText = column.fieldName + " is required";
                //        isValid = false;
                //    }
                //}
                var chckd;

                //else 
                if (column.fieldName == "TransAPAmount") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                }
                if (column.fieldName == "EWT") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (ASPxClientUtils.Trim(value) == true) {
                        chckd = true;
                    }
                }
                if (column.fieldName == "ATCCode") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") && chckd == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                }
            }
        }

        function OnFileUploadComplete(s, e) {//Loads the excel file into the grid
            gv1.PerformCallback();
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
            if (e.buttonID == "ViewTransaction") {

                var transtype = s.batchEditApi.GetCellValue(e.visibleIndex, "TransType");
                var docnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "DocNumber");
                var commandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "CommandString");

                window.open(commandtring + '?entry=V&transtype=' + transtype + '&parameters=&iswithdetail=true&docnumber=' + docnumber, '_blank', "", false);
                console.log('ViewTransaction')
            }
            if (e.buttonID == "ViewReferenceTransaction") {

                var rtranstype = s.batchEditApi.GetCellValue(e.visibleIndex, "RTransType");
                var rdocnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "REFDocNumber");
                var rcommandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "RCommandString");
                window.open(rcommandtring + '?entry=V&transtype=' + rtranstype + '&parameters=&iswithdetail=true&docnumber=' + rdocnumber, '_blank');
                console.log('ViewTransaction')
            }
        }

        function CloseGridLookup() {
            glInvoice.ConfirmCurrentSelection();
            glInvoice.HideDropDown();
            //glInvoice.Focus();
        }

        function Clear() {
            glInvoice.SetValue(null);
        }

        function autocalculate(s, e) {
            var amount = 0.00;
            var vatrate = 0.00;
            var atcrate = 0.00;
            var totalamount = 0.00;


            setTimeout(function () { //New Rows
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        console.log("new row " + indicies[i]);
                    }
                    else { //Existing Rows
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            amount = gv1.batchEditApi.GetCellValue(indicies[i], "Amount");
                            atcrate = gv1.batchEditApi.GetCellValue(indicies[i], "ATCCode");

                            //console.log(gv1.batchEditApi.GetCellValue(indicies[i], "IsVat"));
                            if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVatable") == true) {
                                vatrate = gv1.batchEditApi.GetCellValue(indicies[i], "vatrate");
                                vatamount += amount * vatrate;
                                grossvatable += amount;
                            }
                            else {
                                grossnonvatable += amount;
                            }

                            if (gv1.batchEditApi.GetCellValue(indicies[i], "IsEWT") == true) {
                                if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVatable") == true) {
                                    atcrate = gv1.batchEditApi.GetCellValue(indicies[i], "atcrate");
                                    whtaxamount += amount * atcrate;
                                }
                            }
                        }
                    }


                }
                totalamountdue = (grossvatable + grossnonvatable + vatamount) - whtaxamount;
                txtvatamount.SetText(vatamount.toFixed(2));
                txtgrossvatable.SetText(grossvatable.toFixed(2));
                txtgrossnonvatable.SetText(grossnonvatable.toFixed(2));
                txtwhvatamount.SetText(whtaxamount.toFixed(2));
                txtamountdue.SetText(totalamountdue.toFixed(2));
            }, 500);
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
        
            gvRef.SetWidth(width - 120);
            gv1.SetWidth(width - 120);
        }

    </script>
    <!--#endregion-->
</head>
<body style="height: 565px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
<form id="form1" runat="server" class="Entry">
                        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Unfinished WIP/Scrap" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                        <%--    <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="90"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>--%><%--    <h1>AP Voucher</h1>--%>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="850px" Height="565px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">

                    <dx:ASPxFormLayout ID="frmlayout1" runat="server"  Height="565px" Width="850px" style="margin-left: -3px" ClientInstanceName="frmlayout">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                          <%--<!--#region Region Header --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                                      <dx:LayoutItem Caption="UnfinishedWIP No." Name="DocNumber" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocnumber" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date:" Name="DocDate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpdocdate" runat="server"  Width="170px" OnInit="dtpDocDate_Init"  OnLoad="Date_Load">
                                                              <ClientSideEvents Validation="OnValidation"  />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip" >
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                 
              
                                                     <%--   <dx:LayoutItem Caption="Step" Name="Step" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glStep" runat="server" DataSourceID="sdsStep" KeyFieldName="StepCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <ClientSideEvents Validation="OnValidation"    ValueChanged="function(s,e){ cp.PerformCallback('Step');
                                                                      e.processOnServer = false; }"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="true" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                           

                                              <%-- <dx:LayoutItem Caption="Customer Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtType" runat="server" Text="" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>

                                           <dx:LayoutItem Caption="Year:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="ASPxTextBox3" runat="server"  OnLoad="TextboxLoad"  Width="50px">
                                                    
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="WorkWeek">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="ASPxTextBox1" runat="server"  OnLoad="TextboxLoad"  Width="50px">
                                                    
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                         
 


                                            <dx:LayoutItem Caption="SKU:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="ASPxTextBox2" runat="server"  OnLoad="TextboxLoad"  Width="170px">
                                                    
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                <dx:LayoutItem Caption="Batch No">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRemarks" runat="server"  OnLoad="TextboxLoad"  Width="170px">
                                                    
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Process Step:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="ASPxTextBox4" runat="server"  OnLoad="TextboxLoad"  Width="170px">
                                                    
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Machine Code:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="ASPxTextBox5" runat="server"  OnLoad="TextboxLoad"  Width="170px">
                                                    
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Scrap Type" Name="ScrapType">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                        <dx:ASPxComboBox ID="cboType"  runat="server" Width="170px" ClientInstanceName="cboType">
                                                            <ClientSideEvents SelectedIndexChanged="typechanged" />
                                                            <Items>
                                                                <dx:ListEditItem Text="Disposable" Value="D" Selected="true" />
                                                                <dx:ListEditItem Text="For Reprocess" Value="R" />
                                                                <dx:ListEditItem Text="Usable Already" Value="U" />
                                                            </Items>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Machine Wastage%:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="ASPxTextBox6" runat="server"  OnLoad="TextboxLoad"  Width="50px" Text="3">
                                                    
                                                            
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Scrap Code:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="ASPxTextBox7" runat="server"  OnLoad="TextboxLoad"  Width="170px" Text="S-GR-0001">
                                                    
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Remarks:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="ASPxTextBox8" runat="server"  OnLoad="TextboxLoad"  Width="170px">
                                                    
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Qty(KG):">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="ASPxTextBox9" runat="server"  OnLoad="TextboxLoad"  Width="170px">
                                                    
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Expiry Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="ASPxTextBox10" runat="server"  OnLoad="TextboxLoad"  Width="170px">
                                                    
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="# of Sack for Diposal:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="ASPxTextBox11" runat="server"  OnLoad="TextboxLoad"  Width="170px">
                                                    
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                        </Items>
                                    </dx:LayoutGroup>
                                    <%--<dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" OnLoad="TextboxLoad" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                           
                                            <dx:LayoutItem Caption="Field2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" OnLoad="TextboxLoad" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                              
                                            <dx:LayoutItem Caption="Field3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" OnLoad="TextboxLoad" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
             
                                            <dx:LayoutItem Caption="Field4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" OnLoad="TextboxLoad" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                             
                                            <dx:LayoutItem Caption="Field5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" OnLoad="TextboxLoad" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                             <dx:LayoutItem Caption="Field6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" OnLoad="TextboxLoad" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                          <dx:LayoutItem Caption="Field7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" OnLoad="TextboxLoad" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                  <dx:LayoutItem Caption="Field8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" OnLoad="TextboxLoad" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>  
                                                           <dx:LayoutItem Caption="Field9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" OnLoad="TextboxLoad" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>--%>

                                     <dx:LayoutGroup Caption="Audit Trail" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Added By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Added Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                <dx:LayoutItem Caption="Submitted By">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                                           <dx:LayoutItem Caption="Submitted Date">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                        
                                        </Items>
                                    </dx:LayoutGroup>


                                       <%--<dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction">
                                                   <Items>
                                    <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="608px"  KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber"  ClientInstanceName="gvRef" >
                                                               <SettingsBehavior AllowSort="false" AllowGroup="false" />    
                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                            <SettingsPager PageSize="5">
                                                            </SettingsPager>
                                                            <SettingsEditing Mode="Batch">      
                                                            </SettingsEditing>
                                                            <ClientSideEvents Init="OnInitTrans" />--%>
                                                            <%--<Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="130" VerticalScrollBarMode="Auto" />--%>
                                                        <%--    <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" Caption="DocNumber" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="RTransType" Caption="Reference TransType" ShowInCustomizationForm="True" VisibleIndex="1" ReadOnly="True"  Name="RTransType">
                                                                  
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewCommandColumn ButtonType="Image"  ShowInCustomizationForm="True" VisibleIndex="0" Width="90px" >            
                                                               <CustomButtons>
                                                                             <dx:GridViewCommandColumnCustomButton ID="ViewReferenceTransaction">
                                                               <Image IconID="functionlibrary_lookupreference_16x16"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                                    <dx:GridViewCommandColumnCustomButton ID="ViewTransaction">
                                                               <Image IconID="find_find_16x16"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                                      
                                                            </CustomButtons>
                                                                       </dx:GridViewCommandColumn>
                                                                <dx:GridViewDataTextColumn FieldName="REFDocNumber" Caption="Reference DocNumber" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="RCommandString" ShowInCustomizationForm="True" VisibleIndex="3" >
                                                            
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="CommandString" ShowInCustomizationForm="True" VisibleIndex="6"  >
                                                                                                                                
                                                                     </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                </Items>
                                    </dx:LayoutGroup>--%>
                                </Items>
                            </dx:TabbedLayoutGroup>
   
                                     <dx:LayoutGroup Caption=" Details" ColCount="2" ClientVisible="false">
                                        <Items>
                                            <dx:LayoutItem ShowCaption="False">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">

 <%-- Material Order--%>
                                                         <dx:ASPxLabel runat="server" Text=" Material Order Detail:" Font-Bold="true" ForeColor="Gray"  Font-Size="Medium" ></dx:ASPxLabel>                                       
                                                         <dx:ASPxGridView ID="ASPxGridView4" runat="server" AutoGenerateColumns="False" Width="1230px" DataSourceID ="sdsDetail"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" 
                                                     KeyFieldName="DocNumber;LineNumber">
                                                                    <SettingsBehavior AllowSort="false" AllowGroup="false" />    
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <%--<ClientSideEvents CustomButtonClick="OnCustomClick" />--%>
                                                    <SettingsPager PageSize="5" Visible="False"/> 
                                                            <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130"  /> 
                                                    <Columns>
                                                           <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                              
                                                        <dx:GridViewCommandColumn ShowDeleteButton="true"  ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="60px" ShowNewButtonInHeader="true">
                                                                                                               <CustomButtons>


                                                            <dx:GridViewCommandColumnCustomButton ID="Details0">
                                                               <Image IconID="support_info_16x16"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                        </CustomButtons>
                                                            
                                                             </dx:GridViewCommandColumn>
                                                       
                                                                <dx:GridViewDataTextColumn Caption="SAP Code" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="16" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Item Description" FieldName="Field2" Name="Field2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="250px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Packaging Type" FieldName="Field3" Name="Field3" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="18" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Mon" FieldName="Field4" Name="Field4" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="19" Width="60px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Tue" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="20" Width="60px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                               <dx:GridViewDataTextColumn Caption="Wed" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21" Width="60px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                               <dx:GridViewDataTextColumn Caption="Thu" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="22" Width="60px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Fri" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="23" Width="60px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                                 <dx:GridViewDataTextColumn Caption="Sat" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="24" Width="60px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                               <dx:GridViewDataTextColumn Caption="Sun" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="25" Width="60px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                                 <dx:GridViewDataTextColumn Caption="Total KG" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="25" Width="100px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Total Batch" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="25" Width="100px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                              
                                                              
                                                              
                                                            </Columns>
                                                        </dx:ASPxGridView>
 <%-- Material Order End --%>
                                                       

<%-- Total Qty Per date  --%>
                                                        <dx:ASPxLabel runat="server" Text="Total Qty Per date:" Font-Bold="true" ForeColor="Gray"  Font-Size="Medium"></dx:ASPxLabel>
                                                        
                                                        <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="640px" DataSourceID ="sdsDetail"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" 
                                                     KeyFieldName="DocNumber;LineNumber">
                                                                    <SettingsBehavior AllowSort="false" AllowGroup="false" />    
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <%--<ClientSideEvents CustomButtonClick="OnCustomClick" />--%>
                                                    <SettingsPager PageSize="5" Visible="False"/> 
                                                            <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130"  /> 
                                                    <Columns>
                                                           <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <%--<dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="80px">
                                                                    <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                    </PropertiesTextEdit>
                                                                </dx:GridViewDataTextColumn>--%>
                                                       <%-- <dx:GridViewCommandColumn ShowDeleteButton="true"  ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="60px" ShowNewButtonInHeader="true" >
                                                                                                               <CustomButtons>
                                                            <dx:GridViewCommandColumnCustomButton ID="Details">
                                                               <Image IconID="support_info_16x16"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                        </CustomButtons>
                                                            
                                                             </dx:GridViewCommandColumn>--%>
                                                 
                                                                <dx:GridViewDataTextColumn Caption="SKU Code" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="16" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewBandColumn Caption="Total Qty Per date:" VisibleIndex="17" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <Columns>
                                                        <dx:GridViewDataTextColumn Caption="5/3" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="50px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" >
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="5/4" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="18" Width="50px"  HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" >
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="5/5" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="19" Width="50px"  HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center">
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="5/6" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="20" Width="50px"  HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center">
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="5/7" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21" Width="50px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center">
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="5/8" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="22" Width="50px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center">
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="5/9" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="23" Width="50px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center">
                                                                </dx:GridViewDataTextColumn>
                                                                                        </Columns>
</dx:GridViewBandColumn>
                                                                <dx:GridViewDataTextColumn Caption="Weight" FieldName="Field2" Name="Field2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="24" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                    <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2" 
                                                                    KeyFieldName="ColorCode" OnInit="glItemCode_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="140px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn  FieldName="UOM" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents  CloseUp="gridLookup_CloseUp"  EndCallback="GridEnd"
                                                                        KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"
                                                                        DropDown="function(s,e){
                                                                        if(nope==false){
                                                                        nope = true;
                                                                        loader.Show();
                                                                        loader.SetText('Loading2...');
                                                                        loading = true;
                                                                        gl2.GetGridView().PerformCallback('ColorCode'+ '|' + jo + '|' + s.GetInputElement().value + '|' + step + '|' + itemc  + '|' +'code'  + '|' + 'code'  + '|' + 'code'  );
                                                                        }
                                                                        }"
                                                                       
                                                                      />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="" FieldName="Field21" Name="Field2" Visible="False" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="150px">
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="" FieldName="Field22" Name="Field2" Visible="False"  ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="150px">
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="" FieldName="Field22" Name="Field2" Visible="False"  ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="150px">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridView>
                                                        
                             <%-- Total Qty Per date End --%>

                                      <%-- Total Qty Per SKU --%>
                                                        <dx:ASPxLabel runat="server" Text="Total Qty Per SKU:" Font-Bold="true" ForeColor="Gray"  Font-Size="Medium"></dx:ASPxLabel>
                                                        
                                                          <dx:ASPxGridView ID="ASPxGridView1" runat="server" AutoGenerateColumns="False" Width="452px" DataSourceID ="sdsDetail"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" 
                                                     KeyFieldName="DocNumber;LineNumber">
                                                                    <SettingsBehavior AllowSort="false" AllowGroup="false" />    
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <%--<ClientSideEvents CustomButtonClick="OnCustomClick" />--%>
                                                    <SettingsPager PageSize="5" Visible="False"/> 
                                                            <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130"  /> 
                                                    <Columns>
                                                           <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                             
                                                        <%--<dx:GridViewCommandColumn ShowDeleteButton="true"  ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="60px" ShowNewButtonInHeader="true">
                                                                                                               <CustomButtons>


                                                            <dx:GridViewCommandColumnCustomButton ID="Details1">
                                                               <Image IconID="support_info_16x16"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                        </CustomButtons>
                                                            
                                                             </dx:GridViewCommandColumn>--%>
                                              
                                                        <dx:GridViewDataTextColumn Caption="SKU Code" FieldName="Field0" Name="Field0" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="16" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                               <dx:GridViewDataTextColumn Caption="Total Qty (per SKU)" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="16" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Weight" FieldName="Field2" Name="Field2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                               <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2" 
                                                                    KeyFieldName="ColorCode" OnInit="glItemCode_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="140px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn  FieldName="UOM" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents  CloseUp="gridLookup_CloseUp"  EndCallback="GridEnd"
                                                                        KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"
                                                                        DropDown="function(s,e){
                                                                        if(nope==false){
                                                                        nope = true;
                                                                        loader.Show();
                                                                        loader.SetText('Loading2...');
                                                                        loading = true;
                                                                        gl2.GetGridView().PerformCallback('ColorCode'+ '|' + jo + '|' + s.GetInputElement().value + '|' + step + '|' + itemc  + '|' +'code'  + '|' + 'code'  + '|' + 'code'  );
                                                                        }
                                                                        }"
                                                                       
                                                                      />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                                     </dx:GridViewDataTextColumn>
                                                         <dx:GridViewDataTextColumn Caption="" FieldName="Field21" Name="Field2" Visible="False" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="150px">
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="" FieldName="Field22" Name="Field2" Visible="False"  ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="150px">
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="" FieldName="Field22" Name="Field2" Visible="False"  ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="150px">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridView>
 <%-- Total Qty Per SKU End --%>
                                                        <%-- Total Batches--%>
                                                         <dx:ASPxLabel runat="server" Text=" Total Batches:" Font-Bold="true" ForeColor="Gray"  Font-Size="Medium"></dx:ASPxLabel>
                                            
                                                          <dx:ASPxGridView ID="ASPxGridView2" runat="server" AutoGenerateColumns="False" Width="452px" DataSourceID ="sdsDetail"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" 
                                                     KeyFieldName="DocNumber;LineNumber">
                                                                    <SettingsBehavior AllowSort="false" AllowGroup="false" />    
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <%--<ClientSideEvents CustomButtonClick="OnCustomClick" />--%>
                                                    <SettingsPager PageSize="5" Visible="False"/> 
                                                            <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130"  /> 
                                                    <Columns>
                                                           <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                              
                                                      <%--  <dx:GridViewCommandColumn ShowDeleteButton="true"  ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="60px" ShowNewButtonInHeader="true">
                                                                                                               <CustomButtons>


                                                            <dx:GridViewCommandColumnCustomButton ID="Details2">
                                                               <Image IconID="support_info_16x16"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                        </CustomButtons>
                                                            
                                                             </dx:GridViewCommandColumn>--%>
                                                       <dx:GridViewDataTextColumn Caption="SKU Code" FieldName="Field0" Name="Field0" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="16" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Total Batches (Per SKU)" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="16" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Overall Total Batches" FieldName="Field2" Name="Field2"  ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                 <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2" 
                                                                    KeyFieldName="ColorCode" OnInit="glItemCode_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="130px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn  FieldName="Batches" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents  CloseUp="gridLookup_CloseUp"  EndCallback="GridEnd"
                                                                        KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"
                                                                        DropDown="function(s,e){
                                                                        if(nope==false){
                                                                        nope = true;
                                                                        loader.Show();
                                                                        loader.SetText('Loading2...');
                                                                        loading = true;
                                                                        gl2.GetGridView().PerformCallback('ColorCode'+ '|' + jo + '|' + s.GetInputElement().value + '|' + step + '|' + itemc  + '|' +'code'  + '|' + 'code'  + '|' + 'code'  );
                                                                        }
                                                                        }"
                                                                       
                                                                      />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Overall Total Batches" FieldName="Field21" Name="Field2" Visible="False" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="150px">
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Overall Total Batches" FieldName="Field22" Name="Field2" Visible="False"  ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="150px">
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Overall Total Batches" FieldName="Field22" Name="Field2" Visible="False"  ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="150px">
                                                                </dx:GridViewDataTextColumn>
                                                               
                                                            </Columns>
                                                        </dx:ASPxGridView>
 <%-- Total Batches End --%>
                                                           <%-- Material Order Detail FG--%>
                                                         <dx:ASPxLabel runat="server" Text=" Material Order Detail FG:" Font-Bold="true" ForeColor="Gray"  Font-Size="Medium" ></dx:ASPxLabel>                                       
                                                         <dx:ASPxGridView ID="ASPxGridView3" runat="server" AutoGenerateColumns="False" Width="820px" DataSourceID ="sdsDetail"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" 
                                                     KeyFieldName="DocNumber;LineNumber">
                                                                    <SettingsBehavior AllowSort="false" AllowGroup="false" />    
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <%--<ClientSideEvents CustomButtonClick="OnCustomClick" />--%>
                                                    <SettingsPager PageSize="5" Visible="False"/> 
                                                            <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130"  /> 
                                                    <Columns>
                                                           <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                              
                                                        <dx:GridViewCommandColumn ShowDeleteButton="true"  ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="60px" ShowNewButtonInHeader="true">
                                                                                                               <CustomButtons>


                                                            <dx:GridViewCommandColumnCustomButton ID="Details3">
                                                               <Image IconID="support_info_16x16"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                        </CustomButtons>
                                                            
                                                             </dx:GridViewCommandColumn>
                                                       
                                                                <dx:GridViewDataTextColumn Caption="FG SKU Code" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="16" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Item Description" FieldName="Field2" Name="Field2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="250px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Qty" FieldName="Field3" Name="Field3" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="18" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Unit" FieldName="Field4" Name="Field4" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="19" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Order Date" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="20" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                              
                                                            </Columns>
                                                        </dx:ASPxGridView>
 <%-- Material Order Detail FG End --%>


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
        
</form>
    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
        <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.PreProductionOut+PreProductionOutDetail" SelectMethod="getdetail" UpdateMethod="UpdatePreProductionOutDetail" TypeName="Entity.PreProductionOut+PreProductionOutDetail" DeleteMethod="DeletePreProductionOutDetail" InsertMethod="AddPreProductionOutDetail">
              <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Production.PreProductionOutDetail where DocNumber is null"   OnInit = "Connection_Init">
    </asp:SqlDataSource>


        <asp:SqlDataSource ID="sdsJobOrder" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="
SELECT DISTINCT A.DocNumber,StepCode,C.ItemCode as ProductCode FROM Production.JobOrder A 
INNER JOIN Production.JOStepPlanning B 
ON A.DocNumber = B.DocNumber
INNER JOIN Production.JOProductOrder C 
ON A.DocNumber = C.DocNumber
 WHERE  ISNULL(AllocSubmittedBy,'')!='' and Status  IN ('N','W')
 and  ISNULL(AllocSubmittedDate,'')!='' and ISNULL(PreProd,0)='1'"   OnInit = "Connection_Init">
    </asp:SqlDataSource>
            <asp:SqlDataSource ID="sdsStep" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="
   select StepCode,Description,Mnemonics,EstimatedWOPrice,MinimumWOPrice,OverheadCode from masterfile.step where IsPreProductionStep='1'"   OnInit = "Connection_Init">
    </asp:SqlDataSource>
                <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.PreProductionOut+RefTransaction" >
        <SelectParameters>
             <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
</body>
</html>


