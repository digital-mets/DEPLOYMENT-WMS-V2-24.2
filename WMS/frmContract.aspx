<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmContract.aspx.cs" Inherits="GWL.frmContract" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Contract</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 710px; /*Change this whenever needed*/
        }

        .Entry {
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
        }

        /*.dxeButtonEditSys input,
        .dxeTextBoxSys input{
            text-transform:uppercase;
        }*/

        .pnl-content {
            text-align: right;
        }
    </style>
    <!--#endregion-->

    <!--#region Region Javascript-->
    <script>
        var isValid = true;
        var counterror = 0;
        var gridcounterror = 0;
        var gridcounterror2 = 0;

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
                isValid = false;
            }
            else {
                isValid = true;
            }
        }

        function OnInitTrans(s, e) {
            var BizPartnerCode = aglBizPartnerCode.GetText();
            factbox.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
            AdjustSize();
        }

        function OnControlsInitialized(s, e) {
            ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                AdjustSize();
            });
        }

        function AdjustSize() {
            var width = Math.max(0, document.documentElement.clientWidth);
            gv1.SetWidth(width - 120);
            gv2.SetWidth(width - 120);
            //gvJournal.SetWidth(width - 120);
        }

        //function Validate() {
        //    if (document.getElementById("txtStatus") == "NEW") {
        //        document.getElementById("aglContractNumber").disabled = true;
        //    }
        //    else
        //        document.getElementById("aglContractNumber").disabled = false;

        //}

        function OnUpdateClick(s, e) {
            console.log('UPDATECLICK')

            var btnmode = btn.GetText();

            const validationMessages = ValidateNonStorageDetail();

            if (validationMessages.length > 0) {
                alert(validationMessages.join("\n"));
                return;
            }

            if (isValid && counterror < 1 && gridcounterror < 1 || btnmode == "Close") {

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
                isValid = true;
                counterror = 0;
                gridcounterror = 0;
                gridcounterror2 = 0;
                alert('Please check all the fields!');
            }

            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }
        }

        function OnConfirm(s, e) {
            //console.log(e.requestTriggerID);
            if (e.requestTriggerID === undefined || e.requestTriggerID === "ASPxFormLayout1_ASPxFormLayout2_gv1" || e.requestTriggerID === "ASPxFormLayout1_cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            if (s.cp_success) {
                gv1.CancelEdit();

                if (s.cp_forceclose) {
                    alert(s.cp_message);
                    delete (s.cp_success);
                    delete (s.cp_message);
                    delete (s.cp_forceclose);
                    window.close();
                }
                else {
                    alert(s.cp_message);
                    if (s.cp_valmsg !== undefined) alert(s.cp_valmsg);
                    delete (s.cp_valmsg);
                    delete (s.cp_success);
                    delete (s.cp_message);
                }
            }

            if (s.cp_close) {
                gv1.CancelEdit();
                if (s.cp_message != null) {
                    alert(s.cp_message);
                    delete (s.cp_message);
                }
                if (s.cp_valmsg != null) {
                    alert(s.cp_valmsg);
                    delete (s.cp_valmsg);
                }
                if (glcheck.GetChecked()) {
                    delete (cp_close);
                    window.location.reload();
                }
                else {
                    delete (cp_close);
                    window.close();
                }
            }

            if (s.cp_delete) {
                delete (s.cp_delete);
                DeleteControl.Show();
            }

            if (s.cp_bizpartner) {
                delete (s.cp_bizpartner);
                // UpdateDetail();
            }

            if (s.cp_generatedstorage) {
                // Storage
                delete (s.cp_generatedstorage);

                gv1.CancelEdit();
                var _indices = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < _indices.length; i++) {
                    gv1.DeleteRow(_indices[i]);
                }

                //gv1.AddNewRow();

                var _refindices = gvRefC.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < _refindices.length; i++) {
                    gv1.AddNewRow();
                    _indices = gv1.batchEditApi.GetRowVisibleIndices();


                    gv1.batchEditApi.SetCellValue(_indices[0], 'DocNumber', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'DocNumber'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'LineNumber', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'LineNumber'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'ServiceType', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'ServiceType'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'Description', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Description'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'ServiceRate', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'ServiceRate'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'UnitOfMeasure', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'UnitOfMeasure'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'UnitOfMeasureBulk', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'UnitOfMeasureBulk'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'Vatable', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Vatable'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'BillingType', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'BillingType'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'Period', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Period'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'Remarks', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Remarks'));

                    gv1.batchEditApi.SetCellValue(_indices[0], 'IsMulStorage', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'IsMulStorage'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'StorageCode', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'StorageCode'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'IsDiffCustomer', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'IsDiffCustomer'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'DiffCustomerCode', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'DiffCustomerCode'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'HandlingInRate', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'HandlingInRate'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'HandlingOutRate', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'HandlingOutRate'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'MinHandlingIn', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'MinHandlingIn'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'MinHandlingOut', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'MinHandlingOut'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'MinStorage', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'MinStorage'));

                    gv1.batchEditApi.SetCellValue(_indices[0], 'Field1', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Field1'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'Field2', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Field2'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'Field3', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Field3'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'Field4', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Field4'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'Field5', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Field5'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'Field6', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Field6'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'Field7', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Field7'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'Field8', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Field8'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'Field9', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Field9'));

                    gv1.batchEditApi.SetCellValue(_indices[0], 'Type', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Type'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'VATCode', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'VATCode'));



                    gv1.batchEditApi.SetCellValue(_indices[0], 'ExcessRate', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'ExcessRate'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'BeginDay', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'BeginDay'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'Staging', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Staging'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'AllocChargeable', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'AllocChargeable'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'SplitBill', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'SplitBill'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'ServiceHandling', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'ServiceHandling'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'HandlingUOMQty', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'HandlingUOMQty'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'HandlingUOMBulk', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'HandlingUOMBulk'));
                    //gv1.batchEditApi.SetCellValue(_indices[0], 'BillingPrintOutStr', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'BillingPrintOutStr'));

                    gv1.batchEditApi.SetCellValue(_indices[0], 'BillingPrintOutStr', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'BillingPrintOutStr'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'BillingPrintOutHan', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'BillingPrintOutHan'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'ConvFactorStr', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'ConvFactorStr'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'ConvFactorHan', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'ConvFactorHan'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'SplitBillRate', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'SplitBillRate'));

                    gv1.batchEditApi.SetCellValue(_indices[0], 'HandlingUOM', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'HandlingUOM'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'HandlingOutUOM', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'HandlingOutUOM'));





                }
                gv1.batchEditApi.EndEdit();
                //gv1.DeleteRow(-1);     // First added dummy record
                //delete (s.cp_generatedstorage);

                // Non-Storage

                delete (s.cp_generated);

                gv2.CancelEdit();
                var _indices = gv2.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < _indices.length; i++) {
                    gv2.DeleteRow(_indices[i]);
                }

                //gv2.AddNewRow();
                var _refindices = gvRefCN.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < _refindices.length; i++) {


                    gv2.AddNewRow();
                    _indices = gv2.batchEditApi.GetRowVisibleIndices();


                    gv2.batchEditApi.SetCellValue(_indices[0], 'DocNumber', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'DocNumber'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'LineNumber', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'LineNumber'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'ServiceType', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'ServiceType'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'Description', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'Description'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'ServiceRate', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'ServiceRate'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'UnitOfMeasure', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'UnitOfMeasure'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'UnitOfMeasureBulk', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'UnitOfMeasureBulk'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'Vatable', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'Vatable'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'BillingType', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'BillingType'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'Period', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'Period'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'Remarks', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'Remarks'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'Type', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'Type'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'VATCode', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'VATCode'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'AllocC', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'AllocC'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'TruckT', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'TruckT'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'TransT', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'TransT'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'Min', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'Min'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'Max', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'Max'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'GMV', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'GMV'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'Days', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'Days'));


                }
                gv2.batchEditApi.EndEdit();
                //gv2.DeleteRow(-1);     // First added dummy record
                //delete (s.cp_generated);
            }

            if (s.cp_generated) {
                delete (s.cp_generated);

                gv2.CancelEdit();
                var _indices = gv2.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < _indices.length; i++) {
                    gv2.DeleteRow(_indices[i]);
                }

                //gv2.AddNewRow();
                var _refindices = gvRefCN.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < _refindices.length; i++) {


                    gv2.AddNewRow();
                    _indices = gv2.batchEditApi.GetRowVisibleIndices();


                    gv2.batchEditApi.SetCellValue(_indices[0], 'DocNumber', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'DocNumber'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'LineNumber', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'LineNumber'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'ServiceType', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'ServiceType'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'Description', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'Description'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'ServiceRate', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'ServiceRate'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'UnitOfMeasure', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'UnitOfMeasure'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'UnitOfMeasureBulk', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'UnitOfMeasureBulk'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'Vatable', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'Vatable'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'BillingType', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'BillingType'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'Period', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'Period'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'Remarks', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'Remarks'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'Type', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'Type'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'VATCode', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'VATCode'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'AllocC', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'AllocC'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'TruckT', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'TruckT'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'TransT', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'TransT'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'Min', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'Min'));
                    gv2.batchEditApi.SetCellValue(_indices[0], 'Max', gvRefCN.batchEditApi.GetCellValue(_refindices[i], 'Max'));


                }
                gv2.batchEditApi.EndEdit();
                //gv2.DeleteRow(-1);     // First added dummy record
                //delete (s.cp_generated);
            }
        }

        function gv1_EndCallBack(s, e) {

            if (s.cp_success) {
                gv1.CancelEdit();

                if (s.cp_forceclose) {
                    alert(s.cp_message);
                    delete (s.cp_success);
                    delete (s.cp_message);
                    delete (s.cp_forceclose);
                    window.close();
                }
                else {
                    alert(s.cp_message);
                    alert(s.cp_valmsg);
                    delete (s.cp_valmsg);
                    delete (s.cp_success);
                    delete (s.cp_message);
                }
            }

            if (s.cp_close) {

                if (s.cp_valmsg != null) {
                    alert(s.cp_valmsg);
                    delete (s.cp_valmsg);
                }
                if (s.cp_message != null) {
                    alert(s.cp_message);
                    delete (s.cp_message);
                }
                if (glcheck.GetChecked()) {
                    delete (cp_close);
                    window.location.reload();
                }
                else {
                    delete (cp_close);
                    window.close();
                }
            }

            if (s.cp_delete) {
                delete (s.cp_delete);
                DeleteControl.Show();
            }

            if (s.cp_cascade) {
                delete (s.cp_delete);
                gv1.PerformCallback("CallbackContractCascade2");
            }


        }

        var index;
        var index2;
        var closing;
        var valchange2;
        var valchange3;
        var servhan;
        var val;
        var temp;
        var itemc;
        var itemServ;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var linebilltype;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ServiceType");
            //linebilltype = s.batchEditApi.GetCellValue(e.visibleIndex, "BillingType");
            index = e.visibleIndex;

            var entry = getParameterByName('entry');

            if (entry == "V" || entry == "D" || txtType.GetText() == "TERMINATION") {
                e.cancel = true;
            }
            else {

                if (s.batchEditApi.GetCellValue(e.visibleIndex, "SplitBill") != true) {
                    if (e.focusedColumn.fieldName === "ServiceHandling" || e.focusedColumn.fieldName === "SplitBillRate" ||
                        e.focusedColumn.fieldName === "HandlingUOMQty" || e.focusedColumn.fieldName === "BillingPrintOutHan") {
                        e.cancel = true;
                    }
                    else {
                        e.cancel = false;
                    }
                }

                if (e.focusedColumn.fieldName === "ServiceType") { //Check the column name
                    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "ServiceRate") {
                    //if (s.batchEditApi.GetCellValue(e.visibleIndex, "BillingType") == "EXCESS QTY") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "BillingType") == "EXCESS QTYND" || s.batchEditApi.GetCellValue(e.visibleIndex, "BillingType") == "EXCESS QTYSD") {
                        e.cancel = true;
                    }
                    else {
                        e.cancel = false;
                    }
                }
                if (e.focusedColumn.fieldName === "ExcessRate") {
                    //if (s.batchEditApi.GetCellValue(e.visibleIndex, "BillingType") !== "EXCESS QTY") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "BillingType") != "EXCESS QTYND" && s.batchEditApi.GetCellValue(e.visibleIndex, "BillingType") != "EXCESS QTYSD") {
                        e.cancel = true;
                    }
                    else {
                        e.cancel = false;
                    }
                }
                if (e.focusedColumn.fieldName === "UnitOfMeasure") {
                    gl2.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "UnitOfMeasureBulk") {
                    gUnitOfMeasureBulk.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                }

                if (e.focusedColumn.fieldName === "BillingType") {
                    gl3.GetInputElement().value = cellInfo.value;
                }

                if (e.focusedColumn.fieldName === "Period") {
                    glPeriod.GetInputElement().value = cellInfo.value;
                }

                if (e.focusedColumn.fieldName === "VATCode") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "Vatable") == false || s.batchEditApi.GetCellValue(e.visibleIndex, "Vatable") != true) {
                        e.cancel = true;
                    }
                    else {
                        gVATCode.GetInputElement().value = cellInfo.value;
                        isSetTextRequired = true;
                    }
                }

                if (e.focusedColumn.fieldName === "IsMulStorage") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsDiffCustomer") == false || s.batchEditApi.GetCellValue(e.visibleIndex, "IsDiffCustomer") != true) {
                        e.cancel = false;
                    }
                    else {
                        e.cancel = true;
                    }
                }

                if (e.focusedColumn.fieldName === "StorageCode") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsMulStorage") == false || s.batchEditApi.GetCellValue(e.visibleIndex, "IsMulStorage") != true) {
                        e.cancel = true;
                    }
                    else {
                        gStorageCode.GetInputElement().value = cellInfo.value;
                        isSetTextRequired = true;
                    }
                }

                if (e.focusedColumn.fieldName === "IsDiffCustomer") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsMulStorage") == false || s.batchEditApi.GetCellValue(e.visibleIndex, "IsMulStorage") != true) {
                        e.cancel = false;
                    }
                    else {
                        e.cancel = true;
                    }
                }

                if (e.focusedColumn.fieldName === "DiffCustomerCode") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsDiffCustomer") == false || s.batchEditApi.GetCellValue(e.visibleIndex, "IsDiffCustomer") != true) {
                        e.cancel = true;
                    }
                    else {
                        gDiffCustomerCode.GetInputElement().value = cellInfo.value;
                        isSetTextRequired = true;
                    }
                }

                //if (e.focusedColumn.fieldName === "BeginDay") {
                //    if (s.batchEditApi.GetCellValue(e.visibleIndex, "BillingType") !== "MAG EXDAYS") {
                //        e.cancel = true;
                //    }
                //    else {
                //        e.cancel = false;
                //    }
                //}

                if (e.focusedColumn.fieldName === "Staging") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "BillingType") != "EXCESS QTYSD") {
                        e.cancel = true;
                    }
                    else {
                        e.cancel = false;
                    }
                }

                if (e.focusedColumn.fieldName === "AllocChargeable") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "BillingType") !== "EXCESS QTYSD") {
                        e.cancel = true;
                    }
                    else {
                        e.cancel = false;
                    }
                }

                if (e.focusedColumn.fieldName === "ServiceHandling") {
                    gServiceHandling.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "HandlingUOMQty") {
                    gHandlingUOMQty.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "HandlingUOMBulk") {
                    gHandlingUOMBulk.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "HandlingUOM") {
                    gHandlingUOM.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "HandlingOutUOM") {
                    gHandlingUOM.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "BillingPrintOutStr") {
                    gBillingPrintOutStr.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "BillingPrintOutHan") {
                    gBillingPrintOutHan.GetInputElement().value = cellInfo.value;
                }

            }
        }

        function gv2_OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemServ = s.batchEditApi.GetCellValue(e.visibleIndex, "ServiceType");
            index1 = e.visibleIndex;

            var entry = getParameterByName('entry');

            if (entry == "V" || entry == "D" || txtType.GetText() == "TERMINATION") {
                e.cancel = true;
            }
            else {

                if (e.focusedColumn.fieldName === "ServiceType") { //Check the column name
                    aServiceType.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "UnitOfMeasure") {
                    aUnitOfMeasure.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "UnitOfMeasureBulk") {
                    aUnitOfMeasureBulk.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "BillingType") {
                    aBillingType.GetInputElement().value = cellInfo.value;
                }

                if (e.focusedColumn.fieldName === "Period") {
                    aPeriod.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "TransT") {
                    atxtTrans.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "TruckT") {
                    atxtTruckType.GetInputElement().value = cellInfo.value;
                }

                if (e.focusedColumn.fieldName === "VATCode") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "Vatable") == false || s.batchEditApi.GetCellValue(e.visibleIndex, "Vatable") != true) {
                        e.cancel = true;
                    }
                    else {
                        aVATCode.GetInputElement().value = cellInfo.value;
                        isSetTextRequired = true;
                    }
                }
            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            if (currentColumn.fieldName === "ServiceType") {
                cellInfo.value = gl.GetValue();
                cellInfo.text = gl.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "UnitOfMeasure") {
                cellInfo.value = gl2.GetValue();
                cellInfo.text = gl2.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "UnitOfMeasureBulk") {
                cellInfo.value = gUnitOfMeasureBulk.GetValue();
                cellInfo.text = gUnitOfMeasureBulk.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "BillingType") {
                cellInfo.value = gl3.GetValue();
                cellInfo.text = gl3.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "Period") {
                cellInfo.value = glPeriod.GetValue();
                cellInfo.text = glPeriod.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "StorageCode") {
                cellInfo.value = gStorageCode.GetValue();
                cellInfo.text = gStorageCode.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "DiffCustomerCode") {
                // 7/29/2024 JCB Updated handling of DiffCustomerCode Column to get text instead of value
                //cellInfo.value = gDiffCustomerCode.GetValue();
                cellInfo.value = gDiffCustomerCode.GetText().toUpperCase();
                cellInfo.text = gDiffCustomerCode.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "ServiceHandling") {
                cellInfo.value = gServiceHandling.GetValue();
                cellInfo.text = gServiceHandling.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "HandlingUOMQty") {
                cellInfo.value = gHandlingUOMQty.GetValue();
                cellInfo.text = gHandlingUOMQty.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "HandlingUOMBulk") {
                cellInfo.value = gHandlingUOMBulk.GetValue();
                cellInfo.text = gHandlingUOMBulk.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "BillingPrintOutStr") {
                cellInfo.value = gBillingPrintOutStr.GetValue();
                cellInfo.text = gBillingPrintOutStr.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "BillingPrintOutHan") {
                cellInfo.value = gBillingPrintOutHan.GetValue();
                cellInfo.text = gBillingPrintOutHan.GetText().toUpperCase();
            }
        }

        function gv2_OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            if (currentColumn.fieldName === "ServiceType") {
                cellInfo.value = aServiceType.GetValue();
                cellInfo.text = aServiceType.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "UnitOfMeasure") {
                cellInfo.value = aUnitOfMeasure.GetValue();
                cellInfo.text = aUnitOfMeasure.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "UnitOfMeasureBulk") {
                cellInfo.value = aUnitOfMeasureBulk.GetValue();
                cellInfo.text = aUnitOfMeasureBulk.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "BillingType") {
                cellInfo.value = aBillingType.GetValue();
                cellInfo.text = aBillingType.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "Period") {
                cellInfo.value = aPeriod.GetValue();
                cellInfo.text = aPeriod.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "VATCode") {
                cellInfo.value = aVATCode.GetValue();
                cellInfo.text = aVATCode.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "TruckT") {
                cellInfo.value = atxtTruckType.GetValue();
                cellInfo.text = atxtTruckType.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "TransT") {
                cellInfo.value = atxtTrans.GetValue();
                cellInfo.text = atxtTrans.GetText().toUpperCase();
            }
        }

        function GridEnd(s, e) {

            val = s.GetGridView().cp_codes;
            if (val == null || val == "") {
                val = ";;;;";
            }
            temp = val.split(';');

            if (closing == true) {

            }

            console.log('endcb');

            if (valchange2) {
                valchange2 = false;
                closing = false;
                for (var i = 0; i < gv1.GetColumnsCount(); i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells3(0, e, column, s);
                }

            }

            if (valchange3) {
                valchange3 = false;
                closing = false;
                for (var i = 0; i < gv2.GetColumnsCount(); i++) {
                    var column = gv2.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells_gv2(0, e, column, s);
                }
                gv2.batchEditApi.EndEdit();
            }

            if (servhan) {
                servhan = false;
                closing = false;
                for (var i = 0; i < gv1.GetColumnsCount(); i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells_servhan(0, e, column, s);
                }
                gv1.batchEditApi.EndEdit();
            }


            gv1.batchEditApi.EndEdit();
        }

        function ProcessCells3(selectedIndex, e, column, s) {//Auto Color,class,size,full desc, qty function :D
            if (val == null) {
                val = ";;;;";
                temp = val.split(';');
            }
            console.log(val);
            if (temp[0] == null || temp[0] == "") {
                temp[0] = "";
            }
            if (temp[1] == null || temp[1] == "") {
                temp[1] = 0;
            }

            if (selectedIndex == 0) {
                if (column.fieldName == "Description") {
                    gv1.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                }
                if (column.fieldName == "ServiceRate") {
                    gv1.batchEditApi.SetCellValue(index, column.fieldName, temp[1]);
                    console.log('val');
                }
                if (column.fieldName == "Type") {
                    gv1.batchEditApi.SetCellValue(index, column.fieldName, temp[2]);
                }
                if (column.fieldName == "StorageCode") {
                    gv1.batchEditApi.SetCellValue(index, column.fieldName, temp[3]);
                }
                if (column.fieldName == "DiffCustomerCode") {
                    gv1.batchEditApi.SetCellValue(index, column.fieldName, aglBizPartnerCode.GetText());
                }
            }
        }

        function ProcessCells_gv2(selectedIndex, e, column, s) {//Auto Color,class,size,full desc, qty function :D
            if (val == null) {
                val = ";;;;";
                temp = val.split(';');
            }
            console.log(val);
            if (temp[0] == null || temp[0] == "") {
                temp[0] = "";
            }
            if (temp[1] == null || temp[1] == "") {
                temp[1] = 0;
            }
            if (temp[2] == null || temp[2] == "") {
                temp[2] = "";
            }

            if (selectedIndex == 0) {
                if (column.fieldName == "Description") {
                    gv2.batchEditApi.SetCellValue(index1, column.fieldName, temp[0]);
                }
                if (column.fieldName == "ServiceRate") {
                    gv2.batchEditApi.SetCellValue(index1, column.fieldName, temp[1]);
                    console.log('val');
                }
                if (column.fieldName == "Type") {
                    gv2.batchEditApi.SetCellValue(index1, column.fieldName, temp[2]);
                }

            }
        }

        function ProcessCells_servhan(selectedIndex, e, column, s) {
            if (val == null) {
                val = ";;;";
                temp = val.split(';');
            }

            if (temp[0] == null || temp[0] == "") {
                temp[0] = "";
            }

            if (selectedIndex == 0) {
                if (column.fieldName == "SplitBillRate") {
                    gv1.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                }
            }
        }

        function lookup(s, e) {
            if (isSetTextRequired) {//Sets the text during lookup for item code
                s.SetText(s.GetInputElement().value);
                isSetTextRequired = false;
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

        function gridLookup_KeyDown2(s, e) { //Allows tabbing between gridlookup on details
            isSetTextRequired = false;
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode !== ASPxKey.Tab) return;
            var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
            if (gv2.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            }
        }

        function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode == ASPxKey.Enter)
                gv1.batchEditApi.EndEdit();
            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_KeyPress2(s, e) { //Prevents grid refresh when a user press enter key for every column
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode == ASPxKey.Enter)
                gv2.batchEditApi.EndEdit();
            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            gv1.batchEditApi.EndEdit();
        }

        function gridLookup_CloseUp2(s, e) { //Automatically leaves the current cell if an item is selected.
            gv2.batchEditApi.EndEdit();
        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {
            console.log('BATCH')
            for (var i = 0; i < gv1.GetColumnsCount(); i++) {
                var column = s.GetColumn(i);
                var billtype;
                var isVatable;
                var isSplit;
                var isMulStorage;
                var isDiffCustomer;

                if (column.fieldName == "BillingType") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    billtype = cellValidationInfo.value;
                }
                var cntServiceRate = 0;
                if (column.fieldName == "ServiceRate") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || value == "" || value == "0" || value == "0.00" || value == "0.0000" || value == null) && (billtype == "SAME DAY" || billtype == "NEXT DAY" || billtype == "MAG EXDAYS") && (billtype != "undefined" && billtype != undefined)) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "Service rate is required!";
                        isValid = false;
                        cntServiceRate++;
                    }
                    else {
                        isValid = true;
                        cntServiceRate--;
                    }
                }

                var cntExcessRate = 0;
                if (column.fieldName == "ExcessRate") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || value == "" || value == "0" || value == "0.00" || value == "0.0000" || value == null) && (billtype != "SAME DAY" && billtype != "NEXT DAY" && billtype != "MAG HANDLING" && billtype != "MAG EXDAYS" && billtype != "undefined" && billtype != undefined)) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "Excess Storage Rate is required!";
                        isValid = false;
                        cntExcessRate++;
                    }
                    else {
                        isValid = true;
                        cntExcessRate--;
                    }
                }

                var cntUnitOfMeasure = 0;
                if (column.fieldName == "UnitOfMeasure") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == null)) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "Unit of measure is required!";
                        isValid = false;
                        cntUnitOfMeasure++;
                    }
                    else {
                        isValid = true;
                        cntUnitOfMeasure--;
                    }
                }

                if (column.fieldName == "Vatable") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (value == true) {
                        isVatable = true;
                    }
                }

                var cntVATCode = 0;
                if (column.fieldName == "VATCode") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == "NONV") && isVatable == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "VAT Code is required!";
                        isValid = false;
                        cntVATCode++;
                    }
                    else {
                        isValid = true;
                        cntVATCode--;
                    }
                }

                if (column.fieldName == "IsMulStorage") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (value == true) {
                        isMulStorage = true;
                    }
                }

                var cntStorageCode = 0;
                if (column.fieldName == "StorageCode") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == null) && isMulStorage == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "Storage Code is required!";
                        isValid = false;
                        cntStorageCode++;
                    }
                    else {
                        isValid = true;
                        cntStorageCode--;
                    }
                }

                if (column.fieldName == "IsDiffCustomer") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (value == true) {
                        isDiffCustomer = true;
                    }
                }

                var cntDiffCustomerCode = 0;
                if (column.fieldName == "DiffCustomerCode") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == null) && isDiffCustomer == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "Customer Code is required!";
                        isValid = false;
                        cntDiffCustomerCode++;
                    }
                    else {
                        isValid = true;
                        cntDiffCustomerCode--;
                    }
                }

                var cntHandlingOutRate = 0;
                if (column.fieldName == "HandlingOutRate") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || value == "" || value == "0" || value == "0.00" || value == "0.0000" || value == null) && (billtype == "MAG HANDLING")) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "Handling Out Rate is required!";
                        isValid = false;
                        cntHandlingOutRate++;
                    }
                    else {
                        isValid = true;
                        cntHandlingOutRate--;
                    }
                }

                if (column.fieldName == "SplitBill") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (value == true) {
                        isSplit = true;
                    }
                }

                var cntServiceHandling = 0;
                if (column.fieldName == "ServiceHandling") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == null) && isSplit == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "Service code for split billing is required!";
                        isValid = false;
                        cntServiceHandling++;
                    }
                    else {
                        isValid = true;
                        cntServiceHandling--;
                    }
                }

                var cntSplitBillRate = 0;
                if (column.fieldName == "SplitBillRate") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || value == "" || value == "0" || value == "0.00" || value == null) && isSplit == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "Split Bill Rate is required!";
                        isValid = false;
                        cntSplitBillRate++;
                    }
                    else {
                        isValid = true;
                        cntSplitBillRate--;
                    }
                }

                var cntHandlingUOMQty = 0;
                if (column.fieldName == "HandlingUOMQty") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == null) && isSplit == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "Split Billing UOM is required!";
                        isValid = false;
                        cntHandlingUOMQty++;
                    }
                    else {
                        isValid = true;
                        cntHandlingUOMQty--;
                    }
                }

                gridcounterror = cntServiceRate + cntExcessRate + cntUnitOfMeasure + cntVATCode + cntStorageCode
                    + cntDiffCustomerCode + cntServiceHandling + cntSplitBillRate + cntHandlingUOMQty;
            }

        }


        function Grid_BatchEditRowValidating_2(s, e) {
            gridcounterror2 = 0;
            for (var i = 0; i < gv2.GetColumnsCount(); i++) {
                var column = s.GetColumn(i);
                var isVatable;

                if (column.fieldName == "ServiceType") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == null)) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "Service code is required!";
                        isValid = false;
                        gridcounterror2++;
                    }
                    else {
                        isValid = true;
                        //gridcounterror--;
                    }
                }

                if (column.fieldName == "ServiceRate") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || value == "" || value == "0" || value == "0.00" || value == null) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "Service rate is required!";
                        isValid = false;
                        gridcounterror2++;
                    }
                    else {
                        isValid = true;
                        //gridcounterror--;
                    }
                }

                if (column.fieldName == "UnitOfMeasure") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == null)) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "Unit of measure is required!";
                        isValid = false;
                        gridcounterror2++;
                    }
                    else {
                        isValid = true;
                        //gridcounterror--;
                    }
                }

                if (column.fieldName == "Vatable") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (value == true) {
                        isVatable = true;
                    }
                }

                if (column.fieldName == "VATCode") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == "NONV") && isVatable == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "VAT Code is required!";
                        isValid = false;
                        gridcounterror2++;
                    }
                    else {
                        isValid = true;
                        //gridcounterror--;
                    }
                }

                if (column.fieldName == "BillingType") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == null)) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "Billing type is required!";
                        isValid = false;
                        gridcounterror2++;
                    }
                    else {
                        isValid = true;
                        //gridcounterror--;
                    }
                }

            }

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

        function OnCompareDate(s, e) {

            var dfrom = Date.parse(dtpDateFrom.GetValue());
            var dto = Date.parse(dtpDateTo.GetValue());
            var dOP = Date.parse(dtpOpenPeriod.GetValue());
            var msg = "";

            if (dfrom > dto) {
                msg = "Period date range is incorrect!";
            }
            else if (dfrom < dOP) {
                msg = "Period Start is lesser than the open period!";
            }
            else if (dto < dOP) {
                msg = "Period End is lesser than the open period!";
            }

            if (msg != "") {
                counterror++;
                isValid = false;
                alert(msg);
            }
            else {
                isValid = true;
            }
        }

        function GetContract(s, e) {
            if (aglContractNumber.GetText() == null || aglContractNumber.GetText() == "") {
                alert("No reference contract was selected!");
            }
            else {
                cp.PerformCallback("CallbackContractCascade");
                //cp.PerformCallback("CallbackContractCascade2");
            }
        }

        function VatableChanged(s, e) {
            var vatValue = gv1.batchEditApi.GetCellValue(index, "Vatable");

            if (vatValue == true) {
                gv1.batchEditApi.SetCellValue(index, "VATCode", "VAT12");
            }
            else {
                gv1.batchEditApi.SetCellValue(index, "VATCode", "NONV");
            }
        }

        function VatableChanged2(s, e) {
            var vatValue1 = gv2.batchEditApi.GetCellValue(index1, "Vatable");

            if (vatValue1 == true) {
                gv2.batchEditApi.SetCellValue(index1, "VATCode", "VAT12");
            }
            else {
                gv2.batchEditApi.SetCellValue(index1, "VATCode", "NONV");
            }
        }

        function MulStorageChange(s, e) {
            var serviceValue = gv1.batchEditApi.GetCellValue(index, "ServiceType");

            gv1.batchEditApi.SetCellValue(index, "StorageCode", serviceValue);
        }

        function DiffCustomerChange(s, e) {
            gv1.batchEditApi.SetCellValue(index, "DiffCustomerCode", aglBizPartnerCode.GetText());
        }

        function SplitBillClearing(s, e) {
            var splitValue = gv1.batchEditApi.GetCellValue(index, "SplitBill");

            if (splitValue != true) {
                gv1.batchEditApi.SetCellValue(index, "ServiceHandling", "");
                gv1.batchEditApi.SetCellValue(index, "SplitBillRate", 0.0000);
                gv1.batchEditApi.SetCellValue(index, "HandlingUOMQty", "");
                gv1.batchEditApi.SetCellValue(index, "BillingPrintOutHan", "");
            }
            else {
                gv1.batchEditApi.SetCellValue(index, "BillingPrintOutHan", "REGULAR");
            }
        }

        function BillingTypeStorage(s, e) {
            var billtype = gv1.batchEditApi.GetCellValue(index, "BillingType");
            linebilltype = billtype;

            if (billtype == "EXCESS QTYND" || billtype == "EXCESS QTYSD" || billtype == "EXCESS QTY") {
                gv1.batchEditApi.SetCellValue(index, "ServiceRate", 0.0000);
            }
            else if (billtype != "MAG HANDLING" && billtype != "EXCESS QTYND" && billtype != "EXCESS QTYSD" && billtype != "EXCESS QTY") {
                gv1.batchEditApi.SetCellValue(index, "ExcessRate", 0.0000);
            }
            else if (billtype == "MAG HANDLING") {
                gv1.batchEditApi.SetCellValue(index, "ExcessRate", 0.0000);
                gv1.batchEditApi.SetCellValue(index, "ServiceRate", 0.0000);
            }
            else if (billtype != "EXCESS QTYSD") {
                gv1.batchEditApi.SetCellValue(index, "Staging", 0);
                gv1.batchEditApi.SetCellValue(index, "AllocChargeable", 0);
            }

            gv1.batchEditApi.SetCellValue(index, "BeginDay", 0);
        }

        function UpdateDetail(s, e) {
            LoadPanel.Show();

            setTimeout(function () {
                console.log(gv1.batchEditHelper);
                var iStorage = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < iStorage.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(iStorage[i])) {
                        var DiffCustomer = gv1.batchEditApi.GetCellValue(iStorage[i], "DiffCustomerCode");
                        var Storage = gv1.batchEditApi.GetCellValue(iStorage[i], "StorageCode");
                        var Service = gv1.batchEditApi.GetCellValue(iStorage[i], "ServiceType");

                        if (DiffCustomer == null || DiffCustomer == "") {
                            gv1.batchEditApi.SetCellValue(iStorage[i], "DiffCustomerCode", aglBizPartnerCode.GetText());
                        }

                        if (Storage == null || Storage == "") {
                            gv1.batchEditApi.SetCellValue(iStorage[i], "StorageCode", Service);
                        }
                    }
                    else {
                        var key = gv1.GetRowKey(iStorage[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) {

                        }
                        else {
                            var DiffCustomer = gv1.batchEditApi.GetCellValue(iStorage[i], "DiffCustomerCode");
                            var Storage = gv1.batchEditApi.GetCellValue(iStorage[i], "StorageCode");
                            var Service = gv1.batchEditApi.GetCellValue(iStorage[i], "ServiceType");

                            if (DiffCustomer == null || DiffCustomer == "") {
                                gv1.batchEditApi.SetCellValue(iStorage[i], "DiffCustomerCode", aglBizPartnerCode.GetText());
                            }

                            if (Storage == null || Storage == "") {
                                gv1.batchEditApi.SetCellValue(iStorage[i], "StorageCode", Service);
                            }
                        }
                    }
                }

                LoadPanel.Hide();
            }, 2000);

        }


        // SKUCode valuechanged event
        function UpdateStorage(values) {
            gv1.batchEditApi.SetCellValue(index, "ServiceType", values[0]);
            gv1.batchEditApi.SetCellValue(index, "Description", values[1]);
            gv1.batchEditApi.SetCellValue(index, "ServiceRate", values[3]);

            gv1.batchEditApi.EndEdit();
        }

        function UpdateUOM(values) {
            gv1.batchEditApi.SetCellValue(index, "UnitOfMeasure", values);

            gv1.batchEditApi.EndEdit();
        }

        function UpdateHandlingUOM(values) {
            gv1.batchEditApi.SetCellValue(index, "HandlingUOM", values);

            gv1.batchEditApi.EndEdit();
        }

        function UpdateHandlingOutUOM(values) {
            gv1.batchEditApi.SetCellValue(index, "HandlingOutUOM", values);

            gv1.batchEditApi.EndEdit();
        }



        // SKUCode valuechanged eventindex
        function UpdateNonStorage(values) {
            gv2.batchEditApi.SetCellValue(index1, "ServiceType", values[0]);
            gv2.batchEditApi.SetCellValue(index1, "Description", values[1]);
            gv2.batchEditApi.SetCellValue(index1, "ServiceRate", values[3]);

            gv2.batchEditApi.EndEdit();
        }

        function UpdateUOMNon(values) {
            gv2.batchEditApi.SetCellValue(index1, "UnitOfMeasure", values);

            gv2.batchEditApi.EndEdit();
        }

        function UpdateTruckType(values) {
            gv2.batchEditApi.SetCellValue(index1, "TruckType", values);

            gv2.batchEditApi.EndEdit();
        }

        function UpdateTransType(values) {
            gv2.batchEditApi.SetCellValue(index1, "TransType", values);

            gv2.batchEditApi.EndEdit();
        }

        function ValidateNonStorageDetail() {
            let errors = [];
            gv2.batchEditApi.GetRowVisibleIndices().forEach((rowIndex) => {
                const serviceTypeColValue = gv2.batchEditApi.GetCellValue(rowIndex, 'ServiceType');
                const serviceType = Array.isArray(serviceTypeColValue) ? serviceTypeColValue[0] : serviceTypeColValue;
                const allocChargeable = gv2.batchEditApi.GetCellValue(rowIndex, 'AllocC');
                const min = gv2.batchEditApi.GetCellValue(rowIndex, 'Min');
                const max = gv2.batchEditApi.GetCellValue(rowIndex, 'Max');

                if (serviceType.trim() !== '' && allocChargeable && ((min <= 0 && max <= 0) || (min > 0 && min > max) || (min < 0 || max < 0))) {
                    errors.push(`${serviceType} requires MIN and MAX value`);
                }
            });

            return errors;
        }
    </script>
    <!--#endregion-->
</head>
<body style="height: 980px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel ID="txtHeader" runat="server" Text="Contract" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None"
            EnableViewState="False" HeaderText="BizPartner Info" Height="270px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="50"
            ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" Height="600px" Width="1280px" Style="margin-left: -3px">
            <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
            <Items>
                <dx:LayoutItem Caption="">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer>
                            <dx:ASPxCallbackPanel ID="cp" runat="server" Width="1050px" Height="1px" ClientInstanceName="cp" OnCallback="cp_Callback">
                                <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
                                <PanelCollection>
                                    <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                        <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" Style="margin-left: -20px">
                                            <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                                            <Items>
                                                <dx:TabbedLayoutGroup>
                                                    <Items>
                                                        <dx:LayoutGroup Caption="Header" ColCount="2">
                                                            <Items>
                                                                <dx:LayoutItem Caption="Document Number">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px" AutoCompleteType="Disabled" Enabled="False" OnLoad="TextboxLoad" ReadOnly="True">
                                                                            </dx:ASPxTextBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Document Date">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnLoad="Date_Load" OnInit="dtpDocDate_Init" Width="170px">
                                                                                <ClientSideEvents Validation="OnValidation" />
                                                                                <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                    <RequiredField IsRequired="True" />
                                                                                </ValidationSettings>
                                                                                <InvalidStyle BackColor="Pink">
                                                                                </InvalidStyle>
                                                                            </dx:ASPxDateEdit>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Type">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxTextBox ID="txtType" runat="server" Width="170px" ClientSideEnabled="true" ClientInstanceName="txtType" ReadOnly="true">
                                                                            </dx:ASPxTextBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Warehouse Code">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxGridLookup ID="aglWarehouse" runat="server" DataSourceID="sdsWarehouse" OnLoad="LookupLoad"
                                                                                Width="170px" KeyFieldName="WarehouseCode" TextFormatString="{0}" AutoGenerateColumns="false">
                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                    <Settings ShowFilterRow="True"></Settings>
                                                                                </GridViewProperties>
                                                                                <Columns>
                                                                                    <dx:GridViewDataTextColumn FieldName="WarehouseCode" ReadOnly="true">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="true">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dx:GridViewDataTextColumn>
                                                                                </Columns>
                                                                            </dx:ASPxGridLookup>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Reference Contract">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <table>
                                                                                <tr>
                                                                                    <td>
                                                                                        <dx:ASPxGridLookup ID="aglContractNumber" runat="server" Width="170px" DataSourceID="sdsContract" OnLoad="LookupLoad_2"
                                                                                            KeyFieldName="DocNumber" TextFormatString="{0}" ClientInstanceName="aglContractNumber" AutoGenerateColumns="false" OnInit="aglContractNumber_Init">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                                <Settings ShowFilterRow="True"></Settings>
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" VisibleIndex="0">
                                                                                                    <Settings AllowAutoFilter="true" AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataDateColumn FieldName="DocDate" ShowInCustomizationForm="True" VisibleIndex="1" Width="100px" ReadOnly="true">
                                                                                                    <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible="false">
                                                                                                        <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                                                    </PropertiesDateEdit>
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataDateColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="ContractType" ReadOnly="True" VisibleIndex="2" Caption="Type">
                                                                                                    <Settings AllowAutoFilter="true" AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" VisibleIndex="3" Caption="Business Partner">
                                                                                                    <Settings AllowAutoFilter="true" AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataDateColumn FieldName="PeriodFrom" ShowInCustomizationForm="True" VisibleIndex="4" Width="100px" ReadOnly="true" Caption="Period From">
                                                                                                    <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible="false">
                                                                                                        <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                                                    </PropertiesDateEdit>
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataDateColumn>
                                                                                                <dx:GridViewDataDateColumn FieldName="PeriodTo" ShowInCustomizationForm="True" VisibleIndex="5" Width="100px" ReadOnly="true" Caption="Period To">
                                                                                                    <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible="false">
                                                                                                        <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                                                    </PropertiesDateEdit>
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataDateColumn>
                                                                                                <dx:GridViewDataDateColumn FieldName="EffectivityDate" ShowInCustomizationForm="True" VisibleIndex="6" Width="100px" ReadOnly="true" Caption="Effectivity Date">
                                                                                                    <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible="false">
                                                                                                        <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                                                    </PropertiesDateEdit>
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataDateColumn>
                                                                                                <%--<dx:GridViewDataTextColumn FieldName="BillingPeriodType" ReadOnly="True" VisibleIndex="7" Caption="Billing Period">
                                                                                                <Settings AllowAutoFilter="true" AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>--%>
                                                                                                <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" ReadOnly="True" VisibleIndex="7" Caption="Profit Center">
                                                                                                    <Settings AllowAutoFilter="true" AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="Status" ReadOnly="True" VisibleIndex="8">
                                                                                                    <Settings AllowAutoFilter="true" AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="WarehouseCode" ReadOnly="True" VisibleIndex="9" Caption="Warehouse">
                                                                                                    <Settings AllowAutoFilter="true" AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            </Columns>
                                                                                            <ClientSideEvents ValueChanged="function (s,e) { gv1.CancelEdit(); gv2.CancelEdit(); cp.PerformCallback('CallbackContractNum'); }" />
                                                                                        </dx:ASPxGridLookup>
                                                                                    </td>
                                                                                    <td>
                                                                                        <dx:ASPxLabel ID="lblSpace" runat="server" Text="" Width="5px">
                                                                                        </dx:ASPxLabel>
                                                                                    </td>
                                                                                    <td>
                                                                                        <dx:ASPxButton ID="btnGetContract" runat="server" AutoPostBack="False" Width="80px" Theme="MetropolisBlue" Text="Get Contract" OnLoad="ButtonLoad" Height="12">
                                                                                            <ClientSideEvents Click="GetContract" />
                                                                                        </dx:ASPxButton>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Period Start">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxDateEdit ID="dtpDateFrom" runat="server" OnLoad="Date_Load" OnInit="dtpDateFrom_Init" Width="170px" ClientInstanceName="dtpDateFrom">
                                                                                <ClientSideEvents Validation="OnValidation" ValueChanged="OnCompareDate" />
                                                                                <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                    <RequiredField IsRequired="True" />
                                                                                </ValidationSettings>
                                                                                <InvalidStyle BackColor="Pink">
                                                                                </InvalidStyle>
                                                                            </dx:ASPxDateEdit>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="BizPartner Code">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxGridLookup ID="aglBizPartnerCode" runat="server" Width="170px" ClientInstanceName="aglBizPartnerCode"
                                                                                DataSourceID="sdsBizPartner" KeyFieldName="BizPartnerCode" OnLoad="aglBizPartnerCode_Load" TextFormatString="{0}" AutoGenerateColumns="false">
                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                    <Settings ShowFilterRow="True"></Settings>
                                                                                </GridViewProperties>
                                                                                <Columns>
                                                                                    <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="true" VisibleIndex="0">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="true" VisibleIndex="1">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="BusinessAccountCode" ReadOnly="true" VisibleIndex="2">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="BizAccountName" ReadOnly="true" VisibleIndex="3">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="Address" ReadOnly="true" VisibleIndex="4">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="ContactPerson" ReadOnly="true" VisibleIndex="5">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dx:GridViewDataTextColumn>
                                                                                </Columns>
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
                                                                <dx:LayoutItem Caption="Period End">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxDateEdit ID="dtpDateTo" runat="server" OnInit="dtpDateTo_Init" OnLoad="Date_Load" Width="170px" ClientInstanceName="dtpDateTo">
                                                                                <ClientSideEvents Validation="OnValidation" ValueChanged="OnCompareDate" />
                                                                                <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                    <RequiredField IsRequired="True" />
                                                                                </ValidationSettings>
                                                                                <InvalidStyle BackColor="Pink">
                                                                                </InvalidStyle>
                                                                            </dx:ASPxDateEdit>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Profit Center Code">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxGridLookup ID="aglProfitCenter" runat="server" DataSourceID="sdsProfitCenter" OnLoad="LookupLoad"
                                                                                KeyFieldName="ProfitCenterCode" TextFormatString="{0}" Width="170px" AutoGenerateColumns="false" ClientInstanceName="aglProfitCenter">
                                                                                <GridViewProperties Settings-ShowFilterRow="true">
                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                    <Settings ShowFilterRow="True"></Settings>
                                                                                </GridViewProperties>
                                                                                <Columns>
                                                                                    <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" ReadOnly="true">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="true">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dx:GridViewDataTextColumn>
                                                                                </Columns>
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
                                                                <dx:LayoutItem Caption="Effectivity Date">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxDateEdit ID="dtpEffectivityDate" runat="server" OnLoad="Date_Load" Width="170px">
                                                                                <ClientSideEvents Validation="OnValidation" />
                                                                                <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                    <RequiredField IsRequired="True" />
                                                                                </ValidationSettings>
                                                                                <InvalidStyle BackColor="Pink">
                                                                                </InvalidStyle>
                                                                            </dx:ASPxDateEdit>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Status">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <%--<dx:ASPxComboBox ID="cboStatus" runat="server" OnLoad="ComboBoxLoad" ClientInstanceName="cboStatus" Width="170px">
                                                                            <ClientSideEvents Validation="OnValidation" SelectedIndexChanged="statuschanged" />
                                                                            <Items>
                                                                                <dx:ListEditItem Text="New" Value="New" />
                                                                                <dx:ListEditItem Text="Renew" Value="Renew" />
                                                                            </Items>
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxComboBox>--%>
                                                                            <dx:ASPxTextBox ID="txtStatus" runat="server" Width="170px" ClientInstanceName="txtStatus" ReadOnly="true">
                                                                            </dx:ASPxTextBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <%-- <dx:LayoutItem Caption="Non Billable Days">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxspinedit ID="NonBillableDays" runat="server" Width="170px" ClientInstanceName="NonBillableDays" ReadOnly="false" MinValue="0" MaxValue="1000" ClientEnabled="false">
                                                                            </dx:ASPxspinedit>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>--%>
                                                                <dx:LayoutItem ClientVisible="false">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxGridView ID="gvRefC" runat="server" ClientInstanceName="gvRefC" AutoGenerateColumns="true" BatchEditStartEditing="OnStartEditing">
                                                                                <SettingsEditing Mode="Batch" />
                                                                                <SettingsPager Mode="ShowAllRecords" />
                                                                            </dx:ASPxGridView>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>

                                                                <dx:LayoutItem ClientVisible="false">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxGridView ID="gvRefCN" runat="server" ClientInstanceName="gvRefCN" AutoGenerateColumns="true" BatchEditStartEditing="gv2_OnStartEditing">
                                                                                <SettingsEditing Mode="Batch" />
                                                                                <SettingsPager Mode="ShowAllRecords" />
                                                                            </dx:ASPxGridView>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>


                                                                <dx:LayoutGroup Caption="Storage">
                                                                    <Items>
                                                                        <dx:LayoutItem Caption="">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="1100px"
                                                                                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                                                        OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" Validation="OnValidation" OnInitNewRow="gv1_InitNewRow">
                                                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing"
                                                                                            CustomButtonClick="OnCustomClick" />
                                                                                        <SettingsPager Mode="ShowAllRecords" />
                                                                                        <Settings ShowStatusBar="Hidden" HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="250" />
                                                                                        <SettingsEditing Mode="Batch" />
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false" VisibleIndex="0">
                                                                                                <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                                                </PropertiesTextEdit>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="60px">
                                                                                            </dx:GridViewCommandColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Width="80px" ReadOnly="true" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center">
                                                                                                <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                                                </PropertiesTextEdit>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="ServiceType" Caption="Service Code" VisibleIndex="3" Width="180px" Name="ServiceType" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="ServiceType" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsServiceType" KeyFieldName="ServiceType" ClientInstanceName="gl" TextFormatString="{0}" Width="180px">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="ServiceType" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="1" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Type" VisibleIndex="2" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Rate" VisibleIndex="3" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>


                                                                                                        <ClientSideEvents DropDown="lookup" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" ValueChanged="function(s,e){ 
                                                                        var g = gl.GetGridView();
                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'ServiceType;Description;Rate', UpdateStorage); 
                                                                    }" />



                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Description" Name="Description" ShowInCustomizationForm="True" VisibleIndex="4" Width="180px" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxTextBox ID="txtBox" runat="server" ClientEnabled="false"
                                                                                                        Value='<%# Bind("Description") %>' />
                                                                                                </EditItemTemplate>
                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="BillingType" Caption="Bill Type" VisibleIndex="5" Width="150px" Name="BillingType" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="BillingType" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsBillingType" KeyFieldName="BillingType" TextFormatString="{0}" Width="150px" ClientInstanceName="gl3">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="BillingType" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp"
                                                                                                            ValueChanged="BillingTypeStorage" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>
                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Service Rate" FieldName="ServiceRate" Name="ServiceRate" ShowInCustomizationForm="True" VisibleIndex="6" Width="100px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="gServiceRate" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"
                                                                                                    DisplayFormatString="{0:N4}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MinValue="0" DecimalPlaces="4">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>

                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Excess Storage Rate" FieldName="ExcessRate" Name="ExcessRate" ShowInCustomizationForm="True" VisibleIndex="7" Width="100px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="gExcessRate" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"
                                                                                                    DisplayFormatString="{0:N4}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MinValue="0" DecimalPlaces="4">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="UnitOfMeasure" VisibleIndex="8" Width="110px" Name="UnitOfMeasure" Caption="Unit Of Measure (Qty)" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="UnitOfMeasure" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                                                        DataSourceID="sdsUnitOfMeasure" KeyFieldName="UnitOfMeasure" ClientInstanceName="gl2" TextFormatString="{0}" Width="110px" OnLoad="gvLookupLoad">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="UnitOfMeasure" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" ValueChanged="function(s,e){ 
                                                                                                                                        var g = gl2.GetGridView();
                                                                                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'UnitOfMeasure', UpdateUOM); 
                                                                                                                                    }" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="UnitOfMeasureBulk" VisibleIndex="9" Width="0px" Name="UnitOfMeasureBulk" Caption="Unit Of Measure (Bulk)" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="UnitOfMeasureBulk" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                                                        DataSourceID="sdsUnitOfMeasure" KeyFieldName="UnitOfMeasure" ClientInstanceName="gUnitOfMeasureBulk" TextFormatString="{0}" Width="110px" OnLoad="gvLookupLoad">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="UnitOfMeasure" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataCheckColumn FieldName="Vatable" Name="Vatable" ShowInCustomizationForm="True" VisibleIndex="10" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesCheckEdit AllowGrayed="false" ValueChecked="true" ValueUnchecked="false" ValueType="System.Boolean" ClientInstanceName="Vatable">
                                                                                                    <ClientSideEvents CheckedChanged="function(s, e){ gv1.batchEditApi.EndEdit(); VatableChanged(); }" />
                                                                                                </PropertiesCheckEdit>
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>

                                                                                            </dx:GridViewDataCheckColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="VATCode" Caption="VAT Code" VisibleIndex="11" Width="80px" Name="VATCode" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="VATCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsVATCode" KeyFieldName="VATCode" TextFormatString="{0}" Width="80px" ClientInstanceName="gVATCode">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="VATCode" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="1" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Rate" VisibleIndex="2" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Period" Caption="Billing Period" VisibleIndex="12" Width="100px" Name="BillingType" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="Period" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsBillingPeriod" KeyFieldName="BillingPeriodCode" TextFormatString="{0}" Width="100px" ClientInstanceName="glPeriod">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="BillingPeriodCode" VisibleIndex="0" UnboundType="String" Caption="Billing Period">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>
                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataCheckColumn FieldName="IsMulStorage" Name="IsMulStorage" Caption="Multiple Storage" ShowInCustomizationForm="True" VisibleIndex="13" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesCheckEdit AllowGrayed="false" ValueChecked="true" ValueUnchecked="false" ValueType="System.Boolean" ClientInstanceName="IsMulStorage">
                                                                                                    <ClientSideEvents CheckedChanged="function(s, e){ gv1.batchEditApi.EndEdit(); MulStorageChange();}" />
                                                                                                </PropertiesCheckEdit>
                                                                                            </dx:GridViewDataCheckColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="StorageCode" VisibleIndex="14" Width="180px" Name="StorageCode" Caption="Storage Code" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="StorageCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsServiceType" KeyFieldName="ServiceType" ClientInstanceName="gStorageCode" TextFormatString="{0}" Width="180px" SelectionMode="Multiple">
                                                                                                        <GridViewProperties>
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSort="False" />
                                                                                                            <Settings ShowFilterRow="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px" SelectAllCheckboxMode="AllPages">
                                                                                                            </dx:GridViewCommandColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="ServiceType" VisibleIndex="1" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="2" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Type" VisibleIndex="3" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Rate" VisibleIndex="4" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataCheckColumn FieldName="IsDiffCustomer" Name="IsDiffCustomer" Caption="Different Customer" ShowInCustomizationForm="True" VisibleIndex="15" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesCheckEdit AllowGrayed="false" ValueChecked="true" ValueUnchecked="false" ValueType="System.Boolean" ClientInstanceName="IsDiffCustomer">
                                                                                                    <ClientSideEvents CheckedChanged="function(s, e){ gv1.batchEditApi.EndEdit(); DiffCustomerChange();}" />
                                                                                                </PropertiesCheckEdit>
                                                                                            </dx:GridViewDataCheckColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="DiffCustomerCode" VisibleIndex="16" Width="180px" Name="DiffCustomerCode" Caption="Customer Code" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="DiffCustomerCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsBizPartner" KeyFieldName="BizPartnerCode" ClientInstanceName="gDiffCustomerCode" TextFormatString="{0}" Width="180px" SelectionMode="Multiple">
                                                                                                        <GridViewProperties>
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSort="False" />
                                                                                                            <Settings ShowFilterRow="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px" SelectAllCheckboxMode="AllPages">
                                                                                                            </dx:GridViewCommandColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="true" VisibleIndex="0">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="true" VisibleIndex="1">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="BusinessAccountCode" ReadOnly="true" VisibleIndex="2">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="BizAccountName" ReadOnly="true" VisibleIndex="3">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Address" ReadOnly="true" VisibleIndex="4">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="ContactPerson" ReadOnly="true" VisibleIndex="5">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Handling In Rate" FieldName="HandlingInRate" Name="HandlingInRate" ShowInCustomizationForm="True" VisibleIndex="17" Width="110px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="gHandlingInRate" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"
                                                                                                    DisplayFormatString="{0:N4}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MinValue="0" DecimalPlaces="4">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>

                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Handling Out Rate" FieldName="HandlingOutRate" Name="HandlingOutRate" ShowInCustomizationForm="True" VisibleIndex="18" Width="110px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="gHandlingOutRate" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"
                                                                                                    DisplayFormatString="{0:N4}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MinValue="0" DecimalPlaces="4">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>

                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Min Handling In" FieldName="MinHandlingIn" Name="MinHandlingIn" ShowInCustomizationForm="True" VisibleIndex="19" Width="110px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="gMinHandlingIn" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                                                    DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>

                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Min Handling Out" FieldName="MinHandlingOut" Name="MinHandlingOut" ShowInCustomizationForm="True" VisibleIndex="20" Width="110px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="gMinHandlingOut" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                                                    DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>

                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Min Storage" FieldName="MinStorage" Name="MinStorage" ShowInCustomizationForm="True" VisibleIndex="21" Width="110px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="gMinStorage" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                                                    DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="No Storage Charge For Day" FieldName="BeginDay" Name="BeginDay" ShowInCustomizationForm="True" VisibleIndex="22" Width="110px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="gBeginDay" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"
                                                                                                    DisplayFormatString="{0}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Staging Free of Charge (Days)" FieldName="Staging" Name="Staging" ShowInCustomizationForm="True" VisibleIndex="23" Width="110px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="gStaging" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"
                                                                                                    DisplayFormatString="{0}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Allocation Chargeable (Days)" FieldName="AllocChargeable" Name="AllocChargeable" ShowInCustomizationForm="True" VisibleIndex="24" Width="110px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="gAllocChargeable" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"
                                                                                                    DisplayFormatString="{0}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataCheckColumn FieldName="SplitBill" Name="SplitBill" Caption="Split Billing" ShowInCustomizationForm="True" VisibleIndex="25" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" Width="0px">
                                                                                                <PropertiesCheckEdit AllowGrayed="false" ValueChecked="true" ValueUnchecked="false" ValueType="System.Boolean">
                                                                                                    <ClientSideEvents CheckedChanged="function(s, e){ gv1.batchEditApi.EndEdit(); SplitBillClearing();}" />
                                                                                                </PropertiesCheckEdit>
                                                                                            </dx:GridViewDataCheckColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="ServiceHandling" Caption="Service Code for Split Billing" VisibleIndex="26" Width="0px" Name="ServiceHandling" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="ServiceHandling" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsServiceType" KeyFieldName="ServiceType" ClientInstanceName="gServiceHandling" TextFormatString="{0}" Width="180px">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="ServiceType" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="1" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Type" VisibleIndex="2" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Rate" VisibleIndex="3" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents DropDown="lookup" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" RowClick="function(s,e){
                                                                                                            setTimeout(function(){
                                                                                                                closing = true;
                                                                                                                gl2.GetGridView().PerformCallback('ServiceHandling' + '|' + gServiceHandling.GetValue() + '|' + 'code');
                                                                                                                e.processOnServer = false;
                                                                                                                servhan = true
                                                                                                                }, 1000);
                                                                                                            }" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Split Bill Rate" FieldName="SplitBillRate" Name="SplitBillRate" ShowInCustomizationForm="True" VisibleIndex="27" Width="0px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="gSplitBillRate" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"
                                                                                                    DisplayFormatString="{0:N4}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MinValue="0" DecimalPlaces="4">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>

                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="HandlingUOMQty" VisibleIndex="28" Width="0px" Name="HandlingUOMQty" Caption="Split Billing UOM" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="HandlingUOMQty" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsUnitOfMeasure" KeyFieldName="UnitOfMeasure" ClientInstanceName="gHandlingUOMQty" TextFormatString="{0}" Width="110px" OnLoad="gvLookupLoad">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="UnitOfMeasure" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="HandlingUOM" VisibleIndex="29" Width="180px" Name="HandlingUOM" Caption="Handling UOM" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="HandlingUOM" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsUnitOfMeasure" KeyFieldName="UnitOfMeasure" ClientInstanceName="gHandlingUOM" TextFormatString="{0}" Width="180px" OnLoad="gvLookupLoad">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="UnitOfMeasure" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <%--<ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />--%>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" ValueChanged="function(s,e){ 
                                                                                                                                        var g = gHandlingUOM.GetGridView();
                                                                                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'UnitOfMeasure', UpdateHandlingUOM);
                                                                                                            }" />

                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="HandlingOutUOM" VisibleIndex="29" Width="180px" Name="HandlingOutUOM" Caption="Handling Out UOM" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="HandlingOutUOM" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsUnitOfMeasure" KeyFieldName="UnitOfMeasure" ClientInstanceName="gHandlingOutUOM" TextFormatString="{0}" Width="180px" OnLoad="gvLookupLoad">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="UnitOfMeasure" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <%--<ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />--%>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" ValueChanged="function(s,e){ 
                                            var g = gHandlingOutUOM.GetGridView();
                                            g.GetRowValues(g.GetFocusedRowIndex(), 'UnitOfMeasure', UpdateHandlingOutUOM);
                }" />

                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="HandlingUOMBulk" VisibleIndex="29" Width="0" Name="HandlingUOMBulk" Caption="Handling UOM (Bulk)" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="HandlingUOMBulk" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsUnitOfMeasure" KeyFieldName="UnitOfMeasure" ClientInstanceName="gHandlingUOMBulk" TextFormatString="{0}" Width="110px" OnLoad="gvLookupLoad">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="UnitOfMeasure" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="BillingPrintOutStr" Caption="Billing Storage PrintOut" VisibleIndex="30" Width="110px" Name="BillingPrintOutStr" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="BillingPrintOutStr" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsBillingPrintOut" KeyFieldName="PrintCode" TextFormatString="{0}" Width="110px" ClientInstanceName="gBillingPrintOutStr">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="PrintCode" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="BillingPrintOutHan" Caption="Split Bill PrintOut" VisibleIndex="31" Width="0px" Name="BillingPrintOutHan" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="BillingPrintOutHan" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsBillingPrintOut_2" KeyFieldName="PrintCode" TextFormatString="{0}" Width="110px" ClientInstanceName="gBillingPrintOutHan">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="PrintCode" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Conversion Factor" FieldName="ConvFactorStr" Name="ConvFactorStr" ShowInCustomizationForm="True" VisibleIndex="32" Width="100px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit ClientInstanceName="gConvFactorStr" NullDisplayText="0.000000" ConvertEmptyStringToNull="False" NullText="0.000000"
                                                                                                    DisplayFormatString="{0:N6}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>

                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Conversion Factor (Handling)" FieldName="ConvFactorHan" Name="ConvFactorHan" ShowInCustomizationForm="True" VisibleIndex="33" Width="0px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit ClientInstanceName="gConvFactorHan" NullDisplayText="0.000000" ConvertEmptyStringToNull="False" NullText="0.000000"
                                                                                                    DisplayFormatString="{0:N6}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>

                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Remarks" Name="Remarks" ShowInCustomizationForm="True" VisibleIndex="34" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" Width="180px">
                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="40" Width="0">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Field2" Name="Field2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="41" Width="0">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Field3" Name="Field3" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="42" Width="0">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Field4" Name="Field4" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="43" Width="0">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="44" Width="0">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Field6" Name="Field6" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="45" Width="0">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Field7" Name="Field7" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="46" Width="0">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Field8" Name="Field8" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="47" Width="0">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Field9" Name="Field9" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="48" Width="0">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Type" Name="Type" ShowInCustomizationForm="True" Visible="True" ReadOnly="true" VisibleIndex="49" Width="0">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="GMV" FieldName="GMV" Name="GMV" ShowInCustomizationForm="True" VisibleIndex="50" Width="100px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit ClientInstanceName="GMV" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"
                                                                                                    DisplayFormatString="{0:N4}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>

                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Days" FieldName="Days" Name="Days" ShowInCustomizationForm="True" VisibleIndex="51" Width="100px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit ClientInstanceName="Days" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"
                                                                                                    DisplayFormatString="{0}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>

                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataSpinEditColumn FieldName="NonBillableDays" Caption="Non Billable Days" Name="Type" ShowInCustomizationForm="True" Visible="True" ReadOnly="false" VisibleIndex="52" Width="100" PropertiesSpinEdit-MinValue="0" PropertiesSpinEdit-MaxValue="99999">
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                        </Columns>
                                                                                    </dx:ASPxGridView>
                                                                                    <dx:ASPxLoadingPanel ID="LoadPanel" runat="server" Text="Loading..."
                                                                                        ClientInstanceName="LoadPanel" ContainerElementID="gv1" Modal="true">
                                                                                        <LoadingDivStyle Opacity="0"></LoadingDivStyle>
                                                                                    </dx:ASPxLoadingPanel>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                    </Items>
                                                                </dx:LayoutGroup>
                                                                <dx:LayoutGroup Caption="Non-Storage">
                                                                    <Items>
                                                                        <dx:LayoutItem Caption="">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxGridView ID="gv2" OnInit="gv2_Init" runat="server" AutoGenerateColumns="False" Width="1100px"
                                                                                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv2"
                                                                                        OnRowValidating="grid_RowValidating" OnBatchUpdate="gv2_BatchUpdate" OnCustomCallback="gv2_CustomCallback" Validation="OnValidation" OnInitNewRow="gv2_InitNewRow">
                                                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans" BatchEditEndEditing="gv2_OnEndEditing" BatchEditStartEditing="gv2_OnStartEditing"
                                                                                            CustomButtonClick="OnCustomClick" />
                                                                                        <SettingsPager Mode="ShowAllRecords" />
                                                                                        <Settings ShowStatusBar="Hidden" HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="250" />
                                                                                        <SettingsEditing Mode="Batch" />
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false" VisibleIndex="0">
                                                                                                <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                                                </PropertiesTextEdit>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="60px">
                                                                                            </dx:GridViewCommandColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Width="80px" ReadOnly="true" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center">
                                                                                                <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                                                </PropertiesTextEdit>
                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="ServiceType" Caption="Service Code" VisibleIndex="3" Width="180px" Name="ServiceType" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="ServiceType" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsServiceTypeNon" KeyFieldName="ServiceType" ClientInstanceName="aServiceType" TextFormatString="{0}" Width="180px">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="ServiceType" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="1" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Type" VisibleIndex="2" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Rate" VisibleIndex="3" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents DropDown="lookup" KeyPress="gridLookup_KeyPress2" KeyDown="gridLookup_KeyDown2" ValueChanged="function(s,e){ 
                                                                        var g = aServiceType.GetGridView();
                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'ServiceType;Description;Rate', UpdateNonStorage); 
                                                                    }" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Description" Name="Description" ShowInCustomizationForm="True" VisibleIndex="4" Width="180px" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxTextBox ID="txtBox" runat="server" ClientEnabled="false"
                                                                                                        Value='<%# Bind("Description") %>' />
                                                                                                </EditItemTemplate>
                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Service Rate" FieldName="ServiceRate" Name="ServiceRate" ShowInCustomizationForm="True" VisibleIndex="5" Width="100px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="aServiceRate" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"
                                                                                                    DisplayFormatString="{0:N4}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MinValue="0" DecimalPlaces="4">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>

                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="UnitOfMeasure" VisibleIndex="6" Width="110px" Name="UnitOfMeasure" Caption="Unit Of Measure (Qty)" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="UnitOfMeasure" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                                                        DataSourceID="sdsUnitOfMeasure" KeyFieldName="UnitOfMeasure" ClientInstanceName="aUnitOfMeasure" TextFormatString="{0}" Width="110px" OnLoad="gvLookupLoad">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="UnitOfMeasure" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress2" KeyDown="gridLookup_KeyDown2" DropDown="lookup" CloseUp="gridLookup_CloseUp2" ValueChanged="function(s,e){ 
                                                                                                                                        var g = aUnitOfMeasure.GetGridView();
                                                                                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'UnitOfMeasure', UpdateUOMNon); 
                                                                                                                                    }" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="UnitOfMeasureBulk" VisibleIndex="7" Width="0px" Name="UnitOfMeasureBulk" Caption="Unit Of Measure (Bulk)" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>

                                                                                                    <dx:ASPxGridLookup ID="UnitOfMeasureBulk" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsUnitOfMeasure" KeyFieldName="UnitOfMeasure" ClientInstanceName="aUnitOfMeasureBulk" TextFormatString="{0}" Width="110px" OnLoad="gvLookupLoad">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="UnitOfMeasure" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress2" KeyDown="gridLookup_KeyDown2" DropDown="lookup" CloseUp="gridLookup_CloseUp2" />
                                                                                                    </dx:ASPxGridLookup>

                                                                                                </EditItemTemplate>
                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataCheckColumn FieldName="Vatable" Name="Vatable" ShowInCustomizationForm="True" VisibleIndex="8" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesCheckEdit AllowGrayed="false" ValueChecked="true" ValueUnchecked="false" ValueType="System.Boolean">
                                                                                                    <ClientSideEvents CheckedChanged="function(s, e){ gv2.batchEditApi.EndEdit(); VatableChanged2(); }" />
                                                                                                </PropertiesCheckEdit>
                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataCheckColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="VATCode" Caption="VAT Code" VisibleIndex="9" Width="80px" Name="VATCode" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="VATCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsVATCode" KeyFieldName="VATCode" TextFormatString="{0}" Width="80px" ClientInstanceName="aVATCode">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="VATCode" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="1" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Rate" VisibleIndex="2" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress2" KeyDown="gridLookup_KeyDown2" DropDown="lookup" CloseUp="gridLookup_CloseUp2" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="BillingType" Caption="Bill Type" VisibleIndex="10" Width="80px" Name="BillingType" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="BillingType" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsBillingTypeNon" KeyFieldName="BillingType" TextFormatString="{0}" Width="80px" ClientInstanceName="aBillingType">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="BillingType" VisibleIndex="0" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="1" UnboundType="String">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress2" KeyDown="gridLookup_KeyDown2" DropDown="lookup" CloseUp="gridLookup_CloseUp2" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>
                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Period" Caption="Billing Period" VisibleIndex="11" Width="100px" Name="BillingType" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="Period" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="sdsBillingPeriod" KeyFieldName="BillingPeriodCode" TextFormatString="{0}" Width="100px" ClientInstanceName="aPeriod">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="BillingPeriodCode" VisibleIndex="0" UnboundType="String" Caption="Billing Period">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress2" KeyDown="gridLookup_KeyDown2" DropDown="lookup" CloseUp="gridLookup_CloseUp2" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>
                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>

                                                                                            <dx:GridViewDataSpinEditColumn Caption="MIN" FieldName="Min" Name="Min" ShowInCustomizationForm="True" VisibleIndex="19" Width="110px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="gMin" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                                                    DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>

                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="MAX" FieldName="Max" Name="Max" ShowInCustomizationForm="True" VisibleIndex="20" Width="110px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="gMax" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                                                    DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>

                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataSpinEditColumn>

                                                                                            <dx:GridViewDataTextColumn FieldName="Remarks" Name="Remarks" ShowInCustomizationForm="True" VisibleIndex="12" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Width="180px" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataCheckColumn FieldName="AllocC" Caption="AllocChargeable" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Width="120px" VisibleIndex="13">
                                                                                            </dx:GridViewDataCheckColumn>

                                                                                            <dx:GridViewDataTextColumn FieldName="TruckT" Caption="TruckType" VisibleIndex="14" Width="100px" Name="TruckType" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" UnboundType="String" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="txtTruckType" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                                        DataSourceID="Truckdata" KeyFieldName="TruckType" TextFormatString="{0}" Width="100px" ClientInstanceName="atxtTruckType">
                                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="TruckType" VisibleIndex="0" UnboundType="String" Caption="Truck Type">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress2" KeyDown="gridLookup_KeyDown2" DropDown="lookup" CloseUp="gridLookup_CloseUp2" ValueChanged="function(s,e){ 
                                                                                                                                        var g = atxtTruckType.GetGridView();
                                                                                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'TruckType', UpdateTruckType); 
                                                                                                                                    }" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>
                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>

                                                                                            <dx:GridViewDataTextColumn FieldName="TransT" Caption="TransType" VisibleIndex="15" Width="100px" Name="TransType" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <Settings AllowSort="False"></Settings>
                                                                                                <EditItemTemplate>
                                                                                                    <dx:ASPxGridLookup ID="txtTrans" runat="server" AutoGenerateColumns="False" ClientInstanceName="atxtTrans" DataSourceID="trans" KeyFieldName="TransType" Width="100px">
                                                                                                        <GridViewProperties>
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="TransType" ReadOnly="True" VisibleIndex="0" UnboundType="String" ShowInCustomizationForm="True">
                                                                                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                        </Columns>
                                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress2" KeyDown="gridLookup_KeyDown2" DropDown="lookup" CloseUp="gridLookup_CloseUp2" ValueChanged="function(s,e){ 
                                                                                                                                        var g = atxtTrans.GetGridView();
                                                                                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'TransType', UpdateTransType); 
                                                                                                                                    }" />
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </EditItemTemplate>
                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataTextColumn>

                                                                                            <dx:GridViewDataTextColumn FieldName="Type" Name="Type" ShowInCustomizationForm="True" Visible="True" ReadOnly="true" VisibleIndex="16" Width="0">
                                                                                            </dx:GridViewDataTextColumn>

                                                                                            <dx:GridViewDataSpinEditColumn Caption="GMV" FieldName="GMV" Name="GMV" ShowInCustomizationForm="True" VisibleIndex="50" Width="100px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit ClientInstanceName="NSGMV" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"
                                                                                                    DisplayFormatString="{0:N4}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>

                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Days" FieldName="Days" Name="Days" ShowInCustomizationForm="True" VisibleIndex="51" Width="100px" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                                <PropertiesSpinEdit ClientInstanceName="NSDays" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"
                                                                                                    DisplayFormatString="{0}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>

                                                                                                <Settings AllowSort="False"></Settings>

                                                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                                                            </dx:GridViewDataSpinEditColumn>

                                                                                        </Columns>
                                                                                    </dx:ASPxGridView>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                    </Items>
                                                                </dx:LayoutGroup>
                                                                <%--<dx:LayoutItem Caption="Billing Period Type">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="aglBillingPeriod" runat="server" ClientInstanceName="aglBillingPeriod" DataSourceID="sdsBillingPeriod" 
                                                                            KeyFieldName="BillingPeriodCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px" AutoGenerateColumns="false">
                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"/>
                                                                                <Settings ShowFilterRow="True"></Settings>
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="BillingPeriodCode" ReadOnly="true">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="true">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="DaysCount" ReadOnly="true">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>    
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
                                                                <dx:LayoutItem Caption="Field6">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxTextBox ID="txtHField6" runat="server" OnLoad="TextboxLoad">
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
                                                                <dx:LayoutItem Caption="Field7">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad">
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
                                                                <dx:LayoutItem Caption="Field8">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxTextBox ID="txtHField8" runat="server" OnLoad="TextboxLoad">
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
                                                                <dx:LayoutItem Caption="Field9">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxTextBox ID="txtHField9" runat="server" OnLoad="TextboxLoad">
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
                                                                <dx:LayoutItem Caption="Open Period" ShowCaption="False">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxDateEdit ID="dtpOpenPeriod" runat="server" Width="170px" ClientInstanceName="dtpOpenPeriod" ClientVisible="False">
                                                                            </dx:ASPxDateEdit>
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
                                                                            <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" Width="170px" ReadOnly="True">
                                                                            </dx:ASPxTextBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Submitted Date">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" Width="170px" ReadOnly="True">
                                                                            </dx:ASPxTextBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                            </Items>
                                                        </dx:LayoutGroup>
                                                        <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction">
                                                            <Items>
                                                                <dx:LayoutItem Caption="">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="608px" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Settings-ShowStatusBar="Hidden">
                                                                                <Settings ShowStatusBar="Hidden"></Settings>
                                                                                <SettingsBehavior FilterRowMode="OnClick" ColumnResizeMode="NextColumn" />
                                                                                <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" />
                                                                                <SettingsPager PageSize="5">
                                                                                </SettingsPager>
                                                                                <SettingsEditing Mode="Batch">
                                                                                </SettingsEditing>
                                                                                <Columns>
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
                                                                                    <dx:GridViewDataTextColumn FieldName="RTransType" Caption="Reference TransType" ShowInCustomizationForm="True" VisibleIndex="1" ReadOnly="True" Name="RTransType">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="REFDocNumber" Caption="Reference DocNumber" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="True">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="RCommandString" ShowInCustomizationForm="True" VisibleIndex="3" ReadOnly="True" Width="0px">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4" ReadOnly="True">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" Caption="DocNumber" ReadOnly="True">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="CommandString" ShowInCustomizationForm="True" VisibleIndex="6" ReadOnly="True" Width="0px">
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
                                            </Items>
                                        </dx:ASPxFormLayout>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxCallbackPanel>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>



            </Items>
        </dx:ASPxFormLayout>

        <dx:ASPxPanel ID="BottomPanel" runat="server" FixedPosition="WindowBottom" BackColor="#FFFFFF" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <div class="pnl-content">
                        <dx:ASPxCheckBox Style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                        <dx:ASPxButton ID="updateBtn" runat="server" Text="Add" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
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
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" AutoPostBack="False" UseSubmitBehavior="false">
                                    <ClientSideEvents Click="function (s, e){  cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                </dx:ASPxButton>
                            </td>
                            <td>
                                <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" AutoPostBack="False" UseSubmitBehavior="false">
                                    <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

    </form>
    <!--#region Region Datasource-->
    <%--<ClientSideEvents SelectedIndexChanged="ComboboxChanged"/>--%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.Contract" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.Contract" UpdateMethod="UpdateData" DeleteMethod="Deletedata">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="" Name="DocNumber" SessionField="DocNumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.Contract+ContractDetail" SelectMethod="getdetail" UpdateMethod="UpdateContractDetail" TypeName="Entity.Contract+ContractDetail" DeleteMethod="DeleteContractDetail" InsertMethod="AddContractDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetailNon" runat="server" DataObjectTypeName="Entity.Contract+ContractDetailNon" SelectMethod="getdetailNon" UpdateMethod="UpdateContractDetailNon" TypeName="Entity.Contract+ContractDetailNon" DeleteMethod="DeleteContractDetailNon" InsertMethod="AddContractDetailNon">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.Contract+RefTransaction">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM WMS.ContractDetail WHERE DocNumber IS NULL" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsForDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT TOP 1 [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] WHERE 1 = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBizPartner" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.BizPartnerCode, A.Name, ISNULL(B.BusinessAccountCode,'') AS BusinessAccountCode, ISNULL(C.BizAccountName,'') AS BizAccountName, B.Address, B.ContactPerson FROM Masterfile.BPCustomerInfo A 
        INNER JOIN Masterfile.BizPartner B ON A.BizPartnerCode = B.BizPartnerCode LEFT JOIN Masterfile.BizAccount C ON B.BusinessAccountCode = C.BizAccountCode WHERE (ISNULL(A.IsInactive,0) = 0 AND ISNULL(B.IsInactive,0) = 0)"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, Description FROM Masterfile.[Warehouse] WHERE ISNULL([IsInactive],0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsContract" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber, DocDate, ContractType, BizPartnerCode, DateFrom AS PeriodFrom, DateTo AS PeriodTo, EffectivityDate, BillingPeriodType, ProfitCenterCode, Status, WarehouseCode FROM WMS.Contract WHERE ISNULL(SubmittedBy,'') != '' AND Status = 'ACTIVE'" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsServiceType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT ServiceType, Description, Type, ISNULL(ServiceRate,0) AS Rate FROM Masterfile.WMSServiceType WHERE ISNULL(IsInactive,0) = 0 AND Type = 'STORAGE'" OnInit="Connection_Init"></asp:SqlDataSource>
    <%--<asp:SqlDataSource ID="sdsServiceTypeAll" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT ServiceType, Description, Type, ISNULL(ServiceRate,0) AS Rate FROM Masterfile.WMSServiceType WHERE ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>--%>
    <asp:SqlDataSource ID="sdsServiceTypeNon" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT ServiceType, Description, Type, ISNULL(ServiceRate,0) AS Rate FROM Masterfile.WMSServiceType WHERE ISNULL(IsInactive,0) = 0 AND Type != 'STORAGE'" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsProfitCenter" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ProfitCenterCode, Description FROM Accounting.ProfitCenter WHERE ISNULL(IsInActive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBillingPeriod" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BillingPeriodCode, Description, DaysCount FROM Masterfile.WMSBillingPeriod" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsUnitOfMeasure" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT UnitOfMeasure, Description FROM Masterfile.WMSUnitOfMeasure" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsContractDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT '' as DocNumber,RIGHT('00000'+CONVERT(varchar(max),ROW_NUMBER() OVER (ORDER BY ServiceType)),5)  as LineNumber,ServiceType, Description,
        ServiceRate,'' as UnitOfMeasure,'' as UnitOfMeasureBulk, CONVERT(bit,0) as Vatable,'' as BillingType, CONVERT(bit,0) AS IsMulStorage, '' AS StorageCode, CONVERT(bit,0) AS IsDiffCustomer, '' AS DiffCustomerCode, 0.0000 as HandlingInRate,0.0000 HandlingOutRate,0.00 MinHandlingIn,0.00 MinHandlingOut,0.00 MinStorage,'' as Remarks,'' as Field1,'' as Field2,'' as Field3,'' as Field4,'' as Field5,'' as Field6,'' as Field7,'' as Field8,
        '' as Field9,Type, '' AS VATCode, 0.0000 AS	ExcessRate, 0 AS BeginDay, 0 AS Staging, 0 AS AllocChargeable, CONVERT(bit,0) AS SplitBill, '' AS ServiceHandling, '' AS HandlingUOMQty, '' AS HandlingUOMBulk, 'REGULAR' AS BillingPrintOutStr, '' AS BillingPrintOutHan, 0.000000 AS ConvFactorStr, 0.000000 AS ConvFactorHan, 0.0000 AS SplitBillRate, 0.00 Min, 0.00 Max, '' AS HandlingUOM
        FROM Masterfile.WMSServiceType WHERE ISNULL(IsStandard,0) = 1 and ISNULL(IsInactive,0) = 0 AND Type = 'STORAGE'"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsContractDetailNon" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT '' as DocNumber,RIGHT('00000'+CONVERT(varchar(max),ROW_NUMBER() OVER (ORDER BY ServiceType)),5)  as LineNumber,ServiceType, Description,
        ServiceRate,'' as UnitOfMeasure,'' as UnitOfMeasureBulk, CONVERT(bit,0) as Vatable,'' as BillingType, CONVERT(bit,0) AS IsMulStorage, '' AS StorageCode, CONVERT(bit,0) AS IsDiffCustomer, '' AS DiffCustomerCode, 0.00 as HandlingInRate,0.00 HandlingOutRate,0.00 MinHandlingIn,0.00 MinHandlingOut,0.00 MinStorage,'' as Remarks,'' as Field1,'' as Field2,'' as Field3,'' as Field4,'' as Field5,'' as Field6,'' as Field7,'' as Field8,
        '' as Field9,Type, '' AS VATCode, 0.0000 AS	ExcessRate, 0 AS BeginDay, 0 AS Staging, 0 AS AllocChargeable, CONVERT(bit,0) AS SplitBill, '' AS ServiceHandling, '' AS HandlingUOMQty, '' AS HandlingUOMBulk, 'REGULAR' AS BillingPrintOutStr, '' AS BillingPrintOutHan, 0.000000 AS ConvFactorStr, 0.000000 AS ConvFactorHan, 0.0000 AS SplitBillRate, 0.00 Min, 0.00 Max, '' AS HandlingUOM
        FROM Masterfile.WMSServiceType WHERE ISNULL(IsStandard,0) = 1 and ISNULL(IsInactive,0) = 0 AND Type = 'NONSTORAGE'"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsVATCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT TCode AS VATCode, Description, ISNULL(Rate,0) AS Rate FROM Masterfile.Tax WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBillingPrintOut" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [Text] AS PrintCode  FROM Masterfile.FormLayout WHERE FormName IN ('BILPRT') AND LocationCode = 'DOCNUMBER' ORDER BY RecordID ASC" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBillingPrintOut_2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [Text] AS PrintCode  FROM Masterfile.FormLayout WHERE FormName IN ('BILPRT') AND LocationCode = 'DOCNUMBER1' ORDER BY RecordID ASC" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBillingType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT 'SAME DAY' AS BillingType UNION ALL SELECT 'NEXT DAY' AS BillingType UNION ALL SELECT 'EXCESS QTYSD' AS BillingType UNION ALL SELECT 'EXCESS QTYND' AS BillingType UNION ALL SELECT 'MAG HANDLING' AS BillingType UNION ALL SELECT 'MAG EXDAYS' AS BillingType" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBillingTypeNon" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT 'ACT' AS BillingType,'ACTUAL' AS Description UNION ALL SELECT 'CHR' AS BillingType,'CHARGEABLE' AS Description" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Truckdata" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select TruckType from it.TruckType" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="trans" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT 'BOTH' AS TransType UNION ALL SELECT 'INBOUND' AS TransType UNION ALL SELECT 'OUTBOUND' AS TransType" OnInit="Connection_Init"></asp:SqlDataSource>

    <!--#endregion-->
</body>
</html>


