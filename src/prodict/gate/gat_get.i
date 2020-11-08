/*********************************************************************
* Copyright (C) 2020 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/gat_get.i

Description:
    
    last part of the get-routines:
    - message if no object met preselection criteria
    - auto-select or call guigget or ttygget
    - if not canceled: generate unique names for selected objects
      if     canceled: delete gate-works and set user_path = ""
        
Text-Parameters:
    &block     label of block to leave if canceled or no obj found  
    &clean-up  clean-up routines for user_path  
    &end       "end." if repeat for get-process started in _xxx_get.p
               "" otherwise
    &gate-flag value or expression for gate-flag   
    &special1  some DS-specific action to be done BEFORE calling 
               of _guigget.p  
    &special2  some DS-specific action to be done AFTER calling 
               of _guigget.p  
    &as400-flag yes if ODBC for AS/400
    &where     where-phrase to exclude system-objects from auto-select  


Included in:
    syb/syb_getp.i
    odb/_odb_get.p
    ora/_ora_lks.p

History:
    mcmann      98/07/13 Added _Owner to _File finds
    hutegger    95/08   included {&end} parameter
    hutegger    95/04   creation
    sdash    05/04/14   Support for native sequence generator for MSS.
    vmaganti 24/08/2020 Removed unnecessary for each block as part of jira # OCTA-22220 and OCTA-16650
--------------------------------------------------------------------*/        
/*h-*/

/*----------------------------------------------------------------------*/

&GLOBAL-DEFINE xxDS_DEBUG DEBUG

{prodict/gate/nogatwrk.i
  &block    = "{&block} "
  &end      = "{&end} "
  &clean-up = {&clean-up}
  } /* message and leave */


/* The compare algorithm needs an extra gate-work record to allow to
 * check all progress-objects, if there is a corresponding object on
 * the <DS>-side.
 * Update and create don't need this record
 */
if  user_env[25] begins "AUTO-COMPARE"
 or user_env[25] begins "COMPARE"
 then do:
  create gate-work.
  assign
    gate-work.gate-name = " ***                 Check in"
    gate-work.gate-user = edbtyp + " for "
    gate-work.gate-type = "PROGRESS"
    gate-work.gate-qual = " orphans           *** " /*string used again!*/
    gate-work.gate-prog = "Pseudo-Entry".
  end.

  
/* the following statment is a workaround to the problem that the last
 * temp-table -entry gets lost
 */
find FIRST gate-work no-error.

if user_env[25] begins "AUTO"
 then do:   /*========= automatically select all possible tables =======*/
  for each gate-work    /*===== but exclude system-tables =====*/
    where {&where}:
    assign gate-flag = {&gate-flag}.
    end.

    /* below for each block removed as part of jira OCTA-16650 
     * and OCTA-22220 which giving error while validating 
     * query expression */

    /*for each s_ttb_seq    /*===== but exclude system-tables =====*/
    where {&where}:
    assign gate-flag = {&gate-flag}.
    end.*/

  end.      /*========= automatically select all possible tables =======*/

 else do:   /*=========== let user select the tables he wants ==========*/
  
  {&special1}  /* oracle: gate-qual = ? -> "<Local DB>" */
   
  /* input to _xxxgget.p: gate-slct = TRUE, gate-flag = FALSE */    

  RUN prodict/gui/_guigget.p
    ( INPUT edbtyp,
      INPUT "Pull",
      &IF DEFINED(as400-flag) &THEN {&as400-flag} &ELSE NO &ENDIF
    ).

  assign canned = (if RETURN-VALUE = "cancel" then yes else no).

  /* output from _xxxgget.p: gate-slct = TRUE, gate-flag = <selected> */    

  {&special2}  /* oracle: gate-qual = ? -> "<Local DB>" */
   
  end.     /*=========== let user select the tables he wants ==========*/

/*----------------------------------------------------------------------*/
/*                 check names and ev. prepare next link                */
/*----------------------------------------------------------------------*/

if NOT canned
 then do TRANSACTION:

  SESSION:IMMEDIATE-DISPLAY = YES.
  RUN adecomm/_setcurs.p ("WAIT").

  for each gate-work:
    assign gate-work.gate-slct = gate-work.gate-flag.
    end.
  
  /* Explanation for the following "strange"-appearing  code-duplication:
   * With Oracle's distributed Databases, the local-db has ? in 
   * gate-work.gate-link, which gets sorted higher than any other value.
   * The result was, that if there were tables with the same name in 
   * the local-db and a linked-db, the one in the linked got the same
   * name on the progress-side as on the foreign side, and the one in
   * the local-db got a "-1" appended. Since this is rather unexpected
   * (local-db stuff gets pulled first), we need to run through the
   * gate-work's of the local db first and then through the others.
   */

  /* 1.a Step: find unique names for all _Sequence gate-work's
   * (... of local-db if oracle ...)
   */
  { prodict/gate/gat_getd.i
      &gate-type = "SEQUENCE"
      &local     = "true"
      &sequence  = "true"
      }

  /* 1.b Step: find unique names for all _Sequence Synonym gate-work's
   * (... of remote-db if oracle ...)
   */
  { prodict/gate/gat_getd.i
      &gate-type = "SYNONYM"
      &local     = "true"
      &sequence  = "true"
      }

  /* 2.a Step: find unique names for all _Sequence gate-work's
   * (... of remote-db if oracle ...)
   */
  { prodict/gate/gat_getd.i
      &gate-type = "SEQUENCE"
      &local     = "false"
      &sequence  = "true"
      }

  /* 2.b Step: find unique names for all _Sequence Synonym gate-work's
   * (... of local-db if oracle ...)
   */
  { prodict/gate/gat_getd.i
      &gate-type = "SYNONYM"
      &local     = "false"
      &sequence  = "true"
      }

  /* delete temporary sequences, in case the user doesn't select it, 
   * it's not left-over...
   * /
/**/ message "before delete" view-as alert-box.
  for each DICTDB._Sequence 
    where DICTDB._Sequence._Db-recid    = drec_db 
    and   DICTDB._Sequence._Seq-misc[2] = "%TEMPORARY%":
    delete DICTDB._Sequence.
    end.
/**/ message "after delete" view-as alert-box.
/ **/



  /* 3.a Step: find unique names for all _File gate-work's
   * (... of local-db if oracle ...)
   */
  { prodict/gate/gat_getd.i
      &gate-type = "x"
      &local     = "true"
      &sequence  = "false"
      }

  /* 3.b Step: find unique names for all _File Synonym gate-work's
   * (... of remote-db if oracle ...)
   */
  { prodict/gate/gat_getd.i
      &gate-type = "SYNONYM"
      &local     = "true"
      &sequence  = "false"
      }

  /* 4.a Step: find unique names for all _File gate-work's
   * (... of remote-db if oracle ...)
   */
  { prodict/gate/gat_getd.i
      &gate-type = "x"
      &local     = "false"
      &sequence  = "false"
      }

  /* 4.b Step: find unique names for all _File Synonym gate-work's
   * (... of local-db if oracle ...)
   */
  { prodict/gate/gat_getd.i
      &gate-type = "SYNONYM"
      &local     = "false"
      &sequence  = "false"
      }

  /* delete temporary files, in case the user doesn't select it, it's not
   * left-over...
   */
  for each DICTDB._File 
    where DICTDB._File._Db-recid = drec_db 
    and (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
    and   DICTDB._File._For-type = "TEMPORARY":
    delete DICTDB._File.
    end.



  if edbtyp = "ORACLE"
   then do:

/**/  &IF "{&DS_DEBUG}" = "DEBUG"
/**/   &THEN
/**/    output to s_ttb_link.d.
/**/    for each s_ttb_link:
/**/      display
/**/        slctd srchd level
/**/        "*" + master + "*" + s_ttb_link.name + "*" format "x(20)"
/**/        with side-labels frame a.
/**/      for each gate-work
/**/        where gate-work.gate-qual = ( if s_ttb_link.master + s_ttb_link.name = ""
/**/                            then ?
/**/                            else s_ttb_link.master + s_ttb_link.name
/**/                                    ):
/**/        display
/**/          gate-slct label "slct"
/**/          gate-flag label "flg"
/**/          gate-name format "x(20)"
/**/          gate-prog format "x(20)"
/**/          gate-qual format "x(20)"
/**/          gate-type format "x(9)"
/**/          gate-user format "x(9)"
/**/          with down frame b width 100.
/**/        end.  /* for each gate-work */
/**/      end.  /* for each s_ttb_link */
/**/    output close.
/**/   &ENDIF

    /* if for a link there is no object's definition to be pulled, we
     * delete the link (saves time - one less re-connect and recursion)
     */
    for each s_ttb_link:

/* we can't do that this way, because the distributed dbs need to be 
 * checked when orphans is selected. Also we have no clue to which 
 * db the synonyms are pointing...
 * 
 *    if s_ttb_link.master + s_ttb_link.name = ""
 *     then find first gate-work
 *      where gate-work.gate-slct = TRUE
 *      and ( gate-work.gate-qual = ?
 *      or    gate-work.gate-qual = " orphans           *** "
 *          )
 *      no-lock no-error.
 *     else find first gate-work
 *      where gate-work.gate-slct = TRUE
 *      and   gate-work.gate-qual = s_ttb_link.master + s_ttb_link.name
 *      no-lock no-error.
 *    if not available gate-work
 *     then assign
 *      s_ttb_link.slctd = FALSE
 *      s_ttb_link.srchd = FALSE.
 *     else assign
 *      s_ttb_link.slctd = TRUE
 *      s_ttb_link.srchd = FALSE.
 */
      assign 
        s_ttb_link.srchd = FALSE.
      end.

    
/**/  &IF "{&DS_DEBUG}" = "DEBUG"
/**/   &THEN
/**/    output to s_ttb_link.d2.
/**/    for each s_ttb_link:
/**/      display
/**/        slctd srchd level
/**/        "*" + master + "*" + s_ttb_link.name + "*" format "x(20)"
/**/        with side-labels frame a2.
/**/      for each gate-work
/**/        where gate-work.gate-qual = ( if s_ttb_link.master + s_ttb_link.name = ""
/**/                            then ?
/**/                            else s_ttb_link.master + s_ttb_link.name
/**/                                    ):
/**/        display
/**/          gate-slct label "slct"
/**/          gate-flag label "flg"
/**/          gate-name format "x(20)"
/**/          gate-prog format "x(20)"
/**/          gate-qual format "x(20)"
/**/          gate-type format "x(9)"
/**/          gate-user format "x(9)"
/**/          with down frame b2 width 100.
/**/        end.  /* for each gate-work */
/**/      end.  /* for each s_ttb_link */
/**/    output close.
/**/   &ENDIF

    find first s_ttb_link
      where s_ttb_link.slctd  = TRUE
      and   s_ttb_link.srchd  = FALSE
      no-lock no-error.
    if available s_ttb_link
     then do:
      assign
        user_path = "*C,_ora_lkc,_ora_pul"  /* pull objects */
        s_level   = s_ttb_link.level
        s_master  = s_ttb_link.master
        s_lnkname = s_ttb_link.name.
      if  s_ldbname = "tmp00000"
       and connected(s_ldbname)
       then disconnect value(s_ldbname) /*no-error*/.
      find first DICTDB._Db
        where DICTDB._Db._Db-name = s_ldbname
        and   DICTDB._Db._Db-type = "ORACLE"
        no-error.
      if available DICTDB._Db
       then assign DICTDB._Db._Db-misc2[8] = s_master + s_lnkname.
      end.

     else assign
        user_path = "*C,_ora_lkx". /* clean up */
      
    end.

  end.     /* TRANSACTION */

 else do:  /* user canceled out */

  if edbtyp = "ORACLE"
   then assign user_path = "*C,_ora_lkx". /* clean-up */

   else do:  /* SYBASE and ODBC */
   
    for each gate-work:
      delete gate-work.
      end.
    assign
      user_path = "".
    RUN adecomm/_setcurs.p ("").
   
    end.     /* SYBASE and ODBC */
    
  end.  /* user canceled out */

/*------------------------------------------------------------------*/


