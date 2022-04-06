/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* 
 * Filename: vsookver.i 
 * Description:
 *  include file used with sookver.i
 *  Variables used to determine if smart object versions are ok
 * Created: 02/98 SLK
 */
DEFINE VARIABLE obj-handle   AS HANDLE    NO-UNDO. /* object handle */
DEFINE VARIABLE obj-version  AS CHARACTER NO-UNDO. /* smart object version */
/* Variables used to read in header line of smartobject file */
DEFINE STREAM l_P_QS.
DEFINE VARIABLE FileHeader      AS CHARACTER NO-UNDO.
DEFINE VARIABLE file_ext         AS CHARACTER NO-UNDO.
DEFINE VARIABLE numTokens         AS INTEGER NO-UNDO.

DEFINE VARIABLE canDraw AS LOGICAL NO-UNDO.
DEFINE VARIABLE canRun  AS LOGICAL NO-UNDO INIT TRUE.
{adeuib/vundsmar.i}          /* variables used in conjuntion with undsmar.i */

DEFINE VARIABLE admVersion AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
DEFINE VARIABLE lValue AS LOGICAL NO-UNDO.
