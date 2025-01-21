<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmServiceBilling.aspx.cs" Inherits="GWL.frmServiceBilling" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Service Billing</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
        height: 680px; /*Change this whenever needed*/
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

        .statusBar a:first-child
        {
            display: none;
        }
    </style>
    <!--#endregion-->
    
    <!--#region Region Javascript-->
    <script>
        var isValid = true;
        var counterror = 0;
        var clicked;

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

        function OnUpdateClick(s, e) {
            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < indicies.length; i++) {
                if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                    gv1.batchEditApi.ValidateRow(indicies[i]);
                    gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("ServiceCode").index);
                }
                else {
                    var key = gv1.GetRowKey(indicies[i]);
                    if (gv1.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indicies[i]);
                    else {
                        gv1.batchEditApi.ValidateRow(indicies[i]);
                        gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("ServiceCode").index);
                    }
                }
            }

            gv1.batchEditApi.EndEdit();

            var btnmode = btn.GetText();
            if (isValid && counterror < 1 || btnmode == "Close") {
                
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

        function OnConfirm(s, e) {
            if (e.requestTriggerID === "cp")
                e.cancel = true;
        }

        function gridView_EndCallback(s, e) {
            if (s.cp_success) {
                if (s.cp_valmsg != null) {
                    alert(s.cp_valmsg);
                    delete (s.cp_valmsg);
                }
                alert(s.cp_message);
                delete (s.cp_success);
                delete (s.cp_message);
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
                    window.close();
                }
            }

            if (s.cp_delete) {
                delete (cp_delete);
                DeleteControl.Show();
            }

            if (s.cp_terms) {
                delete (s.cp_terms);
                cp.PerformCallback('Terms');
            }

            if (s.cp_calculate) {
                delete (s.cp_calculate);
                autocalculate();
            }

            if (s.cp_nodetail != null) {
                alert(s.cp_nodetail);
                delete (s.cp_nodetail);

            }
        }
        var index;
        var itemc;
        var vatc;
        var supc;
        var exp;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var valchange = false;
        var valchange2 = false;
        var entry = getParameterByName('entry');
        function OnStartEditing(s, e) { 
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            exp = s.batchEditApi.GetCellValue(e.visibleIndex, "ServiceCode");
            vatc = s.batchEditApi.GetCellValue(e.visibleIndex, "VATCode");
            index = e.visibleIndex;

            if (entry == "V" || entry == "D" || aglReceivable.GetText() == "" || aglReceivable.GetText() == null) {
                e.cancel = true;
            }

            if (entry != "V" && entry != "D") {                
                if (e.focusedColumn.fieldName === "ServiceCode") {
                    gl.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;                    
                }
                if (e.focusedColumn.fieldName === "GLSubsiCode") {
                    glSubsiCode.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "ProfitCenterCode") {
                    glProfitCenter.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "CostCenterCode") {
                    glCostCenter.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "VATCode") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsVatable") == false) {
                        e.cancel = true;
                        s.batchEditApi.SetCellValue(e.visibleIndex, "VATCode", "NONV")
                    }
                    else {
                        gl3.GetInputElement().value = cellInfo.value;
                        isSetTextRequired = true;
                    }
                }
                if (e.focusedColumn.fieldName === "IsEWT") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsVatable") == false) {
                        e.cancel = true;
                    }
                    else {
                        e.cancel = false;
                    }
                }
                if (e.focusedColumn.fieldName === "ATCCode") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsEWT") == false) {
                        e.cancel = true;
                    }
                    else {
                        gl2.GetInputElement().value = cellInfo.value;
                        isSetTextRequired = true;
                    }
                }
            }
            else {
                e.cancel = true;
            }

        }

        function OnEndEditing(s, e) {
            var cellInfo = e.rowValues[currentColumn.index];
            if (currentColumn.fieldName === "ServiceCode") {
                cellInfo.value = gl.GetValue();
                cellInfo.text = gl.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "GLSubsiCode") {
                cellInfo.value = glSubsiCode.GetValue();
                cellInfo.text = glSubsiCode.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "ProfitCenterCode") {
                cellInfo.value = glProfitCenter.GetValue();
                cellInfo.text = glProfitCenter.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "CostCenterCode") {
                cellInfo.value = glCostCenter.GetValue();
                cellInfo.text = glCostCenter.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "VATCode") {
                cellInfo.value = gl3.GetValue();
                cellInfo.text = gl3.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "ATCCode") {
                cellInfo.value = gl2.GetValue();
                cellInfo.text = gl2.GetText().toUpperCase();
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
            if (keyCode !== 9) return;
            var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
            if (gv1.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            }
        }

        function gridLookup_KeyPress(s, e) {
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode == 13)
                gv1.batchEditApi.EndEdit();
        }

        function gridLookup_CloseUp(s, e) {
            gv1.batchEditApi.EndEdit();
        }

        function Grid_BatchEditRowValidating(s, e) {
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                var chckd;
                var chckd2;

                if (column.fieldName == "Amount") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (value == null) {
                        value = "";
                    }
                    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                    else if (ASPxClientUtils.Trim(value) < 0) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " must not be negative";
                        isValid = false;
                    }
                }

                if (column.fieldName == "IsVatable") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (value == null) {
                        value = "";
                    }
                    if (ASPxClientUtils.Trim(value) == true) {
                        chckd2 = true;
                    }
                }
                if (column.fieldName == "VATCode") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (value == null) {
                        value = "";
                    }
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") && chckd2 == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                }
                if (column.fieldName == "IsEWT") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (value == null) {
                        value = "";
                    }
                    if (ASPxClientUtils.Trim(value) == true) {
                        chckd = true;
                    }
                }
                if (column.fieldName == "ATCCode") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (value == null){
                        value = "";
                    }
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") && chckd == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                }
            }
        }

        function OnCustomClick(s, e) {

            if (e.buttonID == "Delete") {
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

        var identifier;
        function GridEnd(s, e) {

            identifier = s.GetGridView().cp_identifier;
            val = s.GetGridView().cp_codes;
            if (val != null) {
                temp = val.split(';');
            }
            delete (s.GetGridView().cp_identifier);
            delete (s.GetGridView().cp_codes);

            if (valchange && (val != null && val != 'undefined' && val != '')) {
                valchange = false;
                var column = gv1.GetColumn(6);
                ProcessCells2(0, index, column, gv1);
                gv1.batchEditApi.EndEdit();
            }
            
            autocalculate();
        }

        function ProcessCells2(selectedIndex, focused, column, s) {
            if (val == null) {
                val = ";;;;;;;";
                temp = val.split(';');
            }

            if (temp[0] == null) {
                temp[0] = 0;
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

            console.log('iden:' + identifier);
            if (selectedIndex == 0) {
                if (identifier == "VAT") {
                    s.batchEditApi.SetCellValue(focused, "VATRate", temp[0]);
                }
                else if (identifier == "ATC") {
                    s.batchEditApi.SetCellValue(focused, "ATCRate", temp[0]);
                }
                else {
                    s.batchEditApi.SetCellValue(focused, "ServiceDescription", temp[0]);
                    s.batchEditApi.SetCellValue(focused, "GLAccountCode", temp[1]);
                    s.batchEditApi.SetCellValue(focused, "GLSubsiCode", temp[2]);
                    if (temp[3] == "True") {
                        s.batchEditApi.SetCellValue(focused, "IsVatable", gIsVatable.SetChecked = true);
                    }
                    else {
                        s.batchEditApi.SetCellValue(focused, "IsVatable", gIsVatable.SetChecked = false);
                    }
                    s.batchEditApi.SetCellValue(focused, "VATCode", temp[4]);
                    s.batchEditApi.SetCellValue(focused, "VATRate", temp[5]);
                    s.batchEditApi.SetCellValue(focused, "ProfitCenterCode", temp[6]);
                    s.batchEditApi.SetCellValue(focused, "CostCenterCode", temp[7]);
                }
            }
        }

        Number.prototype.format = function (d, w, s, c) {
            var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
                num = this.toFixed(Math.max(0, ~~d));
            return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
        };


        function OnInitTrans(s, e) {
            var BizPartnerCode = aglReceivable.GetText();
            factbox.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
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

        function IsVatableChanged(s, e) {
            if (gv1.batchEditApi.GetCellValue(index, "IsVatable") == false) {
                gv1.batchEditApi.SetCellValue(index, "VATRate", "0.00");
                gv1.batchEditApi.SetCellValue(index, "VATCode", "NONV");
            }
            else
            {
                gv1.batchEditApi.SetCellValue(index, "VATCode", "");
            }
        }

        function IsEWTChanged(s, e) {
            if (gv1.batchEditApi.GetCellValue(index, "IsEWT") == false) {
                gv1.batchEditApi.SetCellValue(index, "ATCRate", "0.00");
                gv1.batchEditApi.SetCellValue(index, "ATCCode", "");
            }
        }

        function autocalculate(s, e) {
            var amount = 0.00;
            var VATRate = 0.00;
            var ATCRate = 0.00;
            var grossvatable = 0.00;
            var grossnonvatable = 0.00;
            var vatamount = 0.00;
            var whtaxamount = 0.00;
            var totalamountdue = 0.00;

            var arrTrans = [];
            var cntr = 0;
            var holder = 0;
            var txt = "";

            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        amount = gv1.batchEditApi.GetCellValue(indicies[i], "Amount");
                        ATCRate = gv1.batchEditApi.GetCellValue(indicies[i], "ATCRate");
                        VATRate = gv1.batchEditApi.GetCellValue(indicies[i], "VATRate");

                        gv1.batchEditApi.SetCellValue(indicies[i], "VATAmount", (amount * VATRate).toFixed(2));

                        if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVatable") == true) {
                            vatamount += amount * VATRate;
                            grossvatable += amount;
                        }
                        else {
                            grossnonvatable += amount;
                        }

                        if (gv1.batchEditApi.GetCellValue(indicies[i], "IsEWT") == true) {
                            if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVatable") == true) {
                                ATCRate = gv1.batchEditApi.GetCellValue(indicies[i], "ATCRate");
                                whtaxamount += amount * ATCRate;
                            }
                        }

                        gv1.batchEditApi.SetCellValue(indicies[i], "Net", (amount + (amount * VATRate) - (amount * ATCRate)).toFixed(2));

                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            amount = gv1.batchEditApi.GetCellValue(indicies[i], "Amount");
                            ATCRate = gv1.batchEditApi.GetCellValue(indicies[i], "ATCRate");
                            VATRate = gv1.batchEditApi.GetCellValue(indicies[i], "VATRate");

                            gv1.batchEditApi.SetCellValue(indicies[i], "VATAmount", (amount * VATRate).toFixed(2));

                            if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVatable") == true) {
                                vatamount += amount * VATRate;
                                grossvatable += amount;
                            }
                            else {
                                grossnonvatable += amount;
                            }

                            if (gv1.batchEditApi.GetCellValue(indicies[i], "IsEWT") == true) {
                                if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVatable") == true) {
                                    ATCRate = gv1.batchEditApi.GetCellValue(indicies[i], "ATCRate");
                                    whtaxamount += amount * ATCRate;
                                }
                            }

                            gv1.batchEditApi.SetCellValue(indicies[i], "Net", (amount + (amount * VATRate) - (amount * ATCRate)).toFixed(2));

                        }
                    }
                }

                totalamountdue = (grossvatable + grossnonvatable + vatamount) - whtaxamount;
                speTotalVat.SetValue(vatamount);
                speTotalGross.SetValue(grossvatable);
                speTotalGrossNon.SetValue(grossnonvatable);
                speTotalWithholding.SetValue(whtaxamount);
                speTotalAmount.SetValue(totalamountdue);

            }, 500);
        }

        function OnCancelClick(s, e) {
            gv1.CancelEdit();
            autocalculate();
        }
    </script>

</head>
<body style="height: 910px">
<form id="form1" runat="server" class="Entry">
     <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="BizPartner Info" Height="325px" Width="245px" PopupHorizontalOffset="1250" PopupVerticalOffset="50"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
        <PanelCollection>
            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                <dx:ASPxLabel runat="server" Text="Service Billing" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxPanel>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="1050px" Height="565px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="1050px" style="margin-left: -3px" SettingsAdaptivity-AdaptivityMode="SingleColumnWindowLimit" SettingsAdaptivity-SwitchToSingleColumnAtWindowInnerWidth="600">
                    <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600"></SettingsAdaptivity>
                        <Items>
                          <%--<!--#region Region Header --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>
                                            <dx:LayoutGroup Caption="Information" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Document Number">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocNumber" runat="server" AutoCompleteType="Disabled" Enabled="False" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Document Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnLoad="Date_Load" Width="170px">
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
                                                    <dx:LayoutItem Caption="Receivable From">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglReceivable" runat="server" AutoGenerateColumns="False" ClientInstanceName="aglReceivable" DataSourceID="sdsBizPartner" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="False" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="true" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="true" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="BusinessAccountCode" ReadOnly="true" VisibleIndex="2">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="BizAccountName" ReadOnly="true" VisibleIndex="3">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Address" ReadOnly="true" VisibleIndex="4">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ContactPerson" ReadOnly="true" VisibleIndex="5">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TIN" ReadOnly="true" VisibleIndex="6" Caption="Customer TIN">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(){cp.PerformCallback('CallbackCustomer|' + aglReceivable.GetText());}" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
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
                                                                <dx:ASPxDateEdit ID="dtpDueDate" runat="server" OnLoad="Date_Load" Width="170px">
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Name">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtName" runat="server" ReadOnly="True" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Terms">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTerms" runat="server" Width="170px" Number="0" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  
                                                                                    ClientInstanceName ="speTerms" DisplayFormatString="{0}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" DecimalPlaces="0" NumberType="Integer">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Remarks">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memRemarks" runat="server" Height="200px" OnLoad="MemoLoad" Width="480px">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Ref. Charge No">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtRefNumber" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Amounts" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Total Gross Vatable Amount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTotalGross" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="speTotalGross" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Gross Non-Vatable Amount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTotalGrossNon" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="speTotalGrossNon" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total VAT Amount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTotalVat" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="speTotalVat" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Withholding Tax Amount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTotalWithholding" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="speTotalWithholding" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Amount Due">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTotalAmount" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="speTotalAmount" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
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
                                    <dx:LayoutGroup Caption="Journal Entries">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvJournal" runat="server" AutoGenerateColumns="False" Width="850px" ClientInstanceName="gvJournal"  KeyFieldName="RTransType;TransType"  >
                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                            <SettingsPager Mode="ShowAllRecords" />  
                                                            <SettingsEditing Mode="Batch"/>
                                                            <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130"  /> 
                                                            <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                            <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                                                               <ClientSideEvents Init="OnInitTrans" />
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
                            <dx:LayoutGroup Caption="Service Billing Details">
                                <Items>
                                    <dx:LayoutItem Caption="" ShowCaption="False">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">                                                
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="1000" KeyFieldName="DocNumber;LineNumber"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" SettingsBehavior-AllowSort="false"
                                                    OnCustomButtonInitialize="gv1_CustomButtonInitialize" OnInitNewRow="gv1_InitNewRow">
                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                                    <SettingsEditing Mode="Batch" />
                                                    <SettingsCommandButton>
                                                        <NewButton>
                                                        <Image IconID="actions_addfile_16x16"></Image>
                                                        </NewButton>
                                                        <EditButton>
                                                        <Image IconID="actions_addfile_16x16"></Image>
                                                        </EditButton>
                                                        <DeleteButton>
                                                        <Image IconID="actions_cancel_16x16"></Image>
                                                        </DeleteButton>
                                                    </SettingsCommandButton>
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick"/>
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false"
                                                            VisibleIndex="0">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="False" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="30px">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                    <Image IconID="actions_cancel_16x16"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="80px" PropertiesTextEdit-ConvertEmptyStringToNull="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ServiceCode" VisibleIndex="3" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glServiceCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                    DataSourceID="sdsServiceCode" KeyFieldName="ServiceCode" ClientInstanceName="gl" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="OnClick">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ServiceCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEnd" DropDown="lookup" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  
                                                                        ValueChanged="function(s,e){
                                                                        if(exp != gl.GetValue()){
                                                                            gl3.GetGridView().PerformCallback('Expense' + '|' + gl.GetValue());
                                                                            e.processOnServer = false;
                                                                            valchange = true;
                                                                            loader.SetText('Loading...');
                                                                            loader.Show();
                                                                            setTimeout(function(){ 
                                                                            gv1.batchEditApi.StartEdit(index, gv1.GetColumnByField('Amount').index);
                                                                            loader.Hide(); 
                                                                        },500);
                                                                            }
                                                                        }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ServiceDescription" VisibleIndex="4" ReadOnly="true" Width="200px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="GLAccountCode" VisibleIndex="5" ReadOnly="true" Width="105px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="GL SubsiCode" FieldName="GLSubsiCode" Name="ySubsidiaryCode" ShowInCustomizationForm="True" VisibleIndex="6" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSubsiCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" AutoCallBack="false" ClientInstanceName="glSubsiCode" 
                                                                    DataSourceID="sdsSubsi" KeyFieldName="SubsiCode"  OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{1}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SubsiCode" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="2">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents CloseUp ="gridLookup_CloseUp" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" DropDown="lookup"/>       
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Profit Center" FieldName="ProfitCenterCode" Name="yProfitCenter" ShowInCustomizationForm="True" VisibleIndex="7" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glProfitCenter" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="glProfitCenter" 
                                                                    DataSourceID="sdsProfitCenter" KeyFieldName="ProfitCenter"  OnLoad="gvLookupLoad" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ProfitCenter" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents CloseUp ="gridLookup_CloseUp" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" DropDown="lookup"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Cost Center" FieldName="CostCenterCode" Name="yCostCenter" ShowInCustomizationForm="True" VisibleIndex="8" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glCostCenter" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="glCostCenter" 
                                                                    DataSourceID="sdsCostCenter" KeyFieldName="CostCenter"  OnLoad="gvLookupLoad" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="CostCenter" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents CloseUp ="gridLookup_CloseUp" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" DropDown="lookup"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>                                          
                                                        <dx:GridViewDataSpinEditColumn FieldName="Amount" Name="gAmount" ShowInCustomizationForm="True" VisibleIndex="9" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                    SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false" MinValue="0" MaxValue="9999999999">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged ="autocalculate" />
                                                            </PropertiesSpinEdit>                                                          
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataCheckColumn Caption="Vatable" FieldName="IsVatable" ShowInCustomizationForm="True" VisibleIndex="10" Name="gIsVatable" Width="50px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesCheckEdit ClientInstanceName ="gIsVatable">
                                                                <ClientSideEvents CheckedChanged ="function(s, e){gv1.batchEditApi.EndEdit(); IsVatableChanged(); autocalculate();}" />
                                                            </PropertiesCheckEdit>
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataTextColumn FieldName="VATCode" VisibleIndex="11" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glVATCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"  OnInit="lookup_Init"
                                                                    DataSourceID="sdsTaxCode" KeyFieldName="TCode" ClientInstanceName="gl3" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="OnClick">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="TCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Rate" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents RowClick="function(){clicked = true;}" EndCallback="GridEnd" DropDown="lookup" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  ValueChanged="function(s,e){
                                                                            if(clicked == true){
                                                                            if(vatc != gl3.GetValue()){                                                                             
                                                                                gl.GetGridView().PerformCallback('VATCode' + '|' + gl3.GetValue());
                                                                                e.processOnServer = false;
                                                                                valchange = true;
                                                                                loader.SetText('Loading...');
                                                                                loader.Show();
                                                                                setTimeout(function(){ 
                                                                                autocalculate();
                                                                                loader.Hide(); 
                                                                            },500);}
                                                                                }
                                                                            clicked = false;
                                                                        }"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="VATRate" VisibleIndex="12" Width="0px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesTextEdit ClientInstanceName="txtVATRate"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="VATAmount" Name="gVATAmount" Caption="VAT Amount" ShowInCustomizationForm="True" VisibleIndex="13" Width="0px" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                    SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="IsEWT" Caption="EWT" ShowInCustomizationForm="True" VisibleIndex="14" Name="gIsEWT" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" Width="50px">
                                                            <PropertiesCheckEdit ClientInstanceName ="gIsEWT">
                                                                <ClientSideEvents CheckedChanged ="function(s, e){gv1.batchEditApi.EndEdit(); IsEWTChanged(); autocalculate();}" />
                                                            </PropertiesCheckEdit>
                                                        </dx:GridViewDataCheckColumn>                                                        
                                                        <dx:GridViewDataTextColumn FieldName="ATCCode" ShowInCustomizationForm="True" VisibleIndex="15" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glATCCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"  
                                                                    DataSourceID="sdsATC" KeyFieldName="ATCCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad"
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
                                                                    <ClientSideEvents RowClick="function(){clicked = true;}" EndCallback="GridEnd" DropDown="lookup" KeyPress="gridLookup_KeyPress" 
                                                                        KeyDown="gridLookup_KeyDown"  ValueChanged="function(s,e){
                                                                            if(clicked == true){
                                                                                gv1.batchEditApi.EndEdit();
                                                                                gl.GetGridView().PerformCallback('ATCCode' + '|' + gl2.GetValue());
                                                                                e.processOnServer = false;
                                                                                valchange = true;
                                                                                loader.SetText('Loading...');
                                                                                loader.Show();
                                                                                setTimeout(function(){ 
                                                                                autocalculate();
                                                                                loader.Hide(); 
                                                                            },500);
                                                                                }
                                                                            clicked = false;
                                                                        }"/>       
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ATCRate" VisibleIndex="16" Width="0px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesTextEdit ClientInstanceName="txtATCRate"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="ATCAmount" Name="gATCAmount" Caption="ATC Amount" ShowInCustomizationForm="True" VisibleIndex="17" Width="0px" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                    SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="Net" Name="gNet" Caption="Net Amount" ShowInCustomizationForm="True" VisibleIndex="18" Width="120px" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                    SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Remarks" VisibleIndex="19" Width="300" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Version" VisibleIndex="20" ReadOnly="true" Width="0" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                </dx:ASPxGridView>
                                                <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Loading..."
                                                    ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
                                                    <LoadingDivStyle Opacity="0"></LoadingDivStyle>
                                                </dx:ASPxLoadingPanel>
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
                                        <dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false">
                                        <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                        </dx:ASPxButton>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false">
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
    <%-- put all datasource codeblock here --%>
  
<form id="form2" runat="server" visible="false">
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.ServiceBilling+ServiceBillingDetail" SelectMethod="getdetail" UpdateMethod="UpdateServiceBillingDetail" TypeName="Entity.ServiceBilling+ServiceBillingDetail" DeleteMethod="DeleteServiceBillingDetail" InsertMethod="AddServiceBillingDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>	
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.ServiceBilling+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>    
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.ExpenseProcessing+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Accounting.ServiceBillingDetail WHERE DocNumber IS NULL" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBizPartner" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.BizPartnerCode, A.Name, ISNULL(B.BusinessAccountCode,'') AS BusinessAccountCode, ISNULL(C.BizAccountName,'') AS BizAccountName, B.Address, B.ContactPerson, B.TIN FROM Masterfile.BPCustomerInfo A 
        INNER JOIN Masterfile.BizPartner B ON A.BizPartnerCode = B.BizPartnerCode LEFT JOIN Masterfile.BizAccount C ON B.BusinessAccountCode = C.BizAccountCode WHERE (ISNULL(A.IsInactive,0) = 0 AND ISNULL(B.IsInactive,0) = 0)"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsServiceCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT UPPER(ServiceCode) AS ServiceCode, UPPER(Description) AS Description, Type FROM Masterfile.Service WHERE ISNULL(IsInactive,0) = 0 AND Type = 'INCOME'" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsTaxCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT TCode, Description, Rate FROM Masterfile.Tax WHERE ISNULL(IsInactive,0) = 0" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsATC" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ATCCode, Description, Rate FROM Masterfile.ATC WHERE ISNULL(IsInactive,0) = 0" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsProfitCenter" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ProfitCenterCode AS ProfitCenter, Description FROM Accounting.ProfitCenter WHERE ISNULL(IsInactive,0) = 0" ></asp:SqlDataSource>  
    <asp:SqlDataSource ID="sdsCostCenter" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT CostCenterCode AS CostCenter, Description FROM Accounting.CostCenter WHERE ISNULL(IsInactive,0) = 0" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSubsi" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT AccountCode, SubsiCode, Description FROM Accounting.GLSubsiCode WHERE ISNULL(IsInactive,0) = 0" ></asp:SqlDataSource>
    <!--#endregion-->
    </form> 
</body>
</html>


