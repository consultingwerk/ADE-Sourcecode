/*********************************************************************
* Copyright (C) 2006-09 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _mss_typ.p - mss-to-Progress datatype conversion subroutine */

/*
Pass parameters, and this routine will fill in the unknowns, as long as
io-pro-type or io-gate-type is input.

  in:  io-pro-type  = ? or Progress datatype
       io-length    = ? or _Fld-stlen; size, or 0 for variable length
       io-dtype     = ? or _Fld-stdtype; gate datatype code for _Fld-stdtype
       io-gate-type = ? or MSS datatype
  out: io-pro-type  = Progress datatype
       io-length    = _Fld-stlen
       io-dtype     = _Fld-stdtype
       io-gate-type = MSS datatype
       io-format    = suggested format

To get the list of progress types that can be mapped to a particular
gateway type:
  in:  io-pro-type  = "get-list"
       io-gate-type = ?
  out: io-pro-type = comma separated list of pro_types

To get the MSS-to-PROGRESS tables copied to the environment:
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
 
 NOTES for gate_config: 
1) Standard character string must be first in table! 
2) All entries that are the same gateway type must be contiguous in the 
   table.
3) the format can contain either 
   * a specific format                                             OR 
   * {c,d,i,l,#,dt} for (character, date, integer, logical, decimal,datetime}
     to use the format created by the hardcoded algorithm in _xxx_mak.i   OR
 
 History:  D. McMann replaced "?" with "l" for logical data types 04/17/02
           D. McMann added format x(26) for timestamp 06/09/02
           D. McMann Removed unicode data types and guid
           fernando  04/14/06 Unicode support
           fernando  05/26/05 Added support for int64
           fernando  02/14/08 Added support for datetime
           knavneet   03/16/09  datetime-tz support for MSS
           knavneet   04/28/09  BLOB support for MSS (OE00178319)
           knavneet   05/27/09  OE00185197            
           sgarg      05/22/09  ROWGUID support for MSS
*/ 
&SCOPED-DEFINE GATE_CONFIG_ENTRIES 59
DEFINE VARIABLE gate-config AS CHARACTER EXTENT {&GATE_CONFIG_ENTRIES} NO-UNDO.
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
DEFINE              VARIABLE  isDatetimeDefault  AS LOGICAL   NO-UNDO INIT NO.
DEFINE              VARIABLE  isLobDefault      AS LOGICAL   NO-UNDO INIT NO.
DEFINE              VARIABLE  numEntries         AS INTEGER   NO-UNDO.

FUNCTION initGateConfig RETURN CHARACTER EXTENT {&GATE_CONFIG_ENTRIES}
 (INPUT isDatetimeDefault as logical, INPUT isLobDefault as logical) FORWARD.

IF io-pro-type NE ? THEN DO:
   ASSIGN numEntries   = NUM-ENTRIES(io-pro-type).
          isDatetimeDefault = (IF ENTRY(1,io-pro-type) = "datetime_default" 
                               THEN YES ELSE NO).
   IF numEntries > 1 THEN
      isLobDefault = (IF ENTRY(2,io-pro-type) = "lob_default" 
                      THEN YES ELSE NO ).

   /* must reset it in these special cases */
   IF isDatetimeDefault OR isLobDefault THEN
       io-pro-type = ?. 
END.

gate-config = initGateConfig (isDatetimeDefault, isLobDefault).

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

  RETURN.
END.
i = 0.

/* PROGRESS datatype -> MSS datatype (io-pro-type given, io-gate-type = ?) */
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

/* Function : initGateConfig
   Purpose  : initilize gate-config[]
   Input    : 1 - isDatetimeDefault as logical
              2 - isBlobDefault as logical
   RETURN   : Character extent */

FUNCTION initGateConfig RETURN CHARACTER EXTENT {&GATE_CONFIG_ENTRIES}
 (INPUT isDatetimeDefault as logical, INPUT isLobDefault as logical):

DEFINE VARIABLE gate-config AS CHARACTER EXTENT {&GATE_CONFIG_ENTRIES} NO-UNDO.
/* Assign gate-config[i], where 'i' is the extent no., as:
gate-config[i] = "<description>, <datatype>, <sz>, <cd>, <pro type>, <fm>, <format>" */

ASSIGN
  gate-config[1] = "Varchar, Varchar, 0, 36, character,0, |c"
  gate-config[2] = "NVarchar, Nvarchar, 0, 51, character,0, |c"
  gate-config[3] = "Char, Char, 0, 35, character,0, |c"
  gate-config[4] = "Nchar, Nchar, 0, 50, character,0, |c"
  gate-config[5] = "NLongvarchar, Nlongvarchar, 0, 52, character,0, |c"
  gate-config[6] = "Time, Time, 0, 53, character,b, |x(16)"
  gate-config[7] = "Time, Time, 0, 53, datetime ,b, |dt"
  gate-config[8] = "Longvarchar, Longvarchar, 0, 37, character,0, |c"
  gate-config[9] = "Binary, Binary, 0, 38, character,0, |c"
  gate-config[10] = "Date, Date, 0, 43, date, c, |d"
  gate-config[11] = "Date, Date, 0, 43, datetime, c, |dt"
  gate-config[12] = "Date, Date, 0, 43, datetime-tz, c, |dtz"
  gate-config[13] = "Date, Date, 0, 43, character, c, |x(10)"
  gate-config[14] = "Numeric, Numeric, 0, 136,decimal, 1, |#"
  gate-config[15] = "Numeric, Numeric, 0, 136,integer, 1, |i"
  gate-config[16] = "Numeric, Numeric, 0, 136,int64, 1, |i"
  gate-config[17] = "Decimal, Decimal, 0, 236,decimal, 2, |#"
  gate-config[18] = "Decimal, Decimal, 0, 236,integer, 2, |i"
  gate-config[19] = "Decimal, Decimal, 0, 236,int64, 2, |i"
  gate-config[20] = "Integer, Integer, 0, 33, integer, 3, |i"
  gate-config[21] = "Integer, Integer, 0, 33, decimal, 3, |#"
  gate-config[22] = "Integer, Integer, 0, 33, logical, 3, |?"
  gate-config[23] = "Integer, Integer, 0, 33, int64, 3, |i"
  gate-config[24] = "Integer, Integer, 0, 33, recid, 3, |i" 
  gate-config[25] = "Smallint, Smallint, 0, 32, integer, 4, |i"
  gate-config[26] = "Smallint, Smallint, 0, 32, decimal, 4, |#"
  gate-config[27] = "Smallint, Smallint, 0, 32, logical, 4, |l"
  gate-config[28] = "Smallint, Smallint, 0, 32, int64, 4, |i"
  gate-config[29] = "Float, Float, 0, 34, decimal, 5, |#"
  gate-config[30] = "Float, Float, 0, 34, integer, 5, |i"
  gate-config[31] = "Float, Float, 0, 34, int64, 5, |i"
  gate-config[32] = "Real, Real, 0, 48, decimal, 6, |#"
  gate-config[33] = "Real, Real, 0, 48, integer, 6, |i"
  gate-config[34] = "Real, Real, 0, 48, int64, 6, |i"
  gate-config[35] = "Double, Double, 0, 134,decimal, 7, |#"
  gate-config[36] = "Double, Double, 0, 134,integer, 7, |i"
  gate-config[37] = "Double, Double, 0, 134,int64, 7, |i"
  gate-config[38] = "Bigint, Bigint, 0, 234,int64, 8, |i"
  gate-config[39] = "Bigint, Bigint, 0, 234,decimal, 8, |#"
  gate-config[40] = "Bigint, Bigint, 0, 234,integer, 8, |i"
  gate-config[41] = "Tinyint, Tinyint, 0, 31, integer, 9, |->>9"
  gate-config[42] = "Tinyint, Tinyint, 0, 31, decimal, 9, |->>>>9"
  gate-config[43] = "Tinyint, Tinyint, 0, 31, logical, 9, |l"
  gate-config[44] = "Tinyint, Tinyint, 0, 31, int64, 9, |i"
  gate-config[45] = "Bit, Bit, 0, 41, logical, 0, |l"
  gate-config[46] = "Timestamp-tz, Timestamp-tz, 0, 54 ,datetime-tz, d,|dtz"
  gate-config[47] = "Timestamp-tz, Timestamp-tz, 0, 54 ,datetime, d,|dt"
  gate-config[48] = "Timestamp-tz, Timestamp-tz, 0, 54 ,date, d,|d"
  gate-config[49] = "Timestamp-tz, Timestamp-tz, 0, 54 ,character, d,|x(34)".

IF isDatetimeDefault THEN 
    ASSIGN
      gate-config[50] = "Timestamp, Timestamp, 0, 44, datetime, a, |dt"
      gate-config[51] = "Timestamp, Timestamp, 0, 44, date, a, |d".
ELSE
    ASSIGN
      gate-config[50] = "Timestamp, Timestamp, 0, 44, date, a, |d"
      gate-config[51] = "Timestamp, Timestamp, 0, 44, datetime, a, |dt".

ASSIGN
  gate-config[52] = "Timestamp, Timestamp, 0, 44, datetime-tz, a, |dtz"
  gate-config[53] = "Timestamp, Timestamp, 0, 44, character, a, |x(27)".


IF isLobDefault THEN 
    ASSIGN
      gate-config[54] = "Longvarbinary, Longvarbinary,0, 40, BLOB,e, |c"
      gate-config[55] = "Longvarbinary, Longvarbinary,0, 40, character,e, |c"
      gate-config[56] = "Varbinary, Varbinary, 0, 39, BLOB,f, |c"
      gate-config[57] = "Varbinary, Varbinary, 0, 39, character,f, |c".
ELSE
    ASSIGN
      gate-config[54] = "Longvarbinary, Longvarbinary,0, 40, character,e, |c"
      gate-config[55] = "Longvarbinary, Longvarbinary,0, 40, BLOB,e, |c"
      gate-config[56] = "Varbinary, Varbinary, 0, 39, character,f, |c"
      gate-config[57] = "Varbinary, Varbinary, 0, 39, BLOB,f, |c".

/* Add any other entries here */
ASSIGN
  gate-config[58] = "ROWGUID, ROWGUID, 0, 55, character, 0, |x(36)". /* OE00196270 */
ASSIGN 
   gate-config[{&GATE_CONFIG_ENTRIES}] = ?. /* Please note that this should be the last value */

RETURN gate-config.
END FUNCTION.

RETURN.
