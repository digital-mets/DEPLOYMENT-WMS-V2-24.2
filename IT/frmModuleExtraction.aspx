<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmModuleExtraction.aspx.cs" Inherits="GWL.IT.frmModuleExtraction" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="assets/css/icons.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/app.min.css" rel="stylesheet" type="text/css" />
    <%--<link href="assets/css/vendor/dataTables.bootstrap4.css" rel="stylesheet" type="text/css" />--%>
    <link href="//cdn.datatables.net/1.11.5/css/dataTables.bootstrap4.min.css" rel="stylesheet" type="text/css" />
    <link href="//cdn.datatables.net/buttons/2.2.2/css/buttons.dataTables.min.css" rel="stylesheet" type="text/css" />
    <link href="//cdn.datatables.net/buttons/2.2.2/css/buttons.bootstrap4.min.css" rel="stylesheet" type="text/css" />
    <link href="css/frmModuleExtraction.css" rel="stylesheet" type="text/css" />

    <script src="../js/PerfSender.js" type="text/javascript" defer></script>
    <script src="assets/js/vendor.min.js" defer></script>
    <script src="assets/js/app.min.js" defer></script>
    <script src="//cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js" defer></script>
    <%--<script src="assets/js/vendor/dataTables.bootstrap4.js" defer></script>--%>
    <script src="assets/js/vendor/dataTables.responsive.min.js" defer></script>
    <script src="//cdn.datatables.net/1.11.5/js/dataTables.bootstrap4.min.js" defer></script>
    <script src="//cdn.datatables.net/buttons/2.2.2/js/dataTables.buttons.min.js" defer></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js" defer></script>
    <script src="//cdn.datatables.net/buttons/2.2.2/js/buttons.dataTables.min.js" defer></script>
    <script src="//cdn.datatables.net/buttons/2.2.2/js/buttons.bootstrap4.min.js" defer></script>
    <script src="//cdn.datatables.net/buttons/2.2.2/js/buttons.html5.min.js" defer></script>
    <script src="//cdn.datatables.net/buttons/2.2.2/js/buttons.colVis.min.js" defer></script>
    <script src="js/moment.min.js" defer></script>
    <script src="js/frmModuleExtraction.js" defer></script>

</head>
<body>
    <h4 class="page-title">Module Extraction</h4>
    <div class="p-2">
        <div class="form-group">
            <div id="module-dropdown" class="input-group">
                <div class="input-group-prepend">
                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Module</button>
                    <div class="dropdown-menu">
                        <div class="dropdown-item selected">Loading...</div>
                    </div>
                </div>
                <input type="text" class="form-control" data-toggle="tooltip" title="" data-trigger="hover" autocomplete="@(false)" value="" />
            </div>
        </div>
        <div class="d-flex align-items-baseline">
            <h5 class="pl-2 mr-1 mb-0">Parameters</h5>
            <button id="btn-toggle-params" class="collapsible-toggle-btn p-0 d-flex align-items-baseline justify-content-center" type="button">
                <span class="mdi mdi-chevron-double-up p-0"></span>
            </button>
        </div>
        <div class="horzintal-divider flex-grow-1"></div>
        <div id="params-panel" class="collapsible expand pt-2">
            <div class="form-row m-0">
                <p class="col-12 text-center mb-1">No parameter</p>
            </div>
            <div class="d-flex justify-content-end m-2">
                <button id="btn-generate" type="button" class="btn btn-primary" disabled>Generate</button>
            </div>
        </div>
        <div class="horzintal-divider flex-grow-1 mb-2"></div>
        <div class="table-responsive px-1">
            <table id="tblModule" name="tblModule" class="table table-bordered display dataTable dt-normal" width="100%">
                <thead>
                    <tr>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</body>
</html>
