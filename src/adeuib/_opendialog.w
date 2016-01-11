&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*********************************************************************
* Copyright (C) 2012 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : _opendialog.w
    Purpose     : Open Object Dialog for repository objects.

    Syntax      : 

    Input Parameters:
      phWindow            : Window in which to display the dialog box.
      gcProductModule     : Initial Product Module Code.
      glOpenInAppBuilder  : Open in Appbuilder
      pcTitle             : Title for Dialog Window to be launched

    Output Parameters:
      gcFileName          : The filename selected.
      pressedOK           : TRUE if user successfully choose an object file name.

    Description: from cntnrdlg.w - ADM2 SmartDialog Template

    History     :
                  05/24/2002     Updated By           Don Bulua
                  - IZ 2433, Added search on filename with timer, 
                  - Greatly improved query when 'Display Repostiory Data' set to yes.
                  - Modifed batch rows from 20 to 100
                  - IZ:4571 - restuctured adm calls
                  - Added most recent used combo-box displaying filename and description
                  - Save MRU and column sizes as user profiles
                  - Added verification for existence of static files. 
           
    
                  02/25/2002      Updated by          Ross Hunter
                  Allow the reading of Dynamic Viewers (DynView)

                  11/20/2001      Updated by          John Palazzo (jep)
                  IZ 3195 Description missing from PM list.
                  Fix: Added description to PM list: "code // description".

                  09/30/2001      Updated by          John Palazzo (jep)
                  IZ 2009 Objects the AB can't open are in dialog.
                  Fix: Filter the Object Type combo query and the
                  SDO query with preprocessor gcOpenObjectTypes, which
                  lists the object type codes that the AB knows to open.

                  09/30/2001      Updated by          John Palazzo (jep)
                  IZ 1940 Long delay in Open Object dialog browser.
                  Fix: Changed rows-to-batch instance property for SDO
                  to 20 (was 200).
                  
                  08/16/2001      created by          Yongjian Gu
                  
                  04/12/2001      Update By           Peter Judge
                  IZ3130: Change delimiter in combos from comma to CHR(3)
                  to avoid issue with non-American numeric formats.
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

create widget-pool.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
define input  parameter phWindow           as handle no-undo.
define input  parameter gcProductModule    as character no-undo.
define input  parameter glOpenInAppBuilder as logical    no-undo.
define input  parameter pcTitle            as character  no-undo.
define output parameter gcFilename         as character no-undo.
 define output parameter pressedOK          as logical.

/* Local Variable Definitions ---                                       */
/*{af/sup2/afglobals.i} 8/19 */
define variable gcOriginalWhere            as character initial "". 
/*DEFINE VARIABLE fiFileName                 AS CHARACTER INITIAL "". */

/* A list of object types to filter on */
define variable gcObjectFilterTypes as character  no-undo.

define variable ghRyObject          as handle no-undo. 

{src/adm2/ttcombo.i}
 
procedure SendMessageA external "user32" :
  define input  parameter hwnd        as LONG.
  define input  parameter umsg        as LONG.
  define input  parameter wparam      as LONG.
  define input  parameter lparam      as LONG.
  define return parameter ReturnValue as LONG.
end procedure.

define variable ghRepositoryDesignManager as handle     no-undo.
define variable gcOpenObjectTypes         as character  no-undo.
define variable gcsort                    as character  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiFileName Btn_Cancel fiObject ~
coProductModule coObjectType coCombo RECT-1 
&Scoped-Define DISPLAYED-OBJECTS fiFileName fiObject coProductModule ~
coObjectType coCombo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRDMHandle gDialog 
function getRDMHandle returns logical
  ( /* parameter-definitions */ )  forward.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSort gDialog 
function setSort returns logical
  ( pcField  as character)  forward.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
define variable h_bopendialog as handle no-undo.
define variable h_dopendialog as handle no-undo.
define variable ipTitle       as character  no-undo init "Open Object".
/* Definitions of the field level widgets                               */
define button Btn_Cancel auto-end-key 
     label "Cancel" 
     size 15 by 1.05.

define button Btn_OK 
     label "&Open" 
     size 15 by 1.05.

define variable coCombo as character format "X(256)":U 
     view-as combo-box inner-lines 10
     drop-down-list
     size 85 by 1 no-undo.

define variable coObjectType as decimal format "->>>>>>>>>>>>>>>>>>>>9.999999999":U initial 0 
     label "Type" 
     view-as combo-box inner-lines 12
     list-item-pairs "x",0
     drop-down-list
     size 73 by 1 no-undo.

define variable coProductModule as decimal format "-999999999999999999999.999999999":U initial 0 
     label "Module" 
     view-as combo-box inner-lines 10
     list-item-pairs "x",0
     drop-down-list
     size 73 by 1 no-undo.

define variable fiChar as character format "X(256)":U 
     view-as fill-in 
     size .2 by .91
     bgcolor 7 fgcolor 7  no-undo.

define variable fiFileName as character format "x(70)":U 
     label "Object filename" 
     view-as fill-in native 
     size 81.4 by 1 no-undo.

define variable fiObject as character format "X(256)":U 
     view-as fill-in 
     size 38 by 1 no-undo.

define rectangle RECT-1
     edge-pixels 2 graphic-edge  no-fill 
     size 123 by 2.95.


/* ************************  Frame Definitions  *********************** */

define frame gDialog
     fiFileName at row 14.57 col 4.2
     Btn_OK at row 14.57 col 110
     Btn_Cancel at row 15.81 col 110
     fiObject at row 2.91 col 1 colon-aligned no-label
     coProductModule at row 1.71 col 49 colon-aligned
     fiChar at row 14.57 col 99.2 colon-aligned no-label no-tab-stop 
     coObjectType at row 2.91 col 49 colon-aligned
     coCombo at row 14.57 col 18 colon-aligned no-label no-tab-stop 
     RECT-1 at row 1.29 col 2
     "Filter:" view-as text
          size 5.4 by .62 at row 1 col 3.6
     "Object filename:" view-as text
          size 18.6 by .62 at row 2.1 col 3.4
     space(103.79) skip(14.27)
    with
    &if DEFINED(IDE-IS-RUNNING) = 0 &then
    view-as dialog-box 
    title ipTitle
    &else
    no-box
    &endif
    keep-tab-order 
    side-labels 
    no-underline 
    three-d  
    scrollable 
    default-button Btn_OK cancel-button Btn_Cancel.
 
/*&if DEFINED(IDE-IS-RUNNING) <> 0 &then                                                         */
/*    define variable dialogService as adeuib.idialogservice no-undo.                            */
/*    Run CreateDialogService in hOEIDEService (FRAME {&FRAME-NAME}:handle,output dialogService).*/
/*&endif                                                                                         */
   

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */
 
{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   NOT-VISIBLE Custom                                                   */
assign 
       frame gDialog:SCROLLABLE       = false
       frame gDialog:HIDDEN           = true.

/* SETTINGS FOR BUTTON Btn_OK IN FRAME gDialog
   NO-ENABLE                                                            */
assign 
       coObjectType:hidden in frame gDialog           = true.

/* SETTINGS FOR FILL-IN fiChar IN FRAME gDialog
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fiFileName IN FRAME gDialog
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
on go of frame gDialog /* Open Object */
do:
    apply 'CHOOSE' to Btn_OK.   /* go to search the object file */
   
    if gcFileName = ? then  return no-apply.   /* if no such a file, do not close the dialog */
   
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
on window-close of frame gDialog /* Open Object */
do:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */ 
  run setMRULIST ("","").
  apply "END-ERROR":U to self.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel gDialog
on choose of Btn_Cancel in frame gDialog /* Cancel */
do:
  assign gcFileName = ?               /* these values are by default, just reaffirm it. */
         pressedOK = no.
  run setMRULIST ("","").
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
on choose of Btn_OK in frame gDialog /* Open */
do:
  run OpenObject (fiFilename:screen-value in frame {&FRAME-NAME}).
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coCombo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coCombo gDialog
on value-changed of coCombo in frame gDialog
do:
   assign fiFileName:screen-value = self:SCREEN-VALUE
          Btn_OK:sensitive        = true.
   
   apply "VALUE-CHANGED":U to fiFilename.
   if last-event:label <> "CURSOR-UP":U 
        and last-event:label <> "CURSOR-DOWN":U then 
     apply "ENTRY":U to fiFileName.
     
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coObjectType gDialog
on value-changed of coObjectType in frame gDialog /* Type */
do:
  run updateBrowserContents.    /* update contents in the browser according to 
                                   the newly-changed object type. */
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule gDialog
on entry of coProductModule in frame gDialog /* Module */
do:
  /* ASSIGN gcSavedModule = SELF:SCREEN-VALUE.*/
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule gDialog
on value-changed of coProductModule in frame gDialog /* Module */
do:
  run updateBrowserContents.  /* update contents in the browser according to 
                                 the newly-changed Product Module. */
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFileName gDialog
on cursor-down of fiFileName in frame gDialog /* Object filename */
do:
  run applyKey in h_bopenDialog ("CURSORDOWN":U).
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFileName gDialog
on cursor-up of fiFileName in frame gDialog /* Object filename */
do:
  run applyKey in h_bopenDialog ("CURSORUP":U).
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFileName gDialog
on F4 of fiFileName in frame gDialog /* Object filename */
do:
  define variable iretval as integer no-undo.
 &GLOBAL-DEFINE CB_SHOWDROPDOWN 335
 
 run SendMessageA (input  CoCombo:hwnd,
                          {&CB_SHOWDROPDOWN},
                          1,   /* True */
                          0,
                   output iretval
                   )  no-error .
 apply "ENTRY":U to coCombo.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFileName gDialog
on PAGE-DOWN of fiFileName in frame gDialog /* Object filename */
do:
  run applyKey in h_bopenDialog ("PAGEDOWN":U).
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFileName gDialog
on PAGE-UP of fiFileName in frame gDialog /* Object filename */
do:
  run applyKey in h_bopenDialog ("PAGEUP":U).
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFileName gDialog
on value-changed of fiFileName in frame gDialog /* Object filename */
do:
  assign coCombo:screen-value = self:SCREEN-VALUE NO-ERROR.
       
   if lookup(self:SCREEN-VALUE,coCombo:list-item-pairs,chr(3)) = 0 then
        coCombo:screen-value = entry(2,coCombo:list-item-pairs,chr(3)).
   if self:SCREEN-VALUE = "" then
      Btn_OK:sensitive = false.
   else
      Btn_OK:sensitive = true.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObject gDialog
on value-changed of fiObject in frame gDialog
do:
  define variable cValue as character  no-undo.
  &SCOPED-DEFINE TIMER-INTERVAL 500
  
  do while true:
    if cValue <> self:SCREEN-VALUE then
    do:
      etime(true).
      cValue = self:SCREEN-VALUE.
    end.
    process events.
    
    if etime >= {&TIMER-INTERVAL} then do:

      run updateBrowserContents.  /* update contents in the browser */
      assign self:CURSOR-OFFSET = MAX(1,length(self:SCREEN-VALUE) + 1) NO-ERROR.
      leave.
    end.
  end.
  
 
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */
 
/*{src/adm2/dialogmn.i}*/
if this-procedure:persistent then do:
    message "The " + this-procedure:file-name + " procedure is not intended to be run " + CHR(10) + 
            "Persistent or to be placed in another ":U + CHR(10) +
            "SmartObject at AppBuilder design time."
            view-as alert-box error.
    run disable_UI.
    delete procedure this-procedure.
    return.
end.

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
  &if DEFINED(IDE-IS-RUNNING) = 0  &then
if valid-handle(active-window) and frame {&FRAME-NAME}:PARENT eq ?
then frame {&FRAME-NAME}:PARENT = active-window.
   &endif
   
run createObjects.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
do on error   undo MAIN-BLOCK, leave MAIN-BLOCK
   on end-key undo MAIN-BLOCK, leave MAIN-BLOCK:
  run initializeObject.
  &if DEFINED(IDE-IS-RUNNING) = 0  &then
  wait-for go of frame {&FRAME-NAME} {&FOCUS-Phrase}.
  &ELSE
  /* u2 of frame because we set dialogservide.CancelEventNum = 2.  This cuases U2 to be applied to frame on 
     Cancel from Eclipse  */
  wait-for go of frame {&FRAME-NAME} or "u2" of frame {&FRAME-NAME} {&FOCUS-Phrase}.       
/*  if cancelDialog THEN UNDO, LEAVE.*/
  &endif
end.


run destroyObject.


/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  run initializeObject.
&ENDIF



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
procedure adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  define variable currentPage  as integer no-undo.

  assign currentPage = getCurrentPage().

  case currentPage: 

    when 0 then do:
       run constructObject (
             input  'ry/obj/dopendialog.wDB-AWARE':U ,
             input  frame gDialog:HANDLE ,
             input  'AppServiceAstraASUsePromptASInfoForeignFieldsRowsToBatch50CheckCurrentChangedyesRebuildOnReposyesServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamedopendialogUpdateFromSourcenoToggleDataTargetsyesOpenOnInitnoPromptOnDeleteyesPromptColumns(NONE)':U ,
             output h_dopendialog ).
       run repositionObject in h_dopendialog ( 1.48 , 24.00 ) no-error.
       /* Size in AB:  ( 2.38 , 18.00 ) */

       run constructObject (
             input  'ry/obj/bopendialog.w':U ,
             input  frame gDialog:HANDLE ,
             input  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesDataSourceNamesUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             output h_bopendialog ).
       run repositionObject in h_bopendialog ( 4.33 , 2.00 ) no-error.
       run resizeObject in h_bopendialog ( 10.00 , 123.00 ) no-error.

       /* Links to SmartDataBrowser h_bopendialog. */
       run addLink ( h_dopendialog , 'Data':U , h_bopendialog ).
       run addLink ( h_bopendialog , 'F2Pressed':U , this-procedure ).
       run addLink ( h_bopendialog , 'updateFileName':U , this-procedure ).

       /* Adjust the tab order of the smart objects. */
       run adjustTabOrder ( h_bopendialog ,
             fiObject:handle , 'AFTER':U ).
    end. /* Page 0 */

  end case.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject gDialog 
procedure destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if valid-handle(ghRyObject) then
        run destroyObject in ghRyObject no-error.
    run super.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
procedure disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  hide frame gDialog.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
procedure enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  display fiFileName fiObject coProductModule coObjectType coCombo 
      with frame gDialog.
  enable fiFileName Btn_Cancel fiObject coProductModule coObjectType coCombo 
         RECT-1 
      with frame gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE F2Pressed gDialog 
procedure F2Pressed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

apply 'CHOOSE' to Btn_OK in frame {&FRAME-NAME}.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
procedure initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    define variable rRowid              as rowid      no-undo.
    define variable cProfileData        as character  no-undo.
    define variable iCols               as integer    no-undo.

    /* Parent the dialog-box to the specified window. */
     &if DEFINED(IDE-IS-RUNNING) = 0 &then
    if valid-handle(phWindow) then
        assign frame {&FRAME-NAME}:PARENT = phWindow.
    &else
    define variable dialogService as adeuib.idialogservice no-undo.
    run CreateDialogService in hOEIDEService (frame {&FRAME-NAME}:handle,output dialogService).
    &endif
    
    /* override the SDO default dehavoir, don't run query and populate SBO after initializing
     * SDO. It is because we want to do query based on information passed-in, in addition to 
     * SDO's original. Waiting until we specifically order it to do by calling openQuery(). */
    dynamic-function('setOpenOnInit' in h_dopendialog, no).  

    /* Change combo delimiter to avoid numeric format issues, particularly
     * with non-American formats.                                         */
    assign coProductModule:delimiter in frame {&FRAME-NAME} = chr(3)
           coObjectType:delimiter    in frame {&FRAME-NAME} = chr(3)
           coCombo:delimiter in frame {&FRAME-NAME}         = chr(3). 
    
    {set HideOnInit YES h_bopendialog}.
    {set HideOnInit YES }.
    {set popupActive NO h_bopendialog}.
    
    run SUPER.
    
    assign
        gcOpenObjectTypes = dynamic-function("getObjectTypes":U in h_dopendialog)
        rRowid            = ?.

    run getProfileData in gshProfileManager ( input        "General":U,
                                              input        "DispRepos":U,
                                              input        "ObjectMRU":U,
                                              input        no,
                                              input-output rRowid,
                                              output       cProfileData).
    assign coCombo:list-item-pairs  = entry(1,cProfileData,chr(4)) NO-ERROR.
    if num-entries(cProfileData,chr(4)) >= 2 then
    do:
       if valid-handle(h_bopendialog) then
          DYNAMIC-FUNC("setColumnWidth":U in h_bopendialog, entry(2,cProfileData,chr(4))).
    end.
  
    run populateCombos. /* populate combos */
    if num-entries(cProfileData,chr(4)) >= 3 then
       assign coProductModule:screen-value = entry(3,cProfileData,chr(4)) NO-ERROR.

    run showBrowser.    /* construct new query and ask SDO to openQuery(),
                         * show result in the SmartDataBrowser */
                         
                        
    if pcTitle = "" or pcTitle = ? then
        pcTitle = "Open Object".
    &if DEFINED(IDE-IS-RUNNING) = 0  &then
    frame {&FRAME-NAME}:TITLE =  pcTitle.
    &endif
                                 
    run viewObject.
    
   &if DEFINED(IDE-IS-RUNNING) <> 0 &then
    define variable lCancel as logical no-undo.
    dialogService:SizeTofit().
    dialogService:View().
    /* use eventnum to cancel - see wait-for  */
    dialogService:CancelEventNum = 2. 
    /* probably do not need this anymore when using CancelEventNum, but*/
    dialogService:SetOkButton(btn_OK:handle in frame {&FRAME-NAME}).
    dialogService:SetCancelButton(btn_Cancel:handle in frame {&FRAME-NAME}).
    dialogService:title = ipTitle.
   &endif    
   
    coCombo:MOVE-TO-BOTTOM().
    if glOpenInAppBuilder then
    do:
        run adeuib/_ryobject.p persistent set ghRyObject.
        run setDataSource in ghRyObject(h_dopendialog).
    end.
end procedure.    /* end procedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenObject gDialog 
procedure OpenObject :
/*------------------------------------------------------------------------------
  Purpose:   Opens an object in the AppBuilder
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 define input  parameter cFileName as character  no-undo.
 
 define variable currentProductModule        as character  no-undo.
 define variable cObjectDesc                 as character  no-undo.
 define variable cQueryPosition              as character  no-undo.
 define variable cFullFileName               as character  no-undo.
 define variable cPath                       as character  no-undo.
 define variable cExtension                  as character  no-undo.

do with frame {&FRAME-NAME}:
  assign coObjectType coProductModule.
  
  if (cFileName <> "" and cFileName <> ?) then    /* only do the search when there is a filename string */
  do:
     DYNAMIC-FUNC('assignQuerySelection':U in h_dopendialog,'object_filename':U,cFileName,'EQ':U).
    
    /* open the new query  */
     dynamic-function('openQuery':U in h_dopendialog).
    
    {get QueryPosition cQueryPosition h_dopendialog}. /* any data? */
    if cQueryPosition = 'NoRecordAvailable':U then 
    do:
        message substitute("The Object file  '&1' cannot be found in the repository.",cFileName) skip
                "Please verify that the correct file name, product module, and type were specified."
        view-as alert-box information buttons ok. 
  
        
        
        /* Reset the query based on filter settings */
        run UpdateBrowserContents in this-procedure.
        
        assign gcFileName = ?             /* reaffirm output values */
               pressedOK = no.
    end. /* Available */
    else do:
       /* Check whether static object exists */
       if dynamic-function("ColumnStringValue":U in h_dopendialog,"Static_object":U) = "YES":U or
          DYNAMIC-FUNCTION("ColumnStringValue":U in h_dopendialog,"Static_object":U) = "TRUE":U then
       do:
         assign
           cPath         = dynamic-function("ColumnStringValue":U in h_dopendialog,"object_path":U)
           cExtension    = dynamic-function("ColumnStringValue":U in h_dopendialog,"object_extension":U)
           cPath         = trim(cPath) + if cPath = "" then "" else "/":U
           cFullFileName = search (cPath + cFileName + (if cExtension > "" then "." + cExtension else ""))
           NO-ERROR.
          if cFullFileName = ? then /* Could not find static object */
          do:
            assign
              cPath         = dynamic-function("ColumnStringValue":U in h_dopendialog,"relative_path":U)
              cPath         = trim(cPath) + if cPath = "" then "" else "/":U
              cFullFileName = search (cPath + cFileName + (if cExtension > "" then "." + cExtension else ""))
              NO-ERROR.
            if cFullFileName = ? then /* Could not find static object */
            do:
               message substitute("The static file '&1' cannot be found in your Propath.",
                                  cPath + cFileName + if num-entries(cFileName,".") > 1 then "" else "." + TRIM(cExtension) ) skip
                 "Please verify the location of this file."
               view-as alert-box information buttons ok. 
               
               /* Reset the query */
               run UpdateBrowserContents in this-procedure.
               assign gcFileName = ?             /* reaffirm output values */
                      pressedOK = no.
               return no-apply.
            end.
          end.
       end.
       assign cObjectDesc    = trim(dynamic-function("ColumnStringValue":U in h_dopendialog,"object_description":U)) 
              gcFileName     = string(cFileName)    /* assign valid outputs, GO to close the dialog */
              pressedOK      = yes.
       /* Create the _RyObject record to be later used by AppBuilder to copy data to _P. */
       if glOpenInAppBuilder then
       do on error undo, throw:
           run createRyObject in ghRyObject.
           /* Update the current product module for the user, unles it's "<All>".
              Repository API session super procedure handles this call. */
           assign currentProductModule =
               entry(lookup(" " + coProductModule:screen-value, coProductModule:list-item-pairs) - 1, coProductModule:list-item-pairs) NO-ERROR.
           getRDMHandle().
           if (currentProductModule <> "<All>":u) and (currentProductModule <> "") and VALID-HANDLE(ghRepositoryDesignManager) then
               dynamic-function("setCurrentProductModule":u in ghRepositoryDesignManager, currentProductModule) no-error.
           run setMRUList in THIS-PROCEDURE (trim(cFileName), cObjectDesc).
           catch e as Progress.Lang.Error :
           		
           end catch.
       end.
       apply 'GO':U to frame {&FRAME-NAME}. 
    end. /* valid filename found */
  end. /* search if filename string */
  else do:                    /* doing nothing because there is no object filename to search. */
     assign gcFileName = ?             /* reaffirm output values */
            pressedOK = no.
     return no-apply.       
  end.
end.      /* DO WITH {&FRAME-NAME} */
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombos gDialog 
procedure populateCombos :
/*------------------------------------------------------------------------------
  Purpose:    populate combo-boxes: Product Module and Object Type,
              based on the information from the repository.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define variable cWhere                      as character                no-undo.        
    define variable cField                      as character                no-undo.  
    define variable moduleEntry                 as integer                  no-undo.
    define variable typeName                    as integer                  no-undo.
    define variable iModuleCount                as integer                  no-undo.
    define variable cWhereClause                as character                no-undo.
    define variable cEntry                      as character                no-undo.
    define variable i                           as integer                  no-undo.
    define variable hProcedure                  as handle                   no-undo.
    
    
    do with frame {&FRAME-NAME}:
        empty temp-table ttComboData.

        create ttComboData.
        assign ttComboData.cWidgetName        = "coObjectType":U
               ttComboData.cWidgetType        = "decimal":U
               ttComboData.hWidget            = coObjectType:handle
               ttComboData.cForEach           = "FOR EACH gsc_object_type WHERE CAN-DO('" + gcOpenObjectTypes + "', gsc_object_type.object_type_code) NO-LOCK BY gsc_object_type.object_type_code":U
               ttComboData.cBufferList        = "gsc_object_type":U
               ttComboData.cKeyFieldName      = "gsc_object_type.object_type_obj":U
               ttComboData.cDescFieldNames    = "gsc_object_type.object_type_description, gsc_object_type.object_type_code":U 
               ttComboData.cDescSubstitute    = "&2  (&1)":U
               ttComboData.cFlag              = "A":U
               ttComboData.cCurrentKeyValue   = "":U
               ttComboData.cListItemDelimiter = coObjectType:delimiter
               ttComboData.cListItemPairs     = "":U
               ttComboData.cCurrentDescValue  = "":U
               .

        /* Refine query of object types if calling procedure contains procedure OpenObjectFilter */
        if phWindow:private-data > "" then do:
           hProcedure = widget-handle(phWindow:private-data) no-error.

           if valid-handle(hProcedure) and LOOKUP("getOpenObjectFilter":U,hProcedure:internal-entries) > 0  then
           do:
              gcObjectFilterTypes = dynamic-function("getOpenObjectFilter":U in hProcedure).
              if gcObjectFilterTypes > "" then
                 assign  ttComboData.cForEach  = "FOR EACH gsc_object_type WHERE CAN-DO('" 
                                                 + gcObjectFilterTypes + "'" 
                                                 + " , gsc_object_type.object_type_code) NO-LOCK BY gsc_object_type.object_type_code":U
                         ttComboData.cFlag     = if num-entries(gcObjectFilterTypes) <= 1 then "" else "A".
           end.
           
           if valid-handle(hProcedure) and LOOKUP("getInitialFileName":U,hProcedure:internal-entries) > 0  then
           do:
              assign fiObject:screen-value = dynamic-function("getInitialFileName":U in hProcedure).
           end.
        end.


        /* IZ 3195 cDescFieldNames has both code and description with // seperator in cDescSubstitute. */
        create ttComboData.
        assign ttComboData.cWidgetName        = "coProductModule":U
               ttComboData.cWidgetType        = "decimal":U
               ttComboData.hWidget            = coProductModule:handle
               ttComboData.cBufferList        = "gsc_product_module":U
               ttComboData.cKeyFieldName      = "gsc_product_module.product_module_obj":U
               ttComboData.cDescFieldNames    = "gsc_product_module.product_module_code,gsc_product_module.product_module_description":U
               ttComboData.cDescSubstitute    = "&1 // &2":U
               ttComboData.cFlag              = "A":U
               ttComboData.cCurrentKeyValue   = "":U
               ttComboData.cListItemDelimiter = coProductModule:delimiter
               ttComboData.cListItemPairs     = "":U
               ttComboData.cCurrentDescValue  = "":U
               ttComboData.cForEach           = "FOR EACH gsc_product_module NO-LOCK":U
                                              + "   WHERE [&FilterList=|&EntityList=GSCPM] BY gsc_product_module.product_module_code":U.

        /* build combo list-item pairs */
        run af/app/afcobuildp.p on gshAstraAppserver (input-output TABLE ttComboData).

        /* and set-up object type combo */
        find first ttComboData where ttComboData.cWidgetName = "coObjectType":U.
        assign coObjectType:list-item-pairs in frame {&FRAME-NAME} = ttComboData.cListItemPairs.

        /* Select 1st entry */
        if coObjectType:num-items > 0 then
        do:
            assign cEntry = coObjectType:ENTRY(1) NO-ERROR.
            if cEntry <> ? and not error-status:error then
                assign coObjectType:screen-value = cEntry NO-ERROR.
            else
                /* blank the combo */
                assign coObjectType:list-item-pairs = coObjectType:list-item-pairs.
        end.

        /* and set-up product module combo */
        find first ttComboData where ttComboData.cWidgetName = "coProductModule":U.
        assign coProductModule:list-item-pairs in frame {&FRAME-NAME} = ttComboData.cListItemPairs.

        /* If no product module passed in, try using the user's current product module.
         * This value comes from the Repository API session super-procedure. */
        getRDMHandle().
        if (gcProductModule = ? or gcProductModule = "") and VALID-HANDLE(ghRepositoryDesignManager) then
            assign gcProductModule = dynamic-function("getCurrentProductModule":u in ghRepositoryDesignManager) NO-ERROR.

        /* display the product module passed in */
        if (gcProductModule <> ? and gcProductModule <> "") then
        do:
            /* Because we take list-item-pairs, for each combo drop-down list pair, the first is the description,
             * and the second is the value. gcProductModule (product_module_code // product_module_description)
             * is the description. Look it up in the temple table string list first, then halve the size,
             * which should be its pair location in the drop-down list. Then we retrieve the value, which
             * should be gsc_product_module.product_module_obj, assign the value to the combo. */
            assign moduleEntry = lookup(gcProductModule, coProductModule:list-item-pairs)
                   moduleEntry = integer((moduleEntry + 1) / 2)
                   cEntry      = coProductModule:ENTRY(moduleEntry)
                   NO-ERROR.
            if cEntry <> ? and not error-status:error then
            do:
                assign coProductModule:screen-value = cEntry NO-ERROR.
                assign coProductModule.
            end.
        end.
        /* else take the 1st entry, which should not be the case normally, because a valid 
         * gcProductModule should always be passed-in in order to run the dialog box. */
        else
        do:
            if coProductModule:num-items > 0 then
            do:
                assign cEntry = coProductModule:ENTRY(1) NO-ERROR.
                if cEntry <> ? and not error-status:error then
                do:
                    assign coProductModule:screen-value = cEntry NO-ERROR.
                    assign coProductModule.
                end.
                else
                    /* blank the combo */
                    assign coProductModule:list-item-pairs = coProductModule:list-item-pairs.            
            end.
        end. /* IF gcProductModule */
    end. /* {&FRAME-NAME} */

    return.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setMRUList gDialog 
procedure setMRUList :
/*------------------------------------------------------------------------------
  Purpose:     Adds the most recently opened file to the User profile data
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input  parameter pcObjectName as character  no-undo.
define input  parameter pcObjectDesc as character  no-undo.

define variable iPos         as integer    no-undo.
define variable cListItems   as character  no-undo.
define variable cProfileData as character  no-undo.
define variable cNewProfile  as character  no-undo.

/* Maximum number of Most recent items to store and display in combo-box */
&SCOPED-DEFINE MAX_MRU_ITEMS 15

assign cListitems = coCombo:list-item-pairs in frame {&FRAME-NAME}.


/* If the object is already in the list, put the object at the top of the list */
if pcObjectName > "" then
   cProfileData = pcObjectName + FILL(" ":u, MAX(2,integer((150 - font-table:get-text-width-p(pcObjectName)) / 3)))
                               + pcObjectDesc + CHR(3) + pcObjectName.
/*   cProfileData = pcObjectName + "  /  ":U + pcObjectDesc + CHR(3) + pcObjectName.*/

if cListItems > "" then
do:
  do ipos = 2 to MIN({&MAX_MRU_ITEMS} * 2,num-entries(cListItems,chr(3))) by 2:
     if entry(iPos,cListItems,chr(3)) = pcObjectName then
       next.
     else
       cProfileData = cProfileData + (if cProfileData = "" then "" else chr(3))
                          + ENTRY(iPos - 1,cListItems,chr(3)) + CHR(3) + ENTRY(iPos,cListItems,chr(3)).
  end.
  /* Ensure the profile data doesn't have more than the maximum number of items allowed */
  if num-entries(cProfileData,chr(3)) >  {&MAX_MRU_ITEMS} * 2 then
  do:
    do iPos = 1 to {&MAX_MRU_ITEMS} * 2:
       cNewProfile = cNewProfile + (if cNewProfile = "" then "" else chr(3)) 
                        + ENTRY(iPos,cProfileData,chr(3)).
    end.
    assign cProfileData =  cNewProfile.
  end.
end.
if valid-handle(h_bopendialog) then
   cprofileData = cProfileData + CHR(4) + DYNAMIC-FUNC("getColumnWidth":U in h_bopendialog)
                               + CHR(4) + coProductModule:screen-value .

run setProfileData in gshProfileManager (input "General":U,        /* Profile type code */
                                         input "DispRepos":U,  /* Profile code */
                                         input "ObjectMRU",     /* Profile data key */
                                         input ?,                 /* Rowid of profile data */
                                         input cProfileData,      /* Profile data value */
                                         input no,                /* Delete flag */
                                         input "PER":u).          /* Save flag (permanent) */

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showBrowser gDialog 
procedure showBrowser :
/*------------------------------------------------------------------------------
  Purpose:     show result records of the query in the browser
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Force a the product module to populate the browse. */
    apply "VALUE-CHANGED":U to coProductModule in frame {&FRAME-NAME}.

    return.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateBrowserContents gDialog 
procedure updateBrowserContents :
/*------------------------------------------------------------------------------
  Purpose:     when a value in Product Module or Object Type combo-boxes changes, 
               update the object files listed in the bowser based on the new criteria.
  Parameters:  <none>
  Notes:       If the preferences are set to exclude the display of repository objects, the
               query will be slowed down as it will be constructed using an OR connstuct for
               each product module allowed. Otherwise, he query will be constructed here based 
               on the selected product module, object type, and the object filename filter.
------------------------------------------------------------------------------*/
    define variable cFilterSetClause  as character  no-undo.
    define variable cFilterSetCode    as character  no-undo.
    define variable cObjects          as character  no-undo.
    define variable cWhere            as character  no-undo.        
    define variable iComboCount       as integer    no-undo.

    do with frame {&FRAME-NAME}:
       assign coProductModule coObjectType fiFileName.

       dynamic-function("setQueryWhere":U in h_dopendialog,"").
       if gcObjectFilterTypes > "" and coObjectType eq 0 then
       do:
          do iComboCount = 1 to num-entries(gcObjectFilterTypes):
             assign cWhere = cWhere + (if cWhere = "":U then "":U else " OR ":U)
                     + " gsc_object_type.object_type_code = '":U + ENTRY(iComboCount,gcObjectFilterTypes) + "' ":U.
          end.         
          dynamic-function('addQueryWhere':U in h_dopendialog, input cWhere,?,?).
       end.
       else do:
         if coObjectType ne 0 then
            dynamic-function('assignQuerySelection':U in h_dopendialog,'object_type_obj':U,coObjectType,'EQ':U).
         else do:
            cObjects = dynamic-function("getObjectTypes":U in h_dopendialog).
            dynamic-function('addQueryWhere':U in h_dopendialog, input "LOOKUP(gsc_object_type.object_type_code, '" + cObjects + "') > 0",?,?).  
         end.
       end.

       /* Get the FilterSet for the Session */
       run getFilterSetClause in gshGenManager (input-output cFilterSetCode,    /* FilterSetCode        */
                                                input        "GSCPM,RYCSO":U,   /* EntityList           */
                                                input        "":U,              /* BufferList           */
                                                input        "":U,              /* AdditionalParameters */
                                                output       cFilterSetClause). /* FilterSetClause      */

       if fiObject:screen-value > "" then
         DYNAMIC-FUNC('assignQuerySelection':U in h_dopendialog,'object_filename':U,fiObject:screen-value,'BEGINS':U).
       else
         DYNAMIC-FUNC('removeQuerySelection':U in h_dopendialog,'object_filename':U,'BEGINS':U).

       if coProductModule ne 0 then
       do:
          dynamic-function('assignQuerySelection':U in h_dopendialog, 'product_module_obj':U, coProductModule,       'EQ':U).
          dynamic-function('addQueryWhere':U        in h_dopendialog, cFilterSetClause,      'gsc_product_module':U, 'AND':U).
       end.
       else
         dynamic-function('addQueryWhere':U in h_dopendialog, cFilterSetClause, 'gsc_product_module':U, 'AND':U).

       if gcSort > "" then
          dynamic-function("setQuerySort":U in  h_dopendialog, gcSort).
       dynamic-function('openQuery' in h_dopendialog).        
    end.  /* end {&FRAME-NAME} */

    return.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateFileName gDialog 
procedure updateFileName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter newFileName as character no-undo.
 
if newFilename > "" then
do:

  fiFileName = newFileName.

  display fiFileName with frame {&FRAME-NAME}.

  apply "VALUE-CHANGED":U to fiFilename.
  assign fiFileName:cursor-offset = length(fiFileName:screen-value) + 1.
end.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRDMHandle gDialog 
function getRDMHandle returns logical
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  assign ghRepositoryDesignManager = dynamic-function("getManagerHandle":U, input "RepositoryDesignManager":U).

  return true.   /* Function return value. */

end function.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSort gDialog 
function setSort returns logical
  ( pcField  as character) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gcsort = pcField.
  return true.   /* Function return value. */

end function.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

