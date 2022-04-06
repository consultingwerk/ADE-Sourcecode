/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* _y-strng.p - enter a string literal */

{ adecomm/y-const.i
  &DefaultFormat="x(40)"
  &DataType     ="CHARACTER"
  &Message      ="Enter String Value"
  &Function     =" "
  &InitialValue ="''"
  &PackageOne   ="'""':u + REPLACE(v_one,'""':u,'""""':u) + '""':u"
  &PackageTwo   ="'""':u + REPLACE(v_one,'""':u,'""""':u) + '""':u
                 + CHR(10)
                 + '""':u + REPLACE(v_two,'""':u,'""""':u) + '""':u"
}

RETURN.

/* _y-strng.p - end of file */
