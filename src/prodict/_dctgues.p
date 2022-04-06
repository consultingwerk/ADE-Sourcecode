/*********************************************************************
* Copyright (C) 2000,2010 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/_dctgues.p

Description:
    guess at which db the user wants to use. We follow the folowing rules:
    a) take the db that DICTDB is pointing to
    b) if this is an empty schemaholder, take the first supported
        foreign schema
    This routine assumes the db cache is good; the new version doesn't
    care about the cache.

    THIS ROUTINE CAN BE RUN WITHOUT A CONNECTED DB
    
Input Parameters:
    none

Output Parameters:
    none

Used/Modified Shared Info:
    cache_dirty     in:  ?    if first call of this routine
                    out: TRUE if first call of this routine
                         unchanged otherwise
    drec_db         RECID of the selected db
    user_dbname     logical name of the selected db
    user_dbtype     type of the selected db (internal name)
    user_filename   unchanged

History:
    95/08    hutegger    new version created
    97/12/18 laurief     Made V8 to "generic version" changes
    00/06/14 D.McMann    When new version created running _dctsset.p was
                         left off so dict_rog not being re-set 20000614001
    09/30/10 fernando     Support for OE 11

--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

/* this assumes the db cache is good */

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

{ adecomm/getdbs.i
  &new = "new"
  }

define variable l_edbtyp    as character.
define variable l_i         as integer.
define variable old_dbver   as character NO-UNDO.

/* LANGUAGE DEPENDENCIES START */ /*--------------------------------*/
define variable l_msg as character no-undo extent 11 initial [
  /* 1*/ "You have been automatically switched to database",
 /*2,3*/ "There are no R12", "databases connected. This tool cannot",
  /* 4*/ "be used with a OpenEdge", 
  /* 5*/ "database. Use the tool under OpenEdge", 
  /* 6*/ "to access such a database.",
/*7-11*/ "" /* reserved */
  ].
/* LANGUAGE DEPENDENCIES END */ /*----------------------------------*/

/*---------------------------  TRIGGERS  ---------------------------*/
  
/*------------------------  INT.-PROCEDURES  -----------------------*/

/*------------------------  INITIALIZATIONS  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

/* here starts the new version */

repeat l_i = 1 to num-entries(DATASERVERS):
  assign 
    l_edbtyp = l_edbtyp + "," + { adecomm/ds_type.i
                                   &direction = "itoe"
                                   &from-type = "ENTRY(l_i,DATASERVERS)"
                                }.
  end.

if NUM-DBS = 0
 then do:
  assign
    cache_dirty   = TRUE
    drec_db       = ?
    user_dbname   = ""
    user_dbtype   = ""
    user_filename = "".
  delete alias DICTDB.
  delete alias DICTDBG.
  end.
  
 else do:  /* there is at least one db connected */

  assign user_dbtype = "". /* to signal not found yet ... */
  
  RUN adecomm/_getdbs.p.

/*----- 1. gues: try to use DICTDBG ---*/

  if LDBNAME("DICTDBG") <> ?
   then do:  /* DICTDBG set */
    find first s_ttb_db
      where s_ttb_db.ldbnm = LDBNAME("DICTDBG")
      no-error.
    if available s_ttb_db
     and INTEGER(s_ttb_db.vrsn)  > 11
     and LOOKUP(s_ttb_db.dbtyp,l_edbtyp) <> 0
     then assign
      drec_db     = s_ttb_db.dbrcd
      user_dbname = s_ttb_db.ldbnm
      user_dbtype = { adecomm/ds_type.i
                        &direction = "etoi"
                        &from-type = "s_ttb_db.dbtyp"
                    }.
    end.   /* DICTDBG set */

/*----- 2. gues: try to use DICTDB, if NON-empty ---*/

  if   user_dbtype        = ""
   and LDBNAME("DICTDB") <> ?
   then do:  /* DICTDB set */
    find first s_ttb_db
      where s_ttb_db.ldbnm = LDBNAME("DICTDB")
      no-error.
    if available s_ttb_db
     and INTEGER(s_ttb_db.vrsn)  > 11
     and s_ttb_db.empty  = FALSE
     then assign
      drec_db     = s_ttb_db.dbrcd
      user_dbname = s_ttb_db.ldbnm
      user_dbtype = { adecomm/ds_type.i
                        &direction = "etoi"
                        &from-type = "s_ttb_db.dbtyp"
                    }.
    end.     /* DICTDB set */

/*----- 3. gues: try to use anything NON-empty---*/

  if   user_dbtype = ""
   then do:  /* take anything NON-empty */
    find first s_ttb_db
      where INTEGER(s_ttb_db.vrsn) > 11
      and s_ttb_db.empty  = FALSE
      and   LOOKUP(s_ttb_db.dbtyp,l_edbtyp) <> 0
      no-error.
    if available s_ttb_db
     then assign
      drec_db     = s_ttb_db.dbrcd
      user_dbname = s_ttb_db.ldbnm
      user_dbtype = { adecomm/ds_type.i
                        &direction = "etoi"
                        &from-type = "s_ttb_db.dbtyp"
                    }.
    end.     /* take anything NON-empty */

/*----- 4. gues: try to use DICTDB, even if empty ---*/
          
  if   user_dbtype        = ""
   and LDBNAME("DICTDB") <> ?
   then do:  /* DICTDB set */
    find first s_ttb_db
      where s_ttb_db.ldbnm = LDBNAME("DICTDB")
      no-error.
    if available s_ttb_db
     and INTEGER(s_ttb_db.vrsn) > 11
     then assign
      drec_db     = s_ttb_db.dbrcd
      user_dbname = s_ttb_db.ldbnm
      user_dbtype = { adecomm/ds_type.i
                        &direction = "etoi"
                        &from-type = "s_ttb_db.dbtyp"
                    }.
    end.     /* DICTDB set */

/*----- 5. gues: try to use ANYTHING ---*/
           
  if   user_dbtype = ""
   then do:  /* take anything */
    find first s_ttb_db
      where INTEGER(s_ttb_db.vrsn)  > 11
      and   LOOKUP(s_ttb_db.dbtyp,l_edbtyp) <> 0
      no-error.
    if available s_ttb_db
     then assign
      drec_db     = s_ttb_db.dbrcd
      user_dbname = s_ttb_db.ldbnm
      user_dbtype = { adecomm/ds_type.i
                        &direction = "etoi"
                        &from-type = "s_ttb_db.dbtyp"
                    }.
    end.     /* take anything */


/* reset aliases, cache_dirty and user_filename */
           
  if user_dbtype = ""
   then do:  /* We need to determine the database version here
                 in order to display this message correctly when
                 no current version database is connected */
     find first s_ttb_db where integer(s_ttb_db.vrsn) < 12 no-error.
      repeat:
        if available s_ttb_db then do:
          old_dbver = "R" + s_ttb_db.vrsn.
          message l_msg[2] l_msg[3] skip
                   l_msg[4] old_dbver skip
                   l_msg[5] old_dbver skip
                   l_msg[6]
                   view-as alert-box. 
          find next s_ttb_db where integer(s_ttb_db.vrsn) < 12 no-error.
        end.
        else
          return.
      end.
    end.
  else if LDBNAME("DICTDB")  <> user_dbname
   and    LDBNAME("DICTDBG") <> user_dbname
   then do:  /* ALIAS(es) changed */

    message l_msg[1] '"' + user_dbname + '"'. /* auto-switched */
    assign
      user_filename = ""
      cache_dirty   = TRUE.

    if user_dbtype <> "PROGRESS"
     then do:
      create alias DICTDB  for database value(SDBNAME(user_dbname)).
      if connected(user_dbname)
       then create alias DICTDBG for database value(user_dbname).
       else delete alias DICTDBG.
      end.
     else do:
      create alias DICTDB  for database value(user_dbname).
      delete alias DICTDBG.
      end.
    end.     /* ALIAS(es) changed */
    RUN "prodict/_dctsset.p" (IF user_dbtype = "PROGRESS" THEN ? ELSE user_dbname).
  end.     /* there is at least one db connected */


{ prodict/user/usercon.i user_filename }


