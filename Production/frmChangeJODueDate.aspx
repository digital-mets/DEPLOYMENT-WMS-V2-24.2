<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmChangeJODueDate.aspx.cs" Inherits="GWL.frmChangeJODueDate" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
<title>Change JO Due Date</title>
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
        }

        function OnUpdateClick(s, e) { 
            var btnmode = btn.GetText(); 
            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }

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
                console.log(counterror);
            }
        }

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        var vatrate = 0;
        var vatdetail1 = 0;

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);
                if (s.cp_forceclose) {
                    delete (s.cp_forceclose);
                    window.close();
                }

            }

            if (s.cp_close) {              
                if (s.cp_valmsg != null && s.cp_valmsg != "" && s.cp_valmsg != undefined) {
                    alert(s.cp_valmsg);
                    delete (s.cp_valmsg);
                }
                if (s.cp_message != null) {
                    alert(s.cp_message);
                    delete (s.cp_message);
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
                //autocalculate();           
            }

            if (s.cp_unitcost) {
                delete (s.cp_unitcost);
            }

            if (s.cp_vatrate != null) {

                vatrate = s.cp_vatrate;
                delete (s.cp_vatrate);
                vatdetail1 = 1 + parseFloat(vatrate);
            }

        }

        var index;
        var closing;
        var itemc; //variable required for lookup
        var itemclr;
        var itemcls;
        var itemsze;
        var itemunit;
        var itemdesc;
        var loading = false;
        var nope = false;
        var valchange = false;
        var valchange2 = false;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for

            itemclr = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
            itemcls = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
            itemsze = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
            itemunit = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
            itemdesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
            index = e.visibleIndex;
            var entry = getParameterByName('entry');

            if (entry == "V") {
                e.cancel = true; //this will made the gridview readonly
            }


            
            if (e.focusedColumn.fieldName == "NewCost")
            {
                if (entry != "V") {
                    e.cancel = false;
                }
                else
                {
                    console.log('genrev to')
                    e.cancel = true;
                }
            }
            

            if (entry != "V") {
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
                    gl4.GetInputElement().value = cellInfo.value;
                    nope = false;
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "Unit") {
                    gl5.GetInputElement().value = cellInfo.value;
                }                
            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];

            var entry = getParameterByName('entry');

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
                cellInfo.value = gl4.GetValue();
                cellInfo.text = gl4.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "Unit") {
                cellInfo.value = gl5.GetValue();
                cellInfo.text = gl5.GetText().toUpperCase();
            }
        }

 

        var val;
        var temp;
        var identifier;
        var testinglang;
        function GridEnd(s, e) {
            identifier = s.GetGridView().cp_identifier;
            val = s.GetGridView().cp_codes;
            //console.log(val + 'val');
            if (val != null) {
                temp = val.split(';');
                delete (s.GetGridView().cp_codes);
            }
            else {
                val = "";
                delete (s.GetGridView().cp_codes);
            }
            console.log('identifier '+identifier)

            if (identifier == 'sku') {

                if (s.keyFieldName == 'ItemCode' && (itemc == null || itemc == '')) {
                    s.SetText('');
                    console.log('heh');
                }
                else if (s.keyFieldName == 'ItemCode' && (itemc != null && itemc != '')) {
                    s.SetText(itemc);
                    console.log('rev');
                }

                if (s.keyFieldName == 'ColorCode' && (itemclr == null || itemclr == '')) {
                    s.SetText("");
                    console.log('heh2');
                }
                //else if (s.keyFieldName == 'ColorCode' && (itemclr != null || itemclr != '')) {
                //    s.SetText(s.GetInputElement().value);
                //}
                if (s.keyFieldName == 'ClassCode' && (itemcls == null || itemcls == "")) {
                    s.SetText("");
                    console.log('heh3');
                }
                if (s.keyFieldName == 'SizeCode' && (itemsze == null || itemsze == "")) {
                    console.log(itemsze)
                    s.SetText("");
                    console.log('heh4');
                }
                delete (s.GetGridView().cp_identifier);
            }
                //else {
                //    s.SetText(s.GetInputElement().value);
                //}
                //else {
                //    s.SetText(s.GetInputElement().value);
                //}

            if (valchange && (val != null && val != 'undefined' && val != '')) {
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, e, column, gv1);
                    gv1.batchEditApi.EndEdit();
                }
            }

            if (valchange2 && (val != null && val != 'undefined' && val != '')) {
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells2(0, e, column, gv1);
                    gv1.batchEditApi.EndEdit();
                }
            }
            loading = false;
            loader.Hide();
        }

        function ProcessCells(selectedIndex, e, column, s) {

            if (val == null) {
                val = ";;;;";
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
            if (temp[3] == null) {
                temp[3] = "";
            }
            if (temp[4] == null) {
                temp[4] = "";
            }
            if (temp[5] == null) {
                temp[5] = "0";
            }

            //console.log('val ' + val);

            if (selectedIndex == 0) {
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
                    if (column.fieldName == "FullDesc") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[3]);
                    }
                    if (column.fieldName == "Unit") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[4]);
                    }
                    if (column.fieldName == "OnHandQty") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[5]));
                    }
                }
                if (identifier == "size") {
                    if (column.fieldName == "OnHandQty") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[0]));
                    }
                }
                valchange = false;
            }
        }

        function ProcessCells2(selectedIndex, e, column, s) {
            if (val == null) {
                val = ";";
                temp = val.split(';');
            }

            if (temp[0] == null || temp[0] == "") {
                temp[0] = "0";
            }

                if (selectedIndex == 0) {
                    if (column.fieldName == "OnHandQty") {
                        console.log('changing');
                        s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[0]));
                        valchange2 = false;
                    }
                }
        }

        function Grid_BatchEditRowValidating(s, e) {

        }

        function lookup(s, e) {
            if (isSetTextRequired) {//Sets the text during lookup for item code
                //s.SetText(s.GetInputElement().value);
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
            if (keyCode == ASPxKey.Enter) {
                gv1.batchEditApi.EndEdit();
            }

        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.

            gv1.batchEditApi.EndEdit();

        }

        function OnCustomClick(s, e)
        {
            if (e.buttonID == "Details")
            {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
                var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&unit=' + unitbase + '&fulldesc=' + fulldesc);
            }
            if (e.buttonID == "Delete") {
                gv1.DeleteRow(e.visibleIndex);
                //autocalculate(s,e);
            }
            if (e.buttonID == "ViewTransaction") {

                var transtype = s.batchEditApi.GetCellValue(e.visibleIndex, "TransType");
                var docnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "DocNumber");
                var commandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "CommandString");

                window.open(commandtring + '?entry=V&transtype=' + transtype + '&parameters=&iswithdetail=true&docnumber=' + docnumber, '_blank', "", false);
                console.log('ViewTransaction')
            }
            if (e.buttonID == "CountSheet") {
                CSheet.Show();
                var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
                var docnumber = getParameterByName('docnumber');
                var transtype = getParameterByName('transtype');
                var entry = getParameterByName('entry');
                CSheet.SetContentUrl('../WMS/frmCountSheet.aspx?entry=' + entry + '&docnumber=' + docnumber + '&transtype=' + transtype +
                    '&linenumber=' + linenum);
            }
            if (e.buttonID == "ViewReferenceTransaction") {
                var rtranstype = s.batchEditApi.GetCellValue(e.visibleIndex, "RTransType");
                var rdocnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "REFDocNumber");
                var rcommandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "RCommandString");
                window.open(rcommandtring + '?entry=V&transtype=' + rtranstype + '&parameters=&iswithdetail=true&docnumber=' + rdocnumber, '_blank');
                console.log('ViewTransaction')
            }
        }


        function endcp(s, e) {
            var endg = s.GetGridView().cp_endgl1;
            if (endg == true) {
                console.log(endg);
                e.processOnServer = false;
                endg = null;
            }
        }

        Number.prototype.format = function (d, w, s, c) {
            var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
                num = this.toFixed(Math.max(0, ~~d));

            return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
        };

        function autocalculate(s, e) {

            OnInitTrans();

            var DQty = 0.00;
            var SQty = 0.00;

            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {

                        DQty = gv1.batchEditApi.GetCellValue(indicies[i], "IssuedQty");
                        SQty += DQty;

                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            
                            DQty = gv1.batchEditApi.GetCellValue(indicies[i], "IssuedQty");
                            SQty += DQty;

                        }
                    }
                }

                txtTotalQty.SetText(SQty.format(2, 3, ',', '.'));

            }, 500);
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
                                <dx:ASPxLabel ID="HeaderText" runat="server" Text="Change JO Due Date" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
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
        <ClientSideEvents CloseUp="function (s, e) { cp.PerformCallback('RefGrid') }" />
    </dx:ASPxPopupControl>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>
                                            <dx:LayoutGroup Caption="Information" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Document Number" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocNumber" runat="server" OnLoad="TextboxLoad" Width="170px" AutoCompleteType="Disabled" Enabled="False" ReadOnly ="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Document Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnInit="dtpDocDate_Init" OnLoad="Date_Load" Width="170px">
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
                                                    <dx:LayoutItem Caption="Reason">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglReason" runat="server" AutoGenerateColumns="False" DataSourceID="sdsReasons" KeyFieldName="Code" OnLoad="LookupLoad" TextFormatString="{1}" Width="170px" ClientInstanceName="aglReasons">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn Caption="Code" FieldName="Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Description" FieldName="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
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
                                                    <dx:LayoutItem Caption="Old JO Due Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpOldDueDate" runat="server" ClientEnabled="False" Width="170px" DisabledStyle-BackColor="White" DisabledStyle-ForeColor="Black" DropDownButton-ClientVisible="False">
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
                                                    <dx:LayoutItem Caption="Reference JO" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglReferenceJO" runat="server" AutoGenerateColumns="False" DataSourceID="sdsReferenceJO" KeyFieldName="DocNumber" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn Caption="Document Number" FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="DocDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="100px">
                                                                            <PropertiesDateEdit AllowMouseWheel="False" DisplayFormatString="MM/dd/yyyy">
                                                                                <DropDownButton ClientVisible="False" Enabled="False">
                                                                                </DropDownButton>
                                                                            </PropertiesDateEdit>
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="DueDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="100px">
                                                                            <PropertiesDateEdit AllowMouseWheel="False" DisplayFormatString="MM/dd/yyyy">
                                                                                <DropDownButton ClientVisible="False" Enabled="False">
                                                                                </DropDownButton>
                                                                            </PropertiesDateEdit>
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Lead Time" FieldName="LeadTime" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Customer" FieldName="CustomerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TotalJOQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5">
                                                                            <PropertiesTextEdit DisplayFormatString="{0:N}">
                                                                            </PropertiesTextEdit>
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TotalINQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6">
                                                                            <PropertiesTextEdit DisplayFormatString="{0:N}">
                                                                            </PropertiesTextEdit>
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TotalFinalQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7">
                                                                            <PropertiesTextEdit DisplayFormatString="{0:N}">
                                                                            </PropertiesTextEdit>
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Remarks" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8" Width="200px">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('CallbackReferenceJO');}" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="New JO Due Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpNewDueDate" runat="server" OnInit="dtpDocDate_Init" OnLoad="Date_Load" Width="170px">
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
                                                    <dx:LayoutItem Caption="Customer">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtCustomer" runat="server" Width="170px" ClientEnabled="False" DisabledStyle-BackColor="White" DisabledStyle-ForeColor="Black">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>                                                    
                                                    <dx:LayoutItem Caption="SO Due Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtSODueDate" runat="server" ClientEnabled="False" Width="170px" DisabledStyle-BackColor="White" DisabledStyle-ForeColor="Black">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Remarks">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memRemarks" runat="server" Height="71px" OnLoad="MemoLoad" Width="170px">
                                                                </dx:ASPxMemo>
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
                                            <dx:LayoutItem Caption="Approved By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHApprovedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Approved Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHApprovedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledDate" runat="server" Width="170px" ReadOnly="True">
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
                                                        <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Width="860px" ClientInstanceName="gvRef" OnCommandButtonInitialize="gv_CommandButtonInitialize">
                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  Init="OnInitTrans" />
                                                                    
                                                            <SettingsPager PageSize="5">
                                                            </SettingsPager>
                                                            <SettingsEditing Mode="Batch">
                                                            </SettingsEditing>
                                                            <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn Caption="DocNumber" FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5">
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
                                                                <dx:GridViewDataTextColumn Caption="Reference DocNumber" FieldName="REFDocNumber" ShowInCustomizationForm="True" VisibleIndex="2">
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
                         <td><dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false">
                             <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                             </dx:ASPxButton>
                         <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel">
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
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.ItemRevaluation" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.ItemRevaluation" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.ItemRevaluation+ItemRevaluationDetail" SelectMethod="getdetail" UpdateMethod="UpdateItemRevaluationDetail" TypeName="Entity.ItemRevaluation+ItemRevaluationDetail" DeleteMethod="DeleteItemRevaluationDetail" InsertMethod="AddItemRevaluationDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.DIS+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            <asp:QueryStringParameter Name="TransType" QueryStringField="transtype" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsReferenceJO" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber, DocDate, DueDate, LeadTime, CustomerCode, TotalJOQty, TotalINQty, TotalFinalQty, Remarks FROM Production.JobOrder WHERE Status IN ('N','W') AND ISNULL(ProdSubmittedBy,'') != ''" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsReasons" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT ReasonCode AS Code, Description FROM Masterfile.Reason WHERE ISNULL(IsInactive,0) = 0 AND TransactionType = 'PRDCHG'" OnInit ="Connection_Init"></asp:SqlDataSource>  
    <!--#endregion-->
</body>
</html>


