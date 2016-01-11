/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*
File:
    prodict/_dctexec.p
    
descr:
    runs all routines from user_path, locks MetaSchema (search for *T),
    We return from this routine to its caller (usermenu.i: procedure
    perform_Func) either
    a) if the user_path   = ""      (no more programs to run)
    b) entry(1,user_path) = "*E"    (leave _dictc.p)
    c) entry(1,user_path) = "*T"    (start transaction)
    d) entry(1,user_path) = "*C"    (commit transaction)

history:
    hutegger    08/96   changed *O behavior. executable can have different
                        names per OPSYS. So I use user_env[1-6] to hold
                        the names of the programs per opsys. user_env[7]
                        holds the default value, which gets used when
                        one of user_env[1-6] = ""
    tomn        07/96   Changed the "proc name massage" logic to correctly
                        produce the correct relative path name for the
                        "protoxxx" utilities.  Since they do not follow the
                        original naming convention, the logic had to be changed
                        so as to not attempt to insert a subdirectory spec.
    hutegger    95/06   fixed commit-flag
    gfs         94/11   Make sure that "external" dbtype is used in
                        message. (Mainly for AS400 vs. AS/400).
    gfs         94/07   Report error message when running a *T function
                        on a Read-only database.
    mcmann     03/20/00 Added support for MS SQL Server 7
    D. McMann 02/21/03  Replaced GATEWAYS with DATASERVERS
    kmcintos   04/03/05 Added "Security" (_sec) and "Auditing" (_aud)
                        file-types
    kmayur     08/05/11 Added "Constraints for mss and oracle
                        (/mss/key) and (/ora/key)                        
    sdash      05/07/13 Added Logical DB validation in a Schema Holder
                        while using delta SQL utility.
*/
/*h-*/
/*---------------------------------------------------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

DEFINE NEW SHARED VARIABLE select_dbname   AS CHARACTER           NO-UNDO.

/* LANGUAGE DEPENDENCIES START */ /*-----------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 9 NO-UNDO INITIAL [
  /*  1,2*/ "Operations on", "are not supported in this copy of {&PRO_DISPLAY_NAME}.",
  /*    3*/ "The dictionary is in read-only mode - alterations not allowed.",
  /*4,5,6*/ "You tried to perform some", "operation on a", "database.",
  /*    7*/ "You can only perform this operation when the", 
  /*    8*/ "database is connected.",
  /*    9*/ "Schema holder database has no logical database of type."
].
/* LANGUAGE DEPENDENCIES END */ /*-------------------------------------*/

DEFINE VARIABLE i  AS INTEGER   NO-UNDO.
DEFINE VARIABLE l  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE op AS CHARACTER NO-UNDO.
DEFINE VARIABLE p  AS CHARACTER NO-UNDO.
DEFINE VARIABLE z  AS CHARACTER NO-UNDO.
DEFINE VARIABLE extdbtype1 AS CHARACTER NO-UNDO. /*cvt op dbtype to exttype*/
DEFINE VARIABLE extdbtype2 AS CHARACTER NO-UNDO. /*cvt dbtype to exttype */

/*---------------------------------------------------------------------*/

DO WHILE user_path <> "":

  assign z = ( if drec_file = ?
                 then ""
                 else user_filename
             ).
  if z <> INPUT FRAME user_ftr user_filename then
    DISPLAY z @ user_filename WITH FRAME user_ftr.
  ASSIGN
    z         = ENTRY(1,user_path)
    i         = INDEX(z,"=")
    op        = ( if i > 0
                   then "*A"
                   else z
                )
    user_path = TRIM(SUBSTRING(user_path
                              ,LENGTH(z,"character") + 2
                              ,-1
                              ,"character"
                              )).
  if  op BEGINS "?"
   or op BEGINS "!"
   or op BEGINS "@"
   or op BEGINS "&"
   then do:
    /* extdbtype1 replaces "SUBSTRING(op,2)" in messages */
    extdbtype1 = {adecomm/ds_type.i
                     &direction = "itoe" 
                     &from-type = "substring(op,2,-1,""character"")" }.
    /* extdbtype2 replaces "user_dbtype" in messages */                                    
    extdbtype2 = {adecomm/ds_type.i
                     &direction = "itoe" 
                     &from-type = "user_dbtype" }.
    if NOT CAN-DO(DATASERVERS,SUBSTRING(op,2,-1,"character"))
     then do:
      HIDE MESSAGE NO-PAUSE.
      /* Operations on <dbtype> are not supported in this copy of PROGRESS. */
      MESSAGE new_lang[1] extdbtype1 new_lang[2]
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      user_path = "".
      end.
    else if op BEGINS "!" or op BEGINS "@"
     then do:
      if user_dbtype <> SUBSTRING(op,2,-1,"character")
       then do:
        HIDE MESSAGE NO-PAUSE.
        /* You tried to perform some <type> operation on a <type> database. */
        MESSAGE new_lang[4] extdbtype1 new_lang[5] extdbtype2 new_lang[6]
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        user_path = "".
        end.
      else if op BEGINS "@" AND NOT CONNECTED (user_dbname)
       then do:
        HIDE MESSAGE NO-PAUSE.
        /* You can only perform this operation when the <type> database
      	   is connected. */
        MESSAGE new_lang[7] extdbtype1 new_lang[8] 
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        user_path = "".
        end.
      end.
      else if op BEGINS "&" 
       then do:
       l = NO.
       /* l = YES if there are any foreign schema logical db's, Also assigned "selected" db */
       IF LDBNAME("DICTDB") <> ? THEN DO: 
        FOR EACH DICTDB._DB NO-LOCK:
          IF DICTDB._DB._Db-type = SUBSTRING(op,2,-1,"character") THEN DO:
            IF DICTDB._DB._Db-name = user_dbname THEN 
              select_dbname = user_dbname.
            l = YES.
          end.
      end.
      end.
      if NOT l THEN DO:  
        HIDE MESSAGE NO-PAUSE.
        /* Schema holder database has no logical database of type <type>. */
        MESSAGE new_lang[9] SUBSTRING(op,2,-1,"character") 
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        user_path = "".
      end.
    end.
  end.
  else
  if op BEGINS "*" then   /* Is this a command? */
  DO:
    if op = "*A" then /*------------------------------*/ /* assignment */
      user_env[INTEGER(SUBSTRING(z,1,i - 1,"character"))]
                    = SUBSTRING(z,i + 1,-1,"character").
     else
    if op = "*C" /*---------------------------*/ /* commit transaction */
     then do:
      assign dict_trans = false.
      RETURN.  /* return to Perform_Func to leave transaction */
      end.
    else if op = "*E" /*------------------------------------*/ /* exit */
     then do:
      user_path = op.
      LEAVE.  /* return to Perform_Func to leave _dictc.p completely */
      end.
    else if op BEGINS "*L" /*------------------*/ /* run local program */
      then RUN VALUE(SUBSTRING(z,4,-1,"character")).
    else if op = "*N" then . /*-----------------------------*/ /* noop */
    else if op = "*O" /*-----------------------*/ /* run opsys program */
     then do:
      PAUSE 0.
      case OPSYS:
        when "MSDOS" then assign p = ( if user_env[2] = ""
                                        then user_env[7]
                                        else user_env[2]
                                     ).
        when "UNIX"  then assign p = ( if user_env[4] = ""
                                        then user_env[7]
                                        else user_env[4]
                                     ).
        when "WIN32" then assign p = ( if user_env[6] = ""
                                        then user_env[7]
                                        else user_env[6]
                                     ).
        end case.
      os-command value(p).
      end.
    else if op = "*Q" then QUIT. /*-------------------------*/ /* quit */
    else if op = "*R" /*--------------------------------*/ /* rollback */
     then do:
      ASSIGN
        user_path   = op
        cache_dirty = TRUE
        dict_trans  = FALSE.
      RETURN.
      end.
    else if op BEGINS "*MSL" /*------------------*/ /* MetaSchema lock */
     then do:
      /* this switch got set in the *T section, after checking dict_rog
       * and setting dict_trans = TRUE.
       * The logic then returned back to _dictc.p (usermenu.i procedure
       * Perform_Func) and called me (_dctexec.p) again with *MSL, as
       * first entry of the user_path.
       * Now, that I'm in  the transaction, I lock the MetaSchema with
       * the following trick...
       */
      _schema-lock:
      DO ON ERROR UNDO,LEAVE:
        CREATE DICTDB._Field.
        UNDO _schema-lock,LEAVE _schema-lock.
        end.
      end.
    else if op BEGINS "*T" /*------------------*/ /* transaction start */
     then do:
      if dict_rog
       then do:
        MESSAGE new_lang[3] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        ASSIGN user_path = "".
        LEAVE.
        end.
      ASSIGN
        l          = dict_trans
        dict_trans = TRUE
        user_trans = ( if INDEX(z,":") > 0
                         then SUBSTRING(z,4,-1,"character")
                         else "")
        user_path  = "*MSL," + user_path. /* to get MetaSchema lock */
        LEAVE.  /* return to Perform_Func to start transaction */
      end.
    end.  /* end of command processing */
   else DO ON STOP  UNDO, RETURN ERROR 
          ON ERROR UNDO, RETURN ERROR:
    if      z BEGINS "_dct"  then .
    else if z BEGINS "_usr"  then z = "user/" + z.
    else if z BEGINS "_gui"  then z = "gui/"  + z.
    else if z BEGINS "_dmp"
         or z BEGINS "_lod"  then z = "dump/" + z.
    else if z BEGINS "_gat"  then z = "gate/" + z.
    else if z BEGINS "_as4"  then z = "as4/"  + z.  /* AS400 */
    else if z BEGINS "_bti"  then z = "bti/"  + z.  /* CTOS-ISAM */
    else if z BEGINS "_gen"  then z = "gen/"  + z.  /* Generic */
    else if z BEGINS "_ism"  then z = "ism/"  + z.  /* C-ISAM and NetISAM */
    else if z BEGINS "_oag"  then z = "oag/"  + z.  /* Object Access */
    else if z BEGINS "_ora"  then z = "ora/"  + z.  /* Oracle */
    else if z BEGINS "_pro"  then z = "pro/"  + z.  /* PROGRESS */
    else if z BEGINS "_rdb"  then z = "rdb/"  + z.  /* Rdb */
    else if z BEGINS "_rms"  then z = "rms/"  + z.  /* RMS */
    else if z BEGINS "_syb"  then z = "syb/"  + z.  /* SYBASE */
    ELSE IF z BEGINS "_mss"  THEN z = "mss/"  + z.  /* MS SQL Server 7 */
    else if z BEGINS "_odb"  then z = "odb/"  + z.  /* ODBC */
    ELSE IF z BEGINS "_aud"  THEN z = "aud/"  + z.  /* Auditing */
    ELSE IF z BEGINS "_sec"  THEN z = "sec/"  + z.  /* Security */
    ELSE IF z BEGINS "_msc"  THEN z = "mss/key/"  + z. /* MSS constraint */
    ELSE IF z BEGINS "_orc"  THEN z = "ora/key/"  + z. /* ORA constraint */
    /*--------------------------------------------------------------------*
       This had to be changed to allow the "protoxxx" utilities to be 
       called from the DataServer menu (tsn 7/96).  Before, it was just
       "else z = 'misc/' + z", which would tack an unwanted "misc/" on
       the beginning of, for example, "ora/protoora".
     *-----------------------------------------------------------*/
    else if z BEGINS "_"     then z = "misc/" + z.
    RUN VALUE("prodict/" + z + ".p").
    end.
  if CAN-DO(",ALL,SOME",user_filename) then drec_file = ?.
  if user_path = "" AND user_trans <> "*" then user_path = user_trans.
  end.

RETURN.

/*---------------------------------------------------------------------*/
