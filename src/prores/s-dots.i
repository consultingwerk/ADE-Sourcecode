/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-dots.i - show elipsis if text too long */

(IF LENGTH({1}) > ({2}) THEN
  SUBSTRING(({1}),1,({2}) - 3) + "..."
 ELSE
  ({1})
)
