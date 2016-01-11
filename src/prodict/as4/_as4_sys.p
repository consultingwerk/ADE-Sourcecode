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


/*-----------------------------------------------------------------------

File:
    prodict/as4/_as4_sys.p
    
Description:
    depending on the input code this routines either creates/updates
    the metaschema-info for the FOREIGN db, or returns specific info.

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
    98/06/30    D. McMann   Added  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                            to _file find.
    95/08       hutegger    added support for "f" and "p"; plus 
                            auto-update functionality for meta-schema
    94/08       hutegger    Index-Capabilities: u changed from 
                            unique-index-allowed to 
                            change-uniqueness-allowed   and
                            removed the "u" from the capab-string

-----------------------------------------------------------------------*/
/*h-*/

/*===========================  DEFINITIONS ============================*/

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
  l_sys-obj   = ""
  l_sys-obj-f = "".
/* NOTE: If you add a new foreign-meta-schema table be sure to append
 *       its progress-name and foreign-name TO THE END of the lists
 *       above. This way we automatically upgrade old schemaholders
 *       with the new tables.
 */

/* check if meta-schema is up-to-date * /
find first DICTDB._File
  where RECID(DICTDB._File) = dbkey
  and   DICTDB._File._File-name = entry(num-entries(l_sys-obj),l_sys-obj)
  and  (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
  no-lock no-error. / **/
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
END.


/*
system = "c" for can-remove system tables
-----------------------------------------
*/
ELSE IF system BEGINS "c" THEN DO: /* can remove entire schema? */
  /* return OK if the database contains no user files and can be deleted */
  FIND FIRST _File WHERE _File._Db-recid = dbkey NO-ERROR.
  system = STRING(AVAILABLE _File,"/ok").
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
            u=change_uniqueness_allowed, w=word_index, 
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
            n=has_foreign_name o=has_owner, r=can_rename, s=seq_support
  ENTRY 11 = default-value for code-page

*/
ELSE IF system BEGINS "q" THEN DO:
  system = "cu,dgr,nr,100,2l,64,,,as4,ds,ibm037".
END.


/*
system = "u" for unloadable/undumpable file types
-------------------------------------------------
*/
ELSE IF system BEGINS "u" THEN DO:
  system = "".
END.

RETURN.

/*=====================================================================*/

