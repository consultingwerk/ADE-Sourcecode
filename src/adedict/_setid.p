/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------

File: _setid.p

Description:
   Set p_Id to the recid of the _File record for the current table.

Input Parameter:
   p_ObjType - the type of object (DB or TBL )

Output Parameter:
   p_Id - The place to store the record Id 

Author: Laura Stern

Date Created: 02/07/92 
    Modified: 06/30/98 D. McMann Added  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                                 to find of _File
              03/27/02 D. McMann Added new _file find based on new table recid
                                 variable.    
              10/17/03 D. McMann Add NO-LOCK statement to _Db find in support of on-line schema add               
-----------------------------------------------------------------------*/

{adedict/dictvar.i shared}

Define input  parameter p_ObjType   as integer.
Define output parameter p_Id        as recid.



if p_ObjType = {&OBJ_DB}
 then do:
   FIND DICTDB._Db
     where DICTDB._Db._DB-Name = (if {adedict/ispro.i}
                                   then ? 
                                   else s_CurrDb
                                 ) NO-LOCK.
   p_Id = RECID(_Db).
  end.

 else do:  /* table */
   if p_ObjType = {&OBJ_TBL} then DO:

      find first DICTDB._File where DICTDB._File._DB-recid  = s_DbRecId
                                and DICTDB._File._File-name = s_CurrTbl
                            and  (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                          NO-LOCK NO-ERROR.
       
      IF NOT AVAILABLE DICTDB._File THEN 
      _f-loop:        
      FOR EACH DICTDB._File where DICTDB._File._File-name = s_CurrTbl 
                              AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                              NO-LOCK:
          
        IF DICTDB._File._db-recid = s_DbRecid THEN DO:
          assign p_id = RECID(DICTDB._File).
          LEAVE _f-loop.
        END.
      END.                         
      ELSE 
      p_Id = RECID(DICTDB._File).
      IF p_id = ? THEN
          ASSIGN p_Id = n_tblrecid.
   end.
  end.     /* table */





