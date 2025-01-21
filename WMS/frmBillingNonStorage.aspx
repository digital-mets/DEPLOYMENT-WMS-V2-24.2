<%@ page language="C#" autoeventwireup="true" codebehind="frmBillingNonStorage.aspx.cs" inherits="GWL.frmBillingNonStorage" %>

<%@ register assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Data.Linq" tagprefix="dx" %>

<%@ register assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>
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
            height: 700px; /*Change this whenever needed*/
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

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            if (s.cp_success) {
                alert(s.cp_valmsg);
                alert(s.cp_message);
                delete (s.cp_valmsg);
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
                delete (s.cp_delete);
                DeleteControl.Show();
            }
            if (s.cp_generated) {
                delete (s.cp_generated);
                console.log('autocalculate');
                autocalculate();
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

            if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                gl.GetInputElement().value = cellInfo.value; //Gets the column value
                isSetTextRequired = true;
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
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            if (currentColumn.fieldName === "ItemCode") {
                cellInfo.value = gl.GetValue();
                cellInfo.text = gl.GetText();
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
        }
        function ComboboxChanged(s, e) {
            var Type = gvServiceType.GetText();
            console.log(Type);

            if (Type == "ELECTRICITY") {
                console.log('test');

                // gvBizPartnerCode.SetValue(null);
                //  gvWarehouse.SetValue(null);
                gvProfit.SetValue(null);
                txtContractNumber.SetValue(null);
                txtBillingPeriodType.SetValue(null);
            }
            else {
                //  gvBizPartnerCode.SetValue(null);
                //  gvWarehouse.SetValue(null);
                gvProfit.SetValue(null);
                txtContractNumber.SetValue(null);
                txtBillingPeriodType.SetValue(null);
            }
        }

        function autocalculate(s, e) {
            //console.log(txtNewUnitCost.GetValue());
            OnInitTrans();
            var field6 = 0;
            var field7 = 0;
            var totalamount = 0;
            var totalvat = 0;

            setTimeout(function () {
                for (var i = 0; i < gv1.GetVisibleRowsOnPage(); i++) {
                    field6 = gv1.batchEditApi.GetCellValue(i, "Field6");
                    field7 = gv1.batchEditApi.GetCellValue(i, "Field7");
                    //qty = gv1.batchEditApi.GetCellValue(i, "Qty");
                    totalamount += field7;
                    totalvat += field6;


                }
                txtTotalAmount.SetText(totalamount);
                txtTotalVat.SetText(totalvat);

            }, 500);
        }

        function lookup(s, e) {
            if (isSetTextRequired) {//Sets the text during lookup for item code
                s.SetText(s.GetInputElement().value);
                isSetTextRequired = false;
            }
        }
        function OnCustomClick(s, e) {
            //if (e.buttonID == "Details") {
            //    var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
            //    var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
            //    var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
            //    var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
            //    factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
            //    + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode);
            //}
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
            for (var i = 0; i < gv1.GetColumnsCount(); i++) {
                var column = s.GetColumn(i);
                if (column != s.GetColumn(6) && column != s.GetColumn(1) && column != s.GetColumn(7) && column != s.GetColumn(5) && column != s.GetColumn(8) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23) && column != s.GetColumn(24) && column != s.GetColumn(13)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
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
        function Generate(s, e) {
            var generate = confirm("Are you sure that you want to generate this transactions?");
            if (generate) {
                cp.PerformCallback('Generate');
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
            gvJournal.SetWidth(width - 120);
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
    <dx:aspxglobalevents id="ge" runat="server">
        <clientsideevents controlsinitialized="OnControlsInitialized" />
    </dx:aspxglobalevents>
    <form id="form1" runat="server" class="Entry">
        <dx:aspxpanel id="toppanel" runat="server" fixedpositionoverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" height="30px">
            <panelcollection>
                <dx:panelcontent runat="server" supportsdisabledattribute="True">
                    <dx:aspxlabel runat="server" text="Billing Non Storage" font-bold="true" forecolor="White" font-size="X-Large"></dx:aspxlabel>
                </dx:panelcontent>
            </panelcollection>
        </dx:aspxpanel>
        <dx:aspxcallbackpanel id="cp" runat="server" width="806px" height="641px" clientinstancename="cp" oncallback="cp_Callback">
            <clientsideevents endcallback="gridView_EndCallback"></clientsideevents>
            <panelcollection>
                <dx:panelcontent runat="server" supportsdisabledattribute="True">
                    <dx:aspxformlayout id="frmlayout1" runat="server" height="565px" width="850px" style="margin-left: -3px">
                        <settingsadaptivity adaptivitymode="SingleColumnWindowLimit" switchtosinglecolumnatwindowinnerwidth="600" />
                        <items>

                            <%--<!--#region Region Header --> --%>
                            <%-- <!--#endregion --> --%>

                            <%--<!--#region Region Details --> --%>

                            <%-- <!--#endregion --> --%>
                            <dx:tabbedlayoutgroup>
                                <items>
                                    <dx:layoutgroup caption="Header" colcount="2">
                                        <items>
                                            <dx:layoutitem caption="Document Number:" name="DocNumber">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtDocnumber" runat="server" width="170px" onload="LookupLoad">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Document Date:" name="DocDate">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxdateedit id="deDocDate" runat="server" oninit="deDocDate_Init" onload="Date_Load" width="170px">
                                                        </dx:aspxdateedit>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="ServiceType:" name="ServiceType">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxgridlookup id="gvServiceType" runat="server" clientinstancename="gvServiceType" autogeneratecolumns="False" datasourceid="ServiceType" keyfieldname="ServiceType" onload="LookupLoad" textformatstring="{0}" width="170px">
                                                            <gridviewproperties>
                                                                <settingsbehavior allowfocusedrow="True" allowselectsinglerowonly="True" />
                                                                <settings showfilterrow="True"></settings>
                                                            </gridviewproperties>
                                                            <columns>
                                                                <dx:gridviewdatatextcolumn fieldname="ServiceType" readonly="True" showincustomizationform="True" visibleindex="0">
                                                                </dx:gridviewdatatextcolumn>
                                                                <dx:gridviewdatatextcolumn fieldname="Description" showincustomizationform="True" visibleindex="1">
                                                                </dx:gridviewdatatextcolumn>
                                                            </columns>
                                                            <clientsideevents validation="OnValidation" valuechanged="ComboboxChanged" />
                                                            <validationsettings display="None" errordisplaymode="ImageWithTooltip">
                                                                <errorimage tooltip="ServiceType is required">
                                                                </errorimage>
                                                                <requiredfield isrequired="True" />
                                                            </validationsettings>
                                                            <invalidstyle backcolor="Pink">
                                                            </invalidstyle>
                                                        </dx:aspxgridlookup>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="DateFrom:" name="dtpDateFrom">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxdateedit id="dtpDateFrom" runat="server" oninit="dtpDateFrom_Init" onload="Date_Load" width="170px">
                                                        </dx:aspxdateedit>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>

                                            <dx:layoutitem caption="BizPartnerCode:" name="BizPartnerCode">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxgridlookup id="gvBizPartnerCode" clientinstancename="gvBizPartnerCode" runat="server" autogeneratecolumns="False" datasourceid="Masterfilebiz" keyfieldname="BizPartnerCode" onload="LookupLoad" textformatstring="{0}" width="170px">
                                                            <gridviewproperties>
                                                                <settingsbehavior allowfocusedrow="True" allowselectsinglerowonly="True" />
                                                                <settings showfilterrow="True"></settings>
                                                            </gridviewproperties>
                                                            <columns>
                                                                <dx:gridviewdatatextcolumn fieldname="BizPartnerCode" readonly="True" showincustomizationform="True" visibleindex="0">
                                                                </dx:gridviewdatatextcolumn>
                                                                <dx:gridviewdatatextcolumn fieldname="Name" showincustomizationform="True" visibleindex="1">
                                                                </dx:gridviewdatatextcolumn>
                                                            </columns>
                                                            <clientsideevents validation="OnValidation" valuechanged="function(s,e){cp.PerformCallback('RR');}" />
                                                            <validationsettings display="None" errordisplaymode="ImageWithTooltip">
                                                                <errorimage tooltip="Supplier is required">
                                                                </errorimage>
                                                                <requiredfield isrequired="True" />
                                                            </validationsettings>
                                                            <invalidstyle backcolor="Pink">
                                                            </invalidstyle>
                                                        </dx:aspxgridlookup>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="DateTo:" name="dtpDateTo">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxdateedit id="dtpDateTo" runat="server" oninit="dtpDateTo_Init" onload="Date_Load" width="170px">
                                                        </dx:aspxdateedit>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Warehouse Code">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxgridlookup id="gvWarehouse" clientinstancename="gvWarehouse" runat="server" width="170px" datasourceid="sdsWarehouse" keyfieldname="WarehouseCode" textformatstring="{0}">
                                                            <gridviewproperties>
                                                                <settingsbehavior allowfocusedrow="True" allowselectsinglerowonly="True" />
                                                                <settings showfilterrow="True"></settings>
                                                            </gridviewproperties>
                                                            <clientsideevents validation="OnValidation" valuechanged="function(s,e){cp.PerformCallback('RR');}" />


                                                            <validationsettings display="None" errordisplaymode="ImageWithTooltip">
                                                                <errorimage tooltip="ServiceType is required">
                                                                </errorimage>
                                                                <requiredfield isrequired="True" />
                                                            </validationsettings>
                                                            <invalidstyle backcolor="Pink">
                                                            </invalidstyle>
                                                        </dx:aspxgridlookup>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Total Amount:" name="TotalAmount ">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtTotalAmount" runat="server" clientinstancename="txtTotalAmount" readonly="True" width="170px">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>

                                            <dx:layoutitem caption="ProfitCenterCode:" name="ProfitCenterCode">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxgridlookup id="gvProfit" clientinstancename="gvProfit" runat="server" datasourceid="ProfitCenterCode" width="170px" keyfieldname="ProfitCenterCode" textformatstring="{0}" autogeneratecolumns="False" onload="LookupLoad">
                                                            <gridviewproperties>
                                                                <settingsbehavior allowfocusedrow="True" allowselectsinglerowonly="True" />
                                                                <settings showfilterrow="True"></settings>
                                                            </gridviewproperties>
                                                            <columns>
                                                                <dx:gridviewdatatextcolumn fieldname="ProfitCenterCode" readonly="True" showincustomizationform="True" visibleindex="0">
                                                                </dx:gridviewdatatextcolumn>
                                                                <dx:gridviewdatatextcolumn fieldname="Description" showincustomizationform="True" visibleindex="1">
                                                                </dx:gridviewdatatextcolumn>
                                                            </columns>
                                                            <clientsideevents validation="OnValidation" />
                                                            <validationsettings display="None" errordisplaymode="ImageWithTooltip">
                                                                <errorimage tooltip="Supplier is required">
                                                                </errorimage>
                                                                <requiredfield isrequired="True" />
                                                            </validationsettings>
                                                            <invalidstyle backcolor="Pink">
                                                            </invalidstyle>
                                                        </dx:aspxgridlookup>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="TotalVat:" name="TotalVat">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtTotalVat" runat="server" width="170px" readonly="True" clientinstancename="txtTotalVat">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="ContractNumber:">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtContractNumber" clientinstancename="txtContractNumber" runat="server" width="170px" readonly="true">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="BillingStatement:" name="BillingStatement">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtBillingStatement" runat="server" width="170px" onload="TextboxLoad">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="BillingPeriodType:" name="BillingPeriodType">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtBillingPeriodType" clientinstancename="txtBillingPeriodType" runat="server" width="170px" readonly="true">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="" name="Genereatebtn">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxbutton id="Generatebtn" runat="server" autopostback="False" text="Generate" theme="MetropolisBlue" width="170px">
                                                            <clientsideevents click="Generate" />
                                                        </dx:aspxbutton>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                        </items>
                                    </dx:layoutgroup>
                                    <dx:layoutgroup caption="User Defined" colcount="2">
                                        <items>
                                            <dx:layoutitem name="Field1" caption="Field 1:">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtHField1" runat="server" onload="TextboxLoad">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Field 6:">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtHField6" runat="server" onload="TextboxLoad">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Field 2:">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtHField2" runat="server" onload="TextboxLoad">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Field 7:">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtHField7" runat="server" onload="TextboxLoad">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Field 3:">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtHField3" runat="server" onload="TextboxLoad">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Field 8:">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtHField8" runat="server" onload="TextboxLoad">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Field 4:">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtHField4" runat="server" onload="TextboxLoad">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Field 9:">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtHField9" runat="server" onload="TextboxLoad">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Field 5:">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtHField5" runat="server" onload="TextboxLoad">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Field 5:">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtServType" runat="server" onload="TextboxLoad">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                        </items>
                                    </dx:layoutgroup>
                                    <dx:layoutgroup caption="Journal Entries">
                                        <items>
                                            <dx:layoutitem caption="">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxgridview id="gvJournal" runat="server" autogeneratecolumns="False" width="850px" clientinstancename="gvJournal" keyfieldname="RTransType;TransType">
                                                            <clientsideevents init="OnInitTrans" batcheditconfirmshowing="OnConfirm" custombuttonclick="OnCustomClick" />
                                                            <settingspager mode="ShowAllRecords" />
                                                            <settingsediting mode="Batch" />
                                                            <settings horizontalscrollbarmode="Visible" verticalscrollbarmode="Auto" columnminwidth="120" verticalscrollableheight="130" />
                                                            <settingsbehavior allowsort="False"></settingsbehavior>
                                                            <settingsdatasecurity allowdelete="False" allowedit="False" allowinsert="False" />
                                                            <columns>
                                                                <dx:gridviewdatatextcolumn fieldname="AccountCode" name="jAccountCode" showincustomizationform="True" visibleindex="0" width="120px" caption="Account Code">
                                                                </dx:gridviewdatatextcolumn>
                                                                <dx:gridviewdatatextcolumn fieldname="AccountDescription" name="jAccountDescription" showincustomizationform="True" visibleindex="1" width="150px" caption="Account Description">
                                                                </dx:gridviewdatatextcolumn>
                                                                <dx:gridviewdatatextcolumn fieldname="SubsidiaryCode" name="jSubsidiaryCode" showincustomizationform="True" visibleindex="2" width="120px" caption="Subsidiary Code">
                                                                </dx:gridviewdatatextcolumn>
                                                                <dx:gridviewdatatextcolumn fieldname="SubsidiaryDescription" name="jSubsidiaryDescription" showincustomizationform="True" visibleindex="3" width="150px" caption="Subsidiary Description">
                                                                </dx:gridviewdatatextcolumn>
                                                                <dx:gridviewdatatextcolumn fieldname="ProfitCenter" name="jProfitCenter" showincustomizationform="True" visibleindex="4" width="120px" caption="Profit Center">
                                                                </dx:gridviewdatatextcolumn>
                                                                <dx:gridviewdatatextcolumn fieldname="CostCenter" name="jCostCenter" showincustomizationform="True" visibleindex="5" width="120px" caption="Cost Center">
                                                                </dx:gridviewdatatextcolumn>
                                                                <dx:gridviewdatatextcolumn fieldname="Debit" name="jDebit" showincustomizationform="True" visibleindex="6" width="120px" caption="Debit  Amount">
                                                                </dx:gridviewdatatextcolumn>
                                                                <dx:gridviewdatatextcolumn fieldname="Credit" name="jCredit" showincustomizationform="True" visibleindex="7" width="120px" caption="Credit Amount">
                                                                </dx:gridviewdatatextcolumn>
                                                            </columns>
                                                        </dx:aspxgridview>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                        </items>
                                    </dx:layoutgroup>
                                    <dx:layoutgroup caption="Audit Trail" colcount="2">
                                        <items>
                                            <dx:layoutitem caption="Added By">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtHAddedBy" runat="server" width="170px" readonly="True">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Added Date">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtHAddedDate" runat="server" width="170px" readonly="True">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Last Edited By">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtHLastEditedBy" runat="server" width="170px" readonly="True">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Last Edited Date">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtHLastEditedDate" runat="server" width="170px" readonly="True">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Submitted By">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtHSubmittedBy" runat="server" width="170px" readonly="True">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                            <dx:layoutitem caption="Submitted Date">
                                                <layoutitemnestedcontrolcollection>
                                                    <dx:layoutitemnestedcontrolcontainer runat="server">
                                                        <dx:aspxtextbox id="txtHSubmittedDate" runat="server" width="170px" readonly="True">
                                                        </dx:aspxtextbox>
                                                    </dx:layoutitemnestedcontrolcontainer>
                                                </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>
                                        </items>
                                    </dx:layoutgroup>
                                </items>
                            </dx:tabbedlayoutgroup>

                            <dx:layoutgroup caption="Lines">
                                <items>
                                    <dx:layoutitem caption="">
                                        <layoutitemnestedcontrolcollection>
                                            <dx:layoutitemnestedcontrolcontainer runat="server">
                                                <dx:aspxgridview id="gv1" runat="server" autogeneratecolumns="False" width="747px"
                                                    oncommandbuttoninitialize="gv_CommandButtonInitialize" oncelleditorinitialize="gv1_CellEditorInitialize" clientinstancename="gv1"
                                                    onrowvalidating="grid_RowValidating" onbatchupdate="gv1_BatchUpdate" keyfieldname="DocNumber;LineNumber">
                                                    <clientsideevents batcheditconfirmshowing="OnConfirm" batcheditrowvalidating="Grid_BatchEditRowValidating"
                                                        batcheditstartediting="OnStartEditing" batcheditendediting="OnEndEditing" init="OnInitTrans" />
                                                    <settingspager mode="ShowAllRecords" />
                                                    <a href="frmBillingMC.aspx.cs">frmBillingMC.aspx.cs</a>
                                                    <settingsediting mode="Batch" />
                                                    <settings horizontalscrollbarmode="Visible" verticalscrollbarmode="Auto" columnminwidth="120" verticalscrollableheight="130" />
                                                    <columns>
                                                        <dx:gridviewdatatextcolumn fieldname="DocNumber" visible="True"
                                                            visibleindex="0" width="0px">
                                                        </dx:gridviewdatatextcolumn>
                                                        <dx:gridviewdatatextcolumn fieldname="LineNumber" visibleindex="2" caption="Line" readonly="True" width="0px" visible="True">
                                                        </dx:gridviewdatatextcolumn>

                                                        <dx:gridviewcommandcolumn buttontype="Image" showincustomizationform="True" visibleindex="1" width="60px">
                                                            <custombuttons>
                                                                <dx:gridviewcommandcolumncustombutton id="Details">
                                                                    <image iconid="support_info_16x16"></image>
                                                                </dx:gridviewcommandcolumncustombutton>
                                                            </custombuttons>

                                                        </dx:gridviewcommandcolumn>

                                                        <dx:gridviewdatatextcolumn caption="Field1" name="Field1" width="170px" showincustomizationform="True" visibleindex="16" fieldname="Field1" unboundtype="String" readonly="True">
                                                        </dx:gridviewdatatextcolumn>
                                                        <dx:gridviewdatatextcolumn caption="Field2" name="Field2" width="170px" showincustomizationform="True" visibleindex="17" fieldname="Field2" unboundtype="String" readonly="True">
                                                        </dx:gridviewdatatextcolumn>
                                                        <dx:gridviewdatatextcolumn caption="Field3" name="Field3" width="170px" showincustomizationform="True" visibleindex="18" fieldname="Field3" unboundtype="String" readonly="True">
                                                        </dx:gridviewdatatextcolumn>
                                                        <dx:gridviewdatatextcolumn caption="Field4" name="Field4" width="170px" showincustomizationform="True" visibleindex="19" fieldname="Field4" unboundtype="Decimal" readonly="True">
                                                        </dx:gridviewdatatextcolumn>
                                                        <dx:gridviewdatatextcolumn caption="Field5" name="Field5" width="170px" showincustomizationform="True" visibleindex="20" fieldname="Field5" unboundtype="Decimal" readonly="True">
                                                        </dx:gridviewdatatextcolumn>
                                                        <dx:gridviewdatatextcolumn caption="Field6" name="Field6" width="170px" showincustomizationform="True" visibleindex="21" fieldname="Field6" unboundtype="Decimal" readonly="True">
                                                        </dx:gridviewdatatextcolumn>
                                                        <dx:gridviewdatatextcolumn caption="Field7" name="Field7" width="170px" showincustomizationform="True" visibleindex="22" fieldname="Field7" unboundtype="Decimal" readonly="True">
                                                        </dx:gridviewdatatextcolumn>
                                                        <dx:gridviewdatatextcolumn caption="Field8" name="Field8" width="170px" showincustomizationform="True" visibleindex="23" fieldname="Field8" unboundtype="String" readonly="True">
                                                        </dx:gridviewdatatextcolumn>
                                                        <dx:gridviewdatatextcolumn caption="Field9" name="Field9" width="170px" showincustomizationform="True" visibleindex="24" fieldname="Field9" unboundtype="String" readonly="True">
                                                        </dx:gridviewdatatextcolumn>

                                                    </columns>
                                                </dx:aspxgridview>
                                            </dx:layoutitemnestedcontrolcontainer>
                                        </layoutitemnestedcontrolcollection>
                                    </dx:layoutitem>
                                </items>
                            </dx:layoutgroup>

                        </items>
                    </dx:aspxformlayout>
                    <dx:aspxpanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF" height="30px">
                        <panelcollection>
                            <dx:panelcontent runat="server" supportsdisabledattribute="True">
                                <div class="pnl-content">
                                    <dx:aspxcheckbox style="display: inline-block;" id="glcheck" runat="server" clientinstancename="glcheck" textalign="Left" text="Prevent auto-close upon update" width="200px"></dx:aspxcheckbox>
                                    <dx:aspxbutton id="updateBtn" runat="server" text="Add" autopostback="False" cssclass="btn" clientinstancename="btn"
                                        usesubmitbehavior="false" causesvalidation="true">
                                        <clientsideevents click="OnUpdateClick" />
                                    </dx:aspxbutton>
                                </div>
                            </dx:panelcontent>
                        </panelcollection>
                    </dx:aspxpanel>
                </dx:panelcontent>
            </panelcollection>
        </dx:aspxcallbackpanel>
        <dx:aspxpopupcontrol id="DeleteControl" runat="server" width="250px" height="100px" headertext="Warning!"
            closeaction="CloseButton" closeonescape="True" modal="True" clientinstancename="DeleteControl"
            popuphorizontalalign="WindowCenter" popupverticalalign="WindowCenter">
            <contentcollection>
                <dx:popupcontrolcontentcontrol runat="server">
                    <dx:aspxlabel id="ASPxLabel1" runat="server" text="Are you sure you want to delete this specific document?" />
                    <table>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>
                                <dx:aspxbutton id="Ok" runat="server" text="Ok" autopostback="False" usesubmitbehavior="false">
                                    <clientsideevents click="function (s, e){  cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                </dx:aspxbutton>
                                <td>
                                    <dx:aspxbutton id="Cancel" runat="server" text="Cancel">
                                        <clientsideevents click="function (s,e){ DeleteControl.Hide(); }" />
                                    </dx:aspxbutton>
                        </tr>
                    </table>
                </dx:popupcontrolcontentcontrol>
            </contentcollection>
        </dx:aspxpopupcontrol>
    </form>

    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.BillingNonStorage" DataObjectTypeName="Entity.BillingNonStorage" DeleteMethod="DeleteData" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <selectparameters>
            <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </selectparameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.BillingNonStorage+BillingNonStorageDetail" DataObjectTypeName="Entity.BillingNonStorage+BillingNonStorageDetail" DeleteMethod="DeleteBillingNonStorageDetail" InsertMethod="AddBillingNonStorageDetail" UpdateMethod="UpdateBillingNonStorageDetail">
        <selectparameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="DocNumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </selectparameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  WMS.BillingOtherServiceDetail where DocNumber  is null " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.BillingNonStorage+JournalEntry">
        <selectparameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </selectparameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [ColorCode], [ClassCode],[SizeCode] FROM Masterfile.[ItemDetail] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.BPCustomerInfo WHERE ISNULL(IsInactive, 0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilebizcustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,0)=0 and IsCustomer='1'" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="ProfitCenterCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ProfitCenterCode, Description FROM Accounting.ProfitCenter WHERE ISNULL(IsInActive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="ServiceType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ServiceType,Description FROM Masterfile.WMSServiceType WHERE Type = 'NONSTORAGE' and ISNULL(IsInActive,0)=0 " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="ContractNumber" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" select DocNumber from wms.Contract where isnull(Submittedby,'') !=''" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="BillingPeriodType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="  select BillingPeriodCode,Description from MasterFile.WMSBillingPeriod" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBOSDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber,Field1,Field2,Field3,Field4,Field5,Field6,Field7,Field8,Field9 FROM WMS.TransactionNonStorage where ISNULL(SubmittedBy,'')!=''" OnInit="Connection_Init"></asp:SqlDataSource>

</body>
</html>
<!--#endr'



