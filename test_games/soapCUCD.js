var gSelectedRows_GL = [];
var gSelectedRows_BK = [];
function btnShowRecon() {
    getBankTRan();
    getGLTran();
}

function getBankTRan() {
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

    var TransType = $("#ddlType").val();
    // pageContext.getComponentById("ddlType").getValue();

    var OrderStr = $("#ddlOrder").val();
    // pageContext.getComponentById("ddlOrder").getValue();
    var BankOrderByStr = OrderStr.substr(0, OrderStr.indexOf(";"));
    var GLOrderByStr = OrderStr.substr(OrderStr.indexOf(";") + 1, OrderStr.length);

    var WhereString = "and 1=1 ";
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
                "sInfo": "_START_ עד _END_ מתוך _TOTAL_ רשומות",
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
                "url": url,
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
                                return '<span style="color:red;" >' + data + '</span>';
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
                    "targets": [0,6], //'BDLMDT,BDCURD'
                    "defaultContent": "",
                    "render": function (data, type, full, meta) {
                        if (data == null || data == "" || data == "0") {
                            return "ddd";
                        }
                        return YYYYMMDDtoDDMMYY(data);
                    }
                },{
                    "targets": [8,9,10],
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

function getGLTran() {
    gGLSum = 0;
    var ToDate, tmpWhereStr1, tmpWhereStr2;
    // prepare all the parameters for the transactions models

    // var MyModel=MyDrop.getModel();
    var selBKIDdesc = $("#selBKIDdesc").val().split(",");

    hidFromDate = 0;
    hidToDate = 0;
    var SubmitOK = true;

    var chosenBkid = selBKIDdesc[0];
    var ChosenAit1 = selBKIDdesc[1];

    var TransType = $("#ddlType").val();
    // pageContext.getComponentById("ddlType").getValue();

    var OrderStr = $("#ddlOrder").val();
    var BankOrderByStr = OrderStr.substr(0, OrderStr.indexOf(";"));
    var GLOrderByStr = OrderStr.substr(OrderStr.indexOf(";") + 1, OrderStr.length);

    // get the Date format
    // /dateFormat=pageContext.getComponentById("ddlDateFormat").getValue();
    // /replaced by API

    // alert(dateFormat);
    // set where string according to transaction type
    var WhereString1 = "";
    var WhereString2 = "";
    if (TransType == 1) {
        WhereString1 = " AND BDVONO=0 ";
        WhereString2 = " AND FG.EGTOCD!='9' ";
    } else {
        WhereString1 = " AND BDVONO!=0 ";
        WhereString2 = " AND FG.EGTOCD='9' ";
    }

    // alert(WhereString1);
    // alert(gCONO);//

    // var WhereString=WhereString2;
    var WhereString = " and 1=1 ";
    var returncols = 'TRDATE,EGCUAM,CHKNO,EGJRNO,SHOVAR,EGJSNO,EGVTXT,EGERDT,RECNO';
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
                "sInfo": "_START_ עד _END_ מתוך _TOTAL_ רשומות",
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
                    "targets": "EGERDT",
                    "data": null,
                    "defaultContent": "",
                    "render": function (data, type, full, meta) {
                        if (data == null || data == "" || data == "0") {
                            return "0";
                        }
                        return YYYYMMDDtoDDMMYY(data);
                    }
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
    var TransDate, Lineno, JournalNo, JournalSeqNo, TransYear;
    // var TransType=pageContext.getComponentById("ddlType").getValue();
    var TransType = $("#ddlType").val();
    var found_flag;
    var diff;

    //check that rows are selected in both tables
    var BankRows = setBankTabelArry();
    var GLRows = setGLArry();

    ApiTest();
    return;

    console.log(BankRows[0].BDVONO);
    if (TransType == 1)//Do recon
    {
        if (BankRows.length < 1 && GLRows.length < 1) {
            alert(msg6);
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
        AddStatus("");
        if (diff != 0) {
            diff = Math.round(diff * 100) / 100;
            top.alert(msg8 + diff);
            return;
        }
        if (confirm(msg9))//confirmed
        {
            AddStatus(msg10);
            //ApiTest();
            if (StartReco() != 0)//start reco succeded ?
            {
                AddStatus("");
                return;
            }

            AddStatus("");
            if (BankRows.length > 0) {
                AddStatus(msg12);
                for (i = 0; i < BankRows.length; i++) {
                    TransDate = BankRows[i].getValueByField("BDSDRC");
                    LineNo = BankRows[i].getValueByField("BDALLN");
                    if (AddBankTrans(TransDate, LineNo) != 0)//error occured
                    {
                        DeleteReco();
                        top.alert("]]><jsp:expression>msg13</jsp:expression><![CDATA[");
                        AddStatus("");
                        return;
                    }
                    AddStatus(".");
                }
            }
            AddStatus("");
            if (GLRows) {
                for (i = 0; i < GLRows.length; i++) {
                    AddStatus("]]><jsp:expression>msg14</jsp:expression><![CDATA[");
                    TransYear = GLRows[i].getValueByField("TRDATE").substring(0, 4);
                    JournalNo = GLRows[i].getValueByField("EGJRNO");
                    JournalSeqNo = GLRows[i].getValueByField("EGJSNO");
                    if (AddGLTrans(TransYear, JournalNo, JournalSeqNo) != 0)//error occured
                    {
                        DeleteReco();
                        top.alert("]]><jsp:expression>msg13</jsp:expression><![CDATA[");
                        AddStatus("");
                        return;
                    }
                }
            }
            AddStatus("");
            AddStatus("]]><jsp:expression>msg15</jsp:expression><![CDATA[");
            if (EndReco() != 0) {
                DeleteReco();
                top.alert("]]><jsp:expression>msg13</jsp:expression><![CDATA[");
                AddStatus("");
                return;
            }
            top.alert("]]><jsp:expression>msg16</jsp:expression><![CDATA[");
            AddStatus("");

            btnShowRecon();
        } else {//not confirme
            return;
        }
    } else//Del Recon
    {
        //get the recon selected in both tables
        var BankRows = pageContext.getComponentById("tblBankTrans").getSelectedRows();
        var GLRows = pageContext.getComponentById("tblGLTrans").getSelectedRows();
        //get the reconciliation to cancel into an array
        delrec_counter = 0;
        var DelReconArr = new Array(100);
        AddStatus("]]><jsp:expression>msg17</jsp:expression><![CDATA[");
        if (BankRows) {
            for (i = 0; i < BankRows.length; i++) {
                found_flag = 0;
                for (j = 0; j < delrec_counter; j++) {
                    if (BankRows[i].getValueByField("BDVSER") == DelReconArr[j][0] && BankRows[i].getValueByField("BDVONO") == DelReconArr[j][1])
                        found_flag = 1;
                }
                if (found_flag == 0) {
                    DelReconArr[delrec_counter] = new Array(2);
                    DelReconArr[delrec_counter][0] = BankRows[i].getValueByField("BDVSER");
                    DelReconArr[delrec_counter][1] = BankRows[i].getValueByField("BDVONO");
                    delrec_counter++;
                }
            }
        }
        AddStatus("");
        AddStatus("]]><jsp:expression>msg18</jsp:expression><![CDATA[");
        if (GLRows) {
            for (i = 0; i < GLRows.length; i++) {
                found_flag = 0;
                for (j = 0; j < delrec_counter; j++) {
                    if (GLRows[i].getValueByField("VSER") == DelReconArr[j][0] && GLRows[i].getValueByField("RECNO") == DelReconArr[j][1])
                        found_flag = 1;
                }
                if (found_flag == 0) {
                    DelReconArr[delrec_counter] = new Array(2);
                    DelReconArr[delrec_counter][0] = GLRows[i].getValueByField("VSER");
                    DelReconArr[delrec_counter][1] = GLRows[i].getValueByField("RECNO");
                    delrec_counter++;
                }
            }
        }
        //end of array filling
        //do the cancelling
        if (delrec_counter == 0) {
            top.alert("]]><jsp:expression>msg19</jsp:expression><![CDATA[");
            AddStatus("");
            return;
        }
        AddStatus("");
        AddStatus("]]><jsp:expression>msg20</jsp:expression><![CDATA[");
        for (i = 0; i < delrec_counter; i++) {
            //top.alert("Recon " + i + "=" + DelReconArr[i][0] + "," + DelReconArr[i][1])
            vser = DelReconArr[i][0];
            vono = DelReconArr[i][1];
            AddStatus(".");
            DeleteReco();
        }
        top.alert("]]><jsp:expression>msg21</jsp:expression><![CDATA[");
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

function StartReco() {

    var program = 'GLIL02MI';
    var transaction = 'StartReco';
    var returncols = ["VSER", "VONO"];
    var inputFields = "CONO=" + gCONO + "&DIVI=" + gDIVI + "&BKID=" + chosenBkid + "&CHID=" + gUSER;
    var anserAtt = RunApi_OneAnser(program, transaction, returncols, inputFields);

    if (anserAtt.error != undefined) {
        alert(ApiError.error);
        return -1;
    }
    console.log(anserAtt.error);
    return 0;
}

function ApiTest() {
    console.log("hii");
    var program = 'MMS010MI';
    var transaction = 'ListLocations';
    var returncols = ["SLDS", "RESP"];
    var inputFields = "";
    //'WHLO=110&WHSL=001';
    var anserAtt = RunApi_OneAnser(program, transaction, returncols, inputFields);
    for (var key in anserAtt) {
        var value = anserAtt[key];
        console.log(key + "=" + value);

    }
}

function RunApi_OneAnser(program, transaction, returncols, inputFields) {
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

            if ((req.responseText).indexOf("ErrorMessage")) {
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