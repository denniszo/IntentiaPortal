<!DOCTYPE html>
<%@include file="Translator.jsp"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:c="http://www.intentia.com/bifrost/1.0"
      xmlns:m="http://schemas.intentia.com/bifrost/runtime-meta-data/20031114/"
      xmlns:i18n="http://schemas.intentia.com/MWP/IPM/I18N"
      xmlns:jsp="http://java.sun.com/JSP/Page">


<head lang="en">
    <meta http-equiv="X-UA-Compatible" content="IE=9">
    <META http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>קישורים</title>


    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css"/>
    <script src="//code.jquery.com/ui/1.11.0/jquery-ui.js"></script>
    <script src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
    <script src="//cdn.datatables.net/tabletools/2.2.1/js/dataTables.tableTools.min.js"></script>
    <link href="//cdn.datatables.net/tabletools/2.2.1/css/dataTables.tableTools.css" rel="stylesheet" type="text/css"/>

    <!-- Bootstrap -->
    <link href="/intentia/sors/bootstrap.min.css" rel="stylesheet"/>
    <script src="/intentia/sors/bootstrap.min.js"></script>
    <style>
        body {
            background-color: lightgray
        }

        h1 {
            color: blue
        }

        p {
            color: green
        }
    </style>
    <script type="text/javascript">
        gUSER = "";
        function loadUser() {
            // alert("a= "+gUSER);
            getCurrentUser();
            //  alert("b= "+gUSER);
            document.getElementById('usn').innerHTML=gUSER;
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

        function openLinck(url) {
            url += gUSER;
            window.open(url, "_self");

        }
    </script>
</head>
<body onload="loadUser();" align=center>
<div class="container">
    <div  class="col-md-1">er
        <h4 id="usn"></h4>
    </div>
    <div class="col-md-1">
        <button type="button" class="btn btn-link"
                onclick="openLinck('http://momsrv/ProductionM/PackPyramid.aspx?user=')">
            PackPyramid
        </button>
        <div class="col-md-1">
        </div>
        <button type="button" class="btn btn-link"
                onclick="openLinck('http://momsrv/ProductionM/InvoiceToXmlFormat.aspx?user=')">InvoiceToXmlFormat
        </button>
        <div class="col-md-1">
        </div>
        <button type="button" class="btn btn-link"
                onclick="openLinck('http://momsrv/ProductionM/DelayBatch.aspx?user=')">
            DelayBatch
        </button>
    </div>

</div>
</body>
</html>