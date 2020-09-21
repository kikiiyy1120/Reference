<%@ page language="java" contentType="application/json; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.*" %>
<%@page import="org.json.simple.*"%>
<%
//response.addHeader("Access-Control-Allow-Origin", "*");

//response.addHeader("Access-Control-Allow-Credentials", "true");


class Product{
	String prdnm;
	String prdcode;
	int prdcnt;
	int prdamount;
	int grossamount;
	int indvat;
	int indict;
	int indedut;
	int indstr;
	public Product(){
		prdnm = null;
		prdcode = null;
		prdcnt = 0;
		prdamount = 0;
		grossamount = 0;
		indvat = 0;
		indict = 0;
		indedut = 0;
		indstr = 0;
	}
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
String receiptno = request.getParameter("receiptno");
String url = "jdbc:oracle:thin:@192.168.122.111:1521:nmario";
String user = "SYS as sysdba";
String pass = "mario4321";
Connection connSql = null;
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;

int rowCnt = 0;
int i = 0;
String sql = null;
String RECEIPTNO = null;
String RECEIPTDATETIME = null;
int TOTALPURCHASE = 0;
Product product[] = null;
JSONObject ob = new JSONObject();

Class.forName("oracle.jdbc.driver.OracleDriver");
conn = DriverManager.getConnection(url, user, pass);
stmt = conn.createStatement();

 try
 {
  System.out.println("-------------------------------------------------------RECEIPT START");
  System.out.println("GET parameter receiptno: "+receiptno);
  sql = "SELECT TRF.FN_SALE_INFO_VALID('" + receiptno + "') FROM DUAL";
  rs = stmt.executeQuery(sql);
	 
  while(rs.next())
  {
	  System.out.println("VALID:"+rs.getInt(1));
	  rowCnt = rs.getInt(1);  
  }
  
  if(rowCnt >= 7181){
	  String msg = null;
	  response.setStatus(423);
	  
	  
	  if(rowCnt == 7181)
		  msg = "반품 영수증 (Returned receipt) 반품";
	  else if (rowCnt == 7182)
		  msg = "환급 불가 영수증(Non-refundable receipt) 임대을 불가";
	  else if(rowCnt == 7183)
		  msg = "기 환급 영수증 (Receipt Already Refunded)";
	  
	  throw new ReceiptException(""+rowCnt, msg);	  
  }
  
  product = new Product[rowCnt];
  
  if (rowCnt == 0)
  {
 	 response.setStatus(404);
 	 throw new ReceiptException("7190", "영수증 찾을 수 없음 (Receipt not found.)");
  }
  else
  {
	sql = "SELECT RECEIPTNO,RECEIPTDATETIME,TOTALPURCHASE,PRDNM,PRDCODE,PRDCNT,PRDAMOUNT,GROSSAMOUNT,INDVAT,INDICT,INDEDUT,INDSTR FROM TABLE(TRF.FN_SALE_INFO_GET('" + receiptno + "'))";
	rs = stmt.executeQuery(sql);
	
	while(rs.next())
	{	  
		RECEIPTNO = rs.getString(1);
		RECEIPTDATETIME = rs.getString(2);
		TOTALPURCHASE = rs.getInt(3);
		
		product[i] = new Product();
		product[i].prdnm = rs.getString(4);
		product[i].prdcode = rs.getString(5);
		product[i].prdcnt = rs.getInt(6);
		product[i].prdamount = rs.getInt(7);
		product[i].grossamount = rs.getInt(8);
		product[i].indvat = rs.getInt(9);
		product[i].indict = rs.getInt(10);
		product[i].indedut = rs.getInt(11);
		product[i].indstr = rs.getInt(12); 
		
		i++;
	}
	i = 0;
	
 	JSONObject obj[] = new JSONObject[rowCnt];
 	JSONArray objArr = new JSONArray();

 	ob.put("receiptno", RECEIPTNO);
 	ob.put("reciptdatetime", RECEIPTDATETIME);
 	ob.put("totalpurchase", TOTALPURCHASE);  
 	
 	while(i < rowCnt){
 		obj[i] = new JSONObject();
 		obj[i].put("prdnm", product[i].prdnm);
 		obj[i].put("prdcode", product[i].prdcode);
 		obj[i].put("prdcnt", product[i].prdcnt);
 		obj[i].put("prdamount", product[i].prdamount);
 		obj[i].put("grossamount", product[i].grossamount);
 		obj[i].put("indvat", product[i].indvat);
 		obj[i].put("indict", product[i].indict);
 		obj[i].put("indedut", product[i].indedut);
 		obj[i].put("indstr", product[i].indstr);	
 		objArr.add(obj[i]);
 		i++;
 	}
 	ob.put("products", objArr);
 	out.println(ob.toJSONString());
 	System.out.println(ob.toJSONString());
  }
 }catch(SQLException e) {
	 response.setStatus(500);
	 ob.put("err_cd", "7999");
	 ob.put("err_msg", "기타 오류 (Other System Error : DB function call fail)");
	 out.println(ob.toJSONString());
	 System.out.println(ob.toJSONString());
	 System.out.println(e.getMessage());
 } catch(ReceiptException e){
	 out.println(e.ob.toJSONString());
	 System.out.println(e.ob.toJSONString());
 } catch(Exception e) {
	 response.setStatus(500);
	 ob.put("err_cd", "7999");
	 ob.put("err_msg", "기타 오류 (Other System Error : unknown)");
	 out.println(ob.toJSONString());
	 System.out.println(ob.toJSONString());
 } 

 System.out.println("-------------------------------------------------------RECEIPT END");
if(rs != null)
{
   try 
   {
    rs.close();
   
   } catch (SQLException ex) { 
	   	response.setStatus(500);
		ob.put("err_cd", "7999");
		ob.put("err_msg", "기타 오류 (Other System Error : rs resource fail to close)");
		System.out.println(ob.toJSONString());
	   }
}

if(stmt != null)
{
   try
   {
    stmt.close();
   
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

%>