/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* In loop  either FOR EACH kit.XL_Instance OR IMPORT Fld1 etc 
 * If translation coming in as ? or "" then delete xl_translation
 *
 * &NumTrans             = FileSize
 * &InTargetPhrase       = dataTranslation
 * &InSequenceNumber     = dataSequence_Num
 * &InInstanceNumber     = dataInstance_Num
 * &InLang_Name          = headerLanguageName
 * &InReconcileType      = ReconcileType:SCREEN-VALUE
 * &RejectNew            = RejectTransNew
 * &CreateNew            = CreateTransNew
 * &UpdateOld            = UpdateTrans
 * &DeleteOld            = DeleteTrans
 * &StopProcessingAction = "LEAVE"
 * &ThisRec              = RecsRead
 * &ThisRecSeekStream    = SEEK(ThisStream)
 */

  PROCESS EVENTS.
  IF StopProcessing THEN DO:
    RUN HideMe IN _hMeter.
    {&StopProcessingAction}.
  END.      

  IF {&ThisRec} MOD 100 = 0 THEN 
  RUN SetBar in _hMeter ({&NumTrans}, {&ThisRecSeekStream}, {&InTargetPhrase}).

  DO:
    FIND xlatedb.XL_Translation WHERE
           xlatedb.XL_Translation.Sequence_Num = {&InSequenceNumber} 
       AND xlatedb.XL_Translation.Instance_Num = {&InInstanceNumber}
       AND xlatedb.XL_Translation.Lang_Name    = {&InLang_Name}
    USE-INDEX seq_inst NO-LOCK NO-ERROR.     

    IF AVAILABLE xlatedb.XL_Translation THEN DO: 
    /* Note: ReconcileType indicates what to do with a match.
         Case 1: take new over old (default)
         Case 2: take old over new (i.e. don't do anything)
         Case 3: resolve conflict (put up a dialog box)      */
      CASE {&InReconcileType}:
        WHEN "1":U THEN 
        DO:
          RUN UpdateNew
           (  INPUT {&InSequenceNumber}
            , INPUT {&InInstanceNumber}
            , INPUT {&InLang_Name}
            , INPUT {&InTargetPhrase}
            , INPUT-OUTPUT {&UpdateOld}
            , INPUT-OUTPUT {&DeleteOld})
           .
        END.
        WHEN "2":U THEN {&RejectNew} = {&RejectNew} + 1.
        OTHERWISE DO:  /* Case 3: resolve with a dialog */   
          ASSIGN ProjString  = RIGHT-TRIM(xlatedb.XL_Translation.trans_string)
                 TransString = RIGHT-TRIM({&InTargetPhrase}). 
      
          IF ProjString MATCHES TransString THEN {&RejectNew} = {&RejectNew} + 1.
          ELSE DO: /* If existing string is not the same as the new one */    
                   /* User must pick resolve conflict and old <> new    */

            /* If kit has a different source language, use original language */
            FIND FIRST xlatedb.XL_String_Info WHERE
                  xlatedb.XL_String_Info.sequence_num = {&InSequenceNumber}
                  NO-LOCK NO-ERROR.
            ASSIGN srcString = IF AVAILABLE xlatedb.XL_String_Info THEN
                                  xlatedb.XL_String_Info.original_string
                               ELSE
                                  {&Original_String}.
            RUN adetran/pm/_resolve.w (
                             srcString,
                             xlatedb.XL_Translation.trans_string,
                             {&InTargetPhrase},
                             OUTPUT ResolveType, 
                             OUTPUT OKPressed). 
          
            IF ResolveType = "N" AND OKPressed THEN 
            DO:
                 RUN UpdateNew
                 (  INPUT {&InSequenceNumber}
                  , INPUT {&InInstanceNumber}
                  , INPUT {&InLang_Name}
                  , INPUT {&InTargetPhrase}
                  , INPUT-OUTPUT {&UpdateOld}
                  , INPUT-OUTPUT {&DeleteOld})
                 .
            END.
            ELSE ASSIGN {&RejectNew} = {&RejectNew} + 1.
          END. /* IF strings are different and the project manager has to resolve it. */
        END.  /* Case 3: Resolve with a dialog */
      END CASE. 
    END. /* if avail XL_Translation */   
    ELSE 
    DO: 
      IF {&InTargetPhrase} = ? OR {&InTargetPhrase} = "":U 
         OR NOT CAN-FIND(xlatedb.XL_String_Info
            WHERE Sequence_Num = {&InSequenceNumber}) THEN
         {&RejectNew} = {&RejectNew} + 1.
      ELSE 
      DO:
         CREATE xlatedb.XL_Translation.
         ASSIGN {&CreateNew}                     = {&CreateNew} + 1
             xlatedb.XL_Translation.Sequence_Num = {&InSequenceNumber}
             xlatedb.XL_Translation.Instance_Num = {&InInstanceNumber}
             xlatedb.XL_Translation.Lang_Name    = {&InLang_Name}
             xlatedb.XL_Translation.Trans_String = {&InTargetPhrase}
             xlatedb.XL_Translation.Last_Change  = TimeDateStamp. 
      END.
    END.  /* Couldn't find the translation record */
  END.  /* Transaction */
