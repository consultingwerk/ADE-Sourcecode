/*********************************************************************
* Copyright (C) 2013 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/mss/_cnrank.p

Description:
    New Index ranking for rowid selection
    
Text-Parameters:
    tmp_best      Migration option "select best rowid" 
    tbl_recid     Target Table's recid
    uniquifyAddon Add on to indicate foced uniqification 
    mssrecidCompat Migration option - whether index should be recid compatible.
    mapmssdatetime Migration selection to calculate field size.
    callerid       1-progress ranking , 2-pulled SH ranking
    
Output-Parameters:
        s_ttb_tbl.ds_recid   
        s_ttb_tbl.ds_msc23 
        s_ttb_tbl.ds_rowid 
        s_ttb_idx.ds_msc21

Included in:            
    prodict/mss/_mss_pul.p
    prodict/mss/_rankpdb.p

    
History:
    Anil Shukla  05/29/13   Created
    Sachin Garg  06/09/13   OE00225738: Exclusions for RECID function support

--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/
{ prodict/user/uservar.i }

&SCOPED-DEFINE NOTTCACHE 1
&SCOPED-DEFINE xxDS_DEBUG                   DEBUG /**/
&SCOPED-DEFINE DATASERVER                 YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i }
&UNDEFINE DATASERVER
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES
&UNDEFINE NOTTCACHE

define input parameter tmp_best as INTEGER no-undo.
define input parameter tbl_recid as RECID no-undo.
define input parameter uniquifyAddon as INTEGER no-undo.
define input parameter mssrecidCompat as LOGICAL no-undo.
define input parameter mapmssdatetime as LOGICAL no-undo.
define input parameter callerid as INTEGER no-undo. /* 1-progress ranking , 2-pulled SH ranking */

define variable l_matrix  as character no-undo initial
                      "a,ax,ax,ax,ax,ax,u,ux,ux,ux".
define variable n_matrix  as character no-undo initial ?.
define variable Adjustlevel as INTEGER no-undo INITIAL 0.
define variable expday as INTEGER no-undo INITIAL 0.
define variable remainder as INTEGER no-undo INITIAL 0.
define variable multiplr as INTEGER no-undo INITIAL 0.
define variable pkfound  as LOGICAL no-undo INITIAL FALSE.
define variable V3compat as CHARACTER no-undo INITIAL 
       "1,2,3,7,8,12,13,14,18,19,23,24,25,29,30,34,35,36,40,41,45,46,47,51,52,56,57,58,62,63".

/* PROCEDURE: SH-calc-fldsize
 */
PROCEDURE SH-calc-fldsize:
DEFINE OUTPUT PARAMETER odatasize AS INTEGER NO-UNDO.
DEFINE VARIABLE j                   AS INTEGER    NO-UNDO.

CASE UPPER(s_ttb_fld.pro_type):
     WHEN "INTEGER" OR WHEN "RECID" THEN DO:
        odatasize = 4. 
     END.
     WHEN "INT64" THEN odatasize = 8. 
     WHEN "DATE" THEN DO:
       IF mapmssdatetime THEN odatasize = 8. /* MSS - Datetime */
       ELSE odatasize = 3. /* MSS - DATE */
      END.
     WHEN "DATETIME" THEN odatasize = 7.  /* datetime2(3) */
     WHEN "DATETIME-TZ" THEN odatasize = 9. 
     WHEN "LOGICAL" THEN odatasize = 1.  /* it's tinyint of sql server */
     WHEN "DECIMAL" THEN DO:
      assign j = s_ttb_fld.ds_lngth.
      IF j >= 1 AND j <= 9 then odatasize = 5.
      ELSE IF j >= 10 AND j <= 19 then odatasize = 9.
      ELSE IF j >= 20 AND j <= 28 then odatasize = 13.
      ELSE odatasize = 17.
     END.
     WHEN "CHARACTER" THEN DO:
       assign odatasize = s_ttb_fld.ds_lngth.
     END.
     OTHERWISE odatasize = 0.
END CASE.

RETURN.
END PROCEDURE.

/* this code accepts temp tables and does ranking for rowid selection   */
/*--------------------------- RECID-INDEX ----------------------------*/
    /* in Version 7.3 we needed a mandatory integer-field with a unique index
     * on it, to be used for RECID-functionality. Now we are able to use any
     * index, as long as it is unique.
     * In order to grant as much compatibility with previous versions as
     * possible, we now put both the old and the new version's info into
     * the required places. As long as there are indexes of "level" 0 or 4
     * selected, the schema can be used with a V7.3-client.
     * If another index gets selected, we put a message into the error-file
     * The new rules are:
     *    Level  Data-Types                andatory  unique   #(comp) misc2[1]
     *      1    integer only                 yes   &  yes  &   =1      a
     *      2    anything except date|float   yes   &  yes  &   =1      ax
     *      3    anything except float        yes   &  yes  &   =1      ax
     *      4    anything                     yes   &  yes  &   =1      ax
     *      5    integer only                 no    |  no   |   >1      u
     *      6    anything except date|float   no    |  no   |   >1      ux
     *      7    anything except float        no    |  no   |   >1      ux
     *      8    anything except date|float   no    |  no   |   >1      ux
     * a/u := automatically-selectable/user-definable
     * x   := NON V7.3-compatible v := Uniqueness Enforced  n := Uniqueness missing
     * m := mandatory missing   c:= RECID compatible index
     * ( float can't be used for "="; date has some restrictions too )
    */
 
    /* check all indexes and calculate their usability-level */
    find first s_ttb_tbl where  s_ttb_tbl.tmp_recid = tbl_recid.
       for each s_ttb_idx
          where s_ttb_idx.ttb_tbl = s_ttb_tbl.tmp_recid:
            assign 
		s_ttb_idx.hlp_fld# = 0
		s_ttb_idx.hlp_dtype# = 0
		s_ttb_idx.hlp_level = 0
		s_ttb_idx.hlp_idxsize = 0
		s_ttb_idx.ds_msc21 = ""
		s_ttb_idx.key_wt# = 0.
       end.


/* Calculate field sizes of the table fields */
     IF callerid = 2 THEN DO:
       FOR EACH s_ttb_fld WHERE s_ttb_fld.ttb_tbl = tbl_recid:
          RUN SH-calc-fldsize ( OUTPUT s_ttb_fld.fld_size ).
       end.
     END.

       for each s_ttb_idx
          where s_ttb_idx.ttb_tbl = s_ttb_tbl.tmp_recid:
        
         assign n_matrix = ?.
         for each s_ttb_idf 
            where s_ttb_idf.ttb_idx = s_ttb_idx.idx_recid:

           find first s_ttb_fld 
              where s_ttb_fld.tmpfld_recid = s_ttb_idf.ttb_fld.
                  
           assign
              s_ttb_idx.hlp_fld#   = s_ttb_idx.hlp_fld# + 1
              s_ttb_idx.hlp_dtype# = maximum(s_ttb_idx.hlp_dtype#,
                          integer(string((s_ttb_fld.ds_type <> "integer"),"3/0")),
                          integer(string((s_ttb_fld.pro_type = "date" ),"4/0")),
                          integer(string((s_ttb_fld.pro_type = "datetime" ),"4/0")),
                          integer(string((s_ttb_fld.pro_type = "datetime-tz" ),"4/0")),
                          integer(string((s_ttb_fld.ds_type  = "float"  ),"5/0")) 
                                     )
              s_ttb_idx.hlp_mand   = s_ttb_idx.hlp_mand and s_ttb_fld.pro_mand.
              s_ttb_idx.hlp_fstoff = s_ttb_fld.ds_stoff * -1.
              s_ttb_idx.hlp_msc23  = ( if s_ttb_fld.ds_msc23 <> ?
                                      then s_ttb_fld.ds_msc23 
                                      else s_ttb_fld.ds_name
                                      ).
              s_ttb_idx.hlp_idxsize# = s_ttb_idx.hlp_idxsize# + s_ttb_fld.fld_size.
              if s_ttb_fld.ds_type = "BIGINT" then
                 assign s_ttb_idx.hlp_dtype# = s_ttb_idx.hlp_dtype# - 2.
         end.  /* for each s_ttb_idfs of s_ttb_idx */
         
            if s_ttb_idx.hlp_fld#   > 1 then do:
	       IF s_ttb_idx.hlp_dtype# = 0 THEN  DO: 
                  IF s_ttb_idx.hlp_fld# = 2 THEN assign s_ttb_idx.hlp_dtype# = 2.  /* int,int */
                  ELSE assign s_ttb_idx.hlp_dtype# = 6.
	       END.
               ELSE IF s_ttb_idx.hlp_dtype# = 1 THEN assign s_ttb_idx.hlp_dtype# = s_ttb_idx.hlp_dtype# + 6.
               ELSE assign s_ttb_idx.hlp_dtype# = s_ttb_idx.hlp_dtype# + 5.
            end.
         IF s_ttb_idx.pro_uniq = TRUE THEN Adjustlevel = uniquifyAddon.
         ELSE Adjustlevel = 44.
         assign
           s_ttb_idx.hlp_level  = ( if ( s_ttb_idx.hlp_mand = TRUE )
                                    then 1
                                    else 12
                                    ) 
                                    + s_ttb_idx.hlp_dtype#
                                    + Adjustlevel.
         assign
           expday = TRUNCATE(s_ttb_idx.hlp_idxsize# / 8, 0)
           remainder = s_ttb_idx.hlp_idxsize# MOD 8.
         assign multiplr = expday + ( IF remainder > 0 then 1 else 0).  
         assign  
           s_ttb_idx.key_wt#  = ( s_ttb_idx.hlp_level + s_ttb_idx.hlp_fld# ) * multiplr.
      
         if s_ttb_idx.pro_uniq then do:
           if uniquifyAddon = 22 then s_ttb_idx.ds_msc21 = s_ttb_idx.ds_msc21 + "v". /*enforced uniqness */
         end.
         else s_ttb_idx.ds_msc21 = s_ttb_idx.ds_msc21 + "n". /* uniqueness missing */

         if not s_ttb_idx.hlp_mand then
           s_ttb_idx.ds_msc21 = s_ttb_idx.ds_msc21 + "m". /* mandatory missing */
       end. /* for each s_ttb_idx */

       /* assign correct i-misc2[1]-values and select index */
       for each s_ttb_idx where s_ttb_idx.ttb_tbl = s_ttb_tbl.tmp_recid
             break by s_ttb_idx.pro_uniq descending
                   by s_ttb_idx.ds_idx_typ
                   by s_ttb_idx.hlp_slctd descending
                   by s_ttb_idx.hlp_level
                   by s_ttb_idx.key_wt#
                   by s_ttb_idx.pro_prim descending:
          if s_ttb_idx.hlp_slctd   /* previousely selected RowID index */
               and s_ttb_idx.hlp_level <> 0
               and s_ttb_idx.hlp_level <> 4
               and s_ttb_idx.hlp_level <= 6
               then do: /* select it but schema NOT compatible with V7.3 anymore*/
             assign
                s_ttb_idx.ds_msc21 = "r" 
                                     + entry(s_ttb_idx.hlp_level,l_matrix)
               s_ttb_tbl.ds_recid = ?
               s_ttb_tbl.ds_msc23 = ?
               s_ttb_tbl.ds_rowid = s_ttb_idx.pro_idx#.
          end.    /* select it but schema NOT compatible with V7.3 anymore*/
          else if first(s_ttb_idx.hlp_slctd)
                 and s_ttb_idx.hlp_level <= 6
                 then assign /* select this index */
                    s_ttb_idx.ds_msc21 = "r"
                                        + entry(s_ttb_idx.hlp_level,l_matrix)
                    s_ttb_tbl.ds_recid = s_ttb_idx.hlp_fstoff
                    s_ttb_tbl.ds_msc23 = s_ttb_idx.hlp_msc23
                    s_ttb_tbl.ds_msc16 = ( if (s_ttb_idx.hlp_fld# > 1 or
                                               s_ttb_idx.hlp_dtype# > 1)
                                           then 1
                                           else ?
                                         )
/*
                    s_ttb_tbl.ds_recid = ( if (s_ttb_idx.hlp_fld# > 1 or
                                                s_ttb_idx.hlp_dtype# > 1)
                                           then 0
                                           else s_ttb_idx.hlp_fstoff
                                          )
                    s_ttb_tbl.ds_msc23 = ( if (s_ttb_idx.hlp_fld# > 1 or
                                                s_ttb_idx.hlp_dtype# > 1)
                                           then ?
                                           else s_ttb_idx.hlp_msc23
                                          )
*/
                    s_ttb_tbl.ds_rowid = s_ttb_idx.pro_idx#.
          else DO:
               assign n_matrix = ( if ( ( s_ttb_idx.hlp_level >= 12 and
                                          s_ttb_idx.hlp_level <= 17 ) OR
                                        s_ttb_idx.hlp_level <= 6 )
                                      
                                then "a"
                                else "u"
                              ).
               IF LOOKUP(STRING(s_ttb_idx.hlp_level),V3compat) = 0 THEN
                  assign n_matrix = n_matrix + "x".
             
               assign s_ttb_idx.ds_msc21 = n_matrix + s_ttb_idx.ds_msc21.
          end.

            /* OE00225738: multi component index or single componnet
             * index but non binary type are not eligible for RECID 
             * function support.
             */
          IF s_ttb_idx.hlp_fld# <= 2 and (s_ttb_idx.hlp_level <= 3 OR
             (s_ttb_idx.hlp_level >= 12 AND s_ttb_idx.hlp_level <= 14 )) THEN 
            assign s_ttb_idx.ds_msc21 = s_ttb_idx.ds_msc21 + "c".  /* RECID compatible index */
          IF s_ttb_idx.pro_uniq THEN DO:
             IF s_ttb_idx.hlp_mand AND NOT pkfound THEN
                assign pkfound = TRUE
                       s_ttb_idx.ds_msc21 = s_ttb_idx.ds_msc21 + "p". /* Primary key candidate */
             IF s_ttb_idx.pro_prim AND s_ttb_idx.pro_uniq_bkp <> s_ttb_idx.pro_uniq AND
                s_ttb_idx.ds_idx_typ = 1 AND index(s_ttb_idx.ds_msc21,"v") = 0 THEN 
                  s_ttb_idx.ds_msc21 = s_ttb_idx.ds_msc21 + "v". /*enforced uniqness on OE PK */
          END.
       end.     /* for each s_ttb_idx */

   FOR EACH s_ttb_idx where s_ttb_idx.ttb_tbl = s_ttb_tbl.tmp_recid
             break by s_ttb_idx.pro_uniq descending
                   by s_ttb_idx.ds_idx_typ
                   by s_ttb_idx.hlp_level
                   by s_ttb_idx.key_wt#
                   by s_ttb_idx.pro_prim descending:
       
       IF mssrecidCompat THEN DO:
          IF substring(s_ttb_idx.ds_msc21,1,1) = "r" THEN DO:
             IF INDEX(s_ttb_idx.ds_msc21,"c") <> 0 THEN  LEAVE. /* RECID comaptible */
             ELSE DO:
                 /* ---- Remove "r" and Replace 'a' with 'u'*/
                assign s_ttb_idx.ds_msc21 = substring(s_ttb_idx.ds_msc21,2,LENGTH(s_ttb_idx.ds_msc21)).
                assign s_ttb_tbl.ds_recid = ?
                       s_ttb_tbl.ds_msc23 = ?
                       s_ttb_tbl.ds_rowid = ?.
               /*
                IF INDEX(s_ttb_idx.ds_msc21,"a") <> 0 THEN 
                    assign s_ttb_idx.ds_msc21 = replace(s_ttb_idx.ds_msc21, "a","u").
               */
             END.
          END. 
          ELSE DO: 
             IF INDEX(s_ttb_idx.ds_msc21,"c") <> 0 THEN DO: /* RECID compatible but no "r" */
               /** --- Add "r" **/
                 assign s_ttb_idx.ds_msc21 = "r" + s_ttb_idx.ds_msc21
                        s_ttb_tbl.ds_recid = s_ttb_idx.hlp_fstoff
                        s_ttb_tbl.ds_msc23 = s_ttb_idx.hlp_msc23
                        s_ttb_tbl.ds_rowid = s_ttb_idx.pro_idx#.
               /*
                 IF INDEX(s_ttb_idx.ds_msc21,"u") <> 0 THEN 
                    assign s_ttb_idx.ds_msc21 = replace(s_ttb_idx.ds_msc21, "u","a").
               */
                 LEAVE.   
             END. 
          END.
       END.
       ELSE DO:
         IF substring(s_ttb_idx.ds_msc21,1,1) <> "r" THEN DO: 
           IF( ( s_ttb_idx.ds_idx_typ = 1 AND s_ttb_idx.pro_uniq ) OR 
               INDEX(s_ttb_idx.ds_msc21,"n") = 0 OR  /* is Unique already */
               INDEX(s_ttb_idx.ds_msc21,"v") <> 0 )  /* OR uniqueness enforced */
           THEN DO:
             assign s_ttb_idx.ds_msc21 = "r" + s_ttb_idx.ds_msc21
                    s_ttb_tbl.ds_recid = s_ttb_idx.hlp_fstoff
                    s_ttb_tbl.ds_msc23 = s_ttb_idx.hlp_msc23
                    s_ttb_tbl.ds_msc16 = ( if (s_ttb_idx.hlp_fld# > 1 or
                                               s_ttb_idx.hlp_dtype# > 1)
                                           then 1
                                           else ?
                                         )
/*
                    s_ttb_tbl.ds_recid = ( if (s_ttb_idx.hlp_fld# > 1 or
                                                s_ttb_idx.hlp_dtype# > 1)
                                           then 0
                                           else s_ttb_idx.hlp_fstoff
                                          )
                    s_ttb_tbl.ds_msc23 = ( if (s_ttb_idx.hlp_fld# > 1 or
                                                s_ttb_idx.hlp_dtype# > 1)
                                           then ?
                                           else s_ttb_idx.hlp_msc23
                                          )
*/
                    s_ttb_tbl.ds_rowid = s_ttb_idx.pro_idx#.
             IF INDEX(s_ttb_idx.ds_msc21,"u") <> 0 THEN
                assign s_ttb_idx.ds_msc21 = replace(s_ttb_idx.ds_msc21, "u","a").
           END.
         END.
         LEAVE.
       END.
   END.

/*------------------------------------------------------------------*/
