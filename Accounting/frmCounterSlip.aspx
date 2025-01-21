<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmCounterSlip.aspx.cs" Inherits="GWL.frmCounterSlip" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Counter Slip</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script>
    <!--#region Region CSS-->
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
        height: 550px; /*Change this whenever needed*/
        }

        .Entry {
        padding: 20px;
        margin: 10px auto;
        background: #FFF;
        }

        /*.dxeButtonEditSys input,
        .dxeTextBoxSys input{
            text-transform:uppercase;
        }*/

         .pnl-content
        {
            text-align: right;
        }


    </style>
    <!--#endregion-->
    
    <!--#region Region Javascript-->
    <script>
        var isValid = true;
        var counterror = 0;
        var datecheking = 0;
        var errormsg = "";
        var isDate = false;
        var isDocDate = false;

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

        function OnInitTrans(s, e) {

            var BizPartnerCode = gvSup.GetText();
            var BizAccount = gvBiz.GetText();

            if (BizPartnerCode == null || BizPartnerCode == "" || BizPartnerCode == '') {
                factbox.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizAccount);

            } else {
                factbox.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
            }

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

        function OnValidation(s, e) { //Validation function for header controls (Set this for each header controls)
            if (s.GetText() == "" || e.value == "" || e.value == null) {
                counterror++;
                isValid = false
                console.log(s);
                console.log(e);
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
            console.log(isValid + ' ' + counterror);

            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            var cntdetails = indicies.length;

            gv1.batchEditApi.EndEdit();

            if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
                //Sends request to server side
                if (btnmode == "Add") {
                    if (cntdetails == 0) {
                        cp.PerformCallback("AddZeroDetail");
                    }
                    else {
                        cp.PerformCallback("Add");
                    }
                }
                else if (btnmode == "Update") {
                    if (cntdetails == 0) {
                        cp.PerformCallback("UpdateZeroDetail");
                    }
                    else {
                        cp.PerformCallback("Update");
                    }
                }
                else if (btnmode == "Close") {
                    cp.PerformCallback("Close");
                }
            }
            else {
                counterror = 0;
                alert('Please check all the fields!');
                console.log(counterror);
            }


        }

        function ResetGrid(s, e) {
            gv1.CancelEdit();
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

                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                var cntdetails = indicies.length;

                gv1.batchEditApi.EndEdit();
                autocalculate();

                if (cntdetails == 0) {
                    aglTransNo.SetText("");
                }

                if (s.cp_forceclose) {
                    delete (s.cp_forceclose);
                    window.close();

                }

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
            if (s.cp_generated) {
                delete (s.cp_generated);
                autocalculate();
            }

            if (s.cp_check) {
                delete (s.cp_check);
                alert(s.cp_message);
                delete (s.cp_message);
            }

        }

        var index;
        var closing;
        var itemc; //variable required for lookup
        var valchange = false;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for

            var entry = getParameterByName('entry');

            e.cancel = true; //this will made the gridview readonly


            if (entry != "V") {
                if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                    closing = true;
                }
                if (e.focusedColumn.fieldName === "ColorCode") {
                    gl2.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "ClassCode") {
                    gl3.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "SizeCode") {
                    gl4.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "Unit") {
                    gl5.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "BulkUnit") {
                    gl6.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "VATCode") {
                    glVATCode.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "IsVAT") {
                    glIsVAT.GetInputElement().value = cellInfo.value;
                }
            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];

            var entry = getParameterByName('entry');

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
            if (currentColumn.fieldName === "SizeCode") {
                cellInfo.value = gl4.GetValue();
                cellInfo.text = gl4.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "Unit") {
                cellInfo.value = gl5.GetValue();
                cellInfo.text = gl5.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "BulkUnit") {
                cellInfo.value = gl6.GetValue();
                cellInfo.text = gl6.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "VATCode") {
                cellInfo.value = glVATCode.GetValue();
                cellInfo.text = glVATCode.GetText();
            }
            if (currentColumn.fieldName === "IsVAT") {
                cellInfo.value = glIsVAT.GetValue();
            }


            if (valchange) {

                valchange = false;
                closing = false;
                for (var i = 0; i < s.GetColumnsCount() ; i++) {
                    var column = s.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, e, column, s);
                }
            }
        }



        var val;
        var temp;
        function ProcessCells(selectedIndex, e, column, s) {
            if (val == null) {
                val = ";;;;";
                temp = val.split(';');
            }
            if (temp[0] == null) {
                temp[0] = "";
            }
            if (temp[1] == null) {
                temp[1] = "";
            }
            if (temp[2] == null) {
                temp[2] = "";
            }
            if (temp[3] == null) {
                temp[3] = "";
            }
            if (temp[4] == null) {
                temp[4] = "";
            }
            if (temp[5] == null) {
                temp[5] = "";
            }
            if (temp[6] == null) {
                temp[6] = "";
            }
            if (temp[7] == null) {
                temp[7] = "";
            }
            if (selectedIndex == 0) {
                if (column.fieldName == "ColorCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0]);
                }
                if (column.fieldName == "ClassCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[1]);
                }
                if (column.fieldName == "SizeCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[2]);
                }
                if (column.fieldName == "Unit") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
                }
                if (column.fieldName == "BulkUnit") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[5]);
                }
                if (column.fieldName == "FullDesc") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
                }
                if (column.fieldName == "VATCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[6]);
                }
                if (column.fieldName == "IsVAT") {
                    if (temp[7] == "True") {
                        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsVAT.SetChecked = true);
                    }
                    else {
                        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsVAT.SetChecked = false);
                    }
                }
            }
        }


        function GridEnd(s, e) {
            val = s.GetGridView().cp_codes;
            temp = val.split(';');

            if (closing == true) {
                for (var i = 0; i > -gv1.GetVisibleRowsOnPage() ; i--) {
                    gv1.batchEditApi.ValidateRow(-1);
                    //gv1.batchEditApi.StartEdit(i, gv1.GetColumnByField("ColorCode").index);
                }
                gv1.batchEditApi.EndEdit();
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
            if (keyCode == ASPxKey.Enter) {
                gv1.batchEditApi.EndEdit();
            }
            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            gv1.batchEditApi.EndEdit();
        }

        function OnCustomClick(s, e) {
            if (e.buttonID == "Details") {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
                var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
                //factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                //+ '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&unit=' + unitbase + '&fulldesc=' + fulldesc);
            }
            if (e.buttonID == "DetailsDelete") {
                gv1.DeleteRow(e.visibleIndex);
                autocalculate();
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


        function endcp(s, e) {
            var endg = s.GetGridView().cp_endgl1;
            if (endg == true) {
                console.log(endg);
                e.processOnServer = false;
                endg = null;
            }
        }

        function autocalculate(s, e) {

            OnInitTrans();
            console.log('auto')

            var HGross = 0.00;
            var HGrossNon = 0.00;
            var HVat = 0.00;
            var HAmount = 0.00;

            //for detail
            var DGross = 0.00;
            var DGrossNon = 0.00;
            var DVat = 0.00;
            var DAmount = 0.00;

            var arrTrans = [];
            var cntr = 0;
            var holder = 0;
            var txt = "";

            setTimeout(function () {

                var iGrid = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < iGrid.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(iGrid[i])) {

                        DGross = gv1.batchEditApi.GetCellValue(iGrid[i], "GrossVAT");
                        DGrossNon = gv1.batchEditApi.GetCellValue(iGrid[i], "GrossNonVAT");
                        DVat = gv1.batchEditApi.GetCellValue(iGrid[i], "VATAmount");
                        DAmount = gv1.batchEditApi.GetCellValue(iGrid[i], "AmountDue");

                        HGross += DGross;
                        HGrossNon += DGrossNon;
                        HVat += DVat;
                        HAmount += DAmount;
                    }
                    else {
                        var key = gv1.GetRowKey(iGrid[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) {
                            console.log("deleted row " + iGrid[i]);
                        }
                        else {
                            DGross = gv1.batchEditApi.GetCellValue(iGrid[i], "GrossVAT");
                            DGrossNon = gv1.batchEditApi.GetCellValue(iGrid[i], "GrossNonVAT");
                            DVat = gv1.batchEditApi.GetCellValue(iGrid[i], "VATAmount");
                            DAmount = gv1.batchEditApi.GetCellValue(iGrid[i], "AmountDue");

                            HGross += DGross;
                            HGrossNon += DGrossNon;
                            HVat += DVat;
                            HAmount += DAmount;
                        }
                    }
                }

                //FOR RefTrans
                for (var x = 0; x <= iGrid.length; x++) {
                    if (gv1.batchEditApi.IsNewRow(iGrid[x])) {
                        for (var y = 0; y <= iGrid.length; y++) {
                            if (gv1.batchEditApi.GetCellValue(iGrid[x], "SalesInvoiceNo") == arrTrans[y]) {
                                cntr++;
                            }
                        }
                        if (cntr == 0) {
                            holder++;
                            arrTrans[holder] = gv1.batchEditApi.GetCellValue(iGrid[x], "SalesInvoiceNo");
                        }
                        else cntr = 0;
                    }
                    else {
                        var key = gv1.GetRowKey(iGrid[x]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + iGrid[x]);
                        else {
                            for (var y = 0; y <= iGrid.length; y++) {
                                if (gv1.batchEditApi.GetCellValue(iGrid[x], "SalesInvoiceNo") == arrTrans[y]) {
                                    cntr++;
                                }
                            }
                            if (cntr == 0) {
                                holder++;
                                arrTrans[holder] = gv1.batchEditApi.GetCellValue(iGrid[x], "SalesInvoiceNo");
                            }
                            else cntr = 0;
                        }
                    }
                }

                for (var z = 0; z <= holder; z++) {
                    if (z == 0 && z == null && z == "undefined")
                        console.log('skip');
                    else {
                        if (arrTrans[z] != 0 && arrTrans[z] != null && z != "undefined")
                        { txt += arrTrans[z] + ";"; }
                    }
                }

                var str = txt;
                str = str.slice(0, -1);
                //END RefTrans
                console.log(str);
                aglTransNo.SetText(str);
                txtGross.SetValue(HGross);
                txtVat.SetValue(HVat);
                txtNonVat.SetValue(HGrossNon);
                txtAmount.SetValue(HAmount);

            }, 500);
        }


    </script>
    <!--#endregion-->
</head>
<body style="height: 910px;">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
<form id="form1" runat="server" class="Entry">
      <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="BizPartner info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="50"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Counter Slip" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>

    <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
         ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents CloseUp="function (s, e) { window.location.reload(); }" />
    </dx:ASPxPopupControl>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>
                                            <dx:LayoutGroup Caption="Information" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Document Number">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocNumber" runat="server" OnLoad="TextboxLoad" Width="170px" AutoCompleteType="Disabled" Enabled="False">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Document Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnInit="dtpDocDate_Init" OnLoad="Date_Load" Width="170px" ClientInstanceName="dtpDocDate">
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
                                                    <dx:LayoutItem Caption="Customer Code">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglCustomerCode" runat="server" ClientInstanceName="gvSup" DataSourceID="sdsBizPartnerCus" 
                                                                    Width="170px" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}" AutoGenerateColumns="false">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="true">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="true">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                                    <ClientSideEvents ValueChanged="function(s, e) { cp.PerformCallback('CallbackCustomer') }"/>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Date From">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td>                                                                        
                                                                            <dx:ASPxDateEdit ID="dtpDateFrom" runat="server" OnLoad="Date_Load" Width="170px" ClientInstanceName ="dtpDateFrom">
                                                                                <ClientSideEvents Validation="OnValidation" ValueChanged ="function(s, e) { cp.PerformCallback('GridReset') }" />
                                                                                <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                    <RequiredField IsRequired="True" />
                                                                                </ValidationSettings>
                                                                                <InvalidStyle BackColor="Pink">
                                                                                </InvalidStyle>
                                                                            </dx:ASPxDateEdit>
																        </td>
                                                                        <td>
                                                                            <dx:ASPxLabel ID="lblDateFrom" runat="server" Text="*Must be lesser than Date To."/>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Business Account">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglBizAccount" runat="server" ClientInstanceName="gvBiz" Width="170px" DataSourceID="sdsBizAccount" 
                                                                    KeyFieldName="BizAccount" OnLoad="LookupLoad" TextFormatString="{0}" AutoGenerateColumns="false">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizAccount" ReadOnly="true">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="true">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents ValueChanged="function(s,e){cp.PerformCallback('CallbackBizAccount');}"/>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Date To" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td> 
                                                                            <dx:ASPxDateEdit ID="dtpDateTo" runat="server" OnLoad="Date_Load" Width="170px" ClientInstanceName ="dtpDateTo">
                                                                                <ClientSideEvents Validation="OnValidation" ValueChanged ="function(s, e) { cp.PerformCallback('GridReset') }" />
                                                                                <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                    <RequiredField IsRequired="True" />
                                                                                </ValidationSettings>
                                                                                <InvalidStyle BackColor="Pink">
                                                                                </InvalidStyle>
                                                                            </dx:ASPxDateEdit>
																        </td>
                                                                        <td>
                                                                            <dx:ASPxLabel ID="lblDateTo" runat="server" Text="*Must be greater than Date From."/>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Remarks">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memRemarks" runat="server" Height="150px" Width="450px" OnLoad ="MemoLoad">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Amount" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Total Gross VAT">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtGross" runat="server" Width="170px" ClientInstanceName="txtGross" ReadOnly="True" DisplayFormatString="{0:N}" DecimalPlaces="2"
                                                            AllowMouseWheel ="false" SpinButtons-ShowIncrementButtons ="false">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total VAT" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtVatAmount" runat="server" Width="170px" ClientInstanceName="txtVat" ReadOnly="True" DisplayFormatString="{0:N}" DecimalPlaces="2"
                                                            AllowMouseWheel ="false" SpinButtons-ShowIncrementButtons ="false">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                 <dx:LayoutItem Caption="Total Gross Non-VAT">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtNonVatable" runat="server" ClientInstanceName="txtNonVat" ReadOnly="True" Width="170px" DisplayFormatString="{0:N}" DecimalPlaces="2"
                                                            AllowMouseWheel ="false" SpinButtons-ShowIncrementButtons ="false">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Amount Due">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtAmountDue" runat="server" Width="170px" ReadOnly="True" ClientInstanceName="txtAmount" DisplayFormatString="{0:N}" DecimalPlaces="2"
                                                            AllowMouseWheel ="false" SpinButtons-ShowIncrementButtons ="false">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
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
                                            <dx:LayoutItem Caption="Field1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" OnLoad="TextboxLoad">
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
                                            <dx:LayoutItem Caption="Field3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server"  OnLoad="TextboxLoad">
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
                                            <dx:LayoutItem Caption="Field5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad">
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
                                            <dx:LayoutItem Caption="Field7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad">
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
                                            <dx:LayoutItem Caption="Field9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
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
                                            <dx:LayoutItem Caption="Cancelled By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>                                     
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                      <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="608px"  KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Settings-ShowStatusBar="Hidden">

<Settings ShowStatusBar="Hidden"></Settings>

                                                        <SettingsBehavior FilterRowMode="OnClick" ColumnResizeMode="NextColumn" />
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                        <SettingsPager PageSize="5">
                                                        </SettingsPager>
                                                        <SettingsEditing Mode="Batch">
                                                        </SettingsEditing>
                                                           <ClientSideEvents Init="OnInitTrans" />

                                                        <Columns>
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
                                                            <dx:GridViewDataTextColumn FieldName="RTransType" Caption="Reference TransType" ShowInCustomizationForm="True" VisibleIndex="1" ReadOnly="True"  Name="RTransType">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="REFDocNumber" Caption="Reference DocNumber" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="True">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="RCommandString" ShowInCustomizationForm="True" VisibleIndex="3" ReadOnly="True" >
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4" ReadOnly="True">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" Caption="DocNumber"  ReadOnly="True">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CommandString" ShowInCustomizationForm="True" VisibleIndex="6"   ReadOnly="True">
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
                            <dx:LayoutGroup Caption="Counter Slip Detail">
                                <Items>
                                    <dx:LayoutItem Caption ="Reference Transactions">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <dx:ASPxGridLookup ID="aglTransNo" runat="server" DataSourceID="sdsRefTrans" SelectionMode="Multiple" 
                                                            KeyFieldName="DocNumber" OnLoad="LookupLoad" TextFormatString="{1}" OnInit="aglTransNo_Init" Width="700px" ClientInstanceName ="aglTransNo" >
                                                                <GridViewProperties>
                                                                    <SettingsBehavior AllowFocusedRow="True" />
                                                                    <Settings ShowFilterRow="True" />
                                                                </GridViewProperties>
                                                                <Columns>
                                                                    <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px" SelectAllCheckboxMode ="AllPages">
                                                                    </dx:GridViewCommandColumn>
                                                                    <%--<dx:GridViewDataTextColumn FieldName="RecordID" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>--%>
                                                                    <dx:GridViewDataTextColumn FieldName="TransType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataDateColumn FieldName="DocDate" ShowInCustomizationForm="True" VisibleIndex="2" Width="100px" ReadOnly ="true">
                                                                        <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                                        <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                        </PropertiesDateEdit>
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataDateColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="Reference" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <%--<dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="SubsiCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="ProfitCenter" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="CostCenter" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="9">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>--%>
                                                                    <dx:GridViewDataTextColumn FieldName="Amount" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5">
                                                                        <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="Applied" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6">
                                                                        <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                </Columns>                                                                  
                                                            </dx:ASPxGridLookup>
                                                        </td>
                                                        <td>
                                                            <dx:ASPxLabel ID="lblSpace" runat="server" Text="" Width="10px">
                                                            </dx:ASPxLabel>
                                                        </td>
                                                        <td>
		                                                    <dx:ASPxButton ID="btnGenerate" runat="server" AutoPostBack="False" Width="170px" Theme="MetropolisBlue" Text="Generate Detail" OnLoad="Button_Load" UseSubmitBehavior="false">
                                                                <ClientSideEvents Click="function(s, e) { cp.PerformCallback('Generate') }" />
                                                            </dx:ASPxButton>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                    <dx:LayoutItem Caption="" ShowCaption="False">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False"  Width="850px"
                                                    ClientInstanceName="gv1" OnBatchUpdate="gv1_BatchUpdate" OnCellEditorInitialize="gv1_CellEditorInitialize"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize"
                                                    OnInit="gv1_Init" OnRowValidating="grid_RowValidating" >
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick"  />
                                                    <SettingsPager Mode="ShowAllRecords" />  
                                                     <SettingsEditing Mode="Batch"/>
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="350"  /> 
                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                    <SettingsDataSecurity AllowDelete="False" AllowEdit="False" />
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false" VisibleIndex="0">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="30px">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="DetailsDelete">
                                                                <Image IconID="actions_cancel_16x16"> </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="80px" ReadOnly="true">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>                                                        
                                                        <%--<dx:GridViewDataTextColumn FieldName="DRNumber" Name="glpDRNumber" ShowInCustomizationForm="True" VisibleIndex="3" Width="80px" Caption="DR Number">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn FieldName="DRDate" Name="glpDRDate" VisibleIndex="4" Width="80px" Caption="DR Date" UnboundType="String">
                                                            <PropertiesDateEdit DisplayFormatString="MM/d/yyyy">
                                                            </PropertiesDateEdit>
                                                        </dx:GridViewDataDateColumn>--%>
                                                        <dx:GridViewDataTextColumn FieldName="SalesInvoiceNo" Name="glpSalesInvoiceNo" ShowInCustomizationForm="True" VisibleIndex="6" Width="120px" Caption="Transaction No.">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn FieldName="SIDate" Name="glpSIDate" VisibleIndex="7" Width="100px" Caption="Transaction Date" UnboundType="String">
                                                            <PropertiesDateEdit DisplayFormatString="MM/d/yyyy">
                                                            </PropertiesDateEdit>
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="Qty" Name="glpQty" ShowInCustomizationForm="True" UnboundType="Decimal" VisibleIndex="8" Caption="Quantity" Width="120px">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText= "0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="GrossVAT" Name="glpGrossVAT" ShowInCustomizationForm="True" VisibleIndex="9" Caption="Gross VAT Amount" Width="120px">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="GrossNonVAT" Name="glpGrossNonVAT" ShowInCustomizationForm="True" UnboundType="Decimal" VisibleIndex="10" Width="140px" Caption="Gross Non-VAT Amount">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="VATAmount" Name="glpVATAmount" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="11" Width="120px" Caption="VAT Amount" >
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false">
                                                            <SpinButtons ShowIncrementButtons="False" Enabled="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="AmountDue" Name="glpAmountDue" ShowInCustomizationForm="True" VisibleIndex="12" Caption="Amount Due" Width="120px">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="DiscountRate" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="StatusCode" ShowInCustomizationForm="True" VisibleIndex="13" Name="glpStatusCode" ReadOnly="True" Width="0px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="BaseQty" Name="glpBaseQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="14" Width="0px">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false">
                                                            <SpinButtons ShowIncrementButtons="False" Enabled="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BarcodeNo" ShowInCustomizationForm="True" VisibleIndex="15" Name="glpBarcodeNo" ReadOnly="True" Width="0px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="UnitFactor" Name="glUnitFactor" ShowInCustomizationForm="True" VisibleIndex="16" Caption="Unit Factor" Width="0px" >
                                                        <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}"
                                                                 SpinButtons-ShowIncrementButtons="false">
                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" ShowInCustomizationForm="True" VisibleIndex="25" UnboundType="String" Width="80px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" ShowInCustomizationForm="True" VisibleIndex="26" UnboundType="String" Width="80px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" ShowInCustomizationForm="True" VisibleIndex="27" UnboundType="String" Width="80px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" ShowInCustomizationForm="True" VisibleIndex="28" UnboundType="String" Width="80px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" ShowInCustomizationForm="True" VisibleIndex="29" UnboundType="String" Width="80px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" ShowInCustomizationForm="True" VisibleIndex="30" UnboundType="String" Width="80px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" ShowInCustomizationForm="True" VisibleIndex="31" UnboundType="String" Width="80px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" VisibleIndex="32" UnboundType="String" Width="80px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" VisibleIndex="33" UnboundType="String" Width="80px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Version" Name="glpVersion" ShowInCustomizationForm="True" VisibleIndex="34" UnboundType="String" Width="0">
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
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
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" AutoPostBack="False" UseSubmitBehavior="false">
                                <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                </dx:ASPxButton>
                            </td>
                            <td>
                                <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" AutoPostBack="False" UseSubmitBehavior="false">
                                <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                </dx:ASPxButton> 
                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
</form>
    <!--#region Region Datasource-->    
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.CounterSlip+CounterSlipDetail" SelectMethod="getdetail" UpdateMethod="UpdateCounterSlipDetail" TypeName="Entity.CounterSlip+CounterSlipDetail" DeleteMethod="DeleteCounterSlipDetail" InsertMethod="AddCounterSlipDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.CounterSlip+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Accounting.CounterSlipDetail WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBizPartnerCus" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT BizPartnerCode, Name FROM Masterfile.BPCustomerInfo WHERE ISNULL(IsInActive,0)=0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBizAccount" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizAccountCode AS BizAccount, BizAccountName AS Name FROM Masterfile.BizAccount WHERE ISNULL(IsInactive,0) = 0 " OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsRefTrans" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT TransType, DocNumber, DocDate, ISNULL(Reference,'') AS Reference, BizPartnerCode, SUM(Amount) AS Amount, SUM(Applied) AS Applied FROM Accounting.SubsiLedgerNonInv WHERE TransType IN ('ACTSIN','ACTARM','ACTJOV','ACTJOV2','SLSDRC') AND ISNULL(CounterDocNumber,'') = '' AND ISNULL(Amount,0) <> ISNULL(Applied,0) GROUP BY TransType, DocNumber, DocDate, Reference, BizPartnerCode ORDER BY TransType, DocNumber, DocDate" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSalesInvoice" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="	SELECT RIGHT('00000'+ CAST(ROW_NUMBER() OVER (ORDER BY SalesInvoiceNo) AS VARCHAR(5)),5) AS LineNumber, * FROM
	(SELECT * FROM (SELECT A.DocNumber AS SalesInvoiceNo, CONVERT(VARCHAR(10),A.DocDate,101) AS SIDate, A.CustomerCode, SUM(ISNULL(Qty,0)) AS Qty, ISNULL(VatAfterDisc,0) AS GrossVAT, ISNULL(NonVatAfterDisc,0) AS GrossNonVAT, ISNULL(VATAmount,0) AS VATAmount,  
    ISNULL(TotalAmountDue,0) AS AmountDue,  '' AS Field1, '' AS Field2, '' AS Field3, '' AS Field4, '' AS Field5, '' AS Field6, '' AS Field7, '' AS Field8, '' AS Field9, '' AS StatusCode, 0.00 AS BaseQty, '' AS BarcodeNo, 0.00 AS UnitFactor, '2' AS Version 
    FROM Accounting.SalesInvoice A INNER JOIN Accounting.SalesInvoiceDetail B ON A.DocNumber = B.DocNumber INNER JOIN Masterfile.Tax C  ON B.VTaxCode = C.TCode INNER JOIN Accounting.SubsiledgerNonInv D ON A.DocNumber = D.DocNumber AND ISNULL(CounterDocNumber,'') = ''  
    GROUP BY A.DocNumber, A.DocDate, A.CustomerCode, VatAfterDisc, NonVatAfterDisc, VATAmount, TotalAmountDue) AS A UNION ALL SELECT * FROM (SELECT A.DocNumber AS SalesInvoiceNo, CONVERT(VARCHAR(10),A.DocDate,101) AS DocDate, A.CustomerCode, SUM(ISNULL(Qty,0)) AS Qty, ISNULL(GrossVatAmount,0) AS GrossVAT, ISNULL(GrossNonVatAmount,0) AS GrossNonVAT, ISNULL(VATAmount,0) AS VATAmount,  
    ISNULL(TotalAmount,0) AS AmountDue,  '' AS Field1, '' AS Field2, '' AS Field3, '' AS Field4, '' AS Field5, '' AS Field6, '' AS Field7, '' AS Field8, '' AS Field9, '' AS StatusCode, 0.00 AS BaseQty, '' AS BarcodeNo, 0.00 AS UnitFactor, '2' AS Version 
    FROM Accounting.ARMemo A INNER JOIN Accounting.ARMemoDetail B ON A.DocNumber = B.DocNumber INNER JOIN Accounting.SubsiledgerNonInv D ON A.DocNumber = D.DocNumber AND ISNULL(CounterDocNumber,'') = ''  
    GROUP BY A.DocNumber, A.DocDate, A.CustomerCode, GrossVatAmount, GrossNonVatAmount, VATAmount, TotalAmount) AS B) C" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDiscount" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Code, Description FROM (SELECT Code, Description, LEN(Code) AS Ord FROM IT.SystemSettings WHERE SequenceNumber = 6 AND Code LIKE '%DISC_%') AS X ORDER BY Ord " OnInit ="Connection_Init"></asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


