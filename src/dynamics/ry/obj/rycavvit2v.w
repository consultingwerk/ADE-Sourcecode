&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
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
       {"ry/obj/rycavful4o.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/* Copyright (C) 2005,2007 by Progress Software Corporation. All rights
   reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: rycavvit2v.w

  Description:  SmartObject Object Instance Attribute Va

  Purpose:      SmartObject Object Instance Attribute Value SmartDataViewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/17/2001  Author:     

  Update Notes: Changed Attribute vlaue to editor box.

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

&scop object-name       rycavvit2v.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}
{af/app/afdatatypi.i}

DEFINE VARIABLE glMaintain AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycavful4o.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.dAttributeGroupObj ~
RowObject.object_type_obj RowObject.primary_smartobject_obj ~
RowObject.smartobject_obj RowObject.container_smartobject_obj ~
RowObject.object_instance_obj RowObject.constant_value ~
RowObject.applies_at_runtime RowObject.date_value RowObject.decimal_value ~
RowObject.integer_value RowObject.character_value RowObject.logical_value 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS RECT-1 raLogicalValue fiAttrNarrative 
&Scoped-Define DISPLAYED-FIELDS RowObject.dAttributeGroupObj ~
RowObject.object_type_obj RowObject.primary_smartobject_obj ~
RowObject.smartobject_obj RowObject.container_smartobject_obj ~
RowObject.object_instance_obj RowObject.constant_value ~
RowObject.applies_at_runtime RowObject.date_value RowObject.decimal_value ~
RowObject.integer_value RowObject.character_value RowObject.logical_value ~
RowObject.data_type 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS toMaint toIncludeDesign fiDataTypeDesc ~
fiAttrNarrative toDesignOnly toRuntimeOnly toIsPrivate toSystemOwned ~
coConstantLevel cOverride fiLabel fiNarrativeLabel fiOverrideTypeLabel 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hAttributeGroupObj AS HANDLE NO-UNDO.
DEFINE VARIABLE hAttributeLabel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE coConstantLevel AS CHARACTER FORMAT "X(10)" INITIAL ? 
     LABEL "Constant level" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Instance Level",".",
                     "Class Level","Class",
                     "Master Level","Master"
     DROP-DOWN-LIST
     SIZE 24 BY 1 TOOLTIP "Lowest level where the value can be stored and changed (also through instances)".

DEFINE VARIABLE fiAttrNarrative AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 50 BY 3 NO-UNDO.

DEFINE VARIABLE fiDataTypeDesc AS CHARACTER FORMAT "X(15)":U 
     LABEL "Data type" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 TOOLTIP "Attribute Data Type Description" NO-UNDO.

DEFINE VARIABLE fiLabel AS CHARACTER FORMAT "X(20)":U INITIAL "Attribute value:" 
      VIEW-AS TEXT 
     SIZE 14.4 BY .62 NO-UNDO.

DEFINE VARIABLE fiNarrativeLabel AS CHARACTER FORMAT "X(20)":U INITIAL "Attribute narrative:" 
      VIEW-AS TEXT 
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE fiOverrideTypeLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Override type" 
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE VARIABLE iDataType AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 1.6 BY 1 NO-UNDO.

DEFINE VARIABLE cOverride AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "None", ""
     SIZE 66.8 BY 3 NO-UNDO.

DEFINE VARIABLE raLogicalValue AS LOGICAL 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "True", yes,
"False", no,
"Unknown", ?
     SIZE 33.6 BY .86 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68.8 BY 4.05.

DEFINE VARIABLE toDesignOnly AS LOGICAL INITIAL no 
     LABEL "Design only" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE toIncludeDesign AS LOGICAL INITIAL no 
     LABEL "Show design time attributes for lookup" 
     VIEW-AS TOGGLE-BOX
     SIZE 49.4 BY .81 NO-UNDO.

DEFINE VARIABLE toIsPrivate AS LOGICAL INITIAL no 
     LABEL "Is private" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE toMaint AS LOGICAL INITIAL no 
     LABEL "Maintain" 
     VIEW-AS TOGGLE-BOX
     SIZE 1 BY 1 NO-UNDO.

DEFINE VARIABLE toRuntimeOnly AS LOGICAL INITIAL no 
     LABEL "Runtime only" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE toSystemOwned AS LOGICAL INITIAL no 
     LABEL "System owned" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.6 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     toMaint AT ROW 1 COL 1
     iDataType AT ROW 1 COL 69.8 COLON-ALIGNED NO-LABEL
     RowObject.dAttributeGroupObj AT ROW 1 COL 72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1.6 BY 1
     RowObject.object_type_obj AT ROW 1 COL 75.6 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1.6 BY 1
     RowObject.primary_smartobject_obj AT ROW 1 COL 77.2 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1.2 BY 1
     RowObject.smartobject_obj AT ROW 1 COL 76.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1.6 BY 1
     RowObject.container_smartobject_obj AT ROW 2.05 COL 74.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1.4 BY 1
     RowObject.object_instance_obj AT ROW 2.05 COL 76.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1.4 BY 1
     toIncludeDesign AT ROW 2.1 COL 20.8
     RowObject.constant_value AT ROW 4.1 COL 20.6
          LABEL "Constant value"
          VIEW-AS TOGGLE-BOX
          SIZE 19.4 BY .81
     RowObject.applies_at_runtime AT ROW 4.1 COL 49
          LABEL "Applies at runtime"
          VIEW-AS TOGGLE-BOX
          SIZE 21.6 BY .81
     fiDataTypeDesc AT ROW 4.95 COL 18.6 COLON-ALIGNED
     RowObject.date_value AT ROW 6.05 COL 18.6 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 21.2 BY 1
     RowObject.decimal_value AT ROW 6.05 COL 18.6 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 50 BY 1
     RowObject.integer_value AT ROW 6.05 COL 18.6 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 50 BY 1
     RowObject.character_value AT ROW 6.05 COL 20.6 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 50 BY 4
     RowObject.logical_value AT ROW 6.1 COL 19.4
          LABEL "" FORMAT "yes/no":U
          VIEW-AS FILL-IN 
          SIZE 7.2 BY .81
     raLogicalValue AT ROW 6.1 COL 20.6 NO-LABEL
     fiAttrNarrative AT ROW 10.1 COL 20.6 NO-LABEL
     toDesignOnly AT ROW 10.14 COL 72.4
     toRuntimeOnly AT ROW 11.14 COL 72.4
     toIsPrivate AT ROW 12.05 COL 72.4
     toSystemOwned AT ROW 13 COL 72.4
     coConstantLevel AT ROW 13.19 COL 18.6 COLON-ALIGNED HELP
          "Constant level"
     RowObject.data_type AT ROW 13.19 COL 61.4 COLON-ALIGNED
          LABEL "Data type"
          VIEW-AS FILL-IN 
          SIZE 7.6 BY 1
     cOverride AT ROW 15.19 COL 21.8 NO-LABEL
     fiLabel AT ROW 6.24 COL 3.4 COLON-ALIGNED NO-LABEL
     fiNarrativeLabel AT ROW 9.1 COL 2.6 NO-LABEL
     fiOverrideTypeLabel AT ROW 14.43 COL 20.6 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 14.67 COL 20.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Compile into: ry/obj
   Data Source: "ry/obj/rycavful4o.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycavful4o.i}
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
         HEIGHT             = 18.57
         WIDTH              = 94.2.
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

/* SETTINGS FOR TOGGLE-BOX RowObject.applies_at_runtime IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR EDITOR RowObject.character_value IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.character_value:HIDDEN IN FRAME frMain           = TRUE
       RowObject.character_value:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* SETTINGS FOR COMBO-BOX coConstantLevel IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.constant_value IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.container_smartobject_obj IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.container_smartobject_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.container_smartobject_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR RADIO-SET cOverride IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject.data_type IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       RowObject.data_type:HIDDEN IN FRAME frMain           = TRUE
       RowObject.data_type:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.date_value IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.date_value:HIDDEN IN FRAME frMain           = TRUE
       RowObject.date_value:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR FILL-IN RowObject.dAttributeGroupObj IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.dAttributeGroupObj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.dAttributeGroupObj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR FILL-IN RowObject.decimal_value IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.decimal_value:HIDDEN IN FRAME frMain           = TRUE
       RowObject.decimal_value:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

ASSIGN 
       fiAttrNarrative:RETURN-INSERTED IN FRAME frMain  = TRUE
       fiAttrNarrative:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN fiDataTypeDesc IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiLabel IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Attribute value:".

/* SETTINGS FOR FILL-IN fiNarrativeLabel IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fiNarrativeLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Attribute narrative:".

/* SETTINGS FOR FILL-IN fiOverrideTypeLabel IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiOverrideTypeLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Override type".

/* SETTINGS FOR FILL-IN iDataType IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       iDataType:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.integer_value IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.integer_value:HIDDEN IN FRAME frMain           = TRUE
       RowObject.integer_value:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR FILL-IN RowObject.logical_value IN FRAME frMain
   ALIGN-L EXP-LABEL EXP-FORMAT                                         */
ASSIGN 
       RowObject.logical_value:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.object_instance_obj IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.object_instance_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.object_instance_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR FILL-IN RowObject.object_type_obj IN FRAME frMain
   ALIGN-L EXP-LABEL                                                    */
ASSIGN 
       RowObject.object_type_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.object_type_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR FILL-IN RowObject.primary_smartobject_obj IN FRAME frMain
   ALIGN-L EXP-LABEL                                                    */
ASSIGN 
       RowObject.primary_smartobject_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.primary_smartobject_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR RADIO-SET raLogicalValue IN FRAME frMain
   NO-DISPLAY                                                           */
ASSIGN 
       raLogicalValue:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.smartobject_obj IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.smartobject_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.smartobject_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR TOGGLE-BOX toDesignOnly IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX toIncludeDesign IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX toIsPrivate IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX toMaint IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       toMaint:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR TOGGLE-BOX toRuntimeOnly IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX toSystemOwned IN FRAME frMain
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME raLogicalValue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raLogicalValue vTableWin
ON VALUE-CHANGED OF raLogicalValue IN FRAME frMain
DO:
  ASSIGN rowObject.LOGICAL_value:SCREEN-VALUE = SELF:SCREEN-VALUE
         rowObject.LOGICAL_value:MODIFIED = TRUE.
  APPLY "VALUE-CHANGED" TO rowObject.LOGICAL_value. /* enable save button */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toIncludeDesign
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toIncludeDesign vTableWin
ON VALUE-CHANGED OF toIncludeDesign IN FRAME frMain /* Show design time attributes for lookup */
DO:
  DEFINE VARIABLE lModified AS LOGICAL    NO-UNDO.
  
  {get DataModified lModified}.

  ASSIGN toIncludeDesign.

/* commented out these lines as they make no sense whatsoever and cause issues 
   in modify when you tick on and off a few times - it loses the screen value 
*/
/*   IF toIncludeDesign:CHECKED = FALSE THEN                        */
/*     RUN assignNewValue IN hAttributeLabel ("z9z9","",lModified). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hContainer          AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hDataSource         AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hParentData         AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE cDataSource         AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cMode               AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cColValues          AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cLevel              AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cColumns            AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cColumnValue        AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE iLoop               AS INTEGER                      NO-UNDO.

    RUN SUPER.
    
    DO WITH FRAME {&FRAME-NAME}:
        {get DataSource cDataSource}.
        DO iLoop = 1 TO NUM-ENTRIES(cDataSource):
            ASSIGN hDataSource = WIDGET-HANDLE(ENTRY(iLoop, cDataSource)).
            IF VALID-HANDLE(hDataSource) THEN
            DO:
                /* Determine where we are */
                ASSIGN cLevel = DYNAMIC-FUNCTION("getSDOLevel":U IN hDataSource).

                {get DataSource hParentData hDataSource}.

                IF VALID-HANDLE(hParentData) THEN
                DO:
                    CASE cLevel:
                      WHEN "ObjectType":U THEN
                        ASSIGN cColumns = "object_type_obj":U.
                      WHEN "SmartObject":U THEN
                        ASSIGN cColumns = "smartobject_obj,object_type_obj":U.
                      WHEN "ObjectInstance":U THEN
                        ASSIGN cColumns = "container_smartobject_obj,smartobject_obj,object_type_obj,object_instance_obj":U.
                    END CASE.

                    ASSIGN cColValues = DYNAMIC-FUNCTION ("colValues" IN hParentData, INPUT cColumns).

                    CASE cLevel:
                      WHEN "ObjectType":U THEN DO:
                        DO WITH FRAME {&FRAME-NAME}:
                          ASSIGN RowObject.primary_smartobject_obj:SCREEN-VALUE   = "0":U
                                 RowObject.container_smartobject_obj:SCREEN-VALUE = "0":U
                                 RowObject.smartobject_obj:SCREEN-VALUE           = "0":U
                                 RowObject.object_type_obj:SCREEN-VALUE           = ENTRY(2, cColValues, CHR(1))
                                 RowObject.object_instance_obj:SCREEN-VALUE       = "0":U.
                        END.
                      END.
                      WHEN "SmartObject":U THEN DO:
                        DO WITH FRAME {&FRAME-NAME}:
                          ASSIGN RowObject.primary_smartobject_obj:SCREEN-VALUE   = ENTRY(2, cColValues, CHR(1))
                                 RowObject.container_smartobject_obj:SCREEN-VALUE = "0":U
                                 RowObject.smartobject_obj:SCREEN-VALUE           = ENTRY(2, cColValues, CHR(1))
                                 RowObject.object_type_obj:SCREEN-VALUE           = ENTRY(3, cColValues, CHR(1))
                                 RowObject.object_instance_obj:SCREEN-VALUE       = "0":U.
                        END.
                      END.
                      WHEN "ObjectInstance":U THEN DO:
                        DO WITH FRAME {&FRAME-NAME}:
                          ASSIGN RowObject.primary_smartobject_obj:SCREEN-VALUE   = ENTRY(2, cColValues, CHR(1))
                                 RowObject.container_smartobject_obj:SCREEN-VALUE = ENTRY(2, cColValues, CHR(1))
                                 RowObject.smartobject_obj:SCREEN-VALUE           = ENTRY(3, cColValues, CHR(1))
                                 RowObject.object_type_obj:SCREEN-VALUE           = ENTRY(4, cColValues, CHR(1))
                                 RowObject.object_instance_obj:SCREEN-VALUE       = ENTRY(5, cColValues, CHR(1)).
                        END.
                      END.
                    END CASE.
                END.    /* valid parent */
            END.    /* valid data source */
        END.    /* loop through data sources */
    END.    /* ADD mode */    

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_attribute_group.attribute_group_nameKeyFieldryc_attribute_group.attribute_group_objFieldLabelAttribute groupFieldTooltipSelect an attribute group from the listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH ryc_attribute_group NO-LOCK BY ryc_attribute_group.attribute_group_nameQueryTablesryc_attribute_groupSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1ComboDelimiterListItemPairsInnerLines5SortnoComboFlagAFlagValue0BuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldName<Local>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hAttributeGroupObj ).
       RUN repositionObject IN hAttributeGroupObj ( 1.00 , 20.60 ) NO-ERROR.
       RUN resizeObject IN hAttributeGroupObj ( 1.05 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_attribute.attribute_labelKeyFieldryc_attribute.attribute_labelFieldLabelAttribute labelFieldTooltipPress F4 for lookupKeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_attribute NO-LOCK INDEXED-REPOSITIONQueryTablesryc_attributeBrowseFieldsryc_attribute.attribute_label,ryc_attribute.attribute_narrative,ryc_attribute.system_ownedBrowseFieldDataTypescharacter,character,logicalBrowseFieldFormatsX(35)|X(500)|YES/NORowsToBatch200BrowseTitleLookup AttributeViewerLinkedFieldsryc_attribute.runtime_only,ryc_attribute.override_type,ryc_attribute.constant_level,ryc_attribute.data_type,ryc_attribute.design_only,ryc_attribute.is_private,ryc_attribute.attribute_narrative,ryc_attribute.system_ownedLinkedFieldDataTypeslogical,character,character,integer,logical,logical,character,logicalLinkedFieldFormatsYES/NO,X(3000),X(10),->>9,YES/NO,YES/NO,X(500),YES/NOViewerLinkedWidgetstoRuntimeOnly,fiDummy,fiDummy,iDataType,toDesignOnly,toIsPrivate,fiAttrNarrative,toSystemOwnedColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFielddAttributeGroupObj,dAttributeGroupObj,toIncludeDesign,toMaintParentFilterQuery(IF DECIMAL(~'&1~') <> 0 THEN ryc_attribute.attribute_group_obj = DECIMAL(~'&1~') ELSE TRUE) AND (IF ~'&3~' = ~'yes~' OR ~'&4~' = ~'no~' THEN TRUE ELSE ryc_attribute.design_only = FALSE)MaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCK INDEXED-REPOSITIONQueryBuilderOrderListQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNameattribute_labelDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hAttributeLabel ).
       RUN repositionObject IN hAttributeLabel ( 3.00 , 20.60 ) NO-ERROR.
       RUN resizeObject IN hAttributeLabel ( 1.00 , 50.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hAttributeGroupObj ,
             toMaint:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hAttributeLabel ,
             toIncludeDesign:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ComboValueChanged vTableWin 
PROCEDURE ComboValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcKeyValue    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcScreenValue AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phComboHandle AS HANDLE     NO-UNDO.

  IF phComboHandle = hAttributeGroupObj THEN 
    DO WITH FRAME {&FRAME-NAME}:
      ASSIGN RowObject.dAttributeGroupObj:SCREEN-VALUE = pcKeyValue.
    END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord vTableWin 
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hPropertysheet AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hProcedure     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cClass         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProp          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLevel         AS CHARACTER  NO-UNDO.

  /* Get the DataSource of the parent node */
  {get DataSource hSource}.
  ASSIGN cLevel = DYNAMIC-FUNCTION("getSDOLevel":U IN hSource).

  RUN SUPER.
  /* Refresh Class Cache */
  IF cLevel = "ObjectType":U THEN DO:
    {get DataSource hSource hSource}.
    ASSIGN cClass =  trim(DYNAMIC-FUNC("ColumnStringValue" IN hSource,"Object_type_code":U))
           cProp  =  trim(DYNAMIC-FUNC("getDataValue" IN hAttributeLabel ))
           NO-ERROR.
    
    IF RETURN-VALUE <> "ADM-ERROR":U 
    THEN DO:
       hProcedure = SESSION:FIRST-PROCEDURE.
       DO WHILE VALID-HANDLE(hProcedure) AND hProcedure:FILE-NAME NE "ry/prc/ryvobplipp.p":U:
         hProcedure = hProcedure:NEXT-SIBLING.
       END.
       IF VALID-HANDLE(hProcedure) THEN
       DO:
          
          RUN refreshProperty IN hProcedure 
              (INPUT cClass,
               INPUT cProp,
               INPUT "Delete":U,
               INPUT "Attribute":U
               ) NO-ERROR.
       END.
       ELSE DO:
          RUN destroyClassCache IN gshRepositoryManager.
       END.
  
    END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields vTableWin 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcFieldType AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcFieldType).

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN glMaintain                = FALSE
           toIncludeDesign:SENSITIVE = FALSE
           raLogicalValue:SENSITIVE  = FALSE.
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
  ASSIGN iDataType:SCREEN-VALUE IN FRAME {&FRAME-NAME} = rowObject.data_type:SCREEN-VALUE.
  RUN setDataTypeFields.
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN toMaint:CHECKED = glMaintain
           toMaint:HIDDEN  = TRUE.
    {set DataValue RowObject.dAttributeGroupObj:SCREEN-VALUE hAttributeGroupObj}.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields vTableWin 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN glMaintain                = TRUE
           toIncludeDesign:SENSITIVE = TRUE
           fiAttrNarrative:READ-ONLY = TRUE
           raLogicalValue:SENSITIVE  = TRUE.
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
  SUBSCRIBE TO "lookupDisplayComplete":U IN THIS-PROCEDURE.
  SUBSCRIBE TO "ComboValueChanged":U IN THIS-PROCEDURE.
  DO WITH FRAME {&FRAME-NAME}:
   ASSIGN 
    cOverride:DELIMITER = CHR(1)  
    cOverride:RADIO-BUTTONS =
         "None - Allow direct access to attribute value" + CHR(1) + '':U + CHR(1)
       + "Get  - Force value to be retrieved using get function" + CHR(1) + "GET" + CHR(1)
       + "Set  - Force value to be saved using set function" + CHR(1) + "SET" + CHR(1)
       + "Both - Force use of both set and get functions" + CHR(1) + "GET,SET".
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupDisplayComplete vTableWin 
PROCEDURE lookupDisplayComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFieldList     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcFieldValues   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcKeyValye      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phLookupHandle  AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cConstantLevel AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOverrideType  AS CHARACTER  NO-UNDO.

  IF phLookupHandle = hAttributeLabel AND 
     pcFieldValues <> "":U THEN DO:
    ASSIGN cConstantLevel = ENTRY(LOOKUP("ryc_attribute.constant_level",pcFieldList),pcFieldValues,CHR(1))
           cOverrideType  = ENTRY(LOOKUP("ryc_attribute.override_type",pcFieldList),pcFieldValues,CHR(1)) NO-ERROR.
    IF cConstantLevel = ? OR
       cConstantLevel = "?":U THEN
      cConstantLevel = ".":U.
    IF cOverrideType = ? OR
       cOverrideType = "?":U THEN
      cOverrideType = "":U.
    DO WITH FRAME {&FRAME-NAME}:
      /* Ensure we make the combo blank before we assign the new value - issue #10332 */
      ASSIGN coConstantLevel:LIST-ITEM-PAIRS = coConstantLevel:LIST-ITEM-PAIRS.
      ASSIGN coConstantLevel:SCREEN-VALUE = cConstantLevel
             cOverride:SCREEN-VALUE       = cOverrideType
             toIncludeDesign:CHECKED      = toDesignOnly:CHECKED.
    END.
    RUN setDataTypeFields.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDataTypeFields vTableWin 
PROCEDURE setDataTypeFields :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will check the data type of the attribute selected
               and hide and view the appropriate field to be updated.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN RowObject.character_value:HIDDEN    = TRUE
           RowObject.character_value:SENSITIVE = RowObject.constant_value:SENSITIVE
           RowObject.decimal_value:HIDDEN   = TRUE
           RowObject.decimal_value:HIDDEN   = TRUE
           RowObject.integer_value:HIDDEN   = TRUE
           RowObject.logical_value:HIDDEN   = TRUE
           RowObject.date_value:HIDDEN      = TRUE
           raLogicalValue:HIDDEN            = TRUE
           fiDataTypeDesc:SCREEN-VALUE      = "":U
           fiAttrNarrative:ROW              = 7.1
           fiNarrativeLabel:ROW             = 7.1
           fiAttrNarrative:HEIGHT           = 5.95.
    CASE INTEGER(iDataType:SCREEN-VALUE):
        WHEN {&CHARACTER-DATA-TYPE} THEN 
          ASSIGN RowObject.character_value:HIDDEN    = FALSE
                 RowObject.character_value:SENSITIVE = RowObject.constant_value:SENSITIVE
                 fiDataTypeDesc:SCREEN-VALUE         = "CHARACTER":U
                 fiAttrNarrative:HEIGHT              = 3
                 fiAttrNarrative:ROW                 = 10.05
                 fiNarrativeLabel:ROW                = 10.05.
        WHEN {&DECIMAL-DATA-TYPE} THEN 
          ASSIGN RowObject.decimal_value:HIDDEN    = FALSE
                 RowObject.decimal_value:SENSITIVE = RowObject.constant_value:SENSITIVE
                 fiDataTypeDesc:SCREEN-VALUE         = "DECIMAL":U.
        WHEN {&INTEGER-DATA-TYPE} THEN 
          ASSIGN RowObject.integer_value:HIDDEN    = FALSE
                 RowObject.integer_value:SENSITIVE = RowObject.constant_value:SENSITIVE
                 fiDataTypeDesc:SCREEN-VALUE         = "INTEGER":U.
        WHEN {&LOGICAL-DATA-TYPE} THEN 
          ASSIGN raLogicalValue:SCREEN-VALUE = rowobject.LOGICAL_value:SCREEN-VALUE
                 raLogicalValue:HIDDEN    = FALSE
                 raLogicalValue:SENSITIVE = RowObject.constant_value:SENSITIVE
                 fiDataTypeDesc:SCREEN-VALUE         = "LOGICAL":U.
        WHEN {&DATE-DATA-TYPE} THEN 
          ASSIGN RowObject.date_value:HIDDEN    = FALSE
                 RowObject.date_value:SENSITIVE = RowObject.constant_value:SENSITIVE
            fiDataTypeDesc:SCREEN-VALUE         = "DATE":U.
        WHEN {&RAW-DATA-TYPE} THEN
            fiDataTypeDesc:SCREEN-VALUE = "RAW":U.
    END CASE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hPropertysheet AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hProcedure     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNew           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLevel         AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  
  {get NewRecord cNew}.
  RUN SUPER.
  
  /* Code placed here will execute AFTER standard behavior.    */
  IF RETURN-VALUE <> "ADM-ERROR":U 
  THEN DO:
     hProcedure = SESSION:FIRST-PROCEDURE.
     DO WHILE VALID-HANDLE(hProcedure) AND hProcedure:FILE-NAME NE "ry/prc/ryvobplipp.p":U:
       hProcedure = hProcedure:NEXT-SIBLING.
     END.
     
     {get DataSource hSource}.
     ASSIGN cLevel = DYNAMIC-FUNCTION("getSDOLevel":U IN hSource).
     
     IF VALID-HANDLE(hProcedure) AND 
        cLevel = "ObjectType" THEN
     DO:
        /* Get the DataSource of the parent node */
        {get DataSource hSource hSource}.
       
        RUN refreshProperty IN hProcedure 
            (INPUT trim(DYNAMIC-FUNC("ColumnStringValue" IN hSource,"Object_type_code":U)),
             INPUT trim(DYNAMIC-FUNC("getDataValue" IN hAttributeLabel )),
             INPUT IF cNew = "ADD" OR cNew = "Copy":U THEN "Add":U ELSE "Modifiy":U ,
             INPUT "Attribute":U
             ) NO-ERROR.
     END.
     ELSE DO:
        RUN destroyClassCache IN gshRepositoryManager.
     END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

