<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css">
<!-- jQuery library -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<!-- Popper JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js"></script>
<!-- Latest compiled JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
<script>
$(document).ready(function(){
	
	//receipt start
	$("#receipt").click(function(){
		$("#resultReceipt").html("");
		$.ajax({
			  //url: "http://localhost:8080/test/receipt.jsp",
			  
			  url: "http://192.168.122.102:8088/pot/trf/receipt.jsp",
			  type: "GET",
			  data: { receiptno : $("#receiptno").val()},
			  dataType: "JSON",
			  success : function(data, status, xhr){
				  //alert(xhr.status);
				  $.each(data, function(key, value){
					  		if(jQuery.type(value) != "array"){
					  			$("#resultReceipt").append(key + ":" + value + " ");
								$("#resultReceipt").append("<br>");
					  		}else{
								$.each(value, function(index, json){
					  				$("#resultReceipt").append("["+ key + " " + index + "]-------------------------------------------------");
									$("#resultReceipt").append("<br>");
					  				$.each(json, function(key1, value1){
					  					$("#resultReceipt").append(key1 + ":" + value1 + " ");
										$("#resultReceipt").append("<br>");					  				
					  				});
					  			});
					  		}
				    });
			  },
			  error : function(xhr, status, error){
				  alert(xhr.responseText);
				  alert(xhr.status);
					var json = $.parseJSON(xhr.responseText);
					$("#resultReceipt").append("http_status:" + xhr.status);
					$("#resultReceipt").append("<br>");	
					 $.each(json, function(key, value){
						 $("#resultReceipt").append(key + ":" + value + " ");
						 $("#resultReceipt").append("<br>");	
					 });
				 }
			});
	});
	//receipt end
	
	//issue start
	$("#issue").click(function(){
		var v_receiptitems = [
			{
  				receiptnumber : $("input[name=issue_receiptnumber]:eq(0)").val()
			},
  			{
  				receiptnumber : $("input[name=issue_receiptnumber]:eq(1)").val()
  			}	
  		];
		$("#resultIssue").html("");		
		
		$.ajax({
			  //url: "http://localhost:8080/test/issue.jsp",
			  url: "http://192.168.122.102:8088/pot/trf/issue.jsp",
			  type: "POST",
			  data: { 
				  		docid : $("#issue_docid").val(),
				  		totalgrossamount : $("#issue_totalgrossamount").val(),
				  		totalrefundamount : $("#issue_totalrefundamount").val(),
				  		totalvatamount : $("#issue_totalvatamount").val(),				  		
				  		issuedatetime : $("#issue_issuedatetime").val(),
				  		receiptitems : JSON.stringify(v_receiptitems)
				  	},
			  dataType: "JSON",
			  traditional: true,
			  success : function(data, status, xhr){
				  //alert(xhr.status);
				  $.each(data, function(key, value){
					  		if(jQuery.type(value) != "array"){
					  			$("#resultIssue").append(key + ":" + value + " ");
								$("#resultIssue").append("<br>");
					  		}else{
								$.each(value, function(index, json){
					  				$("#resultIssue").append("["+ key + " " + index + "]-------------------------------------------------");
									$("#resultIssue").append("<br>");
					  				$.each(json, function(key1, value1){
					  					$("#resultIssue").append(key1 + ":" + value1 + " ");
										$("#resultIssue").append("<br>");					  				
					  				});
					  			});
					  		}
				    });
			  },
			  error : function(xhr, status, error){
				  //alert(xhr.responseText);
					var json = xhr.responseText;
					$("#resultIssue").append("http_status:" + xhr.status);
					$("#resultIssue").append("<br>");	
					 $.each(json, function(key, value){
						 $("#resultIssue").append(key + ":" + value + " ");
						 $("#resultIssue").append("<br>");	
					 });
				 }
			});
	});
	//issue end
	
	//cancel start
	$("#cancel").click(function(){
		var v_receiptitems = [
			{
  				receiptnumber : $("input[name=cancel_receiptnumber]:eq(0)").val()
			},
  			{
  				receiptnumber : $("input[name=cancel_receiptnumber]:eq(1)").val()
  			}	
  		];
		$("#resultCancel").html("");
		$.ajax({
			  //url: "http://localhost:8080/test/cancel.jsp",
			  url: "http://192.168.122.102:8088/pot/trf/cancel.jsp",
			  type: "POST",
			  data: { 
			  		docid : $("#cancel_docid").val(),
			  		totalrefundamount : $("#cancel_totalrefundamount").val(),			  		
			  		issuedatetime : $("#cancel_issuedatetime").val(),
			  		receiptitems : JSON.stringify(v_receiptitems)
			  	},
			  dataType: "JSON",
			  success : function(data, status, xhr){
				  //alert(xhr.status);
				  $.each(data, function(key, value){
					  		if(jQuery.type(value) != "array"){
					  			$("#resultCancel").append(key + ":" + value + " ");
								$("#resultCancel").append("<br>");
					  		}else{
								$.each(value, function(index, json){
					  				$("#resultCancel").append("["+ key + " " + index + "]-------------------------------------------------");
									$("#resultCancel").append("<br>");
					  				$.each(json, function(key1, value1){
					  					$("#resultCancel").append(key1 + ":" + value1 + " ");
										$("#resultCancel").append("<br>");					  				
					  				});
					  			});
					  		}
				    });
			  },
			  error : function(xhr, status, error){
				  //alert(xhr.responseText);
					var json = xhr.responseText;
					$("#resultCancel").append("http_status:" + xhr.status);
					$("#resultCancel").append("<br>");	
					 $.each(json, function(key, value){
						 $("#resultCancel").append(key + ":" + value + " ");
						 $("#resultCancel").append("<br>");	
					 });
				 }
			});
	});
	//cancel end
});
</script>
<style>
p{
	font-weight:bold;
	margin-top:50px;
}
</style>
</head>
<body>
	<div class="container">
		<div class="row">
    		<div class="col-md-12">
    			<p>
					정상조회:115041221030001600003390<br>
				       반품된거:119040421010000510001180<br>
				       이미된거:119050211010001400000623<br>
				       환급불가:119050211060000100000100<br>
		      </p>
    		</div>
    	</div>
  		<div class="row">
    		<div class="col-md-4">
				<p>영수증 조회</p>
				receiptno <br> <input type="text" id="receiptno" name="receiptno" value="115041221030001600003390" style="width:220px;"/><br>
				<input type="button" value="전송" id="receipt" name="receipt" />
			    <div style="margin-top:50px" id="resultReceipt">
			    </div>
			</div>
			<div class="col-md-4">
				<p>영수증 발행</p>
				docid <br> <input type="text" id="issue_docid" name="issue_docid" value="15003308002310914949" style="width:220px;"/><br>
				totalgrossamount <br> <input type="text" id="issue_totalgrossamount" name="issue_totalgrossamount" value="49000" style="width:220px;"/><br>
				totalrefundamount <br> <input type="text" id="issue_totalrefundamount" name="issue_totalrefundamount" value="1500" style="width:220px;"/><br>
				totalvatamount <br> <input type="text" id="issue_totalvatamount" name="issue_totalvatamount" value="4455" style="width:220px;"/><br>
				issuedatetime <br> <input type="text" id="issue_issuedatetime" name="issue_issuedatetime" value="20150412115009" style="width:220px;"/><br><br>
				
				receiptno <br> <input type="text" id="issue_receiptnumber" name="issue_receiptnumber" value="115041221030001600003390" style="width:220px;"/><br>
				receiptno <br> <input type="text" id="issue_receiptnumber" name="issue_receiptnumber" value="115041221030001700000300" style="width:220px;"/><br>
				
				<input type="button" value="전송" id="issue" name="issue" />
			    <div style="margin-top:50px" id="resultIssue">
			    </div>
			</div>
			<div class="col-md-4">
				<p>영수증 취소</p>
				docid <br> <input type="text" id="cancel_docid" name="cancel_docid" value="15003308002310914949" style="width:200px;"/><br>
				totalrefundamount <br> <input type="text" id="cancel_totalrefundamount" name="cancel_totalrefundamount" value="1500" style="width:200px;"/><br>
				issuedatetime <br> <input type="text" id="cancel_issuedatetime" name="cancel_issuedatetime" value="20150412115009" style="width:200px;"/><br><br>
				
				receiptno <br> <input type="text" id="cancel_receiptnumber[]" name="cancel_receiptnumber" value="115041221030001600003390" style="width:220px;"/><br>
				receiptno <br> <input type="text" id="cancel_receiptnumber[]" name="cancel_receiptnumber" value="115041221030001700000300" style="width:220px;"/><br>
				<input type="button" value="전송" id="cancel" name="cancel" />
			    <div style="margin-top:50px" id="resultCancel">
			    </div>
			</div>
		</div>
	</div>
</body>
</html>