&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME diDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS diDialog 
/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: _calcselg.w

  Description:  

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/13/2004  Author:     

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

&scop object-name       _calcselg.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDialog yes

{adeuib/uibhlp.i}
{src/adm2/globals.i}
{src/adm2/widgetprto.i}

DEFINE INPUT  PARAMETER pcTableList    AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcCalcMaster   AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcCalcInstance AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcDataType     AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcLabel        AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcColumnLabel  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcFormat       AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcHelp         AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER plNewCalc      AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcClass        AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcModule       AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER plOK           AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME diDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bCancel bHelp bChoose bNew 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableList diDialog 
FUNCTION getTableList RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_calcselb AS HANDLE NO-UNDO.
DEFINE VARIABLE h_calcseld AS HANDLE NO-UNDO.
DEFINE VARIABLE h_calcself AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bCancel AUTO-END-KEY 
     LABEL "Ca&ncel" 
     SIZE 29 BY 1.14.

DEFINE BUTTON bChoose AUTO-GO 
     LABEL "&Select calculated field" 
     SIZE 29 BY 1.14.

DEFINE BUTTON bHelp 
     LABEL "&Help" 
     SIZE 29 BY 1.14.

DEFINE BUTTON bNew 
     LABEL "&Create new calculated field" 
     SIZE 29 BY 1.14.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME diDialog
     bCancel AT ROW 19.57 COL 65.8
     bHelp AT ROW 19.57 COL 111
     bChoose AT ROW 19.62 COL 5
     bNew AT ROW 19.62 COL 35.4
     SPACE(81.59) SKIP(0.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Calculated Field Selector"
         DEFAULT-BUTTON bChoose CANCEL-BUTTON bCancel.


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
   FRAME-NAME                                                           */
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
ON HELP OF FRAME diDialog /* Calculated Field Selector */
DO:
  MESSAGE 1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL diDialog diDialog
ON WINDOW-CLOSE OF FRAME diDialog /* Calculated Field Selector */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bChoose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bChoose diDialog
ON CHOOSE OF bChoose IN FRAME diDialog /* Select calculated field */
DO:
  RUN selectCalcField.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bHelp diDialog
ON CHOOSE OF bHelp IN FRAME diDialog /* Help */
DO:
  RUN runHelp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bNew
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bNew diDialog
ON CHOOSE OF bNew IN FRAME diDialog /* Create new calculated field */
DO:

  RUN adeuib/_newcalcg.w
      (OUTPUT pcClass,
       OUTPUT pcCalcMaster,
       OUTPUT pcModule,
       OUTPUT pcDataType,
       OUTPUT pcLabel,
       OUTPUT pcColumnLabel,
       OUTPUT pcFormat,
       OUTPUT pcHelp,
       OUTPUT plOK).

  IF plOK THEN
  DO:
    ASSIGN 
      plNewCalc = TRUE
      pcCalcInstance = pcCalcMaster.
    
    APPLY 'GO':U TO FRAME {&FRAME-NAME}.
  END.

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
             INPUT  'adeuib/_calcseld.wDB-AWARE':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessyesDisconnectAppServernoObjectName_calcseldUpdateFromSourcenoToggleDataTargetsyesOpenOnInitnoPromptOnDeleteyesPromptColumns(ALL)':U ,
             OUTPUT h_calcseld ).
       RUN repositionObject IN h_calcseld ( 1.24 , 122.00 ) NO-ERROR.
       /* Size in AB:  ( 2.62 , 15.00 ) */

       RUN constructObject (
             INPUT  'adeuib/_calcself.w':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'EnabledObjFldsToDisableModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectName_calcself.wDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_calcself ).
       RUN repositionObject IN h_calcself ( 1.24 , 32.00 ) NO-ERROR.
       /* Size in AB:  ( 4.00 , 69.60 ) */

       RUN constructObject (
             INPUT  'adeuib/_calcselb.w':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesDataSourceNamesUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_calcselb ).
       RUN repositionObject IN h_calcselb ( 5.52 , 4.00 ) NO-ERROR.
       RUN resizeObject IN h_calcselb ( 13.81 , 137.00 ) NO-ERROR.

       /* Links to SmartDataObject h_calcseld. */
       RUN addLink ( h_calcself , 'CalcFilter':U , h_calcseld ).

       /* Links to SmartDataViewer h_calcself. */
       RUN addLink ( h_calcseld , 'Data':U , h_calcself ).

       /* Links to SmartDataBrowser h_calcselb. */
       RUN addLink ( h_calcseld , 'Data':U , h_calcselb ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_calcself ,
             bCancel:HANDLE , 'BEFORE':U ).
       RUN adjustTabOrder ( h_calcselb ,
             h_calcself , 'AFTER':U ).
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
  ENABLE bCancel bHelp bChoose bNew 
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

  IF VALID-HANDLE(h_calcself) THEN
  DO:
    {get ContainerHandle hContainer h_calcself}.
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
  RUN adecomm/_adehelp.p( "AB", "CONTEXT", {&Calculated_Field_Selector}, ?).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectCalcField diDialog 
PROCEDURE selectCalcField :
/*------------------------------------------------------------------------------
  Purpose:     Gets the calculated data for the selected field and sets 
               the output parameters with that data
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cCalcData AS CHARACTER  NO-UNDO.

 cCalcData = DYNAMIC-FUNCTION('colValues':U IN h_calcseld, 
                              INPUT 'tName,tInstanceName,tDataType,tLabel,tFormat,tHelp,tColumnLabel').
 ASSIGN 
   pcCalcMaster   = ENTRY(2, cCalcData, CHR(1))
   pcCalcInstance = ENTRY(3, cCalcData, CHR(1))
   pcDataType     = ENTRY(4, cCalcData, CHR(1))
   pcLabel        = ENTRY(5, cCalcData, CHR(1))
   pcFormat       = ENTRY(6, cCalcData, CHR(1))
   pcHelp         = ENTRY(7, cCalcData, CHR(1))
   pcColumnLabel  = ENTRY(8, cCalcData, CHR(1))
   plOK           = TRUE.

 IF SOURCE-PROCEDURE NE THIS-PROCEDURE THEN
   APPLY 'GO':U TO FRAME {&FRAME-NAME}.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableList diDialog 
FUNCTION getTableList RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of tables (set by input parameter)
    Notes:  Invoked by the SDO to create temp table records for calculated 
            fields of the SDO's table's entities.
------------------------------------------------------------------------------*/

  RETURN pcTableList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

