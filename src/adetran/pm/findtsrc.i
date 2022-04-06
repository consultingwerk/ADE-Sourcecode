/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/findtsrc.i
Author:       SLK
Created:      07/08/98
Updated:      09/98 
Purpose:      Translation Manager's find include file
Background:   Include file for locating translation records 
              (no NEXT or PREV - those are located in findtsn.i
               and findtsp.i)
              (see comments in pm/_find.w).
NOTE:         This code is different from VT's _find.i because
              xlatedb.xl_string_info.original_string is setup as a
              case-sensitive string therefore the "=" will FAIL.
              We need to lc values before comparison .

For readability we'll leave the action (NEXT,FIRST,LAST etc.)
Called By:    pm/_find.w
Usage:        {adetran/pm/findtran.i SourcePhrase NEXT}

{1} Type of Phrase = SourcePhrase or TargetPhrase
{2} FIRST, LAST, CURRENT...

OLD 1=xlatedb.xlatedb.xl_instance, sourphrase next

FIRST
   FIND FIRST xl_string_info
   FIND FIRST xl_instance
   FIND FIRST xl_translation
LAST
   FIND LAST xl_string_info
   FIND LAST xl_instance
   FIND LAST xl_translation
CURRENT
   FIND CURRENT xl_string_info
   FIND CURRENT xl_instance
   FIND CURRENT xl_translation
   
*/

IF IgnoreSpaces:CHECKED THEN 
DO:
   IF MatchCase:CHECKED THEN 
   DO:
      IF UseWildCards:CHECKED THEN 
      DO:
         FIND {2} xlatedb.XL_String_Info WHERE 
            TRIM(xlatedb.XL_String_Info.original_string) MATCHES TRIM(tVal)
         NO-LOCK NO-ERROR.
         FIND {2} xlatedb.xl_instance WHERE 
            xlatedb.xl_instance.sequence_num = xlatedb.XL_String_Info.sequence_num 
         NO-LOCK NO-ERROR.
         FIND {2} xlatedb.xl_translation WHERE 
                xlatedb.xl_instance.sequence_num = xlatedb.XL_String_Info.sequence_num 
            AND xlatedb.xl_translation.sequence_num = xlatedb.XL_instance.instance_num 
         NO-LOCK NO-ERROR.
      END.  /* UseWildCards */
      ELSE 
      DO:
         FIND {2} xlatedb.XL_String_Info WHERE 
            TRIM(xlatedb.XL_String_Info.original_string) = TRIM(tVal) 
         NO-LOCK NO-ERROR.
         FIND {2} xlatedb.xl_instance WHERE 
            xlatedb.xl_instance.sequence_num = xlatedb.XL_String_Info.sequence_num 
         NO-LOCK NO-ERROR.
         FIND {2} xlatedb.xl_translation WHERE 
                xlatedb.xl_instance.sequence_num = xlatedb.XL_translation.sequence_num 
            AND xlatedb.xl_instance.instance_num = xlatedb.XL_translation.instance_num 
         NO-LOCK NO-ERROR.
      END.  /* NOT UseWildCards */
      END. /* MatchCase */
      ELSE 
      DO: /* Not Case sensitive */
         IF UseWildCards:CHECKED THEN 
         DO:
            FIND FIRST xlatedb.XL_String_Info WHERE 
               TRIM(LC(xlatedb.XL_String_Info.original_string)) MATCHES TRIM(LC(FindValue)) 
            NO-LOCK NO-ERROR.
            FIND {2} xlatedb.xl_instance WHERE 
               xlatedb.xl_instance.sequence_num = xlatedb.XL_String_Info.sequence_num 
            NO-LOCK NO-ERROR.
            FIND {2} xlatedb.xl_translation WHERE 
                   xlatedb.xl_instance.sequence_num = xlatedb.XL_translation.sequence_num 
               AND xlatedb.xl_instance.instance_num = xlatedb.XL_translation.instance_num 
            NO-LOCK NO-ERROR.
         END. /* WildCards */
         ELSE
         DO:
            FIND {2} xlatedb.XL_String_Info WHERE 
               TRIM(LC(xlatedb.XL_String_Info.original_string)) = TRIM(LC(FindValue)) 
            NO-LOCK NO-ERROR.
            FIND {2} xlatedb.xl_instance WHERE 
               xlatedb.xl_instance.sequence_num = xlatedb.XL_String_Info.sequence_num 
            NO-LOCK NO-ERROR.
            FIND {2} xlatedb.xl_translation WHERE 
                   xlatedb.xl_instance.sequence_num = xlatedb.XL_translation.sequence_num 
               AND xlatedb.xl_instance.instance_num = xlatedb.XL_translation.instance_num 
            NO-LOCK NO-ERROR.
         END. /* Not Wildcards */
      END. /* Not Case sensitive */
   END.  /* IF ignore spaces */
   ELSE
   DO: /* Don't ignore spaces */
     IF MatchCase:CHECKED THEN 
     DO:
       IF UseWildCards:CHECKED THEN 
       DO:
          FIND {2} xlatedb.XL_String_Info WHERE 
                  xlatedb.XL_String_Info.original_string MATCHES tVal
          NO-LOCK NO-ERROR.
          FIND {2} xlatedb.xl_instance WHERE 
                xlatedb.xl_instance.sequence_num = xlatedb.XL_String_Info.sequence_num 
          NO-LOCK NO-ERROR.
          FIND {2} xlatedb.xl_translation WHERE 
                 xlatedb.xl_instance.sequence_num = xlatedb.XL_translation.sequence_num 
             AND xlatedb.xl_instance.instance_num = xlatedb.XL_translation.instance_num 
          NO-LOCK NO-ERROR.
       END. /* */
       ELSE
       DO:
          FIND {2} xlatedb.XL_String_Info WHERE 
               xlatedb.XL_String_Info.original_string = tVal 
          NO-LOCK NO-ERROR.
          FIND {2} xlatedb.xl_instance WHERE 
                xlatedb.xl_instance.sequence_num = xlatedb.XL_String_Info.sequence_num 
          NO-LOCK NO-ERROR.
          FIND {2} xlatedb.xl_translation WHERE 
                 xlatedb.xl_instance.sequence_num = xlatedb.XL_translation.sequence_num 
             AND xlatedb.xl_instance.sequence_num = xlatedb.XL_translation.sequence_num 
          NO-LOCK NO-ERROR.
       END. /* Wildcard */
   END. /* MatchCase */
   ELSE 
   DO: /* Not Case sensitive */
       IF UseWildCards:CHECKED THEN 
       DO:
          FIND {2} xlatedb.XL_String_Info WHERE 
             LC(xlatedb.XL_String_Info.original_string) MATCHES LC(FindValue)
          NO-LOCK NO-ERROR.
          FIND {2} xlatedb.xl_instance WHERE 
             xlatedb.xl_instance.sequence_num = xlatedb.XL_String_Info.sequence_num 
          NO-LOCK NO-ERROR.
          FIND {2} xlatedb.xl_translation WHERE 
                 xlatedb.xl_instance.sequence_num = xlatedb.XL_translation.sequence_num 
             AND xlatedb.xl_instance.instance_num = xlatedb.XL_translation.instance_num 
          NO-LOCK NO-ERROR.
       END. /* Wildcard */
       ELSE
       DO:
          FIND {2} xlatedb.XL_String_Info WHERE 
             LC(xlatedb.XL_String_Info.original_string) = LC(FindValue) 
          NO-LOCK NO-ERROR.
          FIND {2} xlatedb.xl_instance WHERE 
             xlatedb.xl_instance.sequence_num = xlatedb.XL_String_Info.sequence_num 
          NO-LOCK NO-ERROR.
          FIND {2} xlatedb.xl_translation WHERE 
                 xlatedb.xl_instance.sequence_num = xlatedb.XL_translation.sequence_num 
             AND xlatedb.xl_instance.instance_num = xlatedb.XL_translation.instance_num 
          NO-LOCK NO-ERROR.
       END. /* Wildcard */
   END. /* Not Case sensitive */
END. /* Don't ignore spaces */
