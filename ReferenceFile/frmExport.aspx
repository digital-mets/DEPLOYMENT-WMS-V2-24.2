<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmExport.aspx.cs" Inherits="GWL.WMS.frmExport" %>

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
            width: 914px; /*Change this whenever needed*/
            padding: 10px;
            margin: 20px auto;
            background: #FFF;
            border-radius: 10px;
            -webkit-border-radius: 10px;
            -moz-border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
            -moz-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
            -webkit-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
        }

        .pnl-content {
            text-align: right;
        }
    </style>
    <!--#endregion-->

    <!--#region Javascript-->
    <script>
        var isValid = false;
        var isValid2 = true;
        var counterror = 0;

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        function calcuinit(s, e) {
            autocalculateALL();
        }

        function calcuinit2(s, e) {
            Bulk.SetVisible(false);
            autocalculateALL2();
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
            cp.PerformCallback("Update");
        }

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        function gridView_EndCallback(s, e) {
            if (s.cp_message != null) {
                alert(s.cp_message);
                delete (s.cp_message);
                exportheader.Refresh();
            }

            if (s.cp_error != null) {
                alert(s.cp_error);
                delete (s.cp_error);
            }

            if (s.cp_gensuccess) {
                //if (!alert('Successfully Exported! Please wait while this countsheet reloads...')) {
                //    txtFrom.SetText(null);
                //    txtTo.SetText(null);
                //    txtPallet.SetText(null);
                //    txtExpDate.SetText(null);
                //    txtMfgDate.SetText(null);
                //    txtQty.SetText(null);
                //    window.location.reload();
                //}
            }
            
        }

        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];

            //if (s.batchEditApi.GetCellValue(e.visibleIndex, "PutawayDate") != null) {
            //    e.cancel = true;
            //}

            //if (e.focusedColumn.fieldName === "Location") { //Check the column name
            //    gl.GetInputElement().value = cellInfo.value; //Gets the column value
            //    isSetTextRequired = true;
            //}
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            //if (currentColumn.fieldName === "Location") {
            //    cellInfo.value = gl.GetValue();
            //    cellInfo.text = gl.GetText().toUpperCase();
            //}
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            //countsheetsetup.batchEditApi.EndEdit();
        }

        function Clear(s, e) {
           
        }

        function OnExport(s, e) {
            //if (isValid && counterror < 1 && isValid2) {
            console.log('rev')
              var generate = confirm('Are you sure you want to continue?');
              if (generate) {
                  document.getElementById('btnExecute').click();

                  //cp.PerformCallback('Export');
              }
           //}
           //else {
           //    counterror = 0;
           //    alert('Please check all the fields!');
           //}
        }

        

        function onload() {
            var type = getParameterByName('type');
            var entry = getParameterByName('entry');
            
        }        

        function checkdate(s, e) {
           
            e.isValid = isValid2;
        }

        

        function OnCancelClick(s, e) {
            
        }

        
    </script>
    <!--#endregion-->
</head>
<body style="height: 700px" onload="onload()">
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="700px" Height="350px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" ClientInstanceName="fl" runat="server" DataSourceID="" Height="565px" Width="910px" Style="margin-left: -3px" ColCount="2">
                        <Items>
                            <dx:LayoutGroup Caption="Information" ColSpan="2">
                                <Items>
                                    <dx:LayoutItem Caption="Transaction Type">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtTransType" runat="server" Width="170px" ReadOnly="true">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Doc No.">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px" ReadOnly="true">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                            <dx:LayoutGroup Caption="Export Details" ColSpan="2">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="header" runat="server" ClientInstanceName="exportheader" DataSourceID="sdsExport" KeyFieldName="DocNumber" OnCellEditorInitialize="headerline_CellEditorInitialize" Width="742px">
                                                    <Settings HorizontalScrollBarMode="Visible" />
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Output File">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxComboBox ID="cmbOutput" runat="server" SelectedIndex="0" Width="170px">
                                                    <Items>
                                                        <dx:ListEditItem Text=".Xlsx" Value=".Xlsx" />
                                                        <dx:ListEditItem Text=".Xls" Value=".Xls" />
                                                        <dx:ListEditItem Text=".Rtf" Value=".Rtf" />
                                                        <dx:ListEditItem Text=".Csv" Value=".Csv" />
                                                        <dx:ListEditItem Text=".Pdf" Value=".Pdf" />
                                                    </Items>
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxButton ID="genbtn" runat="server" AutoPostBack="False" Text="Export" OnClick="genbtn_Click" UseSubmitBehavior="False">
                                                </dx:ASPxButton>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>                                    
                        </Items>
                    </dx:ASPxFormLayout>
                    <dx:ASPxGridViewExporter ID="gridExport" runat="server" GridViewID="header" ExportedRowType="All" />
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Calculating..."
            ClientInstanceName="loader" ContainerElementID="loadingcont">
        </dx:ASPxLoadingPanel>
    </form>
    <!--#region Region Datasource-->
    <asp:SqlDataSource ID="sdsExport" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>
    
</body>
</html>
