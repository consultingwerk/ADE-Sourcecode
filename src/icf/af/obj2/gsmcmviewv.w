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
       {"af/obj2/gsmcmfullo.i"}.


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
  File: gsmcmviewv.w

  Description:  Comments SDV

  Purpose:      Comments SDV

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000167   UserRef:    
                Date:   16/07/2001  Author:     Pieter Meyer

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

&scop object-name       gsmcmviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

DEFINE VARIABLE cOwningEntityMnemonic         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOwningReference              AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmcmfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.comment_description ~
RowObject.comment_text RowObject.expiry_date RowObject.auto_display ~
RowObject.print_option_tlas 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.comment_description ~
RowObject.comment_text RowObject.expiry_date RowObject.auto_display ~
RowObject.print_option_tlas RowObject.owning_reference ~
RowObject.owning_entity_mnemonic 
&Scoped-Define DISPLAYED-OBJECTS cOwningEntityKeyField 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_gsmcad2sfv AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE cOwningEntityKeyField AS CHARACTER FORMAT "X(256)":U 
     LABEL "Owning Entity Key Field" 
     VIEW-AS FILL-IN 
     SIZE 39.4 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.comment_description AT ROW 2.24 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 72 BY 1
     RowObject.comment_text AT ROW 3.33 COL 31 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 3000 SCROLLBAR-VERTICAL LARGE
          SIZE 70 BY 8
     RowObject.expiry_date AT ROW 11.43 COL 29.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.auto_display AT ROW 12.43 COL 31.2
          VIEW-AS TOGGLE-BOX
          SIZE 16.8 BY .81
     RowObject.print_option_tlas AT ROW 13.24 COL 13.4
          VIEW-AS FILL-IN 
          SIZE 72 BY 1
     cOwningEntityKeyField AT ROW 14.33 COL 29.4 COLON-ALIGNED
     RowObject.owning_reference AT ROW 15.43 COL 29.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40 BY 1
     RowObject.owning_entity_mnemonic AT ROW 15.43 COL 87.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.6 BY 1
     "Comment Text:" VIEW-AS TEXT
          SIZE 14.4 BY .62 AT ROW 3.48 COL 15.4
     SPACE(73.80) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmcmfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmcmfullo.i}
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
         HEIGHT             = 15.43
         WIDTH              = 102.6.
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

/* SETTINGS FOR FILL-IN cOwningEntityKeyField IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject.owning_entity_mnemonic IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.owning_entity_mnemonic:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.owning_reference IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.owning_reference:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.print_option_tlas IN FRAME frMain
   ALIGN-L                                                              */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
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
             INPUT  'af/obj2/gsmcad2sfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNamecategory_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gsmcad2sfv ).
       RUN repositionObject IN h_gsmcad2sfv ( 1.00 , 18.40 ) NO-ERROR.
       RUN resizeObject IN h_gsmcad2sfv ( 1.05 , 85.20 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_gsmcad2sfv ,
             RowObject.comment_description:HANDLE IN FRAME frMain , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE constructObject vTableWin 
PROCEDURE constructObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcProcName AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER phParent   AS HANDLE NO-UNDO.
  DEFINE INPUT  PARAMETER pcPropList AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER phObject   AS HANDLE NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cFieldName AS CHARACTER NO-UNDO.
  
  RUN SUPER( INPUT pcProcName, INPUT phParent, INPUT pcPropList, OUTPUT phObject).
  
  /* Code placed here will execute AFTER standard behavior.    */
  IF VALID-HANDLE(gshGenManager) AND
     LOOKUP("getPropertyFromList":U, gshGenManager:INTERNAL-ENTRIES) <> 0 THEN
    ASSIGN cFieldName = DYNAMIC-FUNCTION("getPropertyFromList":U IN gshGenManager, INPUT pcPropList, INPUT "FieldName":U).
    
  CASE cFieldname:  
    WHEN "category_obj":U THEN DO:
      DYNAMIC-FUNCTION("setUserProperty":U IN phObject, "CategoryType":U, "NOT":U).
      /*DYNAMIC-FUNCTION("setUserProperty":U IN phObject, "CategoryGroup":U, "INV":U).
      DYNAMIC-FUNCTION("setUserProperty":U IN phObject, "CategorySubGroup":U, "PRN":U).
      DYNAMIC-FUNCTION("setUserProperty":U IN phObject, "ComboLabelOverride":U, "Invoice Print Procedure":U).*/
    END.
  END CASE.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable vTableWin 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcRelative).

  /* Code placed here will execute AFTER standard behavior.    */
/*
  RUN entityUpdateDetail.
*/
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

  DO WITH FRAME {&FRAME-NAME}:
    IF RowObject.owning_entity_mnemonic:SCREEN-VALUE = "":U
    THEN ASSIGN RowObject.owning_entity_mnemonic:SCREEN-VALUE = cOwningEntityMnemonic.
    IF RowObject.owning_reference:SCREEN-VALUE = "":U
    THEN ASSIGN RowObject.owning_reference:SCREEN-VALUE = cOwningReference.
  END.
  RUN entityUpdateDetail.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE entitySetDetail vTableWin 
PROCEDURE entitySetDetail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hDataSource                   AS WIDGET-HANDLE NO-UNDO.

  DEFINE VARIABLE cOwningEntityMnemonicFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOwningEntityMnemonicValues   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOwningEntityMnemonicKeyField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOwningEntityMnemonicObjField AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    {get DataSource hDataSource}.

    ASSIGN
      cOwningEntityMnemonic = DYNAMIC-FUNCTION("getUserProperty":U  IN hDataSource , "OwningEntityMnemonic":U)
      cOwningReference      = DYNAMIC-FUNCTION("getUserProperty":U  IN hDataSource , "OwningReference":U)
      cOwningReference      = cOwningReference.

    ASSIGN
      RowObject.owning_entity_mnemonic:SCREEN-VALUE = cOwningEntityMnemonic
      RowObject.owning_reference:SCREEN-VALUE       = cOwningReference
      .

    IF VALID-HANDLE(gshGenManager)
    AND cOwningEntityMnemonic <> "":U
    THEN
      RUN getEntityDetail IN gshGenManager
                         (INPUT  cOwningEntityMnemonic
                         ,OUTPUT cOwningEntityMnemonicFields
                         ,OUTPUT cOwningEntityMnemonicValues
                         ).

    IF cOwningEntityMnemonicFields <> "":U
    THEN DO:
      IF LOOKUP("entity_object_field",cOwningEntityMnemonicFields,CHR(1)) <> 0
      THEN ASSIGN cOwningEntityMnemonicObjField = ENTRY( LOOKUP("entity_object_field",cOwningEntityMnemonicFields,CHR(1)) ,cOwningEntityMnemonicValues,CHR(1) ).
      IF LOOKUP("entity_key_field",cOwningEntityMnemonicFields,CHR(1)) <> 0
      THEN ASSIGN cOwningEntityMnemonicKeyField = ENTRY( LOOKUP("entity_key_field",cOwningEntityMnemonicFields,CHR(1))    ,cOwningEntityMnemonicValues,CHR(1) ).
    END.

    /* Have to do this for multi-component key fields - the ',' confuses some other stuff */
    ASSIGN cOwningEntityMnemonicObjField = REPLACE(cOwningEntityMnemonicKeyField,",":U,CHR(2))
           cOwningEntityMnemonicKeyField = REPLACE(cOwningEntityMnemonicKeyField,",":U,CHR(2)).

    IF cOwningEntityMnemonicObjField <> "":U
    THEN ASSIGN RowObject.owning_reference:LABEL  = REPLACE(TRIM(cOwningEntityMnemonicObjField),CHR(2),"/":U).
    
    IF cOwningEntityMnemonicKeyField <> "":U AND
       (cOwningEntityKeyField:LABEL = "Owning Entity Key Field":U OR
        cOwningEntityKeyField:LABEL = "":U)
    THEN ASSIGN cOwningEntityKeyField:LABEL = REPLACE(TRIM(cOwningEntityMnemonicKeyField),CHR(2),"/":U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE entityUpdateDetail vTableWin 
PROCEDURE entityUpdateDetail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hDataSource          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLabel               AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    {get DataSource hDataSource}.
    {get ContainerSource hContainerSource}.

    ASSIGN  
      cOwningEntityMnemonic = DYNAMIC-FUNCTION("getUserProperty":U IN hDataSource, "OwningEntityMnemonic":U)
      cOwningReference      = DYNAMIC-FUNCTION("getUserProperty":U IN hDataSource, "OwningReference":U)
      cOwningReference      = cOwningReference.

    ASSIGN
      RowObject.owning_reference:SCREEN-VALUE       = cOwningReference
      RowObject.owning_entity_mnemonic:SCREEN-VALUE = cOwningEntityMnemonic.

   IF VALID-HANDLE(gshGenManager) THEN
    RUN getEntityDisplayField IN gshGenManager
      (INPUT  cOwningEntityMnemonic
      ,INPUT  REPLACE(cOwningReference,CHR(2),CHR(1)) /* Since this procedure excepts list with chr(1) delimited */
      ,OUTPUT cLabel
      ,OUTPUT cOwningEntityKeyField
      ).
    IF cOwningEntityKeyField = "":U THEN
      cOwningEntityKeyField = cOwningReference.
    ASSIGN 
      cOwningEntityKeyField:SCREEN-VALUE = IF NUM-ENTRIES(cOwningEntityKeyField,CHR(2)) > 1 THEN REPLACE(cOwningEntityKeyField,CHR(2)," & ":U) ELSE cOwningEntityKeyField
      cOwningEntityKeyField:LABEL        = IF cLabel <> "":U THEN cLabel ELSE cOwningEntityKeyField:LABEL.
  END.

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

  /* Code placed here will execute AFTER standard behavior.    */

  RUN entitySetDetail.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator vTableWin 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
  RUN "af\obj2\gsmcad2sfv.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

