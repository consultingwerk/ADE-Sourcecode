/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
**********************************************************************

    Procedure:  _winexit.p
    
    Purpose:    Attempt to close all open XML Mapping Tool windows for a 
                specified Parent.
    
    Syntax :    RUN adexml/_winexit.p ( pParent, OUTPUT pOKClose ).

    Parameters:
        INPUT
        pParent
            - String value indicating "Parent" of XML Mapping window.
              Pass Null ("") if no parent. The pParent parameter should be
              the name of the calling tool.  When the tool exits, it calls
              adexml/_winexit.p and passes pParent again. This procedure
              uses pParent to determine which XML Mapping windows to close.

              It's best to pass the application's or tool's startup procedure
              name. This allows adexml/_winexit.p to determine if the caller
              is the startup routine. If it is, then all XML Mapping Tools are 
              closed, not just those owned by the caller. This takes care of 
              those XML Mapping Tools created by PRO*Tools.

        OUTPUT
        pOKClose  
            - If all XML Mapping Tool windows of the Parent are closed 
              successfully, pOKClose is returned as TRUE. Otherwise, its 
              returned as FALSE or Unknown.
                 
    Description:
          1. Search all the windows in the current session looking for
             XML Mapping windows belonging to the Parent specified by
             pParent. 
          2. Tell the XML Mapping window to close. If all windows of the 
             Parent are closed successfully, pOKClose is returned as TRUE. 
             Otherwise, its returned as FALSE or Unknown.
    
    Notes  : Based on adecomm/_pwexit.p, written by John Palazzo
    Authors: Doug Adams, John Palazzo
    Created: January, 1994
    Update : 07/20/00 adams Adapted for use with XML Mapping Tool
**************************************************************************/

DEFINE INPUT  PARAMETER pParent  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pOKClose AS LOGICAL   NO-UNDO INITIAL TRUE.

DEFINE VARIABLE cParent    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE cStartProc AS CHARACTER     NO-UNDO.
DEFINE VARIABLE hProcedure AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hWindow    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE lProQuit   AS LOGICAL       NO-UNDO.

/* --- Begin SCM changes --- */
DEFINE VARIABLE scm_ok       AS LOGICAL       NO-UNDO.
DEFINE VARIABLE scm_context  AS CHARACTER     NO-UNDO.
DEFINE VARIABLE scm_filename AS CHARACTER     NO-UNDO.
/* --- End SCM changes ----- */

/* Internal Procedure Include. */
{ adecomm/pruntool.i }

&SCOPED-DEFINE XML-NAME "XML Schema Mapping":U

REPEAT ON STOP UNDO, RETRY:
  IF RETRY THEN DO:
    ASSIGN pOKClose = FALSE.
    RETURN ERROR.
  END.
    
  /* Start with the session's first window. */
  ASSIGN 
    hWindow = SESSION:FIRST-CHILD
    pParent = ( IF pParent = ? THEN "?" ELSE pParent ).
           
  /* Check if the parent is the startup procedure. If so, user
     is exiting Progress. Set Pro_Quit so all PW will be deleted. */
  IF pParent <> "" AND pParent <> ? THEN DO:
    RUN RunBy (INPUT ? , OUTPUT cStartProc).
    ASSIGN lProQuit = (pParent = cStartProc).
  END.
    
  DO WHILE VALID-HANDLE( hWindow ):
    IF NUM-ENTRIES(hWindow:PRIVATE-DATA) > 1 THEN
      ASSIGN
        cParent    =               ENTRY(1, hWindow:PRIVATE-DATA)
        hProcedure = WIDGET-HANDLE(ENTRY(2, hWindow:PRIVATE-DATA)).
    ELSE
      ASSIGN 
        cParent    = hWindow:PRIVATE-DATA
        hProcedure = ?.
      
    /* Is this a XML Mapping window and is it a "child window" of the Parent 
       window passed? */
    IF hWindow:NAME = {&XML-NAME} AND 
      (cParent = pParent OR lProQuit) THEN DO:
      /* --- Begin SCM changes --- */
      ASSIGN 
        scm_context  = STRING( hWindow )
        scm_filename = hWindow:NAME.
      RUN adecomm/_adeevnt.p ( {&XML-NAME}, "Before-Close":U, scm_context, 
                               scm_filename, OUTPUT scm_ok ).
      IF scm_ok = FALSE THEN DO:
        ASSIGN pOKClose = FALSE.  /* Cancel */
        RETURN.
      END.
      RUN adecomm/_adeevnt.p ( {&XML-NAME}, "Close":U, scm_context, 
                               scm_filename, OUTPUT scm_ok ).
      /* Do custom shutdown -- this is generally a no-op, but it can
         be used to cleanup custom modifications. */
      RUN adecomm/_adeevnt.p ( {&XML-NAME}, "Shutdown":U, STRING(hWindow), 
                               STRING(hWindow:PRIVATE-DATA), OUTPUT scm_ok ).
      /* --- End SCM changes ----- */
    
      IF VALID-HANDLE(hProcedure) THEN DO:
        ASSIGN hWindow = hWindow:NEXT-SIBLING.
          
        RUN windowClose IN hProcedure.
        IF ERROR-STATUS:ERROR THEN DO:
          ASSIGN pOKClose = FALSE.
          RETURN.
        END.
      END.
    END.
    ELSE 
      ASSIGN hWindow = hWindow:NEXT-SIBLING.
  END.
  LEAVE.

END.

/* _winexit.p - end of file */
