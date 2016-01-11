&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          asdb             PROGRESS
          rydb             PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
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

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBulder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT-OUTPUT PARAMETER pdSmartobjectObj  AS DECIMAL NO-UNDO.
DEFINE OUTPUT       PARAMETER plProceed         AS LOGICAL INITIAL FALSE.

/* Local Variable Definitions ---                                       */

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME brObjectType

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gsc_object_type ryc_smartobject

/* Definitions for BROWSE brObjectType                                  */
&Scoped-define FIELDS-IN-QUERY-brObjectType ~
gsc_object_type.object_type_description 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brObjectType 
&Scoped-define OPEN-QUERY-brObjectType OPEN QUERY brObjectType FOR EACH gsc_object_type NO-LOCK ~
    BY gsc_object_type.object_type_description INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brObjectType gsc_object_type
&Scoped-define FIRST-TABLE-IN-QUERY-brObjectType gsc_object_type


/* Definitions for BROWSE brSmartObject                                 */
&Scoped-define FIELDS-IN-QUERY-brSmartObject ~
ryc_smartobject.object_filename 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSmartObject 
&Scoped-define OPEN-QUERY-brSmartObject OPEN QUERY brSmartObject FOR EACH ryc_smartobject ~
      WHERE ryc_smartobject.object_type_obj = gsc_object_type.Object_Type_Obj NO-LOCK ~
    BY ryc_smartobject.object_filename INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSmartObject ryc_smartobject
&Scoped-define FIRST-TABLE-IN-QUERY-brSmartObject ryc_smartobject


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-brObjectType}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brObjectType brSmartObject Btn_OK Btn_Cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brObjectType FOR 
      gsc_object_type SCROLLING.

DEFINE QUERY brSmartObject FOR 
      ryc_smartobject SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brObjectType Dialog-Frame _STRUCTURED
  QUERY brObjectType NO-LOCK DISPLAY
      gsc_object_type.object_type_description FORMAT "X(35)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 31 BY 5 EXPANDABLE.

DEFINE BROWSE brSmartObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSmartObject Dialog-Frame _STRUCTURED
  QUERY brSmartObject NO-LOCK DISPLAY
      ryc_smartobject.object_filename FORMAT "X(70)":U WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 31 BY 13.33 ROW-HEIGHT-CHARS .71 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     brObjectType AT ROW 1.24 COL 2
     brSmartObject AT ROW 6.48 COL 2
     Btn_OK AT ROW 20.05 COL 2
     Btn_Cancel AT ROW 20.05 COL 18
     SPACE(0.59) SKIP(0.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Select a SmartObject"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
/* BROWSE-TAB brObjectType 1 Dialog-Frame */
/* BROWSE-TAB brSmartObject brObjectType Dialog-Frame */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brObjectType
/* Query rebuild information for BROWSE brObjectType
     _TblList          = "asdb.gsc_object_type"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "asdb.gsc_object_type.object_type_description|yes"
     _FldNameList[1]   = asdb.gsc_object_type.object_type_description
     _Query            is OPENED
*/  /* BROWSE brObjectType */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSmartObject
/* Query rebuild information for BROWSE brSmartObject
     _TblList          = "RYDB.ryc_smartobject"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "RYDB.ryc_smartobject.object_filename|yes"
     _Where[1]         = "RYDB.ryc_smartobject.object_type_obj = gsc_object_type.Object_Type_Obj"
     _FldNameList[1]   > RYDB.ryc_smartobject.object_filename
"object_filename" ? ? "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" ""
     _Query            is NOT OPENED
*/  /* BROWSE brSmartObject */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Select a SmartObject */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brObjectType
&Scoped-define SELF-NAME brObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brObjectType Dialog-Frame
ON ITERATION-CHANGED OF brObjectType IN FRAME Dialog-Frame
DO:
    {&OPEN-QUERY-brSmartObject}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSmartObject
&Scoped-define SELF-NAME brSmartObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSmartObject Dialog-Frame
ON MOUSE-SELECT-DBLCLICK OF brSmartObject IN FRAME Dialog-Frame
DO:
    DEFINE VARIABLE lLogicalObject AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cPhysicalObjectName AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cObjectPath AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cObjectDescription AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lProceed AS LOGICAL.

    DEFINE BUFFER lb_gsc_object FOR gsc_object.

    FIND FIRST gsc_object NO-LOCK 
        WHERE gsc_object.OBJECT_filename = ryc_smartobject.OBJECT_filename.
    IF gsc_object.LOGICAL_object THEN
    DO:
        lLogicalObject = TRUE.
        FIND FIRST lb_gsc_object NO-LOCK
            WHERE lb_gsc_object.OBJECT_obj = gsc_object.physical_object_obj.
        cPhysicalObjectName = lb_gsc_object.OBJECT_filename.
    END.
    ELSE cObjectPath = gsc_object.OBJECT_path.

    cObjectDescription = gsc_object.OBJECT_description.                                             

    DO TRANSACTION ON ERROR UNDO, LEAVE:
        FIND CURRENT ryc_smartobject EXCLUSIVE-LOCK.
        RUN ry/uib/rycsoeditd.w (
            INPUT-OUTPUT ryc_smartobject.Layout_Obj,
            INPUT-OUTPUT ryc_smartobject.Object_Type_Obj,
            INPUT-OUTPUT ryc_smartobject.Product_Module_Obj,
            INPUT-OUTPUT ryc_smartobject.Object_Filename,
            INPUT-OUTPUT ryc_smartobject.Custom_Super_Procedure,
            INPUT-OUTPUT ryc_smartobject.Static_Object,
            INPUT-OUTPUT ryc_smartobject.System_Owned,
            INPUT-OUTPUT ryc_smartobject.Template_smartobject,
            INPUT-OUTPUT lLogicalObject,
            INPUT-OUTPUT cPhysicalObjectName,
            INPUT-OUTPUT cObjectPath,
            INPUT-OUTPUT cObjectDescription,
            OUTPUT lProceed).
        IF NOT lProceed THEN UNDO, LEAVE.
        FIND CURRENT ryc_smartobject NO-LOCK.
    END.

    {af/sup2/afcheckerr.i &NO-RETURN=YES}

    brSmartObject:REFRESH() NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
    IF AVAILABLE ryc_smartobject THEN 
    DO:
        ASSIGN 
            pdSmartObjectObj = ryc_smartobject.smartobject_obj
            plProceed = TRUE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brObjectType
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN initialize.
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  ENABLE brObjectType brSmartObject Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialize Dialog-Frame 
PROCEDURE initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&OPEN-QUERY-brObjectType}
    APPLY "ITERATION-CHANGED":U TO brObjectType IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

