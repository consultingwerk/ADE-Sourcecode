<!--------------------------------------------------------------------
* Copyright (C) 2002 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors: john.harlow@bravepoint.com                           *
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
