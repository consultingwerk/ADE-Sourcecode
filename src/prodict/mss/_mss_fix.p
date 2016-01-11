/*********************************************************************
* Copyright (C) 2005,2008-2011 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/


/*
Copied from _Odb_fix.p for MS Sql Server 7 DataServer

History:  D. McMann 04/21/00 Added assignment of user_env 28 and 29 as well
                               as checking for _seq in sequence name.
          D. McMann 08/14/00 Added assignment of index numbers 20000727012
          D. McMann 08/18/00 Changed size of identifiers max length 20000727-013
          D. McMann 07/05/01 Added assignment of _Order to be greater than original
                             Progress database so conflict would not happen.
                             20010703-019
          D.McMann  08/07/02 Added _Owner to FOR EACH on delete loop.
          D. McMann 10/17/03 Add NO-LOCK statement to _Db find in support of on-line schema add

*/  

DEFINE INPUT PARAMETER p_edbtype AS CHARACTER NO-UNDO.

DEFINE VARIABLE sseqn            AS CHARACTER FORMAT "x(60)" NO-UNDO.
DEFINE VARIABLE sfiln            AS CHARACTER NO-UNDO.
DEFINE VARIABLE sfldn            AS CHARACTER NO-UNDO.
DEFINE VARIABLE asfldn           AS CHARACTER NO-UNDO.
DEFINE VARIABLE m21              AS CHARACTER NO-UNDO.
DEFINE VARIABLE sidxn            AS CHARACTER NO-UNDO.
DEFINE VARIABLE ppi              AS CHARACTER NO-UNDO.
DEFINE VARIABLE spi              AS CHARACTER NO-UNDO.
DEFINE VARIABLE cext             AS INTEGER   NO-UNDO.
DEFINE VARIABLE ri               AS INTEGER   NO-UNDO.
DEFINE VARIABLE msg              AS CHARACTER   EXTENT 4 NO-UNDO.
DEFINE VARIABLE max_idx_len      AS INTEGER NO-UNDO.
DEFINE VARIABLE max_id_length    AS INTEGER NO-UNDO.
DEFINE VARIABLE idbtype          AS CHARACTER NO-UNDO.
DEFINE VARIABLE del-cycle        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l_idx-num       AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_files          AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_seqs           AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_views          AS CHARACTER NO-UNDO.
DEFINE VARIABLE maxorder         AS INTEGER   NO-UNDO.
DEFINE VARIABLE a                AS INTEGER   NO-UNDO.
DEFINE VARIABLE cType            AS CHARACTER NO-UNDO.
DEFINE VARIABLE migCon           AS LOGICAL   NO-UNDO.

DEFINE BUFFER   a_DICTDB         FOR DICTDB._Field.
DEFINE BUFFER   i_DICTDB        FOR DICTDB._Index.

DEFINE VARIABLE sconn            AS CHARACTER NO-UNDO.
DEFINE VARIABLE con_recid        AS INTEGER   NO-UNDO INITIAL 0.
DEFINE VARIABLE con-fld_recid    AS INTEGER   NO-UNDO.
DEFINE VARIABLE con_indx_recid   AS INTEGER   NO-UNDO.
DEFINE VARIABLE con_parnt_recid  AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_con-num        AS INTEGER   NO-UNDO.
DEFINE BUFFER   f_DICTDB2        FOR DICTDB2._File.
DEFINE BUFFER   f_DICTDB         FOR DICTDB._File.

DEFINE TEMP-TABLE verify-fname NO-UNDO
  FIELD new-name LIKE _Field._Field-name
  INDEX trun-name IS UNIQUE new-name.

DEFINE TEMP-TABLE verify-table NO-UNDO
  FIELD tnew-name LIKE _File._File-name
  INDEX trun-name IS UNIQUE tnew-name.

{ prodict/dictvar.i }
{ prodict/mss/mssvar.i } /* temp */
{ prodict/user/uservar.i }

/* DICTDB is the newly created schema holder.
 * DICTDB2 is the original progress database.
 */

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
FORM
  SKIP(1)
  msg[1] FORMAT "x(25)" LABEL "  File" SKIP
  msg[2] FORMAT "x(25)" LABEL " Field" SKIP
  msg[3] FORMAT "x(25)" LABEL " Index" SKIP
  msg[4] FORMAT "x(25)" LABEL " Component" SKIP
  SKIP(1)
  WITH FRAME mss_fix ATTR-SPACE OVERLAY SIDE-LABELS ROW 4 CENTERED
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN view-as dialog-box three-d &ENDIF
  TITLE " Updating MSS Schema Holder".
/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

IF NOT SESSION:BATCH-MODE  
 then assign SESSION:IMMEDIATE-DISPLAY = yes.

IF ENTRY(1,user_env[36]) = "y" 
THEN migCon = YES.
ELSE migCon = NO. 
  
if  user_env[25] = "**all**"
 or user_env[25] = ""
 then assign
  l_files = "**all**"
  l_seqs  = "**all**"
  l_views = "**all**"
  del-cycle = TRUE.
else if  num-entries(user_env[25],";") < 2
 then assign
  l_files = entry(1,user_env[25],";")
  l_seqs  = "**all**"
  l_views = "**all**".
else if  num-entries(user_env[25],";") < 3
 then assign
  l_files = entry(1,user_env[25],";")
  l_seqs  = entry(2,user_env[25],";")
  l_views = "**all**".
 else assign
  l_files = entry(1,user_env[25],";")
  l_seqs  = entry(2,user_env[25],";")
  l_views = entry(3,user_env[25],";").

 idbtype = { adecomm/ds_type.i
                &direction = "ETOI"
                &from-type = "p_edbtype"
                }.

IF user_env[28] <> ? AND user_env[28] <> ""  THEN
  max_idx_len = INTEGER(user_env[28]).
ELSE
  max_idx_len = 128.  

IF user_env[29] <> ? AND user_env[29] <> "" THEN
  max_id_length = INTEGER(user_env[29]).
ELSE
  max_id_length = 128.

  FOR EACH DICTDB2._View
    where ( l_views = "**all**"
         or lookup(DICTDB2._View._View-Name,l_views) <> 0
          ):
    FIND DICTDB._View WHERE DICTDB._View._View-Name = DICTDB2._View._View-Name NO-ERROR.
    IF AVAILABLE DICTDB._View THEN DO:
      FOR EACH DICTDB._View-col OF DICTDB._View:
          DELETE DICTDB._View-col.
      END.
      FOR EACH DICTDB._View-ref OF DICTDB._View:
          DELETE DICTDB._View-ref.
      END.
      DELETE DICTDB._View.
    END.
    CREATE DICTDB._View.
    ASSIGN DICTDB._View._View-Name    = DICTDB2._View._View-Name
           DICTDB._View._Auth-Id      = DICTDB2._View._Auth-Id
           DICTDB._View._Base-Tables  = DICTDB2._View._Base-Tables
           DICTDB._View._Where-Cls    = DICTDB2._View._Where-Cls
           DICTDB._View._Group-By     = DICTDB2._View._Group-By
           DICTDB._View._View-Def     = DICTDB2._View._View-Def
           DICTDB._View._Can-Read     = DICTDB2._View._Can-Read
           DICTDB._View._Can-Write    = DICTDB2._View._Can-Write
           DICTDB._View._Can-Create   = DICTDB2._View._Can-Create
           DICTDB._View._Can-Delete   = DICTDB2._View._Can-Delete
           DICTDB._View._Desc         = DICTDB2._View._Desc
           DICTDB._View._Updatable    = DICTDB2._View._Updatable.
    FOR EACH DICTDB2._View-Col of DICTDB2._View:    
      CREATE DICTDB._View-Col.
      ASSIGN DICTDB._View-Col._View-Name = DICTDB2._View-Col._View-Name
             DICTDB._View-Col._Auth-Id    = DICTDB2._View-Col._Auth-Id
             DICTDB._View-Col._Col-Name   = DICTDB2._View-Col._Col-Name
             DICTDB._View-Col._Base-Col   = DICTDB2._View-Col._Base-Col
             DICTDB._View-Col._Can-Write  = DICTDB2._View-Col._Can-Write
             DICTDB._View-Col._Can-Create = DICTDB2._View-Col._Can-Create
             DICTDB._View-Col._Vcol-Order = DICTDB2._View-Col._Vcol-Order.
    END. /* DICTDB2._View-Col */

    FOR EACH DICTDB2._View-Ref of DICTDB2._View:    
      CREATE DICTDB._View-Ref.
      ASSIGN DICTDB._View-Ref._View-Name = DICTDB2._View-Ref._View-Name
             DICTDB._View-Ref._Auth-Id   = DICTDB2._View-Ref._Auth-Id
             DICTDB._View-Ref._Ref-Table = DICTDB2._View-Ref._Ref-Table
             DICTDB._View-Ref._Base-Col  = DICTDB2._View-Ref._Base-Col.
    END. /* DICTDB2._View-Ref */
  END. /* each DICTDB2._View */

/* IF (user_env[32] <> ?   and user_env[25] BEGINS "y") THEN*/
FOR EACH DICTDB2._Sequence where ( l_seqs = "**all**"
       or lookup(DICTDB2._Sequence._Seq-Name,l_seqs) <> 0 ):
  ASSIGN sseqn = _Seq-Name
         sseqn = sseqn + "," + p_edbtype + "," + STRING(max_id_length).

  RUN prodict/misc/_resxlat.p (INPUT-OUTPUT sseqn).

/* _wrktgen.p does not allow _seq to be at the end of the sequence name so we have to do
   the same thing here.
*/   
  IF length(sseqn) > 3 AND lc(SUBSTRING(sseqn, (LENGTH(sseqn) - 3))) = "_seq" THEN
        ASSIGN sseqn = SUBSTRING(sseqn, 1, (LENGTH(sseqn) - 1)).

  FIND DICTDB._Db WHERE RECID(DICTDB._Db) = drec_db NO-LOCK.

  FIND DICTDB._Sequence OF DICTDB._Db WHERE DICTDB._Sequence._Seq-name = sseqn NO-ERROR.

  IF AVAILABLE DICTDB._Seq THEN 
    ASSIGN    
      DICTDB._Sequence._Seq-Name = DICTDB2._Sequence._Seq-Name
      DICTDB._Sequence._Seq-Init = DICTDB2._Sequence._Seq-Init
      DICTDB._Sequence._Seq-Incr = DICTDB2._Sequence._Seq-Incr
      DICTDB._Sequence._Seq-Min  = DICTDB2._Sequence._Seq-Min
      DICTDB._Sequence._Seq-Max  = DICTDB2._Sequence._Seq-Max
      DICTDB._Sequence._Cycle-Ok = DICTDB2._Sequence._Cycle-OK.

END. /* each DICTDB2._Sequence */


/* To avoid double dump-names we set them to ? for now, they will be
 * set to dictdb2._File._Dump-name lateron
 */
FOR EACH DICTDB._File WHERE DICTDB._File._DB-recid = drec_db
        and DICTDB._File._Owner = "_FOREIGN"
        and ( l_files = "**all**" or lookup(DICTDB._File._File-name,l_files) <> 0):
  ASSIGN DICTDB._File._Dump-name = ?.
END. /* each DICTDB2._File */


FOR EACH DICTDB2._File WHERE DICTDB2._File._Owner = "PUB" 
                         AND DICTDB2._File._Tbl-type = "T"
                         AND ( l_files = "**all**"
                               or lookup(DICTDB2._File._File-name,l_files) <> 0):

  IF DICTDB2._File._File-name BEGINS "_" THEN NEXT.
  
  ASSIGN sfiln = DICTDB2._File._File-name
         sfiln = sfiln + "," + p_edbtype + "," + string (max_id_length).

  RUN prodict/misc/_resxlat.p (INPUT-OUTPUT sfiln).

  _verify-table:
  DO WHILE TRUE:
    FIND verify-table WHERE verify-table.tnew-name = sfiln NO-ERROR.
    IF NOT AVAILABLE verify-table THEN DO:
      CREATE verify-table.
      ASSIGN verify-table.tnew-name = sfiln.
      LEAVE _verify-table.
    END.
    ELSE DO:
      DO a = 1 TO 999:
        ASSIGN sfiln = SUBSTRING(sfiln, 1, LENGTH(sfiln) - LENGTH(STRING(a))) + STRING(a).

        IF CAN-FIND(verify-table WHERE verify-table.tnew-name = sfiln) THEN NEXT.
        ELSE DO:
          CREATE verify-table.
          ASSIGN verify-table.tnew-name = sfiln.
          LEAVE _verify-table.
        END.
      END.
    END.    
  END.

  FIND DICTDB._File WHERE DICTDB._File._File-name = sfiln 
                      and DICTDB._File._DB-recid = drec_db 
                      and DICTDB._File._Owner = "_FOREIGN" NO-ERROR.

  IF NOT AVAILABLE DICTDB._File THEN NEXT.

  FOR EACH DICTDB._Field OF DICTDB._File WHERE	
    DICTDB._Field._For-Type = "TIME":
   
    IF TERMINAL <> "" and NOT SESSION:BATCH-MODE THEN
      DISPLAY  DICTDB._File._File-name @ msg[1]
	DICTDB._Field._Field-name @ msg[2]
	"" @ msg[3] "" @ msg[4]
	WITH FRAME mss_fix.
    DELETE DICTDB._Field.

  END. /* each DICTDB._Field */

  /* Do first to avoid _order collisions */
  FIND LAST DICTDB._Field OF DICTDB._FILE USE-INDEX _Field-position.
  ASSIGN maxorder = DICTDB._Field._Order.

  FOR EACH DICTDB._Field OF DICTDB._File:
    ASSIGN DICTDB._Field._Order = maxorder + 5
           maxorder = maxorder + 5.
  END.

  FOR EACH DICTDB2._File-Trig OF DICTDB2._File:
    FIND DICTDB._File-Trig OF DICTDB._File WHERE   
      DICTDB._File-Trig._Event = DICTDB2._File-Trig._Event NO-ERROR.
    IF AVAILABLE DICTDB._File-Trig THEN 
        DELETE DICTDB._File-Trig.

    CREATE DICTDB._File-Trig.
    ASSIGN DICTDB._File-Trig._File-Recid = RECID(DICTDB._File)
           DICTDB._File-Trig._Event      = DICTDB2._File-Trig._Event
           DICTDB._File-Trig._Proc-Name  = DICTDB2._File-Trig._Proc-Name
           DICTDB._File-Trig._Override   = DICTDB2._File-Trig._Override.

  END. /* each DICTDB2._File-Trig OF DICTDB2._File */

  /* Clear temp table for new file */
  FOR EACH verify-fname:
     DELETE verify-fname.
  END.

  FOR EACH DICTDB2._Field OF DICTDB2._File:
    ASSIGN sfldn = DICTDB2._Field._Field-name.

    /* Avoid collisions with unrolled extents */

    ASSIGN ri = R-INDEX (sfldn, "#").    
    IF ri > 2 AND ri < LENGTH (sfldn) THEN DO:
      IF INDEX ("0123456789", SUBSTR (sfldn, ri + 1, 1)) > 0 THEN DO:
	    ASSIGN asfldn = SUBSTR (sfldn, 1, ri - 1).
	    IF CAN-FIND (DICTDB._Field OF DICTDB._File WHERE
	          DICTDB._Field._Field-name = asfldn) THEN
          OVERLAY (sfldn, ri, 1) = "_".   
      END.
    END.

    ASSIGN sfldn = sfldn + "," + p_edbtype + "," + string (max_id_length).
    RUN prodict/misc/_resxlat.p (INPUT-OUTPUT sfldn).

    /* We have to do the same thing we do when running protoora.
       We need to keep track of the names we come up with, and
       find unique names if the one we just got now is duplicate.*/
    FIND FIRST verify-fname WHERE new-name = sfldn NO-ERROR.

    IF NOT AVAILABLE verify-fname THEN DO:
      CREATE verify-fname.
      ASSIGN verify-fname.new-name = sfldn.
    END.
    ELSE DO:
        DO a = 1 TO 999:
          ASSIGN sfldn = SUBSTRING(sfldn, 1, LENGTH(sfldn) - LENGTH(STRING(a))) + STRING(a).

          IF CAN-FIND(verify-fname WHERE verify-fname.new-name = sfldn) THEN 
              NEXT.
          ELSE DO:
            CREATE verify-fname.
            ASSIGN verify-fname.new-name = sfldn.
            LEAVE. /* get out of the a =1 to 999 loop */
          END.
        END.
    END.

    IF TERMINAL <> "" and NOT SESSION:BATCH-MODE THEN
      DISPLAY  DICTDB2._File._File-name @ msg[1]
        DICTDB2._Field._Field-name @ msg[2]
        "" @ msg[3] "" @ msg[4]
        WITH FRAME mss_fix.

    IF DICTDB2._Field._Extent > 0 AND NOT CAN-FIND (DICTDB._Field OF DICTDB._File 
                WHERE DICTDB._Field._Field-name = sfldn) THEN DO:
      ASSIGN asfldn = sfldn + "#".
      
      FIND a_DICTDB OF DICTDB._File WHERE a_DICTDB._Field-name = asfldn NO-ERROR.
      IF NOT AVAILABLE a_DICTDB THEN NEXT.
      
      ASSIGN m21 = a_DICTDB._For-Name.
      IF R-INDEX (m21, "#") > 3 THEN
	    ASSIGN m21 = SUBSTR (m21, 1, R-INDEX(m21, "#") - 2).

      CREATE DICTDB._Field.
      ASSIGN DICTDB._Field._File-recid      = RECID(DICTDB._File)
	         DICTDB._Field._For-Name        = m21
	         DICTDB._Field._Fld-stdtype     = a_DICTDB._Fld-stdtype
	         DICTDB._Field._Fld-stoff       = a_DICTDB._Fld-stoff
	         DICTDB._Field._Fld-misc2[8]    = a_DICTDB._Fld-misc2[8]
	         DICTDB._Field._Field-name      = DICTDB2._Field._Field-name
	         DICTDB._Field._Fld-case        = DICTDB2._Field._Fld-case
	         DICTDB._Field._Data-type       = DICTDB2._Field._Data-type
	         DICTDB._Field._Format          = DICTDB2._Field._Format
	         DICTDB._Field._Initial         = DICTDB2._Field._Initial
	         DICTDB._Field._Mandatory       = DICTDB2._Field._Mandatory
	         DICTDB._Field._Decimals        = DICTDB2._Field._Decimals
	         DICTDB._Field._Order           = DICTDB2._Field._Order
	         DICTDB._Field._Desc            = DICTDB2._Field._Desc
	         DICTDB._Field._Can-Read        = DICTDB2._Field._Can-Read
	         DICTDB._Field._Can-Write       = DICTDB2._Field._Can-Write
	         DICTDB._Field._Label           = DICTDB2._Field._Label
	         DICTDB._Field._Col-label       = DICTDB2._Field._Col-label
	         DICTDB._Field._Valexp          = DICTDB2._Field._Valexp
	         DICTDB._Field._Valmsg          = DICTDB2._Field._Valmsg
	         DICTDB._Field._Help            = DICTDB2._Field._Help
             DICTDB._Field._Col-label-sa    = DICTDB2._Field._Col-label-sa
             DICTDB._Field._Format-sa       = DICTDB2._Field._Format-sa
             DICTDB._Field._Help-sa         = DICTDB2._Field._Help-sa
             DICTDB._Field._Initial-sa      = DICTDB2._Field._Initial-sa
             DICTDB._Field._Label-sa        = DICTDB2._Field._Label-sa
             DICTDB._Field._Valmsg-sa       = DICTDB2._Field._Valmsg-sa
	         DICTDB._Field._For-Id          = a_DICTDB._For-Id
	         DICTDB._Field._For-Primary     = a_DICTDB._For-Primary
	         DICTDB._Field._For-Spacing     = a_DICTDB._For-Spacing
	         DICTDB._Field._For-Scale       = a_DICTDB._For-Spacing
	         DICTDB._Field._For-Type        = a_DICTDB._For-Type
	         DICTDB._Field._For-Itype       = a_DICTDB._For-Itype
	         DICTDB._Field._For-Xpos        = a_DICTDB._For-Xpos
	         DICTDB._Field._For-Retrieve    = a_DICTDB._For-Retrieve
	         DICTDB._Field._For-Separator   = a_DICTDB._For-Separator
	         DICTDB._Field._For-Maxsize     = a_DICTDB._For-Maxsize
	         DICTDB._Field._For-Allocated   = a_DICTDB._For-Allocated
	         DICTDB._Field._View-As         = DICTDB2._Field._View-As
	         DICTDB._Field._Extent          = DICTDB2._Field._Extent.

/*      IF DICTDB._Field._Data-type = "RECID" THEN
          DICTDB._Field._Data-type = "INTEGER".
*/
	  DO cext = 1 TO DICTDB._Field._Extent:
	    ASSIGN asfldn = sfldn + "#" + STRING (cext).

	    FIND a_DICTDB OF DICTDB._File WHERE a_DICTDB._Field-name = asfldn NO-ERROR.

	    IF AVAILABLE a_DICTDB THEN
	      DELETE a_DICTDB.

	  END. /* DICTDB._Field._Extent > 1 DO cext = 1 TO ... */
    END. /* DICTDB2._Field._Extent > 0 */
    ELSE DO: /* !  DICTDB2._Field._Extent > 0 */

      FIND DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Field-name = sfldn NO-ERROR.
      IF NOT AVAILABLE DICTDB._Field THEN NEXT.
    END. /* !  DICTDB2._Field._Extent > 0 */

    ASSIGN cType =  DICTDB2._Field._Data-type.

    /* if type is RAW in the OE db and varchar in the foreign db, we can't make it
       RAW or we will get error 6187, so leave it alone.
    */
    IF cType = "RAW" AND INDEX(DICTDB._Field._For-type, "varchar") > 0  THEN
       ASSIGN cType = DICTDB._Field._Data-type.

    ASSIGN  DICTDB._Field._Field-name   = DICTDB2._Field._Field-name
            DICTDB._Field._Data-type    = cType
            DICTDB._Field._Format       = DICTDB2._Field._Format
            DICTDB._Field._Fld-case     = DICTDB2._Field._Fld-case
            DICTDB._Field._Initial      = DICTDB2._Field._Initial
            DICTDB._Field._Mandatory    = DICTDB2._Field._Mandatory
            DICTDB._Field._Decimals     = DICTDB2._Field._Decimals
            DICTDB._Field._Order        = DICTDB2._Field._Order
            DICTDB._Field._Desc         = DICTDB2._Field._Desc
            DICTDB._Field._Can-Read     = DICTDB2._Field._Can-Read
            DICTDB._Field._Can-Write    = DICTDB2._Field._Can-Write
            DICTDB._Field._Label        = DICTDB2._Field._Label
            DICTDB._Field._Col-label    = DICTDB2._Field._Col-label
            DICTDB._Field._Valexp       = DICTDB2._Field._Valexp
            DICTDB._Field._Valmsg       = DICTDB2._Field._Valmsg
            DICTDB._Field._Col-label-sa = DICTDB2._Field._Col-label-sa
            DICTDB._Field._Format-sa    = DICTDB2._Field._Format-sa
            DICTDB._Field._Help-sa      = DICTDB2._Field._Help-sa
            DICTDB._Field._Initial-sa   = DICTDB2._Field._Initial-sa
            DICTDB._Field._Label-sa     = DICTDB2._Field._Label-sa
            DICTDB._Field._Valmsg-sa    = DICTDB2._Field._Valmsg-sa
            DICTDB._Field._View-As      = DICTDB2._Field._View-As
            DICTDB._Field._Help         = DICTDB2._Field._Help.


/*    IF DICTDB._Field._Data-type = "RECID" THEN
       DICTDB._Field._Data-type = "INTEGER".
*/
 /*------------------------------------------------------------------*/
/*------------------------  FIELD-TRIGGERS  ------------------------*/
/*------------------------------------------------------------------*/

    FOR EACH DICTDB2._Field-Trig OF DICTDB2._Field:
      FIND DICTDB._Field-Trig OF DICTDB._Field WHERE
        DICTDB._Field-Trig._Event = DICTDB2._Field-Trig._Event NO-ERROR.
      IF AVAILABLE DICTDB._Field-Trig THEN 
          DELETE DICTDB._Field-Trig.

      CREATE DICTDB._Field-Trig.
      ASSIGN
          DICTDB._Field-Trig._Field-Recid = RECID (DICTDB._Field)
          DICTDB._Field-Trig._File-Recid  = RECID (DICTDB._File)
          DICTDB._Field-Trig._Event       = DICTDB2._Field-Trig._Event
          DICTDB._Field-Trig._Proc-Name   = DICTDB2._Field-Trig._Proc-Name
          DICTDB._Field-Trig._Override    = DICTDB2._Field-Trig._Override.
    END. /* each DICTDB2._Field-Trig OF DICTDB2._Field */
  END. /* each DICTDB2._Field OF DICTDB2._File */

  /*------------------------------------------------------------------*/
  /*---------------------------  INDEXES  ----------------------------*/
  /*------------------------------------------------------------------*/

  /* we first need to give the indexes a higher number, so that we then
   * can safely assign the number from the original db. Otherwise we run
   * the problem of assigning the same number to two different indexes
   */
  ASSIGN l_idx-num = 0.
  FOR EACH DICTDB._Index OF DICTDB._File:
    IF l_idx-num < DICTDB._Index._idx-num THEN
      ASSIGN l_idx-num = DICTDB._Index._idx-num.
  END.

  _idxloop:
  FOR EACH DICTDB2._Index OF DICTDB2._File:
    IF DICTDB2._Index._Wordidx = 1  OR DICTDB2._Index._Index-name = "default"
        THEN NEXT _idxloop.

    ASSIGN sidxn = DICTDB2._Index._Index-Name.

    IF TERMINAL <> "" and NOT SESSION:BATCH-MODE THEN
      DISPLAY  DICTDB2._File._File-name @ msg[1] "" @ msg[2]
         DICTDB2._Index._Index-Name @ msg[3] "" @ msg[4]
         WITH FRAME mss_fix.

    ASSIGN sidxn = sidxn + "," + p_edbtype + "," + string (max_idx_len).
    RUN prodict/misc/_resxlat.p (INPUT-OUTPUT sidxn).

    FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-Name = sidxn
      NO-ERROR.
    IF NOT AVAILABLE DICTDB._Index THEN
      FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._For-Name = sidxn
      NO-ERROR.
    IF NOT AVAILABLE DICTDB._Index THEN
      FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-name = DICTDB2._index._Index-name NO-ERROR.

    IF NOT AVAILABLE DICTDB._Index THEN DO:
      CREATE DICTDB._Index.
      ASSIGN
        l_idx-num                   = l_idx-num + 1
        DICTDB._Index._File-recid   = RECID (DICTDB._File)
        DICTDB._Index._Wordidx      = DICTDB2._Index._Wordidx
        DICTDB._Index._Desc         = DICTDB2._Index._Desc
        DICTDB._Index._For-Name     = sidxn
        DICTDB._Index._For-type     = DICTDB2._Index._For-type
        DICTDB._Index._Index-name   = DICTDB2._Index._Index-Name
        DICTDB._Index._Active       = DICTDB2._Index._Active
        DICTDB._Index._idx-num      = l_idx-num
        DICTDB._Index._Unique       = DICTDB2._Index._Unique.
    END. /* NOT AVAILABLE DICTDB._Index */
    ELSE DO: /* AVAILABLE DICTDB._Index */
      ASSIGN
        DICTDB._Index._Desc         = DICTDB2._Index._Desc
	    DICTDB._Index._Index-name   = DICTDB2._Index._Index-name.
    END. /* AVAILABLE DICTDB._Index */

    FOR EACH DICTDB2._Index-field OF DICTDB2._Index:

      FIND DICTDB2._Field WHERE RECID(DICTDB2._Field) = 
	       DICTDB2._Index-field._Field-recid NO-ERROR.
      IF NOT AVAILABLE DICTDB2._Field THEN NEXT.     

      IF TERMINAL <> "" and NOT SESSION:BATCH-MODE THEN
        DISPLAY  DICTDB2._File._File-name @ msg[1] "" @ msg[2]
	             DICTDB2._Index._Index-Name @ msg[3]
                 DICTDB2._Field._Field-name @ msg[4]
	         WITH FRAME mss_fix.

      ASSIGN sfldn = DICTDB2._Field._Field-name.

      FIND DICTDB._Field WHERE DICTDB._Field._File-recid = RECID (DICTDB._File) 
                           AND DICTDB._Field._Field-name = sfldn NO-ERROR.
      IF NOT AVAILABLE DICTDB._Field THEN NEXT.

      FIND DICTDB._Index-field OF DICTDB._Index WHERE DICTDB._Index-field._Index-seq = DICTDB2._Index-field._Index-seq NO-ERROR.
      IF NOT AVAILABLE DICTDB._Index-field THEN DO:
	    CREATE DICTDB._Index-field.
	    ASSIGN DICTDB._Index-field._Index-recid = RECID (DICTDB._Index)
	           DICTDB._Index-field._Field-recid = RECID (DICTDB._Field)
	           DICTDB._Index-field._Index-seq   = DICTDB2._Index-field._Index-seq
	           DICTDB._Index-field._Ascending   = DICTDB2._Index-field._Ascending
	           DICTDB._Index-field._Abbreviate  = DICTDB2._Index-field._Abbreviate
	           DICTDB._Index-field._Unsorted    = DICTDB2._Index-field._Unsorted.
      END. /* NOT avaiable DICTDB._Index-field */
      ELSE DO: /* avaiable DICTDB._Index-field */
	    ASSIGN DICTDB._Index-field._Ascending   = DICTDB2._Index-field._Ascending
               DICTDB._Index-field._Abbreviate  = DICTDB2._Index-field._Abbreviate.
      END. /* avaiable DICTDB._Index-field */
    END. /* each DICTDB2._Index-field */
  END. /* each DICTDB2._Index OF DICTDB2._File */

	/* Remove any extra indexes from the schema holder */
  _rmvidx:
  FOR EACH DICTDB._Index OF DICTDB._File:
    ASSIGN sidxn = DICTDB._Index._Index-Name.
    IF sidxn = "default_" THEN NEXT.

    IF TERMINAL <> "" and NOT SESSION:BATCH-MODE THEN
      DISPLAY  DICTDB._File._File-name @ msg[1] "" @ msg[2]
               DICTDB._Index._Index-Name @ msg[3] "" @ msg[4]
               WITH FRAME mss_fix.

    FIND DICTDB2._Index OF DICTDB2._File WHERE  DICTDB2._Index._Index-Name = DICTDB._Index._Index-Name NO-ERROR.
    IF AVAILABLE DICTDB2._Index THEN NEXT.
    IF RECID(DICTDB._Index) = DICTDB._File._Prime-index THEN DO:
      FIND FIRST i_dictdb WHERE RECID(i_dictdb) <> RECID(DICTDB._Index)
                             AND i_dictdb._File-recid = RECID(DICTDB._File)
                             AND i_dictdb._Unique NO-ERROR.
      IF AVAILABLE i_dictdb THEN 
        ASSIGN DICTDB._File._Prime-index = RECID(i_dictdb).
      ELSE DO:
        FIND FIRST i_dictdb WHERE RECID(i_dictdb) <> RECID(DICTDB._Index)
                              AND i_dictdb._File-recid = RECID(DICTDB._File)
                              NO-ERROR.
        IF AVAILABLE i_dictdb THEN
          ASSIGN DICTDB._File._Prime-index = RECID(i_dictdb).
        ELSE NEXT _rmvidx.
      END.
    END.
    IF DICTDB._Index._idx-num = DICTDB._File._Fil-misc1[2] THEN DO:
       /* This is a selected ROWID for this table but no mapping in progress db    *
          find a corresponding Progress index and pass the rowid designation to it *
       */
       FIND FIRST DICTDB._constraint WHERE DICTDB._Constraint._File-Recid = RECID(DICTDB._File)
                               AND (DICTDB._Constraint._Con-Type = "P" OR
                                    DICTDB._Constraint._Con-Type = "PC" OR DICTDB._Constraint._Con-Type = "MP" )
                               AND DICTDB._constraint._Con-Status <> "D" AND DICTDB._constraint._Con-Status <> "O"
                               AND DICTDB._constraint._con-name = DICTDB._Index._Index-Name 
                               AND DICTDB._constraint._Con-Active = TRUE
                               NO-LOCK NO-ERROR.
      IF NOT AVAILABLE DICTDB._constraint THEN 
             FIND FIRST DICTDB._constraint WHERE DICTDB._Constraint._File-Recid = RECID(DICTDB._File)
                               AND (DICTDB._Constraint._Con-Type = "P" OR
                                    DICTDB._Constraint._Con-Type = "PC" OR DICTDB._Constraint._Con-Type = "MP" )
                               AND DICTDB._constraint._Con-Status <> "D" AND DICTDB._constraint._Con-Status <> "O"
                               AND substr(DICTDB._constraint._con-name,2,LENGTH(DICTDB._constraint._con-name)) = 
                                          DICTDB._Index._Index-Name 
                               AND DICTDB._constraint._Con-Active = TRUE
                               NO-LOCK NO-ERROR.

      ASSIGN con_recid =  RECID(DICTDB._CONSTRAINT).
    END.
    FOR EACH DICTDB._Index-field OF DICTDB._Index:
      DELETE DICTDB._Index-field.
    END. /* DICTDB._Index-field OF DICTDB._Index */

    DELETE DICTDB._Index.

  END. /* DICTDB._Index OF DICTDB._File */

	/* Set the primary index */

  FIND DICTDB._Index WHERE RECID(DICTDB._Index) = DICTDB._File._Prime-Index
      NO-ERROR.
  IF AVAILABLE DICTDB._Index THEN
    ASSIGN spi = DICTDB._Index._Index-Name.
  ELSE
    ASSIGN spi = ?.

  FIND DICTDB2._Index WHERE RECID(DICTDB2._Index) = DICTDB2._File._Prime-Index
     NO-ERROR.
  IF AVAILABLE DICTDB2._Index THEN
    ASSIGN ppi = DICTDB2._Index._Index-Name.
  ELSE
    ASSIGN ppi = ?.

  IF spi <> ppi AND ppi <> ? THEN DO:
    FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-Name = ppi NO-ERROR.
    IF AVAILABLE DICTDB._Index THEN 
      DICTDB._File._Prime-Index= RECID(DICTDB._Index).      
  END. /* spi <> ppi AND ppi <> ? */

  /*-----------------------------------------------------------------*/
 /*-----------------------  CONSTRAINTS     ------------------------*/
/*-----------------------------------------------------------------*/

IF migCon THEN DO: /* constraints only fixed if migrate constraints set intitially */
  ASSIGN l_con-num = 0.
  FOR EACH DICTDB._Constraint:
    IF l_con-num < DICTDB._Constraint._con-num THEN
      ASSIGN l_con-num = DICTDB._Constraint._con-num.
  END.
  
  _con-loop:
  FOR EACH DICTDB2._Constraint OF DICTDB2._File:
    IF DICTDB2._Constraint._Con-Status = "D" OR DICTDB2._Constraint._Con-Status = "O"
       THEN NEXT _con-loop.
       
        IF (DICTDB2._Constraint._Con-Type = "C" OR DICTDB2._Constraint._Con-Type = "D")
        THEN DO:
          FIND FIRST DICTDB2._Field OF DICTDB2._File WHERE RECID(DICTDB2._Field) = DICTDB2._Constraint._Field-Recid NO-LOCK NO-ERROR.
          FIND FIRST DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Field-Name = DICTDB2._Field._Field-Name NO-LOCK NO-ERROR.
          ASSIGN con-fld_recid = RECID (DICTDB._Field).
        END.   
        
        
        IF (DICTDB2._Constraint._Con-Type = "F" OR DICTDB2._Constraint._Con-Type = "U" OR DICTDB2._Constraint._Con-Type = "PC" 
              OR DICTDB2._Constraint._Con-Type = "P" OR DICTDB2._Constraint._Con-Type = "MP" OR DICTDB2._Constraint._Con-Type = "M")
        THEN DO:     
          FIND FIRST DICTDB2._Index OF DICTDB2._File WHERE RECID(DICTDB2._Index) = DICTDB2._Constraint._Index-Recid NO-LOCK NO-ERROR.
          FIND FIRST DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-Name = DICTDB2._Index._Index-Name NO-LOCK NO-ERROR.
          ASSIGN con_indx_recid = RECID (DICTDB._Index).
        END.
        
        IF DICTDB2._Constraint._Con-Type = "F"
        THEN DO:
          FIND FIRST DICTDB2._Index WHERE RECID(DICTDB2._Index) = DICTDB2._Constraint._Index-Parent-Recid NO-LOCK NO-ERROR.
          FIND first f_DICTDB2 WHERE RECID(f_DICTDB2) = DICTDB2._Index._File-Recid NO-LOCK NO-ERROR.
          FIND FIRST f_DICTDB WHERE f_DICTDB._File-Name = f_DICTDB2._File-Name NO-LOCK NO-ERROR.
          FIND FIRST DICTDB._Index OF f_DICTDB WHERE DICTDB._Index._Index-Name = DICTDB2._Index._Index-Name NO-LOCK NO-ERROR.
          ASSIGN con_parnt_recid = RECID(DICTDB._Index).  
        END.  
        
        
      FIND FIRST DICTDB._Constraint OF DICTDB._File WHERE DICTDB._Constraint._Con-Name = DICTDB2._Constraint._Con-Name EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE(DICTDB._Constraint) THEN
      FIND FIRST DICTDB._Constraint OF DICTDB._File WHERE DICTDB._Constraint._Con-Name = DICTDB2._Constraint._For-Name EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE(DICTDB._Constraint) 
      THEN DO: 
      l_con-num                        = l_con-num + 1.      
      CREATE DICTDB._Constraint.
      ASSIGN
        DICTDB._Constraint._File-recid   = RECID (DICTDB._File)
        DICTDB._constraint._db-recid     = drec_db
        DICTDB._Constraint._Con-Desc     = DICTDB2._Constraint._Con-Desc
        DICTDB._Constraint._For-Name     = DICTDB2._Constraint._For-Name
        DICTDB._Constraint._Con-Name     = DICTDB2._Constraint._Con-Name
        DICTDB._Constraint._Con-Type     = DICTDB2._Constraint._Con-Type
        DICTDB._Constraint._Con-Expr     = DICTDB2._Constraint._Con-Expr
        DICTDB._Constraint._Con-Status   = DICTDB2._Constraint._Con-Status
        DICTDB._Constraint._Con-Type     = DICTDB2._Constraint._Con-Type
        DICTDB._constraint._con-num      = l_con-num
        DICTDB._Constraint._Con-Active   = TRUE.
        
        IF (DICTDB2._Constraint._Con-Type = "C" OR DICTDB2._Constraint._Con-Type = "D")
        THEN
           DICTDB._Constraint._Field-Recid = con-fld_recid.
        ELSE 
           DICTDB._Constraint._Index-Recid = con_indx_recid.
        
        IF DICTDB2._Constraint._Con-Type = "F"
        THEN
           DICTDB._Constraint._Index-Parent-Recid = con_parnt_recid.   
        
      END.
      ELSE DO:
      ASSIGN 
        DICTDB._constraint._db-recid     = drec_db
        DICTDB._Constraint._Con-Desc     = DICTDB2._Constraint._Con-Desc
        DICTDB._Constraint._For-Name     = DICTDB2._Constraint._For-Name
        DICTDB._Constraint._Con-Name     = DICTDB2._Constraint._Con-Name
        DICTDB._Constraint._Con-Status   = DICTDB2._Constraint._Con-Status
        DICTDB._Constraint._Con-Expr     = DICTDB2._Constraint._Con-Expr
        DICTDB._Constraint._Con-Active   = TRUE.
        
        IF (DICTDB2._Constraint._Con-Type = "C" OR DICTDB2._Constraint._Con-Type = "D")
        THEN
           DICTDB._Constraint._Field-Recid = con-fld_recid.
        ELSE 
           DICTDB._Constraint._Index-Recid = con_indx_recid.
        
        IF DICTDB2._Constraint._Con-Type = "F"
        THEN
           DICTDB._Constraint._Index-Parent-Recid = con_parnt_recid.  
   
      END. 
  END.
END. /* Migrate constraint */  
  _rmcon:
  FOR EACH DICTDB._constraint OF DICTDB._File:
     FIND FIRST DICTDB2._Constraint WHERE DICTDB2._Constraint._Con-Name = DICTDB._Constraint._Con-Name NO-LOCK NO-ERROR.
     IF NOT AVAILABLE (DICTDB2._Constraint)
     THEN DO: 
         FOR EACH DICTDB._Constraint-Keys WHERE recid(DICTDB._Constraint) = DICTDB._Constraint-Keys._con-recid:
             DELETE DICTDB._Constraint-Keys.
         END.
         DELETE DICTDB._Constraint.
     END.
  END.
  
  IF con_recid <> 0 THEN DO:
     FIND FIRST DICTDB._constraint WHERE RECID(DICTDB._constraint) = con_recid NO-LOCK NO-ERROR.
     FIND FIRST i_dictdb WHERE RECID(i_dictdb) = DICTDB._Constraint._Index-recid NO-LOCK NO-ERROR.
     ASSIGN DICTDB._File._Fil-misc1[2] = i_dictdb._idx-num
            con_recid = 0.  /* re-initialize */
  END.

  IF TERMINAL <> "" and NOT SESSION:BATCH-MODE THEN
    DISPLAY DICTDB2._File._File-name @ msg[1] "" @ msg[2] "" @ msg[3] 
        "" @ msg[4]
        WITH FRAME mss_fix.
  /* Do this last since it may set _File._Frozen. */

  ASSIGN DICTDB._File._File-name     = DICTDB2._File._File-name
         DICTDB._File._Can-Create    = DICTDB2._File._Can-Create
         DICTDB._File._Can-Read      = DICTDB2._File._Can-Read
         DICTDB._File._Can-Write     = DICTDB2._File._Can-Write
         DICTDB._File._Can-Delete    = DICTDB2._File._Can-Delete
         DICTDB._File._Desc          = DICTDB2._File._Desc
         DICTDB._File._Valexp        = DICTDB2._File._Valexp
         DICTDB._File._Valmsg        = DICTDB2._File._Valmsg
         DICTDB._File._File-Label    = DICTDB2._File._File-Label
         DICTDB._File._File-Label-sa = DICTDB2._File._File-Label-sa
         DICTDB._File._Valmsg-sa     = DICTDB2._File._Valmsg-sa
         DICTDB._File._Dump-name     = DICTDB2._File._Dump-name.

  ASSIGN DICTDB._File._Frozen        = DICTDB2._File._Frozen.
END. /* each DICTDB2._File */

/* Now check DICTDB._File to make sure we get only those we pushed */
IF del-cycle THEN DO:
  FOR EACH DICTDB._File WHERE DICTDB._File._Tbl-type = "T"
                          AND DICTDB._File._Owner = "_Foreign":
    IF DICTDB._File._Hidden THEN NEXT.
    FIND DICTDB2._File WHERE DICTDB2._File._File-name = DICTDB._File._File-name 
                         AND DICTDB2._File._Owner = "PUB"  NO-ERROR.
    IF NOT AVAILABLE DICTDB2._File THEN DO:
      FOR EACH DICTDB._Constraint OF DICTDB._File:
         FOR EACH DICTDB._Constraint-Keys WHERE recid(DICTDB._Constraint) = DICTDB._Constraint-Keys._con-recid:
             DELETE DICTDB._Constraint-Keys.
         END.
         DELETE DICTDB._Constraint.
      END.
      FOR EACH DICTDB._INDEX OF DICTDB._File:
        FOR EACH DICTDB._Index-field of DICTDB._Index:
          DELETE DICTDB._Index-field.
        END.
        DELETE DICTDB._Index.
      END.
      FOR EACH DICTDB._Field OF DICTDB._File:
        DELETE DICTDB._Field.
      END.
      DELETE DICTDB._File.
    END.
  END.  
  FOR EACH DICTDB._Sequence:
    FIND DICTDB2._Sequence WHERE DICTDB2._Sequence._Seq-name = DICTDB._Sequence._Seq-name NO-ERROR.    
    IF NOT AVAILABLE DICTDB2._Sequence THEN
       DELETE DICTDB._Sequence.
  END.    
END.

IF NOT SESSION:BATCH-MODE THEN 
    HIDE FRAME mss_fix NO-PAUSE.

IF NOT SESSION:BATCH-MODE  
 then assign SESSION:IMMEDIATE-DISPLAY = no.

RETURN.









