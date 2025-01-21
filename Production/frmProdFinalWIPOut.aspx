<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmProdFinalWIPOut.aspx.cs" Inherits="GWL.frmProdFinalWIPOut" %>

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
        height: 600px; /*Change this whenever needed*/
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

        var x = 0;
        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            gv1.batchEditApi.EndEdit();
            gvclass.batchEditApi.EndEdit();
            setTimeout(function () { 

                var btnmode = btn.GetText(); //gets text of button
                if (btnmode == "Delete") {
                    cp.PerformCallback("Delete");
                }
                console.log(isValid + ' ' + counterror);

            
                if (x == 0) 
			    {
				    if (isValid && counterror < 1 || btnmode == "Close" || btnmode == "Override") { //check if there's no error then proceed to callback
					    //Sends request to server side
					    if (btnmode == "Add" && x == 0) {
                            x++;
						    autocalculate();
						    cp.PerformCallback("Add");
					    }
					    else if (btnmode == "Update" && x == 0) {
                            x++;
						    autocalculate();
						    cp.PerformCallback("Update");
					    }
					    else if (btnmode == "Close") {
						    cp.PerformCallback("Close");
					    }
					    else if (btnmode == "Override" && x == 0) {
                            x++;
						    cp.PerformCallback("Override");
					    }
				    }
				    else {
					    counterror = 0;
					    alert('Please check all the fields!');
					    console.log(counterror);
				    }
			    }
                else {
                    alert('Updating, please wait!');
                }  
            }, 500);
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
                gv1.CancelEdit();
                gvclass.CancelEdit();
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


            console.log('gridend');
            if (s.cp_vatdetail != null) {
                totalvat = s.cp_vatdetail;
                delete (s.cp_vatdetail);
                txtGrossVATableAmount.SetText(totalvat);
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
                gvclass.PerformCallback();

            }
            else {

                autocalculate(s, e)
                generate1 = false;
            }
        }
        var itemc;
        var index;
        var currentColumn;
        var isSetTextRequired = false;
        var linecount = 1;
        function OnStartEditing(s, e) {//On start edit grid function    
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode"); //needed var for all lookups; this is where the lookups vary for

            index = e.visibleIndex; //needed var for all lookups; this is where the lookups vary for
            //if (e.visibleIndex < 0) {//new row
            //    var linenumber = s.GetColumnByField("LineNumber");
            //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
            //}
            if (entry == "V") {
                e.cancel = true; //this will made the gridview readonly
            }
            if (entry != "V") {
                if (e.focusedColumn.fieldName === "SizeCode" || e.focusedColumn.fieldName === "JOBreakdown" || e.focusedColumn.fieldName === "ClassCodes") { //Check the column name
                    e.cancel = true;
                }

                if (e.focusedColumn.fieldName === "ClassCode") {
                    gl3.GetInputElement().value = cellInfo.value;
                }

                if (currentColumn.fieldName === "SizeCodes") {
                    cellInfo.value = glsize.GetValue();
                    cellInfo.text = glsize.GetText().toUpperCase();
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
            if (currentColumn.fieldName === "SizeCodes") {
                cellInfo.value = glsize.GetValue();
                cellInfo.text = glsize.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "JOClass") {
                cellInfo.value = glJOClass.GetValue();
                cellInfo.text = glJOClass.GetText().toUpperCase();
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
                for (var i = 0; i < gvclass.GetColumnsCount() ; i++) {
                    var column = gvclass.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, e, column, gvclass);
                    gvclass.batchEditApi.EndEdit();
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
                if (column.fieldName == "SizeCodes") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                }

            }
        }

        function autocalculate(s, e) {
            //console.log(txtNewUnitCost.GetValue());
            OnInitTrans();
            var qty = 0.00;

            var totalqty = 0.00
            var wop = 0.00
            var exchangerate = 0.00
            var NonVatAmount = 0.00
            var GrossVatamount = 0.00
            var VatAmount = 0.00
            var WithHolding = 0.00
            var VatRate = 0.00
            var Atc = 0.00
            //RA
            if (txtexchangerate.GetText() == null || txtexchangerate.GetText() == "") {
                exchangerate = 0.00;
            }
            else {
                exchangerate = txtexchangerate.GetText();
            }


            if (txtWOP.GetText() == null || txtWOP.GetText() == "") {
                wop = 0.00;
            }
            else {
                wop = txtWOP.GetText();
            }


            if (txtVatRate.GetText() == null || txtVatRate.GetText() == "") {
                VatRate = 0.00;
            }
            else {
                VatRate = txtVatRate.GetText();
            }

            if (txtAtc.GetText() == null || txtAtc.GetText() == "") {
                Atc = 0.00;
            }
            else {
                Atc = txtAtc.GetText();
            }
            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                var indicies1 = gvclass.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {

                        qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");

                        totalqty += qty * 1.00;          //Sum of all Quantity
                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");


                            totalqty += qty * 1.00;
                        }
                    }
                }
                for (var i = 0; i < indicies1.length; i++) {
                    if (gvclass.batchEditApi.IsNewRow(indicies1[i])) {

                        qty = gvclass.batchEditApi.GetCellValue(indicies1[i], "Quantity");

                        totalqty += qty * 1.00;          //Sum of all Quantity
                    }
                    else {
                        var key = gvclass.GetRowKey(indicies1[i]);
                        if (gvclass.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies1[i]);
                        else {
                            qty = gvclass.batchEditApi.GetCellValue(indicies1[i], "Quantity");


                            totalqty += qty * 1.00;
                        }
                    }
                }


                if (isNaN(totalqty) == true) {
                    totalqty = 0;
                }


                if (txtVatRate.GetValue() == 0) {
                    NonVatAmount = totalqty * wop * exchangerate
                    GrossVatamount = 0.00
                }
                else {
                    GrossVatamount = totalqty * wop * exchangerate
                    NonVatAmount = 0.00

                }

                //  txtVatAmount.SetText(VATAmount.format(2, 3, ',', '.'));



                txtGrossVATableAmount.SetValue(GrossVatamount)
                txtNonVatableAmount.SetValue(NonVatAmount)

                txtTotalQuantity.SetValue(totalqty);
                txtForeignAmount.SetValue(totalqty * wop * exchangerate);
                txtPesoAmount.SetValue(totalqty * wop)
                vatdetail1 = 1 + parseFloat(VatRate);

                txtVatAmount.SetValue(((GrossVatamount / vatdetail1) * VatRate).toFixed(2))
                txtWithHoldingTax.SetValue(((GrossVatamount - txtVatAmount.GetValue()) * Atc).toFixed(2))

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
            isSetTextRequired = false;
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode !== ASPxKey.Tab) return;
            var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
            if (gv1.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            }
            if (gvclass.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            }
        }

        function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode == ASPxKey.Enter) {
                gv1.batchEditApi.EndEdit();
                gvclass.batchEditApi.EndEdit();
            }
            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            setTimeout(function () {
                gv1.batchEditApi.EndEdit();
                gvclass.batchEditApi.EndEdit();
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
                var transtype = getParameterByName('transtype') + 'A';
                var refdocnum = "";
                var itemcode = glProductCode.GetValue();
                var colorcode = glproductcolor.GetValue();
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCodes");
                var bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "BulkQty"); 
                var expdate = s.batchEditApi.GetCellValue(e.visibleIndex, "ExpDate");
                var mfgdate = s.batchEditApi.GetCellValue(e.visibleIndex, "MfgDate");
                var batchno = s.batchEditApi.GetCellValue(e.visibleIndex, "BatchNo");
                var lotno = s.batchEditApi.GetCellValue(e.visibleIndex, "LotNo");
                var docdate = dtpDocDate.GetText();
                var entry = getParameterByName('entry');
                var Warehouse = WarehouseCode.GetText();
                CSheet.SetContentUrl('../WMS/frmTRRSetup.aspx?entry=' + entry + '&docnumber=' + docnumber
                   + '&transtype=' + transtype
                   + '&linenumber=' + linenum
                   + '&refdocnum=' + encodeURIComponent(refdocnum)
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
            if (e.buttonID == "CountSheet1") {
                CSheet.Show(); 
                var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
                var docnumber = getParameterByName('docnumber');
                var transtype = getParameterByName('transtype') + 'B';
                var refdocnum = "";
                var itemcode = glProductCode.GetValue();
                var colorcode = glproductcolor.GetValue();
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCodes");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                var bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "BulkQuantity");
                var expdate = s.batchEditApi.GetCellValue(e.visibleIndex, "ExpDate");
                var mfgdate = s.batchEditApi.GetCellValue(e.visibleIndex, "MfgDate");
                var batchno = s.batchEditApi.GetCellValue(e.visibleIndex, "BatchNo");
                var lotno = s.batchEditApi.GetCellValue(e.visibleIndex, "LotNo");
                var docdate = dtpDocDate.GetText();
                var entry = getParameterByName('entry');
                var Warehouse = WarehouseCode.GetText();
                CSheet.SetContentUrl('../WMS/frmTRRSetup.aspx?entry=' + entry + '&docnumber=' + docnumber
                   + '&transtype=' + transtype
                   + '&linenumber=' + linenum
                   + '&refdocnum=' + encodeURIComponent(refdocnum)
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


        function convertDate(str) {
            var date = new Date(str),
                mnth = ("0" + (date.getMonth() + 1)).slice(-2),
                day = ("0" + date.getDate()).slice(-2);
            return [date.getFullYear(), mnth, day].join("-");
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
            gv1.SetWidth(width - 120);
            gvclass.SetWidth(width - 120);
            gvRef.SetWidth(width - 120);
            gvJournal.SetWidth(width - 120);
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

    </script>
    <!--#endregion-->
</head>
<body style="height: 910px;">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
<form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Final WIP OUT" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
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
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server"  Height="565px" Width="850px" style="margin-left: -20px" SettingsAdaptivity-AdaptivityMode="SingleColumnWindowLimit" SettingsAdaptivity-SwitchToSingleColumnAtWindowInnerWidth="800">
        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px"  OnLoad="TextboxLoad" AutoCompleteType="Disabled" Enabled="False">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnLoad="Date_Load" OnInit ="dtpDocDate_Init"  Width="170px" ClientInstanceName="dtpDocDate">
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
                                            <dx:LayoutItem Caption="Type">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                             <dx:ASPxComboBox ID="cmbType" Width="170px" runat="server" OnLoad="Comboboxload" >
                                                            <Items>
                                                                <dx:ListEditItem Text="Normal Out" Value="Normal Out" />
                                                                <dx:ListEditItem Text="Adjustment" Value="Adjustment" />
                                                            </Items>
                                                               <ClientSideEvents Validation="OnValidation" />
                                                               <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                                  <ClientSideEvents ValueChanged="function(s,e){
                                                                  cp.PerformCallback('Type');
                                                                   e.processOnServer = false;
                                                                }" />
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                               <dx:LayoutItem Caption="Adjustment Classification">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glAdjustment" DataSourceID="sdsAdjustmentClassification"  runat="server" AutoGenerateColumns="False" ClientInstanceName="glAdjustment" KeyFieldName="AdjustmentCode"  OnLoad="LookupLoad"  TextFormatString="{0}" Width="170px">                                                        <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px">
                                                                </dx:GridViewCommandColumn>
                                                                <dx:GridViewDataTextColumn Caption="AdjustmentCode" FieldName="AdjustmentCode" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Description" FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="2" Width="50px">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
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

                                             <dx:LayoutItem Caption="Job Order">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glserviceorder" DataSourceID="sdsServiceOrder"  runat="server" AutoGenerateColumns="False" ClientInstanceName="glserviceorder" KeyFieldName="DocNumber;StepCode;WorkCenter"  OnLoad="LookupLoad"  TextFormatString="{0}" Width="170px">
                                                             <ClientSideEvents ValueChanged="function(s,e){
                                                                    var g = glserviceorder.GetGridView();
                                                     
                                                                    
                                                                    cp.PerformCallback('JO|'+g.GetRowKey(g.GetFocusedRowIndex()));
                                                                }" />
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>   
                                                                <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px">
                                                                </dx:GridViewCommandColumn>
                                                                <dx:GridViewDataTextColumn Caption="Job Order No" FieldName="DocNumber" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                  <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                               <dx:GridViewDataTextColumn Caption="Work Center" FieldName="WorkCenter" ShowInCustomizationForm="True" VisibleIndex="2" Width="50px">
                                                                      <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                  <dx:GridViewDataTextColumn Caption="StepCode" FieldName="StepCode" ShowInCustomizationForm="True" VisibleIndex="3" Width="50px">
                                                                   <Settings AutoFilterCondition="Contains" />
                                                                  </dx:GridViewDataTextColumn>

                                                            </Columns>
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
                                                                         
                                             <dx:LayoutItem Caption="Step">
                                          <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStep" runat="server" ReadOnly="true"  Width="170px" ClientInstanceName="txtStep">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                               <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                           
                                            <dx:LayoutItem Caption="Work Center">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtWorkCenter" runat="server" ReadOnly="true" Width="170px" ClientInstanceName="txtWorkCenter">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                               <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            

                                                   <dx:LayoutItem Caption="Product Color" > 
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glProductColor" runat="server" DataSourceID="sdsProductColor" SelectionMode="Single" OnInit="glProductColor_Init" KeyFieldName="ProductColor" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px" ClientInstanceName="glproductcolor">
                                                                <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <ClientSideEvents Validation="OnValidation" DropDown=" function (s,e) {glproductcolor.GetGridView().PerformCallback(glserviceorder.GetValue().toString()) }" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                                                                               
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                        
                                          
                                            <dx:LayoutItem Caption="Product Code" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glProductCode" runat="server" DataSourceID="sdsProductCode" SelectionMode="Single"  OnInit="glProductCode_Init"  KeyFieldName="ProductCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px" ClientInstanceName="glProductCode">
                                                                   <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <ClientSideEvents Validation="OnValidation"  DropDown=" function (s,e) {glProductCode.GetGridView().PerformCallback(glserviceorder.GetValue().toString()) }" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
              
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                        

                                              <dx:LayoutItem Caption="DR Doc No">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDrNumber" runat="server" Width="170px">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                             <dx:LayoutItem Caption="RR Doc No">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRRNumber" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                          <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Warehouse Code:" Name="WarehouseCode">
                                                  <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup  ID="aglwarehousecode" Width="170px" runat="server" DataSourceID="sdsWarehouse" ClientInstanceName="WarehouseCode"  KeyFieldName="WarehouseCode" OnLoad="LookupLoad" TextFormatString="{0}" >
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSelectByRowClick="True" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Remarks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxMemo ID="memRemarks" runat="server" Height="71px" Width="170px">
                                                        </dx:ASPxMemo>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                            <dx:LayoutItem Caption="Overhead Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtOverhead" runat="server" ReadOnly="true" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                 
                                            
                                               <dx:LayoutItem Caption="Status">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glStatus" DataSourceID="sdsStatus" runat="server" AutoGenerateColumns="False" ClientInstanceName="glStatus" KeyFieldName="StatusCode"  OnLoad="LookupLoad"  TextFormatString="{0}" Width="170px">                                                        <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px">
                                                                </dx:GridViewCommandColumn>
                                                                <dx:GridViewDataTextColumn Caption="StatusCode" FieldName="StatusCode" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Description" FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="2" Width="50px">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            
                                               <dx:LayoutItem Caption="Disposition">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glDisposition" DataSourceID="sdsDisposition" runat="server" AutoGenerateColumns="False" ClientInstanceName="glDisposition" KeyFieldName="Disposition"  OnLoad="LookupLoad"  TextFormatString="{0}" Width="170px">                                                        <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px">
                                                                </dx:GridViewCommandColumn>
                                                                <dx:GridViewDataTextColumn Caption="Disposition" FieldName="Disposition" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Description" FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="2" Width="50px">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Class A">
                                                      <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkIsWithDR" runat="server" Width="170px"  CheckState="Unchecked" ClientInstanceName="cbiswithdr" OnLoad="CheckBoxLoad">
                                                            <ClientSideEvents CheckedChanged="checkedchanged" />
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                <dx:LayoutItem Caption="Auto Charge">
                                                      <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkIsAutoCharge" runat="server" Width="170px"  CheckState="Unchecked" ClientInstanceName="cbisautocharge" OnLoad="CheckBoxLoad">
                                                          
                                                        </dx:ASPxCheckBox>
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
       
                                    <dx:LayoutGroup Caption="Audit Trail"  ColCount="2">
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
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" Width="170px"  ReadOnly="true" >
                                               
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                              
                                              <dx:LayoutItem Caption="Last Edited Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" Width="170px" ReadOnly="True" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                              <dx:LayoutItem Caption="Submitted By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" Width="170px"  ReadOnly="true"  >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                <dx:LayoutItem Caption="Submitted Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" Width="170px"  ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                     <dx:LayoutItem Caption="Cancelled By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" Width="170px"  ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                        <dx:LayoutItem Caption="Cancelled Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledDate" runat="server" Width="170px"  ReadOnly="true">
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
                                                        <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="608px" ClientInstanceName="gvRef" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber"  >
                                                            <ClientSideEvents Init="OnInitTrans" />
                                                            <%--<Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="130" VerticalScrollBarMode="Auto" />--%>
                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                            <SettingsPager PageSize="5">
                                                            </SettingsPager>
                                                            <SettingsEditing Mode="Batch">      
                                                            </SettingsEditing>
                                                              <SettingsBehavior FilterRowMode="OnClick" ColumnResizeMode="NextColumn"  />
                                                            <Columns>
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
																<dx:GridViewDataSpinEditColumn FieldName="BizPartnerCode" Name="jBizPartnerCode" ShowInCustomizationForm="True" VisibleIndex="6" Width ="150px" Caption="Business Partner" > 
                                                                </dx:GridViewDataSpinEditColumn>
                                                                <dx:GridViewDataSpinEditColumn FieldName="Debit" Name="jDebit" ShowInCustomizationForm="True" VisibleIndex="7" Width="120px" Caption="Debit Amount" >
                                                                    <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>                                                                
                                                                <dx:GridViewDataSpinEditColumn FieldName="Credit" Name="jCredit" ShowInCustomizationForm="True" VisibleIndex="8" Width="120px" Caption="Credit Amount" >
                                                                    <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
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
                                </Items>
                            </dx:TabbedLayoutGroup>
                              <dx:LayoutGroup Caption="Amount" ColCount="2">
                                <Items>
                                      <dx:LayoutItem Caption="Total Quantity">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speTotalQuantity" runat="server"  Width="170px"   DisplayFormatString="{0:N}"  ClientInstanceName="txtTotalQuantity"  NullDisplayText="0.00" NullText="0.00" MinValue="0"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2" >
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Work Order Price">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                  <dx:ASPxSpinEdit ID="speWOP" runat="server" Width="170px" ClientInstanceName="txtWOP" DisplayFormatString="{0:N}"  NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2" >
                                                   
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                       <dx:LayoutItem Caption="Original Work Order Price">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speOrigWOP" runat="server" Width="170px" ReadOnly="True" ClientInstanceName="txtOrigWOP" DisplayFormatString="{0:N}"  NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2" >                                                         
<SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                         <dx:LayoutItem Caption="VAT Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtVatCode" runat="server" Width="170px" ReadOnly="True" ClientInstanceName="txtVatCode" >
                                                         
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                     <dx:LayoutItem Caption="ATC Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAtcCode" runat="server" Width="170px" ReadOnly="True" ClientInstanceName="txtVatCode" >
                                                         
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
                                                        <dx:ASPxSpinEdit ID="speExchangeRate" runat="server" Width="170px" ClientInstanceName="txtexchangerate" DisplayFormatString="{0:N}"  NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2" >
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            
                                               <dx:LayoutItem Caption="Peso Amount" ColSpan="2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="spePesoAmount" runat="server" Width="170px" ClientInstanceName="txtPesoAmount" DisplayFormatString="{0:N}" ReadOnly="true" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2" >
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Foreign Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speForeignAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtForeignAmount" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">
                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Gross Vatable Amount" ColSpan="2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speGrossVatableAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtGrossVATableAmount" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                       <ClientSideEvents Validation="function (s,e)
                                                                {
                                                                 OnValidation = true;
                                                                }" />
                                                             </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                <dx:LayoutItem Caption="Non Vatable Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speNonVatableAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtNonVatableAmount" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Vat Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speVatAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtVatAmount" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Withholding Tax">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speWithHoldingTax" runat="server" DisplayFormatString="{0:N}"  ClientInstanceName="txtWithHoldingTax"  ReadOnly="True" Width="170px" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                              <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speVatRate" runat="server" Width="170px"   DisplayFormatString="{0:N}"  ReadOnly="True" ClientVisible="false" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2" ClientInstanceName="txtVatRate" >
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speAtc" runat="server" ClientInstanceName="txtAtc"  ClientVisible="false" ReadOnly="True" Width="170px">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                         </Items>
                            </dx:LayoutGroup>
                         

                            <dx:LayoutGroup Caption="Size Breakdown">
                       <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                             <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False"  Width="770px" KeyFieldName="LineNumber"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" OnInit="gv1_Init" OnCustomButtonInitialize="gv1_CustomButtonInitialize" >
                                                    <ClientSideEvents Init="OnInitTrans" />
                                           <SettingsBehavior AllowSort="false" AllowGroup="false" />    

                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True"  ShowInCustomizationForm="True" VisibleIndex="2" Width="80px">
                                                                    <PropertiesTextEdit ConvertEmptyStringToNull="False" >
                                                                    </PropertiesTextEdit>
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowDeleteButton="true" VisibleIndex="1" Width="60px">
                                                                    <CustomButtons>
                                                                        <dx:GridViewCommandColumnCustomButton ID="Details2">
                                                                            <Image IconID="support_info_16x16">
                                                                            </Image>
                                                                        </dx:GridViewCommandColumnCustomButton>
																		<dx:GridViewCommandColumnCustomButton ID="CountSheet1">
																			<Image IconID="arrange_withtextwrapping_topleft_16x16" ToolTip="Countsheet"></Image>
																		</dx:GridViewCommandColumnCustomButton>
                                                                    </CustomButtons>
                                                                </dx:GridViewCommandColumn>
                                                         
                                                                <dx:GridViewDataTextColumn Caption="SizeCode" FieldName="SizeCode" Name="SizeCode" ShowInCustomizationForm="True" VisibleIndex="20">
                                                          
                                                                </dx:GridViewDataTextColumn>
                                                                 <dx:GridViewDataTextColumn Caption="Class Code" FieldName="ClassCodes" Name="ClassCodes" ShowInCustomizationForm="True" VisibleIndex="20">
                                                          
                                                                </dx:GridViewDataTextColumn>
                                                                          <dx:GridViewDataSpinEditColumn Caption="Qty" FieldName="Qty" Name="Qty" ShowInCustomizationForm="True" VisibleIndex="21">
                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="gQty" ConvertEmptyStringToNull="False"  DisplayFormatString="{0:N}" NullDisplayText="0" NullText="0"  MaxValue="9999999999" MinValue="0" SpinButtons-ShowIncrementButtons ="false">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                                        <ClientSideEvents ValueChanged="autocalculate" />
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                                          <dx:GridViewDataSpinEditColumn Caption="BulkQty" FieldName="BulkQty" Name="BulkQty" ShowInCustomizationForm="True" VisibleIndex="22">
                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="gBulkQty" ConvertEmptyStringToNull="False"  DisplayFormatString="{0:N}" NullDisplayText="0" NullText="0"  MaxValue="9999999999" MinValue="0" SpinButtons-ShowIncrementButtons ="false">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                                        <ClientSideEvents ValueChanged="autocalculate" />
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>

                                                                <dx:GridViewDataSpinEditColumn Caption="JO Breakdown" FieldName="JOBreakdown" Name="JOBreakdown" ShowInCustomizationForm="True"   VisibleIndex="22" ReadOnly="true">
                                                                <PropertiesSpinEdit  SpinButtons-ShowIncrementButtons ="false"  DisplayFormatString="{0:N}" ></PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                                
                                                                <dx:GridViewDataDateColumn FieldName="ExpDate" Name="dtpExpDate" ShowInCustomizationForm="True" VisibleIndex="25">
                                                                </dx:GridViewDataDateColumn>
                                                                <dx:GridViewDataDateColumn FieldName="MfgDate" Name="dtpMfgDate" ShowInCustomizationForm="True" VisibleIndex="26">
                                                                </dx:GridViewDataDateColumn>
                                                                <dx:GridViewDataTextColumn FieldName="BatchNo" Name="txtBatchNo" ShowInCustomizationForm="True" VisibleIndex="27">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="LotNo" Name="txtLotNo" ShowInCustomizationForm="True" VisibleIndex="28">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field1" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="29">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field2" FieldName="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="30">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field3" FieldName="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="31">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field4" FieldName="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="32">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field5" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="33">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field6" FieldName="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="34">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field7" FieldName="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="35">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field8" FieldName="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="36">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field9" FieldName="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="37">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                 <SettingsPager Mode="ShowAllRecords"/> 
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" 
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                     <SettingsEditing Mode="Batch"/>
                                                </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                            </dx:LayoutGroup>
                            
                            <dx:LayoutGroup Caption="Class Breakdown">
                       <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                             <dx:ASPxGridView ID="gvclass" runat="server" AutoGenerateColumns="False"  Width="770px" KeyFieldName="LineNumber"
                                                    OnCommandButtonInitialize="gvclass_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gvclass"
                                                    OnRowValidating="grid_RowValidating"  OnInit="gv1_Init" OnCustomButtonInitialize="gv1_CustomButtonInitialize" >
                                                    <ClientSideEvents Init="OnInitTrans" />
                                           <SettingsBehavior AllowSort="false" AllowGroup="false" />    

                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="80px">
                                                                    <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                    </PropertiesTextEdit>
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True"  ShowNewButtonInHeader="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="60px">
                                                                    <CustomButtons>
                                                                        <dx:GridViewCommandColumnCustomButton ID="Details3">
                                                                            <Image IconID="support_info_16x16">
                                                                            </Image>
                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="CountSheet">
                                                                    <Image IconID="arrange_withtextwrapping_topleft_16x16" ToolTip="Countsheet"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                    </CustomButtons>
                                                                </dx:GridViewCommandColumn>
                                                         
                                                              
                                                                <dx:GridViewDataTextColumn Caption="JO Class" FieldName="JOClass" Name="JOClass"  ShowInCustomizationForm="True" VisibleIndex="19">
                                                                     <EditItemTemplate>
                                                                        <dx:ASPxGridLookup ID="glJOClass" runat="server" AutoGenerateColumns="True" OnInit="glClass1_Init" AutoPostBack="false" DataSourceID="MasterfileClass"  IncrementalFilteringMode="Contains"
                                                                        KeyFieldName="ClassCode" ClientInstanceName="glJOClass"  TextFormatString="{0}" Width="100px" >
                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                    AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                           <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                                DropDown="function(s,e){
                                                                                    glJOClass.GetGridView().PerformCallback('ClassCode' + '|'  + s.GetInputElement().value ); e.processOnServer = false;
                                                                        
                                                                                }" ValueChanged="gridLookup_CloseUp"/> 
                                                                            </dx:ASPxGridLookup>
                                                                        </EditItemTemplate>
                                                                     </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Class Code" FieldName="ClassCode" Name="ClassCode"  ShowInCustomizationForm="True" VisibleIndex="20">
                                                                     <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="True" OnInit="glClass1_Init" AutoPostBack="false" DataSourceID="MasterfileClass"  IncrementalFilteringMode="Contains"
                                                                KeyFieldName="ClassCode" ClientInstanceName="gl3"  TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                   <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  
                                                                        DropDown="function(s,e){
                                                                            gl3.GetGridView().PerformCallback('ClassCode' + '|'  + s.GetInputElement().value ); e.processOnServer = false;
                                                                        
                                                                        }"
                                                                         ValueChanged="gridLookup_CloseUp"/>

                                                                      
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                                     </dx:GridViewDataTextColumn>

                                                       <dx:GridViewDataTextColumn  VisibleIndex="30" Name="glpItemCode" Width="0">                                                            
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" OnInit="glItemCode_Init"
                                                                    ClientInstanceName="gl" TextFormatString="{0}" Width="0px" >
                                                                   <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" Settings-VerticalScrollBarMode="Visible"> 
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True"/>
                                                                    </GridViewProperties>
                                                                    <ClientSideEvents EndCallback="GridEnd" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Size Code" FieldName="SizeCodes" Name="SizeCodes"  ShowInCustomizationForm="True" VisibleIndex="20">
                                                                     <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="SizeCodes" runat="server" AutoGenerateColumns="True" AutoPostBack="false" OnInit="SizeCodes_Init" DataSourceID="SizeJO"  IncrementalFilteringMode="Contains"
                                                                KeyFieldName="StockSize" ClientInstanceName="glsize"  TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                      <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  
                                                                                        DropDown="lookup"
                                                                               GotFocus="function(s,e){
                                                                            glsize.GetGridView().PerformCallback(); e.processOnServer = false;
                                                         
                                                                        }"  CloseUp="gridLookup_CloseUp"/>

                                                                      
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                                     </dx:GridViewDataTextColumn>


                                                                <dx:GridViewDataSpinEditColumn Caption="Quantity" FieldName="Quantity" Name="Quantity" ShowInCustomizationForm="True" VisibleIndex="21">
                                                                
                                                                 <PropertiesSpinEdit Increment="0" ClientInstanceName="gQuantity" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}"  NullDisplayText="0" NullText="0"  MaxValue="9999999999" MinValue="0" SpinButtons-ShowIncrementButtons ="false">
                                                                        <ClientSideEvents ValueChanged="autocalculate" />
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>

                                                                <dx:GridViewDataSpinEditColumn Caption="BulkQuantity" FieldName="BulkQuantity" Name="BulkQuantity" ShowInCustomizationForm="True" VisibleIndex="22">
                                                                    <PropertiesSpinEdit Increment="0" ClientInstanceName="gBulkQuantity" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}"  NullDisplayText="0" NullText="0"  MaxValue="9999999999" MinValue="0" SpinButtons-ShowIncrementButtons ="false">
                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons> 
                                                                        <ClientSideEvents ValueChanged="autocalculate" />
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                                
                                                                <dx:GridViewDataDateColumn FieldName="ExpDate" Name="dtpExpDate" ShowInCustomizationForm="True" VisibleIndex="25">
                                                                </dx:GridViewDataDateColumn>
                                                                <dx:GridViewDataDateColumn FieldName="MfgDate" Name="dtpMfgDate" ShowInCustomizationForm="True" VisibleIndex="26">
                                                                </dx:GridViewDataDateColumn>
                                                                <dx:GridViewDataTextColumn FieldName="BatchNo" Name="txtBatchNo" ShowInCustomizationForm="True" VisibleIndex="27">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="LotNo" Name="txtLotNo" ShowInCustomizationForm="True" VisibleIndex="28">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field1" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="29">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field2" FieldName="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="30">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field3" FieldName="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="31">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field4" FieldName="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="32">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field5" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="33">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field6" FieldName="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="34">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field7" FieldName="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="35">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field8" FieldName="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="36">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field9" FieldName="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="37">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                 <SettingsPager Mode="ShowAllRecords"/> 
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" 
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                     <SettingsEditing Mode="Batch"/>
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
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.FinalWIPOUT+WOSizeBreakDown" SelectMethod="getdetail" UpdateMethod="UpdateWOSizeBreakDown" TypeName="Entity.FinalWIPOUT+WOSizeBreakDown" DeleteMethod="DeleteWOSizeBreakDown" InsertMethod="AddWOSizeBreakDown">
                 <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
        <asp:ObjectDataSource ID="odsClass" runat="server" DataObjectTypeName="Entity.FinalWIPOUT+WOClassBreakDown" SelectMethod="getdetail" UpdateMethod="UpdateWOClassBreakDown" TypeName="Entity.FinalWIPOUT+WOClassBreakDown" DeleteMethod="DeleteWOClassBreakDown" InsertMethod="AddWOClassBreakDown">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Procurement.WOSizeBreakdown where DocNumber is null"   OnInit = "Connection_Init">
    </asp:SqlDataSource>
      <asp:SqlDataSource ID="sdsClass" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Procurement.WOClassBreakdown where DocNumber is null"   OnInit = "Connection_Init">
    </asp:SqlDataSource>
         <asp:SqlDataSource ID="MasterfileClass" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT  ClassCode,Description,StepCode  FROM Masterfile.[Class] where isnull(IsInactive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
     <asp:SqlDataSource ID="SizeJO" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select StockSize,DocNumber from Production.JOSizeBreakdown" OnInit = "Connection_Init"></asp:SqlDataSource>

    
    
    <asp:SqlDataSource ID="sdsServiceOrder" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="
SELECT A.DocNumber,StepCode,WorkCenter FROM (
SELECT DISTINCT A.DocNumber,MAX(Sequence) as Sequence FROM Production.JobOrder A 
INNER JOIN Production.JOStepPlanning B ON A.DocNumber = B.DocNumber
 WHERE Status IN ('N','W') and ISNULL(PreProd,0)=0 
 group by A.DocNumber) as A
 INNER JOIN Production.JOStepPlanning B 
 ON A.DocNumber = B.DocNumber
 and A.Sequence = B.Sequence
 where   ISNULL(PreProd,0)=0 "   OnInit = "Connection_Init">
    
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsServiceOrderdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" SELECT A.DocNumber,LineNumber,StockSize as SizeCode,'A' as ClassCodes,JOQty as JOBreakdown,0 as Qty, 0 AS BulkQty
,'' as Field1,'' as Field2
 ,'' as Field3,'' as Field4,'' as Field5,'' as Field6
 ,'' as Field7,'' as Field8,'' as Field9, CAST(NULL AS Date) AS ExpDate, CAST(NULL AS Date) AS MfgDate, '' AS BatchNo, '' AS LotNo FROM Production.JobOrder A
  INNER JOIN Production.JOSizeBreakdown B ON A.DocNumber = B.DocNumber
  "   OnInit = "Connection_Init">
    </asp:SqlDataSource>
      
    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
        
    <asp:SqlDataSource ID="sdsAdjustmentClassification" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="
        select AdjustmentCode,Description from MasterFile.WIPAdjustmentType where ISNULL(IsInactive,0)=0 "  OnInit = "Connection_Init">
    </asp:SqlDataSource> 

    <asp:SqlDataSource ID="sdsProductCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select DISTINCT ItemCode as ProductCode,A.Docnumber,FullDesc,ColorCode as ProductColor,ClassCode,SizeCode from Production.JOProductOrder A inner join Production.JobOrder B on A.DocNumber = B.DocNumber" OnInit="Connection_Init"></asp:SqlDataSource> 
    <asp:SqlDataSource ID="sdsProductColor" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select DISTINCT ColorCode as ProductColor,A.Docnumber,A.ItemCode as ProductCode,FullDesc,ClassCode,SizeCode from Production.JOProductOrder A inner join Production.JobOrder B on A.DocNumber = B.DocNumber" OnInit="Connection_Init"></asp:SqlDataSource> 

    <asp:SqlDataSource ID="sdsStatus" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT Code as StatusCode, Description FROM It.GenericLookup where LookUpKey = 'PRDSTTS'" OnInit="Connection_Init"></asp:SqlDataSource> 
    <asp:SqlDataSource ID="sdsDisposition" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT ReasonCode as Disposition, Description FROM Masterfile.Reason where TransactionType = 'PRDFWT'" OnInit="Connection_Init"></asp:SqlDataSource> 

    
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.FinalWIPOUT+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.FinalWIPOUT+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>

       <!--#endregion-->
</body>
</html>
