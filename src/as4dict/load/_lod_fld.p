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


/* Modified 12/18/95 by D. McMann to check for variable length fields to
    assign _fld-misc1[5] properly.    
            3/21/96 Load fields with null capable indicator on as default 
                    D. McMann  
            3/28/96 Correct how decimals are applied to format 96-03-28-015
                    D. McMann   
            9/10/96 Added logic to test for AS400 Dictionary utilities to
                    know if the field should default to null.  D. McMann   
            10/18/96 Added CAPS to field name to fix bug 96-10-17-004 
                     D. McMann
            10/21/96 Added logic to assign fld-stlen and fld-misc1[5] correctly
                     for as400 df's that might have had their formats changed.   
                     D. McMann bug 96-10-17-015 
            10/24/96 Changed assignment for variable length fields to fix
                     D. McMann bug 96-10-17-016   
            03/20/97 Changed modify of field to change field size.
            03/21/97 Added Object Library support (user_env[34]) D. McMann
                     97-01-20-020 
            06/25/97 D. McMann 97-06-20-008 generated not being set properly
            04/13/98 D. McMann 98-03-12-030 Added assignment of _Fil-misc1[1]
                     for sync to know something has happened.
            06/04/98 Changed how variable length fields are assigned the proper
                     _Fld-stlen and _For-maxsize when in df 98-04-27-005. 
            06/18/98 Change DTYPE_RAW from 6 to 8 DLM
            01/12/99 Added allow-null switch D. McMann
            05/18/00 Added support for new keyword MAX-GLYPHS
            02/12/02 Added logic for changing stlen of fields when the format was increased.
            03/14/02 Added logic to check max-size = stlen.
            03/21/02 Added assignment to _fil-misc1[1] when only format is changed
                     for extents
                         
                               
*/    

{ as4dict/dictvar.i shared }
{ as4dict/load/loaddefs.i }

DEFINE VARIABLE scrap          AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE decimal_pos    AS INTEGER                      NO-UNDO.
DEFINE VARIABLE fldrecid       AS RECID                        NO-UNDO.
DEFINE VARIABLE fldrpos        AS INTEGER                      NO-UNDO.
DEFINE VARIABLE pdpos          AS INTEGER                      NO-UNDO.
DEFINE VARIABLE j              AS INTEGER                      NO-UNDO.
DEFINE VARIABLE type_idx       AS INTEGER                      NO-UNDO.
DEFINE VARIABLE s_Fld_Typecode AS INTEGER                      NO-UNDO.
DEFINE VARIABLE dtype_ok       AS LOGICAL                      NO-UNDO.  
DEFINE VARIABLE chgsize        AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE ofldlen        AS INTEGER                      NO-UNDO.
DEFINE VARIABLE ofldmisc15     AS INTEGER                      NO-UNDO.
DEFINE VARIABLE ofldstdtype    AS INTEGER                      NO-UNDO.
DEFINE VARIABLE odecimals      AS INTEGER                      NO-UNDO.
DEFINE VARIABLE ofortype       AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE oformax        AS INTEGER                      NO-UNDO.


DEFINE BUFFER As4_Field FOR As4dict.p__field.

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
FIND as4dict.p__File WHERE as4dict.p__File._File-number = pfilenumber NO-ERROR.
IF NOT AVAILABLE as4dict.p__File THEN RETURN.         

ASSIGN As4filename = as4dict.p__file._As4-file
       chgsize = FALSE.

IF as4dict.p__File._Frozen = "Y" THEN
  ierror = 14. /* "Cannot alter field from frozen file" */
IF as4dict.p__File._Db-lang = 1 AND imod <> "m" THEN
  ierror = 15. /* "Use SQL ALTER TABLE to change field" */
IF ierror > 0 THEN RETURN.


FIND FIRST wfld.

IF imod <> "a" THEN 
  FIND as4dict.p__Field WHERE as4dict.p__Field._Field-name = wfld._Field-name 
       AND as4dict.p__Field._File-number = pfilenumber. /* proven to exist */
       
/* Changed to include update of field if format has changed so size of field will
   be updated.  This would be from an incremental dump
*/   
IF (imod = "a") OR (imod = "m" AND as4dict.p__Field._Format <> wfld._Format) THEN DO:

  /* If format changes see if we can also change the size of the field. */
  IF imod = "m" AND wfld._Format <>  as4dict.p__Field._format THEN 
  _for-loop:  
  DO:
    ASSIGN as4dict.p__Field._Format = wfld._Format.
    IF wfld._fld-stlen = as4dict.p__Field._Fld-stlen AND as4dict.p__Field._Data-type = "CHARACTER" THEN 
      RUN getcharlength.
    ELSE
      ASSIGN lngth = (IF wfld._Fld-stlen > 0 THEN wfld._Fld-stlen ELSE as4dict.p__Field._Fld-stlen).

    IF CAN-FIND(FIRST as4dict.p__Idxfd WHERE as4dict.p__Idxfd._fld-number = as4dict.p__Field._Fld-number 
                   AND as4dict.p__Idxfd._File-number = as4dict.p__Field._File-number) THEN DO:
      
      IF lngth > 200 THEN DO:
        ASSIGN chgsize = FALSE
               ierror = 49.
        LEAVE _for-loop.
      END.
      ASSIGN chgsize = TRUE
             ofldlen = as4dict.p__field._fld-stlen
             ofldmisc15 = as4dict.p__Field._Fld-misc1[5]
             ofldstdtype = as4dict.p__Field._Fld-stdtype
             ofortype = as4dict.p__Field._For-type
             odecimals = as4dict.p__Field._Decimals
             oformax   = as4dict.p__Field._For-maxsize.

      FOR EACH as4dict.p__Index WHERE as4dict.p__Index._File-number = as4dict.p__Field._File-number:
        FIND FIRST as4dict.p__Idxfd WHERE as4dict.p__idxfd._Idx-num = as4dict.p__Index._Idx-num
                                      AND as4dict.p__Idxfd._File-number = as4dict.p__Index._File-number
                                      AND as4dict.p__Idxfd._fld-number = as4dict.p__Field._Fld-number
                                      NO-LOCK NO-ERROR.
        IF AVAILABLE as4dict.p__Idxfd THEN DO:
          FOR EACH as4dict.p__Idxfd WHERE as4dict.p__idxfd._Idx-num = as4dict.p__Index._Idx-num
                                      AND as4dict.p__Idxfd._File-number = as4dict.p__Index._File-number
                                      AND as4dict.p__Idxfd._Fld-number <> as4dict.p__Field._Fld-number:
            FIND As4_Field WHERE As4_Field._File-number = as4dict.p__Idxfd._File-number
                             AND As4_Field._Fld-number = as4dict.p__Idxfd._Fld-number NO-LOCK.
            ASSIGN lngth = lngth + As4_Field._fld-stlen.
          END.
          IF lngth > 200 THEN 
            ASSIGN chgsize = FALSE          
                   ierror = 49.
          ELSE  
            ASSIGN lngth = (IF wfld._Fld-stlen > 0 THEN wfld._Fld-stlen ELSE as4dict.p__Field._Fld-stlen).
          IF ierror > 0 THEN LEAVE _for-loop.
        END.
      END.
    END.
    ELSE IF as4dict.p__Field._Extent > 0 THEN DO:
      ASSIGN chgsize = FALSE
             ierror = 51
             as4dict.p__File._Fil-misc1[1] = as4dict.p__File._Fil-misc1[1] + 1.
    END.
    ELSE
        ASSIGN chgsize = TRUE
               ofldlen = as4dict.p__field._fld-stlen
               ofldmisc15 = as4dict.p__Field._Fld-misc1[5]
               ofldstdtype = as4dict.p__Field._Fld-stdtype
               ofortype = as4dict.p__Field._For-type
               odecimals = as4dict.p__Field._Decimals
               oformax   = as4dict.p__Field._For-maxsize.
  END. 

  IF imod = "a" AND CAN-FIND(as4dict.p__Field WHERE as4dict.p__Field._File-number = pfilenumber
    AND as4dict.p__Field._Field-name = wfld._Field-name) THEN
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
    FIND LAST as4dict.p__Field WHERE as4dict.p__Field._File-number = pfilenumber
      USE-INDEX p__fieldl2 NO-ERROR.
    wfld._Order = (IF AVAILABLE as4dict.p__Field THEN as4dict.p__Field._Order ELSE 0) + 10.
  END.
  /* existing order! */
  IF CAN-FIND(as4dict.p__Field WHERE as4dict.p__Field._File-number = pfilenumber
    AND as4dict.p__Field._Order = wfld._Order AND
        as4dict.p__Field._Field-name <> wfld._Field-name ) THEN
    RUN bump_sub (wfld._Order).
  
  IF imod = "a" THEN
    ASSIGN pfldnumber = (IF as4dict.p__file._Fil-Res1[5] <> ? THEN
                         as4dict.p__file._Fil-Res1[5] + 1 ELSE 1).
  ELSE
    ASSIGN pfldnumber = as4dict.p__Field._Fld-number.             

 /* Validate As4 Field Name, check for duplicates before record creation */
  if wfld._for-name = "" OR wfld._For-name = ? THEN
    ASSIGN generated_name = true
           A4FldNam = CAPS(SUBSTRING(wfld._Field-name,1,10)).
  else
    ASSIGN generated_name = false
           A4FldNam = CAPS(SUBSTRING(wfld._For-name,1,10)).
 
  {as4dict/load/a4fldnam.i}
  IF ierror > 0 AND ierror < 49 THEN RETURN.

  IF imod = "a" THEN DO:
    CREATE as4dict.p__Field.
    ASSIGN
      as4dict.p__Field._File-number = pfilenumber
      as4dict.p__Field._Field-name = wfld._Field-name
      as4dict.p__Field._Data-type  = wfld._Data-type
      as4dict.p__Field._Order      = wfld._Order     
      as4dict.p__Field._Fld-number = pfldnumber 
      as4dict.p__Field._For-id = pfldnumber     
      as4dict.p__Field._As4-file = as4filename
      as4dict.p__Field._Format = wfld._Format 
      as4dict.p__Field._AS4-Library = as4dict.p__File._AS4-Library.
  END.
  ELSE 
     ASSIGN
      as4dict.p__Field._Field-name = wfld._Field-name
      as4dict.p__Field._Order      = wfld._Order     
      as4dict.p__Field._Format     = wfld._Format.
     
  { as4dict/load/copy_fld.i &from=wfld &to=as4dict.p__Field &all=false}
  
  IF imod = "m" AND ofldlen > as4dict.p__Field._Fld-stlen THEN
    ASSIGN as4dict.p__Field._Fld-stlen = ofldlen
           as4dict.p__Field._Fld-misc1[5] = ofldmisc15
           as4dict.p__Field._Fld-stdtype = ofldstdtype
           as4dict.p__Field._For-type = ofortype
           as4dict.p__Field._Decimals = odecimals 
           chgsize = FALSE
           ierror = 50.

   /* Get rid of cr/lf and spaces in the description and valexp fields */
   ASSIGN as4dict.p__Field._Desc = TRIM(REPLACE (as4dict.p__Field._Desc, CHR(13), ""))
          as4dict.p__Field._Valexp = TRIM(REPLACE (as4dict.p__Field._Valexp, CHR(13), "")).

   ASSIGN 
       as4dict.p__field._For-Name = A4FldNam
       /* Default the Y/N values if no value */ 
       as4dict.p__field._Mandatory = 
           (if as4dict.p__field._Mandatory = "" then "N" else as4dict.p__field._Mandatory).
   
   IF as4dict.p__Field._Fld-Misc2[5] = "" or as4dict.p__Field._Fld-misc2[5] = ?  THEN DO:
     IF as4dict.p__field._Extent = 0 THEN
          ASSIGN as4dict.p__Field._Fld-Misc2[5] = "B".      
      ELSE
          ASSIGN as4dict.p__Field._Fld-misc2[5] = "P".               
   END.      

   ASSIGN as4dict.p__Field._Can-Read = (IF as4dict.p__field._Can-Read = "" THEN
              "*" ELSE as4dict.p__field._Can-Read)
          as4dict.p__Field._Can-Write = (IF as4dict.p__field._Can-Write = "" THEN 
              "*" ELSE as4dict.p__field._Can-Write).    
       
  IF as4dict.p__Field._Fld-case = "" OR as4dict.p__Field._Fld-case = ? THEN
           ASSIGN as4dict.p__Field._Fld-case = "N".         
    
  IF as4dict.p__Field._Fld-Misc2[2] = "" OR as4dict.p__Field._Fld-Misc2[2] = ? THEN DO:
    FIND FIRST as4dict.p__Db NO-LOCK.
    IF as4dict.p__Db._Db-Misc1[3] > 0 THEN DO:   
        IF user_env[30] = "no" then
           ASSIGN as4dict.p__Field._Fld-Misc2[2] = "N".   
        ELSE              
           ASSIGN as4dict.p__Field._Fld-Misc2[2] = "Y".   
    END.
    ELSE 
      ASSIGN as4dict.p__Field._Fld-Misc2[2] = "N".
           
  END.
            
  IF wfld._Initial <> "" THEN as4dict.p__Field._Initial = wfld._Initial.                    
        
  fldrecid = RECID(as4dict.p__Field).      
      
  IF imod = "a" THEN
     ASSIGN as4dict.p__File._numfld = as4dict.p__File._numfld + 1.             
 
  /* If we have a progress format DF or the foreign type is empty,
     generate the DDS type, For-type, and Fld-stdtype based on the
     progress datatype.  Otherwise, generate them based on the
     Foreign type.  */
     
  IF NOT as400_type OR as4dict.p__field._for-type = "" 
                    OR as4dict.p__field._For-type = ? THEN /* DO: */
    DO pdpos = 1 TO 7:
        IF as4dict.p__Field._Data-type = progname[pdpos] THEN 
           ASSIGN
            as4dict.p__Field._Fld-misc2[6] = pddstype[pdpos]
            as4dict.p__Field._For-type     = fortype[pdpos]
            as4dict.p__Field._Fld-stdtype  = fldstdtype[pdpos].
  END.

  ELSE  /* Type AS400 */
    IF as4dict.p__Field._For-type <> "" AND as4dict.p__field._For-type <> ? THEN DO:
       type_idx = LOOKUP(as4dict.p__field._For-type, user_env[12]).
       IF as4dict.p__Field._Fld-stdtype = 0 THEN
         ASSIGN as4dict.p__field._Fld-stdtype = INTEGER(ENTRY(type_idx, user_env[14])).       
    END.  

  /*  FLD-STLEN */
  IF as4dict.p__field._fld-stlen = 0 THEN DO:
     type_idx = LOOKUP(STRING(as4dict.p__field._fld-stdtype), user_env[14]).
     ASSIGN as4dict.p__field._fld-stlen = INTEGER(ENTRY(type_idx, user_env[13])).
  END.

  /* Assign FLD-STLEN and FLD-MISC1[5] for character/decimal */
  CASE as4dict.p__Field._Data-type:
      WHEN "Character" then s_Fld_Typecode = {&DTYPE_CHARACTER}.
      WHEN "Date"      then s_Fld_Typecode = {&DTYPE_DATE}.
      WHEN "Logical"   then s_Fld_Typecode = {&DTYPE_LOGICAL}.
      WHEN "Integer"   then s_Fld_Typecode = {&DTYPE_INTEGER}.
      WHEN "Decimal"   then s_Fld_Typecode = {&DTYPE_DECIMAL}.
      WHEN "Recid"     then s_Fld_Typecode = {&DTYPE_RECID}.
      WHEN "Raw  "     then s_Fld_Typecode = {&DTYPE_RAW}.
  END.

  /* DECIMAL.  Check that the format and the # of Decimals agree.    */
  /* If not, send in a valid format to as4stlen.i   */
  IF as4dict.p__field._Decimal > 0 AND s_Fld_Typecode = {&DTYPE_DECIMAL} THEN DO:
      ASSIGN decimal_pos = index(as4dict.p__field._format, "." ).
      IF decimal_pos = 0 THEN DO:
          ASSIGN as4dict.p__field._format = as4dict.p__field._format + ".".
          DO j = 1 to as4dict.p__field._Decimal:
             ASSIGN as4dict.p__field._format = as4dict.p__field._format + "9".
          END.
      END.  
      ELSE IF (LENGTH(as4dict.p__Field._Format) - decimal_pos) <> 
            as4dict.p__field._Decimal THEN DO: 
         ASSIGN as4dict.p__Field._Format = substring(as4dict.p__Field._format,1,decimal_pos).
         DO j = 1 to as4dict.p__field._Decimal:
           ASSIGN as4dict.p__field._format = as4dict.p__field._format + "9".
         END.
      END.                        
  END.

  /* Now calculate the information for new fields or fields we are going to change
     because the format changed */
  IF imod = "a" OR chgsize THEN DO:
   
   {as4dict/FLD/as4stlen.i &prefix = "as4dict.p__field" }
   /* If the changed information is smaller than the old, we can't change the field so put
      everything back except the format */

   IF chgsize AND as4dict.p__field._fld-stlen < ofldlen  THEN
     ASSIGN as4dict.p__field._fld-stlen = ofldlen
            as4dict.p__Field._Fld-misc1[5] = ofldmisc15
            as4dict.p__Field._Fld-stdtype = ofldstdtype
            as4dict.p__Field._For-type = ofortype
            as4dict.p__Field._Decimals = odecimals
            ierror = 50
            chgsize = FALSE. 
  END.
  
  /* Restore format to what the user wanted */
  IF s_Fld_Typecode = {&DTYPE_DECIMAL} AND as4dict.p__field._Decimal > 0 THEN
      ASSIGN as4dict.p__field._Format = wfld._Format.
  
  /* If we have an as400 format we may need to calculate number of digits if the
     format is not the same as number of digits and stlen.
     IF _fld-stlen is in .df and does not match format calculation, then after
     going through as4stlen to calculate other fields, put back original length. */    
  IF as400_type THEN DO:
    IF as4dict.p__Field._Fld-stlen < wfld._Fld-stlen  AND chgsize THEN DO:
      ASSIGN as4dict.p__Field._Fld-stlen = wfld._Fld-stlen
             as4dict.p__Field._For-type = wfld._For-type.
      IF wfld._Fld-stdtype = 34 THEN DO:
        IF wfld._Fld-misc1[5] <> ? AND wfld._Fld-misc1[5] <> 0 THEN
          ASSIGN as4dict.p__Field._Fld-misc1[5] = wfld._fld-misc1[5]
                 as4dict.p__Field._Fld-stdtype = wfld._Fld-stdtype.
        ELSE
          ASSIGN as4dict.p__Field._Fld-misc1[5] = (wfld._Fld-stlen * 2)
                 as4dict.p__Field._Fld-stdtype = wfld._Fld-stdtype.
      END.
      ELSE IF wfld._Fld-stdtype = 42 THEN DO:
        IF wfld._Fld-misc1[5] <> ? AND wfld._Fld-misc1[5] <> 0 THEN
          ASSIGN as4dict.p__Field._Fld-misc1[5] = wfld._fld-misc1[5]
                 as4dict.p__Field._Fld-stdtype = wfld._Fld-stdtype.
        ELSE
          ASSIGN as4dict.p__Field._Fld-misc1[5] = ((wFld._Fld-stlen * 2) - 1)
                 as4dict.p__Field._Fld-stdtype = wfld._Fld-stdtype.
      END.
      ELSE IF as4dict.p__Field._Fld-stdtype = 33 THEN
        ASSIGN as4dict.p__Field._Fld-misc1[5] = wFld._Fld-stlen.  
    END.
    
    IF as4dict.p__Field._Fld-stdtype = 37 THEN
      ASSIGN as4dict.p__Field._Fld-misc1[5] = 9.    
    ELSE IF as4dict.p__Field._Fld-stdtype = 38 THEN
      ASSIGN as4dict.p__Field._Fld-misc1[5] = 17.       
  END.
         
  /*  INTEGER Datatypes.  If fld-misc1[5] < 4 and we have a Lint datatype */
  /*  change it to Sint */
  IF as4dict.p__field._For-type = "Lint" AND as4dict.p__field._Fld-Misc1[5] < 4 THEN
     ASSIGN as4dict.p__field._For-type = "Sint"
            as4dict.p__field._Fld-stlen = 2
            as4dict.p__field._Fld-stdtype = 35.
  ELSE IF as4dict.p__Field._For-type = "Lint" AND as4dict.p__Field._Fld-stlen <> 4 THEN
     ASSIGN as4dict.p__Field._Fld-stlen = 4.

  
  /* DDS TYPE - FLD-MISC2[6] */
  IF (as4dict.p__Field._Fld-Misc2[6] = "" OR as4dict.p__Field._Fld-Misc2[6] = ?)
     AND as4dict.p__Field._Fld-stdtype <> 0 THEN DO:
     {as4dict/FLD/proxtype.i &prefix = "as4dict.p__field"}
     assign as4dict.p__field._Fld-Misc2[6] = ddstype[dpos].
  END.

  /* Tell the client that we have a new variable length field  and change max number
       of digits allowed and length to equal max size. */

  IF as4dict.p__field._For-Maxsize <> 0 AND 
     as4dict.p__Field._For-Maxsize <> ? AND 
     imod = "a" THEN DO:    
    IF (as4dict.p__Field._Fld-stlen + 2) = as4dict.p__Field._For-maxsize THEN
        as4dict.p__field._Fld-Misc1[6] = 1.
    ELSE
      ASSIGN as4dict.p__field._Fld-Misc1[6] = 1
             as4dict.p__Field._Fld-stlen = as4dict.p__Field._For-maxsize
             as4dict.p__Field._For-maxsize = as4dict.p__Field._For-maxsize + 2.
  END.
  IF as4dict.p__Field._Data-type BEGINS "char" AND 
     as4dict.p__Field._For-Type = "cstring" THEN
          SUBSTRING(as4dict.p__File._Fil-Misc2[5],2,1) = "6".
  ELSE IF as4dict.p__Field._Data-type BEGINS "char" AND 
          as4dict.P__Field._Fld-case <> "Y" THEN
        ASSIGN SUBSTRING(as4dict.p__File._Fil-Misc2[5],2,1) = 
           (IF SUBSTRING(as4dict.p__File._Fil-Misc2[5],2,1) <> "6" THEN "7" 
            ELSE SUBSTRING(as4dict.p__File._Fil-Misc2[5],2,1) ).

  IF imod = "a" THEN
    ASSIGN as4dict.p__File._Fil-Res1[5] = pfldnumber. 
  ASSIGN as4dict.p__File._Fil-misc1[1] = as4dict.p__File._Fil-misc1[1] + 1.  
END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "m" THEN DO: /*---------------------------------------------------*/                      
  IF as4dict.p__Field._Data-type <> wfld._Data-type THEN
    ierror = 10. /* "Cannot change datatype of existing field" */
  IF as4dict.p__Field._Extent <> wfld._Extent THEN
    ierror = 11. /* "Cannot change extent of existing field" */
  IF ierror > 0 THEN RETURN.

  /* existing order! */
  IF as4dict.p__Field._Order <> wfld._Order
    AND CAN-FIND(as4dict.p__Field WHERE as4dict.p__Field._File-number = pfilenumber
      AND as4dict.p__Field._Order = wfld._Order) THEN
    RUN bump_sub (wfld._Order).

  IF as4dict.p__File._Db-lang = 0 THEN DO:
    IF as4dict.p__Field._Can-write   <> wfld._Can-write    THEN as4dict.p__Field._Can-write     = wfld._Can-write.
    IF as4dict.p__Field._Can-read    <> wfld._Can-read     THEN as4dict.p__Field._Can-read      = wfld._Can-read.
    IF as4dict.p__Field._Mandatory   <> wfld._Mandatory    THEN as4dict.p__Field._Mandatory     = wfld._Mandatory.
    IF as4dict.p__Field._Decimals    <> wfld._Decimals     THEN as4dict.p__Field._Decimals      = wfld._Decimals.
  END.

  IF as4dict.p__Field._Col-label     <> wfld._Col-label    THEN as4dict.p__Field._Col-label     = wfld._Col-label.
  IF as4dict.p__Field._Col-label-SA  <> wfld._Col-label-SA THEN as4dict.p__Field._Col-label-SA  = wfld._Col-label-SA.
  IF as4dict.p__Field._Desc    	     <> wfld._Desc         THEN as4dict.p__Field._Desc          = wfld._Desc.
  IF as4dict.p__Field._Format  	     <> wfld._Format       THEN as4dict.p__Field._Format        = wfld._Format.
  IF as4dict.p__Field._Format-SA     <> wfld._Format-SA    THEN as4dict.p__Field._Format-SA     = wfld._Format-SA.
  IF as4dict.p__Field._Help    	     <> wfld._Help         THEN as4dict.p__Field._Help          = wfld._Help.
  IF as4dict.p__Field._Help-SA 	     <> wfld._Help-SA      THEN as4dict.p__Field._Help-SA       = wfld._Help-SA.
  IF as4dict.p__Field._Initial 	     <> wfld._Initial      THEN as4dict.p__Field._Initial       = wfld._Initial.
  IF as4dict.p__Field._Initial-SA    <> wfld._Initial-SA   THEN as4dict.p__Field._Initial-SA    = wfld._Initial-SA.
  IF as4dict.p__Field._Label   	     <> wfld._Label        THEN as4dict.p__Field._Label         = wfld._Label.
  IF as4dict.p__Field._Label-SA      <> wfld._Label-SA     THEN as4dict.p__Field._Label-SA      = wfld._Label-SA.
  IF as4dict.p__Field._Order   	     <> wfld._Order        THEN as4dict.p__Field._Order         = wfld._Order.
  IF as4dict.p__Field._Valexp  	     <> wfld._Valexp       THEN as4dict.p__Field._Valexp        = wfld._Valexp.
  IF as4dict.p__Field._Valmsg  	     <> wfld._Valmsg       THEN as4dict.p__Field._Valmsg        = wfld._Valmsg.
  IF as4dict.p__Field._Valmsg-SA     <> wfld._Valmsg-SA    THEN as4dict.p__Field._Valmsg-SA     = wfld._Valmsg-SA.
  IF as4dict.p__Field._View-as 	     <> wfld._View-as      THEN as4dict.p__Field._View-as       = wfld._View-as.

  IF as4dict.p__Field._Fld-case      <> wfld._Fld-case
    AND NOT CAN-FIND(FIRST as4dict.p__Idxfd WHERE as4dict.p__Idxfd._File-number = pfilenumber
         AND as4dict.p__Idxfd._Fld-number = pfldnumber) THEN as4dict.p__Field._Fld-case     = wfld._Fld-case.
/* The following information may not be changed in using "MODIFY".  This
   may change in the future.  Currently an incremental dump may only be
   generated using a PROGRESS db-type in which this information is not
   used, so preserve what is already in these fields on a MODIFY.   
   ----------------------------------------------------------------- */
/*
  IF as4dict.p__Field._Fld-stlen     <> wfld._Fld-stlen     THEN as4dict.p__Field._Fld-stlen     = wfld._Fld-stlen.
  IF as4dict.p__Field._Fld-stoff     <> wfld._Fld-stoff     THEN as4dict.p__Field._Fld-stoff     = wfld._Fld-stoff.
  IF as4dict.p__Field._Fld-stdtype   <> wfld._Fld-stdtype   THEN as4dict.p__Field._Fld-stdtype   = wfld._Fld-stdtype.
  IF as4dict.p__Field._For-Id        <> wfld._For-Id        THEN as4dict.p__Field._For-Id        = wfld._For-Id.
  IF as4dict.p__Field._For-Name      <> wfld._For-Name      THEN as4dict.p__Field._For-Name      = wfld._For-Name.
  IF as4dict.p__Field._For-Type      <> wfld._For-Type      THEN as4dict.p__Field._For-Type      = wfld._For-Type.
  IF as4dict.p__Field._For-Xpos      <> wfld._For-Xpos      THEN as4dict.p__Field._For-Xpos      = wfld._For-Xpos.
  IF as4dict.p__Field._For-Itype     <> wfld._For-Itype     THEN as4dict.p__Field._For-Itype     = wfld._For-Itype.
  IF as4dict.p__Field._For-Retrieve  <> wfld._For-Retrieve  THEN as4dict.p__Field._For-Retrieve  = wfld._For-Retrieve.
  IF as4dict.p__Field._For-Scale     <> wfld._For-Scale     THEN as4dict.p__Field._For-Scale     = wfld._For-Scale.
  IF as4dict.p__Field._For-Spacing   <> wfld._For-Spacing   THEN as4dict.p__Field._For-Spacing   = wfld._For-Spacing.
  IF as4dict.p__Field._For-Separator <> wfld._For-Separator THEN as4dict.p__Field._For-Separator = wfld._For-Separator.
  IF as4dict.p__Field._For-Allocated <> wfld._For-Allocated THEN as4dict.p__Field._For-Allocated = wfld._For-Allocated.
  IF as4dict.p__Field._For-Maxsize   <> wfld._For-Maxsize   THEN as4dict.p__Field._For-Maxsize   = wfld._For-Maxsize.
  IF as4dict.p__Field._Fld-misc2[1]  <> wfld._Fld-misc2[1]  THEN as4dict.p__Field._Fld-misc2[1]  = wfld._Fld-misc2[1].
  IF as4dict.p__Field._Fld-misc2[2]  <> wfld._Fld-misc2[2]  THEN as4dict.p__Field._Fld-misc2[2]  = wfld._Fld-misc2[2].
  IF as4dict.p__Field._Fld-misc2[3]  <> wfld._Fld-misc2[3]  THEN as4dict.p__Field._Fld-misc2[3]  = wfld._Fld-misc2[3].
  IF as4dict.p__Field._Fld-misc2[4]  <> wfld._Fld-misc2[4]  THEN as4dict.p__Field._Fld-misc2[4]  = wfld._Fld-misc2[4]. 
  IF as4dict.p__Field._Fld-misc2[5]  <> wfld._Fld-misc2[5]  THEN as4dict.p__Field._Fld-misc2[5]  = wfld._Fld-misc2[5].
  IF as4dict.p__Field._Fld-misc2[6]  <> wfld._Fld-misc2[6]  THEN as4dict.p__Field._Fld-misc2[6]  = wfld._Fld-misc2[6].
  IF as4dict.p__Field._Fld-misc2[7]  <> wfld._Fld-misc2[7]  THEN as4dict.p__Field._Fld-misc2[7]  = wfld._Fld-misc2[7].
  IF as4dict.p__Field._Fld-misc2[8]  <> wfld._Fld-misc2[8]  THEN as4dict.p__Field._Fld-misc2[8]  = wfld._Fld-misc2[8].
  IF as4dict.p__Field._Fld-misc1[1]  <> wfld._Fld-misc1[1]  THEN as4dict.p__Field._Fld-misc1[1]  = wfld._Fld-misc1[1].
  IF as4dict.p__Field._Fld-misc1[2]  <> wfld._Fld-misc1[2]  THEN as4dict.p__Field._Fld-misc1[2]  = wfld._Fld-misc1[2].
  IF as4dict.p__Field._Fld-misc1[3]  <> wfld._Fld-misc1[3]  THEN as4dict.p__Field._Fld-misc1[3]  = wfld._Fld-misc1[3].
  IF as4dict.p__Field._Fld-misc1[4]  <> wfld._Fld-misc1[4]  THEN as4dict.p__Field._Fld-misc1[4]  = wfld._Fld-misc1[4].
  IF as4dict.p__Field._Fld-misc1[5]  <> wfld._Fld-misc1[5]  THEN as4dict.p__Field._Fld-misc1[5]  = wfld._Fld-misc1[5].
  IF as4dict.p__Field._Fld-misc1[6]  <> wfld._Fld-misc1[6]  THEN as4dict.p__Field._Fld-misc1[6]  = wfld._Fld-misc1[6].
  IF as4dict.p__Field._Fld-misc1[7]  <> wfld._Fld-misc1[7]  THEN as4dict.p__Field._Fld-misc1[7]  = wfld._Fld-misc1[7].
  IF as4dict.p__Field._Fld-misc1[8]  <> wfld._Fld-misc1[8]  THEN as4dict.p__Field._Fld-misc1[8]  = wfld._Fld-misc1[8].
*/
  fldrecid = RECID(as4dict.p__Field). 
  ASSIGN pfldnumber = as4dict.p__field._fld-number
         as4dict.p__File._Fil-misc1[1] = as4dict.p__File._Fil-misc1[1] + 1.
END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "r" THEN DO: /*---------------------------------------------------*/
  IF CAN-FIND(FIRST as4dict.p__Vref
    WHERE as4dict.p__Vref._Ref-Table = as4dict.p__File._File-name
    AND as4dict.p__Vref._Base-Col = as4dict.p__Field._Field-name) THEN
    ierror = 20. /* "Cannot &1 &2 referenced in SQL view" */
  IF CAN-FIND(FIRST as4dict.p__Field WHERE as4dict.p__Field._Field-name = irename
                      AND as4dict.p__Field._File-number = pfilenumber) THEN
    ierror = 7. /* "&2 already exists with name &3" */
  IF ierror > 0 THEN RETURN.
  as4dict.p__Field._Field-name = irename.
  ASSIGN as4dict.p__File._Fil-misc1[1] = as4dict.p__File._Fil-misc1[1] + 1.
END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "d" THEN DO: /*---------------------------------------------------*/
  IF CAN-FIND(FIRST as4dict.p__Vref WHERE as4dict.p__Vref._Ref-Table = as4dict.p__File._File-name
    AND as4dict.p__Vref._Base-Col = as4dict.p__Field._Field-name) THEN
    ierror = 20. /* "Cannot &1 &2 referenced in SQL view" */
  IF ierror > 0 THEN RETURN.

  ASSIGN pfldnumber = as4dict.p__field._fld-number.
  /* This moves the primary index if the field being deleted is */
  /* part of the primary index. */

  FIND FIRST as4dict.p__Idxfd WHERE as4dict.p__Idxfd._Fld-number = pfldnumber
        AND as4dict.p__Idxfd._file-number = pfilenumber
        AND as4dict.p__Idxfd._idx-num = as4dict.p__file._prime-index NO-ERROR.

  IF AVAILABLE (as4dict.p__Idxfd) THEN DO:
     /* Get primary index */
     FIND as4dict.p__Index 
         WHERE as4dict.p__Index._file-number = as4dict.p__idxfd._file-number
           AND as4dict.p__Index._idx-num = as4dict.p__idxfd._idx-num 
           AND as4dict.p__Index._idx-num = as4dict.p__file._prime-index NO-ERROR.
 
     IF AVAILABLE (as4dict.p__index) THEN DO: 
        New_primary = FALSE.
        RUN Swap_Primary (OUTPUT New_primary).
     END.  /* If prime index available */
  END.  /* If field is part of index */

  IF ierror > 0 THEN RETURN.

  /* The following is a sneaky way to delete all index-field records */
  /* associated with a given field, using only one index cursor. */
  FIND FIRST as4dict.p__Idxfd WHERE as4dict.p__Idxfd._Fld-number = as4dict.p__Field._Fld-number 
         AND as4dict.p__idxfd._file-number = pfilenumber NO-ERROR.
  DO WHILE AVAILABLE as4dict.p__Idxfd:
    FIND as4dict.p__index WHERE as4dict.p__index._idx-num = as4dict.p__idxfd._idx-num
           AND as4dict.p__index._file-number = as4dict.p__idxfd._file-number.
    FOR EACH as4dict.p__idxfd WHERE as4dict.p__idxfd._idx-num = as4dict.p__index._idx-num AND
           as4dict.p__idxfd._file-number = as4dict.p__index._file-number:
       DELETE as4dict.p__Idxfd. 
    END.
    /* If the index is deleted, we need to delete the corresponding object */
    dba_cmd = "DLTOBJ".
    IF NOT new_primary THEN DO:
       RUN as4dict/_dbaocmd.p 
	  (INPUT "LF", 
	   INPUT as4dict.p__Index._AS4-File,
      	   INPUT as4dict.p__Index._AS4-Library,
	   INPUT as4dict.p__File._File-number,
	   INPUT as4dict.p__Index._Idx-Num).
       IF dba_return <> 1 THEN DO:
           RUN as4dict/_dbamsgs.p.
           ierror = 23. /* default error to general table attr error */              
         RETURN.
       END.
    END. /* not new_primary */
    kindexcache = kindexcache + "," + as4dict.p__Index._Index-name.          

    /* Needed to assign p__file information for re-organizing index numbers */
    ASSIGN as4dict.p__File._numkey = (as4dict.p__file._numkey - 1)
           as4dict.p__file._fil-Res1[1] = as4dict.p__file._Fil-Res1[1] + 1.
    
     IF as4dict.p__Index._Idx-num < as4dict.p__File._Fil-Res1[3] OR
        as4dict.p__file._Fil-Res1[3] = 0 then
           assign as4dict.p__file._Fil-Res1[3] =  as4dict.p__Index._Idx-num.  

    DELETE as4dict.p__Index.
    ASSIGN as4dict.p__File._numkey = (as4dict.p__file._numkey - 1).
    FIND FIRST as4dict.p__Idxfd WHERE as4dict.p__Idxfd._Fld-number = as4dict.p__Field._Fld-number 
           AND as4dict.p__idxfd._file-number = pfilenumber NO-ERROR.
  END.

  /* and remove associated triggers */
  FOR EACH as4dict.p__Trgfd WHERE as4dict.p__Trgfd._Fld-number = pfldnumber
      AND as4dict.p__Trgfd._file-number = pfilenumber:
    DELETE as4dict.p__Trgfd.
  END.
  /* Check if field has extents and delete AS/400 generated fields */
   IF as4dict.p__field._Extent > 0 THEN DO:
     FOR EACH As4_Field WHERE As4_Field._File-Number = pfilenumber
              AND   As4_Field._Fld-Misc1[7] = as4dict.p__field._order:
          Delete As4_field.
     END.                                  
   END.
  /* Check if field is cstring field - delete As/400 generated field */
  IF as4dict.p__field._fld-stdtype = 41 THEN DO:
     FIND As4_Field WHERE As4_Field._File-Number = pfilenumber 
               AND As4_field._Fld-stoff = As4dict.p__field._For-Xpos NO-ERROR.
     IF AVAILABLE (As4_field) THEN Delete As4_field.
    END.                 

  DELETE as4dict.p__Field.
  Assign as4dict.p__file._numfld = as4dict.p__file._numfld - 1
         as4dict.p__File._Fil-misc1[1] = as4dict.p__File._Fil-misc1[1] + 1.

END. /*---------------------------------------------------------------------*/

/* update triggers */
IF imod = "a" OR imod = "m" THEN DO:            
  scrap = "".
  FOR EACH wflt:
    IF wflt._Proc-name = "!" THEN DO:
      DELETE wflt. /* triggers are deleted via .df when proc-name set to "!" */
      NEXT.
    END.
    FIND as4dict.p__Trgfd WHERE as4dict.p__Trgfd._Event = CAPS(wflt._Event) 
               AND as4dict.p__Trgfd._Fld-number = as4dict.p__Field._Fld-number
               AND as4dict.p__Trgfd._file-number = as4dict.p__Field._file-number NO-ERROR.
    FIND as4dict.p__field WHERE as4dict.p__field._file-number = pfilenumber
        AND as4dict.p__field._fld-number = pfldnumber.
    IF AVAILABLE as4dict.p__Trgfd
      AND as4dict.p__Trgfd._Event     = CAPS(wflt._Event)
      AND as4dict.p__Trgfd._Override  = wflt._Override
      AND as4dict.p__Trgfd._Proc-name = wflt._Proc-name 
      AND as4dict.p__Trgfd._Trig-CRC  = wflt._Trig-CRC THEN NEXT.
    IF AVAILABLE as4dict.p__Trgfd THEN DELETE as4dict.p__Trgfd.
    CREATE as4dict.p__Trgfd.
    ASSIGN
      as4dict.p__Trgfd._File-number = pfilenumber
      as4dict.p__Trgfd._Fld-number  = pfldnumber
      as4dict.p__Trgfd._Event       = CAPS(wflt._Event)
      as4dict.p__Trgfd._Override    = wflt._Override
      as4dict.p__Trgfd._Proc-Name   = wflt._Proc-Name
      as4dict.p__Trgfd._Trig-CRC    = (IF wflt._Trig-CRC = ? THEN 0 ELSE wflt._Trig-CRC)
      scrap = scrap + (IF scrap = "" THEN "" ELSE ",") + CAPS(wflt._Event).
  END.
  FOR EACH as4dict.p__Trgfd WHERE as4dict.p__Trgfd._Fld-number = pfldnumber
                  AND as4dict.p__Trgfd._File-number = pfilenumber
                  AND NOT CAN-DO(scrap,as4dict.p__Trgfd._Event):
    DELETE as4dict.p__Trgfd.
  END.
  ASSIGN as4dict.p__File._Fil-misc1[1] = as4dict.p__File._Fil-misc1[1] + 1.
END.

RETURN.


PROCEDURE bump_sub.
  DEFINE INPUT  PARAMETER norder AS INTEGER NO-UNDO.

  DEFINE BUFFER uField FOR as4dict.p__Field.
  DEFINE VARIABLE i AS INTEGER NO-UNDO.
  DEFINE VARIABLE j AS INTEGER NO-UNDO.

  FIND uField WHERE uField._File-number = as4dict.p__File._File-number
                AND uField._Order = norder NO-ERROR.
  IF NOT AVAILABLE uField THEN RETURN.

  DO i = norder + 1 TO i + 1:
    FIND uField  WHERE uField._File-number = as4dict.p__File._File-number
                   AND uField._Order = i NO-ERROR.
    IF NOT AVAILABLE uField THEN LEAVE.
  END.

  DO j = i - 1 TO norder BY -1:
    FIND uField WHERE uField._File-number = as4dict.p__File._File-number
                AND uField._Order = j.
    uField._Order = uField._Order + 1.
  END.

END PROCEDURE.

PROCEDURE getcharlength.
  define var left_paren as integer.
  define var right_paren as integer.
  define var i as integer.
  define var nbrchar as integer. 
          
  ASSIGN lngth = LENGTH(wfld._Format, "character").  
           
  if index(wfld._Format, "(") > 1 THEN DO:
    ASSIGN left_paren = INDEX(wfld._Format, "(")
           right_paren = INDEX(wfld._Format, ")")
           lngth = right_paren - (left_paren + 1).
    ASSIGN lngth =  INTEGER(SUBSTRING(wfld._Format, left_paren + 1, lngth)).  
  END.  
  ELSE DO:           
    DO i = 1 to lngth:        
      IF SUBSTRING(wfld._Format,i,1) = "9" OR
         SUBSTRING(wfld._Format,i,1) = "N" OR   
         SUBSTRING(wfld._Format,i,1) = "A" OR    
         SUBSTRING(wfld._Format,i,1) = "x" OR
         SUBSTRING(wfld._Format,i,1) = "!"   THEN
            ASSIGN nbrchar = nbrchar + 1.
    END.         
  END.
  IF nbrchar > 0 THEN
    ASSIGN lngth = nbrchar
           wfld._fld-stlen = lngth.
  ELSE
      ASSIGN wfld._fld-stlen = lngth.    
      
  IF as4dict.p__Field._Fld-misc1[6] = 1 THEN
    RUN setlength.
END. /* When Dtype character */           

PROCEDURE setlength.
    
  IF wfld._fld-stlen > as4dict.p__Field._Fld-stlen THEN 
    ASSIGN wfld._For-maxsize = wfld._Fld-stlen + 2.
END.

