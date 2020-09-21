<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.lang.Object" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.xml.parsers.*" %>
<%@ page import="org.w3c.dom.*" %>
<%
 Context ctx = null;
 DataSource ds = null;
 Connection con = null;
 Statement stmt = null;
 ResultSet rs = null;
 
 InputStream in= null;
 BufferedReader reader= null;

 in=request.getInputStream();
 StringBuffer fileData = new StringBuffer(1000);
 reader=new BufferedReader(new InputStreamReader(in,"utf-8"));

 char[] buf = new char[1024];

 int numRead=0;

 while((numRead=reader.read(buf)) != -1){
     fileData.append(buf, 0, numRead);
 }

 in.close();
 reader.close();
 
 String xml = fileData.toString();
 
 //String xml = "<ReceiptRequest><ReceiptNumber>115041221030001600003390</ReceiptNumber></ReceiptRequest>";

 ByteArrayInputStream stream = new ByteArrayInputStream(xml.getBytes());
 DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
 Document doc = builder.parse(stream);

 NodeList nodeUrl = doc.getElementsByTagName("ReceiptNumber");
 String ReceiptNo  = nodeUrl.item(0).getFirstChild().getNodeValue();

 try
 {
  ctx = new InitialContext();
  ds = (javax.sql.DataSource)ctx.lookup("pot");
  con = ds.getConnection();
  con.setAutoCommit(false);
  stmt = con.createStatement();
 } catch(Exception e) {
  out.println(e.toString());
 } finally {
 }

 int i = 0;
 int rowCnt = 0;

 String Category[] = new String[500];
 String SalesDate = "";
 String quantity[] = new String[500];
 String amount[] = new String[500];
 String isLuxury[] = new String[500];
 String sql = "";

 sql = "SELECT SALE_DT,PUMBUN_NAME,SALE_QTY,SALE_PRC,TOT_SALE_AMT,SC_TAX FROM TABLE(TRF.FN_SALE_INFO('" + ReceiptNo + "'))";

 try
 {
  rs = stmt.executeQuery(sql);

  while(rs.next())
  {
	SalesDate = rs.getString(1);
	SalesDate = SalesDate.substring(0,4) + '-' + SalesDate.substring(4,6) + '-' + SalesDate.substring(6,8);
	Category[rowCnt] = rs.getString(2);
	quantity[rowCnt] = rs.getString(3);
	amount[rowCnt] = rs.getString(5);
	isLuxury[rowCnt] = rs.getString(6);
	rowCnt = rowCnt + 1;
  }
 
 } catch(Exception e) {
  out.println(e.toString());
 
 } finally {
 }

 if (rowCnt == 0)
 {
	out.println("<error>No matched receipt</error>");
 }
 else
 {
%>
<ReceiptResponse xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
	<ErrorMessage i:nil="true"/>
	<PurchaseDateTime><%=SalesDate%></PurchaseDateTime>
	<PurchaseItems>
		<%
			for(i=0;i<rowCnt;i++)
			{
		%>
		<PurchaseItem>
			<DetailedDescription i:nil="true"/>
			<GoodDescription><%=Category[i]%></GoodDescription>
			<GrossAmount><%=amount[i]%></GrossAmount>
			<IsLuxury><%=isLuxury[i]%></IsLuxury>
			<Quantity><%=quantity[i]%></Quantity>
			<VatRate>10</VatRate>
		</PurchaseItem>
		<%
			}
		%>
	</PurchaseItems>
	<ReceiptNumber><%=ReceiptNo%></ReceiptNumber>
</ReceiptResponse>
<%
 }

if(rs != null)
{
   try 
   {
    rs.close();
   
   } catch (SQLException ex) { out.println("rs resource close fail"); }
}

if(stmt != null)
{
   try
   {
    stmt.close();
   
   } catch (SQLException ex) { out.println("stmt resource close fail"); }
}

if(con != null)
{
   try
   {
    con.close();
   
   } catch (SQLException ex) { out.println("con resource close fail"); }
}

%>