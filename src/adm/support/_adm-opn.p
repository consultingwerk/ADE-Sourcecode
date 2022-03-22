&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _adm-opn.p

Description:
    Generate the code needed in an adm-open-query-cases procedure
    (used by SmartBrowsers and SmartQueries that support foreign keys).
    
Input Parameters:
    p_context-id - (INTEGER) Context ID of the current procedure
    
Output Parameters:
    p_Code - (CHAR) code to return. (Including "END PROCEDURE." ). 
 
Author: Wm.T.Wood
Created: March, 1996

Modified: <not yet>
----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER  p_context-id AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER  p_code       AS CHAR       NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************** Local Definitions ***************************** */

DEFINE VAR  ch           AS CHAR       NO-UNDO.
DEFINE VAR  cnt          AS INTEGER    NO-UNDO.
DEFINE VAR  db-tbl       AS CHARACTER  NO-UNDO.
DEFINE VAR  db-tbl-fld   AS CHARACTER  NO-UNDO.
DEFINE VAR  dtype        AS CHARACTER  NO-UNDO.
DEFINE VAR  filter-attrs AS CHARACTER  NO-UNDO.
DEFINE VAR  fld          AS CHARACTER  NO-UNDO.
DEFINE VAR  i            AS INTEGER    NO-UNDO.
DEFINE VAR  ipos         AS INTEGER    NO-UNDO.
DEFINE VAR  key          AS CHARACTER  NO-UNDO.
DEFINE VAR  key-list     AS CHARACTER  NO-UNDO.
DEFINE VAR  key-name     AS CHARACTER  NO-UNDO.
DEFINE VAR  key-test     AS CHARACTER  NO-UNDO.
DEFINE VAR  l_found-one  AS LOGICAL    NO-UNDO.
DEFINE VAR  open-query   AS CHARACTER  NO-UNDO.
DEFINE VAR  proc-id      AS INTEGER    NO-UNDO.
DEFINE VAR  query-name   AS CHARACTER  NO-UNDO.
DEFINE VAR  sortby-list  AS CHARACTER  NO-UNDO.

&Scoped-define COMMENT-LINE ------------------------------------------------------------------------------
/* Standard End-of-line character - adjusted in 7.3A to be just chr(10) */
&Scoped-define EOL CHR(10)

/* ******************************** Main Code ********************************** */

/* Get the context of the current procedure. */
RUN adeuib/_uibinfo.p (INPUT p_context-id, ?, "PROCEDURE", OUTPUT ch).
proc-id = INTEGER (ch).

p_code =   
"/*{&COMMENT-LINE}" + {&EOL} +
"  Purpose:     Opens different cases of the query based on attributes" + {&EOL} +
"               such as the 'Key-Name', or 'SortBy-Case'" + {&EOL} + 
"  Parameters:  <none>" + {&EOL} + 
"{&COMMENT-LINE}*/". 

/* Get the NAME of the query from the "Foreign Keys" XFTR section. This should be
   a list of the form:
     KEY-OBJECT
   This will either be the name of a Query or Browse, or &QUERY-NAME or &BROWSE-NAME
 */
RUN adm/support/_xgetdat.p (p_context-id, 'Foreign Keys':U, 'KEY-OBJECT':U,
                            OUTPUT query-name).
IF CAN-DO ("&BROWSE-NAME,&QUERY-NAME":U, query-name)
THEN query-name = "~{":U + query-name + "}":U.
ELSE IF query-name eq "" THEN query-name = "~{&QUERY-NAME}".
open-query = "~{&OPEN-QUERY-" + query-name + "}".

/* Get the SORTBY-OPTIONS from the "Advanced SmartQuery" XFTR section. This should be
   a list of the form:
     sortby-case|db.table.field
     sortby-case|db.table.field
 */
RUN adm/support/_xgetdat.p (p_context-id, 'Advanced Query Options':U, 'SORTBY-OPTIONS':U,
                            OUTPUT sortby-list).

/* Get the FILTER-ATTRIBUES from the "Advanced SmartQuery" XFTR section. */
RUN adm/support/_xgetdat.p (p_context-id, 'Advanced Query Options':U, 'FILTER-ATTRIBUTES':U,
                            OUTPUT filter-attrs).

/* Get the ACCEPTED-KEYS from the "Foreign Keys" XFTR section. This should be
   a list of the form:
     key-name|y|y|db.table.field
     key-name||y|db.table.field
   Accepted keys are ones with a "y" as the second entry.
 */
RUN adm/support/_xgetdat.p (p_context-id, 'Foreign Keys':U, 'FOREIGN-KEYS':U,
                            OUTPUT key-list).
cnt = NUM-ENTRIES (key-list, CHR(10)).
FOUND-ONE:
DO i = 1 to cnt:
  IF ENTRY(2, ENTRY(i, key-list, CHR(10)), "|":U) eq "y":U THEN DO:
    l_found-one = yes.
    LEAVE FOUND-ONE.
  END.
END.
IF NOT l_found-one THEN DO:  
  IF filter-attrs ne "":U THEN RUN build-filter-variables.
  p_code = p_code + {&EOL} + {&EOL} +
  "  /* No Foreign keys are accepted by this SmartObject. */" .
  p_code = p_code + {&EOL}.
  RUN put-sortby-cases ("  ":U).
END.
ELSE DO:
  p_code = p_code + {&EOL} +
  "  DEF VAR key-value AS CHAR NO-UNDO." + {&EOL}.
  
  /* Define filter variables. */
  IF filter-attrs ne "":U THEN RUN build-filter-variables.
 
  p_code = p_code + {&EOL} +
  "  /* Look up the current key-value. */" + {&EOL} + 
  "  RUN get-attribute ('Key-Value':U)." + {&EOL} +
  "  key-value = RETURN-VALUE." + {&EOL} + {&EOL} +
  "  /* Find the current record using the current Key-Name. */" + {&EOL} +            
  "  RUN get-attribute ('Key-Name':U)." + {&EOL} +
  "  CASE RETURN-VALUE:".

  /* The "key-list" is of the form "key-name|y|y|db.tbl.fld". Parse this. */
  DO i = 1 TO cnt:
    key = TRIM(ENTRY(i, key-list, CHR(10))).
    /* Is this an ACCEPTED key? */
    IF ENTRY(2, key, '|':U) eq "y":U THEN DO:
      /* The "key-list" is of the form "key-name|y|y|db.tbl.fld". Parse this. */
      ASSIGN key-name   = TRIM(ENTRY(1, key, '|':U))
             db-tbl-fld = TRIM(ENTRY(4, key, '|':U))
             .
      /* Parse the db-tbl-fld into its basic components. */
      ASSIGN ipos     = R-INDEX(db-tbl-fld, '.':U)
             db-tbl   = SUBSTRING(db-tbl-fld, 1, ipos - 1,  "CHARACTER":U)
             fld      = SUBSTRING(db-tbl-fld, ipos + 1, -1, "CHARACTER":U)
             .
      /* The user may have wanted to suppress the db name in the UIB. Ask the
         UIB to set up the database/table name. */
      RUN adeuib/_dbtbnam.p (proc-id, db-tbl, OUTPUT db-tbl).
  
      /* Get the datatype of the key field, and use it to process the key-value. 
         (That is, all attributes are CHAR, so we need to convert the other data
          types.) */
      RUN adeshar/_fldtype.p (INPUT db-tbl-fld, OUTPUT dtype).
      CASE dtype:
        WHEN "CHARACTER":U THEN key-test = "key-value":U.
        WHEN "DATE":U      THEN key-test = "DATE(key-value)":U.
        WHEN "DECIMAL":U   THEN key-test = "DECIMAL(key-value)":U.
        WHEN "INTEGER":U   THEN key-test = "INTEGER(key-value)":U.
        WHEN "RECID":U     THEN key-test = "INTEGER(key-value)":U.
        WHEN "ROWID":U     THEN key-test = "TO-ROWID(key-value)":U.
        OTHERWISE DO:
          MESSAGE "Unexpected DATA-TYPE:" dtype SKIP
                  "Found while generating code to find a table using key '" 
                  + key-name + "'.":U SKIP(1)
                  "Please check code for {&FILE-NAME}."
                  VIEW-AS ALERT-BOX ERROR.
          key-test = "key-value":U.
        END.
      END CASE.
  
      p_code = p_code + {&EOL} +
      "    WHEN '":U + key-name + "':U THEN DO:" + {&EOL} +
      "       &Scope KEY-PHRASE ":U + db-tbl + ".":U + fld + " eq ":U + key-test.
      RUN put-sortby-cases ("       ":U).
      p_code = p_code + {&EOL} +
      "    END. /* " + key-name + " */".
    END. /* IF.. <accepted key> THEN DO:... */
  END. /* DO i = 1 to cnt...*/
       
  /* Close the Case statement. */
  p_code = p_code + {&EOL} +
  "    OTHERWISE DO:" + {&EOL} +
  "       &Scope KEY-PHRASE TRUE".
  RUN put-sortby-cases ("       ":U).
  p_code = p_code + {&EOL} +
  "    END. /* OTHERWISE...*/" + {&EOL} + 
  "  END CASE." .           
END.

/* End the Procedure. */
p_code = p_code + {&EOL} + {&EOL} + "END PROCEDURE.".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build-filter-variables Procedure 
PROCEDURE build-filter-variables :
/*------------------------------------------------------------------------------
  Purpose:     Add the filter definitions for each of the filter-attributes
               to the generated code.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VAR cnt         AS INTEGER NO-UNDO.
   DEFINE VAR ch          AS CHAR    NO-UNDO.
   DEFINE VAR i           AS INTEGER NO-UNDO.
   DEFINE VAR ok2define   AS LOGICAL NO-UNDO.
   DEFINE VAR assign-code AS CHAR    NO-UNDO.
   DEFINE VAR attr-name   AS CHAR    NO-UNDO.
   
   IF filter-attrs ne "":U THEN DO:
    /* Get the filter attributes from the code. This should be of the form:
       RUN set-attribute-list IN THIS-PROCEDURE ('
         attribute = value,
         attribute = value,
         attribute = value'). 
       We will convert this to a series of:
         DEF VAR attribute AS CHAR NO-UNDO.
         RUN get-attribute ('attribute':U).
         attribute = RETURN-VALUE. */
    ASSIGN ok2define = NO
           cnt = NUM-ENTRIES(filter-attrs, CHR(10))
           assign-code = "":U.     
    DO i = 1 TO cnt:
      ch = ENTRY(i, filter-attrs, CHR(10)).
      IF NOT ok2define THEN DO:
        /* Start variables on the line after the set-attribute-list. */
       IF INDEX(ch, 'set-attribute-list':U) > 0 THEN ok2define = yes.
      END.
      ELSE DO:
        /* Stop creating when NO ='s are found. */
        IF INDEX(ch, "=") > 0 THEN DO:
          ASSIGN
            attr-name   = TRIM (ENTRY(1, ch, "=":U)) 
            p_code      = p_code + {&EOL} 
                        + "  DEF VAR ":U + attr-name + " AS CHAR NO-UNDO.":U.
            assign-code = assign-code + {&EOL} 
                        + "  RUN get-attribute ('":U + attr-name + "':U).":U + {&EOL}
                        + "  ":U + attr-name + " = RETURN-VALUE.":U.
        END. /* IF INDEX..."=" > 0 ... */
      END. /* IF ok2define... */
    END. /* DO i = 1 to cnt... */
    /* Add the assign-code to the code block. */
    IF assign-code ne "":U THEN 
      p_code = p_code + {&EOL} + {&EOL} 
             + "  /* Copy 'Filter-Attributes' into local variables. */"
             + assign-code.
  END. /* IF filter-attrs ne "":U ... */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build-sortby-phrase Procedure 
PROCEDURE build-sortby-phrase :
/*------------------------------------------------------------------------------
  Purpose: Rebuild a sortby-phrase based on encoded build information (of the
           form:
                 "db.tbl.fld|yes,db.tbl.fld|no"
           That is, as comma-delimeted list of
                 "field-name|descending"
                 
           This is converted into a list of "BY fld BY fld2 DESCENDING" etc.
  Parameters:  
    INPUT  p_source - (CHAR) The input list
    OUTPUT p_phrase - (CHAR) The BY pharse
  Notes:       
-------------------------------------------------------------------------------- */ 
  DEFINE INPUT  PARAMETER p_source AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER p_phrase AS CHAR NO-UNDO.
  
  DEF VAR iby         AS INTEGER NO-UNDO.
  DEF VAR ipos        AS INTEGER NO-UNDO.
  DEF VAR cnt         AS INTEGER NO-UNDO.
  DEF VAR cBY         AS CHAR NO-UNDO.
  DEF VAR db-tbl      AS CHARACTER  NO-UNDO.
  DEF VAR db-tbl-fld  AS CHARACTER  NO-UNDO.
  DEF VAR fld         AS CHARACTER  NO-UNDO.
  
  cnt = NUM-ENTRIES (p_source).
  DO iby = 1 TO cnt:
    ASSIGN cBY        = ENTRY(iby, p_source)
           db-tbl-fld = ENTRY (1, cBY, "|":U) 
           /* Parse the db-tbl-fld into its basic components. */
           ipos       = R-INDEX(db-tbl-fld, '.':U)
           db-tbl     = SUBSTRING(db-tbl-fld, 1, ipos - 1,  "CHARACTER":U)
           fld        = SUBSTRING(db-tbl-fld, ipos + 1, -1, "CHARACTER":U)
           .
    /* The user may have wanted to suppress the db name in the UIB. Ask the
       UIB to set up the database/table name. */
    RUN adeuib/_dbtbnam.p (proc-id, db-tbl, OUTPUT db-tbl).

    /* Create the phrase. */
    IF iby > 1 THEN p_phrase = p_phrase + " ":U.
    p_phrase = p_phrase + "BY ":U + db-tbl + ".":U + fld 
                        + (IF ENTRY(2, cBY, "|":U) BEGINS "y":U
                           THEN "":U ELSE " DESCENDING":U).
  END. /* DO:... */ 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE put-sortby-cases Procedure 
PROCEDURE put-sortby-cases :
/*------------------------------------------------------------------------------
  Purpose:     Puts the SORT-CASES into the case statement.   
  Parameters:  c_indent -- the indent string (just spaces).
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER c_indent AS CHAR NO-UNDO.

  DEFINE VAR cnt           AS INTEGER    NO-UNDO.
  DEFINE VAR i             AS INTEGER    NO-UNDO.
  DEFINE VAR ipos          AS INTEGER    NO-UNDO.
  DEFINE VAR lngth         AS INTEGER    NO-UNDO.
  DEFINE VAR l_freeform    AS LOGICAL    NO-UNDO.    
  DEFINE VAR sortby        AS CHARACTER  NO-UNDO.
  DEFINE VAR sortby-case   AS CHARACTER  NO-UNDO.
  DEFINE VAR sortby-phrase AS CHARACTER  NO-UNDO.

  /* If there are NO sort-options, then just put out the simple OPEN QUERY 
     statement. */
  cnt = NUM-ENTRIES (sortby-list, CHR(10)).
  IF cnt < 1 
  THEN p_code = p_code + {&EOL} + c_indent + open-query.
  ELSE DO:
    p_code = p_code + {&EOL} + c_indent + 
    "RUN get-attribute ('SortBy-Case':U)." + {&EOL} + c_indent + 
    "CASE RETURN-VALUE:".

    DO i = 1 TO cnt:
      /* The "sortby-list" is of the form "key-name|y|y|db.tbl.fld". Parse this. 
         Entry 1 is the name, Entry 2 is "y" for the initial case, and entry 3
         is "y" if it is freeform. */
      ASSIGN sortby       = TRIM(ENTRY(i, sortby-list, CHR(10)))
             sortby-case  = TRIM(ENTRY(1, sortby, '|':U))
             l_freeform   = TRIM(ENTRY(3, sortby, '|':U)) eq "y":U
             .
      /* Everything after the 3rd "|" is the sort-by phrase, or the
         sort-rebuild information. */
      ASSIGN 
         lngth = LENGTH(sortby, "CHARACTER":U) 
         ipos  = INDEX(sortby, "|":U).      
      IF ipos > 0 AND ipos < lngth THEN ipos = INDEX(sortby, "|":U, ipos + 1).
      IF ipos > 0 AND ipos < lngth THEN ipos = INDEX(sortby, "|":U, ipos + 1).
      IF ipos eq lngth OR ipos eq 0 THEN sortby-phrase = "".
      ELSE sortby-phrase = SUBSTRING(sortby, ipos + 1, -1, "CHARACTER":U). 
      
      /* Remove LINE-FEED comments in Free-form phrases, 
         and build any phrases that are not freeform. */
      IF l_freeform 
      THEN sortby-phrase = REPLACE (sortby-phrase, "/*lf*/":U, "":U).
      ELSE RUN build-sortby-phrase (sortby-phrase, OUTPUT sortby-phrase).

      p_code = p_code + {&EOL} + c_indent +
      "  WHEN '":U + sortby-case + "':U THEN DO:" + {&EOL} + c_indent +
      "    &Scope SORTBY-PHRASE " + sortby-phrase + {&EOL} + c_indent +
      "    " + open-query + {&EOL} + c_indent +
      "  END.".
    END.      
    /* Close the Case statement. */
    p_code = p_code + {&EOL} + c_indent +
    "  OTHERWISE DO:" + {&EOL} + c_indent +
    "    &Undefine SORTBY-PHRASE" + {&EOL} + c_indent +
    "    " + open-query + {&EOL} + c_indent +
    "  END. /* OTHERWISE...*/" + {&EOL} + c_indent +
    "END CASE." .      
  END. /* IF cnt > 0... */     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


