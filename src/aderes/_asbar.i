/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _asbar.i
 *
 *    Define the Sullivan stuff needed in the admin
 */

DEFINE BUTTON qbf-ok     LABEL "OK":C12     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee     LABEL "Cancel":C12 {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help   LABEL "&Help":C12  {&STDPH_OKBTN}.

/* standard button rectangle */
&IF {&OKBOX} &THEN
  DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.
&ENDIF

/* _asbar.i - end of file */

