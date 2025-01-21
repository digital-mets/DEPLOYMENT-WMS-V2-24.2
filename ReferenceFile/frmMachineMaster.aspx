<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmMachineMaster.aspx.cs" Inherits="GWL.frmMachineMaster" %>
<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Machine</title>
     <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script><%--NEWADD--%>

    <script src="../js/Production/Machine.js" type="text/javascript"></script> <%-- Capacity Planning JS --%>
    <style>
        .dxflCLLSys .dxflCaptionCell_MetropolisBlue {
            padding-right: 0px;
        }

        .dxeCalendarFastNavMonthArea_MetropolisBlue, .dxeCalendar_MetropolisBlue
        {
            display: block !important;
        }

        .pnl-content
        {
            text-align: right;
        }
        .btn
        {
                background: #2A88AD;
                padding: 3px 20px 3px 20px;
                border-radius: 5px;
                -webkit-border-radius: 5px;
                -moz-border-radius: 5px;
                color: #fff;
                text-shadow: 1px 1px 3px rgb(0 0 0 / 12%);
                -moz-box-shadow: inset 0px 2px 2px 0px rgba(255, 255, 255, 0.17);
                -webkit-box-shadow: inset 0px 2px 2px 0px rgb(255 255 255 / 17%);
                box-shadow: inset 0px 2px 2px 0px rgb(255 255 255 / 17%);
                position: relative;
                border: 1px solid #257C9E;
                font-size: 15px;
                font-style: normal;
                font-variant: normal;
                font-weight: bold;
                line-height: normal;
                font-family: 'Segoe UI', Helvetica, 'Droid Sans', Tahoma, Geneva, sans-serif;
        }
         .delbutton
        {
                background: rgba(192, 57, 43, 0.94);
                padding: px 20px 3px 20px;
                border-radius: 5px;
                -webkit-border-radius: 10px;
                -moz-border-radius: 10px;
                color: #fff;
                text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.12);
                -moz-box-shadow: inset 0px 2px 2px 0px rgba(255, 255, 255, 0.17);
                -webkit-box-shadow: inset 0px 2px 2px 0px rgb(255 255 255 / 17%);
                box-shadow: inset 0px 2px 2px 0px rgba(255, 255, 255, 0.17);
                position: relative;
                border: 1px solid #257C9E;
                font-size: 9px;
                font-style: normal;
                font-variant: normal;
                font-weight: bold;
                line-height: normal;
                font-family: 'Segoe UI', Helvetica, 'Droid Sans', Tahoma, Geneva, sans-serif;
                cursor: pointer;
                margin-left:5px;
        }

                 .delbutton span {
                  cursor: pointer;
                  display: inline-block;
                  position: relative;
                  transition: 0.5s;
                }

                .delbutton span:after {
                  content: '\00bb';
                  position: absolute;
                  opacity: 0;
                  top: 0;
                  right: -20px;
                  transition: 0.5s;
                }

                .delbutton:hover span {
                  padding-right: 25px;
                }

                .delbutton:hover span:after {
                  opacity: 1;
                  right: 0;
                }
      
    </style>
</head>
<body style="height: 910px;">

    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>

    <form id="form1" runat="server">

        <%-- Top Panel --%>
        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" Text="Machine" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>

        <%-- Step Process Details Field --%>
        <dx:ASPxPopupControl ID="CStepProcess" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CStepProcess" CloseAction="CloseButton" CloseOnEscape="true"
        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
        ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
            <ClientSideEvents CloseUp="function (s, e) { window.location.reload(); }" />
        </dx:ASPxPopupControl>

        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback" SettingsLoadingPanel-ImagePosition="Left" SettingsLoadingPanel-Enabled="False">

            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>

            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True"> 
                    
                    <%-- Form Layout Start --%>
                    <dx:ASPxFormLayout ID="frmLayoutRouting" runat="server" Height="300px" Width="1280px" style="margin-left: -3px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <%-- General Tab Start --%>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>
                                            <%-- FG-SKU Code Field --%>
                                            <dx:LayoutGroup Caption="Info" ColCount="2">
                                                <Items>
                                                    <%-- SKU Code Field --%>
                                                    <dx:LayoutItem Caption="Machine Code" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                               
                                                                <dx:ASPxTextBox ID="MachineID" runat="server"  Width="170px" MaxLength="15" AutoCompleteType="Disabled" ClientEnabled="True" ClientInstanceName="Code">
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="true" />
                                                                         <RegularExpression ValidationExpression="^[a-zA-Z0-9_-]*$|\@#" ErrorText="Error" /> 
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>

                                                                     </dx:ASPxTextBox>

                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    
                                                    <%-- Effectivity Date Field --%>
                                                    <dx:LayoutItem Caption="Machine Category">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="MachineCategory" runat="server" DataSourceID="sdsMachineCategory" Width="170px" KeyFieldName="MachineCategoryCode" 
                                                                        TextFormatString="{0}" AutoGenerateColumns="False" ClientInstanceName="MachineCategory">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="MachineCategoryCode" Caption="Machine Category Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents ValueChanged="function(s,e){ 
                                                                        var g = MachineCategory.GetGridView();
                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'MachineCategoryCode;Description', UpdateDescription); 
                                                                    }"/>
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="false" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- SKU Description Field --%>
                                                    <dx:LayoutItem Caption="Description">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <%--<dx:ASPxTextBox ID="Description" runat="server" Width="170px" ClientEnabled="false" ClientInstanceName="Description" ReadOnly="true">
                                                                </dx:ASPxTextBox>--%>
                                                                <dx:ASPxMemo ID="Description" ClientInstanceName="Description" runat="server" Height="50px" Width="170px" Text=" " HorizontalAlign="Justify" ClientEnabled="false">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- Unit of Measure Field --%>
                                                    <dx:LayoutItem Caption="Brand">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                               
                                                                <dx:ASPxTextBox ID="Brand" runat="server"  Width="170px" AutoCompleteType="Disabled" ClientEnabled="True" ClientInstanceName="Brand">
                                                                     <ClientSideEvents ValueChanged="UpdateDescr"/>
                                                                </dx:ASPxTextBox>

                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- Customer Code Field --%>
                                                    <dx:LayoutItem Caption="Asset Code">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtAssetCode" runat="server"  Width="170px" AutoCompleteType="Disabled"  ClientInstanceName="txtAssetCode">
                                                                </dx:ASPxTextBox>
                                                                <%--<dx:ASPxGridLookup ID="glAssetCode" runat="server" DataSourceID="sdsAssetCode" Width="170px" KeyFieldName="BizPartnerCode" 
                                                                        TextFormatString="{0}" AutoGenerateColumns="False" ClientInstanceName="CustomerCode">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" Caption="Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" Caption="Name" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents ValueChanged="function(s,e){ 
                                                                        var g = CustomerCode.GetGridView();
                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'Name', UpdateCustomerName); 
                                                                    }"/>
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="false" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>--%>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- Expected Output Qty Field --%>
                                                    <dx:LayoutItem Caption="Model">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtModel" runat="server"  Width="170px" AutoCompleteType="Disabled"  ClientInstanceName="txtModel">
                                                                    <ClientSideEvents ValueChanged="UpdateDescr"/>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- Customer Name Field --%>
                                                    <dx:LayoutItem Caption="Asset Tag">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="AssetTag" runat="server"  Width="170px" AutoCompleteType="Disabled"  ClientInstanceName="AssetTag">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>

                                                    </dx:LayoutItem>
                                                     <%-- Serial No Field --%>
                                                    <dx:LayoutItem Caption="Serial No.">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="SerialNo" runat="server" Width="170px"  ClientInstanceName="SerialNo">
                                                                    <ClientSideEvents ValueChanged="UpdateDescr"/>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    
                                                     <%-- Supply Voltage Field --%>
                                                    <dx:LayoutItem Caption="Supply Voltage">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <%--<dx:ASPxTextBox ID="SupplyVoltage" runat="server" Width="170px"  ClientInstanceName="SupplyVoltage">
                                                                    <ClientSideEvents ValueChanged="UpdateDescr"/>
                                                                </dx:ASPxTextBox>--%>
                                                                <dx:ASPxSpinEdit ID="SupplyVoltage" ClientInstanceName="SupplyVoltage" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  >
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    <ClientSideEvents ValueChanged="UpdateDescr"/>
                                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                     <%-- Section Field --%>
                                                    <dx:LayoutItem Caption="Section">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <%--<dx:ASPxTextBox ID="Section" runat="server" Width="170px"  ClientInstanceName="Section">
                                                                </dx:ASPxTextBox>--%>

                                                                <dx:ASPxGridLookup ID="Section" runat="server" DataSourceID="sdsSection" Width="170px" KeyFieldName="Section" 
                                                                        TextFormatString="{0}" AutoGenerateColumns="False" ClientInstanceName="Section">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>

                                                                    <Columns>
                                                         
                                                                        <dx:GridViewDataTextColumn FieldName="Section" Caption="Section" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="DepartmentID" Caption="Department ID" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CostCenterCode" Caption="Cost Center" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                               <%--     <ClientSideEvents ValueChanged="function(s,e){ 
                                                                        var g = CustomerCode.GetGridView();
                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'Name', UpdateCustomerName); 
                                                                    }"/>--%>
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="true" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    
                                                    <%-- Location Field --%>
                                                    <dx:LayoutItem Caption="Location">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                               <dx:ASPxGridLookup ID="glLocation" runat="server" DataSourceID="sdsLocation" Width="170px" KeyFieldName="LocationCode" 
                                                                        TextFormatString="{0}" AutoGenerateColumns="False" ClientInstanceName="CustomerCode">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="LocationCode" Caption="Location Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LocationDescription" Caption="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                               <%--     <ClientSideEvents ValueChanged="function(s,e){ 
                                                                        var g = CustomerCode.GetGridView();
                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'Name', UpdateCustomerName); 
                                                                    }"/>--%>
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="false" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                     <dx:LayoutItem Caption="Assigned Personel">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                               <dx:ASPxGridLookup ID="glAssignedPersonnel" runat="server" DataSourceID="sdsAssignedPersonnel" Width="170px" KeyFieldName="EmployeeCode" 
                                                                        TextFormatString="{0}" AutoGenerateColumns="False" ClientInstanceName="CustomerCode">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="EmployeeCode" Caption="Employee Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="EmployeeName" Caption="Name" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                   <%-- <ClientSideEvents ValueChanged="function(s,e){ 
                                                                        var g = CustomerCode.GetGridView();
                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'Name', UpdateCustomerName); 
                                                                    }"/>--%>
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="false" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- Status Field --%>
                                                    <dx:LayoutItem Caption="Status">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="Status" runat="server" Width="170px" ClientEnabled="false" ClientInstanceName="Status">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- Date Acquired Field --%>
                                                    <dx:LayoutItem Caption="Date Acquired">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpDocDate" runat="server" Width="170px">
                                                                    
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="false" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- Status Field --%>
                                                 <%--   <dx:LayoutItem Caption="Machine Manual">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <input type="button" style="width:100px;" /> 
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>

                                                    <dx:LayoutItem Caption="Machine Manual" >

                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                   <%-- <div id="dropZone">
                                                                       <div class="form-horizontal">
                                                                        <div class="form-group">
                                                                            <div class="col-sm-2 attachImages">
                                                                                <asp:Image CssClass="img-thumbnail" ID="picture1Img"  runat="server" Height="50%" Width="50%"
                                                                                    style="cursor: pointer;" onclick="showImage(this.id)" />
                                                                            </div>
                                                                            <div class="col-sm-10">
                                                                                <div class="form-row">
                                                                                    <div class="form-holder form-holder-2">
                                                                
                                                                                        <asp:FileUpload ID="Picture1" runat="server" class="form-control-file attachFiles"
                                                                                            accept="application/pdf" onchange="imageIsLoaded(this)" />
                                                                                    </div>
                                                                                    <input id="btnSave" runat="server" type="submit"  onserverclick="UploadFile" style="display:none;"/>
                                                                                
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>--%>
                                                                <dx:ASPxUploadControl ID="Upload" runat="server" ShowUploadButton="false" UploadMode="Advanced" OnFileUploadComplete="Upload_FileUploadComplete" AutoStartUpload="true"  Width="170px" ShowProgressPanel="True">
                                                                     <AdvancedModeSettings EnableMultiSelect="True" EnableFileList="True" EnableDragAndDrop="True" />
                                                                     <ValidationSettings AllowedFileExtensions=".pdf,.docx,.xlsx">
                                                                    </ValidationSettings>
                                                                    <ClientSideEvents FileUploadComplete="OnFileUploadComplete" />
                                                                </dx:ASPxUploadControl>
                                                                <div id="FileListN" style="border:1px; display:none;" runat="server" >
                                                                 <h4>Uploaded Manuals</h4>
                                                                  <div id="FilesN">
                                                                      
                                                                  </div>
                                                              </div>
                                                              <div id="FileList" style="border:1px;" runat="server">
                                                                 <h4>Preview Manuals</h4>
                                                                  <div id="Files">
                                                                      
                                                                  </div>
                                                              </div>

                                                                <br />
                                                                <br />
                                                                <div id="DEL" runat="server">
                                                                <input id="btnDelete" runat="server" type="button"  onserverclick="DeleteManual" value="Delete Manuals" style="width:170px; display:none;"/>
                                                                </div>
                                                                <%--<div class="filesContainer">
                                                                    <dx:UploadedFilesContainer ID="FileContainer" runat="server" Width="100%" Height="180"
                                                                        NameColumnWidth="240" SizeColumnWidth="70" HeaderText="Uploaded files" />
                                                                </div>--%>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                     <%-- Section Field --%>
                                                    <dx:LayoutItem Caption="" Visible="true">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="RecordID" runat="server" Width="0px"  ClientInstanceName="RecordID" Border-BorderColor="#ffffff">
                                                                </dx:ASPxTextBox>
                                                                
                                                                <dx:ASPxHiddenField runat="server" ID="hidID"></dx:ASPxHiddenField>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="" Width="0px" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                         <input id="previewbtn" value="Preview Manual" type="button" onclick="preview()" style="width:170px; align-items:center; display:none;"/>
                                                        <%--<dx:ASPxTextBox ID="RRemarksText" runat="server"  Width="0px" Border-BorderColor="#ffffff">
                                                    
                                             
                                                             </dx:ASPxTextBox>--%>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                                     <dx:LayoutItem Caption="" Visible="true">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="Cat" runat="server" Width="0px"  ClientInstanceName="Cat" Border-BorderColor="#ffffff">
                                                                </dx:ASPxTextBox>
                                                                
                                                                <dx:ASPxHiddenField runat="server" ID="ASPxHiddenField1"></dx:ASPxHiddenField>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                     <dx:LayoutItem Caption="" Width="0px">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="FileName"  ClientInstanceName="FileName" runat="server"  Width="0px" Border-BorderColor="#ffffff">
                                                    
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            
                                                </Items>



                                                <Items>
                   
            
                    
                    
                    <dx:EmptyLayoutItem Height="1" />
                         </Items>
                                          </dx:LayoutGroup>
                                            <%-- Step Process Field --%>
                                            <dx:LayoutGroup Caption="Detail">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <div class="container-fluid" id="StepProcessTable">
                                                                    <dx:ASPxGridView DataSourceID="sdsStepProcess" ID="gvStepProcess" ClientInstanceName="gvStepProcess" runat="server" 
                                                                        AutoGenerateColumns="False" KeyFieldName="MachineID;LineNumber" Width="100%" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize" OnRowValidating="grid_RowValidating" 
                                                                        OnBeforePerformDataSelect="masterGrid_BeforePerformDataSelect" OnRowInserting="gvStepProcess_RowInserting" OnRowUpdating="gvStepProcess_RowUpdating" 
                                                                        OnRowDeleting="gvStepProcess_RowDeleting">

                                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick"/>

                                                                        <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 

                                                                        <SettingsPager Mode="ShowAllRecords"></SettingsPager>

                                                                        <SettingsEditing Mode="Batch"></SettingsEditing>

                                                                        <SettingsBehavior AllowSort="False" ConfirmDelete="true"/>

                                                                        <SettingsDetail ShowDetailRow="true" ShowDetailButtons="false" AllowOnlyOneMasterRowExpanded="true" />

                                                                        <SettingsCommandButton>

                                                                            <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                            <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                            <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                        </SettingsCommandButton>

                                                                        <Styles><StatusBar CssClass="statusBar"></StatusBar></Styles>
                                                                        <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>

                                                                        <Columns>
                                                                            <%-- Buttons --%>
                                                                            <dx:GridViewCommandColumn ShowNewButtonInHeader="True" Width="5%" ButtonType="Image">
                                                                                <CustomButtons>
                                                                                    <dx:GridViewCommandColumnCustomButton ID="Delete" >
                                                                                        <Image IconID="actions_cancel_16x16">
                                                                                        </Image>
                                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                                </CustomButtons>
                                                                            </dx:GridViewCommandColumn>
                                                                           
                                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" Width="10%">
                                                                                <EditFormSettings Visible="False" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <%-- Code Field --%>
                                                                             <dx:GridViewDataTextColumn FieldName="MachineID" Width="0%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="RecordID" Width="0%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="MachineCode" Width="15%">
                                                                            </dx:GridViewDataTextColumn>
                                                                             <dx:GridViewDataTextColumn FieldName="Description" Width="15%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Brand" Width="15%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Model" Width="15%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="SerialNo" Width="15%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <%--<dx:GridViewDataTextColumn FieldName="SupplyVoltage" Width="15%">
                                                                            </dx:GridViewDataTextColumn>--%>

                                                                            <dx:GridViewDataSpinEditColumn Caption="SupplyVoltage" FieldName="SupplyVoltage" Name="SupplyVoltage"  ShowInCustomizationForm="True" PropertiesSpinEdit-DisplayFormatString="{0:#,0.0000;(#,0.0000);}" PropertiesSpinEdit-AllowMouseWheel="False" Width="15%">
                                                                                <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="False">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                </PropertiesSpinEdit>
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                            <%-- PMType Field --%>
                                                                         
                                                                        </Columns>

                                                                    </dx:ASPxGridView>
                                                                </div>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>


                                        


                                                                   <%--     PM SCHED--%>





                                                                        <%--<Templates>
                                                                            <DetailRow>
                                                                                <div style="padding: 3px 3px 2px 3px">
                                                                                    <dx:ASPxPageControl runat="server" ID="StepProcessDetail" Width="100%" EnableCallBacks="true">
                                                                                        <TabPages>
                                                                                            <dx:TabPage Text="PM Schedule" Visible="true">
                                                                                                <ContentCollection>
                                                                                                    <dx:ContentControl runat="server">--%>
                                             <dx:LayoutGroup Caption="PM Schedule Setup">
                                                        <Items>
                                                            <dx:LayoutItem Caption="">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <div class="container-fluid" id="StepProcessDetail">

                                                                            <dx:ASPxGridView ID="gvPMSched" ClientInstanceName="gvPMSched" DataSourceID="sdsPMSched" runat="server" KeyFieldName="LineNumber" Width="100%" 
                                                                                OnBeforePerformDataSelect="detailPMSched_BeforePerformDataSelect" OnRowInserting="gvPMSched_RowInserting" OnRowUpdating="gvPMSched_RowUpdating"
                                                                                OnRowDeleting="gvPMSched_RowDeleting" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize">
                                                                                <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick"/>
                                                                                <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                                <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                                <SettingsBehavior AllowSort="False"/>
                                                                                <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 
                                                                                <SettingsDetail ShowDetailRow="true" ShowDetailButtons="true" AllowOnlyOneMasterRowExpanded="true" />
                                                                                    <SettingsCommandButton>
                                                                                    <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                                    <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                                    <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                                </SettingsCommandButton>
                                                                                <Styles>
                                                                                    <StatusBar CssClass="statusBar">
                                                                                    </StatusBar>
                                                                                </Styles>
                                                                                <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>
                                                                                <Columns>
                                                                                    <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" Width="10%" ShowNewButtonInHeader="True">
                                                                                        <CustomButtons>
                                                                                            <dx:GridViewCommandColumnCustomButton ID="PMDelete">
                                                                                            <Image IconID="actions_cancel_16x16"> </Image>
                                                                                            </dx:GridViewCommandColumnCustomButton>
                                                                                            <dx:GridViewCommandColumnCustomButton ID="ViewPrint" >
                                                                                            <Image IconID="actions_printpreview_16x16devav">
                                                                                            </Image>
                                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                                        </CustomButtons>
                                                                                    </dx:GridViewCommandColumn>
                                                                                    <dx:GridViewDataColumn FieldName="RecordID" Width="0%"/>
                                                                                    <dx:GridViewDataColumn FieldName="MachineID" Width="0%"/>                                                                                                     
                                                                                    <dx:GridViewDataColumn FieldName="MachineCode" Width="0%"/>
                                                                                    <dx:GridViewDataColumn FieldName="DLineNumber" Width="0%"/>
                                                                                    <dx:GridViewDataTextColumn FieldName="LineNumber" Width="15%">
                                                                                        <EditFormSettings Visible="False" />
                                                                                    </dx:GridViewDataTextColumn>
                                                                                                                
                                                                                    <dx:GridViewDataTextColumn FieldName="PMType" Caption="PMType" Name="PMType" ShowInCustomizationForm="True" Width="20%">
                                                                                        <EditItemTemplate>
                                                                                            <dx:ASPxGridLookup ID="glPMType" ClientInstanceName="glPMType" runat="server" DataSourceID="sdsPMType" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="PMType" TextFormatString="{0}" Width="100%" >
                                                                                                    <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                        Settings-VerticalScrollBarMode="Visible"> 
                                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                        AllowSelectSingleRowOnly="True"/>
                                                                                                </GridViewProperties>
                                                                                                <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="PMType" Caption="Code" ReadOnly="True" Width="100px">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                        </dx:GridViewDataTextColumn>
                                                                                                    <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" Width="100px">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                        </dx:GridViewDataTextColumn>
                                                                                                                                
                                                                                                </Columns>
                                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                            var g = glPMType.GetGridView();
                                                                                                            g.GetRowValues(g.GetFocusedRowIndex(), 'PMType;Description', UpdatePMType); 
                                                                                                        }"/>
                                                                                            </dx:ASPxGridLookup>
                                                                                        </EditItemTemplate>
                                                                                    </dx:GridViewDataTextColumn>


<%--                                                                                        <dx:GridViewDataTextColumn FieldName="DateTime" Name="DateTime" Caption="Start Date" Width="15%" CellStyle-HorizontalAlign="Right">
                                                                                    </dx:GridViewDataTextColumn>--%>

                                                                                 <%--   <dx:ASPxDateEdit ID="dateEdit" runat="server" EditFormat="Custom" Date="2009-11-02 09:23" Width="190" Caption="ASPxDateEdit">
                                                                                    <TimeSectionProperties>
                                                                                        <TimeEditProperties EditFormatString="hh:mm tt" />
                                                                                    </TimeSectionProperties>
                                                                                    <CalendarProperties>
                                                                                        <FastNavProperties DisplayMode="Inline" />
                                                                                    </CalendarProperties>
                                                                                </dx:ASPxDateEdit>--%>

                                                                                     <%--<dx:GridViewDataDateColumn  FieldName='DateTime' Name="DateTime" Caption='Start Date' ShowInCustomizationForm='True' runat="server" Date="2009-11-02 09:23" Width="190">
                                                                                         <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy HH:mm" EditFormatString="dd/MM/yyyy HH:mm">   
                                                                                         <TimeSectionProperties Visible="true" >  
                                                                                            <TimeEditProperties EditFormatString="HH:mm" DisplayFormatString="HH:mm"></TimeEditProperties>  
                                                                                        </TimeSectionProperties>  
                                                                                   
                                                                                           </PropertiesDateEdit> 
                                                                                        </dx:GridViewDataDateColumn>--%>


                                                                                    <dx:GridViewDataDateColumn FieldName="DateTime" Width="30%" Caption ="Start Date & Time">  
                                                                                        <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy hh:mm tt" EditFormatString="dd/MM/yyyy hh:mm tt">  
                                                                                            <TimeSectionProperties Visible="true" >  
                                                                                                <%--<TimeEditProperties EditFormatString="hh:mm tt" DisplayFormatString="HH:mm"></TimeEditProperties>  --%>
                                                                                            </TimeSectionProperties>  
                                                                                            <%--<ClientSideEvents  ValueChanged="DateTime()"/>--%>
                                                                                        </PropertiesDateEdit>  
                                                                                    </dx:GridViewDataDateColumn>  

                                                                                    <dx:GridViewDataTextColumn FieldName="Time" Name="Time" Caption=" " Width="0%" ReadOnly="true">
                                                                                    </dx:GridViewDataTextColumn>



                                                                                    <dx:GridViewDataTextColumn FieldName="Priority" Caption="Priority" Name="Priority" ShowInCustomizationForm="True" Width="15%">
                                                                                            <EditItemTemplate>
                                                                                            <dx:ASPxGridLookup ID="glPriority" ClientInstanceName="glPriority" runat="server" DataSourceID="sdsPriority" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="Priority" TextFormatString="{0}" Width="100%" >
                                                                                                    <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                        Settings-VerticalScrollBarMode="Visible"> 
                                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                        AllowSelectSingleRowOnly="True"/>
                                                                                                </GridViewProperties>
                                                                                                <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="Priority" Caption="Priority" ReadOnly="True" Width="100px">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                        </dx:GridViewDataTextColumn>
                                                                                                                                
                                                                                                                                
                                                                                                </Columns>
                                                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                    var g = glPriority.GetGridView();
                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'Priority', UpdatePriority); 
                                                                                                }"/>
                                                                                            </dx:ASPxGridLookup>
                                                                                        </EditItemTemplate>

                                                                                    </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="ReportTitle" Width="15%">
                                                                                        </dx:GridViewDataTextColumn>   
                                                                                                         
                                                                                        <dx:GridViewDataTextColumn FieldName="FormNo" Width="15%">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                                               
                                                                                        <dx:GridViewDataTextColumn FieldName="Version" Width="15%">
                                                                                        </dx:GridViewDataTextColumn>

<%--                                                                                        <dx:GridViewDataTextColumn FieldName="ChecklistForm" Width="15%">
                                                                                        </dx:GridViewDataTextColumn>--%>

                                                                                      <dx:GridViewDataTextColumn FieldName="ChecklistForm" Caption="ChecklistForm" Name="Priority" ShowInCustomizationForm="True" Width="30%">
                                                                                            <EditItemTemplate>
                                                                                            <dx:ASPxGridLookup ID="glChecklistForm" ClientInstanceName="glChecklistForm" runat="server" DataSourceID="sdsChecklistform" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="Form" TextFormatString="{0}" Width="100%" >
                                                                                                    <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                        Settings-VerticalScrollBarMode="Visible"> 
                                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                        AllowSelectSingleRowOnly="True"/>
                                                                                                </GridViewProperties>
                                                                                                <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" Width="100px">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                        </dx:GridViewDataTextColumn>

                                                                                                    <dx:GridViewDataTextColumn FieldName="Form" Caption="Form" ReadOnly="True" Width="100px">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                        </dx:GridViewDataTextColumn>
                                                                                                                                
                                                                                                                                
                                                                                                </Columns>
                                                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                    var g = glChecklistForm.GetGridView();
                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'Description;Form', UpdateChecklist); 
                                                                                                }"/>
                                                                                            </dx:ASPxGridLookup>
                                                                                        </EditItemTemplate>

                                                                                    </dx:GridViewDataTextColumn>

                                                                                                               
                                                                                                                
                                                                                </Columns>
                                                                                            <%--  PM CHECKLIST--%>
                                                                                        <Templates>
                                                                                            <DetailRow>
                                                                                                <div style="padding: 3px 3px 2px 3px">
                                                                                                    <dx:ASPxPageControl runat="server" ID="StepProcessDetail" Width="100%" EnableCallBacks="true">
                                                                                                        <TabPages>
                                                                                                            <dx:TabPage Text="PM Checklist" Visible="true">
                                                                                                                <ContentCollection>
                                                                                                                    <dx:ContentControl runat="server">
                                                                                                                        <dx:ASPxGridView ID="gvStepBOM" ClientInstanceName="gvStepBOM" DataSourceID="sdsBOM" runat="server" KeyFieldName="PMNumber;LineNumber" Width="100%" 
                                                                                                                            OnBeforePerformDataSelect="detailBOM_BeforePerformDataSelect" OnRowInserting="gvStepBOM_RowInserting" OnRowUpdating="gvStepBOM_RowUpdating"
                                                                                                                            OnRowDeleting="gvStepBOM_RowDeleting" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize">
                                                                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick"/>
                                                                                                                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                                                                            <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                                                                            <SettingsBehavior AllowSort="False"/>
                                                                                                                            <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 
                                                                                                                            <SettingsDetail ShowDetailRow="true" ShowDetailButtons="false" AllowOnlyOneMasterRowExpanded="true" />
                                                                                                                                <SettingsCommandButton>
                                                                                                                                <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                                                                                <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                                                                                <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                                                                            </SettingsCommandButton>
                                                                                                                            <Styles>
                                                                                                                                <StatusBar CssClass="statusBar">
                                                                                                                                </StatusBar>
                                                                                                                            </Styles>
                                                                                                                            <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" Width="5%" ShowNewButtonInHeader="True">
                                                                                                                                    <CustomButtons>
                                                                                                                                        <dx:GridViewCommandColumnCustomButton ID="BOMDelete">
                                                                                                                                        <Image IconID="actions_cancel_16x16"> </Image>
                                                                                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                                                                                    </CustomButtons>
                                                                                                                                </dx:GridViewCommandColumn>
                                                                                                                                <dx:GridViewDataColumn FieldName="RecordID" Width="0%"/>
                                                                                                                                <dx:GridViewDataColumn FieldName="PMNumber" Width="0%"/>                                                                                                     
                                                                                                                                <dx:GridViewDataColumn FieldName="Code" Width="0%"/>
                                                                                                                                <dx:GridViewDataColumn FieldName="PMSNumber" Width="0%"/>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="LineNumber" Width="10%">
                                                                                                                                    <EditFormSettings Visible="False" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="ActivityTask" Caption="Activity Task" Name="Description" ShowInCustomizationForm="True" Width="30%"></dx:GridViewDataTextColumn>
                                                                                                               
                                                                                                                                <dx:GridViewDataCheckColumn FieldName="Conformance" Name="Conformance" Caption="Conformance"  ShowInCustomizationForm="True" Width="0%">
                                                                                                                                <PropertiesCheckEdit ClientInstanceName="chkIsConformance"></PropertiesCheckEdit>
                                                                                                                                </dx:GridViewDataCheckColumn>

                                                                                                               
                                                                                                                                <%--<dx:GridViewDataColumn FieldName="TotalConsumption" Width="8.63%" ReadOnly="true" />--%>
                                                                                                                                <dx:GridViewDataCheckColumn FieldName="NonConformance" Name="NonConformance" Caption="NonConformance"  ShowInCustomizationForm="True" Width="0%">
                                                                                                                                <PropertiesCheckEdit ClientInstanceName="chkIsNonConformance"></PropertiesCheckEdit>
                                                                                                                                </dx:GridViewDataCheckColumn>
                                                                                                               
                                                                                                                                <dx:GridViewDataColumn FieldName="Remarks" Width="35%"/>
                                                                                                                
                                                                                                                            </Columns>

                                                                                                                                                           
                                                                                                                                                                            
                                                                                                                        <SettingsDetail IsDetailGrid="True" />
                                                                                                                    </dx:ASPxGridView>
                                                                                                                </dx:ContentControl>
                                                                                                            </ContentCollection>
                                                                                                        </dx:TabPage>
                                                                                                        <%-- Material / Tool--%>
                                                                                                            <dx:TabPage Text="Material Requirement" Visible="true">
                                                                                                                <ContentCollection>
                                                                                                                    <dx:ContentControl runat="server">
                                                                                                                        <dx:ASPxGridView ID="gvMaterial" ClientInstanceName="gvMaterial" DataSourceID="sdsMaterial" runat="server" KeyFieldName="PMCNumber;LineNumber" Width="100%" 
                                                                                                                            OnBeforePerformDataSelect="detailMaterial_BeforePerformDataSelect" OnRowInserting="gvMaterial_RowInserting" OnRowUpdating="gvMaterial_RowUpdating"
                                                                                                                            OnRowDeleting="gvMaterial_RowDeleting" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize">
                                                                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick"/>
                                                                                                                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                                                                            <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                                                                            <SettingsBehavior AllowSort="False"/>
                                                                                                                            <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 
                                                                                                                            <SettingsDetail ShowDetailRow="true" ShowDetailButtons="false" AllowOnlyOneMasterRowExpanded="true" />
                                                                                                                                <SettingsCommandButton>
                                                                                                                                <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                                                                                <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                                                                                <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                                                                            </SettingsCommandButton>
                                                                                                                            <Styles>
                                                                                                                                <StatusBar CssClass="statusBar">
                                                                                                                                </StatusBar>
                                                                                                                            </Styles>
                                                                                                                            <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" Width="5%" ShowNewButtonInHeader="True">
                                                                                                                                    <CustomButtons>
                                                                                                                                        <dx:GridViewCommandColumnCustomButton ID="MTDelete">
                                                                                                                                        <Image IconID="actions_cancel_16x16"> </Image>
                                                                                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                                                                                    </CustomButtons>
                                                                                                                                </dx:GridViewCommandColumn>
                                                                                                                                <dx:GridViewDataColumn FieldName="RecordID" Width="0%"/>
                                                                                                                                <dx:GridViewDataColumn FieldName="PMNumber" Width="0%"/> 
                                                                                                                                <dx:GridViewDataColumn FieldName="PMCNumber" Width="0%"/>  
                                                                                                                                <dx:GridViewDataColumn FieldName="PMSNumber" Width="0%"/>                                                                                                    
                                                                                                                                <dx:GridViewDataColumn FieldName="MachineCode" Width="0%"/>
                                                                                                             
                                                                                                               
                                                                                                                                <dx:GridViewDataTextColumn FieldName="LineNumber" Width="10%">
                                                                                                                                    <EditFormSettings Visible="False" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="MaterialType" Caption="Material Type" Name="MaterialType" ShowInCustomizationForm="True" Width="20%">
                                                                                                                                    <EditItemTemplate>
                                                                                                                                        <dx:ASPxGridLookup ID="glMaterialType" ClientInstanceName="glMaterialType" runat="server" DataSourceID="sdsMaterialType" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="MaterialTypeCode" TextFormatString="{0}" Width="100%" >
                                                                                                                                                <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                                                                    Settings-VerticalScrollBarMode="Visible"> 
                                                                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                                                    AllowSelectSingleRowOnly="True"/>
                                                                                                                                            </GridViewProperties>
                                                                                                                                            <Columns>
                                                                                                                                                <dx:GridViewDataTextColumn FieldName="MaterialTypeCode" Caption="MaterialTypeCode" ReadOnly="True" Width="100px">
                                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                                                                <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" Width="100px">
                                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                                                
                                                                                                                                
                                                                                                                                            </Columns>
                                                                                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                                                                    var g = glMaterialType.GetGridView();
                                                                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'MaterialTypeCode', UpdateMaterialType); 
                                                                                                                                                }"/>
                                                                                                                                                                                                                                  
                                                                                                                                        </dx:ASPxGridLookup>
                                                                                                                                    </EditItemTemplate>

                                                                                                                                </dx:GridViewDataTextColumn>

                                                                                                                                <dx:GridViewDataTextColumn FieldName="Qty" Caption="Quantity" Name="Quantity" ShowInCustomizationForm="True" Width="20%">

                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                              
                                                                                                                                                                            
                                                                                                               
                                                                                                                                <dx:GridViewDataColumn FieldName="Remarks" Width="15%"/>
                                                                                                                                                                           
                                                                                                              
                                                                                                                            </Columns>
                                                                                                                            <SettingsDetail IsDetailGrid="True" />
                                                                                                                        </dx:ASPxGridView>
                                                                                                                    </dx:ContentControl>
                                                                                                                </ContentCollection>
                                                                                                            </dx:TabPage>


                                                                                                                <dx:TabPage Text="Tool" Visible="true">
                                                                                                                <ContentCollection>
                                                                                                                    <dx:ContentControl runat="server">
                                                                                                                        <dx:ASPxGridView ID="gvTool" ClientInstanceName="gvTool" DataSourceID="sdsTool" runat="server" KeyFieldName="PMNumber;LineNumber" Width="100%" 
                                                                                                                            OnBeforePerformDataSelect="detailTool_BeforePerformDataSelect" OnRowInserting="gvTool_RowInserting" OnRowUpdating="gvTool_RowUpdating"
                                                                                                                            OnRowDeleting="gvTool_RowDeleting" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize">
                                                                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick"/>
                                                                                                                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                                                                            <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                                                                            <SettingsBehavior AllowSort="False"/>
                                                                                                                            <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 
                                                                                                                                <SettingsDetail ShowDetailRow="true" ShowDetailButtons="false" AllowOnlyOneMasterRowExpanded="true" />
                                                                                                                                <SettingsCommandButton>
                                                                                                                                <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                                                                                <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                                                                                <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                                                                            </SettingsCommandButton>
                                                                                                                            <Styles>
                                                                                                                                <StatusBar CssClass="statusBar">
                                                                                                                                </StatusBar>
                                                                                                                            </Styles>
                                                                                                                            <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" Width="5%" ShowNewButtonInHeader="True">
                                                                                                                                    <CustomButtons>
                                                                                                                                        <dx:GridViewCommandColumnCustomButton ID="ToolDelete">
                                                                                                                                        <Image IconID="actions_cancel_16x16"> </Image>
                                                                                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                                                                                    </CustomButtons>
                                                                                                                                </dx:GridViewCommandColumn>
                                                                                                                                <dx:GridViewDataColumn FieldName="RecordID" Width="0%"/>
                                                                                                                                <dx:GridViewDataColumn FieldName="PMNumber" Width="0%"/>     
                                                                                                                                <dx:GridViewDataColumn FieldName="PMSNumber" Width="0%"/>                                                                                                
                                                                                                                                <dx:GridViewDataColumn FieldName="MachineCode" Width="0%"/>
                                                                                                             
                                                                                                               
                                                                                                                                <dx:GridViewDataTextColumn FieldName="LineNumber" Width="10%">
                                                                                                                                    <EditFormSettings Visible="False" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="ToolType" Caption="Tool Type" Name="ToolType" ShowInCustomizationForm="True" Width="20%">
                                                                                                                                        <EditItemTemplate>
                                                                                                                                        <dx:ASPxGridLookup ID="glToolType" ClientInstanceName="glToolType" runat="server" DataSourceID="sdsToolType" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="ToolTypeCode" TextFormatString="{0}" Width="100%" >
                                                                                                                                                <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                                                                    Settings-VerticalScrollBarMode="Visible"> 
                                                                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                                                    AllowSelectSingleRowOnly="True"/>
                                                                                                                                            </GridViewProperties>
                                                                                                                                            <Columns>
                                                                                                                                                <dx:GridViewDataTextColumn FieldName="ToolTypeCode" Caption="Tool Type" ReadOnly="True" Width="100px">
                                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                                                                <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" Width="100px">
                                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                                                
                                                                                                                                
                                                                                                                                            </Columns>
                                                                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                                                                var g = glToolType.GetGridView();
                                                                                                                                                g.GetRowValues(g.GetFocusedRowIndex(), 'ToolTypeCode', UpdateToolType); 
                                                                                                                                            }"/>
                                                                                                                                        </dx:ASPxGridLookup>
                                                                                                                                    </EditItemTemplate>
                                                                                                                                </dx:GridViewDataTextColumn>

                                                                                                                                <dx:GridViewDataTextColumn FieldName="Qty" Caption="Quantity" Name="Quantity" ShowInCustomizationForm="True" Width="20%">

                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                              
                                                                                                                                                                            
                                                                                                               
                                                                                                                                <dx:GridViewDataColumn FieldName="Remarks" Width="15%"/>
                                                                                                                                                                            
                                                                                                              
                                                                                                                            </Columns>
                                                                                                                            <SettingsDetail IsDetailGrid="True" />
                                                                                                                        </dx:ASPxGridView>
                                                                                                                    </dx:ContentControl>
                                                                                                                </ContentCollection>
                                                                                                            </dx:TabPage>




                                                                                                    </TabPages>
                                                                                                </dx:ASPxPageControl>
                                                                                            </div>

                                                                                        </DetailRow>
                                                                                    </Templates>
                                                                                                             



                                                                                <SettingsDetail IsDetailGrid="True" />
                                                                            </dx:ASPxGridView>
                                                                            </div>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>



                                                                                                    <%--</dx:ContentControl>
                                                                                                </ContentCollection>
                                                                                            </dx:TabPage>
                                                                  
                                                                                        </TabPages>
                                                                                    </dx:ASPxPageControl>
                                                                                </div>

                                                                            </DetailRow>
                                                                        </Templates>--%>













                                            <%-- PM generated Field --%>
                                          <dx:LayoutGroup Caption="PMSchedule">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <div class="container-fluid" id="PMTable">
                                                                    <dx:ASPxGridView DataSourceID="sdsPMGen" ID="PMGen" ClientInstanceName="PMGen" runat="server" 
                                                                        AutoGenerateColumns="False" KeyFieldName="DocNumber;RecordID" Width="100%" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize" OnRowValidating="grid_RowValidating" 
                                                                        OnBeforePerformDataSelect="PMGen_BeforePerformDataSelect">

                                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick"/>

                                                                        <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 

                                                                        <SettingsPager Mode="ShowAllRecords"></SettingsPager>

                                                                     <%--   <SettingsEditing Mode="Batch"></SettingsEditing>--%>

                                                                        <SettingsBehavior AllowSort="False" ConfirmDelete="true"/>

                                                                        <SettingsDetail ShowDetailRow="true" ShowDetailButtons="true" AllowOnlyOneMasterRowExpanded="true" />

                                                                      

                                                                        <Styles><StatusBar CssClass="statusBar"></StatusBar></Styles>
                                                                        <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>

                                                                        <Columns>
                                                                            
                                                                           
                                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" Width="0%">
                                                                                <EditFormSettings Visible="False" />
                                                                            </dx:GridViewDataTextColumn>

                                                                            <dx:GridViewDataColumn FieldName="RecordID" Width="0%"/>    
                                                                            <dx:GridViewDataColumn FieldName="MachineID" Width="0%"/>                                                                                               
                                                                            <dx:GridViewDataColumn FieldName="MachineCode" Width="0%"/>
                                                                            <dx:GridViewDataColumn FieldName="DLineNumber" Width="0%"/>
                                                                            <dx:GridViewDataColumn FieldName="LineNumber" Width="0%"/>
                                                                            <%-- Code Field --%>
                                                                             <dx:GridViewDataTextColumn FieldName="PMType" Width="15%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <%--<dx:GridViewDataTextColumn FieldName="StartDateTime" Width="15%">
                                                                            </dx:GridViewDataTextColumn>--%>
                                                                            <dx:GridViewDataTextColumn FieldName="Year" Width="15%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="WeekNo" Width="15%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Day" Width="15%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Code" Width="15%">
                                                                            </dx:GridViewDataTextColumn>
                                                                             <dx:GridViewDataTextColumn FieldName="Status" Width="15%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="WorkOrderControlNo" Width="15%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Remarks" Width="15%">
                                                                            </dx:GridViewDataTextColumn>
                                                                             <dx:GridViewDataTextColumn FieldName="Priority" Width="15%">
                                                                            </dx:GridViewDataTextColumn>
                                                                           
                                                                           
                                                                            <%-- PMType Field --%>
                                                                         
                                                                        </Columns>


                                                                      <%--  PM CHECKLIST--%>
                                                                        <Templates>
                                                                            <DetailRow>
                                                                                <div style="padding: 3px 3px 2px 3px">
                                                                                    <dx:ASPxPageControl runat="server" ID="StepProcessDetail" Width="100%" EnableCallBacks="true">
                                                                                        <TabPages>
                                                                                            <dx:TabPage Text="PM Checklist" Visible="true">
                                                                                                <ContentCollection>
                                                                                                    <dx:ContentControl runat="server">
                                                                                                        <dx:ASPxGridView ID="gvStepBOM" ClientInstanceName="gvStepBOM" DataSourceID="sdsBOM" runat="server" KeyFieldName="PMNumber;LineNumber" Width="100%" 
                                                                                                            OnBeforePerformDataSelect="detailBOM_BeforePerformDataSelect" OnRowInserting="gvStepBOM_RowInserting" OnRowUpdating="gvStepBOM_RowUpdating"
                                                                                                            OnRowDeleting="gvStepBOM_RowDeleting" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize">
                                                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick"/>
                                                                                                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                                                            <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                                                            <SettingsBehavior AllowSort="False"/>
                                                                                                            <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 
                                                                                                            <SettingsDetail ShowDetailRow="true" ShowDetailButtons="false" AllowOnlyOneMasterRowExpanded="true" />
                                                                                                             
                                                                                                            <Styles>
                                                                                                                <StatusBar CssClass="statusBar">
                                                                                                                </StatusBar>
                                                                                                            </Styles>
                                                                                                            <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>
                                                                                                            <Columns>
                                                                                                               
                                                                                                                <dx:GridViewDataColumn FieldName="RecordID" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="PMNumber" Width="0%"/>                                                                                                     
                                                                                                                <dx:GridViewDataColumn FieldName="Code" Width="0%"/>
                                                                                                             
                                                                                                                <dx:GridViewDataTextColumn FieldName="LineNumber" Width="10%">
                                                                                                                    <EditFormSettings Visible="False" />
                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                <dx:GridViewDataTextColumn FieldName="ActivityTask" Caption="Activity Task" Name="Description" ShowInCustomizationForm="True" Width="30%"></dx:GridViewDataTextColumn>
                                                                                                               
                                                                                                                <dx:GridViewDataCheckColumn FieldName="Conformance" Name="Conformance" Caption="Conformance"  ShowInCustomizationForm="True" Width="10%">
                                                                                                                <PropertiesCheckEdit ClientInstanceName="chkIsConformance"></PropertiesCheckEdit>
                                                                                                                </dx:GridViewDataCheckColumn>

                                                                                                               
                                                                                                                <%--<dx:GridViewDataColumn FieldName="TotalConsumption" Width="8.63%" ReadOnly="true" />--%>
                                                                                                                <dx:GridViewDataCheckColumn FieldName="NonConformance" Name="NonConformance" Caption="NonConformance"  ShowInCustomizationForm="True" Width="10%">
                                                                                                                <PropertiesCheckEdit ClientInstanceName="chkIsNonConformance"></PropertiesCheckEdit>
                                                                                                                </dx:GridViewDataCheckColumn>
                                                                                                               
                                                                                                                <dx:GridViewDataColumn FieldName="Remarks" Width="35%"/>
                                                                                                                
                                                                                                            </Columns>
    
                                                                                                            <SettingsDetail IsDetailGrid="True" />
                                                                                                        </dx:ASPxGridView>
                                                                                                    </dx:ContentControl>
                                                                                                </ContentCollection>
                                                                                            </dx:TabPage>
                                                                  
                                                                                        </TabPages>
                                                                                    </dx:ASPxPageControl>
                                                                                </div>

                                                                            </DetailRow>
                                                                        </Templates>
                                                                       
                                                                    </dx:ASPxGridView>
                                                                </div>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>  
                                    <%-- General Tab End --%>



                                     <dx:LayoutGroup Caption="Downtime History Tab" ColCount="2">
                                        <Items>
                                           <dx:LayoutItem ClientVisible="true" Caption=" ">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvDowntime" runat="server" ClientInstanceName="gv2" AutoGenerateColumns="true" BatchEditStartEditing="OnStartEditing" DataSourceID="sdsDowntime"  
                                                                    KeyFieldName="DocNumber;LineNumber" Width="100%"  OnBeforePerformDataSelect="detailDownTime_BeforePerformDataSelect">
                                                                                                                                                                     
                                                                   <%-- <SettingsEditing Mode="Batch" />--%>
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <Styles>
                                                                    <StatusBar CssClass="statusBar">
                                                                    </StatusBar>
                                                                     </Styles>
                                                                    <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                          
                                        </Items>
                                    </dx:LayoutGroup>




                                    <%-- Audit Trail Tab Start --%>
                                    <dx:LayoutGroup Caption="Audit Trail" ColCount="2">
                                        <Items>
                                            <%-- Added By Field --%>
                                            <dx:LayoutItem Caption="Added By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAddedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- Added Date Field --%>
                                            <dx:LayoutItem Caption="Added Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAddedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- Last Edited By Field --%>
                                            <dx:LayoutItem Caption="Last Edited By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLastEditedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- Last Edited Date Field --%>
                                            <dx:LayoutItem Caption="Last Edited Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLastEditedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- Activated By Field --%>
                                            <dx:LayoutItem Caption="Activated By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActivatedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- Activated Date Field --%>
                                            <dx:LayoutItem Caption="Activated Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActivatedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- Deactivated By Field --%>
                                            <dx:LayoutItem Caption="Deactivated By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDeactivatedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- Deactivated Date Field --%>
                                            <dx:LayoutItem Caption="Deactivated Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDeactivatedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <%-- Audit Trail Tab END --%>
                                </Items>
                            </dx:TabbedLayoutGroup>

                                   </Items>


                    </dx:ASPxFormLayout>
                    <%-- Form Layout END --%>
               
                    <%-- Bottom Panel --%>
                    <dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                    <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                                    <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" CssClass="btn btn-primary" ClientInstanceName="btn"
                                        UseSubmitBehavior="false" CausesValidation="true">
                                        <ClientSideEvents Click="OnUpdateClick" />
                                    </dx:ASPxButton>
                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>

                    <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server"  Text=""   Image-Url="..\images\loadinggear.gif" Image-Height="30px" Image-Width="30px" Height="30px" Width="30px" Enabled="true" ShowImage="true" BackColor="Transparent" Border-BorderStyle="None" 
                        ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
                        <LoadingDivStyle Opacity="0"></LoadingDivStyle>
                   </dx:ASPxLoadingPanel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel> 
    </form>
    <form id="form2" runat="server" visible="false">
        <asp:SqlDataSource ID="sdsmachineCP" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT * FROM Accounting.APMemo"></asp:SqlDataSource>

         <%--  DataSource --%>

          <%-- CustomerCode DataSource --%>
        <asp:SqlDataSource ID="sdsMachineCategory" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="select MachineCategoryCode,Description from Masterfile.MachineCategory"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsAssetCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.BizPartner"></asp:SqlDataSource>
<%--        <asp:SqlDataSource ID="sdsAssignedPersonnel" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="select EmployeeCode,EmployeeName from MasterFile.BPEmployeeinfo where Requester = 0"></asp:SqlDataSource>--%>
        <asp:SqlDataSource ID="sdsAssignedPersonnel" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="select EmployeeCode,'' AS EmployeeName from MasterFile.BPEmployeeinfo" ></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsLocation" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="select LocationCode,LocationDescription from Masterfile.Location"></asp:SqlDataSource>
        <%--<asp:SqlDataSource ID="sdsSection" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="Declare @Code varchar(10) select @Code = Value from it.SystemSettings where Code = 'SECDEPID'  select A.DepartmentID ,B.Section,B.CostCenterCode from Masterfile.Department A LEFT JOIN Masterfile.DepartmentDetail B ON A.DepartmentID = B.DepartmentID where A.DepartmentID = @Code"></asp:SqlDataSource>--%>

         <asp:SqlDataSource ID="sdsSection" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="select  DepartmentCode AS DepartmentID,DepartmentName AS Section, '' AS CostCenterCode from Masterfile.Department"></asp:SqlDataSource>

        

        
        <%-- PMType DataSource --%>
        <asp:SqlDataSource ID="sdsPMType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT PMType,Description FROM Masterfile.PMType"></asp:SqlDataSource>
          
        <%-- Priority DataSource --%>
        <asp:SqlDataSource ID="sdsChecklistform" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="select Description,Form from Masterfile.ChecklistForms where ChecklistCode = 'MC' Order by RecordID ASC"></asp:SqlDataSource>
         
        
        <%-- Priority DataSource --%>
        <asp:SqlDataSource ID="sdsPriority" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT Priority FROM Masterfile.Priority"></asp:SqlDataSource>
         <%-- MaterialType DataSource --%>
        <asp:SqlDataSource ID="sdsMaterialType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="select MaterialTypeCode,Description from Masterfile.MaterialType"></asp:SqlDataSource>
          <%-- ToolType DataSource --%>
        <asp:SqlDataSource ID="sdsToolType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="select ToolTypeCode,Description from Masterfile.ToolType"></asp:SqlDataSource>



        
        




        <%-- SKUCode DataSource --%>
        <asp:SqlDataSource ID="sdsSKUCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init" SelectCommand="SELECT A.ItemCode, A.FullDesc FROM Masterfile.Item A LEFT JOIN Masterfile.ItemCategory B ON A.ItemCategoryCode = B.ItemCategoryCode LEFT JOIN Production.ProdRouting C ON A.ItemCode=C.SKUCode WHERE ISNULL(A.IsInactive,0)=0 AND A.ItemCategoryCode = 003 AND C.SKUCode IS NULL"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsSKUCode2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init" SelectCommand="SELECT A.ItemCode, A.FullDesc FROM Masterfile.Item A LEFT JOIN Masterfile.ItemCategory B ON A.ItemCategoryCode = B.ItemCategoryCode LEFT JOIN Production.ProdRouting C ON A.ItemCode=C.SKUCode WHERE ISNULL(A.IsInactive,0)=0 AND A.ItemCategoryCode = 003 AND C.SKUCode IS NULL OR C.SKUCode=@SKUCode">
            <SelectParameters>
                <asp:Parameter Name="SKUCode" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>


        
        <%-- ItemCode DataSource --%>
        <asp:SqlDataSource ID="sdsItemCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT A.ItemCode, A.FullDesc, UnitBase FROM Masterfile.Item A LEFT JOIN Masterfile.ItemCategory B ON A.ItemCategoryCode = B.ItemCategoryCode WHERE ISNULL(A.IsInactive,0)=0 AND A.ItemCategoryCode!=003"></asp:SqlDataSource>

        <%-- CustomerCode DataSource --%>
        <asp:SqlDataSource ID="sdsCustomerCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.BizPartner"></asp:SqlDataSource>

        <%-- Unit DataSource --%>
        <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT A.UnitCode, A.Description, B.ConversionFactor FROM Masterfile.Unit A LEFT JOIN Masterfile.UnitConversion B ON A.UnitCode = B.UnitCodeFrom WHERE ISNULL(A.IsInactive,0)=0"></asp:SqlDataSource>
        
        <%-- StepCode DataSource --%>
        <asp:SqlDataSource ID="sdsStepCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT StepCode, Description FROM Masterfile.Step WHERE ISNULL(IsInactive,0)=0"></asp:SqlDataSource>

        <%-- Machine DataSource --%>
        <asp:SqlDataSource ID="sdsMachineCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT MachineCode, Description, Location, CapacityQty, CapacityUnit FROM Masterfile.Machine WHERE ISNULL(IsInactive,0)=0"></asp:SqlDataSource>

        <%-- Machine DataSource --%>
        <asp:SqlDataSource ID="sdsDesignation" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT * FROM Masterfile.Manpower WHERE ISNULL(IsInactive,0)=0"></asp:SqlDataSource>



        <%-- StepProcess DataSource --%>
        <asp:SqlDataSource ID="sdsStepProcess" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init"
            SelectCommand="" 
            DeleteCommand="DELETE  MasterFile.MachineDetail WHERE RecordID=@DRecordID">
            
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>


        <asp:ObjectDataSource ID="odsStepProcess" runat="server" DataObjectTypeName="Entity.Machine+PMSchedule" SelectMethod="getStepProcess" InsertMethod="AddStepProcess" TypeName="Entity.Machine+PMSchedule" UpdateMethod="UpdateStepProcess" DeleteMethod="DeleteStepProcess">
            <SelectParameters>
                <asp:QueryStringParameter Name="SKUCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>

        <%-- PMSched DataSource --%>
        <asp:SqlDataSource ID="sdsPMSched" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init" 
            SelectCommand=""
             DeleteCommand="DELETE MasterFile.MachinePMChecklist WHERE RecordID=@DRecordID">
         
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>

        <asp:ObjectDataSource ID="odsPMSched" runat="server" DataObjectTypeName="Entity.Machine+ProdRoutingStepBOM" TypeName="Entity.Machine+getStepProcessBOM" SelectMethod="getStepProcessBOM" InsertMethod="AddStepProcessBOM" UpdateMethod="UpdateStepProcessBOM" DeleteMethod="DeleteStepProcessBOM">
            <SelectParameters>
                <asp:Parameter Name="SKUCode" Type="String" />
                <asp:Parameter Name="StepSequence" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>





        <%-- BOM DataSource --%>
        <asp:SqlDataSource ID="sdsBOM" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init" 
            SelectCommand=""
             DeleteCommand="DELETE MasterFile.MachinePMChecklist WHERE RecordID=@DRecordID">
         
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>

        <asp:ObjectDataSource ID="odsBOM" runat="server" DataObjectTypeName="Entity.Machine+ProdRoutingStepBOM" TypeName="Entity.Machine+getStepProcessBOM" SelectMethod="getStepProcessBOM" InsertMethod="AddStepProcessBOM" UpdateMethod="UpdateStepProcessBOM" DeleteMethod="DeleteStepProcessBOM">
            <SelectParameters>
                <asp:Parameter Name="SKUCode" Type="String" />
                <asp:Parameter Name="StepSequence" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>

         <%-- Material DataSource --%>
        <asp:SqlDataSource ID="sdsMaterial" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init" 
            SelectCommand=""
             DeleteCommand="DELETE MasterFile.MachineMaterialReq WHERE RecordID=@DRecordID">
         
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>

        <asp:ObjectDataSource ID="OdsMaterial" runat="server" DataObjectTypeName="Entity.Machine+ProdRoutingStepBOM" TypeName="Entity.Machine+getStepProcessBOM" SelectMethod="getStepProcessBOM" InsertMethod="AddStepProcessBOM" UpdateMethod="UpdateStepProcessBOM" DeleteMethod="DeleteStepProcessBOM">
            <SelectParameters>
                <asp:Parameter Name="SKUCode" Type="String" />
                <asp:Parameter Name="StepSequence" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>

        <asp:SqlDataSource ID="sdsDowntime" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init" 
            SelectCommand=""
             DeleteCommand="DELETE MasterFile.MachineMaterialReq WHERE RecordID=@DRecordID">
         
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>

        <asp:ObjectDataSource ID="odsDowntime" runat="server" DataObjectTypeName="Entity.Machine+ProdRoutingStepBOM" TypeName="Entity.Machine+getStepProcessBOM" SelectMethod="getStepProcessBOM" InsertMethod="AddStepProcessBOM" UpdateMethod="UpdateStepProcessBOM" DeleteMethod="DeleteStepProcessBOM">
            <SelectParameters>
                <asp:Parameter Name="SKUCode" Type="String" />
                <asp:Parameter Name="StepSequence" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>


         <%-- PM generated DataSource --%>
        <asp:SqlDataSource ID="sdsPMGen" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init"
            SelectCommand="" 
            DeleteCommand="DELETE  MasterFile.MachineDetail WHERE RecordID=@DRecordID">
            
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>




        <%-- Tool DataSource --%>
        <asp:SqlDataSource ID="sdsTool" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init" 
            SelectCommand=""
             DeleteCommand="DELETE MasterFile.MachineToolReq WHERE RecordID=@DRecordID">
         
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>

        <asp:ObjectDataSource ID="odsTool" runat="server" DataObjectTypeName="Entity.Machine+ProdRoutingStepBOM" TypeName="Entity.Machine+getStepProcessBOM" SelectMethod="getStepProcessBOM" InsertMethod="AddStepProcessBOM" UpdateMethod="UpdateStepProcessBOM" DeleteMethod="DeleteStepProcessBOM">
            <SelectParameters>
                <asp:Parameter Name="SKUCode" Type="String" />
                <asp:Parameter Name="StepSequence" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>



        <%-- Machine DataSource --%>
        <asp:SqlDataSource ID="sdsMachine" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" 
            SelectCommand=""
            InsertCommand="INSERT INTO Production.ProdRoutingStepMachine (SKUCode, StepSequence, StepCode, MachineType, Location, MachineRun, Unit, MachineCapacityQty, MachineCapacityUnit, CostPerUnit, HeaderID) VALUES (@ISKUCode, @IStepSequence, @IStepCode, @IMachineType, @ILocation, @IMachineRun, @IUnit, @IMachineCapacityQty, @IMachineCapacityUnit, @ICostPerUnit, @IHeaderID)" 
            UpdateCommand="UPDATE Production.ProdRoutingStepMachine SET StepSequence=@UStepSequence, StepCode=@UStepCode, MachineType=@UMachineType, Location=@ULocation, MachineRun=@UMachineRun, Unit=@UUnit, MachineCapacityQty=@UMachineCapacityQty, MachineCapacityUnit=@UMachineCapacityUnit, CostPerUnit=@UCostPerUnit WHERE RecordID=@ParamURecordID"
            DeleteCommand="DELETE Production.ProdRoutingStepMachine WHERE RecordID=@DRecordID">
            <InsertParameters>
                <asp:Parameter Name="IHeaderID" Type="String" />
                <asp:Parameter Name="ISKUCode" Type="String" />
                <asp:Parameter Name="IStepSequence" Type="String" />
                <asp:Parameter Name="IStepCode" Type="String" />
                <asp:Parameter Name="IMachineType" Type="String" />
                <asp:Parameter Name="ILocation" Type="String" />
                <asp:Parameter Name="IMachineRun" Type="String" />
                <asp:Parameter Name="IUnit" Type="String" />
                <asp:Parameter Name="IMachineCapacityQty" Type="String" />
                <asp:Parameter Name="IMachineCapacityUnit" Type="String" />
                <asp:Parameter Name="ICostPerUnit" Type="String" />
            </InsertParameters> 
            <UpdateParameters>
                <asp:Parameter Name="ParamURecordID" Type="String" />
                <asp:Parameter Name="UStepSequence" Type="String" />
                <asp:Parameter Name="UStepCode" Type="String" />
                <asp:Parameter Name="UMachineType" Type="String" />
                <asp:Parameter Name="ULocation" Type="String" />
                <asp:Parameter Name="UMachineRun" Type="String" />
                <asp:Parameter Name="UUnit" Type="String" />
                <asp:Parameter Name="UMachineCapacityQty" Type="String" />
                <asp:Parameter Name="UMachineCapacityUnit" Type="String" />
                <asp:Parameter Name="UCostPerUnit" Type="String" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <asp:ObjectDataSource ID="odsMachine" runat="server" DataObjectTypeName="Entity.Machine+ProdRoutingStepMachine" TypeName="Entity.Machine+getStepProcessMachine" SelectMethod="getStepProcessMachine" InsertMethod="AddStepProcessMachine" UpdateMethod="UpdateStepProcessMachine" DeleteMethod="DeleteStepProcessMachine">
            <SelectParameters>
                <asp:QueryStringParameter Name="SKUCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="StepSequence" SessionField="StepSequence" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>

        <%-- Manpower DataSource --%>
        <asp:SqlDataSource ID="sdsManpower" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init"
             SelectCommand=""
            InsertCommand="INSERT INTO Production.ProdRoutingStepManpower (SKUCode, StepSequence, StepCode, Designation, NoManpower, NoHour, StandardRate, StandardRateUnit, CostPerUnit, HeaderID) VALUES (@ISKUCode, @IStepSequence, @IStepCode, @IDesignation, @INoManpower, @INoHour, @IStandardRate, @IStandardRateUnit, @ICostPerUnit, @IHeaderID)" 
            UpdateCommand="UPDATE Production.ProdRoutingStepManpower SET StepSequence=@UStepSequence, StepCode=@UStepCode, Designation=@UDesignation, NoManpower=@UNoManpower, NoHour=@UNoHour, StandardRate=@UStandardRate, StandardRateUnit=@UStandardRateUnit, CostPerUnit=@UCostPerUnit WHERE RecordID=@ParamURecordID"
            DeleteCommand="DELETE Production.ProdRoutingStepManpower WHERE RecordID=@DRecordID">
            <InsertParameters>
                <asp:Parameter Name="IHeaderID" Type="String" />
                <asp:Parameter Name="ISKUCode" Type="String" />
                <asp:Parameter Name="IStepSequence" Type="String" />
                <asp:Parameter Name="IStepCode" Type="String" />
                <asp:Parameter Name="IDesignation" Type="String" />
                <asp:Parameter Name="INoManpower" Type="String" />
                <asp:Parameter Name="INoHour" Type="String" />
                <asp:Parameter Name="IStandardRate" Type="String" />
                <asp:Parameter Name="IStandardRateUnit" Type="String" />
                <asp:Parameter Name="ICostPerUnit" Type="String" />
            </InsertParameters> 
            <UpdateParameters>
                <asp:Parameter Name="ParamURecordID" Type="String" />
                <asp:Parameter Name="UStepSequence" Type="String" />
                <asp:Parameter Name="UStepCode" Type="String" />
                <asp:Parameter Name="UDesignation" Type="String" />
                <asp:Parameter Name="UNoManpower" Type="String" />
                <asp:Parameter Name="UNoHour" Type="String" />
                <asp:Parameter Name="UStandardRate" Type="String" />
                <asp:Parameter Name="UStandardRateUnit" Type="String" />
                <asp:Parameter Name="UCostPerUnit" Type="String" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <asp:ObjectDataSource ID="odsManpower" runat="server" DataObjectTypeName="Entity.Machine+ProdRoutingStepManpower" TypeName="Entity.Machine+getStepProcessManpower" SelectMethod="getStepProcessManpower" InsertMethod="AddStepProcessManpower" UpdateMethod="UpdateStepProcessManpower" DeleteMethod="DeleteStepProcessManpower">
            <SelectParameters>
                <asp:QueryStringParameter Name="SKUCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="StepSequence" SessionField="StepSequence" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>

        <%-- OtherMaterial DataSource --%>
        <asp:SqlDataSource ID="sdsOtherMaterials" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init"
            SelectCommand=""
            InsertCommand="INSERT INTO Production.ProdRoutingOtherMaterials (SKUCode, ItemCode, StepCode, Unit, ConsumptionPerProduct, TotalConsumption, PercentageAllowance, QtyAllowance, ClientSuppliedMaterial, EstimatedUnitCost, StandardUsage, StandardUsageUnit, Remarks, HeaderID) VALUES (@ISKUCode, @IItemCode, @IStepCode, @IUnit, @IConsumptionPerProduct, @ITotalConsumption, @IPercentageAllowance, @IQtyAllowance, @IClientSuppliedMaterial, @IEstimatedUnitCost, @IStandardUsage, @IStandardUsageUnit, @IRemarks, @IHeaderID)" 
            UpdateCommand="UPDATE Production.ProdRoutingOtherMaterials SET ItemCode=@UItemCode, StepSequence=@UStepSequence, StepCode=@UStepCode, Unit=@UUnit, ConsumptionPerProduct=@UConsumptionPerProduct, TotalConsumption=@UTotalConsumption, PercentageAllowance=@UPercentageAllowance, QtyAllowance=@UQtyAllowance, ClientSuppliedMaterial=@UClientSuppliedMaterial, EstimatedUnitCost=@UEstimatedUnitCost, StandardUsage=@UStandardUsage, StandardUsageUnit=@UStandardUsageUnit, Remarks=@URemarks WHERE RecordID=@ParamURecordID"
            DeleteCommand="DELETE Production.ProdRoutingOtherMaterials WHERE RecordID=@DRecordID">
            <InsertParameters>
                <asp:Parameter Name="IHeaderID" Type="String" />
                <asp:Parameter Name="ISKUCode" Type="String" />
                <asp:Parameter Name="IItemCode" Type="String" />
                <%--<asp:Parameter Name="IStepSequence" Type="String" />--%>
                <asp:Parameter Name="IStepCode" Type="String" />
                <asp:Parameter Name="IUnit" Type="String" />
                <asp:Parameter Name="IConsumptionPerProduct" Type="String" />
                <asp:Parameter Name="ITotalConsumption" Type="String" />
                <asp:Parameter Name="IPercentageAllowance" Type="String" />
                <asp:Parameter Name="IQtyAllowance" Type="String" />
                <asp:Parameter Name="IClientSuppliedMaterial" Type="String" />
                <asp:Parameter Name="IEstimatedUnitCost" Type="String" />
                <asp:Parameter Name="IStandardUsage" Type="String" />
                <asp:Parameter Name="IStandardUsageUnit" Type="String" />
                <asp:Parameter Name="IRemarks" Type="String" />
            </InsertParameters> 
            <UpdateParameters>
                <asp:Parameter Name="ParamURecordID" Type="String" />
                <asp:Parameter Name="UItemCode" Type="String" />
                <%--<asp:Parameter Name="UStepSequence" Type="String" />--%>
                <asp:Parameter Name="UStepCode" Type="String" />
                <asp:Parameter Name="UUnit" Type="String" />
                <asp:Parameter Name="UConsumptionPerProduct" Type="String" />
                <asp:Parameter Name="UTotalConsumption" Type="String" />
                <asp:Parameter Name="UPercentageAllowance" Type="String" />
                <asp:Parameter Name="UQtyAllowance" Type="String" />
                <asp:Parameter Name="UClientSuppliedMaterial" Type="String" />
                <asp:Parameter Name="UEstimatedUnitCost" Type="String" />
                <asp:Parameter Name="UStandardUsage" Type="String" />
                <asp:Parameter Name="UStandardUsageUnit" Type="String" />
                <asp:Parameter Name="URemarks" Type="String" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <asp:ObjectDataSource ID="odsOtherMaterials" runat="server" DataObjectTypeName="Entity.Machine+ProdRoutingOtherMaterial" TypeName="Entity.Machine+getOtherMaterial" SelectMethod="getOtherMaterial" InsertMethod="AddOtherMaterial" UpdateMethod="UpdateOtherMaterial" DeleteMethod="DeleteOtherMaterial">
            <SelectParameters>
                <asp:QueryStringParameter Name="SKUCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>
    </form>
</body>
</html>
