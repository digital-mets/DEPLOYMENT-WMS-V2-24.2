<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmMaterialOrder.aspx.cs" Inherits="GWL.frmMaterialOrder" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
<title> Material Order</title>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 800px; /*Change this whenever needed*/
        }

        .Entry {
            /*width: 1280px;*/ /*Change this whenever needed*/
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
            /*border-radius: 10px;
            -webkit-border-radius: 10px;
            -moz-border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
            -moz-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
            -webkit-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);*/
        }

        .dxeButtonEditSys input,
        .dxeTextBoxSys input{
          
        }

         .pnl-content
        {
            text-align: right;
        }
         .redCell {  
        background-color:red !important;  
        } 

         .TotDate tr{
              border:solid; 
              border-width:thin; 
              border-color:rgba(128, 128, 128, 0.54);
         }

          .uploadControlProgressBar {
            width: 250px !important;
        }

          .uploadControlDropZone,
        .hidden {
            display: none;
        }

        .ImageRadius {
            border-radius: 10px;
        }

        .pnl-content {
            text-align: right;
        }

        .txtboxInLine {
            float: left;
        }

         .img-thumbnail {
      border-radius: 5px;
      cursor: pointer;
      transition: 0.5s;
      animation-delay:0.5s;
        }

        .img-thumbnail:hover {
            
            transform: scale(1.5); 
            position:absolute;
            height:100%;
            width:auto;
            z-index:999999 !important;
            
        }


        .totalday{
            border-right:solid;  
            border-width:thin; 
            border-color:rgba(128, 128, 128, 0.54); 
            width:55px;
            height: 20px;
            padding-left:5px;
            text-align:center;
            
        }
    </style>
    <!--#endregion-->
    <script>
        var isValid = true;
        var counterror = 0;
        var counterrorWW = 0;
        var isValidWW = true;
        var counterrorRem = 0;
        var isValidRem = true;

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        var entry = getParameterByName('entry');

        function formLayout_OnInit(s, e) {
            var entry = getParameterByName('entry');
            var parameters = getParameterByName('parameters');
            var revise = "ReviseTrans|" + getParameterByName('docnumber');
            var docnumber = getParameterByName('docnumber');
            var doc = docnumber.split('-')[1];
            console.log(doc);
            var Revision = s.GetItemByName("Revision");

            

            if (entry == "N" && parameters != "") {

                                if (doc == "" || doc == null || doc == undefined) {
                                    document.getElementById("cp_frmlayout1_PC_0_txtDocnumber_I").value = docnumber.split('-')[0] + "-R1";

                                } else {
                                    var last = doc.slice(-1);
                                    var plus1 = 1;
                                    var lastplus = +last + +plus1;
                                    console.log('lasple')
                                    console.log(lastplus)
                                    document.getElementById("cp_frmlayout1_PC_0_txtDocnumber_I").value = docnumber.split('-')[0] + "-R" + lastplus;

                                }
        
                ReviseGrid();
                Revision.SetVisible(true);
                getDateRangeOfWeek();
                calculate_TotalKG(s, e);
                console.log('revise');
                document.getElementById("cp_frmlayout1_PC_0_RRemarks_I").required = true;



            } else if (doc == "R1" || doc == "R2" || doc == "R3" || doc == "R4" || doc == "R5" || doc == "R6" || doc == "R7" || doc == "R8" || doc == "R9" || doc == "R10") {
                Revision.SetVisible(true);
                getDateRangeOfWeek();
                calculate_TotalKG(s, e);
                console.log('editrevise');
                document.getElementById("cp_frmlayout1_PC_0_RRemarks_I").required = true;

            }
            else{
                var d = new Date();
                var Year = d.getFullYear();
                var wweeks = document.getElementById("cp_frmlayout1_PC_0_WWeeks_I").value;
                

                currentdate = new Date();
                var oneJan = new Date(currentdate.getFullYear(), 0, 1);
                console.log(oneJan);
                var numberOfDays = Math.floor((currentdate - oneJan) / (24 * 60 * 60 * 1000));
                console.log(numberOfDays);
                var  Wweek= Math.ceil((currentdate.getDay() + 1 + numberOfDays) / 7);
                console.log(Wweek);
           
                Revision.SetVisible(false);
                getDateRangeOfWeek();
                calculate_TotalKG(s, e);
                //document.getElementById("cp_frmlayout1_PC_0_glYear_I").value = Year;
                if (wweeks == null || wweeks == ""){
                    document.getElementById("cp_frmlayout1_PC_0_txtWorkWeek_I").value = Wweek;
                } else {

                }
                getDateRangeOfWeek();

            }

            
        }
  

        function ReviseGrid(){
            var _indices = gv1.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < _indices.length; i++) {
                gv1.DeleteRow(_indices[i]);
            }

            gv1.AddNewRow();



            var _refindices = gv2.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < _refindices.length; i++) {


                gv1.AddNewRow();
                _indices = gv1.batchEditApi.GetRowVisibleIndices();


                gv1.batchEditApi.SetCellValue(_indices[0], 'DocNumber', gv2.batchEditApi.GetCellValue(_refindices[i], 'DocNumber'));
                gv1.batchEditApi.SetCellValue(_indices[0], 'LineNumber', gv2.batchEditApi.GetCellValue(_refindices[i], 'LineNumber'));
                gv1.batchEditApi.SetCellValue(_indices[0], 'SKUCode', gv2.batchEditApi.GetCellValue(_refindices[i], 'SAPCode'));
                gv1.batchEditApi.SetCellValue(_indices[0], 'ItemDescription', gv2.batchEditApi.GetCellValue(_refindices[i], 'ItemDescription'));
                gv1.batchEditApi.SetCellValue(_indices[0], 'BatchWeight', gv2.batchEditApi.GetCellValue(_refindices[i], 'BatchWeight'));
                gv1.batchEditApi.SetCellValue(_indices[0], 'PackagingType', gv2.batchEditApi.GetCellValue(_refindices[i], 'PackagingType'));
                gv1.batchEditApi.SetCellValue(_indices[0], 'Day1', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day1'));
                gv1.batchEditApi.SetCellValue(_indices[0], 'Day2', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day2'));
                gv1.batchEditApi.SetCellValue(_indices[0], 'Day3', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day3'));
                gv1.batchEditApi.SetCellValue(_indices[0], 'Day4', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day4'));
                gv1.batchEditApi.SetCellValue(_indices[0], 'Day5', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day5'));
                gv1.batchEditApi.SetCellValue(_indices[0], 'Day6', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day6'));
                gv1.batchEditApi.SetCellValue(_indices[0], 'Day7', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day7'));
                gv1.batchEditApi.EndEdit();
                gv1.DeleteRow(-1);


            }
            cleargv2();

        }

        function cleargv2() {
            var _refindices = gv2.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < _refindices.length; i++) {
                gv2.DeleteRow(_refindices[i]);
            }
        }







var module = getParameterByName("transtype");
        var id = getParameterByName("docnumber");
        var entry = getParameterByName("entry");

        $(document).ready(function () {
            PerfStart(module, entry, id);

        });

function OnValidation(s, e) { //Validation function for header controls (Set this for each header controls)
            if (s.GetText() == "" || e.value == "" || e.value == null) {
                counterror++;
                isValid = false
            }
            else {
                isValid = true;
            }
}

function OnValidationWW(s, e) { //Validation function for header controls (Set this for each header controls)
    currentdate = new Date();
    var oneJan = new Date(currentdate.getFullYear(), 0, 1);
    console.log(oneJan);
    var numberOfDays = Math.floor((currentdate - oneJan) / (24 * 60 * 60 * 1000));
    console.log(numberOfDays);
    var Wweek = Math.ceil((currentdate.getDay() + 1 + numberOfDays) / 7) -1;
    console.log(Wweek);
    

    if (s.GetText() <= Wweek || e.value <= Wweek) {
        counterrorWW++;
        isValidWW = false
    }
    else if (s.GetText() == "" || e.value == "" || e.value == null) {
        counterrorWW++;
        isValidWW = false
    }
    else {
        isValidWW = true;
    }
}

function OnValidationRem(s, e) { //Validation function for header controls (Set this for each header controls)
    var image = document.getElementById("cp_frmlayout1_PC_0_Uploadedpath_I").value;
    console.log(image);
    if (s.GetText() == "" || e.value == "" || e.value == null || image == "" || image == null) {
        counterrorRem++;
        isValidRem = false

        
    }
    else {
        isValidRem = true;
    }
}


function OnUpdateClick(s, e) { //Add/Edit/Close button function
    var btnmode = btn.GetText(); //gets text of button
    var docnumber = document.getElementById("cp_frmlayout1_PC_0_txtDocnumber_I").value;
    var doc = docnumber.split('-')[1];
  
    checkodd();
    if (btnmode == "Delete") {
        cp.PerformCallback("Delete");
    }
    if (doc != "R1") {
                                        if (isValidWW && counterrorWW <= 1 || btnmode == "Close") {
                                           
                                        } else {
                                            counterrorWW = 0;
                                            alert('Warning: Late encoding of Material Order ');
                                        }
                                        if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
                                            //Sends request to server side
                                            if (btnmode == "Add") {

                                                cp.PerformCallback("Add");
                                            }
                                            else if (btnmode == "Update") {
                                                cp.PerformCallback("Update");
                                            }
                                            else if (btnmode == "Close") {
                                                cp.PerformCallback("Close");
                                            }
                                        }


                                        else {
                                            counterror = 0;
                                            alert('Please check all the fields!');
                                        }
                                    }
    else {
                if (isValidRem && counterrorRem < 1 || btnmode == "Close") {

                                if (isValidWW && counterrorWW <= 1 || btnmode == "Close") {
                                   
                                } else {
                                    counterrorWW = 0;
                                    alert(' Warning: Late encoding of Material Order');
                                }


                                if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
                                    //Sends request to server side
                                    if (btnmode == "Add") {

                                        cp.PerformCallback("Add");
                                    }
                                    else if (btnmode == "Update") {
                                        cp.PerformCallback("Update");
                                    }
                                    else if (btnmode == "Close") {
                                        cp.PerformCallback("Close");
                                    }
                                }


                                else {
                                    counterror = 0;
                                    alert('Please check all the fields!');
                                }

                } else {
                    counterrorRem = 0;
                    alert(' Revision Remarks and Proof is required ');
                }

    }
}

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);
                if (s.cp_forceclose) {//NEWADD
                    delete (s.cp_forceclose);
                    window.close();
                }
            }
            if (s.cp_close) {
                if (s.cp_message != null) {
                    alert(s.cp_message);
                    delete (s.cp_message);
                }
                if (s.cp_valmsg != null && s.cp_valmsg != "" && s.cp_valmsg != undefined) {
                    alert(s.cp_valmsg);
                    delete (s.cp_valmsg);
                }
                if (glcheck.GetChecked()) {
                    delete (cp_close);
                    //window.location.reload();

                    var docno = document.getElementById("cp_frmlayout1_PC_0_txtDocnumber_I").value;
                    console.log(docno);

                    window.location.replace('../Production/frmMaterialOrder.aspx?entry=E&transtype=PRDMTO&parameters=&iswithdetail=null&docnumber=' + docno + '');
                }
                else {
                    delete (cp_close);
                    window.close();//close window if callback successful
                }
            }
            if (s.cp_delete) {
                delete (cp_delete);
                DeleteControl.Show();
            }
        }

        //var itemc;
        //var index;
        //var currentColumn = null;
        //var isSetTextRequired = false;
        //var linecount = 1;
        //function OnStartEditing(s, e) {//On start edit grid function     
        //    currentColumn = e.focusedColumn;
        //    var cellInfo = e.rowValues[e.focusedColumn.index];
        //    itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "SKUCode"); //needed var for all lookups; this is where the lookups vary for

        //    index = e.visibleIndex;
        //    var entry = getParameterByName('entry');

        //    if (entry == "V" || entry == "D") {
        //        e.cancel = true; //this will made the gridview readonly
        //    }
            

        //    if (e.focusedColumn.fieldName === "ProductOrder" ) { //Check the column name
        //        e.cancel = true;
        //    }

        //    //if (e.focusedColumn.fieldName === "ColorCode") {
        //    //    gl2.GetInputElement().value = cellInfo.value;
        //    //}
        //    //if (e.focusedColumn.fieldName === "ClassCode") {
        //    //    gl3.GetInputElement().value = cellInfo.value;
        //    //}
        //    if (e.focusedColumn.fieldName === "JobOrder") {
        //        gl4.GetInputElement().value = cellInfo.value;
        //    }
        //}

        // Function StepProcess_OnStartEditing, Enable/Disable editing


        function imageIsLoaded(data) {
            var imgID = "cp_frmlayout1_PC_0_picture1Img";
            cp_frmlayout1_PC_0_Uploadedpath.SetText('Uploaded')
            console.log(document.getElementById("cp_frmlayout1_PC_0_Uploadedpath").value);
            //console.log(imgID);
            if (data.files && data.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $("#" + imgID).attr("src", e.target.result);
                    //console.log(document.getElementById("cp_frmlayout1_PC_0_picture1Img").src);
                   
                };
                reader.readAsDataURL(data.files[0]);
                document.getElementById("cp_frmlayout1_PC_0_btnSave").click();
            } else {
                $("#" + imgID).attr("src", "../Assets/img/AdminImages/default.png");
            }
        }


        function ImageLoad() {
            var imgID = "cp_frmlayout1_PC_0_picture1Img";
            var FName = document.getElementById("FileName").value;
            var Remarks = document.getElementById("RRemarks").value;
            $("#" + imgID).attr("src", FName);
            $("#FileName").attr("Text", FName);
            $("#RRemarksText").attr("Text", Remarks);
            console.log($("#" + imgID).attr("src", FName));
            console.log(FName);
          
        }
        function remarksLoad() {
            
            var Remarks = document.getElementById("cp_frmlayout1_PC_0_RRemarks_I").value;
       
            var data = {};
            data.RRemarks = Remarks;
            $.ajax({
                type: "POST",
                url: "frmMaterialOrder.aspx/RemarksRev",
                data: '{name: ' + JSON.stringify(data) + ' }',
                contentType: "application/json",
                dataType: "json",
                success: function (data) {
                    //alert("Deleted Successfully")
                }
            });

        }

        function showImage(id) {
            var value = document.getElementById(id).src;
            $('#img01').attr('src', value);
            $("#myModal").modal("show");
        }

        //image
        function FrontImageUploadComplete(s, e) {
            if (e.isValid)
                CINFrontImage2D.SetImageProperties(e.callbackData, e.callbackData, '', '');
            var imagebinary = e.callbackData.replace('data:image/jpg;base64,', '');
            CIN2DFrontImage64string.SetText(imagebinary);
        }

        //image
        function BackImageUploadComplete(s, e) {
            if (e.isValid)
                CINBackImage2D.SetImageProperties(e.callbackData, e.callbackData, '', '');
            var imagebinary = e.callbackData.replace('data:image/jpg;base64,', '');
            CIN2DBackImage64string.SetText(imagebinary);
        }

        function UploadImageEmbroiderComplete(s, e) {
            if (e.isValid)
                //var ibits = e.callbackData.split("luisgeneledpao");
                //CINEmbroiderImage.SetImageUrl(ibits[0]);

                //CINEmbroiderImage.SetImageUrl(e.callbackData);
                CINEmbroiderImage.SetImageProperties(e.callbackData, e.callbackData, '', '');

            var imagebinary = e.callbackData.replace('data:image/jpg;base64,', '');
            //var imagebinary = ibits[0].replace('data:image/jpg;base64,', '');
            //s.batchEditApi.SetCellValue(index, "PictureEmbroider", imagebinary)
            CINgvEmbroiderDetail.batchEditApi.SetCellValue(index, "PictureEmbroider", imagebinary);
            //CINgvEmbroiderDetail.batchEditApi.SetCellValue(index, "PictureEmbroiderByte", ibits[1]);

            cp.HideLoadingPanel();
        }

        function UploadOtherImageComplete(s, e) {
            if (e.isValid)
                //  CINOtherPicturePicture.SetImageUrl(e.callbackData);
                CINOtherPicturePicture.SetImageProperties(e.callbackData, e.callbackData, '', '');

            var imagebinary = e.callbackData.replace('data:image/jpg;base64,', '');
            CINgvOtherPictures.batchEditApi.SetCellValue(index, "OtherPicture", imagebinary);
            console.log(imagebinary);
            cp.HideLoadingPanel();
        }

        function onImageLoad() {
            var externalDropZone = document.getElementById("externalDropZone");
            var uploadedImage = document.getElementById("uploadedImage");
            uploadedImage.style.left = (externalDropZone.clientWidth - uploadedImage.width) / 2 + "px";
            uploadedImage.style.top = (externalDropZone.clientHeight - uploadedImage.height) / 2 + "px";
            setElementVisible("dragZone", false);
        }
        //





        //Image 
        function OnStartEditing(s, e) {
            index = e.visibleIndex;
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            var entry = getParameterByName('entry');
            e.cancel = (entry == "V") ? true : false; //this will made the gridview readonly

            if (entry != "V") {

                if (e.focusedColumn.fieldName === "SKUCode") { //Check the column name
                    glSKUCode.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                    closing = true;
                    valchange = true;
                }
                if (e.focusedColumn.fieldName === "PackagingType") { //Check the column name
                    glPackagingType.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                    closing = true;
                    valchange = true;
                }

            }
        }

        // SKUCode valuechanged event
        function UpdateSKUDescription(values) {
            gv1.batchEditApi.SetCellValue(index, "SKUCode", values[0]);
            gv1.batchEditApi.SetCellValue(index, "ItemDescription", values[1]);
            gv1.batchEditApi.SetCellValue(index, "BatchWeight", values[2]);
            gv1.batchEditApi.SetCellValue(index, "PackagingType", values[3]);
            
            
        }
        function UpdatePackaging(values) {
            packaging = values[0];
            console.log(packaging);
            gv1.batchEditApi.SetCellValue(index, "PackagingType", values[0]);
           

        }
           
             
        
        function checkodd(s, e) {
            console.log('pumasok');
            setTimeout(function () {

                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                  
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {

                        Batches = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TotalBatch"));
                        if (Batches % 2 == 0) {

                        } else {
                            alert("SKUCode : " + item1 + " Total Batch is Odd");
                        }

                    }
                }

            }, 500);

        }
         
        // Auto Calculate KG

        function calculate_TotalKG(s, e) {

            //OnInitTrans();
            
            var TotDay1 = 0, TotDay2 = 0, TotDay3 = 0, TotDay4 = 0, TotDay5 = 0, TotDay6 = 0, TotDay7 = 0, Totbatch = 0;


            setTimeout(function () {

                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                
                

              
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {

                        var pasok1 = false;
                        var count1 = 0;
                        
                        

                        item1 = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "SKUCode"));
                        batch1 = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "BatchWeight"));
                        Day1 = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "Day1"));
                        Day2 = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "Day2"));
                        Day3 = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "Day3"));
                        Day4 = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "Day4"));
                        Day5 = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "Day5"));
                        Day6 = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "Day6"));
                        Day7 = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "Day7"));
             
                        if (Day1 == "" || Day1 == '' || isNaN(Day1) || Day1 == null) {
                            Day1 = 0;
                        }
                        if (Day2 == "" || Day2 == '' || isNaN(Day2) || Day2 == null) {
                            Day2 = 0;
                        }
                        if (Day3 == "" || Day3 == '' || isNaN(Day3) || Day3 == null) {
                            Day3 = 0;
                        }
                        if (Day4 == "" || Day4 == '' || isNaN(Day4) || Day4 == null) {
                            Day4 = 0;
                        }
                        if (Day5 == "" || Day5 == '' || isNaN(Day5) || Day5 == null) {
                            Day5 = 0;
                        }
                        if (Day6 == "" || Day6 == '' || isNaN(Day6) || Day6 == null) {
                            Day6 = 0;
                        }
                        if (Day7 == "" || Day7 == '' || isNaN(Day7) || Day7 == null) {
                            Day7 = 0;
                        }

                        if (batch1 == "" || batch1 == '' || isNaN(batch1) || batch1 == null) {
                            batch1 = 0;
                        }
                   
                        var total = Day1 + Day2 + Day3 + Day4 + Day5 + Day6 + Day7;
                       
                        
                        gv1.batchEditApi.SetCellValue(iMO[h], "TotalKG", total);


                        var TotalB
                        if(batch1==0)
                        {
                            TotalB = 0;
                        }else{
                            TotalB = total / batch1;
                        }
                        var TotalBa = Math.round(TotalB);

                        if (batch1= 0) {
                            gv1.batchEditApi.SetCellValue(iMO[h], "TotalBatch", "0");
                        } else {
                            gv1.batchEditApi.SetCellValue(iMO[h], "TotalBatch", TotalBa == NaN ? 0 : TotalBa);
                        }
                        
                       
                        Batches = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TotalBatch"));
                        if (Batches % 2 == 0)
                        {

                        } else {
                            console.log(TotalBa == NaN ? 0 : TotalBa);
                            gv1.batchEditApi.SetCellValue(iMO[h], "TotalBatch", (TotalBa == NaN ? 0 : TotalBa) + 1);
                            
                            
                        }
                        TotDay1 += Day1;
                        TotDay2 += Day2;
                        TotDay3 += Day3;
                        TotDay4 += Day4;
                        TotDay5 += Day5;
                        TotDay6 += Day6;
                        TotDay7 += Day7;
                        Totbatch += Batches;

                       

                     

                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) {
                        }
                        else {
                            var pasok1 = false;
                            var count1 = 0;

                            item1 = gv1.batchEditApi.GetCellValue(iMO[h], "SKUCode");
                            batch1 = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "BatchWeight"));
                            Day1 = gv1.batchEditApi.GetCellValue(iMO[h], "Day1");
                            Day2 = gv1.batchEditApi.GetCellValue(iMO[h], "Day2");
                            Day3 = gv1.batchEditApi.GetCellValue(iMO[h], "Day3");
                            Day4 = gv1.batchEditApi.GetCellValue(iMO[h], "Day4");
                            Day5 = gv1.batchEditApi.GetCellValue(iMO[h], "Day5");
                            Day6 = gv1.batchEditApi.GetCellValue(iMO[h], "Day6");
                            Day7 = gv1.batchEditApi.GetCellValue(iMO[h], "Day7");
                           
                            if (Day1 == "" || Day1 == '' || isNaN(Day1) || Day1 == null) {
                                Day1 = 0;
                            }
                            if (Day2 == "" || Day2 == '' || isNaN(Day2) || Day2 == null) {
                                Day2 = 0;
                            }
                            if (Day3 == "" || Day3 == '' || isNaN(Day3) || Day3 == null) {
                                Day3 = 0;
                            }
                            if (Day4 == "" || Day4 == '' || isNaN(Day4) || Day4 == null) {
                                Day4 = 0;
                            }
                            if (Day5 == "" || Day5 == '' || isNaN(Day5) || Day5 == null) {
                                Day5 = 0;
                            }
                            if (Day6 == "" || Day6 == '' || isNaN(Day6) || Day6 == null) {
                                Day6 = 0;
                            }
                            if (Day7 == "" || Day7 == '' || isNaN(Day7) || Day7 == null) {
                                Day7 = 0;
                            }
                            var total = Day1 + Day2 + Day3 + Day4 + Day5 + Day6 + Day7
                            gv1.batchEditApi.SetCellValue(iMO[h], "TotalKG", total);

                            var TotalB = total / batch1;
                            var TotalBa = Math.ceil(TotalB);
                            gv1.batchEditApi.SetCellValue(iMO[h], "TotalBatch", TotalBa);
                            

                            Batches = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TotalBatch"));
                            if (Batches % 2 == 0) {

                            } else {

                                gv1.batchEditApi.SetCellValue(iMO[h], "TotalBatch", (TotalBa == NaN ? 0 : TotalBa) + 1);


                            }
                            Batches = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TotalBatch"));

                            TotDay1 += Day1;
                            TotDay2 += Day2;
                            TotDay3 += Day3;
                            TotDay4 += Day4;
                            TotDay5 += Day5;
                            TotDay6 += Day6;
                            TotDay7 += Day7;
                            Totbatch += Batches;
                           
                        }
                    }
                }
                

                document.getElementById("tdTotDay1").innerHTML = formatNumber(TotDay1);
                document.getElementById("tdTotDay2").innerHTML = formatNumber(TotDay2);
                document.getElementById("tdTotDay3").innerHTML = formatNumber(TotDay3);
                document.getElementById("tdTotDay4").innerHTML = formatNumber(TotDay4);
                document.getElementById("tdTotDay5").innerHTML = formatNumber(TotDay5);
                document.getElementById("tdTotDay6").innerHTML = formatNumber(TotDay6);
                document.getElementById("tdTotDay7").innerHTML = formatNumber(TotDay7);
                document.getElementById("tdBatch").innerHTML = formatNumber(Totbatch);
             

            }, 500);
        }

// Auto Calculate KG End 



        function formatNumber(num) {
            return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
        }





        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            
            if (currentColumn.fieldName === "glSKUCode") {
                cellInfo.value = glSKUCode.GetValue();
                cellInfo.text = glSKUCode.GetText();
                console.log('dahil sakin');
            }
            if (currentColumn.fieldName === "PackagingType") {
                cellInfo.value = glPackagingType.GetValue();
                cellInfo.text = glPackagingType.GetText();
                console.log('dahil d');
            }
        }

        function lookup(s, e) {
            if (isSetTextRequired) {//Sets the text during lookup for item code
                s.SetText(s.GetInputElement().value);
                isSetTextRequired = false;
            }
        }

        var val;
        var temp;
        function GridEnd(s, e) {

            val = s.GetGridView().cp_codes;

            if (val != null) {
                temp = val.split(';');
                delete (s.GetGridView().cp_codes);
            }
            else {
                val = "";
                delete (s.GetGridView().cp_codes);
            }

            if (valchange && (val != null && val != 'undefined' && val != '')) {
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, e, column, gv1);
                    gv1.batchEditApi.EndEdit();
                }
            }
        }

        function ProcessCells(selectedIndex, e, column, s) {
            if (val == null) {
                val = ";;";
                temp = val.split(';');
            }

            if (temp[0] == null) {
                temp[0] = "";
            }


            if (selectedIndex == 0) {
                if (column.fieldName == "ProductOrder") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                }
               
            }
        }

        //var preventEndEditOnLostFocus = false;
        function gridLookup_KeyDown(s, e) { //Allows tabbing between gridlookup on details
            isSetTextRequired = false;
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode !== ASPxKey.Tab) return;
            var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
            if (gv1.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            }
        }

        function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode == ASPxKey.Enter)
                gv1.batchEditApi.EndEdit();
            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            gv1.batchEditApi.EndEdit();
        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                //if (column.fieldName == "ATCCode") {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                //    
                //    var cellValidationInfo = e.validationInfo[column.index];
                //    if (!cellValidationInfo) continue;
                //    var value = cellValidationInfo.value;
                //    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                //        cellValidationInfo.isValid = false;
                //        cellValidationInfo.errorText = column.fieldName + " is required";
                //        isValid = false;
                //    }
                //}
                var chckd;

                //else 
                if (column.fieldName == "TransAPAmount") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                }
                if (column.fieldName == "EWT") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (ASPxClientUtils.Trim(value) == true) {
                        chckd = true;
                    }
                }
                if (column.fieldName == "ATCCode") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") && chckd == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                }
            }
        }

        function OnFileUploadComplete(s, e) {//Loads the excel file into the grid
            gv1.PerformCallback();
        }

        function OnCustomClick(s, e) {
            if (e.buttonID == "Details") {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode);
            }
            if (e.buttonID == "ViewTransaction") {

                var transtype = s.batchEditApi.GetCellValue(e.visibleIndex, "TransType");
                var docnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "DocNumber");
                var commandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "CommandString");

                window.open(commandtring + '?entry=V&transtype=' + transtype + '&parameters=&iswithdetail=true&docnumber=' + docnumber, '_blank', "", false);
                console.log('ViewTransaction')
            }
            if (e.buttonID == "ViewReferenceTransaction") {

                var rtranstype = s.batchEditApi.GetCellValue(e.visibleIndex, "RTransType");
                var rdocnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "REFDocNumber");
                var rcommandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "RCommandString");
                window.open(rcommandtring + '?entry=V&transtype=' + rtranstype + '&parameters=&iswithdetail=true&docnumber=' + rdocnumber, '_blank');
                console.log('ViewTransaction')
            }
        }
       
        function CloseGridLookup() {
            glInvoice.ConfirmCurrentSelection();
            glInvoice.HideDropDown();
            //glInvoice.Focus();
        }

        function Clear() {
            glInvoice.SetValue(null);
        }

      
//WorkWeek
        Date.prototype.getWeek = function () {
            var date = new Date(this.getDate());
            date.setHours(0, 0, 0, 0);
            // Thursday in current week decides the year.
            date.setDate(date.getDate() + 3 - (date.getDay() + 6) % 7);
            // January 4 is always in week 1.
            var week1 = new Date(date.getFullYear(), 0, 4);
            // Adjust to Thursday in week 1 and count number of weeks from date to week1.
            return 1 + Math.round(((date.getTime() - week1.getTime()) / 86400000 - 3 + (week1.getDay() + 6) % 7) / 7);
        }

        function getDateRangeOfWeek() {
            
            

            var workweek = txtWorkWeek.GetText()
            var year = glYear.GetText()
            console.log(workweek)
            console.log(year)

            
            var numOfdaysPastSinceLastMonday, Day1, Day2, Day3, Day4, Day5, Day6, Day7;
            d1 = new Date('' + year + '');
            console.log(d1);
            numOfdaysPastSinceLastMonday = d1.getDay() - 1;
            d1.setDate(d1.getDate() - numOfdaysPastSinceLastMonday);
            d1.setDate(d1.getDate() + (7 * (workweek - d1.getWeek())));
            d1.setDate(d1.getDate() + 7); // + 1 week sync date to fg  sku transfer out
            Day1 = (d1.getMonth() + 1) + "-" + d1.getDate();
            d1.setDate(d1.getDate() + 1);
            Day2 = (d1.getMonth() + 1) + "-" + d1.getDate();
            d1.setDate(d1.getDate() + 1);
            Day3 = (d1.getMonth() + 1) + "-" + d1.getDate();
            d1.setDate(d1.getDate() + 1);
            Day4 = (d1.getMonth() + 1) + "-" + d1.getDate();
            d1.setDate(d1.getDate() + 1);
            Day5 = (d1.getMonth() + 1) + "-" + d1.getDate();
            d1.setDate(d1.getDate() + 1);
            Day6 = (d1.getMonth() + 1) + "-" + d1.getDate();
            d1.setDate(d1.getDate() + 1);
            Day7 = (d1.getMonth() + 1) + "-" + d1.getDate();


            if (Day1 == "NaN-NaN") {
                Day1D.SetText('-');
                } else {
                Day1D.SetText(Day1);
            }
            if (Day2 == "NaN-NaN") {
                Day2D.SetText('-');
            } else {
                Day2D.SetText(Day2);
            }
            if (Day3 == "NaN-NaN") {
                Day3D.SetText('-');
            } else {
                Day3D.SetText(Day3);
            }
            if (Day4 == "NaN-NaN") {
                Day4D.SetText('-');
            } else {
                Day4D.SetText(Day4);
            }
            if (Day5 == "NaN-NaN") {
                Day5D.SetText('-');
            } else {
                Day5D.SetText(Day5);
            }
            if (Day6 == "NaN-NaN") {
                Day6D.SetText('-');
            } else {
                Day6D.SetText(Day6);
            }
            if (Day7 == "NaN-NaN") {
                Day7D.SetText('-');
            } else {
                Day7D.SetText(Day7);
            }

            
            return Day1 + Day2 + Day3 + Day4 + Day5 + Day6 + Day7;
          
            
        };





        function autocalculate(s, e) {
            var amount = 0.00;
            var vatrate = 0.00;
            var atcrate = 0.00;
            var totalamount = 0.00;


            setTimeout(function () { //New Rows
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        console.log("new row " + indicies[i]);
                    }
                    else { //Existing Rows
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            amount = gv1.batchEditApi.GetCellValue(indicies[i], "Amount");
                            atcrate = gv1.batchEditApi.GetCellValue(indicies[i], "ATCCode");

                            //console.log(gv1.batchEditApi.GetCellValue(indicies[i], "IsVat"));
                            if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVatable") == true) {
                                vatrate = gv1.batchEditApi.GetCellValue(indicies[i], "vatrate");
                                vatamount += amount * vatrate;
                                grossvatable += amount;
                            }
                            else {
                                grossnonvatable += amount;
                            }

                            if (gv1.batchEditApi.GetCellValue(indicies[i], "IsEWT") == true) {
                                if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVatable") == true) {
                                    atcrate = gv1.batchEditApi.GetCellValue(indicies[i], "atcrate");
                                    whtaxamount += amount * atcrate;
                                }
                            }
                        }
                    }


                }
                totalamountdue = (grossvatable + grossnonvatable + vatamount) - whtaxamount;
                txtvatamount.SetText(vatamount.toFixed(2));
                txtgrossvatable.SetText(grossvatable.toFixed(2));
                txtgrossnonvatable.SetText(grossnonvatable.toFixed(2));
                txtwhvatamount.SetText(whtaxamount.toFixed(2));
                txtamountdue.SetText(totalamountdue.toFixed(2));
            }, 500);
        }

        function OnInitTrans(s, e) {
            AdjustSize();
        }

        function OnControlsInitialized(s, e) {
            ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                AdjustSize();
            });
        }

        function AdjustSize() {
            var width = Math.max(0, document.documentElement.clientWidth);
            var height = Math.max(0, document.documentElement.clientHeight);
            gv1.SetHeight(height);
            gv1.SetWidth(width - 120);
        }
        var uploadInProgress = false,
           submitInitiated = false,
           uploadErrorOccurred = false;
        uploadedFiles = [];
        function onFileUploadComplete(s, e) {
            var callbackData = e.callbackData.split("|"),
                uploadedFileName = callbackData[0],
                isSubmissionExpired = callbackData[1] === "True";
            uploadedFiles.push(uploadedFileName);
            if (e.errorText.length > 0 || !e.isValid)
                uploadErrorOccurred = true;
            if (isSubmissionExpired && UploadedFilesTokenBox.GetText().length > 0) {
                var removedAfterTimeoutFiles = UploadedFilesTokenBox.GetTokenCollection().join("\n");
                alert("The following files have been removed from the server due to the defined 5 minute timeout: \n\n" + removedAfterTimeoutFiles);
                UploadedFilesTokenBox.ClearTokenCollection();
            }
        }
        function onFileUploadStart(s, e) {
            uploadInProgress = true;
            uploadErrorOccurred = false;
            UploadedFilesTokenBox.SetIsValid(true);
        }
        function onFilesUploadComplete(s, e) {
            uploadInProgress = false;
            for (var i = 0; i < uploadedFiles.length; i++)
                UploadedFilesTokenBox.AddToken(uploadedFiles[i]);
            updateTokenBoxVisibility();
            uploadedFiles = [];
            if (submitInitiated) {
                SubmitButton.SetEnabled(true);
                SubmitButton.DoClick();
            }
        }
        function onSubmitButtonInit(s, e) {
            s.SetEnabled(true);
        }
        function onSubmitButtonClick(s, e) {
            ASPxClientEdit.ValidateGroup();
            if (!formIsValid())
                e.processOnServer = false;
            else if (uploadInProgress) {
                s.SetEnabled(false);
                submitInitiated = true;
                e.processOnServer = false;
            }
        }
        function onTokenBoxValidation(s, e) {
            var isValid = DocumentsUploadControl.GetText().length > 0 || UploadedFilesTokenBox.GetText().length > 0;
            e.isValid = isValid;
            if (!isValid) {
                e.errorText = "No files have been uploaded. Upload at least one file.";
            }
        }
        function onTokenBoxValueChanged(s, e) {
            updateTokenBoxVisibility();
        }
        function updateTokenBoxVisibility() {
            var isTokenBoxVisible = UploadedFilesTokenBox.GetTokenCollection().length > 0;
            UploadedFilesTokenBox.SetVisible(isTokenBoxVisible);
        }
        function formIsValid() {
            return !ValidationSummary.IsVisible() && DescriptionTextBox.GetIsValid() && UploadedFilesTokenBox.GetIsValid() && !uploadErrorOccurred;
        }
    </script>
    <!--#endregion-->
</head>
<body style="height: 565px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
<form id="form1" runat="server" class="Entry">
                        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Material Order" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                        <%--    <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="90"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>--%><%--    <h1>AP Voucher</h1>--%>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="850px" Height="565px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">

                    <dx:ASPxFormLayout ID="frmlayout1" runat="server"  Height="565px" Width="850px" style="margin-left: -3px" ClientInstanceName="frmlayout">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <ClientSideEvents Init="formLayout_OnInit" />
                        <Items>
                          <%--<!--#region Region Header --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                                      <dx:LayoutItem Caption="Material Order No." Name="DocNumber" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocnumber" runat="server" Width="170px" ReadOnly="true" DisabledStyle-BackColor="Gray">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date:" Name="DocDate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpdocdate" runat="server"  Width="170px" OnInit="dtpDocDate_Init"  OnLoad="Date_Load">
                                                              <ClientSideEvents Validation="OnValidation"  />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip" >
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Order Date:" Name="DocDate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpOrderDate" runat="server"  Width="170px" OnInit="dtpOrderDate_Init"  OnLoad="Date_Load">
                                                              <ClientSideEvents Validation="OnValidation"  />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip" >
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:LayoutItem Caption="Production Site">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                       <%-- <dx:ASPxTextBox ID="txtCustomerCode" runat="server"  OnLoad="TextboxLoad"  Width="170px">
                                                    
                                             
                                                             </dx:ASPxTextBox>--%>
                                                          <dx:ASPxGridLookup ID="ProductionSite" runat="server" DataSourceID="sdsProductionSite" KeyFieldName="ProductClassCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="true" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



                                            <%--<dx:LayoutItem Caption="Production Site">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="ProductionSite" runat="server"  OnLoad="TextboxLoad"  Width="170px">
                                                    
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
              
                                                     <%--   <dx:LayoutItem Caption="Step" Name="Step" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glStep" runat="server" DataSourceID="sdsStep" KeyFieldName="StepCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <ClientSideEvents Validation="OnValidation"    ValueChanged="function(s,e){ cp.PerformCallback('Step');
                                                                      e.processOnServer = false; }"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="true" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                           

                                              <%-- <dx:LayoutItem Caption="Customer Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtType" runat="server" Text="" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>

                                            <dx:LayoutItem Caption="Customer Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                       <%-- <dx:ASPxTextBox ID="txtCustomerCode" runat="server"  OnLoad="TextboxLoad"  Width="170px">
                                                    
                                             
                                                             </dx:ASPxTextBox>--%>
                                                          <dx:ASPxGridLookup ID="txtCustomerCode" runat="server" DataSourceID="sdsCustomercode" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="true" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                <dx:LayoutItem Caption="Remarks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <%--<dx:ASPxTextBox ID="txtRemarks" runat="server"  OnLoad="TextboxLoad"  Width="300px">
                                                             </dx:ASPxTextBox>--%>
                                                        <dx:ASPxMemo ID="txtRemarks" ClientInstanceName="txtRemarks" runat="server" Height="50px" Width="170px">  
                                                            <%--<ClientSideEvents Init="OnMemoInit" />  --%>
                                                        </dx:ASPxMemo>  


                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="WorkWeek">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtWorkWeek" runat="server" ClientInstanceName="txtWorkWeek"  OnLoad="TextboxLoad"  Width="50px">

                                                            <ClientSideEvents Valuechanged="getDateRangeOfWeek" Validation="OnValidationWW"/>
                                                              <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                                </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                         <dx:LayoutItem Caption="Year:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <%--<dx:ASPxDateEdit runat="server" ID="txtYear" PickerType="Years" />--%>
                                                       <%-- <dx:ASPxTextBox ID="txtYear" runat="server"  OnLoad="TextboxLoad"  Width="50px">
                                                    
                                             
                                                             </dx:ASPxTextBox>--%>
                                                        <dx:ASPxGridLookup ID="glYear" runat="server" Width="70px"  DataSourceID="sdsYear" SelectionMode="Single"  KeyFieldName="Year" OnLoad="LookupLoad" TextFormatString="{0}" ClientInstanceName="glYear">
                                                                      <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"  />
                                                                <Settings ShowFilterRow="True"  />
                                                            </GridViewProperties>
                                                      <ClientSideEvents Valuechanged="getDateRangeOfWeek" />
                                                          <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>    
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="" Width="0px">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="FileName" runat="server"  OnLoad="TextboxLoad"  Width="0px" Border-BorderColor="#ffffff">
                                                    
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="" Width="0px" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="RRemarksText" runat="server"  OnLoad="TextboxLoad"  Width="0px" Border-BorderColor="#ffffff">
                                                    
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="" Width="100px" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="Uploadedpath" runat="server"  OnLoad="TextboxLoad"  Width="0px" Border-BorderColor="#ffffff">
                                                    
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="" Width="0px" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="WWeeks" runat="server"  OnLoad="TextboxLoad"  Width="0px" Border-BorderColor="#ffffff">
                                                    
                                             
                                                             </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                             <dx:LayoutGroup ShowCaption="False" GroupBoxDecoration="None" Width="50%" UseDefaultPaddings="false" >

    <%-- Revision Section--%>
                                             
                <Items>
                   
            
                    <dx:LayoutGroup  Name="Revision" Caption="Revision">
                       
                        <Items>
                            <dx:LayoutItem Caption="Remarks" CaptionSettings-Location="Top">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox runat="server" ID="RRemarks" ClientInstanceName="DescriptionTextBox" NullText="cause of the revision"
                                    Width="500px" EncodeHtml="true">
                                   <ClientSideEvents Valuechanged="remarksLoad" Validation="OnValidationRem" />
                                        <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                        <RequiredField IsRequired="True" />
                                        </ValidationSettings>
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>

                        <CaptionSettings Location="Top"></CaptionSettings>
                    </dx:LayoutItem>
                            <dx:LayoutItem Caption="Proof of approval" >

                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                            <div id="dropZone">
                                               <div class="form-horizontal">
                                                <div class="form-group">
                                                    <div class="col-sm-2 attachImages">
                                                        <asp:Image CssClass="img-thumbnail" ID="picture1Img"  runat="server" Height="50%" Width="50%"
                                                            style="cursor: pointer;" onclick="showImage(this.id)" />
                                                    </div>
                                                    <div class="col-sm-10">
                                                        <div class="form-row">
                                                            <div class="form-holder form-holder-2">
                                                                
                                                                <asp:FileUpload ID="Picture1" runat="server" class="form-control-file attachFiles"
                                                                    accept="image/*" onchange="imageIsLoaded(this)"/>
                                                            </div>
                                                            <input id="btnSave" runat="server" type="button"  onserverclick="UploadFile" style="display:none"/>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            
                            
                        </Items>
                    </dx:LayoutGroup>
                    
                    <dx:EmptyLayoutItem Height="1" />
                </Items>






            </dx:LayoutGroup>
            <dx:LayoutGroup GroupBoxDecoration="None" ShowCaption="False" Name="ResultGroup" Visible="false" Width="50%" UseDefaultPaddings="false">
                <Items>
                    <dx:LayoutItem ShowCaption="False">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxRoundPanel ID="RoundPanel" runat="server" HeaderText="Uploaded files" Width="100%">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <b>Description:</b>
                                            <dx:ASPxLabel runat="server" ID="DescriptionLabel" />
                                            <br />
                                            <br />
                                            <dx:ASPxListBox ID="SubmittedFilesListBox" runat="server" Width="100%" Height="150px">
                                                <ItemStyle CssClass="ResultFileName" />
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="OriginalFileName" />
                                                    <dx:ListBoxColumn FieldName="FileSize" Width="15%"/>
                                                </Columns>
                                            </dx:ASPxListBox>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxRoundPanel>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                </Items>
            </dx:LayoutGroup>





                                        </Items>

                                    </dx:LayoutGroup>
                                    <%--<dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" OnLoad="TextboxLoad" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                           
                                            <dx:LayoutItem Caption="Field2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" OnLoad="TextboxLoad" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                              
                                            <dx:LayoutItem Caption="Field3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" OnLoad="TextboxLoad" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
             
                                            <dx:LayoutItem Caption="Field4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" OnLoad="TextboxLoad" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                             
                                            <dx:LayoutItem Caption="Field5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" OnLoad="TextboxLoad" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                             <dx:LayoutItem Caption="Field6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" OnLoad="TextboxLoad" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                          <dx:LayoutItem Caption="Field7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" OnLoad="TextboxLoad" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                  <dx:LayoutItem Caption="Field8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" OnLoad="TextboxLoad" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>  
                                                           <dx:LayoutItem Caption="Field9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" OnLoad="TextboxLoad" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>--%>

                                     <dx:LayoutGroup Caption="Audit Trail" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Added By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Added Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                <dx:LayoutItem Caption="Submitted By">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                                           <dx:LayoutItem Caption="Submitted Date">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled By">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                                           <dx:LayoutItem Caption="Cancelled Date">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtHCancelledDate" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Revised By">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtHRevisedBy" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                                           <dx:LayoutItem Caption="Revised Date">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtHRevisedDate" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                        
                                        </Items>
                                    </dx:LayoutGroup>


                                       <%--<dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction">
                                                   <Items>
                                    <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="608px"  KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber"  ClientInstanceName="gvRef" >
                                                               <SettingsBehavior AllowSort="false" AllowGroup="false" />    
                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                            <SettingsPager PageSize="5">
                                                            </SettingsPager>
                                                            <SettingsEditing Mode="Batch">      
                                                            </SettingsEditing>
                                                            <ClientSideEvents Init="OnInitTrans" />--%>
                                                            <%--<Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="130" VerticalScrollBarMode="Auto" />--%>
                                                        <%--    <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" Caption="DocNumber" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="RTransType" Caption="Reference TransType" ShowInCustomizationForm="True" VisibleIndex="1" ReadOnly="True"  Name="RTransType">
                                                                  
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewCommandColumn ButtonType="Image"  ShowInCustomizationForm="True" VisibleIndex="0" Width="90px" >            
                                                               <CustomButtons>
                                                                             <dx:GridViewCommandColumnCustomButton ID="ViewReferenceTransaction">
                                                               <Image IconID="functionlibrary_lookupreference_16x16"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                                    <dx:GridViewCommandColumnCustomButton ID="ViewTransaction">
                                                               <Image IconID="find_find_16x16"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                                      
                                                            </CustomButtons>
                                                                       </dx:GridViewCommandColumn>
                                                                <dx:GridViewDataTextColumn FieldName="REFDocNumber" Caption="Reference DocNumber" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="RCommandString" ShowInCustomizationForm="True" VisibleIndex="3" >
                                                            
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="CommandString" ShowInCustomizationForm="True" VisibleIndex="6"  >
                                                                                                                                
                                                                     </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                </Items>
                                    </dx:LayoutGroup>--%>
                                </Items>
                            </dx:TabbedLayoutGroup>
   

                            
 <%-- Material Order--%>
                                     <dx:LayoutGroup Caption=" Details" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem ShowCaption="False">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">

                                  <dx:ASPxLabel runat="server" Text=" Material Order Detail:" Font-Bold="true" ForeColor="Gray"  Font-Size="Medium" ></dx:ASPxLabel>                                       
                    <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="1230px" DataSourceID ="sdsDetail"
                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" 
                             KeyFieldName="DocNumber;LineNumber" OnCustomUnboundColumnData="grid_CustomUnboundColumnData" SettingsEditing-BatchEditSettings-ShowConfirmOnLosingChanges="true">
                                  <SettingsBehavior AllowSort="false" AllowGroup="false" />    
                                        <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm"  BatchEditRowValidating="Grid_BatchEditRowValidating"
                                             BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                        
                                                  <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager PageSize="1000"  Visible="False"/> 
                                                    <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130"  /> 
                                                    <Columns>
                                                           <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                           </dx:GridViewDataTextColumn>
                                                              
                                                                     <dx:GridViewCommandColumn ShowDeleteButton="true"  ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="60px" ShowNewButtonInHeader="true">
                                                                           <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Details0">
                                                                                    <Image IconID="support_info_16x16"></Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                            
                                                                      </dx:GridViewCommandColumn>
                                                       
                                                            <dx:GridViewDataTextColumn Caption="Client Code" FieldName="SKUCode" Name="SKUCode"  ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="16" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                           <EditItemTemplate>
                                                              <dx:ASPxGridLookup ID="glSKUCode" runat="server" DataSourceID="sdsSKUCode" Width="145px" KeyFieldName="SAPCode" 
                                                                        TextFormatString="{0}" AutoGenerateColumns="False" ClientInstanceName="glSKUCode">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SAPCode" Caption="Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ProductName" Caption="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="BatchWeight" Caption="Batch Weight" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                         <dx:GridViewDataTextColumn FieldName="PackagingType" Caption="Packaging Type" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents ValueChanged="function(s,e){ 
                                                                        var g = glSKUCode.GetGridView();
                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'SAPCode;ProductName;BatchWeight;PackagingType', UpdateSKUDescription); 
                                                                    }"/>
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                               </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>

                                                            <dx:GridViewDataTextColumn Caption="Item Description" FieldName="ItemDescription" Name="ItemDescription" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="250px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="BatchWeight" FieldName="BatchWeight" Name="BatchWeight" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="18" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            </dx:GridViewDataTextColumn>

                                                            <dx:GridViewDataTextColumn Caption="Packaging Type" FieldName="PackagingType" Name="PackagingType" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="19" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                           <EditItemTemplate>
                                                              <dx:ASPxGridLookup ID="glPackagingType" runat="server" DataSourceID="sdsPackagingType" Width="145px" KeyFieldName="PackagingTypeCode" 
                                                                        TextFormatString="{0}" AutoGenerateColumns="False" ClientInstanceName="glPackagingType">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="PackagingTypeCode" Caption="Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        
                                                                    </Columns>
                                                                    <ClientSideEvents ValueChanged="function(s,e){ 
                                                                        var g = glPackagingType.GetGridView();
                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'PackagingTypeCode;Description', UpdatePackaging); 
                                                                    }"/>
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                               </EditItemTemplate>
                                                                
                                                                 </dx:GridViewDataTextColumn>

                                                            <dx:GridViewBandColumn Name="Day1D" AllowDragDrop="False" VisibleIndex="19" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="Day1D" ClientInstanceName="Day1D" runat="server" Text="">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="Mon" FieldName="Day1" Name="Day1" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="60px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="eDay1"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}"> 
                                                                                            <ClientSideEvents ValueChanged ="calculate_TotalKG" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>



                                                            <dx:GridViewBandColumn Name="Day2D"  AllowDragDrop="False" VisibleIndex="20" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                <HeaderCaptionTemplate>  
                                                                    <dx:ASPxLabel ID="Day2D" ClientInstanceName="Day2D" runat="server" Text="">  
                                                                    </dx:ASPxLabel>  
                                                                </HeaderCaptionTemplate>   
                                                                        <Columns>
                                                                            <dx:GridViewDataSpinEditColumn Caption="Tue" FieldName="Day2" Name="Day2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21"  Width="60px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                <PropertiesSpinEdit  ClientInstanceName="eDay2" NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}"> 
                                                                                        <ClientSideEvents ValueChanged ="calculate_TotalKG" /> 
                                                                                </PropertiesSpinEdit>  
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                        </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                             </dx:GridViewBandColumn>



                                                             <dx:GridViewBandColumn Name="Day3D"  AllowDragDrop="False" VisibleIndex="21" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                            <dx:ASPxLabel ID="Day3D" ClientInstanceName="Day3D" runat="server" Text="">  
                                                                            </dx:ASPxLabel>  
                                                                   </HeaderCaptionTemplate>  
                                                                        <Columns>
                                                                            <dx:GridViewDataSpinEditColumn Caption="Wed" FieldName="Day3" Name="Day3" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="22" Width="60px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                    <PropertiesSpinEdit  ClientInstanceName="eDay3" NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}"> 
                                                                                            <ClientSideEvents ValueChanged ="calculate_TotalKG" /> 
                                                                                    </PropertiesSpinEdit>  
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                        </Columns><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                             </dx:GridViewBandColumn>



                                                             <dx:GridViewBandColumn  Name="Day4D"  AllowDragDrop="False" VisibleIndex="22" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                            <dx:ASPxLabel ID="Day4D" ClientInstanceName="Day4D" runat="server" Text="">  
                                                                            </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                                        <Columns>
                                                                            <dx:GridViewDataSpinEditColumn Caption="Thu" FieldName="Day4" Name="Day4" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="23" Width="60px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                 <PropertiesSpinEdit  ClientInstanceName="eDay4" NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_TotalKG" /> 
                                                                                 </PropertiesSpinEdit>  
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                    </Columns><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            </dx:GridViewBandColumn>






                                                            <dx:GridViewBandColumn Name="Day5D"  AllowDragDrop="False" VisibleIndex="23" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                            <dx:ASPxLabel ID="Day5D" ClientInstanceName="Day5D" runat="server" Text="">  
                                                                            </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                                        <Columns>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Fri" FieldName="Day5" Name="Day5" ShowInCustomizationForm="True"  UnboundType="String" VisibleIndex="24" Width="60px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                            <PropertiesSpinEdit  ClientInstanceName="eDay5" NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}"> 
                                                                            <ClientSideEvents ValueChanged ="calculate_TotalKG" /> 
                                                                            </PropertiesSpinEdit>  
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                </Columns><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                             </dx:GridViewBandColumn>






                                                                <dx:GridViewBandColumn Name="Day6D"  AllowDragDrop="False" VisibleIndex="25" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                            <HeaderCaptionTemplate>  
                                                            <dx:ASPxLabel ID="Day6D" ClientInstanceName="Day6D" runat="server" Text="">  
                                                            </dx:ASPxLabel>  
                                                        </HeaderCaptionTemplate>  
                                                                        <Columns>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Sat" FieldName="Day6" Name="Day6" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="26" Width="60px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                    <PropertiesSpinEdit  ClientInstanceName="eDay6" NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}"> 
                                                                    <ClientSideEvents ValueChanged ="calculate_TotalKG" /> 
                                                                    </PropertiesSpinEdit>  
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                </Columns><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>






                                                                <dx:GridViewBandColumn Name="Day7D"  AllowDragDrop="False"  VisibleIndex="27" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                            <HeaderCaptionTemplate>  
                                                            <dx:ASPxLabel ID="Day7D" ClientInstanceName="Day7D" runat="server" Text="">  
                                                            </dx:ASPxLabel>  
                                                        </HeaderCaptionTemplate>  
                                                                        <Columns>
                                                                    <dx:GridViewDataSpinEditColumn Caption="Sun" FieldName="Day7" Name="Day7" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="28" Width="60px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                    <PropertiesSpinEdit  ClientInstanceName="eDay7" NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}"> 
                                                                    <ClientSideEvents ValueChanged ="calculate_TotalKG" /> 
                                                                    </PropertiesSpinEdit>  
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                </Columns><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Total KG" FieldName="TotalKG" Name="TotalKG" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="30" Width="100px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" ReadOnly="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                              <PropertiesTextEdit DisplayFormatString="{0:N2}">
                                                                              </PropertiesTextEdit>
                                                                             </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="Total Batch Weight" FieldName="TotalBatch" Name="TotalBatch" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="31" Width="100px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" ReadOnly="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                    <PropertiesTextEdit ClientInstanceName="eBatch" NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}">
                                                                    <ClientSideEvents ValueChanged ="calculate_TotalKG" /> 
                                                                    </PropertiesTextEdit>

                                                                    </dx:GridViewDataTextColumn>
                                                        
                                                              
                                                              
                                                            </Columns>

                                                                 <%--   <FormatConditions>
                                                                          
                                                                          <dx:GridViewFormatConditionHighlight FieldName="TotalBatch" Expression="[TotalBatch] %2 = 0" Format="GreenFillWithDarkGreenText" />
                                                                         
                                                                     </FormatConditions>--%>
                                                              <Settings ShowFooter="false" />
                                                                    <TotalSummary>
                                                                        <dx:ASPxSummaryItem FieldName="Day1" SummaryType="Sum" />
                                                                        <dx:ASPxSummaryItem FieldName="Day2" SummaryType="Sum" />
                                                                        <dx:ASPxSummaryItem FieldName="Day3" SummaryType="Sum" />
                                                                       
                                                                    </TotalSummary>
              </dx:ASPxGridView>

                                                       

<%-- Total Qty Per date  --%>
                                                        <table id="TotDate" class="TotDate" 
                                                            style="
                                                            border:solid; 
                                                            border-width:thin; 
                                                            border-color:rgba(128, 128, 128, 0.54);
                                                            margin-bottom:50px;">
                                                            
                                                         
                                                                <tr>
                                                                    
                                                                
                                                            
                                                                <td style="border-right:solid;  border-width:thin; border-color:rgba(128, 128, 128, 0.54); padding-left:505px; padding-right:5px; font-weight: bold;" >Total Qty Per Date</td>
                                                                <td id="tdTotDay1" class="totalday"></td>
                                                                <td id="tdTotDay2" class="totalday"></td>                                                                                                                          
                                                                <td id="tdTotDay3" class="totalday"></td>                                                                                                                           
                                                                <td id="tdTotDay4" class="totalday"></td>                                                            
                                                                <td id="tdTotDay5" class="totalday"></td>                                                               
                                                                <td id="tdTotDay6" class="totalday"></td>
                                                                <td id="tdTotDay7" class="totalday"></td>
                                                                <td id="tdTotBatch" class="totalday" style="width:85px; font-weight: bold; border-color:rgba(128, 128, 128, 0.54);">Total Batches</td>
                                                                <td id="tdBatch" class="totalday" style="width:85px;"></td>
                                                                
                                                            </tr>

                                                       </table>
                                                       

                                                          
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                                 </dx:LayoutItem>

                                             </Items>
                                    </dx:LayoutGroup>
 <%-- Material Order End --%>

                         
                            <dx:LayoutItem ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gv2" runat="server" ClientInstanceName="gv2" AutoGenerateColumns="true">
                                                                    <SettingsEditing Mode="Batch" BatchEditSettings-ShowConfirmOnLosingChanges="false" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                        </Items>
                       
                    </dx:ASPxFormLayout>



<dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                                <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
                                    UseSubmitBehavior="false" CausesValidation="true">
                                    <ClientSideEvents Click="OnUpdateClick" />
                                </dx:ASPxButton>
                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
       <dx:ASPxPopupControl ID="DeleteControl" runat="server" Width="250px" Height="100px" HeaderText="Warning!"
        CloseAction="CloseButton" CloseOnEscape="True" Modal="True" ClientInstanceName="DeleteControl"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Are you sure you want to delete this specific document?" />
                    <table>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                           <td><dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                             <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                             </dx:ASPxButton>
                         <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                             <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                             </dx:ASPxButton> 
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        
</form>
    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
        <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.MaterialOrder+MaterialOrderDetail" SelectMethod="getdetail" UpdateMethod="UpdateMaterialOrderDetail" TypeName="Entity.MaterialOrder+MaterialOrderDetail" DeleteMethod="DeleteMaterialOrderDetail" InsertMethod="AddMaterialOrderDetail">
              <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Production.MaterialOrderDetail where DocNumber is null"   OnInit = "Connection_Init">
    </asp:SqlDataSource>

<asp:SqlDataSource ID="sdsYear" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="
select (YEAR(GETDATE()))+number AS Year from master.dbo.spt_values where Type='P' and number <=9"   OnInit = "Connection_Init">
    </asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsJobOrder" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="
SELECT DISTINCT A.DocNumber,StepCode,C.ItemCode as ProductCode FROM Production.JobOrder A 
INNER JOIN Production.JOStepPlanning B 
ON A.DocNumber = B.DocNumber
INNER JOIN Production.JOProductOrder C 
ON A.DocNumber = C.DocNumber
 WHERE  ISNULL(AllocSubmittedBy,'')!='' and Status  IN ('N','W')
 and  ISNULL(AllocSubmittedDate,'')!='' and ISNULL(PreProd,0)='1'"   OnInit = "Connection_Init">
    </asp:SqlDataSource>
            <asp:SqlDataSource ID="sdsStep" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="
   select StepCode,Description,Mnemonics,EstimatedWOPrice,MinimumWOPrice,OveDateTimerheadCode from masterfile.step where IsPreProductionStep='1'"   OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsProductionSite" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="
  select ProductClassCode,Description from MasterFile.ProductClass "   OnInit = "Connection_Init">
    </asp:SqlDataSource>

     <asp:SqlDataSource ID="sdsCustomercode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="
   select BizPartnerCode,Name,DeliveryAddress,SalesManCode from Masterfile.BPCustomerInfo"   OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSKUCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="
   
SELECT SAPCode, ProductName,YieldedBatchWeight AS BatchWeight,PackagingType FROM Masterfile.FGSKU WHERE ISNULL(IsInactive,0)=0 and ProductCategory = 'FG' "   OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsPackagingType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="
   
select PackagingTypeCode, Description from Masterfile.PackagingType WHERE ISNULL(IsInactive,'')=''"   OnInit = "Connection_Init">
    </asp:SqlDataSource>
    



                <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.MaterialOrder+RefTransaction" >
        <SelectParameters>
             <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

   


</body>
</html>


