/**
 *
 */

function OBJ_TableBK(bdcurd, bdblam, bdckno, pageno, bdalln, bdrffd, bdlmdt, bdvono,bdsdrs,bdbkid,bdvser) {
    this.BDCURD = bdcurd;
    this.BDBLAM = bdblam;
    this.BDCKNO = bdckno;
    this.PAGENO = pageno;
    this.BDALLN = bdalln;
    this.BDRFFD = bdrffd;
    this.BDLMDT = bdlmdt;
    this.BDVONO = bdvono;
    this.BDSDRC = bdsdrs;
    this.BDBKID = bdbkid;
    this.BDVSER = bdvser;

};

function OBJ_TableGL(trdate, egcuam, chkno, egjrno, shovar, egjsno, egvtxt, egerdt, recno,vser) {
    this.TRDATE = trdate;
    this.EGCUAM = egcuam;
    this.CHKNO = chkno;
    this.EGJRNO = egjrno;
    this.SHOVAR = shovar;
    this.EGJSNO = egjsno;
    this.EGVTXT = egvtxt;
    this.EGERDT = egerdt;
    this.RECNO = recno;
    this.VSER = vser;
};

/*
 * create bank row arr of -OBJ_TableBK-
 * return Array of all selected rows
 */
function setBankTabelArry() {
    var arrBankRows = new Array();
    var tableBK = $('#tblBankTrans').DataTable();
    $.each(gSelectedRows_BK, function(index, value) {
        var row = new OBJ_TableBK(tableBK.row(value).data()["BDCURD"], tableBK.row(value).data()["BDBLAM"], tableBK.row(value).data()["BDCKNO"], tableBK
        .row(value).data()["PAGENO"], tableBK.row(value).data()["BDALLN"], tableBK
        .row(value).data()["BDRFFD"], tableBK.row(value).data()["BDLMDT"], tableBK
        .row(value).data()["BDVONO"],tableBK.row(value).data()["BDSDRC"],tableBK.row(value).data()["BDBKID"],tableBK.row(value).data()["BDVSER"]);

        arrBankRows.push(row);
    });

    return arrBankRows;
}

/*
 * create GL row arr of -OBJ_TableBK-
 * return Array of all selected rows
 */
function setGLArry() {
    var arrGLRows = new Array();
    var tableBK = $('#tblGLTrans').DataTable();
    $.each(gSelectedRows_GL, function(index, value) {
        var row = new OBJ_TableGL(tableBK.row(value).data()["TRDATE"], tableBK.row(value).data()["EGCUAM"], tableBK.row(value).data()["CHKNO"], tableBK
        .row(value).data()["EGJRNO"], tableBK.row(value).data()["SHOVAR"], tableBK
        .row(value).data()["EGJSNO"], tableBK.row(value).data()["EGVTXT"], tableBK
        .row(value).data()["EGERDT"], tableBK.row(value).data()["RECNO"],tableBK.row(value).data()["VSER"]);

        arrGLRows.push(row);
    });

    return arrGLRows;
}

