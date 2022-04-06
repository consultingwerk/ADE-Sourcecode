&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
/* Procedure Description
"This is the Dynamic Container. No new instances of this should be created."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" wWin _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" wWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" wWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rydyncontw.w

  Description:  Astra 2 Dynamic Container
  
  Purpose:      Astra 2 Dynamic Container

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   101000006   UserRef:    
                Date:   08/01/2001  Author:     Peter Judge

  Update Notes: Changed calls to getObjectAttributes in the Repository Manager, and the way
                that the attribute value lists are determined. This change was needed because
                of the changes necessary for the Dynamic Viewer.

  (v:010001)    Task:    90000149   UserRef:    
                Date:   24/05/2001  Author:     Bruce Gruenbaum

  Update Notes: Apply entry to first page of window

  (v:010002)    Task:        6194   UserRef:    
                Date:   28/06/2000  Author:     Robin Roos

  Update Notes: Window title field for data vis objects

  (v:010003)    Task:        6205   UserRef:    
                Date:   30/06/2000  Author:     Robin Roos

  Update Notes: Dynamic Viewer

  (v:010004)    Task:        6236   UserRef:    
                Date:   05/07/2000  Author:     Jenny Bond

  Update Notes: Implement Window Position & Sizes

  (v:010005)    Task:        6405   UserRef:    9.1B
                Date:   02/08/2000  Author:     Anthony Swindells

  Update Notes: Rename Astra 2 objectname property to AstraObjectName to avoid conflict with
                new 9.1B property for objectname that is the object name without an extension
                or path for use as a prefix for example with sdo's in a sbo.
                Also check new session properties for launched container via protools.

  (v:010006)    Task:        6462   UserRef:    
                Date:   14/08/2000  Author:     Jenny Bond

  Update Notes: When positioning window, ensure not off screen entirely.  If so, position in
                centre of screen.

  (v:010007)    Task:        6498   UserRef:    
                Date:   17/08/2000  Author:     Jenny Bond

  Update Notes: Refine window pos & size

  (v:010008)    Task:        6517   UserRef:    
                Date:   23/08/2000  Author:     Jenny Bond

  Update Notes: Fix problems with height not exactly right.

  (v:010009)    Task:        6812   UserRef:    
                Date:   05/10/2000  Author:     Anthony Swindells

  Update Notes: Fix Astra2 nav buttons sensitivity when running object controller to object
                controller. Also fix switch from view to modify mode when nav buttons are
                pressed on a folder.

  (v:010011)    Task:        7024   UserRef:    
                Date:   09/11/2000  Author:     Chris Koster

  Update Notes: Extending FolderPage Enable / Disable Functionsble Functions

  (v:010012)    Task:        7415   UserRef:    
                Date:   28/12/2000  Author:     Anthony Swindells

  Update Notes: Fix issues with European format decimals

  (v:010013)    Task:        7419   UserRef:    
                Date:   28/12/2000  Author:     Anthony Swindells

  Update Notes: Fix European format issues

  (v:010014)    Task:        7452   UserRef:    
                Date:   03/01/2001  Author:     Anthony Swindells

  Update Notes: fix instantiation order

  (v:010015)    Task:        7538   UserRef:    
                Date:   09/01/2001  Author:     Anthony Swindells

  Update Notes: Fix icons

  (v:010016)    Task:        7487   UserRef:    
                Date:   10/01/2001  Author:     Anthony Swindells

  Update Notes: Fix issues with multi-pages and folder wizard.
                Order of instantiation by page then sequence with sdos first, then toolbars,
                then other objects

  (v:010017)    Task:        7694   UserRef:    
                Date:   24/01/2001  Author:     Anthony Swindells

  Update Notes: support more layouts

  (v:010018)    Task:        7737   UserRef:    
                Date:   29/01/2001  Author:     Anthony Swindells

  Update Notes: Change ESC exit hook to first ask a question if windows open.

  (v:010019)    Task:        8171   UserRef:    
                Date:   16/03/2001  Author:     Chris Koster

  Update Notes: Adding Visit TreeView

  (v:010020)    Task:        8722   UserRef:    
                Date:   14/05/2001  Author:     Anthony Swindells

  Update Notes: implement forced exit functionality. If window private-data is set to
                forcedexit, then exit the folder at end of initializeobject. The reason for the
                exit could also be set in the private-data of the window, seperated by a chr(3)
                from the forced exit text.
 
 
  (v:010021)    Issue:      1663   UserRef:    
                Date:   10/10/2001  Author:     Don Bulua
 Update Notes: Adding Calculation of relativePages. Modified createpages to
               calculate pages that are dependent on current page

  (v:010022)    Task:           0   UserRef:    
                Date:   01/24/2002  Author:     Mark Davies (MIP)

  Update Notes: Removed this 'PROCESS EVENTS' statement in initializeObject due to Issue #3333 and #3641 loged on issuezilla

-----------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydyncontw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra 2 object identifying preprocessor */
&glob   astra2-dynamiccontainer YES

/* tell smart.i that we can use the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gcLaunchLogicalObject   AS CHARACTER        NO-UNDO.
DEFINE VARIABLE gcLaunchRunAttribute    AS CHARACTER        NO-UNDO.
DEFINE VARIABLE gcValueList             AS CHARACTER        NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 68.2 BY 9.81.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Dynamic Object Controller"
         HEIGHT             = 9.81
         WIDTH              = 68.2
         MAX-HEIGHT         = 34.33
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 34.33
         VIRTUAL-WIDTH      = 204.8
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fMain
   NOT-VISIBLE FRAME-NAME                                               */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Dynamic Object Controller */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE
DO:
    RUN windowEndError IN TARGET-PROCEDURE NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
        RETURN NO-APPLY.
    
    APPLY "CLOSE":U TO TARGET-PROCEDURE. /* ensure close down nicely */

    /* Add the return no-apply so that the entire application doesn't shut down. */
    IF TARGET-PROCEDURE:PERSISTENT THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Dynamic Object Controller */
DO:
    /* This ADM code must be left here in order for the SmartWindow
     * and its descendents to terminate properly on exit. */
    APPLY "CLOSE":U TO TARGET-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-MINIMIZED OF wWin /* Dynamic Object Controller */
DO:
    RUN windowMinimized IN TARGET-PROCEDURE NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-RESIZED OF wWin /* Dynamic Object Controller */
DO:
    RUN resizeWindow IN TARGET-PROCEDURE NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE iStartPage AS INTEGER NO-UNDO.
 
IF VALID-HANDLE({&WINDOW-NAME}) THEN
DO:
    /* Window Container Specific Stuff */
    RUN start-super-proc IN TARGET-PROCEDURE ("ry/app/rydynwindp.p":U).   

    ASSIGN CURRENT-WINDOW                    = {&WINDOW-NAME} 
           {&WINDOW-NAME}:KEEP-FRAME-Z-ORDER = YES
           TARGET-PROCEDURE:CURRENT-WINDOW   = {&WINDOW-NAME}
           .
  /* The CLOSE event can be used from inside or outside the procedure to  */
  /* terminate it.                                                        */
  ON CLOSE OF TARGET-PROCEDURE
  DO:
     RUN destroyObject IN TARGET-PROCEDURE NO-ERROR.
     IF ERROR-STATUS:ERROR OR RETURN-VALUE = 'adm-error' THEN
       RETURN NO-APPLY.
  END.

  /* This will bring up all the links of the current object */
  ON CTRL-ALT-SHIFT-HOME ANYWHERE
  DO:
      RUN displayLinks IN TARGET-PROCEDURE.
  END.      

  /* By default, Make sure current-window is always the window with focus. */
  /* To get the old behavior, simply define OldCurrentWindowFocus.    */
  &IF DEFINED(OldCurrentWindowFocus) = 0 &THEN    /* if not defined */
    ON ENTRY OF {&WINDOW-NAME} DO:
      ASSIGN CURRENT-WINDOW = SELF NO-ERROR.
    END.
  &ENDIF

  /* Execute this code only if not being run PERSISTENT, i.e., if in test mode
   of one kind or another or if this is a Main Window. Otherwise postpone 
   'initialize' until told to do so. */

  &IF DEFINED(UIB_IS_RUNNING) EQ 0 &THEN
  IF NOT TARGET-PROCEDURE:PERSISTENT THEN
  DO:
  &ENDIF
    /* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
    MAIN-BLOCK:
    DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
       ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
 
    /* Now enable the interface and wait for the exit condition.            */
        IF NOT TARGET-PROCEDURE:PERSISTENT THEN
        DO: 
            
            ASSIGN
              gcLaunchLogicalObject = "":U
              gcLaunchRunAttribute = "":U
              .
            
            /* the logical object name is presumed to be the first entry of 
               session param, and the run attribute is the second (if present) */
            IF SESSION:PARAM <> "":U THEN
            DO:
              ASSIGN
                gcLaunchLogicalObject = TRIM(ENTRY(1,SESSION:PARAMETER)).
              IF NUM-ENTRIES(SESSION:PARAMETER) >= 2 THEN
                ASSIGN
                  gcLaunchRunAttribute = TRIM(ENTRY(2,SESSION:PARAMETER)).                
            END.
            ELSE
            DO:
              /* Try and get launch logical object and run attribute from
                 session properties instead
              */
                ASSIGN gcValueList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                      INPUT "launchlogicalobject,launchrunattribute":U,
                                                      INPUT YES).
                ASSIGN
                gcLaunchLogicalObject = TRIM(ENTRY(1,gcValueList, CHR(3)))
                gcLaunchRunAttribute = TRIM(ENTRY(2,gcValueList, CHR(3)))
                .
            END.
            
            IF gcLaunchLogicalObject = "" THEN
            DO:
                MESSAGE "Cannot launch a dynamic object since SESSION:PARAMETER and/or the launchlogicalobject property does not contain a Logical Object Name.".
                RETURN.
            END.
               
            {set LogicalObjectName gcLaunchLogicalObject}.
            IF gcLaunchRunAttribute <> "":U THEN 
              {set RunAttribute gcLaunchRunAttribute}.    
        END.
        RUN initializeObject IN TARGET-PROCEDURE.
       
        IF NOT TARGET-PROCEDURE:PERSISTENT THEN
           WAIT-FOR CLOSE OF TARGET-PROCEDURE.
    END.
  &IF DEFINED(UIB_IS_RUNNING) EQ 0 &THEN
  END. /* IF NOT TARGET-PROCEDURE:PERSISTENT THEN */
  &ENDIF

END. /* IF VALID-HANDLE({&WINDOW-NAME}) */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doThisOnceOnly wWin 
PROCEDURE doThisOnceOnly :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       * This procedure is here because doThisOnceOnly is not part of the ADM
                 procedures and is thus not 'visible' from the INTERNAL-ENTRIES
                 attribute. This API is needed so that doThisOnceOnly will happen for 
                 dynamic containers.
------------------------------------------------------------------------------*/
    IF NOT {fn getObjectsCreated} THEN
        RUN createObjects IN TARGET-PROCEDURE.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* doThisOnceOnly */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  {&OPEN-BROWSERS-IN-QUERY-fMain}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/
    APPLY "CLOSE":U TO TARGET-PROCEDURE.
END PROCEDURE.  /* exitObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hWindow                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cErrorMessage           AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cButton                 AS CHARACTER                NO-UNDO.

    /* This is to in the .W to ensure that if there is stuff in a custom super procedure
     * that it will run. This is because the custom super procedure will execute BEFORE
     * any of the super procedures associated with this container window, rydywindp.p and
     * rydynframp.p.                                                                      */
    IF NOT {fn getObjectsCreated} THEN
    DO:
        RUN createObjects IN TARGET-PROCEDURE.

        /* The container handle will always be a window.
         * Check the error status because the window may already have been
         * shut down.                                                     */
        {get ContainerHandle hWindow} NO-ERROR.

        /* Check forced exit of the dynamic container. We may get window packing errors here. */
        IF NOT VALID-HANDLE(hWindow)                                    OR
            (VALID-HANDLE(hWindow)                                      AND
             LENGTH(hWindow:PRIVATE-DATA)            GT 0               AND
             ENTRY(1, hWindow:PRIVATE-DATA, CHR(3))  EQ "ForcedExit":U) THEN
        DO:
            /* Select Page in rydynframp.p might have shown this message already */
            IF NOT VALID-HANDLE(hWindow) OR (VALID-HANDLE(hWindow) AND LOOKUP("MessageShown-YES":U, hWindow:PRIVATE-DATA, CHR(3)) = 0) THEN
            DO:
                IF VALID-HANDLE(hWindow) AND NUM-ENTRIES(hWindow:PRIVATE-DATA, CHR(3)) GE 2 THEN
                    ASSIGN cErrorMessage = ENTRY(2, hWindow:PRIVATE-DATA, CHR(3)).

                IF cErrorMessage EQ "":U OR cErrorMessage EQ ? THEN
                    ASSIGN cErrorMessage = "Program aborted due to unknown reason":U.

                RUN showMessages IN gshSessionManager ( INPUT  cErrorMessage,           /* message to display */
                                                        INPUT  "ERR":U,                 /* error type */
                                                        INPUT  "&OK":U,                 /* button list */
                                                        INPUT  "&OK":U,                 /* default button */
                                                        INPUT  "&OK":U,                 /* cancel button */
                                                        INPUT  "Error on folder window creation":U, /* error window title */
                                                        INPUT  YES,                     /* display if empty */
                                                        INPUT  TARGET-PROCEDURE,        /* container handle */
                                                        OUTPUT cButton               ). /* button pressed */
            END.

            RUN destroyObject IN TARGET-PROCEDURE.
            RETURN.
        END.    /* forced exit */
    END.    /* Objects not already created. */

    /* The super will not run if there has been a forced exit. */
    RUN SUPER.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE manualInitializeObjects wWin 
PROCEDURE manualInitializeObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       * This procedure is here because manualInitializeObjects is not part of the ADM
                 procedures and is thus not 'visible' from the INTERNAL-ENTRIES
                 attribute. This API is needed so that manualInitializeObjects will happen for 
                 dynamic containers.
------------------------------------------------------------------------------*/
    RUN SUPER.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* manualInitializeObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject wWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Resize procedure.
  Parameters:  pdHeight -
               pcWidth  -
  Notes:       * This procedure is here because resizeObject is not part of the ADM
                 procedures and is thus not 'visible' from the INTERNAL-ENTRIES
                 attribute. This API is needed so that resizing will happen for 
                 dynamic containers.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdHeight             AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdWidth              AS DECIMAL              NO-UNDO.
    
    /* We don't check for errors because there will be many cases where
     * there is no resizeObject for the viewer. In this cse, simply ignore 
     * any errors.                                                         */
    RUN SUPER (INPUT pdHeight, INPUT pdWidth) NO-ERROR.
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resizeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

