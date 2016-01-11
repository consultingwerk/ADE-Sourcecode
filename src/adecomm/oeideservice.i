/*************************************************************/
/* Copyright (c) 1984-2012 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : oeideservice.i
    Purpose     : Function prototypes for oeideservice.p

    Syntax      : {adecomm/oeideservice.i}

    Description : 

    Author(s)   : egarcia
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
  
  
/* Code is only included once */

&IF DEFINED(OEIDESERVICE_I) = 0 &THEN
&GLOBAL-DEFINE OEIDESERVICE_I

/* ***************************  Definitions  ************************** */
&IF DEFINED(IN-CLASS) <> 0 &THEN 
&SCOPED-DEFINE METHOD method public static final void Init(): 
&SCOPED-DEFINE METHOD-END end. 
&SCOPED-DEFINE NO-NEW 
&ENDIF

&IF DEFINED(NO-NEW) = 0 &THEN 
&SCOPED-DEFINE NEW new global shared
&ELSE 
&SCOPED-DEFINE STAT static
&SCOPED-DEFINE NEW static

&ENDIF
/* 
 * OEIDEIsRunning   Flag indicating that the OpenEdge IDE is running
 * hOEIDEService    Handle to the oeideservice.p persistent procedure
 */
define {&NEW} var OEIDEIsRunning as logical    no-undo.
define {&NEW} var hOEIDEService  as handle     no-undo.

define {&STAT} variable cProcName                   as character  no-undo initial "adecomm/oeideservice.p":U.


/* ********************  Preprocessor Definitions  ******************** */

&GLOBAL-DEFINE VIEW_ACTIVATE 1
&GLOBAL-DEFINE VIEW_VISIBLE  2
&GLOBAL-DEFINE VIEW_CREATE   3


/* **********************  Forward Declarations  ********************** */

&IF DEFINED(OEIDE-EXCLUDE-PROTOTYPES) = 0 &THEN

function activateWindow returns logical 
         (phWindow as handle) in hOEIDEService.

function checkSyntaxInIde returns logical 
    ( phWindow as handle) in hOEIDEService.

function runUIBCommand returns logical 
    ( phWindow as handle, 
      pcCommand as char)       
      in hOEIDEService.

function runDialog returns logical 
    ( phWindow as handle, 
      pcDialogCommand as char)       
      in hOEIDEService.

function checkHelp returns logical
         (pcContextId as character )  
         in hOEIDEService.

function showHelp returns logical
         (pcContextId as character )  
         in hOEIDEService.
 
function showView returns logical 
         (viewId      as character,
          secondaryId as character,
          mode        as integer)
         in hOEIDEService.

function hideView returns logical 
         (viewId      as character,
          secondaryId as character)
         in hOEIDEService.
         
function setViewTitle returns logical 
         (viewId      as character,
          secondaryId as character,
          viewTitle   as character)
         in hOEIDEService.         

function displayEmbeddedWindow returns logical 
         (viewId      as character,
          secondaryId as character,
          hWindow     as handle)
         in hOEIDEService.

function setEmbeddedWindow returns logical 
         (viewId      as character,
          secondaryId as character,
          hWindow     as handle)
         in hOEIDEService.
         
function getProjectName returns character 
         ()
         in hOEIDEService.
         
function getProjectDisplayName returns character 
         ()
         in hOEIDEService.
         
function gotoPage returns logical
         (phWindow as handle,
          piPage as int) 
          in hOEIDEService.
          
function keyPressed returns logical 
    ( phWindow as handle,
      pcKey    as character) 
      in hOEIDEService.
      
function openEditor returns logical
         (cProjectName  as character,
          cFileName     as character,
          cLinkedFile   as character,
          hWindowHandle as handle)
         in hOEIDEService.

function openDesignEditor returns logical 
         (projectName  as character,
          fileName     as character)
          in hOEIDEService.        
               
function openTextEditor returns logical 
          (cProjectName  as character,
           cFileName     as character )  
           in hOEIDEService.             
              
function openDynamicsEditor returns logical 
          (cProjectName  as character,
           cFileName     as character)  
           in hOEIDEService.      

function openPropertySheet returns logical 
          (windowHandle  as handle)  
           in hOEIDEService.     
               
/* deprecated - use viewSourceTrigger or viewSourceSection */
function viewSource returns logical 
    ( phWindow as handle,
      wName AS CHARACTER,
      wType AS CHARACTER,
      wSection AS CHARACTER,
      wTrigger AS CHARACTER) in hOEIDEService.

function viewSourceTrigger returns logical 
    ( phWindow as handle,
      pEvent as character,
      pName as character,
      pType as character,
      pLabel as character,
      pParent as character) in hOEIDEService.

function viewSourceSection returns logical 
    ( phWindow as handle,
      pSection AS CHARACTER) in hOEIDEService.

function saveEditor returns logical 
         (projectName   as character,
          fileName      as character,
          ask_file_name as logical)
         in hOEIDEService.         

function closeEditor returns logical 
         (projectName  as character,
          fileName     as character,
          saveChanges  as logical)
         in hOEIDEService.         

function findAndSelect returns logical 
         (projectName  as character,
          fileName     as character,
          cText        as character,
          activateEditor as logical)
         in hOEIDEService.         

function createLinkedFile returns character 
         (user_chars   as character,
          extension    as character)
         in hOEIDEService. 

function ShowMessageInIDE returns logical
         (msgText      as character,
          MsgType      as character,
          MsgTitle     as character, 
          MsgButtons   as character,
          ButtonValue  as logical) 
          in hOEIDEService. 
          
 
function ShowOkMessageInIDE returns logical
         (msgText      as character,
          MsgType      as character,
          MsgTitle     as character ) 
          in hOEIDEService.      
                 
function SetWindowSize return logical
         (phwin as handle )
          in hOEIDEService.   

function WidgetEvent return logical
         (phwindow   as handle,
          WidgetName as character,
          WidgetText as character,
          WidgetType as character,
          WidgetParent as character,
          WidgetAction as character ) in hOEIDEService. 
              
function AddCodeSection return logical
         (phwindow   as handle,
          AddSection as character) in hOEIDEService.  
          
function AddTrigger return logical
         (phwindow   as handle,
          WidgetName as character,
          WidgetText as character,
          WidgetType as character,
          WidgetParent as character) in hOEIDEService.    
          
function RunDesign return logical
         (phwindow   as handle) in hOEIDEService.    
         
function CompileDesign return logical
         (phwindow   as handle) in hOEIDEService.  
         
function RenameWidget return logical
         (phwindow   as handle,
          WidgetOldName as character,
          WidgetNewName as character,
          WidgetText as character,
          WidgetType as character,
          WidgetParent as character,
          WidgetAction as character ) in hOEIDEService.   

function ShowCueCard return logical
         (CueCardTitle as character,
          CueCardMessage as character) in hOEIDEService.   

function OpenDBConnectionDialog return logical
         (pmessage as character) in hOEIDEService.          
                           
&ENDIF

&IF DEFINED(OEIDE-EXCLUDE-UTILITIES) = 0 &THEN
    
function OEIDE_CanLaunchDialog returns logical
         ( ):         
    define variable plOk as logical no-undo.
    if valid-handle(hOEIDEService) then 
        run CanLaunchDialog in hOEIDEService(output plOk).
    return plOk.
end function.

function OEIDE_CanShowMessage returns logical
         ( ):         
    define variable plOk as logical no-undo.
    if valid-handle(hOEIDEService) then 
        run CanShowMessage in hOEIDEService(output plOk).
    return plOk.
end function.


&ENDIF
                           
 
/* ***************************  Main Block  *************************** */
{&METHOD}
OEIDEIsRunning = if OS-GETENV("OEA_PORT":U) > "" then true else false.
if OEIDEIsRunning and not VALID-HANDLE(hOEIDEService) then
do:
    /* Check to see if OEIDEService is already running */
    hOEIDEService = session:first-procedure.
    do while VALID-HANDLE(hOEIDEService) 
         and hOEIDEService:FILE-NAME <> cProcName:
       hOEIDEService = hOEIDEService:NEXT-SIBLING.
    end.
    if not VALID-HANDLE(hOEIDEService) then
        run VALUE(cProcName) persistent set hOEIDEService.
end.
{&METHOD-END}

&ENDIF

