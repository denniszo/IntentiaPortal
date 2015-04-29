function body_onload()
{
	
	
	var program = 'CRS610MI';
var transaction = 'LstByNumber';
var maxrecs = 100;
var returncols = 'CUNO,CUNM,CUA1,TFNO,STAT';
 returncols = 'CUNO,CUNM';
var inputFields = 'CONO=790&CUNO=9000';
// construct the URL
var url = '../../m3api-rest/execute/' + program + '/' + transaction + ';maxrecs=' + maxrecs + ';returncols=' + returncols + '?' + inputFields;

url="http://bangkok.intentia.co.il:19007/intentia/sql.jsp";
// prepare the columns for dataTable
var arr = returncols.split(',');
var columns = [];
for (var i in arr) {
    columns[i] = { "data": arr[i] };
   // alert("data:" + arr[i]);
}
 var selectedRows = [];
$(document).ready(function () {
	
    var table = $('#CustomerList').DataTable( {
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
    });
    
    /*
     $('#CustomerList tbody').on('click', 'tr', function () {
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
   	 var table = $('#CustomerList').DataTable();
   //	alert(selected[0]);
	   $.each( selectedRows , function( index, value ) {
	   	alert(table.row(value).data()["CUNO"]);
	//  alert( index + ": " + value );
	}); 

return;
   alert(selectedRows);
   	 var selecredRows = new Array();
   	   var table = $('#CustomerList').DataTable();
   	   var selRows=table.$("tr").filter(".selected");
    		table.$("tr").filter(".selected").each(function (index, row){
    			alert(index);
    			//alert(selRows.row(index).data()["CUNO"]);
       }
      )
       //alert( table.rows('.selected').data().length +' row(s) selected' );
         var table = $('#CustomerList').DataTable();
         var row1 = table.row( 2 ).data();
      //   alert(row1["CUNO"]);
    //     alert(table.row(0).data()["CUNO"]);
   //     alert( table.row( 2).data["CUNO"]);
          //alert( data["CUNO"] );
    } );
  
  
});
  
/*
$('#CustomerList tbody').on('click', 'tr', function () {
    if ($(this).hasClass('selected')) {
        $(this).removeClass('selected');
    } else {
        $('#CustomerList tr.selected').removeClass('selected');
       
      //	table.$('tr.selected').removeClass('selected');
        $(this).addClass('selected');
    }
});
*/
var table = $('#CustomerList').DataTable();
 
$('#CustomerList tbody').on( 'click', 'tr', function () {
   // alert( table.row( this ).data()[0].cell().data());
    
    //  var data1 = table.row( $(CustomerList).parents('tr') ).data();
    //    alert( data1[0] );
        
   // var row1 = table.row( 0 ).data();
 
//alert( 'Pupil name in the first row is: '+ row1.name() );


} );


 $('#CustomerList tbody').on( 'click', 'tr', function () {
        var data = table.row( this ).data();
    //  alert( data["CUNO"] );
      
      // var aPos = $('#CustomerList').dataTable().fnGetPosition(this);
    //var aData = $('#CustomerList').dataTable().fnGetData(aPos[0]);
    // var tData = $('#CustomerList').dataTable().fnGetData(this);
    // console.log(tData);
   // alert(tData[1]);
    } );


$('#CustomerList tbody').on('click', 'tr', function () {
	
		$(this).toggleClass("selected");
		  var id =  $('#CustomerList').dataTable().fnGetPosition(this);
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
 //var table = $('#CustomerList').DataTable();
 // alert( 'There are'+table.data().length+' row(s) of data in this table' );
   //  var aPos = $('#CustomerList').dataTable().fnGetPosition(this);
   // var aData = $('#CustomerList').dataTable().fnGetData(aPos[0]);
    // var tData = $('#CustomerList').dataTable().fnGetData(this);
    // console.log(tData);
  //  alert(tData);
    
});

/*
 * 
 */
/*
$(function(){
    $.contextMenu({
        selector: '#CustomerList tbody',
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