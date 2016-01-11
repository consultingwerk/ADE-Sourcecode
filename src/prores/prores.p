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
/*  prores.p - PROGRESS RESULTS main program */

{ prores/s-system.i NEW }
{ prores/c-form.i   NEW }

/* The main purpose of this program is to scope qbf-join[] and
qbf-form[] to different ICB's from the rest of the arrays so that we
don't exceed maximum record size of 32K. */

DEFINE NEW GLOBAL SHARED VARIABLE microqbf AS LOGICAL NO-UNDO.

ON HELP ANYWHERE RUN prores/s-help.p.

qbf-vers = "1.3E".
/* 1.3C is before translation changes */
/* 1.3D is for translation support */
/* 1.3E is for V7 */

IF OPSYS = "BTOS" THEN 
  qbf-tempdir = "[Scr]<$>_qbf".

RUN prores/s-main.p.

RETURN RETURN-VALUE.
