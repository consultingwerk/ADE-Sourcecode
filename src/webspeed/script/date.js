<!--------------------------------------------------------------------
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
--------------------------------------------------------------------->
<!--
  File:    Date.js
  Updated: 04/26/99 john.harlow@bravepoint.com
             Initial version
           04/27/01 adams@progress.com
             WebSpeed integration
-->

function parseDate(dateString, partOfString, currentYear) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

  var mon, date, yr;
  var stringDate = new String(dateString);
  breakOne = stringDate.indexOf("/");
  breakTwo = stringDate.lastIndexOf("/");

  if (partOfString == 1) {
    mon = stringDate.substring(0,breakOne);
    if (mon.length == 1)
      return "0"+mon;
    else
      return mon;
  }
  else if (partOfString == 2) {
    if (breakTwo == breakOne) 
      date = stringDate.substring(breakOne + 1, stringDate.length);
    else 
      date = stringDate.substring(breakOne + 1, breakTwo);
      
    if (Date.length == 1 )
      return "0"+date;
    else
      return date;
  }
  else if (partOfString == 3) {
    if (breakTwo == breakOne) 
      yr = currentYear;
    else {
      if (breakTwo == stringDate.length - 1) 
        yr = currentYear;
      else 
        yr = stringDate.substring(breakTwo + 1, stringDate.length);
    }
    return yr;
  }
}

function makeYear(yearString, baseString, pieceString) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

  var yr = parseInt(yearString, 10);

  if (yr < 100) {
    if (yr >= pieceString)
      yr+=baseString;
    else
      yr+=baseString+100;
  }
  return yr;
} 

function checkDate(date_format, dateOb, startDate, endDate, ifRequired ) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

//passed as global constants from WebSpeed
//constants
//var date_offset = 1950;
//var thisYear = 1998;
//var dateFormat = "mdy";

//passed variables

if (activeField != dateOb.name)
	return; 

var format = new String(date_format);
var theDate = new String(dateOb.value);
var sDate = new String(startDate);
var eDate = new String(endDate);
var uDate = new String();
var ifReq = ifRequired;

var parseAgent;
var month, day, year;
var maxDays;
var fourDYear = 0;
var pieceYear = date_offset%100;
var baseYear = date_offset - pieceYear;
var monthPos=1;
var dayPos=2;
var yearPos=3;


if (theDate.length == 0) {
        if (ifReq == 1) {
                alert("You must enter a date");
		dateOb.focus();
                return;
        }
	else{
		activeField="";
        return true;
    }
}
else if (theDate.length > 0 && theDate.length < 3) {
        alert("You have entered an invalid date");
	dateOb.focus();
        return;
}
else {
        //find format parse Agent
        if (format.indexOf("/") > -1) {
                parseAgent = "/";
                if (format.length > 8) fourDYear = 1;
        }
        else if (format.indexOf("-") > -1) {
                parseAgent = "-";
                if (format.length > 8) fourDYear = 1;
        }
        else{
                parseAgent = "";
                if (format.length > 6) fourDYear = 1;
        }

        //change the -s to /s
        if (theDate.indexOf("-") > -1) {
                theDate = replaceAll(theDate, "-", "/");
        }
        if (theDate.indexOf("/") < 0) {
                if (theDate.length < 4) {
                        alert("You have entered an invalid date");
			dateOb.focus();
                        return;
                }
                else
                theDate = theDate.substring(0,2) + "/" + theDate.substring(2,4) + "/" + theDate.substring(4, theDate.length);
        }

        monthPos = dateFormat.indexOf("m") + 1;
        dayPos = dateFormat.indexOf("d") + 1;
        yearPos = dateFormat.indexOf("y") + 1;
        month = parseDate(theDate, monthPos, thisYear);
        day = parseDate(theDate, dayPos, thisYear);
        year = parseDate(theDate, yearPos, thisYear);

        month = parseInt(month, 10);
        day = parseInt(day, 10);

        //find out if the dates are valid integers
        if (month == 0  || isNaN(month)) {
                //not a valid month
                alert("You have not entered a valid month");
		dateOb.focus();
                return;
        }
        else {
                if (year != "00") {
                        year = parseInt(year, 10);
                        if (year == 0  || isNaN(year)) {
                        //not a valid year
                                alert("You have not entered a valid year");
				dateOb.focus();
                                return;
                        }
                }

                year = makeYear(year, baseYear, pieceYear);

                if (month == 1 || month == 3 || month ==5 || month==7|| month==8 || month==10 || month==12) {
                        //31 days
                        maxDays=31;
                }
                else if (month == 4 || month == 6 || month ==9 || month==11) {
                        //30 days
                        maxDays=30;
                }
                else if (month ==2) {
                        //february
                        if (year%4 == 0 && (year%400==0 || year%100 > 0))
                                //leap year
                                maxDays = 29;
                        else
                                maxDays = 28;
                }
                else {
                        //not a month
                        alert("You have entered an invalid month");
			dateOb.focus();
                        return;
                }
                if (day == 0  || isNaN(day)) {
                        //not a valid day
                        alert("You have not entered a valid day");
			dateOb.focus();
                        return;
                }
                else if (day > maxDays) {
                        //not a valid day
                        alert("You have entered an invalid day");
			dateOb.focus();
                        return;
                }

                if (day < 10) day="0"+day;
                if (month < 10) month = "0"+month;

                //check bounds
                uDate = parseInt(""+year+month+day);

                if (sDate.charAt(0) != "?") {
                        sDate = parseInt(""+makeYear(parseDate(sDate,3, thisYear), baseYear, pieceYear)+ parseDate(sDate, 1, thisYear) + parseDate(sDate, 2, thisYear));
                        if (uDate < sDate) {
                                alert("The entered date is too low");
				dateOb.focus();
                                return;
                        }
                }
                if (eDate.charAt(0)  != "?") {
                        eDate = parseInt(""+makeYear(parseDate(eDate,3, thisYear), baseYear, pieceYear)+ parseDate(eDate, 1, thisYear) + parseDate(eDate, 2, thisYear));
                        if (uDate > eDate) {
                                alert("The entered date is too high");
				dateOb.focus();
                                return;
                        }
                }

                if (fourDYear == 0) year = (year - baseYear)%100;
        uDate = "";
        for(i=1;i<=3;i++) {
            if( uDate != "")
				uDate = uDate + parseAgent;
            if( yearPos == i ) {
		       if (year < 10)
                  uDate = uDate + "0" + year;
			   else
                  uDate = uDate + year;
			}
			else if(monthPos == i) {
				uDate = uDate + month;
			}
			else if(dayPos == i ) {
				uDate = uDate + day
			}
		}           
		dateOb.value =uDate;
		activeField = "";
        }//end else
}//end if
}//end date check

