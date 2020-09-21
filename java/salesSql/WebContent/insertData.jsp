<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.OutputStreamWriter"%>
<%@ page import="oracle.jdbc.OracleTypes"%>
<%@ page language="java" import="java.util.*" %>
<%@ page language="java" import="java.text.*" %>
<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" import="java.net.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.*"%>
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
PreparedStatement pstmt_ora;
ResultSet rs_ora = null;

//String url_sql = "jdbc:sqlserver://192.168.133.101:1819;databaseName=MarioEIS;user=devSa;password=mario12#$;";
//PreparedStatement pstmt_sql = null;
int rs_sql;
int sum = 0;
String sql = "test";


java.util.Date date = new java.util.Date();
SimpleDateFormat simpleDate = new SimpleDateFormat("yyyyMMdd");
String aim = simpleDate.format(date);

ArrayList<MobileSales> data;

try{
	//Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	//Connection conn_sql = DriverManager.getConnection(url_sql);
	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn_ora = DriverManager.getConnection(url_ora, user_ora, pass_ora);
	cstmt_ora = conn_ora.prepareCall("CALL HB_CRM.PR_GET_MOBILE_SALES(?, ?)");
	pstmt_ora = conn_ora.prepareStatement(sql);
	//pstmt_sql = null;
	date.setYear(118);
	date.setMonth(6);
	date.setDate(1);
	aim = "20181001";
	System.out.println("AIM:"+aim);
	System.out.println("START:"+simpleDate.format(date)); //20180101
	
	//while(!simpleDate.format(date).equals(today)){
	while(!simpleDate.format(date).equals(aim)){
		data = new ArrayList<MobileSales>();
		cstmt_ora = conn_ora.prepareCall("CALL HB_CRM.PR_GET_MOBILE_SALES(?, ?)");
		cstmt_ora.setString(1, simpleDate.format(date));
		cstmt_ora.registerOutParameter(2, OracleTypes.CURSOR);
		cstmt_ora.executeQuery();
		rs_ora = (ResultSet)cstmt_ora.getObject(2);
		while(rs_ora.next()){
			MobileSales tmpData = new MobileSales();
			tmpData.sale_dt = simpleDate.format(date);
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
			data.add(tmpData);
		}
		
		sql = "INSERT ALL";
		for(int i=0;i<data.size();i++){
			sql += " INTO HB_CRM.TMP_MOBILESALES VALUES (? ,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		}
		sql += "SELECT * FROM DUAL";
		pstmt_ora = conn_ora.prepareStatement(sql);
		for(int i=0;i<data.size();i++){
			pstmt_ora.setString(i*14+1, data.get(i).sale_dt);
			pstmt_ora.setString(i*14+2, data.get(i).type);
			pstmt_ora.setString(i*14+3, data.get(i).day);
			pstmt_ora.setString(i*14+4, data.get(i).cmpr_dt);
			pstmt_ora.setString(i*14+5, data.get(i).gubun);
			pstmt_ora.setLong(i*14+6, data.get(i).goal_off);
			pstmt_ora.setLong(i*14+7, data.get(i).goal_on);
			pstmt_ora.setLong(i*14+8, data.get(i).goal_all);
			pstmt_ora.setLong(i*14+9, data.get(i).sale_off);
			pstmt_ora.setLong(i*14+10, data.get(i).sale_on);
			pstmt_ora.setLong(i*14+11, data.get(i).sale_all);
			pstmt_ora.setLong(i*14+12, data.get(i).bfsale_off);
			pstmt_ora.setLong(i*14+13, data.get(i).bfsale_on);
			pstmt_ora.setLong(i*14+14, data.get(i).bfsale_all);
		}
		rs_sql = pstmt_ora.executeUpdate();
		sum += rs_sql;
		data = null;
		System.out.println(simpleDate.format(date)+":INSERT:"+rs_sql+" 누적:"+sum);
		date.setDate(date.getDate()+1);
	}
	System.out.println("END:"+simpleDate.format(date));
	
	data = null;
	pstmt_ora.close();
	//pstmt_sql.close();
	//conn_sql.close();
	cstmt_ora.close();
	conn_ora.close();
	rs_ora.close();
}catch(Exception e){
	//e.printStackTrace();
	System.out.println(e.toString());
	out.println(e.toString());
}
%>
