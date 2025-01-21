<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmSPDetail.aspx.cs" Inherits="GWL.WMS.frmSPDetail" %>
 

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
<title></title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">

        #form1 {
            height: 580px; 
        } 

        .Entry {
         padding: 20px;
         margin: 10px auto;
         background: #FFF;
        } 

        .pnl-content {
            text-align: right;
        }

        .statusBar a:first-child {
            display: none;
        }
    </style>
    <!--#endregion-->

    <!--#region Javascript-->
    <script>
        var isValid = false;
        var counterror = 0;
        var ctype = "";
        var totalqty = 0.00;
        var totalqty2 = 0.00;
        var costbaseqty = 0.00;
        var originalqty = 0.00;
        var subsitotbulk = 0;
        var setuptotbulk = 0;
        var linenum = "";

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        function calcuinit(s, e) {
            autocalculateALL();
        }

        function calcuinit2(s, e) {
            autocalculateALL2();
        }

        var cnterr = 0;
        var cnterr1 = 0;
        function OnUpdateClick(s, e) {

            setTimeout(function () {
                if (countsheetsetup.GetVisible()) {
                    var indiciesxxx = countsheetsetup.batchEditApi.GetRowVisibleIndices();
                    for (var i = 0; i < indiciesxxx.length; i++) {
                        var key = countsheetsetup.GetRowKey(indiciesxxx[i]);
                        if (!countsheetsetup.batchEditApi.IsDeletedRow(key)) {
                            countsheetsetup.batchEditApi.SetCellValue(indiciesxxx[i], "Width", " ")
                        }
                    }
                }
                if (countsheetsubsi.GetVisible()) {
                    var indiciesyyy = countsheetsubsi.batchEditApi.GetRowVisibleIndices();
                    for (var i = 0; i < indiciesyyy.length; i++) {
                        var key = countsheetsubsi.GetRowKey(indiciesyyy[i]);
                        if (!countsheetsubsi.batchEditApi.IsDeletedRow(key)) {
                            countsheetsubsi.batchEditApi.SetCellValue(indiciesyyy[i], "Shrinkage", 0.00)
                        }
                    }
                }
            }, 500);

            setTimeout(function () {
                countsheetsetup.batchEditApi.EndEdit();
                countsheetsubsi.batchEditApi.EndEdit();

                //cnterr = 0;
                var transtayp = getParameterByName('transtype');

                setuptotbulk = 0;
                if (countsheetsetup.GetVisible()) {
                    var indicies = countsheetsetup.batchEditApi.GetRowVisibleIndices();
                    for (var i = 0; i < indicies.length; i++) { 
                        var key = countsheetsetup.GetRowKey(indicies[i]);
                        if (!countsheetsetup.batchEditApi.IsDeletedRow(key)) {
                            countsheetsetup.batchEditApi.ValidateRow(indicies[i]); 
                            var a = parseFloat(countsheetsetup.batchEditApi.GetCellValue(indicies[i], "OriginalBaseQty"));
                            a = a || 0;
                            if (a != 0) {
                                setuptotbulk++;
                            }
                        } 
                    }
                    autocalculateALL();
                    if (cnterr > 0) {
                        alert('Please check all fields!');
                    }
                    else if (totalqty.toFixed(4) != parseFloat(countsheetheader.batchEditApi.GetCellValue(0, "ReceivedQty")).toFixed(4)) {
                        alert('Total RollQty must be equal to the transaction\'s ReceivedQty!');
                    }
                        //else if (setuptotbulk != parseFloat(countsheetheader.batchEditApi.GetCellValue(0, "BulkQty"))) {
                    else if (setuptotbulk != Math.abs(parseFloat(countsheetheader.batchEditApi.GetCellValue(0, "BulkQty")))) {
                        alert('Unequal number of bulk!');
                    }
                    else
                        cp.PerformCallback("Update");
                }

                //cnterr1 = 0;
                subsitotbulk = 0;
                if (countsheetsubsi.GetVisible()) {
                    var trnstyp = getParameterByName('transtype');
                    if (transtayp == "SLSSRN" || transtayp == "INVSAN" || transtayp == "INVJON") {
                        var indicies = countsheetsubsi.batchEditApi.GetRowVisibleIndices();
                        for (var i = 0; i < indicies.length; i++) { 
                            var key = countsheetsubsi.GetRowKey(indicies[i]);
                            if (!countsheetsubsi.batchEditApi.IsDeletedRow(key)) {
                                countsheetsubsi.batchEditApi.ValidateRow(indicies[i]); 
                                countsheetsubsi.batchEditApi.StartEdit(indicies[i], countsheetsubsi.GetColumnByField("LineNumber").index);
                                var a = parseFloat(countsheetsubsi.batchEditApi.GetCellValue(indicies[i], "UsedQty"));
                                a = a || 0;
                                if (a != 0) {
                                    subsitotbulk++;
                                }
                            } 
                        }
                    }
                    else {
                        var indicies = countsheetsubsi.batchEditApi.GetRowVisibleIndices();
                        for (var i = 0; i < indicies.length; i++) { 
                            var key = countsheetsubsi.GetRowKey(indicies[i]);
                            if (!countsheetsubsi.batchEditApi.IsDeletedRow(key)) { 
                                var a = parseFloat(countsheetsubsi.batchEditApi.GetCellValue(indicies[i], "UsedQty"));
                                a = a || 0;
                                if (a != 0) {
                                    if (trnstyp == "INVCNT" && a < 0)
                                        continue;
                                    else
                                        subsitotbulk++;
                                }
                            } 
                        }
                    }

                    if (cnterr1 > 0) {
                        alert('Please check all fields!');
                    }
                    else if (totalqty2.toFixed(4) != parseFloat(countsheetheader.batchEditApi.GetCellValue(0, "TotalRequired")).toFixed(4)) {
                        alert('Total qty must be equal to the transaction\'s total Required qty!');
                    }
                        //else if (subsitotbulk != parseFloat(countsheetheader.batchEditApi.GetCellValue(0, "BulkQty"))) {
                    else if (subsitotbulk != Math.abs(parseFloat(countsheetheader.batchEditApi.GetCellValue(0, "BulkQty")))) {
                        alert('Unequal number of bulk!');
                    }
                    else {
                        cp.PerformCallback("Update");
                    }
                }
            }, 500);
        }

        function OnConfirm(s, e) {
            if (e.requestTriggerID === "cp")
                e.cancel = true;
        }

        function gridView_EndCallback(s, e) {
            if (s.cp_message != null) {
                alert(s.cp_message);
                delete (s.cp_message);
                countsheetheader.Refresh();
                //open(location, '_self').close(); 
            }

            if (s.cp_error != null) {
                alert(s.cp_error);
                delete (s.cp_error);
            }
        }

        function OnStartEditing(s, e) {
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            index = e.visibleIndex;
        }

        function OnEndEditing(s, e) {
            var cellInfo = e.rowValues[currentColumn.index];
        }

        function gridLookup_CloseUp(s, e) {
            countsheetsetup.batchEditApi.EndEdit();
        }

        function onload() {
            var type = getParameterByName('type');
            var entry = getParameterByName('entry');
            var linenum = getParameterByName('linenumber');
             
            if (entry == "V") { 
                var g = fl.GetItemByName('LG');
                g.SetVisible(g.GetVisible());
            }
        }

        function OnCancelClick(s, e) {
            if (countsheetsetup.GetVisible()) {
                countsheetsetup.CancelEdit();
                autocalculateALL();
            }
            if (countsheetsubsi.GetVisible()) {
                countsheetsubsi.CancelEdit();
                autocalculateALL2();
            }
        }

        var Nanprocessor = function (entry) {
            if (isNaN(entry) == true)
                return 0;
            else
                return entry;
        }

        Number.prototype.format = function (d, w, s, c) {
            var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
                num = this.toFixed(Math.max(0, ~~d));
            return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
        };

        //////////////////////////////////////////SETUP AUTO-CALCULATE///////////////////////////////////////////////////
        function autocalculateALL(s, e) {
            var allnum = [];

            var indicies = countsheetsetup.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < indicies.length; i++) { 
                var key = countsheetsetup.GetRowKey(indicies[i]);
                if (!countsheetsetup.batchEditApi.IsDeletedRow(key)) {
                    var getnum = parseFloat(countsheetsetup.batchEditApi.GetCellValue(indicies[i], "OriginalBaseQty"));
                    allnum.push(Nanprocessor(getnum));
                } 
            }

            if (allnum.length > 0) {
                var sum = allnum.reduce(function (a, b) { return a + b; });
                BaseQtyTotal.SetText("Total: " + sum.format(4, 6, ',', '.'));
            }
            else {
                var sum = 0;
                BaseQtyTotal.SetText("Total: " + sum.format(4, 6, ',', '.'));
            }
            totalqty = sum;
        }

        //////////////////////////////////////////SUBSI AUTO-CALCULATE///////////////////////////////////////////////////
        function autocalculateALL2(s, e) {
            var allnum = [];
            
            var ttype = getParameterByName('transtype');

            var indicies = countsheetsubsi.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < indicies.length; i++) { 
                var key = countsheetsubsi.GetRowKey(indicies[i]);
                if (!countsheetsubsi.batchEditApi.IsDeletedRow(key)) {
                    var getnum = parseFloat(countsheetsubsi.batchEditApi.GetCellValue(indicies[i], "UsedQty"));
                    var getnum2 = parseFloat(countsheetsubsi.batchEditApi.GetCellValue(indicies[i], "RemainingQty"));
                    if (ttype == "INVCNT" && Nanprocessor(getnum) < 0)
                        continue;
                    else
                        allnum.push(Nanprocessor(getnum)); 
                } 
            } 
            if (allnum.length > 0) {
                var sum = +allnum.reduce(function (a, b) { return a + b; });
                BaseQtyTotal.SetText("Total: " + sum.format(4, 6, ',', '.'));
            }
            else {
                var sum = 0;
                BaseQtyTotal.SetText("Total: " + sum.format(4, 6, ',', '.'));
            }
            totalqty2 = sum;
        }


        function Grid_BatchEditRowValidating(s, e) {
            if (countsheetsubsi.GetVisible()) {
                cnterr1 = 0;
                for (var i = 0; i < countsheetsubsi.GetColumnsCount() ; i++) {
                    var column = s.GetColumn(i);
                    var transtayp = getParameterByName('transtype');

                    if (column.fieldName == "RemainingQty") {
                        var cellValidationInfo = e.validationInfo[column.index];
                        if (!cellValidationInfo) continue;
                        var value = cellValidationInfo.value;
                        costbaseqty = value;
                    } 
                    if (column.fieldName == "CostBaseQty") {
                        var cellValidationInfo = e.validationInfo[column.index];
                        if (!cellValidationInfo) continue;
                        var value = cellValidationInfo.value;
                        originalqty = value;
                    }
                    if (column.fieldName == "UsedQty" && costbaseqty != 0 && costbaseqty != null && transtayp != "SLSSRN" && transtayp != "INVSAN" && transtayp != "INVJON" && transtayp != "INVADJT" && transtayp != "INVCNT") {
                        var cellValidationInfo = e.validationInfo[column.index];
                        if (!cellValidationInfo) continue;
                        var value = cellValidationInfo.value;

                        if (value > costbaseqty) {
                            cellValidationInfo.isValid = false;
                            ValidityState = false;
                            cellValidationInfo.errorText = "Required Qty should not be greater than Remaining Qty!";
                            isValid = false;
                            cnterr1++;
                        }
                    } 
                    if (column.fieldName == "UsedQty" && (transtayp == "INVCNT")) {
                        var cellValidationInfo = e.validationInfo[column.index];
                        if (!cellValidationInfo) continue;
                        var value = cellValidationInfo.value;

                        if (value > originalqty) {
                            cellValidationInfo.isValid = false;
                            ValidityState = false;
                            cellValidationInfo.errorText = "Required Qty should not be greater than RR Qty!";
                            isValid = false;
                            cnterr1++;
                        }
                    }
                    if (column.fieldName == "UsedQty" && (transtayp == "INVADJT")) {
                        var cellValidationInfo = e.validationInfo[column.index];
                        if (!cellValidationInfo) continue;
                        var value = cellValidationInfo.value;

                        if (value > (originalqty - costbaseqty)) {
                            cellValidationInfo.isValid = false;
                            ValidityState = false;
                            cellValidationInfo.errorText = "Remaining qty plus Required qty to be returned must not be greater than the RR Qty!";
                            isValid = false;
                            cnterr1++;
                        }
                    }
                }
            }
            if (countsheetsetup.GetVisible()) {
                cnterr = 0;
                for (var i = 0; i < countsheetsetup.GetColumnsCount() ; i++) {
                    var column = s.GetColumn(i);

                    if (column.fieldName == "LineNumber") {
                        var cellValidationInfo = e.validationInfo[column.index];
                        if (!cellValidationInfo) continue;
                        var value = cellValidationInfo.value;
                        linenum = value;

                        var indicies = countsheetsetup.batchEditApi.GetRowVisibleIndices();
                        for (var h = 0; h < indicies.length; h++) {
                            var getval = countsheetsetup.batchEditApi.GetCellValue(indicies[h], "LineNumber");

                            if ((e.visibleIndex != indicies[h]) && (linenum == getval)) {
                                cellValidationInfo.isValid = false;
                                ValidityState = false;
                                cellValidationInfo.errorText = "Roll ID must be unique!";

                                isValid = false;
                                cnterr++;
                            }
                        }
                    }
                }
            }
        }

    </script>
    <!--#endregion-->
</head>
<body style="height: 500px" onload="onload()">
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" ClientInstanceName="fl" runat="server" DataSourceID="" Height="565px" Width="810px" Style="margin-left: -3px" ColCount="2">
                        <Items>
                            <dx:LayoutItem Caption="SKUCode">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxTextBox ID="txtSKUCode" runat="server" Width="170px" ReadOnly="true">
                                        </dx:ASPxTextBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Step Sequence">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">        
                                        <dx:ASPxTextBox ID="txtStepSequence" runat="server" Width="170px" ReadOnly="true">
                                        </dx:ASPxTextBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <%-- Step Process Details Field --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <%-- Bill of Materials Field --%>
                                    <dx:LayoutGroup Caption="Bill of Materials">
                                        <Items>
                                            <dx:LayoutGroup Caption="">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <div class="container-fluid" id="BOMTable">
                                                                    <dx:ASPxGridView ID="gvStepBOM" ClientInstanceName="gvStepBOM" DataSourceID="sdsBOM" runat="server" KeyFieldName="SKUCode;StepSequence" Width="100%">
                                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick"/>
                                                                        <Settings ColumnMinWidth="60" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="200" VerticalScrollBarMode="Auto" />
                                                                        <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                        <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                        <SettingsBehavior AllowSort="False"/>
                                                                            <SettingsCommandButton>
                                                                            <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                            <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                            <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                        </SettingsCommandButton>
                                                                        <Styles>
                                                                            <StatusBar CssClass="statusBar">
                                                                            </StatusBar>
                                                                        </Styles>
                                                                        <Columns>
                                                                            <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" Width="60px" ShowNewButtonInHeader="True">
                                                                                <CustomButtons>
                                                                                    <dx:GridViewCommandColumnCustomButton ID="BOMDelete">
                                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                                </CustomButtons>
                                                                            </dx:GridViewCommandColumn>
                                                                            <dx:GridViewDataColumn FieldName="SKUCode" />
                                                                            <dx:GridViewDataColumn FieldName="SKUDescription" />
                                                                            <dx:GridViewDataColumn FieldName="StepSequence" />
                                                                            <dx:GridViewDataColumn FieldName="StepCode" />
                                                                            <dx:GridViewDataColumn FieldName="Unit" />
                                                                            <dx:GridViewDataColumn FieldName="ConsumptionPerProduct" />
                                                                            <dx:GridViewDataColumn FieldName="TotalConsumption" />
                                                                            <dx:GridViewDataColumn FieldName="PercentageAllowance" />
                                                                            <dx:GridViewDataColumn FieldName="QtyAllowance" />
                                                                            <dx:GridViewDataColumn FieldName="ClientSuppliedMaterial" />
                                                                            <dx:GridViewDataColumn FieldName="EstimatedUnitCost" />
                                                                            <dx:GridViewDataColumn FieldName="StandardUsage" />
                                                                            <dx:GridViewDataColumn FieldName="Remarks" />
                                                                        </Columns>
                                                                    </dx:ASPxGridView>
                                                                </div>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <%-- Machineries Field --%>
                                    <dx:LayoutGroup Caption="Machineries">
                                        <Items>
                                            <dx:LayoutGroup Caption="">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <div class="container-fluid" id="MachineTable">
                                                                    <dx:ASPxGridView ID="gvStepMachine" ClientInstanceName="gvStepMachine" runat="server" DataSourceID="sdsMachine" KeyFieldName="SKUCode;StepSequence" Width="100%">
                                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick"/>
                                                                        <Settings ColumnMinWidth="60" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="200" VerticalScrollBarMode="Auto" />
                                                                        <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                        <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                        <SettingsBehavior AllowSort="False"/>
                                                                            <SettingsCommandButton>
                                                                            <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                            <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                            <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                        </SettingsCommandButton>
                                                                        <Styles>
                                                                            <StatusBar CssClass="statusBar">
                                                                            </StatusBar>
                                                                        </Styles>
                                                                        <Columns>
                                                                            <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" Width="60px" ShowNewButtonInHeader="True">
                                                                                <CustomButtons>
                                                                                    <dx:GridViewCommandColumnCustomButton ID="MachineDelete">
                                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                                </CustomButtons>
                                                                            </dx:GridViewCommandColumn>
                                                                            <dx:GridViewDataColumn FieldName="SKUCode" />
                                                                            <dx:GridViewDataColumn FieldName="SKUDescription" />
                                                                            <dx:GridViewDataColumn FieldName="StepSequence" />
                                                                            <dx:GridViewDataColumn FieldName="StepCode" />
                                                                            <dx:GridViewDataColumn FieldName="MachineType" />
                                                                            <dx:GridViewDataColumn FieldName="Location" />
                                                                            <dx:GridViewDataColumn FieldName="MachineRun" />
                                                                            <dx:GridViewDataColumn FieldName="Unit" />
                                                                            <dx:GridViewDataColumn FieldName="MachineCapacityQty" />
                                                                            <dx:GridViewDataColumn FieldName="MachineCapacityUnit" />
                                                                            <dx:GridViewDataColumn FieldName="CostPerUnit" />
                                                                        </Columns>
                                                                    </dx:ASPxGridView>
                                                                </div>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup> 
                                        </Items>
                                    </dx:LayoutGroup> 
                                    <%-- Manpower Field --%>
                                    <dx:LayoutGroup Caption="Manpower">
                                        <Items>
                                            <dx:LayoutGroup Caption="">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <div class="container-fluid" id="ManpowerTable">
                                                                    <dx:ASPxGridView ID="gvStepManpower" ClientInstanceName="gvStepManpower" runat="server" DataSourceID="sdsManpower" KeyFieldName="SKUCOde;StepSequence" Width="100%">
                                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick"/>
                                                                        <Settings ColumnMinWidth="60" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="200" VerticalScrollBarMode="Auto" /><SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                        <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                        <SettingsBehavior AllowSort="False"/>
                                                                            <SettingsCommandButton>
                                                                            <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                            <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                            <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                        </SettingsCommandButton>
                                                                        <Styles>
                                                                            <StatusBar CssClass="statusBar">
                                                                            </StatusBar>
                                                                        </Styles>
                                                                        <Columns>
                                                                            <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" Width="60px" ShowNewButtonInHeader="True">
                                                                                <CustomButtons>
                                                                                    <dx:GridViewCommandColumnCustomButton ID="ManpowerDelete">
                                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                                </CustomButtons>
                                                                            </dx:GridViewCommandColumn>
                                                                            <dx:GridViewDataColumn FieldName="SKUCode" />
                                                                            <dx:GridViewDataColumn FieldName="SKUDescription" />
                                                                            <dx:GridViewDataColumn FieldName="StepSequence" />
                                                                            <dx:GridViewDataColumn FieldName="StepCode" />
                                                                            <dx:GridViewDataColumn FieldName="Designation" />
                                                                            <dx:GridViewDataColumn FieldName="NoManpower" />
                                                                            <dx:GridViewDataColumn FieldName="NoHour" />
                                                                            <dx:GridViewDataColumn FieldName="StandardRate" />
                                                                            <dx:GridViewDataColumn FieldName="StandardRateUnit" />
                                                                            <dx:GridViewDataColumn FieldName="CostPerUnit" />
                                                                        </Columns>
                                                                    </dx:ASPxGridView>
                                                                </div>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup> 
                                        </Items>
                                    </dx:LayoutGroup> 
                                </Items>
                            </dx:TabbedLayoutGroup>
                        </Items>
                    </dx:ASPxFormLayout>
                    <dx:ASPxPanel ID="BottomPanel" runat="server" FixedPosition="WindowBottom" BackColor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                    <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
                                        UseSubmitBehavior="false">
                                        <ClientSideEvents Click="OnUpdateClick" />
                                    </dx:ASPxButton>
                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </form>

    <!--#region Region Datasource-->
    <asp:SqlDataSource ID="countsheetheader" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:ObjectDataSource ID="countsheetdetailsubsi" runat="server" DataObjectTypeName="Entity.TRRSubsi" SelectMethod="getdetail" TypeName="Entity.TRRSubsi" UpdateMethod="UpdateTRRSubsi">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:QueryStringParameter Name="LineNumber" QueryStringField="linenumber" Type="String" />
            <asp:QueryStringParameter Name="TransType" QueryStringField="transtype" Type="String" />
            <asp:QueryStringParameter Name="refdocnum" QueryStringField="refdocnum" Type="String" />
            <asp:QueryStringParameter Name="ItemCode" QueryStringField="itemcode" Type="String" />
            <asp:QueryStringParameter Name="ColorCode" QueryStringField="colorcode" Type="String" />
            <asp:QueryStringParameter Name="ClassCode" QueryStringField="classcode" Type="String" />
            <asp:QueryStringParameter Name="SizeCode" QueryStringField="sizecode" Type="String" />
            <asp:QueryStringParameter Name="Warehouse" QueryStringField="warehouse" Type="String" />
            <asp:QueryStringParameter Name="ExpDate" QueryStringField="expdate" Type="String" />
            <asp:QueryStringParameter Name="MfgDate" QueryStringField="mfgdate" Type="String" />
            <asp:QueryStringParameter Name="BatchNo" QueryStringField="batchno" Type="String" />
            <asp:QueryStringParameter Name="LotNo" QueryStringField="lotno" Type="String" />
            <asp:QueryStringParameter Name="BulkQty" QueryStringField="bulkqty" Type="String" />
            <asp:QueryStringParameter Name="DocDate" QueryStringField="docdate" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="countsheetdetailsetup" runat="server" DataObjectTypeName="Entity.TRRSetup" SelectMethod="getdetail" TypeName="Entity.TRRSetup" UpdateMethod="UpdateTRRSetup">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:QueryStringParameter Name="LineNumber" QueryStringField="linenumber" Type="String" />
            <asp:QueryStringParameter Name="TransType" QueryStringField="transtype" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <%-- BOM DataSource --%>
    <asp:SqlDataSource ID="sdsBOM" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init" SelectCommand=""></asp:SqlDataSource>
    <asp:ObjectDataSource ID="odsBOM" runat="server" DataObjectTypeName="Entity.ProductionRouting+ProdRoutingStepBOM" TypeName="Entity.ProductionRouting+getStepProcessBOM" SelectMethod="getStepProcessBOM" InsertMethod="AddStepProcessBOM" UpdateMethod="UpdateStepProcessBOM" DeleteMethod="DeleteStepProcessBOM">
        <SelectParameters>
            <asp:SessionParameter Name="SKUCode" SessionField="SKUCode" Type="String" />
            <asp:SessionParameter Name="StepSequence" SessionField="StepSequence" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>

    <%-- Machine DataSource --%>
    <asp:SqlDataSource ID="sdsMachine" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand=""></asp:SqlDataSource>
    <asp:ObjectDataSource ID="odsMachine" runat="server" DataObjectTypeName="Entity.ProductionRouting+ProdRoutingStepMachine" TypeName="Entity.ProductionRouting+getStepProcessMachine" SelectMethod="getStepProcessMachine" InsertMethod="AddStepProcessMachine" UpdateMethod="UpdateStepProcessMachine" DeleteMethod="DeleteStepProcessMachine">
        <SelectParameters>
            <asp:QueryStringParameter Name="SKUCode" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="StepSequence" SessionField="StepSequence" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>

    <%-- Manpower DataSource --%>
    <asp:SqlDataSource ID="sdsManpower" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand=""></asp:SqlDataSource>
    <asp:ObjectDataSource ID="odsManpower" runat="server" DataObjectTypeName="Entity.ProductionRouting+ProdRoutingStepManpower" TypeName="Entity.ProductionRouting+getStepProcessManpower" SelectMethod="getStepProcessManpower" InsertMethod="AddStepProcessManpower" UpdateMethod="UpdateStepProcessManpower" DeleteMethod="DeleteStepProcessManpower">
        <SelectParameters>
            <asp:QueryStringParameter Name="SKUCode" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="StepSequence" SessionField="StepSequence" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
</body>
</html>
