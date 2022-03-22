/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwfmod.p
    
    Purpose:    Returns TRUE if editor is a modified; FALSE if not.

    Syntax :    RUN adecomm/_pwfmod.p ( INPUT p_Editor , INPUT p_Title ,
                                      OUTPUT p_Modified ) .

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }

DEFINE INPUT  PARAMETER p_Editor   AS WIDGET-HANDLE      NO-UNDO.
DEFINE OUTPUT PARAMETER p_Modified AS LOGICAL INIT FALSE NO-UNDO.
    
DO:
    /* WebSpeed Report/Detail case where the Procedure Window is the 
       visualization of the Report/Detail Wizards output. The file has not
       been modified per se, yet it is still untitled and not empty. */
    IF ( p_Editor:MODIFIED = NO AND NOT p_Editor:EMPTY AND
         p_Editor:NAME BEGINS {&PW_Untitled})
    THEN p_Modified = TRUE.
    ELSE IF 
       ( p_Editor:MODIFIED = NO ) OR 
       ( p_Editor:NAME BEGINS {&PW_Untitled} AND
         p_Editor:EMPTY ) 
    THEN p_Modified = FALSE.
    ELSE p_Modified = TRUE.

END.
