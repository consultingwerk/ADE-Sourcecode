/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* row-list.i - 4/15/96 */
&IF "{1}" eq "{&FIRST-EXTERNAL-TABLE}" &THEN       
  IF key-name eq ? THEN tbl-list = "{1}":U.    
&ELSE
  IF tbl-list <> "":U THEN tbl-list = tbl-list + ",":U.
  tbl-list = tbl-list + "{1}":U.
&ENDIF
