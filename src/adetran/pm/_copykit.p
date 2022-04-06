/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_copykit.p
Author:       R. Ryan/
Created:      4/94 
Updated:      9/95
              07/06/98 SLK Removed calculation of stats
              07/14/98 SLK change Source Language
Purpose:      Copies the contents of the project/language into a kit db
Background:   This routine copies the contents of xlatedb.XL_Project,
              xlatedb.XL_Procedure, xlatedb.XL_Instance, XL_GlossDet, 
              xlatedb.XL_String_Info, and xlatedb.XL_Translation into
              the kit database as follows:

                kit.XL_Project    = xlatedb.XL_Project
                kit.XL_Procedure  = xlatedb.XL_Procedure
                kit.XL_Instance   = 3-way join of xlatedb.XL_String_Info,
                                    xlatedb.XL_Instance, xlatedb.XL_Translation
                kit.XL_GlossEntry = xlatedb.XL_GlossDet where XL_Glossary = s_Glossary

Calls:        Realize in _hMeter (sets the frame title)
              SetBar in _hMeter (increments the meter)
              HideMe in _hMeter (hides the meter frame) 

Called By:    pm/_newkit.p
Parameters:   pGlossary (input/char) glossary name used by 'where clause'
              pLanguage (input/char) language name used by 'where clause'
              ErrorStatus (output/logical) success of the last copy operation
*/
define input parameter pGlossary    as char                 no-undo.  
define input parameter pLanguage    as char                 no-undo.
DEFINE INPUT PARAMETER pSrcLanguage AS CHARACTER            NO-UNDO.
define output parameter ErrorStatus as logical INITIAL TRUE no-undo.   

define shared var _hMeter           as handle               no-undo.
define shared var StopProcessing    as logical              no-undo. 
define shared var ProjectDB         as char                 no-undo.
define shared var _hKits            as handle               no-undo.
define shared var s_Glossary        as char                 no-undo.  
define shared var _Kit              as char                 no-undo.
DEFINE SHARED VARIABLE _MainWindow  AS WIDGET-HANDLE        NO-UNDO.

{adetran/pm/vsubset.i &NEW=" " &SHARED="SHARED"}

DEFINE VARIABLE CheckPoint          AS INTEGER EXTENT 9     NO-UNDO.
DEFINE VARIABLE cTemp               AS CHARACTER            NO-UNDO.
DEFINE VARIABLE i                   AS INTEGER              NO-UNDO.
DEFINE VARIABLE NumGloss            AS INTEGER              NO-UNDO.
DEFINE VARIABLE NumProcs            AS INTEGER              NO-UNDO.
DEFINE VARIABLE NumPhrases          AS INTEGER              NO-UNDO.
DEFINE VARIABLE NumInstances        AS INTEGER              NO-UNDO. 
DEFINE VARIABLE NumTrans            AS INTEGER              NO-UNDO.
DEFINE VARIABLE ShortName           AS CHARACTER            NO-UNDO.
DEFINE VARIABLE srcString           AS CHARACTER            NO-UNDO.
DEFINE VARIABLE ThisRec             AS INTEGER              NO-UNDO.

DEFINE VARIABLE TotRecs             AS INTEGER              NO-UNDO.
DEFINE VARIABLE TransRecs           AS INTEGER              NO-UNDO.

DEFINE BUFFER bTranslation FOR xlatedb.XL_Translation.
DEFINE QUERY ThisInstance FOR xlatedb.XL_Instance.
DEFINE QUERY glossqry FOR xlatedb.XL_GlossDet.

/* Calculation suppression when creating a kit
RUN adetran/pm/_pmrecnt.p (INPUT _MainWindow).
*/

ShortName = ENTRY(NUM-ENTRIES(_kit,"\":U),_kit,"\":U).
find first xlatedb.XL_Project no-lock no-error.
if available xlatedb.XL_Project then do:
  assign
    NumProcs      = xlatedb.XL_Project.NumberOfProcedures
    NumPhrases    = xlatedb.XL_Project.NumberOfUniquePhrases
    NumInstances  = xlatedb.XL_Project.NumberOfPhrases.
end.
else do:
  message "Can't find project information!" view-as alert-box error
  title "Kit Error".
  ErrorStatus = true.
  return error.
end.   

find first xlatedb.XL_Glossary where
  xlatedb.XL_Glossary.GlossaryName = pGlossary no-lock no-error.
if available xlatedb.XL_Glossary then
  NumGloss = xlatedb.XL_Glossary.GlossaryCount.

do transaction: /* Copy the contents of xlatedb.XL_Project table to kit  */   
  run adecomm/_setcurs.p ("").
  create kit.XL_Project. 
  BUFFER-COPY xlatedb.XL_Project TO kit.XL_Project.
  ASSIGN kit.XL_Project.ProjectRevision       = 
                        ENTRY(1,xlatedb.XL_Project.ProjectRevision,CHR(4)) + CHR(4) +
                        IF NUM-ENTRIES(xlatedb.XL_Project.ProjectRevision,CHR(4)) > 1
                        THEN ENTRY(2,xlatedb.XL_Project.ProjectRevision,CHR(4))
                        + CHR(4) + "No"
                        ELSE "":U 
         kit.XL_Project.CreateDate            = today
         kit.XL_Project.UpdateDate            = today.
  /* Modified since we maintain Sequence/Instance IDs in
   *  xlatedb.XL_Project.DisplayType
   *       DisplayType CHR(4) Sequence_Num CHR(4) Instance_Number
   * Removed before setting kit value
   */ 
   ASSIGN kit.XL_Project.DisplayType     = 
   IF NUM-ENTRIES(xlatedb.XL_Project.DisplayType,CHR(4)) > 1 THEN
        ENTRY(1, xlatedb.XL_Project.DisplayType, CHR(4))
   ELSE 
      xlatedb.XL_Project.DisplayType.
END. /* DO TRANSACTION */

/*
** Move the translation and glossary counts into the kit database
*/ 
find xlatedb.XL_Glossary where 
     xlatedb.XL_Glossary.GlossaryName = s_Glossary no-lock no-error. 
      
find xlatedb.XL_Kit where 
     xlatedb.XL_Kit.KitName = ShortName no-lock no-error.  
    
do transaction: /* Copy procedure info into the kit */
  ASSIGN ThisRec = 0
         CheckPoint[1] = TRUNCATE(DECIMAL(NumProcs) / 10.0,0)
         CheckPoint[2] = Checkpoint[1] + CheckPoint[1]
         CheckPoint[3] = Checkpoint[2] + CheckPoint[1]
         CheckPoint[4] = Checkpoint[3] + CheckPoint[1]
         CheckPoint[5] = Checkpoint[4] + CheckPoint[1]
         CheckPoint[6] = Checkpoint[5] + CheckPoint[1]
         CheckPoint[7] = Checkpoint[6] + CheckPoint[1]
         CheckPoint[8] = Checkpoint[7] + CheckPoint[1]
         CheckPoint[9] = Checkpoint[8] + CheckPoint[1].
  run Realize in _hMeter ("Copying Procedures...").            

  /* Instead of cycling through procedures and checking against subset, 
   * for performance, do the opposite */

  IF lSubset THEN
  DO:
     FOR EACH bSubsetList WHERE bSubsetList.Project = ProjectDB
                            AND bSubsetList.Active  = TRUE NO-LOCK:
        IF bSubsetList.FileName = cAllFiles THEN
        DO:
            FOR EACH xlatedb.XL_Procedure WHERE 
              xlatedb.XL_Procedure.Directory = bSubsetList.Directory 
              EXCLUSIVE-LOCK:
               FIND xlatedb.XL_Kit-Proc OF xlatedb.XL_Procedure WHERE
                 xlatedb.XL_Kit-Proc.KitName = xlatedb.XL_Kit.KitName NO-LOCK NO-ERROR.
               PROCESS EVENTS.
               IF StopProcessing THEN
               DO:
                  RUN HideMe in _hMeter. 
                  RETURN.
               END.
               ThisRec = ThisRec + 1.
               IF ThisRec MOD 100 = 0 THEN 
                  RUN SetBar in _hMeter (NumProcs, ThisRec, xlatedb.XL_Procedure.FileName).
               CREATE kit.XL_Procedure.
               BUFFER-COPY xlatedb.XL_Procedure TO kit.XL_Procedure.
               ASSIGN
                           kit.XL_Procedure.CurrentStatus         = xlatedb.XL_Kit-Proc.CurrentStatus
                           xlatedb.XL_Procedure.CurrentStatus     = "- - -":U.
             END. /* For each Procedure */
        END. /* All Files */
        ELSE
        DO:
            FIND FIRST xlatedb.XL_Procedure
              WHERE xlatedb.XL_Procedure.Directory = bSubsetList.Directory
                AND xlatedb.XL_Procedure.FileName  = bSubsetList.FileName
              EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE xlatedb.XL_Procedure THEN
            DO:
               FIND xlatedb.XL_Kit-Proc OF xlatedb.XL_Procedure WHERE
                 xlatedb.XL_Kit-Proc.KitName = xlatedb.XL_Kit.KitName NO-LOCK NO-ERROR.
               PROCESS EVENTS.
               IF StopProcessing THEN
               DO:
                  RUN HideMe IN _hMeter. 
                  RETURN.
               END.
               ThisRec = ThisRec + 1.
               IF ThisRec MOD 100 = 0 THEN 
                 RUN SetBar in _hMeter (NumProcs, ThisRec, xlatedb.XL_Procedure.FileName).
               CREATE kit.XL_Procedure.
               BUFFER-COPY xlatedb.XL_Procedure TO kit.XL_Procedure.
               ASSIGN kit.XL_Procedure.CurrentStatus     = xlatedb.XL_Kit-Proc.CurrentStatus
                      xlatedb.XL_Procedure.CurrentStatus = "- - -":U.
            END. /* Available XL_Procedure */
        END. /* Single File */
     END. /* bSubsetList */
  END. /* subset */
  ELSE
  DO: /* Complete project */
       nextLoop:
       for each xlatedb.XL_Procedure EXCLUSIVE-LOCK:
         FIND xlatedb.XL_Kit-Proc OF xlatedb.XL_Procedure WHERE
           xlatedb.XL_Kit-Proc.KitName = xlatedb.XL_Kit.KitName NO-LOCK NO-ERROR.
         process events.
         if StopProcessing then do:
           run HideMe in _hMeter. 
           return.
         end.
         ThisRec = ThisRec + 1.
         IF ThisRec MOD 100 = 0 THEN 
         run SetBar in _hMeter (NumProcs, ThisRec, xlatedb.XL_Procedure.FileName).
         create kit.XL_Procedure.
         BUFFER-COPY xlatedb.XL_Procedure TO kit.XL_Procedure.
         ASSIGN
                kit.XL_Procedure.CurrentStatus         = xlatedb.XL_Kit-Proc.CurrentStatus
                xlatedb.XL_Procedure.CurrentStatus     = "- - -":U.
       end. /* For each Procedure */
  END. /* Whole Project */
  run HideMe in _hMeter.   
end.              

ASSIGN ThisRec = 0
       CheckPoint[1] = TRUNCATE(DECIMAL(NumInstances) / 10.0, 0)
       CheckPoint[2] = Checkpoint[1] + CheckPoint[1]
       CheckPoint[3] = Checkpoint[2] + CheckPoint[1]
       CheckPoint[4] = Checkpoint[3] + CheckPoint[1]
       CheckPoint[5] = Checkpoint[4] + CheckPoint[1]
       CheckPoint[6] = Checkpoint[5] + CheckPoint[1]
       CheckPoint[7] = Checkpoint[6] + CheckPoint[1]
       CheckPoint[8] = Checkpoint[7] + CheckPoint[1]
       CheckPoint[9] = Checkpoint[8] + CheckPoint[1].
run Realize in _hMeter ("Copying Instance..."). 

/* Please note that the following IF THEN ELSE block was created to avoid adding
 * additional overhead to the kit creation process for the normal case of NOT 
 * changing the source language

 *
 * Additional blocks added to handle subsets
 *   For subsets, we check the procedure subset and then get the instance vs. checking all the 
 *   instances to determine if the instance is part of a procedure in the subset
 *   Note that xl_instance.procname = directory and filename
 *   We will also be using the index Old_Inst_Of_Proc = proc + last_change
 */

DISABLE TRIGGERS FOR LOAD OF kit.XL_Instance.


IF NOT lSubset THEN
DO:
   open query ThisInstance for each xlatedb.XL_Instance NO-LOCK.
   IF pSrcLanguage = "":U THEN
   DO: /* Process normally */
      Load-Strings:
      REPEAT TRANSACTION:
        
        DO i = 1 TO 100:  /* Block by 100 strings */
          GET NEXT ThisInstance.
   
          FIND FIRST xlatedb.XL_String_Info WHERE
             xlatedb.XL_String_Info.Sequence_Num = 
             xlatedb.XL_Instance.Sequence_Num NO-LOCK NO-ERROR.
   
          IF AVAILABLE xlatedb.XL_String_Info THEN DO:  
            process events.
            if StopProcessing then do:
              run HideMe in _hMeter.
              return.
            end.  /* User canceled */
      
/*    &MESSAGE [_copykit.p] s/e 129 & 141 bypass attempt. Eliminate when Redesign/Schema Change. (sonia) */
            {adetran/pm/_hack129.i}
          
            ThisRec = ThisRec + 1.
            IF ThisRec MOD 100 = 0 THEN 
            run SetBar in _hMeter (NumInstances,
                                   ThisRec,
                                   xlatedb.XL_String_Info.Original_String).
      
            FIND FIRST xlatedb.XL_Translation WHERE
                 xlatedb.XL_Translation.Sequence_Num = xlatedb.XL_Instance.Sequence_Num 
             AND xlatedb.XL_Translation.Instance_Num = xlatedb.XL_Instance.Instance_Num 
             AND xlatedb.XL_Translation.Lang_Name = pLanguage
            NO-LOCK NO-ERROR.
   
            create kit.XL_Instance.
            BUFFER-COPY xlatedb.XL_Instance TO kit.XL_Instance.
            ASSIGN kit.XL_Instance.SequenceNumber  = xlatedb.XL_String_Info.Sequence_Num           
                   kit.XL_Instance.SourcePhrase    = xlatedb.XL_String_Info.Original_string
                   kit.XL_Instance.InstanceNumber  = xlatedb.XL_Instance.Instance_Num
                   kit.XL_Instance.ProcedureName   = xlatedb.XL_Instance.Proc_Name
                   kit.XL_Instance.LineNumber      = xlatedb.XL_Instance.Line_Num  
                   kit.XL_Instance.NumberOfOccurs  = xlatedb.XL_Instance.Num_Occurs
                   kit.XL_Instance.StringKey       = SUBSTRING(kit.XL_Instance.SourcePhrase,
                                                               1,63,"RAW":U)
                   kit.XL_Instance.UpdateDate      = TODAY.
             
            /* ASSIGN to kit.XL_Instance.TargetPhrase ONLY if you have to.
             * There is an ASSIGN trigger which does a bunch of counts.
             * Note that 
             *     if xlatedb.XL_Translation.Trans_String = ?
             *     kit.XL_Instance.TargetPhrase    = ""
             * but kit.XL_Instnace.TargetPhrase defaults to "" when created.
             *
             */
            IF AVAILABLE xlatedb.XL_Translation 
               AND xlatedb.XL_Translation.Trans_String <> "":U
               AND xlatedb.XL_Translation.Trans_String <> ? THEN
            ASSIGN 
               kit.XL_Instance.TargetPhrase = xlatedb.XL_Translation.Trans_String
               kit.XL_Instance.ShortTarg    = 
                  SUBSTRING(kit.XL_Instance.TargetPhrase, 1,63,"RAW":U)
               NumTrans = NumTrans + 1.
   
          END. /* Do IF available This Instance */
          ELSE LEAVE Load-Strings.
        END.  /* i = 1 TO 100 */
      END.  /* Load-Strings: REPEAT TRANSACTION */
   END. /* Using original language */
   ELSE
   DO:
      Load-Strings-Change-Source:
      REPEAT TRANSACTION:
        
        DO i = 1 TO 100:  /* Block by 100 strings */
          GET NEXT ThisInstance.
   
   
          FIND FIRST xlatedb.XL_String_Info WHERE
             xlatedb.XL_String_Info.Sequence_Num = 
             xlatedb.XL_Instance.Sequence_Num
          NO-LOCK NO-ERROR.
   
          IF AVAILABLE xlatedb.XL_String_Info THEN DO:  
            process events.
            if StopProcessing then do:
              run HideMe in _hMeter.
              return.
            end.  /* User canceled */
      
/*    &MESSAGE [_copykit.p] s/e 129 & 141 bypass attempt. Eliminate when Redesign/Schema Change. (sonia) */
            {adetran/pm/_hack129.i}
          
            ThisRec = ThisRec + 1.
            IF ThisRec MOD 100 = 0 THEN 
            run SetBar in _hMeter (NumInstances,
                                   ThisRec,
                                   xlatedb.XL_String_Info.Original_String).
      
             FIND FIRST xlatedb.XL_Translation WHERE
                    xlatedb.XL_Translation.Sequence_num = xlatedb.XL_Instance.Sequence_num 
                AND xlatedb.XL_Translation.Instance_num = xlatedb.XL_Instance.Instance_num 
                AND xlatedb.XL_Translation.Lang_Name = pLanguage 
             NO-LOCK NO-ERROR.
   
             /* Change source language */
             FIND FIRST bTranslation WHERE
                    bTranslation.Sequence_num = xlatedb.XL_Instance.Sequence_num 
                AND bTranslation.Instance_num = xlatedb.XL_Instance.Instance_num 
                AND bTranslation.Lang_Name = pSrcLanguage 
             NO-LOCK NO-ERROR.
   
             ASSIGN srcString = 
                IF AVAILABLE bTranslation 
                   AND bTranslation.Trans_String <> "":U 
                   AND bTranslation.Trans_String <> ? THEN
                   bTranslation.Trans_String
                ELSE 
                   xlatedb.XL_String_Info.Original_string.
      
            create kit.XL_Instance.
            BUFFER-COPY xlatedb.XL_Instance TO kit.XL_Instance.
            ASSIGN kit.XL_Instance.SequenceNumber  = xlatedb.XL_String_Info.Sequence_Num           
                   kit.XL_Instance.SourcePhrase    = srcString
                   kit.XL_Instance.InstanceNumber  = xlatedb.XL_Instance.Instance_Num
                   kit.XL_Instance.ProcedureName   = xlatedb.XL_Instance.Proc_Name
                   kit.XL_Instance.LineNumber      = xlatedb.XL_Instance.Line_Num  
                   kit.XL_Instance.NumberOfOccurs  = xlatedb.XL_Instance.Num_Occurs
                   kit.XL_Instance.StringKey       = SUBSTRING(kit.XL_Instance.SourcePhrase,
                                                               1,63,"RAW":U)
                   kit.XL_Instance.UpdateDate      = TODAY.
             
            /* ASSIGN to kit.XL_Instance.TargetPhrase ONLY if you have to.
             * There is an ASSIGN trigger which does a bunch of counts.
             * Note that 
             *     if xlatedb.XL_Translation.Trans_String = ?
             *     kit.XL_Instance.TargetPhrase    = ""
             * but kit.XL_Instnace.TargetPhrase defaults to "" when created.
             *
             */
            IF AVAILABLE xlatedb.XL_Translation
               AND xlatedb.XL_Translation.Trans_String <> "":U
               AND xlatedb.XL_Translation.Trans_String <> ? THEN
            ASSIGN 
               kit.XL_Instance.TargetPhrase = xlatedb.XL_Translation.Trans_String
               kit.XL_Instance.ShortTarg    = 
                  SUBSTRING(kit.XL_Instance.TargetPhrase, 1,63,"RAW":U)
               NumTrans = NumTrans + 1.
   
          END. /* Do IF available This Instance */
          ELSE LEAVE Load-Strings-Change-Source.
        END.  /* i = 1 TO 100 */
      END.  /* Load-Strings-Change-Source: REPEAT TRANSACTION */
   END. /* Change source language */
END. /* Not Subset */
ELSE
DO: /* SUBSET */
   /* xlatedb.XL_Instance.Proc_name = 
    *    bSubsetList.Directory + "\" + bSubsetList.FileName 
    */

   FOR EACH bSubsetList WHERE bSubsetList.Project = ProjectDB
                          AND bSubsetList.Active  = TRUE NO-LOCK:
      cTemp = bSubsetList.Directory + "\":U + bSubsetList.FileName.
      OPEN QUERY ThisInstance FOR EACH xlatedb.XL_Instance 
      WHERE (   xlatedb.XL_Instance.Proc_Name BEGINS bSubsetList.Directory
             AND (xlatedb.XL_Instance.Proc_Name = cTemp
                  OR (SUBSTRING(xlatedb.XL_Instance.Proc_Name,1
                         , R-INDEX(xlatedb.XL_Instance.Proc_Name,"\":U) - 1)
                      = bSubsetList.Directory)
                      AND bSubsetList.FileName  = cAllFiles))
      NO-LOCK.
      
      IF pSrcLanguage = "":U THEN
      DO: /* Process normally */
         Load-Strings:
         REPEAT TRANSACTION:
           DO i = 1 TO 100:  /* Block by 100 strings */
             GET NEXT ThisInstance.
      
             FIND FIRST xlatedb.XL_String_Info WHERE
                xlatedb.XL_String_Info.Sequence_Num = 
                xlatedb.XL_Instance.Sequence_Num NO-LOCK NO-ERROR.
      
             IF AVAILABLE xlatedb.XL_String_Info THEN DO:  
               process events.
               if StopProcessing then do:
                 run HideMe in _hMeter.
                 return.
               end.  /* User canceled */
         
/*    &MESSAGE [_copykit.p] s/e 129 & 141 bypass attempt. Eliminate when Redesign/Schema Change. (sonia) */
               {adetran/pm/_hack129.i}
             
               ThisRec = ThisRec + 1.
               IF ThisRec MOD 100 = 0 THEN 
               run SetBar in _hMeter (NumInstances,
                                      ThisRec,
                                      xlatedb.XL_String_Info.Original_String).
         
               FIND FIRST xlatedb.XL_Translation WHERE
                    xlatedb.XL_Translation.Sequence_Num = xlatedb.XL_Instance.Sequence_Num 
                AND xlatedb.XL_Translation.Instance_Num = xlatedb.XL_Instance.Instance_Num 
                AND xlatedb.XL_Translation.Lang_Name = pLanguage
               NO-LOCK NO-ERROR.
      
               create kit.XL_Instance.
               BUFFER-COPY xlatedb.XL_Instance TO kit.XL_Instance.
               ASSIGN kit.XL_Instance.SequenceNumber  = xlatedb.XL_String_Info.Sequence_Num           
                      kit.XL_Instance.SourcePhrase    = xlatedb.XL_String_Info.Original_string
                      kit.XL_Instance.InstanceNumber  = xlatedb.XL_Instance.Instance_Num
                      kit.XL_Instance.ProcedureName   = xlatedb.XL_Instance.Proc_Name
                      kit.XL_Instance.LineNumber      = xlatedb.XL_Instance.Line_Num  
                      kit.XL_Instance.NumberOfOccurs  = xlatedb.XL_Instance.Num_Occurs
                      kit.XL_Instance.StringKey       = SUBSTRING(kit.XL_Instance.SourcePhrase,
                                                                  1,63,"RAW":U)
                      kit.XL_Instance.UpdateDate      = TODAY.
                
               /* ASSIGN to kit.XL_Instance.TargetPhrase ONLY if you have to.
                * There is an ASSIGN trigger which does a bunch of counts.
                * Note that 
                *     if xlatedb.XL_Translation.Trans_String = ?
                *     kit.XL_Instance.TargetPhrase    = ""
                * but kit.XL_Instnace.TargetPhrase defaults to "" when created.
                *
                */
               IF AVAILABLE xlatedb.XL_Translation 
                  AND xlatedb.XL_Translation.Trans_String <> "":U
                  AND xlatedb.XL_Translation.Trans_String <> ? THEN
               ASSIGN 
                  kit.XL_Instance.TargetPhrase = xlatedb.XL_Translation.Trans_String
                  kit.XL_Instance.ShortTarg    = 
                     SUBSTRING(kit.XL_Instance.TargetPhrase, 1,63,"RAW":U)
                  NumTrans = NumTrans + 1.
      
             END. /* Do IF available This Instance */
             ELSE LEAVE Load-Strings.
           END.  /* i = 1 TO 100 */
         END.  /* Load-Strings: REPEAT TRANSACTION */
      END. /* Using original language */
      ELSE
      DO:
         Load-Strings-Change-Source:
         REPEAT TRANSACTION:
           
           DO i = 1 TO 100:  /* Block by 100 strings */
             GET NEXT ThisInstance.
      
      
             FIND FIRST xlatedb.XL_String_Info WHERE
                xlatedb.XL_String_Info.Sequence_Num = 
                xlatedb.XL_Instance.Sequence_Num
             NO-LOCK NO-ERROR.
      
             IF AVAILABLE xlatedb.XL_String_Info THEN DO:  
               process events.
               if StopProcessing then do:
                 run HideMe in _hMeter.
                 return.
               end.  /* User canceled */
         
/*    &MESSAGE [_copykit.p] s/e 129 & 141 bypass attempt. Eliminate when Redesign/Schema Change. (sonia) */
               {adetran/pm/_hack129.i}
             
               ThisRec = ThisRec + 1.
               IF ThisRec MOD 100 = 0 THEN 
               run SetBar in _hMeter (NumInstances,
                                      ThisRec,
                                      xlatedb.XL_String_Info.Original_String).
         
                FIND FIRST xlatedb.XL_Translation WHERE
                       xlatedb.XL_Translation.Sequence_num = xlatedb.XL_Instance.Sequence_num 
                   AND xlatedb.XL_Translation.Instance_num = xlatedb.XL_Instance.Instance_num 
                   AND xlatedb.XL_Translation.Lang_Name = pLanguage 
                NO-LOCK NO-ERROR.
      
                /* Change source language */
                FIND FIRST bTranslation WHERE
                       bTranslation.Sequence_num = xlatedb.XL_Instance.Sequence_num 
                   AND bTranslation.Instance_num = xlatedb.XL_Instance.Instance_num 
                   AND bTranslation.Lang_Name = pSrcLanguage 
                NO-LOCK NO-ERROR.
      
                ASSIGN srcString = 
                   IF AVAILABLE bTranslation 
                      AND bTranslation.Trans_String <> "":U 
                      AND bTranslation.Trans_String <> ? THEN
                      bTranslation.Trans_String
                   ELSE 
                      xlatedb.XL_String_Info.Original_string.
         
               create kit.XL_Instance.
               BUFFER-COPY xlatedb.XL_Instance TO kit.XL_Instance.
               ASSIGN kit.XL_Instance.SequenceNumber  = xlatedb.XL_String_Info.Sequence_Num           
                      kit.XL_Instance.SourcePhrase    = srcString
                      kit.XL_Instance.InstanceNumber  = xlatedb.XL_Instance.Instance_Num
                      kit.XL_Instance.ProcedureName   = xlatedb.XL_Instance.Proc_Name
                      kit.XL_Instance.LineNumber      = xlatedb.XL_Instance.Line_Num  
                      kit.XL_Instance.NumberOfOccurs  = xlatedb.XL_Instance.Num_Occurs
                      kit.XL_Instance.StringKey       = SUBSTRING(kit.XL_Instance.SourcePhrase,
                                                                  1,63,"RAW":U)
                      kit.XL_Instance.UpdateDate      = TODAY.
                
               /* ASSIGN to kit.XL_Instance.TargetPhrase ONLY if you have to.
                * There is an ASSIGN trigger which does a bunch of counts.
                * Note that 
                *     if xlatedb.XL_Translation.Trans_String = ?
                *     kit.XL_Instance.TargetPhrase    = ""
                * but kit.XL_Instnace.TargetPhrase defaults to "" when created.
                *
                */
               IF AVAILABLE xlatedb.XL_Translation
                  AND xlatedb.XL_Translation.Trans_String <> "":U
                  AND xlatedb.XL_Translation.Trans_String <> ? THEN
               ASSIGN 
                  kit.XL_Instance.TargetPhrase = xlatedb.XL_Translation.Trans_String
                  kit.XL_Instance.ShortTarg    = 
                     SUBSTRING(kit.XL_Instance.TargetPhrase, 1,63,"RAW":U)
                  NumTrans = NumTrans + 1.
      
             END. /* Do IF available This Instance */
             ELSE LEAVE Load-Strings-Change-Source.
           END.  /* i = 1 TO 100 */
         END.  /* Load-Strings-Change-Source: REPEAT TRANSACTION */
      END. /* Change source language */
   END. /* bSubsetList */
END. /* Subset */
      
DO TRANSACTION:
        FIND FIRST kit.XL_Project EXCLUSIVE-LOCK.
        FIND FIRST xlatedb.XL_Project EXCLUSIVE-LOCK.
        ASSIGN kit.XL_Project.TranslationCount    = NumTrans
               kit.XL_Project.NumberOfPhrases     = ThisRec
               kit.XL_Project.UpdateDate          = TODAY.
               xlatedb.XL_Project.NumberOfPhrases = 
               IF lSubset THEN ThisRec ELSE NumInstances.
END.
      
/* This replaces the VT/_trgains.p trigger code */
OPEN QUERY kitProcedure FOR EACH kit.XL_Procedure EXCLUSIVE-LOCK.
Update-ProcStatus:
REPEAT TRANSACTION:
         DO i = 1 TO 100:  /* Block by 100 strings */
             GET NEXT KitProcedure.
             IF AVAILABLE kit.XL_Procedure THEN
             DO:
                PROCESS EVENTS.
                IF StopProcessing THEN RETURN.
                ASSIGN
                   TotRecs   = 0
                   TransRecs = 0.
                FOR EACH kit.XL_Instance WHERE
                   kit.XL_Instance.ProcedureName = kit.XL_Procedure.Directory + 
                                                   kit.XL_Procedure.FileName
                   NO-LOCK:
                   ASSIGN TotRecs = TotRecs + 1.
                   /* Note that we can not use ShortTarg for the comparison since
                    * in theory you could have a string longer that 63 chars where
                    * its first 63 chars are "" */
                   IF kit.XL_Instance.TargetPhrase <> "" AND
                      kit.XL_Instance.TargetPhrase <> ? THEN TransRecs = TransRecs + 1.
                END.
                ASSIGN kit.Xl_Procedure.CurrentStatus = 
                   IF      TransRecs = 0       THEN "Untranslated"
                   ELSE IF TransRecs = TotRecs THEN "Translated"
                   ELSE STRING(TransRecs) + " of " + STRING(TotRecs).
            END. /* IF AVAILABLE kitProcedure */
            ELSE LEAVE Update-ProcStatus.
         END. /* DO i = 1 TO 100 */
END. /* DO Transaction */
      
RUN HideMe in _hMeter.
ASSIGN ThisRec = 0
             CheckPoint[1] = TRUNCATE(DECIMAL(NumGloss) / 10.0, 0)
             CheckPoint[2] = Checkpoint[1] + CheckPoint[1]
             CheckPoint[3] = Checkpoint[2] + CheckPoint[1]
             CheckPoint[4] = Checkpoint[3] + CheckPoint[1]
             CheckPoint[5] = Checkpoint[4] + CheckPoint[1]
             CheckPoint[6] = Checkpoint[5] + CheckPoint[1]
             CheckPoint[7] = Checkpoint[6] + CheckPoint[1]
             CheckPoint[8] = Checkpoint[7] + CheckPoint[1]
             CheckPoint[9] = Checkpoint[8] + CheckPoint[1].
               
RUN Realize in _hMeter ("Copying Glossary...").            
OPEN QUERY Glossqry FOR EACH xlatedb.XL_GlossDet
                 WHERE xlatedb.XL_GlossDet.GlossaryName = pGlossary NO-LOCK.
                   
Load-GlossEntries:
REPEAT TRANSACTION:
        
        DO i = 1 TO 100:  /* Block by 100 strings */
          GET NEXT Glossqry.
          IF AVAILABLE xlatedb.XL_GlossDet THEN DO:  
            process events.
            if StopProcessing then do:
              run HideMe in _hMeter.
              return.
            end.  /* User canceled */
          
            ThisRec = ThisRec + 1.
            IF ThisRec MOD 100 = 0 THEN
            RUN SetBar in _hMeter (NumGloss,
                                   ThisRec,
                                   xlatedb.XL_GlossDet.SourcePhrase).
            create kit.XL_GlossEntry.
            BUFFER-COPY xlatedb.XL_GlossDet TO kit.XL_GlossEntry.
          END.  /* IF AVAILABLE xlatedb.XL_GlossDet */
          ELSE LEAVE Load-GlossEntries.
        END.  /* DO i = 1 TO 100 */
END. /* Load-GlossEntries: DO Transaction */
RUN HideMe IN _hMeter.   
      
ErrorStatus = false.
return.
