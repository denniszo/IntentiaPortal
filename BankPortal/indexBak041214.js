var gSelectedRows_GL = [];
var gSelectedRows_BK = [];

function btnShowRecon() {
    hidFromDate = 0;
    var WhereString1 = "";
    var WhereString2 = "";
    var TransType = $("#ddlType").val();
    if (TransType == 1) {
        WhereString1 = " AND BDVONO=0 ";
        WhereString2 = " AND FG.EGTOCD!='9' ";
    }
    else {
        WhereString1 = " AND BDVONO!=0 ";
        WhereString2 = " AND FG.EGTOCD='9' ";
    }
    /*
     date filter from
     */
    var picker = $('#datetimepicker_From').data('datetimepicker');
    var year = picker._date.getFullYear();
    var month = picker._date.getMonth() + 1;
    if (month < 10) month = "0" + month;
    var day = picker._date.getDate();
    if (day < 10) day = "0" + day;
    var tmpAS400Date = year + "" + month + "" + day;

    if (document.getElementById("dateInpFrom").value != "") {
        if (TransType == 1) {//Open
            WhereString1 = WhereString1 + " AND BDCURD >=" + tmpAS400Date;
            WhereString2 = WhereString2 + " AND CASE WHEN FB.EGCURD IS NULL THEN FG.EGOCDT ELSE FB.EGCURD END >=" + tmpAS400Date;
        } else { //Close
            WhereString1 = WhereString1 + " AND BDLMDT >=" + tmpAS400Date;
            WhereString2 = WhereString2 + " AND FG.EGERDT >=" + tmpAS400Date; //jonathan 18.6.09 was ERDT
        }
    }
    /*
     date filter To
     */
    picker = $('#datetimepicker_To').data('datetimepicker');
    year = picker._date.getFullYear();
    month = picker._date.getMonth() + 1;
    if (month < 10) month = "0" + month;
    day = picker._date.getDate();
    if (day < 10) day = "0" + day;
    tmpAS400Date = year + "" + month + "" + day;

    if (document.getElementById("dateInpTo").value != "") {
        if (TransType == 1) {//Open
            WhereString1 = WhereString1 + " AND " + tmpAS400Date + " >=BDCURD ";
            WhereString2 = WhereString2 + " AND (" + tmpAS400Date + " >=FG.EGOCDT OR " + tmpAS400Date + " >=FB.EGCURD) ";
        }
        else { //Close
            WhereString1 = WhereString1 + " AND " + tmpAS400Date + " >=BDLMDT ";
            WhereString2 = WhereString2 + " AND (" + tmpAS400Date + " >=FG.EGERDT OR " + tmpAS400Date + " >=FB.EGLMDT) ";
        }
    }

    /*
     c
     */

    var fromStr = document.getElementById("inpFrom").value;
    if (fromStr != "") {
        var fromField = $("#ddlFrom").val();
        var bankFromField = fromField.substr(0, fromField.indexOf(";"));
        var glFromField = fromField.substr(fromField.indexOf(";") + 1, fromField.length);
        if (bankFromField == "BDCKNO" || bankFromField == "BDVONO") { //alfa field - מס התאמה ומספר אסמכתא

            WhereString1 = WhereString1 + " AND " + bankFromField + "='" + fromStr + "'";
            WhereString2 = WhereString2 + " AND " + glFromField + "='" + fromStr + "'";
        } else { //numeric
            hidFromDate = ValiDate(fromStr, "DMY");
            //alert("fromDat=" + hidFromDate );
            if (bankFromField == "BDCURD")//מתאריך
            {
                var tmpAS400Date = setAS400Date(fromStr);
                if (tmpAS400Date == -1) return;
                if (TransType == 1)//פתוחות
                {

                    WhereString1 = WhereString1 + " AND " + bankFromField + " >=" + tmpAS400Date;
                    WhereString2 = WhereString2 + " AND " + glFromField + " >=" + tmpAS400Date;
                } else {
                    WhereString1 = WhereString1 + " AND BDLMDT =" + tmpAS400Date; //jonathan 14.06.09 changed >= to =
                    WhereString2 = WhereString2 + " AND FG.EGERDT =" + tmpAS400Date;
                }
            }else {
                if (TransType == 1) {
                    WhereString1 = WhereString1 + " AND " + bankFromField + " >=" + fromStr;
                    WhereString2 = WhereString2 + " AND " + glFromField + " >=" + fromStr;
                } else { //jonathan 14.6.09
                    WhereString1 = WhereString1 + " AND " + bankFromField + " =" + fromStr;
                    WhereString2 = WhereString2 + " AND " + glFromField + " =" + fromStr;
                }
            }
        }

    }

    window.setTimeout(" $('#pleaseWaitDialog').modal('show');",500);

    getBankTRan(WhereString1);
    getGLTran(WhereString2);

    window.setTimeout(" $('#pleaseWaitDialog').modal('hide');",500);
}

function getBankTRan(WhereString) {
    gBankSum = 0;
    var ToDate, tmpWhereStr1, tmpWhereStr2;
    // prepare all the parameters for the transactions models

    // var MyModel=MyDrop.getModel();
    var selBKIDdesc = $("#selBKIDdesc").val().split(",");

    hidFromDate = 0;
    hidToDate = 0;
    var SubmitOK = true;
    // alert(selIndex);

    chosenBkid = selBKIDdesc[0];
    ChosenAit1 = selBKIDdesc[1];


   //var OrderStr = $("#ddlOrder").val();
    // pageContext.getComponentById("ddlOrder").getValue(); BDCURD,ABS(BDBLAM);TRDATE,ABS(FG.EGCUAM)
    var BankOrderByStr = " BDCURD,ABS(BDBLAM) ";//OrderStr.substr(0, OrderStr.indexOf(";"));


    //var WhereString = "  ";
    var returncols = 'BDCURD,BDBLAM,BDCKNO,PAGENO,BDALLN,BDRFFD,BDLMDT,BDVONO,BDSDRC,BDBKID,BDVSER';


    var inputFields = "cono;" + gCONO + ";divi;" + gDIVI + ";bkid;" + chosenBkid + ";OrderByStr;" + BankOrderByStr + ";WhereString;" + WhereString + ";";
    // construct the URL

    var url = "sqlGetBankTrans.jsp?params=" + inputFields + "&returncols=" + returncols;
    // prepare the columns for dataTable
    var arr = returncols.split(',');
    var columns = [];
    for (var i in arr) {
        columns[i] = {
            "data": arr[i]
        };
        // alert("data:" + arr[i]);
    }
    $("#tblBankTrans").dataTable().fnDestroy();
    //clear table data
    //var selectedRows = [];
    gSelectedRows_BK = [];
    $(document).ready(function () {

        var table = $('#tblBankTrans').DataTable({
            /*
             * "dom": 'T<"clear">lfrtip',
             *
             * "tableTools": { "sSwfPath": "/swf/copy_csv_xls_pdf.swf" },
             *
             * tableTools: { "sRowSelect": "multi", "aButtons": [ "select_all",
             * "select_none" ] },
             */


            "language": {
                "sProcessing": "מעבד...",
                "sLengthMenu": "הצג _MENU_ פריטים",
                "sZeroRecords": "לא נמצאו רשומות מתאימות",
                "sInfo": "_TOTAL_ שורות",
                "sInfoEmpty": "",
                "sInfoFiltered": "(מסונן מסך _MAX_  רשומות)",
                "sInfoPostFix": "",
                "sSearch": "חפש:",
                "sUrl": "",
                "oPaginate": {
                    "sFirst": "ראשון",
                    "sPrevious": "קודם",
                    "sNext": "הבא",
                    "sLast": "אחרון"
                }
            },

            scrollY: 200,
            paging: false,
            searching: false,

            // "ajax": "arrays.txt",

            "ajax": {
                "url": url,
                "async":false,
                "cache":false,
                "dataSrc": function (json) {
                    var result = [];
                    for (var i in json.MIRecord) {
                        var record = {};
                        // alert(json.MIRecord[i].NameValue);
                        json.MIRecord[i].NameValue.map(function (o) {
                            record[o.Name] = o.Value;
                        });
                        gBankSum += record["BDBLAM"] * 1;
                        //sum out or render
                        result[i] = record;
                    }
                    gBankSum = Math.floor(gBankSum * 100) / 100;
                    $("#lblTXTSumBank").text(gBankSum);
                    return result;
                }
            },

            "columns": columns,
            /*
             "rowCallback": function(row,data,displayIndex ) {
             if ($.inArray(data.DT_RowId, selected) !== -1 ) {
             $(row).addClass('selected');
             }
             },

             */
            "columnDefs": [
                {// render
                    "targets": 'BDBLAM',
                    "data": null,
                    "defaultContent": "",
                    "render": function (data, type, row, meta) {
                        if (type == "display") {// runs more than one - don't
                            // use it to count/sum

                            if (data < 0) {
                                return '<span style="color:red;">' + data + '</span>';
                            } else {
                                return data;
                            }

                        }

                        if (type == "filter") {// runs only once
                            //gBankSum += data * 1;
                            //$("#lblTXTSumBank").text(gBankSum);
                        }

                    }
                },
                {
                    // date
                    "targets": [0, 6], //'BDLMDT,BDCURD'
                    "defaultContent": "",
                    "render": function (data, type, full, meta) {
                        if (data == null || data == "" || data == "0") {
                            return "ddd";
                        }
                        return YYYYMMDDtoDDMMYY(data);
                    }
                },
                {
                    "targets": [8, 9, 10],
                    "visible": false,
                    "searchable": false
                }
            ]

        });

        // ///////// dennis /////////

        // /////// end dennis /////////
        /*
         $('#btn').click(function() {
         var table = $('#tblBankTrans').DataTable();
         alert(gSelectedRows_BK.length);
         $.each(gSelectedRows_BK, function(index, value) {
         alert(table.row(value).data()["BDBLAM"]);
         // alert( index + ": " + value );
         });

         return;
         alert(gSelectedRows_BK);
         var selecredRows = new Array();
         var table = $('#tblBankTrans').DataTable();
         var selRows = table.$("tr").filter(".selected");
         table.$("tr").filter(".selected").each(function(index, row) {
         alert(index);
         // alert(selRows.row(index).data()["CUNO"]);
         })
         // alert( table.rows('.selected').data().length +' row(s) selected'
         // );
         var table = $('#tblBankTrans').DataTable();
         var row1 = table.row(2).data();
         // alert(row1["CUNO"]);
         // alert(table.row(0).data()["CUNO"]);
         // alert( table.row( 2).data["CUNO"]);
         // alert( data["CUNO"] );
         });

         */
        $('#tblBankTrans tbody').on('click', 'tr', function () {

            $(this).toggleClass("selected");
            var id = $('#tblBankTrans').dataTable().fnGetPosition(this);
            // alert(id);
            var index = $.inArray(id, gSelectedRows_BK);

            if (index === -1) {
                gSelectedRows_BK.push(id);
            } else {
                gSelectedRows_BK.splice(index, 1);
            }
            // alert(selectedRows.length);
            // $(this).toggleClass('selected');

            // alert(id);
            // alert(aPos);
            // var table = $('#GLTrans').DataTable();
            // alert( 'There are'+table.data().length+' row(s) of data in this
            // table' );
            // var aPos = $('#GLTrans').dataTable().fnGetPosition(this);
            // var aData = $('#GLTrans').dataTable().fnGetData(aPos[0]);
            // var tData = $('#GLTrans').dataTable().fnGetData(this);
            // console.log(tData);
            // alert(tData);

        });

    });

    /*
     * $('#tblBankTrans tbody').on('click', 'tr', function () {
     *
     * $(this).toggleClass("selected"); var id =
     * $('#tblBankTrans').dataTable().fnGetPosition(this); // alert(id); var
     * index = $.inArray(id, selectedRows);
     *
     * if ( index === -1 ) { selectedRows.push( id ); } else {
     * selectedRows.splice( index, 1 ); }
     *
     *
     * });
     */

}

function getGLTran(WhereString) {
    gGLSum = 0;
    var ToDate, tmpWhereStr1, tmpWhereStr2;
    // prepare all the parameters for the transactions models

    // var MyModel=MyDrop.getModel();
    var selBKIDdesc = $("#selBKIDdesc").val().split(",");

    hidFromDate = 0;
    hidToDate = 0;
    var SubmitOK = true;

    chosenBkid = selBKIDdesc[0];
    ChosenAit1 = selBKIDdesc[1];

    var TransType = $("#ddlType").val();
    // pageContext.getComponentById("ddlType").getValue();

   // var OrderStr = $("#ddlOrder").val();
   // var BankOrderByStr = OrderStr.substr(0, OrderStr.indexOf(";"));
    var GLOrderByStr = " TRDATE,ABS(FG.EGCUAM) ";//OrderStr.substr(OrderStr.indexOf(";") + 1, OrderStr.length);

    // var WhereString = "  ";
    var returncols = 'TRDATE,EGCUAM,CHKNO,EGJRNO,SHOVAR,EGJSNO,EGVTXT,EGERDT,RECNO,VSER';
    var inputFields = "cono;" + gCONO + ";divi;" + gDIVI + ";ait;" + ChosenAit1 + ";OrderByStr;" + GLOrderByStr + ";WhereString;" + WhereString + ";";
    // construct the URL

    var url = "sqlGetGLTrans.jsp?params=" + inputFields;
    // prepare the columns for dataTable
    var arr = returncols.split(',');
    var columns = [];
    for (var i in arr) {
        columns[i] = {
            "data": arr[i]
        };
        // alert("data:" + arr[i]);
    }

    $("#tblGLTrans").dataTable().fnDestroy();
    //clear table data
    gSelectedRows_GL = [];
    $(document).ready(function () {

        var table = $('#tblGLTrans').DataTable({
            /*
             * "dom": 'T<"clear">lfrtip',
             *
             * "tableTools": { "sSwfPath": "/swf/copy_csv_xls_pdf.swf" },
             *
             * tableTools: { "sRowSelect": "multi", "aButtons": [ "select_all",
             * "select_none" ] },
             */
            "language": {
                "sProcessing": "מעבד...",
                "sLengthMenu": "הצג _MENU_ פריטים",
                "sZeroRecords": "לא נמצאו רשומות מתאימות",
                "sInfo": "_TOTAL_ שורות",//"sInfo": "_START_ עד _END_ מתוך _TOTAL_ רשומות",
                "sInfoEmpty": "0 עד 0 מתוך 0 רשומות",
                "sInfoFiltered": "(מסונן מסך _MAX_  רשומות)",
                "sInfoPostFix": "",
                "sSearch": "חפש:",
                "sUrl": "",
                "oPaginate": {
                    "sFirst": "ראשון",
                    "sPrevious": "קודם",
                    "sNext": "הבא",
                    "sLast": "אחרון"
                }
            },

            scrollY: 200,
            paging: false,
            searching: false,
            // "ajax": "arrays.txt",

            "ajax": {
                "async":false,
                "cache":false,
                "url": url,
                "dataSrc": function (json) {
                    var result = [];

                    for (var i in json.MIRecord) {
                        var record = {};
                        // alert(json.MIRecord[i].NameValue);
                        json.MIRecord[i].NameValue.map(function (o) {
                            record[o.Name] = o.Value;
                        });
                        // alert(record[0].value);
                        // var arr = [ "Name=CUNO", "Value=9000"];
                        // console.log(record["BDBLAM"]);

                        gGLSum += record["EGCUAM"] * 1;
                        //sum out of render
                        result[i] = record;

                    }
                    gGLSum = Math.floor(gGLSum * 100) / 100;
                    $("#lblTXTSumGL").text(gGLSum);
                    return result;
                }
            },

            "columns": columns/*
             *,


             "rowCallback": function( row, data,
             * displayIndex ) { if (
             * $.inArray(data.DT_RowId, selected) !== -1 ) {
             * $(row).addClass('selected'); } }
             */,
            "columnDefs": [
                {// render
                    "targets": 'EGCUAM',
                    "data": null,
                    "defaultContent": "",
                    "render": function (data, type, row, meta) {

                        if (type == "display") {// runs more than one - don't
                            // use it to count/sum

                            if (data < 0) {
                                return '<span style="direction:ltr;color:red;" >' + data + '</span>';
                            } else {
                                return data;
                            }
                        }

                        if (type == "filter") {// runs only once
                            // gBankSum+=data*1;
                            // $("#lblTXTSumBank").text(gBankSum);
                        }
                    }
                },
                {
                    // date
                    "targets": [0,7],
                    "data": null,
                    "defaultContent": "",
                    "render": function (data, type, full, meta) {
                        if (data == null || data == "" || data == "0") {
                            return "0";
                        }
                        return YYYYMMDDtoDDMMYY(data);
                    }
                },

                {
                    "targets": [9],
                    "visible": false,
                    "searchable": false
                }
            ]

        });

        $('#btn2').click(function () {
            var table = $('#tblGLTrans').DataTable();
            alert(gSelectedRows_GL.length);
            $.each(gSelectedRows_GL, function (index, value) {
                // alert(table.row(value).data()["CHKNO"]);

            });

            return;
            var selecredRows = new Array();
            var table = $('#tblGLTrans').DataTable();
            var selRows = table.$("tr").filter(".selected");
            table.$("tr").filter(".selected").each(function (index, row) {
                // alert(index);

            });
            var table = $('#tblGLTrans').DataTable();
            var row1 = table.row(2).data();
        });

        $('#tblGLTrans tbody').on('click', 'tr', function () {

            $(this).toggleClass("selected");
            var id = $('#tblGLTrans').dataTable().fnGetPosition(this);
            // alert(id);
            var index = $.inArray(id, gSelectedRows_GL);

            if (index === -1) {
                gSelectedRows_GL.push(id);
            } else {
                gSelectedRows_GL.splice(index, 1);
            }

        });

    });

}

/*
 function run() {
 alert(12)
 try {
 // construct the URL
 var url = '../../m3api-rest/execute/' + program + '/' + transaction + ';maxrecs=' + maxrecs
 + ';returncols=' + returncols + '?' + inputFields;
 // execute the request
 var xhr = new XMLHttpRequest();
 xhr.open('GET', url, true, userid, password);
 xhr.setRequestHeader('Accept', 'application/json');
 xhr.onreadystatechange = function() {
 // handle the response
 if (this.readyState == 4) {
 if (this.status == 200) {
 // get the JSON
 var jsonTxt = xhr.responseText;
 var response = eval('(' + jsonTxt + ')');
 // show the metadata
 var table = document.getElementById('results');
 var thead = table.tHead;
 if (thead === null) {
 thead = document.createElement('thead');
 var tr = document.createElement('tr');
 var metadata = response.Metadata.Field;
 for ( var m in metadata) {
 var th = document.createElement('th');
 th.appendChild(document.createTextNode(metadata[m]['@description']
 + ' ' + metadata[m]['@name']));
 tr.appendChild(th);
 }
 thead.appendChild(tr);
 table.appendChild(thead);
 // paint the table with jQuery DataTables
 $('#results').dataTable({
 "bJQueryUI" : true,
 "sPaginationType" : "full_numbers"
 });
 }
 // show the data
 var rows = response.MIRecord;
 for ( var i in rows) {
 var fields = rows[i].NameValue;
 var values = [];
 for ( var j in fields) {
 values.push(fields[j].Value);
 }
 $('#results').dataTable().fnAddData(values);
 }
 } else {
 alert(xhr.responseText);
 }
 }
 };
 xhr.send();
 } catch (ex) {
 alert(ex);
 }
 }
 */

var ddlSportCat, ddlSport, HdnSportCat;
function SportsCategory() {
    ddlSportCat.empty();
    ddlSportCat.append("<option >Loading...</option>");

    $.ajax({
        type: "POST",
        url: "/SportsCategory.ashx",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error: function (data, textStatus) {
            // A function to called if request fails
        },
        success: function (data) {
            ddlSportCat.empty();
            ddlSportCat.append("<option value='0'>--Select Sport Category--</option>");
            ddlSport.append("<option value='0'>--Select Sport--</option>");
            $.each(data, function (i, item) {
                ddlSportCat.append('<option  value="' + item.Category_id + '"> ' + item.Category + '</option>');
            });
            // A function to be called if request succeeds
        },
        complete: function () {
            // A function to be called when the ajax request is completed
        }
    });
}

function YYYYMMDDtoDDMMYY(orig_date) {

    var dd, mm, yyyy, return_date;
    dd = orig_date.substring(6, 8);
    mm = orig_date.substring(4, 6);
    yyyy = orig_date.substring(0, 4);

    return_date = dd + "/" + mm + "/" + yyyy;
    return return_date;
}
function ValiDate(orig_date, dateFormat) {
    var dd, mm, yyyy, return_date;

    var the_text;
    the_text = orig_date;

    if (orig_date.length == 8)//work only on AS400 valid date format
    {
        switch (dateFormat)//select the correct date format
        {
            case "DMY": //ddmmyyyy  01012008= 082001
                the_text = the_text.substr(4, 4) + the_text.substr(2, 2) + the_text.substr(0, 2);
                break;
            case "YMD":
                //the_text=the_text.substr(2,2)+the_text.substr(4,2)+the_text.substr(6,2);
                the_text;
                break;
            case "MDY":
                the_text = the_text.substr(4, 4) + the_text.substr(0, 2) + the_text.substr(2, 2);
                break;
        }

        //	span.innerText = the_text; //set the text in the cell

    } else if (orig_date.length == 6) {
        switch (dateFormat)//select the correct date format
        {
            case "DMY": //ddmmyy  01012008= 082001
                the_text = '20' + the_text.substr(4, 2) + the_text.substr(2, 2) + the_text.substr(0, 2);
                break;
            case "YMD":
                //the_text=the_text.substr(2,2)+the_text.substr(4,2)+the_text.substr(6,2);
                the_text = '20' + the_text;
                break;
            case "MDY":
                the_text = '20' + the_text.substr(4, 2) + the_text.substr(0, 2) + the_text.substr(2, 2);
                break;
        }

    } else {
        the_text = 0;
    }
    //	alert (the_text);
    return the_text;


}
function setAS400Date(orig_date) {
    var dd, mm, yyyy, return_date;
    if (orig_date.length != 8 && orig_date.length != 6) {
        // alert("date error");
        return -1;
    }
    dd = orig_date.substring(0, 2);
    mm = orig_date.substring(2, 4);
    if (orig_date.length == 6) {
        yyyy = '20' + orig_date.substring(4, 6);
    } else {
        yyyy = orig_date.substring(4, 8);
    }
    return_date = yyyy.concat(mm, dd);
    // top.alert(return_date);
    return return_date;
}


/**************************************************************************************
 *
 * Start Reconculation
 *
 * function are coped and generated from ibrix RECON2
 * 01/09/2014 by Dennis
 *
 */
function btnDoRecon() {
    var i, j, delrec_counter;
    var BankSum, GLSum;
    var TransDate, LineNo, JournalNo, JournalSeqNo, TransYear;
    // var TransType=pageContext.getComponentById("ddlType").getValue();
    var TransType = $("#ddlType").val();
    var found_flag;
    var diff;

    //check that rows are selected in both tables
    var BankRows = setBankTabelArry();
    var GLRows = setGLArry();

    // ApiTest();
    // return;

    console.log(BankRows[0].BDVONO);
    if (TransType == 1)//Do recon
    {
        if (BankRows.length < 1 && GLRows.length < 1) {
            top.alert(msg6);
            return;
        }
        AddStatus(msg7);
        BankSum = 0;
        if (BankRows.length > 0) {
            for (i = 0; i < BankRows.length; i++) {
                var fNum = parseFloat(BankRows[i].BDBLAM);
                var iNum = Math.round(fNum * 100);
                BankSum = BankSum + iNum;
            }
        }
        BankSum = BankSum / 100;
        GLSum = 0;
        if (GLRows.length > 0) {
            for (i = 0; i < GLRows.length; i++) {
                var fNum = parseFloat(GLRows[i].EGCUAM);
                var iNum = Math.round(fNum * 100);
                GLSum = GLSum + iNum;
            }
        }
        GLSum = GLSum / 100;
        diff = BankSum - GLSum;
        console.log(diff);
        AddStatus("");
        if (diff != 0) {
            diff = Math.round(diff * 100) / 100;
            top.alert(msg8 + diff);
            return;
        }
        if (confirm(msg9))//confirmed
        {
            AddStatus(msg10);
            if (StartReco() != 0)//start reco succeded ?
            {
                top.alert("Error")
                AddStatus("");
                return;
            }

            AddStatus("");
            if (BankRows.length > 0) {
                AddStatus(msg12);
                for (i = 0; i < BankRows.length; i++) {
                    TransDate = BankRows[i].BDSDRC;//BankRows[i].getValueByField("BDSDRC");
                    LineNo = BankRows[i].BDALLN;//BankRows[i].getValueByField("BDALLN");
                    if (AddBankTrans(TransDate, LineNo) != 0)//error occured
                    {
                        DeleteReco();
                        top.alert(msg13);
                        AddStatus("");
                        return;
                    }
                    AddStatus(".");
                }
            }
            AddStatus("");
            console.log("if (GLRows)")
            if (GLRows.length > 0) {
                for (i = 0; i < GLRows.length; i++) {
                    AddStatus(msg14);
                    TransYear = (GLRows[i].TRDATE).substring(0, 4);//GLRows[i].getValueByField("TRDATE").substring(0, 4);
                    JournalNo = GLRows[i].EGJRNO;//GLRows[i].getValueByField("EGJRNO");
                    JournalSeqNo = GLRows[i].EGJSNO;//GLRows[i].getValueByField("EGJSNO");
                    console.log("TransYear= " + TransYear + " JournalNo=" + JournalNo + " JournalSeqNo= " + JournalSeqNo);
                    if (AddGLTrans(TransYear, JournalNo, JournalSeqNo) != 0)//error occured
                    {
                        DeleteReco();
                        top.alert(msg13);
                        AddStatus("");
                        return;
                    }
                }
            }
            AddStatus("");
            AddStatus(msg15);
            if (EndReco() != 0) {
                DeleteReco();
                top.alert(msg13);
                AddStatus("");
                return;
            }
            top.alert(msg16);
            AddStatus("");
            btnShowRecon();
        } else {
            //not confirmed to proses
            return;
        }
    } else {//Del Recon
        console.log("Del Recon");
        //get the recon selected in both tables
        var BankRows = setBankTabelArry();
        var GLRows = setGLArry();
        //get the reconciliation to cancel into an array
        delrec_counter = 0;
        var DelReconArr = new Array(100);
        AddStatus(msg17);
        if (BankRows.length > 0) {
            for (i = 0; i < BankRows.length; i++) {
                found_flag = 0;
                for (j = 0; j < delrec_counter; j++) {
                    if (BankRows[i].BDVSER == DelReconArr[j][0] && BankRows[i].BDVONO == DelReconArr[j][1])
                        found_flag = 1;
                }
                if (found_flag == 0) {
                    DelReconArr[delrec_counter] = new Array(2);
                    DelReconArr[delrec_counter][0] = BankRows[i].BDVSER;
                    DelReconArr[delrec_counter][1] = BankRows[i].BDVONO;
                    delrec_counter++;
                }
            }
        }
        AddStatus("");
        AddStatus(msg18);
        if (GLRows.length > 0) {
            for (i = 0; i < GLRows.length; i++) {
                found_flag = 0;
                for (j = 0; j < delrec_counter; j++) {
                    if (GLRows[i].VSER == DelReconArr[j][0] && GLRows[i].RECNO == DelReconArr[j][1])
                        found_flag = 1;
                }
                if (found_flag == 0) {
                    DelReconArr[delrec_counter] = new Array(2);
                    DelReconArr[delrec_counter][0] = GLRows[i].VSER; //GLRows[i].getValueByField("VSER");
                    DelReconArr[delrec_counter][1] = GLRows[i].RECNO; //GLRows[i].getValueByField("RECNO");
                    delrec_counter++;
                }
            }
        }
        //end of array filling
        //do the cancelling
        if (delrec_counter == 0) {
            top.alert(msg19);
            AddStatus("");
            return;
        }
        AddStatus("");
        AddStatus(msg20);
        for (i = 0; i < delrec_counter; i++) {
            //top.alert("Recon " + i + "=" + DelReconArr[i][0] + "," + DelReconArr[i][1])
            vser = DelReconArr[i][0];
            vono = DelReconArr[i][1];
            AddStatus(".");
            DeleteReco();
        }
        top.alert(msg21);
        AddStatus("");

        btnShowRecon();
    }
}

function AddStatus(stsText) {

    if (stsText == "") {
        //document.all.lblSts.innerText="";
        console.log("");
    } else {
        //document.all.lblSts.innerText=document.all.lblSts.innerText + stsText;
        console.log(stsText);
    }

}


/*
 Api running function
 return one answer
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
                var mesErr = ApiError + "\nApi:" + program + "\nTransaction" + transaction + "\n" + txt_Messege + $(Error[0]).text();
                console.log("error from Api=" + $(Error[0]).text());

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

/****************
 new registration in regist.js
 ***************/
