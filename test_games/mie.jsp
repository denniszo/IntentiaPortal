<%@page import="java.io.*"%><%@page import="java.sql.*"%><%@page contentType="text/html; charset=UTF-8" %><%@ page import = "java.util.*" %>
<%@ page import = "java.io.BufferedReader" %>
<%@ page import = "javax.xml.parsers.DocumentBuilderFactory" %>
<%@ page import = "javax.xml.parsers.DocumentBuilder" %>
<%@ page import = "org.w3c.dom.Document" %>
<%@ page import = "org.w3c.dom.NodeList" %>
<%@ page import = "org.w3c.dom.Node" %>
<%@ page import = "org.w3c.dom.Element" %>
<%@ page import = "org.xml.sax.InputSource" %>
<%@ page import = "java.io.StringReader" %>
<%	

//System.out.println("XXXXXXXXXXXXXXXX");
BufferedReader br = request.getReader();
String line = "";
String xml="";
String[] xmlAr = new String[2];
if((line = br.readLine()) != null) {
	xmlAr=line.split("\\{");
	xml=xmlAr[0];
	// System.out.println(xml);
}


//out.println(xml);
String params="";
String model="";
if(!xml.equals("")){
	params=parseParameters(xml);
	model=parseMIEmodel(xml);
	
	//System.out.println(model);
	
	
	String strSQL="";
	strSQL=getStatement(model);
	strSQL=strSQL.replace("\n"," ");
	strSQL=strSQL.replace("~","'");
	//strSQL=strSQL.replace("||","+");
	strSQL=strSQL.replace(" ##"," MVXJDTATST.");
	
	strSQL=strSQL.replace("##"," ");
	
	//out.println(strSQL);    
	
	//out.println("<br />");
	
	String select=getFields(model);
	String[] arSelect=select.split(",");
	
	String [] ArParams=params.split(";");
	 String par="";
	 String val="";
	 
	  for(int i=0;i<ArParams.length;i++){
		  par=ArParams[i];
		
		  if(par==null) break;
		  i++;
		  val=ArParams[i];
		  
		  if(val==null) out.println("XXX");
	//	  out.println("par=" + par + " val=" + val + " <br />");
		//  out.println(i);
		  strSQL=strSQL.replace("%"+par+"%",val);
		//  out.println(i);
	  }
	  
	//  out.println(strSQL);
	// System.out.println(strSQL);
 
	  java.sql.DriverManager.registerDriver (new com.ibm.as400.access.AS400JDBCDriver ());
		 
	  String url =  "jdbc:as400://10.0.13;databasename=MVXJDTATST;user=int_portal;password=Int12345";
      
      //jdbc:sqlserver://paris:1433;databaseName=MVXGRID;user=MDBUSR;password=Int12345;TrustedConnection=false;
      Connection conn = DriverManager.getConnection(url);
      Statement stmt = conn.createStatement();
      ResultSet rs;
      System.out.println(strSQL);
      rs = stmt.executeQuery(strSQL);
      
      int i=0;
	  String sel="";
	  String selResult="";
	  String rest="";
	  rest+="<mie:Model xmlns:mie=\"http://schemas.intentia.com/mie/\" xmlns:dt=\"urn:schemas-microsoft-com:datatypes\"><SSet/><Navigator><Lbl>&lt;Label is missing&gt;</Lbl>";
	  rest+="<Mdl.FK>10B85EA5-A11D-4ADF-B9E8-2DB8F5302C4E</Mdl.FK><Prp>1</Prp>";
	  rest+="<FFlds>";
	  
	  for(int p=0;p<ArParams.length;p++){
		  par=ArParams[p];
		
		  if(par==null) break;
		  p++;
		  val=ArParams[p];
		  
		  if(val==null) out.println("XXX");
		  rest+="<K>" + par + "</K>";
		  rest+="<V>" + val + "</V>";
		  
		//  out.println(i);
	  }
	  /*
	  for(int j=0;j<arSelect.length;j++){
		  sel=arSelect[j].trim(); //21.7.14 added trim
		  rest+="<f n=\""  + sel +  "\"/>";
	  }*/
	  rest+="</FFlds>";
	  rest+="<Chld><Sel><Lbl>&lt;Label is missing></Lbl><Mdl.FK>F3B61FCC-1F56-4B38-83A5-D0D8154645AB</Mdl.FK><Prp>1</Prp><Cnt>25</Cnt>";
	  rest+="<Chld>";
      while ( rs.next() ) {
    	  rest+="<Inst>";
    	  rest+="<Lbl>&lt;Label is missing></Lbl><Mdl.FK>6CCBF547-607D-4442-8CF0-0C605E0064B8</Mdl.FK>";
    	//  if(i>0) rest+=",";
    	  rest+="<FFlds>";
    	  for(int j=0;j<arSelect.length;j++){
			 
			  sel=arSelect[j].trim(); //21.7.14 added trim
			  selResult=rs.getString(sel);
			  if(selResult==null) selResult="";
			  rest+="<K>"+sel+"</K>";
			 
			  rest+="<V>"+selResult.trim().replace("\"","\\\"") + "</V>" ; 
			  
		  
		  	}
    	  rest+="</FFlds>";
    	  rest+="<Chld/>";
    	  rest+="</Inst>";
      }
      rest+="</Chld>";
      rest+="<UpFrq>5</UpFrq><IsExc>true</IsExc>";
      rest+="</Sel></Chld>";
      rest+="<Name>" + model + "</Name>";
      rest+="</Navigator><Diag/></mie:Model>";
	out.println(rest);
	System.out.println(rest);
} //if xml exists
//xml="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><mie:Model xmlns:dt=\"urn:schemas-microsoft-com:datatypes\" xmlns:mie=\"http://schemas.intentia.com/mie/\"><SSet><K>__mie_appid</K><V>MIE60TEST</V><K>flags</K><V>0</V></SSet><Navigator><FFlds><K>lng</K><V>IL</V><K>userid</K><V>int-moshea</V><K>divi</K><V>007</V><K>WhereString</K><V> and OKCUNO='21038' </V><K>cono</K><V>1</V></FFlds><Chld></Chld><Name>FR_Product_ListCustomers</Name></Navigator></mie:Model>";


%>




<%!

	public static String parseParameters(String xml) {
		String ret="";
		String params="";
	  try {
	
	  
	  	
	    	//System.out.println(xml);
		//File fXmlFile = new File("E:/Infor/LifeCycle/FRv-WP10/grid/Test/applications/intentia/webapps/intentia/mieinput.xml");
			
		DocumentBuilder db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
		InputSource is = new InputSource();
		is.setCharacterStream(new StringReader(xml));
	
		Document doc = db.parse(is);
	
		//optional, but recommended
		//read this - http://stackoverflow.com/questions/13786607/normalization-in-dom-parsing-with-java-how-does-it-work
		doc.getDocumentElement().normalize();
	
		//System.out.println("Root element :" + doc.getDocumentElement().getNodeName());
	
		NodeList nList = doc.getElementsByTagName("FFlds");
		
		//System.out.println(kList.getLength());
		//System.out.println("----------------------------");
		
		for (int temp = 0; temp < nList.getLength(); temp++) {
	
			Node nNode = nList.item(temp);
		
			
			
				//System.out.println("\nCurrent Element :" + nNode.getNodeName() + " i=" );
				
				if (nNode.getNodeType() == Node.ELEMENT_NODE) {
					
					Element eElement = (Element) nNode;
					
					NodeList kList = eElement.getElementsByTagName("V");
					for(int i=0;i<kList.getLength();i++){
						params+= eElement.getElementsByTagName("K").item(i).getTextContent() + ";" +  eElement.getElementsByTagName("V").item(i).getTextContent() + ";";
						
					}
			}
		}
		
		//System.out.println(params);
	  } catch (Exception e) {
		e.printStackTrace();
	  }
	  	ret=params;
	  	return ret;
}

public static String parseMIEmodel(String xml) {
	String ret="";
	String params="";
  try {

  
  		
	DocumentBuilder db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
	InputSource is = new InputSource();
	is.setCharacterStream(new StringReader(xml));

	Document doc = db.parse(is);

	doc.getDocumentElement().normalize();

		
	NodeList nName = doc.getElementsByTagName("Name");
	for (int temp = 0; temp < nName.getLength(); temp++) {

		Node nNode = nName.item(temp);
		if (nNode.getNodeType() == Node.ELEMENT_NODE) {
			
			Element eElement = (Element) nNode;
			ret =eElement.getTextContent() ;
		}
	}
	return ret;
	
	//System.out.println(params);
  } catch (Exception e) {
	e.printStackTrace();
  }
  	ret=params;
  	return ret;
}

public static String getStatement(String Model){
	
	String ret="";
	String url = "jdbc:sqlserver://frv-wp10:1433;databaseName=MIEMETA90;user=MIEMETA90;password=Int12345;TrustedConnection=false;";;
	Connection conn;
	try {
		conn = DriverManager.getConnection(url);

      Statement stmt = conn.createStatement();
      ResultSet rs;

      String strSQL="";
      strSQL+=" SELECT  Statement "; 
     
      strSQL+=" FROM [MIEMETA90].[MIEMETA90].[RuntimeView]  "; 
      strSQL+=" where  Name like '"  + Model +  "%'  "; 
      strSQL+=" and Type=0 "; 
      
      rs = stmt.executeQuery(strSQL);
      int i=0;
      if ( rs.next() ) {
    	  ret=rs.getString("Statement").trim();
    	  
      }
      
      rs.close();
      conn.close();
      
	} catch (Exception e) {
	System.err.println("Got an exception! ");
	System.err.println(e.getMessage());
	}
	
	return ret;
}


public static String getFields(String Model){
	
	String ret="";
	String url = "jdbc:sqlserver://frv-wp10:1433;databaseName=MIEMETA90;user=MIEMETA90;password=Int12345;TrustedConnection=false;";;
	Connection conn;
	try {
		conn = DriverManager.getConnection(url);

      Statement stmt = conn.createStatement();
      ResultSet rs;

      String strSQL="";
	  strSQL+=" SELECT    Field ";  
	  strSQL+=" FROM [MIEMETA90].[MIEMETA90].[RuntimeView]";
	  strSQL+=" join [MIEMETA90].[MIEMETA90].[ForwardFields] on  FKey_Models=PKey_Model"; 
	  strSQL+=" where  Name like '"  + Model +  "%' ";
	  strSQL+=" and Type='2'";
       
      rs = stmt.executeQuery(strSQL);
      int i=0;
      while ( rs.next() ) {
    	  ret+=rs.getString("Field").trim()+",";
    	  
      }
      
      rs.close();
      conn.close();
      
	} catch (Exception e) {
	e.printStackTrace();
	System.err.println("Got an exception! ");
	System.err.println(e.getMessage());
	}
	
	return ret;
}

%>