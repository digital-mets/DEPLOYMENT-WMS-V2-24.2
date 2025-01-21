

/* enable strict mode */
"use strict";

// create redips container
let redips = {};

// redips initialization
redips.init = function () {
    // reference to the REDIPS.drag object
    let rd = REDIPS.drag;
    // initialization
    rd.init();
    // REDIPS.drag settings
    rd.dropMode = "single"; // dragged elements can be placed only to the empty cells
    rd.hover.colorTd = "#9BB3DA"; // set hover color
    rd.clone.keyDiv = true; // enable cloning DIV elements with pressed SHIFT key
    // prepare node list of DIV elements in tblSchedule
    redips.divNodeList = document
        .getElementById("tblSchedule")
        .getElementsByTagName("div");

    // element is dropped
    rd.event.dropped = function (el) {
        let objOld = rd.objOld, // original object
            targetCell = rd.td.target, // target cell
            targetRow = targetCell.parentNode, // target row
            i,
            objNew, // local letiables
            pos = rd.getPosition(); // Position

        let indexRow = rd.td.target.parentNode.rowIndex;
        let tableName = targetRow.parentNode.parentNode.getAttribute("id"); //Get tableName where it drop
        let TeamCode = document
            .getElementById("" + tableName + "")
            .rows[indexRow].cells[0].getAttribute("data-id");
        let EmployeeCode = document
            .getElementById("" + tableName + "")
            .rows[indexRow].cells[0].getAttribute("data-emp");
        let NoWorkingDay = rd.obj.getAttribute("data-nowork");
        let objDetail = [];

        objDetail.push({
            TeamCode: TeamCode,
            Date: targetCell.getAttribute("data-date"),
            ShiftCode: rd.obj.getAttribute("data-id"),
            EmployeeCode: EmployeeCode,
        });

        // if checkbox is checked and original element is of clone type then clone spread subjects to the week
        if (
            document.getElementById("week").checked === true &&
            objOld.className.indexOf("redips-clone") > -1
        ) {
            // loop through table cells
            for (i = 0; i < targetRow.cells.length; i++) {
                // skip cell if cell has some content (first column is not empty because it contains label)
                if (targetRow.cells[i].childNodes.length > 0) {
                    continue;
                }
                // clone DIV element
                objNew = rd.cloneObject(objOld);
                let today = new Date(targetRow.cells[i].getAttribute("data-date"));
                for (let l = 0; l < NoWorkingDay.length; l++) {
                    if (
                        parseInt(today.getDay() + 1) == parseInt(NoWorkingDay.charAt(l)) 
                    ) {
                        objDetail.push({
                            TeamCode: TeamCode,
                            Date: targetRow.cells[i].getAttribute("data-date"),
                            ShiftCode: rd.objOld.getAttribute("data-id"),
                            EmployeeCode: EmployeeCode,
                        });
                        objNew.innerHTML = "RESTDAY";
                        objNew.style.backgroundColor = "gray";
                        objNew.style.color = "#fff";
                    } else {
                        objDetail.push({
                            TeamCode: TeamCode,
                            Date: targetRow.cells[i].getAttribute("data-date"),
                            ShiftCode: rd.objOld.getAttribute("data-id"),
                            EmployeeCode: EmployeeCode,
                        });
                    }
                }
                targetRow.cells[i].appendChild(objNew);
            }
        }
    
        fetch("frmSchedule.aspx/SaveSchedule", {
            method: "POST",
            body: "{ objShift :" + JSON.stringify(objDetail) + "}",
            headers: {
                "Content-Type": "application/json;charset=utf-8",
            },
        })
            .then(function (response) {
                return response.json();
            })
            .then(function (data) { })
            .catch(function (error) {
                console.log(error);
            });
        // show / hide report buttons
    };

    // after element is deleted from the timetable, print message
    rd.event.deleted = function () {
        //alert(rd.objOld.id);
        let objDetails = {};
        objDetails.ScheduleCode = rd.objOld.id;
        fetch("frmSchedule.aspx/RemoveShift", {
            method: "POST",
            body: "{objShift: " + JSON.stringify(objDetails) + "}",
            headers: {
                "Content-Type": "application/json;charset=utf-8",
            },
        })
            .then(function (response) {
                return response.json();
            })
            .then(function (data) {
                // define reference to the DIV element with id="d1"
                let div = document.getElementById("" + rd.objOld.id + "");
                // remove child from DOM (DIV element still exists in memory)
                div.parentNode.removeChild(div);
            })
            .catch(function (error) {
                console.log(error);
            });
    };

    // if any element is clicked, then make all subjects in timetable visible
    rd.event.clicked = function () {
        redips.showAll();
    };
};

// save elements and their positions
redips.save = function () {
    // scan timetable content
    let content = REDIPS.drag.saveContent("tblSchedule");
    // and save content
    window.location.href = "db_save.php?" + content;
};

// function show all subjects in timetable
redips.showAll = function () {
    let i; // loop letiable
    for (i = 0; i < redips.divNodeList.length; i++) {
        redips.divNodeList[i].style.visibility = "visible";
    }
};

// add onload event listener
if (window.addEventListener) {
    window.addEventListener("load", redips.init, false);
} else if (window.attachEvent) {
    window.attachEvent("onload", redips.init);
}
