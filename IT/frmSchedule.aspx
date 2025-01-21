<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmSchedule.aspx.cs" Inherits="GWL.frmSchedule" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>

    <meta name="author" content="Darko Bunic" />
    <meta name="description" content="Drag and drop table content with JavaScript" />
    <meta name="viewport" content="width=device-width, user-scalable=no" />
    <link href="css/main.css" rel="stylesheet" />
    <link href="css/style.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="css/util.css" />
    <link rel="stylesheet" href="css/redips-style.css" />


    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Poppins" />
 
    <style>
        html, body {
            font-family: 'Poppins' !important;
        }

        .control-label {
            margin: 8px 0 !important
        }


        table {
            table-layout: fixed !important;
            width: 100%;
            overflow: hidden !important;
            word-wrap: break-word !important;
        }

        td, th {
            width: 10rem !important;
        }


        .card {
            margin-bottom: 0 !important;
        }

        .column100.column1.redips-mark.dark {
            text-align: left !important;
        }

        #tblTranslist, .card {
            width: 100% !important;
        }

        .card-body {
            padding: .2rem !important;
        }

        .table-title {
            color: #39646a;
            background: #f1f1f1; /*nims added this*/
            padding: 0 15px;
            margin: -2.5px -7.5px 2.5px;
            border-radius: 3px 3px 0 0;
        }

            .table-title h3 {
                /*font-size: 18px;*/
                font-size: 18px;
                font-weight: 900;
            }

        h3 {
            line-height: 1.4 !important;
            margin: 10px 0 10px !important;
        }

        /*Straight row data*/
        .toolbar {
            margin-bottom: 20px;
        }

        .toolbar-left {
            float: left;
            margin-bottom: 20px;
        }

        .toolbar-right {
            float: right;
            margin-bottom: 20px;
        }


        @media (max-width: 100px) {
            .toolbar-left {
                float: none;
            }

            .toolbar-right {
                float: none;
            }

            .filter-dates {
                display: block;
            }

            .table-searc {
                display: block;
            }
        }

        .btn-success {
            border-color: transparent !important;
        }

        .btn-danger {
            border-color: transparent !important;
        }

        .table100.ver1 td {
            padding: 5px 2px !important;
        }

        div#redips-drag td, .redips-drag {
            font-size: 9px !important;
        }

        .input-group-addon {
            padding: 9px 12px;
        }

        .explode td {
            padding: 2px;
        }

        #MainCard {
            box-shadow: 0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22);
        }
    </style>

       <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <div class="col-sm-12" style="padding-top: 15px;">
                <div class="row">
                    <div class="card" id="MainCard">
                        <div class="card-body">
                            <div class="table-title">
                                <div class="row">
                                    <div class="col-sm-12">
                                        <h3 runat="server" id="txtHeader">Capacity Planning</h3>
                                    </div>
                                </div>
                            </div>
                            <div class="table-responsive" style="overflow-x: hidden;" id="ehDTR">
                                <!-- tables inside this DIV could have draggable content -->
                                <div id="redips-drag">
                                    <div class="col-sm-12">
                                        <div class="form-group row mt-2">

                                            <div class="col-sm-1">
                                                <div class="custom-control custom-checkbox">
                                                    <input type="checkbox" class="custom-control-input" id="week" onclick="myWeek()" checked />
                                                    <label class="custom-control-label control-label" for="week">All</label>
                                                </div>
                                            </div>

                                            <div class="col-sm-1">
                                                <div class="custom-control custom-checkbox">
                                                    <input type="checkbox" class="custom-control-input" id="report" onclick="myReport()" />
                                                    <label class="custom-control-label control-label" for="report">Single</label>
                                                </div>
                                            </div>

                                            <label class="control-label col-sm-2">Date Range</label>
                                            <div class="col-sm-3">
                                                <div class="input-group date" id="datetimepicker2">
                                                    <input type="text" class="form-control" id="CutOffDateCutOff" style="text-align: center;" />
                                                    <span class="input-group-addon">
                                                        <i class="fa fa-calendar" aria-hidden="true"></i>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <!-- left container (table with subjects) -->

                                        <!-- left container -->
                                        <div class="table-responsive col-sm-2">
                                            <div class="table100 ver1">
                                                <table id="table1" data-vertable="ver1" class="table table-sm table-bordered">
                                                    <thead>
                                                        <tr class="row100 head">
                                                            <td class="column100 column1 redips-trash" data-column="column1" title="Trash" style="color: #fff;">Drop to Remove FG-SKU</td>
                                                        </tr>
                                                        <tr class="row100 head">
                                                            <td class="column100 column1" data-column="column1">SKU Base on Counterplan</td>
                                                        </tr>
                                                    </thead>
                                                    <tbody>

                                                      <%--  
                                                        <tr class="row100" role="row">
                                                            <td class="column100 column1 dark" data-column="column1">
                                                                <div data-id="Grinder" data-nowork="S" class="redips-drag redips-clone bi" style="background-color: red">7700030 - Bossing Regular</div>
                                                            </td>
                                                        </tr>
                                                        <tr class="row100" role="row">
                                                            <td class="column100 column1 dark" data-column="column1">
                                                                <div data-id="Grinder" data-nowork="S" class="redips-drag redips-clone " style="background-color: blue">7700035 - Bossing Classic</div>
                                                            </td>
                                                        </tr>
                                                        <tr class="row100" role="row">
                                                            <td class="column100 column1 dark" data-column="column1">
                                                                <div data-id="Grinder" data-nowork="S" class="redips-drag redips-clone " style="background-color: green">7700035 - Bossing Jumbo</div>
                                                            </td>
                                                        </tr>--%>
                                                       
                                                        <% for (var data = 0; data < TableShift.Rows.Count; data++)
                                                            { %>
                                                        <tr class="row100" role="row">
                                                            <td class="column100 column1 dark" data-column="column1">
                                                                <div data-id="<%=TableShift.Rows[data]["ShiftMaintenanceCode"]%>" data-nowork="<%=TableShift.Rows[data]["NoWorkingDay"]%>" class="redips-drag redips-clone " style="background-color: <%=TableShift.Rows[data]["Color"]%>"><%=TableShift.Rows[data]["Shift"]%></div>
                                                            </td>
                                                        </tr>
                                                        <% } %>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>

                                        <!-- right container -->
                                        <div class="table-responsive col-sm-10" id="tblMaster">
                                            <div class="table100 ver1" style="overflow-x: auto;">
                                                <table id="tblSchedule" data-vertable="ver1" class="table table-bordered table-hover">
                                                    <thead>
                                                        <tr class="row100 head">
                                                            <!-- if checkbox is checked, clone school subjects to the whole table row  -->
                                                            <th class="column100 column1 redips-mark blank" data-column="column1">Machines
                                                            </th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>

                                                        <%--            <% for (var data = 0; data < TableTeam.Rows.Count; data++)
                                                        { %>
                                                    <tr class="sub-container">
                                                        <td class="redips-mark dark" data-id="<%=TableTeam.Rows[data]["TeamCode"]%>" data-emp="All">
                                                            <button id="btn<%=TableTeam.Rows[data]["TeamCode"]%>" type="button" class="btn btn-sm exploder btn-success" style="display: none;">
                                                                <i class="fa fa-plus"></i>
                                                            </button>
                                                            <%=TableTeam.Rows[data]["Team"]%>
                                                        </td>
                                                    </tr>
                                                    <tr class="explode hide">
                                                        <td id="<%=TableTeam.Rows[data]["TeamCode"]%>td" colspan="5" style="background: rgb(204, 204, 204); display: none;"></td>
                                                    </tr>
                                                    <% } %>--%>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>

                                        <!-- right container -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="js/redips-drag-min.js"></script>
    <script type="text/javascript" src="js/redips-script.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {

            let CutOffDateStart = '5/2/2021';
            let CutOffDateEnd = '5/8/2021';

            InitDepartment();

            $('#CutOffDateCutOff').daterangepicker({
                opens: 'center'
            }, function (start, end, label) {

                fetch(InitColAppend(start.format('MM/DD/YY'), end.format('MM/DD/YY')), {
                }).then(function () {
                    InitializeShiftPerTeam(start.format('MM/DD/YY'), end.format('MM/DD/YY'));
                }).catch(function (error) {
                    console.log(error);
                })

            });
            $('#CutOffDateCutOff').data('daterangepicker').setStartDate(CutOffDateStart);
            $('#CutOffDateCutOff').data('daterangepicker').setEndDate(CutOffDateEnd);

            // 1st - Load Department 
            function InitDepartment() {
                fetch("frmSchedule.aspx/GetDataTeam", {
                    method: "POST",
                    body: '{}',
                    headers: {
                        "Content-Type": "application/json;charset=utf-8"
                    },
                }).then(function (response) {
                    return response.json()
                }).then(function (data) {
                    let tbody = [];
                    let nodelisttbodytr = document.querySelectorAll('#tblSchedule tbody tr');
                    [].forEach.call(nodelisttbodytr, function (node) {
                        node.parentNode.removeChild(node);
                    });
                    for (var i = 0; i < data.d.length; i++) {
                        tbody.push(
                            "<tr class='row100 sub-container' role='row'>" +
                            "<td class='column100 column1 redips-mark dark' data-column='column1' data-id=" + data.d[i].TeamCode + " data-emp='All'>" +
                            "<button id=" + "btn" + data.d[i].TeamCode + " type='button' class='btn btn-sm exploder btn-success' style='display: none;'>" +
                            "<i class='fa fa-plus'></i>" +
                            "</button>" +
                            "" + data.d[i].Team + "" +
                            "</td>" +
                            "</tr class='row100' role='row'>" +
                            "<tr class='explode hide'>" +
                            "<td id=" + data.d[i].TeamCode + "td" + " colspan='5'style='background: rgb(204, 204, 204); display: none;'> " +
                            "</td>" +
                            "</tr>");
                    }
                    document.querySelectorAll("#tblSchedule tbody")[0].innerHTML = tbody.join('');

                    InitDepartmentEmployee();

                }).catch(function (error) {
                    console.log(error);
                })
            }
            // 2nd - Load Employee To it's Department
            function InitDepartmentEmployee() {
                fetch("frmSchedule.aspx/GetDataEmpUnder", {
                    method: "POST",
                    body: '{}',
                    headers: {
                        "Content-Type": "application/json;charset=utf-8"
                    },
                }).then(function (response) {
                    return response.json()
                }).then(function (result) {
                    let objDetails = {};
                    objDetails = result.d.slice();
                    for (var i = 0; i < objDetails.length; i++) {
                        $('#' + objDetails[i].TeamCode + '').remove();
                        //$("#" + objDetails[i].TeamCode + "td").append("<table id='" + objDetails[i].TeamCode + "' data-id='" + objDetails[i].TeamCode + "' " +
                        //    "class='table table-sm table-bordered'><tbody></tbody></table>");
                        let tableTeam = [];
                        tableTeam.push(
                            "<table id='" + objDetails[i].TeamCode + "' data-id='" + objDetails[i].TeamCode + "' " +
                            "class='table table-sm table-bordered'><tbody></tbody></table>");
                        document.getElementById("" + objDetails[i].TeamCode + "td").innerHTML = tableTeam.join('');
                        document.getElementById("btn" + objDetails[i].TeamCode + "").style.display = "inline-block";
                    }

                    for (var i = 0; i < objDetails.length; i++) {
                        $("#" + objDetails[i].TeamCode + "").append(
                            "<tr class='row100' role='row'> " +
                            "<td class='column100 column1 redips-mark dark' data-column='column1' data-id=" + objDetails[i].TeamCode + " data-emp=" + objDetails[i].EmployeeCode + ">" + objDetails[i].FullName + "</td>" +
                            "</tr>");
                    }

                    //Append Column For Date
                    fetch(InitColAppend(CutOffDateStart, CutOffDateEnd), {
                    }).then(function () {
                        //Append Shift per Employee
                        InitializeShiftPerTeam(CutOffDateStart, CutOffDateEnd);
                    }).catch(function (error) {
                        console.log(error);
                    });
                    $(".exploder").click(function () {

                        $(this).toggleClass("btn-success btn-danger");

                        $(this).children("i").toggleClass("fa fa-plus fa fa-minus");

                        $(this).closest("tr").next("tr").toggleClass("hide");

                        if ($(this).closest("tr").next("tr").hasClass("hide")) {
                            $(this).closest("tr").next("tr").children("td").slideUp();
                        } else {
                            $(this).closest("tr").next("tr").children("td").slideDown(350);
                        }
                    });

                }).catch(function (error) {
                    console.log(error);
                })
            }
            // 3rd - Append Columns Depends on date range or date select
            function InitColAppend(StartDate, EndDate) {
                const StartCutOffDate = StartDate;
                const EndCutOffDate = EndDate;
                const startDate = new Date(StartCutOffDate);
                const endDate = new Date(EndCutOffDate);
                const datesArr = getDates(startDate, endDate);
                if (startDate.getMonth() == endDate.getMonth()) {
                    AppendCol(datesArr);
                }
                else if (endDate.getMonth() > startDate.getMonth()) {
                    AppendCol(datesArr);
                }
                else {
                    console.log("End Date is below Start Date!!!");
                }
            }
            // 4th - Load Shift of Per Employee Depends on its date
            function InitializeShiftPerTeam(StartDate, EndDate) {
                let objDetails = {};
                objDetails.StartDate = StartDate;
                objDetails.EndDate = EndDate;

                fetch("frmSchedule.aspx/GetShiftPerTeam", {
                    method: "POST",
                    body: '{objCutOff: ' + JSON.stringify(objDetails) + '}',
                    headers: {
                        "Content-Type": "application/json;charset=utf-8"
                    },
                }).then(function (response) {
                    return response.json()
                }).then(function (data) {
                    let nodeList = document.querySelectorAll('#tblMaster table');
                    [].forEach.call(nodeList, function (node) {
                        //Get every table ID
                        var table = document.getElementById("" + node.id + "");
                        //For Rows
                        for (let r = 0; r < table.rows.length; r++) {
                            // For Columns
                            for (let c = 0; c < table.rows[r].cells.length; c++) {
                                // For not appending in first column
                                if (c != 0) {
                                    //Filling Data to rows and coloumns
                                    for (let i = 0; i < data.d.length; i++) {
                                        //Check if the data belongs to the specific row and colomn thru Date, EmployeeCode, TeamCode
                                        if (table.rows[r].cells[c].getAttribute("data-date") == data.d[i].Date &&
                                            table.rows[r].cells[0].getAttribute("data-id") == data.d[i].TeamCode &&
                                            table.rows[r].cells[0].getAttribute("data-emp") == data.d[i].EmployeeCode) {
                                            //If restday
                                            if (data.d[i].NoWorkingDay == 1) {
                                                table.rows[r].cells[c].innerHTML = "<div id='" + data.d[i].ScheduleCode + "' class='redips-drag redips-clone " + data.d[i].Color + "' style='border-style: solid; cursor: move;background: gray;color: #fff;'>RESTDAY</div>";
                                            }
                                            //If not restday
                                            else {
                                                table.rows[r].cells[c].innerHTML = "<div id='" + data.d[i].ScheduleCode + "' class='redips-drag redips-clone " + data.d[i].Color + "' style='border-style: solid; cursor: move;'>" + data.d[i].Description + "</div>";
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        REDIPS.drag.init();
                    });

                }).catch(function (error) {
                    console.log(error);
                })
            }

            // Function Call For Append
            function AppendCol(datesArr) {
                const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
                const tblHeadObj = document.getElementById("tblSchedule").tHead;
                const nodeList = document.querySelectorAll('#tblMaster table');
                let tblColsCount;

                [].forEach.call(nodeList, function (node) {
                    //console.log(this.id);
                    const allCols = document.getElementById("" + node.id + "").rows[0].cells.length;
                    const allRows = document.getElementById("" + node.id + "").rows;

                    //Delte Column
                    for (var i = 0; i < allCols; i++) {
                        for (var k = 0; k < allRows.length; k++) {
                            if (allRows[k].cells.length > 1) {
                                allRows[k].deleteCell(-1);
                            }
                        }
                    }

                });

                //Append Column
                for (var i = 0, inc = 2; i < datesArr.length; i++ , inc++) {
                    //Append thead
                    for (var h = 0; h < tblHeadObj.rows.length; h++) {
                        var newTH = document.createElement('th');
                        tblHeadObj.rows[h].appendChild(newTH);
                        newTH.setAttribute("class", "column100 column" + inc + " redips-mark blank");
                        newTH.setAttribute("data-column", "column" + inc + "");
                        newTH.setAttribute("data-id", datesArr[i].getMonth() + 1 + "/" + datesArr[i].getDate() + "/" + datesArr[i].getFullYear());
                        var dayName = days[datesArr[i].getDay()]
                        newTH.innerHTML = dayName.substring(0, 3) + " " + datesArr[i].getDate();
                    }

                    //Append tbody
                    [].forEach.call(nodeList, function (node) {
                        var tblBodyObj = document.getElementById("" + node.id + "").tBodies[0];
                        if (node.id == "tblSchedule") { // for master table
                            for (var d = 0; d < tblBodyObj.rows.length; d++) {
                                if ((d % 2) == 0) { //To Avoid sub td to be append by another td
                                    var newCell = tblBodyObj.rows[d].insertCell(-1);
                                    newCell.setAttribute("class", "column100 column" + inc + "");
                                    newCell.setAttribute("data-column", "column" + inc + "");
                                    newCell.setAttribute("data-date", datesArr[i].getMonth() + 1 + "/" + datesArr[i].getDate() + "/" + datesArr[i].getFullYear());
                                }
                            }
                        }
                        else {
                            for (var d = 0; d < tblBodyObj.rows.length; d++) {
                                var newCell = tblBodyObj.rows[d].insertCell(-1);
                                newCell.setAttribute("class", "column100 column" + inc + "");
                                newCell.setAttribute("data-column", "column" + inc + "");
                                newCell.setAttribute("data-date", datesArr[i].getMonth() + 1 + "/" + datesArr[i].getDate() + "/" + datesArr[i].getFullYear());
                            }
                            tblColsCount = (document.getElementById('tblSchedule').rows[0].cells.length);
                            document.getElementById("" + node.id + "td").colSpan = tblColsCount;
                        }

                    });

                }
            }
        });

        // Returns an array of dates between the two dates
        function getDates(startDate, endDate) {
            var dates = [],
                currentDate = startDate,
                addDays = function (days) {
                    var date = new Date(this.valueOf());
                    date.setDate(date.getDate() + days);
                    return date;
                };
            while (currentDate <= endDate) {
                dates.push(currentDate);
                currentDate = addDays.call(currentDate, 1);
            }
            return dates;
        };

        function myWeek() {
            var cbWeek = document.getElementById("week");
            if (cbWeek.checked == true) {
                document.getElementById("week").checked = true;
                document.getElementById("report").checked = false;
            }
        }

        function myReport() {
            var cbReport = document.getElementById("report");
            if (cbReport.checked == true) {
                document.getElementById("report").checked = true;
                document.getElementById("week").checked = false;
            }
        }

        const setElementHeightCard = function () {
            let height = $(window).height();
        //    $('.dataTables_scrollBody').css('min-height', (height - 250));
        };

        const setElementHeight = function () {
            let height = $(window).height();
       //     $('#MainCard').css('min-height', (height - 35));
        };

        $(window).on("resize", function () {
            setElementHeight();
            setElementHeightCard();
        }).resize();

    </script>
</body>
</html>
