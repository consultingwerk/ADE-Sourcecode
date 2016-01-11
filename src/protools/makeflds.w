&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
/*--------------------------------------------------------------------------
    File        : protools/makeflds.w
    Purpose     : To generate a space delimited list of fields from 
                  a comma delimited list of tables

    Syntax      : RUN protools/makeflds.w (INPUT incFile, INPUT tblList,
                           OUTPUT fldList, OUTPUT asnList, OUTPUT fldRebuild)

    Description : This procedure does 4 things:
                  1) Generates a space delimited list of unique field
                     names (fldList) from a comma delimited list of
                     tables (tblList)
                  2) Generates a space delimited list of assignments of
                     fields that occur in more than 1 table
                  3) Generates a SmartData object style include file
                     (named incFile) that has field definitions in it.
                  4) Generates the structured comment (fldRebuild) needed
                     to reconstruct the SmartData Object's field information
                     when read back into the UIB.

    Author(s)   : Ross Hunter
    Created     : March 18, 1998
    Notes       : This is only called when at least one database is connected
    
    Modified    : 04/13/99  tsm  Added support for various Intl Numeric
                                 formats (in addition to American and 
                                 European) by using set-numeric-format
                                 method to set format back to user's setting
        
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT  PARAMETER incFile    AS CHARACTER                   NO-UNDO.
DEFINE INPUT  PARAMETER tblList    AS CHARACTER                   NO-UNDO.
DEFINE OUTPUT PARAMETER fldList    AS CHARACTER                   NO-UNDO.
DEFINE OUTPUT PARAMETER fListByTbl AS CHARACTER                   NO-UNDO.
DEFINE OUTPUT PARAMETER asnList    AS CHARACTER                   NO-UNDO.
DEFINE OUTPUT PARAMETER fldRbld    AS CHARACTER                   NO-UNDO.

DEFINE VARIABLE cl_file       AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE ext           AS INTEGER                          NO-UNDO.
DEFINE VARIABLE fldCnt        AS INTEGER                          NO-UNDO.
DEFINE VARIABLE flddef        AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE i             AS INTEGER                          NO-UNDO.
DEFINE VARIABLE listPos       AS INTEGER                          NO-UNDO.
DEFINE VARIABLE tblName       AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE SaveSeparator AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE SaveDecimal   AS CHARACTER                        NO-UNDO.

DEFINE STREAM incfl.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN SaveSeparator          = SESSION:NUMERIC-SEPARATOR
       SaveDecimal            = SESSION:NUMERIC-DECIMAL-POINT
       SESSION:NUMERIC-FORMAT = "AMERICAN".
DO i = 1 TO NUM-ENTRIES(tblList):      /* Loop through the tables       */
  tblName = ENTRY(i,tblList).
  IF NUM-ENTRIES(tblName, ".") = 2 THEN
    ASSIGN tblName = ENTRY(2, tblName, ".").  /* Strip off the dbname if there */
  FIND _FILE WHERE _FILE._FILE-NAME = tblName NO-ERROR.
  IF AVAILABLE _FILE THEN DO:
    ASSIGN fListByTbl = (IF fListByTBL NE "" THEN fListByTbl + CHR(10) ELSE "") +
                        "~&Scoped-define ENABLED-FIELDS-IN-" + _FILE._FILE-NAME + " ".
    FOR EACH _FIELD OF _FILE:
      IF _FIELD._EXTENT EQ 0 THEN DO:
        listPos = LOOKUP(_FIELD._FIELD-NAME, fldList, " ").
        IF listPos eq 0 THEN
          ASSIGN fldCnt  = fldCnt + 1
                 fldList = fldList + _FIELD._FIELD-NAME + " "
                 fListByTbl = fListByTbl + _FIELD._FIELD-NAME + " "
                 flddef  = flddef + (IF fldCnt > 1 THEN CHR(10) ELSE "") +
                           "  FIELD " + _FIELD._FIELD-NAME + " LIKE " +
                           tblName + "." + _FIELD._FIELD-NAME + " VALIDATE ~~"
                 fldRbld = fldRbld + (IF fldCnt > 1 THEN CHR(10) ELSE "") +
                           "     _FldNameList[" + STRING(fldCnt) + "]   > " +
                           LDBNAME("DICTDB") + "." + tblName + "." + 
                           _FIELD._FIELD-NAME + CHR(10) +
                           '"' + _FIELD._FIELD-NAME + '" ' +
                           '"' + _FIELD._FIELD-NAME + '" ? ? "' +
                           _FIELD._DATA-TYPE + '" ? ? ? ? ? ? yes ? no ' +
                           (IF _FIELD._DATA-TYPE = "DATE" THEN
                               STRING(FONT-TABLE:GET-TEXT-WIDTH-CHARS(_FIELD._FORMAT))
                            ELSE IF _FIELD._DATA-TYPE BEGINS "C" THEN
                               STRING(LENGTH(STRING("A",_FIELD._FORMAT), "RAW":U))
                            ELSE IF _FIELD._DATA-TYPE BEGINS "L" THEN
                               STRING(MAXIMUM(FONT-TABLE:GET-TEXT-WIDTH-CHARS(STRING(YES,_FIELD._FORMAT)),
                                        FONT-TABLE:GET-TEXT-WIDTH-CHARS(STRING(NO, _FIELD._FORMAT))))
                            ELSE STRING(FONT-TABLE:GET-TEXT-WIDTH-CHARS(_FIELD._FORMAT))) +
                            " yes no no no no no no".
        ELSE
          ASSIGN asnList = asnList + "rowObject." + _FIELD._FIELD-NAME + " = " +
                           ENTRY(4, ENTRY(listPos, flddef, CHR(10)), " ") + " ".
      END.  /* If a scalar field */
      ELSE DO:  /* An array field */
        listPos = LOOKUP(_FIELD._FIELD-NAME + "1", fldList, " ").
        IF listPos eq 0 THEN DO:
          DO ext = 1 TO _FIELD._EXTENT:
            ASSIGN fldCnt  = fldCnt + 1
                   fldList = fldList + _FIELD._FIELD-NAME + STRING(ext) + " "
                   fListByTbl = fListByTbl + _FIELD._FIELD-NAME + STRING(ext) + " "
                   flddef  = flddef + (IF fldCnt > 1 THEN CHR(10) ELSE "") +
                             "  FIELD " + _FIELD._FIELD-NAME + STRING(ext) + " LIKE " +
                             tblName + "." + _FIELD._FIELD-NAME + "[" + STRING(ext) +
                                           "] VALIDATE ~~"
                   fldRbld = fldRbld + (IF fldCnt > 1 THEN CHR(10) ELSE "") +
                             "     _FldNameList[" + STRING(fldCnt) + "]   > " +
                             LDBNAME("DICTDB") + "." + tblName + "." + 
                             _FIELD._FIELD-NAME + "[" + STRING(ext) + "]" + CHR(10) +
                             '"' + _FIELD._FIELD-NAME + "[" + STRING(ext) + ']" ' +
                             '"' + _FIELD._FIELD-NAME + STRING(ext) + '" ? ? "' +
                             _FIELD._DATA-TYPE + '" ? ? ? ? ? ? yes ? no ' +
                             (IF _FIELD._DATA-TYPE = "DATE" THEN
                                 STRING(FONT-TABLE:GET-TEXT-WIDTH-CHARS(_FIELD._FORMAT))
                              ELSE IF _FIELD._DATA-TYPE BEGINS "C" THEN
                                 STRING(LENGTH(STRING("A",_FIELD._FORMAT), "RAW":U))
                             ELSE IF _FIELD._DATA-TYPE BEGINS "L" THEN
                                 STRING(MAXIMUM(FONT-TABLE:GET-TEXT-WIDTH-CHARS(STRING(YES,_FIELD._FORMAT)),
                                          FONT-TABLE:GET-TEXT-WIDTH-CHARS(STRING(NO, _FIELD._FORMAT))))
                              ELSE STRING(FONT-TABLE:GET-TEXT-WIDTH-CHARS(_FIELD._FORMAT))) +
                              " yes no no no no no no".
         END. /* ext = 1 to extent */
        END. /* If it isn't all ready in the list */                 
        ELSE
          ASSIGN asnList = asnList + "rowObject." + _FIELD._FIELD-NAME + " = " +
                           ENTRY(4, ENTRY(listPos, flddef, CHR(10)), " ") + " ".
        
      END.  /* Else an array field */
    END. /* FOR EACH _FIELD */
  END. /* If we found the _FILE record of the table */
END.  /* For all tables in the list */

/* Trim of the final space */
ASSIGN fldList                = TRIM(fldList)
       fListByTbl             = TRIM(fListByTbl)
       asnList                = TRIM(asnList)
       flddef                 = TRIM(flddef,"~~").
       
SESSION:SET-NUMERIC-FORMAT(SaveSeparator,SaveDecimal).

/* Write out the associated include file */
OUTPUT STREAM incfl TO VALUE(incFile).
PUT STREAM incfl UNFORMATTED flddef SKIP.
OUTPUT STREAM incfl CLOSE.

/* Write out the associated proxy file */
cl_file = ENTRY(1, incFile,".":U) + "_cl.w".
OUTPUT STREAM incfl TO VALUE(cl_file).
PUT STREAM incfl UNFORMATTED "/* " + cl_file + " - non-db proxy for " +
                 ENTRY(1, cl_file, "_":U) + ".w */" SKIP (1)
                 "~&GLOBAL-DEFINE DB-REQUIRED FALSE" SKIP (1)
                 "~{" + ENTRY(1, cl_file, "_":U) + ".w~}" SKIP.
OUTPUT STREAM incfl CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


