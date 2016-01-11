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
/**************************************************************************
    Procedure:  _uniqfil.p
    
    Purpose:    Generates a unique file name to be associated with a buffer.

    Parameters:
                INPUT p_File_Name
                  The filename associated with the buffer.
                INPUT p_Ext
                  The extension for the generated filename.
                OUTPUT p_Unique_FileName
                  The unique filename.

    Description: Generates a unique filename for the temporary file used
                 to compile a procedure.  The filename is of the form
                 pNNNNN_origname.ext, where the various parts are:

                 "p"      - By convention
                 NNNNN    - Five-digit number to ensure uniqueness
                 origname - the original name of the file minus the path and
                            extension
                 ext      - The requested extension (p_Ext)

    Authors: Matt Gilarde
    Date   : 01/06/2003
    Updated: 
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }

DEFINE INPUT PARAMETER p_File_Name AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p_Ext AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_Unique_FileName AS CHAR NO-UNDO.

DEFINE VAR Dummy AS CHAR NO-UNDO.

/* If it is an untitled buffer, remove the colon from the buffer
** name so we don't form an invalid temp file name.
*/
IF SUBSTRING(p_File_Name, 1, LENGTH({&PW_Untitled})) = {&PW_Untitled} THEN
  p_File_Name = REPLACE(p_File_Name, ":", "").

/* Separate the file name into its components, throwing away the path
** component.
*/
RUN adecomm/_osprefx.p ( p_File_Name, OUTPUT Dummy, OUTPUT p_Unique_FileName ).

/* If the file has an extension, drop it. */
IF R-INDEX(p_Unique_FileName, ".") > 0 THEN
  p_Unique_FileName = SUBSTRING(p_Unique_FileName, 1, R-INDEX(p_Unique_FileName, ".") - 1).

/* Generate the unique compiler file name for this buffer. */
RUN adecomm/_tmpfile.p ( "_" + p_Unique_FileName , p_Ext, OUTPUT p_Unique_FileName ).

/* _uniqfil.p - end of file. */
