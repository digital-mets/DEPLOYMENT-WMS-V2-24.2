<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmPRODWIPIN.aspx.cs" Inherits="GWL.frmPRODWIPIN" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>WIP IN </title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 600px; /*Change this whenever needed*/
        }

        .Entry {
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
        }

        .dxeButtonEditSys input,
        .dxeTextBoxSys input {
        }

        .pnl-content {
            text-align: right;
        }

        .mycheckbox input[type="checkbox"] 
        { 
            margin-left: -15px; 
        }
    </style>
    <!--#endregion-->

    <!--#region Region Javascript-->
    <script>

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        var entry = getParameterByName('entry');

        var isValid = false;
        var counterror = 0;
        var totalvat = 0;
        var totalnonvat = 0;




        var module = getParameterByName("transtype");
        var id = getParameterByName("docnumber");
        var entry = getParameterByName("entry");

        $(document).ready(function () {
            PerfStart(module, entry, id);
            cp.PerformCallback('docdate');
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

        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            var btnmode = btn.GetText(); //gets text of button
            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }
            console.log(isValid + ' ' + counterror);
            isValid = true;
            if (isValid || btnmode == "Close") { //check if there's no error then proceed to callback
                //if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
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
                console.log(counterror);
            }


        }

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        var vatrate = 0;
        var atc = 0

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
            if (s.cp_generated) {
                delete (s.cp_generated);
                console.log('daan')
                autocalculate();
                // cp.PerformCallback('vat');
            }

            if (s.cp_vatdetail != null) {
                totalvat = s.cp_vatdetail;
                delete (s.cp_vatdetail);
                txtgross.SetText(totalvat);
                console.log('vat');
            }

            if (s.cp_nonvatdetail != null) {
                totalnonvat = s.cp_nonvatdetail;
                delete (s.cp_nonvatdetail);
                txtnonvat.SetText(totalnonvat);
            }
            if (s.cp_vatrate != null) {

                vatrate = s.cp_vatrate;
                var vatdetail1 = 1 + parseFloat(vatrate);

                txtVatAmount.SetText(((txtgross.GetText() / vatdetail1) * vatrate).toFixed(2))
            }
            if (s.cp_atc != null) {

                atc = s.cp_atc;

                txtWithHoldingTax.SetText(((txtgross.GetText() - txtVatAmount.GetText()) * atc).toFixed(2))
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
            if (entry == "V") {
                e.cancel = true; //this will made the gridview readonly
            }
            if (entry != "V") {
                if (e.focusedColumn.fieldName === "SizeCode" || e.focusedColumn.fieldName === "SVOBreakdown") { //Check the column name
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

        }

        function UpdateProductName(value) {
            var Desc = value[1];
            console.log(Desc);
            txtProductName.SetText(Desc);

        }

        function autocalculate(s, e) {
            //console.log(txtNewUnitCost.GetValue());
            OnInitTrans();
            var qty = 0.00;

            var totalqty = 0.00






            setTimeout(function () {
                for (var i = 0; i < gv1.GetVisibleRowsOnPage() ; i++) {


                    qty = gv1.batchEditApi.GetCellValue(i, "Qty");


                    totalqty += qty * 1.00;




                }



                if (isNaN(totalqty) == true) {
                    totalqty = 0;
                }

                txttotalqty.SetText(totalqty);
                //   cp.PerformCallback('vat')
            }, 500);
        }
        function detailautocalculate(s, e) {
            //console.log(txtNewUnitCost.GetValue());

            var freight = 0.00;
            var totalqty = 0.00

            var totalfreight = 0.00;

            if (txtTotalFreight.GetText() == null || txtTotalFreight.GetText() == "") {
                freight = 0;
            }
            else {
                freight = txtTotalFreight.GetText();
            }

            if (txttotalqty.GetText() == null || txttotalqty.GetText() == "") {
                totalqty = 0;
            }
            else {
                totalqty = txttotalqty.GetText();
            }


            setTimeout(function () {
                for (var i = 0; i < gv1.GetVisibleRowsOnPage() ; i++) {





                    gv1.batchEditApi.SetCellValue(i, "UnitFreight", (freight / totalqty).toFixed(2));

                    //totalvat += vat;
                }






            }, 500);
        }


        var gl_objName = "";
        var gl_sdsName = "";
        var gl_sqlcmd = "";
        function gridLookup_Data() {
            //emc2021
            var gridLookupName = gl_objName;
            var ListName2 = hgridlookup.GetText();
            if (ListName2.indexOf(gridLookupName) === -1) {

                hgridlookup.SetText("" + ListName2 + gridLookupName + ",");

                cp.PerformCallback('sds|' + gl_sdsName + "|" + gl_sqlcmd + "|" + gl_objName);

                //console.log(" get data " + ListName2 + "," + txtBatchNo);

            }

            //console.log('sds|' + gl_sdsName + "|" + gl_sqlcmd + "|" + gl_objName);

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
            setTimeout(function () {
                gv1.batchEditApi.EndEdit();
            }, 500);
        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields/index 0 is from the commandcolumn)
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                if (column != s.GetColumn(1) && column != s.GetColumn(2) && column != s.GetColumn(3)
                    && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15)
                    && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18)
                    && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21)
                    && column != s.GetColumn(22) && column != s.GetColumn(23)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                        console.log(column);
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
                CSheet.SetContentUrl('frmCountSheet.aspx?entry=' + entry + '&docnumber=' + docnumber + '&transtype=' + transtype +
                    '&linenumber=' + linenum);
            }
            if (e.buttonID == "Delete") {
                gv1.DeleteRow(e.visibleIndex);
                autocalculate(s, e);

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


        //function endcp(s, e) {
        //    var endg = s.GetGridView().cp_endgl1;
        //    if (endg == true) {
        //        console.log(endg);
        //        sup_cp_Callback.PerformCallback(glSupplierCode.GetValue().toString());
        //        e.processOnServer = false;
        //        endg = null;
        //    }
        //}

        function endcp2(s, e) {
            var endg = s.cp_endgl1;

            console.log('endg2');
            cp.PerformCallback('RR');
            e.processOnServer = false;
            endg = null;

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

        }

        var PutDetailIdx = 0;
        var PutObj;
        var PutGridUse;
        var PutColName;
        var PutValueIndex;

        function PutGridCol(selectedValues) {

            //console.log("PutDetailIdx : " + PutDetailIdx);

            var idx1 = 0
            switch (PutDetailIdx) {
                case 1:
                    //gv1 Raw Material detail

                    //gv1.batchEditApi.EndEdit();
                    for (idx1 = 0; idx1 < PutColName.length; idx1++) {
                        //console.log("idx " + idx1 + " ColName " + PutColName[idx1] + " idx: " + PutValueIndex[idx1] + " value: " + selectedValues[PutValueIndex[idx1]]);
                        //gv1.batchEditApi.SetCellValue(index, PutColName[idx1], selectedValues[PutValueIndex[idx1]]);

                        if (PutColName[idx1] === "Hskucode") {
                            txtskucode.SetText(selectedValues[PutValueIndex[idx1]]);
                        }

                    }

                    break;
                    //case 2:
                    //    //gvservice Spices Detail
                    //    gvService.batchEditApi.EndEdit();
                    //    for (idx1 = 0; idx1 < PutColName.length; idx1++) {
                    //        //console.log("idx " + idx1 + " ColName " + PutColName[idx1] + " idx: " + PutValueIndex[idx1] + " value: " + selectedValues[PutValueIndex[idx1]]);
                    //        gvService.batchEditApi.SetCellValue(index, PutColName[idx1], selectedValues[PutValueIndex[idx1]]);
                    //    }

                    //    break;
                    //case 3:
                    //    //gvscrap Scrap Detail
                    //    gvScrap.batchEditApi.EndEdit();
                    //    for (idx1 = 0; idx1 < PutColName.length; idx1++) {
                    //        //console.log("idx " + idx1 + " ColName " + PutColName[idx1] + " idx: " + PutValueIndex[idx1] + " value: " + selectedValues[PutValueIndex[idx1]]);
                    //        gvScrap.batchEditApi.SetCellValue(index, PutColName[idx1], selectedValues[PutValueIndex[idx1]]);
                    //    }

                    //    break;

            }
        }




    </script>
    <!--#endregion-->
</head>
<body style="height: 910px;">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" ID="FormTitle"  Text="WIP IN" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        &nbsp;<br />
        <br />
        <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None"
            EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="90"
            ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
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
            <ClientSideEvents CloseUp="function (s, e) { window.location.reload(); }" />
        </dx:ASPxPopupControl>

        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" Style="margin-left: -20px" SettingsAdaptivity-AdaptivityMode="SingleColumnWindowLimit" SettingsAdaptivity-SwitchToSingleColumnAtWindowInnerWidth="800">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px" OnLoad="TextboxLoad" AutoCompleteType="Disabled" Enabled="False">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnLoad="Date_Load" OnInit="dtpDocDate_Init" Width="170px">
                                                            <ClientSideEvents Validation="OnValidation" 
                                                                ValueChanged="function (s, e){ cp.PerformCallback('docdate');  e.processOnServer = false;}" 
                                                                 />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>




                                            <dx:LayoutItem Caption="Work Week" Name="txtWorkWeek">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtWorkWeek" runat="server" Width="170px" ReadOnly="true" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Production Site" Name="prodsite">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="hprodsite" ClientInstanceName="hprodsite" runat="server"
                                                            OnInit="lookup_Init"
                                                            DataSourceID="sdsSite" KeyFieldName="Code" TextFormatString="{0}" Width="170px" OnLoad="gvLookupLoad">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="Code" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="Description" Settings-AutoFilterCondition="Contains" />

                                                            </Columns>
                                                            
                                                          <%-- <ClientSideEvents
                                                                DropDown="function(){ 
                                                                               
                                                                              gl_objName = 'hprodsite';
                                                                              gl_sdsName = 'sdsSite';
                                                                              gl_sqlcmd = 'SELECT ProductClassCode as Code,Description FROM Masterfile.ProductClass';
                                                                             
                                                                              gridLookup_Data();

                                                                              }"
                                                              />--%>
                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:LayoutItem Caption="Production Date" name="txtPD">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                          <dx:ASPxDateEdit ID="txtPD" runat="server" OnLoad="Date_Load"  Width="170px">
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Shift" Name="Shift">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="Shift" ClientInstanceName="Shift" runat="server"
                                                            OnInit="lookup_Init"
                                                            DataSourceID="sdsShift" KeyFieldName="ShiftCode" TextFormatString="{0}" Width="170px" OnLoad="gvLookupLoad">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="ShiftCode" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="ShiftName" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>

                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                                <dx:LayoutItem Caption="SKU Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <%--<dx:ASPxTextBox ID="txtskucode" ClientInstanceName="txtskucode" runat="server" Width="170px" ReadOnly="true" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>--%>

                                                        <dx:ASPxGridLookup ID="txtskucode" ClientInstanceName="SkuCode" runat="server"
                                                            OnInit="lookup_Init"
                                                            DataSourceID="sdsSKUCode" KeyFieldName="SKUCode" TextFormatString="{0}" Width="170px" OnLoad="gvLookupLoad">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="SKUCode" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="ProductName" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>
                                                            <ClientSideEvents
                                                                DropDown="function(){ 
                                                                   
                                                                    var PD = '\'' + document.getElementById('cp_frmlayout1_PC_0_txtPD_I').value +'\'';
                                                                    console.log('PD:');
                                                                    console.log(PD);
                                                                 var CPMLI = '\'CP-MLI\'';
                                                                
                                                                 

                                                                              gl_objName = 'txtskucode';
                                                                              gl_sdsName = 'sdsSKUCode';

                                                                             

                                                                 if (PD == '' || PD == null || PD == undefined){
                                                                              gl_sqlcmd = 'select A.ItemCode AS SKUCode, B.ProductName	from production.CounterPlanDetail A left join Masterfile.FGSKU B ON A.ItemCode = B.SKUCode';
                                                                              }
                                                                 else {
                                                                	
                                                                              gl_sqlcmd = 'Declare @PDWorkWeek varchar(50) SELECT @PDWorkWeek = DATEPART(WW,'+ PD +') 	Declare @PDYear varchar(50) SELECT @PDYear = DATEPART(YEAR,' + PD +') select A.ItemCode AS SKUCode, B.ProductName	from production.CounterPlanDetail A left join Masterfile.FGSKU B ON A.ItemCode = B.SKUCode where A.Docnumber = '+ CPMLI +' + @PDYear + @PDWorkWeek';
                                                                              }
                                                                         console.log(gl_sqlcmd);     
                                                                              gridLookup_Data();

                                                                              }" 
                                                                ValueChanged="function(s,e){ 
                                                                        var g = SkuCode.GetGridView();
                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'SKUCode;ProductName', UpdateProductName)}"
                                                                
                                                                />
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Product Description" name="txtProductName">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtProductName" runat="server" Width="170px" OnLoad ="TextboxLoad" ClientInstanceName="txtProductName">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                        

                                            <dx:LayoutItem Caption="Stuffing machine Number used  " Name="glStuffingMach">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                       <%-- <dx:ASPxGridLookup ID="glStuffingMach" ClientInstanceName="glStuffingMach" runat="server"
                                                            OnInit="lookup_Init"
                                                            DataSourceID="sdsStuffing" KeyFieldName="MachineName" TextFormatString="{0}" Width="170px" OnLoad="gvLookupLoad">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="MachineName" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="Description" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>

                                                        </dx:ASPxGridLookup>--%>

                                                        <dx:ASPxSpinEdit ID="glStuffingMach" runat="server" Width="170px" 
                                                            ReadOnly="false" ClientInstanceName="glStuffingMach" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"
                                                            AllowMouseWheel="false" HorizontalAlign="Right" OnLoad="SpinEdit_Load">
                                                        </dx:ASPxSpinEdit>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Spiral Machine Used" Name="glSpiralMach">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <%--<dx:ASPxGridLookup ID="glSpiralMach" ClientInstanceName="glSpiral" runat="server"
                                                            OnInit="lookup_Init"
                                                            DataSourceID="sdsSpiral" KeyFieldName="MachineName" TextFormatString="{0}" Width="170px" OnLoad="gvLookupLoad">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="MachineName" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="Description" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>

                                                        </dx:ASPxGridLookup>--%>
                                                        <dx:ASPxSpinEdit ID="glSpiralMach" runat="server" Width="170px" 
                                                            ReadOnly="false" ClientInstanceName="glSpiralMach" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"
                                                            AllowMouseWheel="false" HorizontalAlign="Right" OnLoad="SpinEdit_Load">
                                                        </dx:ASPxSpinEdit>


                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Blast Machine Used" Name="txtBlastMachine">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtBlastMachine" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Loaded By" name="txtLoadedBy">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLoadedBy" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>




                                            

                                             <dx:LayoutItem Caption="Checked By" name="txtCheckedBy">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCheckedBy" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Machine Speed" Name="txtMachSpeed">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtMachSpeed" runat="server" Width="170px" ReadOnly="true" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:LayoutItem Caption="Time Started" name="TimeStarted">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeStarted" runat="server" DateTime="2009/11/01 15:31:34" Width="100">

                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Step Sequence" Name="stepseq">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="hstepseq" ClientInstanceName="hstepseq" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



                                            <dx:LayoutItem Caption="Year" Name="txtYear">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtYear" runat="server" Width="170px" ReadOnly="true" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            

                                            <dx:LayoutItem Caption="DayNo" Name="txtDayNo">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDayNo" runat="server" Width="170px" ReadOnly="true" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Batch No">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                   
                                                       <%-- <dx:ASPxSpinEdit ID="txtBatchNo" runat="server" Width="170px" 
                                                            ReadOnly="false" ClientInstanceName="NumStrands" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"
                                                            AllowMouseWheel="false" HorizontalAlign="Right" OnLoad="SpinEdit_Load">
                                                        </dx:ASPxSpinEdit>
                                                          --%>

                                                        <dx:ASPxTextBox ID="txtBatchNo" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>

                                                    </dx:LayoutItemNestedControlContainer>

                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            

                                             <dx:LayoutItem Caption="Time Finised" name="TimeFinished">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeFinished" runat="server" DateTime="2009/11/01 15:31:34" Width="100">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="QUALITY CHECK" Name="HeadQuality" CaptionStyle-Font-Bold="true">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer >
                                                       
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Plan Qty" Name="txtPlanQty">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPlanQty" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Actual Qty" Name="txtActualQty">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActualQty" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>




                    <%--Weighing --%>

                                             <dx:LayoutItem Caption="Number of Strands per cart " Name="NumStrands">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="NumStrands" runat="server" Width="170px" 
                                                            ReadOnly="false" ClientInstanceName="NumStrands" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"
                                                            AllowMouseWheel="false" HorizontalAlign="Right" OnLoad="SpinEdit_Load">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Stick properly" Name="cbQCStick" Width="100">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                
                                                                <dx:ASPxCheckBox ID="cbQCStick" runat="server" ClientInstanceName="cbQCStick" CheckState="Unchecked" OnLoad="CheckBoxLoad" Text="YES" >
                                                                    <ClientSideEvents CheckedChanged="function(s, e) {cbQCStickNo.SetChecked(!s.GetChecked()); }" />
                                                                </dx:ASPxCheckBox>
                                                                <dx:ASPxCheckBox ID="cbQCStickNo" runat="server" ClientInstanceName="cbQCStickNo" CheckState="Unchecked" OnLoad="CheckBoxLoad" Text="NO">
                                                                 <ClientSideEvents CheckedChanged="function(s, e) {cbQCStick.SetChecked(!s.GetChecked()); }" />
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            


                                            <dx:LayoutItem Caption="Weight of smoke cart" name="txtWeightSmokecart">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtWeightSmokecart" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:LayoutItem Caption="Hotdog properly arranged" Name="cbQCHotdog">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="cbQCHotdog" runat="server" ClientInstanceName="cbQCHotdog" CheckState="Unchecked" OnLoad="CheckBoxLoad" Text="YES"  CssClass="mycheckbox">
                                                                     <ClientSideEvents CheckedChanged="function(s, e) {cbQCHotdogNo.SetChecked(!s.GetChecked()); }" />
                                                                </dx:ASPxCheckBox>

                                                                <dx:ASPxCheckBox ID="cbQCHotdogNo" runat="server"  ClientInstanceName="cbQCHotdogNo" CheckState="Unchecked" OnLoad="CheckBoxLoad" Text="NO">
                                                                     <ClientSideEvents CheckedChanged="function(s, e) {cbQCHotdog.SetChecked(!s.GetChecked()); }" />
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Weight before Cooking" name="txtWeightbefore">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtWeightbefore" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



 

                                           

                                             <dx:layoutitem caption="unlink /untwist" name="cbQCfreefrom">
                                                        <layoutitemnestedcontrolcollection>
                                                            <dx:layoutitemnestedcontrolcontainer runat="server">
                                                                <dx:aspxcheckbox id="cbQCfreefrom" runat="server" ClientInstanceName="cbQCfreefrom" checkstate="unchecked" OnLoad="CheckBoxLoad" Text="YES">
                                                                     <ClientSideEvents CheckedChanged="function(s, e) {cbQCfreefromNo.SetChecked(!s.GetChecked()); }" />
                                                                </dx:aspxcheckbox>

                                                                <dx:aspxcheckbox id="cbQCfreefromNo" runat="server" ClientInstanceName="cbQCfreefromNo" checkstate="unchecked" OnLoad="CheckBoxLoad" Text="NO">
                                                                <ClientSideEvents CheckedChanged="function(s, e) {cbQCfreefrom.SetChecked(!s.GetChecked()); }" />
                                                                </dx:aspxcheckbox>
                                                            </dx:layoutitemnestedcontrolcontainer>
                                                        </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>   
                                            
                                            

                            <%--Blast Freeze--%>
                                            <dx:LayoutItem Caption="Time Switch On" name="TimeOn">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeOn" runat="server" DateTime="2009/11/01 15:31:34" Width="100">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>

                                            </dx:LayoutItem>

                                              <dx:LayoutItem Caption="No of Packs " Name="NumPacks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="NumPacks" runat="server" Width="170px" 
                                                            ReadOnly="false" ClientInstanceName="NumPacks" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right" OnLoad="SpinEdit_Load">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Time Switch Off" name="TimeOff">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeOff" runat="server" DateTime="2009/11/01 15:31:34" Width="100">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                                 <dx:LayoutItem Caption="Boxed By" name="txtMonitoredBy">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtMonitoredBy" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Blast Temp" name="txtBlastTemp">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtBlastTemp" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            
                                            

                                            


                                            
                                           


            <%--    Spiral Freeze--%>

                                            


                                             <dx:LayoutItem Caption="No of Packs" Name="QtyPacks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="QtyPacks" runat="server" Width="170px" 
                                                            ReadOnly="false" ClientInstanceName="QtyPacks" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right" OnLoad="SpinEdit_Load">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="No Loose Packs" Name="QtyLoosePacks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="QtyLoosePacks" runat="server" Width="170px" 
                                                            ReadOnly="false" ClientInstanceName="QtyLoosePacks" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right" OnLoad="SpinEdit_Load">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                           


                                            



                                            <dx:LayoutItem Caption="IT Prior Loading" Name="IntTempPL">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="IntTempPL" runat="server" Width="170px" 
                                                            ReadOnly="false" ClientInstanceName="IntTempPL" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right" OnLoad="SpinEdit_Load">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:LayoutItem Caption="Room Temp" Name="StdRoomTemp">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="StdRoomTemp" runat="server" Width="170px" 
                                                            ReadOnly="false" ClientInstanceName="StdRoomTemp" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right" OnLoad="SpinEdit_Load">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                             <dx:LayoutItem Caption="QA VALIDATION" Name="QAVal" Width="200%" CaptionStyle-Font-Bold="true">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer >
                                                       
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Spiral Temp" name="txtQAVSpiral">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtQAVSpiral" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="IT Prior Loading" name="txtQAVPLoad">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtQAVPLoad" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="QA Val- Validated By" name="txtQAVValBy">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtQAVValBy" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>






                                            



                                            
                                            

                                       


                                            


                                             <dx:LayoutItem Caption="Remarks" Name="txtRemarks" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRemarks" runat="server" OnLoad="TextboxLoad" Width="200%">
                                                        </dx:ASPxTextBox>
                                                       
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Remarks" Name="MemoRemarks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <%--<dx:ASPxTextBox ID="txtRemarks" runat="server"  OnLoad="TextboxLoad"  Width="300px">
                                                             </dx:ASPxTextBox>--%>
                                                        <dx:ASPxMemo ID="MemoRemarks" ClientInstanceName="txtRemarks" runat="server" Height="50px" Width="570px">  
                                                            <%--<ClientSideEvents Init="OnMemoInit" />  --%>
                                                        </dx:ASPxMemo>  


                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                             <dx:LayoutItem Caption="Step Process" Name="txtStepCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtStepCode" ClientInstanceName="txtStepCode" runat="server"
                                                            OnInit="lookup_Init"
                                                            DataSourceID="sdsStep" KeyFieldName="StepCode" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="StepCode" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>
<%--                                                            <ClientSideEvents
                                                                DropDown="function(){ 
                                                                               
                                                                              gl_objName = 'txtStepCode';
                                                                              gl_sdsName = 'sdsStep';
                                                                              gl_sqlcmd = 'SELECT StepCode FROM Masterfile.Step';
                                                                             
                                                                              gridLookup_Data();

                                                                              }" />--%>

                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                           <dx:LayoutItem Caption="GridLookup"  ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="hgridlookup"  ClientInstanceName="hgridlookup" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             










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

                                    <dx:LayoutGroup Caption="Audit Trail" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Added By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">

                                                        <dx:ASPxTextBox ID="txtHAddedBy" runat="server" ReadOnly="True" Width="170px">
                                                            <ClientSideEvents Validation="function (s,e)
                                                                {
                                                                 OnValidation = true;
                                                                }" />
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
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" Width="170px" ReadOnly="true">
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
                                                        <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledDate" runat="server" Width="170px" ReadOnly="true">
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
                                                        <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="608px" ClientInstanceName="gvRef" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber">
                                                            <%--<Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="130" VerticalScrollBarMode="Auto" />--%>
                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" />
                                                            <ClientSideEvents Init="OnInitTrans" />
                                                            <SettingsPager PageSize="5">
                                                            </SettingsPager>
                                                            <SettingsEditing Mode="Batch">
                                                            </SettingsEditing>
                                                            <SettingsBehavior FilterRowMode="OnClick" ColumnResizeMode="NextColumn" />
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
                            <%--                   <dx:LayoutGroup Caption="Amount" ColCount="2">
                                     

                            </dx:LayoutGroup>--%>
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
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </form>
    <!--#region Region Datasource-->
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.ReceivingReport" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.ReceivingReport" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.PRODWIPIN+WIClassBreakDown" SelectMethod="getdetail" UpdateMethod="UpdateWIClassBreakDown" TypeName="Entity.PRODWIPIN+WIClassBreakDown" DeleteMethod="DeleteWIClassBreakDown" InsertMethod="AddWIClassBreakDown">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:SqlDataSource ID="sdsStep" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="
        SELECT StepCode FROM Masterfile.Step  
        "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsSite" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="   SELECT ProductClassCode as Code,Description FROM Masterfile.ProductClass    "
        OnInit="Connection_Init"></asp:SqlDataSource>

     <asp:SqlDataSource ID="sdsStuffing" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="    select MachineID as MachineName,Description from masterfile.Machinemaster where MachineCategory = 'STUFFING' "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsSpiral" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="    select MachineID as MachineName,Description from masterfile.Machinemaster where MachineCategory = 'SPIRAL FREEZER' "
        OnInit="Connection_Init"></asp:SqlDataSource>


       <asp:SqlDataSource ID="sdsShift" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="select ShiftCode,ShiftName from masterfile.Shift  "
        OnInit="Connection_Init"></asp:SqlDataSource>

  
    
    <asp:SqlDataSource ID="sdsSKUCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand= " "
        
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsBatch" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand= " "
        
        OnInit="Connection_Init"></asp:SqlDataSource>



    <!--#endregion-->
</body>
</html>


