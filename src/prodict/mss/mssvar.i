/*********************************************************************
* Copyright (C) 2006,2008-2011 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
    History:  D. McMann 03/03/99 Removed On-line from Informix
              D. McMann 02/01/00 Added sqlwidth variable
              D. McMann 06/18/01 Added case and collation variables
              fernando  04/14/06 Unicode support
              fernando  04/11/08 Support for new seq generator
              fernando  03/20/09 Support for datetime-tz
              Nagaraju  09/22/09 Support for Computed Columns
*/    

DEFINE {1} SHARED VARIABLE pro_dbname     AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE pro_conparms   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE osh_dbname     AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_dbname     AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_pdbname    AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_username   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_password   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_codepage   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_collname   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_incasesen  AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_conparms   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE long-length    AS INTEGER   INITIAL 8000.
DEFINE {1} SHARED VARIABLE movedata       AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE pcompatible    AS LOGICAL   NO-UNDO  INITIAL TRUE.
DEFINE {1} SHARED VARIABLE sqlwidth       AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE loadsql        AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE genrepenv      AS INTEGER   NO-UNDO INITIAL 0. 
DEFINE {1} SHARED VARIABLE genreplvl      AS INTEGER   
                         LABEL "Rank Report Level"
                         view-as COMBO-BOX INNER-LINES 3
                         LIST-ITEM-PAIRS "None",0,"Summary",1,"Itemized",2
                         DROP-DOWN-LIST
                         SIZE 15 BY 1 
                         NO-UNDO INITIAL 1.
DEFINE {1} SHARED VARIABLE rmvobj         AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE shadowcol      AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE descidx        AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE dflt           AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE iFmtOption     AS INTEGER   NO-UNDO
                                                    INITIAL 2.
DEFINE {1} SHARED VARIABLE lFormat        AS LOGICAL   NO-UNDO
                                                    INITIAL TRUE.
DEFINE {1} SHARED VARIABLE iRecidOption   AS INTEGER   NO-UNDO
                                                    INITIAL 2.
DEFINE {1} SHARED VARIABLE unicodeTypes   AS LOGICAL   NO-UNDO INITIAL FALSE.
DEFINE {1} SHARED VARIABLE lUniExpand     AS LOGICAL   NO-UNDO INITIAL FALSE.
DEFINE {1} SHARED VARIABLE newseq         AS LOGICAL   NO-UNDO INITIAL TRUE.
DEFINE {1} SHARED VARIABLE mapMSSDatetime AS LOGICAL   NO-UNDO INITIAL TRUE.
DEFINE {1} SHARED VARIABLE longlength     AS INTEGER   NO-UNDO.

DEFINE {1} SHARED STREAM dbg_stream.

DEFINE {1} SHARED VARIABLE stages 		    AS LOGICAL EXTENT 7 NO-UNDO.
DEFINE {1} SHARED VARIABLE stages_complete 	AS LOGICAL EXTENT 7 NO-UNDO.

/* OE00195067 BEGIN : New variable defnition for child migration frame */
DEFINE button s_btn_Advanced SIZE 24 by 1.125.
DEFINE {1} SHARED VARIABLE choiceUniquness     AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE choiceDefault       AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE migConstraint       AS LOGICAL NO-UNDO INITIAL FALSE.
DEFINE {1} SHARED VARIABLE choiceRowid         AS INTEGER NO-UNDO INITIAL 1.
DEFINE {1} SHARED VARIABLE choiceSchema        AS INTEGER NO-UNDO.
DEFINE {1} SHARED VARIABLE recidCompat         AS LOGICAL NO-UNDO INITIAL FALSE.
DEFINE {1} SHARED VARIABLE forRowidUniq        AS LOGICAL NO-UNDO INITIAL FALSE.
DEFINE {1} SHARED VARIABLE ForRow	           AS LOGICAL NO-UNDO INITIAL TRUE.
DEFINE {1} SHARED VARIABLE selBestRowidIdx     AS LOGICAL NO-UNDO.
DEFINE {1} SHARED VARIABLE tryPimaryForRowid   AS LOGICAL NO-UNDO.
DEFINE {1} SHARED VARIABLE shdcol              AS LOGICAL NO-UNDO.
DEFINE {1} SHARED VARIABLE lExpand             AS LOGICAL NO-UNDO.
DEFINE {1} SHARED VARIABLE recid_verify        AS LOGICAL NO-UNDO.

/* OE00195067 END */

/*
 * Constants describing stage we are at.
 */ 
define {1} shared variable mss_create_sql	  as integer   initial 1.
define {1} shared variable mss_dump_data   	  as integer   initial 2.
define {1} shared variable mss_create_sh 	  as integer   initial 3. 
define {1} shared variable mss_create_objects     as integer   initial 4.
define {1} shared variable mss_build_schema	  as integer   initial 5.
define {1} shared variable mss_fixup_schema	  as integer   initial 6.
define {1} shared variable mss_load_data	  as integer   initial 7. 
define {1} shared variable s_file-sel             as character initial "*". 
     

DEFINE {1} SHARED VARIABLE osh_conparms     AS CHARACTER NO-UNDO.

DEFINE {1} SHARED VARIABLE kwlist  AS CHARACTER NO-UNDO  INITIAL "PKC,CKC,NONCKC,EXIST,~
DERIVED,OEPK,MIGCON,SELBST,PSREC,NONCC,PKROW,PKFND,RWNCC,~
NORW,NORW2,PAS2,UON,UKFRW,OEPUK,NTGPK".

/* Initialize the description in extent elements. These are interpretations of tags
   in the ROWID designation algorithm.
   The array indexes are based on keyword list maintained in variable kwlist
*/
DEFINE {1} SHARED VARIABLE DescArray AS CHARACTER EXTENT 20 NO-UNDO INITIAL [
          "An active Primary/Unique-clustered constraint is designated as ROWID.", /* PKC */
          "An active non-Unique clustered exist but cannot be designated as ROWID. ROWID will be based on non-clustered index.", /* CKC */
          "ROWID will be based on non-clustered index.", /* NONCKC */
          "An existing index has been designated as ROWID.", /*EXIST */
          "A derived index has been designated as ROWID.", /* DERIVED */
          "OE Primary has been designated as ROWID.", /* OEPK */
          "ROWID designated using Migrate constraint option.", /* MIGCON */
          "ROWID designated using Select Best option.", /* SELBST */
          "PROGRESS_RECID is designated as ROWID.", /* PSREC */
          "ROWID designated from non-Primary Clustered index %1 . ", /* NONCC */
          "Primary Constraint is derived from Index %1 of the table.", /* PKROW */
          "This Primary Constraint is designated as ROWID.", /* PKFND */
          "Designated ROWID is not derived from a Clustered index.", /* RWNCC */
          "No eligible ROWID candidate identified.", /* NORW */
          "Parse-2 attempted and failed. Possibly table has no indexes OR table has only non-mandatory indexes.", /* NORW2 */
          "Parse 2 not attempted.Ensure there are MANDATORY field Indexes.", /* PAS2 */
          "Try turning ON 'For ROWID Uniqueness' migration option.", /* UON */
          "Index %1 is uniquified in order to produce a ROWID candidate.", /* UKFRW */
          "OE Primary Index %1 has been uniquified in order to produce a ROWID candidate.", /* OEPUK */
          "Trigger option cannot be used to make a Primary Constraint candidate." /* NTGPK */
         ].

