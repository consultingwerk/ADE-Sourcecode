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
* _alabel.p
*
*    Defines the GUI for label selection for the admin. This file
*    has been Sullivanized & SKIP chained.
*/

&GLOBAL-DEFINE WIN95-BTN YES
&SCOPED-DEFINE FRAME-NAME labelDialog

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/t-define.i }
{ adecomm/adestds.i }
{ aderes/_alayout.i }
{ aderes/reshlp.i }

/* Create a temporary list. The real values aren't updated until the user
   hits OK.  */
DEFINE VARIABLE tempList         AS CHARACTER NO-UNDO EXTENT 10.
DEFINE VARIABLE qbf-i            AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l            AS LOGICAL   NO-UNDO. /* scrap */

DEFINE VARIABLE name_entry       AS CHARACTER NO-UNDO.
DEFINE VARIABLE addr_1_entry     AS CHARACTER NO-UNDO.
DEFINE VARIABLE addr_2_entry     AS CHARACTER NO-UNDO.
DEFINE VARIABLE addr_3_entry     AS CHARACTER NO-UNDO.
DEFINE VARIABLE city_entry       AS CHARACTER NO-UNDO.
DEFINE VARIABLE state_entry      AS CHARACTER NO-UNDO.
DEFINE VARIABLE zip_entry        AS CHARACTER NO-UNDO.
DEFINE VARIABLE zip_plus_entry   AS CHARACTER NO-UNDO.
DEFINE VARIABLE city_state_entry AS CHARACTER NO-UNDO.
DEFINE VARIABLE country_entry    AS CHARACTER NO-UNDO.

{ aderes/_asbar.i }

FORM
  SKIP({&TFM_WID})

  "Enter lists for matching field names:" 
    VIEW-AS TEXT SIZE 45 BY .96 AT ROW 1 COL 6

  name_entry AT ROW 2 COLUMN 16 COLON-ALIGNED {&STDPH_FILL}
    FORMAT "X(128)":u LABEL "&Name"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&H_OKBTN} 
    
  addr_1_entry AT ROW-OF name_entry + {&ADM_V_GAP}
    COLUMN 16 COLON-ALIGNED {&STDPH_FILL}
    FORMAT "X(128)":u LABEL "Address &1"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&H_OKBTN}
    
  addr_2_entry AT ROW-OF addr_1_entry + {&ADM_V_GAP}
    COLUMN 16 COLON-ALIGNED {&STDPH_FILL}
    FORMAT "X(128)":u LABEL "Address &2"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&H_OKBTN} 
  
  addr_3_entry AT ROW-OF addr_2_entry + {&ADM_V_GAP}
    COLUMN 16 COLON-ALIGNED {&STDPH_FILL}
    FORMAT "X(128)":u LABEL "Address &3"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&H_OKBTN} 

  city_entry AT ROW-OF addr_3_entry + {&ADM_V_GAP}
    COLUMN 16 COLON-ALIGNED {&STDPH_FILL}
    FORMAT "X(128)":u LABEL "&City"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&H_OKBTN} 
 
  state_entry AT ROW-OF city_entry + {&ADM_V_GAP}
    COLUMN 16 COLON-ALIGNED {&STDPH_FILL}
    FORMAT "X(128)":u LABEL "&State"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&H_OKBTN} 

  zip_entry AT ROW-OF state_entry + {&ADM_V_GAP}
    COLUMN 16 COLON-ALIGNED {&STDPH_FILL}
    FORMAT "X(128)":u LABEL "&Postal Code"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&H_OKBTN} 

  zip_plus_entry AT ROW-OF zip_entry + {&ADM_V_GAP}
    COLUMN 16 COLON-ALIGNED {&STDPH_FILL}
    FORMAT "X(128)":u LABEL "Postal Code+&4"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&H_OKBTN} 

  city_state_entry AT ROW-OF zip_plus_entry + {&ADM_V_GAP}
    COLUMN 16 COLON-ALIGNED {&STDPH_FILL}
    FORMAT "X(128)":u LABEL "City+State+&Zip"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&H_OKBTN} 

  country_entry AT ROW-OF city_state_entry + {&ADM_V_GAP}
    COLUMN 16 COLON-ALIGNED  {&STDPH_FILL}
    FORMAT "X(128)":u LABEL "Co&untry"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&H_OKBTN} 

  SKIP({&VM_WID})
  { adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help }

  WITH FRAME {&FRAME-NAME}
  VIEW-AS DIALOG-BOX SIDE-LABELS KEEP-TAB-ORDER THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee 
  TITLE "Label Field Selection":L.

/*------------------------- Trigger Block ----------------------------- */

ON GO OF FRAME {&FRAME-NAME} DO:
  IF    qbf-l-auto[1] = name_entry:SCREEN-VALUE
    AND qbf-l-auto[2] = addr_1_entry:SCREEN-VALUE
    AND qbf-l-auto[3] = addr_2_entry:SCREEN-VALUE
    AND qbf-l-auto[4] = addr_3_entry:SCREEN-VALUE
    AND qbf-l-auto[5] = city_entry:SCREEN-VALUE
    AND qbf-l-auto[6] = state_entry:SCREEN-VALUE
    AND qbf-l-auto[7] = zip_entry:SCREEN-VALUE
    AND qbf-l-auto[8] = zip_plus_entry:SCREEN-VALUE
    AND qbf-l-auto[9] = city_state_entry:SCREEN-VALUE
    AND qbf-l-auto[10] = country_entry:SCREEN-VALUE THEN RETURN.
    .

  ASSIGN
    qbf-l-auto[1] = name_entry:SCREEN-VALUE
    qbf-l-auto[2] = addr_1_entry:SCREEN-VALUE
    qbf-l-auto[3] = addr_2_entry:SCREEN-VALUE
    qbf-l-auto[4] = addr_3_entry:SCREEN-VALUE
    qbf-l-auto[5] = city_entry:SCREEN-VALUE
    qbf-l-auto[6] = state_entry:SCREEN-VALUE
    qbf-l-auto[7] = zip_entry:SCREEN-VALUE
    qbf-l-auto[8] = zip_plus_entry:SCREEN-VALUE
    qbf-l-auto[9] = city_state_entry:SCREEN-VALUE
    qbf-l-auto[10] = country_entry:SCREEN-VALUE
    .

  _configDirty = TRUE.
  RUN adecomm/_setcurs.p("WAIT":u).
  RUN aderes/_awrite.p (0).
  RUN adecomm/_setcurs.p ("").
END.

ON LEAVE OF name_entry, addr_1_entry, addr_2_entry, addr_3_entry,
  city_entry, state_entry, zip_entry, zip_plus_entry, city_state_entry,
  country_entry IN FRAME {&FRAME-NAME} DO:

  IF LENGTH(SELF:SCREEN-VALUE,"CHARACTER":u) <>
    LENGTH(SELF:SCREEN-VALUE,"RAW":u) THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("Double-byte characters cannot be used for field names.  The &1 field is invalid.",REPLACE(SELF:LABEL IN FRAME {&FRAME-NAME},"~&":u,""))).
    RETURN NO-APPLY.
  END.
END.

ON WINDOW-CLOSE OF FRAME {&FRAME-NAME}
  APPLY "END-ERROR":u TO SELF.

/*------------------------------ Main Code Block ---------------------- */

FRAME {&FRAME-NAME}:HIDDEN = TRUE.

{ aderes/_arest.i 
  &FRAME-NAME = {&FRAME-NAME}
  &HELP-NO    = {&Label_Field_Selection_Dlg_Box} }

{ adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help }

ASSIGN
  name_entry:SCREEN-VALUE       = qbf-l-auto[1]
  addr_1_entry:SCREEN-VALUE     = qbf-l-auto[2]
  addr_2_entry:SCREEN-VALUE     = qbf-l-auto[3]
  addr_3_entry:SCREEN-VALUE     = qbf-l-auto[4]
  city_entry:SCREEN-VALUE       = qbf-l-auto[5]
  state_entry:SCREEN-VALUE      = qbf-l-auto[6]
  zip_entry:SCREEN-VALUE        = qbf-l-auto[7]
  zip_plus_entry:SCREEN-VALUE   = qbf-l-auto[8]
  city_state_entry:SCREEN-VALUE = qbf-l-auto[9]
  country_entry:SCREEN-VALUE    = qbf-l-auto[10]
  .

ENABLE name_entry addr_1_entry addr_2_entry addr_3_entry city_entry
  state_entry zip_entry zip_plus_entry city_state_entry country_entry
  qbf-ok qbf-ee qbf-help 
  WITH FRAME {&FRAME-NAME}.
  
FRAME {&FRAME-NAME}:HIDDEN  = FALSE.

DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

&UNDEFINE FRAME-NAME

/* _alabel.p - end of file */

