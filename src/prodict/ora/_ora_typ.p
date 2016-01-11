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

/* _ora_typ.p - Oracle-to-Progress datatype conversion subroutine */

/*
Pass parameters, and this routine will fill in the unknowns, as long as
io-pro-type or io-gate-type is defined.

  in:  io-pro-type  = ? or Progress datatype
       io-length    = ? or _Fld-stlen; size, or 0 for variable length
       io-dtype     = ? or _Fld-stdtype; gate datatype code for _Fld-stdtype
       io-gate-type = ? or Oracle datatype
  out: io-pro-type  = Progress datatype
       io-length    = _Fld-stlen
       io-dtype     = _Fld-stdtype
       io-gate-type = Oracle datatype
       io-format    = suggested format

To get the list of progress types that can be mapped to a particular
gateway type:
  in:  io-pro-type  = "get-list"
       io-gate-type = ?
  out: io-pro-type = comma separated list of pro_types

To get the Oracle-to-PROGRESS tables copied to the environment:
  in:  io-pro-type  = ?
       io-gate-type = ?
  out: user_env[11] = gate_desc
       user_env[12] = gate_type
       user_env[13] = gate_stlen
       user_env[14] = gate_stdtype
       user_env[15] = pro_type
       user_env[16] = gate_family
       user_env[17] = pro_format

  Note: gate_family is the data type family.  This indicates which data
  types can be changed to which other types - only types within the same
  family can be switched with each other.  0 = an orphan: cannot be changed.
*/
/* history:
    98/01/15    D. McMann   Swapped Cursor and Number/logical so that the
                            Number entries are contiguous
    95/05/24    hutegger    added datatype UNDEFINED (treat it like RAW)
    94/07/14    hutegger    added output of format in user_env[17] 
                            plus support of i, l, # for formats
                            plus usage of this program for _xxx_mak.p
*/ 

                            
/* NOTES for gate_config: 
1) Standard character string must be first in table! 
2) All the Number entries should be contiguous in table with 
   the Number/Number entry as the first one.
3) the format can contain either 
   * a specific format                                             OR 
   * {c,d,i,l,#} for (character, date, integer, logical, decimal} to use 
     the format created by the hardcoded algorithm in _xxx_mak.i   OR
   * ? to use the PROGRESS default format  
*/ 

DEFINE VARIABLE gate-config AS CHARACTER EXTENT 20 NO-UNDO INITIAL [
  /*description     datatyp  sz code pro type fm format*/
  /*--------------- -------  - ----- -------- -- ------*/ 
  "Character string,Char      ,0, 4096,character,0,|c", 
  "Var-length Char ,VarChar   ,0, 4096,character,0,|c",
  "Var-length Char2,VarChar2  ,0, 4096,character,0,|c",
  "Number          ,Number    ,0, 8192,decimal  ,1,|#",
  "Number          ,Number    ,0, 8192,integer  ,1,|i",
  "Number          ,Number    ,0, 8192,logical  ,1,|?",
  "Cursor          ,Cursor    ,0, 8192,integer  ,1,|i",
  "Float           ,Float     ,0, 8192,decimal  ,0,|#",
  "BLOB            ,BLOB      ,0,    0,BLOB     ,0,|c",
  "BFILE           ,BFILE     ,0,    0,BLOB     ,0,|c",           
  "Date            ,Date      ,0,12288,date     ,2,|?",
  "DateTime (Char) ,Date      ,0,12288,character,2,|9999/99/99 99:99:99",
  "Time            ,Time      ,0,28672,integer  ,0,|>>,>>9",
  "Long Character  ,Long      ,0,16384,character,0,|c",
  "Undefined       ,undefined ,0,20480,character,0,|c",
  "Raw             ,Raw       ,0,20480,raw      ,0,|c",
  "Long Raw        ,LongRaw   ,0,24576,raw      ,0,|c",
  "Rowid           ,Rowid     ,0, 4096,character,0,|c",
  "Logical         ,Logical   ,0, 8192,logical  ,0,|?",
  ?
].


{ prodict/user/uservar.i }

DEFINE INPUT-OUTPUT PARAMETER io-dtype     AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER io-length    AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER io-pro-type  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER io-gate-type AS CHARACTER NO-UNDO.
DEFINE       OUTPUT PARAMETER io-format    AS CHARACTER NO-UNDO.

DEFINE              VARIABLE  c            AS CHARACTER NO-UNDO.
DEFINE              VARIABLE  gate_desc    AS CHARACTER NO-UNDO.
DEFINE              VARIABLE  gate_stdtype AS CHARACTER NO-UNDO.
DEFINE              VARIABLE  gate_stlen   AS CHARACTER NO-UNDO.
DEFINE              VARIABLE  gate_type    AS CHARACTER NO-UNDO.
DEFINE              VARIABLE  gate_family  AS CHARACTER NO-UNDO.
DEFINE              VARIABLE  i            AS INTEGER   NO-UNDO.
DEFINE              VARIABLE  pro_format   AS CHARACTER NO-UNDO.
DEFINE              VARIABLE  pro_type     AS CHARACTER NO-UNDO.

/* If we want the list of progress types that match a given gateway
   type, then just get that.  A gateway type that matches multiple
   Progress types are in contiguous entries in the gate-config table.
*/
IF io-gate-type <> ? AND io-pro-type = "get-list" THEN DO:
  DO i = 1 TO i + 1 WHILE gate-config[i] <> ?:
    IF TRIM(ENTRY(2,gate-config[i])) = io-gate-type THEN
       LEAVE.
  END.
  io-pro-type = "".
  DO WHILE TRIM(ENTRY(2,gate-config[i])) = io-gate-type:
    io-pro-type = io-pro-type + (IF io-pro-type = "" THEN "" ELSE ",") +
      	       	  TRIM(ENTRY(5,gate-config[i])).
    i = i + 1.
  END.
  RETURN.
END.


/* Compose comma delimited lists of each "column" of the gate-config 
   array (leaving just the format in gate-config itself).
*/
DO i = 1 TO i + 1 WHILE gate-config[i] <> ?:
  ASSIGN
    gate_desc      = gate_desc    + TRIM(ENTRY(1,gate-config[i])) + ","
    gate_type      = gate_type    + TRIM(ENTRY(2,gate-config[i])) + ","
    gate_stlen     = gate_stlen   + TRIM(ENTRY(3,gate-config[i])) + ","
    gate_stdtype   = gate_stdtype + TRIM(ENTRY(4,gate-config[i])) + ","
    pro_type       = pro_type     + TRIM(ENTRY(5,gate-config[i])) + ","
    gate_family    = gate_family  + TRIM(ENTRY(6,gate-config[i])) + ","
    gate-config[i] = SUBSTRING(gate-config[i]
                              ,INDEX(gate-config[i],"|") + 1
                              ,-1
                              ,"character")
    pro_format     = pro_format   + gate-config[i] + "|".
END.

IF io-gate-type = ? AND io-pro-type = ? THEN DO:
  ASSIGN
    user_env[11] = gate_desc
    user_env[12] = gate_type
    user_env[13] = gate_stlen
    user_env[14] = gate_stdtype
    user_env[15] = pro_type
    user_env[16] = gate_family
    user_env[17] = pro_format.
/*  ASSIGN
 *    user_env[11] = pro_type
 *    user_env[12] = gate_type
 *    user_env[13] = gate_stdtype
 *    user_env[14] = gate_stlen
 *    user_env[15] = gate_desc
 *    user_env[16] = gate_family.
 */
  RETURN.
END.

i = 0.

/* PROGRESS datatype -> ORACLE datatype (io-pro-type given, io-gate-type = ?) */
IF io-gate-type = ? THEN DO: 
  DO i = 1 TO NUM-ENTRIES(gate_type) - 1:
    IF io-pro-type = ENTRY(i,pro_type)
      AND INTEGER(ENTRY(i,gate_stdtype)) = io-dtype
      AND (INTEGER(ENTRY(i,gate_stlen))  = io-length
        OR INTEGER(ENTRY(i,gate_stlen))  = 0) THEN LEAVE.
  END.
  io-gate-type = ENTRY(i,gate_type).
END.
ELSE DO: /* io-gate-type given, io-pro-type may be ? */
   i = LOOKUP(io-gate-type,gate_type).
   IF io-pro-type  = ? THEN 
      io-pro-type = ENTRY(i,pro_type).
   ELSE 
      /* Make sure we have the entry that matches both io-pro-type AND
      	 io-gate-type.
      */
      IF io-pro-type <> ENTRY(i,pro_type) THEN
	DO i = i + 1 to NUM-ENTRIES(gate_type) - 1:
	   IF io-pro-type = ENTRY(i,pro_type) AND
	      io-gate-type = ENTRY(i,gate_type) THEN LEAVE.
	END.
END.

ASSIGN
  io-length  = (IF INTEGER(ENTRY(i,gate_stlen)) = 0 THEN io-length
               ELSE INTEGER(ENTRY(i,gate_stlen)))
  io-format  = (IF gate-config[i] = "d" THEN "99/99/99"
               ELSE IF gate-config[i] = "c" THEN
                 "x(" + STRING(IF io-length = 0 THEN 8 ELSE io-length) + ")"
               ELSE gate-config[i])
  io-dtype   = INTEGER(ENTRY(i,gate_stdtype)).

RETURN.
