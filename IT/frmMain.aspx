<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmMain.aspx.cs" Inherits="GWL.IT.frmMain" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <style>
        .tabbable-panel {
            border: 1px solid #eee;
            padding: 10px;
        }

        .tabbable-line > .nav-tabs {
            border: none;
            margin: 0px;
        }

            .tabbable-line > .nav-tabs > li {
                margin-right: 2px;
            }

                .tabbable-line > .nav-tabs > li > a {
                    border: 0;
                    margin-right: 0;
                    color: #737373;
                }

                    .tabbable-line > .nav-tabs > li > a > i {
                        color: #a6a6a6;
                    }

                .tabbable-line > .nav-tabs > li.open, .tabbable-line > .nav-tabs > li:hover {
                    border-bottom: 2px solid #32465B;
                }

                    .tabbable-line > .nav-tabs > li.open > a, .tabbable-line > .nav-tabs > li:hover > a {
                        border: 0;
                        background: none !important;
                        color: #333333;
                    }

                        .tabbable-line > .nav-tabs > li.open > a > i, .tabbable-line > .nav-tabs > li:hover > a > i {
                            color: #a6a6a6;
                        }

                    .tabbable-line > .nav-tabs > li.open .dropdown-menu, .tabbable-line > .nav-tabs > li:hover .dropdown-menu {
                        margin-top: 0px;
                    }

                .tabbable-line > .nav-tabs > li.active {
                    border-bottom: 2px solid rgb(80,144,247);
                    position: relative;
                }

                    .tabbable-line > .nav-tabs > li.active > a {
                        border: 0;
                        color: #333333;
                    }

                        .tabbable-line > .nav-tabs > li.active > a > i {
                            color: #404040;
                        }

        .tabbable-line > .tab-content {
            margin-top: -3px;
            background-color: #fff;
            border: 0;
            border-top: 1px solid #eee;
            padding: 15px 0;
        }

        .portlet .tabbable-line > .tab-content {
            padding-bottom: 0;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-12" style="padding: 0;">
                    <div class="tabbable-panel">
                        <div class="tabbable-line">
                            <ul class="nav nav-tabs ">
                                <li class="active">
                                    <a href="#tab_default_1" data-toggle="tab" aria-expanded="true">Dashboard1 </a>
                                </li>
                                <li class="">
                                    <a href="#tab_default_2" data-toggle="tab" aria-expanded="false">Dashboard2 </a>
                                </li>
                                <li class="">
                                    <a href="#tab_default_3" data-toggle="tab" aria-expanded="false">Dashboard3 </a>
                                </li>
                                <li class="">
                                    <a href="#tab_default_4" data-toggle="tab" aria-expanded="false">Dashboard4 </a>
                                </li>
                            </ul>
                            <div class="tab-content">
                                <div class="tab-pane active" id="tab_default_1">
                                    <iframe class="MyFrame" src="frmDashboard11.aspx" name="iframe_a"
                                        style="border: 0px; width: 100%;"></iframe>
                                </div>
                                <div class="tab-pane" id="tab_default_2">
                                    <iframe class="MyFrame" src="frmDashboard2.aspx" name="iframe_a"
                                        style="border: 0px; width: 100%;"></iframe>
                                </div>
                                <div class="tab-pane" id="tab_default_3">
                                    <iframe class="MyFrame" src="frmDashboard3.aspx" name="iframe_a"
                                        style="border: 0px; width: 100%;"></iframe>
                                </div>
                                <div class="tab-pane" id="tab_default_4">
                                    <iframe class="MyFrame" src="frmDashboard4.aspx" name="iframe_a"
                                        style="border: 0px; width: 100%;"></iframe>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <script>
        const setElementHeight = function () {
            var height = $(window).height();
            $(".MyFrame").css("min-height", height-100);
        };
        $(window).on("resize", function () {
            setElementHeight();
        }).resize();
    </script>
</body>
</html>
