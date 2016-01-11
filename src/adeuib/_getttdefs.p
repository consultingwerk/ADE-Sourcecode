&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: adeuib/_getttdefs.p
  Description:  returns temp-table defintions  
  Purpose:

  Parameters:   prRecid    - _P recid
                plAnalyze  - Determines whether temp-table include references are
                             encased in ANALYZER/SUSPEND, this is only done during 
                             real code generation as opposed to import of frames 
                             when dropping db fields onto design frames
                pcDefLine  - code segment
---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT  PARAMETER prPrecid  AS RECID      NO-UNDO.
DEFINE INPUT  PARAMETER plAnalyze AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcDefLine AS CHARACTER  NO-UNDO.

{adeuib/uniwidg.i}
{adeuib/sharvars.i}

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
         HEIGHT             = 6.14
         WIDTH              = 64.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VAR      addl_fields          AS CHARACTER  NO-UNDO.
DEFINE VAR      cSourceFile          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lFound               AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lOK                  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cSourceList          AS CHARACTER  NO-UNDO.
define variable cAnalyzerDefs        AS character  no-undo.
define variable cOutsideAnalyzerDefs as character  no-undo.

FIND _P WHERE RECID(_P) = prPRecid. 
FOR EACH _TT WHERE _TT._p-recid = prPRecid:
  CASE _TT._TABLE-TYPE:
    WHEN "T":U THEN DO:    /* TEMP-TABLES, via procedure properties */
      lFound = FALSE.
      IF CONNECTED ("TEMP-DB":U) THEN
      DO:
          RUN adeuib/_tempdbvalid.p (OUTPUT lok). /* Check that control file is present in TEMP-DB */
          IF lOK THEN
          DO:
            RUN adeuib/_tempdbfind.p(INPUT "TABLE":U,
                                     INPUT (IF _TT._LIKE-TABLE = ? THEN _TT._NAME ELSE  _TT._LIKE-TABLE ) ,
                                     OUTPUT cSourceFile).
            IF cSourceFile > "" AND LOOKUP(cSourceFile,cSourceList) > 0 THEN
               NEXT.
            IF cSourceFile NE ""  THEN
               ASSIGN cAnalyzerDefs    = cAnalyzerDefs + "~{":U + cSourceFile + "}":U + CHR(10) 
                      cSourceList = cSourceList + (If cSourceList = "" THEN "" ELSE ",") + cSourceFile
                      lFound      = true.
          END.            
      END.
      IF NOT lFound THEN
      DO:
         addl_fields = REPLACE(_TT._ADDITIONAL_FIELDS, CHR(10),
                              CHR(10) + "       ":U).
         cOutsideAnalyzerDefs = cOutsideAnalyzerDefs +
                       "DEFINE ":U + (IF _TT._SHARE-TYPE NE "" THEN
                    (_TT._SHARE-TYPE + " ":U) ELSE "") + "TEMP-TABLE " +
                    (IF _TT._NAME = ? THEN _TT._LIKE-TABLE ELSE _TT._NAME) +
                    (IF _TT._UNDO-TYPE = "NO-UNDO":U THEN " NO-UNDO":U ELSE "":U) +
                    " LIKE ":U + (IF _suppress_dbname THEN "" ELSE _TT._LIKE-DB + ".":U) +
                     _TT._LIKE-TABLE +
                    (IF _TT._ADDITIONAL_FIELDS NE "":U THEN (CHR(10) + "       ":U +
                     addl_fields + ".":U) ELSE ".") + CHR(10).
      END.              
    END.
    
    WHEN "B":U THEN DO:    /* BUFFERS via procedure props */
      cOutsideAnalyzerDefs = cOutsideAnalyzerDefs +
                 (IF _P._db-aware THEN  
                  "~{&DB-REQUIRED-START~}" + CHR(10) + " " ELSE "") 
                 +
                 "DEFINE ":U + (IF _TT._SHARE-TYPE NE "" THEN
                 (_TT._SHARE-TYPE + " ":U) ELSE "") + "BUFFER " + _TT._NAME + 
                 " FOR ":U + (IF _suppress_dbname THEN "" ELSE _TT._LIKE-DB + ".":U) +
                 _TT._LIKE-TABLE + ".":U + CHR(10)
                 + (IF _P._db-aware THEN  
                     "~{&DB-REQUIRED-END~}" + CHR(10) ELSE "").
    END.

    WHEN "D":U OR WHEN "W":U THEN DO:    /* DATA OBJECTS, WEB DATA OBJECTS */
      addl_fields = REPLACE(_TT._ADDITIONAL_FIELDS, CHR(10),
                           CHR(10) + "       ":U).
      
      IF _TT._NAME = "RowObject":U THEN
      DO: /* In case dataobject include file path contains spaces, we enclose
             its file reference in quotes. - jep */
          addl_fields = REPLACE(addl_fields, '~{', '~{"').
          addl_fields = REPLACE(addl_fields, '~}', '"~}').
      END.
      /* comma separated identifies include (don't need additional fields?) */     
      IF  NUM-ENTRIES(_P._data-object) > 1 THEN
      do:
        /* Don't include the same include more than once. */
        if lookup(addl_fields, cOutsideAnalyzerDefs, chr(10)) eq 0 then
            cOutsideAnalyzerDefs = cOutsideAnalyzerDefs + addl_fields + CHR(10). 
      end.    /* data object source */
      ELSE
        cOutsideAnalyzerDefs = cOutsideAnalyzerDefs + 
                 "DEFINE TEMP-TABLE " + _TT._NAME 
                 + (IF _TT._UNDO-TYPE = "NO-UNDO":U THEN " NO-UNDO":U ELSE "":U)
                 + (IF _TT._ADDITIONAL_FIELDS NE "":U 
                    THEN (CHR(10) + "       ":U + addl_fields + ".":U) 
                    ELSE ".") 
                 + CHR(10).
    END.
  END CASE.    /* _TT _Table-Type */
  
  /* Clean up output lines */
  IF cOutsideAnalyzerDefs MATCHES '*~{""}*':U OR cOutsideAnalyzerDefs = ? THEN
    cOutsideAnalyzerDefs = ''.  
  IF cAnalyzerDefs MATCHES '*~{""}*':U OR cAnalyzerDefs = ? THEN
    cAnalyzerDefs = ''.
END.    /* each _TT */
    
/* If an include was created from the temp-db maintenance utility and this is real code
   generation (plAnalyze is TRUE), encase in ANALYZE/SUPSEND */
IF cAnalyzerDefs gt '':u THEN
   pcDefLine = IF plAnalyze THEN
    "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _TEMP-TABLE " + CHR(10) +
    "/* ***********Included Temp-Table & Buffer definitions **************** */" + CHR(10) +
    cAnalyzerDefs + CHR(10) +
    "/* _UIB-CODE-BLOCK-END */" + CHR(10) +
    "&ANALYZE-RESUME" + CHR(10)
       ELSE cAnalyzerDefs.
   
/* Don't encase dataobject and non-include defs in analyze suspends */
if cOutsideAnalyzerDefs gt '':u then
    pcDefLine = pcDefLine + '~n':u
              + "/* Temp-Table and Buffer definitions                                    */"  + '~n':u
              + cOutsideAnalyzerDefs + '~n':u.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


