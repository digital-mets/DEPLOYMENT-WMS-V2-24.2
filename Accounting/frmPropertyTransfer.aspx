<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmPropertyTransfer.aspx.cs" Inherits="GWL.frmPropertyTransfer" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
<script src="../js/PerfSender.js" type="text/javascript"></script>
<title>Property Transfer</title>
<link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
<script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script><%--NEWADD--%>
<script src="../js/jquery-ui.min.js" type="text/javascript"></script><%--NEWADD--%>

     <!--#region Region Javascript-->
<style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
    #form1 {
        height: 400px; /*Change this whenever needed*/
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

            console.log(e.requestTriggerID + ' e.requestTriggerID')
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

            if (s.cp_forceclose) {//NEWADD
                delete (s.cp_forceclose);
                window.close();
            }
        }

        var index;
        var closing;
        var valchange;
        var itemc; //variable required for lookup
        var propertynumber;
        var currentColumn = null;
        var isSetTextRequired = false;
        var valchange_ALL = false;
        var linecount = 1;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
            //if (e.visibleIndex < 0) {//new row
            //    var linenumber = s.GetColumnByField("LineNumber");
            //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
            //}

            index = e.visibleIndex;
            propertynumber = s.batchEditApi.GetCellValue(e.visibleIndex, "PropertyNumber");
            if (e.focusedColumn.fieldName === "PropertyNumber") { //Check the column name
                CINPropertyNumber.GetInputElement().value = cellInfo.value; //Gets the column value
                isSetTextRequired = true;
                index = e.visibleIndex;
                closing = true;
            }
            if (e.focusedColumn.fieldName === "NewLocation") {
                CINNewLocation.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "NewDepartment") {
                CINNewDepartment.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "NewAccountablePerson") {
                CINNewAccountablePerson.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "NewWarehouseCode") {
                CINNewWarehouseCode.GetInputElement().value = cellInfo.value;
            }

        }


        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            if (currentColumn.fieldName === "PropertyNumber") {
                cellInfo.value = CINPropertyNumber.GetValue();
                cellInfo.text = CINPropertyNumber.GetText();
            }
            if (currentColumn.fieldName === "NewLocation") {
                cellInfo.value = CINNewLocation.GetValue();
                cellInfo.text = CINNewLocation.GetText();
            }
            if (currentColumn.fieldName === "NewDepartment") {
                cellInfo.value = CINNewDepartment.GetValue();
                cellInfo.text = CINNewDepartment.GetText();
            }
            if (currentColumn.fieldName === "NewAccountablePerson") {
                cellInfo.value = CINNewAccountablePerson.GetValue();
                cellInfo.text = CINNewAccountablePerson.GetText();
            }
            if (currentColumn.fieldName === "NewWarehouseCode") {
                cellInfo.value = CINNewWarehouseCode.GetValue();
                cellInfo.text = CINNewWarehouseCode.GetText();
            }


        }


        function autodepreciate(s, e) {


            var totalaquisitioncost = 0.00;
            var salvagevalue = 0.00;
            var lifeasset = 0.00;
            var depreciationmethod;
            var monthdepreciation = 0.00;
            var bookvalue = 0.00;

            setTimeout(function () { //New Rows

                totalaquisitioncost = CINTotalAcquisitionCost.GetText();
                salvagevalue = CINSalvageValue.GetText();
                lifeasset = CINNewRemainingLifeAsset.GetText();
                depreciationmethod = CINNewDepreciationMethod.GetText();
                bookvalue = CINNewBookValue.GetText();

                console.log(depreciationmethod);


                if (depreciationmethod == "Straight Line Method") {
                    if (lifeasset > 0)
                        monthdepreciation = (totalaquisitioncost - salvagevalue) / lifeasset;
                    else
                        console.log("no computation")
                }


                if (depreciationmethod == "Double Declining Balance Method") {
                    monthdepreciation = (bookvalue / lifeasset) * 2;
                }


                if (depreciationmethod == "Sum of Years Digit Method") {
                    monthdepreciation = (bookvalue / lifeasset) * 2;
                }

                CINNewMonthlyDepreciationAmount.SetText(monthdepreciation.toFixed(2));

            }, 500);
        }

        function GridEnd(s, e) {
            val = s.GetGridView().cp_codes;
            temp = val.split(';');
            if (closing == true) {
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
       //function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
       //    for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
       //        var column = s.GetColumn(i);
       //        if (column != s.GetColumn(6) && column != s.GetColumn(1) && column != s.GetColumn(7) && column != s.GetColumn(5) && column != s.GetColumn(8) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23) && column != s.GetColumn(24) && column != s.GetColumn(13)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
       //            var cellValidationInfo = e.validationInfo[column.index];
       //            if (!cellValidationInfo) continue;
       //            var value = cellValidationInfo.value;
       //            if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
       //                cellValidationInfo.isValid = false;
       //                cellValidationInfo.errorText = column.fieldName + " is required";
       //                isValid = false;
       //            }
       //            else {
       //                isValid = true;
       //            }
       //        }
       //    }
       //}

        function OnCustomClick(s, e) {


            if (e.buttonID == "Details") {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
                var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
                var Warehouse = "";

                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&unit=' + unitbase + '&Warehouse=' + Warehouse);




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

            if (e.buttonID == "Delete") {
                gv1.DeleteRow(e.visibleIndex);
                //autocalculate(s, e);
            }
        }



        function indexchanged(s, e) {
            if (CINTransferType.GetValue() == "Transfer") {
                cp.PerformCallback('Transfer');
                e.processOnServer = false;
            }
            else {
                cp.PerformCallback('Return To Warehouse');
                e.processOnServer = false;
            }
        }


        var identifier;
        var val_ALL;
        function GridEndChoice(s, e) {
            identifier = s.GetGridView().cp_identifier;
            val_ALL = s.GetGridView().cp_codes;

            if (identifier == "PropertyNumber") {
                delete (s.GetGridView().cp_identifier);
                if (valchange_ALL) {
                    valchange_ALL = false;
                    for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                        //console.log('anoto')
                        var column = gv1.GetColumn(i);
                        if (column.visible == false || column.fieldName == undefined)
                            continue;
                        ProcessCells_PropertyNumber(0, e.visibleIndex, column, gv1);
                    }
                }
                gv1.batchEditApi.EndEdit();
            }
        }


        function ProcessCells_PropertyNumber(selectedIndex, focused, column, s) {//Auto calculate qty function :D
            //console.log("ProcessCells_VAT")
            var temp_PropertyNumber;
            if (val_ALL == null) {
                val_ALL = ";;;;;;;;;;;;";
            }
            temp_PropertyNumber = val_ALL.split(';');
            if (temp_PropertyNumber[0] == null) {
                temp_PropertyNumber[0] = "";
            }
            if (temp_PropertyNumber[1] == null) {
                temp_PropertyNumber[1] = "";
            }
            if (temp_PropertyNumber[2] == null) {
                temp_PropertyNumber[2] = "";
            }
            if (temp_PropertyNumber[3] == null) {
                temp_PropertyNumber[3] = "";
            }
            if (temp_PropertyNumber[4] == null) {
                temp_PropertyNumber[4] = "";
            }
            if (temp_PropertyNumber[5] == null) {
                temp_PropertyNumber[5] = "";
            }
            if (temp_PropertyNumber[6] == null) {
                temp_PropertyNumber[6] = "";
            }
            if (temp_PropertyNumber[7] == null) {
                temp_PropertyNumber[7] = "";
            }
            if (temp_PropertyNumber[8] == null) {
                temp_PropertyNumber[8] = "";
            }
            if (temp_PropertyNumber[9] == null) {
                temp_PropertyNumber[9] = "";
            }
            if (temp_PropertyNumber[10] == null) {
                temp_PropertyNumber[10] = "";
            }
            if (temp_PropertyNumber[11] == null) {
                temp_PropertyNumber[11] = "";
            }

            if (selectedIndex == 0) {
                if (column.fieldName == "ItemCode") {

                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_PropertyNumber[0]);
                }
                if (column.fieldName == "ItemDescription") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_PropertyNumber[1]);
                }
                if (column.fieldName == "ColorCode") {

                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_PropertyNumber[2]);
                }
                if (column.fieldName == "ClassCode") {

                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_PropertyNumber[3]);
                }
                if (column.fieldName == "SizeCode") {

                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_PropertyNumber[4]);
                }
                if (column.fieldName == "AccumulatedCostCenter") {

                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_PropertyNumber[5]);
                }
                if (column.fieldName == "DepreciationCostCenter") {

                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_PropertyNumber[6]);
                }
                if (column.fieldName == "Qty") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_PropertyNumber[7]);
                }
                if (column.fieldName == "Location") {

                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_PropertyNumber[8]);
                }
                if (column.fieldName == "Department") {

                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_PropertyNumber[9]);
                }
                if (column.fieldName == "AccountablePerson") {

                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_PropertyNumber[10]);
                }
                if (column.fieldName == "WarehouseCode") {

                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_PropertyNumber[11]);
                }
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
            gvRef.SetWidth(width - 120);
        }


        function negativecheck(s, e) {
            var quantity = CINQuantity.GetValue();

            quantity = quantity < 0 ? 0 : quantity;

            CINQuantity.SetText(quantity);
        }
       //#region For future reference JS 

       //Debugging purposes
       //function start(s, e) {
       //    pass = fieldValue;
       //    console.log("start callback " + pass);
       //}

       //function end(s, e) {
       //    console.log("end callback");
       //}
       //function rowclick(s, e) {
       //    s.GetRowValues(e.visibleIndex, 'ItemCode;ColorCode;ClassCode;SizeCode', function (data) {
       //        console.log(data[0], data[1], data[2], data[3]);
       //        //splitter.GetPaneByName("Factbox").SetContentUrl('../FactBox/fbBizPartner.aspx?itemcode=' + data[0]
       //        //+ '&colorcode='+data[1]+'&classcode='+data[2]+'&sizecode='+data[3]);
       //        factbox.SetContentUrl('../FactBox/fbBizPartner.aspx?itemcode=' + data[0]
       //        + '&colorcode=' + data[1] + '&classcode=' + data[2] + '&sizecode=' + data[3]);
       //    });
       //}

       //function getParameterByName(name) {
       //    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
       //    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
       //        results = regex.exec(location.search);
       //    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
       //}

       //function OnControlInitialized(event) {
       //    var entry = getParameterByName('entry');
       //    if (entry == "N") {
       //        splitter.GetPaneByName("Factbox").SetContentUrl('../FactBox/fbBizPartner.aspx');
       //        //splitter.GetPaneByName("Factbox2").SetContentUrl('../FactBox/fbBizPartner.aspx');
       //        //splitter.GetPaneByName("Factbox3").SetContentUrl('../FactBox/fbBizPartner.aspx');
       //        //splitter.GetPaneByName("Factbox4").SetContentUrl('../FactBox/fbBizPartner.aspx');
       //    }
       //}
       //#endregion

    </script>
    <!--#endregion-->
</head>
<body style="height: 910px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Property Transfer" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
             <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="50"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>

        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="910px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" style="margin-left: -3px">
                       <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="1">
                                        <Items>
                                            <dx:LayoutGroup Caption="Property Transfer Information" ColCount="1">
                                                <Items>
                                                    <dx:LayoutItem Caption="Document Number" Name="DocNumber">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px" OnLoad="TextboxLoad" Enabled="false">
                                                                <ClientSideEvents Validation="OnValidation"/>
                                                                    <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True"/>
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                    <dx:LayoutItem Caption="Document Date" Name="DocDate" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtDocDate" runat="server" Width="170px" OnLoad="Date_Load" OnInit ="dtpDocDate_Init">
                                                                <ClientSideEvents Validation="OnValidation"/>
                                                                    <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True"/>
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                    <%--<dx:LayoutItem  Caption="Property Number" Name="PropertyNumber">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glPropertyNumber" DataSourceID="PropertyNumberLookup" KeyFieldName="PropertyNumber" runat="server" Width="170px" TextFormatString="{0}" OnLoad="LookupLoad">
                                                                    <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('PropertyNumberCase');  e.processOnServer = false;}"/>
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                            <dx:GridViewCommandColumn Caption=" " ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="10px">
                                                                            </dx:GridViewCommandColumn>
                                                                            <dx:GridViewDataTextColumn Caption="PropertyNumber" FieldName="PropertyNumber" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                            </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>


                                                    <dx:LayoutItem Caption="Transfer Type" Name="TransferType">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox ID="cbTransferType" ClientInstanceName="CINTransferType" runat="server" Width="170px" OnLoad="ComboBoxLoad">
                                                                    <ClientSideEvents SelectedIndexChanged ="indexchanged"/>                                                         
                                                                    <Items>
                                                                        <dx:ListEditItem Text="Return To Warehouse" Value="Return To Warehouse" Selected="True" />
                                                                        <dx:ListEditItem Text="Transfer" Value="Transfer"  />
                                                                    </Items>
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>

                                            <dx:LayoutGroup Caption="Property Number Details" ColCount="1">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" ClientInstanceName="gv1" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize" Width="100%" SettingsBehavior-AllowSort="False"
                                                                        KeyFieldName="LineNumber" >
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" BatchEditEndEditing="OnEndEditing"  BatchEditStartEditing="OnStartEditing" Init="OnInitTrans"/>
                                                                        <SettingsPager Mode="ShowAllRecords">
                                                                        </SettingsPager>
                                                                        <SettingsEditing Mode="Batch">
                                                                        </SettingsEditing>
                                                                        <Settings  VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual"  VerticalScrollableHeight="300" HorizontalScrollBarMode="Visible" ShowStatusBar="Hidden"/>
                                                                        <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="60px">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Details" >
                                                                                    <Image IconID="support_info_16x16" ToolTip="Details"></Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                                    <Image IconID="actions_cancel_16x16">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>                                                                         
                                                                        <dx:GridViewDataTextColumn Caption="LineNumber" FieldName="LineNumber" Name="LineNumber" ShowInCustomizationForm="True" VisibleIndex="2" Width="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="PropertyNumber" FieldName="PropertyNumber" VisibleIndex="3" Width="150px" Name="PropertyNumber">
                                                                             <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glPropertyNumber" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="glPropertyNumber_Init"
                                                                                    DataSourceID="PropertyNumberLookup" KeyFieldName="PropertyNumber" ClientInstanceName="CINPropertyNumber" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad" >
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="PropertyNumber" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" /></dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" /></dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents  KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" EndCallback="GridEndChoice"
                                                                                    ValueChanged="function(s,e){
                                                                                        if(propertynumber != CINPropertyNumber.GetValue()){
                                                                                        closing = true;
                                                                                        CINPropertyNumber.GetGridView().PerformCallback('PropertyNumber' + '|' + CINPropertyNumber.GetValue() + '|' + 's.GetInputElement().value');
                                                                                        e.processOnServer = false;
                                                                                        valchange_ALL = true
                                                                                        }
                                                                                  }" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ItemCode" FieldName="ItemCode" Name="ItemCode" ShowInCustomizationForm="True" VisibleIndex="4" Width="150px" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ItemDescription" FieldName="ItemDescription" Name="ItemDescription" ShowInCustomizationForm="True" VisibleIndex="5" Width="300" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ItemColor" FieldName="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="6" Width="150px" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ItemClass" FieldName="ClassCode" Name="ClassCode" ShowInCustomizationForm="True" VisibleIndex="7" Width="150px" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ItemSize" FieldName="SizeCode" Name="SizeCode" ShowInCustomizationForm="True" VisibleIndex="8" Width="150px" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="AccumulatedCostCenter" FieldName="AccumulatedCostCenter" Name="AccumulatedCostCenter" ShowInCustomizationForm="True" VisibleIndex="9" Width="150px" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="DepreciationCostCenter" FieldName="DepreciationCostCenter" Name="DepreciationCostCenter" ShowInCustomizationForm="True" VisibleIndex="10" Width="150px" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="Qty" Name="Qty"  ShowInCustomizationForm="True" VisibleIndex="11" Width="100" UnboundType="Bound" ReadOnly="true">
                                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="txtOrderQty" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                <%--<ClientSideEvents ValueChanged="autocalculate" NumberChanged="orderqtynegativecheck" />--%>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Location" FieldName="Location" Name="Location" ShowInCustomizationForm="True" VisibleIndex="12" Width="150px" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Department" FieldName="Department" Name="Department" ShowInCustomizationForm="True" VisibleIndex="13" Width="150px" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="AccountablePerson" FieldName="AccountablePerson" Name="AccountablePerson" ShowInCustomizationForm="True" VisibleIndex="14" Width="150" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>                                                                        
                                                                        <dx:GridViewDataTextColumn Caption="WarehouseCode" FieldName="WarehouseCode" Name="WarehouseCode" ShowInCustomizationForm="True" VisibleIndex="15" Width="150px" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="NewLocation" FieldName="NewLocation" VisibleIndex="16" Width="150px" Name="NewLocation">
                                                                             <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glNewLocation" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                    DataSourceID="NewLocationLookup" KeyFieldName="LocationCode" ClientInstanceName="CINNewLocation" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad" >
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="LocationCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" /></dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="LocationDescription" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" /></dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="NewDepartment" FieldName="NewDepartment" VisibleIndex="17" Width="150px" Name="NewDepartment">
                                                                             <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glNewDepartment" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                    DataSourceID="NewDepartmentLookup" KeyFieldName="EntityID" ClientInstanceName="CINNewDepartment" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad" >
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="EntityID" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" /></dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" /></dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="NewAccountablePerson" FieldName="NewAccountablePerson" VisibleIndex="18" Width="150px" Name="NewAccountablePerson">
                                                                             <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glNewAccountablePerson" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                    DataSourceID="NewAccountablePersonLookup" KeyFieldName="EmployeeCode" ClientInstanceName="CINNewAccountablePerson" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad" >
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="EmployeeCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" /></dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="EmployeeID" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" /></dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="2" >
                                                                            <Settings AutoFilterCondition="Contains" /></dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="NewWarehouseCode" FieldName="NewWarehouseCode" VisibleIndex="19" Width="150px" Name="NewWarehouseCode">
                                                                             <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glNewWarehouseCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                    DataSourceID="NewWarehouseCodeLookup" KeyFieldName="WarehouseCode" ClientInstanceName="CINNewWarehouseCode" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad" >
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="WarehouseCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" /></dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" /></dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                                        
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                    <%--<dx:LayoutItem  Caption="Item Code" Name="ItemCode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtItemCode" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Item Description" Name="FullDesc">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtFullDesc" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Item Color" Name="ColorCode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtColorCode" ClientInstanceName="CINSalvageValue" runat="server" Width="170px" ReadOnly="true">
                                                                    
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Item Class" Name="ClassCode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtClassCode" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Item Size" Name="SizeCode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtSizeCode" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Quantity" Name="Qty">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="spinQty" ClientInstanceName="CINQuantity" runat="server" Width="170px" ReadOnly="true" SpinButtons-ShowIncrementButtons="false">
                                                                    <ClientSideEvents ValueChanged="negativecheck"/> 
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="New Location" Name="NewLocation">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glNewLocation" ClientInstanceName="CINNewLocation" DataSourceID="NewLocationLookup" KeyFieldName="LocationCode" runat="server" Width="170px" TextFormatString="{0}" OnLoad="LookupLoad">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                            <dx:GridViewCommandColumn Caption=" " ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="5px">
                                                                            </dx:GridViewCommandColumn>
                                                                            <dx:GridViewDataTextColumn Caption="LocationCode" FieldName="LocationCode" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="LocationDescription" FieldName="LocationDescription" ShowInCustomizationForm="True" VisibleIndex="2" Width="50px">
                                                                            </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Location" Name="Location">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtLocation" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="New Department" Name="NewDepartment">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glNewDepartment" ClientInstanceName="CINNewDepartment" DataSourceID="NewDepartmentLookup" KeyFieldName="EntityID" runat="server" Width="170px" TextFormatString="{0}" OnLoad="LookupLoad">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                            <dx:GridViewCommandColumn Caption=" " ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="5px">
                                                                            </dx:GridViewCommandColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Department(EntityID)" FieldName="EntityID" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Description" FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="2" Width="50px">
                                                                            </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Department" Name="Department">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDepartment" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="New Accountable Person" Name="NewAccountablePerson">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glNewAccountablePerson" ClientInstanceName="CINNewAccountablePerson" DataSourceID="NewAccountablePersonLookup" KeyFieldName="    " runat="server" Width="170px" TextFormatString="{0}" OnLoad="LookupLoad">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                            <dx:GridViewCommandColumn Caption=" " ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="10px">
                                                                            </dx:GridViewCommandColumn>
                                                                            <dx:GridViewDataTextColumn Caption="EmployeeCode" FieldName="EmployeeCode" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="EmployeeID" FieldName="EmployeeID" ShowInCustomizationForm="True" VisibleIndex="2" Width="50px">
                                                                            </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Accountable Person" Name="AccountablePerson">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtAccountablePerson" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="New Warehouse Code" Name="NewWarehouseCOde">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glNewWarehouseCode" runat="server" Width="170px" ClientInstanceName="CINNewWarehouseCode" DataSourceID="NewWarehouseCodeLookup" KeyFieldName="WarehouseCode"  TextFormatString="{0}" OnLoad="LookupLoad">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                            <dx:GridViewCommandColumn Caption=" " ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="10px">
                                                                            </dx:GridViewCommandColumn>
                                                                            <dx:GridViewDataTextColumn Caption="WarehouseCode" FieldName="WarehouseCode" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Description" FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="2" Width="50px">
                                                                            </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Warehouse Code" Name="WarehouseCode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtWarehouseCode" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                </Items>
                                            </dx:LayoutGroup>
                                          
                                         </Items>
                                    </dx:LayoutGroup>



                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field 1:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" OnLoad="TextboxLoad">
                                                            <%--<ClientSideEvents Validation="function(){isValid = true;}" />--%>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 2:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 3:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 4:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 5:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 6:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 7:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 8:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 9:">
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
                                          <dx:LayoutItem Caption="Added By:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Added Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Last Edited By:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Last Edited Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>  
                                  <dx:LayoutItem Caption="Submitted By:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Submitted Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem> 
                                     <dx:LayoutItem Caption="Cancelled By:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Cancelled Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem> 

                                         
                                        </Items>
                                    </dx:LayoutGroup>



                                     <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction">
                                        <Items>
                                            <dx:LayoutGroup Caption="Reference Detail">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Width="860px" ClientInstanceName="gvRef" OnCommandButtonInitialize="gv_CommandButtonInitialize">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans"
                                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing"/>
                                                                    
                                                                    <SettingsPager PageSize="5">
                                                                    </SettingsPager>
                                                                    <SettingsEditing Mode="Batch">
                                                                    </SettingsEditing>
                                                                    <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn Caption="DocNumber" FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" ReadOnly="True">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Reference TransType" FieldName="RTransType" Name="RTransType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="90px" ShowUpdateButton="True" ShowCancelButton="False">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="ViewReferenceTransaction">
                                                                                    <Image IconID="functionlibrary_lookupreference_16x16">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                <dx:GridViewCommandColumnCustomButton ID="ViewTransaction">
                                                                                    <Image IconID="find_find_16x16">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Reference DocNumber" FieldName="REFDocNumber" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="True">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4" ReadOnly="True">
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
                                    </dx:LayoutGroup>











                                </Items>
                            </dx:TabbedLayoutGroup>

                           
                           
               
                        </Items>
                    </dx:ASPxFormLayout>
      
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
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
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                                <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                </dx:ASPxButton>
                            </td> 
                            <td>
                                <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                                <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                </dx:ASPxButton>
                            </td> 
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
    </form>

    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>


    <%--grid Datasource ods && sds--%>
    <asp:SqlDataSource ID="gv1DS" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Accounting.PropertyTransferDetail WHERE DocNumber IS NULL"
         OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:ObjectDataSource ID="gv1ODS" runat="server" SelectMethod="getdetail" TypeName="Entity.PropertyTransfer+PropertyTransferDetail" DataObjectTypeName="Entity.PropertyTransfer+PropertyTransferDetail" DeleteMethod="DeletePropertyTransferDetail" InsertMethod="AddPropertyTransferDetail" UpdateMethod="UpdatePropertyTransferDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.PropertyTransfer+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

     <%--SO Document Number Look Up--%>
    <asp:SqlDataSource ID="PropertyNumberLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT PropertyNumber, FullDesc FROM Accounting.[AssetInv] AI LEFT JOIN Masterfile.Item I ON AI.ItemCode = I.ItemCode WHERE Status NOT IN ('O','H')"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="NewLocationLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT Code AS LocationCode, Description AS LocationDescription FROM IT.GenericLookup WHERE LookUpKey = 'LOCTN' AND ISNULL(IsInactive,0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

        <asp:SqlDataSource ID="NewDepartmentLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select EntityID, Description from Masterfile.OrgChartEntity WHERE ISNULL(IsInactive,0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="NewAccountablePersonLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT EmployeeCode,EmployeeID, RTRIM(LTRIM(FirstName)) + ' ' + RTRIM(LTRIM(LastName)) AS Name FROM Masterfile.[BPEmployeeInfo] WHERE ISNULL(IsInactive,0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="NewWarehouseCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode,Description FROM Masterfile.[Warehouse] WHERE ISNULL(IsInactive,0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


