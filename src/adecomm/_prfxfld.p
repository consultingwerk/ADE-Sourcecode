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
      
