<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="//code.jquery.com/ui/1.11.0/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css"/>
    <%@page import="java.io.*"%>
    <%@page import="java.sql.*"%>
    <%@ include file="/sors/ServerInstace.jsp"%>
    <%
    String ServerUser=request.getRemoteUser();
    String prog=request.getParameter("prog");
    if(prog==null) prog="";
    String code=request.getParameter("code");
    if(code==null) code="";
    %>
    <style type="text/css">
        #mydiv {
            position: fixed;
            top: 50%;
            left: 50%;
            /* bring your own prefixes */
            transform: translate(-50%, -50%);
        }

    </style>
    <title>פורטל בנקים H5</title>
    <script type="text/javascript">
        //http://rome.intentia.co.il/mwp/ibrix/CHR_DOC-1.0.0/index.ibrix?prog=DRS100&code=1000002
        //http://bangkok.intentia.co.il:19007/intentia/CHR_DOC/index.jsp?prog=DRS100&code=1000002
        var gServerUSER = "<%=ServerUser%>"; //is null in first use
        var prog = "<%=prog%>";
        var code = "<%=code%>";
        var Fils =[];
        var gUSER = "";
        var gCONO = "";
        var barcod = "";
        $(document).ready(
                function () {
                    // alert("prog="+prog+" code="+code);
                    if (prog == "" || code == "") {
                        top.alert("No Barcode");
                        window.close();
                        return;
                    }
                    getCurrentUser();
                    //alert(gUSER);

                    getFileFromDB(prog + "" + gCONO + "" + code);
                    initResolt();

                }
        )

        function getFileFromDB(barcod) {
            url = "sqlGetFileList.jsp?barcod=" + barcod ;
            $.ajax({
                "url": url,
                success: processSuccess,
                error: processError,
                async:false
            });
            function processSuccess(data, status, req) {
                if (status == "success") {
                    var obj = $.parseJSON(req.responseText);
                    $.each(obj, function (idx, el) {
                        if (idx == "MIRecord") {
                            for (var i = 0; i < el.length; i++) {
                                for (var j = 0; j < el[i].NameValue.length; j++) {
                                    if (el[i].NameValue[j].Name == "RCAFNM") {
                                        Fils.push(el[i].NameValue[j].Value);
                                    }

                                    if (el[i].NameValue[j].Name == "RCBCDE") {
                                        var par = el[i].NameValue[j].Value;
                                    }
                                }
                            }
                        }
                    });
                }
            }

            function processError(data, status, req) {
                alert(req.responseText + " " + status);
            }

        }

        function initResolt() {
            //alert(Fils.length);
            if (Fils.length > 1) {
                var table = document.getElementById("tblBarc");
                for (var i = 0; i < Fils.length; i++) {
                    var row = table.insertRow();
                    var cell1 = row.insertCell(0);
                    cell1.innerHTML = "<a href='file:" + Fils[i] + "'>" + Fils[i] + "</a>";
                }
            } else {
                if (Fils.length == 1) {
                    window.open("file:" + Fils[0], '_self', false);
                } else {
                    top.alert("No files exist");
                    window.close();
                }
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
                        if (nm == "ZDCONO") {
                            gCONO = vl;
                        }
                    });
                }
            }

            function processError(data, status, req) {
                alert(req.responseText + " " + status);
            }
        }
    </script>
</head>
<body>
<div id="mydiv">
    <table id="tblBarc">

    </table>
</div>
</body>
</html>