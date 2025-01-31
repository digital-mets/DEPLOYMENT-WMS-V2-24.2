<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="wc_UpldSignPopup.ascx.cs" Inherits="GWL.WebControl.wc_UpldSignPopup" %>
<%@ Register Assembly="DevExpress.XtraReports.v24.2.Web.WebForms, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraReports.Web" TagPrefix="dx" %>

<header>
    <style>
        .rootGroup > div:first-child {
            border-right: 1px solid #9f9f9f;
        }

        .dx-designer-viewport .dxd-back-primary-invariant {
            background-color: #ffffff;
            margin: -70px -2px 0;
        }

        /*  .my-container {
            padding-left: 500px;
        }*/

        .dxichTextCellSys {
            font-style: italic !important;
        }
    </style>
    <script>
        let fname = "";
        let cptur = "";
        async function setUser(s, e) {
            try {
                // Await the completion of PerformCallback (assuming it returns a Promise)
                await new Promise((resolve, reject) => {
                    // PerformCallback would trigger resolve when it's complete
                    cpt.PerformCallback('Globals', function () {
                        resolve(); // Resolve the promise when the callback is complete
                    });
                });

                // Now that the callback is complete, call the onClick function
                await onClick(s, e);
            } catch (error) {
                console.error("An error occurred:", error);
            }
        }

        async function onClick(s, e) {
            fname = FullNameSign.GetText();
            cptur = capturedSign.GetText();
            try {
                // Perform your custom document operation
                var p = await viewer.PerformCustomDocumentOperation();
                cpt.PerformCallback(`Vals|${fname}|${cptur}`);
                // Trigger the button click once the operation is complete
                btn.DoClick();
            } catch (error) {
                console.error("An error occurred:", error);
            }
        }
        function onInit(s, e) {


            $('.dxrd-preview-wrapper').css('top', 1);
        }
        function customizeElements(s, e) {

            var toolbarPart = e.GetById(DevExpress.Reporting.Viewer.PreviewElements.Toolbar);
            var index = e.Elements.indexOf(toolbarPart);

            var viewer = s.GetMainElement();  // Get the main element
            //viewer.style.width = '400px'; // Set the report's width
            viewer.style.height = '250px'; // Set the report's height
            //viewer.style.padding-top = '-10px';
            e.Elements.splice(index, 1);
            toolbarPart = e.GetById(DevExpress.Reporting.Viewer.PreviewElements.RightPanel);
            index = e.Elements.indexOf(toolbarPart);
            e.Elements.splice(index, 1);
        }
        function Hide(s, e) {
            //formSign.FindItemOrGroupByName("SignBut").Visible = false;
            //formSign.FindItemOrGroupByName("SignCon").Visible = false;  
            //console.log(s.GetChecked())

            var SignCon = formSign.GetItemByName('SignCon');
            var SignBut = formSign.GetItemByName('SignBut');
            SignCon.SetVisible(s.GetChecked());
            SignBut.SetVisible(s.GetChecked());
        }

        function cpt_endCallback(s, e) {

            console.log('nagend');
        }

        function OnConsent() {
            console.log(ClientCheckBox.GetChecked());
            console.log();
            if (ClientCheckBox.GetChecked() == true) {
                btnCapture.SetEnabled(true);
            }
            else {
                btnCapture.SetEnabled(false);
            }
        };

        //function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
        //    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
        //    if (keyCode == 13)
        //        gv1.batchEditApi.EndEdit();
        //    //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        //}

        //function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
        //    setTimeout(function () {
        //        gv1.batchEditApi.EndEdit();
        //    }, 500);
        //}

        //function updateLook(data) {
        //    if (data == "GetData") {
        //        cpt.PerformCallback(data);
        //    } else if (data == "ChangeValue") {
        //        cpt.PerformCallback(data);
        //    }
        //}
    </script>
</header>
<body>
    <dx:ASPxPopupControl ID="UpldSignPopup" runat="server" ClientInstanceName="UpldSignPopup"
        CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
        HeaderText="Capturing Signature"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
        AllowDragging="True" PopupAnimationType="None" EnableViewState="False" ScrollBars="Vertical" Height="400px" Width="700px">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxCallbackPanel ID="cpt" runat="server" OnCallback="cpt_Callback" ClientInstanceName="cpt">
                    <ClientSideEvents
                        EndCallback="cpt_endCallback" />
                    <PanelCollection>
                        <dx:PanelContent runat="server">
                            <dx:ASPxFormLayout runat="server" ID="formSign" ClientInstanceName="formSign" CssClass="formSign" Width="100%">
                                <%--  <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="1000" />--%>
                                <Items>
                                    <dx:LayoutGroup ColumnCount="1" UseDefaultPaddings="false" GroupBoxDecoration="None" ShowCaption="False" CssClass="rootGroup">
                                        <Items>
                                            <dx:LayoutGroup Caption="SIGNATORY INFORMATION" ColCount="1" UseDefaultPaddings="false" Paddings-PaddingTop="0">
                                                <Paddings PaddingTop="10px" PaddingRight="10px" PaddingBottom="10px" PaddingLeft="10px"></Paddings>
                                                <Items>
                                                    <dx:LayoutItem Caption="User ID">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <dx:ASPxTextBox ID="signUserid" runat="server" ClientInstanceName="signUserid" Width="100%">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- <dx:LayoutItem Caption="Current DocNumber">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer>
                                    <dx:ASPxTextBox ID="signDocNumber" runat="server" ClientInstanceName="signDocNumber">
                                    </dx:ASPxTextBox>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>--%>
                                                    <%--  <dx:LayoutItem Caption="Transtype" Name="TranstypeSign">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxTextBox ID="txtTranstypeSign" runat="server" ClientInstanceName="txtTranstypeSign">
                                        </dx:ASPxTextBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>--%>
                                                    <dx:LayoutItem Caption="FullName">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <dx:ASPxTextBox ID="FullNameSign" runat="server" ClientInstanceName="FullNameSign" ReadOnly="true" Width="100%">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Signature Captured">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <dx:ASPxTextBox ID="capturedSign" runat="server" ClientInstanceName="capturedSign" ReadOnly="true" Width="100%">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="PIN">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <dx:ASPxTextBox ID="txtPin" runat="server" ClientInstanceName="txtPin" TextMode="Password" ReadOnly="false" Width="100%" />
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%--<dx:LayoutItem Caption="Report Name">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server">
                                    <dx:ASPxGridLookup ID="txtReport" runat="server" AutoGenerateColumns="False"  KeyFieldName="ReportName" Width="170px">
                                        <GridViewProperties>
                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                            <Settings ShowFilterRow="True" />
                                        </GridViewProperties>
                                        <Columns>
                                            <dx:GridViewDataTextColumn Caption="Reports" FieldName="ReportName" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                          <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="function(s,e){updateLook('GetData')}" ValueChanged="function(s,e){updateLook('ChangeValue')}" />
                                    </dx:ASPxGridLookup>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                          <dx:LayoutItem Caption="Signature Field">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server">
                                    <dx:ASPxGridLookup ID="txtSignField" runat="server" AutoGenerateColumns="False"  KeyFieldName="SignField" Width="170px">
                                        <GridViewProperties>
                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                            <Settings ShowFilterRow="True" />
                                        </GridViewProperties>
                                        <Columns>
                                            <dx:GridViewDataTextColumn Caption="Signature Fields" FieldName="SignField" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                          <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" />
                                    </dx:ASPxGridLookup>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>--%>
                                                    <%--    <dx:LayoutItem Caption="Signature Captured">
                             <LayoutItemNestedControlCollection>
                                 <dx:LayoutItemNestedControlContainer runat="server">
                                     <dx:ASPxCheckBox ID="captured" runat="server" ClientInstanceName="captured" CheckState="Unchecked" Enabled="false" Text=" ">
                                         <ClientSideEvents CheckedChanged="Hide" />
                                     </dx:ASPxCheckBox>
                                 </dx:LayoutItemNestedControlContainer>
                             </LayoutItemNestedControlCollection>
                         </dx:LayoutItem>--%>
                                                    <%--      <dx:LayoutItem Caption="Recapture Signature">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxCheckBox ID="Recapture" runat="server" ClientInstanceName="Recapture" CheckState="Unchecked" Text=" ">
                                            <ClientSideEvents CheckedChanged="Hide" />
                                        </dx:ASPxCheckBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>--%>
                                                    <dx:LayoutItem Caption="Signature">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                              <%--  <dx:ASPxWebDocumentViewer ID="ASPxWebDocumentViewer2" Width="100%" Height="280px" ClientInstanceName="viewer" runat="server" ColorScheme="dark" ReportSourceId="GWL.WebReports.GEARS_Printout.P_Signtest">
                                                                    <ClientSideEvents CustomizeElements="customizeElements" />
                                                                    <ClientSideEvents Init="onInit" />
                                                                </dx:ASPxWebDocumentViewer>--%>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="" ShowCaption="False" Name="SignCon">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <dx:ASPxWebDocumentViewer ID="ASPxWebDocumentViewer1" Width="100%" Height="280px" ClientInstanceName="viewer" runat="server" ColorScheme="dark" ReportSourceId="GWL.WebReports.GEARS_Printout.P_Signtest">
                                                                    <ClientSideEvents CustomizeElements="customizeElements" />
                                                                    <ClientSideEvents Init="onInit" />
                                                                </dx:ASPxWebDocumentViewer>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem ShowCaption="False" Name="SignBut">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <div class="my-container" style="padding: 0px 20px 20px 20px;font-style: italic;margin-top: -60px;position: relative;z-index: 1000 !important;">
                                                                    <dx:ASPxCheckBox ID="checkbox" ClientInstanceName="ClientCheckBox" runat="server" Checked="false" Text="&quot;I consent to providing my e-signature, which will be securely stored and reused for future transactions in accordance with applicable laws and regulations.&quot;">
                                                                        <ClientSideEvents ValueChanged="function(s, e){ OnConsent(); }" />
                                                                    </dx:ASPxCheckBox>
                                                                </div>
                                                                <div class="my-container" style="justify-content: center; display: flex;">
                                                                    <dx:ASPxButton ID="ASPxButton2" runat="server" AutoPostBack="False" Text="Capture" ClientEnabled="false" ClientInstanceName="btnCapture">
                                                                        <ClientSideEvents Click="onClick" />
                                                                    </dx:ASPxButton>
                                                                </div>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Captured Signature" ColCount="1" GroupBoxDecoration="HeadingLine" Width="100%" UseDefaultPaddings="false" CssClass="rootGroup">
                                                <Paddings PaddingLeft="15px"></Paddings>
                                                <GroupBoxStyle>
                                                    <Caption>
                                                        <Paddings PaddingLeft="15px" />
                                                    </Caption>
                                                </GroupBoxStyle>
                                                <Items>
                                                    <dx:LayoutItem Caption="Signature" ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <dx:ASPxLabel runat="server" ID="SignatureLabel" CssClass="dxflFormLayout">
                                                                </dx:ASPxLabel>
                                                                <dx:ASPxBinaryImage ID="binaryImage" runat="server" Height="200px" Width="100%" Enabled="false">
                                                                </dx:ASPxBinaryImage>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:EmptyLayoutItem Height="29px" />
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                </Items>
                            </dx:ASPxFormLayout>
                            <dx:ASPxButton ID="btn" runat="server" AutoPostBack="false" OnClick="ASPxButton2_Click" ClientInstanceName="btn" ClientVisible="false" />
                            <%--       <dx:ASPxTextBox ID="txtMode" runat="server" Width="100px" ClientInstanceName="UpldDocsMode" 
                                Text="UPLOAD" ClientEnabled="false" ClientVisible="false" />--%>
                            <%--2023-12-04  TL  For Auxiliary Docs--%>
                            <%--    <dx:ASPxTextBox ID="txtDocType" runat="server" Width="100px" ClientInstanceName="UpldDocsDocType" 
                                Text="MAIN" ClientEnabled="false" ClientVisible="false" />--%>
                            <%--2023-12-04  TL  (End)--%>
                            <%--    <dx:ASPxDateEdit ID="dteDocDate" runat="server" Width="100px" ClientInstanceName="UpldDocsDocDate" 
                                ClientEnabled="false" ClientVisible="false" />--%>
                            <%-- <table>
                                <tr>
                                    <td style="padding-right:7px;">
                                    <dx:ASPxLabel runat="server" Text="Transaction:" Width="70px" />
                                    </td>
                                    <td style="padding-right:7px;">
                                    <dx:ASPxTextBox ID="txtTransType" runat="server" Width="120px" ClientInstanceName="UpldDocsTranType"
                                        DisabledStyle-ForeColor="Black" ClientEnabled="false" />
                                    </td>
                                    <td>
                                    <dx:ASPxTextBox ID="txtDocNumber" runat="server" ClientInstanceName="UpldDocsDocNum"
                                        DisabledStyle-ForeColor="Black" ClientEnabled="false" />
                                    </td>
                                </tr>
                            </table>
                            <table>
                            <tr>
                                <td colspan="2">
                                <dx:ASPxLabel Text="" runat="server" Width="635px" Height="3px" BackColor="Blue" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                <dx:ASPxLabel Text="" runat="server" Height="3px" />
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-right:0px;">
                                <dx:ASPxComboBox ID="cboFileList" runat="server" Width="567px" DropDownStyle="DropDownList"
                                    ClientInstanceName="UpldDocs_TF" ClientVIsible="false" />
                                </td>
                                <td>
                                <dx:ASPxButton ID="btnTransfer" runat="server" Text="Transfer"  AutoPostBack="False" Width="68px" 
                                    ClientInstanceName="UpldDocs_btnTF" ClientVisible="false" >
                                    <ClientSideEvents Click="function(s, e) { cp_UpldDocs.PerformCallback('Transfer:'); }" />
                                </dx:ASPxButton>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="padding-top:5px;">
                                <dx:ASPxUploadControl runat="server" ShowProgressPanel="True" ShowUploadButton="True" 
                                    Visible="true" Width="100%" Height="100px" Font-Size="Small" BrowseButtonStyle-Font-Size="Small"
                                    ClientInstanceName="UpldDocs_UC" 
                                    AddUploadButtonsHorizontalPosition="Center" UploadButton-Text="Upload" 
                                    OnFileUploadComplete="OnFileUploadComplete" UploadMode="Advanced" 
                                    OnFilesUploadComplete="OnFilesUploadComplete"
                                    ValidationSettings-AllowedFileExtensions=".pdf, .doc, .docx, .xls, .xlsx, .jpg, .jpeg, .png"
                                    AdvancedModeSettings-EnableFileList="true" AdvancedModeSettings-EnableMultiSelect="true" >
                                    <ClientSideEvents 
                                        FileUploadComplete="function(s, e)
                                        {   
                                            if (e.errorText != '') { alert(e.ErrorText); }
                                        }"
                                        FilesUploadComplete="function (s, e) 
                                        {
                                            if (e.errorText != '') { 
                                                alert('Upload of documents has been aborted'); 
                                            }
                                            else {
                                                cp_UpldDocs.PerformCallback('Upload:'+e.callbackData);
                                            }
                                        }" />
                                    <AdvancedModeSettings EnableDragAndDrop="True" />
                                </dx:ASPxUploadControl>
                                </td>
                            </tr>
                            </table>--%>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</body>

