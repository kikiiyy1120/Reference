<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page language="java" import="java.text.*" %>

<% 
class IParking{
	Connection conn = null;
	String sql = null;
	CallableStatement cs = null;

    String err = null;
	
	IParking(){};

	boolean connection(){
		try
		{
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");			
			String url = "jdbc:sqlserver://192.168.132.91:1433;databaseName=TMPTRAN;user=mariopos;password=qwer!234;";
			conn = DriverManager.getConnection(url);
			return true;
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return false;
		}
	}
	
	String selectCarNo(String inStr){
		String output = null;
		try{
			connection();
			cs =  conn.prepareCall("{call PR_SELECT_IPARKING_CARNUM(?,?)}");
			cs.setString(1, inStr);
			cs.registerOutParameter(2, java.sql.Types.VARCHAR);
			
			cs.execute();
			output = cs.getString(2);
			System.out.println(cs.getString(2));
			
			cs.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
			err = e.toString();
		}
		return output;
	}
String insertIParkingInf(String inStr){
		
		String output = null;
		
		try{
			connection();
			cs =  conn.prepareCall("{call PR_INSERT_IPARKING_INF(?,?)}");
			cs.setString(1, inStr);
			cs.registerOutParameter(2, java.sql.Types.VARCHAR);
			
			cs.execute();
			output = cs.getString(2);
			System.out.println(cs.getString(2));

			cs.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
			System.out.println(e);
		}
		return output;
	}
}

IParking ip = new IParking();
String test = null;
test = ip.selectCarNo("1234");


%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<br>
<%=test%>
</body>
</html>