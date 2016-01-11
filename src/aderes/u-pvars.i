/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* u-pvars.i
*
*    Provides the definitions of the shared variables that
*    programming customers can use.
*
*    These definitions are provided to simplify the life of
*    a Results programmer. Chaning them, however, will have no affect
*    Results.
*/

DEFINE SHARED VARIABLE qbf-vers     AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE qbf-module   AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE qbf-name     AS CHARACTER NO-UNDO.

DEFINE SHARED VARIABLE qbf-rc#      AS INTEGER   NO-UNDO.
DEFINE SHARED VARIABLE qbf-rcn      AS CHARACTER NO-UNDO EXTENT 64.
DEFINE SHARED VARIABLE qbf-rcc      AS CHARACTER NO-UNDO EXTENT 64.
DEFINE SHARED VARIABLE qbf-rcg      AS CHARACTER NO-UNDO EXTENT 64.
DEFINE SHARED VARIABLE qbf-rcl      AS CHARACTER         EXTENT 64.
DEFINE SHARED VARIABLE qbf-rcf      AS CHARACTER         EXTENT 64.
DEFINE SHARED VARIABLE qbf-rcp      AS CHARACTER         EXTENT 64.
DEFINE SHARED VARIABLE qbf-rcw      AS INTEGER   NO-UNDO EXTENT 64.
DEFINE SHARED VARIABLE qbf-rct      AS INTEGER   NO-UNDO EXTENT 64.
DEFINE SHARED VARIABLE qbf-dtype    AS CHARACTER NO-UNDO.

DEFINE SHARED VARIABLE qbf-sortby   AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE qbf-count    AS INTEGER   NO-UNDO.

/* u-pvars.i - end of file */

