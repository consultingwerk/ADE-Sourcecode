/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _prfxfld.p

Syntax:
        RUN adecomm/_prfxfld.p
            ( INPUT        p_FldPrefix ,
              INPUT        p_DBName,
              INPUT        p_TblName,
              INPUT-OUTPUT p_FldName ).

Description:

  Adds either tablename. or dbname.tablename. prefix to each field in a 
  field list.

INPUT Parameters

  p_FldPrefix - Indicates what kind of prefix to add to each field name.
                The values are one of the following:
              
                Field Prefixes   Description
                FP_NOPREFIX      Do not add any prefix.  (Default)
                FP_TBL           Add "tablename." prefix to each field.
                FP_DBTBL         Add "dbname.tablename." prefix to each field.
                
                If any other value is passed, no prefix will be added.
              
                (Note: FP stands for Field Prefix.)
  p_DBName   - The name of the database.  DO NOT include the period separator.
               It is added by the routine.
             
  p_TblName  - The name of the table.  DO NOT include the period separator.
               It is added by the routine. 
             
INPUT-OUTPUT Parameters

  p_FldName  - A comma-delimited list of field names.


Author: John Palazzo

Date Created: 07.30.92 

----------------------------------------------------------------------------*/


DEFINE INPUT        parameter p_FldPrefix AS CHAR no-undo INIT "FP_NOPREFIX".
DEFINE INPUT        parameter p_DBName AS CHAR no-undo.
DEFINE INPUT        parameter p_TblName AS CHAR no-undo.
DEFINE INPUT-OUTPUT parameter p_FldName AS CHAR no-undo.

DEFINE VAR v_FldList AS CHAR no-undo.  /* Used to build field list w' prefixes. */
DEFINE VAR v_period AS CHAR init "." no-undo.
DEFINE VAR v_comma AS CHAR init "," no-undo.
DEFINE VAR v_Field AS INTEGER no-undo.  /* do loop counter. */

    
  /*-------------------- Add prefixes ? -----------------------------*/
  IF ( p_FldPrefix = "FP_TBL" OR p_FldPrefix = "FP_DBTBL" )
     AND NUM-ENTRIES( p_FldName ) > 0 
  THEN DO:
   
    DO v_Field = 1 to num-entries( p_FldName ):
      /* Be sure user passed both a dbname and table name. */
      IF p_FldPrefix = "FP_DBTBL" and p_DBName <> ? and p_TblName <> ?
      THEN v_FldList = v_FldList + p_DBName + v_period.  /* dbname. */
     
      /* Be sure user passed a table name. */
      IF p_TblName <> ?
      THEN v_FldList = v_FldList + p_TblName + v_period. /* tablename. */
      
      /* Build comma delimited Field list. */
      v_FldList = v_FldList + entry( v_Field , p_FldName ) + 
                  IF v_Field < NUM-ENTRIES( p_FldName ) 
                  THEN v_comma
                  ELSE "".  /* Omit last comma in list. */
    END.
    
    p_FldName = v_FldList.  /* Pass prefixed field list back to parameter. */
  END. /* add prefixes. */
      
