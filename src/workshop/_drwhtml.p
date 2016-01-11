&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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

  File: _drwhtml.p

  Description: Looks at the _HTM records for this file and creates
               HTML Associated Fields in the UIB (using adeuib/_uib-crt.p).
               
               This file has two modes: 
                * one where the user is asked before adding new Progres objects
                  (Called when an existing .w is being opened).
                * one where new objects are automatically created.
                  (Called when a new html file is being turned into a .w file).
                                  
  Input Parameters:
               p_proc-id -- Context Id of the Procedure
               p_verbose -- asks before it draws anything
               
  Output Parameters:
               p_Return -- True if load all problems were successfully
                           resolved. (not used)

  Author: Wm.T.Wood

  Created: March 1996

------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_proc-id  AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER p_Verbose  AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER p_Return   AS LOGICAL   NO-UNDO INITIAL TRUE.

/* Shared variables --                                                       */
{ workshop/errors.i }       /* Error handling procedures                     */
{ workshop/htmwidg.i }      /* Design time Web _HTM TEMP-TABLE.              */
{ workshop/objects.i }      /* Web Objects TEMP-TABLE definition             */
{ workshop/sharvars.i }     /* Shared variables                              */
{ workshop/uniwidg.i }      /* Universal Widget TEMP-TABLE definition        */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure

&Scoped-define debug false
&if {&debug} &then
define variable fld-cnt as integer no-undo.
define stream debug.
output stream debug to aa-drwhtml.log append.
&endif

/* _UIB-PREPROCESSOR-BLOCK-END */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK

/* ************************   More Definitions  *********************** */
DEFINE VARIABLE cst-type     AS CHARACTER NO-UNDO. 
DEFINE VARIABLE ipos         AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-draw       AS LOGICAL   NO-UNDO. 
DEFINE VARIABLE line-hgt-p   AS INTEGER   NO-UNDO.
DEFINE VARIABLE new-name     AS CHARACTER NO-UNDO. 
DEFINE VARIABLE num-itms     AS INTEGER   NO-UNDO. 
DEFINE VARIABLE o_h_cur_widg AS HANDLE    NO-UNDO.
DEFINE VARIABLE offFile      AS CHARACTER NO-UNDO. 
DEFINE VARIABLE r-scrap      AS RECID     NO-UNDO. /* scrap */
DEFINE VARIABLE radio-list   AS CHARACTER NO-UNDO. /* radio label/value pairs */
DEFINE VARIABLE testy        AS INTEGER   NO-UNDO.

DEFINE BUFFER win_U FOR _U.
DEFINE BUFFER frm_U FOR _U.

/* ***************************  Main Block  *************************** */
 
/* Is there anything to find. */
IF CAN-FIND (FIRST _HTM WHERE _HTM._P-recid eq p_proc-id AND _HTM._U-recid eq ?)
THEN DO:  
  /* We will draw in the current frame. */
  FIND FIRST frm_U WHERE frm_U._TYPE eq "FRAME"
                     AND frm_U._P-recid eq p_proc-id NO-ERROR.
  IF NOT AVAILABLE frm_U THEN DO:
    /* Create the frame record. */
    CREATE frm_U.
    ASSIGN frm_U._TYPE    = "FRAME":U  
           frm_U._NAME    = "Web-Frame":U
           frm_U._P-recid = p_proc-id 
           frm_U._status  = "NORMAL":U
           .
  END.
  
  /* Look for _HTM records without a _U associated. Create the _U records. */
  FOR EACH _HTM WHERE _HTM._P-recid eq p_proc-id
                  AND _HTM._U-recid eq ?
                   BY _HTM._i-order:
    /* Get the Progress name to use for this object. */
    RUN get_valid_name (_HTM._HTM-NAME, _HTM._MDT-TYPE, OUTPUT new-name).
    
    /* Get the type of object to draw.    
       NOTE: the _HTM._MDT-TYPE contains up to 2 lines.
      The first line will be the Progress widget type (eg. "RADIO-SET").
      The second line will be x's, with one X for each time that 
      particular variable was defined in the HTML file. */   
    IF NUM-ENTRIES(_HTM._MDT-TYPE, CHR(10)) < 2 THEN
      ASSIGN num-itms = 1.
    ELSE 
      ASSIGN 
        num-itms       = LENGTH(ENTRY(2, _HTM._MDT-TYPE, CHR(10)))
        _HTM._MDT-TYPE = ENTRY(1, _HTM._MDT-TYPE, CHR(10))
        .   
    /* Note: in version 1 we checked for ane MDT-NAME that was a CST file entry
        of the form:
          BUTTON:CST-NAME   or SmartObject:object-file. 
       In version 2, we only support simple widgets because there is no CST file. */
    IF NUM-ENTRIES(_HTM._MDT-TYPE, ":":U) > 1 THEN DO:
      ASSIGN _HTM._MDT-TYPE = ENTRY(1, _HTM._MDT-TYPE, ":":U).
      IF _HTM._MDT-TYPE eq "SmartObject:":U THEN
        ASSIGN _HTM._MDT-TYPE = "FILL-IN":U.
    END.
        
    /* Draw a new widget of the current type. */ 
    CREATE _U.  
    CREATE _F.
    ASSIGN
      /* Create links between objects. */
      _U._P-recid      = p_Proc-ID
      _U._x-recid      = RECID(_F)
      _U._parent-recid = RECID(frm_U)
      _HTM._U-recid    = RECID(_U)
      /* Standard Attibutes. */ 
      _U._TYPE         = _HTM._MDT-TYPE   
      _U._NAME         = new-name 
      /* Be default, assume items are CHARACTER fields. */
      _F._DATA-TYPE    = IF _U._TYPE eq "TOGGLE-BOX":U THEN 
                           "LOGICAL":U ELSE "CHARACTER":U.

    /* The height of the object will depend on the number of entries. */
    CASE _U._TYPE:
      WHEN "EDITOR":U OR WHEN "SELECTION-LIST":U THEN 
        ASSIGN _F._WIDTH  = 20
               _F._HEIGHT = 4.
      WHEN "RADIO-SET":U THEN 
        ASSIGN _F._WIDTH  = 20
               _F._HEIGHT = num-itms. 
      WHEN "FILL-IN" OR WHEN "COMBO-BOX" THEN  
        /* Allow these to have a large format, but keep the widget small
           enough to fit in the frame. */
        ASSIGN _F._FORMAT = "X(256)":U
               _F._WIDTH  = 20
               _F._HEIGHT = 1.
      OTHERWISE 
        ASSIGN _F._WIDTH  = ?
               _F._HEIGHT = ?.
    END CASE.                       
    /* Add the number of items for a Radio-set. */
    IF _U._TYPE eq "RADIO-SET" THEN 
      RUN build_radio_set (num-itms).         

    &if {&debug} &then
    fld-cnt = fld-cnt + 1.
    put stream debug unformatted
      "field #" fld-cnt ": " string(time,"hh:mm:ss") skip.
    &endif

  END. /* FOR EACH _HTM... */
END. /* IF CAN-FIND (FIRST _HTM... */

/* Remove the second line (containing "x's") from the MDT-TYPE field.
   This second line holds the number of entries in widgets like
   selection-lists and radio-sets. It was put in by adeweb/_rdoffd.p
   which read the .off file. */
FOR EACH _HTM WHERE _HTM._P-recid eq p_proc-id
  AND NUM-ENTRIES(_HTM._MDT-TYPE, CHR(10)) > 1:
  _HTM._MDT-TYPE = ENTRY(1, _HTM._MDT-TYPE, CHR(10)).
END.

&if {&debug} &then
output stream debug close.
&endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build_radio_set Procedure 
PROCEDURE build_radio_set :
/*------------------------------------------------------------------------------
  Purpose: Populate a radio-set in the UIB.   
  Parameters:  <none>
  Notes:  This works on the current _U and _HTM records.    
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_radio-cnt AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE ix         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE radio-list AS CHARACTER NO-UNDO.
  
  FIND _F WHERE RECID(_F)  = _U._x-RECID NO-ERROR.
  ASSIGN 
    radio-list     = ""
    _F._LIST-ITEMS = "".
    
  DO ix = 1 TO p_radio-cnt:
    ASSIGN
      radio-list = (IF radio-list > "" THEN radio-list + ",":U ELSE "")
                 + _HTM._HTM-NAME + " " + STRING(ix) + ",":U + STRING(ix)
      _F._LIST-ITEMS = (IF _F._LIST-ITEM > "" 
                        THEN _F._LIST-ITEM + ',':U + CHR(10) 
                        ELSE "")
                     + SUBSTITUTE ('"&1","&1"':U, _HTM._HTM-NAME + " " + STRING(ix)).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get_valid_name Procedure 
PROCEDURE get_valid_name :
/*------------------------------------------------------------------------------
  Purpose:     Takes a base-name and makes a unique object name for it 
  Parameters:  base-name (INPUT)  the suggested name of the object.
               name      (OUTPUT) the valid name
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER base-name AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER obj-type  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER name      AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE ch         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cnt        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ipos       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE itest      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE npos       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE valid-name AS CHARACTER NO-UNDO.
   
  /* Make sure all the characters in the name are valid. */
  ASSIGN 
    valid-name = ""
    cnt        = LENGTH (base-name, "CHARACTER":U)
    npos       = 1.
    
  DO ipos = 1 TO cnt:
    ch = SUBSTRING(base-name, ipos, 1, "CHARACTER":U).
    IF INDEX(". ":U, ch) > 0 THEN 
      valid-name = valid-name + "_". /* Replace spaces and "."'s. */
    ELSE DO:   
      /* Check for valid progress 4gl name characters. Remember that the
         first character of the name can't be special or numeric. */
      IF (npos eq 1 AND INDEX ("ETAONRISHDLFCMUGYPWBVKXJQZ":U, ch) > 0) OR
         (npos >  1 AND INDEX ("#$%&-_0123456789ETAONRISHDLFCMUGYPWBVKXJQZ":U, ch) > 0 )
      THEN ASSIGN 
        valid-name = valid-name + ch
        npos       = npos + 1. 
    END.
  END. /* DO ipos.. */
  
  /* Remove any leading or trailing "funny characters. */
  valid-name = TRIM(valid-name, "_-":U).
  
  /* Worry about a really long name exceeding 32 character. */
  IF LENGTH(valid-name, "RAW":u) > 30 THEN
    valid-name = SUBSTRING(valid-name, 1, 30, "FIXED":U).
  
  /* Is the name blank? */
  IF valid-name eq "":U THEN valid-name = "html-object":U.
 
  /* Check that the name does not yet exist (in the current file, or as
     a Progress keyword). */
  ASSIGN 
    name  = valid-name
    itest = 1.

  DO WHILE CAN-FIND (_U WHERE _U._P-recid eq p_Proc-ID AND _U._TYPE eq obj-type
    AND _U._NAME eq name AND _U._TABLE eq ? AND _U._STATUS eq "NORMAL")
    OR KEYWORD (name) ne ?:
    ASSIGN 
      itest = itest + 1
      name  = valid-name + TRIM(STRING(itest,">>>>>9":U)).
  END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _drwhtml.p - end of file */
