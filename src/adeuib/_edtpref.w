&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME dPreferences
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dPreferences 
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

  File: adeuib/_edtpref.w

  Description: Dialog for editing user preferences.  Uses ADM 1
               SmartObject technology.
  
  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Ross Hunter

  Created: 11/19/97
------------------------------------------------------------------------*/          
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Local Variable Definitions ---                                       */
{adeuib/sharvars.i}
{adeuib/uibhlp.i}          /* Help File Preprocessor Directives         */

&SCOPED-DEFINE ClientServerOnly _AB_License = 1 
&SCOPED-DEFINE WebSpeedOnly     _Ab_license = 2

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME dPreferences

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel Btn_Save Btn_Help 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD changeToPage dPreferences 
FUNCTION changeToPage RETURNS LOGICAL
  (pPage AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentPage dPreferences 
FUNCTION getCurrentPage RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vgenrl AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vgrid AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vprint AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vwebcon AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Save DEFAULT 
     LABEL "Save Settings" 
     SIZE 19 BY 1.14 TOOLTIP "Store these setting for future sessions."
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME dPreferences
     Btn_OK AT ROW 20.05 COL 3
     Btn_Cancel AT ROW 20.05 COL 19
     Btn_Save AT ROW 20.05 COL 45
     Btn_Help AT ROW 20.05 COL 74
     SPACE(1.39) SKIP(0.23)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Preferences".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Design Page: 3
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB dPreferences 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX dPreferences
                                                                        */
ASSIGN 
       FRAME dPreferences:SCROLLABLE       = FALSE
       FRAME dPreferences:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX dPreferences
/* Query rebuild information for DIALOG-BOX dPreferences
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX dPreferences */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME dPreferences
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dPreferences dPreferences
ON ALT-G OF FRAME dPreferences /* Preferences */
DO:
  changeToPage(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dPreferences dPreferences
ON ALT-P OF FRAME dPreferences /* Preferences */
DO:
  changeToPage(4).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dPreferences dPreferences
ON ALT-U OF FRAME dPreferences /* Preferences */
DO:
  changeToPage(3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dPreferences dPreferences
ON ALT-W OF FRAME dPreferences /* Preferences */
DO:
  changeToPage(2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dPreferences dPreferences
ON WINDOW-CLOSE OF FRAME dPreferences /* Preferences */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help dPreferences
ON CHOOSE OF Btn_Help IN FRAME dPreferences /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&AppBuilder_Preferences_Dialog}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK dPreferences
ON CHOOSE OF Btn_OK IN FRAME dPreferences /* OK */
DO:
  IF VALID-HANDLE(h_vgenrl) THEN
    RUN assign-new-values IN h_vgenrl.
  IF VALID-HANDLE(h_vwebcon) THEN DO:
    RUN assign-new-values IN h_vwebcon.
    IF RETURN-VALUE eq "Error":U THEN
      RETURN NO-APPLY.
  END.
  IF VALID-HANDLE(h_vgrid) THEN
    RUN assign-new-values IN h_vgrid.
  IF VALID-HANDLE(h_vprint) THEN
    RUN assign-new-values IN h_vprint.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Save dPreferences
ON CHOOSE OF Btn_Save IN FRAME dPreferences /* Save Settings */
DO:
  IF VALID-HANDLE(h_vgenrl) THEN
    RUN assign-new-values IN h_vgenrl.
  IF VALID-HANDLE(h_vwebcon) THEN
    RUN assign-new-values IN h_vwebcon.
  IF VALID-HANDLE(h_vgrid) THEN
    RUN assign-new-values IN h_vgrid.
  IF VALID-HANDLE(h_vprint) THEN
    RUN assign-new-values IN h_vprint.
    
  RUN adeuib/_putpref.p (INPUT TRUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dPreferences 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects dPreferences  _ADM-CREATE-OBJECTS
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
             INPUT  'adm2/folder.w':U ,
             INPUT  FRAME dPreferences:HANDLE ,
             INPUT  'FolderLabels':U + '&General|&WebSpeed|Grid &Units|&Print' + 'FolderTabWidth0FolderFont-1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 1.24 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 18.33 , 88.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN constructObject (
             INPUT  'adeuib/_vgenrl.w':U ,
             INPUT  FRAME dPreferences:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vgenrl ).
       RUN repositionObject IN h_vgenrl ( 3.10 , 6.00 ) NO-ERROR.
       /* Size in AB:  ( 15.71 , 63.00 ) */

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN constructObject (
             INPUT  'adeuib/_vwebcon.w':U ,
             INPUT  FRAME dPreferences:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vwebcon ).
       RUN repositionObject IN h_vwebcon ( 3.38 , 3.00 ) NO-ERROR.
       /* Size in AB:  ( 4.62 , 69.00 ) */

    END. /* Page 2 */

    WHEN 3 THEN DO:
       RUN constructObject (
             INPUT  'adeuib/_vgrid.w':U ,
             INPUT  FRAME dPreferences:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vgrid ).
       RUN repositionObject IN h_vgrid ( 4.67 , 7.00 ) NO-ERROR.
       /* Size in AB:  ( 9.24 , 74.80 ) */

    END. /* Page 3 */

    WHEN 4 THEN DO:
       RUN constructObject (
             INPUT  'adeuib/_vprint.w':U ,
             INPUT  FRAME dPreferences:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vprint ).
       RUN repositionObject IN h_vprint ( 4.10 , 6.00 ) NO-ERROR.
       /* Size in AB:  ( 3.86 , 64.00 ) */

       /* Adjust the tab order of the smart objects. */
    END. /* Page 4 */

  END CASE.
  /* Select a Startup page. */
  IF currentPage eq 0
  THEN RUN selectPage IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects dPreferences 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE iCurrentPage  AS INTEGER NO-UNDO.  
  RUN SUPER.
  iCurrentPage = DYNAMIC-FUNCTION('getCurrentPage':U).
  CASE iCurrentPage:
    WHEN 1 THEN RUN set-init IN h_vgenrl.
    WHEN 2 THEN RUN set-init IN h_vwebcon.
    WHEN 3 THEN RUN set-init IN h_vgrid.
    WHEN 4 THEN RUN set-init IN h_vprint.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dPreferences  _DEFAULT-DISABLE
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
  HIDE FRAME dPreferences.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI dPreferences  _DEFAULT-ENABLE
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
  ENABLE Btn_OK Btn_Cancel Btn_Save Btn_Help 
      WITH FRAME dPreferences.
  VIEW FRAME dPreferences.
  {&OPEN-BROWSERS-IN-QUERY-dPreferences}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dPreferences 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose: Remove and move folde tabs when not provision plus license     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLabels AS CHARACTER NO-UNDO.
  
  IF {&WebSpeedOnly} OR {&ClientServerOnly} THEN 
  DO:
    /* Make page 3 become page 2 */
    cLabels = DYNAMIC-FUNCTION('getFolderLabels':U IN h_folder).
    
    IF {&ClientServerOnly} THEN
       ENTRY(2,clabels,'|':U) = ENTRY(3,clabels,'|':U).

    ENTRY(3,clabels,'|':U) = ENTRY(4,clabels,'|':U).
    
    DYNAMIC-FUNCTION ('setFolderLabels':U IN h_folder,cLabels).
    
    RUN deleteFolderPage IN h_folder (4).
  END.  /* If client/server only */

  /* Dispatch standard ADM method.                             */
  RUN SUPER.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION changeToPage dPreferences 
FUNCTION changeToPage RETURNS LOGICAL
  (pPage AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose: Used by ALT-triggers  
    Notes:  
------------------------------------------------------------------------------*/ 
  CASE pPage:
     WHEN 4 THEN DO: 
        IF {&WebSpeedOnly} OR {&ClientServerOnly} THEN 
           pPage = 3. 
     END.
     WHEN 3 THEN DO:
        IF {&ClientServerOnly} THEN 
           pPage = 2. 
     END.
  END.  
  RUN selectPage(pPage).
  
  RETURN TRUE.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentPage dPreferences 
FUNCTION getCurrentPage RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return the visual page when running licenses that are missing pages. 
    Notes: used internally in this procedure. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iPage AS INT  NO-UNDO.  
  
  /* make sure we don't fool the folder */
  IF SOURCE-PROCEDURE <> THIS-PROCEDURE THEN
    RETURN SUPER().

  iPage = SUPER().
  CASE iPage:
     WHEN 3 THEN DO: 
        IF {&WebSpeedOnly} OR {&ClientServerOnly} THEN 
           RETURN 4. 
        ELSE 
          RETURN iPage. 
     END.
     WHEN 2 THEN DO:
        IF {&ClientServerOnly} THEN 
          RETURN 3. 
        ELSE 
          RETURN iPage.
     END.
  END.  
  RETURN iPage.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

