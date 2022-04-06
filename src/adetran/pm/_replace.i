/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_replace.i
Author:       Ross Hunter
Created:      1/96
Updated:      9/98 SLK Start from first record if reached the end 
               w/ no success (NEXT). Start from last record if reached the
               top with no success (PREV)
Purpose:      Project Managers replace include file
Background:   Include file for locating glossary
              
Called By:    pm/_replace.w
*/

IF IgnoreSpaces:CHECKED THEN
DO:
   IF MatchCase:CHECKED THEN
   DO:
      IF UseWildCards:CHECKED THEN 
      DO:
         FIND {3} {1} WHERE TRIM({1}.{2}) MATCHES TRIM(tVal) AND
              xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
         IF NOT AVAILABLE {1} 
            AND CAN-DO("NEXT,PREV":U,"{3}":U) THEN
         DO:
            ASSIGN 
               ThisMessage = "Search Item Was Not Found. Start search from "
                 + IF "{3}":U = "NEXT":U THEN "first record?"
                                         ELSE "last record?".
            RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
            IF ErrorStatus THEN
            DO:
               IF "{3}":U = "NEXT":U THEN
                 FIND FIRST {1} WHERE TRIM({1}.{2}) MATCHES TRIM(tVal) AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
               ELSE
                 FIND LAST {1} WHERE TRIM({1}.{2}) MATCHES TRIM(tVal) AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
            END. /* ErrorStatus */
         END. /* NOT AVAILABLE {1} */
      END. /* IgnoreSpaces, CaseSensitive, UseWildCards */
      ELSE
      DO:
         FIND {3} {1} WHERE TRIM({1}.{2}) = TRIM(tVal) AND
              xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
         IF NOT AVAILABLE {1} 
            AND CAN-DO("NEXT,PREV":U,"{3}":U) THEN
         DO:
            ASSIGN 
               ThisMessage = "Search Item Was Not Found. Start search from "
                 + IF "{3}":U = "NEXT":U THEN "first record?"
                                         ELSE "last record?".
            RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
            IF ErrorStatus THEN
            DO:
               IF "{3}":U = "NEXT":U THEN
                 FIND FIRST {1} WHERE TRIM({1}.{2}) = TRIM(tVal) AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
               ELSE
                 FIND LAST {1} WHERE TRIM({1}.{2}) = TRIM(tVal) AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
            END. /* ErrorStatus */
         END. /* NOT AVAILABLE {1} */
      END. /* IgnoreSpaces, CaseSensitive, NO WildCards */
   END.
   ELSE 
   DO: /* Not Case sensitive */
      IF UseWildCards:CHECKED THEN 
      DO:
         FIND {3} {1} WHERE TRIM({1}.{2}) MATCHES TRIM(FindValue) AND
              xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
         IF NOT AVAILABLE {1} 
            AND CAN-DO("NEXT,PREV":U,"{3}":U) THEN
         DO:
            ASSIGN 
               ThisMessage = "Search Item Was Not Found. Start search from "
                 + IF "{3}":U = "NEXT":U THEN "first record?"
                                         ELSE "last record?".
            RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
            IF ErrorStatus THEN
            DO:
               IF "{3}":U = "NEXT":U THEN
                 FIND FIRST {1} WHERE TRIM({1}.{2}) MATCHES TRIM(FindValue) AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
               ELSE
                 FIND LAST {1} WHERE TRIM({1}.{2}) MATCHES TRIM(FindValue) AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
            END. /* ErrorStatus */
         END. /* NOT AVAILABLE {1} */
      END.
      ELSE
      DO:
         FIND {3} {1} WHERE TRIM({1}.{2}) = TRIM(FindValue) AND
               xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
         IF NOT AVAILABLE {1} 
            AND CAN-DO("NEXT,PREV":U,"{3}":U) THEN
         DO:
            ASSIGN 
               ThisMessage = "Search Item Was Not Found. Start search from "
                 + IF "{3}":U = "NEXT":U THEN "first record?"
                                         ELSE "last record?".
            RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
            IF ErrorStatus THEN
            DO:
               IF "{3}":U = "NEXT":U THEN
                 FIND FIRST {1} WHERE TRIM({1}.{2}) = TRIM(FindValue) AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
               ELSE
                 FIND LAST {1} WHERE TRIM({1}.{2}) = TRIM(FindValue) AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
            END. /* ErrorStatus */
         END. /* NOT AVAILABLE {1} */.
      END.
  END.
END.  /* IF ignore spaces */
ELSE 
DO: /* Don't ignore spaces */
   IF MatchCase:CHECKED THEN 
   DO:
      IF UseWildCards:CHECKED THEN 
      DO:
         FIND {3} {1} WHERE {1}.{2} MATCHES tVal AND
              xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
         IF NOT AVAILABLE {1} 
            AND CAN-DO("NEXT,PREV":U,"{3}":U) THEN
         DO:
            ASSIGN 
               ThisMessage = "Search Item Was Not Found. Start search from "
                 + IF "{3}":U = "NEXT":U THEN "first record?"
                                         ELSE "last record?".
            RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
            IF ErrorStatus THEN
            DO:
               IF "{3}":U = "NEXT":U THEN
                 FIND FIRST {1} WHERE {1}.{2} MATCHES tVal AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
               ELSE
                 FIND LAST {1} WHERE {1}.{2} MATCHES tVal AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
            END. /* ErrorStatus */
         END. /* NOT AVAILABLE {1} */
      END.
      ELSE 
      DO:
         FIND {3} {1} WHERE {1}.{2} = tVal AND
              xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
         IF NOT AVAILABLE {1} 
            AND CAN-DO("NEXT,PREV":U,"{3}":U) THEN
         DO:
            ASSIGN 
               ThisMessage = "Search Item Was Not Found. Start search from "
                 + IF "{3}":U = "NEXT":U THEN "first record?"
                                         ELSE "last record?".
            RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
            IF ErrorStatus THEN
            DO:
               IF "{3}":U = "NEXT":U THEN
                 FIND FIRST {1} WHERE {1}.{2} = tVal AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
               ELSE
                 FIND LAST {1} WHERE {1}.{2} = tVal AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
            END. /* ErrorStatus */
         END. /* NOT AVAILABLE {1} */
      END.
   END.
   ELSE 
   DO: /* Not Case sensitive */
      IF UseWildCards:CHECKED THEN 
      DO:
        FIND {3} {1} WHERE {1}.{2} MATCHES FindValue AND
              xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
         IF NOT AVAILABLE {1} 
            AND CAN-DO("NEXT,PREV":U,"{3}":U) THEN
         DO:
            ASSIGN 
               ThisMessage = "Search Item Was Not Found. Start search from "
                 + IF "{3}":U = "NEXT":U THEN "first record?"
                                         ELSE "last record?".
            RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
            IF ErrorStatus THEN
            DO:
               IF "{3}":U = "NEXT":U THEN
                 FIND FIRST {1} WHERE {1}.{2} MATCHES FindValue AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
               ELSE
                 FIND LAST {1} WHERE {1}.{2} MATCHES FindValue AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
            END. /* ErrorStatus */
         END. /* NOT AVAILABLE {1} */
      END.
      ELSE
      DO:
        FIND {3} {1} WHERE {1}.{2} = FindValue AND 
              xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
         IF NOT AVAILABLE {1} 
            AND CAN-DO("NEXT,PREV":U,"{3}":U) THEN
         DO:
            ASSIGN 
               ThisMessage = "Search Item Was Not Found. Start search from "
                 + IF "{3}":U = "NEXT":U THEN "first record?"
                                         ELSE "last record?".
            RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"q*":U,"yes-no",ThisMessage).
            IF ErrorStatus THEN
            DO:
               IF "{3}":U = "NEXT":U THEN
                 FIND FIRST {1} WHERE {1}.{2} = FindValue AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
               ELSE
                 FIND LAST {1} WHERE {1}.{2} = FindValue AND
                 xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
            END. /* ErrorStatus */
         END. /* NOT AVAILABLE {1} */
      END.
   END. 
END.  /* Don't ignore spaces */
