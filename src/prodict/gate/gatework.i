/****************************************************************************
* Copyright (C) 2006,2008-2011 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions               *
* contributed by participants of Possenet.                                  *
*****************************************************************************/
                                                                           /*
file:   gate/gatework.i

description:
    Define a shared workfile for use in prompting the user to
    pick the gateway objects to add, verify or modify

included in:
    prodict/dictvar.i
    prodict/gui/_guigget.p
    prodict/odb/_odb_get.p
    prodict/odb/_odb_mak.p
    prodict/odb/_odb_md3.p
    prodict/ora/_ora_get.p
    prodict/ora/_ora_lk0.p
    prodict/ora/_ora6md3.p
    prodict/ora/_ora7md3.p
    prodict/ora/ora67get.i
    prodict/rdb/_rdb_get.p
    prodict/syb/syb_getp.i
    prodict/user/_usr_gsl.p

Note: ORACLE: Synonyms: 
      gate-work.gate-edit contains <owner>.<name>,<type> of the 
      object the synonym is pointing to


History:
    hutegger    96/02   added gate-obj# for ora-synonym support
    hutegger    95/03   addoption for new verify-routines
    mcmann     03/20/01 Added defaultname for descending index support
    mcmann     05/21/02 Added new {&selVarType} variable.
    slutz      08/10/05 Added s_ttb_fld.ds_msc26 20050531-001
    fernando   06/26/06 Added support for large sequences
    fernando   02/25/08 Added parameter for datetime
    rohit      04/30/08 Added new field gate-seqpre to gate-work
    knavneet   04/28/09 BLOB support for MSS (OE00178319)
    sgarg      04/28/09 Added s_ttb_fld.ds_msc17. (OE00193877)
    kmayur     06/21/11 Added s_ttb_con for constraint pull OE00195067    
*/

DEFINE {&new} SHARED TEMP-TABLE gate-work NO-UNDO
  field gate-edit AS CHARACTER             /* report-editor */
  field gate-flag AS LOGICAL INITIAL FALSE /* do me? y/n */
  field gate-flg2 AS LOGICAL INITIAL FALSE /* do me the other thing? y/n */
  field gate-name AS CHARACTER case-sensitive /* foreign name */
  field gate-obj# AS INTEGER               /* oracle type-number */
  field gate-prog AS CHARACTER             /* progress name */
  field gate-qual AS CHARACTER		   /* db-qualifier */
  field gate-slct AS LOGICAL INITIAL FALSE /* user selected me? y/n */
  field gate-type AS CHARACTER             /* type (our name) */
  field gate-seqpre AS CHARACTER           /* sequence prefix- either _SEQT_ or _SEQT_REV_ */
  field gate-user AS CHARACTER             /* userid */
  field ttb-recid AS RECID                 /* RECID(s_ttb_{seq|tbl}) */
       /* don't use it for packages with 1 gate-work = n s_ttb_tbl!! */
  INDEX upi       IS PRIMARY UNIQUE 
            gate-slct DESCENDING gate-flg2 DESCENDING 
            gate-name ASCENDING  gate-type gate-user gate-qual
  INDEX istp    /*IS         UNIQUE*/ 
            gate-slct DESCENDING 
            gate-type ASCENDING  gate-prog
  INDEX gate_idx  IS         UNIQUE 
            gate-slct DESCENDING 
            gate-name ASCENDING  gate-type gate-user gate-qual
  INDEX uiflag    IS         UNIQUE
            gate-slct DESCENDING 
            gate-flag ASCENDING  gate-flg2 gate-name gate-type gate-user gate-qual.

DEFINE {&selVarType}_name       AS character no-undo {&options}.
DEFINE {&selVarType}_owner      AS character no-undo {&options}.
DEFINE {&selVarType}_qual       AS character no-undo {&options}.
DEFINE {&selVarType}_type       AS character no-undo {&options}.
DEFINE {&selVarType}_vrfy       AS logical   no-undo.
DEFINE {&selVarType}_outf       AS logical   no-undo.
DEFINE {&selVarType}_datetime   AS logical   no-undo.
DEFINE {&selVarType}_lob        AS logical   no-undo.
DEFINE {&selVarType}_clobtype   AS logical   no-undo initial TRUE.
DEFINE {&selVarType}_blobtype   AS logical   no-undo initial TRUE.
DEFINE {&selVarType}_primary    AS logical   no-undo.
DEFINE {&selVarType}_best       AS integer   no-undo initial 1.
DEFINE {&selVarType}_recidcompat AS logical  no-undo.
DEFINE {&selVarType}_wildcard   AS logical   no-undo initial TRUE.
DEFINE {&new} SHARED variable proc_obj	 as logical. /* OE00195067 */

/* NOTES:
 * + if an object exists on the PROGRESS-Side but doesn't exist on the
 *   foreign side, the fields gate-type, gate-user and gate-qual are ""
 * + when verifying an object, we use gate-flg2 to signal wether we found
 *   differences or not
 */

&IF "{&FOREIGN_SCHEMA_TEMP_TABLES}" = "INCLUDE"
 &THEN

  /* notes about the temp-tables and their connectability among themself
   * and to Schema-tables:
   *
   * s_ttb_tbl:     foreign Info for PROGRESS-Tables
   *    unique Indexes  : (pro-name)
   *                      (ds_type ds_name ds_user ds_spcl)
   *    <-> _File       : pro_recid
   *    <-> gate-work   : RECID(gate-work)  = s_ttb_tbl.gate-work
   *    <-> s_ttb_fld   : s_ttb_fld.ttb_tbl = RECID(s_ttb_tbl)
   *    <-> s_ttb_idx   : s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl)
   *
   * s_ttb_seq:     foreign Info for PROGRESS-Sequences
   *    unique Indexes  : (pro-name)
   *                      (ds_name ds_user ds_spcl)
   *    <-> gate-work   : RECID(gate-work)  = s_ttb_seq.gate-work
   *    <-> _Sequence   : pro_recid
   *
   * s_ttb_fld:     foreign Info for PROGRESS-Fields
   *    unique Indexes  : (ttb_tbl pro_name)
   *                      (ttb_tbl ds_name ds_type)
   *                      (ttb_tbl pro_order)
   *    ~unique Indexes : (ttb_tbl ds_stoff) /* arrays: n flds 1 stoff */
   *    <-> w_field     : pro_name
   *    <-> _Field      : ds_name [ ds_type ]
   *    <-> s_ttb_tbl   : RECID(s_ttb_tbl)  = s_ttb_fld.ttb_tbl
   *    <-> s_ttb_idf   : s_ttb_idf.ttb_fld = RECID(s_ttb_fld)
   *
   * s_ttb_idx:     foreign Info for PROGRESS-Indexes
   *    unique Indexes  : (ttb_tbl pro_name)
   *    <-> _Index      : ???
   *    <-> s_ttb_tbl   : RECID(s_ttb_tbl)  = s_ttb_idx.ttb_tbl
   *    <-> s_ttb_idf   : s_ttb_idf.ttb_idx = RECID(s_ttb_idx)
   *
   * s_ttb_idf:     foreign Info for PROGRESS-Index-Fields
   *    unique Indexes  : (ttb_idx pro_order)
   *                      (ttb_fld ttb_idx)
   *    <-> _Index-Field: ???
   *    <-> s_ttb_tbl   : RECID(s_ttb_tbl)  = s_ttb_fld.ttb_tbl
   *    <-> s_ttb_idf   : s_ttb_idf.ttb_fld = RECID(s_ttb_fld)
   *
   */
   
  define {&new} shared variable   s_1st-error as logical initial FALSE NO-UNDO.
  define {&new} shared stream     s_stm_errors.
  
  define {&new} shared TEMP-TABLE s_ttb_seq
          field ds_name          as character /* foreign name */
          field ds_spcl          as character initial ? 
                                              /* ODB: FullName [3] */
                                              /* ORA: LinkName [8]*/
          field ds_type          as character /* foreign type */
          field ds_user          as character /* foreing owner */
          field ds_incr          as INT64     /* FOREIGN increment */
          field ds_max           as INT64     /* FOREIGN max-value */
          field ds_min           as INT64     /* FOREIGN min-value */
          field ds_cycle         as logical   /* foreign cycle yes/no */
          field gate-work        as recid
          field pro_name         as character /* PROGRESS name */
          field pro_recid        as recid     initial ?
          index upi              is unique primary
                                     pro_name
          index uids             is unique
                                    ds_name ds_user ds_spcl.
                                    
  define {&new} shared TEMP-TABLE s_ttb_tbl
          field ds_msc13         as integer   initial ? 
                                              /*    misc1[3]           */
          field ds_msc21         as character initial ? 
                                              /*    misc2[1]           */
                                              /* ORA: Package-Name     */
          field ds_msc22         as character initial ? 
                                              /*    misc2[2]           */
                                              /* ODB: Hidden-fields    */
          field ds_msc23         as character initial ?
                                              /*    misc2[3]           */
                                              /* ODB: RECID-field-name */
          field ds_msc24         as character initial ?
                                              /*    misc2[4]           */
                                              /* ODB: proc-param-names */
                                              /* ORA: ?                */
                                              /* SYB: ?                */
          field ds_msc25         as character initial ?
                                              /*    misc2[5]           */
                                              /* ODB: ROWID index name */
                                              /* ORA: ?                */
                                              /* SYB: ?                */
          field ds_msc15         as integer   initial ?
                                              /*    misc1[5]    */
                                              /* ODB & MSS: RECID type */
                                              /* 1=32 bits & 2=64bits  */
          field ds_msc16         as integer   initial ?
                                              /*    misc1[6]           */
                                              /* MSS: RECID Fn Compat  */
                                              /* 1= exclusion criteria */
          field ds_name          as character case-sensitive
                                              /* foreign name          */
          field ds_recid         as integer   initial ?
                                              /*    misc1[1]           */
                                              /* recid-field-nr        */
          field ds_rowid         as integer   initial ? 
                                              /*    misc1[2]           */
                                              /* ODB: misc1[2]         */
          field ds_spcl          as character initial ? 
                                              /* ODB: Qualifier        */
                                              /* ORA: LinkName         */
          field ds_type          as character /* foreing type          */
          field ds_user          as character /* foreing owner         */
          field gate-work        as recid
          field pro_desc         as character 
     /*   field pro_dump-name    as character   */
          field pro_name         as character 
          field pro_prime-idx    as character
          field pro_recid        as recid     initial ?
          field tmp_recid        as recid     initial ?
          field pk_idx_recid     as recid     initial ?
          field rank_desc        as character initial ""
          index upi              as unique primary 
                                     pro_name
          index uids             is unique
                                    ds_type ds_name ds_user ds_spcl.

  define {&new} shared TEMP-TABLE s_ttb_fld
          field ds_prec          as integer   initial ?
                                              /*    misc1[1]    */
                                              /* ODB: precision */
          field ds_scale         as integer   initial ?
                                              /*    misc1[2]    */
                                              /* ODB: scale     */
          field ds_lngth         as integer   initial ?
                                              /*    misc1[3]    */
                                              /* ODB: length    */
          field ds_radix         as integer   initial ?
                                              /*    misc1[4]    */
                                              /* ODB: radix     */
          field ds_msc17         as integer   initial ?
                                              /*    misc1[7]    */
                                              /* ODB: "EXTATTR" or ?  */
          field ds_msc23         as character initial ?
                                              /*    misc2[3]    */
                                              /* ODB: "<name>" or ?  */
          field ds_msc24         as character initial ?
                                              /*    misc2[4]    */
                                              /* ODB: fld-properties */
          field ds_msc25         as character initial ?
                                              /*    misc2[5]    */
                                              /* ORA: ? or 1 for Unicode data type */
                                              /* ODB: ? - note that misc2[5] is used for ODB - see ds_shdn below */
          field ds_msc26         as character initial ?
                                              /*    misc2[6]    */
                                              /* ODB: Extent char "_" or "#" */
          field ds_shdn          as character initial ?
                                              /*    shadow-column    */
                                              /* ODB: misc2[5]       */
                                              /* ORA: misc2[2]       */
          field ds_shd#          as integer   initial ?
                                              /*    misc1[5]         */
                                              /* ODB: shadow-column  */
          field ds_name          as character case-sensitive
          field ds_itype         as integer   initial ?
          field ds_stdtype       as integer
          field ds_stoff         as integer
          field ds_type          as character
          field ds_allocated     AS INTEGER   INITIAL ?
          field fld_recid        as recid     initial ?
          field tmpfld_recid     as recid     initial ?
          field pro_case         as logical   initial FALSE
          field pro_dcml         as integer   initial ?
          field pro_desc         as character
          field pro_extnt        as integer   initial ?
          field pro_frmt         as character
          field pro_init         as character initial ?
          field pro_mand         as logical   initial FALSE
          field pro_name         as character
          field pro_order        as integer   initial ?
          field pro_type         as character
          field ttb_tbl          as recid
          FIELD defaultname      AS CHARACTER
          FIELD fld_size         AS INTEGER   initial ?
          index upi              is unique primary
                                    ttb_tbl pro_name
          index uidsname         is unique
                                    ttb_tbl ds_name ds_type ds_stoff
          index uifldrecid       is unique
                                    ttb_tbl fld_recid
          index uiorder          is unique
                                    ttb_tbl pro_order
          index istoff        /* is NON-unique */
                                    ttb_tbl ds_stoff.
                                    
  define {&new} shared TEMP-TABLE s_ttb_idx
          field ds_name          as character case-sensitive
          field ds_msc21         as character initial ?
                                              /*    misc2[1]    */
                                              /* ODB: "{a,u,?}" */
                                              /* ORA: "{a,u,?}" */
          field ds_idx_typ       as integer   initial 0
                                              /* 1 indicates Clustered idx */
          field hlp_dtype#       as integer   initial 0
          field hlp_fld#         as integer   initial 0
          field hlp_fstoff       as integer   initial ?
          field hlp_level        as integer   initial 9
          field hlp_mand         as logical   initial TRUE
          field hlp_msc23        as character initial ?
          field pro_actv         as logical   initial TRUE
          field pro_desc         as character
          field pro_idx#         as integer
          field pro_name         as character
          field pro_prim         as logical   initial FALSE
          field pro_uniq         as logical   initial FALSE
          field ds_uniq          as logical   initial FALSE
          field ttb_tbl          as recid
          field idx_recid        as recid
          field hlp_slctd        as logical
          field pro_uniq_bkp     as logical   initial FALSE
          field hlp_idxsize#     as integer   initial 0
          field key_wt#          as integer   initial 0
          index upi              is unique primary
                                    ttb_tbl pro_name
          index idsname       /* is NON-unique */
                                    ttb_tbl ds_name  
          index pick          /* is NON-unique */
                                    hlp_dtype# hlp_fld#  
          index pick2         /* is NON-unique */
                                    hlp_slctd hlp_level.   

  define {&new} shared TEMP-TABLE s_ttb_idf
          field pro_abbr         as logical   initial FALSE
          field pro_asc          as logical
          field pro_order        as integer
          field ttb_fld          as recid
          field ttb_idx          as recid
          index upi              is unique primary
                                    ttb_idx pro_order
          index ifld             is unique
                                    ttb_fld ttb_idx.
  /* OE00195067 BEGIN */

  DEFINE {&new} shared TEMP-TABLE s_ttb_con

          field tab_name AS CHAR
          field col_name AS CHAR
          field const_name AS CHAR
          field cons_type AS CHAR
          field expre AS CHAR
          field par_key AS CHAR
          field par_key_num AS INTEGER
          field index_num AS INTEGER
          field index_name AS CHAR
          field par_tab AS CHAR.
  
  
  /* OE00195067 END */
  DEFINE {&new} shared TEMP-TABLE s_ttb_splfld        
          field name AS CHAR.
  &ENDIF
 
