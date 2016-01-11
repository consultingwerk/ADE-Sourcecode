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
