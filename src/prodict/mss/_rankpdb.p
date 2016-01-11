/*********************************************************************
* Copyright (C) 2013 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/mss/_rankpdb.p

Description:
    creates PROGRESS DB index ranking for rowid selection
    
Text-Parameters:
    Table recid
    uniquifyAddon add on value to indicate enforced uniqueness
    
Output-Parameters:
    DICTDB._File._Fil-misc1[2] as ttb_tbl_rowid

Included in:            
    prodict/mss/protoms1.p
    
History:
    Anil Shukla  05/29/13   Created

--------------------------------------------------------------------*/
/*h-*/
&SCOPED-DEFINE NOTTCACHE 1
&SCOPED-DEFINE xxDS_DEBUG                 DEBUG 
&SCOPED-DEFINE DATASERVER                 YES 
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
 { prodict/dictvar.i NEW }
&UNDEFINE DATASERVER
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES
&UNDEFINE NOTTCACHE

{ prodict/user/uservar.i }

/*----------------------------  DEFINES  ---------------------------*/
define input parameter itbl_recid as RECID no-undo.
define input parameter ClustAsROWID as LOGICAL no-undo.
define input parameter RankDesc as CHARACTER no-undo.

DEFINE VARIABLE compatible          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE migConstraint       AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE msstryp             AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE mssrecidCompat      AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE mapmssdatetime      AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE callerid            AS INTEGER    NO-UNDO INITIAL 1.
DEFINE VARIABLE mssOptRowid         AS CHARACTER  NO-UNDO INITIAL "".
DEFINE VARIABLE mssselBestRowidIdx  AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE msschoiceSchema     AS INTEGER    NO-UNDO.
DEFINE VARIABLE mssclus_explct      AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE keyCreated          AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE parse2              AS LOGICAL    NO-UNDO INITIAL FALSE. 
DEFINE VARIABLE RecidAsRowid        AS LOGICAL    NO-UNDO INITIAL FALSE. 
DEFINE VARIABLE uniquifyAddon       as INTEGER    NO-UNDO INITIAL 0.
DEFINE VARIABLE keyExist            AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE NonUnikCC           AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE pk_unique           AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE restorReqd          AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE mdrec_db            AS RECID      NO-UNDO.

DEFINE VARIABLE s_tmp_best          AS INTEGER    NO-UNDO INITIAL 0. 

/* PROCEDURE: calc-fldsize
 */
PROCEDURE calc-fldsize:
DEFINE OUTPUT PARAMETER odatasize AS INTEGER NO-UNDO.
DEFINE VARIABLE left_paren          AS INTEGER    NO-UNDO.
DEFINE VARIABLE right_paren         AS INTEGER    NO-UNDO.
DEFINE VARIABLE lngth               AS INTEGER    NO-UNDO.
DEFINE VARIABLE j                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE z                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE chrlong             AS INTEGER    NO-UNDO INITIAL 240.
DEFINE VARIABLE nbrchar             AS INTEGER    NO-UNDO INITIAL 240.
DEFINE VARIABLE dummy         AS CHARACTER  NO-UNDO INITIAL "".
DEFINE VARIABLE dummyint         AS INTEGER  NO-UNDO.

CASE UPPER(s_ttb_fld.pro_type):
     WHEN "INTEGER" OR WHEN "RECID" THEN DO:
        odatasize = 4. 
     END.
     WHEN "INT64" THEN odatasize = 8. 
     WHEN "DATE" THEN DO:
       IF NUM-ENTRIES(user_env[25]) > 2 AND ENTRY(3,user_env[25]) BEGINS "N" THEN odatasize = 8. /* MSS - Datetime */
       ELSE odatasize = 3. /* MSS - DATE */
      END.
     WHEN "DATETIME" THEN odatasize = 7.  /* datetime2(3) */
     WHEN "DATETIME-TZ" THEN odatasize = 9. 
     WHEN "LOGICAL" THEN odatasize = 1.  /* it's tinyint of sql server */
     WHEN "DECIMAL" THEN DO:
      assign dummyint = DICTDB._Field._Width.
      IF user_env[33] = "y" THEN DO: /* sqlwidth = ON */
         IF DICTDB._Field._Width > 28 THEN ASSIGN j = 28.
         ELSE ASSIGN j = DICTDB._Field._Width.
         IF j < DICTDB._Field._Decimals THEN ASSIGN j = DICTDB._Field._Decimals.
      END.
      ELSE DO:
         ASSIGN z = 1
                j = 0.
       /* get count of significant digits stopping at ".".
        * only count elements that can be considered digits. */
       REPEAT:
        IF z > LENGTH(DICTDB._Field._Format) OR SUBSTR(DICTDB._Field._Format,z,1) = "." THEN
           LEAVE.
        IF SUBSTR(DICTDB._Field._Format,z,1) = ">" OR
           SUBSTR(DICTDB._Field._Format,z,1) = "<" OR
           SUBSTR(DICTDB._Field._Format,z,1) = "Z" OR
           SUBSTR(DICTDB._Field._Format,z,1) = "z" OR
           SUBSTR(DICTDB._Field._Format,z,1) = "9" OR
           SUBSTR(DICTDB._Field._Format,z,1) = "*" THEN
             j = j + 1.
        z = z + 1.
       END.
       /* Add the scale to the precision. */
      assign dummyint = DICTDB._Field._Decimals.
       j = j + DICTDB._Field._Decimals.
      END. /* end of ELSE DO: */

      IF j >= 1 AND j <= 9 then odatasize = 5.
      ELSE IF j >= 10 AND j <= 19 then odatasize = 9.
      ELSE IF j >= 20 AND j <= 28 then odatasize = 13.
      ELSE odatasize = 17.
     END.
     WHEN "CHARACTER" THEN DO:
          IF user_env[32] = "MS SQL Server" THEN ASSIGN chrlong = 255.
          ELSE ASSIGN chrlong = integer(user_env[10]).

          IF UPPER(user_env[33]) = "Y" THEN  /* sqlwidth = ON */
             ASSIGN j = DICTDB._Field._Width.
          ELSE DO:
             ASSIGN lngth = LENGTH(DICTDB._Field._format, "character")
                    nbrchar = 0.

             IF INDEX(DICTDB._Field._Format, "(") > 1 THEN DO:
                left_paren = INDEX(DICTDB._Field._Format, "(").
                right_paren = INDEX(DICTDB._Field._Format, ")").
                lngth = right_paren - (left_paren + 1).
                 assign j = INTEGER(SUBSTRING(DICTDB._Field._Format, left_paren + 1, lngth)).
             END.
             ELSE DO:
               DO z = 1 to lngth:
                  IF SUBSTRING(DICTDB._Field._Format,z,1) = "9" OR
                     SUBSTRING(DICTDB._Field._Format,z,1) = "N" OR
                     SUBSTRING(DICTDB._Field._Format,z,1) = "A" OR
                     SUBSTRING(DICTDB._Field._Format,z,1) = "x" OR
                     SUBSTRING(DICTDB._Field._Format,z,1) = "!"   THEN
                        ASSIGN odatasize = odatasize + 1.
               END.
               IF nbrchar > 0 THEN
                  ASSIGN j = nbrchar.
               ELSE
                  ASSIGN j = lngth.
          END.
          FIND FIRST DICTDB._Db WHERE _Db-local NO-LOCK NO-ERROR.
          ASSIGN mdrec_db = RECID(DICTDB._Db).
          IF DICTDB._Field._Decimals > 0
             AND can-find(first DICTDB._Db where RECID(DICTDB._Db) = mdrec_db
                          and DICTDB._Db._Db-type <> "PROGRESS" ) THEN
             ASSIGN j = DICTDB._Field._Decimals.

          IF j = 8 AND UPPER(user_env[33]) = "N" THEN j = INTEGER (user_env[23]).
        END.
        IF (user_env[35] = "y") THEN j = j * 2.
        IF j > chrlong THEN
           odatasize = chrlong. /* long char */
        ELSE
           odatasize = j.
     END.
     OTHERWISE odatasize = 0.
END CASE.
RETURN.
END PROCEDURE.


/* PROCEDURE: Uniquify-Non-UniqIdx-and-retry
 */
PROCEDURE Uniquify-Non-UniqIdx-and-retry.
  def buffer s_buffer_tmp_idx for s_ttb_idx.
  
  ASSIGN parse2 = TRUE.
  for each s_buffer_tmp_idx where s_buffer_tmp_idx.ttb_tbl = s_ttb_tbl.tmp_recid:
                               /*   AND s_buffer_tmp_idx.hlp_mand = TRUE: */
       ASSIGN s_buffer_tmp_idx.hlp_fld#   = 0
              s_buffer_tmp_idx.hlp_dtype# = 0
              s_buffer_tmp_idx.hlp_fstoff = ?
              s_buffer_tmp_idx.hlp_level  = 0
              s_buffer_tmp_idx.pro_uniq_bkp = s_buffer_tmp_idx.pro_uniq.
       ASSIGN s_buffer_tmp_idx.pro_uniq = TRUE.  /* Assume it's uniq for ranking purposes */
      
  END.
  Assign uniquifyAddon  = 22.
  RUN prodict/mss/_cnrank.p (  INPUT s_tmp_best,
                               INPUT s_ttb_tbl.tmp_recid,
                               INPUT uniquifyAddon,
                               INPUT mssrecidCompat,
                               INPUT mapmssdatetime,
                               INPUT callerid).  /* 1-progress ranking , 2-pulled SH ranking */
/***********
  IF (s_ttb_tbl.ds_rowid GT 0 AND s_ttb_tbl.ds_rowid NE ? ) THEN
          ASSIGN s_ttb_tbl.rank_desc = s_ttb_tbl.rank_desc +
                                       "Attempted Second parse and successfully identified a ROWID candidate.". 
****************/
END.

/*======================== Mainline =================================== */   

/* FOR EACH s_ttb_tbl: DELETE s_ttb_tbl. END. */
FOR EACH s_ttb_idx: DELETE s_ttb_idx. END.

FOR EACH s_ttb_idf: DELETE s_ttb_idf. END.
FOR EACH s_ttb_fld: DELETE s_ttb_fld. END.

 if  user_env[27] = ?  OR user_env[27] = ""
  THEN ASSIGN compatible = true.
 else if num-entries(user_env[27]) > 1
  then assign  /* more than one value in user_env[27] */
   compatible = ( entry(1,user_env[27]) BEGINS "y"
              or entry(1,user_env[27]) = ""
               ).
 else assign
  compatible = (user_env[27] BEGINS "y"). /* create recid fields/indexes */

ASSIGN migConstraint = (ENTRY(1,user_env[36]) = "y").
ASSIGN msstryp = (ENTRY(2,user_env[36]) = "y").
ASSIGN mssrecidCompat = (ENTRY(3,user_env[36]) = "y").
ASSIGN mapmssdatetime = (ENTRY(3,user_env[25]) = "y").
IF compatible THEN ASSIGN mssOptRowid = ENTRY(3,user_env[27]).
ASSIGN mssselBestRowidIdx = (ENTRY(4,user_env[36]) = "y").
IF mssselBestRowidIdx THEN  ASSIGN msschoiceSchema = INTEGER(ENTRY(5,user_env[36])).

FIND FIRST DICTDB._File WHERE RECID(DICTDB._File) = itbl_recid. 
IF NOT CAN-FIND(FIRST s_ttb_tbl WHERE s_ttb_tbl.tmp_recid = itbl_recid)
THEN DO:
   CREATE s_ttb_tbl.
       assign s_ttb_tbl.tmp_recid = itbl_recid
              s_ttb_tbl.pro_name =  DICTDB._File._File-Name
              s_ttb_tbl.pk_idx_recid = DICTDB._File._Prime-index.    
END. 
ELSE FIND FIRST s_ttb_tbl WHERE s_ttb_tbl.tmp_recid = itbl_recid.

  /* Check if User will have PROGRESS_RECID as ROWID, if no indexes */  
  IF compatible AND (mssOptRowid NE "U") AND 
     NOT CAN-FIND(FIRST DICTDB._index WHERE DICTDB._index._file-recid = s_ttb_tbl.tmp_recid AND
                        DICTDB._Index._Index-name <> "default" AND
                        DICTDB._Index._Wordidx <> 1 ) THEN
     ASSIGN RecidAsRowid = TRUE.
  /* Add index/field details to temp tables relevant for ranking purposes */
_idxloop:
  FOR EACH DICTDB._index WHERE DICTDB._index._file-recid = s_ttb_tbl.tmp_recid AND
                                    DICTDB._Index._Index-name <> "default" AND
                                    DICTDB._Index._Wordidx <> 1 :

      UPDATE DICTDB._INDEX._I-misc2[1] = ?. /* Clean-up previous existing data */

      IF NOT CAN-FIND(FIRST s_ttb_idx WHERE s_ttb_idx.idx_recid = RECID(DICTDB._INDEX) AND
                                      s_ttb_idx.ttb_tbl = DICTDB._index._file-recid )
      THEN DO:
         CREATE s_ttb_idx.
                assign s_ttb_idx.idx_recid = RECID(DICTDB._INDEX)
                       s_ttb_idx.pro_idx#  = DICTDB._index._Idx-num
                       s_ttb_idx.pro_uniq = DICTDB._index._Unique
                       s_ttb_idx.pro_uniq_bkp = DICTDB._index._Unique
                       s_ttb_idx.ds_uniq  = DICTDB._index._Unique
                       s_ttb_idx.ttb_tbl  = DICTDB._index._file-recid
                       s_ttb_idx.pro_name = DICTDB._index._Index-name
                       s_ttb_idx.ds_idx_typ = 2.
         IF (RECID (DICTDB._Index) = s_ttb_tbl.pk_idx_recid ) THEN 
                assign s_ttb_idx.pro_prim = TRUE.  
      END.
      ELSE FIND FIRST s_ttb_idx WHERE s_ttb_idx.idx_recid = RECID(DICTDB._INDEX) AND
                                      s_ttb_idx.ttb_tbl = DICTDB._index._file-recid. 
      IF migConstraint AND CAN-FIND(FIRST DICTDB._Constraint 
              WHERE DICTDB._Constraint._Index-Recid = s_ttb_idx.idx_recid  AND
                    DICTDB._Constraint._Con-Active = TRUE AND 
                   (DICTDB._Constraint._Con-Type = "P" OR DICTDB._Constraint._Con-Type = "PC" OR
                    DICTDB._Constraint._Con-Type = "MP" OR DICTDB._Constraint._Con-Type = "M" )
         ) THEN ASSIGN s_ttb_idx.ds_idx_typ = 1.
      ELSE ASSIGN s_ttb_idx.ds_idx_typ = 2.
      for each DICTDB._Index-field 
          where DICTDB._Index-field._index-recid = s_ttb_idx.idx_recid:

            IF NOT CAN-FIND(FIRST s_ttb_idf WHERE s_ttb_idf.ttb_idx = s_ttb_idx.idx_recid 
                                              AND s_ttb_idf.ttb_fld = DICTDB._Index-field._Field-recid) 
            THEN DO:
              CREATE s_ttb_idf.
                   assign s_ttb_idf.ttb_idx = s_ttb_idx.idx_recid
                           s_ttb_idf.ttb_fld = DICTDB._Index-field._Field-recid
                           s_ttb_idf.pro_order = DICTDB._Index-field._Index-Seq.
            END.
            IF NOT CAN-FIND(FIRST s_ttb_fld WHERE s_ttb_fld.tmpfld_recid = s_ttb_idf.ttb_fld)
            THEN DO:
              find first DICTDB._Field 
                   where RECID(DICTDB._Field) = s_ttb_idf.ttb_fld.
                 CREATE s_ttb_fld.
                        assign s_ttb_fld.tmpfld_recid = RECID(DICTDB._Field)
                               s_ttb_fld.ds_type  = DICTDB._Field._Data-type
                               s_ttb_fld.pro_type = DICTDB._Field._Data-type
                               s_ttb_fld.pro_mand = DICTDB._Field._Mandatory
                               s_ttb_fld.ds_stoff = DICTDB._Field._Fld-stoff
                               s_ttb_fld.ds_msc23 = DICTDB._Field._Fld-misc2[3]
                               s_ttb_fld.ds_name  = DICTDB._Field._Field-Name.
                 IF UPPER(s_ttb_fld.pro_type) = "INT64" THEN assign s_ttb_fld.ds_type = "BIGINT".
                 RUN calc-fldsize ( OUTPUT s_ttb_fld.fld_size ). 
            END.
         end. /* for each DICTDB._Index-field  */
  end.  /* for each _INDEX */

  keyExist = CAN-FIND(FIRST DICTDB._CONSTRAINT WHERE DICTDB._CONSTRAINT._File-Recid = itbl_recid AND
                            DICTDB._Constraint._Con-Active = TRUE AND
                           (DICTDB._Constraint._Con-Type = "P" OR DICTDB._Constraint._Con-Type = "PC" OR
                            DICTDB._Constraint._Con-Type = "MP" )).

  FIND FIRST DICTDB._CONSTRAINT WHERE DICTDB._CONSTRAINT._File-Recid = itbl_recid AND
       DICTDB._Constraint._Con-Active = TRUE AND
       DICTDB._Constraint._Con-Type = "M" NO-ERROR.
  IF AVAILABLE DICTDB._CONSTRAINT THEN DO:
       FIND FIRST s_ttb_idx 
                  WHERE s_ttb_idx.idx_recid = DICTDB._CONSTRAINT._Index-recid AND
                        s_ttb_idx.pro_uniq <> TRUE NO-ERROR.
       IF AVAILABLE s_ttb_idx THEN ASSIGN NonUnikCC = TRUE.
       ELSE ASSIGN keyExist = TRUE.
  END.
  FIND FIRST s_ttb_idx WHERE s_ttb_idx.ttb_tbl = itbl_recid AND 
             s_ttb_idx.pro_prim = TRUE NO-ERROR.
  IF AVAILABLE s_ttb_idx THEN DO:
     IF s_ttb_idx.pro_uniq = TRUE THEN ASSIGN pk_unique = TRUE.
     ELSE ASSIGN pk_unique = FALSE.
  END.

  IF ( migConstraint AND keyExist) THEN 
     ASSIGN keyCreated   = TRUE.
  ELSE IF msstryp AND ( pk_unique OR ( NOT pk_unique AND (compatible AND (mssOptRowid EQ "U")))) THEN DO:
     FIND FIRST s_ttb_idx WHERE s_ttb_idx.ttb_tbl = itbl_recid AND 
                                s_ttb_idx.pro_prim = TRUE NO-ERROR.
     IF AVAILABLE s_ttb_idx AND NOT pk_unique THEN DO:
        ASSIGN s_ttb_idx.pro_uniq_bkp = s_ttb_idx.pro_uniq /* save original */
               s_ttb_idx.pro_uniq = TRUE /* Fake it as Unique */
               s_ttb_idx.ds_idx_typ = 1
               restorReqd = TRUE.
     END.
     ASSIGN keyCreated   = TRUE
            s_ttb_idx.ds_idx_typ = 1.
  END.
  ELSE IF (compatible AND (mssOptRowid NE "U")) THEN 
     ASSIGN RecidAsRowid = TRUE
            keyCreated   = TRUE.

IF RecidAsRowid THEN DO:
   ASSIGN DICTDB._FILE._Fil-misc1[1] = 1  /* assign positive to indicate PROGRESS_RECID as ROWID */
          DICTDB._file._Fil-misc1[2] = ?.
   /* Need for cleanup if PROGRESS_RECID is going to be ROWID selection */
   FOR EACH DICTDB._index WHERE DICTDB._index._file-recid = s_ttb_tbl.tmp_recid AND
                                    DICTDB._Index._Index-name <> "default" AND
                                    DICTDB._Index._Wordidx <> 1 :
      UPDATE DICTDB._INDEX._I-misc2[1] = ?. /* Clean-up previous existing data */
   END.
END.
ELSE DO: 
  ASSIGN DICTDB._FILE._Fil-misc1[1] = -1 /* assign negative to indicate no PROGRESS_RECID ROWID */
         s_tmp_best = 2.
  IF ((NUM-ENTRIES(user_env[42]) >= 2) AND
    UPPER(ENTRY(2,user_env[42])) = "L" ) THEN DO:
      RUN prodict/mss/_clrank.p ( INPUT s_tmp_best,
                                    INPUT s_ttb_tbl.tmp_recid,
                                    INPUT ClustAsROWID).
      FOR EACH s_ttb_idx  where s_ttb_idx.ttb_tbl = s_ttb_tbl.tmp_recid:
          FIND FIRST DICTDB._INDEX  where RECID(DICTDB._INDEX) = s_ttb_idx.Idx_recid. 
          UPDATE DICTDB._INDEX._I-misc2[1] = s_ttb_idx.ds_msc21.
      END.
  END.
  ELSE DO:
      ASSIGN parse2 = FALSE. 
      RUN prodict/mss/_cnrank.p (  INPUT s_tmp_best,
                                   INPUT s_ttb_tbl.tmp_recid,
                                   INPUT uniquifyAddon,
                                   INPUT mssrecidCompat,
                                   INPUT mapmssdatetime,
                                   INPUT callerid ). /* 1-progress ranking , 2-pulled SH ranking */


       /* Ranking done BUT Did not get RECID after first pass,
          retry ranking and designation with mandatory indexes by
          uniqifying those mandatory indexes.
        */
          IF mssOptRowid EQ "U" AND NOT mssrecidCompat AND 
             NOT keyCreated AND
             NOT CAN-FIND(FIRST s_ttb_idx where s_ttb_idx.ttb_tbl = s_ttb_tbl.tmp_recid
                                   AND s_ttb_idx.hlp_level <= 22)
          THEN RUN Uniquify-Non-UniqIdx-and-retry. 


       FOR EACH s_ttb_idx  where s_ttb_idx.ttb_tbl = s_ttb_tbl.tmp_recid:
          IF parse2 THEN ASSIGN s_ttb_idx.pro_uniq = s_ttb_idx.pro_uniq_bkp. /* restore original */
 
          IF s_ttb_idx.pro_prim AND restorReqd THEN ASSIGN s_ttb_idx.pro_uniq = TRUE.

         /* Update ranking info irrespective of rowid designation */
	  FIND FIRST DICTDB._INDEX  where RECID(DICTDB._INDEX) = s_ttb_idx.Idx_recid. 
	  UPDATE DICTDB._INDEX._I-misc2[1] = s_ttb_idx.ds_msc21.
       END.

       IF (s_ttb_tbl.ds_rowid GT 0 AND                  /* ROWID designated successfully */
              s_ttb_tbl.ds_rowid NE ? ) THEN DO:  
          IF NOT parse2 THEN  /* Check if it was done successfully in 1st attempt(parse) */ 
             ASSIGN s_ttb_tbl.rank_desc = s_ttb_tbl.rank_desc +
                                       "First parse successfully identified a ROWID candidate.". 
          ELSE ASSIGN s_ttb_tbl.rank_desc = s_ttb_tbl.rank_desc +
                                       "SECOND parse successfully identified a ROWID candidate.". 
       END.
       ELSE DO:            /* Even with 2nd parse could not manage to designate a rowid */
          ASSIGN s_ttb_tbl.rank_desc = s_ttb_tbl.rank_desc +
                                       "No eligible ROWID candidate identified.". 
          IF parse2 THEN 
             ASSIGN s_ttb_tbl.rank_desc = s_ttb_tbl.rank_desc +
                         "Parse-2 attempted and failed. Possibly table has no indexes " + 
                         "OR table has only non-mandatory indexes.". 
          ELSE DO:
             ASSIGN s_ttb_tbl.rank_desc = s_ttb_tbl.rank_desc + "Parse2 not attempted.". 
             IF(mssOptRowid NE "U") THEN
                ASSIGN s_ttb_tbl.rank_desc = s_ttb_tbl.rank_desc + 
                              "Try turning ON 'For ROWID Uniqueness' migration option.".
             ASSIGN s_ttb_tbl.rank_desc = s_ttb_tbl.rank_desc + 
                              "Ensure there are MANDATORY field Indexes.". 
          END.
       END.

  END. /* End of ELSE-DO for NEW algo call */

 IF (s_ttb_tbl.ds_rowid > 0 AND s_ttb_tbl.ds_rowid NE ? ) THEN DO: 
   UPDATE DICTDB._file._Fil-misc1[2] = s_ttb_tbl.ds_rowid.
 END. 
 ELSE UPDATE DICTDB._file._Fil-misc1[2] = ?. 

END. /* end of else part of - IF RecidAsRowid */

Assign RankDesc = s_ttb_tbl.rank_desc.
DELETE s_ttb_tbl. 
/*------------------------------------------------------------------*/
