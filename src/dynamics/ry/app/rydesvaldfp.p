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
  File: rydesvaldfp.p

  Description:  DataField Attribute Validation procedure

  Purpose:      Validates certain datafield attributes and passes back a list
                of invalid attributes and a list of messages 

  Parameters:   INPUT  pcDataFieldName AS CHARACTER
                OUTPUT pcInvalidAttrs  AS CHARACTER
                OUTPUT pcMessageList   AS CHARACTER
  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   06/05/2003  Author:     

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydesvaldfp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

&SCOPED-DEFINE Value-Delimiter CHR(1)

DEFINE INPUT  PARAMETER pcDataFieldName AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcInvalidAttrs  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcMessageList   AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cDataType          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDelimiter         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cListItemPairs     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRadioButtons      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSubType           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cVisualizationType AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField             AS HANDLE     NO-UNDO.
DEFINE VARIABLE hObjectBuffer      AS HANDLE     NO-UNDO.
DEFINE VARIABLE iNumMessage        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cPropertyNames     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPropertyValues    AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
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
         HEIGHT             = 8.81
         WIDTH              = 55.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
ASSIGN  cPropertyNames  = "VisualizationType,DELIMITER,LIST-ITEM-PAIRS,SUBTYPE,RADIO-BUTTONS":U
        cPropertyValues = "":U.

RUN getInstanceProperties IN gshRepositoryManager (INPUT  pcDataFieldName,
                                                   INPUT  "",
                                                   INPUT-OUTPUT cPropertyNames,
                                       OUTPUT cPropertyValues ) NO-ERROR.

IF RETURN-VALUE NE "":U OR ERROR-STATUS:ERROR THEN
   RETURN ERROR RETURN-VALUE.

 cVisualizationType = ENTRY(LOOKUP("VisualizationType":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}).
 CREATE VALUE(cVisualizationType) hField NO-ERROR.
 IF ERROR-STATUS:ERROR THEN
 DO:
   pcInvalidAttrs = 'VisualizationType':U.
   pcMessageList = pcMessageList + (IF NUM-ENTRIES(pcMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                   {aferrortxt.i 'AF' '5' '?' '?' '"VisualizationType attribute"'}.
   RETURN.
 END.  /* if visualization type error */

 CASE cVisualizationType:
   WHEN 'Selection-List':U THEN 
   DO:
     ASSIGN cDelimiter     = ENTRY(LOOKUP("DELIMITER":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})
            cListItemPairs = ENTRY(LOOKUP("LIST-ITEM-PAIRS":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}).
     
     IF cDelimiter = "" OR cDelimiter = "?":U THEN
        cDelimiter = ",".   
     ASSIGN hField:DELIMITER = cDelimiter NO-ERROR.
     IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
       ASSIGN
         pcInvalidAttrs = pcInvalidAttrs + (IF NUM-ENTRIES(pcInvalidAttrs) > 0 THEN ',':U ELSE '':U) +
                          'DELIMITER':U
         pcMessageList = pcMessageList + (IF NUM-ENTRIES(pcMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                         {aferrortxt.i 'AF' '5' '?' '?' '"DELIMITER attribute"'}.
     IF cListItemPairs NE '':U AND clistitemPairs <> "?":U THEN 
     DO: 
       hField:LIST-ITEM-PAIRS = cListItemPairs NO-ERROR.
       IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
         ASSIGN
           pcInvalidAttrs = pcInvalidAttrs + (IF NUM-ENTRIES(pcInvalidAttrs) > 0 THEN ',':U ELSE '':U) +
                            'LIST-ITEM-PAIRS':U
           pcMessageList = pcMessageList + (IF NUM-ENTRIES(pcMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                           {aferrortxt.i 'AF' '5' '?' '?' '"LIST-ITEM-PAIRS attribute"'}.
     END.  /* if list item pairs not blank */
   END.  /* when selection list */
   WHEN 'Combo-box':U THEN
   DO:
     ASSIGN cDelimiter     = ENTRY(LOOKUP("DELIMITER":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})
            cListItemPairs = ENTRY(LOOKUP("LIST-ITEM-PAIRS":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})
            cSubType       = ENTRY(LOOKUP("SUBTYPE":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}).
     IF cDelimiter = "" OR cDelimiter = "?":U THEN
        cDelimiter = ",". 
     hField:DELIMITER = cDelimiter NO-ERROR.
     IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
       ASSIGN
         pcInvalidAttrs = pcInvalidAttrs + (IF NUM-ENTRIES(pcInvalidAttrs) > 0 THEN ',':U ELSE '':U) +
                          'DELIMITER':U
         pcMessageList = pcMessageList + (IF NUM-ENTRIES(pcMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                         {aferrortxt.i 'AF' '5' '?' '?' '"DELIMITER attribute"'}.

     IF cListItemPairs NE '':U AND cListItemPairs NE "?":U THEN 
     DO: 
       hField:LIST-ITEM-PAIRS = cListItemPairs NO-ERROR.
       IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
         ASSIGN
           pcInvalidAttrs = pcInvalidAttrs + (IF NUM-ENTRIES(pcInvalidAttrs) > 0 THEN ',':U ELSE '':U) +
                            'LIST-ITEM-PAIRS':U
           pcMessageList = pcMessageList + (IF NUM-ENTRIES(pcMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                           {aferrortxt.i 'AF' '5' '?' '?' '"LIST-ITEM-PAIRS attribute"'}.
     END.  /* if list item pairs not blank */

     IF cSubType <> "?":U THEN
     DO:
       hField:SUBTYPE = cSubType NO-ERROR.
       IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
         ASSIGN
           pcInvalidAttrs = pcInvalidAttrs + (IF NUM-ENTRIES(pcInvalidAttrs) > 0 THEN ',':U ELSE '':U) +
                            'SUBTYPE':U
           pcMessageList = pcMessageList + (IF NUM-ENTRIES(pcMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                           {aferrortxt.i 'AF' '5' '?' '?' '"SUBTYPE attribute"'}.
     END.                    
   END.  /* when combo-box */
   WHEN 'Radio-Set':U THEN
   DO:
     ASSIGN cDelimiter    = ENTRY(LOOKUP("DELIMITER":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})
            cRadioButtons = ENTRY(LOOKUP("RADIO-BUTTONS":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}).
     IF cDelimiter = "" OR cDelimiter = "?":U THEN
        cDelimiter = ",". 
     ASSIGN hField:DELIMITER = cDelimiter NO-ERROR.
     IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
       ASSIGN
         pcInvalidAttrs = pcInvalidAttrs + (IF NUM-ENTRIES(pcInvalidAttrs) > 0 THEN ',':U ELSE '':U) +
                          'DELIMITER':U
         pcMessageList = pcMessageList + (IF NUM-ENTRIES(pcMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                         {aferrortxt.i 'AF' '5' '?' '?' '"DELIMITER attribute"'}.
     IF cRadioButtons <> "?":U THEN
     DO:
     hField:RADIO-BUTTONS = cRadioButtons NO-ERROR.
        IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
          ASSIGN
            pcInvalidAttrs = pcInvalidAttrs + (IF NUM-ENTRIES(pcInvalidAttrs) > 0 THEN ',':U ELSE '':U) +
                             'RADIO-BUTTONS':U
            pcMessageList = pcMessageList + (IF NUM-ENTRIES(pcMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                            {aferrortxt.i 'AF' '5' '?' '?' '"RADIO-BUTTONS attribute"'}.
     END.                    
   END.  /* when radio-set */
   WHEN 'Fill-in':U THEN
   DO:
     cSubType = ENTRY(LOOKUP("SUBTYPE":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}).

     IF cSubType NE ? AND cSubType <> "?" THEN 
     DO:
       hField:SUBTYPE = cSubType NO-ERROR.
       IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
         ASSIGN
           pcInvalidAttrs = pcInvalidAttrs + (IF NUM-ENTRIES(pcInvalidAttrs) > 0 THEN ',':U ELSE '':U) +
                            'SUBTYPE':U
           pcMessageList = pcMessageList + (IF NUM-ENTRIES(pcMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                           {aferrortxt.i 'AF' '5' '?' '?' '"SUBTYPE attribute"'}.
     END.  /* if subtype not ? */
   END.  /* when fill-in or combo-box */
 END CASE.

DELETE WIDGET hField.

ERROR-STATUS:ERROR = NO.
RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


