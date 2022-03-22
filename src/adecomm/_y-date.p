/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* _y-date.p - enter a date literal */

{ adecomm/y-const.i
  &DefaultFormat="99/99/99"
  &DataType     ="DATE"
  &Message      ="Enter Date Value"
  &Function     ="DATE"
  &InitialValue ="TODAY"
  &PackageOne   ="STRING(MONTH(v_one),'99':u) + '/':u
                 + STRING(DAY(v_one),'99':u) + '/':u
                 + STRING(YEAR(v_one),'9999':u)"
  &PackageTwo   ="STRING(MONTH(v_one),'99':u) + '/':u
                 + STRING(DAY(v_one),'99':u) + '/':u
                 + STRING(YEAR(v_one),'9999':u)
                 + CHR(10)
                 + STRING(MONTH(v_two),'99':u) + '/':u
                 + STRING(DAY(v_two),'99':u) + '/':u
                 + STRING(YEAR(v_two),'9999':u)"
}

RETURN.

/* _y-date.p - end of file */
