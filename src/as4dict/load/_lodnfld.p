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

/* File _lodnfld.p

    Create 11/7/95 to work with temporary tables for PROGRESS/400 Data
    Dictionary when doing an initial load D. McMann  

     Modified 3/21/96 Load files with null capable indicator on as default 
                      D. McMann      
              3/28/96 Correct how decimals are applied to format 98-03-28-015
                      D. McMann  
              9/10/96 Added logic to test for AS400 Dictionary utilities to 
                    know if the field should default to null.  D. McMann  
            10/18/96 Added CAPS to field name to fix bug 96-10-17-004 
                     D. McMann    
            10/21/96 Added logic to assign fld-stlen and fld-misc1[5] correctly
                     for as400 df's that might have had their formats changed.   
                     D. McMann bug 96-10-17-015
            10/24/96 Changed assignment for variable length fields
                     D. McMann bug 96-10-17-016 
            03/21/97 Added Object Library support (user_env[34]) 
                     D. McMann 97-01-20-020  
            06/26/97 Changed how generated was set 97-06-20-008 D. McMann  
            06/04/98 Changed how variable length fields are assigned the proper
                     _Fld-stlen and _For-maxsize when in df 98-04-27-005.                                                 
            06/18/98 Change DTYPE_RAW from 6 to 8 DLM
            01/12/99 Added allow-null switch D. McMann
            05/18/00 Added support for new keyword MAX-GLYPHS
            03/14/02 Added logic to check that max-size = stlen.
         
                                                          
      */
/*************************************************************/

{ as4dict/dictvar.i shared }
{ as4dict/load/loaddefs.i }

DEFINE VARIABLE scrap    AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE decimal_pos AS INTEGER                         NO-UNDO.
DEFINE VARIABLE fldrecid AS RECID                              NO-UNDO.
DEFINE VARIABLE fldrpos  AS INTEGER                            NO-UNDO.
DEFINE VARIABLE pdpos AS INTEGER                               NO-UNDO.
DEFINE VARIABLE j        AS INTEGER                            NO-UNDO.
DEFINE VARIABLE type_idx AS INTEGER                            NO-UNDO.
DEFINE VARIABLE s_Fld_Typecode AS INTEGER                      NO-UNDO.
DEFINE VARIABLE dtype_ok AS LOGICAL                            NO-UNDO.

DEFINE BUFFER As4_Field FOR wtp__field.

/* For field name validation */
DEFINE VARIABLE A4FldNam AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE nlngth   AS INTEGER                            NO-UNDO.
DEFINE VARIABLE pass     AS INTEGER                            NO-UNDO.
DEFINE VARIABLE generated_name AS LOGICAL                      NO-UNDO.

/* For As4stlen.i */
DEFINE VARIABLE frmt AS CHARACTER                              NO-UNDO.
DEFINE VARIABLE lngth AS INTEGER                               NO-UNDO.     
    
DEFINE VARIABLE new_primary AS LOGICAL                         NO-UNDO.

/* Symbolic constants for dtype values. */
&global-define 	  DTYPE_CHARACTER  1
&global-define 	  DTYPE_DATE  	    2
&global-define 	  DTYPE_LOGICAL    3
&global-define 	  DTYPE_INTEGER    4
&global-define 	  DTYPE_DECIMAL    5
&global-define 	  DTYPE_RAW   	    8
&global-define 	  DTYPE_RECID 	    7

DEFINE VARIABLE progname AS CHARACTER EXTENT  7 INITIAL
  [ "Character", "Integer", "Decimal", "Date", "Logical", "Recid", "Raw" ] NO-UNDO.      

/* _For-type */  
DEFINE VARIABLE fortype AS CHARACTER EXTENT 7 INITIAL
  ["String", "Lint", "Packed", "DateISO", "Logical", "Recid", "Raw" ] NO-UNDO.
                              
/* _Fld-stdtype*/
DEFINE VARIABLE fldstdtype  AS INTEGER EXTENT 7 INITIAL
    [ 31, 36, 34, 75, 39, 85, 86 ] NO-UNDO.                                
    
 /* _Fld-stlen */
DEFINE VARIABLE fldstlen AS INTEGER EXTENT 7 INITIAL
   [ 0, 4, 0, 10, 1, 4, 0 ] NO-UNDO. 
                                     
 /* Fld-misc2[6] */     
DEFINE VARIABLE pddstype  AS CHARACTER EXTENT 25 INITIAL
  [ "A", "B", "P", "L", "A", "A", "H" ] NO-UNDO.

/* -------------------Main Line code --------------------------------*/                                    
FIND first wtp__File WHERE wtp__File._File-number = pfilenumber NO-ERROR.
IF NOT AVAILABLE wtp__File THEN RETURN.         

ASSIGN As4filename = wtp__file._As4-file.

IF wtp__File._Db-lang = 1 AND imod <> "m" THEN
  ierror = 15. /* "Use SQL ALTER TABLE to change field" */
IF ierror > 0 THEN RETURN.


FIND FIRST wfld.

  IF CAN-FIND(first wtp__Field WHERE wtp__Field._File-number = pfilenumber
    AND wtp__Field._Field-name = wfld._Field-name) THEN
    ierror = 7. /* "&2 already exists with name &3" */
  
  IF wfld._Format = ? AND
          (wfld._Data-type = "Character" OR wfld._Data-type = "Decimal" ) THEN
     ierror = 46. /* No format so can't calculate _fld-stlen */      
     
  dtype_OK = false.
  DO pdpos = 1 TO 7:
     IF wfld._Data-type = progname[pdpos] THEN dtype_ok = true.
  END.

  IF NOT dtype_OK THEN ierror = 47. /* Unsupported Datatype */

  IF ierror > 0 THEN RETURN.       
  /* This is a check to make sure we don't accidently load an AS400 only
     field.  */
  IF wfld._Fld-Misc2[5] = "A" THEN RETURN.
  
  IF wfld._Order = ? OR wfld._Order = 0 THEN DO:
    FIND LAST wtp__Field WHERE wtp__Field._File-number = pfilenumber
      USE-INDEX p__fieldl2 NO-ERROR.
    wfld._Order = (IF AVAILABLE wtp__Field THEN wtp__Field._Order ELSE 0) + 10.
  END.
  /* existing order! */
  IF CAN-FIND(first wtp__Field WHERE wtp__Field._File-number = pfilenumber
    AND wtp__Field._Order = wfld._Order) THEN
    RUN bump_sub (wfld._Order).

  ASSIGN pfldnumber = (IF wtp__file._Fil-Res1[5] <> ? THEN
               wtp__file._Fil-Res1[5] + 1 ELSE 1).

 /* Validate As4 Field Name, check for duplicates before record creation */
  IF wfld._for-name = "" OR wfld._for-name = ? THEN
     ASSIGN generated_name = yes
            A4FldNam = CAPS(SUBSTRING(wfld._Field-name,1,10)).
  ELSE 
     ASSIGN generated_name = no
            A4FldNam = CAPS(SUBSTRING(wfld._For-name,1,10)).
   
  {as4dict/load/wtfldnam.i}
  IF ierror > 0 THEN RETURN.

  CREATE wtp__Field.
  ASSIGN
    wtp__Field._File-number = pfilenumber
    wtp__Field._Field-name = wfld._Field-name
    wtp__Field._Data-type  = wfld._Data-type
    wtp__Field._Order      = wfld._Order     
    wtp__Field._Fld-number = pfldnumber 
    wtp__Field._For-id = pfldnumber     
    wtp__Field._As4-file = as4filename
    wtp__Field._Format = wfld._Format 
    wtp__Field._AS4-Library = user_env[34].
     
  { as4dict/load/copy_fld.i &from=wfld &to=wtp__Field &all=false}

   /* Get rid of cr/lf and spaces in the description and valexp fields */
   ASSIGN wtp__Field._Desc = TRIM(REPLACE (wtp__Field._Desc, CHR(13), ""))
          wtp__Field._Valexp = TRIM(REPLACE (wtp__Field._Valexp, CHR(13), "")).

   ASSIGN 
       wtp__field._For-Name = A4FldNam
       /* Default the Y/N values if no value */ 
       wtp__field._Mandatory = 
           (if wtp__field._Mandatory = "" then "N" else wtp__field._Mandatory).
   
   IF wtp__Field._Fld-Misc2[5] = "" or wtp__Field._Fld-misc2[5] = ?  THEN DO:
     IF wtp__field._Extent = 0 THEN
          ASSIGN wtp__Field._Fld-Misc2[5] = "B".      
      ELSE
          ASSIGN wtp__Field._Fld-misc2[5] = "P".               
    END.      

   ASSIGN wtp__Field._Can-Read = (IF wtp__field._Can-Read = "" THEN
              "*" ELSE wtp__field._Can-Read)
          wtp__Field._Can-Write = (IF wtp__field._Can-Write = "" THEN 
              "*" ELSE wtp__field._Can-Write).    
       
  IF wtp__Field._Fld-case = "" OR wtp__Field._Fld-case = ? THEN
           ASSIGN wtp__Field._Fld-case = "N".         
    
  IF wtp__Field._Fld-Misc2[2] = "" OR wtp__Field._Fld-Misc2[2] = ? THEN DO:
    FIND FIRST as4dict.P__Db NO-LOCK.
    IF as4dict.p__Db._Db-Misc1[3] > 0 THEN DO:
         IF user_env[30] = "no" then
           ASSIGN wtp__Field._Fld-Misc2[2] = "N".   
        ELSE              
           ASSIGN wtp__Field._Fld-Misc2[2] = "Y".    
    END.
    ELSE
         ASSIGN wtp__Field._Fld-Misc2[2] = "N".             
  END.      
  
  IF wfld._Initial <> "" THEN wtp__Field._Initial = wfld._Initial.                    
        
  fldrecid = RECID(wtp__Field).      
      
  ASSIGN wtp__File._numfld = wtp__File._numfld + 1.             
   
  /* If we have a progress format DF or the foreign type is empty,
     generate the DDS type, For-type, and Fld-stdtype based on the
     progress datatype.  Otherwise, generate them based on the
     Foreign type.  */
     
  IF NOT as400_type OR wtp__field._for-type = "" 
                    OR wtp__field._For-type = ? THEN /* DO: */
    DO pdpos = 1 TO 7:
        IF wtp__Field._Data-type = progname[pdpos] THEN 
           ASSIGN
            wtp__Field._Fld-misc2[6] = pddstype[pdpos]
            wtp__Field._For-type     = fortype[pdpos]
            wtp__Field._Fld-stdtype  = fldstdtype[pdpos].
      END.
 
  ELSE  /* Type AS400 */
    IF wtp__Field._For-type <> "" AND wtp__field._For-type <> ? THEN DO:
       type_idx = LOOKUP(wtp__field._For-type, user_env[12]).
       IF wtp__Field._Fld-stdtype = 0 THEN
         ASSIGN wtp__field._Fld-stdtype = INTEGER(ENTRY(type_idx, user_env[14])).       
    END.  

  /*  FLD-STLEN */
  IF wtp__field._fld-stlen = 0 THEN DO:
     type_idx = LOOKUP(STRING(wtp__field._fld-stdtype), user_env[14]).
     wtp__field._fld-stlen = INTEGER(ENTRY(type_idx, user_env[13])).
  END.

  /* Assign FLD-STLEN and FLD-MISC1[5] for character/decimal */
  CASE wtp__Field._Data-type:
      WHEN "Character" then s_Fld_Typecode = {&DTYPE_CHARACTER}.
      WHEN "Date"      then s_Fld_Typecode = {&DTYPE_DATE}.
      WHEN "Logical"   then s_Fld_Typecode = {&DTYPE_LOGICAL}.
      WHEN "Integer"   then s_Fld_Typecode = {&DTYPE_INTEGER}.
      WHEN "Decimal"   then s_Fld_Typecode = {&DTYPE_DECIMAL}.
      WHEN "Recid"     then s_Fld_Typecode = {&DTYPE_RECID}.
      WHEN "Raw"     then s_Fld_Typecode = {&DTYPE_RAW}.
  END.

  /* DECIMAL.  Check that the format and the # of Decimals agree.    */
  /* If not, send in a valid format to as4stlen.i   */
  IF wtp__field._Decimal > 0 AND s_Fld_Typecode = {&DTYPE_DECIMAL} THEN DO:
      ASSIGN decimal_pos = index(wtp__field._format, "." ).
      IF decimal_pos = 0 THEN DO:
          ASSIGN wtp__field._format = wtp__field._format + ".".
          DO j = 1 to wtp__field._Decimal:
             ASSIGN wtp__field._format = wtp__field._format + "9".
          END.
      END.  
      ELSE IF (LENGTH(wtp__Field._Format) - decimal_pos) <> 
            wtp__field._Decimal THEN DO: 
         ASSIGN wtp__Field._Format = substring(wtp__Field._format,1,decimal_pos).
         DO j = 1 to wtp__field._Decimal:
           ASSIGN wtp__field._format = wtp__field._format + "9".
         END.
      END.           
  END.
  
  {as4dict/FLD/as4stlen.i &prefix = "wtp__field" }

  /* Restore format to what the user wanted */
  IF s_Fld_Typecode = {&DTYPE_DECIMAL} AND wtp__field._Decimal > 0 THEN
      ASSIGN wtp__field._Format = wfld._Format.
   
  /* IF _fld-stlen is in .df and does not match format calculation, then after
     going through as4stlen to calculate other fields, put back original length. */ 
     
  IF as400_type THEN DO:
    IF wtp__Field._Fld-stlen <> wfld._Fld-stlen THEN DO:
      ASSIGN wtp__Field._Fld-stlen = wfld._Fld-stlen.
      IF wfld._Fld-stdtype = 34 THEN DO:
        IF wfld._Fld-misc1[5] <> ? AND wfld._Fld-misc1[5] <> 0 THEN
          ASSIGN wtp__Field._Fld-misc1[5] = wfld._fld-misc1[5]
                 wtp__Field._Fld-stdtype = wfld._Fld-stdtype.
        ELSE
          ASSIGN wtp__Field._Fld-misc1[5] = (wFld._Fld-stlen * 2)
                 wtp__Field._Fld-stdtype = wfld._Fld-stdtype.
      END.
      ELSE IF wtp__Field._Fld-stdtype = 42 THEN DO:
        IF wfld._Fld-misc1[5] <> ? AND wfld._Fld-misc1[5] <> 0 THEN
          ASSIGN wtp__Field._Fld-misc1[5] = wfld._fld-misc1[5]
                 wtp__Field._Fld-stdtype = wfld._Fld-stdtype.
        ELSE
          ASSIGN wtp__Field._Fld-misc1[5] = ((wFld._Fld-stlen * 2) - 1)
                 wtp__Field._Fld-stdtype = wfld._Fld-stdtype.   
      END.
      ELSE IF wtp__Field._Fld-stdtype = 33 THEN
        ASSIGN wtp__Field._Fld-misc1[5] = wFld._Fld-stlen.  
    END.    
    IF wtp__Field._Fld-stdtype = 37 THEN
      ASSIGN wtp__Field._Fld-misc1[5] = 9.    
    ELSE IF wtp__Field._Fld-stdtype = 38 THEN
      ASSIGN wtp__Field._Fld-misc1[5] = 17.       
  END.     
     
        
  /*  INTEGER Datatypes.  If fld-misc1[5] < 4 and we have a Lint datatype */
  /*  change it to Sint */
  IF wtp__field._For-type = "Lint" AND wtp__field._Fld-Misc1[5] < 4 THEN
     ASSIGN wtp__field._For-type = "Sint"
            wtp__field._Fld-stlen = 2
            wtp__field._Fld-stdtype = 35.
  
  /* DDS TYPE - FLD-MISC2[6] */
  IF (wtp__Field._Fld-Misc2[6] = "" OR wtp__Field._Fld-Misc2[6] = ?)
     AND wtp__Field._Fld-stdtype <> 0 THEN DO:
     {as4dict/FLD/proxtype.i &prefix = "wtp__field"}
     assign wtp__field._Fld-Misc2[6] = ddstype[dpos].
  END.

  /* Tell the client that we have a variable length field  and reset number of
      allowed characters or digits equal to max size */
  IF wtp__field._For-Maxsize <> 0 AND wtp__Field._For-Maxsize <> ? THEN DO:
    IF (wtp__Field._Fld-stlen + 2) = wtp__Field._For-maxsize THEN
        ASSIGN wtp__field._Fld-Misc1[6] = 1.
    ELSE
     ASSIGN wtp__field._Fld-Misc1[6] = 1
            wtp__Field._Fld-stlen = wtp__Field._For-maxsize
            wtp__Field._For-maxsize = wtp__Field._For-maxsize + 2.                     
  END.
  IF wtp__Field._Data-type BEGINS "char" AND 
     wtp__Field._For-Type = "cstring" THEN
          SUBSTRING(wtp__File._Fil-Misc2[5],2,1) = "6".
  ELSE IF wtp__Field._Data-type BEGINS "char" AND 
          wtp__Field._Fld-case <> "Y" THEN
        ASSIGN SUBSTRING(wtp__File._Fil-Misc2[5],2,1) = 
           (IF SUBSTRING(wtp__File._Fil-Misc2[5],2,1) <> "6" THEN "7" 
            ELSE SUBSTRING(wtp__File._Fil-Misc2[5],2,1) ).

  ASSIGN wtp__File._Fil-Res1[5] = pfldnumber.
      
  scrap = "".
  FOR EACH wflt:
    IF wflt._Proc-name = "!" THEN DO:
      DELETE wflt. /* triggers are deleted via .df when proc-name set to "!" */
      NEXT.
    END.
    FIND wtp__Trgfd WHERE wtp__Trgfd._Event = CAPS(wflt._Event) 
               AND wtp__Trgfd._Fld-number = wtp__Field._Fld-number
               AND wtp__Trgfd._file-number = wtp__Field._file-number NO-ERROR.
    FIND wtp__field WHERE wtp__field._file-number = pfilenumber
        AND wtp__field._fld-number = pfldnumber.
    IF AVAILABLE wtp__Trgfd
      AND wtp__Trgfd._Event     = CAPS(wflt._Event)
      AND wtp__Trgfd._Override  = wflt._Override
      AND wtp__Trgfd._Proc-name = wflt._Proc-name 
      AND wtp__Trgfd._Trig-CRC  = wflt._Trig-CRC THEN NEXT.
    IF AVAILABLE wtp__Trgfd THEN DELETE wtp__Trgfd.
    CREATE wtp__Trgfd.
    ASSIGN
      wtp__Trgfd._File-number = pfilenumber
      wtp__Trgfd._Fld-number  = pfldnumber
      wtp__Trgfd._Event       = CAPS(wflt._Event)
      wtp__Trgfd._Override    = wflt._Override
      wtp__Trgfd._Proc-Name   = wflt._Proc-Name
      wtp__Trgfd._Trig-CRC    = (IF wflt._Trig-CRC = ? THEN 0 ELSE wflt._Trig-CRC)
      scrap = scrap + (IF scrap = "" THEN "" ELSE ",") + CAPS(wflt._Event).
  END.
  FOR EACH wtp__Trgfd WHERE wtp__Trgfd._Fld-number = pfldnumber
                  AND wtp__Trgfd._File-number = pfilenumber
                  AND NOT CAN-DO(scrap,wtp__Trgfd._Event):
    DELETE wtp__Trgfd.
  END.

RETURN.


PROCEDURE bump_sub.
  DEFINE INPUT  PARAMETER norder AS INTEGER NO-UNDO.

  DEFINE BUFFER uField FOR wtp__Field.
  DEFINE VARIABLE i AS INTEGER NO-UNDO.
  DEFINE VARIABLE j AS INTEGER NO-UNDO.

  FIND uField WHERE uField._File-number = wtp__File._File-number
                AND uField._Order = norder NO-ERROR.
  IF NOT AVAILABLE uField THEN RETURN.

  DO i = norder + 1 TO i + 1:
    FIND uField  WHERE uField._File-number = wtp__File._File-number
                   AND uField._Order = i NO-ERROR.
    IF NOT AVAILABLE uField THEN LEAVE.
  END.

  DO j = i - 1 TO norder BY -1:
    FIND uField WHERE uField._File-number = wtp__File._File-number
                AND uField._Order = j.
    uField._Order = uField._Order + 1.
  END.

END PROCEDURE.





