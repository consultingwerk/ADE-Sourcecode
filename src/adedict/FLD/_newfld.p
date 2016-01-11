/*********************************************************************
* Copyright (C) 2008 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _newfld.p

Description:
   Display and handle the add field boxes and then add
   the field if the user presses OK.

Author: Laura Stern

Date Created: 02/05/92 
    Modified: 07/10/98 Added _Owner check for _File.
              12/11/98 Check for duplicate order numbers, warn and prevent.
              05/01/00 DLM Added _owner to find that was missed 20000428020
              10/01/02 DLM Changed check for SQL tables.
              01/17/03 DLM Added support for lob data types
              07/01/03 DLM Added support for DATETIME and DATETIME-tz
              09/12/03 DLM Moved blank name check to above running BLOB, CLOB 
                       procedure
              09/16/03 DLM Added U1 trigger for data type field
              09/24/03 DLM Check for data type change from U1 trigger in Leave
                       trigger
              10/08/03 DLM Changed for modifying copied LOB fields 20031007-028
              10/25/05 KSM Removed usage of _ianum to locate storage area 
                           20051018-026
              10/28/05 KSM Added code to use _ianum if uncommitted table or
                           fall back on schema area for LOBs
              05/24/06 fernando Added support for int64 datatype
              06/08/06 fernando Hide toint64 button
              06/15/06 fernando Make sure we call setlob when leaving data type to
                                enable/disable needed fields depending on the type.
              02/22/08 fernando Adjust display data type length for Dsrv schemas
----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/capab.i}
{prodict/pro/fldfuncs.i}


DEFINE VARIABLE Last_Order AS INTEGER INIT ?. /* YES-UNDO*//* to set _Order field */
DEFINE VARIABLE Record_Id  AS RECID              NO-UNDO.  /* table record Id */
DEFINE VARIABLE Copy_Hit   AS LOGICAL INIT FALSE NO-UNDO.  /* Flag - was copy hit? */
DEFINE VARIABLE IsPro      AS LOGICAL            NO-UNDO.  /* true if db is Prog. */
DEFINE VARIABLE copied     AS LOGICAL            NO-UNDO.  
DEFINE VARIABLE added      AS LOGICAL INIT FALSE NO-UNDO.
DEFINE VARIABLE odbtyp     AS CHARACTER          NO-UNDO.
DEFINE VARIABLE isodbc     AS LOGICAL INIT FALSE NO-UNDO.
DEFINE VARIABLE islob      AS LOGICAL            NO-UNDO.
DEFINE VARIABLE cObjList   AS CHARACTER          NO-UNDO.

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


/*===========================Internal Procedures=============================*/


/*----------------------------------------------------------------------------
   SetDataTypes

   Get the list of data types appropriate for the current gateway.  For
   non-progress types, also get default information associated with that
   type and just store it so we can set defaults when we need to.
----------------------------------------------------------------------------*/
PROCEDURE SetDataTypes:

Define VARIABLE types as char    NO-UNDO.
Define VARIABLE num   as integer NO-UNDO.
DEFINE VARIABLE s_res AS LOGICAL NO-UNDO.


   if IsPro THEN DO:
      assign
      	 types = "CHARACTER,DATE,DECIMAL,INTEGER,LOGICAL,DATETIME,DATETIME-TZ,BLOB,CLOB,RAW,RECID"
      	 num = 11.
      IF NOT is-pre-101b-db THEN
          /* not a pre-10.1B db, include int64 */
          ASSIGN types = REPLACE(types, "INTEGER","INTEGER,INT64")
              num = 12.
   END.
   else do:
      /* Compose a string to pass to list-items function where each entry
      	 is a data type that looks like "xxxx (yyyy)" where
      	 xxxx is the gateway type and yyyy is the progress type
      	 that it maps to.
      */
      types = "".
      do num = 1 to NUM-ENTRIES(user_env[11]) - 1:
      	 types = types + (if num = 1 then "" else ",") +
      	       	 STRING(ENTRY(num, user_env[11]), "x({&FOREIGN_DTYPE_DISPLAY})") + 
      	       	 "(" + ENTRY(num, user_env[15]) + ")".
      end.
      num = num - 1.  /* undo terminating loop iteration */
   end.
   
   s_lst_Fld_DType:list-items in frame newfld = types.
   s_lst_Fld_DType:inner-lines in frame newfld = 
      (if num <= 12 then num else 12).
end.


/*----------------------------------------------------------------------------
   SetDefaults

   Set default values based on the chosen data type.  Display all new values.
   
   When we get domains:
   Copy the values from an existing domain into the display variables for 
   the new field or domain.  Display all new values.

   Output
      s_Fld_Protype  - Progress data type string
      s_Fld_Typecode - The underlying integer data type (dtype field) 
      s_Fld_Gatetype - The gateway type
----------------------------------------------------------------------------*/
Procedure SetDefaults:
  /*  If the user has selected a lob, make sure the toggle boxes are set
      to no and make insensitive */

  IF s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "BLOB" THEN DO:
    IF s_Fld_array:SCREEN-VALUE IN FRAME newfld = "yes" THEN
      ASSIGN s_Fld_array:SCREEN-VALUE IN FRAME newfld = "no".
    IF b_field._Mandatory:SCREEN-VALUE IN FRAME newfld = "yes" THEN
      ASSIGN b_field._Mandatory:SCREEN-VALUE IN FRAME newfld = "no".
    IF b_field._Fld-case:SCREEN-VALUE IN FRAME newfld = "yes" THEN
      ASSIGN b_Field._Fld-case:SCREEN-VALUE IN FRAME newfld = "no".
    ASSIGN b_field._Mandatory:SENSITIVE IN FRAME newfld = NO
           b_field._Fld-case:SENSITIVE IN FRAME newfld = NO
          s_Fld_array:SENSITIVE IN FRAME newfld = NO.
  END.
  ELSE IF s_Fld_DType:SCREEN-VALUE IN FRAME newfld = "CLOB" THEN DO:
    IF s_Fld_array:SCREEN-VALUE IN FRAME newfld = "yes" THEN
      ASSIGN s_Fld_array:SCREEN-VALUE IN FRAME newfld = "no".
    IF b_field._Mandatory:SCREEN-VALUE IN FRAME newfld = "yes" THEN
      ASSIGN b_field._Mandatory:SCREEN-VALUE IN FRAME newfld = "no".
    ASSIGN b_field._Mandatory:SENSITIVE IN FRAME newfld = NO
           s_Fld_array:SENSITIVE IN FRAME newfld = NO.
  END.
  ELSE 
    ASSIGN b_field._Mandatory:SENSITIVE IN FRAME newfld = YES
           b_field._Fld-case:SENSITIVE IN FRAME newfld = YES
          s_Fld_array:SENSITIVE IN FRAME newfld = YES.

  {adedict/FLD/setdflts.i &Frame = "frame newfld"} 

end.

/*-------------------------------------------------------------------------
    setlob
    
    This procedure handles the different fields that must be set or hidden
    when defining a lob object. It's also called when moving from a LOB to
    another type so that the correct fields are displayed / hidden.
    
--------------------------------------------------------------------------*/    
PROCEDURE setlob:

    IF s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "BLOB" OR
       s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "CLOB" THEN  DO:

      /* disable all the fields not applicable to LOBs */
      ASSIGN s_lob_size:HIDDEN IN FRAME newfld = NO
             s_lob_Area:HIDDEN IN FRAME newfld = NO
             s_btn_lob_Area:HIDDEN IN FRAME newfld = NO
             /* all the other ones */
             b_Field._Format:HIDDEN IN FRAME newfld = YES
             s_btn_Fld_Format:HIDDEN IN FRAME newfld = YES
             s_btn_Fld_ViewAs:SENSITIVE in frame newfld = FALSE
             s_btn_Fld_Validation:SENSITIVE IN FRAME newfld = FALSE
             s_btn_Fld_Triggers:SENSITIVE IN FRAME newfld = FALSE
             s_btn_Fld_StringAttrs:SENSITIVE IN FRAME newfld = FALSE
             b_Field._Label:SENSITIVE IN FRAME newfld = FALSE  	    
             b_Field._Col-label:SENSITIVE IN FRAME newfld = FALSE   
             b_Field._Initial:SENSITIVE IN FRAME newfld = FALSE
             b_Field._Help:SENSITIVE IN FRAME newfld = FALSE 
             b_Field._Mandatory:SENSITIVE IN FRAME newfld = FALSE
             s_Fld_Array:SENSITIVE IN FRAME newfld = FALSE.  

      /* make sure the fields are enabled, if here for the first time */
      IF s_lob_size:SENSITIVE = NO THEN
         ASSIGN s_lob_size:SENSITIVE  = YES.

      IF s_lob_area:SENSITIVE = NO THEN
         ASSIGN s_lob_area:SENSITIVE = YES
                s_btn_lob_Area:SENSITIVE = YES.

      /* some are specific to CLOBs */
      IF s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "CLOB" THEN DO:
         ASSIGN
               s_clob_cp:HIDDEN IN FRAME newfld = FALSE
               s_clob_col:HIDDEN IN FRAME newfld = FALSE
               s_btn_clob_cp:HIDDEN IN FRAME newfld = FALSE
               s_btn_clob_col:HIDDEN IN FRAME newfld = FALSE
               /* the ones at the same position must be hidden */
               b_Field._Label:HIDDEN IN FRAME newfld = TRUE
               b_Field._Col-label:HIDDEN IN FRAME newfld = TRUE.

         IF s_clob_cp:SENSITIVE = NO THEN
            ASSIGN s_clob_cp:SENSITIVE  = TRUE
                   s_btn_clob_cp:SENSITIVE  = TRUE.

         IF s_clob_col:SENSITIVE = NO THEN
            ASSIGN s_clob_col:SENSITIVE  = TRUE
                   s_btn_clob_col:SENSITIVE  = TRUE.

      END.
      ELSE DO:   /* must be a BLOB */
          ASSIGN
                s_clob_cp:HIDDEN IN FRAME newfld = TRUE
                s_clob_col:HIDDEN IN FRAME newfld = TRUE
                s_btn_clob_cp:HIDDEN IN FRAME newfld = TRUE
                s_btn_clob_col:HIDDEN IN FRAME newfld = TRUE
                /* the ones at the same position must be hidden */
                b_Field._Label:HIDDEN IN FRAME newfld = FALSE
                b_Field._Col-label:HIDDEN IN FRAME newfld = FALSE.
      END.
    END.
    ELSE  DO:
        /* not a LOB field, enable all the fields except for the ones specific
          for LOBs
        */
        ASSIGN s_lob_size:HIDDEN IN FRAME newfld = TRUE
               s_lob_Area:HIDDEN IN FRAME newfld = TRUE
               s_btn_lob_Area:HIDDEN IN FRAME newfld = TRUE
               s_clob_cp:HIDDEN IN FRAME newfld = TRUE
               s_clob_col:HIDDEN IN FRAME newfld = TRUE
               s_btn_clob_cp:HIDDEN IN FRAME newfld = TRUE
               s_btn_clob_col:HIDDEN IN FRAME newfld = TRUE
               /* all the other ones */
               b_Field._Format:HIDDEN IN FRAME newfld = FALSE
               s_btn_Fld_Format:HIDDEN IN FRAME newfld = FALSE
               b_Field._Label:HIDDEN IN FRAME newfld = FALSE  	    
               b_Field._Col-label:HIDDEN IN FRAME newfld = FALSE   
               s_btn_Fld_ViewAs:SENSITIVE in frame newfld = FALSE
               s_btn_Fld_ViewAs:SENSITIVE in frame newfld = TRUE
               s_btn_Fld_Validation:SENSITIVE IN FRAME newfld = TRUE
               s_btn_Fld_Triggers:SENSITIVE IN FRAME newfld = TRUE
               s_btn_Fld_StringAttrs:SENSITIVE IN FRAME newfld = TRUE
               b_Field._Label:SENSITIVE IN FRAME newfld = TRUE  	    
               b_Field._Col-label:SENSITIVE IN FRAME newfld = TRUE   
               b_Field._Initial:SENSITIVE IN FRAME newfld = TRUE
               b_Field._Help:SENSITIVE IN FRAME newfld = TRUE 
               b_Field._Mandatory:SENSITIVE IN FRAME newfld = TRUE
               s_Fld_Array:SENSITIVE IN FRAME newfld = TRUE.  
    END.

END.

/*===============================Triggers====================================*/

/* include file contains trigger for s_lob_size and s_clob_cp */
{adedict/FLD/lob-misc.i &Frame = "frame newfld"}


/*-----WINDOW-CLOSE-----*/
on window-close of frame newfld
   apply "END-ERROR" to frame newfld.


/*----- HIT of OK BUTTON -----*/
on choose of s_btn_OK in frame newfld
   s_OK_Hit = yes.
   /* The GO trigger will fire after this. */


/*----- HIT of ADD BUTTON or GO -----*/
on GO of frame newfld	/* or Create because it's auto-go */
do:
   Define var no_name  as logical NO-UNDO.
   Define var obj      as char 	  NO-UNDO.
   Define var ins_name as char    NO-UNDO.
   Define var ix       as integer NO-UNDO.

   obj = (if s_CurrObj = {&OBJ_FLD} then "field" else "domain").
  
    run adedict/_blnknam.p
      (INPUT b_Field._Field-name:HANDLE in frame newfld,
       INPUT obj, OUTPUT no_name).
   if no_name then do:
      s_OK_Hit = no.
      return NO-APPLY.
   end.
   
   IF s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "BLOB" OR
      s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "CLOB" OR
      s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "XLOB" THEN DO:
     
       ASSIGN islob = TRUE.

       IF b_Field._Fld-stlen = ? THEN
          RUN SetDefaults.

       RUN setlob.
   END.
   ELSE DO:
       /* if the user is moving from a LOB field to some other type, call
          setlob again just so that we enable the correct fields */
       IF islob THEN
          RUN setlob.

       ASSIGN islob = FALSE.
   END.

   /* Set some gateway defaults in case they haven't been set yet */
   run adedict/FLD/_dfltgat.p (FALSE).

   /* Do some gateways related validation */
   run adedict/FLD/_valgate.p.
   if RETURN-VALUE = "error" then do:
      s_OK_Hit = no.
      return NO-APPLY.
   end.

   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      run adecomm/_setcurs.p ("WAIT").

      /* NOTE: the data type variables s_Fld_Protype/Gatetype etc. have
      	 been set from the trigger on change of data type.  b_Field._stdtype
      	 has also been set.
      */

      IF s_Fld_Protype = "INT64" THEN DO:
         IF DECIMAL(B_Field._Initial:SCREEN-VALUE) > 9223372036854775807 OR 
            DECIMAL(B_Field._Initial:SCREEN-VALUE) < -9223372036854775808 THEN DO:
             MESSAGE "Initial Value has value too large for int64"
                 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
             UNDO.
         END.
      END.

      assign
	 b_Field._File-recid = Record_Id
	 b_Field._Data-Type = s_Fld_Protype /*WHEN s_Fld_Protype <> "CLOB"*/
     b_Field._For-type = s_Fld_Gatetype
     input frame newfld b_Field._Format
	 input frame newfld b_Field._Field-Name
	 input frame newfld b_Field._Initial WHEN NOT islob 
	 input frame newfld b_Field._Label   WHEN NOT islob
	 input frame newfld b_Field._Col-label WHEN NOT islob
	 input frame newfld b_Field._Mandatory WHEN NOT islob
	 input frame newfld b_Field._Decimals WHEN NOT islob
	 input frame newfld b_Field._Fld-case WHEN s_Fld_Protype <> "BLOB"
	 input frame newfld b_Field._Extent WHEN NOT islob
	 input frame newfld b_Field._Order
	 input frame newfld b_Field._Help WHEN NOT islob
	 input frame newfld b_Field._Desc.

     /* for clob/blobs, we have some additional fields to populate */
     IF islob THEN DO:
          FIND _Area WHERE _Area._Area-name = s_lob_area:SCREEN-VALUE IN FRAME newfld NO-ERROR.
          IF AVAILABLE _Area THEN DO:
            ASSIGN b_field._Fld-stlen = _Area._Area-number
                   b_Field._Width = s_lob_wdth
                   b_Field._Fld-Misc2[1] = CAPS(INPUT FRAME newfld s_lob_size).
            IF b_field._Initial <> ? THEN
              ASSIGN b_field._Initial = ?.
            
            RELEASE _Area.

          END.
          ELSE MESSAGE "Area " s_lob_area:SCREEN-VALUE IN FRAME newfld " is not valid"
               VIEW-AS ALERT-BOX.

          /* some are specific to CLOB fields */
          IF s_Fld_Protype = "CLOB" THEN DO:

              IF _Db._Db-xl-name = "undefined" AND 
                s_clob_cp:SCREEN-VALUE = "*Use DB Code Page"  THEN DO:
                  MESSAGE "The database code page is 'undefined' " SKIP
                          "A clob cannot be defined with this code page." SKIP(1)
                          "Select a code page other than 'Use DB Code Page'." SKIP
                      VIEW-AS ALERT-BOX ERROR.
                  UNDO, LEAVE.
              END.

              IF s_clob_cp:SCREEN-VALUE <> "*Use DB Code Page" THEN
                ASSIGN b_Field._Charset = INPUT FRAME newfld s_clob_cp:SCREEN-VALUE
                       b_Field._Collation = INPUT FRAME newfld s_clob_col:SCREEN-VALUE
                       b_Field._Attributes1 = 2. 
              ELSE 
                ASSIGN b_Field._Charset = _Db._Db-xl-name
                       b_Field._Collation = _Db._Db-coll-name
                       b_Field._Attributes1 = 1. 
          END.
      END.

      /* For certain gateways we store the character length in the _Decimals
	 field to support certain SQL operations.
      */
      if (s_Fld_TypeCode = {&DTYPE_CHARACTER} AND 
	  INDEX(s_Fld_Capab, {&CAPAB_CHAR_LEN_IN_DEC}) <> 0) then
	 b_Field._Decimals = b_Field._Fld-stlen.

      Last_Order = b_Field._Order.

      /* Add entry to appropriate list in the correct order */
      if s_CurrObj = {&OBJ_FLD} then
      	 run adedict/FLD/_ptinlst.p (INPUT b_Field._Field-Name,
      	       	     	      	     INPUT b_Field._Order).     

      {adedict/setdirty.i &Dirty = "true"}
      display "Field Created" @ s_Status with frame newfld.
      added = yes.
      run adecomm/_setcurs.p ("").
      return.
   end.

   /* Will only get here if there's an error. */
   run adecomm/_setcurs.p ("").
   s_OK_Hit = no.
   return NO-APPLY.
end.

/*----------U1 on Data Type Selection List ----------*/
on "U1" of s_Fld_DType in frame newfld
do:
     RUN SetDefaults.  /* sets s_Fld_Typecode */
     RUN setlob.    

     /*Assign s_fld_dtype to stop leave trigger from firing */
   ASSIGN s_fld_dtype = s_Fld_Dtype:SCREEN-VALUE.
end.


/*----- LEAVE of DATA TYPE FIELD -----*/

ON LEAVE OF s_Fld_DType IN FRAME newfld,
            s_btn_Fld_DType IN FRAME newfld,
            s_lst_Fld_DType IN FRAME newfld
DO:
   DEFINE VARIABLE lob AS LOGICAL NO-UNDO.

   ASSIGN cObjList = STRING(s_Fld_DType:HANDLE) + ',' +
                     STRING(s_btn_Fld_DType:HANDLE) + ',' +
                     STRING(s_lst_Fld_DType:HANDLE).

   /* If the ENTRY and LEAVE fields are part of the mock combo-box then
      we don't want to fire the leave event. */
   IF CAN-DO(cObjList,STRING(LAST-EVENT:WIDGET-ENTER)) AND
      CAN-DO(cObjList,STRING(LAST-EVENT:WIDGET-LEAVE)) THEN
     RETURN.

   /* See if type changed first.  If user had changed format or initial 
      value, for example, we don't want to clobber with defaults if we 
      don't have to. (* - los 12/27/94)
   */

   if s_Fld_DType <> s_Fld_DType:screen-value in frame newfld THEN DO:
       /* check if we are changing from a lob type so that we enable/disable
          the right fields 
       */
       IF s_Fld_DType = "BLOB" OR s_Fld_DType = "CLOB" OR s_Fld_DType = "XLOB" THEN 
          ASSIGN lob = YES.

    run SetDefaults.  /* sets s_Fld_Typecode */

    /* this will enable or disable some fields if we are changing to 
       or from a lob type 
    */
    IF s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "BLOB" OR
       s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "CLOB" OR 
       s_Fld_Dtype:SCREEN-VALUE IN FRAME newfld = "XLOB" OR islob OR lob THEN
       RUN setlob. 

   END.
   
end.


/*----- LEAVE of FORMAT FIELD -----*/
on leave of b_Field._Format in frame newfld 
do:
   /* Set format to default if it's blank and fix up initial value
      if data type is logical based on the format. */
   run adedict/FLD/_dfltfmt.p   
      (INPUT b_Field._Format:HANDLE in frame newfld,
       INPUT b_Field._Initial:HANDLE in frame newfld,
       INPUT 0,
       INPUT false). 
end.


/*----- HIT of FORMAT EXAMPLES BUTTON -----*/
on choose of s_btn_Fld_Format in frame newfld
do:
   Define var fmt as CHAR  NO-UNDO.
   IF s_Fld_DType:SCREEN-VALUE = "BLOB" OR s_Fld_DType:SCREEN-VALUE = "CLOB" THEN RETURN NO-APPLY.
   /* Allow user to pick a different format from examples */
   fmt = input frame newfld b_Field._Format.
   run adedict/FLD/_fldfmts.p (INPUT s_Fld_Typecode, INPUT-OUTPUT fmt).
   b_Field._Format:SCREEN-VALUE in frame newfld = fmt .
end.


/*----- VALUE-CHANGED of ARRAY TOGGLE -----*/
on value-changed of s_Fld_Array in frame newfld
do:
   IF s_Fld_DType:SCREEN-VALUE = "BLOB" OR s_Fld_DType:SCREEN-VALUE = "CLOB" THEN RETURN NO-APPLY.
   if SELF:screen-value = "yes" then
   do:
      b_Field._Extent:sensitive in frame newfld = true.
      b_Field._Extent:screen-value = "1".  /* default to non-zero value */
      apply "entry" to b_Field._Extent in frame newfld.
   end.
   else 
      assign
      	 b_Field._Extent:sensitive in frame newfld = false
      	 b_Field._Extent:screen-value in frame newfld = "0".
end.


/*----- HIT of COPY BUTTON -----*/
on choose of s_btn_Fld_Copy in frame newfld
do:
   if INDEX(s_Fld_Capab, {&CAPAB_COPY}) = 0 THEN
        IF NOT (isodbc AND _file._For-Type = "BUFFER" AND
                _File._For-Owner = ? AND _File._For-Name = "NONAME") THEN
        do:
            message "You may not copy fields for this database type."
      	         view-as ALERT-BOX ERROR buttons OK.
            return NO-APPLY.
        end.  
   /* Flag that copy was hit.  The add wait-for will break and we'll
      call the copy program from there.  We must do this so that pressing
      Done after copy will not undo the addition of the copied fields.
   */
   Copy_Hit = true.
end.


/*----- HIT of VIEW-AS BUTTON -----*/
on choose of s_btn_Fld_ViewAs in frame newfld
do:
   Define var no_name as logical NO-UNDO.
   Define var mod     as logical NO-UNDO.
   
   {adedict/forceval.i}  /* force leave trigger to fire */
   IF s_Fld_DType:SCREEN-VALUE = "BLOB" OR s_Fld_DType:SCREEN-VALUE = "CLOB" THEN RETURN NO-APPLY.
   run adedict/_blnknam.p
      (INPUT b_Field._Field-name:HANDLE in frame newfld,
       INPUT "field", OUTPUT no_name).
   if no_name then return NO-APPLY.

   run adecomm/_viewas.p (INPUT s_Fld_ReadOnly, INPUT s_Fld_Typecode,
      	       	     	  INPUT s_Fld_ProType, 
      	       	     	  INPUT-OUTPUT b_Field._View-as, OUTPUT mod).
end.

/*---------- LEAVE OF ORDER FIELD ---------*/
on leave of b_Field._order in frame newfld
DO:
      /* Avoid the test if the field hasn't changed */
      IF b_Field._Order = INT(b_Field._Order:SCREEN-VALUE IN FRAME newfld) THEN
         LEAVE. 
      /* Is the new order number a duplicate?  Don't allow it.  */
      IF CAN-FIND(FIRST _Field WHERE
                        _Field._File-recid = s_TblRecId AND
                        _Field._Order =
			INT(b_Field._Order:SCREEN-VALUE IN FRAME newfld) AND
			_Field._Order <> b_Field._Order) THEN 
      DO:
	 MESSAGE "Order number " +
	 TRIM(b_Field._Order:SCREEN-VALUE IN FRAME newfld) "already exists." 
	 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
	 /* set order number back to its current value */
	 b_Field._Order:SCREEN-VALUE IN FRAME newfld = STRING(b_Field._Order).
        RETURN NO-APPLY.
      END.
END.

/*----- HELP -----*/
on HELP of frame newfld OR choose of s_btn_Help in frame newfld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Create_Field_Dlg_Box}, ?).


/*============================Mainline code==================================*/

Define var msg     as char NO-UNDO.
Define var copytbl as char NO-UNDO init "".
Define var copyfld as char NO-UNDO init "".

find _File WHERE _File._File-name =  "_Field"
             AND _File._Owner = "PUB"
             NO-LOCK.
if NOT can-do(_File._Can-create, USERID("DICTDB")) then
do:
   if s_CurrObj = {&OBJ_FLD} then
      msg = "create fields.".
   else
      msg = "create domains.".
   message s_NoPrivMsg msg view-as ALERT-BOX ERROR buttons Ok.
   return.
end.

find _File where RECID(_File) = s_TblRecId.
msg = "".
if _File._Db-lang >= {&TBLTYP_SQL} then
   msg = "This is a {&PRO_DISPLAY_NAME}/SQL table.  Use ALTER TABLE/ADD COLUMN.".
else if _File._Frozen then  
   msg = "This table is frozen and cannot be modified.".
if msg <> "" then
do:
   message msg view-as ALERT-BOX ERROR buttons OK.
   return.
end.

/* Get ODBC types in case this is an ODBC db */
odbtyp = { adecomm/ds_type.i
           &direction = "ODBC"
           &from-type = "odbtyp"}.
           
/* See if this db is an ODBC db */      
IF CAN-DO(odbtyp, s_DbCache_Type[s_DbCache_ix]) THEN ASSIGN isodbc = yes.

/* Get gateway capabilities */
run adedict/_capab.p (INPUT {&CAPAB_FLD}, OUTPUT s_Fld_Capab).

/* allow add if ODBC BUFFER table */
if INDEX(s_Fld_Capab, {&CAPAB_ADD}) = 0 THEN
    IF NOT (isodbc AND _file._For-Type = "BUFFER" AND
            _File._For-Owner = ? AND _File._For-Name = "NONAME") THEN
    do:
        message "You may not add a field definition for this database type."
            view-as ALERT-BOX ERROR buttons OK.
        return.
    end.    


/* Set dialog box title to show which table this field will belong to. */
frame newfld:title = "Create Field for Table " + s_CurrTbl.

/* Set the record id of the table that this field will belong to or of the
   domain table which means this field is really a domain. */
if s_CurrObj = {&OBJ_FLD} then
   Record_Id =  s_TblRecId.
else
   Record_Id = s_DomRecId.

IsPro = {adedict/ispro.i}.

/* InIndex and InView aren't relevant on "add", Order# isn't relevant 
   for domains, copy is only used in create not props. toint64 is only
   for field properties.
*/
assign
   s_Fld_InIndex:hidden  in frame newfld = yes
   s_Fld_InView:hidden   in frame newfld = yes
   s_btn_Fld_Copy:hidden in frame newfld = no
   b_Field._Order:hidden in frame newfld =
      (if s_CurrObj = {&OBJ_DOM} then yes else no)
   s_btn_Fld_Gateway:sensitive in frame newfld = 
      (if IsPro then no else yes)
    s_btn_toint64:HIDDEN in frame newfld = yes.

/* specific to LOB fields */
ASSIGN s_lob_size:HIDDEN IN FRAME newfld = YES
       s_lob_Area:HIDDEN IN FRAME newfld = YES
       s_btn_lob_Area:HIDDEN IN FRAME newfld = YES
       s_clob_cp:HIDDEN IN FRAME newfld = YES
       s_clob_col:HIDDEN IN FRAME newfld = YES
       s_btn_clob_cp:HIDDEN IN FRAME newfld = YES
       s_btn_clob_col:HIDDEN IN FRAME newfld = YES.

/* Adjust the data type fill-in and list: font and width. */
{adedict/FLD/dtwidth.i &Frame = "Frame newfld" &Only1 = "FALSE"}

/* Run time layout for button area.  This defines eff_frame_width 
   Since this is a shared frame we have to avoid doing this code 
   more than once.
*/
if frame newfld:private-data <> "alive" then
do:
   frame newfld:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "frame newfld" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }

   /* So Return doesn't hit default button in editor widget. */
   b_Field._Desc:RETURN-INSERT in frame newfld = yes.

   /* runtime adjustment of "Optional" title band to the width of the frame */
   s_Optional:width-chars in frame newfld = eff_frame_width - ({&HFM_WID} * 2).
end.

/* Fill data type combo box based on the gateway */
run SetDataTypes.
{adecomm/cbdrop.i &Frame  = "frame newfld"
      	       	  &CBFill = "s_Fld_DType"
      	       	  &CBList = "s_lst_Fld_DType"
      	       	  &CBBtn  = "s_btn_Fld_DType"
     	       	  &CBInit = """"}
                  

/* FILL THE SELECTION LIST OF AREAS FOR BLOB / CLOB FIELDS */

FIND DICTDB._Db WHERE RECID(_Db) = _File._Db-recid NO-LOCK.

s_lst_lob_area:list-items in frame newfld = "".

IF _File._For-type <> ? THEN
  ASSIGN s_lob_Area = "N/A".
ELSE DO:
  IF _File._File-number <> ? THEN DO:
    FIND _storageobject WHERE _Storageobject._Db-recid      = s_DbRecId AND 
                              _Storageobject._Object-type   = 1         AND 
                              _Storageobject._Object-number = _File._File-Number NO-LOCK.

    IF AVAILABLE _StorageObject THEN
      FIND DICTDB._Area 
         WHERE DICTDB._Area._Area-number = _StorageObject._Area-number NO-LOCK.
    ELSE
      FIND DICTDB._Area WHERE DICTDB._Area._Area-number = 6 NO-LOCK.
  END.
  ELSE
    FIND DICTDB._Area WHERE DICTDB._Area._Area-num = _File._ianum.

  ASSIGN s_lob_Area = DICTDB._Area._Area-name.
END.

FOR EACH DICTDB._Area WHERE DICTDB._Area._Area-num > 6 
                      AND DICTDB._Area._Area-type = 6 NO-LOCK:

    IF DICTDB._Area._Area-name = s_lob_Area THEN
       s_res = s_lst_lob_area:ADD-FIRST(DICTDB._Area._Area-name) in frame newfld.
    ELSE
       s_res = s_lst_lob_area:add-last(DICTDB._Area._Area-name) in frame newfld.
END.
FIND DICTDB._Area WHERE DICTDB._Area._Area-num = 6 NO-LOCK.
ASSIGN s_res = s_lst_lob_area:add-last(DICTDB._Area._Area-name) in frame newfld
     bnum = s_lst_lob_area:num-items in frame newfld
     s_lst_lob_area:inner-lines in frame newfld = (if bnum <= 5 then bnum else 5). 


/* fill Area combo box */
{adecomm/cbdrop.i &Frame  = "frame newfld"
                &CBFill = "s_lob_Area"
                &CBList = "s_lst_lob_area"
                &CBBtn  = "s_btn_lob_Area"
                &CBInit = """"}

/* FILL IN LIST OF CODE PAGES AND COLLATIONS FOR CLOB FIELDS */
ASSIGN s_clob_cp = "*Use DB Code Page"
     hldcp = GET-CODEPAGES
     s_lst_clob_cp:LIST-ITEMS IN FRAME newfld = ""
     s_res = s_lst_clob_cp:ADD-FIRST(s_clob_cp) IN FRAME newfld.

DO i = 1 TO NUM-ENTRIES(hldcp):
  IF ENTRY(i, hldcp) <> "undefined" AND 
     ENTRY(i, hldcp) <> "UCS2"      AND 
     ENTRY(i, hldcp) <> "GB18030"   THEN
    s_res = s_lst_clob_cp:ADD-LAST(ENTRY(i, hldcp)) in frame newfld.
END.

/* fill code page combo box */
{adecomm/cbdrop.i &Frame  = "frame newfld"
                &CBFill = "s_clob_cp"
                &CBList = "s_lst_clob_cp"
                &CBBtn  = "s_btn_clob_cp"
                &CBInit = """"}

ASSIGN s_clob_col = DICTDB._DB._Db-coll-name
     s_lst_clob_col:LIST-ITEMS IN FRAME newfld = ""
     s_res = s_lst_clob_col:ADD-FIRST("*Use DB Collation") in frame newfld.

/* fill collation combo box */
{adecomm/cbdrop.i &Frame  = "frame newfld"
                &CBFill = "s_clob_col"
                &CBList = "s_lst_clob_col"
                &CBBtn  = "s_btn_clob_col"
                &CBInit = """"}

/* make sure these are hidden */
ASSIGN s_btn_lob_Area:HIDDEN IN FRAME newfld = YES
       s_btn_clob_cp:HIDDEN IN FRAME newfld = YES
       s_btn_clob_col:HIDDEN IN FRAME newfld = YES.


/* Erase any status from the last time */
s_Status = "".
display s_Status with frame newfld.
ASSIGN s_btn_Done:label in frame newfld = "Cancel".      

/* if this is a LOB field, we have less fields to enable now */
IF islob THEN DO:
   enable b_Field._Field-Name 
          s_Fld_DType
          s_lob_area
          s_btn_lob_Area
          b_Field._Order     when s_CurrObj = {&OBJ_FLD} 
          s_lob_size
          b_Field._Desc
          s_btn_OK
          s_btn_Add
          s_btn_Done
          s_btn_Help
         with frame newfld.   
END.
ELSE DO:
enable b_Field._Field-Name  
       s_btn_Fld_Copy
       s_Fld_DType          
       s_btn_Fld_DType
       b_Field._Format      
       s_btn_Fld_Format     
       b_Field._Label  	    
       b_Field._Col-label   
       b_Field._Initial
       b_Field._Order 	    when s_CurrObj = {&OBJ_FLD} 
       b_Field._Desc
       b_Field._Help
       b_Field._Mandatory   when INDEX(s_Fld_Capab, {&CAPAB_CHANGE_MANDATORY}) 
      	       	     	      	       > 0 
       b_Field._Fld-case    WHEN NOT islob /* this may be disabled later */
       s_Fld_Array
       s_btn_Fld_Triggers
       s_btn_Fld_Validation
       s_btn_Fld_ViewAs
       s_btn_Fld_StringAttrs
       s_btn_Fld_Gateway    when NOT IsPro
       s_btn_OK
       s_btn_Add
       s_btn_Done
       s_btn_Help
       with frame newfld.

END.

/* The rule is ENABLE effects the TAB order but x:SENSITIVE = yes does not. 
   Now readjust tab orders for stuff not in the ENABLE set but
   which may, in fact be sensitive at some point during this .p.
*/
assign
   s_Res = s_lst_Fld_DType:move-after-tab-item
      	       (s_btn_Fld_DType:handle in frame newfld) in frame newfld
   s_Res = b_Field._Decimals:move-before-tab-item
      	       (b_Field._Desc:handle in frame newfld) in frame newfld
   s_Res = b_Field._Fld-case:move-before-tab-item
      	       (s_Fld_Array:handle in frame newfld) in frame newfld
   s_Res = b_Field._Extent:move-after-tab-item
      	       (s_Fld_Array:handle in frame newfld) in frame newfld
   s_Res = s_lob_area:MOVE-AFTER-TAB-ITEM
               (s_btn_Fld_DType:HANDLE IN FRAME newfld) IN FRAME newfld
   s_Res = s_btn_lob_area:MOVE-AFTER-TAB-ITEM
               (s_lob_area:HANDLE IN FRAME newfld) IN FRAME newfld
   s_Res = s_lst_lob_area:MOVE-AFTER-TAB-ITEM
               (s_btn_lob_area:HANDLE IN FRAME newfld) IN FRAME newfld
   s_Res = s_lob_size:MOVE-AFTER-TAB-ITEM
                (b_Field._Order:HANDLE IN FRAME newfld) IN FRAME newfld
   s_Res = s_clob_cp:MOVE-AFTER-TAB-ITEM
                (s_btn_lob_area:HANDLE IN FRAME newfld) IN FRAME newfld
   s_Res = s_btn_clob_cp:MOVE-AFTER-TAB-ITEM
                (s_clob_cp:HANDLE IN FRAME newfld) IN FRAME newfld
   s_Res = s_clob_col:MOVE-AFTER-TAB-ITEM
                (s_btn_clob_cp:HANDLE IN FRAME newfld) IN FRAME newfld
   s_Res = s_btn_clob_col:MOVE-AFTER-TAB-ITEM
                (s_clob_col:HANDLE IN FRAME newfld) IN FRAME newfld
   .
   
/* Each add will be a subtransaction. */
s_OK_Hit = no.
add_subtran:
repeat ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   /* Do this up top here, to be sure we committed the last create */
   if s_OK_Hit then leave add_subtran.

   if added AND s_btn_Done:label in frame newfld <> "Close" then
      s_btn_Done:label in frame newfld = "Close".

   if Copy_Hit then
   do:
      /* This will copy fields and end the sub-transaction so that "Done" 
      	 will not undo it. */
      Copy_Hit = false.  /* reset flag */
      run adedict/FLD/_fldcopy.p (INPUT-OUTPUT Last_Order,
      	       	     	      	 OUTPUT copytbl, OUTPUT copyfld,
      	       	     	      	 OUTPUT copied).
      if copied then 
      do:
      	 display "Copy Completed" @ s_Status with frame newfld.
      	 added = yes.
      end.
   end.
   else do:
      create b_Field.

      /* default a unique order # */
      if Last_Order = ? then
      do:
	 find LAST _Field USE-INDEX _Field-Position 
	    where _Field._File-recid = Record_Id NO-ERROR.
	 Last_Order = (if AVAILABLE _Field then _Field._Order + 10 else 10).
      end.
      else
	 Last_Order = Last_Order + 10.

      if copytbl = "" then
      do:
      	 /* This is a brand new field */

	 b_Field._Order = Last_Order.
    
	 /* Set defaults based on the current data type (either the first
	    in the list or whatever was chosen last time).
	 */
	 run SetDefaults.
    
	 /* Reset some other default values */
	 assign
	    s_Fld_Array = false
	    b_Field._Extent:screen-value in frame newfld  = "0"
	    b_Field._Extent:sensitive in frame newfld = no
	    b_Field._Fld-case:screen-value in frame newfld = "no".

     /* defauts for lob fields */
     ASSIGN  s_lob_size = "100M"
             s_lob_size:SCREEN-VALUE IN FRAME newfld = s_lob_size
             s_lob_wdth = 104857600.

      	 /* Display any remaining attributes */
	 display "" @ b_Field._Field-Name /* blank instead of ? */
      	       	 s_Optional
		 b_Field._Label     WHEN s_Fld_Typecode <> {&DTYPE_CLOB}
		 b_Field._Col-label WHEN s_Fld_Typecode <> {&DTYPE_CLOB}
		 b_Field._Mandatory
		 b_Field._Help
		 b_Field._Desc 
		 b_Field._Order
		 s_Fld_Array
		 with frame newfld.       
      end.
      else do:  
      	 /* Set the field values based on a field chosen as a template
      	    in the Copy dialog box.
      	 */
      	 find _File where _File._Db-recid = s_DbRecId AND
      	       	     	  _File._File-name = copytbl AND
                         ( _File._Owner = "PUB"  OR _File._Owner = "FOREIGN").
      	 find _Field of _File where _Field._Field-name = copyfld.
         
      	 assign
      	    b_Field._Field-name = _Field._Field-name
      	    b_Field._Data-type  = _Field._Data-type
      	    b_Field._Format     = _Field._Format
      	    b_Field._Initial    = _Field._Initial
      	    b_Field._Order    	= Last_Order.
      	 {prodict/dump/copy_fld.i &from=_Field &to=b_Field &all=false}

         IF (b_field._Data-type = "BLOB" OR b_Field._Data-type = "CLOB") THEN DO:
            DEFINE BUFFER b_Area FOR _Area.
            
            /* Find the storage object so that we can see which area the lob is stored
               in and then find the area to display the name to the user if record has
               been committed.  Else find area using number in _fld-stlen 
               _Fld-stlen holds the object number once the field is created by the Progress client 
            */
            IF _Field._Field-rpos <> ? THEN DO: /* if the field was commited */
               FIND _storageobject WHERE _Storageobject._Db-recid = s_DbRecId
                                     AND _Storageobject._Object-type = 3
                                     AND _Storageobject._Object-number = b_Field._Fld-stlen
                                     NO-LOCK.

               /* _Fld-stlen contains the unique object number once the field is created by the Progress
                  client. For new fields, we pass the area number in _Fld-stlen, so reset it now. Once
                  this field is created by the Progress client, it will reassign it to the object number
               */
               ASSIGN b_field._Fld-stlen = _StorageObject._Area-number.

               FIND b_Area WHERE b_Area._Area-number = _StorageObject._Area-number NO-LOCK.
            END.
            ELSE
               FIND b_Area WHERE b_Area._Area-number = b_Field._Fld-stlen NO-LOCK.

           ASSIGN s_lob_size:SCREEN-VALUE IN FRAME newfld = _Field._Fld-Misc2[1]
                  s_lob_wdth = _Field._Width
                  s_lob_Area:SCREEN-VALUE IN FRAME newfld = b_Area._Area-name.

           RELEASE _storageobject NO-ERROR.
           RELEASE b_Area.

         END.

         IF b_field._Data-type = "CLOB" THEN DO:

           /* set code page and collation just like copied field */
           IF _Field._Charset = _Db._Db-xl-name THEN
              ASSIGN s_clob_cp:SCREEN-VALUE IN FRAME newfld = "*Use DB Code Page".
           ELSE                                        
              ASSIGN s_clob_cp:SCREEN-VALUE IN FRAME newfld =  _Field._Charset.

           IF b_Field._Collation = _Db._Db-coll-name THEN
              ASSIGN s_clob_col:SCREEN-VALUE IN FRAME newfld = "*Use DB Collation".
           ELSE
              ASSIGN s_clob_col:SCREEN-VALUE IN FRAME newfld = _Field._Collation.

           ASSIGN b_field._Charset   = _Field._Charset
                  b_Field._Collation = _Field._Collation.
         END.

      	 assign
      	    s_Fld_DType = b_Field._Data-Type
      	    s_Fld_Array = (if b_Field._Extent > 0 then yes else no)
      	    s_Fld_Protype = b_Field._Data-type
	        s_Fld_Gatetype = b_Field._For-type
	        s_Fld_Typecode = _Field._dtype.        

      	 /* Make sensitive/label adjustments to fld-case and _Decimals based
      	    on data type chosen. */
      	    run adedict/FLD/_dtcust.p 
      	       (INPUT b_Field._Fld-case:HANDLE in frame newfld,
      	       	INPUT b_Field._Decimals:HANDLE in frame newfld).

      	 display
	    b_Field._Field-name
        s_Fld_DType
        s_Optional
	    b_Field._Format  WHEN NOT islob
	    s_lob_area       WHEN islob
	    s_btn_lob_Area   WHEN islob
	    b_Field._Label   WHEN s_Fld_Typecode <> {&DTYPE_CLOB}  
	    b_Field._Col-label WHEN s_Fld_Typecode <> {&DTYPE_CLOB}
	    b_Field._Initial   

	    b_Field._Order     
	    b_Field._Fld-case 	 when s_Fld_Typecode = {&DTYPE_CHARACTER}
	    b_Field._Decimals  	 when s_Fld_Typecode = {&DTYPE_DECIMAL}
	    s_lob_size             WHEN islob
	    b_Field._Mandatory 
        s_Fld_Array
	    b_Field._Extent      when b_Field._Extent > 0
	    b_Field._Desc      
	    b_Field._Help      
      	    with frame newfld.

      	 /* Reset the drop down value for data types */
      	 s_lst_Fld_DType:screen-value in frame newfld = CAPS(s_Fld_DType).

      	 /* Reset these for next loop iteration. */
      	 assign
      	    copytbl = ""
      	    copyfld = "".

          /* force trigger to fire on blobs and clobs*/
         IF s_fld_Dtype = "BLOB" OR s_fld_Dtype = "CLOB" THEN
            ASSIGN islob = TRUE.

         /* make sure we enable/disable the proper fields */
         RUN setlob.

      end.
      
      wait-for choose of s_btn_OK in frame newfld,
      	       	     	 s_btn_Add in frame newfld,
      	       	     	 s_btn_Fld_Copy in frame newfld OR
      	       GO of frame newfld
      	       FOCUS b_Field._Field-Name in frame newfld.

      /* Undo the create of b_Field so that when we repeat we don't end up
	 with a bogus field with all unknown values. */
      if Copy_Hit then
	 undo add_subtran, next add_subtran.
   end.
end.

hide frame newfld. 
return.

