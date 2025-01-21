
async function ConstTABLE(Count,Data,TableName,orderbycolumn,orderby) {
    
    //Initial Table Start
    let tHead = document.createElement("tHead");
    tHead.setAttribute('id', 'DetailHead' + Count);
    let tBody = document.createElement("tBody");// CREATE TABLE BODY .
    tBody.setAttribute('id', 'DetailBody' + Count);
    let hTr = document.createElement("tr"); // CREATE ROW FOR TABLE HEAD .

    let col = []; // define an empty array
                      
    //col.push('Select');
    for (var i = 0; i < Data.length; i++) {

        for (var key in Data[i]) {
            if (col.indexOf(key) === -1) {
                col.push(key);
            }
        }
    }

    // ADD COLUMN HEADER TO ROW OF TABLE HEAD.
    for (var i = 0; i < col.length; i++) {
        let th = document.createElement("th");
        th.setAttribute('class', 'th-lg');
        if ( col[i] =='name'){th.setAttribute('style', 'text-align: center;width: 10px;');}
        else{th.setAttribute('style', 'text-align: center;');}
                
        th.setAttribute('id',col[i] );
        th.scope = "col";
        th.innerHTML = col[i];
        hTr.appendChild(th);
                
    }
    tHead.appendChild(hTr);

    for (var i = 0; i < Data.length; i++) {
        let bTr = document.createElement("tr"); // CREATE ROW FOR EACH RECORD .
        for (var j = 0; j < col.length; j++) {

            let td = document.createElement("td");

            if (isNaN(Data[i][col[j]]) || Data[i][col[j]] == null || Data[i][col[j]] == true || Data[i][col[j]] == false) {

                td.innerHTML = Data[i][col[j]];
                td.id = Data[i][col[j]];     
                td.innerHTML = Data[i][col[j]];
                td.style.textAlign = "center";

            }else{

                td.innerHTML = Data[i][col[j]];
                td.id = Data[i][col[j]];
                td.style.textAlign = "center";
            }
            bTr.appendChild(td);

        }
        tBody.appendChild(bTr)
    }
    if ($.fn.DataTable.isDataTable('#' + TableName)) {
   
        $('#'+TableName).DataTable().destroy();
    }
    $('#'+TableName).empty();


    $('#'+TableName).append(tHead);
    
    $('#'+TableName).append(tBody);
    var x = ($('#' + TableName).parent().height()-45)+'px';
 
    if (Data.length > 0) {
        $('#' + TableName).DataTable({
            "orderCellsTop": true,
            "fixedHeader": true,
            "destroy": true,
            "scrollX": true,
            "scrollY": x,
            "scrollCollapse": true,
            "render": true,
            "searching": false,
            "paging": false,
            "info": false,
            "pageLength": 20,
            "order": [[orderbycolumn, orderby]],
            "autoWidth": true,
            "columnDefs": [{
                "defaultContent": "",
                "searchable": true,
                "orderable": false,


            }],


        }).columns.adjust().draw();
    } else { }
    
}



