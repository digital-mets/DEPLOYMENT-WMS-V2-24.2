<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmCapacityPlanningCalendar.aspx.cs" Inherits="GWL.Toll.frmCapacityPlanningCalendar" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Capacity Planning Calendar</title>

    <link rel="stylesheet" href="../css/fullcalendar-5.3.2.min.css"/>
    <link rel="stylesheet" href="../css/bootstrap.min.css"/>
    <link rel="stylesheet" href="../css/CapacityPlanningCalendar.css"/>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/dataTables.bootstrap5.min.css" />

</head>
<body>
    <div id="calendar" class="container-fluid p-2 calendar-machine"></div>

    <div id="machineModal" class="modal fade">
        <div class="modal-dialog modal-xs">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="col"><h5 class="modal-title" id="processData">Grinding</h5></div>
                </div>
                <div id="modalBody" class="modal-body">
                    <div class="col-12 row">
                        <div class="col">
                            <h6>Skus: </h6>
                        </div>
                        <div class="col">
                            <h6 id="skuData">77000111</h6>
                        </div>
                    </div>
                    <div class="col-12 row">
                        <div class="col">
                            <h6>BOM: </h6>
                        </div>
                        <div class="col">
                            <h6 id="BOMData">MEAT 1</h6>
                        </div>
                    </div>
                    <div class="col-12 row">
                        <div class="col">
                            <h6>MACHINES: </h6>
                        </div>
                        <div class="col">
                            <h6 id="machineData">GRINDER 1</h6>
                        </div>
                    </div>
                    <div class="col-12 row">
                        <div class="col">
                            <h6>NO. OF MANPOWER: </h6>
                        </div>
                        <div class="col">
                            <h6 id="manpowerData">2</h6>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="summaryModal" class="modal fade">
        <div class="modal-dialog modal-lg modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="col"><h5 class="modal-title">SKU1</h5></div>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Sequence</th>
                                <th>Machine</th>
                                <th>Schedule</th>
                                <th>Duration</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>GRINDER 1</td>
                                <td>May 11, 2021 12:00 AM - May 11, 2021 03:00 AM</td>
                                <td>3</td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>CHOPPER 1</td>
                                <td>May 11, 2021 03:00 AM - May 11, 2021 04:00 AM</td>
                                <td>1</td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td>MIXER 1</td>
                                <td>May 11, 2021 04:00 AM - May 11, 2021 12:00 PM</td>
                                <td>8</td>
                            </tr>
                            <tr>
                                <td>4</td>
                                <td>STUFFING 3</td>
                                <td>May 11, 2021 12:00 PM - May 11, 2021 09:00 PM</td>
                                <td>9</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="manpowerModal" class="modal fade">
        <div class="modal-dialog modal-md modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header"></div>
                <div class="modal-body">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Position</th>
                                <th># of Manpower</th>
                                <th>Total</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="manpowerModal1" class="modal fade">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Manpower</h5>
                    <button type="button" class="close modalClose" data-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th class="d-none">RecordID</th>
                                <th>Process Code</th>
                                <th>Direct Plan</th>
                                <th>Direct Actual</th>
                                <th>Agency Plan</th>
                                <th>Agency Actual</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type='button' class='btn btn-secondary modalClose' data-dismiss='modal'>Close</button>
                </div>
            </div>
        </div>
    </div>

    <script type='text/javascript' src="../js/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="../js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../js/moment-with-locales.js"></script>
    <script type="text/javascript" src="../js/fullcalendar-5.3.2.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.11.3/js/dataTables.bootstrap5.min.js"></script>
    <script type="text/javascript" src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script type="text/javascript" src="../js/CapacityPlanningCalendar.js"></script>
</body>
</html>
