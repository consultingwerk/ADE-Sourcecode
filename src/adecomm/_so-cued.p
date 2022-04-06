/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _so-cued.p


    Purpose:    Dismiss cue card window upon .W close (XFTR)
                (See adecomm/_so-cue.w for XFTR definition)
                
    Parameters: trg-recid (INT) - RECID(_TRG)
                trg-Code (CHAR) - code block

    Description:
    Notes  :
    Authors: Gerry Seidl
    Date   : 3/15/95
**************************************************************************/

DEFINE INPUT        PARAMETER trg-recid AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER trg-code  AS CHARACTER NO-UNDO.

DEFINE VARIABLE h                       AS WIDGET    NO-UNDO.
DEFINE VARIABLE hnext                   AS WIDGET    NO-UNDO.
DEFINE VARIABLE c                       AS INTEGER   NO-UNDO.
DEFINE VARIABLE cnt                     AS INTEGER   NO-UNDO.
DEFINE VARIABLE firstline               AS CHARACTER NO-UNDO.
DEFINE VARIABLE i                       AS INTEGER   NO-UNDO.
DEFINE VARIABLE subject                 AS CHARACTER NO-UNDO.
DEFINE VARIABLE tcode                   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cProcList               AS CHARACTER NO-UNDO.
DEFINE VARIABLE cProcType               AS CHARACTER NO-UNDO.

ASSIGN   
   h         = SESSION:FIRST-PROCEDURE
   tcode     = TRIM(trg-code)
   firstline = ENTRY(1,tcode,CHR(10))
   subject   = TRIM(SUBSTRING(firstline,3,
                 LENGTH(firstline,"CHARACTER":u) - 2,"CHARACTER")).

IF NUM-ENTRIES(subject) > 1 THEN ASSIGN subject = ENTRY(1,subject).

/* If there is more than one of this type up, leave it up.  Get a list of
   Procedures from the UIB and check each type. */
RUN adeuib/_uibinfo.p (INPUT ?,               /* pi_context: not known      */
                       INPUT "SESSION",       /* p_name: get "Session" info */
                       INPUT "PROCEDURES",    /* p_request: all proc. id's  */
                       OUTPUT cProcList).
cnt = NUM-ENTRIES (cProcList).
DO i = 1 TO cnt:
  /* Get the type of each procedure */
  RUN adeuib/_uibinfo.p (INPUT INTEGER(ENTRY(i,cProcList)),  /* context */
                         INPUT ?,                            /* not needed */
                         INPUT "TYPE",                       /* request */
                         OUTPUT cProcType).
   IF cProcType eq subject THEN c = c + 1.
END.

IF c > 1 THEN RETURN.

DO WHILE VALID-HANDLE(h):
  IF ENTRY(1,h:PRIVATE-DATA) = "CUE-CARD " AND
     ENTRY(2,h:PRIVATE-DATA) = subject     THEN 
  DO:
    ASSIGN hnext = h:NEXT-SIBLING.
    APPLY "CLOSE" TO h.   
  END.
  IF VALID-HANDLE(h) THEN
    ASSIGN h = h:NEXT-SIBLING.  
  ELSE h = hnext.
END.
RETURN.
