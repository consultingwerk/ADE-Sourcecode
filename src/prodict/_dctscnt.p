/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File:
    prodict/_dctscnt.p

Description:
    counts the user-defined tables in db with ldbname p_dbname
    if the database is version 6 or 5 the number will be 0

Input Parameter:
    p_ldbname   logical name of db to count its files

Output Parameter:
    p_file-nr   number of user defined files in that database

Used/Modified Shared Info:
    none

History:
    95/08       changed 1. parameter to logical db-name
                and changed the overall structure to have defined
                output-behaviour and better sanity testing on the 
                db to be used
    D. McMann 07/09/98 Added AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                       to FOR EACH _File.  
    D. McMann 10/17/03 Add NO-LOCK statement to _Db find in support of on-line schema add          

--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

/*{ prodict/dictvar.i }*/

DEFINE INPUT  PARAMETER p_ldbname  AS character NO-UNDO.
DEFINE OUTPUT PARAMETER p_file-nr  AS integer   NO-UNDO.


/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*------------------------  INITIALIZATIONS  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/


if  DBVERSION(p_ldbname) = "5"
 or DBVERSION(p_ldbname) = "6"
 then assign p_file-nr = 0.
 
 else do:  /* DICTDB is a valid db */

  if DBTYPE(p_ldbname) = "PROGRESS"
   then find DICTDB._Db where DICTDB._Db._Db-name = ? NO-LOCK.
   else find DICTDB._Db where DICTDB._Db._Db-name = p_ldbname NO-LOCK.

  /* we are counting USER files, not UNHIDDEN files */
  for each DICTDB._File of DICTDB._Db
    where DICTDB._File._File-num > 0 
      AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
    p_file-nr = 1 to p_file-nr + 1:
    end.
    
  end.     /* DICTDB is a valid db */

/*------------------------------------------------------------------*/

