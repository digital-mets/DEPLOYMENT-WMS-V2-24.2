/*
keyboard Navigation plugin for Gridview in GWL
Author: Erastian Sy
Created Date: 11/19/2016
Description: Enables the use of keyboard functionalities to navigate through the aspxgridview
Controls:
Ctrl + Up,Down,Left,Right while in edit mode of rows
Enter to navigate to bottom row or add row if no rows exist
(Note: Report any bugs that have been encountered to me :D )
list of Revisions:
11/20/2016 - Changed right/left keyup event script; Remove auto add new row; Change how the enter key works
11/21/2016 - Add delete key function
*/

var FocusedCellColumnIndex = 0;
var FocusedCellRowIndex = 0;
var keybGrid;
var entervalue = 0;
var keyOff; //to turn off pressing any keys while callback on going

function keyboardOnStart(e) {
    FocusedCellColumnIndex = e.focusedColumn.index;
    FocusedCellRowIndex = e.visibleIndex;

    //$('body').css({ //Disables page scrolling during editing of grid, so that page won't scroll while using keyb navigation
    //    overflow: 'hidden',
    //});
}

function keyboardOnEnd() { // sa scroll lang naman to RA
    FocusedCellColumnIndex = 0;
    FocusedCellRowIndex = 0;

    //if (!GridPop.IsVisible())
    //$('body').css({ //Enables page scrolling
    //    overflow: 'auto',
    //    height: 'auto'
    //});
}

function OnInit(gv) {

    console.log(entervalue);
    ASPxClientUtils.AttachEventToElement(gv.GetMainElement(), "keydown", function (evt) {
        if (evt.keyCode === ASPxClientUtils.StringToShortcutCode("UP") && evt.ctrlKey)
            UpPressed();
        else if (evt.keyCode === ASPxClientUtils.StringToShortcutCode("DOWN") && evt.ctrlKey)
            DownPressed();
        else if ((evt.keyCode === ASPxClientUtils.StringToShortcutCode("RIGHT") && evt.ctrlKey) || evt.keyCode === 9)

            RightPressed(evt);
        else if (evt.keyCode === ASPxClientUtils.StringToShortcutCode("LEFT") && evt.ctrlKey)
            LeftPressed(evt);
        else if (evt.keyCode === 13) { //Navigate to bottom row/Add New row if no rows exist
            DownPressed();
            ASPxClientUtils.PreventEventAndBubble(evt);
        }
        else if (evt.keyCode === 46) //Delete row
            DeletePressed();
    });
}

var arrayRow = new Array();
function calculatePos() { //Put all index of cells into an array to get a better knowledge about the location of the current cell
    var indicies = keybGrid.batchEditApi.GetRowVisibleIndices();
    for (var i = 0; i < indicies.length; i++) {
        var key = keybGrid.GetRowKey(indicies[i]);
        if (!keybGrid.batchEditApi.IsDeletedRow(key))
            arrayRow.push(indicies[i]);
    }
}

function UpPressed() {
    if (keyOff) return;
    calculatePos();

    var lastRecordIndex = arrayRow.indexOf(FocusedCellRowIndex);
    keybGrid.batchEditApi.StartEdit(arrayRow[lastRecordIndex - 1], FocusedCellColumnIndex);
    arrayRow = [];
}

function DownPressed() {
    if (keyOff) return;

    calculatePos();

    var lastRecordIndex = arrayRow.indexOf(FocusedCellRowIndex);
    if (FocusedCellRowIndex == arrayRow[arrayRow.length - 1]) { //Check if current focus row is the last row, if yes then add new row
        keybGrid.batchEditApi.EndEdit();

        if (entervalue === 0) {

         
        }
        keybGrid.batchEditApi.EndEdit();

    }
    else
        if (entervalue === 0) {
            keybGrid.batchEditApi.StartEdit(arrayRow[lastRecordIndex + 1], FocusedCellColumnIndex);

        }

    arrayRow = [];
}


function RightPressed(e) {
    //if (FocusedCellColumnIndex + 1 == parseInt(arrayCol2[arrayCol2.indexOf(FocusedCellColumnIndex + 1)]))
    //    keybGrid.batchEditApi.StartEdit(FocusedCellRowIndex, FocusedCellColumnIndex + 2);
    //else
    //    keybGrid.batchEditApi.StartEdit(FocusedCellRowIndex, FocusedCellColumnIndex + 1);
    if (keyOff) return;

    if (keybGrid.batchEditApi["MoveFocusForward"]()) {
        ASPxClientUtils.PreventEventAndBubble(e);
    }
}

function LeftPressed(e) {
    //if (FocusedCellColumnIndex - 1 == parseInt(arrayCol2[arrayCol2.indexOf(FocusedCellColumnIndex - 1)]))
    //    keybGrid.batchEditApi.StartEdit(FocusedCellRowIndex, FocusedCellColumnIndex - 2);
    //else
    //    keybGrid.batchEditApi.StartEdit(FocusedCellRowIndex, FocusedCellColumnIndex - 1);
    if (keyOff) return;
    if (keybGrid.batchEditApi["MoveFocusBackward"]()) {
        ASPxClientUtils.PreventEventAndBubble(e);
    }
}

function DeletePressed() {
    keybGrid.DeleteRow(FocusedCellRowIndex);
}

var codes = new Array(3);
codes[0] = 38; // Up
codes[1] = 40; // Down

var flagUpDown;
var cbvalue;
function cb_KeyDown(s, e) { //Gets combobox value during up/down button press
    if (codes.indexOf(e.htmlEvent.keyCode) !== -1 && e.htmlEvent.ctrlKey) { //Check if ctrl + key
        flagUpDown = true;
        cbvalue = s.GetValue();
        // Move focus to the next cell.
    }
    if (e.htmlEvent.keyCode == 46 || e.htmlEvent.keyCode == 8) //Remove value of combobox when backspace/delete key press
        s.SetSelectedIndex(-1);
}

function cb_ValueChanged(s, e) { //This prevents setting default value to combobox during key navigation
    if (flagUpDown) {
        s.SetValue(cbvalue);
        flagUpDown = false;
        cbvalue = null;
    }
}
