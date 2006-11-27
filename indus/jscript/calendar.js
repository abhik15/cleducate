calDateFormat    = "dd/mm/yyyy";topBackground= "white";bottomBackground="white";
tableBGColor="#959595";cellColor="white";headingCellColor="white";headingTextColor="navy";
dateColor="blue";focusColor="#ff0000";hoverColor="#ff0000";fontStyle="8pt Verdana, helvetica";
headingFontStyle="bold 8pt Verdana, helvetica"; bottomBorder=false;
tableBorder=1;var isNav=false;var isIE=false;
if(navigator.appName=="Netscape")
{isNav = true;}
else
{isIE = true;}
selectedLanguage=navigator.language;
buildCalParts();
function setDateField(dateField,todayDate)
{
calDateField = dateField;
inDate = dateField.value;
setInitialDate(todayDate);
calDocTop    = buildTopCalFrame();
calDocBottom = buildBottomCalFrame();
}
function setInitialDate(todayDate) {
calDate = new Date(todayDate);
if (isNaN(calDate)){
calDate = new Date();
}
calDay  = calDate.getDate();
calDate.setDate(1);
}
function showCalendar(dateField)
{
setDateField(dateField);
calDocFrameset = "<HTML><HEAD></HEAD>\n<FRAMESET ROWS='70,*' FRAMEBORDER='0'>\n<FRAME NAME='topCalFrame' SRC='javascript:parent.opener.calDocTop' SCROLLING='no'>\n<FRAME NAME='bottomCalFrame' SRC='javascript:parent.opener.calDocBottom' SCROLLING='no'>\n</FRAMESET>\n";
top.newWin = window.open("javascript:parent.opener.calDocFrameset", "calWin", winPrefs);
top.newWin.focus();
}
function buildTopCalFrame() {
var calDoc ="<HTML><HEAD></HEAD><BODY BGCOLOR='" + topBackground + "'><FORM NAME='calControl' onSubmit='return false;'><CENTER><TABLE CELLPADDING=0 CELLSPACING=1 BORDER=0><TR><TD COLSPAN=7><CENTER>"+
getMonthSelect() +"<INPUT NAME='year' VALUE='" + calDate.getFullYear() + "'TYPE=TEXT SIZE=4 MAXLENGTH=4 onChange='parent.opener.setYear()'></CENTER></TD></TR><TR><TD COLSPAN=7><INPUT TYPE=BUTTON NAME='previousYear' VALUE='<<'    onClick='parent.opener.setPreviousYear()'><INPUT TYPE=BUTTON NAME='previousMonth' VALUE=' < '   onClick='parent.opener.setPreviousMonth()'><INPUT TYPE=BUTTON NAME='today' VALUE='Today' onClick='parent.opener.setToday()'><INPUT TYPE=BUTTON NAME='nextMonth' VALUE=' > '   onClick='parent.opener.setNextMonth()'><INPUT TYPE=BUTTON NAME='nextYear' VALUE='>>'    onClick='parent.opener.setNextYear()'></TD></TR></TABLE></CENTER></FORM></BODY></HTML>";
return calDoc;
}
function buildBottomCalFrame(){
var calDoc=calendarBegin;
month=calDate.getMonth();year=calDate.getFullYear();day=calDay;
var i=0;
var days=getDaysInMonth();
if (day>days){day=days;}
var firstOfMonth = new Date (year, month, 1);
var startingPos  = firstOfMonth.getDay();
days+=startingPos;
var columnCount=0;
for (i=0; i<startingPos; i++) {calDoc+=blankCell;columnCount++;}
var currentDay=0;
var dayType="weekday";
for (i = startingPos; i < days; i++) {var paddingChar = "&nbsp;";
if (i-startingPos+1 < 10){padding = "&nbsp;&nbsp;";}
else{padding = "&nbsp;";}
currentDay = i-startingPos+1;
if (currentDay == day){dayType = "focusDay";}
else {dayType = "weekDay";}
calDoc += "<TD align=center bgcolor='" + cellColor + "'><a class='lnkblu' href='javascript:parent.opener.returnDate("+currentDay+ ")' title=\"Click here for select this date\">"+padding+currentDay+paddingChar+"</a></TD>";
columnCount++;
if(columnCount % 7 == 0) {calDoc += "</TR><TR>";}
}
for(i=days;i<42;i++){calDoc += blankCell;columnCount++;
if(columnCount % 7==0){calDoc += "</TR>";
if(i<41){calDoc += "<TR>";}
}
}
calDoc += calendarEnd;
return calDoc;
}
function writeCalendar(){
calDocBottom = buildBottomCalFrame();
top.newWin.frames['bottomCalFrame'].document.open();
top.newWin.frames['bottomCalFrame'].document.write(calDocBottom);
top.newWin.frames['bottomCalFrame'].document.close();
}
function setToday() {
calDate = new Date();
var month = calDate.getMonth();
var year  = calDate.getFullYear();
top.newWin.frames['topCalFrame'].document.calControl.month.selectedIndex = month;
top.newWin.frames['topCalFrame'].document.calControl.year.value = year;
writeCalendar();
}
function setYear() {
var year  = top.newWin.frames['topCalFrame'].document.calControl.year.value;
if (isFourDigitYear(year)) {
calDate.setFullYear(year);
writeCalendar();
}
else {
top.newWin.frames['topCalFrame'].document.calControl.year.focus();
top.newWin.frames['topCalFrame'].document.calControl.year.select();
}}
function setCurrentMonth(){
var month = top.newWin.frames['topCalFrame'].document.calControl.month.selectedIndex;
calDate.setMonth(month);
writeCalendar();
}
function setPreviousYear(){
var year  = top.newWin.frames['topCalFrame'].document.calControl.year.value;
if (isFourDigitYear(year) && year > 1000) {
year--;
calDate.setFullYear(year);
top.newWin.frames['topCalFrame'].document.calControl.year.value = year;
writeCalendar();
}}
function setPreviousMonth(){
var year=top.newWin.frames['topCalFrame'].document.calControl.year.value;
if (isFourDigitYear(year)){
var month=top.newWin.frames['topCalFrame'].document.calControl.month.selectedIndex;
if(month==0){month=11;
if(year>1000){year--;calDate.setFullYear(year);
top.newWin.frames['topCalFrame'].document.calControl.year.value = year;
}}
else{month--;}
calDate.setMonth(month);
top.newWin.frames['topCalFrame'].document.calControl.month.selectedIndex = month;
writeCalendar();
}}
function setNextMonth(){
var year=top.newWin.frames['topCalFrame'].document.calControl.year.value;
if(isFourDigitYear(year)) {
var month=top.newWin.frames['topCalFrame'].document.calControl.month.selectedIndex;
if(month==11){
month = 0; year++; calDate.setFullYear(year);
top.newWin.frames['topCalFrame'].document.calControl.year.value = year;
}
else{month++;}
calDate.setMonth(month);
top.newWin.frames['topCalFrame'].document.calControl.month.selectedIndex = month;
writeCalendar();
}}
function setNextYear(){
var year=top.newWin.frames['topCalFrame'].document.calControl.year.value;
if(isFourDigitYear(year)){
year++;calDate.setFullYear(year);
top.newWin.frames['topCalFrame'].document.calControl.year.value = year;
writeCalendar();
}}
function getDaysInMonth(){
var days;
var month = calDate.getMonth()+1;
var year  = calDate.getFullYear();
if (month==1 || month==3 || month==5 || month==7 || month==8 || month==10 || month==12){
days=31;}
else if (month==4 || month==6 || month==9 || month==11){days=30;}
else if (month==2){
if (isLeapYear(year)){days=29;
}else{days=28;}
}return(days);}
function isLeapYear(Year){
if (((Year%4)==0) && ((Year%100)!=0) || ((Year%400)==0)) {
return (true);
}else{return(false);}}
function isFourDigitYear(year) {
if (year.length!=4) {
top.newWin.frames['topCalFrame'].document.calControl.year.value = calDate.getFullYear();
top.newWin.frames['topCalFrame'].document.calControl.year.select();
top.newWin.frames['topCalFrame'].document.calControl.year.focus();
}else{return true;}}
function getMonthSelect() {
if (selectedLanguage == "fr"){
monthArray = new Array('Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin','Juillet', 'Aout', 'Septembre', 'Octobre', 'Novembre', 'Décembre');}
else if (selectedLanguage == "de"){
monthArray = new Array('Januar', 'Februar', 'März', 'April', 'Mai', 'Juni','Juli', 'August', 'September', 'Oktober', 'November', 'Dezember');
}else if (selectedLanguage == "es"){
monthArray = new Array('Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio','Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre');}
else{
monthArray = new Array('January', 'February', 'March', 'April', 'May', 'June','July', 'August', 'September', 'October', 'November', 'December');
}
var activeMonth = calDate.getMonth();
monthSelect = "<SELECT NAME='month' onChange='parent.opener.setCurrentMonth()'>";
for (i in monthArray){if (i == activeMonth){
monthSelect += "<OPTION SELECTED>" + monthArray[i] + "\n";
}else{monthSelect += "<OPTION>" + monthArray[i] + "\n";}}
monthSelect += "</SELECT>";
return monthSelect;
}
function createWeekdayList() {
if (selectedLanguage == "fr") {
weekdayList  = new Array('Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi');
weekdayArray = new Array('Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa');
}else if (selectedLanguage == "de"){
weekdayList  = new Array('Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag');
weekdayArray = new Array('So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa');}
else if (selectedLanguage == "es") {
weekdayList  = new Array('Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado')
weekdayArray = new Array('Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa');}
else{
weekdayList  = new Array('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
weekdayArray = new Array('Su','Mo','Tu','We','Th','Fr','Sa');}
var weekdays = "<TR BGCOLOR='" + headingCellColor + "'>";
for (i in weekdayArray) {weekdays += "<TD class='heading' align=center>" + weekdayArray[i] + "</TD>";}
weekdays += "</TR>";
return weekdays;
}
function buildCalParts() {
weekdays = createWeekdayList();
blankCell = "<TD align=center bgcolor='" + cellColor + "'>&nbsp;&nbsp;&nbsp;</TD>";
calendarBegin ="<HTML><HEAD><STYLE type='text/css'><--TD.heading { text-decoration: none; color:headingTextColor; font:"+headingFontStyle+";}A.focusDay:link { color:"+focusColor + "; text-decoration: none; font: " + fontStyle + "; }A.focusDay:hover { color: " + focusColor + "; text-decoration: none; font: " + fontStyle + "; }A.lnkblu {font-family : Verdana; font-weight : bold; font-size : 8pt; color : #00207b; text-decoration : none; }A.weekday:link { color: " + dateColor + "; text-decoration: none; font: " + fontStyle + "; }A.weekday:hover { color: " + hoverColor + "; font: " + fontStyle + "; }--></STYLE></HEAD><BODY BGCOLOR='" + bottomBackground + "' <CENTER>";
if(isNav){
calendarBegin += "<TABLE CELLPADDING=2 CELLSPACING=0 BORDER=" + tableBorder + " ALIGN=CENTER BGCOLOR='" + tableBGColor + "'  bordercolorlight=\"#999999\" bordercolordark=\"#ffffff\"><TR><TD>";
}
calendarBegin +="<TABLE CELLPADDING=2 CELLSPACING=0 BORDER=" + tableBorder + " ALIGN=CENTER BGCOLOR='" + tableBGColor + "' bordercolorlight=\"#999999\" bordercolordark=\"#ffffff\">" + weekdays + "<TR>";
calendarEnd = "";
if (bottomBorder) {calendarEnd += "<TR></TR>";}
if (isNav){calendarEnd += "</TD></TR></TABLE>";}
calendarEnd +="</TABLE>" +"</CENTER>" +"</BODY>" +"</HTML>";}
function jsReplace(inString, find, replace) {
var outString = "";
if (!inString) {
return "";
}
if (inString.indexOf(find) != -1) {
t = inString.split(find);
return (t.join(replace));
}else{return inString;}}
function doNothing() {}
function makeTwoDigit(inValue) {
var numVal = parseInt(inValue, 10);
if (numVal < 10) {return("0" + numVal);}
else{return numVal;}}
function returnDate(inDay)
{
calDate.setDate(inDay);
var day=calDate.getDate();
var month=calDate.getMonth()+1;
var year=calDate.getFullYear();
var monthString=monthArray[calDate.getMonth()];
var monthAbbrev=monthString.substring(0,3);
var weekday=weekdayList[calDate.getDay()];
var weekdayAbbrev=weekday.substring(0,3);
outDate=calDateFormat;
if (calDateFormat.indexOf("DD") != -1) {
day = makeTwoDigit(day);
outDate = jsReplace(outDate, "DD", day);
}
else if (calDateFormat.indexOf("dd") != -1){outDate = jsReplace(outDate, "dd", day);}
if (calDateFormat.indexOf("MM") != -1) {month = makeTwoDigit(month);
outDate = jsReplace(outDate, "MM", month);}
else if (calDateFormat.indexOf("mm") != -1){outDate = jsReplace(outDate, "mm", month);}
if (calDateFormat.indexOf("yyyy") != -1){outDate = jsReplace(outDate, "yyyy", year);}
else if (calDateFormat.indexOf("yy") != -1){var yearString = "" + year;
var yearString = yearString.substring(2,4);
outDate = jsReplace(outDate, "yy", yearString);}
else if (calDateFormat.indexOf("YY") != -1) {outDate = jsReplace(outDate, "YY", year);}
if (calDateFormat.indexOf("Month") != -1){outDate = jsReplace(outDate, "Month", monthString);}
else if (calDateFormat.indexOf("month") != -1){outDate = jsReplace(outDate, "month", monthString.toLowerCase());}
else if (calDateFormat.indexOf("MONTH") != -1){outDate = jsReplace(outDate, "MONTH", monthString.toUpperCase());}
if (calDateFormat.indexOf("Mon") != -1) {outDate = jsReplace(outDate, "Mon", monthAbbrev);}
else if (calDateFormat.indexOf("mon") != -1) {outDate = jsReplace(outDate, "mon", monthAbbrev.toLowerCase());}
else if (calDateFormat.indexOf("MON") != -1) {outDate = jsReplace(outDate, "MON", monthAbbrev.toUpperCase());}
if (calDateFormat.indexOf("Weekday") != -1) {outDate = jsReplace(outDate, "Weekday", weekday);}
else if (calDateFormat.indexOf("weekday") != -1) {outDate = jsReplace(outDate, "weekday", weekday.toLowerCase());}
else if (calDateFormat.indexOf("WEEKDAY") != -1) {outDate = jsReplace(outDate, "WEEKDAY", weekday.toUpperCase());}
if (calDateFormat.indexOf("Wkdy") != -1) {outDate = jsReplace(outDate, "Wkdy", weekdayAbbrev);}
else if (calDateFormat.indexOf("wkdy") != -1) {outDate = jsReplace(outDate, "wkdy", weekdayAbbrev.toLowerCase());}
else if (calDateFormat.indexOf("WKDY") != -1) {outDate = jsReplace(outDate, "WKDY", weekdayAbbrev.toUpperCase());}
calDateField.value = outDate;
calDateField.focus();
top.newWin.close()}