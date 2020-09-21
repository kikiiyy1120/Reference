<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if((String)session.getAttribute("id") != null)
	response.sendRedirect("main.jsp");
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
  <meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css">
  <link rel="stylesheet" href="https://pingendo.com/assets/bootstrap/bootstrap-4.0.0-beta.1.css" type="text/css"> 
<title>마리오아울렛 매출조회</title>  

</head>

<body>
  <div class="py-5">
    <div class="container">
      <div class="row">
        <div class="col-md-3"> </div>
        <div class="col-md-6">
          <div class="card text-white p-5 bg-primary" style="border:1px solid #000;background-color:#fff !important;padding-bottom:0px !important;font-weight:bold;">
            <div class="card-body">
              <h2 class="mb-4" style="color:#000;"><img src="logo.png" style="height:auto"/></h2>
		<!--<h3 style="color:#000;">매출조회 <br><br></h3>-->
              <form method="POST" action="login_proc.jsp">
                <div class="form-group"> <label style="color:#000">아이디</label>
                  <input type="text" name="id" class="form-control" placeholder="아이디를 입력하세요"> </div>
                <div class="form-group"> <label style="color:#000">비밀번호</label>
                  <input type="password" name="pw" class="form-control" placeholder="비밀번호를 입력하세요" style="margin-bottom:30px;bottom:30px;"> </div>
    
<button type="submit" class="btn btn-secondary" style="font-weight:bold;background-color:#dc3545;border:0;">로그인</button>
			               
              </form>
            </div>
			<center><p style="color:#000;font-size:10pt;">COPYRIGHT(c) 2018 마리오쇼핑(주) <br>All Rights Reserved.</p></center>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/js/bootstrap.min.js" integrity="sha384-h0AbiXch4ZDo7tp9hKZ4TsHbi047NrKGLO3SEJAg45jXxnGIfYzk4Si90RDIqNm1" crossorigin="anonymous"></script>
</body>

</html>
