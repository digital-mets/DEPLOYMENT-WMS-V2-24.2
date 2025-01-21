<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmMaterialIssuance.aspx.cs" Inherits="GWL.frmMaterialIssuance" %>

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
<title> Material Issuance </title>
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
  
          
            var btnmode = btn.GetText(); //gets text of button
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

            if (s.cp_generated) {
                delete (s.cp_generated);

                //START 2020-10-30 RAA Added Code for odsdetail approach
                gv1.CancelEdit();
                var _indices = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < _indices.length; i++) {
                    gv1.DeleteRow(_indices[i]);
                }

                gv1.AddNewRow();



                var _refindices = gvRefC.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < _refindices.length; i++) {


                    gv1.AddNewRow();
                    _indices = gv1.batchEditApi.GetRowVisibleIndices();


                    gv1.batchEditApi.SetCellValue(_indices[0], 'DocNumber', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'DocNumber'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'LineNumber', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'LineNumber'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'SerialNumber', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'SerialNumber'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'AssetTag', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'AssetTag'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'ItemCode', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'ItemCode'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'FullDesc', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'FullDesc'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'ColorCode', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'ColorCode'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'ClassCode', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'ClassCode'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'SizeCode', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'SizeCode'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'Quantity', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'POQty'));

                    gv1.batchEditApi.SetCellValue(_indices[0], 'Unit', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Unit'));

                    gv1.batchEditApi.EndEdit();
                    gv1.DeleteRow(-1);

                    autocalculate();

                }
            }


        }
        var itemclr;
        var itemcls;
        var itemsze;
        var loading = false;
        var nope = false;


        var jo;
        var step;

        var itemc;
        var index;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            jo = s.batchEditApi.GetCellValue(e.visibleIndex, "JobOrder"); //needed var for all lookups; this is where the lookups vary for
            step = s.batchEditApi.GetCellValue(e.visibleIndex, "StepCode"); //needed var for all lookups; this is where the lookups vary for
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
            console.log(step);
            index = e.visibleIndex;
            var entry = getParameterByName('entry');
            if (entry ==    "V") {
                e.cancel = true; //this will made the gridview readonly
            }
            if (entry != "V") {
                if (e.focusedColumn.fieldName === "StepCode" ) { //Check the column name
                    e.cancel = true;
                }

                if (e.focusedColumn.fieldName === "JobOrder") { //Check the column name
                    gl4.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    nope = false;
                    closing = true;
                }
                if (e.focusedColumn.fieldName === "ColorCode") {
                    gl2.GetInputElement().value = cellInfo.value;
                    nope = false;
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "ClassCode") {
                    gl3.GetInputElement().value = cellInfo.value;
                    nope = false;
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "SizeCode") {
                    gl5.GetInputElement().value = cellInfo.value;
                    nope = false;
                    isSetTextRequired = true;
                }
            }
          
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            if (currentColumn.fieldName === "JobOrder") {
                cellInfo.value = gl4.GetValue();
                cellInfo.text = gl4.GetText().toUpperCase();
            }

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
                cellInfo.value = gl5.GetValue();
                cellInfo.text = gl5.GetText().toUpperCase();
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
        var identifier;
        var testinglang;
        var valchange3 = false;
        var valchange = false;
        function GridEnd(s, e) {
            identifier = s.GetGridView().cp_identifier;
            val = s.GetGridView().cp_codes;
            console.log(val + 'val');
            console.log(identifier + 'identifier');
            if (val != null) {
                temp = val.split(';');
                delete (s.GetGridView().cp_codes);
            }
            else {
                val = "";
                delete (s.GetGridView().cp_codes);
            }

            if (identifier == 'sku') {
                if (s.keyFieldName == 'ItemCode' && (itemc == null || itemc == '')) {
                    s.SetText('');
                }
                //else if (s.keyFieldName == 'ItemCode' && (itemc != null && itemc != '')) {
                //    s.SetText(s.GetInputElement().value);
                //    console.log('hehe');
                //}

                if (s.keyFieldName == 'ColorCode' && (itemclr == null || itemclr == '')) {
                    s.SetText("");
                }
                //else if (s.keyFieldName == 'ColorCode' && (itemclr != null || itemclr != '')) {
                //    s.SetText(s.GetInputElement().value);
                //}
                if (s.keyFieldName == 'ClassCode' && (itemcls == null || itemcls == "")) {
                    s.SetText("");
                }
                if (s.keyFieldName == 'SizeCode' && (itemsze == null || itemsze == "")) {
                    s.SetText("");
                }
                delete (s.GetGridView().cp_identifier);
            }
            else if
                (identifier == 'sku') {

            }
      
            if (valchange && (val != null && val != 'undefined' && val != '')) {
             
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    
                    gridcheck = 3;
                    ProcessCells(0, e, column, gv1);
                    gv1.batchEditApi.EndEdit();
                }   
            }

            if (valchange3) {
                valchange3 = false;
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                   
                    gridcheck = 1;
                    ProcessCells(0, index, column, gv1);
                }
                gv1.batchEditApi.EndEdit();
                loader.Hide();
            }
            loading = false;
            loader.Hide();

        }

        function ProcessCells(selectedIndex, e, column, s) {
            if (val == null) {
                val = ";;";
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



            if (selectedIndex == 0) {
               
                if (gridcheck == 1) {
                    console.log(identifier);
                    if (identifier == "item") {
                      
                        if (column.fieldName == "ColorCode") {
                            s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                        }
                        if (column.fieldName == "ClassCode") {
                            s.batchEditApi.SetCellValue(index, column.fieldName, temp[1]);
                        }
                        if (column.fieldName == "SizeCode") {
                            s.batchEditApi.SetCellValue(index, column.fieldName, temp[2]);
                        }
        
                    }
                }
                if (gridcheck == 3) {

                    if (column.fieldName == "StepCode") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                    }
                }
                valchange3 = false;
                valchange = false;

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



        function Clear() {
            glInvoice.SetValue(null);
        }

        function autocalculate(s, e) {

            var amount = 0.00;
            var totalamountdetail = 0.00;
            var qty = 0.00;
            var price = 0.00;
            var TotalQuantity = 0.00;
            var TotalAmount = 0.00;


            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {


                        qty = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "Qty"));
                        price = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "Price"));

                        TotalQuantity += qty * 1.00;
                        
                        totalamountdetail= (qty * price).toFixed(2)
                        if (isNaN(totalamountdetail) == true) {
                            totalamountdetail = 0;
                        }


                        


                        gv1.batchEditApi.SetCellValue(indicies[i], "Amount", totalamountdetail);
                        //RRA
                       
                        amount = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "Amount"));
                     
                        TotalAmount += amount;
      

                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            qty = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "Qty"));
                            price = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "Price"));

                            TotalQuantity += qty * 1.00;


                            totalamountdetail = (qty * price).toFixed(2)
                            if (isNaN(totalamountdetail) == true) {
                                totalamountdetail = 0;
                            }





                            gv1.batchEditApi.SetCellValue(indicies[i], "Amount", totalamountdetail);
                            //RRA

                            amount = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "Amount"));

                            TotalAmount += amount;
                        }
                    }
                }







                //RA

                txtQty.SetValue(TotalQuantity.toFixed(2));
                txtAmount.SetValue(TotalAmount.toFixed(2));

            }, 500);



        }
        function autocalculate1(s, e) {

            var amount = 0.00;
            var totalamountdetail = 0.00;
            var qty = 0.00;
            var price = 0.00;
            var TotalQuantity = 0.00;
            var TotalAmount = 0.00;


            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {


               



    //RRA

                        amount = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "Amount"));

                        TotalAmount += amount;


                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                    


                             //RRA

                            amount = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "Amount"));

                            TotalAmount += amount;
                        }
                    }
                }







                //RA

               
                txtAmount.SetValue(TotalAmount.toFixed(2));

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

        function ReferenceEffect(s, e) {

            cp.PerformCallback('CallbackWithReference')

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
                                <dx:ASPxLabel runat="server" Text="Material Issuance" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
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

                    <dx:ASPxFormLayout ID="frmlayout1" runat="server"  Height="565px" Width="150px" style="margin-left: -3px" ClientInstanceName="frmlayout">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                          <%--<!--#region Region Header --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                                      <dx:LayoutItem Caption="Document Number:" Name="DocNumber" >
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
                                                        <dx:ASPxDateEdit ID="dtpdocdate" runat="server"  OnInit="dtpDocDate_Init" Width="170px" OnLoad="Date_Load">
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
                                             

                                            

                                                                                                  
                                            <dx:LayoutItem Caption="Transaction Type">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                         <dx:ASPxTextBox ID="txtTransactionType" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                  <dx:LayoutItem Caption="Issued To" RequiredMarkDisplayMode="Required" Name="IssuedTo">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglIssuedTo" runat="server" ClientInstanceName="aglIssuedTo" DataSourceID="sdsIssuedTo" AutoGenerateColumns="False" KeyFieldName="Code" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px" >
                                                                    <GridViewProperties >
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('CallbackIssuedTo');}" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                              
                                          <dx:LayoutItem Caption="With Reference">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkIsWithRef" runat="server" Checked="True" CheckState="Checked" ClientInstanceName="chkIsWithRef">
                                                                    <ClientSideEvents CheckedChanged="ReferenceEffect" />
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>



                                               <dx:LayoutItem Caption="Reference Number" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglRefNum" runat="server" DataSourceID="sdsReference" AutoGenerateColumns="False" KeyFieldName="DocNumber" 
                                                                    OnLoad="LookupLoad" TextFormatString="{0}" Width="170px"  ClientInstanceName="refno">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0" Caption ="Document Number">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="DocDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Caption ="Document Date" PropertiesTextEdit-DisplayFormatString="MM/dd/yyyy">
                                                                            <PropertiesTextEdit DisplayFormatString="MM/dd/yyyy"></PropertiesTextEdit>
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="RequestedBy" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Caption ="Requested By">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CostCenter" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3" Caption ="Cost Center">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Remarks" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4" Width="200px">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('CallbackReference');}" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                            

                                                        <dx:LayoutItem Caption=" Total Quantity">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speQty" runat="server" Width="170px" ReadOnly="True"  ClientInstanceName="txtQty"    DisplayFormatString="{0:N}"  NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                         
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                    
              
                                               <dx:LayoutItem Caption="Remarks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxMemo ID="memoremarks" runat="server" Width="170px" Height="50">
                                                                                </dx:ASPxMemo>

                                                       
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>




                                                <dx:LayoutItem ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvRefC" runat="server" ClientInstanceName="gvRefC" AutoGenerateColumns="true" BatchEditStartEditing="OnStartEditing">
                                                                    <SettingsEditing Mode="Batch" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem> 


                                         
                                        </Items>
                                    </dx:LayoutGroup>
                                     <%-- <dx:LayoutGroup Caption="User Defined" ColCount="2">
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
                                       <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction">
                                                   <Items>
                                    <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="608px"  KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber"  ClientInstanceName="gvRef" >
                                                            <ClientSideEvents Init="OnInitTrans" />
                                                          <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="130" VerticalScrollBarMode="Auto" />
                                                           <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                            <SettingsPager PageSize="5">
                                                            </SettingsPager>
                                                            <SettingsEditing Mode="Batch">      
                                                            </SettingsEditing>
                                                              <SettingsBehavior FilterRowMode="OnClick" ColumnResizeMode="NextColumn" />
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
                                  

                 <%--<dx:LayoutGroup Caption="Journal Entries">
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
                                    </dx:LayoutGroup>--%>
                                </Items>
                            </dx:TabbedLayoutGroup>
                                                             <dx:LayoutGroup Caption="Details" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem ShowCaption="False">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="1023px" DataSourceID ="sdsDetail"
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
                                                                <dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True" Visible="False" ShowInCustomizationForm="True" VisibleIndex="0" Width="80px">
                                                                    <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                    </PropertiesTextEdit>
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ShowDeleteButton="true"  ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="60px" ShowNewButtonInHeader="true">
                                                                                                               <CustomButtons>
                                                            <dx:GridViewCommandColumnCustomButton ID="Details">
                                                               <Image IconID="support_info_16x16"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                        </CustomButtons>
                                                            
                                                             </dx:GridViewCommandColumn>
                                                                                                              
                                                        <dx:GridViewDataTextColumn VisibleIndex="30" Name="glpItemCode" Width="0">                                                            
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" OnInit="glItemCode_Init"
                                                                    ClientInstanceName="gl6" TextFormatString="{0}" Width="0px" >
                                                                   <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" Settings-VerticalScrollBarMode="Visible"> 
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True"/>
                                                                    </GridViewProperties>
                                                                    <ClientSideEvents EndCallback="GridEnd" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                             
                                                                <dx:GridViewDataTextColumn Caption="Step Code" FieldName="StepCode" Name="StepCode" ShowInCustomizationForm="True"  Visible="False" VisibleIndex="0" Width="100px" UnboundType="Bound">
                                                               
                                                                     </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="4" Name="glpItemCode1" Width="100px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">                                                            
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode1" runat="server" AutoGenerateColumns="false" AutoPostBack="false" OnInit="glItemCode1_Init"  
                                                                   KeyFieldName="ItemCode" DataSourceID="sdsItemDetail" ClientInstanceName="gl" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                   <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" Settings-VerticalScrollBarMode="Visible"> 
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True"/>
                                                                    </GridViewProperties>
                                                          <Columns>
                                                                                                                                      <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" Width="120px" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                      
                                                          </Columns>
                                                                    <ClientSideEvents  KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  
                                                                                                                                           
                                                                         DropDown="function(s,e){
                                                                  
                                                                        gl.GetGridView().PerformCallback('ItemCode' + '|' + jo + '|' + s.GetInputElement().value + '|' + step + '|' + itemc  + '|' +'code'  + '|' + 'code'  + '|' + 'code'  );
                                                                      
                                                                   
                                                                        }"
                                                                            ValueChanged="function(s,e){
                                                                                                            if(itemc != gl.GetValue()){
                                                                                                            gl6.GetGridView().PerformCallback('ItemCode' + '|' + jo + '|' + s.GetInputElement().value + '|' + step + '|' + itemc  + '|' +'code'  + '|' + 'code'  + '|' + 'code'  );
                                                                        valchange3 = true;                       
                                                                                                                                                         e.processOnServer = false;
                                                                                                          }
                                                                                                        }"  />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Item Description" FieldName="Description" Name="Description"  Width="250px" ShowInCustomizationForm="True"  VisibleIndex="4" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                               
                                                                     </dx:GridViewDataTextColumn>
                                    
                                                   
                                                        <dx:GridViewDataTextColumn Caption="Material Type" FieldName="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="5" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2" 
                                                                    KeyFieldName="ColorCode" OnInit="glItemCode_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="130px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn  FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" />
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
                                                        <dx:GridViewDataTextColumn Caption="Batch Number" FieldName="Remarks" Name="Remarks" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="6" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" Name="ClassCode" ShowInCustomizationForm="True" Visible="false" VisibleIndex="0" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl3" 
                                                                    KeyFieldName="ClassCode" OnInit="glItemCode_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents  CloseUp="gridLookup_CloseUp" EndCallback="GridEnd"
                                                                        KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"
                                                                        DropDown="function(s,e){
                                                                        if(nope==false){
                                                                        nope = true;
                                                                        loader.Show();
                                                                        loader.SetText('Loading2...');
                                                                        loading = true;
                                                                        gl3.GetGridView().PerformCallback('ClassCode' + '|' + jo + '|' + s.GetInputElement().value + '|' + step + '|' + itemc  + '|' +'code'  + '|' + 'code'  + '|' + 'code'  );
                                                                        }
                                                                        }"
                                                                       
                                                                       />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" Name="SizeCode" ShowInCustomizationForm="True" Visible="false" VisibleIndex="0" Width="80px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl5"
                                                                     KeyFieldName="SizeCode" OnInit="glItemCode_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents  CloseUp="gridLookup_CloseUp" EndCallback="GridEnd"
                                                                        KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"
                                                                        GotFocus="function(s,e){
                                                                        if(nope==false){
                                                                        nope = true;
                                                                        loader.Show();
                                                                        loader.SetText('Loading2...');
                                                                        loading = true;
                                                                        gl5.GetGridView().PerformCallback('SizeCode' + '|' + jo + '|' + s.GetInputElement().value + '|' + step + '|' + itemc  + '|' +'code'  + '|' + 'code'  + '|' + 'code'  );
                                                                        }
                                                                        }"
                                                                        DropDown="lookup"
                                                                     />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                                                   <dx:GridViewDataSpinEditColumn FieldName="Requested Qty" Name="glQty" ShowInCustomizationForm="True" VisibleIndex="12" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                               <PropertiesSpinEdit Increment="0" ClientInstanceName="glQty"  NullDisplayText="0" MinValue="0" MaxValue="999999999"  ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" AllowMouseWheel="false" SpinButtons-ShowIncrementButtons ="false">
                                                            <ClientSideEvents ValueChanged="autocalculate"  />
                                                                   </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataSpinEditColumn FieldName="Issued Qty" Name="gPrice" ShowInCustomizationForm="True" VisibleIndex="12" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                               <PropertiesSpinEdit Increment="0" ClientInstanceName="gPrice"  NullDisplayText="0" MinValue="0" MaxValue="999999999"  ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" AllowMouseWheel="false" SpinButtons-ShowIncrementButtons ="false">
                                                            <ClientSideEvents ValueChanged="autocalculate"  />
                                                                   </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                         <dx:GridViewDataTextColumn Caption="UOM" FieldName="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="12" Width="80px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2" 
                                                                    KeyFieldName="ColorCode" OnInit="glItemCode_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn  FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" />
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
                                                         <dx:GridViewDataTextColumn Caption="Shift" FieldName="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="12" Width="80px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2" 
                                                                    KeyFieldName="ColorCode" OnInit="glItemCode_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn  FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" />
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
                                                                                <dx:GridViewDataSpinEditColumn FieldName="Amount" Name="gAmount" ShowInCustomizationForm="True" Visible="false" VisibleIndex="12" >
                                                               <PropertiesSpinEdit Increment="0" ClientInstanceName="gAmount"  NullDisplayText="0" MinValue="0" MaxValue="999999999"  ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" AllowMouseWheel="false" SpinButtons-ShowIncrementButtons ="false">
                                                            <ClientSideEvents ValueChanged="autocalculate1"   />
                                                                   </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        
                                                                <dx:GridViewDataTextColumn Caption="Field1" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" UnboundType="String" Visible="false" VisibleIndex="16">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field2" FieldName="Field2" Name="Field2" ShowInCustomizationForm="True" UnboundType="String" Visible="false" VisibleIndex="17">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field3" FieldName="Field3" Name="Field3" ShowInCustomizationForm="True" UnboundType="String" Visible="false" VisibleIndex="18">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field4" FieldName="Field4" Name="Field4" ShowInCustomizationForm="True" UnboundType="String" Visible="false" VisibleIndex="19">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field5" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" UnboundType="String" Visible="false" VisibleIndex="20">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field6" FieldName="Field6" Name="Field6" ShowInCustomizationForm="True" UnboundType="String" Visible="false" VisibleIndex="21">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field7" FieldName="Field7" Name="Field7" ShowInCustomizationForm="True" UnboundType="String" Visible="false" VisibleIndex="22">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field8" FieldName="Field8" Name="Field8" ShowInCustomizationForm="True" UnboundType="String" Visible="false" VisibleIndex="23">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field9" FieldName="Field9" Name="Field9" ShowInCustomizationForm="True" UnboundType="String" Visible="false" VisibleIndex="24">
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
                                         <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Cloning..." Modal="true"
            ClientInstanceName="loader" ContainerElementID="gv1">
             <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
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

            <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.MaterialIssuance+MaterialIssuanceDetail" SelectMethod="getdetail" UpdateMethod="UpdateIssuanceDetail" TypeName="Entity.MaterialIssuance+MaterialIssuanceDetail" DeleteMethod="DeleteIssuanceDetail" InsertMethod="AddIssuanceDetail">
              <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Production.MaterialIssuanceDetail where DocNumber is null"   OnInit = "Connection_Init">
    </asp:SqlDataSource>
       
     <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT ItemCode,StepCode,DocNumber FROM Production.JOMaterialMovement"   OnInit = "Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="sdsIssuedTo" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT EmployeeCode AS Code, LastName + ', ' + FirstName AS Name FROM Masterfile.BPEmployeeInfo WHERE ISNULL(IsInactive,0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
     <asp:SqlDataSource ID="sdsReferenceDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" " OnInit ="Connection_Init"></asp:SqlDataSource>
  
       <%-- <asp:SqlDataSource ID="sdsReference" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" SELECT DocNumber, CONVERT(Date,DocDate,101) AS DocDate, RequestedBy, CostCenter, Remarks FROM Inventory.Request WHERE (ISNULL(AuthorizedBy,'') != '' OR ISNULL(ApprovedBy,'') != '') AND Status IN ('N','P')" OnInit ="Connection_Init"></asp:SqlDataSource>--%>
     <asp:SqlDataSource ID="sdsReference" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber, CONVERT(Date,DocDate,101) AS DocDate, RequestedBy, CostCenter, Remarks FROM Inventory.Request WHERE (ISNULL(SubmittedBy,'') != '' OR ISNULL(ApprovedBy,'') != '')" OnInit ="Connection_Init"></asp:SqlDataSource>

                <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.ChargeReceipt+RefTransaction" >
        <SelectParameters>
             <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

</body>
</html>


