<%@page contentType="text/html;charset=UTF-8" language="java" %><!DOCTYPE html>

<html>
<head>
<meta HTTP-EQUIV="Content-Type" Content="text/html" charset="UTF-8">
<!--
<script type="text/javascript" language="javascript" src="//code.jquery.com/jquery-1.10.2.min.js"></script>
-->
<script type="text/javascript" language="javascript" src="//code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>

<link rel="stylesheet" href="chosen/chosen.css">
<script src="chosen/chosen.jquery.js" type="text/javascript"></script>
<script src="testGL.js"></script>

<link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css" />

<style type="text/css">
table
{ 
    width: 30%;
    height: 150px;
    -webkit-box-shadow: 1px 1px 10px 4px rgba(179,177,179,1);
    -moz-box-shadow: 1px 1px 10px 4px rgba(179,177,179,1);
    box-shadow: 1px 1px 10px 4px rgba(179,177,179,1);
    background: #F7F7F7;
    margin-left: auto;
    margin-right: auto;
}
tr td:first-child
{
    width: 40%;
    font-weight: bold;
    font-family: Cambria;
    font-size: larger;
    color: #6B9AEF;
}
input[type="text"], select
{
    width: 80%;
    height: 25px;
    border: 1px solid #999999;
    border-radius: 4px 4px 4px 4px;
    -moz-border-radius: 4px 4px 4px 4px;
    -webkit-border-radius: 4px 4px 4px 4px;
}
</style>

</head> 
<body onload="body_onload()" style="direction:rtl;">



<div style="height:50px;"> 
<select class="chosen-select" id="bkid" style="width:350px;" >
<option value=""></option>
</select>
</div>

<button id="btn"  ></button>
<div id="tblBankTrans" style="height:250px;">
<table id="GLTrans" class="display" cellspacing="0" width="100%">
<thead> 
    <tr>
        <th>חשבון</th>
        <th>סכום</th>
        <th>תאריך</th> 
        
    </tr>
</thead>
</table>
</div>
</body>
</html>