&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*-----------------------------------------------------------------------------
File: _uibinfo.p

  Input Parameters:
     pi_context - The context (integer) of the object to access. 
                  [If ? then the UIB the current procedure]
                  This value can be a:
                   - context for an object - obtained, for example, with
                        run adeuib/_uibinfo.p 
                            (?,"Btn_OK","CONTEXT", OUTPUT i_context).
                   - context for the Procedure -obtained, for example, with
                        run adeuib/_uibinfo.p 
                            (?, ?, "PROCEDURE", OUTPUT i_context).
                   - context for the Code Section -obtained, for example, with
                        run adeuib/_accsect.p 
                            ("GET", ?, "MAIN-CODE-BLOCK", 
                              INPUT-OUTPUT i_context,
                              INPUT-OUTPUT c_code).
                  
     p_name     - Name of the object in the form:
                    object [IN FRAME frame-name] [IN WINDOW window-name]
                  or
                    object [IN FRAME frame-name] [IN PROCEDURE file-name]
                  or
                    HANDLE object
                                       
                  NOTES:   
                  * If p_context is given, then p_name is IGNORED.
                  
                  * If the frame or window phrase is ommitted, then the
                    current window and frame are assumed. The "frame" is 
                    especially optional.  If an object is unique in
                    a window, then you may refer to it as 
                       object IN WINDOW window-name
                    
                  * To refer to a window, frame, procedur or palette-item
                    then preface the object
                    with the type:
                       FRAME f [IN WINDOW w] - to find frame f   
                       WINDOW w - to find window w.
                       PROCEDURE p.w - to find a procedure with file-name p.w
                    
                    Special case:   
                       PALETTE-ITEM SmartDataObject to find a palette 
                                    item with name SmartDataObject
                           
                  * The following special cases also apply:
                       ? - get the current object (in the UIB's main window)
                       FRAME ? - the current frame
                       WINDOW ? - the current window
                       PROCEDURE ? - the current procedure
                    
                  * If you use the HANDLE <handle> to reference the object,
                    the handle can be either a WIDGET-HANDLE of the object
                    OR a procedure-handle for a SmartObject.
 
      p_request - What is requested:
                  "NAME" - return name of object
                  "PROCEDURE" - The STRING(pi_context) for the procedure                                 
                  "FILE-NAME" - name of file where object is stored (if not
                                saved).
                  "TEMPLATE" - return TRUE or FALSE depending on whether the
                               current object is a Template.
                  "TYPE" - return type of object
                  "HANDLE" - return widget-handle of object
                  "PROCEDURE-HANDLE" - return the procedure handle of the
                             object (if it is a SmartObject)       
                  "&FRAME-NAME [RETURN NAME]" (8.1) - 
                           - the context id, or name, of the FRAME-NAME, or ?
                  "&QUERY-NAME [RETURN NAME]" (8.1) - 
                           - the context id, or name, of QUERY-NAME, or ?
                  "&BROWSE-NAME [RETURN NAME]"(8.1) - 
                           - the context id, or name, of BROWSE-NAME, or ?
                  "CONTEXT" - context of the object listed object
                              (integer ID based on an internal RECID)
                  "CONTAINS *|<comma delimited list of types (no spaces)>
                            [logical attribute phrase]
                            [RETURN [CONTEXT | NAME]"
                    - returns all objects contained in the current context
                     (of a type OR with key toggles set).  By default, we
                     return the context id of the items that match the filter, 
                     but you can ask for the list of names.
                  "FRAMES" - returns all frames (in a window).  This is shorthand
                             for "CONTAINS FRAME RETURN NAME"
                  "FIELDS" - returns dbfields in frame or dbfields in browse
                                or dbfields in SmartData (Query).
                  "EXTERNAL-TABLES" - returns the list of external tables for
                                      a procedure
                  "TABLES" - the tables used by the query of a FRAME, BROWSE
                             or QUERY object.
                  "4GL-QUERY" - the 4GL query for the query of a FRAME, BROWSE,
                             or QUERY object.
                  "WBX-FILE-NAME" - name of the .wbx in which run-time attributes
                                    will be saved for the VBX's in a procedure.
                  "HTML-FILE-NAME" - name of the HTML file for Web Objects.
                  "COMPILE-INTO-DIR" - the directory in which the .W will get
                                       compiled to.
                  "SECTIONS PROCEDURE[,FUNCTION] [RETURN CONTEXT | NAME] - returns
                        the context id (usable with adeuib/_accsect.p) for internal
                        PROCEDURE's or FUNCTION's defined in a file.  The names can
                        optionally be returned.

                  "DataObject" - The filename of the DataObject associated with
                                 the procedure.

                 
                 [logical-attribute-phrase]
                 --------------------------
                 You can specify a particular subset of objects to return
                 by specifying a logical attribute and a value for it. 
                 Attributes include:
                   DISPLAY, ENABLE, LIST-1...LIST-6, HIDDEN, MANUAL-HIGHLIGHT,
                   MOVABLE, RESIZABLE, SELECTABLE, SELECTED (in the UIB),
                   SENSITIVE, SHARED
                 Attribute values must be a logical expression:
                    TRUE, and YES are counted as TRUE
                    All other values are accepted as false.
                    
                 Samples:
                   All Buttons in List-1
                     "CONTAINS BUTTON LIST-1 YES"
                   All Objects SELECTED in the UIB
                     "CONTAINS * SELECTED YES"
            
      For palette-item the following values is valid            
                 "ATTRIBUTE"    Attribute list with filter directory list etc. 
                 "LABEL"        Label without &  
                 "WINDOWSLABEL" Label with & 
                 "FILES"      .cst filename
                                      
Other Options:
    You can get some SESSION information if you request the following:
    pi_context = ?
    p_name     = "SESSION"
    p_request  = "PROCEDURES [RETURN CONTEXT | NAME]"
                            This will return a list of open procedures in the UIB.
                            Untitled procedures show with names = "?" in the list,
                            so you are almost always better off asking for CONTEXT 
                           (which is the default).
                 "brokerURL"  - Returns the broker from Web config preferences
                 "URLhost"    - Returns the host from the Web config broker URL
                 "REMOTE"     - Returns "TRUE" if remote mode. 
                 "WebBrowser" - Returns the browser from Web config preferences
                 "ABLicense"  - Returns the license value where
                                1 = Client/Server only
                                2 = WebSpeed only
                                3 = Client/Server and WebSpeed
                 "DefaultFunctionType" - Returns the default function data return
                                type when creating a new function in the
                                section editor. Default is CHARACTER.
       
Output Parameters:
    p_info  - Output value (converted to a string), or SPACE delimited list 
              In some cases, p_info will be UNKNOWN (?) [For example, if there
              is no windows open in the UIB.]

  Author: Wm. T. Wood
  Created: Feb. 1995
  
  Modified: 
     8/3/99   tsm   Changed link-info to ignore links for deleted objects
     9/28/98  jep   Added "DefaultFunctionType"
     7/9/98   wood  Added "SECTIONS..." options
     6/19/98  adams Added "WebBrowser"
     6/1/98   HD    Added logic for WebReport in flds-info 
     2/27/98  HD    Added "brokerURL" and "REMOTE".  
     2/6/98   HD    Added "HTML-FILE-NAME". 
     3/10/97  GFS   Fixed code in "TABLES" to handle "table2 OF table1"
     3/4/97   GFS   Made sure that no deleted objects return with "CONTAINS" 
     9/18/95  WOOD  Return ? if there is NO current procedure
     8/1/95   GFS   Added "WBX-FILE-NAME" AND "COMPILE-INTO-DIR".
     4/7/95   GFS   Added "HANDLE", "CONTAINS", "EXTERNAL-TABLES",
                      "TABLES" and "4GL-QUERY" for p_request.
     3/31/03  DB    Added support for DATA-LOGIC-PROCEDURE and
                    ACTION for p_request                 
                  
-----------------------------------------------------------------------------*/

/* Define Parameters. */     
DEFINE INPUT  PARAMETER pi_context  AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER p_name      AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER p_request   AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER p_info      AS CHAR    NO-UNDO.

/* Include Files. */
{adeuib/uniwidg.i}             /* Definition of Universal Widget TEMP-TABLE  */
{adeuib/triggers.i}            /* Definition of Triggers TEMP-TABLE          */
{adeuib/sharvars.i}            /* Shared UIB variables                       */
{adeuib/property.i}
{adeuib/brwscols.i}
{adeuib/custwidg.i}
{adeuib/links.i}
{src/adm2/globals.i}  /* Dynamics global variables */

/* Local Variables */              
DEFINE VAR contains-list AS CHAR    NO-UNDO.  
DEFINE VAR attr-OK-list  AS CHAR    NO-UNDO.
DEFINE VAR ch            AS CHAR    NO-UNDO.
DEFINE VAR cnt           AS INTEGER NO-UNDO.
DEFINE VAR h             AS HANDLE  NO-UNDO.
DEFINE VAR i             AS INTEGER NO-UNDO.
DEFINE VAR j             AS INTEGER NO-UNDO.
DEFINE VAR token         AS CHAR    NO-UNDO EXTENT 20.
DEFINE VAR ltest         AS LOGICAL NO-UNDO.
DEFINE VAR l_returnName  AS LOGICAL NO-UNDO.

/* These character fields correspond to _h_win, _h_frame etc.  However they
   list the NAME, not the handle */
DEFINE VAR c_cur_widg AS CHAR NO-UNDO.
DEFINE VAR c_frame    AS CHAR NO-UNDO.
DEFINE VAR c_win      AS CHAR NO-UNDO.
DEFINE VAR c_proc     AS CHAR NO-UNDO.

DEFINE VAR l_proc-info AS LOGICAL NO-UNDO.

DEFINE BUFFER win_U   FOR _U.
DEFINE BUFFER frame_U FOR _U.
DEFINE BUFFER x_U FOR _U.
DEFINE BUFFER x_C FOR _C.
DEFINE BUFFER x_Q FOR _Q.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



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
         HEIGHT             = 10.1
         WIDTH              = 51.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Check the worst case that nothing was specified. */
IF pi_context eq ? AND INDEX("?", p_name) > 0 AND NOT VALID-HANDLE(_h_win) 
THEN DO:
  RUN error-msg ( "No procedure or window is currently selected." ).
  RETURN "Error".
END.                                               

IF p_request = "FRAMES" THEN 
  p_request = "CONTAINS FRAME RETURN NAME".

/* TRIM the input request and break it into tokens. Skip over blank entries. */
ASSIGN p_request = TRIM(p_request) 
       cnt       = MIN ( NUM-ENTRIES(p_request," "),  EXTENT (token))
       j         = 1.
 
DO i = 1 to cnt:
  token[j] = ENTRY( i, p_request, " ").
  /* Ignore blank entries */
  IF token[j] NE "" THEN j = j + 1.
END.

/* Check the special SESSION requests */
IF pi_context eq ? AND p_name eq "SESSION" THEN DO:
  IF token [1] = "_user_hints=?" THEN DO:
    FIND FIRST _uib_prefs.
    _uib_prefs._user_hints = ?.
  END.
  ELSE
    RUN parse-session-request.
  RETURN.
END.

IF pi_context eq ? AND p_name begins "PALETTE-ITEM" THEN DO:
  RUN parse-palette-request.
  RETURN.
END.

/* If pi_context is not specified, then we have to parse it. */
IF pi_context eq ? THEN DO:  
  /* Remove excess spaces [Also handle case of ? -- treat this like "?". */
  p_name = IF p_name eq ? THEN "?" ELSE TRIM(p_name).
  /* Parse the name. Consider special cases first. */
  CASE p_name:
    WHEN "?" THEN DO:
      IF VALID-HANDLE (_h_cur_widg) 
      THEN FIND _U WHERE _U._HANDLE eq _h_cur_widg NO-ERROR. 
    END. /* ? */
    WHEN "FRAME ?" THEN DO:
      IF VALID-HANDLE (_h_frame) 
       THEN FIND _U WHERE _U._HANDLE eq _h_frame NO-ERROR. 
      ELSE DO:
        RUN error-msg("There is no frame currently selected."). 
        RETURN.
      END.
    END. /* FRAME ? */
    WHEN "WINDOW ?" THEN DO:
      IF VALID-HANDLE (_h_win) 
      THEN FIND _U WHERE _U._HANDLE eq _h_win.  
    END. /* WINDOW ? */
    WHEN "PROCEDURE ?" THEN DO:
      IF VALID-HANDLE (_h_win) 
      THEN FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.  
      l_proc-info = YES.  /* User wants procedure information */
    END. /* PROCEDURE ? */
    OTHERWISE DO: /* Really parse it */
      cnt = NUM-ENTRIES(p_name, " ":U).
      DO i = 1 to cnt:
        CASE ENTRY(i, p_name, " ":U):
          WHEN "FRAME"     THEN c_frame = ENTRY(i + 1, p_name, " ":U).
          WHEN "WINDOW"    THEN c_win   = ENTRY(i + 1, p_name, " ":U). 
          WHEN "PROCEDURE" THEN DO: 
            IF i eq 1 THEN l_proc-info = YES.  /* User just wants procedure information */
            c_proc  = ENTRY(i + 1, p_name, " ":U). 
          END.
          WHEN "HANDLE" THEN DO:
            ASSIGN ch = ENTRY(i + 1, p_name, " ":U)
                   h  = WIDGET-HANDLE(ch) .
            /* Is the handle a SmartObject handle? */
            IF VALID-HANDLE(h) THEN DO:
              IF h:TYPE eq "PROCEDURE":U THEN DO:
                FIND _S WHERE _S._HANDLE eq h NO-ERROR.
                IF AVAILABLE (_S) THEN FIND _U WHERE _U._x-recid eq RECID(_S).
              END.
              ELSE DO:
                FIND _U WHERE _U._HANDLE eq h NO-ERROR. 
              END.  
            END.  
          END.
          OTHERWISE IF i eq 1 THEN c_cur_widg = ENTRY(1,p_name, " ":U).
        END CASE.  /* Entry(i,p_name) */
      END. /* DO...*/
     /* Parse the name */
     RUN find_U.
     IF RETURN-VALUE eq "Error" THEN RETURN "Error".
     END. /* OTHERWISE DO... */
  END CASE. /* Case p_name */      
  /* If we get here and there is NO current object, the return ? as the
     information. This is most likely to occur if there is no UIB windows. */
  IF NOT AVAILABLE _U AND NOT AVAILABLE _P THEN DO:
    p_info = ?.
    RETURN.
  END.
END.
ELSE DO:   
  /* Map a procedure to a window */
  FIND _P WHERE RECID(_P) eq pi_context NO-ERROR.
  IF AVAILABLE _P THEN l_proc-info = yes.  /* User wants procedure information */
  ELSE DO: 
    /* See if it is a Trigger. */
    FIND _TRG WHERE RECID(_TRG) eq pi_context NO-ERROR.
    IF AVAILABLE _TRG THEN DO:
      /* Get the _U record.  And if it not a Trigger, then get the _P record
         a set up to return procedure information. */
      FIND _U WHERE RECID(_U) eq _TRG._wRECID.
      IF _TRG._tSection NE "_TRIGGER" THEN DO:
        FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.
        l_proc-info = YES.
      END.
    END.
    ELSE DO:
      /* Get the object of interest */
      FIND _U WHERE RECID(_U) eq pi_context NO-ERROR.
      IF NOT AVAILABLE _U THEN DO:
        RUN error-msg ("Context ID does not point to a known object or code section:" + 
                       STRING(pi_context) + CHR(10) +
                       "If the context is unknown, use '?'.").
        RETURN "Error".  
      END.
    END.
  END.
END. /* IF pi_context ne ?... */

/* Return the desired information. */
RUN process-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Add_It) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Add_It Procedure 
PROCEDURE Add_It :
/*------------------------------------------------------------------------------
  Purpose:    Adds the current x_U to output list (p_info)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cname AS CHARACTER NO-UNDO.
  
  /* Add a "," if necessary. */
  IF p_info ne "":U THEN p_info = p_info + ",":U.
    
  IF l_returnName
  THEN ASSIGN cname  = (IF x_U._TABLE NE ? 
                        THEN x_U._DBNAME + ".":U + x_U._TABLE + ".":U 
                        ELSE "")
                       + x_U._NAME 
              p_info = p_info + cname.
  ELSE ASSIGN p_info = p_info + STRING(RECID(x_U)).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-contains-info) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE contains-info Procedure 
PROCEDURE contains-info :
/*  ----------------------------------------------------------------------
  Procedure: contains-info:   
  
     Get the "Contains" information. That is, the list of objects that
     are in the object, that also meet the required criteria. 
  
  Parameters: <none>
 ---------------------------------------------------------------------- */
  /* Let's figure out what validation list to use and starting position of attr. */
  ASSIGN contains-list = token[2]
         ltest         = CAN-DO ("true,yes", token[4]).
  FOR EACH x_U WHERE ((l_Proc-Info AND x_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE)
                  OR (NOT l_Proc-Info AND  x_U._PARENT-RECID = RECID(_U)) 
                  AND x_U._STATUS NE "DELETED"):
    IF token[3] = "RETURN" OR token[3] = "" THEN DO: /* skip prop check, since none given */
      l_returnName = (token[3] eq "RETURN":U and token[4] eq "NAME":U).
      IF CAN-DO(contains-list, x_U._TYPE) AND x_U._STATUS NE "DELETED" THEN RUN Add_it.
      NEXT.
    END.
    ELSE l_returnName = (token[5] eq "RETURN":U and token[6] eq "NAME":U).
    /* _prop is used to filter out widget types which do not support 
     * the given attribute. Note that not all attributes are in _prop, so we
     * need to check some explicitly.
     */ 
    FIND _prop WHERE _prop._name eq token[3] NO-ERROR.
    IF AVAILABLE _prop THEN attr-OK-list = _prop._WIDGETS.
    ELSE DO:   
      /* Special cases. -- 
          LIST-1...LIST-N are supported on everything.
          SELECTED - for everything. */  
/*    &MESSAGE [_uibinfo.p] Remove explicit test when LIST-n in _prop (wood) */
      IF token[3] BEGINS "List-" OR token[3] eq "SELECTED":U THEN attr-OK-LIST = "*". 
      ELSE attr-OK-List = "".
    END.
    IF CAN-DO(contains-list, x_U._TYPE) AND CAN-DO(attr-OK-List, x_U._TYPE)
    THEN DO:
      CASE token[3]:
        WHEN "DISPLAY"          THEN IF x_U._DISPLAY          = ltest THEN RUN Add_It.
        WHEN "ENABLE"           THEN IF x_U._ENABLE           = ltest THEN RUN Add_It.
        WHEN "LIST-1"           THEN IF x_U._USER-LIST[1]     = ltest THEN RUN Add_It.
        WHEN "LIST-2"           THEN IF x_U._USER-LIST[2]     = ltest THEN RUN Add_It.
        WHEN "LIST-3"           THEN IF x_U._USER-LIST[3]     = ltest THEN RUN Add_It.
        WHEN "LIST-4"           THEN IF x_U._USER-LIST[4]     = ltest THEN RUN Add_It.
        WHEN "LIST-5"           THEN IF x_U._USER-LIST[5]     = ltest THEN RUN Add_It.
        WHEN "LIST-6"           THEN IF x_U._USER-LIST[6]     = ltest THEN RUN Add_It.
        WHEN "HIDDEN"           THEN IF x_U._HIDDEN           = ltest THEN RUN Add_It.
        WHEN "MANUAL-HIGHLIGHT" THEN IF x_U._MANUAL-HIGHLIGHT = ltest THEN RUN Add_It.
        WHEN "MOVABLE"          THEN IF x_U._MOVABLE          = ltest THEN RUN Add_It.
        WHEN "RESIZABLE"        THEN IF x_U._RESIZABLE        = ltest THEN RUN Add_It.
        WHEN "SELECTABLE"       THEN IF x_U._SELECTABLE       = ltest THEN RUN Add_It.
        WHEN "SELECTED"         THEN IF x_U._SELECTEDib       = ltest THEN RUN Add_It.
        WHEN "SENSITIVE"        THEN IF x_U._SENSITIVE        = ltest THEN RUN Add_It.
        WHEN "SHARED"           THEN IF x_U._SHARED           = ltest THEN RUN Add_It.
      END CASE.
    END.
  END.
END PROCEDURE. /* contains-info */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-error-msg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE error-msg Procedure 
PROCEDURE error-msg :
/*------------------------------------------------------------------------------
  Purpose:     Output a standared error message.
  Parameters:  msg - the message to output
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER msg AS CHAR NO-UNDO.  
  MESSAGE "[" + program-name(1) + "]" SKIP msg VIEW-AS ALERT-BOX ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fields-info) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fields-info Procedure 
PROCEDURE fields-info :
/*  ----------------------------------------------------------------------
  Procedure: fields-info:   
  Purpose:   Get the "FIELDS" that are in the object.
  Parameters: po_info - (CHAR) the information 
 ---------------------------------------------------------------------- */
  DEFINE OUTPUT PARAMETER po_info AS CHAR NO-UNDO.

  DEFINE VARIABLE IsSmartData     AS LOG  NO-UNDO.
  DEFINE VARIABLE HasQueryFields  AS LOG  NO-UNDO.

  /* For a browse, create a list of browse columns (fields) 
   * For a query, create a list of _bc columns (SmartData or WebReport)
   */ 
  
  ASSIGN 
    isSmartData    =  _U._TYPE = "QUERY":U AND _U._SUBTYPE = "SmartDataObject":U. 
    HasQueryfields =  _U._TYPE = "QUERY":U 
                      AND CAN-FIND(FIRST _BC WHERE _BC._x-recid = RECID(_U)).                       
  
  IF isSmartData THEN 
  DO:
    FOR EACH _BC WHERE _BC._x-recid = RECID(_U):           
        po_info = (IF po_info eq "":U THEN "":U ELSE po_info + ",":U)
                + _BC._DISP-NAME.
    END.   
  END.  
  ELSE IF _U._TYPE = "BROWSE":U OR HasQueryFields THEN 
  DO:
    FOR EACH _BC WHERE _BC._x-recid = RECID(_U):           
      IF _BC._NAME <> "":U THEN DO:
        po_info = (IF po_info eq "":U THEN "":U ELSE po_info + ",":U)
                + _BC._DBNAME + ".":U + _BC._TABLE + "." + _BC._NAME.
      END.
      ELSE IF _BC._DISP-NAME <> "" AND _BC._DISP-NAME <> ? THEN DO:
         /* calc fld*/
         po_info = (IF po_info eq "":U THEN "":U ELSE po_info + ",":U)
                 + _BC._DISP-NAME.
      END.
    END.
  END.
  ELSE DO:
    /* For all widgets in the current window, write the list of
       database fields (db.table.field) to the output list */
    FOR EACH x_U WHERE x_U._WINDOW-HANDLE eq _h_win
                   AND x_U._STATUS eq "NORMAL":U:
      /* Is this a database field? */
      IF x_U._TABLE ne ? THEN DO:
        IF po_info ne "" THEN po_info = po_info + ",":U.
        po_info = po_info + x_U._DBNAME + ".":U + x_U._TABLE + ".":U + x_U._NAME.
      END.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-find_U) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE find_U Procedure 
PROCEDURE find_U :
/*------------------------------------------------------------------------------
  Purpose:     Based on the name given, find the associated _U (or _P)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Get the procedure */
  IF c_proc ne "" THEN DO:
    FIND _P WHERE _P._SAVE-AS-FILE eq c_proc.
    IF NOT AVAILABLE _P THEN DO:
      RUN error-msg ("No procedure has file name: " + c_proc).
      RETURN "Error".
    END.
  END.
  
  /* Get the window. (use the current window if none is selected). */
  IF c_win eq "" THEN DO:
     /* We have already checked that _h_win exists. */
     FIND win_U WHERE win_U._HANDLE eq _h_win NO-ERROR. 
     IF NOT AVAILABLE win_U THEN DO:
       RUN error-msg ("There is no current default window in the UIB.").
       RETURN "Error". 
     END.
  END.
  ELSE DO:
    IF AVAILABLE(_P) THEN DO:
      FIND win_U WHERE RECID(win_U) eq _P._u-recid.
      IF win_U._NAME ne c_win THEN DO:
        RUN error-msg ("The Procedure does not contain a window with name: " + c_win).
        RETURN "Error".
      END.
    END.
    ELSE DO:
      FIND win_U WHERE CAN-DO("DIALOG-BOX,WINDOW", win_U._TYPE) AND win_U._NAME eq c_win. 
      IF NOT AVAILABLE win_U THEN DO:
        RUN error-msg ("No unique window or dialog-box can be found with name: " + c_win).
        RETURN "Error".
      END.
    END.
  END. 
 
 
  /* Get the frame */
  IF c_frame ne "" THEN DO:
    FIND frame_U WHERE frame_U._WINDOW-HANDLE eq win_U._HANDLE
                   AND frame_U._STATUS eq "NORMAL" 
                   AND frame_U._NAME eq c_frame NO-ERROR.
    
    IF NOT AVAILABLE frame_U THEN DO:
      RUN error-msg ("No frame in the current procedure has name: " + c_frame).
      RETURN "Error".
    END.
  END.
  
  /* Get the individual widget */
  IF c_cur_widg ne "" THEN DO:
    /* If we know the frame then the widget must parent to it. */
    IF AVAILABLE (frame_U) THEN DO:
      /* Look for any widget in the current frame */
      CASE NUM-ENTRIES(c_cur_widg,"."): /* Might be qualified with dbname and/or tbl name ! */
        WHEN 1 THEN
          FIND _U WHERE _U._parent-recid eq RECID(frame_U)
                    AND _U._STATUS EQ "NORMAL" 
                    AND _U._NAME   EQ c_cur_widg NO-ERROR.
        WHEN 2 THEN
          FIND _U WHERE _U._parent-recid eq RECID(frame_U)
                    AND _U._STATUS EQ "NORMAL" 
                    AND _U._TABLE  EQ ENTRY(1,c_cur_widg,".")
                    AND _U._NAME   EQ ENTRY(2,c_cur_widg,".") NO-ERROR.
        WHEN 3 THEN
          FIND _U WHERE _U._parent-recid eq RECID(frame_U)
                    AND _U._STATUS EQ "NORMAL" 
                    AND _U._DBNAME EQ ENTRY(1,c_cur_widg,".")
                    AND _U._TABLE  EQ ENTRY(2,c_cur_widg,".")
                    AND _U._NAME   EQ ENTRY(3,c_cur_widg,".") NO-ERROR.
      END CASE.
      IF NOT AVAILABLE _U THEN DO:
        RUN error-msg ("No object in FRAME " + frame_U._NAME + " has name: " + c_cur_widg).
        RETURN "Error".
      END. 
    END.
    ELSE DO:
      /* Look for any widget in the current window */
      CASE NUM-ENTRIES(c_cur_widg,"."):
        WHEN 1 THEN
          FIND _U WHERE _U._WINDOW-HANDLE EQ win_U._HANDLE
                    AND _U._STATUS        EQ "NORMAL" 
                    AND _U._NAME          EQ c_cur_widg NO-ERROR.
        WHEN 2 THEN
          FIND _U WHERE _U._WINDOW-HANDLE EQ win_U._HANDLE
                    AND _U._STATUS        EQ "NORMAL" 
                    AND _U._TABLE         EQ ENTRY(1,c_cur_widg,".")
                    AND _U._NAME          EQ ENTRY(2,c_cur_widg,".") NO-ERROR.
        WHEN 3 THEN
          FIND _U WHERE _U._WINDOW-HANDLE EQ win_U._HANDLE
                    AND _U._STATUS        EQ "NORMAL" 
                    AND _U._DBNAME        EQ ENTRY(1,c_cur_widg,".")
                    AND _U._TABLE         EQ ENTRY(2,c_cur_widg,".")
                    AND _U._NAME          EQ ENTRY(3,c_cur_widg,".") NO-ERROR.
      END CASE.
      IF NOT AVAILABLE _U THEN DO:
        RUN error-msg ("No object in the current procedure has name: " + c_cur_widg).
        RETURN "Error".
      END. 
    END.
  END.
  ELSE DO:
    /* If there was no current widget, then use the frame or window */
    CASE token[1]:
      WHEN "FRAME" THEN FIND _U WHERE RECID(_U) eq RECID(frame_U).
      WHEN "WINDOW" THEN FIND _U WHERE RECID(_U) eq RECID(win_U).
    END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-link-info) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE link-info Procedure 
PROCEDURE link-info :
/*------------------------------------------------------------------------------
  Purpose:     To get information about a link
  Parameters:  (None)
  Notes:       Currently this only has one case (data-source) but should be
               expanded as nessary in the future.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE linkType      AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE linkDirection AS CHARACTER        NO-UNDO.
 
  /* Token[2] shoulde be something like "DATA-SOURCE" */
  ASSIGN linkType      = ENTRY(1, token[2], "-":U)
         LinkDirection = ENTRY(2, token[2], "-":U).
  
  IF NOT CAN-DO("SOURCE,TARGET",linkDirection) THEN  
      RUN error-msg ("Link reference must be of form <Linkname>-source" +
                     "or -target, " + token[2] + " is invalid." ).
  
  /* Now find all of the links for what we are looking for  */
  IF LinkDirection = "SOURCE":U THEN DO:
    FOR EACH _admlinks 
        WHERE _admlinks._link-type EQ linkType AND
              _admlinks._link-dest EQ STRING(RECID(_U)) : 

      FIND _U WHERE RECID(_U) = INTEGER(_admlinks._link-source) NO-ERROR.

      /* Check if this is a link to THIS-PROCEDURE */
      IF NOT AVAIL _U THEN
      DO:
        FIND _P WHERE RECID(_P) = INTEGER(_admlinks._link-source) NO-ERROR.
        IF AVAIL _P THEN
           FIND _U WHERE _U._HANDLE = _P._WINDOW-HANDLE NO-ERROR.
      END.  
      /* Make sure that the SMO has not been deleted */
      IF AVAILABLE _U AND _U._STATUS NE "DELETED":U THEN
      DO:
      
        IF token[3] = "":U OR   /* If user want the context id */
          (token[3] = "RETURN":U AND token[4] = "CONTEXT":U) THEN 
            p_info = p_info + ",":U + STRING(RECID(_U)).         
        /* User wants a name  */
        ELSE IF token[3] = "RETURN":U AND token[4] = "NAME":U THEN 
           p_info = p_info + ",":U + _U._NAME.
      END. /* avail _U and no deleted */
    END. /* For each link where _U is the target */
  END.  /* If user wants source */
  
  ELSE DO:  /* User wants TARGET */
    FOR EACH _admlinks 
        WHERE _admlinks._link-type   EQ linkType AND
              _admlinks._link-source EQ STRING(RECID(_U)) : 

      FIND _U WHERE RECID(_U) = INTEGER(_admlinks._link-dest) NO-ERROR.
      /* Check if this is a link to THIS-PROCEDURE */
      IF NOT AVAIL _U THEN
      DO:
        FIND _P WHERE RECID(_P) = INTEGER(_admlinks._link-dest) NO-ERROR.
        IF AVAIL _P THEN
           FIND _U WHERE _U._HANDLE = _P._WINDOW-HANDLE NO-ERROR.
        
      END. /* if not avail _u */  
      
      /* Make sure that the SMO has not been deleted */
      IF AVAILABLE _U AND _U._STATUS NE "DELETED":U THEN
      DO:
        IF token[3] = "":U OR   /* If user want the context id */
          (token[3] = "RETURN":U AND token[4] = "CONTEXT":U) THEN 
            p_info = p_info + ",":U + STRING(RECID(_U)). 
        
        /* User wants a name  */
        ELSE IF token[3] = "RETURN":U AND token[4] = "NAME":U THEN 
           p_info = p_info + ",":U + _U._NAME.
      END. /* avail _U and no deleted */
    END. /* For each link where _U is the source*/
  END. /* user wants tyarget */
  p_info = LEFT-TRIM(p_info, ",":U).  /* Trim leading comma */
  
  /* messages is not a good idea in a request for info, 
  IF p_info = "":U THEN
    MESSAGE "No " + token[2] + " link has been defined for " + _U._NAME +
            " yet.".
  
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parse-palette-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE parse-palette-request Procedure 
PROCEDURE parse-palette-request :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR PaletteName AS CHAR NO-UNDO.
  DEF VAR ValidTypes  AS CHAR NO-UNDO INIT "ATTRIBUTES,TEMPLATE,LABEL,FILES":U.
  IF NOT CAN-DO(ValidTypes,P_request) THEN
  DO:
    RUN error-msg ("Could not understand PALETTE-ITEM request: " + p_request
                    + Chr(10)
                    + "Use one of the following values: " + ValidTypes  ).
  END.
  IF NUM-ENTRIES(p_name,"":U) = 1 THEN
  DO:
    RUN error-msg ("Could not understand: " + p_name
                   + CHR(10)
                   + "PALETTE-ITEM must have an objectname and space as separator")
                  .
    RETURN.  
  END.
  
  ASSIGN PaletteName = TRIM(ENTRY(NUM-ENTRIES(p_name,"":U),p_name,"":U)).   
  
  FIND _palette_item WHERE _palette_item._name = PaletteName NO-ERROR.
  
  IF NOT AVAIL _palette_item THEN 
  DO:
    RUN error-msg ("Could not find PALETTE-ITEM: " + PaletteName).
    RETURN.  
  END.
 
  CASE p_request:
    WHEN "Attributes":U THEN
        p_info = _palette_item._attr.
    WHEN "Label":U THEN
        p_info = _palette_item._label2.
    WHEN "template":U THEN
        p_info = _palette_item._new_template.
    WHEN "FILES":U THEN
       p_info  = _palette_item._files.        
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parse-session-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE parse-session-request Procedure 
PROCEDURE parse-session-request :
/*------------------------------------------------------------------------------
  Purpose:     Return the list of SESSION attributes
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF token [1] = "BrokerURL":U THEN 
     p_Info = _BrokerUrl.

  /* This code which extracts the host name from the Broker URL must match
     the code in adeuib/_abfuncs.w, it is duplicated here because it needs 
     to be accessed from the procedure window for remote file save 
     functionality and abfuncs is not available to the procedure window */
  ELSE IF token [1] = "URLhost" THEN 
    ASSIGN
      p_Info = IF TRIM(_BrokerUrl) BEGINS "http://":U THEN
                 SUBSTRING(TRIM(_BrokerUrl), 8, -1, "CHARACTER":U)
               ELSE TRIM(_BrokerUrl)
      p_Info = REPLACE(p_Info, "~\":U, "/":U)
      p_Info = " (":U + SUBSTRING(p_Info, 1, INDEX(p_Info,"/":U) - 1,
                           "CHARACTER":U) + ")":U.
  
  ELSE IF token [1] = "NewBrowser":U THEN
     p_Info = IF _open_new_browse THEN "TRUE":U ELSE "FALSE":U.
  
  ELSE IF token [1] = "Remote":U THEN
     p_Info = IF _remote_file THEN "TRUE":U ELSE "FALSE":U. 
  
  ELSE IF token [1] = "LocalHost":U THEN
     p_Info = _LocalHost.
  
  ELSE IF token [1] = "WebBrowser":U THEN
     p_Info = _WebBrowser.
  
  ELSE IF token [1] = "ABLicense":U THEN
     p_Info = STRING(_ab_license).
  
  ELSE IF token [1] = "DefaultFunctionType":U THEN
     p_Info = _default_function_type.

  ELSE IF token [1] = "USE_CUECARDS":U THEN 
  DO:
    FIND FIRST _uib_prefs.
    IF _uib_prefs._user_hints = TRUE THEN
      p_info = "TRUE".
    ELSE
      p_info = "FALSE".
  END.
  
  ELSE IF token[1] ne "PROCEDURES":U OR NOT CAN-DO (",CONTEXT,NAME":U, token[3]) THEN 
    RUN error-msg ("Could not understand SESSION request: " + p_request).
  ELSE 
  DO:
    IF token[3] eq "" THEN token[3] = "CONTEXT":U.
    /* Look at all the lists */
    FOR EACH _P:
      IF p_info ne ""           THEN p_info = p_info + ",":U.
      IF token[3] eq "CONTEXT " THEN p_info = p_info + STRING(RECID(_P)).
      ELSE IF _P._SAVE-AS-FILE eq ? THEN p_info = p_info + "?":U.
      ELSE p_info = p_info + _P._SAVE-AS-FILE.
    END.
  END. 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-preprocessor-name) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preprocessor-name Procedure 
PROCEDURE preprocessor-name :
/*  ----------------------------------------------------------------------
  Procedure:  preprocessor-name  
  Purpose:    Get the value of the preprocessor variable for
                 &FRAME-NAME, &BROWSE-NAME, and &QUERY-NAME
              These are the first ones in the procedure alphabetically
              (although FRAME-NAME can be set explicitly).
  Parameters: 
    INPUT  pi_name - (CHAR) the name of the preprocessor name
    OUTPUT po_info - (CHAR) the information 
 ---------------------------------------------------------------------- */
  DEFINE INPUT  PARAMETER pi_name AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER po_info AS CHAR NO-UNDO.
     
  DEFINE VAR c_type AS CHAR NO-UNDO.
  DEFINE BUFFER ip_U FOR _U.
  
   IF pi_name eq "&FRAME-NAME":U THEN DO:
    /* Is there an explicit "FRAME-NAME", or is it the first alphabetically.
       (Don't forget to include the Dialog-boxes in the search.) */
    IF _P._frame-name-recid ne ?
    THEN FIND ip_U WHERE RECID(ip_U) eq _P._frame-name-recid NO-ERROR.
    ELSE FIND FIRST ip_U WHERE ip_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE 
                         AND CAN-DO("DIALOG-BOX,FRAME":U, ip_U._TYPE)
                         AND ip_U._STATUS eq "NORMAL":U
                       USE-INDEX _NAME
                       NO-ERROR. 
  END.                                           
  ELSE DO:
    /* BROWSE or QUERY... */
    /* Get the widget type associated with the proprocessor name. */
    c_type = IF pi_name eq "&BROWSE-NAME":U THEN "BROWSE" ELSE "QUERY":U.
    FIND FIRST ip_U WHERE ip_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE 
                      AND ip_U._TYPE eq c_type
                      AND ip_U._STATUS eq "NORMAL":U
                    USE-INDEX _NAME NO-ERROR.
  END.
  
  /* Did we find anything? */  
  IF NOT AVAILABLE ip_U THEN po_info = ?.
  ELSE po_info = (IF l_returnName THEN ip_U._NAME ELSE STRING(RECID(ip_U))).
END PROCEDURE. /* preprocessor-name */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-request Procedure 
PROCEDURE process-request :
/*------------------------------------------------------------------------------
  Purpose:     Take the request given to this program and create the information
               desired.
  Parameters:  <none>
  Notes:       This creates the "p_info" string for most requests.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c AS INTEGER NO-UNDO.
  DEFINE VARIABLE i AS INTEGER NO-UNDO.
  DEFINE VARIABLE include-name  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lisICFRunning AS LOGICAL    NO-UNDO.

  /* Check the special PROCEDURE requests */
  IF l_proc-info AND 
      CAN-DO ("NAME,TYPE,DATAOBJECT,DATAOBJECT-INCLUDE", token[1]) THEN DO:
    CASE token[1]:
      WHEN "NAME":U     THEN p_info = _P._SAVE-AS-FILE.
      WHEN "TYPE":U     THEN p_info = _P._TYPE.
      WHEN "DATAOBJECT" THEN p_info = _P._data-object.
      WHEN "DATAOBJECT-INCLUDE" THEN
      DO:
        ASSIGN i            = R-INDEX(_P._data-object,".")
               include-name = IF i > 0 THEN SUBSTRING(_P._data-object,1,i) + "i"
                                       ELSE _P._data-object + ".i"
               include-name = REPLACE(include-name, "~\", "~/")
               p_info       = include-name.
        IF SEARCH(p_info) = ? THEN DO: 
          /* Check whether specified proc-filename is a repository object if Dynamics is running*/
         ASSIGN lisICFRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
            IF lisICFRunning AND VALID-HANDLE(gshRepositoryManager) THEN 
              p_info = DYNAMIC-FUNCTION("getSDOincludeFile" IN gshRepositoryManager, include-name).
        END.  /* If unable to locate include-file and ICF is running */
      END.
    END CASE.
    RETURN.
  END.
  
  /* Get the procedure...If it is not specified. */
  IF NOT AVAILABLE (_P) THEN FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.
  
  /* If it is the Procedure, get the associated window. */
  IF l_proc-info THEN FIND _U WHERE _U._HANDLE = _P._WINDOW-HANDLE.
  
  /* Return the rest of the types */
  CASE token[1]:
  
    /* Cases that request PROCEDURE information */
    WHEN "COMPILE-INTO-DIR" THEN p_info = _P._compile-into.
    WHEN "DATA-LOGIC-PROCEDURE" THEN 
    DO:
       IF AVAILABLE _U THEN 
       DO:
          FIND x_C WHERE RECID(x_C) = _U._x-recid.
          ASSIGN p_info = x_C._DATA-LOGIC-PROC.
       END.
    END.
    WHEN "ACTION":U         THEN p_info = _P.design_action.
    WHEN "EXTERNAL-TABLES"  THEN p_info = _P._xTblList.
    WHEN "FILE-NAME"        THEN p_info = _P._SAVE-AS-FILE.
    WHEN "PROCEDURE"        THEN p_info = STRING(RECID(_P)).
    WHEN "TEMPLATE"         THEN p_info = STRING(_P._template). 
    WHEN "WBX-FILE-NAME"    THEN p_info = _P._vbx-file.
    WHEN "HTML-FILE-NAME"   THEN p_info = _P._html-file.
    /* Find the variable associatied with &FRAME-NAME, &QUERY-NAME, etc. */  
    WHEN "&QUERY-NAME" OR WHEN "&BROWSE-NAME" OR WHEN "&FRAME-NAME" THEN DO:
      l_returnName = (token[2] eq "RETURN":U AND token[3] eq "NAME":U).
      RUN preprocessor-name (token[1], OUTPUT p_info).
    END.
    
    /* NAME and TYPE are handled about, it the user wanted Procedure information */
    WHEN "NAME"      THEN
      IF _U._TABLE  <> ? THEN p_info = _U._DBNAME + "." + _U._TABLE + "." + _U._NAME.
      ELSE p_info = _U._NAME.
    WHEN "TYPE"      THEN p_info = _U._TYPE.
    WHEN "HANDLE"    THEN p_info = STRING(_U._HANDLE).
    WHEN "PROCEDURE-HANDLE"  THEN DO:
      IF _U._TYPE ne "SmartObject":U THEN p_info = ?.
      ELSE DO:
        FIND _S WHERE RECID(_S) eq _U._x-recid.
        p_info = STRING(_S._HANDLE).
      END.
    END.
    WHEN "CONTEXT"   THEN p_info = STRING(RECID(_U)). 
    WHEN "CONTAINS"  THEN RUN contains-info. /* Modifies p_info directly */    
    WHEN "SECTIONS"  THEN RUN section-info. /* Modifies p_info directly */    
    WHEN "FIELDS"    THEN RUN fields-info (OUTPUT p_info).
  
    WHEN "TABLES" THEN DO:
      FIND x_C WHERE RECID(x_C) = _U._x-recid.
      FIND x_Q WHERE RECID(x_Q) = x_C._q-recid.
      /* All or part of the _TblList may be a "table2 OF table1", if so, the table2 chosen */
      DO c = 1 TO NUM-ENTRIES(x_Q._TblList):
        IF NUM-ENTRIES(ENTRY(c,x_Q._TblList), " ") = 1 THEN
          ch = (IF ch = "" THEN ENTRY(c,x_Q._TblList) ELSE ch + "," + ENTRY(c,x_Q._TblList)).
        ELSE /* table2 OF table1 */
          ch = (IF ch = "" THEN ENTRY(1,ENTRY(c,x_Q._TblList)," ") ELSE ch + "," + ENTRY(1,ENTRY(c,x_Q._TblList)," ")).
      END.
      ASSIGN p_info = ch.
    END.  
    
    WHEN "4GL-QUERY" THEN DO:
      FIND x_C WHERE RECID(x_C) = _U._x-recid.
      FIND x_Q WHERE RECID(x_Q) = x_C._q-recid.
      ASSIGN p_info = x_Q._4GLQury.
    END.
    
    WHEN "LINK" THEN RUN link-info.    /* Modifies p_info directly */
      
    OTHERWISE RUN error-msg ("Could not understand request: " + p_request).
  END CASE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-section-info) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE section-info Procedure 
PROCEDURE section-info :
/*  ----------------------------------------------------------------------
  Procedure: section-info:   
  
     Get the "SECTION" information. That is, the list of code sections in
     the procedure, that also meet the required type. The types can be
     PROCEDURE or FUNCTION (or both).

     This file finds all these sections and places them in the p_info list.
  
  Parameters: <none>
 ---------------------------------------------------------------------- */
  DEFINE BUFFER ipTRG FOR _TRG.

  DEFINE VARIABLE i AS INTEGER NO-UNDO.
  DEFINE VARIABLE section-name AS CHAR NO-UNDO.
  DEFINE VARIABLE section-list AS CHAR NO-UNDO.

  /* See if we should return the name or the section id. */
  l_returnName = (token[3] eq "RETURN":U and token[4] eq "NAME":U).

  /* For each item in the section list, find the relevant sections. */
  ASSIGN section-list = token[2].
  DO i = 1 TO NUM-ENTRIES(section-list):
    /* Map the section names in the input to the internal AppBuilder names. */
    CASE ENTRY(i,section-list):
      WHEN "FUNCTION" THEN section-name = "_FUNCTION".
      WHEN "PROCEDURE" THEN section-name = "_PROCEDURE".
      OTHERWISE section-name = ?.
    END CASE.
    /* Find all the sections of this type. */
    IF section-name ne ? THEN DO:
       FOR EACH ipTRG WHERE (ipTRG._pRECID eq RECID(_P))
                        AND (ipTRG._tSECTION eq section-name):
       
         /* Add a "," if necessary. */
         IF p_info ne "":U THEN p_info = p_info + ",":U.
         IF l_returnName
         THEN p_info = p_info + ipTRG._tEVENT.
         ELSE p_info = p_info + STRING(RECID(ipTRG)).
       END. /* FOR... */
    END. /* IF section-name... */
  END. /* DO i... */  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

