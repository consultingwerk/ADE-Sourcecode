&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME diDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS diDialog 
/*---------------------------------------------------------------------------------
  File: _newcalcg.w

  Description:  New calculated field dialog

  Purpose:      Prompt user for information required to create a new calculated
                field in the repository

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/17/2004  Author:     

  Update Notes: Created from Template rysttdilgd.w

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

&scop object-name       _newcalcg.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDialog yes

{adeuib/uibhlp.i}
{src/adm2/globals.i}
{src/adm2/widgetprto.i}

DEFINE OUTPUT PARAMETER pcClass        AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcName         AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcModule       AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcDataType     AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcLabel        AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcColumnLabel  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcFormat       AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcHelp         AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER plOK           AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME diDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buOk buCancel buHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_newcalcv AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buCancel AUTO-END-KEY 
     LABEL "&Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buHelp 
     LABEL "&Help" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.14.

DEFINE BUTTON buOk 
     LABEL "&OK" 
     SIZE 15 BY 1.14.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME diDialog
     buOk AT ROW 12.95 COL 3.6
     buCancel AT ROW 12.95 COL 19.8
     buHelp AT ROW 12.95 COL 53
     SPACE(2.19) SKIP(0.38)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Create Calculated Field"
         DEFAULT-BUTTON buOk CANCEL-BUTTON buCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB diDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX diDialog
                                                                        */
ASSIGN 
       FRAME diDialog:SCROLLABLE       = FALSE
       FRAME diDialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX diDialog
/* Query rebuild information for DIALOG-BOX diDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX diDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME diDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL diDialog diDialog
ON HELP OF FRAME diDialog /* Create Calculated Field */
ANYWHERE DO:
  RUN runHelp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL diDialog diDialog
ON WINDOW-CLOSE OF FRAME diDialog /* Create Calculated Field */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buHelp diDialog
ON CHOOSE OF buHelp IN FRAME diDialog /* Help */
DO:
  RUN runHelp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOk diDialog
ON CHOOSE OF buOk IN FRAME diDialog /* OK */
DO:
  DEFINE VARIABLE cError AS CHARACTER  NO-UNDO.

  /* Validate the data entered on the viewer and set the output parameters
     with that data if there were no validation errors */
  RUN validateCalcData IN h_newcalcv (OUTPUT cError).
  IF cError NE '':U THEN
    MESSAGE cError VIEW-AS ALERT-BOX ERROR.
  ELSE DO:
    ASSIGN
      pcClass       = DYNAMIC-FUNCTION('widgetValue':U IN h_newcalcv, INPUT 'cClass':U)
      pcName        = DYNAMIC-FUNCTION('widgetValue':U IN h_newcalcv, INPUT 'cName':U)
      pcModule      = DYNAMIC-FUNCTION('widgetValue':U IN h_newcalcv, INPUT 'cModule':U)
      pcDataType    = DYNAMIC-FUNCTION('widgetValue':U IN h_newcalcv, INPUT 'cDataType':U)
      pcLabel       = DYNAMIC-FUNCTION('widgetValue':U IN h_newcalcv, INPUT 'cLabel':U)
      pcColumnLabel = DYNAMIC-FUNCTION('widgetValue':U IN h_newcalcv, INPUT 'cColumnLabel':U)
      pcFormat      = DYNAMIC-FUNCTION('widgetValue':U IN h_newcalcv, INPUT 'cFormat':U)
      pcHelp        = DYNAMIC-FUNCTION('widgetValue':U IN h_newcalcv, INPUT 'cHelp':U)
      plOK          = TRUE.

    APPLY 'GO':U TO FRAME {&FRAME-NAME}.
  END.  /* else no error */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK diDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects diDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'adeuib/_newcalcv.w':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'EnabledObjFldsToDisableModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectName_newcalcv.wDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_newcalcv ).
       RUN repositionObject IN h_newcalcv ( 1.48 , 1.00 ) NO-ERROR.
       /* Size in AB:  ( 11.00 , 62.00 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_newcalcv ,
             buOk:HANDLE , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI diDialog  _DEFAULT-DISABLE
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
  HIDE FRAME diDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI diDialog  _DEFAULT-ENABLE
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
  ENABLE buOk buCancel buHelp 
      WITH FRAME diDialog.
  VIEW FRAME diDialog.
  {&OPEN-BROWSERS-IN-QUERY-diDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject diDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hcontainer AS HANDLE      NO-UNDO.

  RUN SUPER.

  IF VALID-HANDLE(h_newcalcv) THEN
  DO:
    {get ContainerHandle hContainer h_newcalcv}.
    ON HELP OF hContainer ANYWHERE PERSISTENT RUN runHelp.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runHelp diDialog 
PROCEDURE runHelp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN adecomm/_adehelp.p( "AB", "CONTEXT", {&Calculated_Field_New_Dialog}, ?).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

