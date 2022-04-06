&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  File: afgendlogp.p

  Description:  Generate DataLogic Procedure

  Purpose:      Generate DataLogic Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/04/2002  Author:     Peter Judge
  Update Notes: Created from Template rytemplipp.p

  (v:010001)    Task:           0   UserRef:    
                Date:   08/21/2002  Author:     Mark Davies (MIP)            
  Update Notes: Fix for issue #5796 - Error generating Sports2000 objects in Object Generator
  
  (v:010002)    Task:           0   UserRef:    
                Date:   03/19/2003  Author:    DB              
  Added support for enabledfields by adding new input param pcValidationFields
--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgendlogp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

DEFINE INPUT PARAMETER pcLogicProcedureFile         AS CHARACTER   NO-UNDO.    /* Rel pathed file name eg. ry/obj/rycsologcp.p */
DEFINE INPUT PARAMETER pcRootFolder                 AS CHARACTER   NO-UNDO.    /* eg. c:/posse/work/ . Will have the  / at the end. */
DEFINE INPUT PARAMETER pcLogicProcedureTemplate     AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER pcTableNameList              AS CHARACTER   NO-UNDO.   /* Delimited list of tables and dbs  sports2000.customer,sports2000.salesrep */
DEFINE INPUT PARAMETER pcFieldList                  AS CHARACTER   NO-UNDO.   /* Delimited list of fields per table comma delim and chr(1) delim between tables*/
DEFINE INPUT PARAMETER pcValidationFields           AS CHARACTER   NO-UNDO.  /* CHR(2) and CHR(1) Delimited List - see below */
DEFINE INPUT PARAMETER pcDefinitionIncludeName      AS CHARACTER   NO-UNDO.    /* eg. ry/obj/rycsofullo.i */
DEFINE INPUT PARAMETER plCreateMissingFolder        AS LOGICAL     NO-UNDO.
DEFINE INPUT PARAMETER plSuppressvalidation         AS LOGICAL     NO-UNDO.   
DEFINE INPUT PARAMETER pcTempTableDefinition        AS CHARACTER   NO-UNDO.    /* Temp Table or Buffer Statement written to the Definition Section*/
DEFINE INPUT PARAMETER plRowObjectNoUndo            AS LOGICAL     NO-UNDO.    /* DATA-TABLE-NO-UNDO preprocessor written */

/* pcValidationFields is used in the rowObjectValidate procedure.  It contains the field names , 
   the character type and the label grouped by table and delimited by Chr(2) between each item. A 
   chr(1) delimiter is used between tables
   i.e.  custnum[chr(2)]integer[chr[2)]customer Number[chr(2)]name[chr(2)]character[chr(2)]Name[CHR(1)]salesrep[chr(2)]integer... */
   

{src/adm2/globals.i }


DEFINE STREAM sFile.

DEFINE TEMP-TABLE ttTemplate  NO-UNDO
            FIELD ttfLine     AS INTEGER
            FIELD ttfValue    AS CHARACTER
            INDEX ttiPrimary
                  ttfLine
    .

DEFINE TEMP-TABLE ttDLProc    NO-UNDO
            FIELD ttfLine     AS INTEGER
            FIELD ttfValue    AS CHARACTER
            INDEX ttiPrimary
                  ttfLine
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addDataLogicProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addDataLogicProcedure Procedure 
FUNCTION addDataLogicProcedure RETURNS LOGICAL
    ( INPUT pcValue     AS CHARACTER
    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addDataLogicTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addDataLogicTemplate Procedure 
FUNCTION addDataLogicTemplate RETURNS LOGICAL
    ( INPUT pcValue     AS CHARACTER
    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildCreatePreTransValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildCreatePreTransValidate Procedure 
FUNCTION buildCreatePreTransValidate RETURNS CHARACTER
    ( INPUT pcTable         AS CHARACTER   ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildRowObjectValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildRowObjectValidate Procedure 
FUNCTION buildRowObjectValidate RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildWritePreTransValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildWritePreTransValidate Procedure 
FUNCTION buildWritePreTransValidate RETURNS CHARACTER
    ( INPUT pcTable         AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Compile into: af/app
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 17.43
         WIDTH              = 56.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

  DEFINE VARIABLE cClientProxyName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullyPathedProcedure       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTable                      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iField                      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cEntryList                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCreateFolder               AS CHARACTER  NO-UNDO.

  EMPTY TEMP-TABLE ttTemplate.
  EMPTY TEMP-TABLE ttDLProc.

/*NOTE:  Since the Data logic in adm2/logic.i can only support one table we need to ensure that 
         validation is generated for the first enabled table only. This should be removed once 
         logic.i supports multiple tables */
       
  ASSIGN pcTableNameList    = ENTRY(1,pcTableNameList)
         pcFieldList        = ENTRY(1,pcFieldList,CHR(1))
         pcValidationFields = ENTRY(1,pcValidationFields,CHR(1))
         NO-ERROR.


  RUN createDataLogicProcedure.

  IF pcRootFolder EQ "/":U OR pcRootFolder EQ "~\":U   THEN
    ASSIGN cFullyPathedProcedure = pcLogicProcedureFile.
  ELSE 
    ASSIGN cFullyPathedProcedure = pcRootFolder + pcLogicProcedureFile
           cFullyPathedProcedure = REPLACE(cFullyPathedProcedure,"~\","/").

  IF NUM-ENTRIES(cFullyPathedProcedure,"/":U) > 1 THEN  
     ASSIGN cCreateFolder = SUBSTRING(cFullyPathedProcedure,1,R-INDEX(cFullyPathedProcedure,"/") - 1) .
  ELSE   
     ASSIGN cCreateFolder =  pcRootFolder.
     
  ASSIGN FILE-INFO:FILE-NAME = cCreateFolder.

  IF FILE-INFO:FULL-PATHNAME EQ ?
  THEN DO:
    IF plCreateMissingFolder
    THEN DO:
      IF NOT DYNAMIC-FUNCTION("createFolder":U IN gshGenManager, INPUT cCreateFolder)
      THEN
        RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'unable to create folder: ' + pcRootFolder"}.
    END.    /* create the folder */
    ELSE
      RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'folder does not exist: ' + pcRootFolder"}.
  END.    /* folder doesnøt exist */

  /* Output the Data Logic Procedure */
  OUTPUT STREAM sFile TO VALUE(cFullyPathedProcedure).

  FOR EACH ttDLProc
    BY ttDLProc.ttfLine:

    IF ttDLProc.ttfValue <> "":U
    THEN
      PUT STREAM sFile UNFORMATTED
        ttDLProc.ttfValue
        SKIP
        .
    ELSE
      PUT STREAM sFile
        " ":U
        SKIP
        .

  END.

  OUTPUT STREAM sFile CLOSE.

  /* Output the Data Logic Procedure client _CL proxy */
  ASSIGN cClientProxyName = REPLACE(cFullyPathedProcedure,".p","_cl.p").

  OUTPUT STREAM sFile TO VALUE(cClientProxyName).

  PUT STREAM sFile UNFORMATTED
    "/* ":U
    cClientProxyName
    " - non-db proxy for "
    pcLogicProcedureFile
    " */ ":U
    SKIP
    "&GLOBAL-DEFINE DB-REQUIRED FALSE":U
    SKIP
    '~{"' + pcLogicProcedureFile + '"~}'
    SKIP
    .

  OUTPUT STREAM sFile CLOSE.

  RETURN.

/* EOF */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-createDataLogicProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDataLogicProcedure Procedure 
PROCEDURE createDataLogicProcedure :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       TABLES
                      ttTemplate
                      ttDLProc
               FIELDS
                      ttDLProc.ttfLine
                      ttDLProc.ttfValue

------------------------------------------------------------------------------*/

  DEFINE VARIABLE cDataLogicProcedureTemplate AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cLineValue                  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lTemplateProcedure          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lTemplateFunction           AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE lSectionProcedure           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSectionFunction            AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE lCreatePreTransValidate     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lWritePreTransValidate      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRowObjectValidate          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDataTableNoUndo            AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE lReplaceFileName            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lReplaceFileDesc            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lReplaceTableName           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lReplaceObjectName          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lReplaceObjectDesc          AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cPreprocessorLine           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProcedureName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProcedureDescription       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProcedureRequired          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProcedureFunction          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableName                  AS CHARACTER  NO-UNDO.

  ASSIGN
    lTemplateProcedure      = NO
    lTemplateFunction       = NO
    lSectionProcedure       = NO
    lSectionFunction        = NO
    lCreatePreTransValidate = NO
    lWritePreTransValidate  = NO
    lRowObjectValidate      = NO
    lDataTableNoUndo        = NO
    lReplaceFileName        = NO
    lReplaceFileDesc        = NO
    lReplaceTableName       = NO
    lReplaceObjectName      = NO
    lReplaceObjectDesc      = NO
    cTableName              = ENTRY(1,pcTableNameList).

  cDataLogicProcedureTemplate = SEARCH(pcLogicProcedureTemplate).

  IF cDataLogicProcedureTemplate <> ?
  AND cDataLogicProcedureTemplate <> "":U
  THEN DO:

    ASSIGN
      cDataLogicProcedureTemplate = REPLACE(cDataLogicProcedureTemplate,"~\":U,"~/":U).

    INPUT STREAM sFile FROM VALUE(cDataLogicProcedureTemplate).

    REPEAT:

      IMPORT STREAM sFile UNFORMATTED
        cLineValue.

      /* Check if the template does have Internal Procedures */
      IF NOT lTemplateProcedure
      THEN
        RUN scanLine (INPUT-OUTPUT cLineValue
                     ,INPUT        "/* **********************  Internal Procedures":U
                     ,INPUT        "/* **********************  Internal Procedures":U
                     ,INPUT        NO
                     ,INPUT        "":U
                     ,OUTPUT       lTemplateProcedure
                     ).
      /* Check if the template does have Functions */
      IF NOT lTemplateFunction
      THEN
        RUN scanLine (INPUT-OUTPUT cLineValue
                     ,INPUT        "/* ************************  Function Implementations":U
                     ,INPUT        "/* ************************  Function Implementations":U
                     ,INPUT        NO
                     ,INPUT        "":U
                     ,OUTPUT       lTemplateFunction
                     ).
      /* Check if the template does have a createPreTransValidate procedure */
      IF NOT lCreatePreTransValidate
      THEN
        RUN scanLine (INPUT-OUTPUT cLineValue
                     ,INPUT        "PROCEDURE createPreTransValidate":U
                     ,INPUT        "PROCEDURE createPreTransValidate":U
                     ,INPUT        NO
                     ,INPUT        "":U
                     ,OUTPUT       lCreatePreTransValidate
                     ).
      /* Check if the template does have a writePreTransValidate procedure */
      IF NOT lWritePreTransValidate
      THEN
        RUN scanLine (INPUT-OUTPUT cLineValue
                     ,INPUT        "PROCEDURE writePreTransValidate":U
                     ,INPUT        "PROCEDURE writePreTransValidate":U
                     ,INPUT        NO
                     ,INPUT        "":U
                     ,OUTPUT       lWritePreTransValidate
                     ).
      /* Check if the template does have a rowObjectValidate procedure */
      IF NOT lRowObjectValidate
      THEN
        RUN scanLine (INPUT-OUTPUT cLineValue
                     ,INPUT        "PROCEDURE rowObjectValidate":U
                     ,INPUT        "PROCEDURE rowObjectValidate":U
                     ,INPUT        NO
                     ,INPUT        "":U
                     ,OUTPUT       lRowObjectValidate
                     ).

      /* Check if the template has DATA-TABLE-NO-UNDO preprocessor.  If so,
         replace it because it is written below based on the Use NO-UNDO 
         for RowObject option in the tools (AppBuilder/Object Generator. */
      IF NOT lDataTableNoUndo THEN
      DO:
        RUN scanLine (INPUT-OUTPUT cLineValue
                     ,INPUT        "&Global-define DATA-TABLE-NO-UNDO":U
                     ,INPUT        "&Global-define DATA-TABLE-NO-UNDO":U
                     ,INPUT        YES
                     ,INPUT        "":U
                     ,OUTPUT       lDataTableNoUndo
                     ).
        /* cLineValue must be blanked here because the preprocessor may
           or may not be set to a value, scanLine only replaces what is 
           passed to it */
        IF lDataTableNoUndo THEN cLineValue = "":U.
      END.  /* if not lDataTableNoUndo */

      /* Write the line to the temp-table */
      DYNAMIC-FUNCTION("addDataLogicTemplate", INPUT cLineValue).

    END.

    INPUT STREAM sFile CLOSE.

  END.
  ELSE
    RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "'the Data Logic Procedure Template'" 'pcLogicProcedureTemplate'}.

  /* Add the following procedures to the template if they does not exist */
  ASSIGN
    cProcedureName        = "":U
    cProcedureDescription = "":U
    cProcedureRequired    = "":U
    cProcedureFunction    = "":U
    .

  IF NOT lCreatePreTransValidate
  THEN DO:
    IF cProcedureName <> "":U
    THEN
      ASSIGN
        cProcedureName        = cProcedureName        + CHR(1)
        cProcedureDescription = cProcedureDescription + CHR(1)
        cProcedureRequired    = cProcedureRequired    + CHR(1)
        cProcedureFunction    = cProcedureFunction    + CHR(1)
        .
    ASSIGN
      cProcedureName        = cProcedureName        + "createPreTransValidate":U
      cProcedureDescription = cProcedureDescription + "Procedure used to validate records server-side before the transaction scope upon create":U
      cProcedureRequired    = cProcedureRequired    + "YES":U
      cProcedureFunction    = cProcedureFunction    + "buildCreatePreTransValidate":U
      .
  END.

  IF NOT lWritePreTransValidate
  THEN DO:
    IF cProcedureName <> "":U
    THEN
      ASSIGN
        cProcedureName        = cProcedureName        + CHR(1)
        cProcedureDescription = cProcedureDescription + CHR(1)
        cProcedureRequired    = cProcedureRequired    + CHR(1)
        cProcedureFunction    = cProcedureFunction    + CHR(1)
        .
    ASSIGN
      cProcedureName        = cProcedureName        + "writePreTransValidate":U
      cProcedureDescription = cProcedureDescription + "Procedure used to validate records server-side before the transaction scope upon write":U
      cProcedureRequired    = cProcedureRequired    + "YES":U
      cProcedureFunction    = cProcedureFunction    + "buildWritePreTransValidate":U
      .
  END.

  IF NOT lRowObjectValidate
  THEN DO:
    IF cProcedureName <> "":U
    THEN
      ASSIGN
        cProcedureName        = cProcedureName        + CHR(1)
        cProcedureDescription = cProcedureDescription + CHR(1)
        cProcedureRequired    = cProcedureRequired    + CHR(1)
        cProcedureFunction    = cProcedureFunction    + CHR(1)
        .
    ASSIGN
      cProcedureName        = cProcedureName        + "rowObjectValidate":U
      cProcedureDescription = cProcedureDescription + "Procedure used to validate RowObject record client-side":U
      cProcedureRequired    = cProcedureRequired    + "NO":U
      cProcedureFunction    = cProcedureFunction    + "buildRowObjectValidate":U
      .
  END.

  blkTemplate:
  FOR EACH ttTemplate NO-LOCK:

    ASSIGN
      cLineValue = ttTemplate.ttfValue.
      
    /* If TempTable Statement is passed add it at the beginning of the definition section */
    IF pcTempTableDefinition > ""  THEN 
    DO:
      IF INDEX(cLineValue,"&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS":U) > 0 THEN
      DO:
          cLineValue = cLineValue + CHR(10) + pcTempTableDefinition.
          DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT cLineValue).
          NEXT blkTemplate.
      END.           
    END.
    
    /* Add preprocessors to the end of the preprocessor block */
    IF INDEX(cLineValue,"_UIB-PREPROCESSOR-BLOCK-END":U) > 0 THEN
    DO:
      /* Define Table-Name and truncate Data-Logic-Table to maximum 28 characters - Issuezilla 2132 */
      IF LENGTH(cTableName) > 28 THEN
        ASSIGN cPreprocessorLine = "&Global-define TABLE-NAME "  + cTableName +
              CHR(10) + "&Global-define DATA-LOGIC-TABLE "  + SUBSTRING(cTableName,1,28).
      ELSE ASSIGN cPreprocessorLine = "&Global-define DATA-LOGIC-TABLE "  + cTableName.
      ASSIGN cPreprocessorLine = cPreprocessorLine + CHR(10) +
          '&Global-define DATA-FIELD-DEFS "' + pcDefinitionIncludeName + '"':U.
      IF plRowObjectNoUndo THEN
        ASSIGN cPreprocessorLine = cPreprocessorLine + CHR(10) + "&Global-define DATA-TABLE-NO-UNDO NO-UNDO".
      cLineValue = cPreprocessorLine + CHR(10) + CHR(10) + cLineValue.
      DYNAMIC-FUNCTION("addDataLogicProcedure":U, INPUT cLineValue).
      NEXT blkTemplate.
    END.  /* if end of preprocessor block */

    IF NOT lReplaceFileName
    THEN DO:
      RUN scanLine (INPUT-OUTPUT cLineValue
                   ,INPUT        "File: rytemlogic.p"
                   ,INPUT        ".p"
                   ,INPUT        YES
                   ,INPUT        "File: " + ENTRY(NUM-ENTRIES(pcLogicProcedureFile,"/":U),pcLogicProcedureFile,"/":U)
                   ,OUTPUT       lReplaceFileName
                   ).
      IF lReplaceFileName
      THEN DO:
        DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT cLineValue).
        NEXT blkTemplate.
      END.
    END.

    IF NOT lReplaceFileDesc
    THEN DO:
      RUN scanLine (INPUT-OUTPUT cLineValue
                   ,INPUT        "Description:  Data "
                   ,INPUT        "Logic"
                   ,INPUT        YES
                   ,INPUT        "Description:  " + pcTableNameList + " Data Logic"
                   ,OUTPUT       lReplaceFileDesc
                   ).
      IF lReplaceFileDesc
      THEN DO:
        DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT cLineValue).
        NEXT blkTemplate.
      END.
    END.

    IF NOT lReplaceTableName
    THEN DO:
      RUN scanLine (INPUT-OUTPUT cLineValue
                   ,INPUT        "data-"
                   ,INPUT        "logic"
                   ,INPUT        YES
                   ,INPUT        pcTableNameList
                   ,OUTPUT       lReplaceTableName
                   ).
      IF lReplaceTableName
      THEN DO:
        DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT cLineValue).
        NEXT blkTemplate.
      END.
    END.

    IF NOT lReplaceObjectName
    THEN DO:
      RUN scanLine (INPUT-OUTPUT cLineValue
                   ,INPUT        "&scop object-name"
                   ,INPUT        ".p"
                   ,INPUT        YES
                   ,INPUT        "&scop object-name       " + ENTRY(NUM-ENTRIES(pcLogicProcedureFile,"/":U),pcLogicProcedureFile,"/":U)
                   ,OUTPUT       lReplaceObjectName
                   ).
      IF lReplaceObjectName
      THEN DO:
        DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT cLineValue).
        NEXT blkTemplate.
      END.
    END.

    IF NOT lReplaceObjectDesc
    THEN DO:

      RUN scanLine (INPUT-OUTPUT cLineValue
                   ,INPUT        "ASSIGN cProcedurePurpose = "
                   ,INPUT        "PLIP"
                   ,INPUT        YES
                   ,INPUT        'ASSIGN cProcedurePurpose = "' +  pcTableNameList + ' Data Logic Procedure'
                   ,OUTPUT       lReplaceObjectDesc
                   ).
      IF lReplaceObjectDesc
      THEN DO:
        DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT cLineValue).
        NEXT blkTemplate.
      END.
    END.

    /* Add the procedures before function section */
    /* If there is no function section if will be added at the end. */
    IF  lTemplateProcedure
    AND lTemplateFunction
    AND NOT lSectionFunction
    THEN DO:
      RUN scanLine (INPUT-OUTPUT cLineValue
                   ,INPUT        "/* ************************  Function Implementations":U
                   ,INPUT        "/* ************************  Function Implementations":U
                   ,INPUT        NO
                   ,INPUT        "":U
                   ,OUTPUT       lSectionFunction
                   ).
      IF lSectionFunction
      THEN DO:

        RUN insertProcedure (INPUT  cProcedureName
                            ,INPUT  cProcedureDescription
                            ,INPUT  cProcedureRequired
                            ,INPUT  cProcedureFunction
                            ).

        DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT cLineValue).

        NEXT blkTemplate.

      END. /* lSectionFunction */

    END. /* IF  lTemplateProcedure AND lTemplateFunction AND NOT lSectionFunction */

    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT cLineValue).

  END. /* EACH ttTemplate */

  /* Add the procedures if not added already */
  IF lTemplateProcedure
  AND NOT lSectionFunction
  THEN DO:

    RUN insertProcedure (INPUT  cProcedureName
                        ,INPUT  cProcedureDescription
                        ,INPUT  cProcedureRequired
                        ,INPUT  cProcedureFunction
                        ).

    ASSIGN
      lSectionFunction = YES.

  END. /* IF  lTemplateProcedure AND NOT lSectionFunction */

  IF lTemplateFunction
  THEN DO:

    RUN insertFunction.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertFunction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertFunction Procedure 
PROCEDURE insertFunction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertProcedure Procedure 
PROCEDURE insertProcedure :
/*------------------------------------------------------------------------------
  Purpose:     addProcedure
  Notes:       Adds a procedure if it does not exist and positions the editor cursor
               at the start of the procedure, ready to receive text. If the procedure exists,
               does nothing
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcProcedureName           AS CHARACTER        NO-UNDO.
  DEFINE INPUT  PARAMETER pcProcedureDescription    AS CHARACTER        NO-UNDO.
  DEFINE INPUT  PARAMETER pcProcedureRequired       AS CHARACTER        NO-UNDO.
  DEFINE INPUT  PARAMETER pcProcedureFunction       AS CHARACTER        NO-UNDO.

  DEFINE VARIABLE iLoop                             AS INTEGER          NO-UNDO.

  DEFINE VARIABLE iReturnLoop                       AS INTEGER          NO-UNDO.
  DEFINE VARIABLE cReturnValue                      AS CHARACTER        NO-UNDO.

  DEFINE VARIABLE cName                             AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE cPurpose                          AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE lRequired                         AS LOGICAL          NO-UNDO.
  DEFINE VARIABLE cFunction                         AS CHARACTER        NO-UNDO.

  DEFINE VARIABLE cRequired                         AS CHARACTER        NO-UNDO.

  DO iLoop = 1 TO NUM-ENTRIES(pcProcedureName,CHR(1)):

    ASSIGN
      cName     = ENTRY(iLoop,pcProcedureName,CHR(1))
      cPurpose  = ENTRY(iLoop,pcProcedureDescription,CHR(1))
      lRequired = (IF ENTRY(iLoop,pcProcedureRequired,CHR(1)) = "YES":U THEN TRUE ELSE FALSE)
      cFunction = ENTRY(iLoop,pcProcedureFunction,CHR(1))
      .
    
    IF lRequired
    THEN
      ASSIGN
        cRequired = "_DB-REQUIRED".
    ELSE
      cRequired = "":U.
    
    /* Write the code out */
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "":U ).

    IF lRequired
    THEN DO:
      DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "~{&DB-REQUIRED-START~}").
    END.

    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE " + cName + " dTables " + cRequired).
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "PROCEDURE " + cName + " : ").
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "/*------------------------------------------------------------------------------").
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "  Purpose:     " + cPurpose).
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "  Parameters:  <none>").
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "  Notes:       ").
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "------------------------------------------------------------------------------*/").
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "":U ).
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "  DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.").
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "  DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.").
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "":U ).

    cReturnValue = "":U.
    
    IF pcValidationFields > "" THEN 
    DO:
       cReturnValue = DYNAMIC-FUNCTION(cFunction,INPUT pcTableNameList).
       DO iReturnLoop = 1 TO NUM-ENTRIES( cReturnValue , CHR(10) ) :
         DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT ENTRY( iReturnLoop , cReturnValue , CHR(10) ) ).
       END.
    END.

    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "":U ).
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "  ASSIGN").
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "    ERROR-STATUS:ERROR = NO.").
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "  RETURN cMessageList.").
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "":U ).
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "END PROCEDURE.").
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "":U ).
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "/* _UIB-CODE-BLOCK-END */").
    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "&ANALYZE-RESUME").
  
    IF lRequired
    THEN DO:
      DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "~{&DB-REQUIRED-END~}").
    END.

    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT "":U ).

  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scanLine) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scanLine Procedure 
PROCEDURE scanLine :
/*------------------------------------------------------------------------------
  Purpose:     ReplaceLine
  Notes:       Clears the first line containing the phrase and replaces it 
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcValue         AS CHARACTER    NO-UNDO.
  DEFINE INPUT        PARAMETER pcSearchFrom    AS CHARACTER    NO-UNDO.
  DEFINE INPUT        PARAMETER pcSearchUpTo    AS CHARACTER    NO-UNDO.
  DEFINE INPUT        PARAMETER plReplace       AS LOGICAL      NO-UNDO.
  DEFINE INPUT        PARAMETER pcReplaceWith   AS CHARACTER    NO-UNDO.
  DEFINE       OUTPUT PARAMETER plStringFound   AS LOGICAL      NO-UNDO.

  DEFINE VARIABLE iStringStart                  AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iStringEnd                    AS INTEGER      NO-UNDO.
  

  DEFINE VARIABLE pcReplaceThis                 AS CHARACTER    NO-UNDO.

  ASSIGN
    iStringStart =   INDEX(pcValue,pcSearchFrom)
    iStringEnd   = R-INDEX(pcValue,pcSearchUpTo)
    .

  IF iStringEnd <> 0
  THEN
    ASSIGN
      iStringEnd = iStringEnd + LENGTH(pcSearchUpTo)
      .

  IF iStringStart <> 0
  AND iStringEnd  <> 0
  THEN DO:

    ASSIGN
      plStringFound = YES.

    IF plReplace
    THEN
      ASSIGN
        pcReplaceThis = SUBSTRING(pcValue,iStringStart,iStringEnd - iStringStart)
        pcValue       = REPLACE(pcValue,pcReplaceThis,pcReplaceWith)
        NO-ERROR.

  END.
  ELSE DO:

    ASSIGN
      plStringFound = NO.

  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addDataLogicProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addDataLogicProcedure Procedure 
FUNCTION addDataLogicProcedure RETURNS LOGICAL
    ( INPUT pcValue     AS CHARACTER
    ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLine AS INTEGER    NO-UNDO.

  DEFINE BUFFER ttDLProc      FOR ttDLProc.

  FIND LAST ttDLProc
    NO-ERROR.
  IF AVAILABLE ttDLProc
  THEN
    ASSIGN
      iLine  = ttDLProc.ttfLine + 1.
  ELSE
    ASSIGN
      iLine = 1.

  blkAddDataLogicProc:
  REPEAT:

    FIND FIRST ttDLProc
      WHERE ttDLProc.ttfLine = iLine
      NO-ERROR.
    IF AVAILABLE ttDLProc
    THEN DO:
      ASSIGN
        iLine = iLine + 1.
        NEXT blkAddDataLogicProc.
    END.
    ELSE DO:

      CREATE ttDLProc.
      ASSIGN
        ttDLProc.ttfLine   = iLine
        ttDLProc.ttfValue  = pcValue
        .
      LEAVE blkAddDataLogicProc.

    END.
 
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addDataLogicTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addDataLogicTemplate Procedure 
FUNCTION addDataLogicTemplate RETURNS LOGICAL
    ( INPUT pcValue     AS CHARACTER
    ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLine AS INTEGER    NO-UNDO.

  DEFINE BUFFER ttTemplate      FOR ttTemplate.

  FIND LAST ttTemplate
    NO-ERROR.
  IF AVAILABLE ttTemplate
  THEN
    ASSIGN
      iLine  = ttTemplate.ttfLine + 1.
  ELSE
    ASSIGN
      iLine = 1.

  blkAddDataLogicProc:
  REPEAT:

    FIND FIRST ttTemplate
      WHERE ttTemplate.ttfLine = iLine
      NO-ERROR.
    IF AVAILABLE ttTemplate
    THEN DO:
      ASSIGN
        iLine = iLine + 1.
        NEXT blkAddDataLogicProc.
    END.
    ELSE DO:

      CREATE ttTemplate.
      ASSIGN
        ttTemplate.ttfLine   = iLine
        ttTemplate.ttfValue  = pcValue
        .
      LEAVE blkAddDataLogicProc.

    END.
 
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildCreatePreTransValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildCreatePreTransValidate Procedure 
FUNCTION buildCreatePreTransValidate RETURNS CHARACTER
    ( INPUT pcTable         AS CHARACTER   ):
/*------------------------------------------------------------------------------
  Purpose:  To create the CreatePreTransValidate Routine
    Notes:  pcTable can be a string of tables. Construct for reach table.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cIndexInformation           AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cIndexField                 AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cClauseFields               AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cClauseString               AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cClause                     AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cFieldList                  AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cValueList                  AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE hKeyBuffer                  AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
  DEFINE VARIABLE iCnt                        AS INTEGER              NO-UNDO.
  DEFINE VARIABLE iTable                      AS INTEGER              NO-UNDO.
  DEFINE VARIABLE cTable                      AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cSDOFieldList               AS CHARACTER            NO-UNDO.


  ASSIGN
     iCnt              = 0
     iLoop             = 0
     cIndexInformation = "":U
     cClauseString     = "":U
     cClauseFields     = "":U
     cFieldList        = "":U
     cValueList        = "":U
     .

  DO iTable = 1 to NUM-ENTRIES(pcTable):
      ASSIGN cTable        = ENTRY(iTable,pcTable)
             cTable        = SUBSTRING(cTable,1,28) /* Buffer is defined with max 28 chars (4 char prefix) due to 32 char limit */
             cSDOFieldList = ENTRY(iTable,pcFieldList,CHR(1)) NO-ERROR.

      FIND FIRST gsc_entity_mnemonic NO-LOCK
        WHERE gsc_entity_mnemonic.entity_mnemonic_description = IF NUM-ENTRIES(cTable,".") = 2 
                                                                THEN ENTRY(2,cTable,".")
                                                                ELSE cTable
        NO-ERROR.

      /* Create buffer for passed in table */
      CREATE BUFFER hKeyBuffer FOR TABLE TRIM(cTable) NO-ERROR.
      IF NOT VALID-HANDLE(hKeyBuffer) THEN
         NEXT.

      find-index-loop:
      REPEAT WHILE cIndexInformation <> ?:
        ASSIGN
          iLoop             = iLoop + 1
          cIndexInformation = hKeyBuffer:INDEX-INFORMATION(iLoop)
          cClauseFields     = "":U
          cFieldList        = "":U
          cValueList        = "":U
          NO-ERROR.
        IF cIndexInformation = ? THEN
           LEAVE.
                
        IF ENTRY(2,cIndexInformation) = "1":U
        THEN DO:
           DO iCnt = 5 TO NUM-ENTRIES(cIndexInformation) BY 2:
              ASSIGN cIndexField = TRIM(ENTRY(iCnt, cIndexInformation)).

              IF AVAILABLE gsc_entity_mnemonic
                 AND gsc_entity_mnemonic.table_has_object_field    
                 AND gsc_entity_mnemonic.entity_object_field <> ""
              THEN DO:
                 IF cIndexField = gsc_entity_mnemonic.entity_object_field
                 THEN NEXT find-index-loop.
              END.    /* available entity */
              ELSE DO:
                 IF LENGTH(cIndexField) > 4
                 THEN
                   IF  SUBSTRING(cIndexField,LENGTH(cIndexField) - 3)   = "_obj":U
                   AND SUBSTRING(cIndexField,1,LENGTH(cIndexField) - 4) = SUBSTRING(cTable,5)
                   THEN NEXT find-index-loop.
              END.    /* n/a entity */
              
            /* Test if index field is contained in valid list */
            IF cSDOFieldList > "" AND  LOOKUP(cIndexField,cSDOFieldList) = 0 THEN
                NEXT find-index-loop.
                
              IF LOOKUP(cIndexField,cClauseFields) = 0
              THEN DO:
                 ASSIGN
                   cClause       = IF iCnt = 5 THEN "              WHERE " ELSE CHR(10) + "                AND "
                   cFieldList    = cFieldList + cIndexField + ", ":U
                   cValueList    = cValueList + " + ', ' + " WHEN cValueList <> "":U
                   cValueList    = cValueList + "STRING(b_":U + cTable + ".":U + cIndexField + ")":U
                   cClauseFields = cClauseFields + cClause + cTable + ".":U + cIndexField + " = b_":U + cTable + ".":U + cIndexField
                   .
              END.    /* index not in clause */
           END.    /* loop through index information */

           ASSIGN cClauseFields = SUBSTITUTE( "  IF CAN-FIND(FIRST &1 ":U
                                      + CHR(10)
                                      + cClauseFields
                                      + ") THEN":U
                                      + CHR(10)
                                      + "  DO:":U
                                      + CHR(10)
                                      + "     ASSIGN cValueList   = "
                                      + cValueList
                                      + CHR(10)
                                      + "            cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) "
                                      + CHR(10)
                                      + "                         + ~{aferrortxt.i 'AF' '8' '&1' '' ""'&2'"" cValueList ~}."
                                      + CHR(10)
                                      + "  END."
                                      + CHR(10)
                                      ,cTable
                                      ,cFieldList
                                      )
                  cClauseString = cClauseString + (IF cClauseString <> "":U THEN CHR(10) ELSE "":U) + cClauseFields + CHR(10)
                  cClauseFields = "":U
                  NO-ERROR.
        END.    /* entry 2 of index information is 1 */
      END.    /* loop through indexes */

      DELETE OBJECT hKeyBuffer.
      ASSIGN hKeyBuffer = ?.
  END.

  RETURN cClauseString.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildRowObjectValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildRowObjectValidate Procedure 
FUNCTION buildRowObjectValidate RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  To create the RowObjectValidate Routine 
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cField              AS CHARACTER                        NO-UNDO.
  DEFINE VARIABLE cLabel              AS CHARACTER                        NO-UNDO.
  DEFINE VARIABLE cData               AS CHARACTER                        NO-UNDO.
  DEFINE VARIABLE cConvert            AS CHARACTER                        NO-UNDO.
  DEFINE VARIABLE cCompare            AS CHARACTER                        NO-UNDO.
  DEFINE VARIABLE cCompar2            AS CHARACTER                        NO-UNDO.
  DEFINE VARIABLE iLoop               AS INTEGER                          NO-UNDO.
  DEFINE VARIABLE cValidate           AS CHARACTER                        NO-UNDO.
  DEFINE VARIABLE iTable              AS INTEGER                          NO-UNDO.
  DEFINE VARIABLE cTable              AS CHARACTER                        NO-UNDO.
  DEFINE VARIABLE cValidationFields   AS CHARACTER            NO-UNDO.

  DO iTable = 1 to NUM-ENTRIES(pcTable):
      ASSIGN cTable            = ENTRY(iTable,pcTable)
             cTable            = SUBSTRING(cTable,1,28) /* Buffer is defined with max 28 chars (4 char prefix) due to 32 char limit */
             cValidationFields = ENTRY(iTable,pcValidationFields,CHR(1)) NO-ERROR.

      FIND FIRST gsc_entity_mnemonic NO-LOCK
        WHERE gsc_entity_mnemonic.entity_mnemonic_description = IF NUM-ENTRIES(cTable,".") = 2 
                                                                THEN ENTRY(2,cTable,".")
                                                                ELSE cTable  NO-ERROR.
      FIELD-LOOP:
      DO iLoop = 1 TO NUM-ENTRIES(cValidationFields,CHR(2)) BY 3:
        ASSIGN
          cField = ENTRY(iLoop    ,cValidationFields,CHR(2))
          cData  = ENTRY(iLoop + 1,cValidationFields,CHR(2))
          cLabel = ENTRY(iLoop + 2,cValidationFields,CHR(2))
          .

        IF  AVAILABLE gsc_entity_mnemonic
            AND gsc_entity_mnemonic.table_has_object_field
            AND gsc_entity_mnemonic.entity_object_field <> ""
        THEN DO:
          IF cField = gsc_entity_mnemonic.entity_object_field
          THEN NEXT field-loop.
        END.
        ELSE DO:
          IF LENGTH(cField) > 4
          AND SUBSTRING(cField,LENGTH(cField) - 3)   = "_obj":U
          AND SUBSTRING(cField,1,LENGTH(cField) - 4) = SUBSTRING(cTable,5)
          THEN NEXT field-loop.
        END.
        
        CASE cData:
          WHEN "character":U  THEN
            ASSIGN cConvert = "isFieldBlank(":U
                   cCompare = ")":U
                   cCompar2 = "":U
                   .
          WHEN "date":U OR WHEN "datetime":U OR WHEN "datetime-tz":U THEN
            ASSIGN cConvert = "":U
                   cCompare = " = ?":U
                   cCompar2 = "":U
                   .
          WHEN "logical":U THEN
            ASSIGN cConvert = "":U
                   cCompare = " = ?":U
                   cCompar2 = "":U
                   .
          OTHERWISE
            ASSIGN cConvert = "":U
                   cCompare = " = 0":U
                   cCompar2 = " = ?":U
                   .
        END CASE.

        ASSIGN
          cValidate = cValidate
                    + IF cCompar2 = "":U
                      THEN
                        SUBSTITUTE( "  IF &4b_&1.&2&5 THEN":U
                                  + CHR(10)
                                  + "    ASSIGN"
                                  + CHR(10)
                                  + "      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + "
                                  + CHR(10)
                                  + "                    ~{aferrortxt.i 'AF' '1' '&1' '&2' ""'&3'""~}."
                                  + CHR(10)
                                  + CHR(10)
                                  ,cTable
                                  ,cField
                                  ,cLabel
                                  ,cConvert
                                  ,cCompare
                                  ,cCompar2
                                  )
                      ELSE
                        SUBSTITUTE( "  IF &4b_&1.&2&5 OR &4b_&1.&2&6 THEN":U
                                  + CHR(10)
                                  + "    ASSIGN"
                                  + CHR(10)
                                  + "      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + "
                                  + CHR(10)
                                  + "                    ~{aferrortxt.i 'AF' '1' '&1' '&2' ""'&3'""~}."
                                  + CHR(10)
                                  + CHR(10)
                                  ,cTable
                                  ,cField
                                  ,cLabel
                                  ,cConvert
                                  ,cCompare
                                  ,cCompar2
                                  ).
      END.
  END.
  RETURN cValidate.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildWritePreTransValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildWritePreTransValidate Procedure 
FUNCTION buildWritePreTransValidate RETURNS CHARACTER
    ( INPUT pcTable         AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  To create the WritePreTransValidate Routine
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cIndexInformation           AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cIndexField                 AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cClauseFields               AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cClauseString               AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cClause                     AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cFieldList                  AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cValueList                  AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE hKeyBuffer                  AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
  DEFINE VARIABLE iCnt                        AS INTEGER              NO-UNDO.
  DEFINE VARIABLE iTable                      AS INTEGER              NO-UNDO.
  DEFINE VARIABLE cTable                      AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cSDOFieldList               AS CHARACTER            NO-UNDO.  

  ASSIGN
     iLoop             = 0
     iCnt              = 0
     cIndexInformation = "":U
     cClauseString     = "":U
     cClauseFields     = "":U
     cFieldList        = "":U
     cValueList        = "":U
     .

  DO iTable = 1 to NUM-ENTRIES(pcTable):
      ASSIGN cTable        = ENTRY(iTable,pcTable)
             cTable        = SUBSTRING(cTable,1,28) /* Buffer can have max 28 chars (4 char prefix) due to 32 char limit */
             cSDOFieldList = ENTRY(iTable,pcFieldList,CHR(1)) NO-ERROR.
             
      FIND FIRST gsc_entity_mnemonic NO-LOCK
        WHERE gsc_entity_mnemonic.entity_mnemonic_description = IF NUM-ENTRIES(cTable,".") = 2 
                                                                THEN ENTRY(2,cTable,".")  ELSE cTable   
                                                                NO-ERROR.

      /* Create buffer for passed in table */
      CREATE BUFFER hKeyBuffer FOR TABLE TRIM(cTable) NO-ERROR.
      IF NOT VALID-HANDLE(hKeyBuffer) THEN
         NEXT.


      find-index-loop:
      REPEAT WHILE cIndexInformation <> ?:

        ASSIGN
          iLoop             = iLoop + 1
          cIndexInformation = hKeyBuffer:INDEX-INFORMATION(iLoop)
          cFieldList        = "":U
          cValueList        = "":U
          cClauseFields     = "":U
          .

        IF ENTRY(2,cIndexInformation) = "1":U
        THEN DO:

          DO iCnt = 5 TO NUM-ENTRIES(cIndexInformation) BY 2:

            ASSIGN cIndexField = TRIM(ENTRY(iCnt, cIndexInformation)).

            IF  AVAILABLE gsc_entity_mnemonic
                AND gsc_entity_mnemonic.table_has_object_field 
                AND gsc_entity_mnemonic.entity_object_field <> ""
            THEN DO:
              IF cIndexField = gsc_entity_mnemonic.entity_object_field
              THEN NEXT find-index-loop.
            END.
            ELSE DO:
              IF LENGTH(cIndexField) > 4
              THEN
                IF SUBSTRING(cIndexField,LENGTH(cIndexField) - 3) = "_obj":U
                AND SUBSTRING(cIndexField,1,LENGTH(cIndexField) - 4) = SUBSTRING(cTable,5)
                THEN NEXT find-index-loop.
            END.
            /* Test if index field is contained in valid list */
            IF cSDOFieldList > "" AND  LOOKUP(cIndexField,cSDOFieldList) = 0 THEN
                NEXT find-index-loop.
                
                
            IF LOOKUP(cIndexField,cClauseFields) = 0
            THEN DO:
              ASSIGN
                cClause       = IF iCnt = 5 THEN "              WHERE " ELSE CHR(10) + "                AND "
                cFieldList    = cFieldList + cIndexField + ", ":U
                cValueList    = cValueList + " + ', ' + " WHEN cValueList <> "":U
                cValueList    = cValueList + "STRING(b_":U + cTable + ".":U + cIndexField + ")":U
                cClauseFields = cClauseFields + cClause + cTable + ".":U + cIndexField + " = b_":U + cTable + ".":U + cIndexField.
            END.
          END.
          
          ASSIGN
            cClauseFields = SUBSTITUTE( "  IF NOT isCreate() AND CAN-FIND(FIRST &1 ":U
                                      + CHR(10)
                                      + cClauseFields
                                      + CHR(10)
                                      + "                AND ROWID(&1) <> TO-ROWID(ENTRY(1,b_":U + cTable + ".RowIDent))) THEN":U
                                      + CHR(10)
                                      + "  DO:":U
                                      + CHR(10)
                                      + "     ASSIGN cValueList   = " + cValueList
                                      + CHR(10)
                                      + "            cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U)  "
                                      + CHR(10)
                                      + "                         + ~{aferrortxt.i 'AF' '8' '&1' '' ""'&2'"" cValueList ~}."
                                      + CHR(10)
                                      + "  END."
                                      + CHR(10)
                                      ,cTable
                                      ,cFieldList
                                      )
            cClauseString = cClauseString + CHR(10) WHEN cClauseString <> "":U
            cClauseString = cClauseString + cClauseFields + CHR(10)
            cClauseFields = "":U
            .
        END.

      END.

      DELETE OBJECT hKeyBuffer.
      ASSIGN
        hKeyBuffer = ?.
  END.
  RETURN cClauseString.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

