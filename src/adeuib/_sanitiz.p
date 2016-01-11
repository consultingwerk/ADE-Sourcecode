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

File: _sanitiz.p

Description:
    Go through all the _U records and verify that we have valid widgets
    associated with each one. Then go through all the widgets and verify
    that we have a valid _U record for it.
    
    Other checks:
     1) delete _TRG's without matching _U's
    
Input Parameters:
   <None>
   
Output Parameters:
   <None>

Author: Wm.T.Wood

Date Created: July 27, 1993
Modified: 03/26/98 SLK Added Signature Check for ADM SMO objects
          06/22/98 SLK Removed Signature Check for ADM SMO objects
----------------------------------------------------------------------------*/
{adeuib/uniwidg.i}   /* Universal widget definition               */
{adeuib/brwscols.i}  /* Temp-table definitions for browse columns */
{adeuib/layout.i}    /* Layout temp-table definitions             */
{adeuib/triggers.i}  /* Trigger definitions                       */
{adeuib/xftr.i}      /* eXtended Feature definitions              */
{adeuib/_undo.i}     /* Undo temp-table definitons                */
{adeuib/links.i}     /* ADM Link table definition                 */ 

/* If &MODE > 0 then report errors. Modes:
    0  - report nothing
    10 - report deletions of widgets/records
    20 - report unusual widgets [invisible and frame bars] */
&Scoped-define MODE 10
/* &MESSAGE [_sanitiz.p] Report Error mode = {&MODE} (wood) */

/* --------------- Local Variables -----------------------*/
DEF VAR cTemp      AS CHARACTER NO-UNDO.  /* Temp Character          */
DEF VAR lOK        AS LOGICAL   NO-UNDO.  /* Logical Result          */
DEF VAR lSigOK     AS LOGICAL   NO-UNDO.  /* Logical Result          */
DEF VAR admVersion AS CHARACTER NO-UNDO.  /* Logical Result          */

DEFINE BUFFER win_U   FOR _U.
DEFINE BUFFER x_U     FOR _U.
DEFINE BUFFER x_S     FOR _S.

/** ************************
 ** DELETE _U's w/o WIDGETS
 **/
FOR EACH _U WHERE _U._STATUS NE "DELETED" :
  IF NOT VALID-HANDLE(_U._HANDLE) THEN DO:
    IF {&MODE} >= 10 
    THEN MESSAGE "Invalid Handle for _U:" _U._TYPE _U._LABEL SKIP
                 "Deleting Universal Object Record!"
                 VIEW-AS ALERT-BOX WARNING BUTTONS OK TITLE "Sanitize Error".

    /* Find the extension record and delete it */
    FIND _F WHERE RECID(_F) eq _U._x-recid NO-ERROR.
    IF AVAILABLE _F THEN DELETE _F.
    ELSE DO:
      FIND _C WHERE RECID(_C) eq _U._x-recid NO-ERROR.
      IF AVAILABLE _C THEN DO:
        /* _C records now have an associated _Q. */
        IF _C._q-recid ne ? THEN DO:
          FIND _Q WHERE RECID(_Q) eq _C._q-recid NO-ERROR.
          IF AVAILABLE _Q THEN DELETE _Q.
        END.
        DELETE _C.
      END. /* available _C */
      ELSE DO:
        FIND _S WHERE RECID(_S) eq _U._x-recid NO-ERROR.
        IF AVAILABLE _S THEN DO:
          /* Delete both the _S record, and the Persistent Object */
          IF VALID-HANDLE(_S._HANDLE) THEN 
          DO:
             {adeuib/admver.i _S._HANDLE admVersion}
             IF admVersion LT "ADM2":U THEN
                RUN dispatch IN _S._HANDLE ("destroy") NO-ERROR.
             ELSE
                RUN destroyObject IN _S._HANDLE NO-ERROR.
          END.
          /* If that didn't work, then use brute force. */
          IF VALID-HANDLE(_S._HANDLE) THEN DELETE PROCEDURE _S._HANDLE.
          /* Now we can get rid of the record */
          DELETE _S.
        END.
        ELSE DO:
          FIND _M WHERE RECID(_M) eq _U._x-recid NO-ERROR.
          IF AVAILABLE _M THEN DELETE _M.
        END. /* delete _M */
      END. /* delete _S or _M */
    END. /* delete _C or _S or _M */
    
    /* Now delete triggers for the widget */
    FOR EACH _TRG WHERE _TRG._wRECID = RECID(_U):
      DELETE _TRG.
    END.

    /* Now delete action history for the widget */
    FOR EACH _action WHERE _action._u-recid = RECID(_U):
      DELETE _action.
    END.
    
    /* Now delete any _L records for this _U */
    FOR EACH _L WHERE _L._u-recid = RECID(_U):
      DELETE _L.
    END.
    
    /* Now delete the _U itself */
    DELETE _U.
  END.
END.

/** ************************
 ** DELETE UIB WIDGETS w/o _U's
 **/
 /* NOTE: With SmartObjects, there may very well be a whole bunch of 
    widgets created that the user wants to create.  So we don't want to
    just look for WIDGETS w/o _U's.  However we do want to look for any
    widget the UIB created without a _U.  The "trick" here is that all
    dynamic widgets created by the UIB will have "UIB/_U" in their private
    data. (This is defined in pre_proc.i as ~{&UIB-Private}.
    If this is the case, then check the widget for a _U record. */
 
/* It would be nice to be able to go to the SESSION:FIRST-CHILD and check
   all windows, but I have no way of knowing which are UIB windows, so we
   are going to start with the windows the UIB knows about and check all
   their children */
FOR EACH win_U WHERE win_U._STATUS NE "DELETED":U
               AND CAN-DO ("WINDOW,DIALOG-BOX":U, win_U._TYPE):
  /* Loop through the children (recursively) and check all the children. */
  RUN check-child-widgets (win_U._HANDLE).
END. /* FOR EACH win_U... */
  
  
/** ************************************
 ** DELETE _TRG's w/o corresponding _U's
 **/
FOR EACH _TRG :
  FIND _U WHERE RECID(_U) eq _TRG._wrecid NO-ERROR.
  IF NOT AVAILABLE _U THEN
    FIND _BC WHERE RECID(_BC) eq _TRG._wrecid NO-ERROR.
  IF NOT AVAILABLE _U AND NOT AVAILABLE _BC THEN DO:
    IF {&MODE} >= 10
    THEN MESSAGE "Trigger points to non-existent _U:" 
                 _TRG._tSECTION _TRG._tEVENT SKIP
                 SUBSTRING(_TRG._tCODE,1,240) "..." SKIP
                 "Deleting Trigger Record!"
                 VIEW-AS ALERT-BOX WARNING BUTTONS OK TITLE "Sanitize Error".
    DELETE _TRG.
  END.
END.
/** ****************************************
 ** DELETE _U's w/o Corresponding Procedures
 **/
FOR EACH _U WHERE _U._STATUS NE "DELETED" AND
         _U._HANDLE eq _U._WINDOW-HANDLE:
  FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE NO-ERROR.
  IF NOT AVAILABLE _P THEN DO:
    IF {&MODE} >= 10 
    THEN MESSAGE "No Procedure Record exists for :" _U._TYPE _U._LABEL SKIP
                 "Deleting Universal Object Records for all objects."
                 VIEW-AS ALERT-BOX WARNING BUTTONS OK TITLE "Sanitize Error".
    /* Now delete the Universal Widget records for this window. */
    RUN adeuib/_delet_u.p (RECID (_U), TRUE /* Trash */ ).
  END.
END.
 
   
/** ************************************
 ** DELETE _admlinks w/o corresponding _U's
 ** DELETE _amdlinks if signature do not match (ADM2)
 **/
FOR EACH _admlinks : 
  lOK = yes. 
  /* Check the link source */  
  IF _admlinks._link-source eq STRING(_admlinks._P-recid)
  THEN DO:
    FIND _P WHERE RECID(_P) eq _admlinks._P-recid.
    IF NOT AVAILABLE _P THEN lOK = no.  
  END.
  ELSE DO:
    FIND _U WHERE RECID(_U) eq INTEGER(_admlinks._link-source) NO-ERROR.  
    IF NOT AVAILABLE _U THEN lOK = no.
  END.

  IF lOK THEN DO:
    /* Check the link target*/  
    IF _admlinks._link-dest eq STRING(_admlinks._P-recid)
    THEN DO:
      FIND _P WHERE RECID(_P) eq _admlinks._P-recid.
      IF NOT AVAILABLE _P THEN lOK = no. 
    END.
    ELSE DO:
      FIND x_U WHERE RECID(x_U) eq INTEGER(_admlinks._link-dest) NO-ERROR.  
      IF NOT AVAILABLE x_U THEN lOK = no.
    END. 
  END.
    
  IF NOT lOK THEN DO:
    IF {&MODE} >= 10
    THEN MESSAGE "ADM Link points to non-existent _U:" 
                 _admlinks._link-type 
                 "(from" _admlinks._link-source "to" _admlinks._link-dest + ")" SKIP
                 SUBSTRING(_TRG._tCODE,1,240) "..." SKIP
                 "Deleting Link Record!"
                 VIEW-AS ALERT-BOX WARNING BUTTONS OK TITLE "Sanitize Error".
    DELETE _admlinks.
  END.
END.          

/** ************************************
 ** DELETE Inline xftr's w/o corresponding windows's
 **/
FOR EACH _xftr WHERE _xftr._wRECID ne ?:
  FIND _U WHERE RECID(_U) eq _xftr._wRECID NO-ERROR.
  IF NOT AVAILABLE _U THEN DO:
    IF {&MODE} >= 10
    THEN MESSAGE "Inline XFTR points to non-existent window:"
                 _xftr._name SKIP
                 "Deleting eXtended Feature Record!"
                 VIEW-AS ALERT-BOX WARNING BUTTONS OK TITLE "Sanitize Error".
    DELETE _xftr.
  END.
END.

/*
   If _U records were deleted, the action records may need to be cleaned up.
   Call ActionHistoryCheck that cleans out these empty Start/End records.
*/

{adeuib/uibmundo.i}

RUN ActionHistoryCheck.

/* Signature match */
{adeuib/_chkrlnk.i}

/* check-child-widgets:  Walk the widget tree for all the children of a widget.
 *             Report an error if the widget has no Universal Widget record 
 *             (unless this is a situation we know is OK.) 
 * NOTE: the widget passed into this routine is expected to have a valid _U
 * record. */
PROCEDURE check-child-widgets:
  DEFINE INPUT PARAMETER ph_parent AS WIDGET-HANDLE NO-UNDO.
   
  DEF VAR h       AS WIDGET  NO-UNDO.  /* A generic widget handle */
  
  /* Get the Universal widget record of this object. If it is a frame, find
     out other information about this widget.  */
  FIND _U WHERE _U._HANDLE eq ph_parent. 
  FIND _C WHERE RECID(_C) eq _U._x-recid.
  IF CAN-DO ("FRAME,DIALOG-BOX", _U._TYPE)
  THEN ph_parent = ph_parent:FIRST-CHILD. /* The field group. */
 
  /* Make sure that this program is called correctly. That is, the parent is
     a legal "parent". */
  IF NOT CAN-QUERY(ph_parent, "FIRST-CHILD") THEN DO:
    RETURN.
  END.
  
  /* Loop through children looking for universal widget records for each 
     widget. */
  h = ph_parent:FIRST-CHILD.   
  DO WHILE h NE ?: 
    /* Does this widget need, and have, a valid _U? */   
    IF h:PRIVATE-DATA eq "{&UIB-Private}" THEN DO:
      FIND _U WHERE _U._HANDLE EQ h NO-ERROR.
      IF AVAILABLE _U THEN DO:
        /* Check child widgets of this widget if it is a frame, by calling
           the procedure recursively. */
        IF _U._TYPE eq "FRAME" THEN RUN check-child-widgets (_U._HANDLE).   
      END. 
      ELSE DO:
        /* We have found a widget that we should know about, but don't. */           
        IF {&MODE} >= 10
        THEN MESSAGE "No Universal object exists for" h:TYPE 
                     "@ (" h:X "," h:Y  ")." 
                     IF h:DYNAMIC THEN (CHR(10) + "Deleting object!") ELSE ""
                  VIEW-AS ALERT-BOX WARNING BUTTONS OK TITLE "Sanitize Error".
        /* Run Persistent (eg. for a SmartObject) can create Static widgets 
           that can't be deleted */
        IF h:DYNAMIC THEN DELETE WIDGET h.
      END.
    END.
    ELSE DO:
      IF {&MODE} >= 20
      THEN MESSAGE "Ignoring object" h:TYPE 
                   "@ (" h:X "," h:Y  ")."   SKIP
                   "h:VISIBLE = " h:VISIBLE
              VIEW-AS ALERT-BOX WARNING BUTTONS OK TITLE "Sanitize Warning".
    END. 
    /* Get next field level widget */
    h = h:NEXT-SIBLING.
  END.
END PROCEDURE. /* check-child-widgets */
 
