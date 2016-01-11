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
* _adeploy.p
*
*    Defines the GUI for the deployment files needed by Results
*/
&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/_fdefs.i }
{ aderes/s-system.i }
{ adecomm/adestds.i }
{ aderes/_alayout.i }
{ aderes/a-define.i }
{ aderes/reshlp.i }

DEFINE VARIABLE dirty    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE baseName AS CHARACTER NO-UNDO.
DEFINE VARIABLE dirName  AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-l    AS LOGICAL   NO-UNDO. /* scrap */

&Scoped-define FRAME-NAME deploymentDialog

DEFINE BUTTON menuFileBut
  LABEL "F&iles...":L
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.

DEFINE BUTTON FeatureFileBut
  LABEL "Fi&les...":L
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.

DEFINE RECTANGLE rect1 EDGE-PIXELS 1 SIZE 28 BY .52.

{ aderes/_asbar.i }

FORM
  SKIP({&TFM_WID})

  rect1 AT ROW 1.3 COLUMN 1
  
  qbf-fastload AT ROW-OF rect1 COLUMN-OF rect1 + 15 COLON-ALIGNED
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&ADM_H_BUTTON}
    FORMAT "X(128)":u {&STDPH_FILL} LABEL "Fastload &Base"

  _adminFeatureFile AT ROW-OF qbf-fastload + {&ADM_V_GAP}
                       COLUMN-OF rect1 + 15 COLON-ALIGNED
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&ADM_H_BUTTON}
    FORMAT "X(128)":u {&STDPH_FILL} LABEL "&Feature File"

  featureFileBut AT ROW-OF _adminFeatureFile
                    COLUMN-OF qbf-fastload + 47

  _adminMenuFile AT ROW-OF _adminFeatureFile + {&ADM_V_GAP}
                    COLUMN-OF rect1 + 15 COLON-ALIGNED
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&ADM_H_BUTTON}
    FORMAT "X(128)":u {&STDPH_FILL} LABEL "&UI File"

  menuFileBut  AT ROW-OF _adminMenuFile
                  COLUMN-OF qbf-fastload + 47
  SKIP({&VM_WID})

  { adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help }

  WITH FRAME {&FRAME-NAME}
  VIEW-AS DIALOG-BOX SIDE-LABELS NO-UNDERLINE THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee 
  TITLE "Deployment":L.

ON LEAVE OF qbf-fastload IN FRAME {&FRAME-NAME} DO:
  /* Trim leading/trailing spaces. These are not valid in a fastload name. */
  ASSIGN qbf-fastload:SCREEN-VALUE = TRIM(qbf-fastload:SCREEN-VALUE).
  
  /* Don't do any work unless we have to */
  IF qbf-fastload:SCREEN-VALUE = qbf-fastload THEN RETURN.

  /* Check to see if the fastload base fits within specifications, i.e.
  *  has at least 1 character, no embedded spaces, and no filename extension.
  *  Basically, it must conform to the rules of a logical database name. */
  RUN adecomm/_osprefx.p (qbf-fastload:SCREEN-VALUE,
                          OUTPUT dirName, OUTPUT baseName).
  IF   LENGTH(baseName,"RAW":u) = 0 
    OR INDEX(baseName, ".") > 0
    OR INDEX(baseName, " ") > 0
  THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("&1 is not correct.  The base portion must have at least 1 character and must not contain embedded spaces or any file extensions.",
      baseName)).
    RETURN NO-APPLY.
  END.

  ASSIGN
    qbf-fastload = qbf-fastload:SCREEN-VALUE
    dirty        = TRUE
    .
END.

ON LEAVE OF _adminFeatureFile IN FRAME {&FRAME-NAME} DO:
  /* Don't do any work unless we have to */
  IF _adminFeatureFile:SCREEN-VALUE = _adminFeatureFile THEN RETURN.

  IF LENGTH(_adminFeatureFile:SCREEN-VALUE,"CHARACTER":u) > 0 THEN DO:
    /* Add the extension if the user doesn't provide one and there is
       something to add to.  */
    RUN adecomm/_osprefx.p (_adminFeatureFile:SCREEN-VALUE,
                            OUTPUT dirName, OUTPUT baseName).

    IF INDEX(baseName,".":u) = 0 THEN
    _adminFeatureFile:SCREEN-VALUE = _adminFeatureFile:SCREEN-VALUE + ".p":u.
  END.

  ASSIGN
    _adminFeatureFile = _adminFeatureFile:SCREEN-VALUE
    dirty             = TRUE

    /*
    * The feature file is dirty only if there is a valid name. If
    * the user has removed the string then the link to the feature
    * file is lost. There is no need to write it out.
    */
    _featDirty        = (_adminFeatureFile <> "")
    .
END.

ON LEAVE OF _adminMenuFile IN FRAME {&FRAME-NAME} DO:
  /* Don't do any work unless we have to */
  IF _adminMenuFile:SCREEN-VALUE = _adminMenuFile THEN RETURN.

  IF LENGTH(_adminMenuFile:SCREEN-VALUE,"CHARACTER":u) > 0 THEN DO:
    /* Add the extension if the user doesn't provide one */
    RUN adecomm/_osprefx.p (_adminMenuFile:SCREEN-VALUE,
                            OUTPUT dirName, OUTPUT baseName).

    IF INDEX(baseName,".":u) = 0 THEN
    _adminMenuFile:SCREEN-VALUE = _adminMenuFile:SCREEN-VALUE + ".p":u.
  END.

  ASSIGN
    _adminMenuFile = _adminMenuFile:SCREEN-VALUE

    /*
    * The UI file is dirty, that is, the UI file will be regenerated
    * as long as there is a name. If the current value is empty then
    * then the user wants to remove the link the UI file. In this
    * compile the config file, but not the UI file.
    */
    dirty          = TRUE
    _uiDirty       = (_adminMenuFile <> "")
    .
END.

ON GO OF FRAME {&FRAME-NAME} DO:
  IF dirty = FALSE THEN RETURN.

  RUN adecomm/_setcurs.p ("WAIT":u).
  _configDirty = TRUE.

  RUN saveChanges.
  RUN adecomm/_setcurs.p("").
END.

ON CHOOSE OF featureFileBut IN FRAME {&FRAME-NAME} DO:
  DEFINE VARIABLE f-name AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ans    AS LOGICAL   NO-UNDO.

  RUN adecomm/_getfile.p (?, "", "", "Name Feature File", "open":u,
                          INPUT-OUTPUT f-name, OUTPUT ans).

  IF f-name <> "" THEN DO:
    _adminFeatureFile:SCREEN-VALUE = f-name.
    APPLY "LEAVE":u TO _adminFeatureFile.
  END.
END.

ON CHOOSE OF menuFileBut IN FRAME {&FRAME-NAME} DO:
  DEFINE VARIABLE f-name AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ans      AS LOGICAL   NO-UNDO.

  RUN adecomm/_getfile.p (?, "", "", "Name GUI File", "OPEN":u,
                          INPUT-OUTPUT f-name, OUTPUT ans).

  IF f-name <> "" THEN DO:
    _adminMenuFile:SCREEN-VALUE = f-name.
    APPLY "LEAVE":u TO _adminMenuFile.
  END.
END.

/*------------------------ Main Code Block ---------------------------- */

FRAME {&FRAME-NAME}:HIDDEN = TRUE.

{ adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help }

{ aderes/_arest.i 
  &FRAME-NAME = {&FRAME-NAME}
  &HELP-NO    = {&Deployment_Dlg_Box} }

ASSIGN
  qbf-fastload:SENSITIVE         = TRUE
  _adminFeatureFile:SENSITIVE    = TRUE
  featureFileBut:SENSITIVE       = TRUE
  _adminMenuFile:SENSITIVE       = TRUE
  menuFileBut:SENSITIVE          = TRUE
  rect1:HIDDEN                   = TRUE
  qbf-fastload:SCREEN-VALUE      = qbf-fastload
  _adminFeatureFile:SCREEN-VALUE = _adminFeatureFile
  _adminMenuFile:SCREEN-VALUE    = _adminMenuFile
  .

RUN initGui.

FRAME {&FRAME-NAME}:HIDDEN = FALSE.

DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

/* ----------------------------------------------------------- */
PROCEDURE initGui :
  DO WITH FRAME {&FRAME-NAME}:
  END.
END PROCEDURE.

/* ----------------------------------------------------------- */
PROCEDURE saveChanges :
  /* Now write out the information into the configuration file(s) */
  RUN aderes/_awrite.p(0).
  RUN aderes/_afwrite.p(0).
  RUN aderes/_amwrite.p(0).
END PROCEDURE.

&UNDEFINE FRAME-NAME

/* _adeploy.p - end of file */

