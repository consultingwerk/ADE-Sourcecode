&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
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

  File: _seldir.w

  Description: 

  Input Parameters:
      INPUT-OUTPUT pcCur-Dir AS CHARACTER directory to look for

  Output Parameters:
      <none>

  Author: 

  Modified: 05/20/1999
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) EQ 0 &THEN
DEFINE INPUT-OUTPUT PARAMETER pcCur-dir  AS CHARACTER           NO-UNDO.
&ELSE
DEFINE VARIABLE pcCur-dir  AS CHARACTER                         NO-UNDO.
&ENDIF

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cur-dir   AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE cur-drive AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE i         AS INTEGER                              NO-UNDO.
DEFINE VARIABLE tmp-value AS CHARACTER                            NO-UNDO.


{adeuib/uibhlp.i}          /* Help File Preprocessor Directives         */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel Btn_Help Drive-cb 
&Scoped-Define DISPLAYED-OBJECTS directory Drive-cb 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE Drive-cb AS CHARACTER FORMAT "X(2)":U 
     LABEL "Drive" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "C:" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 TOOLTIP "Select a different drive" NO-UNDO.

DEFINE VARIABLE directory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Dir" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     directory AT ROW 1.48 COL 5 COLON-ALIGNED
     Btn_OK AT ROW 1.52 COL 49
     Btn_Cancel AT ROW 2.76 COL 49
     Btn_Help AT ROW 4.76 COL 49
     Drive-cb AT ROW 12.43 COL 51 COLON-ALIGNED
     SPACE(1.13) SKIP(0.83)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Select a Directory"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.

DEFINE FRAME FRAME-A
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.67
         SIZE 39 BY 11.19.


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
/* REPARENT FRAME */
ASSIGN FRAME FRAME-A:FRAME = FRAME Dialog-Frame:HANDLE.

/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME FRAME-A:MOVE-AFTER-TAB-ITEM (Btn_OK:HANDLE IN FRAME Dialog-Frame)
       XXTABVALXX = FRAME FRAME-A:MOVE-BEFORE-TAB-ITEM (Btn_Cancel:HANDLE IN FRAME Dialog-Frame)
/* END-ASSIGN-TABS */.

ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN directory IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
ASSIGN 
       directory:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* SETTINGS FOR FRAME FRAME-A
                                                                        */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME FRAME-A:HANDLE
       ROW             = 1
       COLUMN          = 1
       HEIGHT          = 11.19
       WIDTH           = 39
       HIDDEN          = no
       SENSITIVE       = yes.
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {02ADEC20-91D2-101B-874B-0020AF109266} type: CSList */

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Select a Directory */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: 
  /* Help for this Frame */
  RUN adecomm/_adehelp.p
                ("ICAB", "CONTEXT", {&Select_a_Directory_Dialog_Box}  , "").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-A
&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame Dialog-Frame OCX.Click
PROCEDURE CtrlFrame.CSList.Click .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/
  IF chCtrlFrame:CSList:ListIndex < 0 THEN 
    MESSAGE 'You must click on a valid directory or "[..]".'
      VIEW-AS ALERT-BOX.
  ELSE DO:
    directory = chCtrlFrame:CSList:List(chCtrlFrame:CSList:ListIndex).
    PROCESS EVENTS.
    RUN refresh-list.
    PROCESS EVENTS.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define SELF-NAME Drive-cb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Drive-cb Dialog-Frame
ON VALUE-CHANGED OF Drive-cb IN FRAME Dialog-Frame /* Drive */
DO:
  cur-drive = SELF:SCREEN-VALUE.
  RUN refresh-list.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    
  IF pcCur-dir = "":U OR pcCur-dir = ? OR pcCur-dir = "?" THEN
    ASSIGN FILE-INFO:FILE-NAME = ".":U.
  ELSE  
    ASSIGN FILE-INFO:FILE-NAME = pcCur-dir.
  ASSIGN cur-dir = FILE-INFO:FULL-PATHNAME.
  
  /* Can't find directory, then starts with current directory */
  IF cur-dir = ? THEN
    ASSIGN 
      FILE-INFO:FILE-NAME = ".":U
      cur-dir = FILE-INFO:FULL-PATHNAME
      .

  /* if directory passed is a full path without a drive letter
     file-info:full-pathname doesn't give back the drive letter
     By default, in this case the drive will be the same as the current dir */
  IF INDEX(cur-dir, ":":U) NE 2 THEN
    ASSIGN
        FILE-INFO:FILE-NAME = ".":U
        cur-drive = SUBSTRING(FILE-INFO:FULL-PATHNAME,1,2)
        directory = cur-drive + cur-dir.
  ELSE
  ASSIGN cur-drive = SUBSTRING(cur-dir,1,2)
         directory = cur-dir.

  IF Drive-cb:LOOKUP(cur-drive) = 0 THEN
    Drive-cb:ADD-LAST(cur-drive).
  ASSIGN Drive-cb:SCREEN-VALUE = cur-drive.


  RUN enable_UI.

  /* Initialize list with directory passed */
  chCtrlFrame:CSList:Path = directory.
  PROCESS EVENTS.
  chCtrlFrame:CSList:Refresh().
  PROCESS EVENTS.

  
  DO i = 0 TO chCtrlFrame:CSList:ListCount - 1:
    tmp-value = chCtrlFrame:CSList:List(i).
    PROCESS EVENTS.
    IF tmp-value BEGINS "[-" AND LENGTH(tmp-value) = 5 THEN DO:
      tmp-value = UPPER(SUBSTRING(tmp-value,3,1) + ":").
      IF Drive-cb:LOOKUP(tmp-value) = 0 THEN
         Drive-cb:ADD-LAST(tmp-value).
    END.
  END.
  
  chCtrlFrame:CSList:Drive   = FALSE.
  PROCESS EVENTS.
  chCtrlFrame:CSList:Pattern = "".
  PROCESS EVENTS.
  chCtrlFrame:CSList:Refresh.
  PROCESS EVENTS.
  
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.

  pcCur-dir = directory.

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load Dialog-Frame  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "_seldir.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.
END.
ELSE MESSAGE "_seldir.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  HIDE FRAME FRAME-A.
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
  RUN control_load.
  DISPLAY directory Drive-cb 
      WITH FRAME Dialog-Frame.
  ENABLE Btn_OK Btn_Cancel Btn_Help Drive-cb 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
  VIEW FRAME FRAME-A.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-A}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh-list Dialog-Frame 
PROCEDURE refresh-list :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE tmp-dir AS CHARACTER                                 NO-UNDO.

  IF NOT cur-dir BEGINS cur-drive THEN /* the drive has changed */
    ASSIGN cur-dir   = cur-drive
           directory = cur-drive + "~\".
           
  ELSE DO: /* The directory has changed */
    IF directory = "[..]" THEN
        directory = SUBSTRING(cur-dir,1, R-INDEX(cur-dir,"~\") - 1).

    ELSE DO:
      ASSIGN directory          = TRIM(directory,"[,]")
             FILE-INFO:FILE-NAME = cur-dir + "~\" + directory
             directory           = FILE-INFO:FULL-PATHNAME.
    END.
    cur-dir = directory.
    IF LENGTH(directory) = 2 THEN directory = directory + "~\".
  END.

  chCtrlFrame:CSList:Clear().
  PROCESS EVENTS.
  chCtrlFrame:CSList:Refresh().
  PROCESS EVENTS.
  chCtrlFrame:CSList:Path = directory.
  PROCESS EVENTS.
  chCtrlFrame:CSList:Refresh().
  PROCESS EVENTS.

  IF FONT-TABLE:GET-TEXT-WIDTH-CHARS(directory) GE 41 THEN DO:
    tmp-dir = cur-drive + "~\" + ENTRY(2,directory,"~\") + "~\...~\" +
                          ENTRY(NUM-ENTRIES(directory,"~\"),directory, "~\").
    DISPLAY tmp-dir @ directory WITH FRAME {&FRAME-NAME}.
  END.
  ELSE DISPLAY directory WITH FRAME {&FRAME-NAME}.

  directory:TOOLTIP = DIRECTORY:SCREEN-VALUE .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

