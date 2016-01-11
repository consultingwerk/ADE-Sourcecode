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
/* b-join.i - defines for b-join*.p */

DEFINE {1} SHARED VARIABLE qbf-f  AS CHARACTER NO-UNDO. /*name*/
DEFINE {1} SHARED VARIABLE qbf-p  AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-t  AS INTEGER   NO-UNDO. /*type*/
DEFINE {1} SHARED VARIABLE qbf-w  AS LOGICAL   NO-UNDO INIT TRUE. /*overflow*/

DEFINE {1} SHARED VARIABLE qbf-x# AS INTEGER   NO-UNDO.

/* b-join.i - end of file */

