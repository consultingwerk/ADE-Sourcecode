&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
/* Procedure Description
"This SmartPanel sends navigation messages 
to its NAVIGATION-TARGET. Its buttons have 
icons and are arranged horizontally."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS P-Win 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File:  adm2/dyntoolbar.w

  Description: SmartToolbar object  
  
  Input Parameters:
      <none>

  Output Parameters:
      <none>

    Created: April 1999 -- Progress Version 9.1A
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
&GLOB ADM-Panel-Type    Toolbar
/* tell smart.i that we can use the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE ghMenu        AS HANDLE  NO-UNDO.
DEFINE VARIABLE glResetRecord AS LOG     NO-UNDO INITIAL FALSE .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE toolbar
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Navigation-Source,TableIo-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Panel-Frame

/* Custom List Definitions                                              */
/* Box-Rectangle,List-2,List-3,List-4,List-5,List-6                     */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUseRepository P-Win 
FUNCTION getUseRepository RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initializeMenu P-Win 
FUNCTION initializeMenu RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initializeToolBar P-Win 
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
         SIZE 67.2 BY 1.57.


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
  CREATE WINDOW P-Win ASSIGN
         HEIGHT             = 1.57
         WIDTH              = 67.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB P-Win 
/* ************************* Included-Libraries *********************** */

{src/adm2/toolbar.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW P-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME Panel-Frame
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK P-Win 


/* ***************************  Main Block  *************************** */
  /*RUN start-super-proc ('auditing/adm2/custom/toolbarcustom.p':U).*/

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.        
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI P-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getWindowName P-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject P-Win 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cImagePath AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  
  ASSIGN cImagePath = "auditing/ui/image":U.
  
  /* let's set the image directory to ours */
  {set ImagePath cImagePath} .

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetLink P-Win 
PROCEDURE resetLink :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcLink AS CHARACTER  NO-UNDO.
 
 DEFINE VARIABLE cActionList AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hTarget     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iAction     AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cAction     AS CHARACTER  NO-UNDO.

 cActionList = {fnarg linkActions pcLink}.
  
 IF pcLink <> '':U THEN
   hTarget     = {fnarg activeTarget ENTRY(1,pcLink,'-':U)}.
 ELSE 
   {get ContainerSource hTarget}.

 IF NOT VALID-HANDLE(hTarget) THEN
   RETURN.

 DO iAction = 1 TO NUM-ENTRIES(cActionList):
    cAction = ENTRY(iAction,cActionList).


 END.

 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUseRepository P-Win 
FUNCTION getUseRepository RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* don't use the repository - the menu bar ends up not
     been created when we go through the repository stuff.
  */

  RETURN FALSE /*SUPER( )*/ .

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initializeMenu P-Win 
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

  /* Allow a super-procedure to override the default toolbar */
  lOverridden = SUPER() NO-ERROR.
 
  /* not (true) for unknown */
  IF NOT (lOverridden = TRUE) THEN
  DO:
      DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "Auditdbconnect",                       /*ActionID */
        INPUT "Name,Caption,Type,onChoose,Parent,Order":U, /* Attr list*/
              "Auditdbconnect" + CHR(1) +             /*Name */
              "Co&nnect Database..." + CHR(1) +   /*Caption */
              "RUN":U + CHR(1) +                 /*Type */
              "doConnectDb":U + CHR(1) +
              "File":U + CHR(1) +                /*Parent */
              "100").
  
      DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "Auditdbdisconnect",                       /*ActionID */
        INPUT "Name,Caption,Type,onChoose,Parent,Order":U, /* Attr list*/
              "Auditdbdisconnect" + CHR(1) +             /*Name */
              "Disconnect Database..." + CHR(1) +   /*Caption */
              "RUN":U + CHR(1) +                 /*Type */
              "doDisconnectDb":U + CHR(1) +
              "File":U + CHR(1) +                /*Parent */
              "100").

      DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "AuditExportPolicy",                    /*ActionID */
        INPUT "Name,Caption,Type,onChoose,Parent,Order":U, /* Attr list*/
              "AuditExportPolicy" + CHR(1) +          /*Name */
              "E&xport Policy..." + CHR(1) +      /*Caption */
              "RUN":U + CHR(1) +                 /*Type */
              "doExportPolicy":U + CHR(1) +
              "File":U + CHR(1) +                /*Parent */
              "100").

     DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "AuditImportPolicy",                    /*ActionID */
        INPUT "Name,Caption,Type,onChoose,Parent,Order":U, /* Attr list*/
              "AuditImportPolicy" + CHR(1) +          /*Name */
              "Import Policy..." + CHR(1) +      /*Caption */
              "RUN":U + CHR(1) +                 /*Type */
              "doImportPolicy":U + CHR(1) +
              "File":U + CHR(1) +                /*Parent */
              "100").

     DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "AuditCommitChanges",                    /*ActionID */
        INPUT "Name,Caption,Type,onChoose,Parent,Order":U, /* Attr list*/
              "AuditCommitChanges" + CHR(1) +          /*Name */
              "C&ommit Changes" + CHR(1) +         /*Caption */
              "RUN":U + CHR(1) +                 /*Type */
              "doCommitChanges":U + CHR(1) +
              "File":U + CHR(1) +                /*Parent */
              "100").
     
     DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "AuditUndoChanges",                    /*ActionID */
        INPUT "Name,Caption,Type,onChoose,Parent,Order":U, /* Attr list*/
              "AuditUndoChanges" + CHR(1) +          /*Name */
              "Undo Changes" + CHR(1) +         /*Caption */
              "RUN":U + CHR(1) +                /*Type */
              "doUndoChanges":U + CHR(1) +
              "File":U + CHR(1) +               /*Parent */
              "100").
  
     DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "AuditEventMaint",                      /*ActionID */
        INPUT "Name,Caption,Type,onChoose,Parent,Order":U, /* Attr list*/
              "AuditEventMaint" + CHR(1) +            /*Name */
              "Events &Maintenance..." + CHR(1) + /*Caption */
              "RUN":U + CHR(1) +                 /*Type */
              "doEventMaintenance":U + CHR(1) +
              "File":U + CHR(1) +                /*Parent */
              "100").

     DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "AuditActivatePolicy",                     /*ActionID */
        INPUT "Name,Caption,Type,onChoose,Parent,Order":U, /* Attr list*/
              "AuditActivatePolicy" + CHR(1) +           /*Name */
              "Activate Policies" + CHR(1) +  /*Caption */
              "RUN":U + CHR(1) +              /*Type */
              "doActivatePolicies":U + CHR(1) +
              "PolicyAudit":U + CHR(1) +           /*Parent */
              "100").

     DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "AuditDeactivatePolicy",                     /*ActionID */
        INPUT "Name,Caption,Type,onChoose,Parent,Order":U, /* Attr list*/
              "AuditDeactivatePolicy" + CHR(1) +           /*Name */
              "Deactivate Policies" + CHR(1) +  /*Caption */
              "RUN":U + CHR(1) +                /*Type */
              "doDeactivatePolicies":U + CHR(1) +
              "PolicyAudit":U + CHR(1) +             /*Parent */
              "100").

     DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "AuditRepConflict",                  /*ActionID */
        INPUT "Name,Caption,Type,onChoose,Parent,Order":U, /* Attr list*/
              "AuditRepConflict" + CHR(1) +        /*Name */
              "Report Conflicts" + CHR(1) +   /*Caption */
              "RUN":U + CHR(1) +              /*Type */
              "doReportConflicts":U + CHR(1) +
              "PolicyAudit":U + CHR(1) +           /*Parent */
              "100").

     DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "AuditRefreshPolicies",                  /*ActionID */
        INPUT "Name,Caption,Type,onChoose,Parent,Order":U, /* Attr list*/
              "AuditRefreshPolicies" + CHR(1) +        /*Name */
              "Re&fresh All Policies" + CHR(1) +   /*Caption */
              "RUN":U + CHR(1) +              /*Type */
              "doRefreshPolicies":U + CHR(1) +
              "PolicyAudit":U + CHR(1) +           /*Parent */
              "100").

     DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "AuditRepMerge",                  /*ActionID */
        INPUT "Name,Caption,Type,onChoose,Parent,Order":U, /* Attr list*/
              "AuditRepMerge" + CHR(1) +        /*Name */
              "Report Effective &Settings" + CHR(1) +   /*Caption */
              "RUN":U + CHR(1) +              /*Type */
              "doReportMerge":U + CHR(1) +
              "PolicyAudit":U + CHR(1) +           /*Parent */
              "100").

     DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "MasterHelp",                  /*ActionID */
        INPUT "Name,Caption,Type,onChoose,Parent,Order":U, /* Attr list*/
              "MasterHelp" + CHR(1) +        /*Name */
              "OpenEdge &Master Help" + CHR(1) +   /*Caption */
              "RUN":U + CHR(1) +              /*Type */
              "doMasterHelp":U + CHR(1) +
              "HelpAudit":U + CHR(1) +           /*Parent */
              "100").

     DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "APMTHelp",                  /*ActionID */
        INPUT "Name,Caption,Type,onChoose,Parent,Order":U, /* Attr list*/
              "APMTHelp" + CHR(1) +        /*Name */
              "&Audit Policy Maintenance Help Topics" + CHR(1) +   /*Caption */
              "RUN":U + CHR(1) +              /*Type */
              "doAPMTHelp":U + CHR(1) +
              "HelpAudit":U + CHR(1) +           /*Parent */
              "100").

     DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "FILEAUDIT":U,          /*ActionID */
        INPUT "Name,Caption,Type":U, /* Attr list*/
                      "FileAudit" + CHR(1) +
                      "File" + CHR(1) +
                      "Menu":U).

     DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "POLICYAUDIT":U,            /*ActionID */
        INPUT "Name,Caption,Type":U, /* Attr list*/
                      "PolicyAudit" + CHR(1) +
                      "Policy" + CHR(1) +
                      "Menu":U).

     DYNAMIC-FUNCTION('defineAction':U  IN THIS-PROCEDURE,
        INPUT "HELPAUDIT":U,            /*ActionID */
        INPUT "Name,Caption,Type":U, /* Attr list*/
                      "HelpAudit" + CHR(1) +
                      "Help" + CHR(1) +
                      "Menu":U).

    insertMenu("":U,"FileAudit,PolicyAudit,HelpAudit":U,no,?).

    insertMenu("FileAudit":U,
       "Auditdbconnect,Auditdbdisconnect,RULE,AuditExportPolicy,AuditImportPolicy,RULE,Add,Update,Copy,Delete,RULE,":U
    +  "save,reset,cancel,RULE,Transaction,":U
    +  "RULE,Function,RULE,AuditCommitChanges,AuditUndoChanges,RULE,AuditEventMaint,RULE,Exit":U,
        yes, /* expand children */
        ?).  
    insertMenu("PolicyAudit":U,
               "AuditRefreshPolicies,RULE,AuditActivatePolicy,AuditDeactivatePolicy,RULE,AuditRepConflict,AuditRepMerge",
               YES,
               ?).

    insertMenu("HelpAudit":U,
               "MasterHelp,APMTHelp",
               YES,
               ?).
    
 END.
   
 /* build the menubar */
 buildMenu("").
  
 RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initializeToolBar P-Win 
FUNCTION initializeToolBar RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Creates the toolbar for the toolbar 
    Notes: This function is defined locally, but will skip the default 
           behavior if there is a super defined AND it returns true.      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOverridden AS LOG    NO-UNDO.

  /* Allow a super-procedure to override the default toolbar */
  lOverridden = SUPER() NO-ERROR.
  
  /* not (true) for unknown */
  IF NOT (lOverridden = TRUE) THEN
  DO:
    createToolBar
     ("Tableio,RULE,Transaction,RULE,Navigation,RULE,Function,RULE").
  END.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

