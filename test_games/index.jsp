<%@page contentType="text/html;charset=UTF-8" language="java" %><!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<!--
<script type="text/javascript" language="javascript" src="//code.jquery.com/jquery-1.10.2.min.js"></script>
-->
<script src="../controls/jquery/jquery-1.10.2.min.js"></script>
<script src="../controls/jquery/jquery-ui-1.10.2.custom.min.js"></script>
<script src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
<script src="../controls/jquery/jquery.json-2.2.js"></script> 
<script src="../controls/jquery/jquery.jscrollpane.min.js"></script>

<script src="test.js"></script>

<link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css" />



</head>
<body onload="body_onload()">

<!--
<table id="example"  class="display" cellspacing="0" width="100%">
<thead>
    <tr>
        <th>Name</th>
        <th>Position</th>
        <th>Office</th>
        <th>Extn.</th>
        <th>Start date</th>
        <th>Salary</th>
    </tr>
</thead>

<tfoot>
    <tr>
        <th>Name</th>
        <th>Position</th>
        <th>Office</th>
        <th>Extn.</th>
        <th>Start date</th>
        <th>Salary</th>
    </tr>
</tfoot>
</table>
-->


<table id="CustomerList" class="display" cellspacing="0" width="100%">
<thead> 
    <tr>
        <th>Customer</th>
        <th>Name</th>
        <th>Address line 1</th> 
        <th>Telephone</th>
        <th>Status</th>
    </tr>
</thead>
</table>

</body>
</html>