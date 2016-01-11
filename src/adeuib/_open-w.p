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
/*------------------------------------------------------------------------

  File: _open-w.p 

  Description: Open a file into the UIB.

  Input Parameters:
      pFileName: Name of file to Open 
        File may be on WebSpeed agent, in which case pFileName includes the
        full pathname and pTempFile will contain the file's contents locally.
      pTempFile: Name of temp file to Open for remote web files
      pMode : Mode of open
        OPEN:     Open the file as a WINDOW or DIALOG-BOX
        UNTITLED: Open the file as a WINDOW or DIALOG-BOX, but don't
                    use the filename. (Open as UNTITLED).
        IMPORT:   Import into the UIB's current frame or window.
       
  Output Parameters:
     <none>

  Author: Wm.T.Wood

  Created: 11/05/93 -  8:57 am
  Updated: 12/08/97 - support for HTML files
           1/17/98  - support for WebSpeed files (adams)
      tsm  4/07/99  - added support for various Intl Numeric Formats (in
                      addition to American and European) by using session
                      set-numeric-format method to set format back to 
                      user's setting.
      tsm  6/24/99  - when setting _P._broker-url, use the broker url from 
                      the mru fileslist if the file is being opened from it
------------------------------------------------------------------------ */
DEFINE INPUT PARAMETER pFileName AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pTempFile AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pMode     AS CHARACTER NO-UNDO.

/* UIB Shared Variables and Common Definitions */
{adeuib/sharvars.i}
{adeuib/uniwidg.i}

DEFINE VARIABLE cHostName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE hActiveWin      AS HANDLE    NO-UNDO.
DEFINE VARIABLE ldummy          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE returnValue     AS CHARACTER NO-UNDO.
DEFINE VARIABLE sectionID       AS INTEGER   NO-UNDO.
DEFINE VARIABLE sectionText     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cObjectName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectNameFull AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRelName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRelNameFull    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lSetMRU         AS LOGICAL    NO-UNDO.


/* BEFORE-OPEN hook */
IF pMode NE "UNTITLED" AND pMode NE "IMPORT" THEN DO:
  RUN adecomm/_adeevnt.p
    ("UIB":U, "BEFORE-OPEN":U, ?, pFileName, OUTPUT ldummy).
  IF NOT ldummy THEN RETURN. /* returning FALSE cancels the open */
END.

/* Save the handle of the current window and it's visualization. */
ASSIGN hActiveWin = _h_win.

/* Check to see if we are attempting to open a Dynamic Viewer for Dynamics */
IF _DynamicsIsRunning  THEN
DO:
   FIND FIRST _RyObject WHERE _RyObject.OBJECT_filename = pFileName NO-ERROR.
   IF AVAILABLE _RyObject 
       AND (LOOKUP("DynBrow":U, _RyObject.parent_classes) > 0
         OR LOOKUP("DynView":U, _RyObject.parent_classes) > 0
         OR LOOKUP("DynSDO":U, _RyObject.parent_classes)  > 0
         OR _RyObject.object_type_code = "DynBrow":U
         OR _RyObject.object_type_code = "DynView":U
         OR _RyObject.object_type_code = "DynSDO":U)
       AND pMode = "WINDOW":U AND pTempFile = "":U 
   THEN DO:
      RUN ry/prc/rydynsckrp.p (pFileName, pMode).   
      returnValue = RETURN-VALUE.
      IF RETURN-VALUE > "" THEN 
      DO:
        RUN choose-pointer IN _h_uib.
        RUN display_current IN _h_uib.
        RETURN returnValue.
      END. /* If return value is abort */
   END.   
   ELSE DO:
    /* If opening a static object from the MRU,  the non-qualified object name may be passed.
       If opening a static object from the open file option, this may also be a registered object.
       Change the pFileName input param to equal the repository object before passing to _qssuckr.p
       This will ensure the static object is opened as a repository object */
     ASSIGN cObjectName         = REPLACE(pFilename,"~\":U,"/":U)
            FILE-INFO:FILE-NAME = cObjectName
            cObjectNameFull     = FILE-INFO:FULL-PATHNAME
            cObjectNameFull     = REPLACE(cObjectNameFull,"~\":U,"/":U) .

     ASSIGN cObjectName = ENTRY(NUM-ENTRIES(cObjectname,"/"),cObjectName,"/":U).
     FIND FIRST _RyObject WHERE _RyObject.OBJECT_filename = cObjectName NO-ERROR.
     
     /* Try to find repository object without extension */
     IF NOT AVAIL _RyObject AND NUM-ENTRIES(cObjectName,".") > 1 THEN 
     DO:
       ASSIGN cObjectName = ENTRY(1,cObjectName,".").
       FIND FIRST _RyObject WHERE _RyObject.OBJECT_filename = cObjectName NO-ERROR.
     END.
     
     /* Check that the object in the repository is the same as the opened object. Construct the static object
        basd on the path, object name and extension. Check the FUll-PathName to see if it is on disk. */
     IF AVAIL(_RyObject) THEN 
     DO:
       ASSIGN cRelName            =  _RyObject.object_path + (IF _RyObject.object_path = "" THEN "" ELSE "~/":U) 
                                                           + cObjectName
                                                           + (IF NUM-ENTRIES(cObjectName,".") LE 1 AND  _RyObject.object_extension <> "" 
                                                             THEN "." + _RyObject.object_extension ELSE "")
              FILE-INFO:FILE-NAME = cRelName              
              cRelNameFull        = FILE-INFO:FULL-PATHNAME
              cRelNameFull        = REPLACE(cRelNameFull,"~\":U,"/":U) .        
     /* Check that the Searched file and the search file of pfilename are the same. It could be
        that the retrieved file in the repository is not the same as the opened file */
       IF cObjectNameFull <> ?  AND cRelNameFull = cObjectNameFull AND cRelNameFull <> ? THEN
          pFileName = cObjectName.
     END. 
     /* Turn mru off as it will set the fullpath instead of object name */
     ASSIGN lSetMRU = _mru_filelist
            _mru_filelist = NO.
     /* Now run the _qssucker with the converted filename */       
     
     RUN adeuib/_qssuckr.p (pFileName, pTempFile, 
        (IF pMode eq "OPEN":U THEN "WINDOW":U
         ELSE IF pMode eq "UNTITLED":U THEN "WINDOW UNTITLED":U
         ELSE pMode), FALSE).
     ASSIGN _mru_filelist = lSetMRU 
            returnValue   = RETURN-VALUE.
     IF _mru_filelist AND pMode <> "UNTITLED":U THEN
         RUN adeshar/_mrulist.p (pFileName, IF _remote_file THEN _BrokerURL ELSE "").
   END.
END.
ELSE DO:
   RUN adeuib/_qssuckr.p (pFileName, pTempFile, 
       (IF pMode eq "OPEN":U THEN "WINDOW":U
        ELSE IF pMode eq "UNTITLED":U THEN "WINDOW UNTITLED":U
        ELSE pMode), FALSE).
   ASSIGN returnValue            = RETURN-VALUE.
END.
SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).

IF returnValue = "_ABORT":U THEN DO:
  RUN choose-pointer IN _h_uib.
  RUN display_current IN _h_uib.
  RETURN "_ABORT":U.
END. /* If return value is abort */

FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.

/* Save the broker URL that was used to open the file for existing files
   only, not for new files. If the file was opened from the MRU file list, 
   store that broker url rather than the current broker url. */
IF AVAILABLE _P AND pTempFile NE "" AND _P._save-as-file <> ?
   AND NOT _P.design_ryobject THEN   /* jep-icf: No broker_url for repository objects. */
DO:
  ASSIGN
    _P._Broker-URL = (IF _mru_broker_url NE "" THEN _mru_broker_url ELSE _BrokerURL)
    cHostName      = DYNAMIC-FUNCTION("get-url-host":U IN _h_func_lib, FALSE,
                                      _P._Broker-URL)
    _h_win:TITLE   = _h_win:TITLE + 
                     (IF INDEX(_h_win:TITLE, cHostName) EQ 0 
                      THEN cHostName ELSE "").
END.
                     
/* In case of _qssuckr failure, reset the cursors */
RUN adecomm/_setcurs.p ("":U).

IF pMode ne "IMPORT" AND VALID-HANDLE(_h_win) THEN DO:

  /* Add this window to the Window menu's active windows. The
     check for returnValue prevents the same window from appearing
     twice on the Window menu (fix to bug 95-08-07-057).
  */
  IF NOT returnValue BEGINS "_REOPEN":U THEN DO:
    /* Tell the UIB to display the window as the current widget. 
       Note we need to set _h_cur_widg to UNKNOWN otherwise 
       changewidg won't fire if _h_win = _h_cur_widg. (as for
       example, in the case of an empty window.) */
    ASSIGN _h_cur_widg = ?.
    RUN changewidg IN _h_UIB (_h_win, TRUE). /* Deselect others */
    
    /* Open Section Editor for non-.w files (.p and .i files). */
    IF (_P._FILE-TYPE <> "w":U) THEN 
      RUN call_sew IN _h_UIB (INPUT "SE_OPEN":U ).
    
    ASSIGN hActiveWin = (IF _h_win:TYPE = "WINDOW":U
                         THEN _h_win ELSE _h_win:PARENT).
    /* Note the menu was already updated if the visualization was changed */
    IF VALID-HANDLE(_h_WinMenuMgr) THEN
      RUN WinMenuAddItem IN _h_WinMenuMgr 
        (_h_WindowMenu, hActiveWin:TITLE, _h_uib ).
  END.     
  ELSE IF returnValue BEGINS "_REOPEN":U THEN DO:
    /* Update the current active window and checked Window menu. 
       Corrects bug 95-08-16-067. */
    ASSIGN hActiveWin = WIDGET-HANDLE(ENTRY(2, returnValue)) NO-ERROR.
    RUN WinMenuChoose IN _h_UIB (hActiveWin:TITLE).
  END.

END.

/* _open-w.p - end of file */
