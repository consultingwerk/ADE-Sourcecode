/*********************************************************************
* Copyright (C) 2008 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* pro_fld - field editor for Progress files */

/*
dfields is NOT AVAILABLE to create, otherwise contains record to
UPDATE.

When you come into this routine, the field name is already set on the
form.
*/

/* Modification History:
     D. McMann 03/31/98 Added display of _Field-rpos
     DLM       07/13/98 Added _Owner to _File Find
     DLM       11/16/98 Added missed _Owner for pick list
     Mario B.  11/16/98 Added trigger to check for duplicate order numbers
     DLM       05/28/03 Changed HELP text for valid data types 20030528-050
     DLM       07/28/03 Added support for new data types
     DLM       07/29/03 Added value-change of area and caps for size
     DLM       08/12/03 Added logic for prompt for field name with clob and blobs.
     DLM       08/22/03 Increased size of format field to accomidate datetime-tz largest
                        format
     DLM       08/28/03 Changed size limits for Blob and Clobs
     DLM       09/03/03 Changed format of lob-size 20030829-039
     DLM       09/18/03 Changed DESC field to be an editor widget 20030610-041
     DLM       10/21/03 Removed "WHEN COPIED" from display of inindex.
     DLM       10/21/03 Remove UCS2 from code page selection list
     KSM       03/02/05 Removed extra commas in arealist 20050223-091
     KSM       03/04/05 Added (- 1) to Gigabyte calculation for 
                        Max-Size 20050223-001 
     KSM       03/07/05 Added validation to Max-Size field for LOBs
                        20050223-002
    fernando   05/24/06 int64 support - initial value                        
    fernando   06/08/06 int64 support - type change
    fernando   08/10/06 Handle too many tables in db - 20060717-022
    fernando   06/26/08 Filter out schema tables for encryption
*/     

DEFINE INPUT  PARAMETER ronly   AS CHARACTER             NO-UNDO.
DEFINE INPUT  PARAMETER junk2   AS RECID                 NO-UNDO.
DEFINE OUTPUT PARAMETER changed AS LOGICAL INITIAL FALSE NO-UNDO.

DEFINE SHARED BUFFER dfields FOR dictdb._Field.

DEFINE VARIABLE answer    AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE c         AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE copied    AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE i         AS INTEGER                   NO-UNDO.
DEFINE VARIABLE inindex   AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE inother   AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE inview    AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE j         AS INTEGER                   NO-UNDO.
DEFINE VARIABLE neworder  AS INTEGER                   NO-UNDO.
DEFINE VARIABLE lobarea  AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE arealist  AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE areaname  AS CHARACTER INITIAL ?       NO-UNDO.
DEFINE VARIABLE areaMtText AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cpname    AS CHARACTER INITIAL ?       NO-UNDO.
DEFINE VARIABLE cplist    AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE colname   AS CHARACTER INITIAL ?       NO-UNDO.
DEFINE VARIABLE collist   AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE lob-size  AS CHARACTER FORMAT "x(10)" INITIAL "100M" NO-UNDO.
DEFINE VARIABLE size-type AS CHARACTER FORMAT "x"      NO-UNDO.
DEFINE VARIABLE wdth      AS DECIMAL                   NO-UNDO.
DEFINE VARIABLE hldcp     AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE allow_type_change AS LOGICAL           NO-UNDO INIT NO.
DEFINE VARIABLE s_Dtype    AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE s_Initial  AS CHARACTER                 NO-UNDO.
define variable lNoArea    as logical no-undo.
define variable hLabel     as handle no-undo.
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userpik.i NEW }
{ prodict/pro/fldfuncs.i }
{ prodict/pro/arealabel.i }
/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 12 NO-UNDO INITIAL [
  /* 1*/ "This field is used in a View or Index - cannot delete.",
  /* 2*/ "This field is used in a View - cannot rename.",
  /* 3*/ "This name is already used by a different field in this file",
  /* 4*/ "There is a field in these tables", /* make sure 4..6 fit in the */
  /* 5*/ "with the same name, pick one to", /* frame format 'x(31)'      */
  /* 6*/ ?, /*see below*/                   /* frame name 'frm_top'      */
  /* 7*/ "You must enter a field name here",
  /* 8*/ "create new field",
  /* 9*/ "Attempt to add with same name as existing field - switching to MODIFY",
  /*10*/ "You can only change an integer field to int64",
  /*11*/ "Invalid data type for a pre-10.1B database",
  /*12*/ "Initial Value has value too large for field type"
].
new_lang[6] = "copy, or press [" + KBLABEL("END-ERROR") + "].".

FORM
  dfields._Field-name LABEL "  Field-Name" FORMAT "x(32)"
    VALIDATE(KEYWORD(dfields._Field-name) = ?,
      "This name conflicts with a {&PRO_DISPLAY_NAME} reserved keyword.") SPACE
  dfields._Data-type  LABEL "   Data-Type" FORMAT "x(11)"  SKIP
  s_Dtype             LABEL "   Data-Type" FORMAT "x(11)"  
                      AT ROW-OF dfields._Data-type COL-OF dfields._Data-type SKIP
  dfields._Format     LABEL "      Format" FORMAT "x(32)" 
  dfields._Extent     LABEL "     Extent" FORMAT ">>>>"  SKIP

  dfields._Label      LABEL "       Label" FORMAT "x(30)" SPACE(3)
  dfields._Decimals   LABEL "    Decimals" FORMAT ">>>>9" SKIP
  
  dfields._Col-label  LABEL "Column-label" FORMAT "x(30)" SPACE(3)
  dfields._Order      LABEL "       Order" FORMAT ">>>>9"  SKIP

  dfields._Initial    LABEL "     Initial" FORMAT "x(30)" SPACE(3)
  s_Initial           LABEL "     Initial" FORMAT "x(30)" 
                      AT ROW-OF dfields._Initial COL-OF dfields._Initial SPACE(3)
  dfields._Mandatory  LABEL "   Mandatory" FORMAT "yes/no" "(Not Null)" SKIP

  inview              LABEL "Component of-> View" inindex LABEL "Index" 
  dfields._Field-rpos LABEL "Position" FORMAT ">>>>9" 
  dfields._Fld-case   LABEL "Case-sensitive" FORMAT "yes/no" SKIP

  dfields._Valexp     LABEL "Valexp"       VIEW-AS EDITOR
                                           INNER-CHARS 63 INNER-LINES 2
                                           BUFFER-LINES 6 SKIP
  dfields._Valmsg     LABEL "Valmsg"       FORMAT "x(63)" SKIP
  dfields._Help       LABEL "  Help"       FORMAT "x(63)" SKIP
  dfields._Desc       LABEL "  Desc"       VIEW-AS EDITOR
                                           INNER-CHARS 63 INNER-LINES 2
                                           BUFFER-LINES 6 SKIP 
  HEADER ""
  WITH FRAME pro_fld NO-BOX ATTR-SPACE OVERLAY SIDE-LABELS
  ROW (SCREEN-LINES - 19) COLUMN 1 SCROLLABLE.

FORM
    dfields._Field-name LABEL "Field Name" COLON 11 FORMAT "x(32)"
      VALIDATE(KEYWORD(dfields._Field-name) = ?,
        "This name conflicts with a {&PRO_DISPLAY_NAME} reserved keyword.") SPACE
    areaname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1 
             LABEL "Area" COLON 11  
    space areaMtText no-label format "x(20)"  skip(1)
    skip(1)
    lob-size LABEL "Max Size" COLON 11 SKIP
    dfields._Order LABEL "Order" COLON 11 SKIP
    dfields._Desc  LABEL "Desc" COLON 11  VIEW-AS EDITOR
                                             INNER-CHARS 58 INNER-LINES 3
                                             BUFFER-LINES 6 SKIP 
    WITH FRAME pro-blob VIEW-AS DIALOG-BOX
    SIDE-LABELS ROW 2 COLUMN 5 
    TITLE "Blob Field Attributes".

FORM
    dfields._Field-name LABEL "Field Name" COLON 11 FORMAT "x(32)"
    VALIDATE(KEYWORD(dfields._Field-name) = ?,
      "This name conflicts with a {&PRO_DISPLAY_NAME} reserved keyword.") SKIP
    areaname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1 
             LABEL "Area" COLON 11  
    space areaMtText no-label format "x(20)"  skip(1)
    lob-size LABEL "Max Size" COLON 11 SKIP
    dfields._Order LABEL "  Order" COLON 11 SKIP
    dfields._Desc  LABEL "Desc" COLON 11  VIEW-AS EDITOR
                                             INNER-CHARS 58 INNER-LINES 3
                                             BUFFER-LINES 6 SKIP 
    WITH FRAME mod-blob VIEW-AS DIALOG-BOX
    SIDE-LABELS ROW 2 COLUMN 5 
    TITLE "Blob Field Attributes".

FORM
    dfields._Field-name LABEL "Field Name" COLON 15 FORMAT "x(32)"
    areaname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1 
             LABEL "Area" COLON 15 
    space areaMtText no-label format "x(20)"  skip(1)
    lob-size LABEL "Max Size" COLON 15 SKIP
    dfields._Order LABEL "Order" COLON 15 SKIP
    dfields._fld-case LABEL "Case Sensitive" COLON 15 SKIP
    cpname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1 SORT
           LABEL "Code Page" COLON 15 SKIP
          
    colname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1 SORT
            LABEL "Collation" COLON 15 SKIP
    
    dfields._Desc LABEL "Desc" COLON 15  VIEW-AS EDITOR
                                             INNER-CHARS 58 INNER-LINES 3
                                             BUFFER-LINES 6 SKIP 
    WITH FRAME pro-clob VIEW-AS DIALOG-BOX
    SIDE-LABELS ROW 2 CENTERED 
    TITLE "Clob Field Attributes".

FORM
    dfields._Field-name LABEL "Field name" COLON 15 FORMAT "x(32)"
    VALIDATE(KEYWORD(dfields._Field-name) = ?,
      "This name conflicts with a {&PRO_DISPLAY_NAME} reserved keyword.") SKIP
    areaname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1 
             LABEL "Area" COLON 15 
    space areaMtText no-label format "x(20)"  skip(1)
    lob-size LABEL "Max Size" COLON 15 SKIP
    dfields._Order LABEL "Order" COLON 15 SKIP
    dfields._fld-case LABEL "Case Sensitive" COLON 15 SKIP
    cpname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1
           LABEL "Code Page" COLON 15 SKIP
  
    colname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1
            LABEL "Collation" COLON 15 SKIP
   
    dfields._Desc LABEL "Desc" COLON 15 VIEW-AS EDITOR
                                             INNER-CHARS 58 INNER-LINES 3
                                             BUFFER-LINES 6 SKIP 
    WITH FRAME mod-clob VIEW-AS DIALOG-BOX
    SIDE-LABELS ROW 2 CENTERED 
    TITLE "Clob Field Attributes".

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

FORM
  new_lang[4] FORMAT "x(37)" SKIP
  new_lang[5] FORMAT "x(37)" SKIP
  new_lang[6] FORMAT "x(37)" SKIP
  WITH FRAME frm_top OVERLAY NO-ATTR-SPACE NO-LABELS
  ROW pik_row - 5 COLUMN pik_column.

/* ---------------Internal Procedures--------------------------------*/
PROCEDURE set-code-page:
  DEFINE VARIABLE all-cp AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE i      AS INTEGER          NO-UNDO.

  ASSIGN all-cp = GET-CODEPAGES.
 
  DO i = 1 TO NUM-ENTRIES(all-cp):
    IF i = 1 THEN
      ASSIGN cplist = ENTRY(i,all-cp).
    ELSE DO:
      IF ENTRY(i,all-cp) <> "undefined" AND ENTRY(i,all-cp) <> "UCS2" THEN
        ASSIGN cplist = cplist + "," + ENTRY(i,all-cp).
    END.
  END.
  RETURN.
END PROCEDURE.

/* ---------------Triggers------------------------------------------*/
ON GO OF FRAME pro-blob DO:
  IF NEW dfields THEN DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:  
    IF wdth = ? OR wdth = 0  THEN
      APPLY "leave" TO lob-size IN FRAME pro-blob.
    
    if not lNoArea then
    do:
        IF areaname:SCREEN-VALUE IN FRAME pro-blob <> ? THEN
            ASSIGN lobarea = areaname:SCREEN-VALUE IN FRAME pro-blob.
        FIND DICTDB._Area WHERE DICTDB._Area._Area-name =  lobarea NO-LOCK.          
        dfields._Fld-stlen = DICTDB._Area._Area-number.           
    end.  
        
    ASSIGN dfields._Format = "x(8)"
           dfields._Fld-Misc2[1] = CAPS(lob-size:SCREEN-VALUE) 
           dfields._Width = wdth
           dfields._Initial = ?
           dfields._Order = INTEGER(dfields._Order:SCREEN-VALUE)        
           dfields._Field-name = dfields._Field-name:SCREEN-VALUE IN FRAME /*pro_fld*/ pro-blob
           dfields._Desc = dfields._Desc:SCREEN-VALUE
           areaname = ?
           wdth = ?.

  END.  
END.

ON GO OF FRAME mod-blob DO:
  IF lob-size ENTERED THEN
      APPLY "leave" TO lob-size IN FRAME mod-blob.

  ASSIGN dfields._Fld-Misc2[1] = CAPS(lob-size)
         dfields._Width = wdth
         dfields._Order = INTEGER(dfields._Order:SCREEN-VALUE)        
         dfields._Desc = dfields._Desc:SCREEN-VALUE
         dfields._Field-name = dfields._Field-name:SCREEN-VALUE.
    ASSIGN changed = TRUE.
END.

ON GO OF FRAME pro-clob DO:

  FIND DICTDB._DB WHERE RECID(DICTDB._DB) = drec_db NO-LOCK.
  IF NEW dfields THEN DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:  
    IF wdth = ? OR wdth = 0  THEN
      APPLY "leave" TO lob-size IN FRAME pro-clob.

    IF lobarea = ? AND lNoArea = FALSE THEN
      APPLY "value-changed" TO areaname IN FRAME pro-clob.

    IF cpname:SCREEN-VALUE IN FRAME pro-clob <> "*Use DB Code Page" AND
       (colname:SCREEN-VALUE IN FRAME pro-clob = "*Use DB Collation" OR
        colname:SCREEN-VALUE IN FRAME pro-clob = ?) THEN DO:

       APPLY "leave" TO cpname IN FRAME pro-clob.
       MESSAGE "You must select a collation for the selected code page"
                VIEW-AS ALERT-BOX ERROR.
       NEXT-PROMPT colname.
       RETURN NO-APPLY.
    END.
      
    IF cpname:SCREEN-VALUE IN FRAME pro-clob = "*Use DB Code Page" AND DICTDB._Db._Db-xl-name = "undefined" THEN DO:
      MESSAGE "The database code page is 'undefined' " SKIP
              "A clob cannot be defined with this code page." SKIP(1)
              "Select a code page other than '*Use DB Code Page'." SKIP
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
    END.
    if lNoArea = false then
    do:
        FIND DICTDB._Area WHERE DICTDB._Area._Area-name =  lobarea NO-LOCK.    
        ASSIGN dfields._Fld-stlen = DICTDB._Area._Area-number.
    end.
    else
        assign dfields._Fld-stlen = 0.
        
    assign dfields._Format = "x(8)"
           dfields._Fld-Misc2[1] = CAPS(lob-size:SCREEN-VALUE IN FRAME pro-clob)
           dfields._Width = wdth
           dfields._Initial = ?
           dfields._Order = INTEGER(dfields._Order:SCREEN-VALUE IN FRAME pro-clob) 
           dfields._Fld-case = LOGICAL(dfields._Fld-case:SCREEN-VALUE IN FRAME pro-clob)
           dfields._Desc = dfields._Desc:SCREEN-VALUE
           dfields._Field-name = dfields._Field-name:SCREEN-VALUE IN FRAME pro-clob /*pro_fld*/
           areaname = ?
           wdth = ?
           cpname = ?
           colname = ?.

    IF cpname:SCREEN-VALUE <> "*Use DB Code Page" THEN
      ASSIGN dFields._Charset = INPUT FRAME pro-clob cpname:SCREEN-VALUE
             dFields._Collation = INPUT FRAME pro-clob colname:SCREEN-VALUE
             dFields._Attributes1 = 2.                                      
    ELSE
      ASSIGN dFields._Charset = _Db._Db-xl-name
             dFields._Collation = _Db._Db-coll-name
            dFields._Attributes1 = 1. 
   
  END.  
END.

ON GO OF FRAME mod-clob DO:
  IF lob-size ENTERED THEN
      APPLY "leave" TO lob-size IN FRAME mod-clob.

  ASSIGN dfields._Fld-Misc2[1] = CAPS(lob-size)
         dfields._Width = wdth
         INPUT FRAME mod-clob dfields._Order    
         INPUT FRAME mod-clob dfields._Fld-case
         INPUT FRAME mod-clob dfields._Desc
         INPUT FRAME mod-clob dfields._Field-name.
    ASSIGN changed = TRUE.
END.

ON value-changed OF areaname IN FRAME pro-blob DO:
  ASSIGN lobarea = areaname:SCREEN-VALUE.
  RETURN.
END.

ON value-changed OF areaname IN FRAME pro-clob DO:
  ASSIGN lobarea = areaname:SCREEN-VALUE.
  RETURN.
END.

ON LEAVE OF lob-size IN FRAME pro-blob,
            lob-size IN FRAME mod-blob DO:
  IF NEW dfields THEN 
    ASSIGN lob-size = CAPS(lob-size:SCREEN-VALUE IN FRAME pro-blob).
  ELSE
    ASSIGN lob-size = CAPS(lob-size:SCREEN-VALUE IN FRAME mod-blob).

  /* If the first character is not numeric then return an error
     and reset to the original, or default, value. */
  IF NOT isNumeric(SUBSTRING(lob-size,1,1)) THEN DO:
    MESSAGE "Blob field size must begin with a numeric character!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    IF NEW dfields THEN
      lob-size:SCREEN-VALUE IN FRAME pro-blob = "100M".
    ELSE
      lob-size:SCREEN-VALUE IN FRAME mod-blob = dfields._Fld-Misc2[1].
    RETURN NO-APPLY.
  END.
  /* Check to see if the user specified an invalid format to the input.
     For instance, they can't begin with an alpha char, they can't
     use invalid alpha chars and, once they've specified a valid char,
     no other values are valid. */
  ELSE IF badFormat("BLOB","lob-size",lob-size) THEN DO:
    MESSAGE "Blob field size contains invalid characters!" SKIP(1)
            "Please enter a numeric value followed by one of" SKIP
            "the following alphabetic values:" SKIP(1) 
            "      B = Bytes    " SKIP
            "K or KB = Kilobytes" SKIP
            "M or MB = Megabytes" SKIP
            "G or GB = Gigabytes" SKIP
       VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    IF NEW dfields THEN
      lob-size:SCREEN-VALUE IN FRAME pro-blob = "100M".
    ELSE
      lob-size:SCREEN-VALUE IN FRAME mod-blob = dfields._Fld-Misc2[1].
    RETURN NO-APPLY.
  END.
  IF INDEX(lob-size, "K") <> 0 THEN
    ASSIGN size-type = "K".
  ELSE IF INDEX(lob-size, "M") <> 0 THEN
    ASSIGN size-type = "M".
  ELSE IF INDEX(lob-size, "G") <> 0 THEN
    ASSIGN size-type = "G".
  ELSE IF INDEX(lob-size, "B") <> 0 THEN
    ASSIGN size-type = "B".
  ELSE IF 
      INDEX("ACDEFHIJLNOPQRSTUVWXYZ", 
            SUBSTRING(lob-size, LENGTH(lob-size), 1)) <> 0 THEN DO:
    MESSAGE "Size of blob must be expressed as #B, #K, #M, or #G"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    IF NEW dfields THEN
      lob-size:SCREEN-VALUE IN FRAME pro-blob = "100M".
    ELSE
      lob-size:SCREEN-VALUE IN FRAME mod-blob = dfields._Fld-Misc2[1].
    RETURN NO-APPLY.
  END.    
  ELSE DO:
    ASSIGN size-type = "B"
           lob-size = lob-size + "B".
    IF NEW dfields THEN
       lob-size:SCREEN-VALUE IN FRAME pro-blob = lob-size.
    ELSE
       lob-size:SCREEN-VALUE IN FRAME mod-blob = lob-size.
  END.

  CASE size-type:
    WHEN "K" THEN DO:
        ASSIGN wdth = 
            INTEGER(TRIM(SUBSTRING(lob-size, 1, (INDEX(lob-size, "K") - 1)))).
        ASSIGN wdth = (wdth * 1024).
    END.
    WHEN "M" THEN DO:
        ASSIGN wdth = 
            INTEGER(TRIM(SUBSTRING(lob-size, 1, (INDEX(lob-size, "M") - 1)))).
        ASSIGN wdth = (wdth * (1024 * 1024)).
    END.
    WHEN "G" THEN
        ASSIGN wdth = 
            INTEGER(TRIM(SUBSTRING(lob-size, 1, (INDEX(lob-size, "G") - 1))))
               wdth = (wdth * (1024 * 1024 * 1024) - 1 ).
    OTHERWISE
        ASSIGN wdth = 
            INTEGER(TRIM(SUBSTRING(lob-size, 1, (INDEX(lob-size, "B") - 1)))). 
  END CASE.

  IF wdth < 1 OR wdth > 1073741823 THEN DO:
    MESSAGE "Size of Blob must be between 1B and 1G" SKIP
                "The default value is 100M" SKIP
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        /* Set size to default 1Mb */
     IF NEW dfields THEN
       lob-size:SCREEN-VALUE IN FRAME pro-blob = "100M".
     ELSE
       lob-size:SCREEN-VALUE IN FRAME mod-blob = dfields._Fld-Misc2[1].
    RETURN NO-APPLY.
  END.
END.

ON LEAVE OF dfields._Order IN FRAME pro-blob DO:
  IF CAN-FIND(FIRST dictdb._Field WHERE dictdb._Field._File-recid = drec_file 
              AND dictdb._Field._Order = INPUT dfields._Order 
              AND dictdb._Field._Order <> dfields._Order) THEN DO:
            MESSAGE "Order number" TRIM(INPUT dfields._Order) "already exists." 
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /* set order number back to its current value */
            dfields._Order:SCREEN-VALUE = STRING(neworder).
         RETURN NO-APPLY.
  END.
END.

ON LEAVE OF dfields._Order IN FRAME mod-blob DO:
  IF CAN-FIND(FIRST dictdb._Field WHERE dictdb._Field._File-recid = drec_file 
              AND dictdb._Field._Order = INPUT dfields._Order 
              AND dictdb._Field._Order <> dfields._Order) THEN DO:
            
      MESSAGE "Order number" TRIM(INPUT dfields._Order) "already exists." 
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /* set order number back to its current value */
            dfields._Order:SCREEN-VALUE = STRING(neworder).
         RETURN NO-APPLY.
  END.
END.

ON LEAVE OF dfields._Initial IN FRAME pro_fld,
            s_Initial IN FRAME pro_fld
DO:
    IF dfields._Data-type = "INT64" OR 
	( allow_type_change AND INPUT FRAME pro_fld s_Dtype = "INT64") THEN DO:
       IF DECIMAL(SELF:SCREEN-VALUE) > 9223372036854775807 OR 
          DECIMAL(SELF:SCREEN-VALUE) < -9223372036854775808 THEN DO:
           MESSAGE new_lang[12].
           RETURN NO-APPLY.
       END.
    END.
    ELSE IF dfields._Data-type = "INTEGER" THEN DO:
       IF DECIMAL(SELF:SCREEN-VALUE) > 2147483647 OR 
          DECIMAL(SELF:SCREEN-VALUE) < -2147483648 THEN DO:
           MESSAGE new_lang[12].
           RETURN NO-APPLY.
       END.
    END.

END.

ON LEAVE OF lob-size IN FRAME pro-clob,
            lob-size IN FRAME mod-clob
DO:
  IF NEW dfields THEN
    ASSIGN lob-size = CAPS(lob-size:SCREEN-VALUE IN FRAME pro-clob).
  ELSE
    ASSIGN lob-size = CAPS(lob-size:SCREEN-VALUE IN FRAME mod-clob).

  /* If the first character is not numeric then return an error
     and reset to the original, or default, value. */
  IF NOT isNumeric(SUBSTRING(lob-size,1,1)) THEN DO:
    MESSAGE "Blob field size must begin with a numeric character!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    IF NEW dfields THEN
      lob-size:SCREEN-VALUE IN FRAME pro-clob = "100M".
    ELSE
      lob-size:SCREEN-VALUE IN FRAME mod-blob = dfields._Fld-Misc2[1].
    RETURN NO-APPLY.
  END.
  /* Check to see if the user specified an invalid format to the input.
     For instance, they can't begin with an alpha char, they can't
     use invalid alpha chars and, once they've specified a valid char,
     no other values are valid. */
  IF badFormat("CLOB","lob-size",lob-size) THEN DO:
    MESSAGE "Clob field size contains invalid characters!" SKIP(1)
            "Please enter a numeric value followed by one of" SKIP
            "the following alphabetic values:" SKIP(1)
            "      B = Bytes    " SKIP
            "K or KB = Kilobytes" SKIP
            "M or MB = Megabytes" SKIP
            "G or GB = Gigabytes" SKIP
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    IF NEW dfields THEN
      lob-size:SCREEN-VALUE IN FRAME pro-clob = "100M".
    ELSE
      lob-size:SCREEN-VALUE IN FRAME mod-blob = dfields._Fld-Misc2[1].
    RETURN NO-APPLY.
  END.
  IF INDEX(lob-size, "K") <> 0 THEN
    ASSIGN size-type = "K".
  ELSE IF INDEX(lob-size, "M") <> 0 THEN
    ASSIGN size-type = "M".
  ELSE IF INDEX(lob-size, "G") <> 0 THEN
    ASSIGN size-type = "G".
  ELSE IF INDEX(lob-size, "B") <> 0 THEN
    ASSIGN size-type = "B".
  ELSE IF INDEX("ACDEFHIJLNOPQRSTUVWXYZ", 
                SUBSTRING(lob-size, LENGTH(lob-size), 1)) <> 0 THEN DO:
    MESSAGE "Size of blob must be expressed as #B, #K, #M, or #G"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    IF NEW dfields THEN
      lob-size:SCREEN-VALUE IN FRAME pro-clob = "100M".
    ELSE
      lob-size:SCREEN-VALUE IN FRAME mod-clob = dfields._Fld-Misc2[1].
    RETURN NO-APPLY.
  END.    
  ELSE DO:
    ASSIGN size-type = "B"
           lob-size = lob-size + "B".
    IF NEW dfields THEN
       lob-size:SCREEN-VALUE IN FRAME pro-clob = lob-size.
    ELSE
       lob-size:SCREEN-VALUE IN FRAME mod-clob = lob-size.
  END.

  CASE size-type:
    WHEN "K" THEN DO:
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(lob-size, 1, 
                                             (INDEX(lob-size, "K") - 1)))).
        ASSIGN wdth = (wdth * 1024).
    END.
    WHEN "M" THEN DO:
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(lob-size, 1, 
                                             (INDEX(lob-size, "M") - 1)))).
        ASSIGN wdth = (wdth * (1024 * 1024)).
    END.
    WHEN "G" THEN
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(lob-size, 1, 
                                             (INDEX(lob-size, "G") - 1))))
               wdth = (wdth * (1024 * 1024 * 1024) - 1).
    OTHERWISE
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(lob-size, 1, 
                                             (INDEX(lob-size, "B") - 1)))). 
  END CASE.

  IF wdth < 1 OR wdth > 1073741823 THEN DO:
    MESSAGE "Size of Blob must be between 1B and 1G" SKIP
                "The default value is 100M" SKIP
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        /* Set size to default 1Mb */
     IF NEW dfields THEN
       lob-size:SCREEN-VALUE IN FRAME pro-clob = "100M".
     ELSE
       lob-size:SCREEN-VALUE IN FRAME mod-clob = dfields._Fld-Misc2[1].
    RETURN NO-APPLY.
  END.
END.

ON LEAVE OF cpname IN FRAME pro-clob DO:
 /* ASSIGN colname:LIST-ITEMS IN FRAME pro-clob = "".*/
  IF cpname:SCREEN-VALUE <> "*Use DB Code Page" THEN DO:
    ASSIGN hldcp = GET-COLLATIONS(cpname:SCREEN-VALUE)
           cpname = cpname:SCREEN-VALUE.
        
    DO i = 1 TO NUM-ENTRIES(hldcp):
      IF i = 1 THEN
        ASSIGN collist = ENTRY(i, hldcp)
               colname = collist
               colname:SCREEN-VALUE IN FRAME pro-clob = collist.
      ELSE
        ASSIGN collist = collist + "," + ENTRY(i, hldcp).

    END.
    ASSIGN colname:LIST-ITEMS IN FRAME pro-clob = collist.
  END.
  ELSE DO:
    RUN set-code-page.
    ASSIGN cplist = "*Use DB Code page" + "," + cplist
           collist = "*Use DB Collation"
           cpname:LIST-ITEMS IN FRAME pro-clob = cplist
           colname:LIST-ITEMS IN FRAME pro-clob = collist
           cpname:SCREEN-VALUE = "*Use DB Code page"
           colname:SCREEN-VALUE = "*Use DB Collation".
     
  END.
  RETURN.
END.

ON LEAVE OF s_Dtype IN FRAME pro_fld  DO:
    DEFINE VAR cValue AS CHAR.
    IF NOT NEW dfields THEN DO:
        cValue = INPUT FRAME pro_fld s_Dtype.

        IF cValue NE "int" AND cValue NE "integer"
            AND cValue NE "int64" THEN DO:
            MESSAGE new_lang[10].
            RETURN NO-APPLY.
        END.
    END.
END.

IF NOT AVAILABLE dfields THEN DO:
  CLEAR FRAME pro_fld NO-PAUSE.
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    PROMPT-FOR _Field-name WITH FRAME pro_fld.
    IF INPUT FRAME pro_fld _Field-name = "" THEN DO:
      MESSAGE new_lang[7]. /* nothing entered! */
      UNDO,RETRY.
    END.
  END.
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN DO:
    HIDE FRAME pro_fld NO-PAUSE.
    RETURN.
  END.
  FIND FIRST dfields WHERE dfields._File-recid = drec_file
    AND dfields._field-name = INPUT FRAME pro_fld _Field-name NO-ERROR.
  IF AVAILABLE dfields THEN MESSAGE new_lang[9].
END.

copied = FALSE.
IF AVAILABLE dfields THEN DO: /*---------------------------------------------*/
  ASSIGN
    inindex    = CAN-FIND(FIRST dictdb._Index-field 
                          where dictdb._Index-field._Field-recid = recid(dfields))
    inview     = CAN-FIND(FIRST dictdb._View-ref
                 WHERE dictdb._View-ref._Ref-Table = user_filename
                   AND dictdb._View-ref._Base-Col = dfields._Field-name)
    neworder   = dfields._Order
    wdth       = 0.
  
END. /*---------------------------------------------------------------------*/
ELSE DO: /*-----------------------------------------------------------------*/
  FIND LAST dictdb._Field USE-INDEX _Field-Position
    WHERE dictdb._Field._File-recid = drec_file NO-ERROR.
  ASSIGN
    inindex    = FALSE
    inview     = FALSE
    inother    = CAN-FIND(FIRST dictdb._Field 
                          WHERE dictdb._Field._Field-name = INPUT FRAME pro_fld dfields._Field-name)
    neworder   = (IF AVAILABLE _Field THEN dictdb._Field._Order + 10 ELSE 10)
    pik_column = 40
    pik_row    = SCREEN-LINES - 10
    pik_hide   = TRUE
    pik_init   = ""
    pik_title  = ""
    pik_list   = ""
    pik_wide   = FALSE
    pik_multi  = FALSE
    pik_number = FALSE
    pik_count  = 1
    pik_list[1] = "<<" + new_lang[8] + ">>". /* <<create new field>> */

  IF inother THEN DO:
    EMPTY TEMP-TABLE ttpik NO-ERROR.

    IF l_cache_tt THEN DO:
        CREATE ttpik.
        ASSIGN ttpik.i_number = 1
               ttpik.c_name = pik_list[1].
    END.

    FOR EACH dictdb._Field
      WHERE dictdb._Field._Field-name = INPUT FRAME pro_fld dfields._Field-name:
        FOR EACH dictdb._File OF _Field
          WHERE dictdb._File._Db-recid = drec_db AND RECID(dictdb._File) <> drec_file
            AND (dictdb._File._Owner = "PUB" OR dictdb._File._Owner = "_FOREIGN")
          BY dictdb._File._File-name:
          ASSIGN
            pik_count = pik_count + 1.
            /* 20060717-022
               if we have too many tables, need to use temp-table, in case there are
               too many fields with the same name.
            */
            IF l_cache_tt THEN DO:
                CREATE ttpik.
                ASSIGN ttpik.i_number = pik_count
                       ttpik.c_name = _File._File-name.
                RELEASE ttpik.
            END.
            ELSE
                pik_list[pik_count] = _File._File-name.
        END.
    END.

  END.
 
  /* since we can't tell if a field is in another (non-progress)
  schema, we have to wait until we attempt the join above to eliminate
  those candidates.  hence, the following test: */
  IF pik_count <= 1 THEN DO:
      EMPTY TEMP-TABLE ttpik NO-ERROR.
      inother = FALSE.
  END.

  IF inother THEN _in-other: DO:
    PAUSE 0.
    DISPLAY new_lang[4 FOR 3] WITH FRAME frm_top.
    RUN "prodict/user/_usrpick.p".
    HIDE FRAME frm_top NO-PAUSE.
    IF pik_return = 0 OR pik_first BEGINS "<<" THEN LEAVE _in-other.
    FIND dictdb._File WHERE dictdb._File._Db-recid = drec_db AND dictdb._File._File-name = pik_first
                 AND (dictdb._File._Owner = "PUB" OR dictdb._File._Owner = "_FOREIGN" ).
    FIND dictdb._Field OF dictdb._File WHERE dictdb._Field._Field-name =
                                                 INPUT FRAME pro_fld dfields._Field-name.
    ASSIGN
      copied     = TRUE.

    DISPLAY
      dictdb._Field._Field-name @ dfields._Field-name /*match case*/
      dictdb._Field._Data-type  @ dfields._Data-type
      dictdb._Field._Format     @ dfields._Format
      dictdb._Field._Label      @ dfields._Label
      dictdb._Field._Col-label  @ dfields._Col-label
      dictdb._Field._Initial    @ dfields._Initial
      dictdb._Field._Extent     @ dfields._Extent
      dictdb._Field._Decimals   @ dfields._Decimals
      neworder           @ dfields._Order
      dictdb._Field._Mandatory  @ dfields._Mandatory
      dictdb._Field._Fld-case   @ dfields._Fld-case
      dictdb._Field._Field-rpos @ dfields._Field-rpos
      dictdb._Field._Valmsg     @ dfields._Valmsg
      dictdb._Field._Help       @ dfields._Help
            
      WITH FRAME pro_fld.

    /* Can't seem to do @ on a view-as editor widget so: */
    ASSIGN dfields._Valexp:screen-value in frame pro_fld = dictdb._Field._Valexp
           dfields._Desc:SCREEN-VALUE IN FRAME pro_fld = dictdb._Field._Desc.

    EMPTY TEMP-TABLE ttpik NO-ERROR.
  END.
 
  CREATE dfields.
  dfields._File-recid = drec_file.
END. /*---------------------------------------------------------------------*/

DISPLAY inview inindex /* WHEN copied*/ WITH FRAME pro_fld.
 
 
NEXT-PROMPT dfields._Data-type WITH FRAME pro_fld.
IF NEW dfields THEN DO:
  DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    SET
      dfields._Field-name
        VALIDATE(NOT CAN-FIND(dictdb._Field
          WHERE dictdb._Field._File-recid = drec_file
            AND dictdb._Field._Field-name = INPUT dfields._Field-name),
        "")
      dfields._Data-type
        VALIDATE(dfields._Data-type <> ?,"")
      WITH FRAME pro_fld.
    IF dfields._Data-type = ? OR 
        /* don't allow int64 if this is a pre-101b db */
        (is-pre-101b-db AND dfields._Data-type = "int64") THEN DO:
        IF dfields._Data-type = "int64" THEN
           MESSAGE new_lang[11].
        UNDO,RETRY.
    END.
  END.
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN DO:
    IF NEW dfields THEN DELETE dfields.
    HIDE FRAME pro_fld NO-PAUSE.
    RETURN.
  END.
  allow_type_change = NO.
END.
ELSE DO:
    
    /* if this is a pre-101b db, don't allow type change */
    IF dfields._Data-type = "integer" AND NOT is-pre-101b-db THEN
       ASSIGN allow_type_change = YES
              s_Dtype = dfields._Data-type.
END.
 
 
IF NOT copied THEN 
    DISPLAY
        dfields._Field-name /*match case*/
        dfields._Data-type
        dfields._Format
        dfields._Label
        dfields._Col-label
        dfields._Initial
        dfields._Extent
        dfields._Decimals
        neworder @ dfields._Order
        dfields._Mandatory
        dfields._Fld-case
        dfields._Field-rpos
        dfields._Valexp
        dfields._Valmsg
        dfields._Help
        dfields._Desc
    WITH FRAME pro_fld.
 
find dictdb._file where recid(dictdb._file) = drec_file no-lock.
lNoArea = dictdb._file._file-attributes[1] and dictdb._file._file-attributes[2] = false.

/* adjust lable to mid position - this is done to math up with for default tenant,
   but we do it always for consistency */
assign
    hLabel = areaname:side-label-handle in frame pro-blob
    hLabel:row = hLabel:row + 1
    hLabel = areaname:side-label-handle in frame pro-clob
    hLabel:row = hLabel:row + 1
    hLabel = areaname:side-label-handle in frame mod-blob
    hLabel:row = hLabel:row + 1
    hLabel = areaname:side-label-handle in frame mod-clob
    hLabel:row = hLabel:row + 1
   /* Align other selection list labels as well for consistency */   
   
    hLabel = colname:side-label-handle in frame pro-clob
    hLabel:row = hLabel:row + 1
    hLabel = colname:side-label-handle in frame mod-clob
    hLabel:row = hLabel:row + 1
    hLabel = cpname:side-label-handle in frame pro-clob
    hLabel:row = hLabel:row + 1
    hLabel = cpname:side-label-handle in frame mod-clob
    hLabel:row = hLabel:row + 1
    .
  

if dictdb._file._file-attributes[1] and dictdb._file._file-attributes[2] then
do:
    assign
        areaMtText = "(for default tenant)":T20
        areaMtText:row in frame pro-blob = 3
        areaMtText:row in frame pro-clob = 3
        areaMtText:row in frame mod-blob = 3
        areaMtText:row in frame mod-clob = 3
        areaMtText:screen-value in frame pro-blob = areaMtText
        areaMtText:screen-value in frame pro-clob = areaMtText
        areaMtText:screen-value in frame mod-blob = areaMtText
        areaMtText:screen-value in frame mod-clob = areaMtText
        .
end.


/*
setAreaLabel(areaname:handle in FRAME pro-blob,dictdb._File._File-Attributes[1]). 
setAreaLabel(areaname:handle in FRAME pro-clob,dictdb._File._File-Attributes[1]). 
setAreaLabel(areaname:handle in FRAME mod-blob,dictdb._File._File-Attributes[1]). 
setAreaLabel(areaname:handle in FRAME mod-clob,dictdb._File._File-Attributes[1]). 
 */
IF ronly = "r/o" THEN DO:
  IF dfields._Data-type = "BLOB" OR dfields._Data-type = "CLOB" THEN 
  DO:
      if lnoArea then
      do:
          areaname = "".
      end.
      else do:    
          IF dfields._Field-rpos <> ? THEN 
          DO:
              
              FIND dictdb._storageobject WHERE dictdb._Storageobject._Db-recid = drec_db
                                         AND dictdb._Storageobject._Object-type = 3
                                         AND dictdb._Storageobject._Object-number = dfields._Fld-stlen
                                         and dictdb._Storageobject._Partitionid = 0
                                         NO-LOCK.
              FIND dictdb._Area WHERE dictdb._Area._Area-number = dictdb._StorageObject._Area-number NO-LOCK.
          END.
          ELSE
              FIND dictdb._Area WHERE dictdb._Area._Area-number = dfields._Fld-stlen NO-LOCK.
              
          ASSIGN areaname:LIST-ITEMS IN FRAME pro-blob = dictdb._Area._Area-name
                 lob-size = dfields._Fld-Misc2[1].
      end.
      DISPLAY areaname 
              lob-size 
              dfields._Order 
              dfields._Desc 
              dfields._Field-name  WITH FRAME pro-blob. 
     
      IF dfields._Data-type = "CLOB" THEN 
      DO :
          ASSIGN  
                 cpname:LIST-ITEMS IN FRAME pro-clob = dfields._Charset
                 colname:LIST-ITEMS IN FRAME pro-clob = dfields._Collation.
            
          DISPLAY dfields._Fld-case
                  cpname 
                  colname WITH FRAME pro-clob. 
      END.
  END.
  { prodict/user/userpaus.i }
  HIDE FRAME pro_fld NO-PAUSE.
  RETURN.
END.

IF dfields._Data-type = "BLOB" THEN DO:
  IF NEW dfields THEN DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
 
    ASSIGN arealist = ?
           lobarea = ?.
    
    if lnoArea then
    do:
        lobarea = "".
    end.    
    else do:    
        FOR EACH DICTDB._Area WHERE DICTDB._Area._Area-num > 6
                                AND DICTDB._Area._Area-type = 6
                                AND NOT CAN-DO ({&INVALID_AREAS}, DICTDB._Area._Area-name)
                                NO-LOCK. 
          IF CAN-FIND(FIRST DICTDB._File WHERE RECID(DICTDB._File) = drec_file
                                           AND DICTDB._File._ianum = DICTDB._Area._Area-Num) THEN
              ASSIGN lobarea = DICTDB._Area._Area-name.
          IF arealist = ? THEN
            ASSIGN arealist = DICTDB._Area._Area-name.            
          ELSE
            ASSIGN arealist = arealist + "," + DICTDB._Area._Area-name.
        END.
      
        IF NUM-ENTRIES(arealist) = 1 THEN
          ASSIGN arealist = arealist.
        
        FIND DICTDB._Area WHERE DICTDB._Area._Area-number = 6 NO-LOCK.
        
        IF lobarea = ? THEN
          ASSIGN lobarea = DICTDB._Area._Area-name.
    
        IF arealist = ? THEN 
          ASSIGN arealist = DICTDB._Area._Area-name.           
        ELSE
          ASSIGN arealist = arealist + "," + DICTDB._Area._Area-name.
    
        ASSIGN areaname:LIST-ITEMS IN FRAME pro-blob = arealist.
    end.
                  
    DISPLAY areaname  lob-size neworder @ dfields._Order dfields._Desc dfields._Field-name WITH FRAME pro-blob.
    ASSIGN areaname:SCREEN-VALUE = lobarea.
    SET areaname when lNoArea = false lob-size dfields._Order dfields._Desc  dfields._Field-name WITH FRAME pro-blob.    
  
  END.
  ELSE DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    if not lNoArea then
    do:
        IF dfields._Field-rpos <> ? THEN DO:
          FIND dictdb._storageobject WHERE dictdb._Storageobject._Db-recid = drec_db
                                AND dictdb._Storageobject._Object-type = 3
                                AND dictdb._Storageobject._Object-number = dfields._Fld-stlen
                                and dictdb._Storageobject._Partitionid = 0
                               NO-LOCK.
          FIND DICTDB._Area WHERE DICTDB._Area._Area-number = dictdb._StorageObject._Area-number NO-LOCK.
        END.
        ELSE
          FIND DICTDB._Area WHERE DICTDB._Area._Area-number = dfields._Fld-stlen NO-LOCK.
    
        ASSIGN areaname:LIST-ITEMS IN FRAME mod-blob = DICTDB._Area._Area-name
               lob-size = dfields._Fld-Misc2[1]. 
    end.
    DISPLAY  dfields._Field-name areaname lob-size dfields._Order dfields._Desc WITH FRAME mod-blob.
    UPDATE lob-size dfields._Order dfields._Desc dfields._Field-name WITH FRAME mod-blob. 
  END.   
END.
ELSE IF dfields._Data-type = "CLOB" THEN DO:
  IF NEW dfields THEN DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    
    
    ASSIGN arealist = ?
           lobarea = ?
           cplist = ?
           collist = ?.
    if lNoarea then
        lobarea = "".
    else 
    do:   
        FOR EACH DICTDB._Area WHERE DICTDB._Area._Area-num > 6
                                AND DICTDB._Area._Area-type = 6
                                AND NOT CAN-DO ({&INVALID_AREAS}, DICTDB._Area._Area-name)
                                NO-LOCK. 
          IF CAN-FIND(FIRST DICTDB._File WHERE RECID(DICTDB._File) = drec_file
                                           AND DICTDB._File._ianum = DICTDB._Area._Area-Num) THEN
              ASSIGN lobarea = DICTDB._Area._Area-name.
          IF arealist = ? THEN
            ASSIGN arealist = DICTDB._Area._Area-name.            
          ELSE
            ASSIGN arealist = arealist + "," + DICTDB._Area._Area-name.
        END.
      
        IF NUM-ENTRIES(arealist) = 1 THEN
          ASSIGN arealist = arealist.
        
        FIND DICTDB._Area WHERE DICTDB._Area._Area-number = 6 NO-LOCK.
        
        IF lobarea = ? THEN
          ASSIGN lobarea = DICTDB._Area._Area-name.
    
        IF arealist = ? THEN 
          ASSIGN arealist = DICTDB._Area._Area-name.           
        ELSE
          ASSIGN arealist = arealist + "," + DICTDB._Area._Area-name.
    
        ASSIGN areaname:LIST-ITEMS IN FRAME pro-clob = arealist.
    end.
    
    RUN set-code-page.
    
    ASSIGN cplist = "*Use DB Code page" + "," + cplist
           collist = "*Use DB Collation"
           cpname:LIST-ITEMS IN FRAME pro-clob = cplist
           colname:LIST-ITEMS IN FRAME pro-clob = collist.           
                
    DISPLAY dfields._Field-name areaname lob-size neworder @ dfields._Order
            dfields._Fld-case cpname colname dfields._Desc WITH FRAME pro-clob.

    ASSIGN areaname:SCREEN-VALUE IN FRAME pro-clob = lobarea
           cpname:SCREEN-VALUE IN FRAME pro-clob = "*Use DB Code page"
           colname:SCREEN-VALUE IN FRAME pro-clob = "*Use DB Collation".

    SET areaname when lNoArea = false lob-size dfields._Order 
        dfields._Fld-case cpname colname dfields._Desc dfields._Field-name WITH FRAME pro-clob.
  END.
  ELSE DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    if lNoArea then
       areaname = "".
    else do:
        IF dfields._Field-rpos <> ? THEN DO:
          FIND dictdb._storageobject WHERE dictdb._Storageobject._Db-recid = drec_db
                                AND dictdb._Storageobject._Object-type = 3
                                AND dictdb._Storageobject._Object-number = dfields._Fld-stlen
                                and dictdb._Storageobject._Partitionid = 0
                               NO-LOCK.
        
          FIND DICTDB._Area WHERE DICTDB._Area._Area-number = dictdb._StorageObject._Area-number NO-LOCK.
    
        END.
        ELSE
          FIND DICTDB._Area WHERE DICTDB._Area._Area-number = dfields._Fld-stlen NO-LOCK.
    
        ASSIGN areaname:LIST-ITEMS IN FRAME mod-clob = DICTDB._Area._Area-name.
    end.
    assign   
          lob-size = dfields._Fld-Misc2[1]
           cpname:LIST-ITEMS IN FRAME mod-clob = dfields._Charset
           colname:LIST-ITEMS IN FRAME mod-clob = dfields._Collation.
    DISPLAY dfields._Field-name areaname lob-size dfields._Order dfields._Fld-case
            cpname colname dfields._Desc WITH FRAME mod-clob.

    UPDATE lob-size dfields._Order 
        dfields._Fld-case WHEN NOT inindex dfields._Desc dfields._Field-name
        WITH FRAME mod-clob. 
  END.   
END.
ELSE DO:
  NEXT-PROMPT dfields._Format WITH FRAME pro_fld.
  DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:

  /* Dis-allow duplicate order numbers */
    ON LEAVE OF dfields._Order IN FRAME pro_fld DO:
      IF CAN-FIND(FIRST dictdb._Field WHERE
                        dictdb._Field._File-recid = drec_file AND
                        dictdb._Field._Order = INPUT dfields._Order AND
                        dictdb._Field._Order <> dfields._Order) THEN DO:
            MESSAGE "Order number" TRIM(INPUT dfields._Order) "already exists." 
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /* set order number back to its current value */
            dfields._Order:SCREEN-VALUE = STRING(neworder).
         RETURN NO-APPLY.
      END.
    END.

    /* in case the user changes the type to int64, we would fail if the Initial value
       was set to a value that can't fit into an integer, because we don't update the
       field's type in the SET statement below. So we need to store the Initial value
       in a variable and assign it to the real _Initial later on, after the type gets
       changed.
    */
    ASSIGN s_Initial = dfields._Initial.

    IF allow_type_change THEN
        DISPLAY s_Dtype WITH FRAME pro_fld.

    DISPLAY s_initial WITH FRAME pro_fld.

    SET
    dfields._Field-name WHEN NOT INPUT dfields._Field-name BEGINS "_"  
    s_Dtype WHEN allow_type_change /* dfields._Data-type */
    dfields._Format
    dfields._Label
    dfields._Col-label
    s_initial /*dfields._Initial*/
    dfields._Extent    WHEN NEW dfields
    dfields._Decimals  WHEN INPUT dfields._Data-type = "decimal"
    dfields._Order
    dfields._Mandatory
    dfields._Fld-case WHEN INPUT dfields._Data-type = "character"
                        AND (NEW dfields OR NOT inindex)
    dfields._Valexp
    dfields._Valmsg
    dfields._Help
    dfields._Desc
    WITH FRAME pro_fld.

    IF dfields._Field-name ENTERED AND NOT NEW dfields AND inview THEN DO:
      MESSAGE new_lang[2]. /* sorry, used in view */
      UNDO,RETRY.
    END.

    /* check for int -> int64 change */
    IF NOT NEW dfields AND allow_type_change THEN DO:
        IF dfields._Data-type NE INPUT FRAME pro_fld s_Dtype  THEN DO:
            IF INPUT FRAME pro_fld s_Dtype = "int64" THEN DO:
                RUN prodict/pro/_pro_int64.p.
                
                IF RETURN-VALUE NE "mod" THEN
                    UNDO, RETRY.

                /* make the change now - can't do it on the SET statement or
                   we would get error 171 even if the type was not changed
                 */
                ASSIGN dfields._Data-type = "int64".
            END.
        END.
    END.

    /* in case the data type was changed to int64, need to assign Initial after the type
       gets changed 
    */
    ASSIGN dFields._Initial = s_Initial.

    ASSIGN
      dfields._Valexp = (IF TRIM(dfields._Valexp) = "" 
                                           THEN ? 
                                           ELSE TRIM(dfields._Valexp)).
    changed = TRUE.
  END.
END.

IF KEYFUNCTION(LASTKEY) = "END-ERROR" AND NEW dfields THEN DELETE dfields.

HIDE FRAME pro_fld NO-PAUSE.
RETURN.
