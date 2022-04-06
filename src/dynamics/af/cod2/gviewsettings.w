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
DEFINE INPUT-OUTPUT PARAMETER cvmaxnumflds          AS INTEGER          NO-UNDO. 
DEFINE INPUT-OUTPUT PARAMETER cvnamesuffix          AS CHARACTER        NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER cvmaxfldspercolumn    AS INTEGER          NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER cSDOFields            AS LOGICAL          NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER plDeleteOnGeneration  AS LOGICAL          NO-UNDO. 
DEFINE INPUT        PARAMETER pcAllModules          AS CHARACTER        NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcViewerModule        AS CHARACTER        NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS coModule toSDOFields fivmaxnumflds ~
fivnamesuffix fivmaxfldspercolumn toAlwaysDelete Btn_OK Btn_Cancel Btn_Help ~
RECT-12 RECT-13 
&Scoped-Define DISPLAYED-OBJECTS coModule toSDOFields fivmaxnumflds ~
fivnamesuffix fivmaxfldspercolumn toAlwaysDelete 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetDeleteOnGeneration gDialog 
FUNCTION GetDeleteOnGeneration RETURNS LOGICAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDOFields gDialog 
FUNCTION getSDOFields RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getViewerModule gDialog 
FUNCTION getViewerModule RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getvmaxfldspercolumn gDialog 
FUNCTION getvmaxfldspercolumn RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getvmaxnumflds gDialog 
FUNCTION getvmaxnumflds RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getvnamesuffix gDialog 
FUNCTION getvnamesuffix RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SetDeleteOnGeneration gDialog 
FUNCTION SetDeleteOnGeneration RETURNS LOGICAL
    ( INPUT plAlwaysDelete      AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSDOFields gDialog 
FUNCTION setSDOFields RETURNS LOGICAL
  ( INPUT newval AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setViewerModule gDialog 
FUNCTION setViewerModule RETURNS LOGICAL
    ( INPUT plViewerModule  AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setvmaxfldspercolumn gDialog 
FUNCTION setvmaxfldspercolumn RETURNS LOGICAL
  ( INPUT newval AS INTEGER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setvmaxnumflds gDialog 
FUNCTION setvmaxnumflds RETURNS LOGICAL
   ( INPUT newval AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setvnamesuffix gDialog 
FUNCTION setvnamesuffix RETURNS LOGICAL
  ( INPUT newval AS CHAR )  FORWARD.

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
     SIZE 36.2 BY 1 TOOLTIP "Product module associated with Viewers" NO-UNDO.

DEFINE VARIABLE fivmaxfldspercolumn AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Max  Fields Per Column" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 TOOLTIP "Maximum number of fields to be created per column" NO-UNDO.

DEFINE VARIABLE fivmaxnumflds AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Max Number Of Fields" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 TOOLTIP "Maximum number of fields to be placed on the viewer" NO-UNDO.

DEFINE VARIABLE fivnamesuffix AS CHARACTER FORMAT "X(10)":U 
     LABEL "Name Suffix" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 TOOLTIP "A suffix for the selected table's dump name when creating a Dynamic Viewer" NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72.8 BY 6.1.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72.8 BY 1.71.

DEFINE VARIABLE toAlwaysDelete AS LOGICAL INITIAL no 
     LABEL "Delete instances before generation?" 
     VIEW-AS TOGGLE-BOX
     SIZE 42 BY .81 TOOLTIP "Check to always delete the existing object before generation" NO-UNDO.

DEFINE VARIABLE toSDOFields AS LOGICAL INITIAL no 
     LABEL "Use SDO Fields" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.4 BY .81 TOOLTIP "Use SDO fields on viewer, otherwise fieldlist from entity mnemonic is used" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     coModule AT ROW 1.19 COL 29 COLON-ALIGNED
     toSDOFields AT ROW 2.24 COL 31
     fivmaxnumflds AT ROW 3 COL 29 COLON-ALIGNED HELP
          "Max number of fields to include from SDO"
     fivnamesuffix AT ROW 4.05 COL 29 COLON-ALIGNED
     fivmaxfldspercolumn AT ROW 5.1 COL 29 COLON-ALIGNED HELP
          "Max number of fields to include from SDO"
     toAlwaysDelete AT ROW 6.14 COL 31
     Btn_OK AT ROW 7.67 COL 2.2
     Btn_Cancel AT ROW 7.67 COL 17.8
     Btn_Help AT ROW 7.67 COL 58.6
     RECT-12 AT ROW 1 COL 1.4
     RECT-13 AT ROW 7.29 COL 1.4
     SPACE(0.00) SKIP(0.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Viewer Settings"
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
ON WINDOW-CLOSE OF FRAME gDialog /* Viewer Settings */
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
    IF fivnamesuffix:SCREEN-VALUE = "" THEN
    DO:
        MESSAGE "Please enter a name suffix.".
        APPLY "ENTRY" TO fivnamesuffix.
        RETURN NO-APPLY.
    END. /*IF fivnamesuffix:SCREEN-VALUE = "" THEN DO*/

    IF fivmaxnumflds:INPUT-VALUE <= 0 THEN
    DO:
        MESSAGE "Please enter a max number of fields.".
        APPLY "ENTRY" TO fivmaxnumflds.
        RETURN NO-APPLY.
    END. /* IF INTEGER(fivmaxnumflds:SCREEN-VALUE) <= 0 THEN DO*/
    
    IF fivmaxfldspercolumn:INPUT-VALUE <= 0 THEN
    DO:
        MESSAGE "Please enter a max fields per column.".
        APPLY "ENTRY" TO fivmaxfldspercolumn.
        RETURN NO-APPLY.
    END. /*IF INTEGER(fivmaxfldspercolumn:SCREEN-VALUE) <= 0 THEN DO*/

    ASSIGN cvmaxnumflds         = DYNAMIC-FUNCTION('getvmaxnumflds':U)
           cvnamesuffix         = DYNAMIC-FUNCTION('getvnamesuffix':U)
           cvmaxfldspercolumn   = DYNAMIC-FUNCTION('getvmaxfldspercolumn':U)
           cSDOFields           = DYNAMIC-FUNCTION('getSDOFields':U)
           plDeleteOnGeneration = DYNAMIC-FUNCTION("GetDeleteOnGeneration":U)
           pcViewerModule       = DYNAMIC-FUNCTION("getViewerModule":U)
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
  DISPLAY coModule toSDOFields fivmaxnumflds fivnamesuffix fivmaxfldspercolumn 
          toAlwaysDelete 
      WITH FRAME gDialog.
  ENABLE coModule toSDOFields fivmaxnumflds fivnamesuffix fivmaxfldspercolumn 
         toAlwaysDelete Btn_OK Btn_Cancel Btn_Help RECT-12 RECT-13 
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

    DYNAMIC-FUNCTION('setvmaxnumflds':U,cvmaxnumflds ).
    DYNAMIC-FUNCTION('setvnamesuffix':U,cvnamesuffix ).
    DYNAMIC-FUNCTION('setvmaxfldspercolumn':U,cvmaxfldspercolumn).
    DYNAMIC-FUNCTION('setSDOFields':U,cSDOFields).
    DYNAMIC-FUNCTION("setDeleteOnGeneration":U, INPUT plDeleteOnGeneration).
    DYNAMIC-FUNCTION("setViewerModule":U, INPUT pcViewerModule).

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetDeleteOnGeneration gDialog 
FUNCTION GetDeleteOnGeneration RETURNS LOGICAL
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getViewerModule gDialog 
FUNCTION getViewerModule RETURNS CHARACTER
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getvmaxfldspercolumn gDialog 
FUNCTION getvmaxfldspercolumn RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN fivmaxfldspercolumn.
  RETURN fivmaxfldspercolumn.  
END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getvmaxnumflds gDialog 
FUNCTION getvmaxnumflds RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN fivmaxnumflds.
  RETURN fivmaxnumflds.  
END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getvnamesuffix gDialog 
FUNCTION getvnamesuffix RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN fivnamesuffix.
      RETURN fivnamesuffix.  
  END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SetDeleteOnGeneration gDialog 
FUNCTION SetDeleteOnGeneration RETURNS LOGICAL
    ( INPUT plAlwaysDelete      AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN toAlwaysDelete:CHECKED IN FRAME {&FRAME-NAME} = plDeleteOnGeneration.

    RETURN TRUE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setViewerModule gDialog 
FUNCTION setViewerModule RETURNS LOGICAL
    ( INPUT plViewerModule  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN coModule:SCREEN-VALUE IN FRAME {&FRAME-NAME} = plViewerModule
           NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
        ASSIGN coModule:SCREEN-VALUE IN FRAME {&FRAME-NAME} = coModule:ENTRY(1).

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setvmaxfldspercolumn gDialog 
FUNCTION setvmaxfldspercolumn RETURNS LOGICAL
  ( INPUT newval AS INTEGER  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:  
   fivmaxfldspercolumn:SCREEN-VALUE = STRING(newval).
   RETURN TRUE.  
 END. /*do with frame*/

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setvmaxnumflds gDialog 
FUNCTION setvmaxnumflds RETURNS LOGICAL
   ( INPUT newval AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:  
   fivmaxnumflds:SCREEN-VALUE = STRING(newval).
   RETURN TRUE.  
 END. /*do with frame*/
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setvnamesuffix gDialog 
FUNCTION setvnamesuffix RETURNS LOGICAL
  ( INPUT newval AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:  
   fivnamesuffix:SCREEN-VALUE = newval.
   RETURN TRUE.   /* Function return value. */
 END. /*do with frame*/
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

