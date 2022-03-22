/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* set-attr.i = ADM Broker's set-attribute */ 

ASSIGN adm-tmp-str = {1}:{&ADM-DATA}
       ENTRY({&{2}-INDEX}, adm-tmp-str, "`":U) = {3}
       {1}:{&ADM-DATA} = adm-tmp-str.

/* This is what the above code is trying to accomplish; Progress however
   does not support references to an expression such as ENTRY on the
   left hand side of an assignment statement. 
   ENTRY({&{2}-INDEX}, {1}:{&ADM-DATA}, "`":U) = {3}.
*/

