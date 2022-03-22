/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-menu.i - definitions for strip menu program */

DEFINE {1} SHARED VARIABLE qbf-m-cmd AS CHARACTER INITIAL "" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-m-col AS INTEGER   EXTENT  21 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-m-dsc AS CHARACTER EXTENT  21 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-m-lim AS INTEGER              NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-m-now AS CHARACTER INITIAL "" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-m-aok AS CHARACTER            NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-m-row AS INTEGER   EXTENT  21 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-m-tbl AS CHARACTER INITIAL "" NO-UNDO.
