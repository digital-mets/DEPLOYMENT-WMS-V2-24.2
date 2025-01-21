<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmBankReconciliation.aspx.cs" Inherits="GWL.frmBankReconciliation" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Bank Reconciliation</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script><%--NEWADD--%>

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
        var isValid = true;
        var counterror = 0;
        var totalvat = 0;
        var totalnonvat = 0;


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
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        var vatrate = 0;
        var atc = 0
        function gridView_EndCallback(s, e) {
            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_success);
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

            if (s.cp_generated) {
                delete (s.cp_generated);
                autocalculate();
            }
            if (s.cp_change) {
                IsSelectedChng();
                //var DocnumberArr = OnbtnOkClick();
                //setTimeout(function () { 
                //    recheck(DocnumberArr);
                //}, 1000);
            }
            if (s.cp_forceclose) {//NEWADD
                delete (s.cp_forceclose);
                window.close();
            }
        }

        var index;
        var closing;
        var itemc; //variable required for lookup
        var valchange = false;
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
            var entry = getParameterByName('entry');
            if (entry != "V" && entry != "D") {
                if (e.focusedColumn.fieldName != "IsSelected" && e.focusedColumn.fieldName != "Field1" && e.focusedColumn.fieldName != "Field2" && e.focusedColumn.fieldName != "Field3" && e.focusedColumn.fieldName != "Field4" && e.focusedColumn.fieldName != "Field5" && e.focusedColumn.fieldName != "Field6" && e.focusedColumn.fieldName != "Field7" && e.focusedColumn.fieldName != "Field8" && e.focusedColumn.fieldName != "Field9") {
                    e.cancel = true;
                }
            }
            else
                e.cancel = true;
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            var entry = getParameterByName('entry');

            //if (entry == "N") {

            if (valchange) {

                valchange = false;
                closing = false;
                for (var i = 0; i < s.GetColumnsCount() ; i++) {
                    var column = s.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, e, column, s);
                }
            }
            //}
        }

        //ITO YUNG NAG LALAGAY NG LAMAN SA TEXT
        //Function na nag seset ng value
        var val;
        var temp;
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
            if (selectedIndex == 0) {
                if (column.fieldName == "ColorCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0]);
                }
                if (column.fieldName == "ClassCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[1]);
                }
                if (column.fieldName == "SizeCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[2]);
                }
                if (column.fieldName == "Unit") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
                }
                if (column.fieldName == "FullDesc") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
                }
            }
        }

        Number.prototype.format = function (d, w, s, c) {
            var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
                num = this.toFixed(Math.max(0, ~~d));

            return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
        };

        function autocalculate(s, e) {
            var debitamount = 0.00;
            var creditamount = 0.00;
            var balance = 0.00;
            var balance2 = 0.00;
            var reconbal = 0.00;
            var reconbal2 = 0.00;
            var totaldebitamount = 0.00;
            var totalcreditamount = 0.00;
            var endingbal = 0.00;
            setTimeout(function () {

                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                if (txtLastBankReconBal.GetText() == null || txtLastBankReconBal.GetText() == "")
                    reconbal = 0.00;
                else
                    reconbal = Number(txtLastBankReconBal.GetText());
                reconbal2 = reconbal;
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.GetCellValue(indicies[i], "IsSelected") == "True" || gv1.batchEditApi.GetCellValue(indicies[i], "IsSelected") == true) {
                        debitamount = gv1.batchEditApi.GetCellValue(indicies[i], "DebitAmount");
                        creditamount = gv1.batchEditApi.GetCellValue(indicies[i], "CreditAmount");
                        totaldebitamount += debitamount;
                        totalcreditamount += creditamount;
                        balance = (reconbal2 + creditamount) - debitamount;
                        gv1.batchEditApi.SetCellValue(indicies[i], "BankRunningBalance", balance.toFixed(2));
                        reconbal2 = balance;
                    }
                    else {
                        gv1.batchEditApi.SetCellValue(indicies[i], "BankRunningBalance", reconbal2.toFixed(2));
                    }
                }
                console.log(totalcreditamount + " = totcred; " + totaldebitamount + " = totdeb; " + reconbal + " = reconbal");

                endingbal = (+reconbal + totalcreditamount) - totaldebitamount;

                txtTotalDebitAmount.SetText(totaldebitamount.format(2, 3, ',', '.'));
                txtTotalCreditAmount.SetText(totalcreditamount.format(2, 3, ',', '.'));
                txtEndingBalance.SetText(endingbal.format(2, 3, ',', '.'));
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
        }

        function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode == ASPxKey.Enter) {
                gv1.batchEditApi.EndEdit();
            }
            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            gv1.batchEditApi.EndEdit();
        }

        //validation
        //function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields/index 0 is from the commandcolumn)
        //    for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
        //        var column = s.GetColumn(i);
        //        if (column != s.GetColumn(1) && column != s.GetColumn(2) && column != s.GetColumn(3)
        //            && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15)
        //            && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18)
        //            && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21)
        //            && column != s.GetColumn(22) && column != s.GetColumn(23)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
        //            var cellValidationInfo = e.validationInfo[column.index];
        //            if (!cellValidationInfo) continue;
        //            var value = cellValidationInfo.value;
        //            if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
        //                cellValidationInfo.isValid = false;
        //                cellValidationInfo.errorText = column.fieldName + " is required";
        //                isValid = false;
        //                console.log(column);
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
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&unit=' + unitbase + '&fulldesc=' + fulldesc);
            }
            if (e.buttonID == "CountSheet") {
                CSheet.Show();
                var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
                var docnumber = getParameterByName('docnumber');
                var transtype = getParameterByName('transtype');
                var entry = getParameterByName('entry');
                CSheet.SetContentUrl('../wms/frmCountSheet.aspx?entry=' + entry + '&docnumber=' + docnumber + '&transtype=' + transtype +
                     '&linenumber=' + linenum);
            }
            if (e.buttonID == "Delete") {
                gv1.DeleteRow(e.visibleIndex);
                autocalculate(s, e);
                console.log('test')
            }
            if (e.buttonID == "ViewTransaction") {

                //var url = window.location.pathname;

                //console.log(url);
                //str.substring(0, str.lastIndexOf("/"));

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


        function Generate(s, e) {
            var DocnumberArr = OnbtnOkClick();
            //Session["DocumentNumbersArr"] = DocnumberArr;
            var generate = confirm("Are you sure you want to generate these Bank Account Numbers?");
            if (generate) {
                gv1.CancelEdit();
                cp.PerformCallback('Generate');
                autocalculate(s, e);
                e.processOnServer = false;
            }
            setTimeout(function () {
                recheck(DocnumberArr);
            }, 1000);
        }



        //09-05-2018 Get Checked values //Begin

        function recheck(DocnumberArr) {

            for (var i = 0; i < gv1.GetVisibleRowsOnPage() ; i++)
            {
                var Dc = gv1.batchEditApi.GetCellValue(i, "TransDocNumber");
                var Ln = gv1.batchEditApi.GetCellValue(i, "TransLineNumber");
                for (a = 0; a < DocnumberArr.length; a++) {
                    if (DocnumberArr[a][0] == Dc && DocnumberArr[a][1] == Ln)
                    {
                        gv1.batchEditApi.SetCellValue(i, "IsSelected", "True");
                    }

                }
            }           
        }

        function OnbtnOkClick() {
            //var chkval = new array();
            var DocnumberArr = new Array();
            //var DocnumberArr = [[], []]
            //alert(gv1.GetVisibleRowsOnPage());
            for (var i = 0; i < gv1.GetVisibleRowsOnPage() ; i++) { 
                var Docnumber = gv1.batchEditApi.GetCellValue(i, "TransDocNumber");
                var LineNumber = gv1.batchEditApi.GetCellValue(i, "TransLineNumber");
                    
                //alert(gv1.batchEditApi.GetCellValue(i, "IsSelected"));

                if (gv1.batchEditApi.GetCellValue(i, "IsSelected") == "True" || gv1.batchEditApi.GetCellValue(i, "IsSelected") == true) {
                    DocnumberArr.push([Docnumber,LineNumber]); 
                } 
            }
            //alert(DocnumberArr)
            return DocnumberArr;
        };

        function IsSelectedChng()
        { 
            for (var i = 0; i < gv1.GetVisibleRowsOnPage() ; i++) {
                gv1.batchEditApi.SetCellValue(i, "IsSelected", cbSelectAll.GetChecked() ? "True" : "False");
            }  
            autocalculate();
        }
        //09-05-2018 Get Checked values //End


        function GridEnd(s, e) {
            //console.log('gridend');
            val = s.GetGridView().cp_codes;
            temp = val.split(';');

            if (closing == true) {
                for (var i = 0; i > -gv1.GetVisibleRowsOnPage() ; i--) {
                    gv1.batchEditApi.ValidateRow(-1);
                    gv1.batchEditApi.StartEdit(i, gv1.GetColumnByField("ColorCode").index);
                }
                gv1.batchEditApi.EndEdit();
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
            gvJournal.SetWidth(width - 100);
            gvRef.SetWidth(width - 120);
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
                    <dx:ASPxLabel runat="server" Text="Bank Reconciliation" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
    <%--<dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="90"
        ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>--%>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="1050px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number:" Name="DocNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px" OnLoad="LookupLoad">
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
                                            <dx:LayoutItem Caption="Bank Account Code:" Name="BankAccountCode" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glBankAccountCode" runat="server" Width="170px" DataSourceID="sdsBankAccount" KeyFieldName="BankAccountCode" OnLoad="LookupLoad" TextFormatString="{0}" AutoGenerateColumns="false">
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function (s, e){ cp.PerformCallback('callbackBankAccount');  e.processOnServer = false;}"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="BankAccountCode" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns> 
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cut Off Date:" Name="CutOffDate" RequiredMarkDisplayMode="Required">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpCutOffDate" runat="server" OnLoad="Date_Load" Width="170px" >
                                                        <ClientSideEvents Validation="OnValidation" ValueChanged="function (s, e){ cp.PerformCallback('callbackCutOff');  e.processOnServer = false;}"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Bank Recon Balance:" Name="LastBankReconBal">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLastBankReconBal" runat="server" Width="170px" ReadOnly="true" ClientInstanceName="txtLastBankReconBal" DisplayFormatString="{0:N}">
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Bank Recon Date:" Name="LastBankReconDate" RequiredMarkDisplayMode="Required">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpLastBankReconDate" runat="server" ReadOnly="true" Width="170px" DropDownButton-Visible="False">
                                                        <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip" >
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total Debit Amount" Name="TotalDebitAmount" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" >
                                                        <dx:ASPxTextBox ID="txtTotalDebitAmount" runat="server" Width="170px" ReadOnly="true" ClientInstanceName="txtTotalDebitAmount" DisplayFormatString="{0:N}">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Ending Balance:" Name="EndingBalance" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" >
                                                        <dx:ASPxTextBox ID="txtEndingBalance" runat="server" Width="170px" ReadOnly="true" ClientInstanceName="txtEndingBalance" DisplayFormatString="{0:N}">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total Credit Amount" Name="TotalCreditAmount" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" >
                                                        <dx:ASPxTextBox ID="txtTotalCreditAmount" runat="server" Width="170px" ReadOnly="true" ClientInstanceName="txtTotalCreditAmount" DisplayFormatString="{0:N}">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Select/Unselect All">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="cbxSelectAll" runat="server" CheckState="Checked" ReadOnly="false" ClientInstanceName="cbSelectAll">
                                                        <ClientSideEvents CheckedChanged="IsSelectedChng" />
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="" Name="Genereatebtn">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxButton ID="Generatebtn" runat="server" AutoPostBack="False" CausesValidation="False" OnLoad="Generate_Btn" 
                                                            ClientInstanceName="btnGenerate" Text="Generate" Theme="MetropolisBlue" UseSubmitBehavior="False"  Width="170px">
                                                            <ClientSideEvents Click="Generate" />
                                                        </dx:ASPxButton>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
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
                                            <dx:LayoutItem Caption="Field 6:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" OnLoad="TextboxLoad">
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
                                            <dx:LayoutItem Caption="Field 7:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad">
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
                                            <dx:LayoutItem Caption="Field 8:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" OnLoad="TextboxLoad">
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
                                            <dx:LayoutItem Caption="Field 9:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" OnLoad="TextboxLoad">
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
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Audit Trail" ColCount="2">
                                        <Items>
                                              <dx:LayoutItem Caption="Added By:" >
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTextBox ID="txtHAddedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                              </dx:LayoutItem>
                                              <dx:LayoutItem Caption="Added Date:" >
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTextBox ID="txtHAddedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                   </dx:LayoutItem>
                                              <dx:LayoutItem Caption="Last Edited By:" >
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                   </dx:LayoutItem>
                                              <dx:LayoutItem Caption="Last Edited Date:" >
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                                <ClientSideEvents Validation="function(){isValid = true;}" />
                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                   </dx:LayoutItem>  
                                              <dx:LayoutItem Caption="Submitted By:" >
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                   </dx:LayoutItem>
                                              <dx:LayoutItem Caption="Submitted Date:" >
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
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
                                              <dx:LayoutItem Caption="Cancelled By:" >
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                              </dx:LayoutItem>
                                              <dx:LayoutItem Caption="Cancelled Date:" >
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTextBox ID="txtHCancelledDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
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
																<dx:GridViewDataTextColumn FieldName="Debit" Name="jDebit" ShowInCustomizationForm="True" VisibleIndex="6" Width ="120px" Caption="Debit  Amount" PropertiesTextEdit-DisplayFormatString="{0:N}">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Credit" Name="jCredit" ShowInCustomizationForm="True" VisibleIndex="7" Width ="120px" Caption="Credit Amount" PropertiesTextEdit-DisplayFormatString="{0:N}">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridView>
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
                                    </dx:LayoutGroup>
                                </Items>
                            </dx:TabbedLayoutGroup>
                            <dx:LayoutGroup Caption="Bank Reconciliation Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" ClientInstanceName="gv1" OnBatchUpdate="gv1_BatchUpdate" OnCellEditorInitialize="gv1_CellEditorInitialize" 
                                                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize" OnInit="gv1_Init"  Width="985px" KeyFieldName="LineNumber" Styles-Header-HorizontalAlign="Center">
                                                        <SettingsBehavior FilterRowMode="OnClick" ColumnResizeMode="Control" />
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick"  />
                                                        <SettingsPager Mode="ShowAllRecords"/><SettingsEditing Mode="Batch" />
                                                        <Settings ColumnMinWidth="50" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="300" VerticalScrollBarMode="Auto" ShowStatusBar="Hidden" />
                                                        <ClientSideEvents Init="OnInitTrans"></ClientSideEvents>
                                                        <Columns>
                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false" VisibleIndex="1" Width="0" Settings-AllowDragDrop="False">
                                                                <HeaderStyle VerticalAlign="Middle" Wrap="True" HorizontalAlign="Center" />
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="True" VisibleIndex="2" Caption="Line Number" ReadOnly="true" Width="55px" Settings-AllowDragDrop="False">
                                                                <HeaderStyle VerticalAlign="Middle" Wrap="True" HorizontalAlign="Center" />
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="TransDocNumber" VisibleIndex="3" Width="100px" Caption="Doc Number" Settings-AllowDragDrop="False">
                                                                <HeaderStyle VerticalAlign="Middle" Wrap="True" HorizontalAlign="Center" />
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="TransLineNumber" Visible="true" VisibleIndex="4" Width="90px" Caption=" Trans LineNumber" Settings-AllowDragDrop="False">
                                                                <HeaderStyle VerticalAlign="Middle" Wrap="True" HorizontalAlign="Center" />
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataDateColumn FieldName="DocDate" Visible="True" VisibleIndex="5" Caption="DocDate" ReadOnly="true" Width="85px" CellStyle-HorizontalAlign="Center" Settings-AllowDragDrop="False">
                                                                <HeaderStyle VerticalAlign="Middle" Wrap="True" HorizontalAlign="Center" />
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataTextColumn Caption="Trans Type" Name="TransType" ShowInCustomizationForm="True" VisibleIndex="6" FieldName="TransType" ReadOnly="true" Width="80px" Settings-AllowDragDrop="False">
                                                                <HeaderStyle VerticalAlign="Middle" Wrap="True" HorizontalAlign="Center" />
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Check Number" Name="CheckNumber" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="CheckNumber" ReadOnly="true" Width="120px" Settings-AllowDragDrop="False">
                                                                <HeaderStyle VerticalAlign="Middle" Wrap="True" HorizontalAlign="Center" />
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataCheckColumn FieldName="IsSelected" Name="IsSelected" ShowInCustomizationForm="True" VisibleIndex="8" ReadOnly="false" Caption="Selected" Width="60px" Settings-AllowDragDrop="False" Settings-AllowAutoFilter="True">
                                                                <PropertiesCheckEdit ClientInstanceName="IsSelected" >
                                                                    <ClientSideEvents CheckedChanged="function(s,e){ gv1.batchEditApi.EndEdit(); autocalculate(); }" />
                                                                </PropertiesCheckEdit>
                                                                <HeaderStyle VerticalAlign="Middle" Wrap="True" HorizontalAlign="Center" />                                                            
                                                            </dx:GridViewDataCheckColumn>
                                                            <dx:GridViewDataDateColumn Caption="Check Date" Name="CheckDate" ShowInCustomizationForm="True" VisibleIndex="9" FieldName="CheckDate" ReadOnly="true" Width="85px" CellStyle-HorizontalAlign="Center" Settings-AllowDragDrop="False">
                                                                <HeaderStyle VerticalAlign="Middle" Wrap="True" HorizontalAlign="Center" />
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataTextColumn Caption="Payee Name" Name="PayeeName" ShowInCustomizationForm="True" VisibleIndex="10" FieldName="PayeeName" ReadOnly="true" Width="250px" Settings-AllowDragDrop="False">
                                                                <HeaderStyle VerticalAlign="Middle" Wrap="True" HorizontalAlign="Center" />
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataSpinEditColumn FieldName="DebitAmount" VisibleIndex="11" Width="100px" Caption="Withdrawal" ReadOnly="false" Settings-AllowDragDrop="False">
                                                                <PropertiesSpinEdit Increment="0" DisplayFormatString="{0:N}"></PropertiesSpinEdit>
                                                                <HeaderStyle VerticalAlign="Middle" Wrap="True" HorizontalAlign="Center" />                                                            
                                                            </dx:GridViewDataSpinEditColumn>
                                                            <dx:GridViewDataSpinEditColumn FieldName="CreditAmount" VisibleIndex="12" Width="100px" Caption="Deposit" ReadOnly="false" Settings-AllowDragDrop="False">
                                                                <PropertiesSpinEdit Increment="0" DisplayFormatString="{0:N}"></PropertiesSpinEdit>
                                                                <HeaderStyle VerticalAlign="Middle" Wrap="True" HorizontalAlign="Center" />                                                            
                                                            </dx:GridViewDataSpinEditColumn>
                                                            <dx:GridViewDataSpinEditColumn FieldName="BankRunningBalance" VisibleIndex="13" Width="100px" Caption="Running Balance" ReadOnly="true" Settings-AllowDragDrop="False">
                                                                <PropertiesSpinEdit Increment="0" DisplayFormatString="{0:N}"></PropertiesSpinEdit>
                                                                <HeaderStyle VerticalAlign="Middle" Wrap="True" HorizontalAlign="Center" />                                                            
                                                            </dx:GridViewDataSpinEditColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field1" Name="Field1" ShowInCustomizationForm="True" Visible="false" VisibleIndex="14" FieldName="Field1" UnboundType="String" ReadOnly="false" Settings-AllowDragDrop="False"></dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field2" Name="Field2" ShowInCustomizationForm="True" Visible="false" VisibleIndex="15" FieldName="Field2" UnboundType="String" ReadOnly="false" Settings-AllowDragDrop="False"></dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field3" Name="Field3" ShowInCustomizationForm="True" Visible="false" VisibleIndex="16" FieldName="Field3" UnboundType="String" ReadOnly="false" Settings-AllowDragDrop="False"></dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field4" Name="Field4" ShowInCustomizationForm="True" Visible="false" VisibleIndex="17" FieldName="Field4" UnboundType="String" ReadOnly="false" Settings-AllowDragDrop="False"></dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field5" Name="Field5" ShowInCustomizationForm="True" Visible="false" VisibleIndex="18" FieldName="Field5" UnboundType="String" ReadOnly="false" Settings-AllowDragDrop="False"></dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field6" Name="Field6" ShowInCustomizationForm="True" Visible="false" VisibleIndex="19" FieldName="Field6" UnboundType="String" ReadOnly="false" Settings-AllowDragDrop="False"></dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field7" Name="Field7" ShowInCustomizationForm="True" Visible="false" VisibleIndex="20" FieldName="Field7" UnboundType="String" ReadOnly="false" Settings-AllowDragDrop="False"></dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field8" Name="Field8" ShowInCustomizationForm="True" Visible="false" VisibleIndex="21" FieldName="Field8" UnboundType="String" ReadOnly="false" Settings-AllowDragDrop="False"></dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field9" Name="Field9" ShowInCustomizationForm="True" Visible="false" VisibleIndex="22" FieldName="Field9" UnboundType="String" ReadOnly="false" Settings-AllowDragDrop="False"></dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Version" Name="Version" ShowInCustomizationForm="True" Visible="false" VisibleIndex="23" FieldName="Version" UnboundType="String" ReadOnly="false" Width="0" Settings-AllowDragDrop="False"></dx:GridViewDataTextColumn>
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
                                <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" 
                                    TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                                <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" 
                                    CssClass="btn" ClientInstanceName="btn" UseSubmitBehavior="false" CausesValidation="true">
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
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
</form>
    <!--#region Region Datasource-->
    <%--<asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.BankReconcilliation">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.BankReconcilliation+BankReconcilliationDetail" SelectMethod="getdetail" UpdateMethod="UpdateBankReconcilliationDetail" TypeName="Entity.BankReconcilliation+BankReconcilliationDetail" DeleteMethod="DeleteBankReconcilliationDetaill" InsertMethod="AddBankReconcilliationDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.BankReconcilliation+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.BankReconcilliation+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Accounting.BankReconciliationDetail where DocNumber is null"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsGenerateBankRecon" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBankAccount" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BankAccountCode FROM Masterfile.BankAccount WHERE ISNULL([IsInactive],0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    --%>
    <form id="form2" runat="server" visible="false">
            <!--#region Region Datasource-->
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.BankReconcilliation">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <%--Purchase Order ADD / UPDATE / EDIT Methods--%>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.BankReconcilliation+BankReconcilliationDetail" SelectMethod="getdetail" UpdateMethod="UpdateBankReconcilliationDetail" TypeName="Entity.BankReconcilliation+BankReconcilliationDetail" DeleteMethod="DeleteBankReconcilliationDetaill" InsertMethod="AddBankReconcilliationDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.BankReconcilliation+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.BankReconcilliation+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Accounting.BankReconciliationDetail where DocNumber is null"
       >
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsGenerateBankRecon" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBankAccount" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BankAccountCode FROM Masterfile.BankAccount WHERE ISNULL([IsInactive],0) = 0"></asp:SqlDataSource>
    </form>
</body>
</html>


