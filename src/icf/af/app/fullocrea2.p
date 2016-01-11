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
/*------------------------------------------------------------------------

  File:        af/app/fullocrea2.p 

  Description: Writes the logic procedure

  Purpose: This procedure will create the logic procedure 
  Input Parameters:
           pcTemplate   Procedure logic template file (relative path with filename)
           pcLogicFile  Name of logic file including full pathname to create
                        (i.e. c:/workarea/gsmmlog.p)
           pcTableName  Name of First Internal Table in SDO
           pcSDOName    File name of Saved SDO with full path        
           pcRelLogic   Relative Name of logic procedure
           pcRelSDOName Relative Name of SDO file
  History:
  Author: Don Bulua
  
------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcTemplate   AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcLogicFile  AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcTableName  AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcSDOName    AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcRelLogic   AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcRelSDOName AS CHARACTER  NO-UNDO.

 DEFINE STREAM LogStream.

 DEFINE VARIABLE iOffset    AS INTEGER    NO-UNDO.

 &GLOBAL-DEFINE FRAME-NAME EDIT-FRAME

 FUNCTION editFixCRLF RETURNS LOGICAL FORWARD.

 FUNCTION buildRowObjectValidate RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) FORWARD.

 FUNCTION buildCreatePreTransValidate RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) FORWARD.

 FUNCTION buildWritePreTransValidate RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) FORWARD.

 FUNCTION getIndexFields RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) FORWARD.

 FUNCTION getMandatoryFields RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) FORWARD.

 DEFINE VARIABLE eEdit AS CHARACTER 
      VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
      SIZE 200 BY 20 NO-UNDO .

 DEFINE FRAME {&FRAME-NAME}
     eEdit AT ROW 1 COL 1 NO-LABEL
     WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
          SIDE-LABELS NO-UNDERLINE THREE-D 
          AT COL 1 ROW 1
          SIZE 200 BY 20.

 eEdit:READ-FILE(pcTemplate).

 editFixCRLF().

 RUN EditReplace(INPUT "  File: ",
                    INPUT ".p",
                    INPUT "  File:         " + ENTRY(NUM-ENTRIES(pcLogicFile,"/":U),pcLogicFile,"/":U),
                    OUTPUT iOffset).

 RUN EditReplace(INPUT "  Description:  Data ",
                    INPUT "Logic",
                    INPUT "  Description:  " + pcTableName + " Data Logic",
                    OUTPUT iOffset).

 RUN EditReplace(INPUT "data-",
                    INPUT "logic",
                    INPUT pcTableName,
                    OUTPUT iOffset).

 RUN EditReplace(INPUT "&scop object-name",
                    INPUT ".p",
                    INPUT "&scop object-name       " + ENTRY(NUM-ENTRIES(pcLogicFile,"/":U),pcLogicFile,"/":U),
                    OUTPUT iOffset).

 RUN EditFind(INPUT  "/* Data Preprocessor Definitions */":U,
              INPUT  "/* Error handling definitions */":U,
              OUTPUT iOffset).

 eEdit:INSERT-STRING("&GLOB DATA-LOGIC-TABLE " + pcTableName + CHR(10)).
 eEdit:INSERT-STRING('&GLOB DATA-FIELD-DEFS  "' + REPLACE(pcRelSDOName,".w":U,".i":U) + '"':U + CHR(10)).

 RUN EditReplace(INPUT "ASSIGN cDescription = ",
                 INPUT "PLIP",
                 INPUT 'ASSIGN cDescription = "' +  pcTableName + ' Data Logic Procedure',
                 OUTPUT iOffset).

 eEdit:CURSOR-OFFSET = iOffset.               
 /* Put the standard businesslogic into the new procedure. */
 RUN addProcedure("createPreTransValidate":U,
                  "Procedure used to validate records server-side before the transaction scope upon create":U,
                  YES,
                  OUTPUT iOffset).

 eEdit:CURSOR-OFFSET = iOffset.       
 eEdit:INSERT-STRING(buildCreatePreTransValidate(pcTableName)).


 RUN addProcedure("writePreTransValidate":U,
                  "Procedure used to validate records server-side before the transaction scope upon write":U,
                  YES,
                  OUTPUT iOffset).

 eEdit:CURSOR-OFFSET = iOffset.       
 eEdit:INSERT-STRING(buildWritePreTransValidate(pcTableName)).


 RUN addProcedure("rowObjectValidate":U,
                  "Procedure used to validate RowObject record client-side":U,
                  NO,
                  OUTPUT iOffset).
 eEdit:CURSOR-OFFSET = iOffset.
 eEdit:INSERT-STRING(buildRowObjectValidate(pcTableName)).

 eEdit:SAVE-FILE(pcLogicFile).
 
 OUTPUT STREAM LogStream TO VALUE(REPLACE(pcLogicFile,".p","_cl.p")).
 PUT STREAM LogStream UNFORMATTED
     '/* ' + REPLACE(pcRelLogic,".p","_cl.p") + ' - non-db proxy for ' + pcRelLogic + ' */ ' SKIP(1)
     '&GLOBAL-DEFINE DB-REQUIRED FALSE' SKIP(1)
     '~{"' + pcRelLogic + '"~}' SKIP.
 OUTPUT STREAM LogStream CLOSE.

 
 RETURN.

PROCEDURE addProcedure:
/*------------------------------------------------------------------------------
  Purpose:     addProcedure
  Notes:       Adds a procedure if it does not exist and positions the editor cursor
               at the start of the procedure, ready to receive text. If the procedure exists,
               does nothing
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcProcedureName  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcPurpose        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plRequired       AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER piLine           AS INTEGER    NO-UNDO.

  DEFINE VARIABLE iStart     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEnd       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lExists    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRequired  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iOffset    AS INTEGER    NO-UNDO.

  IF plRequired THEN
    cRequired = "_DB-REQUIRED".

      DO WITH FRAME {&FRAME-NAME}:
          eEdit:CURSOR-OFFSET = 1.
          eEdit:SEARCH("/* **********************  Internal Procedures",5).
          lExists = eEdit:SEARCH(pcProcedureName,5).
          IF lExists THEN RETURN.
          lExists = eEdit:SEARCH("/* ************************  Function Implementations",5).
          IF lExists 
          THEN eEdit:CURSOR-LINE = eEdit:CURSOR-LINE - 1.
          ELSE eEdit:MOVE-TO-EOF().
          eEdit:INSERT-STRING(CHR(10)).
          IF plRequired THEN eEdit:INSERT-STRING("~{&DB-REQUIRED-START~}" + CHR(10)).
          eEdit:INSERT-STRING("&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE " + pcProcedureName + " dTables " + cRequired + CHR(10)).
          eEdit:INSERT-STRING("PROCEDURE " + pcProcedureName + " : " + CHR(10)).
          eEdit:INSERT-STRING("/*------------------------------------------------------------------------------" + CHR(10)).
          eEdit:INSERT-STRING("  Purpose:     " + pcPurpose + CHR(10)).
          eEdit:INSERT-STRING("  Parameters:  <none>" + CHR(10)).
          eEdit:INSERT-STRING("  Notes:       " + CHR(10)).
          eEdit:INSERT-STRING("------------------------------------------------------------------------------*/" + CHR(10) + CHR(10)).
          eEdit:INSERT-STRING("  DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO." + CHR(10)).
          eEdit:INSERT-STRING("  DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO." + CHR(10) + CHR(10)).
          piLine = eEdit:CURSOR-OFFSET.
          eEdit:INSERT-STRING("  ERROR-STATUS:ERROR = NO." + CHR(10)).
          eEdit:INSERT-STRING("  RETURN cMessageList." + CHR(10) + CHR(10)).
          eEdit:INSERT-STRING("END PROCEDURE." + CHR(10) + CHR(10)).
          eEdit:INSERT-STRING("/* _UIB-CODE-BLOCK-END */" + CHR(10) + "&ANALYZE-RESUME" + CHR(10)).
          IF plRequired THEN eEdit:INSERT-STRING("~{&DB-REQUIRED-END~}" + CHR(10)).

      END.

END PROCEDURE.

PROCEDURE EditFind:
/*------------------------------------------------------------------------------
  Purpose:     EditFind
  Notes:       Clears the section between the specified phrases, 
               retuning the start position
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFrom  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcUpto  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER piStart AS INTEGER    NO-UNDO.

DEFINE VARIABLE iStart     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iEnd       AS INTEGER    NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        eEdit:CURSOR-OFFSET = 1.
        eEdit:SEARCH(pcFrom,5).
        iStart = eEdit:CURSOR-OFFSET.
        eEdit:SEARCH(pcUpto,1).
        iEnd = eEdit:CONVERT-TO-OFFSET(eEdit:CURSOR-LINE,1) - 1.
        IF iStart > 1 THEN DO:
            eEdit:SET-SELECTION ( iStart , iEnd ).
            eEdit:REPLACE-SELECTION-TEXT(chr(10)).
            piStart = eEdit:CURSOR-OFFSET.
        END.
    END.
END PROCEDURE.

PROCEDURE EditReplace:
/*------------------------------------------------------------------------------
  Purpose:     ReplaceLine
  Notes:       Clears the first line containing the phrase and replaces it 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFrom    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcUpto    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcReplace AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER piStart AS INTEGER    NO-UNDO.

DEFINE VARIABLE iStart     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iEnd       AS INTEGER    NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        eEdit:CURSOR-OFFSET = 1.
        eEdit:SEARCH(pcFrom,37).
        iStart = eEdit:SELECTION-START.
        eEdit:SEARCH(pcUpto,37).
        iEnd = eEdit:SELECTION-END.
        IF iStart > 1 THEN DO:
            eEdit:SET-SELECTION ( iStart , iEnd ).
            eEdit:REPLACE-SELECTION-TEXT(pcReplace).
            piStart = eEdit:CURSOR-OFFSET.
        END.
    END.
END PROCEDURE.

FUNCTION buildCreatePreTransValidate RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  To create the CreatePreTransValidate Routine
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cIndexInformation           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cIndexField                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClauseFields               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClauseString               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClause                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldList                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hKeyBuffer                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField                      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCnt                        AS INTEGER    NO-UNDO.

/* Create buffer for passed in table */
  CREATE BUFFER hKeyBuffer FOR TABLE TRIM(pcTable) NO-ERROR.

  ASSIGN
    iLoop             = 0
    iCnt              = 0
    cIndexInformation = "":U
    cClauseFields     = "":U
    cFieldList        = "":U.

  find-index-loop:
  REPEAT WHILE cIndexInformation <> ?:
    ASSIGN
      iLoop = iLoop + 1
      cIndexInformation = hKeyBuffer:INDEX-INFORMATION(iLoop)
      cFieldList        = "":U
      cValueList        = "":U
      cClauseFields     = "":U.

    IF ENTRY(2,cIndexInformation) = "1":U THEN
    DO:
      DO iCnt = 5 TO NUM-ENTRIES(cIndexInformation) BY 2:
        ASSIGN
          cIndexField = TRIM(ENTRY(iCnt, cIndexInformation)).

        IF  AVAILABLE gsc_entity_mnemonic
        AND gsc_entity_mnemonic.table_has_object_field 
        AND gsc_entity_mnemonic.entity_object_field NE ""
        THEN DO:
            IF cIndexField = gsc_entity_mnemonic.entity_object_field THEN
               NEXT find-index-loop.
        END.
        ELSE
        DO:
          IF LENGTH(cIndexField) > 4 THEN
            IF SUBSTRING(cIndexField,LENGTH(cIndexField) - 3) = "_obj":U AND
               SUBSTRING(cIndexField,1,LENGTH(cIndexField) - 4) = SUBSTRING(pcTable,5) THEN
               NEXT find-index-loop.
        END.

        IF LOOKUP(cIndexField,cClauseFields) = 0 THEN
        DO:
          ASSIGN
            cClause       = IF iCnt = 5 THEN "              WHERE " ELSE CHR(10) + "                AND "
            cFieldList    = cFieldList + cIndexField + ", ":U
            cValueList    = cValueList + " + ', ' + " WHEN cValueList <> "":U
            cValueList    = cValueList + "STRING(b_":U + pcTable + ".":U + cIndexField + ")":U
            cClauseFields = cClauseFields + cClause + pcTable + ".":U + cIndexField + " = b_":U + pcTable + ".":U + cIndexField.
        END.
      END.

      ASSIGN
        cClauseFields = SUBSTITUTE(
            "  IF CAN-FIND(FIRST &1 ":U + CHR(10) + 
            cClauseFields + ") THEN":U  + CHR(10) + 
            "  DO:":U     + CHR(10) + 
            "     ASSIGN" + CHR(10) +
            "        cValueList   = " + cValueList + CHR(10) +
            "        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + " + CHR(10) +
            "                      ~{aferrortxt.i 'AF' '8' '&1' '' ""'&2'"" cValueList ~}." + CHR(10) + 
            "  END." + CHR(10),
            pcTable,cFieldList)        
        cClauseString = cClauseString + CHR(10) WHEN cClauseString <> "":U
        cClauseString = cClauseString + cClauseFields + CHR(10)
        cClauseFields = "":U.
    END.

  END.

  DELETE OBJECT hKeyBuffer.
  ASSIGN hKeyBuffer = ?.
  RETURN cClauseString.   /* Function return value. */

END FUNCTION.

FUNCTION buildWritePreTransValidate RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  To create the WritePreTransValidate Routine
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cIndexInformation           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cIndexField                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClauseFields               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClauseString               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClause                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldList                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hKeyBuffer                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField                      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCnt                        AS INTEGER    NO-UNDO.

/* Create buffer for passed in table */
  CREATE BUFFER hKeyBuffer FOR TABLE TRIM(pcTable) NO-ERROR.

  ASSIGN
    iLoop             = 0
    iCnt              = 0
    cIndexInformation = "":U
    cClauseFields     = "":U
    cFieldList        = "":U.

  find-index-loop:
  REPEAT WHILE cIndexInformation <> ?:
    ASSIGN
      iLoop = iLoop + 1
      cIndexInformation = hKeyBuffer:INDEX-INFORMATION(iLoop)
      cFieldList        = "":U
      cValueList        = "":U
      cClauseFields     = "":U.

    IF ENTRY(2,cIndexInformation) = "1":U THEN
    DO:
      DO iCnt = 5 TO NUM-ENTRIES(cIndexInformation) BY 2:
        ASSIGN
          cIndexField = TRIM(ENTRY(iCnt, cIndexInformation)).

        IF  AVAILABLE gsc_entity_mnemonic
        AND gsc_entity_mnemonic.table_has_object_field 
        AND gsc_entity_mnemonic.entity_object_field NE ""
        THEN DO:
            IF cIndexField = gsc_entity_mnemonic.entity_object_field THEN
               NEXT find-index-loop.
        END.
        ELSE
        DO:
          IF LENGTH(cIndexField) > 4 THEN
            IF SUBSTRING(cIndexField,LENGTH(cIndexField) - 3) = "_obj":U AND
               SUBSTRING(cIndexField,1,LENGTH(cIndexField) - 4) = SUBSTRING(pcTable,5) THEN
               NEXT find-index-loop.
        END.

        IF LOOKUP(cIndexField,cClauseFields) = 0 THEN
        DO:
            ASSIGN
              cClause       = IF iCnt = 5 THEN "              WHERE " ELSE CHR(10) + "                AND "
              cFieldList    = cFieldList + cIndexField + ", ":U
              cValueList    = cValueList + " + ', ' + " WHEN cValueList <> "":U
              cValueList    = cValueList + "STRING(b_":U + pcTable + ".":U + cIndexField + ")":U
              cClauseFields = cClauseFields + cClause + pcTable + ".":U + cIndexField + " = b_":U + pcTable + ".":U + cIndexField.
        END.
      END.
      ASSIGN
        cClauseFields = SUBSTITUTE(
              "  IF NOT isCreate() AND CAN-FIND(FIRST &1 ":U + CHR(10) + 
              cClauseFields + CHR(10) +              
              "                AND ROWID(&1) <> TO-ROWID(ENTRY(1,b_":U + pcTable + ".RowIDent))) THEN":U  + CHR(10) + 
              "  DO:":U     + CHR(10) + 
              "     ASSIGN" + CHR(10) +
              "        cValueList   = " + cValueList + CHR(10) +
              "        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + " + CHR(10) +
              "                      ~{aferrortxt.i 'AF' '8' '&1' '' ""'&2'"" cValueList ~}." + CHR(10) + 
              "  END." + CHR(10),
              pcTable,cFieldList)        

        cClauseString = cClauseString + CHR(10) WHEN cClauseString <> "":U
        cClauseString = cClauseString + cClauseFields + CHR(10)
        cClauseFields = "":U.
    END.

  END.

  DELETE OBJECT hKeyBuffer.
  ASSIGN hKeyBuffer = ?.
  RETURN cClauseString.   /* Function return value. */

END FUNCTION.


FUNCTION buildRowObjectValidate RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  To create the RowObjectValidate Routine 
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VARIABLE cField        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLabel        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cData         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cConvert      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCompare      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCompar2      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cIndexFields  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMandaFields  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop         AS INTEGER    NO-UNDO.
DEFINE VARIABLE cValidate     AS CHARACTER  NO-UNDO.

  ASSIGN
    cIndexFields = getIndexFields(pcTable)
    cIndexFields = REPLACE(cIndexFields,"'","`")
    cMandaFields = getMandatoryFields(pcTable)
    cMandaFields = REPLACE(cMandaFields,"'","`").

  /*Add only mandatory fields that are not yet in cIndexFields to the string*/
  IF cMandaFields <> "":U THEN
  DO iLoop = 1 TO NUM-ENTRIES(cMandaFields) BY 3:
    ASSIGN
      cField = ENTRY(iLoop,cMandaFields)
      cData  = ENTRY(iLoop + 1,cMandaFields)
      cLabel = ENTRY(iLoop + 2,cMandaFields).
      

    IF LOOKUP(cField,cIndexFields) = 0 THEN
      ASSIGN
        cIndexFields = cIndexFields + ",":U WHEN cIndexFields <> "":U
        cIndexFields = cIndexFields + cField + ",":U + cData + ",":U + cLabel.
  END.

  field-loop:
  DO iLoop = 1 TO NUM-ENTRIES(cindexFields) BY 3:

    ASSIGN
      cField = ENTRY(iLoop,cIndexFields)
      cData  = ENTRY(iLoop + 1,cIndexFields)
      cLabel = ENTRY(iLoop + 2,cIndexFields).

    IF  AVAILABLE gsc_entity_mnemonic
    AND gsc_entity_mnemonic.table_has_object_field 
    AND gsc_entity_mnemonic.entity_object_field NE ""
    THEN DO:
        IF cField = gsc_entity_mnemonic.entity_object_field THEN
           NEXT field-loop.
    END.
    ELSE
    DO:
        IF  LENGTH(cField) GT 4 
        AND SUBSTRING(cField,LENGTH(cField) - 3)   = "_obj":U 
        AND SUBSTRING(cField,1,LENGTH(cField) - 4) = SUBSTRING(pcTable,5) THEN
           NEXT field-loop.
    END.

    CASE cData:
      WHEN "character":U THEN 
        ASSIGN 
          cConvert = "isFieldBlank(":U
          cCompare = ")":U
          cCompar2 = "":U.
      WHEN "date":U THEN 
        ASSIGN 
          cConvert = "":U
          cCompare = " = ?":U
          cCompar2 = "":U.
      WHEN "logical":U THEN
        ASSIGN
          cConvert = "":U
          cCompare = " = ?":U
          cCompar2 = "":U.
      OTHERWISE  
        ASSIGN 
          cConvert = "":U
          cCompare = " = 0":U
          cCompar2 = " = ?":U.
    END CASE.

    ASSIGN
      cValidate = cValidate + IF cCompar2 EQ "":U THEN 
                                 SUBSTITUTE(
                                        "  IF &4b_&1.&2&5 THEN":U + CHR(10) +
                                        "    ASSIGN" + CHR(10) +
                                        "      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + " + CHR(10) + 
                                        "                    ~{aferrortxt.i 'AF' '1' '&1' '&2' ""'&3'""~}." + CHR(10) + CHR(10),
                                        pcTable,cField,cLabel,cConvert,cCompare,cCompar2)
                              ELSE
                                 SUBSTITUTE(
                                        "  IF &4b_&1.&2&5 OR &4b_&1.&2&6 THEN":U + CHR(10) +
                                        "    ASSIGN" + CHR(10) +
                                        "      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + " + CHR(10) + 
                                        "                    ~{aferrortxt.i 'AF' '1' '&1' '&2' ""'&3'""~}." + CHR(10) + CHR(10),
                                        pcTable,cField,cLabel,cConvert,cCompare,cCompar2).


  END.

  RETURN cValidate.

END FUNCTION.

FUNCTION getIndexFields RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  To return a comma delimited list of fields in an AK index
            for the passed in table - selecting best index
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cIndexInformation           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cIndexField                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturnFields               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hKeyBuffer                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField                      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCnt                        AS INTEGER    NO-UNDO.

/* Create buffer for passed in table */
  CREATE BUFFER hKeyBuffer FOR TABLE TRIM(pcTable) NO-ERROR.

  ASSIGN
    iLoop             = 0
    iCnt              = 0
    cIndexInformation = "":U
    cReturnFields     = "":U.

  find-index-loop:
  REPEAT WHILE cIndexInformation <> ?:
    ASSIGN
      iLoop = iLoop + 1
      cIndexInformation = hKeyBuffer:INDEX-INFORMATION(iLoop).
   IF ENTRY(2,cIndexInformation) = "1":U THEN
    DO iCnt = 5 TO NUM-ENTRIES(cIndexInformation) BY 2:
      ASSIGN
        cIndexField = TRIM(ENTRY(iCnt, cIndexInformation)).
      IF LOOKUP(cIndexField,cReturnFields) = 0 THEN
      DO:
        ASSIGN
          hField        = hKeyBuffer:BUFFER-FIELD(cIndexField)
          cReturnFields = cReturnFields + "," WHEN cReturnFields <> "":U
          cReturnFields = cReturnFields + cIndexField + "," + hField:DATA-TYPE + "," + hField:LABEL.
      END.
    END.

  END.

  DELETE OBJECT hKeyBuffer.
  ASSIGN hKeyBuffer = ?.
  RETURN cReturnFields.   /* Function return value. */

END FUNCTION.

FUNCTION getMandatoryFields RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  To return a comma delimited list of mandatory fields 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cReturnFields               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hKeyBuffer                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField                      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.

/* Create buffer for passed in table */
  CREATE BUFFER hKeyBuffer FOR TABLE TRIM(pcTable) NO-ERROR.

  ASSIGN
    cReturnFields     = "":U.

  find-field-loop:
  DO iLoop = 1 TO hKeyBuffer:NUM-FIELDS:

        ASSIGN
          hField        = hKeyBuffer:BUFFER-FIELD(iLoop).

        IF VALID-HANDLE(hField) AND hField:MANDATORY THEN
          ASSIGN
            cReturnFields = cReturnFields + "," WHEN cReturnFields <> "":U
            cReturnFields = cReturnFields + hField:NAME + "," + hField:DATA-TYPE + "," + hField:LABEL.
  END.

  DELETE OBJECT hKeyBuffer.
  ASSIGN hKeyBuffer = ?.
  RETURN cReturnFields.   /* Function return value. */

END FUNCTION.

FUNCTION editFixCRLF RETURNS LOGICAL:
/*------------------------------------------------------------------------------
  Purpose:  Changes all single CHR(10) to CR/LF so that template files saved on a unix 
            file system will not cause errors when read on a windows system
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VARIABLE lResult AS LOGICAL    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    eEdit:CURSOR-OFFSET = 1.
    IF eEdit:SEARCH(CHR(10),17) AND NOT eEdit:SEARCH(CHR(10) + CHR(13),17) THEN
      lResult = eEdit:REPLACE(CHR(10),CHR(10) + CHR(13),8).
    eEdit:CURSOR-OFFSET = 1.
  END.

  RETURN lResult.

END FUNCTION.
