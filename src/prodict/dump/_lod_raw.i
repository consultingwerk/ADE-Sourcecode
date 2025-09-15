/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/


/* _lod_raw.i - load the value of an _Db field whose data type is RAW.

   The first element of ilin should be a comment.  After that, the
   first num bytes (from the version) of the raw value are in the ilin 
   array - one array element per byte.  Each byte is in it's 3-digit 
   ascii representation.  Handle this line and all subsequent lines for 
   this field attribute.  The value will be stored in the wdbs buffer.

   {1} field length (# of bytes to load)

   Input Parameters:
      p_Version - The version # of the collate/translate table format
      hField    - handle of the field to be updated
      p_index   - index of element if field is an array, or 0 for non-array field
      
   History:
   fernando    08/21/06 Fixing load of collation into pre-10.1A db (20060413-001)
*/

&GLOBAL-DEFINE NO_TABLES 1
{ prodict/dump/loaddefs.i }

DEFINE INPUT  PARAMETER p_Version AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER hField   AS HANDLE  NO-UNDO.
DEFINE INPUT  PARAMETER p_index   AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER p_Changed AS LOGICAL NO-UNDO.

DEFINE VAR ix              AS INT NO-UNDO init 0.
DEFINE VAR jx       AS INT NO-UNDO.
DEFINE VAR byte     AS INT NO-UNDO.
DEFINE VAR num      AS INT NO-UNDO.  /* # of bytes per line */
DEFINE VAR raw_val  AS RAW NO-UNDO.
DEFINE VAR orig_val AS RAW NO-UNDO.
DEFINE VAR modify   AS LOGICAL NO-UNDO.

/* Do some rudimentary error checking on the format of the data */
IF NOT (ilin[1] BEGINS "/*") THEN DO:
   ierror = 24.
   return.
END.
jx = INTEGER(ilin[2]) NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
   ierror = 24.
   return.
END.

/* The version # format is n.n-m where m is the # of bytes on one
   line of the .df file.
*/
num = INTEGER(SUBSTR(p_Version, INDEX(p_Version, "-") + 1)).

orig_val = hField:BUFFER-VALUE(p_index).

IF ilin[1] = ? THEN 
   hField:BUFFER-VALUE(p_index) = ?.
ELSE DO:
   IF hField:BUFFER-VALUE(p_index) = ? THEN
      /* This is the only way to replace the unknown value.
               putbyte won't do it!.
      */
      hField:BUFFER-VALUE(p_index) = raw_val.  

   IF ix < {1} THEN
       modify = YES.
   ELSE
       modify = NO.

   DO WHILE ix < {1}:
      DO jx = 1 to num:
         byte = INTEGER(ilin[jx + 1]).
         PUTBYTE(raw_val, ix + jx) = byte.
      END.
      ix = ix + num.
      IF ix < {1} THEN DO:
         IMPORT ilin.
               ipos = ipos + 1.
      END.
   END.

   IF modify THEN
      hField:BUFFER-VALUE(p_index) = raw_val.  
END.

p_Changed = (IF orig_val <> hField:BUFFER-VALUE(p_index) THEN yes ELSE no).

