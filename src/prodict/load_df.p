/*********************************************************************
* Copyright (C) 2007-2010 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: prodict/load_df.p

    End-user entry point for Admin Tool's "Load .df file" utility
      
Input Parameters:
    df-file-name    The name of the .df file to be loaded into DICTDB
    
Output Parameters:
    none
    
Used/Modified Shared Objects:
    defines several NEW SHARED objects
    
History:
    Mario B.    99/03/18    Added user_env[19] to signal _lodsddl.p that it is
                            being called by this code.  If so, _lodsddl.p
                            eliminates the display of any "remaining"
                            alert-boxes not dealt with by prior modifications
                            designed to handle this issue.  
    tomn        08/29/95    Added check for codepage spec in .df file
                            trailer; Leaves as UNDEFINED if none specified
    mcmann      07/13/98    Added check for both cpstream and codepage
    mcmann      03/14/01    Added ability to pass in two entries in input parameter
                            to allow user to commit when errors are found.
    mcmann      04/23/02    Added ability to pass in three entries so that the
                            user can do on-line schema adds.
    mcmann      10/17/03    Add NO-LOCK statement to _Db find in support of on-line schema add
    kmcintos    07/28/05    Added check for false alarm in read_bits 
                            20050727-041.
    fernando    06/20/07    Support for large files
    fernando    07/21/08    Support for encryption
    fernando    03/20/09    Additional changes for encryption
    fernando    04/13/09    Changes for alternate buffer pool
    fernando    03/05/10    Fix code that checks rollback error
----------------------------------------------------------------------------*/
/*h-*/

/*==========================  DEFINITIONS ===========================*/

DEFINE INPUT PARAMETER df-file-name AS CHARACTER NO-UNDO.

{ prodict/user/uservar.i NEW }
{ prodict/dictvar.i NEW }

DEFINE VARIABLE save_ab     AS LOGICAL        NO-UNDO.
DEFINE VARIABLE codepage    AS CHARACTER      NO-UNDO FORMAT "X(20)".
DEFINE VARIABLE lvar        AS CHAR EXTENT 10 NO-UNDO.
DEFINE VARIABLE lvar#       AS INT            NO-UNDO.
DEFINE VARIABLE i           AS INT64          NO-UNDO.
DEFINE VARIABLE old-session AS CHARACTER      NO-UNDO INITIAL ?.
DEFINE VARIABLE validObjs   AS LOGICAL        NO-UNDO.
DEFINE VARIABLE cTmp        AS CHARACTER      NO-UNDO.
DEFINE VARIABLE cMsg        AS CHARACTER      NO-UNDO.
DEFINE VARIABLE stopped     AS LOGICAL        NO-UNDO.
DEFINE VARIABLE xError      AS LOGICAL        NO-UNDO.
DEFINE VARIABLE OK_trans    AS LOGICAL       /*UNDO*/.

DEFINE STREAM loaderr.

/*========================= MAINLINE CODE ============================*/

/*check runtime create privileges*/
FOR EACH _File
  WHERE _File._File-number >= -4 AND _File._File-number <= -1:
  IF CAN-DO(_File._Can-write,USERID("DICTDB"))
           AND CAN-DO(_File._Can-create,USERID("DICTDB")) THEN NEXT.
  MESSAGE "You do not have permission to load table definitions.".
  RETURN.
END. 

FIND FIRST _Db WHERE _Db._Db-local NO-LOCK.
ASSIGN
  user_dbname = LDBNAME("DICTDB")
  user_dbtype = DBTYPE("DICTDB")
  drec_db     = RECID(_Db)  
  user_env[6] = "f"
  user_env[8] = user_dbname
  user_env[19] = THIS-PROCEDURE:FILE-NAME
  codepage    = "".  
  
/* If user wants to commit even if there are errors in the df, they can
   pass in a string composed of "df-file-name,yes"  If user_env[15] is
   set to yes, the _lodsddl.p will handle for committing with errors.
   
   If user wants to load new tables and sequences on-line than df-file-name
   must have three entries, "df-file-name,<commit>,<session parameter>".  
   example:  Commit with errors and loading on-line = "sports,df,yes,NEW OBJECTS" 
             Do not commit with errors and loading on line = "sports.df,,NEW OBJECTS"
             Just passing in file name "sports.df".
*/   
IF NUM-ENTRIES(df-file-name) = 3 THEN
    ASSIGN user_env[2] = ENTRY(1,df-file-name)
           user_env[15] = (IF ENTRY(2,df-file-name) <> "" THEN ENTRY(2,df-file-name)
                          ELSE "")
           old-session = SESSION:SCHEMA-CHANGE
           SESSION:SCHEMA-CHANGE = ENTRY(3,df-file-name) .
ELSE 
   
IF NUM-ENTRIES(df-file-name) = 2 THEN
    ASSIGN user_env[2] = ENTRY(1,df-file-name)
           user_env[15] = ENTRY(2,df-file-name).
ELSE
   ASSIGN user_env[2] = df-file-name.

RUN read-cp.  /* get codepage out of the .df file trailer (tomn 8/28/95) */ 

ASSIGN user_env[10] = CODEPAGE
       save_ab = SESSION:APPL-ALERT-BOXES
       SESSION:APPL-ALERT-BOXES = NO.


DO TRANSACTION ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO, LEAVE:

  /* The reason we do this here is so that we cache the settings for encryption policies
     and buffer pool settings and then don't save them in _lodsddl.p. 
     We will wait until we get back here to start a new transaction for adding them.
     The reason is that if the encryption policies are for newly created objects, 
     their object numbers won't get assigned by core until the end of the transaction
     where they are created, so we can't create the objects and the policies in the 
     same transaction.
  */
  ASSIGN dictObjAttrCache = YES.

  user_path = "*".

  /* OE00193991 - this will get backed out if some error happens */
  ASSIGN OK_trans = TRUE.

  RUN "prodict/dump/_lodv5df.p".
  IF user_path = "*" THEN RUN "prodict/dump/_lodsddl.p".
  
  IF user_path = "*R" then UNDO, LEAVE.

  FINALLY: /*  OE00193991 - use a finally block to check for rollback */
      IF OK_trans = FALSE THEN DO:
          /* transaction was backed out */
          /* Fernando: 20020129-017 if there was a message from the client after the load process started, 
          search for error number 151 (defined as ERROR_ROLLBACK) and write to the error log file. The error
          would be the first entry in message queue ( _msg(1) ).
          */
          IF _msg(1) = {&ERROR_ROLLBACK} THEN
          DO:
              OUTPUT TO VALUE (LDBNAME("DICTDB") + ".e") APPEND.
              PUT UNFORMATTED TODAY " " STRING(TIME,"HH:MM") " : "
              "Load of " user_env[2] " into database " 
              LDBNAME("DICTDB") " was unsuccessful." SKIP " All the changes were backed out..." 
              SKIP " {&PRO_DISPLAY_NAME} Recent Message(s): (" _msg(1) ") " .
              IF _msg(2) > 0 THEN 
                 PUT UNFORMATTED "(" _msg(2) ")." SKIP(1).
              OUTPUT CLOSE.
          END.
      END.

  END FINALLY.

END.
             
IF  OK_trans THEN DO:

    /* only process policies or buffer-pool settings if there wasn't an error in the first phase */
    IF INDEX(user_path,"4=error") = 0 AND 
        (VALID-OBJECT(dictEPolicy) OR VALID-OBJECT(dictObjAttrs)) THEN DO:
        DO TRANSACTION ON ERROR UNDO, LEAVE:
            DEFINE BUFFER my_Db FOR DICTDB._Db.
    
            ASSIGN stopped = YES.
        
            DO ON STOP UNDO, LEAVE:
                /* try to get the schema lock again as soon as possible since we lost it
                   when the transaction above ended
                */
                FIND FIRST my_Db WHERE RECID(my_Db) = drec_db.
        
                IF VALID-OBJECT(dictEPolicy) THEN DO:
                    /* now we should be outside the main transaction. If not, new tables/index/fields will not have
                       been assigned with the object number.
                       We pass this-procedure so that it calls us back to report any errors.
                    */
                    validObjs =  dictEPolicy:cacheSavePolicy(INPUT THIS-PROCEDURE, OUTPUT cTmp).
            
                    IF NOT validObjs THEN DO:
                       RUN Show_Phase2_Error ("Cannot enable encryption for " + cTmp + 
                                              ". Make sure there is no " +
                                              "transaction active when the load process is initiated.").
                    END.
    
                END.

                IF NOT xError AND VALID-OBJECT(dictObjAttrs) THEN DO:

                    /* now we should be outside the main transaction. If not, new tables/index/fields 
                       will not have been assigned with the object number.
                       We pass the handle of this procedure so that secErrorCallback gets called back
                       when an error happens.
                    */
                    IF NOT dictObjAttrs:cacheSaveSettings(INPUT THIS-PROCEDURE,
                                                          OUTPUT cTmp) THEN DO:
                       RUN Show_Phase2_Error ("Cannot set buffer pool for " + cTmp 
                                              + ". Make sure there is no "
                                              + "transaction active when the load process is initiated.",
                                              "b").
                    END.
                END.

                stopped = NO.
            END.
    
            /* if stopped or error, then undo this transactions */
            IF stopped OR xError THEN
                UNDO, LEAVE.
    
            FINALLY:
                IF stopped OR xError THEN DO:
    
                    RUN Show_Phase2_Error (INPUT ?, INPUT ?).
    
                    MESSAGE "Please check" LDBNAME("DICTDB") 
                            ".e for load errors and/or warnings.".
                END.
            END FINALLY.
        END.
    END.
END.

IF VALID-OBJECT(dictEPolicy) THEN
  DELETE OBJECT dictEPolicy.

IF VALID-OBJECT(dictObjAttrs) THEN
  DELETE OBJECT dictObjAttrs.

IF old-session <> ? THEN
  ASSIGN SESSION:SCHEMA-CHANGE = old-session

SESSION:APPL-ALERT-BOXES = save_ab.



/*====================== INTERNAL PROCEDURES =========================*/

PROCEDURE read-cp.
  /* Read trailer of file and find codepage */
  /* (partially stolen from lodtrail.i)     */
  
  INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP.
  SEEK INPUT TO END.
  i = SEEK(INPUT) - 12.
  SEEK INPUT TO i. /* position to possible beginning of last line */

  READKEY PAUSE 0.
  IF LASTKEY = 13 THEN /* deal with CRLF on Windows */
      READKEY PAUSE 0.

  ASSIGN
    lvar# = 0
    lvar  = ""
    i     = 0.
  DO WHILE LASTKEY <> 13 AND i <> ?: /* get byte count (last line) */
    i = (IF LASTKEY > 47 AND LASTKEY < 58 
          THEN i * 10 + LASTKEY - 48
          ELSE ?).
    READKEY PAUSE 0.
  END.

  IF i > 0 then run get_psc. /* get it */
  ELSE RUN find_psc. /* look for it */
  INPUT CLOSE.
  DO i = 1 TO lvar#:
    IF lvar[i] BEGINS "cpstream=" OR lvar[i] BEGINS "codepage=" THEN codepage = TRIM(SUBSTRING(lvar[i],10,-1,"character":U)).
  END.
END PROCEDURE.

PROCEDURE get_psc:
  /* using the byte count, we scoot right down there and look for
   * the beginning of the trailer ("PSC"). If we don't find it, we
   * will go and look for it.
   */
  DEFINE VARIABLE rc AS LOGICAL INITIAL no.
  
  _psc:
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    SEEK INPUT TO i. /* skip to beginning of "PSC" in file */
    READKEY PAUSE 0. IF LASTKEY <> ASC("P") THEN LEAVE _psc. /* not there!*/
    READKEY PAUSE 0. IF LASTKEY <> ASC("S") THEN LEAVE _psc.
    READKEY PAUSE 0. IF LASTKEY <> ASC("C") THEN LEAVE _psc.
    ASSIGN rc = yes. /* found it! */
    RUN read_bits (INPUT i). /* read trailer bits */
  END.
  IF NOT rc THEN RUN find_psc. /* look for it */
END PROCEDURE.

PROCEDURE find_psc:
  /* If the bytecount at the end of the file is wrong, we will jump
   * back the maximum number of bytes in a trailer and start looking
   * from there. If we still don't find it then tough luck.
   * NOTE: Variable p holds the number of bytes to roll back. AS of
   * 7/21/94, the max size of a trailer (.d) is 204 bytes, if you add
   * anything to this trailer, you must change this number to reflect
   * the number of bytes you added. I'll use 256 to add a little padding. (gfs)
   */
  DEFINE VARIABLE p AS INT64   INITIAL 256. /* really 204, added extra just in case */
  DEFINE VARIABLE l AS INT64.               /* LAST char position */
  
  SEEK INPUT TO END.
  ASSIGN l = SEEK(INPUT). /* EOF */
  SEEK INPUT TO SEEK(INPUT) - MINIMUM(p,l). /* take p, or size of file */
  IF SEEK(INPUT) = ? THEN RETURN.
  _scan:
  REPEAT ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    READKEY PAUSE 0.
    p = SEEK(INPUT). /* save off where we are looking */
    IF LASTKEY = ASC("P") THEN DO:
       READKEY PAUSE 0.
       IF LASTKEY <> ASC("S") THEN NEXT.
       ELSE DO: /* found "PS" */
         READKEY PAUSE 0.
         IF LASTKEY <> ASC("C") THEN NEXT.
         ELSE DO: /* found "PSC"! */
           RUN read_bits (INPUT p - 1).
           IF RETURN-VALUE EQ "False Alarm" THEN NEXT.
           LEAVE.
         END. /* IF "C" */
       END. /* IF "S" */    
    END. /* IF "P" */
    ELSE IF p >= l THEN LEAVE _scan. /* at EOF, so give up */
  END. /* repeat */
END.

PROCEDURE read_bits:
  /* reads trailer given a starting position 
   */ 
  DEFINE INPUT PARAMETER i as INT64  . /* "SEEK TO" location */

  DEFINE VARIABLE iStartAt   AS INT64       NO-UNDO.
  DEFINE VARIABLE iLinesRead AS INTEGER     NO-UNDO INITIAL 1.
    
  iStartAt = i.

  SEEK INPUT TO i.
  REPEAT:
    IMPORT lvar[lvar# + 1].
    
    /* The entire line must be equal to "PSC" which is a reserved 
       keyword, but if it's part of a string we simply return to 
       where we left off and continue searching for the trailer.
       20050727-041 */
    IF iLinesRead = 1 AND 
       TRIM(lvar[lvar# + 1]) NE "PSC" THEN DO:
      SEEK INPUT TO iStartAt + LENGTH(lvar[lvar# + 1]) + 1.
      RETURN "False Alarm".
    END.

    ASSIGN lvar#      = lvar# + 1
           iLinesRead = iLinesRead + 1.

  END.
  RETURN "".
END PROCEDURE. 

/* Callback for errors when saving policies */
PROCEDURE secErrorCallback:
    DEFINE INPUT  PARAMETER pmsg      AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER lContinue AS LOGICAL NO-UNDO.

    /* we always continue trying to load the policies */
    lContinue = YES.

    RUN Show_Phase2_Error (INPUT pmsg, INPUT "e").
END.

/* Callback for errors when saving object attributes (buffer pool) */
PROCEDURE attrsErrorCallback:
    DEFINE INPUT  PARAMETER pmsg      AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER lContinue AS LOGICAL NO-UNDO.

    /* we always continue trying to load the settings */
    lContinue = YES.

    RUN Show_Phase2_Error (INPUT pmsg, INPUT "b").
END.

/* Handle errors during encryption policy load phase */
PROCEDURE Show_Phase2_Error:
    DEFINE INPUT PARAMETER p_msg  AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p_cStr AS CHAR NO-UNDO.

    DEFINE VARIABLE dbload-e AS CHARACTER NO-UNDO.

    ASSIGN dbload-e = LDBNAME("DICTDB") + ".e".

    OUTPUT STREAM loaderr TO VALUE(dbload-e) APPEND.

    IF p_cStr = "e" THEN
       p_cStr = "encryption policy".
    ELSE IF p_cStr = "b" THEN
        p_cStr = "buffer pool".
    
    IF p_msg = ? THEN DO:
        /* special case - the last error message about not loading policies and/or buffer-pool */
        p_msg = "Definitions for policies and attributes are loaded in a separate transaction." +
                " Errors caused that transaction to rollback. Other definitions were committed.".

        PUT STREAM loaderr UNFORMATTED
                   SKIP(1) p_msg SKIP.
    END.
    ELSE DO:
        PUT STREAM loaderr UNFORMATTED
                   SKIP(1) "** Error loading " p_cStr " **"  
                   SKIP(1) p_msg SKIP.
    END.

    ASSIGN xerror = true.

    OUTPUT STREAM loaderr CLOSE.

END.

/*========================== END OF load_df.p ==========================*/


