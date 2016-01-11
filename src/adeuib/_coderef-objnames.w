&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _coderef-objnames.w

  Description: from SMART.W - Template for basic ADM2 SmartObject
  Object Names List for AppBuilder's Code References Window.

  Author: J. Palazzo (jep)
  Created: May, 1999

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

{adeuib/sharvars.i}
{adeuib/uniwidg.i}
{adeuib/uibhlp.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE BUFFER b_P             FOR _P.
DEFINE VARIABLE hSecEd        AS HANDLE NO-UNDO.
  /* Procedure Handle to Section Editor for which the Code Refs window
     is currently displaying information. */
DEFINE VARIABLE Curr_PRecid   AS RECID  NO-UNDO.
  /* Recid of _P procedure object for which the Code Refs window is currently
     displaying information. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS s_picklist btnInsert 
&Scoped-Define DISPLAYED-OBJECTS s_picklist 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnInsert 
     LABEL "&Insert" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE s_picklist AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SORT SCROLLBAR-VERTICAL 
     SIZE 73 BY 16.91
     FONT 0 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     s_picklist AT ROW 1.48 COL 1.6 NO-LABEL
     btnInsert AT ROW 18.86 COL 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY
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
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 19.29
         WIDTH              = 73.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME btnInsert
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnInsert sObject
ON CHOOSE OF btnInsert IN FRAME F-Main /* Insert */
DO:
    RUN InsertObjName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME s_picklist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s_picklist sObject
ON DEFAULT-ACTION OF s_picklist IN FRAME F-Main
DO:
    RUN InsertObjName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s_picklist sObject
ON RETURN OF s_picklist IN FRAME F-Main
DO:
  APPLY 'DEFAULT-ACTION':u TO SELF.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

SUBSCRIBE "AB_call_sew_setHandle":U ANYWHERE RUN-PROCEDURE "refreshDisplay":U.
SUBSCRIBE "SE_UPDATE_WIDGETS":U     ANYWHERE RUN-PROCEDURE "refreshDisplay":U.

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* Help for this Viewer. */
ON HELP OF FRAME {&FRAME-NAME}
  RUN adecomm/_adehelp.p ("AB", "CONTEXT", {&Widget_Names_Dlg_Box} , "").

/* Indicate this persistent procedure is an ADE tool. */
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ApplyEntryCodeRef sObject 
PROCEDURE ApplyEntryCodeRef :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    IF s_picklist:SENSITIVE THEN
        APPLY "ENTRY":U TO s_picklist.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InsertObjName sObject 
PROCEDURE InsertObjName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:

  ASSIGN s_PickList.
  IF VALID-HANDLE(hSecEd) THEN
    RUN doInsertWidgetName IN hSecEd (INPUT s_PickList).

END. /* DO WITH FRAME */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshDisplay sObject 
PROCEDURE refreshDisplay :
/*------------------------------------------------------------------------------
  Purpose:     Refresh Preprocessor Name List in Code References window.
  Parameters:  None
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE vList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE vItem       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE vString     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE PRecid      AS RECID      NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

  RUN get-attribute IN _h_UIB ("Section-Editor-Handle":U).
  ASSIGN hSecEd = WIDGET-HANDLE(RETURN-VALUE) NO-ERROR.
  IF NOT VALID-HANDLE ( hSecEd ) THEN
  DO:
    ASSIGN s_PickList = "":U.
    s_PickList:DELETE(s_PickList:LIST-ITEMS).
    RETURN.
  END.

  RUN getAttribute IN hSecEd ("CURRENT-PROCEDURE":U , OUTPUT vString).
  ASSIGN PRecid = INTEGER(vString).

  RUN getInsertWidgetNameList IN hSecEd (OUTPUT vList, OUTPUT vItem).
  IF vList = ? THEN vList = "":u.

  /* Refresh the display if the design window has changed or the list
     has changed. List changes when user adds objects to a design window,
     renames a label, etc. */
  /* Problem here. Progress never thinks vList = s_PickList:LIST-ITEMS.
     Don't know why. But its causing the list to refresh everytime. */
  IF (vList <> s_PickList:LIST-ITEMS) OR (Curr_PRecid <> PRecid) THEN
  DO:
    ASSIGN Curr_PRecid = PRecid.

    ASSIGN s_PickList = "":u
           s_PickList:LIST-ITEMS = vList.
  
    ASSIGN s_PickList = vItem
           s_PickList:SCREEN-VALUE = s_PickList NO-ERROR.
  END.
  
  RETURN.
  
END. /* DO WITH FRAME {&FRAME-NAME} */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject sObject 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* We could have a comma as a item. This must match up with the delimiter
     the Section Editor uses for displaying widget names. */
  ASSIGN s_PickList:DELIMITER IN FRAME {&FRAME-NAME} = CHR(10).

  RUN refreshDisplay.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  
  /* Put focus in the insert window. Fixes 19990603-009 (jep). */ 
  RUN ApplyEntryCodeRef.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

