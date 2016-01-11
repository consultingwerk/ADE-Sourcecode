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

File: _closeup.p

Description:
   The procedure to close windows in the uib.p

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1993 

Last modified on 04/06/99 tsm: added support for various Intl Numeric formats
                                (in addition to American and European) by 
                                using session set-numeric-format method to
                                set format back to user's setting
                 03/05/96 by J. Palazzo: Added LIB-MGR support.
                 12/19/96 gfs: ported for use with OCX
----------------------------------------------------------------------------*/
{adeuib/uniwidg.i}             /* Universal Widget TEMP-TABLE definition     */
{adeuib/triggers.i}            /* Trigger TEMP-TABLE definition              */
{adeuib/layout.i}              /* Layout temp-table definitions              */
{adeuib/links.i}               /* Link temp-table                            */
{adeuib/sharvars.i}
{adeuib/uibhlp.i}     	       /* Help pre-processor directives              */

/* Include standard look and feel (using 3D) */
&Scoped-define USE-3D    yes
&GLOBAL-DEFINE WIN95-BTN YES
{ adecomm/adestds.i }

DEFINE BUFFER d_P FOR _P.

DEFINE VARIABLE  dummy     AS LOGICAL                                  NO-UNDO.
DEFINE VARIABLE  i         AS INTEGER            INITIAL 0             NO-UNDO.

DEFINE VAR    context        AS CHAR                                     NO-UNDO.
DEFINE VAR    file_name      AS CHAR                                     NO-UNDO.
DEFINE VAR    ldummy         AS LOGICAL                                  NO-UNDO.
DEFINE VAR    ok2close       AS LOGICAL                                  NO-UNDO.
DEFINE VAR    real_window    AS WIDGET-HANDLE                            NO-UNDO.
DEFINE VAR    save_opt       AS LOGICAL                                  NO-UNDO.
DEFINE VAR    tmp_file       AS CHAR                                     NO-UNDO.
DEFINE VAR    tmp_name       AS CHAR                                     NO-UNDO.
DEFINE VAR    tmp_string     AS CHAR                                     NO-UNDO.
DEFINE VAR    window_count   AS INTEGER           INITIAL 0              NO-UNDO.
DEFINE VAR    win_handle     AS WIDGET-HANDLE                            NO-UNDO.
DEFINE VAR    wndw           AS LOGICAL                                  NO-UNDO.
DEFINE VAR    lib_parent     AS CHARACTER                                NO-UNDO.
DEFINE VAR    askToSave      AS LOGICAL           INITIAL FALSE          NO-UNDO. 
DEFINE BUFFER x_U FOR _U.
                  
DEFINE QUERY  window_list    FOR _U, _P SCROLLING.
DEFINE BROWSE window_list    QUERY window_list DISPLAY
     IF _U._SUBTYPE eq "Design-Window" THEN _U._LABEL ELSE _U._NAME @ _U._NAME
         LABEL "Object":U FORMAT "X(18)" 
     IF _P._SAVE-AS-FILE = ? THEN "Untitled":U ELSE _P._SAVE-AS-FILE @ _P._SAVE-AS-FILE
         LABEL "Filename":U FORMAT "X(65)"
   WITH SIZE 55 BY 10 MULTIPLE NO-COLUMN-SCROLLING.
   
DEFINE FRAME windselect
     SKIP({&TFM_WID})
     "Active Windows:" AT 2
     window_list       AT 2
  WITH VIEW-AS DIALOG-BOX TITLE "Close Windows" NO-LABELS THREE-D KEEP-TAB-ORDER.

{ adecomm/okbar.i &FRAME-NAME = windselect
                  &TOOL = "AB"
                  &CONTEXT = {&Close_Windows_Dlg_Box}
                  }

ASSIGN window_list:NUM-LOCKED-COLUMNS IN FRAME windselect = 1.

/* WINDOW-CLOSE acts like end-error */         
ON WINDOW-CLOSE OF FRAME windselect APPLY "END-ERROR":U TO SELF.

/* Load window_list */ 
OPEN QUERY window_list FOR EACH _U WHERE CAN-DO("WINDOW,DIALOG-BOX",_U._TYPE)
                                         AND _U._STATUS NE "DELETED",
                           EACH _P WHERE _P._u-recid = RECID(_U) BY _U._NAME.


/* If there are no windows, then don't worry about the OK button (and make the
   cancel button the first button). */ 
IF NUM-RESULTS ("window_list") eq 0
THEN DO:
  btn_OK:SENSITIVE = NO.
  UPDATE btn_cancel btn_help window_list WITH FRAME windselect.
END.
ELSE DO:
  /* Select the current window. */
  FIND _U WHERE _U._HANDLE eq _h_win NO-ERROR.
  IF AVAILABLE _U THEN DO:                
    /* Highlight the current window (but don't scroll it to the top of
       the browses viewport. */
    ldummy = window_list:SET-REPOSITIONED-ROW 
               (window_list:DOWN - 1, "CONDITIONAL":U).  
    REPOSITION window_list TO RECID (RECID(_U)).    
    ldummy = window_list:SELECT-FOCUSED-ROW ().
  END.
  UPDATE window_list btn_OK btn_cancel btn_help WITH FRAME windselect.
END.

/* Close all selected windows, saving them if necessary */
i = 0.
ZAP-WINDOWS:
REPEAT WHILE i < window_list:NUM-SELECTED-ROWS:
  ASSIGN i          = i + 1
         askToSave  = FALSE
         dummy      = window_list:FETCH-SELECTED-ROW(i)
         win_handle = _U._HANDLE
         wndw       = _U._TYPE eq "WINDOW"
         tmp_name   = IF wndw AND _U._SUBTYPE eq "Design-Window" 
                      THEN _U._LABEL
                      ELSE _U._NAME.
                      

  IF NOT _P._FILE-SAVED THEN askToSave = true.
  ELSE IF OPSYS = "WIN32":u THEN
  DO: /* OCX Dirty control check */
    RUN is_control_dirty in _H_UIB (win_handle, output askToSave).
  END.
  
  IF askToSave THEN DO:
    /* This save question should be the same as the one in uibmproe.i? */
    /* Set default responce to "YES - Save changes! "                  */
    save_opt = yes.
    MESSAGE (IF _P._SAVE-AS-FILE <> ? 
               THEN tmp_name + " (" + _P._SAVE-AS-FILE  + ") " 
               ELSE tmp_name ) SKIP
              "This" (IF wndw THEN "window" ELSE "dialog-box")
              "has changes which have not been saved." SKIP(1)
              "Save changes before closing?"
          VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL UPDATE save_opt.
    IF save_opt THEN DO:
      ASSIGN _h_win     = win_handle
             _save_file = _P._SAVE-AS-FILE.
      IF _save_file = ?  THEN DO:
         _save_file = IF LENGTH(_U._NAME, "RAW":U) < 9 OR OPSYS <> "WIN32":u
                      THEN lc(_U._NAME) + ".w" 
                      ELSE lc(SUBSTRING(_U._NAME,1,8,"FIXED":U)) + ".w".
        RUN adeuib/_sel_fn.p ("Save As",_save_file).
      END.
      IF _save_file NE ? THEN DO:   /* user may have canceled */

       /*
        * Now check to see if the file that the user selected is already in
        * the list of active windows. If it is, then let the user know there
        * is a conflict. It is up to the user to get everything figured
        * out. We check to see if there are 2 records with the same name.
        * If there are 0 or 1 the FIND NEXT will fail.
        */
       FIND d_P WHERE d_P._SAVE-AS-FILE = _save_file  AND
                      RECID(d_P) <> RECID(_P) NO-ERROR.
       IF AVAILABLE d_P 
       THEN DO:
         MESSAGE
           "Another window uses" _save_file "to save into." SKIP
           "Either close that window or choose another filename" SKIP
           "for this window. The 'Save As...' operation has been cancelled."
           VIEW-AS ALERT-BOX WARNING BUTTONS OK.
         ASSIGN _save_file = ?.
         NEXT ZAP-WINDOWS.
       END.

       /*
        * Now check to see if the file to save is writable. If not, tell the
        * user and abort the save.
        *
        * Note: Message used here is the same as the Procedure Editor, Procedure
        * Windows, and UIB (uibmproe.i PROCEDURE save-window) use.
        */
        ASSIGN FILE-INFO:FILE-NAME = _save_file.
        IF (FILE-INFO:FULL-PATHNAME <> ?) AND
           (INDEX(FILE-INFO:FILE-TYPE, "W":U) = 0)
        THEN DO:
           DO ON STOP   UNDO, LEAVE
              ON ENDKEY UNDO, LEAVE
              ON ERROR  UNDO, LEAVE:
               MESSAGE _save_file SKIP
               "Cannot save to this file."  SKIP(1)
               "File is read-only or the path specified" SKIP
               "is invalid. Use a different filename."
               VIEW-AS ALERT-BOX WARNING BUTTONS OK IN WINDOW ACTIVE-WINDOW.
           END.
           ASSIGN _save_file = ?.
           NEXT ZAP-WINDOWS.
        END.

        RUN adecomm/_setcurs.p ("WAIT":U).
        RUN adeshar/_gen4gl.p ("SAVE":U).
        SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
        IF NOT (RETURN-VALUE BEGINS "Error":U) THEN DO:

          ASSIGN _P._FILE-SAVED = TRUE. /* going to be deleted anyways */
        END.
        ELSE
          NEXT.
        
        RUN adecomm/_setcurs.p ("").    /* Make sure we restore the cursor */
      END.  
    END. /* save option is true */
    ELSE IF save_opt = ? THEN NEXT ZAP-WINDOWS.
  END. /* window not saved */

  /* Check with source code control programs and see if we really should close
     the file.  [Save the context and file name so that we can report the
     event after the file has closed and _U is no longer valid.] */
  ASSIGN context   = STRING(RECID(_U))
         file_name = _P._SAVE-AS-FILE
         lib_parent = STRING( _U._WINDOW-HANDLE).
  RUN adecomm/_adeevnt.p 
        (INPUT "UIB", "Before-Close", context, file_name,
         OUTPUT ok2close).
         
  IF ok2close THEN DO:
    /* Hide the window to prevent flashing */
    If wndw THEN real_window = win_handle.
    ELSE real_window = win_handle:PARENT.
    real_window:HIDDEN = TRUE.
    
    /* Delete the window itself. [This will recursively TRASH contained
       frames and SmartObjects.] */
    RUN adeuib/_delet_u.p (INPUT RECID(_U), INPUT TRUE /* Trash */ ).
      
     
    /* Delete the Procedure record as well */
    {adeuib/delete_p.i} 
      
    /* Note the CLOSE as being finished */
    RUN adecomm/_adeevnt.p 
          (INPUT "UIB", "Close", context, file_name, 
           OUTPUT save_opt).
    
    /* Tell the ADE LIB-MGR Object that this UIB object is closing. */
    IF VALID-HANDLE( _h_mlmgr ) THEN
        RUN close-parent IN _h_mlmgr ( INPUT lib_parent ).

  END. /* IF ok2close */              
END. /* ZAP-WINDOWS */
