/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-edit.i - definitions for s-edit.p */

DEFINE {1} SHARED VARIABLE qbf-text# AS INTEGER              NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-text  AS CHARACTER EXTENT {2}. /*UNDO*/
qbf-text# = {2}.
