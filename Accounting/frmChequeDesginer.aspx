<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmChequeDesginer.aspx.cs" Inherits="GWL.frmChequeDesginer" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <script src="../Assets/jquery.min.js"></script>
    <script src="../Assets/popper.min.js"></script>
        <script src="../Assets/jquery-3.4.1.min.js"></script>
    <script src="../Assets/jquery.PrintArea.js"></script>
    <script src="../Assets/jquery-ui.js"></script>
    <link href="../Assets/tooltip/tooltip.css" rel="stylesheet" />
    <script src="../Assets/tooltip/tooltip.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
</head>

    <style>
        p
        {
            font-size:14px;
        }

        .move
        {
            cursor:move;
        }

.myButton {
    margin-top : 10px;
	-moz-box-shadow: 0px 11px 8px -8px #9aa5b3;
	-webkit-box-shadow: 0px 11px 8px -8px #9aa5b3;
	box-shadow: 0px 11px 8px -8px #9aa5b3;
	background-color:#1c60c7;
	-moz-border-radius:6px;
	-webkit-border-radius:6px;
	border-radius:6px;
	border:1px solid #1e4d7d;
	display:inline-block;
	cursor:pointer;
	color:#ffffff;
	font-family:Arial;
	font-size:13px;
	font-weight:bold;
	padding:9px 22px;
	text-decoration:none;
}
.myButton:hover {
	background-color:#1a92c9;
}
.myButton:active {
	position:relative;
	top:1px;
}

.pointer
        {
            cursor:pointer;
        }
   

.tooltip {
    display:inline-block;
    position:relative;
    border-bottom:1px dotted #666;
    text-align:left;
}

.tooltip .top {
    min-width:200px; 
    top:-7px;
    left:50%;
    transform:translate(-50%, -100%);
    padding:10px 20px;
    color:#000000;
    background-color:#FFFF66;
    font-weight:normal;
    font-size:13px;
    border-radius:8px;
    position:absolute;
    z-index:99999999;
    box-sizing:border-box;
    box-shadow:0 1px 8px rgba(0,0,0,0.5);
    display:none;
}

.tooltip:hover .top {
    display:block;
}

.tooltip .top i {
    position:absolute;
    top:100%;
    left:50%;
    margin-left:-12px;
    width:24px;
    height:12px;
    overflow:hidden;
}

.tooltip .top i::after {
    content:'';
    position:absolute;
    width:12px;
    height:12px;
    left:50%;
    transform:translate(-50%,-50%) rotate(45deg);
    background-color:#FFFF66;
    box-shadow:0 1px 8px rgba(0,0,0,0.5);
}
  </style>


    

<body>
    <form id="form1" runat="server" >

        <div id="container" style="width: 808px; font-weight: bold; height: 208px; border: double">

            <div id="payee">
                <span id="payeespan" runat="server" class="move" onclick="getPositionXY(this,this.id)">CASH</span>
            </div>

             <div id="amountW">
                <span id="amountWspan" class="move" onclick="getPositionXY(this,this.id)">Two thousand five hundred pesos only</span>
            </div>

            <div id="amountN">
                <span id="amountNspan" class="move"  onclick="getPositionXY(this,this.id)">2,500.00</span>
            </div>

            <div id ="date">
                <span id="dateSpan" runat="server"  class="move" onclick="getPositionXY(this,this.id)">June 24,2019</span>
            </div>

            <div id="remarks" runat="server">
                <span id="remarksSpan" runat="server"  class="move"  onclick="getPositionXY(this,this.id)"> >>For Payee's A/C Only<< </span>
            </div>     
        </div>
        

        <asp:HiddenField ID="DateX" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="DateY" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="AmountWX" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="AmountWY" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="AmountNX" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="AmountNY" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="PayeeX" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="PayeeY" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="CheckWidth" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="CheckHeight" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="RemarksX" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="RemarksY" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="Font" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="FontSize" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="BankID" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="BankName" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="PayeeName" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="SupplierCode" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="CheckAmount" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="CheckAmountW" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="CheckDate" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="DocNumber" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="CheckNumber" runat="server"></asp:HiddenField>
        <input type="text" id="letterSpacing" style="display:none"  runat="server"/>
        
        <div class="myButton tooltip" style="float:right; margin-right:180px; "><i class="fa fa-question-circle" style=" margin-right : 4px;" aria-hidden="true"></i>Help
        <div class="top">
        <h3>Help</h3>
           <%-- [ - Increase Font Size<br />
        ] - Decrease Font Size<br />--%>
        <p style="text-align:justify;">` : Remove \ On Dates<br />
        \ : Change Font Style<br />
        F : Change Form Width <br />
        + : Increase Date Spacing<br /> 
        - : Decrease Date Spacing<br />
        </p>
        <i></i>
        </div>
        </div>
        <%--<input type ="button" id="print_button" runat="server" class="btn btn-primary" text="Print" />--%>

        <asp:Button ID="print_button" runat="server"  class="myButton"  style="float:right; margin-right:10px;" Text="Print" />
        <asp:Button ID="update_button" runat="server"  class="myButton" style="float:right; margin-right:10px;" OnClientClick="update()" onClick="update_Click" Text="Update" />
        <p id='gfg'>X : , Y : </p>
    </form>

             <script type="text/javascript">
                 $(document).ready(function () {
                     setdefault();
                     var ID = JSON.stringify(BankID.value);
                     getDetails(ID)
                     //var currentFontSize = parseInt(divElement.css('font-size'));
                     //var currentFont = divElement.css('font-family');
                     //var currentWidth = divElement.css('width');
                     var letterSpacing = document.getElementById("letterSpacing").value;
                     var currentLetterSpacing = parseInt(letterSpacing);
                     $('#date span').css('letter-spacing', currentLetterSpacing);

                     var fontsize = document.getElementById("FontSize").value;
                     var font = document.getElementById("Font").value;
                     $("#container").css('font-size', fontsize);
                     $("#container").css('font-family', font);
                     //document.getElementById("FormX").value = currentWidth;
                     //document.getElementById("FormY").value = currentHeight;
                     Tipped.create('#help_button', 'some tooltip text');
                     });

                 $(function () {
                     $("#print_button").bind("click", function () {
                         var user = {};
                         user.DocNumber = $("#DocNumber").val();
                         user.BankID = $("#BankID").val();
                         user.CheckNumber = $("#CheckNumber").val();
                         $.ajax({
                             type: "POST",
                             contentType: "application/json; charset=utf-8",
                             url: "frmChequeDesginer.aspx/SaveUser",
                             data: '{user: ' + JSON.stringify(user) + '}',
                             dataType: "json",
                             success: function (response) {
                                 var divElement = $('#container');
                                 var currentFontSize = parseInt(divElement.css('font-size'));
                                 var check = document.getElementById("CheckDate").value;
                                 $("#container").css('border', 'none');
                                 $("#container").css('font-weight', 'bold');
                                 $("#container").css('font-size', 'currentFontSize');

                                 //LETTER SPACING
                                 var dateSpacing = $('#date span');
                                 var currentLetterSpacing = parseInt(dateSpacing.css('letter-spacing'));
                                 $("#LetterSpacing").val(currentLetterSpacing);
                                 //
                                 var mode = 'iframe'; //popup
                                 var close = mode == "popup";
                                 var options = { mode: mode, popClose: close };
                                 $("#container").printArea(options);
                                 $("#container").css('border', 'double');
                             }
                         });
                         return false;
                     });
                 });

                //print
                function update() {
                    //LETTER SPACING
                    var dateSpacing = $('#date span');
                    var currentLetterSpacing = parseInt(dateSpacing.css('letter-spacing'));
                    document.getElementById("letterSpacing").value = currentLetterSpacing.toString();
                    //
                    return false;
                }

                     //key up
                     $('body').keyup(function (e) {
                         if (e.keyCode == 70) {
                             // user press F (to change width and form height)
                             var form = prompt("Please enter the Form Width : ");
                             if (form == null || form == "") {
                                 txt = "User cancelled the prompt.";
                             }
                             else {
                                 $("#container").css("width", form);
                                 var form2 = prompt("Please enter the Form Height : ");
                                 if (form2 == null || form2 == "") {
                                     txt = "User cancelled the prompt.";
                                 }
                                 else
                                 {
                                     $("#container").css("height", form2);
                                     txt = "Changed Width/Height";
                                     alert(txt);
                                 }
                             }
                         }
                         if (e.keyCode == 189) {
                             // user press -
                             modifyFontSize('delspace');
                             var dateSpacing = $('#date span');
                             var currentLetterSpacing = parseInt(dateSpacing.css('letter-spacing'));
                         }
                         if (e.keyCode == 187) {
                             // user press =
                             modifyFontSize('addspace');
                             var dateSpacing = $('#date span');
                             var currentLetterSpacing = parseInt(dateSpacing.css('letter-spacing'));
                         }
                         //if (e.keyCode == 219) {
                         //    // user press [
                         //    modifyFontSize('increase');
                         //}
                         //if(e.keyCode == 221){
                         //    // user press ]
                         //    modifyFontSize('decrease');
                         //}
                         if (e.keyCode == 192) {
                             // user press `
                             toggle();
                         
                         }
                         if(e.keyCode == 220){
                             // user press \
                             var font = prompt("Please enter the font you want to use:","Calibri");
                             if (font == null || font == "") {
                                 txt = "User cancelled the prompt.";
                             } 
                             else {
                                 $("#container").css("font-family", font);
                                 txt = "Changed Font";
                                 alert(txt);
                             }
                         }
                     });


                     //toogle remove or add
                     var toggle = function () {
                         var on = false;
                         return function () {
                             if (!on) {
                                 on = true;
                                 var dateRemove = dateSpan.innerText.split('/').join(' ');
                                 dateSpan.innerText = dateRemove.toString();
                                 return;
                             }
                             var dateRemove = dateSpan.innerText.split(' ').join('/');
                             dateSpan.innerText = dateRemove.toString();
                             on = false;
                         }
                     }();
                    //

                     //get url parameter
                     function getUrlVars() {
                         var vars = {};
                         var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function (m, key, value) {
                             vars[key] = value;
                         });
                         return vars;
                     }

                     //get url parameter
                     function getUrlParam(parameter, defaultvalue) {
                         var urlparameter = defaultvalue;
                         if (window.location.href.indexOf(parameter) > -1) {
                             urlparameter = getUrlVars()[parameter];
                         }
                         return urlparameter;
                     }

                     //2020-03-02 AC Start Fixed Position when Increasing Font
                     function FixedSpacing() {
                         var dateSpan = $('#date span');
                         //var payeeSpan = $('#payee span');
                         
                         //payeeSpan.css('position', 'relative');
                         //payeeSpan.css('width', '0px');
                         dateSpan.css('position', 'relative');
                         dateSpan.css('width', '0px');
                     }
                      //2020-03-02 AC END Fixed Position when Increasing Font

                     //edit container font size
                     function modifyFontSize(flag) {
                         var divElement = $('#container');
                         var dateSpacing = $('#date span');
                       
                        
                         FixedSpacing();

                         var currentFontSize = parseInt(divElement.css('font-size'));
                         var currentLetterSpacing = parseInt(dateSpacing.css('letter-spacing'));
                         //if (flag == 'increase')
                         //{
                         //    currentFontSize += 1;
                         //    //FixedPosition();
                         //}
                         //else if (flag == 'decrease')
                         //{
                         //    currentFontSize -= 1;
                         //    //FixedPosition();
                         //}
                         if (flag == 'addspace')
                         {
                             currentLetterSpacing += 1;
                         }                       
                         else if (flag == 'delspace')
                         {
                             currentLetterSpacing -= 1;
                         }
                            
                         divElement.css('font-size', currentFontSize);
                         dateSpacing.css('letter-spacing', currentLetterSpacing);
                         document.getElementById("letterSpacing").value = currentLetterSpacing.toString();
                     }
           
                     //get coordinates
                     function getDetails(ID) {
                         $.ajax({
                             type: "POST",
                             contentType: "application/json; charset=utf-8",
                             url: "frmChequeDesginer.aspx/GetData",
                             data: '{ID: ' + ID + '}',
                             dataType: "json",
                             success: function (data) {
                                 for (var i = 0; i < data.d.length; i++) {
                                     document.getElementById("BankName").value = data.d[i].BankName;
                                     document.getElementById("PayeeX").value = data.d[i].PayeeX;
                                     document.getElementById("PayeeY").value = data.d[i].PayeeY;
                                     document.getElementById("AmountWX").value = data.d[i].AmountWX;
                                     document.getElementById("AmountWY").value = data.d[i].AmountWY;
                                     document.getElementById("AmountNX").value = data.d[i].AmountNX;
                                     document.getElementById("AmountNY").value = data.d[i].AmountNY;
                                     document.getElementById("DateX").value = data.d[i].DateX;
                                     document.getElementById("DateY").value = data.d[i].DateY;
                                     document.getElementById("CheckHeight").value = data.d[i].CheckHeight;
                                     document.getElementById("CheckWidth").value = data.d[i].CheckWidth;
                                     document.getElementById("RemarksX").value = data.d[i].RemarksX;
                                     document.getElementById("RemarksY").value = data.d[i].RemarksY;

                                     DateX = Number(DateX.value);
                                     DateY = Number(DateY.value);
                                     AmountWX = Number(AmountWX.value);
                                     AmountWY = Number(AmountWY.value);
                                     AmountNX = Number(AmountNX.value);
                                     AmountNY = Number(AmountNY.value);
                                     PayeeX = Number(PayeeX.value);
                                     PayeeY = Number(PayeeY.value);
                                     CheckHeight = Number(CheckHeight.value);
                                     CheckWidth = Number(CheckWidth.value);
                                     RemarksX = Number(RemarksX.value);
                                     RemarksY = Number(RemarksY.value);

                                     set(DateX, DateY, AmountWX, AmountWY, AmountNX, AmountNY, PayeeX, PayeeY, CheckHeight, CheckWidth, RemarksX, RemarksY);
                                 }
                             },
                             error: function (data) {
                                 setdefault();
                                 alert('No Coordinates Found, Coordinates set to default')
                             }
                         });
                     }

                     //set coordinates
                     function set(DateX, DateY, AmountWX, AmountWY, AmountNX, AmountNY, PayeeX, PayeeY, CheckHeight, CheckWidth, RemarksX, RemarksY) {
                         $("#payeespan").text(PayeeName.value);
                         $("#amountWspan").text(CheckAmountW.value);
                         $("#amountNspan").text("*"+ CheckAmount.value + "*");
                         $("#amountWspan").css({ top: AmountWY, left: AmountWX, position: 'fixed'});
                         $("#amountNspan").css({ top: AmountNY, left: AmountNX, position: 'fixed' });
                         $("#dateSpan").css({ top: DateY, left: DateX, position: 'fixed'});
                         $("#payeespan").css({ top: PayeeY, left: PayeeX, position: 'fixed' });
                         $("#remarksSpan").css({ top: RemarksY, left: RemarksX, position: 'fixed' });
                     }

                     //set default coordinates if none
                     function setdefault()
                     {
                         document.getElementById("PayeeX").value = 279;
                         document.getElementById("PayeeY").value = 9;
                         document.getElementById("AmountWX").value = 279;
                         document.getElementById("AmountWY").value = 45;
                         document.getElementById("AmountNX").value = 513;
                         document.getElementById("AmountNY").value = 147;
                         document.getElementById("DateX").value = 493;
                         document.getElementById("DateY").value = 144;
                         document.getElementById("RemarksX").value = 37;
                         document.getElementById("RemarksY").value = 10;
                     }

                     //get position
                     function getPositionXY(element,id) {
                         if (id == "payeespan") 
                         { 
                             var rect = element.getBoundingClientRect();
                             document.getElementById('gfg').innerHTML =
                             'X: ' + rect.x + ', ' + 'Y: ' + rect.y
                             document.getElementById("PayeeX").value = rect.x;
                             document.getElementById("PayeeY").value = rect.y;
                         }
                         else if (id== "amountWspan")
                         {
                             var rect = element.getBoundingClientRect();
                             document.getElementById('gfg').innerHTML =
                             'X: ' + rect.x + ', ' + 'Y: ' + rect.y
                             document.getElementById("AmountWX").value = rect.x;
                             document.getElementById("AmountWY").value = rect.y;
                         }
                         else if (id == "amountNspan") {
                             var rect = element.getBoundingClientRect();
                             document.getElementById('gfg').innerHTML =
                             'X: ' + rect.x + ', ' + 'Y: ' + rect.y
                             document.getElementById("AmountNX").value = rect.x;
                             document.getElementById("AmountNY").value = rect.y;
                         }
                         else if (id == "dateSpan") {
                             var rect = element.getBoundingClientRect();
                             document.getElementById('gfg').innerHTML =
                             'X: ' + rect.x + ', ' + 'Y: ' + rect.y
                             document.getElementById("DateX").value = rect.x;
                             document.getElementById("DateY").value = rect.y;
                         }
                         else if (id == "remarksSpan") {
                             var rect = element.getBoundingClientRect();
                             document.getElementById('gfg').innerHTML =
                             'X: ' + rect.x + ', ' + 'Y: ' + rect.y
                             document.getElementById("RemarksX").value = rect.x;
                             document.getElementById("RemarksY").value = rect.y;
                         }
                         var dateSpacing = $('#date span');
                         var currentLetterSpacing = parseInt(dateSpacing.css('letter-spacing'));
                         document.getElementById("LetterSpacing").value = currentLetterSpacing.toString();

                     }
        
                     //draggable
                     $(function () {
                         $("#payee span").draggable({
                             containment: "#container",
                             drag: function (event, ui) {
                                 $('label').html("X: " + ui.position.left + " Y : " + ui.position.top)
                             }
                         });
                         $("#amountW span").draggable({
                             containment: "#container",
                             drag: function (event, ui) {
                                 $('label').html("X: " + ui.position.left + " Y : " + ui.position.top)
                             }
                         });
                         $("#remarks span").draggable({
                             containment: "#container",
                             drag: function (event, ui) {
                                 $('label').html("X: " + ui.position.left + " Y : " + ui.position.top)
                             }
                         });
                         $("#amountN span").draggable({
                             containment: "#container",
                             drag: function (event, ui) {
                                 $('label').html("X: " + ui.position.left + " Y : " + ui.position.top)
                             }
                         });
                         $("#date span").draggable({
                             containment: "#container",
                             drag: function (event, ui) {
                                 $('label').html("X: " + ui.position.left + " Y : " + ui.position.top)
                             }
                         });
                     });

    </script>

</body>
</html>
