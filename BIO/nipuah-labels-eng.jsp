<%
	String title_first = "Extrusion Department";
	String startWork = "התחלת עבודה";
	String prodReport = "דיווח יצור";
	String stopWork = "עצירת עבודה";
	String endWork = "סיום הוראה";
	
	String title_start = "שיחול - תחילת עבודה";
	String title_stop = "שיחול - עצירת עבודה";
	String title_end = "שיחול - סיום הוראה";
	String moNumber = "מספר הוראה";
	String reportDate = "תאריך";
	String reportHour = "שעה";
	String doBtn = "בצע";
	String exitBtn = "יציאה";
	
	String title_report = "שיחול - דיווח יצור";
	String lblOddRoll = "גליל אי-זוגי";
	String lblEvenRoll = "גליל זוגי";
	String lblRollNumber = "מספר גליל";
	String lblWidth = "רוחב";
	String lblLength = "אורך";
	String lblWeight = "משקל";
	String lblEmp = "עובד";
	String lblLocation = "מתקן";
	String lblNote = "הערה";
	String lblDate = "תאריך";
	String lblHour = "שעה";
	String lblOrder = "הוראת יצור";
	String lblOvi = "עובי";
	String lblType = "סוג";
	String lblPrint = "להדפיס מדבקות?";
	
	String page_dir = "rtl";
	String labels_align = "left";
	String input_align = "right";
	
	String error_notExist = "!!!מספר הוראה איננו קיים";
	String error_tooMuch = "בעייה במספר ההוראה - צור קשר עם מנהל היצור";
	String error_oddWeightNotOk = "האורך והמשקל של הגליל האי-זוגי אינם תואמים";
	String error_evenWeightNotOk = "האורך והמשקל של הגליל הזוגי אינם תואמים";
	String error_missingData = "לא ניתן לדווח כי חסר נתונים";
	String error_OddWidthNotOk = "הרוחב של הגליל האי-זוגי איננו בתחום המותר, הכנס סיסמה";
	String error_EvenWidthNotOk = "הרוחב של הגליל הזוגי איננו בתחום המותר, הכנס סיסמה";
	String error_wrongDate = "!!!התאריך איננו תקף";
	String error_wrongTime = "!!!השעה איננה תקפה";
	String error_wrongOddDate = "!!!התאריך של הגליל האי-זוגי איננו תקף";
	String error_wrongEvenDate = "!!!התאריך של הגליל הזוגי איננו תקף";
	String error_wrongOddTime = "!!!השעה של הגליל האי-זוגי איננה תקפה";
	String error_wrongEvenTime = "!!!השעה של הגליל הזוגי איננה תקפה";
	String error_oddDateNotInRange = "!!!התאריך של הגליל האי-זוגי לא בתחום המותר";
	String error_evenDateNotInRange = "!!!התאריך של הגליל הזוגי לא בתחום המותר";
	
	String error_missingRoll = "!!!חסר מספרי הגלילים";
	String error_missingLength1 = "!!!חסר אורך של הגליל האי-זוגי";
	String error_missingLength2 = "!!!חסר אורך של הגליל האזוגי";
	String error_missingWidth1 = "!!!חסר רוחב של הגליל האי-זוגי";
	String error_missingWidth2 = "!!!חסר רוחב של הגליל הזוגי";
	String error_missingWeight1 = "!!!חסר משקל של הגליל האי-זוגי";
	String error_missingWeight2 = "!!!חסר משקל של הגליל הזוגי";
	String error_missingEmp1 = "!!!חסר עובד של הגליל האי-זוגי";
	String error_missingEmp2 = "!!!חסר עובד של הגליל הזוגי";
	String error_missingLoc1 = "!!!חסר מתקן של הגליל האי-זוגי";
	String error_missingLoc2 = "!!!חסר מתקן של הגליל הזוגי";
	String error_missingDate1 = "!!!חסר תאריך של הגליל האי-זוגי";
	String error_missingDate2 = "!!!חסר תאריך של הגליל האזוגי";
	String error_missingHour1 = "!!!חסר שעה של הגליל האי-זוגי";
	String error_missingHour2 = "!!!חסר שעה של הגליל הזוגי";
	String error_toLate1 = "!!!תאריך של הגליל האי-זוגי מאוחר מהיום";
	String error_toLate2 = "!!!תאריך של הגליל הזוגי מאוחר מהיום";
	
	String error_missingOrder = "!!!חסר הוראת יצור";
	String error_missingDate = "!!!חסר תאריך";
	String error_missingHour = "!!!חסר שעה";
	String error_employeeNotExists = "!!!עובד לא קיים";
%>