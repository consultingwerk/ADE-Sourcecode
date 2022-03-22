&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*-------------------------------------------------------------------------
    File        : treeview.i
    Purpose     : Basic Method Library for the ADMClass treeview.
  
    Syntax      : {src/adm2/treeview.i}

    Description :
  
    Modified    : 04/05/2001
-------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass treeview
&ENDIF

&IF "{&ADMClass}":U = "treeview":U &THEN
  {src/adm2/treeprop.i}
&ENDIF


/* Each node in the TreeView must have a unique key. giSequence is
 * used by getNextNodeKey() to generate this. */
 
DEFINE VARIABLE giSequence AS INT NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getCtrlFrameHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCtrlFrameHandle Method-Library 
FUNCTION getCtrlFrameHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getILComHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getILComHandle Method-Library 
FUNCTION getILComHandle RETURNS COM-HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getILCtrlFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getILCtrlFrame Method-Library 
FUNCTION getILCtrlFrame RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNextNodeKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNextNodeKey Method-Library 
FUNCTION getNextNodeKey RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSelectedNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSelectedNode Method-Library 
FUNCTION getSelectedNode RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTVComHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTVComHandle Method-Library 
FUNCTION getTVComHandle RETURNS COM-HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTVCtrlFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTVCtrlFrame Method-Library 
FUNCTION getTVCtrlFrame RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 17.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
/* Starts super procedure */
IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
  RUN start-super-proc("adm2/treeview.p":u).
  
/* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */

{src/adm2/custom/treeviewcustom.i}

/* _ADM-CODE-BLOCK-END */

&ENDIF

            /* WIN32 API functions for Pixels-to-TWIPS conversion */
&Scoped-Define HORIZONTAL 0
&Scoped-Define VERTICAL 1

&Scoped-Define LOGPIXELSX 88    /* API CONSTANTS */
&Scoped-Define LOGPIXELSY 90

procedure GetDC EXTERNAL "user32":U  :
  define input  parameter hwnd as long.
  define return parameter hDeviceContext as long.
end procedure.

procedure GetDeviceCaps external "gdi32":U :
  define input parameter hdc as long.
  define input parameter nIndex as long.
  define return parameter hDeviceContext as long.
end procedure.

procedure GetClientRect external "user32":U :
  def input  parameter hwnd as long.
  def output parameter hPointer as memptr.
  def return parameter bLog as short.
end procedure.

procedure GetParent external "user32":U :
  def input parameter hwnd as long.
  def return parameter hParent as long.
end procedure.


PROCEDURE GetUserNameA EXTERNAL  "advapi32":U :
    DEFINE INPUT-OUTPUT PARAMETER lpBuffer    AS CHAR.
    DEFINE INPUT-OUTPUT PARAMETER nSize       AS LONG.
    DEFINE RETURN       PARAMETER ReturnValue AS LONG.
  END PROCEDURE.

procedure ReleaseDC external "user32":U :
  define input parameter hwnd as long.
  define input parameter hdc as long.
  define return parameter hDeviceContext as long.
end procedure.

PROCEDURE SendMessageA EXTERNAL "user32":U :
    DEFINE INPUT PARAMETER hwnd   AS LONG.
    DEFINE INPUT PARAMETER umsg   AS LONG.
    DEFINE INPUT PARAMETER wparam AS LONG.
    DEFINE INPUT PARAMETER lparam AS LONG.
    DEFINE RETURN PARAMETER ReturnValue AS LONG.
END PROCEDURE.

PROCEDURE ShellExecuteA EXTERNAL "shell32":U :
  define input parameter hwnd as long.
  define input parameter lpOperation as char.
  define input parameter lpFile as char.
  define input parameter lpParameters as char.
  define input parameter lpDirectory as char.
  define input parameter nShowCmd as long.
  define return parameter hInstance as long.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getCtrlFrameHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCtrlFrameHandle Method-Library 
FUNCTION getCtrlFrameHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
 Returns the handle of the ControlFrame of the TreeView.
------------------------------------------------------------------------------*/

  RETURN hTreeView:HANDLE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getILComHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getILComHandle Method-Library 
FUNCTION getILComHandle RETURNS COM-HANDLE
  (  ) :
/*------------------------------------------------------------------------------
 Returns the com-handle of the ImageList OCX.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hIL AS COM-HANDLE NO-UNDO.

  IF VALID-HANDLE(hImageList) THEN
    ASSIGN hIL = hImageList:COM-HANDLE
           hIL = hIL:ImageList.
  ELSE
    hIL = ?.
     
  RETURN hIL.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getILCtrlFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getILCtrlFrame Method-Library 
FUNCTION getILCtrlFrame RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
IF VALID-HANDLE(hImageList) THEN
    RETURN hImageList.   /* Function return value. */
  ELSE
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNextNodeKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNextNodeKey Method-Library 
FUNCTION getNextNodeKey RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
 Each node in the tree must have a unique key assigned. This function returns a
 unique code to be used for the Key attribute of the treeview.
   
 Note: The Microsoft TreeView does not allow a node's key to begin with a number,
       therefore the prefix xcNodePrefix is used. 
       The key is used as the sort field when adding nodes. Therefore, the string 
       "999999999999" is used to guarantee a valid sort order.
------------------------------------------------------------------------------*/

  giSequence = giSequence + 1.

  RETURN {&xcNodePrefix} + STRING(giSequence,"999999999999":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSelectedNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSelectedNode Method-Library 
FUNCTION getSelectedNode RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the key of the selected node.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chTreeView AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE hTreeview  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE chNode     AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE cNodeKey   AS CHARACTER  NO-UNDO.

  {get TVCtrlFrame hTreeview }.
  ASSIGN chTreeview   = hTreeview:COM-HANDLE
         chTreeview   = chTreeview:CONTROLS:ITEM(1)  
         NO-ERROR. 

  IF VALID-HANDLE(chTreeView) THEN 
  DO:
    cNodeKey = ?.
    chNode = chTreeView:selectedItem.
    IF VALID-HANDLE(chNode) THEN DO:
      cNodeKey = chNode:KEY.
      RELEASE OBJECT chNode.
    END.
    RELEASE OBJECT chTreeview.
    RETURN cNodeKey.
  END.

  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTVComHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTVComHandle Method-Library 
FUNCTION getTVComHandle RETURNS COM-HANDLE
  (  ) :
/*------------------------------------------------------------------------------
 Returns the com-handle of the TreeView OCX.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTV AS COM-HANDLE NO-UNDO.
  
  IF VALID-HANDLE(hTreeView) THEN
    ASSIGN hTV = hTreeView:COM-HANDLE
           hTV = hTV:TreeView.
  ELSE
    hTV = ?.
  
  RETURN hTV.
 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTVCtrlFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTVCtrlFrame Method-Library 
FUNCTION getTVCtrlFrame RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Treeview Control frame
    Notes:  
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(hTreeview) THEN
    RETURN hTreeview.   /* Function return value. */
  ELSE
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

