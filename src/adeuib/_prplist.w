&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
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

  File: _prplist.w

  Description: Edit list-items or radio-sets for HTML objects. This is 
               called from the _proprty if _P._tv-proc is valid. 

  Input Parameters:
      p_Uhandle      -  _U._HANDLE

  Author:  Haavard Danielsen 
  Created: 09/04/98
  Updated: 08/20/99 adams    Added support for LIST-ITEM-PAIRS
           
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBulder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{adeuib/uniwidg.i}
{adeuib/uibhlp.i}               /* Help pre-processor directives        */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_Uhandle AS HANDLE NO-UNDO.

DEFINE SHARED VARIABLE _h_func_lib  AS HANDLE NO-UNDO.
DEFINE VARIABLE cHelpContext AS INTEGER  NO-UNDO.
DEFINE VARIABLE switchlist   AS LOGICAL  NO-UNDO.
DEFINE VARIABLE lListItems   AS LOGICAL  NO-UNDO.

/* Local Variable Definitions ---                                       */
&GLOBAL-DEFINE WIN95-BTN  TRUE
&SCOPED-DEFINE USE-3D     YES

FUNCTION validate-list-items RETURNS LOGICAL
  (INPUT p_Uhandle AS HANDLE) IN _h_func_lib.

FUNCTION validate-list-item-pairs RETURNS LOGICAL
  (INPUT p_Uhandle AS HANDLE) IN _h_func_lib.

FUNCTION validate-radio-buttons RETURNS LOGICAL
  (INPUT p_Uhandle AS HANDLE) IN _h_func_lib.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS h_listType fiListItems fiLabel 
&Scoped-Define DISPLAYED-OBJECTS fiObject h_listType fiListItems fiLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiListItems AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 59 BY 6.67 NO-UNDO.

DEFINE VARIABLE fiLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Label" 
      VIEW-AS TEXT 
     SIZE 10 BY .62 NO-UNDO.

DEFINE VARIABLE fiObject AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object" 
     VIEW-AS FILL-IN 
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE h_listType AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "List-Items", "I",
"List-Item-Pairs", "P"
     SIZE 33 BY .95 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     fiObject AT ROW 1.24 COL 12 COLON-ALIGNED
     h_listType AT ROW 2.19 COL 14 NO-LABEL
     fiListItems AT ROW 3.14 COL 14 NO-LABEL
     fiLabel AT ROW 2.29 COL 1 COLON-ALIGNED NO-LABEL
     SPACE(61.39) SKIP(6.90)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "<insert dialog title>".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

ASSIGN 
       fiListItems:RETURN-INSERTED IN FRAME Dialog-Frame  = TRUE.

/* SETTINGS FOR FILL-IN fiObject IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* <insert dialog title> */
DO:
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cItemPairs AS CHARACTER NO-UNDO.
    
  ASSIGN 
    cListItems = _F._LIST-ITEMS 
    cItemPairs = _F._LIST-ITEM-PAIRS.
    
  IF h_listType:SCREEN-VALUE = "I":U THEN 
    ASSIGN
      _F._LIST-ITEMS      = fiListItems:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      _F._LIST-ITEM-PAIRS = "".
  ELSE IF h_listType:SCREEN-VALUE = "P":U THEN 
    ASSIGN 
      _F._LIST-ITEMS      = ""
      _F._LIST-ITEM-PAIRS = fiListItems:SCREEN-VALUE IN FRAME {&FRAME-NAME}. 
  
  IF _U._TYPE = "radio-set":U THEN 
  DO WITH FRAME {&FRAME-NAME}: 
    IF NOT validate-radio-buttons(_U._HANDLE) THEN DO:
      ASSIGN 
        _F._LIST-ITEMS = cListItems.
      RETURN NO-APPLY.
    END.
  END.  
  ELSE IF _U._TYPE = "combo-box":U OR 
          _U._TYPE = "selection-list":U THEN 
  DO WITH FRAME {&FRAME-NAME}: 
    IF h_listType:SCREEN-VALUE = "I":U THEN DO:
      IF NOT validate-list-items(_U._HANDLE) THEN DO:
        ASSIGN 
          _F._LIST-ITEMS      = cListItems
          _F._LIST-ITEM-PAIRS = cItemPairs.
        RETURN NO-APPLY.
      END.
    END.
    ELSE IF h_listType:SCREEN-VALUE = "P":U THEN DO:
      IF NOT validate-list-item-pairs(_U._HANDLE) THEN DO:
        ASSIGN 
          _F._LIST-ITEMS      = cListItems
          _F._LIST-ITEM-PAIRS = cItemPairs.
        RETURN NO-APPLY.
      END.
    END.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* <insert dialog title> */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME h_listType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL h_listType Dialog-Frame
ON VALUE-CHANGED OF h_listType IN FRAME Dialog-Frame
DO:
  RUN switchList.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

&SCOPED-DEFINE TOOL AB
&SCOPED-DEFINE CONTEXT cHelpContext
{ adecomm/okbar.i }

FIND _U WHERE _U._HANDLE = p_Uhandle.
FIND _F WHERE RECID(_F)  = _U._x-recid NO-ERROR.
IF NOT AVAILABLE _F THEN RETURN.

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Set help context */
CASE _U._TYPE:
  WHEN "COMBO-BOX"      THEN cHelpContext = {&COMBO_BOX_Attrs}.
  WHEN "RADIO-SET"      THEN cHelpContext = {&RADIO_SET_Attrs}.
  WHEN "SELECTION-LIST" THEN cHelpContext = {&SELECTION_LIST_Attrs}.
END.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  ASSIGN 
    fiObject    = _U._NAME
    lListItems  = (_F._LIST-ITEMS NE ? AND _F._LIST-ITEMS NE "") OR
                  (_F._LIST-ITEM-PAIRS EQ ? OR _F._LIST-ITEM-PAIRS EQ "")
    fiListItems = (IF lListItems THEN _F._LIST-ITEMS ELSE _F._LIST-ITEM-PAIRS)
    fiLabel     = (IF _U._TYPE = "RADIO-SET":U THEN "Buttons:":U ELSE " ":U)
    fiLabel:WIDTH IN FRAME {&FRAME-NAME} = 
           FONT-TABLE:GET-TEXT-WIDTH-CHARS(fiLabel,FRAME {&FRAME-NAME}:FONT)
    fiLabel:COL = fiListItems:COL - (fiLabel:WIDTH + 0.6).
  RUN setTitle.
  RUN enable_UI.

  /* Which list type do we have to display? (dma) */
  ASSIGN 
    h_listType:SCREEN-VALUE = (IF lListItems THEN "I":U ELSE "P":U)
    fiLabel:VISIBLE         = _U._TYPE = "RADIO-SET":U
    fiListItems:ROW         = (IF _U._TYPE = "RADIO-SET":U THEN
                               h_listType:ROW ELSE fiListItems:ROW).

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY fiObject h_listType fiListItems fiLabel 
      WITH FRAME Dialog-Frame.
  ENABLE h_listType fiListItems fiLabel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTitle Dialog-Frame 
PROCEDURE setTitle :
/*------------------------------------------------------------------------------
  Purpose:     Update the dialog title.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FRAME {&FRAME-NAME}:TITLE = "Edit " +  
    (IF _U._TYPE = "RADIO-SET" THEN "Radio Buttons "
     ELSE IF lListItems        THEN "List Items "
     ELSE                           "List Item Pairs ")
     + "- ":U + _U._NAME .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE switchList Dialog-Frame 
PROCEDURE switchList :
/*------------------------------------------------------------------------------
  Purpose:     Switch between LIST-ITEMS and LIST-ITEM-PAIRS formats.
  Parameters:  <none>
  Notes:       [Code borrowed from adeuib/_prpobj.p]
               Called from the SELECTION-LIST, RADIO-SET for List-Items/
               List-Item-Pairs attribute when its value has changed. If we 
               have changed from Pairs to Items, we retain only the left-hand 
               values. If we changed from Items to Pairs, we replicate the
               list-item in the case of the character variable (SELECTION-LIST 
               or char RADIO-SET) to create the pair, otherwise we substitute 
               a value for that datatype for the second value.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ix        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE tmpString AS CHARACTER NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      switchlist               = TRUE
      fiListItems:SCREEN-VALUE = RIGHT-TRIM(fiListItems:SCREEN-VALUE).
    IF fiListItems:SCREEN-VALUE NE "" THEN DO:
      /* Try to convert current contents */
      IF SELF:SCREEN-VALUE = "I":U THEN DO: /* LIST-ITEMS */ 
        DO ix = 1 TO NUM-ENTRIES(fiListItems:SCREEN-VALUE,CHR(10)):
          tmpString = (IF tmpString NE "" THEN tmpString + CHR(10) ELSE tmpString) + 
                       ENTRY(1,ENTRY(ix,fiListItems:SCREEN-VALUE,CHR(10)),",":U).
        END.
        ASSIGN 
          fiListItems:SCREEN-VALUE = RIGHT-TRIM(tmpString)
          _F._LIST-ITEMS           = fiListItems:SCREEN-VALUE
          _F._LIST-ITEM-PAIRS      = ?
          lListItems               = TRUE.
      END.
      ELSE DO: /* LIST-ITEM-PAIRS */
        DO ix = 1 TO NUM-ENTRIES(fiListItems:SCREEN-VALUE,CHR(10)):
          ASSIGN tmpString = (IF tmpString NE "" THEN tmpString + CHR(10) ELSE tmpString) + 
                             ENTRY(ix,fiListItems:SCREEN-VALUE,CHR(10)) + ",":U.
          CASE _F._DATA-TYPE: /* Figure out which value to display based on data type */
            WHEN "CHARACTER":U THEN tmpString = tmpString + ENTRY(ix,fiListItems:SCREEN-VALUE,CHR(10)).
            WHEN "DATE":U      THEN tmpString = tmpString + STRING(TODAY,_F._FORMAT).
            WHEN "DECIMAL":U   THEN tmpString = tmpString + STRING(ix,_F._FORMAT).
            WHEN "INTEGER":U   THEN tmpString = tmpString + STRING(ix,_F._FORMAT).
            WHEN "LOGICAL":U   THEN tmpString = tmpString + STRING(no,_F._FORMAT).
          END.
          ASSIGN tmpString = tmpString + (IF ix <> NUM-ENTRIES(fiListItems:SCREEN-VALUE,CHR(10)) THEN ",":U ELSE "").
        END.
        ASSIGN 
          fiListItems:SCREEN-VALUE = RIGHT-TRIM(tmpString)
          _F._LIST-ITEMS           = ?
          _F._LIST-ITEM-PAIRS      = fiListItems:SCREEN-VALUE
          lListItems               = FALSE.
      END.
    END.
  END.
  RUN setTitle.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

