&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
  File: afgenSBOlogp.p

  Description:  Generate SBO DataLogic Procedure

  Purpose:      Generate SBO DataLogic Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/04/2002  Author: 

  Update Notes: Created from Template rytemplipp.p

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgensbologp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

DEFINE INPUT PARAMETER pcLogicProcedureFile         AS CHARACTER            NO-UNDO.    /* Rel pathed file name eg. ry/obj/rycsologcp.p */
DEFINE INPUT PARAMETER pcRootFolder                 AS CHARACTER            NO-UNDO.    /* eg. c:/posse/work/ . Will have the  / at the end. */
DEFINE INPUT PARAMETER pcLogicProcedureTemplate     AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcTableNameList              AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcDefIncludeNameList         AS CHARACTER            NO-UNDO.    /* eg. ry/obj/rycsofullo.i */
DEFINE INPUT PARAMETER plCreateMissingFolder        AS LOGICAL              NO-UNDO.

{src/adm2/globals.i }


DEFIN STREAM sFile.

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
  DEFINE VARIABLE cCreateFolder               AS CHARACTER  NO-UNDO.

  EMPTY TEMP-TABLE ttTemplate.
  EMPTY TEMP-TABLE ttDLProc.
  
  RUN createDataLogicProcedure.

  IF pcRootFolder EQ "/":U OR pcRootFolder EQ "~\":U
  THEN 
    ASSIGN cFullyPathedProcedure = pcLogicProcedureFile.
  ELSE
    ASSIGN cFullyPathedProcedure = pcRootFolder + pcLogicProcedureFile
           cFullyPathedProcedure = REPLACE(cFullyPathedProcedure,"~\","/").

  IF NUM-ENTRIES(cFullyPathedProcedure,"/":U) > 1 THEN  
       ASSIGN cCreateFolder = SUBSTRING(cFullyPathedProcedure,1,R-INDEX(cFullyPathedProcedure,"/") - 1) .
    ELSE   
     ASSIGN cCreateFolder =  pcRootFolder.

  ASSIGN FILE-INFO:FILE-NAME = cCreateFolder.
  

  IF FILE-INFO:FULL-PATHNAME EQ ? THEN 
  DO:
    IF plCreateMissingFolder THEN 
    DO:
      IF NOT DYNAMIC-FUNCTION("createFolder":U IN gshGenManager, INPUT cCreateFolder) THEN
        RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'unable to create folder: ' + pcRootFolder"}.
    END.    /* create the folder */
    ELSE
      RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'folder does not exist: ' + pcRootFolder"}.
  END.    /* folder doesn't exist */

  /* Output the Data Logic Procedure */
  OUTPUT STREAM sFile TO VALUE(cFullyPathedProcedure).

  FOR EACH ttDLProc BY ttDLProc.ttfLine:
    IF ttDLProc.ttfValue <> "":U
    THEN
      PUT STREAM sFile UNFORMATTED ttDLProc.ttfValue SKIP .
    ELSE
      PUT STREAM sFile " ":U SKIP .

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
  Purpose:     Parses template file and adds required sections
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
  DEFINE VARIABLE lReplaceFileName            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lReplaceTableName           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lReplaceObjectName          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSearchDefinition           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iTables                     AS INTEGER    NO-UNDO.
  
  ASSIGN
    lReplaceFileName             = NO
    lReplaceTableName            = NO
    lReplaceObjectName           = NO
    cDataLogicProcedureTemplate  = SEARCH(pcLogicProcedureTemplate).

  IF cDataLogicProcedureTemplate <> ? AND cDataLogicProcedureTemplate <> "":U THEN 
  DO:
    ASSIGN cDataLogicProcedureTemplate = REPLACE(cDataLogicProcedureTemplate,"~\":U,"~/":U).
    INPUT STREAM sFile FROM VALUE(cDataLogicProcedureTemplate).
    /* Build the temp table which contains each line of the tmeplate include file */
    REPEAT:
      IMPORT STREAM sFile UNFORMATTED
        cLineValue.
      /* Write the line to the temp-table */
      DYNAMIC-FUNCTION("addDataLogicTemplate", INPUT cLineValue).
    END.
    INPUT STREAM sFile CLOSE.
  END.
  ELSE
    RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "'the Data Logic Procedure Template'" 'pcLogicProcedureTemplate'}.

    
  blkTemplate:
  FOR EACH ttTemplate NO-LOCK:
    ASSIGN cLineValue = ttTemplate.ttfValue.
    IF NOT lReplaceFileName THEN 
    DO:
      RUN scanLine (INPUT-OUTPUT cLineValue
                   ,INPUT        "File: rytemsbologic.p"
                   ,INPUT        ".p"
                   ,INPUT        YES
                   ,INPUT        "File: " + ENTRY(NUM-ENTRIES(pcLogicProcedureFile,"/":U),pcLogicProcedureFile,"/":U)
                   ,OUTPUT       lReplaceFileName
                   ).
      IF lReplaceFileName THEN 
      DO:
        DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT cLineValue).
        NEXT blkTemplate.
      END.
    END.

    
    IF NOT lReplaceTableName THEN 
    DO:
      RUN scanLine (INPUT-OUTPUT cLineValue
                   ,INPUT        "data-"
                   ,INPUT        "logic"
                   ,INPUT        YES
                   ,INPUT        pcTableNameList
                   ,OUTPUT       lReplaceTableName
                   ).
      IF lReplaceTableName THEN 
      DO:
        DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT cLineValue).
        NEXT blkTemplate.
      END.
    END.

    IF NOT lReplaceObjectName THEN 
    DO:
      RUN scanLine (INPUT-OUTPUT cLineValue
                   ,INPUT        "&scop object-name"
                   ,INPUT        ".p"
                   ,INPUT        YES
                   ,INPUT        "&scop object-name       " + ENTRY(NUM-ENTRIES(pcLogicProcedureFile,"/":U),pcLogicProcedureFile,"/":U)
                   ,OUTPUT       lReplaceObjectName
                   ).
      IF lReplaceObjectName THEN 
      DO:
        DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT cLineValue).
        NEXT blkTemplate.
      END.
    END.

    
    ASSIGN lSearchDefinition = NO.
    RUN scanLine (INPUT-OUTPUT cLineValue
                 ,INPUT        "/* Data Preprocessor Definitions */":U
                 ,INPUT        "/* Data Preprocessor Definitions */":U
                 ,INPUT        NO
                 ,INPUT        "":U
                 ,OUTPUT       lSearchDefinition
                 ).
    IF lSearchDefinition THEN 
    DO:
      DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT cLineValue).
      DO iTables = 1 TO NUM-ENTRIES(pcTableNameList):
         ASSIGN cLineValue = "&SCOPED-DEFINE UpdTable":U + STRING(iTables) + ' ' + ENTRY(iTables,pcTableNameList).
         DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT cLineValue).
         ASSIGN cLineValue = "&SCOPED-DEFINE SDOInclude":U + STRING(iTables) + ' "':U + ENTRY(iTables,pcDefIncludeNameList) + '"'.
         DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT cLineValue).
      END.
      NEXT blkTemplate.

    END. /* lSearchDefinition */

    DYNAMIC-FUNCTION("addDataLogicProcedure", INPUT cLineValue).

  END. /* EACH ttTemplate */

  
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

  DEFINE VARIABLE iStringStart   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iStringEnd     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iStringLength  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cReplaceThis   AS CHARACTER NO-UNDO.

  ASSIGN
    iStringStart  =  INDEX(pcValue,pcSearchFrom)
    iStringEnd    =  IF iStringStart > 0 THEN INDEX(pcValue,pcSearchUpTo,iStringStart) ELSE 0
    iStringLength = iStringEnd - iStringStart + LENGTH(pcSearchUpTo) NO-ERROR.

  IF iStringStart <> 0 AND iStringEnd  <> 0 THEN 
  DO:
    ASSIGN plStringFound = YES.

    IF plReplace THEN
      ASSIGN
        cReplaceThis = SUBSTRING(pcValue,iStringStart,iStringlength)
        pcValue       = REPLACE(pcValue,cReplaceThis,pcReplaceWith)
        .
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

