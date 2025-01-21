<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmLocation.aspx.cs" Inherits="GWL.frmLocation" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

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
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 350px; /*Change this whenever needed*/
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

            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }
        }

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }
        function OnCustomClick(s, e) {
            if (e.buttonID == "Details") {
                //var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                //var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                //var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                //var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                //factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode);
            }
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
        function OnStartEditing(s, e) {//On start edit grid function 
            if (entry != "V") {
                currentColumn = e.focusedColumn;
                var cellInfo = e.rowValues[e.focusedColumn.index];
                itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for

                if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                }

                //if (!palid) {
                //    var palcus;
                //    var currdate = new Date();
                //    //console.log(currdate.getYear() + ' ' + currdate.getMonth())
                //    palcus = gvCustomer.GetText();
                //    var year = String(currdate.getYear());
                //    year = year.slice(1, year.length);
                //    var month = parseInt(currdate.getMonth()) + 1;
                //    month = String(month);
                //    console.log(month)
                //    console.log(palcus)
                //    if (month.length == 1)
                //        month = "0" + month;
                //    //console.log(year + '' + month)
                //    if (PalCharCount == "13")
                //        s.batchEditApi.SetCellValue(e.visibleIndex, 'PalletID', palcus + month + '' + year + '-00001');
                //    else
                //        if (PaltwoCustomer == "1")
                //            s.batchEditApi.SetCellValue(e.visibleIndex, 'PalletID', palcus.substring(0, 2) + month + '' + year + '-00001');
                //        else
                //            s.batchEditApi.SetCellValue(e.visibleIndex, 'PalletID', palcus + month + '' + year + '-0001');
                //}
            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            if (entry != "V") {
                var cellInfo = e.rowValues[currentColumn.index];
                if (currentColumn.fieldName === "ItemCode") {
                    cellInfo.value = gl.GetValue();
                    cellInfo.text = gl.GetText().toUpperCase();
                }
                if (currentColumn.fieldName == "CustomerCode") {
                    cellInfo.value = glStorerKey.GetValue();
                    cellInfo.text = glStorerKey.GetText();
                }


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
            if (keyCode == 13) {
                gv1.batchEditApi.EndEdit();
            }//ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            setTimeout(function () {
                gv1.batchEditApi.EndEdit();
            }, 500);
        }


        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                //if (column != s.GetColumn(6) && column != s.GetColumn(1) && column != s.GetColumn(7) && column != s.GetColumn(5) && column != s.GetColumn(8) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23) && column != s.GetColumn(24) && column != s.GetColumn(13)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                //    var cellValidationInfo = e.validationInfo[column.index];
                //    if (!cellValidationInfo) continue;
                //    var value = cellValidationInfo.value;
                //    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                //        cellValidationInfo.isValid = false;
                //        cellValidationInfo.errorText = column.fieldName + " is required";
                //        isValid = false;
                //    }
                //    else {
                //        isValid = true;
                //    }
                //}
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
            var height = Math.max(0, document.documentElement.clientHeight);
            gv1.SetWidth(width - 120);
            gv1.SetHeight(height - 120);

        }
        function onMinQtyValueChanged(s, e) {

            if (s.GetInputElement().value > Math.trunc(maxQty.GetInputElement().value)) {
                alert("Minimum QTY must not be greater than Maximum QTY, Minimum QTY will be set less to Max QTY by 1.");
                minQty.GetInputElement().value = (Math.trunc(maxQty.GetInputElement().value) - 1).toFixed(2);
                if (minQty.GetInputElement().value < 0) {
                    alert("Minimum will be set to 0.")
                    minQty.GetInputElement().value = (0).toFixed(2);
                }
            }

        }
        function onMaxQtyValueChanged(s, e) {

            if (s.GetInputElement().value < Math.trunc(minQty.GetInputElement().value)) {
                alert("Max QTY must not be less than Minimum QTY, Max QTY will be set greater to Minimum Qty by 1.");
                maxQty.GetInputElement().value = (Math.trunc(minQty.GetInputElement().value) + 1).toFixed(2);
            }

        }

        function onReplenishCheckedChanged(s, e) {

            if (replenishCheckBox.GetChecked() == false) {
                // textbox enable edit
                maxQty.GetInputElement().readOnly = false;

                maxQty.GetInputElement().style.color = "black";
                minQty.GetInputElement().style.color = "black";
                minQty.GetInputElement().readOnly = false;
            } else {
                // textbox disable edit
                maxQty.GetInputElement().readOnly = true;
                minQty.GetInputElement().readOnly = true;
                maxQty.GetInputElement().style.color = "gray";
                minQty.GetInputElement().style.color = "gray";
            }
        }

    </script>

    <!--#endregion-->
</head>
<body style="height: 910px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" Text="Location" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>

        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="850px" Height="716px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="form1_layout" runat="server" Height="900px" Width="850px" Style="margin-left: -3px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="Header" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="RefDoc" Name="RefDoc">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRefDoc" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Location Description">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDesc" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Location Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLocation" runat="server" AutoCompleteType="Disabled" Width="170px" OnLoad="TextboxLoad">
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
                                            <dx:LayoutItem Caption="OnHand BaseQty">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtOnHandBase" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Warehouse Code:" Name="WarehouseCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtwarehousecode" runat="server" Width="170px" DataSourceID="Warehouse" OnLoad="LookupLoad" KeyFieldName="WarehouseCode" TextFormatString="{0}">
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e) {
                                                                   cp.PerformCallback('wh');

                                                                   e.processOnServer = false;
                                                                }" />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Current PalletCount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCurrentPal" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Storage Type:" Name="StorageType">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtStorageType" runat="server" Width="170px" DataSourceID="Storage" OnLoad="LookupLoad" KeyFieldName="StorageType" TextFormatString="{0}">
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e) {
                                                                   cp.PerformCallback('wh');
                                                                   e.processOnServer = false;
                                                                }" />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Maximum BulkQty">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtMaxBulk" runat="server" Number="0" Width="170px" MinValue="0" OnLoad="SpinEdit_Load" MaxValue="999999999999">
                                                            <SpinButtons ShowIncrementButtons="false" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Plant Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvPlant" runat="server" Width="170px" OnLoad="LookupLoad" ClientInstanceName="plant" DataSourceID="PlantCode" KeyFieldName="PlantCode" TextFormatString="{0}">
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e) {
                                                                   cp.PerformCallback('plant');
                                                                   e.processOnServer = false;
                                                                }" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>

                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Maximum BaseQty">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtMaxBase" runat="server" Number="0" OnLoad="SpinEdit_Load" Width="170px" MinValue="0" MaxValue="999999999999">
                                                            <SpinButtons ShowIncrementButtons="false" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Customer Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvCustomer" runat="server" Width="170px" DataSourceID="Masterfilebizcustomer" OnLoad="LookupLoad" KeyFieldName="BizPartnerCode" TextFormatString="{0}">

                                                            <%--        <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle> 
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>--%>
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>

                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="OnHand BulkQty">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtOnHandBulk" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Room Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvRoom" runat="server" Width="170px" DataSourceID="RoomCode" OnLoad="LookupLoad" KeyFieldName="RoomCode" TextFormatString="{0}">

                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Maximum Pallet Count">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtMaxPal" runat="server" Number="0" Width="170px" OnLoad="SpinEdit_Load" MinValue="0" MaxValue="999999999999">
                                                            <SpinButtons ShowIncrementButtons="false" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Location Type">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvLocType" runat="server" Width="170px" DataSourceID="LocationType" OnLoad="LookupLoad" KeyFieldName="Code" TextFormatString="{0}">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                             <dx:LayoutItem Caption="OnHand BaseUnit">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtBaseUnit" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



                                            <dx:LayoutItem Caption="Item Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvItemCode" runat="server" Width="170px" DataSourceID="Masterfileitem" OnLoad="LookupLoad" KeyFieldName="ItemCode" TextFormatString="{0}">

                                                            <%--                                                             <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle><GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>--%>
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            
                                            <dx:LayoutItem Caption="Minimum Weight">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtMinweight" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                             <dx:LayoutItem Caption="Max QTY">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtMaxQty" runat="server" Number="0" Width="170px" MinValue="0" OnLoad="SpinEdit_Load" MaxValue="999999999999" ClientInstanceName="maxQty">
                                                            <SpinButtons ShowIncrementButtons="false" />
                                                            <ClientSideEvents ValueChanged="function(s, e) { onMaxQtyValueChanged(s, e); }" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                          


                                            <dx:LayoutItem Caption="Priority">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtPriority" runat="server" OnLoad="SpinEdit_Load" Number="0" Width="170px">
                                                            <SpinButtons ShowIncrementButtons="false" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            
                                            <dx:LayoutItem Caption="Minimum QTY">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtMinQty" runat="server" Number="0" Width="170px" MinValue="0" OnLoad="SpinEdit_Load" MaxValue="999999999999" ClientInstanceName="minQty">
                                                            <SpinButtons ShowIncrementButtons="false" />
                                                            <ClientSideEvents ValueChanged="function(s, e) { onMinQtyValueChanged(s, e); }" />

                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="ABC">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtABC" runat="server" Width="170px" DataSourceID="ABCSpeed" OnLoad="LookupLoad" KeyFieldName="ABC">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Replenish">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkReplenish" runat="server" OnLoad="CheckboxLoad" CheckState="Unchecked" Text=" " ClientInstanceName="replenishCheckBox" CheckedChanged="chkReplenish_CheckedChanged">
                                                            <ClientSideEvents CheckedChanged="function(s, e) { onReplenishCheckedChanged(s, e); }" />
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            
                                            <dx:LayoutItem Caption="IsInactive">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkIsInactive" runat="server" OnLoad="CheckboxLoad" CheckState="Unchecked" Text=" ">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field1" Name="txtHField1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field6" Name="txtHField6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field2" Name="txtHField2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field7" Name="txtHField7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field3" Name="txtHField3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field8" Name="txtHField8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field4" Name="txtHField4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field9" Name="txtHField9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Field5" Name="txtHField5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Audit Trail" ColCount="2" ColSpan="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Added By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAddedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Added Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAddedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLastEditedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLastEditedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Activated By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActivatedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Activated Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActivatedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="DeActivated By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDeActivatedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="DeActivated Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDeActivatedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                </Items>
                            </dx:TabbedLayoutGroup>
                            <dx:LayoutGroup Caption="Location Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <div id="loadingcont">
                                                    <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="747px" OnInit="gv1_Init"
                                                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                        OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber"
                                                        SettingsBehavior-AllowSort="false" OnRowValidating="grid_RowValidating">
                                                        <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans"
                                                            BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating" />
                                                        <SettingsPager Mode="ShowAllRecords" />
                                                        <SettingsEditing Mode="Batch" />
                                                        <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="530" ShowFooter="True" />

                                                        <SettingsBehavior AllowSort="False"></SettingsBehavior>

                                                        <SettingsCommandButton>
                                                            <NewButton>
                                                                <Image IconID="actions_addfile_16x16"></Image>
                                                            </NewButton>
                                                            <DeleteButton>
                                                                <Image IconID="actions_cancel_16x16"></Image>
                                                            </DeleteButton>
                                                        </SettingsCommandButton>
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ShowDeleteButton="true" ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="60px">
                                                                <CustomButtons>
                                                                    <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                        <Image IconID="support_info_16x16"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                </CustomButtons>

                                                            </dx:GridViewCommandColumn>
                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False" PropertiesTextEdit-Native="true"
                                                                VisibleIndex="0">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="0px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true">
                                                                <PropertiesTextEdit ConvertEmptyStringToNull="False" Native="true">
                                                                </PropertiesTextEdit>

                                                            </dx:GridViewDataTextColumn>

                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Caption="WarehouseCode" Width="0px" FieldName="WareHouseCode" Name="WareHouseCode" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="True">
                                                                <PropertiesTextEdit Width="100px" Native="True"></PropertiesTextEdit>
                                                                <%--<EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glwCodeGrid" runat="server" Width="170px" DataSourceID="Warehouse" OnLoad="gvLookupLoad" KeyFieldName="WarehouseCode" TextFormatString="{0}">
                                                                 
                                                                        <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                            <RequiredField IsRequired="True" />
                                                                        </ValidationSettings>
                                                                        <InvalidStyle BackColor="Pink">
                                                                        </InvalidStyle>
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                                            <Settings ShowFilterRow="True"></Settings>
                                                                        </GridViewProperties>
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>--%>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="0px" Caption="LocationCode" FieldName="LocationCode" Name="LocationCode" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="True">
                                                                <PropertiesTextEdit Width="0px" Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="CustomerCode" FieldName="CustomerCode" VisibleIndex="7" Width="95px" Name="CustomerCode">
                                                                <EditItemTemplate>
                                                                    <dx:ASPxGridLookup Width="80px" ID="glStorerKey" runat="server" AutoGenerateColumns="False" ClientInstanceName="glStorerKey"
                                                                        DataSourceID="Masterfilebiz" KeyFieldName="BizPartnerCode" OnLoad="gvLookupLoad" TextFormatString="{0}">
                                                                        <GridViewProperties>
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            <Settings ShowFilterRow="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" Settings-AutoFilterCondition="Contains" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" CloseUp="gridLookup_CloseUp" />

                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>

                                                            <%--   <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field2" Caption="Client Name" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="16" UnboundType="Bound">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field1" Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="26" UnboundType="Bound">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>

                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field3" Caption="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="28" UnboundType="Bound">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field4" Caption="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="29" UnboundType="Bound">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field5" Caption="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="30" UnboundType="Bound">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field6" Caption="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="31" UnboundType="Bound">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field7" Caption="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="32" UnboundType="Bound">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field8" Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="33" UnboundType="Bound">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field9" Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="33" UnboundType="Bound">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>--%>
                                                        </Columns>
                                                    </dx:ASPxGridView>
                                                </div>

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
                                    <dx:ASPxButton ID="updateBtn" runat="server" Text="Add" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
                                        UseSubmitBehavior="false" CausesValidation="true">
                                        <ClientSideEvents Click="OnUpdateClick" />
                                    </dx:ASPxButton>
                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>

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
                            <td>
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" AutoPostBack="False" UseSubmitBehavior="false">
                                    <ClientSideEvents Click="function (s, e){  cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                </dx:ASPxButton>
                            </td>
                            <td>
                                <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel">
                                    <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <!--#region Region Datasource-->
        <%--<!--#region Region Header --> --%>
        <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.Location" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.Location" UpdateMethod="UpdateData">
            <SelectParameters>
                <asp:SessionParameter DefaultValue="" Name="DocNumber" SessionField="DocNumber" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.Location+LocationDetail" SelectMethod="getdetail" UpdateMethod="UpdateLocationDetail" TypeName="Entity.Location+LocationDetail" DeleteMethod="DeleteLocationDetail" InsertMethod="AddLocationDetail">
            <SelectParameters>
                <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>


        <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Masterfile.LocationDetail where DocNumber  is null "
            OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item]"
            OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [ColorCode], [ClassCode], [SizeCode] FROM Masterfile.[ItemDetail] WHERE ISNULL(IsInactive,0)=0"
            OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] where isnull(IsInactive,'')=0"
            OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="Warehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, Description from Masterfile.Warehouse  where isnull(IsInactive,0)=0"
            OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="PlantCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT PlantCode, PlantDescription from Masterfile.Plant "
            OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="Masterfilebizcustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,0)=0 and IsCustomer='1'"
            OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="RoomCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT RoomCode, RoomDescription from Masterfile.Room "
            OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="LocationType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select Code,Description from It.GenericLookup where LookUpKey = 'LOCTY'"
            OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="Storage" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT StorageType,StorageDescription FROM MASTERFILE.STORAGETYPE"
            OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="ABCSpeed" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT 'Fast Moving' AS ABC UNION ALL SELECT 'Slow Moving' AS ABC UNION ALL SELECT 'Average Moving' AS ABC"
            OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="PutawayStrategies" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="WITH StrategiesCTE AS (SELECT 'Standard' AS PutawayStrategies, 'ST' AS PutawayStrategiesCode UNION ALL SELECT 'Manual', 'MA'
    UNION ALL SELECT 'Cross Duck', 'CR'UNION ALL SELECT 'Fast Moving', 'FM' UNION ALL SELECT 'Slow Moving', 'SM' UNION ALL SELECT 'Consolidation/Kitting', 'CO/KI') SELECT PutawayStrategies, PutawayStrategiesCode FROM StrategiesCTE;"
            OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="AllocationStrategies" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="WITH AllocationCTE AS (SELECT 'Manual Allocation' AS AllocationStrategies, 'MA' AS AllocationStrategiesCode 
    UNION ALL SELECT 'Auto-Allocation', 'AA' UNION ALL SELECT 'Store Picking', 'SP') SELECT AllocationStrategies, AllocationStrategiesCode FROM AllocationCTE;"
            OnInit="Connection_Init"></asp:SqlDataSource>
    </form>
    <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.BizPartner WHERE (ISNULL(IsInactive, '') = 0)" OnInit="Connection_Init"></asp:SqlDataSource>

    <!--#endregion-->
</body>
</html>


