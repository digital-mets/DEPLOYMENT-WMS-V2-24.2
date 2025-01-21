<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="wc_UpldDocsPopup.ascx.cs" Inherits="GWL.WebControl.wc_UpldDocsPopup" %>

<header>
    <script>
    </script>
</header>
<body>
    <dx:ASPxPopupControl ID="UpldDocsPopup" runat="server" ClientInstanceName="UpldDocsPopup"
        CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
        HeaderText="Upload Document" 
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
        AllowDragging="True" PopupAnimationType="None" EnableViewState="False">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxCallbackPanel ID="cp" runat="server" OnCallback="cp_Callback" ClientInstanceName="cp_UpldDocs">
                    <ClientSideEvents 
                        EndCallback="function(s,e) 
                        {
                            if (s.cp_errormssg) {
                                alert(s.cp_errormssg);
                                delete(s.cp_errormssg);
                            }
                            if (s.cp_uploadmssg) {
                                alert(s.cp_uploadmssg);
                                delete(s.cp_uploadmssg);
                                UpldDocsTranType.SetValue(null);
                                UpldDocsDocNum.SetValue(null);
                                UpldDocsDocDate.SetValue(null);
                                UpldDocsMode.SetValue('UPLOAD');
                                UpldDocsPopup.Hide();
                                gv2.Refresh();
                            }
                        }" 
                    />
                    <PanelCollection>
                        <dx:PanelContent runat="server">
                            <dx:ASPxTextBox ID="txtMode" runat="server" Width="100px" ClientInstanceName="UpldDocsMode" 
                                Text="UPLOAD" ClientEnabled="false" ClientVisible="false" />
                            <%--2023-12-04  TL  For Auxiliary Docs--%>
                            <dx:ASPxTextBox ID="txtDocType" runat="server" Width="100px" ClientInstanceName="UpldDocsDocType" 
                                Text="MAIN" ClientEnabled="false" ClientVisible="false" />
                            <%--2023-12-04  TL  (End)--%>
                            <dx:ASPxDateEdit ID="dteDocDate" runat="server" Width="100px" ClientInstanceName="UpldDocsDocDate" 
                                ClientEnabled="false" ClientVisible="false" />
                            <table>
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
                            </table>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallBackPanel>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</body>

