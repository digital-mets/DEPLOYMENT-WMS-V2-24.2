<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmRDESubconSummary.aspx.cs" Inherits="GWL.frmRDESubconSummary" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %><!DOCTYPE html><html xmlns="http://www.w3.org/1999/xhtml"><head runat="server">
    <title>Subcon Summary</title><link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script><%--NEWADD--%>
    
    <!--#region Region Javascript-->
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

       function OnValidation(s, e) { 
           if (s.GetText() == "" || e.value == "" || e.value == null) {
               counterror++;
               isValid = false
           }
           else {
               isValid = true;
           }
       }


       function OnConfirm(s, e) {//function upon saving entry
           if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
               e.cancel = true;
       }

       function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
           textchanged();
            
           if (s.cp_close) {  
                delete (cp_close);
                window.close();//close window if callback successful 
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
           LuisGE.SetWidth(width - 120);
       }

       function textchanged(s, e) { 
           CINFrom.SetEnabled(true);  
           var $cap = $(".perCap");
           $cap.text("Period Covered"); 
           CINGenerate.SetText("ExportToCSV"); 
       }

       function IsValid(param)
       {
       }

    </script><!--#endregion-->

    </head><body style="height: 350px"><dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#dbdbdb" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" Text="Subcon Summary" Font-Bold="true" ForeColor="#666666"  Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>

        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="350px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>

                <dx:PanelContent runat="server" SupportsDisabledAttribute="True"> 
                    <dx:ASPxButton ID="IDExportToCSV" ClientInstanceName="CINGenerate" runat="server" Width="80px" ValidateInvisibleEditors="false" CausesValidation="false" 
                        UseSubmitBehavior="false" AutoPostBack="False" ClientVisible="false" Text="Luis" Theme="MetropolisBlue">                
                    </dx:ASPxButton>

                    <dx:ASPxFormLayout ID="frmlayout1" ClientInstanceName="LuisGE" runat="server" Height="970px" Width="850px" style="margin-left: -3px" ColCount="2">
                       <ClientSideEvents Init="OnInitTrans" />
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:LayoutItem Caption="From" Name="From">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxDateEdit ID="ASPxDateEdit1" runat="server" ClientInstanceName="CINFrom" Width="170px">
                                        </dx:ASPxDateEdit>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="To" Name="To">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxDateEdit ID="ASPxDateEdit2" runat="server" ClientInstanceName="CINTo" Width="170px">
                                        </dx:ASPxDateEdit>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>

                            <dx:LayoutItem Caption="Work Center" Name="WorkCenter">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxGridLookup ID="glWorkCenter" runat="server" ClientInstanceName="CINWorkCenter" DataSourceID="sdsWorkCenter" 
                                            KeyFieldName="WorkCenter" TextFormatString="{0}" Width="170px"
                                            SelectionMode="Single" >
                                            <%--<ClientSideEvents DropDown="function(s,e){CINWorkCenter.GetGridView().PerformCallback();}" />--%>
                                            <GridViewProperties>
                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                            </GridViewProperties>
                                            <Columns>
                                                <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="1">
                                                </dx:GridViewCommandColumn>
                                                <dx:GridViewDataTextColumn FieldName="WorkCenter" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="2" Settings-AutoFilterCondition="Contains">
                                                </dx:GridViewDataTextColumn>
                                            </Columns>
                                        </dx:ASPxGridLookup>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>

                            <dx:LayoutItem Caption="Job Order" Name="JobOrder">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxGridLookup ID="glJobOrder" runat="server" ClientInstanceName="CINJobOrder" DataSourceID="sdsJONumber" 
                                            KeyFieldName="JONumber" TextFormatString="{0}" Width="170px"
                                            SelectionMode="Multiple" >
                                            <%--<ClientSideEvents DropDown="function(s,e){CINJobOrder.GetGridView().PerformCallback();}" />--%>
                                            <GridViewProperties>
                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                            </GridViewProperties>
                                            <Columns>
                                                <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="1">
                                                </dx:GridViewCommandColumn>
                                                <dx:GridViewDataTextColumn FieldName="JONumber" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                </dx:GridViewDataTextColumn> 
                                            </Columns>
                                        </dx:ASPxGridLookup>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                                    

                            <dx:LayoutItem Caption="Step Code" Name="StepCode">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxGridLookup ID="glStepCode" runat="server" ClientInstanceName="CINStepCode" DataSourceID="sdsStep" 
                                            KeyFieldName="StepCode" TextFormatString="{0}" Width="170px"
                                            SelectionMode="Multiple" >
                                            <%--<ClientSideEvents DropDown="function(s,e){StepCode.GetGridView().PerformCallback();}" />--%>
                                            <GridViewProperties>
                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                            </GridViewProperties>
                                            <Columns>
                                                <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="1">
                                                </dx:GridViewCommandColumn>
                                                <dx:GridViewDataTextColumn FieldName="StepCode" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                </dx:GridViewDataTextColumn> 
                                            </Columns>
                                        </dx:ASPxGridLookup>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="" Name="Genereatebtn">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxButton ID="Generatebtn" OnClick="IDExportToCSV_Click" ClientInstanceName="CINGenerate" runat="server" Width="170px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" ClientVisible="true" Text="ExportToCSV" Theme="MetropolisBlue">
                                            <ClientSideEvents Click="function(){ 
                                                cp.PerformCallback();}" />
                                        </dx:ASPxButton>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:EmptyLayoutItem>
                            </dx:EmptyLayoutItem> 

                            <dx:LayoutGroup Caption="Extracted Data">
                                <Items>
                                    <dx:LayoutItem ShowCaption="false">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer>
                                                <dx:ASPxGridView runat="server" ID="gv" AutoGenerateColumns="true"
                                                    Width="900px" EnableViewState="false">
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                            <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                </dx:ASPxGridView>
                                                <dx:ASPxGridView runat="server" ID="gv2" AutoGenerateColumns="true" KeyFieldName="StockNumber"
                                                    Width="900px" EnableViewState="false" Visible="false">
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                            <SettingsBehavior AllowSort="False"></SettingsBehavior>
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

        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Calculating..."
            ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
            <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>

        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" Text="Loading..." Modal="true"
            ClientInstanceName="loader" ContainerElementID="cp">
            <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
    </form>

    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.RICN+RICNDetail" DataObjectTypeName="Entity.RICN+RICNDetail" DeleteMethod="DeleteRICNDetail" InsertMethod="AddRICNDetail" UpdateMethod="UpdateRICNDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.PurchaseRequest+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <form runat="server" id="form2" visible="false">
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Retail.ICNDetail WHERE DocNumber  is null "
         >
    </asp:SqlDataSource>


    <%------------SQL DataSource------------%>
    <%--Gender Code Look Up--%> 
    <asp:SqlDataSource ID="sdsWorkCenter" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="
            SELECT  BP.BizPartnerCode AS WorkCenter, BP.Name + '(' +RTRIM( BP.BizPartnerCode) + ')' AS Name, 
            ROW_NUMBER () OVER (ORDER BY BP.BizPartnerCode) AS Ord INTO #BizLookUP
            FROM MasterFile.BizPartner AS BP INNER JOIN MasterFile.BizPartnerSubtype AS SUB 
            ON BP.BizPartnerCode = SUB.BizPartnerCode AND SUB.BizSubtypeCode = 'SUB'
            WHERE (ISNULL(BP.IsInactive, 0) = 0) 
            UNION ALL SELECT 'ALL' as WorkCenter,'ALL' as Name,0 AS Ord
            ORDER BY Ord

            SELECT  WorkCenter, Name FROM #BizLookUP ORDER BY Ord ASC
            DROP TABLE #BizLookUP" OnInit="Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsJONumber" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT JO.DocNumber AS JONumber, ROW_NUMBER ()
            OVER (ORDER BY JO.DocNumber) AS Ord INTO #JOLookUP FROM Production.JobOrder JO
            INNER JOIN Production.JOStep STEP ON
            JO.DocNumber = STEP.DocNumber 
            GROUP BY JO.DocNumber
            union all select 'ALL' as  JONumber,0 AS Ord
            ORDER BY Ord

            SELECT JONumber FROM #JOLookUP ORDER BY Ord ASC
            DROP TABLE #JOLookUP" OnInit="Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsStep" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT StepCode, ROW_NUMBER ()
            OVER (ORDER BY StepCode) AS Ord INTO #StepLookUP
            from Production.JOStep  GROUP BY StepCode
            union all select 'ALL' as  StepCode,0 AS Ord
            ORDER BY Ord

            SELECT StepCode FROM #StepLookUP ORDER BY Ord ASC
            DROP TABLE #StepLookUP" OnInit="Connection_Init">
    </asp:SqlDataSource>
    </form>
    
    
    <!--#endregion-->
</body>
</html>