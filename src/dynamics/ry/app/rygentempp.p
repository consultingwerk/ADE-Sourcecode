&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/*************************************************************/  
/* Copyright (c) 1984-2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* Update Version Notes Wizard
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
  File: rygentempp.p

  Description:  Static Object Generation Procedure

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/15/2004  Author:     

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rygentempp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

define temp-table ttTemplate    no-undo
    field LineNumber            as integer
    field LineContent           as character
    field HasChildren           as logical
    field NumberOfChildren      as integer
    index idxMain
        LineNumber
    index idxChildren
        HasChildren.

define temp-table ttInsert     no-undo like ttTemplate
    field ParentLineNumber     as integer
    field ParentRowid          as rowid
    index idxParent
        ParentLineNumber.

define temp-table ttOutput    no-undo
    field LineNumber        as integer
    field LineContent       as character
    index idxMain
        LineNumber.

define temp-table ttContext    no-undo
    field Token        as character
    field TokenValue   as character
    index idxMain    as unique
        Token.

define temp-table ttLoop no-undo
    field LoopName        as character
    field Iteration       as integer 
    field StartLine       as integer
    field EndLine         as integer
    index idxLoop as unique
        LoopName.

define variable giOutputLineNumber          as integer          no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-calculateBlockSize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD calculateBlockSize Procedure 
FUNCTION calculateBlockSize RETURNS INTEGER
  ( input pcBlockType        as character,
    input piLineNumber       as integer     )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD clearContext Procedure 
FUNCTION clearContext RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createFolder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createFolder Procedure 
FUNCTION createFolder RETURNS LOGICAL
    ( INPUT pcFolderName       AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createOutputLine) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createOutputLine Procedure 
FUNCTION createOutputLine RETURNS LOGICAL
  ( input pcLineContent   as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyGenerator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyGenerator Procedure 
FUNCTION destroyGenerator RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dumpTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dumpTemplate Procedure 
FUNCTION dumpTemplate RETURNS LOGICAL PRIVATE
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-eitherTranslationOrSecurityEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD eitherTranslationOrSecurityEnabled Procedure 
FUNCTION eitherTranslationOrSecurityEnabled RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFirstInstructionSet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFirstInstructionSet Procedure 
FUNCTION getFirstInstructionSet RETURNS CHARACTER
  ( input pcString        as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTokenValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTokenValue Procedure 
FUNCTION getTokenValue RETURNS CHARACTER
  ( INPUT pcInstruction AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-includeTemplates) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD includeTemplates Procedure 
FUNCTION includeTemplates RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeGenerator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initializeGenerator Procedure 
FUNCTION initializeGenerator RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeOutputTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initializeOutputTable Procedure 
FUNCTION initializeOutputTable RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processInstructionEvery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processInstructionEvery Procedure 
FUNCTION processInstructionEvery RETURNS INTEGER
  ( input piLineNumber            as integer,
      input pcInstructionValue            as character,
      input piLoopIteration         as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processInstructionIf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processInstructionIf Procedure 
FUNCTION processInstructionIf RETURNS INTEGER
  ( input piLineNumber            as integer,
    input pcInstructionValue      as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processInstructionLoop) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processInstructionLoop Procedure 
FUNCTION processInstructionLoop RETURNS INTEGER
  ( input piLineNumber            as integer,
    input pcInstructionValue      as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processInstructionToken) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processInstructionToken Procedure 
FUNCTION processInstructionToken RETURNS logical
  ( input pcLineContent      as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoopIteration) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoopIteration Procedure 
FUNCTION processLoopIteration RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processTemplate Procedure 
FUNCTION processTemplate RETURNS LOGICAL
  ( input piStartLine        as integer,
    input piEndLine          as integer,
    input piLoopIteration    as integer  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resolveInstructionValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resolveInstructionValue Procedure 
FUNCTION resolveInstructionValue RETURNS CHARACTER
        ( input pcInstructionValue        as character  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTokenValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTokenValue Procedure 
FUNCTION setTokenValue RETURNS LOGICAL
  ( input pcInstruction as character,
     input pcValue as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addHookProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addHookProcedure Procedure 
PROCEDURE addHookProcedure :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcHookFilename            as character            no-undo.
    
    define variable hSuper             as handle                             no-undo.
        
    if pcHookFilename eq ? or pcHookFilename eq '':u then
        return error ('Invalid hook procedure specified':u).
    
    pcHookFilename = search(pcHookFilename).
    if pcHookFilename eq ? or pcHookFilename eq '' then
        return error ('Hook procedure could not be found ' + pcHookFilename).
    
    do on stop undo, leave:    
        run value(pcHookFilename) persistent set hSuper.
    end.    /* stop block */
    if valid-handle(hSuper) then
        this-procedure:add-super-procedure(hSuper, search-target).
    else
        return error ('Unable to start hook procedure ' + pcHookFilename).
    
    error-status:error = no.
    return.
end procedure.    /* addHookProcedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateObject Procedure 
PROCEDURE generateObject :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
     Purpose: 
  Parameters: pcObject - the name of the obejct to generate
              pcTemplateFilename - the template to use
              pcHookFilename - the hook procedure for the generation process
              pcLanguages - * or CSV list of languages
              pcResultCodes - a CSV list of codes; at least DEFAULT-RESULT-CODE needed
              pcSuperProcedureLocation - Inline,Property,Constructor
              pcGeneratedFileRoot - the root directory for generation
              pcOptions - GenerateTranslations, GenerateSecurity,ThinRendering
              pcGeneratedObjectName - the name of the generated file
       Notes: 
------------------------------------------------------------------------------*/
    define input  parameter pcObject                    as character           no-undo.
    define input  parameter pcTemplateFilename          as character           no-undo.
    define input  parameter pcHookFilename              as character           no-undo.
    define input  parameter pcLanguages                 as character           no-undo.
    define input  parameter pcResultCodes               as character           no-undo.
    define input  parameter pcSuperProcedureLocation    as character           no-undo.
    define input  parameter pcGeneratedFileRoot         as character           no-undo.
    define input  parameter pcOptions                   as character           no-undo.
    define output parameter pcGeneratedObjectName       as character           no-undo.
    
    define variable lOk                   as logical                           no-undo.
    
    /* Start the super chain first since there may be 
       overrides for the setters and getters in the super(s).
     */
    run addHookProcedure in target-procedure (input pcHookFilename) no-error.
    if error-status:error or return-value ne '' then
        return error return-value.
    
    /* Add processing here that needs to happen before anything else,
       such as clearing of temp-tables etc.
     */
    lOk = dynamic-function('initializeGenerator' in target-procedure).
    if not lOk then
        return error 'Generator initialization failed.'.
    
    /* Initialize Token Values */
    dynamic-function('setTokenValue' in target-procedure, 'ObjectName', pcObject).
    dynamic-function('setTokenValue' in target-procedure, 'TemplateFileName', pcTemplateFilename).
    dynamic-function('setTokenValue' in target-procedure, 'HookFileName', pcHookFilename).
    dynamic-function('setTokenValue' in target-procedure, 'GenerateOptions', pcOptions).
    dynamic-function('setTokenValue' in target-procedure, 'GenerateResultCodes', pcResultCodes).
    dynamic-function('setTokenValue' in target-procedure, 'GenerateLanguages', pcLanguages).
    dynamic-function('setTokenValue' in target-procedure, 'GenerateFileRoot', pcGeneratedFileRoot).
    
    /* Set options */
    /* ALWAYS generate security */
    dynamic-function('setTokenValue' in target-procedure, 'GenerateSecurity', True).
    dynamic-function('setTokenValue' in target-procedure,
                     'GenerateTranslations', can-do(pcOptions, 'GenerateTranslations')).
    dynamic-function('setTokenValue' in target-procedure,
                     'GenerateThinRendering', can-do(pcOptions, 'GenerateThinRendering')).    
    dynamic-function('setTokenValue' in target-procedure,
                     'GenerateSuperLocation', pcSuperProcedureLocation).
        
    /* run up the super chain and set all initial values.
       this is fun no-error since there may not be any initializeTokenValues()
       function up the super stack.    
     */
    lOk = dynamic-function('initializeTokenValues' in target-procedure) no-error.
    if not lOk then
        return error 'initializeTokenValues failed'.
            
    /* suck in all values, including all included templates */
    run loadTemplate in target-procedure (input pcTemplateFilename) no-error.
    if error-status:error or return-value ne '' then
        return error return-value.        
        
    /* DEBUG ONLY: uncommment this call to dump template for debug purposes.
    dynamic-function('dumpTemplate' in target-procedure).
    */
    
    lOk = dynamic-function('initializeOutputTable' in target-procedure).
    if not lOk then
        return error 'initializeOutputTable failed'.
    
    /* Read the template, process and create an output record. */
    lOk = dynamic-function('processTemplate' in target-procedure, ?, ?, ?).
    if not lOk then
        return error ('Processing of template ' + pcTemplateFilename + ' failed').
    
    run writeGeneratedObject in target-procedure. 
    if error-status:error or return-value ne '' then
        return error return-value.
    
    pcGeneratedObjectName = dynamic-function('getTokenValue' in target-procedure,
                                             'OutputFilename').
    
    /* Cleanup once done */
    lOk = dynamic-function('destroyGenerator' in target-procedure) no-error.
    if not lOk then
        return error 'Generator shutdown failed'.
    
    error-status:error = no.
    return.
end procedure.    /* generateObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadTemplate Procedure 
PROCEDURE loadTemplate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcTemplateFilename  as character            no-undo.

    define variable iLineNumber                as integer              no-undo.
    define variable cLineValue                 as character            no-undo.
    
    define buffer lbTemplate        for ttTemplate.
    
    pcTemplateFileName = search(pcTemplateFilename).
    if pcTemplateFileName eq ? or pcTemplateFileName eq '' then
        return error ('Unable to load template file ' + pcTemplateFilename).

    input from value(pcTemplateFilename).
    repeat:
        import unformatted cLineValue.
        
        create lbTemplate.
        assign iLineNumber = iLineNumber + 1
               lbTemplate.LineNumber = iLineNumber
               lbTemplate.LineContent = cLineValue
               lbTemplate.HasChildren = index(cLineValue, '##Include:') gt 0.
    end.    /* repeat */
    input close.
    
    /* Suck in all includes, including recorsive calls. */
    if can-find(first lbTemplate where lbTemplate.HasChildren) then
        dynamic-function('includeTemplates' in target-procedure).
    
    error-status:error = no.
    return.
end procedure.    /* loadTemplate */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseInstructionSet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE parseInstructionSet Procedure 
PROCEDURE parseInstructionSet :
/*------------------------------------------------------------------------------
 Purpose: Ensures the instruction has the format Type:Value. Also processes the 
                  function call and/or token.
   Notes: - Instruction Type is one of: Token, Include, Loop, If, Exclude, Every
          - This procedure doesn't do anything with the instruction value. that's the
            job of other procedures like processTemplate() and includeTemplates().
------------------------------------------------------------------------------*/
    define input  parameter pcInstruction             as character            no-undo.
    define output parameter pcInstructionType         as character            no-undo.
    define output parameter pcInstructionValue        as character            no-undo.
    
    define variable iStartPos                as integer                    no-undo.
    define variable iEndPos                  as integer                    no-undo.
    
    /* get rid of the token indicators */
    pcInstruction = trim(pcInstruction).
    pcInstruction = trim(pcInstruction, '##').
    
    /* If there's no instruction type, default to Token. 
       Don't use entry(, ':') because the instruction value itself
       may have colons, particularly when the instructio type is
       Include.
     */
    iStartPos = index(pcInstruction, ':').
    if iStartPos eq 0 then
        assign pcInstructionType = 'Token'
               pcInstructionValue = pcInstruction.
    else
        assign pcInstructionType = substring(pcInstruction, 1, iStartPos - 1)
               pcInstructionValue = substring(pcInstruction, iStartPos + 1).
    
    error-status:error = no.
    return.
end procedure.    /* parseInstructionSet */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeGeneratedObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeGeneratedObject Procedure 
PROCEDURE writeGeneratedObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define variable cOutputFilename            as character                no-undo.
    
    define buffer lbOutput        for ttOutput.
    
    cOutputFileName = dynamic-function('getTokenValue' in target-procedure, 'OutputFileName').

    output to value(cOutputFileName).
    for each lbOutput by lbOutput.LineNumber:
        if lbOutput.LineContent eq '' then
            put skip(1).
        else
            put unformatted lbOutput.LineContent SKIP.
    end.
    output close.
    
    error-status:error = no.
    return.
end procedure.    /* writeGeneratedObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-calculateBlockSize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION calculateBlockSize Procedure 
FUNCTION calculateBlockSize RETURNS INTEGER
  ( input pcBlockType        as character,
    input piLineNumber       as integer     ) :
/*------------------------------------------------------------------------------
 Purpose: Returns the number of rows that a given block type contains. This includes
              the outermost ##<block type>:## and ##<block type>:End## lines.
   Notes: 
------------------------------------------------------------------------------*/            
    define variable iBlockSize                 as integer            no-undo.
    define variable iNumberBlocks              as integer            no-undo.
    define variable cInstruction               as character          no-undo.
    define variable cInstructionType           as character          no-undo.
    define variable cInstructionValue          as character          no-undo.
    
    define variable cLineContent               as character          no-undo.
            
    define buffer lbTemplate            for ttTemplate.
    
    iNumberBlocks = 0.
    iBlockSize = 0.
    
    for each lbTemplate where
             lbTemplate.LineNumber >= piLineNumber
             by lbTemplate.LineNumber:
        
        iBlockSize = iBlockSize + 1.
        
        cInstruction = dynamic-function('getFirstInstructionSet' in target-procedure,
                                      lbTemplate.LineContent).
        if cInstruction eq '' then
            next.
        
        run parseInstructionSet in target-procedure (input  cInstruction,
                                                     output cInstructionType,
                                                     output cInstructionValue).
        
        /* Block indicators exist alone on a line, so if the
           token type is not the current block type, then we
           ignore any other tokens that may be on the line.           
         */
        if cInstructionType ne pcBlockType then
            next.
        
        /* at this stage all we are left with are Loop tokens. */
        if cInstructionValue eq 'End' then
            iNumberBlocks = iNumberBlocks - 1.
        else
            iNumberBlocks = iNumberBlocks + 1.
        
        /* we've found the End statement */
        if iNumberBlocks eq 0 then
            leave.
    end.    /* each template */
    
    /* If there is an error in the template's syntax, such as 
       a missing instruction block terminator ##<instruction>:End##,
       then returns a block size of zero.
     */
    if iNumberBlocks ne 0 then
        iBlockSize = ?.
    
    return iBlockSize.
end function.    /* calculateBlockSize */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION clearContext Procedure 
FUNCTION clearContext RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Clears out the context table
        Notes: - this is encapsulated in a function because the hook procedure may
                         deem it necessary to empty the context table for some reason.
------------------------------------------------------------------------------*/
    define variable lSuper            as logical                    no-undo.
    
    lSuper = Yes.
    
    lSuper = super() no-error.
    if lSuper eq ? then
        lSuper = Yes.
    
    empty temp-table ttContext.
    
    error-status:error = no.
    return (lSuper ne no).
END FUNCTION.    /* clearCOntext */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createFolder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createFolder Procedure 
FUNCTION createFolder RETURNS LOGICAL
    ( INPUT pcFolderName       AS CHARACTER ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Creates a folder, if it doesn't exist.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iErrorCode              AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cCompositePath          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cFolder                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iFolderCOunt            AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iCount                  AS INTEGER    INITIAL 1     NO-UNDO.

    ASSIGN pcFolderName        = REPLACE(pcFolderName, "~\":U, "/":U)
           FILE-INFO:FILE-NAME = pcFolderName.
           
    IF FILE-INFO:FULL-PATHNAME EQ ? THEN
    DO:
        IF pcFolderName BEGINS "//":U THEN  /* UNC path Check */
          ASSIGN cCompositePath = "//":U + ENTRY(3, pcFolderName, "/":U)
                 iCount         = 4.
        ELSE
          ASSIGN cCompositePath = "":U.

        DO iFolderCount = iCount TO NUM-ENTRIES(pcFolderName, "/":U).
            ASSIGN cFolder = ENTRY(iFolderCount, pcFolderName, "/":U).

            ASSIGN cCompositePath = cCompositePath + (IF NUM-ENTRIES(cCompositePath, "/":U) EQ 0 THEN "":U ELSE "/":U)
                                  + cFolder.

            ASSIGN FILE-INFO:FILE-NAME = cCompositePath.
            IF FILE-INFO:FULL-PATHNAME EQ ? THEN
            DO:
                OS-CREATE-DIR VALUE(cCompositePath).
                ASSIGN iErrorCode = OS-ERROR.
                IF iErrorCode NE 0 THEN
                    LEAVE.
            END.    /* need to create the folder */
        END.    /* folder count. */
    END.    /* folder doesn't exist */

    RETURN (iErrorCode EQ 0).
END FUNCTION.   /* createFolder */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createOutputLine) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createOutputLine Procedure 
FUNCTION createOutputLine RETURNS LOGICAL
  ( input pcLineContent   as character ) :
/*------------------------------------------------------------------------------
 Purpose: Creates a new output line record.
   Notes: - this function increments the line number.
------------------------------------------------------------------------------*/         
    define buffer lbOutput for ttOutput.
            
    create lbOutput.
    assign giOutputLineNumber   = giOutputLineNumber + 1
           lbOutput.LineNumber  = giOutputLineNumber
           lbOutput.LineContent = pcLineContent.
    
    return true.
end function.    /* createOutputLine */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyGenerator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyGenerator Procedure 
FUNCTION destroyGenerator RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
  Purpose: Cleanup on generator destruction
        Notes:
------------------------------------------------------------------------------*/
    define variable lSuper             as logical  initial ?     no-undo.
    define variable iLoop              as integer                no-undo.
    define variable hSuper             as handle                 no-undo.
    
    lSuper = super() no-error.
    if lSuper eq ? then
        lSuper = Yes.
    
    /* Remove all context. Do this via a function call since
       the context is available to the hook procedure, and it may
       want to clear the context at some other point.
     */
    dynamic-function('clearContext' in target-procedure).
    
    /**/
    empty temp-table ttTemplate.
    empty temp-table ttInsert.
    empty temp-table ttOutput.
    empty temp-table ttLoop.
    
    /* Kill any super procedures this object has.
     */
    do iLoop = 1 to num-entries(this-procedure:super-procedures):
        hSuper = widget-handle(entry(iLoop, this-procedure:super-procedures)) no-error.
        if valid-handle(hSuper) then
            delete object hSuper no-error.
        hSuper = ?.            
    end.    /* loop through supers */
    
    return (lSuper ne no).
END FUNCTION.    /* destroyGenerator */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dumpTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dumpTemplate Procedure 
FUNCTION dumpTemplate RETURNS LOGICAL PRIVATE
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Dumps the resolved template out to disk. For DEBUG purposes only.
        Notes: * this function doesn't run by default, it needs to be commented in
                         to execute. it is run from generateObject.
------------------------------------------------------------------------------*/    
    output to value(session:temp-directory + '/template_dump.out').
    
    for each ttTemplate by ttTemplate.LineNumber:
        export ttTemplate.
    end.
    
    output close.
            
    error-status:error = no.
    return true.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-eitherTranslationOrSecurityEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION eitherTranslationOrSecurityEnabled Procedure 
FUNCTION eitherTranslationOrSecurityEnabled RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Returns whether one of translations or security is enabled.
        Notes:
------------------------------------------------------------------------------*/
    define variable lEitherEnabled            as logical            no-undo.
    define variable cValue                    as character          no-undo.
    
    lEitherEnabled = no.
    cValue = dynamic-function('getTokenValue' in target-procedure, 'GenerateSecurity').
    lEitherEnabled = logical(cValue) no-error.
    if lEitherEnabled eq ? then lEitherEnabled = yes.
    
    if not lEitherEnabled then
    do:
            cValue = dynamic-function('getTokenValue' in target-procedure, 'GenerateTranslations').
            lEitherEnabled = logical(cValue) no-error.
            if lEitherEnabled eq ? then lEitherEnabled = yes.
    end.    /* security not enabled */
    
    return lEitherEnabled.
END FUNCTION.    /* eitherTranslationOrSecurityEnabled */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFirstInstructionSet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFirstInstructionSet Procedure 
FUNCTION getFirstInstructionSet RETURNS CHARACTER
  ( input pcString        as character ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    define variable cInstruction  as character            no-undo.
    define variable cTempString   as character            no-undo.        
    define variable iPos          as integer              no-undo.
    
    cInstruction = ''.    
    iPos = index(pcString, '##').
    if iPos gt 0 then
    do:
            cTempString = substring(pcString, iPos).
            iPos = index(cTempString, '##', 3).
            cInstruction = substring(cTempString, 1, iPos + 1).
    end.    /* there are tokens */
    
    return cInstruction.        
end function.    /* getFirstInstructionSet */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTokenValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTokenValue Procedure 
FUNCTION getTokenValue RETURNS CHARACTER
  ( INPUT pcInstruction AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    define variable cInstructionValue            as character                no-undo.    
    
    cInstructionValue = dynamic-function(('getToken-' + pcInstruction) in TARGET-PROCEDURE) no-error.
    
    /* if the function doesn't exist, then get from context directly */    
    if error-status:get-number(1) eq 5639 then
    do:
        find ttContext where ttContext.Token = pcInstruction no-error.
        if available ttContext then
            cInstructionValue = ttContext.TokenValue.
        else
            cInstructionValue = ?.
    end.    /* no getter override available */
    
    error-status:error = no.
    return cInstructionValue.
end function.    /* getTokenValue */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-includeTemplates) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION includeTemplates Procedure 
FUNCTION includeTemplates RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
 Purpose: Sucks in all 'Include' files.
   Notes: 
------------------------------------------------------------------------------*/    
    define variable iLineNum              as integer                    no-undo.
    define variable iTotalLinesInserted   as integer                    no-undo.
    define variable iStartLine            as integer                    no-undo.
    define variable cLineValue            as character                  no-undo.
    define variable cIncludeFile          as character                  no-undo.
    define variable cInstruction          as character                  no-undo.
    define variable cInstructionType      as character                  no-undo.
    
    define buffer lbTemplate      for ttTemplate.
    define buffer moveTemplate    for ttTemplate.
    define buffer lbInsert        for ttInsert.
        
    empty temp-table ttInsert.
    
    /* import all templates. */
    for each lbTemplate where
             lbTemplate.HasChildren
             by lbTemplate.LineNumber:
        
        /* Get the instruction */
        cInstruction = dynamic-function('getFirstInstructionSet' in target-procedure,
                                        lbTemplate.LineContent).
        run parseInstructionSet in target-procedure (input  cInstruction,
                                                     output cInstructionType,
                                                     output cIncludeFile).
        cIncludeFile = dynamic-function('resolveInstructionValue' in target-procedure,
                                        cIncludeFile).                                                     
        
        /* make sure the token is an Include token. */
        if cInstructionType ne 'Include' then
            next.
        
        /* make sure the include file exists */
        cIncludeFile = search(cIncludeFile).
        if cIncludeFile eq ? or cIncludeFile eq '' then
        do:
            /* if the include doesn't exist, remove the HasChildren flag 
               to avoid multiple attempts to include this file.
             */
            lbTemplate.HasChildren = no.
            next.
        end.    /* couldn't find a file to include. */
        
        /* import it.
           replace existing line, move all others down. 
         */
        iLineNum = 0.
        input from value(cIncludeFile).
        repeat:
            import unformatted cLineValue.
            
            create lbInsert.
            assign iLineNum             = iLineNum + 1
                   lbInsert.LineNumber  = iLineNum
                   lbInsert.LineContent = cLineValue
                   lbInsert.HasChildren = index(cLineValue, '##Include:') gt 0
                   lbInsert.ParentRowid = rowid(lbTemplate).
        end.    /* input loop */
        input close.
        
        lbTemplate.NumberOfChildren = iLineNum.        
    end.    /* get all templates */
    
    for each ttInsert break by ttInsert.ParentRowid:
        if first-of(ttInsert.ParentRowid) then
        do:
            find lbTemplate where rowid(lbTemplate) = ttInsert.ParentRowid.
            iStartLine = lbTemplate.LineNumber + 1.
            iTotalLinesInserted = lbTemplate.NumberOfChildren.
            
            /* use preselect because we're messing with a unique index value. */
            repeat preselect
                each lbTemplate where
                     lbTemplate.LineNumber ge iStartLine
                     by lbTemplate.LineNumber descending:
                
                find next lbTemplate.
                lbTemplate.LineNumber = lbTemplate.LineNumber + iTotalLinesInserted.
            end.    /* preselect */
        end.    /* first-of parent line # */
        
        /* insert the line into the template */
        create lbTemplate.
        buffer-copy ttInsert except LineNumber
            to lbTemplate
                assign lbTemplate.LineNumber = iStartLine + ttInsert.LineNumber.
    end.    /* each insert */
    
    /* Delete the parent lines */
    for each ttInsert break by ttInsert.ParentRowid:
        if first-of(ttInsert.ParentRowid) then
                do:
                /* Get rid of the ##Include:## line */
                find lbTemplate where rowid(lbTemplate) = ttInsert.ParentRowid.
                delete lbTemplate.
        end.    /* firstof */
    end.    /* loop through insertable files */
    
    /* are there any new include tokens in the stuff we've just imported? */
    if can-find(first lbTemplate where lbTemplate.HasChildren) then
        dynamic-function('includeTemplates' in target-procedure).
    
    return true.
end function.    /* includeTemplates */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeGenerator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initializeGenerator Procedure 
FUNCTION initializeGenerator RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Actions to perform before anything else happens.
        Notes:
------------------------------------------------------------------------------*/
    define variable lSuper            as logical   initial ? no-undo.    
   
    /* Remove all context. Do this via a function call since
       the context is available to the hook procedure, and it may
       want to clear the context at some other point. */
    lSuper = dynamic-function('clearContext' in target-procedure).
    if lSuper eq ? then
        lSuper = yes. 
    
    /* Remove the other internal generation temp tables */
    empty temp-table ttTemplate.
    empty temp-table ttInsert.
    empty temp-table ttOutput.
    empty temp-table ttLoop.
    
    lSuper = super() no-error.    
    if lSuper eq ? then
        lSuper = yes.

    error-status:error = no.
    return (lSuper ne no).
END FUNCTION.    /* initializeGenerator */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeOutputTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initializeOutputTable Procedure 
FUNCTION initializeOutputTable RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    define buffer lbOutput     for ttOutput.
    
    empty temp-table lbOutput.
    giOutputLineNumber = 0.
    
    return true.
end function.    /* initializeOutputTable */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processInstructionEvery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processInstructionEvery Procedure 
FUNCTION processInstructionEvery RETURNS INTEGER
  ( input piLineNumber            as integer,
      input pcInstructionValue            as character,
      input piLoopIteration         as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    define variable iOffSetRows             as integer                 no-undo.
    define variable iEveryValue             as integer                 no-undo.
    define variable lOk                     as logical                 no-undo.
    
    iEveryValue = integer(pcInstructionValue) no-error.
    
    /* Determine which lines are contained by the If block. We always 
       need to skip over these lines, regardless of whether we process
       them or not.
     */
    iOffSetRows = dynamic-function('calculateBlockSize' in target-procedure,
                                   'Every',    /* block type */
                                   piLineNumber).
    
    /* An offset of ? means that there was an error
       parsing the template. Leave things as they are and
       return.
       
       If the offset is only 2, then all that this
       block consists of is the ##Every:## and ##Every:End## lines.
       There's nothing to do, so don't do it.
     */
    if iOffSetRows eq 2 or iOffSetRows eq ? then
        return iOffsetRows.
    
    /* If the value specified by the ##Every:## token is unknown, ignore the block.
       If the iteration is the nth iteration, as specified by the token value, then
       do the 
     */
    if piLoopIteration ne ? and
       iEveryValue ne ? and
       piLoopIteration mod iEveryValue eq 0 then
    do:
        /* Process the code contained by the Every block. */
        lOk = dynamic-function('processTemplate' in target-procedure,
                               /* exclude the If:XXX line */
                               piLineNumber + 1,
                               /* exclude the Loop:End line */
                               piLineNumber + iOffSetRows - 2,
                               ?   ).
        
        /* Pass the error back by returning the unknown value. */
        if not lOk then
            iOffSetRows = ?.                               
    end.    /* process block contents */
    
    return iOffSetRows.
end function.    /* processInstructionEvery */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processInstructionIf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processInstructionIf Procedure 
FUNCTION processInstructionIf RETURNS INTEGER
  ( input piLineNumber            as integer,
    input pcInstructionValue      as character ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    define variable iOffSetRows             as integer                 no-undo.
    define variable lLogicalValue           as logical                 no-undo.
    define variable lOk                     as logical                 no-undo.
    
    /* Determine which lines are contained by the If block. We always 
       need to skip over these lines, regardless of whether we process
       them or not.
     */
    iOffSetRows = dynamic-function('calculateBlockSize' in target-procedure,
                                   'If',    /* block type */
                                   piLineNumber).
    /* An offset of ? means that there was an error
       parsing the template. Leave things as they are and
       return.
       
       If the offset is only 2, then all that this
       block consists of is the ##If:## and ##If:End## lines.
       There's nothing to do, so don't do it.
     */
    if iOffSetRows eq 2 or iOffSetRows eq ? then
        return iOffsetRows.
    
    lLogicalValue = logical(pcInstructionValue) no-error.    
    /* If the logical value is true or unknown, then process the block.
       If false, ignore the block.
     */
    if lLogicalValue ne false then
    do:
        /* Process the code contained by the If block. */
        lOk = dynamic-function('processTemplate' in target-procedure,
                               /* exclude the If:XXX line */        
                               piLineNumber + 1,
                               /* exclude the Loop:End line */
                               piLineNumber + iOffSetRows - 2,
                               ?   ).
        /* Pass the error back by returning the unknown value. */
        if not lOk then
            iOffSetRows = ?.        
    end.    /* process If condition */                         
    
    return iOffSetRows.
end function.    /* processInstructionIf */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processInstructionLoop) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processInstructionLoop Procedure 
FUNCTION processInstructionLoop RETURNS INTEGER
  ( input piLineNumber            as integer,
    input pcInstructionValue      as character ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    define variable iBlockSize               as integer                no-undo.
    define variable iCount                   as integer                no-undo.
    define variable cLoopName                as character              no-undo.
    define variable cEnclosingLoop           as character              no-undo.
    
    define buffer lbTemplate        for ttTemplate.
    define buffer lbLoop         for ttLoop.
    
    /* determine which lines are contained by the loop */
    iBlockSize = dynamic-function('calculateBlockSize' in target-procedure,
                                   'Loop',    /* block type */
                                   piLineNumber).
    /* An offset of ? means that there was an error
       parsing the template. Leave things as they are and
       return.
       
       If the offset is only 2, then all that this
       block consists of is the ##Loop:## and ##Loop:End## lines.
       There's nothing to do, so don't do it.
     */
    if iBlockSize eq 2 or iBlockSize eq ? then
        return iBlockSize.
    
    /* Set up counters for Every token */
    cEnclosingLoop = dynamic-function('getTokenValue' in target-procedure, 'CurrentLoopName').
    if cEnclosingLoop eq ? then
        cEnclosingLoop = ''.
    
    find lbLoop where lbLoop.LoopName = pcInstructionValue no-error.
    
    /* If the counter */
    if available lbLoop then
    do:
        iCount = 0.
        repeat:
            iCount = iCount + 1.
            cLoopName = pcInstructionValue + '-' + string(iCount).
            
            find lbLoop where lbLoop.LoopName = cLoopName no-error.
            if not available lbLoop then
                leave.
        end.    /* repeat: look for name */
    end.    /* available loop counter */
    else
        cLoopName = pcInstructionValue.
    
    /* each loop has its own counter variable. */
    create lbLoop.
    lbLoop.LoopName = cLoopName.
    lbLoop.StartLine = piLineNumber + 1. /* exclude the Loop:XXX line */
    lbLoop.EndLine = piLineNumber + iBlockSize - 2. /* exclude the Loop:End line */
    
    /* Always set to zero here. processLoopIteration() is called
       from the loop block and it increments this counter.
     */
    lbLoop.Iteration = 0.
    
    /* Keep the name of the loop counter so that we know we're in a loop. */
    dynamic-function('setTokenValue' in target-procedure,
                     'CurrentLoopName', lbLoop.LoopName).
    
    /* Call the code that performs the loop. */
    dynamic-function('processLoop-' + pcInstructionValue in target-procedure) no-error.
    
    /* We don't need this counter any more. */
    delete lbLoop.
    
    /* clear the name of the loop counter */
    dynamic-function('setTokenValue' in target-procedure,
                     'CurrentLoopName', cEnclosingLoop).
    
    return iBlockSize.
end function.    /* processInstructionLoop */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processInstructionToken) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processInstructionToken Procedure 
FUNCTION processInstructionToken RETURNS logical
  ( input pcLineContent      as character ) :
/*------------------------------------------------------------------------------
 Purpose: Processes a line with one or more simple tokens in it. These are
              Call or Token tokens.
   Notes: pcLineContent.
------------------------------------------------------------------------------*/
    define variable cInstruction            as character                    no-undo.
    define variable cInstructionType        as character                    no-undo.
    define variable cInstructionValue       as character                    no-undo.
    
    cInstruction = dynamic-function('getFirstInstructionSet' in target-procedure,
                              pcLineContent).
    
    do while cInstruction ne '':        
        /* get the token into a known form */
        run parseInstructionSet in target-procedure (input  cInstruction,
                                                    output cInstructionType,
                                                    output cInstructionValue).
        cInstructionValue =  dynamic-function('resolveInstructionValue' in target-procedure,
                                              cInstructionValue).
        /* Token has been resolved.
           Turn the ##xxx:## into a tokenised value.
         */
        pcLineContent = replace(pcLineContent, cInstruction, cInstructionValue).
            
        /* find the next token in the line */
        cInstruction = dynamic-function('getFirstInstructionSet' in target-procedure,
                                        pcLineContent).
    end.    /* token loop */
    
    dynamic-function('createOutputLine' in target-procedure, pcLineContent).
    
    return true.
end function.    /* processInstructionToken */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoopIteration) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoopIteration Procedure 
FUNCTION processLoopIteration RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    /* callable only. */
    define variable cCurrentLoop        as character                    no-undo.
    define variable lOk                 as logical                      no-undo.
    
    define buffer lbLoop        for ttLoop.
    
    /* Are we in a loop block? If so, then increment the counter. */
    cCurrentLoop = dynamic-function('getTokenValue' in target-procedure, 'CurrentLoopName').
    find lbLoop where lbLoop.LoopName = cCurrentLoop no-error.
    if available lbLoop then
        lbLoop.Iteration = lbLoop.Iteration + 1.
    
    /* process the contained code. */
    lOK = dynamic-function('processTemplate' in target-procedure,
                           lbLoop.StartLine, lbLoop.EndLine, lbLoop.Iteration).
    
    error-status:error = no.
    return lOk.
end function.    /* processLoopIteration */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processTemplate Procedure 
FUNCTION processTemplate RETURNS LOGICAL
  ( input piStartLine        as integer,
    input piEndLine          as integer,
    input piLoopIteration    as integer  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    define variable cInstruction      as character                    no-undo.
    define variable cInstructionType  as character                    no-undo.
    define variable cInstructionValue as character                    no-undo.
    define variable iOffSetRows       as integer                      no-undo.
    define variable lOk               as logical                      no-undo.
    
    define buffer lbTemplate     for ttTemplate.    
    
    define query qTemplate     for lbTemplate scrolling.
    
    /* use a QUERY instead of FOR EACH because we can 
       navigate backwards and forward at will.
     */
    if piStartLine eq ? or piEndLine eq ? then
        open query qTemplate for each lbTemplate by lbTemplate.LineNumber.
    else
        open query qTemplate         
            for each lbTemplate where
                     lbTemplate.LineNumber >= piStartLine and
                     lbTemplate.LineNumber <= piEndLine
                     by lbTemplate.LineNumber.
    
    lOk = yes.
    
    get first qTemplate.
    QRY-TEMPLATE-LINE:
    do while available lbTemplate:
        /* does the line have tokens?
         */
        cInstruction = dynamic-function('getFirstInstructionSet' in target-procedure,
                                        lbTemplate.LineContent).
        
        /* if there are no tokens, the simply write the line as-is */
        if cInstruction eq '' then
            dynamic-function('createOutputLine' in target-procedure, lbTemplate.LineContent).
        else
        do:
            /* turn the token into a usable form. */
            run parseInstructionSet in target-procedure (input  cInstruction,
                                                         output cInstructionType,
                                                         output cInstructionValue).
            
            /* lines are processed differently depending on the token type */
            case cInstructionType:
                /* Loop, If and Every tokens only support a single token per line,
                   and are block-type tokens.
                 
                   'Token' token types support multiple tokens per line.
                 */
                when 'Token' then
                    dynamic-function('processInstructionToken' in target-procedure, lbTemplate.LineContent).
                when 'Loop' then
                do:
                                cInstructionValue =  dynamic-function('resolveInstructionValue' in target-procedure,
                                                                      cInstructionValue).
                    
                    iOffSetRows = dynamic-function('processInstructionLoop' in target-procedure,
                                                   lbTemplate.LineNumber, cInstructionValue ).
                    /* An offset of ? means that there was an error
                       parsing the template. Leave things as they are and
                       return.
                     */
                    if iOffSetRows eq ? then
                    do:
                        lOk = no.
                        leave QRY-TEMPLATE-LINE.
                    end.    /* offset rows error */
                                                                       
                    /* reposition one back from the value returned because the 
                       reposition forward statement positions between query result rows,
                       and we always do a get next to get the next row.                       
                     */
                    reposition qTemplate forward (iOffsetRows - 1).
                end.    /* 'Loop' token */
                when 'If' then
                do:
                                cInstructionValue =  dynamic-function('resolveInstructionValue' in target-procedure,
                                                                      cInstructionValue).
                    
                    iOffSetRows = dynamic-function('processInstructionIf' in target-procedure,
                                                   lbTemplate.LineNumber, cInstructionValue).
                    /* An offset of ? means that there was an error
                       parsing the template. Leave things as they are and
                       return.
                     */
                    if iOffSetRows eq ? then
                    do:
                        lOk = no.
                        leave QRY-TEMPLATE-LINE.
                    end.    /* offset rows error */
                    
                    /* reposition one back from the value returned because the 
                       reposition forward statement positions between query result rows,
                       and we always do a get next to get the next row.                       
                     */
                    reposition qTemplate forward (iOffsetRows - 1).
                end.    /* 'If' token */
                when 'Every' then
                do:
                                cInstructionValue =  dynamic-function('resolveInstructionValue' in target-procedure,
                                                                      cInstructionValue).
                    
                    iOffSetRows = dynamic-function('processInstructionEvery' in target-procedure,
                                                   lbTemplate.LineNumber, cInstructionValue,
                                                   piLoopIteration ).
                    /* An offset of ? means that there was an error
                       parsing the template. Leave things as they are and
                       return.
                     */
                    if iOffSetRows eq ? then
                    do:
                        lOk = no.
                        leave QRY-TEMPLATE-LINE.
                    end.    /* offset rows error */
                    
                    /* reposition one back from the value returned because the 
                       reposition forward statement positions between query result rows,
                       and we always do a get next to get the next row.
                     */
                    reposition qTemplate forward (iOffsetRows - 1).
                end.    /* 'Every' token */
                when 'Exclude' then
                do:                                                               
                    iOffSetRows = dynamic-function('calculateBlockSize' in target-procedure,
                                                   'Exclude',    /* block type */
                                                   lbTemplate.LineNumber).
                    
                    /* An offset of ? means that there was an error
                       parsing the template. Leave things as they are and
                       return.
                     */
                    if iOffSetRows eq ? then
                    do:
                        lOk = no.
                        leave QRY-TEMPLATE-LINE.
                    end.    /* offset rows error */
                    
                    /* reposition one back from the value returned because the 
                       reposition forward statement positions between query result rows,
                       and we always do a get next to get the next row.
                     */
                    reposition qTemplate forward (iOffsetRows - 1).
                end.    /* 'Exclude' */
            end case.    /* token type */
        end.    /* there are tokens in the line */
        
        get next qTemplate.
    end.    /* QRY-TEMPLATE-LINE: each template record */
    close query qTemplate.
    
    error-status:error = no.    
    return lOk.
end function.    /* processTemplate */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resolveInstructionValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resolveInstructionValue Procedure 
FUNCTION resolveInstructionValue RETURNS CHARACTER
        ( input pcInstructionValue        as character  ):
/*------------------------------------------------------------------------------
  Purpose: Transforms an instruction value from the input value to a more
                   meaningful value. ie. takes [Blah] and returns 'a token value' (say).
        Notes: - Value is resolved into a non-tokenised string. The instruction value 
             can be either a literal string, a token, or a function call. 
           - Function calls can be with or without parameters. The following parameters
             are supported: literal string or token. Nested function calls are not 
             supported. 
------------------------------------------------------------------------------*/
    define variable iStartPos            as integer                no-undo.
    define variable iEndPos              as integer                no-undo.
    define variable cFunctionName        as character              no-undo.
    define variable cParameterValue      as character              no-undo.
    
    /* Now the instruction value is either [Blah] or Blah.
       If [Blah] then it's a token and needs to be resolved, by calling getTokenValue().
       If Blah, simply pass the value back.
    */
    if pcInstructionValue begins '[' then
    do:
        /* get rid of token indicators */
        pcInstructionValue =  trim(pcInstructionValue, '[').
        pcInstructionValue =  trim(pcInstructionValue, ']').
        
            case pcInstructionValue:
            when 'Now' then
                pcInstructionValue = string(year(today), '9999')
                                   + string(month(today), '99')
                                   + string(day(today), '99')
                                   + '-'
                                   + string(time, 'HH:MM:SS').
            when 'Today' then
                pcInstructionValue = string(year(today), '9999')
                                   + string(month(today), '99')
                                   + string(day(today), '99').
            otherwise
                pcInstructionValue = dynamic-function('getTokenValue' in target-procedure, pcInstructionValue).          
            end case.    /* instruction value */
    end.    /* this is a token */
    else
    do:
        /* if the instruction value has parentheses,
           then assume a function call.
         */
        iStartPos = index(pcInstructionValue, '(').
        iEndPos = index(pcInstructionValue, ')').
        
        if iStartPos gt 0 and iEndPos gt 0 then
        do:
            /* The call instruction value will either be in the format of:
               doThing() or
               doThing([TokenName])
               doThing(p1) where p1 is a literal input string. It is the called 
               function's responsibility to interpret the parameter.
             */
            cFunctionName = substring(pcInstructionValue, 1, iStartPos - 1).
            if iStartPos + 1 eq iEndPos then
                pcInstructionValue = dynamic-function(cFunctionName in target-procedure) no-error.                 
            else
            do:
                /* Isolate the parameter value. */
                cParameterValue = substring(pcInstructionValue, iStartPos + 1).
                cParameterValue = trim(cParameterValue, ')').
                
                /* The parameter is potentially a token. */
                if cParameterValue begins '[' then
                do:
                    cParameterValue = trim(cParameterValue, '[').
                    cParameterValue = trim(cParameterValue, ']').
                    /* the cParameterValue passed in to getTokenValue is at this point the name
                       of the token. the value returned by the function is the value of the token.
                     */
                    cParameterValue = dynamic-function('getTokenValue' in target-procedure, cParameterValue).
                end.    /* parameter is a token */
                
                pcInstructionValue = dynamic-function(cFunctionName in target-procedure, cParameterValue) no-error.
            end. /* parameter */
        end.    /* function call used to resolve value */
    end.    /* non-token value */
    
    if pcInstructionValue eq ? then
        pcInstructionValue = '?'.
    
    error-status:error = no.
    return pcInstructionValue.
END FUNCTION.    /* resolveInstructionValue */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTokenValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTokenValue Procedure 
FUNCTION setTokenValue RETURNS LOGICAL
  ( input pcInstruction as character,
     input pcValue as character ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    define variable lOverrideRun         as logical                    no-undo.
    
    lOverrideRun = dynamic-function(('setToken-' + pcInstruction) in target-procedure, pcValue) no-error.
    
    /* if the function doesn't exist, then set into context directly */
    if error-status:get-number(1) eq 5639 then
    do:
        find ttContext where ttContext.Token = pcInstruction no-error.
        if not available ttContext then
        do:
            create ttContext.
            ttContext.Token = pcInstruction.
        end.    /* no context exists */
    
        ttContext.TokenValue = pcValue.
    end.    /* no setter override */
    
    error-status:error = no.
    return true.
end function.    /* setTokenValue */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

