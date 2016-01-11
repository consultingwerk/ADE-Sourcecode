/*************************************************************/
/* Copyright (c) 1984-2012 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/  
/*------------------------------------------------------------------------
    File        : oeideservice.p
    Purpose     : Methods to interact with the OpenEdge IDE

    Syntax      : 

    Description :

    Author(s)   : egarcia
    Created     :
    Notes       : Some ide information is stored in ide context in the session.
                  Publishes oeide_context from main block to retrieve the 
                  runtime/_oeidecontext.p procedure handle started by 
                  runtime/_server.p. 
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/
using Progress.Lang.*.

/* ***************************  Definitions  ************************** */
{adecomm/_adetool.i} /* ADEpersistent  */
/* Shared variables to store Preferences for session */
 
&SCOPED-DEFINE BUFFER_SIZE         1024
&SCOPED-DEFINE NO_EMBEDDED_WINDOWS NO

&SCOPED-DEFINE VIEW_ACTIVATE 1
&SCOPED-DEFINE VIEW_VISIBLE  2
&SCOPED-DEFINE VIEW_CREATE   3

/** must match definitions in com.openedge.pdt.oestudio.input.ICommandHandlerConstants 
    and have a corresponding input handler   */
define variable  GET_IDE_PREFERENCES        as integer init 1 no-undo.  
define variable  GOTO_PAGE                  as integer init 2 no-undo.
define variable  GET_PROJECT_PROPERTIES     as integer init 3 no-undo.
define variable  GET_ACTIVE_PROJECT_OF_FILE as integer init 4 no-undo.
define variable  GET_PROJECT_OF_FILE        as integer init 5 no-undo.
define variable  OPEN_TEXT_EDITOR           as integer init 6 no-undo.
define variable  SAVE_EDITOR                as integer init 7 no-undo.
define variable  CLOSE_EDITOR               as integer init 8 no-undo.
define variable  ACTIVATE_EDITOR            as integer init 9 no-undo.
define variable  ADD_WINDOW                 as integer init 10 no-undo.
define variable  FIND_AND_SELECT            as integer init 11 no-undo.
define variable  SET_EDITOR_MODIFIED        as integer init 12 no-undo.
define variable  SHOW_VIEW                  as integer init 13 no-undo.
define variable  HIDE_VIEW                  as integer init 14 no-undo.
define variable  DELETE_VIEW                as integer init 15 no-undo.
define variable  GET_VIEW_HWND              as integer init 16 no-undo.
define variable  RUN_UIB_COMMAND            as integer init 17 no-undo.
define variable  SET_VIEW_TITLE             as integer init 18 no-undo.
define variable  SET_EMBEDDED_WINDOW        as integer init 19 no-undo.
define variable  SET_TTY_TERMINAL_COLOR     as integer init 20 no-undo.
define variable  VIEW_SOURCE                as integer init 21 no-undo.
define variable  SHOW_HELP                  as integer init 22 no-undo.
define variable  RUN_CHILD_DIALOG           as integer init 23 no-undo.
define variable  CHECK_HELP                 as integer init 24 no-undo.
define variable  OPEN_DYNAMICS_EDITOR       as integer init 25 no-undo.
define variable  SHOW_MESSAGE_IN_IDE        as integer init 26 no-undo.
define variable  APPBUILDER_CONNECTION      as integer init 27 no-undo.
define variable  OPEN_DESIGN_EDITOR         as integer init 28 no-undo.
define variable  OPEN_PROPERTY_SHEET        as integer init 29 no-undo.
define variable  SET_WINDOW_SIZE            as integer init 30 no-undo. 
define variable  WIDGET_EVENT               as integer init 31 no-undo.
define variable  ADD_CODE_SECTION           as integer init 32 no-undo.
define variable  ADD_TRIGGER                as integer init 33 no-undo.
define variable  RUN_DESIGN                 as integer init 34 no-undo.
define variable  COMPILE_DESIGN             as integer init 35 no-undo.
define variable  RENAME_WIDGET_NAME         as integer init 36 no-undo.
define variable  SHOW_CUE_CARD              as integer init 37 no-undo.
define variable  OPEN_DB_CONNECTION         as integer init 38 no-undo.
define variable  KEY_PRESSED                as integer init 39 no-undo.
define variable  CHECK_SYNTAX               as integer init 40 no-undo.

/* see publish in main block */ 
define variable fContextHandle as handle no-undo.
define variable PARAMETER_DELIMITER as char no-undo init "|".

function getAppbuilderMode returns character       () in fContextHandle.
function getDesignFileName returns character       (piHwnd as int64) in fContextHandle.
function getDesignHwnd returns int64             (pcFile as char) in fContextHandle.  
function getLinkFileFileName returns char          (pcLinkFile as char) in fContextHandle.   
function getLinkFileName returns char              (piHwnd as int64) in fContextHandle.
function getLinkFileTimeStamp returns datetime     (pcLinkFile as char) in fContextHandle. 
function getLinkFileWindow returns handle          (pcLinkFile as char) in fContextHandle .
function getOpenDialogHwnd returns int64         () in fContextHandle.
function getProjectName returns character          () in fContextHandle.
function getProjectWorkDirectory returns character () in fContextHandle.    
function getSocketClient returns handle            () in fContextHandle.
function getWorkDirectory returns character        () in fContextHandle.
/* not implemented - exposes context to abl 
   must be specifically declared - not defined in oeideservice.i */
function getRequestContext returns character        () in fContextHandle.
function registerObject returns logical            (piHwnd as int64,pObject as Object) in fContextHandle.
function removeHwnd returns logical                (piHwnd as int64) in fContextHandle.
function setCurrentEventObject returns logical     (pobj as Object) in fContextHandle.              
function setLinkFileTimeStamp returns logical      (pcLinkFile as char,dt as datetime) in fContextHandle. 
function setNextEventObject returns logical        (pobj as Object) in fContextHandle.              
/** not yet
/* not implemented - exposes context to abl 
   must be specifically declared - not defined in oeideservice.i */
function setRequestContext returns logical        (pccontext as char) in fContextHandle.
**/

function setWindowHandle returns logical (piHwnd as int64,phhandle as handle) in fContextHandle.               
define variable CurrentDesignEditor as int64 no-undo.
/*
define temp-table ttLinkedFile no-undo
    field windowHandle         as handle
    field projectName          as character
    field fileName             as character
    field linkedFile           as character
    field syncTimeStamp        as datetime
    index linkedFile   is primary unique linkedFile
    index windowHandle is unique windowHandle
    index fileName     is unique fileName   
    .
  */      



/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-activateWindow) = 0 &THEN

function activateWindow returns logical 
    ( phWindow as handle) forward.


&ENDIF

&IF DEFINED(EXCLUDE-checkSyntaxInIde) = 0 &THEN

function checkSyntaxInIde returns logical 
    ( phWindow as handle) forward.


&ENDIF

&IF DEFINED(EXCLUDE-displayEmbeddedWindow) = 0 &THEN

function displayEmbeddedWindow returns logical
         (viewId      as character,
          secondaryId as character,
          hWindow     as handle)  forward.


&ENDIF

&IF DEFINED(EXCLUDE-getDesignFileNameParent) = 0 &THEN

function getDesignFileNameParent returns character
         (piHwnd as handle)  forward.


&ENDIF

&IF DEFINED(EXCLUDE-getDesignId) = 0 &THEN
        
 /** we currently use the handle as the id -  */      
function getDesignId returns int64 
       (phWidget as handle) forward.

&ENDIF

&IF DEFINED(EXCLUDE-getProjectDisplayName) = 0 &THEN
        
 /** we currently use the handle as the id -  */      
function getProjectDisplayName returns character 
       () forward.

&ENDIF

&IF DEFINED(EXCLUDE-hideView) = 0 &THEN

function hideView returns logical
         (viewId      as character,
          secondaryId as character)  forward.


&ENDIF



&IF DEFINED(EXCLUDE-runDialog) = 0 &THEN

function runDialog returns logical 
    (phWindow as handle,
     pcDialogCommand as char) forward.


&ENDIF

&IF DEFINED(EXCLUDE-runUIBCommand) = 0 &THEN

function runUIBCommand returns logical 
    ( phWindow as handle, 
     pcCommand as char) forward.


&ENDIF

&IF DEFINED(EXCLUDE-setEmbeddedWindow) = 0 &THEN

function setEmbeddedWindow returns logical
         (viewId      as character,
          secondaryId as character,
          hWindow     as handle)  forward.


&ENDIF

&IF DEFINED(EXCLUDE-setTTYTerminalColor) = 0 &THEN

function setTTYTerminalColor returns logical
         (pBG as int,
          pFG as int)  forward.


&ENDIF


&IF DEFINED(EXCLUDE-setViewTitle) = 0 &THEN

function setViewTitle returns logical
         (viewId      as character,
          secondaryId as character,
          viewTitle   as character)  forward.


&ENDIF

&IF DEFINED(EXCLUDE-checHelp) = 0 &THEN

function checkHelp returns logical
         (pcContextId as character )  forward.


&ENDIF


&IF DEFINED(EXCLUDE-showHelp) = 0 &THEN

function showHelp returns logical
         (pcContextId as character )  forward.


&ENDIF

&IF DEFINED(EXCLUDE-showView) = 0 &THEN

function showView returns logical
         (viewId      as character,
          secondaryId as character,
          mode        as integer)  forward.


&ENDIF

&IF DEFINED(EXCLUDE-openEditor) = 0 &THEN
function openEditor returns logical
         (cProjectName  as character,
          cFileName     as character,
          cLinkedFile   as character,
          hWindowHandle as handle) forward.

&ENDIF

&IF DEFINED(EXCLUDE-openDesignEditor) = 0 &THEN

function openDesignEditor returns logical 
         (cProjectName  as character,
          cFileName      as character)  forward.

&ENDIF

&IF DEFINED(EXCLUDE-openTextEditor) = 0 &THEN

function openTextEditor returns logical 
         (cProjectName  as character,
          cFileName      as character)  forward.

&ENDIF

&IF DEFINED(EXCLUDE-openDynamicsEditor) = 0 &THEN

function openDynamicsEditor returns logical 
         (cProjectName  as character,
          cFileName      as character)  forward.

&ENDIF

&IF DEFINED(EXCLUDE-openPropertySheet) = 0 &THEN
function openPropertySheet returns logical 
          (windowHandle  as handle) forward.  

&ENDIF

&IF DEFINED(EXCLUDE-saveEditor) = 0 &THEN

function saveEditor returns logical
         (cProjectName  as character,
          cFileName     as character,
          ask_file_name as logical)  forward.


&ENDIF

&IF DEFINED(EXCLUDE-closeEditor) = 0 &THEN

function closeEditor returns logical
         (cProjectName  as character,
          cFileName     as character,
          lSaveChanges  as logical)  forward.


&ENDIF

&IF DEFINED(EXCLUDE-findAndSelect) = 0 &THEN

function findAndSelect returns logical
         (projectName  as character,
          fileName     as character,
          cText        as character,
          activateEditor as logical)  forward.


&ENDIF

&IF DEFINED(EXCLUDE-createLinkedFile) = 0 &THEN

function createLinkedFile returns character
         (user_chars   as character,
          extension    as character)  forward.


&ENDIF


&IF DEFINED(EXCLUDE-gotoPage) = 0 &THEN

function gotoPage returns logical 
    ( phWindow as handle, 
      piPage as int) forward.


&ENDIF

&IF DEFINED(EXCLUDE-viewSource) = 0 &THEN

function keyPressed returns logical 
    ( phWindow as handle,
      pcKey    as character) forward.

&ENDIF

&IF DEFINED(EXCLUDE-viewSource) = 0 &THEN

function viewSource returns logical 
    ( phWindow as handle,
      wName AS CHARACTER,
      wType AS CHARACTER,
      wSection AS CHARACTER,
      wTrigger AS CHARACTER) forward.


&ENDIF

&IF DEFINED(EXCLUDE-hasDdialog) = 0 &THEN
 function HasDialog returns logical
         (phParent as handle) forward.
&ENDIF

&IF DEFINED(EXCLUDE-SetWindowSize) = 0 &THEN
function  SetWindowSize return logical
         (phwin as handle ) forward.          
&ENDIF

&IF DEFINED(EXCLUDE-ShowOkMessageInIDE) = 0 &THEN
function ShowOkMessageInIDE returns logical
         (msgText      as character,
          MsgType      as character,
          MsgTitle     as character) forward.   
&ENDIF

&IF DEFINED(EXCLUDE-ShowMessageInIDE) = 0 &THEN
function ShowMessageInIDE returns logical
          (msgText      as character,
          MsgType      as character,
          MsgTitle     as character, 
          MsgButtons   as character,
          ButtonValue  as logical) forward.
&ENDIF
          
&IF DEFINED(EXCLUDE-WidgetEvent) = 0 &THEN
function WidgetEvent returns logical
         (phwindow   as handle,
          WidgetName as character,
          WidgetText as character,
          WidgetType as character,
          WidgetParent as character,
          WidgetAction as character ) forward.
&ENDIF
&IF DEFINED(EXCLUDE-RenameWidget) = 0 &THEN
function RenameWidget return logical
         (phwindow   as handle,
          WidgetOldName as character,
          WidgetNewName as character,
          WidgetText as character,
          WidgetType as character,
          WidgetParent as character,
          WidgetAction as character ) forward.
 &ENDIF         
&IF DEFINED(EXCLUDE-AddCodeSection) = 0 &THEN
function AddCodeSection return logical
         (phwindow   as handle,
          AddSection as character)forward.          
&ENDIF     
     
&IF DEFINED(EXCLUDE-AddTrigger) = 0 &THEN
function AddTrigger return logical
         (phwindow   as handle,
          WidgetName as character,
          WidgetType as character) forward.
&endif      

&IF DEFINED(EXCLUDE-RunDesign) = 0 &THEN
function RunDesign return logical
         (phwindow   as handle) forward.
&endif             
&IF DEFINED(EXCLUDE-CompileDesign) = 0 &THEN         
function CompileDesign return logical
         (phwindow   as handle) forward.    
&endif   
&IF DEFINED(EXCLUDE-ShowCueCard) = 0 &THEN
function ShowCueCard return logical
         (CueCardTitle as character,
          CueCardMessage as character) forward.  
&endif   

&IF DEFINED(EXCLUDE-OpenDBConnectionDialog) = 0 &THEN
function OpenDBConnectionDialog return logical
         (pmessage as character)   forward.
&endif                      
/* *********************** Procedure Settings ************************ */



/* *************************  Create Window  ************************** */

/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */

/* ************************* Included-Libraries *********************** */

 




/* ***************************  Main Block  *************************** */
publish "oeide_context" from this-procedure (output fContextHandle).
 
 



/* **********************  Internal Procedures  *********************** */
 
 
&IF DEFINED(EXCLUDE-getSendEditMaster) = 0 &THEN
        
procedure getIsIDEIntegrated:
    DEFINE OUTPUT PARAMETER plintegrated AS LOGICAL NO-UNDO. 
    /*------------------------------------------------------------------------------
          Purpose: Is ab integrated 
                   True is currently the only supported mode. 
                   We're keeping the ability to support multiple modes implemented
                   to support the old modes embedded and not embedded for defensive 
                   reasons. (note: implemention of the old modes or other modes in 
                   addition to the integrsted would require a lot of work)
                                                                                           
            Notes: TODO ABMode = integrated                                                                       
    ------------------------------------------------------------------------------*/
   plintegrated = true.


end procedure.
    

&ENDIF

 
&IF DEFINED(EXCLUDE-OnChoose) = 0 &THEN
        
procedure OnChoose:
    define input  parameter h as handle no-undo.
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
  /* message 
   h:name
   focus:name 
   
   view-as alert-box.
*/
end procedure.
    

&ENDIF

&IF DEFINED(EXCLUDE-positionDesignWindow) = 0 &THEN
        
procedure positionDesignWindow:
    define input parameter phWindow as handle no-undo.
    /*------------------------------------------------------------------------------
            Purpose: called from uibmain to position the design window ...                                                                        
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    /* the numbers are copied from uibmain hardcode  - there were no comments */
    
   /* left upper corner of design canvas */
    assign phWindow:x = 10  
           phWindow:y = 10 NO-ERROR.
             
    SetWindowSize(phWindow).
end procedure.
    

&ENDIF
 
 

&IF DEFINED(EXCLUDE-getLinkedFileName) = 0 &THEN

procedure getLinkedFileName :
/*------------------------------------------------------------------------------
  Purpose: Returns the file name of the linked file for a given window
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
define input parameter phWindow           as handle     no-undo.
define output parameter pcLinkedFile      as character  no-undo.
    
    define variable iId as int64 no-undo.
    iId = getDesignId(phWindow).
    pcLinkedFile = getLinkFileName(iId).
end procedure.


&ENDIF

&IF DEFINED(EXCLUDE-getSyncTimeStamp) = 0 &THEN

procedure getSyncTimeStamp :
/*------------------------------------------------------------------------------
  Purpose: Returns the timestamp of a linked file
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
define input parameter pcLinkedFile     as character  no-undo.
define output parameter timeStamp       as datetime   no-undo.
    timeStamp = getLinkFileTimeStamp(pcLinkedFile).
end procedure.


&ENDIF

&IF DEFINED(EXCLUDE-setSyncTimeStamp) = 0 &THEN

procedure setSyncTimeStamp :
/*------------------------------------------------------------------------------
  Purpose: Sets the timestamp of a linked file
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
define input parameter pcLinkedFile as character  no-undo.
define input parameter timeStamp    as datetime   no-undo.
    setLinkFileTimeStamp(pcLinkedFile,timeStamp).
end procedure.


&ENDIF

&IF DEFINED(EXCLUDE-addWindow) = 0 &THEN

procedure addWindow :
/*------------------------------------------------------------------------------
  Purpose: Adds a 4GL window to the specified view
  Parameters:
    Notes:  
------------------------------------------------------------------------------*/
define input parameter viewId      as character  no-undo.
define input parameter secondaryId as character  no-undo.
define input parameter hWindow     as handle     no-undo.

define variable wHwnd as int64       no-undo.
define variable lVisible as logical    no-undo.
define variable cResult as character   no-undo.

&IF "{&NO_EMBEDDED_WINDOWS}" EQ "YES" &THEN
    return.
&ENDIF
if (secondaryId begins "DesignView":U or secondaryId begins "PropertiesWindow":U) then 
    return.

if not valid-handle(hWindow) then return.

define variable iParentWindow as int64    no-undo.

run getViewHwnd (viewId, secondaryId, output iParentWindow).

if iParentWindow <> 0 then
    assign hWindow:IDE-WINDOW-TYPE = 1 /* virtual desktop */ 
           hWindow:IDE-PARENT-HWND = iParentWindow.
           

end procedure.


&ENDIF


&IF DEFINED(EXCLUDE-displayDesignWindow) = 0 &THEN

procedure displayDesignWindow :
    define input parameter pcFileName  as character  no-undo.
    define input parameter hWindow     as handle     no-undo.
    define variable iParentWindow as int64 no-undo.
    
    if pcFileName = ? then pcFileName = "NEW".
    
    iParentWindow = getDesignHwnd(pcFileName).
    if iParentWindow = ? then 
    do:
        /* check if linked file name was passed (synchfromid) */
        pcFileName = getLinkFileFileName(pcFileName).
        iParentWindow = getDesignHwnd(pcFileName).
    end.    
    if iParentWindow  <> ? and iParentWindow <> 0 then
    do:
         /* design canvas mode = not movable and only reizable right-bottom */ 
        assign hWindow:IDE-WINDOW-TYPE = 5  
               hWindow:IDE-PARENT-HWND = iParentWindow.
   
        setWindowHandle(iParentWindow,hwindow).
    end.
    return.
end procedure.

&ENDIF

&IF DEFINED(EXCLUDE-displayWindow) = 0 &THEN
 
procedure displayContainer :
/*------------------------------------------------------------------------------
  Purpose:  hook for adm2/containr.p 
  Parameters:
  Notes: Called from createObject before window is realized 
------------------------------------------------------------------------------*/
define input parameter prochandle     as handle  no-undo.
define input parameter objectname    as character  no-undo.
define input parameter hWindow        as handle     no-undo.

    define variable pdialog as adeuib.idialogservice  no-undo.
    define variable iHwnd as int64 no-undo.
    if not valid-handle(hWindow) then 
        return.
    case objectname:
        /* CustomLayout (_uibmain morph-layout  ) and CustomizationPriority 
           SmartWindows that emulates dialogs in standalone - uses Eclipse dialog */
        when "rycstlow" or when "rycusmodw" then
        do:
           ihwnd = getOpenDialogHwnd().
           pdialog = new adeuib._windowservice(hWindow,ihwnd,procHandle).
           registerObject(ihwnd,pdialog).
        end. 
    end.  
end procedure.

    
&ENDIF


&IF DEFINED(EXCLUDE-displayWindow) = 0 &THEN

procedure displayWindow :
/*------------------------------------------------------------------------------
  Purpose: Compound procedure to show and embed 
           the specified window into the view in virtual desktop mode 
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
define input parameter viewId      as character  no-undo.
define input parameter secondaryId as character  no-undo.
define input parameter hWindow     as handle     no-undo.

define variable xViewId as char init "com.openedge.pdt.oestudio.views.OEAppBuilderView".

define variable iParentWindow as int64    no-undo.

   if not valid-handle(hWindow) then return.
       
   if viewId = "appbuilderpalette" then
   do:
    /*    if CurrentDesignEditor > 0 then         */
    /*        iParentWindow = CurrentDesignEditor.*/
    /*    else                                    */
        viewId = xViewId.
    end.

    if viewId = xViewId and secondaryId begins "designview" then
    do:
      
        define variable hwnd as int64 no-undo.
        /*define variable result as integer no-undo.*/
    
        /* This will prevent the window from becoming visible even if the window 
           is explicitly made visible by setting VISIBLE = YES, HIDDEN = FALSE, 
           or any other attribute setting or statement that makes a window visible. */
        hWindow:IDE-WINDOW-MODE = 1. 
        /*  realize window (see above) */
        hWindow:hidden = false. 
/*                                                       */
/*            run GetParent(hWindow:hwnd, output result).*/
/*                                                       */
/*            run ShowWindow(result, 0, output result).  */
        
        /* Set positions somewhat central as some dialogs seems to be 
           positioned relative to uib main see below
           -- not tested with ide-window-mode = 1  */  
        hWindow:col = session:width / 2. 
        hWindow:row = 10.
                 
        return.
         
    end.
    
end procedure.


&ENDIF

&IF DEFINED(EXCLUDE-setEditorModified) = 0 &THEN

procedure setEditorModified :
/*------------------------------------------------------------------------------
  Purpose: Set the editor to modified 
  Parameters:
  Notes: 
  - Tell the OpenEdge IDE Editor that the file has been modified so the Save 
    button in the IDE will be enabled, and a check for changes would be 
    performed before the editor is closed.
------------------------------------------------------------------------------*/
    define input parameter phWindow     as handle     no-undo.
  
    define variable iDesignId as int64 no-undo. 
    iDesignId = getDesignId(phWindow). 
    run sendRequest in getSocketClient()
                     (SET_EDITOR_MODIFIED,
                      "IDE setEditorModified ":U 
                      + QUOTER(getProjectName()) + PARAMETER_DELIMITER
                      + QUOTER(iDesignId)).
        
end procedure.


&ENDIF

&IF DEFINED(EXCLUDE-getWindowOfFile) = 0 &THEN

procedure getWindowOfFile :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle of the window associated with a linked file
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
define input parameter pcLinkedFile as character  no-undo.
define output parameter phWindow    as handle     no-undo.
    phWindow = getLinkFileWindow(pcLinkedFile).
end procedure.


&ENDIF
 
&IF DEFINED(EXCLUDE-getViewHwnd) = 0 &THEN

procedure getViewHwnd :
/*------------------------------------------------------------------------------
  Purpose: Returns the Windows hwnd value of the specified view
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
define input parameter viewId       as character  no-undo.
define input parameter secondaryId  as character  no-undo.
define output parameter iResult     as int64    no-undo.

define variable cResult as character  no-undo.
  
if  (viewId = "DIALOG") then
do:
   iResult = getDesignHwnd(secondaryId).
   
end.

else if (secondaryId = "NEWOBJECT" or secondaryId = "WIZARD") then
do:
    iResult = getDesignHwnd(secondaryId).
    
end.
else do:
    
   if (secondaryId begins "DesignView":U) then
       return.

   run sendWaitRequest in getSocketClient()(
                    GET_VIEW_HWND,
                    "IDE getViewHwnd ":U 
                    + viewId + PARAMETER_DELIMITER 
                    + QUOTER(secondaryId),
                    output cResult).
    iResult = int64(cResult) no-error.
    
end.

end procedure.


&ENDIF

&IF DEFINED(EXCLUDE-getActiveProjectOfFile) = 0 &THEN

procedure getActiveProjectOfFile :
/*------------------------------------------------------------------------------
  Purpose: Returns the project associated with a file for the AppBuilder session
  Parameters:
  Notes: Returns blank if the project cannot be used as a resource 
  in the current AppBuilder session.
------------------------------------------------------------------------------*/
define input parameter pcFullPathName as character  no-undo.
define output parameter pcProjectName as character  no-undo.
define variable phand as handle no-undo.
define variable cCurrentProjectName as character   no-undo.

    if pcFullPathName = "" or pcFullPathName = ? then
    do:
        pcProjectName = "".
        return.
    end.
        
    cCurrentProjectName = getProjectName().
    run sendWaitRequest in getSocketClient()(
            GET_ACTIVE_PROJECT_OF_FILE,
            "IDE getActiveProjectOfFile ":U
            + QUOTER(getProjectName()) + PARAMETER_DELIMITER    
            + QUOTER(pcFullPathName), 
            output pcProjectName).
/*                                                                              */
/*        run sendRequest("IDE getActiveProjectOfFile ":U                       */
/*                        + QUOTER(cCurrentProjectName) + " "                   */
/*                        + QUOTER(pcFullPathName), true, output pcProjectName).*/
    
    if pcProjectName = "FALSE":U then
        pcProjectName = "".
    
    if pcprojectName <> "" then
    do:
        run adeuib/_oeidepref.p PERSISTENT SET phand.
        run SetCurrentProjectProperties in phand(pcprojectName).
        if valid-handle(phand) then
        delete object phand no-error.
    end.

end procedure.


&ENDIF

&IF DEFINED(EXCLUDE-getProjectProperties) = 0 &THEN

procedure getPreferences :
/*------------------------------------------------------------------------------
  Purpose: Returns the project properties from the ide
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
    define output parameter pcProperties as character  no-undo.

    run sendWaitRequest in getSocketClient()
          (GET_IDE_PREFERENCES,
          "IDE getIDEPreferences ":U 
          +  quoter(GetProjectName()),
          output pcproperties).
           
end procedure.


&ENDIF

&IF DEFINED(EXCLUDE-RunChildDialog) = 0 &THEN

procedure runChildDialog :
/*------------------------------------------------------------------------------
  Purpose: Asks the IDE to start a dialog and call RunChildDialog from it 
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
    /* the object that knows who and what to call  */
    define input parameter Object as Object  no-undo.
    /* store handle for call back to the uib service */
    setCurrentEventObject(Object).
    run sendRequest in getSocketClient()
          (RUN_CHILD_DIALOG ,
          "IDE RunChildDialog ":U 
          +  quoter(GetProjectName())) .
          
end procedure.


&ENDIF

&IF DEFINED(EXCLUDE-setNextChildDialog) = 0 &THEN

procedure setNextChildDialog :
/*------------------------------------------------------------------------------
  Purpose: Sets the next dialog.
           Sets HasNextDialog to true.
           Caller must check and return signal to the IDE to call again from 
           current runchildDialog request. 
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
    /* the object that knows who and what to call  */
    define input parameter Object as Object  no-undo.
    /* store handle for call back to the uib service */
    setNextEventObject(Object).
end procedure.

&ENDIF

/*&IF DEFINED(EXCLUDE-runWizard) = 0 &THEN                                   */
/*                                                                                */
/*procedure runWizard :                                                           */
/*/*------------------------------------------------------------------------------*/
/*  Purpose: Asks the IDE to start a dialog and call RunChildDialog from it       */
/*  Parameters:                                                                   */
/*  Notes:                                                                        */
/*------------------------------------------------------------------------------*/*/
/*    /*  te  */                                                                  */
/*    define input parameter pcTemplateName as char  no-undo.                     */
/*    /* store handle for call back to the uib service */                         */
/*    run sendRequest in getSocketClient()                                        */
/*          (RUN_WIZARD ,                                                         */
/*          "IDE RunWizard ":U                                                    */
/*          +  quoter(pcTemplateName)) .                                          */
/*                                                                                */
/*end procedure.                                                                  */
/*                                                                                */
/*                                                                                */
/*&ENDIF                                                                          */




&IF DEFINED(EXCLUDE-getProjectProperties) = 0 &THEN

procedure getProjectProperties :
/*------------------------------------------------------------------------------
  Purpose: Returns the project properties from the ide
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
    define output parameter pcProperties as character  no-undo.

    run sendWaitRequest in getSocketClient()
          (GET_PROJECT_PROPERTIES,
          "IDE getProjectProperties ":U 
          +  quoter(GetProjectName()),
          output pcproperties).
           
 
end procedure.


&ENDIF


&IF DEFINED(EXCLUDE-getProjectOfFile) = 0 &THEN

procedure getProjectOfFile :
/*------------------------------------------------------------------------------
  Purpose: Returns the project associated with a file
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
define input parameter pcFullPathName as character  no-undo.
define output parameter pcProjectName as character  no-undo.
define variable cCurrentProjectName as character   no-undo.
if pcFullPathName = "" or pcFullPathName = ? then
do:
    pcProjectName = "".
    return.
end.
    
    
cCurrentProjectName = getProjectName().
run sendWaitRequest in getSocketClient()(
                    GET_PROJECT_OF_FILE, 
                    "IDE getProjectOfFile ":U 
                    + QUOTER(cCurrentProjectName) + PARAMETER_DELIMITER    
                    + QUOTER(pcFullPathName), 
                     output pcProjectName).

if pcProjectName = "FALSE":U then
    pcProjectName = "".

end procedure.


&ENDIF

&IF DEFINED(EXCLUDE-CreateDialogService) = 0 &THEN

procedure createDialogService :
/*------------------------------------------------------------------------------
  Purpose:  Creates a dialog service for the IDE 
  Parameters:
        INOUT frame handle 
        OUTPUT adeuib.idialogservice 
  Notes: 
------------------------------------------------------------------------------*/
    define input parameter pFrame  as handle  no-undo.
    define output parameter pdialog as adeuib.idialogservice  no-undo.
    define variable iHwnd as int64 no-undo.
    ihwnd = getOpenDialogHwnd().
    pdialog = new adeuib._dialogservice(pframe,ihwnd).
    registerObject(ihwnd,pdialog).
end procedure.


&ENDIF



&IF DEFINED(EXCLUDE-asyncRequest) = 0 &THEN

procedure asyncRequest :
/*------------------------------------------------------------------------------
  Purpose: Executes IDE commands ignoring its response
  Parameters:
        INPUT   pcCommand IDE command to be send to the OEIDE
  Notes: 
------------------------------------------------------------------------------*/
    define input parameter pcCommand as character   no-undo.

    define variable cResult as character   no-undo.

    run sendRequest(pcCommand, false, output cResult).
end procedure.


&ENDIF

&IF DEFINED(EXCLUDE-appbuilderConnection) = 0 &THEN

procedure appbuilderConnection :
/*    define input  parameter pReply as longchar no-undo.*/
    run sendRequest in getSocketClient()(
                        APPBUILDER_CONNECTION, 
                        "IDE appbuilderConnection ":U 
                        + quoter(getProjectName())).
    
end procedure.    

&ENDIF

&IF DEFINED(EXCLUDE-resizeToParent) = 0 &THEN

procedure resizeToParent :
    define input  parameter hWindow as handle no-undo.
    define variable wrect as memptr no-undo.
    define variable iparent as integer no-undo.
    define variable ihwnd as integer no-undo.
    define variable iXpos as integer no-undo.
    define variable iYpos as integer no-undo.
    define variable iWidth as integer no-undo.
    define variable iHeight as integer no-undo.
    
    run GetParent(hWindow:hwnd,output iparent).
    if iparent <> 0 then 
    do on error undo, leave:
        set-size(wrect) = 16. /* 4 INTEGERS at 4 bytes each*/
        run GetWindowRect(iparent, output wrect).        
        assign iXpos = GET-LONG(wrect, 1)
               iYpos = GET-LONG(wrect, 5).
               iWidth = GET-LONG(wrect, 9).
               iHeight = GET-LONG(wrect, 1).
        hWindow:height = iheight.
        hwindow:width = iWidth.
        
    end.
end procedure.
&ENDIF


&IF DEFINED(EXCLUDE-sendRequest) = 0 &THEN

procedure sendRequest :
/*------------------------------------------------------------------------------
  Purpose: Executes IDE commands 
  Parameters:
        INPUT   pcCommand IDE command to be send to the OEIDE
        INPUT   plWait    Wait for response from the OEIDE
        OUTPUT  pcResult  String returned from the OEIDE.
                It cannot be unknown.
                The string TRUE and FALSE may be returned from the OEIDE.
  Notes: DEPRECATED This is old and not in use 
             -  kept in case someone calls it (customer code)   
------------------------------------------------------------------------------*/
define input parameter pcCommand as character   no-undo.
define input parameter plWait    as logical     no-undo.
define output parameter pcResult as character   no-undo initial "FALSE":U.

define variable hSocket as handle      no-undo.
define variable mBuffer as memptr      no-undo.
define variable mReadBuffer as memptr  no-undo.
define variable lStatus as logical     no-undo.

   if pcCommand = ? then return.
   if not plWait then
       pcResult = "TRUE":U.
/*    MESSAGE "sendrequest:"*/
/*                          */
/*           pccommand      */
/*    VIEW-AS ALERT-BOX.    */
   create socket hSocket.
   
   lStatus = hSocket:connect("-H localhost -S ":U + OS-GETENV("OEA_PORT":U)) no-error.
   if not lStatus then return.
   
   pcCommand = pcCommand + "~n".
   SET-SIZE(mBuffer)      = 0.
   SET-SIZE(mBuffer)      = length(pcCommand) + 1.
   PUT-STRING(mBuffer, 1) = pcCommand.
   
   lStatus = hSocket:write(mBuffer, 1, length(pcCommand)).
   SET-SIZE(mBuffer) = 0.
   if not lStatus then return.       
 
   if plWait then
   do:
        SET-SIZE(mReadBuffer)      = {&BUFFER_SIZE}.
        if hSocket:connected() then
        do:
            
            lStatus = not hSocket:read(mReadBuffer, 1, {&BUFFER_SIZE} - 1, read-available) no-error.
            if hSocket:bytes-read > 0 or lStatus then
                pcResult = "".                
            
            do while hSocket:bytes-read > 0:                
                PUT-BYTE(mReadBuffer, hSocket:bytes-read + 1) = 0.
                pcResult = pcResult + GET-STRING(mReadBuffer, 1).
                if hSocket:get-bytes-available() <= 0 then
                    leave.
                lStatus = not hSocket:read(mReadBuffer, 1, {&BUFFER_SIZE} - 1, read-available) no-error.
            end.
           
        end.
        SET-SIZE(mReadBuffer) = 0.        
   end.
 
   hSocket:disconnect() no-error.
   delete object hSocket.
end procedure.


&ENDIF

&IF DEFINED(EXCLUDE-canLaunchDialog) = 0 &THEN

procedure canLaunchDialog: 
    define output parameter plOk as logical  no-undo.         
    plok = HasDialog(session) = false.      
end procedure.       

&ENDIF

&IF DEFINED(EXCLUDE-canShowMessage) = 0 &THEN
/* currently same as dialog, but is a separate api to allow change
   Messages are handled by ide so could always be true... */
procedure canShowMessage: 
    define output parameter plOk as logical  no-undo.         
    plok = HasDialog(session) = false.      
end procedure.       

&ENDIF


&IF DEFINED(EXCLUDE-createUntitledFile) = 0 &THEN

procedure createUntitledFile :
    /*------------------------------------------------------------------------------
      Purpose: Creates an untitled file using the input file name as the source.
      Parameters:
            INPUT-OUTPUT pcFileName Source for the content of the untitled file.                
      Notes: 
    ------------------------------------------------------------------------------*/
    define input-output parameter pcFileName as character   no-undo.
    
    define variable cBaseFileName     as character   no-undo.
    define variable cUntitledFileName as character   no-undo.
    define variable i                 as integer     no-undo.
    define variable cFileExt          as character   no-undo.
    
    /* Use the file extension of the specified file name unless it is .tmp. */
    i = r-index(pcFileName, ".").
    if i > 0 then
    do:
        cFileExt = substring(pcFileName, i).
        if cFileExt = ".tmp":U then
            cFileExt = "".
    end.    
    
    i = 0.
    cBaseFileName = os-getenv("ECLIPSE_ROOT") + "Untitled".
    file-info:file-name = cBaseFileName + STRING(i) + cFileExt.
    do while file-info:full-pathname <> ?:
        i = i + 1.
        file-info:file-name = cBaseFileName + STRING(i) + cFileExt.
    end.
    cUntitledFileName = file-info:file-name.
    file-info:file-name = pcFileName.
    if file-info:full-pathname <> ? then
        os-copy VALUE(file-info:full-pathname) VALUE(cUntitledFileName).
    else
    do:
        output TO VALUE(cUntitledFileName).
        output CLOSE.
    end.    
    
    pcFileName = replace(cUntitledFileName, "~\", "/").  

end procedure.


&ENDIF

&IF DEFINED(EXCLUDE-Win32APIs) = 0 &THEN

procedure Win32APIs :
end procedure.

procedure FindWindowA external "USER32.DLL":
  define input  parameter lpClassName    as LONG.
  define input  parameter lpWindowName   as character.
  define return parameter hWnd           as LONG.
end.

procedure FindWindowByClassName external "USER32.DLL" ordinal 228:
  define input  parameter lpClassName  as character.
  define input  parameter lpWindowName as LONG.
  define return parameter hWnd         as LONG.
end.

procedure GetParent external "USER32.DLL":
  define input  parameter hWnd           as LONG.
  define return parameter rhWnd          as LONG.
end.

procedure SetParent external "USER32.DLL":
  define input  parameter hWndChild      as LONG.
  define input  parameter hWndParent     as LONG.
  define return parameter rhWnd          as LONG.
end.

procedure SetWindowPos external "user32.dll":
  define input parameter hWnd            as LONG.
  define input parameter hWndInsertAfter as LONG.
  define input parameter x               as LONG.
  define input parameter y               as LONG.
  define input parameter cx              as LONG.
  define input parameter cy              as LONG.
  define input parameter wflags          as LONG.   
  define return parameter rc             as LONG.
end.

procedure GetWindowRect external "USER32.DLL":
  define input  parameter  hWnd          as LONG.
  define output parameter  lpRect        as memptr.
end.

procedure ShowWindow external "user32.dll":
    define input parameter hWnd as LONG.
    define input parameter nCmdShow as LONG.
    define return parameter result as LONG.
end.

/* the code is not used in 11.2 and thus removed @todo remove method */
procedure SetWindowPosition:
    define input parameter iParentWindow as int64    no-undo.
    define input parameter hNewWindow    as handle     no-undo.
    define input parameter hOldWindow    as handle     no-undo.
    
end procedure.    

/* the code is not used in 11.2 and thus removed @todo remove method */
procedure SetWindowPositionXY:
    define input parameter iParentWindow as int64    no-undo.
    define input parameter hNewWindow    as handle     no-undo.    
    define input parameter iXpos         as integer    no-undo.
    define input parameter iYpos         as integer    no-undo.

end procedure.    


&ENDIF

 /* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-activateWindow) = 0 &THEN
        
function activateWindow returns logical 
    ( phWindow as handle ):
/*------------------------------------------------------------------------------
        Purpose: activate/set focus in editor                                                                 
        Notes:                                                                        
------------------------------------------------------------------------------*/
  define variable iId  as int64 no-undo.
   
  iId = getDesignId(phWindow).
  
  RUN sendRequest in getSocketClient()
                  (ACTIVATE_EDITOR,
                   "IDE activateEditor ":U
                   + QUOTER(getProjectName()) + PARAMETER_DELIMITER
                   + QUOTER(iId)).
  return true.
end function.
    

&ENDIF

&IF DEFINED(EXCLUDE-checkSyntaxInIde) = 0 &THEN
        
function checkSyntaxInIde returns logical 
    ( phWindow as handle ):
/*------------------------------------------------------------------------------
        Purpose: activate/set focus in editor                                                                 
        Notes:                                                                        
------------------------------------------------------------------------------*/
  define variable iId  as int64 no-undo.
   
  iId = getDesignId(phWindow).
  
  RUN sendRequest in getSocketClient()
                  (CHECK_SYNTAX,
                   "IDE checkSyntax ":U
                   + QUOTER(iId)).
  return true.
end function.
    

&ENDIF


&IF DEFINED(EXCLUDE-getDesignId) = 0 &THEN
        
 /** we currently use the handle as the id -  
  @TODO move to _oeidecontext - it now has window handle (but not indexed yet) */      
function getDesignId returns int64
       (phWidget as handle):
     
     if phWidget:type = "FRAME" then
         return phWidget:PARENT:IDE-PARENT-HWND.  
     else
         return phWidget:IDE-PARENT-HWND.
end function.
    

&ENDIF


&IF DEFINED(EXCLUDE-getDesignFileNameParent) = 0 &THEN
        
function getDesignFileNameParent returns character 
    (piHwnd as handle):
     define variable cFile as character no-undo.   
     if piHwnd:type = "FRAME" then
         cFile = getDesignFileName(piHwnd:PARENT:IDE-PARENT-HWND).  
     else
         cFile = getDesignFileName(piHwnd:IDE-PARENT-HWND).
     return cFile.
 end function.
    

&ENDIF

&IF DEFINED(EXCLUDE-getProjectDisplayName) = 0 &THEN
        
 /** we currently use the handle as the id -  */      
function getProjectDisplayName returns character 
       () :
     define variable cName as character no-undo.
     cName = getProjectName().
     if cName = ".sharedavm":U then 
         cName = "Shared AVM".
     return cName.      
 end function.          

&ENDIF

&IF DEFINED(EXCLUDE-displayEmbeddedWindow) = 0 &THEN

function displayEmbeddedWindow returns logical
         (viewId      as character,
          secondaryId as character,
          hWindow     as handle) :
/*------------------------------------------------------------------------------
  Purpose:  Compound function to show and set the title of a view and embed 
            the specified window into the view
    Notes:  
------------------------------------------------------------------------------*/
    if (secondaryId begins "DesignView":U or secondaryId begins "PropertiesWindow":U) then 
        return true.
    showView(viewId, secondaryId, {&VIEW_ACTIVATE}).
    setViewTitle(viewId, secondaryId, hWindow:title).
    setEmbeddedWindow(viewId, secondaryId, hWindow).
    return true.
end function.


&ENDIF

&IF DEFINED(EXCLUDE-hideView) = 0 &THEN

function hideView returns logical
         (viewId      as character,
          secondaryId as character) :
/*------------------------------------------------------------------------------
  Purpose:  Hides the specified view
    Notes:  
------------------------------------------------------------------------------*/
  define variable cResult as character   no-undo. 
  
  if (secondaryId begins "DesignView":U or secondaryId begins "PropertiesWindow":U) then 
      return true.  
  
  run sendRequest in getSocketClient() 
                  (HIDE_VIEW,
                  "IDE hideView ":U 
                  + viewId + PARAMETER_DELIMITER 
                  + QUOTER(secondaryId)).
  return true.

end function.


&ENDIF

&IF DEFINED(EXCLUDE-runDialog) = 0 &THEN
        
function runDialog returns logical 
    ( phWindow as handle, 
      pcDialogCommand as char) :  

   return runUIBCommand(phWindow,pcDialogCommand).
  
end function.
    

&ENDIF


&IF DEFINED(EXCLUDE-runUIBCommand) = 0 &THEN
        
function runUIBCommand returns logical 
    ( phWindow as handle,
      pcCommand as char  ):
 
  define variable iId as int64 no-undo.
  
  /* TODO use tLinkedfile? */
  iId = getDesignId(phWindow).
  run sendRequest in getSocketClient() (
                   RUN_UIB_COMMAND,  
                   "IDE runUIBCommand ":U 
                   + QUOTER(getProjectName()) + PARAMETER_DELIMITER
                   + QUOTER(iId) + PARAMETER_DELIMITER
                   + QUOTER(pcCommand)).
  
  return true.
end function.
    

&ENDIF

&IF DEFINED(EXCLUDE-setEmbeddedWindow) = 0 &THEN

function setEmbeddedWindow returns logical
         (viewId      as character,
          secondaryId as character,
          hWindow     as handle) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the given 4GL window as an embedded window in the specified
            view
    Notes:  
------------------------------------------------------------------------------*/
    define variable lVisible as logical    no-undo.
    define variable wHwnd as int64       no-undo.
    define variable cResult as character   no-undo.  
  
&IF "{&NO_EMBEDDED_WINDOWS}" EQ "YES" &THEN  
    return true.
&ENDIF    
    if (secondaryId begins "DesignView":U ) then 
        return true.
    if hWindow:hwnd = ? then
    do:
        lVisible = hWindow:visible.
        hWindow:visible = true.
        hWindow:visible = lVisible.
    end.                                     
    run GetParent (hWindow:hwnd, output wHwnd).
    run sendRequest in getSocketClient()
                (SET_EMBEDDED_WINDOW,
                 "IDE setEmbeddedWindow ":U 
                 + viewId + PARAMETER_DELIMITER 
                 + QUOTER(secondaryId) + PARAMETER_DELIMITER
                 + STRING(wHwnd)).
  return true.

end function.


&ENDIF

&IF DEFINED(EXCLUDE-setTTYTerminalColor) = 0 &THEN

function setTTYTerminalColor returns logical
         (pBg as int,
          pFg as int):
              
    run sendRequest in getSocketClient() (
                  SET_TTY_TERMINAL_COLOR,
                  "IDE setTTYTerminalColor ":U 
                  + QUOTER(GetProjectName()) + PARAMETER_DELIMITER
                  + QUOTER(pBg) + PARAMETER_DELIMITER
                  + QUOTER(pFg)).
    return true. 
end function.


&ENDIF


&IF DEFINED(EXCLUDE-setViewTitle) = 0 &THEN

function setViewTitle returns logical
         (viewId      as character,
          secondaryId as character,
          viewTitle   as character) :
/*------------------------------------------------------------------------------
  Purpose: Sets the title of the specified view
    Notes:  
------------------------------------------------------------------------------*/
  define variable cResult as character   no-undo.
  
  if (secondaryId begins "DesignView":U) then
      return true.
                               
  run sendRequest in getSocketClient() (
                  SET_VIEW_TITLE,
                  "IDE setViewTitle ":U 
                  + viewId + PARAMETER_DELIMITER 
                  + QUOTER(secondaryId) + PARAMETER_DELIMITER
                  + QUOTER(viewTitle)).
  return true.

end function.


&ENDIF

&IF DEFINED(EXCLUDE-checkHelp) = 0 &THEN

function checkHelp returns logical
         (pcContextId as char) :
    define variable cExists as character no-undo.
    run sendWaitRequest in getSocketClient()
          (CHECK_HELP,
          "IDE CheckHelp ":U
          +  quoter(pcContextId),
            output cExists ).
    return logical(cExists).
end function.

&ENDIF



&IF DEFINED(EXCLUDE-showHelp) = 0 &THEN

function showHelp returns logical
         (pcContextId as char) :
    define variable cExists as character no-undo.
     run sendRequest in getSocketClient()
          (SHOW_HELP,
          "IDE OpenHelp ":U 
          +  quoter(pcContextId) ).
    return true.         
end function.

&ENDIF

&IF DEFINED(EXCLUDE-showView) = 0 &THEN

function showView returns logical
         (viewId      as character,
          secondaryId as character,
          mode        as integer) :
/*------------------------------------------------------------------------------
  Purpose:  Displays the specified view in the IDE
    Notes:  
------------------------------------------------------------------------------*/
  define variable cResult as character   no-undo.
  if (secondaryId begins "DesignView":U) then
      return true.
        
  if mode = ? or mode <= 0 or mode > 3 then /* mode values are 1, 2, 3 */
      mode = {&VIEW_ACTIVATE}.              /* Default value */
  run sendRequest in getSocketClient() (
                  SHOW_VIEW,
                  "IDE showView ":U 
                  + viewId + PARAMETER_DELIMITER 
                  + QUOTER(secondaryId) + PARAMETER_DELIMITER
                  + STRING(mode)).
  return true.

end function.


&ENDIF

&IF DEFINED(EXCLUDE-openEditor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openEditor Procedure 
function openEditor returns logical
         (cProjectName  as character,
          cFileName     as character,
          cLinkedFile   as character,
          hWindowHandle as handle) :
/*------------------------------------------------------------------------------
  Purpose:  Open an OEIDE Editor instance.
    Notes:  For backwards compatibility
    - cLinkedFile - "untitled" is only supported value  
    - hWindowHandle  - is ignored 
------------------------------------------------------------------------------*/
define variable cResult as character   no-undo.


if cProjectName = ? then cProjectName = getProjectName().
if cLinkedFile = "UNTITLED":U then
do:
    run createUntitledFile(input-output cFileName).
end.    
    
return openTextEditor (cProjectName,cFileName).

end function.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-openDesignEditor) = 0 &THEN

function openDesignEditor returns logical 
          (cProjectName  as character,
           cFileName     as character ) :
/*------------------------------------------------------------------------------
  Purpose: Open an OEIDE Design Editor instance for a dynamic Dynamics object.
    Notes: static Dynamics objects should use openEditor  
------------------------------------------------------------------------------*/
    if cProjectName = ? then cProjectName = getProjectName().
    run sendRequest in getSocketClient() (OPEN_DESIGN_EDITOR,
                                      "IDE openDesignEditor ":U 
                                      + QUOTER(cProjectName) + PARAMETER_DELIMITER
                                      + QUOTER(cfileName)).  
    return true.    
end function.

&ENDIF

&IF DEFINED(EXCLUDE-openDynamicsEditor) = 0 &THEN

function openDynamicsEditor returns logical 
          (cProjectName  as character,
           cFileName     as character ) :
/*------------------------------------------------------------------------------
  Purpose: Open an OEIDE Design Editor instance for a dynamic Dynamics object.
    Notes: static Dynamics objects should use openEditor  
------------------------------------------------------------------------------*/
    if cProjectName = ? then cProjectName = getProjectName().
    run sendRequest in getSocketClient() (OPEN_DYNAMICS_EDITOR,
                                      "IDE openDynamicsEditor ":U 
                                      + QUOTER(cProjectName) + PARAMETER_DELIMITER
                                      + QUOTER(cfileName)).  
    return true.    
end function.

&ENDIF

 &IF DEFINED(EXCLUDE-openTextEditor) = 0 &THEN

function openTextEditor returns logical 
          (cProjectName  as character,
           cFileName     as character ) :
/*------------------------------------------------------------------------------
  Purpose: Open an OEIDE Design Editor instance for a dynamic Dynamics object.
    Notes: static Dynamics objects should use openEditor  
------------------------------------------------------------------------------*/
    if cProjectName = ? then cProjectName = getProjectName().
    run sendRequest in getSocketClient() (OPEN_TEXT_EDITOR,
                                      "IDE openTextEditor ":U 
                                      + QUOTER(cProjectName) + PARAMETER_DELIMITER
                                      + QUOTER(cfileName)).  
    return true.    
end function.

&ENDIF
 

&IF DEFINED(EXCLUDE-openPropertySheet) = 0 &THEN
function openPropertySheet returns logical 
          (phWindow  as handle):
    
    define variable iId  as int64 no-undo.
   
    iId = getDesignId(phWindow).
    run sendRequest in getSocketClient() (
                      OPEN_PROPERTY_SHEET,
                      "IDE openPropertySheet ":U 
                    + QUOTER(getProjectName()) + PARAMETER_DELIMITER
                    + QUOTER(iId)).       

    return true.
end function.                
&ENDIF


&IF DEFINED(EXCLUDE-saveEditor) = 0 &THEN

function saveEditor returns logical
         (cProjectName  as character,
          cFileName     as character,
          ask_file_name as logical) :
/*------------------------------------------------------------------------------
  Purpose: Tells the OpenEdge IDE to perform a save operation on the 
           OpenEdge IDE Editor
    Notes: 
    - A Save or Save Ass dialog is used dependeding on the ask_file_name 
    parameter 
------------------------------------------------------------------------------*/
  define variable cResult as character   no-undo.

/*
  IF hWindowHandle <> ? THEN /* A .w file is being opened. */
  DO:
      FIND ttLinkedFile WHERE ttLinkedFile.windowHandle = hWindowHandle NO-ERROR.
      IF NOT AVAILABLE ttLinkedFile THEN
          CREATE ttLinkedFile.

      ASSIGN ttLinkedFile.windowHandle = hWindowHandle
             ttLinkedFile.projectName  = cProjectName
             ttLinkedFile.fileName     = cFileName
             ttLinkedFile.linkedFile   = cLinkedFile.
      FILE-INFO:FILE-NAME = cLinkedFile.         
      ASSIGN ttLinkedFile.syncTimeStamp = DATETIME(FILE-INFO:FILE-MOD-DATE, FILE-INFO:FILE-MOD-TIME).
  END.
*/
  
  run sendRequest in getSocketClient() 
                  (SAVE_EDITOR,
                   "IDE saveEditor ":U 
                  + QUOTER(cProjectName) + PARAMETER_DELIMITER
                  + QUOTER(cfileName) + PARAMETER_DELIMITER
                  + (if ask_file_name then "SAVEAS":U else "SAVE":U)
                  ).
  return true.

end function.


&ENDIF

&IF DEFINED(EXCLUDE-closeEditor) = 0 &THEN

function closeEditor returns logical
         (cProjectName  as character,
          cFileName     as character,
          lSaveChanges  as logical) :
/*------------------------------------------------------------------------------
  Purpose:  Closes OEIDE Editor instance for the specified file name
    Notes:  
------------------------------------------------------------------------------*/
  
  run sendRequest in getSocketClient()
                  (CLOSE_EDITOR,
                   "IDE closeEditor ":U 
                  + QUOTER(cProjectName) + PARAMETER_DELIMITER
                  + QUOTER(cFileName) + PARAMETER_DELIMITER
                  + (if lSaveChanges then "TRUE":U else "FALSE":U)
                  ).
  return true.

end function.


&ENDIF

&IF DEFINED(EXCLUDE-closeEditor) = 0 &THEN

function gotoPage returns logical
         (phWindow as handle,
          piPage as int) :
/*------------------------------------------------------------------------------
  Purpose:  go to page of window
    Notes:  
------------------------------------------------------------------------------*/
   define variable cFile   as character no-undo.
   define variable cResult as character no-undo.
  
   define variable iDesignId as int64 no-undo. 
   iDesignId = getDesignId(phWindow).  
  
   run sendRequest in getSocketClient() (
                   GOTO_PAGE,
                   "IDE GotoPage ":U 
                  + QUOTER(iDesignId) + PARAMETER_DELIMITER
                  + QUOTER(piPage)) .
  return true.

end function.


&ENDIF


&IF DEFINED(EXCLUDE-keyPressed) = 0 &THEN

function keyPressed returns logical 
    ( phWindow as handle,
      pcKey    as character):
/*------------------------------------------------------------------------------
  Purpose:  handle keystroke
    Notes:  
------------------------------------------------------------------------------*/
    define variable iDesignId as int64 no-undo. 
    iDesignId = getDesignId(phWindow).  
  
    run sendRequest in getSocketClient()
                    (KEY_PRESSED,
                      "IDE KeyPressed ":U 
                      + QUOTER(iDesignId) + PARAMETER_DELIMITER
                      + QUOTER(pcKey)).
  
  return true.

end function.

&ENDIF

&IF DEFINED(EXCLUDE-viewSource) = 0 &THEN

function viewSource returns logical
         (phWindow as handle,
          wName AS CHARACTER,
          wType AS CHARACTER,
          wSection AS CHARACTER,
          wTrigger AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  View source for the specified window
    Notes:  
------------------------------------------------------------------------------*/
    define variable iDesignId as int64 no-undo. 
    iDesignId = getDesignId(phWindow).  
  
    run sendRequest in getSocketClient()
                    (VIEW_SOURCE,
                      "IDE viewSource ":U 
                      + QUOTER(iDesignId) + PARAMETER_DELIMITER
                      + QUOTER(wName) + PARAMETER_DELIMITER
                      + QUOTER(wType) + PARAMETER_DELIMITER
                      + QUOTER(wSection) + PARAMETER_DELIMITER
                      + QUOTER(wTrigger)).
  
  return true.

end function.


&ENDIF


&IF DEFINED(EXCLUDE-findAndSelect) = 0 &THEN

function findAndSelect returns logical
         (projectName  as character,
          fileName     as character,
          cText        as character,
          activateEditor as logical) :
/*------------------------------------------------------------------------------
  Purpose:  Finds and select the specified text in the OEIDE Editor
    Notes:  
------------------------------------------------------------------------------*/
  define variable cResult as character   no-undo.
    /*
    FIND ttLinkedFile WHERE ttLinkedFile.fileName = fileName NO-ERROR.
    
    /* TODO - findAndSelect sometimes get fileName with slashes instead of backslashes */
    IF NOT AVAILABLE ttLinkedFile THEN
    DO: 
        fileName = REPLACE(fileName, "/", "~\").
        FIND ttLinkedFile WHERE ttLinkedFile.fileName = fileName NO-ERROR.
    END.    
    
    IF NOT AVAILABLE ttLinkedFile THEN RETURN FALSE.
    */
   
    run sendRequest in getSocketClient() (
                   FIND_AND_SELECT,
                   "IDE findAndSelect ":U 
                   + QUOTER(getProjectName()) + PARAMETER_DELIMITER
                   + QUOTER(fileName) + PARAMETER_DELIMITER
                   + QUOTER(cText) + PARAMETER_DELIMITER
                   + (if activateEditor then "TRUE" else "FALSE")
                   ).
    return true.

end function.


&ENDIF

&IF DEFINED(EXCLUDE-createLinkedFile) = 0 &THEN

function createLinkedFile returns character
         (user_chars   as character,
          extension    as character) :
/*------------------------------------------------------------------------------
  Purpose:  Creates an available temporary file in the linked_resources area.
    Notes:  The return parameter is a complete name that includes the path.
    
    This code is based on adecomm/_tmpfile.p.
------------------------------------------------------------------------------*/

define var name           as character no-undo.
define var name1           as character no-undo.

define var base           as integer.
define var check_name     as character.
define variable lastChar         as character no-undo.
/*
 * Loop until we find a name that hasn't been used. In theory, if the
 * temp directory gets filled, this could be an infinite loop. But, the
 * likelihood of that is low.
 */
check_name = "something":U.
 
do while check_name <> ?:
  /* Take the lowest 5 digits (change the format so that everything works out to have exactly 5
     characters. */
     
  assign
    base = ( time * 1000 + etime ) modulo 100000
    name1 = string(base,"99999":U)
    lastChar = substring(name1,length(name1)) 
     /* Add in the extension and directory into the name. */
    name = getProjectWorkDirectory() 
          + (if not (lastChar = "~\" or lastChar ="/") then "/" else "") 
          + "p":U + name1 + user_chars + extension.
          
  check_name = search(name).
  
end.
/* Creates the linked file */
output TO VALUE(name).
output CLOSE.

name = replace(name, "~\", "/").
name = replace(name, "//", "/").
       
return name.

end function.


&ENDIF

&IF DEFINED(EXCLUDE-ShowOkMessageInIDE) = 0 &THEN

function ShowOkMessageInIDE returns logical
         (msgText      as character,
          MsgType      as character,
          MsgTitle     as character) :
    return ShowMessageInIDE(msgText,MsgType,MsgTitle,"OK",true).     
end function.

&ENDIF

&IF DEFINED(EXCLUDE-ShowMessageInIDE) = 0 &THEN

function ShowMessageInIDE returns logical
         (msgText      as character,
          MsgType      as character,
          MsgTitle     as character, 
          MsgButtons   as character,
          ButtonValue  as logical):
   define variable cResult as character  no-undo.
   define variable ButtonFocus as character no-undo.
   define variable iReturn as integer no-undo.
   
   If msgtitle = ? or msgTitle = "?" then 
      msgTitle = upper(substring(MsgType,1,1)) 
               + lower(substring(MsgType,2,length(MsgType))).
   
   case msgType:
       when "Information" then msgType = "0".
       when "Warning"     then msgType = "1".
       when "Error"       then msgType = "2".
       when "Question"    then msgType = "3".
       otherwise msgType = "2".

   end.
   /* Possible button values are: YES-NO,YES-NO-CANCEL,OK,OK-CANCEL,RETRY-CANCEL. */
   case MsgButtons:
       when "OK" then 
           Assign ButtonFocus = "OK"
                  MsgButtons = "OK". /* get right case */
       when "OK-Cancel" then
       do:
            if ButtonValue then ButtonFocus = "OK".
            else ButtonFocus = "Cancel".
            MsgButtons = "OK-Cancel". /* get right case */
       end.
       when "YES-NO" then
       do:
            if ButtonValue then ButtonFocus = "Yes".
            else ButtonFocus = "No".
            MsgButtons = "Yes-No". /* get right case */
       end.
       when "YES-NO-CANCEL" then
       do:
            if ButtonValue then ButtonFocus = "Yes".
            else if not ButtonValue then ButtonFocus = "No".
            else ButtonFocus = "Cancel".
            MsgButtons = "Yes-No-Cancel". /* get right case */
       end.
       when "RETRY-CANCEL" then
       do:
            if ButtonValue then ButtonFocus = "Retry".
            else ButtonFocus = "Cancel".
            MsgButtons = "Retry-Cancel". /* get right case */
       end.
   end case.
   run sendWaitRequest in getSocketClient()               
                 (SHOW_MESSAGE_IN_IDE,
                  "IDE ShowMessageInIDE ":U
                  + QUOTER(msgText)      + PARAMETER_DELIMITER
                  + QUOTER(MsgType)    + PARAMETER_DELIMITER
                  + QUOTER(MsgTitle)   + PARAMETER_DELIMITER
                  + QUOTER(MsgButtons) + PARAMETER_DELIMITER
                  + QUOTER(ButtonFocus),
                  output cResult).
    
   iReturn =lookup(cResult,MsgButtons,"-").
    /* bad return - assume last button  (cancel if possible)*/
   if not (iReturn > 0) then
       iReturn = num-entries(MsgButtons).
   
   case iReturn:
        when 1 then return true. 
        when 2 then return false.
        when 3 then return ?. 
   end.     
                      
end function.

&ENDIF


&IF DEFINED(EXCLUDE-hasDdialog) = 0 &THEN
/** Utility. used by CanLaunchDialog to check if we can call ide. If a ide supported procedure is used by a dialog for example
    when being called from an unsupported wizard it cannot launch through IDE, since the IDE hosted
    dialog is a window from the ABL perpsective. oeideservice.i OEIDE_CanLaunch() is external api 
  -  oeideservice is included by adm2 code that does not have access to ade code so no other place to add this utility */ 
function HasDialog returns logical
         (phParent as handle):
    define variable hChild  as handle no-undo.
    hChild = phParent:first-child.
    do while valid-handle(hChild):
        if hChild:type = "window" and HasDialog(hChild) then
            return true.  
         /* Check for visible added due to issues with the hidden 
            clipboard frame, so the check returned true after 
            cut, copy, paste (hidden dialog should not cause the 
            problem this check attempts to avoid )   */
        else if hChild:type = "dialog-box" and hChild:visible then 
            return true.  
        hChild = hChild:next-sibling.
    end.     
    return false.                          
end function.       

&ENDIF

&IF DEFINED(EXCLUDE-SetWindowSize) = 0 &THEN             
function SetWindowSize return logical
         (phWindow as handle ):
    
    define variable iDesignId as int64 no-undo. 
    define variable wrect as memptr no-undo.
    define variable iXpos as integer no-undo.
    define variable iYpos as integer no-undo.
    define variable iWidth as integer no-undo.
    define variable iHeight as integer no-undo.
  
/* @todo get  true external size -  this returns big numbers */
/*      phWindow:visible = true. */
    
/*    SET-SIZE(wrect) = 16. /* 4 INTEGERS at 4 bytes each */*/
/*                                                          */
/*                                                          */
/*    run GetWindowRect(phWindow:hwnd, output wrect).       */
/*    assign iXpos = GET-LONG(wrect, 1)                     */
/*           iYpos = GET-LONG(wrect, 5).                    */
/*           iWidth = GET-LONG(wrect, 9).                   */
/*           iHeight = GET-LONG(wrect, 13).                 */
   
      
    ixpos = phWindow:x.
    iypos = phWindow:y.
    iwidth = phWindow:width-p  .
    iheight= phwindow:height-p  .
    iDesignId = getDesignId(phWindow). 
    if (iDesignId) > 0 then 
        run sendRequest in getSocketClient() (
                      SET_WINDOW_SIZE,
                      "IDE SetWindowSize ":U 
                    + QUOTER(iDesignId) + PARAMETER_DELIMITER
                    + QUOTER(iXpos) + PARAMETER_DELIMITER
                    + QUOTER(iYpos) + PARAMETER_DELIMITER  
                    + QUOTER(iWidth)  + PARAMETER_DELIMITER
                    + QUOTER(iHeight)).            
          
end function.                 
&ENDIF

&IF DEFINED(EXCLUDE-WidgetEvent) = 0 &THEN             
function WidgetEvent return logical
         (phwindow   as handle,
          WidgetName as character,
          WidgetText as character,
          WidgetType as character,
          WidgetParent as character,
          WidgetAction as character ):
      define variable iDesignId as int64 no-undo. 
     /* valid check - may be called when the window itself is deleted (save all)  
       if necessary we may use an id to manage this, but it was only encountered 
        during a save all that deleted the window due to save outside of project... 
      @TODO -  Maybe sanitize should be moved to getDesignId or use an id instead of handle 
         */
      if valid-handle(phWindow) then
      do:      
          iDesignId = getDesignId(phWindow).    
          if (iDesignId) > 0 then
          do: 
               /* ensure constant casing. _attr-ed saves with different case  */
               if WidgetType <> "SmartObject":U then 
                   WidgetType = caps(WidgetType).
               run sendRequest in getSocketClient() (
                          WIDGET_EVENT,
                          "IDE WidgetEvent ":U 
                        + QUOTER(iDesignId) + PARAMETER_DELIMITER
                        + QUOTER(WidgetName) + PARAMETER_DELIMITER
                        + QUOTER(WidgetText) + PARAMETER_DELIMITER
                        + QUOTER(WidgetType) + PARAMETER_DELIMITER
                        + QUOTER(WidgetParent) + PARAMETER_DELIMITER
                        + QUOTER(WidgetAction) ).     
          end.
      end.
end function.                               
&endif             

&IF DEFINED(EXCLUDE-AddCodeSection) = 0 &THEN
 function AddCodeSection return logical
         (phwindow   as handle,
          AddSection as character):
      define variable iDesignId as int64 no-undo. 
      iDesignId = getDesignId(phWindow).          
      if (iDesignId) > 0 then 
      run sendRequest in getSocketClient() (
                      ADD_CODE_SECTION,
                      "IDE AddCodeSection ":U 
                    + QUOTER(iDesignId) + PARAMETER_DELIMITER
                    + QUOTER(AddSection) ).   
 end function.              
&endif

&IF DEFINED(EXCLUDE-ReNameWidget) = 0 &THEN             
function RenameWidget return logical
         (phwindow   as handle,
          WidgetOldName as character,
          WidgetNewName as character,
          WidgetText as character,
          WidgetType as character,
          WidgetParent as character,
          WidgetAction as character ):
      define variable iDesignId as int64 no-undo. 
      iDesignId = getDesignId(phWindow).    
     
      if (iDesignId) > 0 then
      do:
           /* ensure constant casing. _attr-ed saves with different case  */
           if WidgetType <> "SmartObject":U then 
               WidgetType = caps(WidgetType).
           run sendRequest in getSocketClient() (
                      RENAME_WIDGET_NAME,
                      "IDE RenameWidgetName ":U
                    + QUOTER(iDesignId) + PARAMETER_DELIMITER
                    + QUOTER(WidgetOldName) + PARAMETER_DELIMITER
                    + QUOTER(WidgetNewName) + PARAMETER_DELIMITER
                    + QUOTER(WidgetText) + PARAMETER_DELIMITER
                    + QUOTER(WidgetType) + PARAMETER_DELIMITER
                    + QUOTER(WidgetParent) + PARAMETER_DELIMITER
                    + QUOTER(WidgetAction) ).
     end.              
end function.                               
&endif       

&IF DEFINED(EXCLUDE-AddTrigger ) = 0 &THEN
function AddTrigger return logical
         (phwindow   as handle,
          WidgetName as character,
          WidgetType as character):
    define variable iDesignId as int64 no-undo. 
    iDesignId = getDesignId(phWindow).          
    if (iDesignId) > 0 then 
    do:
        /* ensure constant casing. _attr-ed saves with different case  */
        if WidgetType <> "SmartObject":U then 
             WidgetType = caps(WidgetType).
        run sendRequest in getSocketClient() (
                          ADD_TRIGGER,
                          "IDE AddTrigger ":U 
                        + QUOTER(iDesignId) + PARAMETER_DELIMITER
                        + QUOTER(WidgetName)+ PARAMETER_DELIMITER
                        + QUOTER(WidgetType) ).       
    end.                      
end function.            
&endif       

&IF DEFINED(EXCLUDE-RunDesign) = 0 &THEN
function RunDesign return logical
         (phwindow   as handle):
    define variable iDesignId as int64 no-undo. 
    iDesignId = getDesignId(phWindow).          
    if (iDesignId) > 0 then 
    run sendRequest in getSocketClient() (
                      RUN_DESIGN,
                      "IDE RunDesign ":U 
                    + QUOTER(iDesignId) ).               
end function.             
&endif      
       
&IF DEFINED(EXCLUDE-CompileDesign) = 0 &THEN         
function CompileDesign return logical
         (phwindow   as handle):  
         define variable iDesignId as int64 no-undo. 
    iDesignId = getDesignId(phWindow).          
    if (iDesignId) > 0 then 
    run sendRequest in getSocketClient() (
                      COMPILE_DESIGN,
                      "IDE CompileDesign ":U 
                      + QUOTER(iDesignId) ).              
end function.               
&endif  

&IF DEFINED(EXCLUDE-ShowCueCard) = 0 &THEN
function ShowCueCard return logical
         (CueCardTitle as character,
          CueCardMessage as character):
              
     run sendRequest in getSocketClient() (
                      SHOW_CUE_CARD,
                      "IDE SHowCueCard ":U 
                      + QUOTER(CueCardTitle) + PARAMETER_DELIMITER
                      + QUOTER(CueCardMessage) ).           
end function.                
&endif  

&IF DEFINED(EXCLUDE-OpenDBConnectionDialog) = 0 &THEN
function OpenDBConnectionDialog return logical
         (pmessage as character):
    define variable pcOk as character no-undo.        
    if pmessage = ? then 
        pmessage = "".    
    run sendWaitRequest in getSocketClient()
          (OPEN_DB_CONNECTION,
          "IDE OpenDBConnectionDialog ":U 
          +  quoter(GetProjectName()) + PARAMETER_DELIMITER
          +  quoter(pmessage) ,
          output pcOk).  
    return logical(pcOk) .            
end function.                               
&endif             