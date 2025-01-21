var loadTime;




//DISABLE INSPECT

document.addEventListener('contextmenu', function (e) {
    e.preventDefault();
});

document.onkeydown = function (e) {
    if (event.keyCode == 123) {
        return false;
    }
    if (e.ctrlKey && e.shiftKey && e.keyCode == 'I'.charCodeAt(0)) {
        return false;
    }
    if (e.ctrlKey && e.shiftKey && e.keyCode == 'J'.charCodeAt(0)) {
        return false;
    }
    if (e.ctrlKey && e.shiftKey && e.keyCode == 'C'.charCodeAt(0)) {
        return false;
    }
    if (e.ctrlKey && e.keyCode == 'U'.charCodeAt(0)) {
        return false;
    }
}

function PerfStart(m, e, i) {
    window.setTimeout(function () {
        loadTime = window.performance.timing.domContentLoadedEventEnd - window.performance.timing.navigationStart;
        console.log('Page load time is ' + loadTime / 1000);
        perfSend(m, e, i, loadTime);
    }, 0);
}

function perfSend() {
    var xhr = $.ajax({
        type: "POST",
        data: JSON.stringify({ ModuleID: module, Entry: entry, Pkey: id, Interval: loadTime / 1000, }),
        url: "/PerformSender.aspx/perfsend",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (result) {
            console.log('sent');
        }
    });
}