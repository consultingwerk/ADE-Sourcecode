/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* procedure to test appserver connection */

{src/adm2/globals.i}

DEFINE OUTPUT PARAMETER plRemote   AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pcConnid   AS CHARACTER NO-UNDO. /* SESSION:SERVER-CONNECTION-ID */
DEFINE OUTPUT PARAMETER pcOpmode   AS CHARACTER NO-UNDO. /* SESSION:SERVER-OPERATING-MODE */
DEFINE OUTPUT PARAMETER plConnReq  AS LOGICAL   NO-UNDO. /* SESSION:SERVER-CONNECTION-BOUND-REQUEST */
DEFINE OUTPUT PARAMETER plConnbnd  AS LOGICAL   NO-UNDO. /* SESSION:SERVER-CONNECTION-BOUND */
DEFINE OUTPUT PARAMETER pcConnctxt AS CHARACTER NO-UNDO. /* SESSION:SERVER-CONNECTION-CONTEXT */
DEFINE OUTPUT PARAMETER pcASppath  AS CHARACTER NO-UNDO. /* PROPATH */
DEFINE OUTPUT PARAMETER pcConndbs  AS CHARACTER NO-UNDO. /* List of Databases */
DEFINE OUTPUT PARAMETER pcCustomisationTypes        AS CHARACTER    NO-UNDO.    /* from CustomizatinManager */
DEFINE OUTPUT PARAMETER pcCustomisationReferences   AS CHARACTER    NO-UNDO.    /* from CustomizatinManager */
DEFINE OUTPUT PARAMETER pcCustomisationResultCodes  AS CHARACTER    NO-UNDO.    /* from CustomizatinManager */
DEFINE OUTPUT PARAMETER TABLE-HANDLE phTTParam.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phTTManager.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phTTServiceType.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phTTService.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phTTPersistentProcedure. /* List of Running Persistent Procedures */

DEFINE TEMP-TABLE ttPProcedure      NO-UNDO
    FIELD iSeq              AS INTEGER
    FIELD cProcedureName    AS CHARACTER
    INDEX pudx IS PRIMARY UNIQUE
          iSeq.

DEFINE VARIABLE iLoop                   AS INTEGER      NO-UNDO. /* Generic counter */
DEFINE VARIABLE hAS                     AS HANDLE       NO-UNDO. /* AppServer connection handle */
DEFINE VARIABLE cDBList                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cDBVersions             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hCustomizationManager   AS HANDLE       NO-UNDO.

ASSIGN
  plRemote   = SESSION:REMOTE
  pcConnid   = SESSION:SERVER-CONNECTION-ID
  pcOpmode   = SESSION:SERVER-OPERATING-MODE
  plConnReq  = SESSION:SERVER-CONNECTION-BOUND-REQUEST
  plConnbnd  = SESSION:SERVER-CONNECTION-BOUND
  pcConnctxt = SESSION:SERVER-CONNECTION-CONTEXT
  pcASppath   = PROPATH
  .

/* Generate list of connected databases */
ASSIGN cDBList = "":U.
DO iLoop = 1 TO NUM-DBS:
  ASSIGN cDBList = cDBList + (IF cDBList <> "":U THEN ",":U ELSE "":U) + LDBNAME(iLoop).
END.         
IF cDBList <> "":U AND VALID-HANDLE(gshGenManager) THEN
  RUN getDBVersion IN gshGenManager (INPUT cDBList, OUTPUT cDBVersions).


IF NUM-DBS > 0 THEN 
DO iLoop = 1 TO NUM-DBS:
  ASSIGN pcConndbs = pcConndbs + (IF pcConndbs NE "" THEN ",":U ELSE "") + LDBNAME(iLoop) + " (":U + PDBNAME(iLoop) + ")":U.
  IF cDBVersions <> "":U THEN
    ASSIGN pcConndbs = pcConndbs + " (Delta: ":U + ENTRY(iLoop, cDBVersions) + ")":U.
END.

/* Generate a list of running persistent procedures */
hAS = SESSION:FIRST-PROCEDURE.
iLoop = 0.
DO WHILE hAS <> ?:
  IF hAS:PERSISTENT THEN
  DO:
      iLoop = iLoop + 1.
      CREATE ttPProcedure.
      ASSIGN ttPPRocedure.iSeq = iLoop
             ttPProcedure.cProcedureName = hAS:FILE-NAME.
             
  END.
  hAS = hAS:NEXT-SIBLING.
END.
phTTPersistentProcedure = TEMP-TABLE ttPProcedure:HANDLE.

/* Get the connections and config manager temp-tables */
RUN obtainCFMTables        IN THIS-PROCEDURE ( OUTPUT phTTParam, OUTPUT phTTManager).
RUN obtainConnectionTables IN THIS-PROCEDURE ( OUTPUT phTTServiceType, OUTPUT phTTService).

/* Get customisation information. */
ASSIGN hCustomizationManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE, "CustomizationManager":U) NO-ERROR.

IF VALID-HANDLE(hCustomizationManager) THEN
    ASSIGN pcCustomisationTypes       = DYNAMIC-FUNCTION("getCustomisationTypesPrioritised":U IN hCustomizationManager)
           pcCustomisationReferences  = DYNAMIC-FUNCTION("getSessionCustomisationReferences":U IN hCustomizationManager)
           pcCustomisationResultCodes = DYNAMIC-FUNCTION("getSessionResultCodes":U IN hCustomizationManager)
           .

RETURN.
