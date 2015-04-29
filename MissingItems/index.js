var gCONO = "";
var gUSER = "";
var gDIVI = "";

function onLoad() {
    set_ddlBUAR();
    set_TableItems();

    prosesApi_GENERAL_GetUserInfo(); //get User General API

}

function prosesApi_GENERAL_GetUserInfo() {
    console.log("-----------------------start GENERAL.GetUserInfo()--------------------------------")
    var program = 'GENERAL';
    var transaction = 'GetUserInfo';
    var returncols = ['ZZUSID', 'ZDCONO', 'ZDDIVI'];
    var anserAtt = RunApi_OneAnswer(program, transaction, returncols, inputFields);
    var inputFields = "";

    console.log("is error ? " + anserAtt.error);
    if (anserAtt.error != undefined) {
        console.log("---------------------OIS100MI.GENERAL.GetUserInfo()-> -Error----------------------------")
        console.log(anserAtt.error);
        console.log("-------------------------------------------------------")
        return anserAtt.error;
    }
    console.log("-----------------End GENERAL.GetUserInfo()-------------------------------------")

    //return object like : {status: "success", ZZUSID: "LCMADMIN  ", ZDCONO: "200", ZDDIVI: "001" }
    //return anserAtt;
    gCONO = anserAtt.ZDCONO;
    gUSER = anserAtt.ZZUSID;
    gDIVI = anserAtt.ZDDIVI;

}

function set_ddlBUAR() {
    //var url = "listErrorLines.jsp?hh="+hh;
    var url = "listBUAR.jsp?cono=200";
    // console.log("start");
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
                    var buar = "";
                    var tx40 = "";
                    var tx15 = "";

                    var etr = 0;
                    for (var i = 0; i < el.length; i++) {
                        //console.log(el[i].RowIndex);
                        for (var j = 0; j < el[i].NameValue.length; j++) {
                            if (el[i].NameValue[j].Name == "buar") {
                                buar = el[i].NameValue[j].Value;
                            }
                            if (el[i].NameValue[j].Name == "tx40") {
                                tx40 = el[i].NameValue[j].Value;
                            }
                            if (el[i].NameValue[j].Name == "tx15") {
                                tx15 = el[i].NameValue[j].Value;
                            }
                        }
                        etr++;
                        //console.log(etr+" "+"| buar="+buar+"| tx40= "+tx40+"| tx15="+tx15 );
                        $('#selBUAR').append("<option value='" + buar + "'>" + tx40 + "</option>");
                    }
                }
            });
        }
    }

    function processError(data, status, req) {
        //alert(req.responseText + " " + status);
        console.log("Error -> " + req.responseText + " " + status)
    }

    return "";

}

function set_TableItems() {
    $("#setFindITNO").val("");
    $("#tblItems > tbody").html("");

    var buar = $('#selBUAR').select().val();
    var url = "listMissingItems.jsp?cono=200&buar=" + buar;
    //console.log("start");
    waitingDialog.show("המתן", {dialogSize: 'bg', progressType: 'warning'});
    $.ajax({
        cache: false,
        async: true,
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
                    var itno = "";
                    var itds = "";
                    var DeliveredQty = "";
                    var MissingQty = "";
                    var AvailableQty = "";
                    var net = "";
                    var buar = "";
                    var date = "";
                    var leadTime = "";

                    var classTo_TR = '';

                    var etr = 0;
                    for (var i = 0; i < el.length; i++) {
                        //console.log(el[i].RowIndex);
                        //"OBITNO", "MMITDS", "DeliveredQty","MissingQty","AvailableQty","NET","MMBUAR"
                        for (var j = 0; j < el[i].NameValue.length; j++) {
                            if (el[i].NameValue[j].Name == "itno") {
                                itno = el[i].NameValue[j].Value;
                            }
                            if (el[i].NameValue[j].Name == "itds") {
                                itds = el[i].NameValue[j].Value;
                            }
                            if (el[i].NameValue[j].Name == "DeliveredQty") {
                                DeliveredQty = el[i].NameValue[j].Value;
                            }
                            if (el[i].NameValue[j].Name == "MissingQty") {
                                MissingQty = el[i].NameValue[j].Value;
                            }
                            if (el[i].NameValue[j].Name == "AvailableQty") {
                                AvailableQty = el[i].NameValue[j].Value;
                            }
                            if (el[i].NameValue[j].Name == "NET") {
                                net = el[i].NameValue[j].Value;
                            }
                            if (el[i].NameValue[j].Name == "buar") {
                                buar = el[i].NameValue[j].Value;
                            }
                            if (el[i].NameValue[j].Name == "date") {
                                date = el[i].NameValue[j].Value;
                            }
                            if (el[i].NameValue[j].Name == "leadTime") {
                                leadTime = el[i].NameValue[j].Value;
                            }

                        }
                        etr++;
                        // console.log(etr+" "+"| buar="+buar+"| itno= "+itno+"| itds="+itds+"| DeliveredQty="+DeliveredQty+"| MissingQty="+MissingQty+"| AvailableQty="+AvailableQty+"| net="+net  );

                        $('#tblItems').append("" +
                        "<tr id='row_" + (i + 2) + "' " + classTo_TR + " >" +
                        "<td>" + itno + "</td>" +
                        "<td>" + itds + "</td>" +
                        "<td>" + DeliveredQty + "</td>" +
                        "<td>" + MissingQty + "</td>" +
                        "<td>" + AvailableQty + "</td>" +
                        "<td>" + net + "</td>" +
                        "<td>" + leadTime + "</td>" +
                        "<td><input type='text' class='form-control' onkeypress='if (window.event.keyCode==13) {(updateText(id));}' " +
                        "id='upDate_" + (i + 2) + "' onblur='updateText(id)' placeholder='תאריך'  value='" + date + "'>" +
                        "</td>" +
                            /*
                        "<td><input type='text' class='form-control' onkeypress='if (window.event.keyCode==13) {(updateText(id));}' " +
                        "id='upQtu" + (i + 2) + "' onblur='updateText(id)' placeholder='כמות'  value='0'>" +
                        "</td>" +
                        */
                        "<td style='visibility:hidden' id='oldDate_" + (i + 2) + "' >" + date + "</td>" +
                            //"<td style='visibility:hidden' id='oldQtu" + (i + 2) + "' >" + 0 + "</td>"+
                        "</tr>");
                    }
                }
                waitingDialog.hide();
            });
        }
    }

    function processError(data, status, req) {
        //alert(req.responseText + " " + status);
        console.log("Error -> " + req.responseText + " " + status)
    }

    return "";

}


function updateText(id) {
    //var row=id.split("_")[1];
    //row=row.trim();
    //var text1 =document.getElementById(id).value;
    //var uuid = document.getElementById("uuid_"+row).innerHTML;
}

function find_TableItems(inp) {
    var val = inp.value;
    $('#tblItems tbody').find('tr').each(function () {
        var colA = $(this).find("td").eq(0);
        var colB = $(this).find("td").eq(1);

        //console.log(colA.html()+" "+colB.html());
        if (colA.html().indexOf(val) > -1 || colB.html().indexOf(val) > -1) {
            $(this).show();
            //colA.css('color', 'red');
            //$(this).html($(this).html().replace(val, "<span style='background-color:#ffff00;'>"+val+"</span>"));

        } else {
            $(this).hide();
            //$(this).html($(this).html().replace(colA.html(), "<span style='background-color:lightgoldenrodyellow;'>"+colA.html()+"</span>"));
        }
    })

}

/*********Prosses to Update *********/

function startRunProses() {
    var table = document.getElementById("tblItems");
    for (var i = 2, row; row = table.rows[i]; i++) {
        var itno = row.cells[0].innerHTML;
        var itds = row.cells[1].innerHTML;
        var DeliveredQty = row.cells[2].innerHTML;
        var MissingQty = row.cells[3].innerHTML;
        var AvailableQty = row.cells[4].innerHTML;
        var net = row.cells[5].innerHTML;

        var up_date = $("#upDate_" + i).val();
        var old_date = row.cells[8].innerHTML;

        if (up_date != old_date) {
            console.log("up_date= " + up_date + " old_date= " + old_date)
            console.log("Update =" + i);
            //TODO run update

        }

    }//for -> next row

}

/*** API OIS100MI_UpdCnfDlyDate **/
function prosesApi_OIS100MI_UpdCnfDlyDate(inputFields) {
    console.log("-----------------------start OIS100MI.UpdCnfDlyDate()--------------------------------")
    var program = 'OIS100MI';
    var transaction = 'UpdCnfDlyDate';
    var returncols = [];
    //var inputFields = "CONO=" + gCONO + "&DIVI=" + gDIVI + "&BKID=" + chosenBkid + "&CHID=" + gUSER;
    var anserAtt = RunApi_OneAnswer(program, transaction, returncols, inputFields);

    console.log("is error ? " + anserAtt.error);
    if (anserAtt.error != undefined) {
        console.log("---------------------OIS100MI.UpdCnfDlyDate()-> -Error----------------------------")
        console.log(anserAtt.error);
        console.log("-------------------------------------------------------")
        return anserAtt.error;
    }

    //for (var key in anserAtt) {
    //    var value = anserAtt[key];
    //    console.log(key + "=" + value);
    //    if (key == "VSER") vser = value;
    //    if (key == "VONO") vono = value;
    //}
    //console.log("vser= " + vser + " and vono= " + vono);
    console.log("-----------------End OIS100MI.UpdCnfDlyDate()-------------------------------------")
    return "1";
}


/***************************************************
 * api run
 ***************************************************/
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