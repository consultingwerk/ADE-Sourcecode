/******************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions     *
* contributed by participants of Possenet.                        *
*                                                                 *
******************************************************************/
/*----------------------------------------------------------------------------

File: _vtitems.p

Description:
    Checks if the list-items or list-items pairs are valid.

Input Parameters:
   pcItems: List-items or list-item-pairs to be validated.

   pcItemsType: 'LIST-ITEMS': The items received in pcItems is a delimited list
                              of list-items.

                'LIST-ITEM-PAIRS': The items received in pcItems is a delimited list
                                   of list-item-pairs.

   pcDataType: DataType of the items
   pcDelimiter: Delimiter datatype
                            
Output Parameters:
   <None>

Author: Marcelo Ferrante.

Date Created: Jun 13th, 2006
---------------------------------------------------------------------------- */
DEFINE INPUT  PARAMETER pcItems     AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pcItemsType AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pcDataType  AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pcDelimiter AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cTempFile           AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i      AS INTEGER     NO-UNDO.
DEFINE VARIABLE lError AS LOGICAL     NO-UNDO.

DEFINE STREAM TempStream.

{adecomm/adefext.i}

/* There's no restrictions for list-items or list-item-pairs if  data-type is character */  
IF pcDataType = "Character":U THEN RETURN.

  RUN adecomm/_tmpfile.p
      ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB}, OUTPUT cTempFile).
  
  OUTPUT STREAM tempStream TO VALUE(cTempFile).

  PUT STREAM tempStream UNFORMATTED
    "DEFINE VARIABLE aComboBox AS " + pcDataType SKIP.
  PUT STREAM tempStream UNFORMATTED
    "     VIEW-AS COMBO-BOX " + pcItemsType SKIP "     ".

  IF pcItemsType = "LIST-ITEMS":U THEN 
     PUT STREAM tempStream UNFORMATTED REPLACE(pcItems,CHR(10),",").

  ELSE DO i = 1 TO NUM-ENTRIES(pcItems,CHR(10)):
          PUT STREAM tempStream UNFORMATTED """"  + /* first item of pair (quoted) */
              ENTRY(1,ENTRY(i,pcItems,CHR(10)),pcDelimiter) + '",' +
              /* Quote the second item only if it's a CHAR field */
              (IF pcDataType = "Character":U THEN '"' + 
              ENTRY(2,ENTRY(i,pcItems,CHR(10)),pcDelimiter) + '"'
              ELSE ENTRY(2,ENTRY(i,pcItems,CHR(10)),pcDelimiter)) +
              (IF i < NUM-ENTRIES(pcItems,CHR(10)) THEN ",":U + CHR(10)
              ELSE "").
       END.  /* DO i = 1 to Num-Entries */

  PUT STREAM tempStream UNFORMATTED "." SKIP.
  OUTPUT STREAM tempStream CLOSE.
  COMPILE VALUE(cTempFile) NO-ERROR.
  IF COMPILER:ERROR THEN
     ASSIGN lError = TRUE.

  OS-DELETE VALUE(cTempFile) NO-ERROR.

  IF lError THEN RETURN ERROR.
  ELSE RETURN.
 

