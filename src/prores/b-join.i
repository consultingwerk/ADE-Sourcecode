/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* b-join.i - defines for b-join*.p */

DEFINE {1} SHARED VARIABLE qbf-f  AS CHARACTER NO-UNDO. /*name*/
DEFINE {1} SHARED VARIABLE qbf-p  AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-t  AS INTEGER   NO-UNDO. /*type*/
DEFINE {1} SHARED VARIABLE qbf-w  AS LOGICAL   NO-UNDO INIT TRUE. /*overflow*/

DEFINE {1} SHARED VARIABLE qbf-x# AS INTEGER   NO-UNDO.

/* b-join.i - end of file */

