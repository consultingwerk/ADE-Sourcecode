/*********************************************************************
* Copyright (C) 2019 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/ora/_ora_fix.p

Description:
    last step of protoora.
    adjusts schemaholder to original progress-db


Input:
    none

Output:
    none
    
Used/Modified Shared Objects:
    drec_db
    user_dbname

History:
    ?           9?/??   created
   DLM         11/12/97 Added view-as dialog-box to screens for non TTY clients.
   DLM         11/24/97 Added logic to skip word indexes
   DLM         03/19/98 Added logic to look at _for-name if _file or _field 
                        can not be found.    
   DLM         04/17/98 Added logic to skip _Index-field record which is
                        now associated with default index. 
   DLM         07/13/98 Added _Owner to _File Find   
   DLM         09/17/98 Removed creating defalut index as default_  
   DLM         02/02/99 Added passign dbtype and length to _resxlat.p  
   DLM         02/08/99 Added delete loop for files not pushed.   
   DLM         10/20/99 Added check for system tables in delete loop.  
   DLM         11/18/99 Fixed so procedure can run with protoora and adjust schema
   DLM         01/25/00 Added sequences to delete loop.
   DLM         06/01/00 Fixed seq name translation so _seq becomes _se
   DLM         05/10/01 Added check for _Unique now that DESC Index can not
                        be determined if unique so make sure it matches Original
   DLM         05/09/02 Change length from 30 to 26 to match protoora.
   DLM         07/23/02 Added _OWNER = "Pub" on the delete for each _file section. 20020723-004
   DLM         06/21/11 kmayur  added support for constraint - OE00195067                                
--------------------------------------------------------------------*/
/*h-*/

{ prodict/user/uservar.i } 

/* _ora_fix */

DEFINE SHARED VARIABLE drec_db  AS RECID     NO-UNDO.

DEFINE VARIABLE a               AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_dump-name     AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_idx-num       AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_max-order     AS INTEGER   NO-UNDO.
DEFINE VARIABLE oseqn           AS CHARACTER NO-UNDO.
DEFINE VARIABLE ofiln           AS CHARACTER NO-UNDO.
DEFINE VARIABLE ofldn           AS CHARACTER NO-UNDO.
DEFINE VARIABLE aofldn          AS CHARACTER NO-UNDO.
DEFINE VARIABLE m21             AS CHARACTER NO-UNDO.
DEFINE VARIABLE oidxn           AS CHARACTER NO-UNDO.
DEFINE VARIABLE ppi             AS CHARACTER NO-UNDO.
DEFINE VARIABLE opi             AS CHARACTER NO-UNDO.
DEFINE VARIABLE cext            AS INTEGER   NO-UNDO.
DEFINE VARIABLE ri              AS INTEGER   NO-UNDO.
DEFINE VARIABLE msg                AS CHARACTER   EXTENT 4 NO-UNDO.
DEFINE VARIABLE batch_mode      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE dbtype-l         AS CHARACTER NO-UNDO.
DEFINE VARIABLE migCon           AS LOGICAL   NO-UNDO.

DEFINE VARIABLE l_files          AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_seqs           AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_views          AS CHARACTER NO-UNDO.
DEFINE vARIABLE l_sys-obj        AS CHARACTER NO-UNDO.
DEFINE VARIABLE del-cycle        AS LOGICAL   NO-UNDO.

DEFINE VARIABLE max_name_size    AS CHARACTER INITIAL "26" NO-UNDO.
DEFINE VARIABLE temp_dbtype-1    AS CHARACTER NO-UNDO.
DEFINE VARIABLE temp_size        AS INTEGER   NO-UNDO.
DEFINE VARIABLE cid              AS CHARACTER NO-UNDO.

/* CR#00195067 */
DEFINE VARIABLE sconn            AS CHARACTER NO-UNDO.
DEFINE VARIABLE con-fld_recid    AS INTEGER   NO-UNDO.
DEFINE VARIABLE con_indx_recid   AS INTEGER   NO-UNDO.
DEFINE VARIABLE con_parnt_recid  AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_con-num        AS INTEGER   NO-UNDO.
DEFINE BUFFER   f_DICTDB2         FOR DICTDB2._File.
DEFINE BUFFER   f_DICTDB         FOR DICTDB._File.

DEFINE TEMP-TABLE verify-fname NO-UNDO
  FIELD new-name LIKE _Field._Field-name
  INDEX trun-name IS UNIQUE new-name.

DEFINE TEMP-TABLE verify-table NO-UNDO
  FIELD tnew-name LIKE _File._File-name
  INDEX trun-name IS UNIQUE tnew-name.

DEFINE BUFFER   a_DICTDB        FOR DICTDB._Field.
DEFINE BUFFER   i_DICTDB        FOR DICTDB._Index.

/* DICTDB is the newly created schema holder.
 * DICTDB2 is the original progress database.
 */

/* LANGUAGE DEPENDENCIES START */ /*--------------------------------*/
FORM
  SKIP(1)
  msg[1] FORMAT "x(25)" LABEL " File"      SKIP
  msg[2] FORMAT "x(25)" LABEL " Field"     SKIP
  msg[3] FORMAT "x(25)" LABEL " Index"     SKIP
  msg[4] FORMAT "x(25)" LABEL " Component" SKIP
  SKIP(1)
  WITH FRAME ora_fix ATTR-SPACE OVERLAY SIDE-LABELS ROW 4 CENTERED
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN view-as dialog-box three-d &ENDIF
  TITLE " Updating ORACLE Schema Holder".
  
/* LANGUAGE DEPENDENCIES END */ /*----------------------------------*/


/*------------------------------------------------------------------*/
/*---------------------------  MAIN-CODE  --------------------------*/
/*------------------------------------------------------------------*/


/*------------------------ INITIALIZATIONS -------------------------*/

ASSIGN 
  batch_mode = SESSION:BATCH-MODE
  dbtype-l = ",ORACLE," + max_name_size
  l_sys-obj   = {prodict/ora/ora_sys.i} /* non-queryable objects */
              + ","
              + "oracle_arguments,oracle_columns,oracle_comment,"
              + "oracle_idxcols,oracle_indexes,oracle_objects,"
              + "oracle_procedures,oracle_sequences,oracle_users,"
              + "oracle_links,oracle_synonyms,oracle_views,"
              + "oracle_tablespace,oracle_constraint,oracle_cons,"
              + "oracle_cons_fld,oracle_procinfo".
  
IF NOT batch_mode
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


/*------------------------------------------------------------------*/
/*-----------------------------  VIEWS  ----------------------------*/
/*------------------------------------------------------------------*/

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


/*------------------------------------------------------------------*/
/*--------------------------- SEQUENCES ----------------------------*/
/*------------------------------------------------------------------*/

FOR EACH DICTDB2._Sequence
  where ( l_seqs = "**all**"
       or lookup(DICTDB2._Sequence._Seq-Name,l_seqs) <> 0
        ):

  oseqn = _Seq-Name + dbtype-l.
  
  RUN prodict/misc/_resxlat.p (INPUT-OUTPUT oseqn).
  /* check to see if ends in _seq then rememove q like wrktgen does */
  IF length(oseqn) > 3 AND lc(SUBSTRING(oseqn, (LENGTH(oseqn) - 3))) = "_seq" THEN
        ASSIGN oseqn = SUBSTRING(oseqn, 1, (LENGTH(oseqn) - 1)).

  IF batch_mode and logfile_open
   then put stream logfile unformatted 
      "Sequence " at 10 _Seq-Name at 25 skip.

  FIND DICTDB._Sequence WHERE  DICTDB._Sequence._DB-Recid = drec_db
                          AND    DICTDB._Sequence._Seq-name = oseqn NO-ERROR.
  IF NOT AVAILABLE DICTDB._Sequence THEN 
    FIND DICTDB._Sequence WHERE  DICTDB._Sequence._DB-Recid = drec_db
                          AND    DICTDB._Sequence._Seq-name = DICTDB2._Sequence._Seq-name NO-ERROR.

  IF NOT AVAILABLE DICTDB._Sequence THEN DO:
    CREATE DICTDB._Seq.
    ASSIGN DICTDB._Sequence._Db-recid = drec_db.
  END.

  ASSIGN
    DICTDB._Sequence._Seq-Name   = DICTDB2._Sequence._Seq-Name
    DICTDB._Sequence._Seq-Init   = DICTDB2._Sequence._Seq-Init
    DICTDB._Sequence._Seq-Incr   = DICTDB2._Sequence._Seq-Incr
    DICTDB._Sequence._Seq-Min    = DICTDB2._Sequence._Seq-Min
    DICTDB._Sequence._Seq-Max    = DICTDB2._Sequence._Seq-Max
    DICTDB._Sequence._Cycle-Ok   = DICTDB2._Sequence._Cycle-OK.

  END. /* each DICTDB2._Sequence */


/*------------------------------------------------------------------*/
/*----------------------------  FILES  -----------------------------*/
/*------------------------------------------------------------------*/

/* To avoid double dump-names we set them to ? for now, they will be
 * set to dictdb2._File._Dump-name lateron
 */
FOR EACH DICTDB._File  WHERE DICTDB._File._DB-recid = drec_db
                         AND DICTDB._File._Owner = "_FOREIGN" 
                         and   ( l_files = "**all**"
                                 or lookup(DICTDB._File._File-name,l_files) <> 0 ):
  ASSIGN DICTDB._File._Dump-name = ?.
END. /* each DICTDB2._File */

/* now adjust the file to match the original */
FOR EACH DICTDB2._File WHERE ( l_files = "**all**" or 
                               lookup(DICTDB2._File._File-name,l_files) <> 0)
                         AND DICTDB2._File._Owner = "PUB":

  IF _File-name BEGINS "_" OR
     _File-name BEGINS "oracle_" THEN NEXT.
  
  ASSIGN dbtype-l = ",ORACLE," + max_name_size.

  IF _for-name <> ? AND _for-name <> "" AND _for-name <> "n/a" THEN
    ASSIGN ofiln = _For-name.
  ELSE DO:  
    ofiln = _File-name + dbtype-l.
    RUN prodict/misc/_resxlat.p (INPUT-OUTPUT ofiln).
  END.

  _verify-table:
  DO WHILE TRUE:
    FIND verify-table WHERE verify-table.tnew-name = ofiln NO-ERROR.
    IF NOT AVAILABLE verify-table THEN DO:
      CREATE verify-table.
      ASSIGN verify-table.tnew-name = ofiln.
      LEAVE _verify-table.
    END.
    ELSE DO:
      DO a = 1 TO 999:
        ASSIGN ofiln = SUBSTRING(ofiln, 1, LENGTH(ofiln) - LENGTH(STRING(a))) + STRING(a).

        IF CAN-FIND(verify-table WHERE verify-table.tnew-name = ofiln) THEN NEXT.
        ELSE DO:
          CREATE verify-table.
          ASSIGN verify-table.tnew-name = ofiln.
          LEAVE _verify-table.
        END.
      END.
    END.    
  END.

  FIND DICTDB._File WHERE DICTDB._File._Db-Recid  = drec_db
                      AND DICTDB._File._File-name = ofiln
                      AND DICTDB._File._Owner = "_FOREIGN" NO-ERROR.

  IF NOT AVAILABLE DICTDB._File THEN NEXT.

  if batch_mode and logfile_open then 
      put stream logfile unformatted "Table " at 10 
                                 DICTDB2._File._File-name at 25 skip.


/*------------------------------------------------------------------*/
/*------------------------  FILE_TRIGGERS  -------------------------*/
/*------------------------------------------------------------------*/

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


/*------------------------------------------------------------------*/
/*---------------------------  FIELDS  -----------------------------*/
/*------------------------------------------------------------------*/

/*---------------  Inits to avoid Order-collisions  ----------------*/

  FOR EACH DICTDB._Field OF DICTDB._File:

    IF TERMINAL <> "" and not batch_mode THEN
      DISPLAY  DICTDB._File._File-name @ msg[1]
        DICTDB._Field._Field-name @ msg[2]
        "" @ msg[3] "" @ msg[4]
        WITH FRAME ora_fix.

    IF DICTDB._Field._For-Type = "TIME"
     THEN DELETE DICTDB._Field.
     ELSE ASSIGN DICTDB._Field._Order = DICTDB._Field._Order + 100000.

    END. /* each DICTDB._Field */

  /* Clear temp table for new file */
  FOR EACH verify-fname:
     DELETE verify-fname.
  END.

  assign l_max-order = 0.

  FOR EACH DICTDB2._Field OF DICTDB2._File:
    IF DICTDB2._Field._For-name <> ? AND DICTDB2._Field._For-name <> "" THEN
      ASSIGN ofldn = DICTDB2._Field._For-name.
    ELSE
      ASSIGN ofldn = DICTDB2._Field._Field-name.

    /*--------  Avoid collisions with unrolled extents  -------------*/

    ri = R-INDEX (ofldn, "#").    
    IF ri > 2 AND ri < LENGTH (ofldn,"character")
     THEN DO:  /* found an extent-indicator */
     
      IF INDEX ("0123456789", SUBSTR (ofldn, ri + 1, 1,"character")) > 0
       THEN DO:
        aofldn = SUBSTR (ofldn, 1, ri - 1,"character").
        IF CAN-FIND(DICTDB._Field OF DICTDB._File
              WHERE DICTDB._Field._Field-name = aofldn)
         THEN DO:
          OVERLAY (ofldn, ri, 1, "character") = "_".
          END.
        END.
        
      END.     /* found an extent-indicator */
    

    IF (DICTDB2._Field._Extent > 0) THEN
        /* Need to process extent fields diferently. We add extra characters to
           the columns when they are extents, so need to take that into account
           when calculating the max size for the field name:
           size =  maximum - 2 (for ##) - number of digits in the extent field 
        */
        ASSIGN temp_size = INTEGER(max_name_size) - 2 - LENGTH(STRING(DICTDB2._Field._Extent))
               temp_dbtype-1 = ",ORACLE," + TRIM(STRING(temp_size))
               ofldn = ofldn + temp_dbtype-1.
    ELSE
        ASSIGN ofldn = ofldn + dbtype-l.

    RUN prodict/misc/_resxlat.p (INPUT-OUTPUT ofldn).

    /* We have to do the same thing we do when running protoora.
       We need to keep track of the names we come up with, and
       find unique names if the one we just got now is duplicate.*/
    FIND FIRST verify-fname WHERE new-name = ofldn NO-ERROR.

    IF NOT AVAILABLE verify-fname THEN DO:
      CREATE verify-fname.
      ASSIGN verify-fname.new-name = ofldn.
    END.
    ELSE DO:
        DO a = 1 TO 999:
          ASSIGN ofldn = SUBSTRING(ofldn, 1, LENGTH(ofldn) - LENGTH(STRING(a))) + STRING(a).

          IF CAN-FIND(verify-fname WHERE verify-fname.new-name = ofldn) THEN 
              NEXT.
          ELSE DO:
            CREATE verify-fname.
            ASSIGN verify-fname.new-name = ofldn.
            LEAVE. /* get out of the a =1 to 999 loop */
          END.
        END.
    END.

    IF TERMINAL <> "" and not batch_mode THEN
      DISPLAY  DICTDB2._File._File-name @ msg[1]
        DICTDB2._Field._Field-name @ msg[2]
        "" @ msg[3] "" @ msg[4]
        WITH FRAME ora_fix.

/*-----------------------  Extent handling  ------------------------*/

    IF DICTDB2._Field._Extent > 0
     AND NOT CAN-FIND(DICTDB._Field OF DICTDB._File
                WHERE DICTDB._Field._Field-name = ofldn OR
                      DICTDB._Field._For-name = ofldn)
     THEN DO:  /* field with extent */

      aofldn = ofldn + "#".

      FIND a_DICTDB OF DICTDB._File
        WHERE a_DICTDB._Field-name = aofldn
        NO-ERROR.
      IF NOT AVAILABLE a_DICTDB THEN NEXT.

      m21 = a_DICTDB._For-Name.
      IF R-INDEX (m21, "#") > 3 THEN
        m21 = SUBSTR (m21, 1, R-INDEX(m21, "#") - 2,"character").

      CREATE DICTDB._Field.
      ASSIGN
        DICTDB._Field._File-recid    = RECID(DICTDB._File)
        DICTDB._Field._For-Name      = m21
        DICTDB._Field._Fld-stdtype   = a_DICTDB._Fld-stdtype
        DICTDB._Field._Fld-stoff     = a_DICTDB._Fld-stoff
        DICTDB._Field._Fld-misc2[8]  = a_DICTDB._Fld-misc2[8]

        DICTDB._Field._Field-name    = DICTDB2._Field._Field-name
        DICTDB._Field._Fld-case      = DICTDB2._Field._Fld-case
        DICTDB._Field._Data-type     = DICTDB2._Field._Data-type
        DICTDB._Field._Format        = DICTDB2._Field._Format
        DICTDB._Field._Initial       = DICTDB2._Field._Initial
        DICTDB._Field._Mandatory     = DICTDB2._Field._Mandatory
        DICTDB._Field._Decimals      = DICTDB2._Field._Decimals
        DICTDB._Field._Order         = DICTDB2._Field._Order
        DICTDB._Field._Desc          = DICTDB2._Field._Desc
        DICTDB._Field._Can-Read      = DICTDB2._Field._Can-Read
        DICTDB._Field._Can-Write     = DICTDB2._Field._Can-Write
        DICTDB._Field._Label         = DICTDB2._Field._Label
        DICTDB._Field._Col-label     = DICTDB2._Field._Col-label
        DICTDB._Field._Valexp        = DICTDB2._Field._Valexp
        DICTDB._Field._Valmsg        = DICTDB2._Field._Valmsg
        DICTDB._Field._Help          = DICTDB2._Field._Help
        DICTDB._Field._Col-label-sa  = DICTDB2._Field._Col-label-sa
        DICTDB._Field._Format-sa     = DICTDB2._Field._Format-sa
        DICTDB._Field._Help-sa       = DICTDB2._Field._Help-sa
        DICTDB._Field._Initial-sa    = DICTDB2._Field._Initial-sa
        DICTDB._Field._Label-sa      = DICTDB2._Field._Label-sa
        DICTDB._Field._Valmsg-sa     = DICTDB2._Field._Valmsg-sa
        DICTDB._Field._For-Id        = a_DICTDB._For-Id
        DICTDB._Field._For-Primary   = a_DICTDB._For-Primary
        DICTDB._Field._For-Spacing   = a_DICTDB._For-Spacing
        DICTDB._Field._For-Scale     = a_DICTDB._For-Scale
        DICTDB._Field._For-Type      = a_DICTDB._For-Type
        DICTDB._Field._For-Itype     = a_DICTDB._For-Itype
        DICTDB._Field._For-Xpos      = a_DICTDB._For-Xpos
        DICTDB._Field._For-Retrieve  = a_DICTDB._For-Retrieve
        DICTDB._Field._For-Separator = a_DICTDB._For-Separator
        DICTDB._Field._For-Maxsize   = a_DICTDB._For-Maxsize
        DICTDB._Field._For-Allocated = a_DICTDB._For-Allocated
        DICTDB._Field._View-As       = DICTDB2._Field._View-As
        DICTDB._Field._Extent        = DICTDB2._Field._Extent
        l_max-order                  = MAX(l_max-order
                                          ,DICTDB._Field._Order).
      
     /*
      * OE00218270 : Commented out to remove RECID mapping to Oracle integer.
      * RECID now mapped directly to NUMBER from _ora_typ.p map list.
      IF DICTDB._Field._Data-type = "RECID"
       THEN DICTDB._Field._Data-type = "INTEGER".
      */

      DO cext = 1 TO DICTDB._Field._Extent:
        aofldn = ofldn + "#" + STRING (cext).
        FIND a_DICTDB OF DICTDB._File
          WHERE a_DICTDB._Field-name = aofldn
          NO-ERROR.
        IF AVAILABLE a_DICTDB
         THEN DELETE a_DICTDB.
        END. /* DICTDB._Field._Extent > 1 DO cext = 1 TO ... */

      END.     /* field with extent */

     ELSE DO:  /* field without extent */

      /* if the user already ran the adjust schema option previously, and
         the field name containe a character that was modified when pushed
         to the Oracle database, we won't find a record with the _Field-name.
         Need to look at the _For-name as well, otherwise the fields in this
         table will have the wrong _order values.
      */

      FIND DICTDB._Field OF DICTDB._File
        WHERE DICTDB._Field._Field-name = ofldn OR 
              DICTDB._Field._For-name = ofldn NO-ERROR.

      IF DICTDB2._Field._For-name MATCHES ".*##1"
       AND NOT AVAILABLE DICTDB._Field
       THEN DO:
        /* If DICTDB2 is really a pre 6.3c schema holder, use the #1 _Field */
        /* to set-up the array's _Field record. */
        FIND DICTDB._Field OF DICTDB._File
          WHERE DICTDB._Field._Field-name = SUBSTR
                      (DICTDB2._Field._For-name
                      ,1
                      ,LENGTH (DICTDB2._Field._For-name,"character") - 3
                      ,"character") NO-ERROR.
        END.

      IF NOT AVAILABLE DICTDB._Field THEN NEXT.
      
      END.     /* field without extent */

/*---------------------  Adjust Field itself  ----------------------*/

    ASSIGN
      DICTDB._Field._Field-name    = DICTDB2._Field._Field-name
      DICTDB._Field._Fld-case      = DICTDB2._Field._Fld-case
      DICTDB._Field._Data-type     = DICTDB2._Field._Data-type
      DICTDB._Field._Format        = DICTDB2._Field._Format
      DICTDB._Field._Initial       = DICTDB2._Field._Initial
      DICTDB._Field._Mandatory     = DICTDB2._Field._Mandatory
      DICTDB._Field._Decimals      = DICTDB2._Field._Decimals
      DICTDB._Field._Order         = DICTDB2._Field._Order
      DICTDB._Field._Desc          = DICTDB2._Field._Desc
      DICTDB._Field._Can-Read      = DICTDB2._Field._Can-Read
      DICTDB._Field._Can-Write     = DICTDB2._Field._Can-Write
      DICTDB._Field._Label         = DICTDB2._Field._Label
      DICTDB._Field._Col-label     = DICTDB2._Field._Col-label
      DICTDB._Field._Valexp        = DICTDB2._Field._Valexp
      DICTDB._Field._Valmsg        = DICTDB2._Field._Valmsg
      DICTDB._Field._Col-label-sa  = DICTDB2._Field._Col-label-sa
      DICTDB._Field._Format-sa     = DICTDB2._Field._Format-sa
      DICTDB._Field._Help-sa       = DICTDB2._Field._Help-sa
      DICTDB._Field._Initial-sa    = DICTDB2._Field._Initial-sa
      DICTDB._Field._Label-sa      = DICTDB2._Field._Label-sa
      DICTDB._Field._Valmsg-sa     = DICTDB2._Field._Valmsg-sa      
      DICTDB._Field._View-As       = DICTDB2._Field._View-As
      DICTDB._Field._Help          = DICTDB2._Field._Help
      l_max-order                  = MAX(l_max-order,DICTDB._Field._Order).

     /*
      * OE00218270 : Commented out to remove RECID mapping to Oracle integer.
      * RECID now mapped directly to NUMBER from _ora_typ.p map list.
      IF DICTDB._Field._Data-type = "RECID"
       THEN DICTDB._Field._Data-type = "INTEGER".
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
  
/*----------------------  Reset Field-Order  -----------------------*/

for each DICTDB._Field of DICTDB._File where DICTDB._Field._Order > 100000:
  ASSIGN l_max-order          = l_max-order + 10
         DICTDB._Field._Order = l_max-order.
end.


/*------------------------------------------------------------------*/
/*---------------------------  INDEXES  ----------------------------*/
/*------------------------------------------------------------------*/
 
/* Find greatest index number if we need to add another index */
  assign l_idx-num = 0.
  for each DICTDB._Index of DICTDB._File:
    if l_idx-num < DICTDB._Index._idx-num
     then assign l_idx-num = DICTDB._Index._idx-num.
  END.

  ASSIGN dbtype-l = ",ORACLE,30".

  _idxloop:
  FOR EACH DICTDB2._Index OF DICTDB2._File:
    IF DICTDB2._Index._Wordidx = 1  OR DICTDB2._Index._Index-name = "default"
       THEN NEXT _idxloop.

    ASSIGN oidxn = DICTDB2._Index._Index-Name + dbtype-l.

    IF TERMINAL <> "" and not batch_mode THEN
      DISPLAY  DICTDB2._File._File-name @ msg[1] "" @ msg[2]
         DICTDB2._Index._Index-Name @ msg[3] "" @ msg[4]
        WITH FRAME ora_fix.

    RUN prodict/misc/_resxlat.p (INPUT-OUTPUT oidxn).
   
    IF batch_mode and logfile_open
     THEN put stream logfile unformatted 
       "Index" at 10 DICTDB2._Index._Index-name at 25 skip.


/*---------------------  Adjust Index itself  ----------------------*/

    FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-Name = oidxn
      NO-ERROR.
    IF NOT AVAILABLE DICTDB._Index THEN
      FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._For-Name = CAPS(oidxn)
      NO-ERROR.
    IF NOT AVAILABLE DICTDB._Index THEN
      FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-name = DICTDB2._index._Index-name NO-ERROR.

&SCOPED-DEFINE  MAX_IDX_LEN 30
&SCOPED-DEFINE  UNIK  "##"       /* adjust LEN_UNIK if this changes */
&SCOPED-DEFINE  LEN_UNIK      2

    IF NOT AVAILABLE DICTDB._Index THEN DO:
        /* upon migration, we may have trimmed some characters off of the index name if the index name was too big
           or if it conflicted with another index name generated (in case table and index name were trimmed to the same
           string). Therefore, we are going to try to do the same thing here to emulate what was done upon migration: try to generate
           the name of the foreign index with the info we have and try to find the index in the schema holder.
           This still may not find it if we had to again trim characters off of the generated foreign name to resolve duplicate names, so
           we will trim one character at a time and check if we can find the index that way.
        */
        IF LENGTH(ofiln) + LENGTH(oidxn) +  {&LEN_UNIK} > {&MAX_IDX_LEN} THEN DO:
            IF LENGTH(oidxn) + 2 <  {&MAX_IDX_LEN} THEN  /* easy way */
                ASSIGN oidxn = SUBSTRING(ofiln,1,  {&MAX_IDX_LEN} - LENGTH(oidxn) -  {&LEN_UNIK}) + {&UNIK} + oidxn.
            ELSE DO:  /* Then, we have to knock some chars off of oidxn as well */
              
                REPEAT:
                  oidxn =  SUBSTRING (oidxn,1, LENGTH(oidxn) - 1).       
                  IF LENGTH(oidxn) +  {&LEN_UNIK} <  {&MAX_IDX_LEN} THEN
                  LEAVE.   /* This is what we want */
                END.  

                ASSIGN oidxn = SUBSTRING(ofiln,1, {&MAX_IDX_LEN} - LENGTH(oidxn) - {&LEN_UNIK}) +  {&UNIK} + oidxn.
            END.
        END.  
        ELSE  /*string is okay */
              ASSIGN oidxn = ofiln +  {&UNIK} + oidxn. 
        
        /* _Index._For-name is case-sensitive, so get characters in uppercase */
        ASSIGN oidxn = CAPS(oidxn)
                     cid = oidxn.
        
        /* we will start with the name we have now, and then trim 1 character at a time and see if we can find it */
        REPEAT temp_size = (LENGTH(oidxn) - 1) TO 0 BY -1:

             FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._For-Name = cid NO-ERROR.
             
             IF AVAILABLE DICTDB._Index THEN  DO:
                 ASSIGN oidxn = cid.
                 LEAVE.
             END. 
             /* trim one character */
             IF temp_size = 0 THEN
                 LEAVE.

             ASSIGN cid = SUBSTRING(oidxn, 1, temp_size).
       END.
    
    END.   /* not available _Index */

    IF NOT AVAILABLE DICTDB._Index THEN DO:  /* NOT AVAILABLE DICTDB._Index and not a word index */     
      CREATE DICTDB._Index.
      ASSIGN
        l_idx-num                   = l_idx-num + 1
        DICTDB._Index._File-recid   = RECID (DICTDB._File)
        DICTDB._Index._Wordidx      = DICTDB2._Index._Wordidx
        DICTDB._Index._Desc         = DICTDB2._Index._Desc
        DICTDB._Index._For-Name     = CAPS(oidxn)
        DICTDB._Index._For-type     = DICTDB2._Index._For-type
        DICTDB._Index._Index-name   = DICTDB2._Index._Index-Name
        DICTDB._Index._Active       = DICTDB2._Index._Active
        DICTDB._Index._idx-num      = l_idx-num
        DICTDB._Index._Unique       = DICTDB2._Index._Unique.
    END.     /* NOT AVAILABLE DICTDB._Index */
   
    ASSIGN DICTDB._Index._Desc       = DICTDB2._Index._Desc
           DICTDB._Index._Index-name = DICTDB2._Index._Index-name.
      
    IF DICTDB._Index._Unique <> DICTDB2._Index._Unique THEN
        ASSIGN DICTDB._Index._Unique       = DICTDB2._Index._Unique.

/*-------------------------  Index-Fields  -------------------------*/

    FOR EACH DICTDB2._Index-field OF DICTDB2._Index:

      FIND DICTDB2._Field WHERE RECID (DICTDB2._Field) = 
        DICTDB2._Index-field._Field-recid NO-ERROR.
        
      IF NOT AVAILABLE DICTDB2._Field OR DICTDB2._Index._Index-name = "default" 
          THEN NEXT.      

      IF TERMINAL <> "" and not batch_mode THEN
        DISPLAY  DICTDB2._File._File-name @ msg[1] "" @ msg[2]
          DICTDB2._Index._Index-Name @ msg[3]
          DICTDB2._Field._Field-name @ msg[4]
          WITH FRAME ora_fix.

      ofldn = DICTDB2._Field._Field-name.

      FIND DICTDB._Field WHERE DICTDB._Field._File-recid = RECID (DICTDB._File) 
                           AND DICTDB._Field._Field-name = ofldn NO-ERROR.
      
      IF NOT AVAILABLE DICTDB._Field THEN NEXT.

      FIND DICTDB._Index-field OF DICTDB._Index
        WHERE DICTDB._Index-field._Index-seq = DICTDB2._Index-field._Index-seq
        NO-ERROR.
      IF NOT AVAILABLE DICTDB._Index-field THEN DO:
          CREATE DICTDB._Index-field.
          ASSIGN
            DICTDB._Index-field._Index-recid = RECID (DICTDB._Index)
            DICTDB._Index-field._Field-recid = RECID (DICTDB._Field)
            DICTDB._Index-field._Index-seq   = DICTDB2._Index-field._Index-seq
            DICTDB._Index-field._Ascending   = DICTDB2._Index-field._Ascending
            DICTDB._Index-field._Abbreviate  = DICTDB2._Index-field._Abbreviate
            DICTDB._Index-field._Unsorted    = DICTDB2._Index-field._Unsorted.

      END. /* NOT avaiable DICTDB._Index-field */
      ELSE 
        ASSIGN
          DICTDB._Index-field._Ascending   = DICTDB2._Index-field._Ascending
          DICTDB._Index-field._Abbreviate  = DICTDB2._Index-field._Abbreviate.
         /* avaiable DICTDB._Index-field */

    END. /* each DICTDB2._Index-field */
  END. /* each DICTDB2._Index OF DICTDB2._File */


/*--------  Remove any extra indexes from the schema holder  -------*/
  _rmvidx:
  FOR EACH DICTDB._Index OF DICTDB._File:
    oidxn = DICTDB._Index._Index-Name.
    IF oidxn = "default_" THEN NEXT.   

    IF TERMINAL <> "" and not batch_mode THEN
      DISPLAY  DICTDB._File._File-name @ msg[1] "" @ msg[2]
         DICTDB._Index._Index-Name @ msg[3] "" @ msg[4]
        WITH FRAME Ora_fix.

    FIND DICTDB2._Index OF DICTDB2._File
      WHERE  DICTDB2._Index._Index-Name = DICTDB._Index._Index-Name NO-ERROR.
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

    FOR EACH DICTDB._Index-field OF DICTDB._Index:
      DELETE DICTDB._Index-field.
    END. /* DICTDB._Index-field OF DICTDB._Index */

    DELETE DICTDB._Index.

  END. /* DICTDB._Index OF DICTDB._File */


/*---------------------  Set the primary index  --------------------*/

  FIND DICTDB._Index WHERE RECID(DICTDB._Index) = DICTDB._File._Prime-Index
    NO-ERROR.
  IF AVAILABLE DICTDB._Index THEN
    opi = DICTDB._Index._Index-Name.
  ELSE
    opi = ?.

  FIND DICTDB2._Index WHERE RECID(DICTDB2._Index) = DICTDB2._File._Prime-Index
    NO-ERROR.
  IF AVAILABLE DICTDB2._Index THEN
    ppi = DICTDB2._Index._Index-Name.
  ELSE
    ppi = ?.

  IF opi <> ppi AND ppi <> ? THEN DO:
    FIND DICTDB._Index OF DICTDB._File WHERE
      DICTDB._Index._Index-Name = ppi NO-ERROR.
    IF AVAILABLE DICTDB._Index THEN DO:
      DICTDB._File._Prime-Index                = RECID(DICTDB._Index).
      END. /* AVAILABLE DICTDB._Index */
    END. /* opi <> ppi AND ppi <> ? */

/*------------------------------------------------------------------*/
/*------------------------  CONSTRAINTS    -------------------------*/
/*------------------------------------------------------------------*/

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
    IF (DICTDB2._Constraint._Con-Type = "M" OR DICTDB2._Constraint._Con-Type = "D")   
       THEN NEXT _con-loop.

        IF (DICTDB2._Constraint._Con-Type = "C")
        THEN DO:
          FIND FIRST DICTDB2._Field OF DICTDB2._File WHERE RECID(DICTDB2._Field) = DICTDB2._Constraint._Field-Recid NO-LOCK NO-ERROR.
          FIND FIRST DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Field-Name = DICTDB2._Field._Field-Name NO-LOCK NO-ERROR.
          ASSIGN con-fld_recid = RECID (DICTDB._Field).
        END.   
        
        IF (DICTDB2._Constraint._Con-Type = "F" OR DICTDB2._Constraint._Con-Type = "U" OR DICTDB2._Constraint._Con-Type = "PC" 
              OR DICTDB2._Constraint._Con-Type = "P" OR DICTDB2._Constraint._Con-Type = "MP")
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
        
        IF (DICTDB2._Constraint._Con-Type = "C")
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
  
  _rmcon:
  FOR EACH DICTDB._constraint OF DICTDB._File:
   FIND FIRST DICTDB2._Constraint WHERE DICTDB2._Constraint._Con-Name = DICTDB._Constraint._Con-Name NO-LOCK NO-ERROR.
   IF NOT AVAILABLE (DICTDB2._Constraint)
   THEN do:
      DELETE DICTDB._Constraint.
   END.
  END.
END. /* migrate constraints*/  


/*----------------------  Adjust File itself  ----------------------*/

  IF TERMINAL <> "" and not batch_mode THEN
    DISPLAY DICTDB2._File._File-name @ msg[1] "" @ msg[2] "" @ msg[3] 
      "" @ msg[4]
      WITH FRAME ora_fix.

  /* Do this last since it may set _File._Frozen. */


  ASSIGN
    DICTDB._File._File-name       = DICTDB2._File._File-name
    DICTDB._File._Can-Create      = DICTDB2._File._Can-Create
    DICTDB._File._Can-Read        = DICTDB2._File._Can-Read
    DICTDB._File._Can-Write       = DICTDB2._File._Can-Write
    DICTDB._File._Can-Delete      = DICTDB2._File._Can-Delete
    DICTDB._File._Desc            = DICTDB2._File._Desc
    DICTDB._File._Valexp          = DICTDB2._File._Valexp
    DICTDB._File._Valmsg          = DICTDB2._File._Valmsg
    DICTDB._File._For-Size        = DICTDB2._File._For-Size
    DICTDB._File._For-Flag        = DICTDB2._File._For-Flag
    DICTDB._File._For-Cnt1        = DICTDB2._File._For-Cnt1
    DICTDB._File._For-Cnt2        = DICTDB2._File._For-Cnt2
    DICTDB._File._For-Format      = DICTDB2._File._For-Format
    DICTDB._File._For-Info        = DICTDB2._File._For-Info
    DICTDB._File._For-Id          = DICTDB2._File._For-ID
    DICTDB._File._For-Number      = DICTDB2._File._For-Number
    DICTDB._File._File-Label      = DICTDB2._File._File-Label
    DICTDB._File._File-Label-sa   = DICTDB2._File._File-Label-sa
    DICTDB._File._Valmsg-sa       = DICTDB2._File._Valmsg-sa
    DICTDB._File._Dump-name       = DICTDB2._File._Dump-name
    DICTDB._File._Frozen          = DICTDB2._File._Frozen.

  END. /* each DICTDB2._File */

/* Now check DICTDB._File to make sure we get only those we pushed 
   if running from protoora or all objects being compared */
IF del-cycle THEN DO:
  FOR EACH DICTDB._File WHERE DICTDB._File._Owner = "_FOREIGN":
    IF DICTDB._File._For-type <> "TABLE" THEN NEXT.
    IF LOOKUP(DICTDB._FILE._File-name,l_sys-obj) = 0 THEN DO:
      FIND DICTDB2._File WHERE DICTDB2._File._File-name = DICTDB._File._File-name 
                           AND DICTDB2._File._Owner = "PUB" NO-ERROR.
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
  END.  
  FOR EACH DICTDB._Sequence:
    FIND DICTDB2._Sequence WHERE DICTDB2._Sequence._Seq-name = DICTDB._Sequence._Seq-name NO-ERROR.
    IF NOT AVAILABLE DICTDB2._Sequence THEN
       DELETE DICTDB._Sequence.
  END.    
END.

IF not batch_mode THEN 
    HIDE FRAME ora_fix NO-PAUSE.

RETURN.
