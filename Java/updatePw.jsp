<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

request.setCharacterEncoding("utf-8");
	
String id = request.getParameter("id");
String o_pw = request.getParameter("o_pw");
String n_pw = request.getParameter("n_pw");
String n_pw_re = request.getParameter("n_pw_re");

System.out.println("id: "+id+" o_pw: "+o_pw+" n_pw: "+n_pw+" n_pw_re: "+n_pw_re);

int update = 0;
String url = "jdbc:sqlserver://192.168.133.101:1819;databaseName=MarioEIS;user=devSa;password=mario12#$;";
Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
Connection conn;
Statement stmt;
ResultSet rs;
conn = DriverManager.getConnection(url);
stmt = conn.createStatement();
rs = stmt.executeQuery("SELECT ID FROM MARIOEIS..USER_LIST WHERE ID ='"+id+"' AND PW = '"+o_pw+"'");
while(rs.next()){
	stmt = conn.createStatement();
	stmt.executeUpdate("UPDATE MARIOEIS..USER_LIST SET PW = '"+n_pw+"'  WHERE ID ='"+id+"' AND PW = '"+o_pw+"'");
	update = 1;
}
stmt.close();
rs.close();
conn.close();

if(update == 1){
	out.println("<script>alert('변경되었습니다');location.href='main.jsp';</script>");
}
else{
	out.println("<script>alert('기존 비밀번호를 확인해주세요');history.go(-1);</script>");
}


%>



