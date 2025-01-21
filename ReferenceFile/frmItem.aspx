<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmItem.aspx.cs" Inherits="GWL.frmItem" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>



<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Item Masterfile</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
    <%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script>
    <%--NEWADD--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 525px; /*Change this whenever needed*/
        }

        .Entry {
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
        }

        .pnl-content {
            text-align: right;
        }
    </style>
    <!--#endregion-->
    <!--#region Region Javascript-->
    <script>
        var isValid = true;
        var counterror = 0;

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        var param = getParameterByName("parameters");

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
                console.log('invalid');
                //counterror++;
                isValid = false
                e.isValid = false
            }
        }

        function OnValidationProd(s, e) { //Validation function for header controls (Set this for each header controls)
            if (txtHavProdSub.GetText() == "True" && (txtprodsubcat.GetText() == null || txtprodsubcat.GetText() == '')) {
                e.isValid = false
                isValid = false;
            }
            //else {
            //    e.isValid = true;
            //    console.log('true');
            //}
        }





        function checkPercentage() {
            var perc = 0.00;
            var totalperc = 0.00;
            var indicies = gvFabric.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < indicies.length; i++) {
                if (gvFabric.batchEditApi.IsNewRow(indicies[i])) {
                    perc = parseFloat(gvFabric.batchEditApi.GetCellValue(indicies[i], "Percentage"));
                    gvFabric.batchEditApi.ValidateRow(indicies[i]);
                    gvFabric.batchEditApi.StartEdit(indicies[i], gvFabric.GetColumnByField("Percentage").index);
                    gvFabric.batchEditApi.EndEdit();
                    totalperc += perc;
                }
                else {
                    var key = gvFabric.GetRowKey(indicies[i]);
                    if (gvFabric.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indicies[i]);
                    else {
                        perc = parseFloat(gvFabric.batchEditApi.GetCellValue(indicies[i], "Percentage"));
                        gvFabric.batchEditApi.ValidateRow(indicies[i]);
                        gvFabric.batchEditApi.StartEdit(indicies[i], gvFabric.GetColumnByField("Percentage").index);
                        gvFabric.batchEditApi.EndEdit();
                        totalperc += perc;
                    }
                }
            }
            if (totalperc != 100 && cboxItemType.GetText() != 'Limited Quantity')
                return false;
            else
                return true;
        }


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
                //gv1.batchEditApi.EndEdit();
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }


        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            var btnmode = btn.GetText(); //gets text of button
            gvUnit.batchEditApi.EndEdit();
           
            gvFabric.batchEditApi.EndEdit();
            if (isValid|| btnmode == "Close") { //check if there's no error then proceed to callback
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

            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
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
        }

        var itemc; //variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var evn;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for

            evn = e;



            var entry = getParameterByName('entry');

            if (entry === "V")
            {
                e.cancel = true;
            }
            else
            {
                if (e.focusedColumn.fieldName === "FromUnit") {
                    d1fromunit.GetInputElement().value = cellInfo.value;                    
                }
                if (e.focusedColumn.fieldName === "ToUnit") {
                    d1tounit.GetInputElement().value = cellInfo.value;
                }

            }


            //console.log("name: " + s.name + " type : " + entry);


            //if (e.visibleIndex < 0) {//new row
            //    var linenumber = s.GetColumnByField("LineNumber");
            //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
            //}

            //if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
            //    gl.GetInputElement().value = cellInfo.value; //Gets the column value
            //    isSetTextRequired = true;
            //}
            if (e.focusedColumn.fieldName === "ColorCode") {
                gl2.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "ClassCode") {
                gl3.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "SizeCode") {
                gl4.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "Description") {
                fabtype.GetInputElement().value = cellInfo.value;
            }


            if (e.focusedColumn.fieldName === "ColorCode" || e.focusedColumn.fieldName === "ClassCode" ||
               e.focusedColumn.fieldName === "SizeCode" || e.focusedColumn.fieldName === "Barcode" || e.focusedColumn.fieldName === "StatusCode") {
                if (s.batchEditApi.GetCellValue(e.visibleIndex, "AddedDetail") != "" && s.batchEditApi.GetCellValue(e.visibleIndex, "AddedDetail") != null) {
                    e.cancel = true;

                    console.log(s.batchEditApi.GetCellValue(e.visibleIndex, "AddedDetail"));
                }

            }

            if (e.focusedColumn.fieldName === "BaseUnit") {
                e.cancel = true
            }


            if (e.focusedColumn.fieldName === "IsInactive") {
                if ((s.batchEditApi.GetCellValue(e.visibleIndex, "OnHand") != 0 && s.batchEditApi.GetCellValue(e.visibleIndex, "OnHand") != null) ||
                (s.batchEditApi.GetCellValue(e.visibleIndex, "OnOrder") != 0 && s.batchEditApi.GetCellValue(e.visibleIndex, "OnOrder") != null) ||
            (s.batchEditApi.GetCellValue(e.visibleIndex, "OnAlloc") != 0 && s.batchEditApi.GetCellValue(e.visibleIndex, "OnAlloc") != null) ||
            (s.batchEditApi.GetCellValue(e.visibleIndex, "OnBulkQty") != 0 && s.batchEditApi.GetCellValue(e.visibleIndex, "OnBulkQty") != null))
                    e.cancel = true;
            }



        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            //if (currentColumn.fieldName === "ItemCode") {
            //    cellInfo.value = gl.GetValue();
            //    cellInfo.text = gl.GetText();
            //}

            if (currentColumn.fieldName === "FromUnit") {
                cellInfo.value = d1fromunit.GetValue();
                cellInfo.text = d1fromunit.GetText();
            }
            if (currentColumn.fieldName === "ToUnit") {
                cellInfo.value = d1tounit.GetValue();
                cellInfo.text = d1tounit.GetText();
            }


            if (currentColumn.fieldName === "ColorCode") {
                cellInfo.value = gl2.GetValue();
                cellInfo.text = gl2.GetText();
            }
            if (currentColumn.fieldName === "ClassCode") {
                cellInfo.value = gl3.GetValue();
                cellInfo.text = gl3.GetText();
            }
            if (currentColumn.fieldName === "SizeCode") {
                cellInfo.value = gl4.GetValue();
                cellInfo.text = gl4.GetText();
            }
            if (currentColumn.fieldName === "Description") {
                cellInfo.value = fabtype.GetValue();
                cellInfo.text = fabtype.GetText();
            }
            //if (currentColumn.fieldName === "BulkUnit") {
            //    cellInfo.value = glBulkUnit.GetValue();
            //    cellInfo.text = glBulkUnit.GetText();
            //}
            //if (currentColumn.fieldName === "Unit") {
            //    cellInfo.value = glUnit.GetValue();
            //    cellInfo.text = glUnit.GetText();
            //}
        }

        function OnStartEditing2(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for

            //s.batchEditApi.SetCellValue(e.visibleIndex, "BaseUnit", txtbaseunit.GetText());
            if (e.focusedColumn.fieldName === "ItemCode") {
                glItem.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "ColorCode") {
                glColor.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "ClassCode") {
                glClass.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "SizeCode") {
                glSize.GetInputElement().value = cellInfo.value;
            }
            //if (e.focusedColumn.fieldName === "SubstitutedColor") {
            //    glColor2.GetInputElement().value = cellInfo.value;
            //}
            //if (e.focusedColumn.fieldName === "SubstitutedClass") {
            //    glClass2.GetInputElement().value = cellInfo.value;
            //}
            //if (e.focusedColumn.fieldName === "SubstitutedSize") {
            //    glSize2.GetInputElement().value = cellInfo.value;
            //}
            if (e.focusedColumn.fieldName === "Customer") {
                gvCustomer.GetInputElement().value = cellInfo.value;
            }
        }

        function OnEndEditing2(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            //if (currentColumn.fieldName === "ItemCode") {
            //    cellInfo.value = gl.GetValue();
            //    cellInfo.text = gl.GetText();
            //}
            //if (currentColumn.fieldName === "SubstitutedItem") {
            //    cellInfo.value = glItem.GetValue();
            //    cellInfo.text = glItem.GetText();
            //}
            if (currentColumn.fieldName === "ColorCode") {
                cellInfo.value = glColor.GetValue();
                cellInfo.text = glColor.GetText();
            }
            if (currentColumn.fieldName === "ClassCode") {
                cellInfo.value = glClass.GetValue();
                cellInfo.text = glClass.GetText();
            }
            if (currentColumn.fieldName === "SizeCode") {
                cellInfo.value = glSize.GetValue();
                cellInfo.text = glSize.GetText();
            }
            //if (currentColumn.fieldName === "SubstitutedColor") {
            //    cellInfo.value = glColor2.GetValue();
            //    cellInfo.text = glColor2.GetText();
            //}
            //if (currentColumn.fieldName === "SubstitutedClass") {
            //    cellInfo.value = glClass2.GetValue();
            //    cellInfo.text = glClass2.GetText();
            //}
            //if (currentColumn.fieldName === "SubstitutedSize") {
            //    cellInfo.value = glSize2.GetValue();
            //    cellInfo.text = glSize2.GetText();
            //}
            if (currentColumn.fieldName === "Customer") {
                cellInfo.value = gvCustomer.GetValue();
                cellInfo.text = gvCustomer.GetText();
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
            gv2.batchEditApi.EndEdit();
        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                if (column != s.GetColumn(3) && column != s.GetColumn(6) && column != s.GetColumn(1) && column != s.GetColumn(7) && column != s.GetColumn(5) && column != s.GetColumn(8) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23) && column != s.GetColumn(24) && column != s.GetColumn(25) && column != s.GetColumn(26) && column != s.GetColumn(24) && column != s.GetColumn(13)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                    else {
                        isValid = true;
                    }
                }
            }
        }

        var clonenumber = 0;
        var cloneindex;
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


                if (s.batchEditApi.GetCellValue(e.visibleIndex, "AddedDetail") != "" && s.batchEditApi.GetCellValue(e.visibleIndex, "AddedDetail") != null) {
                    e.cancel = true;
                }

                else {
                    gv1.DeleteRow(e.visibleIndex);
                }
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


        function OnInitTrans(s, e) {
            AdjustSize();
            isValid = true;
        }

        function OnControlsInitialized(s, e) {
            ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                AdjustSize();
            });
        }

        function AdjustSize() {
            var width = Math.max(0, document.documentElement.clientWidth);
            //gv1.SetWidth(width - 120);
            //gv2.SetWidth(width - 120);
            //gv3.SetWidth(width - 120);
            //gv4.SetWidth(width - 120);
        }

    </script>
    <!--#endregion-->
</head>
<body style="height: 910px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None"
            EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="0"
            ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True" Collapsed="true">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel ID="FormLabel" runat="server" Text="Item Masterfile" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="850px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" Style="margin-left: -3px">
                        <%--<SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />--%>
                        <Items>

                            <%--<!--#region Region Header --> --%>
                            <%-- <!--#endregion --> --%>

                            <%--<!--#region Region Details --> --%>

                            <%-- <!--#endregion --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="Generic Tab" ColCount="2">
                                        <Items>
                                            <%--                                            <dx:LayoutItem Caption="Is Service">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" >
                                                        <dx:ASPxCheckBox ID="chkIsService" runat="server" CheckState="Unchecked">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Item Code:" Name="txtitemCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtItemCode" runat="server" Width="170px" OnTextChanged="txtDocnumber_TextChanged" ReadOnly="False" OnLoad="TextboxLoad"
                                                            MaxLength="50" ClientInstanceName="txtitemcode">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <ErrorImage ToolTip="Supplier is required">
                                                                </ErrorImage>
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- <dx:EmptyLayoutItem>
                                            </dx:EmptyLayoutItem>--%>
                                            <dx:LayoutItem Caption="Item Description" Name="txtitedesc">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtitemdesc" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Item Category" Name="itemtype">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="cboxItemType" runat="server" DataSourceID="ItemCat" Width="170px" ClientInstanceName="cboxItemType" OnLoad="Comboboxload"
                                                            TextField="Description" ValueField="Code" ValueType="System.String" IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <%-- <dx:LayoutItem Caption="Short Description" Name="txtdesc" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtshortdesc" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>

                                            <%-- 
                                            <dx:LayoutItem Caption="Item Category" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtitemcat2" runat="server" Width="170px" readonly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Item Category:" Name="txtitemcategory" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup Width="170px" ID="txtitemcat" ClientInstanceName="txtitemcat" runat="server" AutoGenerateColumns="False" DataSourceID="ItemCategory" KeyFieldName="ItemCategoryCode" OnLoad="LookupLoad" OnTextChanged="glWarehouseCOde_TextChanged" 
                                                            Readonly="true"
                                                            TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="ItemCategoryCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <ErrorImage ToolTip="ItemCategory is required">
                                                                </ErrorImage>
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Product Category:" Name="txtProdCat" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup Width="170px" ID="txtprodcategory" runat="server" AutoGenerateColumns="False" DataSourceID="ProdCat" KeyFieldName="ProductCategoryCode"
                                                            OnLoad="LookupLoad" OnTextChanged="glWarehouseCOde_TextChanged" TextFormatString="{0}" ClientInstanceName="txtprodcategory">
                                                            <ClientSideEvents ValueChanged="function(s,e){ cp.PerformCallback('prodcat'); e.processOnServer = false; }" />
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="ProductCategoryCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <ErrorImage ToolTip="Supplier is required">
                                                                </ErrorImage>
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                        <dx:ASPxTextBox runat="server" ClientInstanceName="txtHavProdSub" ID="txtHavProdSub" ClientVisible="false">
                                                            <ClientSideEvents TextChanged="function(){ console.log('here')}" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <%-- <dx:LayoutItem Caption="Product Sub Category:" Name="txtProdsubcat" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup Width="170px" ID="txtprodsubcat" runat="server" AutoGenerateColumns="False" DataSourceID="ProdSubCat" ClientInstanceName="txtprodsubcat"
                                                            KeyFieldName="ProductSubCatCode" OnLoad="LookupLoad" OnTextChanged="glWarehouseCOde_TextChanged" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="ProductSubCatCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidationProd" />
                                                            <ValidationSettings ErrorText="Product sub category is required">--%>
                                                                <%--<ErrorImage ToolTip="Product sub category is required">
                                                                </ErrorImage>--%>
                                                           <%--  </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <%-- 
                                            <dx:LayoutItem Caption="Item Customer:" Name="txtitemcustomer" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup Width="170px" ID="txtitemcustomer" runat="server" AutoGenerateColumns="False" DataSourceID="customer" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" OnTextChanged="glWarehouseCOde_TextChanged" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Item Supplier:" Name="txtitemsupplier" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup Width="170px" ID="txtitemsupplier" runat="server" AutoGenerateColumns="False" DataSourceID="supplier" KeyFieldName="SupplierCode" OnLoad="LookupLoad" OnTextChanged="glWarehouseCOde_TextChanged" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>

                                            <dx:LayoutItem Caption="Base Unit" Name="txtbaseunit">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup Width="170px" ID="txtbaseunit" runat="server" AutoGenerateColumns="False" DataSourceID="unit"
                                                            KeyFieldName="UnitCode" OnLoad="LookupLoad" TextFormatString="{0}" ClientInstanceName="txtbaseunit">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <ErrorImage ToolTip="Base Qty Unit is required">
                                                                </ErrorImage>
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="MOQ" Name="txtReorderlevel">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtreorderlevel" runat="server" Width="170px" OnLoad="SpinEdit_Load">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- <dx:LayoutItem Caption="Unit Bulk" Name="txtunitbulk" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup Width="170px" ID="txtunitbulk" ClientInstanceName="txtunitbulk" runat="server" AutoGenerateColumns="False" DataSourceID="unit" KeyFieldName="UnitCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <ErrorImage ToolTip="Unit for Bulk is required">
                                                                </ErrorImage>
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            
                                            
                                            <%-- 
                                            <dx:LayoutItem Caption="Is Core" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkIsCore" runat="server" CheckState="Unchecked" OnLoad="Check_Load">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Estimated Cost" Name="txtReorderlevel" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtestcost" runat="server" Width="170px" OnLoad="SpinEdit_Load">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Tax Code" Name="aglTaxCode" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="aglTaxCode" ClientInstanceName="aglTaxCode" runat="server" DataSourceID="sdsTaxCode"
                                                            Width="170px" KeyFieldName="TCode" OnLoad="LookupLoad" TextFormatString="{0}" AutoGenerateColumns="false">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="TCode" ReadOnly="true" Caption="Tax Code">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Rate" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Is Inactive">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkIsInactive" runat="server" CheckState="Unchecked" ReadOnly="True">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- 
                                            <dx:LayoutItem Caption="Clone" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="SpinClone" runat="server" Increment="0" NullText="0" MaxValue="9999999999" MinValue="0" Width="170px" ClientInstanceName="CINClone" SpinButtons-ShowIncrementButtons="false">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Is ByBulk" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox runat="server" CheckState="Unchecked" ID="chkIsBulk" OnLoad="Check_Load"></dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>

                                            <%-- 
                                            <dx:LayoutGroup Caption="Lines" ColSpan="2" >
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" ClientInstanceName="gv1" KeyFieldName="ItemCode;ColorCode;ClassCode;SizeCode" OnBatchUpdate="gv1_BatchUpdate" OnCellEditorInitialize="gv1_CellEditorInitialize" OnCommandButtonInitialize="gvitem_CommandButtonInitialize" OnInitNewRow="gv1_InitNewRow" Width="1077px">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" Init="OnInitTrans" />
                                                                    <SettingsPager Mode="ShowAllRecords">
                                                                    </SettingsPager>
                                                                    <SettingsEditing Mode="Batch">
                                                                    </SettingsEditing>
                                                                    <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="400" VerticalScrollBarMode="Auto" />
                                                                    <SettingsBehavior AllowSort="False" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="80px">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                                    <Image IconID="actions_cancel_16x16"></Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                <dx:GridViewCommandColumnCustomButton ID="CloneButton" Text="Copy">
                                                                                    <Image IconID="edit_copy_16x16" ToolTip="Clone"></Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                                    <Image IconID="support_info_16x16">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="prevColorCode" FieldName="prevColorCode" ReadOnly="True" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="4" Width="0px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="prevSizeCode" FieldName="prevSizeCode" ReadOnly="True" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="5" Width="0px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="prevClassCode" FieldName="prevClassCode" ReadOnly="True" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="6" Width="0px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="5" Width="80px">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="ColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2" DataSourceID="color" KeyFieldName="ColorCode" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" />
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents DropDown="lookup" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" ValueChanged="gridLookup_CloseUp" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Description" FieldName="Description" Name="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" Name="SizeCode" ShowInCustomizationForm="True" VisibleIndex="5" Width="80px">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="SizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl4" DataSourceID="size" KeyFieldName="SizeCode" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" />
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents DropDown="lookup" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" ValueChanged="gridLookup_CloseUp" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" Name="ClassCode" ShowInCustomizationForm="True" VisibleIndex="5" Width="80px">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="ClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl3" DataSourceID="class" KeyFieldName="ClassCode" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" />
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents DropDown="lookup" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" ValueChanged="gridLookup_CloseUp" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Barcode" FieldName="Barcode" Name="Barcode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="OnHand" FieldName="OnHand" Name="OnHand" ReadOnly="True" ShowInCustomizationForm="True" UnboundType="Decimal" VisibleIndex="8">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="OnOrder" FieldName="OnOrder" Name="OnOrder" ReadOnly="True" ShowInCustomizationForm="True" UnboundType="Decimal" VisibleIndex="9">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="OnAlloc" FieldName="OnAlloc" Name="OnAlloc" ReadOnly="True" ShowInCustomizationForm="True" UnboundType="Decimal" VisibleIndex="10">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="OnBulkQty" FieldName="OnBulkQty" Name="OnBulkQty" ReadOnly="True" ShowInCustomizationForm="True" UnboundType="Decimal" VisibleIndex="11">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="InTransit" FieldName="InTransit" Name="InTransit" ReadOnly="True" ShowInCustomizationForm="True" UnboundType="Decimal" VisibleIndex="12">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="StatusCode" FieldName="StatusCode" Name="StatusCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="13">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="SizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="glStat" DataSourceID="Statussql" KeyFieldName="StatusCode" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="StatusCode" ReadOnly="True" VisibleIndex="0" />
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents DropDown="lookup" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" ValueChanged="gridLookup_CloseUp" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="BaseUnit" FieldName="BaseUnit" Name="BaseUnit" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="14">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataCheckColumn FieldName="IsInactive" ShowInCustomizationForm="True" VisibleIndex="17">
                                                                            <PropertiesCheckEdit>
                                                                                <ClientSideEvents CheckedChanged="function(s,e){ gv1.batchEditApi.EndEdit(); }" />
                                                                            </PropertiesCheckEdit>
                                                                        </dx:GridViewDataCheckColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field1" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="18">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field2" FieldName="Field2" Name="Field2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="19">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field3" FieldName="Field3" Name="Field3" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="20">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field4" FieldName="Field4" Name="Field4" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field5" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="22">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field6" FieldName="Field6" Name="Field6" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="23">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field7" FieldName="Field7" Name="Field7" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="24">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field8" FieldName="Field8" Name="Field8" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="25">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field9" FieldName="Field9" Name="Field9" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="26">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="" Width="0px" FieldName="AddedDetail" Name="AddedDetail" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="26">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                                --%>

                                            <dx:LayoutGroup Caption="UOM Detail">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvUnit" runat="server" AutoGenerateColumns="False" Width="500px"
                                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="gvUnit" OnInitNewRow="gvUnit_InitNewRow"
                                                                    OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="ItemCode;FromUnit;ToUnit" SettingsBehavior-AllowSort="False"
                                                                    Settings-ShowStatusBar="Hidden">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans"
                                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <SettingsEditing Mode="Batch" />
                                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="200" ShowFooter="True" />
                                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>
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

                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="60px">
                                                                        </dx:GridViewCommandColumn>

                                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="1" Visible="true" Width="100px">
                                                                        </dx:GridViewDataTextColumn>

                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" Visible="true" Width="0px">
                                                                        </dx:GridViewDataTextColumn>

                                                                        <dx:GridViewDataTextColumn FieldName="FromUnit" VisibleIndex="2" Width="100px" Caption="FromUnit">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="d1fromunit" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                    KeyFieldName="UnitCode" DataSourceID="unit" ClientInstanceName="d1fromunit" TextFormatString="{0}" Width="100px">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>


                                                                        <dx:GridViewDataTextColumn FieldName="ToUnit" VisibleIndex="3" Width="100px" Caption="ToUnit">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="d1tounit" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                    KeyFieldName="UnitCode" DataSourceID="unit" ClientInstanceName="d1tounit" TextFormatString="{0}" Width="100px">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>


                                                                        <dx:GridViewDataSpinEditColumn FieldName="UnitFactor" Caption="Factor" VisibleIndex="4" Width="100px">
                                                                           <%-- <PropertiesSpinEdit Increment="0" ClientInstanceName="d1unitfactor" MinValue="0.99999" MaxValue="999999999" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            </PropertiesSpinEdit>--%>
                                                                        </dx:GridViewDataSpinEditColumn>

                                                                    </Columns>



                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>


                                        </Items>

                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Name="FabricInfo" Paddings-Padding="0px" Caption="Fabric Information Tab" ColCount="2" ClientVisible="false">
                                        <Paddings Padding="0px"></Paddings>
                                        <Items>
                                            <dx:LayoutGroup Paddings-Padding="0px" ShowCaption="False" GroupBoxStyle-Border-BorderStyle="None">
                                                <Border BorderStyle="None" />

                                                <Paddings Padding="0px"></Paddings>

                                                <GroupBoxStyle>
                                                    <border borderstyle="None"></border>
                                                </GroupBoxStyle>
                                                <Items>
                                                    <%--                                                    <dx:LayoutItem Caption="Key Supplier">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtKeySupp" runat="server" DataSourceID="supplier" TextFormatString="{0}"
                                                                 KeyFieldName="SupplierCode"></dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                    <dx:LayoutItem Paddings-Padding="0px" Caption="Retail Fabric Code">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtRetailFabCode" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>

                                                        <Paddings Padding="0px"></Paddings>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Fabric Group">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox runat="server" ID="txtFabGroup" DataSourceID="FabricGroup" Width="170px"
                                                                    TextField="Description" ValueField="Code" ValueType="System.String" IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                                                    <ClientSideEvents ValueChanged="function(){cp.PerformCallback('fabgroup');}" />
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Fabric Design Category">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox runat="server" ID="txtFabDesCat" DataSourceID="FabDesign" Width="170px"
                                                                    TextField="Description" ValueField="FabricDesignCode" ValueType="System.String" IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Dyeing">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox runat="server" ID="txtDye" DataSourceID="Dye" Width="170px"
                                                                    TextField="Description" ValueField="DyeingCode" ValueType="System.String" IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Weave Type" Name="WeaveType">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox runat="server" ID="txtWeave" DataSourceID="Weave" Width="170px"
                                                                    TextField="Description" ValueField="Code" ValueType="System.String" IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Finishing">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox runat="server" ID="txtFinishing" DataSourceID="Finishing" Width="170px"
                                                                    TextField="Description" ValueField="FinishingCode" ValueType="System.String" IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView Caption="COMPOSITION" ID="gvFab" runat="server" AutoGenerateColumns="False" Width="295px" KeyFieldName="FabricCode;Type"
                                                                    OnCommandButtonInitialize="gvitem_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gvFabric"
                                                                    OnBatchUpdate="gv1_BatchUpdate">
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <SettingsBehavior AllowSort="false" />
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="30px">
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="Percentage" VisibleIndex="1" Width="80px" UnboundType="Decimal" PropertiesSpinEdit-AllowMouseWheel="false">
                                                                            <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                MinValue="0">
                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" Caption="Type" VisibleIndex="2" Width="170px" Name="Description" ReadOnly="true">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup runat="server" DataSourceID="CompType" TextFormatString="{0}" AutoPostBack="false" AutoGenerateColumns="true"
                                                                                    ClientInstanceName="fabtype" KeyFieldName="Description">
                                                                                    <ClientSideEvents DropDown="lookup" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                                        ValueChanged="function(){gvFabric.batchEditApi.EndEdit();}" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Visible" VerticalScrollableHeight="100" />
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                                    <SettingsEditing Mode="Batch" />
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Paddings-Padding="0px" ShowCaption="False" Height="110px" GroupBoxStyle-Border-BorderStyle="None">
                                                <Paddings Padding="0px"></Paddings>

                                                <GroupBoxStyle>
                                                    <border borderstyle="None"></border>
                                                </GroupBoxStyle>
                                                <Items>
                                                    <dx:LayoutItem Paddings-Padding="0px" ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td></td>
                                                                        <td style="padding-left: 8px">
                                                                            <dx:ASPxLabel runat="server" Text="Cuttable">
                                                                            </dx:ASPxLabel>
                                                                        </td>
                                                                        <td></td>
                                                                        <td style="padding-left: 15px">
                                                                            <dx:ASPxLabel runat="server" Text="Gross">
                                                                            </dx:ASPxLabel>
                                                                        </td>
                                                                        <td></td>
                                                                        <td>
                                                                            <dx:ASPxLabel runat="server" Text="(For Knits Only)">
                                                                            </dx:ASPxLabel>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 77px">
                                                                            <dx:ASPxLabel runat="server" Text="Width: "></dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox runat="server" ID="txtCuttableWidth" Width="60px"></dx:ASPxTextBox>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxLabel runat="server" Font-Size="Smaller" Text="inches"></dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtGrossWidth" runat="server" Width="60px"></dx:ASPxTextBox>
                                                                        </td>
                                                                        <td style="width: 30px">
                                                                            <dx:ASPxLabel runat="server" Font-Size="Smaller" Text="inches"></dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxComboBox runat="server" ID="cbforknits" Width="80px">
                                                                                <Items>
                                                                                    <dx:ListEditItem Text="OPEN" Value="OPEN" />
                                                                                    <dx:ListEditItem Text="TUBE" Value="TUBE" />
                                                                                </Items>
                                                                            </dx:ASPxComboBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 5px"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 77px">
                                                                            <dx:ASPxLabel runat="server" Text="Weight BW: "></dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtCuttableWeightBW" runat="server" Width="60px"></dx:ASPxTextBox>
                                                                        </td>
                                                                        <td></td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtGrossWeightBW" runat="server" Width="60px"></dx:ASPxTextBox>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxLabel runat="server" Text="Yield: "></dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtYield" runat="server" Width="45px"></dx:ASPxTextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 5px"></td>
                                                                    </tr>
                                                                </table>
                                                                <table>
                                                                    <tr>
                                                                        <td style="width: 77px">
                                                                            <dx:ASPxLabel runat="server" Text="Fabric Stretch: "></dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtFabricStretch" runat="server" Width="60px"></dx:ASPxTextBox>
                                                                        </td>
                                                                        <td style="width: 27.83px; padding-left: 2px">
                                                                            <dx:ASPxLabel runat="server" Text="%"></dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxLabel runat="server" Text="Use Pull-test w/ Rinse Wash"></dx:ASPxLabel>
                                                                        </td>
                                                                        <td></td>
                                                                    </tr>
                                                                </table>
                                                                &nbsp;
                                                                &nbsp;
                                                                &nbsp;
                                                                &nbsp;
                                                        <table>
                                                            <tr>
                                                                <td></td>
                                                                <td style="text-align: center">
                                                                    <dx:ASPxLabel runat="server" Text="Warp">
                                                                    </dx:ASPxLabel>
                                                                </td>
                                                                <td></td>
                                                                <td style="text-align: center">
                                                                    <dx:ASPxLabel runat="server" Text="Weft">
                                                                    </dx:ASPxLabel>
                                                                </td>
                                                                <td></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 77px">
                                                                    <dx:ASPxLabel runat="server" Text="Construction: "></dx:ASPxLabel>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtWarpConstruction" runat="server" Width="100px"></dx:ASPxTextBox>
                                                                </td>
                                                                <td style="width: 40px; text-align: center">
                                                                    <dx:ASPxLabel runat="server" Text="x"></dx:ASPxLabel>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtWeftConstruction" runat="server" Width="100px"></dx:ASPxTextBox>
                                                                </td>
                                                                <td></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="height: 5px"></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 77px">
                                                                    <dx:ASPxLabel runat="server" Text="Density: "></dx:ASPxLabel>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtWarpDensity" runat="server" Width="100px"></dx:ASPxTextBox>
                                                                </td>
                                                                <td style="width: 40px; text-align: center">
                                                                    <dx:ASPxLabel runat="server" Text="x"></dx:ASPxLabel>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtWeftDensity" runat="server" Width="100px"></dx:ASPxTextBox>
                                                                </td>
                                                                <td></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 77px">
                                                                    <dx:ASPxLabel runat="server" Text="Shrinkage (Rinse Watch): "></dx:ASPxLabel>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtWarpShrinkage" runat="server" Width="100px"></dx:ASPxTextBox>
                                                                </td>
                                                                <td style="width: 40px; text-align: left; padding-left: 2px">
                                                                    <dx:ASPxLabel runat="server" Text="%&nbsp;&nbsp;x"></dx:ASPxLabel>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtWeftShrinkage" runat="server" Width="100px"></dx:ASPxTextBox>
                                                                </td>
                                                                <td></td>
                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td colspan="3">
                                                                    <dx:ASPxLabel runat="server" Text="Use 24&quot; x 24&quot; Method, 50 cm X 50 cm Marking"></dx:ASPxLabel>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>

                                                        <Paddings Padding="0px"></Paddings>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>

                                        </Items>
                                    </dx:LayoutGroup>
                                    <%-- 
                                    <dx:LayoutGroup Caption="Stock Master Info Tab" Name="WMSInfo" ClientVisible="false">
                                        <Items>
                                            <dx:TabbedLayoutGroup>
                                                <SettingsTabPages EnableClientSideAPI="True">
                                                </SettingsTabPages>
                                                <Items>
                                                    <dx:LayoutGroup Caption="Stock Info" ColCount="2">
                                                        <Items>
                                                            <dx:LayoutItem Caption="Brand">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E1" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Product Group">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E2" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Delivery Date">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Collection Abbreviation">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E3" runat="server" Width="170px">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="PIS Number">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E12" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Fit Code">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E13" runat="server" Width="170px">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Color">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E7" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Product Design Category">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E14" runat="server" Width="170px">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Color Name">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E9" runat="server" Width="170px">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Retail Fabric Code">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E4" runat="server" Width="170px">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Wash Code">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E15" runat="server" Width="170px">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Tint Code">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E16" runat="server" Width="170px">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Product Class">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E19" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Imported Item">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E17" runat="server" Width="170px">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Product Sub-Class">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E20" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Product Alignment">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E21" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Season">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E22" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Reco Allocation">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E23" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="SRP" ColSpan="2">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxSpinEdit ID="frmlayout1_E24" runat="server" Number="0">
                                                                        </dx:ASPxSpinEdit>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem ColSpan="2" ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridView ID="ASPxGridView1" runat="server" AutoGenerateColumns="False" Caption="Price History" ClientInstanceName="gvPriceHistory" KeyFieldName="FabricCode;Type" OnBatchUpdate="gv1_BatchUpdate" OnCellEditorInitialize="gv1_CellEditorInitialize" OnCommandButtonInitialize="gvitem_CommandButtonInitialize" Width="295px">
                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating" BatchEditStartEditing="OnStartEditing" />
                                                                            <SettingsPager Mode="ShowAllRecords">
                                                                            </SettingsPager>
                                                                            <SettingsEditing Mode="Batch">
                                                                            </SettingsEditing>
                                                                            <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="100" VerticalScrollBarMode="Visible" />
                                                                            <SettingsBehavior AllowSort="False" />
                                                                            <Columns>
                                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="30px">
                                                                                </dx:GridViewCommandColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Status" FieldName="Status" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="170px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Price" FieldName="Price" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="170px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataDateColumn FieldName="EffectivityDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                                </dx:GridViewDataDateColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridView>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                    <dx:LayoutGroup>
                                                    </dx:LayoutGroup>
                                                    <dx:LayoutGroup>
                                                    </dx:LayoutGroup>
                                                </Items>
                                            </dx:TabbedLayoutGroup>

                                        </Items>
                                    </dx:LayoutGroup>--%>
                                    <dx:LayoutGroup Caption="WMS Tab" ColCount="2" Name="WMSInfo" ClientVisible="false">
                                        <Items>
                                            <dx:LayoutItem Caption="Storage Type:" Name="txtstoragetype">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <%--<dx:ASPxTextBox ID="txtstoragetype" runat="server" Width="170px" ColCount="1" OnLoad="TextboxLoad">
                                                        
                                                        </dx:ASPxTextBox>--%>
                                                        <dx:ASPxGridLookup Width="170px" ID="txtstoragetype" runat="server" AutoGenerateColumns="False" DataSourceID="StorageType" KeyFieldName="StorageType" OnLoad="LookupLoad" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="StorageType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="StorageDescription" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="function(){isValid=true;}" />
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Picking Strategy:" Name="txtpickingStrategy">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="txtstrategy" runat="server" ValueType="System.String" Width="170px" OnLoad="Comboboxload">
                                                            <Items>
                                                                <dx:ListEditItem Text="FIFO" Value="FIFO" />
                                                                <dx:ListEditItem Text="FEFO" Value="FEFO" />
                                                                <dx:ListEditItem Text="LIFO" Value="LIFO" />
                                                                <dx:ListEditItem Text="LLFO" Value="LLFO" />
                                                            </Items>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Max Level" Name="txtmaxlevel">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtmaxlevel" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Min Order Qty:" Name="txtminorderqty">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtminorder" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Standard Qty:" Name="txtstandardqty">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtstandardqty" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Use Count Sheet" Name="chkUseCountSheet" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkcountsheet" runat="server" CheckState="Unchecked" OnLoad="Check_Load" ClientVisible="false">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                        </Items>
                                    </dx:LayoutGroup>

                                    <%-- --%>
                                    <dx:LayoutGroup Caption="Running Inventory Information" ClientVisible="false">
                                        <Items>
                                            <dx:LayoutGroup Caption="Lines">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="agvRunningInv" runat="server" AutoGenerateColumns="False" ClientInstanceName="gv4" OnCellEditorInitialize="gv1_CellEditorInitialize" OnCommandButtonInitialize="gv_CommandButtonInitialize" Width="747px">
                                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <SettingsBehavior AllowSort="false" />
                                                                    <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="130" VerticalScrollBarMode="Auto" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="60px" ShowDeleteButton="false">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="RunningINVInfo">
                                                                                    <Image IconID="support_info_16x16">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LineNumber" FieldName="LineNumber" Name="LineNumber" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="2" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ItemCode" FieldName="ItemCode" Name="ItemCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="3" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>

                                                                        <dx:GridViewDataTextColumn Caption="ColorCode" FieldName="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="4" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="SizeCode" FieldName="SizeCode" Name="SizeCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="5" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ClassCode" FieldName="ClassCode" Name="ClassCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="6" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>

                                                                        <dx:GridViewDataTextColumn Caption="Qty" FieldName="Qty" Name="Qty" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="BulkQty" FieldName="BulkQty" Name="BulkQty" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="8" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="BaseUnit" FieldName="BaseUnit" Name="BaseUnit" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="9" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="WarehouseCode" FieldName="WarehouseCode" Name="WarehouseCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="10" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="StatusCode" FieldName="StatusCode" Name="StatusCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="11" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LastMovementDate" FieldName="LastMovementDate" Name="LastMovementDate" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="12" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="FirstIn" FieldName="FirstIn" Name="FirstIn" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LastIn" FieldName="LastIn" Name="LastIn" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="13" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="FirstOut" FieldName="FirstOut" Name="FirstOut" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="14" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LastOut" FieldName="LastOut" Name="LastOut" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="15" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>

                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Item Price History" ClientVisible="false">
                                        <Items>
                                            <dx:LayoutGroup Caption="Lines" Width="650px">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="agvItemCustomer" runat="server" AutoGenerateColumns="False" ClientInstanceName="gv2" OnBatchUpdate="gv1_BatchUpdate" OnCellEditorInitialize="gv1_CellEditorInitialize" OnCommandButtonInitialize="gvitem_CommandButtonInitialize" Width="650px"
                                                                    KeyFieldName="ItemCode;ColorCode;ClassCode;SizeCode;Customer" OnInitNewRow="gv1_InitNewRow">
                                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating" CustomButtonClick="OnCustomClick"
                                                                        BatchEditStartEditing="OnStartEditing2" BatchEditEndEditing="OnEndEditing2" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <SettingsBehavior AllowSort="false" />
                                                                    <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="300" VerticalScrollBarMode="Auto" />
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="60px" ShowDeleteButton="true">
                                                                            <%--<CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Itempricehisto">
                                                                                    <Image IconID="support_info_16x16">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>--%>
                                                                        </dx:GridViewCommandColumn>

                                                                        <dx:GridViewDataTextColumn Caption="ItemCode" FieldName="ItemCode" Name="ItemCode" ShowInCustomizationForm="True" Width="0px" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="2" Width="150px" Name="ColorCode">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="ColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                    DataSourceID="Color" KeyFieldName="ColorCode" ClientInstanceName="glColor" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" />
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="gridLookup_CloseUp" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" VisibleIndex="3" Width="150px" Name="SizeCode">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="SizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                    DataSourceID="size" KeyFieldName="SizeCode" ClientInstanceName="glSize" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" />
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="gridLookup_CloseUp" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" VisibleIndex="4" Width="150px" Name="ClassCode">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="ClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                    DataSourceID="class" KeyFieldName="ClassCode" ClientInstanceName="glClass" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" />
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="gridLookup_CloseUp" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Customer" FieldName="Customer" Width="150px" Name="Customer" ShowInCustomizationForm="True" VisibleIndex="9">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="gvCustomer" runat="server" Width="150px" AutoGenerateColumns="False" DataSourceID="sdsBizPartner" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}"
                                                                                    ClientInstanceName="gvCustomer">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                        <Settings ShowFilterRow="True"></Settings>
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="gridLookup_CloseUp" />
                                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                        <RequiredField IsRequired="True" />
                                                                                    </ValidationSettings>
                                                                                    <InvalidStyle BackColor="Pink">
                                                                                    </InvalidStyle>
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="Price" ShowInCustomizationForm="True" VisibleIndex="10">
                                                                            <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N}">
                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SubstitutedItem" VisibleIndex="5" Width="150px" Name="glItemCode">
                                                                            <%-- <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                        DataSourceID="Masterfileitem" KeyFieldName="ItemCode" ClientInstanceName="glItem" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad">
                                                                        <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" Settings-VerticalScrollBarMode="Visible"> 
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" AllowDragDrop="False"/>
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                        <ClientSideEvents DropDown="lookup" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                        ValueChanged="gridLookup_CloseUp" />
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>--%>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SubstitutedColor" VisibleIndex="6" Width="150px" Name="ColorCode">
                                                                            <%--<EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="ColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                    DataSourceID="color" KeyFieldName="ColorCode" ClientInstanceName="glColor2" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad" >
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" />
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="gridLookup_CloseUp" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>--%>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SubstitutedSize" VisibleIndex="7" Width="150px" Name="SizeCode">
                                                                            <%--<EditItemTemplate>
                                                                            <dx:ASPxGridLookup ID="SizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                DataSourceID="size" KeyFieldName="SizeCode" ClientInstanceName="glSize2" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad" >
                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                        AllowSelectSingleRowOnly="True" />
                                                                                </GridViewProperties>
                                                                                <Columns>
                                                                                    <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" />
                                                                                    <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                                </Columns>
                                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="gridLookup_CloseUp" />
                                                                            </dx:ASPxGridLookup>
                                                                        </EditItemTemplate>--%>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SubstitutedClass" VisibleIndex="8" Width="150px" Name="ClassCode">
                                                                            <%--<EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="ClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                    DataSourceID="class" KeyFieldName="ClassCode" ClientInstanceName="glClass2" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad" >
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" />
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="gridLookup_CloseUp" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>--%>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="11" Width="0px" FieldName="PrevColorCode" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="SizeCode" Name="SizeCode" ShowInCustomizationForm="True" VisibleIndex="12" Width="0px" FieldName="PrevSizeCode" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ClassCode" Name="ClassCode" ShowInCustomizationForm="True" VisibleIndex="13" Width="0px" FieldName="PrevClassCode" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <SettingsEditing Mode="Batch" />
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>

                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Item Cost History" ClientVisible="false">
                                        <Items>
                                            <dx:LayoutGroup Caption="Lines">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="agvItemSupplier" runat="server" AutoGenerateColumns="False" Width="747px"
                                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv3">
                                                                    <ClientSideEvents Init="OnInitTrans" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <SettingsBehavior AllowSort="false" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" Visible="False"
                                                                            VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="60px">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Itemcosthisto">
                                                                                    <Image IconID="support_info_16x16"></Image>
                                                                                </dx:GridViewCommandColumnCustomButton>

                                                                            </CustomButtons>

                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LineNumber" Name="LineNumber" ShowInCustomizationForm="True" VisibleIndex="2" FieldName="LineNumber" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ItemCode" Name="ItemCode" ShowInCustomizationForm="True" VisibleIndex="3" FieldName="ItemCode" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="4" FieldName="ColorCode" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="SizeCode" Name="SizeCode" ShowInCustomizationForm="True" VisibleIndex="5" FieldName="SizeCode" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ClassCode" Name="ClassCode" ShowInCustomizationForm="True" VisibleIndex="6" FieldName="ClassCode" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Supplier" Name="Supplier" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="Supplier" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Unit" Name="Unit" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="Unit" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Price" Name="Price" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="Price" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="PriceCurrency" Name="PriceCurrency" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="PriceCurrency" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="SupplierItemCode" Name="SupplierItemCode" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="SupplierItemCode" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LastPrice" Name="LastPrice" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="LastPrice" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LastUnit" Name="LastUnit" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="LastUnit" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LastUpdate" Name="LastUpdate" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="LastUpdate" UnboundType="String" ReadOnly="true"
                                                                            PropertiesTextEdit-DisplayFormatString="{0:M/d/yyyy}">
                                                                            <PropertiesTextEdit DisplayFormatString="{0:M/d/yyyy}"></PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="QuotePrice" Name="QuotePrice" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="QuotePrice" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130" />
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    

                                    <dx:LayoutGroup Caption="User Defined Tab" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field 1:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                            <ClientSideEvents Validation="function(){isValid=true;}" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 2:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 3:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 4:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 5:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 6:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 7:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 8:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 9:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field10" Name="txth10">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txth10" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Audit Trail Tab" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Added By:" Name="txtAddedBy">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAddedBy" runat="server" ColCount="1" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Added Date:" Name="txtAddedDate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAddedDate" runat="server" ColCount="1" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited By" Name="txtLastEditedBy">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLastEditedBy" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited Date" Name="txtLastEditedDate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLastEditedDate" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Activated By:" Name="txtActivatedBy">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActivatedBy" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Activated Date:" Name="txtActivatedDate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActivatedDate" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Deactivated By:" Name="txtDeactivatedBy">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDeactivatedBy" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Deactivated Date:" Name="txtDeactivatedDate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDeactivatedDate" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                </Items>
                            </dx:TabbedLayoutGroup>

                        </Items>
                    </dx:ASPxFormLayout>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel2" runat="server" Text="Cloning..." ClientInstanceName="cloneloading" ContainerElementID="gv1" Modal="true" ImagePosition="Left">
            <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
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
                                <td>
                                    <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false">
                                        <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                    </dx:ASPxButton>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <%--<SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />--%>
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

        <!--#region Region Datasource-->

        <%--<!--#region Region Header --> --%>
        <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.ItemMasterfile" DataObjectTypeName="Entity.ItemMasterfile" DeleteMethod="DeleteData" InsertMethod="InsertData" UpdateMethod="UpdateData">
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="" Name="ItemCode" QueryStringField="docnumber" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>

        <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ItemMasterfile+ItemMasterDetail" DataObjectTypeName="Entity.ItemMasterfile+ItemMasterDetail" DeleteMethod="DeleteItemDetail" InsertMethod="AddItemDetail" UpdateMethod="UpdateItemDetail">
            <SelectParameters>
                <asp:QueryStringParameter Name="ItemCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>

        <asp:ObjectDataSource ID="odsDetail3" runat="server" SelectMethod="getdetail" TypeName="Entity.ItemMasterfile+ItemMasterUnit" DataObjectTypeName="Entity.ItemMasterfile+ItemMasterUnit" DeleteMethod="DeleteItemDetail" InsertMethod="AddItemDetail" UpdateMethod="UpdateItemDetail">
            <SelectParameters>
                <asp:QueryStringParameter Name="ItemCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>


        <asp:ObjectDataSource ID="odsFab" runat="server" SelectMethod="getfabric" TypeName="Entity.ItemMasterfile+ItemMasterDetail" DataObjectTypeName="Entity.ItemMasterfile+ItemMasterDetail" DeleteMethod="DeleteFabricComp" InsertMethod="AddFabricComp" UpdateMethod="UpdateFabricComp">
            <SelectParameters>
                <asp:QueryStringParameter Name="ItemCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>

        <asp:ObjectDataSource ID="odsWHDetail" runat="server" SelectMethod="getItemWHDetail" TypeName="Entity.ItemMasterfile+ItemMasterDetail" DataObjectTypeName="Entity.ItemMasterfile+ItemMasterDetail">
            <SelectParameters>
                <asp:QueryStringParameter Name="ItemCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>

        <asp:ObjectDataSource ID="odsSuppDetail" runat="server" SelectMethod="getItemSupplierDetail" TypeName="Entity.ItemMasterfile+ItemMasterDetail" DataObjectTypeName="Entity.ItemMasterfile+ItemMasterDetail">
            <SelectParameters>
                <asp:QueryStringParameter Name="ItemCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>

        <asp:SqlDataSource ID="sdsItemSupp" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM MasterFile.ItemCustomerPrice where ItemCode  is null " OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  masterfile.itemdetail where ItemCode  is null "
            OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="sdsDetail3" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  masterfile.ItemUnit where ItemCode  is null "
            OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="sdsFabricComp" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  masterfile.FabricCompositionDetail where FabricCode  is null "
            OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="ProdCat" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" "
            OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="ProdSubCat" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" "
            OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:ObjectDataSource ID="odsCusDetail" runat="server" DataObjectTypeName="Entity.ItemMasterfile+ItemCustomerPriceDetail" DeleteMethod="DeleteItemPriceDetail" InsertMethod="AddItemPriceDetail" SelectMethod="getdetail" TypeName="Entity.ItemMasterfile+ItemCustomerPriceDetail" UpdateMethod="UpdateItemPriceDetail">
            <SelectParameters>
                <asp:QueryStringParameter Name="ItemCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </form>

    <asp:SqlDataSource ID="supplier" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="customer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Unit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select UnitCode,Description from Masterfile.Unit WHERE ISNULL(IsInactive,0) =0"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Color" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Class" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Size" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="ItemCategory" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" "
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Statussql" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="StorageType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" "
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="FabricGroup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="FabDesign" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Dye" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Weave" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Finishing" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" "
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="ItemType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select RawMaterialTypeCode as  Code,Description from Masterfile.RawMaterialsType where ISNULL(IsInactive,0) = 0 "
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="ItemCat" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select ItemCategoryCode as  Code,Description from Masterfile.ItemCategory where ISNULL(IsInactive,0) = 0 "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="CompType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBizPartner" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsVAT" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsTaxCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" " OnInit="Connection_Init"></asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


