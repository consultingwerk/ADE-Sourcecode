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
 *
 * File: _getwdir.p
 *
 * Description: Get the windows directory from WINDOWS. This function calls
 *              out to a windows DLL to retrieve the information. The directory
 *              is returned in a Progress character variable.
 *
 * Input Parameters:  <None>
 *
 * Output Parameters: wDir - The directory
 *                    s    - Status returned from the DLL call
 *
 * Author: David Lee
 *
 * Date Created: April 1995
 *
 *----------------------------------------------------------------------------*/

define output parameter wDir as character no-undo.
define output parameter s    as integer   no-undo.

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN"
&THEN

    define variable theList as memptr no-undo.

    set-size(theList) = 4096.
    
    IF OPSYS EQ "WIN32" THEN
      RUN GetWindowsDirectoryA(theList, 4096, OUTPUT s).
    ELSE
      RUN GetWindowsDirectory(theList, 4096, output s). 
    /*
     * Transfer the information into PROGRESS "safe" variable.
     */
     
    wDir = get-string(theList, 1).

    /*
     * Free up the space
     */
    set-size(theList) = 0.

    return.
    
/*
 * The DLL interface definition
 */
/* 32bit version */
PROCEDURE GetWindowsDirectoryA EXTERNAL "KERNEL32.DLL"  :
    DEFINE INPUT  PARAMETER pszBuffer as MEMPTR NO-UNDO.
    DEFINE INPUT  PARAMETER uBufLen   as LONG   NO-UNDO.
    DEFINE RETURN PARAMETER uResult   as LONG   NO-UNDO.    
END.
/* 16bit version */
PROCEDURE GetWindowsDirectory EXTERNAL "KRNL386.EXE"  :
    DEFINE INPUT  PARAMETER pszBuffer as MEMPTR NO-UNDO.
    DEFINE INPUT  PARAMETER uBufLen   as SHORT  NO-UNDO.
    DEFINE RETURN PARAMETER uResult   as SHORT  NO-UNDO.    
END.

&ENDIF
