/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
**********************************************************************

  tagextr.i - 
  Progress wrapper procedures for C API of TagExtract HTML parser.

  It is the calling program's responsibility to run PE_FreeProExtract.
-----------------------------------------------------------------------------*/

DEFINE NEW GLOBAL SHARED VARIABLE proExtractDLL AS INTEGER  NO-UNDO.  

&SCOPED-DEFINE TagExtractFileName "tagext32.dll"
&SCOPED-DEFINE PERSISTENT-CDECL PERSISTENT

/* Load call needed for 16-bit only. jep 6/30/96 */
IF OPSYS = "MSDOS":u THEN
DO ON STOP  UNDO, LEAVE 
   ON ERROR UNDO, LEAVE:
  RUN loadLibrary (OUTPUT proExtractDLL, {&TagExtractFileName}).
END.

/*----------------------------------------------------------------------------*/
PROCEDURE freeLibrary EXTERNAL "krnl386.exe":
  DEFINE INPUT PARAMETER handle      AS SHORT.
END PROCEDURE.       

/*----------------------------------------------------------------------------*/
PROCEDURE loadLibrary EXTERNAL "krnl386.exe":
  DEFINE RETURN PARAMETER handle      AS SHORT.
  DEFINE INPUT  PARAMETER libFileName AS CHARACTER.
END PROCEDURE.  

/*----------------------------------------------------------------------------*/
/* PE_freeProExtract - 
 * // Free the dll from memory.
 */
PROCEDURE PE_freeProExtract:
  RUN freeLibrary (proExtractDLL). 
END. 

/*----------------------------------------------------------------------------*/
/* PE_parse - 
 * Parses the given HTML file creating the internal structures to support the 
 * access functions below.  Frees any existing structures from previous calls 
 * to parse. Sets the internal positioning to the first mapable field.
 */
PROCEDURE PE_parse EXTERNAL {&TagExtractFileName} {&PERSISTENT-CDECL}:
  DEFINE INPUT PARAMETER htmlFile AS CHARACTER. /* html filename */
  DEFINE INPUT PARAMETER tagFile  AS CHARACTER. /* tagmap.dat */
  DEFINE INPUT PARAMETER code-Page AS CHARACTER. /* character set code page */
  DEFINE RETURN PARAMETER rslt AS SHORT.
END.

/*----------------------------------------------------------------------------*/
/* PE_gotoFirstMapableField - 
 * Provide iteration access to the information generated in a previous call to 
 * parse.  Determine if there are any mapable fields, and to position to the 
 * first one.  Returns 0 if there are no mapable fields. 
*/
PROCEDURE PE_gotoFirstMapableField EXTERNAL {&TagExtractFileName} {&PERSISTENT-CDECL}:
  DEFINE RETURN PARAMETER rslt AS SHORT. 
END.

/*----------------------------------------------------------------------------*/
/* PE_getNextMapableField - 
 * Iterate through the mapable fields.  Returns 0 if there are no more mapable 
 * fields after this one.
 */
PROCEDURE PE_getNextMapableField EXTERNAL {&TagExtractFileName} {&PERSISTENT-CDECL}:
  DEFINE OUTPUT PARAMETER fieldName AS MEMPTR. 
  DEFINE OUTPUT PARAMETER fieldType AS MEMPTR. 
  DEFINE OUTPUT PARAMETER htmlTag AS MEMPTR. 
  DEFINE OUTPUT PARAMETER htmlType AS MEMPTR. 
  DEFINE OUTPUT PARAMETER startLine AS HANDLE TO LONG. 
  DEFINE OUTPUT PARAMETER startOffset AS HANDLE TO LONG. 
  DEFINE OUTPUT PARAMETER endLine AS HANDLE TO LONG. 
  DEFINE OUTPUT PARAMETER endOffset AS HANDLE TO LONG. 
  DEFINE OUTPUT PARAMETER normalizedText AS MEMPTR. 
  DEFINE RETURN PARAMETER rslt AS SHORT. 
END.

/*----------------------------------------------------------------------------*/
/* PE_getNextMapableFieldNoText - 
 * Same as getNextMapableField except it doesn't have the normalized text parameter.
 */
PROCEDURE PE_getNextMapableFieldNoText EXTERNAL {&TagExtractFileName} {&PERSISTENT-CDECL}:
  DEFINE OUTPUT PARAMETER fieldName AS MEMPTR. 
  DEFINE OUTPUT PARAMETER fieldType AS MEMPTR. 
  DEFINE OUTPUT PARAMETER htmlTag   AS MEMPTR. 
  DEFINE OUTPUT PARAMETER htmlType  AS MEMPTR. 
  DEFINE OUTPUT PARAMETER startLine AS HANDLE TO LONG. 
  DEFINE OUTPUT PARAMETER startOffset AS HANDLE TO LONG. 
  DEFINE OUTPUT PARAMETER endLine AS HANDLE TO LONG. 
  DEFINE OUTPUT PARAMETER endOffset AS HANDLE TO LONG. 
  DEFINE RETURN PARAMETER rslt AS SHORT. 
END.

/*----------------------------------------------------------------------------*/
/* PE_LoadProExtract - 
 * Load the dll into memory
 */
PROCEDURE PE_loadProExtract:
  RUN loadLibrary (OUTPUT proExtractDLL, {&TagExtractFileName}) NO-ERROR. 
END.

/*----------------------------------------------------------------------------*/
PROCEDURE TE_needToMakeOffsets EXTERNAL {&TagExtractFileName} {&PERSISTENT-CDECL}:
  DEFINE INPUT PARAMETER HTMLFileName   AS CHARACTER. 
  DEFINE INPUT PARAMETER OffsetFileName AS CHARACTER. 
  DEFINE RETURN PARAMETER rslt AS SHORT. 
END.
 
/*----------------------------------------------------------------------------*/
/* PE_writeToFile - NOT CURRENTLY USED
 * Writes the information generated in a previous call to parse, to the 
 * specified file.  Each line in the file is a comma seperated list of the 
 * information for one field as follows. If the fiile exists, it will be 
 * overwritten.
 *
 * FieldName,FieldType,StartLine,StartOffset,EndLine,EndOffset,NormalizedText
 */

PROCEDURE PE_writeToFile EXTERNAL {&TagExtractFileName} {&PERSISTENT-CDECL}:
  DEFINE INPUT PARAMETER fileName AS MEMPTR. 
END.

/* tagextr.i - end of file */
