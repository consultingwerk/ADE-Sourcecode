/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* af/sup/aflocktab.i
   upgrades database lock */

  assign lv-error = no
              lv-errnum = ?
              lv-string = "".

  find current {&table}
  EXCLUSIVE-LOCK NO-ERROR NO-WAIT.

  if not available {&table} then 
        assign lv-error = yes
                    lv-errnum = error-status:get-number(1)
                    lv-string = if locked {&table} then "locked" else "".

  else if current-changed {&table} then 
        assign lv-error = yes
                    lv-string = "changed". 
