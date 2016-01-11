/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* c-merge.i - defines for cache list of all files in all databases */

DEFINE {1} SHARED VARIABLE qbf-schema# AS INTEGER    NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-schema% AS CHARACTER  NO-UNDO.

/*
c-merge.p returns:

  qbf-schema.cValue = "filename,dbname,0000description"

but warning!  a-join.p alters the structure of this array to be:

  qbf-schema.cValue = "filename,dbname,###,###,....."

where the ### is a list of pointers into qbf-join.cValue of join records
that contains a reference to that file.

qbf-schema% is a scalar of flags to be appended to filenames ("*" or " ")
*/
