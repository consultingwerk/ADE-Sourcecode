/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
