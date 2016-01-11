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
* _renfld.p
*
*    Rename calculated field
*/

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-define.i }
{ adecomm/adestds.i }
{ aderes/s-system.i }
{ aderes/reshlp.i   }

&SCOPED-DEFINE FRAME-NAME renamefield

DEFINE INPUT  PARAMETER fld-index AS INTEGER   NO-UNDO. /* qbf-rcn index */
DEFINE INPUT  PARAMETER old-name  AS CHARACTER NO-UNDO. /* old field name */
DEFINE OUTPUT PARAMETER new-name  AS CHARACTER NO-UNDO. /* new field name */
DEFINE OUTPUT PARAMETER lRet      AS LOGICAL   NO-UNDO. /* name changed? */

DEFINE VARIABLE qbf-a    AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE byte     AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c    AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i    AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE lbl-text AS CHARACTER NO-UNDO.

{ aderes/_asbar.i }

FORM
  SKIP(.5)
  lbl-text FORMAT "x(35)":u AT 2
    VIEW-AS TEXT NO-LABEL
  SKIP
 
  new-name FORMAT "x(32)":u AT 2 NO-LABEL {&STDPH_FILL}
    VIEW-AS FILL-IN SIZE 35 BY 1
    
  {adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME {&FRAME-NAME} VIEW-AS DIALOG-BOX KEEP-TAB-ORDER THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee SIDE-LABELS
  TITLE "Rename Field".

/*------------------------------ Triggers ---------------------------------*/

ON GO OF FRAME {&FRAME-NAME} DO:
  /* Translate field name into a native field name which
     is guaranteed not to be currently in use in this query */
  qbf-c = new-name:SCREEN-VALUE.
  
  /* make sure leading character is a letter (A-Z) */
  IF INDEX("ABCDEFGHIJKLMNOPQRSTUVWXYZ":u,
           SUBSTRING(qbf-c,1,1,"CHARACTER":u)) = 0 AND qbf-c <> "" THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
      "A valid field name must start with a letter. Rename aborted.").
    RETURN NO-APPLY.
  END.

  ASSIGN
    qbf-a = FALSE
    qbf-i = 1.
    
  DO WHILE NOT qbf-a:
    byte = SUBSTRING(qbf-c,qbf-i,1,"CHARACTER":u).
    IF LENGTH(byte,"CHARACTER":u) = 0 OR byte = ? THEN LEAVE.
  
    IF INDEX("#$%-_0123456789ETAONRISHDLFCMUGYPWBVKXJQZ":u,byte) <= 0 THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
        SUBSTITUTE("Field name contains at least one invalid character: '&1'. Rename aborted.",byte)).
      SUBSTRING(qbf-c,qbf-i,1,"CHARACTER":u) = "":u.
      RETURN NO-APPLY.
    END.

    qbf-i = qbf-i + 1.
  END.

  /* Is new fieldname a Progress keyword or contain no valid characters? */
  IF KEYWORD-ALL(qbf-c) <> ? OR qbf-c = "" THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
      "Field name is a PROGRESS keyword or contains no valid characters.  Rename aborted.").
    
    RETURN NO-APPLY.
  END.

  /* Does new fieldname begin "qbf-" */
  IF qbf-c <> old-name AND qbf-c BEGINS "qbf-":u THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
      "New field name cannot begin with 'qbf-'.  Rename aborted.").
    
    RETURN NO-APPLY.
  END.

  /* Is new field name a duplicate? check field list */  
  DO qbf-i = 1 TO qbf-rc#:
    IF qbf-c = ENTRY(1,qbf-rcn[qbf-i]) AND qbf-i <> fld-index THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
        "New field name is a duplicate of another field.  Rename aborted.").

      RETURN NO-APPLY.
    END.
  END.

  IF old-name = qbf-c THEN DO:
    /* Did user change case of any letters? */
    DO qbf-i = 1 TO LENGTH(qbf-c,"CHARACTER":u):
      IF ASC(SUBSTRING(TRIM(old-name),qbf-i,1,"CHARACTER":u)) <>
         ASC(SUBSTRING(TRIM(qbf-c),qbf-i,1,"CHARACTER":u)) THEN DO:
         lRet = TRUE.
         LEAVE.
      END.
    END.
  END.
  
  /* Update the current values into the configuration file */
  ASSIGN
    new-name  = qbf-c
    qbf-dirty = TRUE.

  /* Update any qbf-where in which calculated field name was used.  This
     update is prone to error when the old field name somehow matches some
     other text of field name in the WHERE phrase.  What's a person to do? */
  FOR EACH qbf-where:
    qbf-where.qbf-wcls = REPLACE(qbf-where.qbf-wcls,old-name,new-name).
  END.
END.

ON WINDOW-CLOSE OF FRAME {&FRAME-NAME}
  APPLY "END-ERROR":u TO SELF.             

/*---------------------------- Mainline Code ------------------------------*/

ON HELP OF FRAME {&FRAME-NAME} OR CHOOSE OF qbf-help IN FRAME {&FRAME-NAME}
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Rename_Field_Dlg_Box},?).

ASSIGN
  lbl-text              = "&New field name:"
  new-name              = old-name
  new-name:SCREEN-VALUE = old-name
  .

/* Runtime layout for the Sullivan bar */
{adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help}

DISPLAY lbl-text WITH FRAME {&FRAME-NAME}.

ENABLE new-name qbf-ok qbf-ee qbf-help
  WITH FRAME {&FRAME-NAME}.

DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

RETURN.

/* _renfld.p - end of file */

