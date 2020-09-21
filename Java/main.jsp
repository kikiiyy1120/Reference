<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page language="java" import="java.text.*" %>

<%
class SaleStruct{
	String gubun;
	long goal_off;
	long goal_on;
	long goal_all;
	long sale_off;
	long sale_on;
	long sale_all;
	long bfsale_off;
	long bfsale_on;
	long bfsale_all;
	
	public SaleStruct(String _gubun, long _goal_off, long _goal_on, long _goal_all, long _sale_off, long _sale_on, long _sale_all, long _bfsale_off, long _bfsale_on, long _bfsale_all){
		gubun = _gubun;
		goal_off = _goal_off;
		goal_on = _goal_on;
		goal_all = _goal_all;
		sale_off = _sale_off;
		sale_on = _sale_on;
		sale_all = _sale_all;
		bfsale_off = _bfsale_off;
		bfsale_on = _bfsale_on;
		bfsale_all = _bfsale_all;		
	}
}
request.setCharacterEncoding("utf-8");
int unit = 1000000; //단위
String url = "jdbc:sqlserver://192.168.133.101:1819;databaseName=MarioEIS;user=devSa;password=mario12#$;";
Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
Connection conn = DriverManager.getConnection(url);
ResultSet rs;
PreparedStatement pstmt = null;
Calendar cal = Calendar.getInstance();
String date = null;
String tempDate = null;
String tempMonth = null;
String sessionId = (String)(session.getAttribute("id"));
if(sessionId == null){
	sessionId = "NULL";
}
String ip = request.getRemoteAddr();
if(session.getAttribute("id") == null){	
	response.sendRedirect("login.jsp");
}else{
	pstmt = conn.prepareStatement("INSERT INTO MARIOEIS..VIEW_LOG VALUES(?, GETDATE(), ?)");
	pstmt.setString(1, sessionId);
	pstmt.setString(2, ip);
	pstmt.executeUpdate();
}
if(request.getParameter("sel_y") != null){
	if(Integer.parseInt(request.getParameter("sel_m")) < 10)
		tempMonth = "0" + request.getParameter("sel_m");
	else
		tempMonth = request.getParameter("sel_m");
	
	if(Integer.parseInt(request.getParameter("sel_d")) < 10)
		tempDate = "0" + request.getParameter("sel_d");
	else
		tempDate = request.getParameter("sel_d");
	
	date = request.getParameter("sel_y")+tempMonth+tempDate;
}
else{
	if(cal.get(Calendar.MONTH)+1 < 10)
		tempMonth = "0" + (cal.get(Calendar.MONTH)+1);
	else
		tempMonth = "" + (cal.get(Calendar.MONTH)+1);
	
	if(cal.get(Calendar.DATE) < 10)
		tempDate = "0" + cal.get(Calendar.DATE);
	else
		tempDate = "" + cal.get(Calendar.DATE);
	
	date = String.valueOf(cal.get(Calendar.YEAR)) +tempMonth + tempDate;
}

String today = ""+cal.get(Calendar.YEAR) + cal.get(Calendar.MONTH)+1 + cal.get(Calendar.DATE);
String cmpr_dt = "";
//String gubun = request.getParameter("gubun");
if(Integer.parseInt(date)>Integer.parseInt(today)){
	cmpr_dt = "99991231";
	out.println("<script>alert('금일 기준 이후 데이터는 조회할 수 없습니다.');history.go(-1);</script>");
}
DecimalFormat format = new DecimalFormat("#.##");
String sql = "SELECT * FROM MARIOEIS..MOBILESALES WHERE SALE_DT = ?";

ArrayList<SaleStruct> strDaySum = new ArrayList<SaleStruct>();		//관별일매출
long[] strDaySumSum = new long[9];									//관별일매출
ArrayList<SaleStruct> teamDaySum = new ArrayList<SaleStruct>();		//팀별일매출
long[] teamDaySumSum = new long[9];									//팀별일매출
ArrayList<SaleStruct> strMonthSum = new ArrayList<SaleStruct>();	//관별월누계
long[] strMonthSumSum = new long[9];								//관별월누계
ArrayList<SaleStruct> teamMonthSum = new ArrayList<SaleStruct>();	//팀별월누계
long[] teamMonthSumSum = new long[9];								//팀별월누계

pstmt = conn.prepareStatement(sql);
pstmt.setString(1, date);
rs = pstmt.executeQuery();

int a = 0, b = 0, c = 0, d = 0;
for(int i=0;rs.next();i++){
	cmpr_dt = rs.getString("CMPR_DT");
	//관별일매출
	if(rs.getString("TYPE").equals("1")){
		strDaySum.add(a, new SaleStruct(
			     rs.getString("GUBUN").substring(1, rs.getString("GUBUN").length()), rs.getLong("GOAL_OFF"), rs.getLong("GOAL_ON")
			   , rs.getLong("GOAL_ALL"), rs.getLong("SALE_OFF"), rs.getLong("SALE_ON")
			   , rs.getLong("SALE_ALL"), rs.getLong("BFSALE_OFF"), rs.getLong("BFSALE_ON")
			   , rs.getLong("BFSALE_ALL")
		));
		a++;
		strDaySumSum[0] += rs.getLong("GOAL_ON");
		strDaySumSum[1] += rs.getLong("SALE_ON");
		strDaySumSum[2] += rs.getLong("BFSALE_ON");
		strDaySumSum[3] += rs.getLong("GOAL_OFF");
		strDaySumSum[4] += rs.getLong("SALE_OFF");
		strDaySumSum[5] += rs.getLong("BFSALE_OFF");
		strDaySumSum[6] += rs.getLong("GOAL_ALL");
		strDaySumSum[7] += rs.getLong("SALE_ALL");
		strDaySumSum[8] += rs.getLong("BFSALE_ALL");
	}
	//팀별일매출
	else if(rs.getString("TYPE").equals("2")){
		teamDaySum.add(b, new SaleStruct(
				rs.getString("GUBUN").substring(1, rs.getString("GUBUN").length()), rs.getLong("GOAL_OFF"), rs.getLong("GOAL_ON")
			   , rs.getLong("GOAL_ALL"), rs.getLong("SALE_OFF"), rs.getLong("SALE_ON")
			   , rs.getLong("SALE_ALL"), rs.getLong("BFSALE_OFF"), rs.getLong("BFSALE_ON")
			   , rs.getLong("BFSALE_ALL")
		));
		b++;
		teamDaySumSum[0] += rs.getLong("GOAL_ON");
		teamDaySumSum[1] += rs.getLong("SALE_ON");
		teamDaySumSum[2] += rs.getLong("BFSALE_ON");
		teamDaySumSum[3] += rs.getLong("GOAL_OFF");
		teamDaySumSum[4] += rs.getLong("SALE_OFF");
		teamDaySumSum[5] += rs.getLong("BFSALE_OFF");
		teamDaySumSum[6] += rs.getLong("GOAL_ALL");
		teamDaySumSum[7] += rs.getLong("SALE_ALL");
		teamDaySumSum[8] += rs.getLong("BFSALE_ALL");
	}
	//관별월매출누계
	else if(rs.getString("TYPE").equals("3")){
		strMonthSum.add(c, new SaleStruct(
				rs.getString("GUBUN").substring(1, rs.getString("GUBUN").length()), rs.getLong("GOAL_OFF"), rs.getLong("GOAL_ON")
			   , rs.getLong("GOAL_ALL"), rs.getLong("SALE_OFF"), rs.getLong("SALE_ON")
			   , rs.getLong("SALE_ALL"), rs.getLong("BFSALE_OFF"), rs.getLong("BFSALE_ON")
			   , rs.getLong("BFSALE_ALL")
		));
		c++;
		strMonthSumSum[0] += rs.getLong("GOAL_ON");
		strMonthSumSum[1] += rs.getLong("SALE_ON");
		strMonthSumSum[2] += rs.getLong("BFSALE_ON");
		strMonthSumSum[3] += rs.getLong("GOAL_OFF");
		strMonthSumSum[4] += rs.getLong("SALE_OFF");
		strMonthSumSum[5] += rs.getLong("BFSALE_OFF");
		strMonthSumSum[6] += rs.getLong("GOAL_ALL");
		strMonthSumSum[7] += rs.getLong("SALE_ALL");
		strMonthSumSum[8] += rs.getLong("BFSALE_ALL");		
	}
	//팀별월매출누계
	else if(rs.getString("TYPE").equals("4")){
		teamMonthSum.add(d, new SaleStruct(
				rs.getString("GUBUN").substring(1, rs.getString("GUBUN").length()), rs.getLong("GOAL_OFF"), rs.getLong("GOAL_ON")
			   , rs.getLong("GOAL_ALL"), rs.getLong("SALE_OFF"), rs.getLong("SALE_ON")
			   , rs.getLong("SALE_ALL"), rs.getLong("BFSALE_OFF"), rs.getLong("BFSALE_ON")
			   , rs.getLong("BFSALE_ALL")
		));
		d++;
		teamMonthSumSum[0] += rs.getLong("GOAL_ON");
		teamMonthSumSum[1] += rs.getLong("SALE_ON");
		teamMonthSumSum[2] += rs.getLong("BFSALE_ON");
		teamMonthSumSum[3] += rs.getLong("GOAL_OFF");
		teamMonthSumSum[4] += rs.getLong("SALE_OFF");
		teamMonthSumSum[5] += rs.getLong("BFSALE_OFF");
		teamMonthSumSum[6] += rs.getLong("GOAL_ALL");
		teamMonthSumSum[7] += rs.getLong("SALE_ALL");
		teamMonthSumSum[8] += rs.getLong("BFSALE_ALL");
	}
}
%>		

<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">

<link href="//netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script>
  function modalSubmit(){
	  if(document.getElementById('id').value == ''){
		  alert('로그인 후 가능합니다');
		  return false;
	  }else if(document.getElementById('o_pw').value == ''){
		  alert('기존 비밀번호를 입력하세요');
		  return false;
	  } else if(document.getElementById('n_pw').value == ''){
		  alert('새 비밀번호를 입력하세요');
		  return false;
	  } else if(document.getElementById('n_pw_re').value == ''){
		  alert('새 비밀번호2를 확인하세요');
		  return false;
	  } else if(document.getElementById('n_pw').value != document.getElementById('n_pw_re').value){
		  alert('새비밀번호를 확인하세요');
		  return false;
	  }
	  return true;
  } 
  $(function(){
	  var date = new Date();
	  var today = new Date(date.getFullYear(), date.getMonth(), date.getDate());
	  var day1 = new Date($("#sel_y").val(), $("#sel_m").val(), 0);
	  day1.setDate(<%=tempDate%>);	  
	  var day2 = new Date(<%=cmpr_dt.substring(0, 4)%>, <%=cmpr_dt.substring(4, 6)%>, 0);
	  day2.setDate(<%=cmpr_dt.substring(6, 8)%>);
	  var day;
	  
	  if(today.getFullYear() == day1.getFullYear() && today.getMonth() == day1.getMonth() && today.getDate() == day1.getDate()){
		  $("#online").css('display', 'block');
	  }else{
		  $("#online").css('display', 'none');
	  }
	  
	  if(day1.getDay() == 0){
			  day = ' (일)';
			  $("#day1").css('color', 'red');
			  $("#day2").css('color', 'red');
			  $("#day3").css('color', 'red');
			  $("#day4").css('color', 'red');
			  $("#day5").css('color', 'red');
			  $("#day6").css('color', 'red');
	  }else{
		  if(day1.getDay() == 1)
			  day = ' (월)';
		  else if (day1.getDay() == 2)
			  day = ' (화)';
		  else if (day1.getDay() == 3)
			  day = ' (수)';
		  else if (day1.getDay() == 4)
			  day = ' (목)';
		  else if (day1.getDay() == 5)
			  day = ' (금)';
		  else if (day1.getDay() == 6)
			  day = ' (토)';
		  $("#day1").css('color', 'black');
		  $("#day2").css('color', 'black');
		  $("#day3").css('color', 'black');
		  $("#day4").css('color', 'black');
		  $("#day5").css('color', 'black');
		  $("#day6").css('color', 'black');
	  }
	  $("#day1").html(day);
	  $("#day2").html(day);
	  $("#day3").html(day);
	  $("#day4").html(day);
	  $("#day5").html(day);
	  $("#day6").html(day);
	  
	  if(day2.getDay() == 0){
			  day = ' (일)';
			  $("#day7").css('color', 'red');
			  $("#day8").css('color', 'red');
			  $("#day9").css('color', 'red');
			  $("#day10").css('color', 'red');
			  $("#day11").css('color', 'red');
			  $("#day12").css('color', 'red');
	  }else{
		  if(day2.getDay() == 1)
			  day = ' (월)';
		  else if (day2.getDay() == 2)
			  day = ' (화)';
		  else if (day2.getDay() == 3)
			  day = ' (수)';
		  else if (day2.getDay() == 4)
			  day = ' (목)';
		  else if (day2.getDay() == 5)
			  day = ' (금)';
		  else if (day2.getDay() == 6)
			  day = ' (토)';
		  $("#day7").css('color', 'black');
		  $("#day8").css('color', 'black');
		  $("#day9").css('color', 'black');
		  $("#day10").css('color', 'black');
		  $("#day11").css('color', 'black');
		  $("#day12").css('color', 'black');
	  }
	  $("#day7").html(day);
	  $("#day8").html(day);
	  $("#day9").html(day);
	  $("#day10").html(day);
	  $("#day11").html(day);
	  $("#day12").html(day);
	  
	  
	  
	  
	  
	  var d = new Date($("#sel_y").val(), $("#sel_m").val(), 0);
	  var lastDate = d.getDate();
	  for(var i=1;i<=lastDate;i++){
			if(<%=Integer.parseInt(date.substring(6, 8))%> == i){		
				$("#sel_d").append("<option selected='selected' value="+i+">"+i+"</option>");
			}else{
				$("#sel_d").append("<option value="+i+">"+i+"</option>");
			}
		}
		
	  $('#sel_m').change(function(){
		  var sel = $("#sel_d").val();
		 lastDate = new Date($("#sel_y").val(), $("#sel_m").val(), 0).getDate();
		 for(var i=1;i<=31;i++){
			 $("#sel_d option:first").remove();
		 }
		 for(var i=1;i<=lastDate;i++){
			if(sel == i){		
				$("#sel_d").append("<option selected='selected' value="+i+">"+i+"</option>");
			}else{
				$("#sel_d").append("<option value="+i+">"+i+"</option>");
			}
		}
	  });
	  
	  $("#tab1_btn").click();
		  });
		  
	
  
  function tabClick1(){
	  $("#tab1_btn").css("background-color", "#dc3545");
	  $("#tab1_btn").css("color", "#fff");
	  $("#tab2_btn").css("background-color", "");
	  $("#tab2_btn").css("color", "#000");
	  $("#tab3_btn").css("background-color", "");
	  $("#tab3_btn").css("color", "#000");
	  //location.href = '#tab1';

	};
	function tabClick2(){
		$("#tab2_btn").css("background-color", "#dc3545");
		  $("#tab2_btn").css("color", "#fff");
		  $("#tab1_btn").css("background-color", "");
		  $("#tab1_btn").css("color", "#000");
		  $("#tab3_btn").css("background-color", "");
		  $("#tab3_btn").css("color", "#000");
		  //location.href = '#tab2';
	};
	function tabClick3(){
		$("#tab3_btn").css("background-color", "#dc3545");
		  $("#tab3_btn").css("color", "#fff");
		  $("#tab1_btn").css("background-color", "");
		  $("#tab1_btn").css("color", "#000");
		  $("#tab2_btn").css("background-color", "");
		  $("#tab2_btn").css("color", "#000");
		  //location.href = '#tab2';
	};
</script>
<style>
.table_header{
	font-weight:bold;
	background-color:rgb(183, 240, 177);
}
.table_sum{
	font-weight:bold;
	background-color:rgb(255, 167, 167);
}
td{
	color:#000;
	text-align:center;
	border: 1px solid #000;
	font-size:10px;
}
table{
	border: 1px solid #000;
	
}
tr{
	border: 1px solid #000;
}
</style>
<title>마리오아울렛 매출조회</title>
</head>

<body>							      
	<div class="py-5" >
		<div class="container">
			<br>
			<div class="row" style="margin:0;padding:0;text-align:center;">
				<div class="col-md-12" style="margin:0;padding:0">
						<form class="form-inline my-2 w-100" method="POST" action="main.jsp">
							<select id="sel_y" name="sel_y" class="form-control" style="display:inline;width:20%;">
<%
for(int i=2018;i<=2020;i++){
	if(Integer.parseInt(date.substring(0, 4)) == i){
%>							
								<option selected="selected" value="<%=i%>"><%=i%></option>
<%
	}else{
%>
							  <option value="<%=i%>"><%=i%></option>
<%
	}
}
%>							  
							</select>&nbsp;년&nbsp;
							<select id="sel_m" name="sel_m" class="form-control" style="display:inline;width:15%;">
<%
for(int i=1;i<=12;i++){
	if(Integer.parseInt(date.substring(4, 6)) == i){	
%>								
							  <option selected="selected" value="<%=i%>"><%=i%></option>
<%
	}else{
%>
							<option value="<%=i%>"><%=i%></option>
<%
	}
}
%>							  
							</select>&nbsp;월&nbsp;
							<select id="sel_d" name="sel_d" class="form-control" style="display:inline;width:15%;">								  
							</select>&nbsp;일&nbsp;
							<button type="submit" class="btn btn-primary" style="background:#dc3545;color:#fff;font-weight:bold;border:0;width:15%;">조회</button>
						</form>
				</div>
			</div>
			<br>
			<div class="row">
				<div class="col-md-12" >		
					<ul class="nav nav-tabs" style="text-align:center;">
						<li style="display:inline-block;"><a href="#tab2" data-toggle="tab" id="tab1_btn" class="tab1_btn" onclick="tabClick1()">전체</a></li>
						<li style="display:inline-block;"><a href="#tab1" data-toggle="tab" id="tab2_btn" class="tab2_btn" onclick="tabClick2()">오프라인</a></li>
						<li style="display:inline-block;"><a href="#tab3" data-toggle="tab" id="tab3_btn" class="tab3_btn" onclick="tabClick3()">온라인</a></li>
						<li style="display:inline-block;float:right;"><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal" style="background-color:#fff;color:#2e88b5;font-weight:bold;padding:10px 15px;display:block;float:right;border:0">비밀번호 변경</button></li>
					</ul>
					
				</div>
			</div>
					
<div class="modal fade" id="myModal"> 
	<div class="modal-dialog"> 
		<div class="modal-content"> 
			<form action="updatePw.jsp" method="POST"> 	
				<div class="modal-header"> 
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button> 
					<h4 class="modal-title" id="myModalLabel">비밀번호 변경</h4> 
				</div> 
				<div class="modal-body"> 
					<input type=hidden name="id" id="id" value="<%=sessionId%>"/>
					<input type="password" class="form-control mr-3 my-1" placeholder="기존 비밀번호를 입력해주세요" name="o_pw" id="o_pw"><br>
					<input type="password" class="form-control mr-3 my-1" placeholder="새 비밀번호를 입력해주세요" name="n_pw" id="n_pw"><br>
					<input type="password" class="form-control mr-3 my-1" placeholder="새 비밀번호를 한번 더 입력해주세요" name="n_pw_re" id="n_pw_re">
				</div> 
				<div class="modal-footer"> 
					<button type="button" class="btn btn-default" data-dismiss="modal">취소</button> 
					<button type="submit" class="btn btn-primary" onclick="return modalSubmit()" style="background-color:#dc3545;border:0;">저장</button> 
				</div> 
			</form>
		</div> 
	</div> 
</div>

										 			

<div class="tab-content">
<!-- 온라인 -->
	<div class="tab-pane" id="tab3">
		<div class="row" style="margin:0;padding:0">
				<div class="col-md-12" style="margin:0;padding:0">
				
					<p><center id = "online" style="color:red;font-size:10pt">(당일 온라인 매출은 조회되지 않습니다)</center></p>
					<h3><center>관별 일매출</center></h3>
					<p><font style="float:left;">매출일자 : <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%></font> <font style="float:left" id="day1"></font></p><br>
					<p><font style="float:left;">대비일자 : <%=cmpr_dt.substring(0, 4)%>-<%=cmpr_dt.substring(4, 6)%>-<%=cmpr_dt.substring(6, 8)%> </font> <font style="float:left" id="day7"></font><font style="float:right;">단위 : 백만</font></p>
					<table class="table" style="border-top: 2px solid #000 !important;">
						<tr class="table_header">
							<td>구분</td>
							<td>목표</td>
							<td>실적</td>
							<td>달성율</td>
							<td>전년실적</td>
							<td>신장율</td>
						</tr>
<%
for(int i=0;i<strDaySum.size();i++){
%>						
						<tr>
							<td><%=strDaySum.get(i).gubun%></td>
							<td>
<%
	if(strDaySum.get(i).goal_on == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strDaySum.get(i).goal_on/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(strDaySum.get(i).sale_on == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strDaySum.get(i).sale_on/unit)%>
<%
	}
%>	
							</td>							
							<td>
<%
	if(strDaySum.get(i).goal_on == 0 || strDaySum.get(i).sale_on == 0){
%>							
								0%
<%
	}else{
%>								
								<%=format.format((double)(strDaySum.get(i).sale_on) / (double)(strDaySum.get(i).goal_on) * 100)%>%
<%
	}
%>						
							</td>
							<td>
<%
	if(strDaySum.get(i).bfsale_on == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strDaySum.get(i).bfsale_on/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(strDaySum.get(i).sale_on == 0 || strDaySum.get(i).bfsale_on == 0){
%>							
								0%
<%
	}else{
		if(((double)(strDaySum.get(i).sale_on) / (double)(strDaySum.get(i).bfsale_on) * 100) - 100 > 0){
%>	
							<font style = "color:#000;">
<%
		}else{
%>		
							<font style = "color:#dc3545;">
<%
		}
%>					
								<%=format.format(((double)(strDaySum.get(i).sale_on) / (double)(strDaySum.get(i).bfsale_on) * 100) - 100)%>%
							</font>
<%
	}
%>
							</td>							
						</tr>
<%
}
%>						
						<tr class="table_sum">
							<td>합계</td>
							<td><%=String.format("%,d",  strDaySumSum[0]/unit)%></td>
							<td><%=String.format("%,d",  strDaySumSum[1]/unit)%></td>
							<td><%=format.format((double)(strDaySumSum[1]) / (double)(strDaySumSum[0]) * 100)%>%</td>
							<td><%=String.format("%,d",  strDaySumSum[2]/unit)%></td>
							<td><%=format.format(((double)(strDaySumSum[1]) / (double)(strDaySumSum[2]) * 100)-100)%>%</td>
						</tr>
					</table>
					<br>
					<h3><center>팀별 일매출</center></h3>
					<p><font style="float:left;">매출일자 : <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%> </font><font style="float:left" id="day2"></font></p><br>
					<p><font style="float:left;">대비일자 : <%=cmpr_dt.substring(0, 4)%>-<%=cmpr_dt.substring(4, 6)%>-<%=cmpr_dt.substring(6, 8)%> </font><font style="float:left" id="day8"></font> <font style="float:right;">단위 : 백만</font></p>
					<table class="table" style="border-top: 2px solid #000 !important;">
						<tr class="table_header">
							<td>구분</td>
							<td>목표</td>
							<td>실적</td>
							<td>달성율</td>
							<td>전년실적</td>
							<td>신장율</td>
						</tr>
<%
for(int i=0;i<teamDaySum.size();i++){
%>						
						<tr>
							<td><%=teamDaySum.get(i).gubun%></td>
							<td>
<%
	if(teamDaySum.get(i).goal_on == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamDaySum.get(i).goal_on/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(teamDaySum.get(i).sale_on == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamDaySum.get(i).sale_on/unit)%>
<%
	}
%>	
							</td>							
							<td>
<%
	if(teamDaySum.get(i).goal_on == 0 || teamDaySum.get(i).sale_on == 0){
%>							
								0%
<%
	}else{
%>								
								<%=format.format((double)(teamDaySum.get(i).sale_on) / (double)(teamDaySum.get(i).goal_on) * 100)%>%
<%
	}
%>						
							</td>
							<td>
<%
	if(teamDaySum.get(i).bfsale_on == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamDaySum.get(i).bfsale_on/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(teamDaySum.get(i).sale_on == 0 || teamDaySum.get(i).bfsale_on == 0){
%>							
								0%
<%
	}else{
		if(((double)(teamDaySum.get(i).sale_on) / (double)(teamDaySum.get(i).bfsale_on) * 100) - 100 > 0){
%>	
							<font style = "color:#000;">
<%
		}else{
%>		
							<font style = "color:#dc3545;">
<%
		}
%>					
								<%=format.format(((double)(teamDaySum.get(i).sale_on) / (double)(teamDaySum.get(i).bfsale_on) * 100) - 100)%>%
							</font>
<%
	}
%>
							</td>							
						</tr>
<%
}
%>						
						<tr class="table_sum">
							<td>합계</td>
							<td><%=String.format("%,d",  teamDaySumSum[0]/unit)%></td>
							<td><%=String.format("%,d",  teamDaySumSum[1]/unit)%></td>
							<td><%=format.format((double)(teamDaySumSum[1]) / (double)(teamDaySumSum[0]) * 100)%>%</td>
							<td><%=String.format("%,d",  teamDaySumSum[2]/unit)%></td>
							<td><%=format.format(((double)(teamDaySumSum[1]) / (double)(teamDaySumSum[2]) * 100)-100)%>%</td>
						</tr>
					</table>
					<br>
					<h3><center>관별 월매출 누계</center></h3>
					<p><font style="float:left;">매출일자 : <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-01 ~ <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%></font></p><br>
					<p><font style="float:left;">대비일자 : <%=Integer.parseInt(date.substring(0, 4))-1%>-<%=date.substring(4, 6)%>-01 ~ <%=Integer.parseInt(date.substring(0, 4))-1%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%></font><font style="float:right;">단위 : 백만</font></p>
					<table class="table" style="border-top: 2px solid #000 !important;">
						<tr class="table_header">
							<td>구분</td>
							<td>목표</td>
							<td>실적</td>
							<td>달성율</td>
							<td>전년실적</td>
							<td>신장율</td>
						</tr>
<%
for(int i=0;i<strMonthSum.size();i++){
%>						
						<tr>
							<td><%=strMonthSum.get(i).gubun%></td>
							<td>
<%
	if(strMonthSum.get(i).goal_on == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strMonthSum.get(i).goal_on/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(strMonthSum.get(i).sale_on == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strMonthSum.get(i).sale_on/unit)%>
<%
	}
%>	
							</td>							
							<td>
<%
	if(strMonthSum.get(i).goal_on == 0 || strMonthSum.get(i).sale_on == 0){
%>							
								0%
<%
	}else{
%>								
								<%=format.format((double)(strMonthSum.get(i).sale_on) / (double)(strMonthSum.get(i).goal_on) * 100)%>%
<%
	}
%>						
							</td>
							<td>
<%
	if(strMonthSum.get(i).bfsale_on == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strMonthSum.get(i).bfsale_on/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(strMonthSum.get(i).sale_on == 0 || strMonthSum.get(i).bfsale_on == 0){
%>							
								0%
<%
	}else{
		if(((double)(strMonthSum.get(i).sale_on) / (double)(strMonthSum.get(i).bfsale_on) * 100) - 100 > 0){
%>	
							<font style = "color:#000;">
<%
		}else{
%>		
							<font style = "color:#dc3545;">
<%
		}
%>					
								<%=format.format(((double)(strMonthSum.get(i).sale_on) / (double)(strMonthSum.get(i).bfsale_on) * 100) - 100)%>%
							</font>
<%
	}
%>
							</td>							
						</tr>
<%
}
%>						
						<tr class="table_sum">
							<td>합계</td>
							<td><%=String.format("%,d",  strMonthSumSum[0]/unit)%></td>
							<td><%=String.format("%,d",  strMonthSumSum[1]/unit)%></td>
							<td><%=format.format((double)(strMonthSumSum[1]) / (double)(strMonthSumSum[0]) * 100)%>%</td>
							<td><%=String.format("%,d",  strMonthSumSum[2]/unit)%></td>
							<td><%=format.format(((double)(strMonthSumSum[1]) / (double)(strMonthSumSum[2]) * 100)-100)%>%</td>
						</tr>
					</table>
					<br>
					<h3><center>팀별 월매출 누계</center></h3>
					<p><font style="float:left;">매출일자 : <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-01 ~ <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%></font></p><br>
					<p><font style="float:left;">대비일자 : <%=Integer.parseInt(date.substring(0, 4))-1%>-<%=date.substring(4, 6)%>-01 ~ <%=Integer.parseInt(date.substring(0, 4))-1%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%></font><font style="float:right;">단위 : 백만</font></p>
					<table class="table" style="border-top: 2px solid #000 !important;">
						<tr class="table_header">
							<td>구분</td>
							<td>목표</td>
							<td>실적</td>
							<td>달성율</td>
							<td>전년실적</td>
							<td>신장율</td>
						</tr>
<%
for(int i=0;i<teamMonthSum.size();i++){
%>						
						<tr>
							<td><%=teamMonthSum.get(i).gubun%></td>
							<td>
<%
	if(teamMonthSum.get(i).goal_on == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamMonthSum.get(i).goal_on/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(teamMonthSum.get(i).sale_on == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamMonthSum.get(i).sale_on/unit)%>
<%
	}
%>	
							</td>							
							<td>
<%
	if(teamMonthSum.get(i).goal_on == 0 || teamMonthSum.get(i).sale_on == 0){
%>							
								0%
<%
	}else{
%>								
								<%=format.format((double)(teamMonthSum.get(i).sale_on) / (double)(teamMonthSum.get(i).goal_on) * 100)%>%
<%
	}
%>						
							</td>
							<td>
<%
	if(teamMonthSum.get(i).bfsale_on == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamMonthSum.get(i).bfsale_on/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(teamMonthSum.get(i).sale_on == 0 || teamMonthSum.get(i).bfsale_on == 0){
%>							
								0%
<%
	}else{
		if(((double)(teamMonthSum.get(i).sale_on) / (double)(teamMonthSum.get(i).bfsale_on) * 100) - 100 > 0){
%>	
							<font style = "color:#000;">
<%
		}else{
%>		
							<font style = "color:#dc3545;">
<%
		}
%>					
								<%=format.format(((double)(teamMonthSum.get(i).sale_on) / (double)(teamMonthSum.get(i).bfsale_on) * 100) - 100)%>%
							</font>
<%
	}
%>
							</td>							
						</tr>
<%
}
%>						
						<tr class="table_sum">
							<td>합계</td>
							<td><%=String.format("%,d",  teamMonthSumSum[0]/unit)%></td>
							<td><%=String.format("%,d",  teamMonthSumSum[1]/unit)%></td>
							<td><%=format.format((double)(teamMonthSumSum[1]) / (double)(teamMonthSumSum[0]) * 100)%>%</td>
							<td><%=String.format("%,d",  teamMonthSumSum[2]/unit)%></td>
							<td><%=format.format(((double)(teamMonthSumSum[1]) / (double)(teamMonthSumSum[2]) * 100)-100)%>%</td>
						</tr>
					</table>					
				</div>
		  </div>
	</div>
	<!-- 오프라인 -->
	<div class="tab-pane" id="tab1">
		<div class="row" style="margin:0;padding:0">
				<div class="col-md-12" style="margin:0;padding:0">
					<h3><center>관별 일매출</center></h3>
					<p><font style="float:left;">매출일자 : <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%> </font></p><font style="float:left" id="day3"></font><br>
					<p><font style="float:left;">대비일자 : <%=cmpr_dt.substring(0, 4)%>-<%=cmpr_dt.substring(4, 6)%>-<%=cmpr_dt.substring(6, 8)%> </font><font style="float:left" id="day9"></font> <font style="float:right;">단위 : 백만</font></p>
					<table class="table" style="border-top: 2px solid #000 !important;">
						<tr class="table_header">
							<td>구분</td>
							<td>목표</td>
							<td>실적</td>
							<td>달성율</td>
							<td>전년실적</td>
							<td>신장율</td>
						</tr>
<%
for(int i=0;i<strDaySum.size();i++){
%>						
						<tr>
							<td><%=strDaySum.get(i).gubun%></td>
							<td>
<%
	if(strDaySum.get(i).goal_off == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strDaySum.get(i).goal_off/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(strDaySum.get(i).sale_off == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strDaySum.get(i).sale_off/unit)%>
<%
	}
%>	
							</td>							
							<td>
<%
	if(strDaySum.get(i).goal_off == 0 || strDaySum.get(i).sale_off == 0){
%>							
								0%
<%
	}else{
%>								
								<%=format.format((double)(strDaySum.get(i).sale_off) / (double)(strDaySum.get(i).goal_off) * 100)%>%
<%
	}
%>						
							</td>
							<td>
<%
	if(strDaySum.get(i).bfsale_off == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strDaySum.get(i).bfsale_off/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(strDaySum.get(i).sale_off == 0 || strDaySum.get(i).bfsale_off == 0){
%>							
								0%
<%
	}else{
		if(((double)(strDaySum.get(i).sale_off) / (double)(strDaySum.get(i).bfsale_off) * 100) - 100 > 0){
%>	
							<font style = "color:#000;">
<%
		}else{
%>		
							<font style = "color:#dc3545;">
<%
		}
%>					
								<%=format.format(((double)(strDaySum.get(i).sale_off) / (double)(strDaySum.get(i).bfsale_off) * 100) - 100)%>%
							</font>
<%
	}
%>
							</td>							
						</tr>
<%
}
%>						
						<tr class="table_sum">
							<td>합계</td>
							<td><%=String.format("%,d",  strDaySumSum[3]/unit)%></td>
							<td><%=String.format("%,d",  strDaySumSum[4]/unit)%></td>
							<td><%=format.format((double)(strDaySumSum[4]) / (double)(strDaySumSum[3]) * 100)%>%</td>
							<td><%=String.format("%,d",  strDaySumSum[5]/unit)%></td>
							<td><%=format.format(((double)(strDaySumSum[4]) / (double)(strDaySumSum[5]) * 100)-100)%>%</td>
						</tr>
					</table>
					<br>
					<h3><center>팀별 일매출</center></h3>
					<p><font style="float:left;">매출일자 : <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%> </font></p><font style="float:left" id="day4"></font><br>
					<p><font style="float:left;">대비일자 : <%=cmpr_dt.substring(0, 4)%>-<%=cmpr_dt.substring(4, 6)%>-<%=cmpr_dt.substring(6, 8)%> </font><font style="float:left" id="day10"></font> <font style="float:right;">단위 : 백만</font></p>
					<table class="table" style="border-top: 2px solid #000 !important;">
						<tr class="table_header">
							<td>구분</td>
							<td>목표</td>
							<td>실적</td>
							<td>달성율</td>
							<td>전년실적</td>
							<td>신장율</td>
						</tr>
<%
for(int i=0;i<teamDaySum.size();i++){
%>						
						<tr>
							<td><%=teamDaySum.get(i).gubun%></td>
							<td>
<%
	if(teamDaySum.get(i).goal_off == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamDaySum.get(i).goal_off/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(teamDaySum.get(i).sale_off == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamDaySum.get(i).sale_off/unit)%>
<%
	}
%>	
							</td>							
							<td>
<%
	if(teamDaySum.get(i).goal_off == 0 || teamDaySum.get(i).sale_off == 0){
%>							
								0%
<%
	}else{
%>								
								<%=format.format((double)(teamDaySum.get(i).sale_off) / (double)(teamDaySum.get(i).goal_off) * 100)%>%
<%
	}
%>						
							</td>
							<td>
<%
	if(teamDaySum.get(i).bfsale_off == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamDaySum.get(i).bfsale_off/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(teamDaySum.get(i).sale_off == 0 || teamDaySum.get(i).bfsale_off == 0){
%>							
								0%
<%
	}else{
		if(((double)(teamDaySum.get(i).sale_off) / (double)(teamDaySum.get(i).bfsale_off) * 100) - 100 > 0){
%>	
							<font style = "color:#000;">
<%
		}else{
%>		
							<font style = "color:#dc3545;">
<%
		}
%>					
								<%=format.format(((double)(teamDaySum.get(i).sale_off) / (double)(teamDaySum.get(i).bfsale_off) * 100) - 100)%>%
							</font>
<%
	}
%>
							</td>							
						</tr>
<%
}
%>						
						<tr class="table_sum">
							<td>합계</td>
							<td><%=String.format("%,d",  teamDaySumSum[3]/unit)%></td>
							<td><%=String.format("%,d",  teamDaySumSum[4]/unit)%></td>
							<td><%=format.format((double)(teamDaySumSum[4]) / (double)(teamDaySumSum[3]) * 100)%>%</td>
							<td><%=String.format("%,d",  teamDaySumSum[5]/unit)%></td>
							<td><%=format.format(((double)(teamDaySumSum[4]) / (double)(teamDaySumSum[5]) * 100)-100)%>%</td>
						</tr>
					</table>
					<br>
					<h3><center>관별 월매출 누계</center></h3>
					<p><font style="float:left;">매출일자 : <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-01 ~ <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%></font></p><br>
					<p><font style="float:left;">대비일자 : <%=Integer.parseInt(date.substring(0, 4))-1%>-<%=date.substring(4, 6)%>-01 ~ <%=Integer.parseInt(date.substring(0, 4))-1%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%></font><font style="float:right;">단위 : 백만</font></p>
					<table class="table" style="border-top: 2px solid #000 !important;">
						<tr class="table_header">
							<td>구분</td>
							<td>목표</td>
							<td>실적</td>
							<td>달성율</td>
							<td>전년실적</td>
							<td>신장율</td>
						</tr>
<%
for(int i=0;i<strMonthSum.size();i++){
%>						
						<tr>
							<td><%=strMonthSum.get(i).gubun%></td>
							<td>
<%
	if(strMonthSum.get(i).goal_off == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strMonthSum.get(i).goal_off/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(strMonthSum.get(i).sale_off == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strMonthSum.get(i).sale_off/unit)%>
<%
	}
%>	
							</td>							
							<td>
<%
	if(strMonthSum.get(i).goal_off == 0 || strMonthSum.get(i).sale_off == 0){
%>							
								0%
<%
	}else{
%>								
								<%=format.format((double)(strMonthSum.get(i).sale_off) / (double)(strMonthSum.get(i).goal_off) * 100)%>%
<%
	}
%>						
							</td>
							<td>
<%
	if(strMonthSum.get(i).bfsale_off == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strMonthSum.get(i).bfsale_off/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(strMonthSum.get(i).sale_off == 0 || strMonthSum.get(i).bfsale_off == 0){
%>							
								0%
<%
	}else{
		if(((double)(strMonthSum.get(i).sale_off) / (double)(strMonthSum.get(i).bfsale_off) * 100) - 100 > 0){
%>	
							<font style = "color:#000;">
<%
		}else{
%>		
							<font style = "color:#dc3545;">
<%
		}
%>					
								<%=format.format(((double)(strMonthSum.get(i).sale_off) / (double)(strMonthSum.get(i).bfsale_off) * 100) - 100)%>%
							</font>
<%
	}
%>
							</td>							
						</tr>
<%
}
%>						
						<tr class="table_sum">
							<td>합계</td>
							<td><%=String.format("%,d",  strMonthSumSum[3]/unit)%></td>
							<td><%=String.format("%,d",  strMonthSumSum[4]/unit)%></td>
							<td><%=format.format((double)(strMonthSumSum[4]) / (double)(strMonthSumSum[3]) * 100)%>%</td>
							<td><%=String.format("%,d",  strMonthSumSum[5]/unit)%></td>
							<td><%=format.format(((double)(strMonthSumSum[4]) / (double)(strMonthSumSum[5]) * 100)-100)%>%</td>
						</tr>
					</table>
					<br>
					<h3><center>팀별 월매출 누계</center></h3>
					<p><font style="float:left;">매출일자 : <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-01 ~ <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%></font></p><br>
					<p><font style="float:left;">대비일자 : <%=Integer.parseInt(date.substring(0, 4))-1%>-<%=date.substring(4, 6)%>-01 ~ <%=Integer.parseInt(date.substring(0, 4))-1%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%></font><font style="float:right;">단위 : 백만</font></p>
					<table class="table" style="border-top: 2px solid #000 !important;">
						<tr class="table_header">
							<td>구분</td>
							<td>목표</td>
							<td>실적</td>
							<td>달성율</td>
							<td>전년실적</td>
							<td>신장율</td>
						</tr>
<%
for(int i=0;i<teamMonthSum.size();i++){
%>						
						<tr>
							<td><%=teamMonthSum.get(i).gubun%></td>
							<td>
<%
	if(teamMonthSum.get(i).goal_off == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamMonthSum.get(i).goal_off/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(teamMonthSum.get(i).sale_off == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamMonthSum.get(i).sale_off/unit)%>
<%
	}
%>	
							</td>							
							<td>
<%
	if(teamMonthSum.get(i).goal_off == 0 || teamMonthSum.get(i).sale_off == 0){
%>							
								0%
<%
	}else{
%>								
								<%=format.format((double)(teamMonthSum.get(i).sale_off) / (double)(teamMonthSum.get(i).goal_off) * 100)%>%
<%
	}
%>						
							</td>
							<td>
<%
	if(teamMonthSum.get(i).bfsale_off == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamMonthSum.get(i).bfsale_off/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(teamMonthSum.get(i).sale_off == 0 || teamMonthSum.get(i).bfsale_off == 0){
%>							
								0%
<%
	}else{
		if(((double)(teamMonthSum.get(i).sale_off) / (double)(teamMonthSum.get(i).bfsale_off) * 100) - 100 > 0){
%>	
							<font style = "color:#000;">
<%
		}else{
%>		
							<font style = "color:#dc3545;">
<%
		}
%>					
								<%=format.format(((double)(teamMonthSum.get(i).sale_off) / (double)(teamMonthSum.get(i).bfsale_off) * 100) - 100)%>%
							</font>
<%
	}
%>
							</td>							
						</tr>
<%
}
%>						
						<tr class="table_sum">
							<td>합계</td>
							<td><%=String.format("%,d",  teamMonthSumSum[3]/unit)%></td>
							<td><%=String.format("%,d",  teamMonthSumSum[4]/unit)%></td>
							<td><%=format.format((double)(teamMonthSumSum[4]) / (double)(teamMonthSumSum[3]) * 100)%>%</td>
							<td><%=String.format("%,d",  teamMonthSumSum[5]/unit)%></td>
							<td><%=format.format(((double)(teamMonthSumSum[4]) / (double)(teamMonthSumSum[5]) * 100)-100)%>%</td>
						</tr>
					</table>					
				</div>
		  </div>
	</div>
	<!-- 전체 -->
	<div class="tab-pane" id="tab2">
		<div class="row" style="margin:0;padding:0">
				<div class="col-md-12" style="margin:0;padding:0">
					<h3><center>관별 일매출</center></h3>
					<p><font style="float:left;">매출일자 : <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%> </font><font style="float:left" id="day5"></font></p><br>
					<p><font style="float:left;">대비일자 : <%=cmpr_dt.substring(0, 4)%>-<%=cmpr_dt.substring(4, 6)%>-<%=cmpr_dt.substring(6, 8)%> </font><font style="float:left" id="day11"></font> <font style="float:right;">단위 : 백만</font></p>
					<table class="table" style="border-top: 2px solid #000 !important;">
						<tr class="table_header">
							<td>구분</td>
							<td>목표</td>
							<td>실적</td>
							<td>달성율</td>
							<td>전년실적</td>
							<td>신장율</td>
						</tr>
<%
for(int i=0;i<strDaySum.size();i++){
%>						
						<tr>
							<td><%=strDaySum.get(i).gubun%></td>
							<td>
<%
	if(strDaySum.get(i).goal_all == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strDaySum.get(i).goal_all/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(strDaySum.get(i).sale_all == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strDaySum.get(i).sale_all/unit)%>
<%
	}
%>	
							</td>							
							<td>
<%
	if(strDaySum.get(i).goal_all == 0 || strDaySum.get(i).sale_all == 0){
%>							
								0%
<%
	}else{
%>								
								<%=format.format((double)(strDaySum.get(i).sale_all) / (double)(strDaySum.get(i).goal_all) * 100)%>%
<%
	}
%>						
							</td>
							<td>
<%
	if(strDaySum.get(i).bfsale_all == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strDaySum.get(i).bfsale_all/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(strDaySum.get(i).sale_all == 0 || strDaySum.get(i).bfsale_all == 0){
%>							
								0%
<%
	}else{
		if(((double)(strDaySum.get(i).sale_all) / (double)(strDaySum.get(i).bfsale_all) * 100) - 100 > 0){
%>	
							<font style = "color:#000;">
<%
		}else{
%>		
							<font style = "color:#dc3545;">
<%
		}
%>					
								<%=format.format(((double)(strDaySum.get(i).sale_all) / (double)(strDaySum.get(i).bfsale_all) * 100) - 100)%>%
							</font>
<%
	}
%>
							</td>							
						</tr>
<%
}
%>						
						<tr class="table_sum">
							<td>합계</td>
							<td><%=String.format("%,d",  strDaySumSum[6]/unit)%></td>
							<td><%=String.format("%,d",  strDaySumSum[7]/unit)%></td>
							<td><%=format.format((double)(strDaySumSum[7]) / (double)(strDaySumSum[6]) * 100)%>%</td>
							<td><%=String.format("%,d",  strDaySumSum[8]/unit)%></td>
							<td><%=format.format(((double)(strDaySumSum[7]) / (double)(strDaySumSum[8]) * 100)-100)%>%</td>
						</tr>
					</table>
					<br>
					<h3><center>팀별 일매출</center></h3>
					<p><font style="float:left;">매출일자 : <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%> </font><font style="float:left" id="day6"></font></p><br>
					<p><font style="float:left;">대비일자 : <%=cmpr_dt.substring(0, 4)%>-<%=cmpr_dt.substring(4, 6)%>-<%=cmpr_dt.substring(6, 8)%> </font><font style="float:left" id="day12"></font> <font style="float:right;">단위 : 백만</font></p>
					<table class="table" style="border-top: 2px solid #000 !important;">
						<tr class="table_header">
							<td>구분</td>
							<td>목표</td>
							<td>실적</td>
							<td>달성율</td>
							<td>전년실적</td>
							<td>신장율</td>
						</tr>
<%
for(int i=0;i<teamDaySum.size();i++){
%>						
						<tr>
							<td><%=teamDaySum.get(i).gubun%></td>
							<td>
<%
	if(teamDaySum.get(i).goal_all == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamDaySum.get(i).goal_all/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(teamDaySum.get(i).sale_all == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamDaySum.get(i).sale_all/unit)%>
<%
	}
%>	
							</td>							
							<td>
<%
	if(teamDaySum.get(i).goal_all == 0 || teamDaySum.get(i).sale_all == 0){
%>							
								0%
<%
	}else{
%>								
								<%=format.format((double)(teamDaySum.get(i).sale_all) / (double)(teamDaySum.get(i).goal_all) * 100)%>%
<%
	}
%>						
							</td>
							<td>
<%
	if(teamDaySum.get(i).bfsale_all == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamDaySum.get(i).bfsale_all/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(teamDaySum.get(i).sale_all == 0 || teamDaySum.get(i).bfsale_all == 0){
%>							
								0%
<%
	}else{
		if(((double)(teamDaySum.get(i).sale_all) / (double)(teamDaySum.get(i).bfsale_all) * 100) - 100 > 0){
%>	
							<font style = "color:#000;">
<%
		}else{
%>		
							<font style = "color:#dc3545;">
<%
		}
%>					
								<%=format.format(((double)(teamDaySum.get(i).sale_all) / (double)(teamDaySum.get(i).bfsale_all) * 100) - 100)%>%
							</font>
<%
	}
%>
							</td>							
						</tr>
<%
}
%>						
						<tr class="table_sum">
							<td>합계</td>
							<td><%=String.format("%,d",  teamDaySumSum[6]/unit)%></td>
							<td><%=String.format("%,d",  teamDaySumSum[7]/unit)%></td>
							<td><%=format.format((double)(teamDaySumSum[7]) / (double)(teamDaySumSum[6]) * 100)%>%</td>
							<td><%=String.format("%,d",  teamDaySumSum[8]/unit)%></td>
							<td><%=format.format(((double)(teamDaySumSum[7]) / (double)(teamDaySumSum[8]) * 100)-100)%>%</td>
						</tr>
					</table>
					<br>
					<h3><center>관별 월매출 누계</center></h3>
					<p><font style="float:left;">매출일자 : <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-01 ~ <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%></font></p><br>
					<p><font style="float:left;">대비일자 : <%=Integer.parseInt(date.substring(0, 4))-1%>-<%=date.substring(4, 6)%>-01 ~ <%=Integer.parseInt(date.substring(0, 4))-1%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%></font><font style="float:right;">단위 : 백만</font></p>
					<table class="table" style="border-top: 2px solid #000 !important;">
						<tr class="table_header">
							<td>구분</td>
							<td>목표</td>
							<td>실적</td>
							<td>달성율</td>
							<td>전년실적</td>
							<td>신장율</td>
						</tr>
<%
for(int i=0;i<strMonthSum.size();i++){
%>						
						<tr>
							<td><%=strMonthSum.get(i).gubun%></td>
							<td>
<%
	if(strMonthSum.get(i).goal_all == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strMonthSum.get(i).goal_all/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(strMonthSum.get(i).sale_all == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strMonthSum.get(i).sale_all/unit)%>
<%
	}
%>	
							</td>							
							<td>
<%
	if(strMonthSum.get(i).goal_all == 0 || strMonthSum.get(i).sale_all == 0){
%>							
								0%
<%
	}else{
%>								
								<%=format.format((double)(strMonthSum.get(i).sale_all) / (double)(strMonthSum.get(i).goal_all) * 100)%>%
<%
	}
%>						
							</td>
							<td>
<%
	if(strMonthSum.get(i).bfsale_all == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  strMonthSum.get(i).bfsale_all/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(strMonthSum.get(i).sale_all == 0 || strMonthSum.get(i).bfsale_all == 0){
%>							
								0%
<%
	}else{
		if(((double)(strMonthSum.get(i).sale_all) / (double)(strMonthSum.get(i).bfsale_all) * 100) - 100 > 0){
%>	
							<font style = "color:#000;">
<%
		}else{
%>		
							<font style = "color:#dc3545;">
<%
		}
%>					
								<%=format.format(((double)(strMonthSum.get(i).sale_all) / (double)(strMonthSum.get(i).bfsale_all) * 100) - 100)%>%
							</font>
<%
	}
%>
							</td>							
						</tr>
<%
}
%>						
						<tr class="table_sum">
							<td>합계</td>
							<td><%=String.format("%,d",  strMonthSumSum[6]/unit)%></td>
							<td><%=String.format("%,d",  strMonthSumSum[7]/unit)%></td>
							<td><%=format.format((double)(strMonthSumSum[7]) / (double)(strMonthSumSum[6]) * 100)%>%</td>
							<td><%=String.format("%,d",  strMonthSumSum[8]/unit)%></td>
							<td><%=format.format(((double)(strMonthSumSum[7]) / (double)(strMonthSumSum[8]) * 100)-100)%>%</td>
						</tr>
					</table>
					<br>
					<h3><center>팀별 월매출 누계</center></h3>
					<p><font style="float:left;">매출일자 : <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-01 ~ <%=date.substring(0, 4)%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%></font></p><br>
					<p><font style="float:left;">대비일자 : <%=Integer.parseInt(date.substring(0, 4))-1%>-<%=date.substring(4, 6)%>-01 ~ <%=Integer.parseInt(date.substring(0, 4))-1%>-<%=date.substring(4, 6)%>-<%=date.substring(6, 8)%></font><font style="float:right;">단위 : 백만</font></p>
					<table class="table" style="border-top: 2px solid #000 !important;">
						<tr class="table_header">
							<td>구분</td>
							<td>목표</td>
							<td>실적</td>
							<td>달성율</td>
							<td>전년실적</td>
							<td>신장율</td>
						</tr>
<%
for(int i=0;i<teamMonthSum.size();i++){
%>						
						<tr>
							<td><%=teamMonthSum.get(i).gubun%></td>
							<td>
<%
	if(teamMonthSum.get(i).goal_all == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamMonthSum.get(i).goal_all/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(teamMonthSum.get(i).sale_all == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamMonthSum.get(i).sale_all/unit)%>
<%
	}
%>	
							</td>							
							<td>
<%
	if(teamMonthSum.get(i).goal_all == 0 || teamMonthSum.get(i).sale_all == 0){
%>							
								0%
<%
	}else{
%>								
								<%=format.format((double)(teamMonthSum.get(i).sale_all) / (double)(teamMonthSum.get(i).goal_all) * 100)%>%
<%
	}
%>						
							</td>
							<td>
<%
	if(teamMonthSum.get(i).bfsale_all == 0){
%>			
								0
<%
	}else{
%>			
								<%=String.format("%,d",  teamMonthSum.get(i).bfsale_all/unit)%>
<%
	}
%>	
							</td>
							<td>
<%
	if(teamMonthSum.get(i).sale_all == 0 || teamMonthSum.get(i).bfsale_all == 0){
%>							
								0%
<%
	}else{
		if(((double)(teamMonthSum.get(i).sale_all) / (double)(teamMonthSum.get(i).bfsale_all) * 100) - 100 > 0){
%>	
							<font style = "color:#000;">
<%
		}else{
%>		
							<font style = "color:#dc3545;">
<%
		}
%>					
								<%=format.format(((double)(teamMonthSum.get(i).sale_all) / (double)(teamMonthSum.get(i).bfsale_all) * 100) - 100)%>%
							</font>
<%
	}
%>
							</td>							
						</tr>
<%
}
%>						
						<tr class="table_sum">
							<td>합계</td>
							<td><%=String.format("%,d",  teamMonthSumSum[6]/unit)%></td>
							<td><%=String.format("%,d",  teamMonthSumSum[7]/unit)%></td>
							<td><%=format.format((double)(teamMonthSumSum[7]) / (double)(teamMonthSumSum[6]) * 100)%>%</td>
							<td><%=String.format("%,d",  teamMonthSumSum[8]/unit)%></td>
							<td><%=format.format(((double)(teamMonthSumSum[7]) / (double)(teamMonthSumSum[8]) * 100)-100)%>%</td>
						</tr>
					</table>			
				</div>
		  </div>
	</div>
</div>
		
		</div>
	</div>
  <script src="validate.js"></script>
  <script src="http://code.jquery.com/jquery-latest.min.js"></script> 
  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script> 
  <script src="http://googledrive.com/host/0B-QKv6rUoIcGREtrRTljTlQ3OTg"></script><!-- ie10-viewport-bug-workaround.js --> 
  <script src="http://googledrive.com/host/0B-QKv6rUoIcGeHd6VV9JczlHUjg"></script><!-- holder.js -->

</body>

</html>