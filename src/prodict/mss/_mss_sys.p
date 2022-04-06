/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

./*-----------------------------------------------------------------------

File:
    prodict/mss/_mss_sys.p
    
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
      04/20/06    fernando    Added NOTTCACHE define - 20050930-006  
-----------------------------------------------------------------------*/


/*===========================  DEFINITIONS ============================*/
&GLOBAL-DEFINE NOTTCACHE 1
{ prodict/dictvar.i }

DEFINE INPUT        PARAMETER dbkey  AS RECID     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER system AS CHARACTER NO-UNDO.

DEFINE VARIABLE               l_schema-ok   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE               l_sys-obj     AS CHARACTER NO-UNDO.
DEFINE VARIABLE               l_sys-obj-f   AS CHARACTER NO-UNDO.

/*=============================  TRIGGERS  ============================*/

/*=======================  INTERNAL PROCEDURES  =======================*/

/*=========================  INITIALIZATIONS  =========================*/

/* initialize system-objects list */
assign
  l_sys-obj   = {prodict/mss/mss_sys.i}
  l_sys-obj-f = "".
/* NOTE: If you add a new foreign-meta-schema table be sure to append
 *       its progress-name and foreign-name TO THE END of the lists
 *       above. This way we automatically upgrade old schemaholders
 *       with the new tables.
 */

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
ELSE IF system BEGINS "a" THEN DO: /* add meta-schema definitions */
  RUN adecomm/_setcurs.p ("WAIT").
  RUN "prodict/mss/_mss_crp.p" (dbkey).
  RUN adecomm/_setcurs.p ("").
END.


/*
system = "c" for can-remove system tables
-----------------------------------------
*/
ELSE IF system BEGINS "c" THEN DO: /* can remove entire schema? */
  /* return OK if the database contains no user files and can be deleted */
  FIND FIRST DICTDB._File
    WHERE DICTDB._File._Db-recid = dbkey
    AND   LOOKUP(DICTDB._File._File-name,l_sys-obj) = 0
    and (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
    NO-ERROR.
  system = STRING(AVAILABLE DICTDB._File,"/ok").
END.


/*
system = "q" for query
----------------------
  ENTRY 1 = valid database options
            a=after_add, c=can_delete, d=do_delete, u=userid/passwd_supported
  ENTRY 2 = valid file options
            a=add, c=can_copy_fields, d=delete, f=chg_foreign_name,
            g=get_foreign_name, n=can_add_new_fields, o=get_ownername,
            r=rename, s=chg_foreign_size, t=chg_foreign_type
  ENTRY 3 = valid index options
            a=add, b=idxbuild, d=delete, i=inactivate_index,
            n=non-unique_indexes_allowed, r=rename, s=set_primary,
            u=change uniqueness_allowed, w=word_index, 
             #=index-number-to-be-generated
  ENTRY 4 = load size
  ENTRY 5 = db class and naming conventions
            0=progress_db 1=stand_alone_file 2=part_of_database
            l=logical_name_applies, p=physical_name_applies
  ENTRY 6 = max number index components
  ENTRY 7 = name of sysadmin user ("SA", "DBA", "SYSTEM", "MANAGER", etc.)
  ENTRY 8 = name of system tables ("SYS.*", etc.)
  ENTRY 9 = three-letter dictionary code
  ENTRY 10 = valid sequence options
            a=can_add, d=can_delete, m=can-modify-anything-beyond-name
            n=has_foreign_name o=has_owner, r=can_rename, s=seq_supported
  ENTRY 11 = default-value for code-page
*/
ELSE IF system BEGINS "q" THEN DO:
  system = "acdu,adgor,adnrsu#,100,2lp,16,?,?,mss,nors,iso8859-1".
END.


/*
system = "u" for unloadable/undumpable file types
-------------------------------------------------
*/
ELSE IF system BEGINS "u" THEN DO:
  system = "BUFFER,PROCEDURE".
END.

RETURN.
