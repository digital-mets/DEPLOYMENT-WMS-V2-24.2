<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmTransactionNonStorage.aspx.cs" Inherits="GWL.frmTransactionNonStorage" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Transaction Non Storage</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 445px; /*Change this whenever needed*/
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

            $(document).keypress(function (event) {
                if (event.which == 13) {
                    event.preventDefault();

                    autocalculate();

                    return false;
                }
            });
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
                if (s.cp_addnewmessage) {
                    alert("DocNumber already added!");
                    delete (cp_addnewmessage);
                }
                if (glAddNew.GetChecked()) {
                    delete (s.cp_close)
                    window.open('../WMS/frmTransactionNonStorage.aspx?entry=AN&transtype=WMSNON&parameters=' +
                        '&iswithdetail=false&docnumber=' + cmbDocNumber.GetText(), '_blank');
                    console.log(cmbDocNumber.GetText())
                    window.close();
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

            if (s.cp_vatrate != null) {
                var Amount = 0;
                var num1 = 0;
                var num3 = 0;
                var num2 = 0;

                //Rate
                if (field5.GetText() != null || field5.GetText() != "") {
                    num1 = field5.GetText();
                }

                //Quantity
                if (field4.GetText() != null || field4.GetText() != "") {
                    num2 = field4.GetText();
                }

                vatrateval = s.cp_vatrate;
                num3 = s.cp_vatrate;
                var total = 0;
                total = num1 * num3 * num2;

                //console.log(num1);
                //console.log(num2);
                //console.log(num3);
                //console.log(total);

                Amount = num1 * num2;

                // amount
                field7.SetText(Amount);
                // vat
                field6.SetText(total);

                delete (s.cp_vatrate);
            }
            else {
                ComboboxChanged();
            }

            if (s.cp_servicetype == true) {

                cp.PerformCallback('vat');
                autocalculate();
                delete (s.cp_servicetype);
            }

        }

        var itemc; //variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;

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
            if (keyCode == ASPxKey.Enter)
                gv1.batchEditApi.EndEdit();
            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            gv1.batchEditApi.EndEdit();
        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            //for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
            //    var column = s.GetColumn(i);
            //    if (column != s.GetColumn(6) && column != s.GetColumn(1) && column != s.GetColumn(7) && column != s.GetColumn(5) && column != s.GetColumn(8) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23) && column != s.GetColumn(24) && column != s.GetColumn(13)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
            //        var cellValidationInfo = e.validationInfo[column.index];
            //        if (!cellValidationInfo) continue;
            //        var value = cellValidationInfo.value;
            //        if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
            //            cellValidationInfo.isValid = false;
            //            cellValidationInfo.errorText = column.fieldName + " is required";
            //            isValid = false; 
            //        else {
            //            isValid = true;
            //        }
            //    }
            //}
        }
        function ComboboxChanged(s, e) {
            var Type = glServiceType.GetText();
            //console.log(Type);

            // if (Type == "ELECTRICITY") {
            //   console.log('test');
            if (!Type.includes("REEFERVAN")) {
                //console.log(Type);
                Volume.SetValue(null);
                ActualKm.SetValue(null);
            }
            // field4.SetValue(null);
            //txtHField5.SetText(null);
            // field6.SetValue(null);
            //field7.SetValue(null);
            // }
            // else {
            field1.SetValue(null);
            field2.SetValue(null);
            field3.SetValue(null);
            field4.SetValue(0);
            field5.SetValue(0);
            field6.SetValue(0);
            field7.SetValue(0);
            field8.SetValue(null);
            field9.SetValue(null);
            //  }
        }

        function Clear(s, e) {
            var Biz = glBizpartnerCode.GetText();
            console.log(Biz);

            // if (Type == "ELECTRICITY") {
            //   console.log('test');

            // field4.SetValue(null);
            //txtHField5.SetText(null);
            // field6.SetValue(null);
            //field7.SetValue(null);
            // }
            // else {
            glServiceType.SetValue(null);
            field1.SetValue(null);
            field2.SetValue(null);
            field3.SetValue(null);
            field4.SetValue(0);
            field5.SetValue(0);
            field6.SetValue(0);
            field7.SetValue(0);
            field8.SetValue(null);
            field9.SetValue(null);
            //  }
        }
        function autocalculate(s, e) {
            OnInitTrans();
            cp.PerformCallback('vat');
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
            //gv1.SetWidth(width - 120);
        }


    </script>
    <!--#endregion-->
</head>
<body style="height: 388px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" Text="Transaction Non Storage" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="400px" Height="154px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="255px" Width="848px" Style="margin-left: -3px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>

                            <%--<!--#region Region Header --> --%>
                            <%-- <!--#endregion --> --%>

                            <%--<!--#region Region Details --> --%>

                            <%-- <!--#endregion --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number:" Name="DocNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocnumber" runat="server" Width="170px" ReadOnly="true" OnLoad="LookupLoad" ClientInstanceName="cmbDocNumber">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Service Type:" Name="ServiceType">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glServiceType" runat="server" AutoGenerateColumns="False" ClientInstanceName="glServiceType" DataSourceID="ServiceType" KeyFieldName="ServiceType" OnInit="glServiceType_Init" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="ServiceType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('servicetype'); e.processOnServer=false;
                                                                
                                                                 }" />
                                                            <%-- <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e)  {
                                                                    var grid = subsi.GetGridView();
                                                                    subsi.GetGridView().PerformCallback(s.GetInputElement().value); 
                                                                }"/>--%>
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <ErrorImage ToolTip="Service Type is required">
                                                                </ErrorImage>
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date:" Name="DocDate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="deDocDate" runat="server" OnInit="deDocDate_Init" OnLoad="Date_Load" Width="170px">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Warehouse Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvWarehouse" runat="server" DataSourceID="sdsWarehouse" KeyFieldName="WarehouseCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />

                                                            </GridViewProperties>
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('servicetype'); e.processOnServer=false;}" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <ErrorImage ToolTip="Warehouse Code is required">
                                                                </ErrorImage>
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Bizpartner Code:" Name="BizpartnerCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glBizpartnerCode" runat="server" Width="170px" AutoGenerateColumns="True" ClientInstanceName="glBizpartnerCode" DataSourceID="Masterfilebiz" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />

                                                            </GridViewProperties>
                                                            <%--<ClientSideEvents ValueChanged="Clear" />--%>
                                                            <%--                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>--%>

                                                            <%-- <ClientSideEvents Validation="OnValidation" ValueChanged="Clear" /> --%>
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e)  {
                                                                    var grid = glServiceType.GetGridView();
                                                                    cp.PerformCallback('ST');
                                                                    glServiceType.GetGridView().PerformCallback(s.GetInputElement().value); 
                                                                }" />

                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <ErrorImage ToolTip="BizPartner Code is required">
                                                                </ErrorImage>
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Bill Number:" Name="BillNUmber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtBillNumber" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 1:" Name="Field1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" Width="170px" ClientInstanceName="field1" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 2:" Name="Field2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" Width="170px" ClientInstanceName="field2" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 3:" Name="Field3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" Width="170px" ClientInstanceName="field3" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 4:" Name="Field4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtHField4" runat="server" ClientInstanceName="field4" MaxValue="999999999" Number="0" Width="170px" OnLoad="SpinEdit_Load">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 5:" Name="Field5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtHField5" runat="server" ClientInstanceName="field5" MaxValue="999999999" Number="0" Width="170px" OnLoad="SpinEdit_Load">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 6:" Name="Field6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" Width="170px" ClientInstanceName="field6" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 7:" Name="Field7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtHField7" runat="server" ClientInstanceName="field7" MaxValue="999999999" Number="0" Width="170px" OnLoad="SpinEdit_Load">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--<dx:LayoutItem Caption="Field 7:" Name="Field7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" Width="170px" ClientInstanceName="field7" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Field 8:" Name="Field8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" Width="170px" ClientInstanceName="field8" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 9:" Name="Field9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" Width="170px" ClientInstanceName="field9" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="" Name="Volume">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtVolume" runat="server" Width="170px" ClientInstanceName="Volume" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="" Name="ActualKilometer">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActualKm" runat="server" Width="170px" ClientInstanceName="ActualKm" OnLoad="TextboxLoad">
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
                                            <dx:LayoutItem Caption="Submitted By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" Width="170px" ReadOnly="True">
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
                    <dx:ASPxPanel ID="BottomPanel" runat="server" FixedPosition="WindowBottom" BackColor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                    <dx:ASPxCheckBox Style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                                    <dx:ASPxCheckBox Style="display: inline-block;" ID="glAddNew" runat="server" ClientInstanceName="glAddNew" TextAlign="Left" Text="Add and New" Width="200px"></dx:ASPxCheckBox>
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
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" AutoPostBack="false" UseSubmitBehavior="false">
                                    <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                </dx:ASPxButton>
                                <td>
                                    <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel">
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
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.ICN" DataObjectTypeName="Entity.ICN" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ICN+ICNDetail" DataObjectTypeName="Entity.ICN+ICNDetail" DeleteMethod="DeleteICNDetail" InsertMethod="AddICNDetail" UpdateMethod="UpdateICNDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  WMS.ICNDetail where DocNumber  is null " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [ColorCode], [ClassCode],[SizeCode] FROM Masterfile.[ItemDetail] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="ServiceType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" select Distinct ServiceType,Description, BizPartnerCode from  WMS.Contract a inner join WMS.ContractDetail b on a.DocNumber = b.DocNumber where Status != 'Closed' and Type = 'NONSTORAGE'" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select Distinct A.BizPartnerCode, Name from WMS.Contract A inner join Masterfile.BPCustomerInfo B on A.BizPartnerCode = B.BizPartnerCode where A.Status != 'Closed'" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilebizcustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BPCustomerInfo] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="OCN" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Docnumber,OutgoingDocType FROM WMS.[OCN] where NOT ISNULL(SubmittedBy,'')='' and  NOT ISNULL(SubmittedDate,'')=''  " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, Description FROM Masterfile.[Warehouse] WHERE ISNULL([IsInactive],0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


