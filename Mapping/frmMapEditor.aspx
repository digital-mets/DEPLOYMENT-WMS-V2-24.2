<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmMapEditor.aspx.cs" Inherits="GWL.frmMapEditor" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Editor</title>
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
        integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">


    <style type="text/css">
        body {
            margin: 0 !important;
            background-color: #f0f0f0;
            overflow: hidden;
        }

        #main {
            width: 100%;
            height: 100vh;
            position: absolute;
            z-index: 2;
        }

        #ui {
            position: absolute;
            height: 100vh;
            width: 100%;
        }

        .ui-box {
            position: absolute;
            z-index: 3;
            /*width: 16em;
            right: 0.5em;
            top: 0.5em;*/
            border-radius: 20px;
            /*background-color: rgba(255, 255, 255, .85);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);*/
        }

        .ui-box-lefta {
            width: 4em;
            left: 0.5em;
            top: 6em;
        }

        .ui-box-leftb {
            background-color: transparent;
            width: 3em;
            left: 1.5em;
            top: 3em;
        }

        .ui-box-leftc {
            background-color: transparent;
            width: 3em;
            left: 1.5em;
            bottom: 4em;
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
            left: 0;
        }

        .btn-tool {
            border: 1px solid #b1b1b1;
            padding: 10px;
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
            height: .75em;
            background-color: #d9d9d9;
            border-bottom: 1px solid #bfbfbf;
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
    <%--<form id="test"></form>--%>
    <ul id="navibar" class="nav fixed-top ui-elem">
        <li class="nav-item dropdown">
            <a class="nav-link dropdown" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">File</a>
            <div class="dropdown-menu">
                <a class="dropdown-item" href="#" id="New" onclick="location.reload();">New</a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="#" id="Save">Save</a>
                <a class="dropdown-item" href="#" id="Load">Load</a>
                <%--<div class="dropdown-divider"></div>
                <a class="dropdown-item" href="#">Export</a>--%>

            </div>
        </li>
        <%--<li class="nav-item dropdown">
            <a class="nav-link dropdown" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">Edit</a>
            <div class="dropdown-menu">
                <a class="dropdown-item" href="#">Canvas Size</a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="#">Preferences</a>
            </div>
        </li>

        <li class="nav-item dropdown">
            <a class="nav-link dropdown" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">Help</a>
            <div class="dropdown-menu">
                <a class="dropdown-item" href="#">About</a>
            </div>
        </li>--%>
    </ul>

    <%--GEARS logo--%>
    <%--<div class="logo">
        <img src="../images/GearsLOGO1.gif" />
    </div>--%>

    <%--Main canvas--%>
    <div id="main">
    </div>

    <%--User Interface--%>
    <div id="ui" class="ui-elem">
        <%--Filter--%>
        <%--<div class="ui-box ui-box-lefta">
            <div class="row m-0 p-2">
                <div class="col-12 p-0">
                    <button id="pointer-tool" class="btn btn-tool my-1" data-toggle="tooltip" data-placement="right" title="Select"><i class="bi bi-cursor"></i></button>
                </div>

            </div>
        </div>--%>

        <div class="ui-box ui-box-leftb">
            <div class="row m-0">
                <div class="col-12 p-0">
                    <button id="pointer-tool" class="btn btn-tool mb-3" data-toggle="tooltip" data-placement="right" title="Select"><i class="bi bi-cursor"></i></button>

                    <button id="draw-tool" class="btn btn-tool" data-toggle="tooltip" data-placement="right" title="Draw"><i class="bi bi-pen"></i></button>
                    <button id="erase-tool" class="btn btn-tool" data-toggle="tooltip" data-placement="right" title="Erase"><i class="bi bi-eraser"></i></button>

                    <%--<button id="clearAll" class="btn btn-tool mt-3" data-toggle="tooltip" data-placement="right" title="Clear Canvas"><i class="bi bi-x-lg"></i></button>--%>
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

        <%--Controls--%>
        <%--<div class="ui-box ui-box-params">
            <div class="row m-0 p-2">
                <div class="col-12 p-0">
                    <button id="btnReset" class="btn btn-tool" data-toggle="tooltip" data-placement="left" title="Reset Camera"><i class="bi bi-arrow-repeat"></i></button>
                </div>
            </div>
        </div>--%>


        <div id="stats">
        </div>
    </div>

    <%--Footer--%>
    <div class="footer fixed-bottom" style="text-align: right; font-size: 12px;">
        <p class="m-0">Copyright &copy; <%: DateTime.Now.Year %> Mets Logistics Incorporated All rights reserved.</p>
    </div>

    <div id="win-param" class="win win-param">
        <div class="win-header"></div>
        <div class="win-body">
            <div class="row">
                <div class="col-12">
                    <div class="form-group">
                        <label for="selObjType">Block Type</label>
                        <select id="selObjType" class="form-control">
                            <%--<option value="Floor">Floor</option>--%>
                            <option value="Wall">Wall</option>
                            <option value="Rack">Rack</option>
                        </select>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <div id="win-rack" class="win win-rack">
        <div class="win-header"></div>
        <div class="win-body">
            <div class="row">
                <div class="col-12">

                    <div class="form-group row align-items-center">
                        <div class="col-sm-4">Height</div>
                        <div class="col-sm-8">
                            <input type="number" id="txtHeight" class="form-control" step="1" min="1" max="100" />
                        </div>
                    </div>
                    <div class="form-group row align-items-center">
                        <div class="col-sm-4">Width</div>
                        <div class="col-sm-8">
                            <input type="number" id="txtWidth" class="form-control" step="1" min="1" max="100" />
                        </div>
                    </div>

                </div>
        </div>
    </div>
    </div>

    <div id="win-props" class="win win-props">
        <div class="win-header"></div>
        <div class="win-body">
            <div class="row">
                <div class="col-12">
                    <div class="form-group row align-items-center">
                        <div class="col-sm-4">Name</div>
                        <div class="col-sm-8">
                            <input type="text" id="txtName" class="form-control" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--Rack modal--%>
    <!-- Modal -->
    <div class="modal fade" id="modalRacks" tabindex="-1" aria-labelledby="modalRacksLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalRacksLabel">Modal title</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-12">
                            <table style="width: 100%">
                                <thead>
                                    <tr>
                                        <th></th>
                                        <th>1</th>
                                        <th>2</th>
                                        <th>3</th>
                                        <th>4</th>
                                        <th>5</th>
                                        <th>6</th>
                                        <th>7</th>
                                        <th>8</th>
                                        <th>9</th>
                                        <th>10</th>
                                        <th>11</th>
                                        <th>12</th>
                                        <th>13</th>
                                        <th>14</th>
                                        <th>15</th>
                                        <th>16</th>
                                        <th>17</th>
                                        <th>18</th>
                                        <th>19</th>
                                        <th>20</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th>A</th>
                                        <td>
                                            <button>A1</button></td>
                                        <td>
                                            <button>A2</button></td>
                                        <td>
                                            <button>A3</button></td>
                                        <td>
                                            <button>A4</button></td>
                                        <td>
                                            <button>A5</button></td>
                                        <td>
                                            <button>A6</button></td>
                                        <td>
                                            <button>A7</button></td>
                                        <td>
                                            <button>A8</button></td>
                                        <td>
                                            <button>A9</button></td>
                                        <td>
                                            <button>A10</button></td>
                                        <td>
                                            <button>A11</button></td>
                                        <td>
                                            <button>A12</button></td>
                                        <td>
                                            <button>A13</button></td>
                                        <td>
                                            <button>A14</button></td>
                                        <td>
                                            <button>A15</button></td>
                                        <td>
                                            <button>A16</button></td>
                                        <td>
                                            <button>A17</button></td>
                                        <td>
                                            <button>A18</button></td>
                                        <td>
                                            <button>A19</button></td>
                                        <td>
                                            <button>A20</button></td>
                                    </tr>
                                    <tr>
                                        <th>B</th>
                                        <td>
                                            <button>B1</button></td>
                                        <td>
                                            <button>B2</button></td>
                                        <td>
                                            <button>B3</button></td>
                                        <td>
                                            <button>B4</button></td>
                                        <td>
                                            <button>B5</button></td>
                                        <td>
                                            <button>B6</button></td>
                                        <td>
                                            <button>B7</button></td>
                                        <td>
                                            <button>B8</button></td>
                                        <td>
                                            <button>B9</button></td>
                                        <td>
                                            <button>B10</button></td>
                                        <td>
                                            <button>B11</button></td>
                                        <td>
                                            <button>B12</button></td>
                                        <td>
                                            <button>B13</button></td>
                                        <td>
                                            <button>B14</button></td>
                                        <td>
                                            <button>B15</button></td>
                                        <td>
                                            <button>B16</button></td>
                                        <td>
                                            <button>B17</button></td>
                                        <td>
                                            <button>B18</button></td>
                                        <td>
                                            <button>B19</button></td>
                                        <td>
                                            <button>B20</button></td>

                                    </tr>
                                    <tr>
                                        <th>C</th>
                                        <td>
                                            <button>C1</button></td>
                                        <td>
                                            <button>C2</button></td>
                                        <td>
                                            <button>C3</button></td>
                                        <td>
                                            <button>C4</button></td>
                                        <td>
                                            <button>C5</button></td>
                                        <td>
                                            <button>C6</button></td>
                                        <td>
                                            <button>C7</button></td>
                                        <td>
                                            <button>C8</button></td>
                                        <td>
                                            <button>C9</button></td>
                                        <td>
                                            <button>C10</button></td>
                                        <td>
                                            <button>C11</button></td>
                                        <td>
                                            <button>C12</button></td>
                                        <td>
                                            <button>C13</button></td>
                                        <td>
                                            <button>C14</button></td>
                                        <td>
                                            <button>C15</button></td>
                                        <td>
                                            <button>C16</button></td>
                                        <td>
                                            <button>C17</button></td>
                                        <td>
                                            <button>C18</button></td>
                                        <td>
                                            <button>C19</button></td>
                                        <td>
                                            <button>C20</button></td>

                                    </tr>
                                    <tr>
                                        <th>D</th>
                                        <td>
                                            <button>D1</button></td>
                                        <td>
                                            <button>D2</button></td>
                                        <td>
                                            <button>D3</button></td>
                                        <td>
                                            <button>D4</button></td>
                                        <td>
                                            <button>D5</button></td>
                                        <td>
                                            <button>D6</button></td>
                                        <td>
                                            <button>D7</button></td>
                                        <td>
                                            <button>D8</button></td>
                                        <td>
                                            <button>D9</button></td>
                                        <td>
                                            <button>D10</button></td>
                                        <td>
                                            <button>D11</button></td>
                                        <td>
                                            <button>D12</button></td>
                                        <td>
                                            <button>D13</button></td>
                                        <td>
                                            <button>D14</button></td>
                                        <td>
                                            <button>D15</button></td>
                                        <td>
                                            <button>D16</button></td>
                                        <td>
                                            <button>D17</button></td>
                                        <td>
                                            <button>D18</button></td>
                                        <td>
                                            <button>D19</button></td>
                                        <td>
                                            <button>D20</button></td>

                                    </tr>
                                    <tr>
                                        <th>E</th>
                                        <td>
                                            <button>E1</button></td>
                                        <td>
                                            <button>E2</button></td>
                                        <td>
                                            <button>E3</button></td>
                                        <td>
                                            <button>E4</button></td>
                                        <td>
                                            <button>E5</button></td>
                                        <td>
                                            <button>E6</button></td>
                                        <td>
                                            <button>E7</button></td>
                                        <td>
                                            <button>E8</button></td>
                                        <td>
                                            <button>E9</button></td>
                                        <td>
                                            <button>E10</button></td>
                                        <td>
                                            <button>E11</button></td>
                                        <td>
                                            <button>E12</button></td>
                                        <td>
                                            <button>E13</button></td>
                                        <td>
                                            <button>E14</button></td>
                                        <td>
                                            <button>E15</button></td>
                                        <td>
                                            <button>E16</button></td>
                                        <td>
                                            <button>E17</button></td>
                                        <td>
                                            <button>E18</button></td>
                                        <td>
                                            <button>E19</button></td>
                                        <td>
                                            <button>E20</button></td>

                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
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

    <script type="module" src="../Assets/Editor/Editor.js"></script>

</body>

</html>


