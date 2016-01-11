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
    Procedure:  _fhidden.i

    Purpose:    Defines a 'static' variable which determines whether or
                not hidden tables are shown in the DD or Admin tool. The
                DD/Admin reports will use this value when they run.
                
    Syntax :    {prodict/_fhidden.i}

    Parameters: None

    Description:
    Notes  :
    Authors: Gerry Seidl
    Date   : 05/31/95
**************************************************************************/

DEFINE NEW GLOBAL SHARED VARIABLE fhidden AS LOGICAL NO-UNDO INITIAL NO.
