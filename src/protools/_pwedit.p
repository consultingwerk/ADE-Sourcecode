/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/**************************************************************************
    Procedure:  _pwedit.p

    Purpose:    ProTools front-end call to Procedure Window main procedure.

    Syntax :    RUN protools/_pwedit.p.

    Parameters:
    Description:
    Notes  :
                Parent ID passed is Null (""). This "parents" Procedure
                Windows created by ProTools to the ADE Desktop. When
                the ADE Desktop is told to exit, it notifies each
                of its Procedure Windows (Parent ID = Null), giving each
                a chance to let the user save work-in-progress.
    Authors: John Palazzo
    Date   : March, 1994
**************************************************************************/

RUN adecomm/_pwmain.p ("",   /* Parent ID [eg. UIB]. */
                       "",   /* FileList */
                       "").  /* p_Edit_command (Currently Unused) */
