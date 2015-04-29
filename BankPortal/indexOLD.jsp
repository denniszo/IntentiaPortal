<%@include file="Translator.jsp"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:c="http://www.intentia.com/bifrost/1.0"
      xmlns:m="http://schemas.intentia.com/bifrost/runtime-meta-data/20031114/"
      xmlns:i18n="http://schemas.intentia.com/MWP/IPM/I18N"
      xmlns:jsp="http://java.sun.com/JSP/Page">

<head>


<meta http-equiv="X-UA-Compatible" content="IE=9">
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>פורטל בנקים H5</title>
<script src="index.js"></script>
<script src="objets.js"></script>
<script src="runRecon.js"></script>
<script src="regist.js"></script>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css"/>
<script src="//code.jquery.com/ui/1.11.0/jquery-ui.js"></script>
<script src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
<script src="//cdn.datatables.net/tabletools/2.2.1/js/dataTables.tableTools.min.js"></script>
<link href="//cdn.datatables.net/tabletools/2.2.1/css/dataTables.tableTools.css" rel="stylesheet" type="text/css"/>

<!-- Bootstrap -->
<link href="/intentia/sors/bootstrap.min.css" rel="stylesheet"/>
<script src="/intentia/sors/bootstrap.min.js"></script>

<!-- date inbuts-->
<link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/css/bootstrap-combined.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" media="screen"
      href="http://tarruda.github.com/bootstrap-datetimepicker/assets/css/bootstrap-datetimepicker.min.css">
<script src="/intentia/sors/bootstrap-datetimepicker.min.js"></script>

<style>
    #Header {
        width: 95%;
        height: 100px;
        padding: 0.5em;
        border: 2px;
        border-style: solid;
        border-color: grey;
        border-radius: 8px;
        box-shadow: 2px 2px 5px #888888;
    }

    .IPM_Lbl {
        color: #101010;
    }

    .IPM_Lbl_Dis {
        color: #989898;
    }

    .IPM_Lbl_Font {
        font-family: Verdana, Arial, Helvetica, sans-serif;
        font-size: 11px;
        cursor: default;
    }
</style>


<link href="/intentia/bigtable.css" rel="stylesheet" type="text/css"/>

<link rel="stylesheet" type="text/css"
      href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css"/>

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
var hidFromDate=0;
var hidToDate=0;
var dateSTART=0; //dennis 15.11.2010
var dateEND=0; //dennis 15.11.2010

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
                var wsUrl = "http://bangkok.intentia.co.il:19007/mws-ws/services/SDK_Edu";

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

            function lstDivisions() {
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
                            if (nm == "ZDCONO")
                                gCONO = vl;
                            if (nm == "ZDDIVI")
                                gDIVI = vl;
                            // alert(NameValue[index].firstChild.childNodes[0].data);
                            //	alert(ell.firstChild.data);

                        });
                    }
                }

                function processError(data, status, req) {
                    alert(req.responseText + " " + status);
                }
            }

            function lstBkid() {
                //alert(gstrLang)
                // construct the URL
                url = "sqlGetBkid.jsp?params=cono;" + gCONO + ";divi;" + gDIVI;

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


                getDateLimet();

            }

            $(function () {
                //   $( "#resizable" ).resizable();
            });

            $(".IPM_Lbl").disableSelection();


            //ApiTest();

        });


$(function() {
    $("#dlgREGIST").load("dlgREGIST.html");
});

//outside body obload
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
</script>
</head>
<body style="margin: 0px; ">
<div id="Header" style="direction: <%=direction%>;" >
    <table width="100%"  border="1" cellspacing="0" cellpadding="2px">
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
            <td width="10%"><label id="lblAccount"
                                   class="IPM_Lbl IPM_Lbl_Font"><%=lblAccount%></label></td>
            <td width="20%">
                <div style="width: 170px;">
                    <select id="selBKIDdesc"/> <select id="ddlBkid"
                                                       style="visibility: hidden;"/>
                </div>
            </td>
<!--
            <td width="1%" style="visibility: hidden;"><label id="lblSort"
                                                               class="IPM_Lbl IPM_Lbl_Font"><%=lblSort%></label></td>
            <td width="1%" style="visibility: hidden;">
                <div style="visibility: hidden;width: 100px;">
                    <select id="ddlOrder">
                        <option value="BDCURD,ABS(BDBLAM);TRDATE,ABS(FG.EGCUAM)"><%=selAmuntDate%></option>
                        <option value="ABS(BDBLAM),BDCURD;ABS(FG.EGCUAM),TRDATE"><%=selDateAmunt%></option>
                        <option value="BDCKNO;CHKNO"><%=selReference%></option>
                        <option value="BDVONO;SUBSTRING(FX1.EGGEXI,4,8)"><%=selNoReference%></option>
                    </select>
                </div>
            </td>

-->
            <td width="15%">
                <table>
                    <td width="15%"><label id="lblTransType"
                                           class="IPM_Lbl IPM_Lbl_Font"><%=lblMovType%></label></td>
                    <td width="15%">
                        <div style="width: 100px;">
                            <select id="ddlType">
                                <option value="1"><%=lblOpened%></option>
                                <option value="2"><%=lblClosed%></option>
                            </select>
                        </div>
                    </td>
                </table>
            </td>

            <td width="7%">
                <input type="button" class="btn btn-info"
                       onmouseover="msover(this)" onmouseout="msout(this)" value=<%=btnShow%>
                onclick="btnShowRecon()" />
            </td>
            <td width="7%">
                <input type="button" class="btn btn-info" id="btnCommit"
                       value=<%=btnCommit%> onclick="btnDoRecon()" />
            </td>


        </tr>
        <tr>
            <td colspan="4">
                <table>
                    <td>
                        <label id="lblFromDate" class="IPM_Lbl IPM_Lbl_Font"><%=lblFromDate%></label>
                    </td>
                    <td>
                        <div id="datetimepicker_From" class="form-control">
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
                        <div id="datetimepicker_To" class="form-control">
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
                </table>
            </td>

            <!-- -->

            <td colspan="2">
                <table>
                    <td>
                        <select id="ddlFrom" class="form-control">
                            <option value="BDCURD;CASE WHEN FB.EGCURD IS NULL THEN FG.EGOCDT ELSE FB.EGCURD END"><%=str_date%></option>
                            <option value="ABS(BDBLAM);ABS(FG.EGCUAM)"><%=str_amount%></option>
                            <option value="BDCKNO;FX2.EGGEXI"><%=str_reference%></option>
                            <option value="BDVONO;LTRIM(SUBSTRING(FX1.EGGEXI,4,8))"><%=str_ReconNo%></option>
                        </select>
                    </td>
                    <td>-</td>
                    <td>
                        <input type="test" class="form-control" id="inpFrom" placeholder=""
                               required="">
                    </td>
                </table>
            </td>

            <td colspan="2">
                <input type="button" class="btn btn-warning btn-lg" onclick="btnRedistRec();"
                       id="btnReg"  value=<%=Registration%>  />
            </td>

        </tr>
    </table>


    <!--
<select id="sel" onchange="selChanged()" />

<select id="selCUCD" style="visibility:hidden;"/>
-->
</div>

<!-- tables -->
<div style="margin: 10px; direction: <%=direction%>;">
    <table width="100%" border="0" cellspacing="0" cellpadding="2px">
        <tr>
            <td valign="top">
                <div style="width: 100%; height: 250px;">
                    <table id="tblBankTrans" class="display" cellspacing="0"
                           width="100%">
                        <thead>
                        <tr>

                            <%if(strLang.equals("IL")){ %>
                            <th class="BDCURD">ת.תנועה</th>
                            <th class="BDBLAM">סכום תנועה</th>
                            <th class="BDCKNO">אסמכתא</th>
                            <th class="PAGENO">מס. דף</th>
                            <th class="BDALLN">מס. שורה</th>
                            <th class="BDRFFD">מלל</th>
                            <th class="BDLMDT">ת.התאמה</th>
                            <th class="BDVONO">מס. התאמה</th>
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
        <tr>
            <td><label id="lblSumBank" class="IPM_Lbl IPM_Lbl_Font"><%=sumBank%></label></td>
            <td dir='ltr'><label id="lblTXTSumBank"
                                 class="IPM_Lbl IPM_Lbl_Font"></label></td>
        </tr>
    </table>
</div>


<div style="margin: 10px;">

    <table width="100%" border="0" cellspacing="0" cellpadding="2px">

        <tr>
            <td valign="top">
                <div style="width: 100%; height: 250px;">

                    <table id="tblGLTrans" class="display" cellspacing="0"
                           width="100%">

                        <thead>
                        <tr>
                            <%if(strLang.equals("IL")){ %>
                            <th class="TRDATE">ת.תנועה</th>
                            <th class="EGCUAM">סכום תנועה</th>
                            <th class="CHKNO">אסמכתא</th>
                            <th class="EGJRNO">מס. פקודת יומן</th>
                            <th class="SHOVAR">מס. שובר</th>
                            <th class="EGJSNO">מס. שורה</th>
                            <th class="EGVTXT">מלל</th>
                            <th class="EGERDT">ת.התאמה</th>
                            <th class="RECNO">מס. התאמה</th>
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
                    <td style="<%=direction%>ection: <%=direction%>;"><label id="lblSumGL"
                                                                             class="IPM_Lbl IPM_Lbl_Font"><%=sumGL%></label>
                    </td>
                    <td style="direction: ltr;"><label id="lblTXTSumGL"
                                                       class="IPM_Lbl IPM_Lbl_Font"></label></td>
                </table>
            </td>

            <td style="direction: <%=direction%>;">
                <table border="0">
                    <td style="direction: <%=direction%>;"><label id="lblTXTSumALL"
                                                                  class="IPM_Lbl IPM_Lbl_Font"></label></td>
                    <td style="direction: ltr;"><label id="lblSumALL"
                                                       class="IPM_Lbl IPM_Lbl_Font"></label></td>
                </table>
            </td>
        </tr>
        <tr>
            <!--
    <td width="15%"><c:button id="btnClose" visible="true" label="סגור" onclick="javascript:CloseIbrix();"></c:button></td>
    <td align="center" style="HeadLarge;color:blue;font-size:20px" id="lblSts"></td>
            -->

        </tr>
    </table>

    <div id="dlgREGIST" stile="width=500px;"/>
</body>
</html>