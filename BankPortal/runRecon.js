/**
 * Created by denniszo on 29/09/2014.
 */
function ApiTest() {
    console.log("hii");
    var program = 'MMS010MI';
    var transaction = 'ListLocations';
    var returncols = ["SLDS", "RESP"];
    var inputFields = "";
    //'WHLO=110&WHSL=001';
    var anserAtt = RunApi_OneAnswer(program, transaction, returncols, inputFields);
    for (var key in anserAtt) {
        var value = anserAtt[key];
        console.log(key + "=" + value);

    }
}

function DeleteReco() {
    console.log("-----------------------runRecon.DeleteReco()--------------------------------")
    if (vser == "" && vono == "") {
        top.alert(msg5);
        console.log("-------------------------------------------------------")
        return -1;
    }
    var program = 'GLIL02MI';
    var transaction = 'DeleteReco';
    var returncols = [];
    var inputFields = "CONO=" + gCONO + "&DIVI=" + gDIVI + "&BKID=" + chosenBkid + "&CHID=" + gUSER +
        "&VSER=" + vser + "&VONO=" + vono;
    var anserAtt = RunApi_OneAnswer(program, transaction, returncols, inputFields);

    console.log("is error ? " + anserAtt.error);
    if (anserAtt.error != undefined) {
        alert(anserAtt.error);
        console.log("-------------------------------------------------------")
        return -1;
    } else {
        console.log("-------------------------------------------------------")
        return 0;
    }
}
function StartReco() {
    console.log("-----------------------runRecon.StartReco()--------------------------------")
    var program = 'GLIL02MI';
    var transaction = 'StartReco';
    var returncols = ["VSER", "VONO"];
    var inputFields = "CONO=" + gCONO + "&DIVI=" + gDIVI + "&BKID=" + chosenBkid + "&CHID=" + gUSER;
    var anserAtt = RunApi_OneAnswer(program, transaction, returncols, inputFields);

    console.log("is error ? " + anserAtt.error);
    if (anserAtt.error != undefined) {
        alert(anserAtt.error);
        console.log("-------------------------------------------------------")
        return -1;
    }

    for (var key in anserAtt) {
        var value = anserAtt[key];
        console.log(key + "=" + value);
        if (key == "VSER") vser = value;
        if (key == "VONO") vono = value;
    }
    console.log("vser= " + vser + " and vono= " + vono);
    console.log("-----------------End runRecon.StartReco()-------------------------------------")
    return 0;
}

function AddBankTrans(TransDate, LineNo) {
    console.log("----------------------runRecon.AddBankTrans()---------------------------------")
    var program = 'GLIL02MI';
    var transaction = 'AddBankReco';
    var returncols = [];
    var inputFields = "CONO=" + gCONO + "&DIVI=" + gDIVI + "&BKID=" + chosenBkid +
        "&SDRC=" + TransDate + "&ALLN=" + LineNo + "&VSER=" + vser + "&VONO=" + vono +
        "&CHID=" + gUSER;
    var anserAtt = RunApi_OneAnswer(program, transaction, returncols, inputFields);
    console.log("is error ? " + anserAtt.error);
    if (anserAtt.error != undefined) {
        alert(anserAtt.error);
        console.log("-------------------------------------------------------")
        return -1;
    } else {
        console.log("--------------End runRecon.AddBankTrans()-----------------------------------------")
        return 0;
    }
}

function AddGLTrans(TransYear, JournalNo, JournalSeqNo) {
    console.log("----------------------runRecon.AddGLTrans()---------------------------------")
    var program = 'GLIL02MI';
    var transaction = 'AddGLReco';
    var inputFields = "CONO=" + gCONO + "&DIVI=" + gDIVI +
        "&YEA4=" + TransYear + "&JRNO=" + JournalNo + "&JSNO=" + JournalSeqNo + "&AIT1=" + ChosenAit1 +
        "&VSER=" + vser + "&VONO=" + vono +
        "&BKID=" + chosenBkid + "&CHID=" + gUSER;
    console.log("inputFields");
    console.log(inputFields);
    var returncols = [];
    var anserAtt = RunApi_OneAnswer(program, transaction, returncols, inputFields);
    console.log("is error ? " + anserAtt.error);
    if (anserAtt.error != undefined) {
        alert(anserAtt.error);
        console.log("-------------------------------------------------------")
        return -1;
    } else {
        console.log("---------------End runRecon.AddGLTrans()----------------------------------------")
        return 0;
    }

}

function EndReco() {
    console.log("----------------------runRecon.EndReco()---------------------------------")
    var program = 'GLIL02MI';
    var transaction = 'EndReco';
    var inputFields = "CONO=" + gCONO + "&DIVI=" + gDIVI +
        "&AIT1=" + ChosenAit1 +
        "&BKID=" + chosenBkid + "&CHID=" + gUSER+
        "&VSER=" + vser + "&VONO=" + vono ;
    var returncols = [];
    var anserAtt = RunApi_OneAnswer(program, transaction, returncols, inputFields);
    console.log("is error ? " + anserAtt.error);
    if (anserAtt.error != undefined) {
        alert(anserAtt.error);
        console.log("-------------------------------------------------------")
        return -1;
    } else {
        console.log("-------------End runRecon.EndReco()------------------------------------------")
        return 0;
    }
}

