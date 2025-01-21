<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmFGTransferOut2.aspx.cs" Inherits="GWL.Inventory.frmFGTransferOut2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, user-scalable=no, maximum-scale=1.0, minimum-scale=1.0" />
    
    <title>FG Transfer Out</title>

    <%-- STYLE START --%>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />

    <style type="text/css">
        body {
            overflow-x: hidden;   
        }

        .formLayout {
            max-width: 1300px;
            margin: auto;
        }

        .grid
        {
            margin: 0 auto;
        }

        .pnl-content {
            text-align: right;
        }

        .Entry.btn {
            background: #2A88AD;
            padding: 3px 20px 3px 20px;
            border-radius: 5px;
            -webkit-border-radius: 5px;
            -moz-border-radius: 5px;
            color: #fff;
            text-shadow: 1px 1px 3px rgb(0 0 0 / 12%);
            -moz-box-shadow: inset 0px 2px 2px 0px rgba(255, 255, 255, 0.17);
            -webkit-box-shadow: inset 0px 2px 2px 0px rgb(255 255 255 / 17%);
            box-shadow: inset 0px 2px 2px 0px rgb(255 255 255 / 17%);
            position: relative;
            border: 1px solid #257C9E;
            font-size: 15px;
            font-style: normal;
            font-variant: normal;
            font-weight: bold;
            line-height: normal;
            font-family: 'Segoe UI', Helvetica, 'Droid Sans', Tahoma, Geneva, sans-serif;
        }

        @media only screen and (min-width: 758px) {
            .MaxWidth {
                max-width: 170px !important;
            }
        }
    </style>
    <%-- STYLE END --%>

    <%-- SCRIPT START --%>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script><%--NEWADD--%><%--Link to global stylesheet--%>

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

                console.log(s);
                console.log(e);
            }
            else {
                isValid = true;
            }
        }

        function DateCheck(s, e) {
            var ddate = Date.parse(dtpDocDate.GetValue());
            var rdate = Date.parse(dtpReceivedDate.GetValue());
            var msg = "";

            if (glType.GetText().toUpperCase() == "DISPATCH") {
                if (ddate > rdate) {
                    msg = "Target received date is lower than document date!";
                }
                console.log("timing")
                if (msg != "" || s.GetText() == "" || e.value == "" || e.value == null) {
                    if (msg != "") {
                        alert(msg);
                    }
                    dtpReceivedDate.SetText("");
                    counterror++;
                    isValid = false;
                }
                else {
                    isValid = true;
                }
            }
            else {
                isValid = true;
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

        var vatrate = 0;
        var vatdetail1 = 0;
        function gridView_EndCallback(s, e) {
            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_success);
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
                    window.close();
                }
            }

            if (s.cp_delete) {
                delete (cp_delete);
                DeleteControl.Show();
            }
            if (s.cp_refdel != null) {
                gv1.CancelEdit();
                delete (s.cp_refdel);
            }
            if (s.cp_generated) {
                delete (s.cp_generated);
                console.log('test');
                //START 2020-10-30 RAA Added Code for odsdetail approach
                gv1.CancelEdit();
                var _indices = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < _indices.length; i++) {
                    gv1.DeleteRow(_indices[i]);
                }

                var _refindices = gv2.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < _refindices.length; i++) {
                    gv1.AddNewRow();
                    _indices = gv1.batchEditApi.GetRowVisibleIndices();
                    console.log('test pasok');
                    var today = new Date();
                    var str = dtpDocDate.GetValue();
                    var str1 = str.getDay();

                    gv1.batchEditApi.SetCellValue(_indices[0], 'ItemCode', gv2.batchEditApi.GetCellValue(_refindices[i], 'SKUCode'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'ItemDesc', gv2.batchEditApi.GetCellValue(_refindices[i], 'ItemDescription'));

                    gv1.batchEditApi.SetCellValue(_indices[0], 'OrderQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Orders'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'TransferredQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Orders'));

                    gv1.batchEditApi.EndEdit();
                    //gv1.DeleteRow(-1);

                    console.log('test ok');
                    console.log(gv2.batchEditApi.GetCellValue(_refindices[i], 'SKUCode'));
                    console.log(gv2.batchEditApi.GetCellValue(_refindices[i], 'ItemDescription'));
                    console.log(gv2.batchEditApi.GetCellValue(_refindices[i], 'Orders'));
                    console.log(gv2.batchEditApi.GetCellValue(_refindices[i], 'Orders'));
                }
            }
        }

        var index;
        var closing;
        var itemc; //variable required for lookup
        var valchange = false;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var editorobj;
        var evn;
        function OnStartEditing(s, e) {
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
            evn = e;
            editorobj = e;

            var entry = getParameterByName('entry');
            if (entry != "V" && entry != "D") {
            }
            else {
                e.cancel = true;
            }

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
                if (e.focusedColumn.fieldName === "IsByBulk") {
                    glIsByBulk.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "OISNo") {
                    glOISNo.GetInputElement().value = cellInfo.value;
                }
            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            var entry = getParameterByName('entry');
        }

        function Datechange() {
            gv1.CancelEdit();
            var _indices = gv1.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < _indices.length; i++) {
                gv1.DeleteRow(_indices[i]);
            }
        }
        var val;
        var temp;
        function ProcessCells(selectedIndex, e, column, s) {
            if (val == null) {
                val = ";;;;;";
                temp = val.split(';');
            }
            temp = val.split(';');
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
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
                }
                if (column.fieldName == "FullDesc") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[5]);
                }
            }
        }

        function GridEnd(s, e) {
            val = s.GetGridView().cp_codes;
            temp = val.split(';');

            delete (s.GetGridView().cp_identifier);
            if (s.GetGridView().cp_valch) {
                delete (s.GetGridView().cp_valch);
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, editorobj, column, gv1);
                }
                gv1.batchEditApi.EndEdit();
            }
        }

        function lookup(s, e) {
            if (isSetTextRequired) {
                s.SetText(s.GetInputElement().value);
                isSetTextRequired = false;
            }
        }

        function gridLookup_KeyDown(s, e) {
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
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            gv1.batchEditApi.EndEdit();
        }

        var clonenumber = 0;
        var cloneindex;
        function OnCustomClick(s, e) {
            if (e.buttonID == "Details") {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
                var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
                if (glType.GetText().toUpperCase() == 'DISPATCH') {
                    var Warehouse = glWarehouseFr.GetText()
                }
                else {
                    var Warehouse = glWarehouseTo.GetText();
                }

                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode + '&colorcode=' + colorcode
                                    + '&classcode=' + classcode + '&sizecode=' + sizecode + '&Warehouse=' + Warehouse);
            }
            if (e.buttonID == "Delete") {
                gv1.DeleteRow(e.visibleIndex);
                autocalculate();
            }
            if (e.buttonID == "ViewTransaction") {
                var transtype = s.batchEditApi.GetCellValue(e.visibleIndex, "TransType");
                var docnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "DocNumber");
                var commandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "CommandString");
                window.open(commandtring + '?entry=V&transtype=' + transtype + '&parameters=&iswithdetail=true&docnumber=' + docnumber, '_blank', "", false);
            }
            if (e.buttonID == "ViewReferenceTransaction") {
                var rtranstype = s.batchEditApi.GetCellValue(e.visibleIndex, "RTransType");
                var rdocnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "REFDocNumber");
                var rcommandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "RCommandString");
                window.open(rcommandtring + '?entry=V&transtype=' + rtranstype + '&parameters=&iswithdetail=true&docnumber=' + rdocnumber, '_blank');
            }
            if (e.buttonID == "CountSheet") {
                CSheet.Show();
                var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
                var docnumber = getParameterByName('docnumber');
                var transtype = getParameterByName('transtype');
                var refdocnum = "";
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                var expdate = s.batchEditApi.GetCellValue(e.visibleIndex, "ExpDate");
                var mfgdate = s.batchEditApi.GetCellValue(e.visibleIndex, "MfgDate");
                var batchno = s.batchEditApi.GetCellValue(e.visibleIndex, "BatchNo");
                var lotno = s.batchEditApi.GetCellValue(e.visibleIndex, "LotNo");
                var docdate = dtpDocDate.GetText();
                console.log(itemcode);
                if (glType.GetText().toUpperCase() == 'DISPATCH') {
                    var Warehouse = glWarehouseFr.GetText()
                    var bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "DispatchBulkQty");
                }
                else {
                    var Warehouse = glWarehouseTo.GetText();
                    var bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "ReceivedBulkQty");
                }
                CSheet.SetContentUrl('../WMS/frmTRRSetup.aspx?entry=' + entry + '&docnumber=' + docnumber
                    + '&transtype=' + transtype
                    + '&linenumber=' + linenum
                    + '&refdocnum=' + refdocnum
                    + '&itemcode=' + encodeURIComponent(itemcode)
                    + '&colorcode=' + encodeURIComponent(colorcode)
                    + '&classcode=' + encodeURIComponent(classcode)
                    + '&sizecode=' + encodeURIComponent(sizecode)
                    + '&warehouse=' + encodeURIComponent(Warehouse)
                    + '&expdate=' + encodeURIComponent(convertDate(expdate))
                    + '&mfgdate=' + encodeURIComponent(convertDate(mfgdate))
                    + '&batchno=' + encodeURIComponent(batchno)
                    + '&lotno=' + encodeURIComponent(lotno)
                    + '&bulkqty=' + bulkqty
				    + '&docdate=' + encodeURIComponent(convertDate(docdate)));
            }
            if (e.buttonID == "CloneButton") {
                if (!CINClone.GetText()) {
                    alert('Please input a number to Clone textbox!');
                    return;
                }

                cloneloading.Show();
                setTimeout(function () {
                    clonenumber = CINClone.GetText();
                    for (i = 1; i <= clonenumber; i++) {
                        cloneindex = e.visibleIndex;
                        copyFlag = true;
                        gv1.AddNewRow();
                        precopy(gv1, evn);
                    }
                }, 1000);
            }
        }

        function convertDate(str) {
            var date = new Date(str),
                mnth = ("0" + (date.getMonth() + 1)).slice(-2),
                day = ("0" + date.getDate()).slice(-2);
            return [date.getFullYear(), mnth, day].join("-");
        }

        function precopy(ss, ee) {
            if (copyFlag) {
                copyFlag = false;

                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCellsClone(0, ee, column, gv1);
                }
            }
        }

        function ProcessCellsClone(selectedIndex, e, column, s) {//Clone function :D
            if (selectedIndex == 0) {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, s.batchEditApi.GetCellValue(cloneindex, column.fieldName));
                if (column.fieldName == "LineNumber") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, "");
                }
            }
            cloneloading.Hide();
        }

        Number.prototype.format = function (d, w, s, c) {
            var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')', num = this.toFixed(Math.max(0, ~~d));
            return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
        };

        function autocalculate(s, e) {
            var rqty = 0.0000;
            var rtotalqty = 0.0000;
            var rbulkqty = 0.00;
            var rtotalbulkqty = 0.00;

            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        if (glType.GetText() == "RECEIVE") {
                            rqty = gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedQty");
                            rbulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedBulkQty");
                        }
                        else {
                            rqty = gv1.batchEditApi.GetCellValue(indicies[i], "DispatchQty");
                            rbulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "DispatchBulkQty");
                        }
                        rtotalqty += rqty;
                        rtotalbulkqty += rbulkqty;
                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            if (glType.GetText() == "RECEIVE") {
                                rqty = gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedQty");
                                rbulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedBulkQty");
                            }
                            else {
                                rqty = gv1.batchEditApi.GetCellValue(indicies[i], "DispatchQty");
                                rbulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "DispatchBulkQty");
                            }
                            rtotalqty += rqty;
                            rtotalbulkqty += rbulkqty;
                        }
                    }
                }
                txtTotalQty.SetText(rtotalqty.format(4, 5, ',', '.'));
                txtTotalBulkQty.SetText(rtotalbulkqty.format(2, 3, ',', '.'));
            }, 500);
        }

        function Generate(s, e) {
            var prtext = glRefMONum.GetText();
            if (!prtext) { alert('No Tool Accountability to generate!'); return; }
            var generate = confirm("Are you sure you want to generate these Material Order");
            if (generate) {
                cp.PerformCallback('Generate');
                e.processOnServer = false;
            }

        }
    </script>
    <%-- SCRIPT END --%>
</head>
<body>
    <form id="form1" runat="server">

        <%-- TITLE START --%>
        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel ID="HeaderText" runat="server" Text="FG Transfer Out" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <%-- TITLE END --%>

        <dx:ASPxCallbackPanel ID="cp" runat="server" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <%-- FORM START --%>
                    <dx:ASPxFormLayout runat="server" ID="formLayout" CssClass="formLayout">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="700" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <SettingsTabPages EnableTabScrolling="true" />  
                                <Items>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>
                                            <dx:LayoutGroup Caption="Information" ColCount="2">
                                                <GroupBoxStyle>
                                                    <Caption Font-Bold="true" Font-Size="10" />
                                                </GroupBoxStyle>
                                                <Items>
                                                    <dx:LayoutItem Caption="Transfer Out Number">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocNumber" runat="server" CssClass="MaxWidth" ReadOnly="True" AutoCompleteType="Disabled" >
                                                                <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Document Date" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpDocDate" runat="server" CssClass="MaxWidth" OnLoad="Date_Load" ClientInstanceName="dtpDocDate" onchange="Datechange()">
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="Datechange"  />
                                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Reference MO Number" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glRefMONum" runat="server" CssClass="MaxWidth" SelectionMode="Multiple" ClientInstanceName="glRefMONum" DataSourceID="sdsRefMONum" KeyFieldName="DocNumber" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('Type');   e.processOnServer = false;}"/>
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Picklist Number" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtPicklistNumber" runat="server" CssClass="MaxWidth" AutoCompleteType="Disabled" >
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="" Name="Genereatebtn">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxButton ID="Generatebtn" ClientInstanceName="CINGenerate" runat="server" CssClass="MaxWidth" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" OnLoad="Generate_Btn" ClientVisible="true" Text="Generate" Theme="MetropolisBlue">
                                                                    <ClientSideEvents Click="Generate" />
                                                                </dx:ASPxButton>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Customer Code" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glCustomer" runat="server" CssClass="MaxWidth" ClientInstanceName="glCustomer" DataSourceID="sdsCustomer" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
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

                                                    <dx:LayoutItem Caption="Warehouse Code" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glWarehouse" runat="server" CssClass="MaxWidth" ClientInstanceName="glWarehouse" DataSourceID="sdsWarehouse" KeyFieldName="WarehouseCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
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
                                                    
                                                    <dx:LayoutItem Caption="Remarks" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memRemarks" runat="server" Height="71px" CssClass="MaxWidth" OnLoad="MemoLoad">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Detail">
                                                <GroupBoxStyle>
                                                    <Caption Font-Bold="true" Font-Size="10" />
                                                </GroupBoxStyle>
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gv1" runat="server" CssClass="grid" AutoGenerateColumns="False" ClientInstanceName="gv1" KeyFieldName="DocNumber;LineNumber" OnBatchUpdate="gv1_BatchUpdate" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize" Width="770px">
                                                                    <Settings VerticalScrollBarMode="Auto" HorizontalScrollBarMode="Auto" VerticalScrollableHeight="500" ColumnMinWidth="120"/>
                                                                    <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true"></SettingsAdaptivity>
                                                                    <SettingsBehavior AllowEllipsisInText="true" AllowSort="False"/>
                                                                    <EditFormLayoutProperties>
                                                                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                                                                    </EditFormLayoutProperties>
                                                                    <SettingsEditing Mode="Batch"></SettingsEditing>

                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" Init="OnInitTrans" />
                                                                    
                                                                    <SettingsPager Mode="ShowAllRecords">
                                                                    </SettingsPager>
                                                                    <%--<Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="350" VerticalScrollBarMode="Auto" />--%>
                                                                    <%--<SettingsBehavior AllowSort="False" />--%>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                            </PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" Name="glpItemCode" ShowInCustomizationForm="True" VisibleIndex="4" Width="100px" AdaptivePriority="0">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" ClientInstanceName="gl" DataSourceID="" KeyFieldName="ItemCode" OnInit="glItemCode_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="200px">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true" Settings-VerticalScrollableHeight="150" Settings-VerticalScrollBarMode="Visible" SettingsBehavior-FilterRowMode="Auto">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents DropDown="lookup" EndCallback="GridEnd" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemDesc" Name="ItemDesc" ShowInCustomizationForm="True" VisibleIndex="5" Width="350px" AdaptivePriority="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Order Qty" FieldName="OrderQty" Name="OrderQty" ShowInCustomizationForm="True" VisibleIndex="8" Width="100px" AdaptivePriority="0">
                                                                            <PropertiesSpinEdit AllowMouseWheel="False"  ConvertEmptyStringToNull="False" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" Increment="0" MaxValue="2147483647" NullDisplayText="0.0000" NullText="0.0000" NumberFormat="Custom">
                                                                                <SpinButtons ShowIncrementButtons="False">
                                                                                </SpinButtons>
                                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Transferred Qty" FieldName="TransferredQty" Name="TransferredQty" ShowInCustomizationForm="True" UnboundType="Decimal" VisibleIndex="30" Width="100px" AdaptivePriority="0">
                                                                            <PropertiesSpinEdit AllowMouseWheel="False" ConvertEmptyStringToNull="False" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" Increment="0" MaxValue="2147483647" NullDisplayText="0.0000" NullText="0.0000" NumberFormat="Custom">
                                                                                <SpinButtons ShowIncrementButtons="False">
                                                                                </SpinButtons>
                                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Remaining Qty" FieldName="RemainingQty" Name="RemainingQty" ShowInCustomizationForm="True" VisibleIndex="31" Width="100px" AdaptivePriority="0">
                                                                            <PropertiesSpinEdit AllowMouseWheel="False" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" Increment="0" MaxValue="2147483647" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom">
                                                                                <SpinButtons ShowIncrementButtons="False">
                                                                                </SpinButtons>
                                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>

                                                                        <%-- Added by JCB 10/21/2021 --%>
                                                                        <dx:GridViewDataDateColumn FieldName="ProductionDate" VisibleIndex="32" Width="120px">
                                                                            <PropertiesDateEdit DisplayFormatString="d" Height="30" />

                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Batch Number" FieldName="BatchNumber" Name="BatchNumber" ShowInCustomizationForm="True" VisibleIndex="32" Width="100px" AdaptivePriority="0">
                                                                            <PropertiesSpinEdit AllowMouseWheel="False" ConvertEmptyStringToNull="False" Increment="0" MaxValue="2147483647" NumberFormat="Custom">
                                                                                <SpinButtons ShowIncrementButtons="False">
                                                                                </SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>

                                                                        <dx:GridViewDataTextColumn FieldName="PalletNumber" Name="Pallet Number" ShowInCustomizationForm="True" VisibleIndex="32" Width="100px" AdaptivePriority="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewBandColumn Name="Case Ldaabel" AllowDragDrop="False" VisibleIndex="32" HeaderStyle-HorizontalAlign="Center" >
                                                                            <HeaderCaptionTemplate>  
                                                                                <dx:ASPxLabel ID="lblCaseLabel" ClientInstanceName="CINlblCaseLabel" runat="server" Text="Case Label">  
                                                                                </dx:ASPxLabel>  
                                                                            </HeaderCaptionTemplate>  
                                                            
                                                                                   <Columns>
                                                                                       <dx:GridViewDataCheckColumn Caption="Product Name" FieldName="ProductName" Name="ProductName" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" HeaderStyle-HorizontalAlign="Center" Width="100px" >

                                                                                       </dx:GridViewDataCheckColumn>

                                                                                       <dx:GridViewDataCheckColumn Caption="SKU Code" FieldName="SKUCodeBit" Name="SKUCode" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" HeaderStyle-HorizontalAlign="Center" Width="100px" >

                                                                                       </dx:GridViewDataCheckColumn>
                                                                                        
                                                                                       <dx:GridViewDataCheckColumn Caption="Production Date" FieldName="ProductionDateBit" Name="ProdDate" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" HeaderStyle-HorizontalAlign="Center" Width="120px">

                                                                                       </dx:GridViewDataCheckColumn>

                                                                                       <dx:GridViewDataCheckColumn Caption="Best Before Date" FieldName="BestBeforeDate" Name="BBDate" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" HeaderStyle-HorizontalAlign="Center" Width="120px">

                                                                                       </dx:GridViewDataCheckColumn>

                                                                                       <dx:GridViewDataCheckColumn Caption="Batch Number" FieldName="BatchNum" Name="BatchNum" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" HeaderStyle-HorizontalAlign="Center" Width="100px">

                                                                                       </dx:GridViewDataCheckColumn>
                                                                                       
                                                                                       <dx:GridViewDataCheckColumn Caption="Number of Packs" FieldName="PackNum" Name="PackNum" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" HeaderStyle-HorizontalAlign="Center" Width="120px">

                                                                                       </dx:GridViewDataCheckColumn>
                                                                                       
                                                                                    </Columns>
                                                                                
                                                                        </dx:GridViewBandColumn>

                                                                        <dx:GridViewDataTextColumn FieldName="BoxUsed" Name="Box Used" ShowInCustomizationForm="True" VisibleIndex="32" Width="100" AdaptivePriority="0">
                                                                        </dx:GridViewDataTextColumn>

                                                                        <%-- End Added by JCB 10/21/2021 --%>


                                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="32" MinWidth="50">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="33" MinWidth="50">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="34" MinWidth="50">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="35" MinWidth="50">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="36" MinWidth="50">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="37" MinWidth="50">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="38" MinWidth="50">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="39" MinWidth="50">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="40" MinWidth="50">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Version" FieldName="Version" Name="glpVersion" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="33" Width="0px">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <Styles>
                                                                        <Cell Wrap="False" />
                                                                    </Styles>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>

                                            <dx:LayoutItem ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gv2" runat="server" ClientInstanceName="gv2" AutoGenerateColumns="true" BatchEditStartEditing="OnStartEditing">
                                                            <SettingsEditing Mode="Batch" />
                                                            <SettingsPager Mode="ShowAllRecords" />
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <GroupBoxStyle>
                                            <Caption Font-Bold="true" Font-Size="10" />
                                        </GroupBoxStyle>
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
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" OnLoad="TextboxLoad">
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
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad" >
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
                                        <GroupBoxStyle>
                                            <Caption Font-Bold="true" Font-Size="10" />
                                        </GroupBoxStyle>
                                        <Items>
                                            <dx:LayoutItem Caption="Added By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedBy" runat="server" CssClass="MaxWidth" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Added Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedDate" runat="server" CssClass="MaxWidth" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" CssClass="MaxWidth" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" CssClass="MaxWidth" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" CssClass="MaxWidth" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" CssClass="MaxWidth" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" CssClass="MaxWidth" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledDate" runat="server" CssClass="MaxWidth" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--<dx:LayoutItem Caption="Posted By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHPostedBy" runat="server" CssClass="MaxWidth" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Posted Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHPostedDate" runat="server" CssClass="MaxWidth" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                        </Items>
                                    </dx:LayoutGroup>     
                                </Items>
                            </dx:TabbedLayoutGroup>     
                        </Items>
                    </dx:ASPxFormLayout>        
                    <%-- FORM END --%>

                    <%-- FOOTER START --%>
                    <dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                                <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" CssClass="Entry btn" ClientInstanceName="btn"
                                    UseSubmitBehavior="false" CausesValidation="true">
                                    <ClientSideEvents Click="OnUpdateClick" />
                                </dx:ASPxButton>
                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                    <%-- FOOTER END --%>

                    <%-- LOADING START --%>
                    <dx:ASPxLoadingPanel ID="ASPxLoadingPanel2" runat="server" Text="Cloning..." ClientInstanceName="cloneloading" ContainerElementID="gv1" Modal="true" ImagePosition="Left">
		                <LoadingDivStyle Opacity="0"></LoadingDivStyle>
	                </dx:ASPxLoadingPanel>
                    <%-- LOADING END --%>

                    <%-- DELETE CONTROL START --%>
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
                                            <dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="False">
                                                <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                            </dx:ASPxButton>
                                        </td>
                                        <td>
                                            <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="False">
                                                <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                    <%-- DELETE CONTROL END --%>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </form>

    <%-- DATASOURCE START --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.FGTransferOut" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.FGTransferOut" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.FGTransferOut+FGTransferOutDetail" SelectMethod="getdetail" UpdateMethod="UpdateFGTransferOutDetail" TypeName="Entity.FGTransferOut+FGTransferOutDetail" DeleteMethod="DeleteFGTransferOutDetail" InsertMethod="AddFGTransferOutDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" DataObjectTypeName="Entity.FGTransferOut+FGTransferOutDetail" SelectMethod="getmodetail" UpdateMethod="UpdateFGTransferOutDetail" TypeName="Entity.FGTransferOut+FGTransferOutDetail" DeleteMethod="DeleteFGTransferOutDetail" InsertMethod="AddFGTransferOutDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="MODocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Inventory.FGTransferOutDetail WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, Description FROM Masterfile.Warehouse WHERE ISNULL([IsInactive],0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.BizPartner WHERE ISNULL([IsInactive],0) = 0 and IsCustomer = '1'" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsRefMONum" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select MAX(DocNumber) AS DocNumber, MAX(CustomerCode) AS CustomerCode From Production.MaterialOrder where SubmittedBy IS NOT NULL group by WorkWeek, Year" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsMODetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" select A.DocNumber,SKUCode,PackagingType,LineNumber,RecordID,ItemDescription,Day1,Day2,Day3,Day4,Day5,Day6,Day7,BatchWeight, B.Workweek,B.Year, B.SubmittedBy from Production.MaterialOrderDetail A left join Production.MaterialOrder B on A.DocNumber = B.DocNumber where SubmittedBy is not null" OnInit ="Connection_Init"></asp:SqlDataSource>
    <%-- DATASOURCE END --%>
</body>
</html>
