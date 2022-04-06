&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/  
/* Copyright (c) 1984-2006 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: rydyncontp.p

  Description:  Dynamic Container/Frame Super Procudure

  Purpose:      Dynamic Container/Frame Super Procudure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    3136
                Date:   01/29/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydynwindp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Tell *attr.i that this is the Super procedure. */
&SCOP ADMSuper rydynwindp.p

/* object identifying preprocessor */
&glob   AstraProcedure    yes

/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }

DEFINE VARIABLE ghLayoutManager         AS HANDLE                   NO-UNDO.

/* These are kept for backwards compatibilty. */
DEFINE NEW GLOBAL SHARED VARIABLE gshLayoutManager      AS HANDLE.
DEFINE NEW GLOBAL SHARED VARIABLE gshLayoutManagerID    AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-childWindowsOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD childWindowsOpen Procedure 
FUNCTION childWindowsOpen RETURNS LOGICAL ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutManagerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLayoutManagerHandle Procedure 
FUNCTION getLayoutManagerHandle RETURNS HANDLE
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionMinWindowHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSessionMinWindowHeight Procedure 
FUNCTION getSessionMinWindowHeight RETURNS DECIMAL
    ( INPUT plMenuController        AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionMinWindowWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSessionMinWindowWidth Procedure 
FUNCTION getSessionMinWindowWidth RETURNS DECIMAL
    ( INPUT plMenuController        AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lockContainingWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lockContainingWindow Procedure 
FUNCTION lockContainingWindow RETURNS LOGICAL
    ( INPUT plLockWindow            AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareInitialWindowSize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareInitialWindowSize Procedure 
FUNCTION prepareInitialWindowSize RETURNS LOGICAL
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateMenuWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateMenuWidth Procedure 
FUNCTION updateMenuWidth RETURNS LOGICAL
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 29.81
         WIDTH              = 73.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/cntnprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
ASSIGN ghLayoutManager = DYNAMIC-FUNCTION("getLayoutManagerHandle":U IN TARGET-PROCEDURE).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-createObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects Procedure 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE VARIABLE iCurrentPage                 AS INTEGER            NO-UNDO.
    DEFINE VARIABLE dHeight                      AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE dWidth                       AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE lObjectsCreated              AS LOGICAL            NO-UNDO.
    DEFINE VARIABLE hWindow                      AS HANDLE             NO-UNDO.
    DEFINE VARIABLE cErrorMessage                AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE cButton                      AS CHARACTER          NO-UNDO.
    
    /* If on page 0, set the window's minimum height/width etc.
       Also pack the window as per page 0. This should give us minimum
       size in cases where there are static objects on the container.
     */
    &SCOPED-DEFINE xp-assign
    {get ObjectsCreated lObjectsCreated}
    {get CurrentPage iCurrentPage}.
    &UNDEFINE xp-assign
    
    IF iCurrentPage EQ 0 AND NOT lObjectsCreated THEN
        /* This function gets the initial sizes from the user profiles etc.*/
        {fn prepareInitialWindowSize}.
    
    RUN SUPER.

    {get ContainerHandle hWindow} NO-ERROR.

    /* Check forced exit of the dynamic container. This is checked after the RUN SUPER in case the instantiation of the
       objects on the frame fail.
     */
    IF LENGTH(hWindow:PRIVATE-DATA)         GT 0              AND
       ENTRY(1,hWindow:PRIVATE-DATA,CHR(3)) EQ "ForcedExit":U THEN
    DO:
        IF NUM-ENTRIES(hWindow:PRIVATE-DATA,CHR(3)) EQ 2 THEN
            ASSIGN cErrorMessage = ENTRY(2,hWindow:PRIVATE-DATA,CHR(3)).
        ELSE 
            ASSIGN cErrorMessage = "Program aborted due to unknown reason.":U.
        
        RUN showMessages IN gshSessionManager ( INPUT  cErrorMessage,            /* message to display */
                                                INPUT  "ERR":U,                  /* error type */
                                                INPUT  "&OK":U,                  /* button list */
                                                INPUT  "&OK":U,                  /* default button */ 
                                                INPUT  "&OK":U,                  /* cancel button */
                                                INPUT  "Error on window initialization":U,  /* error window title */
                                                INPUT  YES,                      /* display if empty */ 
                                                INPUT  TARGET-PROCEDURE,           /* container handle */ 
                                                OUTPUT cButton                   /* button pressed */       ).
        RUN destroyObject IN TARGET-PROCEDURE.
        RETURN.
    END.    /* forced exit */    
    
END PROCEDURE.    /* createObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:        
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.

    /* If close window - give chance to abort this if windows open. If a property
       has been set not to prompt, then don't. This can be used in cases (like the 
       container builder) where windows are hidden instead of closed to improve 
       performance. All child windows will still be closed, but the prompt will 
       not be made. 
       
     - It is too late to ask this question if this is published from the 
       container as destroyObject cannot be stopped from subscriber. 
       The question should also already have been asked and answered yes. */  
    {get ContainerSource hContainerSource}.
    IF SOURCE-PROCEDURE <> hContainerSource 
    AND {fnarg getUserProperty '"promptForChildWindows"'} NE "NO":U 
    AND {fn childWindowsOpen}                                       THEN
    DO:
        RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'RY' '20'},
                                               INPUT  "QUE":U,
                                               INPUT  "&Yes,&No":U,
                                               INPUT  "&YES":U,
                                               INPUT  "&No":U,
                                               INPUT  "Close Window",
                                               INPUT  YES,
                                               INPUT  ?,
                                               OUTPUT cButton).

        IF cButton EQ "&No":U OR cButton EQ "No":U THEN
            RETURN ERROR "ADM-ERROR":U.        
    END.    /* child windows are open. */
       
    RUN SUPER NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE = "ADM-ERROR":U THEN
        RETURN ERROR "ADM-ERROR":U.
    
    /* Don't clear the error-status.  Super may raise it to inform we shouldn't destroy */
END PROCEDURE.  /* destroyObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cErrorMessage               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cButton                     AS CHARACTER            NO-UNDO.        
    DEFINE VARIABLE hWindow                     AS HANDLE               NO-UNDO.
    
    /* If the obejcts are not yet initialised, initializeObject in the
     * super - rydynframp.p - will create them.                         */
    RUN SUPER.
    
    {get ContainerHandle hWindow} NO-ERROR.
    
    &if '{&OPSYS}' = 'Win32' &then
    /* This causes the window to be REALIZED, and therefor prevents the setting of the STATUS-AREA property. It
     * was subsequently moved from MAIN BLOCK to after RUN SUPER to allow the setting of the attributes first. */
    {aficonload.i &WINDOW-NAME=hWindow}
    &endif
    
    /* Check forced exit of the dynamic container. This is checked after the RUN SUPER in case the instantiation of the
       objects on the frame fail.
     */
    IF LENGTH(hWindow:PRIVATE-DATA)         GT 0              AND
       ENTRY(1,hWindow:PRIVATE-DATA,CHR(3)) EQ "ForcedExit":U THEN
    DO:
        IF NUM-ENTRIES(hWindow:PRIVATE-DATA,CHR(3)) EQ 2 THEN
            ASSIGN cErrorMessage = ENTRY(2,hWindow:PRIVATE-DATA,CHR(3)).
        ELSE 
            ASSIGN cErrorMessage = "Program aborted due to unknown reason.":U.
        
        RUN showMessages IN gshSessionManager ( INPUT  cErrorMessage,            /* message to display */
                                                INPUT  "ERR":U,                  /* error type */
                                                INPUT  "&OK":U,                  /* button list */
                                                INPUT  "&OK":U,                  /* default button */ 
                                                INPUT  "&OK":U,                  /* cancel button */
                                                INPUT  "Error on window initialization":U,  /* error window title */
                                                INPUT  YES,                      /* display if empty */ 
                                                INPUT  TARGET-PROCEDURE,           /* container handle */ 
                                                OUTPUT cButton                   /* button pressed */       ).
        RUN destroyObject IN TARGET-PROCEDURE.
        RETURN.
    END.    /* forced exit */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-packWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packWindow Procedure 
PROCEDURE packWindow :
/*------------------------------------------------------------------------------
  Purpose:     To work out new minimum window dimensions according to contents
  Parameters:  input current page number
               input resize flag
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piPage           AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAMETER plResize         AS LOGICAL                  NO-UNDO.

    DEFINE VARIABLE cLayoutCode         AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE hWindow             AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hDefaultFrame       AS HANDLE                       NO-UNDO.
    
    &SCOPED-DEFINE xp-assign
    {get Page0LayoutManager cLayoutCode}
    {get ContainerHandle hWindow}
    {get WindowFrameHandle hDefaultFrame}.
    &UNDEFINE xp-assign
    
    /* If a contained frame calls the window repack routine (which it will do whenever a new page is
       initialised) then a null value is passed into this procedure. The dimensionSomething procedure
       figures out that a DynFrame is being packed, and determines which pack should be packed.
     */
    IF piPage EQ ? THEN
        {get CurrentPage piPage}.
    
    IF NOT VALID-HANDLE(ghLayoutManager) THEN
        ASSIGN ghLayoutManager = {fn getLayoutManagerHandle}.
    
    IF VALID-HANDLE(ghLayoutManager) THEN
        RUN packWindowFromSuper IN ghLayoutManager ( INPUT piPage,
                                                     INPUT cLayoutCode,
                                                     INPUT 0,   /*pdInstanceId*/
                                                     INPUT ?,     /* hObjectBuffer */
                                                     INPUT ?,     /* hPageBuffer */
                                                     INPUT hWindow,
                                                     INPUT hDefaultFrame,
                                                     INPUT hWindow:MIN-WIDTH-CHARS,
                                                     INPUT hWindow:MIN-HEIGHT-CHARS,
                                                     INPUT hWindow:MAX-WIDTH-CHARS,
                                                     INPUT hWindow:MAX-HEIGHT-CHARS,
                                                     INPUT plResize,
                                                     INPUT TARGET-PROCEDURE           ) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR (IF NOT (RETURN-VALUE = "":U OR RETURN-VALUE = ?) THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1)).
      
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* packWindow */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerModifyMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContainerModifyMode Procedure 
PROCEDURE setContainerModifyMode :
/*------------------------------------------------------------------------------
  Purpose:     Force whole container into modify mode - including header/detail
               windows where they have many toolbars.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hHandle                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cToolbarHandles             AS CHARACTER            NO-UNDO.
    
    /** For this container window */
    ASSIGN cToolbarHandles = DYNAMIC-FUNCTION("getToolbarHandles":U IN TARGET-PROCEDURE) NO-ERROR.
    DO iLoop = 1 TO NUM-ENTRIES(cToolbarHandles):
        ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, cToolbarHandles)).
        PUBLISH "updateMode" FROM hHandle (INPUT "Enable":U).
    END.    /* loop nthrough handles */

    /* For any contained DynFrames */
    PUBLISH "setContainerModifyMode":U FROM TARGET-PROCEDURE.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* setContainerModifyMode */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerViewMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContainerViewMode Procedure 
PROCEDURE setContainerViewMode :
/*------------------------------------------------------------------------------
  Purpose:     Force whole container intio view mode - including header/detail
               windows where they have many toolbars.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hHandle                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cToolbarHandles             AS CHARACTER            NO-UNDO.

    /** For this container window */
    ASSIGN cToolbarHandles = DYNAMIC-FUNCTION("getToolbarHandles":U IN TARGET-PROCEDURE) NO-ERROR.
    DO iLoop = 1 TO NUM-ENTRIES(cToolbarHandles):
        ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, cToolbarHandles)).
        PUBLISH "updateMode" FROM hHandle ("View":U).
    END.    /* loop nthrough handles */

    /* For any contained DynFrames */
    PUBLISH "setContainerViewMode":U FROM TARGET-PROCEDURE.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* setContainerViewMode */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-windowEndError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE windowEndError Procedure 
PROCEDURE windowEndError :
/*------------------------------------------------------------------------------
  Purpose:     First on the END-ERROR or ENDKEY events on the dynamics window.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cButton                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cAnswer                 AS CHARACTER                NO-UNDO.

    /* If ESC pressed on 1st window, application will exit - give chance to 
     * abort this if windows open                                           */
    IF NOT TARGET-PROCEDURE:PERSISTENT AND 
       DYNAMIC-FUNCTION("childWindowsOpen":U IN TARGET-PROCEDURE) THEN
    DO:        
        RUN askQuestion IN gshSessionManager ( INPUT        "There are child windows open - continue with exit of application?",
                                               INPUT        "&Yes,&No":U,     /* button list */
                                               INPUT        "&Yes":U,         /* default */
                                               INPUT        "&No":U,          /* cancel */
                                               INPUT        "Exit Application":U, /* title */
                                               INPUT        "":U,             /* datatype */
                                               INPUT        "":U,             /* format */
                                               INPUT-OUTPUT cAnswer,   /* answer */
                                                     OUTPUT cButton          /* button pressed */ ).
        IF cButton = "&No":U OR cButton = "No":U THEN
            RETURN ERROR "ADM-ERROR":U.
    END.    /* child windows open on a non-persistent procedure. */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* windowEndError */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-windowMinimized) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE windowMinimized Procedure 
PROCEDURE windowMinimized :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* One of the preferences in security control is whether siblings are minimised with a parent. *
     * If the user doesn't want this, we just RETURN NO-APPLY.  This will suppress the standard    *
     * 4GL behaviour, which is to minimise the sibling windows as well.                            */
    IF DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                        INPUT "minimiseSiblings":U,
                        INPUT YES                                   ) = "NO":U THEN
        RETURN ERROR "ADM-ERROR":U.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* windowMinimized */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-childWindowsOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION childWindowsOpen Procedure 
FUNCTION childWindowsOpen RETURNS LOGICAL ( ) :
/*------------------------------------------------------------------------------
  Purpose: to check if child windows open from this window - use to give warning
           when closing window with X or ESC 
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iLoop                   AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cTargets                AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE hHandle                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE lChildren               AS LOGICAL                  NO-UNDO.

    {get ContainerTarget cTargets}.

    ASSIGN lChildren  = NO.

    TARGET-LOOP:
    DO iLoop = 1 TO NUM-ENTRIES(cTargets) WHILE lChildren EQ NO:
        ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, cTargets)) NO-ERROR.

        IF VALID-HANDLE(hHandle) 
        AND {fn getContainerType hHandle} EQ "Window":U
        THEN DO:
            /* If we can find a function called closeChildWindow, call it to determine whether the container *
             * needs to be included in this check or not.                                                    */
            IF LOOKUP("closeChildWindow":U, hHandle:INTERNAL-ENTRIES) = 0 THEN
                ASSIGN lChildren = YES.
            ELSE
                ASSIGN lChildren = DYNAMIC-FUNCTION("closeChildWindow":U IN hHandle).
        END.
    END.    /* TARGET-LOOP: */

    RETURN lChildren.
END FUNCTION.   /* childWindowsOpen */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutManagerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLayoutManagerHandle Procedure 
FUNCTION getLayoutManagerHandle RETURNS HANDLE
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retrieves the handle to the layout manager.
    Notes:  * This code uses 3 methods to determine the handle, including the
              shared global vars whicha re used for backwards compatibility.
              (1) Check for the LayoutManager specified in the icfconfig.xml file
              (2) Check the value of the global shared variable
              (3) Search the proceduretry
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hLayoutManager          AS HANDLE                   NO-UNDO.

    ASSIGN hLayoutManager = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE, INPUT "LayoutManager":U).

    IF NOT VALID-HANDLE(hLayoutManager) THEN
    DO:
        IF NOT VALID-HANDLE(gshLayoutManager) OR gshLayoutManager:UNIQUE-ID <> gshLayoutManagerID THEN 
        DO: 
            RUN ry/prc/rylayoutsp.p PERSISTENT SET gshLayoutManager.
            IF VALID-HANDLE(gshLayoutManager) THEN
                ASSIGN gshLayoutManagerID = gshLayoutManager:UNIQUE-ID.
        END.
    END.

    IF NOT VALID-HANDLE(hLayoutManager) THEN
    DO:
        ASSIGN hLayoutManager = SESSION:FIRST-PROCEDURE.

        DO WHILE VALID-HANDLE(hLayoutManager) AND NOT hLayoutManager:FILE-NAME BEGINS "ry/prc/rylayoutsp.":U:
            ASSIGN hLayoutManager = hLayoutManager:NEXT-SIBLING.
        END.    /* procedure walking */

        IF NOT VALID-HANDLE(hLayoutManager) THEN
            RUN ry/prc/rylayoutsp.p PERSISTENT SET hLayoutManager.
    END.    /* not valid layout manager. */

    IF VALID-HANDLE(hLayoutManager) THEN
        ASSIGN gshLayoutManager   = hLayoutManager
               gshLayoutManagerID = hLayoutManager:UNIQUE-ID.

    RETURN hLayoutManager.
END FUNCTION.   /* getLayoutManagerHandle */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionMinWindowHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSessionMinWindowHeight Procedure 
FUNCTION getSessionMinWindowHeight RETURNS DECIMAL
    ( INPUT plMenuController        AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the mimimum Height in characters that a window should be in  
            Dynamics.
    Notes:  * This excludes menu controller windows (those that inherit from DynMenc).
            * An override to this procedure can be put in a container's super procedure.    
------------------------------------------------------------------------------*/
    DEFINE variable dMinHeight                as decimal            no-undo.
    
    dMinHeight = super(plMenuController) no-error.

    if dMinHeight eq ? or dMinHeight eq 0 then
    do:
      IF plMenuController THEN
          dMinHeight = 2.38.
      ELSE
          dMinHeight = 10.14.
    end.    /* no super, or value is 0 */
    
    return dMinHeight.         
END FUNCTION.   /* getSessionMinWindowHeight */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionMinWindowWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSessionMinWindowWidth Procedure 
FUNCTION getSessionMinWindowWidth RETURNS DECIMAL
    ( INPUT plMenuController        AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the mimimum width in characters that a window should be in  
            Dynamics.
    Notes:  * This excludes menu controller windows (those that inherit from DynMenc).
            * An override to this procedure can be put in a container's super procedure.
------------------------------------------------------------------------------*/
    DEFINE variable dMinWidth            as decimal                no-undo.
    
    dMinWidth = super(plMenuController) no-error.
    
    if dMinWidth eq ? or dMinWidth eq 0 then
    do:
      IF plMenuController THEN
          dMinWidth = 84.4.
      ELSE
          dMinWidth = 81.0.
    end.    /* bad value from super call */
    
    return dMinWidth.         
END FUNCTION.   /* getSessionMinWindowWidth */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the TARGET-PROCEDURE handle.
    Notes:  * Used by the the Layout Manager when resizing a window.
------------------------------------------------------------------------------*/
    RETURN TARGET-PROCEDURE.
END FUNCTION.   /* getTargetProcedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lockContainingWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lockContainingWindow Procedure 
FUNCTION lockContainingWindow RETURNS LOGICAL
    ( INPUT plLockWindow            AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iReturnCode         AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iLockWindow         AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE hWindow             AS HANDLE                       NO-UNDO.

    ASSIGN iLockWindow = INTEGER(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, INPUT "LockWindow":U)) NO-ERROR.

    ASSIGN iLockWindow = iLockWindow + (IF plLockWindow THEN 1 ELSE -1)
           /* make sure that we are dealing with a non-zero value here. */
           iLockWindow = MAX(iLockWindow, 0)
           .
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, INPUT "LockWindow":U, INPUT STRING(iLockWindow)).

    IF plLockWindow AND iLockWindow > 1 THEN
        RETURN FALSE.

    IF NOT plLockWindow AND iLockWindow > 0 THEN
        RETURN FALSE.

    {get ContainerHandle hWindow}.

    IF plLockWindow AND hWindow:HWND EQ ? THEN
       RETURN FALSE.

    IF plLockWindow THEN
        RUN lockWindowUpdate IN gshSessionManager (INPUT hWindow:HWND, OUTPUT iReturnCode).
    ELSE
        RUN lockWindowUpdate IN gshSessionManager (INPUT 0, OUTPUT iReturnCode).

    RETURN TRUE.
END FUNCTION.   /* lockContainingWindow */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareInitialWindowSize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareInitialWindowSize Procedure 
FUNCTION prepareInitialWindowSize RETURNS LOGICAL
    (  ):
/*------------------------------------------------------------------------------
  Purpose:  Sets the initial window size. This should only be called once, when
               the window is being launched.
    Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cWidth                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cHeight                     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cColumn                     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cRow                        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cProfileData                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cLogicalObjectName          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE rProfileRid                 AS ROWID                NO-UNDO.
    DEFINE VARIABLE lMenuController             AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE hWindow                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hDefaultFrame               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE lSaveWindowPos              AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lFoundSavedSize             AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE dSessionWindowMinHeight     AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dSessionWindowMinWidth      AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dSavedWidth                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dSavedHeight                AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dSavedColumn                AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dSavedRow                   AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dSessionMaxAvailHeight      AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dSessionMaxAvailWidth       AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dMinimumWindowWidth         AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dMinimumWindowHeight        AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dMaximumWindowWidth         AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dMaximumWindowHeight        AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dFrameMinHeight             AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dFrameMinWidth              AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE hContainerSource            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cObjectName                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lMaximized                  AS LOGICAL              NO-UNDO.
    
    ASSIGN lMenuController = {fnarg InstanceOf 'DynMenc'}.
    
    &SCOPED-DEFINE xp-assign
    {get ContainerHandle hWindow}
    {get LogicalObjectName cLogicalObjectName}
    {get WindowFrameHandle hDefaultFrame}.
    &UNDEFINE xp-assign
    
    /* Convert window pixel sizes into characters. Oly use the available portion of the screen
       that is not hidden by taskbars.
     */
    ASSIGN dSessionMaxAvailWidth  = SESSION:WORK-AREA-WIDTH-PIXELS  / SESSION:PIXELS-PER-COLUMN
           dSessionMaxAvailHeight = SESSION:WORK-AREA-HEIGHT-PIXELS / SESSION:PIXELS-PER-ROW.

    /* Set the frame's virtual dimensions to huge. */
    ASSIGN hDefaultFrame:SCROLLABLE     = TRUE
           hDefaultFrame:VIRTUAL-WIDTH  = SESSION:WIDTH-CHARS
           hDefaultFrame:VIRTUAL-HEIGHT = SESSION:HEIGHT-CHARS
           hDefaultFrame:WIDTH          = SESSION:WIDTH-CHARS
           hDefaultFrame:HEIGHT         = SESSION:HEIGHT-CHARS
           hDefaultFrame:SCROLLABLE     = FALSE.
    
    /* Check if there are any saved window sizes & positions. If so, then apply these.
     */
    RUN getProfileData IN gshProfileManager ( INPUT        "Window":U,
                                              INPUT        "SaveSizPos":U,
                                              INPUT        "SaveSizPos":U,
                                              INPUT        NO,
                                              INPUT-OUTPUT rProfileRid,
                                                    OUTPUT cProfileData).
    ASSIGN lSaveWindowPos = (cProfileData EQ "YES":U).
    
    /* Set this user property so that the container code knows to save these window
       sizes on shutdown.
     */
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, INPUT "SaveWindowPos":U, INPUT STRING(lSaveWindowPos)).
    
    /* Allow overrides to be set for the minimum window sizes. */
    ASSIGN dSessionWindowMinHeight = {fnarg getSessionMinWindowHeight lMenuController}
           dSessionWindowMinWidth  = {fnarg getSessionMinWindowWidth lMenuController}
           
           dMinimumWindowWidth     = dSessionWindowMinWidth
           dMinimumWindowHeight    = dSessionWindowMinHeight.
    
    IF lMenuController THEN
        ASSIGN dMaximumWindowWidth  = dSessionMaxAvailWidth /* SESSION:WIDTH-CHARS - 1 */
               dMaximumWindowHeight = dMinimumWindowHeight.
    ELSE
        ASSIGN dMaximumWindowWidth  = dSessionMaxAvailWidth   /* SESSION:WIDTH-CHARS - 1 */
               dMaximumWindowHeight = dSessionMaxAvailHeight. /* SESSION:HEIGHT-CHARS - 1 */
    
    /* Set the window minimum sizes and initial sizes to the default 
       values.
     */
    ASSIGN hWindow:MIN-WIDTH-CHARS  = dMinimumWindowWidth
           hWindow:MIN-HEIGHT-CHARS = dMinimumWindowHeight
           
           hWindow:MAX-HEIGHT-CHARS = hWindow:MIN-HEIGHT-CHARS  WHEN lMenuController
           
           hWindow:WIDTH-CHARS      = dMinimumWindowWidth
           hWindow:HEIGHT-CHARS     = dMinimumWindowHeight.
 
    /* Only get the saved sizes when necessary. */
    IF lSaveWindowPos THEN
    DO:
        ASSIGN cProfileData = "":U
               rProfileRid  = ?.

        RUN getProfileData IN gshProfileManager ( INPUT        "Window":U,              /* Profile type code                            */
                                                  INPUT        "SizePos":U,             /* Profile code                                 */
                                                  INPUT        cLogicalObjectName,      /* Profile data key                             */
                                                  INPUT        "NO":U,                  /* Get next record flag                         */
                                                  INPUT-OUTPUT rProfileRid,             /* Rowid of profile data                        */
                                                        OUTPUT cProfileData       ).    /* Found profile data. Positions as follows:    */
                                                                                        /* 1 = col,         2 = row,                    */
        IF NUM-ENTRIES(cProfileData, CHR(3)) GE 4 THEN
            ASSIGN lFoundSavedSize = YES
                   lMaximized      = NUM-ENTRIES(cProfileData, CHR(3)) GE 5 
                                     and ENTRY(5, cProfileData, CHR(3)) = "WINDOW-MAXIMIZED":U                                          
                   /* Ensure that the values have the correct decimal points. 
                    * These values are always stored using the American numeric format
                    * ie. using a "." as decimal point.                               */
                   cColumn = ENTRY(1, cProfileData, CHR(3))
                   cColumn = REPLACE(cColumn, ".":U, SESSION:NUMERIC-DECIMAL-POINT)

                   cRow = ENTRY(2, cProfileData, CHR(3))
                   cRow = REPLACE(cRow, ".":U, SESSION:NUMERIC-DECIMAL-POINT)

                   cWidth = ENTRY(3, cProfileData, CHR(3))
                   cWidth = REPLACE(cWidth, ".":U, SESSION:NUMERIC-DECIMAL-POINT)

                   cHeight = ENTRY(4, cProfileData, CHR(3))
                   cHeight = REPLACE(cHeight, ".":U, SESSION:NUMERIC-DECIMAL-POINT)

                   dSavedWidth  = DECIMAL(cWidth)
                   dSavedHeight = DECIMAL(cHeight)
                   dSavedColumn = DECIMAL(cColumn)
                   dSavedRow    = DECIMAL(cRow)                              
                   NO-ERROR.
        ELSE
        IF cProfileData EQ "WINDOW-MAXIMIZED":U THEN
            ASSIGN lMaximized      = true.
        ELSE
            ASSIGN dSavedWidth  = ?
                   dSavedHeight = ?
                   dSavedColumn = ?
                   dSavedRow    = ?.
    END.    /* Saved sizes? */
    
    IF lFoundSavedSize THEN
    DO:
       
        ASSIGN hWindow:WIDTH-CHARS         = MIN(MAX(dSavedWidth, hWindow:MIN-WIDTH-CHARS),
                                                 dSessionMaxAvailWidth)
               hWindow:HEIGHT-CHARS        = MIN(MAX(dSavedHeight, (hWindow:MIN-HEIGHT-CHARS)),
                                                 (hWindow:MAX-HEIGHT-CHARS), dSessionMaxAvailHeight)
               dSavedColumn                = IF (dSavedColumn + hWindow:WIDTH-CHARS) GE SESSION:WIDTH-CHARS THEN
                                                MAX(SESSION:WIDTH-CHARS - hWindow:WIDTH-CHARS, 1)
                                             ELSE
                                             IF dSavedColumn LT 0 THEN
                                                 1
                                             ELSE
                                                 dSavedColumn
               dSavedRow                   = IF (dSavedRow + hWindow:HEIGHT-CHARS) GE SESSION:HEIGHT-CHARS THEN
                                                MAX(SESSION:HEIGHT-CHARS - hWindow:HEIGHT-CHARS - 1.5, 1)
                                             ELSE
                                             IF dSavedRow LT 0 THEN
                                                 1
                                             ELSE
        
                                                 dSavedRow.
      
    END.

    ELSE
    IF lMenuController THEN
        ASSIGN dSavedColumn                 = 1
               dSavedRow                    = 1
               hWindow:MIN-WIDTH-CHARS      = dMinimumWindowWidth
               hWindow:MAX-WIDTH-CHARS      = dMaximumWindowWidth
               hWindow:MIN-HEIGHT-CHARS     = dMinimumWindowHeight
               hWindow:MAX-HEIGHT-CHARS     = dMaximumWindowHeight.
 
 
 
    /* Check if container source has cascade rules that requires new position*/
    &SCOPED-DEFINE xp-assign
    {get ContainerSource hContainerSource}
    {get ObjectName cObjectName}
    .
    &UNDEFINE xp-assign
    
    IF VALID-HANDLE(hContainerSource) THEN
      RUN cascadeChildPosition IN hContainerSource 
              (cLogicalObjectName,
               cObjectName,
               hWindow:HEIGHT,
               hWindow:WIDTH,
               INPUT-OUTPUT dSavedRow,
               INPUT-OUTPUT dSavedColumn).
    
     ASSIGN     
      hWindow:ROW    = dSavedRow    WHEN dSavedRow >= 1 
      hWindow:COLUMN = dSavedColumn WHEN dSavedColumn >= 1.  
    
    if lMaximized then
       hWindow:WINDOW-STATE = WINDOW-MAXIMIZED.
    RETURN TRUE.
END FUNCTION.    /* prepareInitialWindowSize */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateMenuWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateMenuWidth Procedure 
FUNCTION updateMenuWidth RETURNS LOGICAL
    (  ):
/*------------------------------------------------------------------------------
  Purpose:  Makes sure that there is enough horizontal space for all the menus 
              of a container.
    Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hWindow                 AS HANDLE                     NO-UNDO.
    DEFINE VARIABLE hMenuBar                AS HANDLE                     NO-UNDO.
    DEFINE VARIABLE hSubMenu                AS HANDLE                     NO-UNDO.
    DEFINE VARIABLE hDefaultFrame           AS HANDLE                     NO-UNDO.
    DEFINE VARIABLE iMenus                  AS INTEGER                    NO-UNDO.
    DEFINE VARIABLE dMenuControllerWidth    AS DECIMAL                    NO-UNDO.
    DEFINE VARIABLE dTextWidth              AS DECIMAL                    NO-UNDO.
    DEFINE VARIABLE dTotalTextWidth         AS DECIMAL                    NO-UNDO.
    
    &SCOPED-DEFINE xp-assign    
    {get WindowFrameHandle hDefaultFrame}
    {get ContainerHandle hWindow}.
    &UNDEFINE xp-assign
    
    /* Calculate window width and the menu width. */
    ASSIGN /*hWindow:VISIBLE = TRUE*/
           hMenuBar = hWindow:MENU-BAR
           NO-ERROR.
    
    IF VALID-HANDLE(hMenuBar) THEN
    DO:
        ASSIGN hSubMenu = hMenuBar:FIRST-CHILD.

        REPEAT WHILE VALID-HANDLE(hSubMenu):
            ASSIGN dTextWidth      = FONT-TABLE:GET-TEXT-WIDTH(REPLACE(hSubMenu:LABEL,"&":U, "":U), hSubMenu:FONT)
                   dTotalTextWidth = dTotalTextWidth + dTextWidth
                   iMenus          = iMenus + 1.            
            ASSIGN hSubMenu = hSubMenu:NEXT-SIBLING.
        END.    /* Valid sub menu handle */

        ASSIGN dMenuControllerWidth = MAX(dTotalTextWidth + (iMenus * 2.6) + 1, 1).
               dMenuControllerWidth = MAX(hWindow:MIN-WIDTH,MIN(dMenuControllerWidth, SESSION:WIDTH - 1)).
               
        IF hWindow:WIDTH LT dMenuControllerWidth THEN
            ASSIGN hDefaultFrame:SCROLLABLE    = TRUE
                   hWindow:MIN-WIDTH           = dMenuControllerWidth
                   hWindow:WIDTH               = dMenuControllerWidth
                   hDefaultFrame:VIRTUAL-WIDTH = dMenuControllerWidth
                   hDefaultFrame:WIDTH         = dMenuControllerWidth
                   hDefaultFrame:SCROLLABLE    = FALSE.
        
        IF hWindow:MIN-WIDTH LT dMenuControllerWidth THEN    
            ASSIGN hWindow:MIN-WIDTH = dMenuControllerWidth.        
    END.    /* valid menu bar */

    RETURN TRUE.
END FUNCTION.    /* updateMenuWidth */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

