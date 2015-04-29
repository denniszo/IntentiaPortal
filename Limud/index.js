var gCONO="";
var gUSER="";
var gDIVI="";

function onLoad(){
	// alert("שלום");
	var anser = API_getCurrentUser();
	if(anser != "1"){
		alert(anser);
		return;
	}
	set_ddlStat() ;
}

/*******************************************************************************
 * get user parameters from M3 CONO, DIVI, USID
 * 
 * @returns error text, if no error the text is empty
 */
function API_getCurrentUser() {
	
    console.log("-----------------------RUN GENERAL.GetUserInfo--------------------------------")
    var program = 'GENERAL';
    var transaction = 'GetUserInfo';
   // var maxrecs = 100;
    var returncols = 'ZZUSID,ZDCONO,ZDDIVI';
    var inputFields;
    
    var anserAtt = RunApi_OneAnswer(program, transaction, returncols, inputFields);

    console.log("is error ? " + anserAtt.error);
    if (anserAtt.error != undefined) {
        console.log("---------------------------Error----------------------------")
        console.log(anserAtt.error);
        console.log("-------------------------------------------------------")
        return anserAtt.error;
    }

    for (var key in anserAtt) {
        var value = anserAtt[key];
        console.log(key + "=" + value);
        if (key == "ZZUSID") gUSER = value;
        if (key == "ZDCONO") gCONO = value;
        if (key == "ZDDIVI") gDIVI = value;
    }
    console.log("user= " + gUSER + " and cono= " + gCONO+ " and divi= " + gDIVI);
    console.log("-----------------End GENERAL.GetUserInfo-------------------------------------")
    return "1";
}

/*******
 * set drop down stats from  MITMAS
 *******/
function set_ddlStat() {
    var url = "getAllStats.jsp?cono="+gCONO;
    $.ajax({
        cache: false,
        async: false,//no sync
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
                    var stat = "";
                    var etr = 0;
                    for (var i = 0; i < el.length; i++) {
                        //console.log(el[i].RowIndex);
                        for (var j = 0; j < el[i].NameValue.length; j++) {
                            if (el[i].NameValue[j].Name == "MMSTAT") {
                            	stat = el[i].NameValue[j].Value;
                            }
                        }
                        etr++;
                        $('#selBUAR').append("<option value='" + stat.trim() + "'>" + stat.trim() + "</option>");
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

/*******************************************************************************
 * run SQL to MITMAS populate to table
 */
function startSQL(){
	var stat = $('#selBUAR').select().val();
	if(stat==undefined || stat == null || stat ==""){
		stat ="20";
	}
	 $("#tblData > tbody").html("");//delete all rows

	 	var itds="N'%נייר%'";
	    var url = "listItems.jsp?cono="+gCONO+"&stat="+stat;
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
	                    var fusd = "";
	                    var resp = "";

	                    
	                    var etr = 0;// counter for rows
	                    for (var i = 0; i < el.length; i++) {
	                        for (var j = 0; j < el[i].NameValue.length; j++) {
	                            if (el[i].NameValue[j].Name == "MMITNO") {
	                                itno = el[i].NameValue[j].Value;
	                            }
	                            if (el[i].NameValue[j].Name == "MMITDS") {
	                                itds = el[i].NameValue[j].Value;
	                            }
	                            if (el[i].NameValue[j].Name == "MMFUDS") {
	                            	fusd = el[i].NameValue[j].Value;
	                            }
	                            if (el[i].NameValue[j].Name == "MMRESP") {
	                            	resp = el[i].NameValue[j].Value;
	                            }
	                        }
	                        etr++;
	                        
	                        /*
							 * populate to table Render the fuds to Input
							 */
	                        $('#tblData').append(""+
	                        "<tr id='row_" + (i + 1) + "' ondblclick='showModel("+ (i + 1) +")'>" +
	                        "<td>" + itno + "</td>" +
	                        "<td>" + itds + "</td>" +
	                        "<td><input type='text' class='form-control' onkeypress='if (window.event.keyCode==13) {(updateText(id));}' " +
	                        "id='fudsText_" + (i + 1) + "' onblur='updateText(id)' placeholder='תעור'  value='" + fusd + "'>" +
	                        "</td>" +
	                        // old val of FUDS
	                        "<td style='visibility:hidden' id='oldFudsText__" + (i + 1) + "' >" + fusd + "</td>" +
	                        "<td style='visibility:hidden' id='resp__" + (i + 1) + "' >" + resp + "</td>" +
	                        "</tr>");
	                    }
	                }
	                waitingDialog.hide();
	            });
	        }
	    }
	    function processError(data, status, req) {
	        // alert(req.responseText + " " + status);
	        console.log("Error -> " + req.responseText + " " + status)
	    }
	    waitingDialog.hide();
	    return "";
	
}
/****
 * show modal
 * @param rowNo - row nomber
 */
function showModel(rowNo){
	var table = document.getElementById("tblData");
	$("#inpFrom").val(table.rows[rowNo].cells[4].innerHTML);
	 $('#mdText').modal('show');
}

/******
 * 
 * @param inp -> serch text
 *******/
function find_TableItems(inp) {
    var val = inp.value;
    $('#tblData tbody').find('tr').each(function () {
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

function updateText(id) {
	// alert(id)
	var rowNo=id.split("_")[1];
	var val =  $("#"+id).val();//val from input
	var table = document.getElementById("tblData");
	
	var itno = table.rows[rowNo].cells[0].innerHTML;//get from no input
	var itds = table.rows[rowNo].cells[1].innerHTML;//get from no input
	var oldFuds = table.rows[rowNo].cells[3].innerHTML;//get from no input
	
	if(val==oldFuds){//if no change
		return;
	}
	var inputFields  = "CONO=" + gCONO + "&ITNO=" + itno + "&FUDS=" +val ;
	var anser = prosesApi_MMS200MI_UpdItmBasic(inputFields);
	if(anser=="1"){//Api Succeeded 
		$("#row_"+rowNo).removeClass();
        $("#row_"+rowNo).addClass('info');
	}else{//Api error
		$("#row_"+rowNo).removeClass();
        $("#row_"+rowNo).addClass('danger');
	}
	
}
/*********
 * 
 * @param inputFields - fealds to send
 * @returns
 */
function prosesApi_MMS200MI_UpdItmBasic(inputFields) {
    console.log("-----------------------start MMS200MI.UpdItmBasic--------------------------------")
    var program = 'MMS200MI';
    var transaction = 'UpdItmBasic';
    var returncols = [];
    var anserAtt = RunApi_OneAnswer(program, transaction, returncols, inputFields);

    console.log("is error ? " + anserAtt.error);
    if (anserAtt.error != undefined) {
        console.log("---------------------MMS200MI.UpdItmBasic-> -Error----------------------------")
        console.log(anserAtt.error);
        console.log("-------------------------------------------------------")
        return anserAtt.error;
    }

    console.log("-----------------End MMS200MI.UpdItmBasic-------------------------------------")
    return "1";
}



/*******************************************************************************
 **************************** RUN API***************************************
 ******************************************************************************/
function RunApi_OneAnswer(program, transaction, returncols, inputFields) {
   // var ansers= new Array();
   var anserAtt = {};
   // return OBJ
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

               var spaceError=txt_Messege.indexOf("                                                                                                                                                                                                                               ");
               if(spaceError>2){
                   txt_Messege=txt_Messege.substring(0,spaceError)+ txt_Messege.substring(spaceError+224)
               }
               var ApiError = "M3 API Error: ";
               var mesErr = ApiError+": "+ txt_Messege.trim();
               console.log("error from Api=" +ApiError);

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