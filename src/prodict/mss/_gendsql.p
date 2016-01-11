/*********************************************************************
* Copyright (C) 2008 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Procedure: prodict/mss/_gendsql.p

     Created: Donna L. McMann
              12/03/02
              
              Creates an incremental sql script to be loaded into MS SQL Server
              and an incremental df to be loaded into the MSS Schema holder
              
     History: 20030805-021 Added logic for duplicate field names
              20030805-026 Added output of QUALIFIER and RECID-FLD-NAME in df.
                           Quoted name was missing for new fields.
              20030807-011 Duplicate index names, foreign position and adding/dropping
                           field with same name
              20031007-008 10/10/03 Added logic for multiple extents at end of file for foreign position
              Added CAPS for case insensitive search for _file _index for name
              02/08/05    Added support for turning on/off x(8) override to x(30) - depending on
                          value stored in sqlwidth 
              04/17/06  fernando Unicode support
              06/12/06  fernando Added support for int64
              07/19/06  fernando Unicode support - support only MSS 2005    
              10/13/06  fernando Fix qualifier name if not the same as DSN - 20061005-002   
                                 Add dsrv-precision to new char fields - 20061005-003       
              01/28/08 fernando  Fix foreign attributes for logical field. Made foreign-owner and
                                 foreign-name lowercase - OE00164229
*/              
{ prodict/user/uservar.i }
{ prodict/mss/mssvar.i }

DEFINE VARIABLE iarg          AS CHARACTER             NO-UNDO. 
DEFINE VARIABLE ikwd          AS CHARACTER             NO-UNDO. 
DEFINE VARIABLE imod          AS CHARACTER             NO-UNDO. 
DEFINE VARIABLE ipos          AS INTEGER               NO-UNDO. 
DEFINE VARIABLE ilin          AS CHARACTER EXTENT 256  NO-UNDO.
DEFINE VARIABLE a             AS INTEGER               NO-UNDO.
DEFINE VARIABLE i             AS INTEGER               NO-UNDO.
DEFINE VARIABLE j             AS INTEGER               NO-UNDO.
DEFINE VARIABLE k             AS INTEGER               NO-UNDO.
DEFINE VARIABLE u             AS INTEGER               NO-UNDO.
DEFINE VARIABLE z             AS INTEGER               NO-UNDO.
DEFINE VARIABLE iobj          AS CHARACTER             NO-UNDO. /* d,t,f,i */
DEFINE VARIABLE inot          AS LOGICAL               NO-UNDO.
DEFINE VARIABLE inum          AS INTEGER               NO-UNDO.
DEFINE VARIABLE all_digits    AS INTEGER               NO-UNDO. 
DEFINE VARIABLE dec_point     AS INTEGER               NO-UNDO. 
DEFINE VARIABLE pos           AS INTEGER               NO-UNDO.
DEFINE VARIABLE idx-number    AS INTEGER               NO-UNDO.
DEFINE VARIABLE lvar          AS CHARACTER EXTENT 10   NO-UNDO.
DEFINE VARIABLE lvar#         AS INTEGER               NO-UNDO.
DEFINE VARIABLE sqlout        AS CHARACTER             NO-UNDO.
DEFINE VARIABLE dfout         AS CHARACTER             NO-UNDO.
DEFINE VARIABLE startdf       AS LOGICAL INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE addtable      AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE alt-table     AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE tablename     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE forname       AS CHARACTER             NO-UNDO.
DEFINE VARIABLE fortype       AS CHARACTER             NO-UNDO.
DEFINE VARIABLE dffortype     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE fieldname     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE fieldtype     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE idbtyp        AS CHARACTER             NO-UNDO.
DEFINE VARIABLE xlate         AS LOGICAL               NO-UNDO.
DEFINE VARIABLE nbrchar       AS INTEGER               NO-UNDO.
DEFINE VARIABLE lngth         AS INTEGER               NO-UNDO.
DEFINE VARIABLE left_paren    AS INTEGER               NO-UNDO.
DEFINE VARIABLE right_paren   AS INTEGER               NO-UNDO.
DEFINE VARIABLE lnum          AS INTEGER               NO-UNDO.
DEFINE VARIABLE endline       AS CHARACTER             NO-UNDO.
DEFINE VARIABLE idxline       AS CHARACTER  INITIAL ?  NO-UNDO.
DEFINE VARIABLE idxname       AS CHARACTER             NO-UNDO.
DEFINE VARIABLE wordidx       AS LOGICAL               NO-UNDO.
DEFINE VARIABLE wordfile      AS CHARACTER             NO-UNDO.
DEFINE VARIABLE shw-fld       AS LOGICAL               NO-UNDO.
DEFINE VARIABLE p-r-index     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE seqname       AS CHARACTER INITIAL ?   NO-UNDO.
DEFINE VARIABLE seq-type      AS CHARACTER             NO-UNDO.
DEFINE VARIABLE seq-line      AS CHARACTER INITIAL ?   NO-UNDO.
DEFINE VARIABLE init          AS CHARACTER             NO-UNDO.
DEFINE VARIABLE incre         AS CHARACTER             NO-UNDO.
DEFINE VARIABLE cyc           AS CHARACTER             NO-UNDO.
DEFINE VARIABLE minval        AS CHARACTER             NO-UNDO.
DEFINE VARIABLE maxval        AS CHARACTER             NO-UNDO INIT ?.
DEFINE VARIABLE dbrecid       AS RECID                 NO-UNDO.
DEFINE VARIABLE fldnum        AS INTEGER               NO-UNDO.
DEFINE VARIABLE shw-col       AS INTEGER               NO-UNDO.
DEFINE VARIABLE df-idx        AS CHARACTER EXTENT 6    NO-UNDO.
DEFINE VARIABLE is-unique     AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE new-ord       AS INTEGER INITIAL 1     NO-UNDO.
DEFINE VARIABLE dropped-fld   AS LOGICAL               NO-UNDO.
DEFINE VARIABLE transname     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE dupfield      AS LOGICAL               NO-UNDO.
DEFINE VARIABLE oq-string     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE minwidth      AS INTEGER               NO-UNDO.
DEFINE VARIABLE dfseq         AS INTEGER INITIAL 1     NO-UNDO.
DEFINE VARIABLE for-init      AS CHARACTER             NO-UNDO.
DEFINE VARIABLE comment_chars AS CHARACTER             NO-UNDO.
DEFINE VARIABLE col-text      AS INTEGER               NO-UNDO.
DEFINE VARIABLE comment-out   AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE extline       AS CHARACTER             NO-UNDO.
DEFINE VARIABLE extlinenum    AS INTEGER               NO-UNDO.
DEFINE VARIABLE newstoff      AS INTEGER               NO-UNDO.
DEFINE VARIABLE efile         AS CHARACTER             NO-UNDO.
DEFINE VARIABLE rntbl         AS CHARACTER             NO-UNDO.
DEFINE VARIABLE recididx      AS CHARACTER             NO-UNDO.
DEFINE VARIABLE trigname      AS CHARACTER             NO-UNDO.
DEFINE VARIABLE varlngth      AS INTEGER               NO-UNDO.
DEFINE VARIABLE recidident    AS CHARACTER             NO-UNDO.
DEFINE VARIABLE dftname       AS CHARACTER             NO-UNDO.
DEFINE VARIABLE unsptdt       AS LOGICAL               NO-UNDO.
DEFINE VARIABLE qualname      AS CHARACTER             NO-UNDO.
DEFINE VARIABLE large_seq     AS LOGICAL               NO-UNDO.

DEFINE TEMP-TABLE df-info NO-UNDO
    FIELD df-seq  AS INTEGER
    FIELD df-line AS CHARACTER
    FIELD df-tbl  AS CHARACTER
    FIELD df-fld  AS CHARACTER
    INDEX rt-line IS PRIMARY df-seq.

DEFINE TEMP-TABLE sql-info NO-UNDO
  FIELD line-num AS INTEGER
  FIELD line     AS CHARACTER
  FIELD tblname  AS CHARACTER
  FIELD fldname  AS CHARACTER
  INDEX tbl-line IS PRIMARY tblname line-num ASCENDING
  INDEX fname tblname fldname. 
  
DEFINE TEMP-TABLE new-obj NO-UNDO
  FIELD add-type AS CHARACTER
  FIELD tbl-name AS CHARACTER
  FIELD fld-name AS CHARACTER
  FIELD for-name AS CHARACTER
  FIELD for-type AS CHARACTER
  FIELD prg-name AS CHARACTER
  FIELD n-order  AS INTEGER
  FIELD mand     AS LOGICAL
  INDEX add-rec IS PRIMARY add-type tbl-name n-order prg-name.

DEFINE TEMP-TABLE rename-obj NO-UNDO
  FIELD rename-type AS CHARACTER
  FIELD t-name      AS CHARACTER
  FIELD old-name    AS CHARACTER
  FIELD new-name    AS CHARACTER
  FIELD dsv-name    AS CHARACTER.

DEFINE TEMP-TABLE drop-field NO-UNDO
  FIELD f-name      AS CHARACTER
  FIELD of-table    AS CHARACTER
  FIELD drop-f-name AS CHARACTER.  

DEFINE TEMP-TABLE new-position NO-UNDO
  FIELD table-np    AS CHARACTER
  FIELD old-pos     AS INTEGER
  FIELD new-pos     AS INTEGER
  FIELD extent#     AS INTEGER
  FIELD shadow      AS INTEGER
  FIELD field-np    AS CHARACTER
  FIELD dropped     AS LOGICAL INITIAL FALSE
  INDEX fld-pos IS PRIMARY table-np old-pos.

DEFINE TEMP-TABLE alt-info NO-UNDO
  FIELD a-line-num AS INTEGER
  FIELD a-line     AS CHARACTER
  FIELD a-tblname  AS CHARACTER
  FIELD a-fldname  AS CHARACTER
  INDEX tbl-line IS PRIMARY a-tblname a-line-num ASCENDING
  INDEX fname a-tblname a-fldname. 
  
DEFINE TEMP-TABLE shad-col NO-UNDO
  FIELD s-fld-name AS CHARACTER
  FIELD s-tbl-name AS CHARACTER
  FIELD p-fld-name AS CHARACTER
  FIELD col-num    AS INTEGER.
    
DEFINE TEMP-TABLE verify-table NO-UNDO
  FIELD tnew-name LIKE _File._File-name
  INDEX trun-name IS UNIQUE tnew-name.

DEFINE TEMP-TABLE verify-field NO-UNDO
  FIELD f-table   LIKE _file._File-name
  FIELD fnew-name LIKE _field._Field-name
  INDEX frun-name IS UNIQUE f-table fnew-name.
  
DEFINE TEMP-TABLE verify-index NO-UNDO
  FIELD inew-name LIKE _index._index-name
  INDEX trun-name IS UNIQUE inew-name.  

DEFINE TEMP-TABLE warntext NO-UNDO
   FIELD wname AS CHARACTER
   INDEX wnamel wname.

DEFINE BUFFER n-obj FOR new-obj.
    
DEFINE STREAM todf.
DEFINE STREAM tosql.

FORM
  SKIP(1)
  tablename LABEL "Working on" FORMAT "x(32)" AT 3
  SKIP(1)
  WITH FRAME working 
  WIDTH 58 SIDE-LABELS ROW 5 CENTERED &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX THREE-D &ENDIF TITLE "Generate Scripts" .

    
/* Internal Procedure */
PROCEDURE write-tbl-sql:     
  DEFINE VARIABLE dftblname   AS CHARACTER                   NO-UNDO.
  DEFINE VARIABLE forpos      AS INTEGER                     NO-UNDO.
  DEFINE VARIABLE extnt       AS LOGICAL                     NO-UNDO.
  DEFINE VARIABLE recidname   AS CHARACTER                   NO-UNDO.
  DEFINE VARIABLE recidpos    AS INTEGER                     NO-UNDO.

  ASSIGN col-text = 0
         comment_chars = ""
         comment-out = FALSE
         unsptdt = FALSE.

  FIND DICTDB._File WHERE DICTDB._File._File-name = tablename
                      AND DICTDB._File._Owner = "_FOREIGN"
                      NO-ERROR.   

  IF AVAILABLE DICTDB._File  THEN DO:
    FOR EACH new-obj WHERE add-type = "F"
                       AND tbl-name = tablename:  
      IF new-obj.for-type = " UNSUPPORTED" THEN
        ASSIGN unsptdt = TRUE.
    END.
  END.
  ELSE DO:
    FIND FIRST new-obj WHERE add-type = "T"
                         AND tbl-name = tablename
                          NO-ERROR.
   FOR EACH new-obj WHERE add-type = "F"
                       AND tbl-name = tablename:  
      IF new-obj.for-type = " UNSUPPORTED" THEN
        ASSIGN unsptdt = TRUE.
      END.
  END.
  IF unsptdt THEN DO:
    ASSIGN comment_chars = "-- ** "
           comment-out = TRUE.
    
    ASSIGN efile = tablename + ".e".
    OUTPUT TO VALUE(efile) APPEND.
    PUT UNFORMATTED tablename " had columns with unsupported data types." SKIP
                   "The sql was commented out and no information was" SKIP
                    "outputed to the {&PRO_DISPLAY_NAME} DF File." SKIP
                    " " SKIP.
    OUTPUT CLOSE.      
  END.
  IF dropped-fld THEN
      RUN new-for-position.

  FOR EACH sql-info BREAK BY tblname BY line-num:  
    IF FIRST-OF(tblname) THEN DO:
      IF pcompatible THEN DO:
        FIND FIRST new-obj WHERE add-type = "T"
                             AND tbl-name = tblname
                             NO-ERROR.
        IF AVAILABLE new-obj THEN DO:
          ASSIGN p-r-index = for-name.
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-tbl = tblname
                 df-line = 'UPDATE TABLE "' + tblname + '"'.
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-tbl = tblname
                 df-line = "  PROGRESS-RECID " + string(fldnum + 1).
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-tbl = tblname
                 df-line = '  HIDDEN-FLDS "' + string(fldnum + 2) + ',"'.
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-tbl = tblname
                 df-line = '  QUALIFIER "' + qualname + '"'.
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-tbl = tblname
                 df-line = '  RECID-FLD-NAME "PROGRESS_RECID"'.
        END.
      END.
      ELSE DO:
        FIND FIRST new-obj WHERE add-type = "T"
                             AND tbl-name = tblname
                             NO-ERROR.
        IF AVAILABLE new-obj THEN DO:
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-tbl = tblname
                 df-line = 'UPDATE TABLE "' + tblname + '"'.
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-tbl = tblname
                 df-line = '  QUALIFIER "' + qualname + '"'.
        END.
      END.

      FIND DICTDB._File WHERE DICTDB._File._File-name = tblname
                          AND DICTDB._File._Owner = "_FOREIGN"
                          NO-ERROR.   
      FIND FIRST new-obj WHERE add-type = "T"
                             AND tbl-name = tblname
                             NO-ERROR.

      IF AVAILABLE DICTDB._File AND NOT AVAILABLE new-obj THEN DO: /* adding new fields to file not dropping it */     
        /* If progress-recid not a specific field but one the user has selected. */
        IF DICTDB._File._fil-misc1[1] < 0  THEN DO:
          FIND DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Fld-stoff = (DICTDB._File._Fil-misc1[1] * -1)
               NO-ERROR.
          IF AVAILABLE DICTDB._Field THEN     
            ASSIGN recidname = DICTDB._Field._Field-name.
        END.
        ELSE 
          ASSIGN recidname = "progress_recid"
                 recidident = "progress_recid_ident_".             
        
        ASSIGN forpos = 1
               extnt = FALSE.

        FOR EACH DICTDB._field OF DICTDB._file BREAK BY _File-recid BY _fld-stoff: 
          IF forpos < DICTDB._field._fld-stoff THEN 
            ASSIGN forpos = DICTDB._field._fld-stoff.
          IF DICTDB._Field._Fld-Misc1[5] > forpos THEN
            ASSIGN forpos = DICTDB._Field._Fld-Misc1[5].
          IF LAST-OF(_File-recid) THEN DO:
            IF DICTDB._field._extent > 0 THEN
              ASSIGN forpos = forpos + (DICTDB._Field._Extent - 1).
          END.
        END.
               
        IF DICTDB._File._Fil-Misc1[1] > forpos THEN
            ASSIGN forpos = DICTDB._File._Fil-Misc1[1] + 1.
        IF INTEGER(DICTDB._File._Fil-Misc2[2]) > forpos THEN
            ASSIGN forpos = INTEGER(DICTDB._File._Fil-Misc2[2]).

        FOR EACH new-obj WHERE add-type = "F"
                           AND tbl-name = tblname:                                                     
          IF INDEX(for-name , "##") <> 0 THEN DO: 

            IF SUBSTRING(new-obj.for-name, (LENGTH(new-obj.for-name) - 2), 3) = "##1" THEN
              ASSIGN extnt = FALSE.

            IF for-name BEGINS "_S#_" THEN 
              ASSIGN extnt = FALSE.  
            ELSE IF NOT extnt THEN DO:   
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tbl-name
                     df-info.df-fld = fieldname
                     df-line = 'UPDATE FIELD "' + prg-name  + '" OF "' + tbl-name + '"'.
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tbl-name
                     df-info.df-fld = fieldname
                     df-line = '  FOREIGN-POS ' + string(forpos).
              
              IF for-name BEGINS "A##" THEN
                ASSIGN extnt = false.
              ELSE 
                ASSIGN extnt = true.
            END. 
          END.
          ELSE DO:
            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-info.df-tbl = tbl-name
                   df-info.df-fld = fieldname
                   df-line = 'UPDATE FIELD "' + prg-name + '" OF "' + tbl-name + '"'.
            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-info.df-tbl = tbl-name
                   df-info.df-fld = fieldname
                   df-line = '  FOREIGN-POS ' + STRING(forpos).
            
            ASSIGN extnt = FALSE.   
          END.                  
          ASSIGN forpos = forpos + 1.
        END.
      END.        
      ELSE DO: /* Have a new file here */
        ASSIGN forpos = 1
               extnt = false.

        FOR EACH new-obj WHERE new-obj.add-type = "F"
                           AND new-obj.tbl-name = tblname: 
          IF INDEX(new-obj.for-name , "##") <> 0 THEN DO: 

            IF SUBSTRING(new-obj.for-name, (LENGTH(new-obj.for-name) - 2), 3) = "##1" THEN
              ASSIGN extnt = FALSE.

            IF new-obj.for-name BEGINS "_S#_" THEN 
              ASSIGN extnt = FALSE.  
            ELSE IF NOT extnt THEN DO:   
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = new-obj.tbl-name
                     df-info.df-fld = fieldname
                     df-line = 'UPDATE FIELD "' + new-obj.prg-name + '" OF "' + new-obj.tbl-name + '"'.
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = new-obj.tbl-name
                     df-info.df-fld = fieldname
                     df-line = '  FOREIGN-POS ' + STRING(forpos).
              
              ASSIGN extnt = true.
            END. 
          END.
          ELSE DO:
            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-info.df-tbl = new-obj.tbl-name
                   df-info.df-fld = fieldname
                   df-line =  'UPDATE FIELD "' + new-obj.prg-name + '" OF "' + new-obj.tbl-name + '"'.
            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-info.df-tbl = new-obj.tbl-name
                   df-info.df-fld = fieldname
                   df-line = '  FOREIGN-POS ' + STRING(forpos).
            
            ASSIGN extnt = FALSE.   
          END.                  

          /* be consistent with the schema pull */
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = new-obj.tbl-name
                 df-info.df-fld = fieldname
                 df-line = '  FIELD-MISC22 ' + (IF new-obj.mand = YES THEN '"N"' ELSE '"Y"').

          ASSIGN forpos = forpos + 1.
        END.
      END.
    END.                                       
    IF line-num < 2 THEN
      PUT STREAM tosql UNFORMATTED comment_chars line SKIP.          
    ELSE IF NOT LAST-OF(tblname) THEN DO:      
      PUT STREAM tosql UNFORMATTED comment_chars line "," SKIP.
    END.
    ELSE DO:          
      PUT STREAM tosql UNFORMATTED comment_chars line ")" SKIP.
      PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP(1).
    END.         
    DELETE sql-info.
  END.

  FOR EACH alt-info BREAK BY a-tblname BY a-line-num:
    IF FIRST-OF(a-tblname) THEN
      PUT STREAM tosql UNFORMATTED comment_chars a-line  SKIP.
    ELSE IF NOT LAST-OF(a-tblname) THEN 
      PUT STREAM tosql UNFORMATTED comment_chars a-line ","  SKIP.
    ELSE DO:          
      PUT STREAM tosql UNFORMATTED  comment_chars a-line   SKIP.       
      PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP(1).
    END.         
    DELETE alt-info.
  END.
    
  IF pcompatible AND addtable THEN DO:
    ASSIGN recididx = p-r-index
           trigname = "_TI_" + recididx
           p-r-index = p-r-index + "##progress_recid ON " + mss_username + "." + p-r-index.
 
    trigname = "_TI_" + recididx.
    
    PUT STREAM tosql UNFORMATTED   
      comment_chars "create trigger " trigname " ON " mss_username "." recididx " for insert as" SKIP
      comment_chars "    if  ( select PROGRESS_RECID from inserted) is NULL " SKIP
      comment_chars "    begin" SKIP
      comment_chars "        update t set PROGRESS_RECID = i.IDENTITYCOL " SKIP
      comment_chars "         from " recididx " t  JOIN inserted i ON " skip
      comment_chars "         t.PROGRESS_RECID_IDENT_ = i.PROGRESS_RECID_IDENT_" SKIP
      comment_chars "        select convert (bigint, @@identity)" SKIP
      comment_chars "    end" SKIP.    
    
    PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP(1).
    PUT STREAM tosql UNFORMATTED comment_chars
      "CREATE UNIQUE INDEX " p-r-index "(PROGRESS_RECID)" SKIP.
    PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP(1).

    ASSIGN p-r-index = recididx
           p-r-index = p-r-index + "##progress_recid_ident_ ON " + mss_username + "." + p-r-index.
    PUT STREAM tosql UNFORMATTED comment_chars
      "CREATE UNIQUE INDEX " p-r-index "(PROGRESS_RECID_IDENT_)" SKIP.
    PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP(1).          
  END.    
  
  ASSIGN addtable      = FALSE
         alt-table     = FALSE
         lnum          = 0.

  IF comment-out THEN DO:
       /* Delete all df info for this table */
    FOR EACH df-info WHERE df-tbl = tablename:
      DELETE df-info.
    END.
  END.

END PROCEDURE.


PROCEDURE write-idx-sql:
  IF idxline = ? OR idxline = "" THEN LEAVE.

  IF pcompatible AND is-unique = FALSE THEN 
      ASSIGN idxline = idxline + ", PROGRESS_RECID".
       
  PUT STREAM tosql UNFORMATTED comment_chars idxline ")"  SKIP.
  PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP(1).
    
  ASSIGN idxline = ?
         idxname = ?
         is-unique = FALSE
         wordidx = FALSE
         wordfile = ?.  
  
  FOR EACH shad-col:
    CREATE df-info.
    ASSIGN df-info.df-seq = dfseq
           dfseq = dfseq + 1
           df-info.df-tbl = s-tbl-name
           df-line = 'UPDATE FIELD "' + p-fld-name + '" OF "' + s-tbl-name + '"'.
    CREATE df-info.
    ASSIGN df-info.df-seq = dfseq
           dfseq = dfseq + 1
           df-info.df-tbl = s-tbl-name
           df-line = '  SHADOW-COL "' + STRING(col-num) + '"'.
    CREATE df-info.
    ASSIGN df-info.df-seq = dfseq
           dfseq = dfseq + 1
           df-info.df-tbl = s-tbl-name
           df-line = "  FIELD-MISC15 " + STRING(col-num).
    DELETE shad-col.
  END.                                 
END PROCEDURE.

PROCEDURE write-seq-sql:
  IF seq-line = ? OR seq-line = "" THEN LEAVE.
  /* Delete sequence */
  IF seq-type = "d"  THEN 
    PUT STREAM tosql UNFORMATTED seq-line "go" SKIP(1).
  /* add sequence */
  ELSE IF seq-type = "a" THEN DO:
    PUT STREAM tosql UNFORMATTED 
           "if (select name from sysobjects where name = '_SEQT_" forname "' and" skip
           "    uid = (select uid from sysusers " SKIP
           "           where sid = (select sid from master.dbo.syslogins" skip 
           "                        where UPPER(name) = UPPER('"mss_username "'))))" skip
           "is not NULL" skip
           "drop table _SEQT_" forname skip. 
        
     PUT STREAM tosql UNFORMATTED "go" SKIP(1).

     PUT STREAM tosql UNFORMATTED 
           "if (select name from sysobjects where name = '_SEQP_" forname "' and" skip
           "           uid = (select uid from sysusers " SKIP
           "                  where sid = (select sid from master.dbo.syslogins" skip 
           "                               where UPPER(name) = UPPER('" mss_username "'))))" skip
           " is not NULL" skip
           " drop procedure _SEQP_" forname SKIP. 
    PUT STREAM tosql UNFORMATTED "go" SKIP(1).

    PUT STREAM tosql UNFORMATTED seq-line "(" SKIP.
    PUT STREAM tosql UNFORMATTED "  initial_value   bigint NULL," SKIP.
    PUT STREAM tosql UNFORMATTED "  increment_value bigint NULL," SKIP.
    PUT STREAM tosql UNFORMATTED "  upper_limit     bigint NULL," SKIP.
    PUT STREAM tosql UNFORMATTED "  current_value   bigint NULL," SKIP.
    PUT STREAM tosql UNFORMATTED "  cycle           BIT NOT NULL)" SKIP(1).
    PUT STREAM tosql UNFORMATTED "insert into _SEQT_" forname SKIP.
    PUT STREAM tosql UNFORMATTED "(initial_value, increment_value, upper_limit, current_value, cycle)" SKIP.
    PUT STREAM tosql UNFORMATTED "values(" init "," incre ",".
    IF maxval = ? THEN
      PUT STREAM tosql UNFORMATTED (IF large_seq THEN "9223372036854775807," ELSE "2147483647,") init "," cyc ")" SKIP.
    ELSE
      PUT STREAM tosql UNFORMATTED  maxval "," init "," cyc ")" SKIP. 

    PUT STREAM tosql UNFORMATTED "go" SKIP(1).
    
    /* Create the procedure to keep sequence numbers */
    PUT STREAM tosql unformatted 
           "create procedure _SEQP_" forname " (@op int, @val bigint output) as " skip
           "begin" skip 
           "    /* " skip 
           "     * Current-Value function " skip 
           "     */" skip
           "    if @op = 0 " skip 
           "    begin" skip 
           "        select @val = (select current_value from _SEQT_" forname ")" skip 
           "        return 0" skip
           "    end" skip 
           "    " skip 
           "    /*" skip  
           "     * Next-Value function " skip 
           "     */" skip 
           "    else if @op = 1" skip 
           "    begin" skip 
           "        declare @cur_val  bigint" skip 
           "        declare @last_val bigint" skip 
           "        declare @inc_val  bigint" skip 
           " " skip 
           "        begin transaction" skip 
           " " skip 
           "        /* perform a 'no-op' update to ensure exclusive lock */" skip 
           "        update _SEQT_" forname " set initial_value = initial_value" skip
           " " skip 
           "        select @cur_val = (select current_value from _SEQT_" forname ")" skip 
           "        select @last_val = (select upper_limit from _SEQT_" forname ")" skip
           "        select @inc_val  = (select increment_value from _SEQT_" forname ")" skip 
           " " skip 
           "        /*" skip 
           "         * if the next value will pass the upper limit, then either" skip
           "         * wrap or return a range violation" skip 
           "         */ " skip 
           "        if  @inc_val > 0 and @cur_val + @inc_val > @last_val  or @inc_val < 0 and @cur_val + @inc_val < @last_val " skip  
           "        begin" skip 
           "            if (select cycle from _SEQT_" forname ") = 0 /* non-cycling sequence */" skip 
           "            begin " skip 
           "                select @val = @cur_val" skip
           "                commit transaction" skip 
           "                return -1" skip 
           "            end" skip 
           "            else " skip 
           "                 select @val = (select initial_value from _SEQT_" forname ")" skip
           "        end" skip 
           "        else " skip 
           "             select @val = @cur_val + @inc_val" skip 
           " " skip 
           " " skip 
           "        update _SEQT_" forname " set current_value = @val" skip 
           " " skip 
           " " skip 
           "        commit transaction" skip 
           "        return 0" skip 
           "    end" skip 
           "    else " SKIP
           "    /*" skip  
           "     * Set Current-Value function " skip 
           "     */" skip
           "    if @op = 2 " SKIP
           "    begin " SKIP
           "      begin transaction " SKIP
           "      update _SEQT_" forname " set current_value = @val" SKIP
           "      commit transaction " SKIP
           "      return 0 " SKIP
           "   end " SKIP           
           "    else " skip 
           "        return -2" skip 
           "end" skip 
           " "   skip. 
     PUT STREAM tosql UNFORMATTED "go" SKIP(1).

    IF init <> ? AND init <> "" THEN DO:
      CREATE df-info.
      ASSIGN df-info.df-seq = dfseq
             dfseq = dfseq + 1
             df-line = "  INITIAL " + init.
    END.
 
    IF incre <> ? AND incre <> "" THEN DO:
      CREATE df-info.
      ASSIGN df-info.df-seq = dfseq
             dfseq = dfseq + 1
             df-line = "  INCREMENT " + incre.
    END.
    IF cyc <> ? AND cyc <> "" THEN DO:
      IF cyc = "1" THEN 
        ASSIGN cyc = "yes".
      ELSE
        ASSIGN cyc = "no".  

      CREATE df-info.
      ASSIGN df-info.df-seq = dfseq
             dfseq = dfseq + 1
             df-line = "  CYCLE-ON-LIMIT " + cyc.
    END.
    
    CREATE df-info.
    ASSIGN df-info.df-seq = dfseq
           dfseq = dfseq + 1
           df-line = "  MIN-VAL " + minval.

    CREATE df-info.
    ASSIGN df-info.df-seq = dfseq
           dfseq = dfseq + 1.
    IF maxval = ? THEN
      ASSIGN df-line = "  MAX-VAL ? ".            
    ELSE
      ASSIGN df-line = "  MAX-VAL " + maxval.
    
    CREATE df-info.
    ASSIGN df-info.df-seq = dfseq
           dfseq = dfseq + 1
           df-line = '  FOREIGN-OWNER "' + LOWER(mss_username) + '"'.
    
  END.
  /* update sequence table */
  ELSE DO:
    IF init <> ? THEN DO:
      PUT STREAM tosql UNFORMATTED "insert into _SEQT_" forname "(initial_value)" SKIP.
      PUT STREAM tosql UNFORMATTED "values(" init ")" SKIP(1).
    END.
    IF incre <> ? THEN DO:
      PUT STREAM tosql UNFORMATTED "insert into _SEQT_" forname "(increment_value)" SKIP.
      PUT STREAM tosql UNFORMATTED "values(" incre ")" SKIP(1).
    END.
    IF maxval <> ? THEN DO:
      PUT STREAM tosql UNFORMATTED "insert into _SEQT_" forname "(upper_limit)" SKIP.
      PUT STREAM tosql UNFORMATTED "values(" maxval ")" SKIP.
    END.
    IF cyc <> ? THEN DO:
      PUT STREAM tosql UNFORMATTED "insert into _SEQT_" forname "(cycle)" SKIP.
      PUT STREAM tosql UNFORMATTED "values(" cyc ")" SKIP.
    END.
  END.

  ASSIGN seq-type = ?
         seq-line = ?
         seqname = ?
         init = ?
         maxval = ?
         minval = ?
         incre = ?
         cyc = ?.                 
END PROCEDURE.

PROCEDURE create-new-obj:
  DEFINE INPUT PARAMETER atype   AS CHARACTER.
  DEFINE INPUT PARAMETER ext-num AS CHARACTER.
  
  IF atype = "T" THEN DO:
    CREATE new-obj.
    ASSIGN add-type = "T"
           tbl-name = ilin[3]
           for-name = forname.
  END. 
  ELSE IF atype = "F" THEN DO:    
    CREATE new-obj.
    ASSIGN add-type = "F"
           n-order = new-ord
           new-ord = new-ord + 1
           tbl-name = tablename
           fld-name = fieldname
           for-type = fortype
           mand = NO
           prg-name = (IF ilin[3] <> ? THEN ilin[3]
                       ELSE fieldname).
    IF ext-num = ? THEN
      ASSIGN for-name = fieldname.       
    ELSE
      ASSIGN for-name = fieldname + "##" + ext-num.  

  END. 
  ELSE IF atype = "I" THEN DO:
     CREATE new-obj.
     ASSIGN add-type = "I"
            tbl-name = ilin[5]
            for-name = forname
            prg-name = ilin[3].
  END.       
END PROCEDURE. 


PROCEDURE new-obj-idx:           
  ASSIGN fortype = new-obj.for-type
         forname = new-obj.for-name.
                              
  FIND new-obj where new-obj.add-type = "F"
                 AND new-obj.tbl-name = tablename
                 AND new-obj.fld-name = "_S#_" + ilin[2]
                 NO-ERROR.                                                                              
  
  IF NOT AVAILABLE new-obj THEN DO:  /* need to alter the table to create field */ 
                                                            
    ASSIGN shw-col = 0.                               
                            
    FOR EACH new-Obj WHERE add-type = "F"
                       AND tbl-name = tablename:
      ASSIGN shw-col = shw-col + 1.
    END.
    IF pcompatible AND NOT addtable THEN
      ASSIGN shw-col = shw-col + 2.
    ELSE  
      ASSIGN shw-col = shw-col + 1.
                                                                                              
    CREATE shad-col.
    ASSIGN s-fld-name = "_S#_" + forname
           p-fld-name = ilin[2]
           s-tbl-name = tablename
           col-num = shw-col.                
 
    CREATE new-obj.
    ASSIGN new-obj.add-type = "F"
           new-obj.tbl-name = tablename
           new-obj.n-order = new-ord
           new-ord = new-ord + 1
           new-obj.for-name = "_S#_" + forname
           new-obj.fld-name = "_S#_" + ilin[2]
           new-obj.prg-name = ilin[2]
           new-obj.for-type = fortype. 
    
    FIND n-obj WHERE n-obj.add-type = "t"
                 AND n-obj.tbl-name = tablename.
                              
    PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " + mss_username + "." + n-obj.for-name SKIP.
    PUT STREAM tosql UNFORMATTED comment_chars " ADD " new-obj.for-name  " " new-obj.for-type SKIP.
    PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP(1).                                                          
  END.                                 
END PROCEDURE.

PROCEDURE get-position:

  FIND DICTDB._File WHERE DICTDB._File._File-name = tablename NO-ERROR.
  IF NOT AVAILABLE DICTDB._File THEN 
    FIND rename-obj WHERE rename-type = "T"
                      AND t-name = tablename
                      NO-ERROR.
  IF AVAILABLE rename-obj THEN
    FIND DICTDB._File WHERE DICTDB._File._File-name = old-name NO-ERROR. 
  IF AVAILABLE DICTDB._File THEN DO:
    ASSIGN i = 0.

    FOR EACH DICTDB._field OF DICTDB._file BREAK BY _File-recid BY _fld-stoff: 
      IF i < DICTDB._field._fld-stoff THEN 
        ASSIGN i = DICTDB._field._fld-stoff.
      IF DICTDB._Field._Fld-Misc1[5] > i THEN
         ASSIGN i = DICTDB._Field._Fld-Misc1[5].
      IF LAST-OF(_File-recid) THEN DO:
        IF DICTDB._field._extent > 0 THEN
          ASSIGN i = i + (DICTDB._Field._Extent - 1).
      END.
    END.

    IF i < DICTDB._File._Fil-misc1[1] THEN
        ASSIGN i = DICTDB._File._Fil-misc1[1].
    IF i < INTEGER(DICTDB._File._Fil-misc2[2]) THEN
        ASSIGN i = INTEGER(DICTDB._File._Fil-misc2[2]).

    FOR EACH new-obj WHERE new-obj.add-type = "F"
                       AND new-obj.tbl-name = tablename:                      
      ASSIGN i = i + 1.
    END.
    FIND FIRST df-info WHERE df-info.df-tbl = tablename
                         AND df-info.df-fld = fieldname
                         AND df-line BEGINS '  FOREIGN-POS '
                         NO-ERROR.
    IF AVAILABLE df-info THEN.
    ELSE DO:
      CREATE df-info.
      ASSIGN df-info.df-seq = dfseq
             dfseq = dfseq + 1
             df-info.df-tbl = tablename
             df-info.df-fld = fieldname
             df-line = '  FOREIGN-POS ' + STRING(i).  
    END.
  END.   
END PROCEDURE.  

PROCEDURE new-for-position:
  DEFINE VARIABLE recidname AS CHARACTER NO-UNDO.
  DEFINE VARIABLE forpos    AS INTEGER   NO-UNDO.
  FIND DICTDB._File WHERE DICTDB._File._File-name = tablename
                      AND DICTDB._File._Owner = "_FOREIGN"
                      NO-ERROR.          
  IF NOT AVAILABLE DICTDB._File THEN DO:
    FIND FIRST rename-obj WHERE rename-obj.new-name = tablename 
                            AND rename-obj.rename-type = "t" NO-ERROR.
    IF AVAILABLE rename-obj THEN DO:
      ASSIGN rntbl = tablename.
      FIND DICTDB._File WHERE DICTDB._File._File-name = old-name NO-ERROR.
    END.
  END.
  ELSE
    ASSIGN rntbl = tablename.

  IF AVAILABLE DICTDB._File THEN DO:
    IF DICTDB._File._fil-misc1[1] < 0   THEN DO:
      FIND DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Fld-stoff = (DICTDB._File._Fil-misc1[1] * -1)
               NO-ERROR.
      IF AVAILABLE DICTDB._Field THEN     
         ASSIGN recidname = DICTDB._Field._Field-name
                recidident = ?.
    END.
    ELSE 
      ASSIGN recidname = "progress_recid"
             recidident = "progress_recid_ident".

    IF recidname <> ? AND recidname <> "" THEN DO:
      CREATE new-position.
      ASSIGN new-position.table-np = rntbl
             new-position.field-np = recidname
             new-position.old-pos  = DICTDB._File._Fil-Misc1[1]
             new-position.shadow   = 0
             new-position.extent#  = 0.
    END.
    IF recidident <> ? THEN DO:
      CREATE new-position.
      ASSIGN new-position.table-np = rntbl
             new-position.field-np = recidident
             new-position.old-pos  = INTEGER(DICTDB._File._Fil-Misc2[2])
             new-position.shadow   = 0
             new-position.extent#  = 0.
    END.

    FOR EACH DICTDB._Field OF DICTDB._File:      
      CREATE new-position.
      ASSIGN new-position.table-np = rntbl
             new-position.field-np = DICTDB._Field._Field-name
             new-position.old-pos  = DICTDB._Field._Fld-stoff
             new-position.shadow   = (IF DICTDB._Field._Fld-Misc1[5] > 0 THEN
                                       DICTDB._Field._Fld-Misc1[5]
                                      ELSE 0)
             new-position.extent#  = (IF DICTDB._Field._Extent > 0 THEN
                                          DICTDB._Field._Extent
                                       ELSE 0).
      FIND FIRST rename-obj WHERE rename-obj.t-name = rntbl 
                            AND rename-obj.rename-type = "f" 
                            AND rename-obj.old-name = new-position.field-np NO-ERROR.
       IF AVAILABLE rename-obj THEN
           ASSIGN new-position.field-np = rename-obj.new-name.
    END.

    ASSIGN forpos = 0.
    FOR EACH new-position WHERE table-np = rntbl:

      FIND FIRST drop-field WHERE drop-field.of-table = new-position.table-np
                              AND drop-field.f-name = new-position.field-np NO-ERROR.

      IF AVAILABLE drop-field THEN                
        ASSIGN new-position.dropped = TRUE
               forpos = forpos + (IF new-position.extent# = 0 THEN 1
                                  ELSE new-position.extent#).       
      ELSE DO:
        IF new-position.shadow <> 0 THEN
          ASSIGN new-position.shadow = new-position.shadow - forpos
                 new-position.new-pos = new-position.old-pos - forpos.
        ELSE
          ASSIGN new-position.new-pos = new-position.old-pos - forpos.   
      END.      
    END.

    /* Now assigns the forpos equal to the last new-pos  */
    FIND LAST new-position WHERE table-np = rntbl
                             AND new-position.dropped = FALSE.
    ASSIGN forpos = new-position.new-pos + 1.
    _newloop:
    FOR EACH new-obj WHERE add-type = "F"
                       AND tbl-name = rntbl:

      IF INDEX(new-obj.for-name, "##") <> 0 THEN DO:
       IF SUBSTRING(new-obj.for-name, LENGTH(new-obj.for-name) - 2) = "##1" THEN DO:
          CREATE new-position.
          ASSIGN new-position.table-np = rntbl
                 new-position.field-np = prg-name
                 new-position.new-pos  = forpos.
               
          FOR EACH n-obj WHERE n-obj.prg-name BEGINS SUBSTRING(new-obj.prg-name, 1, LENGTH(new-position.field-np) - 3):
            ASSIGN forpos = forpos + 1.
          END.
          NEXT _newloop.
        END.        
      END.
      ELSE IF new-obj.for-name BEGINS "_S#_" THEN DO:
         ASSIGN forpos = forpos + 1.
         NEXT _newloop.
      END.
      ELSE DO:
        CREATE new-position.
        ASSIGN new-position.table-np = rntbl
               new-position.field-np = new-obj.prg-name.

        FIND FIRST n-obj WHERE n-obj.prg-name BEGINS SUBSTRING(new-obj.prg-name, 3) NO-ERROR.
        IF AVAILABLE n-obj  THEN
           ASSIGN new-position.shadow   = forpos
                  forpos                = forpos + 1
                  forpos                = forpos + 1.
        ELSE
          ASSIGN new-position.new-pos  = forpos    
                 forpos                = forpos + 1.
      END.
    END.
    
    FOR EACH new-position WHERE table-np = rntbl
                            AND new-position.dropped = FALSE:

      IF new-position.field-np = recidname THEN DO:
        CREATE df-info.
        ASSIGN df-info.df-seq = dfseq
               dfseq = dfseq + 1
               df-info.df-tbl = new-position.table-np
               df-line = 'UPDATE TABLE "' + rntbl + '"'.
        CREATE df-info.
        ASSIGN df-info.df-seq = dfseq
               dfseq = dfseq + 1
               df-info.df-tbl = new-position.table-np
               df-line = '  PROGRESS-RECID ' + STRING( new-position.new-pos).
        /* if user has chosen a field instead of creating the recid field put out df info */
        IF new-position.field-np <> "progress_recid" THEN DO:
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = new-position.table-np
                 df-info.df-fld = new-position.field-np
                 df-line = 'UPDATE FIELD "' + new-position.field-np  + '" OF "' + new-position.table-np + '"'.
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = new-position.table-np
                 df-info.df-fld = new-position.field-np
                 df-line = '  FOREIGN-POS ' + string(new-position.new-pos).
        END.
      END.
      ELSE IF new-position.field-np = recidident THEN DO:
        CREATE df-info.
        ASSIGN df-info.df-seq = dfseq
               dfseq = dfseq + 1
               df-info.df-tbl = new-position.table-np
               df-line = 'UPDATE TABLE "' + rntbl + '"'.
        CREATE df-info.
        ASSIGN df-info.df-seq = dfseq
               dfseq = dfseq + 1
               df-info.df-tbl = new-position.table-np
               df-line = '  HIDDEN-FLDS ' + STRING( new-position.new-pos).
      END.
      ELSE DO:
        CREATE df-info.
        ASSIGN df-info.df-seq = dfseq
               dfseq = dfseq + 1
               df-info.df-tbl = new-position.table-np
               df-info.df-fld = new-position.field-np
               df-line = 'UPDATE FIELD "' + new-position.field-np  + '" OF "' + new-position.table-np + '"'.
        CREATE df-info.
        ASSIGN df-info.df-seq = dfseq
               dfseq = dfseq + 1
               df-info.df-tbl = new-position.table-np
               df-info.df-fld = new-position.field-np
               df-line = '  FOREIGN-POS ' + string(new-position.new-pos).       
      END.  
    END.
  END.
  ASSIGN dropped-fld = FALSE.
END PROCEDURE.

PROCEDURE dctquot:

  DEFINE INPUT  PARAMETER inline  AS CHARACTER            NO-UNDO.
  DEFINE INPUT  PARAMETER quotype AS CHARACTER            NO-UNDO.
  DEFINE OUTPUT PARAMETER outline AS CHARACTER INITIAL "" NO-UNDO.
  DEFINE        VARIABLE  i       AS INTEGER              NO-UNDO.

  IF INDEX(inline,quotype) > 0 THEN
    DO i = 1 TO LENGTH(inline):
       outline = outline + (IF SUBSTRING(inline,i,1) = quotype
                 THEN quotype + quotype ELSE SUBSTRING(inline,i,1)).
    END.
  ELSE
    outline = inline.

  outline = (IF outline = ? THEN "?" ELSE quotype + outline + quotype).

END PROCEDURE.

PROCEDURE create-idx-field:
  FIND DICTDB._File WHERE DICTDB._File._File-name = tablename NO-ERROR.
  IF NOT AVAILABLE DICTDB._FILE THEN DO:               
    FIND rename-obj WHERE rename-type = "T"   
                      AND new-name = tablename
                      NO-ERROR.
    IF AVAILABLE rename-obj THEN 
      FIND DICTDB._File WHERE DICTDB._File._File-name = old-name NO-ERROR.            
  END.        

  IF AVAILABLE DICTDB._File THEN DO:        
    FIND DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Field-name = ilin[2] NO-ERROR.
    IF AVAILABLE DICTDB._Field THEN DO:
      IF NOT shadowcol THEN DO:
        IF INDEX(idxline, "(") = 0 THEN
          ASSIGN idxline = idxline + "( " + DICTDB._Field._For-name.
        ELSE
          ASSIGN idxline = idxline + ", " + DICTDB._Field._For-name.            
      END.
      ELSE DO: 
        IF DICTDB._Field._Data-type <> "Character" THEN DO: 
          IF INDEX(idxline, "(") = 0 THEN
            ASSIGN idxline = idxline + "( " + DICTDB._Field._For-name.
          ELSE
           ASSIGN idxline = idxline + ", " + DICTDB._Field._For-name.  
        END.     
        ELSE IF DICTDB._Field._Data-type = "Character" THEN DO:                                    
          IF (DICTDB._Field._Fld-misc2[5] <> ? and DICTDB._Field._Fld-misc2[5] <> "") OR
            CAN-FIND(new-obj where new-obj.add-type = "F"
                               AND new-obj.tbl-name = tablename
                               AND new-obj.fld-name = "_S#_" + ilin[2]) THEN DO: /* shawdow column exists in file */

            IF INDEX(idxline, "(") = 0 THEN
              ASSIGN idxline = idxline + "(_S#_" + DICTDB._Field._For-name.
            ELSE
              ASSIGN idxline = idxline + ", _S#_" + DICTDB._Field._For-name.  

          END.                    
          ELSE DO: /* shawdow not in original file see if already created */     
            FIND FIRST new-obj where new-obj.add-type = "F"
                                 AND new-obj.tbl-name = tablename
                                 AND new-obj.prg-name = ilin[2]
                                 AND new-obj.fld-name BEGINS "_S#_" 
                                 NO-ERROR.
                                        
            IF NOT AVAILABLE new-obj THEN DO:  /* need to alter the table to create field */        
              ASSIGN shw-col = 0.
                             
              FOR EACH DICTDB._Field OF DICTDB._FILE NO-LOCK:
                IF DICTDB._Field._Extent = 0 THEN                   
                  ASSIGN shw-col = shw-col + 1.
                ELSE
                  ASSIGN shw-col = shw-col + DICTDB._Field._Extent. 
              
                IF DICTDB._Field._Fld-Misc1[5] <> ? AND DICTDB._Field._Fld-Misc1[5] <> 0 THEN
                  ASSIGN shw-col = shw-col + 1.
              END.
              IF shw-col < DICTDB._File._Fil-Misc1[1] THEN
                ASSIGN shw-col = DICTDB._File._Fil-misc1[1].
              IF shw-col < INTEGER(DICTDB._File._Fil-Misc2[2]) THEN
                ASSIGN shw-col = INTEGER(DICTDB._File._Fil-Misc2[2]).
              FOR EACH new-Obj WHERE new-obj.add-type = "F"
                                 AND new-obj.tbl-name = tablename:
                ASSIGN shw-col = shw-col + 1.
              END.               

              ASSIGN shw-col = shw-col + 1.  
             
              FIND DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Field-name = ilin[2] NO-ERROR.
             
              CREATE shad-col.
              ASSIGN p-fld-name = ilin[2]
                     s-tbl-name = tablename
                     col-num = shw-col
                     s-fld-name = "_S#_" + DICTDB._Field._For-name
                     j = DICTDB._Field._Fld-Misc1[3].
                              
              CREATE new-obj.
              ASSIGN new-obj.add-type = "F"
                     new-obj.tbl-name = tablename
                     new-obj.n-order = new-ord
                     new-ord = new-ord + 1
                     new-obj.fld-name = "_S#_" + DICTDB._Field._For-name
                     new-obj.prg-name = ilin[2]
                     new-obj.for-name = "_S#_" + DICTDB._Field._For-name. 
                         
              PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " + DICTDB._File._For-owner + "." + DICTDB._File._For-name SKIP.
                
              IF j < varlngth THEN DO:                                   
                PUT STREAM tosql UNFORMATTED comment_chars "  ADD " + new-obj.fld-name + " " + /*"VARCHAR("*/
                                             user_env[11] + "("  + STRING(j) + ");" SKIP(1).
                ASSIGN new-obj.for-type =  /*"VARCHAR(" */ user_env[11] + "(" + STRING(j) + ")".  
              END.      
              ELSE DO:
                PUT STREAM tosql UNFORMATTED comment_chars "  ADD " new-obj.fld-name /*" TEXT"*/ " " user_env[18] SKIP.
                PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP(1).
                ASSIGN new-obj.for-type =  user_env[18] /*"TEXT"*/.
              END.     
             
              IF INDEX(idxline, "(") = 0 THEN
                ASSIGN idxline = idxline + "(" + new-obj.fld-name.
              ELSE
                ASSIGN idxline = idxline + ", " + new-obj.fld-name.                                                  
            END.                                 
            ELSE DO: /* Available new-obj for shawdow */
              IF INDEX(idxline, "(") = 0 THEN
                ASSIGN idxline = idxline + "(" + new-obj.fld-name.
              ELSE
                ASSIGN idxline = idxline + ", " + new-obj.fld-name.                                                                   
            END.                        
          END. /* shawdow not in existing file */
        END.
        IF ilin[3] BEGINS "DESC"  THEN
          ASSIGN idxline = idxline + " DESC ".
      END.        
    END. /* end available field */ 
    ELSE DO: /* Not available field see if renamed field */   

      FIND rename-obj WHERE rename-type = "F" 
                        AND t-name = tablename
                        AND new-name = ilin[2] NO-ERROR.                                    
      IF AVAILABLE rename-obj THEN DO:      
        FIND DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Field-name = old-name NO-ERROR.                   
        IF AVAILABLE DICTDB._Field THEN DO:
          IF NOT shadowcol THEN DO:
            IF INDEX(idxline, "(") = 0 THEN
                ASSIGN idxline = idxline + "( " + DICTDB._Field._For-name.
              ELSE
                ASSIGN idxline = idxline + ", " + DICTDB._Field._For-name.            
          END.
          ELSE DO:
            IF DICTDB._Field._Data-type = "Character" THEN DO: 
              IF (DICTDB._Field._Fld-misc2[5] <> ? and DICTDB._Field._Fld-misc2[5] <> "") OR
                 CAN-FIND(new-obj where new-obj.add-type = "F"
                                    AND new-obj.tbl-name = tablename
                                    AND new-obj.fld-name = "_S#_" + DICTDB._Field._For-name) THEN DO:                     
                IF INDEX(idxline, "(") = 0 THEN
                  ASSIGN idxline = idxline + "(_S#_" + dsv-name.
                ELSE
                  ASSIGN idxline = idxline + ", _S#_" + dsv-name.                          
              END.
              ELSE DO: /* shawdow not in file see if already created */                      
                FIND new-obj where new-obj.add-type = "F"
                               AND new-obj.tbl-name = tablename
                               AND new-obj.fld-name = "_S#_" + DICTDB._Field._For-name
                               NO-ERROR.
                                 
                IF NOT AVAILABLE new-obj THEN DO:  /* need to alter the table to create field */              
                  ASSIGN shw-col = 0.
                      
                  FOR EACH DICTDB._Field OF DICTDB._FILE NO-LOCK:
                    IF DICTDB._Field._Extent = 0 THEN                   
                      ASSIGN shw-col = shw-col + 1.
                    ELSE
                      ASSIGN shw-col = shw-col + DICTDB._Field._Extent. 
                    IF DICTDB._Field._Fld-Misc1[5] <> ? AND DICTDB._Field._Fld-Misc1[5] <> 0 THEN
                      ASSIGN shw-col = shw-col + 1.
                  END.
                  IF shw-col < DICTDB._File._Fil-Misc1[1] THEN
                    ASSIGN shw-col = DICTDB._File._Fil-Misc1[1].
                  IF shw-col < INTEGER(DICTDB._File._Fil-Misc2[2]) THEN
                    ASSIGN shw-col = INTEGER(DICTDB._File._Fil-Misc2[2]).

                  FOR EACH new-Obj WHERE new-obj.add-type = "F"
                                     AND new-obj.tbl-name = tablename:
                    ASSIGN shw-col = shw-col + 1.
                  END.
                 
                  ASSIGN shw-col = shw-col + 1.
                                                                                              
                  FIND DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Field-name = old-name.
             
                  CREATE shad-col.
                  ASSIGN p-fld-name = ilin[2]
                         s-tbl-name = tablename
                         col-num = shw-col
                         s-fld-name = "_S#_" + DICTDB._Field._For-name
                         j = DICTDB._Field._Fld-Misc1[3].
                  
                  CREATE new-obj.
                  ASSIGN new-obj.add-type = "F"
                         new-obj.tbl-name = tablename
                         new-obj.n-order = new-ord
                         new-ord = new-ord + 1
                         new-obj.fld-name = "_S#_" + DICTDB._Field._For-name
                         new-obj.prg-name = ilin[2]
                         new-obj.for-name = "_S#_" + DICTDB._Field._For-name. 
                   
                  PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " + DICTDB._File._For-owner + "." + DICTDB._File._For-name SKIP.

                  IF j < varlngth THEN DO:                    
                    PUT STREAM tosql UNFORMATTED comment_chars "  ADD " new-obj.fld-name /*" VARCHAR("*/ " " user_env[11] "("
                                   STRING(j)  ");" SKIP(1).
                    ASSIGN new-obj.for-type = /*"VARCHAR("*/ user_env[11] + "(" + STRING(j) + ")".  
                  END.      
                  ELSE DO:
                    PUT STREAM tosql UNFORMATTED comment_chars " ADD " new-obj.fld-name /*" TEXT"*/ " "  user_env[18] SKIP.
                    PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP(1).
                    ASSIGN new-obj.for-type = user_env[18] /*"TEXT"*/.
                  END.     
                END.
                ELSE DO: /* Available new-obj for shawdow */
                  IF INDEX(idxline, "(") = 0 THEN
                    ASSIGN idxline = idxline + "(" + new-obj.fld-name.
                  ELSE
                    ASSIGN idxline = idxline + ", " + new-obj.fld-name.                                                                   
                END.                    
              END. /* shawdow not in existing file */
            END. /* End available field that is a character. */
            ELSE DO:
              IF INDEX(idxline, "(") = 0 THEN
                ASSIGN idxline = idxline + "( " + DICTDB._Field._For-name.
              ELSE
                ASSIGN idxline = idxline + ", " + DICTDB._Field._For-name. 
            END.      
          END.
          IF ilin[3] BEGINS "DESC"  THEN
            ASSIGN idxline = idxline + " DESC ".
        END.
      END. /* End of rename object */
      ELSE DO:
        FIND FIRST new-obj WHERE new-obj.add-type = "F"
                             AND new-obj.tbl-name = tablename
                             AND new-obj.prg-name = ilin[2]
                                        NO-ERROR.                                      
        IF AVAILABLE new-obj THEN DO:                                                                        
          IF SUBSTRING(new-obj.for-type,2,7) = "VARCHAR" OR SUBSTRING(new-obj.for-type,2,8) = "NVARCHAR" THEN DO:                      
            ASSIGN fortype = new-obj.for-type
                   forname = new-obj.for-name.
            IF NOT shadowcol THEN DO:
              IF INDEX(idxline, "(") = 0 THEN
                ASSIGN idxline = idxline + "(" + new-obj.for-name.
              ELSE
                ASSIGN idxline = idxline + ", " + new-obj.for-name. 
            END.
            ELSE DO:
              FIND n-obj where n-obj.add-type = "F"
                           AND n-obj.tbl-name = tablename
                           AND n-obj.fld-name = "_S#_" + ilin[2]
                                       NO-ERROR.     

              IF NOT AVAILABLE n-obj THEN DO:  /* need to alter the table to create field */                                                           
                                                           
                ASSIGN shw-col = 0.                               
                                                
                FOR EACH DICTDB._Field OF DICTDB._FILE NO-LOCK:
                  IF DICTDB._Field._Extent = 0 THEN                   
                    ASSIGN shw-col = shw-col + 1.
                  ELSE
                    ASSIGN shw-col = shw-col + DICTDB._Field._Extent. 
                  IF DICTDB._Field._Fld-Misc1[5] <> ? AND DICTDB._Field._Fld-Misc1[5] <> 0 THEN
                    ASSIGN shw-col = shw-col + 1.
                END.

                IF shw-col < DICTDB._File._Fil-Misc1[1] THEN
                  ASSIGN shw-col = DICTDB._File._Fil-misc1[1].
                IF shw-col < INTEGER(DICTDB._File._Fil-Misc2[2]) THEN
                  ASSIGN shw-col = INTEGER(DICTDB._File._Fil-Misc2[2]).

                FOR EACH new-Obj WHERE new-obj.add-type = "F"
                                   AND new-obj.tbl-name = tablename:
                  ASSIGN shw-col = shw-col + 1.
                END.               

                ASSIGN shw-col = shw-col + 1.  
                                                                                              
                CREATE shad-col.
                ASSIGN p-fld-name = ilin[2]
                       s-fld-name = "_S#_" + forname
                       s-tbl-name = tablename
                       col-num = shw-col.                
 
                CREATE new-obj.
                ASSIGN new-obj.add-type = "F"
                       new-obj.tbl-name = tablename
                       new-obj.n-order = new-ord
                       new-ord = new-ord + 1
                       new-obj.for-name = "_S#_" + forname
                       new-obj.fld-name = "_S#_" + ilin[2]
                       new-obj.prg-name = ilin[2]
                       new-obj.for-type = (IF fortype BEGINS "CHAR" THEN user_env[11] /*"VARCHAR"*/
                                                       ELSE fortype). 
             
                PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " DICTDB._File._For-owner + "." + DICTDB._File._For-name SKIP.
                PUT STREAM tosql UNFORMATTED comment_chars " ADD " new-obj.for-name " " new-obj.for-type SKIP.
                PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP(1).                                                          
              END.                 
              IF INDEX(idxline, "(") = 0 THEN
                ASSIGN idxline = idxline + "(" + new-obj.for-name.
              ELSE
                ASSIGN idxline = idxline + ", " + new-obj.for-name. 
            END.
          END.
          ELSE DO:
            IF INDEX(idxline, "(") = 0 THEN
              ASSIGN idxline = idxline + "(" + new-obj.for-name.
            ELSE
              ASSIGN idxline = idxline + ", " + new-obj.for-name. 
          END.
          IF ilin[3] BEGINS "DESC"  THEN
              ASSIGN idxline = idxline + " DESC".
        END.  
      END.  /* end of new-obj */                           
    END. /* Not available field */
  END. /* End of available file */
  ELSE DO:  /* Dealing with new table */
    FIND FIRST new-obj WHERE new-obj.add-type = "F"
                   AND new-obj.tbl-name = tablename
                   AND new-obj.prg-name = ilin[2]
                               NO-ERROR.                     
    IF AVAILABLE new-obj THEN DO:
      IF SUBSTRING(new-obj.for-type,2,7) = "VARCHAR" OR SUBSTRING(new-obj.for-type,2,8) = "NVARCHAR" THEN DO:
        IF NOT shadowcol THEN DO:
          IF INDEX(idxline, "(") = 0 THEN
            ASSIGN idxline = idxline + "(" + new-obj.for-name.
          ELSE
            ASSIGN idxline = idxline + ", " + new-obj.for-name.          
        END.
        ELSE DO:
          RUN new-obj-idx.
          IF INDEX(idxline, "(") = 0 THEN
            ASSIGN idxline = idxline + "(" + new-obj.for-name.
          ELSE
            ASSIGN idxline = idxline + ", " + new-obj.for-name.  
        END.
      END.
      ELSE DO:
        IF INDEX(idxline, "(") = 0 THEN
          ASSIGN idxline = idxline + "(" + new-obj.for-name.
        ELSE
          ASSIGN idxline = idxline + ", " + new-obj.for-name.
      END.
      IF ilin[3] BEGINS "DESC"  THEN
              ASSIGN idxline = idxline + " DESC".
    END. 
  END.
  CREATE df-info.
  ASSIGN df-info.df-seq = dfseq
         dfseq = dfseq + 1
         df-info.df-tbl = tablename
         df-line = "  " + ilin[1] + ' "' + ilin[2] + '" '.  
  DO j = 3 TO 5:
    IF ilin[j] <> ? THEN     
      ASSIGN df-info.df-line = df-info.df-line + ilin[j] + " ".
    ELSE 
      ASSIGN j = 6. 
  END.                                                 
END PROCEDURE.
/*======================== Mainline =================================== */   

ASSIGN ilin = ?
       ipos = 0
       dfout = osh_dbname + ".df"
       sqlout = mss_dbname + ".sql"
       idbtyp = (IF user_env[32] = ? THEN user_env[22] ELSE user_env[32])
       xlate  = (user_env[8] BEGINS "y")
       minwidth = 30
       varlngth = INTEGER(user_env[10]) + 1.  
   

OUTPUT STREAM todf TO VALUE(dfout) NO-ECHO NO-MAP.
OUTPUT STREAM tosql TO VALUE(sqlout) NO-ECHO NO-MAP.

INPUT FROM VALUE(user_env[1]).              

SESSION:IMMEDIATE-DISPLAY = yes.

RUN adecomm/_setcurs.p ("WAIT").

/* find out if source db supports large sequences */
FIND FIRST _Db WHERE _db._db-name = ?.
IF _DB._Db-res1[1] = 1 THEN
   large_seq = YES.

FIND FIRST DICTDB._File NO-ERROR.
IF AVAILABLE DICTDB._File THEN DO:
  ASSIGN dbrecid = DICTDB._File._Db-recid.

  FIND _Db WHERE RECID(_db) = dbrecid NO-LOCK.
  ASSIGN qualname = _Db._Db-addr.

  /* Unicode types is only supported for MS SQL Server 2005 and up */
  IF unicodeTypes THEN DO:
      IF INTEGER(SUBSTRING(ENTRY(NUM-ENTRIES(_Db._Db-misc2[5], " ":U),_Db._Db-misc2[5], " ":U),1,2)) < 9 THEN DO:
         MESSAGE "Unicode support for the DataServer for MS SQL Server was designed to work" SKIP
                 "with Versions 2005 and above. Do not use the 'Unicode Types' option" SKIP
                 VIEW-AS ALERT-BOX ERROR BUTTONS OK.

         OUTPUT STREAM todf CLOSE.
         OUTPUT STREAM tosql CLOSE.

         RUN adecomm/_setcurs.p ("").

         RETURN.
      END.
  END.
END.

/* 20061005-002
   The qualifier name may not be the same as the dsn name, which is what
   is stored in _Db._Db-addr. Search all tables in the schema holder for the
   current schema and check if the name is different.
*/

ASSIGN imod = ?.
/* look only on the current schema */
FIND FIRST DICTDB._Db WHERE DICTDB._Db._Db-name = mss_dbname NO-ERROR.
IF AVAILABLE DICTDB._Db THEN DO:
    search_loop:
    FOR EACH DICTDB._File OF DICTDB._Db WHERE DICTDB._File._Owner = "_FOREIGN" 
        AND DICTDB._File._Fil-misc2[1] NE ? AND 
        DICTDB._File._Fil-misc2[1] NE qualname NO-LOCK:
    
        /* the first one, remember it */
        IF imod = ? THEN
            ASSIGN imod = DICTDB._File._Fil-misc2[1].
        ELSE IF imod NE DICTDB._File._Fil-misc2[1] THEN DO:
            /* if we found some other value, then this schema must have
               tables from different databases, so we can't pick any,
               leave the value already assigned above.
            */
            ASSIGN imod = ?.
            LEAVE search_loop.
        END.
    END.
    
    IF imod NE ? THEN
        ASSIGN qualname = imod
               imod = ?.
END.

DO ON STOP UNDO, LEAVE:
    /* when IMPORT hits the end, it generates ENDKEY.  This is how loop ends */
  load_loop:
  REPEAT ON ERROR UNDO,RETRY ON ENDKEY UNDO, LEAVE:
       /* Pop the top token off the top and move all the other tokens up one 
         so that ilin[1] is the next token to process.
       */
    ASSIGN ilin = ?.
    IMPORT ilin.

    IF ilin[1] = ? THEN NEXT.    
    ASSIGN inum = 3.

        /* set the action mode */
    CASE ilin[1]:
      WHEN "ADD":u    OR WHEN "CREATE":u OR WHEN "NEW":u  THEN imod = "a":u.
      WHEN "UPDATE":u OR WHEN "MODIFY":u OR WHEN "ALTER":u OR 
                                          WHEN "CHANGE":u THEN imod = "m":u.
      WHEN "DELETE":u OR WHEN "DROP":u OR WHEN "REMOVE":u THEN imod = "d":u.
      WHEN "RENAME":u                                     THEN imod = "r":u.
    END CASE.

    IF ilin[1] = "ADD"    OR ilin[1] = "CREATE" OR ilin[1] = "NEW"    OR
       ilin[1] = "UPDATE" OR ilin[1] = "MODIFY" OR ilin[1] = "ALTER" OR 
       ilin[1] = "CHANGE" OR ilin[1] = "DELETE" OR ilin[1] = "DROP" OR 
       ilin[1] = "REMOVE" OR ilin[1] = "RENAME" THEN DO:
        /* set the object type */
      CASE ilin[2]:
        WHEN "DATABASE":u OR WHEN "CONNECT":u THEN iobj = "d":u.
        WHEN "FILE":u     OR WHEN "TABLE":u   THEN ASSIGN iobj = "t":u.                  
        WHEN "FIELD":u    OR WHEN "COLUMN":u THEN ASSIGN iobj = "f":u.        
        WHEN "INDEX":u    OR WHEN "KEY":u THEN ASSIGN iobj = "i":u.                      
        WHEN "SEQUENCE":u                 THEN ASSIGN iobj = "s":u.        
      END CASE.
    END.
    /* This code is here only for when the index syntax is
        ADD/UPDATE [UNIQUE] [PRIMARY] [INACTIVE] INDEX name 
    */

    IF ilin[1] = "UPDATE" AND
       (ilin[2] <> "DATABASE" AND
        ilin[2] <> "FILE" AND
        ilin[2] <> "FIELD" AND
        ilin[2] <> "INDEX") THEN DO:
      IF CAN-DO("INDEX,KEY":u,ilin[3]) THEN 
        ASSIGN iobj    = "i":u.             
      ELSE IF CAN-DO("INDEX,KEY",ilin[4]) THEN
        ASSIGN iobj    = "i".          
      ELSE IF CAN-DO("INDEX,KEY",ilin[5]) THEN
        ASSIGN iobj    = "i".             
    END.
    
    IF iobj = "d"  or startdf THEN DO: 
      CREATE df-info.
      ASSIGN df-info.df-seq = dfseq
             dfseq = dfseq + 1
             df-line = "UPDATE DATABASE " + '"' + mss_dbname + '"'. 
      ASSIGN startdf = FALSE.
    END.  
          
    IF iobj = "t" THEN DO:
      IF imod = "d" THEN DO:
        IF tablename <> ? AND tablename <> ilin[3] THEN 
          RUN write-tbl-sql.            
                         
       IF idxline <> ? THEN 
          RUN write-idx-sql.

       IF seq-line <> ? THEN
          RUN write-seq-sql.

       IF tablename <> ilin[3] THEN
         ASSIGN tablename = ilin[3]
                 comment_chars = ""
                 comment-out = FALSE.

        IF tablename <> ? THEN                             
          DISPLAY tablename WITH FRAME working.
    
        FIND FIRST DICTDB._File WHERE DICTDB._File._File-name = ilin[3]
                                  AND DICTDB._File._Owner = "_FOREIGN" NO-ERROR.
        IF AVAILABLE DICTDB._File THEN DO:
          PUT STREAM tosql UNFORMATTED comment_chars "DROP TABLE " DICTDB._File._For-name SKIP.
          PUT STREAM tosql UNFORMATTED  user_env[5] SKIP(1).
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = DICTDB._File._File-name
                 df-line = "DROP TABLE " + '"' + DICTDB._File._File-name + '"'.
        END.
        ELSE DO:
          MESSAGE "The Delta DF File contains DROP TABLE " ilin[3]  SKIP
                  "and table does not exist in the schema holder." SKIP
                  "This process is being aborted."  SKIP (1)
                  VIEW-AS ALERT-BOX ERROR.
          RETURN.
        END.
        ASSIGN ilin = ?.
      END. /* End delete table */

      /* Rename table */
      ELSE IF imod = "r" THEN DO:
        IF tablename <> ? AND tablename <> ilin[5] THEN 
          Run write-tbl-sql.                      
        
        IF idxline <> ? THEN 
          RUN write-idx-sql.
        
        IF seq-line <> ? THEN
          RUN write-seq-sql. 

        IF tablename <> ilin[5] THEN
          ASSIGN tablename = ilin[5]
                 comment_chars = ""
                 comment-out = FALSE.

        IF tablename <> ? THEN                              
          DISPLAY tablename WITH FRAME working.       
                      
        FIND FIRST DICTDB._File WHERE DICTDB._File._File-name = ilin[3]
                                  AND DICTDB._File._Owner = "_FOREIGN" NO-ERROR.
 
        IF AVAILABLE DICTDB._File THEN DO:     
          ASSIGN idx-number = 0.
          FOR EACH DICTDB._Index OF DICTDB._File:
            IF idx-number < DICTDB._Index._Idx-num THEN
              ASSIGN idx-number = DICTDB._Index._Idx-num.
          END.
          ASSIGN idx-number = idx-number + 1.
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = ilin[5]
                 df-line = "RENAME TABLE " + '"' + DICTDB._File._File-name + '" TO "' + ilin[5] + '"'.          
          
          CREATE rename-obj.
          ASSIGN rename-type = "T"
                 t-name = ilin[5]
                 old-name = DICTDB._File._File-name
                 new-name = ilin[5].
                  
          IF LENGTH(DICTDB._File._For-name) > 4 AND SUBSTRING(DICTDB._File._For-name, (LENGTH(DICTDB._File._For-name) - 4)) <> "_V##" THEN
            ASSIGN dsv-name = DICTDB._File._For-name.
          ELSE 
              ASSIGN dsv-name = SUBSTRING(DICTDB._File._For-name, 1,(LENGTH(DICTDB._File._For-name) -  4)).                   
        END.
        ELSE DO:
          MESSAGE "The Delta DF File contains RENAME TABLE" ilin[3] SKIP
                  "and table does not exist in the schema holder." SKIP
                  "This process is being aborted."  SKIP (1)
                  VIEW-AS ALERT-BOX ERROR.
          RETURN.
        END.
        ASSIGN ilin = ?. 
      END. /* End Rename Table */
      
      /* Add new table */
      ELSE IF imod = "a" THEN DO:                               
        IF ilin[1] = "ADD" AND ilin[2] = "TABLE" THEN DO: 
          RUN write-tbl-sql.
          
          IF idxline <> ? THEN 
             RUN write-idx-sql.

          IF seq-line <> ? THEN
            RUN write-seq-sql.
         
          ASSIGN addtable = TRUE
                 tablename = ilin[3]
                 fldnum = 0
                 idx-number = 1
                 comment_chars = ""
                 comment-out = FALSE.
                                                                                        
          FIND FIRST DICTDB._File WHERE DICTDB._File._File-name = tablename
                                    AND DICTDB._File._Owner = "_FOREIGN"
                                    NO-LOCK NO-ERROR.
          IF AVAILABLE DICTDB._File THEN DO:
            MESSAGE "The Delta DF File contains ADD TABLE" ilin[3] SKIP
                  "and table already exists in the schema holder." SKIP
                  "This process is being aborted."  SKIP (1)
                  VIEW-AS ALERT-BOX ERROR.
            RETURN.
          END.

          IF xlate THEN DO:       
            ASSIGN forname = ilin[3] + "," + idbtyp + "," + user_env[29].
            RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT forname).
          END.
          ELSE IF LENGTH(ilin[3]) > INTEGER(user_env[29]) THEN DO:   
            ASSIGN forname = ilin[3] + "," + idbtyp + "," + user_env[29].
            RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT forname).
          END.
          ELSE
            ASSIGN forname = ilin[3].
 
          _verify-table:
          DO WHILE TRUE:

            FIND FIRST verify-table WHERE verify-table.tnew-name = forname NO-ERROR.
            FIND FIRST DICTDB._File WHERE CAPS(DICTDB._File._For-name) = CAPS(forname) NO-ERROR.
            
            IF AVAILABLE verify-table OR AVAILABLE DICTDB._File THEN DO:
              DO a = 1 TO 999:
                IF a = 1 THEN
                  ASSIGN forname = forname + STRING(a).
                ELSE
                  ASSIGN forname = SUBSTRING(forname, 1, LENGTH(forname) - LENGTH(STRING(a))) + STRING(a). 
                IF CAN-FIND(FIRST DICTDB._File WHERE DICTDB._File._For-name = forname) THEN NEXT.
                ELSE IF CAN-FIND(FIRST verify-table WHERE verify-table.tnew-name = forname) THEN NEXT.
                ELSE DO:
                  CREATE verify-table.
                  ASSIGN verify-table.tnew-name = forname.
                  LEAVE _verify-table.
                END.
              END.
            END.                
            ELSE DO:
              CREATE verify-table.
              ASSIGN verify-table.tnew-name = forname.
              LEAVE _verify-table.
            END.
          END.

          RUN create-new-obj (INPUT "T", INPUT ?).
          
          IF tablename <> ? THEN    
            DISPLAY tablename WITH FRAME working.   

          IF pcompatible THEN DO: 
                   
            CREATE sql-info.
            ASSIGN line-num = 5000
                   line = "PROGRESS_RECID BIGINT NULL"  
                   tblname = ilin[3]
                   fldname = "PROGRESS_RECID".     
            CREATE sql-info.
            ASSIGN line-num = 5001
                   line = "PROGRESS_RECID_IDENT_ BIGINT identity"  
                   tblname = ilin[3]
                   fldname = "PROGRESS_RECID_INDENT".
          END.          
            
          CREATE sql-info.
          ASSIGN line-num = -8
                 line = "if (select name from sysobjects where name = '" + forname + "'"
                 tblname = ilin[3].
            
          CREATE sql-info.
          ASSIGN line-num = -7
                 line = "and type = 'U' and uid = (select uid from sysusers " 
                 tblname = ilin[3].

          CREATE sql-info.
          ASSIGN line-num = -6
                 line = "where sid = (select sid from master.dbo.syslogins " 
                 tblname = ilin[3].

          CREATE sql-info.
          ASSIGN line-num = -5
                 line = "where UPPER(name) = UPPER('" + mss_username + "'))))"
                 tblname = ilin[3].
          CREATE sql-info.
          ASSIGN line-num = -4
                 line = "is not NULL drop table " + forname 
                 tblname = ilin[3].
          CREATE sql-info.
          ASSIGN line-num = -3
                 line = "go" 
                 tblname = ilin[3].
          CREATE sql-info.
          ASSIGN line-num = -2
                 line = " " 
                 tblname = ilin[3].

          CREATE sql-info.
          ASSIGN lnum = 1 
                 line-num = lnum
                 line = 'CREATE TABLE ' + mss_username + '.' + forname +  ' ('
                 tblname = ilin[3].
                
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = tablename
                 df-line = ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '"'.
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = tablename
                 df-line = '  FOREIGN-NAME "' + LOWER(forname) + '"'.

          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = tablename
                 df-line = '  FOREIGN-TYPE "TABLE" '.
          IF mss_username <> "" THEN DO:
            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-info.df-tbl = tablename
                   df-line = '  FOREIGN-OWNER "' + LOWER(mss_username) + '"'.
          END.
        END.
        ELSE DO:          
          CASE ilin[1]:
            WHEN "AREA" THEN . /* Don't assign the Area it will default to 6 */
            WHEN "CAN-INSERT" OR WHEN "CAN-READ" OR WHEN "CAN-WRITE" OR
            WHEN "CAN-UPDATE" OR WHEN "CAN-DELETE" OR WHEN "CAN-DUMP" OR
            WHEN "CAN-LOAD" OR WHEN "CAN-SELECT" THEN DO:
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tablename
                     df-line = "  " + ilin[1] + ' "' + ilin[2] + '"'.
            END.
            WHEN "LABEL" OR WHEN "LABEL-SA" OR WHEN "DESCRIPTION" OR WHEN "VALEXP" OR
            WHEN "VALMSG" OR WHEN "VALMSG-SA" THEN DO:
              RUN dctquot (ilin[2], '"',OUTPUT oq-string).
              IF LENGTH(oq-string) > 0 THEN DO:
                CREATE df-info.
                ASSIGN df-info.df-seq = dfseq
                       dfseq = dfseq + 1
                       df-info.df-tbl = tablename
                       df-line = "  " + ilin[1] + " " + oq-string.
              END.
            END.
 
            WHEN "FROZEN" THEN DO:
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tablename
                     df-line = "  " + ilin[1] + ' "' + ilin[2] + '"'.
            END.
            WHEN "HIDDEN" THEN DO:
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tablename
                     df-line = "  " + ilin[1] + ' "' + ilin[2] + '"'.
            END.
            WHEN "DUMP-NAME" THEN DO:
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tablename
                     df-line = "  " + ilin[1] + ' "' + ilin[2] + '"'.
            END.
            WHEN "FILE-TRIGGER" OR WHEN "TABLE-TRIGGER" THEN DO:             
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-info.df-tbl = tablename
                   df-line =  "  " + ilin[1] +  ' "' + ilin[2] + '" ' + 
                              ilin[3] + " ". 
             IF ilin[4] <> ? THEN
                 ASSIGN df-line = df-line + ilin[4].            
             IF ilin[5] <> ? THEN 
                 ASSIGN df-line = df-line + ' "' + ilin[5] + '" '.             
             IF ilin[6] <> ? THEN 
                 ASSIGN df-line = df-line + ilin[6].            
             IF ilin[7] <> ? THEN
                 ASSIGN df-line = df-line + ' "' + ilin[7] + '"'.
            END.
          END CASE. 
        END.
        ASSIGN ilin = ?.
      END. /* End Add Table section */
      
      /* Update or modify table attributes are for df only */
      ELSE DO: 
        IF ilin[1] = "UPDATE" THEN DO: 
          IF tablename <> ? AND tablename <> ilin[3] THEN 
            RUN write-tbl-sql.                     
         
          FIND DICTDB._File where DICTDB._File._File-name = ilin[3] NO-ERROR.
          IF NOT AVAILABLE DICTDB._File THEN DO:
            FIND rename-obj WHERE rename-type = "T"
                              AND new-name = ilin[3] NO-ERROR.
            IF AVAILABLE rename-obj THEN
              FIND DICTDB._File where DICTDB._File._File-name = old-name NO-ERROR.
          END.
          IF NOT AVAILABLE DICTDB._File THEN DO:
            MESSAGE "The Delta DF File contains UPDATE TABLE" ilin[3] SKIP
                    "and table does not exist in the schema holder." SKIP
                    "This process is being aborted."  SKIP (1)
                    VIEW-AS ALERT-BOX ERROR.
            RETURN.
          END.
          IF AVAILABLE DICTDB._File THEN DO:
            ASSIGN idx-number = 0.
            FOR EACH DICTDB._Index OF DICTDB._File:
              IF idx-number < DICTDB._Index._Idx-num THEN
                ASSIGN idx-number = DICTDB._Index._Idx-num.
            END.
            IF idx-number > 0 THEN
              ASSIGN idx-number = idx-number + 1.
          END.
          IF idxline <> ? THEN 
            RUN write-idx-sql.
          
          IF seq-line <> ? THEN
            RUN write-seq-sql.
          
          IF tablename <> ilin[3] THEN
            ASSIGN tablename = ilin[3]
                   comment_chars = ""
                   comment-out = FALSE.

          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = tablename
                 df-line = ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '"'.
        END.  
                
        IF tablename <> ? THEN                             
          DISPLAY tablename WITH FRAME working.
           
        CASE ilin[1]:
          WHEN "LABEL"  OR WHEN "LABEL-SA" OR WHEN "DESCRIPTION" OR
          WHEN "VALEXP" OR WHEN "VALMSG"   OR WHEN "VALMSG-SA"   OR
          WHEN "DUMP-NAME" THEN DO:            
            RUN dctquot (ilin[2], '"',OUTPUT oq-string).
            IF ilin[2] = ? THEN DO:
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tablename
                     df-line = "  " + ilin[1] + " ?".
            END.               
            ELSE IF LENGTH(oq-string) > 0 THEN DO:
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tablename
                     df-line = "  " + ilin[1] + " " + oq-string.
            END.
          END.
          WHEN "FROZEN"  OR WHEN "HIDDEN" THEN DO:
           CREATE df-info.
           ASSIGN df-info.df-seq = dfseq
                  dfseq = dfseq + 1
                  df-info.df-tbl = tablename
                  df-line = "  " + ilin[1].
          END.
          WHEN "FILE-TRIGGER" OR WHEN "TABLE-TRIGGER"  THEN DO:            
            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-info.df-tbl = tablename
                   df-line =  "  " + ilin[1] +  ' "' + ilin[2] + '" ' + 
                              ilin[3] + " ". 
             IF ilin[4] <> ? THEN
                 ASSIGN df-line = df-line + ilin[4].             
             IF ilin[5] <> ? THEN 
                 ASSIGN df-line = df-line + ' "' + ilin[5] + '" '.             
             IF ilin[6] <> ? THEN 
                 ASSIGN df-line = df-line + ilin[6].             
             IF ilin[7] <> ? THEN
                 ASSIGN df-line = df-line + ' "' + ilin[7] + '"'.
          END.
        END CASE. 
        ASSIGN ilin = ?.
      END.                                    
    END.  /* End TABLE Section */
    
    IF iobj = "f" THEN DO:               
                         
      IF imod = "d" THEN DO:
        IF tablename <> ? AND tablename <> ilin[5] THEN 
          RUN write-tbl-sql.                 
        
        IF idxline <> ? THEN 
          RUN write-idx-sql.

        IF seq-line <> ? THEN
          RUN write-seq-sql.
     
        IF tablename <> ilin[5] THEN
          ASSIGN tablename = ilin[5]
                 comment_chars = ""
                 comment-out = FALSE.

        IF tablename <> ? THEN  
          DISPLAY tablename WITH FRAME working.
          
                
        FIND FIRST rename-obj WHERE rename-type = "T"
                                AND new-name = ilin[5]
                                NO-ERROR.
        IF NOT AVAILABLE rename-obj THEN
          FIND FIRST DICTDB._File WHERE DICTDB._File._File-name = ilin[5]
                                    AND DICTDB._File._Owner = "_FOREIGN" NO-ERROR.
        ELSE FIND FIRST DICTDB._File WHERE DICTDB._File._File-name = rename-obj.old-name
                                       AND DICTDB._File._Owner = "_FOREIGN" NO-ERROR.
        IF NOT AVAILABLE DICTDB._File THEN DO:
          MESSAGE "The Delta DF File contains DROP FIELD for table" ilin[5] SKIP
                  "and table does not exist in the schema holder." SKIP
                  "This process is being aborted."  SKIP (1)
               VIEW-AS ALERT-BOX ERROR.
          RETURN.
        END.
        IF AVAILABLE DICTDB._File THEN DO:
          FIND FIRST rename-obj WHERE rename-type = "F"
                                  AND t-name = ilin[5]
                                  AND new-name = ilin[3]
                                  NO-ERROR.
          IF AVAILABLE rename-obj THEN
            FIND DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Field-name = old-name NO-ERROR.
          ELSE
            FIND DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Field-name = ilin[3] NO-ERROR.
            
          IF NOT AVAILABLE DICTDB._Field THEN DO:
            MESSAGE "The Delta DF File contains DROP FIELD" ilin[3] "for table" SKIP
                    ilin[5] "and field does not exist in the schema holder." SKIP
                    "This process is being aborted."  SKIP (1)
                VIEW-AS ALERT-BOX ERROR.
            RETURN.
          END.

          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = tablename
                 df-line =  ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '" ' +
                            ilin[4] + ' "' + ilin[5] + '"'.
       
          ASSIGN dropped-fld = TRUE.

          IF AVAILABLE DICTDB._Field THEN DO:
            IF DICTDB._Field._Extent = 0 THEN DO:
              /* Get the first 15 or less start of name */
              ASSIGN dftname = "DF__" + 
                               (IF LENGTH(DICTDB._File._For-name) < 9 THEN DICTDB._File._For-name 
                                ELSE SUBSTRING(DICTDB._File._For-name, 1, 9))
                     dftname = dftname + "__".
              /* Get part of column name and append to dftname */
              ASSIGN dftname = dftname + SUBSTRING(DICTDB._Field._For-name, 1, (20 - LENGTH(dftname))).

              /*Must drop the default constraint before the field can be dropped */
              PUT STREAM tosql UNFORMATTED comment_chars "DECLARE @Name varchar(50)" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "DECLARE def_cursor CURSOR FOR select name from sysobjects where parent_obj = "
                    " OBJECT_ID('" DICTDB._File._For-owner "." DICTDB._File._For-Name "')" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "and xtype = 'D'" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "and substring(name, 1," LENGTH(dftname) ") = '" dftname "'" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "OPEN def_cursor" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "FETCH NEXT FROM def_cursor INTO @Name" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "IF @@FETCH_STATUS = 0 BEGIN" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars " exec('Alter table " DICTDB._File._For-owner "." DICTDB._File._For-Name " drop constraint ' + @Name + '')" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "END" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "CLOSE def_cursor" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "DEALLOCATE def_cursor" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP.

              PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " + DICTDB._File._For-owner "." DICTDB._File._For-name + 
                               " DROP COLUMN " + DICTDB._Field._For-name SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP(1).
              CREATE drop-field.
              ASSIGN f-name = ilin[3]
                     of-table = ilin[5]
                     dropped-fld = TRUE.

              FIND FIRST rename-obj WHERE rename-type = "F"
                                      AND t-name = ilin[5]
                                      AND new-name = ilin[3]
                                      NO-ERROR.
              IF AVAILABLE rename-obj THEN
                ASSIGN drop-f-name = old-name.
              ELSE                       
                ASSIGN drop-f-name = ilin[3].
            END.
            ELSE DO u = 1 TO DICTDB._Field._Extent:
              /* Get the first 15 or less start of name */
              ASSIGN dftname = "DF__" + 
                               (IF LENGTH(DICTDB._File._For-name) < 9 THEN DICTDB._File._For-name 
                                ELSE SUBSTRING(DICTDB._File._For-name, 1, 9))
                     dftname = dftname + "__".
              /* Get part of column name and append to dftname */
              ASSIGN dftname = dftname + SUBSTRING(DICTDB._Field._For-name, 1, (20 - LENGTH(dftname))).

              /*Must drop the default constraint before the field can be dropped */
              PUT STREAM tosql UNFORMATTED comment_chars "DECLARE @Name varchar(50)" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "DECLARE def_cursor CURSOR FOR select name from sysobjects where parent_obj = "
                    " OBJECT_ID('" DICTDB._File._For-owner "." DICTDB._File._For-Name "')" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "and xtype = 'D'" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "and substring(name, 1," LENGTH(dftname) ") = '" dftname "'" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "OPEN def_cursor" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "FETCH NEXT FROM def_cursor INTO @Name" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "IF @@FETCH_STATUS = 0 BEGIN" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars " exec('Alter table " DICTDB._File._For-owner "." DICTDB._File._For-Name " drop constraint ' + @Name + '')" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "END" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "CLOSE def_cursor" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "DEALLOCATE def_cursor" SKIP.
              PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP.

              PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " DICTDB._File._For-owner "." DICTDB._File._For-Name  
                      " DROP COLUMN " DICTDB._Field._For-name "##" string(u) SKIP.  
              PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP.
              IF u = 1 THEN DO:
                CREATE drop-field.
                ASSIGN f-name = ilin[3]
                       of-table = ilin[5]
                       dropped-fld = TRUE.
           
                FIND FIRST rename-obj WHERE rename-type = "F"
                                        AND t-name = ilin[5]
                                        AND new-name = ilin[3]
                                        NO-ERROR.
                IF AVAILABLE rename-obj THEN
                  ASSIGN drop-f-name = old-name.
                ELSE                       
                  ASSIGN drop-f-name = ilin[3].
              END.
            END.
            PUT STREAM tosql UNFORMATTED comment_chars " " SKIP.
          END.
        END.
        ASSIGN ilin = ?.
      END. /* End delete field */ 
                
      /* Rename field in schema holder only */          
      ELSE IF imod = "r" THEN DO:
        IF tablename <> ? AND tablename <> ilin[5] THEN 
          RUN write-tbl-sql.
                            
        IF idxline <> ? THEN 
          RUN write-idx-sql.
        
        IF seq-line <> ? THEN
          RUN write-seq-sql.

        IF tablename <> ilin[5] THEN
          ASSIGN tablename = ilin[5]
                 comment_chars = ""
                 comment-out = FALSE.

        IF tablename <> ? THEN
          DISPLAY tablename WITH FRAME working.
       
        FIND DICTDB._File WHERE DICTDB._File._File-name = ilin[5] NO-ERROR.       
        IF AVAILABLE DICTDB._File THEN DO:
          FIND DICTDB._Field OF DICTDB._FILE WHERE DICTDB._Field._Field-name = ilin[3]
                                             NO-ERROR.
          IF AVAILABLE DICTDB._Field THEN DO:                                   
            CREATE rename-obj.
            ASSIGN rename-type = "F"
                   t-name = ilin[5]
                   old-name = ilin[3]
                   new-name = ilin[7]
                   dsv-name = DICTDB._Field._For-name.
          END.
          ELSE DO:
            FIND rename-obj WHERE rename-type = "F"
                              AND t-name = ilin[5]
                              AND new-name = ilin[3]
                              NO-ERROR.
            IF AVAILABLE rename-obj THEN 
              ASSIGN new-name = ilin[7].         
          END.
        END.    
        ELSE DO:       
          _rename-loop:
          FOR EACH rename-obj WHERE rename-type = "T"
                                AND new-name = ilin[5]:
          
            FIND DICTDB._File WHERE DICTDB._File._File-name = old-name NO-ERROR.
            IF AVAILABLE DICTDB._File THEN 
              LEAVE _rename-loop.
          END.
          IF NOT AVAILABLE DICTDB._File THEN DO:
             MESSAGE "The Delta DF File contains RENAME FIELD for table" ilin[5] SKIP
                     "and table does not exist in the schema holder." SKIP
                     "This process is being aborted."  SKIP (1)
                  VIEW-AS ALERT-BOX ERROR.
             RETURN.
          END.
          IF AVAILABLE DICTDB._File THEN DO:               
            FIND DICTDB._Field OF DICTDB._FILE WHERE DICTDB._Field._Field-name = ilin[3]
                                             NO-ERROR.
            IF AVAILABLE DICTDB._Field THEN DO:                                   
              CREATE rename-obj.
              ASSIGN rename-type = "F"
                     t-name = ilin[5]
                     old-name = ilin[3]
                     new-name = ilin[7]
                     dsv-name = DICTDB._Field._For-name.                  
            END.
            ELSE DO:
              FIND rename-obj WHERE rename-type = "F"
                                AND t-name = tablename
                                AND new-name = ilin[3]
                                  NO-ERROR.
              IF NOT AVAILABLE rename-obj THEN DO:           
                FIND DICTDB._Field OF DICTDB._FILE WHERE DICTDB._Field._Field-name = old-name
                                               NO-ERROR.
                IF NOT AVAILABLE DICTDB._Field THEN DO:
                  MESSAGE "The Delta DF File contains RENAME FIELD" ilin[3] "for table" ilin[5] SKIP
                          "and field does not exist in the schema holder." SKIP
                          "This process is being aborted."  SKIP (1)
                  VIEW-AS ALERT-BOX ERROR.
                  RETURN.
                END.
                IF AVAILABLE DICTDB._Field THEN DO:
                  CREATE rename-obj.                                                   
                  ASSIGN rename-type = "F"
                         t-name = tablename
                         old-name = DICTDB._Field._Field-name
                         new-name = ilin[7]
                         dsv-name = DICTDB._Field._For-name.
                END.
              END.
            END.
          END.
        END.
        IF ilin[1] <> ? THEN do:
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = tablename
                 df-line = ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '" ' +
                           ilin[4] + ' "' + ilin[5] + '" ' + ilin[6] + ' "' + ilin[7] + '"'.
        END.  
        ASSIGN ilin = ?.             
      END.
      
      /* Add field */            
      ELSE IF imod = "a" THEN DO:
        IF ilin[1] = "ADD" AND ilin[2] = "FIELD" THEN DO:  

           /* Verify we are working the same table */
          IF tablename <> ? AND tablename <> ilin[5] THEN 
            RUN write-tbl-sql.                        

          IF idxline <> ? THEN 
            RUN write-idx-sql.
          
          IF seq-line <> ? THEN
            RUN write-seq-sql.

          IF tablename <> ilin[5] THEN
            ASSIGN tablename = ilin[5]
                   comment_chars = ""
                   comment-out = FALSE.

          IF tablename <> ? THEN       
            DISPLAY tablename WITH FRAME WORKING.                       
 
          FIND rename-obj WHERE rename-type = "F"
                            AND new-name = ilin[3]
                            AND t-name = ilin[5]
                            NO-ERROR.
          IF AVAILABLE rename-obj THEN 
            ASSIGN fieldname = "a##" + SUBSTRING(ilin[3], 1, (INTEGER(user_env[29]) - 3)).             
          ELSE                  
            ASSIGN fieldname = ilin[3].
          
          IF xlate THEN DO:           
            IF LENGTH(fieldname) > INTEGER(user_env[29]) THEN DO: 
              IF fieldname BEGINS "a##" THEN                   
                ASSIGN fieldname = SUBSTRING(fieldname, 4, (INTEGER(user_env[29]) - 3)) + "," + idbtyp + "," + user_env[29]
                       dupfield = TRUE.
              ELSE
                ASSIGN fieldname = SUBSTRING(fieldname, 1, (INTEGER(user_env[29]))) + "," + idbtyp + "," + user_env[29]
                       dupfield = FALSE.
              RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT fieldname).
              IF dupfield THEN
                ASSIGN fieldname = "A##" + fieldname
                       dupfield = FALSE.
            END.
            ELSE DO:  
              IF fieldname BEGINS "a##" THEN
                ASSIGN fieldname = SUBSTRING(fieldname,4) + "," + idbtyp + "," + user_env[29]
                       dupfield = TRUE.
              ELSE 
                ASSIGN fieldname = fieldname + "," + idbtyp + "," + user_env[29]
                       dupfield = FALSE.
              RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT fieldname).
              IF dupfield THEN
                ASSIGN fieldname = "A##" + fieldname
                       dupfield = FALSE.
            END.
          END.   
                                           
           _verify-field:
          DO WHILE TRUE:

            FIND FIRST verify-field WHERE verify-field.f-table = tablename
                                      AND verify-field.fnew-name = fieldname NO-ERROR.
            FIND FIRST DICTDB._File WHERE DICTDB._File._file-name = tablename NO-ERROR.
            IF AVAILABLE DICTDB._File THEN
                FIND FIRST DICTDB._Field WHERE DICTDB._Field._File-recid = RECID(DICTDB._File)
                                           AND DICTDB._Field._For-name = fieldname NO-ERROR.
            IF AVAILABLE verify-field OR AVAILABLE DICTDB._Field THEN DO:
              DO a = 1 TO 999:
                IF a = 1 THEN
                  ASSIGN fieldname = fieldname + STRING(a).
                ELSE
                  ASSIGN fieldname = SUBSTRING(fieldname, 1, LENGTH(fieldname) - LENGTH(STRING(a))) + STRING(a). 
                IF CAN-FIND(FIRST DICTDB._Field WHERE DICTDB._Field._File-recid = RECID(DICTDB._File)
                                                  AND DICTDB._Field._For-name = fieldname) THEN NEXT.
                ELSE IF CAN-FIND(FIRST verify-field WHERE verify-field.f-table = tablename
                                                      AND verify-field.fnew-name = fieldname) THEN NEXT.
                ELSE DO:
                  CREATE verify-field.
                  ASSIGN verify-field.f-table = tablename
                         verify-field.fnew-name = fieldname.
                  LEAVE _verify-field.
                END.
              END.
            END.                
            ELSE DO:
              CREATE verify-field.
              ASSIGN verify-field.f-table = tablename
                     verify-field.fnew-name = fieldname.
              LEAVE _verify-field.
            END.
          END.



          ASSIGN fieldtype = ilin[7].
     
          IF NOT addtable THEN DO: 
            IF NOT alt-table THEN DO:                                                
              FIND DICTDB._File WHERE DICTDB._File._File-name = ilin[5]
                                  AND DICTDB._File._Owner = "_FOREIGN" NO-ERROR.
              IF AVAILABLE DICTDB._File THEN DO: 
                ASSIGN forname = DICTDB._File._For-owner + "." + DICTDB._File._For-Name.                  
                
                CREATE alt-info.
                ASSIGN lnum = 1
                       a-line-num = lnum
                       a-line = "ALTER TABLE " + forname + " ADD" 
                       a-tblname = ilin[5]
                       a-fldname = fieldname.                       
              END.          
              ELSE IF NOT AVAILABLE DICTDB._File THEN DO:
                FIND rename-obj WHERE rename-type = "T"
                                  AND new-name = ilin[5] NO-ERROR.


                IF AVAILABLE rename-obj THEN DO:
                  FIND DICTDB._File WHERE DICTDB._File._File-name = old-name NO-ERROR.
                  IF NOT AVAILABLE DICTDB._File THEN DO:
                    MESSAGE "The Delta DF File contains ADD FIELD for table" ilin[5] SKIP
                            "and table does not exist in the schema holder." SKIP
                            "This process is being aborted."  SKIP (1)
                         VIEW-AS ALERT-BOX ERROR.
                    RETURN.
                  END.         
                  ASSIGN forname = DICTDB._File._For-owner + "." + DICTDB._File._For-name
                         fieldtype = ilin[7].
                  CREATE alt-info.
                  ASSIGN lnum = 1
                         a-line-num = lnum
                         a-line = "ALTER TABLE " + forname + " ADD"
                         a-tblname = ilin[5]
                         a-fldname = fieldname.
                            
                END.
                ELSE DO:
                  MESSAGE "The Delta DF File contains ADD FIELD for table" ilin[5] SKIP
                            "and table does not exist in the schema holder." SKIP
                            "This process is being aborted."  SKIP (1)
                         VIEW-AS ALERT-BOX ERROR.
                  RETURN.    
                END.
              END.
              ASSIGN alt-table = TRUE.
            END.
          END.          
          
          RUN create-new-obj (INPUT "F", INPUT ?).          
          ASSIGN fldnum = fldnum + 1.
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = tablename
                 df-line = ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '" ' +
                           ilin[4] + ' "' + ilin[5] + '" ' + ilin[6] + ' ' + ilin[7].
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = tablename
                 df-line = '  FOREIGN-NAME "' + LOWER(fieldname) + '"'. 

          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = tablename
                 df-line = '  QUOTED-NAME """' + CAPS(fieldname) + '"""'.
        END. /* End first line of add field */                      
        ELSE DO:
          CASE ilin[1]:
            WHEN "FORMAT" THEN DO:
              FIND new-obj WHERE new-obj.add-type = "F"
                             AND new-obj.tbl-name = tablename
                             AND new-obj.fld-name = fieldname
                             NO-LOCK NO-ERROR. 
                              
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tablename
                     df-info.df-fld = fieldname.

              IF sqlwidth AND (new-obj.for-type = " VARCHAR" OR new-obj.for-type = " NVARCHAR") THEN
                ASSIGN df-line = "  " + ilin[1] + ' "'.
              ELSE
                ASSIGN df-line = "  " + ilin[1] + ' "' + ilin[2] + '"'.

              IF available new-obj THEN DO:
                IF alt-table THEN DO:
                  CREATE alt-info.
                  ASSIGN lnum = lnum + 1
                         a-line-num = lnum
                         a-tblname = tablename
                         a-fldname = fieldname.
                END.
                ELSE DO:         
                  CREATE sql-info.
                  ASSIGN lnum = lnum + 1
                         line-num = lnum
                         tblname = tablename
                         fldname = fieldname.
                         
                END.
              END.              
              IF fieldtype = "character" THEN DO:
                ASSIGN nbrchar = 0 
                       lngth = LENGTH(ilin[2], "character").  
                IF INDEX(ilin[2], "(") > 1 THEN DO:
                  ASSIGN left_paren = INDEX(ilin[2], "(")
                         right_paren = INDEX(ilin[2], ")")
                         lngth = right_paren - (left_paren + 1)        
                         j = INTEGER(SUBSTRING(ilin[2], left_paren + 1, lngth)).  
                  /* user can turn off the x(8) override */
                  IF j = 8 AND sqlwidth = FALSE THEN j = minwidth.
                END.  
                ELSE DO:           
                  DO z = 1 to lngth:        
                    IF SUBSTRING(ilin[2],z,1) = "9" OR
                       SUBSTRING(ilin[2],z,1) = "N" OR   
                       SUBSTRING(ilin[2],z,1) = "A" OR    
                       SUBSTRING(ilin[2],z,1) = "x" OR
                       SUBSTRING(ilin[2],z,1) = "!"   THEN
                         ASSIGN nbrchar = nbrchar + 1.
                  END.         
                  IF nbrchar > 0 THEN
                    ASSIGN j = nbrchar.
                  ELSE
                    ASSIGN j = lngth.   
                  /* user can turn off the x(8) override */
                  IF j = 8 AND sqlwidth = FALSE THEN j = minwidth.
                END.       

                /* expand length - unicode support */
                IF user_env[35] = "y" THEN
                    j = j * 2.

                IF j < varlngth THEN DO:              
                  IF AVAILABLE new-obj THEN
                    ASSIGN new-obj.for-type = /*" VARCHAR("*/ " " + user_env[11] + "(" + STRING(j) + ")" 
                           dffortype = user_env[11]. /*"VARCHAR"*/
                END.
                ELSE  /* >  */                     
                  IF AVAILABLE new-obj THEN
                    ASSIGN new-obj.for-type = " " + user_env[18] /*" TEXT"*/
                           dffortype = /*"TEXT"*/ user_env[18].                       
                
                ASSIGN lngth = j.   
              END. /* Character datatype */
              ELSE IF fieldtype = "integer" THEN DO: 
                IF AVAILABLE new-obj THEN
                  ASSIGN new-obj.for-type = " INTEGER"
                         dffortype = "INTEGER"
                         lngth = 22.                                                            
              END.
              ELSE IF fieldtype = "int64" THEN DO:
                  IF AVAILABLE new-obj THEN
                       ASSIGN new-obj.for-type = " BIGINT"
                         dffortype = "BIGINT"
                         lngth = 22.    
              END.
              ELSE IF fieldtype = "decimal" THEN DO:                    
                ASSIGN lngth = LENGTH(ilin[2], "character")
                       all_digits = 0
                       dec_point = 0.
                     /* First, count all the digits in the format. */
                DO pos = 1 to lngth:
                  if (SUBSTRING(ilin[2], pos, 1) = ">") OR 
                     (SUBSTRING(ilin[2], pos, 1) = "<") OR  
                     (SUBSTRING(ilin[2], pos, 1) = "*") OR  
                     (SUBSTRING(ilin[2], pos, 1) = "z") OR 
                     (SUBSTRING(ilin[2], pos, 1) = "Z") OR
                     (SUBSTRING(ilin[2], pos, 1) = "9") THEN
                         ASSIGN all_digits = all_digits + 1.   
                  ELSE IF (SUBSTRING(ilin[2],pos,1)) = "."  THEN
                      ASSIGN dec_point = all_digits + 1.            
                END.
                IF AVAILABLE new-obj THEN DO:
                  IF dec_point > 0 THEN
                    ASSIGN new-obj.for-type = " DECIMAL (" + string(all_digits) + "," +
                                    string(all_digits - dec_point + 1) + ")".
                  ELSE
                    ASSIGN new-obj.for-type = " DECIMAL (" + string(all_digits) + ",0)".

                  ASSIGN dffortype = "DECIMAL"
                         lngth = 22
                         dec_point = (IF dec_point > 0 THEN all_digits - (dec_point - 1)
                                      ELSE 0) .
                END.
              END.
              ELSE if fieldtype = "date" AND AVAILABLE new-obj THEN
                ASSIGN new-obj.for-type = " DATETIME"
                       dffortype = "TIMESTAMP"
                       lngth     = 7. 
              ELSE IF fieldtype = "logical" AND AVAILABLE new-obj THEN
                /*OE00164229 - logical should map to tinyint */
                ASSIGN new-obj.for-type = " TINYINT"
                       dffortype = "TINYINT"
                       lngth = 1
                       dec_point = 0
                       all_digits = 3.
              ELSE IF fieldtype = "Recid" AND AVAILABLE new-obj THEN
                ASSIGN new-obj.for-type = " INTEGER"
                       dffortype = "INTEGER"
                       lngth = 22. 
              ELSE IF new-obj.for-type = "" OR new-obj.for-type = ? THEN
                ASSIGN new-obj.for-type = " UNSUPPORTED".
             
              IF AVAILABLE sql-info THEN 
                ASSIGN line = fieldname + new-obj.for-type.                        
              ELSE IF AVAILABLE alt-info THEN DO:              
                ASSIGN a-line = fieldname + new-obj.for-type. 
                RUN get-position.
              END.    
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tablename
                     df-info.df-fld = fieldname
                     df-line = '  FOREIGN-TYPE "' + dffortype + '"'.
              
              IF all_digits <> 0 THEN DO:
                CREATE df-info.
                ASSIGN df-info.df-seq = dfseq
                       dfseq = dfseq + 1
                       df-info.df-tbl = tablename
                       df-line = "  DSRVR-PRECISION " + STRING(all_digits).
                CREATE df-info.
                ASSIGN df-info.df-seq = dfseq
                       dfseq = dfseq + 1
                       df-info.df-tbl = tablename
                       df-info.df-fld = fieldname
                       df-line = "  FIELD-MISC12 " + STRING(dec_point).
              END.
                
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tablename
                     df-info.df-fld = fieldname
                     df-line = "  FIELD-MISC13 " + STRING(lngth).
                 
              /* OE00164229 - don't set this for logical */
              IF fieldtype NE "logical" THEN DO:
                  CREATE df-info.
                  ASSIGN df-info.df-seq = dfseq
                         dfseq = dfseq + 1
                         df-info.df-tbl = tablename
                         df-info.df-fld = fieldname
                         df-line = "  FOREIGN-MAXIMUM " + string(lngth).
              END.

              /* 20061005-003 - missing this for character fields */
              IF fieldtype = "character" THEN DO:
                  CREATE df-info.
                  ASSIGN df-info.df-seq = dfseq
                         dfseq = dfseq + 1
                         df-info.df-tbl = tablename
                         df-info.df-fld = fieldname
                         df-line = "  DSRVR-PRECISION " + string(lngth).
              END.

              ASSIGN all_digits = 0
                     dec_point  = 0.            
            END. /* WHEN FORMAT */                           
            WHEN "QUOTED-NAME"     OR WHEN "FIELD-MISC21"  OR WHEN "FIELD-MISC23"    OR 
            WHEN "FIELD-MISC24"    OR WHEN "FIELD-MISC25"  OR WHEN "FIELD-MISC26"    OR 
            WHEN "FIELD-MISC27"    OR WHEN "FIELD-MISC28"  OR WHEN "MISC-PROPERTIES" OR 
            WHEN "SHADOW-NAME"     OR WHEN "DESC"          OR WHEN "DESCRIPTION"     OR 
            WHEN "CAN-READ"        OR WHEN "CAN-SELECT"    OR WHEN "CAN-WRITE"       OR 
            WHEN "CAN-UPDATE"      OR WHEN "NULL"          OR WHEN "FORMAT-SA"       OR 
            WHEN "LABEL"           OR WHEN "LABEL-SA"      OR WHEN "COLUMN-LABEL"    OR 
            WHEN "COLUMN-LABEL-SA" OR WHEN "INITIAL-SA"    OR WHEN "VALEXP"          OR 
            WHEN "VALMSG"          OR WHEN "VALMSG-SA"     OR WHEN "VIEW-AS"         OR 
            WHEN "HELP"            OR WHEN "HELP-SA"       THEN DO:    
              IF ilin[2] <> "" AND ilin[2] <> ? THEN DO:
                RUN dctquot (ilin[2], '"',OUTPUT oq-string).
                IF LENGTH(oq-string) > 0 THEN DO:
                  CREATE df-info.
                  ASSIGN df-info.df-seq = dfseq
                       dfseq = dfseq + 1
                       df-info.df-tbl = tablename
                       df-line =  "  " + ilin[1] + " " + oq-string.
                END.
              END.
            END.
            WHEN "INITIAL" THEN DO:
              FIND new-obj WHERE new-obj.add-type = "F"
                             AND new-obj.tbl-name = tablename
                             AND new-obj.fld-name = fieldname
                             NO-LOCK NO-ERROR. 
                               
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tablename.
              IF ilin[2] <> ? THEN
                ASSIGN df-line = "  " + ilin[1] + '  "' + ilin[2] + '"'.
              ELSE
                ASSIGN df-line = "  " + ilin[1] + " ?".

              IF dflt THEN  DO:
                IF available new-obj AND ilin[2] <> "" AND ilin[2] <> ? AND ilin[2] <> "?" THEN DO:
                  IF alt-table THEN DO:   
                    IF AVAILABLE alt-info THEN DO: 
                      IF a-tblname <> tablename AND
                         a-fldname <> fieldname THEN                  
                      FIND alt-info WHERE a-tblname = tablename
                                      AND a-fldname = fieldname
                                      NO-ERROR.
                    END.
                    ELSE 
                      FIND alt-info WHERE a-tblname = tablename
                                      AND a-fldname = fieldname
                                      NO-ERROR.
                  END.
                  ELSE          
                    FIND sql-info WHERE tblname = tablename
                                    AND fldname = fieldname
                                    NO-ERROR.
 
                  ASSIGN for-init = "".
                   /* Character */ 
                  IF new-obj.for-type BEGINS " VARCHAR" OR new-obj.for-type BEGINS " NVARCHAR" THEN 
                    ASSIGN for-init = " DEFAULT '" + ilin[2] + "'".                                
                  ELSE IF new-obj.for-type BEGINS " INTEGER" OR  new-obj.for-type BEGINS " DECIMAL"
                       OR new-obj.for-type BEGINS " TINYINT" THEN DO:  
                    /* logical no or false */
                    IF ilin[2] BEGINS "N" OR ilin[2] BEGINS "F" THEN
                      ASSIGN for-init = " DEFAULT 0 ".
                    /* logical yes or true */
                    ELSE IF ilin[2] BEGINS "Y" OR ilin[2] BEGINS "T" THEN
                      ASSIGN for-init = " DEFAULT 1 ".
                    /* integer */
                    ELSE IF INDEX(ilin[2], ",") = 0 AND LOOKUP(substring(ilin[2], 1,1), "1,2,3,4,5,6,7,8,9,0") <> 0 THEN
                       ASSIGN for-init = " DEFAULT " + ilin[2].
                    /* decimal, remove formatting */
                    ELSE IF INDEX(ilin[2], ",") > 0 THEN DO:
                      ASSIGN for-init = ilin[2].
                      DO k = 1 TO LENGTH(ilin[2]):
                        IF INDEX(for-init, ",") > 0 THEN
                          ASSIGN for-init = SUBSTRING(for-init, 1, (INDEX(for-init, ",") - 1)) +  
                                            SUBSTRING(for-init, (INDEX(for-init, ",") + 1)).
                        ELSE
                          ASSIGN k = LENGTH(ilin[2]).
                      END.
                      ASSIGN for-init = " DEFAULT " + for-init.
                    END.                    
                  END.
                  /* date */
                  ELSE IF new-obj.for-type BEGINS " DATE" THEN DO:
                    IF UPPER(ilin[2]) = "TODAY" THEN 
                      ASSIGN for-init = " DEFAULT GETDATE()".                   
                  END.              
                  IF AVAILABLE sql-info THEN 
                    ASSIGN LINE = LINE + for-init.
                  ELSE IF AVAILABLE alt-info THEN 
                    ASSIGN a-line = a-line + for-init. 
                END.
              END.
            END.
            WHEN "EXTENT"  THEN DO:

              IF ilin[2] <> "0" THEN DO:
                CREATE df-info.
                ASSIGN df-info.df-seq = dfseq
                       dfseq = dfseq + 1
                       df-info.df-tbl = tablename
                       df-line =  "  " + ilin[1] + " "  + ilin[2].
             
                FIND FIRST sql-info WHERE tblname = tablename
                                      AND fldname = fieldname 
                                      AND line-num > 1 
                                      AND line <> "" NO-ERROR.
                IF AVAILABLE sql-info THEN DO:                    
                  IF (LENGTH(fieldname) + length(ilin[2]) + 2) < integer(user_env[29]) THEN DO:             
                    ASSIGN endline = SUBSTRING(line,(length(fieldname)+ 1))
                           line = SUBSTRING(line, 1, length(fieldname)) +
                                     "##1" + endline.

                    FIND new-obj WHERE new-obj.add-type = "F"
                                   AND new-obj.tbl-name = tablename
                                   AND new-obj.fld-name = fieldname
                                   NO-ERROR.
                    IF AVAILABLE new-obj THEN
                      ASSIGN new-obj.for-name = new-obj.for-name + "##1"
                             fortype = new-obj.for-type.                  
                      
                    DO i = 2 TO INTEGER(ilin[2]):
                      CREATE sql-info.
                      ASSIGN lnum = lnum + 1
                             line-num = lnum
                             tblname = tablename
                             fldname = fieldname
                             line = fieldname + "##" + STRING(i) +  endline.  
                                                              
                      RUN create-new-obj (INPUT "F", INPUT STRING(i)).    
                      ASSIGN fldnum = fldnum + 1.
                    END.
                  END.
                  ELSE DO:
                    ASSIGN forname = substring(line,1,(INTEGER(user_env[29]) - length(ilin[2]) - 2 )) + "##"
                           endline = SUBSTRING(line,(length(fieldname) + 1))
                           line = forname + "1 " + endline.
                    
                    FIND new-obj WHERE new-obj.add-type = "F"
                                   AND new-obj.tbl-name = tablename
                                   AND new-obj.fld-name = fieldname
                                   NO-ERROR.
                    IF AVAILABLE new-obj THEN
                      ASSIGN new-obj.for-name = forname + "1"
                             fortype = new-obj.for-type.                
                                                                                                   
                    DO i = 2 TO INTEGER(ilin[2]):
                      CREATE sql-info.
                      ASSIGN lnum = lnum + 1
                             line-num = lnum
                             tblname = tablename
                             fldname = fieldname
                             line = forname + STRING(i) + endline.   
                                       
                      RUN create-new-obj (INPUT "F", INPUT STRING(i)).                                         
                    END.
                  END.
                END.
                ELSE DO:
                  FIND FIRST alt-info WHERE a-tblname = tablename
                                        AND a-fldname = fieldname 
                                        AND a-line-num > 1 
                                        AND a-line <> "" NO-ERROR.
                  IF AVAILABLE alt-info THEN DO:  
                    FIND new-obj WHERE new-obj.add-type = "F"
                                   AND new-obj.tbl-name = tablename
                                   AND new-obj.for-name = fieldname
                                   NO-ERROR.
                    IF AVAILABLE new-obj THEN
                        ASSIGN new-obj.for-name = new-obj.for-name + "##1".
                                                      
                    IF (LENGTH(fieldname) + length(ilin[2]) + 2) < integer(user_env[29]) THEN DO:
               
                      ASSIGN endline = SUBSTRING(a-line,(length(fieldname)+ 1))
                             a-line = fieldname + "##1" + endline.                 
                 
                      DO i = 2 TO INTEGER(ilin[2]):
                        CREATE alt-info.
                        ASSIGN lnum = lnum + 1
                               a-line-num = lnum
                               a-tblname = tablename
                               a-fldname = fieldname
                               a-line = fieldname + "##" + STRING(i) +  endline. 
                    
                        RUN create-new-obj (INPUT "F", INPUT STRING(i)).                                                                                        
                      END.
                    END.
                    ELSE DO:                   
                      ASSIGN forname = substring(a-line,4,(INTEGER(user_env[29]) - length(ilin[2]) - 2 )) + "##"
                             endline = SUBSTRING(a-line,(length(fieldname) + 5))
                             a-line = forname + "1 " + endline.
                  
                      DO i = 2 TO INTEGER(ilin[2]):
                        CREATE alt-info.
                        ASSIGN lnum = lnum + 1
                               a-line-num = lnum
                               a-tblname = tablename
                               a-fldname = fieldname
                               a-line = forname + STRING(i) + endline. 
                                            
                        RUN create-new-obj (INPUT "F", INPUT STRING(i)).                                                                                                                 
                      END.
                    END.
                  END.
                END.
              END.               
            END. /* WHEN EXTENT */
                 
            WHEN "ORDER"           OR WHEN "FIELD-MISC11"  OR WHEN "FIELD-MISC12"      OR 
            WHEN "FIELD-MISC13"    OR WHEN "FIELD-MISC14"  OR WHEN "FIELD-MISC15"      OR
            WHEN "FIELD-MISC16"    OR WHEN "FIELD-MISC17"  OR WHEN "FIELD-MISC18"      OR
            WHEN "DECIMALS"        OR WHEN "POSITION" THEN DO:
              IF ilin[2] <> ? THEN DO:
                CREATE df-info.
                ASSIGN df-info.df-seq = dfseq
                       dfseq = dfseq + 1
                       df-info.df-tbl = tablename
                       df-line =  "  " + ilin[1] + " " + ilin[2].
              END.
            END.
            WHEN "LENGTH" THEN DO:
              IF ilin[2] <> "0" THEN DO:
                CREATE df-info.
                ASSIGN df-info.df-seq = dfseq
                       dfseq = dfseq + 1
                       df-info.df-tbl = tablename
                       df-line =  "  " + ilin[1] + " " + ilin[2].
              END.
            END.
            WHEN "MANDATORY" OR WHEN "CASE-SENSITIVE" OR WHEN "NOT-CASE-SENSITIVE" OR
            WHEN "NULL-ALLOWED" THEN DO:

                IF ilin[1] = "MANDATORY" THEN DO:
                   FIND new-obj WHERE new-obj.add-type = "F"
                       AND new-obj.tbl-name = tablename
                       AND new-obj.fld-name = fieldname
                       NO-LOCK NO-ERROR. 
                   /* if it's mandatory for a new field */
                   IF AVAILABLE new-obj THEN
                       ASSIGN new-obj.mand = YES.
                END.

              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tablename
                     df-line =  "  " + ilin[1].
            END.                                          
            WHEN "FIELD-TRIGGER"  THEN DO:
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tablename
                     df-line =  "  " + ilin[1] +  ' "' + ilin[2] + '" ' + 
                               ilin[3] + " ". 
              IF ilin[4] <> ? THEN
                 ASSIGN df-line = df-line + ilin[4].             
              IF ilin[5] <> ? THEN 
                ASSIGN df-line = df-line + ' "' + ilin[5] + '" '.              
              IF ilin[6] <> ? THEN 
                ASSIGN df-line = df-line + ilin[6].             
              IF ilin[7] <> ? THEN
                ASSIGN df-line = df-line + ' "' + ilin[7] + '"'.
            END.
            WHEN "SQL-WIDTH" OR WHEN "MAX-WIDTH" THEN DO:
              IF sqlwidth THEN 
              _sqlw:    
              DO:
                FIND FIRST new-obj WHERE new-obj.add-type = "F"
                               AND new-obj.tbl-name = tablename
                               AND new-obj.fld-name = fieldname
                               NO-LOCK NO-ERROR. 
               
                IF new-obj.for-type = " UNSUPPORTED" THEN LEAVE _sqlw.

                IF new-obj.for-type <> " INTEGER" AND
                   new-obj.for-type <> " DATETIME" AND
                   new-obj.for-type <> " TEXT" AND 
                   new-obj.for-type <> " NVARCHAR(MAX)" THEN DO:
                  
                  FIND df-info WHERE df-info.df-tbl = tablename
                                 AND df-info.df-fld = fieldname
                                 AND df-info.df-line BEGINS "  FORMAT".
                 
                  IF alt-table THEN DO:               
                    FIND FIRST alt-info WHERE a-tblname = tablename
                                    AND a-fldname = fieldname 
                                    AND NOT a-line BEGINS "ALTER" NO-ERROR.
                    IF AVAILABLE alt-info THEN DO:
                      IF new-obj.for-type BEGINS " VARCHAR" OR new-obj.for-type BEGINS " NVARCHAR" THEN DO:  
                        IF INDEX(a-line,"DEFAULT") <> 0 THEN
                          ASSIGN extlinenum = INDEX(a-line,"DEFAULT")
                                 extline = SUBSTRING(a-line, extlinenum).
                        ELSE
                          ASSIGN extline = "".

                        ASSIGN i = INTEGER(ilin[2]).
                        /* expand length - unicode support */
                        IF user_env[35] = "y" THEN
                           ASSIGN i = i * 2.

                        IF i < varlngth THEN
                          ASSIGN new-obj.for-type = /*" VARCHAR("*/ " " + user_env[11] + "(" + string(i) + ")"
                                 a-line = fieldname + /*" VARCHAR("*/ " " + user_env[11] + "(" + string(i) + ") " + extline
                                 df-info.df-line = "  FORMAT " + '"x(' + ilin[2] + ')"'
                                 extline = a-line
                                 extlinenum = alt-info.a-line-num.
                        ELSE DO: 
                          ASSIGN new-obj.for-type = /*" TEXT"*/ " " + user_env[18]
                                 a-line = fieldname + /*" TEXT"*/ " " + user_env[18]
                                 extline = a-line
                                 extlinenum = alt-info.a-line-num.
                          DELETE df-info.
                        END.                        
                      END.
                      ELSE DO:
                        ASSIGN left_paren = INDEX(a-line, "(")
                               right_paren = INDEX(a-line, ")")
                               j = INDEX(a-line, ",").

                        ASSIGN new-obj.for-type = " DECIMAL (" + ilin[2] + ","
                                                  + SUBSTRING(a-line, j + 1, right_paren - j)
                               a-line = fieldname + " DECIMAL (" + ilin[2] + ","
                                        + SUBSTRING(a-line, j + 1, right_paren - j) + " " + extline
                               extline = a-line
                               extlinenum = alt-info.a-line-num.
                      END.                    
                    END.
                    FOR EACH alt-info WHERE a-tblname = tablename
                                        AND a-fldname = fieldname 
                                        AND NOT a-line BEGINS "ALTER"
                                        AND a-line-num > extlinenum:
                        ASSIGN alt-info.a-line = extline.
                    END.
                  END.
                  ELSE DO:
                    FIND FIRST sql-info WHERE tblname = tablename
                                    AND fldname = fieldname 
                                    AND LINE BEGINS fieldname
                                    NO-ERROR.
                    IF AVAILABLE sql-info THEN DO:     
                      IF INDEX(line,"DEFAULT") <> 0 THEN 
                          ASSIGN extlinenum = INDEX(line,"DEFAULT")
                                 extline = SUBSTRING(line, extlinenum).
                        ELSE
                          ASSIGN extline = "".


                      ASSIGN i = INTEGER(ilin[2]).
                      /* expand length - unicode support */
                      IF user_env[35] = "y" THEN
                         ASSIGN i = i * 2.

                      IF new-obj.for-type BEGINS " VARCHAR" OR new-obj.for-type BEGINS " NVARCHAR" THEN DO:    
                        IF i < varlngth THEN
                          ASSIGN new-obj.for-type = /*" VARCHAR("*/ " " + user_env[11] + "(" + STRING(i) + ")"
                                 line = fieldname + /*" VARCHAR("*/ " " + user_env[11] + "(" + STRING(i) + ") " + extline
                                 df-info.df-line = "  FORMAT " + '"x(' + ilin[2] + ')"'
                                 extline = sql-info.line
                                 extlinenum = sql-info.line-num.
                        ELSE DO:                      
                          ASSIGN new-obj.for-type = /*" TEXT"*/ " " + user_env[18]
                                 line = fieldname + /*" TEXT"*/  " " + user_env[18]
                                 extline = sql-info.line
                                 extlinenum = sql-info.line-num.
                          /* There is no format statement for a text */
                          DELETE df-info.                       
                        END.                        
                      END.                    
                      ELSE DO:
                        ASSIGN left_paren = INDEX(line, "(")
                               right_paren = INDEX(line, ")")
                               j = INDEX(line, ",").
                        ASSIGN new-obj.for-type = " DECIMAL (" + ilin[2] + ","
                                                  + SUBSTRING(LINE, j + 1, right_paren - j)
                               line = fieldname + " DECIMAL (" + ilin[2] + ","
                                      + SUBSTRING(LINE, j + 1, right_paren - j) + " " + extline
                               extline = sql-info.line
                               extlinenum = sql-info.line-num.
                      END.
                      FOR EACH sql-info WHERE tblname = tablename
                                    AND fldname = fieldname 
                                    AND LINE BEGINS fieldname
                                    AND sql-info.line-num > extlinenum:
                          ASSIGN sql-info.LINE = extline.
                      END.
                    END.
                  END.
                  FIND df-info WHERE df-info.df-tbl = tablename
                                 AND df-info.df-fld = fieldname
                                 AND df-info.df-line BEGINS "  FIELD-MISC13".
                  ASSIGN df-info.df-line = "  FIELD-MISC13 " + ilin[2].
                  FIND df-info WHERE df-info.df-tbl = tablename
                                 AND df-info.df-fld = fieldname
                                 AND df-info.df-line BEGINS "  FOREIGN-MAXIMUM".
                  ASSIGN df-info.df-line = "  FOREIGN-MAXIMUM " + ilin[2].                  
                  FIND df-info WHERE df-info.df-tbl = tablename
                                 AND df-info.df-fld = fieldname
                                 AND df-info.df-line BEGINS "  DSRVR-PRECISION " NO-ERROR.
                  IF AVAILABLE df-info THEN
                     ASSIGN df-info.df-line = "  DSRVR-PRECISION " + ilin[2].                  
                END.                
              END.
              ASSIGN extlinenum = ?
                     extline = "".
            END.
          END CASE.
        END. /* End subsequent lines of add field */       

        ASSIGN ilin = ?.
      END.
      ELSE DO:  /* imod = m */
        IF ilin[1] = "UPDATE" THEN DO:       
          IF tablename <> ? AND tablename <> ilin[5] THEN 
            RUN write-tbl-sql.               
          
          IF idxline <> ? THEN 
            RUN write-idx-sql.
 
          IF seq-line <> ? THEN
            RUN write-seq-sql.

          IF tablename <> ilin[5] THEN
            ASSIGN tablename = ilin[5]
                   comment_chars = ""
                   comment-out = FALSE
                   fieldtype = ?.

          IF fieldname <> ilin[3] THEN
            ASSIGN fieldname = ilin[3].

          FIND DICTDB._File WHERE DICTDB._File._File-name = ilin[5] NO-ERROR.       
          IF AVAILABLE DICTDB._File THEN DO:
            FIND DICTDB._Field OF DICTDB._FILE WHERE DICTDB._Field._Field-name = ilin[3]
                                                     NO-ERROR.
            IF NOT AVAILABLE DICTDB._Field THEN DO:
              FIND rename-obj WHERE rename-type = "F"
                                AND t-name = ilin[5]
                                AND new-name = ilin[3]
                                  NO-ERROR.
              IF AVAILABLE rename-obj THEN 
                FIND DICTDB._Field OF DICTDB._FILE WHERE DICTDB._Field._Field-name = old-name
                                               NO-ERROR.
              IF NOT AVAILABLE DICTDB._Field THEN DO:         .        
                MESSAGE "The Delta DF File contains UPDATE FIELD" ilin[3] "for table" ilin[5] SKIP
                        "and field does not exist in the schema holder." SKIP
                        "This process is being aborted."  SKIP (1)
                VIEW-AS ALERT-BOX ERROR.
                RETURN.
              END.
            END.
            ASSIGN fieldtype = DICTDB._Field._data-type.
          END.
          IF NOT AVAILABLE DICTDB._File THEN DO:
            _ren-loop:
            FOR EACH rename-obj WHERE rename-type = "T"
                                  AND new-name = ilin[5]:
          
              FIND DICTDB._File WHERE DICTDB._File._File-name = old-name NO-ERROR.
              IF AVAILABLE DICTDB._File THEN 
                LEAVE _ren-loop.
            END.
            IF NOT AVAILABLE DICTDB._File THEN DO:
             MESSAGE "The Delta DF File contains UPDATE FIELD for table" ilin[5] SKIP
                     "and table does not exist in the schema holder." SKIP
                     "This process is being aborted."  SKIP (1)
                  VIEW-AS ALERT-BOX ERROR.
             RETURN.
            END.
            ELSE DO:
              FIND DICTDB._Field OF DICTDB._FILE WHERE DICTDB._Field._Field-name = ilin[3]
                                                     NO-ERROR.
              IF NOT AVAILABLE DICTDB._Field THEN DO:
                FIND rename-obj WHERE rename-type = "F"
                                  AND t-name = ilin[5]
                                  AND new-name = ilin[3]
                                  NO-ERROR.
                IF AVAILABLE rename-obj THEN 
                  FIND DICTDB._Field OF DICTDB._FILE WHERE DICTDB._Field._Field-name = old-name
                                               NO-ERROR.
              END.
              IF NOT AVAILABLE DICTDB._Field THEN DO:         .        
                MESSAGE "The Delta DF File contains UPDATE FIELD" ilin[3] "for table" ilin[5] SKIP
                        "and field does not exist in the schema holder." SKIP
                        "This process is being aborted."  SKIP (1)
                VIEW-AS ALERT-BOX ERROR.
                RETURN.
              END.
            END.
            ASSIGN fieldtype = DICTDB._Field._data-type.
          END.
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                  dfseq = dfseq + 1
                  df-info.df-tbl = tablename
                  df-info.df-fld = fieldname
                  df-line = ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '" ' +
                            ilin[4] + ' "' + ilin[5] + '"'.

          /* handle int->int64 type change */
          IF ilin[6] = "AS" AND ilin[7] = "int64" THEN DO:

                /* we will just change the definition in the .df to be BIGINT.
                   but will need to drop the field (and indexes) nd re-add them
                   in SQL Server since it's a type change 
                */

                /* check if field is part of any index and delete them */
                FOR EACH DICTDB._Index OF DICTDB._File 
                     WHERE DICTDB._File._For-owner NE ? AND DICTDB._File._For-owner NE "" NO-LOCK:
                    
                    FIND FIRST DICTDB._Index-field OF DICTDB._Index 
                         WHERE DICTDB._Index-field._field-recid = RECID(DICTDB._Field) NO-LOCK NO-ERROR.
                    IF AVAILABLE DICTDB._Index-field THEN
                       PUT STREAM tosql UNFORMATTED comment_chars "DROP INDEX " DICTDB._File._For-owner "." DICTDB._File._For-name "." DICTDB._Index._For-name SKIP "go" SKIP(1).           
                END.

                /* now alter the field's type */
                IF DICTDB._Field._Extent > 0 THEN DO:
                    DO i = 1 TO DICTDB._Field._Extent:
                       PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " DICTDB._File._For-owner "." DICTDB._File._For-name 
                                                " ALTER COLUMN " DICTDB._Field._For-name "##" STRING(i) " BIGINT" SKIP "go" SKIP(1).           
                    END.
                END.
                ELSE DO:
                    PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " DICTDB._File._For-owner "." DICTDB._File._For-name 
                        " ALTER COLUMN " DICTDB._Field._For-name " BIGINT" SKIP "go" SKIP(1).           
                END.

                /* now recreate indexes if they were deleted above */
                FOR EACH DICTDB._Index OF DICTDB._File 
                    WHERE DICTDB._File._For-owner NE ? AND DICTDB._File._For-owner NE "" NO-LOCK:
                    
                    /* go through all indexes for the current table, and find the ones that
                       contain this field.
                    */
                    FIND FIRST DICTDB._Index-field OF DICTDB._Index 
                         WHERE DICTDB._Index-field._field-recid = RECID(DICTDB._Field) NO-LOCK NO-ERROR.

                    IF AVAILABLE DICTDB._Index-field THEN DO:
                    
                       ASSIGN is-unique = DICTDB._Index._Unique
                              u = 0.

                       idxline = "CREATE" + (IF is-unique THEN " UNIQUE" ELSE "")
                                  + " INDEX " + DICTDB._Index._For-name + " ON " 
                                  + DICTDB._File._For-owner + "." + DICTDB._File._For-name + " (".
                       
                       FOR EACH DICTDB._Index-field OF DICTDB._Index NO-LOCK BY DICTDB._Index-field._Index-seq:
                           /* add field to sql statement. Since this is an integer field, don't
                              need to worry about shadow columns.
                           */
                           FIND FIRST DICTDB._Field WHERE RECID(DICTDB._Field) = DICTDB._Index-field._field-recid NO-LOCK.

                           idxline = idxline + (IF u > 0 THEN ", " ELSE "") + DICTDB._Field._For-name
                               + (IF NOT DICTDB._Index-field._Ascending THEN " DESC " ELSE "") .

                           ASSIGN u = 1.

                       END.

                       IF pcompatible AND is-unique = FALSE THEN 
                          ASSIGN idxline = idxline + ", PROGRESS_RECID".

                       PUT STREAM tosql UNFORMATTED comment_chars idxline ")"  SKIP.
                       PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP(1).

                       ASSIGN idxline = "".

                       /* now point again at the _Field for the field been changed */
                       FIND DICTDB._Field OF DICTDB._FILE WHERE DICTDB._Field._Field-name = ilin[3] NO-LOCK.
                    END.
                END.

              /* handle .df changes */
              dfseq = dfseq + 1.

              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                      dfseq = dfseq + 1
                      df-info.df-tbl = tablename
                      df-info.df-fld = fieldname
                      df-line = '  FOREIGN-TYPE "BIGINT"'.

              dfseq = dfseq + 1.

              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                      dfseq = dfseq + 1
                      df-info.df-tbl = tablename
                      df-info.df-fld = fieldname
                      df-line = "  DSRVR-PRECISION 19".

              dfseq = dfseq + 1.

              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                      dfseq = dfseq + 1
                      df-info.df-tbl = tablename
                      df-info.df-fld = fieldname
                      df-line = "  DSRVR-LENGTH 8".
          END.

        END.

        CASE ilin[1]:
          WHEN "FORMAT" THEN DO: /* skip changes in format because MSS is already created */             
             /* if this is a logical field, we can change the format, since it won't
                mean a change in ORACLE - also, if the format has changed for a logical field,
                it means that the INITIAL may have also changed, in which case we will
                generate a bad .df - we will fail to load it if INITIAL has changed, but
                FORMAT hasn't changed.
             */
             IF fieldtype = "logical" THEN DO:
                  CREATE df-info.
                  ASSIGN df-info.df-seq = dfseq
                         dfseq = dfseq + 1
                         df-info.df-tbl = tablename
                         df-info.df-fld = fieldname
                         df-line =  "  " + ilin[1] + ' "' + ilin[2] + '"'.
             END.
             ELSE DO:
                 ASSIGN efile = tablename + ".e".
                 OUTPUT TO value(efile) APPEND.
                 PUT UNFORMATTED fieldname " in " tablename " had a change to FORMAT which was not passed to the" SKIP
                                "df file and no ALTER TABLE statement was created to change field size." SKIP(1).
                 OUTPUT CLOSE.
             END.
          END.
          WHEN "SQL-WIDTH" OR WHEN "MAX-WIDTH" THEN DO:
            IF sqlwidth THEN DO:
              ASSIGN efile = tablename + ".e".
              OUTPUT TO value(efile) APPEND.
              PUT UNFORMATTED fieldname " in " tablename " had a change to WIDTH which was not passed to the" SKIP
                              "df file and no ALTER TABLE statement was created to change field size." SKIP(1).
              OUTPUT CLOSE.
            END.
          END.
          WHEN "DESC"            OR WHEN "DESCRIPTION"      OR WHEN "CAN-READ"        OR 
          WHEN "CAN-SELECT"      OR WHEN "CAN-WRITE"        OR WHEN "CAN-UPDATE"      OR
          WHEN "FORMAT-SA"       OR WHEN "LABEL"            OR WHEN "LABEL-SA"        OR 
          WHEN "COLUMN-LABEL"    OR WHEN "COLUMN-LABEL-SA"  OR WHEN "INITIAL-SA"      OR 
          WHEN "VALEXP"          OR WHEN "VALMSG"           OR WHEN "VALMSG-SA"       OR 
          WHEN "VIEW-AS"         OR WHEN "HELP"             OR WHEN "HELP-SA"         OR
          WHEN "QUOTED-NAME"     OR WHEN "FIELD-MISC21"     OR WHEN "FIELD-MISC23"    OR            
          WHEN "FIELD-MISC24"    OR WHEN "FIELD-MISC25"     OR WHEN "FIELD-MISC26"    OR 
          WHEN "FIELD-MISC27"    OR WHEN "FIELD-MISC28"     OR WHEN "MISC-PROPERTIES" OR 
          WHEN "SHADOW-NAME"     OR WHEN "INITIAL" THEN DO:
            IF ilin[2] = ? THEN DO:
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tablename
                     df-info.df-fld = fieldname
                     df-line =  "  " + ilin[1] + " ?".
            END.                                                                
            ELSE DO:
              RUN dctquot (ilin[2], '"',OUTPUT oq-string).
              IF LENGTH(oq-string) > 0 THEN DO:
                CREATE df-info.
                ASSIGN df-info.df-seq = dfseq
                       dfseq = dfseq + 1
                       df-info.df-tbl = tablename
                       df-info.df-fld = fieldname
                       df-line =  "  " + ilin[1] + " " + oq-string.
              END.       
            END.              
          END.
          
          WHEN "POSITION"     OR WHEN "LENGTH"       OR WHEN "SCALE"        OR
          WHEN "ORDER"        OR WHEN "FOREIGN-CODE" OR WHEN "FIELD-MISC11" OR 
          WHEN "FIELD-MISC12" OR WHEN "FIELD-MISC13" OR WHEN "FIELD-MISC14" OR 
          WHEN "FIELD-MISC15" OR WHEN "FIELD-MISC16" OR WHEN "FIELD-MISC17" OR 
          WHEN "FIELD-MISC18" THEN DO:
            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-info.df-tbl = tablename
                   df-info.df-fld = fieldname
                   df-line =  "  " + ilin[1] + " " + ilin[2].
          END.
          WHEN "MANDATORY" THEN DO:
            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-info.df-tbl = tablename
                   df-info.df-fld = fieldname
                   df-line =  "  " + ilin[1].
          END.
          WHEN "FIELD-TRIGGER"  THEN  DO:
            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-info.df-tbl = tablename
                   df-info.df-fld = fieldname
                   df-line =  "  " + ilin[1] +  ' "' + ilin[2] + '" ' + 
                              ilin[3] + " ". 
             IF ilin[4] <> ? THEN
                 ASSIGN df-line = df-line + ilin[4].
             
             IF ilin[5] <> ? THEN 
                 ASSIGN df-line = df-line + ' "' + ilin[5] + '" '.
             
             IF ilin[6] <> ? THEN 
                 ASSIGN df-line = df-line + ilin[6].
             
             IF ilin[7] <> ? THEN
                 ASSIGN df-line = df-line + ' "' + ilin[7] + '"'.
          END.
        END CASE.
        ASSIGN ilin = ?.
      END. /* end update */                    
    END. /* End of object = field */
    ELSE IF iobj = "i" THEN DO:  
      /* Drop an index */
      IF imod = "d" THEN DO:
        RUN write-tbl-sql.
       
        IF idxline <> ? THEN 
          RUN write-idx-sql.

        IF seq-line <> ? THEN
          RUN write-seq-sql.

        IF tablename <> ilin[5] THEN 
          ASSIGN tablename = ilin[5]
                 idxname = ilin[3]
                 comment_chars = ""
                 comment-out = FALSE.
       
 
        FIND FIRST DICTDB._File WHERE DICTDB._File._File-name = ilin[5]
                                  AND DICTDB._File._Owner = "_FOREIGN" NO-ERROR.                                  
        IF AVAILABLE DICTDB._File THEN DO:
          FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-name = ilin[3] NO-ERROR.
          IF AVAILABLE DICTDB._Index THEN DO:
            PUT STREAM tosql UNFORMATTED comment_chars "DROP INDEX " DICTDB._File._For-owner "." DICTDB._File._For-name "." DICTDB._Index._For-name SKIP.
            PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP(1).
            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-info.df-tbl = tablename
                   df-line =  "DROP INDEX " + '"' + DICTDB._Index._Index-name +
                              '"' + " ON " + '"' + ilin[5] + '"'.           
          END.
          ELSE DO:
            FIND FIRST rename-obj WHERE rename-type = "I"
                                    and t-name = ilin[5]
                                    AND new-name = ilin[3]
                                    NO-ERROR.
            IF AVAILABLE rename-obj THEN DO:  
              IF new-name BEGINS "temp-we" THEN DO:              
                CREATE df-info.
                ASSIGN df-info.df-seq = dfseq
                       dfseq = dfseq + 1
                       df-info.df-tbl = tablename
                       df-line =  ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '" ' +
                                  ilin[4] + ' "' + ilin[5] + '" '.
              END.
              ELSE DO:
                FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-name = old-name NO-ERROR.
                IF AVAILABLE DICTDB._Index THEN DO:
                  /* Only put out the df info since if we renamed we have already dropped. */
                  CREATE df-info.
                  ASSIGN df-info.df-seq = dfseq
                         dfseq = dfseq + 1
                         df-info.df-tbl = tablename
                         df-line = ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '" ' + ilin[4] +
                                   ' "' + ilin[5] + '" '.
                END.
                IF NOT AVAILABLE DICTDB._Index THEN DO:
                  MESSAGE "The Delta DF File contains DROP INDEX" ilin[3] "for table" ilin[5] SKIP
                          "and index does not exist in the schema holder." SKIP
                          "This process is being aborted."  SKIP (1)
                       VIEW-AS ALERT-BOX ERROR.
                  RETURN.
                END.
              END.               
            END.
            ELSE DO:
              MESSAGE "The Delta DF File contains DROP INDEX" ilin[3] "for table" ilin[5] SKIP
                          "and index does not exist in the schema holder." SKIP
                          "This process is being aborted."  SKIP (1)
                  VIEW-AS ALERT-BOX ERROR.
              RETURN.
            END.
          END.
        END.
        ELSE DO:
          FIND FIRST rename-obj WHERE rename-type = "T"
                                  AND new-name = ilin[5]
                                  NO-ERROR.
                                                                 
          IF AVAILABLE rename-obj THEN DO:
            FIND DICTDB._File WHERE DICTDB._File._File-name = old-name
                                  AND DICTDB._File._Owner = "_FOREIGN" NO-ERROR.
            IF NOT AVAILABLE DICTDB._File THEN DO:
              MESSAGE "The Delta DF File contains DROP INDEX for table" ilin[5] SKIP
                      "and table does not exist in the schema holder." SKIP
                      "This process is being aborted."  SKIP (1)
                  VIEW-AS ALERT-BOX ERROR.
              RETURN.
            END.
            IF AVAILABLE DICTDB._File THEN DO:
              FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-name = ilin[3] NO-ERROR.
              IF AVAILABLE DICTDB._Index THEN DO:
                PUT STREAM tosql UNFORMATTED comment_chars "DROP INDEX " DICTDB._File._For-owner "." DICTDB._File._For-name "." DICTDB._Index._For-name SKIP.
                PUT STREAM tosql UNFORMATTED comment_chars "go" SKIP(1).
                CREATE df-info.
                ASSIGN df-info.df-seq = dfseq
                       dfseq = dfseq + 1
                       df-info.df-tbl = tablename
                       df-line = ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '" ' + ilin[4] +
                                 ' "' + ilin[5] + '" '.
              END.
              ELSE DO:
                FIND FIRST rename-obj WHERE rename-type = "I"
                                        and t-name = old-name
                                        AND new-name = ilin[3]
                                        NO-ERROR.
                IF AVAILABLE rename-obj THEN DO:
                  FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-name = old-name NO-ERROR.
                  IF NOT AVAILABLE DICTDB._Index THEN DO:
                    MESSAGE "The Delta DF File contains DROP INDEX" ilin[3] "for table" ilin[5] SKIP
                            "and index does not exist in the schema holder." SKIP
                            "This process is being aborted."  SKIP (1)
                         VIEW-AS ALERT-BOX ERROR.
                    RETURN.
                  END.
                  IF AVAILABLE DICTDB._Index THEN DO:
                    /* only put to df because if we renamed first, we have dropped and added already in sql */
                    CREATE df-info.
                    ASSIGN df-info.df-seq = dfseq
                           dfseq = dfseq + 1
                           df-info.df-tbl = tablename
                           df-line = ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '" ' +
                                     ilin[4] + ' "' + ilin[5] + '" '.
                  END.
                END.
                ELSE DO:
                  IF ilin[3] BEGINS "temp-we" THEN DO:
                    CREATE df-info.
                    ASSIGN df-info.df-seq = dfseq
                           dfseq = dfseq + 1
                           df-info.df-tbl = tablename
                           df-line = ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '" ' +
                                     ilin[4] + ' "' + ilin[5] + '" '.
                  END.
                END.                  
              END.              
            END.  
          END.
        END.        
        ASSIGN ilin = ?.
      END. /* End delete index */                
      IF imod = "a" THEN DO:
        IF ilin[1] = "ADD" and ilin[2] = "INDEX" THEN DO:     

          RUN write-tbl-sql.
                                 
          IF idxline <> ? THEN 
            RUN write-idx-sql.
            
          IF seq-line <> ? THEN
            RUN write-seq-sql.

            ASSIGN wordidx = FALSE
                   wordfile = ?
                   is-unique = FALSE.
          
          IF tablename <> ilin[5] THEN
            ASSIGN tablename = ilin[5]
                   comment_chars = ""
                   comment-out = FALSE.

          ASSIGN transname = ilin[3]
                 idxname = ilin[3].
          IF xlate THEN DO:          
            ASSIGN transname = transname  + "," + idbtyp + "," + user_env[28].          
            RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT transname).
          END. 
          ASSIGN transname = transname.              
          IF user_env[6] = "Y" THEN DO:
            FIND DICTDB._File WHERE DICTDB._File._File-name = ilin[5] NO-ERROR.
            IF AVAILABLE DICTDB._File THEN DO:  
              ASSIGN idx-number = 0.
              FOR EACH DICTDB._Index OF DICTDB._File:
                IF idx-number < DICTDB._Index._Idx-num THEN
                  ASSIGN idx-number = DICTDB._Index._Idx-num.
              END.
              FOR EACH n-obj WHERE n-obj.tbl-name = ilin[5]
                               AND n-obj.add-type = "I":
                  ASSIGN idx-number = idx-number + 1.
              END.
              ASSIGN idx-number = idx-number + 1.          
              forname = DICTDB._File._For-name.
              IF LENGTH(forname) + LENGTH(transname) + 2 > INTEGER(user_env[28]) THEN DO:
                IF LENGTH(transname) + 2 < INTEGER(user_env[28]) THEN
                  ASSIGN forname = SUBSTRING(forname,1,(INTEGER(user_env[28]) - length(transname) - 2)) + "##" + transname.
                ELSE DO:
                  ASSIGN forname = transname.
                  REPEAT:
                    forname = SUBSTRING(transname,1, (LENGTH(forname) - 1)).
                    IF LENGTH(forname) + 2 <= INTEGER(user_env[28]) THEN LEAVE.
                  END.
                  ASSIGN forname =  forname + "##".
                END.
              END.
              ELSE 
                ASSIGN forname = DICTDB._File._For-name + "##" + transname.
              
               _verify-index:
              DO WHILE TRUE:
                FIND FIRST verify-index WHERE verify-index.inew-name = forname NO-ERROR.
                FIND FIRST DICTDB._Index WHERE CAPS(DICTDB._Index._For-name) = CAPS(forname)
                                           AND DICTDB._Index._File-recid = RECID(DICTDB._File) NO-ERROR.
                IF AVAILABLE verify-Index OR AVAILABLE DICTDB._Index THEN DO:
                  DO a = 1 TO 999:
                    IF a = 1 THEN
                      ASSIGN forname = forname + STRING(a).
                    ELSE
                      ASSIGN forname = SUBSTRING(forname, 1, LENGTH(forname) - LENGTH(STRING(a))) + STRING(a). 
                    IF CAN-FIND(FIRST DICTDB._Index WHERE DICTDB._Index._File-recid = RECID(DICTDB._File)
                                                  AND DICTDB._Index._For-name = forname) THEN NEXT.
                    ELSE IF CAN-FIND(FIRST verify-index WHERE verify-index.inew-name = forname) THEN NEXT.
                    ELSE DO:
                      CREATE verify-index.
                      ASSIGN verify-index.inew-name = forname.
                      LEAVE _verify-index.
                    END.
                  END.
                END.
                ELSE DO:
                  CREATE verify-index.
                  ASSIGN verify-index.inew-name = forname.
                  LEAVE _verify-index.
                END.
              END.
            END. 
            ELSE DO:
              FIND FIRST new-obj WHERE new-obj.add-type = "T"
                                 AND new-obj.tbl-name = ilin[5]
                                 NO-ERROR.
              IF AVAILABLE new-obj THEN DO:
                ASSIGN forname = new-obj.for-name. 
                IF LENGTH(forname) + LENGTH(transname) + 2 > INTEGER(user_env[28]) THEN DO:
                  IF LENGTH(transname) + 2 < INTEGER(user_env[28]) THEN
                    ASSIGN forname = SUBSTRING(forname,1,(INTEGER(user_env[28]) - length(transname) - 2)) + "##" + transname.
                  ELSE DO:
                    ASSIGN forname = transname.
                    REPEAT:
                      forname = SUBSTRING(transname,1, (LENGTH(forname) - 1)).
                      IF LENGTH(forname) + 2 <= INTEGER(user_env[28]) THEN LEAVE.
                    END.
                    ASSIGN forname =  forname + "##".
                  END.
                END.
                ELSE ASSIGN forname = forname + "##" + transname.
                 
                _verify-new-index:
                DO WHILE TRUE:
                  FIND FIRST verify-index WHERE verify-index.inew-name = forname NO-ERROR.
                  FIND FIRST n-obj WHERE n-obj.for-name = forname 
                                       AND n-obj.tbl-name = ilin[5]
                                       AND n-obj.add-type = "I" NO-ERROR.
                  IF AVAILABLE verify-Index OR AVAILABLE n-obj THEN
                    ASSIGN forname = SUBSTRING(forname, 1, LENGTH(forname) - 1).
                  ELSE DO:
                    CREATE verify-index.
                    ASSIGN verify-index.inew-name = forname.
                    LEAVE _verify-new-index.
                  END.
                END.
              END.
              ELSE DO:
                FIND FIRST rename-obj WHERE rename-type = "T"
                                        AND rename-obj.new-name = ilin[5]
                                        NO-ERROR.
                IF AVAILABLE rename-obj THEN DO: 
                  FIND DICTDB._File WHERE DICTDB._File._File-name = rename-obj.old-name.
                  IF AVAILABLE DICTDB._File THEN DO:
                    ASSIGN idx-number = 0.
                    FOR EACH DICTDB._Index OF DICTDB._File:
                      IF idx-number < DICTDB._Index._Idx-num THEN
                        ASSIGN idx-number = DICTDB._Index._Idx-num.
                    END.
                    FOR EACH n-obj WHERE n-obj.tbl-name = ilin[5]
                                    AND n-obj.add-type = "I":
                       ASSIGN idx-number = idx-number + 1.
                    END.
                    ASSIGN idx-number = idx-number + 1.
                  END.
                  ASSIGN forname = dsv-name.                        
                  IF LENGTH(forname) + LENGTH(transname) + 2 > INTEGER(user_env[28]) THEN DO:
                    IF LENGTH(transname) + 2 < INTEGER(user_env[28]) THEN
                      ASSIGN forname = SUBSTRING(forname,1,(INTEGER(user_env[28]) - length(transname) - 2)) + "##" + transname.
                    ELSE DO:
                      ASSIGN forname = transname.
                      REPEAT:
                        forname = SUBSTRING(transname,1, (LENGTH(forname) - 1)).
                        IF LENGTH(forname) + 2 < INTEGER(user_env[28]) THEN LEAVE.
                      END.
                      ASSIGN forname =  forname + "##".
                    END.
                  END.
                  ELSE
                    ASSIGN forname = forname + "##" + transname. 
                END.
              END.                                       
            END. 
          END.
          ELSE
            ASSIGN forname = transname.
          
          IF AVAILABLE DICTDB._File THEN 
              ASSIGN idxline = "CREATE INDEX " + forname + " ON " + DICTDB._File._For-owner + "." + DICTDB._File._For-name.
          ELSE DO:
            FIND FIRST new-obj WHERE new-obj.add-type = "T"
                                 AND new-obj.tbl-name = ilin[5]
                                 NO-ERROR.
            IF AVAILABLE new-obj THEN
               ASSIGN idxline = "CREATE INDEX " + forname + " ON " + mss_username + "." + new-obj.for-name. 
            ELSE DO:
              FIND FIRST rename-obj WHERE rename-type = "T"
                                      AND rename-obj.new-name = ilin[5]
                                      NO-ERROR.
              IF AVAILABLE rename-obj THEN 
                   ASSIGN idxline = "CREATE INDEX " + forname + " ON " + mss_username + "." + dsv-name.                           
            END.
          END.
          ASSIGN df-idx[1] = 'ADD INDEX "' + ilin[3] + '" ON "' + ilin[5] + '"'
                 df-idx[2] = "  INDEX-NUM " + STRING(idx-number)
                 idx-number = idx-number + 1.

          FIND FIRST rename-obj WHERE rename-type = "I"
                                  and t-name = ilin[5]
                                  AND old-name = ilin[3]
                                  NO-ERROR.
          IF AVAILABLE rename-obj THEN DO:         
            FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-name = old-name NO-ERROR.
            IF AVAILABLE DICTDB._Index THEN 
              PUT STREAM tosql UNFORMATTED comment_chars "DROP INDEX " DICTDB._File._For-owner "." DICTDB._File._For-name "." DICTDB._Index._For-name SKIP "go" SKIP(1).           
          END.
          IF NOT AVAILABLE DICTDB._File AND NOT AVAILABLE rename-obj AND NOT AVAILABLE new-obj THEN DO:
            MESSAGE "The Delta DF File contains ADD INDEX for table" ilin[5] SKIP
                    "and table information does not exist." SKIP
                    "This process is being aborted."  SKIP (1)
                    VIEW-AS ALERT-BOX ERROR.
            RETURN.
          END.

          RUN create-new-obj (INPUT "I", INPUT ?). 
          ASSIGN ilin = ?.
        END.  /* End of add index line */
        ELSE DO:           
          CASE ilin[1]:
            WHEN "UNIQUE" THEN 
              ASSIGN idxline = SUBSTRING(idxline, 1, 7) + "UNIQUE " + SUBSTRING(idxline,8)
                     df-idx[3] = "  " + ilin[1]
                     is-unique = TRUE.             
            WHEN "INACTIVE" THEN 
              ASSIGN df-idx[4] = "  " + ilin[1].
            WHEN "PRIMARY"  THEN
              ASSIGN df-idx[5] = "  " + ilin[1]. 
            WHEN "DESC" OR WHEN "DESCRIPTION" THEN  DO:
              RUN dctquot (ilin[2], '"',OUTPUT oq-string).  
              IF LENGTH(oq-string) > 0 THEN
                ASSIGN df-idx[6] = "  " + ilin[1] + " " + oq-string.
            END.
            WHEN "WORD" THEN DO: /* Skip, work indexes not supported */   
              ASSIGN efile = tablename + ".e".
              OUTPUT TO value(efile) APPEND.
              PUT UNFORMATTED idxname " in " tablename " is a word index and will not be contained in the" SKIP
                             "df file and no CREATE INDEX statement was generated in the sql file." SKIP(1).
              OUTPUT CLOSE.
              ASSIGN idxline = ?
                     wordidx = TRUE
                     wordfile = idxname
                     df-idx = ?.
            END.
            WHEN "INDEX-FIELD" OR WHEN "KEY-FIELD" THEN DO:   
              IF wordidx THEN NEXT.
              ELSE IF df-idx[1] <> ? THEN DO:
                DO i = 1 TO 6:
                  IF df-idx[i] <> ? THEN DO:
                    CREATE df-info.
                    ASSIGN df-info.df-seq = dfseq
                           dfseq = dfseq + 1
                           df-info.df-tbl = tablename
                           df-line = df-idx[i].
                  END.
                END.
                CREATE df-info.
                ASSIGN df-info.df-seq = dfseq
                       dfseq = dfseq + 1
                       df-info.df-tbl = tablename
                       df-line = "  FOREIGN-NAME " + '"' + LOWER(forname) + '"'.

                ASSIGN df-idx = ?.
              END.   
              RUN create-idx-field.
            END.
          END CASE.
          ASSIGN ilin = ?.
        END. /* End of other attributes of add index */       
      END. /* End of add index */
      
      /* Rename Index */
      ELSE IF imod = "r" THEN DO:     
        RUN write-tbl-sql.
        
        IF idxline <> ? AND idxname <> ilin[5] THEN 
          RUN write-idx-sql.
        
        IF seq-line <> ? THEN
          RUN write-seq-sql.

        ASSIGN tablename = ilin[7]
               idxname = ilin[5]
               comment_chars = ""
               comment-out = FALSE.

        IF ilin[1] <> ? THEN DO:
          FIND DICTDB._File WHERE DICTDB._File._File-name = ilin[7] NO-ERROR.  
              
          IF NOT AVAILABLE DICTDB._File THEN DO:
            FIND rename-obj WHERE rename-type = "T"
                              AND rename-obj.new-name = ilin[7]
                              NO-ERROR.
                             
            IF AVAILABLE rename-obj THEN
              FIND DICTDB._File WHERE DICTDB._File._File-name = old-name NO-ERROR. 
          END.
          IF NOT AVAILABLE DICTDB._File THEN DO:
            MESSAGE "The Delta DF File contains RENAME INDEX for table" ilin[7] SKIP
                    "and table does not exist in the schema holder." SKIP
                    "This process is being aborted."  SKIP (1)
                    VIEW-AS ALERT-BOX ERROR.
            RETURN.
          END.
          IF AVAILABLE DICTDB._File THEN 
            FIND FIRST DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-name = ilin[3] NO-ERROR. 
          
          IF AVAILABLE DICTDB._Index THEN DO:                                                
            CREATE rename-obj.
            ASSIGN rename-type = "I"
                   t-name = ilin[7]
                   old-name = ilin[3]
                   rename-obj.new-name = ilin[5].

            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-info.df-tbl = tablename
                   df-line = ilin[1] + ' ' + ilin[2] + ' "' + ilin[3] + '" ' +
                             ilin[4] + ' "' + ilin[5] + '" ' + ilin[6] + ' "' +
                             ilin[7] + '"'.
          END.
          ELSE DO:
            MESSAGE "The Delta DF File contains RENAME INDEX" ilin[3] "for table" ilin[7] SKIP
                    "and index does not exist in the schema holder." SKIP
                    "This process is being aborted."  SKIP (1)
                    VIEW-AS ALERT-BOX ERROR.
            RETURN.
          END.
        END.                              
        ASSIGN ilin = ?.  
      END.
      /* Update Index */
      ELSE DO:
        IF idxline <> ?  THEN 
          RUN write-idx-sql.

        IF seq-line <> ? THEN
          RUN write-seq-sql.

        /* only update if primary is changing since word indexes can't be primary */
        IF ilin[2] = "PRIMARY" THEN DO:   
          FIND DICTDB._File WHERE DICTDB._File._File-name = ilin[6] NO-ERROR.  
              
          IF NOT AVAILABLE DICTDB._File THEN DO:
            FIND rename-obj WHERE rename-type = "T"
                              AND rename-obj.new-name = ilin[6]
                              NO-ERROR.
                             
            IF AVAILABLE rename-obj THEN
              FIND DICTDB._File WHERE DICTDB._File._File-name = old-name NO-ERROR. 
          END.
          IF NOT AVAILABLE DICTDB._File THEN DO:
            MESSAGE "The Delta DF File contains UPDATE PRIMARY INDEX for table" ilin[6] SKIP
                    "and table does not exist in the schema holder." SKIP
                    "This process is being aborted."  SKIP (1)
                    VIEW-AS ALERT-BOX ERROR.
            RETURN.
          END.
          IF AVAILABLE DICTDB._File THEN 
            FIND FIRST DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-name = ilin[4] NO-ERROR. 
          
          IF NOT AVAILABLE DICTDB._Index THEN DO:                                                
            FIND rename-obj WHERE rename-type = "I"
                              AND rename-obj.new-name = ilin[4]
                              NO-ERROR.
            IF AVAILABLE rename-obj THEN
              FIND FIRST DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-name = old-name NO-ERROR.
            IF NOT AVAILABLE DICTDB._Index THEN DO:
              /* check if the index is being created as well */
              FIND FIRST new-obj WHERE new-obj.tbl-name = ilin[6] AND 
                                       new-obj.add-type = "I" AND
                                       new-obj.prg-name = ilin[4] NO-ERROR.
              IF NOT AVAILABLE new-obj THEN DO:
                  MESSAGE "The Delta DF File contains UPDATE PRIMARY INDEX" ilin[4] "for table" ilin[6] SKIP
                          "and index does not exist in the schema holder." SKIP
                          "This process is being aborted."  SKIP (1)
                      VIEW-AS ALERT-BOX ERROR.
                  RETURN.
              END.
            END.
          END.
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = tablename
                 df-line = ?.
          DO i = 1 TO 9: 
            IF ilin[i] <> "" AND ilin[i] <> ? THEN DO:  
              IF df-line = ? THEN 
                ASSIGN df-line = ilin[i] + " ".                        
              ELSE 
                ASSIGN df-line = df-line + ilin[i] + " ".
            END.
          END.
        END.
      END.                  
    END. /* End of index processing */
    IF iobj = "s" THEN DO: 
      IF tablename <> ? THEN 
        RUN write-tbl-sql.
   
      RUN write-idx-sql.

      ASSIGN tablename = ?
             comment_chars = ""
             comment-out = FALSE.

      IF imod = "d" THEN DO:  
        IF ilin[3] <> seqname AND seqname <> ? THEN 
          RUN write-seq-sql.  
            
        ASSIGN seqname = ilin[3].
        
        DISPLAY seqname @ tablename WITH FRAME WORKING.          
        
        IF xlate THEN DO:       
          ASSIGN forname = ilin[3] + "," + idbtyp + "," + user_env[29].
          RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT forname).
        END.
        ELSE IF LENGTH(ilin[3]) > INTEGER(user_env[29]) THEN DO:   
          ASSIGN forname = ilin[3] + "," + idbtyp + "," + user_env[29].
          RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT forname).
        END.
        ELSE
          ASSIGN forname = ilin[3].
        
        FIND DICTDB._Sequence WHERE DICTDB._Sequence._Db-recid = dbrecid
                                AND DICTDB._Sequence._Seq-name = ilin[3]
                                NO-ERROR.
        IF AVAILABLE _Sequence THEN DO:        
          /* first drop the table and write out the line */
          ASSIGN seq-line = "DROP TABLE _SEQT_ " + forname
                 seq-type = "d"
                 seqname = ilin[3].
          RUN write-seq-sql. 
          /* Now drop the associated procedure */
          ASSIGN seq-line = "DROP PROCEDURE _SEQP_" + forname
                 seq-type = "d"
                 seqname = ilin[3].

          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-line = ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '"'.
        END.
        ELSE DO:
          MESSAGE "The Delta DF File contains DROP SEQUENXE" ilin[3] SKIP
                    "and sequence does not exist in the schema holder." SKIP
                    "This process is being aborted."  SKIP (1)
                    VIEW-AS ALERT-BOX ERROR.
          RETURN.
        END.
      END.
      ELSE IF imod = "a"  OR imod = "m" THEN DO: 

        CASE ilin[1]:
          WHEN "ADD" THEN DO:
            DISPLAY ilin[3] @ tablename WITH FRAME WORKING.
            IF seq-line <> ? THEN
              RUN write-seq-sql.
            IF xlate THEN DO:       
              ASSIGN forname = ilin[3] + "," + idbtyp + "," + user_env[29].
              RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT forname).
            END.
            ELSE IF LENGTH(ilin[3]) > INTEGER(user_env[29]) THEN DO:   
              ASSIGN forname = ilin[3] + "," + idbtyp + "," + user_env[29].
              RUN "prodict/misc/_resxlat.p" (INPUT-OUTPUT forname).
            END.
            ELSE
              ASSIGN forname = ilin[3].
            
            ASSIGN seq-line = "CREATE TABLE " + mss_username + "." + "_SEQT_" + forname
                   seq-type = "a"
                   seqname = ilin[3].
            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-line = 'ADD SEQUENCE "' + ilin[3] + '"'.
            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-line = '  FOREIGN-NAME "' + LOWER(forname) + '"'.

          END.
         
          WHEN "UPDATE" THEN DO:         
            IF seqname <> ? THEN 
              RUN write-seq-sql.
            DISPLAY ilin[3] @ tablename WITH FRAME WORKING.  
            FIND FIRST DICTDB._Sequence WHERE DICTDB._Sequence._Db-recid = dbrecid
                                          AND DICTDB._Sequence._Seq-name = ilin[3]
                                          NO-ERROR.
            IF NOT AVAILABLE _Sequence THEN DO:
              MESSAGE "The Delta DF File contains UPDATE SEQUENCE" ilin[3] SKIP
                      "and sequence does not exist in the schema holder." SKIP
                       "This process is being aborted."  SKIP (1)
                    VIEW-AS ALERT-BOX ERROR.
              RETURN.
            END.
            IF AVAILABLE _Sequence THEN DO:            
              ASSIGN seq-line = "insert into " + _Sequence._Seq-misc[1]
                     seq-type = "u"
                     seqname = ilin[3].
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-line = 'UPDATE SEQUENCE "' + ilin[3] + '"'.                  
            END.          
          END.
          WHEN "INITIAL" THEN
            ASSIGN init = ilin[2].         
          WHEN "INCREMENT" THEN
            ASSIGN incre = ilin[2].
          WHEN "CYCLE-ON-LIMIT" THEN DO:
            IF ilin[2] = "no" THEN
              ASSIGN cyc = "0".
            ELSE
              ASSIGN cyc = "1".
          END.
          WHEN "MIN-VAL" THEN 
              ASSIGN minval = ilin[2].
          WHEN "MAX-VAL" THEN DO:
              ASSIGN maxval = ilin[2].
          END.
        END CASE.
      END.
      /* Rename sequence in schema holder only */          
      ELSE IF imod = "r" THEN DO:
        IF seq-line <> ? THEN
           RUN write-seq-sql.
           
        FIND FIRST DICTDB._Sequence WHERE DICTDB._Sequence._Db-recid = dbrecid
                                      AND DICTDB._Sequence._Seq-name = ilin[3]
                                      NO-ERROR.
        IF NOT AVAILABLE _Sequence THEN DO:
          MESSAGE "The Delta DF File contains RENAME SEQUENCE" ilin[3] SKIP
                  "and sequence does not exist in the schema holder." SKIP
                  "This process is being aborted."  SKIP (1)
               VIEW-AS ALERT-BOX ERROR.
          RETURN.
        END.

        DISPLAY ilin[3] @ tablename WITH FRAME WORKING.
        
        IF ilin[1] <> ? THEN do:
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-line = ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '" ' +
                           ilin[4] + ' "' + ilin[5] + '"'.
        END.  
      END.
    END.  
  END.
END.

/* flush out last line of script */
RUN write-tbl-sql.
RUN write-idx-sql.
RUN write-seq-sql.

IF user_env[2] = "yes" THEN DO:    
  FOR EACH df-info:     
    IF SUBSTRING(df-line,1,1) <> " " THEN
      PUT STREAM todf UNFORMATTED " " SKIP.
    PUT STREAM todf UNFORMATTED df-line SKIP.
  END.

  ASSIGN user_env[5] = SESSION:CPSTREAM.
  
 /* adds trailer with code-page-entry to end of file */ 
 {prodict/dump/dmptrail.i
        &entries      = " "
        &seek-stream  = "todf"
        &stream       = "stream todf"
        }   
        
  OUTPUT STREAM todf CLOSE.  
  OUTPUT STREAM tosql CLOSE. 
  HIDE FRAME working NO-PAUSE.
  
  MESSAGE "The following files have been created:" SKIP(1)
          "  MS SQL Server Script:  " sqlout  SKIP
          "     PROGRESS DF File:  " dfout SKIP(1)
          "If the delta.df contained any drop statements," SKIP
          "data will be lost from the SQL Server Database." SKIP 
          "Check for warnings in <table name>.e files " SKIP          
    VIEW-AS ALERT-BOX INFORMATION. 
END.
ELSE do:
  OUTPUT STREAM todf CLOSE.
  OUTPUT STREAM tosql CLOSE.
  OS-DELETE VALUE(dfout).
  HIDE FRAME working NO-PAUSE.
  
  MESSAGE "The following file has been created: " SKIP(1)
          "  MS SQL Server Script: " sqlout SKIP(1)
          "If the delta.df contained any drop statements," SKIP
          "data will be lost from the SQL Server Database." SKIP 
          "Check for warnings in <table name>.e files " SKIP
     VIEW-AS ALERT-BOX INFORMATION.
END.
RUN adecomm/_setcurs.p ("").
 
RETURN.





