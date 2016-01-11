/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/* Procedure: prodict/ora/_gendsql.p

     Created: Donna L. McMann
              10/20/98
              
              Creates an incremental sql script to be loaded into ORACLE
              and an incremental df to be loaded into the ORACLE Schema holder
              
     History: ll/03/98 put check in for renamed file to get proper field names  
              11/20/98 Index-fields for old file, foreign name for indexes 
              03/22/99 Changed how index names are translated
              01/18/00 Changed new shadow column to be created as VARCHAR2
              06/07/00 Added proper quoting of fields.
              06/09/00 Changed how long index names are created.
              08/11/00 Changed calculation of foreign position 20000809014
              08/17/00 Removed FORMAT from .df 20000808036
              08/19/00 Corrected compatibility not working 20000818034
              08/22/00 Changed data type for recid and integer 20000821017
              08/23/00 Changed calculation of shadow column position 20000822016
              11/13/00 Added minwidth for character format to be consistent with _wrktgen.p
              12/18/00 Added check for existing file and new-obj for foreign-pos.
              03/14/01 Changed how format for decimals are done.
              04/10/01 Assignment of index name with new table and index corrected.
              06/20/01 Added Foreign Owner
              07/09/01 Changed how index name is created to match protoora 20010523-010
              11/27/01 Added defaults and check for longs. 20011108-022 20010226-013
              11/30/01 Added check for unique table and index names 20010116-014
              12/06/01 Added support for sql-width 20010112-007
              03/15/02 Added suport for descending indexes
              07/08/02 DESC index fixes 20020702013,20020703006, 20020622001
              07/23/02 Added support for function based index, dropping fields for - V7
              09/18/02 Added support for MAX-WIDTH keyword
                  
*/              

{ prodict/user/uservar.i }
{ prodict/ora/oravar.i }

DEFINE VARIABLE iarg          AS CHARACTER             NO-UNDO. 
DEFINE VARIABLE ikwd          AS CHARACTER             NO-UNDO. 
DEFINE VARIABLE imod          AS CHARACTER             NO-UNDO. 
DEFINE VARIABLE ipos          AS INTEGER               NO-UNDO. 
DEFINE VARIABLE ilin          AS CHARACTER EXTENT 256  NO-UNDO.
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
DEFINE VARIABLE maxval        AS CHARACTER             NO-UNDO.
DEFINE VARIABLE dbrecid       AS RECID                 NO-UNDO.
DEFINE VARIABLE fldnum        AS INTEGER               NO-UNDO.
DEFINE VARIABLE shw-col       AS INTEGER               NO-UNDO.
DEFINE VARIABLE df-idx        AS CHARACTER EXTENT 6    NO-UNDO.
DEFINE VARIABLE is-unique     AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE new-ord       AS INTEGER INITIAL 1     NO-UNDO.
DEFINE VARIABLE view-created  AS LOGICAL               NO-UNDO.
DEFINE VARIABLE dropped-fld   AS LOGICAL               NO-UNDO.
DEFINE VARIABLE transname     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE dupfield      AS LOGICAL               NO-UNDO.
DEFINE VARIABLE oq-string     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE minwidth      AS INTEGER               NO-UNDO.
DEFINE VARIABLE dfseq         AS INTEGER INITIAL 1     NO-UNDO.
DEFINE VARIABLE for-init      AS CHARACTER             NO-UNDO.
DEFINE VARIABLE comment_chars AS CHARACTER             NO-UNDO.
DEFINE VARIABLE col-long      AS INTEGER               NO-UNDO.
DEFINE VARIABLE comment-out   AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE extline       AS CHARACTER             NO-UNDO.
DEFINE VARIABLE extlinenum    AS INTEGER               NO-UNDO.
DEFINE VARIABLE newstoff      AS INTEGER               NO-UNDO.

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


DEFINE TEMP-TABLE view-table NO-UNDO
  FIELD v-order  AS INTEGER
  FIELD v-table  AS CHARACTER
  FIELD v-field  AS CHARACTER
  FIELD v-line   AS CHARACTER
  FIELD v-progn  AS CHARACTER
  FIELD v-shadow AS LOGICAL INITIAL FALSE
  FIELD v-ext    AS LOGICAL INITIAL FALSE
  INDEX view-line IS PRIMARY v-table v-order ASCENDING
  INDEX v-field v-table v-field.

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
  
DEFINE TEMP-TABLE verify-index NO-UNDO
  FIELD inew-name LIKE _index._index-name
  INDEX trun-name IS UNIQUE inew-name.  

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

  ASSIGN col-long = 0
         comment_chars = "".

  FIND DICTDB._File WHERE DICTDB._File._File-name = tablename
                      AND DICTDB._File._Owner = "_FOREIGN"
                      NO-ERROR.   

  IF AVAILABLE DICTDB._File  THEN DO:
    FOR EACH DICTDB._Field OF DICTDB._File:
      IF DICTDB._Field._For-type = "LONG" THEN
            ASSIGN col-long = col-long + 1.
    END.  
    FOR EACH new-obj WHERE add-type = "F"
                       AND tbl-name = tablename:  
      IF new-obj.for-type = " LONG" THEN
        ASSIGN col-long = col-long + 1.
    END.
  END.
  ELSE DO:
    FIND FIRST new-obj WHERE add-type = "T"
                         AND tbl-name = tablename
                          NO-ERROR.

    FOR EACH new-obj WHERE add-type = "F"
                       AND tbl-name = tablename:  
      IF new-obj.for-type = " LONG" THEN
        ASSIGN col-long = col-long + 1.
    END.
  END.

  IF col-long > 1 THEN DO:
    ASSIGN comment_chars = "-- ** "
           comment-out = TRUE.

   /* Delete all df info for this table */
    FOR EACH df-info WHERE df-tbl = tablename:
      DELETE df-info.
    END.
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
                 df-line = "  PROGRESS-RECID " + string(fldnum).
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
        IF DICTDB._File._fil-misc1[4] <> 0  OR DICTDB._File._Fil-misc1[4] <> ? THEN DO:
          FIND DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Fld-stoff = DICTDB._File._Fil-misc1[4]
               NO-ERROR.
          IF AVAILABLE DICTDB._Field THEN     
            ASSIGN recidname = DICTDB._Field._Field-name.
        END.
        ELSE IF DICTDB._File._fil-misc1[1] <> 0 THEN
          ASSIGN recidname = "progress_recid".             
        
        ASSIGN forpos = 1
               extnt = FALSE.
               
        IF DICTDB._File._Fil-Misc1[1] > forpos THEN
            ASSIGN forpos = DICTDB._File._Fil-Misc1[1] + 1.

        /* if the delta sql has been done before there could be fields passed progress_recid */
        FOR LAST DICTDB._Field OF DICTDB._File BY DICTDB._Field._Fld-stoff. END.

        IF DICTDB._Field._Fld-stoff >= forpos THEN
          ASSIGN forpos = DICTDB._Field._Fld-stoff + 1.

        FOR EACH new-obj WHERE add-type = "F"
                           AND tbl-name = tblname:                                                     
          IF INDEX(for-name , "##") <> 0 THEN DO: 
            IF for-name BEGINS "U##" THEN 
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
            IF new-obj.for-name BEGINS "U##" THEN 
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
          ASSIGN forpos = forpos + 1.
        END.
      END.
    END.                                       
    IF line-num < 2 THEN
      PUT STREAM tosql UNFORMATTED comment_chars line SKIP.          
    ELSE IF NOT LAST-OF(tblname) THEN 
      PUT STREAM tosql UNFORMATTED comment_chars line "," SKIP.
    ELSE DO:          
      PUT STREAM tosql UNFORMATTED comment_chars line ")" SKIP.
      IF user_env[34] <> "" AND user_env[34] <> ? THEN
        PUT STREAM tosql UNFORMATTED comment_chars "TABLESPACE " user_env[34] SKIP. 
      PUT STREAM tosql UNFORMATTED comment_chars ";" SKIP(1).
    END.         
    DELETE sql-info.
  END.

  FOR EACH alt-info BREAK BY a-tblname BY a-line-num: 
    IF NOT LAST-OF(a-tblname) THEN 
      PUT STREAM tosql UNFORMATTED comment_chars a-line  SKIP.
    ELSE DO:          
      PUT STREAM tosql UNFORMATTED  comment_chars a-line   SKIP.       
      PUT STREAM tosql UNFORMATTED comment_chars ";" SKIP(1).
    END.         
    DELETE alt-info.
  END.
    
  IF pcompatible AND addtable THEN DO:
    IF LENGTH(p-r-index) < 15 THEN
        ASSIGN p-r-index = p-r-index + "##progress_recid ON " + p-r-index.
    ELSE
        ASSIGN p-r-index = p-r-index + " ON " + p-r-index.  
    
    PUT STREAM tosql UNFORMATTED comment_chars
      "CREATE UNIQUE INDEX " p-r-index "(progress_recid)" SKIP.
    IF user_env[35] <> "" AND user_env[35] <> ? THEN
       PUT STREAM tosql UNFORMATTED comment_chars "TABLESPACE " user_env[35] ";" SKIP(1).
    ELSE
       PUT STREAM tosql UNFORMATTED comment_chars ";" SKIP(1).   
  END.    
  
  ASSIGN addtable      = FALSE
         alt-table     = FALSE
         lnum          = 0.
           

END PROCEDURE.

PROCEDURE write-view:
  DEFINE VARIABLE dftblname   AS CHARACTER                   NO-UNDO.
  DEFINE VARIABLE orig-name   AS CHARACTER                   NO-UNDO.
  DEFINE VARIABLE forpos      AS INTEGER                     NO-UNDO.
  DEFINE VARIABLE extnt       AS LOGICAL                     NO-UNDO.
  DEFINE VARIABLE recidname   AS CHARACTER                   NO-UNDO.
  DEFINE VARIABLE recidpos    AS INTEGER                     NO-UNDO.

  IF NOT view-created THEN RETURN.

  FIND FIRST sql-info WHERE sql-info.tblname = tablename NO-ERROR.
  IF AVAILABLE sql-info THEN
    RUN write-tbl-sql.
  ELSE DO:
    FIND FIRST alt-info WHERE a-tblname = tablename NO-ERROR.
    IF AVAILABLE alt-info THEN
      RUN write-tbl-sql.
  END.      
  FIND LAST view-table WHERE v-table = tablename USE-INDEX view-line NO-ERROR.
 
  IF AVAILABLE view-table  THEN DO: 
    ASSIGN orig-name = SUBSTRING(v-line, 6). 
    IF NOT pcompatible THEN DO:
      FIND PREV view-table WHERE v-table = tablename USE-INDEX view-line.
      ASSIGN v-line = SUBSTRING(v-line,1, LENGTH(v-line) - 1). 
    END. 
    FIND view-table WHERE v-table = tablename
                      AND v-order = -1.
    ASSIGN dftblname = SUBSTRING(v-line,11)
           dftblname = SUBSTRING(dftblname,1, LENGTH(dftblname) - 1).
 
    ASSIGN forpos = 1. 
    FOR EACH view-table USE-INDEX view-line BREAK BY v-table:
      IF v-order < 2 THEN NEXT.
      IF NOT v-shadow AND NOT v-ext AND v-progn <> "" AND v-prog <> ? THEN DO:
        CREATE df-info.
        ASSIGN df-info.df-seq = dfseq
               dfseq = dfseq + 1
               df-info.df-tbl = v-table
               df-line = 'UPDATE FIELD "' + v-progn + '" OF "' + v-table + '"'.
        CREATE df-info.
        ASSIGN df-info.df-seq = dfseq
               dfseq = dfseq + 1
               df-info.df-tbl = v-table
               df-line = "  FOREIGN-POS " + STRING(forpos).
      END.
      
      IF v-shadow THEN DO:      
        CREATE df-info.
        ASSIGN df-info.df-seq = dfseq
               dfseq = dfseq + 1
               df-info.df-tbl = v-table
               df-line = 'UPDATE FIELD "' + v-progn + '" OF "' + v-table + '"'.
        CREATE df-info.
        ASSIGN df-info.df-seq = dfseq
               dfseq = dfseq + 1
               df-info.df-tbl = v-table
               df-line = '  SHADOW-COL "' + STRING(forpos) + '"'. 
        CREATE df-info.
        ASSIGN df-info.df-seq = dfseq
               dfseq = dfseq + 1
               df-info.df-tbl = v-table
               df-line = "  FIELD-MISC15 " + STRING(forpos).
      END. 
      IF recidname = v-progn THEN
        ASSIGN recidpos = forpos.
      IF LAST-OF(v-table) AND pcompatible THEN
        ASSIGN recidpos = forpos.     
      ASSIGN forpos = forpos + 1.
    END. 
    CREATE df-info.
    ASSIGN df-info.df-seq = dfseq
           dfseq = dfseq + 1
           df-info.df-tbl = tablename
           df-line = 'UPDATE TABLE "' + tablename + '"'.
    CREATE df-info.
    ASSIGN df-info.df-seq = dfseq
           dfseq = dfseq + 1
           df-info.df-tbl = tablename
           df-line = '  FOREIGN-NAME "' + CAPS(dftblname) + '"'.

    CREATE df-info.
    ASSIGN df-info.df-seq = dfseq
           dfseq = dfseq + 1
           df-info.df-tbl = tablename
           df-line = '  FILE-MISC27 "' + orig-name + '"'.      
    CREATE df-info.
    ASSIGN df-info.df-seq = dfseq
           dfseq = dfseq + 1
           df-info.df-tbl = tablename
           df-line = '  FOREIGN-TYPE "VIEW"'. 
    IF recidpos <> 0 THEN DO:
      IF pcompatible THEN DO:
        CREATE df-info.
        ASSIGN df-info.df-seq = dfseq
               dfseq = dfseq + 1
               df-info.df-tbl = tablename
               df-line = '  PROGRESS-RECID ' + STRING(recidpos).
      END.
      ELSE DO:
        CREATE df-info.
        ASSIGN df-info.df-seq = dfseq
               dfseq = dfseq + 1
               df-info.df-tbl = tablename
               df-line = '  RECID-COL-NO ' + STRING(recidpos).
      END.
    END.
  END. 
                                
  FOR EACH view-table USE-INDEX view-line BREAK BY v-table :    
    IF v-order < 2 THEN
      PUT STREAM tosql UNFORMATTED comment_chars  v-line SKIP.           
    ELSE IF LAST-OF(v-table) THEN DO:
      IF pcompatible THEN DO:
        PUT STREAM tosql UNFORMATTED comment_chars  "PROGRESS_RECID" SKIP.
        PUT STREAM tosql UNFORMATTED comment_chars v-line ";" SKIP(1). 
      END.
      ELSE
        PUT STREAM tosql UNFORMATTED comment_chars v-line ";" SKIP(1). 
    END.  
    ELSE 
      PUT STREAM tosql UNFORMATTED comment_chars v-line SKIP.      

    DELETE view-table.
  END. 
END PROCEDURE.

PROCEDURE write-idx-sql:
  IF idxline = ? OR idxline = "" THEN LEAVE.

  IF pcompatible AND is-unique = FALSE THEN 
      ASSIGN idxline = idxline + ", PROGRESS_RECID".
  IF user_env[35] <> "" AND user_env[35] <> ? THEN DO:
    PUT STREAM tosql UNFORMATTED comment_chars idxline ")" SKIP.
    PUT STREAM tosql UNFORMATTED comment_chars "TABLESPACE " user_env[35] SKIP.
    PUT STREAM tosql UNFORMATTED comment_chars ";" SKIP(1).
  END.
  ELSE      
    PUT STREAM tosql UNFORMATTED comment_chars idxline ");"  SKIP(1).
    
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
  IF seq-type = "d"  THEN 
    PUT STREAM tosql UNFORMATTED seq-line ";" SKIP(1).
  ELSE DO:
    PUT STREAM tosql UNFORMATTED seq-line " " SKIP.
    IF incre <> ? AND incre <> "" THEN
      PUT STREAM tosql UNFORMATTED "INCREMENT BY " incre " " SKIP. 
    IF seq-type = "u" THEN.
    ELSE DO:
      IF (init <> ? AND init <> "") THEN
        PUT STREAM tosql UNFORMATTED "START WITH " init " " SKIP.
    END.
    IF maxval <> ? AND maxval <> "" THEN
      PUT STREAM tosql UNFORMATTED "MAXVALUE " maxval SKIP.
    ELSE
      PUT STREAM tosql UNFORMATTED "NOMAXVALUE"  SKIP.  
    IF minval <> ? AND minval <> "" THEN
      PUT STREAM tosql UNFORMATTED "MINVALUE " minval SKIP.
    ELSE
      PUT STREAM tosql UNFORMATTED "NOMINVALUE" SKIP.  
    IF cyc <> ? AND cyc <> "" THEN       
        PUT STREAM tosql UNFORMATTED cyc SKIP.              
    PUT STREAM tosql UNFORMATTED ";" SKIP(1).
    IF init <> ? AND init <> "" THEN DO:
      CREATE df-info.
      ASSIGN df-info.df-seq = dfseq
             dfseq = dfseq + 1
             df-line = "  INITIAL " + init.
    END.
    CREATE df-info.
    ASSIGN df-info.df-seq = dfseq
           dfseq = dfseq + 1
           df-line = "  INCREMENT " + incre.

    IF cyc = "CYCLE" THEN 
      ASSIGN cyc = "yes".
    ELSE
      ASSIGN cyc = "no".  

    CREATE df-info.
    ASSIGN df-info.df-seq = dfseq
           dfseq = dfseq + 1
           df-line = "  CYCLE-ON-LIMIT " + cyc.
  
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

    IF ora_owner <> "" THEN DO:
      CREATE df-info.
      ASSIGN df-info.df-seq = dfseq
             dfseq = dfseq + 1
             df-line = '  FOREIGN-OWNER "' + CAPS(ora_owner) + '"'.
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
           prg-name = ilin[3].
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

PROCEDURE create-view:
  DEFINE VARIABLE rename       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE rename-table AS CHARACTER NO-UNDO.
                    
  IF AVAILABLE rename-obj THEN DO:  
    IF rename-type = "T" THEN 
      ASSIGN rename = TRUE
             rename-table = new-name.
    ELSE
      ASSIGN rename = FALSE.
  END.  
  ELSE
    ASSIGN rename = FALSE.      

  IF NOT AVAILABLE DICTDB._File THEN DO:
    IF rename THEN
      FIND DICTDB._File WHERE DICTDB._File._File-name = old-name NO-ERROR.
    ELSE
      FIND DICTDB._File WHERE DICTDB._File._File-name = tablename NO-ERROR.
  END.
  IF NOT AVAILABLE DICTDB._File THEN DO.
    ASSIGN view-created = FALSE.
    RETURN.
  END.  
  IF NOT rename THEN DO:
    FIND FIRST rename-obj WHERE old-name = DICTDB._File._File-name NO-ERROR.
    IF AVAILABLE rename-obj THEN
      ASSIGN rename = TRUE
             rename-table = new-name.
  END.
  
  IF LENGTH(DICTDB._File._For-name) > 4 AND SUBSTRING(DICTDB._File._For-name, LENGTH(DICTDB._File._For-name) - 4 ) = "_V##" THEN DO:
    IF DICTDB._File._fil-misc2[7] <> ? AND DICTDB._File._fil-misc2[7] <> "" THEN
      ASSIGN forname = DICTDB._File._fil-misc2[7].
    ELSE
      ASSIGN forname = SUBSTRING(DICTDB._File._For-name, 1, (LENGTH(DICTDB._File._For-name) - 4)).  
  END.
  ELSE    
    ASSIGN forname = DICTDB._File._For-name.  
  FIND view-table WHERE v-order = -1 NO-ERROR.
  IF NOT AVAILABLE view-table THEN DO:           
    CREATE view-table.
    ASSIGN v-order = -1
           v-table = (IF rename THEN rename-table ELSE DICTDB._File._File-name)
           v-line = "DROP VIEW " + forname + "_V## ;".
  
    CREATE view-table.
    ASSIGN lnum = 1 
           v-order = lnum
           v-table = (IF rename THEN rename-table ELSE DICTDB._File._File-name)       
           v-line = "CREATE VIEW " + forname + "_V## AS SELECT". 
  
    CREATE view-table.
    ASSIGN v-order = 10001
           v-table = (IF rename THEN rename-table ELSE DICTDB._File._File-name)
           v-line = "FROM " + forname.               
  END. 
  
  _fld-loop:                                                
  FOR EACH DICTDB._Field OF DICTDB._File NO-LOCK:        
    IF DICTDB._Field._Field-name = ilin[3] THEN NEXT.
    FIND FIRST drop-field WHERE of-table = (IF rename THEN rename-table ELSE DICTDB._File._File-name)
                            AND drop-f-name = DICTDB._Field._Field-name
                            NO-ERROR.   
    IF AVAILABLE drop-field THEN  NEXT _fld-loop.                                       
                           
    IF DICTDB._Field._Extent = 0 THEN DO:             
      CREATE view-table.
      ASSIGN lnum = lnum + 1
             v-order = lnum
             v-line = DICTDB._Field._For-name + ","  
             v-table = (IF rename THEN rename-table ELSE DICTDB._File._File-name)
             v-field = DICTDB._Field._Field-name.
             
      FIND FIRST rename-obj WHERE rename-type = "F"
                              AND t-name = (IF rename THEN rename-table ELSE DICTDB._File._File-name)
                              AND old-name = DICTDB._Field._Field-name
                              NO-ERROR.
      IF AVAILABLE rename-obj THEN
        ASSIGN v-progn = new-name.
      ELSE                         
        ASSIGN v-progn = DICTDB._Field._Field-name.
              
      IF DICTDB._Field._Fld-misc2[2] <> ? AND DICTDB._Field._Fld-misc2[2] <> "" THEN DO:       
        CREATE view-table.
        ASSIGN lnum = lnum + 1
               v-order = lnum
               v-line = "U##" + DICTDB._Field._For-name + ","
               v-table = (IF rename THEN rename-table ELSE DICTDB._File._File-name)
               v-field = "U##" + DICTDB._Field._For-name
               v-shadow = TRUE.
               
        FIND FIRST rename-obj WHERE rename-type = "F"
                                AND t-name = (IF rename THEN rename-table ELSE DICTDB._File._File-name)
                                AND old-name = DICTDB._Field._Field-name
                                NO-ERROR.
        IF AVAILABLE rename-obj THEN
          ASSIGN v-progn = new-name.
        ELSE                         
          ASSIGN v-progn = DICTDB._Field._Field-name.   
                      
      END.
    END.
    ELSE DO:
      DO i = 1 TO DICTDB._Field._Extent:
        CREATE view-table.
        ASSIGN lnum = lnum + 1
               v-order = lnum
               v-line = DICTDB._Field._For-name + "##" + STRING(i) + ","
               v-table = (IF rename THEN rename-table ELSE DICTDB._File._File-name)
               v-field = DICTDB._Field._For-name + "##" + STRING(i)               
               v-ext   = TRUE.
                
        FIND FIRST rename-obj WHERE rename-type = "F"
                                AND t-name = (IF rename THEN rename-table ELSE DICTDB._File._File-name)
                                AND old-name = DICTDB._Field._Field-name
                                NO-ERROR.
        IF AVAILABLE rename-obj THEN
          ASSIGN v-progn = new-name
                 v-ext = (IF i = 1 THEN FALSE ELSE TRUE).
        ELSE                         
          ASSIGN v-progn = DICTDB._Field._Field-name
                 v-ext = (IF i = 1 THEN FALSE ELSE TRUE).                                                                         
      END.                        
    END.
  END. /* FOR EACH FIELD */            
  FOR EACH new-obj WHERE add-type = "F" 
                     AND tbl-name = (IF rename THEN rename-table ELSE DICTDB._File._File-name):                          
    CREATE view-table.
    ASSIGN lnum = lnum + 1
           v-order = lnum
           v-line = for-name + ","
           v-table = (IF rename THEN rename-table ELSE DICTDB._File._File-name)
           v-field = fieldname
           v-progn = prg-name.
     
    IF for-name BEGINS "U##" THEN ASSIGN v-shadow = TRUE.       
  END.  
END PROCEDURE.

PROCEDURE new-obj-idx:           
  ASSIGN fortype = new-obj.for-type
         forname = new-obj.for-name.
                              
  FIND new-obj where new-obj.add-type = "F"
                 AND new-obj.tbl-name = tablename
                 AND new-obj.fld-name = "U##" + ilin[2]
                 NO-ERROR.                                                                              
  
  IF NOT AVAILABLE new-obj THEN DO:  /* need to alter the table to create field */ 
   /* FIND FIRST new-obj WHERE new-obj.add-type = "F"
                         AND new-obj.tbl-name = tablename
                         AND new-obj.prg-name = ilin[2].
     */                                                           
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
    ASSIGN s-fld-name = "U##" + forname
           p-fld-name = ilin[2]
           s-tbl-name = tablename
           col-num = shw-col.                
 
    CREATE new-obj.
    ASSIGN new-obj.add-type = "F"
           new-obj.tbl-name = tablename
           new-obj.n-order = new-ord
           new-ord = new-ord + 1
           new-obj.for-name = "U##" + forname
           new-obj.fld-name = "U##" + ilin[2]
           new-obj.prg-name = ilin[2]
           new-obj.for-type = fortype. 
    
    FIND n-obj WHERE n-obj.add-type = "t"
                 AND n-obj.tbl-name = tablename.
                              
    PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " + n-obj.for-name SKIP.
    PUT STREAM tosql UNFORMATTED comment_chars " ADD " + new-obj.for-name + " " + new-obj.for-type + ";" SKIP(1).                                                          
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
    FOR EACH DICTDB._Field OF DICTDB._File:
      IF DICTDB._Field._Fld-stoff > i THEN
       ASSIGN i = DICTDB._Field._Fld-stoff.
      IF INTEGER(DICTDB._Field._Fld-misc2[2]) > i THEN
        ASSIGN i = INTEGER(DICTDB._Field._Fld-misc2[2]).
    END.
    IF i < DICTDB._File._Fil-misc1[1] THEN
        ASSIGN i = DICTDB._File._Fil-misc1[1].
    FOR EACH new-obj WHERE new-obj.add-type = "F"
                       AND new-obj.tbl-name = tablename:                      
      ASSIGN i = i + 1.
    END.
    CREATE df-info.
    ASSIGN df-info.df-seq = dfseq
           dfseq = dfseq + 1
           df-info.df-tbl = tablename
           df-line = '  FOREIGN-POS ' + STRING(i).  
  END.   
END PROCEDURE.  

PROCEDURE new-for-position:
  DEFINE VARIABLE recidname AS CHARACTER NO-UNDO.
  DEFINE VARIABLE forpos    AS INTEGER   NO-UNDO.

  FIND DICTDB._File WHERE DICTDB._File._File-name = tablename
                      AND DICTDB._File._Owner = "_FOREIGN"
                      NO-ERROR.          
  IF NOT AVAILABLE DICTDB._File THEN DO:
    FIND rename-obj WHERE rename-obj.new-name = tablename NO-ERROR.
    IF AVAILABLE rename-obj THEN
      FIND DICTDB._File WHERE DICTDB._File._File-name = old-name NO-ERROR.
  END.
  IF AVAILABLE DICTDB._File THEN DO:
    IF DICTDB._File._fil-misc1[4] <> 0  AND DICTDB._File._Fil-misc1[4] <> ? THEN DO:
      FIND DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Fld-stoff = DICTDB._File._Fil-misc1[4]
               NO-ERROR.
      IF AVAILABLE DICTDB._Field THEN     
         ASSIGN recidname = DICTDB._Field._Field-name.
    END.
    ELSE IF DICTDB._File._fil-misc1[1] <> 0 THEN
      ASSIGN recidname = "progress_recid".

    IF recidname <> ? AND recidname <> "" THEN DO:
      CREATE new-position.
      ASSIGN new-position.table-np = DICTDB._File._File-name
             new-position.field-np = recidname
             new-position.old-pos  = DICTDB._File._Fil-Misc1[1]
             new-position.shadow   = 0
             new-position.extent#  = 0.
    END.

    FOR EACH DICTDB._Field OF DICTDB._File:
      CREATE new-position.
      ASSIGN new-position.table-np = DICTDB._File._File-name
             new-position.field-np = DICTDB._Field._Field-name
             new-position.old-pos  = DICTDB._Field._Fld-stoff
             new-position.shadow   = (IF DICTDB._Field._Fld-Misc1[5] > 0 THEN
                                       DICTDB._Field._Fld-Misc1[5]
                                      ELSE 0)
             new-position.extent#  = (IF DICTDB._Field._Extent > 0 THEN
                                          DICTDB._Field._Extent
                                       ELSE 0).
    END.
    ASSIGN forpos = 0.
    FOR EACH new-position WHERE table-np = DICTDB._File._File-name:
      FIND FIRST drop-field WHERE drop-field.of-table = new-position.table-np
                              AND drop-field.f-name = new-position.field-np NO-ERROR.
      IF AVAILABLE drop-field THEN DO:                
        IF new-position.extent# <> 0 THEN
          ASSIGN forpos = forpos + new-position.extent#.
        ELSE
          ASSIGN forpos = forpos + 1.
        IF new-position.shadow <> 0 THEN
          ASSIGN new-position.shadow = new-position.shadow - forpos
                 new-position.new-pos = new-position.old-pos - forpos
                 new-position.dropped = TRUE.
        ELSE
          ASSIGN new-position.new-pos = new-position.old-pos - forpos
                 new-position.dropped = TRUE.
      END.
      ELSE DO:
        IF new-position.shadow <> 0 THEN
          ASSIGN new-position.shadow = new-position.shadow - forpos
                 new-position.new-pos = new-position.old-pos - forpos.
        ELSE
          ASSIGN new-position.new-pos = new-position.old-pos - forpos.
      END.
    END.
    FIND LAST new-position WHERE new-position.table-np = DICTDB._File._File-name NO-ERROR.
    ASSIGN forpos = new-position.new-pos + 1.
    FOR EACH new-obj WHERE add-type = "F"
                       AND tbl-name = DICTDB._File._File-name:   
      IF INDEX(new-obj.for-name, "##1") <> 0 THEN DO:
        CREATE new-position.
        ASSIGN new-position.table-np = DICTDB._File._File-name
               new-position.field-np = prg-name
               new-position.new-pos  = forpos.
        FOR EACH n-obj WHERE n-obj.prg-name = new-obj.prg-name:
          ASSIGN forpos = forpos + 1.
        END.
      END.
      ELSE IF INDEX(new-obj.for-name, "##") <> 0 THEN NEXT.
      IF new-obj.for-name BEGINS "U##" THEN 
         ASSIGN forpos = forpos + 1.
      ELSE DO:
        CREATE new-position.
        ASSIGN new-position.table-np = DICTDB._File._File-name
               new-position.field-np = new-obj.prg-name.

        FIND FIRST n-obj WHERE n-obj.prg-name BEGINS SUBSTRING(new-obj.prg-name, 3) NO-ERROR.
        IF AVAILABLE n-obj  THEN
           ASSIGN new-position.shadow   = forpos
                  forpos                = forpos + 1
                  new-position.new-pos  = forpos                     
                  forpos                = forpos + 1.
        ELSE
          ASSIGN new-position.new-pos  = forpos                     
                 forpos                = forpos + 1.
      END.
    END.
    FOR EACH new-position WHERE table-np = DICTDB._File._File-name
                            AND new-position.dropped = FALSE:

      IF new-position.field-np = recidname THEN DO:
        CREATE df-info.
        ASSIGN df-info.df-seq = dfseq
               dfseq = dfseq + 1
               df-info.df-tbl = new-position.table-np
               df-line = 'UPDATE TABLE "' + DICTDB._File._File-name + '"'.
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

PROCEDURE check-view:
  IF view-created THEN DO: 
    IF iobj = "t" THEN DO:
      IF tablename <> ilin[3] THEN DO:
        RUN create-view.
        RUN write-view. 
        ASSIGN view-created = FALSE.
      END.
    END.    
  
    ELSE IF iobj = "f" THEN DO:
      IF tablename <> ilin[5] THEN DO:
        RUN create-view.
        RUN write-view. 
        ASSIGN view-created = FALSE.
      END.
    END.    
     
    ELSE IF iobj = "i" THEN DO:
      DO i = 4 TO 10:
        IF ilin[i] = "ON" THEN DO:
          IF ilin[i + 1] <> tablename THEN DO:
            RUN create-view.
            RUN write-view.
            ASSIGN view-created = FALSE
                   i = 11.
          END.
        END.
      END.
    END.
  END.
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
        IF ora_version > 7 THEN DO:
          IF DICTDB._Field._Data-type <> "Character" THEN DO:
            IF INDEX(idxline, "(") = 0 THEN
              ASSIGN idxline = idxline + "( " + DICTDB._Field._For-name.
            ELSE
              ASSIGN idxline = idxline + ", " + DICTDB._Field._For-name.  
          END.
          ELSE DO:
            IF INDEX(idxline, "(") = 0 THEN
              ASSIGN idxline = idxline + "(UPPER(" + DICTDB._Field._For-name + ")".
            ELSE
              ASSIGN idxline = idxline + ", UPPER(" + DICTDB._Field._For-name + ")".  
          END.
        END.
        ELSE DO:
          IF INDEX(idxline, "(") = 0 THEN
            ASSIGN idxline = idxline + "( " + DICTDB._Field._For-name.
          ELSE
            ASSIGN idxline = idxline + ", " + DICTDB._Field._For-name.  
        END.
      END.
      ELSE DO: 
        IF DICTDB._Field._Data-type <> "Character" THEN DO: 
          IF INDEX(idxline, "(") = 0 THEN
            ASSIGN idxline = idxline + "( " + DICTDB._Field._For-name.
          ELSE
           ASSIGN idxline = idxline + ", " + DICTDB._Field._For-name.  
      END.     
      ELSE IF DICTDB._Field._Data-type = "Character" THEN DO:                                    
        IF (DICTDB._Field._Fld-misc2[2] <> ? and DICTDB._Field._Fld-misc2[2] <> "") OR
            CAN-FIND(new-obj where new-obj.add-type = "F"
                               AND new-obj.tbl-name = tablename
                               AND new-obj.fld-name = "U##" + ilin[2]) THEN DO: /* shawdow column exists in file */

          IF INDEX(idxline, "(") = 0 THEN
            ASSIGN idxline = idxline + "(U##" + DICTDB._Field._For-name.
          ELSE
            ASSIGN idxline = idxline + ", U##" + DICTDB._Field._For-name.  

        END.                    
        ELSE DO: /* shawdow not in original file see if already created */     
          FIND FIRST new-obj where new-obj.add-type = "F"
                               AND new-obj.tbl-name = tablename
                               AND new-obj.prg-name = ilin[2]
                               AND new-obj.fld-name BEGINS "U##" 
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
                    s-fld-name = "U##" + DICTDB._Field._For-name
                    j = DICTDB._Field._Fld-Misc1[3].
                              
             CREATE new-obj.
             ASSIGN new-obj.add-type = "F"
                    new-obj.tbl-name = tablename
                    new-obj.n-order = new-ord
                    new-ord = new-ord + 1
                    new-obj.fld-name = "U##" + DICTDB._Field._For-name
                    new-obj.prg-name = ilin[2]
                    new-obj.for-name = "U##" + DICTDB._Field._For-name. 
                         
             IF DICTDB._File._Fil-Misc2[7] <> "" AND DICTDB._File._Fil-Misc2[7] <> ? THEN
                 PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " +  DICTDB._File._Fil-Misc2[7] SKIP.
             ELSE 
                 PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " + DICTDB._File._For-name SKIP.
               IF ora_version > 7 THEN DO: 
               IF j < 4001 THEN DO:                                   
                 PUT STREAM tosql UNFORMATTED comment_chars "  ADD " + new-obj.fld-name + " " + "VARCHAR2" + "(" +
                               STRING(j) + ");" SKIP(1).
                 ASSIGN new-obj.for-type = "VARCHAR2" + "(" + STRING(j) + ")".  
               END.      
               ELSE DO:
                 PUT STREAM tosql UNFORMATTED comment_chars "  ADD " + new-obj.fld-name + " " + "LONG" + ";" SKIP(1).
                 ASSIGN new-obj.for-type = "LONG".
               END.     
             END.
             ELSE DO: /* Oracle 7 */
               IF j < 2001 THEN DO:                    
                 PUT STREAM tosql UNFORMATTED comment_chars "  ADD " + new-obj.fld-name + " " + "VARCHAR2" + "(" +
                                     STRING(j) + ");" SKIP(1).
                 ASSIGN new-obj.for-type = "VARCHAR2" + "(" + STRING(j) + ")".
               END.        
               ELSE DO: 
                 PUT STREAM tosql UNFORMATTED comment_chars " ADD " + new-obj.fld-name + " " + "LONG" + ";" SKIP(1).
                 ASSIGN new-obj.for-type = "LONG".
               END.
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
      END.
      IF ilin[3] BEGINS "DESC"  THEN
        ASSIGN idxline = idxline + " DESC ".
    END. /* end available field */                             
    ELSE DO: /* Not available field see if renamed field */   

      FIND rename-obj WHERE rename-type = "F" 
                        AND t-name = tablename
                        AND new-name = ilin[2] NO-ERROR.                                    
      IF AVAILABLE rename-obj THEN DO:      
        FIND DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Field-name = old-name NO-ERROR.                   
        IF AVAILABLE DICTDB._Field THEN DO:
          IF NOT shadowcol THEN DO:
            IF ora_version > 7 THEN DO:
              IF DICTDB._Field._Data-type <> "Character" THEN DO:
                IF INDEX(idxline, "(") = 0 THEN
                  ASSIGN idxline = idxline + "( " + DICTDB._Field._For-name.
                ELSE
                  ASSIGN idxline = idxline + ", " + DICTDB._Field._For-name.  
              END.
              ELSE DO:
                IF INDEX(idxline, "(") = 0 THEN
                  ASSIGN idxline = idxline + "(UPPER(" + DICTDB._Field._For-name + ")".
                ELSE
                  ASSIGN idxline = idxline + ", UPPER(" + DICTDB._Field._For-name + ")".  
              END.
            END.
            ELSE DO:
              IF INDEX(idxline, "(") = 0 THEN
                ASSIGN idxline = idxline + "( " + DICTDB._Field._For-name.
              ELSE
                ASSIGN idxline = idxline + ", " + DICTDB._Field._For-name.  
            END.          
          END.
          ELSE DO:
            IF DICTDB._Field._Data-type = "Character" THEN DO: 
              IF (DICTDB._Field._Fld-misc2[2] <> ? and DICTDB._Field._Fld-misc2[2] <> "") OR
                 CAN-FIND(new-obj where new-obj.add-type = "F"
                                    AND new-obj.tbl-name = tablename
                                    AND new-obj.fld-name = "U##" + DICTDB._Field._For-name) THEN DO:                     
                IF INDEX(idxline, "(") = 0 THEN
                  ASSIGN idxline = idxline + "(U##" + dsv-name.
                ELSE
                  ASSIGN idxline = idxline + ", U##" + dsv-name.                          
              END.
              ELSE DO: /* shawdow not in file see if already created */                      
                FIND new-obj where new-obj.add-type = "F"
                               AND new-obj.tbl-name = tablename
                               AND new-obj.fld-name = "U##" + DICTDB._Field._For-name
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
                       s-fld-name = "U##" + DICTDB._Field._For-name
                       j = DICTDB._Field._Fld-Misc1[3].
                  
                CREATE new-obj.
                ASSIGN new-obj.add-type = "F"
                       new-obj.tbl-name = tablename
                       new-obj.n-order = new-ord
                       new-ord = new-ord + 1
                       new-obj.fld-name = "U##" + DICTDB._Field._For-name
                       new-obj.prg-name = ilin[2]
                       new-obj.for-name = "U##" + DICTDB._Field._For-name. 
                IF DICTDB._File._Fil-Misc2[7] <> "" AND DICTDB._File._Fil-Misc2[7] <> ? THEN
                  PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " +  DICTDB._File._Fil-Misc2[7] SKIP.
                ELSE 
                  PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " + DICTDB._File._For-name SKIP.

                  IF ora_version > 7 THEN DO: 
                  IF j < 4001 THEN DO:                    
                    PUT STREAM tosql UNFORMATTED comment_chars "  ADD " + new-obj.fld-name + " " + "VARCHAR2" + "(" +
                                   STRING(j) + ");" SKIP(1).
                    ASSIGN new-obj.for-type = "VARCHAR2" + "(" + STRING(j) + ")".  
                  END.      
                  ELSE DO:
                    PUT STREAM tosql UNFORMATTED comment_chars " ADD " + new-obj.fld-name + " " + "LONG" + ";" SKIP(1).
                    ASSIGN new-obj.for-type = "LONG".
                  END.     
                END.
                ELSE DO: /* Oracle 7 */
                  IF j < 2001 THEN DO:                    
                    PUT STREAM tosql UNFORMATTED comment_chars " ADD " + new-obj.fld-name + " " + "VARCHAR2" + "(" +
                                       STRING(j) + ");" SKIP(1).
                    ASSIGN new-obj.for-type = "VARCHAR2" + "(" + STRING(j) + ")".
                  END.        
                  ELSE DO:
                    PUT STREAM tosql UNFORMATTED comment_chars " ADD " + new-obj.fld-name + " " + "LONG" + ";" SKIP(1).
                    ASSIGN new-obj.for-type = "LONG".
                  END.
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
          IF SUBSTRING(new-obj.for-type,2,7) = "VARCHAR" THEN DO:                      
            ASSIGN fortype = new-obj.for-type
                   forname = new-obj.for-name.
            IF NOT shadowcol THEN DO:
              IF ora_version > 7 THEN DO:
                IF INDEX(idxline, "(") = 0 THEN
                  ASSIGN idxline = idxline + "(UPPER(" + new-obj.for-name + ")".
                ELSE
                  ASSIGN idxline = idxline + ", UPPER(" + new-obj.for-name + ")". 
              END.
              ELSE DO:
                IF INDEX(idxline, "(") = 0 THEN
                  ASSIGN idxline = idxline + "(" + new-obj.for-name.
                ELSE
                  ASSIGN idxline = idxline + ", " + new-obj.for-name. 
              END.
            END.
            ELSE DO:
              FIND n-obj where n-obj.add-type = "F"
                           AND n-obj.tbl-name = tablename
                           AND n-obj.fld-name = "U##" + ilin[2]
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

              FOR EACH new-Obj WHERE new-obj.add-type = "F"
                                 AND new-obj.tbl-name = tablename:
                ASSIGN shw-col = shw-col + 1.
              END.               

              ASSIGN shw-col = shw-col + 1.  
                                                                                              
              CREATE shad-col.
              ASSIGN p-fld-name = ilin[2]
                     s-fld-name = "U##" + forname
                     s-tbl-name = tablename
                     col-num = shw-col.                
 
              CREATE new-obj.
              ASSIGN new-obj.add-type = "F"
                     new-obj.tbl-name = tablename
                     new-obj.n-order = new-ord
                     new-ord = new-ord + 1
                     new-obj.for-name = "U##" + forname
                     new-obj.fld-name = "U##" + ilin[2]
                     new-obj.prg-name = ilin[2]
                     new-obj.for-type = (IF fortype BEGINS "CHAR" THEN "VARCHAR2"
                                                       ELSE fortype). 
                              
              IF DICTDB._File._Fil-Misc2[7] <> "" AND DICTDB._File._Fil-Misc2[7] <> ? THEN
                 PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " +  DICTDB._File._Fil-Misc2[7] SKIP.
             ELSE 
                 PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " + DICTDB._File._For-name SKIP.

                PUT STREAM tosql UNFORMATTED comment_chars " ADD " + new-obj.for-name + " " + new-obj.for-type + ";" SKIP(1).                                                          
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
      IF SUBSTRING(new-obj.for-type,2,7) = "VARCHAR" THEN DO:
        IF NOT shadowcol THEN DO:
          IF ora_version > 7 THEN DO:
            IF INDEX(idxline, "(") = 0 THEN
              ASSIGN idxline = idxline + "(UPPER(" + new-obj.for-name + ")".
            ELSE
              ASSIGN idxline = idxline + ", UPPER(" + new-obj.for-name + ")".
          END.
          ELSE DO:
            IF INDEX(idxline, "(") = 0 THEN
              ASSIGN idxline = idxline + "(" + new-obj.for-name.
            ELSE
              ASSIGN idxline = idxline + ", " + new-obj.for-name.
          END.
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
       sqlout = ora_dbname + ".sql"
       idbtyp = (IF user_env[32] = ? THEN user_env[22] ELSE user_env[32])
       xlate  = (user_env[8] BEGINS "y")
       minwidth = 30.
   
OUTPUT STREAM todf TO VALUE(dfout) NO-ECHO NO-MAP.
OUTPUT STREAM tosql TO VALUE(sqlout) NO-ECHO NO-MAP.

INPUT FROM VALUE(user_env[1]).              

SESSION:IMMEDIATE-DISPLAY = yes.

RUN adecomm/_setcurs.p ("WAIT").

FIND FIRST DICTDB._File NO-ERROR.
IF AVAILABLE DICTDB._File THEN
  ASSIGN dbrecid = DICTDB._File._Db-recid.
   
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
    
    CASE ilin[2]:
      WHEN "DATABASE":u OR WHEN "CONNECT":u OR WHEN "FILE":u   OR 
      WHEN "TABLE":u    OR WHEN "FIELD":u   OR WHEN "COLUMN":u OR 
      WHEN "INDEX":u    OR WHEN "KEY":u     OR WHEN "SEQUENCE":u
          THEN RUN check-view.      
    END CASE.
    
  
                    
    IF iobj = "d"  or startdf THEN DO: 
      CREATE df-info.
      ASSIGN df-info.df-seq = dfseq
             dfseq = dfseq + 1
             df-line = "UPDATE DATABASE " + '"' + ora_dbname + '"'. 
      ASSIGN startdf = FALSE.
    END.  
          
    IF iobj = "t" THEN DO:
      IF imod = "d" THEN DO:
        IF tablename <> ? AND tablename <> ilin[3] THEN 
          RUN write-tbl-sql.            
                         
       IF idxline <> ? THEN 
          RUN write-idx-sql.

       IF tablename <> ilin[3] THEN
         ASSIGN tablename = ilin[3]
                 comment_chars = "".

        IF tablename <> ? THEN                             
          DISPLAY tablename WITH FRAME working.
    
        FIND FIRST DICTDB._File WHERE DICTDB._File._File-name = ilin[3]
                                  AND DICTDB._File._Owner = "_FOREIGN" NO-ERROR.
        IF AVAILABLE DICTDB._File THEN DO:
          PUT STREAM tosql UNFORMATTED comment_chars "DROP TABLE " DICTDB._File._For-name user_env[5] SKIP(1).
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = DICTDB._File._File-name
                 df-line = "DROP TABLE " + '"' + DICTDB._File._File-name + '"'.
        END.
        ASSIGN ilin = ?.
      END. /* End delete table */

      /* Rename table */
      ELSE IF imod = "r" THEN DO:
        IF tablename <> ? AND tablename <> ilin[5] THEN 
          Run write-tbl-sql.                      
        
        IF idxline <> ? THEN 
          RUN write-idx-sql.
 
        IF tablename <> ilin[5] THEN
          ASSIGN tablename = ilin[5]
                 comment_chars = "".

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
          ELSE DO:
            IF DICTDB._File._Fil-misc2[7] <> "" AND DICTDB._File._Fil-misc2[7] <> ? THEN
              ASSIGN dsv-name = DICTDB._File._Fil-misc2[7].
            ELSE
              ASSIGN dsv-name = SUBSTRING(DICTDB._File._For-name, 1,(LENGTH(DICTDB._File._For-name) -  4)).
          END.                    
        END. 
        ASSIGN ilin = ?. 
      END. /* End Rename Table */
      
      /* Add new table */
      ELSE IF imod = "a" THEN DO:                               
        IF ilin[1] = "ADD" AND ilin[2] = "TABLE" THEN DO: 
          RUN write-tbl-sql.
          
          IF idxline <> ? THEN 
             RUN write-idx-sql.

          ASSIGN addtable = TRUE
                 tablename = ilin[3]
                 fldnum = 0
                 idx-number = 1
                 comment_chars = "".
                                                                                        
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
            FIND FIRST DICTDB._File WHERE DICTDB._File._For-name = forname NO-ERROR.
            IF AVAILABLE verify-table OR AVAILABLE DICTDB._File THEN
                ASSIGN forname = SUBSTRING(forname, 1, LENGTH(forname) - 1).
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
            ASSIGN fldnum = fldnum + 1.             
            CREATE sql-info.
            ASSIGN line-num = -3
                   line = comment_chars + "DROP SEQUENCE " + forname + "_SEQ" + user_env[5]
                   tblname = ilin[3].
        
            CREATE sql-info.
            ASSIGN line-num = -2 
                   line = 'CREATE SEQUENCE ' + forname + 
                          '_SEQ START WITH 1 INCREMENT BY 1' + user_env[5]
                   tblname = ilin[3].       
            CREATE sql-info.
            ASSIGN line-num = 5000
                   line = "PROGRESS_RECID NUMBER NULL"  
                   tblname = ilin[3]
                   fldname = "PROGRESS_RECID".                  
          END.          
            
          CREATE sql-info.
          ASSIGN line-num = -1
                 line = 'DROP TABLE ' + forname + ' ' + user_env[5]
                 tblname = ilin[3].
          
          CREATE sql-info.
          ASSIGN lnum = 1 
                 line-num = lnum
                 line = 'CREATE TABLE ' + forname +  ' ('
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
                 df-line = '  FOREIGN-NAME "' + CAPS(forname) + '"'.

          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = tablename
                 df-line = '  FOREIGN-TYPE "TABLE" '.
          IF ora_owner <> "" THEN DO:
            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-info.df-tbl = tablename
                   df-line = '  FOREIGN-OWNER "' + CAPS(ora_owner) + '"'.
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
        
          IF tablename <> ilin[3] THEN
            ASSIGN tablename = ilin[3]
                   comment_chars = "".

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
       /* Drop field in schema holder only and create a view for Oracle if V7 else
          issue Alter Table Statement to drop Column
       */                   
      IF imod = "d" THEN DO:
        IF tablename <> ? AND tablename <> ilin[5] THEN 
          RUN write-tbl-sql.
                    
        
        IF idxline <> ? THEN 
          RUN write-idx-sql.
 
        IF tablename <> ilin[5] THEN
          ASSIGN tablename = ilin[5]
                 comment_chars = "".

        IF tablename <> ? THEN  
          DISPLAY tablename WITH FRAME working.
          
        CREATE df-info.
        ASSIGN df-info.df-seq = dfseq
               dfseq = dfseq + 1
               df-info.df-tbl = tablename
               df-line =  ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '" ' +
                          ilin[4] + ' "' + ilin[5] + '"'.
       
        IF ora_version > 7 THEN DO:
          FIND FIRST rename-obj WHERE rename-type = "T"
                                  AND new-name = ilin[5]
                                  NO-ERROR.
          IF NOT AVAILABLE rename-obj THEN
            FIND FIRST DICTDB._File WHERE DICTDB._File._File-name = ilin[5]
                                      AND DICTDB._File._Owner = "_FOREIGN" NO-ERROR.
          IF AVAILABLE DICTDB._File THEN DO:
            FIND FIRST rename-obj WHERE rename-type = "F"
                                  AND t-name = ilin[5]
                                  AND new-name = ilin[3]
                                  NO-ERROR.
            IF AVAILABLE rename-obj THEN
              FIND DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Field-name = old-name NO-ERROR.
            ELSE
              FIND DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Field-name = ilin[3] NO-ERROR.
      
            IF AVAILABLE DICTDB._Field THEN DO:
              IF DICTDB._Field._Extent = 0 THEN DO:
                PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " + DICTDB._File._For-name + 
                                 " DROP COLUMN " + DICTDB._Field._For-name + ";" SKIP.     
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
                PUT STREAM tosql UNFORMATTED comment_chars "ALTER TABLE " + DICTDB._File._For-name + 
                                 " DROP COLUMN " + DICTDB._Field._For-name + "##" + string(u) + ";" SKIP.  
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
        END.
        ELSE DO:
          CREATE drop-field.
          ASSIGN f-name = ilin[3]
                 of-table = ilin[5]
                 view-created = TRUE.
               
          FIND FIRST rename-obj WHERE rename-type = "F"
                                  AND t-name = ilin[5]
                                  AND new-name = ilin[3]
                                  NO-ERROR.
          IF AVAILABLE rename-obj THEN
            ASSIGN drop-f-name = old-name.
          ELSE                       
            ASSIGN drop-f-name = ilin[3].
                                         
          FIND FIRST DICTDB._File WHERE DICTDB._File._File-name = ilin[5]
                                    AND DICTDB._File._Owner = "_FOREIGN" NO-ERROR.
          IF AVAILABLE DICTDB._File THEN DO:
            FIND view-table WHERE v-table = ilin[5] 
                              AND v-order = 1 NO-ERROR.
            IF  AVAILABLE view-table THEN DO:
              FOR EACH view-table WHERE v-table = ilin[5]
                                    AND v-progn = drop-f-name /*ilin[3]*/:          
                DELETE view-table.
              END.
            END.                      
          END. /* End of IF AVAILABLE _File */
          ELSE DO:
            FIND FIRST rename-obj WHERE  rename-type = "T"
                                    AND new-name = ilin[5]
                                    NO-ERROR.
            IF AVAILABLE rename-obj THEN DO:
              FIND view-table WHERE v-table = old-name
                                AND v-order = 1 NO-ERROR.
              IF AVAILABLE view-table THEN DO:
                FOR EACH view-table WHERE v-table = ilin[5] 
                                      AND v-progn = ilin[3]:
                  DELETE view-table.
                END.
              END.
            END.
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
        
        IF tablename <> ilin[5] THEN
          ASSIGN tablename = ilin[5]
                 comment_chars = "".

        IF tablename <> ? THEN
          DISPLAY tablename WITH FRAME working.

        IF ilin[1] <> ? THEN do:
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-info.df-tbl = tablename
                 df-line = ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '" ' +
                           ilin[4] + ' "' + ilin[5] + '" ' + ilin[6] + ' "' + ilin[7] + '"'.
        END.  
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

          IF tablename <> ilin[5] THEN
            ASSIGN tablename = ilin[5]
                   comment_chars = "".

          IF tablename <> ? THEN       
            DISPLAY tablename WITH FRAME WORKING.                       
 
          FIND drop-field WHERE f-name = ilin[3]
                            AND of-table = ilin[5]
                            NO-ERROR.
          IF AVAILABLE drop-field THEN DO: /* adding field which we dropped from schema holder */
            FIND FIRST rename-obj WHERE rename-type = "F"
                                    AND t-name = ilin[5]
                                    AND new-name = ilin[3]
                                    NO-ERROR.
            IF NOT AVAILABLE rename-obj THEN                         
              ASSIGN fieldname = "a##" + SUBSTRING(ilin[3], 1, (INTEGER(user_env[29]) - 3)).   
            ELSE
              ASSIGN fieldname = ilin[3].
          END.           
          ELSE IF NOT AVAILABLE drop-field THEN DO:
            FIND rename-obj WHERE rename-type = "F"
                              AND new-name = ilin[3]
                              AND t-name = ilin[5]
                              NO-ERROR.
            IF AVAILABLE rename-obj THEN 
              ASSIGN fieldname = "a##" + SUBSTRING(ilin[3], 1, (INTEGER(user_env[29]) - 3)).             
            ELSE                  
              ASSIGN fieldname = ilin[3].
          END.
          
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
                                           
          ASSIGN fieldtype = ilin[7].
      
          IF NOT addtable THEN DO: 
            IF NOT alt-table THEN DO:                                                
              FIND DICTDB._File WHERE DICTDB._File._File-name = ilin[5]
                                  AND DICTDB._File._Owner = "_FOREIGN" NO-ERROR.
              IF AVAILABLE DICTDB._File THEN DO: 
              
                IF LENGTH(DICTDB._File._For-name) > 4 THEN DO:
                  IF SUBSTRING(DICTDB._File._For-name, (LENGTH(DICTDB._File._For-name) - 4)) <> "_V##" THEN
                    ASSIGN forname = DICTDB._File._For-name.                  
                  ELSE DO:
                    IF DICTDB._File._Fil-misc2[7] <> ? AND DICTDB._File._Fil-misc2[7] <> "" THEN
                      ASSIGN forname = DICTDB._File._Fil-misc2[7].
                    ELSE
                      ASSIGN forname = SUBSTRING(DICTDB._File._For-name, 1, (LENGTH(DICTDB._File._For-name) -  4)).                                                             
                    ASSIGN view-created = TRUE. 
                  END.
                END.
                ELSE
                  ASSIGN forname = DICTDB._File._For-name.

                CREATE alt-info.
                ASSIGN lnum = 1
                       a-line-num = lnum
                       a-line = "ALTER TABLE " + forname 
                       a-tblname = ilin[5]
                       a-fldname = fieldname.                       
              END.
          
              ELSE IF NOT AVAILABLE DICTDB._File THEN DO:
                FIND rename-obj WHERE rename-type = "T"
                                  AND new-name = ilin[5] NO-ERROR.
                IF AVAILABLE rename-obj THEN DO:
                  ASSIGN forname = dsv-name
                         fieldtype = ilin[7].
                  CREATE alt-info.
                  ASSIGN lnum = 1
                         a-line-num = lnum
                         a-line = "ALTER TABLE " + forname 
                         a-tblname = ilin[5]
                         a-fldname = fieldname.
                  FIND DICTDB._File WHERE DICTDB._File._File-name = old-name NO-ERROR.
                   
                  IF AVAILABLE DICTDB._File AND LENGTH(DICTDB._File._For-name) > 4 AND 
                    SUBSTRING(DICTDB._File._For-name, (LENGTH(DICTDB._File._For-name) - 4)) = "_V##" THEN
                      ASSIGN view-created = TRUE.
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
                 df-line = '  FOREIGN-NAME "' + CAPS(fieldname) + '"'. 

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

              IF sqlwidth AND new-obj.for-type = " VARCHAR2" THEN
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
                  IF j = 8 THEN j = minwidth.
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
                  IF j = 8 THEN j = minwidth.
                END.       
                IF ora_version > 7 THEN DO: 
                  IF j < 4001 THEN DO:              
                    IF AVAILABLE new-obj THEN
                      ASSIGN new-obj.for-type = " VARCHAR2 (" + STRING(j) + ")" 
                             dffortype = "VARCHAR2".
                  END.
                  ELSE  /* > 4000 */                     
                    IF AVAILABLE new-obj THEN
                      ASSIGN new-obj.for-type = " LONG"
                             dffortype = "LONG".                       
                END.
                ELSE DO: /* Not V8 */
                  IF j < 2001 THEN DO:
                    IF AVAILABLE new-obj THEN
                       ASSIGN new-obj.for-type = " VARCHAR2 (" + STRING(j) + ")" 
                              dffortype = "VARCHAR2".                                                                   
                  END.
                  ELSE 
                    IF AVAILABLE new-obj THEN
                      ASSIGN new-obj.for-type = " LONG"
                             dffortype = "LONG".
                END.
                ASSIGN lngth = j.   
              END. /* Character datatype */
              ELSE IF fieldtype = "integer" THEN DO: 
                IF AVAILABLE new-obj THEN
                  ASSIGN new-obj.for-type = " NUMBER"
                         dffortype = "NUMBER"
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
                    ASSIGN new-obj.for-type = " NUMBER (" + string(all_digits) + "," +
                                    string(all_digits - dec_point + 1) + ")".
                  ELSE
                    ASSIGN new-obj.for-type = " NUMBER (" + string(all_digits) + ",0)".

                  ASSIGN dffortype = "NUMBER"
                         lngth = 22
                         dec_point = (IF dec_point > 0 THEN all_digits - (dec_point - 1)
                                      ELSE 0) .
                END.
              END.
              ELSE if fieldtype = "date" AND AVAILABLE new-obj THEN
                ASSIGN new-obj.for-type = " DATE"
                       dffortype = "DATE"
                       lngth     = 7. 
              ELSE IF fieldtype = "logical" AND AVAILABLE new-obj THEN
                ASSIGN new-obj.for-type = " NUMBER"
                       dffortype = "NUMBER"
                       lngth = 22.
              ELSE IF fieldtype = "Recid" AND AVAILABLE new-obj THEN
                ASSIGN new-obj.for-type = " NUMBER"
                       dffortype = "NUMBER"
                       lngth = 22. 
                                             
              IF AVAILABLE sql-info THEN 
                ASSIGN line = fieldname + new-obj.for-type.                        
              ELSE IF AVAILABLE alt-info THEN DO:              
                ASSIGN a-line = "ADD " + fieldname + new-obj.for-type. 
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
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tablename
                     df-info.df-fld = fieldname
                     df-line = "  FIELD-MISC14 1".   
              CREATE df-info.
              ASSIGN df-info.df-seq = dfseq
                     dfseq = dfseq + 1
                     df-info.df-tbl = tablename
                     df-info.df-fld = fieldname
                     df-line = "  FOREIGN-MAXIMUM " + string(lngth).

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
              IF crtdefault THEN  DO:
                IF available new-obj AND ilin[2] <> "" AND ilin[2] <> ? AND ilin[2] <> "?" THEN DO:
                  IF alt-table THEN               
                    FIND alt-info WHERE a-tblname = tablename
                                    AND a-fldname = fieldname
                                    NO-ERROR.
                  ELSE          
                    FIND sql-info WHERE tblname = tablename
                                    AND fldname = fieldname
                                    NO-ERROR.
 
                  ASSIGN for-init = "".
                   /* Character */ 
                  IF new-obj.for-type BEGINS " VARCHAR2" THEN 
                    ASSIGN for-init = " DEFAULT '" + ilin[2] + "'".                                
                  ELSE IF new-obj.for-type BEGINS " NUMBER" THEN DO:  
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
                      ASSIGN for-init = " DEFAULT SYSDATE".                   
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
               
                      ASSIGN endline = SUBSTRING(a-line,(length(fieldname)+ 5))
                             a-line = SUBSTRING(a-line, 1, length(fieldname) + 4) +
                                       "##1" + endline.                 
                 
                      DO i = 2 TO INTEGER(ilin[2]):
                        CREATE alt-info.
                        ASSIGN lnum = lnum + 1
                               a-line-num = lnum
                               a-tblname = tablename
                               a-fldname = fieldname
                               a-line = "ADD " + fieldname + "##" + STRING(i) +  endline. 
                    
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
                               a-line = "ADD " + forname + STRING(i) + endline. 
                                            
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
              IF sqlwidth THEN DO:
                FIND FIRST new-obj WHERE new-obj.add-type = "F"
                               AND new-obj.tbl-name = tablename
                               AND new-obj.fld-name = fieldname
                               NO-LOCK NO-ERROR. 
               
                IF new-obj.for-type <> " NUMBER" AND
                   new-obj.for-type <> " DATE" AND
                   new-obj.for-type <> " LONG" THEN DO:
                  
                  FIND df-info WHERE df-info.df-tbl = tablename
                                 AND df-info.df-fld = fieldname
                                 AND df-info.df-line BEGINS "  FORMAT".
                 
                  IF alt-table THEN DO:               
                    FIND FIRST alt-info WHERE a-tblname = tablename
                                    AND a-fldname = fieldname 
                                    AND a-line BEGINS "ADD" NO-ERROR.
                    IF AVAILABLE alt-info THEN DO:
                      IF new-obj.for-type BEGINS " VARCHAR2" THEN DO:  
                        IF INDEX(a-line,"DEFAULT") <> 0 THEN
                          ASSIGN extlinenum = INDEX(a-line,"DEFAULT")
                                 extline = SUBSTRING(a-line, extlinenum).
                        ELSE
                          ASSIGN extline = "".

                        IF ora_version > 7 THEN DO: 
                          IF INTEGER(ilin[2]) < 4001 THEN
                            ASSIGN new-obj.for-type = " VARCHAR2(" + ilin[2] + ")"
                                   a-line = "ADD " + fieldname + " VARCHAR2(" + ilin[2] + ") " + extline
                                   df-info.df-line = "  FORMAT " + '"x(' + ilin[2] + ')"'
                                   extline = a-line
                                   extlinenum = alt-info.a-line-num.
                          ELSE DO: 
                            ASSIGN new-obj.for-type = " LONG"
                                   a-line = "ADD " + fieldname + " LONG"
                                   extline = a-line
                                   extlinenum = alt-info.a-line-num.
                            DELETE df-info.
                          END.
                        END.
                        ELSE DO:                          
                          IF INTEGER(ilin[2]) < 2001 THEN
                            ASSIGN new-obj.for-type = " VARCHAR2(" + ilin[2] + ") " 
                                   a-line = "ADD " + fieldname + " VARCHAR2(" + ilin[2] + ") " + extline
                                   df-info.df-line = "  FORMAT " + '"x(' + ilin[2] + ')"'
                                   extline = a-line
                                   extlinenum = alt-info.a-line-num.
                          ELSE DO:
                            ASSIGN new-obj.for-type = " LONG"
                                   a-line = "ADD " + fieldname + " LONG"
                                   extline = a-line
                                   extlinenum = alt-info.a-line-num.
                            DELETE df-info.
                          END.
                        END.
                      END.
                      ELSE DO:
                        ASSIGN left_paren = INDEX(a-line, "(")
                               right_paren = INDEX(a-line, ")")
                               j = INDEX(a-line, ",").
                        ASSIGN new-obj.for-type = " NUMBER (" + ilin[2] + ","
                                                  + SUBSTRING(a-line, j + 1, right_paren - j)
                               a-line = "ADD " + fieldname + " NUMBER (" + ilin[2] + ","
                                        + SUBSTRING(a-line, j + 1, right_paren - j) + " " + extline
                               extline = a-line
                               extlinenum = alt-info.a-line-num.
                      END.                    
                    END.
                    FOR EACH alt-info WHERE a-tblname = tablename
                                        AND a-fldname = fieldname 
                                        AND a-line BEGINS "ADD"
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

                      IF new-obj.for-type BEGINS " VARCHAR2" THEN DO:    
                        IF ora_version > 7 THEN DO: 
                          IF INTEGER(ilin[2]) < 4001 THEN
                            ASSIGN new-obj.for-type = " VARCHAR2(" + ilin[2] + ")"
                                   line = fieldname + " VARCHAR2(" + ilin[2] + ") " + extline
                                   df-info.df-line = "  FORMAT " + '"x(' + ilin[2] + ')"'
                                   extline = sql-info.line
                                   extlinenum = sql-info.line-num.
                          ELSE DO:                      
                            ASSIGN new-obj.for-type = " LONG"
                                   line = fieldname + " LONG"
                                   extline = sql-info.line
                                   extlinenum = sql-info.line-num.
                            /* There is no format statement for a long */
                            DELETE df-info.
                          END.
                        END.
                        ELSE DO:
                          IF INTEGER(ilin[2]) < 2001 THEN
                            ASSIGN new-obj.for-type = " VARCHAR2(" + ilin[2] + ")"
                                   line = fieldname + " VARCHAR2(" + ilin[2] + ") " + extline
                                   df-info.df-line = "  FORMAT " + '"x(' + ilin[2] + ')"'
                                   extline = sql-info.line
                                   extlinenum = sql-info.line-num.
                          ELSE DO: 
                            ASSIGN new-obj.for-type = " LONG"
                                   line = fieldname + " LONG"
                                   extline = sql-info.line
                                   extlinenum = sql-info.line-num.
                            DELETE df-info.
                          END.
                        END.
                      END.                    
                      ELSE DO:
                        ASSIGN left_paren = INDEX(line, "(")
                               right_paren = INDEX(line, ")")
                               j = INDEX(line, ",").
                        ASSIGN new-obj.for-type = " NUMBER (" + ilin[2] + ","
                                                  + SUBSTRING(LINE, j + 1, right_paren - j)
                               line = fieldname + " NUMBER (" + ilin[2] + ","
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

          IF tablename <> ilin[5] THEN
            ASSIGN tablename = ilin[5]
                   comment_chars = "".

          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                  dfseq = dfseq + 1
                  df-info.df-tbl = tablename
                  df-info.df-fld = fieldname
                  df-line = ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '" ' +
                            ilin[4] + ' "' + ilin[5] + '"'.
        END.

        CASE ilin[1]:
          WHEN "FORMAT" THEN. /* skip changes in format because Oracle is already created */

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

        IF tablename <> ilin[5] THEN 
          ASSIGN tablename = ilin[5]
                comment_chars = "".
       
 
        FIND FIRST DICTDB._File WHERE DICTDB._File._File-name = ilin[5]
                                  AND DICTDB._File._Owner = "_FOREIGN" NO-ERROR.                                  
        IF AVAILABLE DICTDB._File THEN DO:
          FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-name = ilin[3] NO-ERROR.
          IF AVAILABLE DICTDB._Index THEN DO:
            PUT STREAM tosql UNFORMATTED comment_chars "DROP INDEX " DICTDB._Index._For-name user_env[5] SKIP.
            PUT STREAM tosql UNFORMATTED comment_chars " " SKIP.
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
              END.               
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
            IF AVAILABLE DICTDB._File THEN DO:
              FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-name = ilin[3] NO-ERROR.
              IF AVAILABLE DICTDB._Index THEN DO:
                PUT STREAM tosql UNFORMATTED comment_chars "DROP INDEX " DICTDB._Index._For-name user_env[5] SKIP.
                PUT STREAM tosql UNFORMATTED comment_chars " " SKIP.
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
          ELSE  
            ASSIGN wordidx = FALSE
                   wordfile = ?
                   is-unique = FALSE.
          
          IF tablename <> ilin[5] THEN
            ASSIGN tablename = ilin[5]
                   comment_chars = "".

          ASSIGN transname = ilin[3].
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
              ASSIGN idx-number = idx-number + 1.          
              IF DICTDB._File._Fil-misc2[7] <> ? AND DICTDB._File._Fil-misc2[7] <> "" THEN DO:   
                ASSIGN forname = DICTDB._File._Fil-misc2[7].
                IF LENGTH(forname) + LENGTH(transname) + 2 > INTEGER(user_env[28]) THEN DO:
                  IF LENGTH(transname) + 2 < INTEGER(user_env[28]) THEN
                    ASSIGN forname = SUBSTRING(forname,1,(INTEGER(user_env[28]) - length(transname) - 2)) + "##" + transname.
                  ELSE DO:
                    ASSIGN forname = transname.
                    _iname:
                    REPEAT:
                      forname = SUBSTRING(transname,1, (LENGTH(forname) - 1)).
                      IF LENGTH(forname) + 2 <= INTEGER(user_env[28]) THEN LEAVE _iname.
                    END.
                    ASSIGN forname =  forname + "##".
                  END.
                END.
                ELSE 
                    ASSIGN forname = DICTDB._File._Fil-misc2[7] + "##" + transname.
              END.
              ELSE DO:
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
              END.

               _verify-index:
              DO WHILE TRUE:
                FIND FIRST verify-index WHERE verify-index.inew-name = forname NO-ERROR.
                FIND FIRST DICTDB._Index WHERE DICTDB._Index._For-name = forname 
                                           AND DICTDB._Index._File-recid = RECID(DICTDB._File) NO-ERROR.
                IF AVAILABLE verify-Index OR AVAILABLE DICTDB._Index THEN
                  ASSIGN forname = SUBSTRING(forname, 1, LENGTH(forname) - 1).
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
                END.
              END.                                       
            END. 
          END.
          ELSE
            ASSIGN forname = transname.
        
          IF AVAILABLE DICTDB._File THEN DO:
            IF DICTDB._File._Fil-Misc2[7] <> "" AND DICTDB._File._Fil-Misc2[7] <> ? THEN
              ASSIGN idxline = "CREATE INDEX " + forname + " ON " + DICTDB._File._Fil-Misc2[7].
            ELSE
              ASSIGN idxline = "CREATE INDEX " + forname + " ON " + DICTDB._File._For-name.
          END.
          ELSE DO:
            FIND FIRST new-obj WHERE new-obj.add-type = "T"
                                 AND new-obj.tbl-name = ilin[5]
                                 NO-ERROR.
            IF AVAILABLE new-obj THEN
               ASSIGN idxline = "CREATE INDEX " + forname + " ON " +  new-obj.for-name. 
            ELSE DO:
              FIND FIRST rename-obj WHERE rename-type = "T"
                                      AND rename-obj.new-name = ilin[5]
                                      NO-ERROR.
              IF AVAILABLE rename-obj THEN 
                   ASSIGN idxline = "CREATE INDEX " + forname + " ON " + dsv-name.                           
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
              PUT STREAM tosql UNFORMATTED comment_chars "DROP INDEX " DICTDB._Index._For-name user_env[5] SKIP.           
          END.
          
          RUN create-new-obj (INPUT "I", INPUT ?). 
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
            WHEN "WORD" THEN  /* Skip, work indexes not supported */
              ASSIGN idxline = ?
                     wordidx = TRUE
                     wordfile = idxname
                     df-idx = ?.
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
                       df-line = "  FOREIGN-NAME " + '"' + CAPS(forname) + '"'.

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
        
        IF idxline <> ? AND idxname <> ilin[3] THEN 
          RUN write-idx-sql.
        
        ASSIGN tablename = ilin[7]
               comment_chars = "".

        IF ilin[1] <> ? THEN DO:
          FIND DICTDB._File WHERE DICTDB._File._File-name = ilin[7] NO-ERROR.  
              
          IF NOT AVAILABLE DICTDB._File THEN DO:
            FIND rename-obj WHERE rename-type = "T"
                              AND rename-obj.new-name = ilin[7]
                              NO-ERROR.
                             
            IF AVAILABLE rename-obj THEN
              FIND DICTDB._File WHERE DICTDB._File._File-name = old-name NO-ERROR. 
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
        END.                              
        ASSIGN ilin = ?.  
      END.
      /* Update Index */
      ELSE DO:
        IF idxline <> ?  THEN 
          RUN write-idx-sql.
        /* only update if primary is changing since word indexes can't be primary */
        IF ilin[2] = "PRIMARY" THEN DO:   
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
               comment_chars = "".
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
          ASSIGN seq-line = "DROP SEQUENCE " + forname
                 seq-type = "d"
                 seqname = ilin[3].
       
          CREATE df-info.
          ASSIGN df-info.df-seq = dfseq
                 dfseq = dfseq + 1
                 df-line = ilin[1] + " " + ilin[2] + ' "' + ilin[3] + '"'.
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
            
            ASSIGN seq-line = "CREATE SEQUENCE " + forname
                   seq-type = "a"
                   seqname = ilin[3].
            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-line = 'ADD SEQUENCE "' + ilin[3] + '"'.
            CREATE df-info.
            ASSIGN df-info.df-seq = dfseq
                   dfseq = dfseq + 1
                   df-line = '  FOREIGN-NAME "' + CAPS(forname) + '"'.

          END.
         
          WHEN "UPDATE" THEN DO:         
            IF seqname <> ? THEN 
              RUN write-seq-sql.
            DISPLAY ilin[3] @ tablename WITH FRAME WORKING.  
            FIND FIRST DICTDB._Sequence WHERE DICTDB._Sequence._Db-recid = dbrecid
                                          AND DICTDB._Sequence._Seq-name = ilin[3]
                                          NO-ERROR.
            IF AVAILABLE _Sequence THEN DO:            
              ASSIGN seq-line = "ALTER SEQUENCE " + _Sequence._Seq-misc[1]
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
              ASSIGN cyc = "NOCYCLE".
            ELSE
              ASSIGN cyc = "CYCLE".
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
IF view-created THEN DO:
  RUN create-view.
  RUN write-view.
END.
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
  IF comment-out THEN
    MESSAGE "The following files have been created:" SKIP(1)
           "ORACLE SQL Script:  " sqlout  SKIP
           "PROGRESS DF File:  " dfout SKIP(1)
          "If the delta.df contained any drop table statements," SKIP
          "data will be lost from the ORACLE Database." SKIP (1)
          "Table(s) have been found that contain too many long columns." SKIP
          "The sql has been commented out and no information was" SKIP
          "outputed to the Progress DF File." SKIP
    VIEW-AS ALERT-BOX INFORMATION. 
  ELSE
    MESSAGE "The following files have been created:" SKIP(1)
           "ORACLE SQL Script:  " sqlout  SKIP
           "PROGRESS DF File:  " dfout SKIP(1)
          "If the delta.df contained any drop statements," SKIP
          "data will be lost from the ORACLE Database." SKIP (1)          
    VIEW-AS ALERT-BOX INFORMATION. 
END.
ELSE do:
  OUTPUT STREAM todf CLOSE.
  OUTPUT STREAM tosql CLOSE.
  OS-DELETE VALUE(dfout).
  HIDE FRAME working NO-PAUSE.
  IF comment-out THEN
  MESSAGE "The following file has been created: " SKIP(1)
          "    ORACLE SQL Script: " sqlout SKIP(1)
          "If the delta.df contained any drop statements," SKIP
          "data will be lost from the ORACLE Database." SKIP(1)
          "Table(s) have been found that contain too many long columns." SKIP
          "The sql has been commented out and no information was" SKIP
          "outputed to the Progress DF File." SKIP          
  VIEW-AS ALERT-BOX INFORMATION.
  ELSE
     MESSAGE "The following file has been created: " SKIP(1)
          "    ORACLE SQL Script: " sqlout SKIP(1)
          "If the delta.df contained any drop statements," SKIP
          "data will be lost from the ORACLE Database." SKIP(1)                   
     VIEW-AS ALERT-BOX INFORMATION.
END.
RUN adecomm/_setcurs.p ("").
 
RETURN.





