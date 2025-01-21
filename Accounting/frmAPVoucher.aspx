<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmAPVoucher.aspx.cs" Inherits="GWL.frmAPVoucher" %>

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
    <title>AP Voucher</title>
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
            text-transform:uppercase;
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
        var check = true;

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
            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            var cntdetails = indicies.length;

            for (var i = 0; i < indicies.length; i++) {
                if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                    gv1.batchEditApi.ValidateRow(indicies[i]);
                    gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("DocNumber").index);
                }
                else {
                    var key = gv1.GetRowKey(indicies[i]);
                    if (gv1.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indicies[i]);
                    else {
                        gv1.batchEditApi.ValidateRow(indicies[i]);
                        gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("DocNumber").index);
                    }
                }
            }

            gv1.batchEditApi.EndEdit();

            var btnmode = btn.GetText(); //gets text of button
            if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
                //Sends request to server side
                if (btnmode == "Add") {
                    if (cntdetails != 0) {
                        cp.PerformCallback("Add");
                    }
                    else {
                        cp.PerformCallback("ZeroDetail");
                    }
                }
                else if (btnmode == "Update") {
                    if (cntdetails != 0) {
                        cp.PerformCallback("Update");
                    }
                    else {
                        cp.PerformCallback("ZeroDetail");
                    }
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

                if (s.cp_forceclose) {
                    delete (s.cp_forceclose);
                    window.close();
                }
            }

            if (s.cp_close) {
                gv1.CancelEdit();
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

            if (s.cp_suppjs) {
                delete (s.cp_suppjs);
                gv1.CancelEdit();
            }
        }

        var itemc; //variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var editorobj;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ATCcode"); //needed var for all lookups; this is where the lookups vary for
            index = e.visibleIndex;
            if (e.focusedColumn.fieldName === "ATCcode") {

                if (s.batchEditApi.GetCellValue(e.visibleIndex, "EWT") == false) {
                    e.cancel = true;
                }
                else {
                    gl2.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                }
            }
            editorobj = e;

            if (e.focusedColumn.fieldName === "Transtype" || e.focusedColumn.fieldName === "TransDocNumber" ||
                e.focusedColumn.fieldName === "TransDate" || e.focusedColumn.fieldName === "TransAPAmount" ||
                e.focusedColumn.fieldName === "TransVatAmount" || e.focusedColumn.fieldName === "TransEWTAmount") {
                e.cancel = true;
            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            if (currentColumn.fieldName === "ATCcode") {
                cellInfo.value = gl2.GetValue();
                cellInfo.text = gl2.GetText().toUpperCase();
            }
        }

        var val = "";
        var temp = "";
        var valchange = false;
        function GridEnd(s, e) {
            //console.log('gridend');
            if (valchange) {
                val = s.GetGridView().cp_codes;
                temp = val.split(';');
                valchange = false;
                var column = gv1.GetColumn(6);
                ProcessCells2(0, index, column, gv1);
                gv1.batchEditApi.EndEdit();
                autocalculate();
            }

        }

        function ProcessCells2(selectedIndex, focused, column, s) {//Auto calculate qty function :D
            if (val == null) {
                val = ";";
                temp = val.split(';');
            }
            if (temp[0] == null) {
                temp[0] = 0;
            }
            if (selectedIndex == 0) {
                s.batchEditApi.SetCellValue(focused, "atcrate", temp[0]);
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
            if (keyCode !== 9) return;
            var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
            if (gv1.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            }
        }

        function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode == 13)
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
                //if (column.fieldName == "TransAPAmount") {
                //    var cellValidationInfo = e.validationInfo[column.index];
                //    if (!cellValidationInfo) continue;
                //    var value = cellValidationInfo.value;
                //    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                //        cellValidationInfo.isValid = false;
                //        cellValidationInfo.errorText = column.fieldName + " is required";
                //        isValid = false;
                //    }
                //}
                if (column.fieldName == "EWT") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (ASPxClientUtils.Trim(value) == true) {
                        chckd = true;
                    }
                }
                if (column.fieldName == "ATCcode") {
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

        function OnCustomClick(s, e) {
            if (e.buttonID == "Details") {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode);
            }

            if (e.buttonID == "Delete") {
                gv1.DeleteRow(e.visibleIndex);
                autocalculate();
            }
        }

        Number.prototype.format = function (n, x) {
            var re = '(\\d)(?=(\\d{' + (x || 3) + '})+' + (n > 0 ? '\\.' : '$') + ')';
            return this.toFixed(Math.max(0, ~~n)).replace(new RegExp(re, 'g'), '$1,');
        };

        function autocalculate(s, e) {
            var amount = 0.00;
            var vatamount = 0.00;
            //var atcrate = 0.00;
            var ewtamount = 0.00;
            var totalamount = 0.00;
            var totalvatamount = 0.00;
            var totalewtamount = 0.00;

            //New Rows
            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < indicies.length; i++) {
                if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                    amount = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "TransAPAmount").replace(/,/g, ''));
                    vatamount = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "TransVatAmount").replace(/,/g, ''));
                    ewtamount = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "TransEWTAmount").replace(/,/g, ''));

                    totalamount += amount;
                    totalvatamount += vatamount;
                    totalewtamount += ewtamount;

                    console.log(totalamount);
                }
                else { //Existing Rows
                    var key = gv1.GetRowKey(indicies[i]);
                    if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        //console.log("deleted row " + indicies[i]);
                    else {
                        amount = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "TransAPAmount"));
                        vatamount = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "TransVatAmount"));
                        ewtamount = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "TransEWTAmount"));

                        totalamount += amount;
                        totalvatamount += vatamount;
                        totalewtamount += ewtamount;

                        // console.log(totalamount);

                        //if (gv1.batchEditApi.GetCellValue(indicies[i], "EWT") == true) {
                        //        atcrate = gv1.batchEditApi.GetCellValue(indicies[i], "atcrate");
                        //        totalewtamount += amount * atcrate;
                        //        //console.log('am:'+amount+'atc:'+atcrate);
                        //} 
                    }
                }
            }
            //var a = ;
            totalamount = (totalamount + totalvatamount) - totalewtamount;
            console.log(totalamount);
            TotalVAT.SetText(totalvatamount.format(2));
            TotalAP.SetText(totalamount.format(2));
            TotalEWT.SetText(totalewtamount.format(2));

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
            gvJournal.SetWidth(width - 120);
        }

        function OnCancelClick(s, e) {
            gv1.CancelEdit();
            autocalculate();
        }

        var arrayGrid = new Array();
        var arrayGrid2 = new Array();
        var arrayGL = new Array();
        var arrayGL2 = new Array();
        var OnConf = false;
        var glText;
        var ValueChanged = false;
        var deleting = false;
        //Function Autobind to GridEnd
        function isInArray(value, array) {
            return array.indexOf(value) > -1;
        }

        function DeletePreviousRows(s, e) {

            setTimeout(function () {

                var iGrid = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < iGrid.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(iGrid[i])) {
                        gv1.DeleteRow(iGrid[i]);
                    }
                    else {
                        var key = gv1.GetRowKey(iGrid[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) {
                            gv1.DeleteRow(iGrid[i]);
                        }
                        else {
                            gv1.DeleteRow(iGrid[i]);
                        }
                    }
                }

            }, 2000);

        }

        function OnGetSelectedFieldValues(selectedValues) {
            //if (selectedValues.length == 0) return;           


            arrayGL.push(glTranslook.GetText().split(';'));
            checkGrid();
            var item;
            var checkitem;
            for (i = 0; i < selectedValues.length; i++) {
                var s = "";
                for (j = 0; j < selectedValues[i].length; j++) {
                    s = s + selectedValues[i][j] + ";";
                }
                item = s.split(';');
                checkitem = item[0] + '-' + item[1];
                if (isInArray(checkitem, arrayGrid)) {
                    continue;
                }
                gv1.AddNewRow();
                getCol(gv1, editorobj, item);
            }
            //checkGrid();
            loader.Hide();
            arrayGrid = [];
            arrayGL = [];
            autocalculate();
        }

        function checkGrid() {
            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            var Keyfield;
            for (var i = 0; i < indicies.length; i++) {
                if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                    Keyfield = gv1.batchEditApi.GetCellValue(indicies[i], "TransDocNumber") + ':' + gv1.batchEditApi.GetCellValue(indicies[i], "TransType");
                    arrayGrid.push(Keyfield);
                    gv1.batchEditApi.ValidateRow(indicies[i]);
                    if (!isInArray(Keyfield, arrayGL[0]))
                        gv1.DeleteRow(indicies[i]);
                }
                else {
                    var key = gv1.GetRowKey(indicies[i]);
                    if (gv1.batchEditApi.IsDeletedRow(key))
                        var ss = "";
                    else {
                        Keyfield = gv1.batchEditApi.GetCellValue(indicies[i], "TransDocNumber") + ':' + gv1.batchEditApi.GetCellValue(indicies[i], "TransType");
                        arrayGrid.push(Keyfield);
                        gv1.batchEditApi.ValidateRow(indicies[i]);
                        if (!isInArray(Keyfield, arrayGL[0]))
                            gv1.DeleteRow(indicies[i]);
                    }
                }
            }
        }

        function getCol(ss, ee, item) {
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = gv1.GetColumn(i);
                if (column.visible == false || column.fieldName == undefined)
                    continue;
                Bindgrid(item, ee, column, gv1);
            }
        }

        function Bindgrid(item, e, column, s) {//Clone function :D
            if (column.fieldName == "Transtype") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[8]);
            }
            if (column.fieldName == "TransDocNumber") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[0]);
            }
            if (column.fieldName == "TransDate") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, new Date(item[1]));
            }
            if (column.fieldName == "TransAPAmount") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[4]);
            }
            if (column.fieldName == "TransVatAmount") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[5]);
            }
            if (column.fieldName == "TransEWTAmount") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[6]);
            }
            if (column.fieldName == "Currency") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[7]);
            }
        }

        function OnCustomClick(s, e) {

            if (e.buttonID == "Delete") {
                deleting = true;
                loader.Show();
                loader.SetText('Deleting');
                //console.log(key);
                try {
                    glTranslook.GetGridView().UnselectRowsByKey(gv1.batchEditApi.GetCellValue(e.visibleIndex, "TransDocNumber"));
                    if (gv1.batchEditApi.GetCellValue(e.visibleIndex, "TransDocNumber") == null) {
                        loader.Hide();
                    }
                    gv1.DeleteRow(e.visibleIndex);
                }
                catch (err) {
                    gv1.DeleteRow(e.visibleIndex);
                }
                autocalculate();
            }
        }

        function Clear() {
            glTranslook.GetGridView().UnselectAllRowsOnPage();
        }

        function CloseGridLookup() {
            OnConf = true;
            glTranslook.ConfirmCurrentSelection();
            glTranslook.HideDropDown();
            //console.log(glTranslook.GetText() + ' ' + glText);
            if (glTranslook.GetText() == glText) {
                ValueChanged = true;
                //DeletePreviousRows();
            }
            if (ValueChanged == true) {
                loader.Show();
                loader.SetText('Loading...');
                glTranslook.GetGridView().GetSelectedFieldValues('DocNumber;DocDate;SubmittedBy;Supplier/Broker;APAmount;VatAmount;EWTAmount;Currency;TransType', OnGetSelectedFieldValues);
                ValueChanged = false;
                OnConf = false;
            }
        }

        function OnCancelClick(s, e) {
            var Textcv = "";
            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            gv1.CancelEdit();
            var Keyfield;
            for (var i = 0; i < indicies.length; i++) {
                if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                    var a = "";
                }
                else {
                    var key = gv1.GetRowKey(indicies[i]);
                    if (gv1.batchEditApi.IsDeletedRow(key))
                        var ss = "";
                    else {
                        Textcv += gv1.batchEditApi.GetCellValue(indicies[i], "TransDocNumber") + ':' + gv1.batchEditApi.GetCellValue(indicies[i], "TransType") + ";";
                    }
                }
            }
            glTranslook.SetText(Textcv);
            autocalculate();
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
                                <dx:ASPxLabel runat="server" Text="AP Voucher" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
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
            <ClientSideEvents EndCallback="gridView_EndCallback" Init="autocalculate"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" style="margin-left: -3px" ClientInstanceName="frmlayout">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                          <%--<!--#region Region Header --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="Header" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocNumber" runat="server" AutoCompleteType="Disabled" ReadOnly="true" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="DocDate" runat="server" OnLoad="Date_Load" Width="170px">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Supplier Code" Name="Supplier">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvSupplier" runat="server" AutoGenerateColumns="False" DataSourceID="Masterfilebiz" KeyFieldName="SupplierCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function(){
                                                                cp.PerformCallback('Supp');
                                                                gv1.CancelEdit();}"/>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns> 
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Due Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="DueDate" runat="server" OnLoad="Date_Load" Width="170px">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Supplier Name">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="SupplierName" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
<%--                                            <dx:LayoutItem Caption="Broker Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="BrokerCode" runat="server" AutoGenerateColumns="True" DataSourceID="Masterfilebiz" KeyFieldName="SupplierCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function(){cp.PerformCallback('Broker');}"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Broker Name">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="BrokerName" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Total AP Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="TotalAP" runat="server" Width="170px" ClientInstanceName="TotalAP" ReadOnly="true"  DisplayFormatString="{0:N}">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Invoice Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="InvoiceDate" runat="server" Width="170px" OnLoad="Date_Load">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total VAT Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="TotalVAT" runat="server" Width="170px" ClientInstanceName="TotalVAT" ReadOnly="true"  DisplayFormatString="{0:N}">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Invoice Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtInvoice" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                             <%--<ClientSideEvents Validation="OnValidation" />--%>
                                                            <%--<ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <ErrorImage ToolTip="Invoice Number is required">
                                                                </ErrorImage>
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>--%>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total EWT Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="TotalEWT" runat="server" ClientInstanceName="TotalEWT" ReadOnly="True" Width="170px"  DisplayFormatString="{0:N}">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Remarks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxMemo ID="Remarks" runat="server" Height="150px" Width="500px" OnLoad ="Memo_Load">
                                                        </dx:ASPxMemo>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:EmptyLayoutItem>
                                            </dx:EmptyLayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Journal Entries">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvJournal" runat="server" AutoGenerateColumns="False" Width="850px" ClientInstanceName="gvJournal"  KeyFieldName="RTransType;TransType"  >
                                                            <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                            <SettingsPager Mode="ShowAllRecords" />  
                                                            <SettingsEditing Mode="Batch"/>
                                                            <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130"  /> 
                                                            <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                            <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="AccountCode" Name="jAccountCode" ShowInCustomizationForm="True" VisibleIndex="0" Width ="120px" Caption="Account Code" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="AccountDescription" Name="jAccountDescription" ShowInCustomizationForm="True" VisibleIndex="1" Width ="150px" Caption="Account Description" >
                                                                </dx:GridViewDataTextColumn>
																<dx:GridViewDataTextColumn FieldName="SubsidiaryCode" Name="jSubsidiaryCode" ShowInCustomizationForm="True" VisibleIndex="2" Width ="120px" Caption="Subsidiary Code" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="SubsidiaryDescription" Name="jSubsidiaryDescription" ShowInCustomizationForm="True" VisibleIndex="3" Width ="150px" Caption="Subsidiary Description" >
                                                                </dx:GridViewDataTextColumn>																
																<dx:GridViewDataTextColumn FieldName="ProfitCenter" Name="jProfitCenter" ShowInCustomizationForm="True" VisibleIndex="4" Width ="120px" Caption="Profit Center" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="CostCenter" Name="jCostCenter" ShowInCustomizationForm="True" VisibleIndex="5" Width ="120px" Caption="Cost Center" >
                                                                </dx:GridViewDataTextColumn>
																<dx:GridViewDataTextColumn FieldName="Debit" Name="jDebit" ShowInCustomizationForm="True" VisibleIndex="6" Width ="120px" Caption="Debit  Amount" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Credit" Name="jCredit" ShowInCustomizationForm="True" VisibleIndex="7" Width ="120px" Caption="Credit Amount" >
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
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
                                                        <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Posted By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPostedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Posted Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPostedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>   
                                </Items>
                            </dx:TabbedLayoutGroup>

                            <%-- <!--#endregion --> --%>
                            
                          <%--<!--#region Region Details --> --%>
                            <dx:LayoutGroup Caption="Lines" Width="1px">
                                <Items>
                                    <dx:LayoutItem Caption="Reference Number">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridLookup ID="glInvoice" ClientInstanceName="glTranslook" runat="server" AutoGenerateColumns="False" DataSourceID="refnum"
                                                    KeyFieldName="DocNumber;TransType" OnLoad="LookupLoad" TextFormatString="{0}:{8}" SelectionMode="Multiple" Width="800px" OnInit="glInvoice_Init">
                                                    <ClientSideEvents ValueChanged="function(s,e){ if(deleting){deleting = false; loader.Hide();} glText = glTranslook.GetText();  if(!OnConf) return; ValueChanged=true; CloseGridLookup(); }"
                                                        DropDown="function(){
                                                                    glTranslook.GetGridView().PerformCallback();
                                                                }"/>
                                                    <%--Validation="OnValidation"
                                                    <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                        <RequiredField IsRequired="True"/>
                                                    </ValidationSettings>
                                                    <InvalidStyle BackColor="Pink">
                                                    </InvalidStyle>--%>
                                                    <GridViewProperties>
                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="true" AllowSort="true"/>
                                                        <Settings ShowFilterRow="True" ShowStatusBar="Visible"></Settings>
                                                        <Templates>
                                                            <StatusBar>
                                                                <table class="OptionsTable" style="float: right">
                                                                    <tr>
                                                                        <td>
                                                                            <dx:ASPxButton ID="Confirm" runat="server" AutoPostBack="false" Text="Confirm" ClientSideEvents-Click="CloseGridLookup" Width="150px"/>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxButton ID="Clear" runat="server" AutoPostBack="false" Text="Clear" ClientSideEvents-Click="Clear" Width="150px"/>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </StatusBar>
                                                        </Templates>
                                                    </GridViewProperties>
                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                        <Templates>
                                                            <StatusBar>
                                                                    <table class="OptionsTable" style="float: right">
                                                                        <tr>
                                                                            <td>
                                                                                <dx:ASPxButton ID="Close" runat="server" AutoPostBack="false" Text="Generate Detail" ClientSideEvents-Click="CloseGridLookup" Width="150px"/>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxButton ID="Clear" runat="server" AutoPostBack="false" Text="Clear" ClientSideEvents-Click="Clear" Width="150px"/>
                                                                            </td>
                                                                        </tr>
                                                                    </table>                                                                 
                                                            </StatusBar>
                                                        </Templates>
                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"></SettingsBehavior>
                                                        <%--<SettingsPager PageSize="5"></SettingsPager>--%>
                                                        <Settings ShowFilterRow="True" ShowStatusBar="Visible" UseFixedTableLayout="True"></Settings>
                                                    </GridViewProperties>
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ShowSelectCheckbox="True" Width="60px">
                                                            </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="true" Width="100px">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn FieldName="DocDate" ShowInCustomizationForm="True" VisibleIndex="3" Width="100px" ReadOnly ="true">
                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                            <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                            </PropertiesDateEdit>
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SubmittedBy" ReadOnly="true" Width="100px">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Supplier/Broker" ReadOnly="true" Width="100px">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="APAmount" ReadOnly="True" ShowInCustomizationForm="True" Width="150px">
                                                            <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="VatAmount" ReadOnly="True" ShowInCustomizationForm="True" Width="150px">
                                                            <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="EWTAmount" ReadOnly="True" ShowInCustomizationForm="True" Width="150px">
                                                            <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Currency" ReadOnly="true" Width="100px">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransType" ReadOnly="true" Width="100px">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ReferenceNumber" ReadOnly="true" Width="200px">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                </dx:ASPxGridLookup>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="" ShowCaption="False">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="850"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" OnInit="gv1_Init" SettingsBehavior-AllowSort="false"
                                                    OnCustomButtonInitialize="gv1_CustomButtonInitialize">
                                                     <ClientSideEvents Init="OnInitTrans" />
<SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Width="0px"
                                                            VisibleIndex="0">
                                                           
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="80px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="30px">
                                                        <%--<CustomButtons>
                                                                    <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                        <Image IconID="actions_cancel_16x16"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                    </CustomButtons>--%>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Transtype" VisibleIndex="3" ReadOnly="true">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="Transtype" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                     ClientInstanceName="gl" Width="80px" OnLoad="gvLookupLoad" ClientEnabled="false"
                                                                    >
                                                                    <ClientSideEvents EndCallback="GridEnd" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransDocNumber" VisibleIndex="4" ReadOnly="true" Width="130px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn FieldName="TransDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="TransAPAmount" VisibleIndex="6" Width="130px">
                                                        <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" NumberFormat="Custom" NumberType="Float" DisplayFormatString="{0:N}"
                                                            ><SpinButtons ShowIncrementButtons="False"></SpinButtons></PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="TransVatAmount" ShowInCustomizationForm="True" VisibleIndex="7" Width="130px" ReadOnly="true">
                                                        <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" NumberFormat="Custom" NumberType="Float" DisplayFormatString="{0:N}"
                                                            ><SpinButtons ShowIncrementButtons="False"></SpinButtons></PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="TransEWTAmount" ShowInCustomizationForm="True" VisibleIndex="8" Width="130px" ReadOnly="true">
                                                        <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" NumberFormat="Custom" NumberType="Float" DisplayFormatString="{0:N}"
                                                            ><SpinButtons ShowIncrementButtons="False"></SpinButtons></PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <%--<dx:GridViewDataCheckColumn FieldName="EWT" ShowInCustomizationForm="True" VisibleIndex="8">
                                                            <PropertiesCheckEdit>
                                                            <ClientSideEvents CheckedChanged="function(s,e){gv1.batchEditApi.EndEdit();
                                                                if(s.GetChecked() == false){
                                                                gv1.batchEditApi.SetCellValue(index, 'ATCcode', '');
                                                                gv1.batchEditApi.SetCellValue(index, 'atcrate', '0');
                                                                }
                                                                autocalculate();
                                                                }"/>
                                                            </PropertiesCheckEdit>
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ATCcode" ShowInCustomizationForm="True" VisibleIndex="9">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glATCcode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="MasterfileATC" KeyFieldName="ATCCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad"
                                                                     >
                                                                    <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="OnClick">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ATCCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Rate" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="lookup" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  ValueChanged="function(s,e){
                                                                        if(itemc!=gl2.GetValue()){
                                                                        console.log(gl2.GetValue());
                                                                         gl.GetGridView().PerformCallback('ATCCode' + '|' + gl2.GetValue());
                                                                         e.processOnServer = false;
                                                                         valchange = true;
                                                                            }
                                                                        }"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="atcrate" VisibleIndex="10" Width="0px">
                                                            <PropertiesTextEdit ClientInstanceName="txtatcrate"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>--%>
                                                        <dx:GridViewDataTextColumn FieldName="Currency"  Caption="Currency" Name="Currency" ShowInCustomizationForm="True" VisibleIndex="10" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1"  Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="11" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Caption="Field2"  Name="Field2" ShowInCustomizationForm="True" VisibleIndex="12" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Caption="Field3"  Name="Field3" ShowInCustomizationForm="True" VisibleIndex="13" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Caption="Field4"  Name="Field4" ShowInCustomizationForm="True" VisibleIndex="14" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Caption="Field5"  Name="Field5" ShowInCustomizationForm="True" VisibleIndex="15" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Caption="Field6"  Name="Field6" ShowInCustomizationForm="True" VisibleIndex="16" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Caption="Field7"  Name="Field7" ShowInCustomizationForm="True" VisibleIndex="17" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8"  Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="18" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9"  Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="19" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                    <SettingsPager Mode="ShowAllRecords"/> 
                                                    <SettingsCommandButton>
                                                        <NewButton>
                                                        <Image IconID="actions_addfile_16x16"></Image>
                                                        </NewButton>
                                                        <EditButton>
                                                        <Image IconID="actions_addfile_16x16"></Image>
                                                        </EditButton>
                                                        <%--<DeleteButton>
                                                        <Image IconID="actions_cancel_16x16"></Image>
                                                        </DeleteButton>--%>
                                                    </SettingsCommandButton>
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing"/>
                                                            <SettingsEditing Mode="Batch" />
                                                </dx:ASPxGridView>
                                                <dx:ASPxButton style="margin-left: 1125px;" ID="btnCancel" runat="server" Text="Cancel Changes" ClientInstanceName="btnCancel" CausesValidation="false" AutoPostBack="false" UseSubmitBehavior="false">
                                                    <ClientSideEvents Click="OnCancelClick" />
                                                </dx:ASPxButton>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                            <%-- <!--#endregion --> --%>
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
        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Loading..." Modal="true"
            ClientInstanceName="loader" ContainerElementID="gv1">
             <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
</form>
    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="PO" runat="server" DataObjectTypeName="Entity.PurchaseOrder" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.PurchaseOrder" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="" Name="DocNumber" SessionField="DocNumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.APVoucher+APVoucherDetail" SelectMethod="getdetail" UpdateMethod="UpdateAPVoucherDetail" TypeName="Entity.APVoucher+APVoucherDetail" DeleteMethod="DeleteAPVoucherDetail" InsertMethod="AddAPVoucherDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.APVoucher+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT SupplierCode, Name FROM Masterfile.[BPSupplierInfo]" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="refnum" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from(
	select a.DocNumber,DocDate,SubmittedBy,SupplierCode as 'Supplier/Broker',TotalAmount as APAmount,
    SUM(((isnull(UnitCost,0)*ISNULL(ExchangeRate,0))*isnull(ReceivedQty,0))*ISNULL(vatrate,0)) as VatAmount,
    SUM(((isnull(UnitCost,0)*ISNULL(ExchangeRate,0))*isnull(ReceivedQty,0))*ISNULL(ATCRate,0)) as EWTAmount,
    Currency,'PRCRCR' as TransType, A.ReferenceNumber 
    from Procurement.ReceivingReport a
    inner join Procurement.ReceivingReportDetailPO b on a.DocNumber = b.DocNumber
	where isnull(SubmittedBy,'')!='' and isnull(costingsubmittedby,'')!='' and ISNULL(Apvnumber,'') = ''
	and ISNULL(supplierCode,'')!='' and ISNULL(IsAsset,0)=0
	group by a.DocNumber,DocDate,SubmittedBy,SupplierCode,TotalAmount,Currency, A.ReferenceNumber 
	union all
	select a.DocNumber,DocDate,SubmittedBy,Broker,TotalFreight as APAmount,
    0 as VatAmount,
    0 as EWTAmount,
    Currency,'PRCRCR-B' as TransType, A.ReferenceNumber
    from Procurement.ReceivingReport a
    inner join Procurement.ReceivingReportDetailPO b on a.DocNumber = b.DocNumber
	where isnull(SubmittedBy,'')!='' and isnull(costingsubmittedby,'')!='' and ISNULL(BrokerAPVNumber,'') = ''
	and ISNULL(Broker,'')!='' and ISNULL(IsAsset,0)=0
	group by a.DocNumber,DocDate,SubmittedBy,Broker,TotalAmount,Currency,TotalFreight, A.ReferenceNumber 
	union all
	select a.DocNumber,DocDate,SubmittedBy,SupplierCode as 'Supplier/Broker',TotalAmount as APAmount,
    SUM(((isnull(UnitCost,0)*ISNULL(ExchangeRate,0))*isnull(ReceivedQty,0))*ISNULL(vatrate,0)) as VatAmount,
    SUM(((isnull(UnitCost,0)*ISNULL(ExchangeRate,0))*isnull(ReceivedQty,0))*ISNULL(ATCRate,0)) as EWTAmount,
    Currency,'ACTAQT' as TransType, A.ReferenceNumber
    from Procurement.ReceivingReport a
    inner join Procurement.ReceivingReportDetailPO b on a.DocNumber = b.DocNumber
	where isnull(SubmittedBy,'')!='' and isnull(costingsubmittedby,'')!='' and ISNULL(Apvnumber,'') = ''
	and ISNULL(supplierCode,'')!=''  and ISNULL(IsAsset,0)=1
	group by a.DocNumber,DocDate,SubmittedBy,SupplierCode,TotalAmount,Currency, A.ReferenceNumber 
	union all
	select DocNumber,DocDate,SubmittedBy,PayableTo AS SupplierCode,ISNULL(TotalGrossVatable,0) + ISNULL(TotalGrossNonVatable,0) as TotalAmountDue,TotalVatAmount,TotalWitholdingTax,'PHP',
	'ACTEXP' as TransType, '' AS ReferenceNumber
	from Accounting.ExpenseProcessing
    where isnull(SubmittedBy,'')!=''
    union all
    select DocNumber,DocDate,SubmittedBy,SupplierCode,TotalAmount,0 TotalVatAmount,0 TotalWitholdingTax,'PHP' as Currency,
    'PRPRT' as TransType, '' AS ReferenceNumber from Procurement.PurchaseReturn
    where isnull(SubmittedBy,'')!='' and ISNULL(Apvnumber,'') = ''
	and ISNULL(supplierCode,'')!='' 
	UNION ALL
	select a.DocNumber,DocDate,SubmittedBy,SupplierCode as 'Supplier/Broker',TotalAmount as APAmount,
    SUM(((isnull(UnitCost,0)*ISNULL(ExchangeRate,0))*isnull(ReceivedQty,0))*ISNULL(vatrate,0)) as VatAmount,
    SUM(((isnull(UnitCost,0)*ISNULL(ExchangeRate,0))*isnull(ReceivedQty,0))*ISNULL(ATCRate,0)) as EWTAmount,
    Currency,'PRCRCRNI' as TransType, A.ReferenceNumber 
    from Procurement.ReceivingReportNonInv a
    inner join Procurement.ReceivingReportNonInvDetailPO b on a.DocNumber = b.DocNumber
	where isnull(SubmittedBy,'')!='' and isnull(costingsubmittedby,'')!='' and ISNULL(Apvnumber,'') = ''
	and ISNULL(supplierCode,'')!='' and ISNULL(IsAsset,0)=0
	group by a.DocNumber,DocDate,SubmittedBy,SupplierCode,TotalAmount,Currency, A.ReferenceNumber 
    )t
    order by DocDate desc,DocNumber asc,TransType" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="refnum2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from(
	select a.DocNumber,DocDate,SubmittedBy,SupplierCode as 'Supplier/Broker',TotalAmount as APAmount,
    SUM(((isnull(UnitCost,0)*ISNULL(ExchangeRate,0))*isnull(ReceivedQty,0))*ISNULL(vatrate,0)) as VatAmount,
    SUM(((isnull(UnitCost,0)*ISNULL(ExchangeRate,0))*isnull(ReceivedQty,0))*ISNULL(ATCRate,0)) as EWTAmount,
    Currency,'PRCRCR' as TransType, A.ReferenceNumber 
    from Procurement.ReceivingReport a
    inner join Procurement.ReceivingReportDetailPO b on a.DocNumber = b.DocNumber
	where isnull(SubmittedBy,'')!='' and isnull(costingsubmittedby,'')!=''
	and ISNULL(supplierCode,'')!='' and ISNULL(IsAsset,0)=0
	group by a.DocNumber,DocDate,SubmittedBy,SupplierCode,TotalAmount,Currency, A.ReferenceNumber 
	union all
	select a.DocNumber,DocDate,SubmittedBy,Broker,TotalFreight as APAmount,
    0 as VatAmount,
    0 as EWTAmount,
    Currency,'PRCRCR-B' as TransType, A.ReferenceNumber
    from Procurement.ReceivingReport a
    inner join Procurement.ReceivingReportDetailPO b on a.DocNumber = b.DocNumber
	where isnull(SubmittedBy,'')!='' and isnull(costingsubmittedby,'')!=''
	and ISNULL(Broker,'')!='' and ISNULL(IsAsset,0)=0
	group by a.DocNumber,DocDate,SubmittedBy,Broker,TotalAmount,Currency,TotalFreight, A.ReferenceNumber
	union all
	select a.DocNumber,DocDate,SubmittedBy,SupplierCode as 'Supplier/Broker',TotalAmount as APAmount,
    SUM(((isnull(UnitCost,0)*ISNULL(ExchangeRate,0))*isnull(ReceivedQty,0))*ISNULL(vatrate,0)) as VatAmount,
    SUM(((isnull(UnitCost,0)*ISNULL(ExchangeRate,0))*isnull(ReceivedQty,0))*ISNULL(ATCRate,0)) as EWTAmount,
    Currency,'ACTAQT' as TransType, A.ReferenceNumber
    from Procurement.ReceivingReport a
    inner join Procurement.ReceivingReportDetailPO b on a.DocNumber = b.DocNumber
	where isnull(SubmittedBy,'')!='' and isnull(costingsubmittedby,'')!=''
	and ISNULL(supplierCode,'')!='' and ISNULL(IsAsset,0)=1
	group by a.DocNumber,DocDate,SubmittedBy,SupplierCode,TotalAmount,Currency, A.ReferenceNumber
	union all
	select DocNumber,DocDate,SubmittedBy,PayableTo AS SupplierCode,ISNULL(TotalGrossVatable,0) + ISNULL(TotalGrossNonVatable,0) as TotalAmountDue,TotalVatAmount,TotalWitholdingTax,'PHP' as Currency,
	'ACTEXP' as TransType, '' AS ReferenceNumber
	from Accounting.ExpenseProcessing
    where isnull(SubmittedBy,'')!=''
    union all
    select DocNumber,DocDate,SubmittedBy,SupplierCode,TotalAmount,0 TotalVatAmount,0 TotalWitholdingTax,'PHP' as Currency,
    'PRPRT' as TransType, '' AS ReferenceNumber from Procurement.PurchaseReturn
    where isnull(SubmittedBy,'')!='' 
    UNION ALL
	select a.DocNumber,DocDate,SubmittedBy,SupplierCode as 'Supplier/Broker',TotalAmount as APAmount,
    SUM(((isnull(UnitCost,0)*ISNULL(ExchangeRate,0))*isnull(ReceivedQty,0))*ISNULL(vatrate,0)) as VatAmount,
    SUM(((isnull(UnitCost,0)*ISNULL(ExchangeRate,0))*isnull(ReceivedQty,0))*ISNULL(ATCRate,0)) as EWTAmount,
    Currency,'PRCRCRNI' as TransType, A.ReferenceNumber 
    from Procurement.ReceivingReportNonInv a
    inner join Procurement.ReceivingReportNonInvDetailPO b on a.DocNumber = b.DocNumber
	where isnull(SubmittedBy,'')!='' and isnull(costingsubmittedby,'')!=''
	and ISNULL(supplierCode,'')!='' and ISNULL(IsAsset,0)=0
	group by a.DocNumber,DocDate,SubmittedBy,SupplierCode,TotalAmount,Currency, A.ReferenceNumber 
    )t
    order by DocNumber,TransType,DocDate desc" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SalesInvoicedet" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select *
    from(
    select b.DocNumber,'' as LineNumber,'PRCRCR' as Transtype,b.DocNumber as TransDocNumber,DocDate as TransDate,sum(a.PesoAmount+(a.PesoAmount*isnull(VATRate,0))-(a.PesoAmount*isnull(ATCRate,0))) as TransAPAmount, sum(a.PesoAmount*isnull(VATRate,0)) as TransVatAmount,
    sum(a.PesoAmount*isnull(ATCRate,0)) as TransEWTAmount,b.Currency,b.Field1,b.Field2,b.Field3,b.Field4,b.Field5,b.Field6,b.Field7,b.Field8,b.Field9,b.APVNumber,b.InvoiceNumber from Procurement.ReceivingReportDetailPO a
    inner join procurement.ReceivingReport b on a.docnumber = b.docnumber
    where isnull(costingsubmittedby,'')!=''
    group by b.DocNumber,b.DocDate,b.Currency,b.Field1,b.Field2,b.Field3,b.Field4,b.Field5,b.Field6,b.Field7,b.Field8,b.Field9,b.APVNumber,b.InvoiceNumber
    union all
    select DocNumber,'' as LineNumber,'ACTEXP' as Transtype,DocNumber as TransDocNumber,DocDate as TransDate,ISNULL(TotalGrossVatable,0) + ISNULL(TotalGrossNonVatable,0) as TransAPAmount, isnull(TotalVatAmount,0) as TransVatAmount,
    isnull(TotalWitholdingTax,0) as TransEWTAmount,'' as Currency, Field1,Field2,Field3,Field4,Field5,Field6,Field7,Field8,Field9,APVNumber,'' from Accounting.ExpenseProcessing
    ) trans
    where isnull(APVNumber,'')=''" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="getSI" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select MAX(DocNumber) as DocNumber,MAX(TransDocNumber) as TransDocNumber,MAX(InvoiceNumber) as InvoiceNumber
    from(
    select DocNumber,'' as LineNumber,'PRCRCR' as Transtype,DocNumber as TransDocNumber,DocDate as TransDate,isnull(TotalAmount,0) as TransAPAmount, isnull(VATAmount,0) as TransVatAmount,
    isnull(WTaxAmount,0) as TransEWTAmount,Currency,Field1,Field2,Field3,Field4,Field5,Field6,Field7,Field8,Field9,APVNumber,InvoiceNumber from Procurement.ReceivingReport
    union all
    select DocNumber,'' as LineNumber,'ACTEXP' as Transtype,DocNumber as TransDocNumber,DocDate as TransDate,ISNULL(TotalGrossVatable,0) + ISNULL(TotalGrossNonVatable,0) as TransAPAmount, isnull(TotalVatAmount,0) as TransVatAmount,
    isnull(TotalWitholdingTax,0) as TransEWTAmount,'' as Currency, Field1,Field2,Field3,Field4,Field5,Field6,Field7,Field8,Field9,APVNumber,'' from Accounting.ExpenseProcessing
    ) trans
    where isnull(APVNumber,'')='' and ISNULL(InvoiceNumber,'')!=''" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SalesInvoicedet2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Accounting.apvoucherdetail" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="getsales" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select TransDocNumber,DocNumber from Accounting.apvoucherdetail" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Accounting.APVoucherDetail where DocNumber  is null " OnInit="Connection_Init"></asp:SqlDataSource>
    
    <asp:SqlDataSource ID="MasterfileATC" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ATCCode, Description, Rate FROM Masterfile.[ATC]" OnInit="Connection_Init"></asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


