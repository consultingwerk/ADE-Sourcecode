/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_ldtran.p
Author:       R. Ryan/
Created:      1/95
Updated:      9/95
Purpose:      Consolidates translations
Background:   This is one of the more important procedures which
              consolidates translations from the kit into the
              project database.  A companion program, _ldgloss.p
              consolidates the glossary.

Notes:        This procedure works only if kit.XL_Project.TranslationCount
              is > 0. Conflicts can arrise *if* there is an existing
              translation in the project database that is different than
              the incoming translation.  In this case, this procedure
              uses the conflict method that was defined in pm/_consol.w:

                o Keep newer stuff ......... The kit overwrites the project
                o Keep older stuff ......... The project data wins over the kit and
                                             the kit data is toss aside
                o Ask about each conflict .. A conflict resolution dialog is
                                             displayed.  Once evaluated, either
                                             of the first two conditions are met.

Called by:    pm/_consol.w
Calls:        pm/_resolve.w (resolves conflicts)
*/


DEFINE INPUT PARAMETER  pReconcileType AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  pKitName       AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  pLanguage      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pErrorStatus   AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER trans-message  AS CHARACTER NO-UNDO.

DEFINE SHARED VARIABLE StopProcessing  AS LOGICAL   NO-UNDO.
DEFINE SHARED VARIABLE _hMeter         AS HANDLE    NO-UNDO.
DEFINE SHARED VARIABLE _hTrans         AS HANDLE    NO-UNDO.
DEFINE SHARED VARIABLE CurrentMode     AS INTEGER   NO-UNDO.

DEFINE VARIABLE CreateNew     AS INTEGER            NO-UNDO.
DEFINE VARIABLE ErrorStatus   AS LOGICAL            NO-UNDO.
DEFINE VARIABLE i             AS INTEGER            NO-UNDO.
DEFINE VARIABLE NumProcs      AS INTEGER            NO-UNDO.
DEFINE VARIABLE NumTrans      AS INTEGER            NO-UNDO.
DEFINE VARIABLE OKPressed     AS LOGICAL            NO-UNDO.
DEFINE VARIABLE ProjString    AS CHARACTER          NO-UNDO.
DEFINE VARIABLE RejectNew     AS INTEGER            NO-UNDO.
DEFINE VARIABLE ResolveType   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE srcString     AS CHARACTER          NO-UNDO.
DEFINE VARIABLE ThisMessage   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE ThisRec       AS INTEGER            NO-UNDO.
DEFINE VARIABLE ThisTrans     AS CHARACTER          NO-UNDO.
DEFINE VARIABLE TimeDateStamp AS DECIMAL            NO-UNDO.
DEFINE VARIABLE TransString   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE UpdateNew     AS INTEGER            NO-UNDO.


/* Initialize */
FIND FIRST kit.XL_Project NO-LOCK NO-ERROR.
IF NOT AVAILABLE kit.XL_Project THEN RETURN.

ASSIGN NumProcs        = kit.XL_Project.NumberOfProcedures
       NumTrans        = kit.XL_Project.TranslationCount
       StopProcessing  = FALSE
       TimeDateStamp   = INTEGER(TODAY) + (TIME / 100000).

IF NumTrans = 0 THEN DO:
  ThisMessage = "There aren't any translations to consolidate.".
  RUN adecomm/_s-alert.p (input-output ErrorStatus, "w*":u, "ok":u, ThisMessage).
  RETURN.
END.

ASSIGN ThisRec = 0.
RUN Realize IN _hMeter ("Updating Procedures...").

OPEN QUERY kitProcedure FOR EACH kit.XL_Procedure NO-LOCK.
Update-Proc:
REPEAT TRANSACTION:

   DO i = 1 TO 100: /* Block for 100 Procedures */
      GET NEXT KitProcedure.
      IF AVAILABLE kit.XL_Procedure THEN 
      DO:
         PROCESS EVENTS.
         IF StopProcessing THEN DO:
            RUN HideMe IN _hMeter.
            RETURN.
         END.
      
         ASSIGN ThisRec = ThisRec + 1.
         IF ThisRec MOD 100 = 0 THEN 
         RUN SetBar IN _hMeter (NumProcs,ThisRec, kit.XL_Procedure.FileName).
         FIND  xlatedb.XL_Procedure WHERE
               xlatedb.XL_Procedure.Directory = kit.XL_Procedure.Directory AND
               xlatedb.XL_Procedure.FileName  = kit.XL_Procedure.FileName
            EXCLUSIVE-LOCK NO-ERROR.
         FIND xlatedb.XL_Kit-Proc WHERE 
                   xlatedb.XL_Kit-Proc.KitName   = pKitName 
               AND xlatedb.XL_Kit-Proc.FileName  = kit.XL_Procedure.Filename
               AND xlatedb.XL_Kit-Proc.Directory = kit.XL_Procedure.Directory
         EXCLUSIVE-LOCK.
         IF AVAILABLE xlatedb.XL_Procedure THEN
            ASSIGN xlatedb.XL_Procedure.CurrentStatus = kit.XL_Procedure.CurrentStatus
                   xlatedb.XL_Kit-Proc.CurrentStatus  = kit.XL_Procedure.CurrentStatus.
       END. /* IF AVAILABLE kitProcedure */
     ELSE LEAVE Update-Proc.
   END. /* DO i = 1 TO 100 */
END.  /* REPEAT Kit.XL_Procedure */
RUN HideMe IN _hMeter.

RUN Realize IN _hMeter ("Updating Translations...").
ASSIGN ThisRec = 0.
/* Note that we can not use ShortTarg for the comparison since
 * in theory you could have a string longer that 63 chars where
 * its first 63 chars are "" */
FOR EACH kit.XL_Instance WHERE kit.XL_Instance.ShortTarg <> ""
                           AND kit.XL_Instance.TargetPhrase <> "" NO-LOCK:
  ThisRec = ThisRec + 1.

  /* *******************************************************
   *           Update Translations  
   * *******************************************************/
  {adetran/pm/ldtran.i
     &NumTrans             = NumTrans 
     &InTargetPhrase       = kit.XL_Instance.TargetPhrase
     &InSequenceNumber     = kit.XL_Instance.SequenceNumber
     &InInstanceNumber     = kit.XL_Instance.InstanceNumber
     &InLang_Name          = pLanguage
     &InReconcileType      = pReconcileType
     &RejectNew            = RejectNew
     &CreateNew            = CreateNew
     &UpdateOld            = UpdateNew
     &DeleteOld            = i
     &StopProcessingAction = "RETURN"
     &ThisRec              = ThisRec 
     &ThisRecSeekStream    = ThisRec 
     &Src_String           = kit.XL_Instance.SourcePhrase
     &Original_String      = xlatedb.XL_Translation.Trans_String
  }
END.  /* FOR EACH loop */
RUN HideMe IN _hMeter.


DO TRANSACTION: /* Update the active translation count */
  FIND xlatedb.XL_Kit WHERE xlatedb.XL_Kit.KitName = pKitName
                      EXCLUSIVE-LOCK NO-ERROR.
  
  IF AVAILABLE xlatedb.XL_Kit THEN
   ASSIGN xlatedb.XL_Kit.KitConsolidated  = TRUE
          xlatedb.XL_Kit.TranslationCount = kit.XL_Project.TranslationCount.
END.

trans-message = IF UpdateNew >= 1
                THEN STRING(CreateNew) + " translations were added; " + STRING(UpdateNew) +
                     " existing translations were updated."
                ELSE STRING(CreateNew) + " translations were added.".
RUN SetLanguages IN _hTrans.
IF CurrentMode = 2 THEN RUN OpenQuery IN _hTrans.
pErrorStatus = FALSE.
RETURN.

/* Update new internal procedure */
{adetran/pm/ldtranu.i}
