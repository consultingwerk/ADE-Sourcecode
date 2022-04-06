&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER cmaxnumflds           AS INTEGER          NO-UNDO. 
DEFINE INPUT-OUTPUT PARAMETER cnamesuffix           AS CHARACTER        NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER cSDOFields            AS LOGICAL          NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER plDeleteOnGeneration  AS LOGICAL          NO-UNDO.
DEFINE INPUT        PARAMETER pcAllModules          AS CHARACTER        NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcBrowseModule        AS CHARACTER        NO-UNDO.

/* Local Variable Definitions ---                                       */

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
&Scoped-Define ENABLED-OBJECTS coModule toSDOFields fimaxnumflds ~
finamesuffix toAlwaysDelete Btn_OK Btn_Cancel Btn_Help RECT-10 RECT-11 
&Scoped-Define DISPLAYED-OBJECTS coModule toSDOFields fimaxnumflds ~
finamesuffix toAlwaysDelete 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseModule gDialog 
FUNCTION getBrowseModule RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDeleteOnGeneration gDialog 
FUNCTION getDeleteOnGeneration RETURNS LOGICAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getmaxnumflds gDialog 
FUNCTION getmaxnumflds RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getnamesuffix gDialog 
FUNCTION getnamesuffix RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDOFields gDialog 
FUNCTION getSDOFields RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseModule gDialog 
FUNCTION setBrowseModule RETURNS LOGICAL
    ( INPUT plBrowseModule  AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDeleteOnGeneration gDialog 
FUNCTION setDeleteOnGeneration RETURNS LOGICAL
  ( INPUT plAlwaysDelete        AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setmaxnumflds gDialog 
FUNCTION setmaxnumflds RETURNS LOGICAL
   ( INPUT newval AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setnamesuffix gDialog 
FUNCTION setnamesuffix RETURNS LOGICAL
  ( INPUT newval AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSDOFields gDialog 
FUNCTION setSDOFields RETURNS LOGICAL
  ( INPUT newval AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE coModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "M&odule" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 36.2 BY 1 TOOLTIP "Product module associated with Browsers" NO-UNDO.

DEFINE VARIABLE fimaxnumflds AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Max Number Of Fields" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 TOOLTIP "The maximum number of fields to be used in the browser" NO-UNDO.

DEFINE VARIABLE finamesuffix AS CHARACTER FORMAT "X(10)":U 
     LABEL "Name Suffix" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 TOOLTIP "A suffix for the selected table's dump name when creating a Dynamic Browser" NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72.8 BY 5.81.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72.8 BY 1.81.

DEFINE VARIABLE toAlwaysDelete AS LOGICAL INITIAL no 
     LABEL "Always delete before generation?" 
     VIEW-AS TOGGLE-BOX
     SIZE 42 BY .81 TOOLTIP "Check to always delete the existing object before generation" NO-UNDO.

DEFINE VARIABLE toSDOFields AS LOGICAL INITIAL no 
     LABEL "Use SDO Fields" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.4 BY .81 TOOLTIP "Use SDO fields on browser, otherwise fieldlist from entity mnemonic is used" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     coModule AT ROW 1.38 COL 29 COLON-ALIGNED
     toSDOFields AT ROW 2.52 COL 31
     fimaxnumflds AT ROW 3.38 COL 29 COLON-ALIGNED HELP
          "Max number of fields to include from SDO"
     finamesuffix AT ROW 4.52 COL 29 COLON-ALIGNED
     toAlwaysDelete AT ROW 5.67 COL 31
     Btn_OK AT ROW 7.29 COL 2.4
     Btn_Cancel AT ROW 7.29 COL 18
     Btn_Help AT ROW 7.29 COL 57.8
     RECT-10 AT ROW 1 COL 1.4
     RECT-11 AT ROW 6.91 COL 1.4
     SPACE(0.00) SKIP(0.13)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Browser Settings"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


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
                                                                        */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

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
ON WINDOW-CLOSE OF FRAME gDialog /* Browser Settings */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help gDialog
ON CHOOSE OF Btn_Help IN FRAME gDialog /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
    IF INTEGER(fimaxnumflds:SCREEN-VALUE) <= 0 THEN
    DO:
        MESSAGE "Please enter a max number of fields.".
        APPLY "ENTRY" TO fimaxnumflds.
        RETURN NO-APPLY.
    END. /* IF INTEGER(fimaxnumflds:SCREEN-VALUE) <= 0 THEN DO*/

    IF finamesuffix:SCREEN-VALUE = "" THEN
    DO:
        MESSAGE "Please enter a name suffix.".
        APPLY "ENTRY" TO finamesuffix.
        RETURN NO-APPLY.
    END. /*IF finamesuffix:SCREEN-VALUE = "" THEN DO:*/

    ASSIGN cmaxnumflds          = DYNAMIC-FUNCTION('getmaxnumflds':U)
           cnamesuffix          = DYNAMIC-FUNCTION('getnamesuffix':U)
           cSdoFields           = DYNAMIC-FUNCTION('getSdoFields':U)
           plDeleteOnGeneration = DYNAMIC-FUNCTION("getDeleteOnGeneration":U)
           pcBrowseModule       = DYNAMIC-FUNCTION("getBrowseModule":U)
           .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY coModule toSDOFields fimaxnumflds finamesuffix toAlwaysDelete 
      WITH FRAME gDialog.
  ENABLE coModule toSDOFields fimaxnumflds finamesuffix toAlwaysDelete Btn_OK 
         Btn_Cancel Btn_Help RECT-10 RECT-11 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    RUN SUPER.

    ASSIGN coModule:LIST-ITEMS IN FRAME {&FRAME-NAME} = pcAllModules.
    
    DYNAMIC-FUNCTION('setmaxnumflds':U,cmaxnumflds ).
    DYNAMIC-FUNCTION('setnamesuffix':U,cnamesuffix ).
    DYNAMIC-FUNCTION('setSDOFields':U,cSDOFields).
    DYNAMIC-FUNCTION("setDeleteOnGeneration":U, plDeleteOnGeneration).
    DYNAMIC-FUNCTION("setBrowseModule":U, INPUT pcBrowseModule).

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseModule gDialog 
FUNCTION getBrowseModule RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN FRAME {&FRAME-NAME} coMOdule.

    RETURN coModule.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDeleteOnGeneration gDialog 
FUNCTION getDeleteOnGeneration RETURNS LOGICAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN FRAME {&FRAME-NAME} toAlwaysDelete.
    RETURN toAlwaysDelete.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getmaxnumflds gDialog 
FUNCTION getmaxnumflds RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN fimaxnumflds.
  RETURN fimaxnumflds.  
END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getnamesuffix gDialog 
FUNCTION getnamesuffix RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN finamesuffix.
      RETURN finamesuffix.  
  END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDOFields gDialog 
FUNCTION getSDOFields RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN toSDOFields.
  RETURN toSDOFields.  
END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseModule gDialog 
FUNCTION setBrowseModule RETURNS LOGICAL
    ( INPUT plBrowseModule  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN coModule:SCREEN-VALUE IN FRAME {&FRAME-NAME} = plBrowseModule
           NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
        ASSIGN coModule:SCREEN-VALUE IN FRAME {&FRAME-NAME} = coModule:ENTRY(1).

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDeleteOnGeneration gDialog 
FUNCTION setDeleteOnGeneration RETURNS LOGICAL
  ( INPUT plAlwaysDelete        AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN toAlwaysDelete:CHECKED IN FRAME {&FRAME-NAME} = plAlwaysDelete.
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setmaxnumflds gDialog 
FUNCTION setmaxnumflds RETURNS LOGICAL
   ( INPUT newval AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:  
   fimaxnumflds:SCREEN-VALUE = STRING(newval).
   RETURN TRUE.  
 END. /*do with frame*/
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setnamesuffix gDialog 
FUNCTION setnamesuffix RETURNS LOGICAL
  ( INPUT newval AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:  
   finamesuffix:SCREEN-VALUE = newval.
   RETURN TRUE.   /* Function return value. */
 END. /*do with frame*/
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSDOFields gDialog 
FUNCTION setSDOFields RETURNS LOGICAL
  ( INPUT newval AS LOGICAL  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:  
   toSDOFields:CHECKED = newval.
   RETURN TRUE.  
 END. /*do with frame*/

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

