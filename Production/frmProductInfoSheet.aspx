<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmProductInfoSheet.aspx.cs" Inherits="GWL.frmProductInfoSheet" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
<title></title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="../js/Fraction.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>  
     <!--#region Region Javascript-->
    

        <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
       
            #form1 {
            height: 580px; /*Change this whenever needed*/
            }

            .itemimage > div,
            .itemimage > img
            {
                position: absolute;
            }
            .itemimage
            {
                height: 40px;
                width: 80px;
                position: relative;
                border: 2px dashed #808080!important;
                border-radius: 10px;
                cursor: pointer;
            }
            .dragZoneTextItemImage
            {
                height: 50px;
                width: 100px;
                display: table-cell;
                vertical-align: middle;
                text-align: center;
                font-size: 20pt;
            }
            
            .embroiderprint > div,
            .embroiderprint > img
            {
                position: absolute;
            }
            .embroiderprint
            {
                height: 150px;
                width: 200px;
                position: relative;
                border: 2px dashed #808080!important;
                border-radius: 10px;
                cursor: pointer;
            }
            .dragZoneTextEmbroiderPrint
            {
                width: 200px;
                height: 150px;
                display: table-cell;
                vertical-align: middle;
                text-align: center;
                font-size: 20pt;
            }
            .dropZoneTextEmbroiderPrint
            {
                width: 200px;
                height: 150px;
                color: #d5d2cc;
                background-color: #2A88AD;
                border-radius: 10px;
            }
            .dropZoneTextEmbroiderPrint,
            .dragZoneTextEmbroiderPrint
            {
                display: table-cell;
                vertical-align: middle;
                text-align: center;
                font-size: 20pt;
            }

            .luisgeneledpao /*cell class*/
        {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
             
            
            .ImageRadius
            {
                border-radius: 10px;
            }
            .dropZoneExternal > div,
            .dropZoneExternal > img
            {
                position: absolute;
            }
            .dropZoneExternal
            {
                position: relative;
                border: 2px dashed #808080!important;
                cursor: pointer;
                border-radius: 10px;
                margin-top: 1px;
                margin-bottom: 1px;
                background-color: #fafafa;
            }
            .dropZoneExternal,
            .dragZoneText
            {
                width: 240px;
                height: 360px;
            }
            .dropZoneText
            {
                width: 240px;
                height: 360px;
                color: #d5d2cc;
                background-color: #2A88AD;
                border-radius: 10px;
            }
            .uploadControlDropZone,
            .hidden
            {
                display: none;
            }
            .dropZoneText,
            .dragZoneText
            {
                display: table-cell;
                vertical-align: middle;
                text-align: center;
                font-size: 20pt;
            }
            .dragZoneText
            {
                color: #d5d2cc;
            }
            .dxucInlineDropZoneSys span
            {
                color: #fff!important;
                font-size: 10pt;
                font-weight: normal!important;
            }
            .uploadControlProgressBar
            {
                width: 250px!important;
            }
            .validationMessage
            {
                padding: 0 20px;
                text-align: center;
            }
            .uploadControl
            {
             
            }
            .Note
            {
                width: 500px;
            }

            .roundedPopup
             {
                border-radius: 10px;
                box-shadow: 0 0 0 1px rgba(255,255,255,0.25), 0 8px 16px 0px rgba(0,0,0,0.35);
            }
            
    .BrowseButton
        {
            border-radius: 100px;
            text-align: center;
        }

.Entry {
/*width: 806px; /*Change this whenever needed*/
/*padding: 30px;
margin: 40px auto;
background: #FFF;
border-radius: 10px;
-webkit-border-radius: 10px;
-moz-border-radius: 10px;
box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
-moz-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
-webkit-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);*/

 padding: 20px;
 margin: 10px auto;
 background: #FFF;
}

        .pnl-content
        {
            text-align: right;
        }

        .txtboxInLine {

        float: left;

        }
    </style>
   <script>
       var isValid = true;
       var counterror = 0;
       var bitbycode = false;
       var sizeschecker = 0;
       var measurementcharterrorcounter = 0;

       function getParameterByName(name) {
           name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
           var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
               results = regex.exec(location.search);
           return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
       }
       function FrontImageUploadComplete(s, e) {
           if (e.isValid)


               CINFrontImage.SetImageProperties(e.callbackData, e.callbackData, '', '');

           var imagebinary = e.callbackData.replace('data:image/jpg;base64,', '');
           CINFrontImage64string.SetText(imagebinary);
           //UploadControl.SetText(e.callbackData);
           //UploadControl.
           //setElementVisible("uploadedImage", e.isValid);
       }

       function BackImageUploadComplete(s, e) {
           if (e.isValid)
               // CINBackImage.SetImageUrl(e.callbackData);
               CINBackImage.SetImageProperties(e.callbackData, e.callbackData, '', '');
           var imagebinary = e.callbackData.replace('data:image/jpg;base64,', '');
           CINBackImage64string.SetText(imagebinary);
       }

       function UC2DFrontImageUploadComplete(s, e) {
           if (e.isValid)
               //CINFrontImage2D.SetImageUrl(e.callbackData);
               CINFrontImage2D.SetImageProperties(e.callbackData, e.callbackData, '', '');
           var imagebinary = e.callbackData.replace('data:image/jpg;base64,', '');
           CIN2DFrontImage64string.SetText(imagebinary);
       }

       function UC2DBackImageUploadComplete(s, e) {
           if (e.isValid)
               CINBackImage2D.SetImageProperties(e.callbackData, e.callbackData, '', '');
           //CINBackImage2D.SetImageUrl(e.callbackData);

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

       function UploadImagePrintComplete(s, e) {
           if (e.isValid)
               //CINPrintImage.SetImageUrl(e.callbackData);
               CINPrintImage.SetImageProperties(e.callbackData, e.callbackData, '', '');


           var imagebinary = e.callbackData.replace('data:image/jpg;base64,', '');
           CINgvPrintDetail.batchEditApi.SetCellValue(index, "PicturePrint", imagebinary);

           //image1.SetImageProperties(e.callbackData, e.callbackData, '', '');



           cp.HideLoadingPanel();
       }

       function UploadOtherImageComplete(s, e) {
           if (e.isValid)
               //  CINOtherPicturePicture.SetImageUrl(e.callbackData);
               CINOtherPicturePicture.SetImageProperties(e.callbackData, e.callbackData, '', '');

           var imagebinary = e.callbackData.replace('data:image/jpg;base64,', '');
           CINgvOtherPictures.batchEditApi.SetCellValue(index, "OtherPicture", imagebinary);

           cp.HideLoadingPanel();
       }

       function onImageLoad() {
           var externalDropZone = document.getElementById("externalDropZone");
           var uploadedImage = document.getElementById("uploadedImage");
           uploadedImage.style.left = (externalDropZone.clientWidth - uploadedImage.width) / 2 + "px";
           uploadedImage.style.top = (externalDropZone.clientHeight - uploadedImage.height) / 2 + "px";
           setElementVisible("dragZone", false);
       }

       function setElementVisible(elementId, visible) {
           document.getElementById(elementId).className = visible ? "" : "hidden";
       }
       //(function (global) {
       //    var imagesPerRow = 3,
       //        chooseFiles,
       //        columns,
       //        previews;

       //    function PreviewImages() {
       //        var row;

       //        Array.prototype.forEach.call(chooseFiles.files, function (file, index) {
       //            var cindex = index % imageonstsPerRow,
       //                oFReader = new FileReader(),
       //                cell,
       //                image;

       //            if (cindex === 0) {
       //                row = previews.insertRow(Math.ceil(index / imagesPerRow));
       //            }

       //            image = document.createElement("img");
       //            image.id = "img_" + index;
       //            image.style.width = "100%";
       //            image.style.height = "auto";
       //            cell = row.insertCell(cindex);
       //            cell.appendChild(image);

       //            oFReader.addEventListener("load", function assignImageSrc(evt) {
       //                image.src = evt.target.result;
       //                this.removeEventListener("load", assignImageSrc);
       //            }, false);

       //            oFReader.readAsDataURL(file);
       //        });
       //    }

       //    global.addEventListener("load", function windowLoadHandler() {
       //        global.removeEventListener("load", windowLoadHandler);
       //        chooseFiles = document.getElementById("chooseFiles");
       //        columns = document.getElementById("columns");
       //        previews = document.getElementById("previews");

       //        var row = columns.insertRow(-1),
       //            header,
       //            i;

       //        for (i = 0; i < imagesPerRow; i += 1) {
       //            header = row.insertCell(-1);
       //            header.style.width = (100 / imagesPerRow) + "%";
       //        }

       //        chooseFiles.addEventListener("change", PreviewImages, false);
       //    }, false);
       //}(window));

       //function onImageLoad(s, e) {
       //    var externalDropZone = document.getElementById("externalDropZone");
       //    var uploadedImage = document.getElementById("uploadedImage");
       //    uploadedImage.style.left = (externalDropZone.clientWidth - uploadedImage.width) / 2 + "px";
       //    uploadedImage.style.top = (externalDropZone.clientHeight - uploadedImage.height) / 2 + "px";
       //    setElementVisible("dragZone", false);
       //}
       //function setElementVisible(elementId, visible) {
       //    document.getElementById(elementId).className = visible ? "" : "hidden";
       //}

       function getParameterByName(name) {
           name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
           var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
               results = regex.exec(location.search);
           return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
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
        var cntmc = 0;
       function OnUpdateClick(s, e) { //Add/Edit/Close button function
           var btnmode = btn.GetText(); //gets text of button


           cnterr = 0;

           var indicies = CINSizeDetail1.batchEditApi.GetRowVisibleIndices();
           for (var i = 0; i < indicies.length; i++) {
               if (CINSizeDetail1.batchEditApi.IsNewRow(indicies[i])) {
                   CINSizeDetail1.batchEditApi.ValidateRow(indicies[i]);
               }
               else {
                   var key = CINSizeDetail1.GetRowKey(indicies[i]);
                   if (CINSizeDetail1.batchEditApi.IsDeletedRow(key))
                       console.log("deleted row " + indicies[i]);
                   else {
                       CINSizeDetail1.batchEditApi.ValidateRow(indicies[i]);
                   }
               }
           }


           if (btnmode == "Delete") {
               cp.PerformCallback("Delete");
           }

           var indicies = CINSizeDetail1.batchEditApi.GetRowVisibleIndices();
           for (var i = 0; i < indicies.length; i++) {
               if (CINSizeDetail1.batchEditApi.IsNewRow(indicies[i])) {
                   CINSizeDetail1.batchEditApi.ValidateRow(indicies[i]);
                   //gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("Qty").index);
               }
               else {
                   var key = CINSizeDetail1.GetRowKey(indicies[i]);
                   if (CINSizeDetail1.batchEditApi.IsDeletedRow(key))
                       console.log("deleted row " + indicies[i]);
                   else {
                       CINSizeDetail1.batchEditApi.ValidateRow(indicies[i]);
                       // gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("Qty").index);
                   }
               }
           }
       
           MeasurementChartChecker();
            
        
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
               if (!isValid && counterror > 0) {
                   counterror = 0;
                   alert('Please check all the fields!');
               }
               else {
                   if (sizeschecker > 0) {
                       sizeschecker = 0;
                       CINErrorConfirm.Show();
                       setElementVisible('SizeError', true);
                   }
               }
               //alert('Please check all the fields!');
           }
       }

       function MeasurementChartChecker(s, e) {
           if (!CINFitCode.GetValue()) {
               sizeschecker += 1;
               isValid = false;
           }
       }


       function OnConfirm(s, e) {//function upon saving entry
           console.log(e)
           if (e.requestTriggerID === "cp" || e.requestTriggerID === undefined)//disables confirmation message upon saving.
               e.cancel = true;
       }


       var initgv = 'true';
       //var vatrate = 0;
       var url = "";
       function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
           if (s.cp_success) {
               alert(s.cp_message);
               delete (s.cp_success);//deletes cache variables' data
               delete (s.cp_message);
               //gv1.CancelEdit();
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
                   window.location.reload();
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
           //console.log(cp_image)
           //if (s.cp_image) {
           //    console.log(s.cp_image + ' haha')
           //    imageLuis.SetImageUrl(s.cp_image);
           //    delete (s.cp_image);
           //}

           if (s.cp_forceclose) {//NEWADD
               delete (s.cp_forceclose);
               window.close();
           }


           if (s.cp_colorerror) {
               alert(s.cp_colorerror);
               delete (s.cp_colorerror);
           }

           if (s.cp_bitbycode) {
               delete (s.cp_bitbycode);
               bitbycode = true;
           }

           if (s.cp_UpdatePISNumber) {
               delete (s.cp_UpdatePISNumber);
               UpdatePISNumber();
           }

           loader.Hide();
       }
       var counterhandler = 0;

       var TabCallback;
       var RowClickCallback;
       var NoCallback;
       var NotDropDown;
       var ColumnName;
       var index;
       var closing;
       var valchange;
       var embro;
       var printcode;
       var inkcode;
       var fitcolorcode;
       var pomcode;
       var itemcategorycodestyle
       var productcategorycodestyle
       var itemc; //variable required for lookup
       var prodcat;
       var currentColumn = null;
       var valchange_EMBROCODE = false;
       var gridendchecker = false;
       var isSetTextRequired = false;
       var linecount = 1;
       var VATCode = "";
       var foclum;

       var stocksizeload, componentload, customerload, fabricsupplierload, fabriccodeload, fitcodeload, washcodeload, tintcolorload, embroidersupplierload, printsupplierload, washsupplierload;  //Header Variables
       var threadcolorload, embrocodeload, printcodeload, printinkload, pomcodeload;
       var stepcodeload, supplierload, itemcategorystyleload, productcategorystyleload, itemcodestyleload;
       var workcenterstepload;
       var colorcodeload, classcodeload, sizecodeload, unitcodeload;
       var stepcodesteps;
       var luisgenel = false;
       var SetNull = false;
       var bomvaluechanged = false;
       var dropdown = false;
       var Next = false;


       var pomcodeNew;
       var POMfocusindex;
       var Codefocusindex;


       var canceledit = false;
       function OnStartEditing(s, e) {//On start edit grid function
           foclum = e.focusedColumn.fieldName;
           currentColumn = e.focusedColumn;
           var cellInfo = e.rowValues[e.focusedColumn.index];

           if (s.batchEditApi.GetCellValue(e.visibleIndex, "Grade") === null || s.batchEditApi.GetCellValue(e.visibleIndex, "Grade") === "") {
               s.batchEditApi.SetCellValue(e.visibleIndex, "Grade", "0")
           }
           if (s.batchEditApi.GetCellValue(e.visibleIndex, "Bracket") === null || s.batchEditApi.GetCellValue(e.visibleIndex, "Bracket") === "") {
               s.batchEditApi.SetCellValue(e.visibleIndex, "Bracket", 1)
           }

           prodcat = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
           itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
           embro = s.batchEditApi.GetCellValue(e.visibleIndex, "EmbroCode");
           printcode = s.batchEditApi.GetCellValue(e.visibleIndex, "PrintCode");
           inkcode = s.batchEditApi.GetCellValue(e.visibleIndex, "InkCode");
           fitcolorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ThreadColor");
           pomcode = s.batchEditApi.GetCellValue(e.visibleIndex, "Code");
           stepcodeload = s.batchEditApi.GetCellValue(e.visibleIndex, "StepCodeStyle");
           supplierload = s.batchEditApi.GetCellValue(e.visibleIndex, "SupplierCodeStyle");
           itemcategorycodestyle = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCategoryCodeStyle");
           productcategorycodestyle = s.batchEditApi.GetCellValue(e.visibleIndex, "ProductCategoryCodeStyle");
           suppliercodesteps = s.batchEditApi.GetCellValue(e.visibleIndex, "SupplierSteps");
           componentload = s.batchEditApi.GetCellValue(e.visibleIndex, "ComponentStyle");
           stocksizeload = s.batchEditApi.GetCellValue(e.visibleIndex, "StockSize");
           colorcodeload = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCodeStyle");
           classcodeload = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCodeStyle");
           sizecodeload = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCodeStyle");
           unitcodeload = s.batchEditApi.GetCellValue(e.visibleIndex, "UnitStyle");
           stepcodesteps = s.batchEditApi.GetCellValue(e.visibleIndex, "StepCodeSteps");


           pomcode = s.batchEditApi.GetCellValue(e.visibleIndex, "POMCode");
           base = CINBaseSize.GetText();
           if (base != null && base != undefined && base != "") {
               POMfocusindex = CINSizeDetail1.GetColumnByField(base).index;
           }


           index = e.visibleIndex;

           if (luisgenel) {
               e.cancel = true;
           }

           if (canceledit) {
               e.cancel = true;
           }

           if (s.batchEditApi.GetCellValue(e.visibleIndex, "Bracket") === null || s.batchEditApi.GetCellValue(e.visibleIndex, "Bracket") === "" || s.batchEditApi.GetCellValue(e.visibleIndex, "Bracket") === 0) {
               s.batchEditApi.SetCellValue(e.visibleIndex, "Bracket", 1)
           }

           if (!bitbycode) {
               if (s.batchEditApi.GetCellValue(e.visibleIndex, "BySize") === null) {
                   s.batchEditApi.SetCellValue(e.visibleIndex, "BySize", false)
               }
           }
           else {
               if (s.batchEditApi.GetCellValue(e.visibleIndex, "BySize") === null) {
                   s.batchEditApi.SetCellValue(e.visibleIndex, "BySize", 0)
               }
           }

           if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsMajor") === null) {
               s.batchEditApi.SetCellValue(e.visibleIndex, "IsMajor", false)
           }

           if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsBlowUp") === null) {
               s.batchEditApi.SetCellValue(e.visibleIndex, "IsBlowUp", false)
           }

           if (e.focusedColumn.fieldName === "Code") {
               CINPOMCode.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "POMCode") {
               CINGBPOMCode.GetInputElement().value = cellInfo.value;
           }

           var entry = getParameterByName('entry');

           if (entry == "V") {
               e.cancel = true; //this will made the gridview readonly

               // EMBRO DETAIL
               if (e.focusedColumn.fieldName === "EmbroPart"
                   || e.focusedColumn.fieldName === "EmbroCode"
                   || e.focusedColumn.fieldName === "EmbroDescription"
                   || e.focusedColumn.fieldName === "Height"
                   || e.focusedColumn.fieldName === "Width"
                   || e.focusedColumn.fieldName === "UploadEmbroider"
                   || e.focusedColumn.fieldName === "PictureEmbroider") {

                   var imagebinary = CINgvEmbroiderDetail.batchEditApi.GetCellValue(e.visibleIndex, "PictureEmbroider")

                   CINEmbroiderImage.SetImageProperties('data:image/jpg;base64,' + imagebinary, 'data:image/jpg;base64,' + imagebinary, '', '');

               }
               // END OF EMBROIDERY DETAIL

               // PRINT DETAIL
               if (e.focusedColumn.fieldName === "PrintPart"
                   || e.focusedColumn.fieldName === "PrintCode"
                   || e.focusedColumn.fieldName === "PrintDescription"
                   || e.focusedColumn.fieldName === "PrintInk"
                   || e.focusedColumn.fieldName === "InkDescription"
                   || e.focusedColumn.fieldName === "PicturePrint"
                   || e.focusedColumn.fieldName === "UploadPrint") {

                   var imagebinary = CINgvPrintDetail.batchEditApi.GetCellValue(e.visibleIndex, "PicturePrint")
                   CINPrintImage.SetImageProperties('data:image/jpg;base64,' + imagebinary, 'data:image/jpg;base64,' + imagebinary, '', '');

               }
               // END OF PRINT DETAIL

               // OTHER PICTURES DETAIL
               if (e.focusedColumn.fieldName === "ImageFileName"
                   || e.focusedColumn.fieldName === "OtherPicture"
                   || e.focusedColumn.fieldName === "OtherPictureUpload") {

                   var imagebinary = CINgvOtherPictures.batchEditApi.GetCellValue(e.visibleIndex, "OtherPicture")
                   CINOtherPicturePicture.SetImageProperties('data:image/jpg;base64,' + imagebinary, 'data:image/jpg;base64,' + imagebinary, '', '');
               }
               // END OF OTHER PICTURES DETAIL
           }
           if (entry != "V") {

               // -- FIT DETAIL -- //
               if (e.focusedColumn.fieldName === "Stitch") {
                   CINStitch.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "ThreadColor") {
                   CINThreadColor.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "Ticket") {
                   CINTicket.GetInputElement().value = cellInfo.value;
               }

               if (e.focusedColumn.fieldName === "R"
                   || e.focusedColumn.fieldName === "G"
                   || e.focusedColumn.fieldName === "B") {
                   e.cancel = true
               }
               //s.batchEditApi.SetCellValue(e.visibleIndex, "Ticket", "TK-" + s.batchEditApi.GetCellValue(e.visibleIndex, "Ticket"))
               // -- END OF FIT DETAIL -- //


               // -- EMBROIDER DETAIL -- //
               if (e.focusedColumn.fieldName === "EmbroCode") {
                   CINEmbroiderCode.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "EmbroDescription"
                   || e.focusedColumn.fieldName === "Height"
                   || e.focusedColumn.fieldName === "Width"
                   || e.focusedColumn.fieldName === "UploadEmbroider"
                   || e.focusedColumn.fieldName === "PictureEmbroider") {
                   e.cancel = true;
               }
               if (e.focusedColumn.fieldName === "EmbroPart"
                   || e.focusedColumn.fieldName === "EmbroCode"
                   || e.focusedColumn.fieldName === "EmbroDescription"
                   || e.focusedColumn.fieldName === "Height"
                   || e.focusedColumn.fieldName === "Width"
                   || e.focusedColumn.fieldName === "UploadEmbroider"
                   || e.focusedColumn.fieldName === "PictureEmbroider") {

                   var imagebinary = CINgvEmbroiderDetail.batchEditApi.GetCellValue(e.visibleIndex, "PictureEmbroider")
                   if (imagebinary != null)
                   {
                       CINEmbroiderImage.SetImageProperties('data:image/jpg;base64,' + imagebinary, 'data:image/jpg;base64,' + imagebinary, '', '');
                   }
               }
               //if (e.focusedColumn.fieldName === "UploadEmbroider") {
               ////    console.log(cellInfo.value);
               ////    console.log(e.visibleIndex)
               ////    console.log(CINEmbroiderPicture.GetInputElement())
               ////    s.batchEditApi.SetCellValue(e.visibleIndex, "UploadEmbroiderPicture", null);
               ////    //CINEmbroiderPicture.value = cellInfo.value;
               //    e.cancel = true;
               //} 
               //if (e.focusedColumn.fieldName === "PictureEmbroider") {
               //    e.cancel = true;
               //}
               // -- END OF EMBROIDER DETAIL -- //
               // -- PRINT DETAIL -- //
               if (e.focusedColumn.fieldName === "PrintCode") {
                   CINPrintCode.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "PrintInk") {
                   CINPrintInk.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "PrintDescription"
                   || e.focusedColumn.fieldName === "InkDescription"
                   || e.focusedColumn.fieldName === "PicturePrint"
                   || e.focusedColumn.fieldName === "UploadPrint") {
                   e.cancel = true;
               }

               if (e.focusedColumn.fieldName === "PrintPart"
                   || e.focusedColumn.fieldName === "PrintCode"
                   || e.focusedColumn.fieldName === "PrintDescription"
                   || e.focusedColumn.fieldName === "PrintInk"
                   || e.focusedColumn.fieldName === "InkDescription"
                   || e.focusedColumn.fieldName === "PicturePrint"
                   || e.focusedColumn.fieldName === "UploadPrint") {

                   var imagebinary = CINgvPrintDetail.batchEditApi.GetCellValue(e.visibleIndex, "PicturePrint")
                   if (imagebinary != null) {
                       CINPrintImage.SetImageProperties('data:image/jpg;base64,' + imagebinary, 'data:image/jpg;base64,' + imagebinary, '', '');
                   }
               }
               // -- END OF PRINT DETAIL -- //
               // -- STEP DETAIL -- //
               if (e.focusedColumn.fieldName === "StepCodeSteps") {
                   //if (cellInfo.value === null && CINStepCodeSteps.GetValue() != null) {
                   //    CINStepCodeSteps.SetValue(null);
                   //    SetNull = true;
                   //    loader.Show();
                   //}
                   //else {
                   //    CINStepCodeSteps.GetInputElement().value = cellInfo.value;
                   //}
                   //Next = false;

                   CINStepCodeSteps.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "SupplierSteps") {
                   //if (cellInfo.value === null && CINSupplierCodeSteps.GetValue() != null) {
                   //    CINSupplierCodeSteps.SetValue(null);
                   //    SetNull = true;
                   //    loader.Show();
                   //}
                   //else {
                   //    CINSupplierCodeSteps.GetInputElement().value = cellInfo.value;
                   //}
                   //Next = false;
                   CINSupplierCodeSteps.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "WorkCenterName") {
                   e.cancel = true;
               }
               // -- END OF STEP DETAIL -- //


               // -- STYLE DETAIL -- //
               if (e.focusedColumn.fieldName === "StepCodeStyle") {
                   //if (cellInfo.value === null && CINStepCodestyle.GetValue() != null)
                   //{
                   //    CINStepCodestyle.SetValue(null);
                   //    SetNull = true; 
                   //    loader.Show();
                   //}
                   //else
                   //{
                   //    CINStepCodestyle.GetInputElement().value = cellInfo.value;
                   //}
                   //Next = false;
                   CINStepCodestyle.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "ItemCategoryCodeStyle") {
                   //if (cellInfo.value === null && CINItemCategoryCodestyle.GetValue() != null) {
                   //    CINItemCategoryCodestyle.SetValue(null);
                   //    SetNull = true;
                   //    loader.Show();
                   //}
                   //else {
                   //    CINItemCategoryCodestyle.GetInputElement().value = cellInfo.value;
                   //}

                   //Next = false;
                   CINItemCategoryCodestyle.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "ProductCategoryCodeStyle") {
                   //if (cellInfo.value === null && CINProductCategoryCodestyle.GetValue() != null) {
                   //    CINProductCategoryCodestyle.SetValue(null);
                   //    SetNull = true;
                   //    loader.Show();
                   //}
                   //else {
                   //    CINProductCategoryCodestyle.GetInputElement().value = cellInfo.value;
                   //}

                   //Next = false;
                   CINProductCategoryCodestyle.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;

               }
               if (e.focusedColumn.fieldName === "SupplierCodeStyle") {
                   //if (cellInfo.value === null && CINSupplierCodestyle.GetValue() != null) {
                   //    CINSupplierCodestyle.SetValue(null);
                   //    SetNull = true;
                   //    loader.Show();
                   //}
                   //else {
                   //    CINSupplierCodestyle.GetInputElement().value = cellInfo.value;
                   //}

                   //Next = false;
                   CINSupplierCodestyle.GetInputElement().value = cellInfo.value
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "ComponentStyle") {
                   //if (cellInfo.value === null && CINComponent.GetValue() != null) {
                   //    CINComponent.SetValue(null);
                   //    SetNull = true;
                   //    loader.Show();
                   //}
                   //else {
                   //    CINComponent.GetInputElement().value = cellInfo.value;
                   //}

                   //Next = false;
                   CINComponent.GetInputElement().value = cellInfo.value
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "ItemCodeStyle") {
                   //if (cellInfo.value === null && CINItemCodestyle.GetValue() != null) {
                   //    CINItemCodestyle.SetValue(null);
                   //    SetNull = true;
                   //    loader.Show();
                   //}
                   //else {
                   //    CINItemCodestyle.GetInputElement().value = cellInfo.value;
                   //}

                   //Next = false;
                   CINItemCodestyle.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "ColorCodeStyle") {
                   //if (cellInfo.value === null && CINColorCodestyle.GetValue() != null) {
                   //    CINColorCodestyle.SetValue(null);
                   //    SetNull = true;
                   //    loader.Show();
                   //}
                   //else {
                   //    CINColorCodestyle.GetInputElement().value = cellInfo.value;
                   //}

                   //Next = false;
                   CINColorCodestyle.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "ClassCodeStyle") {
                   //if (cellInfo.value === null && CINClassCodestyle.GetValue() != null) {
                   //    CINClassCodestyle.SetValue(null);
                   //    SetNull = true;
                   //    loader.Show();
                   //}
                   //else {
                   //    CINClassCodestyle.GetInputElement().value = cellInfo.value;
                   //}

                   //Next = false;
                   CINClassCodestyle.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "SizeCodeStyle") {
                   //if (cellInfo.value === null && CINSizeCodestyle.GetValue() != null) {
                   //    CINSizeCodestyle.SetValue(null);
                   //    SetNull = true;
                   //    loader.Show();
                   //}
                   //else {
                   //    CINSizeCodestyle.GetInputElement().value = cellInfo.value;
                   //}

                   //Next = false;
                   CINSizeCodestyle.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "UnitStyle") {
                   //if (cellInfo.value === null && CINUnitstyle.GetValue() != null) {
                   //    CINUnitstyle.SetValue(null);
                   //    SetNull = true;
                   //    loader.Show();
                   //}
                   //else {
                   //    CINUnitstyle.GetInputElement().value = cellInfo.value;
                   //}

                   //Next = false;
                   CINUnitstyle.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "StockSize") {
                   //if (cellInfo.value === null && CINStockSize.GetValue() != null) {
                   //    CINStockSize.SetValue(null);
                   //    SetNull = true;
                   //    loader.Show();
                   //}
                   //else {
                   //    CINStockSize.GetInputElement().value = cellInfo.value;
                   //}

                   //Next = false;
                   CINStockSize.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "ItemCategoryDescription"
                   || e.focusedColumn.fieldName === "ProductCategoryDescription"
                   || e.focusedColumn.fieldName === "ItemDescription"
                   || e.focusedColumn.fieldName === "EstimatedCost"
                   || e.focusedColumn.fieldName === "PictureBOM") {
                   e.cancel = true;

                   var imagebinary = CINgvStyleDetail.batchEditApi.GetCellValue(e.visibleIndex, "PictureBOM")
                   if (imagebinary != null) {
                       CINItemImagePicture.SetImageProperties('data:image/jpg;base64,' + imagebinary, 'data:image/jpg;base64,' + imagebinary, '', '');
                   }

               }
               // -- END OF STYLE DETAIL -- //

               if (e.focusedColumn.fieldName === "OtherPictureUpload") {
                   e.cancel = true;
               }

               // -- MEASUREMENT CHART DETAIL -- //
               if (e.focusedColumn.fieldName === "Order") {
                   if (!CINBaseSize.GetText()) {
                       CINErrorConfirm.Show();
                       setElementVisible('BaseSizeError', true);
                       CINSizeDetail1.Refresh();
                   }
               }
               if (e.focusedColumn.fieldName === "Code") {
                   CINPOMCode.GetInputElement().value = cellInfo.value;
               }
               // -- END OF MEASUREMENT CHART DETAIL -- //


               // -- OTHER PICTURES DETAIL -- //
               if (e.focusedColumn.fieldName === "OtherPicture") {
                   e.cancel = true;
               }
               if (e.focusedColumn.fieldName === "OtherPictureUpload") {
                   e.cancel = true;
               }

               if (e.focusedColumn.fieldName === "ImageFileName"
                   || e.focusedColumn.fieldName === "OtherPicture"
                   || e.focusedColumn.fieldName === "OtherPictureUpload") {

                   var imagebinary = CINgvOtherPictures.batchEditApi.GetCellValue(e.visibleIndex, "OtherPicture")
                   if (imagebinary != null) {
                       CINOtherPicturePicture.SetImageProperties('data:image/jpg;base64,' + imagebinary, 'data:image/jpg;base64,' + imagebinary, '', '');
                   }
               }
               // -- END OF OTHER PICTURES DETAIL -- //
           }



           //if (SetNull) {
           //    e.cancel = true;
           //}

       }


       //Kapag umalis ka sa field na yun. hindi mawawala yung value.
       function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
           var cellInfo = e.rowValues[currentColumn.index];
           pomcodeNew = s.batchEditApi.GetCellValue(e.visibleIndex, "Code");
           //if (currentColumn.fieldName === "PropertyNumber") {
           //    cellInfo.value = gl.GetValue();
           //    cellInfo.text = gl.GetText();
           //}
           //if (currentColumn.fieldName === "ColorCode") {
           //    cellInfo.value = gl2.GetValue();
           //    cellInfo.text = gl2.GetText();
           //}
           //if (currentColumn.fieldName === "ClassCode") {
           //    cellInfo.value = gl3.GetValue();
           //    cellInfo.text = gl3.GetText();
           //}
           //if (currentColumn.fieldName === "Qty") {
           //    cellInfo.value = CINQty.GetValue();
           //    cellInfo.text = CINQty.GetText();
           //} 
           //if (currentColumn.fieldName === "UnitCost") {
           //    cellInfo.value = CINUnitCost.GetValue();
           //    cellInfo.text = CINUnitCost.GetText();
           //}
           //if (currentColumn.fieldName === "AccumulatedDepreciation") {
           //    cellInfo.value = CINAccumulatedDepreciation.GetValue();
           //    cellInfo.text = CINAccumulatedDepreciation.GetText();
           //}
           //if (currentColumn.fieldName === "IsVat") {
           //    cellInfo.value = CINIsVAT.GetValue();
           //}
           // -- FIT DETAIL -- //
           if (currentColumn.fieldName === "Stitch") {
               cellInfo.value = CINStitch.GetValue();
               cellInfo.text = CINStitch.GetText();
           }
           if (currentColumn.fieldName === "ThreadColor") {
               cellInfo.value = CINThreadColor.GetValue();
               cellInfo.text = CINThreadColor.GetText();
           }
           if (currentColumn.fieldName === "Ticket") {
               cellInfo.value = CINTicket.GetValue();
               cellInfo.text = CINTicket.GetText();
           }
           // -- END OF FIT DETAIL -- //
           // -- EMBROIDER DETAIL -- //
           if (currentColumn.fieldName === "EmbroCode") {
               cellInfo.value = CINEmbroiderCode.GetValue();
               cellInfo.text = CINEmbroiderCode.GetText();
           }
           // -- END OF EMBROIDER DETAIL -- //
           // -- PRINT DETAIL -- //
           if (currentColumn.fieldName === "PrintCode") {
               cellInfo.value = CINPrintCode.GetValue();
               cellInfo.text = CINPrintCode.GetText();
           }
           if (currentColumn.fieldName === "PrintInk") {
               cellInfo.value = CINPrintInk.GetValue();
               cellInfo.text = CINPrintInk.GetText();
           }
           // -- END OF PRINT DETAIL -- //
           // -- STEP DETAIL -- //
           if (currentColumn.fieldName === "StepCodeSteps") {
               cellInfo.value = CINStepCodeSteps.GetValue();
               cellInfo.text = CINStepCodeSteps.GetText();
           }
           if (currentColumn.fieldName === "SupplierSteps") {
               cellInfo.value = CINSupplierCodeSteps.GetValue();
               cellInfo.text = CINSupplierCodeSteps.GetText();
           }
           // -- END OF STEP DETAIL -- //

           // -- STYLE DETAIL -- //
           if (currentColumn.fieldName === "StepCodeStyle") {
               cellInfo.value = CINStepCodestyle.GetValue();
               cellInfo.text = CINStepCodestyle.GetText();
           }
           if (currentColumn.fieldName === "ItemCategoryCodeStyle") {
               cellInfo.value = CINItemCategoryCodestyle.GetValue();
               cellInfo.text = CINItemCategoryCodestyle.GetText();
           }
           if (currentColumn.fieldName === "ProductCategoryCodeStyle") {
               cellInfo.value = CINProductCategoryCodestyle.GetValue();
               cellInfo.text = CINProductCategoryCodestyle.GetText();
           }
           if (currentColumn.fieldName === "SupplierCodeStyle") {
               cellInfo.value = CINSupplierCodestyle.GetValue();
               cellInfo.text = CINSupplierCodestyle.GetText();
           }
           if (currentColumn.fieldName === "ComponentStyle") {
               cellInfo.value = CINComponent.GetValue();
               cellInfo.text = CINComponent.GetText();
           }
           if (currentColumn.fieldName === "ItemCodeStyle") {
               cellInfo.value = CINItemCodestyle.GetValue();
               cellInfo.text = CINItemCodestyle.GetText();
           }
           if (currentColumn.fieldName === "ColorCodeStyle") {
               cellInfo.value = CINColorCodestyle.GetValue();
               cellInfo.text = CINColorCodestyle.GetText();
           }
           if (currentColumn.fieldName === "ClassCodeStyle") {
               cellInfo.value = CINClassCodestyle.GetValue();
               cellInfo.text = CINClassCodestyle.GetText();
           }
           if (currentColumn.fieldName === "SizeCodeStyle") {
               cellInfo.value = CINSizeCodestyle.GetValue();
               cellInfo.text = CINSizeCodestyle.GetText();
           }
           if (currentColumn.fieldName === "UnitStyle") {
               cellInfo.value = CINUnitstyle.GetValue();
               cellInfo.text = CINUnitstyle.GetText();
           }
           if (currentColumn.fieldName === "StockSize") {
               cellInfo.value = CINStockSize.GetValue();
               cellInfo.text = CINStockSize.GetText();
           }
           // -- END OF STYLE DETAIL -- //

           // -- MEASUREMENT CHART DETAIL -- //
           if (currentColumn.fieldName === "Code") {
               cellInfo.value = CINPOMCode.GetValue();
               cellInfo.text = CINPOMCode.GetText();
           }
           // -- END OF MEASUREMENT CHART DETAIL -- //



           if (currentColumn.fieldName === "Code") {
               cellInfo.value = CINPOMCode.GetValue();
               cellInfo.text = CINPOMCode.GetText();
           }
           if (currentColumn.fieldName === "POMCode") {
               cellInfo.value = CINGBPOMCode.GetValue();
               cellInfo.text = CINGBPOMCode.GetText();
           }
       }

       //var val;
       //var temp;
       //function ProcessCells(selectedIndex, e, column, s) {
       //    var totalcostasset = 0.00;
       //    if (val == null) {
       //        val = ";;;;;;;;;;";
       //        temp = val.split(';');
       //    }
       //    if (temp[0] == null) {
       //        temp[0] = "";
       //    }
       //    if (temp[1] == null) {
       //        temp[1] = "";
       //    }
       //    if (temp[2] == null) {
       //        temp[2] = "";
       //    }
       //    if (temp[3] == null) {
       //        temp[3] = "";
       //    }
       //    if (temp[4] == null) {
       //        temp[4] = "";
       //    } 
       //    if (temp[5] == null) {
       //        temp[5] = "";
       //    }
       //    if (temp[6] == null) {
       //        temp[6] = "";
       //    }
       //    if (temp[7] == null) {
       //        temp[7] = "";
       //    }
       //    if (temp[8] == null) {
       //        temp[8] = "";
       //    }
       //    if (temp[9] == null) {
       //        temp[9] = "";
       //    }
       //    if (temp[10] == null) {
       //        temp[10] = "";
       //    }
       //    if (selectedIndex == 0) {
       //        if (column.fieldName == "ColorCode") {
       //            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0]);
       //        }
       //        if (column.fieldName == "ClassCode") {
       //            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[1]);
       //        }
       //        if (column.fieldName == "SizeCode") {
       //            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[2]);
       //        }
       //        if (column.fieldName == "ItemCode") {
       //            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
       //        }
       //        if (column.fieldName == "Qty") {
       //            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
       //        }
       //        if (column.fieldName == "UnitCost") {
       //            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[5]);
       //        }
       //        if (column.fieldName == "AccumulatedDepreciation") {
       //            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[6]);
       //        }
       //        if (column.fieldName == "PropertyStatus") {
       //            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[7]);
       //        }
       //        if (column.fieldName == "IsVat") {
       //            if (temp[8] == "True") {
       //                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, CINIsVAT.SetChecked = true);
       //            }
       //            else {
       //                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, CINIsVAT.SetChecked = false);
       //            }
       //        }
       //        if (column.fieldName == "VATCode") {
       //            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[9]);
       //        }
       //        if (column.fieldName == "Rate") {
       //            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[10]);
       //        }
       //        if (column.fieldName == "OrigQty") {
       //            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
       //        }
       //    }
       //}
       var identifierHeader;
       var val_Header;
       function HeaderEndCallback(s, e) {
           identifierHeader = s.GetGridView().cp_identifierheader;
           val_Header = s.GetGridView().cp_codes;

           if (identifierHeader == "EmbroiderSupplier") {
               CINEmbroiderSupplierDescription.SetText(val_Header);
               loader.Hide();
           }
           else if (identifierHeader == "PrintSupplier") {
               CINPrintSupplierDescription.SetText(val_Header);
               loader.Hide();
           }
           else if (identifierHeader == "WashSupplier") {
               CINWashSupplierName.SetText(val_Header);
               loader.Hide();
           }
       }

       var identifier;
       var val_EMBROCODE;
       var val_ALL;

       function GridEndChoice(s, e) {

           identifier = s.GetGridView().cp_identifier;
           //console.log('CINItemCategoryCodestyle.GetGridView().cp_RowClick = ' + CINItemCategoryCodestyle.GetGridView().cp_RowClick);
           //console.log('bomvaluechanged = ' + bomvaluechanged);
           //console.log('identifier = ' + identifier);
           canceledit = false;

           if (s.GetGridView().cp_RowClick && bomvaluechanged) {
               delete (s.GetGridView().cp_RowClick);
               loader.Hide();
           }
           // -- EMBROIDERY DETAIL -- //
           val_EMBROCODE = s.GetGridView().cp_codes;
           val_ALL = s.GetGridView().cp_codes;

           // -- END OF EMBROIDERY DETAIL -- //

           if (identifier == "StepCodeStyle") {
               delete (s.GetGridView().cp_identifier);
               CINgvStyleDetail.batchEditApi.StartEdit(index, CINgvStyleDetail.GetColumnByField('ItemCategoryCodeStyle').index)
           }
           if (identifier == "SupplierCodeStyle") {
               delete (s.GetGridView().cp_identifier);
               CINgvStyleDetail.batchEditApi.StartEdit(index, CINgvStyleDetail.GetColumnByField('ItemCodeStyle').index)
           }
           if (identifier == "ComponentStyle") {
               delete (s.GetGridView().cp_identifier);
               CINgvStyleDetail.batchEditApi.StartEdit(index, CINgvStyleDetail.GetColumnByField('StockSize').index)
           }
           if (identifier == "StockSizeStyle") {
               delete (s.GetGridView().cp_identifier);
               CINgvStyleDetail.batchEditApi.StartEdit(index, CINgvStyleDetail.GetColumnByField('ColorCodeStyle').index)
           }
           if (identifier == "ColorCodeStyle") {
               delete (s.GetGridView().cp_identifier);
               CINgvStyleDetail.batchEditApi.StartEdit(index, CINgvStyleDetail.GetColumnByField('ClassCodeStyle').index)
           }
           if (identifier == "ClassCodeStyle") {
               delete (s.GetGridView().cp_identifier);
               CINgvStyleDetail.batchEditApi.StartEdit(index, CINgvStyleDetail.GetColumnByField('SizeCodeStyle').index)
           }
           if (identifier == "SizeCodeStyle") {
               delete (s.GetGridView().cp_identifier);
               CINgvStyleDetail.batchEditApi.StartEdit(index, CINgvStyleDetail.GetColumnByField('PerPieceConsumption').index)
           }
           if (identifier == "UnitStyle") {
               delete (s.GetGridView().cp_identifier);
               CINgvStyleDetail.batchEditApi.StartEdit(index, CINgvStyleDetail.GetColumnByField('EstimatedUnitCost').index)
           }
           if (identifier == "StepCodeSteps") {
               delete (s.GetGridView().cp_identifier);
               CINgvStepDetail.batchEditApi.StartEdit(index, CINgvStepDetail.GetColumnByField('SupplierSteps').index)
           }

           if (identifier == "EmbroCode") {
               delete (s.GetGridView().cp_identifier);
               //if (valchange_EMBROCODE) {
               //    valchange_EMBROCODE = false;
               for (var i = 0; i < CINgvEmbroiderDetail.GetColumnsCount() ; i++) {
                   //console.log('anoto')
                   var column = CINgvEmbroiderDetail.GetColumn(i);
                   if (column.visible == false || column.fieldName == undefined)
                       continue;
                   ProcessCells_EMBROCODE(0, e.visibleIndex, column, CINgvEmbroiderDetail);
               }
               //}
               //CINgvEmbroiderDetail.batchEditApi.EndEdit();
           }

           else if (identifier == "PrintCode") {
               delete (s.GetGridView().cp_identifier);
               //if (valchange_EMBROCODE) {
               //    valchange_EMBROCODE = false;
               for (var i = 0; i < CINgvPrintDetail.GetColumnsCount() ; i++) {
                   //console.log('anoto')
                   var column = CINgvPrintDetail.GetColumn(i);
                   if (column.visible == false || column.fieldName == undefined)
                       continue;
                   ProcessCells_PRINTCODE(0, e.visibleIndex, column, CINgvPrintDetail);
               }
               //}
               //CINgvPrintDetail.batchEditApi.EndEdit();
           }

           else if (identifier == "InkCode") {
               delete (s.GetGridView().cp_identifier);
               //if (valchange_EMBROCODE) {
               //    valchange_EMBROCODE = false;
               for (var i = 0; i < CINgvPrintDetail.GetColumnsCount() ; i++) {
                   var column = CINgvPrintDetail.GetColumn(i);
                   if (column.visible == false || column.fieldName == undefined)
                       continue;
                   ProcessCells_INKCODE(0, e.visibleIndex, column, CINgvPrintDetail);
               }
               //}
               //CINgvPrintDetail.batchEditApi.EndEdit();
           }

           else if (identifier == "FitColorCode") {
               delete (s.GetGridView().cp_identifier);
               //if (valchange_EMBROCODE) {
               //    valchange_EMBROCODE = false;
               for (var i = 0; i < CINgvThreadDetail.GetColumnsCount() ; i++) {
                   var column = CINgvThreadDetail.GetColumn(i);
                   if (column.visible == false || column.fieldName == undefined)
                       continue;
                   ProcessCells_FITCOLORCODE(0, e.visibleIndex, column, CINgvThreadDetail);
               }
               //}
               //CINgvThreadDetail.batchEditApi.EndEdit();
           }

           else if (identifier == "POMCode") {
               delete (s.GetGridView().cp_identifier);
               if (valchange_EMBROCODE) {
                   valchange_EMBROCODE = false;
                   for (var i = 0; i < CINSizeDetail1.GetColumnsCount() ; i++) {
                       var column = CINSizeDetail1.GetColumn(i);
                       if (column.visible == false || column.fieldName == undefined)
                           continue;
                       ProcessCells_POMCODE(0, e.visibleIndex, column, CINSizeDetail1);
                   }
               }
               CINSizeDetail1.batchEditApi.EndEdit();
           }

           else if (identifier == "ItemCategoryCodeStyle") {
               delete (s.GetGridView().cp_identifier);
               //if (gridendchecker) {
               //gridendchecker = false;
               for (var i = 0; i < CINgvStyleDetail.GetColumnsCount() ; i++) {
                   var column = CINgvStyleDetail.GetColumn(i);
                   if (column.visible == false || column.fieldName == undefined)
                       continue;
                   ProcessCells_ItemCategoryCodeStyle(0, e.visibleIndex, column, CINgvStyleDetail);
               }
               //}
               //CINgvStyleDetail.batchEditApi.EndEdit();
           }


           else if (identifier == "ProductCategoryCodeStyle") {
               delete (s.GetGridView().cp_identifier);
               //if (gridendchecker) {
               //gridendchecker = false;
               for (var i = 0; i < CINgvStyleDetail.GetColumnsCount() ; i++) {
                   var column = CINgvStyleDetail.GetColumn(i);
                   if (column.visible == false || column.fieldName == undefined)
                       continue;
                   ProcessCells_ProductCategoryCodeStyle(0, e.visibleIndex, column, CINgvStyleDetail);
               }
               //}
               //CINgvStyleDetail.batchEditApi.EndEdit();
           }


           else if (identifier == "ItemCodeStyle") {
               delete (s.GetGridView().cp_identifier);
               //if (gridendchecker) {
               //    gridendchecker = false;
               for (var i = 0; i < CINgvStyleDetail.GetColumnsCount() ; i++) {
                   var column = CINgvStyleDetail.GetColumn(i);
                   if (column.visible == false || column.fieldName == undefined)
                       continue;
                   ProcessCells_ItemCodeStyle(0, e.visibleIndex, column, CINgvStyleDetail);
               }
               //}
               //CINgvStyleDetail.batchEditApi.EndEdit();
           }

           else if (identifier == "SupplierCodeSteps") {
               delete (s.GetGridView().cp_identifier);
               //if (gridendchecker) {
               //    gridendchecker = false;
               for (var i = 0; i < CINgvStepDetail.GetColumnsCount() ; i++) {
                   var column = CINgvStepDetail.GetColumn(i);
                   if (column.visible == false || column.fieldName == undefined)
                       continue;
                   ProcessCells_SupplierCodeSteps(0, e.visibleIndex, column, CINgvStepDetail);
               }
               // }
               //CINgvStepDetail.batchEditApi.EndEdit();
           }

           CINgvGradeBracket.batchEditApi.EndEdit();
       }

       function suboklangpota(s, e) {
           measurementcharterrorcounter++;
           if (measurementcharterrorcounter % 2 != 0) {
               $("#ErrorDetail").show();
           } else {
               $("#ErrorDetail").hide();
           }
       }
       //function GridEnd_EMBROCODE() {
       //    if (valchange_EMBROCODE) {
       //        valchange_EMBROCODE = false;
       //        for (var i = 0; i < s.GetColumnsCount() ; i++) {
       //            //console.log('anoto')
       //            var column = s.GetColumn(i);
       //            if (column.visible == false || column.fieldName == undefined)
       //                continue;
       //            ProcessCells_EMBROCODE(0, e.visibleIndex, column, s);
       //        }
       //    }
       //}


       function ProcessCells_EMBROCODE(selectedIndex, focused, column, s) {//Auto calculate qty function :D
           //console.log("ProcessCells_VAT")
           var temp_EMBROCODE;
           if (val_EMBROCODE == null) {
               val_EMBROCODE = ";;;";
           }
           temp_EMBROCODE = val_EMBROCODE.split(';');
           if (temp_EMBROCODE[0] == null) {
               temp_EMBROCODE[0] = "";
           }
           if (temp_EMBROCODE[1] == null) {
               temp_EMBROCODE[1] = "";
           }
           if (temp_EMBROCODE[2] == null) {
               temp_EMBROCODE[2] = "";
           }
           if (temp_EMBROCODE[3] == null) {
               temp_EMBROCODE[3] = "";
           }

           if (selectedIndex == 0) {
               if (column.fieldName == "EmbroDescription") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_EMBROCODE[0]);
               }
               if (column.fieldName == "Height") {
                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_EMBROCODE[1]);
               }
               if (column.fieldName == "Width") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_EMBROCODE[2]);
               }
           }
           loader.Hide();
           CINgvEmbroiderDetail.batchEditApi.StartEdit(index, CINgvEmbroiderDetail.GetColumnByField("UploadEmbroider").index);
       }

       function ProcessCells_PRINTCODE(selectedIndex, focused, column, s) {//Auto calculate qty function :D
           //console.log("ProcessCells_VAT")
           var temp_ALL;
           if (val_ALL == null) {
               val_ALL = ";";
           }
           temp_ALL = val_ALL.split(';');
           if (temp_ALL[0] == null) {
               temp_ALL[0] = "";
           }
           if (temp_ALL[1] == null) {
               temp_ALL[1] = "";
           }

           if (selectedIndex == 0) {
               if (column.fieldName == "PrintDescription") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[0]);
               }
           }

           loader.Hide();
           CINgvPrintDetail.batchEditApi.StartEdit(index, CINgvPrintDetail.GetColumnByField("PrintInk").index);
       }


       function ProcessCells_INKCODE(selectedIndex, focused, column, s) {
           var temp_ALL;
           if (val_ALL == null) {
               val_ALL = ";";
           }
           temp_ALL = val_ALL.split(';');
           if (temp_ALL[0] == null) {
               temp_ALL[0] = "";
           }
           if (temp_ALL[1] == null) {
               temp_ALL[1] = "";
           }

           if (selectedIndex == 0) {
               if (column.fieldName == "InkDescription") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[0]);
               }
           }

           loader.Hide();
           CINgvPrintDetail.batchEditApi.StartEdit(index, CINgvPrintDetail.GetColumnByField("UploadPrint").index);
       }


       function ProcessCells_FITCOLORCODE(selectedIndex, focused, column, s) {
           var temp_ALL;
           if (val_EMBROCODE == null) {
               val_EMBROCODE = ";;";
           }
           temp_ALL = val_ALL.split(';');
           if (temp_ALL[0] == null) {
               temp_ALL[0] = "";
           }
           if (temp_ALL[1] == null) {
               temp_ALL[1] = "";
           }
           if (temp_ALL[2] == null) {
               temp_ALL[2] = "";
           }

           if (selectedIndex == 0) {
               if (column.fieldName == "R") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[0]);
               }
               if (column.fieldName == "G") {
                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[1]);
               }
               if (column.fieldName == "B") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[2]);
               }
           }

           //cp.HideLoadingPanel();
           loader.Hide();
           CINgvThreadDetail.batchEditApi.StartEdit(index, CINgvThreadDetail.GetColumnByField("Ticket").index);
       }


       function ProcessCells_POMCODE(selectedIndex, focused, column, s) {
           var temp_ALL;
           if (val_EMBROCODE == null) {
               val_EMBROCODE = ";;;";
           }
           temp_ALL = val_ALL.split(';');
           if (temp_ALL[0] == null) {
               temp_ALL[0] = "";
           }
           if (temp_ALL[1] == null) {
               temp_ALL[1] = "";
           }

           if (selectedIndex == 0) {
               if (column.fieldName == "PointofMeasurement") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[0]);
               }
               if (column.fieldName == "Instruction") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[1]);
               }
           }
           loader.Hide();
       }

       function ProcessCells_ItemCategoryCodeStyle(selectedIndex, focused, column, s) {
           var temp_ALL;
           if (val_EMBROCODE == null) {
               val_EMBROCODE = ";";
           }
           temp_ALL = val_ALL.split(';');
           if (temp_ALL[0] == null) {
               temp_ALL[0] = "";
           }

           if (selectedIndex == 0) {
               if (column.fieldName == "ItemCategoryDescription") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[0]);
               }
           }

           loader.Hide();
           CINgvStyleDetail.batchEditApi.StartEdit(index, CINgvStyleDetail.GetColumnByField("ProductCategoryCodeStyle").index);
       }

       function ProcessCells_ProductCategoryCodeStyle(selectedIndex, focused, column, s) {
           var temp_ALL;
           if (val_EMBROCODE == null) {
               val_EMBROCODE = ";";
           }
           temp_ALL = val_ALL.split(';');
           if (temp_ALL[0] == null) {
               temp_ALL[0] = "";
           }

           if (selectedIndex == 0) {
               if (column.fieldName == "ProductCategoryDescription") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[0]);
               }
           }
           loader.Hide();
           CINgvStyleDetail.batchEditApi.StartEdit(index, CINgvStyleDetail.GetColumnByField("SupplierCodeStyle").index);
       }

       function ProcessCells_ItemCodeStyle(selectedIndex, focused, column, s) {
           var temp_ALL;
           if (val_EMBROCODE == null) {
               val_EMBROCODE = ";;;;;";
           }
           temp_ALL = val_ALL.split(';');
           if (temp_ALL[0] == null) {
               temp_ALL[0] = "";
           }
           if (temp_ALL[1] == null) {
               temp_ALL[1] = "";
           }
           if (temp_ALL[2] == null) {
               temp_ALL[2] = "";
           }
           if (temp_ALL[3] == null) {
               temp_ALL[3] = "";
           }
           if (temp_ALL[4] == null) {
               temp_ALL[4] = "";
           }
           if (temp_ALL[5] == null) {
               temp_ALL[5] = "";
           }
           if (temp_ALL[6] == null) {
               temp_ALL[6] = "";
           }
           if (selectedIndex == 0) {
               if (column.fieldName == "ColorCodeStyle") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[0]);
               }
               if (column.fieldName == "ClassCodeStyle") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[1]);
               }
               if (column.fieldName == "SizeCodeStyle") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[2]);
               }
               if (column.fieldName == "ItemDescription") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[3]);
               }
               if (column.fieldName == "UnitStyle") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[4]);
               }
               if (column.fieldName == "EstimatedUnitCost") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[5]);

                   computeTotalItemCost();
               }
               if (column.fieldName == "PictureBOM") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[6]);
               }
           }
           loader.Hide();
           CINgvStyleDetail.batchEditApi.StartEdit(index, CINgvStyleDetail.GetColumnByField("ComponentStyle").index);
       }


       function ProcessCells_SupplierCodeSteps(selectedIndex, focused, column, s) {
           var temp_ALL;
           if (val_ALL == null) {
               val_ALL = ";";
           }
           temp_ALL = val_ALL.split(';');
           if (temp_ALL[0] == null) {
               temp_ALL[0] = "";
           }

           if (selectedIndex == 0) {
               if (column.fieldName == "WorkCenterName") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[0]);
               }
           }
           loader.Hide();
           CINgvStepDetail.batchEditApi.StartEdit(index, CINgvStepDetail.GetColumnByField("EstimatedPrice").index);
       }

       function lookup(s, e) {
           if (isSetTextRequired) {//Sets the text during lookup for item code
               s.SetText(s.GetInputElement().value);
               isSetTextRequired = false;
               bomvaluechanged = false;
           }
       }

       //function lookup(s, e) {
       //    //if (isSetTextRequired) {//Sets the text during lookup for item code
       //    //    //s.SetText(s.GetInputElement().value);
       //    //    var propertynum;
       //    //    var getallpropertynum;
       //    //    isSetTextRequired = false;
       //    //    var indicies = gv1.batchEditApi.GetRowVisibleIndices();
       //    //    //for (var i = 0; i < indicies.length; i++) {
       //    //    //    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
       //    //    //        console.log(indicies)
       //    //    //        propertynum = gv1.batchEditApi.GetCellValue(indicies[i], "PropertyNumber") + ";";

       //    //    //        getallpropertynum += propertynum;
       //    //    //        console.log(getallpropertynum + " ALL")
       //    //    //    }

       //    //    //    else {
       //    //    //        var keyB = gv1.GetRowKey(indicies[i]);
       //    //    //        if (gv1.batchEditApi.IsDeletedRow(keyB))
       //    //    //            console.log("deleted row " + indicies[i]);
       //    //    //        else {
       //    //    //            propertynum = gv1.batchEditApi.GetCellValue(indicies[i], "PropertyNumber") + ";";
       //    //    //            getallpropertynum += propertynum;

       //    //    //        }
       //    //    //    }

       //    //    //}
       //    //    //gl2.GetGridView().PerformCallback('CheckPropertyNumber' + '|' + getallpropertynum + '|' + 'itemc');
       //    //    //console.log(gl.GetGridView() + '        gl.GetGridView()');
       //    //    //gl.GetGridView().PerformCallback('CheckPNumber' + '|' + getallpropertynum + '|' + 'itemc');
       //    //    //e.processOnServer = false;
       //    }
       //}

       //function CheckPropertyNumber(s, e) {
       //    var propertynum;
       //    var getallpropertynum;
       //    var indicies = gv1.batchEditApi.GetRowVisibleIndices();
       //    for (var i = 0; i < indicies.length; i++) {
       //        if (gv1.batchEditApi.IsNewRow(indicies[i])) {
       //            propertynum = gv1.batchEditApi.GetCellValue(indicies[i], "PropertyNumber") + ";";

       //            getallpropertynum += propertynum;
       //            console.log(getallpropertynum + " ALL")
       //        }

       //        else {
       //            var keyB = gv1.GetRowKey(indicies[i]);
       //            if (gv1.batchEditApi.IsDeletedRow(keyB))
       //                console.log("deleted row " + indicies[i]);
       //            else {
       //                propertynum = gv1.batchEditApi.GetCellValue(indicies[i], "PropertyNumber") + ";";
       //                getallpropertynum += propertynum;

       //            }
       //        }

       //    }
       //    console.log('ditopota')
       //    gl.GetGridView().PerformCallback('CheckPropertyNumber' + '|' + getallpropertynum + '|' + 'itemc');
       //    e.processOnServer = false;
       //}

       //var preventEndEditOnLostFocus = false;
       function gridLookup_KeyDown(s, e) { //Allows tabbing between gridlookup on details
           isSetTextRequired = false;
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode !== 9) return;
           var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
           if (gv1.batchEditApi[moveActionName]()) {
               ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
           }
       }

       function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode == 13)
               gv1.batchEditApi.EndEdit();
           //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
       }

       function CINgvStyleDetail_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
           setTimeout(function () {
               CINgvStyleDetail.batchEditApi.EndEdit();
           }, 1000);
       }

       function CINgvStepDetail_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
           setTimeout(function () {
               CINgvStepDetail.batchEditApi.EndEdit();
           }, 1000);
       }

       //validation
       function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)





               for (var i = 0; i < CINSizeDetail1.GetColumnsCount() ; i++) {
                   var column = s.GetColumn(i);

                   if (column.fieldName == "Code") {
                       var cellValidationInfo = e.validationInfo[column.index];
                       if (!cellValidationInfo) continue;
                       var value = cellValidationInfo.value;
                       code = value;

                       var indicies = CINSizeDetail1.batchEditApi.GetRowVisibleIndices();
                       for (var h = 0; h < indicies.length; h++) {
                           var getval = CINSizeDetail1.batchEditApi.GetCellValue(indicies[h], "Code");

                           if ((e.visibleIndex != indicies[h]) && (code == getval)) {
                               cellValidationInfo.isValid = false;
                               ValidityState = false;
                               cellValidationInfo.errorText = "POM Code must be unique!";

                               isValid = false;
                               counterror++;

                               //console.log((e.visibleIndex + ' : ' + indicies[h] + ' : ' + linenum + ' : ' + getval));
                           }
                      
                        
                       }
                   }
               }
           
       }


       function OnCustomClick(s, e) {
           if (e.buttonID == "Details") {
               var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "PropertyNumber");
               var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
               var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
               var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
               var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "UnitBase");
               factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
               + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&unitbase=' + unitbase);
           }

           if (e.buttonID == "Delete") {
              
               //gv1.DeleteRow(e.visibleIndex);
               //autocalculate(s, e);
           }

           if (e.buttonID == "ThreadDelete") {
               CINgvThreadDetail.DeleteRow(e.visibleIndex);
               //autocalculate(s, e);
           }

           // -- EMBROIDER DETAIL -- //
           if (e.buttonID == "EmbroiderDelete") {
               CINgvEmbroiderDetail.DeleteRow(e.visibleIndex);
               //autocalculate(s, e);
           }
           //if (e.buttonID == "EmbroiderShowImage") {
           //    //CINgvEmbroiderDetail.DeleteRow(e.visibleIndex);
           //    var imagebinary = CINgvEmbroiderDetail.batchEditApi.GetCellValue(e.visibleIndex, "PictureEmbroider")
           //    CINEmbroiderImage.SetImageUrl('data:image/jpg;base64,' + imagebinary);
           //    //var imagebinary = e.callbackData.replace('data:image/jpg;base64,', '');
           //}
           // -- END OF EMBROIDER DETAIL -- //

           // -- PRINT DETAIL -- //
           if (e.buttonID == "PrintDelete") {
               CINgvPrintDetail.DeleteRow(e.visibleIndex);
               //autocalculate(s, e);
           }
           //if (e.buttonID == "PrintShowImage") {
           //    var imagebinary = CINgvPrintDetail.batchEditApi.GetCellValue(e.visibleIndex, "PicturePrint")
           //    CINPrintImage.SetImageUrl('data:image/jpg;base64,' + imagebinary);
           //}
           // -- END OF PRINT DETAIL -- //

           if (e.buttonID == "MeasurementChartDelete") {
               CINSizeDetail1.DeleteRow(e.visibleIndex);
         
               //autocalculate(s, e);
           }

           if (e.buttonID == "StyleDelete") {
               CINgvStyleDetail.DeleteRow(e.visibleIndex);
               //autocalculate(s, e);
               computeTotalItemCost(s, e);
           }

           if (e.buttonID == "StepsDelete") {
               CINgvStepDetail.DeleteRow(e.visibleIndex);
               //autocalculate(s, e);
               computeTotalItemCost(s, e);
           }


           // -- OTHER IMAGE DETAIL -- //
           if (e.buttonID == "OtherPictureDelete") {
               CINgvOtherPictures.DeleteRow(e.visibleIndex);
               //autocalculate(s, e);
           }
           //if (e.buttonID == "OtherPictureShowImage") {
           //    var imagebinary = CINgvOtherPictures.batchEditApi.GetCellValue(e.visibleIndex, "OtherPicture")
           //    CINOtherPicturePicture.SetImageUrl('data:image/jpg;base64,' + imagebinary);
           //}
           // -- END OF OTHER IMAGE DETAIL -- //

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
           if (e.buttonID == "GradeBracketDelete") {
               pomcode = CINgvGradeBracket.batchEditApi.GetCellValue(e.visibleIndex, "POMCode");
               CINgvGradeBracket.DeleteRow(e.visibleIndex); base = CINBaseSize.GetText()
               POMfocusindex = CINSizeDetail1.GetColumnByField(base).index;
               autoToleranceNew();
           }
       }


       function GetStepDetail(s, e) {
           var generate = confirm("Are you sure you want to Generate Step Detail?");
           if (generate) {
               CINgvStepDetail.CancelEdit();
               cp.PerformCallback('GetStepDetail');
               e.processOnServer = false;
           }
       }

       function GetStyleDetail(s, e) {
           var generate = confirm("Are you sure you want to Generate Style Detail?");
           if (generate) {
               CINgvStyleDetail.CancelEdit();
               cp.PerformCallback('GetStyleDetail');
               e.processOnServer = false;
           }
       }


       function computestepprice(s, e) {
           var estimatedpricestep = 0.00;
           var totalcost = 0.00;

           setTimeout(function () { //New Rows
               var indicies = CINgvStepDetail.batchEditApi.GetRowVisibleIndices();

               for (var i = 0; i < indicies.length; i++) {
                   if (CINgvStepDetail.batchEditApi.IsNewRow(indicies[i])) {
                       estimatedpricestep = CINgvStepDetail.batchEditApi.GetCellValue(indicies[i], "EstimatedPrice");

                       totalcost += estimatedpricestep;
                   }
                   else { //Existing Rows
                       var key = CINgvStepDetail.GetRowKey(indicies[i]);
                       if (CINgvStepDetail.batchEditApi.IsDeletedRow(key)) {
                           console.log("deleted row " + indicies[i]);
                           //gv1.batchEditHelper.EndEdit();
                       }
                       else {
                           estimatedpricestep = CINgvStepDetail.batchEditApi.GetCellValue(indicies[i], "EstimatedPrice");

                           totalcost += estimatedpricestep;
                       }
                   }
               }

               CINTotalItemCost.SetText(totalcost.toFixed(2));
           }, 500);
       }

       function BOMandCOSTING(s, e) {
           var estimatedpricestyle = 0.00;
           var totalcost = 0.00;
           var curtotalcost = CINTotalItemCost.GetText();

           setTimeout(function () { //New Rows
               var indicies = CINgvStyleDetail.batchEditApi.GetRowVisibleIndices();

               for (var i = 0; i < indicies.length; i++) {
                   if (CINgvStyleDetail.batchEditApi.IsNewRow(indicies[i])) {
                       estimatedpricestyle = CINgvStyleDetail.batchEditApi.GetCellValue(indicies[i], "EstimatedCost");

                       totalcost += estimatedpricestyle;
                   }
                   else { //Existing Rows
                       var key = CINgvStyleDetail.GetRowKey(indicies[i]);
                       if (CINgvStyleDetail.batchEditApi.IsDeletedRow(key)) {
                           console.log("deleted row " + indicies[i]);
                           //gv1.batchEditHelper.EndEdit();
                       }
                       else {
                           estimatedpricestyle = CINgvStyleDetail.batchEditApi.GetCellValue(indicies[i], "EstimatedPrice");

                           totalcost += estimatedpricestyle;
                       }
                   }
               }

               curtotalcost = +curtotalcost + totalcost
               CINTotalItemCost.SetValue(curtotalcost);
           }, 500);
       }
       //function autocalculate(s, e) {
       //    OnInitTrans();

       //    var qty = 0.00;
       //    var unitprice = 0.00;
       //    var unitcost = 0.00;
       //    var depreciation = 0.00;
       //    var soldamount = 0.00;
       //    var costamount = 0.00;
       //    var depreciationsmount = 0.00;

       //    var qtyVAT = 0.00;
       //    var unitpriceVAT = 0.00;
       //    var soldamountVAT = 0.00;
       //    var qtyNVAT = 0.00;
       //    var unitpriceNVAT = 0.00;
       //    var soldamountNVAT = 0.00;
       //    var totalamountsoldNVAT = 0.00;

       //    var totalamountsold = 0.00;
       //    var totalcostasset = 0.00;
       //    var totalaccumulateddepreciation = 0.00;
       //    var netbookvalue = 0.00;
       //    var totalgainloss = 0.00;
       //    var grossnonvatableamount = 0.00;
       //    var grossvatableamount = 0.00;
       //    var rate = 0.00;

       //    setTimeout(function () { //New Rows
       //        var indicies = gv1.batchEditApi.GetRowVisibleIndices();

       //            for (var i = 0; i < indicies.length; i++)
       //            {
       //                if (gv1.batchEditApi.IsNewRow(indicies[i])) {
       //                    qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
       //                    unitprice = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");
       //                    unitcost = gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost");
       //                    depreciation = gv1.batchEditApi.GetCellValue(indicies[i], "AccumulatedDepreciation");

       //                    //Check if input Quanties are Negative
       //                    //qty = qty < 0 ? 0 : qty;
       //                    //unitprice = unitprice < 0 ? 0 : unitprice;
       //                    if (qty < 0)
       //                    {
       //                        qty = 0;
       //                        gv1.batchEditApi.SetCellValue(indicies[i], "Qty", qty.toFixed(2));
       //                    }
       //                    if (unitprice < 0) {
       //                        unitprice = 0;
       //                        gv1.batchEditApi.SetCellValue(indicies[i], "UnitPrice", unitprice.toFixed(2));
       //                    }
       //                    // End Of Negative Checking - LGE (02/03/2016)

       //                    soldamount = qty * unitprice;
       //                    costamount = qty * unitcost;
       //                    depreciationsmount = depreciation * 1;
       //                    totalamountsold += soldamount;
       //                    totalcostasset += costamount;
       //                    totalaccumulateddepreciation += depreciationsmount;
       //                    netbookvalue = totalcostasset - totalaccumulateddepreciation;
       //                    totalgainloss = totalamountsold - netbookvalue;

       //                    var cb = gv1.batchEditApi.GetCellValue(indicies[i], "IsVat");

       //                    if (cb == true)
       //                    {

       //                        console.log("checkpasok");
       //                        qtyVAT = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
       //                        unitpriceVAT = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");
       //                        rate = gv1.batchEditApi.GetCellValue(indicies[i], "Rate");
       //                        console.log(rate + ' r a t e');
       //                        soldamountVAT = qtyVAT * unitpriceVAT;

       //                        grossvatableamount += soldamountVAT * rate;
       //                    }
       //                    else
       //                    {

       //                        console.log("unchekpasok");
       //                        qtyNVAT = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
       //                        unitpriceNVAT = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");

       //                        soldamountNVAT += qtyNVAT * unitpriceNVAT;
       //                        totalamountsoldNVAT += soldamountNVAT

       //                    }

       //                    gv1.batchEditApi.SetCellValue(indicies[i], "SoldAmount", soldamount.toFixed(2));

       //                } //END OF IsNewRow indicies


       //                else { //Existing Rows
       //                    var key = gv1.GetRowKey(indicies[i]);
       //                    if (gv1.batchEditApi.IsDeletedRow(key))
       //                        console.log("deleted row " + indicies[i]);
       //                    else {
       //                        qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
       //                        unitprice = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");
       //                        unitcost = gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost");
       //                        depreciation = gv1.batchEditApi.GetCellValue(indicies[i], "AccumulatedDepreciation");

       //                        //Check if input Quanties are Negative
       //                        if (qty < 0) {
       //                            qty = 0;
       //                            gv1.batchEditApi.SetCellValue(indicies[i], "Qty", qty.toFixed(2));
       //                        }
       //                        if (unitprice < 0) {
       //                            unitprice = 0;
       //                            gv1.batchEditApi.SetCellValue(indicies[i], "UnitPrice", unitprice.toFixed(2));
       //                        }
       //                        // End Of Negative Checking - LGE (02/03/2016)

       //                        soldamount = qty * unitprice;
       //                        costamount = qty * unitcost;
       //                        depreciationsmount = depreciation * 1;
       //                        totalamountsold += soldamount;
       //                        totalcostasset += costamount;
       //                        totalaccumulateddepreciation += depreciationsmount;
       //                        netbookvalue = totalcostasset - totalaccumulateddepreciation;
       //                        totalgainloss = netbookvalue - totalamountsold;

       //                        var cb = gv1.batchEditApi.GetCellValue(indicies[i], "IsVat")

       //                        if (cb == true) {
       //                            qtyVAT = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
       //                            unitpriceVAT = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");

       //                            soldamountVAT = qtyVAT * unitpriceVAT;

       //                            grossvatableamount += soldamountVAT * vatrate;
       //                        }
       //                        else {
       //                            qtyNVAT = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
       //                            unitpriceNVAT = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");

       //                            soldamountNVAT = qtyNVAT * unitpriceNVAT;
       //                            totalamountsoldNVAT += soldamountNVAT


       //                        }
       //                        gv1.batchEditApi.SetCellValue(indicies[i], "SoldAmount", soldamount.toFixed(2));
       //                    }


       //                } // END OF ELSE EXISTING ROWS

       //            } //END OF FOR LOOP (indicies)

       //            CINTotalAmountSold.SetText(totalamountsold.toFixed(2));
       //            CINTotalCostAsset.SetText(totalcostasset.toFixed(2));
       //            CINTotalAccumulatedDepreciationRecord.SetText(totalaccumulateddepreciation.toFixed(2));
       //            CINNetBookValue.SetText(netbookvalue.toFixed(2));
       //            CINTotalGainLoss.SetText(totalgainloss.toFixed(2));
       //            CINTotalNonGrossVatableAmount.SetText(totalamountsoldNVAT.toFixed(2));
       //            CINTotalGrossVatableAmount.SetText(grossvatableamount.toFixed(2));
       //            //console.log(CINTotalAmountSold.GetValue() + " FINAL TotalAmountSold")
       //            //console.log(CINSoldAmount.GetValue() + "  FINAL")
       //            //console.log(CINTotalCostAsset.GetValue() + "  FINAL TotalCostAsset")


       //    }, 500);
       //}
       function autoTolerance(s, e) {

           var tolerance = 0.00;
           var grade;
           var base = CINBaseSize.GetText();
           setTimeout(function () { //New Rows
               var indicies = CINSizeDetail1.batchEditApi.GetRowVisibleIndices();

               for (var i = 0; i < indicies.length; i++) {
                   if (CINSizeDetail1.batchEditApi.IsNewRow(indicies[i])) {
                       grade = CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], "Grade");

                       //tolerance = eval(grade) / 2;
                       tolerance = toDecimal(grade) / 2;
                       var pia = new Fraction(tolerance);
                       CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], "Tolerance", pia);

                   } //END OF IsNewRow indicies


                   else { //Existing Rows
                       var key = CINSizeDetail1.GetRowKey(indicies[i]);
                       if (CINSizeDetail1.batchEditApi.IsDeletedRow(key))
                           console.log("deleted row " + indicies[i]);
                       else {
                           grade = CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], "Grade");

                           tolerance = toDecimal(grade) / 2;
                           var pia = new Fraction(tolerance);

                           CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], "Tolerance", pia);
                           //CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], "Tolerance", tolerance.toFixed(2));
                       }
                   } // END OF ELSE EXISTING ROWS
               } //END OF FOR LOOP (indicies)
           }, 500);
           computesizesvalue();
       }


       function uploadimageembroider(s, e) {
           //document.getElementById("gvuploadimage").click();
           //CINUploadImage.Click();
           //CINUploadImage.Upload();
           $('#gvuploadimageembroider_TextBox0_Input').click();
           //console.log($('.dxTI')[1]);    Use to view element ID
           //console.log($('.dxTI')[2]);
           //console.log($('.dxTI')[3]);
           //console.log($('.dxTI')[4]);
           //console.log($('.dxTI')[5]);
           //console.log($('.dxTI')[6]);
           //console.log($('.dxTI')[7]);
           //$('.dxTI')[1].click();
       }

       function uploadimageprint(s, e) {
           $('#gvuploadimageprint_TextBox0_Input').click();
       }
       function uploadimageotherpiture(s, e) {
           $('#gvuploadimageotherimage_TextBox0_Input').click();
       }


       function computesizesvalue(s, e) {

           var tolerance = 0.00;
           var grade = 0.00;
           var base = CINBaseSize.GetValue();
           var value = 0.00;
           var tot = 0.00;
           var mainbracket = 0;
           var indexbackward = 0;
           var basevalue = 0.00;
           var bracketcounter = 0;    // Reset Bracket Counter Every Row.
    

           setTimeout(function () {

             
               if (foclum == base || foclum == "Grade" || foclum == "Bracket") {
                
                   grade = toDecimal(CINSizeDetail1.batchEditApi.GetCellValue(index, "Grade"));
                   if (!grade)
                       grade = 0.00;
                  
                   mainbracket = CINSizeDetail1.batchEditApi.GetCellValue(index, "Bracket");
                   basevalue = CINSizeDetail1.batchEditApi.GetCellValue(index, base);
                   // Increment Part
                   basevalue = toDecimal(basevalue);
                   basevalue = parseFloat(basevalue);
                   basevalue += parseFloat(grade);
                   basevalue = new Fraction(basevalue);

                   for (var j = 8; j < CINSizeDetail1.GetColumnsCount() ; j++) {
                       var column = CINSizeDetail1.GetColumn(j);
                       if (column.fieldName > base) {
                          

                               
                           if (column.fieldName != "Instruction" && column.fieldName != "LineNumberMeasurementChart") {
                               CINSizeDetail1.batchEditApi.SetCellValue(index, column.fieldName, basevalue); // WORKING
                               bracketcounter++;
                               if (bracketcounter == mainbracket) {
                                   bracketcounter = 0;
                                   basevalue = toDecimal(basevalue);
                                   basevalue = parseFloat(basevalue);
                                   basevalue += parseFloat(grade);
                                   basevalue = new Fraction(basevalue);
                               }
                           }
                           else
                               continue;

                       }
                   }

                   // Decrement Part
                   // reset bracket / index / basevalue 
                   bracketcounter = mainbracket;
                   indexbackward = CINSizeDetail1.GetColumnByField(base).index;
                   basevalue = CINSizeDetail1.batchEditApi.GetCellValue(index, base);
                   console.log(indexbackward);
                   for (var g = indexbackward; g > 6 ; g--) {
                       var column = CINSizeDetail1.GetColumn(g);
                       if (column.fieldName <= base) {
                         
                           if (column.fieldName != "Instruction" && column.fieldName != "LineNumberMeasurementChart") {
                               CINSizeDetail1.batchEditApi.SetCellValue(index, column.fieldName, basevalue); // WORKING
                               bracketcounter--;
                               if (bracketcounter == 0) {
                                   bracketcounter = mainbracket;
                                   basevalue = toDecimal(basevalue);
                                   basevalue -= grade;
                                   basevalue = new Fraction(basevalue);
                               }
                           }
                       } // END OF for (var g = indexbackward; g > 6 ; g--)
                   }
               }
           }, 500);
       }
       //function computesizesvalue(s, e) {

       //    var tolerance = 0.00;
       //    var grade = 0.00;
       //    var base = CINBaseSize.GetValue();
       //    var value = 0.00;
       //    var tot = 0.00;
       //    var mainbracket = 0;
       //    var indexbackward = 0;
       //    var basevalue = 0.00;
       //    setTimeout(function () { //New Rows
       //        var indicies = CINSizeDetail1.batchEditApi.GetRowVisibleIndices();
       //        //value = CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], CINSizeDetail1.GetColumnByField(base).index)
       //        console.log(index);
       //        if(foclum == base)
       //        {
       //            for (var i = 0; i < indicies.length; i++) {
       //                var bracketcounter = 0;    // Reset Bracket Counter Every Row.
       //                if (CINSizeDetail1.batchEditApi.IsNewRow(indicies[i])) {
       //                    grade = CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], "Grade");
       //                    mainbracket = CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], "Bracket");
       //                    basevalue = CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], base);


       //                    basevalue += grade;
       //                    for (var j = 8; j < CINSizeDetail1.GetColumnsCount() ; j++) {
       //                        var column = CINSizeDetail1.GetColumn(j);
       //                        ///stringcolumn = "" + column.fieldName;
       //                        if (column.fieldName > base) {
       //                            CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, basevalue); // WORKING
       //                            bracketcounter++;
       //                            if (bracketcounter == mainbracket) {
       //                                bracketcounter = 0;
       //                                basevalue += grade;
       //                            }
       //                        }
       //                    }

       //                    // reset bracket / index / basevalue 
       //                    bracketcounter = mainbracket;
       //                    indexbackward = CINSizeDetail1.GetColumnByField(base).index;
       //                    basevalue = CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], base);
       //                    for (var g = indexbackward; g > 6 ; g--) {
       //                        var column = CINSizeDetail1.GetColumn(g);
       //                        if (column.fieldName <= base) {
       //                            CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, basevalue); // WORKING
       //                            bracketcounter--;
       //                            if (bracketcounter == 0) {
       //                                bracketcounter = mainbracket;
       //                                basevalue -= grade;
       //                            }
       //                        }
       //                    }

       //                } //END OF IsNewRow indicies


       //                else { //Existing Rows
       //                    var key = CINSizeDetail1.GetRowKey(indicies[i]);
       //                    if (CINSizeDetail1.batchEditApi.IsDeletedRow(key))
       //                        console.log("deleted row " + indicies[i]);
       //                    else {

       //                        if (i == index) {
       //                            grade = CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], "Grade");
       //                            mainbracket = CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], "Bracket");
       //                            basevalue = parseFloat(CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], base));

       //                            basevalue += parseFloat(grade);
       //                            for (var j = 8; j < CINSizeDetail1.GetColumnsCount() ; j++) {
       //                                var column = CINSizeDetail1.GetColumn(j);
       //                                ///stringcolumn = "" + column.fieldName;
       //                                if (column.fieldName > base) {
       //                                    CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, basevalue); // WORKING
       //                                    bracketcounter++;
       //                                    if (bracketcounter == mainbracket) {
       //                                        bracketcounter = 0;
       //                                        basevalue += parseFloat(grade);
       //                                    }
       //                                }
       //                            }
       //                            //break;
       //                            // reset bracket / index / basevalue 
       //                            bracketcounter = mainbracket;
       //                            indexbackward = CINSizeDetail1.GetColumnByField(base).index;
       //                            basevalue = CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], base);

       //                            for (var g = indexbackward; g > 6 ; g--) {
       //                                var column = CINSizeDetail1.GetColumn(g);
       //                                if (column.fieldName <= base) {
       //                                    CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, basevalue); // WORKING
       //                                    bracketcounter--;
       //                                    if (bracketcounter == 0) {
       //                                        bracketcounter = mainbracket;
       //                                        basevalue -= grade;
       //                                    }
       //                                }
       //                            }
       //                        } // END OF IF(i == index)
       //                    }
       //                } // END OF ELSE EXISTING ROWS
       //            } //END OF FOR LOOP (indicies)
       //        }
       //    }, 500);
       //}

       function toDecimal(inputString) {
           var ToConvert = String(inputString);
           var depth;

           if (ToConvert.indexOf("/") > -1) {
               if (ToConvert.indexOf(" ") > -1) {
                   var whole = ToConvert.slice(0, ToConvert.indexOf(" "));
                   var fract = ToConvert.slice(ToConvert.indexOf(" ") + 1, ToConvert.length);

                   var num = fract.slice(0, fract.indexOf("/"));
                   var den = fract.slice(fract.indexOf("/") + 1, fract.length);
                   depth = parseInt(whole) + num / den;
               }
               else {
                   var num = ToConvert.slice(0, ToConvert.indexOf("/"));
                   var den = ToConvert.slice(ToConvert.indexOf("/") + 1, ToConvert.length);
                   depth = num / den;
               }
           }
           else {
               depth = ToConvert;
           }
           return depth;
       }







       function resetsizesvalue(s, e) {

           var tolerance = 0.00;
           var grade = 0.00;
           var base = CINBaseSize.GetValue();
           var value = 0.00;
           var tot = 0.00;
           var mainbracket = 0;
           var indexbackward = 0;
           var basevalue = 0.00;
           setTimeout(function () { //New Rows
               var indicies = CINSizeDetail1.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < indicies.length; i++) {
                   var bracketcounter = 0;    // Reset Bracket Counter Every Row.
                   if (CINSizeDetail1.batchEditApi.IsNewRow(indicies[i])) {


                       for (var j = 8; j < CINSizeDetail1.GetColumnsCount() ; j++) {
                           var column = CINSizeDetail1.GetColumn(j);
                           ///stringcolumn = "" + column.fieldName;
                           if (column.fieldName > base) {
                               if (column.fieldName != "Instruction" && column.fieldName != "LineNumberMeasurementChart") {
                                   CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, null); // WORKING
                                   bracketcounter++;
                                   if (bracketcounter == mainbracket) {
                                       bracketcounter = 0;
                                       basevalue += grade;
                                   }
                               }
                           }
                       }

                       bracketcounter = mainbracket;
                       indexbackward = CINSizeDetail1.GetColumnByField(base).index;
                       for (var g = indexbackward; g > 6 ; g--) {
                           var column = CINSizeDetail1.GetColumn(g);
                           if (column.fieldName <= base) {
                               CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, null); // WORKING
                               bracketcounter--;
                               if (bracketcounter == 0) {
                                   bracketcounter = mainbracket;
                                   basevalue -= grade;
                               }
                           }
                       }
                   } //END OF IsNewRow indicies


                   else { //Existing Rows
                       var key = CINSizeDetail1.GetRowKey(indicies[i]);
                       if (CINSizeDetail1.batchEditApi.IsDeletedRow(key))
                           console.log("deleted row " + indicies[i]);
                       else {

                           for (var j = 8; j < CINSizeDetail1.GetColumnsCount() ; j++) {
                               var column = CINSizeDetail1.GetColumn(j);
                               if (column.fieldName > base) {
                                   if (column.fieldName != "Instruction" && column.fieldName != "LineNumberMeasurementChart") {
                                       CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, null); // WORKING
                                       bracketcounter++;
                                       if (bracketcounter == mainbracket) {
                                           bracketcounter = 0;
                                           basevalue += parseFloat(grade);
                                       }
                                   }
                               }
                           }

                           // reset bracket / index / basevalue 
                           bracketcounter = mainbracket;
                           indexbackward = CINSizeDetail1.GetColumnByField(base).index;
                           for (var g = indexbackward; g > 6 ; g--) {
                               var column = CINSizeDetail1.GetColumn(g);
                               if (column.fieldName <= base) {
                                   CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, null); // WORKING
                                   bracketcounter--;
                                   if (bracketcounter == 0) {
                                       bracketcounter = mainbracket;
                                       basevalue -= grade;
                                   }
                               }
                           }
                       }
                   } // END OF ELSE EXISTING ROWS
               } //END OF FOR LOOP (indicies)
           }, 500);
       }

       function computeTotalItemCost1(s, e) {

           var additionaloverhead = CINAdditionalOverhead.GetValue();
           var perpiececonsumption = 0.00;
           var estimatedunitcost = 0.00;
           var estimatedcost = 0.00;
           var totalestimatedcost = 0.00;


           var price = 0.00;
           var totalprice = 0.00;

           var totalitemcost = 0.00;

           setTimeout(function () { //New Rows
               //// -- -- -- -- -- STYLE -- -- -- -- -- ////
               var Styleindicies = CINgvStyleDetail.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < Styleindicies.length; i++) {
                   if (CINgvStyleDetail.batchEditApi.IsNewRow(Styleindicies[i])) {
                       perpiececonsumption = CINgvStyleDetail.batchEditApi.GetCellValue(Styleindicies[i], "PerPieceConsumption");
                       estimatedunitcost = CINgvStyleDetail.batchEditApi.GetCellValue(Styleindicies[i], "EstimatedUnitCost");

                       if (!perpiececonsumption)
                           perpiececonsumption = 0;
                       if (!estimatedunitcost)
                           estimatedunitcost = 0;

                       estimatedcost = perpiececonsumption * estimatedunitcost;
                       totalestimatedcost += estimatedcost;

                       CINgvStyleDetail.batchEditApi.SetCellValue(Styleindicies[i], "EstimatedCost", estimatedcost.toFixed(2));
                   } //END OF IsNewRow indicies
                   else { //Existing Rows
                       var key = CINgvStyleDetail.GetRowKey(Styleindicies[i]);
                       if (CINgvStyleDetail.batchEditApi.IsDeletedRow(key))
                           console.log("deleted row " + Styleindicies[i]);
                       else {
                           perpiececonsumption = CINgvStyleDetail.batchEditApi.GetCellValue(Styleindicies[i], "PerPieceConsumption");
                           estimatedunitcost = CINgvStyleDetail.batchEditApi.GetCellValue(Styleindicies[i], "EstimatedUnitCost");

                           if (!perpiececonsumption)
                               perpiececonsumption = 0;
                           if (!estimatedunitcost)
                               estimatedunitcost = 0;

                           estimatedcost = perpiececonsumption * estimatedunitcost;
                           totalestimatedcost += estimatedcost;

                           CINgvStyleDetail.batchEditApi.SetCellValue(Styleindicies[i], "EstimatedCost", estimatedcost.toFixed(2));
                       }
                   } // END OF ELSE EXISTING ROWS
               } //END OF FOR LOOP (indicies)
               //// -- -- -- -- -- END OF STYLE -- -- -- -- -- ////
               //// -- -- -- -- -- STEPS -- -- -- -- -- ////
               var Stepindicies = CINgvStepDetail.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < Stepindicies.length; i++) {
                   if (CINgvStepDetail.batchEditApi.IsNewRow(Stepindicies[i])) {

                       price = CINgvStepDetail.batchEditApi.GetCellValue(Stepindicies[i], "EstimatedPrice");
                       totalprice += price;
                   } //END OF IsNewRow indicies
                   else { //Existing Rows
                       var key = CINgvStepDetail.GetRowKey(Stepindicies[i]);
                       if (CINgvStepDetail.batchEditApi.IsDeletedRow(key))
                           console.log("deleted row " + Stepindicies[i]);
                       else {
                           price = CINgvStepDetail.batchEditApi.GetCellValue(Stepindicies[i], "EstimatedPrice");

                           totalprice += price;
                       }
                   } // END OF ELSE EXISTING ROWS
               } //END OF FOR LOOP (indicies)
               //// -- -- -- -- -- END OF STEPS -- -- -- -- -- ////


               totalitemcost = totalprice + totalestimatedcost + additionaloverhead;
               CINTotalItemCost.SetValue(totalitemcost.toFixed(2));


               computeSellingPrice();
           }, 500);

       }


       function computeTotalItemCost(s, e) {

           var additionaloverhead = CINAdditionalOverhead.GetValue();
           var perpiececonsumption = 0.00;
           var estimatedunitcost = 0.00;
           var estimatedcost = 0.00;
           var totalestimatedcost = 0.00;


           var price = 0.00;
           var totalprice = 0.00;

           var totalitemcost = 0.00;


           var workorderprice = 0.00;
           var EstUnit = 0.00;
           var TotalCost = 0;
           var TotalCost1 = 0;
           var ItemCode = [];
           var ColorCode = [];
           var Cost1 = [];
           var Count = [];

           setTimeout(function () { //New Rows


               var Styleindicies = CINgvStyleDetail.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < Styleindicies.length; i++) {
                   if (CINgvStyleDetail.batchEditApi.IsNewRow(Styleindicies[i])) {
                       perpiececonsumption = CINgvStyleDetail.batchEditApi.GetCellValue(Styleindicies[i], "PerPieceConsumption");
                       estimatedunitcost = CINgvStyleDetail.batchEditApi.GetCellValue(Styleindicies[i], "EstimatedUnitCost");

                       if (!perpiececonsumption)
                           perpiececonsumption = 0;
                       if (!estimatedunitcost)
                           estimatedunitcost = 0;

                       estimatedcost = perpiececonsumption * estimatedunitcost;
                       totalestimatedcost += estimatedcost;

                       CINgvStyleDetail.batchEditApi.SetCellValue(Styleindicies[i], "EstimatedCost", estimatedcost.toFixed(2));
                   } //END OF IsNewRow indicies
                   else { //Existing Rows
                       var key = CINgvStyleDetail.GetRowKey(Styleindicies[i]);
                       if (CINgvStyleDetail.batchEditApi.IsDeletedRow(key))
                           console.log("deleted row " + Styleindicies[i]);
                       else {
                           perpiececonsumption = CINgvStyleDetail.batchEditApi.GetCellValue(Styleindicies[i], "PerPieceConsumption");
                           estimatedunitcost = CINgvStyleDetail.batchEditApi.GetCellValue(Styleindicies[i], "EstimatedUnitCost");

                           if (!perpiececonsumption)
                               perpiececonsumption = 0;
                           if (!estimatedunitcost)
                               estimatedunitcost = 0;

                           estimatedcost = perpiececonsumption * estimatedunitcost;
                           totalestimatedcost += estimatedcost;

                           CINgvStyleDetail.batchEditApi.SetCellValue(Styleindicies[i], "EstimatedCost", estimatedcost.toFixed(2));
                       }
                   } // END OF ELSE EXISTING ROWS
               }


               var indicies = CINgvStyleDetail.batchEditApi.GetRowVisibleIndices();

               for (var i = 0; i < indicies.length; i++) {
                   if (CINgvStyleDetail.batchEditApi.IsNewRow(indicies[i])) {

                       var pasok = false;
                       var count = 0;
                       item = CINgvStyleDetail.batchEditApi.GetCellValue(indicies[i], "ItemCode");
                       color = CINgvStyleDetail.batchEditApi.GetCellValue(indicies[i], "ColorCode");

                       cost = parseFloat(CINgvStyleDetail.batchEditApi.GetCellValue(indicies[i], "EstimatedCost"));

                       if (ItemCode.length == 0) {
                           var temptotalcost = cost;
                           ItemCode.push(item);
                           ColorCode.push(color);
                           Cost1.push(temptotalcost);
                           Count.push(1);
                           pasok = true;
                       }
                       else {

                           for (var y = 0; y < ItemCode.length; y++) {
                               if (ItemCode[y] == item) {

                                   if (ColorCode[y] == color) {
                                       var temptotalcost = cost;
                                       Cost1[y] += parseFloat(temptotalcost);
                                       Count[y] += 1;
                                       TotalCost1 = Cost1[y] / Count[y]
                                       Cost1[y] = 0;
                                       pasok = true;
                                   }
                               }
                           }
                       }


                       if (pasok == false) {
                           var temptotalcost = cost;
                           ItemCode.push(item);
                           ColorCode.push(color);
                           Cost1.push(temptotalcost);
                           Count.push(1);
                       }




                   }
                   else { //Existing Rows
                       var key = CINgvStyleDetail.GetRowKey(indicies[i]);
                       if (CINgvStyleDetail.batchEditApi.IsDeletedRow(key)) {

                           //gv1.batchEditHelper.EndEdit();
                       }
                       else {

                           var pasok = false;
                           var count = 0;
                           item = CINgvStyleDetail.batchEditApi.GetCellValue(indicies[i], "ItemCode");
                           color = CINgvStyleDetail.batchEditApi.GetCellValue(indicies[i], "ColorCode");
                           //qty = CINgvStyleDetail.batchEditApi.GetCellValue(indicies[i], "PerPieceConsumption");
                           cost = parseFloat(CINgvStyleDetail.batchEditApi.GetCellValue(indicies[i], "EstimatedCost"));

                           if (ItemCode.length == 0) {
                               var temptotalcost = cost;
                               ItemCode.push(item);
                               ColorCode.push(color);
                               Cost1.push(temptotalcost);
                               Count.push(1);

                               pasok = true;
                           }
                           else {

                               for (var y = 0; y < ItemCode.length; y++) {
                                   if (ItemCode[y] == item) {
                                       if (ColorCode[y] == color) {
                                           var temptotalcost = cost;

                                           Cost1[y] += parseFloat(temptotalcost);
                                           Count[y] += 1;
                                           TotalCost1 = Cost1[y] / Count[y]
                                           Cost1[y] = 0;
                                           pasok = true;
                                       }
                                   }
                               }


                           }


                           if (pasok == false) {
                               var temptotalcost = cost;
                               ItemCode.push(item);
                               ColorCode.push(color);
                               Cost1.push(temptotalcost);
                               Count.push(1);
                           }
                       }
                   }
               }


               for (var i = 0; i < ItemCode.length; i++) {
                   TotalCost += Cost1[i];
               }

               CINTotalItemCost.SetValue((TotalCost + TotalCost1).toFixed(2));
               computeSellingPrice();
           }, 500);

       }


       function computeSellingPrice(s, e) {
           var totalitemcost = CINTotalItemCost.GetValue();
           var markup = CINMarkUp.GetValue() / 100;
           //var additionaloverhead = CINAdditionalOverhead.GetValue(); -- 08|01|2016   Remove na daw sabi ni ate nes.
           var sellingprice = 0.00;
           //sellingprice = (((totalitemcost * markup) + totalitemcost) + additionaloverhead);  -- 08|01|2016   Remove na daw yung overhead sabi ni ate nes.
           sellingprice = ((totalitemcost * markup) + totalitemcost);

           CINSellingPrice.SetValue(sellingprice);

           computeProfit();

       }

       function computeProfit(s, e) {
           var srp = CINSRP.GetValue();
           var sellingprice = CINSellingPrice.GetValue();

           var profit = 0.00;

           if (sellingprice < 1)
               profit = 0.00;
           else
               profit = srp / sellingprice;

           CINProfitFactor.SetValue(profit);

       }

       function computeSRP(s, e) {
           var profit = CINProfitFactor.GetValue();
           var sellingprice = CINSellingPrice.GetValue();
           var srp = 0.00;

           srp = sellingprice * profit;

           CINSRP.SetValue(srp);
       }

       function computePlusOverhead(s, e) {
           var totalitemcost = CINTotalItemCost.GetValue();
           var additionaloverhead = CINAdditionalOverhead.GetValue();

           var newtotalitemcost = 0.00;

           newtotalitemcost = totalitemcost + additionaloverhead;

           CINTotalItemCost.SetValue(newtotalitemcost);


           computeSellingPrice();
       }

       function OnInitTrans(s, e) {
           AdjustSize();
           CINErrorConfirm.Hide();
           UpdatePISNumber();
       }

       function OnControlsInitialized(s, e) {
           ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
               AdjustSize();
           });
       }

       function AdjustSize() {
           var width = Math.max(0, document.documentElement.clientWidth);
           //document.getElementById("badtrip").click();
           //gvJournal.SetWidth(width - 100);
           gvRef.SetWidth(width - 120);


           CINSizeDetail1.SetWidth(width - 120);
           CINgvStyleDetail.SetWidth(width - 120);
           CINgvStepDetail.SetWidth(width - 120);
           CINgvGradeBracket.SetWidth(width - 120);
           //CINgvEmbroiderDetail.SetWidth(width - 120);
       }



       function computeshrinkage(s, e) {
           //console.log(CINActualShrinkageWeft.GetValue() + "  Actual Shrinkage Weft")
           //console.log(CINActualShrinkageWarp.GetValue() + "  Actual Shrinkage Warp")


           //console.log(Math.sqrt((CINActualShrinkageWarp.GetValue() * CINActualShrinkageWarp.GetValue()) + (CINActualShrinkageWeft.GetValue() * CINActualShrinkageWeft.GetValue())))
           CINCombineShrinkage.SetValue(Math.sqrt((CINActualShrinkageWarp.GetValue() * CINActualShrinkageWarp.GetValue()) + (CINActualShrinkageWeft.GetValue() * CINActualShrinkageWeft.GetValue())).toFixed(2));
       }

       function HideError(s, e) {
           CINErrorConfirm.Hide();
       }

       function setTK(s, e) {
           var TKText = CINTicket.GetText();
           var NoTKText = TKText.replace("TK-", "");
           var SetTKText = "TK-".concat(NoTKText);

           CINTicket.SetText(SetTKText);
       }

       function functiontrylang() {
           //function(s,e){ CINCustomerCode.GetGridView().GetRowValues(CINCustomerCode.GetFocusedRowIndex(), 'BizPartnerCode', OnGetRowValues); }
           //var grid = CINCustomerCode.GetGridView();
           //console.log(grid.GetRowValues(grid.GetFocusedRowIndex(), 'BizPartnerCode', OnGetRowValues));
           //grid.GetRowValues(grid.GetFocusedRowIndex(), 'BizPartnerCode', OnGetRowValues);
           //CINCustomerCode.GetGridView().GetSelectedFieldValues('BizPartnerCode;Name', OnGetSelectedFieldValues);
           //var grid = CINCustomerCode.GetGridView();
           //console.log(CINCustomerCode.GetFocusedRowIndex() + ' grid.GetFocusedRowIndex()')
           //CINCustomerCode.GetGridView().GetSelectedFieldValues('BizPartnerCode;Name', OnGetSelectedFieldValues);

           //g.GetRowKey(g.GetFocusedRowIndex()
           //console.log(CINCustomerCode.GetGridView().GetRowKey(CINCustomerCode.GetFocusedRowIndex()));

           //var g = glDIS.GetGridView();
           //cp.PerformCallback('DIS|' + g.GetRowKey(g.GetFocusedRowIndex()));


           //var g = CINCustomerCode.GetGridView();
           //console.log(g + ' g');
           //console.log(g.GetRowKey(g.GetFocusedRowIndex()));

           //var g = CINCustomerCode.GetGridView();
           //console.log(g.GetRowKey(g.GetFocusedRowIndex()));
           //console.log(CINCustomerCode.GetGridView().GetRowKey() + ' CINCustomerCode.GetRowKey');
           //console.log(CINCustomerCode.GetGridView().GetFocusedRowIndex() + ' CINCustomerCode.GetFocusedRowIndex()')

           CINStepCodestyle.GetGridView().GetSelectedFieldValues('StepCode', OnGetSelectedFieldValues);
       }


       //function OnGetRowValues(values) {
       //    console.log(values + ' values')
       //}
       function OnGetSelectedFieldValues(selectedValues) {
           console.log(selectedValues + 'selectedValues');

       }

       function OnGetRowValues(Value) {
           alert(Value);
       }

       function UpdatePISNumber(s, e) {
           var entry = getParameterByName('entry');
           if (entry == "N") {
               var PISNumber = "16************";
               var dateNow = new Date();
               var yearNow = dateNow.getFullYear();
               var yearLast = String(yearNow).substr(-2);

               var gender = CINGender.GetValue();
               if (!gender)
                   gender = "*";

               var productCatCode = CINProductCategory.GetValue();
               if (!productCatCode)
                   productCatCode = "*";

               var productGroup = CINProductGroup.GetValue();
               if (!productGroup)
                   productGroup = "*";

               var productSubCategory = CINProductSubCategory.GetValue();
               if (!productSubCategory)
                   productSubCategory = "*";

               var fobSupplier = CINFOBSupplier.GetValue();
               if (!fobSupplier)
                   fobSupplier = "**";

               PISNumber = yearLast + "" + gender + "" + productCatCode + "" + productGroup + "" + productSubCategory + "*****" + fobSupplier;
               console.log(PISNumber + ' PISNumberxx');
               CINPISNumber.SetText(PISNumber);
               //CINPISNumber.SetValue(PISNumber);
           }
       }
       //#region For future reference JS 

       //Debugging purposes
       //function start(s, e) {
       //    pass = fieldValue;
       //    console.log("start callback " + pass);
       //}

       //function end(s, e) {
       //    console.log("end callback");
       //}
       //function rowclick(s, e) {
       //    s.GetRowValues(e.visibleIndex, 'ItemCode;ColorCode;ClassCode;SizeCode', function (data) {
       //        console.log(data[0], data[1], data[2], data[3]);
       //        //splitter.GetPaneByName("Factbox").SetContentUrl('../FactBox/fbBizPartner.aspx?itemcode=' + data[0]
       //        //+ '&colorcode='+data[1]+'&classcode='+data[2]+'&sizecode='+data[3]);
       //        factbox.SetContentUrl('../FactBox/fbBizPartner.aspx?itemcode=' + data[0]
       //        + '&colorcode=' + data[1] + '&classcode=' + data[2] + '&sizecode=' + data[3]);
       //    });
       //}

       //function getParameterByName(name) {
       //    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
       //    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
       //        results = regex.exec(location.search);
       //    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
       //}

       //function OnControlInitialized(event) {
       //    var entry = getParameterByName('entry');
       //    if (entry == "N") {
       //        splitter.GetPaneByName("Factbox").SetContentUrl('../FactBox/fbBizPartner.aspx');
       //        //splitter.GetPaneByName("Factbox2").SetContentUrl('../FactBox/fbBizPartner.aspx');
       //        //splitter.GetPaneByName("Factbox3").SetContentUrl('../FactBox/fbBizPartner.aspx');
       //        //splitter.GetPaneByName("Factbox4").SetContentUrl('../FactBox/fbBizPartner.aspx');
       //    }
       //}
       //#endregion
       function gridLookup_KeyDownThread(s, e) {
           isSetTextRequired = false;
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode !== 9) return;
           if (tab) {
               canceledit = true;
           }
           else {
               var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
               if (CINgvThreadDetail.batchEditApi[moveActionName]()) {
                   ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);

               }
           }
       }

       function gridLookup_KeyPressThread(s, e) { //Prevents grid refresh when a user press enter key for every column
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode == 13)
               CINgvThreadDetail.batchEditApi.EndEdit();
           //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
       }


       function gridLookup_KeyDownEmbro(s, e, tab) {
           isSetTextRequired = false;
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode !== 9) return;
           if (tab) {
               canceledit = true;
           }
           else {
               var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
               if (CINgvEmbroiderDetail.batchEditApi[moveActionName]()) {
                   ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);

               }
           }
       }

       function gridLookup_KeyPressEmbro(s, e) { //Prevents grid refresh when a user press enter key for every column
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode == 13)
               CINgvEmbroiderDetail.batchEditApi.EndEdit();
           //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
       }

       function gridLookup_KeyDownDynamic(s, e, tab) {
           isSetTextRequired = false;
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode !== 9) return;
           if (tab) {
               canceledit = true;
           }
           else {
               var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
               if (CINgvPrintDetail.batchEditApi[moveActionName]()) {
                   ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);

               }
           }
       }

       function gridLookup_KeyPressDynamic(s, e) { //Prevents grid refresh when a user press enter key for every column
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode == 13)
               CINgvPrintDetail.batchEditApi.EndEdit();
           //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
       }

       function gridLookup_KeyDownBOM(s, e, tab) {
           isSetTextRequired = false;
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode !== 9) return;
           if (tab) {
               canceledit = true;
           }
           else {
               var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
               if (CINgvStyleDetail.batchEditApi[moveActionName]()) {
                   ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);

               }
           }
       }

       function gridLookup_KeyPressBOM(s, e) { //Prevents grid refresh when a user press enter key for every column
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode == 13)
               CINgvStyleDetail.batchEditApi.EndEdit();
           //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
       }

       function gridLookup_KeyDownSTEPS(s, e, tab) {
           isSetTextRequired = false;
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode !== 9) return;
           if (tab) {
               canceledit = true;
           }
           else {
               var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
               if (CINgvStepDetail.batchEditApi[moveActionName]()) {
                   ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);

               }
           }
       }

       function gridLookup_KeyPressSTEPS(s, e) { //Prevebnts grid refresh when a user press enter key for every column
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode == 13)
               CINgvStepDetail.batchEditApi.EndEdit();
           //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
       }

       function loaderHide() {
           setInterval(function () { loader.Hide() }, 10000);
       }
       var timerHandle = -1;

       var goToNextRow = false;
       var currentEditRowIndex;


       function OnEndCallback(s, e) {
           GoToNextRow()
       }


       function OnEndCallback(s, e) {
           GoToNextRow()
       }

       function GoToNextRow() {
           if (goToNextRow) {
               goToNextRow = false;
               CINgvStyleDetail.batchEditApi.StartEdit(++currentEditRowIndex, 2);
               CINgvStyleDetail.GetEditor('PerPieceConsumption').Focus();
           }
       }

       function KeyDownEventHandler(s, e) {
           if (e.htmlEvent.keyCode == 13)
               goToNextRow = true;
           CINgvStyleDetail.UpdateEdit();
           GoToNextRow();
       }
       var transtype = getParameterByName('transtype');
       function onload() {
           fbnotes.SetContentUrl('../FactBox/fbNotes.aspx?docnumber=' + CINPISNumber.GetText() + '&transtype=' + transtype);
       }













       //STARTTTTTTTTTTTTT OF PIS FIT PROJECT

       var Nanprocessor = function (entry) {
           if (isNaN(entry) == true) {
               return 0;
           } else {
               return entry;
           }
       }

       var Nanprocessor1 = function (entry) {
           if (isNaN(entry) == true || entry == 0 || entry == "" || entry == null) {
               return 1;
           } else {
               return entry;
           }
       }

       Array.prototype.contains = function (obj) {
           var i = this.length;
           while (i--) {
               if (this[i] == obj) {
                   return true;
               }
           }
           return false;
       }

       function validationMeasurementChart() {
           CINSizeDetail1.batchEditApi.EndEdit();
           for (var j = POMfocusindex; j < CINSizeDetail1.GetColumnsCount() ; j++) {
               var column = CINSizeDetail1.GetColumn(j);
               if (column.fieldName != "PointofMeasurement" && column.fieldName != "Instruction") {
                   var getval = CINSizeDetail1.batchEditApi.GetCellValue(index, column.fieldName) + "";
                   if (toDecimal(getval) < 0) {
                       alert("Grade must be an integer greater than zero!");
                       CINSizeDetail1.batchEditApi.SetCellValue(index, column.fieldName, "");
                   }
                   if (getval.indexOf('.') >= 0) {
                       alert("Please encode a valid fraction");
                       CINSizeDetail1.batchEditApi.SetCellValue(index, column.fieldName, "");
                   }
               }
               else {
                   break;
               }
           }

           for (var h = POMfocusindex; h > 6 ; h--) {
               counterskip = 0;
               var column = CINSizeDetail1.GetColumn(h);
               if (column.fieldName != "PointofMeasurement" && column.fieldName != "Instruction") {
                   var getval = CINSizeDetail1.batchEditApi.GetCellValue(index, column.fieldName) + "";
                   if (toDecimal(getval) < 0) {
                       alert("Grade must be an integer greater than zero!");
                       CINSizeDetail1.batchEditApi.SetCellValue(index, column.fieldName, "");
                   }
                   if (getval.indexOf('.') >= 0) {
                       alert("Please encode a valid fraction");
                       CINSizeDetail1.batchEditApi.SetCellValue(index, column.fieldName, "");
                   }
               }
               else {
                   break;
               }
           }
       }

       function validationGradeBracket() {
           CINgvGradeBracket.batchEditApi.EndEdit();
           var counterrmgs = 0;
           var getval = CINgvGradeBracket.batchEditApi.GetCellValue(index, "Grade") + "";
           if (toDecimal(getval) < 0) {
               alert("Grade must be an integer greater than zero!");
               CINgvGradeBracket.batchEditApi.SetCellValue(index, "Grade", 0);
               counterrmgs++;
           }
           if (getval.indexOf('.') >= 0) {
               alert("Please encode a valid fraction");
               CINgvGradeBracket.batchEditApi.SetCellValue(index, "Grade", 0);
               counterrmgs++;
           }

           getval = CINgvGradeBracket.batchEditApi.GetCellValue(index, "Bracket") + "";
           if (toDecimal(getval) < 0) {
               alert("Bracket must be an integer greater than zero!");
               CINgvGradeBracket.batchEditApi.SetCellValue(index, "Bracket", 1);
               counterrmgs++;
           }
           if (getval.indexOf('.') >= 0) {
               alert("Please encode a valid fraction");
               CINgvGradeBracket.batchEditApi.SetCellValue(index, "Bracket", 1);
               counterrmgs++;
           }

           getval = CINgvGradeBracket.batchEditApi.GetCellValue(index, "Tolerance") + "";
           if (toDecimal(getval) < 0) {
               alert("Tolerance must be an integer greater than zero!");
               CINgvGradeBracket.batchEditApi.SetCellValue(index, "Tolerance", 0);
               counterrmgs++;
           }
           if (getval.indexOf('.') >= 0) {
               alert("Please encode a valid fraction");
               CINgvGradeBracket.batchEditApi.SetCellValue(index, "Tolerance", 0);
               counterrmgs++;
           }
           autoToleranceNew();
       }

       var allgrade = "";
       var newgrade = "";
       function autoToleranceNew(s, e) {
           var tolerance = 0.00;
           var grade;
           newgrade = "";
           allgrade = "";

           setTimeout(function () {

               var indicies = CINgvGradeBracket.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < indicies.length; i++) {
                   var key = CINgvGradeBracket.GetRowKey(indicies[i]);
                   if (!CINgvGradeBracket.batchEditApi.IsDeletedRow(key)) {
                       grade = CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Grade");
                       tolerance = toDecimal(grade) / 2;
                       var pia = new Fraction(tolerance);
                       CINgvGradeBracket.batchEditApi.SetCellValue(indicies[i], "Tolerance", pia);

                       //Ter Codes
                       if (pomcode == CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "POMCode")) {
                           if (CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Size") != null && CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Size") != 'undefined') {
                               if (CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Size").includes(",")) {
                                   allgrade = newgrade + CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Size").split(/,/).join("+" + CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Grade") + "+" + CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Bracket") + "+" + indicies[i] + ",");
                                   newgrade = allgrade + "+" + (CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Grade") + "+" + CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Bracket") + "+" + indicies[i] + ",");
                               }
                               else {
                                   newgrade += CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Size") + "+" + (CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Grade") + "+" + CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Bracket") + "+" + indicies[i] + ",");
                               }
                           }
                       }
                   }
               }
           }, 500);
           computesizesvalueGradeBracket();
       }

       function autoTolerance(s, e) {
           CINSizeDetail1.batchEditApi.EndEdit();
           var tolerance = 0.00;
           var grade;
           newgrade = "";
           allgrade = "";

           setTimeout(function () {
               var indicies = CINgvGradeBracket.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < indicies.length; i++) {
                   var key = CINgvGradeBracket.GetRowKey(indicies[i]);
                   if (!CINgvGradeBracket.batchEditApi.IsDeletedRow(key)) {

                       //Ter Codes
                       if (pomcodeNew == CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "POMCode")) {
                           if (CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Size") != null && CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Size") != 'undefined') {
                               if (CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Size").includes(",")) {
                                   allgrade = newgrade + CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Size").split(/,/).join("+" + CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Grade") + "+" + CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Bracket") + "+" + indicies[i] + ",");
                                   newgrade = allgrade + "+" + (CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Grade") + "+" + CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Bracket") + "+" + indicies[i] + ",");
                               }
                               else {
                                   newgrade += CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Size") + "+" + (CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Grade") + "+" + CINgvGradeBracket.batchEditApi.GetCellValue(indicies[i], "Bracket") + "+" + indicies[i] + ",");
                               }
                           }
                       }
                   }
               }
           }, 500);
           computesizesvalue();
       }

       function computesizesvalueGradeBracket(s, e) {
           var grade = 0.00;
           var base = CINBaseSize.GetValue();
           var indexbackward = 0;
           var basevalue = 0.00;

           var bracketcntr = 0;
           var currbracket = 1;
           var linenumberr = "xxx";
           var currlinenumber = "xxx";

           setTimeout(function () {
               var indicies = CINSizeDetail1.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < indicies.length; i++) {
                   var bv = CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], base)
                   var key = CINSizeDetail1.GetRowKey(indicies[i]);
                   var finish = false;


                   if (!CINSizeDetail1.batchEditApi.IsDeletedRow(key)) {
                       if (pomcode == CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], "Code")) {
                           linenumberr = "xxx";
                           currlinenumber = "xxx";
                           basevalue = bv;
                           bracketcntr = 0;
                           currbracket = 1;
                           var counterskip = 0;
                           for (var j = POMfocusindex; j < CINSizeDetail1.GetColumnsCount() ; j++) {
                               counterskip = 0;
                               var column = CINSizeDetail1.GetColumn(j);
                               if (column.fieldName != "PointofMeasurement" && column.fieldName != "Instruction") {

                                   //lagay ng tamang grade
                                   var leonard = newgrade.split(",");

                                   for (var a = 0; a < leonard.length - 1; a++) {
                                       var angcaya = leonard[a].split("+", 4);
                                       if (column.fieldName == angcaya[0].trim()) {
                                           grade = angcaya[1];
                                           currbracket = Nanprocessor1(angcaya[2]);
                                           currlinenumber = angcaya[3];
                                           if (linenumberr == "xxx") {
                                               linenumberr = angcaya[3];
                                           };
                                           counterskip++;
                                       }
                                   }


                                   if (bracketcntr > currbracket) {
                                       bracketcntr = 1;
                                   }
                                   if (linenumberr != currlinenumber) {
                                       bracketcntr = 0;
                                   }

                                   if (column.fieldName != base) {
                                       if (finish == true && grade != 0) {
                                           basevalue = toDecimal(basevalue);
                                           basevalue = parseFloat(basevalue);
                                           basevalue += parseFloat(toDecimal(grade));
                                           basevalue = new Fraction(basevalue);
                                       }

                                       if (counterskip == 0) {
                                           if ((bracketcntr != currbracket && linenumberr == currlinenumber) || finish == true) {
                                               bracketcntr++;
                                           }
                                           else {
                                               basevalue = toDecimal(basevalue);
                                               basevalue = parseFloat(basevalue);
                                               basevalue += parseFloat(toDecimal(grade));
                                               basevalue = new Fraction(basevalue);
                                               bracketcntr++;
                                           }
                                           finish = false;

                                           linenumberr = currlinenumber;
                                           if (currbracket == 1) {
                                               bracketcntr = currbracket;
                                           }

                                           if (column.fieldName != base)
                                               CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, "");
                                       }
                                       else {
                                           if ((bracketcntr != currbracket && linenumberr == currlinenumber) || finish == true) {
                                               bracketcntr++;
                                           }
                                           else {
                                               bracketcntr++;
                                               basevalue = toDecimal(basevalue);
                                               basevalue = parseFloat(basevalue);
                                               basevalue += parseFloat(toDecimal(grade));
                                               basevalue = new Fraction(basevalue);
                                           }
                                           finish = false;
                                           linenumberr = currlinenumber;

                                           if (column.fieldName != base)
                                               CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, basevalue);
                                       }
                                   }
                                   else {
                                       finish = true;
                                   }
                               }
                               else {
                                   break;
                               }
                           }

                           linenumberr = "xxx";
                           currlinenumber = "xxx";
                           basevalue = bv;
                           bracketcntr = 0;
                           currbracket = 1;

                           indexbackward = CINSizeDetail1.GetColumnByField(base).index;
                           for (var h = POMfocusindex; h > 6 ; h--) {
                               counterskip = 0;
                               var column = CINSizeDetail1.GetColumn(h);
                               if (column.fieldName != "PointofMeasurement" && column.fieldName != "Instruction") {

                                   //lagay ng tamang grade
                                   var tv = newgrade.split(",");
                                   for (var t = 0; t < tv.length - 1; t++) {
                                       var la = tv[t].split("+", 4);
                                       if (column.fieldName == la[0].trim()) {
                                           grade = la[1];
                                           currbracket = Nanprocessor1(la[2]);
                                           currlinenumber = la[3];
                                           if (linenumberr == "xxx") {
                                               linenumberr = la[3];
                                           };
                                           counterskip++;
                                       }
                                   }

                                   if (bracketcntr > currbracket) {
                                       bracketcntr = 1;
                                   }
                                   if (linenumberr != currlinenumber) {
                                       bracketcntr = 0;
                                   }

                                   if (counterskip == 0) {
                                       if ((bracketcntr != currbracket && linenumberr == currlinenumber) || finish == true) {
                                           bracketcntr++;
                                       }
                                       else {
                                           basevalue = toDecimal(basevalue);
                                           basevalue = parseFloat(basevalue);
                                           basevalue -= parseFloat(toDecimal(grade));
                                           basevalue = new Fraction(basevalue);
                                           bracketcntr++;
                                       }
                                       finish = false;

                                       linenumberr = currlinenumber;
                                       if (currbracket == 1) {
                                           bracketcntr = currbracket;
                                       }

                                       if (column.fieldName != base)
                                           CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, "");
                                   }
                                   else {
                                       if ((bracketcntr != currbracket && linenumberr == currlinenumber) || finish == true) {
                                           bracketcntr++;
                                       }
                                       else {
                                           bracketcntr++;
                                           basevalue = toDecimal(basevalue);
                                           basevalue = parseFloat(basevalue);
                                           basevalue -= parseFloat(toDecimal(grade));
                                           basevalue = new Fraction(basevalue);
                                       }
                                       finish = false;
                                       linenumberr = currlinenumber;

                                       if (column.fieldName != base)
                                           CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, basevalue);
                                   }
                               }
                               else {
                                   break;
                               }
                           }
                       }
                   }
               }
           }, 500);
       }

       function computesizesvalue(s, e) {
           var grade = 0.00;
           var base = CINBaseSize.GetValue();
           var indexbackward = 0;
           var basevalue = 0.00;
           var bv = CINSizeDetail1.batchEditApi.GetCellValue(index, base);

           var bracketcntr = 0;
           var currbracket = 1;
           var linenumberr = "xxx";
           var currlinenumber = "xxx";

           var finish = false;
           setTimeout(function () {
               if (foclum == base) {

                   //loop for SizeDetail POSITIVE SIDE  
                   linenumberr = "xxx";
                   currlinenumber = "xxx";
                   basevalue = bv;
                   bracketcntr = 0;
                   currbracket = 1;
                   var counterskip = 0;

                   for (var j = POMfocusindex; j < CINSizeDetail1.GetColumnsCount() ; j++) {
                       counterskip = 0;
                       var column = CINSizeDetail1.GetColumn(j);
                       if (column.fieldName != "PointofMeasurement" && column.fieldName != "Instruction") {

                           //lagay ng tamang grade
                           var leonard = newgrade.split(",");

                           for (var a = 0; a < leonard.length - 1; a++) {
                               var angcaya = leonard[a].split("+", 4);
                               if (column.fieldName == angcaya[0].trim()) {
                                   grade = angcaya[1];
                                   currbracket = Nanprocessor1(angcaya[2]);
                                   currlinenumber = angcaya[3];
                                   if (linenumberr == "xxx") {
                                       linenumberr = angcaya[3];
                                   };
                                   counterskip++;
                               }
                           }

                           if (bracketcntr > currbracket) {
                               bracketcntr = 1;
                           }
                           if (linenumberr != currlinenumber) {
                               bracketcntr = 0;
                           }

                           if (column.fieldName != base) {
                               if (finish == true && grade != 0) {
                                   basevalue = toDecimal(basevalue);
                                   basevalue = parseFloat(basevalue);
                                   basevalue += parseFloat(toDecimal(grade));
                                   basevalue = new Fraction(basevalue);
                               }

                               if (counterskip == 0) {
                                   if ((bracketcntr != currbracket && linenumberr == currlinenumber) || finish == true) {
                                       bracketcntr++;
                                   }
                                   else {
                                       basevalue = toDecimal(basevalue);
                                       basevalue = parseFloat(basevalue);
                                       basevalue += parseFloat(toDecimal(grade));
                                       basevalue = new Fraction(basevalue);
                                       bracketcntr++;
                                   }
                                   finish = false;

                                   linenumberr = currlinenumber;
                                   if (currbracket == 1) {
                                       bracketcntr = currbracket;
                                   }

                                   if (column.fieldName != base)
                                       CINSizeDetail1.batchEditApi.SetCellValue(index, column.fieldName, "");
                               }
                               else {
                                   if ((bracketcntr != currbracket && linenumberr == currlinenumber) || finish == true) {
                                       bracketcntr++;
                                   }
                                   else {
                                       bracketcntr++;
                                       basevalue = toDecimal(basevalue);
                                       basevalue = parseFloat(basevalue);
                                       basevalue += parseFloat(toDecimal(grade));
                                       basevalue = new Fraction(basevalue);
                                   }
                                   finish = false;
                                   linenumberr = currlinenumber;

                                   if (column.fieldName != base)
                                       CINSizeDetail1.batchEditApi.SetCellValue(index, column.fieldName, basevalue);
                               }
                           }
                           else {
                               finish = true;
                           }
                       }
                       else {
                           break;
                       }
                   }



                   linenumberr = "xxx";
                   currlinenumber = "xxx";
                   basevalue = bv;
                   bracketcntr = 0;
                   currbracket = 1;

                   indexbackward = CINSizeDetail1.GetColumnByField(base).index;
                   for (var h = POMfocusindex; h > 6 ; h--) {
                       counterskip = 0;
                       var column = CINSizeDetail1.GetColumn(h);
                       if (column.fieldName != "PointofMeasurement" && column.fieldName != "Instruction") {

                           //lagay ng tamang grade
                           var tv = newgrade.split(",");
                           for (var t = 0; t < tv.length - 1; t++) {
                               var la = tv[t].split("+", 4);
                               if (column.fieldName == la[0].trim()) {
                                   grade = la[1];
                                   currbracket = Nanprocessor1(la[2]);
                                   currlinenumber = la[3];
                                   if (linenumberr == "xxx") {
                                       linenumberr = la[3];
                                   };
                                   counterskip++;
                               }
                           }

                           if (bracketcntr > currbracket) {
                               bracketcntr = 1;
                           }
                           if (linenumberr != currlinenumber) {
                               bracketcntr = 0;
                           }

                           if (counterskip == 0) {
                               if ((bracketcntr != currbracket && linenumberr == currlinenumber) || finish == true) {
                                   bracketcntr++;
                               }
                               else {
                                   basevalue = toDecimal(basevalue);
                                   basevalue = parseFloat(basevalue);
                                   basevalue -= parseFloat(toDecimal(grade));
                                   basevalue = new Fraction(basevalue);
                                   bracketcntr++;
                               }
                               finish = false;

                               linenumberr = currlinenumber;
                               if (currbracket == 1) {
                                   bracketcntr = currbracket;
                               }

                               if (column.fieldName != base)
                                   CINSizeDetail1.batchEditApi.SetCellValue(index, column.fieldName, "");
                           }
                           else {
                               if ((bracketcntr != currbracket && linenumberr == currlinenumber) || finish == true) {
                                   bracketcntr++;
                               }
                               else {
                                   bracketcntr++;
                                   basevalue = toDecimal(basevalue);
                                   basevalue = parseFloat(basevalue);
                                   basevalue -= parseFloat(toDecimal(grade));
                                   basevalue = new Fraction(basevalue);
                               }
                               finish = false;
                               linenumberr = currlinenumber;

                               if (column.fieldName != base)
                                   CINSizeDetail1.batchEditApi.SetCellValue(index, column.fieldName, basevalue);
                           }
                       }
                       else {
                           break;
                       }
                   }

               }
           }, 500);

           validationMeasurementChart();
       }

    </script>
    <!--#endregion-->
</head>
<body style="height: 2300px" onload="onload()">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Product Information Sheet" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
           <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="90"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="notes" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="fbnotes" CloseAction="None"
            EnableViewState="False" HeaderText="Notes" Height="370px" Width="280px" PopupHorizontalOffset="1060" PopupVerticalOffset="200"
            ShowCloseButton="False" Collapsed="true" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="2200px" ClientInstanceName="cp" OnCallback="cp_Callback" SettingsLoadingPanel-Delay="0">
           <%-- <ClientSideEvents EndCallback="gridView_EndCallback" Init="function(){ if(initgv == 'true'){ cp.PerformCallback('getvat'); initgv = 'false'; }}"></ClientSideEvents>
            --%><ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            
            <PanelCollection>
                <dx:PanelContent runat="server" priSupportsDisabledAttribute="True">
                    <dx:ASPxUploadControl ID="gvuploadimageembroider" runat="server" AutoStartUpload="True" ClientInstanceName="CINuploadimageembroider" ClientVisible="false" CssClass="uploadControl" OnFileUploadComplete="gvuploadimageembroider_FileUploadComplete" ShowProgressPanel="True" UploadMode="Auto" ShowTextBox="False" ClientSideEvents-FileUploadStart="function(s,e){cp.ShowLoadingPanel();}" DialogTriggerID="embroiderDropZone">
                        <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .gif, .png" MaxFileSize="510462" MaxFileSizeErrorText="File is too large!">
                        <ErrorStyle CssClass="validationMessage" />
                        </ValidationSettings>
                            <ClientSideEvents 
                                DropZoneEnter="function(s, e) { if(e.dropZone.id == 'embroiderDropZone') setElementVisible('dropZoneEmbroider', true); }" 
                                DropZoneLeave="function(s, e) { if(e.dropZone.id == 'embroiderDropZone') setElementVisible('dropZoneEmbroider', false); }" 
                                FileUploadComplete="UploadImageEmbroiderComplete"  />
                        <ProgressBarStyle CssClass="uploadControlProgressBar" />
                        <AdvancedModeSettings EnableDragAndDrop="True" EnableFileList="False" EnableMultiSelect="False" ExternalDropZoneID="embroiderDropZone"> </AdvancedModeSettings>
                    </dx:ASPxUploadControl>

                    <dx:ASPxUploadControl ID="gvuploadimageprint" runat="server" AutoStartUpload="True"  Caption="dsada" ClientInstanceName="CINuploadimageprint" ClientVisible="false" CssClass="uploadControl" OnFileUploadComplete="gvuploadimageprint_FileUploadComplete" ShowProgressPanel="True" UploadMode="Auto" ShowTextBox="False" ClientSideEvents-FileUploadStart="function(s,e){cp.ShowLoadingPanel();}" DialogTriggerID="printDropZone">
                        <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .gif, .png" MaxFileSize="510462" MaxFileSizeErrorText="File is too large!">
                        <ErrorStyle CssClass="validationMessage" />
                        </ValidationSettings>
                            <ClientSideEvents 
                                DropZoneEnter="function(s, e) { if(e.dropZone.id == 'printDropZone') setElementVisible('dropZonePrint', true); }" 
                                DropZoneLeave="function(s, e) { if(e.dropZone.id == 'printDropZone') setElementVisible('dropZonePrint', false); }" 
                                FileUploadComplete="UploadImagePrintComplete"  />
                        <ProgressBarStyle CssClass="uploadControlProgressBar" />
                        <AdvancedModeSettings EnableDragAndDrop="True" EnableFileList="False" EnableMultiSelect="False" ExternalDropZoneID="printDropZone"> </AdvancedModeSettings>
                    </dx:ASPxUploadControl>

                    <dx:ASPxUploadControl ID="gvuploadimageotherimage" runat="server" AutoStartUpload="True"  Caption="dsada" ClientInstanceName="CINgvuploadimageotherimage" ClientVisible="false" CssClass="uploadControl" OnFileUploadComplete="gvgvuploadimageotherimage_FileUploadComplete" ShowProgressPanel="True" UploadMode="Auto" ShowTextBox="False" ClientSideEvents-FileUploadStart="function(s,e){cp.ShowLoadingPanel();}" DialogTriggerID="OtherPictureDropZone">
                        <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .gif, .png" MaxFileSize="510462" MaxFileSizeErrorText="File is too large!">
                        <ErrorStyle CssClass="validationMessage" />
                        </ValidationSettings>
                            <ClientSideEvents 
                                DropZoneEnter="function(s, e) { if(e.dropZone.id == 'OtherPictureDropZone') setElementVisible('dropZoneOtherPictures', true); }" 
                                DropZoneLeave="function(s, e) { if(e.dropZone.id == 'OtherPictureDropZone') setElementVisible('dropZoneOtherPictures', false); }" 
                                FileUploadComplete="UploadOtherImageComplete"  />
                        <ProgressBarStyle CssClass="uploadControlProgressBar" />
                        <AdvancedModeSettings EnableDragAndDrop="True" EnableFileList="False" EnableMultiSelect="False" ExternalDropZoneID="OtherPictureDropZone"> </AdvancedModeSettings>
                    </dx:ASPxUploadControl>





                    <dx:ASPxPopupControl ID="ErrorConfirm" Theme="Mulberry" runat="server" AllowDragging="True" ClientInstanceName="CINErrorConfirm" CloseAction="CloseButton" CloseOnEscape="true"
                        EnableViewState="False" HeaderImage-Height="10px" HeaderText="Error" Height="100px" ShowHeader="true" Width="400px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
                        ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center" 
                        CssClass="roundedPopup">
                        <HeaderStyle CssClass="roundedPopup" />
                        <ModalBackgroundStyle Opacity="50"></ModalBackgroundStyle>
                        <ContentCollection>
                            <dx:PopupControlContentControl runat="server">
                                <div id="SizeError" class="hidden">
                                    <span><b>No sizes in Measurement Chart.Please specify sizes.</b></span>
                                    <dx:ASPxButton Text="How To Set Measurement Chart Sizes" runat="server"
                                        ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" ClientVisible="true" Theme="MetropolisBlue">
                                        <ClientSideEvents Click="suboklangpota" />
                                    </dx:ASPxButton>
                                    <p id="ErrorDetail" style="font-family: Tahoma; font-size: 10px; color: #666666; display:none; text-align: left" >
                                        * Choose Fit Code. <br />
                                        * Set base size to add detail in measurement chart.
                                    </p>
                                </div>
                                <div id="BaseSizeError" class="hidden">
                                    <span><b>Set Base Size First!</b></span>
                                </div>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>








                     <dx:ASPxFormLayout ID="frmlayout1" ClientInstanceName="CINfrmlayout1" runat="server" Height="565px" Width="850px" style="margin-left: -3px">
                         <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                       
                        <Items>
                            <dx:TabbedLayoutGroup ActiveTabIndex="0">
                                <Items>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>
                                            <dx:LayoutGroup Caption="PIS Information" ColCount="2" Width="100%">
                                                <Items>
                                                    <dx:LayoutGroup Caption="" UseDefaultPaddings="False" Width="37%"
                                                        Paddings-PaddingLeft="25">
                                                        <Items>

                                                            <dx:LayoutItem Caption="PIS Number" Name="PISNumber">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtPISNumber" runat="server" ClientInstanceName="CINPISNumber" Width="220px" ReadOnly="true">
                                                                            <ClientSideEvents Validation="OnValidation" />
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            <dx:LayoutItem Caption="PIS Description" Name="PISDescription">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtPISDescription" runat="server" ClientInstanceName="CINPISDescription" Width="220px">
                                                                            <ClientSideEvents Validation="OnValidation" />
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <dx:LayoutItem Caption="Customer">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <table>
                                                                            <tr>
                                                                                <td>
                                                                                    <dx:ASPxGridLookup ID="glCustomerCode" runat="server" ClientInstanceName="CINCustomerCode" DataSourceID="CustomerCodeLookup" KeyFieldName="BizPartnerCode;Name" TextFormatString="{0}" Width="70px">
                                                                                       <ClientSideEvents  ValueChanged="function (s, e){ cp.PerformCallback('customercodecase');  e.processOnServer = false; loader.Hide();}"
                                                                                            QueryCloseUp="function(s,e){ if(customerload != CINCustomerCode.GetValue()) { loader.Show();}}" 
                                                                                            GotFocus="function(s,e){ customerload = CINCustomerCode.GetValue()}"  />
                                                                                        <GridViewProperties>
                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                            <Settings ShowFilterRow="True" />
                                                                                        </GridViewProperties>
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                        <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                            <RequiredField IsRequired="True" />
                                                                                        </ValidationSettings>
                                                                                        <InvalidStyle BackColor="Pink">
                                                                                        </InvalidStyle>
                                                                                    </dx:ASPxGridLookup>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxTextBox ID="txtCustomerName" runat="server" ClientInstanceName="CINCustomerName"  Width="150px" ReadOnly="true">
                                                                                    </dx:ASPxTextBox>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            <%--<dx:LayoutItem Caption="Customer">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxComboBox ID="cbCustomerCode" runat="server" ClientInstanceName="CINCustomerCode" DataSourceID="CustomerCodeLookup" KeyFieldName="BizPartnerCode" OnLoad="ComboBoxLoad" TextFormatString="{0}" Width="170px"
                                                                            ValueField="BizPartnerCode" TextField="Name">
                                                                            
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>--%>


                                                            <%--<dx:LayoutItem Caption="Brand">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="glBrand" runat="server" ClientInstanceName="CINBrand" DataSourceID="BrandLookup" KeyFieldName="BrandCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="220px">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <ClientSideEvents Validation="OnValidation" />
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>--%>


                                                            <dx:LayoutItem Caption="Brand">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxComboBox ID="cbBrand" runat="server" ClientInstanceName="CINBrand" DataSourceID="BrandLookup" KeyFieldName="BrandCode" TextFormatString="{0}" Width="220px"
                                                                            ValueField="BrandCode" TextField="BrandName">
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            <%--<dx:LayoutItem Caption="Gender">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="glGender" runat="server" ClientInstanceName="CINGender" DataSourceID="GenderCodeLookup" KeyFieldName="GenderCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="220px">
                                                                            <ClientSideEvents ValueChanged="function(s,e){ cp.PerformCallback('gendercodefiltercase'); e.processOnServer = false;}" />
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <ClientSideEvents Validation="OnValidation" />
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>--%>

                                                            <dx:LayoutItem Caption="Gender">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxComboBox ID="cbGender" runat="server" ClientInstanceName="CINGender" DataSourceID="GenderCodeLookup" KeyFieldName="GenderCode" OnLoad="ComboBoxLoad" TextFormatString="{0}" Width="220px"
                                                                            ValueField="GenderCode" TextField="Description">
                                                                            <ClientSideEvents ValueChanged="function(s,e){ cp.PerformCallback('gendercodefiltercase'); e.processOnServer = false;}" />
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            <%--<dx:LayoutItem Caption="Product Category">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="glProductCategory" runat="server" ClientInstanceName="CINGender" DataSourceID="ProductCategoryLookup" KeyFieldName="ProductCategoryCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="220px">
                                                                            <ClientSideEvents ValueChanged="function(s,e){ cp.PerformCallback('productcatergoryfiltercase'); e.processOnServer = false;}" />
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <ClientSideEvents Validation="OnValidation" />
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>--%>

                                                            <dx:LayoutItem Caption="Product Category">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxComboBox ID="cbProductCategory" runat="server" ClientInstanceName="CINProductCategory" DataSourceID="ProductCategoryLookup" KeyFieldName="ProductCategoryCode" OnLoad="ComboBoxLoad" TextFormatString="{0}" Width="220px"
                                                                            ValueField="ProductCategoryCode" TextField="Description">
                                                                            <ClientSideEvents ValueChanged="function(s,e){cp.PerformCallback('productcatergoryfiltercase'); e.processOnServer = false;}" />
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            <%--<dx:LayoutItem Caption="Product Group">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="glProductGroup" runat="server" ClientInstanceName="CINProductGroup" DataSourceID="ProductGroupLookup" KeyFieldName="ProductGroupCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="220px">
                                                                            <ClientSideEvents ValueChanged="function(s,e){ cp.PerformCallback('productgroupfiltercase'); e.processOnServer = false;}" />
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <ClientSideEvents Validation="OnValidation" />
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>--%>

                                                            <dx:LayoutItem Caption="Product Group">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxComboBox ID="cbProductGroup" runat="server" ClientInstanceName="CINProductGroup" DataSourceID="ProductGroupLookup" KeyFieldName="ProductGroupCode" OnLoad="ComboBoxLoad" TextFormatString="{0}" Width="220px"
                                                                            ValueField="ProductGroupCode" TextField="Description">
                                                                            <ClientSideEvents ValueChanged="function(s,e){ cp.PerformCallback('productgroupfiltercase'); e.processOnServer = false;}" />
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            <%--<dx:LayoutItem Caption="FOB Supplier">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="glFOBSupplier" runat="server" ClientInstanceName="CINFOBSupplier" DataSourceID="FOBSupplierLookup" KeyFieldName="FOBCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="220px">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <ClientSideEvents Validation="OnValidation" />
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>--%>

                                                            <dx:LayoutItem Caption="FOB Supplier">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxComboBox ID="cbFOBSupplier" runat="server" ClientInstanceName="CINFOBSupplier" DataSourceID="FOBSupplierLookup" KeyFieldName="FOBCode" OnLoad="ComboBoxLoad" TextFormatString="{0}" Width="220px"
                                                                            ValueField="FOBCode" TextField="Description">
                                                                            <ClientSideEvents ValueChanged="UpdatePISNumber" />
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            <%--<dx:LayoutItem Caption="Product Sub Category">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="glProductSubCategory" runat="server" ClientInstanceName="CINProductSubCategory" DataSourceID="ProductSubCategoryLookup" KeyFieldName="ProductSubCatCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="220px">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <ClientSideEvents Validation="OnValidation" />
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>--%>


                                                            <dx:LayoutItem Caption="Product Sub Category">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxComboBox ID="cbProductSubCategory" runat="server" ClientInstanceName="CINProductSubCategory" DataSourceID="ProductSubCategoryLookup" KeyFieldName="Mnemonics" OnLoad="ComboBoxLoad" TextFormatString="{0}" Width="220px"
                                                                            ValueField="Mnemonics" TextField="Description" HelpText="ProductSubCategory: Filtered By Product Category And Gender." HelpTextSettings-DisplayMode="Popup">
                                                                            <ClientSideEvents ValueChanged="UpdatePISNumber" />
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <%--<dx:LayoutItem Caption="Design Category">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="glDesignCategory" runat="server" ClientInstanceName="CINDesignCategory" DataSourceID="DesignCategoryLookup" KeyFieldName="CategoryCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="220px">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>--%>

                                                            <dx:LayoutItem Caption="Design Category">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxComboBox ID="cbDesignCategory" runat="server" ClientInstanceName="CINDesignCategory" DataSourceID="DesignCategoryLookup" KeyFieldName="CategoryCode" TextFormatString="{0}" Width="220px"
                                                                            ValueField="CategoryCode" TextField="Description" HelpText="DesignCategory: Filtered By Product Category." HelpTextSettings-DisplayMode="Popup">
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            <%--<dx:LayoutItem Caption="Design Sub Category">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="glDesignSubCategory" runat="server" ClientInstanceName="CINDesignSubCategory" DataSourceID="DesignSubCategoryLookup" KeyFieldName="SubCategoryCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="220px">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>--%>

                                                            <dx:LayoutItem Caption="Design Sub Category">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxComboBox ID="cbDesignSubCategory" runat="server" ClientInstanceName="CINDesignSubCategory" DataSourceID="DesignSubCategoryLookup" KeyFieldName="SubCategoryCode" TextFormatString="{0}" Width="220px"
                                                                            ValueField="SubCategoryCode" TextField="Description" HelpText="DesignSubCategory: Filtered By Product Category and Product Group." HelpTextSettings-DisplayMode="Popup">
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            <%--<dx:LayoutItem Caption="Product Class">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="glProductClass" runat="server" ClientInstanceName="CINProductClass" DataSourceID="ProductClassLookup" KeyFieldName="ProductClassCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="220px">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <ClientSideEvents Validation="OnValidation" />
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>--%>

                                                            <dx:LayoutItem Caption="Product Class">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxComboBox ID="cbProductClass" runat="server" ClientInstanceName="CINProductClass" DataSourceID="ProductClassLookup" KeyFieldName="ProductClassCode" TextFormatString="{0}" Width="220px"
                                                                            ValueField="ProductClassCode" TextField="Description">
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            <%--<dx:LayoutItem Caption="Product Sub Class">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="glProductSubClass" runat="server" ClientInstanceName="CINProductSubClass" DataSourceID="ProductSubClassLookup" KeyFieldName="ProductSubClassCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="220px">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>--%>

                                                            <dx:LayoutItem Caption="Product Sub Class">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxComboBox ID="cbProductSubClass" runat="server" ClientInstanceName="CINProductSubClass" DataSourceID="ProductSubClassLookup" KeyFieldName="ProductSubClassCode" TextFormatString="{0}" Width="220px"
                                                                            ValueField="ProductSubClassCode" TextField="Description">
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            <dx:LayoutItem Caption="Inspiration">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtInspiration" runat="server" ClientInstanceName="CINInspiration"  Width="220px">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <dx:LayoutItem Caption="Delivery" >
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <table>
                                                                            <tr>
                                                                                <td>
                                                                                    <dx:ASPxComboBox ID="cbYear" Width="70px" ClientInstanceName="CINcbYear" runat="server">  
                                                                                    </dx:ASPxComboBox>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxLabel Text="" runat="server" Width="2"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxComboBox ID="cbMonth" Width="148px" ClientInstanceName="CINcbMonth" runat="server">                                                                                                        
                                                                                        <Items>
                                                                                            <dx:ListEditItem Text="January" Value="1" />
                                                                                            <dx:ListEditItem Text="February" Value="2" />
                                                                                            <dx:ListEditItem Text="March" Value="3" />
                                                                                            <dx:ListEditItem Text="April" Value="4" />
                                                                                            <dx:ListEditItem Text="May" Value="5" />
                                                                                            <dx:ListEditItem Text="June" Value="6" />
                                                                                            <dx:ListEditItem Text="July" Value="7" />
                                                                                            <dx:ListEditItem Text="August" Value="8" />
                                                                                            <dx:ListEditItem Text="September" Value="9" />
                                                                                            <dx:ListEditItem Text="October" Value="10" />
                                                                                            <dx:ListEditItem Text="November" Value="11" />
                                                                                            <dx:ListEditItem Text="December" Value="12" />
                                                                                        </Items>
                                                                                    </dx:ASPxComboBox>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            <dx:LayoutItem Caption="Collection">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="glCollection" runat="server" ClientInstanceName="CINCollection" DataSourceID="CollectionLookup" KeyFieldName="ThemeCode" TextFormatString="{0}" Width="220px">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="ThemeCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            <dx:LayoutItem Caption="Designer">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="glDesigner" runat="server" ClientInstanceName="CINDesigner" DataSourceID="DesignerLookup" KeyFieldName="EmployeeCode" TextFormatString="{0}" Width="220px">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="EmployeeCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                           
                                                            <dx:LayoutItem Caption="DIS No.">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="glDISNo" runat="server" ClientInstanceName="glDISNo" DataSourceID="DISLookup" KeyFieldName="DocNumber" TextFormatString="{0}" Width="220px">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Type" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            
                                                        </Items>
                                                    </dx:LayoutGroup>



                                                    <dx:LayoutGroup Caption="" ColCount="2" UseDefaultPaddings="False" Width="63%" 
                                                                    Paddings-PaddingLeft="70"
                                                                    Paddings-PaddingRight ="50" ParentContainerStyle-Paddings-PaddingLeft="" >
                                                                    <Paddings PaddingLeft="70px" PaddingRight="50px"></Paddings>
                                                        <Items>




                                                            <dx:LayoutItem ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <dx:ASPxLabel Text="*Note: Recommended picture size 600pxl X 900pxl and less than 500 KB." runat="server" Width="400" ForeColor="Red"> </dx:ASPxLabel>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <dx:EmptyLayoutItem></dx:EmptyLayoutItem>




                                                            <dx:LayoutItem Caption="">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxUploadControl ID="btnFrontUpload" runat="server" AutoStartUpload="True"  Caption="dsada" ClientInstanceName="CINFrontUpload" CssClass="uploadControl" DialogTriggerID="externalDropZone" Name=" " OnFileUploadComplete="btnFrontUpload_FileUploadComplete" ShowProgressPanel="True" UploadMode="Auto" ShowTextBox="False">
                                                                            <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .gif, .png" MaxFileSize="910462" MaxFileSizeErrorText="File is too large!">
                                                                                <ErrorStyle CssClass="validationMessage" />
                                                                            </ValidationSettings>
                                                                                 <ClientSideEvents 
                                                                                     DropZoneEnter="function(s, e) { if(e.dropZone.id == 'externalDropZone') setElementVisible('dropZone', true); }" 
                                                                                     DropZoneLeave="function(s, e) { if(e.dropZone.id == 'externalDropZone') setElementVisible('dropZone', false); }" 
                                                                                     FileUploadComplete="FrontImageUploadComplete"  />
                                                                            <BrowseButton Text="FRONT"></BrowseButton>
                                                                            <BrowseButtonStyle Width="215px" CssClass="BrowseButton"></BrowseButtonStyle>
                                                                            <DropZoneStyle CssClass="uploadControlDropZone" />
                                                                            <ProgressBarStyle CssClass="uploadControlProgressBar" />
                                                                            <AdvancedModeSettings EnableDragAndDrop="True" EnableFileList="False" EnableMultiSelect="False" ExternalDropZoneID="externalDropZone">
                                                                            </AdvancedModeSettings>
                                                                        </dx:ASPxUploadControl>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <dx:LayoutItem Caption="">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxUploadControl ID="btnBackUpload" runat="server" AutoStartUpload="True" Caption="dsada" ClientInstanceName="CINBackUpload" CssClass="uploadControl" DialogTriggerID="externalDropZoneBack" Name=" " OnFileUploadComplete="btnBackUpload_FileUploadComplete" ShowProgressPanel="True" UploadMode="Auto" ShowTextBox="False" OnLoad="UploadControlLoad">
                                                                            <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .gif, .png" MaxFileSize="510462" MaxFileSizeErrorText="File is too large!">
                                                                                <ErrorStyle CssClass="validationMessage" />
                                                                            </ValidationSettings>
                                                                                 <ClientSideEvents 
                                                                                     DropZoneEnter="function(s, e) { if(e.dropZone.id == 'externalDropZoneBack') setElementVisible('dropZoneBack', true); }" 
                                                                                     DropZoneLeave="function(s, e) { if(e.dropZone.id == 'externalDropZoneBack') setElementVisible('dropZoneBack', false); }" 
                                                                                     FileUploadComplete="BackImageUploadComplete" />
                                                                            <BrowseButton Text="BACK"></BrowseButton>
                                                                            <BrowseButtonStyle Width="215px" CssClass="BrowseButton"></BrowseButtonStyle>
                                                                            <DropZoneStyle CssClass="uploadControlDropZone" />
                                                                            <ProgressBarStyle CssClass="uploadControlProgressBar" />
                                                                            <AdvancedModeSettings EnableDragAndDrop="True" EnableFileList="False" EnableMultiSelect="False" ExternalDropZoneID="externalDropZoneBack">
                                                                            </AdvancedModeSettings>
                                                                        </dx:ASPxUploadControl>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <%-- RA TEST remove muna id para sa drag --%>
                                                            <dx:LayoutItem ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                         <div id="externalDropZone" class="dropZoneExternal">
                                                                            <div id="dragZone">
                                                                                <span class="dragZoneText">DRAG IMAGE HERE</span>
                                                                            </div>
                                                                            <dx:ASPxImageZoom ID="dxFrontImage"  ExpandWindowText="Press Escape to Exit Full Screen Mode" ImagesExpandWindow-CloseButton-Width="0px" runat="server" LargeImageUrl="~\IT\Initial.png" ImageUrl="~\IT\Initial.png"  EnableExpandMode="true" ClientInstanceName="CINFrontImage" Height="354px" ShowLoadingImage="True" Width="234px"  CssClass="ImageRadius">
                                                                              <SettingsZoomMode ZoomWindowPosition="Right"  />
                                                                            </dx:ASPxImageZoom>

                                                                            <div id="dropZone" class="hidden">
                                                                                <span class="dropZoneText">DROP IMAGE HERE</span>
                                                                            </div>
                                                                        </div>
                                                                        <table>
                                                                            <tr>
                                                                                  <dx:ASPxLabel Text="" runat="server" Height="2px"> </dx:ASPxLabel>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                        <dx:ASPxLabel Text="" runat="server" Width="50"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxButton ID="ASPxButton1" ClientInstanceName="CINGetStepDetail" runat="server" Width="150px" CssClass="BrowseButton"   AutoPostBack="False" ClientVisible="true" Text="View Full Size" >
                                                                                        <ClientSideEvents Click="function(s,e){ CINFrontImage.expandWindow.Show();
                                                                                            CINBackUpload.SetEnabled(false)
                                                                                             }" />
                                                                                    </dx:ASPxButton>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
		                                                                         

                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <dx:LayoutItem ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <div id="externalDropZoneBack" class="dropZoneExternal">
                                                                               <div id="dragZoneBack">
                                                                                <span class="dragZoneText">DRAG IMAGE HERE</span>
                                                                            </div>
                                                                            <dx:ASPxImageZoom ID="dxBackImage" ExpandWindowText="Press Escape to Exit Full Screen Mode" ImagesExpandWindow-CloseButton-Width="0px" runat="server" LargeImageUrl="~\IT\Initial.png" ImageUrl="~\IT\Initial.png"  ClientInstanceName="CINBackImage" Height="354px" ShowLoadingImage="True" Width="234px"  CssClass="ImageRadius">
                                                                            </dx:ASPxImageZoom>
                                                                            <div id="dropZoneBack" class="hidden">
                                                                                <span class="dropZoneText">DROP IMAGE HERE</span>
                                                                            </div>
                                                                        </div>
                                                                        <table>
                                                                            <tr>
                                                                                  <dx:ASPxLabel Text="" runat="server" Height="2px"> </dx:ASPxLabel>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                        <dx:ASPxLabel Text="" runat="server" Width="50"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxButton ID="ASPxButton2" ClientInstanceName="CINGetStepDetail" runat="server" Width="150px" CssClass="BrowseButton"   AutoPostBack="False" ClientVisible="true" Text="View Full Size" >
                                                                                        <ClientSideEvents Click="function(s,e){ CINBackImage.expandWindow.Show();
                                                                                            CINFrontUpload.SetEnabled(false)
                                                                                             }" />
                                                                                    </dx:ASPxButton>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <dx:LayoutItem ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <dx:ASPxTextBox ID="txtFrontImage64string" ClientInstanceName="CINFrontImage64string" runat="server" Width="250" ClientVisible="false"  ReadOnly="true">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <dx:LayoutItem ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <dx:ASPxTextBox ID="txtBackImage64string" ClientInstanceName="CINBackImage64string" runat="server" Width="250" ClientVisible="false"  ReadOnly="true">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            
                                                            
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Fabric" ColCount="2">
                                                <Items>
                                                    <dx:LayoutGroup ShowCaption="False" GroupBoxStyle-Border-BorderColor="Transparent">
                                                        <Items>
                                                            <dx:LayoutGroup ShowCaption="False">
                                                                <Items>
                                                                        <dx:LayoutItem Caption="Fabric Supplier">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxGridLookup ID="glFabricSupplier" runat="server" ClientInstanceName="CINFabricSupplier" DataSourceID="SupplierCodeLookup" KeyFieldName="SupplierCode" TextFormatString="{0}" Width="170px" OnInit="glFabricSupplier_Init">
                                                                                        <ClientSideEvents ValueChanged="function(s,e){ cp.PerformCallback('fabricsupplierfiltercase'); e.processOnServer = false; loader.Hide();}"
                                                                                            
                                                                                            GotFocus="function(s,e){ fabricsupplierload = CINFabricSupplier.GetValue()}" />
                                                                                        <GridViewProperties>
                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                            <Settings ShowFilterRow="True" />
                                                                                        </GridViewProperties>
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="True" VisibleIndex="0">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                    </dx:ASPxGridLookup>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>

                                                                     <dx:LayoutItem Caption="Fabric Code">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxGridLookup ID="glFabricCode" runat="server" ClientInstanceName="CINFabricCode" DataSourceID="FabricCodeLookup" KeyFieldName="FabricCode" TextFormatString="{0}" Width="170px" HelpText="Fabric Color: Filtered By Fabric Supplier and Product Group." HelpTextSettings-DisplayMode="Popup" OnInit="glFabricCode_Init">
                                                                                        <ClientSideEvents
                                                                                            DropDown="function dropdown(s, e){
                                                                                                        CINFabricCode.GetGridView().PerformCallback(CINProductGroup.GetValue() + '|' + CINFabricSupplier.GetValue() );
                                                                                                        }" 
                                                                                            ValueChanged="function(s,e){ cp.PerformCallback('fabriccodefiltercase'); e.processOnServer = false; loader.Hide();}"/>
                                                                                        <GridViewProperties>
                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                            <Settings ShowFilterRow="True" />
                                                                                        </GridViewProperties>
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="FabricCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="FabricDescription" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                    </dx:ASPxGridLookup>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>

                                                                        <dx:LayoutItem Caption="Fabric Color">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxGridLookup ID="glFabricColor" runat="server" ClientInstanceName="CINFabricColor" DataSourceID="FabricColorLookup" KeyFieldName="ColorCode" TextFormatString="{0}" Width="170px" HelpText="Fabric Color: Filtered By Fabric Code." HelpTextSettings-DisplayMode="Popup" OnInit="glFabricColor_Init">
                                                                                           <ClientSideEvents
                                                                                            DropDown="function dropdown(s, e){
                                                                                                        CINFabricColor.GetGridView().PerformCallback(CINFabricCode.GetValue());
                                                                                                        }" 
                                                                                                />
                                                                                        <GridViewProperties>
                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                            <Settings ShowFilterRow="True" />
                                                                                        </GridViewProperties>
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="FabricCode" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                    </dx:ASPxGridLookup>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>


                                                                        <dx:LayoutItem Caption="Fabric Group">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxTextBox ID="txtFabricGroup" runat="server" ClientInstanceName="CINFabricGroup" ReadOnly="True" Width="170px">
                                                                                    </dx:ASPxTextBox>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>


                                                                        <dx:LayoutItem Caption="Fabric Design Category">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxTextBox ID="txtFabricDesignCategory" runat="server" ClientInstanceName="CINFabricDesignCategory" ReadOnly="True" Width="170px">
                                                                                    </dx:ASPxTextBox>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>


                                                                        <dx:LayoutItem Caption="Dyeing Method">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxTextBox ID="txtDyeingMethod" runat="server" ClientInstanceName="CINDyeingMethod" ReadOnly="True" Width="170px">
                                                                                    </dx:ASPxTextBox>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>


                                                                        <dx:LayoutItem Caption="Weave Type">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxTextBox ID="txtWeaveType" runat="server" ClientInstanceName="CINWeaveType" ReadOnly="True" Width="170px">
                                                                                    </dx:ASPxTextBox>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>


                                                                        <%--<dx:LayoutItem Caption="Finishing">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxTextBox ID="txtFinishing" runat="server" ClientInstanceName="CINFinishing" ReadOnly="True" Width="170px">
                                                                                    </dx:ASPxTextBox>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>--%>
                                                                </Items>
                                                            </dx:LayoutGroup>
                                                            <dx:LayoutGroup Caption="Composition">
                                                                <Items>
                                                                    <dx:LayoutItem Caption="">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxGridView ID="gvComposition" runat="server" AutoGenerateColumns="False" ClientInstanceName="CINgvComposition" Width="100%" SettingsBehavior-AllowSort="False">
                                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" />
                                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                                    <SettingsEditing Mode="Batch">
                                                                                    </SettingsEditing>
                                                                                    <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                                    <Settings VerticalScrollBarMode="Auto" VerticalScrollableHeight="162" VerticalScrollBarStyle="Standard" />
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn Caption="FabricCode" FieldName="FabricCode" Name="FabricCode" ReadOnly="True" ShowInCustomizationForm="True" Visible="false">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="LineNumber" FieldName="LineNumber" Name="FabricCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="0px">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="Percentage" FieldName="Percentage" Name="Percentage" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="Composition" FieldName="Composition" Name="Composition" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                </dx:ASPxGridView>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                 </Items>
                                                            </dx:LayoutGroup>
                                                        </Items>
                                                    </dx:LayoutGroup>

                                                    <dx:LayoutGroup Caption="" ShowCaption="False" GroupBoxStyle-Border-BorderColor="Transparent">
                                                        <Items>
                                                           <%-- NEW LAYOUT GROUP--%>
                                                            
                                                           <%-- RA TEST --%>
                                                            <dx:LayoutGroup ColCount="1" ShowCaption="False">
                                                                <Items>

                                                                    <dx:LayoutItem Caption="" ShowCaption="False">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td>
                                                                                               <dx:ASPxLabel Text="" runat="server" Width="120"> </dx:ASPxLabel>
                                                                                            </td>
                                                                                            <td>
                                                                                                <dx:ASPxImageZoom ID="dxFabricImage" ExpandWindowText="Press Escape to Exit Full Screen Mode" ImagesExpandWindow-CloseButton-Width="0px" ImageUrl="~\IT\Initial1.png" runat="server" Border-BorderStyle="Solid" ClientInstanceName="FabricImage" Height="200px" ShowLoadingImage="True" Width="300px">
                                                                                                  
                                                                                                     <BorderLeft BorderColor="Black" BorderStyle="Solid" BorderWidth="2px" />
                                                                                                    <BorderTop BorderColor="Black" BorderStyle="Solid" BorderWidth="2px" />
                                                                                                    <BorderRight BorderColor="Black" BorderStyle="Solid" BorderWidth="2px" />
                                                                                                    <BorderBottom BorderColor="Black" BorderStyle="Solid" BorderWidth="2px" />
                                                                                                      <SettingsZoomMode ZoomWindowPosition="Left"  />
                                                                                                </dx:ASPxImageZoom>    
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <%---------%>
                                                                        <%--ROW 1--%>
                                                                        <%---------%>
                                                                        <dx:LayoutItem Caption="" ShowCaption="False">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td>
                                                                                               <dx:ASPxLabel Text="" runat="server" Width="120"> </dx:ASPxLabel>
                                                                                            </td>
                                                                                            <td> 
                                                                                                <dx:ASPxLabel Text="Cuttable" runat="server" Font-Size="X-Small" Width="70"> </dx:ASPxLabel>
                                                                                            </td>
                                                                                            <td>
                                                                                                <dx:ASPxLabel Text="Gross" runat="server" Font-Size="X-Small" Width="70"></dx:ASPxLabel>
                                                                                            </td>
                                                                                            <td>
                                                                                                <dx:ASPxLabel Text="For Knits Only" runat="server" Font-Size="X-Small"></dx:ASPxLabel>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <%--END OF ROW 1--%>


                                                                        <%---------%>
                                                                        <%--ROW 2--%>
                                                                        <%---------%>
                                                                        <dx:LayoutItem Caption="" ShowCaption="False">
                                                                                <LayoutItemNestedControlCollection>
                                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                                        <table>
                                                                                            <tr>
                                                                                                <td> 
                                                                                                    <dx:ASPxLabel Text="Width" runat="server" Width="80"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="30"> </dx:ASPxLabel>
                                                                                                 </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtCuttableWidth" runat="server" ClientInstanceName="CINCuttableWidth" ReadOnly="True" Width="60px" Paddings-PaddingRight="10">
<Paddings PaddingRight="10px"></Paddings>
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="2"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtGrossWidth" runat="server" ClientInstanceName="CINGrossWidth" ReadOnly="True" Width="60px" Paddings-PaddingRight="20">
<Paddings PaddingRight="20px"></Paddings>
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="2"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtForKnitsOnly" runat="server" ClientInstanceName="CINForKnitsOnly" ReadOnly="True" Width="130px" CssClass="txtboxInLine">
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </dx:LayoutItemNestedControlContainer>
                                                                                </LayoutItemNestedControlCollection>
                                                                            </dx:LayoutItem>
                                                                        <%--END OF ROW 2--%>

                                                                        <%---------%>
                                                                        <%--ROW 3--%>
                                                                        <%---------%>
                                                                        <dx:LayoutItem Caption="" ShowCaption="False">
                                                                                <LayoutItemNestedControlCollection>
                                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                                        <table>
                                                                                            <tr>
                                                                                                <td> 
                                                                                                    <dx:ASPxLabel Text="Weight BW" runat="server" Width="100"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="10"> </dx:ASPxLabel>
                                                                                                 </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtCuttableWeightBW" runat="server" ClientInstanceName="CINCuttableWeightBW" ReadOnly="True" Width="60px" Paddings-PaddingRight="10">
<Paddings PaddingRight="10px"></Paddings>
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="2"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtGrossWeightBW" runat="server" ClientInstanceName="CINGrossWeightBW" ReadOnly="True" Width="60px" Paddings-PaddingRight="20">
<Paddings PaddingRight="20px"></Paddings>
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="2"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtYield" runat="server" ClientInstanceName="CINYield" Caption="Yield" ReadOnly="True" Width="95px">
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </dx:LayoutItemNestedControlContainer>
                                                                                </LayoutItemNestedControlCollection>
                                                                            </dx:LayoutItem>
                                                                        <%--END OF ROW 3--%>

                                                                        <%---------%>
                                                                        <%--ROW 4--%>
                                                                        <%---------%>
                                                                        <dx:LayoutItem Caption="" ShowCaption="False">
                                                                                <LayoutItemNestedControlCollection>
                                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                                        <table>
                                                                                            <tr>
                                                                                                <td> 
                                                                                                    <dx:ASPxLabel Text="Fabric Stretch:" runat="server" Width="100"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="10"> </dx:ASPxLabel>
                                                                                                 </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtFabricStretch" runat="server" ClientInstanceName="CINFabricStretch" ReadOnly="True" Width="60px" Paddings-PaddingRight="10">
<Paddings PaddingRight="10px"></Paddings>
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="10"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="%" runat="server"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="4"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text=" Use Pull-Test w/ Rinse Wash" runat="server" Width="220" Font-Underline="True"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </dx:LayoutItemNestedControlContainer>
                                                                                </LayoutItemNestedControlCollection>
                                                                            </dx:LayoutItem>
                                                                        <%--END OF ROW 4--%>
                                                                        

                                                                        <%---------%>
                                                                        <%--ROW 5--%>
                                                                        <%---------%>
                                                                        <dx:EmptyLayoutItem>
                                                                        </dx:EmptyLayoutItem>



                                                                        <dx:LayoutItem Caption="" ShowCaption="False">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td>
                                                                                               <dx:ASPxLabel Text="" runat="server" Width="205"> </dx:ASPxLabel>
                                                                                            </td>
                                                                                            <td> 
                                                                                                <dx:ASPxLabel Text="Warp" runat="server" Font-Size="X-Small" Width="100"> </dx:ASPxLabel>
                                                                                            </td>
                                                                                            <td>
                                                                                                <dx:ASPxLabel Text="Weft" runat="server" Font-Size="X-Small" Width="70"></dx:ASPxLabel>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <%--END OF ROW 1--%>


                                                                        <%---------%>
                                                                        <%--ROW 6--%>
                                                                        <%---------%>
                                                                        <dx:LayoutItem Caption="" ShowCaption="False">
                                                                                <LayoutItemNestedControlCollection>
                                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                                        <table>
                                                                                            <tr>
                                                                                                <td> 
                                                                                                    <dx:ASPxLabel Text="Construction:" runat="server" Width="170"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtWarpConstruction" runat="server" ClientInstanceName="CINWarpConstruction" ReadOnly="True" Width="90px">
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="3.5"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="X" runat="server"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="3.5"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtWeftConstruction" runat="server" ClientInstanceName="CINWeftConstruction" ReadOnly="True" Width="90px">
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </dx:LayoutItemNestedControlContainer>
                                                                                </LayoutItemNestedControlCollection>
                                                                            </dx:LayoutItem>
                                                                        <%--END OF ROW 6--%>


                                                                        <%---------%>
                                                                        <%--ROW 7--%>
                                                                        <%---------%>
                                                                        <dx:LayoutItem Caption="" ShowCaption="False">
                                                                                <LayoutItemNestedControlCollection>
                                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                                        <table>
                                                                                            <tr>
                                                                                                <td> 
                                                                                                    <dx:ASPxLabel Text="Weave:" runat="server" Width="170"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtWarpWeave" runat="server" ClientInstanceName="CINWarpWeave" ReadOnly="True" Width="90px">
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="3.5"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="X" runat="server"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="3.5"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtWeftWeave" runat="server" ClientInstanceName="CINWeftWeave" ReadOnly="True" Width="90px">
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </dx:LayoutItemNestedControlContainer>
                                                                                </LayoutItemNestedControlCollection>
                                                                            </dx:LayoutItem>
                                                                        <%--END OF ROW 7--%>


                                                                        <%---------%>
                                                                        <%--ROW 8--%>
                                                                        <%---------%>
                                                                        <dx:LayoutItem Caption="" ShowCaption="False">
                                                                                <LayoutItemNestedControlCollection>
                                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                                        <table>
                                                                                            <tr>
                                                                                                <td> 
                                                                                                    <dx:ASPxLabel Text="Shrinkage (Rinse Wash):" runat="server" Width="170"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtShrinkageWarp" runat="server" ClientInstanceName="CINShrinkageWarp" ReadOnly="True" Width="75">
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="3.5"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="%" runat="server"  Width="10"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="4"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="X" runat="server"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="4"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtShrinkageWeft" runat="server" ClientInstanceName="CINShrinkageWeft" ReadOnly="True" Width="75">
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="3.5"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="%" runat="server"  Width="10"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </dx:LayoutItemNestedControlContainer>
                                                                                </LayoutItemNestedControlCollection>
                                                                            </dx:LayoutItem>
                                                                        <%--END OF ROW 8--%>


                                                                        <%---------%>
                                                                        <%--ROW 9--%>
                                                                        <%---------%>
                                                                        <dx:LayoutItem Caption="" ShowCaption="False">
                                                                                <LayoutItemNestedControlCollection>
                                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                                        <table>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="122"> </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="Use 24” x 24” Method, 50 cm  x 50 cm Marking" runat="server" > </dx:ASPxLabel>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </dx:LayoutItemNestedControlContainer>
                                                                                </LayoutItemNestedControlCollection>
                                                                            </dx:LayoutItem>
                                                                        <%--END OF ROW 9--%>
                                                                        <%--<dx:LayoutItem Caption="" >
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxLabel Text="Width" runat="server">
                                                                                    </dx:ASPxLabel>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>

                                                                        <dx:LayoutItem Caption="" ShowCaption="False">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxTextBox ID="txtCuttableWidth" runat="server" ClientInstanceName="CINCuttableWidth" ReadOnly="True" Width="60px" CssClass="txtboxInLine">
                                                                                    </dx:ASPxTextBox>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>

                                                                        <dx:LayoutItem Caption="" ShowCaption="False">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxTextBox ID="txtGrossWidth" runat="server" ClientInstanceName="CINGrossWidth" ReadOnly="True" Width="60px" CssClass="txtboxInLine">
                                                                                    </dx:ASPxTextBox>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>

                                                                        <dx:LayoutItem Caption="" ShowCaption="False">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxTextBox ID="txtWidthForKnitsOnly" runat="server" ClientInstanceName="CINWidthForKnitsOnly" ReadOnly="True" Width="170px" CssClass="txtboxInLine">
                                                                                    </dx:ASPxTextBox>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>--%>
                                                                </Items>
                                                            </dx:LayoutGroup>
                                                           <%-- END OF NEW LAYOUT GROUP--%>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Fit">
                                                <Items>
                                                    <dx:LayoutGroup ColCount="2" Caption="Fit Information">
                                                        <Items>
                                                            <dx:LayoutItem Caption="Reference BizPartner">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="glReferenceBizPartner" runat="server" ClientInstanceName="CINReferenceBizPartner" DataSourceID="CustomerCodeLookup" KeyFieldName="BizPartnerCode" TextFormatString="{0}" Width="170px">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <dx:LayoutItem Caption="Master Pattern">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtMasterPattern" runat="server" Width="170px" ReadOnly="true">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <dx:LayoutItem Caption="Fit Code">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="glFitCode" runat="server" ClientInstanceName="CINFitCode" DataSourceID="FitCodeLookup" KeyFieldName="FitCode" TextFormatString="{0}" Width="170px" HelpText="Fit Code: Filtered By Gender & Product Category." HelpTextSettings-DisplayMode="Popup">
                                                                            <ClientSideEvents ValueChanged="
                                                                                function(s,e){ cp.PerformCallback('fitcodecase'); e.processOnServer = false; loader.Hide();}"
                                                                                QueryCloseUp="function(s,e){ if(fitcodeload != CINFitCode.GetValue()) { loader.Show();}}" 
                                                                                GotFocus="function(s,e){ fitcodeload = CINFitCode.GetValue()}" />
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="FitCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="FitName" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            
                                                            <dx:LayoutItem Caption="Base Pattern">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtBasePattern" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            
                                                            <dx:LayoutItem Caption="Waist/Neck Line">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtWaistNeckLine" runat="server" Width="170px" ReadOnly="true">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                             <dx:LayoutItem Caption="" ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <table>
                                                                            <tr>
                                                                                <td> 
                                                                                    <dx:ASPxLabel Text="Shrinkage (Actual Wash):" runat="server" Width="140"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxSpinEdit ID="spinActualShrinkageWarp" runat="server" ClientInstanceName="CINActualShrinkageWarp" Width="75" SpinButtons-ShowIncrementButtons="false" OnLoad="SpinEdit_Load">
                                                                                        <ClientSideEvents ValueChanged="computeshrinkage" />
                                                                                    </dx:ASPxSpinEdit>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxLabel Text="" runat="server" Width="3.5"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxLabel Text="%" runat="server"  Width="10"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxLabel Text="" runat="server" Width="4"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxLabel Text="X" runat="server"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxLabel Text="" runat="server" Width="4"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxSpinEdit ID="spinActualShrinkageWeft" runat="server" ClientInstanceName="CINActualShrinkageWeft" Width="75" SpinButtons-ShowIncrementButtons="false" OnLoad="SpinEdit_Load">
                                                                                        <ClientSideEvents ValueChanged="computeshrinkage" />
                                                                                    </dx:ASPxSpinEdit>
                                                                                 </td>
                                                                                 <td>
                                                                                    <dx:ASPxLabel Text="" runat="server" Width="3.5"> </dx:ASPxLabel>
                                                                                 </td>
                                                                                 <td>
                                                                                    <dx:ASPxLabel Text="%" runat="server"  Width="10"> </dx:ASPxLabel>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                 </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            
                                                            <dx:LayoutItem Caption="Fit">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtFit" runat="server" Width="170px" ReadOnly="true">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                             <dx:LayoutItem Caption="" ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <table>
                                                                            <tr>
                                                                                <td> 
                                                                                    <dx:ASPxLabel Text="Combine Shrinkage:" runat="server" Width="140"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxTextBox ID="spinCombineShrinkage" runat="server" ClientInstanceName="CINCombineShrinkage" ReadOnly="True" Width="75">
                                                                                    </dx:ASPxTextBox>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxLabel Text="" runat="server" Width="3.5"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxLabel Text="%" runat="server"  Width="10"> </dx:ASPxLabel>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                 </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>


                                                            
                                                            <dx:LayoutItem Caption="Silhouette/Sleeve Length">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtSilhouette" runat="server" Width="170px" ReadOnly="true">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>



                                                        </Items>
                                                    </dx:LayoutGroup>
                                                    <dx:LayoutGroup ColCount="1" ShowCaption="False" GroupBoxStyle-Border-BorderColor="Transparent">
                                                        <Items>
                                                            <dx:LayoutGroup Caption="Fit Detail">
                                                                <Items>
                                                                    <dx:LayoutItem Caption="">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxGridView ID="gvThreadDetail" runat="server" AutoGenerateColumns="False" ClientInstanceName="CINgvThreadDetail" OnBatchUpdate="gvThreadDetail_BatchUpdate" OnCommandButtonInitialize="gv_CommandButtonInitialize" 
                                                                                    OnCustomButtonInitialize="gv1_CustomButtonInitialize" Width="1200px" SettingsBehavior-AllowSort="False" KeyFieldName="Stitch;ThreadColor;Ticket">
                                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" BatchEditEndEditing="OnEndEditing"  BatchEditStartEditing="OnStartEditing" Init="OnInitTrans"/>
                                                                                        <SettingsPager Mode="ShowAllRecords">
                                                                                        </SettingsPager>
                                                                                        <SettingsEditing Mode="Batch">
                                                                                        </SettingsEditing>
                                                                                        <Settings  VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" HorizontalScrollBarMode="Auto" VerticalScrollableHeight="105" />
                                                                                        <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                                    <Columns>
                                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="60px">
                                                                                            <CustomButtons>
                                                                                                <dx:GridViewCommandColumnCustomButton ID="ThreadDelete">
                                                                                                    <Image IconID="actions_cancel_16x16">
                                                                                                    </Image>
                                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                            </CustomButtons>
                                                                                        </dx:GridViewCommandColumn>

                                                                                        <dx:GridViewDataTextColumn Caption="Stitch" FieldName="Stitch" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="1" Width="150">
                                                                                            <EditItemTemplate>
                                                                                                <dx:ASPxComboBox ID="cbStitch" runat="server" ClientInstanceName="CINStitch">
                                                                                                    <Items>
                                                                                                        <dx:ListEditItem Text="TOP STITCH" Value="TOP STITCH" />
                                                                                                        <dx:ListEditItem Text="UNDERSTITCH" Value="UNDERSTITCH" />
                                                                                                        <dx:ListEditItem Text="SERGING/BARTACK" Value="SERGING/BARTACK" />
                                                                                                    </Items>
                                                                                                </dx:ASPxComboBox>
                                                                                            </EditItemTemplate>
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="ThreadColor" VisibleIndex="2" Width="100px" Name="Thread Color" >
                                                                                            <EditItemTemplate>
                                                                                                <dx:ASPxGridLookup ID="glThreadColor" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                    KeyFieldName="ColorCode" DataSourceID="ColorCodeLookup" ClientInstanceName="CINThreadColor" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad" OnInit="glColorCode_Init" >
                                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                    </GridViewProperties>
                                                                                                    <Columns>
                                                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                                        </dx:GridViewDataTextColumn>
                                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                                                        </dx:GridViewDataTextColumn>
                                                                                                    </Columns>
                                                                                                    <ClientSideEvents KeyDown="function(s,e){
                                                                                                            if(fitcolorcode != CINThreadColor.GetValue())
                                                                                                            {
                                                                                                                gridLookup_KeyDownThread(s,e,true)
                                                                                                            }
                                                                                                            else{
                                                                                                                gridLookup_KeyDownThread(s,e,false)
                                                                                                            }
                                                                                                        }" 
                                                                                                        EndCallback="GridEndChoice" 
                                                                                                        KeyPress="gridLookup_KeyPressThread" 
                                                                                                        DropDown="lookup"  />
                                                                                                </dx:ASPxGridLookup>
                                                                                            </EditItemTemplate>
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <%--<dx:GridViewDataTextColumn Caption="Thread Color" FieldName="ThreadColor" Name="ThreadColor" ShowInCustomizationForm="True" VisibleIndex="2" Width="125">
                                                                                           
                                                                                        </dx:GridViewDataTextColumn>--%>
                                                                                        <dx:GridViewDataTextColumn Caption="Ticket" FieldName="Ticket" Name="Ticket" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                                            <EditItemTemplate>
                                                                                                <dx:ASPxTextBox runat="server" Width="100%" ClientInstanceName="CINTicket">
                                                                                                    <ClientSideEvents LostFocus="setTK" />
                                                                                                </dx:ASPxTextBox>
                                                                                            </EditItemTemplate>
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="R" FieldName="R" Name="R" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="G" FieldName="G" Name="G" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="B" FieldName="B" Name="B" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="Location" FieldName="Location" Name="RTransType" ShowInCustomizationForm="True" VisibleIndex="7">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                </dx:ASPxGridView>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                </Items>
                                                            </dx:LayoutGroup>
<%--                                                            <dx:LayoutGroup Caption="Threads">
                                                            </dx:LayoutGroup>--%>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Wash" ColCount="2">
                                                <Items>    
                                                    <dx:LayoutItem Caption="Wash Supplier" ColSpan="2">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td>
                                                                            <dx:ASPxGridLookup ID="glWashSupplier" runat="server" ClientInstanceName="CINWashSupplier" DataSourceID="SupplierCodeLookup" KeyFieldName="SupplierCode" TextFormatString="{0}" Width="80px" OnInit="glWashSupplier_Init">
                                                                            <ClientSideEvents EndCallback="HeaderEndCallback"
                                                                                    ValueChanged="function(s,e){ CINWashSupplier.GetGridView().PerformCallback('washsuppliercase' + '|' + CINWashSupplier.GetValue() );}"
                                                                                       QueryCloseUp="function(s,e){ if(washsupplierload != CINWashSupplier.GetValue()) { loader.Show();}}"
                                                                                    GotFocus="function(s,e){ washsupplierload = CINWashSupplier.GetValue()}"
                                                                                    DropDown="function(s,e){CINWashSupplier.GetGridView().PerformCallback();}" />
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridLookup>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxLabel runat="server" Width="2px">
                                                                            </dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtWashSupplierName" ClientInstanceName="CINWashSupplierName" runat="server" Width="320px" ClientEnabled="false">
                                                                            </dx:ASPxTextBox>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Wash Code">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glWashCode" runat="server" ClientInstanceName="CINWashCode" DataSourceID="WashCodeLookup" KeyFieldName="WashCode" TextFormatString="{0}" Width="170px" OnInit="glWashCode_Init">
                                                                    <ClientSideEvents ValueChanged="function(s,e){ cp.PerformCallback('washandtintcodecase'); e.processOnServer = false; loader.Hide();}"
                                                                        QueryCloseUp="function(s,e){ if(washcodeload != CINWashCode.GetValue()) { loader.Show();}}" 
                                                                        GotFocus="function(s,e){ washcodeload = CINWashCode.GetValue()}"
                                                                        DropDown="function(s,e){CINWashCode.GetGridView().PerformCallback();}" />
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="WashCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Description">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memoWashDescription" runat="server" Width="400px" Height="60px" HelpText="Default as Wash Code Description + Tint Code Description" HelpTextSettings-DisplayMode="Popup">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem> 

                                                    <dx:LayoutItem Caption="Tint Color">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glTintColor" runat="server" ClientInstanceName="CINTintColor" DataSourceID="TintCodeLookup" KeyFieldName="TintCode" TextFormatString="{0}" Width="170px" OnInit="glTintColor_Init">
                                                                    <ClientSideEvents ValueChanged="function(s,e){ cp.PerformCallback('washandtintcodecase'); e.processOnServer = false; loader.Hide();}"
                                                                        QueryCloseUp="function(s,e){ if(tintcolorload != CINTintColor.GetValue()) { loader.Show();}}" 
                                                                        GotFocus="function(s,e){ tintcolorload = CINTintColor.GetValue()}"
                                                                        DropDown="function(s,e){CINTintColor.GetGridView().PerformCallback();}" />
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="TintCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>    


                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Embroider" ColCount="2">
                                                <Items>


                                                    <dx:LayoutItem Caption="Embroider Supplier">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td>
                                                                            <dx:ASPxGridLookup ID="glEmbroiderySupplier" runat="server" ClientInstanceName="CINEmbroiderySupplier" DataSourceID="SupplierCodeLookup" KeyFieldName="SupplierCode" TextFormatString="{0}" Width="100px" OnInit="glEmbroiderySupplier_Init">
                                                                                <ClientSideEvents EndCallback="HeaderEndCallback"
                                                                                    ValueChanged="function(s,e){ CINEmbroiderySupplier.GetGridView().PerformCallback('embroidersuppliercase' + '|' + CINEmbroiderySupplier.GetValue() );}"
                                                                                    QueryCloseUp="function(s,e){ if(embroidersupplierload != CINEmbroiderySupplier.GetValue()) { loader.Show();}}" 
                                                                                    GotFocus="function(s,e){ embroidersupplierload = CINEmbroiderySupplier.GetValue()}"
                                                                                    DropDown="function(s,e){CINEmbroiderySupplier.GetGridView().PerformCallback();}"  />
                                                                                <GridViewProperties>
                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                    <Settings ShowFilterRow="True" />
                                                                                </GridViewProperties>
                                                                                <Columns>
                                                                                    <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                </Columns>
                                                                            </dx:ASPxGridLookup>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxLabel runat="server" Width="2px">
                                                                            </dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtEmbroiderSupplierDescription" ClientInstanceName="CINEmbroiderSupplierDescription" runat="server" ReadOnly="true" Width="350px">
                                                                            </dx:ASPxTextBox>
                                                                            
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>



                                                    <dx:LayoutGroup Caption="Embroider Detail" Width="80%">
                                                        <Items>
                                                            <dx:LayoutItem Caption="">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxGridView ID="gvEmbroiderDetail" runat="server" AutoGenerateColumns="False"   ClientInstanceName="CINgvEmbroiderDetail" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize" Width="100%" SettingsBehavior-AllowSort="False" onbatchupdate="gvEmbroiderDetail_BatchUpdate"
                                                                                     KeyFieldName="PISNumber;LineNumber">
                                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing"
                                                                                     />
                                                                                        <SettingsPager Mode="ShowAllRecords">
                                                                                        </SettingsPager>
                                                                                        <SettingsEditing Mode="Batch">
                                                                                        </SettingsEditing>
                                                                                        <Settings  VerticalScrollBarMode="Visible" VerticalScrollBarStyle="Virtual" HorizontalScrollBarMode="Hidden" VerticalScrollableHeight="105" />
                                                                                        <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                                        <SettingsBehavior AllowSelectSingleRowOnly="true" />
                                                                                    <Columns>
                                                                                        <%--<dx:GridViewDataTextColumn Caption="LineNumber" FieldName="LineNumber" Name="LineNumber" ShowInCustomizationForm="True" VisibleIndex="1" Width="0">
                                                                                        </dx:GridViewDataTextColumn>--%>
                                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="7%">
                                                                                            <CustomButtons>
                                                                                                <dx:GridViewCommandColumnCustomButton ID="EmbroiderDelete">
                                                                                                    <Image IconID="actions_cancel_16x16">
                                                                                                    </Image>
                                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                            </CustomButtons>
                                                                                        </dx:GridViewCommandColumn> 
                                                                                        <dx:GridViewDataTextColumn Caption="Embro Part" FieldName="EmbroPart" Name="EmbroPart" ShowInCustomizationForm="True" VisibleIndex="1" Width="14%">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="Embro Code" FieldName="EmbroCode" Name="EmbroCode" ShowInCustomizationForm="True" VisibleIndex="2" Width="12%">
                                                                                            <EditItemTemplate>
                                                                                                <dx:ASPxGridLookup ID="glEmbroCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                    KeyFieldName="EmbroCode" DataSourceID="EmbroideryCodeLookup" ClientInstanceName="CINEmbroiderCode" TextFormatString="{0}" Width="100%" OnLoad="gvLookupLoad" OnInit="lookup_Init">
                                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                    </GridViewProperties>
                                                                                                    <Columns>
                                                                                                        <dx:GridViewDataTextColumn FieldName="EmbroCode" ReadOnly="True" VisibleIndex="0">
                                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                                        </dx:GridViewDataTextColumn>
                                                                                                        <dx:GridViewDataTextColumn FieldName="EmbroDescription" ReadOnly="True" VisibleIndex="1">
                                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                                        </dx:GridViewDataTextColumn>
                                                                                                    </Columns>
                                                                                                    <ClientSideEvents KeyDown="function(s,e){
                                                                                                            if(embro != CINEmbroiderCode.GetValue())
                                                                                                            {
                                                                                                                gridLookup_KeyDownEmbro(s,e,true)
                                                                                                            }
                                                                                                            else{
                                                                                                                gridLookup_KeyDownEmbro(s,e,false)
                                                                                                            }
                                                                                                        }" 
                                                                                                        EndCallback="GridEndChoice" 
                                                                                                        KeyPress="gridLookup_KeyPressEmbro"  
                                                                                                        DropDown="lookup"
                                                                                                        />
                                                                                                </dx:ASPxGridLookup>
                                                                                            </EditItemTemplate>
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="Embro Description" FieldName="EmbroDescription" Name="RTransType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4" Width="22%">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataSpinEditColumn Caption="Height(in)" FieldName="Height" Name="RTransType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5" Width="10%">
                                                                                            <PropertiesSpinEdit ClientInstanceName="CINHeight" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" Width="100%">
                                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                <%--<ClientSideEvents ValueChanged="autocalculate" NumberChanged="orderqtynegativecheck" />--%>
                                                                                            </PropertiesSpinEdit>
                                                                                        </dx:GridViewDataSpinEditColumn>
                                                                                        <dx:GridViewDataSpinEditColumn Caption="Width(in)" FieldName="Width" Name="RTransType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6" Width="10%">
                                                                                            <PropertiesSpinEdit ClientInstanceName="CINWidth" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" Width="100%">
                                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                <%--<ClientSideEvents ValueChanged="autocalculate" NumberChanged="orderqtynegativecheck" />--%>
                                                                                            </PropertiesSpinEdit>
                                                                                        </dx:GridViewDataSpinEditColumn >

                                                                                        <dx:GridViewDataTextColumn Caption="Picture" FieldName="PictureEmbroider" Name="Picture" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7" Width="20%" >
                                                                                        </dx:GridViewDataTextColumn>
                                                                                       <%-- CellStyle-Paddings-PaddingLeft="0"
                                                                                                CellStyle-Paddings-PaddingRight="0"
                                                                                                CellStyle-Paddings-PaddingTop="0"
                                                                                                CellStyle-Paddings-PaddingBottom="0"--%>
                                                                                        <dx:GridViewDataButtonEditColumn Caption="..." FieldName="UploadEmbroider" Name="UploadEmbroider" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8" Width="5%">
                                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                                            <DataItemTemplate>
                                                                                                <dx:ASPxButton ID="btnEmbroiderUpload" ClientInstanceName="CINEmbroiderUpload" runat="server" Width="100%" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" ClientVisible="true" Text=" " Theme="MetropolisBlue" OnLoad="btn_init">
                                                                                                    <ClientSideEvents Click="uploadimageembroider" />
                                                                                                </dx:ASPxButton>
                                                                                            </DataItemTemplate>
                                                                                        </dx:GridViewDataButtonEditColumn>

                                                                                        <%--<dx:GridViewDataTextColumn Caption="" FieldName="PictureEmbroiderByte" Name="Picture" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8" Width="">
                                                                                        </dx:GridViewDataTextColumn>--%>

                                                                                        <%--<dx:GridViewDataColumn Caption="Picture" FieldName="Picture" Name="Picture" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7" Width="200">
                                                                                            <EditItemTemplate>
                                                                                                <dx:ASPxUploadControl runat="server">

                                                                                                </dx:ASPxUploadControl>
                                                                                            </EditItemTemplate>
                                                                                        </dx:GridViewDataColumn>--%>
                                                                                        <%--<dx:GridViewDataTextColumn Caption="Picture" FieldName="Picture" Name="Picture" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7" Width="200">
                                                                                        </dx:GridViewDataTextColumn>--%>
                                                                                       <%--  <dx:GridViewDataButtonEditColumn Caption="..." FieldName="UploadEmbroiderPicture" Name="" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8">
                                                                                            <EditItemTemplate>
                                                                                                <dx:ASPxUploadControl ID="ASPxUploadControl12" runat="server" AutoStartUpload="True" Caption="dsada" ClientInstanceName="CINEmbroiderPicture" CssClass="uploadControl" DialogTriggerID="externalDropZone" Name=" " OnFileUploadComplete="btnFrontUpload_FileUploadComplete" ShowProgressPanel="True" ShowTextBox="False">
                                                                                                    <ClientSideEvents FileUploadComplete="function(s,e){ console.log(index + ' hahaha');}" />
                                                                                                </dx:ASPxUploadControl>
                                                                                            </EditItemTemplate>
                                                                                                
                                                                                        </dx:GridViewDataButtonEditColumn>
                                                                                        --%>
                                                                                     <%--    <dx:ASPxUploadControl ID="ASPxUploadControl12" runat="server" AutoStartUpload="True" ClientInstanceName="CINEmbroiderPicture" CssClass="uploadControl" DialogTriggerID="externalDropZone" Name=" " OnFileUploadComplete="btnFrontUpload_FileUploadComplete"  ShowProgressPanel="True" UploadMode="Auto" ShowTextBox="False">
                                                                                                    <ClientSideEvents />
                                                                                                </dx:ASPxUploadControl>--%>
                                                                                        <%--<dx:GridViewDataTextColumn Caption="..." FieldName="UploadEmbroiderPicture" Name="" ShowInCustomizationForm="True" VisibleIndex="8">
                                                                                           <EditItemTemplate>
                                                                                                <dx:ASPxUploadControl ID="EmbroiderUpload" runat="server" ShowUploadButton="true" OnFileUploadComplete="EmbroiderUpload_FileUploadComplete"
                                                                                                    UploadMode="Standard" OnInit="EmbroiderUpload_Init">

                                                                                                </dx:ASPxUploadControl>
                                                                                           </EditItemTemplate>
                                                                                        </dx:GridViewDataTextColumn>--%>
                                                                                      
                                                                                        <%--<dx:GridViewDataTextColumn Caption="Picture" FieldName="Location" Name="RTransType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7">
                                                                                        </dx:GridViewDataTextColumn>--%>
                                                                                    </Columns>
                                                                                </dx:ASPxGridView>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                    <dx:LayoutGroup ShowCaption="False" Width="20%" GroupBoxStyle-Border-BorderColor="Transparent">
                                                        <Items>
                                                            <dx:LayoutItem ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <div id="embroiderDropZone" class="embroiderprint">
                                                                            <div id="dragZoneEmbroider">
                                                                                <span class="dragZoneTextEmbroiderPrint">DRAG IMAGE HERE</span>
                                                                            </div>
                                                                          
                                                                            <dx:ASPxImageZoom ID="dxEmbroiderImage" ExpandWindowText="Press Escape to Exit Full Screen Mode" ImagesExpandWindow-CloseButton-Width="0px" LargeImageUrl="~\IT\Initial2.png" ImageUrl="~\IT\Initial2.png" runat="server" ClientInstanceName="CINEmbroiderImage" Height="147px" ShowLoadingImage="True" Width="197px" CssClass="ImageRadius">
                                                                            </dx:ASPxImageZoom>
                                                                            <div id="dropZoneEmbroider" class="hidden">
                                                                                <span class="dropZoneTextEmbroiderPrint">DROP IMAGE HERE</span>
                                                                            </div>
                                                                        </div>
                                                                                <table>
                                                                            <tr>
                                                                                  <dx:ASPxLabel Text="" runat="server" Height="2px"> </dx:ASPxLabel>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                        <dx:ASPxLabel Text="" runat="server" Width="35"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxButton ID="ASPxButton3" ClientInstanceName="CINGetStepDetail" runat="server" Width="150px" CssClass="BrowseButton"   AutoPostBack="False" ClientVisible="true" Text="View Full Size" >
                                                                                        <ClientSideEvents Click="function(s,e){ CINEmbroiderImage.expandWindow.Show();
                                                                                            CINuploadimageembroider.SetEnabled(false)
                                                                                             }" />
                                                                                    </dx:ASPxButton>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Printing" ColCount="2">
                                                <Items>


                                                    <dx:LayoutItem Caption="Print Supplier">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td>
                                                                            <dx:ASPxGridLookup ID="glPrintSupplier" runat="server" ClientInstanceName="CINPrintSupplier" DataSourceID="SupplierCodeLookup" KeyFieldName="SupplierCode" TextFormatString="{0}" Width="100px" OnInit="glPrintSupplier_Init">
                                                                                <ClientSideEvents EndCallback="HeaderEndCallback"
                                                                                    ValueChanged="function(s,e){ CINPrintSupplier.GetGridView().PerformCallback('printsuppliercase' + '|' + CINPrintSupplier.GetValue() );}"
                                                                                    QueryCloseUp="function(s,e){ if(printsupplierload != CINPrintSupplier.GetValue()) { loader.Show();}}" 
                                                                                    GotFocus="function(s,e){ printsupplierload = CINPrintSupplier.GetValue()}"
                                                                                    DropDown="function(s,e){CINPrintSupplier.GetGridView().PerformCallback();}"  />
                                                                                <GridViewProperties>
                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                    <Settings ShowFilterRow="True" />
                                                                                </GridViewProperties>
                                                                                <Columns>
                                                                                    <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                </Columns>
                                                                            </dx:ASPxGridLookup>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxLabel runat="server" Width="2px">
                                                                            </dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtPrintSupplierDescription" ClientInstanceName="CINPrintSupplierDescription" runat="server" Width="350px" ClientEnabled="false">
                                                                            </dx:ASPxTextBox>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                  
                                                    <dx:LayoutGroup Caption="Print Detail" Width="80%">
                                                        <Items>
                                                            <dx:LayoutItem Caption="">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxGridView ID="gvPrintDetail" runat="server" OnBatchUpdate="gvPrintDetail_BatchUpdate" AutoGenerateColumns="False" ClientInstanceName="CINgvPrintDetail" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize" Width="100%" SettingsBehavior-AllowSort="False" KeyFieldName="PISNumber;LineNumber">
                                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing"
                                                                                     />
                                                                                        <SettingsPager Mode="ShowAllRecords">
                                                                                        </SettingsPager>
                                                                                        <SettingsEditing Mode="Batch">
                                                                                        </SettingsEditing>
                                                                                        <Settings  VerticalScrollBarMode="Visible" VerticalScrollBarStyle="Virtual" HorizontalScrollBarMode="Hidden" VerticalScrollableHeight="105" />
                                                                                        <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                                    <Columns>
                                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="7%">
                                                                                            <CustomButtons>
                                                                                                <dx:GridViewCommandColumnCustomButton ID="PrintDelete">
                                                                                                    <Image IconID="actions_cancel_16x16">
                                                                                                    </Image>
                                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                            </CustomButtons>
                                                                                        </dx:GridViewCommandColumn> 
                                                                                        <dx:GridViewDataTextColumn Caption="Print Part" FieldName="PrintPart" Name="PrintPart" ShowInCustomizationForm="True" VisibleIndex="1" Width="12%">
                                                                                                <PropertiesTextEdit ></PropertiesTextEdit>
                                                                                        </dx:GridViewDataTextColumn>

                                                                                        <dx:GridViewDataTextColumn Caption="Print Code" FieldName="PrintCode" Name="PrintCode" ShowInCustomizationForm="True" VisibleIndex="2" Width="12%">
                                                                                            <EditItemTemplate>
                                                                                                <dx:ASPxGridLookup ID="glPrintCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                    KeyFieldName="ProcessCode" DataSourceID="PrintCodeLookup" ClientInstanceName="CINPrintCode" TextFormatString="{0}" Width="100%" OnLoad="gvLookupLoad" OnInit="glPrintCode_Init">
                                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                    </GridViewProperties>
                                                                                                    <Columns>
                                                                                                        <dx:GridViewDataTextColumn FieldName="ProcessCode" ReadOnly="True" VisibleIndex="0">
                                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                                        </dx:GridViewDataTextColumn>
                                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                                        </dx:GridViewDataTextColumn>
                                                                                                    </Columns>
                                                                                                    <ClientSideEvents KeyDown="function(s,e){
                                                                                                            if(printcodeload != CINPrintCode.GetValue())
                                                                                                            {
                                                                                                                gridLookup_KeyDownDynamic(s,e,true)
                                                                                                            }
                                                                                                            else{
                                                                                                                gridLookup_KeyDownDynamic(s,e,false)
                                                                                                            }
                                                                                                        }" 
                                                                                                        EndCallback="GridEndChoice" 
                                                                                                        KeyPress="gridLookup_KeyPressDynamic"  
                                                                                                        DropDown="lookup"
                                                                                                        />
                                                                                                </dx:ASPxGridLookup>
                                                                                            </EditItemTemplate>
                                                                                        </dx:GridViewDataTextColumn>



                                                                                        <dx:GridViewDataTextColumn Caption="Print Description" FieldName="PrintDescription" Name="PrintDescription" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3" Width="15%">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="Print Ink" FieldName="PrintInk" Name="PrintInk" ShowInCustomizationForm="True" VisibleIndex="4" Width="12%">
                                                                                            <EditItemTemplate>
                                                                                                <dx:ASPxGridLookup ID="glInkCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                    KeyFieldName="InkCode" DataSourceID="InkCodeLookup" ClientInstanceName="CINPrintInk" TextFormatString="{0}" Width="100%" OnLoad="gvLookupLoad" Oninit="glInkCode_Init">
                                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                    </GridViewProperties>
                                                                                                    <Columns>
                                                                                                        <dx:GridViewDataTextColumn FieldName="InkCode" ReadOnly="True" VisibleIndex="0">
                                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                                        </dx:GridViewDataTextColumn>
                                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                                        </dx:GridViewDataTextColumn>
                                                                                                    </Columns>
                                                                                                    <ClientSideEvents KeyDown="function(s,e){
                                                                                                            if(inkcode != CINPrintInk.GetValue())
                                                                                                            {
                                                                                                                gridLookup_KeyDownDynamic(s,e,true)
                                                                                                            }
                                                                                                            else{
                                                                                                                gridLookup_KeyDownDynamic(s,e,false)
                                                                                                            }
                                                                                                        }" 
                                                                                                        EndCallback="GridEndChoice"  
                                                                                                        KeyPress="gridLookup_KeyPressDynamic"  DropDown="lookup"
                                                                                                         />
                                                                                                </dx:ASPxGridLookup>
                                                                                            </EditItemTemplate>
                                                                                        </dx:GridViewDataTextColumn>

                                                                                        <dx:GridViewDataTextColumn Caption="Ink Description" FieldName="InkDescription" Name="InkDescription" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5" Width="17%">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        
                                                                                        <dx:GridViewDataTextColumn Caption="Picture" FieldName="PicturePrint" Name="Picture" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6" Width="20%">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                               <%-- Grid may pics  
                                                                                                     <dx:GridViewDataColumn FieldName="PicturePrint" VisibleIndex="3" Caption="Photo">
                                                                                               
                                                                                                <DataItemTemplate>
                                                                                                    <dx:ASPxImage ID="img" Height="170px" Width="256px" runat="server" ShowLoadingImage="true" ImageUrl='<%# Eval("imagefilename")%>'></dx:ASPxImage>
                                                                                                     <dx:ASPxImageZoom ID="img" ClientInstanceName="image1" Height="170px" Width="256px" runat="server" ShowLoadingImage="true"   ImageUrl='<%#  "data:image/jpg;base64," + Eval("PicturePrint") %>'></dx:ASPxImageZoom>
                                                                                                </DataItemTemplate>
                                                                                            </dx:GridViewDataColumn>--%>

                                                                                        <dx:GridViewDataButtonEditColumn Caption="..." FieldName="UploadPrint" Name="UploadPrint" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7" Width="5%">
                                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                                            <DataItemTemplate>
                                                                                                <dx:ASPxButton ID="btnPrintUpload" ClientInstanceName="CINPrintUpload" runat="server" Width="100%" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" ClientVisible="true" Text=" " Theme="MetropolisBlue" OnLoad="btn_init">
                                                                                                    <ClientSideEvents Click="uploadimageprint" />
                                                                                                </dx:ASPxButton>
                                                                                            </DataItemTemplate>
                                                                                        </dx:GridViewDataButtonEditColumn>

                                                                                    </Columns>
                                                                                </dx:ASPxGridView>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                    <%-- Renats Test --%>
                                                    <dx:LayoutGroup ShowCaption="False" Width="20%" GroupBoxStyle-Border-BorderColor="Transparent">
                                                        <Items>
                                                            <dx:LayoutItem ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <div id="printDropZone" class="embroiderprint">
                                                                            <div id="dragZonePrint">
                                                                                <span class="dragZoneTextEmbroiderPrint">DRAG IMAGE HERE</span>
                                                                            </div>
                                                                            <dx:ASPxImageZoom ID="dxPrintImage"  ExpandWindowText="Press Escape to Exit Full Screen Mode" ImagesExpandWindow-CloseButton-Width="0px" runat="server" LargeImageUrl="~\IT\Initial2.png" ImageUrl="~\IT\Initial2.png" ClientInstanceName="CINPrintImage" Height="147px" ShowLoadingImage="True" Width="197px">
                   
                                                                            </dx:ASPxImageZoom>
                                                                            <div id="dropZonePrint" class="hidden">
                                                                                <span class="dropZoneTextEmbroiderPrint">DROP IMAGE HERE</span>
                                                                            </div>
                                                                        </div>
                                                                                 <table>
                                                                            <tr>
                                                                                  <dx:ASPxLabel Text="" runat="server" Height="2px"> </dx:ASPxLabel>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                        <dx:ASPxLabel Text="" runat="server" Width="35"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxButton ID="ASPxButton4"  ClientInstanceName="CINGetStepDetail" runat="server" Width="150px" CssClass="BrowseButton"   AutoPostBack="False" ClientVisible="true" Text="View Full Size" >
                                                                                        <ClientSideEvents   Click="function(s,e){ 
                                                                                         
                                                                                            CINPrintImage.expandWindow.Show();
                                                                                            CINuploadimageprint.SetEnabled(false)
                                                                                             }" />
                                                                                    </dx:ASPxButton>
                                                                                </td>
                                                                            </tr>
                                                                            </table>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>

                                     
                                    <dx:LayoutGroup Caption="Measurement Chart" Width="100%" ColCount="1">
                                        <Items>
                                            <dx:LayoutGroup Caption="Grade and Bracket Detail Setup" Width="100%" >
                                                <Items> 
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvGradeBracket" runat="server" KeyFieldName="FitCode;LineNumber;POMCode" AutoGenerateColumns="False" DataSourceID ="sdsDetail3" ClientInstanceName="CINgvGradeBracket" OnBatchUpdate="gv1GB_BatchUpdate" OnCommandButtonInitialize="gv_CommandButtonInitialize">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing"  CustomButtonClick="OnCustomClick" Init="OnInitTrans" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <SettingsEditing Mode="Batch" />
                                                                    <Settings HorizontalScrollBarMode="Auto" VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" />
                                                                    <SettingsBehavior AllowSort="False" ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                            
                                                                    <ClientSideEvents Init="OnInitTrans" />
                                                                    <SettingsCommandButton>
                                                                        <NewButton Image-IconID="actions_addfile_16x16">
                                                                            <Image IconID="actions_addfile_16x16"></Image>
                                                                        </NewButton>
                                                                    </SettingsCommandButton>
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="40px" ShowNewButtonInHeader="true">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="GradeBracketDelete">
                                                                                    <Image IconID="actions_cancel_16x16" />
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>    
                                                                        </dx:GridViewCommandColumn>  
                                                                        <dx:GridViewDataTextColumn FieldName="FitCode" ShowInCustomizationForm="True" Visible="false" Width="0px" VisibleIndex="0" >
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" Name="LineNumber" ShowInCustomizationForm="True" Visible="True" VisibleIndex="1" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn> 
                                                                        <dx:GridViewDataTextColumn FieldName="POMCode" VisibleIndex="1" Width="150px" Name="POMCode" Caption="POMCode">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glGBPOMCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                    KeyFieldName="POMCode" DataSourceID="POMLookup" ClientInstanceName="CINGBPOMCode" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad" OnInit="glPOMCode_Init" >
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="POMCode" ReadOnly="True" VisibleIndex="0">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="Instruction" ReadOnly="True" VisibleIndex="2">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents EndCallback="GridEndChoice" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" ValueChanged="function () { autoToleranceNew(); CINgvGradeBracket.batchEditApi.EndEdit();  }" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Sizes" FieldName="Size" Name="Size" ReadOnly="False" Width="540px" ShowInCustomizationForm="True" VisibleIndex="2" CellStyle-HorizontalAlign="Center">
                                                                            <PropertiesTextEdit>
                                                                                <ClientSideEvents TextChanged="autoToleranceNew" />
                                                                            </PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <%--<dx:GridViewDataTextColumn Caption="Grade" FieldName="Grade" Name="Grade" ReadOnly="False" Width="140px" ShowInCustomizationForm="True" VisibleIndex="3" CellStyle-HorizontalAlign="Center">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Bracket" FieldName="Bracket" Name="Bracket" ReadOnly="False" Width="135px" ShowInCustomizationForm="True" VisibleIndex="4" CellStyle-HorizontalAlign="Center">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Tolerance" FieldName="Tolerance" Name="Tolerance" ReadOnly="False" Width="135px" ShowInCustomizationForm="True" VisibleIndex="4" CellStyle-HorizontalAlign="Center">
                                                                        </dx:GridViewDataTextColumn>--%>
                                                                        <dx:GridViewDataTextColumn Caption="Grade" FieldName="Grade" Name="Grade" ShowInCustomizationForm="True" VisibleIndex="7" Width="50">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <CellStyle HorizontalAlign="Center" />
                                                                            <PropertiesTextEdit NullDisplayText="0" NullText="0">
                                                                                <ClientSideEvents TextChanged="validationGradeBracket" />
                                                                            </PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Bracket" FieldName="Bracket" Name="Bracket" ShowInCustomizationForm="True" VisibleIndex="8" Width="50px">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <CellStyle HorizontalAlign="Center" />
                                                                            <PropertiesTextEdit ClientInstanceName="CINBracket" NullDisplayText="1" NullText="1"> 
                                                                                <ClientSideEvents TextChanged="validationGradeBracket" />
                                                                            </PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="+/- Tol" FieldName="Tolerance" Name="Location" ShowInCustomizationForm="True" VisibleIndex="9" Width="50px">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <CellStyle HorizontalAlign="Center" />
                                                                            <PropertiesTextEdit ClientInstanceName="CINTolerance"> 
                                                                                <%--<ClientSideEvents TextChanged="validationGradeBracket" />--%>
                                                                            </PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%--<dx:LayoutItem Caption="" Width="100%" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvGradeBracket" runat="server" AutoGenerateColumns="False" DataSourceID ="sdsDetail" 
                                                                    ClientInstanceName="CINgvGradeBracket" KeyFieldName="SizeCode" OnCommandButtonInitialize="gv_CommandButtonInitialize"   
                                                                    OnBatchUpdate="gv1_BatchUpdate" OnRowDataBound="" Width="1205px" BatchEditStartEditing="OnStartEditing" >
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <SettingsEditing Mode="Batch" />
                                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollableHeight="103" VerticalScrollBarMode="Auto" />
                                                                    <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="40px" ShowNewButtonInHeader="true">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="GradeBracketDelete">
                                                                                    <Image IconID="actions_cancel_16x16" />
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>    
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FitCode" ShowInCustomizationForm="True" Visible="false" Width="0px" VisibleIndex="0" >
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="POMCode" VisibleIndex="1" Width="100px" Name="Code" Caption="Code">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glGBPOMCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                    KeyFieldName="POMCode" DataSourceID="sdsPOM" ClientInstanceName="CINGBPOMCode" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad" OnInit="glPOMCode_Init" >
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="POMCode" ReadOnly="True" VisibleIndex="0">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="Instruction" ReadOnly="True" VisibleIndex="2">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents EndCallback="GridEndChoice" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Sizes" FieldName="Size" Name="Size" ReadOnly="False" Width="140px" ShowInCustomizationForm="True" VisibleIndex="2" CellStyle-HorizontalAlign="Center">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Grade" FieldName="Grade" Name="Grade" ReadOnly="False" Width="140px" ShowInCustomizationForm="True" VisibleIndex="3" CellStyle-HorizontalAlign="Center">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Bracket" FieldName="Bracket" Name="Bracket" ReadOnly="False" Width="135px" ShowInCustomizationForm="True" VisibleIndex="4" CellStyle-HorizontalAlign="Center">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Tolerance" FieldName="Tolerance" Name="Tolerance" ReadOnly="False" Width="135px" ShowInCustomizationForm="True" VisibleIndex="4" CellStyle-HorizontalAlign="Center">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                </Items>
                                            </dx:LayoutGroup> 
                                            <%--<dx:LayoutGroup Caption="Measurement Chart" Width="100%">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvSizeDetail1" runat="server" AutoGenerateColumns="False" ClientInstanceName="CINSizeDetail1" OnBatchUpdate="gvSizeDetail1_BatchUpdate" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize" SettingsBehavior-AllowSort="False"  >
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating" BatchEditStartEditing="OnStartEditing" Init="OnInitTrans" />
                                                                        <SettingsPager Mode="ShowAllRecords">
                                                                        </SettingsPager>
                                                                        <SettingsEditing Mode="Batch">
                                                                        </SettingsEditing>
                                                                        <Settings VerticalScrollableHeight="227" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" HorizontalScrollBarMode="Auto" />
                                                                        <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                        
                                                                    <Columns>      
                                                                            <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="60px">
                                                                                <CustomButtons>
                                                                                   <dx:GridViewCommandColumnCustomButton ID="MeasurementChartDelete">
                                                                                        <Image IconID="actions_cancel_16x16">
                                                                                        </Image>
                                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                                </CustomButtons>
                                                                            </dx:GridViewCommandColumn> 
                                                                            <dx:GridViewDataTextColumn Caption="Order" FieldName="Order" Name="Order" ShowInCustomizationForm="True" VisibleIndex="1" Width="50">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataCheckColumn FieldName="IsMajor" Name="IsMajor" Caption="!"  ShowInCustomizationForm="True" VisibleIndex="2" Width="50">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                                <PropertiesCheckEdit ClientInstanceName="CINIsMajor"></PropertiesCheckEdit>
                                                                            </dx:GridViewDataCheckColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Code" VisibleIndex="3" Width="100px" Name="Code" Caption="Code">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                                <EditItemTemplate>
                                                                                    <dx:ASPxGridLookup ID="glPOMCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                        KeyFieldName="POMCode" DataSourceID="POMLookup" ClientInstanceName="CINPOMCode" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad" OnInit="glPOMCode_Init" >
                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                        </GridViewProperties>
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="POMCode" ReadOnly="True" VisibleIndex="0">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                        <ClientSideEvents EndCallback="GridEndChoice" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" 
                                                                                                ValueChanged="function(s,e){
                                                                                                if(pomcode != CINPOMCode.GetValue()){
                                                                                                closing = true;
                                                                                                CINPOMCode.GetGridView().PerformCallback('POMCode' + '|' + CINPOMCode.GetValue() + '|' + 's.GetInputElement().value');
                                                                                                e.processOnServer = false;
                                                                                                valchange_EMBROCODE = true
                                                                                                }
                                                                                                }"
                                                                                            QueryCloseUp="function(s,e){ if(pomcodeload != CINPOMCode.GetValue()) { loader.Show();}}" 
                                                                                            GotFocus="function(s,e){ pomcodeload = CINPOMCode.GetValue()}"  />
                                                                                    </dx:ASPxGridLookup>
                                                                                </EditItemTemplate>
                                                                                        </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Point Of Measurement" FieldName="PointofMeasurement" Name="PrintDescription" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4" Width="250">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Grade" FieldName="Grade" Name="Grade" ShowInCustomizationForm="True" VisibleIndex="5" Width="50">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                                <CellStyle HorizontalAlign="Center" />
                                                                                <PropertiesTextEdit>
                                                                                    <ClientSideEvents TextChanged="autoTolerance" />
                                                                                </PropertiesTextEdit>
                                                                            </dx:GridViewDataTextColumn> 
                    
                                                                            <dx:GridViewDataSpinEditColumn Caption="Bracket" PropertiesSpinEdit-NumberType="Integer" FieldName="Bracket" Name="Bracket" ShowInCustomizationForm="True" VisibleIndex="6" Width="50">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                                <CellStyle HorizontalAlign="Center" />
                                                                                <PropertiesSpinEdit ClientInstanceName="CINBracket" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"   Width="50">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                     <ClientSideEvents NumberChanged="autoTolerance" /> 
                                                                                </PropertiesSpinEdit>
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                            <dx:GridViewDataTextColumn Caption="+/- Tol" FieldName="Tolerance" Name="Location" ShowInCustomizationForm="True" VisibleIndex="7" Width="50">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                                <CellStyle HorizontalAlign="Center" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Instruction" FieldName="Instruction" Name="Instruction" ReadOnly="true" ShowInCustomizationForm="True" VisibleIndex="998" Width="600">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="LineNumber" FieldName="LineNumberMeasurementChart" Name="LineNumber" ReadOnly="true" ShowInCustomizationForm="True" VisibleIndex="999" Width="0">
                                                                            </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>--%>
                                            
                                            <dx:LayoutGroup Caption="Measurement Chart" Width="100%"> 
                                                <Items> 
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvSizeDetail1" runat="server" KeyFieldName="Order" AutoGenerateColumns="False" ClientInstanceName="CINSizeDetail1" OnBatchUpdate="gvSizeDetail1_BatchUpdate" OnCommandButtonInitialize="gv_CommandButtonInitialize">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm"  BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating" BatchEditStartEditing="OnStartEditing"  CustomButtonClick="OnCustomClick" Init="OnInitTrans" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <SettingsEditing Mode="Batch" />
                                                                    <Settings HorizontalScrollBarMode="Auto" VerticalScrollableHeight="350" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" />
                                                                    <SettingsBehavior AllowSort="False" ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                            
                                                                    <ClientSideEvents Init="OnInitTrans" />
                                                                    <SettingsCommandButton>
                                                                        <NewButton Image-IconID="actions_addfile_16x16">
                                                                            <Image IconID="actions_addfile_16x16"></Image>
                                                                        </NewButton>
                                                                    </SettingsCommandButton>
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="40px" ShowNewButtonInHeader="true">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="MeasurementChartDelete">
                                                                                    <Image IconID="actions_cancel_16x16" />
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>    
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LineNumber" FieldName="LineNumberMeasurementChart" Name="LineNumber" ReadOnly="true" ShowInCustomizationForm="True" VisibleIndex="999" Width="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FitCode" Name="FitCode" ShowInCustomizationForm="True" Visible="False" VisibleIndex="2">
                                                                        </dx:GridViewDataTextColumn> 
                                                                        <dx:GridViewDataTextColumn Caption="Order" FieldName="Order" Name="PrintPart" ShowInCustomizationForm="True" VisibleIndex="3" Width="50px" CellStyle-HorizontalAlign="Center">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataCheckColumn FieldName="IsMajor" Name="IsMajor" Caption="!"  ShowInCustomizationForm="True" VisibleIndex="4" Width="50">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <PropertiesCheckEdit ClientInstanceName="CINIsMajor" />
                                                                        </dx:GridViewDataCheckColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Code" VisibleIndex="5" Width="100px" Name="Code" Caption="Code">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glPOMCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                    KeyFieldName="POMCode" DataSourceID="POMLookup" ClientInstanceName="CINPOMCode" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad" OnInit="glPOMCode_Init" >
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="POMCode" ReadOnly="True" VisibleIndex="0">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="Instruction" ReadOnly="True" VisibleIndex="2">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents EndCallback="GridEndChoice" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" 
                                                                                            ValueChanged="function(s,e){
                                                                                            if(pomcode != CINPOMCode.GetValue()){
                                                                                            closing = true;
                                                                                            CINPOMCode.GetGridView().PerformCallback('POMCode' + '|' + CINPOMCode.GetValue() + '|' + 's.GetInputElement().value');
                                                                                            e.processOnServer = false;
                                                                                            valchange_EMBROCODE = true
                                                                                            }
                                                                                            }"  
                                                                                                GotFocus="function(s,e){ pomcodeload = CINPOMCode.GetValue()}"  />
                                                                                    <%-- QueryCloseUp="function(s,e){ if(pomcodeload != CINPOMCode.GetValue()) { loader.Show();}}" --%>
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Point Of Measurement" FieldName="PointofMeasurement" Name="PrintDescription" ReadOnly="true"  ShowInCustomizationForm="True" VisibleIndex="6" Width="250px">
                                                                        </dx:GridViewDataTextColumn> 
                                                                        <%--<dx:GridViewDataTextColumn Caption="Grade" FieldName="Grade" Name="Grade" ShowInCustomizationForm="True" VisibleIndex="7" Width="50">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <CellStyle HorizontalAlign="Center" />
                                                                            <PropertiesTextEdit>
                                                                                <ClientSideEvents TextChanged="autoTolerance" />
                                                                            </PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Bracket" FieldName="Bracket" Name="Bracket" ShowInCustomizationForm="True" VisibleIndex="8" Width="50px">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <CellStyle HorizontalAlign="Center" />
                                                                            <PropertiesTextEdit ClientInstanceName="CINBracket" NullDisplayText="1" NullText="1"> 
                                                                                <ClientSideEvents TextChanged="autoTolerance" />
                                                                            </PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="+/- Tol" FieldName="Tolerance" Name="Location" ShowInCustomizationForm="True" VisibleIndex="9" Width="50px">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <CellStyle HorizontalAlign="Center" />
                                                                        </dx:GridViewDataTextColumn>--%>
                                                                        <dx:GridViewDataTextColumn Caption="Instruction" FieldName="Instruction" Name="Instruction" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7" Width="210px">
                                                                        </dx:GridViewDataTextColumn> 
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup> 

                                            <dx:LayoutItem Caption="Remarks" Name="Remarks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRemarks" runat="server" ClientInstanceName="CINRemarks">
                                                            </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



                                            <dx:LayoutGroup ShowCaption="False" Width="100%">
                                                <Items>
                                                    <dx:LayoutGroup Caption="Sizes Detail" Width="50%">
                                                        <Items>
                                                            <dx:LayoutItem Caption="">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridView ID="gvSizeDetail2" runat="server" AutoGenerateColumns="False" ClientInstanceName="CINgvSizeDetail2" Width="100%" SettingsBehavior-AllowSort="False" OnCustomButtonInitialize="gv1_CustomButtonInitialize">
                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" />
                                                                                <SettingsPager Mode="ShowAllRecords">
                                                                                </SettingsPager>
                                                                                <SettingsEditing Mode="Batch">
                                                                                </SettingsEditing>
                                                                                <Settings  VerticalScrollableHeight="103" VerticalScrollBarMode="Auto" />
                                                                                <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                        
                                                                            <Columns>       
                                                                                    <dx:GridViewDataTextColumn Caption="SizeCode" FieldName="SizeCode" Name="SizeCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="SizeName" FieldName="SizeName" Name="SizeName" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="Inseam/Length" FieldName="InseamLength" Name="InseamLength" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="Sort#" FieldName="SortNumber" Name="SortNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                                    </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridView>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>

                                                    <dx:LayoutGroup Caption="Sizes" Width="50%" ColCount="1" Height="190">
                                                        <Items>
                                                            <%--<dx:LayoutItem Caption="Base Size" Name="BaseSize">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="ASPxTextBox8" runat="server" ClientInstanceName="CINRemarks" ReadOnly="True" Width="100px">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem ShowCaption="False" >
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxButton ID="btnSet" ClientInstanceName="CINSet" runat="server" Width="100px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" ClientVisible="true" Text="Set" Theme="MetropolisBlue">
                                                                        </dx:ASPxButton>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem ShowCaption="False" >
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxButton ID="btnRefreshGrid" ClientInstanceName="CINRefreshGrid" runat="server" Width="150px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" ClientVisible="true" Text="Refresh Grid" Theme="MetropolisBlue">
                                                                        </dx:ASPxButton>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>--%>
                                                            <dx:LayoutItem Caption="" ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <table>
                                                                            <tr>
                                                                                <td> 
                                                                                    <dx:ASPxTextBox ID="txtBaseSize" runat="server" ClientInstanceName="CINBaseSize" Caption="Base Size" Width="100px">
                                                                                    </dx:ASPxTextBox>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxLabel Text="" runat="server" Width="3.5"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxButton ID="btnSet" ClientInstanceName="CINSet" runat="server" Width="100px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" ClientVisible="true" Text="Set" Theme="MetropolisBlue">
                                                                                        <ClientSideEvents Click="function(s,e){ cp.PerformCallback('setcase'); e.processOnServer = false;  }" />
                                                                                    </dx:ASPxButton>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxLabel Text="" runat="server" Width="3.5"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxButton ID="btnRefreshGrid" ClientInstanceName="CINRefreshGrid" runat="server" Width="150px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" ClientVisible="true" Text="Refresh Grid" Theme="MetropolisBlue">
                                                                                        <ClientSideEvents Click="resetsizesvalue" />
                                                                                    </dx:ASPxButton>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                 </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                </Items>
                                            </dx:LayoutGroup>


                                            <%--<dx:LayoutItem Caption="Sold To" Name="SoldTo">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glSoldTo" AutoGenerateColumns="true" runat="server" DataSourceID="SoldToLookup" KeyFieldName="BizPartnerCode" Width="170px" >
                                                             <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                        </Items>
                                    </dx:LayoutGroup>


                                    <dx:LayoutGroup Caption="BOM &amp; Costing">
                                        <Items>
                                            <dx:LayoutGroup Caption="Costing" ColCount="3">
                                                <Items>
                                                    <dx:LayoutItem Caption="Total Item Cost" Name="TotalItemCost">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="spinTotalItemCost" ClientInstanceName="CINTotalItemCost" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False" OnLoad="SpinEdit_Load" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Mark-up" Name="MarkUp">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="spinMarkUp" ClientInstanceName="CINMarkUp" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False" OnLoad="SpinEdit_Load" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents ValueChanged="computeSellingPrice" />
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Selling Price" Name="SellingPrice">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="spinSellingPrice" ClientInstanceName="CINSellingPrice" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False" OnLoad="SpinEdit_Load" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Additional Overhead" Name="AdditionalOverhead">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="spinAdditionalOverhead" ClientInstanceName="CINAdditionalOverhead" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False" OnLoad="SpinEdit_Load" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents ValueChanged="computePlusOverhead" />
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="SRP" Name="SRP">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="spinSRP" ClientInstanceName="CINSRP" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False" OnLoad="SpinEdit_Load" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents ValueChanged ="computeProfit" />
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Profit Factor" Name="ProfitFactor">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="spinProfitFactor" ClientInstanceName="CINProfitFactor" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False" OnLoad="SpinEdit_Load" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents ValueChanged ="computeSRP" />
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="BOM" ColCount="3">
                                                <Items>
                                                            <dx:LayoutItem Caption="" ShowCaption="False" >
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <table>
                                                                            <tr>
                                                                                <td> 
                                                                                    <dx:ASPxGridLookup ID="glStyleCode" runat="server" ClientInstanceName="CINStyleCode" DataSourceID="StyleCodeLookup" KeyFieldName="StyleCode" TextFormatString="{0}" Width="170px">
                                                                                        <GridViewProperties>
                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                            <Settings ShowFilterRow="True" />
                                                                                        </GridViewProperties>
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="StyleCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                    </dx:ASPxGridLookup>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxLabel Text="" runat="server" Width="3.5"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxButton ID="btnGetStyleDetail" ClientInstanceName="CINGetStyleDetail" runat="server" Width="150px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" ClientVisible="true" Text="Get Template" Theme="MetropolisBlue" >
                                                                                        <ClientSideEvents Click="GetStyleDetail" />
                                                                                    </dx:ASPxButton>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                 </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem  ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <table>
                                                                            <tr>
                                                                                <td>
                                                                                    <dx:ASPxLabel Width="250px" runat="server">
                                                                                    </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxTextBox ID="txtBaseSizeBOM" runat="server" ClientInstanceName="CINBaseSizeBOM" Width="100px" ReadOnly="true" Caption="Base Size">
                                                                                    </dx:ASPxTextBox>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <dx:LayoutItem ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <table>
                                                                            <tr>
                                                                                <td>
                                                                                    <dx:ASPxLabel Width="250px" runat="server"></dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <div id="ItemImageDropZone" class="itemimage">
                                                                                        <div id="dragZoneItemImage">
                                                                                            <span class="dragZoneTextItemImage"></span>
                                                                                        </div>
                                                                                        <dx:ASPxImageZoom ID="dxItemImagePicture" runat="server" ExpandWindowText="Press Escape to Exit Full Screen Mode" ImagesExpandWindow-CloseButton-Width="0px" LargeImageUrl="~\IT\Initial1.png" ImageUrl="~\IT\Initial1.png" ClientInstanceName="CINItemImagePicture" Height="40px" ShowLoadingImage="True" Width="80px">
                                                                                        </dx:ASPxImageZoom>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                    <dx:LayoutGroup Caption="BOM Detail">
                                                        <Items>
                                                            <dx:LayoutItem Caption="">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridView ID="gvStyleDetail"  runat="server"  AutoGenerateColumns="False" ClientInstanceName="CINgvStyleDetail" OnCommandButtonInitialize="gv_CommandButtonInitialize" Width="100%" SettingsBehavior-AllowSort="False" OnBatchUpdate="gvStyleDetail_BatchUpdate" OnCustomButtonInitialize="gv1_CustomButtonInitialize">
                                                                            <ClientSideEvents  EndCallback="OnEndCallback" BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing" Init="OnInitTrans"/>
                                                                            <SettingsPager Mode="ShowAllRecords">
                                                                            </SettingsPager>
                                                                            <SettingsEditing Mode="Batch">
                                                                            </SettingsEditing>
                                                                            <Settings   VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" HorizontalScrollBarMode="Auto" VerticalScrollableHeight="241" />
                                                                            <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                        
                                                                            <Columns>  
                                                                                    <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="60px">
                                                                                            <CustomButtons>
                                                                                                <dx:GridViewCommandColumnCustomButton ID="StyleDelete">
                                                                                                    <Image IconID="actions_cancel_16x16">
                                                                                                    </Image>
                                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                            </CustomButtons>
                                                                                    </dx:GridViewCommandColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="LineNumber" FieldName="LineNumber" Name="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="0px">
                                                                                    </dx:GridViewDataTextColumn> 

                                                                                   
                                                                                    <dx:GridViewDataTextColumn Caption="Step" FieldName="StepCodeStyle" Name="Step"  ShowInCustomizationForm="True" VisibleIndex="2" Width="150px">
                                                                                        <EditItemTemplate>
                                                                                            <dx:ASPxGridLookup ID="glStepCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"  TabIndex="-1"
                                                                                                KeyFieldName="StepCode" DataSourceID="StepLookup" ClientInstanceName="CINStepCodestyle" TextFormatString="{0}" Width="100%" OnLoad="gvLookupLoad" OnInit="glStepCode_Init" IncrementalFilteringMode="Contains">
                                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                </GridViewProperties>
                                                                                                <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="StepCode" ReadOnly="True" VisibleIndex="0" Width="30%" >
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                        
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                    <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1"  Width="70%">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                </Columns>
                                                                                                <ClientSideEvents KeyDown="function(s,e){
                                                                                                        if(stepcodeload != CINStepCodestyle.GetValue())
                                                                                                        {
                                                                                                            gridLookup_KeyDownBOM(s,e,true)
                                                                                                        }
                                                                                                        else{
                                                                                                            gridLookup_KeyDownBOM(s,e,false)
                                                                                                        }
                                                                                                    }" 
                                                                                                    KeyPress="gridLookup_KeyPressBOM"
                                                                                                    DropDown="lookup" 
                                                                                                    EndCallback="GridEndChoice"
                                                                                                    />
                                                                                            </dx:ASPxGridLookup>
                                                                                        </EditItemTemplate>
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="ItemCategory" FieldName="ItemCategoryCodeStyle" Name="ItemCategoryCode"  ShowInCustomizationForm="True" VisibleIndex="3" Width="150px">
                                                                                        <EditItemTemplate>
                                                                                            <dx:ASPxGridLookup ID="glItemCategoryCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                KeyFieldName="ItemCategoryCode" ClientInstanceName="CINItemCategoryCodestyle" TextFormatString="{0}" Width="150" OnLoad="gvLookupLoad" OnInit="glItemCategoryCode_Init">
                                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                </GridViewProperties>
                                                                                                <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="ItemCategoryCode" ReadOnly="True" VisibleIndex="0">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                    <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                </Columns>
                                                                                                <ClientSideEvents KeyDown="function(s,e){
                                                                                                        if(itemcategorycodestyle != CINItemCategoryCodestyle.GetValue())
                                                                                                        {
                                                                                                            gridLookup_KeyDownBOM(s,e,true)
                                                                                                        }
                                                                                                        else{
                                                                                                            gridLookup_KeyDownBOM(s,e,false)
                                                                                                        }
                                                                                                    }" 
                                                                                                    KeyPress="gridLookup_KeyPressBOM" DropDown="lookup" EndCallback="GridEndChoice" />
                                                                                            </dx:ASPxGridLookup>
                                                                                        </EditItemTemplate>
                                                                                    </dx:GridViewDataTextColumn>   
                                                                                  
                                                                                    <dx:GridViewDataTextColumn Caption="ItemCategoryDescription" FieldName="ItemCategoryDescription" Name="ItemCategoryDescription" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4"  Width="200px">
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn Caption="ProductCategory" FieldName="ProductCategoryCodeStyle" Name="ProductCategoryCode"  ShowInCustomizationForm="True" VisibleIndex="5" Width="150px">
                                                                                        <EditItemTemplate>
                                                                                            <dx:ASPxGridLookup ID="glProductCategoryCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                KeyFieldName="ProductCategoryCode" ClientInstanceName="CINProductCategoryCodestyle" TextFormatString="{0}" Width="150" OnLoad="gvLookupLoad" OnInit="glProductCategoryCode_Init">
                                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                </GridViewProperties>
                                                                                                <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="ProductCategoryCode" ReadOnly="True" VisibleIndex="0">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                    <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                </Columns>
                                                                                                <ClientSideEvents EndCallback="GridEndChoice" KeyDown="function(s,e){
                                                                                                        if(productcategorycodestyle != CINProductCategoryCodestyle.GetValue())
                                                                                                        {
                                                                                                            gridLookup_KeyDownBOM(s,e,true)
                                                                                                        }
                                                                                                        else{
                                                                                                            gridLookup_KeyDownBOM(s,e,false)
                                                                                                        }
                                                                                                    }"  
                                                                                                    KeyPress="gridLookup_KeyPressBOM"
                                                                                                    DropDown="function(s,e){CINProductCategoryCodestyle.GetGridView().PerformCallback('ProductCategoryCodeDropDown' + '|' + itemcategorycodestyle);}"   />
                                                                                            </dx:ASPxGridLookup>
                                                                                        </EditItemTemplate>
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="ProductCategoryDescription" FieldName="ProductCategoryDescription" Name="ProductCategoryDescription" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6"  Width="200px">
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn Caption="Supplier" FieldName="SupplierCodeStyle" Name="SupplierCode"  ShowInCustomizationForm="True" VisibleIndex="7" Width="150px">
                                                                                        <EditItemTemplate>
                                                                                            <dx:ASPxGridLookup ID="glSupplierCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                KeyFieldName="SupplierCode" DataSourceID="SupplierCodeLookup" ClientInstanceName="CINSupplierCodestyle" TextFormatString="{0}" Width="150" OnInit="glSupplierCode_Init1">
                                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                </GridViewProperties>
                                                                                                <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="True" VisibleIndex="0">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                    <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                </Columns>
                                                                                                <ClientSideEvents  KeyDown="function(s,e){
                                                                                                        if(suppliercodesteps != CINSupplierCodestyle.GetValue())
                                                                                                        {
                                                                                                            gridLookup_KeyDownBOM(s,e,true)
                                                                                                        }
                                                                                                        else{
                                                                                                            gridLookup_KeyDownBOM(s,e,false)
                                                                                                        }
                                                                                                    }"   
                                                                                                    KeyPress="gridLookup_KeyPressBOM"  
                                                                                                    DropDown="lookup"
                                                                                                    EndCallback="GridEndChoice"
                                                                                                    />
                                                                                            </dx:ASPxGridLookup>
                                                                                        </EditItemTemplate>
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn Caption="ItemCode" FieldName="ItemCodeStyle" Name="ItemCode"  ShowInCustomizationForm="True" VisibleIndex="8" Width="150px">
                                                                                        <EditItemTemplate>
                                                                                            <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                KeyFieldName="ItemCode" ClientInstanceName="CINItemCodestyle" TextFormatString="{0}" Width="150" OnInit="glItemCode_Init">
                                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                </GridViewProperties>
                                                                                                <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                    <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                </Columns>
                                                                                                <ClientSideEvents EndCallback="GridEndChoice" DropDown="function(s,e){CINItemCodestyle.GetGridView().PerformCallback('ItemCodeStyle' + '|' + supplierload + '|' + productcategorycodestyle);}" 
                                                                                                        KeyPress="gridLookup_KeyDownBOM" KeyDown="function(s,e){
                                                                                                        if(itemc != CINItemCodestyle.GetValue())
                                                                                                        {
                                                                                                            gridLookup_KeyDownBOM(s,e,true)
                                                                                                        }
                                                                                                        else{
                                                                                                            gridLookup_KeyDownBOM(s,e,false)
                                                                                                        }
                                                                                                    }"  
                                                                                                     />

                                                                                            </dx:ASPxGridLookup>
                                                                                        </EditItemTemplate>
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn Caption="ItemDescription" FieldName="ItemDescription" Name="ItemDescription" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="9"  Width="250px">
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn Caption="Component" FieldName="ComponentStyle" Name="Component"  ShowInCustomizationForm="True" VisibleIndex="10" Width="150px">
                                                                                        <EditItemTemplate>
                                                                                            <dx:ASPxGridLookup ID="glComponent" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                KeyFieldName="ComponentCode" DataSourceID="ComponentCodeLookup" ClientInstanceName="CINComponent" TextFormatString="{0}" Width="150" OnLoad="gvLookupLoad" OnInit="glComponent_Init">
                                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                </GridViewProperties>
                                                                                                <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="ComponentCode" ReadOnly="True" VisibleIndex="0">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                    <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                </Columns>
                                                                                                <ClientSideEvents KeyDown="function(s,e){
                                                                                                        if(componentload != CINComponent.GetValue())
                                                                                                        {
                                                                                                            gridLookup_KeyDownBOM(s,e,true)
                                                                                                        }
                                                                                                        else{
                                                                                                            gridLookup_KeyDownBOM(s,e,false)
                                                                                                        }
                                                                                                    }" 
                                                                                                    KeyPress="gridLookup_KeyPressBOM"  
                                                                                                    DropDown="lookup"
                                                                                                    EndCallback="GridEndChoice"
                                                                                                    />
                                                                                            </dx:ASPxGridLookup>
                                                                                        </EditItemTemplate>
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn Caption="StockSize" FieldName="StockSize" Name="StockSize"  ShowInCustomizationForm="True" VisibleIndex="11" Width="150px">
                                                                                        <EditItemTemplate>
                                                                                            <dx:ASPxGridLookup ID="glStockSize" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                KeyFieldName="SizeCode" DataSourceID="SizeCodeLookup" ClientInstanceName="CINStockSize" TextFormatString="{0}" Width="100%" OnLoad="gvLookupLoad" OnInit="glStockSize_Init">
                                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                </GridViewProperties>
                                                                                                <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                    <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                </Columns>
                                                                                                <ClientSideEvents KeyDown="function(s,e){
                                                                                                        if(stocksizeload != CINStockSize.GetValue())
                                                                                                        {
                                                                                                            gridLookup_KeyDownBOM(s,e,true)
                                                                                                        }
                                                                                                        else{
                                                                                                            gridLookup_KeyDownBOM(s,e,false)
                                                                                                        }
                                                                                                    }"  KeyPress="gridLookup_KeyPressBOM"  DropDown="lookup"
                                                                                                   EndCallback="GridEndChoice" />
                                                                                            </dx:ASPxGridLookup>
                                                                                        </EditItemTemplate>
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <%--<dx:GridViewDataTextColumn Caption="BySize" FieldName="BySize" Name="BySize" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="12"  Width="200px">
                                                                                    </dx:GridViewDataTextColumn>--%>
                                                                                    <dx:GridViewDataCheckColumn FieldName="BySize" Name="BySize" Caption="BySize"  ShowInCustomizationForm="True" VisibleIndex="12" Width="50px">
                                                                                        <PropertiesCheckEdit ClientInstanceName="CINBySize"></PropertiesCheckEdit>
                                                                                    </dx:GridViewDataCheckColumn>

                                                                                    <dx:GridViewDataTextColumn Caption="ColorCode" FieldName="ColorCodeStyle" Name="ColorCode"  ShowInCustomizationForm="True" VisibleIndex="13" Width="150px">
                                                                                        <EditItemTemplate>
                                                                                            <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                KeyFieldName="ColorCode" ClientInstanceName="CINColorCodestyle" TextFormatString="{0}" Width="150" OnInit="glColorCode_Init1">
                                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                </GridViewProperties>
                                                                                                <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                </Columns>
                                                                                                <ClientSideEvents KeyDown="function(s,e){
                                                                                                        if(colorcodeload != CINColorCodestyle.GetValue())
                                                                                                        {
                                                                                                            gridLookup_KeyDownBOM(s,e,true)
                                                                                                        }
                                                                                                        else{
                                                                                                            gridLookup_KeyDownBOM(s,e,false)
                                                                                                        }
                                                                                                    }"
                                                                                                        KeyPress="gridLookup_KeyPressBOM"
                                                                                                        DropDown="function dropdown(s, e){
                                                                                                        CINColorCodestyle.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                                                        }" 
                                                                                                        EndCallback="GridEndChoice"
                                                                                                        />
                                                                                            </dx:ASPxGridLookup>
                                                                                        </EditItemTemplate>
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn Caption="ClassCode" FieldName="ClassCodeStyle" Name="ClassCode"  ShowInCustomizationForm="True" VisibleIndex="14" Width="150px">
                                                                                        <EditItemTemplate>
                                                                                            <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                KeyFieldName="ClassCode" ClientInstanceName="CINClassCodestyle" TextFormatString="{0}" Width="150" OnInit="glColorCode_Init1">
                                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                </GridViewProperties>
                                                                                                <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                </Columns>
                                                                                                <ClientSideEvents KeyDown="function(s,e){
                                                                                                        if(classcodeload != CINClassCodestyle.GetValue())
                                                                                                        {
                                                                                                            gridLookup_KeyDownBOM(s,e,true)
                                                                                                        }
                                                                                                        else{
                                                                                                            gridLookup_KeyDownBOM(s,e,false)
                                                                                                        }
                                                                                                    }"
                                                                                                        KeyPress="gridLookup_KeyPressBOM"
                                                                                                        DropDown="function dropdown(s, e){
                                                                                                        CINClassCodestyle.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                                                        }" 
                                                                                                         EndCallback="GridEndChoice" />
                                                                                            </dx:ASPxGridLookup>
                                                                                        </EditItemTemplate>
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn Caption="SizeCode" FieldName="SizeCodeStyle" Name="SizeCode"  ShowInCustomizationForm="True" VisibleIndex="15" Width="150px">
                                                                                        <EditItemTemplate>
                                                                                            <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                KeyFieldName="SizeCode" ClientInstanceName="CINSizeCodestyle" TextFormatString="{0}" Width="150" OnInit="glColorCode_Init1">
                                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                </GridViewProperties>
                                                                                                <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                </Columns>
                                                                                                <ClientSideEvents KeyDown="function(s,e){
                                                                                                        if(sizecodeload != CINSizeCodestyle.GetValue())
                                                                                                        {
                                                                                                            gridLookup_KeyDownBOM(s,e,true)
                                                                                                        }
                                                                                                        else{
                                                                                                            gridLookup_KeyDownBOM(s,e,false)
                                                                                                        }
                                                                                                    }" 
                                                                                                        KeyPress="gridLookup_KeyPressBOM"
                                                                                                        DropDown="function dropdown(s, e){
                                                                                                        CINSizeCodestyle.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                                                        }" 
                                                                                                         EndCallback="GridEndChoice" />
                                                                                            </dx:ASPxGridLookup>
                                                                                        </EditItemTemplate>
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataSpinEditColumn Caption="PerPieceConsumption" FieldName="PerPieceConsumption" Name="PerPieceConsumption" ShowInCustomizationForm="True" VisibleIndex="16" Width="150">
                                                                                        <PropertiesSpinEdit ClientInstanceName="CINPerPieceConsumption" DisplayFormatString="g" SpinButtons-ShowIncrementButtons="false" Increment="0">
                                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                <ClientSideEvents   NumberChanged="computeTotalItemCost" />
                                                                                            </PropertiesSpinEdit>
                                                                                    </dx:GridViewDataSpinEditColumn>


                                                                                    <dx:GridViewDataTextColumn FieldName="UnitStyle" VisibleIndex="17" Width="100px" Caption="Unit">   
                                                                                          <EditItemTemplate>
                                                                                            <dx:ASPxGridLookup ID="glUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                KeyFieldName="UnitBase" ClientInstanceName="CINUnitstyle" TextFormatString="{0}" Width="100px" OnInit="glColorCode_Init1">
                                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                </GridViewProperties>
                                                                                                <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="UnitBase" ReadOnly="True" VisibleIndex="0">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                </Columns>
                                                                                                <ClientSideEvents KeyDown="function(s,e){
                                                                                                        if(unitcodeload != CINUnitstyle.GetValue())
                                                                                                        {
                                                                                                            gridLookup_KeyDownBOM(s,e,true)
                                                                                                        }
                                                                                                        else{
                                                                                                            gridLookup_KeyDownBOM(s,e,false)
                                                                                                        }
                                                                                                    }" 
                                                                                                        KeyPress="gridLookup_KeyPressBOM"
                                                                                                        DropDown="function dropdown(s, e){
                                                                                                        CINUnitstyle.GetGridView().PerformCallback('UnitBase' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                                                        }" 
                                                                                                         EndCallback="GridEndChoice" />
                                                                                            </dx:ASPxGridLookup>
                                                                                        </EditItemTemplate>
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataSpinEditColumn Caption="EstimatedUnitCost" FieldName="EstimatedUnitCost" Name="EstimatedUnitCost" ShowInCustomizationForm="True" VisibleIndex="18" Width="150">
                                                                                        <PropertiesSpinEdit ClientInstanceName="CINEstimatedUnitCost" DisplayFormatString="g" SpinButtons-ShowIncrementButtons="false">
                                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                <ClientSideEvents NumberChanged="computeTotalItemCost" />
                                                                                        </PropertiesSpinEdit>
                                                                                    </dx:GridViewDataSpinEditColumn>

                                                                                    <dx:GridViewDataSpinEditColumn Caption="EstimatedCost" FieldName="EstimatedCost" Name="EstimatedCost" ShowInCustomizationForm="True" VisibleIndex="19" Width="150">
                                                                                        <PropertiesSpinEdit ClientInstanceName="CINEstimatedCost" DisplayFormatString="g" SpinButtons-ShowIncrementButtons="false" Increment="0">
                                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                               <ClientSideEvents ValueChanged="computeTotalItemCost" />
                                                                                        </PropertiesSpinEdit>
                                                                                    </dx:GridViewDataSpinEditColumn>

                                                                                    <dx:GridViewDataTextColumn Caption="Picture" FieldName="PictureBOM" Name="PictureBOM" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="20">
                                                                                    </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridView>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>

                                                    

                                                            
                                                            
                                                            
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Steps">
                                                <Items>
                                                    <dx:LayoutItem Caption="" ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <table>
                                                                            <tr>
                                                                                <td> 
                                                                                    <dx:ASPxGridLookup ID="glStepCode" runat="server" ClientInstanceName="CINStepCode" DataSourceID="StepCodeLookup" KeyFieldName="StepTemplateCode" TextFormatString="{0}" Width="170px">
                                                                                        <GridViewProperties>
                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                            <Settings ShowFilterRow="True" />
                                                                                        </GridViewProperties>
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="StepTemplateCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                    </dx:ASPxGridLookup>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxLabel Text="" runat="server" Width="3.5"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxButton ID="btnGetStepDetail" ClientInstanceName="CINGetStepDetail" runat="server" Width="150px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" ClientVisible="true" Text="Get Template" Theme="MetropolisBlue">
                                                                                        <ClientSideEvents Click="GetStepDetail" />
                                                                                    </dx:ASPxButton>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                 </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                    <dx:LayoutGroup Caption="Steps Detail">
                                                        <Items>
                                                            <dx:LayoutItem Caption="">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridView ID="gvStepDetail" runat="server" AutoGenerateColumns="False" ClientInstanceName="CINgvStepDetail" OnCommandButtonInitialize="gv_CommandButtonInitialize" Width="100%" SettingsBehavior-AllowSort="False" OnBatchUpdate="gvStepDetail_BatchUpdate" OnCustomButtonInitialize="gv1_CustomButtonInitialize">
                                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" BatchEditEndEditing="OnEndEditing"  BatchEditStartEditing="OnStartEditing " Init="OnInitTrans"/>
                                                                                        <SettingsPager Mode="ShowAllRecords">
                                                                                        </SettingsPager>
                                                                                        <SettingsEditing Mode="Batch">
                                                                                        </SettingsEditing>
                                                                                        <Settings  VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" HorizontalScrollBarMode="Hidden" VerticalScrollableHeight="226" />
                                                                                        <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                        
                                                                                    <Columns>   
                                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="60px">
                                                                                                <CustomButtons>
                                                                                                    <dx:GridViewCommandColumnCustomButton ID="StepsDelete">
                                                                                                        <Image IconID="actions_cancel_16x16">
                                                                                                        </Image>
                                                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                                                </CustomButtons>
                                                                                        </dx:GridViewCommandColumn>   
                                                                                        <dx:GridViewDataTextColumn Caption="LineNumber" FieldName="LineNumber" Name="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="0px">
                                                                                        </dx:GridViewDataTextColumn>  
                                                                                        <dx:GridViewDataTextColumn Caption="Sequence" FieldName="Sequence" Name="Sequence" ShowInCustomizationForm="True" VisibleIndex="2" Width="100px">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="Step" FieldName="StepCodeSteps" Name="StepCodeSteps"  ShowInCustomizationForm="True" VisibleIndex="3" Width="150px">
                                                                                            <EditItemTemplate>
                                                                                                <dx:ASPxGridLookup ID="glStepCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                    KeyFieldName="StepCode" DataSourceID="StepLookup" ClientInstanceName="CINStepCodeSteps" TextFormatString="{0}" Width="150" OnLoad="gvLookupLoad" OnInit="glStepCode_Init1">
                                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                    </GridViewProperties>
                                                                                                    <Columns>
                                                                                                        <dx:GridViewDataTextColumn FieldName="StepCode" ReadOnly="True" VisibleIndex="0">
                                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                                        </dx:GridViewDataTextColumn>
                                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                                        </dx:GridViewDataTextColumn>
                                                                                                    </Columns>
                                                                                                    <ClientSideEvents KeyDown="function(s,e){
                                                                                                        if(stepcodesteps != CINStepCodeSteps.GetValue())
                                                                                                        {
                                                                                                            gridLookup_KeyDownSTEPS(s,e,true)
                                                                                                        }
                                                                                                        else{
                                                                                                            gridLookup_KeyDownSTEPS(s,e,false)
                                                                                                        }
                                                                                                    }" 
                                                                                                        KeyPress="gridLookup_KeyPressSTEPS"  DropDown="lookup"
                                                                                                        EndCallback="GridEndChoice" />
                                                                                                </dx:ASPxGridLookup>
                                                                                            </EditItemTemplate>
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="Work Center" FieldName="SupplierSteps" Name="WorkCenter"  ShowInCustomizationForm="True" VisibleIndex="4" Width="150px">
                                                                                        <EditItemTemplate>
                                                                                            <dx:ASPxGridLookup ID="glSupplierCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                                KeyFieldName="SupplierCode" DataSourceID="SupplierCodeLookup" ClientInstanceName="CINSupplierCodeSteps" TextFormatString="{0}" Width="150" OnLoad="gvLookupLoad" OnInit="glSupplierCode_Init">
                                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                                </GridViewProperties>
                                                                                                <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="True" VisibleIndex="0">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                    <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1">
                                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                </Columns>
                                                                                                <ClientSideEvents  KeyDown="function(s,e){
                                                                                                        if(suppliercodesteps != CINSupplierCodeSteps.GetValue())
                                                                                                        {
                                                                                                            gridLookup_KeyDownSTEPS(s,e,true)
                                                                                                        }
                                                                                                        else{
                                                                                                            gridLookup_KeyDownSTEPS(s,e,false)
                                                                                                        }
                                                                                                    }"  
                                                                                                    EndCallback="GridEndChoice"
                                                                                                     KeyPress="gridLookup_KeyPressSTEPS" DropDown="lookup"
                                                                                                   
                                                                                                      />
                                                                                            </dx:ASPxGridLookup>
                                                                                        </EditItemTemplate>
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="Work Center Name" FieldName="WorkCenterName" Name="WorkCenterName" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5" Width="250px">
                                                                                        <PropertiesTextEdit EncodeHtml="False"  ></PropertiesTextEdit>
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataSpinEditColumn Caption="Price" FieldName="EstimatedPrice" Name="EstimatedPrice" ShowInCustomizationForm="True" VisibleIndex="6">
                                                                                        <PropertiesSpinEdit ClientInstanceName="CINPrice" DisplayFormatString="g" SpinButtons-ShowIncrementButtons="false" EncodeHtml="False" Increment="0" >
                                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                <ClientSideEvents NumberChanged="computeTotalItemCost" />
                                                                                        </PropertiesSpinEdit>
                                                                                    </dx:GridViewDataSpinEditColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridView>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                </Items>
                                            </dx:LayoutGroup>


                                        </Items>
                                    </dx:LayoutGroup>
                                       


                                  <dx:LayoutGroup Caption="Technical Drawings">
                                        <Items>
                                            <dx:LayoutGroup Caption="Technical Drawing" ColCount="1" Width="100%">
                                                <Items>
                                                    <dx:LayoutItem ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <dx:ASPxLabel Text="*Note: Recommended picture size 600pxl X 900pxl and less than 500 KB." runat="server" ForeColor="Red" > </dx:ASPxLabel>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutGroup ShowCaption="False" GroupBoxStyle-Border-BorderColor="Transparent" ColCount="2"
                                                         Paddings-PaddingLeft="11%"
                                                         Paddings-PaddingRight="9%" >
                                                        <Items>
                                                            <dx:LayoutItem Caption="">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxUploadControl ID="UC2DFront" runat="server" AutoStartUpload="True" ClientInstanceName="CINUC2DFront" CssClass="uploadControl" DialogTriggerID="2DFrontExternalDropZone" Name=" " OnFileUploadComplete="UC2DFront_FileUploadComplete" ShowProgressPanel="True" UploadMode="Auto" ShowTextBox="False" OnLoad="UploadControlLoad">
                                                                            <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .gif, .png" MaxFileSize="510462" MaxFileSizeErrorText="File is too large!">
                                                                                <ErrorStyle CssClass="validationMessage" />
                                                                            </ValidationSettings>
                                                                                    <ClientSideEvents 
                                                                                        DropZoneEnter="function(s, e) { if(e.dropZone.id == '2DFrontExternalDropZone') setElementVisible('2DFrontDropZone', true); }" 
                                                                                        DropZoneLeave="function(s, e) { if(e.dropZone.id == '2DFrontExternalDropZone') setElementVisible('2DFrontDropZone', false); }" 
                                                                                        FileUploadComplete="UC2DFrontImageUploadComplete" />
                                                                            <BrowseButton Text="2D FRONT"></BrowseButton>
                                                                            <BrowseButtonStyle Width="215px" CssClass="BrowseButton"></BrowseButtonStyle>
                                                                            <DropZoneStyle CssClass="uploadControlDropZone" />
                                                                            <ProgressBarStyle CssClass="uploadControlProgressBar" />
                                                                            <AdvancedModeSettings EnableDragAndDrop="True" EnableFileList="False" EnableMultiSelect="False" ExternalDropZoneID="2DFrontExternalDropZone">
                                                                            </AdvancedModeSettings>
                                                                        </dx:ASPxUploadControl>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <dx:LayoutItem Caption="">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxUploadControl ID="UC2DBack" runat="server" AutoStartUpload="True" Caption="dsada" ClientInstanceName="CINUC2DBack" CssClass="uploadControl" DialogTriggerID="2DBackExternalDropZone" Name=" " OnFileUploadComplete="UC2DBack_FileUploadComplete" ShowProgressPanel="True" UploadMode="Auto" ShowTextBox="False" OnLoad="UploadControlLoad">
                                                                            <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .gif, .png" MaxFileSize="510462" MaxFileSizeErrorText="File is too large!">
                                                                                <ErrorStyle CssClass="validationMessage" />
                                                                            </ValidationSettings>
                                                                                    <ClientSideEvents 
                                                                                        DropZoneEnter="function(s, e) { if(e.dropZone.id == '2DBackExternalDropZone') setElementVisible('2DBackDropZone', true); }" 
                                                                                        DropZoneLeave="function(s, e) { if(e.dropZone.id == '2DBackExternalDropZone') setElementVisible('2DBackDropZone', false); }" 
                                                                                        FileUploadComplete="UC2DBackImageUploadComplete" />
                                                                            <BrowseButton Text="2D BACK"></BrowseButton>
                                                                            <BrowseButtonStyle Width="215px" CssClass="BrowseButton"></BrowseButtonStyle>
                                                                            <DropZoneStyle CssClass="uploadControlDropZone" />
                                                                            <ProgressBarStyle CssClass="uploadControlProgressBar" />
                                                                            <AdvancedModeSettings EnableDragAndDrop="True" EnableFileList="False" EnableMultiSelect="False" ExternalDropZoneID="2DBackExternalDropZone">
                                                                            </AdvancedModeSettings>
                                                                        </dx:ASPxUploadControl>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <div id="2DFrontExternalDropZone" class="dropZoneExternal">
                                                                            <div id="2DFrontDragZone">
                                                                                <span class="dragZoneText">DRAG IMAGE HERE</span>
                                                                            </div>
                                                                            <dx:ASPxImageZoom ID="dxFrontImage2D" ExpandWindowText="Press Escape to Exit Full Screen Mode" ImagesExpandWindow-CloseButton-Width="0px"  LargeImageUrl="~\IT\Initial.png" ImageUrl="~\IT\Initial.png"  runat="server" ClientInstanceName="CINFrontImage2D"  Height="354px" ShowLoadingImage="True" Width="234px"  CssClass="ImageRadius">
                                                                            </dx:ASPxImageZoom>
                                                                            <div id="2DFrontDropZone" class="hidden">
                                                                                <span class="dropZoneText">DROP IMAGE HERE</span>
                                                                            </div>
                                                                        </div>
                                                                        
  <table>
                                                                            <tr>
                                                                                  <dx:ASPxLabel Text="" runat="server" Height="2px"> </dx:ASPxLabel>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                        <dx:ASPxLabel Text="" runat="server" Width="50"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxButton ID="ASPxButton5" ClientInstanceName="CINGetStepDetail" runat="server" Width="150px" CssClass="BrowseButton"   AutoPostBack="False" ClientVisible="true" Text="View Full Size" >
                                                                                        <ClientSideEvents Click="function(s,e){ CINFrontImage2D.expandWindow.Show();
                                                                                            CINUC2DFront.SetEnabled(false)
                                                                                             }" />
                                                                                    </dx:ASPxButton>
                                                                                </td>
                                                                            </tr>
                                                                        </table>

                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <dx:LayoutItem ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <div id="2DBackExternalDropZone" class="dropZoneExternal">
                                                                            <div id="2DBackDragZone">
                                                                                <span class="dragZoneText">DRAG IMAGE HERE</span>
                                                                            </div>
                                                                            <dx:ASPxImageZoom ID="dxBackImage2D" ExpandWindowText="Press Escape to Exit Full Screen Mode" ImagesExpandWindow-CloseButton-Width="0px" runat="server" LargeImageUrl="~\IT\Initial.png" ImageUrl="~\IT\Initial.png" ClientInstanceName="CINBackImage2D"  Height="354px" ShowLoadingImage="True" Width="234px"  CssClass="ImageRadius">
                                                                            </dx:ASPxImageZoom>
                                                                            <div id="2DBackDropZone" class="hidden">
                                                                                <span class="dropZoneText">DROP IMAGE HERE</span>
                                                                            </div>
                                                                        </div>
                                                                          <table>
                                                                            <tr>
                                                                                  <dx:ASPxLabel Text="" runat="server" Height="2px"> </dx:ASPxLabel>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                        <dx:ASPxLabel Text="" runat="server" Width="50"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxButton ID="ASPxButton6" ClientInstanceName="CINGetStepDetail" runat="server" Width="150px" CssClass="BrowseButton"   AutoPostBack="False" ClientVisible="true" Text="View Full Size" >
                                                                                        <ClientSideEvents Click="function(s,e){ CINBackImage2D.expandWindow.Show();
                                                                                            CINUC2DBack.SetEnabled(false)
                                                                                             }" />
                                                                                    </dx:ASPxButton>
                                                                                </td>
                                                                            </tr>
                                                                        </table>

                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <dx:LayoutItem ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <dx:ASPxTextBox ID="txt2DFrontImage64string" ClientInstanceName="CIN2DFrontImage64string" runat="server" Width="250" ClientVisible="false" ReadOnly="true">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <dx:LayoutItem ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <dx:ASPxTextBox ID="txt2DBackImage64string" ClientInstanceName="CIN2DBackImage64string" runat="server" Width="250" ClientVisible="false" ReadOnly="true">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                   
                                                        
                                                    
                                                    

                                                    
                                                    
                                                </Items>
                                            </dx:LayoutGroup>

                                            <dx:LayoutGroup Caption="Other Pictures" ColCount="2" Width="100%">
                                                <Items>
                                                    <dx:LayoutGroup Caption="Images" Width="70%">
                                                        <Items>
                                                            <dx:LayoutItem Caption="">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxGridView ID="gvOtherPictures" runat="server" OnBatchUpdate="gvOtherPictures_BatchUpdate" AutoGenerateColumns="False" ClientInstanceName="CINgvOtherPictures" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize" Width="100%" SettingsBehavior-AllowSort="False"
                                                                                     KeyFieldName="PISNumber;LineNumber">
                                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" BatchEditEndEditing="OnEndEditing"  BatchEditStartEditing="OnStartEditing"
                                                                                     />
                                                                                        <SettingsPager Mode="ShowAllRecords">
                                                                                        </SettingsPager>
                                                                                        <SettingsEditing Mode="Batch">
                                                                                        </SettingsEditing>
                                                                                        <Settings  VerticalScrollBarMode="Visible" VerticalScrollBarStyle="Virtual" HorizontalScrollBarMode="Hidden" VerticalScrollableHeight="105" />
                                                                                        <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                                        <SettingsBehavior AllowSelectSingleRowOnly="true" />
                                                                                    <Columns>
                                                                                        <%--<dx:GridViewDataTextColumn Caption="LineNumber" FieldName="LineNumber" Name="LineNumber" ShowInCustomizationForm="True" VisibleIndex="1" Width="0">
                                                                                        </dx:GridViewDataTextColumn>--%>
                                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="10%">
                                                                                            <CustomButtons>
                                                                                                <dx:GridViewCommandColumnCustomButton ID="OtherPictureDelete">
                                                                                                    <Image IconID="actions_cancel_16x16">
                                                                                                    </Image>
                                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                            </CustomButtons>
                                                                                        </dx:GridViewCommandColumn> 
                                                                                        <dx:GridViewDataTextColumn Caption="Name" FieldName="ImageFileName" Name="OtherPictureName" ShowInCustomizationForm="True" VisibleIndex="1" Width="30%">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="Picture" FieldName="OtherPicture" Name="Picture" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="40%">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataButtonEditColumn Caption="..." FieldName="OtherPictureUpload" Name="UploadEmbroider" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3" Width="10%">
                                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                                            <DataItemTemplate>
                                                                                                <dx:ASPxButton ID="btnOtherPictureUpload" ClientInstanceName="CINOtherPictureUpload" runat="server" Width="100%" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" ClientVisible="true" Text=" " Theme="MetropolisBlue" OnLoad="btn_init">
                                                                                                    <ClientSideEvents Click="uploadimageotherpiture" />
                                                                                                </dx:ASPxButton>
                                                                                            </DataItemTemplate>
                                                                                        </dx:GridViewDataButtonEditColumn>
                                                                                        <dx:GridViewDataCheckColumn FieldName="IsBlowUp" Name="IsBlowUp" Caption="BlowUp"  ShowInCustomizationForm="True" VisibleIndex="4" Width="10%">
                                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                                            <PropertiesCheckEdit ClientInstanceName="CINIsBlowUp"></PropertiesCheckEdit>
                                                                                        </dx:GridViewDataCheckColumn>
                                                                                    </Columns>
                                                                                </dx:ASPxGridView>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>



                                                    <dx:LayoutGroup ShowCaption="False" Width="30%" GroupBoxStyle-Border-BorderColor="Transparent">
                                                <Items>
                                                    <dx:LayoutItem ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <div id="OtherPictureDropZone" class="embroiderprint">
                                                                    <div id="dragZoneOtherPicture">
                                                                        <span class="dragZoneTextEmbroiderPrint">DRAG IMAGE HERE</span>
                                                                    </div>
                                                                    <dx:ASPxImageZoom ID="dxOtherPicturePicture" runat="server" ExpandWindowText="Press Escape to Exit Full Screen Mode" ImagesExpandWindow-CloseButton-Width="0px"  LargeImageUrl="~\IT\Initial2.png" ImageUrl="~\IT\Initial2.png" ClientInstanceName="CINOtherPicturePicture" Height="147px" ShowLoadingImage="True" Width="197px">
                                                                    </dx:ASPxImageZoom>
                                                                    <div id="dropZoneOtherPictures" class="hidden">
                                                                        <span class="dropZoneTextEmbroiderPrint">DROP IMAGE HERE</span>
                                                                    </div>
                                                                </div>
                                                                     <table>
                                                                            <tr>
                                                                                  <dx:ASPxLabel Text="" runat="server" Height="2px"> </dx:ASPxLabel>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                        <dx:ASPxLabel Text="" runat="server" Width="35"> </dx:ASPxLabel>
                                                                                </td>
                                                                                <td>
                                                                                    <dx:ASPxButton ID="ASPxButton7"  ClientInstanceName="CINGetStepDetail" runat="server" Width="150px" CssClass="BrowseButton"   AutoPostBack="False" ClientVisible="true" Text="View Full Size" >
                                                                                        <ClientSideEvents   Click="function(s,e){ 
                                                                                         
                                                                                            CINOtherPicturePicture.expandWindow.Show();
                                                                                            CINgvuploadimageotherimage.SetEnabled(false)
                                                                                             }" />
                                                                                    </dx:ASPxButton>
                                                                                </td>
                                                                            </tr>
                                                                            </table>

                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                                </Items>
                                            </dx:LayoutGroup>


                                        </Items>
                                    </dx:LayoutGroup>


                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field 1:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 2:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 3:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 4:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 5:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 6:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 7:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 8:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 9:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>


                                    <dx:LayoutGroup Caption="Audit Trail" ColCount="2" ColSpan="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Added By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Added Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Approved By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtApprovedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Approved Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtApprovedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Unapproved By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtUnapprovedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Unapproved Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtUnapprovedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="CancelledBy By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Synced By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSyncedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Synced Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSyncedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction">
                                        <Items>
                                            <dx:LayoutGroup Caption="Reference Detail">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" ClientInstanceName="gvRef" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" OnCommandButtonInitialize="gv_CommandButtonInitialize" Width="860px">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" Init="OnInitTrans" />
                                                                    <SettingsPager PageSize="5">
                                                                    </SettingsPager>
                                                                    <SettingsEditing Mode="Batch">
                                                                    </SettingsEditing>
                                                                    <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn Caption="DocNumber" FieldName="DocNumber" Name="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Reference TransType" FieldName="RTransType" Name="RTransType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowUpdateButton="True" VisibleIndex="0" Width="90px">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="ViewReferenceTransaction">
                                                                                    <Image IconID="functionlibrary_lookupreference_16x16">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                <dx:GridViewCommandColumnCustomButton ID="ViewTransaction">
                                                                                    <Image IconID="find_find_16x16">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Reference PropertyNumber" FieldName="REFDocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TransType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="RCommandString" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CommandString" ShowInCustomizationForm="True" VisibleIndex="6">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>








                                </Items>
                            </dx:TabbedLayoutGroup>
                            
                        </Items>
                    </dx:ASPxFormLayout>
      
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
                   <dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientVisible ="false" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                                <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
                                    UseSubmitBehavior="false" CausesValidation="true">
                                    <ClientSideEvents Click="OnUpdateClick" />
                                </dx:ASPxButton>
                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
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
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" Text="Loading..." Modal="true"
            ClientInstanceName="loader" ContainerElementID="cp">
             <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
    </form>

    <!--#region Region Datasource-->
    <%-- <ClientSideEvents EndCallback="gridView_EndCallback" Init="function(){ if(initgv == 'true'){ cp.PerformCallback('getvat'); initgv = 'false'; }}"></ClientSideEvents>
            --%>
    <form id="form2" runat="server" visible="false">
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.AssetDisposal" DataObjectTypeName="Entity.AssetDisposal" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ProductInfoSheet+PISStyleChart" DataObjectTypeName="Entity.ProductInfoSheet+PISStyleChart" DeleteMethod="DeletePISStyleChart" InsertMethod="AddPISStyleChart" UpdateMethod="UpdatePISStyleChart">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.AssetDisposal+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.AssetDisposal+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsThreadDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ProductInfoSheet+PISThreadDetail" DataObjectTypeName="Entity.ProductInfoSheet+PISThreadDetail" DeleteMethod="DeletePISThreadDetail" InsertMethod="AddPISThreadDetail" UpdateMethod="UpdatePISThreadDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsEmbroideryDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ProductInfoSheet+PISEmbroideryDetail" DataObjectTypeName="Entity.ProductInfoSheet+PISEmbroideryDetail" DeleteMethod="DeletePISEmbroideryDetail" InsertMethod="AddPISEmbroideryDetail" UpdateMethod="UpdatePISEmbroideryDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsPrintDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ProductInfoSheet+PISPrintDetail" DataObjectTypeName="Entity.ProductInfoSheet+PISPrintDetail" DeleteMethod="DeletePISPrintDetail" InsertMethod="AddPISPrintDetail" UpdateMethod="UpdatePISPrintDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsStepDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ProductInfoSheet+PISStepTemplate" DataObjectTypeName="Entity.ProductInfoSheet+PISStepTemplate" DeleteMethod="DeletePISStepTemplate" InsertMethod="AddPISStepTemplate" UpdateMethod="UpdatePISStepTemplate">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsStyleDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ProductInfoSheet+PISStyleTemplate" DataObjectTypeName="Entity.ProductInfoSheet+PISStyleTemplate" DeleteMethod="DeletePISStyleTemplate" InsertMethod="AddPISStyleTemplate" UpdateMethod="UpdatePISStyleTemplate">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsOtherPictureDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ProductInfoSheet+PISOtherPictureDetail" DataObjectTypeName="Entity.ProductInfoSheet+PISOtherPictureDetail" DeleteMethod="DeletePISOtherPictureDetail" InsertMethod="AddPISOtherPictureDetail" UpdateMethod="UpdatePISOtherPictureDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail3" runat="server" SelectMethod="getdetailFitGradeBracket" TypeName="Entity.ProductInfoSheet+PISGradeBracket" DataObjectTypeName="Entity.ProductInfoSheet+PISGradeBracket" DeleteMethod="DeleteFitGradeBracket" InsertMethod="AddFitGradeBracket" UpdateMethod="UpdateFitGradeBracket">
        <SelectParameters>
            <asp:QueryStringParameter Name="docnumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

     <%--<!--#region Region Header --> --%>
    <asp:SqlDataSource ID="sdsDetail3" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Production.PISGradeBracket where FitCode  is null " OnInit = "Connection_Init" />
    <asp:SqlDataSource ID="ThreadDetailDS" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Masterfile.PISThreadDetail WHERE PISNumber is null" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="EmbroiderDetailDS" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT *,'' AS EmbroDescription, '' AS UploadEmbroider FROM Masterfile.PISEmbroideryDetail WHERE PISNumber is null" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="PrintDetailDS" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT *,'' AS UploadPrint FROM Masterfile.PISPrintDetail WHERE PISNumber is null" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="StepDetailDS" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Masterfile.PISStepTemplate WHERE PISNumber is null" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="StyleDetailDS" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Masterfile.PISStyleTemplate WHERE PISNumber is null" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="OtherPictureDetailDS" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT *,'' AS OtherPictureUpload FROM Masterfile.PISImage WHERE PISNumber is null" OnInit = "Connection_Init"> </asp:SqlDataSource>

    <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="CustomerCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode,Name FROM Masterfile.[BPCustomerInfo] WHERE ISNULL([IsInactive],0) = 0" OnInit = "Connection_Init"> </asp:SqlDataSource> 
    <asp:SqlDataSource ID="ProductCategoryLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT LTRIM(RTRIM(ProductCategoryCode)) AS ProductCategoryCode, Description FROM Masterfile.ProductCategory WHERE ISNULL(IsInactive,0)=0 AND ISNULL(ProductCategoryCode,'')!='' AND ISNULL(ItemCategoryCode,'')=1"  OnInit = "Connection_Init"> </asp:SqlDataSource> 
    <asp:SqlDataSource ID="ProductGroupLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ProductGroupCode, Description FROM Masterfile.ProductGroup WHERE ISNULL(IsInactive,0)=0 AND ISNULL(ProductGroupCode,'')!=''" OnInit = "Connection_Init"> </asp:SqlDataSource> 
    <asp:SqlDataSource ID="FOBSupplierLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT FOBCode, Description FROM Masterfile.FOBSupplier WHERE ISNULL(IsInactive,0)=0 AND ISNULL(FOBCode,'')!=''" OnInit = "Connection_Init"> </asp:SqlDataSource> 
    <asp:SqlDataSource ID="ProductSubCategoryLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""  OnInit = "Connection_Init"> </asp:SqlDataSource> 
    <asp:SqlDataSource ID="DesignCategoryLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource> 
    <asp:SqlDataSource ID="DesignSubCategoryLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource> 
    <asp:SqlDataSource ID="ProductClassLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ProductClassCode, Description FROM Masterfile.ProductClass WHERE ISNULL(IsInactive,0)=0 AND ISNULL(ProductClassCode,'')!=''" OnInit = "Connection_Init"> </asp:SqlDataSource> 
    <asp:SqlDataSource ID="ProductSubClassLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ProductSubClassCode, Description FROM Masterfile.ProductSubClass WHERE ISNULL(IsInactive,0)=0 AND ISNULL(ProductSubClassCode,'')!=''" OnInit = "Connection_Init"> </asp:SqlDataSource> 
    <asp:SqlDataSource ID="GenderCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT GenderCode, Description FROM Masterfile.Gender WHERE ISNULL(IsInactive,0)=0 AND ISNULL(GenderCode,'')!=''" OnInit = "Connection_Init"> </asp:SqlDataSource> 
    <asp:SqlDataSource ID="BrandLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BrandCode, BrandName FROM Masterfile.Brand WHERE ISNULL(IsInactive,0)=0 AND ISNULL(BrandCode,'')!=''" OnInit = "Connection_Init"> </asp:SqlDataSource> 
    <asp:SqlDataSource ID="SupplierCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="FabricCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="FabricColorLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="FitCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="WashCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource> 
    <asp:SqlDataSource ID="TintCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="EmbroideryCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""  OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="PrintCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="InkCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="StepCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT StepTemplateCode, Description FROM MasterFile.StepTemplate WHERE ISNULL(IsInactive,0)=0" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="StyleCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT StyleCode, Description FROM Masterfile.StyleTemplate WHERE ISNULL(IsInactive,0)=0" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="StepLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="ItemCategoryLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="ItemCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="ColorCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="SizeCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="CollectionLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ThemeCode, Description FROM Masterfile.Themes WHERE ISNULL(IsInactive,0)=0" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="DesignerLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT EmployeeCode, FirstName + LastName AS Name FROM Masterfile.BPEmployeeInfo WHERE ISNULL(IsInactive,0)=0" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="POMLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT POMCode, Description, Instruction FROM Masterfile.POM WHERE ISNULL(IsInactive,0)=0" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="ComponentCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="CompositionDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="SizeDetail2DataSource" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSizeDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT PISNumber, POMCode, SizeCode, Value, Tolerance, Bracket, Grade, Sorting AS [Order], IsMajor, LineNumber FROM Masterfile.PISStyleChart WHERE PISNumber is null" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="DISLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select DocNumber,Type from Production.DIS where ISNULL(SubmittedBy,'') !='' and ISNULL(SubmittedDate,'') !=''" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <!--#endregion-->
        </form>
</body>
</html>


