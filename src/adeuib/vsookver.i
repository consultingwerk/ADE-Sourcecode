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
