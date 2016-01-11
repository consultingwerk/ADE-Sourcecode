/*********************************************************************
* Copyright (C) 2001 by Progress Software Corporation ("PSC"),       *
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
