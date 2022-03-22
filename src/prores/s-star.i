/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-star.i - part of c-star.p */

/*
(IF qbf-toggle1 THEN
  SUBSTRING({*},INDEX({*},",") + 1)
ELSE
  ENTRY(1,{*})
)
*/
/*
SUBSTRING(ENTRY(1,{*}),R-INDEX({*},".") + 1) /*fieldname*/
SUBSTRING(ENTRY(1,{*}),1,R-INDEX({*},".") - 1) /*db.file*/
SUBSTRING({*},INDEX({*},",") + 1) /*label*/
*/

(
  (IF qbf-toggle1 THEN
    SUBSTRING({*},INDEX({*},",") + 1)
  ELSE
    SUBSTRING(ENTRY(1,{*}),R-INDEX({*},".") + 1)
  )
  + FILL(" ",38 - LENGTH(
      (IF qbf-toggle1 THEN
        SUBSTRING({*},INDEX({*},",") + 1)
      ELSE
        SUBSTRING(ENTRY(1,{*}),R-INDEX({*},".") + 1)
      )
      + SUBSTRING(ENTRY(1,{*}),1,R-INDEX({*},".") - 1)
      )
    )
  + "("
  + SUBSTRING(ENTRY(1,{*}),1,R-INDEX({*},".") - 1)
  + ")"
)
