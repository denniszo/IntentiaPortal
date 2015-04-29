/**
 * Created by denniszo on 07/04/2015.
 * http://bangkok.intentia.co.il:19007/intentia/CreatePDS027/index.html
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
    //alert(gUSER+" cono "+gCONO)
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
                    for (var j = 0; j < 4; j++) {
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

function startWork() {
    var table = document.getElementById("tblData");
    for (var i = 1, row; row = table.rows[i]; i++) {
        //iterate through rows
        //rows would be accessed using the "row" variable assigned in the for loop
        //for (var j = 0, col; col = row.cells[j]; j++) {
        //    //iterate through columns
        //    //columns would be accessed using the "col" variable assigned in the for loop
        //    console.log(col.innerHTML)
        //}

        var prno = row.cells[0].innerHTML;
        var strt = row.cells[1].innerHTML;
        var opno = row.cells[2].innerHTML;
        var plgr = row.cells[3].innerHTML;

        var inputFields = "cono=" + gCONO + "&prno=" + prno + "&strt=" + strt + "&opno=" + opno + "&plgr=" + plgr;
        var anser = prosesMWS(inputFields);
        if (anser == "1") {
            console.log("OK");
            $("#row_" + (i + 1)).removeClass();
            $("#row_" + (i + 1)).addClass('info');
            row.cells[4].innerHTML = "OK";
        } else {
            console.log("No OK");
            $("#row_" + (i + 1)).removeClass();
            $("#row_" + (i + 1)).addClass('danger');
            row.cells[4].innerHTML = anser;
        }
    }//for -> next row
}

/*
 function for MWS
 */
function prosesMWS(inputFields) {
    var url = "RunPDS027.jsp?"+inputFields;
    // console.log("start");
    var anser="no Anser";
    $.ajax({
        cache: false,
        async: false,
        "url": url,
        type: 'POST',
        contentType: 'application/text',
        dataType: 'text',
        success: processSuccess,
        error: processError
    });
    function processSuccess(data, status, req) {
        if (status == "success") {
            var obj =  req.responseText;
            anser = obj.trim();
        }
    }
    function processError(data, status, req) {
        //alert(req.responseText + " " + status);
        console.log("Error -> " + req.responseText + " " + status)
    }
    return anser;
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

    function exportToFile() {
        var rows = [['WHLO', 'ITNO', 'FDAT', 'TDAT', 'FOQT', 'Error']];
        var table = document.getElementById("tblData");
        for (var i = 1, row; row = table.rows[i]; i++) {
            var whlo = row.cells[0].innerHTML;
            var itno = row.cells[1].innerHTML;
            var fdat = row.cells[2].innerHTML;
            var tdat = row.cells[3].innerHTML;
            var foqt = row.cells[4].innerHTML;
            var error = row.cells[5].innerHTML;

            var row = [whlo, itno, fdat, tdat, foqt, error.trim()];
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
