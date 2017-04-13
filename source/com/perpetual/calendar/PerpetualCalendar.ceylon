import ceylon.collection {
	HashMap
}
import ceylon.decimal {
	parseDecimal,
	decimalNumber
}

"The perpetual calendar class"
shared class PerpetualCalendar() {
	
	value weekAnchorDays = HashMap<Integer,String> { 0->"Sunday", 1->"Monday", 2->"Tuesday", 3->"Wednesday",
		4->"Thursday", 5->"Friday", 6->"Saturday" };
	
	value months = HashMap<Integer,String> { 1->"JAN", 2->"FEB", 3->"MAR", 4->"APR", 5->"MAY", 6->"JUN", 7->"JUL",
		8->"AUG", 9->"SEP", 10->"OCT", 11->"NOV", 12->"DEC" };
	
	value monthAnchorDays = HashMap<String,Integer> { "JAN"->3, "FEB"->7, "MAR"->7, "APR"->4, "MAY"->2, "JUN"->6,
		"JUL"->7, "AUG"->1, "SEP"->5, "OCT"->3, "NOV"->7, "DEC"->5 };
	
	value centuryAnchorDay = HashMap<Integer,Integer> { 19->5, 20->3, 21->2, 22->0 };
	
	"Checks whether the given year is a leap year"
	function isLeapYear(Integer year) {
		if (year%400 == 0) {
			return true;
		}
		if (year%100 == 0) {
			return false;
		}
		return year%4 == 0;
	}
	
	"Gets the year century day"
	function getCentuaryAnchorDay(Integer year) {
		variable Integer? centuaryAnchorDay = null;
		if (year>=2100 && year<2200) {
			centuaryAnchorDay = centuryAnchorDay.get(22);
		}
		else if (year>=2000 && year<2100) {
			centuaryAnchorDay = centuryAnchorDay.get(21);
		}
		else if (year>=1900 && year<2000) {
			centuaryAnchorDay = centuryAnchorDay.get(20);
		}
		else if (year>=1800 && year<1900) {
			centuaryAnchorDay = centuryAnchorDay.get(19);
		}
		return centuaryAnchorDay else -1;
	}
	
	"Gets the year anchor day"
	function getYearAnchorDay(Integer year) {
		value unitDigit = year % 10;
		value tensDigit = (year / 10) % 10;
		value twoDigitNumber = tensDigit*10 + unitDigit;
		value timesOfTwelve = twoDigitNumber / 12;
		value residueOfTwelve = twoDigitNumber % 12;
		value residueOfFour = residueOfTwelve / 4;
		return timesOfTwelve + residueOfTwelve + residueOfFour;
	}
	
	"Gets the dooms day"
	shared Integer getDoomsday(Integer year) {
		value centuaryAnchorDay = getCentuaryAnchorDay(year);
		value yearAnchorDay = getYearAnchorDay(year);
		return (centuaryAnchorDay + yearAnchorDay) % 7;
	}
	
	"Gets the week day index of the input date"
	function getWeekDay(variable Integer date, Integer monthAnchorDay, Integer doomsDay) {
		while (date >= 7) {
			date -= 7;
		}
		date = date - monthAnchorDay + doomsDay;
		if (date < 0) {
			date += 7;
		}
		return weekAnchorDays.get(date) else "";
	}
	
	"calculates the day of the given date"
	shared void calculateDay({String+} dmy) {
		value date = (parseDecimal(dmy.first) else decimalNumber(-1)).integer;
		value year = (parseDecimal(dmy.last) else decimalNumber(-1)).integer;
		if (date < 0 || year < 0 || getCentuaryAnchorDay(year) < 0) {
			print("Please enter a date between 1800-Jan-01 && 2199-Dec-31");
			return;
		}
		variable value month = "";
		for (i->str in dmy.indexed) {
			if (i == 1) {
				value monthNum = (parseDecimal(str) else decimalNumber(-1)).integer;
				if (monthNum > 0) {
					month = months.get(monthNum) else "";
				}
				else {
					value x = monthAnchorDays.get(str.uppercased) else -1;
					if (x > 0) {
						month = str.uppercased;
					}
				}
				break;
			}
		}
		
		if (month == "") {
			print("Invalid month!");
			return;
		}
		
		value doomsDay = getDoomsday(year);
		print("``date``, ``month``, ``year``");
		print("The dooms day is ``doomsDay``");
		variable value monthAnchorDay = monthAnchorDays.get(month) else -1;
		if (isLeapYear(year)) {
			print("This year is a leap year");
			if (month=="JAN" || month=="FEB") {
				monthAnchorDay++;
			}
		}
		else {
			print("This year is not a leap year");
		}
		value weekDay = getWeekDay(date, monthAnchorDay, doomsDay);
		print("The given date falls on ``weekDay``");
	}
}