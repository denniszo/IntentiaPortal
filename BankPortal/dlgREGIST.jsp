<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@include file="Translator.jsp"%>
    <meta charset="UTF-8">
    <script type="text/javascript">
        function CleareTable(){
            $('#tblSerch').empty();
            $('#tblSerch').append("" +
            "<tr> "+
            "<th style='text-align: right'><%=str_code%></th>"+
            "<th style='text-align: right'><%=str_name%></th>"+
            "</tr>");
        }
    </script>
</head>
<body>
<div class="row">
    <!-- Modal -->dir="rtl">
    <div class="modal fade modal-fullscreen force-fullscreen" id="mdRegist" tabindex="-1" role="dialog" aria-labelledby="mdRegist" aria-hidden="true"
         style=" left: 15px; top: 15px;margin:1px; padding:0;height: 80%;width: 70%">
        <div class="modal-dialog ">
            <div class="modal-content" style="height:120%">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                    <h4 class="modal-title" id="mdRegist_titel"><%=dlgRegistitel%></h4>
                </div>
                <div class="modal-body">
                    <!-- body-->
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-sm-8">
                                <div class="row">
                                    <div class="col-md-4" dir="<%=direction%>">
                                        <label for="dim1"><%=dim1%></label>
                                        <input type="text" id="dim1" class="form-control" onfocus="getAITP('1',this.value)" onkeyup="serchNumber(this.value)">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4" dir="<%=direction%>">
                                        <label for="dim2"><%=dim2%></label>
                                        <input type="text" id="dim2" class="form-control" onfocus="getAITP('2',this.value)" onkeyup="serchNumber(this.value)">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4" dir="<%=direction%>">
                                        <label for="dim3"><%=dim3%></label>
                                        <input type="text" id="dim3" class="form-control" onfocus="getAITP('3',this.value)" onkeyup="serchNumber(this.value)">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4" dir="<%=direction%>">
                                        <label for="dim4"><%=dim4%></label>
                                        <input type="text" id="dim4" class="form-control" onfocus="getAITP('4',this.value)" onkeyup="serchNumber(this.value)">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4" dir="<%=direction%>">
                                        <label for="dim5"><%=dim5%></label>
                                        <input type="text" id="dim5" class="form-control" onfocus="getAITP('5',this.value)" onkeyup="serchNumber(this.value)">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4" dir="<%=direction%>">
                                        <label for="dim6"><%=dim6%></label>
                                        <input type="text" id="dim6" class="form-control" onfocus="getAITP('6',this.value)" onkeyup="serchNumber(this.value)">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4" dir="<%=direction%>">
                                        <label for="dim7"><%=dim7%></label>
                                        <input type="text" id="dim7" class="form-control" onfocus="getAITP('7',this.value)" onkeyup="serchNumber(this.value)">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4" dir="<%=direction%>">
                                        <label for="dim8"><%=dim8%></label>
                                        <input type="text" id="dim8" class="form-control" onfocus="getAITP('8',this.value)" onkeyup="serchNumber(this.value)">
                                    </div>
                                </div>

                            </div><!--  <div class="col-sm-9"> -->
                            <div class="col-sm-4">
                                <div class="row">
                                    <label for="srhName"><%=str_srhName%></label>
                                    <input type="text" id="srhName" class="form-control" onkeyup="serchName(this.value)">
                                    <!-- Tabele serch -->
                                    <div class="table-responsive" id="Serch_div" style="height: 350px; overflow: scroll" >
                                        <table class="table table-hover" id="tblSerch" dir="rtl" >
                                            <thead>
                                            <tr>
                                                <th style="text-align: right"><%=str_code%></th>
                                                <th style="text-align: right"><%=str_name%></th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>     <!--  <div class="col-sm-2"> -->
                        </div><!-- div class="row"> -->

                    </div>

                </div><!-- end body -->
            </div>
            <div class="modal-footer" style="height: 10%">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Save changes</button>
            </div>
        </div>
    </div>
</div>
<!-- End Modal -->


</div>
</body>
</html>