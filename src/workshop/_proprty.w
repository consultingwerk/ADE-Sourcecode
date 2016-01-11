&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v1r1 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: _proprty.w
  
  Description: Display the property sheet for an _U record
  
  Parameters:  <none>
  
  Fields: field-id: The RECID of the _U record.
  
  Author:  D.M.Adams
  
  Created: February 1997
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Included Definitions ---                                             */
{ workshop/errors.i }
{ workshop/htmwidg.i }         /* Design time Web _HTM TEMP-TABLE.      */
{ workshop/objects.i }         /* Shared web object temp-tables.        */
{ workshop/sharvars.i }
{ workshop/uniwidg.i }         /* Universal Widget TEMP-TABLE def       */
{ workshop/help.i }            /* Include context strings.              */

{ webutil/wstyle.i }           /* Standard style defs & functions.      */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE bad-datatype      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-database        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-field           AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-scrap           AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE c-table           AS CHARACTER NO-UNDO.
DEFINE VARIABLE ftv-error         AS LOGICAL   NO-UNDO. 
  /* Format, datatype, or initial value error.  If any of these problems occur,
     then none of these attributes should be written out until they all agree.  */
DEFINE VARIABLE field-name        AS CHARACTER NO-UNDO.
DEFINE VARIABLE get-custom-lists  AS CHARACTER NO-UNDO EXTENT {&MaxUserLists}.
DEFINE VARIABLE get-data-type     AS CHARACTER NO-UNDO.
DEFINE VARIABLE get-display       AS CHARACTER NO-UNDO.
DEFINE VARIABLE get-enable        AS CHARACTER NO-UNDO.
DEFINE VARIABLE get-format        AS CHARACTER NO-UNDO.
DEFINE VARIABLE get-field-source  AS CHARACTER NO-UNDO.
DEFINE VARIABLE get-initial-data  AS CHARACTER NO-UNDO.
DEFINE VARIABLE get-list-items    AS CHARACTER NO-UNDO.
DEFINE VARIABLE get-multiple      AS CHARACTER NO-UNDO.
DEFINE VARIABLE get-object-name   AS CHARACTER NO-UNDO.
DEFINE VARIABLE get-private-data  AS CHARACTER NO-UNDO.
DEFINE VARIABLE get-radio-buttons AS CHARACTER NO-UNDO.
DEFINE VARIABLE get-sort          AS CHARACTER NO-UNDO.
DEFINE VARIABLE has-error         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE html-tag          AS CHARACTER NO-UNDO.
DEFINE VARIABLE html-type         AS CHARACTER NO-UNDO.
DEFINE VARIABLE is-valid          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE i-scrap           AS INTEGER   NO-UNDO.
DEFINE VARIABLE ix                AS INTEGER   NO-UNDO.
DEFINE VARIABLE list-state        AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-scrap           AS LOGICAL   NO-UNDO.
DEFINE VARIABLE old-field-source  AS CHARACTER NO-UNDO. /* prev field source */
DEFINE VARIABLE p-recid           AS RECID     NO-UNDO.
DEFINE VARIABLE param-list        AS CHARACTER NO-UNDO.
DEFINE VARIABLE temp-file         AS CHARACTER NO-UNDO.
DEFINE VARIABLE test-value        AS CHARACTER NO-UNDO.             

DEFINE BUFFER buf_U FOR _U.
DEFINE STREAM outstream.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&SCOPED-DEFINE PROCEDURE-TYPE Procedure
&SCOPED-DEFINE debug false

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by design tool only) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2.38
         WIDTH              = 36.
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web/method/wrap-cgi.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

/* ************************  Main Code Block  *********************** */

/* Find the _U record to display. */   
FIND _U WHERE RECID(_U) eq INTEGER(get-field("field-id":U)) NO-ERROR.
IF AVAILABLE _U THEN DO:
  FIND _P WHERE RECID(_P) EQ _U._P-recid.
  p-recid = RECID(_P).

  IF _U._TYPE = "query":U THEN
    FIND _Q WHERE RECID(_Q) EQ _U._X-recid.
  ELSE DO:
    FIND _F WHERE RECID(_F) EQ _U._X-recid.
    FIND _HTM WHERE _HTM._U-recid eq RECID(_U).
  END.
END.

/* Initialize temporary variables.  We need to do this so that we retain
   these values even if the user POSTs the page using the Show Lists or Hide
   Lists submit buttons.  In these cases, we don't want to assign the data
   to the _U or _F records, but keep them around for a 'real' submit. */
IF REQUEST_METHOD = "GET":U THEN DO:
  DO ix = 1 TO {&MaxUserLists}:
    get-custom-lists[ix] = STRING(_U._USER-LIST[ix],"Yes/No":U).
  END.
  
  IF _U._TYPE <> "query":U THEN
    ASSIGN
      get-data-type     = _F._DATA-TYPE 
      get-display       = IF _U._DISPLAY THEN "Yes":U ELSE "No":U
      get-enable        = IF _U._ENABLE THEN "Yes":U ELSE "No":U
      get-format        = _F._FORMAT
      get-initial-data  = _F._INITIAL-DATA 
      get-field-source  = _U._DEFINED-BY /* Tool, DB, or User */
      old-field-source  = get-field-source
      get-list-items    = _F._LIST-ITEMS 
      get-multiple      = IF _F._MULTIPLE THEN "Yes":U ELSE "No":U
      get-private-data  = _U._PRIVATE-DATA 
      get-radio-buttons = _F._LIST-ITEMS 
      get-sort          = IF _F._SORT THEN "Yes":U ELSE "No":U
      .
      
  get-object-name   = { workshop/name_u.i &U_BUFFER = "_U" }.
END.

/* Output the page. */
RUN OutputContentType IN web-utilities-hdl ('text/html':U).
{&OUT}
  { workshop/html.i 
    &SEGMENTS = "head,open-body,help"                      
    &FRAME    = "WSFI_main" 
    &AUTHOR   = "D.M.Adams"
    &CONTEXT  = "{&Property_Sheet_Help}"
    &TITLE    = "Property Sheet" }
    /* Format the property sheet name like a filename. */
    format-filename (_U._NAME, 'Property Sheet for &1', '')
    get-rule-tag ("100%":U, "") 
    '<BR>~n':U
    .
 
IF NOT AVAILABLE (_U) THEN DO:
  RUN Add-Error IN _err-hdl 
    ("ERROR",?,SUBSTITUTE('Field ID &1 does not exist.',c-field)).
  
  {&OUT}
    '</BODY>~n':U
    '</HTML>~n':U
    .
  RETURN "Error":U.
END.

IF _U._TYPE <> "query":U THEN
  ASSIGN
    html-tag     = (IF _HTM._HTM-TAG = "" OR _HTM._HTM-TAG = ? THEN "~&nbsp;":U 
                     ELSE html-encode(_HTM._HTM-TAG))
    html-type    = (IF _HTM._HTM-TYPE = "" OR _HTM._HTM-TYPE = ? THEN "~&nbsp;":U 
                     ELSE html-encode(_HTM._HTM-TYPE)).

IF REQUEST_METHOD = "POST":U THEN DO:
  IF _U._TYPE <> "query":U THEN DO:
    DO ix = 1 TO {&MaxUserLists}:
      get-custom-lists[ix] = get-value("list-":U + STRING(ix)).
        
      IF get-value("submit":U) <> "" THEN
        ASSIGN
          _P._MODIFIED         = (_P._MODIFIED OR STRING(_U._USER-LIST[ix],"Yes/No":U) <> 
                                    get-custom-lists[ix])
          _U._USER-LIST[ix]    = (IF get-custom-lists[ix] = "Yes":U THEN TRUE ELSE FALSE).
    END.
    
    /* Get variable screen-values. */
    ASSIGN
      get-data-type     = IF get-value("field-source":U) = "DB":U THEN _F._DATA-TYPE 
                          ELSE IF get-value("data-type":U) <> "" THEN get-value("data-type":U)
                          ELSE _F._DATA-TYPE
      get-display       = get-value("display":U)
      get-enable        = get-value("enable":U)
      old-field-source  = IF get-value("old-source":U) = "Local":U THEN "Tool":U
                          ELSE get-value("old-source":U)
      get-field-source  = IF get-value("field-source":U) = "Local":U THEN "Tool":U
                          ELSE get-value("field-source":U)
      get-format        = IF get-value("format":U) <> "" THEN get-value("format":U)
                          ELSE _F._FORMAT
      get-initial-data  = get-value("initial-data":U)
      get-list-items    = TRIM(get-value("list-items":U))
      get-multiple      = get-value("multiple":U)
      get-private-data  = get-value("private-data":U)
      get-sort          = get-value("sort":U)
      get-radio-buttons = get-value("radio-buttons":U)
      .

    IF get-value("submit":U) <> "" THEN DO:
      ASSIGN      
        _P._MODIFIED     = (_P._MODIFIED OR STRING(_U._DISPLAY,"Yes/No":U) <> get-display)
        _U._DISPLAY      = (IF get-display = "Yes":U THEN TRUE ELSE FALSE)
        _P._MODIFIED     = (_P._MODIFIED OR STRING(_U._ENABLE,"Yes/No":U) <> get-enable)
        _U._ENABLE       = (IF get-enable = "Yes":U THEN TRUE ELSE FALSE)
        _P._MODIFIED     = (_P._MODIFIED OR _U._PRIVATE-DATA <> get-private-data)
        _U._PRIVATE-DATA = get-private-data
        .
        
      /* Validate data-type based on the field's format. */    
      RUN validate-type (get-format,"Format",get-data-type,OUTPUT has-error).
      IF NOT has-error THEN
        ASSIGN
          _P._MODIFIED     = (_P._MODIFIED OR _F._DATA-TYPE <> get-data-type)
          _F._DATA-TYPE    = get-data-type.
      ELSE
        ASSIGN
          ftv-error    = TRUE
          bad-datatype = TRUE.
      
      /* Validate initial-value based on field's datatype. */    
      RUN validate-type (get-initial-data,"Initial Value",get-data-type,OUTPUT has-error).
      IF NOT has-error AND NOT ftv-error THEN
        ASSIGN
          _P._MODIFIED     = (_P._MODIFIED OR _F._INITIAL-DATA <> get-initial-data)
          _F._INITIAL-DATA = get-initial-data
          .
      ELSE
        ftv-error = TRUE.
    END.
    has-error = FALSE.
    
    CASE _U._TYPE:
      /* Validate the Format attribute. */
      WHEN "fill-in":U THEN DO:
        test-value = get-format.
        
        CASE get-data-type:
          WHEN "character":U THEN DO:
            temp-file = "tmp":U + STRING(RANDOM(1,99999),"99999":U) + ".wdt":U.
            OUTPUT STREAM outstream TO VALUE(temp-file) NO-MAP.
            PUT STREAM outstream UNFORMATTED
              'DEFINE VARIABLE aFillIn AS ':U get-data-type ' FORMAT "':U test-value '".':U SKIP.
            OUTPUT STREAM outstream CLOSE.
            COMPILE VALUE(temp-file) NO-ERROR.
            IF COMPILER:ERROR THEN has-error = TRUE.
            OS-DELETE VALUE(temp-file) NO-ERROR.
          END.
          WHEN "date":U THEN DO:
            ASSIGN c-scrap = STRING(TODAY,test-value) NO-ERROR.
            IF ERROR-STATUS:ERROR AND c-scrap NE ? THEN has-error = TRUE.
          END.
          WHEN "decimal":U THEN DO:
            /* Assuming that Progress was invoked in -E format, make sure that the 
               value is stored in the American format */
            IF SESSION:NUMERIC-FORMAT = "EUROPEAN":U THEN
              RUN adecomm/_convert.p ("E-TO-A":U,test-value,OUTPUT test-value).
              
            ASSIGN c-scrap = STRING(DECIMAL("123.45":U),test-value) NO-ERROR.
            IF ERROR-STATUS:ERROR AND c-scrap NE ? THEN has-error = TRUE.
          END.
          WHEN "integer":U THEN DO:
            /* Assuming that Progress was invoked in -E format, make sure that the 
               value is stored in the American format */
            IF SESSION:NUMERIC-FORMAT = "EUROPEAN":U THEN
              RUN adecomm/_convert.p ("E-TO-A":U,test-value,OUTPUT test-value).
              
            ASSIGN c-scrap = STRING(INTEGER("12345":U),test-value) NO-ERROR.
            IF ERROR-STATUS:ERROR AND c-scrap NE ? THEN has-error = TRUE.
          END.
          WHEN "logical":U THEN
            IF NUM-ENTRIES(test-value,"/":U) NE 2 THEN has-error = TRUE.
        END CASE.
        
        IF has-error AND NOT bad-datatype THEN
          RUN Add-Error IN _err-hdl ("VALIDATION":U,?,
            SUBSTITUTE("&1 is an invalid &2 format.  Remaining valid changes were saved.",
            test-value,LC(get-data-type))).
        ELSE IF get-value("submit":U) <> "" AND NOT ftv-error THEN
          ASSIGN
            _P._MODIFIED = (_P._MODIFIED OR _F._FORMAT <> get-format)
            _F._FORMAT   = get-format.
      END. /* IF _U._TYPE = "fill-in":U */
      
      WHEN "selection-list":U THEN DO:
        IF get-value("submit":U) <> "" THEN DO:
          RUN validate-type (get-list-items,"List Items",get-data-type,OUTPUT has-error).
          IF NOT has-error THEN
            ASSIGN
              _P._MODIFIED   = (_P._MODIFIED OR _F._LIST-ITEMS <> get-list-items)
              _F._LIST-ITEMS = get-list-items.
        
          ASSIGN
            _P._MODIFIED   = (_P._MODIFIED OR STRING(_F._MULTIPLE,"Yes/No":U) <> get-multiple)
            _F._MULTIPLE   = (IF get-multiple = "Yes":U THEN TRUE ELSE FALSE) 
            _P._MODIFIED   = (_P._MODIFIED OR STRING(_F._SORT,"Yes/No":U) <> get-sort)
            _F._SORT       = (IF get-sort = "Yes":U THEN TRUE ELSE FALSE)
            .
        END.
      END. /* _U._TYPE = "selection-list" */
    
      WHEN "radio-set":U THEN DO:
        IF get-value("submit":U) <> "" THEN DO:
          IF get-radio-buttons <> "" THEN DO:
            RUN validate-rbs (get-radio-buttons,get-data-type).
            IF RETURN-VALUE = "Error":U THEN RETURN "Error":U.
          END.
  
          ASSIGN
            _P._MODIFIED   = (_P._MODIFIED OR _F._LIST-ITEMS <> get-radio-buttons)
            _F._LIST-ITEMS = get-radio-buttons.
        END.
      END.
    END CASE.
  END. /* not a query field */
      
  IF get-value("submit":U) <> "" THEN DO:
    ASSIGN
      get-object-name = TRIM(get-value("object_name":U))       /* new value */
      c-scrap         = { workshop/name_u.i &U_BUFFER = "_U" } /* old value */
      c-field         = ?
      c-database      = ?
      c-table         = ?
      has-error       = FALSE.
      .

    IF INDEX(get-object-name,' ':U) > 0 THEN DO:
      RUN Add-Error IN _err-hdl ("VALIDATION":U,?,"WebSpeed Field is invalid because it contains a space.  Remaining valid changes were saved.").
    END.
    ELSE DO:
      CASE NUM-ENTRIES(get-object-name,".":U):
        WHEN 0 THEN DO:
          RUN Add-Error IN _err-hdl ("VALIDATION":U,?,"Webspeed Field is blank and must contain a value. Remaining valid changes were saved.").
          has-error = TRUE.
        END.
        WHEN 1 THEN DO:
          ASSIGN 
            c-field    = ENTRY(1,get-object-name,".":U).
          FIND FIRST buf_U WHERE buf_U._P-recid = p-recid AND 
            RECID(buf_U) <> RECID(_U) AND buf_U._NAME eq c-field NO-ERROR.
        END.
        WHEN 2 THEN DO:
          ASSIGN 
            c-field    = ENTRY(2,get-object-name,".":U)
            c-table    = ENTRY(1,get-object-name,".":U).
          FIND FIRST buf_U WHERE buf_U._P-recid = p-recid AND 
            RECID(buf_U) <> RECID(_U) AND buf_U._TABLE eq c-table AND 
            buf_U._NAME eq c-field NO-ERROR.
        END.
        WHEN 3 THEN DO:
          ASSIGN 
            c-field    = ENTRY(3,get-object-name,".":U)
            c-table    = ENTRY(2,get-object-name,".":U)
            c-database = ENTRY(1,get-object-name,".":U).
          FIND FIRST buf_U WHERE buf_U._P-recid = p-recid AND 
            RECID(buf_U) <> RECID(_U) AND buf_U._DBNAME eq c-database AND 
            buf_U._TABLE eq c-table AND	buf_U._NAME eq c-field NO-ERROR.
        END.
        OTHERWISE DO:
          RUN Add-Error IN _err-hdl ("VALIDATION":U,?,"WebSpeed Field name has more than three parts; database, table, and field.  Remaining valid changes were saved.").
          has-error = TRUE.
        END.
      END CASE.

      IF NOT has-error THEN DO:
        /* If buf_U is available, then we have a duplicate field, so raise error. */
        IF AVAILABLE buf_U THEN DO:
          RUN Add-Error IN _err-hdl ("VALIDATION":U,?,
            SUBSTITUTE("&1 cannot be changed to &2, since an object already exists with that name. Remaining valid changes were saved."
            ,c-scrap,get-object-name)).
        END.
    
        /* Check to see if it's a valid DB name. */
        ELSE IF get-field-source = "DB":U THEN DO:
          ASSIGN
            c-scrap   = ?
            has-error = FALSE.
            
          IF NUM-ENTRIES(get-object-name,".":U) > 1 THEN
            RUN webutil/_fldtype.p (get-object-name, OUTPUT c-scrap).
          
          /* Field is not a valid DB name, so make sure it's a valid WebSpeed name. 
             Check all WebSpeed field name components. */
          IF c-scrap = ? THEN DO:
            IF c-database <> ? THEN DO:
              RUN workshop/_valname.p (c-database,OUTPUT is-valid).
              IF NOT is-valid THEN has-error = TRUE.
            END.
            IF c-table <> ? THEN DO:
              RUN workshop/_valname.p (c-table,OUTPUT is-valid).
              IF NOT is-valid THEN has-error = TRUE.
            END.
            IF c-field <> ? THEN DO:
              RUN workshop/_valname.p (c-field,OUTPUT is-valid).
              IF NOT is-valid THEN has-error = TRUE.
            END.
            
            IF has-error THEN
              RUN Add-Error IN _err-hdl ("VALIDATION":U,?,
                SUBSTITUTE("&1 is an invalid name. Remaining valid changes were saved.",
                get-object-name)).
          END.

          IF NOT has-error THEN DO:
            RUN validate-fields (get-object-name, c-database, c-table, c-field, 
                                 get-field-source, OUTPUT l-scrap).
                                 
            IF l-scrap THEN /* validation was successful */
              ASSIGN
                get-object-name  = { workshop/name_u.i &U_BUFFER = "_U" }
                _P._MODIFIED     = (_P._MODIFIED OR _U._DBNAME <> c-database 
                                    OR _U._TABLE <> c-table OR _U._NAME <> c-field)
                get-field-source = "DB":U
                _P._MODIFIED     = (_P._MODIFIED OR _U._DEFINED-BY <> "DB":U)
                _U._DEFINED-BY   = "DB":U
                .
            /* Restore Field Source to its previous value. */
            ELSE
              get-field-source = _U._DEFINED-BY.
          END.
          
          /* Restore Field Source to its previous value. */
          ELSE
            get-field-source = _U._DEFINED-BY.
        END.
        
        /* get-field-source = "Tool" or "User" */
        ELSE DO:
          RUN validate-fields (get-object-name, c-database, c-table, c-field, 
                               get-field-source, OUTPUT l-scrap).
          
          IF l-scrap THEN /* validation was successful */
            ASSIGN
              get-object-name  = { workshop/name_u.i &U_BUFFER = "_U" } 
              _P._MODIFIED     = (_P._MODIFIED OR _U._DEFINED-BY <> get-field-source)
              _U._DEFINED-BY   = get-field-source
              .
        END.
      END. /* NOT has-error */
      
      /* Revert get-field-source to previous value. */
      ELSE
        get-field-source = _U._DEFINED-BY.
    END. /* is-valid */
    
    old-field-source = get-field-source.
  END. /* IF get-value("submit":U) <> "" */
  
  /* Show errors */
  IF errors-exist ("VALIDATION":U) THEN DO:
    {&OUT} '<UL>' format-text ('Errors:', "SUBMIT":U)
           '<UL>'.
    RUN output-errors IN _err-hdl ("VALIDATION":U, ? /* Use default template */ ).
    {&OUT} '</UL></UL><CENTER>~n':U.
  END.
END. /* Submit button POST */

/* Add Javascript to validate fields (for spaces, invalid characters, etc. */
{&OUT}
  '<SCRIPT LANGUAGE="JavaScript"> ~n'
  '<~!-- ~n' 
  { workshop/chkfld.i &no-tag = "yes" }
  'function chgSrc(what) ~{ ~n ':U
  '  var k = what.value.lastIndexOf(".")~; ~n':U
  '  what.value = what.value.substring(k+1, what.value.length)~; ~n ':U
  '  return true~; ~n ':U
  ' ~} ~n ':U
  '//-->~n':U
  '</SCRIPT>~n':U.
 
IF REQUEST_METHOD = "GET":U THEN
  list-state = "hide":U.
ELSE DO:
  IF get-value("show-lists":U) <> "" THEN 
    ASSIGN
      get-object-name = TRIM(get-value("object_name":U)) 
      list-state      = "display":U.
  IF get-value("hide-lists":U) <> "" THEN 
    ASSIGN
      get-object-name = TRIM(get-value("object_name":U)) 
      list-state      = "hide":U.
  IF list-state = "" THEN list-state = get-value("list-state":U).
END.
    
{&OUT}
  '<CENTER>~n':U
  '<FORM METHOD="POST">~n':U
  '<CENTER>~n':U
  '<INPUT TYPE="SUBMIT" NAME="submit" VALUE="Submit">~n':U
  '<INPUT TYPE="RESET" VALUE="Reset">~n':U
  '<INPUT TYPE="HIDDEN" NAME="list-state" VALUE="':U list-state '">~n':U
  '<INPUT TYPE="HIDDEN" NAME="old-source" VALUE="':U old-field-source '">~n':U
  .
  
  /* If custom lists are hidden, we need to keep their values around until user
     wants to POST. */
  IF list-state = "hide":U THEN
    DO ix = 1 TO {&MaxUserLists}:
      {&OUT}
        '<INPUT TYPE="HIDDEN" NAME="list-':U ix '" VALUE="':U get-custom-lists[ix] '">~n':U.
    END.
  
  {&OUT}
    '</CENTER><BR>~n':U
    '<TABLE':U get-table-phrase("") '>~n':U.
  
IF _U._TYPE <> "query":U THEN DO:
  {&OUT}
    '<TR>~n':U
    '  <TD ALIGN="RIGHT">' format-label ('Custom Lists', 'ROW', '') '</TD>~n':U.

  IF list-state = "hide":U OR list-state = "":U THEN
    {&OUT}
      '  <TD ALIGN="CENTER"><INPUT TYPE="SUBMIT" NAME="show-lists" VALUE="Show Lists"></TD>~n':U
      '</TR>~n':U.
  ELSE IF list-state = "display":U THEN DO:
    {&OUT}
      '  <TD ALIGN="CENTER"><INPUT TYPE="SUBMIT" NAME="hide-lists" VALUE="Hide Lists"></TD>~n':U
      '</TR>~n':U.

    DO ix = 1 TO {&MaxUserLists}:
      {&OUT}
        '<TR>~n':U
        '  <TD ALIGN="RIGHT">' format-label (ENTRY(ix,_P._LISTS), "ROW":U, "") '</TD>~n':U
        '  <TD><INPUT TYPE="RADIO" NAME="list-':U ix '" VALUE="Yes"':U
                 (IF get-custom-lists[ix] = "Yes":U THEN " CHECKED":U ELSE "") '>Yes~n':U
        '      <INPUT TYPE="RADIO" NAME="list-':U ix '" VALUE="No"':U
                 (IF get-custom-lists[ix] = "No":U THEN " CHECKED":U ELSE "") '>No</TD>~n':U
        '</TR>~n':U.
    END.
  END.
    
  {&OUT}    
    '<TR>~n':U
    '  <TD ALIGN="RIGHT">' format-label ('Display', "ROW":U, "") '</TD>~n':U
    '  <TD><INPUT TYPE="RADIO" NAME="display" VALUE="Yes"':U
             (IF get-display = "Yes":U THEN " CHECKED":U ELSE "") '>Yes~n':U
    '      <INPUT TYPE="RADIO" NAME="display" VALUE="No"':U
             (IF get-display = "No":U THEN " CHECKED":U ELSE "") '>No</TD>~n':U
    '</TR>~n':U
    '<TR>~n':U
    '  <TD ALIGN="RIGHT">' format-label ('Enable', "ROW":U, "") '</TD>~n':U 
    '  <TD><INPUT TYPE="RADIO" NAME="enable" VALUE="Yes"':U
             (IF get-enable = "Yes":U THEN " CHECKED":U ELSE "") '>Yes~n':U
    '      <INPUT TYPE="RADIO" NAME="enable" VALUE="No"':U
             (IF get-enable = "No":U THEN " CHECKED":U ELSE "") '>No</TD>~n':U
    '</TR>~n':U
    '<TR>~n':U
    '  <TD ALIGN="RIGHT">' format-label ('Field Source', "ROW":U, "") '</TD>~n':U 
    '  <TD><INPUT TYPE="RADIO" NAME="field-source" VALUE="Local"':U
    ' onClick="chgSrc(form.object_name); "':U
             (IF get-field-source EQ "Tool":U OR get-field-source EQ "" THEN " CHECKED":U ELSE "") '>Local~n':U
    '      <INPUT TYPE="RADIO" NAME="field-source" VALUE="DB"':U
             (IF get-field-source EQ "DB":U THEN " CHECKED":U ELSE "") '>DB~n':U
    '      <INPUT TYPE="RADIO" NAME="field-source" VALUE="User"':U
             (IF get-field-source EQ "User":U THEN " CHECKED":U ELSE "") '>User</TD>~n':U
    '</TR>~n':U
    .
    
  IF _U._TYPE = "fill-in":U THEN
    {&OUT}
      '<TR>~n':U
      '  <TD ALIGN="RIGHT">' format-label ('Format', "ROW":U, "") '</TD>~n':U 
      '  <TD><INPUT TYPE="TEXT" NAME="format" VALUE="':U html-encode(get-format)
        '"></TD>~n':U
      '</TR>~n':U
      .
      
  {&OUT}
    '<TR>~n':U
    '  <TD ALIGN="RIGHT">' format-label ('HTML Field', "ROW":U, "") '</TD>~n':U 
    '  <TD>':U _HTM._HTM-NAME '</TD>~n':U
    '</TR>~n':U
    '<TR>~n':U
    '  <TD ALIGN="RIGHT">' format-label ('HTML Tag', "ROW":U, "") '</TD>~n':U          
    '  <TD>':U html-tag '</TD>~n':U
    '</TR>~n':U
    '<TR>~n':U
    '  <TD ALIGN="RIGHT">' format-label ('HTML Type', "ROW":U, "") '</TD>~n':U          
    '  <TD>':U html-type '</TD>~n':U
    '</TR>~n':U
    .
    
  IF get-field-source <> "DB":U THEN
    {&OUT}
      '<TR>~n':U
      '  <TD ALIGN="RIGHT">' format-label ('Initial Value', "ROW":U, "") '</TD>~n':U          
      '  <TD><INPUT TYPE="TEXT" NAME="initial-data" VALUE="':U html-encode(get-initial-data) 
        '"></TD>~n':U
      '</TR>~n':U
      .
      
  IF _U._TYPE = "selection-list":U THEN
    {&OUT}
      '<TR>~n':U
      '  <TD ALIGN="RIGHT">' format-label ('List-Items', "ROW":U, "") '</TD>~n':U          
      '  <TD><TEXTAREA NAME="list-items" ROWS="4" COLS="25">':U
        html-encode(get-list-items) '</TEXTAREA></TD>~n':U
      '</TR>~n':U
      '<TR>~n':U
      '  <TD ALIGN="RIGHT">' format-label ('Multiple', "ROW", "") '</TD>~n':U
      '  <TD><INPUT TYPE="RADIO" NAME="multiple" VALUE="Yes"':U
               (IF get-multiple = "Yes":U THEN " CHECKED":U ELSE "") '>Yes~n':U
      '      <INPUT TYPE="RADIO" NAME="multiple" VALUE="No"':U
               (IF get-multiple = "No":U THEN " CHECKED":U ELSE "") '>No</TD>~n':U
      '</TR>~n':U
      .
  
  {&OUT}
    '<TR>~n':U
    '  <TD ALIGN="RIGHT">' format-label ('Private-Data', "ROW":U, "") '</TD>~n':U          
    '  <TD><INPUT TYPE="TEXT" NAME="private-data" VALUE="':U html-encode(get-private-data)
        '"></TD>~n':U
    '</TR>~n':U
    .
  
  IF _U._TYPE = "radio-set":U THEN
    {&OUT}
      '<TR>~n':U
      '  <TD ALIGN="RIGHT">' format-label ('Radio-Buttons', "ROW":U, "") '</TD>~n':U          
      '  <TD><TEXTAREA NAME="radio-buttons" ROWS="4" COLS="25">':U
        html-encode(get-radio-buttons) '</TEXTAREA></TD>~n':U
      '</TR>~n':U
      .
      
  IF _U._TYPE = "selection-list":U THEN
    {&OUT}
      '<TR>~n':U
      '  <TD ALIGN="RIGHT">' format-label ('Sort', "ROW":U, "") '</TD>~n':U          
      '  <TD><INPUT TYPE="RADIO" NAME="sort" VALUE="Yes"':U
               (IF get-sort = "Yes":U THEN " CHECKED":U ELSE "") '>Yes~n':U
      '      <INPUT TYPE="RADIO" NAME="sort" VALUE="No"':U
               (IF get-sort = "No":U THEN " CHECKED":U ELSE "") '>No</TD>~n':U
      '</TR>~n':U
    .
END. /* not a query field */
    
{&OUT}
  '<TR>~n':U
  '  <TD ALIGN="RIGHT">' format-label ('WebSpeed Field', "ROW":U, "") '</TD>~n':U          
  '  <TD><INPUT TYPE="TEXT" NAME="object_name" VALUE="':U 
         html-encode(get-object-name) '" onChange="chkFld(this);"></TD>~n':U
  '</TR>~n':U
  '<TR>~n':U
  '  <TD ALIGN="RIGHT">' format-label ('WebSpeed Type', "ROW":U, "") '</TD>~n':U          
  .
 
IF get-field-source = "DB":U OR _U._TYPE = "query":U THEN
  {&OUT}
    '  <TD>':U (IF _U._TYPE = "query":U THEN _U._TYPE ELSE get-data-type) '</TD>~n':U.
ELSE
  {&OUT}
    '  <TD><SELECT NAME="data-type">~n':U
    '        <OPTION':U (IF get-data-type = "character":U THEN ' SELECTED':U ELSE '') '>Character~n':U
    '        <OPTION':U (IF get-data-type = "date":U      THEN ' SELECTED':U ELSE '') '>Date~n':U
    '        <OPTION':U (IF get-data-type = "decimal":U   THEN ' SELECTED':U ELSE '') '>Decimal~n':U
    '        <OPTION':U (IF get-data-type = "integer":U   THEN ' SELECTED':U ELSE '') '>Integer~n':U
    '        <OPTION':U (IF get-data-type = "logical":U   THEN ' SELECTED':U ELSE '') '>Logical~n':U
    '      </SELECT></TD>~n':U.
    
{&OUT}
  '</TR>~n':U
  '</TABLE>~n':U
  '</FORM>~n':U    
  '</CENTER>~n':U
  '</BODY>~n'
  '</HTML>~n'
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE validate-rbs
PROCEDURE validate-rbs:
/*------------------------------------------------------------------------------
  Purpose:     Validate radio-button item values
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pRadio AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pDType AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE tmp-label AS CHARACTER NO-UNDO.
  
  IF NUM-ENTRIES(pRadio) MOD 2 eq 0 THEN DO:
    DO ix = 1 TO NUM-ENTRIES(pRadio) BY 2:
      tmp-label = TRIM(ENTRY(ix,pRadio)).
      IF NOT tmp-label BEGINS "~"":U AND NOT tmp-label BEGINS "~'":U THEN
        ENTRY(ix,pRadio) = (IF ix > 1 THEN CHR(10) ELSE "":U) +
                           '~"':U + tmp-label + '~"':U.
    END.
    
    temp-file = "tmp":U + STRING(RANDOM(1,99999),"99999":U) + ".wdt":U.
          
    OUTPUT STREAM outstream TO VALUE(temp-file) NO-MAP.
    PUT STREAM outstream UNFORMATTED
      "DEFINE VARIABLE aRadioSet AS ":U pDType SKIP 
      "     VIEW-AS RADIO-SET RADIO-BUTTONS":U SKIP 
      "     ":U pRadio ".":U SKIP.
    OUTPUT STREAM outstream CLOSE.
    
    COMPILE VALUE(temp-file) NO-ERROR.
    IF COMPILER:ERROR THEN DO:
      RUN Add-Error IN _err-hdl ("VALIDATION":U,?,
        SUBSTITUTE("Invalid Radio-Button(s) definition or datatype: &1",
          ERROR-STATUS:GET-MESSAGE(1))).
      RETURN "Error":U.
    END. /* compiler error */
    
    OS-DELETE VALUE(temp-file) NO-ERROR.
  END. /* valid radio list */
  
  /* Check for odd number of radio-item tokens */
  ELSE DO:
    RUN Add-Error IN _err-hdl ("VALIDATION":U,?,
      "Radio-Buttons must have an even number of elements. Update not saved.").
    RETURN "Error":U.
  END.
    
  /* Check for blank radio-item token */
  DO ix = 1 TO NUM-ENTRIES(get-radio-buttons):
    IF TRIM(ENTRY(ix,get-radio-buttons)) = "" THEN DO:
      RUN Add-Error IN _err-hdl ("VALIDATION":U,?,
        "At least one Radio-Buttons element is blank. Update not saved.").
      RETURN "Error":U.
    END.
  END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE validate-fields 
PROCEDURE validate-fields :
/*------------------------------------------------------------------------------
  Purpose:  Validate the WebSpeed Field name
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pName     AS CHARACTER NO-UNDO. /* screen-value */
  DEFINE INPUT  PARAMETER pDatabase AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pTable    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pField    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pSource   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pSuccess  AS LOGICAL   NO-UNDO.
  
  DEFINE VARIABLE data-base     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE db-found      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE err-cnt       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE field-cnt     AS INTEGER   NO-UNDO. /* found field counter */
  DEFINE VARIABLE fld-ok        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE ix            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ldb-name      AS CHARACTER NO-UNDO. /* logical db name */
  DEFINE VARIABLE map-found     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE name-err      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE old-count     AS INTEGER   NO-UNDO. /* prev field counter */
  DEFINE VARIABLE valid-name    AS LOGICAL   NO-UNDO.

  IF pSource = "DB":U THEN DO:
    /* If we have db.table.name, _fldtype.p will return its datatype if it can
       find the field, otherwise it will return ?. */
    IF NUM-ENTRIES(pName,".":U) = 3 THEN DO:
      RUN webutil/_fldtype.p (pname, OUTPUT c-scrap).
      IF c-scrap <> ? AND c-scrap <> "" THEN 
        map-found = yes.
    END.
    ELSE DO:
      /* This loop's purpose is to determine if the field is ambiguous, i.e. not 
         fully qualified and more than one table.field or field with the same
         name exists somewhere. Also used in workshop/_htmlmap.w. We should put 
         this in a separate file and call it from here and from _htmlmap.w. */
      DO ix = 1 TO NUM-DBS:
        IF DBTYPE(ix) eq "PROGRESS":U THEN
          ASSIGN data-base = LDBNAME(ix). 
        ELSE NEXT.

        /* Is field name ambiguous? If so, we can't automatically map it. */
        CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(data-base).
        ASSIGN old-count = field-cnt.
        RUN workshop/_fldcnt.p (RECID(_U), pName, INPUT-OUTPUT field-cnt).
        
        /* We found a live one, so save off the db's LDBNAME in case this is the
           only occurance of this field in all connected databases. */
        IF field-cnt > old-count THEN
          ldb-name = data-base.
      END.

      /* If field name is not ambiguous let's attempt to map it. */
      IF field-cnt = 1 THEN DO:
        CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(ldb-name).
        /* If we don't have a database name, try to map what we have.  If 
           successful, _mapfld will update _U._DBNAME, _U._TABLE, and _U._NAME,
           as well as other _U fields. */
        RUN workshop/_mapfld.p (RECID(_U), pName, OUTPUT map-found).
  
        IF map-found THEN
          pTable = _U._TABLE.
      END.
    END.

    IF NOT map-found THEN DO:
      err-cnt = err-cnt + 1.	
      If err-cnt = 1 THEN    
        {&OUT} 
           { workshop/javascpt.i &SEGMENTS = "goto-Field" }
           format-text ('The following errors were detected. (Remaining valid changes were saved):',
                        'SUBMIT':U)
           '<BR>~n':U.

      IF NUM-DBS > 0 THEN DO:
        IF field-cnt = 0 THEN
          {&OUT}
            format-error ('** Field &1 was not found in database.~n', pName, "").
        ELSE IF field-cnt > 1 THEN
          {&OUT}
            format-error ('** Field &1 was found more than once in database.~n', pName, "")
            '<BR>~n'.
      END.
      ELSE
        {&OUT}
          format-error ('** There are no connected databases, so the field could not be verified. ~n', "", "").
    END.
    ELSE DO:
      RUN workshop/_chkfld.p (RECID(_U), pTable, pField, pSource, OUTPUT fld-ok).
      IF fld-ok THEN
        pSuccess = TRUE.
    END.
  END.  /* When "DB" */
     
  ELSE IF CAN-DO("Tool,User":U,pSource) THEN DO:
    name-err = 0.
    DO ix = 1 to NUM-ENTRIES(pName,".":U):
      RUN workshop/_valname.p (TRIM(ENTRY(ix,pName,".":U)), OUTPUT valid-name).
      IF NOT valid-name THEN DO:
        ASSIGN
          err-cnt  = err-cnt + 1
          name-err = name-err + 1.
          
        If err-cnt = 1 THEN    
         {&OUT} 
           { workshop/javascpt.i &SEGMENTS = "goto-Field" }   
           format-text ('The following errors were detected. (Remaining valid changes were saved):',   
                        'SUBMIT':U)   
           '<BR>~n':U    
           format-error ('** Name &1 is not a valid name.', ENTRY(ix,pName,".":U), "":U) 
          '[<A HREF="Javascript:GotoField(~'object_name~')~;">goto field</A>]<BR>~n':U.
      END.
    END.

    /* Don't want to use workshop/_chkfld.p here because of the side-effect of
       blowing away data-type, format, and initial-data. */
    ASSIGN
      _U._DBNAME = ?
      _U._TABLE  = TRIM(pTable)
      _U._NAME   = TRIM(pField)
      pSuccess   = TRUE.

  END.  /* End Local or User */
END PROCEDURE.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE validate-type
PROCEDURE validate-type:
/*------------------------------------------------------------------------------
  Purpose:  Validate a field based on its datatype
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pValue      AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pAttribute  AS CHARACTER NO-UNDO. /* attribute */
  DEFINE INPUT  PARAMETER pDataType   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pError      AS LOGICAL   NO-UNDO. 

  DEFINE VARIABLE c-scrap    AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE da-scrap   AS DATE      NO-UNDO INITIAL TODAY. /* scrap */
  DEFINE VARIABLE de-scrap   AS DECIMAL   NO-UNDO. /* scrap */
  DEFINE VARIABLE l-scrap    AS LOGICAL   NO-UNDO. /* scrap */
  DEFINE VARIABLE ix         AS INTEGER   NO-UNDO. /* loop */
  DEFINE VARIABLE test-value AS CHARACTER NO-UNDO.
    
  /* pValue may contain a list of comma-separated items, especially for 
     selection-lists.  Loop through the values, insuring that items entered
     are valid for the datatype. Selection-list items are CHR(10)-delimited. */
  DO ix = 1 TO NUM-ENTRIES(pValue,CHR(10)):
    ASSIGN
      test-value = ENTRY(ix,pValue,CHR(10))
      l-scrap    = FALSE.
      
    CASE pDataType:
      WHEN "date":U THEN DO:
        IF pAttribute = "format":U THEN DO:
          ASSIGN c-scrap = STRING(TODAY,test-value) NO-ERROR.
          ASSIGN l-scrap = (ERROR-STATUS:ERROR OR c-scrap EQ ?).
        END.
        ELSE DO:
          ASSIGN da-scrap = DATE(test-value) NO-ERROR.
          ASSIGN l-scrap  = (ERROR-STATUS:ERROR OR da-scrap EQ ?).
        END.
        IF l-scrap THEN pError = TRUE.

        &IF {&debug} &THEN
        RUN Add-Error IN _err-hdl ("VALIDATION":U,?,string(da-scrap)).
        &ENDIF
     
      END.
      WHEN "decimal":U THEN DO:
        /* Assuming that Progress was invoked in -E format, make sure that the 
           value is stored in the American format */
        IF SESSION:NUMERIC-FORMAT = "EUROPEAN":U THEN
          RUN adecomm/_convert.p ("E-TO-A":U,test-value,OUTPUT test-value).
          
        ASSIGN de-scrap = DECIMAL(test-value) NO-ERROR.
        IF ERROR-STATUS:ERROR OR de-scrap EQ ? THEN
          ASSIGN
            l-scrap   = TRUE
            pError    = TRUE.
      END.
      WHEN "integer":U THEN DO:
        /* Assuming that Progress was invoked in -E format, make sure that the 
           value is stored in the American format */
        IF SESSION:NUMERIC-FORMAT = "EUROPEAN":U THEN
          RUN adecomm/_convert.p ("E-TO-A":U,test-value,OUTPUT test-value).
          
        ASSIGN i-scrap = INTEGER(test-value) NO-ERROR.
        IF ERROR-STATUS:ERROR OR i-scrap EQ ? OR
          (i-scrap = 0 AND test-value <> "0") THEN
          ASSIGN
            l-scrap   = TRUE
            pError    = TRUE.
      END.
      WHEN "logical":U THEN DO:
        IF pAttribute = "format":U THEN DO:
          IF NUM-ENTRIES(test-value,"/":U) NE 2 THEN
            ASSIGN
              l-scrap   = TRUE
              pError    = TRUE.
        END.
        ELSE DO:
          IF NOT CAN-DO("yes,no,true,false",test-value) THEN
            ASSIGN
              l-scrap   = TRUE
              pError    = TRUE.
        END.
      END.
    END CASE.
  
    IF l-scrap THEN
      RUN Add-Error IN _err-hdl ("VALIDATION":U,?,
        SUBSTITUTE("&1 is an invalid &2 value for a field with &3 datatype.  Remaining valid changes were saved.",
        test-value,pAttribute,LC(pDataType))).
  END. /* DO ix */

END PROCEDURE.

&ANALYZE-RESUME

/* _proprty.w - end of file */
