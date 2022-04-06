&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
/* Procedure Description
"This Astra 2 Dynamic Toolbar should be used 
whereever toolbar or panel functionality is  
required."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" w_toolbar _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" w_toolbar _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" w_toolbar _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w_toolbar 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rydyntoolt.w

  Description:  Astra 2 Dynamic Toolbar

  Purpose:      Astra 2 Dynamic Toolbar. This is a direct replacement for the ADM2
                dynamic toolbar src/adm2/dyntoolbar.w. It has functionality built in to read
                its data from the Astra 2 repository, plus has many additional features such as
                resize capabilities, horizontal / vertical alignment, etc.
                Specific code in custom versions of action.p and toolbar.p

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   11/05/2000  Author:     Anthony Swindells

  Update Notes: Write Astra2 Toolbar

  (v:010003)    Task:        5653   UserRef:    
                Date:   05/06/2000  Author:     Robin Roos

  Update Notes: Write Astra2 Toolbar

  (v:010004)    Task:        5929   UserRef:    
                Date:   07/06/2000  Author:     Robin Roos

  Update Notes: Implement Repository Cache for Dynamic Objects

  (v:010005)    Task:        6002   UserRef:    
                Date:   12/06/2000  Author:     Robin Roos

  Update Notes: Investigate Toolbar Performance

  (v:010006)    Task:        6094   UserRef:    
                Date:   20/06/2000  Author:     Robin Roos

  Update Notes: Implement ContainerMode property

--------------------------------------------------------------------*/
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

&scop object-name       rydyntoolt.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra 2 object identifying preprocessor - this is used in toobarcustom.i to
   only launch the toolbarcustom.p super procedure if this is defined, thus
   allowing the standard toolbar supplied by Progress to continue to work
   unchanged.
*/

/* Parameters Definitions ---                                           */
&GLOBAL-DEFINE ADM-Panel-Type    Toolbar
/* tell smart.i that we can use the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE toolbar
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Navigation-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Panel-Frame

/* Custom List Definitions                                              */
/* Box-Rectangle,List-2,List-3,List-4,List-5,List-6                     */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initializeMenu w_toolbar 
FUNCTION initializeMenu RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initializeToolBar w_toolbar 
FUNCTION initializeToolBar RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Panel-Frame
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 67.2 BY 1.24.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: toolbar
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW w_toolbar ASSIGN
         HEIGHT             = 1.24
         WIDTH              = 67.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w_toolbar 
/* ************************* Included-Libraries *********************** */

{src/adm2/toolbar.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w_toolbar
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME Panel-Frame
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME Panel-Frame:SCROLLABLE       = FALSE
       FRAME Panel-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME Panel-Frame
/* Query rebuild information for FRAME Panel-Frame
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME Panel-Frame */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w_toolbar 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.        
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w_toolbar  _DEFAULT-DISABLE
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
  HIDE FRAME Panel-Frame.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getWindowName w_toolbar 
PROCEDURE getWindowName :
/**
*   @desc  Procedure to retrieve the filename of the window  (wxxxxx.w)
*   @returns <code> file-name</code> Filename of windowprocedure
*/
  DEFINE VARIABLE hWin AS HANDLE NO-UNDO.

  ASSIGN hwin =  DYNAMIC-FUNCTION('getContainerSource':U).

  RETURN hWin:file-name.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE publishEvent w_toolbar 
PROCEDURE publishEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcEventName AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcParameter AS CHARACTER NO-UNDO.

DEF VAR cLinkHandles AS CHARACTER.

cLinkHandles = DYNAMIC-FUNCTION('linkHandles':U IN TARGET-PROCEDURE, 
                                INPUT 'tableio-target':U).

IF pcParameter = ? 
    THEN PUBLISH pcEventName. 
    ELSE PUBLISH pcEventName (pcParameter).

    MESSAGE "Event " pcEventName " published." cLinkHandles.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initializeMenu w_toolbar 
FUNCTION initializeMenu RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Create the menus for the toolbar 
    Notes: This function is defined locally, but will skip the default 
           behavior if there is a super defined AND it returns true.     
           buildMenu() is always called! so it should not be part of the 
           super procedure. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOverridden AS LOG    NO-UNDO.
  DEFINE VARIABLE lOk         AS LOG    NO-UNDO.

/*   /* Allow a super-procedure to override the default toolbar */ */
/*   lOverridden = SUPER() NO-ERROR.                               */
/*                                                                 */
/*   /* not (true) for unknown */                                  */
/*   IF NOT (lOverridden = TRUE) THEN                              */
/*   DO:                                                           */
/*                                                                 */
/*     insertMenu("":U,"File,Navigation":U,no,?).                  */
/*                                                                 */
/*     insertMenu("File":U,                                        */
/*        "Add,Update,Copy,Delete,RULE,":U                         */
/*     +  "save,reset,cancel,RULE,Transaction,":U                  */
/*     +  "RULE,Function,RULE,Exit":U,                             */
/*         yes, /* expand children */                              */
/*         ?).                                                     */
/*  END.                                                           */
/*                                                                 */
 /* build the menubar */
 lOk = constructMenu().

 RETURN lOK. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initializeToolBar w_toolbar 
FUNCTION initializeToolBar RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Creates the toolbar for the toolbar 
    Notes: This function is defined locally, but will skip the default 
           behavior if there is a super defined AND it returns true.      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOverridden AS LOG    NO-UNDO.
  DEFINE VARIABLE lOk         AS LOG    NO-UNDO.

  /* Allow a super-procedure to override the default toolbar */
  lOverridden = SUPER() NO-ERROR.

  /* not (true) for unknown */
  IF NOT (lOverridden = TRUE) THEN
  DO:
    RUN buildToolbar(OUTPUT lOk).
/*     createToolBar                                                     */
/*      ("Tableio,RULE,Transaction,RULE,Navigation,RULE,Function,RULE"). */
  END.
  RETURN lOk.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

