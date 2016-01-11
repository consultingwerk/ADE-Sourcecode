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
* _afeat.p
*
*    Defines the GUI for admin feature definition
*/
&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/_fdefs.i }
{ aderes/s-system.i }
{ aderes/s-menu.i }
{ adecomm/adestds.i }
{ aderes/_alayout.i }
{ adeshar/_mnudefs.i }
{ aderes/reshlp.i }

&SCOPED-DEFINE FRAME-NAME featureDialog

DEFINE VARIABLE ans             AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE args            AS CHARACTER NO-UNDO.
DEFINE VARIABLE aTitle          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cJunk           AS CHARACTER NO-UNDO.
DEFINE VARIABLE featureLabel    AS CHARACTER NO-UNDO LABEL "La&bel".
DEFINE VARIABLE dInsImage       AS CHARACTER NO-UNDO.
DEFINE VARIABLE dLabel          AS CHARACTER NO-UNDO.
DEFINE VARIABLE dUpImage        AS CHARACTER NO-UNDO.
DEFINE VARIABLE featureName     AS CHARACTER NO-UNDO LABEL "&Name".
DEFINE VARIABLE fList           AS CHARACTER NO-UNDO.
DEFINE VARIABLE fTitle          AS CHARACTER NO-UNDO.
DEFINE VARIABLE ftype           AS CHARACTER NO-UNDO.
DEFINE VARIABLE func            AS CHARACTER NO-UNDO.
DEFINE VARIABLE functionArgs    AS CHARACTER NO-UNDO LABEL "Ar&gument".
DEFINE VARIABLE functionName    AS CHARACTER NO-UNDO LABEL "&Program".
DEFINE VARIABLE qbf-w           AS HANDLE    NO-UNDO.
DEFINE VARIABLE im-text         AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i           AS INTEGER   NO-UNDO.
DEFINE VARIABLE microHelp       AS CHARACTER NO-UNDO LABEL "H&elp Line".
DEFINE VARIABLE parentId        AS CHARACTER NO-UNDO.
DEFINE VARIABLE prvData         AS CHARACTER NO-UNDO.
DEFINE VARIABLE userDefined     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-ud          AS LOGICAL   NO-UNDO.

DEFINE BUTTON addBut       LABEL "&Add"
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.
DEFINE BUTTON deleteBut	   LABEL "&Remove"
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.
DEFINE BUTTON clearBut	   LABEL "C&lear"
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.
DEFINE BUTTON getFileBut   LABEL "&Files..."
  SIZE 11 BY {&ADM_H_BUTTON}.

/* Use 35 by 33 to support smaller Windows 95 toolbar images. jep 7/30/97 */
DEFINE BUTTON UpImageBut LABEL ""
  SIZE-PIXELS {&mnuIconSize} BY {&mnuIconSize}.

/*
 * This temp table will combine the information found in RESULTS features
 * as well as the information stored in the menu feature. This is because
 * they share the same name. By doing this, we can still have OK/CANCEL.
 */
DEFINE TEMP-TABLE tempFeature
  FIELD featureId    AS CHARACTER
  FIELD ftype        AS CHARACTER
  FIELD args         AS CHARACTER
  FIELD featureLabel AS CHARACTER
  FIELD microHelp    AS CHARACTER
  FIELD defUpIcon    AS CHARACTER
  FIELD newlyCreated AS LOGICAL
  FIELD deleted      AS LOGICAL
  FIELD dirty        AS LOGICAL
  .
{ aderes/_asbar.i }

ASSIGN
  fTitle  = "Fea&tures:"
  aTitle  = " Attributes:"
  im-text = "Image:"
  .
FORM
  SKIP({&TFM_WID})
  fTitle AT 2 FORMAT "X({&ADM_IC_FLIST})":u NO-LABEL
    VIEW-AS TEXT

  aTitle AT ROW-OF fTitle COLUMN-OF fTitle + 45 NO-LABEL
    VIEW-AS TEXT {&STDPH_SDIV} FORMAT "X(39)":u
  SKIP({&VM_WID})

  fList AT 2 NO-LABEL
    VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
    INNER-LINES {&ADM_IL_FLIST} INNER-CHARS {&ADM_IC_FLIST}

  addBut AT ROW-OF fList + 1 COLUMN-OF fList + {&ADM_H_FLIST_OFF}

  deleteBut AT ROW-OF addBut + {&ADM_V_GAP} COLUMN-OF AddBut

  clearBut AT ROW-OF deleteBut + {&ADM_V_GAP} COLUMN-OF AddBut

  featureName AT ROW-OF fList COLUMN-OF addBut + 21
    VIEW-AS FILL-IN SIZE 29 BY {&ADM_H_BUTTON} FORMAT "X(128)":u

  functionName AT ROW-OF featureName + {&ADM_V_GAP} COLUMN-OF addBut + 21
    VIEW-AS FILL-IN SIZE 17 BY {&ADM_H_BUTTON} FORMAT "X(128)":u

  getFileBut AT ROW-OF functionName COLUMN-OF functionName + 27

  functionArgs AT ROW-OF functionName + {&ADM_V_GAP} COLUMN-OF addBut + 21
    VIEW-AS FILL-IN SIZE 29 BY {&ADM_H_BUTTON} FORMAT "X(128)":u

  featureLabel AT ROW-OF functionArgs + {&ADM_V_GAP} COLUMN-OF addBut + 21
    VIEW-AS FILL-IN SIZE 29 BY {&ADM_H_BUTTON} FORMAT "X(128)":u 

  microHelp AT ROW-OF featureLabel + {&ADM_V_GAP} COLUMN-OF addBut + 21
    VIEW-AS FILL-IN SIZE 29 BY {&ADM_H_BUTTON} FORMAT "X(128)":u

  upImageBut AT ROW-OF microHelp + {&ADM_V_GAP} COLUMN-OF addBut + 23

  im-text AT ROW-OF microHelp + 1.4 COLUMN 1 NO-LABEL
    VIEW-AS TEXT
  SKIP(1)

  { adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help }

  WITH FRAME {&FRAME-NAME} VIEW-AS DIALOG-BOX SIDE-LABELS NO-UNDERLINE 
  KEEP-TAB-ORDER THREE-D DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee 
  SCROLLABLE TITLE "Feature Editor".

ON LEAVE OF functionName IN FRAME {&FRAME-NAME} DO:
  /*
  * Use the leave trigger to edit existing features. The addBut will
  * use the value of this field too, but we're not interested in the
  * "new" feature scenario. If we aren't dealing with an active feature 
  * then go away. This is determined by the current value of the feature
  * selection list. If nothing is selected then we can't update. Finally, 
  * this function assumes that the proper record is already found and is 
  * in scope! The record is found when fList is changed.
  */

  IF fList:SCREEN-VALUE = ? THEN RETURN.
  IF (ENTRY(2, tempFeature.args) <> functionName:SCREEN-VALUE) THEN
    ASSIGN
      tempFeature.args  = "RunAdmin,":u 
                        + functionName:SCREEN-VALUE + ",":u
                        + functionArgs:SCREEN-VALUE
      tempFeature.dirty = TRUE
      _uiDirty          = TRUE
      .
END.

ON LEAVE OF functionArgs IN FRAME {&FRAME-NAME} DO:
  /* If there isn't an existing feature selected we don't want to
   * deal with it
   */
  IF fList:SCREEN-VALUE = ? THEN RETURN.
  IF (ENTRY(3, tempFeature.args) <> functionArgs:SCREEN-VALUE) THEN
    ASSIGN
      tempFeature.args   = "RunAdmin,":u 
                         + functionName:SCREEN-VALUE + ",":u
                         + functionArgs:SCREEN-VALUE
      tempFeature.dirty  = TRUE
      _uiDirty           = TRUE
      .
END.

ON LEAVE OF featureLabel IN FRAME {&FRAME-NAME} DO:
  /* If there isn't an existing feature selected we don't want to
   * deal with it
   */

  IF fList:SCREEN-VALUE = ? THEN RETURN.

  /* Don't do any work unless we have to */
  IF tempFeature.featureLabel <> featureLabel:SCREEN-VALUE THEN
  ASSIGN
    tempFeature.featureLabel = featureLabel:SCREEN-VALUE
    tempFeature.dirty        = TRUE
    _uiDirty                 = TRUE
    .
END.

ON LEAVE OF microHelp IN FRAME {&FRAME-NAME} DO:
  /* If there isn't an existing feature selected we don't want to
   * deal with it
   */
  IF fList:SCREEN-VALUE = ? THEN RETURN.

  /* Don't do any work unless we have to */
  IF tempFeature.microHelp <> microHelp:SCREEN-VALUE THEN
  ASSIGN
    tempFeature.microHelp = microHelp:SCREEN-VALUE
    tempFeature.dirty     = TRUE
    _uiDirty              = TRUE
    .
END.

ON CHOOSE OF addBut DO:
  /* Make sure the featureName is legal */
  IF featureName:SCREEN-VALUE = "" THEN DO: 
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ans,"error":u,"ok":u,
        "You must provide a name for the feature.").
    RETURN NO-APPLY.
  END.

  /* Make sure the functionName is legal */
  IF functionName:SCREEN-VALUE = "" THEN DO: 
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ans,"error":u,"ok":u,
        "You must provide a program for the feature.").
    RETURN NO-APPLY.
  END.

  /*
  * Make sure that the feature is a new one. That is, the last entry in the
  * table for this name has to be deleted. A user can add the same name
  * after the name has been deleted. If we didn't make this check then
  * the user could not readd the feature withou first "OK" out of the
  * interface and coming back in. Also, once the thing is deleted, it is
  * removed from the selection list. So the user thinks the name is available.
  */

  FIND LAST tempFeature
    WHERE tempFeature.featureId = featureName:SCREEN-VALUE NO-ERROR.
  IF AVAILABLE tempFeature AND tempFeature.deleted = FALSE THEN DO:
    MESSAGE tempFeature.featureId "is defined. Select a new name."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

    RUN changeToFeature(tempFeature.featureId).
    RETURN NO-APPLY.
  END.

  /*
   * Take the name of the feature and add it into the temporary list.
   * When the user hits OK the information will be added to the permanent
   * data structures. This indirection allows CANCEL to work.
   */
  CREATE tempFeature.
  ASSIGN
    ans                      = fList:ADD-LAST(featureName:SCREEN-VALUE)
    fList:SCREEN-VALUE       = featureName:SCREEN-VALUE
    tempFeature.featureId    = featureName:SCREEN-VALUE
    tempFeature.ftype        = {&mnuItemType}
    tempFeature.args         = "RunAdmin,":u
                               + functionName:SCREEN-VALUE
                               + ",":u + functionArgs:SCREEN-VALUE
    tempFeature.featureLabel = featureLabel:SCREEN-VALUE
    tempFeature.microHelp    = microHelp:SCREEN-VALUE
    tempFeature.defUpIcon    = (IF dUpImage > " ":u THEN dUpImage ELSE "") 
    tempFeature.dirty        = TRUE
    tempFeature.newlyCreated = TRUE
    tempFeature.deleted      = FALSE
    qbf-ok:SENSITIVE         = TRUE
    .

  RUN figureButtonState.
END.

ON CHOOSE OF upImageBut DO:
  /* If there is no current feature then choosing this button becomes an
   * add operation. Otherwise it is an edit operation.
   */
  IF fList:SCREEN-VALUE = ? THEN
    RUN getImage (INPUT-OUTPUT dUpImage,"up":u,OUTPUT ans).
  ELSE DO:
    dUpImage = tempFeature.defUpIcon.
    RUN getImage (INPUT-OUTPUT dUpImage,"up":u,OUTPUT ans).
    IF tempFeature.defUpIcon = dUpImage THEN RETURN.

    ASSIGN
      tempFeature.defUpIcon = dUpImage
      tempFeature.dirty     = TRUE
      .
  END.
  IF ans THEN 
    ASSIGN _uiDirty = TRUE.
END.

ON ALT-T OF FRAME {&FRAME-NAME}
  APPLY "ENTRY":u TO fList IN FRAME {&FRAME-NAME}.

ON ALT-U OF FRAME {&FRAME-NAME}
  APPLY "CHOOSE":u TO upImageBut IN FRAME {&FRAME-NAME}.

ON VALUE-CHANGED OF fList
  RUN changeToFeature (fList:SCREEN-VALUE).

ON CHOOSE OF clearBut DO:
  /* Erase the values in the feature fill-ins as well as the current
     value of the feature list */
  ASSIGN
    fList:SCREEN-VALUE        = ""
    featureName:SCREEN-VALUE  = ""
    functionName:SCREEN-VALUE = ""
    functionArgs:SCREEN-VALUE = ""
    featureLabel:SCREEN-VALUE = ""
    microHelp:SCREEN-VALUE    = ""
    dUpImage                  = ""
    ans                       = upImageBut:LOAD-IMAGE-UP("")
    qbf-ok:SENSITIVE          = (IF fList:NUM-ITEMS <> 0 THEN 
                                 TRUE ELSE FALSE)
  .

  RUN figureButtonState.
END.

ON CHOOSE OF deleteBut IN FRAME {&FRAME-NAME} DO:
  DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO.

  /*
  * Find the last record with the name. Eventually, we'll want to support
  * the case where the user deletes and then adds using the same name. Since
  * the tempFeature is a delta list of changes, the deleted item will still
  * be in the tempTable.
  */
  FIND LAST tempFeature WHERE tempFeature.featureId = fList:SCREEN-VALUE.

  /*
  * First check to see if this feature has been placed into the menu
  * layout. If it has then tell the user that he's got to go Menu Editor
  * to remove it. The main reason to make the user go to the Menu Editor
  * is 1) consistancy (the user can't add to a menu from this interface) and 2)
  * simplify for the time being. This way we don't have to worry about
  * the case if the admin feature is a submenu.
  */
  RUN adeshar/_mgeti2.p ({&resId}, fList:SCREEN-VALUE,
    OUTPUT dLabel, 
    OUTPUT ftype, 
    OUTPUT userDefined, 
    OUTPUT qbf-w,
    OUTPUT qbf-w, 
    OUTPUT parentId, 
    OUTPUT ans).
     
  IF ans = TRUE THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ans,"information":u,"ok":u,
      SUBSTITUTE("The menu item &1 is assigned to feature &2.  Use the Menu Editor to remove the menu item.",
      dLabel,flist:SCREEN-VALUE)).

    RETURN.
  END.

  RUN adeshar/_mgett2.p({&resId}, fList:SCREEN-VALUE, {&resToolbar},
    OUTPUT cJunk,
    OUTPUT cJunk,
    OUTPUT cJunk,
    OUTPUT cJunk,
    OUTPUT userDefined,
    OUTPUT cJunk,
    OUTPUT qbf-i,
    OUTPUT qbf-i,
    OUTPUT qbf-i,
    OUTPUT qbf-i,
    OUTPUT qbf-w,
    OUTPUT qbf-w,
    OUTPUT ans).

  IF ans = TRUE THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ans,"information":u,"ok":u,
      SUBSTITUTE("There is a Tool Bar button assigned to feature &1.  Use the Tool Bar Editor to remove the button.",
      flist:SCREEN-VALUE)).

    RETURN.
  END.

  /*
  * It is ok to "delete" the item. Update the GUI and flag the change. We don't
  * remove the item from the temp list. The temp table is a list of deltas
  * to the real datastructure. This is the operation to be done on the
  * real feature list. If we deleted the record now, then the corresponding
  * item in the real data structure would not get deleted.
  */
  ASSIGN
    tempFeature.dirty   = TRUE
    tempFeature.deleted = TRUE
    qbf-i               = fList:LOOKUP(fList:SCREEN-VALUE)

    /*
    * If this is the last item, then select the new last item.
    * If there is nothing then select nothing, otherwise choose the
    * next item.
    */
    ans                 = fList:DELETE(fList:SCREEN-VALUE)
    .

  IF qbf-i > fList:NUM-ITEMS THEN
    qbf-i = qbf-i - 1.

  IF qbf-i = 0 THEN
    ASSIGN
      featureName:SCREEN-VALUE  = ""
      functionName:SCREEN-VALUE = ""
      functionArgs:SCREEN-VALUE = ""
      featureLabel:SCREEN-VALUE = ""
      microHelp:SCREEN-VALUE    = ""      
      dUpImage                  = ""
      ans                       = upImageBut:LOAD-IMAGE-UP("")
      qbf-ok:SENSITIVE          = (IF qbf-ud THEN TRUE ELSE FALSE)
    .
  ELSE DO:
    fList:SCREEN-VALUE = fList:ENTRY(qbf-i).
    RUN changeToFeature (fList:SCREEN-VALUE).
  END.

  RUN figureButtonState.
END.

ON GO OF FRAME {&FRAME-NAME} DO:
  RUN adecomm/_setcurs.p ("WAIT":u).
  RUN saveChanges.

  /* update feature icon in toolbar */
  RUN adecomm/_statdsp.p (wGlbStatus, 1, "Updating Tool Bar...":t72).
  RUN adeshar/_mupdatt.p ({&resId}).
  /*RUN _tFinishEdit.*/
  RUN adecomm/_statdsp.p (wGlbStatus, 1, "").

  IF FRAME fToolbar:VISIBLE = TRUE THEN
    ENABLE ALL WITH FRAME fToolbar.
END.

ON CHOOSE OF getFileBut DO:
  DEFINE VARIABLE f-name AS CHARACTER NO-UNDO.

  RUN adecomm/_getfile.p (?, "", "", "Link Procedure to Feature", "OPEN":u,
                          INPUT-OUTPUT f-name, OUTPUT ans).

 IF f-name <> "" THEN DO:
    ASSIGN 
      /* qbf-ok:SENSITIVE          = TRUE */
      functionName:SCREEN-VALUE = f-name.
    APPLY "ENTRY":u TO functionName.
  END.
END.

/*---------------------------- Main Code Block --------------------------*/
FRAME {&FRAME-NAME}:HIDDEN         = TRUE.

/* Manage the watch cursor ourselves */
&UNDEFINE TURN-OFF-CURSOR

DISPLAY fTitle aTitle im-text 
  WITH FRAME {&FRAME-NAME}.

/* run-time layout */
ASSIGN
  fList:WIDTH          = fList:WIDTH - shrink-hor-2
  addBut:COL           = fList:COL + fList:WIDTH + 1
  deleteBut:COL        = addBut:COL
  clearBut:COL         = addBut:COL
  qbf-i                = addBut:COL + addBut:WIDTH + 12

  featureName:WIDTH    = featureName:WIDTH - shrink-hor-2
  featureName:COL      = qbf-i + 1
  qbf-w                = featureName:SIDE-LABEL-HANDLE
  qbf-w:COL            = featureName:COL
  aTitle:WIDTH         = aTitle:WIDTH - shrink-hor-2
  aTitle:COL           = featureName:COL
                         + featureName:WIDTH
                         - aTitle:WIDTH
  
  functionName:WIDTH   = functionName:WIDTH - shrink-hor-2
  functionName:COL     = featureName:COL
  qbf-w                = functionName:SIDE-LABEL-HANDLE
  qbf-w:COL            = featureName:COL
  
  getFileBut:COL       = featureName:COL + featureName:WIDTH
                         - getFileBut:WIDTH

  functionArgs:WIDTH   = featureName:WIDTH
  functionArgs:COL     = featureName:COL
  qbf-w                = functionArgs:SIDE-LABEL-HANDLE
  qbf-w:COL            = featureName:COL
  
  featureLabel:WIDTH   = featureName:WIDTH
  featureLabel:COL     = featureName:COL
  qbf-w                = featureLabel:SIDE-LABEL-HANDLE
  qbf-w:COL            = featureName:COL
  
  microHelp:WIDTH      = featureName:WIDTH
  microHelp:COL        = featureName:COL
  qbf-w                = microHelp:SIDE-LABEL-HANDLE
  qbf-w:COL            = featureName:COL

  upImageBut:COL       = featureName:COL
  im-text:WIDTH-PIXELS =
    FONT-TABLE:GET-TEXT-WIDTH-PIXELS(im-text) + 1
  im-text:X            = featureName:X
    - FONT-TABLE:GET-TEXT-WIDTH-PIXELS(im-text:SCREEN-VALUE) - 5
  FRAME {&FRAME-NAME}:VIRTUAL-WIDTH  = featureName:COL 
                                       + featureName:WIDTH
  .

{ adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help }

{ aderes/_arest.i 
  &FRAME-NAME = {&FRAME-NAME}
  &HELP-NO    = {&Feature_Editing_Dlg_Box} }

RUN initGui.

FRAME {&FRAME-NAME}:HIDDEN = FALSE.

ENABLE fList addBut featureName functionName getFileBut functionArgs
  featureLabel clearBut microHelp upImageBut
  WITH FRAME {&FRAME-NAME}.

RUN adecomm/_setcurs.p ("").

DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

/* ----------------------------------------------------------- */
PROCEDURE initGui:
  DO WITH FRAME {&FRAME-NAME}:
    DEFINE VARIABLE cScrap   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE features AS CHARACTER NO-UNDO.
    DEFINE VARIABLE fName    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE qbf-i    AS INTEGER   NO-UNDO.

    /*
     * Initialize the interface. First, get all of the admin defined
     * features and put them into the temp list.
     */
    RUN adeshar/_mgetfl.p({&resId}, TRUE, OUTPUT features).

    DO qbf-i = 1 TO NUM-ENTRIES(features):
      fName = ENTRY(qbf-i, features).

      /* Get the corresponding information stored in the menu feature */
      RUN adeshar/_mgetf.p({&resId}, fName,
                           OUTPUT ftype,
                           OUTPUT func,
                           OUTPUT args,
                           OUTPUT dLabel,
                           OUTPUT dUpImage,   /* up image */
                           OUTPUT cScrap,     /* down image */
                           OUTPUT cScrap,     /* ins image */
                           OUTPUT microHelp,
                           OUTPUT prvData,
                           OUTPUT userDefined,
                           OUTPUT ans).
                   
      IF userDefined = TRUE THEN DO:
 
        CREATE tempFeature.
        ASSIGN
          ans                      = fList:ADD-LAST(fName)
          tempFeature.featureId    = fName
          tempFeature.ftype        = ftype
          tempFeature.args         = args
          tempFeature.featureLabel = dLabel
          tempFeature.microHelp    = microHelp
          tempFeature.defUpIcon    = (IF dUpImage > " ":u THEN 
                                       dUpImage ELSE "") 
          tempFeature.dirty        = FALSE
          tempFeature.newlyCreated = FALSE
          tempFeature.deleted      = FALSE
          qbf-ud                   = TRUE
          .
      END.
    END.

    /* Take the first item on the list and set the GUI. */
    FIND FIRST tempFeature NO-ERROR.
    IF AVAILABLE tempFeature THEN DO:
      RUN changeToFeature (tempFeature.featureId).
      fList:SCREEN-VALUE = tempFeature.featureId.
    END.
    ELSE
      qbf-ok:SENSITIVE             = FALSE.

    /* Retrieve the "default" icon dir */
    IF _iconPath = "" THEN
      RUN aderes/_aicdir.p (OUTPUT _iconPath).
  END.

  RUN figureButtonState.
END PROCEDURE.

/* ----------------------------------------------------------- */
PROCEDURE changeToFeature:
  DEFINE INPUT PARAMETER newFeature AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    DEFINE VARIABLE qbf-i     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lookAhead AS CHARACTER NO-UNDO. 

    /* Find the record in our temp structure that has all the information. */
    FIND LAST tempFeature WHERE tempFeature.featureId = newFeature NO-ERROR.
    IF NOT AVAILABLE tempFeature THEN RETURN.

    ASSIGN
      featureName:SCREEN-VALUE  = newFeature
      functionName:SCREEN-VALUE = ENTRY(2, tempFeature.args)
      featureLabel:SCREEN-VALUE = tempFeature.featureLabel
      microHelp:SCREEN-VALUE    = tempFeature.microHelp
      ans = upImageBut:LOAD-IMAGE-UP(tempFeature.defUpIcon)
      dUpImage                  = tempFeature.defUpIcon
      qbf-ok:SENSITIVE          = TRUE
      .

    /* There could be many args in the arg list created by the user. */
    ASSIGN
      lookAhead                 = ""
      functionArgs:SCREEN-VALUE = ""
      .

    DO qbf-i = 3 TO NUM-ENTRIES(tempFeature.args):
      ASSIGN
        functionArgs:SCREEN-VALUE = functionArgs:SCREEN-VALUE
                                    + lookAhead
                                    + ENTRY(qbf-i, tempFeature.args)
        lookAhead                 = ",":u
        .
    END.
  END.

  RUN figureButtonState.
END PROCEDURE.

/* ----------------------------------------------------------- */
PROCEDURE figureButtonState:
  DO WITH FRAME {&FRAME-NAME}:
    deleteBut:SENSITIVE = fList:SCREEN-VALUE <> ?.
  END.
END PROCEDURE.

/* ----------------------------------------------------------- */
PROCEDURE saveChanges:
  DEFINE VARIABLE dirty AS LOGICAL NO-UNDO. 

  DO WITH FRAME {&FRAME-NAME}:
    /*
     * Walk through the temp list and see what is in there and what
     * has changed. The new bit tells us to use a different function. The
     * dirty bit says something has changed.
     */
    FOR EACH tempFeature:
      IF tempFeature.dirty = TRUE THEN DO:
        /* If the user created and deleted a feature in the same
           sitting its a noop */
        IF tempFeature.deleted = TRUE 
          AND tempFeature.newlyCreated = TRUE THEN NEXT.

        IF tempFeature.newlyCreated = TRUE THEN DO:
          /* Create an admin defined feature in RESULTS */
          dirty = TRUE.

          /* Create the menu subsystem feature for this feature */
          RUN adeshar/_maddf.p ({&resId}, tempFeature.featureId,
                                tempFeature.ftype,
                                "aderes/_dspfunc.p":u,
                                tempFeature.args,
                                tempFeature.featureLabel,
                                tempFeature.defUpIcon,
                                "",
                                "",
                                tempFeature.microHelp,
                                TRUE,
                                "",
                                "*":u,
                                OUTPUT ans).
        END.
        ELSE IF tempFeature.deleted = TRUE THEN DO:
          /*
          * Delete the admin defined feature. Any menu item
          * has already been removed, so this code only has to
          * delete the feature from the 2 feature lists.
          */
          dirty = TRUE.
          RUN adeshar/_mdelf.p ({&resId}, tempFeature.featureId, OUTPUT ans).
        END.
        ELSE DO:
          dirty = TRUE.
          RUN adeshar/_mupdf.p ({&resId}, tempFeature.featureId,
                                TRUE,
                                "aderes/_dspfunc.p":u,
                                tempFeature.args,
                                tempFeature.featureLabel,
                                tempFeature.defUpIcon,
                                "",
                                "",
                                tempFeature.microHelp,
                                OUTPUT ans).
        END.
      END.
    END.
  END.

  /*
   * Now write out the admin feature definition file and the menu file. These
   * files are used to hang the admin's code off of RESULTS Core. Also
   * update the state of the menu and toolbar. Simply changing the values
   * doesn't get the work commited.
   */
  IF dirty = TRUE THEN DO:
    RUN adeshar/_mupdatm.p ({&resId}).
    _featDirty = TRUE.
    RUN aderes/_afwrite.p (0).
  END.
END PROCEDURE.

/* ----------------------------------------------------------- */
PROCEDURE getImage:
  DEFINE INPUT-OUTPUT PARAMETER newName   AS CHARACTER NO-UNDO.
  DEFINE INPUT        PARAMETER imageType AS CHARACTER NO-UNDO.
  DEFINE OUTPUT       PARAMETER lRet      AS LOGICAL   NO-UNDO.

  DEFINE VARIABLE oldName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE absoluteName AS CHARACTER NO-UNDO.

  &if "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &then
  DEFINE VARIABLE fileFilters AS CHARACTER NO-UNDO INITIAL "*.ico,*.bmp|*.*":u.
  &else
  DEFINE VARIABLE fileFilters AS CHARACTER NO-UNDO INITIAL "*.xbm,*.xpm|*":u.
  &endif

  DO WITH FRAME {&FRAME-NAME}:
    oldName = newName.

    RUN adecomm/_fndfile.p ("Image", "IMAGE":u, fileFilters,
      INPUT-OUTPUT _iconPath, INPUT-OUTPUT newName,
      OUTPUT absoluteName, OUTPUT lRet).

    IF lRet = FALSE OR oldName = newName THEN RETURN.

    CASE imageType:
      WHEN "up":u   THEN ans = upImageBut:LOAD-IMAGE-UP(newName).
    END.
  END.
END PROCEDURE.

&UNDEFINE FRAME-NAME

/* _afeat.p - end of file */

