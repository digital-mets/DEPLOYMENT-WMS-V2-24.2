<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmProdWIPOut.aspx.cs" Inherits="GWL.frmProdWIPOut" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>WIP Out</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 250px; /*Change this whenever needed*/
        }

        .Entry {
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
        }

        .dxeButtonEditSys input,
        .dxeTextBoxSys input {
            text-transform: uppercase;
        }

        .pnl-content {
            text-align: right;
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
        var useparam = getParameterByName("parameters");
        var isValid = false;
        var counterror = 0;
        var totalvat = 0;
        var totalnonvat = 0;



        var module = getParameterByName("transtype");
        var id = getParameterByName("docnumber");
        var entry = getParameterByName("entry");

        $(document).ready(function () {
            PerfStart(module, entry, id);

            switch (useparam) {
                case "TIPIN":
                    document.title = "Unfinished WIP OUT (TIP IN)";
                    break;
                case "FINAL":
                    document.title = "FINAL WIP OUT";
                    break;
                case "OUT":
                    document.title = "WIP OUT";
                    break;
            }

        });

        function OnValidation(s, e) { //Validation function for header controls (Set this for each header controls)

            isValid = true;

            //if (s.GetText() == "" || e.value == "" || e.value == null) {
            //    counterror++;
            //    isValid = false
            //    s.GetMainElement().style.color = 'Pink';
            //    console.log(s);
            //}
            //else {
            //    isValid = true;
            //}
        }

        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            var btnmode = btn.GetText(); //gets text of button
            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }
            console.log(isValid + ' ' + counterror);
            //emc999



            if (isValid || btnmode == "Close") { //check if there's no error then proceed to callback
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

        function OnQtyValidate(s, e) {
            if (s.GetValue() == 0 || e.value == 0 || e.value == null)
                e.isValid = false;
            else
                e.isValid = true;
        }

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        var vatrate = 0;
        var atc = 0
        var atc = 0
        var vatdetail1 = 0.00
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
            //if (s.cp_generated) {
            //    delete (s.cp_generated);
            //    console.log('daan')
            //    autocalculate();
            //    // cp.PerformCallback('vat');
            //}


            if (s.cp_vatdetail != null) {
                totalvat = s.cp_vatdetail;
                delete (s.cp_vatdetail);
                txtGrossVATableAmount.SetValue(totalvat);
                console.log('vat');
            }

            //if (s.cp_nonvatdetail != null) {
            //    totalnonvat = s.cp_nonvatdetail;
            //    delete (s.cp_nonvatdetail);
            //    txtnonvat.SetText(totalnonvat);
            //}
            //if(s.cp_vatrate !=null)
            //{
            //    console.log('amount')
            //    vatrate = s.cp_vatrate;
            //     vatdetail1 = 1 + parseFloat(vatrate);

            //    txtVatAmount.SetText(((txtGrossVATableAmount.GetText() / vatdetail1) * vatrate).toFixed(2))
            //}
            //if (s.cp_atc != null) {

            //    atc = s.cp_atc;

            //    txtWithHoldingTax.SetText(((txtGrossVATableAmount.GetText() - txtVatAmount.GetText()) * atc).toFixed(2))
            //}

            if (s.cp_isclassa == "1") {

                autocalculate(s, e)
                generate1 = true;

            }
            else {

                autocalculate(s, e)
                generate1 = false;
            }

            if (s.cp_generated) {
                delete (s.cp_generated);
                //console.log('test');
                //BATCH DETAIL
                gv1.CancelEdit();
                var _indices = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < _indices.length; i++) {
                    gv1.DeleteRow(_indices[i]);
                }

                var _refindices = gv3.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < _refindices.length; i++) {
                    gv1.AddNewRow();
                    _indices = gv1.batchEditApi.GetRowVisibleIndices();

                    gv1.batchEditApi.SetCellValue(_indices[0], 'SmokeHouseNo', gv3.batchEditApi.GetCellValue(_refindices[i], 'SmokeHouseNo'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'BatchNo', gv3.batchEditApi.GetCellValue(_refindices[i], 'BatchNo'));

                    //gv1.batchEditApi.SetCellValue(_indices[0], 'ITAcooking', gv3.batchEditApi.GetCellValue(_refindices[i], 'ITAcooking'));


                    gv1.batchEditApi.EndEdit();
                    //END BATCH DETAIL
                }
                 //COOKING DETAIL


                    gv2.CancelEdit();
                    var _indices = gv2.batchEditApi.GetRowVisibleIndices();

                    for (var i = 0; i < _indices.length; i++) {
                        gv2.DeleteRow(_indices[i]);
                    }

                    var _refindices = gv4.batchEditApi.GetRowVisibleIndices();

                    for (var i = 0; i < _refindices.length; i++) {
                        gv2.AddNewRow();
                        _indices = gv2.batchEditApi.GetRowVisibleIndices();

                        gv2.batchEditApi.SetCellValue(_indices[0], 'CookingStage', gv4.batchEditApi.GetCellValue(_refindices[i], 'CookingStage'));
                        console.log(gv4.batchEditApi.GetCellValue(_refindices[i], 'CookingStage'));
                        //gv2.batchEditApi.SetCellValue(_indices[0], 'STDcooking', gv4.batchEditApi.GetCellValue(_refindices[i], 'STDcooking'));

                        //gv2.batchEditApi.SetCellValue(_indices[0], 'TimeStart', gv4.batchEditApi.GetCellValue(_refindices[i], 'TimeStart'));
                        //gv2.batchEditApi.SetCellValue(_indices[0], 'TimeEnd', gv4.batchEditApi.GetCellValue(_refindices[i], 'TimeEnd'));
                        //gv2.batchEditApi.SetCellValue(_indices[0], 'StdST', gv4.batchEditApi.GetCellValue(_refindices[i], 'StdST'));
                        //gv2.batchEditApi.SetCellValue(_indices[0], 'ActualST', gv4.batchEditApi.GetCellValue(_refindices[i], 'ActualST'));
                        //gv2.batchEditApi.SetCellValue(_indices[0], 'StdH', gv4.batchEditApi.GetCellValue(_refindices[i], 'StdH'));
                        //gv2.batchEditApi.SetCellValue(_indices[0], 'ActualH', gv4.batchEditApi.GetCellValue(_refindices[i], 'ActualH'));

                

                        gv2.batchEditApi.EndEdit();
                        //END COOKING DETAIL
                    //console.log('test ok');
                }
            }

        }

        function UpdateCooking(values) {
            Cooking = values[0];
            //console.log(Cooking);
            //gv1.batchEditApi.SetCellValue(index, "CookingStage", values[0]);


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

                if (e.focusedColumn.fieldName === "ClassCode") {
                    gl3.GetInputElement().value = cellInfo.value;


                }

                if (e.focusedColumn.fieldName === "CookingStage") { //Check the column name
                    glCookingstage.GetInputElement().value = cellInfo.value; //Gets the column value
                    console.log('dito');
                    closing = true;
                    valchange = true;

                }
            }
        }
        function UpdateProductName(value) {
            var Desc = value[1];
            console.log(Desc);
            txtProductName.SetText(Desc);

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
            //if (currentColumn.fieldName === "CookingStage") {
            //    cellInfo.value = glCookingstage.GetValue();
            //    cellInfo.text = glCookingstage.GetText();
            //    console.log('dahil d');
            //}

        }


        function autocalculate(s, e) {
            //console.log(txtNewUnitCost.GetValue());


            var qty = 0.00;

            var totalqty = txttotalqty.GetValue();

            var wop = 0.00
            var exchangerate = 0.00
            var NonVatAmount = 0.00
            var GrossVatamount = 0.00
            var VatAmount = 0.00
            var WithHolding = 0.00
            var VatRate = 0.00
            var Atc = 0.00
            //RA

            exchangerate = txtexchangerate.GetValue();




            wop = txtWOP.GetValue();







            Atc = txtAtc.GetValue();

            setTimeout(function () {




                if (txtVatRate.GetValue() == 0) {
                    NonVatAmount = totalqty * wop * exchangerate
                    GrossVatamount = 0.00
                }
                else {
                    GrossVatamount = parseFloat(totalqty * wop * exchangerate);

                    NonVatAmount = 0.00

                }

                //  txtVatAmount.SetText(VATAmount.format(2, 3, ',', '.'));



                txtGrossVATableAmount.SetValue(GrossVatamount.toFixed(2))
                txtnonvat.SetValue((NonVatAmount).toFixed(2))

                // txttotalqty.SetText(totalqty);
                txtForeignAmount.SetValue((totalqty * wop * exchangerate).toFixed(2));
                txtTotalAmount.SetValue((totalqty * wop).toFixed(2))
                vatdetail1 = 1 + parseFloat(txtVatRate.GetValue());

                var value = (GrossVatamount / vatdetail1) * txtVatRate.GetValue();

                txtVatAmount1.SetValue(value.toFixed(2));
                txtWithHoldingTax.SetValue(((GrossVatamount - value) * Atc).toFixed(2))

            }, 500);
        }



        function lookup(s, e) {
            if (isSetTextRequired) {//Sets the text during lookup for item code
                s.SetText(s.GetInputElement().value);
                isSetTextRequired = false;
            }
        }

        //var preventEndEditOnLostFocus = false;
        function gridLookup_KeyDown(s, e) { //Allows tabbing between gridlookup on details

        }



        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.

        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields/index 0 is from the commandcolumn)

        }


        function OnCustomClick(s, e) {
            if (e.buttonID == "Delete") {
                gvclass.DeleteRow(e.visibleIndex);
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
            gvJournal.SetWidth(width - 120);
            gvTemp.SetWidth(width - 120);
            //gv1.SetWidth(width - 120);
            //gv2.SetWidth(width - 120);
        }
        function checkedchanged(s, e) {
            var checkState = cbiswithdr.GetChecked();
            if (checkState == true) {
                cp.PerformCallback('isclassatrue');
                e.processOnServer = false;

            }
            else {
                cp.PerformCallback('isclassafalse');
                e.processOnServer = false;


            }
        }

        var gl_objName = "";
        var gl_sdsName = "";
        var gl_sqlcmd = "";
        function gridLookup_Data()
        {
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

        function gridLookup_DropDown(s, e) {
            //emc2021
            var gridLookupName = txtBatchNo.globalName;
            var ListName2 = hgridlookup.GetText();
            if(ListName2.indexOf(gridLookupName) === -1)
            {
                hgridlookup.SetText("" + ListName2 + gridLookupName + ",");

                cp.PerformCallback('batchno');

                console.log(" get data " + ListName2 + "," + txtBatchNo);

            }
            //console.log(" s " + s.name + " sds " + );
            console.log("use: "+ txtBatchNo.globalName);
            console.log(txtBatchNo);

            
            //cp.PerformCallback('batchno');
        }

        function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);

            if(keyCode = 63)
            {
                cp.PerformCallback('batchno');
            }

            //alert("keycode :" + keyCode);
            //if (keyCode == ASPxKey.ke) {
            //    //gv1.batchEditApi.EndEdit();
         
            //}
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

                        if(PutColName[idx1] === "Hskucode")
                        {
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
            //PutGridUse.batchEditApi.SetCellValue(index, PutColName, selectedValues[PutValueIndex]);
            //gvService.batchEditApi.SetCellValue(index, "CustomerCode", selectedValues[0]);
        }




        function Generates(s, e) {
            var prtext = document.getElementById("cp_frmlayout1_PC_0_txtskucode_I").value;
            if (!prtext) { alert('No SKUCode to generate!'); return; }
            var generate = confirm("Are you sure you want to generate these SKUCode");
            if (generate) {
                cp.PerformCallback('Generates');
                e.processOnServer = false;
            }

        }

    </script>
    <!--#endregion-->
</head>
<body style="height: 250px; overflow: auto;">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="false" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" ID="FormTitle" Text="WIP Out" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
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

        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" HeighSKUt="300px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="300px" Width="850px" Style="margin-left: -20px" SettingsAdaptivity-AdaptivityMode="SingleColumnWindowLimit" SettingsAdaptivity-SwitchToSingleColumnAtWindowInnerWidth="800">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Type" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="cmbType" Width="170px" runat="server" OnLoad="Comboboxload">
                                                            <Items>
                                                                <dx:ListEditItem Text="Normal Out" Value="Normal Out" />
                                                                <dx:ListEditItem Text="Adjustment" Value="Adjustment" />
                                                            </Items>
                                                            <ClientSideEvents ValueChanged="function(s,e){
                                                                  cp.PerformCallback('Type');
                                                                   e.processOnServer = false;
                                                                }" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


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

                                             <dx:LayoutItem Caption="Work Week">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtWorkWeek" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

<%--                                            <dx:LayoutItem Caption="Step Process">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStepCode" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>


                                            <dx:LayoutItem Caption="Step Process" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtStepCode" ClientInstanceName="txtStepCode" runat="server"
                                                            DataSourceID="sdsStep" KeyFieldName="StepCode" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="StepCode" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>
                                                             <%--<ClientSideEvents 
                                                                    DropDown="function(){ 
                                                                               
                                                                              gl_objName = 'txtStepCode';
                                                                              gl_sdsName = 'sdsStep';
                                                                              gl_sqlcmd = 'SELECT StepCode FROM Masterfile.Step';
                                                                             
                                                                              gridLookup_Data();

                                                                              }"
                                                                />--%>

                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Production Site" Name="prodsite">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="hprodsite" ClientInstanceName="hprodsite" runat="server"
                                                            DataSourceID="sdsSite" KeyFieldName="Code" TextFormatString="{0}" Width="170px" OnLoad="gvLookupLoad">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="Code" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="Description" Settings-AutoFilterCondition="Contains" />

                                                            </Columns>
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
                                                 <%--       <dx:ASPxTextBox ID="txtskucode"  ClientInstanceName="txtskucode" runat="server" Width="170px" ReadOnly="false">
                                                            <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('CookingStage');  e.processOnServer = false;
                                                                 
                                                                         }" />
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



                                            <dx:LayoutItem Caption="Step Sequence" Name="stepseq" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="hstepseq"  ClientInstanceName="hstepseq" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



                                            <dx:LayoutItem Caption="Year" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtYear" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            

                                            <dx:LayoutItem Caption="DayNo" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDayNo" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            
                                          


                                            
                                            <dx:LayoutItem Caption="Batch No" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtBatchNo" ClientInstanceName="txtBatchNo" runat="server"
                                                            OnInit="lookup_Init"    
                                                            DataSourceID="sdsBatch" KeyFieldName="BatchNo" TextFormatString="{0}" Width="170px" OnLoad="gvLookupLoad">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True"    />
                                                            </GridViewProperties>
                                                           
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="BatchNo" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="SKUcode" Settings-AutoFilterCondition="Contains" />
                                                      

                                                            </Columns>
                                                            <ClientSideEvents 
                                                                    DropDown="function(){ 
                                                                            var date = document.getElementById('cp_frmlayout1_PC_0_dtpDocDate_I').value;
                                                                    var datestring = '\'' + date.split('/')[2] + '-' + date.split('/')[0] + '-'+ date.split('/')[1] + '\'';
                                                                    console.log('datestring:');
                                                                    console.log(datestring);

                                                                    var sku = document.getElementById('cp_frmlayout1_PC_0_txtskucode_I').value;
                                                                      var skustring = '\'' + sku + '\'';
                                                                    console.log('sku:');
                                                                    console.log(sku);

                                                                              gl_objName = 'txtBatchNo';
                                                                              gl_sdsName = 'sdsBatch';

                                                                             

                                                                 if (sku == '' || sku == null || sku == undefined){
                                                                              gl_sqlcmd = 'SELECT BatchNo,MAX(SKUcode) AS SKUcode FROM Production.BatchQueue where Field9 =' + datestring +' GROUP BY BatchNo';
                                                                              }
                                                                 else {
                                                                              gl_sqlcmd = 'SELECT BatchNo,MAX(SKUcode) AS SKUcode FROM Production.BatchQueue where Field9 =' + datestring +' and SKUcode =' + skustring +' GROUP BY BatchNo';
                                                                              }
                                                                         console.log(gl_sqlcmd);     
                                                                              gridLookup_Data();

                                                                              }"
                                                                    ValueChanged="function(){

                                                                                PutDetailIdx = 1;
                                                                                PutObj = txtBatchNo;
                                                                                PutGridUse=PutObj.GetGridView(); 
                                                                                PutColName = ['Hskucode'];
                                                                                PutValueIndex = [1];

                                                                                PutGridUse.GetRowValues(PutGridUse.GetFocusedRowIndex(), 'BatchNo;SKUcode', PutGridCol);
                                                                                }"
                                                                />
                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                   
                                                </LayoutItemNestedControlCollection>                                                
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Scrap Code" Name="scrapcode" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="hscrapcode" ClientInstanceName="hscrapcode" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Scrap Date" Name="scrapdate" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="hscrapdate" runat="server"  ClientInstanceName="hscrapdate"  Width="170px">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Weight" Name="scrapweight" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="hscrapweight" ClientInstanceName="hscrapweight" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="UOM" Name="scrapuom" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="hscrapuom" ClientInstanceName="hscrapuom" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


              <%--                              <dx:LayoutItem Caption="Machine"  ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtMachine" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>




                                            <dx:LayoutItem Caption="Plan Qty" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPlanQty" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Actual Qty" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActualQty" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



                                             <%--Cooking--%>
                                            <dx:LayoutItem Caption="Smokehouse Number (HS No.) " Name ="glSmokehouse" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glSmokehouse" ClientInstanceName="txtSmokehouse" runat="server"
                                                            OnInit="lookup_Init"
                                                            DataSourceID="sdsStep" KeyFieldName="StepCode" TextFormatString="{0}" Width="170px" OnLoad="gvLookupLoad">
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


                                            <dx:LayoutItem Caption="Batch Number " Name="BatchNum" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="BatchNum" runat="server" Width="170px" 
                                                            ReadOnly="true" ClientInstanceName="NumStrands" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right" OnLoad="SpinEdit_Load">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                              <dx:LayoutItem Caption="Time (Standard cooking time Per stage) " name="TimeStandard" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeStandard" runat="server" DateTime="2009/11/01 15:31:34" Width="100">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:LayoutItem Caption="Time Start" name="TimeStart" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeStart" runat="server" DateTime="2009/11/01 15:31:34" Width="100" EditFormat="Time">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                             <dx:LayoutItem Caption="Time End" name="TimeEnd" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeEnd" runat="server" DateTime="2009/11/01 15:31:34" Width="100">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <%--<dx:LayoutItem Caption="Stove Temp - STD">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speTotalBulk" runat="server" Width="170px" 
                                                            ReadOnly="true" ClientInstanceName="txttotalbulk" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>


                                            <dx:LayoutItem Caption="Stove Temp - STD" name="txtStoveTemp" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStoveTemp" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Stove Temp - Actual" name="txtStoveTempAct" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStoveTempAct" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:LayoutItem Caption="Humidity - STD" name="txtHumiditySTD" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHumiditySTD" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Humidity - Actual" name="txtHumidityAct" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHumidityAct" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Steam Pressure" name="txtSteam" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSteam" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            
                                            <dx:LayoutItem Caption="Internal Temp After Cooking" name="txtInternal" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtInternal" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Weighing After Cooking" name="TxtWeighingAC" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="TxtWeighingAC" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="IT Validation (QA)" name="txtValidated" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtValidated" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="" Name="Genereatebtn">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxButton ID="Generatebtn" ClientInstanceName="CINGenerate" runat="server"  Width="170px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" OnLoad="Generate_Btn" ClientVisible="true" Text="Generate" Theme="MetropolisBlue">
                                                                    <ClientSideEvents Click="Generates" />
                                                                </dx:ASPxButton>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Monitored By" name="txtMonitoredBy" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtMonitoredBy" runat="server" Width="170px" OnLoad ="TextboxLoad">
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











                                            <dx:LayoutItem Caption="Remarks" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRemarks" runat="server" OnLoad="TextboxLoad" Width="170px" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                           <dx:LayoutItem Caption="GridLookup"  ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="hgridlookup"  ClientInstanceName="hgridlookup" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Back Flush" Name="backflush" Visible="false"> 
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkBackFlash" runat="server" Width="170px" CheckState="Unchecked" ClientInstanceName="cbAutocharge" OnLoad="CheckBoxLoad">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRecWorkCenter" ClientVisible="false" ClientInstanceName="txtRecWorkCenter" runat="server" Width="0px">
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
                                    <dx:LayoutGroup Caption="Journal Entries" ClientVisible="false">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvJournal" runat="server" AutoGenerateColumns="False" Width="850px" ClientInstanceName="gvJournal" KeyFieldName="RTransType;TransType">
                                                            <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" />
                                                            <SettingsPager Mode="ShowAllRecords" />
                                                            <SettingsEditing Mode="Batch" />
                                                            <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130" />
                                                            <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                            <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="AccountCode" Name="jAccountCode" ShowInCustomizationForm="True" VisibleIndex="0" Width="120px" Caption="Account Code">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="AccountDescription" Name="jAccountDescription" ShowInCustomizationForm="True" VisibleIndex="1" Width="150px" Caption="Account Description">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="SubsidiaryCode" Name="jSubsidiaryCode" ShowInCustomizationForm="True" VisibleIndex="2" Width="120px" Caption="Subsidiary Code">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="SubsidiaryDescription" Name="jSubsidiaryDescription" ShowInCustomizationForm="True" VisibleIndex="3" Width="150px" Caption="Subsidiary Description">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="ProfitCenter" Name="jProfitCenter" ShowInCustomizationForm="True" VisibleIndex="4" Width="120px" Caption="Profit Center">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="CostCenter" Name="jCostCenter" ShowInCustomizationForm="True" VisibleIndex="5" Width="120px" Caption="Cost Center">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataSpinEditColumn FieldName="BizPartnerCode" Name="jBizPartnerCode" ShowInCustomizationForm="True" VisibleIndex="6" Width="150px" Caption="Business Partner">
                                                                </dx:GridViewDataSpinEditColumn>
                                                                <dx:GridViewDataSpinEditColumn FieldName="Debit" Name="jDebit" ShowInCustomizationForm="True" VisibleIndex="7" Width="120px" Caption="Debit Amount">
                                                                    <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                                <dx:GridViewDataSpinEditColumn FieldName="Credit" Name="jCredit" ShowInCustomizationForm="True" VisibleIndex="8" Width="120px" Caption="Credit Amount">
                                                                    <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                            </Columns>
                                                        </dx:ASPxGridView>
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
                                                        <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="608px" ClientInstanceName="gvRef" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber">
                                                            <ClientSideEvents Init="OnInitTrans" />
                                                            <%--<Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="130" VerticalScrollBarMode="Auto" />--%>
                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" />
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


 <%-- Batch Detail--%>
    <dx:LayoutGroup Caption=" Details" ColCount="2">
    <Items>
        <dx:LayoutItem ShowCaption="False">
            <LayoutItemNestedControlCollection>
                <dx:LayoutItemNestedControlContainer runat="server">

                                  <dx:ASPxLabel runat="server" Text="" Font-Bold="true" ForeColor="Gray"  Font-Size="Medium" ></dx:ASPxLabel>                                       
                    <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="980px" DataSourceID ="sdsDetail"
                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" 
                             KeyFieldName="DocNumber;LineNumber" SettingsEditing-BatchEditSettings-ShowConfirmOnLosingChanges="true">
                                  <SettingsBehavior AllowSort="false" AllowGroup="false" />    
                                        <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm"
                                             BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                        
                                                  <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager PageSize="1000"  Visible="False"/> 
                                                    <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130"  /> 
                                                    <Columns>
                                                           <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                           </dx:GridViewDataTextColumn>
                                                              
                                                                     <dx:GridViewCommandColumn ShowDeleteButton="true"  ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="50px" ShowNewButtonInHeader="true">
                                                                           <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Details0">
                                                                                    <Image IconID="support_info_16x16"></Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                            
                                                                      </dx:GridViewCommandColumn>
                                                       
                                                         

<%--                                                            <dx:GridViewDataTextColumn Caption="Smoke House No" FieldName="SmokeHouseNo" Name="SmokeHouseNo" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21" Width="175px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            </dx:GridViewDataTextColumn>--%>


                                                        <dx:GridViewDataSpinEditColumn Caption="Smoke House No" FieldName="SmokeHouseNo" Name="SmokeHouseNo" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21" Width="175px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                            <PropertiesSpinEdit  ClientInstanceName="SmokeHouseNo" DisplayFormatString="{0}"> 
                                                                                     
                                                                                            </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                         </dx:GridViewDataSpinEditColumn>


                                                            <dx:GridViewDataSpinEditColumn Caption="Batch No" FieldName="BatchNo" Name="BatchNo" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="22" Width="175px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                            <PropertiesSpinEdit  ClientInstanceName="BatchNo" DisplayFormatString="{0}"> 
                                                                                     
                                                                                            </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            </dx:GridViewDataSpinEditColumn>

                                                            <dx:GridViewDataSpinEditColumn Caption="IT After cooking" FieldName="ITAcooking" Name="ITAcooking" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="23" Width="175px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                            <PropertiesSpinEdit  ClientInstanceName="ITAcooking" DisplayFormatString="{0}"> 
                                                                                     
                                                                                            </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                 </dx:GridViewDataSpinEditColumn>



                                                        <%--<dx:GridViewDataTextColumn Caption="Cooking Stage" FieldName="Cookingstage" Name="Cookingstage" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="175px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            </dx:GridViewDataTextColumn>--%>
                                 
                                                              
                                                              
                                                            </Columns>

              </dx:ASPxGridView>

                                                       


                                                          
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                                 </dx:LayoutItem>

                                             </Items>
                                    </dx:LayoutGroup>
 <%-- Batch Detail End--%>
                             <%-- Batch Detail--%>
    <dx:LayoutGroup Caption=" Details" ColCount="2">
    <Items>
        <dx:LayoutItem ShowCaption="False">
            <LayoutItemNestedControlCollection>
                <dx:LayoutItemNestedControlContainer runat="server">

                                  <dx:ASPxLabel runat="server" Text="" Font-Bold="true" ForeColor="Gray"  Font-Size="Medium" ></dx:ASPxLabel>                                       
                    <dx:ASPxGridView ID="gv2" runat="server" AutoGenerateColumns="False" Width="980px" DataSourceID ="sdsDetailcooking"
                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv2" 
                             KeyFieldName="DocNumber;LineNumber" SettingsEditing-BatchEditSettings-ShowConfirmOnLosingChanges="true">
                                  <SettingsBehavior AllowSort="false" AllowGroup="false" />    
                                        <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm"
                                             BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                        
                                                  <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager PageSize="1000"  Visible="False"/> 
                                                    <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130"  /> 
                                                    <Columns>
                                                           <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                           </dx:GridViewDataTextColumn>
                                                              
                                                                     <dx:GridViewCommandColumn ShowDeleteButton="true"  ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="50px" ShowNewButtonInHeader="true">
                                                                           <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Details1">
                                                                                    <Image IconID="support_info_16x16"></Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                            
                                                                      </dx:GridViewCommandColumn>
                                                       
                                                         

                                                          <dx:GridViewDataTextColumn Caption="Cooking Stage" FieldName="CookingStage" Name="CookingStage" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="24" Width="250px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" ReadOnly="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                           <EditItemTemplate>
                                                              <dx:ASPxGridLookup ID="glCookingstage" runat="server" DataSourceID="sdsCookingStage" Width="250px" KeyFieldName="StepCode" 
                                                                        TextFormatString="{0}" AutoGenerateColumns="False" ClientInstanceName="glCookingstage" ClientEnabled="false" ReadOnly="true">
                                                               
                                                                 
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="StepCode" Caption="Step Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        
                                                                        
                                                                    </Columns>
                                                                 
                                                                   <ClientSideEvents ValueChanged="function(s,e){ 
                                                                        var g = glCookingstage.GetGridView();
                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'StepCode', UpdateCooking); 
                                                                    }"/>
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                               </EditItemTemplate>
                                                                
                                                          </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataSpinEditColumn Caption="STD cooking time" FieldName="STDcooking" Name="Cookingstage" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="25" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                            <PropertiesSpinEdit  ClientInstanceName="ITAcooking" DisplayFormatString="{0}"> 
                                                                                     
                                                                                            </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="TimeStart" FieldName="TimeStart" Name="TimeStart" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="26" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                            <PropertiesSpinEdit  ClientInstanceName="ITAcooking" DisplayFormatString="{0}"> 
                                                                                     
                                                                                            </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                        </dx:GridViewDataSpinEditColumn>
                                                       <%-- <dx:GridViewDataTimeEditColumn Caption="TimeStart" FieldName="TimeStart" Name="TimeStart" ShowInCustomizationForm="True" VisibleIndex="26" Width="75px">
                                                            <PropertiesTimeEdit EditFormat= "Time" EditFormatString="hh:mm:ss tt" DisplayFormatString="hh:mm:ss tt">  
                                                            </PropertiesTimeEdit>  
                                                        </dx:GridViewDataTimeEditColumn>--%>

                                                        
                                                         <dx:GridViewDataSpinEditColumn Caption="TimeEnd" FieldName="TimeEnd" Name="TimeEnd" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="27" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                            <PropertiesSpinEdit  ClientInstanceName="ITAcooking" DisplayFormatString="{0}" > 
                                                                                     
                                                                                            </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                         </dx:GridViewDataSpinEditColumn>


                                                        <%-- <dx:GridViewDataTimeEditColumn Caption="TimeEnd" FieldName="TimeEnd" Name="TimeEnd" ShowInCustomizationForm="True" VisibleIndex="27" Width="75px">
                                                            <PropertiesTimeEdit EditFormat="Custom" EditFormatString="hh:mm:ss tt" DisplayFormatString="hh:mm:ss tt" >  
                                                            </PropertiesTimeEdit>  
                                                        </dx:GridViewDataTimeEditColumn>--%>



                                                            <dx:GridViewBandColumn Name="StoveTemp" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="StoveTemp" ClientInstanceName="StoveTemp" runat="server" Text="Stove Temp">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="Std" FieldName="StdST" Name="StdST" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="StdST"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                <dx:GridViewDataSpinEditColumn Caption="Actual" FieldName="ActualST" Name="ActualST" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="ActualST"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>



                                                            <dx:GridViewBandColumn Name="Humidity"  AllowDragDrop="False" VisibleIndex="29" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                <HeaderCaptionTemplate>  
                                                                    <dx:ASPxLabel ID="Humidity" ClientInstanceName="Humidity" runat="server" Text="% Humidity">  
                                                                    </dx:ASPxLabel>  
                                                                </HeaderCaptionTemplate>   
                                                                        <Columns>
                                                                            <dx:GridViewDataSpinEditColumn Caption="Std" FieldName="StdH" Name="StdH" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="StdH"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                <dx:GridViewDataSpinEditColumn Caption="Actual" FieldName="ActualH" Name="ActualH" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="ActualH"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>
                                                                        </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                             </dx:GridViewBandColumn>



                                                        
                                                              
                                                              
                                                            </Columns>

              </dx:ASPxGridView>

                                                       


                                                          
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                                 </dx:LayoutItem>

                                             </Items>
                                    </dx:LayoutGroup>
 <%-- Batch Detail End--%>

                                            <dx:LayoutItem ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gv3" runat="server" ClientInstanceName="gv3" AutoGenerateColumns="true" BatchEditStartEditing="OnStartEditing">
                                                            <SettingsEditing Mode="Batch" />
                                                            <SettingsPager Mode="ShowAllRecords" />
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                            <dx:LayoutItem ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gv4" runat="server" ClientInstanceName="gv4" AutoGenerateColumns="true" BatchEditStartEditing="OnStartEditing">
                                                            <SettingsEditing Mode="Batch" />
                                                            <SettingsPager Mode="ShowAllRecords" />
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



                            <dx:LayoutGroup Caption="Amount" ColCount="2" ClientVisible="false">
                                <Items>
                                    <dx:LayoutItem Caption="Quantity">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">

                                                <dx:ASPxSpinEdit ID="speTotalQuantity" runat="server" Width="170px" OnLoad="SpinEdit_Load" ClientInstanceName="txttotalqty" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00" DisplayFormatString="{0:N}" AllowMouseWheel="false">
                                                    <ClientSideEvents Validation="OnQtyValidate" ValueChanged="autocalculate" />
                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                        <RequiredField IsRequired="True" />
                                                    </ValidationSettings>
                                                    <InvalidStyle BackColor="Pink">
                                                    </InvalidStyle>
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Work Order Price">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speWOP" runat="server" Width="170px" DisplayFormatString="{0:N}" ClientInstanceName="txtWOP" OnLoad="SpinEdit_Load" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption=" Original Work Order Price">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speOrigWOP" runat="server" Width="170px" ReadOnly="True" ClientInstanceName="speWOP" DisplayFormatString="{0:N}" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    
                                    <dx:LayoutItem Caption="VAT Code">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtVatCode" runat="server" Width="170px" ReadOnly="True" ClientInstanceName="txtVatCode">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>

                                    <dx:LayoutItem Caption="Currency ">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">


                                                <dx:ASPxTextBox ID="txtCurrency" runat="server" ReadOnly="True" Width="170px">
                                                </dx:ASPxTextBox>


                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>

                                    <dx:LayoutItem Caption="Exchange Rate" ColSpan="2">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speExchangeRate" runat="server" Width="170px" ClientInstanceName="txtexchangerate" OnLoad="SpinEdit_Load" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>

                                    <dx:LayoutItem Caption="Peso Amount" ColSpan="2">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="spePesoAmount" runat="server" Width="170px" ClientInstanceName="txtTotalAmount" DisplayFormatString="{0:N}" ReadOnly="true" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Foreign Amount">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speForeignAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtForeignAmount" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>

                                    <dx:LayoutItem Caption="Non Vatable Amount">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speNonVatableAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtnonvat" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Gross Vatable Amount" ColSpan="2">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speGrossVatableAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtGrossVATableAmount" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                    <ClientSideEvents Validation="function (s,e)
                                                                {
                                                                 OnValidation = true;
                                                                }" />
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Vat Amount">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speVatAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtVatAmount1" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Withholding Tax">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speWithHoldingTax" runat="server" DisplayFormatString="{0:N}" ClientInstanceName="txtWithHoldingTax" ReadOnly="True" Width="170px" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speVatRate" runat="server" Width="170px" DisplayFormatString="{0:N}" ReadOnly="True" ClientVisible="false" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2" ClientInstanceName="txtVatRate">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speAtc" runat="server" ClientInstanceName="txtAtc" ClientVisible="false" ReadOnly="True" Width="170px">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                            <dx:EmptyLayoutItem></dx:EmptyLayoutItem>
                            <dx:EmptyLayoutItem></dx:EmptyLayoutItem>
                            <dx:EmptyLayoutItem></dx:EmptyLayoutItem>


                            <dx:LayoutGroup GroupBoxDecoration="None" ClientVisible="false">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gvTemp" runat="server" AutoGenerateColumns="False" Width="608px" ClientInstanceName="gvTemp" Settings-ShowColumnHeaders="false" setting>
                                                    <ClientSideEvents Init="OnInitTrans" />
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


    <asp:SqlDataSource ID="MasterfileClass" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT  [ClassCode],[ItemCode], [ColorCode] ,[SizeCode] FROM Masterfile.[ItemDetail] where isnull(IsInactive,0)=0"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsJobOrder" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="

SELECT A.DocNumber,StepCode,WorkCenter,WorkOrderPrice FROM (
SELECT DISTINCT A.DocNumber,MAX(Sequence) as Sequence FROM Production.JobOrder A 
INNER JOIN Production.JOStepPlanning B ON A.DocNumber = B.DocNumber
 WHERE  ISNULL(ProdSubmittedBy,'')!='' and Status  IN ('N','W')
 and  ISNULL(ProdSubmittedDate,'')!='' and ISNULL(PreProd,0)=0 
 group by A.DocNumber) as A
 INNER JOIN Production.JOStepPlanning B 
 ON A.DocNumber = B.DocNumber
 and A.Sequence != B.Sequence
 where   ISNULL(PreProd,0)=0 "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsAdjustmentClassification" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="
select AdjustmentCode,Description from MasterFile.WIPAdjustmentType where ISNULL(IsInactive,0)=0 "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.ProdWIPOUT+JournalEntry">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.ProdWIPOUT+RefTransaction">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:SqlDataSource ID="sdsShift" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="select ShiftCode,ShiftName from masterfile.Shift  "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.ProdWIPOUT+ProdWIPOUTDetail" SelectMethod="getdetail" UpdateMethod="UpdateProdWIPOUTDetail" TypeName="Entity.ProdWIPOUT+ProdWIPOUTDetail" DeleteMethod="DeleteProdWIPOUTDetail" InsertMethod="AddProdWIPOUTDetail">
              <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsDetailCooking" runat="server" DataObjectTypeName="Entity.ProdWIPOUT+ProdWIPOUTDetailCooking" SelectMethod="getdetailCooking" UpdateMethod="UpdateProdWIPOUTDetailCooking" TypeName="Entity.ProdWIPOUT+ProdWIPOUTDetailCooking" DeleteMethod="DeleteProdWIPOUTDetailCooking" InsertMethod="AddProdWIPOUTDetailCooking">
              <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Production.WIPOutDetail where DocNumber is null"   OnInit = "Connection_Init">
    </asp:SqlDataSource>

     <asp:SqlDataSource ID="sdsDetailCooking" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Production.WIPOutDetailCooking where DocNumber is null"   OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsStep" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="
        SELECT StepCode
        FROM Masterfile.Step
  "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsSite" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="

        SELECT ProductClassCode as Code,Description 
        FROM Masterfile.ProductClass
  
        "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsBatch" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand= " "
        
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsSKUCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand= " "
        
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsCookingStage" runat="server" 
        SelectCommand="SELECT DISTINCT StepCode FROM Production.ProdRoutingStepPack"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <!--#endregion-->
</body>
</html>


