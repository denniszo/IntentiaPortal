function body_onload()
{
	

	var program = 'CRS610MI';
var transaction = 'LstByNumber';
var maxrecs = 100;
var returncols = 'CUNO,CUNM,CUA1,TFNO,STAT';
 returncols = 'EGAIT1,EGCUAM,EGCODT';
var inputFields = 'CONO=790&CUNO=9000';
// construct the URL
var url = '../../m3api-rest/execute/' + program + '/' + transaction + ';maxrecs=' + maxrecs + ';returncols=' + returncols + '?' + inputFields;

url="sqlGetGLTrans.jsp";
// prepare the columns for dataTable
var arr = returncols.split(',');
var columns = [];
for (var i in arr) {
    columns[i] = { "data": arr[i] };
   // alert("data:" + arr[i]);
}
 var selectedRows = [];
$(document).ready(function () {
	
    var table = $('#GLTrans').DataTable( {
    	 "language": {
     "sProcessing":   "מעבד...",
    "sLengthMenu":   "הצג _MENU_ פריטים",
    "sZeroRecords":  "לא נמצאו רשומות מתאימות",
    "sInfo": "_START_ עד _END_ מתוך _TOTAL_ רשומות" ,
    "sInfoEmpty":    "0 עד 0 מתוך 0 רשומות",
    "sInfoFiltered": "(מסונן מסך _MAX_  רשומות)",
    "sInfoPostFix":  "",
    "sSearch":       "חפש:",
    "sUrl":          "",
    "oPaginate": {
        "sFirst":    "ראשון",
        "sPrevious": "קודם",
        "sNext":     "הבא",
        "sLast":     "אחרון"
    }
      },
        
        
    	//paging: false,
    	 //searching: false,
    	  //"ajax": "arrays.txt",
    	  
        "ajax": {
            "url": url,            
            "dataSrc": function (json) {
                var result = [];
                
                for (var i in json.MIRecord) {
                    var record = {};
                   // alert(json.MIRecord[i].NameValue);
                    json.MIRecord[i].NameValue.map(function(o){ record[o.Name] = o.Value; });
                 //   alert(record[0].value);
                  //  var arr = [ "Name=CUNO", "Value=9000"];
                  console.log(record["CUNO"]);
                    result[i] =record;
                    
                }
                
                return result;
            }
        },
        
        "columns": columns/*,
         "rowCallback": function( row, data, displayIndex ) {
            if ( $.inArray(data.DT_RowId, selected) !== -1 ) {
                $(row).addClass('selected');
            }
        }
        */
        /*
       "columnDefs": [ {
            "targets": -1,
            "data1": null,
            "defaultContent": "<button>Click!</button>"
        } ]
        
        */
       ,
        "columnDefs": [ {
            "targets": 1,
            "data": null,
            "defaultContent": "",
            "render": function ( data, type, full, meta ) {
        //	alert(type);
        
        		if(data<0)  {
        			return '<span style="color:red;" >' + data + '</span>';
    	 		}else{
					return data;
    	 		}
    		}
    		}  ,
    		{
    		//date
    		"targets": 2,
            "data": null,
            "defaultContent": "",
            "render": function ( data, type, full, meta ) {      
				return YYYYMMDDtoDDMMYY(data) ;
			} 
    			     
        } ]
       
    
       
    });
    
    /*
     $('#GLTrans tbody').on('click', 'tr', function () {
        var id = this.id;
        var index = $.inArray(id, selected);
 alert(index);
        if ( index === -1 ) {
            selected.push( id );
        } else {
            selected.splice( index, 1 );
        }
 
        $(this).toggleClass('selected');
    } );
    
    */
  $("#btn").text("test");

  
   $('#btn').click( function () {
   	 var table = $('#GLTrans').DataTable();
   //	alert(selected[0]);
	   $.each( selectedRows , function( index, value ) {
	   	alert(table.row(value).data()["EGAIT1"]);
	//  alert( index + ": " + value );
	}); 

return;
   alert(selectedRows);
   	 var selecredRows = new Array();
   	   var table = $('#GLTrans').DataTable();
   	   var selRows=table.$("tr").filter(".selected");
    		table.$("tr").filter(".selected").each(function (index, row){
    			alert(index);
    			//alert(selRows.row(index).data()["CUNO"]);
       }
      )
       //alert( table.rows('.selected').data().length +' row(s) selected' );
         var table = $('#GLTrans').DataTable();
         var row1 = table.row( 2 ).data();
      //   alert(row1["CUNO"]);
    //     alert(table.row(0).data()["CUNO"]);
   //     alert( table.row( 2).data["CUNO"]);
          //alert( data["CUNO"] );
    } );
  
  
});
  
/*
$('#GLTrans tbody').on('click', 'tr', function () {
    if ($(this).hasClass('selected')) {
        $(this).removeClass('selected');
    } else {
        $('#GLTrans tr.selected').removeClass('selected');
       
      //	table.$('tr.selected').removeClass('selected');
        $(this).addClass('selected');
    }
});
*/
var table = $('#GLTrans').DataTable();
 
$('#GLTrans tbody').on( 'click', 'tr', function () {
   // alert( table.row( this ).data()[0].cell().data());
    
    //  var data1 = table.row( $(GLTrans).parents('tr') ).data();
    //    alert( data1[0] );
        
   // var row1 = table.row( 0 ).data();
 
//alert( 'Pupil name in the first row is: '+ row1.name() );


} );


 $('#GLTrans tbody').on( 'click', 'tr', function () {
        var data = table.row( this ).data();
    //  alert( data["CUNO"] );
      
      // var aPos = $('#GLTrans').dataTable().fnGetPosition(this);
    //var aData = $('#GLTrans').dataTable().fnGetData(aPos[0]);
    // var tData = $('#GLTrans').dataTable().fnGetData(this);
    // console.log(tData);
   // alert(tData[1]);
    } );


$('#GLTrans tbody').on('click', 'tr', function () {
	
		$(this).toggleClass("selected");
		  var id =  $('#GLTrans').dataTable().fnGetPosition(this);
		//  alert(id);
        var index = $.inArray(id, selectedRows);
 		
        if ( index === -1 ) {
            selectedRows.push( id );
        } else {
            selectedRows.splice( index, 1 );
        }
 //alert(selectedRows.length);
    //    $(this).toggleClass('selected');
   
    
	//	 alert(id);
	//	 alert(aPos);
 //var table = $('#GLTrans').DataTable();
 // alert( 'There are'+table.data().length+' row(s) of data in this table' );
   //  var aPos = $('#GLTrans').dataTable().fnGetPosition(this);
   // var aData = $('#GLTrans').dataTable().fnGetData(aPos[0]);
    // var tData = $('#GLTrans').dataTable().fnGetData(this);
    // console.log(tData);
  //  alert(tData);
    
});



$('chosen-select chosen-rtl').chosen({
  source: function( request, response ) {
    $.ajax({
    
      url: "sqlGetGLTrans.jsp",
      dataType: "json",
     
      success: function( data ) {
        response( $.map( data, function( item ) {
          $('bkid-results').append('<li class="active-result">' + item.name + '</li>');
        }));
      }
    });
  }
});


/*
 * 
 */
/*
$(function(){
    $.contextMenu({
        selector: '#GLTrans tbody',
        callback: function(key, options) {
            // PENDING
        },
        items: {
            "Select": {name: "select", icon: "select"},
            "Copy": {name: "copy", icon: "copy"},
            "Change": {name: "change", icon: "edit"},
            "Display": {name: "display", icon: "display"},
            "Delete": {name: "delete", icon: "delete"}
        }
    });
});
*/
/*
$(document).ready(function() {
    $('#example').dataTable( {
        "ajax": {
            "url": "arrays_custom_prop.txt",
            "dataSrc": "demo"
        }
    } );
} );

*/

}


 function run() {
                try {
                    // construct the URL
                    var url = '../../m3api-rest/execute/'+program+'/'+transaction+';maxrecs='+maxrecs+';returncols='+returncols+'?'+inputFields;
                    // execute the request
                    var xhr = new XMLHttpRequest();
                    xhr.open('GET', url, true, userid, password);
                    xhr.setRequestHeader('Accept', 'application/json');
                    xhr.onreadystatechange = function () {
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
                                    for (var m in metadata) {
                                        var th = document.createElement('th');
                                        th.appendChild(document.createTextNode(metadata[m]['@description'] + ' ' + metadata[m]['@name']));
                                        tr.appendChild(th);
                                    }
                                    thead.appendChild(tr);
                                    table.appendChild(thead);
                                    // paint the table with jQuery DataTables
                                    $('#results').dataTable({
                                        "bJQueryUI": true,
                                        "sPaginationType": "full_numbers"
                                    });
                                }
                                // show the data
                                var rows = response.MIRecord;
                                for (var i in rows) {
                                    var fields = rows[i].NameValue;
                                    var values = [];
                                    for (var j in fields) {
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
 
       
       

function YYYYMMDDtoDDMMYY(orig_date){
	
	var dd,mm,yyyy,return_date;
	dd=orig_date.substring(6,8);
	mm=orig_date.substring(4,6);
	yyyy=orig_date.substring(0,4);
	
	return_date=dd+"/"+mm+"/"+yyyy;
		return return_date;
}

function setAS400Date(orig_date)
{
	var dd,mm,yyyy,return_date;
	if(orig_date.length!=8 && orig_date.length!=6)
	{
		//alert("date error");
		return -1;
	}
	dd=orig_date.substring(0,2);
	mm=orig_date.substring(2,4);
	if(orig_date.length==6){
		yyyy='20'+orig_date.substring(4,6);
	}else{
		yyyy=orig_date.substring(4,8);
	}
	return_date=yyyy.concat(mm,dd);
	//top.alert(return_date);
	return return_date;
}
