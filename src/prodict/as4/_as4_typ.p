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

/* __as4_typ.p - AS/400-to-Progress datatype conversion subroutine */
/* The table below should be kept up-to-date with as4ctl.h  AND
     as4dict/fld/proxtype.i  !! */

/*
Pass parameters, and this routine will fill in the unknowns, as long as
io-pro-type or io-gate-type is defined.

  in:  io-pro-type  = ? or Progress datatype
       io-length    = ? or _Fld-stlen; size, or 0 for variable length
       io-dtype     = ? or _Fld-stdtype; gate datatype code for _Fld-stdtype
       io-gate-type = ? or AS/400 datatype
  out: io-pro-type  = Progress datatype
       io-length    = _Fld-stlen
       io-dtype     = _Fld-stdtype
       io-gate-type = AS/400 datatype
       io-format    = suggested format

To get the AS/400-to-PROGRESS tables copied to the environment:
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
/* Note that the packed DATE field sizes must be specified as 0 (variable),
   because the specified number overrides the length as specified in
   the .df file.  Sloppy file design may indeed have a PACKED(8,0)
   (or PACKED(17,0), etc.)
   field for a YYMMDD value.  We need to know that there are unused
   leading digits.

   Keep the below table in synch with as4ctl.h.
*/

DEFINE VARIABLE gate-config AS CHARACTER EXTENT 37 NO-UNDO INITIAL [
  /*description       datatype sz cd pro type fm format*/
  /*----------------- -------- -- -- -------- -- ------*/
  "Character Alpha   ,String  , 0,31,character,0,|c", /* formatted specially */   
  "Case InSen Key    ,Cstring , 0,41,character,0,|c", 
  "Zoned numeric     ,Zoned   , 0,33,decimal  ,0,|->>,>>>,>>9.99",
  "Packed decimal    ,Packed  , 0,34,decimal  ,0,|->>>,>>>,>>9.99",
  "Pckd (even digits),Packede , 0,42,decimal  ,0,|->,>>>,>>>,>>9.99",
  "Short Integer     ,SInt    , 2,35,integer  ,0,|->>,>>9",
  "Long Integer      ,LInt    , 4,36,integer  ,0,|->>>,>>>,>>9",
  "Short floating pt ,SFloat  , 4,37,decimal  ,0,|->,>>>,>>9",
  "Long floating pt  ,LFloat  , 8,38,decimal  ,0,|->>>,>>>,>>9",
  "Logical           ,Logical , 1,39,logical  ,0,|yes/no",
  "Hex character     ,Hex     , 0,40,character,0,|c",
  "Date MDY          ,DateMDY , 8,71,date     ,0,|d",
  "Date DMY          ,DateDMY , 8,72,date     ,0,|d",
  "Date YMD          ,DateYMD , 8,73,date     ,0,|d",
  "Date Julian       ,DateJUL , 6,74,date     ,0,|d",
  "Date ISO          ,DateISO ,10,75,date     ,0,|d",
  "Date USA          ,DateUSA ,10,76,date     ,0,|d",
  "Date EUR          ,DateEUR ,10,77,date     ,0,|d",
  "Date JIS          ,DateJIS ,10,78,date     ,0,|d",
  "Time HMS          ,TimeHMS , 8,79,character,0,|c",
  "Time ISO          ,TimeISO , 8,80,character,0,|c",
  "Time USA          ,TimeUSA , 8,81,character,0,|c",
  "Time EUR          ,TimeEUR , 8,82,character,0,|c",
  "Time JIS          ,TimeJIS , 8,83,character,0,|c",
  "Time stamp        ,TStamp  ,26,84,character,0,|c", 
  "AS/400 Recid      ,Recid   , 4,85,recid    ,0,|>>>>>>9",
  "",
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

IF DECIMAL(SUBSTRING(PROVERSION,1,3)) > 9.1 THEN
  ASSIGN gate-config[27] = "Raw/Binary        ,Raw     , 0,86,raw      ,0,|x(256)".
ELSE IF DECIMAL(SUBSTRING(PROVERSION,1,3)) = 9.1
       AND SUBSTRING(PROVERSION,4,1) > "B" THEN 
  ASSIGN gate-config[27] = "Raw/Binary        ,Raw     , 0,86,raw      ,0,|x(256)".

DO i = 1 TO i + 1 WHILE gate-config[i] <> ?:
  IF gate-config[i] = "" THEN NEXT.
  ASSIGN
    gate_desc      = gate_desc    + TRIM(ENTRY(1,gate-config[i])) + ","
    gate_type      = gate_type    + TRIM(ENTRY(2,gate-config[i])) + ","
    gate_stlen     = gate_stlen   + TRIM(ENTRY(3,gate-config[i])) + ","
    gate_stdtype   = gate_stdtype + TRIM(ENTRY(4,gate-config[i])) + ","
    pro_type       = pro_type     + TRIM(ENTRY(5,gate-config[i])) + ","
    gate_family    = gate_family  + TRIM(ENTRY(6,gate-config[i])) + ","
    gate-config[i] = SUBSTRING(gate-config[i],INDEX(gate-config[i],"|") + 1)
    pro_format     = pro_format   + gate-config[i] + "|".
END.

IF io-gate-type = ? AND io-pro-type = ? THEN DO: /* set user_env fields */
  ASSIGN
/*    user_env[11] = pro_type
 *    user_env[12] = gate_type
 *    user_env[13] = gate_stdtype
 *    user_env[14] = gate_stlen
 *    user_env[15] = gate_desc
 *    user_env[16] = gate_family.
 */
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

IF io-gate-type = ? THEN DO: /* PROGRESS datatype -> AS/400 datatype */
  DO i = 1 TO NUM-ENTRIES(gate_type) - 1:
    IF (io-pro-type = ENTRY(i,pro_type) OR io-pro-type = ?)
      AND INTEGER(ENTRY(i,gate_stdtype)) = io-dtype
      AND (INTEGER(ENTRY(i,gate_stlen))  = io-length
        OR INTEGER(ENTRY(i,gate_stlen))  = 0) THEN LEAVE.
  END.
  io-gate-type = ENTRY(i,gate_type).
END.

ASSIGN
  i           = (IF i = 0 THEN LOOKUP(io-gate-type,gate_type) ELSE i)
  io-pro-type = (IF io-pro-type = ? THEN ENTRY(i,pro_type) ELSE io-pro-type)
  io-length   = (IF INTEGER(ENTRY(i,gate_stlen)) = 0 THEN io-length
                ELSE INTEGER(ENTRY(i,gate_stlen)))
  io-format   = (IF gate-config[i] = "d" THEN "99/99/99"
                ELSE IF gate-config[i] = "c" THEN
                  "x(" + STRING(IF io-length = 0 THEN 8 ELSE io-length) + ")"
                ELSE gate-config[i])
  io-dtype    = INTEGER(ENTRY(i,gate_stdtype)).

RETURN.
