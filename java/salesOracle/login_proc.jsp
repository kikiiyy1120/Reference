<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

request.setCharacterEncoding("utf-8");
String id = request.getParameter("id");
String pw = request.getParameter("pw");

boolean login = false;
String url = "jdbc:oracle:thin:@192.168.122.111:1521:nmario";
String user = "HB_CRM";
String pass = "crm";
Connection conn;
Statement stmt;
ResultSet rs;

Class.forName("oracle.jdbc.driver.OracleDriver");
conn = DriverManager.getConnection(url, user, pass);
stmt = conn.createStatement();
rs = stmt.executeQuery("SELECT * FROM HB_CRM.USER_LIST WHERE ID ='"+id+"' AND PW = '"+pw+"'");
while(rs.next()){
	stmt = conn.createStatement();
	stmt.executeUpdate("UPDATE HB_CRM.USER_LIST SET LOGIN_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') WHERE ID ='"+id+"' AND PW = '"+pw+"'");
	session.setAttribute("id", id);
	session.setMaxInactiveInterval(60*60);

	
	login = true;
	
}
stmt.close();
rs.close();
conn.close();

if(login == true){
	response.sendRedirect("main.jsp");
}
else{
	out.println("<script>alert('아이디 또는 비밀번호를 확인하세요');history.go(-1);</script>");
}


%>