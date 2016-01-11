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
/* 
 * Program Name : adeshar/_conthdl.p 
 * Description  : Finds the real hWnd for a VBX control 
 * Author       : gfs
 * Last Modified: 9/6/95
 *
 */
DEFINE INPUT  PARAMETER hVbx    AS HANDLE  NO-UNDO.        /* widget-handle of VBX */
DEFINE OUTPUT PARAMETER vbxhWnd AS INTEGER NO-UNDO INIT ?. /* hWnd of VBX */

DEFINE VARIABLE phWnd AS MEMPTR NO-UNDO. /* pointer to the VBX hWnd */

IF NOT VALID-HANDLE(hVbx) THEN RETURN.   /* Invalid-widget handle passed in */

SET-SIZE(phWnd) = 4. 

RUN CntrGetControlHwnd (INPUT hVbx:hWnd, OUTPUT phWnd).

vbxhWnd = GET-SHORT(phWnd,1).

SET-SIZE(phWnd) = 0. /* free memory */
RETURN.

/* DLL Entry Point*/
PROCEDURE CntrGetControlHwnd EXTERNAL "cntr.dll" ORDINAL 43:
  DEFINE INPUT  PARAMETER hWidget AS SHORT.
  DEFINE OUTPUT PARAMETER pHwnd   AS MEMPTR.
END.
