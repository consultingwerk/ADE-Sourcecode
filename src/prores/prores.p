/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
