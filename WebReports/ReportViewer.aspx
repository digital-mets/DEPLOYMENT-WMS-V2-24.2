<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportViewer.aspx.cs" Inherits="GWL.WebReports.ReportViewer" %>




<%@ Register Assembly="DevExpress.XtraReports.v24.2.Web.WebForms, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraReports.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title runat="server" id="txtReport"></title>
    <%--    <script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-2.1.4.js" type="text/javascript"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.11.4/jquery-ui.js" type="text/javascript"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/globalize/0.1.1/globalize.js" type="text/javascript"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/globalize/0.1.1/cultures/globalize.cultures.js" type="text/javascript"></script>--%>
    <script src="https://ajax.aspnetcdn.com/ajax/knockout/knockout-3.4.0.js" type="text/javascript"></script>
    <%--<link href="js/jquery-ui-1.11.4/jquery-ui.css" type="text/css" rel="Stylesheet" />--%>
    <%--<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>--%>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        .custom-multivalue {
            min-height: 26px;
        }

        .dx-list-select-all {
            display: none;
        }
    </style>
    <script type="text/html" id="custom-dx-checkbox">
        <div data-bind="dxCheckBox: {
            value: value
        }">
        </div>
    </script>
    <script type="text/C#" id="custom-dx-date">
     <div data-bind="dxDateBox: { 
  value: value, 
  onValueChanged: function(e) { 
    console.log('Selected Date-Time:', e.value); 
        this.value = e.value;
  },
  showSpinButtons: true, 
  applyValueMode: 'instantly', 
  closeOnValueChange: true, 
  width: '150px',
  displayFormat: 'dd/MM/yyyy', 
  dateSerializationFormat: 'yyyy-MM-ddTHH:mm:ssZ'
}, 
dxValidator: { validationRules: validationRules || [] }"></div>    
    </script>
    <script type="text/html" id="custom-dxrd-combobox">
        <div data-bind="dxSelectBox: { dataSource: { 
            store: values(), 
            paginate: true, pageSize: 200 }, value: value, valueExpr: 'value', searchEnabled: true, displayExpr: 'displayValue', displayCustomValue: true, disabled: disabled }, dxValidator: { validationRules: $data.validationRules || [] }">
        </div>
    </script>

    <script type="text/html" id="custom-dxrd-multivalue">
        <!-- ko with: value -->
        <div class="custom-multivalue" data-bind="dxTagBox: {
    dataSource: { pageSize: 20, paginate: true, store: displayItems() },
    height: 'auto',
    values: ko.pureComputed(function () {
        if (isPending($data))
            return [];
        return displayItems().filter(function (item) { return item.selected(); });
    }),
    showSelectionControls: true,
    onFocusOut: updateValue,
    hideSelectedItems: true,
    displayExpr: 'displayValue',
    applyValueMode: 'instantly',
    searchEnabled: true,
    onValueChanged: function (e) {
        if (isPending($data))
            return;
        $data['pending'](true);
        try {
            customValueChanged(e);
            updateValue();
        } finally {
            $data['pending'](false);
        }
    }
}">
        </div>
        <!-- /ko -->
    </script>

    <script>
        var module = getParameterByName("transtype");
        var id = getParameterByName("userid");
        var entry = getParameterByName("param");
        //let IsExport = false;

        //console.log(module, id, entry)

        $(document).ready(function () {
            PerfStart(module, entry + '-i', id);
        });

        function isPending(data) {
            !ko.isObservable(data['pending']) && (data['pending'] = ko.observable(false));
            return data['pending']();
        }

        var getArraysDifference = function (first, second) {
            return $.grep(first, function (element) { return $.inArray(element, second) < 0 });
        };


        function customValueChanged(e) {
            var isItemAdded = e.values.length > e.previousValues.length,
                difference = isItemAdded ? getArraysDifference(e.values, e.previousValues) : getArraysDifference(e.previousValues, e.values);
            difference.forEach(function (item) { item.selected(isItemAdded); });
        }

        var reprint = getParameterByName('reprinted');

        function CustomizeParameterEditors(s, e) {
            //if (e.info.editor.header === 'dxrd-multivalue') {
            //    e.info.editor.header = 'custom-dxrd-multivalue';
            //}

            //for (var rekt in e.info.editor) {
            //    if (e.info.editor.header === 'custom-dxrd-multivalue') {
            //        (window['multiValueParameterNames'] || (window['multiValueParameterNames'] = [])).push(e.info.propertyName);
            //    }
            //}
            // End
            //console.log(e.info.editor.header)
            //console.log(s.parametersInfo.parameters)
            //s.parametersInfo.parameters.forEach(function (editor) {
            //    if (editor.Name == "DocDate") {
            //        // Remove the time component by setting the editor's format.
            //        editor.Format = "yyyy-MM-dd";
            //    }
            //});

            if (e.info.editor.header === 'dx-combobox') {
                e.info.editor.header = 'custom-dxrd-combobox';
            }
            if (e.info.editor.header === 'dx-date') {
                e.info.editor = $.extend({}, e.info.editor);
                e.info.editor.extendedOptions = $.extend(e.info.editor.extendedOptions || {}, { type: 'date' });
                /*e.info.editor.header = 'custom-dx-date';*/


            }
            if (e.info.editor.header === 'dx-boolean-select') {
                //e.info.editor = $.extend({}, e.info.editor);  // Clone the editor object to avoid mutation

                //e.info.editor.header = 'dx-checkbox'; // Change to 'dxCheckBox' for checkbox type

                //// Set additional options if necessary (e.g., label, value, etc.)
                //e.info.editor.options = $.extend(e.info.editor.options || {}, {
                //    value: e.value ? true : false, // Ensure the value is a boolean
                //});
                //console.log(e);
                //var name = e.info.displayName;
            }
            //if (name.includes("Date") && e.info.editor.header == 'dx-text') {
            //    e.info.editor.header = 'custom-dx-date';
            //    console.log(name)
            //}

            //console.log(e.info)
        }

        function customizeMenu(s, e) {
            var actionPrint = e.Actions.filter(action => action.text === "Print")[0];
            var actionPrint2 = e.Actions.filter(action => action.text === "Print Page")[0];

            if (actionPrint2) actionPrint2.visible = false;

            e.Actions.push({
                text: "New Tab",
                imageClassName: "dxrd-image-open",
                disabled: ko.observable(false),
                visible: true,
                clickAction: function () {
                    window.open(window.location.href, '_blank');
                }
            });

            var defaultPrintClickAction = actionPrint.clickAction;
            actionPrint.clickAction = async function () {
                if (typeof reprint !== "undefined" && reprint === "True") {
                    var r = confirm('Are you sure that you want to proceed with printing? ' +
                        'This will be marked as Re-Printed after this process');
                    if (r) {
                        defaultPrintClickAction();
                        if (typeof cp !== "undefined" && cp.PerformCallback) {
                            cp.PerformCallback();
                        }
                        window.close();
                    }
                } else {
                    await Validation();

                    var content = $("<div style='height: auto; max-height: none; min-height: 0px; display: flex; justify-content: center; flex-direction: column; align-items: center;'/>");

                    $("#popup").dxPopup({
                        showTitle: false,
                        visible: false,
                        hideOnOutsideClick: false,
                        dragEnabled: false,
                        position: { my: "center", at: "center", of: window },
                        width: 450,
                        height: "auto",
                        contentTemplate: function () {
                            content.empty().append(
                                $("<i class='dx-icon-warning' style='color: yellow; font-size: 75px; text-align: center; margin: 20px'></i>"),
                                $("<h1 />")
                                    .text("Do you want to upload this document?")
                                    .css({ color: "black", "text-align": "center", "font-size": "20px" }),

                                // Buttons inside the same div with Flexbox
                                $("<div />").css({
                                    display: "flex",
                                    justifyContent: "center",
                                    gap: "20px", // Space between buttons
                                    marginTop: "20px",
                                    marginBottom: "20px"
                                }).append(
                                    $("<div style='padding-left: 50px; padding-right: 50px;'/>").attr("id", "btnYes").dxButton({
                                        text: "Yes",
                                        type: "success", // Green color
                                        stylingMode: "contained",
                                        onClick: async function () {
                                            await s.PerformCustomDocumentOperation("ExportToCustomPath");
                                            $("#popup").dxPopup("hide");
                                            await defaultPrintClickAction();
                                        }
                                    }),
                                    $("<div style='padding-left: 50px; padding-right: 50px;'/>").attr("id", "btnNo").dxButton({
                                        text: "No",
                                        type: "danger", // Red color
                                        stylingMode: "contained",
                                        onClick: async function () {
                                            $("#popup").dxPopup("hide");
                                            await defaultPrintClickAction();
                                        }
                                    })
                                )
                            );
                            return content;
                        }
                    }).dxPopup("instance").show(); // Show popup
                }
            };
        }

        async function Validation() {
            try {
                const data = await $.ajax({
                    type: "POST",
                    url: "ReportViewer.aspx/ExportPDF",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ Action: "AutoUpload" }),
                    dataType: "json",
                    cache: false
                });

                if (data.d[0] !== "Success") {
                    if (data.d[1] == 'IsNotForExport') {
                        //IsExport = false;
                    } else {
                        alert(data.d[0]);
                        //IsExport = false;
                    }
                } else {
                    IsExport = true;
                }
            } catch (error) {
                console.error("Error:", error);
            }
        }

        function Init(s, e) {
            //updated by SA
            //s.previewModel.reportPreview.zoom(1);
            //s.previewModel.reportPreview.showMultipagePreview(1);
            //update by saa 10/16/2024
            s.GetReportPreview().zoom = 0.9;
            //console.log(s);
            ResizeReport();
            var previewModel = s.GetPreviewModel();
            if (!previewModel || !previewModel.parametersModel) {
                return;
            }
            (window['multiValueParameterNames'] || []).forEach(function (parameterName) {
                var parameter = null;
                if (parameterName && (parameter = previewModel.parametersModel[parameterName])) {
                    var removeSelectAllItem = function (newValue) {
                        newValue.displayItems && (newValue.displayItems.length > 0) && newValue.displayItems.splice(0, 1);
                    }
                    parameter.subscribe(removeSelectAllItem);
                    removeSelectAllItem(parameter());
                    //console.log('here')
                }
            });

            var previewModel = s.GetPreviewModel();
            var startTime;
            var elapsedTime;
            var subscription = previewModel.reportPreview.progressBar.visible.subscribe(function (newValue) {
                if (newValue) {
                    startTime = Date.now();
                }
                else {
                    elapsedTime = Date.now() - startTime;
                    perfSend2((elapsedTime / 1000).toFixed(3));
                }
            });
        }

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        var module2 = getParameterByName("val").split('~');

        function perfSend2(loadTime) {
            //console.log(loadTime, module)
            $.ajax({
                type: "POST",
                data: JSON.stringify({ ModuleID: module2[1], Entry: 'PView-load', Pkey: null, Interval: loadTime, UserId: id, }),
                url: "../PerformSender.aspx/perfsend",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    console.log('sent');
                }
            });
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%--<dx:ASPxButton ID="ASPxButton1" runat="server" Text="TEST" AutoPostBack="False">
             <ClientSideEvents Click="btnOnClick" />
            </dx:ASPxButton>--%>
            <dx:ASPxWebDocumentViewer ID="GWLReportViewer" runat="server" Height="300px" ClientInstanceName="report">
                <ClientSideEvents Init="Init" CustomizeParameterEditors="CustomizeParameterEditors" CustomizeMenuActions="customizeMenu" />
            </dx:ASPxWebDocumentViewer>
            <dx:ASPxCallback ID="cp" runat="server" OnCallback="cp_Callback"></dx:ASPxCallback>
            <div id="popup"></div>
            <script type="text/javascript">
                function ResizeReport() {
                    report.SetHeight(document.documentElement.clientHeight - 45);
                }
                window.onresize = function resize() { ResizeReport(); }
            </script>
        </div>
    </form>
</body>
</html>
