let DateStart;
let DateEnd;
        
document.addEventListener("DOMContentLoaded", () => {

    $('#daterangetrans').daterangepicker({
        opens: 'center'
    }, function (start, end, label) {
        console.log("A new date selection was made: " + start.format('YYYY-MM-DD') + ' to ' + end.format('YYYY-MM-DD'));
        DateStart =   start.format('YYYY-MM-DD');
        DateEnd =   end.format('YYYY-MM-DD');
        updateData();
    });
 
$("#dash-period").datepicker({
    format: "M-yyyy",
    viewMode: "months",
    minViewMode: "months",
    autoclose: true
});

$('#dash-period').datepicker( 'option' , 'onSelect', function (date) { // 'onSelect' here, but could be any datepicker event
    //$(this).change(); // Lauch the "change" evenet of the <input> everytime someone click a new date
              
});

var strArray=['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

$.ajax({
    type: "POST",
    data: JSON.stringify({ Code: "BOOKDATE" }),
    url: "/PerformSender.aspx/SS",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (result) {
        bookdate = result.d;
        var d = new Date(bookdate);
        $('#dash-period').val(strArray[d.getMonth() - 1] + '-' + d.getFullYear());


        var datesd = new Date(bookdate);
        var dateEd = new Date();

        $('#daterangetrans').data('daterangepicker').setStartDate(datesd);
        $('#daterangetrans').data('daterangepicker').setEndDate(dateEd);
        DateStart =   datesd.getFullYear() + '-' + ('0' + (datesd.getMonth() + 1)).slice(-2) + '-' + ('0' + datesd.getDate()).slice(-2);
        DateEnd =   dateEd.getFullYear() + '-' + ('0' + (dateEd.getMonth() + 1)).slice(-2) + '-' + ('0' + dateEd.getDate()).slice(-2);
        
        GetData();
    }

});
            
});

function GetData() {
    console.log('initialget');

    let parameters = {
        DateStart,
        DateEnd
        }
    $.ajax({
        type: "POST",
        url: "frmDashboardBasic2.aspx/GetData",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: '{_data:' + JSON.stringify(parameters) + '}',
        success: function (data) {
            // CARDS START
            let Card1 = JSON.parse(data.d[0]);
            let Card2 = JSON.parse(data.d[1]);
            let Card3 = JSON.parse(data.d[2]);
            let Card4 = JSON.parse(data.d[3]);
            console.log(Card1[0].Count);
            console.log(Card2[0].Count);
            console.log(Card3[0].Count);
            console.log(Card4[0].Count);

            document.getElementById('Unsub').innerHTML = Card1[0].Count;
            document.getElementById('Sub').innerHTML = Card2[0].Count;
            document.getElementById('Cancel').innerHTML = Card3[0].Count;
            document.getElementById('ForSync').innerHTML = Card4[0].Count;

            // CARDS END

            //table(data);

            //loaderout();
        },
        error: function (error) {
            Swal.fire("", error.responseJSON.Message, "error");
        }
    });
}


function updateData() {
    console.log('getupdate');

    let parameters = {
        DateStart,
        DateEnd
        }
    console.log(parameters);

    //document.getElementById('ForSync').innerHTML = abcTotal[0].Total;

}

