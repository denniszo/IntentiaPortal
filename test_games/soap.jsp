<html>
<head>
    <title>example m3 soap web service with jquery</title>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            jQuery.support.cors = true;

            $("#submitBtn").click(function (event) {
                var wsUrl = "http://bangkok.intentia.co.il:19007/mws-ws/services/GetDeliveryAddressAndStatus";

                var soapRequest = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cred="http://lawson.com/ws/credentials" xmlns:get="http://your.company.net/GetDeliveryAddressAndStatus/GetBasicData">';
                soapRequest += '<soapenv:Body><get:GetBasicData><get:GetBasicDataItem>  <get:Company>334</get:Company><get:CustomerNumber>' + $("#cusno").val() + '</get:CustomerNumber>' ;
                soapRequest += '</get:GetBasicDataItem></get:GetBasicData></soapenv:Body></soapenv:Envelope>';
                $.ajax({
                    type : "POST",
                    url : wsUrl,
                    contentType : "text/xml",
                    dataType : "xml",
                    data : soapRequest,
                    success : processSuccess,
                    error : processError
                });
            });
        });

        function processSuccess(data, status, req) {
            if (status == "success") {
                var ois002 = $(req.responseText).find('GetBasicDataResponseItem');
                var response = ois002.find('Name').text() +
                                "<br />" + ois002.find('CustomerAddress1').text() +
                                "<br />" + ois002.find('CustomerAddress2').text();
                $("#response").html(response);
            }
        }

        function processError(data, status, req) {
            alert(req.responseText + " " + status);
        }
</script>
</head>
<body>
    <h3>Calling Web Services with jQuery/AJAX</h3>
    <h4>Input</h4>
    Customer Number / Address ID
    <input id="cusno" type="text" />
    <input id="addressId" type="text" />
    <input id="submitBtn" value="Submit" type="button" />
    <h4>Output</h4>
    <div id="response"/>
</body>
</html>