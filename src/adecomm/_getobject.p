/***********************************************************************
* Copyright (C) 2000,2012 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
************************************************************************/
/*----------------------------------------------------------------------------

File                  : _getobject.p

Description           : This is the ADE API to do the call to open a Dynamic Object.

Input Parameters:
  phWindow            : Window in which to display the dialog box.
  gcProductModule     : Initial Product Module Code.
  glOpenInAppBuilder  : Open in Appbuilder
  pcTitle             : Title for Dialog Window to be launched

Output Parameters:
  gcFileName          : The filename selected.
  pressedOK           : TRUE if user successfully choose an object file name.

Author: Pieter J. Meyer

Date Created: September 2002

----------------------------------------------------------------------------*/
{adecomm/oeideservice.i}
DEFINE INPUT  PARAMETER phWindow           AS HANDLE      NO-UNDO.
DEFINE INPUT  PARAMETER gcProductModule    AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER glOpenInAppBuilder AS LOGICAL     NO-UNDO.
DEFINE INPUT  PARAMETER pcTitle            AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER gcFileName         AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER pressedOK          AS LOGICAL     NO-UNDO.
 
IF SEARCH("adeuib/_opendialog.w":U) <> ?
OR SEARCH("adeuib/_opendialog.r":U) <> ?
THEN
DO:  
    if OEIDEIsRunning then 
        run adeuib/ide/_dialog_opendialog.p 
                               (phWindow,
                                gcProductModule,
                                glOpenInAppBuilder,
                                pcTitle,
                                OUTPUT gcFileName,
                                OUTPUT pressedOK).
    else
       run adeuib/_opendialog.w(phWindow,
                                gcProductModule,
                                glOpenInAppBuilder,
                                pcTitle,
                                OUTPUT gcFileName,
                                OUTPUT pressedOK).

END.                           
ELSE DO:
  ASSIGN
    pressedOK = NO.
  MESSAGE "No open object dialog is available."
    VIEW-AS ALERT-BOX BUTTONS OK.
  RETURN.

END.

RETURN.
