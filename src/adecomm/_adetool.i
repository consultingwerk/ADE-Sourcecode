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
    Procedure:  _adetool.i
                                       
    Purpose:    Defines an internal procedure called 'ADEPersistent'. This
                should be included in any Persistent procedure which you do
                not want to be automatically deleted by any ADE tools (e.g.
                Editor, UIB). The program _runtool.p will check for the
                existence of ADEPersistent in a procedure and will delete
                it only if it doesn't exist.

    Syntax :    {adecomm/_adetool.i}

    Parameters: None
        
    Description:
    Notes  :
    Authors: Gerry Seidl
    Date   : 1/18/95
**************************************************************************/
PROCEDURE ADEPersistent:
    RETURN "OK".
END.
