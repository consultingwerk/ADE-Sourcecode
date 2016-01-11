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
     
*/     

DEFINE INPUT  PARAMETER ronly   AS CHARACTER             NO-UNDO.
DEFINE INPUT  PARAMETER junk2   AS RECID                 NO-UNDO.
DEFINE OUTPUT PARAMETER changed AS LOGICAL INITIAL FALSE NO-UNDO.

DEFINE SHARED BUFFER dfields FOR _Field.

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
DEFINE VARIABLE cpname    AS CHARACTER INITIAL ?       NO-UNDO.
DEFINE VARIABLE cplist    AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE colname   AS CHARACTER INITIAL ?       NO-UNDO.
DEFINE VARIABLE collist   AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE lob-size  AS CHARACTER FORMAT "x(10)" INITIAL "100M" NO-UNDO.
DEFINE VARIABLE size-type AS CHARACTER FORMAT "x"      NO-UNDO.
DEFINE VARIABLE wdth      AS DECIMAL                   NO-UNDO.
DEFINE VARIABLE hldcp     AS CHARACTER                 NO-UNDO.

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userpik.i NEW }

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 9 NO-UNDO INITIAL [
  /* 1*/ "This field is used in a View or Index - cannot delete.",
  /* 2*/ "This field is used in a View - cannot rename.",
  /* 3*/ "This name is already used by a different field in this file",
  /* 4*/ "There is a field in these tables", /* make sure 4..6 fit in the */
  /* 5*/ "with the same name, pick one to", /* frame format 'x(31)'      */
  /* 6*/ ?, /*see below*/                   /* frame name 'frm_top'      */
  /* 7*/ "You must enter a field name here",
  /* 8*/ "create new field",
  /* 9*/ "Attempt to add with same name as existing field - switching to MODIFY"
].
new_lang[6] = "copy, or press [" + KBLABEL("END-ERROR") + "].".

FORM
  dfields._Field-name LABEL "  Field-Name" FORMAT "x(32)"
    VALIDATE(KEYWORD(dfields._Field-name) = ?,
      "This name conflicts with a PROGRESS reserved keyword.") SPACE
  dfields._Data-type  LABEL "   Data-Type" FORMAT "x(11)"  SKIP
  dfields._Format     LABEL "      Format" FORMAT "x(32)" 
  dfields._Extent     LABEL "     Extent" FORMAT ">>>>"  SKIP

  dfields._Label      LABEL "       Label" FORMAT "x(30)" SPACE(3)
  dfields._Decimals   LABEL "    Decimals" FORMAT ">>>>9" SKIP
  
  dfields._Col-label  LABEL "Column-label" FORMAT "x(30)" SPACE(3)
  dfields._Order      LABEL "       Order" FORMAT ">>>>9"  SKIP

  dfields._Initial    LABEL "     Initial" FORMAT "x(30)" SPACE(3)
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
    areaname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1 
             LABEL "Area" COLON 10 SKIP
    lob-size LABEL "Max Size" COLON 10 SKIP
    dfields._Order LABEL "Order" COLON 10 SKIP
    WITH FRAME pro-blob VIEW-AS DIALOG-BOX
    SIDE-LABELS ROW 4 COLUMN 10 
    TITLE "Blob Field Attributes".

FORM
    dfields._Field-name LABEL "Field Name" FORMAT "x(32)"
    VALIDATE(KEYWORD(dfields._Field-name) = ?,
      "This name conflicts with a PROGRESS reserved keyword.") SKIP
    areaname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1 
             LABEL "Area" COLON 11 SKIP
    lob-size LABEL "Max Size" COLON 11 SKIP
    dfields._Order LABEL "  Order" COLON 11 SKIP
    WITH FRAME mod-blob VIEW-AS DIALOG-BOX
    SIDE-LABELS ROW 4 COLUMN 10 
    TITLE "Blob Field Attributes".

FORM
    areaname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1 
             LABEL "Area" COLON 15 SKIP
    lob-size LABEL "Max Size" COLON 15 SKIP
    dfields._Order LABEL "Order" COLON 15 SKIP
    dfields._fld-case LABEL "Case Sensitive" COLON 15 SKIP
    cpname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1 SORT
             LABEL "Code Page" COLON 15 SKIP
    colname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1 SORT
             LABEL "Collation" COLON 15 SKIP
    WITH FRAME pro-clob VIEW-AS DIALOG-BOX
    SIDE-LABELS ROW 4 COLUMN 10 
    TITLE "Clob Field Attributes".

FORM
    dfields._Field-name LABEL "    Field name" FORMAT "x(32)"
    VALIDATE(KEYWORD(dfields._Field-name) = ?,
      "This name conflicts with a PROGRESS reserved keyword.") SKIP
    areaname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1 
             LABEL "Area" COLON 15 SKIP
    lob-size LABEL "Max Size" COLON 15 SKIP
    dfields._Order LABEL "Order" COLON 15 SKIP
    dfields._fld-case LABEL "Case Sensitive" COLON 15 SKIP
    cpname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1
             LABEL "Code Page" COLON 15 SKIP
    colname VIEW-AS SELECTION-LIST INNER-CHARS 32 INNER-LINES 1
             LABEL "Collation" COLON 15 SKIP
    WITH FRAME mod-clob VIEW-AS DIALOG-BOX
    SIDE-LABELS ROW 4 COLUMN 10 
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

    IF areaname:SCREEN-VALUE IN FRAME pro-blob <> ? THEN
     ASSIGN lobarea = areaname:SCREEN-VALUE IN FRAME pro-blob.
  
    FIND DICTDB._Area WHERE DICTDB._Area._Area-name =  lobarea NO-LOCK.    
    ASSIGN dfields._Fld-stlen = DICTDB._Area._Area-number
           dfields._Format = "x(8)"
           dfields._Fld-Misc2[1] = CAPS(lob-size:SCREEN-VALUE) 
           dfields._Width = wdth
           dfields._Initial = ?
           dfields._Order = INTEGER(dfields._Order:SCREEN-VALUE)        
           dfields._Field-name = dfields._Field-name:SCREEN-VALUE IN FRAME pro_fld
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
         dfields._Field-name = dfields._Field-name:SCREEN-VALUE.
    ASSIGN changed = TRUE.
END.

ON GO OF FRAME pro-clob DO:

  FIND DICTDB._DB WHERE RECID(DICTDB._DB) = drec_db NO-LOCK.
  IF NEW dfields THEN DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:  
    IF wdth = ? OR wdth = 0  THEN
      APPLY "leave" TO lob-size IN FRAME pro-clob.

    IF lobarea = ? THEN
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
  
    FIND DICTDB._Area WHERE DICTDB._Area._Area-name =  lobarea NO-LOCK.    
  
    ASSIGN dfields._Fld-stlen = DICTDB._Area._Area-number
           dfields._Format = "x(8)"
           dfields._Fld-Misc2[1] = CAPS(lob-size:SCREEN-VALUE IN FRAME pro-clob)
           dfields._Width = wdth
           dfields._Initial = ?
           dfields._Order = INTEGER(dfields._Order:SCREEN-VALUE IN FRAME pro-clob) 
           dfields._Fld-case = LOGICAL(dfields._Fld-case:SCREEN-VALUE IN FRAME pro-clob)
           dfields._Field-name = dfields._Field-name:SCREEN-VALUE IN FRAME pro_fld
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

  IF INDEX(lob-size, "K") <> 0 THEN
    ASSIGN size-type = "K".
  ELSE IF INDEX(lob-size, "M") <> 0 THEN
    ASSIGN size-type = "M".
  ELSE IF INDEX(lob-size, "G") <> 0 THEN
    ASSIGN size-type = "G".
  ELSE IF INDEX(lob-size, "B") <> 0 THEN
    ASSIGN size-type = "B".
  ELSE IF INDEX("ACDEFHIJLNOPQRSTUVWXYZ", SUBSTRING(lob-size, LENGTH(lob-size), 1)) <> 0 THEN DO:
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
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(lob-size, 1, (INDEX(lob-size, "K") - 1)))).
        ASSIGN wdth = (wdth * 1024).
    END.
    WHEN "M" THEN DO:
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(lob-size, 1, (INDEX(lob-size, "M") - 1)))).
        ASSIGN wdth = (wdth * (1024 * 1024)).
    END.
    WHEN "G" THEN
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(lob-size, 1, (INDEX(lob-size, "G") - 1))))
               wdth = (wdth * (1024 * 1024 * 1024)- 1 ).
    OTHERWISE
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(lob-size, 1, (INDEX(lob-size, "B") - 1)))). 
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
  IF CAN-FIND(FIRST _Field WHERE _Field._File-recid = drec_file 
              AND _Field._Order = INPUT dfields._Order 
              AND _Field._Order <> dfields._Order) THEN DO:
            MESSAGE "Order number" TRIM(INPUT dfields._Order) "already exists." 
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /* set order number back to its current value */
            dfields._Order:SCREEN-VALUE = STRING(neworder).
         RETURN NO-APPLY.
  END.
END.

ON LEAVE OF dfields._Order IN FRAME mod-blob DO:
  IF CAN-FIND(FIRST _Field WHERE _Field._File-recid = drec_file 
              AND _Field._Order = INPUT dfields._Order 
              AND _Field._Order <> dfields._Order) THEN DO:
            
      MESSAGE "Order number" TRIM(INPUT dfields._Order) "already exists." 
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /* set order number back to its current value */
            dfields._Order:SCREEN-VALUE = STRING(neworder).
         RETURN NO-APPLY.
  END.
END.

ON LEAVE OF lob-size IN FRAME pro-clob,
            lob-size IN FRAME mod-clob
DO:
  IF NEW dfields THEN
    ASSIGN lob-size = CAPS(lob-size:SCREEN-VALUE IN FRAME pro-clob).
  ELSE
    ASSIGN lob-size = CAPS(lob-size:SCREEN-VALUE IN FRAME mod-clob).

  IF INDEX(lob-size, "K") <> 0 THEN
    ASSIGN size-type = "K".
  ELSE IF INDEX(lob-size, "M") <> 0 THEN
    ASSIGN size-type = "M".
  ELSE IF INDEX(lob-size, "G") <> 0 THEN
    ASSIGN size-type = "G".
  ELSE IF INDEX(lob-size, "B") <> 0 THEN
    ASSIGN size-type = "B".
  ELSE IF INDEX("ACDEFHIJLNOPQRSTUVWXYZ", SUBSTRING(lob-size, LENGTH(lob-size), 1)) <> 0 THEN DO:
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
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(lob-size, 1, (INDEX(lob-size, "K") - 1)))).
        ASSIGN wdth = (wdth * 1024).
    END.
    WHEN "M" THEN DO:
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(lob-size, 1, (INDEX(lob-size, "M") - 1)))).
        ASSIGN wdth = (wdth * (1024 * 1024)).
    END.
    WHEN "G" THEN
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(lob-size, 1, (INDEX(lob-size, "G") - 1))))
               wdth = (wdth * (1024 * 1024 * 1024)).
    OTHERWISE
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(lob-size, 1, (INDEX(lob-size, "B") - 1)))). 
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
    inindex    = CAN-FIND(FIRST _Index-field OF dfields)
    inview     = CAN-FIND(FIRST _View-ref
                 WHERE _View-ref._Ref-Table = user_filename
                   AND _View-ref._Base-Col = dfields._Field-name)
    neworder   = dfields._Order
    wdth       = 0.
  
END. /*---------------------------------------------------------------------*/
ELSE DO: /*-----------------------------------------------------------------*/
  FIND LAST _Field USE-INDEX _Field-Position
    WHERE _Field._File-recid = drec_file NO-ERROR.
  ASSIGN
    inindex    = FALSE
    inview     = FALSE
    inother    = CAN-FIND(FIRST _Field
                 WHERE _Field._Field-name =
                 INPUT FRAME pro_fld dfields._Field-name)
    neworder   = (IF AVAILABLE _Field THEN _Field._Order + 10 ELSE 10)
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

  IF inother THEN
    FOR EACH _Field
      WHERE _Field._Field-name = INPUT FRAME pro_fld dfields._Field-name:
        FOR EACH _File OF _Field
          WHERE _File._Db-recid = drec_db AND RECID(_File) <> drec_file
            AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
          BY _File._File-name:
          ASSIGN
            pik_count = pik_count + 1
            pik_list[pik_count] = _File._File-name.
        END.
    END.

  /* since we can't tell if a field is in another (non-progress)
  schema, we have to wait until we attempt the join above to eliminate
  those candidates.  hence, the following test: */
  IF pik_count <= 1 THEN inother = FALSE.

  IF inother THEN _in-other: DO:
    PAUSE 0.
    DISPLAY new_lang[4 FOR 3] WITH FRAME frm_top.
    RUN "prodict/user/_usrpick.p".
    HIDE FRAME frm_top NO-PAUSE.
    IF pik_return = 0 OR pik_first BEGINS "<<" THEN LEAVE _in-other.
    FIND _File WHERE _File._Db-recid = drec_db AND _File._File-name = pik_first
                 AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN" ).
    FIND _Field OF _File WHERE _Field._Field-name =
      INPUT FRAME pro_fld dfields._Field-name.
    ASSIGN
      copied     = TRUE.

    DISPLAY
      _Field._Field-name @ dfields._Field-name /*match case*/
      _Field._Data-type  @ dfields._Data-type
      _Field._Format     @ dfields._Format
      _Field._Label      @ dfields._Label
      _Field._Col-label  @ dfields._Col-label
      _Field._Initial    @ dfields._Initial
      _Field._Extent     @ dfields._Extent
      _Field._Decimals   @ dfields._Decimals
      neworder           @ dfields._Order
      _Field._Mandatory  @ dfields._Mandatory
      _Field._Fld-case   @ dfields._Fld-case
      _Field._Field-rpos @ dfields._Field-rpos
      _Field._Valmsg     @ dfields._Valmsg
      _Field._Help       @ dfields._Help
            
      WITH FRAME pro_fld.

    /* Can't seem to do @ on a view-as editor widget so: */
    ASSIGN dfields._Valexp:screen-value in frame pro_fld = _Field._Valexp
           dfields._Desc:SCREEN-VALUE IN FRAME pro_fld = _Field._Desc.
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
        VALIDATE(NOT CAN-FIND(_Field
          WHERE _Field._File-recid = drec_file
            AND _Field._Field-name = INPUT dfields._Field-name),
        "")
      dfields._Data-type
        VALIDATE(dfields._Data-type <> ?,"")
      WITH FRAME pro_fld.
    IF dfields._Data-type = ? THEN UNDO,RETRY.
  END.
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN DO:
    IF NEW dfields THEN DELETE dfields.
    HIDE FRAME pro_fld NO-PAUSE.
    RETURN.
  END.
END.

IF NOT copied THEN DISPLAY
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

IF ronly = "r/o" THEN DO:
  IF dfields._Data-type = "BLOB" THEN DO:
    IF dfields._Field-rpos <> ? THEN DO:
      FIND _storageobject WHERE _Storageobject._Db-recid = drec_db
                            AND _Storageobject._Object-type = 3
                            AND _Storageobject._Object-number = dfields._Fld-stlen
                           NO-LOCK.
      FIND _Area WHERE _Area._Area-number = _StorageObject._Area-number NO-LOCK.
     END.
     ELSE
       FIND _Area WHERE _Area._Area-number = dfields._Fld-stlen NO-LOCK.

    ASSIGN areaname:LIST-ITEMS IN FRAME pro-blob = _Area._Area-name
           lob-size = dfields._Fld-Misc2[1].
    DISPLAY areaname lob-size dfields._Order WITH FRAME pro-blob. 
  END.
  IF dfields._Data-type = "CLOB" THEN DO:
    IF dfields._Field-rpos <> ? THEN DO:
      FIND _storageobject WHERE _Storageobject._Db-recid = drec_db
                            AND _Storageobject._Object-type = 3
                            AND _Storageobject._Object-number = dfields._Fld-stlen
                           NO-LOCK.
      FIND _Area WHERE _Area._Area-number = _StorageObject._Area-number NO-LOCK.
     END.
     ELSE
       FIND _Area WHERE _Area._Area-number = dfields._Fld-stlen NO-LOCK.

    ASSIGN areaname:LIST-ITEMS IN FRAME pro-clob = _Area._Area-name
           cpname:LIST-ITEMS IN FRAME pro-clob = dfields._Charset
           colname:LIST-ITEMS IN FRAME pro-clob = dfields._Collation
           lob-size = dfields._Fld-Misc2[1].
  
    DISPLAY areaname lob-size dfields._Order dfields._Fld-case
            cpname colname WITH FRAME pro-clob. 
  END.
  { prodict/user/userpaus.i }
  HIDE FRAME pro_fld NO-PAUSE.
  RETURN.
END.

IF dfields._Data-type = "BLOB" THEN DO:
  IF NEW dfields THEN DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    ASSIGN arealist = ?
           lobarea = ?.
    FOR EACH DICTDB._Area WHERE DICTDB._Area._Area-num > 6
                            NO-LOCK. 
      IF CAN-FIND(FIRST DICTDB._File WHERE RECID(DICTDB._File) = drec_file
                                       AND DICTDB._File._ianum = DICTDB._Area._Area-Num) THEN
          ASSIGN lobarea = DICTDB._Area._Area-name.
      IF arealist = ? THEN
        ASSIGN arealist = DICTDB._Area._Area-name.            
      ELSE
        ASSIGN arealist = arealist + "," + DICTDB._Area._Area-name + ",".
    END.
  
    IF NUM-ENTRIES(arealist) = 1 THEN
      ASSIGN arealist = arealist + ",".
    
    FIND DICTDB._Area WHERE DICTDB._Area._Area-number = 6 NO-LOCK.
    
    IF lobarea = ? THEN
      ASSIGN lobarea = DICTDB._Area._Area-name.

    IF arealist = ? THEN 
      ASSIGN arealist = DICTDB._Area._Area-name.           
    ELSE
      ASSIGN arealist = arealist + DICTDB._Area._Area-name.

    ASSIGN areaname:LIST-ITEMS IN FRAME pro-blob = arealist.
                  
    DISPLAY areaname lob-size neworder @ dfields._Order WITH FRAME pro-blob.
    ASSIGN areaname:SCREEN-VALUE = lobarea.
    SET areaname lob-size dfields._Order WITH FRAME pro-blob.    
  END.
  ELSE DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    IF dfields._Field-rpos <> ? THEN DO:
      FIND _storageobject WHERE _Storageobject._Db-recid = drec_db
                            AND _Storageobject._Object-type = 3
                            AND _Storageobject._Object-number = dfields._Fld-stlen
                           NO-LOCK.
      FIND DICTDB._Area WHERE DICTDB._Area._Area-number = _StorageObject._Area-number NO-LOCK.
    END.
    ELSE
      FIND DICTDB._Area WHERE DICTDB._Area._Area-number = dfields._Fld-stlen NO-LOCK.

    ASSIGN areaname:LIST-ITEMS IN FRAME mod-blob = DICTDB._Area._Area-name
           lob-size = dfields._Fld-Misc2[1]. 
    
    DISPLAY  dfields._Field-name areaname lob-size dfields._Order WITH FRAME mod-blob.
    UPDATE lob-size dfields._Order dfields._Field-name WITH FRAME mod-blob. 
  END.   
END.
ELSE IF dfields._Data-type = "CLOB" THEN DO:
  IF NEW dfields THEN DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    ASSIGN arealist = ?
           lobarea = ?
           cplist = ?
           collist = ?.
    FOR EACH DICTDB._Area WHERE DICTDB._Area._Area-num > 6
                            NO-LOCK. 
      IF CAN-FIND(FIRST DICTDB._File WHERE RECID(DICTDB._File) = drec_file
                                       AND DICTDB._File._ianum = DICTDB._Area._Area-Num) THEN
          ASSIGN lobarea = DICTDB._Area._Area-name.
      IF arealist = ? THEN
        ASSIGN arealist = DICTDB._Area._Area-name.            
      ELSE
        ASSIGN arealist = arealist + "," + DICTDB._Area._Area-name + ",".
    END.
  
    IF NUM-ENTRIES(arealist) = 1 THEN
      ASSIGN arealist = arealist + ",".
    
    FIND DICTDB._Area WHERE DICTDB._Area._Area-number = 6 NO-LOCK.
    
    IF lobarea = ? THEN
      ASSIGN lobarea = DICTDB._Area._Area-name.

    IF arealist = ? THEN 
      ASSIGN arealist = DICTDB._Area._Area-name.           
    ELSE
      ASSIGN arealist = arealist + DICTDB._Area._Area-name.

    ASSIGN areaname:LIST-ITEMS IN FRAME pro-clob = arealist.
    RUN set-code-page.
    ASSIGN cplist = "*Use DB Code page" + "," + cplist
           collist = "*Use DB Collation"
           cpname:LIST-ITEMS IN FRAME pro-clob = cplist
           colname:LIST-ITEMS IN FRAME pro-clob = collist.           
                
    DISPLAY areaname lob-size neworder @ dfields._Order
            dfields._Fld-case cpname colname WITH FRAME pro-clob.

    ASSIGN areaname:SCREEN-VALUE IN FRAME pro-clob = lobarea
           cpname:SCREEN-VALUE IN FRAME pro-clob = "*Use DB Code page"
           colname:SCREEN-VALUE IN FRAME pro-clob = "*Use DB Collation".

    SET areaname lob-size dfields._Order 
        dfields._Fld-case cpname colname WITH FRAME pro-clob.
  END.
  ELSE DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
 
    IF dfields._Field-rpos <> ? THEN DO:
      FIND _storageobject WHERE _Storageobject._Db-recid = drec_db
                            AND _Storageobject._Object-type = 3
                            AND _Storageobject._Object-number = dfields._Fld-stlen
                           NO-LOCK.
    
      FIND DICTDB._Area WHERE DICTDB._Area._Area-number = _StorageObject._Area-number NO-LOCK.

    END.
    ELSE
      FIND DICTDB._Area WHERE DICTDB._Area._Area-number = dfields._Fld-stlen NO-LOCK.

    ASSIGN areaname:LIST-ITEMS IN FRAME mod-clob = DICTDB._Area._Area-name
           lob-size = dfields._Fld-Misc2[1]
           cpname:LIST-ITEMS IN FRAME mod-clob = dfields._Charset
           colname:LIST-ITEMS IN FRAME mod-clob = dfields._Collation.

    DISPLAY dfields._Field-name areaname lob-size dfields._Order dfields._Fld-case
            cpname colname WITH FRAME mod-clob.

    UPDATE lob-size dfields._Order 
        dfields._Fld-case WHEN NOT inindex dfields._Field-name
        WITH FRAME mod-clob. 
  END.   
END.
ELSE DO:
  NEXT-PROMPT dfields._Format WITH FRAME pro_fld.
  DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:

  /* Dis-allow duplicate order numbers */
    ON LEAVE OF dfields._Order IN FRAME pro_fld DO:
      IF CAN-FIND(FIRST _Field WHERE
                        _Field._File-recid = drec_file AND
                        _Field._Order = INPUT dfields._Order AND
                        _Field._Order <> dfields._Order) THEN DO:
            MESSAGE "Order number" TRIM(INPUT dfields._Order) "already exists." 
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /* set order number back to its current value */
            dfields._Order:SCREEN-VALUE = STRING(neworder).
         RETURN NO-APPLY.
      END.
    END.

    SET
    dfields._Field-name WHEN NOT INPUT dfields._Field-name BEGINS "_"  
    dfields._Format
    dfields._Label
    dfields._Col-label
    dfields._Initial
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
