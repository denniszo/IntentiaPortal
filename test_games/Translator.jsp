<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   
<%

String strLang=request.getParameter("lang") ; 
//String strLang="HB";
if(strLang == null || strLang.equals("")) strLang="IL";
String direction = "ltr";
String winWait="html/LoadingEN.html";

String lblAccount="Account:";
String lblSort="Sort:";
String lblClosed="Closed";
//	String lblBDCURD="Transaction Date:";
String cboxBank="Bank Transactions";
String lblOpened="Opened";
String lblMovType="Transaction Type:";
String btnShow="Show";
String btnCommit="Commit";
String lblDateFormat="Date Format:";
String lblToDate="To Date:";
String lblFromDate="From Date:";
String lblcboxGL="Bookkeeping Transactions"; 
	String Registration="Registration";
	String sumBank="Bank Sum: ";
	String sumGL="GL Sum: ";
	String sumALL="increment: ";

String msg1="Please type date in ddmmyy format only!";
String msg2="Invalid date range";
String msg3="Create Reconciliation";
String msg4="Cancel Reconciliation";
String msg5="Can't delite, Reconciliation is no exist.";
String msg6="Select Reconciliation lines";
String msg7="Checking amounts";
String msg8="Reconciliation amount not equal. The difference between the amounts is";
String msg9="Confirm the Reconciliation"; 
String msg10="Opening new Reconciliation";
String msg11="Opening the Reconciliation is Failed";
String msg12="Supplementing Bank lines";
String msg13="Reconciliation Failed";
String msg14="Supplementing the Bookkeeping lines";
String msg15="Creating Reconciliation";
String msg16="Reconciliation was carried Successfully";
String msg17="Checking the Bank lines";
String msg18="Checking the Bookkeeping lines";
String msg19="There no chosen Reconciliation for Cancel";
String msg20="Cancel the Bank Reconciliation";
String msg21="deletion was Successfully";
String msg22="Successfully Booted";
String noRows="No rows was selected";

String selAmuntDate = "Amount-Date";
String selDateAmunt = "Date-Amount";
String selReference = "Reference";
String selNoReference="Reference";

String ApiError = "M3 return Error in Api: ";
String txt_Messege = "Messege - ";

if(strLang.equals("IL"))
{      
	winWait="html/Loading.html";
	direction = "rtl";
	lblAccount="חשבון:";
	lblSort="מיון:";
	lblClosed="סגורות";
	cboxBank="תנועות בנק";
//		lblBDCURD="ת.תנועה";
	lblOpened="פתוחות";
	lblMovType="סוג תנועה:";
	btnShow="הצג";
	btnCommit="בצע התאמה";
	lblDateFormat="תבנית תאריך:";
	lblToDate="עד תאריך תנועה:";
	lblFromDate="מתאריך תנועה:";
	lblcboxGL="תנועות הנהלת חשבונות";
	Registration="רישום פק' יומן";
	sumBank="סה'כ בנק: ";
	sumGL="סה'כ הנה'ח: ";
	sumALL="הפרש: ";
	
	msg1="בלבד ddmmyy  אנא הקלד תאריך בפורמט";
	msg2="טווח תאריכים לא תקין!";
	msg3="בצע התאמה";
	msg4="בטל התאמה";
	msg5="התאמה אינה קיימת,מחיקה לא התבצעה.";
	msg6="יש לבחור שורות להתאמה.";
	msg7="בודק סכומים";
	msg8=" סכומי התאמה אינם שווים .ההפרש בין הסכומים הוא ";
	msg9="?האם לבצע את ההתאמה";
	msg10="פותח התאמה חדשה";
	msg11="פתיחת התאמה נכשלה.";
	msg12="מוסיף שורות בנק";
	msg13="התאמה נכשלה";
	msg14="מוסיף שורות הנהלת חשבונות";
	msg15="מבצע התאמה";
	msg16="התאמה בוצעה בהצלחה";
	msg17="בודק שורות בנק";
	msg18="שורות הנהלת חשבונות";
	msg19="לא נבחרו התאמות לביטול";
	msg20="מבטל התאמות בנק";
	msg21="מחיקה בוצעה בהצלחה";
	msg22="איתחול בוצע בהצלחה";
	noRows="לא נבחרו שורות";
	
	selAmuntDate = "סכום-תאריך";
	selDateAmunt="תאריך-סכום";
	selReference="אסמכתא";
	selNoReference = "מס.התאמה";
	
	ApiError = "שגיאה M3 API";
	txt_Messege = "הודעה - ";
}

%>
<head>
<script type="text/javascript">

var msg1="<%=msg1%>";
var msg2="<%=msg2%>";
var msg3="<%=msg3%>";
var msg4="<%=msg4%>";
var msg5="<%=msg5%>";
var msg6="<%=msg6%>";
var msg7="<%=msg7%>";
var msg8="<%=msg8%>";
var msg9="<%=msg9%>";
var msg10="<%=msg10%>";
var msg11="<%=msg11%>";
var msg12="<%=msg12%>";
var msg13="<%=msg13%>";
var msg14="<%=msg14%>";
var msg15="<%=msg15%>";
var msg16="<%=msg16%>";
var msg17="<%=msg17%>";
var msg18="<%=msg18%>";
var msg19="<%=msg19%>";
var msg20="<%=msg20%>";
var msg21="<%=msg21%>";
var msg22="<%=msg22%>";
var noRows="<%=noRows%>";
var ApiError="<%=ApiError%>";
var txt_Messege="<%=txt_Messege%>";
</script>
</head>
