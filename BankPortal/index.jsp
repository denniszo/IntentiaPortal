<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
    <%@include file="Translator.jsp"%>
    <%@ include file="/sors/ServerInstace.jsp"%>

    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>פורטל בנקים H5</title>
    <script src="index.js"></script>
    <script src="objets.js"></script>
    <script src="runRecon.js"></script>
    <script src="regist.js"></script>

  <!--  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="//code.jquery.com/ui/1.11.0/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css"/> -->

    <script src="/intentia/sors/jquery-1.11.2.js"></script>
    <script src="/intentia/sors/jquery-ui.js"></script>
    <link rel="stylesheet" href="/intentia/sors/jquery-ui.css"/>


    <!-- Bootstrap -->
    <link href="/intentia/sors/bootstrap.min.css" rel="stylesheet"/>
    <script src="/intentia/sors/bootstrap.min.js"></script>

    <!--
    <script src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
    <script src="//cdn.datatables.net/tabletools/2.2.1/js/dataTables.tableTools.min.js"></script>
    <link href="//cdn.datatables.net/tabletools/2.2.1/css/dataTables.tableTools.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css"/>-->

    <script src="/intentia/sors/jquery.dataTables.min.js"></script>
    <link rel="stylesheet" type="text/css" media="screen" href="/intentia/sors/jquery.dataTables.min.css">


    <link href="/intentia/sors/bigtable.css" rel="stylesheet" type="text/css"/>

    <!-- date inbuts-->

    <link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/css/bootstrap-combined.min.css" rel="stylesheet">
    <!-- <link rel="stylesheet" type="text/css" media="screen"href="http://tarruda.github.com/bootstrap-datetimepicker/assets/css/bootstrap-datetimepicker.min.css">-->
    <link rel="stylesheet" type="text/css" media="screen" href="/intentia/sors/bootstrap-datetimepicker.min.css">
    <script src="/intentia/sors/bootstrap-datetimepicker.min.js"></script>

   <!-- <link rel="stylesheet" type="text/css" media="screen" href="/intentia/sors/bootstrap-responsive.min.css">-->

    <style>
        #tblBankTrans_length {
            display: none;
        }

        #tblGLTrans_length {
            display: none;
        }

        #Header {
            width: 100%;
            height: 100px;
            padding: 0.5em;
            border: 2px;
            border-style: solid;
            border-color: grey;
            border-radius: 8px;
            box-shadow: 2px 2px 5px #888888;
            background-color: #bfbfbf
        }

        .IPM_Lbl {
            color: #101010;
        }

        .IPM_Lbl_Dis {
            color: #989898;
        }

        .IPM_Lbl_Font {
            font-family: Verdana, Arial, Helvetica, sans-serif;
            font-size: 14px;
            font-weight: bold;
            cursor: default;
        }

        body .modal-admin {
            /* new custom width */
            width: 1200px;
            /* must be half of the width, minus scrollbar on the left (30px) */
            margin-left: -600px;
        }

        .modal-dialog {
            width: 100%;

        }
    </style>


    <script type="text/javascript">
        var gServerUSER = "<%=request.getRemoteUser()%>"; //is null in first use
        var gstrLang = "<%=strLang%>";
        var gUSER = "";
        var gCONO = "";
        var gDIVI = "";

        var gBankSum = 0;
        var gGLSum = 0;
        var chosenBkid, ChosenAit1;
        var vser, vono;
        var hidFromDate = 0;
        var hidToDate = 0;
        var dateSTART = 0; //dennis 15.11.2010
        var dateEND = 0; //dennis 15.11.2010

        var processing;


        var waitingDialog = (function ($) {

            // Creating modal dialog's DOM proses bar
            var $dialog = $(
                    '<div class="modal fade" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" ' +
                    'aria-hidden="true" style="height:170px; background:none; direction: <%=direction%>;">' +
                    '<div class="modal-dialog modal-m">' +
                    '<div class="modal-content">' +
                    '<div class="modal-header"><h3 style="margin:0;"></h3></div>' +
                    '<div class="modal-body">' +
                    '<div class="progress progress-striped active" style="margin-bottom:0;">' +
                    '<div class="progress-bar" id="proLoadBar" style="width: 100%"></div></div>' +
                    '</div>' +
                    '</div></div></div>');

            return {
                /**
                 * Opens our dialog
                 * @param message Custom message
                 * @param options Custom options:
                 *                  options.dialogSize - bootstrap postfix for dialog size, e.g. "sm", "m";
                 *                  options.progressType - bootstrap postfix for progress bar type, e.g. "success", "warning".
                 */
                show: function (message, options) {
                    // Assigning defaults
                    var settings = $.extend({
                        dialogSize: 'm',
                        progressType: ''
                    }, options);
                    if (typeof message === 'undefined') {
                        message = 'Loading';
                    }
                    if (typeof options === 'undefined') {
                        options = {};
                    }
                    // Configuring dialog
                    $dialog.find('.modal-dialog').attr('class', 'modal-dialog').addClass('modal-' + settings.dialogSize);
                    $dialog.find('.progress-bar').attr('class', 'progress-bar');
                    if (settings.progressType) {
                        $dialog.find('.progress-bar').addClass('progress-bar-' + settings.progressType);
                    }
                    $dialog.find('h3').text(message);
                    // Opening dialog
                    $dialog.modal();
                },
                /**
                 * Closes dialog
                 */
                hide: function () {
                    $dialog.modal('hide');
                }
            }

        })(jQuery);

        //-//
        var s = "<%=msg6%>";
        $(document)
                .ready(
                function () {
                    jQuery.support.cors = true;
                    getCurrentUser();
                    //  alert(gUSER);
                    //  	getCurrency();
                    lstBkid();


                    function getCurrency() {
                        console.log("getCurrency")//not in use
                        var wsUrl = "http://bangkok1.intentia.co.il:19007/mws-ws/services/SDK_Edu";

                        var soapRequest = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cred="http://lawson.com/ws/credentials" xmlns:get="http://your.company.net/SDK_Edu/LstCodesByLng">';
                        soapRequest += '<soapenv:Body><get:LstCodesByLng><get:LstCodesByLngItem>  <get:ConstantValue>CUCD</get:ConstantValue>';
                        soapRequest += '</get:LstCodesByLngItem></get:LstCodesByLng></soapenv:Body></soapenv:Envelope>';
                        $.ajax({
                            type: "POST",
                            url: wsUrl,
                            contentType: "text/xml",
                            dataType: "xml",

                            data: soapRequest,
                            success: processSuccess,
                            error: processError
                        });

                        function processSuccess(data, status, req) {

                            if (status == "success") {

                                var ois002 = $(req.responseText).find(
                                        'LstCodesByLngResponseItem');
                                $(ois002).each(
                                        function (index, el) {
                                            //  alert(el[index].find('ConstantValue').text());
                                            //alert( index + ": " + el.textContent );
                                            var Desc = el.firstChild.childNodes[0].data;
                                            var Cucd = el.childNodes[3].innerHTML;
                                            $("#sel").append(
                                                    "<option value='1'>" + Desc + "</option>");
                                            $("#selCUCD").append(
                                                    "<option value='1'>" + Cucd + "</option>");
                                            // 	alert(1);
                                        });

                                var response = "<option value='"
                                        + ois002.find('ConstantValue').text() + "'>"
                                        + ois002.find('Description').text() + "</option>";
                                // alert(response);
                                //   var x = document.getElementById("sel");
                                //   var option = document.createElement("option");
                                //   option.text =  ois002.find('ConstantValue').text() ;
                                //  x.add(option,x[0]);

                                //  $("#sel").html(response);
                            }
                        }

                        function processError(data, status, req) {
                            alert(req.responseText + " " + status);
                        }
                    }

                    function lstDivisions() { //not in use
                        var wsUrl = "http://bangkok.intentia.co.il:19007/mws-ws/services/SDK_Edu";

                        var soapRequest = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cred="http://lawson.com/ws/credentials" xmlns:get="http://your.company.net/SDK_Edu/LstCmpDivi">';
                        soapRequest += '<soapenv:Body><get:LstCmpDivi><get:LstCodesByLngItem>  <get:ConstantValue>CUCD</get:ConstantValue>';
                        soapRequest += '</get:LstCmpDiviItem></get:LstCmpDivi></soapenv:Body></soapenv:Envelope>';
                        $.ajax({
                            type: "POST",
                            url: wsUrl,
                            contentType: "text/xml",
                            dataType: "xml",
                            data: soapRequest,
                            success: processSuccess,
                            error: processError
                        });

                        function processSuccess(data, status, req) {

                            if (status == "success") {

                                var ois002 = $(req.responseText).find(
                                        'LstCodesByLngResponseItem');
                                $(ois002).each(
                                        function (index, el) {

                                            var Desc = el.firstChild.childNodes[0].data;
                                            var Cucd = el.childNodes[3].innerHTML;
                                            $("#sel").append(
                                                    "<option value='1'>" + Desc + "</option>");
                                            $("#selCUCD").append(
                                                    "<option value='1'>" + Cucd + "</option>");

                                        });

                                var response = "<option value='"
                                        + ois002.find('ConstantValue').text() + "'>"
                                        + ois002.find('Description').text() + "</option>";

                            }
                        }

                        function processError(data, status, req) {
                            alert(req.responseText + " " + status);
                        }
                    }

                    function getCurrentUser() {

                        var program = 'GENERAL';
                        var transaction = 'GetUserInfo';
                        var maxrecs = 100;
                        var returncols = 'ZZUSID,ZDCONO,ZDDIVI';

                        var inputFields;// = 'CONO=790&CUNO=9000';
                        // construct the URL
                        var url = '../../m3api-rest/execute/' + program + '/' + transaction
                                + ';maxrecs=' + maxrecs + ';returncols=' + returncols + '?'
                                + inputFields;
                        var arr = returncols.split(',');
                        var columns = [];
                        for (var i in arr) {
                            columns[i] = {
                                "data": arr[i]
                            };
                            // alert("data:" + arr[i]);
                        }
                        var selectedRows = [];

                        $.ajax({
                            cache: false,
                            async: false,
                            "url": url,
                            /*
                             "dataSrc": function (json) {
                             var result = [];

                             for (var i in json.MIRecord) {
                             var record = {};
                             // alert(json.MIRecord[i].NameValue);
                             json.MIRecord[i].NameValue.map(function(o){ record[o.Name] = o.Value; });
                             //   alert(record[0].value);
                             //  var arr = [ "Name=CUNO", "Value=9000"];
                             console.log(record["ZZUSID"]);
                             result[i] =record;

                             }

                             return result;
                             },
                             */
                            success: processSuccess,
                            error: processError
                        });

                        function processSuccess(data, status, req) {

                            if (status == "success") {

                                var MIRecord = $(req.responseText).find('MIRecord');
                                var NameValue = $(MIRecord).find('NameValue');
                                var val1 = $(NameValue).find('Value');
                                $(val1).each(function (index, ell) {
                                    var nm = NameValue[index].firstChild.childNodes[0].data;
                                    var vl = ell.firstChild.data;
                                    if (nm == "ZZUSID")
                                        gUSER = vl;
                                    if (nm == "ZDCONO") {
                                        gCONO = vl;
                                        document.getElementById("inpCONO").value = gCONO;
                                    }
                                    if (nm == "ZDDIVI") {
                                        gDIVI = vl;
                                        document.getElementById("inpDIVI").value = gDIVI;
                                    }
                                    // alert(NameValue[index].firstChild.childNodes[0].data);
                                    //	alert(ell.firstChild.data);

                                });
                            }
                        }

                        function processError(data, status, req) {
                            alert(req.responseText + " >> " + status);
                        }
                    }


                    $(function () {
                        //   $( "#resizable" ).resizable();
                    });

                    $(".IPM_Lbl").disableSelection();


                    // prossesin bar inithilise
                    // processing=pageContext.getComponentById("pleaseWaitDialog");


                    //ApiTest();


                });


        $(function () {
            $("#dlgREGIST").load("dlgREGIST.jsp");
        });

        //outside body obload /document redy

        function lstBkid() {
            //alert(gstrLang)
            // construct the URL
            url = "Queries/sqlGetBkid.jsp?params=cono;" + gCONO + ";divi;" + gDIVI;

            $.ajax({
                "url": url,

                success: processSuccess,
                error: processError
            });

            function processSuccess(data, status, req) {

                if (status == "success") {
                    //	alert(req.responseText);

                    var obj = $.parseJSON(req.responseText);
                    // $('#results').html('Plugin name: ' + obj.MIRecord.NameValue );
                    // var MIRecord = $(obj).find('MIRecord');
                    $.each(obj, function (idx, el) {
                        if (idx == "MIRecord") {
                            // alert(el[0].NameValue[0].Name);
                            var elID = "";
                            var elDESC = "";
                            var elAIT1 = "";
                            for (var i = 0; i < el.length; i++) {
                                for (var j = 0; j < el[i].NameValue.length; j++) {
                                    if (el[i].NameValue[j].Name == "BCBKID") {
                                        elID = el[i].NameValue[j].Value;

                                    }
                                    if (el[i].NameValue[j].Name == "BKIDNAME") {
                                        elDESC = el[i].NameValue[j].Value;

                                    }
                                    if (el[i].NameValue[j].Name == "BCAIT1") {
                                        elAIT1 = el[i].NameValue[j].Value;

                                    }

                                }
                                $("#selBKIDdesc").append(
                                        "<option value='" + elID + "," + elAIT1 + "'>"
                                        + elDESC + "</option>");
                                $("#ddlBkid").append(
                                        "<option value='" + elID + "'>" + elID
                                        + "</option>");
                                // var id= el[i].NameValue[0].Value;
                                // selBKIDdesc
                                // alert(el[i].NameValue[0].Name + " = " + el[i].NameValue[0].Value);
                            }

                        }
                    });

                    // alert( obj.MIRecord.NameValue.Name === "John" );
                    // var MIRecord = $(obj).find('MIRecord');
                    // var NameValue = $(MIRecord).find('NameValue');
                    // var val1 = $(NameValue).find('Name');
                    //  $(NameValue).each(function(index, ell) {
                    //   alert(index);
                    // var nm=NameValue[index].firstChild.childNodes[0].data;
                    //  alert(nm);
                    //  });
                    /*

                     var NameValue = $(MIRecord).find('NameValue');
                     var val1 = $(NameValue).find('Value');
                     $(val1).each(function(index, ell) {
                     var nm=NameValue[index].firstChild.childNodes[0].data;
                     var vl=ell.firstChild.data;
                     if(nm=="ZZUSID") gUSER=vl;
                     if(nm=="ZDCONO") gCONO=vl;
                     if(nm=="ZDDIVI") gDIVI=vl;
                     // alert(NameValue[index].firstChild.childNodes[0].data);
                     //	alert(ell.firstChild.data);

                     });

                     */
                }
            }

            function processError(data, status, req) {
                alert(req.responseText + " " + status);
            }

            if ("<%=NewRecon%>" == "1") {
                console.log("set date to limet");
                getDateLimet();
            } else {
                console.log("no date to limet");
            }


        }

        function selChanged() {
            var cucdSelectedIndex = $("#sel option:selected").prevAll().size();
            var cucd = $("#selCUCD option:eq(" + cucdSelectedIndex + ")").text();
            alert(cucd);

        }

        function msover(e) {
            if (e.className == "IPM_Btn")
                e.className = "IPM_Btn_Hvr";
            //alert(e.value);
        }

        function msout(e) {
            if (e.className == "IPM_Btn_Hvr")
                e.className = "IPM_Btn";
            //alert(e.value);
        }

        function sbClick() {
            alert(gUSER);
        }
        function ddlTypeChanged() {
            if ($("#ddlType").val() == 1) {
                $("#btnCommit").html("<%=btnCommit%>");
            } else {
                $("#btnCommit").html("<%=btnCancel%>");
            }
        }

    </script>
</head>
<body style="margin: 0px; ">
<div id="Header" style="direction: <%=direction%>;">

    <table width="100%" border="0" cellspacing="0" cellpadding="2px">
        <tr>
            <!--
        <td width="10%">
            <label id="lblDivision" class="IPM_Lbl IPM_Lbl_Font" >חטיבה:</label>

            </td>
            <td width="20%">
                <select id="selDIVIdesc" onchange="diviChanged()" />
                <select id="selDIVI" />
            </td>
        -->
            <td>
                <table>
                    <tr>
                        <td><label id="lblAccount"
                                   class="IPM_Lbl IPM_Lbl_Font"><%=lblAccount%></label>
                        </td>
                        <td>
                            <div>
                                <select id="selBKIDdesc"/>
                                <select id="ddlBkid" style="visibility: hidden;"/>
                            </div>
                        </td>
                        <td width="80px"></td>
                        <td width="10px" style="visibility: visible;">
                            <label id="lblSort" class="IPM_Lbl IPM_Lbl_Font"><%=lblSort%></label>
                        </td>
                        <td style="visibility: visible;">
                            <div style="visibility: visible;width: 100px;">
                                <select id="ddlOrder">
                                    <option value="BDCURD,ABS(BDBLAM);TRDATE,ABS(FG.EGCUAM)"><%=selDateAmunt%></option>
                                    <option value="ABS(BDBLAM),BDCURD;ABS(FG.EGCUAM),TRDATE"><%=selAmuntDate%></option>
                                    <option value="BDCKNO;CHKNO"><%=selReference%></option>
                                    <option value="BDVONO;SUBSTRING(FX1.EGGEXI,4,8)"><%=selNoReference%></option>
                                </select>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
            <!--  <td>
                <table>
                    <tr>
                        <td width="1%" style="visibility: visible;"><label id="lblSort"
                                                                           class="IPM_Lbl IPM_Lbl_Font"><%=lblSort%></label></td>
                        <td width="1%" style="visibility: visible;">
                            <div style="visibility: visible;width: 100px;">
                                <select id="ddlOrder">
                                    <option value="BDCURD,ABS(BDBLAM);TRDATE,ABS(FG.EGCUAM)"><%=selAmuntDate%></option>
                                    <option value="ABS(BDBLAM),BDCURD;ABS(FG.EGCUAM),TRDATE"><%=selDateAmunt%></option>
                                    <option value="BDCKNO;CHKNO"><%=selReference%></option>
                                    <option value="BDVONO;SUBSTRING(FX1.EGGEXI,4,8)"><%=selNoReference%></option>
                                </select>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>-->
            <td>
                <table>
                    <tr>
                        <td><label id="lblTransType"
                                   class="IPM_Lbl IPM_Lbl_Font"><%=lblMovType%></label></td>
                        <td>
                            <div style="width: 100px;">
                                <select id="ddlType" onchange="ddlTypeChanged(); $('#inpFrom').val('');">
                                    <option value="1"><%=lblOpened%></option>
                                    <option value="2"><%=lblClosed%></option>
                                </select>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>


            <!--buttons -->
            <td>
                <button type="button" class="btn btn-info" style="width: 100px"
                        onmouseover="msover(this)" onmouseout="msout(this)"
                        onclick="btnShowRecon()"><%=btnShow%>
                </button>
            </td>
            <td>
                <button type="button" style="width: 100px" class="btn btn-success" id="btnChangeComDiv" data-toggle="modal"
                        data-target="#mdChange_CmpDivi"><%=btnChangeComDiv%>
                </button>
            </td>


        </tr>
        <tr>
            <td colspan="1" width="50%">
                <table>
                    <tr>
                        <td>
                            <label id="lblFromDate" class="IPM_Lbl IPM_Lbl_Font"><%=lblFromDate%></label>
                        </td>
                        <td>
                            <div id="datetimepicker_From" class="form-control" style="background-color: #dfdfdf">
                                <input data-format="dd/MM/yyyy" type="text" id="dateInpFrom" placeholder="dd/mm/yyyy">
						<span class="add-on">
						  <i data-time-icon="icon-time" data-date-icon="icon-calendar">
                          </i>
						</span>
                            </div>
                            <script type="text/javascript">
                                $(function () {
                                    $('#datetimepicker_From').datetimepicker({
                                        pickTime: false
                                    });
                                });
                            </script>
                        </td>
                        <td>
                            <label id="lblToDate" class="IPM_Lbl IPM_Lbl_Font"><%=lblToDate%></label>
                        </td>
                        <td>
                            <div id="datetimepicker_To" class="form-control" style="background-color: #dfdfdf">
                                <input data-format="dd/MM/yyyy" type="text" id="dateInpTo" placeholder="dd/mm/yyyy">
						<span class="add-on">
						  <i data-time-icon="icon-time" data-date-icon="icon-calendar">
                          </i>
						</span>
                            </div>
                            <script type="text/javascript">
                                $(function () {
                                    $('#datetimepicker_To').datetimepicker({
                                        pickTime: false
                                    });
                                });
                            </script>
                        </td>
                    </tr>
                </table>
            </td>


            <td>
                <table>
                    <tr>
                        <td>
                            <select id="ddlFrom" class="dropdown" onchange="$('#inpFrom').val('');">
                                <option value="BDCURD;CASE WHEN FB.EGCURD IS NULL THEN FG.EGOCDT ELSE FB.EGCURD END">
                                    <%=str_date%>
                                </option>
                                <!-- <option value="ABS(BDBLAM);ABS(FG.EGCUAM)"><%=str_amount%></option>-->
                                <option value="ABS(BDBLAM);ABS(FG.EGCUAM)"><%=str_amount%></option>
                                <option value="BDCKNO;FX2.EGGEXI"><%=str_reference%></option>
                                <option value="BDVONO;LTRIM(SUBSTRING(FX1.EGGEXI,4,8))"><%=str_ReconNo%></option>
                            </select>
                        </td>
                        <td>-</td>
                        <td>
                            <input type="test" class="form-control" id="inpFrom" placeholder=""
                                   required="" onkeypress="if (window.event.keyCode==13) {(btnShowRecon());}"/>
                        </td>
                    </tr>
                </table>
            </td>

            <!-- buttons -->
            <td colspan="1">
                <% if(NewRecon.equals("1")){ %>
                <button type="button" style="width: 100px" class="btn btn-warning" onclick="btnRedistRec();"
                        id="btnReg"><%=Registration%>
                </button>
                <%}%>
            </td>
            <td>
                <button type="button" style="width: 100px" class="btn btn-info" id="btnCommit"
                        onclick="btnDoRecon()"><%=btnCommit%>
                </button>
            </td>

        </tr>
    </table>


    <!--
<select id="sel" onchange="selChanged()" />

<select id="selCUCD" style="visibility:hidden;"/>
-->
</div>

<!-- tables -->
<div style="margin: 15px; direction: <%=direction%>;">
    <table width="100%" border="0" cellspacing="0" cellpadding="2px">
        <tr>
            <td valign="top">
                <div style="width: 100%; height: 300px;">
                    <table id="tblBankTrans" class="display" cellspacing="0" onclick="selBankTran()"
                           width="90%">
                        <thead>
                        <tr>

                            <%if(strLang.equals("IL")){ %>
                            <th class="BDCURD" style="text-align: right">ת.תנועה</th>
                            <th class="BDBLAM" style="text-align: right">סכום תנועה</th>
                            <th class="BDCKNO" style="text-align: right">אסמכתא</th>
                            <th class="PAGENO" style="text-align: right">מס. דף</th>
                            <th class="BDALLN" style="text-align: right">מס. שורה</th>
                            <th class="BDRFFD" style="text-align: right">מלל</th>
                            <th class="BDLMDT" style="text-align: right">ת.התאמה</th>
                            <th class="BDVONO" style="text-align: right">מס. התאמה</th>
                            <%}else{ %>
                            <th class="BDCURD">Trn Date</th>
                            <th class="BDBLAM">Trn Sum</th>
                            <th class="BDCKNO">Reference</th>
                            <th class="PAGENO">Page No.</th>
                            <th class="BDALLN">Line No.</th>
                            <th class="BDRFFD">Description</th>
                            <th class="BDLMDT">Recon Date</th>
                            <th class="BDVONO">Recon No.</th>
                            <%} %>
                            <th style="visibility: hidden;" class="BDSDRC"></th>
                            <th style="visibility: hidden;" class="BDBKID"></th>
                            <th style="visibility: hidden;" class="BDVSER"></th>
                        </tr>
                        </thead>
                    </table>

                </div>
            </td>
        </tr>
    </table>
    <table>
        <tr style=" background-color: #ffff00">
            <td><label id="lblSumBank" class="IPM_Lbl IPM_Lbl_Font"><%=sumBank%></label></td>
            <td dir='ltr'><label id="lblTXTSumBank"
                                 class="IPM_Lbl IPM_Lbl_Font"></label></td>
        </tr>
    </table>
</div>


<div style="margin: 3px; direction: <%=direction%>;">

    <table width="100%" border="0" cellspacing="0" cellpadding="2px">

        <tr>
            <td valign="top">
                <div style="width: 100%; height: 300px;">

                    <table id="tblGLTrans" class="display" cellspacing="0"
                           width="100%" onclick="selGlTable()">

                        <thead>
                        <tr>
                            <%if(strLang.equals("IL")){ %>
                            <th class="TRDATE" style="text-align: right">ת.תנועה</th>
                            <th class="EGCUAM" style="text-align: right">סכום תנועה</th>
                            <th class="CHKNO" style="text-align: right">אסמכתא</th>
                            <th class="EGJRNO" style="text-align: right">מס. פקודת יומן</th>
                            <th class="SHOVAR" style="text-align: right">מס. שובר</th>
                            <th class="EGJSNO" style="text-align: right">מס. שורה</th>
                            <th class="EGVTXT" style="text-align: right">מלל</th>
                            <th class="EGERDT" style="text-align: right">ת.התאמה</th>
                            <th class="RECNO" style="text-align: right">מס. התאמה</th>
                            <%}else{ %>
                            <th class="TRDATE">Trn Date</th>
                            <th class="EGCUAM">Trn Sum</th>
                            <th class="CHKNO">Reference</th>
                            <th class="EGJRNO">No.Entry Runn Accoun</th>
                            <th class="SHOVAR">Voucher No.</th>
                            <th class="EGJSNO">Line No.</th>
                            <th class="EGVTXT">Description</th>
                            <th class="EGERDT">Recon Date</th>
                            <th class="RECNO">Recon No.</th>
                            <%} %>
                            <th style="visibility: hidden;" class="VSER"></th>
                        </tr>
                        </thead>
                    </table>


                </div>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" cellspacing="0" cellpadding="2px">
        <tr>

            <td>
                <table border="0">
                    <tr>
                        <td style="<%=direction%>ection: <%=direction%>; background-color: #ffff00"><label id="lblSumGL"
                                                                                                           class="IPM_Lbl IPM_Lbl_Font"><%=sumGL%></label>
                        </td>
                        <td style="direction: ltr; background-color: #ffff00 "><label id="lblTXTSumGL"
                                                                                      class="IPM_Lbl IPM_Lbl_Font"></label>
                        </td>

                        <td width="50px"></td>

                        <td style="<%=direction%>ection: <%=direction%>; background-color:#1385e5"><label
                                id="lblTXTSumALL"
                                class="IPM_Lbl IPM_Lbl_Font"><%=sumALL%></label>
                        </td>
                        <td style="direction: ltr; background-color:#1385e5 "><label id="lblSumALL"
                                                                                     class="IPM_Lbl IPM_Lbl_Font"></label>
                        </td>
                    </tr>
                </table>
            </td>
            <!--
                        <td style="direction: <%=direction%>;">
                            <table border="0">
                                <tr>
                                    <td style="<%=direction%>ection: <%=direction%>;"><label id="lblTXTSumALL"
                                                                                  class="IPM_Lbl IPM_Lbl_Font"></label><%=sumALL%></td>
                                    <td style="direction: ltr;"><label id="lblSumALL"
                                                                       class="IPM_Lbl IPM_Lbl_Font"></label></td>
                                </tr>
                            </table>
                        </td>
                        -->
        </tr>
        <tr>
            <!--
    <td width="15%"><c:button id="btnClose" visible="true" label="סגור" onclick="javascript:CloseIbrix();"></c:button></td>
    <td align="center" style="HeadLarge;color:blue;font-size:20px" id="lblSts"></td>
            -->

        </tr>
    </table>

    <!-- Modal Change_Cmp Divi-->
    <div class="modal fade" id="mdChange_CmpDivi" tabindex="-1" role="dialog" aria-labelledby="arChange_CmpDivi"
         aria-hidden="true" style="height:400px; background:none; direction: <%=direction%>;">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="Label"><%=btnChangeComDiv%></h4>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="form-group">
                            <label for="inpCONO" class="control-label"><%=str_Compony%></label>
                            <input type="test" style="width: 20%; " maxlength="3" class="form-control" id="inpCONO"
                                   placeholder="" required=""
                                   onkeypress="if (window.event.keyCode==13) {ChangeComDiv();}"/>
                        </div>
                        <div class="form-group">
                            <label for="inpDIVI" class="control-label"><%=str_Divi%></label>
                            <input type="test" class="form-control" maxlength="3" style="width: 20%; " id="inpDIVI"
                                   placeholder="" required=""
                                   onkeypress="if (window.event.keyCode==13) {ChangeComDiv();}"/>
                        </div>
                        <div class="form-group">
                            <label for="inpDIVI" class="control-label"><%=str_Divi%></label>
                            <select class="selectpicker" id="selCONO">
                                <option value="100">Mustard</option>
                                <option value="200">Ketchup</option>
                                <option value="300">Relish</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" style="width: 100px" class="btn btn-default" data-dismiss="modal"><%=str_Cansel%></button>
                    <button type="button" style="width: 100px" class="btn btn-primary" onclick="ChangeComDiv();"><%=str_Change%></button>

                    <button type="button" style="width: 100px" class="btn btn-primary" onclick="test();">בדיקה</button>
                </div>
            </div>
        </div>
    </div>
    <!-- modal dialog mesege -->

</div>


<!-- go to dlgREGIST-->
<div id="dlgREGIST"></div>

</body>
</html>