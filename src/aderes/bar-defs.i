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
DEFINE BUTTON qbf-ok     LABEL "OK":C12     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee     LABEL "Cancel":C12 {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help   LABEL "&Help":C12  {&STDPH_OKBTN}.

/* standard button rectangle */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.
&ENDIF

/*
 * Add the buttons to the frame. If the frame already exists (as it should)
 * then this define frame statement will add the buttons to the frame.
 */
DEFINE FRAME {&FRAME-NAME}
  {adecomm/okform.i
    &BOX    = "rect_btns"
    &STATUS = "no"
    &OK     = "qbf-ok"
    &CANCEL = "qbf-ee"
    &HELP   = "qbf-help"}.

{adecomm/okrun.i  
   &FRAME = "FRAME {&FRAME-NAME}" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }      

ON HELP OF FRAME {&FRAME-NAME} OR CHOOSE OF qbf-help IN FRAME {&FRAME-NAME}
  RUN adecomm/_adehelp.p ("res":u, "CONTEXT":u, {&HELP-NO}, ?).

ASSIGN
  FRAME {&FRAME-NAME}:DEFAULT-BUTTON = qbf-ok:HANDLE
  qbf-ok:SENSITIVE     IN FRAME {&FRAME-NAME} = TRUE
  qbf-ok:DEFAULT       IN FRAME {&FRAME-NAME} = TRUE
  qbf-ee:SENSITIVE     IN FRAME {&FRAME-NAME} = TRUE
  qbf-help:SENSITIVE   IN FRAME {&FRAME-NAME} = TRUE.

/* bar-defs.i - end of file */
