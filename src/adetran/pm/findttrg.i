/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/findttrg.i
Author:       SLK
Created:      07/08/98
Updated:      
Purpose:      Translation Manager's find include file
Background:   Include file for locating translation records 
              (see comments in pm/_find.w).
Called By:    pm/_find.w
Usage:        {adetran/pm/findtran.i CurrentMode SourcePhrase NEXT}

{1} Type of Phrase = SourcePhrase or TargetPhrase
{2} NEXT, FIRST, LAST, ...

OLD 1=xlatedb.xlatedb.xl_instance, sourphrase next

*/

      IF IgnoreSpaces:CHECKED THEN 
      DO:
        IF MatchCase:CHECKED THEN 
        DO:
          IF UseWildCards:CHECKED THEN 
          DO:
             FIND {2} xlatedb.XL_Translation WHERE 
               TRIM(XL_Translation.trans_string) MATCHES TRIM(tVal)
               AND xlatedb.XL_Translation.Lang_name = _Lang
             NO-LOCK NO-ERROR.
             IF NOT AVAILABLE xlatedb.XL_Translation
                AND CAN-DO("NEXT,PREV":U,"{2}":U) THEN
             DO:
                ASSIGN
                   ThisMessage = "Search Item Was Not Found. Start search from"
                     + IF "{2}" = "NEXT":U THEN " first record?"
                                           ELSE " last record?". 
                RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
                IF ErrorStatus THEN
                DO:
                    IF "{2}" = "NEXT":U THEN
                       FIND FIRST xlatedb.XL_Translation WHERE 
                            TRIM(XL_Translation.trans_string) MATCHES TRIM(tVal)
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                    ELSE
                       FIND LAST xlatedb.XL_Translation WHERE 
                            TRIM(XL_Translation.trans_string) MATCHES TRIM(tVal)
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                END. /* ErrorStatus */
             END. /* NOT AVAILABLE XL_Translation */
          END. /* WildCards */
          ELSE
          DO:
             FIND {2} xlatedb.XL_Translation WHERE 
               TRIM(XL_Translation.trans_string) = TRIM(tVal) 
               AND xlatedb.XL_Translation.Lang_name = _Lang
             NO-LOCK NO-ERROR.
             IF NOT AVAILABLE xlatedb.XL_Translation
                AND CAN-DO("NEXT,PREV":U,"{2}":U) THEN
             DO:
                ASSIGN
                   ThisMessage = "Search Item Was Not Found. Start search from"
                     + IF "{2}" = "NEXT":U THEN " first record?"
                                           ELSE " last record?". 
                RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
                IF ErrorStatus THEN
                DO:
                    IF "{2}" = "NEXT":U THEN
                       FIND FIRST xlatedb.XL_Translation WHERE 
                            TRIM(XL_Translation.trans_string) = TRIM(tVal)
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                    ELSE
                       FIND LAST xlatedb.XL_Translation WHERE 
                            TRIM(XL_Translation.trans_string) = TRIM(tVal)
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                END. /* ErrorStatus */
             END. /* NOT AVAILABLE XL_Translation */
          END. /* WildCards */
        END. /* MatchCase */
        ELSE 
        DO: /* Not Case sensitive */
          IF UseWildCards:CHECKED THEN 
          DO:
             FIND {2} xlatedb.XL_Translation WHERE 
               TRIM(XL_Translation.trans_string) MATCHES TRIM(FindValue) 
               AND xlatedb.XL_Translation.Lang_name = _Lang
             NO-LOCK NO-ERROR.
             IF NOT AVAILABLE xlatedb.XL_Translation
                AND CAN-DO("NEXT,PREV":U,"{2}":U) THEN
             DO:
                ASSIGN
                   ThisMessage = "Search Item Was Not Found. Start search from"
                     + IF "{2}" = "NEXT":U THEN " first record?"
                                           ELSE " last record?". 
                RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
                IF ErrorStatus THEN
                DO:
                    IF "{2}" = "NEXT":U THEN
                       FIND FIRST xlatedb.XL_Translation WHERE 
                            TRIM(XL_Translation.trans_string) MATCHES TRIM(FindValue)
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                    ELSE
                       FIND LAST xlatedb.XL_Translation WHERE 
                            TRIM(XL_Translation.trans_string) MATCHES TRIM(FindValue)
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                END. /* ErrorStatus */
             END. /* NOT AVAILABLE XL_Translation */
          END. /* WildCards */
          ELSE
          DO:
             FIND {2} xlatedb.XL_Translation WHERE 
               TRIM(XL_Translation.trans_string) = TRIM(FindValue) 
               AND xlatedb.XL_Translation.Lang_name = _Lang
               NO-LOCK NO-ERROR.
             IF NOT AVAILABLE xlatedb.XL_Translation
                AND CAN-DO("NEXT,PREV":U,"{2}":U) THEN
             DO:
                ASSIGN
                   ThisMessage = "Search Item Was Not Found. Start search from"
                     + IF "{2}" = "NEXT":U THEN " first record?"
                                           ELSE " last record?". 
                RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
                IF ErrorStatus THEN
                DO:
                    IF "{2}" = "NEXT":U THEN
                       FIND FIRST xlatedb.XL_Translation WHERE 
                            TRIM(XL_Translation.trans_string) = TRIM(FindValue)
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                    ELSE
                       FIND LAST xlatedb.XL_Translation WHERE 
                            TRIM(XL_Translation.trans_string) = TRIM(FindValue)
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                END. /* ErrorStatus */
             END. /* NOT AVAILABLE XL_Translation */
          END. /* WildCards */
        END. /* Not Case sensitive */
      END.  /* IF ignore spaces */
      ELSE
      DO: /* Don't ignore spaces */
        IF MatchCase:CHECKED THEN 
        DO:
          IF UseWildCards:CHECKED THEN 
          DO:
             FIND {2} xlatedb.XL_Translation WHERE 
               xlatedb.XL_Translation.trans_string MATCHES tVal
               AND xlatedb.XL_Translation.Lang_name = _Lang
             NO-LOCK NO-ERROR.
             IF NOT AVAILABLE xlatedb.XL_Translation
                AND CAN-DO("NEXT,PREV":U,"{2}":U) THEN
             DO:
                ASSIGN
                   ThisMessage = "Search Item Was Not Found. Start search from"
                     + IF "{2}" = "NEXT":U THEN " first record?"
                                           ELSE " last record?". 
                RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
                IF ErrorStatus THEN
                DO:
                    IF "{2}" = "NEXT":U THEN
                       FIND FIRST xlatedb.XL_Translation WHERE 
                            XL_Translation.trans_string MATCHES tVal
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                    ELSE
                       FIND LAST xlatedb.XL_Translation WHERE 
                            XL_Translation.trans_string MATCHES tVal
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                END. /* ErrorStatus */
             END. /* NOT AVAILABLE XL_Translation */
          END. /* WildCards */
          ELSE
          DO:
             FIND {2} xlatedb.XL_Translation WHERE 
               xlatedb.XL_Translation.trans_string = tVal 
               AND xlatedb.XL_Translation.Lang_name = _Lang
             NO-LOCK NO-ERROR.
             IF NOT AVAILABLE xlatedb.XL_Translation
                AND CAN-DO("NEXT,PREV":U,"{2}":U) THEN
             DO:
                ASSIGN
                   ThisMessage = "Search Item Was Not Found. Start search from"
                     + IF "{2}" = "NEXT":U THEN " first record?"
                                           ELSE " last record?". 
                RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
                IF ErrorStatus THEN
                DO:
                    IF "{2}" = "NEXT":U THEN
                       FIND FIRST xlatedb.XL_Translation WHERE 
                            XL_Translation.trans_string = tVal
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                    ELSE
                       FIND LAST xlatedb.XL_Translation WHERE 
                            XL_Translation.trans_string = tVal
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                END. /* ErrorStatus */
             END. /* NOT AVAILABLE XL_Translation */
          END. /* WildCards */
        END. /* MatchCase */
        ELSE 
        DO: /* Not Case sensitive */
          IF UseWildCards:CHECKED THEN 
          DO:
             FIND {2} xlatedb.XL_Translation WHERE 
               xlatedb.XL_Translation.trans_string MATCHES FindValue
               AND xlatedb.XL_Translation.Lang_name = _Lang
             NO-LOCK NO-ERROR.
             IF NOT AVAILABLE xlatedb.XL_Translation
                AND CAN-DO("NEXT,PREV":U,"{2}":U) THEN
             DO:
                ASSIGN
                   ThisMessage = "Search Item Was Not Found. Start search from"
                     + IF "{2}" = "NEXT":U THEN " first record?"
                                           ELSE " last record?". 
                RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
                IF ErrorStatus THEN
                DO:
                    IF "{2}" = "NEXT":U THEN
                       FIND FIRST xlatedb.XL_Translation WHERE 
                            XL_Translation.trans_string MATCHES FindValue
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                    ELSE
                       FIND LAST xlatedb.XL_Translation WHERE 
                            XL_Translation.trans_string MATCHES FindValue
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                END. /* ErrorStatus */
             END. /* NOT AVAILABLE XL_Translation */
          END. /* WildCards */
          ELSE
          DO:
             FIND {2} xlatedb.XL_Translation WHERE 
               xlatedb.XL_Translation.trans_string = FindValue 
               AND xlatedb.XL_Translation.Lang_name = _Lang
               NO-LOCK NO-ERROR.
             IF NOT AVAILABLE xlatedb.XL_Translation
                AND CAN-DO("NEXT,PREV":U,"{2}":U) THEN
             DO:
                ASSIGN
                   ThisMessage = "Search Item Was Not Found. Start search from"
                     + IF "{2}" = "NEXT":U THEN " first record?"
                                           ELSE " last record?". 
                RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
                IF ErrorStatus THEN
                DO:
                    IF "{2}" = "NEXT":U THEN
                       FIND FIRST xlatedb.XL_Translation WHERE 
                            XL_Translation.trans_string = FindValue
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                    ELSE
                       FIND LAST xlatedb.XL_Translation WHERE 
                            XL_Translation.trans_string = FindValue
                          AND xlatedb.XL_Translation.Lang_name = _Lang
                       NO-LOCK NO-ERROR.
                END. /* ErrorStatus */
             END. /* NOT AVAILABLE XL_Translation */
          END. /* WildCards */
        END. /* Not Case sensitive */
      END. /* Don't ignore spaces */


   IF AVAILABLE xlatedb.XL_Translation THEN 
   DO:
      FIND FIRST xlatedb.XL_String_Info WHERE
         xlatedb.XL_String_Info.sequence_num = xlatedb.XL_Translation.sequence_num
      NO-LOCK NO-ERROR.
      FIND FIRST xlatedb.XL_Instance WHERE
             xlatedb.XL_Instance.sequence_num = xlatedb.XL_Translation.sequence_num
         AND xlatedb.XL_Instance.instance_num = xlatedb.XL_Translation.instance_num
      NO-LOCK NO-ERROR.
   END.
