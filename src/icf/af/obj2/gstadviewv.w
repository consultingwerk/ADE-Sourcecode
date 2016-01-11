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
       {"af/obj2/gstadfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
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
/*---------------------------------------------------------------------------------
  File: gstadviewv.w

  Description:  Audit Static SDV

  Purpose:      Audit Static SDV

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000167   UserRef:    
                Date:   13/07/2001  Author:     Pieter Meyer

  Update Notes: Created from Template rysttviewv.w

  (v:010001)    Task:   101000035   UserRef:    
                Date:   09/28/2001  Author:     Johan Meyer

  Update Notes: Change use the information in entity_key_field for tables that do not have object numbers.

--------------------------------------------------------------------------------*/
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

&scop object-name       gstadviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

DEFINE VARIABLE ghWindow                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerHandle           AS HANDLE     NO-UNDO.

DEFINE VARIABLE ghBrowse                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTable                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBuffer                    AS HANDLE     NO-UNDO.

DEFINE TEMP-TABLE ttAudit NO-UNDO RCODE-INFORMATION
            FIELD ttAFieldName AS CHARACTER FORMAT "X(20)":U COLUMN-LABEL "Field Name":U
            FIELD ttAValueNew  AS CHARACTER FORMAT "X(40)":U COLUMN-LABEL "Value New":U
            FIELD ttAValueOld  AS CHARACTER FORMAT "X(40)":U COLUMN-LABEL "Value Old":U
            INDEX tiAkey1      AS PRIMARY
                  ttAFieldName
            .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gstadfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define DISPLAYED-FIELDS RowObject.owning_entity_mnemonic ~
RowObject.audit_date RowObject.audit_time_str ~
RowObject.entity_mnemonic_description RowObject.user_login_name ~
RowObject.audit_action RowObject.program_procedure ~
RowObject.owning_reference RowObject.program_name RowObject.old_detail ~
RowObject.entity_object_field RowObject.entity_key_field 
&Scoped-Define DISPLAYED-OBJECTS cOwningEntityKeyField 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cOwningEntityKeyField AS CHARACTER FORMAT "X(256)":U 
     LABEL "Owning Entity Key Field" 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.owning_entity_mnemonic AT ROW 1 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.6 BY 1
     RowObject.audit_date AT ROW 1 COL 85 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.audit_time_str AT ROW 1 COL 125 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     RowObject.entity_mnemonic_description AT ROW 2.14 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1
     RowObject.user_login_name AT ROW 2.14 COL 85 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.audit_action AT ROW 2.14 COL 125 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     cOwningEntityKeyField AT ROW 3.19 COL 28 COLON-ALIGNED
     RowObject.program_procedure AT ROW 3.29 COL 85 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 52 BY 1
     RowObject.owning_reference AT ROW 4.24 COL 29.8 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 3000 SCROLLBAR-VERTICAL LARGE
          SIZE 38 BY 1.14
     RowObject.program_name AT ROW 4.43 COL 85 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 52 BY 1
     RowObject.old_detail AT ROW 5.48 COL 30.2 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 10000 SCROLLBAR-VERTICAL LARGE
          SIZE 109.2 BY 8.19
     RowObject.entity_object_field AT ROW 13.76 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1
     RowObject.entity_key_field AT ROW 14.76 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gstadfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gstadfullo.i}
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
         HEIGHT             = 14.95
         WIDTH              = 140.
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

/* SETTINGS FOR FILL-IN RowObject.audit_action IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.audit_action:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.audit_date IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.audit_date:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.audit_time_str IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.audit_time_str:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN cOwningEntityKeyField IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject.entity_key_field IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.entity_key_field:HIDDEN IN FRAME frMain           = TRUE
       RowObject.entity_key_field:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.entity_mnemonic_description IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.entity_mnemonic_description:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.entity_object_field IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.entity_object_field:HIDDEN IN FRAME frMain           = TRUE
       RowObject.entity_object_field:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR EDITOR RowObject.old_detail IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.old_detail:HIDDEN IN FRAME frMain           = TRUE
       RowObject.old_detail:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.owning_entity_mnemonic IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.owning_entity_mnemonic:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR EDITOR RowObject.owning_reference IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.owning_reference:HIDDEN IN FRAME frMain           = TRUE
       RowObject.owning_reference:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.program_name IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.program_name:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.program_procedure IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.program_procedure:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.user_login_name IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.user_login_name:READ-ONLY IN FRAME frMain        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildBrowser vTableWin 
PROCEDURE buildBrowser :
/*------------------------------------------------------------------------------
  Purpose:     Construct dynamic browser onto viewer for audit
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cQuery                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrowseColHdls            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLookup                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValue                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkHandles              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrowseLabels             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerSource          AS HANDLE     NO-UNDO.

  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hLoopValue                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCurValue                 AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    /* populate temp-table */
    ASSIGN
      ghTable  = TEMP-TABLE ttAudit:HANDLE
      ghBuffer = ghTable:DEFAULT-BUFFER-HANDLE
      .

    RUN buildEntityField.
    RUN buildTempTable (INPUT NO).

    CREATE QUERY ghQuery.
    ghQuery:ADD-BUFFER(ghBuffer).
    ASSIGN cQuery = "FOR EACH ttAudit NO-LOCK":U.
    ghQuery:QUERY-PREPARE(cQuery).

    /* Create the dynamic browser here */

    /* make the viewer as big as it can be to fit on tab page */
    DEFINE VARIABLE hFrame                AS HANDLE  NO-UNDO.
    DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
    DEFINE VARIABLE dHeight               AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dWidth                AS DECIMAL NO-UNDO.

    FRAME {&FRAME-NAME}:HEIGHT-PIXELS = ghWindow:HEIGHT-PIXELS - 70 .
    FRAME {&FRAME-NAME}:WIDTH-PIXELS  = ghWindow:WIDTH-PIXELS  - 28 .

    CREATE BROWSE ghBrowse
      ASSIGN FRAME              = FRAME {&FRAME-NAME}:HANDLE
        ROW                     = 5.66
        COL                     = 1.5
        WIDTH-CHARS             = FRAME {&FRAME-NAME}:WIDTH-CHARS   - 2
        HEIGHT-PIXELS           = FRAME {&FRAME-NAME}:HEIGHT-PIXELS - 110
        SEPARATORS              = TRUE
        ROW-MARKERS             = FALSE
        EXPANDABLE              = TRUE
        COLUMN-RESIZABLE        = TRUE
        COLUMN-SCROLLING        = TRUE
        ALLOW-COLUMN-SEARCHING  = NO
        READ-ONLY               = NO
        QUERY                   = ghQuery
        .

    /* Hide the browse while it is repopulated to avoid flashing */
    ghBrowse:VISIBLE   = NO.
    ghBrowse:SENSITIVE = NO.
    ghBrowse:MODIFIED  = NO.

    /* Add fields to browser */
    field-loop:
    DO iLoop = 1 TO ghBuffer:NUM-FIELDS:

      hLoopValue = ghBuffer:BUFFER-FIELD(iLoop).
      hCurValue  = ghBrowse:ADD-LIKE-COLUMN(hLoopValue).

      /* Build up the list of browse columns for use in rowDisplay */
      IF VALID-HANDLE(hCurValue)
      THEN
        cBrowseColHdls = cBrowseColHdls
                       + (IF cBrowseColHdls = "":U THEN "":U ELSE ",":U) 
                       + STRING(hCurValue).

    END.

    column-loop:
    DO iLoop = 1 TO ghBrowse:NUM-COLUMNS:

      IF iLoop = 1
      THEN
        ASSIGN
          hCurValue  = ghBrowse:FIRST-COLUMN.
      ELSE
        ASSIGN
          hLoopValue = hCurValue:NEXT-COLUMN
          hCurValue  = hLoopValue.

      ASSIGN
        hCurValue:WIDTH-PIXELS = ( ghBrowse:WIDTH-PIXELS / ghBrowse:NUM-COLUMNS ).

    END.

    /* Now open the query */
    ghQuery:QUERY-OPEN().
    APPLY "VALUE-CHANGED":U TO ghBrowse.

    /* And show the browse to the user */
    FRAME {&FRAME-NAME}:VISIBLE = FALSE.
    ghBrowse:VISIBLE            = YES.
    ghBrowse:SENSITIVE          = YES.
    FRAME {&FRAME-NAME}:VISIBLE = TRUE.

    APPLY "ENTRY":U TO ghBrowse.

    {set DataModified FALSE}.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildEntityField vTableWin 
PROCEDURE buildEntityField :
/*------------------------------------------------------------------------------
  Purpose:     buildEntityField
  Parameters:  <none>
  Notes:       Follows the joins to a table and assigns the fields to display
------------------------------------------------------------------------------*/
DEFINE VARIABLE cLabel AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    
    RUN getEntityDisplayField IN gshGenManager
      (INPUT  RowObject.owning_entity_mnemonic:INPUT-VALUE
      ,INPUT  RowObject.owning_reference:INPUT-VALUE 
      ,OUTPUT cLabel
      ,OUTPUT cOwningEntityKeyField
      ).
    
    ASSIGN 
      cOwningEntityKeyField:SCREEN-VALUE = cOwningEntityKeyField
      cOwningEntityKeyField:LABEL        = cLabel.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildTempTable vTableWin 
PROCEDURE buildTempTable :
/*------------------------------------------------------------------------------
  Purpose:     To build temp-table of audit changed fields
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER plOpenQuery              AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE iLoop                           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLoopEntry                      AS CHARACTER  NO-UNDO.

  /* 1st empty current temp-table contents */
  EMPTY TEMP-TABLE ttAudit.

  DO WITH FRAME {&FRAME-NAME}:

    detail-loop:
    DO iLoop = 1 TO NUM-ENTRIES(RowObject.old_detail:INPUT-VALUE , CHR(5)):

      ASSIGN
        iLoopEntry = ENTRY( iLoop , RowObject.old_detail:INPUT-VALUE , CHR(5) ).

      CREATE ttAudit.

      IF NUM-ENTRIES( iLoopEntry , CHR(6) ) >  0 THEN ASSIGN ttAFieldName = ENTRY(  1 , iLoopEntry, CHR(6) ).
      IF NUM-ENTRIES( iLoopEntry , CHR(6) ) >  1 THEN ASSIGN ttAValueNew  = ENTRY(  2 , iLoopEntry, CHR(6) ).
      IF NUM-ENTRIES( iLoopEntry , CHR(6) ) >  2 THEN ASSIGN ttAValueOld  = ENTRY(  3 , iLoopEntry, CHR(6) ).

    END. /* detail-loop */

  END.

  /* Re-open query if required */
  IF plOpenQuery
  THEN DO:
    ghQuery:QUERY-OPEN().
    APPLY "VALUE-CHANGED":U TO ghBrowse.
    APPLY "ENTRY":U TO ghBrowse.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields vTableWin 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcColValues).

  /* Code placed here will execute AFTER standard behavior.    */

  IF  ghWindow          <> ?
  AND ghContainerHandle <> ?
  THEN
    RUN buildBrowser.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior. */

  ghContainerHandle = DYNAMIC-FUNCTION('getContainerSource' IN THIS-PROCEDURE).

  {get ContainerHandle ghWindow ghContainerHandle}.

  RUN buildBrowser.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

