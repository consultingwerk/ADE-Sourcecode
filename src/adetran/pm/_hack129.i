/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
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
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_hack129.i
Author:       SLK
Created:      04/97 
Updated:      
Purpose:      Attempt at eliminating the s/e 129
		Temporary hack
Background:   
Notes:        
Used By:    pm/_copykit.w
*/


IF LENGTH(SUBSTRING(xlatedb.XL_String_Info.Original_String,1,63,"RAW":U),"RAW":U)
	+  LENGTH(xlatedb.XL_Instance.Proc_name,"RAW":U) > 187 THEN DO:
   MESSAGE "Combination of:" CHR(10)
	"        String:" xlatedb.XL_String_Info.Original_String CHR(10)
	"Procedure Name:" xlatedb.XL_Instance.Proc_name CHR(10)
	"will generate the s/e 129 Error. Change your directory structure." CHR(10)
	'Algorythm is first 63 characters of translation string + directory + filename.'
	VIEW-AS ALERT-BOX ERROR TITLE "Kit Error".
   RUN HideMe in _hMeter. 
   ASSIGN ErrorStatus = true.
   RETURN error.
END.
