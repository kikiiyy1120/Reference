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

Calendar cal1 = Calendar.getInstance();
Calendar cal2 = Calendar.getInstance();

cal2.set(cal1.get(Calendar.YEAR), cal1.get(Calendar.MONTH), cal1.get(Calendar.DATE)-1);

String today = ""+cal1.get(Calendar.YEAR);
if((cal1.get(Calendar.MONTH)+1) < 10)
	today += "0" + (cal1.get(Calendar.MONTH)+1);
else
	today += "" + (cal1.get(Calendar.MONTH)+1);

if(cal1.get(Calendar.DATE) < 10)
	today += "0" + cal1.get(Calendar.DATE);
else
	today += "" + cal1.get(Calendar.DATE);

String yesterday = ""+cal2.get(Calendar.YEAR);
if((cal2.get(Calendar.MONTH)+1) < 10)
	yesterday += "0" + (cal2.get(Calendar.MONTH)+1);
else
	yesterday += "" + (cal2.get(Calendar.MONTH)+1);

if(cal2.get(Calendar.DATE) < 10)
	yesterday += "0" + cal2.get(Calendar.DATE);
else
	yesterday += "" + cal2.get(Calendar.DATE);


System.out.println("today"+today);
System.out.println("yesterday"+yesterday);

java.util.Date date = new java.util.Date();
SimpleDateFormat simpleDate = new SimpleDateFormat("yyyyMMdd");
date.setYear(120);
date.setMonth(1);
date.setDate(1);
System.out.println("START_SQL:"+simpleDate.format(date)); //20180101


%>
