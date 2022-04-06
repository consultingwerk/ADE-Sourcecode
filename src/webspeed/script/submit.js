<!--------------------------------------------------------------------
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
--------------------------------------------------------------------->
<!--
  File:    submit.js
  Updated: 04/26/99 john.harlow@bravepoint.com
             Initial version
           04/27/01 adams@progress.com
             WebSpeed integration
-->

function goSubmit(formName) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

	for (var n=0; n < document.forms.length; n++) {
		if (document.forms[n].name == formName.name) break;
	}
	numElements = document.forms[n].elements.length;
	
	for (var m=0; m<numElements; m++) {
		if (reqFields.indexOf(""+document.forms[n].elements[m].name) > -1) {
			if (document.forms[n].elements[m].value == "") {
				alert("You have not filled in all the required fields");
				document.forms[n].elements[m].focus();
				return;
			}
		}
	}
	formName.submit();
}

function goConfirm(formName, confirmText) {
  /*----------------------------------------------------------------------
    Purpose:     
    Parameters:  
    Notes:       
  ----------------------------------------------------------------------*/

	var areYouSure = confirm(confirmText);
	
	if (areYouSure)
		goSubmit(formName);
	else
	  return;
}
