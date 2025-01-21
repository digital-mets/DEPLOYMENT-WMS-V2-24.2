<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmMapping.aspx.cs" Inherits="GWL.frmMapping" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Mapping</title>
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
        integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">


    <style type="text/css">
        body {
            margin: 0 !important;
            background-color: #f0f0f0;
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
            background-color: rgba(255, 255, 255, .85);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
        }

        .ui-box-filter {
            width: 16em;
            right: 0.5em;
            top: 0.5em;
        }

        .ui-box-controls {
            width: 6em;
            right: 0.5em;
            top: 12.5em;
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

        #options {
            position: absolute;
            z-index: 3;
            bottom: 0.5em;
            left: 0.5em;
        }
    </style>
    <!--#endregion-->
    <script type="importmap">
        {
            "imports": {
                "three": "../node_modules/three/build/three.module.js",
                "OrbitControls": "../node_modules/three/examples/jsm/controls/MapControls.js",
                "Sky": "../node_modules/three/examples/jsm/objects/Sky.js"
            }
        }
    </script>
</head>
<body>
    <%--GEARS logo--%>
    <div class="logo">
        <img src="../images/GearsLOGO1.gif" />
    </div>

    <%--Main canvas--%>
    <div id="main">
    </div>

    <%--User Interface--%>
    <div id="ui">
        <%--Filter--%>
        <div class="ui-box ui-box-filter">
            <div class="row m-0 py-3">
                <div class="col-12">
                    <div class="form-group row">
                        <label for="selWarehouse" class="col-sm-5 col-form-label">Warehouse</label>
                        <div class="col-sm-7">
                            <select class="form-control" id="selWarehouse">
                                <option>MGDCAV</option>
                                <option>MLICAV</option>
                                <option>MLICAV2</option>
                                <option>MLICDO</option>
                                <option>MLICEB</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="selArea" class="col-sm-5 col-form-label">Area</label>
                        <div class="col-sm-7">
                            <select class="form-control" id="selArea">
                                <option>AREA1</option>
                                <option>AREA2</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="col-12">
                    <button type="button" class="btn btn-primary btn-block" data-toggle="modal" data-target="#modalRacks">
                        Toggle Modal
                    </button>
                </div>
            </div>
        </div>

        <%--Controls--%>
        <%--<div class="ui-box ui-box-controls">
            <div class="row m-0 py-3">
                <div class="col-12">
                    <button class="btn btn-primary btn-block"><i class="bi bi-arrow-counterclockwise"></i></button>
                </div>
            </div>
        </div>--%>

        <%--Options--%>
        <%--<div id="options">
            <button class="btn btn-link"><i class="bi bi-gear"></i></button>
        </div>--%>
    </div>

    <%--Footer--%>
    <div class="footer fixed-bottom" style="text-align: right; font-size: 12px;">
        <p class="m-0">Copyright &copy; <%: DateTime.Now.Year %> Mets Logistics Incorporated All rights reserved.</p>
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

    <script type="module" src="../Assets/Editor/mainMap.js"></script>
</body>

</html>


