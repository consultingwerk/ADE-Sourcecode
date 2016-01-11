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
  File: _webfile.w

  Description: Remote file Open/Save As dialog.  Communicates with a WebSpeed
      agent via a Web server using Crescent CIHTTP and Microsoft ListView 
      ActiveX controls.

  Input Parameters:
    p_product : The ADE product code.  eg. "uib" for the UIB, or "Procedure"
                for the Procedure Window.
    p_mode    : A string indicating what the intent of this call is.
                eg.  "open", "save", "saveas", "exportas", "search"
    p_title   : The title to use for the system-dialog.
    p_filter  : Overide default filter if not "" or ? 
                COMMA separated list with filters in parenthesis. 
                Entries inside parenthesis must be separated by semicolon.    

Input-Output Parameters:
    p_fileName: The filename to use as the default, and to return.

Output Parameters:
    p_tempFile : The temporary filename containing the file to open, save, etc.
    p_ok       : TRUE if user successfully choose a file name
    
Author:  D.M.Adams
Created: November 1997
Changed: April 23 1998, HD  
                  Corrected error when two colons in host + path (NT)  
                  Added windows standard user dialog.  
                  - NO-FOCUS on image button.
                  - Buttons last in tab-order.  
                  - Keep data until returned data is checked for error.  
                  - Keep filename when saving also when directory is changed.
                  - RETURN anywhere in the dialog uses file-name as filter.
                    - Don't blank filter data in file-name field.
                    - If file-name is unique APPLY GO.  
                    - If path and filename is entered in filename. 
                      - If path is invalid give error.    
                      - If filename is unique APPLY GO.
Changed: July 20 1998, HD  
                  Added MORE windows standard user dialog.  
                  - Find and move to directory if typed in fill-in. 
                  - If typed directory AND fill-in and the fill-in was not found,
                    show data in listview from the typed directory  
                    using the current filter.
                  - Remove directory from fill-in if slashes was typed and
                    directory was found.                                           
                  - Remove filter from fill-in when one is selected in combo-box.                        
                  - OK button and RETURN have same functionality.
                  - Set combo screen-value like typed filter.
                  - Add first extention to filename on save-as if no extention 
                    in file-name.  

  Notes: NOT supported Windows functionality. 
         - The windows dialog moves to the last directory used if you 
           type a drive in the file-name.   
         
         Using WAIT-FOR U1 in this-procedure to be able to hide UI until
         files are loaded. VIEW FRAME is done in load_files !
         (Frame must be visible to WAIT-FOR go of frame and all of the 
         load happens while we are waiting)            
------------------------------------------------------------------------*/
/*       This .W file was created with the Progress AppBuilder.         */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{ adeuib/sharvars.i } 

&SCOPED-DEFINE debug FALSE

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER p_product  AS CHARACTER     NO-UNDO.
DEFINE INPUT        PARAMETER p_mode     AS CHARACTER     NO-UNDO.
DEFINE INPUT        PARAMETER p_title    AS CHARACTER     NO-UNDO.
DEFINE INPUT        PARAMETER p_filter   AS CHARACTER     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_fileName AS CHARACTER     NO-UNDO.
DEFINE       OUTPUT PARAMETER p_tempFile AS CHARACTER     NO-UNDO.
DEFINE       OUTPUT PARAMETER p_ok       AS LOGICAL       NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gcAction     AS CHARACTER NO-UNDO.
DEFINE VARIABLE gcSearchFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE gcDirFile    AS CHARACTER NO-UNDO. /* directory listing */
DEFINE VARIABLE gcErrorText  AS CHARACTER NO-UNDO.
DEFINE VARIABLE gcOSSlash    AS CHARACTER NO-UNDO.
DEFINE VARIABLE gcNOSSlash   AS CHARACTER NO-UNDO.
DEFINE VARIABLE glTopDir     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE glError      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE glScrap      AS LOGICAL   NO-UNDO.

DEFINE STREAM instream.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_CDUP dir-list file-name fileFilter ~
Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS cur-dir dir-list file-name fileFilter 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getComboFilter Dialog-Frame 
FUNCTION getComboFilter RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setComboFilter Dialog-Frame 
FUNCTION setComboFilter RETURNS LOGICAL
  (pFilter AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD UseWildCard Dialog-Frame 
FUNCTION UseWildCard RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.
DEFINE VARIABLE CtrlFrame-2 AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame-2 AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_CDUP 
     IMAGE-UP FILE "adeicon/cdup":U NO-FOCUS
     LABEL "CDUP" 
     SIZE 4 BY .95 TOOLTIP "Up one level".

DEFINE BUTTON Btn_OK 
     LABEL "Open" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE dir-list AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Directory" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE fileFilter AS CHARACTER FORMAT "X(256)":U 
     LABEL "Files of &type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "All Source(*.w;*.p;*.i;*.htm*)","Web Objects(*.w)","Procedures(*.p)","Includes(*.i)","HTML(*.html;*.htm)","All Files(*.*)" 
     SIZE 33 BY 1 NO-UNDO.

DEFINE VARIABLE cur-dir AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY 1 TOOLTIP "Current working directory" NO-UNDO.

DEFINE VARIABLE file-name AS CHARACTER FORMAT "X(256)":U 
     LABEL "File &name" 
     VIEW-AS FILL-IN 
     SIZE 33 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_CDUP AT ROW 2.67 COL 43
     cur-dir AT ROW 1.48 COL 2 NO-LABEL
     dir-list AT ROW 2.67 COL 10 COLON-ALIGNED
     file-name AT ROW 11 COL 13 COLON-ALIGNED
     fileFilter AT ROW 12.43 COL 13 COLON-ALIGNED
     Btn_OK AT ROW 11 COL 54
     Btn_Cancel AT ROW 12.43 COL 54
     SPACE(0.99) SKIP(0.11)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE ""
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


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
   NOT-VISIBLE Custom                                                   */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cur-dir IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

/* OCX BINARY:FILENAME is: adeweb\_webfile.wrx */

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME        = FRAME Dialog-Frame:HANDLE
       ROW          = 2.67
       COLUMN       = 62
       HEIGHT       = 1.43
       WIDTH        = 6.4
       HIDDEN       = yes
       SENSITIVE    = yes.

CREATE CONTROL-FRAME CtrlFrame-2 ASSIGN
       FRAME        = FRAME Dialog-Frame:HANDLE
       ROW          = 4.14
       COLUMN       = 2
       HEIGHT       = 6.67
       WIDTH        = 67
       HIDDEN       = no
       SENSITIVE    = yes.
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {DE90AEA3-1461-11CF-858F-0080C7973784} type: CIHTTP */
      CtrlFrame-2:NAME = "CtrlFrame-2":U .
/* CtrlFrame-2 OCXINFO:CREATE-CONTROL from: {58DA8D8A-9D6A-101B-AFC0-4210102A8DA7} type: ListView */
      CtrlFrame:MOVE-AFTER(dir-list:HANDLE IN FRAME Dialog-Frame).
      CtrlFrame-2:MOVE-AFTER(CtrlFrame).

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn_CDUP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_CDUP Dialog-Frame
ON CHOOSE OF Btn_CDUP IN FRAME Dialog-Frame /* CDUP */
DO:
  /* Move up to parent directory. */
  ASSIGN gcAction = "CDUP":U.
  RUN connect_server.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* Open */
DO:
  Run ApplyGo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame Dialog-Frame OCX.FileClosed
PROCEDURE CtrlFrame.CIHTTP.FileClosed .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/
  RUN load_files.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame Dialog-Frame OCX.HTTPServerConnection
PROCEDURE CtrlFrame.CIHTTP.HTTPServerConnection .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBase      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFilter    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPath      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDirectory AS CHARACTER NO-UNDO. /* current directory */
  DEFINE VARIABLE lTopDir    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iSlashPos  AS INTEGER   NO-UNDO.

  IF gcAction = "init":U AND p_mode BEGINS "save":U THEN DO:
    RUN adecomm/_osprefx.p (p_fileName, OUTPUT cPath, OUTPUT cBase).
      
    ASSIGN
      cDirectory                                    = cPath
      file-name:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cBase.
  END.
  ELSE DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      cDirectory = (IF cur-dir:SCREEN-VALUE = ".":U THEN cur-dir:SCREEN-VALUE  
                    ELSE REPLACE(SUBSTR(cur-dir:SCREEN-VALUE,
                                        INDEX(cur-dir:SCREEN-VALUE,":":U) + 1                   
                                 ),
                                 "~\":U,"/":U))
    
      /* If Change dir up remove a directory from list or use combo-box.  Note
         that directory may be set from fill-in further down if gcAction = go. */
      cDirectory  = (IF gcAction = "CDUP":U 
                     THEN SUBSTRING(cDirectory,1,R-INDEX(cDirectory,"/":U) - 1,
                                    "CHARACTER":U)
                     ELSE (IF cDirectory = ".":U THEN cDirectory 
                           ELSE RIGHT-TRIM(cDirectory,"/":U) + "/":U 
                           + 
                          (IF dir-list:SCREEN-VALUE = ? THEN ".":U 
                           ELSE dir-list:SCREEN-VALUE))) 
      
      /* Default filter is set from the combo-box, but may be replaced further 
         down. */                                
      cFilter      = getComboFilter().
      gcSearchFile = "":U.
     
    /* We are using the fill-in as filter or file or dir etc..  */  
    IF gcAction = "GO":U THEN DO:  
      /* If WildCard is used in the fill-in we use ONLY fill-in as filter, but
         if a directory and/or a filename is typed in the fill-in, we must fill
         the ListView with data according to what is in the combo-box, but we 
         must also see if the typed value is valid.  This is achieved by sending 
         both the typed value and the combo-box filter to _weblist.w. using ";" 
         as separator.
      */
      ASSIGN 
        glTopDir     = file-name:SCREEN-VALUE BEGINS "/":U OR
                       file-name:SCREEN-VALUE BEGINS "~\":U OR                       
                       INDEX(file-name:SCREEN-VALUE,":":U) <> 0

        cDirectory  = IF glTopDir    
                      THEN file-name:SCREEN-VALUE
                      ELSE cDirectory
                
        /* logg the filename part of the fill-in */                  
        gcSearchFile = REPLACE(file-name:SCREEN-VALUE,"~\":U,"/":U)
        gcSearchFile = IF R-INDEX(gcSearchFile,"/") > 0 
                       THEN SUBSTRING(gcSearchFile,R-INDEX(gcSearchFile,"/") + 1)
                       ELSE gcSearchFile
        
        /* Remove directory from filter if we are searching for a TOP directory
           or else _weblist.w will try to add it to the directory */
                           
        cFilter     =  IF glTopDir THEN gcSearchFile
                       ELSE file-name:SCREEN-VALUE
                       + IF UseWildCard() 
                         THEN "":U     
                         ELSE ";" + cFilter
                      . 
            
    END.  
        
    /* If directory ends with : add the slash, so _weblist 
       doesn't make it current */ 
    IF R-INDEX(cDirectory,":":U) = LENGTH(cDirectory,"CHARACTER":U) THEN 
      cDirectory = cDirectory + "/":U.
  END.
  
  ASSIGN
    chCtrlFrame:CIHTTP:URL = _BrokerURL 
      + "/webutil/_weblist.w?":U + "directory=":U + cDirectory
      + "&filter=":U + cFilter
    chCtrlFrame:CIHTTP:URL = REPLACE(chCtrlFrame:CIHTTP:URL," ":U,"%20":U).
  
  chCtrlFrame:CIHTTP:GET.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame Dialog-Frame OCX.WSAError
PROCEDURE CtrlFrame.CIHTTP.WSAError .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Required for OCX.
    error_number
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-error_number AS INTEGER NO-UNDO.

  ASSIGN 
    gcErrorText = DYNAMIC-FUNCTION("WSAError":U in _h_func_lib, p-error_number).
  
  chCtrlFrame:CIHTTP:CleanupConnection.

  glError = TRUE.
  APPLY "U1":U TO THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame-2 Dialog-Frame
ON GO OF CtrlFrame-2 /* ListView */
DO:
  RUN ApplyGo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame-2 Dialog-Frame OCX.DblClick
PROCEDURE CtrlFrame-2.ListView.DblClick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/
  APPLY "U1" TO THIS-PROCEDURE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame-2 Dialog-Frame OCX.ItemClick
PROCEDURE CtrlFrame-2.ListView.ItemClick .
/*------------------------------------------------------------------------------
  Purpose:     Populate file-name screen-value with file user has clicked on.
  Parameters:  Required for OCX.
    Item
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-Item AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE itemNum       AS INTEGER    NO-UNDO.
  
  ASSIGN
    itemNum    = p-Item:Index /* Index in ListView list */
    file-name:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
      chCtrlFrame-2:ListView:ListItems(ItemNum):Text /* name */
    . 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame-2 Dialog-Frame OCX.KeyDown
PROCEDURE CtrlFrame-2.ListView.KeyDown .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Required for OCX.
    KeyCode
    Shift
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER p-KeyCode AS INTEGER NO-UNDO.
DEFINE INPUT        PARAMETER p-Shift   AS INTEGER NO-UNDO.

IF KEYFUNCTION(p-keyCode) = "RETURN":U THEN 
  RUN ApplyGo.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dir-list
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dir-list Dialog-Frame
ON VALUE-CHANGED OF dir-list IN FRAME Dialog-Frame /* Directory */
DO:
  RUN connect_server. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fileFilter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fileFilter Dialog-Frame
ON VALUE-CHANGED OF fileFilter IN FRAME Dialog-Frame /* Files of type */
DO:
  /* Remove filter from fill-in */
  IF UseWildCard() THEN 
    ASSIGN file-name:SCREEN-VALUE = "":U.
  RUN connect_server.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

PAUSE 0 BEFORE-HIDE.
 
IF _brokerURL = "":U THEN DO:
  RUN adecomm/_s-alert.p (INPUT-OUTPUT glScrap, "error":U, "ok":U,
    "Cannot open a remote file when the WebSpeed Broker URL is blank.  Make sure it is set in Preferences.").
  RETURN ERROR.
END.
 
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ? THEN
  FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "END-ERROR":U TO SELF.
  RETURN NO-APPLY.
END.

/* We're waiting for this */ 
ON U1 OF THIS-PROCEDURE 
DO: 
  RUN ProcessFile.
END.

/* Emulate behavior of Windows file dialog */    
ON RETURN OF FRAME {&FRAME-NAME} ANYWHERE 
  RUN ApplyGo. 

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  dir-list:ADD-LAST(".":U).
   
  ASSIGN
    /* Disallow LabelEdit */
    chCtrlFrame-2:ListView:LabelEdit = 1  
    gcAction                         = "init":U
    FRAME {&FRAME-NAME}:TITLE        = p_title
    cur-dir:SCREEN-VALUE             = ".":U
    dir-list:SCREEN-VALUE            = dir-list:ENTRY(1)
    fileFilter:LIST-ITEMS            = IF p_filter <> ? AND p_filter <> "":U 
                                       THEN p_filter
                                       ELSE fileFilter:LIST-ITEMS  
    filefilter:INNER-LINES           = fileFilter:NUM-ITEMS + 1
    fileFilter:SCREEN-VALUE          = fileFilter:ENTRY(1).
        
  CASE p_mode:
    WHEN "open":U OR WHEN "search":U THEN 
        Btn_OK:LABEL = "Open".
    
    WHEN "save":U OR WHEN "saveas":U THEN 
      ASSIGN
        FileFilter:LABEL = "Save as &type"
        Btn_OK:LABEL     = "Save".
        
    WHEN "exportas":U                THEN 
       Btn_OK:LABEL = "Export".
    
    OTHERWISE
       Btn_OK:LABEL = "OK".
  END.
  
  RUN connect_server.
  
  DO ON ERROR   UNDO, LEAVE 
     ON END-KEY UNDO, LEAVE:
    /** 
    Cannot wait-for go of frame, because we don't want to hide the UI 
    until load_files is finished. 
    Load_files has the VIEW FRAME ....
    **/         
    IF NOT glError THEN 
      WAIT-FOR U1 OF THIS-PROCEDURE.
  END.
END.

RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ApplyGo Dialog-Frame 
PROCEDURE ApplyGo :
/*------------------------------------------------------------------------------
  Purpose: GO action. 
           Exit with selected file or use fill-in as directory or filter 
  Parameters:  
  Notes:   Called from 
           on return of frame anywhere  
           on ocx.keypress if keyfunc(ascii) = return.
           on choose of ok    
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:    
   ASSIGN gcAction = "GO":U.
      
   IF file-name:SCREEN-VALUE = "":U THEN RETURN. 
    
   /* Leave the wait-for if the file-name is in the list ? */   
   IF chCtrlFrame-2:ListView:FindItem(file-name:SCREEN-VALUE) <> 0 THEN
     APPLY "U1":U TO THIS-PROCEDURE.      
   ELSE RUN connect_server.   
 END.
 
 RETURN NO-APPLY.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connect_server Dialog-Frame 
PROCEDURE connect_server :
/*------------------------------------------------------------------------------
  Purpose:     Connect to HTTP Server
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iResult   AS INTEGER   NO-UNDO.
  
  RUN adecomm/_setcurs.p ("WAIT":U).
  RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT gcDirFile).

  /* Connect to Web server and pass URL. */
  ASSIGN
    chCtrlFrame:CIHTTP:LocalFileName = gcDirFile
    chCtrlFrame:CIHTTP:ParseURL      = TRUE
    chCtrlFrame:CIHTTP:URL           = _BrokerURL 
    iResult                          = chCtrlFrame:CIHTTP:ConnectToHTTPServer
    .
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load Dialog-Frame _CONTROL-LOAD
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

OCXFile = SEARCH( "adeweb\_webfile.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
    chCtrlFrame-2 = CtrlFrame-2:COM-HANDLE
    UIB_S = chCtrlFrame-2:LoadControls( OCXFile, "CtrlFrame-2":U)
  .
  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.
END.
ELSE MESSAGE "adeweb\_webfile.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame _DEFAULT-ENABLE
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
  DISPLAY cur-dir dir-list file-name fileFilter 
      WITH FRAME Dialog-Frame.
  ENABLE Btn_CDUP dir-list file-name fileFilter Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE load_files Dialog-Frame 
PROCEDURE load_files :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dirIcon   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fileCnt   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE fileName  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fileIcon  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fileType  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE OldDir    AS CHAR      NO-UNDO.
  
  DEFINE VARIABLE isDir     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE DirTyped  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE ix        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE nextFile  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lGo       AS LOG       NO-UNDO.
  DEFINE VARIABLE lDirError AS LOG       NO-UNDO.
  
  DEFINE VARIABLE ListItems AS CHAR      NO-UNDO.
          
  /* Clear directory and file lists. */
  ASSIGN
    glError             = False  
    FILE-INFO:FILE-NAME = "adeicon/file-w.bmp":U
    fileIcon            = FILE-INFO:FULL-PATHNAME
    FILE-INFO:FILE-NAME = "adeicon/folder.bmp":U
    dirIcon             = FILE-INFO:FULL-PATHNAME
    .
  
  INPUT STREAM instream FROM VALUE(gcDirFile) NO-ECHO.
  inp_block:
  REPEAT WITH FRAME {&FRAME-NAME}:
    
    ASSIGN
      fileName = "":U
      fileType = "":U.
    
    IMPORT STREAM instream fileName fileType.
    ASSIGN fileCnt = fileCnt + 1.
    CASE fileCnt:
      /* Check for line that does NOT begin with "<!--" indicating an error 
         reported by the web server. View the error in a web browser. */
      WHEN 1 THEN DO:
        IF NOT fileName BEGINS "<!--":U THEN DO:
          INPUT STREAM instream CLOSE.
          RUN adecomm/_s-alert.p (INPUT-OUTPUT glScrap, "error":U, "ok":U,
            "An error occurred while reading the WebSpeed directory and will be displayed in your Web browser.").
          RUN adeweb/_runbrws.p (_WebBrowser, chCtrlFrame:CIHTTP:URL, _open_new_browse).
          ASSIGN glError = TRUE.
          OS-DELETE VALUE(gcDirFile).
          
          APPLY "U1":U TO THIS-PROCEDURE.
          RETURN.
        END.
        ELSE NEXT.
      END.
      
      WHEN 2 THEN NEXT inp_block.
      
      /* Check for non-blank line indicating an error. */
      WHEN 3 THEN DO:
        IF fileName <> "" THEN DO:
          MESSAGE "An error occurred while reading the WebSpeed directory."
            VIEW-AS ALERT-BOX ERROR.
          glError = TRUE.
        END.
        NEXT inp_block.
      END.
  
      /* Get current directory full path from 4th data line. */
      WHEN 4 THEN DO:
        /* Unknown value indicates that the path is wrong */   
        IF fileName = ? THEN DO:
          MESSAGE 
            (IF NOT glTopDir THEN           
             cur-dir:SCREEN-VALUE + gcOSslash 
             ELSE "":U)
            + file-name:SCREEN-VALUE SKIP
            "This path does not exist." SKIP
            "Make sure that the correct path is given."             
           VIEW-AS 
             ALERT-BOX 
             WARNING 
             TITLE FRAME {&FRAME-NAME}:TITLE.
             
          /* Make sure the screen-value stays as is */   
          ASSIGN 
            gcSearchfile = "":U
            lDirError    = TRUE. 
          LEAVE inp_block.          
        END.
       
        /* Display the current directory on top of the screen. */
        
        ASSIGN 
          OldDir               = cur-dir:SCREEN-VALUE
          cur-dir:SCREEN-VALUE = chCtrlFrame:CIHTTP:HostName + ":":U + fileName
          
          /* See if correct slash can be read from it */
          gcOSslash  = IF INDEX(fileName,"~\":U) > 0 
                       THEN "~\":U ELSE "/":U                             
          gcNOSslash = IF INDEX(fileName,"~\":U) > 0 
                       THEN "/":U ELSE "~\":U                             
          
          /* 
          If current dir = olddir + screen-value we have typed 
          and found a directory or current-dir = fill-in, set this flag to avoid error message */
                                      
          DirTyped  = gcAction EQ "GO":U
                      AND 
                     (REPLACE(cur-dir:SCREEN-VALUE,"~\":U,"/":U) EQ
                      REPLACE(olddir + gcOsslash + file-name:screen-value,"~\","/")
                      OR     
                      RIGHT-TRIM(REPLACE(cur-dir:SCREEN-VALUE,"~\":U,"/":U),"/":U) EQ
                      RIGHT-TRIM(REPLACE(chCtrlFrame:CIHTTP:HostName + ":" + file-name:screen-value,"~\":U,"/":U),"/":U)                      
                     ).
        NEXT inp_block.
      END.
      WHEN 5 THEN DO:        
        IF p_mode BEGINS "SAVE":U 
        AND gcAction = "GO":U
        AND NOT UseWildCard() 
        AND NOT DirTyped THEN 
        DO:
          /* gSearchfile does not contain slashes */      
          IF gcSearchFile <> "" THEN 
            ASSIGN file-name:SCREEN-VALUE = gcSearchFile.
         
          APPLY "U1":U TO THIS-PROCEDURE.
          ASSIGN lGo = TRUE.
          LEAVE inp_block.               
        END.
        /* Keep data in case of error 
           Don't blank current data until we are certain that the 
           first 4 lines are ok  */
        
        IF NOT glError THEN
          dir-list:LIST-ITEMS IN FRAME {&FRAME-NAME} = ".".
      END.         
    END CASE.
    
    IF fileName = "":U THEN NEXT inp_block.
      
    IF NOT glError THEN DO:
      ASSIGN
        nextFile = fileName 
        isDir    = fileType eq "D":U 
      .
      
      
      IF isDir THEN DO:
        IF dir-list:LOOKUP(nextFile) IN FRAME {&FRAME-NAME} EQ 0 THEN
          dir-list:ADD-LAST(nextFile) IN FRAME {&FRAME-NAME}.
      END.
      ELSE
      DO:
        /* We found the file that was typed in */         
        IF gcSearchFile <> "":U 
        AND gcSearchFile = nextFile THEN
        DO:        
          ASSIGN
            file-name:SCREEN-VALUE IN FRAME {&FRAME-NAME} = nextFile
            lGo                                           = TRUE.
          APPLY "U1":U TO THIS-PROCEDURE.
        END. 
        ELSE                 
          Listitems = ListItems 
                      + (If listitems = "":U THEN "":U ELSe ",":U) 
                      + nextFile. 
      END.
    END.
  END. /* repeat */ 
  
  IF glError THEN 
    APPLY "U1":U TO THIS-PROCEDURE.
  
  INPUT STREAM instream CLOSE.
  
  OS-DELETE VALUE(gcDirFile).
 
  IF  NOT glError
  AND NOT lGo THEN 
  DO:    
    IF NOT lDirError THEN
    DO:       
      IF UseWildCard() THEN 
         setComboFilter(gcSearchFile).      
     
      chCtrlFrame-2:ListView:ListItems:Clear().          
      DO ix = 1 to NUM-ENTRIES(ListItems): 
        /* index, key, text, icon, smallicon) */
        chCtrlFrame-2:ListView:ListItems:Add(,,Entry(ix,ListItems)).                 
      END.  
    
      dir-list:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
        dir-list:ENTRY(1) IN FRAME {&FRAME-NAME}.
  
       VIEW FRAME {&FRAME-NAME}.
          
      IF NOT (p_mode BEGINS "save":U) THEN
      DO:
      
        /* gSearchfile does not contain slashes, so show that */      
        IF gcSearchFile <> "" THEN 
          ASSIGN file-name:SCREEN-VALUE = gcSearchFile.
       
        /* It is not an error if Directory was typed or wildcard was used */ 
        IF  NOT DirTyped   
        AND NOT UseWildCard()
        AND gcSearchFile <> "":U THEN
          MESSAGE               
          gcSearchFile SKIP
          "This file was not found." SKIP
          "Make sure that the correct path and filename is given."             
          VIEW-AS ALERT-BOX WARNING TITLE Frame {&FRAME-NAME}:TITLE.   
   
      END. /* if not save */ 
    END. /* if not ldirerror */ 
    IF NOT (p_mode begins "save":U) 
    OR gcAction = "init":U THEN
      APPLY "ENTRY":U TO file-name IN FRAME {&FRAME-NAME}.
    
  END. /* IF NOT glerror ANd NOT lGo AND NOT lDirError */ 
  
  /* Reset action */
  ASSIGN 
   gcAction = "":U
   glTopDir = FALSE.
  
  RUN adecomm/_setcurs.p ("").
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProcessFile Dialog-Frame 
PROCEDURE ProcessFile :
/*------------------------------------------------------------------------------
  Purpose: Return the selected file      
  Parameters:  <none>
  Notes:   Called when program leaves wait-for. (on u1 of this-procedure)      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTmpMode   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRelName   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFileFound AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAddExt    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cReturn    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cObjType   AS CHARACTER NO-UNDO.   
  DEFINE VARIABLE iStack     AS INTEGER   NO-UNDO.   
  
  IF glError THEN DO:
    IF gcErrorText <> "":U THEN
      MESSAGE gcErrorText
        VIEW-AS ALERT-BOX ERROR. 
    RETURN.
  END.
    
  DO WITH FRAME {&FRAME-NAME}: 
    /* Hide the frame as early as possible */
    HIDE FRAME {&FRAME-NAME}.
    RUN adecomm/_setcurs.p ("WAIT":U).
   
    ASSIGN    
      p_Filename = SUBSTR(cur-dir:SCREEN-VALUE,INDEX(cur-dir:SCREEN-VALUE,":":U) + 1)
                 + "/":U + file-name:SCREEN-VALUE
      p_tempFile = "":U
      p_ok       = TRUE
      cTmpMode   = p_mode + (IF p_mode eq "saveAs":U THEN ":okToSave":U ELSE "").
  END.

  /* SaveAs is included here to check if the file exists or is writeable. */
  IF CAN-DO("open,saveAs,search":U,p_mode) THEN DO:
    /* Add default extention if no extention */
    IF p_mode eq "saveAs":U AND INDEX(p_filename,".":U) = 0 THEN DO:
      ASSIGN         /* remove first wildcard*/ 
        cAddext    = LEFT-TRIM(ENTRY(1,getComboFilter(),";":U),"*":U) 
                     /* Use the extention if it begins with a period 
                        and there are no * or ~ behind the period */                        
        p_filename = IF  cAddExt BEGINS ".":U 
                     AND INDEX(cAddExt,"*":U)  = 0   
                     AND INDEX(cAddExt,"~~":U) = 0 
                     THEN p_filename + cAddExt
                     ELSE p_filename.   
    END. /* if saveas and no extention */
   
  /* Check objecttype if saveAs and we are called from a function in 
     appbuilder (This is done to check be able ot warn about an exisitng .i) */
    cObjType = "":U.         
    IF cTmpmode EQ "saveAs:oktosave":U THEN 
    DO WHILE TRUE:
      iStack = iStack + 1.
      
      IF NUM-ENTRIES(program-name(iStack)," ":U) > 1 
      AND ENTRY(2,program-name(iStack)," ":U) BEGINS "adeuib/_uibmain":U THEN 
      DO:  
        RUN adeuib/_uibinfo.p(?, "PROCEDURE ?":U,"TYPE":U, OUTPUT cObjType).  
        LEAVE.
      END.       
      ELSE IF program-name(iStack) BEGINS "_pwsave":U THEN LEAVE.      
      IF program-name(iStack) = ? THEN LEAVE.
    END.
    
    IF cObjType <> ? THEN cTmpMode = cTmpMode + cObjType.      
    
    RUN adeweb/_webcom.w (?, _BrokerURL, p_fileName, cTmpMode, 
                          OUTPUT cRelName, INPUT-OUTPUT p_tempFile).
    IF RETURN-VALUE BEGINS "ERROR":U THEN 
    DO:
      ASSIGN 
        p_ok       = FALSE  
        p_filename = REPLACE(p_filename, gcNOSSlash, gcOSSlash)        
        SUBSTRING(p_mode,1,1,"CHARACTER":U) = 
          CAPS(SUBSTRING(p_mode,1,1,"CHARACTER":U)).

      IF INDEX(RETURN-VALUE,"Filename spaces":U) ne 0 THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT glScrap, "information":U, "ok":U,
          SUBSTITUTE("WebSpeed does not support spaces in filenames on UNIX.  &1",
          (IF p_mode BEGINS "save" THEN p_mode + " was aborted" ELSE ""))).
        OS-DELETE VALUE(p_tempFile).   
        RETURN ERROR.
      END.

      IF INDEX(RETURN-VALUE,"Not readable":U) ne 0 THEN
        RUN adecomm/_s-alert.p (INPUT-OUTPUT glScrap, "error":U, "ok":U,
          SUBSTITUTE("Cannot open &1.  WebSpeed agent does not have read permission.", 
          p_filename)).
          
      IF INDEX(RETURN-VALUE,"Not writeable":U) ne 0 THEN
        RUN adecomm/_s-alert.p (INPUT-OUTPUT glScrap, "warning":U, "ok":U,
          SUBSTITUTE("&1^Cannot save to this file.^^File is read-only or the path specified is invalid.  Use a different filename.",
          p_filename)).
      ELSE
      IF INDEX(RETURN-VALUE,"File exists":U) ne 0 THEN
      DO:    
        /* We use the entry(2,return-value) as filename in error message 
           because it may have a  .i when saving a sdo.w  */ 
        ASSIGN 
          cFileFound = p_filename 
          ENTRY(NUM-ENTRIES(cFileFound,gcOsSlash),cFileFound,gcOsSLash) = 
                                            ENTRY(2,RETURN-VALUE,CHR(10)).
        
        MESSAGE cRelName /* cFileFound (19990317-029) */
          "already exists." SKIP
          "Do you want to replace it?"
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE p_ok.
      END. 
      
      IF INDEX(RETURN-VALUE,"File not found":U) ne 0 THEN
        MESSAGE p_filename "not found in WebSpeed agent PROPATH."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END. /* if return-value begins 'error' */
    
    &if {&debug} &then
      message 
        "[_webfile.w] ON GO OF FRAME" skip
        "p_filename:  " p_filename skip
        "crelname:    " crelname skip
        "p_tempfile:  " p_tempfile skip
      view-as alert-box.
    &endif
  
    IF cRelName ne "" AND cRelName ne ? THEN
      p_fileName = cRelName.
    
    IF p_mode = "search":U THEN 
      OS-DELETE VALUE(p_tempFile).   
  END.
  
  RUN adecomm/_setcurs.p ("":U).
 
  IF p_ok = FALSE THEN 
    RETURN ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getComboFilter Dialog-Frame 
FUNCTION getComboFilter RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Get the filter part of the filefilter combo box 
    Notes:  
------------------------------------------------------------------------------*/
  RETURN ENTRY(1,ENTRY(2,fileFilter:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                       "(":U),")":U).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setComboFilter Dialog-Frame 
FUNCTION setComboFilter RETURNS LOGICAL
  (pFilter AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR i AS INT NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
    DO i = 1 TO FileFilter:NUM-ITEMS:
      IF ENTRY(1,ENTRY(2,fileFilter:ENTRY(i),"(":U),")":U) = pFilter THEN 
      DO:
        ASSIGN FileFilter:SCREEN-VALUE = FileFilter:ENTRY(i).
        RETURN TRUE.
      END.  
    END.
  END.
  
  RETURN FALSE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION UseWildCard Dialog-Frame 
FUNCTION UseWildCard RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Check if the user entered a filter in the fill-in  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN INDEX(file-name:SCREEN-VALUE IN FRAME {&FRAME-NAME},"*":U) > 0.   
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




