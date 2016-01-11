/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* a-define.i - local definitions for admin modules */

DEFINE {1} SHARED VARIABLE qbf-fastload AS CHARACTER          NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-form-ok  AS LOGICAL            NO-UNDO.

DEFINE {1} SHARED VARIABLE qbf-a-attr   AS CHARACTER EXTENT 4 NO-UNDO.
/*
qbf-a-attr[1]= 'form-file= "customer.f"'
qbf-a-attr[2]= 'form-name= "customer"'
qbf-a-attr[3]= source of form: 'default' 'ft' 'user'
qbf-a-attr[4]= num of lines on form: 'form-lines= 15' (not counting box)
*/

/* module and query permissions */
DEFINE {1} SHARED VARIABLE qbf-m-perm AS CHARACTER EXTENT  6 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-q-perm AS CHARACTER EXTENT 18 NO-UNDO.

/* term info */
DEFINE {1} SHARED VARIABLE qbf-t-name AS CHARACTER
  EXTENT { prores/s-limtrm.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-t-hues AS CHARACTER
  EXTENT { prores/s-limtrm.i } NO-UNDO.
