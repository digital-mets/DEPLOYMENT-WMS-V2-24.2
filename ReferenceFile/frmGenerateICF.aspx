<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmGenerateICF.aspx.cs" Inherits="GWL.frmGenerateICF" %>

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
            height: 250px; /*Change this whenever needed*/
            }

            .Entry {
             padding: 20px;
             margin: 10px auto;
             background: #FFF;
            }

            .invalidlength *
            {
                background-color:#FFCCCC !important;
            }

            .validlength
            {
                background-color:transparent; 
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
       var isValid = false;
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
               console.log(s.GetText());
               console.log(e.value);
           }
           else {
               isValid = true;
           }
       }

       function OnUpdateClick(s, e) { //Add/Edit/Close button function
           
           cp.PerformCallback('update');
       }

       function OnConfirm(s, e) {//function upon saving entry
           if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
               e.cancel = true;
       }

       function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
           //console.log(cboItemCategory.GetValue())
           if (s.cp_confirm != null) {
               if (confirm(s.cp_confirm)) {
                   cp.PerformCallback('Confirmed');
               }
               else {
                   alert('Action cancelled');
               }
               delete (s.cp_confirm);
           }
           if (s.cp_message != null) {
               alert(s.cp_message);
               delete (s.cp_message);
           }
           if (s.cp_success) {
               var txtcode = txtItemCode.GetText().toUpperCase();
               var prodcat = txtProductCategory.GetText().toUpperCase();
               var prodsub = txtProductSubCategory.GetText().toUpperCase();
               if (typeof txtKeySupplier !== "undefined" && ASPxClientUtils.IsExists(txtKeySupplier))
                   var sup = txtKeySupplier.GetText().toUpperCase();

               window.open("frmItemMasterfile.aspx?entry=N&transtype=RELITEM&parameters=" + s.cp_param + "&iswithdetail=false&docnumber=" + txtcode
                   + '&itemcat=' + cboItemCategory.GetValue() + '&prodcat=' + prodcat + '&prodsub=' + prodsub + '&sup=' + sup + '&conf=1', '_self');
               delete (s.cp_param);
           }
       }

       function getParameterByName(name) {
           name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
           var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
               results = regex.exec(location.search);
           return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
       }



       //function LengthValidation(s, e)
       //{
       //        var value = s.GetValue();
       //        var objInst = CINColorCode.GetMainElement();
       //        var str = CINColorCode.GetText();
       //        var count = str.length;
       //        if (count > 19) {
       //            if (objInst.className.indexOf('invalidlength') == -1) {
       //                objInst.className += ' invalidlength';
       //            }
       //        }  
       //        else if(count < 20)
       //        {
       //            console.log('HI')
       //            if (objInst.className.indexOf('validlength') == -1) {
       //                objInst.className += ' validlength';
       //            } 
       //        }
       //}

       function OnInitTrans(s, e) {
           AdjustSize();
       }

       function OnControlsInitialized(s, e) {
           ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
               AdjustSize();
           });
       }

       function AdjustSize() {
           //var width = Math.max(0, document.documentElement.clientWidth);
           //gv1.SetWidth(width - 120);
       }
    </script>
    <!--#endregion-->
</head>
<body style="height: 910px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" ID="headerlabel" Text="Generate Fabric" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
        <%--<!--#region Region Factbox --> --%><%--<!--#endregion --> --%>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" Style="margin-left: -3px; margin-right: 0px;">
                        <%--<SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />--%>
                        <Items>
                            <%--<!--#region Region Header --> --%>
                            
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="Header">
                                        <Items>
                                            <dx:LayoutGroup Caption="Generate Item Code" ColCount="2" width="1100">
                                                <Items>
                                                    <dx:LayoutItem Caption="Item Category">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td style="padding-left:17px"><dx:ASPxComboBox TextField="Description" ValueField="ItemCategoryCode" ValueType="System.String"
                                                                             ID="cboItemCategory" ClientInstanceName="cboItemCategory" DataSourceID="ItemCategoryCodeLookup" runat="server" Width="222px" ViewStateMode="Disabled" >
                                                                        </dx:ASPxComboBox>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Item Code">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtItemCode" ClientInstanceName="txtItemCode" ReadOnly="true" runat="server" Width="222px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Product Category">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td style="padding-left:17px"><dx:ASPxGridLookup DataSourceID="ProductCategoryLookUp" TextFormatString="{0}" AutoGenerateColumns="false"
                                                                             KeyFieldName="ProductCategoryCode" ID="txtProductCategory" runat="server" Width="70px" OnInit="txtProductCategory_Init"
                                                                             ClientInstanceName="txtProductCategory">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('prodcat')}" DropDown="function(){txtProductCategory.GetGridView().PerformCallback('prodcat')}" />
<GridViewProperties>
<SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
</GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataColumn FieldName="ProductCategoryCode"></dx:GridViewDataColumn>
                                                                                <dx:GridViewDataColumn FieldName="Description"></dx:GridViewDataColumn>
                                                                            </Columns>
                                                                                                      </dx:ASPxGridLookup>
                                                                        </td>
                                                                        <td  style="padding-left:2px"><dx:ASPxTextBox ID="txtProductCategoryDesc" runat="server" Width="150px" ReadOnly="true"></dx:ASPxTextBox></td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Key Supplier" Name="lblKeySupplier">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td><dx:ASPxGridLookup DataSourceID="Masterfilesup" TextFormatString="{0}" AutoGenerateColumns="false"
                                                                             KeyFieldName="SupplierCode" ID="txtKeySupplier" runat="server" Width="70px"
                                                                             ClientInstanceName="txtKeySupplier" GridViewProperties-Settings-ShowFilterRow="true">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('keysupp')}"/>
<GridViewProperties>
<SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>

<Settings ShowFilterRow="True"></Settings>
</GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Address" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                                                      </dx:ASPxGridLookup></td>
                                                                        <td  style="padding-left:2px"><dx:ASPxTextBox ID="txtSuppName" runat="server" Width="150px" ReadOnly="true"></dx:ASPxTextBox></td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Product Sub Category">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td style="padding-left:17px"><dx:ASPxGridLookup DataSourceID="ProductSubCategoryLookUp" TextFormatString="{0}" AutoGenerateColumns="false" 
                                                                            ClientInstanceName="txtProductSubCategory" KeyFieldName="ProductSubCatCode" ID="txtProductSubCategory" runat="server" Width="70px" OnInit="txtProductCategory_Init">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('prodsub')}" DropDown="function(){txtProductSubCategory.GetGridView().PerformCallback('prodsubcat')}" />
<GridViewProperties>
<SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
</GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataColumn FieldName="ProductSubCatCode"></dx:GridViewDataColumn>
                                                                                <dx:GridViewDataColumn FieldName="Description"></dx:GridViewDataColumn>
                                                                            </Columns>
                                                                                                      </dx:ASPxGridLookup></td>
                                                                        <td  style="padding-left:2px"><dx:ASPxTextBox ID="txtProductSubCategoryDesc" runat="server" Width="150px" ReadOnly="true"></dx:ASPxTextBox></td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Customer" Name="lblCustomer">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td><dx:ASPxTextBox ID="txtCustomer" runat="server" Width="70px"></dx:ASPxTextBox></td>
                                                                        <td  style="padding-left:2px"><dx:ASPxTextBox ID="txtMnemonics" runat="server" Width="150px" ReadOnly="true">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('customer');}" />
                                                                                                      </dx:ASPxTextBox></td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%--<dx:EmptyLayoutItem>
                                                    </dx:EmptyLayoutItem>
                                                    <dx:LayoutItem ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxButton ID="frmlayout1_E1" runat="server" Text="Generate">
                                                                </dx:ASPxButton>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Generate Item Code (Stock Master)" ColCount="2" Name="expStockMaster">
                                                <Items>
                                                    <dx:LayoutItem Caption="Product Group">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td>
                                                                            <dx:ASPxGridLookup DataSourceID="ProdGroupLookup" TextFormatString="{0}" AutoGenerateColumns="false" 
                                                                            ClientInstanceName="txtProductGroup" KeyFieldName="ProductGroupCode" ID="txtProductGroup" runat="server" Width="85px" OnInit="txtProductCategory_Init">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('textchanged')}" DropDown="function(){txtProductGroup.GetGridView().PerformCallback('prodgroup')}" />
<GridViewProperties>
<SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
</GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataColumn FieldName="ProductGroupCode"></dx:GridViewDataColumn>
                                                                                <dx:GridViewDataColumn FieldName="Description"></dx:GridViewDataColumn>
                                                                            </Columns>
                                                                           </dx:ASPxGridLookup>
                                                                        </td>
                                                                        <td style="padding-left:2px">
                                                                            <dx:ASPxTextBox ID="txtProductGroupDesc" runat="server" Width="135px" ReadOnly="true"></dx:ASPxTextBox ></td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="PIS Number">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <table>
                                                                            <tr>
                                                                                <td style="padding-left:3px"><%--<dx:ASPxTextBox ID="txtPIS" runat="server" Width="222px" ReadOnly="true">
                                                                                    <ClientSideEvents ValueChanged="function(){cp.PerformCallback('pis');}" />
                                                                                                             </dx:ASPxTextBox>--%>
                                                                                <dx:ASPxGridLookup DataSourceID="PISLookup" TextFormatString="{0}" AutoGenerateColumns="false" 
                                                                                ClientInstanceName="txtPIS" KeyFieldName="PISNumber" ID="txtPIS" runat="server" Width="135px" OnInit="txtProductCategory_Init">
                                                                                <ClientSideEvents TextChanged="function(){cp.PerformCallback('pis')}" DropDown="function(){txtPIS.GetGridView().PerformCallback('pis')}" />
                                                                                <Columns>
                                                                                    <dx:GridViewDataColumn FieldName="PISNumber"></dx:GridViewDataColumn>
                                                                                    <dx:GridViewDataColumn FieldName="PISDescription"></dx:GridViewDataColumn>
                                                                                </Columns>
                                                                               </dx:ASPxGridLookup>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Brand">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td><dx:ASPxGridLookup DataSourceID="BrandLookup" TextFormatString="{0}" AutoGenerateColumns="false" 
                                                                            ClientInstanceName="txtBrand" KeyFieldName="BrandCode" ID="txtBrand" runat="server" Width="85px">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('brand')}" />
<GridViewProperties>
<SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
</GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataColumn FieldName="BrandCode"></dx:GridViewDataColumn>
                                                                                <dx:GridViewDataColumn FieldName="BrandName"></dx:GridViewDataColumn>
                                                                            </Columns>
                                                                           </dx:ASPxGridLookup></td>
                                                                        <td style="padding-left:2px"><dx:ASPxTextBox ID="txtBrandDesc" runat="server" Width="135px" ReadOnly="true"></dx:ASPxTextBox></td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem ShowCaption="False" Paddings-PaddingLeft="75px">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxLabel runat="server" Text="Use this if there is an available Techpack">
                                                                </dx:ASPxLabel>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>

<Paddings PaddingLeft="75px"></Paddings>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Gender">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td><dx:ASPxGridLookup DataSourceID="GenderLookup" TextFormatString="{0}" AutoGenerateColumns="false" 
                                                                            ClientInstanceName="txtGender" KeyFieldName="GenderCode" ID="txtGender" runat="server" Width="85px">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('gender')}" />
                                                                            <GridViewProperties>
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataColumn FieldName="GenderCode"></dx:GridViewDataColumn>
                                                                                <dx:GridViewDataColumn FieldName="Description"></dx:GridViewDataColumn>
                                                                            </Columns>
                                                                           </dx:ASPxGridLookup></td>
                                                                        <td style="padding-left:2px"><dx:ASPxTextBox ID="txtGenderDesc" runat="server" Width="135px" ReadOnly="true">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('gender');}" />
                                                                                                     </dx:ASPxTextBox></td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td style="padding-left:71px"><dx:ASPxCheckBox runat="server" ID="isSecondQuality">
                                                                                <ClientSideEvents CheckedChanged="function(){cp.PerformCallback('secondQual');}" /> 
                                                                         </dx:ASPxCheckBox>
                                                                        </td>
                                                                        <td  style="padding-left:2px"><dx:ASPxLabel runat="server" Text="Second Quality"></dx:ASPxLabel></td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Delivery">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td><dx:ASPxTextBox ID="txtDeliveryYear" runat="server" Width="85px" MaxLength="4">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('delivery');}" />
                                                                            </dx:ASPxTextBox></td>
                                                                        <td style="padding-left:2px">
                                                                            <dx:ASPxComboBox ID="cboDeliveryMonth" runat="server" Width="135px" DataSourceID="Months"
                                                                                ValueField="Code" TextField="Description">
                                                                                <ClientSideEvents ValueChanged="function(){cp.PerformCallback('month');}" />
                                                                            </dx:ASPxComboBox></td>
                                                                        <td style="padding-left:10px">OR</td>
                                                                        <td style="padding-left:15px"><dx:ASPxCheckBox ID="chkIsCollection" runat="server" Text="Collection" TextAlign="Right" >
                                                                            <ClientSideEvents CheckedChanged="function(){cp.PerformCallback();}" />
                                                                                                      </dx:ASPxCheckBox></td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td style="padding-left:3px"><dx:ASPxTextBox ID="txtCollection" runat="server" AutoCompleteType="None" ClientEnabled="false">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('collection');}" />
                                                                                                     </dx:ASPxTextBox></td>
                                                                        <td><-2 Letter Collection Abbreviation</td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Fit Code/Fit">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td><dx:ASPxGridLookup DataSourceID="FITLookup" TextFormatString="{0}" AutoGenerateColumns="false" 
                                                                            ClientInstanceName="txtFit" KeyFieldName="FitCode" ID="txtFit" runat="server" Width="85px" OnInit="txtProductCategory_Init">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('fit')}" 
                                                                                DropDown="function(){txtFit.GetGridView().PerformCallback('fit')}"/>
                                                                                <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                                                                </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataColumn FieldName="FitCode"></dx:GridViewDataColumn>
                                                                                <dx:GridViewDataColumn FieldName="FitName"></dx:GridViewDataColumn>
                                                                            </Columns>
                                                                           </dx:ASPxGridLookup></td>
                                                                        <td style="padding-left:2px"><dx:ASPxTextBox ID="txtFitDesc" runat="server" Width="135px" ReadOnly="true"></dx:ASPxTextBox></td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td style="padding-left:71px"><asp:CheckBox ID="chkOverRide" runat="server" /></td>
                                                                        <td  style="padding-left:2px"><dx:ASPxLabel runat="server" Text="Use This ItemCode"></dx:ASPxLabel></td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Product Design Category">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td><dx:ASPxGridLookup DataSourceID="DesCatLookup" TextFormatString="{0}" AutoGenerateColumns="false"  OnInit="txtProductCategory_Init" 
                                                                            ClientInstanceName="txtDesignCategory" KeyFieldName="CategoryCode" ID="txtDesignCategory" runat="server" Width="85px">
                                                                                <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                                                                </GridViewProperties>
                                                                                <Columns>
                                                                                    <dx:GridViewDataColumn FieldName="CategoryCode"></dx:GridViewDataColumn>
                                                                                    <dx:GridViewDataColumn FieldName="Description"></dx:GridViewDataColumn>
                                                                                </Columns>
                                                                                <ClientSideEvents TextChanged="function(){cp.PerformCallback('designcat')}" 
                                                                                    DropDown="function(){txtDesignCategory.GetGridView().PerformCallback('designcat')}"/>
                                                                            </dx:ASPxGridLookup>
                                                                           </td>
                                                                        <td style="padding-left:2px"><dx:ASPxTextBox ID="txtDesignCategoryDesc" runat="server" Width="135px" ReadOnly="true"></dx:ASPxTextBox></td>
                                                                        <td style="padding-left:10px">(Tops and Acc Only)</td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td style="padding-left:75px"><dx:ASPxTextBox ID="txtOverRide" runat="server" Width="175px"></dx:ASPxTextBox></td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Color" ColSpan="2">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td><dx:ASPxGridLookup DataSourceID="ColorLookup" TextFormatString="{0}" AutoGenerateColumns="false" OnInit="txtProductCategory_Init" 
                                                                            ClientInstanceName="txtColor" KeyFieldName="ColorCode" ID="txtColor" runat="server" Width="85px">
                                                                                <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                                                                </GridViewProperties>
                                                                                <Columns>
                                                                                    <dx:GridViewDataColumn FieldName="ColorCode"></dx:GridViewDataColumn>
                                                                                    <dx:GridViewDataColumn FieldName="Description"></dx:GridViewDataColumn>
                                                                                </Columns>
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('color')}" 
                                                                                DropDown="function(){txtColor.GetGridView().PerformCallback('color')}"/>
                                                                            </dx:ASPxGridLookup></td>
                                                                        <td style="padding-left:2px"><dx:ASPxTextBox ID="txtColorDesc" runat="server" Width="135px" ReadOnly="true"></dx:ASPxTextBox></td>
                                                                        <td style="padding-left:10px">(Tops and Acc Only and Non Denim Only)</td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                   <%-- <dx:EmptyLayoutItem></dx:EmptyLayoutItem>--%>
                                                    <dx:LayoutItem Caption="Color Name" ColSpan="2">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td><dx:ASPxTextBox ID="txtColorName" runat="server" Width="222px"></dx:ASPxTextBox></td>
                                                                        <td style="padding-left:10px"><- User defined color that will appear on reports</td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Retail Fabric Code" ColSpan="2">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td><dx:ASPxTextBox ID="txtRetailFabricCode" runat="server" Width="222px">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback();}" />
                                                                            </dx:ASPxTextBox></td>
                                                                        <td style="padding-left:10px">(Bottoms)</td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Wash Code" ColSpan="2">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td><dx:ASPxGridLookup DataSourceID="WashLookup" TextFormatString="{0}" AutoGenerateColumns="false" 
                                                                            ClientInstanceName="txtWashCode" KeyFieldName="WashCode" ID="txtWashCode" runat="server" Width="85px">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('wash')}" />
                                                                            <GridViewProperties>
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataColumn FieldName="WashCode"></dx:GridViewDataColumn>
                                                                                <dx:GridViewDataColumn FieldName="Description"></dx:GridViewDataColumn>
                                                                            </Columns>
                                                                           </dx:ASPxGridLookup>
                                                                        </td>
                                                                        <td style="padding-left:2px"><dx:ASPxTextBox ID="txtWashDesc" runat="server" Width="400px" ReadOnly="true"></dx:ASPxTextBox></td>
                                                                        <td style="padding-left:10px">(Bottoms)</td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Tint Code" ColSpan="2">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td><dx:ASPxGridLookup DataSourceID="TintLookup" TextFormatString="{0}" AutoGenerateColumns="false" 
                                                                            ClientInstanceName="txtTintCode" KeyFieldName="TintCode" ID="txtTintCode" runat="server" Width="85px">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('tint')}" />
                                                                            <GridViewProperties>
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataColumn FieldName="TintCode"></dx:GridViewDataColumn>
                                                                                <dx:GridViewDataColumn FieldName="Description"></dx:GridViewDataColumn>
                                                                            </Columns>
                                                                           </dx:ASPxGridLookup>
                                                                           </td>
                                                                        <td style="padding-left:2px"><dx:ASPxTextBox ID="txtTintDesc" runat="server" Width="155px" ReadOnly="true"></dx:ASPxTextBox></td>
                                                                        <td style="padding-left:10px">(Tops and Acc Only and Non Denim Only)</td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Imported Item" ColSpan="2">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td><dx:ASPxTextBox ID="txtImportedItem" runat="server" Width="65px">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('textchanged');}" />
                                                                            </dx:ASPxTextBox></td>
                                                                        <td style="padding-left:10px">(Accessories Only)</td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Generate Item Code (Fabric)" Name="expFabric">
                                                <Items>
                                                    <dx:LayoutItem Caption="Short Description" Name="lblDescription">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td style="padding-left:40px"><dx:ASPxTextBox ID="txtShortDescription" runat="server" Width="222px" >
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('textchanged')}" />
                                                                                                      </dx:ASPxTextBox></td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Generate Item Code (Accessories)" ColCount="2" Name="expAccessories">
                                                <Items>
                                                    <dx:LayoutItem Caption="Supplier Item Code" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td style="padding-left:29.5px"><dx:ASPxTextBox ID="txtSupplierItemCode" runat="server" Width="222px">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('textchanged')}" />
                                                                                                        </dx:ASPxTextBox></td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Brand">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td><dx:ASPxTextBox ID="txtBrand2" runat="server" Width="65px">
                                                                            <ClientSideEvents TextChanged="function(){cp.PerformCallback('textchanged');}" />
                                                                            </dx:ASPxTextBox></td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                </Items>
                            </dx:TabbedLayoutGroup>
                            <%-- <!--#endregion --> --%>

                            <%--<!--#region Region Details --> --%>


                            <%-- <!--#endregion --> --%>
                        </Items>
                    </dx:ASPxFormLayout>
                     <dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                <dx:ASPxButton ID="updateBtn" runat="server" Text="Continue" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
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
        
    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.ItemAdjustment" DataObjectTypeName="Entity.ItemAdjustment" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="" Name="DocNumber" SessionField="DocNumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ItemAdjustment+ItemAdjustmentDetail" DataObjectTypeName="Entity.ItemAdjustment+ItemAdjustmentDetail" DeleteMethod="DeleteItemAdjustmentDetail" InsertMethod="AddItemAdjustmentDetail" UpdateMethod="UpdateItemAdjustmentDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="DocNumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  wms.ItemAdjustmentDetail where DocNumber  is null " >
  
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] where isnull(IsInactive,'')=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [ColorCode], [ClassCode],[SizeCode] FROM Masterfile.[ItemDetail] where isnull(IsInactive,'')=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Warehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WareHouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,'')=0" OnInit="Connection_Init"></asp:SqlDataSource>
   <asp:SqlDataSource ID="ItemAdjustment" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT AdjustmentCode,TransType FROM Masterfile.[AdjustmentType]" OnInit="Connection_Init"></asp:SqlDataSource>
  
    <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilesup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select SupplierCode,Name,Address from masterfile.BPSupplierInfo where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
     <%--Color Group Look Up--%>
    <asp:SqlDataSource ID="ColorGroupLookUp" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ColorGroup,Description FROM Masterfile.ColorGroup WHERE ISNULL([IsInactive],0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <%--Item Category Code Look Up--%>
    <asp:SqlDataSource ID="ItemCategoryCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT *  FROM MasterFile.ItemCategory WHERE ISNULL(IsInactive,0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <%--Product Category Look Up--%>
    <asp:SqlDataSource ID="ProductCategoryLookUp" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ProductCategoryCode,Description FROM Masterfile.ProductCategory WHERE ISNULL([IsInactive],0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <%--Product Sub Category Look Up--%>
    <asp:SqlDataSource ID="ProductSubCategoryLookUp" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ProductSubCatCode,Description FROM Masterfile.ProductCategorySub WHERE ISNULL([IsInactive],0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <%--Product Sub Category Look Up--%>
    <asp:SqlDataSource ID="ProdGroupLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ProductGroupCode,Description FROM Masterfile.ProductGroup WHERE ISNULL([IsInactive],0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="BrandLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM MasterFile.Brand WHERE ISNULL(IsInactive,0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="GenderLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select * from masterfile.Gender WHERE ISNULL(IsInactive,0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="PISLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="FITLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select * From masterfile.Fit"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="ColorLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select * from masterfile.Color"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DesCatLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * FROM MasterFile.DesignCategory"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="WashLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>"
        SelectCommand="SELECT * FROM MasterFile.Wash WHERE ISNULL(IsInactive,0)=0" OnInit = "Connection_Init">
    </asp:SqlDataSource>    
    <asp:SqlDataSource ID="TintLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>"
        SelectCommand="select TintCode,Description from masterfile.Tint where ISNULL(IsInactive,0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>       
    <asp:ObjectDataSource ID="Months" runat="server" SelectMethod="Months" TypeName="Common.Common"></asp:ObjectDataSource>
    </form>

     <!--#endregion-->
</body>
</html>


