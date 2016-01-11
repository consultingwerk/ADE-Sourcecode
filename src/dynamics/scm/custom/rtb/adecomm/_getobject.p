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
DEFINE INPUT  PARAMETER phWindow           AS HANDLE      NO-UNDO.
DEFINE INPUT  PARAMETER gcProductModule    AS CHARACTER   NO-UNDO. /* LIKE gsc_product_module.product_module_code. */
DEFINE INPUT  PARAMETER glOpenInAppBuilder AS LOGICAL     NO-UNDO.
DEFINE INPUT  PARAMETER pcTitle            AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER gcFileName         AS CHARACTER   NO-UNDO. /* LIKE ryc_smartobject.object_filename. */
DEFINE OUTPUT PARAMETER pressedOK          AS LOGICAL     NO-UNDO.

DEFINE SHARED VARIABLE Grtb-proc-handle AS HANDLE NO-UNDO.

DEFINE VARIABLE cRTBAction  AS CHARACTER NO-UNDO.

DEFINE VARIABLE cProduct  AS CHARACTER  NO-UNDO INITIAL "UIB":U.
DEFINE VARIABLE cAction   AS CHARACTER  NO-UNDO INITIAL "OPEN":U.
DEFINE VARIABLE cMode AS CHARACTER  NO-UNDO.

DEFINE VARIABLE lIsICFRunning          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gshRepositoryDesignManager  AS HANDLE   NO-UNDO.
DEFINE VARIABLE dSmartObjectObj AS DECIMAL    NO-UNDO.

{src/adm2/globals.i}

ASSIGN lIsICFRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
IF lIsICFRunning = ? THEN 
    lIsICFRunning = NO.

/* If the ICF is running, get the handle of the Repository Design Manager */
IF lIsICFRunning THEN 
    gshRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) .

IF VALID-HANDLE( Grtb-proc-handle )THEN 
DO:
    RUN intercept_getfile IN Grtb-proc-handle
      ( INPUT  phWindow ,
        INPUT  cProduct,
        INPUT  cAction,
        INPUT  pcTitle,
        INPUT  cMode,
        INPUT-OUTPUT gcFileName,
        OUTPUT cRTBAction ).
    
    /* First get the base name of the file and then remove the file extension if              */
    /* if has a .ado extension from the file name to make sure the AppBuilder understands it. */
    /*                                                                                             */
    /* Apart from removing the .ado extension, the full object name, including the            */
    /* extension should always be passed in.                                                  */
    /*                                                                                             */
    /* If the object is a static object, this will be determined from the object              */
    /* when it is found in the repository prior to opening it.                                */
    /*                                                                                             */
    /* If the object is dynamic, then it is enough to pass in the base name of the object.    */
  
    ASSIGN  gcFilename = SUBSTRING(gcFilename, R-INDEX(gcFilename, "/":U) + 1)
            gcFileName = REPLACE(gcFilename, ".ado":U, "":U).       
    
    /* Process the action coming from RTB */
    CASE cRTBAction:
    WHEN "Cancel" THEN DO:
      ASSIGN pressedOK = NO.
      RETURN.
    END.
    WHEN "Go" THEN DO:
      ASSIGN pressedOK = YES.
    
      IF VALID-HANDLE(gshRepositoryDesignManager) THEN
        DYNAMIC-FUNCTION('openRyObjectAB' IN gshRepositoryDesignManager, gcFileName) NO-ERROR.
      RETURN.
    END.
    END CASE.
END.   /* --- valid-handle(Grtb-proc-handle) --- */

/* If we get this far, then "Open Via OS" has been selected - and we use the standard Open Object Dialog */
IF SEARCH("ry/obj/gopendialog.w":U) <> ?
OR SEARCH("ry/obj/gopendialog.r":U) <> ?
THEN DO:
  RUN ry/obj/gopendialog.w (INPUT  phWindow,
                            INPUT  gcProductModule,
                            INPUT  glOpenInAppBuilder,
                            INPUT  pcTitle,
                            OUTPUT gcFileName,
                            OUTPUT pressedOK).
END.
ELSE DO:
  ASSIGN
    pressedOK = NO.
  MESSAGE "The AppBuilder Open Object Dialog is not available."
    VIEW-AS ALERT-BOX ERROR.
  RETURN.
END.

RETURN.
