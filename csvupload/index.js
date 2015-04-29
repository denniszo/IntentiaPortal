/**
 * Created by denniszo on 04/03/2015.
 */

function onLoad(){
    //alert(123);
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
                var tblRowsStr="";
                for(var i=0;i<data.length;i++){
                    tblRowsStr+="<tr id='row_" + (i + 1) + "'  >";
                    for(var j=0;j<data[i].length;j++){
                        tblRowsStr+="<td>"+ data[i][j]+ "</td>"
                    }
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