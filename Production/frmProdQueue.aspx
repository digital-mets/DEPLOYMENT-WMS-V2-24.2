<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmProdQueue.aspx.cs" Inherits="GWL.frmProdQueue" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Production Batch Queue</title>
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
        .dxeTextBoxSys input {
        }

        .pnl-content {
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
            gv1.SetHeight(400);
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
            //2021-05-26    EMC batch update part2
            if (s.cp_batch) {
                delete (s.cp_batch);//deletes cache variables' data
                //emc999
                // alert("Status : " + s.cp_batchstatus + " idx " + index);

                gv1.batchEditApi.SetCellValue(index, "Status", s.cp_batchstatus);
                gv1.batchEditApi.SetCellValue(index, "CurrentStep", s.cp_wipprocess);
                gv1.batchEditApi.SetCellValue(index, "CProgress", s.cp_progress);

                delete (s.cp_batchstatus);//deletes cache variables' data
                delete (s.cp_wipprocess);//deletes cache variables' data
                delete (s.cp_progress);//deletes cache variables' data
            }

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

            if (e.focusedColumn.fieldName === "ProductOrder") { //Check the column name
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
        var index = 0;
        function OnCustomClick(s, e) {
            var transtype0 = "";
            var docnumber0 = "";
            var commandtring0 = "";

            var batch1 = s.batchEditApi.GetCellValue(e.visibleIndex, "BatchNo");
            var status1 = s.batchEditApi.GetCellValue(e.visibleIndex, "Status");
            var sku1 = s.batchEditApi.GetCellValue(e.visibleIndex, "SKUcode");

            var recordID1 = s.batchEditApi.GetCellValue(e.visibleIndex, "RecordID");
            var process1 = s.batchEditApi.GetCellValue(e.visibleIndex, "CurrentStep");

            index = e.visibleIndex;

            //emc999
            wipSKU.SetText(sku1);
            wipBatch.SetText(batch1);
            batchid.SetText(recordID1);

            //wipprocess.SetText(process1);
            wipprocess.SetText(hstep.GetText());

            gridindex.SetText("" + index);

            chkbackflash.SetValue("false");
            chkbackflash.SetText("");

            if (e.buttonID == "wipin") {
                pcwip.SetHeaderText("WIP-IN");
                wiptype.SetText("WIPIN")

                pcwip.Show();
            }

            //if (e.buttonID == "wipfinal") {
            //    pcwip.SetHeaderText("WIP-FINAL-OUT");
            //    wiptype.SetText("WIPFINAL")
            //    pcwip.Show();
            //}


            if (e.buttonID == "tipin") {
                pcwip.SetHeaderText("TIP-IN");
                wiptype.SetText("TIPIN")

                pcwip.Show();
            }

            if (e.buttonID == "wipout") {
                pcwip.SetHeaderText("WIP-OUT");
                wiptype.SetText("WIPOUT")
                chkbackflash.SetText("BackFlush");

                pcwip.Show();

                //window.open(commandtring0 + '?entry=E&transtype=' + transtype0 + '&parameters=&iswithdetail=true&docnumber=' + docnumber0, '_blank', "", false);

                //console.log('NEWTransaction')

            }

            if (e.buttonID == "Details5") {


                //2021-05-21    EMC
                if (status1 != "START") {

                    //alert( " idx1 " + e.visibleIndex);                    
                    s.batchEditApi.SetCellValue(e.visibleIndex, "CProgress", "1/10");

                    //s.batchEditApi.SetCellValue(e.visibleIndex, "Status", "START");

                    //alert("Record ID :" + recordID1 +" ! ");


                    //cp.PerformCallback("batch|" + recordID1);
                    //emc999
                    //wip.Show();
                    pcLogin.SetHeaderText("WIP TRANS");
                    wipSKU.SetText("AAA");

                    pcLogin.Show();

                }
                else {
                    alert("Batch :" + batch1 + " already started !");
                }



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
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" ID="htitle" Text="Production Batch Queue" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
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

                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" Style="margin-left: -3px" ClientInstanceName="frmlayout">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <%--<!--#region Region Header --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number:" Name="DocNumber" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocnumber" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Year" ClientVisible="true">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtyear" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Work Week No" ClientVisible="true">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtweek" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Day No">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                        <dx:ASPxComboBox ID="hdayno" runat="server" Width="170px" ClientInstanceName="hdayno">
                                                            <Items>
                                                                <dx:ListEditItem Text="1" Value="1" Selected="true" />
                                                                <dx:ListEditItem Text="2" Value="2" />
                                                                <dx:ListEditItem Text="3" Value="3" />
                                                                <dx:ListEditItem Text="4" Value="4" />
                                                                <dx:ListEditItem Text="5" Value="5" />
                                                                <dx:ListEditItem Text="6" Value="6" />
                                                                <dx:ListEditItem Text="7" Value="7" />

                                                            </Items>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:EmptyLayoutItem></dx:EmptyLayoutItem>

                                            <dx:LayoutItem Caption="SKU Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="hskucode" ClientInstanceName="hskucode" runat="server"
                                                            DataSourceID="sdsSKU" KeyFieldName="SKUcode" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="SKUcode" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>
                                                        </dx:ASPxGridLookup>

                                                        <%-- <dx:ASPxButton ID="btnskucode" runat="server" AutoPostBack="False" Width="100px" Theme="MetropolisBlue" Text="View" UseSubmitBehavior="false">
                                                            <ClientSideEvents Click="function(s, e) { cp.PerformCallback('skucodeview') }" />
                                                        </dx:ASPxButton>--%>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="" Name="Genereatebtn">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxButton ID="Generatebtn" ClientInstanceName="CINGenerate" runat="server" Width="170px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False"
                                                            ClientVisible="true" Text="Generate" Theme="MetropolisBlue">
                                                            <ClientSideEvents Click="function(s, e) { cp.PerformCallback('skucodeview') }" />
                                                        </dx:ASPxButton>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Default Process">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="hstep" ClientInstanceName="hstep" runat="server"
                                                            DataSourceID="sdsStep" KeyFieldName="StepCode" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="StepCode" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>
                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Remarks" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRemarks" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                        </Items>
                                    </dx:LayoutGroup>


                                    <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction" ClientVisible="false">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="608px" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" ClientInstanceName="gvRef">
                                                            <SettingsBehavior AllowSort="false" AllowGroup="false" />
                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" />
                                                            <SettingsPager PageSize="15">
                                                            </SettingsPager>
                                                            <SettingsEditing Mode="Batch">
                                                            </SettingsEditing>
                                                            <ClientSideEvents Init="OnInitTrans" />
                                                            <%--<Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="130" VerticalScrollBarMode="Auto" />--%>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" Caption="DocNumber">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="RTransType" Caption="Reference TransType" ShowInCustomizationForm="True" VisibleIndex="1" ReadOnly="True" Name="RTransType">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="90px">
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
                                                                <dx:GridViewDataTextColumn FieldName="RCommandString" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="CommandString" ShowInCustomizationForm="True" VisibleIndex="6">
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

                            <dx:LayoutGroup Caption="Production Batch Queue Details" ColCount="2">
                                <Items>
                                    <dx:LayoutItem ShowCaption="False">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="747px"                                                       
                                                    DataSourceID="sdsProdQueue"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                    KeyFieldName="RecordID" >
                                                    <SettingsBehavior AllowSort="false" AllowGroup="false"  />
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick" />
                                                    <%--<ClientSideEvents CustomButtonClick="OnCustomClick" />--%>
                                                    
                                                    <SettingsPager PageSize="15"  Visible="false" Mode="ShowAllRecords" />
                                                    
                                                    <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130" />
                                                    <Columns>

                                                        <%-- <dx:GridViewDataTextColumn FieldName="RecordID" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0" >
                                                                </dx:GridViewDataTextColumn>--%>

                                                        <dx:GridViewDataTextColumn Caption="Queue No." FieldName="QueueNo2" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="80px">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>

                                        <%--                <dx:GridViewCommandColumn ShowDeleteButton="true" ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="60px" ShowNewButtonInHeader="true">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                    <Image IconID="actions_pagenext_16x16devav"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>

                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>--%>



                                                        <dx:GridViewDataTextColumn Caption="Batch No" FieldName="BatchNo" Name="BatchNo" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7">
                                                        </dx:GridViewDataTextColumn>
                                                        
                                                        <dx:GridViewDataTextColumn Caption="SKU" FieldName="SKUcode" Name="SKUcode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="6" >
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn Caption="DayNo" FieldName="DayNo" Name="DayNo" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="5" >
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn Caption="Packing type" FieldName="PackingType" Name="PackingType" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="18">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Batch Qty in Kg(Yielded)" FieldName="BatchQty" Name="BatchQty" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="19" Width="90px">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn Caption="Current Process" FieldName="CurrentStep" Name="CurrentStep" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Status" FieldName="Status" Name="Status" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="22">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Progress" FieldName="CProgress" Name="CProgress" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="23" Width="60px">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn Caption="RecordID" FieldName="RecordID" Name="RecordID" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="1" Width="100">
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewCommandColumn ShowDeleteButton="true" ButtonType="Image" Caption="WIP-IN" VisibleIndex="100" Width="60px" ShowNewButtonInHeader="true">
                                                            <CustomButtons>

                                                                <dx:GridViewCommandColumnCustomButton ID="wipin">
                                                                    <Image IconID="reports_addfooter_16x16office2013"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>

                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>

                                                        <dx:GridViewCommandColumn ShowDeleteButton="true" ButtonType="Image" Caption="WIP-OUT" VisibleIndex="101" Width="60px" ShowNewButtonInHeader="true">
                                                            <CustomButtons>

                                                                <dx:GridViewCommandColumnCustomButton ID="wipout">
                                                                    <Image IconID="data_addnewdatasource_16x16office2013"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>

                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>


                                                        <%--   <dx:GridViewCommandColumn ShowDeleteButton="true"  ButtonType="Image"  Caption="WIP-FINAL" VisibleIndex="101" Width="70px" ShowNewButtonInHeader="true">
                                                               <CustomButtons>

                                                                <dx:GridViewCommandColumnCustomButton ID="wipfinal" >
                                                                <Image IconID="data_addnewdatasource_16x16office2013"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>

                                                               </CustomButtons>                                                            
                                                               </dx:GridViewCommandColumn>--%>


                                                        <dx:GridViewCommandColumn ShowDeleteButton="true" ButtonType="Image" Caption="TIP-IN" VisibleIndex="101" Width="60px" ShowNewButtonInHeader="true">
                                                            <CustomButtons>

                                                                <dx:GridViewCommandColumnCustomButton ID="tipin">
                                                                    <Image IconID="actions_addfile_16x16office2013"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>

                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>


                                                        <%--        <dx:GridViewCommandColumn Caption="START" ButtonType="Image" ShowInCustomizationForm="True">
                                                                 <CustomButtons>
                                                                 <dx:GridViewCommandColumnCustomButton ID="AddBillofMaterials"><Image IconID="actions_search_16x16devav"></Image></dx:GridViewCommandColumnCustomButton>
                                                                 </CustomButtons>
                                                                 </dx:GridViewCommandColumn>--%>
                                                    </Columns>
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>

                                </Items>
                            </dx:LayoutGroup>
                        </Items>

                    </dx:ASPxFormLayout>
                    <dx:ASPxPanel ID="BottomPanel" runat="server" FixedPosition="WindowBottom" BackColor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                    <dx:ASPxCheckBox Style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
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

        <%--COMBATE--%>
        <dx:ASPxPopupControl ID="pcwip" runat="server" Width="320" CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcwip"
            HeaderText="Login" AllowDragging="True" PopupAnimationType="None" EnableViewState="False" AutoUpdatePosition="true">
            <ClientSideEvents PopUp="function(s, e) { ASPxClientEdit.ClearGroup('entryGroup'); Qtywip.Focus(); }" />
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <dx:ASPxPanel ID="Panel1" runat="server" DefaultButton="btOK">
                        <PanelCollection>
                            <dx:PanelContent runat="server">
                                <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout1" Width="100%" Height="100%">
                                    <Items>


                                        <dx:LayoutItem Caption="Process">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>

                                                    <dx:ASPxGridLookup ID="wipprocess" DataSourceID="sdsStep" runat="server" AutoGenerateColumns="False" ClientInstanceName="wipprocess" KeyFieldName="StepCode" Width="170px">

                                                        <GridViewProperties>
                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                            <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                        </GridViewProperties>

                                                        <Columns>
                                                            <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px">
                                                            </dx:GridViewCommandColumn>
                                                            <dx:GridViewDataTextColumn FieldName="StepCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                <Settings AutoFilterCondition="Contains" />
                                                            </dx:GridViewDataTextColumn>


                                                        </Columns>
                                                    </dx:ASPxGridLookup>


                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>



                                        <dx:LayoutItem Caption="Qty">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="Qtywip" runat="server" Width="100%" ClientInstanceName="Qtywip">
                                                        <ValidationSettings EnableCustomValidation="True" ValidationGroup="entryGroup" SetFocusOnError="True"
                                                            ErrorDisplayMode="Text" ErrorTextPosition="Bottom" CausesValidation="True">
                                                            <RequiredField ErrorText="required" IsRequired="True" />
                                                            <RegularExpression ErrorText="required" />
                                                            <ErrorFrameStyle Font-Size="10px">
                                                                <ErrorTextPaddings PaddingLeft="0px" />
                                                            </ErrorFrameStyle>
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>


                                        <dx:LayoutItem Caption="SKU">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="wipSKU" runat="server" Width="100%" ClientInstanceName="wipSKU">

                                                        <%--                                                    <ValidationSettings EnableCustomValidation="True" ValidationGroup="entryGroup" SetFocusOnError="True"
                                                        ErrorDisplayMode="Text" ErrorTextPosition="Bottom" CausesValidation="True">
                                                        <RequiredField ErrorText="required" IsRequired="True" />
                                                        <RegularExpression ErrorText="required" />
                                                        <ErrorFrameStyle Font-Size="10px">
                                                            <ErrorTextPaddings PaddingLeft="0px" />
                                                        </ErrorFrameStyle>
                                                    </ValidationSettings>--%>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="Batch #">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="wipBatch" runat="server" Width="100%" ClientInstanceName="wipBatch">

                                                        <%--                                                    <ValidationSettings EnableCustomValidation="True" ValidationGroup="entryGroup" SetFocusOnError="True"
                                                        ErrorDisplayMode="Text" ErrorTextPosition="Bottom" CausesValidation="True">
                                                        <RequiredField ErrorText="required" IsRequired="True" />
                                                        <RegularExpression ErrorText="required" />
                                                        <ErrorFrameStyle Font-Size="10px">
                                                            <ErrorTextPaddings PaddingLeft="0px" />
                                                        </ErrorFrameStyle>
                                                    </ValidationSettings>--%>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>




                                        <dx:LayoutItem Caption="">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxCheckBox ID="chkbackflash" runat="server" Text="BackFlush" ClientInstanceName="chkbackflash">
                                                    </dx:ASPxCheckBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="RecordID" ClientVisible="false">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="batchid" runat="server" Width="100%" ClientInstanceName="batchid">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="GridIndex" ClientVisible="false">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="gridindex" runat="server" Width="100%" ClientInstanceName="gridindex">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="TransType" ClientVisible="false">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="wiptype" runat="server" Width="100%" ClientInstanceName="wiptype">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="User ID" ClientVisible="false">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="wipuserid" runat="server" Width="100%" ClientInstanceName="wipuserid">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem ShowCaption="False" Paddings-PaddingTop="19">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxButton ID="btOK" runat="server" Text="Save" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                        <ClientSideEvents Click="function(s, e) { if(ASPxClientEdit.ValidateGroup('entryGroup')){ cp.PerformCallback('batch|0' ); pcwip.Hide(); } }" />
                                                    </dx:ASPxButton>

                                                    <dx:ASPxButton ID="btCancel" runat="server" Text="Cancel" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                        <ClientSideEvents Click="function(s, e) { pcwip.Hide(); }" />
                                                    </dx:ASPxButton>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:ASPxFormLayout>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>

                </dx:PopupControlContentControl>
            </ContentCollection>
            <ContentStyle>
                <Paddings PaddingBottom="5px" />
            </ContentStyle>
        </dx:ASPxPopupControl>
        <%--COMBATE--%>

        <%--EDWIN--%>

        <dx:ASPxPopupControl ID="pcwip2" runat="server" ClientInstanceName="pcwip2"
            CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
            HeaderText="WIP" AllowDragging="True" PopupAnimationType="None" EnableViewState="False">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <dx:ASPxPanel ID="ASPxPanel7" runat="server">
                        <PanelCollection>
                            <dx:PanelContent runat="server">
                                <table>
                                    <tr>
                                        <td />
                                        <dx:ASPxLabel runat="server" Text="Qty: "></dx:ASPxLabel>
                                        <td />
                                        <dx:ASPxTextBox ID="wipqty" ClientInstanceName="wipqty" runat="server" Width="170px">
                                        </dx:ASPxTextBox>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;
                                        </td>
                                    </tr>


                                    <tr>
                                        <td />
                                        <td />
                                        <dx:ASPxButton ID="wipqtybtn" runat="server" Text="Submit2" AutoPostBack="False">
                                            <ClientSideEvents Click="function(s, e) {
                                                                cp.PerformCallback('RSetWeightSub');
                                                                pcwip.Hide();
                                                                }" />
                                        </dx:ASPxButton>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <%--EDWIN--%>

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
                            <td>
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                                    <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                </dx:ASPxButton>
                                <td>
                                    <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
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


    <asp:SqlDataSource ID="sdsProdQueue" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="




"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsStep" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="

  "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsSKU" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="

SELECT SKUcode
FROM Production.BatchQueue
GROUP BY SKUcode


  "
        OnInit="Connection_Init"></asp:SqlDataSource>



</body>
</html>


