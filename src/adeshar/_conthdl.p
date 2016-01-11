/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
