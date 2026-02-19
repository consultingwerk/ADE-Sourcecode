/*********************************************************************
* Copyright (C) 2006,2014,2025 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------

File: prodict/user/_usrinf3.p

Description:
    gets collation- and codepage-name of current DB. Also large sequence
    and large key support flags
    
Input-Parameters:
    p_currdb        name of current DB
        
Output-Parameters:
    p_collname      collation-name of current db
    p_codepage      codepage-name of current db
    p_large_seq     yes/no for large sequence support or ? for n/a
    p_large_keys    yes/no for large keys support or ? for n/a
    
    
History:
    hutegger    94/06/13    creation
    McMann      10/17/03  Add NO-LOCK statement to _Db find in support of on-line schema add
    fernando    06/06/06  large sequence and large keys support
    fernando    08/13/25  Cleanup of is-pre-101b-db
--------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_currdbn  AS character.
DEFINE INPUT  PARAMETER p_currdbt  AS character.
DEFINE OUTPUT PARAMETER p_codepage AS character.
DEFINE OUTPUT PARAMETER p_collname AS character.
DEFINE OUTPUT PARAMETER p_large_seq AS LOGICAL.
DEFINE OUTPUT PARAMETER p_large_keys AS LOGICAL.
DEFINE OUTPUT PARAMETER p_multitenant AS LOGICAL.
DEFINE OUTPUT PARAMETER p_partitioned AS LOGICAL.
DEFINE OUTPUT PARAMETER p_cdcenabled AS LOGICAL.
/*------------------------------------------------------------------*/

if p_currdbt = "PROGRESS"
  then find first DICTDB._db where DICTDB._db._db-name = ?         NO-LOCK no-error.         
  else find first DICTDB._db where DICTDB._db._db-name = p_currdbn NO-LOCK no-error.         
if available DICTDB._Db
  then do: 
    assign 
    p_codepage = DICTDB._Db._Db-xl-name
    p_collname = DICTDB._Db._Db-coll-name.               

    /* For Progress db's, large keys and sequences are always enabled now.
    */
    IF p_currdbt = "PROGRESS" THEN
       ASSIGN p_large_keys = YES
              p_large_seq = YES.
    ELSE 
        ASSIGN p_large_keys = ?
               p_large_seq = ?.

   /* Adding support for Multitenant and Partitioned display*/
   FIND DICTDB._Database-feature WHERE _DBFeature_Name = "Table Partitioning" NO-LOCK NO-ERROR.
   IF AVAILABLE DICTDB._Database-feature THEN DO:
     IF DICTDB._Database-feature._DBFeature_Enabled = "1" THEN
          p_partitioned = true.
     ELSE
          p_partitioned = false.
   END.
   ELSE 
        ASSIGN p_partitioned = ?.

   IF can-find(first dictdb._tenant) then
      p_multitenant = true.
   ELSE
      p_multitenant = false.

   FIND DICTDB._Database-feature WHERE _DBFeature_Name = "Change Data Capture" NO-LOCK NO-ERROR.
   IF AVAILABLE DICTDB._Database-feature THEN DO:
     IF DICTDB._Database-feature._DBFeature_Enabled = "1" THEN
          p_cdcenabled = true.
     ELSE
          p_cdcenabled = false.
   END.
   ELSE 
        ASSIGN p_cdcenabled = ?.


  END.
  else assign 
    p_codepage = ""
    p_collname = ""
    p_large_seq = ?
    p_large_keys = ?. 


/*------------------------------------------------------------------*/
