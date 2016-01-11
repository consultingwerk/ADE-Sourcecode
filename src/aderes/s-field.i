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
/* s-field.i - part of x-field.p and s-field.p */

ASSIGN
  qbf-1 = 
    (IF qbf-toggle1 THEN
       SUBSTRING({*},INDEX({*},"|":u) + 1,-1,"CHARACTER":u)
     ELSE
       ENTRY(2,{*}))

  qbf-2 = ENTRY(1,{*})

  qbf-2 = "(" +
    (IF LENGTH(qbf-1,"CHARACTER":u) > 38 - LENGTH(qbf-2,"CHARACTER":u) THEN
       SUBSTRING(qbf-2,1,MAXIMUM(0,35 - LENGTH(qbf-1,"CHARACTER":u)),
                 "CHARACTER":u) + "...":u
     ELSE
       qbf-2)
     + ")":u

  qbf-1 = 
    (IF LENGTH(qbf-1,"CHARACTER":u) > 41 - LENGTH(qbf-2,"CHARACTER":u) THEN
       SUBSTRING(qbf-1,1,37 - LENGTH(qbf-2,"CHARACTER":u),
                 "CHARACTER":u) + "...":u
     ELSE
       qbf-1)

  OVERLAY(qbf-1,41 - LENGTH(qbf-2,"CHARACTER":u),-1,"CHARACTER":u) = qbf-2.

/*
(IF qbf-toggle1 THEN SUBSTRING({*},INDEX({*},"|") + 1) ELSE ENTRY(2,{*}))
  + FILL(" ",38 -
    (IF LENGTH(ENTRY(1,{*})) + LENGTH((IF qbf-toggle1 THEN SUBSTRING({*},INDEX({*},"|") + 1) ELSE ENTRY(2,{*}))) > 38
      THEN 38 - LENGTH((IF qbf-toggle1 THEN SUBSTRING({*},INDEX({*},"|") + 1) ELSE ENTRY(2,{*})))
      ELSE LENGTH(ENTRY(1,{*}))
    )
    - LENGTH((IF qbf-toggle1 THEN SUBSTRING({*},INDEX({*},"|") + 1) ELSE ENTRY(2,{*})))
  )
  + "(" +
  (IF LENGTH(ENTRY(1,{*})) + LENGTH((IF qbf-toggle1 THEN SUBSTRING({*},INDEX({*},"|") + 1) ELSE ENTRY(2,{*}))) > 38
    THEN SUBSTRING(ENTRY(1,{*}),1,35 - LENGTH((IF qbf-toggle1 THEN SUBSTRING({*},INDEX({*},"|") + 1) ELSE ENTRY(2,{*})))) + "..."
    ELSE ENTRY(1,{*})
  )
  + ")"
*/

/*
ENTRY(2,{*})
  + FILL(" ",38 -
    (IF LENGTH(ENTRY(1,{*})) + LENGTH(ENTRY(2,{*})) > 38
      THEN 38 - LENGTH(ENTRY(2,{*}))
      ELSE LENGTH(ENTRY(1,{*}))
    )
    - LENGTH(ENTRY(2,{*}))
  )
  + "(" +
  (IF LENGTH(ENTRY(1,{*})) + LENGTH(ENTRY(2,{*})) > 38
    THEN SUBSTRING(ENTRY(1,{*}),1,35 - LENGTH(ENTRY(2,{*}))) + "..."
    ELSE ENTRY(1,{*})
  )
  + ")"
*/

/* s-field.i - end of file */

