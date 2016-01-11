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
/*----------------------------------------------------------------------------

File:   _vbini.p

Description:
    Given a VBX file name and VBX type, return the corresponding OCX ClassID
    and OCX ShortName.
              
    We use the [VBX Conversions32] section from the VB.INI file to find the
    appropriate key=value line and then pass it to PRO.IDE (_h_controls)
    to determine the OCX CLSID and ShortName.
    
    We use the environment variables SYSTEMROOT, WINBOOTDIR, or WINDIR as the
    directory to look for VB.INI, in that order.
    
    Here's a quick view of VB.INI:
        [VBX Conversions32]
        <VBX filename>={typelib GUID}#typelib version#tupelib LCID server path
        etc.

        [VBX Conversions32]
        mh3d200.vbx={CDC34168-F264-11CE-A0DD-00AA0062530E}#1.0#0;mh3d32.ocx
        mh3b200.vbx={AC331D83-EDCE-11CE-9577-0020AF039CA3}#1.0#0;mhbutn32.ocx
        mhgcal.vbx={0A9F72E3-91CE-101B-AFF8-00AA003E1700}#1.0#0;MhCal32.ocx

Input-Output Parameters:
        p_fileClassId   = IN vbx filename, OUT ocxClassID
        p_typeShortName = IN vbx type,     OUT ocxShortName
      
Output Parameters:
        p_status = successful?
        p_errMsg = not successful - error message 

Notes:
      Conversion of Progress VBX controls to OCX Controls maps as follows:

      VBX Type    OCX ShortName
      ----------  -------------
      PSSpin      CSSpin
      PSComboBox  CSComboBox

    Test string from VB.INI:
    mhgcmb.vbx={96A6D86D-FE3D-11CE-A0DD-00AA0062530E}#1.0#0;MhCmbo32.ocx

Author      : SLK
Date Created: Jan. 24, 1996
Modified    : Mar.  6, 1997 J. Palazzo - Added WINDIR to list of vb.ini dirs.
---------------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER p_fileClassId   AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_typeShortName AS CHARACTER  NO-UNDO.
DEFINE OUTPUT       PARAMETER p_status        AS LOGICAL    NO-UNDO.
DEFINE OUTPUT       PARAMETER p_errMsg        AS CHARACTER  NO-UNDO.

{adeuib/sharvars.i}

DEFINE VARIABLE vbiniFileName AS CHARACTER NO-UNDO.
DEFINE VARIABLE vbiniDirName  AS CHARACTER NO-UNDO.
DEFINE VARIABLE vbiniSection  AS CHARACTER NO-UNDO INIT "VBX Conversions32":U.
DEFINE VARIABLE vbiniLine     AS CHARACTER NO-UNDO.
DEFINE VARIABLE vbxPath       AS CHARACTER NO-UNDO.
DEFINE VARIABLE vbxFile       AS CHARACTER NO-UNDO.
DEFINE VARIABLE vbxType       AS CHARACTER NO-UNDO.

/* ------------------------------------------------------------------------*/

/* Determine the Windows system directory. Use it to find VB.INI. */
ASSIGN vbiniDirName = OS-GETENV("SYSTEMROOT").
IF vbiniDirName = ? THEN
  ASSIGN vbiniDirName = OS-GETENV("WINBOOTDIR").
IF vbiniDirName = ? THEN
  ASSIGN vbiniDirName = OS-GETENV("WINDIR").

/* Create full path to VB.INI using dirname and "vb.ini". */
RUN adecomm/_osfmush.p 
        (INPUT vbiniDirName , INPUT "vb.ini", OUTPUT vbiniFileName).
ASSIGN FILE-INFO:FILENAME = vbiniFileName.
IF FILE-INFO:FULL-PATHNAME = ? OR INDEX(FILE-INFO:FILE-TYPE,"R":U) = 0 THEN 
DO:
   ASSIGN
     p_status = FALSE
     p_errMsg = vbiniFileName + " file is not available or readable.".

   RETURN.
END.

/* VB.INI uses the base VBX filename, so drop any paths. */
RUN adecomm/_osprefx.p
  (INPUT p_fileClassId, OUTPUT vbxPath, OUTPUT vbxFile).

/* Set vb.ini as current initialization file. */
LOAD vbiniFileName NO-ERROR.
USE vbiniFileName NO-ERROR.
GET-KEY-VALUE SECTION vbiniSection KEY vbxFile VALUE vbiniLine.

ASSIGN vbiniLine = vbxFile + "=" + vbiniLine.
IF vbiniLine = ? THEN 
DO:
   ASSIGN
     p_status = FALSE
     p_errMsg = vbiniFileName + " Section " + vbiniSection + " not found.".

   USE "" NO-ERROR. /* Reset to startup initialization. */
   RETURN.
END.

/* Convert Progress VBX Types to OCX Counterparts.
      VBX Type    OCX ShortName
      ----------  -------------
      PSSpin      CSSpin
      PSComboBox  CSComboBox
*/
IF CAN-DO("PSSpin,PSComboBox":U, p_typeShortName) THEN
  ASSIGN p_typeShortName = REPLACE(p_typeShortName, "PS":U, "CS":U).

ASSIGN vbxType = p_typeShortName.

ASSIGN p_fileClassId = _h_controls:VBXToOCXClassID( vbiniLine, vbxType ) NO-ERROR.

IF (p_fileClassId = "") OR (ERROR-STATUS:NUM-MESSAGES > 0) 
    OR (p_fileClassId = "~{00000000-0000-0000-0000-000000000000~}")
THEN
DO:
   ASSIGN
     p_status = FALSE
     p_errMsg = "Unable to determine OCX Class ID." + CHR(10) + 
                "_h_controls: " + ERROR-STATUS:GET-MESSAGE(1).
   USE "" NO-ERROR. /* Reset to startup initialization. */
   RETURN.
END.

ASSIGN p_status = TRUE.
USE "" NO-ERROR. /* Reset to startup initialization. */

RETURN.
