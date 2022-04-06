/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: adedict/_dictfdb.p

Description:
    checks if the schmeaholder has also a PROGRESS-Schema in it
    
Input-Output Pramaeters:
    dbnum   gets increased by one if PROGRESS-Schemaholder contains no 
    PROGRESS-Schema
    
    
History:
    hutegger    94/06/13    creation
    D. McMann   98/06/29    Added _Owner to can-find
    D. McMann   03/10/17    Add NO-LOCK statement to _Db find in support of on-line schema add
    
--------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER dbnum as integer.

/*------------------------------------------------------------------*/

        find first DICTDB._db where DICTDB._db._db-name = ? NO-LOCK no-error.         
        if available DICTDB._Db
         AND NOT can-find(first DICTDB._file of DICTDB._db             
                         where DICTDB._file._file-number > 0
                           AND (DICTDB._File._Owner = "PUB" 
                                 OR DICTDB._File._Owner = "_FOREIGN"))  
          then assign dbnum = dbnum + 1.               


/*------------------------------------------------------------------*/

