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

File: _undcont.p

Description: Undelete a OCX Control and its CONTROL-FRAME widget.

Input Parameters:  uRecId - RecID of object of interest.

Output Parameters: <None>

Author: Wm.T.Wood

Date Created: February 1995

Modified on 11/01/96 gfs Put preprocessor around Control Container syntax so 
                         that this program would compile on 32bit.
            12/17/96 gfs Port to use with OCX's
            02/26/97 gfs Temporary fix for OCX default size (8.2A2B only)
            03/10/97 gfs Changed error handling & removed temp fix of 2/26/97
            03/17/97 jep Fix for 97-02-13-012 to delete OCX if can't create it.
            03/17/97 gfs Hide OCX if not in GUI mode
----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER uRecId              AS RECID     NO-UNDO.

{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}
{adecomm/adefext.i}

DEFINE VARIABLE s       AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE c       AS INTEGER    NO-UNDO.
DEFINE VARIABLE msg     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE err-msg AS CHARACTER  NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER parent_C FOR _C.

FIND _U       WHERE RECID(_U)       eq uRecId.
FIND _L       WHERE RECID(_L)       eq _U._lo-recid.
FIND _F       WHERE RECID(_F)       eq _U._x-recid.
FIND parent_U WHERE RECID(parent_U) eq _U._parent-recid.
FIND parent_L WHERE RECID(parent_L) eq parent_U._lo-recid.
FIND parent_C WHERE RECID(parent_C) eq parent_U._x-recid.

ASSIGN _F._FRAME    = parent_U._HANDLE
       _L._WIN-TYPE = parent_L._WIN-TYPE.
    
/* Because control-frames are not in DesignMode by default, defer setting DesignMode
   only control-frame attributes SELECTABLE, MOVABLE, and RESIZABLE. We do this by
   defining CONTROL-FRAME preprocessor so std_attr.i skips setting these attributes. */
&SCOPED-DEFINE control-frame  YES

/* Create the control-frame to put the OCX into. */
CREATE CONTROL-FRAME _U._HANDLE
    ASSIGN
        {adeuib/std_attr.i}
        NAME = _U._NAME
    TRIGGERS:
        {adeuib/std_trig.i}
    END TRIGGERS.
    .

/* Store away the com handle and set control-frame into design mode. */
ASSIGN _U._COM-HANDLE            = _U._HANDLE:COM-HANDLE
       _U._COM-HANDLE:DesignMode = TRUE.

/* Set DesignMode only control-frame attributes now that DesignMode has been set true. */
ASSIGN _U._HANDLE:SELECTABLE   = TRUE
       _U._HANDLE:MOVABLE      = TRUE
       _U._HANDLE:RESIZABLE    = TRUE.

/* Attach design-time trigger handling for "designFrame" triggers:
   designFrame.ControlNameChanged & designFrame.ObjectCreated (in uibmproa.i). */
_U._HANDLE:Add-Events-Procedure(_h_uib).

/* Assign Handles that we now know */
ASSIGN  {adeuib/std_uf.i &section = "HANDLES"} .

IF _L._WIN-TYPE THEN DO:       

  IF _L._WIDTH ne ?  THEN _U._HANDLE:WIDTH = _L._WIDTH * _L._COL-MULT.
  IF _L._HEIGHT ne ? THEN _U._HANDLE:HEIGHT = _L._HEIGHT * _L._ROW-MULT.

  /* Place object within frame boundary. 
     NOTE: Always view it here (HIDDEN = NO). We will REMOVE-FROM-LAYOUT later
     after we load the OCX from the binary file.
   */
  {adeuib/onframe.i
     &_whFrameHandle = "_F._FRAME"
     &_whObjHandle   = "_U._HANDLE"
     &_lvHidden      =  no }	 
      
  /* Make sure the Universal Widget Record is "correct" by reading the actually
     instantiated values. */
  ASSIGN  {adeuib/std_uf.i &section = "GEOMETRY"} .
        
  { adeuib/rstrtrg.i } /* Restore triggers */
END.
ELSE /* TTY emulation */
  ASSIGN
    _U._HANDLE:HIDDEN      = YES /* If not GUI, then HIDE the CONTROL FRAME */
    _L._REMOVE-FROM-LAYOUT = YES
    _U._HANDLE:ROW    = 1   /* In case the hidden OCX doesn't fit, put it at 1,1 */
    _U._HANDLE:COLUMN = 1.

IF _L._WIN-TYPE OR _F._VBX-BINARY NE "" THEN DO: /* GUI Mode */
/* Note: _F._VBX-BINARY will be set and _L._WIN-TYPE will be NO (TTY) 
 * when switching from GUI to TTY layout. 
 */    
    find first _LAYOUT where _LAYOUT._LO-NAME = _L._LO-NAME.

    /* If there is a binary file then load from it. */              
    IF _F._VBX-BINARY <> ? THEN DO:
        /* Load from the binary, but use the control name (i.e., shortname)
         * and then assign the name given by the UIB. This is for
         * cut/copy situations where the name gets changed.
        */
        _U._COM-HANDLE:LoadControls(SEARCH(ENTRY(1, _F._VBX-BINARY)) , ENTRY(2, _F._VBX-BINARY)) NO-ERROR.
        IF ERROR-STATUS:NUM-MESSAGES > 0 AND _L._WIN-TYPE THEN
        DO:
          ASSIGN err-msg = ERROR-STATUS:GET-MESSAGE(1).
          /* A Note about OCX ERROR handling. ERROR-STATUS:ERROR will always report
             FALSE. So, the only way to detect an error, although not the best 
             way, if to check NUM-MESSAGES. If NUM-MESSAGE > 0 then an error has
             occurred (gfs - 97-03-07-101) */
          ASSIGN s = FALSE. /* ERROR */
        END.
        ELSE ASSIGN s = TRUE. /* SUCCESS */
    END.
    ELSE DO:	
        /* Create OCX control w/o reading from a wrx file.
           NOTE: You'll get here in these cases:
                 1) Drawing from the Object Palette.
                 2) Loading a .W and there is no wrx file.
                 3) Migrating a VBX to an OCX.
        */
        ASSIGN _U._HANDLE:NAME = _U._NAME.
        /* _ocx_draw will not be set for case #2 only. In case #1 and #3,
           the user will have selected an OCX Control from the Choose OCX
           Control dialog. */
        IF NOT VALID-HANDLE(_ocx_draw) THEN DO:
          /* Create control using the classid and shortname which was
           * read from the OCXINFO comment in the .W file. */
          CREATE "PROX.ControlDef" _ocx_draw.
          ASSIGN _ocx_draw:ClassID   = _F._IMAGE-FILE
                 _ocx_draw:ShortName = _U._SUBTYPE NO-ERROR.
        END.
        IF VALID-HANDLE(_ocx_draw) THEN DO:
          _U._COM-HANDLE:AddControl(_ocx_draw, 0, 0, 0, 0) NO-ERROR.
          IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
          DO:
            ASSIGN err-msg = ERROR-STATUS:GET-MESSAGE(1).
            ASSIGN s = FALSE. /* ERROR */
          END.
          ELSE
            /* Assign back to temp tables to ensure true ClassID and ShortName are
               recorded. Overwrites values for VBX-OCX migration as well. -jep 1/22/97 */
            ASSIGN s              = TRUE /* SUCCESS */
                   _F._IMAGE-FILE = _ocx_draw:ClassID
                   _U._SUBTYPE    = _ocx_draw:ShortName
                   _U._OCX-NAME   = _ocx_draw:ShortName
                   _U._LABEL      = _ocx_draw:ShortName
                   _U._SENSITIVE  = TRUE
                   _U._HIDDEN     = NOT _U._COM-HANDLE:IsVisibleAtRuntime.

          RELEASE OBJECT _ocx_draw.
        END. /* IF VALID-HANDLE */
    END.

    /* If we can't create the control then let the caller know. */        
    IF s = FALSE THEN
    DO ON STOP UNDO, LEAVE:
      ASSIGN _F._SPECIAL-DATA = "":U.
      ASSIGN msg = _U._NAME + "." + _U._SUBTYPE + CHR(10) +
                   "Unable to create control." + CHR(10) + CHR(10).
      /* Strip off any additional message information, such as "Error
         occurred in procedure adeuib/_undcont.p". */
      ASSIGN msg = msg + ENTRY(1, err-msg, CHR(10)).
      MESSAGE msg
        VIEW-AS ALERT-BOX ERROR TITLE "{&UIB_SHORT_NAME}" IN WINDOW ACTIVE-WINDOW.
    END.
    ELSE DO:
      /* Reread geometry becuase it may have changed when the OCX was loaded */
      ASSIGN  {adeuib/std_uf.i &section = "GEOMETRY"} . 
    END.

    /* After the load of the binary file, hide the container if it is not supposed
     * to be on the current layout. 
     */
    IF _L._REMOVE-FROM-LAYOUT THEN _U._HANDLE:HIDDEN = TRUE.                                  
END.

