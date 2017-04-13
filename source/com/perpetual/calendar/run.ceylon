"Run the module `com.perpetual.calendar`"
shared void run() {
	process.write("Enter a date (DD-MM-YYYY or DD-MON-YYYY): ");
	value dateStr = (process.readLine() else "").trimmed;
	value dmy = dateStr.split('-'.equals);
	if (dmy.size != 3) {
		print("Please enter a date in the DD-MM-YYYY or DD-MON-YYYY format!");
	}
	else {
		PerpetualCalendar().calculateDay(dmy);
	}
}
