&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 WebSpeed-Object
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
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
/*------------------------------------------------------------------------
  File: _htmlmap.w
  
  Description: List the HTML fields in a web object and allows the
               user to change the mapping between:
                   * local names
                   * user-defined names
                   * db fields
  
  Notes: This routine is also the jumping off point for the HTML mapping
         wizard.

  Parameters:  p_proc-id -- context id of the file
               p_options -- comma delimeted list of additional options
                  "NO-HEAD" -- don't show the <HTML><HEAD><BODY> tags
                     
  Author:  Wm. T. Wood
  Created: Feb. 11, 1997
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_proc-id  AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER p_options  AS CHARACTER NO-UNDO.

/* Included Definitions ---                                             */
{ webutil/wstyle.i }        /* Standard style definitions.              */
{ workshop/errors.i }
{ workshop/help.i }         /* Help Context Strings.                    */
{ workshop/htmwidg.i }      /* Design time Web _HTM TEMP-TABLE.         */
{ workshop/objects.i }      /* Web Objects TEMP-TABLE definition        */
{ workshop/sharvars.i }     /* Common Shared variables.                 */
{ workshop/uniwidg.i }      /* Universal Widget TEMP-TABLE definition   */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE ldb-name   AS CHARACTER NO-UNDO. /* logical db name */
DEFINE VARIABLE field-cnt  AS INTEGER   NO-UNDO. /* found field counter */
DEFINE VARIABLE old-count  AS INTEGER   NO-UNDO. /* prev field counter */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&SCOPED-DEFINE PROCEDURE-TYPE WebSpeed-Object
&SCOPED-DEFINE debug false

&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* ************************* Included-Libraries *********************** */

{ src/web/method/wrap-cgi.i }
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 

/* ************************  Main Code Block  *********************** */

FUNCTION use_dspname RETURNS LOGICAL (H4glname AS CHAR, dspname AS CHAR):
  IF dspname eq "" THEN RETURN no.
  CASE NUM-ENTRIES(dspname, ".":U):
    WHEN 1 THEN DO: 
      IF NUM-ENTRIES(H4glname, ".":U) eq 1 THEN
        IF (H4glname ne TRIM(dspname)) THEN
          RETURN yes.
      IF NUM-ENTRIES(H4glname, ".":U) eq 2 AND 
        (ENTRY(2, H4glname, ".":U) ne TRIM(dspname)) THEN 
        RETURN yes. 
    END.
    WHEN 2 THEN DO: 
      IF NUM-ENTRIES(H4glname, ".":U) eq 1 THEN 
        RETURN yes.
      IF NUM-ENTRIES(H4glname, ".":U) eq 2 THEN 
        IF (ENTRY(1, dspname, ".":U)) ne (ENTRY(1, H4glname, ".":U)) OR 
          (ENTRY(2, dspname, ".":U)) ne (ENTRY(2, H4glname, ".":U)) THEN
          RETURN yes.
    END.
  END CASE.

  RETURN no. 
END FUNCTION.

RUN output-mapping-doc.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE list-field 
PROCEDURE list-fields :
/*------------------------------------------------------------------------------
  Purpose:    Lists all the HTML fields in this web object
  Parameters:  p_action - Indicates automap or submit was pressed. 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_action AS CHARACTER.

  DEFINE VARIABLE h_4glName  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE h_HtmlName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE icon-name  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tmpname    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE dspname    AS CHARACTER NO-UNDO.
  
  /* Loop though all the objects. */
  FOR EACH _U WHERE _U._P-recid eq p_proc-id,
    EACH _HTM WHERE _HTM._U-recid eq RECID(_U)
    BY _HTM._HTM-NAME:
        
    /* Convert the 4GL and HTML names from pure ASCII to HTML. */ 
    h_4glName = { workshop/name_u.i &U_BUFFER = "_U" }.

    RUN AsciiToHtml IN web-utilities-hdl (h_4glName,      OUTPUT h_4glName).
    RUN AsciiToHtml IN web-utilities-hdl (_HTM._HTM-NAME, OUTPUT h_HtmlName).

    /* This is to retrieve a display name if we have one.  */
    /* Display name may be WRONG if it conflicts with a previous field name
       (bug 97-06-20-003), so why do this? 
    tmpname = "name":U + STRING(RECID(_U)).
    RUN GetField IN web-utilities-hdl (tmpname, OUTPUT dspname).
    IF (use_dspname(h_4glName, dspname)) AND (p_action eq "Submit") THEN 
        h_4glname = dspname.
    */
    
    CASE _HTM._HTM-TAG:
      WHEN "TEXTAREA":U THEN icon-name = "i-area":U.
      WHEN "SELECT":U   THEN icon-name = "i-select":U.
      OTHERWISE DO: 
        /* This is usually <INPUT> tags */
        CASE _HTM._HTM-TYPE:
          WHEN "CHECKBOX":U THEN icon-name = "i-check":U.
          WHEN "RADIO":U    THEN icon-name = "i-radio":U.
          WHEN "TEXT":U     THEN icon-name = "i-text":U.
          OTHERWISE              icon-name = "i-html":U.   
        END CASE. /* _HTM._HTM-TYPE... */
      END. /* OTHERWISE DO:... */
    END CASE. /* _HTM._HTM-TAG ... */   
    
    /* Output the name of the field. */
    {&OUT} 
      '<TR>~n':U
      '  <TD><IMG SRC="/webspeed/workshop/':U icon-name '.gif" WIDTH=16 HEIGHT=16 BORDER=0>':U h_HtmlName '</TD>~n':U
      '  <TD>':U _HTM._HTM-tag SPACE _HTM._HTM-type '</TD>~n':U
      '  <TD><INPUT TYPE="TEXT"  NAME="name':U RECID(_U) '"   VALUE="':U h_4glName '" SIZE="20" ':U
      ' onChange="chkFld(this);"></TD>~n':U
      '    <TD><INPUT TYPE="RADIO" NAME="source':U RECID(_U) '" VALUE="Tool" ':U
      ' onClick="chgSrc(form.name':U RECID(_U) ')~; " ':U
        (IF _U._DEFINED-BY eq "Tool" OR _U._DEFINED-BY eq "" THEN 'CHECKED>':U ELSE '>':U) 'Local~n':U
      '      <INPUT TYPE="RADIO" NAME="source':U RECID(_U) '" VALUE="DB" ':U
        (IF _U._DEFINED-BY eq "DB" THEN 'CHECKED>':U ELSE '>':U) 'DB ~n':U
      '      <INPUT TYPE="RADIO" NAME="source':U RECID(_U) '"VALUE="User" ':U
        (IF _U._DEFINED-BY eq "User" THEN 'CHECKED>':U ELSE '>':U) 'User ~n':U
      '  </TD>~n':U
      '</TR>~n':U
      .  
  END. /* FOR EACH _U:... */

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE Map_Wizard 
PROCEDURE Map_Wizard :
/*------------------------------------------------------------------------------
  Purpose:  Auto Maps the HTML fields in this web object, if possible
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE ch         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cnt        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE data-base  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE db-list    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ix         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE num-found  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE map-found  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE map-exists AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE tbls-used  AS CHARACTER NO-UNDO.

  /* See if any fields are already mapped. */
  map-exists = CAN-FIND (FIRST _U WHERE _U._P-recid = p_proc-id AND _U._DEFINED-BY = "DB":U).

  /* See if any DB.TBLS are already in use. */
  FOR EACH _U WHERE _U._P-recid eq p_proc-id AND _U._DBNAME ne ?:
    ch = _U._DBNAME + "." + _U._TABLE. 
    IF LOOKUP(ch, tbls-used) eq 0 THEN 
      tbls-used = tbls-used + "," + ch. /* Keep leading "," */
    IF LOOKUP(_U._DBNAME, db-list) eq 0 THEN 
      db-list = db-list + (IF db-list eq "" THEN "" ELSE ",") + _U._DBNAME.
  END.

  /* Add in additional PROGRESS databases into the list of databases.
     NOTE that we have DB's in use first. */
  DO ix = 1 TO NUM-DBS:
    IF DBTYPE(ix) eq "PROGRESS":U THEN 
      db-list = db-list + (IF db-list eq "" THEN "" ELSE ",") + LDBNAME(ix).
  END.

  /* Look at fields that are not already mapped to DB or made local */
  FOR EACH _U WHERE _U._P-recid eq p_proc-id AND _U._DEFINED-BY eq "Tool":U,
    EACH _HTM WHERE _HTM._U-recid eq RECID(_U)
    BY _HTM._HTM-NAME:

    ASSIGN 
      field-cnt = 0
      map-found = no
      old-count = 0.
      
    /* This loop's purpose is to determine if the field is ambiguous, i.e. not 
       fully qualified and more than one table.field or field with the same
       name exists somewhere. If the HTM-NAME does have a database component, then don't do this search. */
    CASE NUM-ENTRIES(_HTM._HTM-NAME, ".":U):
      WHEN 3 THEN field-cnt = 1. /* Use the field exactly as given. */
      WHEN 1 THEN DO:
        /* Add the field name to the various tbls already in use. */
        cnt = NUM-ENTRIES (tbls-used).
        Table-Loop:
        DO ix = 2 TO cnt:
          ch = ENTRY(ix, tbls-used) + ".":U + _HTM._HTM-NAME.
          RUN workshop/_mapfld.p (RECID(_U), ch, OUTPUT map-found).
          IF map-found THEN LEAVE Table-Loop. 
        END. /* Table-Loop: DO... */
      END.
    END CASE.
    
    /* IF we still haven't figured out a possible field, then loop through all
       databases. This will return the first match found. */
    IF NOT map-found THEN DO:
      IF field-cnt eq 0 THEN DO:
        ASSIGN ldb-name = "":U 
               cnt = NUM-ENTRIES(db-list). 
        Db-Loop: 
        DO ix = 1 TO cnt: 
          /* These are all PROGRESS databases. */ 
          data-base = ENTRY(ix, db-list). 
 
          /* Is field name ambiguous? If so, we can't automatically map it. */ 
          CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(data-base). 
          old-count = field-cnt. 
          RUN workshop/_fldcnt.p (RECID(_U), _HTM._HTM-NAME, INPUT-OUTPUT field-cnt). 
        
          /* We found a live one, so save off the db's LDBNAME to use for the 
             default mapping. */ 
          IF ldb-name eq "":U AND field-cnt > old-count THEN DO: 
            ldb-name = data-base. 
            LEAVE Db-Loop. 
          END. 
        END. /* Db-Loop: DO ix... */ 
        /* Set up for calls to _mapfld.p by setting the DICTDB to the first found 
           database. */ 
        IF ldb-name ne "":U THEN CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(ldb-name). 
      END. 
 
      /* If field name is not ambiguous let's attempt to map it. If  
         successful, _mapfld will update _U._DBNAME, _U._TABLE, and _U._NAME, 
          as well as other _U fields. */
      IF field-cnt > 0 THEN  
        RUN workshop/_mapfld.p (RECID(_U), _HTM._HTM-NAME, OUTPUT map-found). 
    END.

    /* Note that another object was found and the file has been modified. */
    IF map-found THEN DO:
      ASSIGN 
        num-found    = num-found + 1
        _P._modified = yes
        
        /* Add this db.tbl to the list of tables used in mapping. */
        ch           = _U._DBNAME + ".":U + _U._TABLE
        . 
      IF LOOKUP(ch, tbls-used) eq 0 THEN 
        tbls-used = ",":U + ch + tbls-used. /* Assume leading "," */
    END. /* IF map-found... */
  END. /* FOR EACH _U */

  /* Report the results. Note that the message depends on whether some fields
     already were mapped before we started. */
  {&OUT} '<HR WIDTH="60%">~n&nbsp~;&nbsp~;':U.
  CASE num-found:
    WHEN 0 THEN {&OUT}
         format-text ('No' + (IF map-exists THEN " additional" ELSE "") + 
                      ' HTML fields could be mapped to database fields.', 
                     "SUBMIT":U).
    WHEN 1 THEN {&OUT}
         format-text ('One':U + (IF map-exists THEN " additional" ELSE "") + 
                      ' HTML field was successfully mapped to a database field.', 
                     "SUBMIT":U).
    OTHERWISE {&OUT}
         format-text (STRING(num-found) + 
                      (IF map-exists THEN " additional" ELSE "") + 
                      ' HTML fields were successfully mapped to database fields.', 
                     "SUBMIT":U).
  END CASE.
  {&OUT} '~n':U.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-mapping-doc 
PROCEDURE output-mapping-doc :
/*------------------------------------------------------------------------------
  Purpose:     Show the document that allows mapping between HTML fields
               and 4GL variables or database fields.
               
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE DB_URL     AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE c_field    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE map-action AS CHARACTER NO-UNDO.
  DEFINE VARIABLE l_header   AS LOGICAL   NO-UNDO.

  RUN GetField IN web-utilities-hdl (INPUT "MapAction.x":U, OUTPUT c_field).
  IF c_field ne "" THEN map-action = "Mapping Wizard".
  ELSE DO:
    RUN GetField IN web-utilities-hdl(INPUT "SubAction":U, OUTPUT map-action).
    IF c_field ne "" THEN map-action = "Submit".
  END.

  /* Parse options. */
  l_header = LOOKUP ("NO-HEAD":U, p_options) eq 0.

  /* Generate the header if necessary. */
  IF l_header THEN DO:
    RUN outputContentType IN web-utilities-hdl ("text/html":U).
    {&OUT} 
      { workshop/html.i &SEGMENTS = "head,open-body"
                        &FRAME    = "WS_main" 
                        &AUTHOR   = "Nancy.E.Horn"
                        &TITLE    = "HTML Mapping" }.
  END.
  
  /* Get the relevant _P record. */
  FIND _P WHERE RECID(_P) eq p_proc-id NO-ERROR.
  IF ( NOT AVAILABLE _P ) THEN
    RUN Add-Error IN _err-hdl ("ERROR":U,?,SUBSTITUTE('File id &1 not found.', p_proc-id)).
  ELSE DO:
    {&OUT} 
      '<FORM METHOD="POST">~n':U
      '<SCRIPT LANGUAGE="JavaScript">~n':U
      '<!--~n':U
      { workshop/chkfld.i &no-tag = "yes" }
      'function chgSrc(what) ~{ ~n ':U
      '  var k = what.value.lastIndexOf(".")~; ~n':U
      '  what.value = what.value.substring(k+1, what.value.length)~; ~n ':U
      '  return true~; ~n ':U
      ' ~} ~n ':U
      '//-->~n':U
      '</SCRIPT>~n':U
      '<CENTER>~n':U
      '<TABLE WIDTH="80%">~n':U
      '<TR><TD>~n':U
      '<INPUT TYPE="Submit" NAME="SubAction" VALUE="Submit">~n':U
      '<INPUT TYPE="RESET">~n':U
      '</TD>~n':U
      '<TD >~n':U
      '<INPUT TYPE="IMAGE" NAME="MapAction" IMG SRC="/webspeed/images/u-mapwiz.gif" BORDER="0" ALT="Mapping Wizard" VALUE="Mapping Wizard">~n':U
      '</TD>~n':U. 
      
    /* NOTE: the JavaScript window.open does not want the "http://" part
       of the DB_URL. */
    DB_URL = AppURL + "/webtools/dbmain.w":U.
    
    {&OUT}  
      '<TD>&nbsp&nbsp&nbsp</TD>~n':U
      '<TD><A HREF="' DB_URL '" TARGET="dbListWindow" ~n ':U
      ' onClick="window.open~( ~'':U DB_URL ' ~',~'dbListWindow~',~'' 
        get-window-settings("dbListWindow":U, "":U) '~')~; " >Database View</A></TD>~n ':U
      '<TD>&nbsp&nbsp</TD>~n':U
      '<TD>~n':U
       { workshop/html.i &SEGMENTS = "help"
                         &FRAME    = "WSFC_main" 
                         &CONTEXT  = "{&HTML_Mapping_Help}" }
      '</TD></TR>~n':U
      '</TABLE>~n':U
      '</CENTER>~n':U
      .

    CASE map-action:
      WHEN "Mapping Wizard":U THEN DO:
        {&OUT} '~n':U.
        RUN Map_Wizard.
        IF RETURN-VALUE = "Error":U THEN RETURN.
      END.
      WHEN "Submit":U THEN DO:
        {&OUT} '~n':U.
        RUN Validate_Fields.
      END.
    END CASE.

    {&OUT}
      '<CENTER> ~n':U
      '<TABLE' get-table-phrase("":U) '>~n':U
      '<TR>~n':U
      '  <TH>' format-label('HTML Field', "COLUMN":U, "":U) '</TH>~n':U
      '  <TH>' format-label('HTML Type', "COLUMN":U, "":U) '</TH>~n':U
      '  <TH>' format-label('WebSpeed Field', "COLUMN":U, "":U) '</TH>~n':U
      '  <TH>' format-label('Field Source', "COLUMN":U, "":U) '</TH>~n':U
      '</TR>~n':U
      .
    
    /* Now list each of the fields in a separate row. */
    RUN list-fields (INPUT map-action) .
    
    /* Close the table and form. */
    {&OUT}
      '</TABLE>~n':U
      '</CENTER>~n':U
      '</FORM>~n':U
      .
  END. /* IF...AVAILABLE(_P)... */
        
  /* Close the document, if necessary. */
  IF l_header THEN {&OUT} '</BODY>~n </HTML>~n':U.
  
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE Validate_Fields 
PROCEDURE Validate_Fields :
/*------------------------------------------------------------------------------
  Purpose:  Validates the fields mapped. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE c-scrap       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE data-base     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE database-name AS CHARACTER NO-UNDO.
  DEFINE VARIABLE db-found      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE dup-field     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE err-cnt       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE field-cnt     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE fld-name      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fld-ok        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE H_4glname     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE H_source      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Htm_name      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ix            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ldb-name      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE map-found     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE name-err      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE old-count     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE table-name    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE valid-name    AS LOGICAL   NO-UNDO.

  DEFINE BUFFER buf_U FOR _U.

  /* Look at each record and record the new information. */ 
  field-block:
  FOR EACH _U WHERE _U._P-recid eq p_proc-id,
    EACH _HTM WHERE _HTM._U-recid eq RECID(_U)
    BY _HTM._HTM-NAME:

    ASSIGN Htm_name = "name":U + STRING(RECID(_U)).
    RUN GetField IN web-utilities-hdl (INPUT Htm_name, OUTPUT H_4glname).

    ASSIGN Htm_name = "source":U + STRING(RECID(_U)).
    RUN GetField IN web-utilities-hdl (INPUT Htm_name, OUTPUT H_source).

    ASSIGN
      field-cnt = 0
      map-found = no
      name-err  = 0
      old-count = 0
      H_4glname = IF H_source ne "Tool":U THEN H_4glname ELSE
                    ENTRY(NUM-ENTRIES(H_4glname,".":U),H_4glname,".":U)
      .

    CASE NUM-ENTRIES(H_4glname,".":U):
      WHEN 3 THEN
        ASSIGN
          database-name = ENTRY(1, H_4glname, ".":U)
          table-name    = ENTRY(2, H_4glname, ".":U)
          fld-name      = ENTRY(3, H_4glname, ".":U).
      WHEN 2 THEN
        ASSIGN
          database-name = (IF H_source eq "DB":U THEN _U._DBNAME ELSE ?)
          table-name    = ENTRY(1, H_4glname, ".":U )
          fld-name      = ENTRY(2, H_4glname, ".":U ).
      WHEN 1 THEN
        ASSIGN
          database-name = (IF H_source eq "DB":U THEN _U._DBNAME ELSE ?)
          table-name    = (IF H_source eq "DB":U THEN _U._TABLE ELSE ?)
          fld-name      = H_4glname.
    END CASE.

    FIND FIRST buf_U WHERE buf_U._P-recid = p_proc-id AND RECID(buf_U) <> RECID(_U) AND 
      buf_U._DBNAME eq database-name AND buf_U._TABLE eq table-name AND 
      buf_U._NAME eq fld-name NO-ERROR.
      
    /* If buf_U is available, then we have a duplicate field, so raise error. */
    IF AVAILABLE buf_U THEN DO:
      &IF {&debug} &THEN
      {&out}
        '<br>_p-recid:' buf_u._p-recid ' ' p_proc-id
        '<br>_u-recid:' recid(buf_u) ' ' recid(_u)
        '<br>database: ' database-name
        '<br>table: ' table-name
        '<br>field: ' fld-name
        .
      &ENDIF
             
      RUN error_header (INPUT-OUTPUT err-cnt).
      IF h_4glname ne "" THEN
        {&OUT}
          format-error (SUBSTITUTE("** The HTML field &1 cannot be changed to &2, since an object already exists with that name.",
          _HTM._HTM-NAME,H_4glname),'','').
      ELSE
        {&OUT}
          format-error ("** The WebSpeed Field value for &1 cannot be blank.",
          _HTM._HTM-NAME,'').

      NEXT field-block.
    END.
    
    CASE H_source:
      WHEN "DB":U THEN DO:
        /* If we have db.table.name, _fldtype.p will return its datatype if it can
           find the field, otherwise it will return ?. */
        IF NUM-ENTRIES(H_4glname,".":U) = 3 THEN DO:
          RUN webutil/_fldtype.p (H_4glname, OUTPUT c-scrap).
          IF c-scrap <> ? AND c-scrap <> "" THEN 
            ASSIGN
              map-found      = yes
              _U._DBNAME     = ENTRY(1,H_4glname,".":U)
              _U._TABLE      = ENTRY(2,H_4glname,".":U)
              _U._NAME       = ENTRY(3,H_4glname,".":U)
              _U._DEFINED-BY = "DB":U.
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
            RUN workshop/_fldcnt.p (RECID(_U), H_4glname, INPUT-OUTPUT field-cnt).
            
            /* We found a live one, so save off the db's LDBNAME in case this is the
               only occurance of this field in all connected databases. */
            IF field-cnt > old-count THEN
              ldb-name = data-base.
          END.

          /* If field name is not ambiguous let's attempt to map it. */
          IF field-cnt = 1 THEN DO:
            CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(ldb-name).
            /* If successful, _mapfld will update _U._DBNAME, _U._TABLE, and 
               _U._NAME, as well as other _U fields. Make sure there are no 
               duplicate fields, however. */
              
            RUN workshop/_mapfld.p (RECID(_U), H_4glname, OUTPUT map-found).
            IF RETURN-VALUE eq "Duplicate":U THEN dup-field = TRUE.
          END.
        END.

        IF NOT map-found THEN DO:
          &IF {&debug} &THEN
          {&out}
            '<br>return: ' return-value
            '<br>field-cnt: ' field-cnt
            '<br>dup-field: ' dup-field
            '<br>ldb-name: ' ldb-name
            '<br>data-base: ' data-base
            .
          &ENDIF
            
          RUN error_header (INPUT-OUTPUT err-cnt).
           
          IF NUM-DBS > 0 THEN DO:
            IF field-cnt = 0 THEN     
              {&OUT}
                format-error ('** Field &1 was not found in database.~n', H_4glname, "":U)
                ' [<A HREF="JavaScript:GotoField(~'name' RECID(_U) '~')~;">goto field</A>]<BR>~n'.
            IF field-cnt > 1 THEN
              {&OUT}
                format-error ('** Field &1 was found more than once in database.~n', H_4glname, "":U)
                  ' [<A HREF="JavaScript:GotoField(~'name' RECID(_U) '~')~;">goto field</A>]<BR>~n'.
            IF dup-field THEN
              {&OUT}
                format-error (SUBSTITUTE("** The HTML field &1 cannot be changed to &2, since an object already exists with that name.",
                  _HTM._HTM-NAME,H_4glname),'','').
          END. 
          ELSE
            {&OUT}
              format-error ('** There are no connected databases, so the field &1 could not be verified. ~n', H_4glname, "") '<BR>~n':U.
        END.
      END.  /* When "DB" */
       
      WHEN "Tool":U OR WHEN "User":U THEN DO:
        DO ix = 1 to NUM-ENTRIES(H_4glname,".":U):
          RUN workshop/_valname.p (TRIM(ENTRY(ix, H_4glname,".":U)), OUTPUT valid-name).
          IF NOT valid-name THEN DO:
            name-err = name-err + 1.

            RUN error_header (INPUT-OUTPUT err-cnt).
            {&OUT}
              format-error ('** Name &1 is not a valid name.', ENTRY(ix,H_4glname,".":U), "":U)
              '[<A HREF="Javascript:GotoField(~'name':U RECID(_U) '~')~;">goto field</A>]<BR>~n':U.
          END.
        END.
        IF name-err = 0 AND NUM-DBS > 0 THEN 
           RUN workshop/_chkfld.p (RECID(_U), table-name, fld-name, H_source, OUTPUT fld-ok).
      END.  /* End Local or User */
    END CASE.
  END.  /* FOR EACH */
  /* We've done a submit - set the modified flag for the procedure */
  _P._modified = yes.

END PROCEDURE.
&ANALYZE-RESUME
 
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE error_header
PROCEDURE error_header :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER p_err-cnt AS INTEGER NO-UNDO.
  
  p_err-cnt = p_err-cnt + 1.    
  IF p_err-cnt = 1 THEN    
    {&OUT} 
      '<HR WIDTH="60%">'
      { workshop/javascpt.i &SEGMENTS = "goto-Field" }
      format-text ('The following errors were detected. (Remaining changes were saved):', 
                   'SUBMIT':U)
      '<BR>~n':U.

END PROCEDURE.
&ANALYZE-RESUME
 
/* _htmlmap.w - end of file */
