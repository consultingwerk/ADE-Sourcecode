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
/* _y-datetime-tz.p - enter a datetime-tz literal */

{ adecomm/y-const.i
  &DefaultFormat="99/99/9999 HH:MM:SS.SSS+HH:MM"
  &DataType     ="DATETIME-TZ"
  &Message      ="Enter DateTime-Tz Value"
  &Function     ="DATETIME-TZ"
  &InitialValue ="NOW"
  &PackageOne   ="'DATETIME-TZ(' + CHR(34) + STRING(v_one,'99/99/9999 HH:MM:SS.SSS+HH:MM':u) + CHR(34) + ')'"
  &PackageTwo   ="'DATETIME-TZ(' + CHR(34) + STRING(v_one,'99/99/9999 HH:MM:SS.SSS+HH:MM':u) + CHR(34) + ')'
                + CHR(10)
                + 'DATETIME-TZ(' + CHR(34) + STRING(v_two,'99/99/9999 HH:MM:SS.SSS+HH:MM':u) + CHR(34) + ')'"
}

RETURN.

/* _y-datetime-tz.p - end of file */
