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
/*----------------------------------------------------------------------------

File: _dspfunc.p

Description:

Input Parameters:

Output Parameters:      <none>

Author: Greg O'Connor

Created: 08/20/93 - 12:17 pm

-----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/r-define.i }
{ aderes/l-define.i }
{ aderes/e-define.i }
{ aderes/fbdefine.i }
{ aderes/y-define.i }
{ aderes/s-output.i }
{ aderes/s-menu.i   }
{ adecomm/adestds.i }
{ aderes/_fdefs.i }
{ aderes/reshlp.i }

DEFINE VARIABLE lOK AS LOGICAL NO-UNDO.

/*
 * Please note: An object, either a button or a menu item is being passed
 * from the menu system. It CANNOT be assumed that the object is a menuitem!
 * Be careful with the methods/attrs you choose in this function. For example,
 * if you must use the CHECKED attribute then you must first insure that
 * the uiObject is a toggle menu item and not a button.
 *
 * However, for the most part we should be using our datastructures to
 * determine the state of things.
 */
/*--------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER uiObject  AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER featureId AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER appId     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER cFunction AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER cData     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER optHandle AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER prvData   AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-a            AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE lRet             AS LOGICAL   NO-UNDO.
  
RUN VALUE(cFunction) (uiObject,featureId,cData).

RETURN.

/*--------------------------------------------------------------------------*/
PROCEDURE ViewAs:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cIndex   AS CHARACTER NO-UNDO.

  DEFINE VARIABLE iTemp     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE nolabels  AS LOGICAL   NO-UNDO INIT TRUE.
  DEFINE VARIABLE selfield  AS LOGICAL   NO-UNDO INIT TRUE. /* select fields */
  DEFINE VARIABLE tmodule   AS CHARACTER NO-UNDO INIT TRUE.
  DEFINE VARIABLE vname     AS CHARACTER NO-UNDO.
     
  ASSIGN
    tmodule   = qbf-module /* set initial state */
    qbf-index = 1          /* index to qbf-rc array */
    .

  /* Determine if there are any fields selected for chosen view */
  IF (INDEX("brfe":u, cIndex) > 0 AND qbf-rc# > 0) THEN
    selfield = (qbf-field = TRUE). /* table deselected in label view */
  ELSE IF cIndex = "l":u THEN DO:
    DO iTemp = 1 TO EXTENT(qbf-l-text) WHILE selfield:
      selfield = (qbf-l-text[iTemp] = "").
    END.
    IF NOT selfield THEN nolabels = FALSE.
  END.
  ELSE
    selfield = TRUE.

  /* We have no fields - prompt user for course of action */
  IF cIndex > "" AND selfield THEN DO:
    vname = (IF cIndex = "b":u THEN "browse":u ELSE
      IF cIndex = "r":u THEN "report":u ELSE
      IF cIndex = "f":u THEN "form":u   ELSE
      IF cIndex = "l":u THEN "label":u  ELSE
      IF cIndex = "e":u THEN "export":u ELSE "").
    IF cIndex <> "l" THEN
      RUN adecomm/_s-alert.p (INPUT-OUTPUT selfield,"question":u,"yes-no":u,
        SUBSTITUTE("There are no fields chosen for &1 view.  Do you want to select them now?",vname)).

    /* reselect fields */
    IF selfield THEN DO:
  
      ASSIGN
        qbf-module = cIndex.

      RUN aderes/y-field.p (OUTPUT lRet).

      /* revert to old module if user cancels out of field picker */
      IF CAN-DO("ENDKEY,WINDOW-CLOSE":u, LAST-EVENT:FUNCTION) OR 
        (CAN-DO("CHOOSE,WINDOW-CLOSE":u, LAST-EVENT:FUNCTION) AND
          NOT lRet)                                           THEN
        qbf-module = tmodule.
      ELSE
        qbf-redraw = TRUE. 

      /* any label fields and/or text defined */
      DO iTemp = 1 TO EXTENT(qbf-l-text) WHILE nolabels:
        nolabels = (qbf-l-text[iTemp] = "").
      END.

      IF (qbf-rc# = 0 AND nolabels) THEN DO:

        qbf-dirty  = TRUE.
        RUN aderes/i-open.p (?,OUTPUT lRet).
      END.
    END.
  END.

  /* just switch views */
  ELSE DO:

    /* When we switch between browse and form, it remembers rowid. */
    IF CAN-DO("b,f":u,cIndex) AND CAN-DO("b,f":u,qbf-module) THEN
      qbf-use-rowids = YES.

    ASSIGN
      qbf-redraw = TRUE
      qbf-dirty  = TRUE
      qbf-module = cIndex.
  END.

  qbf-field = FALSE.

  IF qbf-module <> tmodule THEN
    APPLY "U1":u TO qbf-widxit.
    /*RUN main_loop IN wGlbMainLoop.*/
END PROCEDURE. /* ViewAs */

/*--------------------------------------------------------------------------*/
PROCEDURE RunHelp:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.

  CASE cArgs:
    WHEN "topics":u THEN
      RUN adecomm/_adehelp.p ("res":u,"TOPICS":u,?,?).
    WHEN "contents":u THEN
      RUN adecomm/_adehelp.p ("res":u,"CONTENTS":u,?,?).
    WHEN "search":u THEN
      RUN adecomm/_adehelp.p ("res":u,"PARTIAL-KEY":u,?,"").
    WHEN "howto":u THEN
      RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&How_To}, ?).
    WHEN "messages":u THEN
      RUN prohelp/_msgs.p.
    WHEN "recentmsgs":u THEN
      RUN prohelp/_rcntmsg.p.
    WHEN "aboutres":u THEN
      RUN adecomm/_about.p ("RESULTS":u, _minLogo).
    OTHERWISE
      RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,
                              {&PROGRESS_RESULTS_Window}, ?).
  END CASE.
END.

/*--------------------------------------------------------------------------*/
PROCEDURE RunHook:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE iTemp AS INTEGER NO-UNDO.

  iTemp = INTEGER(ENTRY(2,cArgs)).
  IF qbf-u-hook[iTemp] <> ? THEN 
    RUN VALUE(qbf-u-hook[iTemp]).
END.

/*--------------------------------------------------------------------------*/
PROCEDURE ToolView:
  /* Turn the toolbar or status bar on/off */
  
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE ix AS INTEGER NO-UNDO.
  
  CASE cArgs:
    WHEN "t":u THEN DO:
      lGlbToolBar = NOT lGlbToolBar.
      /* Modify the frame row in temp-table to take toolbar
         existence or non-existence into account */
      FOR EACH qbf-frame:
        DO ix = 1 to 2: /* 1 for form, 2 for browse */
          IF qbf-frame.qbf-frow[ix] > 0 THEN
            IF lGlbToolBar THEN /* just turned toolbar on */
              qbf-frame.qbf-frow[ix] = 
                 qbf-frame.qbf-frow[ix] + FRAME fToolbar:HEIGHT.
            ELSE  /* just turned off toolbar */
              qbf-frame.qbf-frow[ix] = 
                 qbf-frame.qbf-frow[ix] - FRAME fToolbar:HEIGHT.
        END.      
      END.
    END.  
    WHEN "s":u THEN 
      lGlbStatus  = NOT lGlbStatus.
    OTHERWISE 
      MESSAGE "y-menu.p:ViewType Error [" cModule "]".
  END.

  qbf-redraw = TRUE.
  APPLY "U1":u TO qbf-widxit.
  /*RUN main_loop IN wGlbMainLoop.*/
END.

/*--------------------------------------------------------------------------*/
PROCEDURE Custom:
  /* custom export view */
  
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cSave           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTmp            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE titleText       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE junk            AS CHARACTER NO-UNDO.

  FIND FIRST qbf-esys.

  CASE cArgs:
    WHEN "b":u THEN
      cTmp = qbf-esys.qbf-lin-beg.
    WHEN "l":u THEN
      cTmp = qbf-esys.qbf-lin-end.
    WHEN "f":u THEN
      cTmp = qbf-esys.qbf-fld-dlm.
    WHEN "s":u THEN
      cTmp = qbf-esys.qbf-fld-sep.
    OTHERWISE
    MESSAGE "y-menu.p:Custom Error [" cModule "]".
  END.

  ASSIGN cSave       = cTmp.

  /*
  * If the uiObject is a menu item then use the label as the title of
  * the dialog box. Otherwise, use the default label of the feature.
  */

  IF uiObject = ? OR uiObject:TYPE <> "MENU-ITEM":u THEN
    RUN adeshar/_mgetf.p ({&resId}, fId,
                          OUTPUT junk,
                          OUTPUT junk,
                          OUTPUT junk,
                          OUTPUT titleText,
                          OUTPUT junk,
                          OUTPUT junk,
                          OUTPUT junk,
                          OUTPUT junk,
                          OUTPUT junk,
                          OUTPUT lOk,
                          OUTPUT lOk).
  ELSE
    titleText = uiObject:LABEL.

  RUN aderes/e-edit.p (RIGHT-TRIM(titleText,".":u),INPUT-OUTPUT cSave).
    
  CASE cArgs:
    WHEN "b":u THEN
      qbf-esys.qbf-lin-beg = cSave.
    WHEN "l":u THEN
      qbf-esys.qbf-lin-end = cSave.
    WHEN "f":u THEN
      qbf-esys.qbf-fld-dlm = cSave.
    WHEN "s":u THEN
      qbf-esys.qbf-fld-sep = cSave.
    OTHERWISE
      MESSAGE "y-menu.p:Custom Error [" cModule "]".
  END.

  qbf-dirty = qbf-dirty OR (cSave <> cTmp).
  
  IF qbf-dirty THEN DO:
    ASSIGN
      qbf-redraw           = (cSave <> cTmp)
      qbf-esys.qbf-type    = "CUSTOM"
      qbf-esys.qbf-desc    = "CUSTOM Export"
      qbf-esys.qbf-program = "e-ascii.p":u.

   APPLY "U1":u TO qbf-widxit.
    /*RUN main_loop IN wGlbMainLoop.*/
  END.
END.

/*--------------------------------------------------------------------------*/
PROCEDURE Headers:
  /* Customer export Output Headers? and Fixed-Width? toggles */
  
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.

  FIND FIRST qbf-esys.

  CASE cArgs:
    WHEN "h":u THEN qbf-esys.qbf-headers = NOT qbf-esys.qbf-headers.
    WHEN "f":u THEN qbf-esys.qbf-fixed   = NOT qbf-esys.qbf-fixed.
    OTHERWISE MESSAGE "y-menu.p:Headers Error [" cModule "]".
  END.

  ASSIGN
    qbf-dirty            = TRUE
    qbf-redraw           = TRUE
    qbf-esys.qbf-type    = "CUSTOM"
    qbf-esys.qbf-desc    = "CUSTOM Export"
    qbf-esys.qbf-program = "e-ascii.p":u
    .
    
  APPLY "U1":u TO qbf-widxit.
  /*RUN main_loop IN wGlbMainLoop.*/
END.

/*--------------------------------------------------------------------------*/
PROCEDURE RunLogical:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cProg  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lValue AS LOGICAL   NO-UNDO.

  ASSIGN
    cProg  = ENTRY(1,cArgs)
    lValue = IF (ENTRY(2,cArgs) = "TRUE":u) THEN TRUE ELSE FALSE
    .

  RUN VALUE("aderes/":u + cProg) (lValue,OUTPUT lRet).

  IF qbf-redraw OR lRet THEN 
    APPLY "U1":u TO qbf-widxit.
    /*RUN main_loop IN wGlbMainLoop.*/
END.

/*--------------------------------------------------------------------------*/
PROCEDURE RunLogicalInput:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cProg  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lValue AS LOGICAL   NO-UNDO.

  ASSIGN
    cProg  = ENTRY(1,cArgs)
    lValue = IF (ENTRY(2,cArgs) = "TRUE":u) THEN TRUE ELSE FALSE
    .

  RUN VALUE("aderes/":u + cProg) (lValue).
END.

/*--------------------------------------------------------------------------*/
PROCEDURE RunSingle:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cProg  AS CHARACTER NO-UNDO.

  cProg  = ENTRY(1,cArgs).

  RUN VALUE("aderes/":u + cProg).
END.

/*--------------------------------------------------------------------------*/
PROCEDURE RunTriple:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cProg  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE arg1   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE arg2   AS CHARACTER NO-UNDO.

  ASSIGN
    cProg  = ENTRY(1,cArgs)
    arg1   = ENTRY(2,cArgs)
    arg2   = ENTRY(3,cArgs)
    .

  RUN VALUE("aderes/":u + cProg) (arg1,arg2).
END.

/*--------------------------------------------------------------------------*/
PROCEDURE RunSingleInteger:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cProg  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE theNum AS INTEGER   NO-UNDO.


  ASSIGN
    cProg  = ENTRY(1,cArgs).
    theNum = INTEGER(ENTRY(2,cArgs))
    .

  RUN VALUE("aderes/":u + cProg) (theNum).
END.

/*--------------------------------------------------------------------------*/
PROCEDURE NewPage:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.

  RUN aderes/r-page.p (OUTPUT lRet).

  IF lRet THEN 
    APPLY "U1":u TO qbf-widxit.
    /*RUN main_loop IN wGlbMainLoop.*/
END.

/*--------------------------------------------------------------------------*/
PROCEDURE RunDirty:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cProg           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTemp           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iVal            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE queryIndex      AS INTEGER   NO-UNDO.
     
  cProg  = ENTRY(1,cArgs).
     
  IF NUM-ENTRIES(cArgs) > 1 THEN DO:

    cTemp = ENTRY(2,cArgs).
 
    IF (cTemp = '?':u) THEN
      RUN VALUE("aderes/":u + cProg) (?,OUTPUT lRet).
    ELSE DO:
      IF cTemp BEGINS "qbf-":u THEN
        cTemp = STRING(qbf-index).
      IF cProg = "i-opnsav.p":u THEN
        RUN VALUE("aderes/":u + cProg) (INTEGER(cTemp),OUTPUT queryIndex, 
                                        OUTPUT lRet).
      ELSE
        RUN VALUE("aderes/":u + cProg) (INTEGER(cTemp),OUTPUT lRet).
    END.
  END.
  ELSE
    RUN VALUE("aderes/":u + cProg) (OUTPUT lRet).
                                   
  IF qbf-redraw OR (lRet AND cProg <> "i-opnsav.p":u) THEN      
    APPLY "U1":u TO qbf-widxit.
    /*RUN main_loop IN wGlbMainLoop.*/
END.

/*--------------------------------------------------------------------------*/
PROCEDURE RunAdmin:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cProg  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTemp  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE loc    AS INTEGER   NO-UNDO.

  ASSIGN
    qbf-redraw = FALSE
    cProg      = ENTRY(1,cArgs)
    loc        = INDEX(cArgs,",":u)
    cTemp      = SUBSTRING(cArgs,loc + 1,-1,"CHARACTER":u)
    .

  /* If there's any problem in running the file then don't blow up. Try
   * to keep Results up! */
  RUN VALUE(cProg) (cTemp,OUTPUT lRet) NO-ERROR.

  IF ERROR-STATUS:ERROR AND ERROR-STATUS:NUM-MESSAGES > 0 THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
      SUBSTITUTE("There is a problem with &1.^^&2",
      cProg,ERROR-STATUS:GET-MESSAGE(1))). 
  ELSE DO:
    ASSIGN 
      qbf-dirty  = qbf-dirty OR lRet 
      qbf-redraw = qbf-dirty.

    IF lRet THEN  
      APPLY "U1":u TO qbf-widxit.
      /*RUN main_loop IN wGlbMainLoop.*/
  END.
END.

/*--------------------------------------------------------------------------*/
/* File->New... (Browse, Report, Form, Label, Export) */
PROCEDURE ChooseModule:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.

  IF cArgs = ? THEN cArgs = "r":u.
   
  RUN aderes/i-open.p (cArgs,OUTPUT lRet).
  
  IF qbf-redraw OR lRet THEN 
    APPLY "U1":u TO qbf-widxit.
    /*RUN main_loop IN wGlbMainLoop.*/
END.

/*--------------------------------------------------------------------------*/
/* Make a new view, but the same type as currently being used */
PROCEDURE NewDupModule:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE module AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE k      AS INTEGER   NO-UNDO.

  /*
  * If this is the first operation then get the view permissions.
  * Doing the work here is to avoid doing the work during startup, and
  * making startup slower.
  */
  IF _viewPermission[1] = ? THEN DO:
    RUN adeshar/_mgetfs.p ({&resId}, {&rfNewReportView},
                           OUTPUT _newViewPermission[1]).
    RUN adeshar/_mgetfs.p ({&resId}, {&rfNewBrowseView},
                           OUTPUT _newViewPermission[2]).
    RUN adeshar/_mgetfs.p ({&resId}, {&rfNewFormView},
                           OUTPUT _newViewPermission[3]).
    RUN adeshar/_mgetfs.p ({&resId}, {&rfNewExportView},
                           OUTPUT _newViewPermission[4]).
    RUN adeshar/_mgetfs.p ({&resId}, {&rfNewLabelView},
                           OUTPUT _newViewPermission[5]).
  END.

  /*
  * If the user has just started up and picked new duplicate, then
  * set to report, if the user has permission to create a report.
  */
  ASSIGN
    module = IF qbf-module = ? THEN "r":u ELSE qbf-module
    k      = LOOKUP(module,"r,b,f,e,l":u).

  IF _newViewPermission[k] <> TRUE THEN DO:

    /*
    * If the user can't use the mode then choose another, using
    * the following order: report, browse, form, export, label.
    * Convert the type old order to the new order
    */
    module = ?.
    DO i = 1 TO EXTENT(_newViewPermission):
      IF i = k THEN NEXT.
      IF _newViewPermission[i] = TRUE THEN DO:
        module = SUBSTRING("rbfel":u,i,1,"CHARACTER":u).
        LEAVE.
      END.
    END.
  END.

  RUN ChooseModule (uiObject,fId,module).
END.

/*--------------------------------------------------------------------------*/
/* File->Open... */
PROCEDURE FileOpen:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cModule  AS CHARACTER NO-UNDO.

  RUN aderes/i-open.p (INPUT "",OUTPUT lRet).
  
  IF qbf-redraw OR lRet THEN 
    APPLY "U1":u TO qbf-widxit.
    /*RUN main_loop IN wGlbMainLoop.*/
END.

/*--------------------------------------------------------------------------*/
/* File->Print->To Printer... */
PROCEDURE PrintToPrinter:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cModule  AS CHARACTER NO-UNDO.

  RUN aderes/y-run.p ("defprint":u,"",FALSE,INTEGER(cModule)).
END.

/*--------------------------------------------------------------------------*/
/* File->Print->To File... */
PROCEDURE PrintToFile:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cModule  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE qbf_f AS CHARACTER NO-UNDO. /* opsys file for output */

  qbf_f = (IF qbf-module = "r":u THEN "report":t8
           ELSE IF qbf-module = "l":u THEN "label":t8
           ELSE IF qbf-module = "e":u THEN "export":t8
           ELSE                            "output":t8) + ".txt":u.
  RUN aderes/y-output.p (INPUT-OUTPUT qbf_f,OUTPUT lRet).
  
  IF lRet THEN 
    RUN aderes/y-run.p ("file":u,qbf_f,qbf-pr-app,0).
END.

/*--------------------------------------------------------------------------*/
/* File->Print Preview */
PROCEDURE PrintPreview:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cModule  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cTmp  AS CHARACTER NO-UNDO.

  cTmp = qbf-module.
  IF CAN-DO("b,f,r":u,qbf-module) THEN 
    qbf-module = "r":u.
  
  RUN aderes/y-run.p ("term":u,"",FALSE,0).
  
  qbf-module = cTmp.
END.

/*--------------------------------------------------------------------------*/
/* File->Print->To Clipboard */
PROCEDURE PrintClip:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cModule  AS CHARACTER NO-UNDO.

  RUN aderes/y-run.p ("clip":u,"CLIPBOARD":u,FALSE,0).
END.

/*--------------------------------------------------------------------------*/
/* File->Exit */
PROCEDURE Exit:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cModule  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hasfields       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE i-loop          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE queryIndex      AS INTEGER   NO-UNDO.

  /* Write out the configuration file. It worries about the dirty bit */
  RUN aderes/_afwrite.p (1). /* write features */
  RUN aderes/_amwrite.p (1). /* write menus, toolbar */
  RUN aderes/_awrite.p (1).  /* write configuration */
  RUN aderes/_afiles.p.      /* write deployment report */
  
  IF qbf-module = ? OR qbf-tables = "" THEN
    qbf-dirty = FALSE.

  IF qbf-dirty THEN DO:
    qbf-a = TRUE.
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"question":u,"yes-no-cancel":u,
      "The current query has changed.  Do you want to save the changes?").

    IF qbf-a THEN DO:
      IF qbf-module = "l":u THEN
      DO i-loop = 1 TO EXTENT(qbf-l-text) WHILE NOT hasfields:
        IF qbf-l-text[i-loop] > "" THEN
          hasfields = TRUE.
      END.
      ELSE IF qbf-rc# > 0 THEN 
        hasfields = TRUE.

      IF hasfields THEN DO:
        RUN aderes/i-opnsav.p (1, OUTPUT queryIndex, OUTPUT lRet).
      
        /* User cancelled save */    
        IF lRet THEN RETURN.
      END.
    END.
    ELSE IF qbf-a = ? THEN RETURN.
  END.
  lExit = ?. /* signal to exit results */

  FOR EACH qbf-wsys:
    RUN aderes/y-page2.p ("c":u,qbf-wsys.qbf-wwin,0).
  END.

  APPLY "U1":u TO qbf-widxit.
END.

/*--------------------------------------------------------------------------*/
/* Field->(...) */
PROCEDURE ipFields:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cArgs    AS CHARACTER NO-UNDO.
  
  RUN aderes/s-calc.p (cArgs,0,OUTPUT lRet).
  
  qbf-dirty = qbf-dirty OR lRet.
  
  IF qbf-redraw OR lRet THEN 
    APPLY "U1":u TO qbf-widxit.
    /*RUN main_loop IN wGlbMainLoop.*/
END PROCEDURE. /* ip_fields */

/*--------------------------------------------------------------------------*/
PROCEDURE NullProgram:
  DEFINE INPUT PARAMETER uiObject AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fId      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cModule  AS CHARACTER NO-UNDO.

  RETURN.
END.

/* _dspfunc.p - end of file */

