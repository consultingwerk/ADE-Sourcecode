/**********************************************************************
* Copyright (C) 2000-2008 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: setdflts.i

Description:
   Set default values based on the chosen data type.

Arguments:
   &Frame = the frame name, e.g., "frame newtbl".


IMPORTANT: Do not change the b_Field buffer.  All changes must be made to
   widgets directly or to temporary variables.  Otherwise our SAVE strategy
   is messed up.

/* Reminder: Here's what's in user_env:

      user_env[11] - the long form of the gateway type (string), i.e., the
      	       	     type description.
      user_env[12] - list of gateway types (strings)
      user_env[13] - list of _Fld-stlen values for each data type (this is
      	       	     the storage length)
      user_env[14] - list of gateway type codes (_Fld-stdtype).
      user_env[15] - list of progress types that map to gateway types
      user_env[16] - the gateway type family - to indicate what data types
      	       	     can be modified to what other data types.
      user_env[17] - the default-format per foreign data-type.
*/

Author: Laura Stern

Date Created: 09/24/92 
     History: 06/06/02 D. McMann Added check for timestamp's initial value.
              01/31/03 D. McMann Added support for lobs
              07/01/03 D. McMann Added support for DATETIME and DATETIME-TZ
              05/19/04 K. McIntosh Added case for RAW fields to set initial value to ""
              05/24/06 fernando    Added support for int64 fields
              02/22/08 fernando    Adjust display data type length for Dsrv schemas

----------------------------------------------------------------------------*/


Define var type_idx  as integer  NO-UNDO.  /* index into datatypes list */
Define var junk      as logical  NO-UNDO.  /* output parm we don't care about */
Define var fmt       as char     NO-UNDO.
Define var len       as integer  NO-UNDO.  /* stlen */

s_Fld_DType = s_Fld_DType:screen-value in {&Frame}.

if {adedict/ispro.i} then
   assign
      s_Fld_Protype = s_Fld_DType
      s_Fld_Gatetype = ?.
else do: 
   /* Set gateway defaults including, the progress data type that
      the gateway type maps to.  See description of user_env at 
      top of file.
   */

   assign
      /* Use s_Fld_Gatetype temporarily to find the correct
      	 user_env entry.  It will be reset below.  We can't just
      	 do a lookup of s_Fld_DType in the data type select list
      	 to get the index because for properties the select list
      	 may not have the full complement of types.
      */
      s_Fld_Gatetype = TRIM(SUBSTR(s_Fld_DType, 1, 21,"character")) /* the long version */
      type_idx = LOOKUP(s_Fld_Gatetype, user_env[11])
      s_Fld_Protype = TRIM(SUBSTR(s_Fld_DType, 23,-1,"character"))
      /* Remove the trailing parenthesis */
      s_Fld_Protype = SUBSTR(s_Fld_Protype,1,LENGTH(s_Fld_Protype,"character") - 1,"character").

   /* Make sure we have the right user_env entry.  There may be more than
      one with this gate type description.  Find the one where the pro
      type matches as well.
   */
   do while ENTRY(type_idx, user_env[15]) <> s_Fld_Protype:
      type_idx = type_idx + 1.
   end.

   /* Set foreign type code and length from cached gateway info. 
      If stlen is already > 0, and the len in the table = 0, meaning
      the length is not strictly dictated by the type, don't
      overwrite the non-zero value with zero.
   */
   b_Field._Fld-stdtype = INTEGER(ENTRY(type_idx, user_env[14])).
   len = INTEGER(ENTRY(type_idx, user_env[13])).
   if NOT s_Fld_InIndex
    AND ( b_Field._Fld-stlen = ? OR len > 0 ) then
      b_Field._Fld-stlen = len.

      /* Set data types for save later and also so we can get the 
   	 format - the one piece of info we have not got in 
   	 user_env array. 
      */
      s_Fld_Gatetype = ENTRY(type_idx, user_env[12]). /* the short version */
end.

/* Set the underlying progress type code whether we are dealing with
   Progress or other gateway. */
case s_Fld_Protype:
   when "Character"    then s_Fld_Typecode = {&DTYPE_CHARACTER}.
   when "Date"	       then s_Fld_Typecode = {&DTYPE_DATE}.
   when "Logical"      then s_Fld_Typecode = {&DTYPE_LOGICAL}.
   when "Integer"      then s_Fld_Typecode = {&DTYPE_INTEGER}.
   when "Int64"        then s_Fld_Typecode = {&DTYPE_INT64}.
   when "Decimal"      then s_Fld_Typecode = {&DTYPE_DECIMAL}.
   when "RECID"	       then s_Fld_Typecode = {&DTYPE_RECID}.
   when "RAW"          then s_Fld_Typecode = {&DTYPE_RAW}.
   when "BLOB"         then s_Fld_Typecode = {&DTYPE_BLOB}.   
   WHEN "CLOB"         THEN s_Fld_Typecode = {&DTYPE_CLOB}. 
   WHEN "XLOB"         THEN s_Fld_Typecode = {&DTYPE_XLOB}.
   WHEN "DATETIME"     THEN s_Fld_Typecode = {&DTYPE_DATETM}.
   WHEN "DATETIME-TZ"  THEN s_Fld_Typecode = {&DTYPE_DATETMTZ}.
end.

/* Set format default based on data type.  This will also set initial
   value if data type is logical. */
run adedict/FLD/_dfltfmt.p 
   (INPUT b_Field._Format:HANDLE in {&Frame},
    INPUT b_Field._Initial:HANDLE in {&Frame},
    INPUT b_Field._Fld-stlen,
    INPUT true). 

/* Make visibility/label adjustments to fld-case and _Decimals based
   on data type chosen. */
run adedict/FLD/_dtcust.p (INPUT b_Field._Fld-case:HANDLE in {&Frame},
      	       	     	   INPUT b_Field._Decimals:HANDLE in {&Frame}).

/* Set other defaults. */
case s_Fld_Typecode:
   when {&DTYPE_CHARACTER} THEN DO: 
     IF s_Fld_Gatetype = "Timestamp" THEN /* Timestamp needs ? as initial value */
        ASSIGN b_Field._Initial:screen-value in {&Frame} = ?. 
     ELSE
      assign
         b_Field._Initial:screen-value in {&Frame} = "".
   END.
   /* DTYPE_LOGICAL - Initial value is the only thing to set and it 
      has been done in _dfltfmt.p */
   when {&DTYPE_LOGICAL} then .
      
   when {&DTYPE_INTEGER} OR WHEN {&DTYPE_INT64} then
   do:
      assign
         b_Field._Initial:screen-value in {&Frame} = "0".
      if s_Fld_Gatetype = "Bits" then
      	 b_Field._Decimals:screen-value in {&Frame} = "0".
   end.      	 
   when {&DTYPE_DECIMAL} then
      assign
         b_Field._Initial:screen-value in {&Frame} = "0"
         b_Field._Decimals:screen-value in {&Frame} = "2".
   WHEN {&DTYPE_RAW} THEN
      ASSIGN
         b_Field._Initial:SCREEN-VALUE IN {&Frame} = "".
   WHEN {&DTYPE_DATE} OR WHEN {&DTYPE_DATETM} THEN DO:
       ASSIGN b_Field._Initial:screen-value in {&Frame} = ?.

       /* if Dataservers, and changing from date/datetime, keep initial value
          as today/now
       */
       IF (s_Fld_Gatetype BEGINS "Timestamp" OR s_Fld_Gatetype = "date") AND 
           CAN-DO("TODAY,NOW", UPPER(b_Field._Initial)) THEN DO:
           IF s_Fld_Typecode = {&DTYPE_DATE} THEN
              ASSIGN b_Field._Initial:screen-value in {&Frame} = "TODAY".
           ELSE
              ASSIGN b_Field._Initial:screen-value in {&Frame} = "NOW".
       END.
   END.
   otherwise
      assign
	 b_Field._Initial:screen-value in {&Frame} = ?.
end.
