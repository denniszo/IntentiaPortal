<%
// we need those includes and imports:
%>


<%@ page import = "com.intentia.mwsf.client.sdk.connectionmanager.*"%>
<%@ page import = "com.intentia.mwsf.client.sdk.util.MWSFClientException"%>
<%@ page import = "java.util.Iterator,
    com.intentia.mie.IMieEntity" %>
<%@ page import = "com.intentia.mie.IMieCollection" %>
<%@ page import = "com.intentia.mie.MieCollectionFactory" %>

<%@include file="../i_IBrixVars.inc"%>


<%
//use example:

String strDTID;
String mvxd = String.valueOf(MvxDivision);
String MIEserverURLHardCoded = "";
if (mvxd.indexOf("1") >= 0)
	MIEserverURLHardCoded = "http://10.0.0.12/MIE50/MieIsapi.dll";
else
	MIEserverURLHardCoded = "http://mwpus/MIE50/MieIsapi.dll";


strDTID=GetDTID(MIEserverURLHardCoded,  MIEAppID,  strCONO);

%>



<%!
public String GetDTID(String MIEserverURLHardCoded, String MIEAppID, String strCONO)
{
	String strTmpReturn="";
// get current DTID
		// SQL statement:
		// select max(MMDTID) + 1 as NEXTID 
		// from ##MITMAS##  where mmcono=%cono%
		
		try{
		
// Create Mie Java Collection, with model name, MIE AppID, och path to the Workplace MIE bridge
		 IMieCollection instanceCollection = MieCollectionFactory.create("FR_Items_GetNextItemID",MIEserverURLHardCoded , MIEAppID);
		 
		
		 instanceCollection.setValue("cono", strCONO);
				 
		 // Execute model
	     instanceCollection.execute();
		 Iterator instanceIterator = instanceCollection.iterator();
	     IMieEntity entity = null;
	      // Loop over all instances in result and insert them into the combobox
	  
	    
	        while (instanceIterator.hasNext())
	     {
		     	
		    entity = (IMieEntity)instanceIterator.next();
		    strTmpReturn= entity.getValue("NEXTID") ;
		    
		}
		
		instanceIterator=null;
		
		}
		catch(com.intentia.mie.MieCollectionException e)
		{
		//out.println("=================================<BR>MIE error<BR>");
		}
		
		return strTmpReturn;
}


public String MTEINFinsert(String MIEserverURLHardCoded, String MIEAppID, String strCONO, String strDTID, String strCFMF, String strAlpha, String strValue, String strDate, String strTime, String strMvxUser )
{
	String strTmpReturn="";
// inset line to MTEINF
		// SQL statement:
		//INSERT INTO 
		//##MTEINF##
		//(UICONO, UIDTID, UICFMG, UICFMF,  
		//UICFMA, UICFMN, UICFMD, UIRGDT, UIRGTM, 
		//UILMDT, UICHNO, UICHID) 
		//VALUES(%cono%, %dtid%, '150', '%cfmf%', %alpha%  , %value%, 0  ,
		//%date%,     %time%, %date%, 1, '%mvxuser%')
		
		try{
		
// Create Mie Java Collection, with model name, MIE AppID, och path to the Workplace MIE bridge
		 IMieCollection instanceCollection = MieCollectionFactory.create("FR_Items_MTEINF_Insert",MIEserverURLHardCoded , MIEAppID);
		 
		
		 instanceCollection.setValue("cono", strCONO);
		 instanceCollection.setValue("dtid", strDTID);
		 instanceCollection.setValue("cfmf", strCFMF);
		 instanceCollection.setValue("value", strValue);
		 instanceCollection.setValue("alpha", strAlpha);
		 instanceCollection.setValue("date", strDate);
		 instanceCollection.setValue("time", strTime);
		 instanceCollection.setValue("mvxuser", strMvxUser);
		
		
				 
		 // Execute model
	     instanceCollection.execute();
		
		
		instanceCollection=null;
		
		}
		catch(com.intentia.mie.MieCollectionException e)
		{
		//out.println("=================================<BR>MIE error<BR>");
		}
		
		return strTmpReturn;
}

%>