/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* _y-datetime.p - enter a datetime literal */

{ adecomm/y-const.i
  &DefaultFormat="99/99/9999 HH:MM:SS.SSS"
  &DataType     ="DATETIME"
  &Message      ="Enter DateTime Value"
  &Function     ="DATETIME"
  &InitialValue ="?"
  &PackageOne   ="'DATETIME(' + CHR(34) + STRING(v_one,'99/99/9999 HH:MM:SS.SSS':u) + CHR(34) + ')'"
  &PackageTwo   ="'DATETIME(' + CHR(34) + STRING(v_one,'99/99/9999 HH:MM:SS.SSS':u) + CHR(34) + ')'
                + CHR(10)
                + 'DATETIME(' + CHR(34) + STRING(v_two,'99/99/9999 HH:MM:SS.SSS':u) + CHR(34) + ')'"
}

RETURN.

/* _y-datetime.p - end of file */
