/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _convqc.p
 *
 *    Converts the TTY configuration file to GUI
 *
 *    The configuration file is the shared part of the application
 */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i NEW }
{ aderes/s-define.i NEW }
{ aderes/a-define.i NEW }
{ aderes/e-define.i NEW }
{ aderes/l-define.i NEW }
{ aderes/r-define.i NEW }
{ aderes/i-define.i NEW }
{ aderes/j-define.i NEW }
{ aderes/y-define.i NEW }
{ aderes/s-output.i NEW }
{ aderes/t-define.i NEW }
{ aderes/s-menu.i NEW }
{ aderes/fbdefine.i NEW }
{ adeshar/_mnudefs.i NEW }
{ aderes/_fdefs.i }
{ adecomm/adestds.i }
{ aderes/_alayout.i }
{ aderes/reshlp.i }

&SCOPED-DEFINE FRAME-NAME convqc

DEFINE NEW SHARED VARIABLE appDir    AS CHARACTER NO-UNDO. /* QC dir */
DEFINE NEW SHARED VARIABLE appName   AS CHARACTER NO-UNDO. /* QC file */
DEFINE     SHARED VARIABLE initDb    AS LOGICAL   NO-UNDO.
DEFINE NEW SHARED VARIABLE outDir    AS CHARACTER NO-UNDO. /* out dir */
DEFINE NEW SHARED VARIABLE ttyApp    AS CHARACTER NO-UNDO. /* QC path */

DEFINE VARIABLE ldb-1     AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-c     AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i     AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-s     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE writeWhat AS CHARACTER NO-UNDO.

DEFINE BUTTON fileBut LABEL "F&ile..." 
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.

{ aderes/_asbar.i }

FORM
  SKIP({&TFM_WID})

  ttyApp COLON 20 FORMAT "X(128)":u LABEL "&Configuration File" 
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&ADM_H_BUTTON}
    
  fileBut
  SKIP({&VM_WID})
    
  outDir COLON 20 FORMAT "X(128)":u LABEL "&Output Directory"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&ADM_H_BUTTON}
  SKIP({&VM_WID})

  qbf-fastload COLON 20 FORMAT "X(128)":u LABEL "&FastLoad File"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&ADM_H_BUTTON}
  SKIP({&VM_WID})

  _adminFeatureFile COLON 20 FORMAT "X(128)":u LABEL "F&eature File"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&ADM_H_BUTTON}
  SKIP({&VM_WID})

  _adminMenuFile COLON 20 FORMAT "X(128)":u LABEL "&GUI File"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&ADM_H_BUTTON}

  {adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME {&FRAME-NAME} KEEP-TAB-ORDER
  VIEW-AS DIALOG-BOX SIDE-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  .

/*--------------------------- Trigger Block ----------------------------*/

ON GO OF FRAME {&FRAME-NAME} DO:
  ASSIGN
    ttyApp            = ttyApp:SCREEN-VALUE
    outDir            = outDir:SCREEN-VALUE
    qbf-fastload      = qbf-fastload:SCREEN-VALUE

    /* strip '.p' suffix for error-checking */
    _adminFeatureFile = REPLACE(_adminFeatureFile:SCREEN-VALUE,".p":u,"")
    _adminMenuFile    = REPLACE(_adminMenuFile:SCREEN-VALUE,".p":u,"")
    .
    
  IF LENGTH(qbf-fastload,"RAW":u) > 5 THEN DO:
    MESSAGE "The maximum Fastload filename" SKIP "length is 5 characters."
      VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

  IF LENGTH(_adminFeatureFile,"RAW":u) > 8 THEN DO:
    MESSAGE "The maximum Feature filename" SKIP "length is 8 characters."
      VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

  IF LENGTH(_adminMenuFile,"RAW":u) > 8 THEN DO:
    MESSAGE "The maximum GUI filename" SKIP "length is 8 characters."
      VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

  IF (qbf-fastload = _adminFeatureFile AND qbf-fastload > "") OR
     (qbf-fastload = _adminMenuFile AND qbf-fastload > "") OR
     (_adminMenuFile = _adminFeatureFile AND _adminMenuFile > "") THEN DO:
    MESSAGE "The Fastload, Feature, and GUI" SKIP
            "filenames must all be different."
      VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

  /* Does configuration file exist? File may not have extension. */
  IF ttyApp > "" AND
    SUBSTRING(ttyApp,LENGTH(ttyApp,"CHARACTER":u) - 2,-1,
               "CHARACTER":u) <> ".qc":u THEN
    ttyApp = ttyApp + ".qc":u.

  IF SEARCH(ttyApp) = ? THEN DO:
    MESSAGE "The configuration file" ttyApp SKIP 
      "could not be found." SKIP
      VIEW-AS ALERT-BOX ERROR.

    RETURN NO-APPLY.
  END.
  ELSE DO:
    ttyApp = SEARCH(ttyApp).

    /* Strip the .qc off the qcfile name. The name is used as a base for
     * many other things. */
    RUN adecomm/_osprefx.p (ttyApp,OUTPUT appDir,OUTPUT appName).
  END.

  IF outDir > "" THEN DO:
    /* check for valid output directory */
    OS-CREATE-DIR VALUE(outDir).
  
    IF OS-ERROR > 0 THEN DO:
      RUN adecomm/_oserr.p (OUTPUT qbf-c).
      MESSAGE "SYSTEM ERROR #" + STRING(OS-ERROR) + ":":u SKIP
        qbf-c + ".":u SKIP
        "Output directory is invalid."
        VIEW-AS ALERT-BOX ERROR.            
      RETURN NO-APPLY.
    END.

    IF SUBSTRING(outDir,LENGTH(TRIM(outDir),"CHARACTER":u),1,
                 "CHARACTER":u) <> "~/":u 
    AND SUBSTRING(outDir,LENGTH(TRIM(outDir),"CHARACTER":u),1,
                  "CHARACTER":u) <> "~\":u THEN
    outDir = outDir 
           + (IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN":u THEN "~\":u ELSE "~/":u).
  END.

  ASSIGN
    qbf-fastload      = outDir 
                      + (IF qbf-fastload > "" THEN
                          SUBSTRING(qbf-fastload,1,5,"FIXED":u)
                        ELSE
                          SUBSTRING(REPLACE(appName,".qc":u,""),1,5,"FIXED":u))
    qbf-qcfile        = outDir + ldb-1
    qbf-c             = SEARCH(qbf-qcfile + {&qcExt})

    _adminFeatureFile = (IF _adminFeatureFile > "" THEN outDir +
                          SUBSTRING(_adminFeatureFile,1,8,"FIXED":u) + ".p":u
                        ELSE
                          qbf-fastload + "f.p":u)
    _adminMenuFile    = (IF _adminMenuFile > "" THEN outDir + 
                          SUBSTRING(_adminMenuFile,1,8,"FIXED":u) + ".p":u
                        ELSE
                          qbf-fastload + "mt.p":u)
    .

  IF qbf-c <> ? THEN DO:
    MESSAGE CAPS(qbf-c) SKIP 
      "This file already exists." SKIP(1)
      "Replace existing file?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      TITLE "Convert " + appName UPDATE qbf-s.

    IF NOT qbf-s THEN RETURN.
  END.
  
  RUN adecomm/_setcurs.p ("WAIT":u).

  /* Register application and converted application with the menu system. */
  RUN adeshar/_madda.p ({&resId},?,"",OUTPUT qbf-s).

  /* Initialize all of the GUI Results variables that are done at runtime */
  RUN aderes/_asetvar.p.

  /* Create the features/menus needed to add printer features */
  RUN aderes/af-init.p.
  RUN aderes/_mset.p ({&resId}, FALSE).
  RUN aderes/_msett.p.

  /* Moved from below. Don't want to overwrite what's in qc file -dma */
  RUN aderes/s-boot.p. 
  RUN aderesc/_aload.p (OUTPUT qbf-s,OUTPUT writeWhat).

  IF qbf-s = TRUE THEN DO:
    IF ENTRY(2, writeWhat) = "ff":u OR ENTRY(3, writeWhat) = "gf":u THEN
      RUN adeshar/_mupdatm.p ({&resId}).

    /* Write out the feature and menu files regardless, for performance 
     * reasons. */
    RUN aderes/_afwrite.p (2).
    RUN aderes/_amwrite.p (2).

    /* Write out the public query directory file */
    IF ENTRY(4, writeWhat) = "qd7":u THEN
      RUN aderes/i-write.p (?).

    IF ENTRY(1, writeWhat) = "qc7":u THEN 
      /*RUN aderes/s-boot.p. moved above -dma */ 
      RUN aderes/_awrite.p (2).
  END.
  ELSE
    MESSAGE "Conversion has been aborted." VIEW-AS ALERT-BOX ERROR.

  RUN adecomm/_setcurs.p ("").
END.

ON CHOOSE OF fileBut IN FRAME {&FRAME-NAME} DO:
  DEFINE VARIABLE f-name   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lRet     AS LOGICAL   NO-UNDO.

  RUN adecomm/_getfile.p (?,"TTYRESULTS":u,"","RESULTS .qc File","OPEN":u,
                          INPUT-OUTPUT f-name,OUTPUT lRet).

  IF f-name > "" THEN
    ttyApp:SCREEN-VALUE = f-name.
END.

ON WINDOW-CLOSE OF FRAME {&FRAME-NAME}
  APPLY "END-ERROR":u TO FRAME {&FRAME-NAME}.
  
/*----------------------------- Main Block -----------------------------*/
ON HELP OF FRAME {&FRAME-NAME} OR CHOOSE OF qbf-help IN FRAME {&FRAME-NAME}
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,
                          {&Convert_Configuration_Dlg_Box},?).

ASSIGN
  ldb-1                          = LDBNAME(1)
  qbf-fastload:SCREEN-VALUE      = SUBSTRING(ldb-1,1,5,"FIXED":u)
  _adminFeatureFile:SCREEN-VALUE = qbf-fastload:SCREEN-VALUE + "f.p":u
  _adminMenuFile:SCREEN-VALUE    = qbf-fastload:SCREEN-VALUE + "mt.p":u
  .

/* Runtime layout for the sullivan bar */
{adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help}

FRAME {&FRAME-NAME}:TITLE = "Convert Configuration".

ENABLE ttyApp fileBut outDir qbf-fastload _adminFeatureFile _adminMenuFile
  qbf-ok qbf-ee qbf-help
  WITH FRAME {&FRAME-NAME}.

DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

RETURN.

/* _convqc.p - end of file */
