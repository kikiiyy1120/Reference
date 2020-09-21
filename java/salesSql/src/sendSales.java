import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.OutputStreamWriter;
import oracle.jdbc.OracleTypes;
import java.util.*;
import java.text.*;
import java.sql.*;
import java.net.*;
import org.json.simple.*;


public class sendSales {	
	public static void main(String[] args) {							
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
		
		Calendar cal1 = Calendar.getInstance();
		Calendar cal2 = Calendar.getInstance();
		cal2.set(cal1.get(Calendar.YEAR), cal1.get(Calendar.MONTH), cal1.get(Calendar.DATE)-1);
		String today = ""+cal1.get(Calendar.YEAR) + cal1.get(Calendar.MONTH)+1 + cal1.get(Calendar.DATE);
		String yesterday = ""+cal2.get(Calendar.YEAR) + cal2.get(Calendar.MONTH)+1 + cal2.get(Calendar.DATE);
		
		ArrayList<MobileSales> data= new ArrayList<MobileSales>();
		
		try{
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn_ora = DriverManager.getConnection(url_ora, user_ora, pass_ora);
			
			//today start///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////			
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
				data.add(tmpData);
			}
			
			JSONObject ob = new JSONObject();
			JSONObject obj[] = new JSONObject[data.size()];
			JSONArray objArr = new JSONArray();
		
		 	for(int i=0;i<data.size();i++){
		 		obj[i] = new JSONObject();
		 		obj[i].put("sale_dt", data.get(i).sale_dt);
		 		obj[i].put("type", data.get(i).type);
		 		obj[i].put("day", data.get(i).day);
		 		obj[i].put("gubun", data.get(i).gubun);
		 		obj[i].put("cmpr_dt", data.get(i).cmpr_dt);
		 		obj[i].put("goal_off", data.get(i).goal_off);
		 		obj[i].put("goal_on", data.get(i).goal_on);
		 		obj[i].put("goal_all", data.get(i).goal_all);
		 		obj[i].put("sale_off", data.get(i).sale_off);
		 		obj[i].put("sale_on", data.get(i).sale_on);
		 		obj[i].put("sale_all", data.get(i).sale_all);
		 		obj[i].put("bfsale_off", data.get(i).bfsale_off);
		 		obj[i].put("bfsale_on", data.get(i).bfsale_on);
		 		obj[i].put("bfsale_all", data.get(i).bfsale_all);
		 		objArr.add(obj[i]);
		 	}
		 	ob.put("mobileSales", objArr);
		 	System.out.println("--------------------------START----------------------------------------------------"+today);
		 	System.out.println("mobileSales.SP:");
		 	System.out.println(ob.toJSONString());
		 	
		 	URL url = new URL("http://192.168.133.101:8080/MobileSales/insertSales.jsp");
		 	HttpURLConnection hconn = (HttpURLConnection)url.openConnection();
		 	hconn.setDoOutput(true);
		 	hconn.setRequestMethod("POST");
		 	hconn.setRequestProperty("Content-Type", "text/html");
		 	hconn.setRequestProperty("Accept-Charset", "UTF-8");
		 	OutputStreamWriter osw = new OutputStreamWriter(hconn.getOutputStream());
		 	osw.write(ob.toJSONString());
		 	osw.flush();
		 	String inputLine = null;
		 	StringBuffer outResult = new StringBuffer();
		 	BufferedReader in = new BufferedReader(new InputStreamReader(hconn.getInputStream(), "UTF-8"));
		 	while((inputLine = in.readLine()) != null){
		 		outResult.append(inputLine);
		 	}
		 	hconn.disconnect();
		 	System.out.println("Response:");
		 	System.out.println(outResult);		 	
		 	System.out.println("--------------------------E-N-D----------------------------------------------------"+today);
		 	//today end///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//yesterday start///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////			
			cstmt_ora = conn_ora.prepareCall("CALL HB_CRM.PR_GET_MOBILE_SALES(?, ?)");
			cstmt_ora.setString(1, yesterday);
			cstmt_ora.registerOutParameter(2, OracleTypes.CURSOR);
			cstmt_ora.executeQuery();
			rs_ora = (ResultSet)cstmt_ora.getObject(2);
			data = new ArrayList<MobileSales>();
			while(rs_ora.next()){
			MobileSales tmpData = new MobileSales();
			tmpData.sale_dt = yesterday;
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
			
			ob = new JSONObject();
			obj = new JSONObject[data.size()];
			objArr = new JSONArray();
			
			for(int i=0;i<data.size();i++){
			obj[i] = new JSONObject();
			obj[i].put("sale_dt", data.get(i).sale_dt);
			obj[i].put("type", data.get(i).type);
			obj[i].put("day", data.get(i).day);
			obj[i].put("gubun", data.get(i).gubun);
			obj[i].put("cmpr_dt", data.get(i).cmpr_dt);
			obj[i].put("goal_off", data.get(i).goal_off);
			obj[i].put("goal_on", data.get(i).goal_on);
			obj[i].put("goal_all", data.get(i).goal_all);
			obj[i].put("sale_off", data.get(i).sale_off);
			obj[i].put("sale_on", data.get(i).sale_on);
			obj[i].put("sale_all", data.get(i).sale_all);
			obj[i].put("bfsale_off", data.get(i).bfsale_off);
			obj[i].put("bfsale_on", data.get(i).bfsale_on);
			obj[i].put("bfsale_all", data.get(i).bfsale_all);
			objArr.add(obj[i]);
			}
			ob.put("mobileSales", objArr);
			System.out.println("--------------------------START----------------------------------------------------"+yesterday);
			System.out.println("mobileSales.SP:");
			System.out.println(ob.toJSONString());
			hconn = (HttpURLConnection)url.openConnection();
		 	hconn.setDoOutput(true);
		 	hconn.setRequestMethod("POST");
		 	hconn.setRequestProperty("Content-Type", "text/html");
		 	hconn.setRequestProperty("Accept-Charset", "UTF-8");
			osw = new OutputStreamWriter(hconn.getOutputStream());
			osw.write(ob.toJSONString());
			osw.flush();
			inputLine = null;
		 	outResult = new StringBuffer();
		 	in = new BufferedReader(new InputStreamReader(hconn.getInputStream(), "UTF-8"));
		 	
			while((inputLine = in.readLine()) != null){
			outResult.append(inputLine);
			}
			hconn.disconnect();
			System.out.println("Response:");
			System.out.println(outResult);		 	
			System.out.println("--------------------------E-N-D----------------------------------------------------"+yesterday);
			//yesterady end///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		 	url = null;
		 	hconn = null;
		 	osw = null;
		 	in = null;
		 	ob = null;
		 	obj = null;
		 	objArr = null;
			data = null;
			cstmt_ora.close();
			conn_ora.close();
		}catch(Exception e){
			e.printStackTrace();
			System.out.println(e.toString());
		}
	}
}



