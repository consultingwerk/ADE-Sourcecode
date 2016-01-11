/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*--------------------------------------------------------------------

File: prodict/dump/dumpname.i

Description:
    checkes and eventually transformes a name into a valid unique 
    dumpname
    
Text-Parameters:
    none

Objects changed:
    nam         INPUT:  dump-name estimation
                OUTPUT: valid, unique dump-name
                    
Included in:
    prodict/dump/_lodname.p
    prodict/dump/_lod_fil.p
    

Author: Tom Hutegger

History:
    hutegger    94/05/23    creation
    Mario B     99/02/12    BUG 98-12-17-030 stop LC() on dumpname.  
    fernando    06/15/06    Expanding Dump-name to 32 characters    
--------------------------------------------------------------------*/
/*h-*/
/*--------------------------------------------------------------------
needs the following variables defined:

DEFINE VARIABLE nam  AS CHARACTER NO-UNDO.
DEFINE VARIABLE pass AS INTEGER   NO-UNDO.
--------------------------------------------------------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

  IF INTEGER(DBVERSION("DICTDB")) > 8 THEN DO:
     nam = SUBSTRING(nam,1,32,"character").
 
    IF CAN-FIND(DICTDB._File WHERE DICTDB._File._Db-recid = drec_db
                               AND DICTDB._File._Dump-name = nam  
                               AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")) THEN
      ASSIGN pass = 1 /*ABSOLUTE(_File-num)*/
             nam  = SUBSTRING(nam + "-------"
                      ,1
                      ,32 - LENGTH(STRING(pass),"character")
                      ,"character"
                      )
                       + STRING(pass).

    DO pass = 1 TO 9999 WHILE 
        CAN-FIND(DICTDB._File WHERE DICTDB._File._Db-recid = drec_db
                                AND DICTDB._File._Dump-name = nam
                                AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")):      
      ASSIGN nam = SUBSTRING(nam + "-------"
                   ,1
                   ,32 - LENGTH(STRING(pass),"character")
                   ,"character"
                   )
                   + STRING(pass).
    END.
  END.
  ELSE DO:
    nam = SUBSTRING(nam,1,8,"character").

    IF CAN-FIND(DICTDB._File WHERE DICTDB._File._Db-recid = drec_db
                               AND DICTDB._File._Dump-name = nam) THEN
      ASSIGN pass = 1 /*ABSOLUTE(_File-num)*/
             nam  = SUBSTRING(nam + "-------"
                      ,1
                      ,8 - LENGTH(STRING(pass),"character")
                      ,"character"
                      )
                       + STRING(pass).

    DO pass = 1 TO 9999 WHILE CAN-FIND(DICTDB._File WHERE DICTDB._File._Db-recid = drec_db
                                                      AND DICTDB._File._Dump-name = nam):      
      ASSIGN nam = SUBSTRING(nam + "-------"
                   ,1
                   ,8 - LENGTH(STRING(pass),"character")
                   ,"character"
                   )
                   + STRING(pass).
    END.
  END.

/*------------------------------------------------------------------*/
