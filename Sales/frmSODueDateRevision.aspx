<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmSODueDateRevision.aspx.cs" Inherits="GWL.frmSODueDateRevision" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Change SO Due Date</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script><%--NEWADD--%>

     <!--#region Region Javascript-->


        <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
#form1 {
height: 220px; /*Change this whenever needed*/
}

.Entry {
 padding: 20px;
 margin: 10px auto;
 background: #FFF;
}

        .pnl-content
        {
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

           if(s.cp_isnotvalid)
           {
               delete (s.cp_isnotvalid);
               window.confirm(s.cp_message);
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

           if (entry == "V") {
               e.cancel = true; //this will made the gridview readonly
           }

           if (entry != "V") {
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
                   gl5.GetInputElement().value = cellInfo.value;
               }
           }

       }

       function GridEnd(s, e) {
           val = s.GetGridView().cp_codes;
           temp = val.split(';');
           if (closing == true) {
               gvRef.batchEditApi.EndEdit();
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
           if (gvref.batchEditApi[moveActionName]()) {
               ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
           }
       }

       function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode == 13)
               gvref.batchEditApi.EndEdit();
           //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
       }

       function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
           gvref.batchEditApi.EndEdit();
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
               var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "UnitBase");
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
           gvref.SetWidth(width - 120);
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
       var transtype = getParameterByName('transtype');
       function onload() {
           fbnotes.SetContentUrl('../FactBox/fbNotes.aspx?docnumber=' + txtDocnumber1.GetText() + '&transtype=' + transtype);
       }

    </script>
    <!--#endregion-->
</head>
<body style="height: 910px" onload="onload()">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Change SO Due Date" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>

                <dx:ASPxPopupControl ID="notes" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="fbnotes" CloseAction="None"
            EnableViewState="False" HeaderText="Notes" Height="370px" Width="297px" PopupHorizontalOffset="1060" PopupVerticalOffset="200"
            ShowCloseButton="False" Collapsed="true" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" />
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="910px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" style="margin-left: -3px">
                       <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>

                          <%--<!--#region Region Header --> --%>
                            <%-- <!--#endregion --> --%>
                            
                          <%--<!--#region Region Details --> --%>
                            
                            <%-- <!--#endregion --> --%>
                            <dx:TabbedLayoutGroup ActiveTabIndex="0">
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>

                                            <dx:LayoutItem Caption="Document Number" Name="DocNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocnumber" runat="server" Width="170px" OnLoad="TextboxLoad" Enabled="true" ClientInstanceName="txtDocnumber1">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Document Date" Name="DocDate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtDocDate" runat="server" Width="170px" OnLoad="Date_Load">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                             <dx:LayoutItem Caption="SO Document Number" Name="SODocNumber" RequiredMarkDisplayMode="Required">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" >
                                                        <dx:ASPxGridLookup AutoGenerateColumns="true" ID="glSODocNumber"  runat="server" DataSourceID="SODocNumberlookup" KeyFieldName="DocNumber" OnLoad="LookupLoad" TextFormatString="{0}">
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function (s, e){ cp.PerformCallback('SoDueDate');  e.processOnServer = false;}"/>                                                            
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" FilterRowMode="Auto"/>
                                                                <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn Caption="Document Number" FieldName="DocNumber" ShowInCustomizationForm="True" VisibleIndex="1" Width="20px">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Old Due Date" Name="dtOldDueDate" RequiredMarkDisplayMode="Required">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtOldDueDate" runat="server" Width="170px" ReadOnly="true" DropDownButton-Enabled="False">
<DropDownButton Enabled="False"></DropDownButton>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            
                                            <dx:LayoutItem Caption="Remarks" Name="Remarks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxMemo ID="txtRemarks" runat="server" Width="170px" Height="71px" OnLoad="MemoLoad">
                                                        </dx:ASPxMemo>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="New Due Date" Name="DocDate" RequiredMarkDisplayMode="Required">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtNewDueDate" runat="server" Width="170px" OnLoad="Date_Load">
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

                                         </Items>
                                    </dx:LayoutGroup>


                                       


                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field 1:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" OnLoad="TextboxLoad">
                                                            <%--<ClientSideEvents Validation="function (s,e)
                                                                {
                                                                 OnValidation = true;
                                                                }" />--%>
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
                                           <dx:LayoutGroup Caption="Audit Trail" ColSpan="2" ColCount="2">
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
                                               </dx:LayoutItem> <dx:LayoutItem Caption="Cancelled By:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Cancelled Date:" >
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
                                            <dx:LayoutGroup Caption="Reference Detail">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Width="860px" ClientInstanceName="gvref" OnCommandButtonInitialize="gv_CommandButtonInitialize">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  Init="OnInitTrans" />
                                                                    
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
                            <%--document usage trail--%>
                                    <%--end of document usage trail--%>
                            

               
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
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.PurchaseRequest" DataObjectTypeName="Entity.PurchaseRequest" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.PurchaseRequest+PurchaseRequestDetail" DataObjectTypeName="Entity.PurchaseRequest+PurchaseRequestDetail" DeleteMethod="DeletePurchaseRequestDetail" InsertMethod="AddPurchaseRequestDetail" UpdateMethod="UpdatePurchaseRequestDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.SODueDateRevision+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>

    </asp:ObjectDataSource>

    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Procurement.PurchaseRequestDetail where DocNumber  is null "
         OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] where isnull(IsInactive,'')=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT B.ItemCode, ColorCode, ClassCode,SizeCode,UnitBase FROM Masterfile.[Item] A INNER JOIN Masterfile.[ItemDetail] B ON A.ItemCode = B.ItemCode where isnull(A.IsInactive,'')=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="Warehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,'')=0"></asp:SqlDataSource>
  <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.BizPartner WHERE (ISNULL(IsInactive, '') = 0)"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilebizcustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,'')=0 and IsCustomer='1'"></asp:SqlDataSource>
   
    
    
    


    <%------------SQL DataSource------------%>

     <%--SO Document Number Look Up--%>
    <asp:SqlDataSource ID="SODocNumberlookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber FROM Sales.[SalesOrder] WHERE ISNULL (SubmittedBy,'')!='' AND Status IN ('N','P')"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="OldDueDatelookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT TargetDeliveryDate,DocNumber FROM Sales.[SalesOrder] WHERE ISNULL (SubmittedBy,'')!=''"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


