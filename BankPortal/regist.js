/**
 * Created by denniszo on 12/10/2014.
 */
/************************************************************************************************************
 * if MOVEX is on AS400:
 *  you mast insert the 'gTargetPath' in as 400 as MOVEX M3FileTransfer direction.
 *  'gAS400Adres' is IP address of AS400
 *  'gPath' and 'gPath_test' set path of directions for create file and copy to AS400 M3FileTransfer.
 *  ***************                ***************
 * if MOVEX is on MSserver:
 *   'gTargetPath' and 'gAS400Adres' set to empty
 *   'gPath' and 'gPath_test' set to directions of MOVEX M3FileTransfer direction.
 *
 ************************************************************************************************************/
//MSServer settings
/*
 //AS400 settings
 var gStrFileName="AddVouch.txt";
 var gPath="c:\\\\Racon\\\\prod\\\\";
 var gPath_test="c:\\\\Racon\\\\test\\\\";
 var gINTN="ADDVOUCHER";
 var AS400server=true; //if MOVEX run on AS400 server
 var gTargetPath="M3FileTransferPit//";
 var gAS400Adres="200.0.0.67";
 */


var gStrFileName = "AddVouch.txt";
var gPath = "d:\\\\Lawson\\\\M3FileTransferInt\\\\";
var gPath_test = "d:\\\\Lawson\\\\M3FileTransferInt\\\\";
var gINTN = "ADDVOUCHER";
var AS400server = false; //if MOVEX run on AS400 server
var gAS400Adres = "";
var gTargetPath = "";


var gRNNO = 0;
var gSuperVono = "";
var gBank = "";
var gArat = 0;
var timerConter = 0;
var bankAmount = 0;
var gEmmaunSelected = 0;
var gSelRows;
var gTransYear = new Array();
var gJournalNo = new Array();
var gJournalSeqNo = new Array();
var gVONO = new Array();
var gVSER = new Array();
var gType = false; //if true = {תנוע מרוקזת}

var gAitpSerch = "";

function GetServerTime(par) {
    console.log("-----------------------regist.GetServerTime(par)--------------------------------");
    console.log("par is= " + par);

    var program = 'GENERAL';
    var transaction = 'GetServerTime';
    var returncols = [];
    var inputFields = "";
    var anserAtt = RunApi_OneAnswer(program, transaction, returncols, inputFields);

    console.log("is error ? " + anserAtt.error);
    if (anserAtt.error != undefined) {
        alert(ApiError.error);
        console.log("-------------------------------------------------------")
        return -1;
    } else {
        console.log("-------------------------------------------------------")
        return 0;
    }
    var date, time;
    for (var key in anserAtt) {
        var value = anserAtt[key];
        console.log(key + "=" + value);
        if (key == "DATE") date = value;
        if (key == "TIME") time = value;
    }
    console.log("date= " + date + " and time= " + time);
    console.log("-------------------------------------------------------")

    if (par == "time") {
        return time;
    }
    if (par == "date") {
        return date;
    }
    return date;
}

function btnRedistRec() {



    //  TODO- delete this 2 rows

    $('#mdRegist').modal('show');
    return

    //

    var amount = 0;
    var amountGL = 0;

    // var GLRows = setGLArry();
    //  console.log(BankRows[0].BDVONO);

    var selRows = setBankTabelArry();
    if (selRows < 1) {
        top.alert("לא נבחרו שורות בתנועות בנק");
        return;
    }
    for (i = 0; i < selRows.length; i++) {//run on selected rows to count amount
        var rowDate = selRows[i].BDVSER; //dennis 15.11.2010
        if (rowDate < dateSTART || rowDate > dateEND) { //dennis 15.11.2010
            console.log("rowDate= " + rowDate + " dateSTART= " + dateSTART + " dateEND= " + dateEND)
            var ckno = selRows[i].BDCKNO;	 //dennis 15.11.2010
            //top.alert(" תאריך "+rowDate+" לא בתוקף הפונקציה "+func+"\n אסמחתה:"+ckno); //dennis 15.11.2010
            alert("לא ניתן לרשום פק' יומן לתאריך" + rowDate + "מאסמכתא" + " " + ckno + ".\nיש לצאת ולשנות תוקף של פונקציה "); //dennis 15.11.2010
            //TODO set return if not developer !!!
            // return;
        }


        amount = amount + parseFloat(selRows[i].BDBLAM);
        alert("amount1= " + amount);
    }
    var bank = chosenBkid;

    // get GL
    var selRowsGL = setGLArry();
    if (selRowsGL == null) {
        gType = false;
    } else {
        gType = true;
        for (i = 0; i < selRowsGL.length; i++) {//run on selected rows to count amount
            // amountGL=amountGL+parseFloat(selRowsGL[i].EGCUAM);
            alert("amountGL1= " + amountGL);
        }
    }
    gBank = ChosenAit1;//getBankNumber(bank);
    // alert(gBank);

    amount = amount - amountGL;
    //alert("amount2= "+amount);
    amount = Math.round(amount * 100) / 100;
    //alert("amount3= "+amount);
    if (gType && amount == 0) {
        top.alert("סכום תנועות בפקודה מרוקזת לא יכול להיות 0");
        return;
    }

    $('#mdRegist').modal('show');

    //TODO from here
    return;
    var dialog = pageContext.getComponentById("dlgREGIST");
    //alert(searchValue);
    if (gType) {
        dialog.setWidth("350");
    } else {
        dialog.setWidth("200");
    }

    bankAmount = amount; //to check after regist if all job done well
    //alert("bankAmount= "+bankAmount); //de1
    dialog.setHeight("335");
    dialog.setTop(screen.height / 2);
    dialog.setLeft(screen.width / 2);
    //.setTop(((screen.height*0.5)-(170*0.5)));
    //dialog.setLeft(((screen.width*0.5)-(650*0.5)));

    dialog.setTitle("רשום פקודות יומן");

    dialog.invokeMethod("start", amount, top.ErrorMessage.TYPE_ERROR, gType, dateSTART, dateEND);
    dialog.show();


}


function serchName(str){
    console.log(str);
    if(str.trim().length<1) str="";
    CleareTable();
    getAITPSerch(gAitpSerch,str,"")

}
function serchNumber(str){
    console.log(str);
    if(str.trim().length<1) str="";
    CleareTable();
    getAITPSerch(gAitpSerch,"",str)

}
function getAITP(aitp,number){
    CleareTable();
    gAitpSerch = aitp;
    if(number.trim().length<1) number="";
    $('#srhName').val("");
    getAITPSerch(gAitpSerch,"",number);
}
function getAITPSerch(aitp,name,number) {// get from SQL aitp table
    if(isNaN(aitp) ) return;
    var url = "Queries/sqlGetAITP.jsp?cono=" + gCONO + "&divi=" + gDIVI + "&aitp=" + aitp+"&name="+name+"&number="+number;
    console.log("sqlGetAITP");
    $.ajax({
        cache: false,
        async: true,
        "url": url,
        success: processSuccess,
        error: processError
    });
    console.log("dennis")
    function processSuccess(data, status, req) {
        if (status == "success") {
            var obj = $.parseJSON(req.responseText);
            $.each(obj, function (idx, el) {
                if (idx != "MIRecord") {
                } else {
                    var classTo_TR = "";

                    var id = "";
                    var txt = "";
                    var etr = 0;
                    for (var i = 0; i < el.length; i++) {
                        //console.log(el[i].RowIndex);
                        for (var j = 0; j < el[i].NameValue.length; j++) {
                            if (el[i].NameValue[j].Name == "EAAITM") {
                                id = el[i].NameValue[j].Value;
                            }
                            if (el[i].NameValue[j].Name == "EATX40") {
                                txt = el[i].NameValue[j].Value;
                            }

                        }
                        etr++;
                       // console.log(etr + " " + "| id=" + id + " | txt= " + txt);
                        $('#tblSerch').append("" +
                        "<tr id='row_" + (i + 1) + "' " + classTo_TR + " onclick='selectRow(this)'>" +
                        "<td>" + id + "</td>" +
                        "<td>" + txt + "</td>" +
                        "</tr>");
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


function No_Selected() {

}

function getBankNumber(bank) {
    url = "Queries/sqlGetBkid.jsp?params=cono;" + gCONO + "AND BCBKID='" + bank + "';divi;" + gDIVI;

    $.ajax({
        cache: false,
        async: false,
        "url": url,
        success: processSuccess,
        error: processError
    });

    function processSuccess(data, status, req) {
        if (status == "success") {
            var obj = $.parseJSON(req.responseText);
            $.each(obj, function (idx, el) {
                if (idx == "MIRecord") {
                    var elID = "";
                    var elDESC = "";
                    var elAIT1 = "";
                    for (var i = 0; i < el.length; i++) {
                        for (var j = 0; j < el[i].NameValue.length; j++) {
                            if (el[i].NameValue[j].Name == "BCAIT1") {
                                elAIT1 = el[i].NameValue[j].Value;
                                alert("elAIT1= " + elAIT1);
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

    /*
     var strSQLParameter = gDIVI;
     var idspc = pageContext.getComponentById("idspConnector");
     var request = idspc.createRequest();
     request.setServiceDependency("mie_GetBkid");
     request.clearBatch();
     //set parameters
     request.setParameter("cono", gCONO+" AND BCBKID='"+bank+"' ");//set parameter for MIE
     request.setParameter("div", strSQLParameter);

     request.setFeature("synchronous", "true");
     //execute request
     var response = request.execute();
     if (response != null) {
     var result = response.getInvocationResult();
     if (result != null && !result.hasError()) {
     var it = result.createIterator();
     if (it.hasNext()) {
     var item = it.next();
     var par= result.getItemValue(item, "BCAIT1");
     par=AddLeadSpace(par, 8);
     return par;

     }
     return "000";
     } // if result
     } //if response

     return "   ";
     */
    return "";
}

function Do_regist_compres(arrAit, date) {

    /*************************************************
     * Compressed file
     * sending one row to one date
     * the amount is total for all date.
     * the parameters are taken from first row
     *************************************************/
    alert("compres date is: " + date + " bankAmount= " + bankAmount);
    return;
    var strAit = "";
    for (var i = 0; i < arrAit.length; i++) {
        arrAit[i] = AddLeadSpace(arrAit[i], 8);
        strAit = strAit + arrAit[i];
    }
    //alert ("strAit= "+strAit);
    var lineStringBANK = "";
    var lineStringEXP = "";
    var lineString = "";
    var tempString = "";
    var BankRows = pageContext.getComponentById("tblBankTrans").getSelectedRows();
    //parameters to file
    var ID = "I1";
    var rnno = findRNNO();//get rnno no
    var dbcr = "";
    var eicd = "0";
    var AtiBank = AddLeadSpace(" ", 48);
    var acqt = AddLeadSpace(" ", 17);
    var tmpSubmitLin = "@@";
    var cucd = BankCucd();
    //var strCuam;
    //var date=""; //dellitet for MIA dennis 20/02/2012
    var arat = "";
    var vtxt = "";
    var cuam = "";
    var strCuam = "";
    var strAcam = "";
    var temDate = "";
    var acam = 0;
    var bopc = "";//dennis 16.11.2010
    var ocdt = "";//dennnis 16.11.2010 -
    var ckno = "";//dennis 18.11.2010
    var bkid = pageContext.getComponentById("ddlBkid").getValue();//dennis 18.11.2010
    var rnno2 = AddLeadZero(rnno, 19);
    gRNNO = rnno2;
    for (i = 0; i < BankRows.length; i++) {//run on selected rows
        //date=parseFloat(BankRows[i].getValueByField("BDCURD"));//only from first row in date //dellitet for MIA dennis 20/02/2012
        if (date != temDate) {
            ocdt = temDate;////dennis 16.11.2010
            if (i > 0) {
                /************************************************
                 * insert parameters from row to one string
                 ************************************************/
                    //row 1
                ckno = AddLeadZero(BankRows[i].getValueByField("BDCKNO"), 15);//dennis 18.11.2010
                ckno = bkid + ckno;//dennis 18.11.2010
                acam = acam = Math.floor(acam * 100) / 100;
                strAcam = AddLeadZeroMuny(acam, 17);
                strCuam = AddLeadZeroMuny(bankAmount, 17)//dennis 20/02/2012 - before was-> strCuam=AddLeadZeroMuny(cuam, 17);
                lineStringBANK = ID + rnno + gDateTOday + gDIVI + eicd + gBank + AtiBank + acqt + cucd + "01" + arat + strCuam + temDate + "00" + vtxt + dbcr + strAcam + bopc + ocdt + ckno + rnno2 + tmpSubmitLin;//string for Bank side

                //row 2 -negative from row 1

                cuam = cuam * -1;
                acam = acam * -1
                acam = acam = Math.floor(acam * 100) / 100;
                strAcam = AddLeadZeroMuny(acam, 17);
                strCuam = AddLeadZeroMuny((bankAmount * -1), 17)//dennis 20/02/2012 - before was-> strCuam=AddLeadZeroMuny(cuam, 17);
                if (cuam < 0) {
                    dbcr = "C";
                    bopc = "CK";//dennis 16.11.2010

                } else {
                    dbcr = "D";
                    bopc = "CS";//dennis 16.11.2010
                }
                lineStringEXP = ID + rnno + gDateTOday + gDIVI + eicd + strAit + acqt + cucd + "01" + arat + strCuam + temDate + "00" + vtxt + dbcr + strAcam + bopc + ocdt + ckno + rnno2 + tmpSubmitLin;//string for Expense side
                //lineStringEXP = "";
                lineString = lineString + lineStringBANK + lineStringEXP; //String to connect all rows in selected rows

                /**************************************************/
                lineStringBANK = "";
                lineStringEXP = "";
                cuam = "";
                strCuam = "";
                dbcr = "";

            }

            temDate = date;
            ocdt = temDate;//dennis 16.11.2010
            arat = GetARAT(date, cucd, gDIVI); //only from first row in date
            if (arat == "000000.000000") {
                arat = GetARAT(date, cucd, "");
            }
            vtxt = AddLeadSpace(BankRows[i].getValueByField("BDRFFD"), 40);//only from first row in date
            cuam = parseFloat(BankRows[i].getValueByField("BDBLAM"));//amount

            var dmcu = BankConver();//dennis 12/03/2012
            //acam=bankAmount*gArat;

            if (dmcu == "1") {
                acam = bankAmount * gArat;
            } else {
                if (dmcu == "2" && gArat != 0) {
                    acam = bankAmount / gArat;
                }
            }

            acam = acam = Math.floor(acam * 100) / 100;
            if (cuam < 0) {
                dbcr = "C";
                bopc = "CK";//dennis 16.11.2010
            } else {
                dbcr = "D";
                bopc = "CS";//dennis 16.11.2010
            }
            ckno = AddLeadZero(BankRows[i].getValueByField("BDCKNO"), 15);//dennis 18.11.2010
            ckno = bkid + ckno;//dennis 18.11.2010
        } else {
            var temCuam = parseFloat(BankRows[i].getValueByField("BDBLAM"));//amount
            cuam = cuam + temCuam;

            var dmcu = BankConver();//dennis 12/03/2012
            //acam=bankAmount*gArat;

            if (dmcu == "1") {
                acam = bankAmount * gArat;
            } else {
                if (dmcu == "2" && gArat != 0) {
                    acam = bankAmount / gArat;
                }
            }

            acam = acam = Math.floor(acam * 100) / 100;
            if (cuam < 0) {
                dbcr = "C";
                bopc = "CK";//dennis 16.11.2010
            } else {
                dbcr = "D";
                bopc = "CS";//dennis 16.11.2010
            }
            ckno = AddLeadZero(BankRows[i].getValueByField("BDCKNO"), 15);//dennis 18.11.2010
            ckno = bkid + ckno;//dennis 18.11.2010
        }
    }//end for

    /************************************************
     * insert parameters from row to one string
     ************************************************/
        //row 1
        //strCuam=AddLeadZeroMuny(cuam, 17);
    strCuam = AddLeadZeroMuny(bankAmount, 17)//dennis 20/02/2012 - before was-> strCuam=AddLeadZeroMuny(cuam, 17);
    strAcam = AddLeadZeroMuny(acam, 17);
    lineStringBANK = ID + rnno + gDateTOday + gDIVI + eicd + gBank + AtiBank + acqt + cucd + "01" + arat + strCuam + temDate + "00" + vtxt + dbcr + strAcam + bopc + ocdt + ckno + rnno2 + tmpSubmitLin;//string for Bank side
    //row 2 -negative from row 1
    cuam = cuam * -1;
    //strCuam=AddLeadZeroMuny(cuam, 17);
    strCuam = AddLeadZeroMuny((bankAmount * -1), 17)//dennis 20/02/2012 - before was-> strCuam=AddLeadZeroMuny(cuam, 17);
    acam = acam * -1;
    strAcam = AddLeadZeroMuny(acam, 17);
    if (cuam < 0) {
        dbcr = "C";
    } else {
        dbcr = "D";
    }
    lineStringEXP = ID + rnno + gDateTOday + gDIVI + eicd + strAit + acqt + cucd + "01" + arat + strCuam + temDate + "00" + vtxt + dbcr + strAcam + bopc + ocdt + ckno + rnno2 + tmpSubmitLin;//string for Expense side
    //lineStringEXP = "";
    lineString = lineString + lineStringBANK + lineStringEXP; //String to connect all rows in selected rows

    /**************************************************/
    lineStringBANK = "";
    lineStringEXP = "";
    cuam = "";
    strCuam = "";
    dbcr = "";


    //alert("Compressed- lineString= "+lineString);
    SendLine(lineString);

    top.QuickSwitchMessage.setLoading(true);  // progress bar on
    document.body.style.cursor = 'wait'
    window.setTimeout("StartAPI()", 500);
}

function Do_regist(arrAit) {
    /**********************************************************
     * Detailed File
     * Sending all selected rows to separate rows  in file
     **********************************************************/
    alert("not Comoress");
    return;
    var strAit = "";
    for (var i = 0; i < arrAit.length; i++) {
        arrAit[i] = AddLeadSpace(arrAit[i], 8);
        strAit = strAit + arrAit[i];
    }
    //alert ("strAit= "+strAit);
    var lineStringBANK = "";
    var lineStringEXP = "";
    var lineString = "";
    var tempString = "";
    var BankRows = pageContext.getComponentById("tblBankTrans").getSelectedRows();
    //parameters to file
    var ID = "I1";
    var rnno = findRNNO();//get rnno no
//	alert("rnno seted = "+rnno);  
    var dbcr = "";
    var eicd = "0";
    var AtiBank = AddLeadSpace(" ", 48);
    var acqt = AddLeadSpace(" ", 17);
    var tmpSubmitLin = "@@";
    var cucd = BankCucd();
    var acam = 0;
    var bopc = "";//dennis 16.11.2010
    var ocdt = "";//dennnis 16.11.2010 -
    var ckno = "";//dennis 18.11.2010
    var bkid = pageContext.getComponentById("ddlBkid").getValue();//dennis 18.11.2010

    for (i = 0; i < BankRows.length; i++) {//run on selected rows
        var date = parseFloat(BankRows[i].getValueByField("BDCURD"));
        ocdt = date;//dennis 16.11.2010
        var arat = GetARAT(date, cucd, gDIVI);
        if (arat == "000000.000000") {
            arat = GetARAT(date, cucd, "");
        }
        var vtxt = AddLeadSpace(BankRows[i].getValueByField("BDRFFD"), 40);
        var cuam = parseFloat(BankRows[i].getValueByField("BDBLAM"));
        acam = cuam * gArat;
        acam = Math.floor(acam * 100) / 100;
        var strAcam = AddLeadZeroMuny(acam, 17);
        var strCuam = AddLeadZeroMuny(cuam, 17);
        if (cuam < 0) {
            dbcr = "C";
            bopc = "CK";//dennis 16.11.2010
        } else {
            dbcr = "D";
            bopc = "CS";//dennis 16.11.2010
        }
        ckno = AddLeadZero(BankRows[i].getValueByField("BDCKNO"), 15);//dennis 18.11.2010
        ckno = bkid + ckno;//dennis 18.11.2010

        /************************************************
         * insert parameters from row to one string
         ************************************************/

        lineStringBANK = ID + rnno + gDateTOday + gDIVI + eicd + gBank + AtiBank + acqt + cucd + "01" + arat + strCuam + date + "00" + vtxt + dbcr + strAcam + bopc + ocdt + ckno + tmpSubmitLin;//string for Bank side
        acam = acam * -1;
        //acam=Math.floor(acam*100)/100;
        var strAcam = AddLeadZeroMuny(acam, 17);
        cuam = cuam * -1;
        strCuam = AddLeadZeroMuny(cuam, 17);
        if (cuam < 0) {
            dbcr = "C";
            bopc = "  ";
        } else {
            dbcr = "D";
            bopc = "  ";
        }
        lineStringEXP = ID + rnno + gDateTOday + gDIVI + eicd + strAit + acqt + cucd + "01" + arat + strCuam + date + "00" + vtxt + dbcr + strAcam + bopc + ocdt + ckno + tmpSubmitLin;//string for Expense side
        //lineStringEXP = "";
        lineString = lineString + lineStringBANK + lineStringEXP; //String to connect all rows in selected rows

        /**************************************************/
    }//end for

//	alert("Detailed- lineString= "+lineString);
    SendLine(lineString);

    top.QuickSwitchMessage.setLoading(true);  // progress bar on
    document.body.style.cursor = 'wait'
    window.setTimeout("StartAPI()", 500);

}
function SendLine(tmpSubmitLine) {

    //add string to file
    document.all.Line.value = tmpSubmitLine;
    var Path = "";
    if (MIEAppID.indexOf("TEST") == -1) {
        Path = gPath;
    } else {
        Path = gPath_test;
    }

    document.all.FileName.value = Path + gStrFileName;
    document.all.DeleteFile.value = "";
    frm.action = "CreateFile.jsp";
    var WinParam = "height=360,width=400,status=no,toolbar=no,menubar=no,location=no,titlebar=no,top=150,left = 250";
    window.open("blank.jsp", "Smit", WinParam);
    frm.submit();

    //return;////den
    if (AS400server) {
        //send file to AS400
        var typi = "AddVouch";
        var Path = gPath;
        var TargetPath = gTargetPath;
        document.all.FileName.value = Path + gStrFileName;
        document.all.AS400Adres.value = gAS400Adres;
        document.all.TargetFileName.value = TargetPath + gStrFileName
        document.all.DeleteFile.value = "";
        document.all.Type.value = typi;
        //alert(del);
        frm.action = "CopyToAS400.jsp";
        var WinParam = "height=360,width=400,status=no,toolbar=no,menubar=no,location=no,titlebar=no,top=150,left = 250";
        window.open("blank.jsp", "Smit", WinParam);

        frm.submit();
    }
}

function AddLeadZeroMuny(tmpTxt, tmpLen) {
    var negativNumberFlag = false;
    var FlagbigNum = false;
    var FlagMidNum = false;
    if (tmpTxt < 0) {//negative Number
        negativNumberFlag = true;
        tmpTxt = tmpTxt * -1;
        tmpLen = tmpLen - 1;
    }

    tmpTxt = tmpTxt.toString();
    for (var i = 0; i < tmpTxt.length; i++) { //check if number whis .00
        if (tmpTxt.charAt(i) == ".") {
            FlagbigNum = true;
            var tpmSplit = tmpTxt.split(".");
            if (tpmSplit[1].length == 2) {
                FlagMidNum = true;//after "." is two numbers
            }

            break;
        }
    }
    if (!FlagbigNum) {
        tmpLen = tmpLen - 3;//edd "0" to integer number (no ".00")
    } else {
        if (!FlagMidNum) {
            tmpLen = tmpLen - 1;
        }
    }

    var n = tmpLen - tmpTxt.length;
    var tmpSpc = "";


    if (n > 0) {
        for (var i = 0; i < n; i++) {
            tmpSpc = tmpSpc.concat("0");
        }
    }
    if (!FlagbigNum) {
        tmpTxt = tmpTxt + ".00";
    } else {
        if (!FlagMidNum) {
            tmpTxt = tmpTxt + "0";
        }
    }

    if (negativNumberFlag) {//negative Number
        tmpTxt = "-" + tmpSpc + tmpTxt;
    } else {
        tmpTxt = tmpSpc + tmpTxt;
    }

    return tmpTxt;
}

function AddLeadZero(tmpTxt, tmpLen) {
    tmpTxt = tmpTxt.toString();
    var n = tmpLen - tmpTxt.length;
    var tmpSpc = "";

    if (n > 0) {
        for (var i = 0; i < n; i++) {
            tmpSpc = tmpSpc.concat("0");
        }
    }

    return tmpSpc.concat(tmpTxt);
}

function AddLeadSpace(tmpTxt, tmpLen) {
    //alert("AddLeadSpace - tmpTxt= "+tmpTxt+" tmpLen"+tmpLen);
    tmpTxt = tmpTxt.toString();
    var n = tmpLen - tmpTxt.length;
    var tmpSpc = "";

    if (n > 0) {
        for (var i = 0; i < n; i++) {
            tmpSpc = tmpSpc.concat(" ");
        }
    }
    tmpTxt = tmpTxt + tmpSpc;
    return tmpTxt;
}

function findRNNO() { //get last number of transaction

    var rnno = "1";

    var idspc = pageContext.getComponentById("idspConnector");
    var request = idspc.createRequest();
    request.setServiceDependency("mie_GetRNNO");
    request.clearBatch();
    //set parameters
    request.setParameter("cono", gCONO);
    request.setParameter("div", gDIVI);
    //request.setParameter("user", gUSER);

    request.setFeature("synchronous", "true");
    //execute request
    var response = request.execute();
    if (response != null) {
        var result = response.getInvocationResult();
        if (result != null && !result.hasError()) {
            var it = result.createIterator();
            if (it.hasNext()) {
                var item = it.next();
                rnno = result.getItemValue(item, "DARNNO");
                rnno = parseInt(rnno);
                //	alert("Before rnno "+rnno);
                rnno = rnno + 1;
                rnno = AddLeadZero(rnno, 9);
                //alert("rnno "+rnno);
                return rnno;
            } else {
                rnno = "1";
            }
            //alert("ELSE Before rnno "+rnno);
            rnno = AddLeadZero(rnno, 9);
            //	alert("rnno "+rnno);
            return rnno;
        } // if result
    } //if response

    return 0;


}

function BankCucd() {
    var bkid = pageContext.getComponentById("ddlBkid").getValue();
    //alert("bkid= "+bkid);
    var idspc = pageContext.getComponentById("idspConnector");
    var request = idspc.createRequest();
    request.setServiceDependency("mie_getCucd");
    request.clearBatch();
    //set parameters
    request.setParameter("cono", gCONO);
    request.setParameter("div", gDIVI);
    request.setParameter("bkid", bkid);

    request.setFeature("synchronous", "true");
    //execute request
    var response = request.execute();
    if (response != null) {
        var result = response.getInvocationResult();
        if (result != null && !result.hasError()) {
            var it = result.createIterator();
            if (it.hasNext()) {
                var item = it.next();
                return result.getItemValue(item, "BCCUCD");
            }
            return "000";
        } // if result
    } //if response

    return "   ";
}

function BankConver() {
    var bkid = pageContext.getComponentById("ddlBkid").getValue();
    //alert("bkid= "+bkid);
    var idspc = pageContext.getComponentById("idspConnector");
    var request = idspc.createRequest();
    request.setServiceDependency("mie_GetCucdConver");
    request.clearBatch();
    //set parameters
    request.setParameter("cono", gCONO);
    request.setParameter("div", gDIVI);

    request.setFeature("synchronous", "true");
    //execute request
    var response = request.execute();
    if (response != null) {
        var result = response.getInvocationResult();
        if (result != null && !result.hasError()) {
            var it = result.createIterator();
            if (it.hasNext()) {
                var item = it.next();
                return result.getItemValue(item, "CCDMCU");
            }
            return "0";
        } // if result
    } //if response

    return "0";
}

function GetARAT(date, cucd, my_divi) {

    var idspc = pageContext.getComponentById("idspConnector");
    var request = idspc.createRequest();
    request.setServiceDependency("mie_GetBankARAT");
    request.clearBatch();
//set parameters
    request.setParameter("cono", gCONO);
    request.setParameter("div", my_divi);
    request.setParameter("date", date);
    request.setParameter("cucd", cucd);

    request.setFeature("synchronous", "true");
//execute request
    var response = request.execute();
    if (response != null) {
        var result = response.getInvocationResult();
        if (result != null && !result.hasError()) {
            var it = result.createIterator();
            if (it.hasNext()) {
                var item = it.next();
                var arat = result.getItemValue(item, "CUARAT");

                var SplitedArat = arat.split(".");
                SplitedArat[0] = AddLeadZero(SplitedArat[0], 6);
                //SplitedArat[1]=AddLeadZero(SplitedArat[1],6);
                //alert("SplitedArat[0]= "+SplitedArat[0]+" SplitedArat[1]= "+SplitedArat[1]);
                gArat = arat;
                arat = SplitedArat[0] + "." + SplitedArat[1];
                return arat;
            }
            return "000000.000000";
        } // if result
    } //if response

    return "ERROR_GetARAT";
}
function StartAPI() {
    timerConter = 0;
    var idspc = pageContext.getComponentById("idspConnector");
    var request = idspc.createRequest();

    request.setServiceDependency("api_ExecTransac");
    request.clearParameters();
    request.setFeature("synchronous", true);

    request.setParameter("CONO", gCONO);
    request.setParameter("DIVI", gDIVI);
    request.setParameter("INTN", gINTN);
    request.setParameter("PCND", gStrFileName);
    request.setParameter("FLDR", gTargetPath);
    request.setParameter("UPCD", "1");
    request.setParameter("CODE", "01"); //remuved 21/03/2012 for MIA

    var response = request.execute();
    var result = response.getInvocationResult();

    if (!result.hasError()) {
        var time = GetServerTime("time");
        window.setTimeout("CheckTrans(" + time + ")", 10000); //whaite 5 second --< ?10
    }
    else {
        if (result != null) {
            top.alert("api_PrcWhsTran: " + result.getErrorMessage());
            top.QuickSwitchMessage.setLoading(false);
            document.body.style.cursor = 'default';
        }
        top.QuickSwitchMessage.setLoading(false);
        document.body.style.cursor = 'default';

    }
}

function CheckTrans(time) {
    var stat = 0;
    var tableModel = pageContext.getComponentById("tblGLTrans").getModel();
    var idspc = pageContext.getComponentById("idspConnector");
    var request = idspc.createRequest();
    request.setServiceDependency("mie_CheckTransStat");
    request.clearBatch();
    //set parameters
    request.setParameter("cono", gCONO);
    request.setParameter("div", gDIVI);
    request.setParameter("intn", gINTN);
    request.setParameter("user", gUSER);
    request.setParameter("date", gDateTOday);
    request.setParameter("time", time);

    request.setFeature("synchronous", "true");
    //execute request
    var response = request.execute();
    if (response != null) {
        var result = response.getInvocationResult();
        if (result != null && !result.hasError()) {
            var it = result.createIterator();
            if (it.hasNext()) {
                var item = it.next();
                stat = result.getItemValue(item, "DAIFST");
                if (stat == "20") {
                    window.setTimeout("chackAnswer(" + time + ")", 5000); //whaite 5 second! --<

                    return;
                }
                if (stat == "10") {
                    top.QuickSwitchMessage.showMessage("פעולה לא בוצעה", "Close", top.ErrorMessage.TYPE_ERROR, "!!!שגיאה בעת ביצוע הפעולה \n !ממשק קיבל סטטוס 10   \n נא לבדוק ב-GLS850\n לא נוצרה פקודת יומן.");
                    top.QuickSwitchMessage.setLoading(false);
                    document.body.style.cursor = 'default';
                    return;
                }

            } else {
                timerConter++;
                if (timerConter > 11) {
                    top.QuickSwitchMessage.showMessage("פעולה לא בוצעה", "Close", top.ErrorMessage.TYPE_ERROR, "שגיאה בעת ביצוע הפעולה \n אין רשומה חדשה  \n יש לבדוק בקובץ FFIHST");
                    top.QuickSwitchMessage.setLoading(false);
                    document.body.style.cursor = 'default';
                    return;
                } else {
                    window.setTimeout("CheckTrans(" + time + ")", 5000); //dennis , refind ansar.
                    return;
                }
            }

        } // if result
    } else { //if response
        timerConter++;
        if (timerConter > 11) {
            top.QuickSwitchMessage.showMessage("פעולה לא בוצעה", "Close", top.ErrorMessage.TYPE_ERROR, "שגיאה בעת ביצוע הפעולה \n אין רשומה חדשה  \n יש לבדוק בקובץ FFIHST");
            top.QuickSwitchMessage.setLoading(false);
            document.body.style.cursor = 'default';
            return;
        } else {
            window.setTimeout("CheckTrans(" + time + ")", 3000); //dennis , refind ansar.
            return;
        }
    }

    top.QuickSwitchMessage.showMessage("פעולה לא בוצעה", "Close", top.ErrorMessage.TYPE_ERROR, "שגיאה בעת ביצוע הפעולה \n אין רשומה  \n יש לבדוק בקובץ FFIHST");
    top.QuickSwitchMessage.setLoading(false);
    document.body.style.cursor = 'default';
}

/************
 * methods to set automatic  Reconculation
 * add Dennis 10/10/2010
 ************/
function chackAnswer(time) {
    var i = 0;
    var x = 0;
    var WhereString3 = " AND FG.EGTOCD!='9' AND FG.EGCHID='" + gUSER + "' AND FG.EGRGDT='" + gDateTOday + "' AND FG.EGRGTM> '" + time + "'  ";
    var MyDrop = pageContext.getComponentById("ddlBkid");
    var MyModel = MyDrop.getModel();
    var selIndex = MyDrop.getSelectedIndex();
    var ChosenAit1 = MyModel.getElementValueByFieldName(selIndex, "BCAIT1");
    var amount = 0;
    var idspc = pageContext.getComponentById("idspConnector");
    var request = idspc.createRequest();
    request.setServiceDependency("mie_GetGLTransactions");
    request.clearBatch();

    //set parameters
    request.setParameter("ait", ChosenAit1);
    request.setParameter("WhereString", WhereString3);
    request.setParameter("OrderByStr", " FG.EGRGTM ");

    request.setFeature("synchronous", "true");
    //execute request
    var response = request.execute();
    if (response != null) {
        var result = response.getInvocationResult();
        if (result != null && !result.hasError()) {
            var it = result.createIterator();
            while (it.hasNext()) {//EGQEM
                var item = it.next();
                var tmpAmount1 = result.getItemValue(item, "EGCUAM");
                //	alert("tmpAmount1= "+tmpAmount1);
                var tmpAmount = parseFloat(tmpAmount1);
                //alert("amount= "+amount);
                amount = amount + tmpAmount; //to get amount of all work
                //alert("amount= "+amount+" tmpAmount= "+tmpAmount);
                gTransYear[i] = result.getItemValue(item, "TRDATE");
                gJournalNo[i] = result.getItemValue(item, "EGJRNO");
                gJournalSeqNo[i] = result.getItemValue(item, "EGJSNO");
                gSuperVono = result.getItemValue(item, "SHOVAR").substring(3);
                gVONO[i] = result.getItemValue(item, "SHOVAR").substring(3);
                gVSER[i] = result.getItemValue(item, "SHOVAR").substring(0, 3);

                x = i;
                i++;
            }
        } else {
            top.QuickSwitchMessage.showMessage("ERROR chackAnswer-000", "Close", top.ErrorMessage.TYPE_ERROR, "התאמה נכשלה !");
            top.QuickSwitchMessage.setLoading(false);
            document.body.style.cursor = 'default';
            return;
        }
    } else {
        top.QuickSwitchMessage.showMessage("ERROR chackAnswer-001", "Close", top.ErrorMessage.TYPE_ERROR, "התאמה נכשלה !");
        top.QuickSwitchMessage.setLoading(false);
        document.body.style.cursor = 'default';
        return;
    }


//	alert("amount= "+amount+" bankAmount= "+bankAmount);

    if (gType) {//if is compresed dont cheak
        if (setVirtualGL(gTransYear[x], gJournalNo[x], gJournalSeqNo[x], ChosenAit1, i)) {
            i++;
            //alert("i = "+i);//de1
            DoAutoRecon(i);
        } else {
            top.QuickSwitchMessage.showMessage("ERROR DoRecon-000", "Close", top.ErrorMessage.TYPE_ERROR, "התאמה מרוקזת נכשלה !");
            top.QuickSwitchMessage.setLoading(false);
            document.body.style.cursor = 'default';
            return;
        }
    } else {
        /*
         * check amount from GLTransactions to selected bank transactions
         * bankAmount = amount taken from selected rowds is start proses.
         */
        if (amount == bankAmount) {
            DoAutoRecon(i);
        } else {
            top.QuickSwitchMessage.showMessage("ERROR DoRecon-00", "Close", top.ErrorMessage.TYPE_ERROR, "לא מצליח לפתוח התאמה, לא תואמים");
            top.QuickSwitchMessage.setLoading(false);
            document.body.style.cursor = 'default';
            return;
        }
    }

    top.QuickSwitchMessage.setLoading(false);
    document.body.style.cursor = 'default';
    var tableModel = pageContext.getComponentById("tblGLTrans").getModel();
    tableModel.refresh();
    var table = pageContext.getComponentById("tblBankTrans").getModel();
    table.refresh();
    top.QuickSwitchMessage.setLoading(false);
    document.body.style.cursor = 'default';
    return;
}

function DoAutoRecon(counter) {
    //alert("counter is "+counter);
    var TransDate;
    var LineNo;


    if (StartReco() != 0) //start reco succeded ?
    {
        top.QuickSwitchMessage.showMessage("ERROR DoRecon-01", "Close", top.ErrorMessage.TYPE_ERROR, "פתיחת התאמה נכשלה !");
        top.QuickSwitchMessage.setLoading(false);
        document.body.style.cursor = 'default';
        return;
    }

    top.QuickSwitchMessage.showMessage("פעולה", "Close", top.ErrorMessage.TYPE_INFORMATION, "מספר שובר שנוצר: " + gSuperVono);

    var selRows = pageContext.getComponentById("tblBankTrans").getSelectedRows();
    for (var i = 0; i < selRows.length; i++) {
        TransDate = selRows[i].getValueByField("BDSDRC");
        LineNo = selRows[i].getValueByField("BDALLN")
        if (AddBankTrans(TransDate, LineNo) != 0) //error occured
        {
            DeleteReco();
            top.QuickSwitchMessage.showMessage("ERROR DoRecon-02", "Close", top.ErrorMessage.TYPE_ERROR, "התאמה נכשלה !");
            top.QuickSwitchMessage.setLoading(false);
            document.body.style.cursor = 'default';
            return;
        }


    }
    //alert("counter= "+counter);//de1
    for (var i = 0; i < counter; i++) {
        //alert("i= "+i)//de1
        //alert("year= "+gTransYear[i].substring(0,4)+" JRNO= "+gJournalNo[i]+" JSNO= "+gJournalSeqNo[i]+" VONO= "+gVONO[i]+" VSER= "+gVSER[i]);
        if (AddGLTransNEW(gTransYear[i].substring(0, 4), gJournalNo[i], gJournalSeqNo[i], gVONO[i], gVSER[i]) != 0) //error occured
        {
            DeleteReco();
            top.QuickSwitchMessage.showMessage("ERROR DoRecon-03", "Close", top.ErrorMessage.TYPE_ERROR, "התאמה נכשלה !");
            top.QuickSwitchMessage.setLoading(false);
            document.body.style.cursor = 'default';
            return;
        }
    }
    if (EndReco() != 0) {
        DeleteReco();
        top.QuickSwitchMessage.showMessage("ERROR DoRecon-04", "Close", top.ErrorMessage.TYPE_ERROR, "התאמה נכשלה !");
        return;
    }

    top.QuickSwitchMessage.showMessage("פעולה בוצע בהצלחה", "Close", top.ErrorMessage.TYPE_INFORMATION, "הפקודה נקלטה בספרים");

    return;
}

//virt
function setVirtualGL(transYear, journalNo, journalSeqNo, ChosenAit1, count) {
    var selRows = pageContext.getComponentById("tblGLTrans").getSelectedRows();
    for (i = 0; i < selRows.length; i++) {
        if (i != 0) {
            count++;
        }
        var GLtransYear = selRows[i].getValueByField("TRDATE");
        var journalNo = selRows[i].getValueByField("EGJRNO");
        var journalAIT1 = ChosenAit1;
        var vSER = selRows[i].getValueByField("SHOVAR").substring(0, 3);
        var vONO = selRows[i].getValueByField("SHOVAR").substring(3);
        //alert("transYear= "+transYear+" journalNo= "+journalNo+" ChosenAit1= "+ChosenAit1+" count= "+count);

        var idspc = pageContext.getComponentById("idspConnector");
        var request = idspc.createRequest();
        request.setServiceDependency("mie_getVirtualRNNO");
        request.clearBatch();

        //set parameters
        request.setParameter("cono", gCONO);
        request.setParameter("divi", gDIVI);
        request.setParameter("year", GLtransYear.substring(0, 4));
        request.setParameter("ait", ChosenAit1);
        request.setParameter("vser", vSER);
        request.setParameter("vono", vONO);
        request.setParameter("WhereString", " ");
        request.setFeature("synchronous", "true");
        //execute request
        var response = request.execute();
        if (response != null) {
            var result = response.getInvocationResult();
            if (result != null && !result.hasError()) {
                var it = result.createIterator();
                if (it.hasNext()) {//EGQEM
                    var item = it.next();
                    gTransYear[count] = GLtransYear;
                    gJournalNo[count] = result.getItemValue(item, "EGJRNO");
                    //gJournalSeqNo[count]=result.getItemValue(item, "EGJSNO");
                    gJournalSeqNo[count] = selRows[i].getValueByField("EGJSNO")//from table - dennis
                    gVONO[count] = result.getItemValue(item, "EGVONO");
                    gVSER[count] = result.getItemValue(item, "EGVSER");

                }
            }
        } else {
            return false;
        }

    }
    return true;
}

function AddGLTransNEW(TransYear, JournalNo, JournalSeqNo, nVono, nVser) {
    //alert("year= "+TransYear+" JRNO= "+JournalNo+" JSNO= "+JournalSeqNo+" VONO= "+nVono+" VSER= "+nVser);
    var idspc = pageContext.getComponentById("idspConnector");
    var request = idspc.createRequest();

    request.setServiceDependency("api_AddGLReco");
    request.clearParameters();
    request.setFeature("synchronous", true);

    //Company
    request.setParameter("CONO", gCONO);

    //Division
    request.setParameter("DIVI", gDIVI);

    //Year
    request.setParameter("YEA4", TransYear);

    //Journal no
    request.setParameter("JRNO", JournalNo);

    //Journal seq no
    request.setParameter("JSNO", JournalSeqNo);

    //Acounting dimention 1
    request.setParameter("AIT1", ChosenAit1);

    //voucher no series
    if (nVser != undefined && nVser != null && nVser != "") {
        //	alert("2");
        request.setParameter("VSER", nVser);
    } else {
        request.setParameter("VSER", vser);
    }

    //voucher number
    if (nVono != undefined && nVono != null && nVono != "") {
        //alert("1");
        request.setParameter("VONO", nVono);
    } else {
        request.setParameter("VONO", gSuperVono);
    }

    //Bank account idenity
    request.setParameter("BKID", chosenBkid);

    //changed by
    request.setParameter("CHID", gUSER);

    //execute MI
    var response = request.execute();
    //get result
    var result = response.getInvocationResult();

    if (!result.hasError()) {
        return 0;
    }
    else {
        if (result != null) {
            top.alert("ErrorMessage: " + result.getErrorMessage());
            return -1;
        }
    }
}

function getDateLimet() {//dennis 14.11.2010
///mie_GetNameToLimit
    //alert(1234)
    var url = "Queries/sqlGetDateLimet.jsp?cono=" + gCONO + "&divi=" + gDIVI + "&intn=" + gINTN;
    // url = "sqlGetDateLimet.jsp?params=cono;" + gCONO + ";divi;" + gDIVI;
    $.ajax({
        cache: false,
        async: false,
        "url": url,
        success: processSuccess,
        error: processError
    });
    function processSuccess(data, status, req) {
        console.log("status " + status);
        console.log("req " + status);
        console.log("data " + data);

        if (status == "success" && data != "-1" && data != "0") {
            var obj = $.parseJSON(req.responseText);
            $.each(obj, function (idx, el) {
                if (idx == "MIRecord") {
                    // alert(el[0].NameValue[0].Name);
                    var START_DATE = "";
                    var END_DATE = "";

                    for (var i = 0; i < el.length; i++) {
                        for (var j = 0; j < el[i].NameValue.length; j++) {
                            if (el[i].NameValue[j].Name == "START_DATE") {
                                dateSTART = el[i].NameValue[j].Value;

                            }
                            if (el[i].NameValue[j].Name == "END_DATE") {
                                dateEND = el[i].NameValue[j].Value;
                            }
                        }
                        //alert("dateSTART2= "+dateSTART+" dateEND2= "+dateEND);
                    }

                }
            });
        } else {
            dateSTART = "";
            dateEND = "";
        }
    }

    function processError(data, status, req) {
        alert(req.responseText + " " + status);
    }

    //alert("dateSTART= "+dateSTART+" dateEND= "+dateEND);
    if (dateSTART == "" || dateEND == "") {
        alert(msg23);
    }
}


function selectRow(row){
    $("#dim"+gAitpSerch).val(row.getElementsByTagName("td")[0].innerHTML);
   // row.getElementsByTagName("td")[0].innerHTML
}