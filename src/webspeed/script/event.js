<!--------------------------------------------------------------------
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
--------------------------------------------------------------------->
<!--
  File:    Event.js
  Updated: 04/26/99 john.harlow@bravepoint.com
             Initial version
           04/27/01 adams@progress.com
             WebSpeed integration
-->

var activeField = new String("");
var hilight = "";
var cols=1;
var holdid  = "";
var pageSize = 0;

function setUnderline() {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

  if (navigator.appName.substring(0,1) == 'M' && navigator.appVersion.substring(0,1) == '4')
    document.writeln('<STYLE> <!-- .underline { [text-decoration:"underline";]} --> </STYLE>');
  else
    document.writeln('<STYLE> <!-- .underline { } --> </STYLE>');
}

// <img src=/ptw.gif width=4 height=1 border=0>
function setColumns(numCells,widthCells) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

  for (i=0; i<=numCells; i++)
    document.writeln(' <td width='+widthCells+'>&nbsp;</td>');
}

function leaveField(field) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

	if (activeField != field.name)
		return;
	else{
		activeField = "";
		document.forms[0].focusField.value = activeField;
		return;
	}
}

function enterField(field) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

	if (activeField != "" && activeField != field.name) 
	  return;
	activeField = field.name;
	document.forms[0].focusField.value = activeField;
  autoZap(field);
  
	return;
}

function autoZap(field) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

	if (field.type == "text" || field.type=="textarea")
		field.select();
}

function postForm() {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

	document.forms[0].focusField.value = activeField;
	goSubmit(document.forms[0].name);
}

// generic formatting stuff

function trim(charString) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

	var newString = new String(""+charString);
	
  for(i=0; i < newString.length; i++) {
    if (newString.charAt(i) == " ") {
      newString = newString.substring(1,newString.length);
	    i--;
		}
    else
		  break;
  }
  for (i = newString.length; i>=0; i--) {
    if (newString.charAt(i) == " ") {
	    newString = newString.substring(0,newString.length - 1);
		}
    else
		  break;
	}
  return(newString);
}

function charRemove(charString,remove) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

	var newString = new String(""+charString);
	i = newString.indexOf(remove);
	
	while( i > -1) {
		if (i == 0)
			newString = newString.substring(1,newString.length);
		else
			newString = newString.substring(0,i) + newString.substring(i + 1, newString.length);
		i = newString.indexOf(remove);			
	}
	return(newString);
}

function charInsert(charString,insert,position) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

	var newString = new String(""+charString);
	if (newString.length < position)
		newString=newString+insert;
	else if (position == 0)
		newString = insert+newString;
	else
		newString = newString.substring(0,position) + insert +
		        		newString.substring(position,newString.length);
	return(newString);
}

function colorRow(arg,rowid) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

  if (document.layers || navigator.appName == "Netscape") {
    if (hilight != "" ) {
      for (i=1; i<=cols; i++) {
        Window.document.layers[hilight + "_td" + i].bgColor = 'white';
        Window.document.layers[hilight + "_td" + i].fgColor = 'black';
      }
    }
    hilight = arg;
    
    for (i=1; i<=cols; i++) {
      Window.document.layers[hilight + "_td" + i].bgColor = 'blue';
      Window.document.layers[hilight + "_td" + i].fgColor = 'white';
    }
  } 
  else {
    if (hilight != "") {
      eval(hilight + ".style.backgroundColor='white'");
      eval(hilight + ".style.color='black'");
      
      for (i=1; i<=cols; i++)
        eval(hilight + "_link" + i + ".style.color = 'black'");
    }
    hilight = arg;
    eval(hilight + ".style.backgroundColor = 'blue'");
    eval(hilight + ".style.color = 'white'");
    
    for (i=1; i<=cols; i++)
      eval(hilight + "_link" + i + ".style.color = 'white'");
  }
  document.forms[0].selectedField.value = rowid + "," + hilight;
}

function pageUp() {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

  alert("go up " + pageSize + " Records ");
}

function pageDown() {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

  alert("go down " + pageSize + " Records");
}

function replaceAll (oldString, oldChar, newChar) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

  if (oldString.length > 0) {
    while (oldString.indexOf(oldChar) > -1) {
      var n = oldString.indexOf(oldChar);
      oldString = oldString.substring(0, n) + newChar +
      oldString.substring(n+1, (oldString.length));
    }
  }
  return oldString;
}
