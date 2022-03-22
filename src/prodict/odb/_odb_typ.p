/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/* _odb_typ.p - Odbc-to-Progress datatype conversion subroutine */

/*
Pass parameters, and this routine will fill in the unknowns, as long as
io-pro-type or io-gate-type is input.

  in:  io-pro-type  = ? or Progress datatype
       io-length    = ? or _Fld-stlen; size, or 0 for variable length
       io-dtype     = ? or _Fld-stdtype; gate datatype code for _Fld-stdtype
       io-gate-type = ? or Odbc datatype
  out: io-pro-type  = Progress datatype
       io-length    = _Fld-stlen
       io-dtype     = _Fld-stdtype
       io-gate-type = Odbc datatype
       io-format    = suggested format

To get the list of progress types that can be mapped to a particular
gateway type:
  in:  io-pro-type  = "get-list"
       io-gate-type = ?
  out: io-pro-type = comma separated list of pro_types

To get the Odbc-to-PROGRESS tables copied to the environment:
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
    94/07/14    hutegger    added output of format in user_env[17] 
                            plus support of i, l, # for formats
                            plus usage of this program for _xxx_mak.p
                            
    04/17/02    D. McMann replaced "?" with "l" for logical data types 
    06/09/02    D. McMann added format x(26) for timestamp
    06/13/06    fernando  Support for bigint
    08/24/06    rkumar replaced "c" with "99:99:99" for TIME data type 
*/ 

                            
/* NOTES for gate_config: 
1) Standard character string must be first in table! 
2) All entries that are the same gateway type must be contiguous in the 
   table.
3) the format can contain either 
   * a specific format                                             OR 
   * {c,d,i,l,#} for (character, date, integer, logical, decimal} to use 
     the format created by the hardcoded algorithm in _xxx_mak.i   
   
*/ 

DEFINE VARIABLE gate-config AS CHARACTER EXTENT 42 NO-UNDO INITIAL [
  /*description      datatype      sz cd  pro type  fm format*/
  /*-----------      --------      -- --  --------  -- ------*/ 
  "Char,	         Char,         0, 35, character,0, |c",
  "Longvarbinary,    Longvarbinary,0, 40, character,0, |c",
  "Time,             Time,         0, 143,character,0, |99:99:99",
  "Timestamp,	     Timestamp,	   0, 44, character,a, |x(26)",
  "Timestamp,	     Timestamp,	   0, 44, date,     a, |d",
  "Longvarchar,	     Longvarchar,  0, 37, character,0, |c",
  "Binary,           Binary,       0, 38, character,0, |c",
  "Varbinary,	     Varbinary,    0, 39, character,0, |c",
  "Date,             Date,         0, 43, date,     0, |d",
  "Numeric,          Numeric,      0, 136,decimal,  1, |#",
  "Numeric,          Numeric,      0, 136,integer,  1, |i",
  "Numeric,          Numeric,      0, 136,int64,    1, |i",
  "Decimal,          Decimal,      0, 236,decimal,  2, |#",
  "Decimal,          Decimal,      0, 236,integer,  2, |i",
  "Decimal,          Decimal,      0, 236,int64,    2, |i",
  "Integer,          Integer,      0, 33, integer,  3, |i",
  "Integer,          Integer,      0, 33, decimal,  3, |#",
  "Integer,          Integer,      0, 33, int64,    3, |i",
  "Integer,          Integer,      0, 33, logical,  3, |l",
  "Smallint,	     Smallint,     0, 32, integer,  4, |i",
  "Smallint,         Smallint,     0, 32, decimal,  4, |#",
  "Smallint,	     Smallint,     0, 32, int64,    4, |i",
  "Smallint,	     Smallint,     0, 32, logical,  4, |l",
  "Float,            Float,        0, 34, decimal,  5, |#",
  "Float,            Float,        0, 34, integer,  5, |i",
  "Float,            Float,        0, 34, int64,    5, |i",
  "Real,             Real,         0, 48, decimal,  6, |#",
  "Real,             Real,         0, 48, integer,  6, |i",
  "Real,             Real,         0, 48, int64,    6, |i",
  "Double,           Double,       0, 134,decimal,  7, |#",
  "Double,           Double,       0, 134,integer,  7, |i",
  "Double,           Double,       0, 134,int64,    7, |i",
  "Varchar,          Varchar,      0, 36, character,0, |c",
  "Bigint,           Bigint,       0, 234,int64,    8, |i",
  "Bigint,           Bigint,       0, 234,decimal,  8, |#",
  "Bigint,           Bigint,       0, 234,integer,  8, |i",
  "Tinyint,          Tinyint,      0, 31, integer,  9, |->>9",
  "Tinyint,          Tinyint,      0, 31, decimal,  9, |->>>>9",
  "Tinyint,          Tinyint,      0, 31, int64,    9, |->>9",
  "Tinyint,          Tinyint,      0, 31, logical,  9, |l",
  "Bit,	     	     Bit,          0, 41, logical,  0, |l",
  ?
].

/* from prodict/dictvar.i */
DEFINE SHARED VARIABLE is-pre-101b-db  AS LOGICAL NO-UNDO.

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
     /* dont' allow int64 if a pre-10.1B schema holder */
     IF NOT is-pre-101b-db OR TRIM(ENTRY(5,gate-config[i])) NE "int64" THEN
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
   /* dont' allow int64 if a pre-10.1B schema holder */
   IF NOT is-pre-101b-db OR TRIM(ENTRY(5,gate-config[i])) NE "int64" THEN
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
                                  ,"character"
                                  )
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

/* PROGRESS datatype -> ODBC datatype (io-pro-type given, io-gate-type = ?) */
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
  io-length   = (IF INTEGER(ENTRY(i,gate_stlen)) = 0 THEN io-length
                ELSE INTEGER(ENTRY(i,gate_stlen)))
  io-format   = (IF gate-config[i] = "d" THEN "99/99/99"
                ELSE IF gate-config[i] = "c" THEN
                  "x(" + STRING(IF io-length = 0 THEN 8 ELSE io-length) + ")"
                ELSE gate-config[i])
  io-dtype    = INTEGER(ENTRY(i,gate_stdtype)).

RETURN.
