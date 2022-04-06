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
       {"ry/obj/rycsoful2o.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/* Copyright (C) 2000,2007 by Progress Software Corporation. All rights
   reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: rycsovie2v.w

  Description:  Smart Object Viewer

  Purpose:      Smart Object Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        7462   UserRef:    
                Date:   03/01/2001  Author:     Jenny Bond

  Update Notes: Created from Template rysttviewv.w

  (v:010001)    Task:        7748   UserRef:    
                Date:   30/01/2001  Author:     Jenny Bond

  Update Notes: Complete Smart Object Maintenance

  Modified: Mark Davies (MIP)     09/25/2001
            Replace references to KeyFieldValue by DataValue

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

&scop object-name       rycsovie2v.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes


&SCOPED-DEFINE RycpaUpdateButtons buRycpaAdd buRycpaDelete buRycpaUpdate
&SCOPED-DEFINE RycpaSaveButtons buRycpaSave buRycpaCancel
&SCOPED-DEFINE RycpaFields coLayout fiPageLabel fiPageSeq fiSecurityToken ToCreate ToModify ToView
&SCOPED-DEFINE RycoiUpdateButtons buRycoiAdd buRycoiDelete buRycoiUpdate
&SCOPED-DEFINE RycoiSaveButtons buRycoiSave buRycoiCancel
&SCOPED-DEFINE RycoiFields coPage fiLayoutPosition
&SCOPED-DEFINE RycavUpdateButtons buRycavAdd buRycavDelete buRycavUpdate
&SCOPED-DEFINE RycavSaveButtons buRycavSave buRycavCancel
&SCOPED-DEFINE RycavFields coAttributeGroup coAttribute fiAttributeValue ToConstant ToInherited
&SCOPED-DEFINE RycsmUpdateButtons buRycsmAdd buRycsmDelete buRycsmUpdate
&SCOPED-DEFINE RycsmSaveButtons buRycsmSave buRycsmCancel
&SCOPED-DEFINE RycsmFields coLink coSourceLink coTargetLink


&SCOPED-DEFINE num-tables 2
{af/sup2/afglobals.i}

DEFINE VARIABLE gcUIBMode   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE dObject     AS DECIMAL      NO-UNDO INITIAL 0.


{af/sup2/afttcombo.i}

DEFINE VARIABLE gcDataString        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE ghAttributeGroup    AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghAttribute         AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghAttributeValue    AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghConstantValue     AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghInheritedValue    AS HANDLE       NO-UNDO.
DEFINE VARIABLE gcAttributeAction   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gdMaxAttributeGroup AS DECIMAL      NO-UNDO.
DEFINE VARIABLE ghGroupAssign       AS HANDLE       NO-UNDO.

/* Temp table, queryn and browse handles and query string definitions */
/* rycoi */
DEFINE VARIABLE ghTtObjectInstance  AS HANDLE       NO-UNDO. /* Handle to Object Instance temp table */
DEFINE VARIABLE ghRycoiBrowse       AS HANDLE       NO-UNDO. /* Browse handle */
DEFINE VARIABLE ghRycoiQuery1       AS HANDLE       NO-UNDO.
DEFINE VARIABLE gcRycoiQuery1       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE ghRycoiQuery1Buffer AS HANDLE       NO-UNDO.

DEFINE VARIABLE ghRycoiQuery2       AS HANDLE       NO-UNDO.
DEFINE VARIABLE gcRycoiQuery2       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE ghRycoiQuery2Buffer AS HANDLE       NO-UNDO.

/* rycav */
DEFINE VARIABLE ghTtAttributeValue  AS HANDLE       NO-UNDO. /* Handle to Attribute Value temp table */
DEFINE VARIABLE ghRycavBrowse       AS HANDLE       NO-UNDO. /* Browse handle */
DEFINE VARIABLE ghRycavQuery1       AS HANDLE       NO-UNDO.
DEFINE VARIABLE gcRycavQuery1       AS CHARACTER    NO-UNDO. 
DEFINE VARIABLE ghRycavQuery1Buffer AS HANDLE       NO-UNDO.

/* rycsm */
DEFINE VARIABLE ghTtSmartlink       AS HANDLE       NO-UNDO. /* Handle to Smart Link temp table */
DEFINE VARIABLE ghRycsmBrowse       AS HANDLE       NO-UNDO. /* Browse handle */
DEFINE VARIABLE ghRycsmQuery1       AS HANDLE       NO-UNDO.
DEFINE VARIABLE gcRycsmQuery1       AS CHARACTER    NO-UNDO. 
DEFINE VARIABLE ghRycsmQuery1Buffer AS HANDLE       NO-UNDO.

/* rycpa */
DEFINE VARIABLE ghTtPage            AS HANDLE       NO-UNDO. /* Handle to Page temp table */
DEFINE VARIABLE ghRycpaBrowse       AS HANDLE       NO-UNDO. /* Browse handle */
DEFINE VARIABLE ghRycpaQuery1       AS HANDLE       NO-UNDO.
DEFINE VARIABLE gcRycpaQuery1       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE ghRycpaQuery1Buffer AS HANDLE       NO-UNDO.

DEFINE VARIABLE ghRycpaQuery2       AS HANDLE       NO-UNDO.
DEFINE VARIABLE gcRycpaQuery2       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE ghRycpaQuery2Buffer AS HANDLE       NO-UNDO.


DEFINE VARIABLE ghProductCode       AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghProductModuleCode AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghObjectFilename    AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghObjectDescription AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghObjectTypeCode    AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghLayoutPosition    AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghPageLabel         AS HANDLE       NO-UNDO.

DEFINE VARIABLE ghSourceObj         AS DECIMAL      NO-UNDO.
DEFINE VARIABLE gcLinkObjects       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE ghSource            AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghTargetObj         AS DECIMAL      NO-UNDO.
DEFINE VARIABLE ghTarget            AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghUserDef           AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghLinkName          AS HANDLE       NO-UNDO.
DEFINE VARIABLE gcPage              AS CHARACTER    NO-UNDO.
DEFINE VARIABLE ghLayoutName        AS HANDLE       NO-UNDO.

DEFINE VARIABLE gcContainerMode     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE ghLookupField    AS HANDLE       NO-UNDO.
DEFINE VARIABLE gdSmartObjectObj    AS DECIMAL      NO-UNDO.
DEFINE VARIABLE gdObjectObj         AS DECIMAL      NO-UNDO.
DEFINE VARIABLE gdObjectTypeObj     AS DECIMAL      NO-UNDO.
DEFINE VARIABLE gcRycoiUpdateState  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcRycavUpdateState  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcRycpaUpdateState  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcRycsmUpdateState  AS CHARACTER    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycsoful2o.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buRycavAdd buRycavCancel buRycavDelete ~
buRycavSave buRycavUpdate buRycoiAdd buRycoiCancel buRycoiDelete ~
buRycoiSave buRycoiUpdate buRycpaCancel buRycsmCancel buRycpaAdd ~
buRycpaDelete buRycpaSave buRycpaUpdate buRycsmAdd buRycsmDelete ~
buRycsmSave buRycsmUpdate fiLayoutPosition coPage coAttributeGroup ~
coAttribute fiAttributeValue ToConstant ToInherited fiPageLabel coLayout ~
fiPageSeq ToCreate ToModify ToView fiSecurityToken coSourceLink coLink ~
coTargetLink 
&Scoped-Define DISPLAYED-OBJECTS fiLayoutPosition coPage fiAttributeValue ~
ToConstant ToInherited fiPageLabel fiPageSeq ToCreate ToModify ToView ~
fiSecurityToken coLink 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dynlookup AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buRycavAdd 
     IMAGE-UP FILE "ry/img/add.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Add" 
     SIZE 4.8 BY 1.05 TOOLTIP "Add Attribute for Selected Object Instance"
     BGCOLOR 8 .

DEFINE BUTTON buRycavCancel 
     IMAGE-UP FILE "ry/img/cancel.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Cancel" 
     SIZE 4.8 BY 1.05 TOOLTIP "Cancel changes"
     BGCOLOR 8 .

DEFINE BUTTON buRycavDelete 
     IMAGE-UP FILE "ry/img/delete.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Delete" 
     SIZE 4.8 BY 1.05 TOOLTIP "Delete Attribute for Selected Object Instance"
     BGCOLOR 8 .

DEFINE BUTTON buRycavSave 
     IMAGE-UP FILE "ry/img/saverec.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Save" 
     SIZE 4.8 BY 1.05 TOOLTIP "Save Attribute Record"
     BGCOLOR 8 .

DEFINE BUTTON buRycavUpdate 
     IMAGE-UP FILE "ry/img/update.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Update" 
     SIZE 4.8 BY 1.05 TOOLTIP "Delete Attribute for Selected Object Instance"
     BGCOLOR 8 .

DEFINE BUTTON buRycoiAdd 
     IMAGE-UP FILE "ry/img/add.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Add" 
     SIZE 4.8 BY 1.05 TOOLTIP "Add Object Instance"
     BGCOLOR 8 .

DEFINE BUTTON buRycoiCancel 
     IMAGE-UP FILE "ry/img/cancel.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Cancel" 
     SIZE 4.8 BY 1.05 TOOLTIP "Cancel changes"
     BGCOLOR 8 .

DEFINE BUTTON buRycoiDelete 
     IMAGE-UP FILE "ry/img/delete.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Delete" 
     SIZE 4.8 BY 1.05 TOOLTIP "Delete Object Instance"
     BGCOLOR 8 .

DEFINE BUTTON buRycoiSave 
     IMAGE-UP FILE "ry/img/saverec.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Save" 
     SIZE 4.8 BY 1.05 TOOLTIP "Save Object Instance Record"
     BGCOLOR 8 .

DEFINE BUTTON buRycoiUpdate 
     IMAGE-UP FILE "ry/img/update.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Update" 
     SIZE 4.8 BY 1.05 TOOLTIP "Update Object Instance"
     BGCOLOR 8 .

DEFINE BUTTON buRycpaAdd 
     IMAGE-UP FILE "ry/img/add.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Add" 
     SIZE 4.8 BY 1.05
     BGCOLOR 8 .

DEFINE BUTTON buRycpaCancel 
     IMAGE-UP FILE "ry/img/cancel.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Cancel" 
     SIZE 4.8 BY 1.05 TOOLTIP "Cancel changes"
     BGCOLOR 8 .

DEFINE BUTTON buRycpaDelete 
     IMAGE-UP FILE "ry/img/delete.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Delete" 
     SIZE 4.8 BY 1.05
     BGCOLOR 8 .

DEFINE BUTTON buRycpaSave 
     IMAGE-UP FILE "ry/img/saverec.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Save" 
     SIZE 4.8 BY 1.05 TOOLTIP "Cancel all changes since last saved"
     BGCOLOR 8 .

DEFINE BUTTON buRycpaUpdate 
     IMAGE-UP FILE "ry/img/update.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Update" 
     SIZE 4.8 BY 1.05 TOOLTIP "Update Page"
     BGCOLOR 8 .

DEFINE BUTTON buRycsmAdd 
     IMAGE-UP FILE "ry/img/add.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Add" 
     SIZE 4.8 BY 1.05
     BGCOLOR 8 .

DEFINE BUTTON buRycsmCancel 
     IMAGE-UP FILE "ry/img/cancel.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Cancel" 
     SIZE 4.8 BY 1.05 TOOLTIP "Cancel changes"
     BGCOLOR 8 .

DEFINE BUTTON buRycsmDelete 
     IMAGE-UP FILE "ry/img/delete.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Delete" 
     SIZE 4.8 BY 1.05
     BGCOLOR 8 .

DEFINE BUTTON buRycsmSave 
     IMAGE-UP FILE "ry/img/saverec.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Save" 
     SIZE 4.8 BY 1.05 TOOLTIP "Cancel all changes since last saved"
     BGCOLOR 8 .

DEFINE BUTTON buRycsmUpdate 
     IMAGE-UP FILE "ry/img/update.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Update" 
     SIZE 4.8 BY 1.05 TOOLTIP "Update Smart Link"
     BGCOLOR 8 .

DEFINE VARIABLE coAttribute AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "x","x"
     DROP-DOWN-LIST
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE coAttributeGroup AS DECIMAL FORMAT "-99999999999999999999.999999999":U INITIAL 0 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "0",0
     DROP-DOWN-LIST
     SIZE 24.8 BY 1 NO-UNDO.

DEFINE VARIABLE coLayout AS DECIMAL FORMAT "99999999999999999999.999999999":U INITIAL 0 
     LABEL "Layout" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "0",0
     DROP-DOWN-LIST
     SIZE 29 BY 1.05 NO-UNDO.

DEFINE VARIABLE coLink AS DECIMAL FORMAT "-99999999999999999999.999999999":U INITIAL ? 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "0",0
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE coPage AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Page" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "0",0
     DROP-DOWN-LIST
     SIZE 23.6 BY 1 NO-UNDO.

DEFINE VARIABLE coSourceLink AS INTEGER FORMAT "9999999999":U INITIAL 0 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "0",0
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE coTargetLink AS INTEGER FORMAT "9999999999":U INITIAL 0 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "0",0
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE fiAttributeValue AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiLayoutPosition AS CHARACTER FORMAT "X(256)":U 
     LABEL "Layout Position" 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE fiPageLabel AS CHARACTER FORMAT "X(28)":U 
     LABEL "Label" 
     VIEW-AS FILL-IN 
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE fiPageSeq AS INTEGER FORMAT "-99":U INITIAL 0 
     LABEL "Seq." 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE fiSecurityToken AS CHARACTER FORMAT "X(28)":U 
     LABEL "Security Token" 
     VIEW-AS FILL-IN 
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE ToConstant AS LOGICAL INITIAL no 
     LABEL "Constant" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .81 NO-UNDO.

DEFINE VARIABLE ToCreate AS LOGICAL INITIAL no 
     LABEL "Enable On Create" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE ToInherited AS LOGICAL INITIAL no 
     LABEL "Inherited" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .81 NO-UNDO.

DEFINE VARIABLE ToModify AS LOGICAL INITIAL no 
     LABEL "Enable On Modify" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE ToView AS LOGICAL INITIAL no 
     LABEL "Enable On View" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buRycavAdd AT ROW 13.57 COL 1
     buRycavCancel AT ROW 13.57 COL 20.2
     buRycavDelete AT ROW 13.57 COL 5.8
     buRycavSave AT ROW 13.57 COL 24.8
     buRycavUpdate AT ROW 13.57 COL 10.6
     buRycoiAdd AT ROW 1 COL 1
     buRycoiCancel AT ROW 1 COL 21.4
     buRycoiDelete AT ROW 1 COL 5.8
     buRycoiSave AT ROW 1 COL 17
     buRycoiUpdate AT ROW 1 COL 10.4
     buRycpaCancel AT ROW 1 COL 113.4
     buRycsmCancel AT ROW 13.57 COL 113.4
     buRycpaAdd AT ROW 1 COL 94.2
     buRycpaDelete AT ROW 1 COL 99
     buRycpaSave AT ROW 1 COL 118.2
     buRycpaUpdate AT ROW 1 COL 103.8
     buRycsmAdd AT ROW 13.57 COL 94.2
     buRycsmDelete AT ROW 13.57 COL 99
     buRycsmSave AT ROW 13.57 COL 118
     buRycsmUpdate AT ROW 13.57 COL 103.8
     fiLayoutPosition AT ROW 10.95 COL 17 COLON-ALIGNED
     coPage AT ROW 9.86 COL 65.8 COLON-ALIGNED
     coAttributeGroup AT ROW 22.52 COL 1 NO-LABEL
     coAttribute AT ROW 22.52 COL 24.2 COLON-ALIGNED NO-LABEL
     fiAttributeValue AT ROW 22.52 COL 52.6 COLON-ALIGNED NO-LABEL
     ToConstant AT ROW 23.76 COL 1
     ToInherited AT ROW 23.76 COL 26.6
     fiPageLabel AT ROW 9.86 COL 99.8 COLON-ALIGNED
     coLayout AT ROW 10.95 COL 99.8 COLON-ALIGNED
     fiPageSeq AT ROW 12.1 COL 99.8 COLON-ALIGNED
     ToCreate AT ROW 9.86 COL 132.2
     ToModify AT ROW 10.57 COL 132.2
     ToView AT ROW 11.29 COL 132.2
     fiSecurityToken AT ROW 12.1 COL 130.2 COLON-ALIGNED
     coSourceLink AT ROW 22.48 COL 92.2 COLON-ALIGNED NO-LABEL
     coLink AT ROW 22.48 COL 114.2 NO-LABEL
     coTargetLink AT ROW 22.48 COL 132 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycsoful2o.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycsoful2o.i}
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
         HEIGHT             = 24.19
         WIDTH              = 157.6.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX coAttribute IN FRAME frMain
   NO-DISPLAY                                                           */
/* SETTINGS FOR COMBO-BOX coAttributeGroup IN FRAME frMain
   NO-DISPLAY ALIGN-L                                                   */
/* SETTINGS FOR COMBO-BOX coLayout IN FRAME frMain
   NO-DISPLAY                                                           */
/* SETTINGS FOR COMBO-BOX coLink IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX coSourceLink IN FRAME frMain
   NO-DISPLAY                                                           */
/* SETTINGS FOR COMBO-BOX coTargetLink IN FRAME frMain
   NO-DISPLAY                                                           */
ASSIGN 
       fiPageSeq:PRIVATE-DATA IN FRAME frMain     = 
                "no-button".

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

&Scoped-define SELF-NAME buRycavAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycavAdd vTableWin
ON CHOOSE OF buRycavAdd IN FRAME frMain /* Add */
DO:
    /* move this buttons with caution as various widgets are lined up with it, i.e., the */
    /* browse and coAttributeGroup, which are in turn used to line up other widgets      */

    RUN modRycav(INPUT "add":u).

    ASSIGN
        coAttributeGroup:LIST-ITEM-PAIRS = coAttributeGroup:LIST-ITEM-PAIRS
        coAttribute:LIST-ITEM-PAIRS      = coAttribute:LIST-ITEM-PAIRS
        fiAttributeValue                 = "":u
        ToConstant                       = NO
        ToInherited                      = NO
        gcAttributeAction                = "A":u.

    DISPLAY 
        coAttributeGroup
        coAttribute
        fiAttributeValue
        ToConstant
        ToInherited
    WITH FRAME {&FRAME-NAME}.

    APPLY "entry":u TO coAttributeGroup.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycavCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycavCancel vTableWin
ON CHOOSE OF buRycavCancel IN FRAME frMain /* Cancel */
DO:
    RUN modRycav(INPUT "cancel":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycavDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycavDelete vTableWin
ON CHOOSE OF buRycavDelete IN FRAME frMain /* Delete */
DO:
    RUN modRycav(INPUT "delete":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycavSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycavSave vTableWin
ON CHOOSE OF buRycavSave IN FRAME frMain /* Save */
DO:
    RUN modRycav(INPUT "save":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycavUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycavUpdate vTableWin
ON CHOOSE OF buRycavUpdate IN FRAME frMain /* Update */
DO:
    RUN modRycav(INPUT "update":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycoiAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycoiAdd vTableWin
ON CHOOSE OF buRycoiAdd IN FRAME frMain /* Add */
DO:
    /* move this buttons with caution as various widgets are lined up with it, i.e., the */
    /* browse and coAttributeGroup, which are in turn used to line up other widgets      */

    RUN modRycoi(INPUT "add":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycoiCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycoiCancel vTableWin
ON CHOOSE OF buRycoiCancel IN FRAME frMain /* Cancel */
DO:
    RUN modRycoi(INPUT "cancel":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycoiDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycoiDelete vTableWin
ON CHOOSE OF buRycoiDelete IN FRAME frMain /* Delete */
DO:
    RUN modRycoi(INPUT "delete":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycoiSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycoiSave vTableWin
ON CHOOSE OF buRycoiSave IN FRAME frMain /* Save */
DO:
    RUN modRycoi(INPUT 'save':u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycoiUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycoiUpdate vTableWin
ON CHOOSE OF buRycoiUpdate IN FRAME frMain /* Update */
DO:
    RUN modRycoi(INPUT "update":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycpaAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycpaAdd vTableWin
ON CHOOSE OF buRycpaAdd IN FRAME frMain /* Add */
DO:
    /* move this buttons with caution as various widgets are lined up with it, i.e., the */
    /* browse and coAttributeGroup, which are in turn used to line up other widgets      */

    RUN modRycpa(INPUT "add":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycpaCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycpaCancel vTableWin
ON CHOOSE OF buRycpaCancel IN FRAME frMain /* Cancel */
DO:
    RUN modRycpa(INPUT "cancel":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycpaDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycpaDelete vTableWin
ON CHOOSE OF buRycpaDelete IN FRAME frMain /* Delete */
DO:
    RUN modRycpa(INPUT "delete":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycpaSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycpaSave vTableWin
ON CHOOSE OF buRycpaSave IN FRAME frMain /* Save */
DO:
    RUN modRycpa(INPUT "save":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycpaUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycpaUpdate vTableWin
ON CHOOSE OF buRycpaUpdate IN FRAME frMain /* Update */
DO:
    RUN modRycpa(INPUT "update":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycsmAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycsmAdd vTableWin
ON CHOOSE OF buRycsmAdd IN FRAME frMain /* Add */
DO:
    /* move this buttons with caution as various widgets are lined up with it, i.e., the */
    /* browse and coAttributeGroup, which are in turn used to line up other widgets      */

    RUN modRycsm(INPUT "add":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycsmCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycsmCancel vTableWin
ON CHOOSE OF buRycsmCancel IN FRAME frMain /* Cancel */
DO:
    RUN modRycsm(INPUT "cancel":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycsmDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycsmDelete vTableWin
ON CHOOSE OF buRycsmDelete IN FRAME frMain /* Delete */
DO:
    RUN modRycsm(INPUT "delete":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycsmSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycsmSave vTableWin
ON CHOOSE OF buRycsmSave IN FRAME frMain /* Save */
DO:
    RUN modRycsm(INPUT "save":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRycsmUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRycsmUpdate vTableWin
ON CHOOSE OF buRycsmUpdate IN FRAME frMain /* Update */
DO:
    RUN modRycsm(INPUT "update":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coAttribute
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coAttribute vTableWin
ON VALUE-CHANGED OF coAttribute IN FRAME frMain
DO:
    DEFINE VARIABLE hbuffer         AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBufferField    AS HANDLE       NO-UNDO.

    ASSIGN
        hbuffer = ghttAttributeValue:DEFAULT-BUFFER-HANDLE
        hBufferField = hBuffer:BUFFER-FIELD("attribute_label":u)
        hBufferField:BUFFER-VALUE = coAttribute:SCREEN-VALUE.

    ghRycavBrowse:REFRESH().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coAttributeGroup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coAttributeGroup vTableWin
ON VALUE-CHANGED OF coAttributeGroup IN FRAME frMain
DO:
    DEFINE VARIABLE hbuffer         AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBufferField    AS HANDLE       NO-UNDO.

    FIND FIRST ttComboData NO-LOCK
        WHERE ttComboData.hWidget = coAttributeGroup:HANDLE NO-ERROR.

    ASSIGN
        hbuffer                   = ghttAttributeValue:DEFAULT-BUFFER-HANDLE
        hBufferField              = hBuffer:BUFFER-FIELD("attribute_group_obj":u)
        hBufferField:BUFFER-VALUE = DECIMAL(coAttributeGroup:SCREEN-VALUE)
        hBufferField              = hBuffer:BUFFER-FIELD("attribute_group_name":u)
        hBufferField:BUFFER-VALUE = 
            ENTRY(LOOKUP(coAttributeGroup:SCREEN-VALUE, ttComboData.cListItemPairs) - 1, ttComboData.cListItemPairs, coAttributeGroup:DELIMITER) NO-ERROR.

    ghRycoiBrowse:REFRESH().

    FIND FIRST ttComboData NO-LOCK
        WHERE ttComboData.hWidget = coAttribute:HANDLE NO-ERROR.

    IF  NOT AVAILABLE ttComboData
    OR  ttComboData.cListItemPairs = ?
    OR  ttComboData.cListItemPairs = "":u THEN RETURN.

    /* Assign full list of values to product module temp table records before filtering product module */
    ASSIGN
        ttComboData.cListItemPairs = gcDataString.

    RUN filterCombo (INPUT coAttributeGroup:SCREEN-VALUE). /* Filter Attribute combo by value of attribute combo */

    FIND FIRST ttComboData NO-LOCK
        WHERE ttComboData.hWidget = coAttribute:HANDLE NO-ERROR.

    IF  NOT AVAILABLE ttComboData THEN RETURN.

    coAttribute:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} =
        IF ttComboData.cListItemPairs = "":u THEN coAttribute:LIST-ITEM-PAIRS ELSE ttComboData.cListItemPairs.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coPage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coPage vTableWin
ON VALUE-CHANGED OF coPage IN FRAME frMain /* Page */
DO:
    ASSIGN coPage.
    IF (ghRycoiQuery1Buffer:AVAILABLE AND gcRycoiUpdateState EQ "U":U) OR gcRycoiUpdateState EQ "A":U THEN
    DO:
        ghPageLabel:SCREEN-VALUE = ENTRY(LOOKUP(STRING(coPage,coPage:FORMAT),coPage:LIST-ITEM-PAIRS,coPage:DELIMITER) - 1, 
                                         coPage:LIST-ITEM-PAIRS, 
                                         coPage:DELIMITER).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiAttributeValue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiAttributeValue vTableWin
ON LEAVE OF fiAttributeValue IN FRAME frMain
DO:
    DEFINE VARIABLE hbuffer         AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBufferField    AS HANDLE       NO-UNDO.

    ASSIGN
        hbuffer = ghttAttributeValue:DEFAULT-BUFFER-HANDLE
        hBufferField = hBuffer:BUFFER-FIELD("attribute_value":u)
        hBufferField:BUFFER-VALUE = fiAttributeValue:SCREEN-VALUE.

    ghRycoiBrowse:REFRESH().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiLayoutPosition
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiLayoutPosition vTableWin
ON LEAVE OF fiLayoutPosition IN FRAME frMain /* Layout Position */
DO:
    IF (ghRycoiQuery1Buffer:AVAILABLE AND gcRycoiUpdateState EQ "U":U) OR gcRycoiUpdateState EQ "A":U THEN
    DO:
        ghLayoutPosition:SCREEN-VALUE = fiLayoutPosition:SCREEN-VALUE.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToConstant
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToConstant vTableWin
ON VALUE-CHANGED OF ToConstant IN FRAME frMain /* Constant */
DO:
    DEFINE VARIABLE hbuffer         AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBufferField    AS HANDLE       NO-UNDO.

    ASSIGN
        toConstant
        hbuffer = ghttAttributeValue:DEFAULT-BUFFER-HANDLE
        hBufferField = hBuffer:BUFFER-FIELD("constant_value":u)
        hBufferField:BUFFER-VALUE = toConstant.

    ghRycoiBrowse:REFRESH().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToInherited
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToInherited vTableWin
ON VALUE-CHANGED OF ToInherited IN FRAME frMain /* Inherited */
DO:
    DEFINE VARIABLE hbuffer         AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBufferField    AS HANDLE       NO-UNDO.

    ASSIGN
        toInherited
        hbuffer = ghttAttributeValue:DEFAULT-BUFFER-HANDLE
        hBufferField = hBuffer:BUFFER-FIELD("inheritted_value":u)
        hBufferField:BUFFER-VALUE = toInherited.

    ghRycoiBrowse:REFRESH().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

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
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelObject FilenameFieldTooltipPress F4 for LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_smartobject NO-LOCK,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj,
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj,
                     FIRST ryc_layout NO-LOCK
                     WHERE ryc_layout.layout_obj = ryc_smartobject.layout_objQueryTablesryc_smartobject,gsc_object_type,gsc_product_module,gsc_product,ryc_layoutBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,ryc_smartobject.object_filename,ryc_smartobject.object_description,gsc_object_type.object_type_code,ryc_smartobject.static_object,ryc_smartobject.template_smartobject,ryc_smartobject.system_owned,ryc_layout.layout_codeBrowseFieldDataTypescharacter,character,character,character,character,logical,logical,logical,characterBrowseFieldFormatsX(10),X(10),X(70),X(35),X(15),YES/NO,YES/NO,YES/NO,X(10)RowsToBatch200BrowseTitleLookup Object InstanceViewerLinkedFieldsgsc_product.product_obj,gsc_product_module.product_module_obj,gsc_product.product_code,gsc_product_module.product_module_code,ryc_smartobject.object_description,gsc_object_type.object_type_codeLinkedFieldDataTypesdecimal,decimal,character,character,character,characterLinkedFieldFormats->>>>>>>>>>>>>>>>>9.999999999,->>>>>>>>>>>>>>>>>9.999999999,X(10),X(10),X(35),X(15)ViewerLinkedWidgetsfiProductObj,fiProductModuleObj,fiProductCode,fiProductModuleCode,?,?ColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcFieldNamedObjectInstanceDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup ).
       RUN repositionObject IN h_dynlookup ( 9.86 , 19.00 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup ( 1.00 , 40.40 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dynlookup ,
             coTargetLink:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCombo vTableWin 
PROCEDURE buildCombo :
/*------------------------------------------------------------------------------
  Purpose:     This is published from the smartviewer containing the smartdatafield 
               to populate the combo with the evaluated list item pairs - if the
               query was succesful.
               This will be done as part of initilizing the container viewer. 
  Parameters:  input combo temp-table
  Notes:       This is designed to facilitate all combo queries being built with
               a single appserver hit.
               Note: if SDF is dependant on data from another SDF, then this
               procedure can not be used.
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:

        FIND FIRST ttComboData NO-LOCK
            WHERE ttComboData.hWidget = coLink:HANDLE NO-ERROR.

        coLink:LIST-ITEM-PAIRS = ttComboData.cListItemPairs.

        FIND FIRST ttComboData NO-LOCK
            WHERE ttComboData.hWidget = coLayout:HANDLE NO-ERROR.

        coLayout:LIST-ITEM-PAIRS = ttComboData.cListItemPairs.

        FIND FIRST ttComboData NO-LOCK
            WHERE ttComboData.hWidget = coAttributeGroup:HANDLE NO-ERROR.

        IF  NOT AVAILABLE ttComboData 
        OR  ttComboData.cListItemPairs = ?
        OR  ttComboData.cListItemPairs = "":u THEN RETURN.

        coAttributeGroup:LIST-ITEM-PAIRS = ttComboData.cListItemPairs.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildLinkCombo vTableWin 
PROCEDURE buildLinkCombo :
/*------------------------------------------------------------------------------
  Purpose:      Populate link combos from ttRycObjectInstance, as new object 
                instances could be added/deleted, which would need to be added 
                to/deleted from the link combos
  Parameters:   <none>
  Notes:       
------------------------------------------------------------------------------*/

    CREATE QUERY ghRycoiQuery2.
    CREATE BUFFER ghRycoiQuery2Buffer FOR TABLE ghttObjectInstance:DEFAULT-BUFFER-HANDLE BUFFER-NAME "b2_ttRycObjectInstance":U.
    ghRycoiQuery2:ADD-BUFFER(ghRycoiQuery2Buffer).

    ASSIGN gcRycoiQuery2 = 
        "FOR EACH b2_ttRycObjectInstance ":u +
           "WHERE b2_ttRycObjectInstance.rowMod <> 'D':u " +
             "AND b2_ttRycObjectInstance.rowMod <> '':u ":u +
              "BY b2_ttRycObjectInstance.object_filename":u.    
    ghRycoiQuery2:QUERY-PREPARE(gcRycoiQuery2).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPageCombo vTableWin 
PROCEDURE buildPageCombo :
/*------------------------------------------------------------------------------
  Purpose:      Populate link combos from ttRycObjectInstance, as new object 
                instances could be added/deleted, which would need to be added 
                to/deleted from the link combos
  Parameters:   <none>
  Notes:       
------------------------------------------------------------------------------*/

    CREATE QUERY ghRycpaQuery2.
    CREATE BUFFER ghRycpaQuery2Buffer FOR TABLE ghTtPage:DEFAULT-BUFFER-HANDLE BUFFER-NAME "b2_ttRycPage":U.
    ghRycpaQuery2:ADD-BUFFER(ghRycpaQuery2Buffer).

    ASSIGN gcRycpaQuery2 =
        "FOR EACH b2_ttRycPage NO-LOCK ":u +
           "WHERE b2_ttRycPage.rowmod <> '':u ":u +
             "AND b2_ttRycPage.rowmod <> 'D':u ":u.    
    ghRycpaQuery2:QUERY-PREPARE(gcRycpaQuery2).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildRycavBrowse vTableWin 
PROCEDURE buildRycavBrowse :
/*------------------------------------------------------------------------------
  Purpose:      Create browse and query and do initial positioning of browse and
                associated widgets.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hBufferField    AS HANDLE       NO-UNDO.


    IF VALID-HANDLE(ghRycavQuery1) THEN
       DELETE OBJECT ghRycavQuery1.
    IF VALID-HANDLE(ghRycavQuery1Buffer) THEN
       DELETE OBJECT ghRycavQuery1Buffer.
    ASSIGN
       gcRycavQuery1       = "":U
       ghRycavQuery1       = ?
       ghRycavQuery1Buffer = ?.

    CREATE QUERY ghRycavQuery1.
    CREATE BUFFER ghRycavQuery1Buffer FOR TABLE ghttAttributeValue:DEFAULT-BUFFER-HANDLE BUFFER-NAME "b1_ttAttributeValue":U.
    ghRycavQuery1:ADD-BUFFER(ghRycavQuery1Buffer).

    CREATE BROWSE ghRycavBrowse
        ASSIGN
            FRAME                   = FRAME {&FRAME-NAME}:HANDLE
            TITLE                   = "Attributes Of Selected Object Instance"
            Y                       = buRycavAdd:Y + buRycavAdd:HEIGHT-PIXELS + 5 /* line up with add button */
            X                       = buRycavAdd:X
            WIDTH-PIXELS            = FRAME {&FRAME-NAME}:WIDTH-PIXELS  * 60 / 100 /* 60% of frame width */  
            HEIGHT-PIXELS           = FRAME {&FRAME-NAME}:HEIGHT-PIXELS * 40 / 100 /* 40% of frame height */ 
            SEPARATORS              = TRUE
            ROW-MARKERS             = FALSE
            EXPANDABLE              = TRUE
            MAX-DATA-GUESS          = 30
            COLUMN-RESIZABLE        = TRUE
            COLUMN-SCROLLING        = TRUE
            DOWN                    = 5
    /*        RESIZABLE               = FALSE*/
            ALLOW-COLUMN-SEARCHING  = TRUE
            SELECTABLE              = FALSE
            READ-ONLY               = NO
            QUERY                   = ghRycavQuery1
        TRIGGERS:            
            ON 'row-leave':U
                PERSISTENT RUN rowLeave IN THIS-PROCEDURE.
            ON 'value-changed':U
                PERSISTENT RUN valueChangedRycav IN THIS-PROCEDURE.
            ON 'end-resize':U ANYWHERE
                PERSISTENT RUN resizeAttributeBrowse IN THIS-PROCEDURE.
        END TRIGGERS.

    ASSIGN
        ghRycavBrowse:VISIBLE = NO
        ghRycavBrowse:SENSITIVE = NO.    

    /* initial browse settings */
    hBufferField = ghRycavQuery1Buffer:BUFFER-FIELD("attribute_group_name").
    ghAttributeGroup = ghRycavBrowse:ADD-LIKE-COLUMN(hBufferField).
    /* width = 15% of browse width */
    /*ghAttributeGroup:WIDTH-PIXELS = dBrowseWidth * 15 / 100.*/

    hBufferField = ghRycavQuery1Buffer:BUFFER-FIELD("attribute_label").
    ghAttribute = ghRycavBrowse:ADD-LIKE-COLUMN(hBufferField).
    /* width = 21% of browse width */
    /*ghAttribute:WIDTH-PIXELS = dBrowseWidth * 15 / 100.*/

    hBufferField = ghRycavQuery1Buffer:BUFFER-FIELD("attribute_value").
    ghAttributeValue = ghRycavBrowse:ADD-LIKE-COLUMN(hBufferField).
    /* width = 50% of browse width */
    /*ghAttributeValue:WIDTH-PIXELS = dBrowseWidth * 52 / 100.*/

    hBufferField = ghRycavQuery1Buffer:BUFFER-FIELD("constant_value").
    ghConstantValue = ghRycavBrowse:ADD-LIKE-COLUMN(hBufferField).
    /* width = 9% of browse-width */
    /*ghConstantValue:WIDTH-PIXELS = dBrowseWidth * 9 / 100.*/

    hBufferField = ghRycavQuery1Buffer:BUFFER-FIELD("inheritted_value"). /* sic */
    ghInheritedValue = ghRycavBrowse:ADD-LIKE-COLUMN(hBufferField).
    /*ghInheritedValue:WIDTH-PIXELS = dBrowseWidth * 9 / 100.*/

    ghRycavBrowse:NUM-LOCKED-COLUMNS = 1.
    ghRycavBrowse:SENSITIVE = YES.
    ghRycavBrowse:HIDDEN = NO.

    ghRycavBrowse:SET-REPOSITIONED-ROW(1,"CONDITIONAL":u).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildRycoiBrowse vTableWin 
PROCEDURE buildRycoiBrowse :
/*------------------------------------------------------------------------------
  Purpose:      Create browse and query and do initial positioning of browse and
                associated widgets.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hBufferField    AS HANDLE       NO-UNDO.


    IF VALID-HANDLE(ghRycoiQuery1) THEN
       DELETE OBJECT ghRycoiQuery1.
    IF VALID-HANDLE(ghRycoiQuery1Buffer) THEN
       DELETE OBJECT ghRycoiQuery1Buffer.
    ASSIGN
       gcRycoiQuery1       = "":U
       ghRycoiQuery1       = ?
       ghRycoiQuery1Buffer = ?.

    CREATE QUERY ghRycoiQuery1.
    CREATE BUFFER ghRycoiQuery1Buffer FOR TABLE ghttObjectInstance:DEFAULT-BUFFER-HANDLE BUFFER-NAME "b1_ttRycObjectInstance":U.
    ghRycoiQuery1:ADD-BUFFER(ghRycoiQuery1Buffer).

    ASSIGN gcRycoiQuery1 = 
        "FOR EACH b1_ttRycObjectInstance ":u +
           "WHERE b1_ttRycObjectInstance.rowMod <> 'D':u " +
             "AND b1_ttRycObjectInstance.rowMod <> '':u ":u +
              "BY b1_ttRycObjectInstance.object_filename":u.
    ghRycoiQuery1:QUERY-PREPARE(gcRycoiQuery1).

    CREATE BROWSE ghRycoiBrowse
        ASSIGN
            FRAME                   = FRAME {&FRAME-NAME}:HANDLE
            TITLE                   = "Object Instances of Container"
            Y                       = buRycoiAdd:Y + buRycoiAdd:HEIGHT-PIXELS + 5 /* Place below add button */
            X                       = buRycoiAdd:X
            WIDTH-PIXELS            = FRAME {&FRAME-NAME}:WIDTH-PIXELS  * 60 / 100 /* 60% of frame width */
            HEIGHT-PIXELS           = FRAME {&FRAME-NAME}:HEIGHT-PIXELS * 40 / 100 /* 40% of frame height */
            SEPARATORS              = TRUE
            ROW-MARKERS             = FALSE
            EXPANDABLE              = TRUE
            MAX-DATA-GUESS          = 30
            COLUMN-RESIZABLE        = TRUE
            COLUMN-SCROLLING        = TRUE
            DOWN                    = 5
            ALLOW-COLUMN-SEARCHING  = TRUE
            SELECTABLE              = FALSE
            READ-ONLY               = NO
            QUERY                   = ghRycoiQuery1
        TRIGGERS:            
            ON 'row-leave':U
                PERSISTENT RUN rowLeave IN THIS-PROCEDURE.
            ON 'value-changed':U
                PERSISTENT RUN valueChangedRycoi IN THIS-PROCEDURE.
        END TRIGGERS.

    ASSIGN
        ghRycoiBrowse:VISIBLE = NO
        ghRycoiBrowse:SENSITIVE = NO.

    hBufferField = ghRycoiQuery1Buffer:BUFFER-FIELD("product_code").
    ghProductCode = ghRycoiBrowse:ADD-LIKE-COLUMN(hBufferField).
    ghProductCode:LABEL = "Product".

    hBufferField = ghRycoiQuery1Buffer:BUFFER-FIELD("product_module_code").
    ghProductModuleCode = ghRycoiBrowse:ADD-LIKE-COLUMN(hBufferField).
    ghProductModuleCode:LABEL = "Product Module".

    hBufferField = ghRycoiQuery1Buffer:BUFFER-FIELD("object_filename").
    ghObjectFilename = ghRycoiBrowse:ADD-LIKE-COLUMN(hBufferField).

    hBufferField = ghRycoiQuery1Buffer:BUFFER-FIELD("layout_position").
    ghLayoutPosition = ghRycoiBrowse:ADD-LIKE-COLUMN(hBufferField).

    hBufferField = ghRycoiQuery1Buffer:BUFFER-FIELD("page_label").
    ghPageLabel = ghRycoiBrowse:ADD-LIKE-COLUMN(hBufferField).

    hBufferField = ghRycoiQuery1Buffer:BUFFER-FIELD("object_description").
    ghObjectDescription = ghRycoiBrowse:ADD-LIKE-COLUMN(hBufferField).

    hBufferField = ghRycoiQuery1Buffer:BUFFER-FIELD("object_type_code").
    ghObjectTypeCode = ghRycoiBrowse:ADD-LIKE-COLUMN(hBufferField).

    ASSIGN
        ghRycoiBrowse:NUM-LOCKED-COLUMNS = 1    
        ghRycoiBrowse:SENSITIVE          = YES
        ghRycoiBrowse:HIDDEN             = NO.

    ghRycoiBrowse:SET-REPOSITIONED-ROW(1,"CONDITIONAL":u).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildRycpaBrowse vTableWin 
PROCEDURE buildRycpaBrowse :
/*------------------------------------------------------------------------------
  Purpose:      Create browse and query and do initial positioning of browse and
                associated widgets.
  Parameters:  <none>
  Notes:       

------------------------------------------------------------------------------*/

    DEFINE VARIABLE hBufferField    AS HANDLE       NO-UNDO.
    DEFINE VARIABLE dBrowseWidth    AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE hLinkName       AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hUserDef        AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBrowseCol      AS HANDLE       NO-UNDO.

    IF VALID-HANDLE(ghRycpaQuery1) THEN
       DELETE OBJECT ghRycpaQuery1.
    IF VALID-HANDLE(ghRycpaQuery1Buffer) THEN
       DELETE OBJECT ghRycpaQuery1Buffer.
    ASSIGN
       gcRycpaQuery1       = "":U
       ghRycpaQuery1       = ?
       ghRycpaQuery1Buffer = ?.

    CREATE QUERY ghRycpaQuery1.
    CREATE BUFFER ghRycpaQuery1Buffer FOR TABLE ghttPage:DEFAULT-BUFFER-HANDLE BUFFER-NAME "b1_ttRycPage":U.
    ghRycpaQuery1:ADD-BUFFER(ghRycpaQuery1Buffer).

    ASSIGN gcRycpaQuery1 =
       "FOR EACH b1_ttRycPage ":u +
          "WHERE b1_ttRycPage.rowMod <> 'D':u ":u +
            "AND b1_ttRycPage.rowMod <> '':u ":u +
             "BY b1_ttRycPage.page_sequence":u.
    ghRycpaQuery1:QUERY-PREPARE(gcRycpaQuery1).

    CREATE BROWSE ghRycpaBrowse
        ASSIGN
            FRAME                   = FRAME {&FRAME-NAME}:HANDLE
            TITLE                   = "Container Pages"
            Y                       = buRycpaAdd:Y + buRycpaAdd:HEIGHT-PIXELS + 5 /* Place below add button */  
            X                       = buRycpaAdd:X                                                               
            WIDTH-PIXELS            = ({&WINDOW-NAME}:WIDTH-PIXELS - 30) - ghRycpaBrowse:X
            HEIGHT-PIXELS           = fiPageLabel:Y - ghRycPaBrowse:Y - 5
            SEPARATORS              = TRUE
            ROW-MARKERS             = FALSE
            EXPANDABLE              = TRUE
            MAX-DATA-GUESS          = 30
            COLUMN-RESIZABLE        = TRUE
            COLUMN-SCROLLING        = TRUE
            DOWN                    = 5
    /*        RESIZABLE               = FALSE*/
            ALLOW-COLUMN-SEARCHING  = TRUE
            SELECTABLE              = FALSE
            READ-ONLY               = NO
            QUERY                   = ghRycpaQuery1
        TRIGGERS:            
            ON 'row-leave':U
                PERSISTENT RUN rowLeave IN THIS-PROCEDURE.
            ON 'value-changed':U
                PERSISTENT RUN valueChangedRycpa IN THIS-PROCEDURE.
            ON 'end-resize':U ANYWHERE
                PERSISTENT RUN resizePageBrowse IN THIS-PROCEDURE.
        END TRIGGERS.

    ASSIGN
        ghRycpaBrowse:VISIBLE = NO
        ghRycpaBrowse:SENSITIVE = NO.

    /* initial browse settings */
    hBufferField = ghRycpaQuery1Buffer:BUFFER-FIELD("page_sequence").
    hBrowseCol = ghRycpaBrowse:ADD-LIKE-COLUMN(hBufferField).
    hBrowseCol:LABEL = "Sequence":u.
    hBrowseCol:WIDTH-PIXELS = ghRycpaBrowse:WIDTH-PIXELS * 15 / 100.

    hBufferField = ghRycpaQuery1Buffer:BUFFER-FIELD("page_label").
    hBrowseCol = ghRycpaBrowse:ADD-LIKE-COLUMN(hBufferField).
    hBrowseCol:LABEL = "Label":u.
    hBrowseCol:WIDTH-PIXELS = ghRycpaBrowse:WIDTH-PIXELS * 40 / 100.

    hBufferField = ghRycpaQuery1Buffer:BUFFER-FIELD("layout_name").
    ghLayoutName = ghRycpaBrowse:ADD-LIKE-COLUMN(hBufferField).
    ghLayoutName:WIDTH-PIXELS = ghRycpaBrowse:WIDTH-PIXELS * 40 / 100.

    hBufferField = ghRycpaQuery1Buffer:BUFFER-FIELD("security_token").
    ghRycpaBrowse:ADD-LIKE-COLUMN(hBufferField).

    hBufferField = ghRycpaQuery1Buffer:BUFFER-FIELD("enable_on_create").
    ghRycpaBrowse:ADD-LIKE-COLUMN(hBufferField).

    hBufferField = ghRycpaQuery1Buffer:BUFFER-FIELD("enable_on_modify").
    ghRycpaBrowse:ADD-LIKE-COLUMN(hBufferField).

    hBufferField = ghRycpaQuery1Buffer:BUFFER-FIELD("enable_on_view").
    ghRycpaBrowse:ADD-LIKE-COLUMN(hBufferField).

    ASSIGN
        ghRycpaBrowse:NUM-LOCKED-COLUMNS = 1
        ghRycpaBrowse:SENSITIVE          = YES
        ghRycpaBrowse:HIDDEN             = NO
        .

    ghRycpaBrowse:SET-REPOSITIONED-ROW(1,"CONDITIONAL":u).

    ASSIGN
        buRycpaAdd:X    = ghRycpaBrowse:X
        buRycpaAdd:Y    = buRycoiAdd:Y
        buRycpaUpdate:X = buRycpaAdd:X + buRycpaAdd:WIDTH-PIXELS
        buRycpaUpdate:Y = buRycpaAdd:Y
        buRycpaDelete:X = buRycpaAdd:X + buRycpaAdd:WIDTH-PIXELS + buRycpaUpdate:WIDTH-PIXELS
        buRycpaDelete:Y = buRycpaAdd:Y.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildRycsmBrowse vTableWin 
PROCEDURE buildRycsmBrowse :
/*------------------------------------------------------------------------------
  Purpose:      Create browse and query and do initial positioning of browse and
                associated widgets.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hBufferField    AS HANDLE       NO-UNDO.
    DEFINE VARIABLE dBrowseWidth    AS DECIMAL      NO-UNDO.

    IF VALID-HANDLE(ghRycsmQuery1) THEN
       DELETE OBJECT ghRycsmQuery1.
    IF VALID-HANDLE(ghRycsmQuery1Buffer) THEN
       DELETE OBJECT ghRycsmQuery1Buffer.
    ASSIGN
       gcRycsmQuery1       = "":U
       ghRycsmQuery1       = ?
       ghRycsmQuery1Buffer = ?.

    CREATE QUERY ghRycsmQuery1.
    CREATE BUFFER ghRycsmQuery1Buffer FOR TABLE ghTTSmartLink:DEFAULT-BUFFER-HANDLE BUFFER-NAME "b1_ttRycSmartLink":U.
    ghRycsmQuery1:ADD-BUFFER(ghRycsmQuery1Buffer).

    ASSIGN gcRycsmQuery1 =
        "FOR EACH b1_ttRycSmartlink ":u +
           "WHERE b1_ttRycSmartlink.rowMod <> 'D':u ":u +
             "AND b1_ttRycSmartlink.rowMod <> '':u ":u.
    ghRycsmQuery1:QUERY-PREPARE(gcRycsmQuery1).

    CREATE BROWSE ghRycsmBrowse
        ASSIGN
            FRAME                   = FRAME {&FRAME-NAME}:HANDLE
            TITLE                   = "Container Links"
            Y                       = ghRycavBrowse:Y
            X                       = ghRycavBrowse:X + ghRycavBrowse:WIDTH-PIXELS + 10
            WIDTH-PIXELS            = ({&WINDOW-NAME}:WIDTH-PIXELS - 30) - ghRycsmBrowse:X
            HEIGHT-PIXELS           = ghRycavBrowse:HEIGHT-PIXELS
            SEPARATORS              = TRUE
            ROW-MARKERS             = FALSE
            EXPANDABLE              = TRUE
            MAX-DATA-GUESS          = 7
            COLUMN-RESIZABLE        = TRUE
            COLUMN-SCROLLING        = TRUE
            DOWN                    = 5
            ALLOW-COLUMN-SEARCHING  = TRUE
            READ-ONLY               = NO
            QUERY                   = ghRycsmQuery1
        TRIGGERS: 
            ON 'row-display':U
                PERSISTENT RUN rowDisplayRycsm IN THIS-PROCEDURE.
            ON 'row-leave':U
                PERSISTENT RUN rowLeave IN THIS-PROCEDURE.
            ON 'value-changed':U
                PERSISTENT RUN valueChangedRycsm IN THIS-PROCEDURE.
            ON 'end-resize':U ANYWHERE
                PERSISTENT RUN resizeAttributeBrowse IN THIS-PROCEDURE.
        END TRIGGERS.

    ASSIGN
        ghRycsmBrowse:VISIBLE = NO
        ghRycsmBrowse:SENSITIVE = NO.

    ghRycsmQuery1:QUERY-OPEN().


    hBufferField    = ghRycsmQuery1Buffer:BUFFER-FIELD("source_object_instance_obj").
    ghSource        = ghRycsmBrowse:ADD-CALC-COLUMN("char":u, /* datatype */
                                                    "x(35)":u, /* Format */
                                                    ENTRY(LOOKUP(STRING(ghSourceObj), gcLinkObjects, coSourceLink:DELIMITER) + 1,
                                                          gcLinkObjects, coSourceLink:DELIMITER),
                                                    "Source":u). /* Column Label */

    hBufferField    = ghRycsmQuery1Buffer:BUFFER-FIELD("link_name").
    ghLinkName      = ghRycsmBrowse:ADD-LIKE-COLUMN(hBufferField).

    hBufferField    = ghRycsmQuery1Buffer:BUFFER-FIELD("target_object_instance_obj").
    ghTarget        = ghRycsmBrowse:ADD-CALC-COLUMN("char":u, /* datatype */
                                                    "x(35)":u, /* Format */
                                                    ENTRY(LOOKUP(STRING(ghTargetObj), gcLinkObjects, coTargetLink:DELIMITER) + 1,
                                                          gcLinkObjects, coSourceLink:DELIMITER),
                                                    "Target":u). /* Column Label */


    hBufferField    = ghRycsmQuery1Buffer:BUFFER-FIELD("user_defined_link").    
    ghUserDef       = ghRycsmBrowse:ADD-LIKE-COLUMN(hBufferField).
    ghUserDef:LABEL = "User Def.":u.


    ASSIGN
        ghRycsmBrowse:NUM-LOCKED-COLUMNS = 1    
        ghRycsmBrowse:SENSITIVE          = YES
        ghRycsmBrowse:HIDDEN             = NO
        .

    ghRycsmBrowse:SET-REPOSITIONED-ROW(1,"CONDITIONAL":u).

    ASSIGN
        buRycsmAdd:X    = ghRycsmBrowse:X
        buRycsmAdd:Y    = buRycavAdd:Y
        buRycsmUpdate:X = buRycsmAdd:X + buRycsmAdd:WIDTH-PIXELS
        buRycsmUpdate:Y = buRycsmAdd:Y
        buRycsmDelete:X = buRycsmAdd:X + buRycsmAdd:WIDTH-PIXELS + buRycsmUpdate:WIDTH-PIXELS
        buRycsmDelete:Y = buRycsmAdd:Y.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildScreen vTableWin 
PROCEDURE buildScreen :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /* populate combos */
    ASSIGN
        coAttribute:DELIMITER            IN FRAME {&FRAME-NAME} = CHR(3)
        coAttribute:LIST-ITEM-PAIRS      IN FRAME {&FRAME-NAME} = coAttribute:LIST-ITEM-PAIRS      /* '0' + CHR(3) + '0'*/
        coAttributeGroup:DELIMITER       IN FRAME {&FRAME-NAME} = CHR(3)
        coAttributeGroup:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = coAttributeGroup:LIST-ITEM-PAIRS /* '0' + CHR(3) + '0'    */
        coLink:DELIMITER                 IN FRAME {&FRAME-NAME} = CHR(3)
        coLink:LIST-ITEM-PAIRS           IN FRAME {&FRAME-NAME} = coLink:LIST-ITEM-PAIRS            /*'0' + CHR(3) + '0'*/
        coSourceLink:DELIMITER           IN FRAME {&FRAME-NAME} = CHR(3)
        coSourceLink:LIST-ITEM-PAIRS     IN FRAME {&FRAME-NAME} = coSourceLink:LIST-ITEM-PAIRS     /*'0' + CHR(3) + '0'    */
        coTargetLink:DELIMITER           IN FRAME {&FRAME-NAME} = CHR(3)
        coTargetLink:LIST-ITEM-PAIRS     IN FRAME {&FRAME-NAME} = coTargetLink:LIST-ITEM-PAIRS     /*'0' + CHR(3) + '0'*/
        coPage:DELIMITER                 IN FRAME {&FRAME-NAME} = CHR(3)
        coPage:LIST-ITEM-PAIRS           IN FRAME {&FRAME-NAME} = coPage:LIST-ITEM-PAIRS           /*'0' + CHR(3) + '0'*/ .        

    RUN getComboQuery.

    RUN buildCombo.

    IF NOT VALID-HANDLE(ghRycpaBrowse) THEN
       RUN buildRycpaBrowse.

    RUN populateRycpaBrowse.

    IF NOT VALID-HANDLE(ghRycoiBrowse) THEN 
       RUN buildRycoiBrowse.

    RUN populateRycoiBrowse.

    IF NOT VALID-HANDLE(ghRycsmBrowse) THEN
       RUN buildRycsmBrowse.

    RUN populateRycsmBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject vTableWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    RUN SUPER.

    /* Code placed here will execute AFTER standard behavior.    */
    /* This must be done after super as SUPER will confirm exit */

    IF VALID-HANDLE (ghRycoiQuery1) THEN
        DELETE OBJECT ghRycoiQuery1.
    IF VALID-HANDLE (ghRycoiQuery2) THEN
        DELETE OBJECT ghRycoiQuery2.
    IF VALID-HANDLE (ghRycavQuery1) THEN
        DELETE OBJECT ghRycavQuery1.
    IF VALID-HANDLE (ghRycsmQuery1) THEN
        DELETE OBJECT ghRycsmQuery1.
    IF VALID-HANDLE (ghRycpaQuery1) THEN
        DELETE OBJECT ghRycpaQuery1.
    IF VALID-HANDLE (ghRycpaQuery2) THEN
        DELETE OBJECT ghRycpaQuery2.


    IF VALID-HANDLE (ghRycoiBrowse) THEN
        DELETE OBJECT ghRycoiBrowse.
    IF VALID-HANDLE (ghRycavBrowse) THEN
        DELETE OBJECT ghRycavBrowse.
    IF VALID-HANDLE (ghRycsmBrowse) THEN
        DELETE OBJECT ghRycsmBrowse.
    IF VALID-HANDLE (ghRycpaBrowse) THEN
        DELETE OBJECT ghRycpaBrowse.

    ASSIGN
        ghAttributeGroup    = ?
        ghAttribute         = ?
        ghAttributeValue    = ?
        ghConstantValue     = ?
        ghConstantValue     = ?
        ghInheritedValue    = ?
        ghTtObjectInstance  = ?
        ghRycoiBrowse       = ?
        ghRycoiQuery1       = ?
        ghRycoiQuery2       = ?
        ghTtAttributeValue  = ?
        ghRycavBrowse       = ?
        ghRycavQuery1       = ?
        ghTtSmartlink       = ?
        ghRycsmBrowse       = ?
        ghRycsmQuery1       = ?
        ghTtPage            = ?
        ghRycpaBrowse       = ?
        ghRycpaQuery1       = ?
        ghRycpaQuery2       = ?
        ghProductCode       = ?
        ghProductModuleCode = ?
        ghObjectFilename    = ?
        ghObjectDescription = ?
        ghObjectTypeCode    = ?
        ghLayoutPosition    = ?
        ghPageLabel         = ?
        ghSourceObj         = ?
        ghSource            = ?
        ghTargetObj         = ?
        ghTarget            = ?
        ghUserDef           = ?
        ghLinkName          = ?
        ghLayoutName        = ?.

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

  DEFINE VARIABLE cGroupAssignLink        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iLoop                   AS INTEGER      NO-UNDO.

  IF VALID-HANDLE(ghRycoiQuery1Buffer) THEN
     ghRycoiQuery1Buffer:EMPTY-TEMP-TABLE().

  IF VALID-HANDLE(ghRycoiQuery2Buffer) THEN
     ghRycoiQuery2Buffer:EMPTY-TEMP-TABLE().

  IF VALID-HANDLE(ghRycavQuery1Buffer) THEN
     ghRycavQuery1Buffer:EMPTY-TEMP-TABLE().

  RUN SUPER( INPUT pcColValues).

  /* Code placed here will execute AFTER standard behavior.    */

  cGroupAssignLink = DYNAMIC-FUNCTION("LinkHandles":u, INPUT "GroupAssign-Source").

  DO iLoop = 1 TO NUM-ENTRIES(cGroupAssignLink):
     ghGroupAssign = WIDGET-HANDLE(ENTRY(iLoop, cGroupAssignLink)).
     IF  VALID-HANDLE(ghGroupAssign)
     AND LOOKUP("getTempTables":u, ghGroupAssign:INTERNAL-ENTRIES) > 0 THEN
     DO:
         RUN getTempTables IN ghGroupAssign
             (OUTPUT gcContainerMode,          
              OUTPUT gdSmartObjectObj,
              OUTPUT gdObjectObj,
              OUTPUT gdObjectTypeObj,
              OUTPUT TABLE-HANDLE ghTtObjectInstance,
              OUTPUT TABLE-HANDLE ghTtAttributeValue,
              OUTPUT TABLE-HANDLE ghTtPage,
              OUTPUT TABLE-HANDLE ghTtSmartlink).
         LEAVE.
     END.
  END.

  RUN buildScreen.

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

  RUN setRycoiWidgetState.
  /*
  ENABLE 
      {&RycpaUpdateButtons} 
      {&RycoiUpdateButtons}
      {&RycavUpdateButtons}
      {&RycsmUpdateButtons}
  WITH FRAME {&FRAME-NAME}.

  DISABLE
      {&RycpaSaveButtons}
      {&RycpaFields}
      {&RycoiSaveButtons}
      {&RycoiFields}
      {&RycavSaveButtons}
      {&RycavFields}
      {&RycsmSaveButtons}
      {&RycsmFields}
  WITH FRAME {&FRAME-NAME}.
  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filterCombo vTableWin 
PROCEDURE filterCombo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFilterInfo    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cString             AS CHARACTER    NO-UNDO INITIAL "":U.
DEFINE VARIABLE cNewListItemPairs   AS CHARACTER    NO-UNDO INITIAL "":U.
DEFINE VARIABLE iLoop               AS INTEGER      NO-UNDO.

FIND FIRST ttComboData EXCLUSIVE-LOCK
    WHERE ttComboData.hWidget = coAttribute:HANDLE IN FRAME {&FRAME-NAME} NO-ERROR.

IF  LENGTH(pcFilterInfo) > 0 THEN DO:
    DO iLoop = 1 TO NUM-ENTRIES(ttComboData.cListItemPairs, coAttribute:DELIMITER) BY 2:
        ASSIGN
            cString = ENTRY(iLoop, ttComboData.cListItemPairs, coAttribute:DELIMITER) + coAttribute:DELIMITER +
                      ENTRY(iLoop + 1, ttComboData.cListItemPairs, coAttribute:DELIMITER).

        IF DECIMAL(ENTRY(2, ENTRY(1, cString, coAttribute:DELIMITER), "|":u)) = DECIMAL(pcFilterInfo) THEN
            ASSIGN
                cNewListItemPairs = TRIM(cNewListItemPairs) + TRIM(ENTRY(1, cString, "|":U)) + coAttribute:DELIMITER +
                                    TRIM(ENTRY(2, cString, coAttribute:DELIMITER)) + coAttribute:DELIMITER.

    END.

    ASSIGN
        ttComboData.cListItemPairs  = TRIM(cNewListItemPairs, coAttribute:DELIMITER).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getComboQuery vTableWin 
PROCEDURE getComboQuery :
/*------------------------------------------------------------------------------
  Purpose:      Fetch combo queries for local combos

  Parameters:   None

  Notes:        Specific to this procedure, hence the naming
                so as not to get confused with the generic getComboQuery.
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            coAttribute:DELIMITER = CHR(3)
            coAttributeGroup:DELIMITER = CHR(3)
            coLink:DELIMITER = CHR(3)
            coSourceLink:DELIMITER = CHR(3)
            coTargetLink:DELIMITER = CHR(3)
            .

      /* 1. populate coAttributeGroup from ryc_attribute_group */
      FIND FIRST ttComboData
           WHERE ttComboData.hWidget = coAttributeGroup:HANDLE
           NO-ERROR.
      IF NOT AVAILABLE ttComboData THEN CREATE ttComboData.
      /* set-up appropriate values here for your query, fields to display, etc. */
      ASSIGN
        ttComboData.cWidgetName = "coAttributeGroup":U
        ttComboData.cWidgetType = "decimal":U
        ttComboData.hWidget = coAttributeGroup:HANDLE
        ttComboData.cForEach = "FOR EACH ryc_attribute_group NO-LOCK BY ryc_attribute_group.attribute_group_name":U
        ttComboData.cBufferList = "ryc_attribute_group":U
        ttComboData.cKeyFieldName = "ryc_attribute_group.attribute_group_obj":U
        ttComboData.cDescFieldNames = "ryc_attribute_group.attribute_group_name":U
        ttComboData.cDescSubstitute = "&1":U
        ttComboData.cFlag = "":U
        ttComboData.cCurrentKeyValue = "":U
        ttComboData.cListItemDelimiter = coAttributeGroup:DELIMITER
        ttComboData.cListItemPairs = "":U
        ttComboData.cCurrentDescValue = "":U
        .

      /* 2. populate coAttribute from ryc_attribute */
      FIND FIRST ttComboData
           WHERE ttComboData.hWidget = coAttribute:HANDLE
           NO-ERROR.
      IF NOT AVAILABLE ttComboData THEN CREATE ttComboData.
      /* set-up appropriate values here for your query, fields to display, etc. */
      ASSIGN
        ttComboData.cWidgetName = "coAttribute":U
        ttComboData.cWidgetType = "character":U
        ttComboData.hWidget = coAttribute:HANDLE
        ttComboData.cForEach = "FOR EACH ryc_attribute NO-LOCK BY ryc_attribute.attribute_label":U
        ttComboData.cBufferList = "ryc_attribute":U
        ttComboData.cKeyFieldName = "ryc_attribute.attribute_label":U
        /* store the attribute_group_obj in cDescFieldNames temporarily to find the info we want to filter on */
        ttComboData.cDescFieldNames = "ryc_attribute.attribute_label,ryc_attribute.attribute_group_obj":U
        ttComboData.cDescSubstitute = "&1|&2":U
        ttComboData.cFlag = "":U
        ttComboData.cCurrentKeyValue = "":U
        ttComboData.cListItemDelimiter = coAttribute:DELIMITER
        ttComboData.cListItemPairs = "":U
        ttComboData.cCurrentDescValue = "":U.

      /* 3. populate coLink from ryc_smartlink_type */
      FIND FIRST ttComboData
           WHERE ttComboData.hWidget = coLink:HANDLE
           NO-ERROR.
      IF NOT AVAILABLE ttComboData THEN CREATE ttComboData.
      /* set-up appropriate values here for your query, fields to display, etc. */
      ASSIGN
        ttComboData.cWidgetName = "coLink":U
        ttComboData.cWidgetType = "decimal":U
        ttComboData.hWidget = coLink:HANDLE
        ttComboData.cForEach = "FOR EACH ryc_smartlink_type NO-LOCK BY ryc_smartlink_type.link_name":U
        ttComboData.cBufferList = "ryc_smartlink_type":U
        ttComboData.cKeyFieldName = "ryc_smartlink_type.smartlink_type_obj":U
        /* store the attribute_group_obj in cDescFieldNames temporarily to find the info we want to filter on */
        ttComboData.cDescFieldNames = "ryc_smartlink_type.link_name":U
        ttComboData.cDescSubstitute = "&1":U
        ttComboData.cFlag = "":U
        ttComboData.cCurrentKeyValue = "":U
        ttComboData.cListItemDelimiter = coLink:DELIMITER
        ttComboData.cListItemPairs = "":U
        ttComboData.cCurrentDescValue = "":U.

      /* 4. populate coLayout */
      FIND FIRST ttComboData
           WHERE ttComboData.hWidget = coLayout:HANDLE
           NO-ERROR.
      IF NOT AVAILABLE ttComboData THEN CREATE ttComboData.

      /* set-up appropriate values here for your query, fields to display, etc. */
      ASSIGN
        ttComboData.cWidgetName = "coLayout":U
        ttComboData.cWidgetType = "decimal":U
        ttComboData.hWidget = coLayout:HANDLE
        ttComboData.cForEach =
          "FOR EACH ryc_layout NO-LOCK " + 
          "BY ryc_layout.layout_name":U
        ttComboData.cBufferList = "ryc_layout":U
        ttComboData.cKeyFieldName = "ryc_layout.layout_obj":U
        ttComboData.cDescFieldNames = "ryc_layout.layout_name":U
        ttComboData.cDescSubstitute = "&1":U
        ttComboData.cFlag = "":U
        ttComboData.cCurrentKeyValue = "":U
        ttComboData.cListItemDelimiter = coLayout:DELIMITER
        /* add this-procedure (container smartobject) to list item pairs*/
        ttComboData.cListItemPairs = "":u
        ttComboData.cCurrentDescValue = "":U.

    END.

    RUN af/app/afcobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).

    FIND FIRST ttComboData NO-LOCK
        WHERE ttComboData.hWidget = coAttribute:HANDLE NO-ERROR.

    IF  AVAILABLE ttComboData THEN
        ASSIGN gcDataString = ttComboData.cListItemPairs.

    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTempTables vTableWin 
PROCEDURE getTempTables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER phObjectInstance  AS HANDLE       NO-UNDO.
    DEFINE OUTPUT PARAMETER phAttributeValue  AS HANDLE       NO-UNDO.
    DEFINE OUTPUT PARAMETER phPage            AS HANDLE       NO-UNDO.
    DEFINE OUTPUT PARAMETER phSmartlink       AS HANDLE       NO-UNDO.

    ASSIGN        
        phObjectInstance  = ghTtObjectInstance
        phAttributeValue  = ghTtAttributeValue
        phPage            = ghTtPage
        phSmartlink       = ghTtSmartlink.

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

  SUBSCRIBE PROCEDURE THIS-PROCEDURE  TO 'LookupComplete   '     IN THIS-PROCEDURE.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE  TO 'LookupDisplayComplete' IN THIS-PROCEDURE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LookupDisplayComplete vTableWin 
PROCEDURE LookupDisplayComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcFieldList                AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER pcFieldValueList           AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER pcKeyFieldValue            AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER phLookupProc               AS HANDLE        NO-UNDO.


DEFINE VARIABLE hColumn                            AS HANDLE        NO-UNDO.


CASE phLookupProc:
    WHEN h_dynlookup THEN
    DO:

        IF (ghRycoiQuery1Buffer:AVAILABLE AND gcRycoiUpdateState EQ "U":U) OR gcRycoiUpdateState EQ "A":U THEN
        DO:
            ASSIGN
                ghObjectFilename:SCREEN-VALUE    = ENTRY(2,pcFieldValueList,CHR(1))
                ghProductCode:SCREEN-VALUE       = ENTRY(5,pcFieldValueLIst,CHR(1))
                ghProductModuleCode:SCREEN-VALUE = ENTRY(6,pcFieldValueList,CHR(1))
                ghObjectDescription:SCREEN-VALUE = ENTRY(7,pcFieldValueList,CHR(1))
                ghObjectTypeCode:SCREEN-VALUE    = ENTRY(8,pcFieldValueList,CHR(1))
                .
        END.

    END.
END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modRycav vTableWin 
PROCEDURE modRycav :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modRycav2 vTableWin 
PROCEDURE modRycav2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcAction    AS CHARACTER    NO-UNDO.

/*
DEFINE VARIABLE hBuffer             AS HANDLE       NO-UNDO.
DEFINE VARIABLE hBufferField        AS HANDLE       NO-UNDO.
DEFINE VARIABLE hObjectInst         AS HANDLE       NO-UNDO.
DEFINE VARIABLE hObjectInstField    AS HANDLE       NO-UNDO.

RUN widgetStateRycav(INPUT pcAction). /* enable/disable widgets associated with browse for pcAction */

hbuffer = ghttAttributeValue:DEFAULT-BUFFER-HANDLE. 

CASE pcAction:
    WHEN "add":u THEN DO:
        hObjectInst = ghttObjectInstance:DEFAULT-BUFFER-HANDLE. /* buffer handle of object instance table, from which we want to assign values */

        hbuffer:BUFFER-CREATE.  /* Create attribute value record */

        hBufferField = hBuffer:BUFFER-FIELD("container_smartobject_obj":u). /* handle to ttRycAttributeValue.container_smartobject_obj field */
        hBufferField:BUFFER-VALUE = gdContainer. 

        hBufferField = hBuffer:BUFFER-FIELD("object_instance_obj":u). /* handle to ttRycAttributeValue.object_instance_obj field */
        hObjectInstField = hObjectInst:BUFFER-FIELD("object_instance_obj":u). /* handle to ttobjectInstance.object_instance_obj field */
        hBufferField:BUFFER-VALUE = hObjectInstField:BUFFER-VALUE. /* Assign value */

        hBufferField = hBuffer:BUFFER-FIELD("rowmod":u). /* assign rowmod */
        hBufferField:BUFFER-VALUE = "A":u.

    END.

    WHEN "delete":u THEN DO:
        /* Confirm deletion */
        /* ... */

        hBufferField = hBuffer:BUFFER-FIELD("rowmod":u).
        IF  hBuffer:BUFFER-VALUE = "A":u THEN
            /* If rowmod = "A", we have just added the record to the TT and we can delete it from the TT */
            hBuffer:BUFFER-DELETE().
        ELSE
            /* otherwise rowmod = "u" and the record must be deleted from the DB.  We, therefore, assign rowmod = "D" */
            hBufferField:BUFFER-VALUE = "D":u.
    END.
    WHEN "cancel":u THEN DO:
        /* cancel all changes made in this since last saved  */ 
        /* refetch records from Database */
        /* ... */
        /***DIAG***/
        MESSAGE {&line-number} PROGRAM-NAME(1) SKIP
            "cancel - still to code "
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END CASE.

ghRycavQuery:QUERY-OPEN().
ghRycavQuery:REPOSITION-TO-ROWID(hbuffer:ROWID).
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modRycoi vTableWin 
PROCEDURE modRycoi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcAction   AS CHARACTER             NO-UNDO.

    DEFINE VARIABLE hField             AS HANDLE                NO-UNDO.
    DEFINE VARIABLE iRowNum            AS INTEGER               NO-UNDO.
    DEFINE VARIABLE lAnswer            AS LOGICAL               NO-UNDO.
    DEFINE VARIABLE rTTRycoi           AS ROWID                 NO-UNDO.
    DEFINE VARIABLE iResultRow         AS INTEGER               NO-UNDO.
    DEFINE VARIABLE hLookup            AS HANDLE                NO-UNDO.

    CASE pcAction:
        WHEN "add":u THEN DO WITH FRAME {&FRAME-NAME}:
            iRowNum = ghRycoiBrowse:FOCUSED-ROW.
            ghRycoiBrowse:INSERT-ROW("AFTER":u).

            hLookup = DYNAMIC-FUNCTION ("getLookupHandle":U IN h_dynlookup).
            hLookup:SCREEN-VALUE = "":U.
            ASSIGN
                fiLayoutPosition:SCREEN-VALUE = ""
                coPage:SCREEN-VALUE           = "0":U.
            gcRycoiUpdateState         = "A":U.
            RUN setRycoiWidgetState.
            ghRycoiBrowse:SELECT-ROW(iRowNum + 1).
        END.
        WHEN "delete":u THEN DO WITH FRAME {&FRAME-NAME}:
            IF ghRycoiQuery1Buffer:AVAILABLE THEN
            DO:
                MESSAGE
                   "Are you sure?"
                   VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                   SET lAnswer.
                IF lAnswer THEN
                DO:
                    hField = ghRycoiQuery1Buffer:BUFFER-FIELD("rowMod":U).
                    hField:BUFFER-VALUE = "D":U.
                    iResultRow = ghRycoiQuery1:CURRENT-RESULT-ROW.                        
                    ghRycoiQuery1:QUERY-OPEN().
                    IF ghRycoiQuery1:NUM-RESULTS GT 0 THEN
                    DO:
                       ghRycoiQuery1:REPOSITION-TO-ROW(IF iResultRow LE ghRycoiQuery1:NUM-RESULTS THEN 
                                                          iResultRow 
                                                       ELSE ghRycoiQuery1:NUM-RESULTS) NO-ERROR.
                       ghRycoiQuery1:GET-NEXT NO-ERROR.
                       IF ghRycoiQuery1:QUERY-OFF-END THEN
                          ghRycoiQuery1:GET-PREV NO-ERROR.
                    END.
                    gcRycoiUpdateState        = "":U.
                    RUN setRycoiWidgetState.
                    APPLY "value-changed":U TO ghRycoiBrowse.
                    {set DataModified TRUE}.
                END.
            END.        
        END.
        WHEN "update":u THEN DO WITH FRAME {&FRAME-NAME}:
            IF ghRycoiQuery1Buffer:AVAILABLE THEN
            DO:
                gcRycoiUpdateState         = "U":U.
                RUN setRycoiWidgetState.
            END.
        END.
        WHEN "cancel":u THEN DO:
            IF (ghRycoiQuery1Buffer:AVAILABLE AND gcRycoiUpdateState EQ "U":U) OR gcRycoiUpdateState EQ "A":U THEN
            DO:
                iResultRow = ghRycoiQuery1:CURRENT-RESULT-ROW.
                ghRycoiQuery1:QUERY-OPEN().
                IF ghRycoiQuery1:NUM-RESULTS GT 0 THEN
                   ghRycoiQuery1:REPOSITION-TO-ROW(IF iResultRow LE ghRycoiQuery1:NUM-RESULTS THEN 
                                                      iResultRow 
                                                   ELSE ghRycoiQuery1:NUM-RESULTS) NO-ERROR.
            END.
            gcRycoiUpdateState         = "":U.
            RUN setRycoiWidgetState.
            APPLY "value-changed":U TO ghRycoiBrowse.
        END.
        WHEN "save":U THEN
        DO:
            IF (ghRycoiQuery1Buffer:AVAILABLE AND gcRycoiUpdateState EQ "U":U) OR gcRycoiUpdateState EQ "A":U THEN
            DO:
                APPLY "LEAVE":U TO fiLayoutPosition IN FRAME {&FRAME-NAME}.

                IF gcRycoiUpdateState EQ "A":U THEN
                DO:
                    iRowNum = 110000 + ghRycoiQuery1:NUM-RESULTS + 1.
                    ghRycoiQuery1Buffer:BUFFER-CREATE().

                    hField = ghRycoiQuery1Buffer:BUFFER-FIELD("rowMod":U).
                    hField:BUFFER-VALUE = "A":U.
                    hField = ghRycoiQuery1Buffer:BUFFER-FIELD("rowNum":U).
                    hField:BUFFER-VALUE = iRowNum.
                    hField = ghRycoiQuery1Buffer:BUFFER-FIELD("rowIdent":U).
                    hField:BUFFER-VALUE = "0":U.
                    hField = ghRycoiQuery1Buffer:BUFFER-FIELD("object_instance_obj":U).
                    hField:BUFFER-VALUE = 0.
                    hField = ghRycoiQuery1Buffer:BUFFER-FIELD("container_smartobject_obj":U).
                    hField:BUFFER-VALUE = gdSmartObjectObj.

                END.

                rTTRycoi = ghRycoiQuery1Buffer:ROWID.

                hField = ghRycoiQuery1Buffer:BUFFER-FIELD("smartobject_obj").
                hField:BUFFER-VALUE = DECIMAL(DYNAMIC-FUNCTION ("getDataValue":U IN h_dynlookup)).

                hField = ghRycoiQuery1Buffer:BUFFER-FIELD("product_code":U).
                hField:BUFFER-VALUE = ghProductCode:SCREEN-VALUE.

                hField = ghRycoiQuery1Buffer:BUFFER-FIELD("product_module_code":U).
                hField:BUFFER-VALUE = ghProductModuleCode:SCREEN-VALUE.

                hField = ghRycoiQuery1Buffer:BUFFER-FIELD("object_filename":U).
                hField:BUFFER-VALUE = ghObjectFilename:SCREEN-VALUE.

                hField = ghRycoiQuery1Buffer:BUFFER-FIELD("layout_position").
                hField:BUFFER-VALUE = ghLayoutPosition:SCREEN-VALUE.

                hField = ghRycoiQuery1Buffer:BUFFER-FIELD("object_description":U).
                hField:BUFFER-VALUE = ghObjectDescription:SCREEN-VALUE.

                hField = ghRycoiQuery1Buffer:BUFFER-FIELD("object_type_code":U).
                hField:BUFFER-VALUE = ghObjectTypeCode:SCREEN-VALUE.

                hField = ghRycoiQuery1Buffer:BUFFER-FIELD("page_label":U).
                hField:BUFFER-VALUE = ghPageLabel:SCREEN-VALUE.

                hField = ghRycoiQuery1Buffer:BUFFER-FIELD("page_obj":U).
                hField:BUFFER-VALUE = coPage.

                IF gcRycoiUpdateState EQ "A":U THEN
                DO:
                    ghRycoiQuery1:QUERY-OPEN().
                    IF ghRycoiQuery1:NUM-RESULTS GT 0 THEN
                       ghRycoiQuery1:REPOSITION-TO-ROWID(rTTRycoi) NO-ERROR.
                END.

            END.
            gcRycoiUpdateState         = "":U.
            RUN setRycoiWidgetState.
            APPLY "value-changed":U TO ghRycoiBrowse.
            {set DataModified TRUE}.
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modRycoi2 vTableWin 
PROCEDURE modRycoi2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcAction    AS CHARACTER    NO-UNDO.

/*
DEFINE VARIABLE hBuffer             AS HANDLE       NO-UNDO.
DEFINE VARIABLE hBufferField        AS HANDLE       NO-UNDO.
DEFINE VARIABLE hObjectInst         AS HANDLE       NO-UNDO.
DEFINE VARIABLE hObjectInstField    AS HANDLE       NO-UNDO.
DEFINE VARIABLE hBuffer2            AS HANDLE       NO-UNDO.
DEFINE VARIABLE hQuery              AS HANDLE       NO-UNDO.
DEFINE VARIABLE iLoop               AS INTEGER      NO-UNDO.

RUN widgetStateRycoi(INPUT pcAction). /* enable/disable widgets associated with browse for pcAction */

hbuffer = ghRycoiQuery1Buffer. 

CASE pcAction:
    WHEN "add":u THEN DO:
        hbuffer:BUFFER-CREATE.  /* Create object instance record */

        hBufferField = hBuffer:BUFFER-FIELD("container_smartobject_obj":u). /* handle to ttRycObjectInstance.container_smartobject_obj field */
        hBufferField:BUFFER-VALUE = gdContainer. /* Assign value */

        hBufferField = hBuffer:BUFFER-FIELD("rowmod":u). /* Assign rowmod */
        hBufferField:BUFFER-VALUE = "A":u.
        ghRycoiQuery1:REPOSITION-TO-ROWID(hbuffer:ROWID).
    END.

    WHEN "delete":u THEN DO:
        /* Confirm deletion */

        hBufferField = hBuffer:BUFFER-FIELD("rowmod":u).
        IF  hBufferField:BUFFER-VALUE = "A":u THEN
            /* If rowmod = "A", we have just added the record to the TT and we can delete it from the TT */
            hBuffer:BUFFER-DELETE().
        ELSE
            /* otherwise rowmod = "u" and the record must be deleted from the DB.  We, therefore, assign rowmod = "D" */
            hBufferField:BUFFER-VALUE = "D":u.

        ghRycoiQuery1:QUERY-CLOSE().
        ghRycoiQuery1:QUERY-OPEN().
        RUN buildLinkCombo.
    END.

    WHEN "cancel":u THEN DO:
        /* cancel all changes made in this since last saved  */ 
        hBufferField = hBuffer:BUFFER-FIELD("rowmod":u). /* Assign rowmod */
        IF  hBufferField:BUFFER-VALUE = "A":u THEN
            hbuffer:BUFFER-DELETE().
        ELSE DO:
            /*
            hBufferField = hBuffer:BUFFER-FIELD("rowIdent").
            hBuffer2 = ghTtPage:DEFAULT-BUFFER-HANDLE.
            CREATE QUERY hQuery.
            hQuery:ADD-BUFFER(hBuffer2).
            hQuery:QUERY-PREPARE("FOR FIRST ttRycObjectInstance " + 
                                    "WHERE ttRycObjectInstance.rowIdent = ":u + hBufferField:BUFFER-VALUE +
                                    " AND   ttRycObjectInstance.rowMod   = '':u ").
            hQuery:QUERY-OPEN().
            IF hBuffer2:AVAILABLE THEN
                hBuffer:BUFFER-COPY(hBuffer2).

            IF VALID-HANDLE(hBuffer2) THEN DELETE OBJECT hBuffer2.
            IF VALID-HANDLE(hQuery)   THEN DELETE OBJECT hQuery.
            */
        END.
        ghRycoiQuery1:QUERY-CLOSE().
        ghRycoiQuery1:QUERY-OPEN().
    END.

    WHEN "save":u THEN DO:
        ASSIGN
            hBufferField = hBuffer:BUFFER-FIELD("object_instance_obj")
            hBufferField:BUFFER-VALUE = DECIMAL(DYNAMIC-FUNCTION ("getDataValue":U IN h_dynlookup))
            hBufferField = hBuffer:BUFFER-FIELD("layout_position")
            hBufferField:BUFFER-VALUE = fiLayoutPosition:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            ghLayoutPosition:SCREEN-VALUE = fiLayoutPosition:SCREEN-VALUE
            hBufferField = hBuffer:BUFFER-FIELD("page_obj")
            hBufferField:BUFFER-VALUE = DECIMAL(coPage:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

        IF  DECIMAL(coPage:SCREEN-VALUE) = 0 THEN
            ghPageLabel:SCREEN-VALUE = '':u.
        ELSE DO iLoop = 2 TO NUM-ENTRIES(coPage:LIST-ITEM-PAIRS, coPage:DELIMITER) BY 2:
            IF  hBufferField:BUFFER-VALUE = DECIMAL(ENTRY(iLoop, coPage:LIST-ITEM-PAIRS, coPage:DELIMITER)) THEN DO:
                ghPageLabel:SCREEN-VALUE = ENTRY(iLoop - 1, coPage:LIST-ITEM-PAIRS, coPage:DELIMITER).
                LEAVE.
            END.
        END.
        hBufferField = hBuffer:BUFFER-FIELD("page_label").
        hBufferField:BUFFER-VALUE = ghPageLabel:SCREEN-VALUE.

        ghRycoiBrowse:REFRESH().

/*        hBufferField = hBuffer:BUFFER-FIELD('rowmod':u).
        IF hBufferField:BUFFER-VALUE BEGINS 'a':u THEN DO:
            ghRycoiQuery:QUERY-CLOSE().
            RUN buildLinkCombo.
        END.*/
    END.
END CASE.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modRycpa vTableWin 
PROCEDURE modRycpa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcAction    AS CHARACTER    NO-UNDO.

/*
DEFINE VARIABLE hBuffer             AS HANDLE       NO-UNDO.
DEFINE VARIABLE hBuffer2            AS HANDLE       NO-UNDO.
DEFINE VARIABLE hQuery              AS HANDLE       NO-UNDO.
DEFINE VARIABLE hBufferField        AS HANDLE       NO-UNDO.
DEFINE VARIABLE hObjectInst         AS HANDLE       NO-UNDO.
DEFINE VARIABLE hObjectInstField    AS HANDLE       NO-UNDO.

RUN widgetStateRycpa(INPUT pcAction). /* enable/disable widgets associated with browse for pcAction */

hbuffer = ghRycpaQuery1Buffer.

CASE pcAction:
    WHEN "add":u THEN DO:
        /* Create the record here and now, rather than on save.  Saves us having to store an action */
        /* as we can check the rowmod flag to see what we are doing.  */
        hbuffer:BUFFER-CREATE.  /* Create attribute value record */

        hBufferField = hBuffer:BUFFER-FIELD("container_smartobject_obj":u). /* handle to ttRycObjectInstance.container_smartobject_obj field */
        hBufferField:BUFFER-VALUE = gdContainer. /* Assign value */

        hBufferField = hBuffer:BUFFER-FIELD("rowmod":u). /* Assign rowmod */
        hBufferField:BUFFER-VALUE = "A":u.
    END.

    WHEN "delete":u THEN DO:
        /* Confirm deletion */
        /* ... */
        hBufferField = hBuffer:BUFFER-FIELD("rowmod":u).

        IF  hBuffer:BUFFER-VALUE = "A":u THEN
            /* If rowmod = "A", we have just added the record to the TT and we can delete it from the TT */
            hBuffer:BUFFER-DELETE().
        ELSE
            /* otherwise rowmod = "u" and the record must be deleted from the DB.  We, therefore, assign rowmod = "D" */
            hBufferField:BUFFER-VALUE = "D":u.
    END.

    WHEN "cancel":u THEN DO:
        /* cancel all changes made in this since last saved  */ 
        hBufferField = hBuffer:BUFFER-FIELD("rowmod":u). /* Assign rowmod */
        IF  hBufferField:BUFFER-VALUE = "A":u THEN
            hbuffer:BUFFER-DELETE().
        ELSE DO:
            hBufferField = hBuffer:BUFFER-FIELD("rowIdent").
            hBuffer2 = ghTtPage:DEFAULT-BUFFER-HANDLE.
            CREATE QUERY hQuery.
            hQuery:ADD-BUFFER(hBuffer2).
            hQuery:QUERY-PREPARE("FOR FIRST ttRycPage " + 
                                    "WHERE ttRycPage.rowIdent = ":u + hBufferField:BUFFER-VALUE +
                                    " AND  ttRycPage.rowMod   = '':u ").
            hQuery:QUERY-OPEN().
            IF hBuffer2:AVAILABLE THEN
                hBuffer:BUFFER-COPY(hBuffer2).

            IF VALID-HANDLE(hBuffer2) THEN DELETE OBJECT hBuffer2.
            IF VALID-HANDLE(hQuery)   THEN DELETE OBJECT hQuery.
        END.
    END.

    WHEN "save":u THEN DO:
        ASSIGN
            ToCreate                  = toCreate:SCREEN-VALUE IN FRAME {&FRAME-NAME} BEGINS "y"
            ToModify                  = toCreate:SCREEN-VALUE IN FRAME {&FRAME-NAME} BEGINS "y"
            ToView                    = toCreate:SCREEN-VALUE IN FRAME {&FRAME-NAME} BEGINS "y".
        ASSIGN
            hbuffer                   = ghttPage:DEFAULT-BUFFER-HANDLE
            hBufferField              = hBuffer:BUFFER-FIELD("layout_obj":u)
            hBufferField:BUFFER-VALUE = DECIMAL(coLayout:SCREEN-VALUE)
            hBufferField              = hBuffer:BUFFER-FIELD("layout_name":u)
            hBufferField:BUFFER-VALUE = ENTRY(LOOKUP(coLayout:SCREEN-VALUE, coLayout:LIST-ITEM-PAIRS, coLayout:DELIMITER) - 1, 
                                              coLayout:LIST-ITEM-PAIRS, coLayout:DELIMITER)
            hBufferField              = hBuffer:BUFFER-FIELD("page_label":u)
            hBufferField:BUFFER-VALUE = fiPageLabel:SCREEN-VALUE
            hBufferField              = hBuffer:BUFFER-FIELD("page_Sequence":u)
            hBufferField:BUFFER-VALUE = fiPageSeq:SCREEN-VALUE
            hBufferField              = hBuffer:BUFFER-FIELD("enable_on_create":u)
            hBufferField:BUFFER-VALUE = ToCreate
            hBufferField              = hBuffer:BUFFER-FIELD("enable_on_modify":u)
            hBufferField:BUFFER-VALUE = ToModify
            hBufferField              = hBuffer:BUFFER-FIELD("enable_on_view":u)
            hBufferField:BUFFER-VALUE = ToView
            hBufferField              = hBuffer:BUFFER-FIELD("security_token":u)
            hBufferField:BUFFER-VALUE = fiSecurityToken:SCREEN-VALUE.

        APPLY "value-changed":U TO coLayout IN FRAME {&FRAME-NAME}.
        RUN buildPageCombo.
        ghRycpaBrowse:REFRESH().
    END.
END CASE.

IF  pcAction <> 'update':u THEN
    ghRycpaQuery1:QUERY-OPEN().

ghRycpaQuery1:REPOSITION-TO-ROWID(hbuffer:ROWID) NO-ERROR.
APPLY "VALUE-CHANGED":U TO ghRycpaBrowse.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modRycsm vTableWin 
PROCEDURE modRycsm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcAction    AS CHARACTER    NO-UNDO.

/*
DEFINE VARIABLE hBuffer             AS HANDLE       NO-UNDO.
DEFINE VARIABLE hBufferField        AS HANDLE       NO-UNDO.
DEFINE VARIABLE hObjectInst         AS HANDLE       NO-UNDO.
DEFINE VARIABLE hObjectInstField    AS HANDLE       NO-UNDO.

RUN widgetStateRycsm(INPUT pcAction). /* enable/disable widgets associated with browse for pcAction */

hbuffer = ghTtSmartlink:DEFAULT-BUFFER-HANDLE. 

CASE pcAction:
    WHEN "add":u THEN DO:
        hbuffer:BUFFER-CREATE.  /* Create attribute value record */

        hBufferField = hBuffer:BUFFER-FIELD("container_smartobject_obj":u). /* handle to ttRycObjectInstance.container_smartobject_obj field */
        hBufferField:BUFFER-VALUE = gdContainer. /* Assign value */

        hBufferField = hBuffer:BUFFER-FIELD("rowmod":u). /* Assign rowmod */
        hBufferField:BUFFER-VALUE = "A":u.

    END.

    WHEN "delete":u THEN DO:
        /* Confirm deletion */
        /* ... */

        hBufferField = hBuffer:BUFFER-FIELD("rowmod":u).
        IF  hBuffer:BUFFER-VALUE = "A":u THEN
            /* If rowmod = "A", we have just added the record to the TT and we can delete it from the TT */
            hBuffer:BUFFER-DELETE().
        ELSE
            /* otherwise rowmod = "u" and the record must be deleted from the DB.  We, therefore, assign rowmod = "D" */
            hBufferField:BUFFER-VALUE = "D":u.
    END.
    WHEN "cancel":u THEN DO:
        /* cancel all changes made in this since last saved  */ 
        /* refetch records from Database */
        /* ... */
        /***DIAG***/
        MESSAGE {&line-number} PROGRAM-NAME(1) SKIP
            "cancel - still to code "
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END CASE.

ghRycsmQuery:QUERY-OPEN().
ghRycsmQuery:REPOSITION-TO-ROWID(hbuffer:ROWID).
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateLinkCombo vTableWin 
PROCEDURE populateLinkCombo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hObjectFilename     AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hLayoutPosition     AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hObjectInstanceObj  AS HANDLE       NO-UNDO.


    hObjectFilename    = ghRycoiQuery2Buffer:BUFFER-FIELD("object_filename").
    hLayoutPosition    = ghRycoiQuery2Buffer:BUFFER-FIELD("layout_position").
    hObjectInstanceObj = ghRycoiQuery2Buffer:BUFFER-FIELD("object_instance_obj").
    ghRycoiQuery2:QUERY-OPEN().

    ASSIGN
        gcLinkObjects = 'THIS-PROCEDURE' + coSourceLink:DELIMITER IN FRAME {&FRAME-NAME} + 
                        '0' + coSourceLink:DELIMITER IN FRAME {&FRAME-NAME}.

    REPEAT:
        ghRycoiQuery2:GET-NEXT().
        IF NOT ghRycoiQuery2Buffer:AVAILABLE THEN LEAVE.

        gcLinkObjects = gcLinkObjects + 
                        LC(hObjectFilename:BUFFER-VALUE) + "/" + LC(hLayoutPosition:BUFFER-VALUE) + 
                        coSourceLink:DELIMITER IN FRAME {&FRAME-NAME} + 
                        STRING(hObjectInstanceObj:BUFFER-VALUE) + coSourceLink:DELIMITER.
    END.

    ASSIGN
        coSourceLink:LIST-ITEM-PAIRS = TRIM(gcLinkObjects, CHR(3))
        coTargetLink:LIST-ITEM-PAIRS = TRIM(gcLinkObjects, CHR(3)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populatePageCombo vTableWin 
PROCEDURE populatePageCombo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hPage       AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hPageObj    AS HANDLE       NO-UNDO.

    ASSIGN
        coPage:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = '0' + coPage:DELIMITER + '0'
        coPage:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = coPage:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME}
        gcPage                                        = coPage:LIST-ITEM-PAIRS + coPage:DELIMITER
        hPage                                         = ghRycpaQuery2Buffer:BUFFER-FIELD("page_label").
        hPageObj                                      = ghRycpaQuery2Buffer:BUFFER-FIELD("page_obj").
        .

    ghRycpaQuery2:QUERY-OPEN().
    REPEAT:
        ghRycpaQuery2:GET-NEXT().
        IF NOT ghRycpaQuery2Buffer:AVAILABLE THEN LEAVE.

        gcPage = gcPage + 
                 hPage:BUFFER-VALUE            + coPage:DELIMITER IN FRAME {&FRAME-NAME} + 
                 STRING(hPageObj:BUFFER-VALUE) + coPage:DELIMITER.
    END.

    ASSIGN
        coPage:LIST-ITEM-PAIRS = TRIM(gcPage, CHR(3)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateRycavBrowse vTableWin 
PROCEDURE populateRycavBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hBufferField       AS HANDLE     NO-UNDO.

    IF VALID-HANDLE(ghRycavQuery1) AND ghRycavQuery1:IS-OPEN THEN
       ghRycavQuery1:QUERY-CLOSE() NO-ERROR.

    IF ghRycoiQuery1Buffer:AVAILABLE THEN
    DO:

        hBufferField = ghRycoiQuery1Buffer:BUFFER-FIELD("object_instance_obj").

        ASSIGN gcRycavQuery1 =
            "FOR EACH b1_ttAttributeValue ":u + 
               "WHERE b1_ttAttributeValue.rowMod <> 'D' ":u +
                 "AND b1_ttAttributeValue.rowMod <> '' ":u +
                 "AND b1_ttAttributeValue.object_instance_obj = ":u + 
                 IF hBufferField:BUFFER-VALUE = ? THEN "0":u 
                 ELSE hBufferField:BUFFER-VALUE.

        ghRycavQuery1:QUERY-PREPARE(gcRycavQuery1).    
        ghRycavQuery1:QUERY-OPEN().

    END.

    APPLY "value-changed":U TO ghRycavBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateRycoiBrowse vTableWin 
PROCEDURE populateRycoiBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(ghRycoiQuery1) AND ghRycoiQuery1:IS-OPEN THEN
        ghRycoiQuery1:QUERY-CLOSE().

    ghRycoiQuery1:QUERY-OPEN().

    APPLY "value-changed":U TO ghRycoiBrowse.

    IF NOT VALID-HANDLE(ghRycoiQuery2) THEN
       RUN buildLinkCombo.

    RUN populateLinkCombo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateRycpaBrowse vTableWin 
PROCEDURE populateRycpaBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(ghRycpaQuery1) AND ghRycpaQuery1:IS-OPEN THEN
        ghRycpaQuery1:QUERY-CLOSE().

    ghRycpaQuery1:QUERY-OPEN().

    APPLY "value-changed":U TO ghRycpaBrowse.

    IF NOT VALID-HANDLE(ghRycpaQuery2) THEN
       RUN buildPageCombo.

    RUN populatePageCombo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateRycsmBrowse vTableWin 
PROCEDURE populateRycsmBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(ghRycsmQuery1) AND ghRycsmQuery1:IS-OPEN THEN
        ghRycsmQuery1:QUERY-CLOSE().

    ghRycsmQuery1:QUERY-OPEN().

    APPLY "value-changed":u TO ghRycsmBrowse.

    APPLY "row-display":u   TO ghRycsmBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetBrowseColumns vTableWin 
PROCEDURE resetBrowseColumns :
/*------------------------------------------------------------------------------
  Purpose:      After resizing the frame, the browse columns are reset to their
                original percentages of the browse width.  This is done to 
                prevent errors when the frame is resized to be smaller, and the
                widgets do not fit on the frame.
  Parameters:   pdBrowseWidth - width of browse in pixels
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pdBrowseWidth   AS DECIMAL      NO-UNDO.

ASSIGN
    pdBrowseWidth = pdBrowseWidth - 18.
/* width = 10% of browse width */
ghAttributeGroup:WIDTH-PIXELS = pdBrowseWidth * 15 / 100.

/* width = 10% of browse width */
ghAttribute:WIDTH-PIXELS = pdBrowseWidth * 15 / 100.

/* width = 62% of browse width */
ghAttributeValue:WIDTH-PIXELS = pdBrowseWidth * 52 / 100.

/* width = 9% of browse-width */
ghConstantValue:WIDTH-PIXELS = pdBrowseWidth * 9 / 100.

/* width = 9% of browse-width */
ghInheritedValue:WIDTH-PIXELS = pdBrowseWidth * 9 / 100.

APPLY "end-resize":u TO ghRycoiBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeAttributeBrowse vTableWin 
PROCEDURE resizeAttributeBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN
    /* don't allow toggle columns to be > 15 and other columns to be smaller than 15   */
    ghAttributeGroup:WIDTH                        = MAX(15, ghAttributeGroup:WIDTH)
    ghAttribute:WIDTH                             = MAX(15, ghAttribute:WIDTH)     
    ghAttributeValue:WIDTH                        = MAX(15, ghAttributeValue:WIDTH)
    ghConstantValue:WIDTH                         = MIN(15, ghConstantValue:WIDTH) 
    ghInheritedValue:WIDTH                        = MIN(15, ghInheritedValue:WIDTH)
    /* make viewer fields = width and column position of browse columns */
    /* however, column position cannot be < 1 */
    coAttributeGroup:COL   IN FRAME {&FRAME-NAME} = MAX(1, buRycoiAdd:COL)
    coAttributeGroup:WIDTH IN FRAME {&FRAME-NAME} = ghAttributeGroup:WIDTH
    coAttribute:COL        IN FRAME {&FRAME-NAME} = MAX(1, ghAttribute:COL)         + buRycoiAdd:COL
    coAttribute:WIDTH      IN FRAME {&FRAME-NAME} = ghAttribute:WIDTH
    fiAttributeValue:COL   IN FRAME {&FRAME-NAME} = MAX(1, ghAttributeValue:COL)    + buRycoiAdd:COL
    fiAttributeValue:WIDTH IN FRAME {&FRAME-NAME} = ghAttributeValue:WIDTH
    toConstant:COL         IN FRAME {&FRAME-NAME} = MAX(1, ghConstantValue:COL)     + buRycoiAdd:COL
    ghConstantValue:WIDTH                         = MIN(15, ghConstantValue:WIDTH)
    toInherited:COL        IN FRAME {&FRAME-NAME} = MAX(1, ghInheritedValue:COL)    + buRycoiAdd:COL
    ghInheritedValue:WIDTH                        = MIN(15, ghInheritedValue:WIDTH).

RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pdHeight    AS DECIMAL      NO-UNDO.
    DEFINE INPUT  PARAMETER pdWidth     AS DECIMAL      NO-UNDO.

    FRAME {&FRAME-NAME}:HEIGHT-PIXELS             = {&WINDOW-NAME}:HEIGHT-PIXELS - 75 NO-ERROR.
    FRAME {&FRAME-NAME}:WIDTH-PIXELS              = {&WINDOW-NAME}:WIDTH-PIXELS - 30 NO-ERROR.

    ASSIGN
        ToConstant:Y       IN FRAME {&FRAME-NAME} = FRAME {&FRAME-NAME}:HEIGHT-PIXELS - fiAttributeValue:HEIGHT-PIXELS - 5
        ToInherited:Y      IN FRAME {&FRAME-NAME} = ToConstant:Y
        fiAttributeValue:Y IN FRAME {&FRAME-NAME} = ToConstant:Y - fiAttributeValue:HEIGHT-PIXELS - 0.5
        coAttributeGroup:Y IN FRAME {&FRAME-NAME} = fiAttributeValue:Y
        coAttribute:Y      IN FRAME {&FRAME-NAME} = fiAttributeValue:Y.

    IF VALID-HANDLE(ghRycoiBrowse) THEN DO:
        ghRycoiBrowse:HEIGHT-PIXELS = (FRAME {&FRAME-NAME}:HEIGHT-PIXELS * 40 / 100) - 50 . /* 40% of frame height  - space for fill-ins */ 
        ghRycoiBrowse:WIDTH-PIXELS  = FRAME {&FRAME-NAME}:WIDTH-PIXELS  * 60 / 100. /* 60% of frame width */ 
        ghProductCode:WIDTH-PIXELS = ghRycoiBrowse:WIDTH-PIXELS * 10 / 100.
        ghProductModuleCode:WIDTH-PIXELS = ghRycoiBrowse:WIDTH-PIXELS * 10 / 100.
        ghObjectFilename:WIDTH-PIXELS = ghRycoiBrowse:WIDTH-PIXELS * 30 / 100.
        ghLayoutPosition:WIDTH-PIXELS = ghRycoiBrowse:WIDTH-PIXELS * 10 / 100.
        /* This proc expects the row and col position in chars, not pixels */
        RUN repositionObject IN h_dynlookup (ghRycoiBrowse:ROW + ghRycoiBrowse:HEIGHT-CHARS + 0.4, 19) NO-ERROR.
        RUN initializelookup IN h_dynlookup. /* repositions label */

        ASSIGN
            ghPageLabel:WIDTH-PIXELS = ghRycoiBrowse:WIDTH-PIXELS * 15 / 100
            fiLayoutPosition:Y       = ghRycoiBrowse:Y + ghRycoiBrowse:HEIGHT-PIXELS + 10 + 22 /* underneath object lookup */
            coPage:Y                 = ghRycoiBrowse:Y + ghRycoiBrowse:HEIGHT-PIXELS + 10
            buRycavAdd:Y             = fiLayoutPosition:Y + 35
            buRycavAdd:X             = buRycoiAdd:X /* X pos of rycoi add button */
            buRycavUpdate:Y          = buRycavAdd:Y
            buRycavUpdate:X          = buRycavAdd:X + buRycavAdd:WIDTH-PIXELS
            buRycavDelete:Y          = buRycavAdd:Y
            buRycavDelete:X          = buRycavUpdate:X + buRycavUpdate:WIDTH-PIXELS
            buRycavSave:Y            = buRycavAdd:Y
            buRycavSave:X            = buRycavDelete:X + buRycavDelete:WIDTH-PIXELS + 10
            buRycavCancel:Y          = buRycavAdd:Y
            buRycavCancel:X          = buRycavSave:X + buRycavSave:WIDTH-PIXELS.
    END.

    IF VALID-HANDLE(ghRycavBrowse) THEN
        ASSIGN
            ghRycavBrowse:Y             = buRycavAdd:Y + buRycavAdd:HEIGHT-PIXELS + 5  /* line up with add button */ 
            ghRycavBrowse:X             = buRycavAdd:X
            ghRycavBrowse:HEIGHT-PIXELS = fiAttributeValue:Y - (buRycavAdd:Y + buRycavAdd:HEIGHT-PIXELS + 10)
            ghRycavBrowse:WIDTH-PIXELS  = FRAME {&FRAME-NAME}:WIDTH-PIXELS  * 60 / 100. /* 60% of frame width */ 

    IF  VALID-HANDLE(ghRycsmBrowse) THEN
        ASSIGN
            ghRycsmBrowse:Y             = ghRycavBrowse:Y
            ghRycsmBrowse:X             = ghRycavBrowse:X + ghRycavBrowse:WIDTH-PIXELS + 10
            ghRycsmBrowse:HEIGHT-PIXELS = fiAttributeValue:Y - (buRycavAdd:Y + buRycavAdd:HEIGHT-PIXELS + 10)
            ghRycsmBrowse:WIDTH-PIXELS  = ({&WINDOW-NAME}:WIDTH-PIXELS - 30) - ghRycsmBrowse:X
            buRycsmAdd:X                = ghRycsmBrowse:X
            buRycsmAdd:Y                = buRycavAdd:Y
            buRycsmUpdate:X             = buRycsmAdd:X + buRycsmAdd:WIDTH-PIXELS
            buRycsmUpdate:Y             = buRycsmAdd:Y
            buRycsmDelete:X             = buRycsmUpdate:X + buRycsmUpdate:WIDTH-PIXELS
            buRycsmDelete:Y             = buRycsmAdd:Y
            buRycsmSave:X               = buRycsmDelete:X + buRycsmDelete:WIDTH-PIXELS + 10
            buRycsmSave:Y               = buRycsmAdd:Y
            buRycsmCancel:X             = buRycsmSave:X + buRycsmSave:WIDTH-PIXELS
            buRycsmCancel:Y             = buRycsmAdd:Y
            ghSource:WIDTH-PIXELS       = ghRycsmBrowse:WIDTH-PIXELS * 33 / 100
            ghLinkName:WIDTH-PIXELS     = ghRycsmBrowse:WIDTH-PIXELS * 33 / 100
            ghTarget:WIDTH-PIXELS       = ghRycsmBrowse:WIDTH-PIXELS * 33 / 100
            coSourceLink:X              = ghRycsmBrowse:X
            coSourceLink:Y              = fiAttributeValue:Y
            coSourceLink:WIDTH-PIXELS   = ghSource:WIDTH-PIXELS
            coLink:X                    = ghRycsmBrowse:X + ghSource:WIDTH-PIXELS
            coLink:Y                    = coSourceLink:Y
            coLink:WIDTH-PIXELS         = ghLinkName:WIDTH-PIXELS
            coTargetLink:X              = ghRycsmBrowse:X + ghSource:WIDTH-PIXELS + ghLinkName:WIDTH-PIXELS
            coTargetLink:Y              = coSourceLink:Y
            coTargetLink:WIDTH-PIXELS   = ghTarget:WIDTH-PIXELS.

    IF VALID-HANDLE(ghRycpaBrowse) THEN
        ASSIGN
            fiPageSeq:Y                 = coPage:Y
            coLayout:Y                  = fiPageSeq:Y - fiPageLabel:HEIGHT-PIXELS - 0.5
            fiPageLabel:Y               = coLayout:Y - fiPageLabel:HEIGHT-PIXELS - 0.5
            fiSecurityToken:Y           = fiPageSeq:Y.

            ToCreate:Y                  = fiPageLabel:Y.
            ToModify:Y                  = ToCreate:Y + 14.
            ToView:Y                    = ToModify:Y + 14.

    IF VALID-HANDLE(ghRycpaBrowse) THEN
        ASSIGN
            ghRycpaBrowse:Y             = ghRycoiBrowse:Y
            ghRycpaBrowse:X             = ghRycoiBrowse:X + ghRycoiBrowse:WIDTH-PIXELS + 10
            ghRycpaBrowse:HEIGHT-PIXELS = fiPageLabel:Y - ghRycPaBrowse:Y - 5
            ghRycpaBrowse:WIDTH-PIXELS  = ({&WINDOW-NAME}:WIDTH-PIXELS - 30) - ghRycpaBrowse:X
            buRycpaAdd:X                = ghRycpaBrowse:X
            buRycpaAdd:Y                = buRycoiAdd:Y
            buRycpaUpdate:X             = buRycpaAdd:X + buRycpaAdd:WIDTH-PIXELS
            buRycpaUpdate:Y             = buRycpaAdd:Y
            buRycpaDelete:X             = buRycpaUpdate:X + buRycpaUpdate:WIDTH-PIXELS
            buRycpaDelete:Y             = buRycpaAdd:Y
            buRycpaSave:X               = buRycpaDelete:X + buRycpaDelete:WIDTH-PIXELS + 10
            buRycpaSave:Y               = buRycpaAdd:Y
            buRycpaCancel:X             = buRycpaSave:X + buRycpaSave:WIDTH-PIXELS
            buRycpaCancel:Y             = buRycpaAdd:Y.

      /* Frame height and width is re-assigned here because previos assign may have caused an error */
      /* depending on whether you are making the frame bigger or smaller.  The assign must be done in both */
      /* places. */
      FRAME {&FRAME-NAME}:HEIGHT-PIXELS             = {&WINDOW-NAME}:HEIGHT-PIXELS - 75 NO-ERROR.
      FRAME {&FRAME-NAME}:WIDTH-PIXELS              = {&WINDOW-NAME}:WIDTH-PIXELS - 30 NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowDisplayRycsm vTableWin 
PROCEDURE rowDisplayRycsm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hBufferField    AS HANDLE       NO-UNDO.


    IF ghRycsmQuery1Buffer:AVAILABLE THEN 
    DO:
        ASSIGN
        hBufferField          = ghRycsmQuery1Buffer:BUFFER-FIELD("source_object_instance_obj").
        ghSource:SCREEN-VALUE = IF LOOKUP(hBufferField:BUFFER-VALUE, gcLinkObjects, coSourceLink:DELIMITER IN FRAME {&FRAME-NAME}) > 0 THEN 
                                ENTRY(LOOKUP(hBufferField:BUFFER-VALUE, gcLinkObjects, coSourceLink:DELIMITER IN FRAME {&FRAME-NAME}) - 1, 
                                      gcLinkObjects, coSourceLink:DELIMITER IN FRAME {&FRAME-NAME}) 
                                ELSE 'No Object':u NO-ERROR.
        hBufferField          = ghRycsmQuery1Buffer:BUFFER-FIELD("target_object_instance_obj").
        ghTarget:SCREEN-VALUE = IF LOOKUP(hBufferField:BUFFER-VALUE, gcLinkObjects, coTargetLink:DELIMITER IN FRAME {&FRAME-NAME}) > 0 THEN 
                                ENTRY(LOOKUP(hBufferField:BUFFER-VALUE, gcLinkObjects, coTargetLink:DELIMITER IN FRAME {&FRAME-NAME}) - 1, 
                                      gcLinkObjects, coTargetLink:DELIMITER IN FRAME {&FRAME-NAME}) 
                                ELSE 'No Object':u NO-ERROR.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFilterComboValue vTableWin 
PROCEDURE setFilterComboValue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcKeyValue  AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER plSuccess   AS LOGICAL      NO-UNDO.

DEFINE VARIABLE iLoop   AS INTEGER      NO-UNDO.

plSuccess = NO.

valueLoop:
DO iLoop = 1 TO NUM-ENTRIES(gcDataString, coAttribute:DELIMITER IN FRAME {&FRAME-NAME}) BY 2:
    IF DECIMAL(pcKeyValue) = DECIMAL(ENTRY(iLoop + 1, gcDataString, coAttribute:DELIMITER)) THEN DO:
        ASSIGN
            coAttributeGroup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(2, ENTRY(iLoop, gcDataString, coAttribute:DELIMITER), "|":U)
            plSuccess = TRUE.

        APPLY "value-changed":u TO coAttributeGroup.

        LEAVE valueLoop.
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRycoiWidgetState vTableWin 
PROCEDURE setRycoiWidgetState :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE VARIABLE lFieldsEnabled           AS LOGICAL         NO-UNDO.

   lFieldsEnabled = DYNAMIC-FUNCTION("getFieldsEnabled":U).

   DO WITH FRAME {&FRAME-NAME}:
       ASSIGN
           buRycoiAdd:SENSITIVE            = lFieldsEnabled                                   AND gcRycoiUpdateState EQ "":U
           buRycoiDelete:SENSITIVE         = lFieldsEnabled AND ghRycoiQuery1Buffer:AVAILABLE AND gcRycoiUpdateState EQ "":U
           buRycoiUpdate:SENSITIVE         = lFieldsEnabled AND ghRycoiQuery1Buffer:AVAILABLE AND gcRycoiUpdateState EQ "":U
           buRycoiCancel:SENSITIVE         = lFieldsEnabled AND ghRycoiQuery1Buffer:AVAILABLE AND gcRycoiUpdateState NE "":U
           buRycoiSave:SENSITIVE           = lFieldsEnabled AND ghRycoiQuery1Buffer:AVAILABLE AND gcRycoiUpdateState NE "":U

           fiLayoutPosition:SENSITIVE      = lFieldsEnabled AND ghRycoiQuery1Buffer:AVAILABLE AND gcRycoiUpdateState NE "":U
           coPage:SENSITIVE                = lFieldsEnabled AND ghRycoiQuery1Buffer:AVAILABLE AND gcRycoiUpdateState NE "":U
           .   
   END.
   IF VALID-HANDLE(h_dynlookup) THEN
   DO:
       IF lFieldsEnabled AND ghRycoiQuery1Buffer:AVAILABLE AND gcRycoiUpdateState EQ "":U THEN
       DO:
           RUN disableField  IN h_dynlookup.
           RUN disableButton IN h_dynlookup.
       END.
       ELSE
       DO:
           RUN enableField  IN h_dynlookup.
           RUN enableButton IN h_dynlookup.
       END.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChangedRycav vTableWin 
PROCEDURE valueChangedRycav :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hBufferField    AS HANDLE       NO-UNDO.


    IF  ghRycavQuery1Buffer:AVAILABLE THEN 
    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN
            hBufferField                  = ghRycavQuery1Buffer:BUFFER-FIELD("attribute_group_obj":u)
            coAttributeGroup:SCREEN-VALUE = STRING(hBufferField:BUFFER-VALUE).

        APPLY "value-changed":U TO coAttributeGroup.

        ASSIGN
            hBufferField                  = ghRycavQuery1Buffer:BUFFER-FIELD("attribute_label":u)
            coAttribute:SCREEN-VALUE      = hBufferField:BUFFER-VALUE
            hBufferField                  = ghRycavQuery1Buffer:BUFFER-FIELD("attribute_value":u)
            fiAttributeValue:SCREEN-VALUE = hBufferField:BUFFER-VALUE
            hBufferField                  = ghRycavQuery1Buffer:BUFFER-FIELD("constant_value":u)
            ToConstant:SCREEN-VALUE       = STRING(hBufferField:BUFFER-VALUE)
            hBufferField                  = ghRycavQuery1Buffer:BUFFER-FIELD("inheritted_value":u)
            ToInherited:SCREEN-VALUE      = STRING(hBufferField:BUFFER-VALUE)
            .
    END.
    ELSE
    DO WITH FRAME {&FRAME-NAME}:
       ASSIGN
           fiAttributeValue:SCREEN-VALUE       = ""
           ToConstant:CHECKED                  = NO
           ToInherited:CHECKED                 = NO
           .

    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChangedRycoi vTableWin 
PROCEDURE valueChangedRycoi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hBufferField    AS HANDLE       NO-UNDO.    


    IF ghRycoiQuery1Buffer:AVAILABLE THEN 
    DO WITH FRAME {&FRAME-NAME}:

        hBufferField                   = ghRycoiQuery1Buffer:BUFFER-FIELD("smartobject_obj":U).
        DYNAMIC-FUNCTION("setDataValue":u IN h_dynlookup, INPUT STRING(hBufferField:BUFFER-VALUE)).    

        IF NOT VALID-HANDLE(ghLookupField) THEN
           ghLookupField = DYNAMIC-FUNCTION("getLookupHandle":u IN h_dynlookup).    

        hBufferField                   = ghRycoiQuery1Buffer:BUFFER-FIELD("object_filename":U).
        ghLookupField:SCREEN-VALUE = hBufferField:BUFFER-VALUE.

        ASSIGN
            hBufferField                    = ghRycoiQuery1Buffer:BUFFER-FIELD("page_obj")
            coPage:SCREEN-VALUE             = STRING(hBufferField:BUFFER-VALUE)
            hBufferField                    = ghRycoiQuery1Buffer:BUFFER-FIELD("layout_position")
            fiLayoutPosition:SCREEN-VALUE   = STRING(hBufferField:BUFFER-VALUE).       

    END.
    ELSE
    DO WITH FRAME {&FRAME-NAME}:

        DYNAMIC-FUNCTION("setDataValue":u IN h_dynlookup, INPUT "":U).    

        ASSIGN
            fiLayoutPosition:SCREEN-VALUE  = "":U.       

    END.

    IF NOT VALID-HANDLE(ghRycavBrowse) THEN
       RUN buildRycavBrowse.

    RUN populateRycavBrowse.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChangedRycpa vTableWin 
PROCEDURE valueChangedRycpa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hBufferField    AS HANDLE       NO-UNDO.


    IF ghRycpaQuery1Buffer:AVAILABLE THEN 
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            hBufferField                  = ghRycpaQuery1Buffer:BUFFER-FIELD("page_sequence")
            fiPageSeq:SCREEN-VALUE        = STRING(hBufferField:BUFFER-VALUE)
            hBufferField                  = ghRycpaQuery1Buffer:BUFFER-FIELD("page_label")
            fiPageLabel:SCREEN-VALUE      = STRING(hBufferField:BUFFER-VALUE)
            hBufferField                  = ghRycpaQuery1Buffer:BUFFER-FIELD("security_token")
            fiSecurityToken:SCREEN-VALUE  = STRING(hBufferField:BUFFER-VALUE)
            hBufferField                  = ghRycpaQuery1Buffer:BUFFER-FIELD("enable_on_create")
            toCreate:SCREEN-VALUE         = STRING(hBufferField:BUFFER-VALUE)
            hBufferField                  = ghRycpaQuery1Buffer:BUFFER-FIELD("enable_on_modify")
            toModify:SCREEN-VALUE         = STRING(hBufferField:BUFFER-VALUE)
            hBufferField                  = ghRycpaQuery1Buffer:BUFFER-FIELD("enable_on_view")
            toView:SCREEN-VALUE           = STRING(hBufferField:BUFFER-VALUE)
            .
    END.
    ELSE
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            fiPageSeq:SCREEN-VALUE        = "":U
            fiPageLabel:SCREEN-VALUE      = "":U
            fiSecurityToken:SCREEN-VALUE  = "":U
            toCreate:CHECKED              = NO
            toModify:CHECKED              = NO
            toView:CHECKED                = NO
            .
    END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChangedRycsm vTableWin 
PROCEDURE valueChangedRycsm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hBufferField    AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hLinkObj        AS DECIMAL      NO-UNDO.


    IF ghRycsmQuery1Buffer:AVAILABLE THEN 
    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN
            hBufferField              = ghRycsmQuery1Buffer:BUFFER-FIELD("source_object_instance_obj")
            ghSourceObj               = hBufferfield:BUFFER-VALUE
            hBufferField              = ghRycsmQuery1Buffer:BUFFER-FIELD("target_object_instance_obj")
            ghTargetObj               = hBufferfield:BUFFER-VALUE
            hBufferField              = ghRycsmQuery1Buffer:BUFFER-FIELD("smartlink_type_obj")
            hLinkObj                  = hBufferField:BUFFER-VALUE
            coSourceLink:SCREEN-VALUE = STRING(ghSourceObj)
            coTargetLink:SCREEN-VALUE = STRING(ghTargetObj)
            coLink:SCREEN-VALUE       = STRING(hLinkObj)
            .
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE widgetStateRycav vTableWin 
PROCEDURE widgetStateRycav :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcAction    AS CHARACTER    NO-UNDO.

CASE pcAction:
    WHEN "add":u OR WHEN "update":u THEN DO:
        ENABLE
            {&RycavSaveButtons}
            {&RycavFields}
        WITH FRAME {&FRAME-NAME}.

        DISABLE 
            {&RycpaUpdateButtons}   {&RycpaSaveButtons}
            {&RycpaFields}
            {&RycsmUpdateButtons}   {&RycsmSaveButtons}
            {&RycsmFields}
            {&RycoiUpdateButtons}   {&RycoiSaveButtons}
            {&RycoiFields}
            {&RycavUpdateButtons}
        WITH FRAME {&FRAME-NAME}.
    END.

    WHEN "save":u OR WHEN "cancel":u THEN DO:
        DISABLE
            {&RycavSaveButtons}
            {&RycavFields}
        WITH FRAME {&FRAME-NAME}.

        ENABLE
            {&RycoiUpdateButtons}   {&RycoiSaveButtons}
            {&RycavUpdateButtons}   {&RycavSaveButtons}
            {&RycsmUpdateButtons}   {&RycsmSaveButtons}
            {&RycpaUpdateButtons}   {&RycpaSaveButtons}
        WITH FRAME {&FRAME-NAME}.
    END.
END CASE.
END PROCEDURE.
/*
RycpaUpdateButtons 
RycpaSaveButtons
RycpaFields 
RycoiUpdateButtons 
RycoiSaveButtons 
RycoiFields  
RycavUpdateButtons 
RycavSaveButtons 
&RycavFields 
RycsmUpdateButtons 
RycsmSaveButtons 
RycsmFields  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE widgetStateRycoi vTableWin 
PROCEDURE widgetStateRycoi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcAction    AS CHARACTER    NO-UNDO.

CASE pcAction:
    WHEN "add":u OR WHEN "update":u THEN DO:
        ENABLE
            {&RycoiSaveButtons}
            {&RycoiFields}
        WITH FRAME {&FRAME-NAME}.

        DISABLE 
            {&RycpaUpdateButtons}   {&RycpaSaveButtons}
            {&RycpaFields}
            {&RycavUpdateButtons}   {&RycavSaveButtons}
            {&RycavFields}
            {&RycsmUpdateButtons}   {&RycsmSaveButtons}
            {&RycsmFields}
            {&RycoiUpdateButtons}
        WITH FRAME {&FRAME-NAME}.
        ASSIGN
            ghRycoiBrowse:SENSITIVE = FALSE.
    END.

    WHEN "save":u OR WHEN "cancel":u THEN DO:
        DISABLE
            {&RycoiSaveButtons}
            {&RycoiFields}
        WITH FRAME {&FRAME-NAME}.

        ENABLE
            {&RycoiUpdateButtons}   {&RycoiSaveButtons}
            {&RycavUpdateButtons}   {&RycavSaveButtons}
            {&RycsmUpdateButtons}   {&RycsmSaveButtons}
            {&RycpaUpdateButtons}   {&RycpaSaveButtons}
        WITH FRAME {&FRAME-NAME}.
        ASSIGN
            ghRycoiBrowse:SENSITIVE = TRUE.
    END.
END CASE.
END PROCEDURE.
/*
RycpaUpdateButtons 
RycpaSaveButtons
RycpaFields 
RycoiUpdateButtons 
RycoiSaveButtons 
RycoiFields  
RycavUpdateButtons 
RycavSaveButtons 
&RycavFields 
RycsmUpdateButtons 
RycsmSaveButtons 
RycsmFields  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE widgetStateRycpa vTableWin 
PROCEDURE widgetStateRycpa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcAction    AS CHARACTER    NO-UNDO.

CASE pcAction:
    WHEN "add":u OR WHEN "update":u THEN DO:
        ENABLE
            {&RycpaSaveButtons}
            {&RycpaFields}
        WITH FRAME {&FRAME-NAME}.

        DISABLE 
            {&RycoiUpdateButtons}   {&RycoiSaveButtons}
            {&RycoiFields}          
            {&RycavUpdateButtons}   {&RycavSaveButtons}
            {&RycavFields}
            {&RycsmUpdateButtons}   {&RycsmSaveButtons}
            {&RycsmFields}
            {&RycpaUpdateButtons}
        WITH FRAME {&FRAME-NAME}.
        ASSIGN
            ghRycpaBrowse:SENSITIVE = FALSE.
    END.

    WHEN "save":u OR WHEN "cancel":u THEN DO:
        DISABLE
            {&RycpaSaveButtons}
            {&RycpaFields}
        WITH FRAME {&FRAME-NAME}.

        ENABLE
            {&RycoiUpdateButtons}   {&RycoiSaveButtons}
            {&RycavUpdateButtons}   {&RycavSaveButtons}
            {&RycsmUpdateButtons}   {&RycsmSaveButtons}
            {&RycpaUpdateButtons}   {&RycpaSaveButtons}
        WITH FRAME {&FRAME-NAME}.
        ASSIGN
            ghRycpaBrowse:SENSITIVE = TRUE.
    END.
END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE widgetStateRycsm vTableWin 
PROCEDURE widgetStateRycsm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcAction    AS CHARACTER    NO-UNDO.

CASE pcAction:
    WHEN "add":u OR WHEN "update":u THEN DO:
        ENABLE
            {&RycsmSaveButtons}
            {&RycsmFields}
        WITH FRAME {&FRAME-NAME}.
        ASSIGN
            coLayout:SCREEN-VALUE = "0":u
            fiPageLabel:SCREEN-VALUE = "":u
            fiPageSeq:SCREEN-VALUE = "0":u
            fiSecurityToken:SCREEN-VALUE = "":u
            ToCreate:SCREEN-VALUE = STRING(TRUE)
            ToModify:SCREEN-VALUE = STRING(TRUE)
            ToView:SCREEN-VALUE = STRING(TRUE).

        DISABLE 
            {&RycoiUpdateButtons}   {&RycoiSaveButtons}
            {&RycoiFields}          
            {&RycavUpdateButtons}   {&RycavSaveButtons}
            {&RycavFields}
            {&RycpaUpdateButtons}   {&RycpaSaveButtons}
            {&RycpaFields}
            {&RycsmUpdateButtons}   
        WITH FRAME {&FRAME-NAME}.
    END.

    WHEN "save":u OR WHEN "cancel":u THEN DO:
        DISABLE
            {&RycsmSaveButtons}
            {&RycsmFields}
        WITH FRAME {&FRAME-NAME}.

        ENABLE
            {&RycoiUpdateButtons}   {&RycoiSaveButtons}
            {&RycavUpdateButtons}   {&RycavSaveButtons}
            {&RycsmUpdateButtons}   {&RycsmSaveButtons}
            {&RycpaUpdateButtons}   {&RycpaSaveButtons}
        WITH FRAME {&FRAME-NAME}.
    END.
END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

