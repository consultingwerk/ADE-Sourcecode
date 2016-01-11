/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*********************************************************************/

/*-----------------------------------------------------------------------

File:
    prodict/ora/_ora_sys.p
    
Description:
    depending on the input code this routines either creates/updates
    the metaschema-info for the foreign db, or returns specifique info.

Input Parameter:
    system      a   add meta-schema tables
                c   can-delete this _db? (:= no userdefined tables?)
                f   supply list of foreign-names of foreign meta-schema
                p   supply list of progress-names of foreign meta-schema
                q   query for capabilities
                u   supply list of un{dump|load}able foreign object-types

Output Parameter:
    system      a       none
                c       "ok"  or  ""  for "can-delete"  or  "can't delete"
                f,p,u   list of objects
                q       list of allowed/supported functions/features
                
History:
    06/11/07    fernando    Unicode support - new fields in oracle_columns
    04/20/06    fernando    Added NOTTCACHE define - 20050930-006  
    07/18/02    D. McMann   Changed default codepage to iso8859-1
    06/04/02    D. McMann   Added check for problem creating hidden files
    07/13/98    D. McMann   Added _Owner to _File Find
    98/03       D. McMann   Added creation of oracle_tablespace table TS$
    95/08       hutegger    extracted non-queryable objects from l_sys-obj
                            assignment, so that report-builder can use it
                            too (-> ora/ora_sys.i)
    95/08       hutegger    added support for "f" and "p"; plus 
                            auto-update functionality for meta-schema
    94/08       hutegger    Index-Capabilities: u changed from 
                            unique-index-allowed to 
                            change-uniqueness-allowed   and
                            removed the "u" from the capab-string
    06/21/11   kmayur       added support for constraint pull - OE00195067                            

-----------------------------------------------------------------------*/
/*h-*/

/*===========================  DEFINITIONS ============================*/
&GLOBAL-DEFINE NOTTCACHE 1
{ prodict/dictvar.i }

DEFINE INPUT        PARAMETER dbkey         AS RECID     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER system        AS CHARACTER NO-UNDO.

DEFINE VARIABLE               l_schema-ok   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE               l_sys-obj     AS CHARACTER NO-UNDO.
DEFINE VARIABLE               l_sys-obj-f   AS CHARACTER NO-UNDO.

/*=============================  TRIGGERS  ============================*/

/*=======================  INTERNAL PROCEDURES  =======================*/

/*=========================  INITIALIZATIONS  =========================*/

/* initialize system-objects list */
assign
  l_sys-obj   = {prodict/ora/ora_sys.i} /* non-queryable objects */
              + ","
              + "oracle_arguments,oracle_columns,oracle_comment,"
              + "oracle_idxcols,oracle_indexes,oracle_objects,"
              + "oracle_procedures,oracle_sequences,oracle_users,"
              + "oracle_links,oracle_synonyms,oracle_views,"
              + "oracle_tablespace,oracle_constraint,oracle_cons,"
              + "oracle_cons_fld"
  l_sys-obj-f = "ARGUMENT$,COL$,COM$,ICOL$,IND$,OBJ$,"
              + "PROCEDURE$,SEQ$,USER$,LINK$,SYN$,VIEW$,CON$,CDEF$,CCOL$".
/* NOTE: If you add a new foreign-meta-schema table be sure to append
 *       its progress-name and foreign-name TO THE END of the lists
 *       above. This way we automatically upgrade old schemaholders
 *       with the new tables.
 */

/* check if meta-schema is up-to-date */
find first DICTDB._File
  where RECID(DICTDB._File) = dbkey
  and   DICTDB._File._File-name = entry(num-entries(l_sys-obj),l_sys-obj)
  AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN" )
  no-lock no-error.
assign
  l_schema-ok = available DICTDB._File OR dbkey = ?.

/*============================  MAIN CODE  ============================*/

/*
system = "f" for list of foreign-names of meta-schema-objects
-------------------------------------------------------------
*/
IF      system BEGINS "f"
 then assign system = l_sys-obj-f.


/*
system = "p" for list of progress-names of meta-schema-objects
--------------------------------------------------------------
*/
ELSE IF system BEGINS "p"
 then assign system = l_sys-obj.


/*
system = "a" for add system tables
----------------------------------
*/
ELSE IF system BEGINS "a"
 or NOT l_schema-ok THEN DO: /* add meta-schema definitions */
  RUN adecomm/_setcurs.p ("WAIT").
  RUN "prodict/ora/_ora_cra.p" (dbkey) NO-ERROR. /* argument             */
  /* check to make sure table was created if not return */
  IF NOT CAN-FIND(FIRST _file WHERE _db-recid = dbkey
                                AND _file-name = "oracle_arguments") THEN
    RETURN "2".

  RUN "prodict/ora/_ora_crc.p" (dbkey). /* columns              */
  RUN "prodict/ora/_ora_crg.p" (dbkey). /* PROC-TEXT-BUFFER
                                         * SEND-SQL-STATEMENT 
                                         * CLOSEALLPROCS        */
  RUN "prodict/ora/_ora_cri.p" (dbkey). /* indexes              */
  RUN "prodict/ora/_ora_crk.p" (dbkey). /* idxcols              */
  RUN "prodict/ora/_ora_crl.p" (dbkey). /* links synonyms views */
  RUN "prodict/ora/_ora_crm.p" (dbkey). /* comment              */
  RUN "prodict/ora/_ora_cro.p" (dbkey). /* objects              */
  RUN "prodict/ora/_ora_crp.p" (dbkey). /* procedures           */
  RUN "prodict/ora/_ora_crs.p" (dbkey). /* sequences            */
  RUN "prodict/ora/_ora_crt.p" (dbkey). /* tablespaces          */
  RUN "prodict/ora/_ora_cru.p" (dbkey). /* users                */
  RUN "prodict/ora/_ora_crn.p" (dbkey). /* constraint           */
  RUN adecomm/_setcurs.p ("").
  end.

/*
system = "c" for can-remove system tables
-----------------------------------------
*/
/*ELSE*/ IF system BEGINS "c" THEN DO: /* can remove entire schema? */
  /* return TRUE if the database contains no user files and can be deleted */
  FIND FIRST DICTDB._File
    WHERE DICTDB._File._Db-recid = dbkey
    AND   LOOKUP(DICTDB._File._File-name,l_sys-obj) = 0
    AND   DICTDB._File._File-name <> "oracle5_COLUMNS"
    AND   DICTDB._File._File-name <> "oracle5_INDEXES"
    AND   DICTDB._File._File-name <> "oracle5_TABLES"
    AND   DICTDB._File._File-name <> "oracle5_USERS"
    AND   DICTDB._File._File-name <> "oracle6_COLUMNS"
    AND   DICTDB._File._File-name <> "oracle6_COMMENT"
    AND   DICTDB._File._File-name <> "oracle6_IDXCOLS"
    AND   DICTDB._File._File-name <> "oracle6_INDEXES"
    AND   DICTDB._File._File-name <> "oracle6_OBJECTS"
    AND   DICTDB._File._File-name <> "oracle6_TABLES"
    AND   DICTDB._File._File-name <> "oracle6_SEQUENCES"
    AND   DICTDB._File._File-name <> "oracle6_USERS"
    NO-ERROR.
  /* leave ORA5 references in here for update purposes */
  system = STRING(AVAILABLE DICTDB._File,"/ok").
  end.


/*
system = "q" for query
----------------------
  ENTRY  1 = valid database options
             a=after_add, c=can_delete, d=do_delete, u=userid/passwd_supported
  ENTRY  2 = valid file options
             a=add, c=can_copy_fields, d=delete, f=chg_foreign_name,
             g=get_foreign_name, n=can_add_new_fields, o=get_ownername,
             r=rename, s=chg_foreign_size, t=chg_foreign_type
  ENTRY  3 = valid index options
             a=add, b=idxbuild, d=delete, i=inactivate_index,
             n=non-unique_indexes_allowed, r=rename, s=set_primary,
             u=change_uniqueness_allowed, w=word_index, 
             #=index-number-to-be-generated
  ENTRY  4 = load size
  ENTRY  5 = db class and naming conventions
             0=progress_db 1=stand_alone_file 2=part_of_database
             l=logical_name_applies, p=physical_name_applies
  ENTRY  6 = max number index components
  ENTRY  7 = name of sysadmin ("SA", "DBA", "SYSTEM", "MANAGER", etc.)
  ENTRY  8 = name of system tables ("SYS.*", etc.)
  ENTRY  9 = three-letter dictionary code
  ENTRY 10 = valid sequence options
            a=can_add, d=can_delete, m=can-modify-anything-beyond-name
            n=has_foreign_name o=has_owner, r=can_rename, s=seq_supported
  ENTRY 11 = default-value for code-page

*/
ELSE IF system BEGINS "q" THEN DO:
  system = "acdu,dgor,adnrsu#,100,2l,16,DBA,SYS.*,ora,dnors,iso8859-1".
  ASSIGN dbkey = drec_db.
  RUN "prodict/ora/_ora_crt.p" (dbkey).
  RUN "prodict/ora/_ora_crc.p" (dbkey). /* columns  */
  RUN "prodict/ora/_ora_cra.p" (dbkey). /* argument */
end.


/*
system = "u" for unloadable/undumpable file types
-------------------------------------------------
*/
ELSE IF system BEGINS "u" THEN DO:
  system = "PROCEDURE,FUNCTION,PACKAGE,BUFFER".
  end.

RETURN.

/*=====================================================================*/

