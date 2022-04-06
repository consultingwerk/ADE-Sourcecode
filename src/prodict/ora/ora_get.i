/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* ora_get.i -

This gets from the user a table-name, table-type and table-owner into
user_env[1..3], respectively.  user_env[4] is the Progress file-name
for that Oracle table, or a good guess if there is no corresponding
progress file.  If more than one file is selected, then user_env[1..4]
becomes a set of comma-separated items, containing lists of their
respective names and types.

OUTPUT:
    user_env[1..4] == "" if end-error hit.

INPUT:
    user_env[25]    "{AUTO},<owner>,<type>,<name>,<qualifier>"
                        for autmatically select all or bringing up the 
                            selection-dialog-box, Initial-values for
                            pre-selection-criterias                           
                    

Text Parameters:
    <none>
    
Included in:
    prodict/ora/_ora6get.p
    prodict/ora/_ora7get.p
    
    
History:
    94/08/03    hutegger    extracted to include-file and inserted 
                            preselection-criteria - support
    94/06/03    hutegger    added user_env[25] as "AUTO"-switch
    04/19/06    fernando    Oracle 10g - skip BIN$* tables
*/

&SCOPED-DEFINE DATASERVER YES
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/ora/ora_ctl.i 8 }
&UNDEFINE DATASERVER


DEFINE VARIABLE c               AS CHARACTER NO-UNDO.
DEFINE VARIABLE edbtyp          AS CHARACTER NO-UNDO INITIAL "ORACLE".
DEFINE VARIABLE hint            AS CHARACTER NO-UNDO INITIAL "".
DEFINE VARIABLE i               AS INTEGER   NO-UNDO.
DEFINE VARIABLE inc_qual        AS LOGICAL   NO-UNDO INITIAL FALSE.
DEFINE VARIABLE j               AS INTEGER   NO-UNDO.
DEFINE VARIABLE l               AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lim             AS INTEGER   NO-UNDO INITIAL 0.
define variable l_rep-presel    as logical   no-undo initial TRUE.
DEFINE VARIABLE xld             AS INTEGER   NO-UNDO INITIAL 0.
DEFINE VARIABLE rpos1           AS CHARACTER NO-UNDO.
DEFINE VARIABLE rpos2           AS CHARACTER NO-UNDO.
DEFINE VARIABLE rpos3           AS CHARACTER NO-UNDO.
DEFINE VARIABLE redraw          AS LOGICAL   NO-UNDO INITIAL TRUE.
DEFINE VARIABLE canned          AS LOGICAL   NO-UNDO.

&IF "{&WINDOW-SYSTEM}" = "TTY"
 &THEN
  DEFINE VARIABLE lab-qual AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pat-name AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pat-qual AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pat-user AS CHARACTER NO-UNDO.
 &ENDIF

/*
{prodict/gate/gatework.i 
  &new        = "NEW"
  &selvartype = "VARIABLE l"
  &options    = "INITIAL ""*"" "
  } /* Defines WORKFILE: gate-work */
*/

DEFINE BUFFER gate-buff FOR gate-work.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 6 NO-UNDO INITIAL [
  /* 1*/ "You have not selected an ORACLE database.",
  /*Select tables with [RETURN].  Press [F1] to begin work, or [F4] to abort.*/
  /* 2*/ "Press",             /* [F1] */
  /* 3*/ "to begin work, or", /* [F4] */
  /* 4*/ "to abort",          /*.*/
  /*Use [F5] to select a group, or [F6] to unselect a group.*/
  /* 5*/ "to select a group, or", /* [F6] */
  /* 6*/ "to unselect a group"    /*.*/
].


FORM 
  SKIP(1)
  "  Please wait while information is gathered from the ORACLE schema  "
  SKIP(1)
  SPACE(10) hint LABEL "(Searching" FORMAT "x(32)" ")" 
  SKIP(1)
  WITH FRAME gate_wait ROW 6 CENTERED SIDE-LABELS NO-ATTR-SPACE.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
FORM
  "Below is a list of objects from the Oracle database.  Select tables"  SKIP
  "with" /*[RETURN].  Press [F1] to begin work, or [F4] to abort.*/
    hint FORMAT "x(63)"                                                  SKIP
  "Use"  /*[F5] to select a group, or [F6] to unselect a group.*/
    c    FORMAT "x(64)"
  "Each table you choose will be checked against its PROGRESS image."    SKIP
  "If the PROGRESS image of the Oracle table definition is new, missing" SKIP
  "or invalid, this program will automatically update it."               SKIP
  WITH FRAME gate_not OVERLAY WIDTH 80 ROW 3 COLUMN 1 NO-LABELS NO-ATTR-SPACE.

/* in gate/ttygget.i the forms gate_match and gate_tbl contain code  */
/* that accesses the qualifier-fields. Therefore we have to          */
/* include them here in the form-definitions, but without label and  */
/* as small as possible (format "x")                                 */
FORM SKIP(1)
  "Enter MATCHES pattern (use * and . for wildcard pattern)"          SKIP
  "For table names to" l FORMAT "mark/unmark" NO-LABEL NO-ATTR-SPACE  SKIP(1)
    pat-name             FORMAT "x(30)"          LABEL "Object Name"  SKIP
    pat-user             FORMAT "x(30)"          LABEL "Owner Name " 
    lab-qual             FORMAT "x"           NO-LABEL  
    pat-qual             FORMAT "x"           NO-LABEL                SKIP(1)
 WITH FRAME gate_match
  OVERLAY ROW 8 CENTERED SIDE-LABELS ATTR-SPACE.

FORM
  gate-flag FORMAT "*/" NO-LABEL
  gate-name FORMAT "x(30)" LABEL "Object Name"
  gate-user FORMAT "x(26)" LABEL "Object Owner"
  gate-type FORMAT "x(10)" LABEL "Object Type"                 
  gate-qual FORMAT "x"  NO-LABEL                   
 WITH FRAME gate_tbl
  OVERLAY ROW 10 COLUMN 1 ATTR-SPACE
  WIDTH 80 MINIMUM(lim,SCREEN-LINES - 14) DOWN SCROLL 1.

&ENDIF

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

IF user_dbtype <> "ORACLE" THEN DO:
  MESSAGE new_lang[1] /* not oracle */
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.


/*----------------------------------------------------------------------*/
/*                          pull in schema-info                         */
/*----------------------------------------------------------------------*/

assign
  l_rep-presel = TRUE.
  
presel:
repeat while l_rep-presel:   /* end for this repeat is in nogatwrk.i */

{prodict/gate/presel.i
  &frame  = "frm_nto"
  &link   = """ """
  &master = """ """
  }

PAUSE 0.
VIEW FRAME gate_wait.

SESSION:IMMEDIATE-DISPLAY = yes.
RUN adecomm/_setcurs.p ("WAIT").

FOR EACH DICTDBG.oracle_users
  WHERE DICTDBG.oracle_users.name MATCHES s_owner
  NO-LOCK
  BY DICTDBG.oracle_users.name:
    
  FOR EACH DICTDBG.oracle_objects
    WHERE DICTDBG.oracle_users.user# = DICTDBG.oracle_objects.owner# 
    AND   CAN-DO(tallowed,ENTRY(DICTDBG.oracle_objects.type + 1,oobjects))
    NO-LOCK
    BY DICTDBG.oracle_objects.name: 

    /* since there are no esc-characters possible in Oracle V6, we */
    /* can't use the wildcards. As soon as we drop V6-support, we  */
    /* can move this lines up into the where-clause                */
    IF  NOT ENTRY(DICTDBG.oracle_objects.type + 1,oobjects) MATCHES s_type
     OR NOT       DICTDBG.oracle_objects.name               MATCHES s_name
     THEN NEXT.
     
    FIND _File
      WHERE _File._Db-recid  = drec_db
      AND   _File._For-Name  = DICTDBG.oracle_objects.name
      AND   _File._For-Owner = DICTDBG.oracle_users.name
      NO-ERROR.

  /* Skip sequence generators created for compatible oracle tables */
  
    IF DICTDBG.oracle_objects.name MATCHES "*_SEQ" THEN
      NEXT.

  /* to prevent schemaholder-tables from beeing updated        */
  /*                                          <hutegger> 94/06 */
    IF available _File
      AND _file._file-name begins "oracle_" THEN NEXT.
      
    /* in Oracle 10g, there is a feature called flashback table which 
       saves deleted tables, by renaming them to BIN$<some-string>.
       We can skip these too.
    */
    IF DICTDBG.oracle_objects.NAME BEGINS "BIN$" THEN
       NEXT.

    DISPLAY DICTDBG.oracle_objects.name @ hint WITH FRAME gate_wait.
  /* exclude existing progress defs? */
  /*IF user_env[6] MATCHES "*x*" AND AVAILABLE _File THEN NEXT.*/
    CREATE gate-work.
    ASSIGN
      lim = lim + 1
      gate-work.gate-user = DICTDBG.oracle_users.name
      gate-work.gate-prog = (IF AVAILABLE _File
                              THEN _File._File-name ELSE ?).
    IF   DICTDBG.oracle_objects.type   =    4
     AND DICTDBG.oracle_objects.name BEGINS "BUFFER_"
     THEN ASSIGN
       gate-work.gate-name = SUBSTR(DICTDBG.oracle_objects.name
                                   ,8
                                   ,-1
                                   ,"character"
                                   )
       gate-work.gate-type = ENTRY(19,oobjects).
     ELSE ASSIGN
       gate-work.gate-name = DICTDBG.oracle_objects.name
       gate-work.gate-type = ENTRY(DICTDBG.oracle_objects.type + 1, oobjects).

  END. /* FOR EACH DICTDBG.oracle_users */
END. /* FOR EACH DICTDBG.oracle_objects */


{prodict/gate/ttygget.i
  &autocond = " where gate-work.gate-user <>  ""SYS"" "
  &block    = "presel"
  &db-type  = " ""ORACLE"" "
  &end      = "end."
  &gq       = " "
  } /* message and leave */


/*----------------------------------------------------------------------*/







