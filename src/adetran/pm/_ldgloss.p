/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_ldgloss.p
Author:       R. Ryan
Created:      1/95
Updated:      9/95
Purpose:      Consolidates glossary
Background:   This is one of the more important procedures which
              consolidates source/target glossaries from the kit into the
              project database.  A companion program, _ldtran.p
              consolidates the translations.
              
Notes:        This procedure works only if kit.XL_Project.GlossaryCount
              is > 0. Conflicts can arrise *if* there is an existing
              translation in the project database that is different than
              the incoming translation.  In this case, this procedure
              uses the conflict method that was defined in pm/_consol.w:

                o Keep newer stuff ......... The kit overwrites the project        
                o Keep older stuff ......... The project data wins over the kit and
                                             the kit data is tossed aside
                o Ask about each conflict .. A conflict resolution dialog is
                                             displayed.  Once evaluated, either
                                             of the first two conditions are met.
  
Called by:    pm/_consol.w  
Calls:        pm/_resolve.w (resolves conflicts)
*/


DEFINE INPUT PARAMETER  pGlossary      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pErrorStatus   AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER gloss-message  AS CHARACTER NO-UNDO.

DEFINE SHARED VARIABLE _hGloss         AS HANDLE    NO-UNDO. 
DEFINE SHARED VARIABLE s_Glossary      AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE StopProcessing  AS LOGICAL   NO-UNDO.
DEFINE SHARED VARIABLE _hMeter         AS HANDLE    NO-UNDO.

DEFINE VARIABLE CreateNew              AS INTEGER   NO-UNDO.
DEFINE VARIABLE OKPressed              AS LOGICAL   NO-UNDO.
DEFINE VARIABLE i                      AS INTEGER   NO-UNDO.
DEFINE VARIABLE NumGloss               AS INTEGER   NO-UNDO.
DEFINE VARIABLE ThisGloss              AS CHARACTER NO-UNDO.
DEFINE VARIABLE ThisMessage            AS CHARACTER NO-UNDO.
DEFINE VARIABLE ErrorStatus            AS LOGICAL   NO-UNDO.

/* Initialize */
RUN adecomm/_setcurs.p ("WAIT":U).
ASSIGN s_glossary      = pGlossary
       StopProcessing  = FALSE.
FOR EACH kit.XL_GlossEntry WHERE kit.XL_GlossEntry.ModifiedByTranslator NO-LOCK:
  NumGloss = NumGloss + 1.
END.
RUN adecomm/_setcurs.p ("").
RUN Realize IN _hMeter ("Updating Glossary...").

/* Find each instance where a translation exists */
FOR EACH kit.XL_GlossEntry WHERE kit.XL_GlossEntry.ModifiedByTranslator NO-LOCK:
  PROCESS EVENTS.
  IF StopProcessing THEN DO:
    RUN HideMe IN _hMeter.
    RETURN.
  END.
        
  i = i + 1. 
  IF i MOD 100 = 0 THEN 
  RUN SetBar IN _hMeter (NumGloss, i, kit.XL_GlossEntry.TargetPhrase).

  IF NOT CAN-FIND(FIRST xlatedb.XL_GlossDet WHERE 
         xlatedb.XL_GlossDet.GlossaryName = pGlossary AND
         xlatedb.XL_GlossDet.ShortSrc     BEGINS  kit.XL_GlossEntry.ShortSrc AND
         xlatedb.XL_GlossDet.SourcePhrase MATCHES kit.XL_GlossEntry.SourcePhrase AND
         xlatedb.XL_GlossDet.ShortTarg    BEGINS kit.XL_GlossEntry.ShortTarg AND
         xlatedb.XL_GlossDet.TargetPhrase MATCHES kit.XL_GlossEntry.TargetPhrase) THEN
  DO TRANSACTION:
    CREATE xlatedb.XL_GlossDet.
    BUFFER-COPY kit.XL_GlossEntry TO xlatedb.XL_GlossDet.
    ASSIGN CreateNew                                = CreateNew + 1 
           xlatedb.XL_GlossDet.GlossaryName         = pGlossary.
  END.  /* DO TRANSACTION */
END.  /* for loop */
RUN HideMe IN _hMeter.  
  
gloss-message = STRING(CreateNew) + " glossary items were added.".

/* Count the glossary items */   
RUN CountEntries IN _hGloss (INPUT pGlossary, OUTPUT NumGloss).
DO TRANSACTION:
  FIND xlatedb.XL_Glossary WHERE xlatedb.XL_Glossary.GlossaryName = pGlossary
                           EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE xlatedb.XL_Glossary THEN xlatedb.XL_Glossary.GlossaryCount = NumGloss.
END.
pErrorStatus = FALSE.
RETURN.
