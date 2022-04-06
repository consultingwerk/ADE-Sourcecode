/***********************************************************************
* Copyright (C) 2006,2008 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*--------------------------------------------------------------------

File: prodict/ora/_ora_lkg.p   THIS ROUTINE GETS CALLED ONCE PER LINK!

Description:
    GETs all the object-info from all the previousely selected links 
    according to the preselection criteria also stored with the links
    
Input-Parameters:  
   none
                                     
Output-Parameters: 
    none
    
Used/Modified Shared Objects:
    DICTDBG     alias gets reset for all selected links
    
History:
    hutegger    94/10/18    creation
    mcmann      97/11/12    Added view-as dialog-box for non TTY clients
    mcmann      98/01/19    Added user_env[25] check for procedures to
                            know if an update is being done.
    mcmann      98/06/15    Added check for num-entries in oobjects
                            98-04-17-046    
    mcmann      01/01/23    Split for each so Oracle 8 can get the
                            proper records 20010108-001     
    mcmann      02/09/10    Added check for num-entries for Synonyms
                            20020820-004               
    04/19/06    fernando    Oracle 10g - skip BIN$* tables
    08/11/08    ashukla     LDAP support (CR#OE00172458)
    08/14/08    knavneet    OE00170417 - Quoting object names if it has special chars.
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

&GLOBAL-DEFINE DS_DEBUG XXDEBUG
&SCOPED-DEFINE DATASERVER YES
{ prodict/dictvar.i }
&UNDEFINE DATASERVER

{ prodict/user/uservar.i }
{ prodict/ora/ora_ctl.i 8 }

define variable hint            AS character no-undo initial "".

define variable l_i             AS integer   no-undo.
define variable l_list          AS character no-undo.
define variable l_name          AS character no-undo.
define variable l_owner         AS character no-undo.
define variable l_qual          AS character no-undo.
define variable l_syst-names    AS character no-undo.
define variable l_type          AS character no-undo.
define variable l_unspprtd      AS character no-undo.
DEFINE VARIABLE batch_mode      AS LOGICAL   no-undo.
define variable l_quoted-owner  AS character no-undo.

/* LANGUAGE DEPENDENCIES START */ /*--------------------------------*/

FORM 
                                                                   SKIP(1)
  "  Please wait while information is gathered from the ORACLE schema  "
                                                                   SKIP(1)
  SPACE(10) s_qual LABEL "(DB-Link  " FORMAT "x(32)" ")"           SKIP
  SPACE(10) hint   LABEL "(Searching" FORMAT "x(32)" ")"           SKIP(1)
 with row 6 centered
  side-labels no-attr-space
  frame gate_wait 
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN view-as dialog-box 
    three-d &ENDIF.

FORM 
                                                                   SKIP(1)
  "  Please wait while SYNONYMS are getting resolved  "            SKIP(1)
 with row 7 centered
  side-labels no-attr-space
  frame syno_wait view-as dialog-box three-d.

/* LANGUAGE DEPENDENCIES END */ /*----------------------------------*/


/*---------------------------  TRIGGERS  ---------------------------*/


/*------------------------  INT.-PROCEDURES  -----------------------*/
procedure clean-up-matches-params:

define input  parameter p_in    as character.
define output parameter p_out   as character.
define        variable i        as integer.

  assign
    p_out = p_in
    i     = index(p_out,"_").
  repeat while i <> 0:
    assign
      p_out = substring(p_out,1,i - 1,"character")
            + "."
            + substring(p_out,i + 1,-1,"character")
      i     = index(p_out,"_").
    end.

  assign i = index(p_out,"%").
  repeat while i <> 0:
    assign
      p_out = substring(p_out,1,i - 1,"character")
            + "*"
            + substring(p_out,i + 1,-1,"character")
      i     = index(p_out,"%").
    end.

  end.   /* procedure clean-up-matches-params */

/*---------------------------  MAIN-CODE  --------------------------*/

assign SESSION:IMMEDIATE-DISPLAY = yes.
batch_mode = SESSION:BATCH-MODE.
RUN adecomm/_setcurs.p ("WAIT").
assign
  l_unspprtd = "DBMS_ALERT,DBMS_APPLICATION_INFO,DBMS_DDL,"
             + "DBMS_EXPORT_EXTENSION,DBMS_JOB,DBMS_ISNAPSHOT,DBMS_LOCK,"
             + "DBMS_OUTPUT,DBMS_PIPE,DBMS_REFRESH,DBMS_SESSION,"
             + "DBMS_SNAPSHOT,DBMS_SPACE,DBMS_STANDARD,DBMS_SQL,"
             + "DBMS_SYS_SQL,DBMS_TRANSACTION,DBMS_UTILITY,DIANA,"
             + "DIUTIL,STANDARD".

{ prodict/dictgate.i 
  &action = "flist" 
  &dbtype = " ""ORACLE"" " 
  &dbrec  = "drec_db"
  &output = "l_syst-names"
  }
find first s_ttb_link
  where s_ttb_link.slctd  = TRUE
  and   s_ttb_link.level  = s_level
  and   s_ttb_link.master = s_master
  and   s_ttb_link.name   = s_lnkname
  no-error.

if available s_ttb_link
 then assign
  s_name  = s_ttb_link.presel-n
  s_owner = s_ttb_link.presel-o
  s_qual  = s_ttb_link.master + s_ttb_link.name
  s_type  = s_ttb_link.presel-t
  s_vrfy  = s_ttb_link.presel-v
  s_ttb_link.srchd = TRUE.
 else do:  /* should actually never happen */
  assign user_path = "*C,_ora_lkx". /* clean-up */
  leave.
  end.     /* should actually never happen */

 
/* pull in the objects of this link according to the preselection
 * criteria. Store all of them in gate-work temp-table. In the next
 * program the user will be able to select the ones he wants to get
 * pulled over
 */
IF NOT batch_mode THEN DO:
  if s_qual = "" then do:
    display "<Local DB>" @ s_qual with frame gate_wait.
    s_qual = ?.
  end.
  else display            s_qual with frame gate_wait.
END.

RUN clean-up-matches-params (INPUT s_name, OUTPUT l_name).
RUN clean-up-matches-params (INPUT s_owner,OUTPUT l_owner).
RUN clean-up-matches-params (INPUT s_type, OUTPUT l_type).
if index(l_owner,"/") <> 0
 then assign
  l_owner = substring(l_owner,1,index(l_owner,"/") - 1,"character").
if index(l_owner,"@") <> 0
 then assign
  l_owner = substring(l_owner,1,index(l_owner,"@") - 1,"character").

/* In case l_owner is null, we are using external authentication 
 * Get user name from database.
 */
IF (l_owner EQ "" OR l_owner EQ ?) THEN 
   RUN prodict/ora/_get_orauser.p (OUTPUT l_owner).
     
/* Skip remote packages, functions and procedures */
if s_qual <> ?
 then do:
  assign l_list = "". 
  repeat l_i = 1 to num-entries(tallowed):
    if lookup(entry(l_i,tallowed),"FUNCTION,PACKAGE,PROCEDURE") = 0
     then assign l_list = l_list + "," + entry(l_i,tallowed).
    end.
  assign tallowed = substring(l_list,2,-1,"character"). 
  end.

for each DICTDBG.oracle_users 
  fields (name user#)
  where DICTDBG.oracle_users.name MATCHES l_owner
  NO-LOCK  by DICTDBG.oracle_users.name: 
    FOR each DICTDBG.oracle_objects fields (owner# type name linkname obj#)
    where DICTDBG.oracle_objects.owner# = DICTDBG.oracle_users.user#
    NO-LOCK by DICTDBG.oracle_objects.name: 

    /* and phrase in the second each-phrase produces error-message */
    /* from ORACLE, so I sort out the records with linknames <> ?  */
    /* here                                                        */

      if DICTDBG.oracle_objects.linkname <> ? then next.

    /* we don't want to pull system-files, so we sort them out */
      if LOOKUP(DICTDBG.oracle_objects.name,l_syst-names ) <> 0 then next.
  
    /* There are a couple of system-tables other than above checked, that
     * we don't support. We filter them out with this statement:
     */
     
      if   DICTDBG.oracle_users.name = "SYS"
       and LOOKUP(DICTDBG.oracle_objects.name,l_unspprtd ) <> 0 then next.
   
   
   /* The list of oracle object can change without notice so this statement
      handles when more types then entries in oobjects so we don't receive
      an error message.  If it is a type that we will be supporting then
      ora_ctl.i needs to be changed so that this statement will eliminate it.
   */

      IF (DICTDBG.oracle_objects.type + 1) > NUM-ENTRIES(oobjects) THEN NEXT.
   
    /* since there are no esc-characters possible in Oracle V6, we
     * can't use the wildcards. As soon as we drop V6-support, we
     * can move this lines up into the where-clause              
     */
     
      if NOT (
       ( ENTRY(DICTDBG.oracle_objects.type + 1,oobjects) =    "view"
         and DICTDBG.oracle_objects.name  MATCHES "buffer." + l_name
         and "buffer" MATCHES l_type
       )  /* "buffer_" produces error, so I use "buffer." (hutegger) */
       or 
       ( ENTRY(DICTDBG.oracle_objects.type + 1,oobjects)     MATCHES l_type
         and     DICTDBG.oracle_objects.name                   MATCHES l_name
         and  CAN-DO(tallowed,ENTRY(DICTDBG.oracle_objects.type + 1,oobjects))
       )
      ) then NEXT.

    /* Skip sequence generators created for compatible oracle tables */
      if DICTDBG.oracle_objects.name MATCHES "*_SEQ" then NEXT.

      /* in Oracle 10g, there is a feature called flashback table which 
         saves deleted tables, by renaming them to BIN$<some-string>.
         We can skip these too.
      */
      IF DICTDBG.oracle_objects.NAME BEGINS "BIN$" THEN
         NEXT.

    /* we try to find the object in the existing schema, because we need 
     * to make sure, that when it get's created later-on, it will get a 
     * unique name. Therefore we try to find teh object with the name,
     * foreign-name, qualifier (= db-link) and user. If we don't find that
     * object we assign a ? to gate-work.gate-prog (which is the 
     * PROGRESS-name); and in ora_lks we go through all the gate-work 
     * records that the user selected and that have a ? instead a 
     * progress-name, and find a new name for the object
     */
      l_quoted-owner = QUOTER(DICTDBG.oracle_users.name).

      if ENTRY(DICTDBG.oracle_objects.type + 1, oobjects) = "SYNONYM" then do:  /* synonym */
        find first DICTDB._Sequence
          where DICTDB._Sequence._Db-recid    = drec_db
            and (DICTDB._Sequence._Seq-misc[1] = DICTDBG.oracle_objects.name
                 /* OE00170417 - string may be quoted */
                 OR DICTDB._Sequence._Seq-misc[1] = QUOTER(DICTDBG.oracle_objects.NAME))
            and   DICTDB._Sequence._Seq-misc[2] = ""
            and   DICTDB._Sequence._Seq-misc[8] = s_qual
            no-error.
        if not available DICTDB._Sequence
         then find first DICTDB._File
            where DICTDB._File._Db-recid     = drec_db
              and   (DICTDB._File._For-Name     = DICTDBG.oracle_objects.name
                    /* OE00170417 - string may be quoted */
                     OR DICTDB._File._For-Name = QUOTER(DICTDBG.oracle_objects.NAME))
              and   DICTDB._File._For-Owner    = ""
              and   DICTDB._File._Fil-misc2[8] = s_qual
              no-error.
      end.     /* synonym */
     
      else if ENTRY(DICTDBG.oracle_objects.type + 1, oobjects) = "SEQUENCE" then do:  /* sequence */
        find first DICTDB._Sequence where DICTDB._Sequence._Db-recid    = drec_db
          and  (DICTDB._Sequence._Seq-misc[1] = DICTDBG.oracle_objects.name
                 /* OE00170417 - string may be quoted */
                 OR DICTDB._Sequence._Seq-misc[1] = QUOTER(DICTDBG.oracle_objects.NAME))
          and  (DICTDB._Sequence._Seq-misc[2] = DICTDBG.oracle_users.name
                 OR DICTDB._Sequence._Seq-misc[2] = l_quoted-owner)
          and   DICTDB._Sequence._Seq-misc[8] = s_qual
          no-error.
      end.     /* sequence */
     
      else do:  /* table */
        if ENTRY(DICTDBG.oracle_objects.type + 1, oobjects) = "PACKAGE"
         then find first DICTDB._File
           where DICTDB._File._Db-recid     = drec_db
             and (DICTDB._File._For-Owner    = DICTDBG.oracle_users.name
                  OR DICTDB._File._For-Owner = l_quoted-owner)
             and (DICTDB._File._Fil-misc2[1] = DICTDBG.oracle_objects.name
                 /* OE00170417 - string may be quoted */
                 OR DICTDB._File._Fil-misc2[1] = QUOTER(DICTDBG.oracle_objects.NAME))
             and DICTDB._File._Fil-misc2[8] = s_qual
             no-error.
         else find first DICTDB._File
            where DICTDB._File._Db-recid     = drec_db
              and (DICTDB._File._For-Name     = DICTDBG.oracle_objects.name
                 /* OE00170417 - string may be quoted */
                 OR DICTDB._File._For-Name = QUOTER(DICTDBG.oracle_objects.NAME))
              and (DICTDB._File._For-Owner    = DICTDBG.oracle_users.name
                   OR DICTDB._File._For-Owner = l_quoted-owner)
              and DICTDB._File._Fil-misc2[8] = s_qual
              no-error.

    /* to prevent schemaholder-tables from beeing updated        */
    /*                                          <hutegger> 94/06 */
         if available DICTDB._File
          and DICTDB._file._file-name begins "oracle_" then NEXT.

      end.     /* table */

      if not available _File and not available _Sequence
          and s_vrfy = TRUE then NEXT.

      IF NOT batch_mode THEN   
          display DICTDBG.oracle_objects.name @ hint with frame gate_wait.

      create gate-work.
      ASSIGN gate-work.gate-user = DICTDBG.oracle_users.name
             gate-work.gate-prog = ( if available DICTDB._File
                                    and DICTDB._File._Fil-misc2[1] <> ?
                                    /* OE00130417 - and not 0-length value */
                                    AND DICTDB._File._Fil-misc2[1] <> ""
                                    and user_env[25] <> "compare"
                                    then ?
                                    else if available DICTDB._File
                                    then DICTDB._File._File-name 
                                    else if available DICTDB._Sequence
                                    then DICTDB._Sequence._Seq-name 
                                    else ? )
             gate-work.gate-qual = s_qual
             gate-work.gate-type = TRIM(STRING((AVAILABLE DICTDB._File 
                                    AND DICTDB._File._Frozen),"FROZEN:/" ) )
             gate-work.gate-obj# = DICTDBG.oracle_objects.obj#.

      if DICTDBG.oracle_objects.type   =    4
            and DICTDBG.oracle_objects.name BEGINS "BUFFER_" then 
        ASSIGN gate-work.gate-name = SUBSTR(DICTDBG.oracle_objects.name, 8, -1 ,"character")
               gate-work.gate-type = gate-work.gate-type + ENTRY(19,oobjects).
      else 
        ASSIGN gate-work.gate-name = DICTDBG.oracle_objects.name
               gate-work.gate-type = gate-work.gate-type
                                    + ENTRY(DICTDBG.oracle_objects.type + 1
                                    ,oobjects).
    END. /* for each DICTDBG.oracle_objects */
  END. /* for each DICTDBG.oracle_users */

IF NOT batch_mode THEN DO:
  pause 0.
  hide frame gate_wait no-pause.
  view frame syno_wait.
END.

find first gate-work no-error.

/**/  &IF "{&DS_DEBUG}" = "DEBUG"
/**/   &THEN
/**/    output to gate-work.d.
/**/    display s_qual format "x(50)" with side-label frame d1a.
/**/    for each gate-work:
/**/        display
/**/          gate-slct gate-flag
/**/          gate-name format "x(20)"
/**/          gate-edit format "x(30)"
/**/          gate-prog format "x(20)"
/**/          gate-qual format "x(20)"
/**/          gate-obj# format ">>>>>>>>>9"
/**/          gate-type gate-user with down stream-io width 100 frame d1.
/**/      end.  /* for each gate-work */
/**/    output close.
/**/    message "D1 DEBUG-Output done" s_qual view-as alert-box.
/**/   &ENDIF

for each gate-work
  where gate-work.gate-type = "SYNONYM"
  and   gate-work.gate-edit = ""
  and   gate-work.gate-qual = s_qual:

  find first DICTDBG.oracle_synonyms 
    where DICTDBG.oracle_synonyms.obj# = gate-work.gate-obj#
    no-lock no-error.

  /* The synonym needs to be a local one, except if it is in the local
   * db. And there are a couple of system-tables, that we don't support.
   * We filter them out with this statement.
   */
  if available DICTDBG.oracle_synonyms
  and ( DICTDBG.oracle_synonyms.node = ?
     or s_qual  =  ?
      )
  and (  DICTDBG.oracle_synonyms.owner <> "SYS"
     or LOOKUP(DICTDBG.oracle_synonyms.name,l_unspprtd ) = 0
      )

   then do:  /* try to resolve this synonym */

    /* synonyms pointing at remote objects can't be resolved completely */
    if DICTDBG.oracle_synonyms.node = ?
     then do:  /* pointing local -> resolve */
      find first DICTDBG.oracle_users 
        where DICTDBG.oracle_users.name = DICTDBG.oracle_synonyms.owner
        no-lock no-error.
      if available DICTDBG.oracle_users
       then find first DICTDBG.oracle_objects 
        where DICTDBG.oracle_objects.name = DICTDBG.oracle_synonyms.name
        and   DICTDBG.oracle_users.user#  = DICTDBG.oracle_objects.owner#
        no-lock no-error.
       else release DICTDBG.oracle_objects.
      end.     /* pointing local -> resolve */
     else release DICTDBG.oracle_objects.
    
    IF AVAILABLE DICTDBG.oracle_objects THEN DO:
      IF (DICTDBG.oracle_objects.type + 1) <= NUM-ENTRIES(oobjects) THEN
        ASSIGN l_type = ENTRY(DICTDBG.oracle_objects.type + 1,oobjects).
      ELSE
        ASSIGN l_type = "".
    END. 
    ELSE
     ASSIGN l_type =  "".
         
     IF ( s_qual <> ? or DICTDBG.oracle_synonyms.node <> ? )
     and  LOOKUP(l_type,"PACKAGE,PROCEDURE,FUNCTION") <> 0
     then next. /* disallow remote procedures, functions and packages */

    if   LOOKUP(l_type,tallowed + ",") <> 0
     and l_type                        <> "SYNONYM"
     then assign
       gate-work.gate-edit = DICTDBG.oracle_synonyms.owner
                           + ":"
                           + DICTDBG.oracle_synonyms.name
                           + ":"
                           + l_type
                           + ( if DICTDBG.oracle_synonyms.node <> ?
                                then ":@" + DICTDBG.oracle_synonyms.node
                                else ""
                             ).

    end.     /* try to resolve this synonym */

  end.     /* for each gate-work "synonym" */
  
/**/  &IF "{&DS_DEBUG}" = "DEBUG"
/**/   &THEN
/**/    output to gate-work.d2.
/**/    display s_qual format "x(50)"  with side-label frame d2a.
/**/    for each gate-work:
/**/        display
/**/          gate-slct gate-flag
/**/          gate-name format "x(20)"
/**/          gate-edit format "x(30)"
/**/          gate-prog format "x(20)"
/**/          gate-qual format "x(20)"
/**/          gate-obj# format ">>>>>>>>>9"
/**/          gate-type gate-user with down stream-io width 100 frame d2.
/**/      end.  /* for each gate-work */
/**/    output close.
/**/    message "D2 DEBUG-Output done" view-as alert-box.
/**/   &ENDIF

if s_qual <> ?
 then for each gate-work
  where gate-work.gate-type                   = "SYNONYM"
  and   num-entries(gate-work.gate-edit,":") >= 4:

  if not ( entry(3,gate-work.gate-edit,":")      = ""
     and   entry(4,gate-work.gate-edit,":")      = s_qual
         )
     then next.
 
  find first DICTDBG.oracle_users 
    where DICTDBG.oracle_users.name = entry(1,gate-work.gate-edit,":")
    no-lock no-error.
  release DICTDBG.oracle_objects.
  if available DICTDBG.oracle_users
   then find first DICTDBG.oracle_objects 
    where DICTDBG.oracle_objects.name = entry(2,gate-work.gate-edit,":")
    and   DICTDBG.oracle_users.user#  = DICTDBG.oracle_objects.owner#
    no-lock no-error.

  assign
    l_type = ( if available DICTDBG.oracle_objects
                then ENTRY(DICTDBG.oracle_objects.type + 1,oobjects)
                else ""
             ).

  if   LOOKUP(l_type,tallowed + ",") <> 0
   and l_type                        <> "SYNONYM"
   then assign
     gate-work.gate-edit = entry(1,gate-work.gate-edit,":")
                         + ":"
                         + entry(2,gate-work.gate-edit,":")
                         + ":"
                         + l_type
                         + ":"
                         + s_qual.

  end.     /* for each gate-work "synonym" */

/**/  &IF "{&DS_DEBUG}" = "DEBUG"
/**/   &THEN
/**/    output to gate-work.d3.
/**/    display s_qual format "x(50)"  with side-label frame d3a.
/**/    for each gate-work:
/**/        display
/**/          gate-slct gate-flag
/**/          gate-name format "x(20)"
/**/          gate-edit format "x(30)"
/**/          gate-prog format "x(20)"
/**/          gate-qual format "x(20)"
/**/          gate-obj# format ">>>>>>>>>9"
/**/          gate-type gate-user with down stream-io width 100 frame d3.
/**/      end.  /* for each gate-work */
/**/    output close.
/**/    message "D3 DEBUG-Output done" view-as alert-box.
/**/   &ENDIF

/* we are done with this link, lets do the next one (srchd = false)
 * if there aren't anymore, we continue to the next step, wich is allowing
 * the user to select the objects to be pulled
 */

find first s_ttb_link
  where s_ttb_link.slctd  = TRUE
  and   s_ttb_link.srchd  = FALSE
  no-lock no-error.
if not available s_ttb_link
 then do:  /* done with getting object-names -> objects-selection */

/**/  &IF "{&DS_DEBUG}" = "DEBUG"
/**/   &THEN
/**/    output to gate-work.d4.
/**/    display s_qual format "x(50)"  with side-label frame d4a.
/**/    for each gate-work:
/**/        display
/**/          gate-slct gate-flag
/**/          gate-name format "x(20)"
/**/          gate-edit format "x(30)"
/**/          gate-prog format "x(20)"
/**/          gate-qual format "x(20)"
/**/          gate-obj# format ">>>>>>>>>9"
/**/          gate-type gate-user with down stream-io width 100 frame d4.
/**/      end.  /* for each gate-work */
/**/    output close.
/**/    message "D4 DEBUG-Output done" view-as alert-box.
/**/   &ENDIF

  for each gate-work
    where gate-work.gate-type = "SYNONYM":
    
    if gate-work.gate-edit = ""
     or num-entries(gate-work.gate-edit,":") < 3
     or     entry(3,gate-work.gate-edit,":") = ""
     then do:  /* these synonyms couldn't get resolved - wrong link */
     
     IF NOT batch_mode THEN
/** /    message "unresolved synonym:"                    /**/
/**/       gate-work.gate-name gate-work.gate-type       /**/
/**/       gate-work.gate-user                           /**/
/**/       gate-work.gate-edit                           /**/
/**/       num-entries(gate-work.gate-edit,":")          /**/
/**/       entry(3,gate-work.gate-edit,":") = ""         /**/
/**/       view-as alert-box.                            / **/
      delete gate-work.
      end.     /* these synonyms couldn't get resolved - wrong link */
    end.     /* for each gate-work */

/**/  &IF "{&DS_DEBUG}" = "DEBUG"
/**/   &THEN
/**/    output to gate-work.d5.
/**/    display s_qual format "x(50)"  with side-label frame d5a.
/**/    for each gate-work:
/**/        display
/**/          gate-slct gate-flag
/**/          gate-name format "x(20)"
/**/          gate-edit format "x(30)"
/**/          gate-prog format "x(20)"
/**/          gate-qual format "x(20)"
/**/          gate-obj# format ">>>>>>>>>9"
/**/          gate-type gate-user with down stream-io width 100 frame d5.
/**/      end.  /* for each gate-work */
/**/    output close.
/**/    message "LAST DEBUG-Output done" view-as alert-box.
/**/   &ENDIF
  /* relict from previous version now redundant * /
  for each s_ttb_link
    where s_ttb_link.slctd  = TRUE:
    assign s_ttb_link.srchd  = FALSE. /* init for next step: */
    end.                              /*      select objects */
  */
  
  assign
    user_path = "_ora_lks".             /* objects-selection */

  end.     /* done with getting object-names -> objects-selection */

 else do:  /* look for objects in next selected link */

  assign
    s_level   = s_ttb_link.level
    s_master  = s_ttb_link.master
    s_lnkname = s_ttb_link.name.

  if s_level > 0
   then do:  /* only if s_ttb_link is for linked db */

    if connected(s_ldbname)
     then disconnect value(s_ldbname) /*no-error*/.

    do transaction:
      find first DICTDB._Db
        where DICTDB._Db._Db-name = s_ldbname
        and   DICTDB._Db._Db-type = "ORACLE".
      assign DICTDB._Db._Db-misc2[8] = s_master + s_ttb_link.name.
      end.     /* transaction */

    end.     /* only if s_ttb_link is for linked db */

  assign  user_path = "*C,_ora_lkc,_ora_lkg".

  end.     /* look for objects in next selected link */

IF NOT batch_mode THEN
  hide frame syno_wait no-pause.


/**/  &IF "{&DS_DEBUG}" = "DEBUG"
/**/   &THEN
/**/    output to s_ttb_link.lst append.
/**/    for each s_ttb_link:
/**/      display
/**/        slctd srchd master s_ttb_link.name level
/**/        with side-labels frame a.
/**/      for each gate-work
/**/        where gate-work.gate-qual = ( if s_ttb_link.master + s_ttb_link.name = ""
/**/                            then ?
/**/                            else s_ttb_link.master + s_ttb_link.name
/**/                                    ):
/**/        display
/**/          gate-slct gate-flag
/**/          gate-name format "x(20)"
/**/          gate-edit format "x(30)"
/**/          gate-prog format "x(20)"
/**/          gate-qual format "x(20)"
/**/          gate-type gate-user with down width 100 frame b.
/**/        end.  /* for each gate-work */
/**/      end.  /* for each s_ttb_link */
/**/    output close.
/**/   &ENDIF

/*------------------------------------------------------------------*/
