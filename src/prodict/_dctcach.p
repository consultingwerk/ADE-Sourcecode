/*********************************************************************
* Copyright (C) 2006,2008-2009,2011 by Progress Software Corporation.*
* All rights reserved.  Prior versions of this work may contain      *
* portions contributed by participants of Possenet.                  *
*                                                                    *
*********************************************************************/
/*

  History: D. McMann 07/09/98 Added AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                              to FOR EACH _File.
           K. McIntosh 04/25/05 Added code to avoid adding _aud tables to 
                                list, when p_hidden.
           K. McIntosh 04/28/05 Refined logic to allow tables to show when
                                called from options other than "Dump Contents" 
                                and "Edit Security". 20050427-022
           fernando  03/13/06 Using temp-table to hold table names - bug 20050930-006
           fernando  06/26/08 Filter encryption schema table out from cache
           fernando  08/04/09 Put a limit on the size of the table array before
                              switching to the temp-table approach.

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 1 NO-UNDO INITIAL [
  /* 1*/ "Reading Schema..."
].
/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/

/* Include hidden tables in list? */                                  
DEFINE INPUT PARAMETER p_hidden AS LOGICAL NO-UNDO.

DEFINE VARIABLE c      AS CHARACTER NO-UNDO.
DEFINE VARIABLE useVar AS LOGICAL   NO-UNDO INIT YES.
DEFINE VARIABLE totLen AS INT       NO-UNDO.

/* 20050930-006 - get rid of the caching information */
EMPTY TEMP-TABLE tt_cache_file NO-ERROR.

ASSIGN cache_dirty = FALSE
       cache_file# = 0
       cache_file  = ""
       l_cache_tt = FALSE /* 20050930-006 - clear it out */
       c           = user_hdr.  /* save it */

PAUSE 0 BEFORE-HIDE.  /* Added BEFORE-HIDE to prevent prior messages from 
                         being cleared (e.g., from _usrsget.p) in tty mode
                         (Nordhougen 07/25/95) */

{prodict/user/userhdr.i new_lang[1]}

/* For gui only, schema tables may be included in the cache for
   the table get program.
   In tty, the user must type in a schema table name.
*/
IF p_hidden
 THEN FOR EACH DICTDB._File
    WHERE DICTDB._File._Db-recid = drec_db
      AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
      AND NOT CAN-DO({&INVALID_SCHEMA_TABLES},DICTDB._File._File-name)
    BY DICTDB._File._File-name:
  
    /* If this is an Audit table, show only if this was called by a 
       "Schema" menu-item. */
    IF DICTDB._File._File-Name BEGINS "_aud" AND
       (user_env[9] = "f"  OR
        user_env[9] = "rw") THEN NEXT.
       
    /* Set the cache to dirty to force it to rebuild the list next time.
       This prevents an unauthorized tool from seeing these tables. */
    cache_dirty = TRUE.
    
    RUN addEntry(INPUT DICTDB._File._File-name).

    END.
 ELSE FOR EACH DICTDB._File
    WHERE DICTDB._File._Db-recid = drec_db
      AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
      AND NOT DICTDB._File._Hidden
      BY DICTDB._File._File-name:

         RUN addEntry(INPUT DICTDB._File._File-name).

  END.

{prodict/user/userhdr.i c}  /* restore header line */

/* to refresh the db/file status line */
DISPLAY (IF user_filename = "ALL"  THEN "ALL"
    ELSE IF user_filename = "SOME" THEN "SOME"
    ELSE IF drec_file     = ?      THEN ""
    ELSE                                user_filename) 
                           @ user_filename WITH FRAME user_ftr.

RETURN.

/* Added to fix 20050930-006 - we will store the table names in a temp-table
   if we can't fit them into a character field
*/
PROCEDURE addEntry:
    DEFINE INPUT PARAMETER cTableName AS CHARACTER NO-UNDO.

    DEFINE VARIABLE iNum   AS INTEGER   NO-UNDO INIT 0.

    ASSIGN cache_file# = cache_file# + 1.

    IF NOT l_cache_tt THEN DO:

       ASSIGN cache_file[cache_file#] = cTableName NO-ERROR.

       ASSIGN totLen = totLen + LENGTH(cTableName).

       /* OE00163260
          Check the size of the array to leave some room for other things
          as the var is compiled as undo.
       */
       IF totlen > 25000 OR ERROR-STATUS:ERROR THEN DO:
           /* if an error occurred, it could be because there are too many
              tables, or we hit the limit on the character variable size
              (cache_file), so we will use a temp-table to hold the table
              names 
           */

           /* copy them to the temp-table */
           REPEAT iNum = 1 TO (cache_file# - 1):
               CREATE tt_cache_file.
               ASSIGN tt_cache_file.nPos = iNum
                      tt_cache_file.cName = cache_file[iNum].
           END.

           /* now create an entry for the current table name */
           CREATE tt_cache_file.
           ASSIGN tt_cache_file.nPos = cache_file#
                  tt_cache_file.cName = DICTDB._File._File-name
                  tt_cache_file.multitenant = DICTDB._File._File-attributes[1].

           /* clear out cache_file */
           ASSIGN cache_file = ""
                  l_cache_tt = YES.
       END.
    END.
    ELSE DO:
        CREATE tt_cache_file.
        ASSIGN tt_cache_file.nPos = cache_file#
               tt_cache_file.cName = DICTDB._File._File-name
               tt_cache_file.multitenant = DICTDB._File._File-attributes[1].
    END.

END PROCEDURE.
