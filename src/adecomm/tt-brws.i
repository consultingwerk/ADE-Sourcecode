/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* This is the definitions of temp-tables built solely to use in the
   schema pickers to deal with temp-tables in the UIB.
   
   Created: 11/03/96
   Author:  D. Ross Hunter                                         */

DEFINE {1} SHARED TEMP-TABLE _tt-tbl NO-UNDO
       FIELD tt-name AS CHARACTER FORMAT "X(32)"
       FIELD like-db AS CHARACTER
       FIELD like-table AS CHARACTER
       FIELD table-type AS CHARACTER
       INDEX tt-name IS PRIMARY UNIQUE tt-name.
DEFINE {1} SHARED TEMP-TABLE _tt-fld NO-UNDO
       FIELD tt-fld   AS CHARACTER FORMAT "X(32)"
       FIELD tt-recid AS RECID
       INDEX tt-rec-fld IS PRIMARY UNIQUE tt-recid tt-fld.
