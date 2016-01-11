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
/* c-cache2.i - used by c-cache.p */

ASSIGN
  qbf-k = LOOKUP(ENTRY({&cursor},qbf-f) + "." + qbf-c{&cursor}._Field-name,
          qbf-o)
  qbf-t = "".
IF qbf-k > 0 THEN
  ASSIGN
    OVERLAY(qbf-u,qbf-k * 5 - 4,4) = STRING(qbf-ctop,"9999")
    qbf-t = ENTRY(qbf-k,qbf-v).

ASSIGN
  qbf-ctop           = qbf-ctop + 1
  lReturn            = getRecord("qbf-cfld":U, qbf-ctop)
  qbf-cfld.cValue    = ENTRY({&cursor},qbf-f) + ","
                     + qbf-c{&cursor}._Field-name
                     + (IF qbf-c{&cursor}._Extent = 0
                       THEN ","
                       ELSE "[" + qbf-t + "]," + STRING(qbf-c{&cursor}._Extent))
                     + ",|"
                     + (IF qbf-c{&cursor}._Label = ?
                       THEN qbf-c{&cursor}._Field-name
                       ELSE qbf-c{&cursor}._Label)
                     + (IF qbf-c{&cursor}._Extent = 0
                       THEN ""
                       ELSE "[" + qbf-t + "]").
