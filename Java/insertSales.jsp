<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.OutputStreamWriter"%>
<%@ page import="oracle.jdbc.OracleTypes"%>
<%@ page language="java" import="java.util.*" %>
<%@ page language="java" import="java.text.*" %>
<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" import="java.net.*" %>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.*"%>
<%
class MobileSales{
	String sale_dt;
	String type;
	String day;
	String cmpr_dt;
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
	
	public MobileSales(){};
	public MobileSales(String _sale_dt, String _type, String _day, String _cmpr_dt
			, String _gubun, long _goal_off, long _goal_on, long _goal_all, long _sale_off, long _sale_on, long _sale_all, long _bfsale_off, long _bfsale_on, long _bfsale_all){
		sale_dt = _sale_dt;
		type = _type;
		day = _day;
		cmpr_dt = _cmpr_dt;		
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
																						
String url_sql = "jdbc:sqlserver://192.168.133.101:1819;databaseName=MarioEIS;user=devSa;password=mario12#$;";
PreparedStatement pstmt_sql = null;
int rs_sql;

java.util.Date date = new java.util.Date();
JSONObject ob = null;
String body = null;
StringBuffer sb = new StringBuffer();
InputStream inputStream = request.getInputStream();
BufferedReader in = null;

ArrayList<MobileSales> data= new ArrayList<MobileSales>();

try{
	if(inputStream != null){
		in = new BufferedReader(new InputStreamReader(inputStream));
		char[] charBuffer = new char[128];
		int bytesRead = -1;
		while ((bytesRead = in.read(charBuffer)) > 0) {
            sb.append(charBuffer, 0, bytesRead);
        }
	}else{
		sb.append("");
	}
	body = sb.toString();	
	JSONParser parser = new JSONParser();
	Object ob_body = parser.parse(body);
	JSONObject json_body = (JSONObject)ob_body;
	JSONArray objArr = (JSONArray)json_body.get("mobileSales");
	JSONObject tmp = (JSONObject)objArr.get(0);
	
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	Connection conn_sql = DriverManager.getConnection(url_sql);
	String sql = "";
	sql = "DELETE FROM MARIOEIS..MOBILESALES WHERE SALE_DT = ?";
	System.out.println(tmp.get("sale_dt").toString());
	pstmt_sql = conn_sql.prepareStatement(sql);
	pstmt_sql.setString(1, tmp.get("sale_dt").toString());
	pstmt_sql.executeUpdate();
	sql = "INSERT INTO MARIOEIS..MOBILESALES VALUES";
	for(int i=0;i<objArr.size();i++){
		sql += "(? ,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'SYSTEM', getdate())";
		if(i != objArr.size()-1)
			sql += ",";
	}
	pstmt_sql = conn_sql.prepareStatement(sql);
	for(int i=0;i<objArr.size();i++){
		tmp = (JSONObject)objArr.get(i);
		pstmt_sql.setString(i*14+1, tmp.get("sale_dt").toString());
		pstmt_sql.setString(i*14+2, tmp.get("type").toString());
		pstmt_sql.setString(i*14+3, tmp.get("day").toString());
		pstmt_sql.setString(i*14+4, tmp.get("cmpr_dt").toString());
		pstmt_sql.setString(i*14+5, tmp.get("gubun").toString());
		pstmt_sql.setLong(i*14+6, Long.parseLong(tmp.get("goal_off").toString()));
		pstmt_sql.setLong(i*14+7, Long.parseLong(tmp.get("goal_on").toString()));
		pstmt_sql.setLong(i*14+8, Long.parseLong(tmp.get("goal_all").toString()));
		pstmt_sql.setLong(i*14+9, Long.parseLong(tmp.get("sale_off").toString()));
		pstmt_sql.setLong(i*14+10, Long.parseLong(tmp.get("sale_on").toString()));
		pstmt_sql.setLong(i*14+11, Long.parseLong(tmp.get("sale_all").toString()));
		pstmt_sql.setLong(i*14+12, Long.parseLong(tmp.get("bfsale_off").toString()));
		pstmt_sql.setLong(i*14+13, Long.parseLong(tmp.get("bfsale_on").toString()));
		pstmt_sql.setLong(i*14+14, Long.parseLong(tmp.get("bfsale_all").toString()));
	}
	rs_sql = pstmt_sql.executeUpdate();
	System.out.println("RS_SQL:"+rs_sql);	
 	
 	in = null;
 	ob = null;
 	objArr = null;
	data = null;
	pstmt_sql.close();
	conn_sql.close();	
	ob = new JSONObject();
 	ob.put("err_msg", "정상완료");
 	ob.put("err_cd", "0000");
}catch(Exception e){
	System.out.println(e.toString());
	response.setStatus(200);
	ob = new JSONObject();
 	ob.put("err_msg", e.toString());
 	ob.put("err_cd", "9999");
}finally{
 	out.println(ob.toJSONString());
}
%>
