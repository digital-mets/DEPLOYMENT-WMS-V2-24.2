<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmEditor.aspx.cs" Inherits="GWL.frmEditor" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Editor</title>
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
        integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous" />

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />


    <style type="text/css">
        html {
            height: 100% !important;
        }

        body {
            height: 100% !important;
            margin: 0 !important;
            /*background-color: #f0f0f0;*/
            background-color: #ebebeb;
            overflow: hidden;
        }

        #main {
            width: 100%;
            height: 100%;
            position: absolute;
            z-index: 2;
        }

        #ui {
            position: absolute;
            height: 100%;
            width: 100%;
        }

        .ui-box {
            position: absolute;
            z-index: 3;
            border-radius: 20px;
        }

        .ui-box-lefta {
            width: 4em;
            left: 0.5em;
            top: 6em;
        }

        .ui-box-leftb {
            background-color: transparent;
            width: 2.5em;
            left: 1em;
            top: 3em;
        }

        .ui-box-leftc {
            background-color: transparent;
            width: 2.5em;
            top: 3em;
            right: 1em;
        }

        .ui-box-midtop {
            background-color: transparent;
            width: 2.5em;
            top: 6em;
            right: 1em;
        }

        .ui-box-params {
            width: 4em;
            right: 0.5em;
            bottom: 1.5em;
        }

        .modal-content {
            border-radius: 25px !important;
        }

        .modal-header {
            border-bottom: none !important;
        }

        .modal-footer {
            border-top: none !important;
        }

        table {
            text-align: center !important;
        }

        table, th, td {
            border: 1px solid black;
            border-collapse: collapse;
        }

            table button {
                width: 100% !important;
            }

        .logo {
            z-index: 3;
            top: 0.5em;
            left: 0.5em;
            position: absolute;
            width: 50px;
            height: 50px;
        }

            .logo img {
                width: 100%;
                height: auto;
            }

        /*#options {
            position: absolute;
            z-index: 3;
            bottom: 0.5em;
            left: 0.5em;
        }*/

        #stats {
            position: absolute;
            z-index: 3;
            bottom: 0;
            right: 0;
        }

        .btn-tool {
            border: 1px solid #b1b1b1;
            /*padding: 10px;*/
            width: 100%;
            background-color: #e1e1e1;
            border-radius: 0;
        }

            .btn-tool:hover {
                background-color: #b1b1b1;
                color: #fff;
            }

        ul.nav {
            background-color: #d1d1d1;
            border-bottom: 1px solid #b3b3b3;
        }


        .nav-link {
            color: #000 !important;
            padding: 0.1rem 0.8rem !important;
        }

            .nav-link:hover {
                color: #1c1c1c !important;
                background-color: #dfdfdf;
            }

        .win {
            position: absolute;
            border: 1px solid #bfbfbf;
            background-color: rgba(255, 255, 255, .85);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            z-index: 11;
            border-radius: 5px;
            overflow: hidden;
        }

        .win-header {
            height: 0.75em;
            background-color: #d9d9d9;
            border-bottom: 1px solid #bfbfbf;
            overflow: hidden;
            align-items: center;
            justify-content: center;
            display: flex;
        }

        .win-body {
            /*height: 7.5em;*/
            background-color: #fff;
            padding: 0.5em 1em;
        }

        .win-param {
            top: 3em;
            right: 1em;
            width: 12em;
        }

        .win-rack {
            top: 11em;
            right: 1em;
            width: 12em;
        }

        .win-props {
            top: 20.5em;
            right: 1em;
            width: 12em;
        }

        #navibar {
            z-index: 5;
        }

        .footer p {
            -webkit-touch-callout: none; /* iOS Safari */
            -webkit-user-select: none; /* Safari */
            -khtml-user-select: none; /* Konqueror HTML */
            -moz-user-select: none; /* Old versions of Firefox */
            -ms-user-select: none; /* Internet Explorer/Edge */
            user-select: none; /* Non-prefixed version, currently
                                  supported by Chrome, Edge, Opera and Firefox */
        }

        .win-header .hr {
            height: 10%;
            width: 94%;
            font-size: 9px;
            text-align: center;
            background-color: #a9a9a9;
            border-radius: 15px;
        }

        #sidebarProps {
            background-color: #ebebeb;
            border-bottom: 1px solid #b3b3b3;
        }

        .dropdown-divider {
            margin: 0 !important;
        }

        .dropdown-menu {
            padding: 0 !important;
        }

        .Sidebar {
            border-left: 1px solid #b3b3b3;
            background-color: #d3d3d3;
        }

        .dropdown:hover .dropdown-menu {
            display: block;
            position: absolute;
            transform: translate3d(5px, 27px, 0px);
            top: 0px;
            left: 0px;
            will-change: transform;
        }

        .dropdown-item:focus, .dropdown-item:hover {
            color: #16181b;
            text-decoration: none;
            background-color: #ffe3c7;
        }
    </style>
    <!--#endregion-->
    <script type="importmap">
        {
            "imports": {
                "three": "../node_modules/three/build/three.module.js",
                "OrbitControls": "../node_modules/three/examples/jsm/controls/MapControls.js",
                "Sky": "../node_modules/three/examples/jsm/objects/Sky.js",
                "Stats": "../node_modules/three/examples/jsm/libs/stats.module.js",
                "@tweenjs/tween.js": "../node_modules/@tweenjs/tween.js/dist/tween.esm.js"
            }
        }
    </script>
</head>
<body>

    <div class="container-fluid h-100">
        <%--Top Navbar--%>
        <div class="row">
            <div class="col-12">
                <ul id="navibar" class="nav fixed-top ui-elem">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">File</a>
                        <div class="dropdown-menu">
                            <a class="dropdown-item" href="#" id="New" onclick="location.reload();">New</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="#" id="Save">Save</a>
                            <a class="dropdown-item" href="#" id="Load">Load</a>
                        </div>
                    </li>

                </ul>
            </div>
        </div>
        <div class="row h-100">
            <%--Viewport--%>
            <div class="col-lg-10 col-sm-12">
                <div class="row h-100">
                    <div class="col-12 px-0">
                        <%--Canvas--%>
                        <div id="main">
                        </div>

                        <%--GUI--%>
                        <div id="ui" class="ui-elem">
                            <div class="ui-box ui-box-leftb">
                                <div class="row m-0">
                                    <div class="col-12 p-0">
                                        <button id="pointer-tool" class="btn btn-tool mb-3" data-toggle="tooltip" data-placement="right" title="Default"><i class="bi bi-cursor"></i></button>

                                        <button id="point-select-tool" class="btn btn-tool mb-3" data-toggle="tooltip" data-placement="right" title="Select"><i class="bi bi-hand-index-thumb"></i></button>

                                        <button id="wall-tool" class="btn btn-tool" data-toggle="tooltip" data-placement="right" title="Wall"><i class="bi bi-bricks"></i></button>
                                        <button id="rack-tool" class="btn btn-tool" data-toggle="tooltip" data-placement="right" title="Rack"><i class="bi bi-grid-3x2"></i></button>
                                        <button id="erase-tool" class="btn btn-tool" data-toggle="tooltip" data-placement="right" title="Erase"><i class="bi bi-eraser"></i></button>

                                        <button id="btnClearAll" class="btn btn-tool mt-3" data-toggle="tooltip" data-placement="right" title="Clear"><i class="bi bi-trash"></i></button>
                                    </div>
                                </div>
                            </div>

                            <div class="ui-box ui-box-leftc">
                                <div class="row m-0">
                                    <div class="col-12 p-0">
                                        <button id="btnReset" class="btn btn-tool" data-toggle="tooltip" data-placement="left" title="Reset Camera"><i class="bi bi-arrow-repeat"></i></button>
                                    </div>
                                </div>
                            </div>

                            <div class="ui-box ui-box-midtop d-block">
                                <div class="row m-0">
                                    <div class="col-12 p-0">
                                        <button id="btnConfirm" class="btn btn-tool" data-toggle="tooltip" data-placement="left" title="Confirm"><i class="bi bi-check"></i></button>
                                        <button id="btnCancel" class="btn btn-tool" data-toggle="tooltip" data-placement="left" title="Cancel"><i class="bi bi-x"></i></button>
                                        

                                    </div>
                                </div>
                            </div>

                            <div id="stats">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%--Sidebar--%>
            <div class="col-sm-2 d-sm-none d-lg-block Sidebar">

                <div id="sidebarProps" class="row pt-5 pb-3">
                    <div class="col-12">
                        <h5 class="user-select-none">Properties</h5>
                        <hr />
                    </div>

                    <div class="col-12">
                        <div class="form-group row mb-1 d-none">
                            <label class="col-sm-3 col-form-label user-select-none" for="txtUUID">UUID</label>
                            <div class="col-sm-9 d-flex align-items-center">
                                <input id="txtUUID" type="text" readonly="" class="form-control form-control-sm" />
                            </div>
                        </div>
                        <div class="form-group row mb-1">
                            <label class="col-sm-3 col-form-label user-select-none" for="txtName">Name</label>
                            <div class="col-sm-9 d-flex align-items-center">
                                <input id="txtName" type="text" class="form-control form-control-sm" disabled="disabled" />
                            </div>
                        </div>
                        <div class="form-group row mb-1">
                            <label class="col-sm-3 col-form-label user-select-none" for="selType">Type</label>
                            <div class="col-sm-9 d-flex align-items-center">
                                <!-- <select class="form-control form-control-sm" id="selType">
                                    <option value="rack">Rack</option>
                                    <option value="wall">Wall</option>
                                </select> -->
                                <input class="form-control form-control-sm" id="inputType" type="text" disabled="disabled" />
                            </div>
                        </div>
                        <div class="form-group row mb-1 d-none">
                            <label class="col-sm-3 col-form-label user-select-none" for="txtRows">Rows</label>
                            <div class="col-sm-9 d-flex align-items-center">
                                <input id="txtRows" type="number" min="0" max="8" value="0" class="form-control form-control-sm" />
                            </div>
                        </div>
                        <div class="form-group row mb-3 d-none">
                            <label class="col-sm-3 col-form-label user-select-none" for="txtColumns">Cols</label>
                            <div class="col-sm-9 d-flex align-items-center">
                                <input id="txtColumns" type="number" min="0" max="48" value="0" disabled="disabled" class="form-control form-control-sm" />
                            </div>
                        </div>
                        <button id="btnUpdate" disabled="disabled" class="btn btn-primary btn-sm btn-block d-none">Save Changes</button>
                    </div>
                </div>

            </div>
        </div>
    </div>



    <script src="https://code.jquery.com/jquery-3.7.0.min.js"
        integrity="sha256-2Pmvv0kuTBOenSvLm6bvfBSSHrUJ+3A7x6P5Ebd07/g=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"
        integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN"
        crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.min.js"
        integrity="sha384-w1Q4orYjBQndcko6MimVbzY0tgp4pWB4lZ7lr30WKz0vr/aWKhXdBNmNb5D92v7s"
        crossorigin="anonymous"></script>

    <%--<script type="module" src="../Assets/Editor/History.js"></script>--%>

    <%--<script type="module" src="../Assets/Editor/mainEditor.js"></script>--%>
    
    <script type="module" src="../Assets/Editor/EditorNew.js"></script>
    <%--<script type="module" src="../Assets/Editor/Controls.js"></script>--%>

</body>

</html>


