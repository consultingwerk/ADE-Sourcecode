<!--------------------------------------------------------------------
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
--------------------------------------------------------------------->
<!--
  File:    charmask.js
  Updated: 04/26/99 john.harlow@bravepoint.com
             Initial version
           04/27/01 adams@progress.com
             WebSpeed integration
-->

function isNumberChar (InString)  {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/
	if (InString.length != 1)
		return (false);
	RefString="1234567890-.";
	if (RefString.indexOf (InString, 0) == -1)
		return (false);
	return (true);
}

function findAlpha (charString) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/
  var uString = new String(""+charString);

	for (var n=0; n < uString.length; n++) {
		if (!isNumberChar(uString.charAt(n)))
			return (false);
	}
	return (true);
}

function cleanString (charString) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/
  var uString   = new String(""+charString);
  var retString = new String();

	for (var n=0; n < uString.length; n++) {
		if (isNumberChar(uString.charAt(n)))
			retString = retString+uString.charAt(n);
	}
	return (retString);
}

function calcMax (mask) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/
  var uString   = new String(""+mask);
  var retString = new String();

	for (var n=0; n < uString.length; n++) {
		if (uString.charAt(n) == ">" )
			retString = retString + "9";
		else
		if (uString.charAt(n) == "-" )
			retString = retString + "0";
		else
			retString = retString+uString.charAt(n);
	}
	uString="";
	for (n=0; n < retString.length; n++) {
		if (isNumberChar(retString.charAt(n)))
			uString = uString+uString.charAt(n);
	}
	return(uString);
}

function fixLeader( charString, format) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/
  var chkNum  = new String(""+charString);
  var cFormat = new String(""+format);

	while( chkNum.charAt(0) == '0') {
		var n = cFormat.length - chkNum.length - 1;
		if (cFormat.charAt(n) != '9') {
			chkNum = chkNum.substring(1,chkNum.length);
		}
		else{
			break;
		}
	}
	if (chkNum.charAt(0) == ',')
		chkNum = fixLeader(chkNum.substring(1,chkNum.length),cFormat);
	return(chkNum);
}

function checkNum(num_format, numOb, startNum, endNum, ifRequired) {
   /*----------------------------------------------------------------------
     Purpose:     
     Parameters:  
     Notes:       
   ----------------------------------------------------------------------*/
if (activeField != numOb.name) return;

var format = new String(num_format);
var sNum = new String(cleanString(startNum));
var eNum = new String(cleanString(endNum));
var ifReq = ifRequired;
var uNum = numOb.value;
var maxLength= format.length;
var numberString = new String(""+uNum);
var periodPlace = format.indexOf(".");
var dollarPlace = format.indexOf('$');
var parenPlace = format.indexOf('(');
var negPlace = format.indexOf('-');
var newNum = new String();
var curPos;
var referenceString = new String(",");
var goodValues = new String("0123456789");
var isNeg = 0;
var curValue = new String();

if (numOb.value == "") {
	if (ifReq == 1) {
		alert("You must enter a number");
		numOb.focus();
	}
	return;
}

if (parenPlace > -1 || negPlace > -1 )
	allowNeg = 1;
else
	allowNeg = -1;	

if (dollarPlace >= 0 && numberString.indexOf('$') >= 0) {
	numberString=charRemove(numberString,'$');
}
if (parenPlace > -1 && numberString.indexOf('(') >= 0) {
	numberString=charRemove(numberString,'(');
	numberString=charRemove(numberString,')');
	isNeg = 1;
}	
if (numberString.indexOf('-') >= 0) {
	numberString=charRemove(numberString,'-');
	isNeg = 1;
}

for (var ctr=0; ctr<numberString.length; ctr++) {
	if (! (isNumberChar(numberString.charAt(ctr))||
	       (numberString.charAt(ctr)==','))) {
		alert("Invalid Characters in Numeric Input");
		numOb.focus();
		return;
	}
}
numberString = cleanString(numberString);
uNum=numberString;
var period2 = numberString.indexOf(".");
if (Format.length < numberString.length) {
	alert(numberString + " is too large for format " + format);
}
else {
  if (format.length > 0) {
	if (! findAlpha(numberString)) {
		alert("You must enter a valid number");
		numOb.focus();
		return;
	}
	if (periodPlace > -1) { //if decimal
		uNum = parseFloat(""+uNum);

		if (isNaN(uNum)) {
			alert("You did not enter a valid number");
			numOb.focus();
			return;
		}
		if (allowNeg < 0) {
			if (uNum < 0) {
				alert("Negative numbers are not allowed for this field");
				numOb.focus();
				return;
			}
		}

		if (sNum.charAt(0) != "?") {
			if (parseFloat(""+uNum) < parseFloat(""+sNum)) {
				alert("The entered number is too low");
				numOb.focus();
				return;
			}
		}
		if (eNum.charAt(0) == "?") {
			eNum=calcMax(format);
		}
		if (eNum.charAt(0) != "?") {
			if (parseFloat(""+uNum) > parseFloat(""+eNum)) {
				alert("The entered number is too high");
				numOb.focus();
				return;
			}
		}

		if (uNum < 0) {
			isNeg = 1;
			uNum = Math.abs(parseFloat(""+uNum));
			numberString = (""+uNum);
			period2 = numberString.indexOf(".");
		}


		if (period2 == -1) {
			period2 = numberString.length;
		}

		curPos = period2 - 1;
		newNum = "."
		
		//place all the digits required before decimal
		for (var x = periodPlace -1; x > -1; x--) {
			if (curPos >= 0) {
				curValue = numberString.charAt(curPos);
			}
			else{
				curValue = "";
			}

			if (format.charAt(x) == "9") {
				if (goodValues.indexOf(curValue) >= 0 && curValue != "") {
				        newNum = curValue + newNum;
				}
				else newNum = "0" + newNum;
				curPos--;
			}
			else if (format.charAt(x) == ">") {
				if (curValue != "")
				        newNum =curValue + newNum;
				else break;
				curPos--;
			}
			else {
				if (referenceString.indexOf(format.charAt(x)) > -1) {
					if (format.charAt(x) == "," && curPos != -1)
					newNum = format.charAt(x) + newNum;
					else if (format.charAt(x) != ",")
					newNum = format.charAt(x) + newNum;
				}
			}
		}

		//place all digits required after decimal
		curPos = period2 + 1;
		for (var n = periodPlace + 1; n < format.length;n++) {
			if (curPos <= numberString.length) {
				curValue = numberString.charAt(curPos);
			}
			else{
				curValue = "";
			}

			if (format.charAt(n) == "9") {
				if (goodValues.indexOf(curValue) >= 0 && curValue != "") {
				  newNum = newNum + curValue;
				}
				else newNum = newNum + "0";
				curPos++;
			}
			if (format.charAt(n) == ">") {
				if (curValue != "")
				  newNum = newNum + curValue;
				else 
				  break;
				curPos++;
			}
			else {
				if (referenceString.indexOf(format.charAt(x)) > -1) {
					if (format.charAt(x) == "," && curPos != -1)
					  newNum = format.charAt(x) + newNum;
					else if (format.charAt(x) != ",")
					  newNum = format.charAt(x) + newNum;

				}
		}
		newNum = fixLeader(newNum,format);
		if (isNeg ==1) {
			if (parenPlace >= 0 ) 
				newNum = "("+newNum+")";
			else
				newNum = "-"+newNum;
		}		

		if (dollarPlace >= 0 ) {
			if (isNeg > 0 )
				newNum = charInsert(newNum,'$',dollarPlace);
			else
				newNum = charInsert(newNum,'$',dollarPlace-1);
		}
		numOb.value = newNum;
		activeField = "";
	}//end decimal format
	else {
	//if integer
		uNum = parseInt(numberString);
		if (isNaN(uNum) || (period2 < numberString.length-1 && period2 > -1)) {
			alert("You did not enter a valid integer");
			numOb.focus();
			return;
		}

		if (numberString.charAt(numberString.length -1) == ".")
			numberString = numberString.substring(0,numberString.length-1);

		if (allowNeg < 0) {
			if (uNum < 0) {
				alert("Negative numbers are not allowed for this field");
				numOb.focus();
				return;
			}
		}

		if (sNum.charAt(0) != "?") {
			if (parseInt(""+uNum) < parseInt(""+sNum)) {
				alert("The entered number is too low");
				numOb.focus();
				return;
			}
		}
		if (eNum.charAt(0) == "?") {
			eNum=calcMax(format);
		}
		if (eNum.charAt(0) != "?") {
			if (parseInt(""+uNum) > parseInt(""+eNum)) {
				alert("The entered number is too high");
				numOb.focus();
				return;
			}
		}
  	if (uNum < 0) {
			isNeg = 1;
			uNum = Math.abs(parseInt(""+uNum));
			numberString = (""+uNum);
		}

		curPos = numberString.length-1;

		for (var x = format.length - 1; x > -1; x--) {
			if (curPos >= 0)
				curValue = numberString.charAt(curPos);
			else
				curValue = "";

			if (format.charAt(x) == "9") {
				if (goodValues.indexOf(curValue) >= 0 && curValue != "")
				  newNum = curValue + newNum;
				else 
				  newNum = "0" + newNum;
				curPos--;
			}
			else if (format.charAt(x) == ">") {
				if (curValue != "")
				  newNum =curValue + newNum;
				else 
				  break;
				curPos--;
			}
			else {
				if (referenceString.indexOf(format.charAt(x)) > -1)
					newNum = format.charAt(x) + newNum;
			}
		}
		newNum = fixLeader(newNum, format);
		if (isNeg ==1) {
			if (parenPlace >= 0 ) {
				newNum = "("+newNum+")";
			}
			else {
				newNum = "-"+newNum;
			}
			if (dollarPlace >= 0)
				newNum = charInsert(newNum,'$',dollarPlace);
		}			
		else
		if (dollarPlace >= 0 ) {
			if (dollarPlace==0)
				newNum = "$"+ newNum;
			else
				newNum = charInsert(newNum,'$',dollarPlace-1);
		}
		
		numOb.value = newNum;
		activeField = "";
	}//end integer format
  }//end format = 0
}
}

