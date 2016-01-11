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

File: defextnt.i

Description:
   Include file that defines the extent of a widget.  This is called by
   _gen4gl and quikcomp to assure an array is defined once and only once.
   When an array variable is found defextent is called to produce the
   "EXTENT n " phrase of a DEFINE statement.  To do this defextent loops
   through the _U records of the same name as the current one to find the
   largest _SUBSCRIPT to determine "n".  While looping, it is making the
   _SUBSCRIPTs negative to indicate that this variable has been processed.
   This assures that the same variable is not output twice.
Input Parameters:
   <None>

Output Parameters:
   <None>

Author: Ross Hunter

Date Created: 19 February 1993.

----------------------------------------------------------------------------*/
DEFINE VARIABLE xxtmp_name AS CHAR                                     NO-UNDO.
DEFINE VARIABLE xxmax_ext  AS INTEGER                                  NO-UNDO.

ASSIGN xxtmp_name    = tmp_name + "["
       xxmax_ext     = _F._SUBSCRIPT
       _F._SUBSCRIPT = -1 * _F._SUBSCRIPT.
       
FOR EACH xx_U WHERE xx_U._NAME BEGINS xxtmp_name AND
                    xx_U._TYPE = x_U._TYPE,
    EACH x_F WHERE RECID(x_F) = xx_U._x-recid AND
                   x_F._SUBSCRIPT > 0:
   ASSIGN xxmax_ext      = MAX(xxmax_ext,x_F._SUBSCRIPT)
          x_F._SUBSCRIPT = -1 * x_F._SUBSCRIPT.
END.

PUT STREAM P_4GL UNFORMATTED " EXTENT " xxmax_ext.
