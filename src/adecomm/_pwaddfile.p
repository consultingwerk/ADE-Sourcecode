/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwaddfile.p
    
    Purpose:    Adds a file to Dynamics Repository.

    Syntax :    RUN adecomm/_pwaddfile.p (INPUT pw_Editor).

    Parameters:
    Description:

    Notes  :    Part of IZ 2513 Error when trying to save structured include
                in Dynamics framework.
      
    Authors: John Palazzo
    Date   : November, 2001
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }

DEFINE INPUT  PARAMETER pw_Editor   AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE hWindow    AS HANDLE    NO-UNDO.
DEFINE VARIABLE Add_OK     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE FileExt    AS CHARACTER NO-UNDO.

DO ON STOP UNDO, LEAVE:
    /* Need Window handle of Procedure Window for this editor widget. */
    hWindow = pw_Editor:WINDOW.
           
    /* Cannot add untitled / unsaved files to repository. */
    IF pw_Editor:NAME BEGINS {&PW_Untitled} THEN
    DO:
      MESSAGE "Cannot add to repository:" pw_Editor:NAME SKIP(1)
              "The file must be saved before it can be added to a repository."
              VIEW-AS ALERT-BOX INFORMATION IN WINDOW hWindow.
      RETURN.
    END.
    
    /* IZ 2513 Cannot add include files to repository. We can only filter on .i extensions. */
    RUN adecomm/_osfext.p
        (INPUT  pw_Editor:NAME  /* OS File Name.   */ ,
         OUTPUT FileExt         /* File Extension. */ ).
    IF (FileExt = ".i":U) THEN
    DO:
      MESSAGE "Cannot add to repository:" pw_Editor:NAME SKIP(1)
              "Include file types cannot be added to a repository."
              VIEW-AS ALERT-BOX INFORMATION IN WINDOW hWindow.
      RETURN.
    END.

    /* Call to run Add to Repository dialog and add file to repository. */
    RUN adeuib/_reposaddfile.p
        (INPUT hWindow,           /* Parent Window    */
         INPUT ?,                 /* _P recid         */
         INPUT "",                /* Product Module   */
         INPUT pw_Editor:NAME,    /* File to add      */
         INPUT "",                /* File type        */
         OUTPUT Add_OK).
END.
