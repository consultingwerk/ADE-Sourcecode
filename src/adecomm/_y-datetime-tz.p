/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
