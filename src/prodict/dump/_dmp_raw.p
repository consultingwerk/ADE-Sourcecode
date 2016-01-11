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


/* _dmp_raw.p - dump the value of an _Db field whose data type is RAW to 
   a .df file.  Output 16 bytes per line to make it easier for the user
   to edit the dump file if necessary (instead of outputting all bytes
   as one lonnnnng line).

   Input Parameters:
      raw_val - is the value to dump.
*/

DEFINE SHARED STREAM ddl.

DEFINE INPUT PARAMETER raw_val AS RAW NO-UNDO.

DEFINE VAR ix             AS INT NO-UNDO.
DEFINE VAR jx      AS INT NO-UNDO.
DEFINE VAR byte    AS INT NO-UNDO.

IF raw_val = ? OR LENGTH(raw_val, "raw":U) = 0 THEN 
   PUT STREAM ddl UNFORMATTED "  ?" SKIP.
ELSE DO:
   DO ix = 0 TO LENGTH(raw_val, "raw":U) - 1 BY 16:
      PUT STREAM ddl UNFORMATTED "  /*".  /* beginning of byte # comment */
      DO jx = 1 TO 16:
         IF jx = 1 THEN
            PUT STREAM ddl UNFORMATTED STRING(ix, "999") + "-" + 
                                       STRING(ix + 15, "999") + "*/  ".
         byte = GETBYTE(raw_val,ix + jx).
         PUT STREAM ddl UNFORMATTED STRING(byte, "999") " ".
      END.
      PUT STREAM ddl UNFORMATTED SKIP.
   end.
   PUT STREAM ddl UNFORMATTED SKIP.
END.
