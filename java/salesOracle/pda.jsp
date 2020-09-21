<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page language="java" import="java.text.*" %>
<%

request.setCharacterEncoding("utf-8");
String url = "jdbc:oracle:thin:@192.168.122.111:1521:nmario";
String user = "DPS";
String pass = "dps";
Connection conn;
ResultSet rs;
PreparedStatement pstmt;
Class.forName("oracle.jdbc.driver.OracleDriver");
conn = DriverManager.getConnection(url, user, pass);
pstmt = null;

Calendar cal = Calendar.getInstance();

String date = null;
String tempDate = null;
String tempMonth = null;

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

String sql =   
"SELECT                                                                                                                                                                                                 "+
"            POS_NO,SHOP_NAME,POS_NAME,POS_FLAG,FLOR_CD,MAGAM_FLAG,                                                                                                                                     "+
"            MAX(SALE_USER_ID) SALE_USER_ID, EMP_NO                                                                                                                                                     "+
"        FROM                                                                                                                                                                                           "+
"            (SELECT POS.POS_NO                                                                                                                                                                         "+
"                  , POS.SHOP_NAME                                                                                                                                                                      "+
"                  , POS.POS_NAME                                                                                                                                                                       "+
"                  , POS.POS_FLAG                                                                                                                                                                       "+
"                  , POS.FLOR_CD                                                                                                                                                                        "+
"                  , DPM.MAGAM_FLAG                                                                                                                                                                     "+
"                  , DPM.SALE_USER_ID                                                                                                                                                                   "+
"                  , REPLACE(NVL((SELECT MAX(ITEM_NAME) FROM DPS.PC_POSSHORTKEY Z WHERE STR_CD = POS.STR_CD AND Z.POS_NO = POS.POS_NO  AND ITEM_NAME NOT LIKE '행사%' AND ITEM_NAME NOT LIKE '대표%'),  "+
"                    (SELECT A.EMP_NAME FROM DPS.PC_SALEUSERMST A WHERE A.SALE_USER_ID = DPM.SALE_USER_ID AND A.STR_CD = POS.STR_CD)),'대표품목','') EMP_NO                                             "+
"               FROM DPS.PC_POSMST POS                                                                                                                                                                  "+
"                  , (SELECT POS_NO                                                                                                                                                                     "+
"                          , MAGAM_FLAG                                                                                                                                                                 "+
"                          , SALE_USER_ID                                                                                                                                                               "+
"                          , SALE_DT                                                                                                                                                                    "+
"                          , STR_CD                                                                                                                                                                     "+
"                       FROM DPS.PS_DISPOSMAGAM                                                                                                                                                         "+
"                      WHERE STR_CD  = '01'                                                                                                                                                             "+
"                        AND SALE_DT = ?                                                                                                                                                       "+
"                     UNION ALL                                                                                                                                                                         "+
"                     SELECT POS_NO, DECODE(EOD_TIME,NULL,'N','Y') MAGAM_FLAG, '' SALE_USER_ID, SALE_DT, STR_CD FROM DAT_POS_STAT@OUTLET                                                                "+
"                        WHERE 1=1                                                                                                                                                                      "+
"                        AND STR_CD = '01'                                                                                                                                                              "+
"                        AND SALE_DT = ?                                                                                                                                                       "+
"                        AND (STR_CD, POS_NO) NOT IN (SELECT STR_CD, POS_NO FROM DPS.PS_DISPOSMAGAM  WHERE STR_CD = '01'   AND SALE_DT = ?)                                                    "+
"                     UNION ALL                                                                                                                                                                         "+
"                     SELECT POS_NO, 'N' MAGAM_FLAG, '' SALE_USER_ID, SALE_DT, STR_CD                                                                                                                   "+
"                    FROM                                                                                                                                                                               "+
"                        (SELECT STR_CD,POS_NO,SALE_DT,COUNT(TRAN_NO) AA,TO_NUMBER(MAX(TRAN_NO)) BB FROM DPS.PS_TRHEADER                                                                                "+
"                        WHERE STR_CD = '01' AND SALE_DT = ?                                                                                                                                   "+
"                        GROUP BY STR_CD,POS_NO,SALE_DT)                                                                                                                                                "+
"                    WHERE AA <> BB                                                                                                                                                                     "+
"                    ) DPM                                                                                                                                                                              "+
"               WHERE POS.STR_CD = DPM.STR_CD(+)                                                                                                                                                        "+
"                AND POS.POS_NO = DPM.POS_NO(+)                                                                                                                                                         "+
"                AND POS.STR_CD = '01'                                                                                                                                                                  "+
"                AND POS.USE_YN = 'Y'                                                                                                                                                                   "+
"                AND POS.HALL_CD LIKE '' || '%'                                                                                                                                                         "+
"                   AND DPM.MAGAM_FLAG IN ( 'N', 'N')                                                                                                                                                   "+
"               )                                                                                                                                                                                       "+
"               GROUP BY POS_NO,SHOP_NAME,POS_NAME,POS_FLAG,FLOR_CD,MAGAM_FLAG,EMP_NO                                                                                                                   "+
"               ORDER BY POS_NO                                                                                                                                                                         "
;
pstmt = conn.prepareStatement(sql);
pstmt.setString(1, date);
pstmt.setString(2, date);
pstmt.setString(3, date);
pstmt.setString(4, date);
rs = pstmt.executeQuery();
%>		
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="//netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<title>PDA마감현황</title>
	
  <script>
  $(function(){
	  $("#tab0_btn").click();
		  });
  
  function tabClick0(){
	  $("#tab0_btn").css("background-color", "#dc3545");
	  $("#tab0_btn").css("color", "#fff");
	  $("#tab1_btn").css("background-color", "");
	  $("#tab1_btn").css("color", "#000");
	  $("#tab2_btn").css("background-color", "");
	  $("#tab2_btn").css("color", "#000");
	  $("#tab3_btn").css("background-color", "");
	  $("#tab3_btn").css("color", "#000");
	  $("#tab9_btn").css("background-color", "");
	  $("#tab9_btn").css("color", "#000");  
	  //location.href = '#tab1';
	};
  function tabClick1(){
	  $("#tab1_btn").css("background-color", "#dc3545");
	  $("#tab1_btn").css("color", "#fff");
	  $("#tab0_btn").css("background-color", "");
	  $("#tab0_btn").css("color", "#000");
	  $("#tab2_btn").css("background-color", "");
	  $("#tab2_btn").css("color", "#000");
	  $("#tab3_btn").css("background-color", "");
	  $("#tab3_btn").css("color", "#000");
	  $("#tab9_btn").css("background-color", "");
	  $("#tab9_btn").css("color", "#000");  
	  //location.href = '#tab1';
	};
	  function tabClick2(){
	  $("#tab2_btn").css("background-color", "#dc3545");
	  $("#tab2_btn").css("color", "#fff");
	  $("#tab0_btn").css("background-color", "");
	  $("#tab0_btn").css("color", "#000");
	  $("#tab1_btn").css("background-color", "");
	  $("#tab1_btn").css("color", "#000");
	  $("#tab3_btn").css("background-color", "");
	  $("#tab3_btn").css("color", "#000");
	  $("#tab9_btn").css("background-color", "");
	  $("#tab9_btn").css("color", "#000");  
	  //location.href = '#tab1';
	};
	  function tabClick3(){
	  $("#tab3_btn").css("background-color", "#dc3545");
	  $("#tab3_btn").css("color", "#fff");
	  $("#tab0_btn").css("background-color", "");
	  $("#tab0_btn").css("color", "#000");
	  $("#tab1_btn").css("background-color", "");
	  $("#tab1_btn").css("color", "#000");
	  $("#tab2_btn").css("background-color", "");
	  $("#tab2_btn").css("color", "#000");
	  $("#tab9_btn").css("background-color", "");
	  $("#tab9_btn").css("color", "#000");  
	  //location.href = '#tab1';
	};
	  function tabClick9(){
	  $("#tab9_btn").css("background-color", "#dc3545");
	  $("#tab9_btn").css("color", "#fff");
	  $("#tab0_btn").css("background-color", "");
	  $("#tab0_btn").css("color", "#000");
	  $("#tab1_btn").css("background-color", "");
	  $("#tab1_btn").css("color", "#000");
	  $("#tab2_btn").css("background-color", "");
	  $("#tab2_btn").css("color", "#000");
	  $("#tab3_btn").css("background-color", "");
	  $("#tab3_btn").css("color", "#000");  
	  //location.href = '#tab1';
	};
</script>
</head>
<body>							      
	<div class="py-5" >
		<div class="container">
			<br>
			<div class="row" style="margin:0;padding:0;text-align:center;">
				<div class="col-md-12" style="margin:0;padding:0">
					<form class="form-inline my-2 w-100" method="POST" action="pda.jsp">
						<select name="sel_y" class="form-control" style="display:inline;width:20%;">
<%
for(int i=Integer.parseInt(String.valueOf(cal.get(Calendar.YEAR)))-1;i<=Integer.parseInt(String.valueOf(cal.get(Calendar.YEAR)));i++){
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
						<select name="sel_m" class="form-control" style="display:inline;width:15%;">
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
						<select name="sel_d" class="form-control" style="display:inline;width:15%;">
<%
for(int i=1;i<=31;i++){
	if(Integer.parseInt(date.substring(6, 8)) == i){		
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
						</select>&nbsp;일&nbsp;
						<button type="submit" class="btn btn-primary" style="background:#dc3545;color:#fff;font-weight:bold;border:0;width:15%;">조회</button>
					</form>
				</div>
			</div>
			<br>
			<div class="row">
				<div class="col-md-12" >		
					<ul class="nav nav-tabs" style="text-align:center;">
						<li style="display:inline-block;"><a href="#tab0" data-toggle="tab" id="tab0_btn" class="tab0_btn" onclick="tabClick0()">전체</a></li>
						<li style="display:inline-block;"><a href="#tab1" data-toggle="tab" id="tab1_btn" class="tab1_btn" onclick="tabClick1()">1관</a></li>
						<li style="display:inline-block;"><a href="#tab2" data-toggle="tab" id="tab2_btn" class="tab2_btn" onclick="tabClick2()">2관</a></li>
						<li style="display:inline-block;"><a href="#tab3" data-toggle="tab" id="tab3_btn" class="tab3_btn" onclick="tabClick3()">3관</a></li>
						<li style="display:inline-block;"><a href="#tab9" data-toggle="tab" id="tab9_btn" class="tab9_btn" onclick="tabClick9()">행사장</a></li>
					</ul>
				</div>
			</div>
			
			<div class="tab-content">
				<!-- 전체 -->
				<div class="tab-pane" id="tab0">
					<div class="row" style="margin:0;padding:0">
						<div class="col-md-12" style="margin:0;padding:0">
							<br>
							<table style="margin-left:auto;margin-right:auto;width:100%">
<%
for(int i=0;rs.next();i++){
	if(rs.getString("POS_NO").equals("3001") || rs.getString("POS_NO").equals("2101") || rs.getString("POS_NO").equals("1101") || rs.getString("POS_NO").equals("2103") 
		|| rs.getString("POS_NO").equals("3301") || rs.getString("POS_NO").equals("3501") || rs.getString("POS_NO").equals("2201") || rs.getString("POS_NO").equals("1202") 
		|| rs.getString("POS_NO").equals("1301") || rs.getString("POS_NO").equals("3101") || rs.getString("POS_NO").equals("3945") || rs.getString("POS_NO").equals("1401") 
		|| rs.getString("POS_NO").equals("3105") || rs.getString("POS_NO").equals("1602") || rs.getString("POS_NO").equals("3401") || rs.getString("POS_NO").equals("3803")){
%>				
								<tr style="border-top:2px solid silver;border-bottom:2px solid silver;background-color:yellow">
<%
		}else{
%>
								<tr style="border-top:2px solid silver;border-bottom:2px solid silver;">
<%
		}
%>						
									<td>
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"><%=rs.getString("POS_NO")%></p>
									</td>	
									<td>								
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"><%=rs.getString("POS_NAME")%></p>
									</td>	
									<td>	
<%
if(rs.getString("EMP_NO") == null){
%>							
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"></p>
<%
}else{
%>		
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"><%=rs.getString("EMP_NO")%></p>
<%
}
%>						
									</td>
								</tr>
<%
}
%>							
							</table>
						</div>
					</div>
				</div>	
<%
sql =   
"SELECT                                                                                                                                                                                                 "+
"            POS_NO,SHOP_NAME,POS_NAME,POS_FLAG,FLOR_CD,MAGAM_FLAG,                                                                                                                                     "+
"            MAX(SALE_USER_ID) SALE_USER_ID, EMP_NO                                                                                                                                                     "+
"        FROM                                                                                                                                                                                           "+
"            (SELECT POS.POS_NO                                                                                                                                                                         "+
"                  , POS.SHOP_NAME                                                                                                                                                                      "+
"                  , POS.POS_NAME                                                                                                                                                                       "+
"                  , POS.POS_FLAG                                                                                                                                                                       "+
"                  , POS.FLOR_CD                                                                                                                                                                        "+
"                  , DPM.MAGAM_FLAG                                                                                                                                                                     "+
"                  , DPM.SALE_USER_ID                                                                                                                                                                   "+
"                  , REPLACE(NVL((SELECT MAX(ITEM_NAME) FROM DPS.PC_POSSHORTKEY Z WHERE STR_CD = POS.STR_CD AND Z.POS_NO = POS.POS_NO  AND ITEM_NAME NOT LIKE '행사%' AND ITEM_NAME NOT LIKE '대표%'),  "+
"                    (SELECT A.EMP_NAME FROM DPS.PC_SALEUSERMST A WHERE A.SALE_USER_ID = DPM.SALE_USER_ID AND A.STR_CD = POS.STR_CD)),'대표품목','') EMP_NO                                             "+
"               FROM DPS.PC_POSMST POS                                                                                                                                                                  "+
"                  , (SELECT POS_NO                                                                                                                                                                     "+
"                          , MAGAM_FLAG                                                                                                                                                                 "+
"                          , SALE_USER_ID                                                                                                                                                               "+
"                          , SALE_DT                                                                                                                                                                    "+
"                          , STR_CD                                                                                                                                                                     "+
"                       FROM DPS.PS_DISPOSMAGAM                                                                                                                                                         "+
"                      WHERE STR_CD  = '01'                                                                                                                                                             "+
"                        AND SALE_DT = ?                                                                                                                                                       "+
"                     UNION ALL                                                                                                                                                                         "+
"                     SELECT POS_NO, DECODE(EOD_TIME,NULL,'N','Y') MAGAM_FLAG, '' SALE_USER_ID, SALE_DT, STR_CD FROM DAT_POS_STAT@OUTLET                                                                "+
"                        WHERE 1=1                                                                                                                                                                      "+
"                        AND STR_CD = '01'                                                                                                                                                              "+
"                        AND SALE_DT = ?                                                                                                                                                       "+
"                        AND (STR_CD, POS_NO) NOT IN (SELECT STR_CD, POS_NO FROM DPS.PS_DISPOSMAGAM  WHERE STR_CD = '01'   AND SALE_DT = ?)                                                    "+
"                     UNION ALL                                                                                                                                                                         "+
"                     SELECT POS_NO, 'N' MAGAM_FLAG, '' SALE_USER_ID, SALE_DT, STR_CD                                                                                                                   "+
"                    FROM                                                                                                                                                                               "+
"                        (SELECT STR_CD,POS_NO,SALE_DT,COUNT(TRAN_NO) AA,TO_NUMBER(MAX(TRAN_NO)) BB FROM DPS.PS_TRHEADER                                                                                "+
"                        WHERE STR_CD = '01' AND SALE_DT = ?                                                                                                                                   "+
"                        GROUP BY STR_CD,POS_NO,SALE_DT)                                                                                                                                                "+
"                    WHERE AA <> BB                                                                                                                                                                     "+
"                    ) DPM                                                                                                                                                                              "+
"               WHERE POS.STR_CD = DPM.STR_CD(+)                                                                                                                                                        "+
"                AND POS.POS_NO = DPM.POS_NO(+)                                                                                                                                                         "+
"                AND POS.STR_CD = '01'                                                                                                                                                                  "+
"                AND POS.USE_YN = 'Y'                                                                                                                                                                   "+
"                AND POS.HALL_CD LIKE '' || '%'                                                                                                                                                         "+
"                AND SUBSTR(POS.POS_NO, 0, 1) = '1'                                                                                                                                                     "+
"                AND SUBSTR(POS.POS_NO, 0, 2) <> '19'                                                                                                                                                   "+
"                AND DPM.MAGAM_FLAG IN ( 'N', 'N')                                                                                                                                                      "+
"               )                                                                                                                                                                                       "+
"               GROUP BY POS_NO,SHOP_NAME,POS_NAME,POS_FLAG,FLOR_CD,MAGAM_FLAG,EMP_NO                                                                                                                   "+
"               ORDER BY POS_NO                                                                                                                                                                         "
;
pstmt = conn.prepareStatement(sql);
pstmt.setString(1, date);
pstmt.setString(2, date);
pstmt.setString(3, date);
pstmt.setString(4, date);
rs = pstmt.executeQuery();
%>				
				<!-- 1관 -->
				<div class="tab-pane" id="tab1">
					<div class="row" style="margin:0;padding:0">
						<div class="col-md-12" style="margin:0;padding:0">
							<br>
							<table style="margin-left:auto;margin-right:auto;width:100%">
<%
for(int i=0;rs.next();i++){
	if(rs.getString("POS_NO").equals("3001") || rs.getString("POS_NO").equals("2101") || rs.getString("POS_NO").equals("1101") || rs.getString("POS_NO").equals("2103") 
		|| rs.getString("POS_NO").equals("3301") || rs.getString("POS_NO").equals("3501") || rs.getString("POS_NO").equals("2201") || rs.getString("POS_NO").equals("1202") 
		|| rs.getString("POS_NO").equals("1301") || rs.getString("POS_NO").equals("3101") || rs.getString("POS_NO").equals("3945") || rs.getString("POS_NO").equals("1401") 
		|| rs.getString("POS_NO").equals("3105") || rs.getString("POS_NO").equals("1602") || rs.getString("POS_NO").equals("3401") || rs.getString("POS_NO").equals("3803")){
%>				
								<tr style="border-top:2px solid silver;border-bottom:2px solid silver;background-color:yellow">
<%
		}else{
%>
								<tr style="border-top:2px solid silver;border-bottom:2px solid silver;">
<%
		}
%>						
									<td>
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"><%=rs.getString("POS_NO")%></p>
									</td>	
									<td>								
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"><%=rs.getString("POS_NAME")%></p>
									</td>	
									<td>	
<%
if(rs.getString("EMP_NO") == null){
%>							
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"></p>
<%
}else{
%>		
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"><%=rs.getString("EMP_NO")%></p>
<%
}
%>						
									</td>
								</tr>
<%
}
%>							
							</table>
						</div>
					</div>
				</div>
<%
sql =   
"SELECT                                                                                                                                                                                                 "+
"            POS_NO,SHOP_NAME,POS_NAME,POS_FLAG,FLOR_CD,MAGAM_FLAG,                                                                                                                                     "+
"            MAX(SALE_USER_ID) SALE_USER_ID, EMP_NO                                                                                                                                                     "+
"        FROM                                                                                                                                                                                           "+
"            (SELECT POS.POS_NO                                                                                                                                                                         "+
"                  , POS.SHOP_NAME                                                                                                                                                                      "+
"                  , POS.POS_NAME                                                                                                                                                                       "+
"                  , POS.POS_FLAG                                                                                                                                                                       "+
"                  , POS.FLOR_CD                                                                                                                                                                        "+
"                  , DPM.MAGAM_FLAG                                                                                                                                                                     "+
"                  , DPM.SALE_USER_ID                                                                                                                                                                   "+
"                  , REPLACE(NVL((SELECT MAX(ITEM_NAME) FROM DPS.PC_POSSHORTKEY Z WHERE STR_CD = POS.STR_CD AND Z.POS_NO = POS.POS_NO  AND ITEM_NAME NOT LIKE '행사%' AND ITEM_NAME NOT LIKE '대표%'),  "+
"                    (SELECT A.EMP_NAME FROM DPS.PC_SALEUSERMST A WHERE A.SALE_USER_ID = DPM.SALE_USER_ID AND A.STR_CD = POS.STR_CD)),'대표품목','') EMP_NO                                             "+
"               FROM DPS.PC_POSMST POS                                                                                                                                                                  "+
"                  , (SELECT POS_NO                                                                                                                                                                     "+
"                          , MAGAM_FLAG                                                                                                                                                                 "+
"                          , SALE_USER_ID                                                                                                                                                               "+
"                          , SALE_DT                                                                                                                                                                    "+
"                          , STR_CD                                                                                                                                                                     "+
"                       FROM DPS.PS_DISPOSMAGAM                                                                                                                                                         "+
"                      WHERE STR_CD  = '01'                                                                                                                                                             "+
"                        AND SALE_DT = ?                                                                                                                                                       "+
"                     UNION ALL                                                                                                                                                                         "+
"                     SELECT POS_NO, DECODE(EOD_TIME,NULL,'N','Y') MAGAM_FLAG, '' SALE_USER_ID, SALE_DT, STR_CD FROM DAT_POS_STAT@OUTLET                                                                "+
"                        WHERE 1=1                                                                                                                                                                      "+
"                        AND STR_CD = '01'                                                                                                                                                              "+
"                        AND SALE_DT = ?                                                                                                                                                       "+
"                        AND (STR_CD, POS_NO) NOT IN (SELECT STR_CD, POS_NO FROM DPS.PS_DISPOSMAGAM  WHERE STR_CD = '01'   AND SALE_DT = ?)                                                    "+
"                     UNION ALL                                                                                                                                                                         "+
"                     SELECT POS_NO, 'N' MAGAM_FLAG, '' SALE_USER_ID, SALE_DT, STR_CD                                                                                                                   "+
"                    FROM                                                                                                                                                                               "+
"                        (SELECT STR_CD,POS_NO,SALE_DT,COUNT(TRAN_NO) AA,TO_NUMBER(MAX(TRAN_NO)) BB FROM DPS.PS_TRHEADER                                                                                "+
"                        WHERE STR_CD = '01' AND SALE_DT = ?                                                                                                                                   "+
"                        GROUP BY STR_CD,POS_NO,SALE_DT)                                                                                                                                                "+
"                    WHERE AA <> BB                                                                                                                                                                     "+
"                    ) DPM                                                                                                                                                                              "+
"               WHERE POS.STR_CD = DPM.STR_CD(+)                                                                                                                                                        "+
"                AND POS.POS_NO = DPM.POS_NO(+)                                                                                                                                                         "+
"                AND POS.STR_CD = '01'                                                                                                                                                                  "+
"                AND POS.USE_YN = 'Y'                                                                                                                                                                   "+
"                AND POS.HALL_CD LIKE '' || '%'                                                                                                                                                         "+
"                AND SUBSTR(POS.POS_NO, 0, 1) = '2'                                                                                                                                                     "+
"                AND SUBSTR(POS.POS_NO, 0, 2) <> '19'                                                                                                                                                   "+
"                AND DPM.MAGAM_FLAG IN ( 'N', 'N')                                                                                                                                                      "+
"               )                                                                                                                                                                                       "+
"               GROUP BY POS_NO,SHOP_NAME,POS_NAME,POS_FLAG,FLOR_CD,MAGAM_FLAG,EMP_NO                                                                                                                   "+
"               ORDER BY POS_NO                                                                                                                                                                         "
;
pstmt = conn.prepareStatement(sql);
pstmt.setString(1, date);
pstmt.setString(2, date);
pstmt.setString(3, date);
pstmt.setString(4, date);
rs = pstmt.executeQuery();
%>				
				<!-- 2관 -->
				<div class="tab-pane" id="tab2">
					<div class="row" style="margin:0;padding:0">
						<div class="col-md-12" style="margin:0;padding:0">
							<br>
							<table style="margin-left:auto;margin-right:auto;width:100%">
<%
for(int i=0;rs.next();i++){
	if(rs.getString("POS_NO").equals("3001") || rs.getString("POS_NO").equals("2101") || rs.getString("POS_NO").equals("1101") || rs.getString("POS_NO").equals("2103") 
		|| rs.getString("POS_NO").equals("3301") || rs.getString("POS_NO").equals("3501") || rs.getString("POS_NO").equals("2201") || rs.getString("POS_NO").equals("1202") 
		|| rs.getString("POS_NO").equals("1301") || rs.getString("POS_NO").equals("3101") || rs.getString("POS_NO").equals("3945") || rs.getString("POS_NO").equals("1401") 
		|| rs.getString("POS_NO").equals("3105") || rs.getString("POS_NO").equals("1602") || rs.getString("POS_NO").equals("3401") || rs.getString("POS_NO").equals("3803")){
%>				
								<tr style="border-top:2px solid silver;border-bottom:2px solid silver;background-color:yellow">
<%
		}else{
%>
								<tr style="border-top:2px solid silver;border-bottom:2px solid silver;">
<%
		}
%>						
									<td>
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"><%=rs.getString("POS_NO")%></p>
									</td>	
									<td>								
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"><%=rs.getString("POS_NAME")%></p>
									</td>	
									<td>	
<%
if(rs.getString("EMP_NO") == null){
%>							
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"></p>
<%
}else{
%>		
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"><%=rs.getString("EMP_NO")%></p>
<%
}
%>						
									</td>
								</tr>
<%
}
%>							
							</table>
						</div>
					</div>
				</div>
<%
sql =   
"SELECT                                                                                                                                                                                                 "+
"            POS_NO,SHOP_NAME,POS_NAME,POS_FLAG,FLOR_CD,MAGAM_FLAG,                                                                                                                                     "+
"            MAX(SALE_USER_ID) SALE_USER_ID, EMP_NO                                                                                                                                                     "+
"        FROM                                                                                                                                                                                           "+
"            (SELECT POS.POS_NO                                                                                                                                                                         "+
"                  , POS.SHOP_NAME                                                                                                                                                                      "+
"                  , POS.POS_NAME                                                                                                                                                                       "+
"                  , POS.POS_FLAG                                                                                                                                                                       "+
"                  , POS.FLOR_CD                                                                                                                                                                        "+
"                  , DPM.MAGAM_FLAG                                                                                                                                                                     "+
"                  , DPM.SALE_USER_ID                                                                                                                                                                   "+
"                  , REPLACE(NVL((SELECT MAX(ITEM_NAME) FROM DPS.PC_POSSHORTKEY Z WHERE STR_CD = POS.STR_CD AND Z.POS_NO = POS.POS_NO  AND ITEM_NAME NOT LIKE '행사%' AND ITEM_NAME NOT LIKE '대표%'),  "+
"                    (SELECT A.EMP_NAME FROM DPS.PC_SALEUSERMST A WHERE A.SALE_USER_ID = DPM.SALE_USER_ID AND A.STR_CD = POS.STR_CD)),'대표품목','') EMP_NO                                             "+
"               FROM DPS.PC_POSMST POS                                                                                                                                                                  "+
"                  , (SELECT POS_NO                                                                                                                                                                     "+
"                          , MAGAM_FLAG                                                                                                                                                                 "+
"                          , SALE_USER_ID                                                                                                                                                               "+
"                          , SALE_DT                                                                                                                                                                    "+
"                          , STR_CD                                                                                                                                                                     "+
"                       FROM DPS.PS_DISPOSMAGAM                                                                                                                                                         "+
"                      WHERE STR_CD  = '01'                                                                                                                                                             "+
"                        AND SALE_DT = ?                                                                                                                                                       "+
"                     UNION ALL                                                                                                                                                                         "+
"                     SELECT POS_NO, DECODE(EOD_TIME,NULL,'N','Y') MAGAM_FLAG, '' SALE_USER_ID, SALE_DT, STR_CD FROM DAT_POS_STAT@OUTLET                                                                "+
"                        WHERE 1=1                                                                                                                                                                      "+
"                        AND STR_CD = '01'                                                                                                                                                              "+
"                        AND SALE_DT = ?                                                                                                                                                       "+
"                        AND (STR_CD, POS_NO) NOT IN (SELECT STR_CD, POS_NO FROM DPS.PS_DISPOSMAGAM  WHERE STR_CD = '01'   AND SALE_DT = ?)                                                    "+
"                     UNION ALL                                                                                                                                                                         "+
"                     SELECT POS_NO, 'N' MAGAM_FLAG, '' SALE_USER_ID, SALE_DT, STR_CD                                                                                                                   "+
"                    FROM                                                                                                                                                                               "+
"                        (SELECT STR_CD,POS_NO,SALE_DT,COUNT(TRAN_NO) AA,TO_NUMBER(MAX(TRAN_NO)) BB FROM DPS.PS_TRHEADER                                                                                "+
"                        WHERE STR_CD = '01' AND SALE_DT = ?                                                                                                                                   "+
"                        GROUP BY STR_CD,POS_NO,SALE_DT)                                                                                                                                                "+
"                    WHERE AA <> BB                                                                                                                                                                     "+
"                    ) DPM                                                                                                                                                                              "+
"               WHERE POS.STR_CD = DPM.STR_CD(+)                                                                                                                                                        "+
"                AND POS.POS_NO = DPM.POS_NO(+)                                                                                                                                                         "+
"                AND POS.STR_CD = '01'                                                                                                                                                                  "+
"                AND POS.USE_YN = 'Y'                                                                                                                                                                   "+
"                AND POS.HALL_CD LIKE '' || '%'                                                                                                                                                         "+
"                AND SUBSTR(POS.POS_NO, 0, 1) = '3'                                                                                                                                                     "+
"                AND SUBSTR(POS.POS_NO, 0, 2) <> '19'                                                                                                                                                   "+
"                AND DPM.MAGAM_FLAG IN ( 'N', 'N')                                                                                                                                                      "+
"               )                                                                                                                                                                                       "+
"               GROUP BY POS_NO,SHOP_NAME,POS_NAME,POS_FLAG,FLOR_CD,MAGAM_FLAG,EMP_NO                                                                                                                   "+
"               ORDER BY POS_NO                                                                                                                                                                         "
;
pstmt = conn.prepareStatement(sql);
pstmt.setString(1, date);
pstmt.setString(2, date);
pstmt.setString(3, date);
pstmt.setString(4, date);
rs = pstmt.executeQuery();
%>				
				<!-- 3관 -->
				<div class="tab-pane" id="tab3">
					<div class="row" style="margin:0;padding:0">
						<div class="col-md-12" style="margin:0;padding:0">
							<br>
							<table style="margin-left:auto;margin-right:auto;width:100%">
<%
for(int i=0;rs.next();i++){
	if(rs.getString("POS_NO").equals("3001") || rs.getString("POS_NO").equals("2101") || rs.getString("POS_NO").equals("1101") || rs.getString("POS_NO").equals("2103") 
		|| rs.getString("POS_NO").equals("3301") || rs.getString("POS_NO").equals("3501") || rs.getString("POS_NO").equals("2201") || rs.getString("POS_NO").equals("1202") 
		|| rs.getString("POS_NO").equals("1301") || rs.getString("POS_NO").equals("3101") || rs.getString("POS_NO").equals("3945") || rs.getString("POS_NO").equals("1401") 
		|| rs.getString("POS_NO").equals("3105") || rs.getString("POS_NO").equals("1602") || rs.getString("POS_NO").equals("3401") || rs.getString("POS_NO").equals("3803")){
%>				
								<tr style="border-top:2px solid silver;border-bottom:2px solid silver;background-color:yellow">
<%
		}else{
%>
								<tr style="border-top:2px solid silver;border-bottom:2px solid silver;">
<%
		}
%>						
									<td>
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"><%=rs.getString("POS_NO")%></p>
									</td>	
									<td>								
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"><%=rs.getString("POS_NAME")%></p>
									</td>	
									<td>	
<%
if(rs.getString("EMP_NO") == null){
%>							
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"></p>
<%
}else{
%>		
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"><%=rs.getString("EMP_NO")%></p>
<%
}
%>						
									</td>
								</tr>
<%
}
%>							
							</table>
						</div>
					</div>
				</div>
<%
sql =   
"SELECT                                                                                                                                                                                                 "+
"            POS_NO,SHOP_NAME,POS_NAME,POS_FLAG,FLOR_CD,MAGAM_FLAG,                                                                                                                                     "+
"            MAX(SALE_USER_ID) SALE_USER_ID, EMP_NO                                                                                                                                                     "+
"        FROM                                                                                                                                                                                           "+
"            (SELECT POS.POS_NO                                                                                                                                                                         "+
"                  , POS.SHOP_NAME                                                                                                                                                                      "+
"                  , POS.POS_NAME                                                                                                                                                                       "+
"                  , POS.POS_FLAG                                                                                                                                                                       "+
"                  , POS.FLOR_CD                                                                                                                                                                        "+
"                  , DPM.MAGAM_FLAG                                                                                                                                                                     "+
"                  , DPM.SALE_USER_ID                                                                                                                                                                   "+
"                  , REPLACE(NVL((SELECT MAX(ITEM_NAME) FROM DPS.PC_POSSHORTKEY Z WHERE STR_CD = POS.STR_CD AND Z.POS_NO = POS.POS_NO  AND ITEM_NAME NOT LIKE '행사%' AND ITEM_NAME NOT LIKE '대표%'),  "+
"                    (SELECT A.EMP_NAME FROM DPS.PC_SALEUSERMST A WHERE A.SALE_USER_ID = DPM.SALE_USER_ID AND A.STR_CD = POS.STR_CD)),'대표품목','') EMP_NO                                             "+
"               FROM DPS.PC_POSMST POS                                                                                                                                                                  "+
"                  , (SELECT POS_NO                                                                                                                                                                     "+
"                          , MAGAM_FLAG                                                                                                                                                                 "+
"                          , SALE_USER_ID                                                                                                                                                               "+
"                          , SALE_DT                                                                                                                                                                    "+
"                          , STR_CD                                                                                                                                                                     "+
"                       FROM DPS.PS_DISPOSMAGAM                                                                                                                                                         "+
"                      WHERE STR_CD  = '01'                                                                                                                                                             "+
"                        AND SALE_DT = ?                                                                                                                                                       "+
"                     UNION ALL                                                                                                                                                                         "+
"                     SELECT POS_NO, DECODE(EOD_TIME,NULL,'N','Y') MAGAM_FLAG, '' SALE_USER_ID, SALE_DT, STR_CD FROM DAT_POS_STAT@OUTLET                                                                "+
"                        WHERE 1=1                                                                                                                                                                      "+
"                        AND STR_CD = '01'                                                                                                                                                              "+
"                        AND SALE_DT = ?                                                                                                                                                       "+
"                        AND (STR_CD, POS_NO) NOT IN (SELECT STR_CD, POS_NO FROM DPS.PS_DISPOSMAGAM  WHERE STR_CD = '01'   AND SALE_DT = ?)                                                    "+
"                     UNION ALL                                                                                                                                                                         "+
"                     SELECT POS_NO, 'N' MAGAM_FLAG, '' SALE_USER_ID, SALE_DT, STR_CD                                                                                                                   "+
"                    FROM                                                                                                                                                                               "+
"                        (SELECT STR_CD,POS_NO,SALE_DT,COUNT(TRAN_NO) AA,TO_NUMBER(MAX(TRAN_NO)) BB FROM DPS.PS_TRHEADER                                                                                "+
"                        WHERE STR_CD = '01' AND SALE_DT = ?                                                                                                                                   "+
"                        GROUP BY STR_CD,POS_NO,SALE_DT)                                                                                                                                                "+
"                    WHERE AA <> BB                                                                                                                                                                     "+
"                    ) DPM                                                                                                                                                                              "+
"               WHERE POS.STR_CD = DPM.STR_CD(+)                                                                                                                                                        "+
"                AND POS.POS_NO = DPM.POS_NO(+)                                                                                                                                                         "+
"                AND POS.STR_CD = '01'                                                                                                                                                                  "+
"                AND POS.USE_YN = 'Y'                                                                                                                                                                   "+
"                AND POS.HALL_CD LIKE '' || '%'                                                                                                                                                         "+
"                AND SUBSTR(POS.POS_NO, 0, 2) = '19'                                                                                                                                                    "+
"                AND DPM.MAGAM_FLAG IN ( 'N', 'N')                                                                                                                                                      "+
"               )                                                                                                                                                                                       "+
"               GROUP BY POS_NO,SHOP_NAME,POS_NAME,POS_FLAG,FLOR_CD,MAGAM_FLAG,EMP_NO                                                                                                                   "+
"               ORDER BY POS_NO                                                                                                                                                                         "
;
pstmt = conn.prepareStatement(sql);
pstmt.setString(1, date);
pstmt.setString(2, date);
pstmt.setString(3, date);
pstmt.setString(4, date);
rs = pstmt.executeQuery();
%>				
				<!-- 행사장 -->
				<div class="tab-pane" id="tab9">
					<div class="row" style="margin:0;padding:0">
						<div class="col-md-12" style="margin:0;padding:0">
							<br>
							<table style="margin-left:auto;margin-right:auto;width:100%">
<%
for(int i=0;rs.next();i++){
	if(rs.getString("POS_NO").equals("3001") || rs.getString("POS_NO").equals("2101") || rs.getString("POS_NO").equals("1101") || rs.getString("POS_NO").equals("2103") 
		|| rs.getString("POS_NO").equals("3301") || rs.getString("POS_NO").equals("3501") || rs.getString("POS_NO").equals("2201") || rs.getString("POS_NO").equals("1202") 
		|| rs.getString("POS_NO").equals("1301") || rs.getString("POS_NO").equals("3101") || rs.getString("POS_NO").equals("3945") || rs.getString("POS_NO").equals("1401") 
		|| rs.getString("POS_NO").equals("3105") || rs.getString("POS_NO").equals("1602") || rs.getString("POS_NO").equals("3401") || rs.getString("POS_NO").equals("3803")){
%>				
								<tr style="border-top:2px solid silver;border-bottom:2px solid silver;background-color:yellow">
<%
		}else{
%>
								<tr style="border-top:2px solid silver;border-bottom:2px solid silver;">
<%
		}
%>						
									<td>
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"><%=rs.getString("POS_NO")%></p>
									</td>	
									<td>								
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"><%=rs.getString("POS_NAME")%></p>
									</td>	
									<td>	
<%
if(rs.getString("EMP_NO") == null){
%>							
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"></p>
<%
}else{
%>		
										<p style="text-align:center;margin-top:2px;margin-bottom:2px"><%=rs.getString("EMP_NO")%></p>
<%
}
%>						
									</td>
								</tr>
<%
}
%>							
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
</body>
</html>