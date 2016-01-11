&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Method-Library
/* Procedure Description
"Standard include file for HTML Mapping objects. 
This file is included in every html-map.w."
*/
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
/*--------------------------------------------------------------------------
    Library     : web/method/html-map.i
    Purpose     : Standard include file for HTML Mapping objects. 
                  This file is included in every web/template/html-map.w

    Syntax      :

    Description :

    Author(s)   : Wm. T. Wood
    Created     : May 19, 1996
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* **************************** Shared Definitions ***************************/
{src/web/method/cgidefs.i} 
{src/web/method/tagmap.i}

/* ***********************Included, but local, Definitions *******************/
{src/web/method/htmoff.i NEW}

DEFINE STREAM instream.     /* html input file */

DEFINE VARIABLE proc-names   AS CHARACTER NO-UNDO. /* internal procedures */

ASSIGN
  SESSION:APPL-ALERT-BOXES = TRUE
  proc-names               = THIS-PROCEDURE:INTERNAL-ENTRIES
  htmFname                 = "{&WEB-FILE}":U.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */


&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* Included Libraries --- */
{src/web/method/admweb.i}
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* ****************************** Main Code Block ************************** */
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adm-assign-fields) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE adm-assign-fields 
PROCEDURE adm-assign-fields :
/*------------------------------------------------------------------------------
  Purpose:     Assign the current values in the enabled fields/objects to
               the database and to local variables.     
  Parameters:  <none>
  Notes:        
------------------------------------------------------------------------------*/
  &IF "{&FRAME-NAME}" ne "" &THEN
  
    /* Assign Enabled object, if any. */
    &IF "{&ENABLED-OBJECTS}" ne "" &THEN
      ASSIGN FRAME {&FRAME-NAME} {&ENABLED-OBJECTS}.
    &ENDIF
    
    /* Assign Enabled Fields, if the table is available. */
    &IF "{&ENABLED-FIELDS}" ne "" &THEN
      ASSIGN FRAME {&FRAME-NAME} {&ENABLED-FIELDS}.
    &ENDIF
    
  &ENDIF
END PROCEDURE.
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-display-fields) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE adm-display-fields 
PROCEDURE adm-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Display the current database and field values in the Progress
               form buffer.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  &IF "{&FRAME-NAME}" ne "" AND
      "{&DISPLAYED-OBJECTS}{&DISPLAYED-FIELDS}" ne "" 
  &THEN
    DISPLAY {&DISPLAYED-OBJECTS} {&DISPLAYED-FIELDS}
            WITH FRAME {&FRAME-NAME} NO-ERROR.
  &ENDIF
END PROCEDURE.
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-enable-fields) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE adm-enable-fields 
PROCEDURE adm-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Enable the fields that will be available for input.     
  Parameters:  <none>
  Notes:        
------------------------------------------------------------------------------*/
  &IF "{&FRAME-NAME}" ne "" AND
      "{&ENABLED-OBJECTS}{&ENABLED-FIELDS}" ne "" 
  &THEN
    ENABLE {&ENABLED-OBJECTS} {&ENABLED-FIELDS} WITH FRAME {&FRAME-NAME}.
  &ENDIF
END PROCEDURE.
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-find-records) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE adm-find-records 
PROCEDURE adm-find-records :
/*------------------------------------------------------------------------------
  Purpose:     Open the query that finds the records in this frame.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  &IF "{&OPEN-QUERY-{&QUERY-NAME}}" ne "":U &THEN
    {&OPEN-QUERY-{&QUERY-NAME}}
    GET FIRST {&QUERY-NAME}.
  &ENDIF
END PROCEDURE.
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-initialize) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE adm-initialize 
PROCEDURE adm-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Load offset data, set web-state, set Clear widget screen-values.
  Parameters:  p_hframe - handle of frame
  Notes:                    
------------------------------------------------------------------------------*/
 
  /* Load .htm field offset table. */
  RUN htm-offsets IN THIS-PROCEDURE NO-ERROR.

  /* Clear widget screen-values (in form buffer) -- this should be unnecessary 
     if you haven't done a display. */
  &IF "{&FRAME-NAME}" ne "" &THEN
    DEFINE VARIABLE h AS HANDLE NO-UNDO.
    ASSIGN
      h = FRAME {&FRAME-NAME}:CURRENT-ITERATION   /* get the field group */
      h = h:FIRST-CHILD.                          /* first field handle */
    
    DO WHILE(VALID-HANDLE(h)):
      IF CAN-SET(h, "SCREEN-VALUE":U) THEN ASSIGN h:SCREEN-VALUE = "" NO-ERROR.
      ASSIGN h = h:NEXT-SIBLING. /* get next field handle */
    END.
  &ENDIF
END PROCEDURE.
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-input-fields) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE adm-input-fields 
PROCEDURE adm-input-fields :
/*------------------------------------------------------------------------------
  Purpose:  Receive field input from the web browser.
   
     Call the WEB.INPUT procedure for each field in the seek offset table.
     This copies the html field data into the Progress objects.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE web-input-fields AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c-scrap          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i-scrap          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE aFieldDef        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE util-proc-result AS LOGICAL   NO-UNDO.

  /* field definition */
  DEFINE VARIABLE field-val        AS CHARACTER NO-UNDO.

  DEFINE BUFFER htmoff-input FOR HTMOFF.
 
  FOR EACH htmoff-input USE-INDEX offset:
    /* get the field value */
    RUN GetField IN web-utilities-hdl (htmoff-input.HTM-NAME, OUTPUT field-val).
   
    /* Dispatch to WEB.INPUT procedure */ 
    IF CAN-DO(proc-names, htmoff-input.WDT-NAME + ".INPUT":U) THEN
      /* User has defined an INPUT procedure */
      RUN VALUE(htmoff-input.WDT-NAME + '.INPUT':U) IN THIS-PROCEDURE 
        (field-val) NO-ERROR.
          
    ELSE
      /* No INPUT procedure defined.  Call the default utility procedure. */
      RUN dispatch-utility-proc ("WEB.INPUT":U, htmoff-input.HANDLE, 
                                 field-val, htmoff-input.ITEM-CNT, 
                                 OUTPUT util-proc-result).
  END. /* FOR EACH htmoff-input... */
  
END PROCEDURE.
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-output-fields) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE adm-output-fields 
PROCEDURE adm-output-fields :
/*------------------------------------------------------------------------------
  Purpose:     Replace the tagged fields in the HTML file with the
               values stored on the form buffer.
  
   Merge html file with results of OUTPUT procedures if one exists for each
   field.  Else just output the definition for now.  Replace with call to
   default utility procedure based on type when util procs are available.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE util-proc-result AS LOGICAL NO-UNDO.

  DEFINE VARIABLE c-name            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c-path            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c-scrap           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE clip-bytes        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE field-def         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE file-ext          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE html-path         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE next-line         AS CHARACTER NO-UNDO.
  
  /* line numbers and line offset of the field definition */
  DEFINE VARIABLE line-no           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE start-line-no     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE end-line-no       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE start-line-offset AS INTEGER   NO-UNDO.
  DEFINE VARIABLE end-line-offset   AS INTEGER   NO-UNDO.
  
  DEFINE BUFFER htmoff-output FOR HTMOFF.

  /* Look for HTML file. */
  RUN webutil/_htmsrch.p ("{&WEB-FILE}":U,THIS-PROCEDURE:FILE-NAME,OUTPUT html-path).
  IF html-path = ? THEN DO:
    RUN adecomm/_osfext.p (htmFname,OUTPUT file-ext).
    
    IF file-ext <> "htm":U AND file-ext <> "html":U THEN
      c-name = SUBSTRING(htmFname,1,R-INDEX(htmFname,".":U),"CHARACTER":U) + "htm":U.
      
    RUN HtmlError IN web-utilities-hdl (SUBSTITUTE("<b>ERROR:</b> The file &1 could not be found. [html-map.i]",htmFname)).
    RETURN "Error".
  END.
    
  INPUT STREAM instream FROM VALUE(html-path) NO-ECHO.
  ASSIGN start-line-offset = 1.
  
  FIND FIRST htmoff-output NO-ERROR.
 
  REPEAT ON ENDKEY UNDO, RETRY:
    IF AVAILABLE (htmoff-output) THEN
      ASSIGN
        start-line-no     = htmoff-output.BEG-LINE
        start-line-offset = htmoff-output.BEG-BYTE 
        end-line-no       = htmoff-output.END-LINE
        end-line-offset   = htmoff-output.END-BYTE
        .
    ELSE DO: 
      /* Flush out the rest of the html file. */
      REPEAT:
        {&OUT} next-line + CHR(10).
  
        IMPORT STREAM instream UNFORMATTED next-line.
      END.
      LEAVE.
    END.
  
    /* Snip the field definition out of the file using the offsets */
    RUN get-next-html-field (INPUT-OUTPUT next-line,
                             INPUT-OUTPUT line-no,
                             INPUT-OUTPUT start-line-no,
                             INPUT-OUTPUT start-line-offset,
                             INPUT-OUTPUT end-line-no,
                             INPUT-OUTPUT end-line-offset,
                             INPUT-OUTPUT field-def,
                             INPUT-OUTPUT clip-bytes).
	
    /* dispatch to WEB.OUTPUT procedure if one exists */
    IF CAN-DO(proc-names, htmoff-output.WDT-NAME + ".OUTPUT":U) THEN DO:
      /* found that the user has defined a local WEB.OUTPUT procedure */
      IF htmoff-output.WDT-TYPE = "radio-set":U THEN
        RUN VALUE(htmoff-output.WDT-NAME + '.OUTPUT':U) IN THIS-PROCEDURE 
          (field-def, htmoff-output.ITEM-CNT) NO-ERROR.
      ELSE
        RUN VALUE(htmoff-output.WDT-NAME + '.OUTPUT':U) IN THIS-PROCEDURE 
          (field-def) NO-ERROR.
   	END.
    ELSE DO:
      /* There is no local procedure defined so call the default proc. */
      RUN dispatch-utility-proc ("WEB.OUTPUT":U, htmoff-output.HANDLE, 
                                 field-def, htmoff-output.ITEM-CNT, 
                                 OUTPUT util-proc-result).
      IF (util-proc-result <> TRUE) THEN
        /* Could not invoke default utility proc so send as is. */
        {&OUT} field-def + CHR(10).
    END.

    FIND NEXT htmoff-output NO-ERROR.
  END. /* repeat */
  
  INPUT STREAM instream CLOSE.

END PROCEDURE.
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dispatch-utility-proc) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE dispatch-utility-proc 
PROCEDURE dispatch-utility-proc :
/*------------------------------------------------------------------------------
  Purpose:     Call the standard utility procedure for the current object.
  Input Parameters:  
    p_invoke-method - (CHAR) the method to run in the utility procedure
                      [e.g. WEB.INPUT or WEB.OUTPUT]
    p_field-handle  - (HANDLE) the handle of the Progress object.
    p_field-data    - (CHAR) the data to send to the procedure.
    p_item-counter  - (INT) the radio-set item to process.
    
  Ouput Parameters: 
    p_result - (LOGICAL) did the method run successfully. 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_invoke-method AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_field-handle  AS HANDLE    NO-UNDO.
  DEFINE INPUT  PARAMETER p_field-data    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_item-counter  AS INTEGER   NO-UNDO.
  DEFINE OUTPUT PARAMETER p_result        AS LOGICAL   NO-UNDO.

  DEFINE BUFFER htmoff-disp FOR HTMOFF.

  /* Note: htmoff-disp.ITEM-CNT will be 0 for all non-radio-sets */
  FIND FIRST htmoff-disp WHERE htmoff-disp.HANDLE = p_field-handle
    AND htmoff-disp.ITEM-CNT = p_item-counter NO-ERROR.
  IF AVAILABLE htmoff-disp THEN DO:
    /* Get the TAGMAP record. */
    FIND FIRST tagmap WHERE tagmap.htm-Tag  = htmoff-disp.HTM-TAG 
                        AND tagmap.htm-Type = htmoff-disp.HTM-TYPE NO-ERROR.

    IF NOT AVAILABLE (tagmap) THEN
      FIND FIRST tagmap WHERE tagmap.htm-Tag EQ htmoff-disp.HTM-TAG 
                        USE-INDEX i-order NO-ERROR.  
    /* If a TAG is not found, this is a "serious" error, so report it. */
    IF NOT AVAILABLE (tagmap) THEN
      RUN HtmlError IN web-utilities-hdl 
        (SUBSTITUTE ('HTML tag mapping procedure for tag &1&2 not found.',
                     htmoff-disp.HTM-TAG,
                     IF htmoff-disp.HTM-TYPE ne '':U 
                       THEN ' (TYPE = ':U + htmoff-disp.HTM-TYPE + ')':U
                       ELSE '':U) + htmoff-disp.HANDLE:NAME).
    ELSE DO: 
      /* Is there a TAGMAP utility procedure? */
      IF VALID-HANDLE (tagmap.util-Proc-Hdl) THEN DO:
        IF htmoff-disp.WDT-TYPE = "radio-set":U 
          AND p_invoke-method = "web.output":U THEN
          RUN VALUE(p_invoke-method) IN tagmap.util-Proc-Hdl
            (htmoff-disp.HANDLE, p_field-data, p_item-counter) NO-ERROR.
        ELSE
          RUN VALUE(p_invoke-method) IN tagmap.util-Proc-Hdl
            (htmoff-disp.HANDLE, p_field-data) NO-ERROR.
        IF NOT ERROR-STATUS:ERROR THEN p_result = yes.

      END.
    END. /* IF AVAIL...tagmap */
  END. /* IF AVAIL...htmoff-disp */
  
END PROCEDURE.
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-next-html-field) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE get-next-html-field 
PROCEDURE get-next-html-field :
/*------------------------------------------------------------------------------
  Purpose: Read the current 'instream' sending each line to the WEBSTREAM
           up the next HTML field definition.
           
           The field defintion is found from
             line: start-line-no   column: start-line-offset
           to
             line: end-line-no     column: end-line-offset    
             
           The string for this field definition is returned in "field-def".  
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER next-line         AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER line-no           AS INTEGER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER start-line-no     AS INTEGER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER start-line-offset AS INTEGER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER end-line-no       AS INTEGER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER end-line-offset   AS INTEGER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER field-def         AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER clip-bytes        AS INTEGER   NO-UNDO.

  DEFINE VARIABLE org-line-len AS INTEGER   NO-UNDO. /* original HTML line length */
  DEFINE VARIABLE last-line    AS CHARACTER NO-UNDO. /* last line read */
  DEFINE VARIABLE num-lines    AS INTEGER   NO-UNDO. /* # lines in field definition */
 
  /* Go through file until we get in the vicinity of the next seek offset. */
  REPEAT WHILE line-no < start-line-no:
    ASSIGN last-line = next-line.
    IMPORT STREAM instream UNFORMATTED next-line.
    ASSIGN
      clip-bytes   = 0
      line-no      = line-no + 1.
  
    {&OUT} last-line + CHR(10).
  END.

  /* Adjust the starting byte offset to account for any preceding text we
     may have already 'stripped' off and sent to the web. */
  ASSIGN
    org-line-len      = LENGTH(next-line,"CHARACTER":U)
    start-line-offset = start-line-offset - clip-bytes.

  /* We read up to start-seek-offset and then some */
  IF (org-line-len > start-line-offset AND start-line-offset > 1) THEN DO:
    /* Number of bytes in the string to the left of the start of the field
       definition that should be passed along to the output stream.  This
       should be cumulative if more than one field exists on a line. */
    ASSIGN 
      clip-bytes = clip-bytes + start-line-offset - 1.
  
    IF clip-bytes > 0 THEN DO:
      {&OUT} SUBSTRING(next-line,1,start-line-offset - 1,"CHARACTER":U).  
      ASSIGN 
        next-line    = SUBSTRING(next-line,start-line-offset,-1,"CHARACTER":U)
        org-line-len = LENGTH(next-line,"CHARACTER":U).
    END.
  END.
  
  ASSIGN field-def = next-line.
 
  REPEAT WHILE line-no < end-line-no:
    IMPORT STREAM instream UNFORMATTED next-line.
  
    ASSIGN
      line-no      = line-no + 1
      clip-bytes   = 0
      org-line-len = LENGTH(next-line,"CHARACTER":U)

      /* If we're looking at the last line of a multi-line field definition, only 
         add that part that pertains to this field, otherwise add the whole line. */
      field-def    = field-def + CHR(10) + 
        (IF line-no < end-line-no THEN next-line ELSE
         SUBSTRING(next-line,1,end-line-offset,"CHARACTER":U)).
  END.

  /* Adjust the ending byte offset to account for any preceding text we
     may have already 'stripped' off and sent to the web. */
  ASSIGN
    num-lines       = NUM-ENTRIES(field-def,CHR(10))
    end-line-offset = end-line-offset - clip-bytes.

  IF (org-line-len > end-line-offset) AND num-lines = 1 THEN
    ASSIGN
      field-def = SUBSTRING(field-def,1,end-line-offset,"CHARACTER":U).

  /* Adjust clip-bytes to account for the last line of the field-def we're sending 
     to the web */ 
  ASSIGN clip-bytes = clip-bytes + 
    LENGTH(ENTRY(num-lines,field-def,CHR(10)),"CHARACTER":U).

  IF (org-line-len - end-line-offset >= 0) THEN
    ASSIGN next-line = SUBSTRING(next-line,end-line-offset + 1,-1,"CHARACTER":U).

END PROCEDURE.
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htm-associate) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE htm-associate 
PROCEDURE htm-associate :
/*------------------------------------------------------------------------------
  Purpose:     Associate HTML fields with their Web object widget counterparts.
  Parameters:  < none >
  Notes:                    
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER htmField  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER wdtField  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER widHandle AS HANDLE    NO-UNDO.
  
  DEFINE VARIABLE found AS LOGICAL NO-UNDO.

  DEFINE BUFFER htmoff-assoc FOR HTMOFF.
  
  /* Previously a FIND FIRST, this FOR EACH will only find one record per
     htmField, EXCEPT for radio-sets.  In this case, one htmoff-assoc record 
     will exist for each radio-item.
  */
  FOR EACH htmoff-assoc WHERE htmoff-assoc.HTM-NAME = htmField:
    /* Check to see if the datatype has changed.  If so, raise error.  For
       radio-sets, this will abort on the first radio-item. */
    IF htmoff-assoc.WDT-TYPE <> widHandle:TYPE THEN DO:
      RUN HtmlError IN web-utilities-hdl 
        (SUBSTITUTE("For the field &1, the HTML datatype (&2) does not match the Web object datatype (&3).", 
                     wdtField, htmoff-assoc.WDT-TYPE, widHandle:TYPE)).
      RETURN.
    END.
    
    ASSIGN
      htmoff-assoc.WDT-NAME = wdtField
      htmoff-assoc.HANDLE   = widHandle
      found                 = TRUE.
  END.
  IF NOT found THEN DO: /* ERROR: HTML field deleted since Web object updated */
    RUN HtmlError IN web-utilities-hdl 
      (SUBSTITUTE("The '&1' field was found in the Web object, but missing from the offset file.", 
                   wdtField)).
    RETURN.
  END.
   
END PROCEDURE.
&ANALYZE-RESUME

&ENDIF

/* html-map.i - end of file */
