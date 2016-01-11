&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2001 by Progress Software Corporation ("PSC"),       *
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
*   Per S Digre (pdigre@progress.com)                                *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : appdoc.p
    Purpose     : Application documentation utility
    Updated     : 10/27/00 pdigre@progress.com
                    Initial version
                  04/27/01 adams@progress.com
                    WebSpeed integration
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{src/web/method/cgidefs.i}  

DEFINE INPUT PARAMETER pFile AS CHARACTER NO-UNDO.  

DEFINE NEW GLOBAL SHARED VARIABLE hHTML AS HANDLE NO-UNDO.  

DEFINE VARIABLE cLineData  AS CHARACTER  NO-UNDO.  
DEFINE VARIABLE cLineData2 AS CHARACTER  NO-UNDO.  
DEFINE VARIABLE cOut       AS CHARACTER  NO-UNDO.  
DEFINE VARIABLE cOut2      AS CHARACTER  NO-UNDO.  
DEFINE VARIABLE i1         AS INTEGER    NO-UNDO.  
DEFINE VARIABLE iLine      AS INTEGER    NO-UNDO.  
DEFINE VARIABLE iComment   AS INTEGER    NO-UNDO.  
DEFINE VARIABLE iBlock     AS INTEGER    NO-UNDO.  
DEFINE VARIABLE iBLines    AS INTEGER    NO-UNDO.  
DEFINE VARIABLE iMLines    AS INTEGER    NO-UNDO.  
DEFINE VARIABLE cTemp      AS CHARACTER  NO-UNDO.  
DEFINE VARIABLE cType      AS CHARACTER  NO-UNDO.  
DEFINE VARIABLE iLastProc  AS INTEGER    NO-UNDO.  
DEFINE VARIABLE lHeader    AS LOGICAL    NO-UNDO INITIAL TRUE.  
  
DEFINE TEMP-TABLE tLine  
   FIELDS t-line    AS INTEGER  
   FIELDS t-block   AS INTEGER  
   FIELDS t-comment AS INTEGER  
   FIELDS t-type    AS CHARACTER  
   FIELDS t-extra   AS CHARACTER  
   FIELDS t-data    AS CHARACTER.  

DEFINE BUFFER bLine FOR tLine.  

DEFINE STREAM sIni.  

FUNCTION fRow        RETURNS CHARACTER 
  ( cData AS CHARACTER ) IN hHTML.  
FUNCTION fBeginTable RETURNS CHARACTER
  ( cLabels AS CHARACTER ) IN hHTML.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fCreateLine) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCreateLine Procedure 
FUNCTION fCreateLine RETURNS CHARACTER
  ( cType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fSet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSet Procedure 
FUNCTION fSet RETURNS CHARACTER
  ( cIdent AS CHARACTER, 
    pType AS CHARACTER )  FORWARD.

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

RUN amDoc(pFile).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-amDoc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE amDoc Procedure 
PROCEDURE amDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pFile AS CHARACTER NO-UNDO.  

  {&OUT} '<BR CLASS=page><H2>Program: '  pFile  '</h2>~n'.  

  /***** Read the input data ********/  
  INPUT STREAM sIni FROM VALUE(pFile).  
  REPEAT:  
    ASSIGN cLineData = "".  
    IMPORT STREAM sIni UNFORMATTED cLineData.  
    ASSIGN 
      iLine     = iLine + 1  
      cLineData = REPLACE(REPLACE(cLineData,CHR(9)," "),'|','').  
  
    IF INDEX(cLineData,"/~*") > 0 THEN 
      iComment = iComment + 1.  
  
    IF INDEX(cLineData,"*~/") > 0 THEN DO:  
      ASSIGN 
        iComment = iComment - 1
        lHeader  = FALSE.  

      fCreateLine("Comm").  
      IF iComment > 0 THEN NEXT.  
    END.  
  
    IF iComment > 0 THEN DO:  
      fCreateLine("Comm").  
      NEXT.  
    END.  
  
    IF cLineData MATCHES "*RUN *"         THEN fCreateLine("RUN").  
    IF cLineData MATCHES "*~{inc*"        THEN fCreateLine("inc").  
    IF cLineData MATCHES "* INPUT PARAM*" THEN fCreateLine("INPT").  
    ASSIGN cLineData   = TRIM(cLineData).  
  
    IF cLineData BEGINS "FUNCTION " THEN DO:  
      IF iBLines = 0 AND iLastProc > 0 THEN DO:  
        FIND tLine WHERE t-line = iLastProc.  
        ASSIGN t-extra = "Error (Not closed)".  
      END.  
      ASSIGN iBLines = 1  
             iLastProc = iLine.  
      fCreateLine("FUNC").  
    END.  

    IF cLineData BEGINS "PROCEDURE " THEN DO:  
      IF iBLines = 0 AND iLastProc > 0 THEN DO:  
        FIND tLine WHERE t-line = iLastProc.  
        ASSIGN t-extra = "Error (Not closed)".  
      END.  
      ASSIGN iBLines = 1  
             iLastProc = iLine.  
      fCreateLine("PROC").  
    END.  
  
    IF cLineData BEGINS "END FUNCTION" THEN DO:  
      FIND tLine WHERE t-line = iLastProc.  
      IF AVAILABLE tLine THEN t-extra = STRING(iBLines) + " lines.".  
      ASSIGN iBLines = 0  
             iLastProc = 0.  
    END.  
  
    IF cLineData BEGINS "END PROCEDURE" THEN DO:  
      FIND tLine WHERE t-line = iLastProc.  
      IF AVAILABLE tLine THEN t-extra = STRING(iBLines) + " lines.".  
      ASSIGN iBLines = 0  
             iLastProc = 0.  
    END.  
    IF iBLines > 0 THEN iBLines = iBLines + 1.  
                   ELSE iMLines = iMLines + 1.  
  END.  
  INPUT STREAM sIni CLOSE.  
  ASSIGN 
    cOut = ""  
    cLineData  = "".  
  
  /* RCS History Section Preparation */  
  FOR EACH tLine EXCLUSIVE-LOCK 
    WHERE t-type = "head" AND t-data BEGINS "Revision "  
    BY t-line TRANSACTION:  
    FIND bLine EXCLUSIVE-LOCK WHERE bLine.t-line = tLine.t-line + 1.  
  
    ASSIGN tLine.t-data = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(tLine.t-data,"    "," "),"    "," "),"  "," "),"  "," ")," ","|")  
                        + "|" + REPLACE(bLine.t-data,"|","!")  
           tLine.t-type = "Rev".  
    DELETE bLine.  
  END.  
  
  /* Header Section */  
  {&OUT} fBeginTable("Header|Info").  

  FOR EACH tLine EXCLUSIVE-LOCK WHERE  
           tLine.t-type = "head" BY tLine.t-line TRANSACTION:  
    ASSIGN cOut = REPLACE(tLine.t-data," ","").  
    IF cOut BEGINS "Modification" THEN
      ASSIGN  
        tLine.t-data = REPLACE(tLine.t-data,"Modification","")  
        cOut         = REPLACE(tLine.t-data," ","").  

    fSet("File:","head1a").  
    fSet("Created:","head1b").  
    fSet("$Header:","Head2a").  
    fSet("Author(s):","head3a").  
    fSet("Syntax:","head3b").  
    fSet("Purpose:","head4a").  
    fSet("Description:","head5a").  
    fSet("Notes:","head6a").  
    fSet("Modification History:","head7a").  
    fSet("Modification","head7a").  
    fSet("History:","head7a").  
    fSet("$Log:","delete").  
    fSet("/~*----","delete").  
    fSet("------","delete").  
    fSet("*****","delete").  

    ASSIGN tLine.t-type = cType.  

    IF cType BEGINS "delete" OR LENGTH(TRIM(tLine.t-data)) < 5 THEN 
      DELETE tLine.  
  END.  
  
  FOR EACH tLine EXCLUSIVE-LOCK 
    WHERE tLine.t-type BEGINS "head"  
    BREAK BY tLine.t-type BY tLine.t-line TRANSACTION:  

    ASSIGN cOut = cOut + (IF cOut > "" THEN '<BR>' /* "||" */ ELSE "") + tLine.t-data.  
    IF LAST-OF(tLine.t-type) THEN DO:  
      {&OUT} fRow(ENTRY(2,tLine.t-type + ",#") + "|" + cOut).  
      ASSIGN cOut = "".  
    END.  
    DELETE tLine.  
  END.  
  {&OUT} "</TABLE>" SKIP.  
  
  /**** Program lines *********/  
  CREATE tLine.  
  ASSIGN tLine.t-data  = "MAIN CODE BLOCK"  
         tLine.t-extra = STRING(iMLines) + " lines."  
         iLastProc = 0.  
  
  {&OUT} fBeginTable("Line| " + STRING(iLine) + " lines|Code").  
  FOR EACH tLine NO-LOCK WHERE tLine.t-type <> "Rev" BY tLine.t-block BY tLine.t-line:  
    IF tLine.t-comment > 0 THEN
      {&out} fRow(STRING(tLine.t-line,">>>9") + " | " + tLine.t-extra + " | |8" + tLine.t-data + "|9").  
    ELSE 
      {&out} fRow(STRING(tLine.t-line,">>>9") + " | " + tLine.t-extra + " | "   + tLine.t-data).  
  END.  
  {&OUT} "</TABLE>" SKIP.  
  
  /***** RCS History Section Writing *******/  
  {&OUT} fBeginTable("Rev|Date|Time|User|RCS - Revision Comment").  
  FOR EACH tLine EXCLUSIVE-LOCK WHERE tLine.t-type = "Rev" BY tLine.t-line:  
    {&OUT} fRow(TRIM(SUBSTRING(tLine.t-data,10))).  
    DELETE tLine.  
  END.  
  {&OUT} "</TABLE>" SKIP.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fCreateLine) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCreateLine Procedure 
FUNCTION fCreateLine RETURNS CHARACTER
  ( cType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF cType = "Comm" AND lHeader THEN 
    cType = "Head".  
  IF iComment > 0 AND cType = "Comm" THEN
    cLineData2 = cLineData2 + TRIM(html-encode(cLineData)) + " || ".  
  ELSE DO:  
    /* Double '$$' marks comment section for reporting */  
    IF cType <> "Comm" THEN  
    DO TRANSACTION:  
      CREATE tLine.  
      ASSIGN  
           t-line    = iLine  
           t-block   = iLastProc  
           t-Comment = IF cType = "Comm" THEN 1 ELSE 0  
           t-type    = cType  
           t-data    = cLineData2 + html-encode(cLineData).  
    END.  
    ASSIGN cLineData2 = "".  
  END.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fSet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSet Procedure 
FUNCTION fSet RETURNS CHARACTER
  ( cIdent AS CHARACTER, 
    pType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Create a data row line
    Notes:  
------------------------------------------------------------------------------*/

  IF cOut BEGINS cIdent THEN DO:  
    ASSIGN 
      cType         = pType + ",":U + cIdent  
       tLine.t-data = TRIM(REPLACE(tLine.t-data,REPLACE(cIdent,":",""),"")).  

    IF tLine.t-data BEGINS ":" THEN 
      tLine.t-data = TRIM(SUBSTRING(tLine.t-data,2)).  
  END.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

