/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
