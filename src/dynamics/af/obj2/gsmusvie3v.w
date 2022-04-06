&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"af/obj2/gsmusfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gsmusviewv.w

  Description:  User Maintenance SmartDataViewer

  Purpose:      SmartDataViewer for general user maintenance

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000009   UserRef:    POSSE
                Date:   14/03/2001  Author:     Phillip Magnay

  Update Notes: Created from Template rysttviewv.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

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

&scop object-name       gsmusvie3v.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

DEFINE VARIABLE gcErrorMessage      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcAbort             AS LOGICAL      NO-UNDO.
DEFINE VARIABLE gdUserObj           AS DECIMAL      NO-UNDO.
DEFINE VARIABLE gdCompanyObj        AS DECIMAL      NO-UNDO.
DEFINE VARIABLE ghBrowse            AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghTT                AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghQuery             AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghBuffer            AS HANDLE       NO-UNDO.

/* PLIP definitions */
{af/sup2/afrun2.i &define-only = YES }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmusfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buCascade 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRow vTableWin 
FUNCTION getRow RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buCascade 
     LABEL "&Cascade" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buCascade AT ROW 11.19 COL 86.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmusfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmusfullo.i}
      END-FIELDS.
   END-TABLES.
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 11.38
         WIDTH              = 100.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buCascade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCascade vTableWin
ON CHOOSE OF buCascade IN FRAME frMain /* Cascade */
DO:
    DEFINE VARIABLE cAnswer             AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE lAnswer             AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE cButtonPressed      AS CHARACTER    NO-UNDO.

    IF VALID-HANDLE(gshSessionManager) THEN
    DO:
        RUN askQuestion IN gshSessionManager (    
            INPUT "Proceed cascading data to profile Users?",         /* pcMessageList     */
            INPUT "Yes,No",         /* pcButtonList      */
            INPUT "NO",             /* pcDefaultButton   */
            INPUT "NO",             /* pcCancelButton    */
            INPUT "Cascade Data",   /* pcMessageTitle    */
            INPUT "",               /* pcDataType        */
            INPUT "",               /* pcFormat          */
            INPUT-OUTPUT cAnswer,   /* pcAnswer          */
            OUTPUT cButtonPressed   /* pcButtonPressed   */   
            ) NO-ERROR.

        CASE cButtonPressed:
            WHEN "YES" THEN lAnswer = TRUE.
            WHEN "NO"  THEN lAnswer = FALSE.                
        END CASE.             
    END.
    IF lAnswer THEN
       RUN cascadeData.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseEnd vTableWin 
PROCEDURE browseEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseHome vTableWin 
PROCEDURE browseHome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseOffEnd vTableWin 
PROCEDURE browseOffEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseOffHome vTableWin 
PROCEDURE browseOffHome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildBrowser vTableWin 
PROCEDURE buildBrowser :
/*-----------------------------------------------------------------------------  
  Purpose:     Constructs a dynamic data browser on to viewer
  Parameters:  <none>
  Notes:       Query parameters are set according to Security Type chosen in UI.
               Fetches first batch of records in a dynamic temp table for the query
               defined by the parameters in ttQueryParams and other UI values.
               Creates a dynamic browser using the information from the dynamic temp table.
               Populates the dynamic browser using the batch of records in the dynamic temp table.
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cQuery                    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cField                    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cRowIdent                 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hCurField                 AS HANDLE     NO-UNDO.
    DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cBrowseColHdls            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hWindow                   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hContainerSource          AS HANDLE     NO-UNDO.

    /* Hour glass ON */
    SESSION:SET-WAIT-STATE("general":U).

    RUN cleanUp.

    DO WITH FRAME {&FRAME-NAME}:

        /* Fetch first batch of records in a dynamic temp-table */
        {af/sup2/afrun2.i      &PLIP  = 'af/app/gsmusplipp.p'
                               &IPROC = 'getTypesResultSet'
                               &onApp = 'yes'
                               &PLIST = "(INPUT gdUserObj,~
                                          INPUT gdCompanyObj,~
                                          OUTPUT TABLE-HANDLE ghTT,~
                                          OUTPUT gcErrorMessage)"
                               &Define-only = NO
                               &autokill = YES}

        /* If PLIP internal procedure call returns an error message, then show to user */
        IF gcErrorMessage <> "":U THEN
        DO:
           RUN showMessages IN gshSessionManager (INPUT gcErrorMEssage,
                                                  INPUT "ERR":U,
                                                  INPUT "OK":U,
                                                  INPUT "OK":U,
                                                  INPUT "OK":U,
                                                  INPUT "Get Types Result Set Error",
                                                  INPUT YES,
                                                  INPUT ?,
                                                  OUTPUT gcAbort).
           ERROR-STATUS:ERROR = NO.
           RETURN NO-APPLY.
        END.

    END.

    /* If handle to returned dynamic temp table is valid */
    IF VALID-HANDLE(ghTT) THEN
    DO:

        /* Set handle to the temp table buffer */
        ASSIGN 
            ghBuffer = ghTT:DEFAULT-BUFFER-HANDLE
            .

        /* Construct query for dynamic temp table */
        CREATE QUERY ghQuery.
        ghQuery:ADD-BUFFER(ghBuffer).
        ASSIGN cQuery = "FOR EACH ":U + ghBuffer:NAME + " NO-LOCK":U.
        ghQuery:QUERY-PREPARE(cQuery).
/*
        /* Get dimensions of containing window */
        {get ContainerSource hContainerSource}.
        {get ContainerHandle hWindow hContainerSource}.
        ASSIGN
           FRAME {&FRAME-NAME}:HEIGHT-PIXELS  = hWindow:HEIGHT-PIXELS - 80
           FRAME {&FRAME-NAME}:WIDTH-PIXELS   = hWindow:WIDTH-PIXELS  - 28.  
  */
        /* Create the dynamic browser and size it relative to the containing window */
        CREATE BROWSE ghBrowse
               ASSIGN FRAME            = FRAME {&FRAME-NAME}:handle
                      ROW              = 2.5
                      COL              = 1.5
                      WIDTH-CHARS      = FRAME {&FRAME-NAME}:WIDTH-CHARS   - 3
                      HEIGHT-CHARS     = FRAME {&FRAME-NAME}:HEIGHT-CHARS - ghBrowse:ROW + 1
                      SEPARATORS       = TRUE
                      ROW-MARKERS      = FALSE
                      EXPANDABLE       = TRUE
                      COLUMN-RESIZABLE = TRUE
                      ALLOW-COLUMN-SEARCHING = TRUE
                      MULTIPLE         = TRUE
                      READ-ONLY        = FALSE
                      QUERY            = ghQuery
                /* Set procedures to handle browser events */
                TRIGGERS:   
                  ON DEFAULT-ACTION
                      PERSISTENT RUN defaultAction IN THIS-PROCEDURE.
                  ON VALUE-CHANGED
                      PERSISTENT RUN valueChanged  IN THIS-PROCEDURE.
                  ON END
                     PERSISTENT RUN browseEnd      IN THIS-PROCEDURE.
                  ON HOME
                     PERSISTENT RUN browseHome     IN THIS-PROCEDURE.
                  ON OFF-END
                     PERSISTENT RUN browseOffEnd   IN THIS-PROCEDURE.
                  ON OFF-HOME
                     PERSISTENT RUN browseOffHome  IN THIS-PROCEDURE.
                  ON START-SEARCH
                     PERSISTENT RUN startSearch    IN THIS-PROCEDURE.
                  ON ROW-DISPLAY
                     PERSISTENT RUN rowDisplay     IN THIS-PROCEDURE.
                  ON ROW-LEAVE
                     PERSISTENT RUN rowLeave       IN THIS-PROCEDURE.
                END TRIGGERS.

        /* Hide the dynamic browser while it is being constructed */
        IF FRAME {&FRAME-NAME}:VISIBLE THEN
           ASSIGN
              ghBrowse:VISIBLE   = NO.

        ghBrowse:SENSITIVE = NO.

        ASSIGN buCascade:ROW = 1.14.

        /* Add fields to browser using structure of dynamic temp table */
        DO iLoop = 1 TO ghBuffer:NUM-FIELDS:
            hCurField = ghBuffer:BUFFER-FIELD(iLoop).

            /* Ignore rowNum and rowIdent fields */
            IF hCurField:NAME EQ "RowNum":U 
            OR hCurField:NAME EQ "RowIdent":U 
            OR hCurField:NAME EQ "Entity_Mnemonic":U 
            OR hCurField:NAME EQ "Selected":U 
            THEN 
                NEXT.

            hField = ghBrowse:ADD-LIKE-COLUMN(hCurField).

            /* Enable/disable columns in browser according to Security Type and column name */
            hField:READ-ONLY = YES.

            /* Build up the list of browse columns for use in rowDisplay */
            IF VALID-HANDLE(hField) THEN
                cBrowseColHdls = cBrowseColHdls 
                               + (IF cBrowseColHdls = "":U THEN "":U ELSE ",":U) 
                               + STRING(hField).

        END. /* DO iLoop = 1 TO ghBuffer:NUM-FIELDS */

        /* Lock first column of dynamic browser */
        ghBrowse:NUM-LOCKED-COLUMNS = 1.

        /* Open the query for the browser */
        ghQuery:QUERY-OPEN().

        /* Show the browser */
        IF FRAME {&FRAME-NAME}:VISIBLE THEN
           ASSIGN
              ghBrowse:VISIBLE   = YES

        ghBrowse:SENSITIVE = YES.

        /* Reposition to first record in browser */
        ghQuery:GET-FIRST().
        IF ghBuffer:AVAILABLE THEN
            ghQuery:REPOSITION-TO-ROWID(ghBuffer:ROWID).

    END. /* IF VALID-HANDLE(hTH) */

    IF VALID-HANDLE(ghBrowse) THEN
       buCascade:COLUMN = ghBrowse:COLUMN + ghBrowse:WIDTH-CHARS - buCascade:WIDTH-CHARS.

    /* Hour glass OFF */
    SESSION:SET-WAIT-STATE("":U).

    /*
    /* Move focus to first updateable column of browser */
    IF VALID-HANDLE(ghBrowse) THEN
       APPLY "entry":U TO ghBrowse.
    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cascadeData vTableWin 
PROCEDURE cascadeData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop                 AS INTEGER      NO-UNDO.
  DEFINE VARIABLE lOK                   AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE hSelectedField        AS HANDLE       NO-UNDO.

  SESSION:SET-WAIT-STATE("GENERAL":U).

  ghQuery:GET-FIRST().
  DO WHILE ghBuffer:AVAILABLE:
      hSelectedField = ghBuffer:BUFFER-FIELD("Selected":U).
      hSelectedField:BUFFER-VALUE = NO.
      ghQuery:GET-NEXT().
  END.

  DO iLoop = 1 TO ghBrowse:NUM-SELECTED-ROWS:
      lOK = ghBrowse:FETCH-SELECTED-ROW(iLoop).
      IF NOT lOK THEN LEAVE.
      hSelectedField = ghBuffer:BUFFER-FIELD("Selected":U).
      hSelectedField:BUFFER-VALUE = YES.
  END.

  DO WITH FRAME {&FRAME-NAME}:

    {af/sup2/afrun2.i      &PLIP  = 'af/app/gsmusplipp.p'
                           &IPROC = 'cascadeTypesData'
                           &onApp = 'yes'
                           &PLIST = "(INPUT gdUserObj,~
                                      INPUT gdCompanyObj,~
                                      INPUT TABLE-HANDLE ghTT,~
                                      OUTPUT gcErrorMessage)"
                           &Define-only = NO
                           &autokill = YES}

    SESSION:SET-WAIT-STATE("":U).

    /* If PLIP internal procedure call returns an error message, then show to user */
    IF gcErrorMessage <> "":U THEN
    DO:
       RUN showMessages IN gshSessionManager (INPUT gcErrorMEssage,
                                              INPUT "ERR":U,
                                              INPUT "OK":U,
                                              INPUT "OK":U,
                                              INPUT "OK":U,
                                              INPUT "Cascade Data Error",
                                              INPUT YES,
                                              INPUT ?,
                                              OUTPUT gcAbort).
       ERROR-STATUS:ERROR = NO.
       RETURN NO-APPLY.
    END.

  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cleanUp vTableWin 
PROCEDURE cleanUp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(ghBrowse) THEN
        DELETE OBJECT ghBrowse.

    IF VALID-HANDLE(ghTT) THEN
        DELETE OBJECT ghTT.

    IF VALID-HANDLE(ghQuery) THEN
        DELETE OBJECT ghQuery.

    IF VALID-HANDLE(ghBuffer) THEN
        DELETE OBJECT ghBuffer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable vTableWin 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  input string pcRelative
  Notes:       NO call to SUPER
               Request the value of the user key field only
               then make a procedure call to build the dynamic browser
------------------------------------------------------------------------------*/

 DEFINE INPUT PARAMETER pcRelative    AS CHARACTER NO-UNDO.

 DEFINE VARIABLE cKeyFields           AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cKeyFieldValues      AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hSource              AS HANDLE    NO-UNDO.

 /* Get handle to SDO */
 {get DataSource hSource}.

 /* Set key field name to _obj of user table */
 cKeyFields = 'user_obj,default_login_company_obj':U.

 IF VALID-HANDLE(hSource) THEN
 DO:
   /* Get key field value from SDO */
   cKeyFieldValues = DYNAMIC-FUNCTION ("colValues":U IN hSource, cKeyFields).

   /* error 7351 indicates that a buffer-field is missing */
   IF cKeyFieldValues = ? AND ERROR-STATUS:GET-NUMBER(1) = 7351 THEN 
     DYNAMIC-FUNC('showMessage' IN TARGET-PROCEDURE, 
              SUBSTITUTE(DYNAMIC-FUNC("messageNumber":U IN TARGET-PROCEDURE,19), 
                       /* The fieldname is the second entry in the message */
                         ENTRY(2,ERROR-STATUS:GET-MESSAGE(1)," ":U),
                         TARGET-PROCEDURE:FILE-NAME)).
    ELSE
    DO:
        /* Save the returned user _obj field value and build the dynamic browser */
        ASSIGN 
           gdUserObj    = DECIMAL(ENTRY(2,cKeyFieldValues,CHR(1)))
           gdCompanyObj = DECIMAL(ENTRY(3,cKeyFieldValues,CHR(1)))
           . 

        RUN buildBrowser.
    END.

 END. /* if valid datasource*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defaultAction vTableWin 
PROCEDURE defaultAction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdHeight       AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth        AS DECIMAL NO-UNDO.

  DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hWindow               AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hContainerSource      AS HANDLE  NO-UNDO.

  /* Get container and window handles */
  {get ContainerSource hContainerSource}.
  {get ContainerHandle hWindow hContainerSource}.

  /* Save hidden state of current frame, then hide it */
  FRAME {&FRAME-NAME}:SCROLLABLE = FALSE.                                               
  lPreviouslyHidden = FRAME {&FRAME-NAME}:HIDDEN.                                                           
  FRAME {&FRAME-NAME}:HIDDEN = TRUE.

  /* Resize frame relative to containing window size */
  FRAME {&FRAME-NAME}:HEIGHT = pdHeight.
  FRAME {&FRAME-NAME}:WIDTH  = pdWidth.



  /* Resize dynamic browser (if exists) relative to current frame */
  IF VALID-HANDLE(ghBrowse) THEN
  DO:
    ghBrowse:WIDTH-CHARS  = FRAME {&FRAME-NAME}:WIDTH-CHARS   - 3.
    ghBrowse:HEIGHT-CHARS = FRAME {&FRAME-NAME}:HEIGHT-CHARS - ghBrowse:ROW + 1.

    buCascade:COLUMN = ghBrowse:COLUMN + ghBrowse:WIDTH-CHARS - buCascade:WIDTH-CHARS.

  END.



  /* Restore original hidden state of current frame */
  APPLY "end-resize":U TO FRAME {&FRAME-NAME}.
  FRAME {&FRAME-NAME}:HIDDEN = lPreviouslyHidden NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowDisplay vTableWin 
PROCEDURE rowDisplay :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSearch vTableWin 
PROCEDURE startSearch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChanged vTableWin 
PROCEDURE valueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject vTableWin 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  IF VALID-HANDLE(ghBrowse) THEN
      ghBrowse:SENSITIVE = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRow vTableWin 
FUNCTION getRow RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RETURN SUPER( ).


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

