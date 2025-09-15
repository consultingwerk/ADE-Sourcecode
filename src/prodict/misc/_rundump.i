/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*

Preprocessor parameters
    1 - table name 
    2 - where .. [use index] no-lock
    3 -  no-lobs (trailing space)
    4 -  except <fields>
History:
 
  K McIntosh 04/25/05  Added code, when dumping _db-detail table, to ensure 
                       that the current _db-detail record is the first one 
                       in the output file.
                       
                       Also added except list support, to allow facilities to
                       compile lists of specific data not to dump.  Added
                       code to prevent system owned _sec-role records from
                       being dumped.
                       
*/                       
/* _rundump.i - Data Dictionary file dump module */
DEFINE SHARED STREAM   dump.

DEFINE SHARED VARIABLE recs         AS DECIMAL   FORMAT "ZZZZZZZZZZZZ9" NO-UNDO.
DEFINE SHARED VARIABLE xpos         AS INTEGER   NO-UNDO.
DEFINE SHARED VARIABLE ypos         AS INTEGER   NO-UNDO.
DEFINE SHARED VARIABLE user_excepts AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE drec_db      AS RECID     NO-UNDO.

/* Will be "y" or "n" */
DEFINE INPUT PARAMETER p_Disable AS CHARACTER NO-UNDO.

DEFINE VARIABLE i     AS INTEGER     NO-UNDO.

DEFINE VARIABLE cGuid AS CHARACTER   NO-UNDO.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  IF TERMINAL <> "" THEN DO:
    DEFINE STREAM run_dump.
    OUTPUT STREAM run_dump TO TERMINAL.

  END.
&ENDIF
IF p_Disable  = "y" THEN
  DISABLE TRIGGERS FOR DUMP OF DICTDB2.{1}.
recs = 0.

/* If the table is _db-detail, ensure that we dump out the current record
   first. */
&IF "{1}" = "_db-detail" &THEN
  FIND DICTDB2._db WHERE RECID(DICTDB2._db) EQ drec_db NO-LOCK NO-ERROR.
  FIND DICTDB2._db-detail 
      WHERE DICTDB2._db-detail._db-guid = DICTDB2._db._db-guid NO-LOCK NO-ERROR.
  IF AVAILABLE DICTDB2._db-detail THEN DO:
    ASSIGN cGuid = DICTDB2._db._db-guid
           recs  = recs + 1.
    EXPORT STREAM dump DICTDB2._db-detail {3}.
  END.
&ENDIF
 
for each DICTDB2.{1} {2}: 

  /* Here we prevent dumping the current record a second time. */
  &IF "{1}" = "_db-detail" &THEN
     IF DICTDB2._db-detail._db-guid = cGuid THEN NEXT.
  &ENDIF
  
  /* Ensure that this record is not in the except list before 
     dumping it. */
  &IF "{1}" = "_sec-role" &THEN
    IF CAN-DO(user_excepts, DICTDB2._sec-role._role-name) THEN NEXT.
  &ENDIF
  
  &IF "{1}" = "_aud-event" &THEN
    IF DICTDB2._aud-event._event-id < 32000 THEN NEXT.
  &ENDIF
 
  assign recs = recs + 1.
  export stream dump DICTDB2.{1} {4} {3}.
  
  if   terminal       <> ""
   and recs modulo 100 = 0
   then do:  /* */
    
    end.
  end.  /* for each DICTDB2.{1} {2} */

RETURN.
