<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="application/json; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.*" %>
<%@page import="org.json.simple.*"%>
<%@ page import="java.io.*" %>
<%

class Cancel{
	String docid;
	String totalrefundamount;
	String issuedatetime;
	String receiptitems;
}
class ReceiptException extends Exception{
	JSONObject ob = new JSONObject();
	public ReceiptException(){
		//super();
	}
	public ReceiptException(String code, String msg){
		ob.put("err_cd", code);
		ob.put("err_msg", msg);
	}
}
JSONObject ob = new JSONObject();
String url = "jdbc:oracle:thin:@192.168.122.111:1521:nmario";
String user = "SYS as sysdba";
String pass = "mario4321";
Connection conn = null;
CallableStatement cstmt = null;
String sql = null;
Class.forName("oracle.jdbc.driver.OracleDriver");
conn = DriverManager.getConnection(url, user, pass);

String body = null;
StringBuilder stringBuilder = new StringBuilder();
BufferedReader bufferedReader = null;
InputStream inputStream = request.getInputStream();

/*
String urlSql = "jdbc:sqlserver://192.168.122.110:1433;databaseName=TMPTRAN;user=mariopos;password=qwer!234;";
Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
Connection connSql = DriverManager.getConnection(urlSql);
CallableStatement cstmtSql = null;
*/
 try
 {
	 System.out.println("-------------------------------------------------------CANCEL START");
	 
	 if (inputStream != null) {
         bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
         char[] charBuffer = new char[128];
         int bytesRead = -1;
         while ((bytesRead = bufferedReader.read(charBuffer)) > 0) {
             stringBuilder.append(charBuffer, 0, bytesRead);
         }
     } else {
         stringBuilder.append("");
     }
     body = stringBuilder.toString();     
     System.out.println(body);
     
     JSONParser parser = new JSONParser();
	  Object ob_body = parser.parse(body);
	  JSONObject json_body = (JSONObject)ob_body;
	  
	  Cancel cancel = new Cancel();
	  cancel.docid = json_body.get("docid").toString();
	  cancel.totalrefundamount = json_body.get("totalrefundamount").toString();
	  cancel.issuedatetime = json_body.get("issuedatetime").toString();
	  cancel.receiptitems = json_body.get("receiptitems").toString();
	  
	  System.out.println(cancel.receiptitems);
	 
	  
     System.out.println("docid = " + cancel.docid);
     System.out.println("totalrefundamount = " + cancel.totalrefundamount);
     System.out.println("issuedatetime = " + cancel.issuedatetime);
     System.out.println("receiptitems = " + cancel.receiptitems);
     
	 Object o_receiptitems = JSONValue.parse(cancel.receiptitems);
	 JSONArray a_receiptitems=(JSONArray)o_receiptitems;
	 JSONObject obj[] = new JSONObject[a_receiptitems.size()];
	 String sql_cd = "0000";
	 
	 conn.setAutoCommit(false);
	 //connSql.setAutoCommit(false);
	 
	 for(int i=0; i<a_receiptitems.size(); i++){		
		 obj[i] = (JSONObject)a_receiptitems.get(i);
		 sql = "CALL TRF.PR_SALE_INFO_CANCEL(?, ?, ?, ?, ?)";
		 cstmt =  conn.prepareCall(sql);
		 cstmt.setString(1, cancel.docid);
		 cstmt.setString(2, cancel.totalrefundamount);
		 cstmt.setString(3, cancel.issuedatetime);
		 cstmt.setString(4, obj[i].get("receiptnumber").toString());
		 cstmt.registerOutParameter(5, Types.VARCHAR);
		 cstmt.executeQuery();
		 sql_cd = String.format("%04d", Integer.parseInt(sql_cd) + Integer.parseInt(cstmt.getString(5)));
		 
		 System.out.println(i+"번째 oracle sql_cd: "+sql_cd);
		 
		 if(sql_cd.equals("0000")){
			 /*
			 sql = "EXEC TMPTRAN.DBO.PR_SALE_INFO_CANCEL ?, ?, ?, ?, ?";
			 cstmtSql = connSql.prepareCall(sql);
			 cstmtSql.setString(1, docid);
			 cstmtSql.setString(2, totalrefundamount);
			 cstmtSql.setString(3, issuedatetime);
			 cstmtSql.setString(4, obj[i].get("receiptnumber").toString());
			 cstmtSql.registerOutParameter(5, Types.VARCHAR);
			 cstmtSql.executeUpdate();
			 sql_cd = String.format("%04d", Integer.parseInt(sql_cd) + Integer.parseInt(cstmtSql.getString(5)));
			 System.out.println(i+"번째 mssql  sql_cd: "+sql_cd);
			 if(!sql_cd.equals("0000")){
				 break;
			 }
			 */
		 }else{
			 break;
		 }
	 }	 
	 if(sql_cd.equals("0000")){
		 conn.commit();
		 //connSql.commit();
	  	 response.setStatus(200);
	  	 throw new ReceiptException("0000", "데이터 입력 처리 완료");
	 }else{
	  	 response.setStatus(404);
	  	 throw new ReceiptException("7190", "영수증 찾을 수 없음 (Receipt not found.)");
	 }  
 }catch(SQLException e) {
	 conn.rollback();
	 //connSql.rollback();
	 response.setStatus(500);
	 ob.put("err_cd", "7001");
	 ob.put("err_msg", "데이터 처리 실패 SQL");
	 out.println(ob.toJSONString());
	 System.out.println(ob.toJSONString());
	 System.out.println(e.getMessage());
 }catch(ReceiptException e) {
	 conn.rollback();
	 //connSql.rollback();
	 out.println(e.ob.toJSONString());
	 System.out.println(e.ob.toJSONString());
 }catch(Exception e) {
	 conn.rollback();
	 //connSql.rollback();
	 response.setStatus(500);
	 ob.put("err_cd", "7001");
	 ob.put("err_msg", "데이터 처리 실패 ETC");
	 out.println(ob.toJSONString());
	 System.out.println(ob.toJSONString());
	 System.out.println(e.getMessage());
 }
 System.out.println("-------------------------------------------------------CANCEL END");
if(cstmt != null)
{
   try
   {
	   cstmt.close();
   
   } catch (SQLException ex) { 
	    response.setStatus(500);
		ob.put("err_cd", "7999");
		ob.put("err_msg", "기타 오류 (Other System Error : stmt resource fail to close)");
		System.out.println(ob.toJSONString());
	   }
}
if(conn != null)
{
   try
   {
	   conn.close();
   
   } catch (SQLException ex) { 
	    response.setStatus(500);
		ob.put("err_cd", "7999");
		ob.put("err_msg", "기타 오류 (Other System Error : conn resource fail to close)");
		System.out.println(ob.toJSONString());
	   }
}
bufferedReader.close();
/*
if(cstmtSql != null)
{
   try
   {
	   cstmt.close();
   
   } catch (SQLException ex) { 
	    response.setStatus(500);
		ob.put("err_cd", "7999");
		ob.put("err_msg", "기타 오류 (Other System Error : stmtSql resource fail to close)");
		System.out.println(ob.toJSONString());
	   }
}
if(connSql != null)
{
   try
   {
	   conn.close();
   
   } catch (SQLException ex) { 
	    response.setStatus(500);
		ob.put("err_cd", "7999");
		ob.put("err_msg", "기타 오류 (Other System Error : connSql resource fail to close)");
		System.out.println(ob.toJSONString());
	   }
}
*/
%>