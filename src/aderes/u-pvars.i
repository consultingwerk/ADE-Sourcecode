/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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

