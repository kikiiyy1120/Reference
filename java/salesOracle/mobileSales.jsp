<%@ page import="oracle.jdbc.OracleTypes"%>
<%@ page language="java" import="java.util.*" %>
<%@ page language="java" import="java.text.*" %>
<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

request.setCharacterEncoding("utf-8");

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
																						
String url_ora = "jdbc:oracle:thin:@192.168.122.111:1521:nmario";
String user_ora = "HB_CRM";
String pass_ora = "crm";
Connection conn_ora;
CallableStatement cstmt_ora;
ResultSet rs_ora;

String url_sql = "jdbc:sqlserver://192.168.133.101:1819;databaseName=MarioEIS";
String user_sql = "devSa";
String pass_sql = "mario12#$";
Connection conn_sql;
CallableStatement cstmt_sql;
ResultSet rs_sql;

java.util.Date date = new java.util.Date();
SimpleDateFormat simpleDate = new SimpleDateFormat("yyyyMMdd");
String today = simpleDate.format(date);

ArrayList<MobileSales> data= new ArrayList<MobileSales>();

try{
	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn_ora = DriverManager.getConnection(url_ora, user_ora, pass_ora);
	//Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	//conn_sql = DriverManager.getConnection(url_sql, user_sql, pass_sql);
	
	cstmt_ora = conn_ora.prepareCall("CALL HB_CRM.PR_GET_MOBILE_SALES(?, ?)");
	cstmt_ora.setString(1, today);
	cstmt_ora.registerOutParameter(2, OracleTypes.CURSOR);
	cstmt_ora.executeQuery();
	rs_ora = (ResultSet)cstmt_ora.getObject(2);
	while(rs_ora.next()){
		MobileSales tmpData = new MobileSales();
		tmpData.sale_dt = today;
		tmpData.type = rs_ora.getString("TYPE");
		tmpData.day = rs_ora.getString("DAY");
		tmpData.gubun = rs_ora.getString("GUBUN");
		tmpData.cmpr_dt = rs_ora.getString("CMPR_DT");
		tmpData.goal_off = rs_ora.getLong("GOAL_OFF");
		tmpData.goal_on = rs_ora.getLong("GOAL_ON");
		tmpData.goal_all = rs_ora.getLong("GOAL_ALL");
		tmpData.sale_off = rs_ora.getLong("SALE_OFF");
		tmpData.sale_on = rs_ora.getLong("SALE_ON");
		tmpData.sale_all = rs_ora.getLong("SALE_ALL");
		tmpData.bfsale_off = rs_ora.getLong("BFSALE_OFF");
		tmpData.bfsale_on = rs_ora.getLong("BFSALE_ON");
		tmpData.bfsale_all = rs_ora.getLong("BFSALE_ALL");
		out.println(tmpData.sale_all);
		out.println(tmpData.sale_off);
		out.println(tmpData.sale_on);
		data.add(tmpData);
	}
	
	//cstmt_sql = conn_sql.prepareCall("");
	
	//rs_sql = cstmt_sql.executeQuery();
	//while(rs_sql.next()){
		
	//}
	
	data = null;
	cstmt_ora.close();
	conn_ora.close();
	//cstmt_sql.close();
	//conn_sql.close();
}catch(Exception e){
	e.printStackTrace();
	System.out.println(e.toString());
	out.println(e.toString());
}
%>
