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
/*------------------------------------------------------------------------

  File: affieldval.i

  Description: Standard write trigger wrapper code

  Purpose: pulled into write triggers

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History:
  (010000)  Task: 33    19/12/1997  Anthony D Swindells
            New include written from scratch

------------------------------------------------------------------------*/

 OR DEFINED(WRITE_TRIGGER) <> 0 &THEN
    &IF DEFINED(WRITE_TRIGGER) &THEN
        ASSIGN lv-value = STRING({&FIELDNAME}).
    &ENDIF
