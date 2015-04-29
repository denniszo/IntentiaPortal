/**
 * Created by denniszo on 20/01/2015.
 */

function onload() {

    //window.open('ErrorReport/Server_Error_Report_UUID_18bd4c22-db32-4802-8aa1-04a910756958_1423655999548_0.html')

    var mes=$('#selNames').select().val();
    var hh = $('#hourse').val();

   // console.log("mes= "+mes);
   //console.log(hh);
    getErrorsLine(hh,mes);

    window.setTimeout("autoReload()", 10000);
}

function autoReload() {
    window.setTimeout("reloadTabele()", 180000);//5 min
}

function reloadTabele() {
    var mes=$('#selNames').select().val();
    var hh = $('#hourse').val();
    console.log(hh);

    if(isNaN(hh)){
       return;
    }

    if(hh<1){
        return;
    }

    $('#tblLines').empty();
    $('#tblLines').append("" +
    "<tr> "+
    "<th style='text-align: right'>שעה</th> "+
    "<th style='text-align: right'>שם ממשק</th> "+
    "<th style='text-align: right'>הערות</th> "+
    "<th style='text-align: right'>פתח שגיאה</th> "+
    "</tr>");

    getErrorsLine(hh,mes);

    window.setTimeout("autoReload()", 10000);
}

function getErrorsLine(hh,mes) {
    //var url = "listErrorLines.jsp?hh="+hh;
    var url = "listError.jsp?hh=" + hh +"&mes="+mes;
    console.log("start");
    $.ajax({
        cache: false,
        async: false,
        "url": url,
        type: 'GET',
        contentType: 'application/json',
        dataType: 'json',
        success: processSuccess,
        error: processError
    });

    function processSuccess(data, status, req) {
        if (status == "success") {
            var obj = $.parseJSON(req.responseText);
            $.each(obj, function (idx, el) {
                if (idx != "MIRecord") {
                } else {
                    var agreement = "";
                    var log_time = "";
                    var uuid = "";
                    var state = "";
                    var log_file = "";
                    var Text1="";

                    var classTo_TR='';
                    var disOfButton='';

                    var etr = 0;
                    for (var i = 0; i < el.length; i++) {
                        console.log(el[i].RowIndex);
                        for (var j = 0; j < el[i].NameValue.length; j++) {
                            if (el[i].NameValue[j].Name == "agreement") {
                                agreement = el[i].NameValue[j].Value;
                            }
                            if (el[i].NameValue[j].Name == "log_time") {
                                log_time = el[i].NameValue[j].Value;
                            }
                            if (el[i].NameValue[j].Name == "uuid") {
                                uuid = el[i].NameValue[j].Value;
                            }
                            if (el[i].NameValue[j].Name == "state") {
                                state = el[i].NameValue[j].Value;
                            }
                            if (el[i].NameValue[j].Name == "Text1") {
                                Text1 = el[i].NameValue[j].Value;
                                if(Text1.length>1){
                                    classTo_TR="class='info'";
                                }else{
                                    classTo_TR="class='danger'";
                                }
                            }
                            if (el[i].NameValue[j].Name == "log_file") {
                                log_file = el[i].NameValue[j].Value;
                                if(log_file.length<1){
                                    disOfButton="disabled='disabled'";
                                }
                                log_file = "file://" + log_file;

                            }
                        }
                        etr++;
                        //console.log(etr + " " + "| log_time=" + log_time + "| log_file= " + log_file + " | uuid=" + uuid + "| state" + state + "| agreement=" + agreement + "| Text1=" + Text1);
                        $('#tblLines').append("" +
                        "<tr id='row_" + (i + 1) +"' "+classTo_TR+" >" +
                            "<td>" + log_time + "</td>" +
                            "<td>" + agreement + "</td>" +

                            "<td><input type='text' class='form-control' onkeypress='if (window.event.keyCode==13) {(updateText(id));}' " +
                            "id='Text1_" + (i + 1) + " ' onblur='updateText(id)' placeholder='הזן טקסט'  value='" + Text1 + "'>" +
                        "</td>" +

                            //"<td><a class='btn btn-primary' "+disOfButton+" href='"+log_file+"' role='button'>פתח קובץ שגיאה</a></td>"+
                            "<td><button  class='btn btn-primary' onclick=window.open('" + log_file + "')>פתח קובץ שגיאה</button></td>" +
                            "<td style='visibility:hidden' id='uuid_" + (i + 1) + "' >" + uuid + "</td>"+
                        "</tr>");
                    }
                }
            });
        }
    }

    function processError(data, status, req) {
        //alert(req.responseText + " " + status);
        console.log("Error -> "+req.responseText + " " + status)
    }

    return "";

}
function openFileLog(str) {
    //str="file//smart/ErrorReport/Server_Error_Report_UUID_af5c1a4a-5506-4238-b3fc-8298ef5ecd7b_1422789924486_0.html";
    //console.log(str)
    //str.replace('/','//');
    console.log(str)

    window.open('file://smart/ErrorReport/Server_Error_Report_UUID_6c30dbdd-6833-44ba-8a11-48d23c70132d_1423652702262_0.html');

    //var link = document.createElement("a");
    //link.download = "dsa";
    //link.href = str;
    //link.click();
}

function updateText (id){

    var row=id.split("_")[1];
    row=row.trim();

    var text1 =document.getElementById(id).value;
   // text1=window.btoa(text1);

    var uuid = document.getElementById("uuid_"+row).innerHTML;
    var timeStemp="0";
    console.log("uuid= "+uuid+" text1="+text1);

    var url = "addText1.jsp?text1=" + text1+"&uuid="+uuid+"&timeStemp="+timeStemp;
    console.log("Update= "+url);

    $.ajax({
        cache: false,
        async: false,
        "url": url,
        type: 'POST',
        encoding:"UTF-8",
        contentType: 'application/json; charset=UTF-8',
        //dataType: 'json',
        success: processSuccess,
        error: processError
    });

    function processSuccess(data, status, req) {
        if (status == "success") {
            //console.log("OK");
        }
    }

    function processError(data, status, req) {
        //console.log("NOT OK");
    }

    if(text1.length>1){
        $("#row_"+row).removeClass();
        $("#row_"+row).addClass('info');
    }else{
        $("#row_"+row).removeClass();
        $("#row_"+row).addClass('danger');
    }
}
