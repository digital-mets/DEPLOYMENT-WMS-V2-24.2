<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmInitialDPR.aspx.cs" Inherits="GWL.frmInitialDPR" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script><%--NEWADD--%>
    <title>Initial DPR</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 250px; /*Change this whenever needed*/
        }

        .Entry {
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
        }

        .dxeButtonEditSys input,
        .dxeTextBoxSys input {
            text-transform: uppercase;
        }

        .pnl-content {
            text-align: right;
        }
    </style>
    <!--#endregion-->

    <!--#region Region Javascript-->
    <script>

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        var entry = getParameterByName('entry');
        var useparam = getParameterByName("parameters");
        var isValid = false;
        var counterror = 0;
        var totalvat = 0;
        var totalnonvat = 0;



        var module = getParameterByName("transtype");
        var id = getParameterByName("docnumber");
        var entry = getParameterByName("entry");

        $(document).ready(function () {
            PerfStart(module, entry, id);
            //calculate_Input();
            //calculate_ProductionPlan();
            //calculate_ActualProduced();
            //calculate_FGGiveawaypercent();
            //calculate_CasingStd();

            //if (useparam == 'Resync'){
            //    recalculate();
            //}
        });

        function OnValidation(s, e) { //Validation function for header controls (Set this for each header controls)

            isValid = true;

            //if (s.GetText() == "" || e.value == "" || e.value == null) {
            //    counterror++;
            //    isValid = false
            //    s.GetMainElement().style.color = 'Pink';
            //    console.log(s);
            //}
            //else {
            //    isValid = true;
            //}
        }

        async function OnUpdateClick(s, e) { //Add/Edit/Close button function

            calculate_ProductionPlan();
            calculate_ActualProduced();
            calculate_FGGiveawaypercent();
            calculate_CasingStd();
            calculate_PlasticPackagingRej();
            calculate_CasingRej();
            calculate_CartonRej();
            //calculate_Theoretical();
            //calculate_RejectionSummaryTotal();
            calculate_RejectionSummaryPercent();

            //const variables1 = ["ProductionPlanDay", "ProductionPlanNight", "ProductionPlanTotal", "ActualProducedDay", "ActualProducedNight", "ActualProducedTotal", "PLTotal", "TipinDay", "TipinNight", "TipinTotal", "stdBatchWeight", "InputDay", "InputNight", "InputTotal", "BC", "PROyield", "AC", "CookingLoss", "SMYield", "PackagingInitialOutDay", "PackagingInitialOutNight", "PackagingInitialOutTotal", "RejectionSummarypercent", "RejectionSummarypercentTotal", "SMKHULUT", "BRINEULUT", "CUTTINGULUT", "PackagingULUT", "PackagingOSDF", "PackagingMISCUT", "FGGiveawaySTD", "FGGiveawayActual", "FGGiveawayPercent", "TotalYield", "StandaredYield", "StandardWTPStrand", "StandardCaseCon", "AVGKiloPPiece", "InitialYield", "Spillage1", "Spillage2", "Spillage3", "Spillage4", "Spillage5", "Spillage6", "SectionSAMPLE", "SpillageTotal"];
            //const variables2 = ["MEATStdUseMDM", "MEATStdUseTHEORETICAL", "MEATStdUseCOPACOL", "MEATStdUseFatA", "MEATStdUseEMERGING", "MEATStdUseBEEF", "MEATStdUseGroundMeat", "MEATActUseMDM", "MEATActUseTHEORETICAL", "MEATActUseCOPACOL", "MEATActUseFatA", "MEATActUseEMERGING", "MEATActUseBEEF", "MEATActUseGroundMeat", "CasingSKU", "CasingSTD", "CasingACT", "CasingREJ", "CasingTOTAL", "CasingDIFF", "PlasticPackagingSKU", "PlasticPackagingSTD", "PlasticPackagingACT", "PlasticPackagingREJ", "PlasticPackagingTOTAL", "PlasticPackagingDIFF", "CartonSKU", "CartonSTD", "CartonACT", "CartonREJ"];


            //await new Promise(resolve => setTimeout(resolve, 500));

            //var iMO = gv1.batchEditApi.GetRowVisibleIndices();
            //for (var h = 0; h < iMO.length; h++) {

            //    for (let i = 0; i < variables1.length; i++) {
            //        let variable = variables1[i];
            //        // Do something with the variable here
            //        var field = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], variable)); if (isNaN(field)) { gv1.batchEditApi.SetCellValue(iMO[h], variable, 0) }
            //        //console.log(variable + ':'+ gv1.batchEditApi.GetCellValue(iMO[h], variable));
            //    }
            //}
            //var iMO2 = gv2.batchEditApi.GetRowVisibleIndices();
            //for (var h = 0; h < iMO.length; h++) {
            //    for (let i = 0; i < variables2.length; i++) {
            //        let variable = variables1[i];
            //        // Do something with the variable here
            //        var field = parseFloat(gv2.batchEditApi.GetCellValue(iMO2[h], variable)); if (isNaN(field)) { gv2.batchEditApi.SetCellValue(iMO2[h], variable, 0) }
            //        //console.log(variable + ':' + gv2.batchEditApi.GetCellValue(iMO[h], variable));
            //    }
            //}

            var btnmode = btn.GetText(); //gets text of button
            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }
            console.log(isValid + ' ' + counterror);
            //emc999

            if (isValid || btnmode == "Close") { //check if there's no error then proceed to callback
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
                console.log(counterror);
            }
        }


        //function OnUpdateClick(s, e) { //Add/Edit/Close button function
        //    calculate_ProductionPlan();
        //    calculate_ActualProduced();
        //    calculate_FGGiveawaypercent();
        //    calculate_CasingStd();
        //    calculate_PlasticPackagingRej();
        //    calculate_CasingRej();
        //    calculate_CartonRej();
        //    calculate_Theoretical();
        //    calculate_RejectionSummaryTotal();

        //    const variables1 = ["ProductionPlanDay", "ProductionPlanNight", "ProductionPlanTotal", "ActualProducedDay", "ActualProducedNight", "ActualProducedTotal", "PLTotal", "TipinDay", "TipinNight", "TipinTotal", "stdBatchWeight", "InputDay", "InputNight", "InputTotal", "BC", "PROyield", "AC", "CookingLoss", "SMYield", "PackagingInitialOutDay", "PackagingInitialOutNight", "PackagingInitialOutTotal", "RejectionSummarypercent", "RejectionSummarypercentTotal", "SMKHULUT", "BRINEULUT", "CUTTINGULUT", "PackagingULUT", "PackagingOSDF", "PackagingMISCUT", "FGGiveawaySTD", "FGGiveawayActual", "FGGiveawayPercent", "TotalYield", "StandaredYield", "StandardWTPStrand", "StandardCaseCon", "AVGKiloPPiece", "InitialYield", "Spillage1", "Spillage2", "Spillage3", "Spillage4", "Spillage5", "Spillage6", "SectionSAMPLE", "SpillageTotal"];
        //    const variables2 = ["MEATStdUseMDM", "MEATStdUseTHEORETICAL", "MEATStdUseCOPACOL", "MEATStdUseFatA", "MEATStdUseEMERGING", "MEATStdUseBEEF", "MEATStdUseGroundMeat", "MEATActUseMDM", "MEATActUseTHEORETICAL", "MEATActUseCOPACOL", "MEATActUseFatA", "MEATActUseEMERGING", "MEATActUseBEEF", "MEATActUseGroundMeat", "CasingSKU", "CasingSTD", "CasingACT", "CasingREJ", "CasingTOTAL", "CasingDIFF", "PlasticPackagingSKU", "PlasticPackagingSTD", "PlasticPackagingACT", "PlasticPackagingREJ", "PlasticPackagingTOTAL", "PlasticPackagingDIFF", "CartonSKU", "CartonSTD", "CartonACT", "CartonREJ"];

        //    setTimeout(function () {

        //        var iMO = gv1.batchEditApi.GetRowVisibleIndices();
        //        for (var h = 0; h < iMO.length; h++) {

        //            for (let i = 0; i < variables1.length; i++) {
        //                let variable = variables1[i];
        //                // Do something with the variable here
        //                var field = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], variable)); if (isNaN(field)) { gv1.batchEditApi.SetCellValue(iMO[h], variable, 0) }
        //                console.log(variable + ':'+ gv1.batchEditApi.GetCellValue(iMO[h], variable));
        //            }
        //        }
        //        var iMO2 = gv2.batchEditApi.GetRowVisibleIndices();
        //        for (var h = 0; h < iMO.length; h++) {
        //            for (let i = 0; i < variables2.length; i++) {
        //                let variable = variables1[i];
        //                // Do something with the variable here
        //                var field = parseFloat(gv2.batchEditApi.GetCellValue(iMO2[h], variable)); if (isNaN(field)) { gv2.batchEditApi.SetCellValue(iMO2[h], variable, 0) }
        //                console.log(variable + ':' + gv2.batchEditApi.GetCellValue(iMO[h], variable));
        //            }
        //        }
        //    }, 10000);
          
             
        //    var btnmode = btn.GetText(); //gets text of button
        //    if (btnmode == "Delete") {
        //        cp.PerformCallback("Delete");
        //    }
        //    console.log(isValid + ' ' + counterror);
        //    //emc999



        //    if (isValid || btnmode == "Close") { //check if there's no error then proceed to callback
        //        //Sends request to server side
        //        if (btnmode == "Add") {
               
                 
        //            cp.PerformCallback("Add");
        //        }
        //        else if (btnmode == "Update") {
                 
        //            cp.PerformCallback("Update");
        //        }
        //        else if (btnmode == "Close") {
        //            cp.PerformCallback("Close");
        //        }
        //    }
        //    else {
        //        counterror = 0;
        //        alert('Please check all the fields!');
        //        console.log(counterror);
        //    }


        //}

        function OnQtyValidate(s, e) {
            if (s.GetValue() == 0 || e.value == 0 || e.value == null)
                e.isValid = false;
            else
                e.isValid = true;
        }

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        var vatrate = 0;
        var atc = 0
        var atc = 0
        var vatdetail1 = 0.00
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
            //if (s.cp_generated) {
            //    delete (s.cp_generated);
            //    console.log('daan')
            //    autocalculate();
            //    // cp.PerformCallback('vat');
            //}


            if (s.cp_vatdetail != null) {
                totalvat = s.cp_vatdetail;
                delete (s.cp_vatdetail);
                txtGrossVATableAmount.SetValue(totalvat);
                console.log('vat');
            }

            //if (s.cp_nonvatdetail != null) {
            //    totalnonvat = s.cp_nonvatdetail;
            //    delete (s.cp_nonvatdetail);
            //    txtnonvat.SetText(totalnonvat);
            //}
            //if(s.cp_vatrate !=null)
            //{
            //    console.log('amount')
            //    vatrate = s.cp_vatrate;
            //     vatdetail1 = 1 + parseFloat(vatrate);

            //    txtVatAmount.SetText(((txtGrossVATableAmount.GetText() / vatdetail1) * vatrate).toFixed(2))
            //}
            //if (s.cp_atc != null) {

            //    atc = s.cp_atc;

            //    txtWithHoldingTax.SetText(((txtGrossVATableAmount.GetText() - txtVatAmount.GetText()) * atc).toFixed(2))
            //}

            if (s.cp_isclassa == "1") {

                autocalculate(s, e)
                generate1 = true;

            }
            else {

                autocalculate(s, e)
                generate1 = false;
            }

            if (s.cp_Resync) {

                delete (s.cp_generated);
                window.location.reload();
                //window.open ('../Production/frmInitialDPR.aspx?entry='+entry+'&transtype='+module+'&parameters=Resync&iswithdetail=null&docnumber='+id+'','_self');
            }


            if (s.cp_generated) {
                delete (s.cp_generated);
                if (s.cp_message != null) {
                    alert(s.cp_message);
                    delete (s.cp_message);

                    gv1.CancelEdit();
                    var _indices = gv1.batchEditApi.GetRowVisibleIndices();

                    for (var i = 0; i < _indices.length; i++) {
                        gv1.DeleteRow(_indices[i]);
                    }
                    gv2.CancelEdit();
                    var _indices = gv2.batchEditApi.GetRowVisibleIndices();

                    for (var i = 0; i < _indices.length; i++) {
                        gv2.DeleteRow(_indices[i]);
                    }

                }
                else{
                        //console.log('test');
                        //BATCH DETAIL
                        gv1.CancelEdit();
                        var _indices = gv1.batchEditApi.GetRowVisibleIndices();

                        for (var i = 0; i < _indices.length; i++) {
                            gv1.DeleteRow(_indices[i]);
                        }

                        var _refindices = gv3.batchEditApi.GetRowVisibleIndices();

                        for (var i = 0; i < _refindices.length; i++) {
                            gv1.AddNewRow();
                            _indices = gv1.batchEditApi.GetRowVisibleIndices();

                            gv1.batchEditApi.SetCellValue(_indices[0], 'SmokeHouseNo', gv3.batchEditApi.GetCellValue(_refindices[i], 'SmokeHouseNo'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'BatchNo', gv3.batchEditApi.GetCellValue(_refindices[i], 'BatchNo'));


                            gv1.batchEditApi.SetCellValue(_indices[0], 'ItemCode', gv3.batchEditApi.GetCellValue(_refindices[i], 'ItemDescription'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'ItemC', gv3.batchEditApi.GetCellValue(_refindices[i], 'SKU'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'ItemDescription', gv3.batchEditApi.GetCellValue(_refindices[i], 'ItemDescription'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'ProductionPlanDay', gv3.batchEditApi.GetCellValue(_refindices[i], 'ProductionPlanDay'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'ProductionPlanNight', gv3.batchEditApi.GetCellValue(_refindices[i], 'ProductionPlanNight'));
                   
                            gv1.batchEditApi.SetCellValue(_indices[0], 'ActualProducedDay', gv3.batchEditApi.GetCellValue(_refindices[i], 'ActualProducedDay'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'ActualProducedNight', gv3.batchEditApi.GetCellValue(_refindices[i], 'ActualProducedNight'));
                    
                            gv1.batchEditApi.SetCellValue(_indices[0], 'TipinDay', gv3.batchEditApi.GetCellValue(_refindices[i], 'TipinDay'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'TipinNight', gv3.batchEditApi.GetCellValue(_refindices[i], 'TipinNight'));
                    
                            gv1.batchEditApi.SetCellValue(_indices[0], 'stdBatchWeight', gv3.batchEditApi.GetCellValue(_refindices[i], 'stdBatchWeight'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'InputDay', gv3.batchEditApi.GetCellValue(_refindices[i], 'InputDay'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'InputNight', gv3.batchEditApi.GetCellValue(_refindices[i], 'InputNight'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'InputNight', gv3.batchEditApi.GetCellValue(_refindices[i], 'InputTotal'));
                  
                            gv1.batchEditApi.SetCellValue(_indices[0], 'BC', gv3.batchEditApi.GetCellValue(_refindices[i], 'BC'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'PROyield', gv3.batchEditApi.GetCellValue(_refindices[i], 'PROyield'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'AC', gv3.batchEditApi.GetCellValue(_refindices[i], 'AC'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'CookingLoss', gv3.batchEditApi.GetCellValue(_refindices[i], 'CookingLoss'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'SMYield', gv3.batchEditApi.GetCellValue(_refindices[i], 'SMYield'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'PackagingInitialOutDay', gv3.batchEditApi.GetCellValue(_refindices[i], 'PackagingInitialOutDay'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'PackagingInitialOutNight', gv3.batchEditApi.GetCellValue(_refindices[i], 'PackagingInitialOutNight'));
              
                            gv1.batchEditApi.SetCellValue(_indices[0], 'RejectionSummarypercent', gv3.batchEditApi.GetCellValue(_refindices[i], 'RejectionSummarypercent'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'RejectionSummarypercentTotal', gv3.batchEditApi.GetCellValue(_refindices[i], 'RejectionSummarypercentTotal'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'SMKHULUT', gv3.batchEditApi.GetCellValue(_refindices[i], 'SMKHULUT'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'BRINEULUT', gv3.batchEditApi.GetCellValue(_refindices[i], 'BRINEULUT'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'CUTTINGULUT', gv3.batchEditApi.GetCellValue(_refindices[i], 'CUTTINGULUT'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'PackagingULUT', gv3.batchEditApi.GetCellValue(_refindices[i], 'PackagingULUT'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'PackagingOSDF', gv3.batchEditApi.GetCellValue(_refindices[i], 'PackagingOSDF'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'PackagingMISCUT', gv3.batchEditApi.GetCellValue(_refindices[i], 'PackagingMISCUT'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'FGGiveawaySTD', gv3.batchEditApi.GetCellValue(_refindices[i], 'FGGiveawaySTD'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'FGGiveawayActual', gv3.batchEditApi.GetCellValue(_refindices[i], 'FGGiveawayActual'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'FGGiveawayPercent', gv3.batchEditApi.GetCellValue(_refindices[i], 'FGGiveawayPercent'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'TotalYield', gv3.batchEditApi.GetCellValue(_refindices[i], 'TotalYield'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'StandardWTPStrand', gv3.batchEditApi.GetCellValue(_refindices[i], 'StandardWTPStrand'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'AVGWrange', gv3.batchEditApi.GetCellValue(_refindices[i], 'AVGWrange'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'StandaredYield', gv3.batchEditApi.GetCellValue(_refindices[i], 'StandaredYield'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'StandardCaseCon', gv3.batchEditApi.GetCellValue(_refindices[i], 'StandardCaseCon'));
                            /*gv1.batchEditApi.SetCellValue(_indices[0], 'AVGKiloPPiece', gv3.batchEditApi.GetCellValue(_refindices[i], 'AVGKiloPPiece'));*/
                            var avgKiloPPiece = gv3.batchEditApi.GetCellValue(_refindices[i], 'AVGKiloPPiece');
                            if ((avgKiloPPiece == "" || avgKiloPPiece == '' || isNaN(avgKiloPPiece) || avgKiloPPiece == null || avgKiloPPiece == "          " || avgKiloPPiece == '          ')) {
                                avgKiloPPiece = 0;
                            }
                            gv1.batchEditApi.SetCellValue(_indices[0], 'AVGKiloPPiece', avgKiloPPiece);
                            gv1.batchEditApi.SetCellValue(_indices[0], 'SpillageTotal', gv3.batchEditApi.GetCellValue(_refindices[i], 'SpillageTotal'));

                   
                      
                
                            //gv1.batchEditApi.SetCellValue(_indices[0], 'ITAcooking', gv3.batchEditApi.GetCellValue(_refindices[i], 'ITAcooking'));
                
                            gv1.batchEditApi.EndEdit();
                            //END BATCH DETAIL
                        }
                         //COOKING DETAIL


                            gv2.CancelEdit();
                            var _indices = gv2.batchEditApi.GetRowVisibleIndices();

                            for (var i = 0; i < _indices.length; i++) {
                                gv2.DeleteRow(_indices[i]);
                            }

                            var _refindices = gv4.batchEditApi.GetRowVisibleIndices();

                            for (var i = 0; i < _refindices.length; i++) {
                                gv2.AddNewRow();
                                _indices = gv2.batchEditApi.GetRowVisibleIndices();

                                gv2.batchEditApi.SetCellValue(_indices[0], 'CookingStage', gv4.batchEditApi.GetCellValue(_refindices[i], 'CookingStage'));
                     
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'STDcooking', gv4.batchEditApi.GetCellValue(_refindices[i], 'STDcooking'));

                                //gv2.batchEditApi.SetCellValue(_indices[0], 'TimeStart', gv4.batchEditApi.GetCellValue(_refindices[i], 'TimeStart'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'TimeEnd', gv4.batchEditApi.GetCellValue(_refindices[i], 'TimeEnd'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'StdST', gv4.batchEditApi.GetCellValue(_refindices[i], 'StdST'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'ActualST', gv4.batchEditApi.GetCellValue(_refindices[i], 'ActualST'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'StdH', gv4.batchEditApi.GetCellValue(_refindices[i], 'StdH'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'ActualH', gv4.batchEditApi.GetCellValue(_refindices[i], 'ActualH'));
                                

                                gv2.batchEditApi.SetCellValue(_indices[0], 'ItemC', gv4.batchEditApi.GetCellValue(_refindices[i], 'SKU'));
                                gv2.batchEditApi.SetCellValue(_indices[0], 'ItemDescription', gv4.batchEditApi.GetCellValue(_refindices[i], 'ItemDescription'));


                                gv2.batchEditApi.SetCellValue(_indices[0], 'MEATStdUseMDM', gv4.batchEditApi.GetCellValue(_refindices[i], 'MEATStdUseMDM'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'MEATStdUseTHEORETICAL', gv4.batchEditApi.GetCellValue(_refindices[i], 'MEATStdUseTHEORETICAL'));
                                gv2.batchEditApi.SetCellValue(_indices[0], 'MEATStdUseCOPACOL', gv4.batchEditApi.GetCellValue(_refindices[i], 'MEATStdUseCOPACOL'));
                                gv2.batchEditApi.SetCellValue(_indices[0], 'MEATStdUseFatA', gv4.batchEditApi.GetCellValue(_refindices[i], 'MEATStdUseFatA'));
                                gv2.batchEditApi.SetCellValue(_indices[0], 'MEATStdUseEMERGING', gv4.batchEditApi.GetCellValue(_refindices[i], 'MEATStdUseEMERGING'));
                                gv2.batchEditApi.SetCellValue(_indices[0], 'MEATStdUseBEEF', gv4.batchEditApi.GetCellValue(_refindices[i], 'MEATStdUseBEEF'));
                                gv2.batchEditApi.SetCellValue(_indices[0], 'MEATStdUseGroundMeat', gv4.batchEditApi.GetCellValue(_refindices[i], 'MEATStdUseGroundMeat'));



                                //gv2.batchEditApi.SetCellValue(_indices[0], 'MEATActUseMDM', gv4.batchEditApi.GetCellValue(_refindices[i], 'MEATActUseMDM'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'MEATActUseTHEORETICAL', gv4.batchEditApi.GetCellValue(_refindices[i], 'MEATActUseTHEORETICAL'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'MEATActUseCOPACOL', gv4.batchEditApi.GetCellValue(_refindices[i], 'MEATActUseCOPACOL'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'MEATActUseFatA', gv4.batchEditApi.GetCellValue(_refindices[i], 'MEATActUseFatA'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'MEATActUseEMERGING', gv4.batchEditApi.GetCellValue(_refindices[i], 'MEATActUseEMERGING'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'MEATActUseBEEF', gv4.batchEditApi.GetCellValue(_refindices[i], 'MEATActUseBEEF'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'MEATActUseGroundMeat', gv4.batchEditApi.GetCellValue(_refindices[i], 'MEATActUseGroundMeat'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'CasingSTD', gv4.batchEditApi.GetCellValue(_refindices[i], 'CasingSTD'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'CasingACT', gv4.batchEditApi.GetCellValue(_refindices[i], 'CasingACT'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'CasingREJ', gv4.batchEditApi.GetCellValue(_refindices[i], 'CasingREJ'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'CasingDIFF', gv4.batchEditApi.GetCellValue(_refindices[i], 'CasingDIFF'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'PlasticPackagingSTD', gv4.batchEditApi.GetCellValue(_refindices[i], 'PlasticPackagingSTD'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'PlasticPackagingACT', gv4.batchEditApi.GetCellValue(_refindices[i], 'PlasticPackagingACT'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'PlasticPackagingREJ', gv4.batchEditApi.GetCellValue(_refindices[i], 'PlasticPackagingREJ'));
                                //gv2.batchEditApi.SetCellValue(_indices[0], 'PlasticPackagingDIFF', gv4.batchEditApi.GetCellValue(_refindices[i], 'PlasticPackagingDIFF'));
                

                                gv2.batchEditApi.EndEdit();
                   
                                //END COOKING DETAIL
                            //console.log('test ok');
                            }
                    calculate();
                            
                          
                        }
            }

        }

        function UpdateCooking(values) {
            Cooking = values[0];
            //console.log(Cooking);
            //gv1.batchEditApi.SetCellValue(index, "CookingStage", values[0]);

            ActualProducedNight
        }

        // Auto Calculate 
        function calculate_InitialYield(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        PackagingInitialOutTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingInitialOutTotal"));
                      /*  FGGiveawaySTD = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "FGGiveawaySTD")); */
                        InputTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputTotal"));

                        if (PackagingInitialOutTotal == "" || PackagingInitialOutTotal == '' || isNaN(PackagingInitialOutTotal) || PackagingInitialOutTotal == null) {
                            PackagingInitialOutTotal = 0;
                        }
                        if (FGGiveawaySTD == "" || FGGiveawaySTD == '' || isNaN(FGGiveawaySTD) || FGGiveawaySTD == null) {
                            FGGiveawaySTD = 0;
                        }
                        if (InputTotal == "" || InputTotal == '' || isNaN(InputTotal) || InputTotal == null) {
                            InputTotal = 0;
                        }
                        
                        //if (PackagingInitialOutTotal == 0 || FGGiveawaySTD == 0 || InputTotal == 0) {
                        //    gv1.batchEditApi.SetCellValue(iMO[h], "InitialYield", 0);
                        //}
                        if (PackagingInitialOutTotal == 0 || InputTotal == 0) {
                            gv1.batchEditApi.SetCellValue(iMO[h], "InitialYield", 0);
                        }
                        else {
                            //var Tota = PackagingInitialOutTotal * FGGiveawaySTD;
                            //var Total = (Tota / InputTotal) * 100;
                           
                            var Total = (PackagingInitialOutTotal / InputTotal) * 100;
                          
                            gv1.batchEditApi.SetCellValue(iMO[h], "InitialYield", Total);
                        }
                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            PackagingInitialOutTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingInitialOutTotal"));
                            /*FGGiveawaySTD = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "FGGiveawaySTD"));*/
                            InputTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputTotal"));

                            if (PackagingInitialOutTotal == "" || PackagingInitialOutTotal == '' || isNaN(PackagingInitialOutTotal) || PackagingInitialOutTotal == null) {
                                PackagingInitialOutTotal = 0;
                            }
                            if (FGGiveawaySTD == "" || FGGiveawaySTD == '' || isNaN(FGGiveawaySTD) || FGGiveawaySTD == null) {
                                FGGiveawaySTD = 0;
                            }
                            if (InputTotal == "" || InputTotal == '' || isNaN(InputTotal) || InputTotal == null) {
                                InputTotal = 0;
                            }


                            //if (PackagingInitialOutTotal == 0 || FGGiveawaySTD == 0 || InputTotal == 0) {
                            //    gv1.batchEditApi.SetCellValue(iMO[h], "InitialYield", 0);
                            //}
                            if (PackagingInitialOutTotal == 0 || InputTotal == 0) {
                                gv1.batchEditApi.SetCellValue(iMO[h], "InitialYield", 0);
                            }
                            else {
                                //var Tota = PackagingInitialOutTotal * FGGiveawaySTD;
                                //var Total = (Tota / InputTotal) * 100;

                                var Total = (PackagingInitialOutTotal / InputTotal) * 100;
                           
                                gv1.batchEditApi.SetCellValue(iMO[h], "InitialYield", Total);
                            }
                            

                        }
                    }
                }
            }, 500);
            
            calculate_CasingStd();
            //calculate_PlasticPackaging();
            calculate_TotalYield();

            
        }


        function calculate_TotalYield(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        InitialYield = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InitialYield"));
                        CookingLoss = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "CookingLoss"));
                        RejectionSummarypercent = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "RejectionSummarypercent"));
                        FGGiveawayPercent = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "FGGiveawayPercent"));

                        if (InitialYield == "" || InitialYield == '' || isNaN(InitialYield) || InitialYield == null) {
                            InitialYield = 0;
                        }
                        if (CookingLoss == "" || CookingLoss == '' || isNaN(CookingLoss) || CookingLoss == null) {
                            CookingLoss = 0;
                        }
                        if (RejectionSummarypercent == "" || RejectionSummarypercent == '' || isNaN(RejectionSummarypercent) || RejectionSummarypercent == null) {
                            RejectionSummarypercent = 0;
                        }
                        if (FGGiveawayPercent == "" || FGGiveawayPercent == '' || isNaN(FGGiveawayPercent) || FGGiveawayPercent == null) {
                            FGGiveawayPercent = 0;
                        }

                  
                        var Total = InitialYield + CookingLoss + RejectionSummarypercent + FGGiveawayPercent;
                        gv1.batchEditApi.SetCellValue(iMO[h], "TotalYield", Total);
                        
                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            InitialYield = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InitialYield"));
                            CookingLoss = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "CookingLoss"));
                            RejectionSummarypercent = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "RejectionSummarypercent"));
                            FGGiveawayPercent = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "FGGiveawayPercent"));

                            if (InitialYield == "" || InitialYield == '' || isNaN(InitialYield) || InitialYield == null) {
                                InitialYield = 0;
                            }
                            if (CookingLoss == "" || CookingLoss == '' || isNaN(CookingLoss) || CookingLoss == null) {
                                CookingLoss = 0;
                            }
                            if (RejectionSummarypercent == "" || RejectionSummarypercent == '' || isNaN(RejectionSummarypercent) || RejectionSummarypercent == null) {
                                RejectionSummarypercent = 0;
                            }
                            if (FGGiveawayPercent == "" || FGGiveawayPercent == '' || isNaN(FGGiveawayPercent) || FGGiveawayPercent == null) {
                                FGGiveawayPercent = 0;
                            }


                            var Total = InitialYield + CookingLoss + RejectionSummarypercent + FGGiveawayPercent;
                            gv1.batchEditApi.SetCellValue(iMO[h], "TotalYield", Total);


                        }
                    }
                }
            }, 500);

        }


        function calculate_ProductionPlan(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {      
                        Day = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ProductionPlanDay"));
                        Night = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ProductionPlanNight"));
                       
                        if (Day == "" || Day == '' || isNaN(Day) || Day == null) {
                            Day = 0;
                        }
                        if (Night == "" || Night == '' || isNaN(Night) || Night == null) {
                            Night = 0;
                        }
                        var Total = Day + Night;
                        gv1.batchEditApi.SetCellValue(iMO[h], "ProductionPlanTotal", Total);
                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {        
                            Day = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ProductionPlanDay"));
                            Night = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ProductionPlanNight"));

                            if (Day == "" || Day == '' || isNaN(Day) || Day == null) {
                                Day = 0;
                            }
                            if (Night == "" || Night == '' || isNaN(Night) || Night == null) {
                                Night = 0;
                            }
                            var Total = Day + Night;
                            gv1.batchEditApi.SetCellValue(iMO[h], "ProductionPlanTotal", Total);

                        }
                    }
                }      
            }, 500);
        }
        // RCD ADD for Section Column
        function calculate_ActualProduced(s, e) {


            //var Day = 0, Night = 0, Total = 0;
            //setTimeout(function () {
            //    var iMO = gv1.batchEditApi.GetRowVisibleIndices();
            //    for (var h = 0; h < iMO.length; h++) {
            //        if (gv1.batchEditApi.IsNewRow(iMO[h])) {
            //            Day = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ActualProducedDay"));
            //            Night = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ActualProducedNight"));

            //            if (Day == "" || Day == '' || isNaN(Day) || Day == null) {
            //                Day = 0;
            //            }
            //            if (Night == "" || Night == '' || isNaN(Night) || Night == null) {
            //                Night = 0;
            //            }
            //            var Total = Day + Night;
            //            gv1.batchEditApi.SetCellValue(iMO[h], "ActualProducedTotal", Total);
            //        }
            //        else {
            //            var key = gv1.GetRowKey(iMO[h]);
            //            if (gv1.batchEditApi.IsDeletedRow(key)) { }
            //            else {
            //                Day = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ActualProducedDay"));
            //                Night = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ActualProducedNight"));

            //                if (Day == "" || Day == '' || isNaN(Day) || Day == null) {
            //                    Day = 0;
            //                }
            //                if (Night == "" || Night == '' || isNaN(Night) || Night == null) {
            //                    Night = 0;
            //                }
            //                var Total = Day + Night;
            //                gv1.batchEditApi.SetCellValue(iMO[h], "ActualProducedTotal", Total);

            //            }
            //        }
            //    }
            //}, 500);
            //calculate_InputNight();
            //calculate_InputDay();
            calculate_Input();
            //calculate_Section();
        }
        //function calculate_Tipin(s, e) {


        //    var Day = 0, Night = 0, Total = 0;
        //    setTimeout(function () {
        //        var iMO = gv1.batchEditApi.GetRowVisibleIndices();
        //        for (var h = 0; h < iMO.length; h++) {
        //            if (gv1.batchEditApi.IsNewRow(iMO[h])) {
        //                Day = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TipinDay"));
        //                Night = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TipinNight"));

        //                if (Day == "" || Day == '' || isNaN(Day) || Day == null) {
        //                    Day = 0;
        //                }
        //                if (Night == "" || Night == '' || isNaN(Night) || Night == null) {
        //                    Night = 0;
        //                }
        //                var Total = Day + Night;
        //                gv1.batchEditApi.SetCellValue(iMO[h], "TipinTotal", Total);
        //            }
        //            else {
        //                var key = gv1.GetRowKey(iMO[h]);
        //                if (gv1.batchEditApi.IsDeletedRow(key)) { }
        //                else {
        //                    Day = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TipinDay"));
        //                    Night = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TipinNight"));

        //                    if (Day == "" || Day == '' || isNaN(Day) || Day == null) {
        //                        Day = 0;
        //                    }
        //                    if (Night == "" || Night == '' || isNaN(Night) || Night == null) {
        //                        Night = 0;
        //                    }
        //                    var Total = Day + Night;
        //                    gv1.batchEditApi.SetCellValue(iMO[h], "TipinTotal", Total);

        //                }
        //            }
        //        }
        //    }, 500);
        //    //calculate_InputNight();
        //    //calculate_InputDay();
        //    calculate_Input();
        //}
        function calculate_Input(s, e) {


            //var Day = 0, Night = 0, Total = 0 , Spillagetotal = 0;
            //setTimeout(function () {
            //    var iMO = gv1.batchEditApi.GetRowVisibleIndices();
            //    for (var h = 0; h < iMO.length; h++) {
            //        if (gv1.batchEditApi.IsNewRow(iMO[h])) {
            //            Day = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputDay"));
            //            Night = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputNight"));
            //            Spillagetotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "SpillageTotal"));
            //            if (Day == "" || Day == '' || isNaN(Day) || Day == null) {
            //                Day = 0;
            //            }
            //            if (Night == "" || Night == '' || isNaN(Night) || Night == null) {
            //                Night = 0;
            //            }

            //            if (Spillagetotal == "" || Spillagetotal == '' || isNaN(Spillagetotal) || Spillagetotal == null) {
            //                Spillagetotal = 0;
            //            }
            //            var Total = Day + Night;
            //            gv1.batchEditApi.SetCellValue(iMO[h], "InputTotal", Total + Spillagetotal);
            //        }
            //        else {
            //            var key = gv1.GetRowKey(iMO[h]);
            //            if (gv1.batchEditApi.IsDeletedRow(key)) { }
            //            else {
            //                Day = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputDay"));
            //                Night = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputNight"));
            //                Spillagetotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "SpillageTotal"));
            //                if (Day == "" || Day == '' || isNaN(Day) || Day == null) {
            //                    Day = 0;
            //                }
            //                if (Night == "" || Night == '' || isNaN(Night) || Night == null) {
            //                    Night = 0;
            //                }
            //                if (Spillagetotal == "" || Spillagetotal == '' || isNaN(Spillagetotal) || Spillagetotal == null) {
            //                    Spillagetotal = 0;
            //                }
            //                var Total = Day + Night;
            //                gv1.batchEditApi.SetCellValue(iMO[h], "InputTotal", Total + Spillagetotal);

            //            }
            //        }
            //    }
            //}, 500);
            var stdBatchWeight = 0, ActualProducedTotal = 0, Total = 0, Spillagetotal = 0, TipinTotal = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        stdBatchWeight = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "stdBatchWeight"));
                        ActualProducedTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ActualProducedTotal"));
                        Night = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TipinNight"));
                        TipinTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TipinTotal"));
                       /* Spillagetotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "SpillageTotal")); */
                        MEATActUseMDM = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "MEATActUseMDM")); 
                        MEATActUseCOPACOL = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "MEATActUseCOPACOL")); 
                        MEATActUseFatA = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "MEATActUseFatA"));
                        MEATActUseBEEF = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "MEATActUseBEEF")); 


                        if (stdBatchWeight == "" || stdBatchWeight == '' || isNaN(stdBatchWeight) || stdBatchWeight == null) {
                            stdBatchWeight = 0;
                        }
                        if (ActualProducedTotal == "" || ActualProducedTotal == '' || isNaN(ActualProducedTotal) || ActualProducedTotal == null) {
                            ActualProducedTotal = 0;
                        }
                        if (Night == "" || Night == '' || isNaN(Night) || Night == null) {
                            Night = 0;
                        }
                        if (TipinTotal == "" || TipinTotal == '' || isNaN(TipinTotal) || TipinTotal == null) {
                            TipinTotal = 0;
                        }
                        
                        if (MEATActUseMDM == "" || MEATActUseMDM == '' || isNaN(MEATActUseMDM) || MEATActUseMDM == null) {
                            MEATActUseMDM = 0;
                        }
                        if (MEATActUseCOPACOL == "" || MEATActUseCOPACOL == '' || isNaN(MEATActUseCOPACOL) || MEATActUseCOPACOL == null) {
                            MEATActUseCOPACOL = 0;
                        }
                        if (MEATActUseFatA == "" || MEATActUseFatA == '' || isNaN(MEATActUseFatA) || MEATActUseFatA == null) {
                            MEATActUseFatA = 0;
                        }
                        if (MEATActUseBEEF == "" || MEATActUseBEEF == '' || isNaN(MEATActUseBEEF) || MEATActUseBEEF == null) {
                            MEATActUseBEEF = 0;
                        }
                       var Spillagetotal = MEATActUseMDM + MEATActUseCOPACOL + MEATActUseFatA + MEATActUseBEEF;
                       var Total = (stdBatchWeight * ActualProducedTotal) + Night + TipinTotal;
                        gv1.batchEditApi.SetCellValue(iMO[h], "InputTotal", Total + Spillagetotal);
                     
                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            stdBatchWeight = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "stdBatchWeight"));
                            ActualProducedTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ActualProducedTotal"));
                            Night = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TipinNight"));
                            TipinTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TipinTotal"));
                            /* Spillagetotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "SpillageTotal")); */
                            MEATActUseMDM = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "MEATActUseMDM"));
                            MEATActUseCOPACOL = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "MEATActUseCOPACOL"));
                            MEATActUseFatA = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "MEATActUseFatA"));
                            MEATActUseBEEF = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "MEATActUseBEEF")); 


                            if (stdBatchWeight == "" || stdBatchWeight == '' || isNaN(stdBatchWeight) || stdBatchWeight == null) {
                                stdBatchWeight = 0;
                            }
                            if (ActualProducedTotal == "" || ActualProducedTotal == '' || isNaN(ActualProducedTotal) || ActualProducedTotal == null) {
                                ActualProducedTotal = 0;
                            }
                            if (Night == "" || Night == '' || isNaN(Night) || Night == null) {
                                Night = 0;
                            }
                            if (TipinTotal == "" || TipinTotal == '' || isNaN(TipinTotal) || TipinTotal == null) {
                                TipinTotal = 0;
                            }

                            if (MEATActUseMDM == "" || MEATActUseMDM == '' || isNaN(MEATActUseMDM) || MEATActUseMDM == null) {
                                MEATActUseMDM = 0;
                            }
                            if (MEATActUseCOPACOL == "" || MEATActUseCOPACOL == '' || isNaN(MEATActUseCOPACOL) || MEATActUseCOPACOL == null) {
                                MEATActUseCOPACOL = 0;
                            }
                            if (MEATActUseFatA == "" || MEATActUseFatA == '' || isNaN(MEATActUseFatA) || MEATActUseFatA == null) {
                                MEATActUseFatA = 0;
                            }
                            if (MEATActUseBEEF == "" || MEATActUseBEEF == '' || isNaN(MEATActUseBEEF) || MEATActUseBEEF == null) {
                                MEATActUseBEEF = 0;
                            }
                           var Spillagetotal = MEATActUseMDM + MEATActUseCOPACOL + MEATActUseFatA + MEATActUseBEEF;
                           var Total = (stdBatchWeight * ActualProducedTotal) + Night + TipinTotal;
                            gv1.batchEditApi.SetCellValue(iMO[h], "InputTotal", Total + Spillagetotal);
                         
                        }
                    }
                }
            }, 500);

            calculate_CasingStd();
            //calculate_PlasticPackaging();
            calculate_ProYield();
            calculate_RejectionSummaryPercent();
            calculate_InitialYield();
            //calculate_Section();
        }

        //function calculate_InputDay(s, e) {


        //    var Day = 0, Night = 0, Total = 0;
        //    setTimeout(function () {
        //        var iMO = gv1.batchEditApi.GetRowVisibleIndices();
        //        for (var h = 0; h < iMO.length; h++) {
        //            if (gv1.batchEditApi.IsNewRow(iMO[h])) {
        //                stdBatchWeight = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "stdBatchWeight"));
        //                ActualProducedDay = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ActualProducedDay"));
        //                TipinDay = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TipinDay"));

        //                if (stdBatchWeight == "" || stdBatchWeight == '' || isNaN(stdBatchWeight) || stdBatchWeight == null) {
        //                    stdBatchWeight = 0;
        //                }
        //                if (ActualProducedDay == "" || ActualProducedDay == '' || isNaN(ActualProducedDay) || ActualProducedDay == null) {
        //                    ActualProducedDay = 0;
        //                }
        //                if (TipinDay == "" || TipinDay == '' || isNaN(TipinDay) || TipinDay == null) {
        //                    TipinDay = 0;
        //                }
        //                var Total = (stdBatchWeight * ActualProducedDay) + TipinDay;
        //                gv1.batchEditApi.SetCellValue(iMO[h], "InputDay", Total);
        //            }
        //            else {
        //                var key = gv1.GetRowKey(iMO[h]);
        //                if (gv1.batchEditApi.IsDeletedRow(key)) { }
        //                else {
        //                    stdBatchWeight = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "stdBatchWeight"));
        //                    ActualProducedDay = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ActualProducedDay"));
        //                    TipinDay = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TipinDay"));

        //                    if (stdBatchWeight == "" || stdBatchWeight == '' || isNaN(stdBatchWeight) || stdBatchWeight == null) {
        //                        stdBatchWeight = 0;
        //                    }
        //                    if (ActualProducedDay == "" || ActualProducedDay == '' || isNaN(ActualProducedDay) || ActualProducedDay == null) {
        //                        ActualProducedDay = 0;
        //                    }
        //                    if (TipinDay == "" || TipinDay == '' || isNaN(TipinDay) || TipinDay == null) {
        //                        TipinDay = 0;
        //                    }
        //                    var Total = (stdBatchWeight * ActualProducedDay) + TipinDay;
        //                    gv1.batchEditApi.SetCellValue(iMO[h], "InputDay", Total);

        //                }
        //            }
        //        }
        //    }, 500);
        //    calculate_Input();
        //}

        //function calculate_InputNight(s, e) {


        //    var Day = 0, Night = 0, Total = 0;
        //    setTimeout(function () {
        //        var iMO = gv1.batchEditApi.GetRowVisibleIndices();
        //        for (var h = 0; h < iMO.length; h++) {
        //            if (gv1.batchEditApi.IsNewRow(iMO[h])) {
        //                stdBatchWeight = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "stdBatchWeight"));
        //                ActualProducedNight = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ActualProducedNight"));
        //                TipinNight = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TipinNight"));

        //                if (stdBatchWeight == "" || stdBatchWeight == '' || isNaN(stdBatchWeight) || stdBatchWeight == null) {
        //                    stdBatchWeight = 0;
        //                }
        //                if (ActualProducedNight == "" || ActualProducedNight == '' || isNaN(ActualProducedNight) || ActualProducedNight == null) {
        //                    ActualProducedNight = 0;
        //                }
        //                if (TipinNight == "" || TipinNight == '' || isNaN(TipinNight) || TipinNight == null) {
        //                    TipinNight = 0;
        //                }
        //                var Total = (stdBatchWeight * ActualProducedNight) + TipinNight;
        //                gv1.batchEditApi.SetCellValue(iMO[h], "InputNight", Total);
        //            }
        //            else {
        //                var key = gv1.GetRowKey(iMO[h]);
        //                if (gv1.batchEditApi.IsDeletedRow(key)) { }
        //                else {
        //                    stdBatchWeight = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "stdBatchWeight"));
        //                    ActualProducedNight = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ActualProducedNight"));
        //                    TipinNight = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "TipinNight"));

        //                    if (stdBatchWeight == "" || stdBatchWeight == '' || isNaN(stdBatchWeight) || stdBatchWeight == null) {
        //                        stdBatchWeight = 0;
        //                    }
        //                    if (ActualProducedNight == "" || ActualProducedNight == '' || isNaN(ActualProducedNight) || ActualProducedNight == null) {
        //                        ActualProducedNight = 0;
        //                    }
        //                    if (TipinNight == "" || TipinNight == '' || isNaN(TipinNight) || TipinNight == null) {
        //                        TipinNight = 0;
        //                    }
        //                    var Total = (stdBatchWeight * ActualProducedNight) + TipinNight;
        //                    gv1.batchEditApi.SetCellValue(iMO[h], "InputNight", Total);

        //                }
        //            }
        //        }
        //    }, 500);
        //    calculate_Input();
        //}


        function calculate_PackagingInitial(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        Day = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingInitialOutDay"));
                        Night = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingInitialOutNight"));
                        AVGWrange = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "AVGWrange"));
                        if (Day == "" || Day == '' || isNaN(Day) || Day == null) {
                            Day = 0;
                        }

                        if (Night == "" || Night == '' || isNaN(Night) || Night == null) {
                            Night = 0;
                        }
                        if (AVGWrange == "" || AVGWrange == '' || isNaN(AVGWrange) || AVGWrange == null) {
                            AVGWrange = 0;
                        }
                        var Total = (Day + Night) * AVGWrange;
                      
                        gv1.batchEditApi.SetCellValue(iMO[h], "PackagingInitialOutTotal", Total);
                        
                        gv1.batchEditApi.SetCellValue(iMO[h], "PackagingInitialOutTotalPkcs", Day + Night);
                        gv2.batchEditApi.SetCellValue(iMO[h], "PlasticPackagingSTD", Day + Night);
                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            Day = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingInitialOutDay"));
                            Night = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingInitialOutNight"));
                            AVGWrange = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "AVGWrange"));
                            if (Day == "" || Day == '' || isNaN(Day) || Day == null) {
                                Day = 0;
                            }
                            if (Night == "" || Night == '' || isNaN(Night) || Night == null) {
                                Night = 0;
                            }
                            if (AVGWrange == "" || AVGWrange == '' || isNaN(AVGWrange) || AVGWrange == null) {
                                AVGWrange = 0;
                            }
                            var Total = (Day + Night) * AVGWrange;
                        
                            gv1.batchEditApi.SetCellValue(iMO[h], "PackagingInitialOutTotal", Total);
                            
                            gv1.batchEditApi.SetCellValue(iMO[h], "PackagingInitialOutTotalPkcs", Day + Night);
                            gv2.batchEditApi.SetCellValue(iMO[h], "PlasticPackagingSTD", Day + Night);
                        }
                    }
                }
            }, 500);
            calculate_CartonStd();
        }
        function calculate_Theoretical(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        MDM = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "MEATStdUseMDM"));
                        Total = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ActualProducedTotal"));

                        if (MDM == "" || MDM == '' || isNaN(MDM) || MDM == null) {
                            MDM = 0;
                        }
                        if (Total == "" || Total == '' || isNaN(Total) || Total == null) {
                            Total = 0;
                        }
                        var Theo = MDM * Total;
                        var FATA = Total * 10;
                        gv2.batchEditApi.SetCellValue(iMO[h], "MEATStdUseTHEORETICAL", Theo);
                        gv2.batchEditApi.SetCellValue(iMO[h], "MEATStdUseFatA", FATA);
                        console.log(parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "MEATStdUseTHEORETICAL")));
                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            MDM = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "MEATStdUseMDM"));
                            Total = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ActualProducedTotal"));

                            if (MDM == "" || MDM == '' || isNaN(MDM) || MDM == null) {
                                MDM = 0;
                            }
                            if (Total == "" || Total == '' || isNaN(Total) || Total == null) {
                                Total = 0;
                            }
                            var Theo = MDM * Total;
                            var FATA = Total * 10;
                            gv2.batchEditApi.SetCellValue(iMO[h], "MEATStdUseTHEORETICAL", Theo);
                            gv2.batchEditApi.SetCellValue(iMO[h], "MEATStdUseFatA", FATA);
                            console.log(parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "MEATStdUseTHEORETICAL")));
                        }
                    }
                }
            }, 500);
        }
        function calculate_CasingStd(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        Inputtotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputTotal"));
                        WTPStrand = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "StandardWTPStrand"));

                        if (Inputtotal == "" || Inputtotal == '' || isNaN(Inputtotal) || Inputtotal == null) {
                            Inputtotal = 0;
                        }
                        if (WTPStrand == "" || WTPStrand == '' || isNaN(WTPStrand) || WTPStrand == null) {
                            WTPStrand = 0;
                        }
                        

                        if (WTPStrand == 0 || Inputtotal == 0) {
                            gv2.batchEditApi.SetCellValue(iMO[h], "CasingSTD", 0);
                        }
                        else {
                            var Total = Inputtotal / WTPStrand;
                            gv2.batchEditApi.SetCellValue(iMO[h], "CasingSTD", Total);
                        }
                        
                       
                        
                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            Inputtotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputTotal"));
                            WTPStrand = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "StandardWTPStrand"));

                            if (Inputtotal == "" || Inputtotal == '' || isNaN(Inputtotal) || Inputtotal == null) {
                                Inputtotal = 0;
                            }
                            if (WTPStrand == "" || WTPStrand == '' || isNaN(WTPStrand) || WTPStrand == null) {
                                WTPStrand = 0;
                            }

                            if (WTPStrand == 0 ||  Inputtotal == 0 ) {
                                gv2.batchEditApi.SetCellValue(iMO[h], "CasingSTD", 0);
                            }
                            else {
                                var Total = Inputtotal / WTPStrand;
                                gv2.batchEditApi.SetCellValue(iMO[h], "CasingSTD", Total);
                            }

                        }
                    }
                }
            }, 500);
        }

        //function calculate_PlasticPackaging(s, e) {


        //    var Day = 0, Night = 0, Total = 0;
        //    setTimeout(function () {
        //        var iMO = gv1.batchEditApi.GetRowVisibleIndices();
        //        for (var h = 0; h < iMO.length; h++) {
        //            if (gv1.batchEditApi.IsNewRow(iMO[h])) {
        //                Inputtotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputTotal"));
        //                FGGiveawaySTD = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "FGGiveawaySTD"));
        //                StandaredYield = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "StandaredYield"));

        //                if (Inputtotal == "" || Inputtotal == '' || isNaN(Inputtotal) || Inputtotal == null) {
        //                    Inputtotal = 0;
        //                }
        //                if (FGGiveawaySTD == "" || FGGiveawaySTD == '' || isNaN(FGGiveawaySTD) || FGGiveawaySTD == null) {
        //                    FGGiveawaySTD = 0;
        //                }
        //                if (StandaredYield == "" || StandaredYield == '' || isNaN(StandaredYield) || StandaredYield == null) {
        //                    StandaredYield = 0;
        //                }
        //                var Total = Inputtotal * StandaredYield / StandaredYield;

        //                gv2.batchEditApi.SetCellValue(iMO[h], "PlasticPackagingSTD", Total);

        //            }
        //            else {
        //                var key = gv1.GetRowKey(iMO[h]);
        //                if (gv1.batchEditApi.IsDeletedRow(key)) { }
        //                else {
        //                    Inputtotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputTotal"));
        //                    FGGiveawaySTD = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "FGGiveawaySTD"));
        //                    StandaredYield = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "StandaredYield"));

        //                    if (Inputtotal == "" || Inputtotal == '' || isNaN(Inputtotal) || Inputtotal == null) {
        //                        Inputtotal = 0;
        //                    }
        //                    if (FGGiveawaySTD == "" || FGGiveawaySTD == '' || isNaN(FGGiveawaySTD) || FGGiveawaySTD == null) {
        //                        FGGiveawaySTD = 0;
        //                    }
        //                    if (StandaredYield == "" || StandaredYield == '' || isNaN(StandaredYield) || StandaredYield == null) {
        //                        StandaredYield = 0;
        //                    }
        //                    var Total = Inputtotal * StandaredYield / StandaredYield;

        //                    gv2.batchEditApi.SetCellValue(iMO[h], "PlasticPackagingSTD", Total);
        //                }
        //            }
        //        }
        //    }, 500);
        //}
        function calculate_CasingRej(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        var CasingSTD = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CasingSTD"));
                        var CasingACT = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CasingACT"));

                        if (isNaN(CasingSTD) || CasingSTD == null) {
                            CasingSTD = 0;
                        }
                        if (isNaN(CasingACT) || CasingACT == null) {
                            CasingACT = 0;
                        }
                        var CasingREJ = 0;
                        if (CasingSTD == 0 || CasingACT == 0) {
                            gv2.batchEditApi.SetCellValue(iMO[h], "CasingREJ", 0);
                        }
                        else {
                            CasingREJ = ((CasingACT - CasingSTD) / CasingSTD) * 100;
                        }
                        gv2.batchEditApi.SetCellValue(iMO[h], "CasingREJ", CasingREJ);
                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            var CasingSTD = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CasingSTD"));
                            var CasingACT = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CasingACT"));

                            if (isNaN(CasingSTD) || CasingSTD == null) {
                                CasingSTD = 0;
                            }
                            if (isNaN(CasingACT) || CasingACT == null) {
                                CasingACT = 0;
                            }

                         

                            var CasingREJ = 0;
                            if (CasingSTD == 0 || CasingACT == 0) {
                                gv2.batchEditApi.SetCellValue(iMO[h], "CasingREJ", 0);
                            }
                            else {
                                CasingREJ = ((CasingACT - CasingSTD) / CasingSTD) * 100;
                            }
                            gv2.batchEditApi.SetCellValue(iMO[h], "CasingREJ", CasingREJ);
                        }
                    }
                }
            }, 500);
            //calculate_CasingTotal();
        }


        //function calculate_CasingTotal(s, e) {


        //    var Day = 0, Night = 0, Total = 0;
        //    setTimeout(function () {
        //        var iMO = gv1.batchEditApi.GetRowVisibleIndices();
        //        for (var h = 0; h < iMO.length; h++) {
        //            if (gv1.batchEditApi.IsNewRow(iMO[h])) {
        //                CasingACT = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CasingACT"));
        //                Rej = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CasingREJ"));

        //                if (CasingACT == "" || CasingACT == '' || isNaN(CasingACT) || CasingACT == null) {
        //                    CasingACT = 0;
        //                }
        //                if (Rej == "" || Rej == '' || isNaN(Rej) || Rej == null) {
        //                    Rej = 0;
        //                }
        //                var CTotal = CasingACT + Rej;

        //                gv2.batchEditApi.SetCellValue(iMO[h], "CasingTOTAL", CTotal);

        //            }
        //            else {
        //                var key = gv1.GetRowKey(iMO[h]);
        //                if (gv1.batchEditApi.IsDeletedRow(key)) { }
        //                else {
        //                    CasingACT = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CasingACT"));
        //                    Rej = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CasingREJ"));

        //                    if (CasingACT == "" || CasingACT == '' || isNaN(CasingACT) || CasingACT == null) {
        //                        CasingACT = 0;
        //                    }
        //                    if (Rej == "" || Rej == '' || isNaN(Rej) || Rej == null) {
        //                        Rej = 0;
        //                    }
        //                    var CTotal = CasingACT + Rej;

        //                    gv2.batchEditApi.SetCellValue(iMO[h], "CasingTOTAL", CTotal);


        //                }
        //            }
        //        }
        //    }, 500);
        //    calculate_CasingDiff();
        //}
        function calculate_CasingDiff(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        CasingTOTAL = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CasingTOTAL"));
                        CasingSTD = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CasingSTD"));

                        if (CasingTOTAL == "" || CasingTOTAL == '' || isNaN(CasingTOTAL) || CasingTOTAL == null) {
                            CasingTOTAL = 0;
                        }
                        if (CasingSTD == "" || CasingSTD == '' || isNaN(CasingSTD) || CasingSTD == null) {
                            CasingSTD = 0;
                        }
                        var Total = CasingTOTAL - CasingSTD;

                        gv2.batchEditApi.SetCellValue(iMO[h], "CasingDIFF", Total);

                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            CasingTOTAL = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CasingTOTAL"));
                            CasingSTD = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CasingSTD"));

                            if (CasingTOTAL == "" || CasingTOTAL == '' || isNaN(CasingTOTAL) || CasingTOTAL == null) {
                                CasingTOTAL = 0;
                            }
                            if (CasingSTD == "" || CasingSTD == '' || isNaN(CasingSTD) || CasingSTD == null) {
                                CasingSTD = 0;
                            }
                            var Total = CasingTOTAL - CasingSTD;

                            gv2.batchEditApi.SetCellValue(iMO[h], "CasingDIFF", Total);


                        }
                    }
                }
            }, 500);
        }

        function calculate_PlasticPackagingRej(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv2.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv2.batchEditApi.IsNewRow(iMO[h])) {
                        PlasticPackagingSTD = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "PlasticPackagingSTD"));
                        PlasticPackagingACT = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "PlasticPackagingACT"));

                        if (PlasticPackagingSTD == "" || PlasticPackagingSTD == '' || isNaN(PlasticPackagingSTD) || PlasticPackagingSTD == null) {
                            PlasticPackagingSTD = 0;
                        }
                        if (PlasticPackagingACT == "" || PlasticPackagingACT == '' || isNaN(PlasticPackagingACT) || PlasticPackagingACT == null) {
                            PlasticPackagingACT = 0;
                        }
                  
                        //var CTotal = PlasticPackagingSTD - PlasticPackagingACT;
                    
                        //gv2.batchEditApi.SetCellValue(iMO[h], "PlasticPackagingREJ", CTotal);


                        var PlasticPackagingREJ = 0;
                        if (PlasticPackagingSTD == 0 || PlasticPackagingACT == 0) {
                            gv2.batchEditApi.SetCellValue(iMO[h], "PlasticPackagingREJ", 0);
                        }
                        else {
                            PlasticPackagingREJ = ((PlasticPackagingACT - PlasticPackagingSTD) / PlasticPackagingSTD) * 100;
                        }
                        gv2.batchEditApi.SetCellValue(iMO[h], "PlasticPackagingREJ", PlasticPackagingREJ);
             

                    }
                    else {
                        var key = gv2.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            PlasticPackagingSTD = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "PlasticPackagingSTD"));
                            PlasticPackagingACT = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "PlasticPackagingACT"));

                            if (PlasticPackagingSTD == "" || PlasticPackagingSTD == '' || isNaN(PlasticPackagingSTD) || PlasticPackagingSTD == null) {
                                PlasticPackagingSTD = 0;
                            }
                            if (PlasticPackagingACT == "" || PlasticPackagingACT == '' || isNaN(PlasticPackagingACT) || PlasticPackagingACT == null) {
                                PlasticPackagingACT = 0;
                            }
                            //var CTotal = PlasticPackagingSTD - PlasticPackagingACT;

                            //gv2.batchEditApi.SetCellValue(iMO[h], "PlasticPackagingREJ", CTotal);

                        

                            var PlasticPackagingREJ = 0;
                            if (PlasticPackagingSTD == 0 || PlasticPackagingACT == 0) {
                                gv2.batchEditApi.SetCellValue(iMO[h], "PlasticPackagingREJ", 0);
                            }
                            else {
                                PlasticPackagingREJ = ((PlasticPackagingACT - PlasticPackagingSTD) / PlasticPackagingSTD) * 100;
                            }
                            gv2.batchEditApi.SetCellValue(iMO[h], "PlasticPackagingREJ", PlasticPackagingREJ);

                        }
                    }
                }
            }, 500);
            calculate_PlasticPackagingTotal();
        }
        function calculate_CartonRej(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        CartonSTD = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CartonSTD"));
                        CartonACT = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CartonACT"));

                        if (CartonSTD == "" || CartonSTD == '' || isNaN(CartonSTD) || CartonSTD == null) {
                            CartonSTD = 0;
                        }
                        if (CartonACT == "" || CartonACT == '' || isNaN(CartonACT) || CartonACT == null) {
                            CartonACT = 0;
                        }
                        //var CTotal = CartonSTD - CartonACT;

                        //gv2.batchEditApi.SetCellValue(iMO[h], "CartonREJ", CTotal);

                        var CartonREJ = 0;
                        if (CartonSTD == 0 || CartonACT == 0) {
                            gv2.batchEditApi.SetCellValue(iMO[h], "CartonREJ", 0);
                        }
                        else  {
                            CartonREJ = ((CartonACT - CartonSTD) / CartonSTD) * 100;
                        }
                        gv2.batchEditApi.SetCellValue(iMO[h], "CartonREJ", CartonREJ);

                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            CartonSTD = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CartonSTD"));
                            CartonACT = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "CartonACT"));

                            if (CartonSTD == "" || CartonSTD == '' || isNaN(CartonSTD) || CartonSTD == null) {
                                CartonSTD = 0;
                            }
                            if (CartonACT == "" || CartonACT == '' || isNaN(CartonACT) || CartonACT == null) {
                                CartonACT = 0;
                            }
                            //var CTotal = CartonSTD - CartonACT;

                            //gv2.batchEditApi.SetCellValue(iMO[h], "CartonREJ", CTotal);


                            var CartonREJ = 0;
                            if (CartonSTD == 0 || CartonACT == 0) {
                                gv2.batchEditApi.SetCellValue(iMO[h], "CartonREJ", 0);
                            }
                            else {
                                CartonREJ = ((CartonACT - CartonSTD) / CartonSTD) * 100;
                            }
                            gv2.batchEditApi.SetCellValue(iMO[h], "CartonREJ", CartonREJ);


                        }
                    }
                }
            }, 500);
           
        }

        function calculate_PlasticPackagingTotal(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        PlasticPackagingACT = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "PlasticPackagingACT"));
                        PlasticPackagingREJ = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "PlasticPackagingREJ"));

                        if (PlasticPackagingACT == "" || PlasticPackagingACT == '' || isNaN(PlasticPackagingACT) || PlasticPackagingACT == null) {
                            PlasticPackagingACT = 0;
                        }
                        if (PlasticPackagingREJ == "" || PlasticPackagingREJ == '' || isNaN(PlasticPackagingREJ) || PlasticPackagingREJ == null) {
                            PlasticPackagingREJ = 0;
                        }
                        var CTotal = PlasticPackagingACT + PlasticPackagingREJ;

                        gv2.batchEditApi.SetCellValue(iMO[h], "PlasticPackagingTOTAL", CTotal);

                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            PlasticPackagingACT = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "PlasticPackagingACT"));
                            PlasticPackagingREJ = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "PlasticPackagingREJ"));

                            if (PlasticPackagingACT == "" || PlasticPackagingACT == '' || isNaN(PlasticPackagingACT) || PlasticPackagingACT == null) {
                                PlasticPackagingACT = 0;
                            }
                            if (PlasticPackagingREJ == "" || PlasticPackagingREJ == '' || isNaN(PlasticPackagingREJ) || PlasticPackagingREJ == null) {
                                PlasticPackagingREJ = 0;
                            }
                            var CTotal = PlasticPackagingACT + PlasticPackagingREJ;

                            gv2.batchEditApi.SetCellValue(iMO[h], "PlasticPackagingTOTAL", CTotal);


                        }
                    }
                }
            }, 500);
            calculate_PlasticPackagingDiff();
        }
        function calculate_PlasticPackagingDiff(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        PlasticPackagingTOTAL = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "PlasticPackagingTOTAL"));
                        PlasticPackagingSTD = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "PlasticPackagingSTD"));

                        if (PlasticPackagingTOTAL == "" || PlasticPackagingTOTAL == '' || isNaN(PlasticPackagingTOTAL) || PlasticPackagingTOTAL == null) {
                            PlasticPackagingTOTAL = 0;
                        }
                        if (PlasticPackagingSTD == "" || PlasticPackagingSTD == '' || isNaN(PlasticPackagingSTD) || PlasticPackagingSTD == null) {
                            PlasticPackagingSTD = 0;
                        }
                        var Total = PlasticPackagingTOTAL - PlasticPackagingSTD;

                        gv2.batchEditApi.SetCellValue(iMO[h], "PlasticPackagingDIFF", Total);

                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            PlasticPackagingTOTAL = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "PlasticPackagingTOTAL"));
                            PlasticPackagingSTD = parseFloat(gv2.batchEditApi.GetCellValue(iMO[h], "PlasticPackagingSTD"));

                            if (PlasticPackagingTOTAL == "" || PlasticPackagingTOTAL == '' || isNaN(PlasticPackagingTOTAL) || PlasticPackagingTOTAL == null) {
                                PlasticPackagingTOTAL = 0;
                            }
                            if (PlasticPackagingSTD == "" || PlasticPackagingSTD == '' || isNaN(PlasticPackagingSTD) || PlasticPackagingSTD == null) {
                                PlasticPackagingSTD = 0;
                            }
                            var Total = PlasticPackagingTOTAL - PlasticPackagingSTD;

                            gv2.batchEditApi.SetCellValue(iMO[h], "PlasticPackagingDIFF", Total);


                        }
                    }
                }
            }, 500);
        }

        function calculate_CartonStd(s, e) {
          

            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    //if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                    //    //PackagingInitialOutTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingInitialOutTotal"));
                    //    StandardCaseCon = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "StandardCaseCon"));
                    //    Day = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingInitialOutDay"));
                    //    Night = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingInitialOutNight"));
                       
                    //    if (Day == "" || Day == '' || isNaN(Day) || Day == null) {
                    //        Day = 0;
                    //    }
                    //    if (Night == "" || Night == '' || isNaN(Night) || Night == null) {
                    //        Night = 0;
                    //    }
                    //    //if (PackagingInitialOutTotal == "" || PackagingInitialOutTotal == '' || isNaN(PackagingInitialOutTotal) || PackagingInitialOutTotal == null) {
                    //    //    PackagingInitialOutTotal = 0;
                    //    //}
                    //    if (StandardCaseCon == "" || StandardCaseCon == '' || isNaN(StandardCaseCon) || StandardCaseCon == null) {
                    //        StandardCaseCon = 0;
                    //    }


                    //    if (StandardCaseCon == 0 || Day == 0 || Night == 0) {

                    //    }
                    //    else {
                    //        var Total = (Day + Night)/ StandardCaseCon;
                    //        gv2.batchEditApi.SetCellValue(iMO[h], "CartonSTD", Total);
                           
                    //    }



                    //}
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        var StandardCaseCon = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "StandardCaseCon")) || 0;
                        var Day = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingInitialOutDay")) || 0;
                        var Night = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingInitialOutNight")) || 0;
                        var ItemCode = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ItemC"))
                        console.log('ItemCode:' + ItemCode);
                        console.log('DAY:' + Day);
                        console.log('Night:' + Night);
                        console.log('StandardCaseCon:' + StandardCaseCon);
                        if (StandardCaseCon && Day && Night) {
                            var Total = (Day + Night) / StandardCaseCon;
                            gv2.batchEditApi.SetCellValue(iMO[h], "CartonSTD", Total);
                        }
                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            var StandardCaseCon = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "StandardCaseCon")) || 0;
                            var Day = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingInitialOutDay")) || 0;
                            var Night = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingInitialOutNight")) || 0;
                            var ItemCode = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ItemC"))
                            console.log('ItemCode:' + ItemCode);
                            console.log('DAY:' + Day);
                            console.log('Night:' + Night);
                            console.log('StandardCaseCon:' + StandardCaseCon);
                            if (StandardCaseCon && Day && Night) {
                                var Total = (Day + Night) / StandardCaseCon;
                                gv2.batchEditApi.SetCellValue(iMO[h], "CartonSTD", Total);
                            }
                            else {
                                var Total = PackagingInitialOutTotal / StandardCaseCon;
                                gv2.batchEditApi.SetCellValue(iMO[h], "CartonSTD", Total);
                            }

                        }
                    }
                }
            }, 500);
        }


        function calculate_ProYield(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        BC = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "BC"));
                        InputTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputTotal"));

                        if (BC == "" || BC == '' || isNaN(BC) || BC == null) {
                            BC = 0;
                        }
                        if (InputTotal == "" || InputTotal == '' || isNaN(InputTotal) || InputTotal == null) {
                            InputTotal = 0;
                        }
                        

                        if (BC == 0 || InputTotal == 0) {
                            gv1.batchEditApi.SetCellValue(iMO[h], "PROyield", '0');
                        }

                        else {
                            var Total = BC / InputTotal * 100;
                            gv1.batchEditApi.SetCellValue(iMO[h], "PROyield", Total);
                        }
                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            BC = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "BC"));
                            InputTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputTotal"));

                            if (BC == "" || BC == '' || isNaN(BC) || BC == null) {
                                BC = 0;
                            }
                            if (InputTotal == "" || InputTotal == '' || isNaN(InputTotal) || InputTotal == null) {
                                InputTotal = 0;
                            }
                          
                            if (BC == 0 || InputTotal == 0) {
                                gv1.batchEditApi.SetCellValue(iMO[h], "PROyield", '0');
                            }

                            else {
                                var Total = BC / InputTotal * 100;
                                gv1.batchEditApi.SetCellValue(iMO[h], "PROyield", Total);
                            }

                        }
                    }
                }
            }, 500);
        }
        function calculate_CookingLoss(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        AC = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "AC"));
                        BC = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "BC"));

                        if (AC == "" || AC == '' || isNaN(AC) || AC == null) {
                            AC = 0;
                        }
                        if (BC == "" || BC == '' || isNaN(BC) || BC == null) {
                            BC = 0;
                        }



                        var Tota =  BC - AC;
                        var Total = (Tota / BC) * 100;
                        

                        if (AC == 0 || BC == 0) {
                            gv1.batchEditApi.SetCellValue(iMO[h], "CookingLoss", '0');
                       
                        }

                        else {

                          
                            gv1.batchEditApi.SetCellValue(iMO[h], "CookingLoss", Total);
                        }

                     
                      
                        
                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            AC = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "AC"));
                            BC = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "BC"));

                            if (AC == "" || AC == '' || isNaN(AC) || AC == null) {
                                AC = 0;
                            }
                            if (BC == "" || BC == '' || isNaN(BC) || BC == null) {
                                BC = 0;
                            }
                      

                            var Tota = BC - AC;
                            var Total = (Tota / BC) * 100;


                            if (AC == 0 || BC == 0) {
                                gv1.batchEditApi.SetCellValue(iMO[h], "CookingLoss", '0');
                            }

                            else {
                                gv1.batchEditApi.SetCellValue(iMO[h], "CookingLoss", Total);
                            }




                          

                        }
                    }
                }
                
            }, 500);
            calculate_TotalYield();
        }
        function calculate_CookingSMYield(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        AC = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "AC"));
                        InputTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputTotal"));

                        if (AC == "" || AC == '' || isNaN(AC) || AC == null) {
                            AC = 0;
                        }
                        if (InputTotal == "" || InputTotal == '' || isNaN(InputTotal) || InputTotal == null) {
                            InputTotal = 0;
                        }
                   

                        var Tota = InputTotal + AC;
                        var Total = (AC / InputTotal) * 100;


                        if (AC == 0 || InputTotal == 0) {
                            gv1.batchEditApi.SetCellValue(iMO[h], "SMYield", '0');
                        }

                        else {


                            gv1.batchEditApi.SetCellValue(iMO[h], "SMYield", Total);
                        }




                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            AC = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "AC"));
                            InputTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputTotal"));

                            if (AC == "" || AC == '' || isNaN(AC) || AC == null) {
                                AC = 0;
                            }
                            if (InputTotal == "" || InputTotal == '' || isNaN(InputTotal) || InputTotal == null) {
                                InputTotal = 0;
                            }
                        

                            var Tota = InputTotal + AC;
                            var Total = (AC / InputTotal) * 100;


                            if (AC == 0 || InputTotal == 0) {
                                gv1.batchEditApi.SetCellValue(iMO[h], "SMYield", '0');
                            }

                            else {


                                gv1.batchEditApi.SetCellValue(iMO[h], "SMYield", Total);
                            }







                        }
                    }
                }
            }, 500);
        }

        function calculate_RejectionSummaryPercent(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        RejectionSummarypercentTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "RejectionSummarypercentTotal"));
                        InputTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputTotal"));
                        SectionSAMPLE = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "SectionSAMPLE"));
                        if (RejectionSummarypercentTotal == "" || RejectionSummarypercentTotal == '' || isNaN(RejectionSummarypercentTotal) || RejectionSummarypercentTotal == null) {
                            RejectionSummarypercentTotal = 0;
                        }
                        if (InputTotal == "" || InputTotal == '' || isNaN(InputTotal) || InputTotal == null) {
                            InputTotal = 0;
                        }
                        if (SectionSAMPLE == "" || SectionSAMPLE == '' || isNaN(SectionSAMPLE) || SectionSAMPLE == null) {
                            SectionSAMPLE = 0;
                        }


                        if (RejectionSummarypercentTotal == 0 || InputTotal == 0) {
                            gv1.batchEditApi.SetCellValue(iMO[h], "RejectionSummarypercent", '0');
                        }

                        else {

                            var Total = (RejectionSummarypercentTotal + SectionSAMPLE) / InputTotal * 100;
                            gv1.batchEditApi.SetCellValue(iMO[h], "RejectionSummarypercent", Total);
                        }
                        

                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            RejectionSummarypercentTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "RejectionSummarypercentTotal"));
                            InputTotal = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "InputTotal"));
                            SectionSAMPLE = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "SectionSAMPLE"));
                            if (RejectionSummarypercentTotal == "" || RejectionSummarypercentTotal == '' || isNaN(RejectionSummarypercentTotal) || RejectionSummarypercentTotal == null) {
                                RejectionSummarypercentTotal = 0;
                            }
                            if (InputTotal == "" || InputTotal == '' || isNaN(InputTotal) || InputTotal == null) {
                                InputTotal = 0;
                            }
                            if (SectionSAMPLE == "" || SectionSAMPLE == '' || isNaN(SectionSAMPLE) || SectionSAMPLE == null) {
                                SectionSAMPLE = 0;
                            }


                            if (RejectionSummarypercentTotal == 0 || InputTotal == 0) {
                                gv1.batchEditApi.SetCellValue(iMO[h], "RejectionSummarypercent", '0');
                            }

                            else {

                                var Total = (RejectionSummarypercentTotal + SectionSAMPLE) / InputTotal * 100;
                                gv1.batchEditApi.SetCellValue(iMO[h], "RejectionSummarypercent", Total);
                            }


                        }
                    }
                }
            }, 500);
            calculate_TotalYield();
        }

        function calculate_FGGiveawaypercent(s, e) {


            var Day = 0, Night = 0, Total = 0;
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        FGGiveawaySTD = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "FGGiveawaySTD"));
                        FGGiveawayActual = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "FGGiveawayActual"));

                        if (FGGiveawaySTD == "" || FGGiveawaySTD == '' || isNaN(FGGiveawaySTD) || FGGiveawaySTD == null) {
                            FGGiveawaySTD = 0;
                        }
                        if (FGGiveawayActual == "" || FGGiveawayActual == '' || isNaN(FGGiveawayActual) || FGGiveawayActual == null) {
                            InputTotal = 0;
                        }
                       



                        if (FGGiveawaySTD == 0 ) {
                            gv1.batchEditApi.SetCellValue(iMO[h], "FGGiveawayPercent", '0');
                            
                        }
                        else if (FGGiveawaySTD != 0 && FGGiveawayActual == 0) {
                            gv1.batchEditApi.SetCellValue(iMO[h], "FGGiveawayPercent", '-100');

                        }
                        else {

                            var Total = ((FGGiveawayActual - FGGiveawaySTD) / FGGiveawaySTD) * 100;
                            gv1.batchEditApi.SetCellValue(iMO[h], "FGGiveawayPercent", Total);
                            
                        }




                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            FGGiveawaySTD = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "FGGiveawaySTD"));
                            FGGiveawayActual = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "FGGiveawayActual"));

                            if (FGGiveawaySTD == "" || FGGiveawaySTD == '' || isNaN(FGGiveawaySTD) || FGGiveawaySTD == null) {
                                FGGiveawaySTD = 0;
                            }
                            if (FGGiveawayActual == "" || FGGiveawayActual == '' || isNaN(FGGiveawayActual) || FGGiveawayActual == null) {
                                InputTotal = 0;
                            }
                          



                            if (FGGiveawaySTD == 0 || FGGiveawayActual == 0) {
                                gv1.batchEditApi.SetCellValue(iMO[h], "FGGiveawayPercent", '0');
                            
                            }

                            else {

                                var Total = (FGGiveawayActual - FGGiveawaySTD) / FGGiveawaySTD * 100;
                                gv1.batchEditApi.SetCellValue(iMO[h], "FGGiveawayPercent", Total);
                            
                            }




                        }
                    }
                }
            }, 500);
            calculate_InitialYield();
            
        }


        function calculate_RejectionSummaryTotal(s, e) {


         
            setTimeout(function () {
                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        SMKHULUT = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "SMKHULUT"));
                        BRINEULUT = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "BRINEULUT"));
                        CUTTINGULUT = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "CUTTINGULUT"));
                        PackagingULUT = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingULUT"));
                        PackagingOSDF = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingOSDF"));
                        PackagingMISCUT = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingMISCUT"));
                   

                        if (SMKHULUT == "" || SMKHULUT == '' || isNaN(SMKHULUT) || SMKHULUT == null) {
                            SMKHULUT = 0;
                        }
                        if (BRINEULUT == "" || BRINEULUT == '' || isNaN(BRINEULUT) || BRINEULUT == null) {
                            BRINEULUT = 0;
                        }
                        if (CUTTINGULUT == "" || CUTTINGULUT == '' || isNaN(CUTTINGULUT) || CUTTINGULUT == null) {
                            CUTTINGULUT = 0;
                        }
                        if (PackagingULUT == "" || PackagingULUT == '' || isNaN(PackagingULUT) || PackagingULUT == null) {
                            PackagingULUT = 0;
                        }
                        if (PackagingOSDF == "" || PackagingOSDF == '' || isNaN(PackagingOSDF) || PackagingOSDF == null) {
                            PackagingOSDF = 0;
                        }
                        if (PackagingMISCUT == "" || PackagingMISCUT == '' || isNaN(PackagingMISCUT) || PackagingMISCUT == null) {
                            PackagingMISCUT = 0;
                        }
                        

                        var Total = SMKHULUT + BRINEULUT + CUTTINGULUT + PackagingULUT + PackagingOSDF + PackagingMISCUT;

                        gv1.batchEditApi.SetCellValue(iMO[h], "RejectionSummarypercentTotal", Total);

                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            SMKHULUT = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "SMKHULUT"));
                            BRINEULUT = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "BRINEULUT"));
                            CUTTINGULUT = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "CUTTINGULUT"));
                            PackagingULUT = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingULUT"));
                            PackagingOSDF = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingOSDF"));
                            PackagingMISCUT = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "PackagingMISCUT"));


                            if (SMKHULUT == "" || SMKHULUT == '' || isNaN(SMKHULUT) || SMKHULUT == null) {
                                SMKHULUT = 0;
                            }
                            if (BRINEULUT == "" || BRINEULUT == '' || isNaN(BRINEULUT) || BRINEULUT == null) {
                                BRINEULUT = 0;
                            }
                            if (CUTTINGULUT == "" || CUTTINGULUT == '' || isNaN(CUTTINGULUT) || CUTTINGULUT == null) {
                                CUTTINGULUT = 0;
                            }
                            if (PackagingULUT == "" || PackagingULUT == '' || isNaN(PackagingULUT) || PackagingULUT == null) {
                                PackagingULUT = 0;
                            }
                            if (PackagingOSDF == "" || PackagingOSDF == '' || isNaN(PackagingOSDF) || PackagingOSDF == null) {
                                PackagingOSDF = 0;
                            }
                            if (PackagingMISCUT == "" || PackagingMISCUT == '' || isNaN(PackagingMISCUT) || PackagingMISCUT == null) {
                                PackagingMISCUT = 0;
                            }


                            var Total = SMKHULUT + BRINEULUT + CUTTINGULUT + PackagingULUT + PackagingOSDF + PackagingMISCUT;

                            gv1.batchEditApi.SetCellValue(iMO[h], "RejectionSummarypercentTotal", Total);

                        }
                    }
                }
            }, 500);
            calculate_RejectionSummaryPercent();
        }

        function calculate_Section(s, e) {


            var ActualProduce = 0, AVGKiloPPiece=0, Total = 0;
            setTimeout(function () {

                var iMO = gv1.batchEditApi.GetRowVisibleIndices();
                for (var h = 0; h < iMO.length; h++) {
                    if (gv1.batchEditApi.IsNewRow(iMO[h])) {
                        ActualProduce = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ActualProducedTotal"));
                        AVGKiloPPiece = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "AVGKiloPPiece"));
                        if (ActualProduce == "" || ActualProduce == '' || isNaN(ActualProduce) || ActualProduce == null) {
                            ActualProduce = 0;
                        }
                        if (AVGKiloPPiece == "" || AVGKiloPPiece == '' || isNaN(AVGKiloPPiece) || AVGKiloPPiece == null) {
                            AVGKiloPPiece = 0;
                        }
                        if (ActualProduce == 0 || AVGKiloPPiece == 0) {
                         Total = 0;
                            gv1.batchEditApi.SetCellValue(iMO[h], "SectionSAMPLE", Total);
                        } else {
                            
                            Total = ActualProduce / 4;
                            Total = ((Total * 4) * AVGKiloPPiece) + (((2 * AVGKiloPPiece) * Total) / 2);
                          
                            gv1.batchEditApi.SetCellValue(iMO[h], "SectionSAMPLE", Total);
                        }

                        console.log('ActualProduce:' + ActualProduce);
                        console.log('ActualProduce:' + ActualProduce);
                     
                        console.log('SectionSAMPLE:' + parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "SectionSAMPLE")));
                        
                    }
                    else {
                        var key = gv1.GetRowKey(iMO[h]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) { }
                        else {
                            ActualProduce = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "ActualProducedTotal"));
                            AVGKiloPPiece = parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "AVGKiloPPiece"));
                            if (ActualProduce == "" || ActualProduce == '' || isNaN(ActualProduce) || ActualProduce == null) {
                                ActualProduce = 0;
                            }
                            if (AVGKiloPPiece == "" || AVGKiloPPiece == '' || isNaN(AVGKiloPPiece) || AVGKiloPPiece == null) {
                                AVGKiloPPiece = 0;
                            }
                            if (ActualProduce == 0 || AVGKiloPPiece == 0) {
                                Total = 0;
                                gv1.batchEditApi.SetCellValue(iMO[h], "SectionSAMPLE", Total);
                            } else {

                                Total = ActualProduce / 4;
                                Total = ((Total * 4) * AVGKiloPPiece) + (((2 * AVGKiloPPiece) * Total) / 2);
                           
                                gv1.batchEditApi.SetCellValue(iMO[h], "SectionSAMPLE", Total);
                            }
                        }
                    }
                    console.log('ActualProduce:' + ActualProduce);
                    console.log('ActualProduce:' + ActualProduce);
                     
                    console.log('SectionSAMPLE:' + parseFloat(gv1.batchEditApi.GetCellValue(iMO[h], "SectionSAMPLE")));
                }
            }, 500);
           
        }
        function calculate() {

            calculate_ProductionPlan();
            calculate_ActualProduced();
            calculate_RejectionSummaryTotal();
            calculate_RejectionSummaryPercent();
            calculate_PackagingInitial();
            calculate_InitialYield();
            calculate_FGGiveawaypercent();
            calculate_TotalYield();
            calculate_CasingStd();
            calculate_CartonStd();
       
        }

        function recalculate(){
        calculate_ProductionPlan();
        //calculate_ActualProduced();
        calculate_FGGiveawaypercent();
        calculate_CasingStd();
        calculate_PlasticPackagingRej();
        calculate_CasingRej();
        calculate_CartonRej();
        calculate_RejectionSummaryPercent();
        calculate_CartonStd();
        }
        function Calculate_BC()
        {
            calculate_CookingLoss();
            calculate_CookingSMYield();

        }


            


        // Auto Calculate 


        var generateAction = 0;
        var index;
        var closing;
        var valchange = false;
        var itemc; //variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var curr;


        var itemc; //variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            curr = e;
            index = e.visibleIndex;
      
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
            //if (e.visibleIndex < 0) {//new row
            //    var linenumber = s.GetColumnByField("LineNumber");
            //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
            //}
            
            
            
            if (entry == "V") {
                e.cancel = true; //this will made the gridview readonly
            }
            if (entry != "V") {
                if (e.focusedColumn.fieldName === "SizeCode" || e.focusedColumn.fieldName === "SVOBreakdown" || e.focusedColumn.fieldName === "CasingREJ" || e.focusedColumn.fieldName === "PlasticPackagingREJ" || e.focusedColumn.fieldName === "CartonREJ") { //Check the column name
                    e.cancel = true;
                }

                if (e.focusedColumn.fieldName === "ClassCode") {
                    gl3.GetInputElement().value = cellInfo.value;


                }

                if (e.focusedColumn.fieldName === "CookingStage") { //Check the column name
                    glCookingstage.GetInputElement().value = cellInfo.value; //Gets the column value
              
                    closing = true;
                    valchange = true;

                }

                if (e.focusedColumn.fieldName === "SKUCode1") {
                    SKU1.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "SKUCode2") {
                    SKU2.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "SKUCode3") {
                    SKU3.GetInputElement().value = cellInfo.value;
                }

            }
        }
        function UpdateProductName(value) {
            var Desc = value[1];
      
            txtProductName.SetText(Desc);

        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            //if (currentColumn.fieldName === "ItemCode") {
            //    cellInfo.value = gl.GetValue();
            //    cellInfo.text = gl.GetText().toUpperCase();
            //}
            if (currentColumn.fieldName === "ColorCode") {
                cellInfo.value = gl2.GetValue();
                cellInfo.text = gl2.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "ClassCode") {
                cellInfo.value = gl3.GetValue();
                cellInfo.text = gl3.GetText().toUpperCase();
            }
            //if (currentColumn.fieldName === "CookingStage") {
            //    cellInfo.value = glCookingstage.GetValue();
            //    cellInfo.text = glCookingstage.GetText();
         
            //}
            if (currentColumn.fieldName === "SKUCode1") {
                cellInfo.value = SKU1.GetValue();
                cellInfo.text = SKU1.GetText();
            }
            if (currentColumn.fieldName === "SKUCode2") {
                cellInfo.value = SKU2.GetValue();
                cellInfo.text = SKU2.GetText();
            }
            if (currentColumn.fieldName === "SKUCode3") {
                cellInfo.value = SKU3.GetValue();
                cellInfo.text = SKU3.GetText();
            }

        }


        function autocalculate(s, e) {
        


            var qty = 0.00;

            var totalqty = txttotalqty.GetValue();

            var wop = 0.00
            var exchangerate = 0.00
            var NonVatAmount = 0.00
            var GrossVatamount = 0.00
            var VatAmount = 0.00
            var WithHolding = 0.00
            var VatRate = 0.00
            var Atc = 0.00
            //RA

            exchangerate = txtexchangerate.GetValue();




            wop = txtWOP.GetValue();







            Atc = txtAtc.GetValue();

            setTimeout(function () {




                if (txtVatRate.GetValue() == 0) {
                    NonVatAmount = totalqty * wop * exchangerate
                    GrossVatamount = 0.00
                }
                else {
                    GrossVatamount = parseFloat(totalqty * wop * exchangerate);

                    NonVatAmount = 0.00

                }

                //  txtVatAmount.SetText(VATAmount.format(2, 3, ',', '.'));



                txtGrossVATableAmount.SetValue(GrossVatamount.toFixed(2))
                txtnonvat.SetValue((NonVatAmount).toFixed(2))

                // txttotalqty.SetText(totalqty);
                txtForeignAmount.SetValue((totalqty * wop * exchangerate).toFixed(2));
                txtTotalAmount.SetValue((totalqty * wop).toFixed(2))
                vatdetail1 = 1 + parseFloat(txtVatRate.GetValue());

                var value = (GrossVatamount / vatdetail1) * txtVatRate.GetValue();

                txtVatAmount1.SetValue(value.toFixed(2));
                txtWithHoldingTax.SetValue(((GrossVatamount - value) * Atc).toFixed(2))

            }, 500);
        }



        function lookup(s, e) {
            if (isSetTextRequired) {//Sets the text during lookup for item code
                s.SetText(s.GetInputElement().value);
                isSetTextRequired = false;
            }
        }

        //var preventEndEditOnLostFocus = false;
        function gridLookup_KeyDown(s, e) { //Allows tabbing between gridlookup on details

        }



        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.

        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields/index 0 is from the commandcolumn)

        }


        function OnCustomClick(s, e) {
            var entry = getParameterByName('entry');
            var transtype = getParameterByName('transtype');
            if (entry == "V" || entry == "D") {
       
                alert('Can not delete detail during view');
                return;
            }



            if (e.buttonID == "Delete") {
                gvclass.DeleteRow(e.visibleIndex);
                autocalculate(s, e);

            }
            if (e.buttonID == "ViewTransaction") {

                var transtype = s.batchEditApi.GetCellValue(e.visibleIndex, "TransType");
                var docnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "DocNumber");
                var commandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "CommandString");

                window.open(commandtring + '?entry=V&transtype=' + transtype + '&parameters=&iswithdetail=true&docnumber=' + docnumber, '_blank', "", false);
             
            }
            if (e.buttonID == "ViewReferenceTransaction") {

                var rtranstype = s.batchEditApi.GetCellValue(e.visibleIndex, "RTransType");
                var rdocnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "REFDocNumber");
                var rcommandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "RCommandString");
                window.open(rcommandtring + '?entry=V&transtype=' + rtranstype + '&parameters=&iswithdetail=true&docnumber=' + rdocnumber, '_blank');
              

            }
            if (e.buttonID == "BOMDelete") gvStepBOM.DeleteRow(e.visibleIndex);
        }


        //function endcp(s, e) {
        //    var endg = s.GetGridView().cp_endgl1;
        //    if (endg == true) {
        //        console.log(endg);
        //        sup_cp_Callback.PerformCallback(glSupplierCode.GetValue().toString());
        //        e.processOnServer = false;
        //        endg = null;
        //    }
        //}

        function endcp2(s, e) {
            var endg = s.cp_endgl1;

       
            cp.PerformCallback('RR');
            e.processOnServer = false;
            endg = null;

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
            gvRef.SetWidth(width - 120);
            gvJournal.SetWidth(width - 120);
            gvTemp.SetWidth(width - 120);
            //gv1.SetWidth(width - 120);
            //gv2.SetWidth(width - 120);
        }
        function checkedchanged(s, e) {
            var checkState = cbiswithdr.GetChecked();
            if (checkState == true) {
                cp.PerformCallback('isclassatrue');
                e.processOnServer = false;

            }
            else {
                cp.PerformCallback('isclassafalse');
                e.processOnServer = false;


            }
        }

        var gl_objName = "";
        var gl_sdsName = "";
        var gl_sqlcmd = "";
        function gridLookup_Data()
        {
            //emc2021
            var gridLookupName = gl_objName;
            var ListName2 = hgridlookup.GetText();
            if (ListName2.indexOf(gridLookupName) === -1) {

                hgridlookup.SetText("" + ListName2 + gridLookupName + ",");

                cp.PerformCallback('sds|' + gl_sdsName + "|" + gl_sqlcmd + "|" + gl_objName);

                //console.log(" get data " + ListName2 + "," + txtBatchNo);

            }

            //console.log('sds|' + gl_sdsName + "|" + gl_sqlcmd + "|" + gl_objName);

        }

        function gridLookup_DropDown(s, e) {
            //emc2021
            var gridLookupName = txtBatchNo.globalName;
            var ListName2 = hgridlookup.GetText();
            if(ListName2.indexOf(gridLookupName) === -1)
            {
                hgridlookup.SetText("" + ListName2 + gridLookupName + ",");

                cp.PerformCallback('batchno');

            

            }
           
            
            //cp.PerformCallback('batchno');
        }

        function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);

            if(keyCode = 63)
            {
                cp.PerformCallback('batchno');
            }

            //alert("keycode :" + keyCode);
            //if (keyCode == ASPxKey.ke) {
            //    //gv1.batchEditApi.EndEdit();
         
            //}
        }

        var PutDetailIdx = 0;
        var PutObj;
        var PutGridUse;
        var PutColName;
        var PutValueIndex;

        function PutGridCol(selectedValues) {

          

            var idx1 = 0
            switch (PutDetailIdx) {
                case 1:
                    //gv1 Raw Material detail

                    //gv1.batchEditApi.EndEdit();
                    for (idx1 = 0; idx1 < PutColName.length; idx1++) {
                        //console.log("idx " + idx1 + " ColName " + PutColName[idx1] + " idx: " + PutValueIndex[idx1] + " value: " + selectedValues[PutValueIndex[idx1]]);
                        //gv1.batchEditApi.SetCellValue(index, PutColName[idx1], selectedValues[PutValueIndex[idx1]]);

                        if(PutColName[idx1] === "Hskucode")
                        {
                            txtskucode.SetText(selectedValues[PutValueIndex[idx1]]);
                        }

                        if (PutColName[idx1] === "SKUCode1") {
                            gv2.batchEditApi.SetCellValue(index, PutColName[idx1], selectedValues[PutValueIndex[idx1]]);
                        }
                        if (PutColName[idx1] === "CasingSTD") {
                            gv2.batchEditApi.SetCellValue(index, PutColName[idx1], selectedValues[PutValueIndex[idx1]]);
                        }

                        if (PutColName[idx1] === "SKUCode2") {
                            gv2.batchEditApi.SetCellValue(index, PutColName[idx1], selectedValues[PutValueIndex[idx1]]);
                        }

                        if (PutColName[idx1] === "SKUCode3") {
                            gv2.batchEditApi.SetCellValue(index, PutColName[idx1], selectedValues[PutValueIndex[idx1]]);
                        }
                        
                    }

                    break;
                //case 2:
                //    //gvservice Spices Detail
                //    gvService.batchEditApi.EndEdit();
                //    for (idx1 = 0; idx1 < PutColName.length; idx1++) {
                //        //console.log("idx " + idx1 + " ColName " + PutColName[idx1] + " idx: " + PutValueIndex[idx1] + " value: " + selectedValues[PutValueIndex[idx1]]);
                //        gvService.batchEditApi.SetCellValue(index, PutColName[idx1], selectedValues[PutValueIndex[idx1]]);
                //    }

                //    break;
                //case 3:
                //    //gvscrap Scrap Detail
                //    gvScrap.batchEditApi.EndEdit();
                //    for (idx1 = 0; idx1 < PutColName.length; idx1++) {
                //        //console.log("idx " + idx1 + " ColName " + PutColName[idx1] + " idx: " + PutValueIndex[idx1] + " value: " + selectedValues[PutValueIndex[idx1]]);
                //        gvScrap.batchEditApi.SetCellValue(index, PutColName[idx1], selectedValues[PutValueIndex[idx1]]);
                //    }

                //    break;

            }
           /* PutGridUse.batchEditApi.SetCellValue(index, PutColName, selectedValues[PutValueIndex]);*/
            //gvService.batchEditApi.SetCellValue(index, "CustomerCode", selectedValues[0]);
        }




        function Generates(s, e) {
            var prtext = document.getElementById("cp_frmlayout1_PC_0_txtPD_I").value;
            if (!prtext) { alert('No Production Date to generate!'); return; }
            var generate = confirm("Are you sure you want to generate");
            if (generate) {
                cp.PerformCallback('Generates');
                e.processOnServer = false;
            }

        }
        function Generates1(s, e) {
            console.log('Resyncbtn');
            var prtext = document.getElementById("cp_frmlayout1_PC_0_txtPD_I").value;
            if (!prtext) { alert('No Production Date to generate!'); return; }
            var generate = confirm("Are you sure you want to resync data from WIP?");
            if (generate) {
                cp.PerformCallback('Resync');
                e.processOnServer = false;
            }

        }
        function Resync(s, e) {
            console.log('Resyncbtn');
            var prtext = document.getElementById("cp_frmlayout1_PC_0_txtPD_I").value;
            if (!prtext) { alert('No Production Date to generate!'); return; }
            var generate = confirm("Are you sure you want to resync data from WIP?");
            if (generate) {
                cp.PerformCallback('Resync');
                e.processOnServer = false;
            }

        }
    </script>
    <!--#endregion-->
</head>
<body style="height: 250px; overflow: auto;">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="false" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" ID="FormTitle" Text="Initial DPR" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        &nbsp;<br />
        <br />
        <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None"
            EnableViewState="False" HeaderText="Item info" Height="0px" Width="0px" PopupHorizontalOffset="1085" PopupVerticalOffset="90"
            ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="False" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
            EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
            ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
            <ClientSideEvents CloseUp="function (s, e) { window.location.reload(); }" />
        </dx:ASPxPopupControl>

        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" HeighSKUt="300px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="300px" Width="850px" Style="margin-left: -20px" SettingsAdaptivity-AdaptivityMode="SingleColumnWindowLimit" SettingsAdaptivity-SwitchToSingleColumnAtWindowInnerWidth="800">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Type" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="cmbType" Width="170px" runat="server" OnLoad="Comboboxload">
                                                            <Items>
                                                                <dx:ListEditItem Text="Normal Out" Value="Normal Out" />
                                                                <dx:ListEditItem Text="Adjustment" Value="Adjustment" />
                                                            </Items>
                                                            <ClientSideEvents ValueChanged="function(s,e){
                                                                  cp.PerformCallback('Type');
                                                                   e.processOnServer = false;
                                                                }" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Document Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px" OnLoad="TextboxLoad" AutoCompleteType="Disabled" Enabled="False">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                           

                                            <dx:LayoutItem Caption="Document Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnLoad="Date_Load" OnInit="dtpDocDate_Init" Width="170px">
                                                            <ClientSideEvents Validation="OnValidation"
                                                                 ValueChanged="function (s, e){ cp.PerformCallback('docdate');  e.processOnServer = false;}" 
                                                                 />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:LayoutItem Caption="Work Week">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtWorkWeek" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

<%--                                            <dx:LayoutItem Caption="Step Process">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStepCode" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>


                                            <dx:LayoutItem Caption="Step Process" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtStepCode" ClientInstanceName="txtStepCode" runat="server"
                                                            DataSourceID="sdsStep" KeyFieldName="StepCode" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="StepCode" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>
                                                             <%--<ClientSideEvents 
                                                                    DropDown="function(){ 
                                                                               
                                                                              gl_objName = 'txtStepCode';
                                                                              gl_sdsName = 'sdsStep';
                                                                              gl_sqlcmd = 'SELECT StepCode FROM Masterfile.Step';
                                                                             
                                                                              gridLookup_Data();

                                                                              }"
                                                                />--%>

                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Production Site" Name="prodsite">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="hprodsite" ClientInstanceName="hprodsite" runat="server"
                                                            DataSourceID="sdsSite" KeyFieldName="Code" TextFormatString="{0}" Width="170px" OnLoad="gvLookupLoad">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="Code" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="Description" Settings-AutoFilterCondition="Contains" />

                                                            </Columns>
                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Production Date" name="txtPD">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                          <dx:ASPxDateEdit ID="txtPD" runat="server" OnLoad="Date_Load"  Width="170px">
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Shift" Name="Shift" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="Shift" ClientInstanceName="Shift" runat="server"
                                                            OnInit="lookup_Init"
                                                            DataSourceID="sdsShift" KeyFieldName="ShiftCode" TextFormatString="{0}" Width="170px" OnLoad="gvLookupLoad">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="ShiftCode" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="ShiftName" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>

                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                               <dx:LayoutItem Caption="Product Description" name="txtProductName" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtProductName" runat="server" Width="170px" OnLoad ="TextboxLoad" ClientInstanceName="txtProductName">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



                                            <dx:LayoutItem Caption="Step Sequence" Name="stepseq" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="hstepseq"  ClientInstanceName="hstepseq" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



                                            <dx:LayoutItem Caption="Year" Visible="false" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtYear" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            

                                            <dx:LayoutItem Caption="DayNo" Visible="false" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDayNo" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            
                                            <dx:LayoutItem Caption="SKU Code" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                 <%--       <dx:ASPxTextBox ID="txtskucode"  ClientInstanceName="txtskucode" runat="server" Width="170px" ReadOnly="false">
                                                            <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('CookingStage');  e.processOnServer = false;
                                                                 
                                                                         }" />
                                                        </dx:ASPxTextBox>--%>

                                                        <dx:ASPxGridLookup ID="txtskucode" ClientInstanceName="SkuCode" runat="server"
                                                            OnInit="lookup_Init"
                                                            DataSourceID="sdsSKUCode" KeyFieldName="SKUCode" TextFormatString="{0}" Width="170px" OnLoad="gvLookupLoad">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="SKUCode" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="ProductName" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>
                                                            <ClientSideEvents
                                                                DropDown="function(){ 
                                                                   
                                                                    var PD = '\'' + document.getElementById('cp_frmlayout1_PC_0_txtPD_I').value +'\'';

                                                                 var CPMLI = '\'CP-MLI\'';
                                                                
                                                                 

                                                                              gl_objName = 'txtskucode';
                                                                              gl_sdsName = 'sdsSKUCode';

                                                                             

                                                                 if (PD == '' || PD == null || PD == undefined){
                                                                              gl_sqlcmd = 'select A.ItemCode AS SKUCode, B.ProductName	from production.CounterPlanDetail A left join Masterfile.FGSKU B ON A.ItemCode = B.SKUCode';
                                                                              }
                                                                 else {
                                                                	
                                                                              gl_sqlcmd = 'Declare @PDWorkWeek varchar(50) SELECT @PDWorkWeek = DATEPART(WW,'+ PD +') 	Declare @PDYear varchar(50) SELECT @PDYear = DATEPART(YEAR,' + PD +') select A.ItemCode AS SKUCode, B.ProductName	from production.CounterPlanDetail A left join Masterfile.FGSKU B ON A.ItemCode = B.SKUCode where A.Docnumber = '+ CPMLI +' + @PDYear + @PDWorkWeek';
                                                                              }
                                                                       
                                                                              gridLookup_Data();

                                                                              }" 
                                                                ValueChanged="function(s,e){ 
                                                                        var g = SkuCode.GetGridView();
                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'SKUCode;ProductName', UpdateProductName)}"
                                                                
                                                                />
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            
                                            <dx:LayoutItem Caption="Batch No" Visible="false" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtBatchNo" ClientInstanceName="txtBatchNo" runat="server"
                                                            OnInit="lookup_Init"    
                                                            DataSourceID="sdsBatch" KeyFieldName="BatchNo" TextFormatString="{0}" Width="170px" OnLoad="gvLookupLoad">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True"    />
                                                            </GridViewProperties>
                                                           
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="BatchNo" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="SKUcode" Settings-AutoFilterCondition="Contains" />
                                                      

                                                            </Columns>
                                                            <ClientSideEvents 
                                                                    DropDown="function(){ 
                                                                            var date = document.getElementById('cp_frmlayout1_PC_0_dtpDocDate_I').value;
                                                                    var datestring = '\'' + date.split('/')[2] + '-' + date.split('/')[0] + '-'+ date.split('/')[1] + '\'';
                                                              

                                                                    var sku = document.getElementById('cp_frmlayout1_PC_0_txtskucode_I').value;
                                                                      var skustring = '\'' + sku + '\'';
                                                                 

                                                                              gl_objName = 'txtBatchNo';
                                                                              gl_sdsName = 'sdsBatch';

                                                                             

                                                                 if (sku == '' || sku == null || sku == undefined){
                                                                              gl_sqlcmd = 'SELECT BatchNo,MAX(SKUcode) AS SKUcode FROM Production.BatchQueue where Field9 =' + datestring +' GROUP BY BatchNo';
                                                                              }
                                                                 else {
                                                                              gl_sqlcmd = 'SELECT BatchNo,MAX(SKUcode) AS SKUcode FROM Production.BatchQueue where Field9 =' + datestring +' and SKUcode =' + skustring +' GROUP BY BatchNo';
                                                                              }
                                                                          
                                                                              gridLookup_Data();

                                                                              }"
                                                                    ValueChanged="function(){

                                                                                PutDetailIdx = 1;
                                                                                PutObj = txtBatchNo;
                                                                                PutGridUse=PutObj.GetGridView(); 
                                                                                PutColName = ['Hskucode'];
                                                                                PutValueIndex = [1];

                                                                                PutGridUse.GetRowValues(PutGridUse.GetFocusedRowIndex(), 'BatchNo;SKUcode', PutGridCol);
                                                                                }"
                                                                />
                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                   
                                                </LayoutItemNestedControlCollection>                                                
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Scrap Code" Name="scrapcode" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="hscrapcode" ClientInstanceName="hscrapcode" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Scrap Date" Name="scrapdate" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="hscrapdate" runat="server"  ClientInstanceName="hscrapdate"  Width="170px">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Weight" Name="scrapweight" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="hscrapweight" ClientInstanceName="hscrapweight" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="UOM" Name="scrapuom" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="hscrapuom" ClientInstanceName="hscrapuom" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


              <%--                              <dx:LayoutItem Caption="Machine"  ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtMachine" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>




                                            <dx:LayoutItem Caption="Plan Qty" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPlanQty" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Actual Qty" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActualQty" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



                                             <%--Cooking--%>
                                            <dx:LayoutItem Caption="Smokehouse Number (HS No.) " Name ="glSmokehouse" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glSmokehouse" ClientInstanceName="txtSmokehouse" runat="server"
                                                            OnInit="lookup_Init"
                                                            DataSourceID="sdsStep" KeyFieldName="StepCode" TextFormatString="{0}" Width="170px" OnLoad="gvLookupLoad">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="StepCode" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>
<%--                                                            <ClientSideEvents
                                                                DropDown="function(){ 
                                                                               
                                                                              gl_objName = 'txtStepCode';
                                                                              gl_sdsName = 'sdsStep';
                                                                              gl_sqlcmd = 'SELECT StepCode FROM Masterfile.Step';
                                                                             
                                                                              gridLookup_Data();

                                                                              }" />--%>

                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Batch Number " Name="BatchNum" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="BatchNum" runat="server" Width="170px" 
                                                            ReadOnly="true" ClientInstanceName="NumStrands" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right" OnLoad="SpinEdit_Load">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                              <dx:LayoutItem Caption="Time (Standard cooking time Per stage) " name="TimeStandard" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeStandard" runat="server" DateTime="2009/11/01 15:31:34" Width="100">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:LayoutItem Caption="Time Start" name="TimeStart" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeStart" runat="server" DateTime="2009/11/01 15:31:34" Width="100" EditFormat="Time">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                             <dx:LayoutItem Caption="Time End" name="TimeEnd" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeEnd" runat="server" DateTime="2009/11/01 15:31:34" Width="100">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <%--<dx:LayoutItem Caption="Stove Temp - STD">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speTotalBulk" runat="server" Width="170px" 
                                                            ReadOnly="true" ClientInstanceName="txttotalbulk" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>


                                            <dx:LayoutItem Caption="Stove Temp - STD" name="txtStoveTemp" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStoveTemp" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Stove Temp - Actual" name="txtStoveTempAct" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStoveTempAct" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:LayoutItem Caption="Humidity - STD" name="txtHumiditySTD" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHumiditySTD" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Humidity - Actual" name="txtHumidityAct" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHumidityAct" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Steam Pressure" name="txtSteam" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSteam" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            
                                            <dx:LayoutItem Caption="Internal Temp After Cooking" name="txtInternal" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtInternal" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Weighing After Cooking" name="TxtWeighingAC" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="TxtWeighingAC" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="IT Validation (QA)" name="txtValidated" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtValidated" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="" Name="Genereatebtn">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxButton ID="Generatebtn" ClientInstanceName="CINGenerate" runat="server"  Width="170px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" OnLoad="Generate_Btn" ClientVisible="true" Text="Generate" Theme="MetropolisBlue">
                                                                    <ClientSideEvents Click="Generates" />
                                                                </dx:ASPxButton>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                             <dx:LayoutItem  Caption="" Name="Resyncbtn">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxButton ID="Resyncbtn" ClientInstanceName="Resync" runat="server" Visible="false"   Width="170px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" OnLoad="Resync_Btn" ClientVisible="true" Text="Re-sync from WIP" Theme="MetropolisBlue" BackColor="PaleGreen">
                                                                    <ClientSideEvents Click="Generates1" />
                                                                </dx:ASPxButton>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                             <dx:LayoutItem Caption="" name="filler" ClientVisible="true">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="filler" runat="server" Height="0px" Border-BorderWidth="0px" Width="0px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Monitored By" name="txtMonitoredBy" ClientVisible="false" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtMonitoredBy" runat="server" Width="170px" OnLoad ="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Remarks" Name="MemoRemarks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <%--<dx:ASPxTextBox ID="txtRemarks" runat="server"  OnLoad="TextboxLoad"  Width="300px">
                                                             </dx:ASPxTextBox>--%>
                                                        <dx:ASPxMemo ID="MemoRemarks" ClientInstanceName="txtRemarks" runat="server" Height="50px" Width="570px">  
                                                            <%--<ClientSideEvents Init="OnMemoInit" />  --%>
                                                        </dx:ASPxMemo>  


                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>











                                            <dx:LayoutItem Caption="Remarks" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRemarks" runat="server" OnLoad="TextboxLoad" Width="170px" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                           <dx:LayoutItem Caption="GridLookup"  ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="hgridlookup"  ClientInstanceName="hgridlookup" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Back Flush" Name="backflush" Visible="false"> 
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkBackFlash" runat="server" Width="170px" CheckState="Unchecked" ClientInstanceName="cbAutocharge" OnLoad="CheckBoxLoad">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRecWorkCenter" ClientVisible="false" ClientInstanceName="txtRecWorkCenter" runat="server" Width="0px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                        </Items>
                                    </dx:LayoutGroup>


                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Field2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Field3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Field4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>

                                    <dx:LayoutGroup Caption="Audit Trail" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Added By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">

                                                        <dx:ASPxTextBox ID="txtHAddedBy" runat="server" ReadOnly="True" Width="170px">
                                                            <ClientSideEvents Validation="function (s,e)
                                                                {
                                                                 OnValidation = true;
                                                                }" />
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
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" Width="170px" ReadOnly="true">
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
                                                        <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledDate" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Journal Entries" ClientVisible="false">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvJournal" runat="server" AutoGenerateColumns="False" Width="850px" ClientInstanceName="gvJournal" KeyFieldName="RTransType;TransType">
                                                            <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" />
                                                            <SettingsPager Mode="ShowAllRecords" />
                                                            <SettingsEditing Mode="Batch" />
                                                            <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130" />
                                                            <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                            <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="AccountCode" Name="jAccountCode" ShowInCustomizationForm="True" VisibleIndex="0" Width="120px" Caption="Account Code">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="AccountDescription" Name="jAccountDescription" ShowInCustomizationForm="True" VisibleIndex="1" Width="150px" Caption="Account Description">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="SubsidiaryCode" Name="jSubsidiaryCode" ShowInCustomizationForm="True" VisibleIndex="2" Width="120px" Caption="Subsidiary Code">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="SubsidiaryDescription" Name="jSubsidiaryDescription" ShowInCustomizationForm="True" VisibleIndex="3" Width="150px" Caption="Subsidiary Description">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="ProfitCenter" Name="jProfitCenter" ShowInCustomizationForm="True" VisibleIndex="4" Width="120px" Caption="Profit Center">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="CostCenter" Name="jCostCenter" ShowInCustomizationForm="True" VisibleIndex="5" Width="120px" Caption="Cost Center">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataSpinEditColumn FieldName="BizPartnerCode" Name="jBizPartnerCode" ShowInCustomizationForm="True" VisibleIndex="6" Width="150px" Caption="Business Partner">
                                                                </dx:GridViewDataSpinEditColumn>
                                                                <dx:GridViewDataSpinEditColumn FieldName="Debit" Name="jDebit" ShowInCustomizationForm="True" VisibleIndex="7" Width="120px" Caption="Debit Amount">
                                                                    <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                                <dx:GridViewDataSpinEditColumn FieldName="Credit" Name="jCredit" ShowInCustomizationForm="True" VisibleIndex="8" Width="120px" Caption="Credit Amount">
                                                                    <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                            </Columns>
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>

                                    <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction" ClientVisible="false">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="608px" ClientInstanceName="gvRef" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber">
                                                            <ClientSideEvents Init="OnInitTrans" />
                                                            <%--<Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="130" VerticalScrollBarMode="Auto" />--%>
                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" />
                                                            <SettingsPager PageSize="5">
                                                            </SettingsPager>
                                                            <SettingsEditing Mode="Batch">
                                                            </SettingsEditing>
                                                            <SettingsBehavior FilterRowMode="OnClick" ColumnResizeMode="NextColumn" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" Caption="DocNumber">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="RTransType" Caption="Reference TransType" ShowInCustomizationForm="True" VisibleIndex="1" ReadOnly="True" Name="RTransType">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="90px">
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
                            </dx:TabbedLayoutGroup>


 <%-- Batch Detail--%>
    <dx:LayoutGroup Caption=" Details" ColCount="2">
    <Items>
        <dx:LayoutItem ShowCaption="False">
            <LayoutItemNestedControlCollection>
                <dx:LayoutItemNestedControlContainer runat="server">

                  <dx:ASPxLabel runat="server" Text="" Font-Bold="true" ForeColor="Gray"  Font-Size="Medium" ></dx:ASPxLabel>                                       
                    <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="1980px" DataSourceID ="sdsDetail"
                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" 
                             KeyFieldName="DocNumber;LineNumber" SettingsEditing-BatchEditSettings-ShowConfirmOnLosingChanges="true">
                                  <SettingsBehavior AllowSort="false" AllowGroup="false" />    
                                        <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm"
                                             BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                        
                                                  <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager PageSize="1000"  Visible="False"/> 
                                                    <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto"  ColumnMinWidth="120" VerticalScrollableHeight="330"  /> 
                                                    <SettingsDetail ShowDetailRow="true" ShowDetailButtons="true" AllowOnlyOneMasterRowExpanded="true" />
                         <Columns>
                                                           <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                           </dx:GridViewDataTextColumn>
                                                              
                                                                     <dx:GridViewCommandColumn ShowDeleteButton="true"  ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="1px" ShowNewButtonInHeader="true">
                                                                           <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Details0">
                                                                                    <Image IconID="support_info_16x16"></Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>


                                                            
                                                                      </dx:GridViewCommandColumn>
                                                          <dx:GridViewDataTextColumn Caption="" FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            </dx:GridViewDataTextColumn>                          

                                                         <dx:GridViewDataTextColumn Caption="" FieldName="ItemCode" Name="ItemCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            </dx:GridViewDataTextColumn>

                                                            <dx:GridViewDataTextColumn Caption="Item Code" FieldName="ItemC" Name="ItemC" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            </dx:GridViewDataTextColumn>

                                                         <dx:GridViewDataTextColumn Caption="Item Description" FieldName="ItemDescription" Name="ItemDescription" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21" Width="175px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            </dx:GridViewDataTextColumn>





                                                        <dx:GridViewDataSpinEditColumn Caption="Initial Yield" FieldName="InitialYield" Name="InitialYield" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="22" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="InitialYield"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                       <ClientSideEvents ValueChanged ="calculate_InitialYield" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>


                                                     <%--   PRODUCTION PLAN--%>

                                                        
                                                            <dx:GridViewBandColumn Name="ProductionPlan" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="ProductionPlan" ClientInstanceName="ProductionPlan" runat="server" Text="PLAN">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="DAY" FieldName="ProductionPlanDay" Name="ProductionPlanDay" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="ProductionPlanDay"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                       <ClientSideEvents ValueChanged ="calculate_ProductionPlan" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                <dx:GridViewDataSpinEditColumn Caption="NIGHT" FieldName="ProductionPlanNight" Name="ProductionPlanNight" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="ProductionPlanNight"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_ProductionPlan" /> 
                                                                                        
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="(In Batch)" FieldName="ProductionPlanTotal" Name="ProductionPlanTotal"  ReadOnly="true" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="ProductionPlanTotal"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2" SpinButtons-Enabled="false"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>

                                                     <%--   ACTUAL PRODUCED		--%>

                                                        
                                                            <dx:GridViewBandColumn Name="ActualProduced" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="ActualProduced" ClientInstanceName="ActualProduced" runat="server" Text="ACTUAL">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="DAY" FieldName="ActualProducedDay" Name="ActualProducedDay" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="ActualProducedDay"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_ActualProduced" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                <dx:GridViewDataSpinEditColumn Caption="NIGHT" FieldName="ActualProducedNight" Name="ActualProducedNight" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="ActualProducedNight"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_ActualProduced" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="(In Batch)" FieldName="ActualProducedTotal" Name="ActualProducedTotal" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                                  
                                                                                   
                                                                                   <PropertiesSpinEdit  ClientInstanceName="PLTotal"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_ActualProduced" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>


                                                     <%--   TIP-IN		--%>

                                                        
                                                            <dx:GridViewBandColumn Name="Tipin" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="Tipin" ClientInstanceName="Tipin" runat="server" Text="TIP-IN">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="DAY" FieldName="TipinDay" Name="TipinDay" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="TipinDay"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <%--<ClientSideEvents ValueChanged ="calculate_Tipin" /> --%>
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                <dx:GridViewDataSpinEditColumn Caption="(Scrap)" FieldName="TipinNight" Name="TipinNight" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="TipinNight"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_Input" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="(Emulsion)" FieldName="TipinTotal" Name="TipinTotal" ShowInCustomizationForm="True"   UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="TipinTotal"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_Input" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>

                                                        <dx:GridViewDataSpinEditColumn Caption="STD BATCH WEIGHT" FieldName="stdBatchWeight" Name="SmokeHouseNo" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="28" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                            <PropertiesSpinEdit  ClientInstanceName="stdBatchWeight" DisplayFormatString="{0}"> 
                                                                                     
                                                                                            </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                         </dx:GridViewDataSpinEditColumn>


                                                     <%--   INPUT	--%>

                                                        
                                                            <dx:GridViewBandColumn Name="Input" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="Input" ClientInstanceName="Input" runat="server" Text="TOTAL INPUT">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="DAY" FieldName="InputDay" Name="InputDay" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="InputDay"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_Input" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                <dx:GridViewDataSpinEditColumn Caption="NIGHT" FieldName="InputNight" Name="InputNight" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="InputNight"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_Input" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="(in kgs)" FieldName="InputTotal" Name="InputTotal" ShowInCustomizationForm="True"  ReadOnly="true" UnboundType="String"  VisibleIndex="20" Width="85px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="InputTotal"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_InitialYield" />  
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>


                                                     <%--   SMOKEHOUSE	--%>

                                                        
                                                            <dx:GridViewBandColumn Name="Smokehouse" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="Smokehouse" ClientInstanceName="Smokehouse" runat="server" Text="SMOKEHOUSE">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="Before Cooking" FieldName="BC" Name="BC" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="125px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="BC"  NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                     <ClientSideEvents ValueChanged ="Calculate_BC" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                <dx:GridViewDataSpinEditColumn Caption="PRO_yield" FieldName="PROyield" Name="PROyield" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="PROyield"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="After Cooking" FieldName="AC" Name="AC" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="125px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="AC" NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                     <ClientSideEvents ValueChanged ="Calculate_BC" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                 <dx:GridViewDataSpinEditColumn Caption="Cooking loss %" FieldName="CookingLoss" Name="CookingLoss" ShowInCustomizationForm="True" HeaderStyle-Wrap="True" UnboundType="String"  VisibleIndex="20" Width="90px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="CookingLoss"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="SM Yield" FieldName="SMYield" Name="SMYield" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="SMYield"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2" > 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>


                                                    <%--   PACKAGING INITIAL OUTPUT	--%>

                                                        
                                                            <dx:GridViewBandColumn Name="PackagingInitialOut" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="PackagingInitialOut" ClientInstanceName="PackagingInitialOut" runat="server" Text="FGs">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="DAY" FieldName="PackagingInitialOutDay" Name="PackagingInitialOutDay" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="PackagingInitialOutDay"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_PackagingInitial" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                <dx:GridViewDataSpinEditColumn Caption="NIGHT" FieldName="PackagingInitialOutNight" Name="PackagingInitialOutNight" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="PackagingInitialOutNight"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_PackagingInitial" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               
                                                                               <dx:GridViewDataSpinEditColumn Caption="(in Kgs)" FieldName="PackagingInitialOutTotal" Name="PackagingInitialOutTotal"  ReadOnly="true" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="PackagingInitialOutTotal"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                    <ClientSideEvents ValueChanged ="calculate_InitialYield" />  
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="(in Packs)" FieldName="PackagingInitialOutTotalPkcs" Name="PackagingInitialOutTotalPkcs"  ReadOnly="true" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="PackagingInitialOutTotalPkcs"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                    <ClientSideEvents ValueChanged ="calculate_InitialYield" />  
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>

                                                     <%--   REJECTION SUMMAR	--%>

                                                        
                                                            <dx:GridViewBandColumn Name="RejectionSummary" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="RejectionSummary" ClientInstanceName="RejectionSummary" runat="server" Text="Rejection Summary">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="%" FieldName="RejectionSummarypercent" Name="RejectionSummarypercent" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="110px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="RejectionSummarypercent"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>



                                                                               
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>



                             
                                                     <%--   Generated Scrap  --%>

                                                        
                                                            <dx:GridViewBandColumn Name="GeneratedScrap" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="GeneratedScrap" ClientInstanceName="GeneratedScrap" runat="server" Text="Generated Scrap">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                             

                                                                                <dx:GridViewDataSpinEditColumn Caption="(in kgs)" FieldName="RejectionSummarypercentTotal" Name="RejectionSummarypercentTotal" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="105px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="RejectionSummarypercentTotal"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                         <ClientSideEvents ValueChanged ="calculate_RejectionSummaryPercent" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>


                                                                               
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>
                                                     <%--  SMKH	--%>

                                                        
                                                            <dx:GridViewBandColumn Name="SMKH" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="SMKH" ClientInstanceName="SMKH" runat="server" Text="SMKH">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="UL/UT" FieldName="SMKHULUT" Name="SMKHULUT" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="SMKHULUT"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_RejectionSummaryTotal" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

              
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>

                                                     <%--  BRINE	--%>

                                                        
                                                            <dx:GridViewBandColumn Name="BRINE" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="BRINE" ClientInstanceName="BRINE" runat="server" Text="BRINE">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="UL/UT" FieldName="BRINEULUT" Name="BRINEULUT" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="BRINEULUT"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_RejectionSummaryTotal" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

              
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>

                                                        <%--  CUTTING	--%>

                                                        
                                                            <dx:GridViewBandColumn Name="CUTTING" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="CUTTING" ClientInstanceName="CUTTING" runat="server" Text="CUTTING">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="UL/UT" FieldName="CUTTINGULUT" Name="CUTTINGULUT" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="CUTTINGULUT"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_RejectionSummaryTotal" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

              
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>
                                                            <%--  PACKAGING	--%>

                                                        
                                                            <dx:GridViewBandColumn Name="Packaging" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="Packaging" ClientInstanceName="Packaging" runat="server" Text="PACKAGING">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="UL/UT" FieldName="PackagingULUT" Name="PackagingULUT" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="PackagingULUT"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_RejectionSummaryTotal" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                 <dx:GridViewDataSpinEditColumn Caption="OS/DF" FieldName="PackagingOSDF" Name="PackagingOSDF" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="PackagingOSDF"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_RejectionSummaryTotal" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                 <dx:GridViewDataSpinEditColumn Caption="MISCUT" FieldName="PackagingMISCUT" Name="PackagingMISCUT" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="PackagingMISCUT"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_RejectionSummaryTotal" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

              
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>
                                                                 <%--  SECTION	--%>

                                                        
                                                            <dx:GridViewBandColumn Name="Section" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="Section" ClientInstanceName="Section" runat="server" Text="SENSORY">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                

                                                                                 <dx:GridViewDataSpinEditColumn Caption="SAMPLE" FieldName="SectionSAMPLE" Name="SectionSAMPLE" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="SectionSAMPLE"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_RejectionSummaryPercent" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

              
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>

                                                         <%--  FG GIVEAWAY	--%>

                                                        
                                                            <dx:GridViewBandColumn Name="FGGiveaway" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="FGGiveaway" ClientInstanceName="FGGiveaway" runat="server" Text="FG GIVEAWAY">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="STD" FieldName="FGGiveawaySTD" Name="FGGiveawaySTD" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="FGGiveawaySTD"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="3"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_FGGiveawaypercent" />  
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                 <dx:GridViewDataSpinEditColumn Caption="ACTUAL" FieldName="FGGiveawayActual" Name="FGGiveawayActual" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="FGGiveawayActual"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="3"> 
                                                                                   <ClientSideEvents ValueChanged ="calculate_FGGiveawaypercent" />   
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                 <dx:GridViewDataSpinEditColumn Caption="%" FieldName="FGGiveawayPercent" Name="FGGiveawayPercent" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="FGGiveawayPercent"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="3"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

              
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>

                                                           <dx:GridViewDataSpinEditColumn Caption="TOTAL YIELD" FieldName="TotalYield" Name="TotalYield" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="28" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                            <PropertiesSpinEdit  ClientInstanceName="TotalYield"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="3"> 
                                                                                     
                                                                                            </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                         </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Standard Yield" FieldName="StandaredYield" Name="StandaredYield" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="28" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                            <PropertiesSpinEdit  ClientInstanceName="StandaredYield" DisplayFormatString="{0}"> 
                                                                                     
                                                                                            </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                         </dx:GridViewDataSpinEditColumn>
                                              <dx:GridViewDataSpinEditColumn Caption="Standard wt per strand" FieldName="StandardWTPStrand" Name="StandardWTPStrand" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="28" Width="0px" HeaderStyle-BackColor="#EBEBEB" CellStyle-Wrap="True" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                            <PropertiesSpinEdit  ClientInstanceName="StandardWTPStrand" DisplayFormatString="{0}"> 
                                                                                     
                                                                                            </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                         </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Standard wt per strand" FieldName="AVGWrange" Name="AVGWrange" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="28" Width="0px" HeaderStyle-BackColor="#EBEBEB" CellStyle-Wrap="True" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                            <PropertiesSpinEdit  ClientInstanceName="AVGWrange" DisplayFormatString="{0}"> 
                                                                                     
                                                                                            </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                         </dx:GridViewDataSpinEditColumn>

                                                         <dx:GridViewDataSpinEditColumn Caption="Standard Case Con" FieldName="StandardCaseCon" Name="StandardCaseCon" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="28" Width="0px" HeaderStyle-BackColor="#EBEBEB" CellStyle-Wrap="True" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                            <PropertiesSpinEdit  ClientInstanceName="StandardCaseCon" DisplayFormatString="{0}"> 
                                                                                        
                                                                                            </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                         </dx:GridViewDataSpinEditColumn>
                                                         <dx:GridViewDataSpinEditColumn Caption="AVG Kilo Per Piece" FieldName="AVGKiloPPiece" Name="AVGKiloPPiece" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="28" Width="0px" HeaderStyle-BackColor="#EBEBEB" CellStyle-Wrap="True" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                            <PropertiesSpinEdit  ClientInstanceName="AVGKiloPPiece" DisplayFormatString="{0}"> 
                                                                                     
                                                                                            </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                         </dx:GridViewDataSpinEditColumn>
                           
                                                        <dx:GridViewDataSpinEditColumn Caption="Spillage Total" FieldName="SpillageTotal" Name="SpillageTotal" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="28" Width="0px" HeaderStyle-BackColor="#EBEBEB" CellStyle-Wrap="True" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                            <PropertiesSpinEdit  ClientInstanceName="SpillageTotal" DisplayFormatString="{0}"> 
                                                                                     
                                                                                            </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                         </dx:GridViewDataSpinEditColumn>

                                                          <%--   SPILLAGE--%>

                                                        
                                                            <dx:GridViewBandColumn Name="SPILLAGES" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="Spillages" ClientInstanceName="Spillages" runat="server" Text="SPILLAGES">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="MDM" FieldName="Spillage1" Name="Spillage1" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="Spillage1"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                       <ClientSideEvents ValueChanged ="calculate_ProductionPlan" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                <dx:GridViewDataSpinEditColumn Caption="2" FieldName="Spillage2" Name="Spillage2" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="Spillage2"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_ProductionPlan" /> 
                                                                                        
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="3" FieldName="Spillage3" Name="Spillage3" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="Spillage3"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_ProductionPlan" /> 
                                                                                        
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                              
                                                                               <dx:GridViewDataSpinEditColumn Caption="4" FieldName="Spillage4" Name="Spillage4" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="Spillage4"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_ProductionPlan" /> 
                                                                                        
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                              
                                                                               <dx:GridViewDataSpinEditColumn Caption="5" FieldName="Spillage5" Name="Spillage5" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="Spillage5"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_ProductionPlan" /> 
                                                                                       
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                              
                                                                               <dx:GridViewDataSpinEditColumn Caption="6" FieldName="Spillage6" Name="Spillage6" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="Spillage6"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_ProductionPlan" /> 
                                                                                        
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                              
                                                                              

                                                                               
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>

                                 
                                                              
                                                              
                                                            </Columns>
                                                                           <Templates>
                                                                                            <DetailRow>
                                                                                                <div style="padding: 3px 3px 2px 3px">
                                                                                                    <dx:ASPxPageControl runat="server" ID="StepProcessDetail" Width="100%" EnableCallBacks="true">
                                                                                                        <TabPages>
                                                                                                            <dx:TabPage Text="Consumables" Visible="true">
                                                                                                                <ContentCollection>
                                                                                                                    <dx:ContentControl runat="server">
                                                                                                                        <dx:ASPxGridView ID="gvStepBOM" ClientInstanceName="gvStepBOM" DataSourceID="sdsBOM" runat="server" KeyFieldName="ItemC;LineNumber" Width="25%" 
                                                                                                                            OnBeforePerformDataSelect="detailBOM_BeforePerformDataSelect" OnRowInserting="gvStepBOM_RowInserting" OnRowUpdating="gvStepBOM_RowUpdating"
                                                                                                                            OnRowDeleting="gvStepBOM_RowDeleting" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize">
                                                                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick"/>
                                                                                                                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                                                                            <SettingsEditing Mode="Batch" ></SettingsEditing>
                                                                                                                            <SettingsBehavior AllowSort="False"/>
                                                                                                                            <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 
                                                                                                                            <SettingsDetail ShowDetailRow="true" ShowDetailButtons="false" AllowOnlyOneMasterRowExpanded="true" />
                                                                                                                                <SettingsCommandButton>
                                                                                                                                <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                                                                                <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                                                                                <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                                                                            </SettingsCommandButton>
                                                                                                                            <Styles>
                                                                                                                                <StatusBar CssClass="statusBar">
                                                                                                                                </StatusBar>
                                                                                                                            </Styles>
                                                                                                                            <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewCommandColumn ShowUpdateButton="true" ButtonType="Image" ShowInCustomizationForm="True" Width="50px" ShowNewButtonInHeader="True">
                                                                                                                                    <CustomButtons>
                                                                                                                                        <dx:GridViewCommandColumnCustomButton ID="BOMDelete">
                                                                                                                                        <Image IconID="actions_cancel_16x16"> </Image>
                                                                                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                                                                                    </CustomButtons>
                                                                                                                                </dx:GridViewCommandColumn>
                                                                                                                                <dx:GridViewDataColumn FieldName="RecordID" Width="0%"/>
                                                                                                                                <dx:GridViewDataColumn FieldName="DocNumber" Width="0%"/>
                                                                                                                                <dx:GridViewDataColumn FieldName="ItemC" Width="0%"/>                                                                                                     
                                                                                                                                
                                                                                                                                <dx:GridViewDataTextColumn FieldName="LineNumber" Width="0px">
                                                                                                                                    <EditFormSettings Visible="False" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Material" Caption="Material" Name="Material" ShowInCustomizationForm="True" Width="150px"></dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="UsagePerBatch" Caption="Usage Per Batch" Name="UsagePerBatch" ShowInCustomizationForm="True" Width="150px"></dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Spillage" Caption="Spillage" Name="Spillage" ShowInCustomizationForm="True" Width="150px"></dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="StandardUsage" Caption="Standard Usage" Name="StandardUsage" ShowInCustomizationForm="True" Width="0px"></dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="ActualUsage" Caption="Actual Usage" Name="ActualUsage" ShowInCustomizationForm="True" Width="0px"></dx:GridViewDataTextColumn>
                                                                                                                         
                                                                                                                
                                                                                                                            </Columns>
                                                                                                                            
                                                                                                                                                           
                                                                                                                                                                            
                                                                                                                        <SettingsDetail IsDetailGrid="True" />
                                                                                                                    </dx:ASPxGridView>
                                                                                                                        <table id="TotDate" class="TotDate" 
                                                                                                                                style="
                                                                                                                                border:solid; 
                                                                                                                                border-width:thin; 
                                                                                                                                border-color:rgba(128, 128, 128, 0.54);
                                                                                                                                margin-bottom:50px;">
                                                            
                                                                                                                                    <tr>

                                                                                                                                        <td style="border-right:solid;  border-width:thin; border-color:rgba(128, 128, 128, 0.54); width:925px;  padding-right:5px; font-weight: bold;" >Note: Make sure header detail are already updated before making changes in Consumables detail. and kindly refresh page after saving changes to update header details</td>
                                                                                                                                   
                                                                                                                                    </tr>

                                                                                                                             </table>
                                                                                                                </dx:ContentControl>
                                                                                                            </ContentCollection>
                                                                                                        </dx:TabPage>

                                                                                                    </TabPages>
                                                                                                </dx:ASPxPageControl>
                                                                                            </div>

                                                                                        </DetailRow>        
                                                                                    </Templates>                                                    


                                                                     <Settings ShowFooter="false" />
                                                                                        <TotalSummary>
                                                                                            <%--<dx:ASPxSummaryItem FieldName="ProductionPlanDay" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="ProductionPlanNight" SummaryType="Sum" DisplayFormat="{0}"/>--%>
                                                                                            <dx:ASPxSummaryItem FieldName="ProductionPlanTotal" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <%--<dx:ASPxSummaryItem FieldName="ActualProducedDay" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="ActualProducedNight" SummaryType="Sum" DisplayFormat="{0}"/>--%>
                                                                                            <dx:ASPxSummaryItem FieldName="ActualProducedTotal" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="PLTotal" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <%--<dx:ASPxSummaryItem FieldName="TipinDay" SummaryType="Sum" DisplayFormat="{0}"/>--%>
                                                                                            <dx:ASPxSummaryItem FieldName="TipinNight" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="TipinTotal" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="InputDay" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="InputNight" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="InputTotal" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="BC" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="AC" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="CookingLoss" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="PackagingInitialOutDay" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="PackagingInitialOutNight" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="PackagingInitialOutTotal" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="RejectionSummarypercentTotal" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="SMKHULUT" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="BRINEULUT" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="CUTTINGULUT" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="PackagingULUT" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="PackagingOSDF" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="PackagingMISCUT" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="SectionSAMPLE" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="FGGiveawaySTD" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="FGGiveawayActual" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                            <dx:ASPxSummaryItem FieldName="FGGiveawayPercent" SummaryType="Sum" DisplayFormat="{0}"/>
                                                                                           

                                                                                          
                                                                                        </TotalSummary>

                                              </dx:ASPxGridView>

                                                       


                                                          
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                                 </dx:LayoutItem>

                                             </Items>
                                    </dx:LayoutGroup>
 <%-- Batch Detail End--%>
                             <%-- Batch Detail--%>
    <dx:LayoutGroup Caption=" Details" ColCount="2">
    <Items>
        <dx:LayoutItem ShowCaption="False">
            <LayoutItemNestedControlCollection>
                <dx:LayoutItemNestedControlContainer runat="server">

                                  <dx:ASPxLabel runat="server" Text="" Font-Bold="true" ForeColor="Gray"  Font-Size="Medium" ></dx:ASPxLabel>                                       
                    <dx:ASPxGridView ID="gv2" runat="server" AutoGenerateColumns="False" Width="1980px" DataSourceID ="sdsDetail2"
                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv2" 
                             KeyFieldName="DocNumber;LineNumber" SettingsEditing-BatchEditSettings-ShowConfirmOnLosingChanges="true">
                                  <SettingsBehavior AllowSort="false" AllowGroup="false" />    
                                        <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm"
                                             BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                        
                                                  <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager PageSize="1000"  Visible="False"/> 
                                                    <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="730"  /> 
                                                    <Columns>
                                                           <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                           </dx:GridViewDataTextColumn>
                                                              
                                                                     <dx:GridViewCommandColumn ShowDeleteButton="true"  ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="50px" ShowNewButtonInHeader="true">
                                                                           <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Details1">
                                                                                    <Image IconID="support_info_16x16"></Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                            
                                                                      </dx:GridViewCommandColumn>
                                                       
                                                          <dx:GridViewDataTextColumn Caption="" FieldName="ItemCode" Name="ItemCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            </dx:GridViewDataTextColumn>

                                                            <dx:GridViewDataTextColumn Caption="Item Code" FieldName="ItemC" Name="ItemC" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            </dx:GridViewDataTextColumn>

                                                         <dx:GridViewDataTextColumn Caption="Item Description" FieldName="ItemDescription" Name="ItemDescription" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21" Width="135px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            </dx:GridViewDataTextColumn>

                                                <%--MEAT - STANDARD USAGE (KGS)--%>

                                                            <dx:GridViewBandColumn Name="MEATStdUse" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="MEATStdUse" ClientInstanceName="MEATStdUse" runat="server" Text="STANDARD USAGE">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="MDM" FieldName="MEATStdUseMDM" Name="MEATStdUseMDM" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="MEATStdUseMDM"   NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                     <%--<ClientSideEvents ValueChanged ="calculate_Theoretical" /> --%>
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                <dx:GridViewDataSpinEditColumn Caption="THEORETICAL" FieldName="MEATStdUseTHEORETICAL"  Name="MEATStdUseTHEORETICAL" ShowInCustomizationForm="True" HeaderStyle-Wrap="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="MEATStdUseTHEORETICAL"  NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3">  
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="Chx Skin" FieldName="MEATStdUseCOPACOL" Name="MEATStdUseCOPACOL" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="MEATStdUseCOPACOL"   NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="Chicken Fat" FieldName="MEATStdUseFatA" Name="MEATStdUseFatA" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="MEATStdUseFatA"   NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="EMERGING" FieldName="MEATStdUseEMERGING" Name="MEATStdUseEMERGING" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="MEATStdUseEMERGING"   NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="Beef Fat" FieldName="MEATStdUseBEEF" Name="MEATStdUseBEEF" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="MEATStdUseBEEF"   NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="Ground Meat" FieldName="MEATStdUseGroundMeat" Name="MEATStdUseGroundMeat" HeaderStyle-Wrap="True" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="MEATStdUseGroundMeat"   NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="Cheese" FieldName="Cheese" Name="Cheese" HeaderStyle-Wrap="True" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="Cheese"   NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>




                                                                               
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>

                                                 <%--MEAT - ACTUAL USAGE (KGS)--%>

                                                            <dx:GridViewBandColumn Name="MEATActUse" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="MEATActUse" ClientInstanceName="MEATActUse" runat="server" Text="SPILLAGES">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="MDM" FieldName="MEATActUseMDM" Name="MEATActUseMDM" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="MEATActUseMDM"   NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                      <ClientSideEvents ValueChanged ="calculate_Input" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                <dx:GridViewDataSpinEditColumn Caption="THEORETICAL" FieldName="MEATActUseTHEORETICAL" Name="MEATActUseTHEORETICAL" HeaderStyle-Wrap="True" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="MEATActUseTHEORETICAL"   NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="Chx Skin" FieldName="MEATActUseCOPACOL" Name="MEATActUseCOPACOL" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="MEATActUseCOPACOL"  NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                      <ClientSideEvents ValueChanged ="calculate_Input" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="Chicken Fat" FieldName="MEATActUseFatA" Name="MEATActUseFatA" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="MEATActUseFatA"  NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                      <ClientSideEvents ValueChanged ="calculate_Input" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="EMERGING" FieldName="MEATActUseEMERGING" Name="MEATActUseEMERGING" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="MEATActUseEMERGING"   NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="Beef Fat" FieldName="MEATActUseBEEF" Name="MEATActUseBEEF" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="MEATActUseBEEF"   NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                      <ClientSideEvents ValueChanged ="calculate_Input" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="Ground Meat" FieldName="MEATActUseGroundMeat" Name="MEATActUseGroundMeat" HeaderStyle-Wrap="True" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="MEATActUseGroundMeat"   NullDisplayText="0.000" NullText="0.000" DisplayFormatString="{0:N3}" DecimalPlaces="3"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>




                                                                               
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>

                                                
                                                 <%--CASING--%>

                                                            <dx:GridViewBandColumn Name="Casing" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="Casing" ClientInstanceName="Casing" runat="server" Text="CASING">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>

                                                                               <dx:GridViewDataTextColumn Caption="SKUCode" FieldName="CasingSKU" Name="CasingSKU" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                 </dx:GridViewDataTextColumn>
                                                                               <dx:GridViewDataTextColumn FieldName="SKUCode1" Caption="SKUCode" VisibleIndex="2" Width="100px" Name="SKU1" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True" >
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="SKU1" ClientInstanceName="SKU1" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                            DataSourceID="sdsSKU1" KeyFieldName="SKUCode" TextFormatString="{0}" Width="90px">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                    AllowSelectSingleRowOnly="True" />
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="SKUCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                                                <dx:GridViewDataTextColumn FieldName="CasingSTD" ReadOnly="True" VisibleIndex="2" Settings-AutoFilterCondition="Contains" />
                                                                                            </Columns>
                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                                                ValueChanged="function(){

                                                                                                        PutDetailIdx = 1;
                                                                                                        PutObj = SKU1;
                                                                                                        PutGridUse=PutObj.GetGridView(); 
                                                                                                        PutColName = ['SKUCode1','CasingSTD'];
                                                                                                        PutValueIndex = [0];

                                                                                                        PutGridUse.GetRowValues(PutGridUse.GetFocusedRowIndex(), 'SKUCode;SKUCode;CasingSTD', PutGridCol);
                                                                                                        }" />

                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataSpinEditColumn Caption="STD" FieldName="CasingSTD" Name="CasingSTD" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="CasingSTD"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_CasingRej" /> 
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                <dx:GridViewDataSpinEditColumn Caption="Actual" FieldName="CasingACT" Name="CasingACT" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="CasingACT"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_CasingRej" />  
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="Rejection%" FieldName="CasingREJ" Name="CasingREJ" ShowInCustomizationForm="True" ReadOnly="true" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="CasingREJ"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                    <%--<ClientSideEvents ValueChanged ="calculate_CasingTotal" />  --%>
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="TOTAL" FieldName="CasingTOTAL" Name="CasingTOTAL" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="CasingTOTAL"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="DIFF" FieldName="CasingDIFF" Name="CasingDIFF" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="CasingDIFF"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>


                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>

                                                  <%--PLASTIC PACKAGING--%>

                                                            <dx:GridViewBandColumn Name="PlasticPackaging" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="PlasticPackaging" ClientInstanceName="PlasticPackaging" runat="server" Text="PLASTIC PACKAGING">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                               <dx:GridViewDataTextColumn Caption="SKUCode" FieldName="PlasticPackagingSKU" Name="PlasticPackagingSKU" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                 </dx:GridViewDataTextColumn>
                                                                               <dx:GridViewDataTextColumn FieldName="SKUCode2" Caption="SKUCode" VisibleIndex="2" Width="100px" Name="SKU2"  HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True">
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="SKU2" ClientInstanceName="SKU2" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                            DataSourceID="sdsSKU2" KeyFieldName="SKUCode" TextFormatString="{0}" Width="90px">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                    AllowSelectSingleRowOnly="True" />
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="SKUCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                                                 <dx:GridViewDataTextColumn FieldName="PlasticPackagingSTD" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                                                
                                                                                            </Columns>
                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                                                ValueChanged="function(){

                                                                                                        PutDetailIdx = 1;
                                                                                                        PutObj = SKU2;
                                                                                                        PutGridUse=PutObj.GetGridView(); 
                                                                                                        PutColName = ['SKUCode2','PlasticPackagingSTD'];
                                                                                                        PutValueIndex = [0];

                                                                                                        PutGridUse.GetRowValues(PutGridUse.GetFocusedRowIndex(), 'SKUCode;SKUCode;PlasticPackagingSTD', PutGridCol);
                                                                                                        }" />

                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>

                                                                                <dx:GridViewDataSpinEditColumn Caption="STD" FieldName="PlasticPackagingSTD" Name="PlasticPackagingSTD" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="PlasticPackagingSTD"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_PlasticPackagingRej" />   
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                <dx:GridViewDataSpinEditColumn Caption="Actual" FieldName="PlasticPackagingACT" Name="PlasticPackagingACT" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="PlasticPackagingACT"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_PlasticPackagingRej" />    
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="Rejection%" FieldName="PlasticPackagingREJ" Name="PlasticPackagingREJ" ShowInCustomizationForm="True" ReadOnly="true" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="PlasticPackagingREJ"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_PlasticPackagingTotal" />    
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="TOTAL" FieldName="PlasticPackagingTOTAL" Name="PlasticPackagingTOTAL" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="PlasticPackagingTOTAL"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="DIFF" FieldName="PlasticPackagingDIFF" Name="PlasticPackagingDIFF" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="PlasticPackagingDIFF"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>


                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>

                                                          <%--CARTON--%>

                                                            <dx:GridViewBandColumn Name="Carton" AllowDragDrop="False" VisibleIndex="28" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="Carton" ClientInstanceName="Carton" runat="server" Text="CARTON">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                               <dx:GridViewDataTextColumn Caption="SKUCode" FieldName="CartonSKU" Name="CartonSKU" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="20" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                 </dx:GridViewDataTextColumn>
                                                                                 <dx:GridViewDataTextColumn FieldName="SKUCode3" Caption="SKUCode" VisibleIndex="2" Width="100px" Name="SKU3"  HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True">
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="SKU3" ClientInstanceName="SKU3" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                            DataSourceID="sdsSKU3" KeyFieldName="SKUCode" TextFormatString="{0}" Width="90px">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                    AllowSelectSingleRowOnly="True" />
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="SKUCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                                                <dx:GridViewDataTextColumn FieldName="CartonACT" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                                            </Columns>
                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                                                ValueChanged="function(){

                                                                                                        PutDetailIdx = 1;
                                                                                                        PutObj = SKU3;
                                                                                                        PutGridUse=PutObj.GetGridView(); 
                                                                                                        PutColName = ['SKUCode3','CartonACT'];
                                                                                                        PutValueIndex = [0];

                                                                                                        PutGridUse.GetRowValues(PutGridUse.GetFocusedRowIndex(), 'SKUCode;SKUCode;CartonACT', PutGridCol);
                                                                                                        }" />

                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataSpinEditColumn Caption="STD" FieldName="CartonSTD" Name="CartonSTD" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="CartonSTD"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     <ClientSideEvents ValueChanged ="calculate_CartonRej" />  
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                                <dx:GridViewDataSpinEditColumn Caption="ACT" FieldName="CartonACT" Name="CartonACT" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="CartonACT"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                   <ClientSideEvents ValueChanged ="calculate_CartonRej" />  
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <dx:GridViewDataSpinEditColumn Caption="REJ" FieldName="CartonREJ" Name="CartonREJ" ShowInCustomizationForm="True" UnboundType="String" ReadOnly="true"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="CartonREJ"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                               
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>

                                                                               <%--<dx:GridViewDataSpinEditColumn Caption="TOTAL" FieldName="CartonTOTAL" Name="CartonTOTAL" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="CartonTOTAL"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>--%>

<%--                                                                               <dx:GridViewDataSpinEditColumn Caption="DIFF" FieldName="CartonDIFF" Name="CartonDIFF" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="75px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="CartonDIFF"  NullDisplayText="0.00" NullText="0.00" DisplayFormatString="{0:N2}" DecimalPlaces="2"> 
                                                                                     
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>--%>


                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>
                                                         <dx:GridViewDataMemoColumn Caption="Remarks" FieldName="ItemRemarks" Name="ItemRemarks" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="100" Width="275px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-Wrap="True"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            </dx:GridViewDataMemoColumn>
                                                
                                                            </Columns>

              </dx:ASPxGridView>

                                                       


                                                          
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                                 </dx:LayoutItem>

                                             </Items>
                                    </dx:LayoutGroup>
 <%-- Batch Detail End--%>

                                            <dx:LayoutItem ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gv3" runat="server" ClientInstanceName="gv3" AutoGenerateColumns="true" BatchEditStartEditing="OnStartEditing">
                                                            <SettingsEditing Mode="Batch" />
                                                            <SettingsPager Mode="ShowAllRecords" />
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                            <dx:LayoutItem ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gv4" runat="server" ClientInstanceName="gv4" AutoGenerateColumns="true" BatchEditStartEditing="OnStartEditing">
                                                            <SettingsEditing Mode="Batch" />
                                                            <SettingsPager Mode="ShowAllRecords" />
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



                            <dx:LayoutGroup Caption="Amount" ColCount="2" ClientVisible="false">
                                <Items>
                                    <dx:LayoutItem Caption="Quantity">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">

                                                <dx:ASPxSpinEdit ID="speTotalQuantity" runat="server" Width="170px" OnLoad="SpinEdit_Load" ClientInstanceName="txttotalqty" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00" DisplayFormatString="{0:N}" AllowMouseWheel="false">
                                                    <ClientSideEvents Validation="OnQtyValidate" ValueChanged="autocalculate" />
                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                        <RequiredField IsRequired="True" />
                                                    </ValidationSettings>
                                                    <InvalidStyle BackColor="Pink">
                                                    </InvalidStyle>
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Work Order Price">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speWOP" runat="server" Width="170px" DisplayFormatString="{0:N}" ClientInstanceName="txtWOP" OnLoad="SpinEdit_Load" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption=" Original Work Order Price">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speOrigWOP" runat="server" Width="170px" ReadOnly="True" ClientInstanceName="speWOP" DisplayFormatString="{0:N}" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    
                                    <dx:LayoutItem Caption="VAT Code">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtVatCode" runat="server" Width="170px" ReadOnly="True" ClientInstanceName="txtVatCode">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>

                                    <dx:LayoutItem Caption="Currency ">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">


                                                <dx:ASPxTextBox ID="txtCurrency" runat="server" ReadOnly="True" Width="170px">
                                                </dx:ASPxTextBox>


                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>

                                    <dx:LayoutItem Caption="Exchange Rate" ColSpan="2">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speExchangeRate" runat="server" Width="170px" ClientInstanceName="txtexchangerate" OnLoad="SpinEdit_Load" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>

                                    <dx:LayoutItem Caption="Peso Amount" ColSpan="2">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="spePesoAmount" runat="server" Width="170px" ClientInstanceName="txtTotalAmount" DisplayFormatString="{0:N}" ReadOnly="true" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Foreign Amount">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speForeignAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtForeignAmount" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>

                                    <dx:LayoutItem Caption="Non Vatable Amount">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speNonVatableAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtnonvat" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Gross Vatable Amount" ColSpan="2">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speGrossVatableAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtGrossVATableAmount" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                    <ClientSideEvents Validation="function (s,e)
                                                                {
                                                                 OnValidation = true;
                                                                }" />
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Vat Amount">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speVatAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtVatAmount1" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Withholding Tax">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speWithHoldingTax" runat="server" DisplayFormatString="{0:N}" ClientInstanceName="txtWithHoldingTax" ReadOnly="True" Width="170px" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speVatRate" runat="server" Width="170px" DisplayFormatString="{0:N}" ReadOnly="True" ClientVisible="false" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999" AllowMouseWheel="False" SpinButtons-ShowIncrementButtons="false" DecimalPlaces="2" ClientInstanceName="txtVatRate">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speAtc" runat="server" ClientInstanceName="txtAtc" ClientVisible="false" ReadOnly="True" Width="170px">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                            <dx:EmptyLayoutItem></dx:EmptyLayoutItem>
                            <dx:EmptyLayoutItem></dx:EmptyLayoutItem>
                            <dx:EmptyLayoutItem></dx:EmptyLayoutItem>


                            <dx:LayoutGroup GroupBoxDecoration="None" ClientVisible="false">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gvTemp" runat="server" AutoGenerateColumns="False" Width="608px" ClientInstanceName="gvTemp" Settings-ShowColumnHeaders="false" setting>
                                                    <ClientSideEvents Init="OnInitTrans" />
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                        </Items>
                    </dx:ASPxFormLayout>
                    <dx:ASPxPanel ID="BottomPanel" runat="server" FixedPosition="WindowBottom" BackColor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                    <dx:ASPxCheckBox Style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
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
                                        <td>
                                            <dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                                                <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                            </dx:ASPxButton>
                                            <td>
                                                <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                                                    <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                                </dx:ASPxButton>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </form>
    <!--#region Region Datasource-->


    <asp:SqlDataSource ID="MasterfileClass" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT  [ClassCode],[ItemCode], [ColorCode] ,[SizeCode] FROM Masterfile.[ItemDetail] where isnull(IsInactive,0)=0"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsJobOrder" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="

SELECT A.DocNumber,StepCode,WorkCenter,WorkOrderPrice FROM (
SELECT DISTINCT A.DocNumber,MAX(Sequence) as Sequence FROM Production.JobOrder A 
INNER JOIN Production.JOStepPlanning B ON A.DocNumber = B.DocNumber
 WHERE  ISNULL(ProdSubmittedBy,'')!='' and Status  IN ('N','W')
 and  ISNULL(ProdSubmittedDate,'')!='' and ISNULL(PreProd,0)=0 
 group by A.DocNumber) as A
 INNER JOIN Production.JOStepPlanning B 
 ON A.DocNumber = B.DocNumber
 and A.Sequence != B.Sequence
 where   ISNULL(PreProd,0)=0 "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsAdjustmentClassification" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="
select AdjustmentCode,Description from MasterFile.WIPAdjustmentType where ISNULL(IsInactive,0)=0 "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT SKUCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.InitialDPR+JournalEntry">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.InitialDPR+RefTransaction">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:SqlDataSource ID="sdsShift" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="select ShiftCode,ShiftName from masterfile.Shift  "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.InitialDPR+InitialDPRDetail" SelectMethod="getdetail" UpdateMethod="UpdateInitialDPRDetail" TypeName="Entity.InitialDPR+InitialDPRDetail" DeleteMethod="DeleteInitialDPRDetail" InsertMethod="AddInitialDPRDetail">
              <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsDetail2" runat="server" DataObjectTypeName="Entity.InitialDPR+InitialDPRDetail2" SelectMethod="getDetail2" UpdateMethod="UpdateInitialDPRDetail2" TypeName="Entity.InitialDPR+InitialDPRDetail2" DeleteMethod="DeleteInitialDPRDetail2" InsertMethod="AddInitialDPRDetail2">
              <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Production.InitialDPRDetail where DocNumber is null"   OnInit = "Connection_Init">
    </asp:SqlDataSource>

     <asp:SqlDataSource ID="sdsDetail2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Production.InitialDPRDetail2 where DocNumber is null"   OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsStep" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="
        SELECT StepCode
        FROM Masterfile.Step
  "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsSite" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="

        SELECT ProductClassCode as Code,Description 
        FROM Masterfile.ProductClass
  
        "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsBatch" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand= " "
        
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsSKUCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand= " "
        
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsCookingStage" runat="server" 
        SelectCommand="SELECT DISTINCT StepCode FROM Production.ProdRoutingStepPack"
        OnInit="Connection_Init"></asp:SqlDataSource>

      <%-- BOM DataSource --%>
        <asp:SqlDataSource ID="sdsBOM" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init" 
            SelectCommand=""
             DeleteCommand="DELETE Production.InitialDPRDetailMaterial WHERE RecordID=@DRecordID">
         
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>
     <asp:SqlDataSource ID="sdsSKU1" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select ItemCode as SKUCode, FullDesc AS Description,AVG(ISNULL(txtPerStrndFrom,0) + ISNULL(txtPerStrndTo,0)) /2.0 AS CasingSTD  from Masterfile.Item where Itemcategorycode = '008' group by ItemCode,FullDesc" OnInit="Connection_Init"></asp:SqlDataSource>
   
    <asp:SqlDataSource ID="sdsSKU2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select ItemCode as SKUCode, FullDesc AS Description,AVG(ISNULL(txtPerStrndFrom,0) + ISNULL(txtPerStrndTo,0)) /2.0 AS PlasticPackagingSTD from Masterfile.Item where Itemcategorycode = '009' group by ItemCode,FullDesc" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSKU3" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select ItemCode as SKUCode, FullDesc AS Description,AVG(ISNULL(txtPerStrndFrom,0) + ISNULL(txtPerStrndTo,0)) /2.0 AS CartonACT from Masterfile.Item where Itemcategorycode = '010' group by ItemCode,FullDesc" OnInit="Connection_Init"></asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


