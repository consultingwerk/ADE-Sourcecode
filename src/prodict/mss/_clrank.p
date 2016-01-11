/*********************************************************************
* Copyright (C) 2013 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/mss/_clrank.p

Description:
    Legacy Index ranking for rowid selection
    
Text-Parameters:
    tmp_best      Migration option "select best rowid" 
    tbl_recid     Target Table's recid
    ClustAsROWID  Clustered Index available for selection as ROWID ?
    
Output-Parameters:
  _File fields:
        s_ttb_tbl.ds_recid INTEGER -> Updated with PROGRESS_RECID position, if it exist's in table.
        s_ttb_tbl.ds_msc23 CHAR    -> "PROGRESS_RECID" field name is stored here.
        s_ttb_tbl.ds_rowid INTEGER -> Updated with ROWID designated progress index serial number.
        s_ttb_idx.ds_msc21 CHAR    -> ROWID qualifications i.e "rux"

Included in:            
    prodict/mss/_mss_pul.p
    prodict/mss/_rankpdb.p
    
History:
    Anil Shukla  05/29/13   Created

--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/
&SCOPED-DEFINE xxDS_DEBUG                   DEBUG /**/
&SCOPED-DEFINE DATASERVER                 YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i }
&UNDEFINE DATASERVER
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES


define input parameter tmp_best as INTEGER no-undo.
define input parameter tbl_recid as RECID no-undo.
define input parameter ClustAsROWID as LOGICAL no-undo.

define variable l_matrix  as character no-undo initial
                      "a,ax,ax,ax,u,ux,ux,ux".


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
     * x   := NON V7.3-compatible
     * ( float can't be used for "="; date has some restrictions too )
    */
 
       /* check all indexes and calculate their usability-level */
    find first s_ttb_tbl where  s_ttb_tbl.tmp_recid = tbl_recid.
       for each s_ttb_idx
          where s_ttb_idx.ttb_tbl = s_ttb_tbl.tmp_recid:

         for each s_ttb_idf 
            where s_ttb_idf.ttb_idx = s_ttb_idx.idx_recid:

           find first s_ttb_fld 
              where s_ttb_fld.tmpfld_recid = s_ttb_idf.ttb_fld.
           assign
              s_ttb_idx.hlp_fld#   = s_ttb_idx.hlp_fld# + 1
              s_ttb_idx.hlp_dtype# = maximum(s_ttb_idx.hlp_dtype#,
                          integer(string((s_ttb_fld.ds_type <> "integer"),"1/0")),
                          integer(string((s_ttb_fld.pro_type = "date"   ),"2/0")),
                          integer(string((s_ttb_fld.ds_type  = "float"  ),"3/0")) 
                                     )
              s_ttb_idx.hlp_mand   = s_ttb_idx.hlp_mand and s_ttb_fld.pro_mand.
              s_ttb_idx.hlp_fstoff = s_ttb_fld.ds_stoff * -1.
              s_ttb_idx.hlp_msc23  = ( if s_ttb_fld.ds_msc23 <> ?
                                      then s_ttb_fld.ds_msc23 
                                      else s_ttb_fld.ds_name
                                      ).
                                 
         end.  /* for each s_ttb_idfs of s_ttb_idx */
         
         if s_ttb_idx.ds_idx_typ = 1 AND
            ClustAsROWID THEN  /* This is a clustered index */
              assign s_ttb_idx.hlp_dtype# = 1
                     s_ttb_idx.hlp_level  = 1.
         ELSE DO:
         IF tmp_best <> 2 THEN assign s_ttb_idx.ds_idx_typ = 3.  /* DANGER:manupulated statement  */
         assign
            s_ttb_idx.hlp_dtype# = ( if ( s_ttb_idx.hlp_dtype# = 0
                                    and s_ttb_idx.hlp_fld#   > 1 )
                                    then 1
                                    else s_ttb_idx.hlp_dtype#
                                    )
            s_ttb_idx.hlp_level  = ( if ( s_ttb_idx.hlp_mand = TRUE 
                                    and s_ttb_idx.pro_uniq = TRUE )
                                    then 1
                                    else 5
                                    ) 
                                    + s_ttb_idx.hlp_dtype#.
          END.
       end. /* for each s_ttb_idx */

       /* assign correct i-misc2[1]-values and select index */
       for each s_ttb_idx where s_ttb_idx.ttb_tbl = s_ttb_tbl.tmp_recid
             break by s_ttb_idx.ds_idx_typ
                   by s_ttb_idx.hlp_slctd descending
                   by s_ttb_idx.hlp_level:

          if s_ttb_idx.hlp_slctd   /* previousely selected RowID index */
               and s_ttb_idx.hlp_level <> 0
               and s_ttb_idx.hlp_level <> 4
               then do: /* select it but schema NOT compatible with V7.3 anymore*/
             assign
                s_ttb_idx.ds_msc21 = "r" 
                                     + entry(s_ttb_idx.hlp_level,l_matrix)
               s_ttb_tbl.ds_recid = ?
               s_ttb_tbl.ds_msc23 = ?
               s_ttb_tbl.ds_rowid = s_ttb_idx.pro_idx#.
          end.    /* select it but schema NOT compatible with V7.3 anymore*/
          else if first(s_ttb_idx.hlp_slctd)
                 and s_ttb_idx.hlp_level <= 4
                 then assign /* select this index */
                    s_ttb_idx.ds_msc21 = "ra"
                    s_ttb_tbl.ds_recid = s_ttb_idx.hlp_fstoff
                    s_ttb_tbl.ds_msc23 = s_ttb_idx.hlp_msc23
                    s_ttb_tbl.ds_rowid = s_ttb_idx.pro_idx#.
          else assign
              s_ttb_idx.ds_msc21 = entry(s_ttb_idx.hlp_level,l_matrix).
       end.     /* for each s_ttb_idx */

/*------------------------------------------------------------------*/
