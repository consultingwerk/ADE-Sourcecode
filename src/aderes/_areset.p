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
* _reset.p
*
*    This module allows the admin to reset the various pieces of the GUI.
*/

&GLOBAL-DEFINE WIN95-BTN YES
&SCOPED-DEFINE FRAME-NAME     areset

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/y-define.i }
{ aderes/_fdefs.i }
{ aderes/s-menu.i }
{ adecomm/adestds.i }
{ aderes/_alayout.i }
{ aderes/reshlp.i }

DEFINE VARIABLE resetMenu  AS LOGICAL NO-UNDO
  VIEW-AS TOGGLE-BOX
  LABEL "Reset &Menu Layout".

DEFINE VARIABLE resetTool  AS LOGICAL NO-UNDO
  VIEW-AS TOGGLE-BOX
  LABEL "Reset &Tool Bar Layout".

DEFINE VARIABLE resetAdmin AS LOGICAL NO-UNDO
  VIEW-AS TOGGLE-BOX
  LABEL "Delete &User Defined Features".

{ aderes/_asbar.i }

/* ************************  Frame Definitions  *********************** */

FORM
  SKIP({&TFM_WID})

  resetMenu AT {&ADM_X_START}
  SKIP({&VM_WID})

  resetTool AT COLUMN-OF resetMenu ROW-OF resetMenu + {&ADM_V_GAP}
  SKIP({&VM_WID})

  resetAdmin AT COLUMN-OF resetMenu ROW-OF resetTool + {&ADM_V_GAP}
  SKIP({&VM_WID})

  { adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME {&FRAME-NAME}
  VIEW-AS DIALOG-BOX NO-LABELS SIDE-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee 
  TITLE "Reset":L.

ON GO OF FRAME {&FRAME-NAME} DO:
  IF    resetMenu:SCREEN-VALUE  = "no":u
    AND resetTool:SCREEN-VALUE  = "no":u
    AND resetAdmin:SCREEN-VALUE = "no":u THEN
  RETURN.

  DEFINE VARIABLE sx      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE allGone AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE qbf-m   AS CHARACTER NO-UNDO INITIAL
      "You have chosen the following to be reset to default values:^".

  /*
  * Try to do everything in an orderly fashion.
  *
  *    1. Reset the menus. We will not delete any Results core or MSS
  *       features. We will call _mset though.
  *
  *    2. Reset the toolbar. The reset function here will only deal with
  *       items on the toolbars.
  *
  *    3. Delete the admin defined features. First, we have to delete any
  *       menus or toolbars that are hanging off an admin defined feature.
  *
  *    4. If all 3 are selected then simply blow away the internal
  *       datastructures as well as the rcode. That will get us back
  *       to the default. Then repopulate the world.
  */

  /* Handle case four first. */

  IF    resetMenu:SCREEN-VALUE  = "yes":u
    AND resetTool:SCREEN-VALUE  = "yes":u
    AND resetAdmin:SCREEN-VALUE = "yes":u THEN DO:
    
    qbf-m = qbf-m + "^Menu Layout^Tool Bar Layout^User Defined Features^^This operation cannot be undone. Do you want to continue?". 

    RUN adecomm/_s-alert.p (INPUT-OUTPUT sx,"warning":u,"yes-no":u,qbf-m).
    IF sx = FALSE THEN RETURN NO-APPLY.

    /*
    * Knowing that everything goes away will change the behavior of
    * individual stuff in each of the 3 cases.
    */
    allGone = TRUE.
  END.
  ELSE DO:
    /*
    * Dump out a single message box. Don't need to annoy the user
    * with mulitple questions.
    */

    IF resetMenu:SCREEN-VALUE  = "yes":u THEN 
      qbf-m = qbf-m + "^Menu Layout".
         
    IF resetTool:SCREEN-VALUE  = "yes":u THEN   
      qbf-m = qbf-m + "^Tool Bar Layout". 
        
    IF resetAdmin:SCREEN-VALUE = "yes":u THEN
      qbf-m = qbf-m + "^User Defined Features". 
           
    qbf-m = qbf-m + "^^This operation cannot be undone. Do you want to continue?". 
         
    RUN adecomm/_s-alert.p (INPUT-OUTPUT sx,"warning":u,"yes-no":u,qbf-m).

    IF sx = FALSE THEN RETURN NO-APPLY.
  END.

  RUN adecomm/_setcurs.p("WAIT":u).

  IF resetMenu:SCREEN-VALUE = "yes":u THEN DO:

    /*
    * Delete all the Results core menu stuff. Don't delete the core
    * features though. No need to.

    * To avoid "animation" of the destruction we'll only delete
    * what is "underneath" the menubar. RESULTS can do this 
    * because the items on the toolbar do not change. This code
    * relies on the menu system feature of not squawking when code
    * tries to define stuff twice. That is important, becuase _mset
    * will try to redefine the menus that go across the menubar. But
    * these will not be deleted by this particular reset.
    *
    * Trying to swap in a whole new toolbar still causes a flash.
    */

    RUN adecomm/_statdsp.p(wGlbStatus, 1, "Resetting Menu Layout...").
    RUN adeshar/_mreset.p({&resId}, FALSE, FALSE, TRUE, TRUE, _menuBar).
    RUN aderes/_mset.p({&resId}, FALSE).
    RUN adeshar/_mcheckm.p({&resId}, OUTPUT sx).
  END.

  IF resetTool:SCREEN-VALUE = "yes":u THEN DO:

    /*
    * Clean out the MSS data structures, rebuild, and then redisplay
    */

    RUN adecomm/_statdsp.p(wGlbStatus, 1, "Resetting Tool Bar...").
    RUN adeshar/_mresett.p({&resId}).

    IF VALID-HANDLE(FRAME fToolbar:HANDLE) THEN
      RUN aderes/_msett.p.

    IF FRAME fToolbar:VISIBLE = TRUE THEN
      ENABLE ALL WITH FRAME fToolbar.
  END.

  IF resetAdmin:SCREEN-VALUE = "yes":u THEN DO:
    DEFINE VARIABLE admin AS LOGICAL INITIAL FALSE.

    /*
    * Canning the admin features is a little more complicated than
    * deleting menu items or toolbar buttons.
    *
    * We have to delete any screen artifact attached to the feature
    * before we delete the feature. There are 4 cases that can be
    * attached: 1) nothing 2) a menu item 3) a submenu and 4) a
    * toolbar button. Case 2&3 are mutually exclusize. While case
    * 4 can coexist with case 2.
    *
    * We'll play with the data structure directly here.
    */

    DEFINE VARIABLE featureList AS CHARACTER NO-UNDO.
    DEFINE VARIABLE fName       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE labl        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE userDefined AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE aText	    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE aLogical    AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE wHandle     AS HANDLE    NO-UNDO.
    DEFINE VARIABLE i           AS INTEGER   NO-UNDO.

    RUN adecomm/_statdsp.p(wGlbStatus, 1, "Deleting User Defined Features...").
    RUN adeshar/_mgetfl.p({&resId}, FALSE, OUTPUT featureList).

    DO i = 1 TO NUM-ENTRIES(featureLIst):
      fName = ENTRY(i, featureList).

      RUN adeshar/_mgetf ({&resId}, fName,
                          OUTPUT aText,
                          OUTPUT aText,
                          OUTPUT aText,
                          OUTPUT aText,
                          OUTPUT aText,
                          OUTPUT aText,
                          OUTPUT aText,
                          OUTPUT aText,
                          OUTPUT aText,
                          OUTPUT userDefined,
                          OUTPUT sx).

      IF userDefined = FALSE THEN NEXT.

      admin = TRUE.

      /* Get the feature's label */
      RUN adeshar/_mgeti2.p ({&resId}, fName,
                             OUTPUT labl,
                             OUTPUT aText,
                             OUTPUT aLogical,
                             OUTPUT wHandle,
                             OUTPUT wHandle,
                             OUTPUT aText,
                             OUTPUT sx).

      /*
      * Try to delete the feature from the menu. _mdeli will
      * do all the work. It returns without doing anything if
      * there was nothing attached to the feature.
      */
      RUN adeshar/_mdeli.p({&resId}, labl, TRUE, OUTPUT sx).

      /*
      * Assume there is a toolbar attached to this feature and
      * delete it. _mdelt.p checks to see if there is a feature,
      * so why not ...
      */
      RUN adeshar/_mdelt.p({&resId}, fName, {&resToolbar}, OUTPUT sx).
      RUN adeshar/_mdelf.p({&resId}, fName, OUTPUT sx).
    END.

    IF admin = TRUE THEN DO:
      /* Finalize the changes to the toolbar and menu.  */

      RUN adeshar/_mupdatm.p({&resId}).
      RUN adeshar/_mupdatt.p({&resId}).

      /*
      * Since we've eliminated all of the admin features we have
      * to "reset" the  Results Core features. One option would be to
      * delete the feature .r file. But, there is performance reasons
      * to have the feature file. Security information is in there.
      * So recompile the admin feature file. It'll only contain
      * Results features.
      */
      _featDirty = TRUE.
      RUN aderes/_afwrite.p (0).
    END.
  END.

  /*
  * All of the internal structures are set. Now generate and
  * recompile the menu/toolbar file.
  */

  IF allGone THEN DO:
    /*
    * Consider the UI "clean at this point, since we are changing
    * back to the default. This has to be done in case the UI was
    * changed previous to this feature being executed.
    */

    ASSIGN
      _adminMenuFile = ""
      _uiDirty       = FALSE
      _configDirty   = TRUE
      .
  END.
  ELSE DO:
    _uiDirty = TRUE.
    RUN aderes/_amwrite.p(0).
  END.

  RUN adecomm/_statdsp.p(wGlbStatus, 1, "").
  RUN adecomm/_setcurs.p("").
END.

/*-------------------------- Main Block -------------------------- */

FRAME {&FRAME-NAME}:HIDDEN = TRUE.

{ aderes/_arest.i 
  &FRAME-NAME = {&FRAME-NAME}
  &HELP-NO    = {&Reset_Relations_Dlg_Box}}

{ adecomm/okrun.i 
  &FRAME = "frame {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help}

ASSIGN
  resetMenu:SENSITIVE         = TRUE
  resetTool:SENSITIVE         = TRUE
  resetAdmin:SENSITIVE        = TRUE
  FRAME {&FRAME-NAME}:HIDDEN  = FALSE
  .

DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

&UNDEFINE FRAME-NAME
 
/* _areset.p - end of file */
