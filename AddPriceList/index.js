/**
 * Created by denniszo on 04/03/2015.
 */

/*
 gneral parameters
 */
var gUSER = "";
var gCONO = "";
var gDIVI = "";

function onLoad() {
    getCurrentUser();
    if (gUSER == null || gUSER == "") {
        alert("לא מצליח להיתחבר ל M3");
        window.close();
        return;
    }
    var todayDate=new Date().toISOString().substring(0, 10);
    todayDate=todayDate.substr(0,4)+todayDate.substr(5,2)+todayDate.substr(8,2);
    console.log(todayDate)
    document.getElementById('inpFVDT').value = todayDate;
    document.getElementById('inpLVDT').value = todayDate;
    console.log(document.getElementById('inpLVDT').value)

    //alert(gUSER+" cono "+gCONO)
}

/*
 Api - get user params
 */
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
                if (nm == "ZDCONO") {
                    gCONO = vl;
                    //document.getElementById("inpCONO").value = gCONO;
                }
                if (nm == "ZDDIVI") {
                    gDIVI = vl;
                    // document.getElementById("inpDIVI").value = gDIVI;
                }
                // alert(NameValue[index].firstChild.childNodes[0].data);
                //	alert(ell.firstChild.data);

            });
        }
    }

    function processError(data, status, req) {
        alert(req.responseText + " " + status);
    }
}
/*
 load CSV
 */


function browserSupportFileUpload() {
    var isCompatible = false;
    if (window.File && window.FileReader && window.FileList && window.Blob) {
        isCompatible = true;
    }
    return isCompatible;
    {

        // Method that reads and processes the selected file

    }
}

function upload(evt) {
    if (!browserSupportFileUpload()) {
        alert('The File APIs are not fully supported in this browser!');
    } else {
        var data = null;
        var file = evt.target.files[0];
        var reader = new FileReader();
        reader.readAsText(file);
        reader.onload = function (event) {
            var csvData = event.target.result;
            data = $.csv.toArrays(csvData)

            if (data && data.length > 0) {
                //alert('Imported -' + data.length + '- rows successfully!');
                var tblRowsStr = "";
                for (var i = 1; i < data.length; i++) {
                    tblRowsStr += "<tr id='row_" + (i + 1) + "'  >";
                    for (var j = 0; j < 3; j++) {
                        if (data[i][j] != undefined && data[i][j] != null) {
                            tblRowsStr += "<td>" + data[i][j] + "</td>"
                        } else {
                            tblRowsStr += "<td id='anser_" + (i + 1) + "'></td>"
                        }
                    }
                    //anser row
                    tblRowsStr += "<td></td>"
                }
                $('#tblData').append(tblRowsStr);//apend to table
            } else {
                alert('No data to import!');
            }
        };
        reader.onerror = function () {
            alert('Unable to read ' + file.fileName);
        };
    }
}
function start_AddPriceList() {
    var fvdt = $("#inpFVDT").val();
    fvdt = fvdt.replace("-", "");
    fvdt = fvdt.replace("-", "");
    var lvdt = $("#inpLVDT").val();
    lvdt = lvdt.replace("-", "");
    lvdt = lvdt.replace("-", "");
    console.log(lvdt);


    var tx40 = $("#inpTX40").val();
    var prrf = $("#inpPRRF").val();

    var cucd = "ILS";
    var crtp = "01";
    var scmu = "1";
    if (fvdt.trim() == "" || lvdt.trim() == "" || prrf.trim() == "") return;
    var inputFields = "PRRF=" + prrf + "&CUCD=" + cucd + "&FVDT=" + fvdt + "&LVDT=" + lvdt + "&TX40=" + tx40 + "&CRTP=" + crtp +"&SCMU="+ scmu;
    var anser = prosesApi_AddPriceList(inputFields);
    console.log("--->" + anser)
    if (anser == "1") {
        document.getElementById("AddPriceList_anser").innerHTML = "נוצר מחירון חדש";
        $("#AddPriceList_anser").css("background-color", "#4cae4c");
    } else {
        $("#AddPriceList_anser").css("background-color", "red");
        document.getElementById("AddPriceList_anser").innerHTML = anser;
    }


}
function start_AddBasePrice() {
    var prrf=$("#inpPRRF").val();
    if(prrf.trim()==""){
        alert("חווה להקים מחירון");
        return;
    }
    var cucd = "ILS";
    var table = document.getElementById("tblData");
    for (var i = 1, row; row = table.rows[i]; i++) {

        var itno = row.cells[0].innerHTML;
        var fvdt = row.cells[1].innerHTML;
        var sapr = row.cells[2].innerHTML;

        var inputFields = "PRRF=" + prrf + "&CUCD=" + cucd + "&ITNO=" + itno + "&FVDT=" + fvdt + "&SAPR=" + sapr;
        var anser = prosesApi_AddBasePrice(inputFields);
        if (anser == "1") {
            console.log("OK");
            $("#row_" + (i + 1)).removeClass();
            $("#row_" + (i + 1)).addClass('info');
            row.cells[3].innerHTML = "OK";
        } else {
            console.log("No OK");
            $("#row_" + (i + 1)).removeClass();
            $("#row_" + (i + 1)).addClass('danger');
            row.cells[3].innerHTML = anser;
        }
    } //for -> next row
}

/*
 function for API
 */
function prosesApi_AddPriceList(inputFields) {
    console.log("-----------------------prosesApi_AddPriceList()--------------------------------")
    var program = 'OIS017MI';
    var transaction = 'AddPriceList';
    var returncols = [];
    var anserAtt = RunApi_OneAnswer(program, transaction, returncols, inputFields);

    console.log("is error ? " + anserAtt.error);
    if (anserAtt.error != undefined) {
        console.log("---------------------------Error----------------------------")
        console.log(anserAtt.error);
        console.log("-------------------------------------------------------")
        return anserAtt.error;
    }
    console.log("-----------------End AddBasePrice()-------------------------------------")
    return "1";
}

function prosesApi_AddBasePrice(inputFields) {
    console.log("-----------------------AddBasePrice--------------------------------")
    var program = 'OIS017MI';
    var transaction = 'AddBasePrice';
    var returncols = [];
    var anserAtt = RunApi_OneAnswer(program, transaction, returncols, inputFields);

    console.log("is error ? " + anserAtt.error);
    if (anserAtt.error != undefined) {
        console.log("---------------------------Error----------------------------")
        console.log(anserAtt.error);
        console.log("-------------------------------------------------------")
        return anserAtt.error;
    }
    console.log("-----------------End AddBasePrice-------------------------------------")
    return "1";
}

function delleteComplited() {
    delleteRows("OK");
    delleteRows("OK");
}
function delleteRows(txt) {
    var table = document.getElementById("tblData");
    for (var i = 1, row; row = table.rows[i]; i++) {
        var foqt = row.cells[5].innerHTML;
        console.log(foqt)
        if (txt != undefined && txt != null && txt != "") {
            if (foqt.trim().toUpperCase() == txt.trim().toUpperCase()) {
                row.remove();
            }
        } else {
            row.remove();
        }

    }//for -> next row
}

/*
 api run
 */
function RunApi_OneAnswer(program, transaction, returncols, inputFields) {
    //var ansers= new Array();
    var anserAtt = {};
    //return OBJ
    var maxrecs = 100;
    // construct the URL
    var url = '../../m3api-rest/execute/' + program + '/' + transaction + ';maxrecs=' + maxrecs + ';returncols=' + returncols + '?' + inputFields;
    var selectedRows = [];
    $.ajax({
        cache: false,
        async: false,
        "url": url,
        success: processSuccess,
        error: processError
    });
    function processSuccess(data, status, req) {
        anserAtt.status = status;
        if (status == "success") {

            if ((req.responseText).indexOf("ErrorMessage") > -1) {
                console.log("API Error program-" + program + " transaction- " + transaction);
                var Error = $(req.responseText).find('Message');
                var Message = $(Error).find('Message');
                var txt_Messege = $(Error[0]).text();

                var spaceError = txt_Messege.indexOf("                                                                                                                                                                                                                               ");
                if (spaceError > 2) {
                    txt_Messege = txt_Messege.substring(0, spaceError) + txt_Messege.substring(spaceError + 224)
                }
                var ApiError = "M3 API Error: ";
                var mesErr = ApiError + ": " + txt_Messege.trim();
                console.log("error from Api=" + ApiError);

                anserAtt.error = mesErr;

            } else {
                var MIRecord = $(req.responseText).find('MIRecord');
                var NameValue = $(MIRecord).find('NameValue');
                var val1 = $(NameValue).find('Value');
                $(val1).each(function (index, ell) {
                    var nm = NameValue[index].firstChild.childNodes[0].data;
                    var vl = ell.firstChild.data;
                    anserAtt[nm] = vl;
                });
            }
        }
    }

    function processError(data, status, req) {
        anserAtt.status = status;
        // anserAtt.responseText = req.responseText;
        alert(req.responseText + " " + status);
        anserAtt.error = "Error in Script Api";
    }

    return anserAtt;
}

function exportToFile() {
    var rows = [['ITNO', 'FDAT', 'SAPR', 'Error']];
    var table = document.getElementById("tblData");
    for (var i = 1, row; row = table.rows[i]; i++) {
        var itno = row.cells[0].innerHTML;
        var fdat = row.cells[1].innerHTML;
        var sapr = row.cells[2].innerHTML;
        var error = row.cells[3].innerHTML;

        var row = [itno, fdat,sapr, error.trim()];
        rows.push(row);
    }//for -> next row

    if (rows.length > 1) {
        exportToCsv("*.csv", rows)
    }
}

function exportToCsv(filename, rows) {
    var processRow = function (row) {
        var finalVal = '';
        for (var j = 0; j < row.length; j++) {
            var innerValue = row[j] === null ? '' : row[j].toString();
            if (row[j] instanceof Date) {
                innerValue = row[j].toLocaleString();
            }
            ;
            var result = innerValue.replace(/"/g, '""');
            if (result.search(/("|,|\n)/g) >= 0)
                result = '"' + result + '"';
            if (j > 0)
                finalVal += ',';
            finalVal += result;
        }
        return finalVal + '\n';
    };

    var csvFile = '';
    for (var i = 0; i < rows.length; i++) {
        csvFile += processRow(rows[i]);
    }

    var blob = new Blob([csvFile], {type: 'text/csv;charset=utf-8;'});
    if (navigator.msSaveBlob) { // IE 10+
        navigator.msSaveBlob(blob, filename);
    } else {
        var link = document.createElement("a");
        if (link.download !== undefined) { // feature detection
            // Browsers that support HTML5 download attribute
            var url = URL.createObjectURL(blob);
            link.setAttribute("href", url);
            link.setAttribute("download", filename);
            link.style = "visibility:hidden";
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    }
}