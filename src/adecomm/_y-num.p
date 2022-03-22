/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* _y-num.p - enter a number literal */

{ adecomm/y-const.i
  &DefaultFormat = "->>>>>>>>9.99"
  &DataType      = "DECIMAL DECIMALS 10"
  &Message       = "Enter Numeric Value"
  &Function      = "DECIMAL"
  &InitialValue  = "0"
  &PackageOne    = "REPLACE(STRING(v_one), ',':u, '.':u)"
  &PackageTwo    = "REPLACE(STRING(v_one), ',':u, '.':u) + CHR(10)
                  + REPLACE(STRING(v_two), ',':u, '.':u)"
}

RETURN.

/* _y-num.p - end of file */
