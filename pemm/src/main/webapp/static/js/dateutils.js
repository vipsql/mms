function formatDate(data, pattern) {
	if (data != null) {
		var time = new Date(data);
		var nowStr = time.format(pattern);
		return nowStr;
	} else {
		return "";
	}
}

// 获得上个月在昨天这一天的日期
function getLastMonthYestdy(date) {
	var daysInMonth = new Array([ 0 ], [ 31 ], [ 28 ], [ 31 ], [ 30 ], [ 31 ],
			[ 30 ], [ 31 ], [ 31 ], [ 30 ], [ 31 ], [ 30 ], [ 31 ]);
	var strYear = date.getFullYear();
	var strDay = date.getDate();
	var strMonth = date.getMonth() + 1;
	if (strYear % 4 == 0 && strYear % 100 != 0) {
		daysInMonth[2] = 29;
	}
	if (strMonth - 1 == 0) {
		strYear -= 1;
		strMonth = 12;
	} else {
		strMonth -= 1;
	}
	strDay = daysInMonth[strMonth] >= strDay ? strDay : daysInMonth[strMonth];
	if (strMonth < 10) {
		strMonth = "0" + strMonth;
	}
	if (strDay < 10) {
		strDay = "0" + strDay;
	}
	datastr = strYear + "-" + strMonth + "-" + strDay;
	return datastr;
}
