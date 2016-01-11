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

/*----------------------------------------------------------------------------

File: _dfltfmt.p

Description:
   Set the format to it's default value based on the data type, conditional
   upon the value of p_Default.  In any case, fix the initial value if
   the data type is logical, to be consistent with the current or new default
   format.

Shared Input (The following shared variables must have been set):
   if database is Progress:
      s_Fld_Typecode  - data type code corresponding to currently selected data
      	       	        type.
   else
      s_Fld_Gatetype  - The gateway data type string (short form)
      s_Fld_Protype   - Progress data type that this gateway type maps to.
      s_Gate_Typ_Proc - The procedure to call to get the format/type info for
      	       	        the current gateway type.
   
Input Parameters:
   p_Format  - The format widget handle.
   p_Initial - The initial value widget handle.
   p_Default - True, if caller wants format set to the default unconditionally,
      	       False if we should only set default if the current format value
      	       is the null string. 

Author: Laura Stern

Date Created: 08/05/92 
Modified: 01/31/03 D. McMann Added support for lobs
          07/01/03 D. McMann Added support for Date-time and Date-time-tz

----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adecomm/cbvar.i shared}
{adedict/uivar.i shared}
{adedict/FLD/fldvar.i shared}

Define INPUT PARAMETER p_Format  as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Initial as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Length  as integer       NO-UNDO.
Define INPUT PARAMETER p_Default as logical       NO-UNDO.

Define var io1 as integer  NO-UNDO.  
Define var fmt as char     NO-UNDO.

fmt = p_Format:screen-value.
if p_Default OR (fmt = "" OR fmt = "?") then
do:
   /*Reset format to its default for this data type */
   assign fmt = ?.

   if NOT {adedict/ispro.i} then
      run VALUE(s_Gate_Typ_Proc) 
      	 (INPUT-OUTPUT io1, 
	  INPUT-OUTPUT p_Length,
	  INPUT-OUTPUT s_Fld_Protype, 
	  INPUT-OUTPUT s_Fld_Gatetype,
	  OUTPUT fmt).

   if io1 <> b_Field._fld-stdtype
    then assign b_Field._fld-stdtype = io1.

   if fmt = ? OR fmt = "?" then
   case s_Fld_Typecode:
	 when {&DTYPE_CHARACTER} OR WHEN {&DTYPE_RAW} OR
     WHEN {&DTYPE_BLOB}      OR WHEN {&DTYPE_CLOB} OR
     WHEN {&DTYPE_XLOB} THEN
	    fmt = "x(8)".
	 when {&DTYPE_DATE} then
	    fmt = "99/99/99".
     when {&DTYPE_DATETM} then
	    fmt = "99/99/9999 HH:MM:SS.SSS".
     when {&DTYPE_DATETMTZ} then
	    fmt = "99/99/9999 HH:MM:SS.SSS+HH:MM".
	 when {&DTYPE_LOGICAL} then
	    fmt = "yes/no".
	 when {&DTYPE_INTEGER} then
	    fmt = "->,>>>,>>9".
	 when {&DTYPE_DECIMAL} then
	    fmt = "->>,>>9.99".
	 when {&DTYPE_RECID} then
	    fmt = ">>>>>>9".
   end.
   else case fmt:
	 when "c"  then
	    fmt = "X(8)".
	 when "d"  then
	    fmt = "99/99/99".
	 when "l"  then
	    fmt = "yes/no".
	 when "i"  then
	    fmt = "->,>>>,>>9".
	 when "#"  then
	    fmt = "->>,>>9.99".
      end.

   p_Format:screen-value = fmt.
end.

if s_Fld_Typecode = {&DTYPE_LOGICAL} then
   /* Reset the initial value to the first string in the format, e.g.,
      set to "male" if format is male/female.  However, special case
      yes/no and true/false to initialize to no and false respectively
      since that is what Progress does.
   */
if S_Adding then do:
   if fmt = "yes/no" then
      p_Initial:screen-value = "no".
   else if fmt = "true/false" then
      p_Initial:screen-value = "false".
   else
      p_Initial:screen-value = SUBSTR(fmt, 1, INDEX(fmt, "/") - 1).
 end.

 if (s_Fld_Typecode = {&DTYPE_BLOB} OR 
     s_Fld_Typecode = {&DTYPE_CLOB} OR
     s_Fld_Typecode = {&DTYPE_XLOB} OR
     s_Fld_Typecode = {&DTYPE_DATETM} OR
     s_Fld_Typecode = {&DTYPE_DATETMTZ}) 
     AND S_Adding  then
       p_Initial:SCREEN-VALUE = ?.
