<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="wc_DocRmkPopup.ascx.cs" Inherits="GWL.WebControl.wc_UploadDocsPopup" %>

<header>
    <script>
        var DocRmk_Separator = ";";

        function DocRmk_UpdateText() {
            var selectedItems = DocRmk_LB.GetSelectedItems();
            DocRmk_TXT.SetText(DocRmk_getSelectedItemsText(selectedItems));
        }

        function DocRmk_SyncLB(textBox, args) {
            DocRmk_LB.UnselectAll();
            var texts = textBox.GetText().split(DocRmk_Separator);
            var values = DocRmk_getValuesByTexts(texts);
            DocRmk_LB.SelectValues(values);
            DocRmk_UpdateText(); // for remove non-existing texts
        }

        function DocRmk_getSelectedItemsText(items) {
            var texts = [];
            for (var i = 0; i < items.length; i++)
                texts.push(items[i].text);
            return texts.join(DocRmk_Separator);
        }

        function DocRmk_getValuesByTexts(texts) {
            var actualValues = [];
            var item;
            for (var i = 0; i < texts.length; i++) {
                item = DocRmk_LB.FindItemByText(texts[i]);
                if (item != null)
                    actualValues.push(item.value);
            }
            return actualValues;
        }

        function DocRmk_SetRmkType(mode, doclist, missingdoc) {
            DocRmkRmkType.SetText(mode);
            if (mode == 'MISSING') {
                DocRmk_Rmk.SetVisible(false);
                var list = doclist.split(DocRmk_Separator);
                DocRmk_LB.ClearItems();
                for (var i = 0; i < list.length; i++) {
                    DocRmk_LB.AddItem(list[i]);
                }
                DocRmk_TXT.SetVisible(true);
                DocRmk_LB.SetVisible(true);
                DocRmk_TXT.SetText(missingdoc);
                DocRmk_SyncLB(DocRmk_TXT, null);
                DocRmkPopup.SetHeaderText("Missing Document");
            }
            else {
                DocRmk_TXT.SetVisible(false);
                DocRmk_LB.ClearItems();
                DocRmk_LB.SetVisible(false);
                DocRmk_Rmk.SetVisible(true);
                DocRmk_Rmk.SetText(missingdoc);

                DocRmkPopup.SetHeaderText("Incorrect Document");
            }
            DocRmkRmkType.SetText(mode);
        }

    </script>
</header>

<body>
    <dx:ASPxPopupControl ID="DocRmkPopup" runat="server" ClientInstanceName="DocRmkPopup"
        CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
        HeaderText="Upload Document" 
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
        AllowDragging="True" PopupAnimationType="None" EnableViewState="False">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxCallbackPanel ID="cp" runat="server" OnCallback="cp_Callback" ClientInstanceName="cp_DocRmk">
                    <ClientSideEvents 
                        EndCallback="function(s,e) 
                        {
                            if (s.cp_errormssg) {
                                alert(s.cp_errormssg);
                                delete(s.cp_errormssg);
                                DocRmkPopup.Hide();
                            }
                            if (s.cp_success) {
                                delete(s.cp_success);
                                alert('Document record has been updated');
                                DocRmkPopup.Hide();
                                gv2.Refresh();
                            }
                            DocRmkTranType.SetValue(null);
                            DocRmkDocNum.SetValue(null);
                        }" 
                    />
                    <PanelCollection>
                        <dx:PanelContent runat="server">
                            <dx:ASPxTextBox ID="txtRmkType" runat="server" Width="100px" ClientInstanceName="DocRmkRmkType" 
                                Text="MAIN" ClientEnabled="false" ClientVisible="false" />
                            <table>
                                <tr>
                                    <td style="padding-right:7px;">
                                    <dx:ASPxLabel runat="server" Text="Transaction:" Width="70px" />
                                    </td>
                                    <td style="padding-right:7px;">
                                    <dx:ASPxTextBox ID="txtTransType" runat="server" Width="120px" ClientInstanceName="DocRmkTranType"
                                        DisabledStyle-ForeColor="Black" ClientEnabled="false" />
                                    </td>
                                    <td>
                                    <dx:ASPxTextBox ID="txtDocNumber" runat="server" ClientInstanceName="DocRmkDocNum"
                                        DisabledStyle-ForeColor="Black" ClientEnabled="false" />
                                    </td>
                                </tr>
                            </table>
                            <table>
                            <tr>
                                <td>
                                    <dx:ASPxLabel Text="" runat="server" Width="650px" Height="3px" BackColor="Blue" />
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-top:5px;">
                                    <dx:ASPxTextBox ID="txtMissingDocs" runat="server" Width="650px" ClientInstanceName="DocRmk_TXT" ClientEnabled="false" DisabledStyle-ForeColor="Black">
                                        <ClientSideEvents TextChanged="DocRmk_SyncLB" />
                                    </dx:ASPxTextBox>
                                    <dx:ASPxListBox ID="lbDocList" runat="server" Width="100%" Height="274px" ClientInstanceName="DocRmk_LB" 
                                        SelectionMode="CheckColumn" >
                                        <Border BorderStyle="None" />
                                        <BorderBottom BorderStyle="Solid" BorderWidth="1px" />
                                        <ClientSideEvents SelectedIndexChanged="DocRmk_UpdateText" Init="DocRmk_UpdateText" />
                                    </dx:ASPxListBox>
                                    <dx:ASPxMemo ID="memRemarks" runat="server" Width="650px" Height="100px" ClientInstanceName="DocRmk_Rmk">
                                    </dx:ASPxMemo>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-top:5px;text-align:center" >
                                    <dx:ASPxButton ID="btnUpdate" runat="server" Text="Update" AutoPostBack="False" Width="80px" >
                                        <ClientSideEvents Click="function(s, e) {
                                            if (DocRmkRmkType.GetText() == 'INCORRECT' && DocRmk_Rmk.GetText() == '') {
                                                alert('Please provide the required information');
                                            }
                                            else {
                                                cp_DocRmk.PerformCallback();
                                                e.processOnServer = false;
                                            }
                                        }" />
                                    </dx:ASPxButton>
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

