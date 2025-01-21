<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmPurchaseRequest.aspx.cs" Inherits="GWL.frmPurchaseRequest" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>

    <title>Purchase Request</title>

    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
    <%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script>
    <%--NEWADD--%>

    <!--#region Region Javascript-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 580px; /*Change this whenever needed*/
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
    <script>
        var isValid = true;
        var counterror = 0;

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        //       function getParameterByName(name) {
        //    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        //    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        //        results = regex.exec(location.search);
        //    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        //}

        var module = getParameterByName("transtype");
        var id = getParameterByName("docnumber");
        var entry = getParameterByName("entry");
        var useparam = getParameterByName("parameters");

        $(document).ready(function () {
            //emc999
            console.log("REQUEST TYPE : " + useparam);

            switch (useparam) {
                case "PR":
                    document.title = "Purchase Request";
                    break;
                case "SP":
                    document.title = "Spice Request";
                    break;
                case "SC":
                    document.title = "Scrap Request";
                    break;
                case "RM":
                    document.title = "Raw Material Request";
                    break;
            }


            autocalculate();



            PerfStart(module, entry, id);

        });

        function OnValidation(s, e) { //Validation function for header controls (Set this for each header controls)
            // var DocDate = CINDocDate.GetText();
            // var TargetDate = CINTargetDate.GetText();
            // console.log(DocDate + ' DOcDate')

            // console.log(TargetDate + ' TargetDate')
            // if (TargetDate < DocDate)
            // {
            //     console.log('TargetDate < DocDate');
            //     e.isValid = false;
            // }

            if (s.GetText() == "" || e.value == "" || e.value == null) {

                counterror++;
                isValid = false
            }
            else {
                isValid = true;
            }
        }

        //emc888
        function autocalculate(s, e) {
            var retqty = 0.00;
            var totretqty = 0.00;

            //console.log("TotQty: " + totretqty);

            // console.log("TotQty: " );

            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        retqty = gv1.batchEditApi.GetCellValue(indicies[i], "RequestQty");
                        totretqty += retqty;


                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            retqty = gv1.batchEditApi.GetCellValue(indicies[i], "RequestQty");
                            totretqty += retqty;
                        }
                    }
                }

                //txtTotalQty.SetText(totretqty.format(4, 5, ',', '.'));
                txtTotalQty.SetText("" + totretqty);
                console.log("TotQty: " + totretqty);
            }, 500);
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

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            //if (s.cp_success) {
            //    if (s.cp_valmsg != null || s.cp_valmsg != '') {
            //        alert(s.cp_valmsg);
            //    }
            //    if(s.cp_message != null) {
            //        alert(s.cp_message);
            //    }
            //    delete (s.cp_valmsg);
            //    delete (s.cp_success);//deletes cache variables' data
            //    delete (s.cp_message);
            //}


            if (s.cp_close) {
                if (s.cp_valmsg) {
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
                    console.log('aw');
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
        var valchange = false;
        var itemc; //variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var curr;

        var customerload;
        var itemcodeload;
        var unitc;
        var unitc2;
        function OnStartEditing(s, e) {//On start edit grid function     


            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
            unitc = s.batchEditApi.GetCellValue(e.visibleIndex, "UnitBase");
            unitc2 = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
            //if (e.visibleIndex < 0) {//new row
            //    var linenumber = s.GetColumnByField("LineNumber");
            //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
            //}
            curr = e;
            index = e.visibleIndex;
            if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsAllowPartial") === null) {
                s.batchEditApi.SetCellValue(e.visibleIndex, "IsAllowPartial", true)
            }

            var entry = getParameterByName('entry');


            if (entry == "V" || entry == "D") {
                e.cancel = true; //this will made the gridview readonly
            }

            if (entry != "V") {

                //2021-07-19    EMC
                if (e.focusedColumn.fieldName === "OrderQty") {
                    e.cancel = true; //this will made the gridview readonly
                }



                if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                    closing = true;
                }
                if (e.focusedColumn.fieldName === "ColorCode") {
                    gl2.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "ClassCode") {
                    gl3.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "SizeCode") {
                    gl4.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "UnitBase") {
                    isSetTextRequired = true;
                    gl5.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "ServiceType") {
                    glService.GetInputElement().value = cellInfo.value;
                }

                if (e.focusedColumn.fieldName === "Unit") {
                    isSetTextRequired = true;
                    glUnit.GetInputElement().value = cellInfo.value;
                }

                if (e.focusedColumn.fieldName === "Field3") {
                    //isSetTextRequired = true;
                    gl30.GetInputElement().value = cellInfo.value;

                }

            }


        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            //emc888
            autocalculate();

            var cellInfo = e.rowValues[currentColumn.index];
            if (currentColumn.fieldName === "ItemCode") {
                cellInfo.value = gl.GetValue();
                cellInfo.text = gl.GetText();
                valchange = true;
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
            if (currentColumn.fieldName === "UnitBase") {
                cellInfo.value = gl5.GetValue();
                cellInfo.text = gl5.GetText();

            }
            if (currentColumn.fieldName === "Unit") {
                cellInfo.value = glUnit.GetValue();
                cellInfo.text = glUnit.GetText();

            }
            if (currentColumn.fieldName === "ServiceType") {
                cellInfo.value = glService.GetValue();
                cellInfo.text = glService.GetText();
            }

            if (currentColumn.fieldName === "Field3") {
                cellInfo.value = gl30.GetValue();
                cellInfo.text = gl30.GetText();
            }
        }



        var identifier;
        var val_ALL;
        function GridEndChoice(s, e) {

            identifier = s.GetGridView().cp_identifier;
            val_ALL = s.GetGridView().cp_codes;

            console.log(identifier)
            console.log(val_ALL + " ito sila!")
            if (identifier == "ItemCode") {
                delete (s.GetGridView().cp_identifier);
                if (s.GetGridView().cp_valch) {
                    delete (s.GetGridView().cp_valch);
                    for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                        //console.log('anoto')
                        var column = gv1.GetColumn(i);
                        if (column.visible == false || column.fieldName == undefined)
                            continue;
                        ProcessCells_ItemCode(0, e.visibleIndex, column, gv1);
                    }
                }
                gv1.batchEditApi.EndEdit();
            }
        }


        function ProcessCells_ItemCode(selectedIndex, e, column, s) {
            var temp_ALL;
            if (temp_ALL == null) {
                temp_ALL = ";;;;;";
            }
            temp_ALL = val_ALL.split(';');
            if (temp_ALL[0] == null) {
                temp_ALL[0] = "";
            }
            if (temp_ALL[1] == null) {
                temp_ALL[1] = "";
            }
            if (temp_ALL[2] == null) {
                temp_ALL[2] = "";
            }
            if (temp_ALL[3] == null) {
                temp_ALL[3] = "";
            }
            if (temp_ALL[4] == null) {
                temp_ALL[4] = "";
            }
            if (selectedIndex == 0) {
                if (column.fieldName == "ColorCode") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[0]);
                }
                if (column.fieldName == "ClassCode") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[1]);
                }
                if (column.fieldName == "SizeCode") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[2]);
                }
                if (column.fieldName == "UnitBase") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[3]);
                }
                if (column.fieldName == "FullDesc") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[4]);
                }
            }
            loader.Hide();
        }

        // Unit valuechanged event
        function UpdateUnit(values) {
            gv1.batchEditApi.EndEdit();
            gv1.batchEditApi.SetCellValue(index, "UnitBase", values);
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
                //gv1.batchEditApi.EndEdit();
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            gv1.batchEditApi.EndEdit();
            gvService.batchEditApi.EndEdit();
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
                var BizPartnerCode = clBizPartnerCode.GetText();
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                    + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&Warehouse=' + Warehouse);

                factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);


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

        function negativecheck(s, e) {
            var requestqty = CINRequestQty.GetValue();
            requestqty = requestqty <= 0 ? 0 : requestqty;

            CINRequestQty.SetText('' + requestqty);

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
            gvService.SetWidth(width - 120);
        }


        function GetJODetails(s, e) {
            var generate = confirm("Generate multiple item using selected Job Order Number?");
            if (generate) {
                CINJODetails.Show();
                CINgvJODetails.CancelEdit();
                cp.PerformCallback('GetJODetails');
                e.processOnServer = false;
            }
            //CINMultiplePR.SetEnabled(true);
        }

        function POPUPGetJODetail(s, e) {
            var generate = confirm("Generate multiple item using selected Job Order Number?");
            if (generate) {
                CINJODetails.Hide();
                var str = CINgvJODetails.GetSelectedKeysOnPage();
                console.log(str);
                //for(var i = 0; i < str.length; i++)
                //{
                //    var str2 = str[i].split("|");
                //    gv1.AddNewRow();
                //    getCol(gv1, curr, str2);
                //}
                if (str != null) {
                    for (var i = 0; i < str.length; i++) {
                        var str2 = str[i].split("|");
                        console.log(str.length);
                        gv1.AddNewRow();
                        getCol(gv1, curr, str2);
                    }
                }
            }
            //CINMultiplePR.SetEnabled(true);
        }

        function getCol(ss, ee, item) {
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = gv1.GetColumn(i);
                if (column.visible == false || column.fieldName == undefined)
                    continue;
                Bindgrid(item, ee, column, gv1);
            }
        }

        function Bindgrid(item, e, column, s) {//Clone function :D
            if (column.fieldName == "ItemCode") {
                console.log(item[1] + 'pasok');
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[1]);
            }
            if (column.fieldName == "ColorCode") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[2]);
            }
            if (column.fieldName == "ClassCode") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[3]);
            }
            if (column.fieldName == "SizeCode") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[4]);
            }
            if (column.fieldName == "RequestQty") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, Math.abs(item[5]));
            }
            if (column.fieldName == "UnitBase") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[6]);
            }
        }


        var gl_objName = "";
        var gl_sdsName = "";
        var gl_sqlcmd = "";
        function gridLookup_Data() {
            //emclookup
            var gridLookupName = gl_objName;
            var ListName2 = hgridlookup.GetText();
            if (ListName2.indexOf(gridLookupName) === -1) {

                hgridlookup.SetText("" + ListName2 + gridLookupName + ",");

                cp.PerformCallback('sds|' + gl_sdsName + "|" + gl_sqlcmd + "|" + gl_objName);

                //console.log(" get data " + ListName2 + "," + gl_sdsName + " " + gl_sdsName + " > " + gl_sqlcmd);

            }

            //console.log('sds|' + gl_sdsName + "|" + gl_sqlcmd + "|" + gl_objName);

        }

        function PutDesc(selectedValues) {
            gvService.batchEditApi.EndEdit();
            gvService.batchEditApi.SetCellValue(index, "Description", selectedValues[1]);
            gvService.batchEditApi.SetCellValue(index, "IsAllowProgressBilling", selectedValues[2]);
        }

        var transtype = getParameterByName('transtype');
        function onload() {
            setTimeout(function () {
                var BizPartnerCode = clBizPartnerCode.GetText();
                factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
                fbnotes.SetContentUrl('../FactBox/fbNotes.aspx?docnumber=' + txtDocnumber.GetText() + '&transtype=' + transtype);
            }, 500);
        }

    </script>
    <!--#endregion-->
</head>
<body style="height: 910px" onload="onload()">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" ID="FormTitle" Text="Purchase Request" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
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
        <dx:ASPxPopupControl ID="notes" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="fbnotes" CloseAction="None"
            EnableViewState="False" HeaderText="Notes" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="470"
            ShowCloseButton="False" Collapsed="true" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ID="popup2" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox2" CloseAction="None"
            EnableViewState="False" HeaderText="BizPartner info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="260"
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
                    <dx:ASPxPopupControl ID="JODetails" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CINJODetails" CloseAction="CloseButton" CloseOnEscape="true"
                        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="400px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                        ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">

                        <HeaderImage Height="10px"></HeaderImage>

                        <ContentStyle HorizontalAlign="Center"></ContentStyle>

                        <ContentCollection>
                            <dx:PopupControlContentControl runat="server">
                                <dx:ASPxGridView ID="gvJODetails" runat="server" AutoGenerateColumns="False" Width="900px" OnInit="gvJODetails_Init"
                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="CINgvJODetails"
                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" OnCustomButtonInitialize="gv1_CustomButtonInitialize">
                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm"
                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                    <SettingsPager Mode="ShowAllRecords" />
                                    <SettingsEditing Mode="Batch" />
                                    <Settings VerticalScrollableHeight="250" VerticalScrollBarMode="Auto" ShowStatusBar="Hidden" />
                                    <SettingsBehavior AllowSelectSingleRowOnly="false" />

                                    <Columns>
                                        <dx:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" ButtonType="Image" Width="50px" SelectAllCheckboxMode="Page">
                                        </dx:GridViewCommandColumn>
                                        <dx:GridViewDataTextColumn Caption="LineNumber" FieldName="LineNumber" Name="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="0px">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Item" FieldName="ItemCode" Name="ItemCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="200">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Color" FieldName="ColorCode" Name="ColorCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3" Width="150">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Class" FieldName="ClassCode" Name="ClassCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4" Width="150">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Size" FieldName="SizeCode" Name="SizeCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5" Width="150">
                                        </dx:GridViewDataTextColumn>

                                        <%-- <dx:GridViewDataSpinEditColumn Caption="RequestQty" FieldName="RequestQty" Name="RequestQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6" PropertiesSpinEdit-DisplayFormatString="{0:#,0.0000;(#,0.0000);}" PropertiesSpinEdit-AllowMouseWheel="False">
                                            <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="False">
                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                            </PropertiesSpinEdit>
                                        </dx:GridViewDataSpinEditColumn>--%>

                                        <dx:GridViewDataSpinEditColumn FieldName="RequestQty" Name="RequestQty" ShowInCustomizationForm="True" VisibleIndex="9" Caption="RequestQty" UnboundType="Decimal">
                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false" Width="100px" MaxValue="2147483647">
                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                <ClientSideEvents ValueChanged="autocalculate"></ClientSideEvents>
                                            </PropertiesSpinEdit>
                                        </dx:GridViewDataSpinEditColumn>


                                        <dx:GridViewDataTextColumn Caption="UnitBase" FieldName="UnitBase" Name="UnitBase" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7" Width="0">
                                        </dx:GridViewDataTextColumn>
                                    </Columns>
                                </dx:ASPxGridView>
                                <dx:ASPxButton ID="btn" ClientInstanceName="POPUPGetJODetailbtn" runat="server" Width="170px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" OnLoad="ButtonLoad" ClientVisible="true" Text="Get JO Details" Theme="MetropolisBlue">
                                    <ClientSideEvents Click="POPUPGetJODetail" />
                                </dx:ASPxButton>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>


                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" Style="margin-left: -3px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>

                            <%--<!--#region Region Header --> --%>
                            <%-- <!--#endregion --> --%>

                            <%--<!--#region Region Details --> --%>

                            <%-- <!--#endregion --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>

                                            <dx:LayoutGroup Caption="Information" ColCount="2" RowSpan="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Document Number" Name="DocNumber">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocnumber" runat="server" ClientInstanceName="txtDocnumber" ReadOnly="true" Width="170px">
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
                                                    <dx:LayoutItem Caption="Document Date" Name="DocDate" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtDocDate" runat="server" ClientInstanceName="CINDocDate" Width="170px">
                                                                    <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('docdate');  e.processOnServer = false; }" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Year" Name="Year">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtYear" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="WorkWeek" Name="WorkWeek">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtWorkWeek" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Day No" Name="DayNo">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDayNo" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Req Dept. Company:" Name="ReqDeptComp">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtReqDept2" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                <%--    <dx:LayoutItem Caption="Req Dept. Company" Name="ReqDeptComp">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtReqDept2" ClientInstanceName="txtReqDept2" runat="server" 
                                                                    OnInit="lookup_Init"
                                                                    DataSourceID="sdsDept" KeyFieldName="DepartmentCode" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>

                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DepartmentCode" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="DepartmentName" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>--%>

<%--                                                                    <ClientSideEvents 
                                                                           DropDown="function(){ 
                                                                               
                                                                              gl_objName = 'txtReqDept2';
                                                                              gl_sdsName = 'sdsDept';
                                                                              gl_sqlcmd = 'SELECT DepartmentCode, DepartmentName FROM Masterfile.Department';
                                                                             
                                                                              gridLookup_Data();

                                                                              }"
                                                                        
                                                                        /> --%>
                                                        <%--        </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>


                                                    <dx:LayoutItem Caption="Warehouse Code" Name="WH">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglWarehouseCode" ClientInstanceName="aglWarehouseCode" runat="server" 
                                                                    OnInit="lookup_Init" OnValueChanged="glWarehouseCodeValueChange"
                                                                    DataSourceID="sdsWarehouse" KeyFieldName="WarehouseCode" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>

                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="WarehouseCode" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>

                                                                   <%-- <ClientSideEvents 
                                                                           DropDown="function(){ 
                                                                               
                                                                              gl_objName = 'aglWarehouseCode';
                                                                              gl_sdsName = 'sdsWarehouse';
                                                                              gl_sqlcmd = 'SELECT WarehouseCode, [Description] FROM Masterfile.[Warehouse] WHERE ISNULL([IsInactive],0) = 0';
                                                                             
                                                                              gridLookup_Data();

                                                                              }"
                                                                        
                                                                        />--%>

                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Customer" Name="CustomerCode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="clBizPartnerCode" runat="server" ClientInstanceName="clBizPartnerCode" 
                                                                    OnInit="lookup_Init"
                                                                    DataSourceID="CustomerCodelookup" KeyFieldName="BizPartnerCode" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <%--<ClientSideEvents Validation="OnValidation"
                                                                           DropDown="function(){ 
                                                                               
                                                                              gl_objName = 'clBizPartnerCode';
                                                                              gl_sdsName = 'CustomerCodelookup';
                                                                              gl_sqlcmd = 'SELECT BizPartnerCode,Name FROM Masterfile.[BPCustomerInfo] WHERE ISNULL([IsInactive],0) = 0 Order By BizPartnerCode';
                                                                             
                                                                              gridLookup_Data();

                                                                              }"
                                                                        
                                                                        />--%>

                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>

                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Consignee" Name="Consignee">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtConsignee" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Consignee Address " Name="ConsigneeAddress">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtConsigneeaddress" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <%--                           <dx:LayoutItem Caption="Required Loading Time:" Name="RequiredLoadingTime">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtReqloadtime" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>


                                                    <dx:LayoutItem Caption="Required Loading Time" Name="RequiredLoadingTime">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="txtReqloadtime" runat="server" Width="170px" EditFormat="DateTime">
                                                                </dx:ASPxDateEdit>

                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>



                                                    <dx:LayoutItem Caption="Type of Shipment:" Name="TypeofShipment">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtTypeshipment" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Target Delivery Date" Name="TargetDate">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtTargetDate" runat="server" ClientInstanceName="CINTargetDate" Width="170px">
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
                                                    <dx:LayoutItem Caption="Stock Number" Name="StockNumber" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="ASPxGridLookup1" runat="server" ClientInstanceName="CINStockNumber" DataSourceID="StockNumberLookup"
                                                                    KeyFieldName="ItemCode" TextFormatString="{0}" Width="170px" OnInit="glStockNumber_Init">
                                                                    <ClientSideEvents DropDown="function(){CINStockNumber.GetGridView().PerformCallback();}" />
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ShortDesc" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Cost Center" Name="CostCenter" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glCostCenter" runat="server" DataSourceID="CostCenterlookup" KeyFieldName="CostCenterCode" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="CostCenterCode" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>



                                                    <dx:LayoutItem Caption="OCN Request No.: " Name="OCNReqNo">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtOCNreq" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                    <dx:LayoutItem Caption="Scrap Reference" Name="HScrapRef">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="HScrapRef" runat="server"
                                                                    DataSourceID="Masterfileitem" KeyFieldName="ItemCode" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                    <dx:LayoutItem Caption="PO DocNumber" Name="PODocNumber" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtPODocNumber" runat="server" ReadOnly="True" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Allow Partial" Name="IsPartial">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkIsPartial" runat="server" CheckState="Unchecked">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Status" Name="Status">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtStatus" runat="server" ReadOnly="True" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Printed" Name="IsPrinted">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkIsPrinted" runat="server" CheckState="Unchecked" ReadOnly="True">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Total Qty">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtTotalQty" runat="server" Width="170px" ReadOnly="true" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" ClientInstanceName="txtTotalQty">
                                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                    <dx:LayoutItem Caption="Remarks" Name="Remarks">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memoRemarks" runat="server" Width="170px" Height="71px">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="GridLookup"  ClientVisible="false" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="hgridlookup" ClientInstanceName="hgridlookup" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Stock Number" Name="StockNumber" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glStockNumber" runat="server" ClientInstanceName="CINStockNumber" DataSourceID="StockNumberLookup"
                                                                    KeyFieldName="ItemCode" TextFormatString="{0}" Width="170px" OnInit="glStockNumber_Init">
                                                                    <ClientSideEvents DropDown="function(){CINStockNumber.GetGridView().PerformCallback();}" />
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ShortDesc" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                </Items>
                                            </dx:LayoutGroup>

                                            <dx:LayoutGroup Caption="Job Order" ColCount="2" ClientVisible="false">
                                                <Items>
                                                    <dx:LayoutItem Caption="JO Number:">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glJONumber" runat="server" Width="170px" DataSourceID="JobOrderNumberLookup" AutoGenerateColumns="False" KeyFieldName="DocNumber" SelectionMode="Multiple" TextFormatString="{0}"
                                                                    ClientInstanceName="CINJONumber" OnInit="glJONumber_Init">
                                                                    <ClientSideEvents DropDown="function(){CINJONumber.GetGridView().PerformCallback();}" />
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                        <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="10%">
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="JO Number" FieldName="DocNumber" ShowInCustomizationForm="True" VisibleIndex="1" Width="90%"
                                                                            Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="" Name="GetJODetailsbtn">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxButton ID="GetJODetailsbtn" ClientInstanceName="CINGetJODetailsbtn" runat="server" Width="170px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" OnLoad="ButtonLoad" ClientVisible="true" Text="Get JO Details" Theme="MetropolisBlue">
                                                                    <ClientSideEvents Click="GetJODetails" />
                                                                </dx:ASPxButton>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field 1:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 2:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 3:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 4:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 5:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 6:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 7:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 8:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 9:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Name="Audit" Caption="Audit Trail" ColSpan="2" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Added By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Added Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtApprovedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtApprovedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Manual Closed By:" Name="closeby">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtForceClosedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Manual Closed Date:" Name="closedate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtForceClosedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction" ClientVisible="false">
                                        <Items>
                                            <dx:LayoutGroup Caption="Reference Detail">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Width="860px" ClientInstanceName="gvRef" OnCommandButtonInitialize="gv_CommandButtonInitialize" SettingsBehavior-AllowSort="False">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" Init="OnInitTrans" />

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
                            <dx:LayoutGroup Caption="Purchase Request Detail" Name="PRdetail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="770px"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="gv1" OnInitNewRow="gv1_InitNewRow"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber" SettingsBehavior-AllowSort="False"
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
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="true" Width="0px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="LineNumber" FieldName="LineNumber" Name="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="0px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="2" Width="150px" Name="glItemCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="glItemCode_Init"
                                                                    DataSourceID="Masterfileitem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="150px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                        EndCallback="GridEndChoice" />

                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" VisibleIndex="2" Width="300px" Caption="Item Description">
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="3" Width="100px" Caption="ColorCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    KeyFieldName="ColorCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="100px" OnInit="lookup_Init">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEndChoice" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        e.processOnServer = false;
                                                                        }"
                                                                        CloseUp="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" VisibleIndex="4" Width="100px" Name="glClassCode" Caption="ClassCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                    KeyFieldName="ClassCode" ClientInstanceName="gl3" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl3.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        }"
                                                                        CloseUp="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" VisibleIndex="5" Width="100px" Name="glSizeCode" Caption="SizeCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                    KeyFieldName="SizeCode" ClientInstanceName="gl4" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        }"
                                                                        CloseUp="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataSpinEditColumn FieldName="RequestQty" VisibleIndex="6" Width="100px" Caption="RequestQty">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="CINRequestQty" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents NumberChanged="negativecheck" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>


                                                        <%--<dx:GridViewDataTextColumn FieldName="UnitBase" VisibleIndex="7" Width="100px" Caption="Unit">   
                                                              <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                    KeyFieldName="UnitBase" ClientInstanceName="gl5" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"  />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitBase" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains"  >
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl5.GetGridView().PerformCallback('UnitBase' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        e.processOnServer = false;
                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>--%>

                                                        <dx:GridViewDataTextColumn FieldName="UnitBase" VisibleIndex="7" Width="100px" Caption="Unit">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    KeyFieldName="UnitCode" DataSourceID="UnitLookup" ClientInstanceName="gl5" TextFormatString="{0}" Width="100px"  OnInit="lookup_Init">
                                                                    <GridViewProperties Settings-ShowFilterRow="true"  >
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
<%--                                                                    <ClientSideEvents DropDown="lookup" />
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" ValueChanged="function(s,e){
                                                                        console.log(unitc, s.GetValue())
                                                                        if(unitc != s.GetValue())
                                                                        gv1.batchEditApi.EndEdit();
                                                                        }" />--%>
                                                                   <ClientSideEvents CloseUp="gridLookup_CloseUp" Dropdown="function dropdown(s, e){
                                                                      
                                                                            gl5.GetGridView().PerformCallback('UnitCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                            }"  KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"
                                                                        
                                                                        ValueChanged="function(s,e){ 
                                                                                                    var g = gl5.GetGridView();
                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'UnitCode', UpdateUnit)}" />


                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataSpinEditColumn FieldName="OrderQty" Name="OrderQty" VisibleIndex="8" Width="100px" Caption="OrderQty" ReadOnly="true">
                                                            <PropertiesSpinEdit Increment="0" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>

                                                        <dx:GridViewDataCheckColumn FieldName="IsAllowPartial" Name="IsAllowPartial" Caption="Partial Delivery" ShowInCustomizationForm="True" VisibleIndex="9">
                                                            <PropertiesCheckEdit ClientInstanceName="chkIsAllowPartial"></PropertiesCheckEdit>
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" ShowInCustomizationForm="True" VisibleIndex="10">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" ShowInCustomizationForm="True" VisibleIndex="11">
                                                        </dx:GridViewDataTextColumn>

                                                        <%--                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" ShowInCustomizationForm="True" VisibleIndex="12">
                                                        </dx:GridViewDataTextColumn>--%>

                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" VisibleIndex="12" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glpDField3" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    KeyFieldName="StepCode" DataSourceID="sdsStep" ClientInstanceName="gl30" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="StepCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="lookup" />
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" ValueChanged="function(s,e){
                                                                        console.log(unitc, s.GetValue())
                                                                        if(unitc != s.GetValue())
                                                                        gv1.batchEditApi.EndEdit();
                                                                        }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" ShowInCustomizationForm="True" VisibleIndex="13">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataDateColumn FieldName="ManuDate" Name="d1manudate" Caption="Manu Date" ShowInCustomizationForm="True" VisibleIndex="13" Width="100px" PropertiesDateEdit-AllowNull="true">
                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" ClientInstanceName="d1manudate">
                                                            </PropertiesDateEdit>
                                                        </dx:GridViewDataDateColumn>

                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" ShowInCustomizationForm="True" VisibleIndex="14">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" ShowInCustomizationForm="True" VisibleIndex="15">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" ShowInCustomizationForm="True" VisibleIndex="16">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" VisibleIndex="17">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" VisibleIndex="18">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="60px">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                    <Image IconID="support_info_16x16"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                    </Columns>
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>

                            <dx:LayoutGroup Caption="Purchase Request Service Detail" ClientVisible="false">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gvService" runat="server" AutoGenerateColumns="False" Width="770px" OnInitNewRow="gvService_InitNewRow"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="gvService"
                                                    OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber" SettingsBehavior-AllowSort="False"
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
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="true" Width="0px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Service" FieldName="ServiceType" VisibleIndex="2" Width="150px" Name="glItemCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glService" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="ServiceLookup" KeyFieldName="ServiceCode" ClientInstanceName="glService" TextFormatString="{0}" Width="150px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ServiceCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="IsAllowBilling" ReadOnly="True" VisibleIndex="2" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                        ValueChanged="function(){
                                                                                 var grid = glService.GetGridView();
                                                                                grid.GetRowValues(grid.GetFocusedRowIndex(), 'ServiceCode;Description;IsAllowBilling', PutDesc);
                                                                                }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="Qty" VisibleIndex="3" Width="100px" Caption="RequestQty">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="Qty" MinValue="0.99999" MaxValue="999999999" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents NumberChanged="negativecheck" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Unit" VisibleIndex="4" Width="100px" Caption="Unit">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    KeyFieldName="UnitCode" DataSourceID="UnitLookup" ClientInstanceName="glUnit" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="lookup" />
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        ValueChanged="function(s,e){
                                                                        if(unitc2 != s.GetValue())
                                                                        gvService.batchEditApi.EndEdit();
                                                                        }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="IsAllowProgressBilling" Caption="Progress Billing" ShowInCustomizationForm="True" VisibleIndex="5">
                                                            <PropertiesCheckEdit ClientInstanceName="chkIsAllowProgress">
                                                                <ClientSideEvents CheckedChanged="function(){gvService.batchEditApi.EndEdit()}" />
                                                            </PropertiesCheckEdit>
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="ServicePOQty" VisibleIndex="6" Width="100px" Caption="ServicePOQty" ReadOnly="true">
                                                            <PropertiesSpinEdit Increment="0" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" ShowInCustomizationForm="True" VisibleIndex="10">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" ShowInCustomizationForm="True" VisibleIndex="11">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" ShowInCustomizationForm="True" VisibleIndex="12">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" ShowInCustomizationForm="True" VisibleIndex="13">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" ShowInCustomizationForm="True" VisibleIndex="14">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" ShowInCustomizationForm="True" VisibleIndex="15">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" ShowInCustomizationForm="True" VisibleIndex="16">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" VisibleIndex="17">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" VisibleIndex="18">
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

                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
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

        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Calculating..."
            ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
            <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>

        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel2" runat="server" Text="loading..."
            ClientInstanceName="loader2" ContainerElementID="gv1" Modal="true">
            <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
    </form>

    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.PurchaseRequest" DataObjectTypeName="Entity.PurchaseRequest" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.PurchaseRequest+PurchaseRequestDetail" DataObjectTypeName="Entity.PurchaseRequest+PurchaseRequestDetail" DeleteMethod="DeletePurchaseRequestDetail" InsertMethod="AddPurchaseRequestDetail" UpdateMethod="UpdatePurchaseRequestDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail2" runat="server" SelectMethod="getdetail" TypeName="Entity.PurchaseRequest+PurchaseRequestService" DataObjectTypeName="Entity.PurchaseRequest+PurchaseRequestService" DeleteMethod="DeletePurchaseRequestDetail" InsertMethod="AddPurchaseRequestDetail" UpdateMethod="UpdatePurchaseRequestDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.PurchaseRequest+RefTransaction">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Procurement.PurchaseRequestDetail where DocNumber  is null "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsDetail2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Procurement.PurchaseRequestService where DocNumber  is null "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>
    <%--<asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT B.ItemCode, ColorCode, ClassCode,SizeCode,UnitBase FROM Masterfile.[Item] A INNER JOIN Masterfile.[ItemDetail] B ON A.ItemCode = B.ItemCode where isnull(A.IsInactive,'')=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>--%>
    <%------------SQL DataSource------------%>

    <%--Customer Code Look Up--%>
    <asp:SqlDataSource ID="CustomerCodelookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" SELECT BizPartnerCode,Name FROM Masterfile.[BPCustomerInfo] WHERE ISNULL([IsInactive],0) = 0 Order By BizPartnerCode "
        OnInit="Connection_Init"></asp:SqlDataSource>
    <%--Cost Center Look Up--%>
    <asp:SqlDataSource ID="CostCenterlookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT CostCenterCode,Description FROM Accounting.[CostCenter] WHERE ISNULL([IsInactive],0) = 0"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <%--Job Order Look Up--%>
    <asp:SqlDataSource ID="JobOrderNumberLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>

    <%--Job Order Details Datasource--%>
    <asp:SqlDataSource ID="JODetailsds" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Production.JOBillOfMaterial where DocNumber is null"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <%-- Stock Number Lookup Datasource--%>
    <asp:SqlDataSource ID="StockNumberLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="ServiceLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select ServiceCode,Description,Type,IsVatable,IsAllowBilling from Masterfile.Service where ISNULL(IsInactive, 0)=0
        and Type = 'EXPENSE' and isnull(IsCore,0)=0"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="UnitLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT UnitCode,Description FROM Masterfile.Unit where isnull(IsInactive,0)=0"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" SELECT WarehouseCode, [Description] FROM Masterfile.[Warehouse] WHERE ISNULL([IsInactive],0) = 0  " OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsStep" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT StepCode FROM Masterfile.Step WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsDept" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" SELECT DepartmentCode, DepartmentName FROM Masterfile.Department WHERE ISNULL(IsInactive,0) = 0 " OnInit="Connection_Init"></asp:SqlDataSource>


</body>
</html>
