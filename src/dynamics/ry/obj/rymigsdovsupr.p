&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Migration preferences for SDOs viewer"
*/
&ANALYZE-RESUME
/* Connected Databases 
*/
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*---------------------------------------------------------------------------------
  File: C:/migration/ry/obj/rymigsdovsupr.p rymigsdov

  Description:  Migration preferences for SDOs viewer

  Purpose:      This is part of the advanced migration dynamic folder.  It is the viewer used to
                edit user preferences when migrating static SDOs to dynamic SDOs.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   01/22/2003  Author:     Ross Hunter

  Update Notes: Created from Template viewv

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

&scop object-name       rymigsdovsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-DynamicSmartDataViewer yes

{src/adm2/globals.i}
{adeuib/sharvars.i}
{src/adm2/inrepprmod.i}

DEFINE VARIABLE gcFields      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcHandles     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcProfileData AS CHARACTER  NO-UNDO.
DEFINE VARIABLE rRowid        AS ROWID      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmcrfullo.i"



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-disableWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disableWidget Procedure 
FUNCTION disableWidget RETURNS LOGICAL
  ( pcNameList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enableWidget Procedure 
FUNCTION enableWidget RETURNS LOGICAL
  ( pcNameList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-FetchPMListItemPairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FetchPMListItemPairs Procedure 
FUNCTION FetchPMListItemPairs RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getScreenValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getScreenValues Procedure 
FUNCTION getScreenValues RETURNS CHARACTER
  ( pcFieldList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWidgetAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWidgetAttribute Procedure 
FUNCTION setWidgetAttribute RETURNS LOGICAL
  ( pcWidget AS CHARACTER,
    pcAttr   AS CHARACTER,
    pcValue  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-WidgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD WidgetHandle Procedure 
FUNCTION WidgetHandle RETURNS HANDLE
  ( pcWidgetName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Compile into: 
   Data Source: "gsmcrfullo"
   Allow: Basic,Browse,DB-Fields
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY PERSISTENT-ONLY COMPILE
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
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 20.33
         WIDTH              = 49.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    /* RUN initializeObject. */
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-InitializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeObject Procedure 
PROCEDURE InitializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPMItemPairs   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSVobjs        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSVvals        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSubClasses    AS CHARACTER  NO-UNDO.

  RUN SUPER.
 
  /* Get Profile information */
  ASSIGN rRowid = ?.
  IF VALID-HANDLE(gshProfileManager) THEN
  RUN getProfileData IN gshProfileManager (INPUT "General":U,         /* Profile type code     */
                                           INPUT "Preference":U,      /* Profile code          */
                                           INPUT "GenerateObjects":U, /* Profile data key      */
                                           INPUT "NO":U,              /* Get next record flag  */
                                           INPUT-OUTPUT rRowid,       /* Rowid of profile data */
                                           OUTPUT gcProfileData).     /* Found profile data.   */

  IF gcProfileData NE "":U THEN DO:  /* User has specified preferences in the past */
    {get AllFieldNames   gcFields}.
    {get AllFieldHandles gcHandles}.
   
    /* List items is DynSDO and all of its subclasses */
    cSubClasses = DYNAMIC-FUNCTION("getClassChildrenFromDB" IN gshRepositoryManager,"DynSDO":U).
    setWidgetAttribute("coDynObjectType", "LIST-ITEMS", cSubClasses).
                     
    /* Get Product module list */
    cPMItemPairs = fetchPMListItemPairs().

    /* Set up SDO product module combo */
    setWidgetAttribute("coProdMod", "Delimiter", CHR(4)).
    setWidgetAttribute("coProdMod", "LIST-ITEM-PAIRS", cPMItemPairs).

    /* Set up DLP product module combo */
    setWidgetAttribute("coDLPProdMod", "Delimiter", CHR(4)).
    setWidgetAttribute("coDLPProdMod", "LIST-ITEM-PAIRS", cPMItemPairs).

    /* Make a list of all screen-value objects to set along with a list
       of their values.                                                 */
    ASSIGN cSVobjs = "coDynObjectType,CoProdMod,fiRmPrefix,fiRmSuffix,fiAddPrefix,":U +
                     "fiAddSuffix,raSet,coDLPProdMod,fiAddPrefix-2,fiAddSuffix-2":U
           cSVVals = "SDO_Type,SDO_PM,SDO_RmPre,SDO_RmSuf,SDO_AdPre,":U +
                     "SDO_AdSuf,SDO_DLPOpt,SDO_DLPPM,SDO_DLPPre,SDO_DLPSuf":U.

    /* Display all of the screen values */
    RUN setScreenValues(cSVobjs, cSVvals).

  END.  /* if gcProfileData NE "" */

  {set DataModified TRUE}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ResetHalf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ResetHalf Procedure 
PROCEDURE ResetHalf :
/*------------------------------------------------------------------------------
  Purpose:     When a Reset Button has been pressed, this procedure is run to
               reset the half screen controlled by the button.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSVobjs      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSVVals      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBar         AS HANDLE     NO-UNDO.

  hBar = WidgetHandle("RECT-1").
  IF SELF:Y < hBar:Y THEN DO: /* Top button was pressed */
    /* Make a list of all screen-value objects to set along with a list
       of their values.                                                 */
    ASSIGN cSVobjs = "coDynObjectType,CoProdMod,fiRmPrefix,fiRmSuffix,fiAddPrefix,":U +
                     "fiAddSuffix":U
           cSVVals = "SDO_Type,SDO_PM,SDO_RmPre,SDO_RmSuf,SDO_AdPre,":U +
                     "SDO_AdSuf":U.
           disableWidget("buSDOReset":U).
  END.
  ELSE DO: /* Bottom button was pressed */
    /* Make a list of all screen-value objects to set along with a list
       of their values.                                                 */
    ASSIGN cSVobjs = "raSet,coDLPProdMod,fiAddPrefix-2,fiAddSuffix-2":U
           cSVVals = "SDO_DLPOpt,SDO_DLPPM,SDO_DLPPre,SDO_DLPSuf":U.
           disableWidget("buDLPReset":U).
  END.

  /* Reset the screen values */
  RUN setScreenValues(cSVobjs, cSVvals).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setScreenValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setScreenValues Procedure 
PROCEDURE setScreenValues :
/*------------------------------------------------------------------------------
  Purpose:     To set screen values of a group of objects
  Parameters:  INPUT pcSVobjs     a comma delimited list of screen objects
               INPUT pcSVvals     a comma delimited list of entry names in a 
                                  mapped entry string
               INPUT pcMappedVals a chr(3) delimited list of entry values
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pcSVobjs     AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER pcSVvals     AS CHARACTER  NO-UNDO.

   DEFINE VARIABLE cScreenValue  AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hField        AS HANDLE     NO-UNDO.
   DEFINE VARIABLE iEntry        AS INTEGER    NO-UNDO.
   DEFINE VARIABLE iFldPos       AS INTEGER    NO-UNDO.

   DO iEntry = 1 TO NUM-ENTRIES(pcSVobjs):
     ASSIGN iFldPos      = LOOKUP(ENTRY(iEntry, pcSVobjs), gcFields)
            hField       = WIDGET-HANDLE(ENTRY(iFldPos, gcHandles))
            cScreenValue = DYNAMIC-FUNCTION("mappedEntry" IN _h_func_lib,
                                            ENTRY(iEntry,pcSVvals),
                                            gcProfileData,
                                            TRUE,
                                            CHR(3)).

     /* Convert Product Module codes to OBJ numbers */
     IF LOOKUP(ENTRY(iENTRY, pcSVobjs), "coProdMod,coDLPProdMod":U) > 0 THEN DO:
       FIND FIRST gsc_product_module WHERE gsc_product_module.product_module_code = cScreenValue NO-LOCK.
       cScreenValue = STRING(gsc_product_module.product_module_obj).
     END.

     hField:SCREEN-VALUE = cScreenValue NO-ERROR.
   END.
                                  
                                  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-UpdateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UpdateRecord Procedure 
PROCEDURE UpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     To collect all settings and save them to the Profile Data
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSVobjects AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPDEntries  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSValues    AS CHARACTER  NO-UNDO.

  /* Fetch the latest string (other viewers may have changed it ) */
  RUN getProfileData IN gshProfileManager (INPUT "General":U,         /* Profile type code     */
                                         INPUT "Preference":U,      /* Profile code          */
                                         INPUT "GenerateObjects":U, /* Profile data key      */
                                         INPUT "NO":U,              /* Get next record flag  */
                                         INPUT-OUTPUT rRowid,       /* Rowid of profile data */
                                         OUTPUT gcProfileData).     /* Found profile data.   */
 
  /* Make a list of things to save in this viewer */
  ASSIGN cSVobjects = "coDynObjectType,CoProdMod,fiRmPrefix,fiRmSuffix,fiAddPrefix,":U +
                      "fiAddSuffix,raSet,coDLPProdMod,fiAddPrefix-2,fiAddSuffix-2":U
         cPDEntries = "SDO_Type,SDO_PM,SDO_RmPre,SDO_RmSuf,SDO_AdPre,":U +
                      "SDO_AdSuf,SDO_DLPOpt,SDO_DLPPM,SDO_DLPPre,SDO_DLPSuf":U.

  cSValues = getScreenValues(cSVobjects).

  cPDEntries = REPLACE(cPDEntries, ",":U, CHR(3)).
 

  gcProfileData = DYNAMIC-FUNCTION("assignMappedEntry" IN _h_func_lib,
               cPDEntries,             /* 10 Names         */
               gcProfileData,          /* String to Change */
               cSVAlues,               /* 10 Vlaues        */
               CHR(3),                 /* Delimiter        */
               TRUE).                  /* Name then Value  */

  /* Store cProfile in repository */
  RUN setProfileData IN gshProfileManager (INPUT "General":U,       /* Profile type code */
                                           INPUT "Preference":U,    /* Profile code */
                                           INPUT "GenerateObjects", /* Profile data key */
                                           INPUT ?,                 /* Rowid of profile data */
                                           INPUT gcProfileData,     /* Profile data value */
                                           INPUT NO,                /* Delete flag */
                                           INPUT "PER":u).         /* Save flag (permanent) */

  {set DataModified FALSE}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValueChanged Procedure 
PROCEDURE ValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBar   AS HANDLE     NO-UNDO.

  hBar = WidgetHandle("RECT-1":U).

  IF SELF:Y < hBar:Y THEN enableWidget("buSDOReset":U).
  ELSE enableWidget("buDLPReset":U).

  RUN SUPER.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-disableWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disableWidget Procedure 
FUNCTION disableWidget RETURNS LOGICAL
  ( pcNameList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: To disable all widgets in the list  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWidget   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE i         AS INTEGER    NO-UNDO.

  DO i = 1 TO NUM-ENTRIES(pcNameList):
    hWidget = widgetHandle(ENTRY(i,pcNameList)).
    hWidget:SENSITIVE = FALSE.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enableWidget Procedure 
FUNCTION enableWidget RETURNS LOGICAL
  ( pcNameList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: To enable all widgets in the list  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWidget   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE i         AS INTEGER    NO-UNDO.

  DO i = 1 TO NUM-ENTRIES(pcNameList):
    hWidget = widgetHandle(ENTRY(i,pcNameList)).
    hWidget:SENSITIVE = TRUE.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-FetchPMListItemPairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FetchPMListItemPairs Procedure 
FUNCTION FetchPMListItemPairs RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  To return a string of all Product Module for the purpose of attaching
            it to a combo box.
    Notes:  It is in the standard list-item-pairs format and it takes into account
            the user preference "DispRepos".
------------------------------------------------------------------------------*/
   /* Create a list of all product modules appropriate product modules */
    DEFINE VARIABLE cListItemPairs AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cQuery         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hBuffer        AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hQuery         AS HANDLE     NO-UNDO.

    /* Apply the session's filter set to the product modules */
    CREATE QUERY hQuery.
    CREATE BUFFER hBuffer FOR TABLE "gsc_product_module":U BUFFER-NAME "gsc_product_module":U.

    cQuery = "FOR EACH gsc_product_module NO-LOCK WHERE [&FilterSet=|&EntityList=GSCPM]":U.

    RUN processQueryStringFilterSets IN gshGenManager (INPUT  cQuery,
                                                       OUTPUT cQuery).

    /* Setup and prepare the query */
    hQuery:SET-BUFFERS(hBuffer).
    hQuery:QUERY-PREPARE(cQuery).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().

    clistItemPairs = "".

    /* I am referencing the db-buffer here directly on the dynamic viewer because that is what the old code did... */
    /* Step through the query if there is data */
    DO WHILE NOT hQuery:QUERY-OFF-END:
      ASSIGN clistItemPairs = cListItemPairs + CHR(4)
                            + hBuffer:BUFFER-FIELD("product_module_code":U):BUFFER-VALUE
                            + " // " + hBuffer:BUFFER-FIELD("product_module_description":U):BUFFER-VALUE + CHR(4)
                            + STRING(hBuffer:BUFFER-FIELD("product_module_obj":U):BUFFER-VALUE).

      /* Find the next record */
      hQuery:GET-NEXT().
    END.
    cListItemPairs = LEFT-TRIM(cListItemPairs, CHR(4)).

    DELETE OBJECT hQuery.
    DELETE OBJECT hBuffer.

    RETURN cListItemPairs.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getScreenValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getScreenValues Procedure 
FUNCTION getScreenValues RETURNS CHARACTER
  ( pcFieldList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  To get screen values (in CHR(3) delimited list of the objects in the
            input field list.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cScreenValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValues      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iField       AS INTEGER    NO-UNDO.

  DO iField = 1 TO NUM-ENTRIES(pcFieldList):
    hField = WidgetHandle(ENTRY(iField, pcFieldList)).
    cScreenValue =  hField:SCREEN-VALUE.

    /* Convert PM obj numbers back to Codes */
    IF LOOKUP(ENTRY(iField, pcFieldList), "coProdMod,coDLPProdMod":U) > 0 THEN DO:
      FIND FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = 
            DECIMAL(cScreenValue) NO-LOCK.
      cScreenValue = gsc_product_module.product_module_code.
    END.
    cValues = cValues + (IF cValues = "":U THEN "":U ELSE CHR(3)) + 
                      cScreenValue.
  END.
  RETURN cValues.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWidgetAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWidgetAttribute Procedure 
FUNCTION setWidgetAttribute RETURNS LOGICAL
  ( pcWidget AS CHARACTER,
    pcAttr   AS CHARACTER,
    pcValue  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iFieldPos AS INTEGER    NO-UNDO. 
  DEFINE VARIABLE hField    AS HANDLE     NO-UNDO.

  /* Get widget handle */
  iFieldPos = LOOKUP(pcWidget, gcFields).

  IF iFieldPos > 0 THEN DO:
    hField = WIDGET-HANDLE(ENTRY(iFieldPos, gcHandles)).
    CASE pcAttr:
      WHEN "Delimiter":U THEN       hField:DELIMITER       = pcValue.
      WHEN "LIST-ITEMS":U THEN      hField:LIST-ITEMS      = pcValue.
      WHEN "LIST-ITEM-PAIRS":U THEN hField:LIST-ITEM-PAIRS = pcValue.
      WHEN "SCREEN-VALUE":U THEN    hField:SCREEN-VALUE    = pcValue.
      OTHERWISE RETURN FALSE.
    END CASE.
    RETURN TRUE.
  END.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-WidgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION WidgetHandle Procedure 
FUNCTION WidgetHandle RETURNS HANDLE
  ( pcWidgetName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Given a widget name, return its handle
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iFieldPos AS INTEGER    NO-UNDO.

  iFieldPos = LOOKUP(pcWidgetName, gcFields).
  
  RETURN IF iFieldPos > 0 THEN WIDGET-HANDLE(ENTRY(iFieldPos, gcHandles))
         ELSE ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

