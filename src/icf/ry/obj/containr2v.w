&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*------------------------------------------------------------------------

  File:

  Description: from SMART.W - Template for basic ADM2 SmartObject

  Author:
  Created:

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

/* Local Variable Definitions ---                                       */
{ af/sup2/afglobals.i }
{ ry/app/containeri.i }

DEFINE VARIABLE ghContainerSource           AS HANDLE               NO-UNDO.
DEFINE VARIABLE ghSBO                       AS HANDLE               NO-UNDO.
DEFINE VARIABLE gcContainerObjectTypeCode   AS CHARACTER            NO-UNDO.
DEFINE VARIABLE gcAttributeValues           AS CHARACTER            NO-UNDO.
DEFINE VARIABLE gcAttributeLabels           AS CHARACTER            NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buLookupObject edForeignFields ~
fiLayoutPosition fiLaunchContainer coNavigationTargetName ~
fiWindowTitleField 
&Scoped-Define DISPLAYED-OBJECTS fiObjectName fiTemplateObjectName ~
fiObjectType edForeignFields fiLayoutPosition fiLaunchContainer ~
coNavigationTargetName fiWindowTitleField 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buApply 
     LABEL "Appl&y" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buLookupObject 
     IMAGE-UP FILE "ry/img/affind.gif":U
     LABEL "" 
     SIZE 4.8 BY 1 TOOLTIP "Lookup the container to use"
     BGCOLOR 8 .

DEFINE BUTTON buProp 
     LABEL "&Properties" 
     SIZE 15 BY 1.14 TOOLTIP "Properties for instance"
     BGCOLOR 8 .

DEFINE VARIABLE coNavigationTargetName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Navigation Target" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE edForeignFields AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 42.4 BY 1.95 NO-UNDO.

DEFINE VARIABLE fiLaunchContainer AS CHARACTER FORMAT "X(70)":U 
     LABEL "Launch Container" 
     VIEW-AS FILL-IN 
     SIZE 37.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiLayoutPosition AS CHARACTER FORMAT "X(70)":U 
     LABEL "Layout Position" 
     VIEW-AS FILL-IN 
     SIZE 37.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectName AS CHARACTER FORMAT "X(70)":U 
     LABEL "Object Name" 
     VIEW-AS FILL-IN 
     SIZE 37.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectType AS CHARACTER FORMAT "X(15)":U 
     LABEL "Object Type Code" 
     VIEW-AS FILL-IN 
     SIZE 37.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiTemplateObjectName AS CHARACTER FORMAT "X(70)":U 
     LABEL "Template Object Name" 
     VIEW-AS FILL-IN 
     SIZE 37.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiWindowTitleField AS CHARACTER FORMAT "X(70)":U 
     LABEL "Window Title Field" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fiObjectName AT ROW 1.1 COL 23 COLON-ALIGNED
     buLookupObject AT ROW 1.1 COL 62.2
     fiTemplateObjectName AT ROW 1.1 COL 105 COLON-ALIGNED
     fiObjectType AT ROW 2.05 COL 88.6
     edForeignFields AT ROW 2.14 COL 25 NO-LABEL
     fiLayoutPosition AT ROW 3.05 COL 105 COLON-ALIGNED
     fiLaunchContainer AT ROW 4.14 COL 105 COLON-ALIGNED
     coNavigationTargetName AT ROW 4.24 COL 23 COLON-ALIGNED
     fiWindowTitleField AT ROW 5.19 COL 23 COLON-ALIGNED
     buProp AT ROW 5.29 COL 114.6
     buApply AT ROW 5.29 COL 129.6
     "Foreign Fields:" VIEW-AS TEXT
          SIZE 14.4 BY .62 AT ROW 2.14 COL 10.6
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
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 5.43
         WIDTH              = 143.6.
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

/* SETTINGS FOR BUTTON buApply IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buProp IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       edForeignFields:RETURN-INSERTED IN FRAME F-Main  = TRUE.

/* SETTINGS FOR FILL-IN fiObjectName IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiObjectType IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fiTemplateObjectName IN FRAME F-Main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME buApply
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buApply sObject
ON CHOOSE OF buApply IN FRAME F-Main /* Apply */
DO:
DO ON ERROR UNDO, RETURN NO-APPLY:
    RUN applyChanges.
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLookupObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLookupObject sObject
ON CHOOSE OF buLookupObject IN FRAME F-Main
DO:
    DEFINE VARIABLE cObjectFilename         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cObjectTypeCode         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cObjectTypeWhere        AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE dObjectTypeObj          AS DECIMAL                  NO-UNDO.

    IF fiObjectType:SCREEN-VALUE NE "":U THEN
    DO:
        ASSIGN cObjectTypeWhere = " gsc_object_type.object_type_code = '":U +  fiObjectType:INPUT-VALUE + "' ":U.
        CASE fiObjectType:SCREEN-VALUE:
            WHEN "SDO":U THEN ASSIGN cObjectTypeWhere = cObjectTypeWhere + " OR gsc_object_type.object_type_code = 'SBO':U ":U.
            WHEN "SBO":U THEN ASSIGN cObjectTypeWhere = cObjectTypeWhere + " OR gsc_object_type.object_type_code = 'SDO':U ":U.
            WHEN "DynView":U THEN ASSIGN cObjectTypeWhere = cObjectTypeWhere + " OR gsc_object_type.object_type_code = 'StaticSDV':U ":U.
            WHEN "StaticSDV":U THEN ASSIGN cObjectTypeWhere = cObjectTypeWhere + " OR gsc_object_type.object_type_code = 'DynView':U ":U.
        END CASE.   /* object type */
    END.    /* object type not blank */
    ELSE
        ASSIGN cObjectTypeWhere = "":U.

    RUN ry/uib/containrbd.w ( INPUT        NO,                /* template object? */
                              INPUT        cObjectTypeWhere,  /* object type where clause */
                              INPUT        NO,                /* container object? */
                              INPUT-OUTPUT dObjectTypeObj,
                              INPUT-OUTPUT cObjectFilename,
                                    OUTPUT cObjectTypeCode) NO-ERROR.
    IF cObjectFilename NE "":U THEN
        ASSIGN fiObjectName:SCREEN-VALUE = cObjectFilename
               fiObjectType:SCREEN-VALUE = cObjectTypeCode
               .
    
    /* Get the launch container for the DynBrow */
    IF fiObjectType:INPUT-VALUE EQ "DynBrow":U THEN
    DO:
        RUN getAttributeValue ( INPUT cObjectFilename,
                                INPUT "FolderWindowToLaunch":U,
                                OUTPUT fiLaunchContainer).
        ASSIGN fiLaunchContainer:SCREEN-VALUE = fiLaunchContainer.
    END.    /* Browse */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buProp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buProp sObject
ON CHOOSE OF buProp IN FRAME F-Main /* Properties */
DO:
    RUN setProperties.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectType sObject
ON VALUE-CHANGED OF fiObjectType IN FRAME F-Main /* Object Type Code */
DO:
DO ON ERROR UNDO, RETURN NO-APPLY:
    RUN ChangeObjectType ( INPUT SELF:SCREEN-VALUE ).
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ApplyChanges sObject 
PROCEDURE ApplyChanges :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST ttPageInstance NO-ERROR.

    IF AVAILABLE ttPageInstance THEN
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN ttPageInstance.tObjectFileName         = fiObjectName:SCREEN-VALUE
               ttPageInstance.tObjectTypeCode         = fiObjectType:SCREEN-VALUE
               ttPageInstance.tForeignFields          = edForeignFields:SCREEN-VALUE
               ttPageInstance.tLaunchContainer        = fiLaunchContainer:SCREEN-VALUE
               ttPageInstance.tWindowTitleField       = fiWindowTitleField:SCREEN-VALUE
               ttPageInstance.tTemplateObjectFileName = fiTemplateObjectName:SCREEN-VALUE
               ttPageInstance.tLayoutPosition         = fiLayoutPosition:SCREEN-VALUE
               ttPageInstance.tAttributeLabels        = gcAttributeLabels
               ttPageInstance.tAttributeValues        = gcAttributeValues
               .
        IF ttPageInstance.tObjectTypeCode BEGINS "Static" THEN DO:
          IF ttPageInstance.tAttributeLabels <> "":U THEN
            ASSIGN ttPageInstance.tAttributeLabels = ttPageInstance.tAttributeLabels + ",DynamicObject":U
                   ttPageInstance.tAttributeValues = ttPageInstance.tAttributeValues + CHR(3) + "no":U.
          ELSE 
            ASSIGN ttPageInstance.tAttributeLabels = "DynamicObject":U
                   ttPageInstance.tAttributeValues = "no":U.
        END.
        
        /* The NavigationTargetName is only valid for SmartToolbars. */
        IF coNavigationTargetName:SENSITIVE THEN
            ASSIGN ttPageInstance.tNavigationTargetName = (IF coNavigationTargetName:SCREEN-VALUE BEGINS "<":U THEN "":U ELSE coNavigationTargetName:SCREEN-VALUE).
        ELSE
            ASSIGN ttPageInstance.tNavigationTargetName = ?.

        IF VALID-HANDLE(ghContainerSource)                                         AND
           LOOKUP("updatePageInstance":U, ghContainerSource:INTERNAL-ENTRIES) NE 0 THEN
            RUN updatePageInstance IN ghContainerSource (INPUT TABLE ttPageInstance).
    END.    /* avail ttpageinstance */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ChangeObjectType sObject 
PROCEDURE ChangeObjectType :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcObjectTypeCode         AS CHARACTER        NO-UNDO.

    DEFINE VARIABLE cPathedObjectName       AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cSDONames               AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cLinkedObjectName       AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cLinkedObjectType       AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cLinkedObjectId         AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj         AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dObjectTypeObj          AS DECIMAL                  NO-UNDO.

    DEFINE BUFFER ttPageInstance        FOR ttPageInstance.
    DEFINE BUFFER ryc_smartObject       FOR ryc_smartObject.
    DEFINE BUFFER gsc_object            FOR gsc_object.
    DEFINE BUFFER gscob                 FOR gsc_object.

    /* SDOs*/
    IF LOOKUP(pcObjectTypeCode, "SDO,SBO":U) EQ 0 THEN
        ASSIGN edForeignFields:READ-ONLY IN FRAME {&FRAME-NAME} = YES.
    ELSE
        ASSIGN edForeignFields:READ-ONLY IN FRAME {&FRAME-NAME} = NO.

    /* DynBrow */
    IF pcObjectTypeCode EQ "DynBrow":U THEN
        ASSIGN fiLaunchContainer:SENSITIVE  = YES
               fiWindowTitleField:SENSITIVE = YES
               .
    ELSE
        ASSIGN fiLaunchContainer:SENSITIVE     = NO              
               fiWindowTitleField:SENSITIVE    = NO
               fiWindowTitleField:SCREEN-VALUE = ?
               .
    IF fiLaunchContainer:SENSITIVE EQ NO THEN
        ASSIGN fiLaunchContainer:SCREEN-VALUE  = ?.

    /* Toolbar */
    IF pcObjectTypeCode EQ "SmartToolbar":U THEN
    DO:
        ASSIGN coNavigationTargetName:SENSITIVE = YES.

        FIND FIRST ttPageInstance NO-ERROR.

        /* Get the Navigation Target */
        RUN GetLinkDetail IN ghContainerSource ( INPUT  ttPageInstance.tLocalSequence,
                                                 INPUT  "Navigation-Target":U,
                                                 OUTPUT cLinkedObjectName,
                                                 OUTPUT cLinkedObjectId,
                                                 OUTPUT cLinkedObjectType  ).
        /* If the navigation target is an SBO, we launch the SBO to determine which
         * SDOs are available for use as navigation targets.                        */
        IF cLinkedObjectType EQ "SBO":U THEN
        DO:
            FIND FIRST ryc_smartObject WHERE
                       ryc_smartObject.object_filename = cLinkedObjectName
                       NO-LOCK NO-ERROR.

            IF AVAILABLE ryc_smartObject THEN
            DO:
                ASSIGN dSmartObjectObj = ryc_smartobject.smartobject_obj.
                FIND FIRST gsc_object WHERE
                           gsc_object.object_obj =  ryc_smartobject.object_obj
                           NO-LOCK.
                ASSIGN dObjectTypeObj = gsc_object.object_type_obj.

                IF gsc_object.logical_object THEN
                    FIND FIRST gscob WHERE
                               gscob.object_obj = gsc_object.physical_object_obj
                               NO-LOCK NO-ERROR.
                IF AVAILABLE gscob THEN
                DO:
                    ASSIGN cPathedObjectName = RIGHT-TRIM(gscob.object_path, "/~\":U)
                                             + ( IF gscob.object_path EQ "":U THEN "":U ELSE "/":U )
                                             + gscob.object_filename.
                    IF gscob.object_extension NE "":U THEN
                        ASSIGN cPathedObjectName = cPathedObjectName + ".w":U.
                END.    /* logical object */
                ELSE
                DO:
                    ASSIGN cPathedObjectName = RIGHT-TRIM(gsc_object.object_path, "/~\":U)
                                             + ( IF gsc_object.object_path EQ "":U THEN "":U ELSE "/":U )
                                             + gsc_object.object_filename.
                    IF gsc_object.object_extension NE "":U THEN
                        ASSIGN cPathedObjectName = cPathedObjectName + ".w":U.
                END.    /* phys object */

                DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
                    RUN VALUE(cPathedObjectName) PERSISTENT SET ghSBO ON gshAstraAppserver.
                END.  /* do on stop on error */

                IF VALID-HANDLE(ghSBO) THEN
                DO:
                    RUN initializeObject IN ghSBO NO-ERROR.

                    /* Get the Data Object names from the SBO and populate the SDF combo
                     * with them. The combo sorts the data.                              */
                    ASSIGN cSDONames = DYNAMIC-FUNCTION("getDataObjectNames":U IN ghSBO)
                           NO-ERROR.
                    ASSIGN coNavigationTargetName:LIST-ITEMS = (IF cSDONames EQ "":U THEN "":U ELSE (cSDONames + coNavigationTargetName:DELIMITER)) + "<None>".
                END.    /* valid SBO handle */                
                ELSE
                    ASSIGN coNavigationTargetName:LIST-ITEMS = "<<Could not start SBO>>"
                           coNavigationTargetName:SENSITIVE  = NO
                           .
            END.    /* avail smartobject */

            IF VALID-HANDLE(ghSBO) THEN
            DO:
                RUN destroyObject IN ghSBO.
                ASSIGN ghSBO = ?.
            END.    /* valid ghSBO */
            ELSE
                ASSIGN ghSBO =?.
        END.    /* linked object is SBO */
        ELSE
            ASSIGN coNavigationTargetName:LIST-ITEMS   = "<None>" + (IF cLinkedObjectName EQ "":U THEN "":U ELSE coNavigationTargetName:DELIMITER) + cLinkedObjectName.

        ASSIGN coNavigationTargetName:SCREEN-VALUE = coNavigationTargetName:ENTRY(1)
               coNavigationTargetName:SCREEN-VALUE = ttPageInstance.tNavigationTargetName
               NO-ERROR.
    END.    /* smart toolbar. */
    ELSE
        ASSIGN coNavigationTargetName:SENSITIVE    = NO
               coNavigationTargetName:LIST-ITEMS   = "<None>"
               coNavigationTargetName:SCREEN-VALUE = coNavigationTargetName:ENTRY(1)
               NO-ERROR.
    RETURN.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAttributeValue sObject 
PROCEDURE getAttributeValue :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will return the value of a specified attribute
               value for a master object selected.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectName        AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcAttributeLabel    AS CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcAttributeValue    AS CHARACTER            NO-UNDO.

    DEFINE BUFFER ryc_attribute_value FOR ryc_attribute_value.
    DEFINE BUFFER ryc_smartObject     FOR ryc_smartObject.
    DEFINE BUFFER gsc_object          FOR gsc_object.
    
    FIND FIRST ryc_smartObject WHERE
               ryc_smartObject.object_filename = pcObjectName
               NO-LOCK NO-ERROR.
    IF AVAILABLE ryc_smartObject THEN
    DO:
        FIND FIRST gsc_object WHERE
                   gsc_object.object_obj =  ryc_smartobject.object_obj
                   NO-LOCK.

        /* Find the attribute value for the master object */
        FIND FIRST ryc_attribute_value WHERE
                   ryc_attribute_value.object_type_obj           = gsc_object.object_type_obj      AND
                   ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj AND
                   ryc_attribute_value.container_smartobject_obj = 0                               AND
                   ryc_attribute_value.attribute_label           = pcAttributeLabel
                   NO-LOCK NO-ERROR.
        IF AVAILABLE ryc_attribute_value THEN
            ASSIGN pcAttributeValue = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager,
                                                       INPUT ryc_attribute_value.attribute_type_TLA,
                                                       INPUT ryc_attribute_value.attribute_value).
        ELSE
            ASSIGN pcAttributeValue = "":U.
    END.    /* avail smartobject */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    {get ContainerSource ghContainerSource}.

    ASSIGN gcContainerObjectTypeCode                             = DYNAMIC-FUNCTION("getContainerType":U IN ghContainerSource)
           coNavigationTargetName:TOOLTIP IN FRAME {&FRAME-NAME} = "When this toolbar's Navigation target is an SBO, this should be the instance name of the SDO being navigated."
           NO-ERROR.

    RUN SUPER.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RecordChange sObject 
PROCEDURE RecordChange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttPageInstance.

    FIND FIRST ttPageInstance NO-ERROR.

    IF AVAILABLE ttPageInstance THEN
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN fiObjectName:SCREEN-VALUE           = ttPageInstance.tObjectFileName
               fiObjectType:SCREEN-VALUE           = ttPageInstance.tObjectTypeCode
               edForeignFields:SCREEN-VALUE        = ttPageInstance.tForeignFields
               fiLaunchContainer:SCREEN-VALUE      = ttPageInstance.tLaunchContainer
               fiWindowTitleField:SCREEN-VALUE     = ttPageInstance.tWindowTitleField
               fiTemplateObjectName:SCREEN-VALUE   = ttPageInstance.tTemplateObjectFileName
               fiLayoutPosition:SCREEN-VALUE       = ttPageInstance.tLayoutPosition
               /* The NavigationTargetName is set in ChangeObjectType */
               gcAttributeValues                   = "":U
               gcAttributeLabels                   = "":U
               .
        /* Force Object Type related viewer dependencies. */
        RUN ChangeObjectType (INPUT ttPageInstance.tObjectTypeCode).
    END.    /* avail ttPageInstance */

    ASSIGN buApply:SENSITIVE = (AVAILABLE ttPageInstance)
           buProp:SENSITIVE  = (AVAILABLE ttPageInstance)
           .
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setProperties sObject 
PROCEDURE setProperties :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cButtonPressed          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cLinkedObjectName       AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cLinkedObjectType       AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cLinkedObjectId         AS DECIMAL                  NO-UNDO.
    
    FIND FIRST ttPageInstance NO-ERROR.
    IF AVAILABLE ttPageInstance THEN
    DO:
        ASSIGN cLinkedObjectName = "":U
               cLinkedObjectId   = 0
               cLinkedObjectType = "":U
               .
        RUN GetLinkDetail IN ghContainerSource ( INPUT  ttPageInstance.tLocalSequence,
                                                 INPUT  "Data-Source":U,
                                                 OUTPUT cLinkedObjectName,
                                                 OUTPUT cLinkedObjectId,
                                                 OUTPUT cLinkedObjectType  ).

        IF cLinkedObjectName EQ "":U OR cLinkedObjectName EQ ? THEN
            RUN GetLinkDetail IN ghContainerSource ( INPUT  ttPageInstance.tLocalSequence,
                                                     INPUT  "Navigation-Target":U,
                                                     OUTPUT cLinkedObjectName,
                                                     OUTPUT cLinkedObjectId,
                                                     OUTPUT cLinkedObjectType  ).

        RUN af/cod2/afpropwin.p ( INPUT  ttPageInstance.tObjectFileName,
                                  INPUT  ttPageInstance.tObjectInstanceObj,
                                  INPUT  (IF CAN-DO("SDO,SBO":U, cLinkedObjectType) THEN cLinkedObjectName ELSE "":U),  /* SDO Name */
                                  INPUT  (IF ttPageInstance.tOIAction EQ "TEMPLATE":U THEN NO ELSE YES),                /* return only changes? */
                                  OUTPUT gcAttributeLabels,
                                  OUTPUT gcAttributeValues ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        DO:
            RUN showMessages IN gshSessionManager (INPUT  RETURN-VALUE,                     /* message to display */
                                                   INPUT  "ERR",                            /* error type */
                                                   INPUT  "&OK",                            /* button list */
                                                   INPUT  "&OK",                            /* default button */ 
                                                   INPUT  "&OK",                            /* cancel button */
                                                   INPUT  "", /* error window title */
                                                   INPUT  YES,                              /* display if empty */ 
                                                   INPUT  ghContainerSource,                /* container handle */ 
                                                   OUTPUT cButtonPressed           ).
            RETURN ERROR.
        END.    /* error */
    END.    /* avail ttpageinstance */

    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

