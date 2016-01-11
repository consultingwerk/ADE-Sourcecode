&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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

  Authors: adams, hdaniels
  Created: 10/1998
  Updated: 04/26/01 jep   IZ 993 - Check Syntax support for local WebSpeed V2 files.
                          Added _L._LO-NAME = "Master Layout" assignments.

------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_proc-id  AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER p_Verbose  AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER p_Return   AS LOGICAL   NO-UNDO INITIAL TRUE.

/* Shared variables --                                                       */
{ adeweb/htmwidg.i }      /* Design time Web _HTM TEMP-TABLE.              */
{ adeuib/sharvars.i }     /* Shared variables                              */
{ adeuib/uniwidg.i }      /* Universal Widget TEMP-TABLE definition        */
{ adeuib/layout.i }       /* Layout TEMNP-TABLE definitions               */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure

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
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

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
DEFINE VARIABLE frame-bar    AS HANDLE    NO-UNDO.

DEFINE BUFFER win_U FOR _U.
DEFINE BUFFER frm_U FOR _U.

/* ***************************  Main Block  *************************** */

/* Is there anything to find. */
IF CAN-FIND (FIRST _HTM WHERE _HTM._P-recid eq p_proc-id AND _HTM._U-recid eq ?)
THEN DO:  
  /* We will draw in the current frame. */
  FIND frm_U WHERE frm_U._HANDLE = _h_frame NO-ERROR.
  FIND win_U WHERE win_U._HANDLE = _h_win.  
    
  /* Removing query image from tree-view made _h_frame sometimes point to query */  
  IF NOT AVAILABLE frm_U 
  OR frm_U._TYPE <> "FRAME":U THEN  
  DO:
    /* Create temp-table records. */
    CREATE _L.
    CREATE _C.
    CREATE _Q.
    CREATE frm_U.
    
    /* Create frame widget. */
    CREATE FRAME frm_U._HANDLE
      ASSIGN 
        PARENT = _h_win
        HIDDEN = TRUE.     

    ASSIGN      
      /*  Set shared variable */ 
      _h_frame             = frm_U._HANDLE
    
      /* Create links between objects. */
      frm_U._WINDOW-HANDLE = _h_win
      frm_U._parent-recid  = RECID(win_u) 
      frm_U._x-recid       = RECID(_C)
      frm_U._lo-recid      = RECID(_L)
      _L._u-recid          = RECID(frm_U)
      _L._LO-NAME          = "Master Layout"
      _C._q-recid          = RECID(_Q)   
               
      /* Set other IMPORTANT attributes */
      _L._LO-NAME          = "Master Layout":U  
      frm_U._NAME          = "Web-Frame":U
      frm_U._TYPE          = "FRAME":U
      frm_U._status        = "NORMAL":U
      frm_U._WIN-TYPE      = _cur_win_type
      frm_U._SENSITIVE     = TRUE
      frm_U._PARENT        = frm_U._HANDLE:PARENT
      _C._TITLE            = FALSE
      _L._ROW              = 1   
      _L._COL              = 1  
      _L._WIDTH            = 80
      _L._HEIGHT           = 20
      _L._WIN-TYPE         = _cur_win_type
      _L._COL-MULT         = IF _cur_win_type THEN 1 ELSE _tty_col_mult
      _L._ROW-MULT         = IF _cur_win_type THEN 1 ELSE _tty_row_mult.
      
    ASSIGN
      frm_U._HANDLE:WIDTH   = _L._WIDTH * _cur_col_mult
      frm_U._HANDLE:HEIGHT  = _L._HEIGHT * _cur_row_mult
      frm_U._HANDLE:COLUMN  = MAX(1,(_L._COL - 1) * _cur_col_mult + 1)
      frm_U._HANDLE:ROW     = MAX(1,(_L._ROW - 1) * _cur_row_mult + 1).

    CREATE RECTANGLE frame-bar
           ASSIGN FRAME       = frm_U._HANDLE
                  X           = 0
                  Y           = IF _C._SIDE-LABELS THEN 0 ELSE 1
                  HEIGHT-P    = 1
                  WIDTH       = _L._WIDTH - (frm_U._HANDLE:BORDER-LEFT + frm_U._HANDLE:BORDER-RIGHT)
                  BGCOLOR     = 0
                  FGCOLOR     = 0
                  FILLED      = TRUE
                  EDGE-PIXELS = 1
                  VISIBLE     = FALSE.
    ASSIGN _C._FRAME-BAR = frame-bar.

  END. /* IF not availabale frm_u */ 
  
  /* Look for _HTM records without a _U associated. Create the _U records. */
  FOR EACH _HTM WHERE _HTM._P-recid eq p_proc-id
                AND _HTM._U-recid eq ?
                BY  _HTM._i-order:
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
    CREATE _L.
    
    ASSIGN
       /* Create links between objects. */
       _U._WINDOW-HANDLE = _h_win
       _U._x-recid       = RECID(_F)
       _U._lo-recid      = RECID(_L)
       _U._parent-recid  = RECID(frm_U) 
       _L._u-recid       = RECID(_U)
       _L._LO-NAME       = "Master Layout"
       _HTM._U-recid     = RECID(_U)
           
      /* Standard Attibutes. */      
       _F._FRAME        = frm_U._HANDLE
       _U._PARENT       = _F._FRAME:FIRST-CHILD 
       _U._NAME         = new-name
       _U._LABEL        = _HTM._HTM-NAME       
       _U._TYPE         = _HTM._MDT-TYPE
       /* _U._SUBTYPE      = "" Shouldn't need to set this. Take default of unknown. -jep */
       _U._WIN-TYPE     = _cur_win_type
       _L._WIN-TYPE     = _cur_win_type
       _L._COL-MULT     = IF _cur_win_type THEN 1 ELSE _tty_col_mult
       _L._ROW-MULT     = IF _cur_win_type THEN 1 ELSE _tty_row_mult
       _L._NO-LABELS    = TRUE
       _L._LO-NAME      = "Master Layout":U 
       _L._ROW          = 1  /* Objects aren't displayed. Position doesn't really matter. */
       _L._COL          = 1  /* Objects aren't displayed. Position doesn't really matter. */
           
      /* By default, assume items are CHARACTER fields. */
       _F._DATA-TYPE    = IF _U._TYPE eq "TOGGLE-BOX":U 
                          THEN "LOGICAL":U 
                          ELSE "CHARACTER":U.
    
    CREATE VALUE(_HTM._MDT-TYPE) _U._HANDLE
      ASSIGN FRAME = frm_U._HANDLE.    
       
    /* The height of the object will depend on the number of entries. */
    CASE _U._TYPE:
      WHEN "EDITOR":U OR WHEN "SELECTION-LIST":U THEN 
        ASSIGN _L._WIDTH  = 20  
               _L._HEIGHT = 4.
      WHEN "RADIO-SET":U THEN 
        ASSIGN _L._WIDTH  = 20
               _L._HEIGHT = num-itms + 1.
      WHEN "FILL-IN":U OR WHEN "COMBO-BOX":U THEN  
        /* Allow these to have a large format, but keep the widget small
           enough to fit in the frame. */
        ASSIGN _F._FORMAT = "X(256)":U
               _L._WIDTH  = 20
               _L._HEIGHT = 1.
      WHEN "TOGGLE-BOX":U THEN  
        ASSIGN _L._WIDTH  = 20
               _L._HEIGHT = 1.
      OTHERWISE 
        ASSIGN _L._WIDTH  = 1
               _L._HEIGHT = 1.
       
    END CASE.  
              
    /* Add the number of items for a Radio-set. */
    IF _U._TYPE eq "RADIO-SET" THEN 
      RUN build_radio_set (num-itms).         

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
      _F._LIST-ITEMS = (IF _F._LIST-ITEMS > "" 
                        THEN _F._LIST-ITEMS + ',':U + CHR(10) 
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

  DO WHILE 
     CAN-FIND (_U WHERE _U._WINDOW-HANDLE = _h_win                     
                  AND   _U._TYPE          = obj-type
                  AND   _U._NAME          = name 
                  AND   _U._TABLE         = ? 
                  AND   _U._STATUS        = "NORMAL")
               OR KEYWORD (name) ne ?:
    ASSIGN 
      itest = itest + 1
      name  = valid-name + TRIM(STRING(itest,">>>>>9":U)).
  END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

