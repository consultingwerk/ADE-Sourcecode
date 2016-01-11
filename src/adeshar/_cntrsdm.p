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

File: _cntrsdm.p

Description:
    Sets the design mode flag for control support

Input Parameters:
    dMode - 1 for DESIGN 0 for RUN

Output Parameters:
    s     - non 0 if there is an error

Author: D. Lee


Date Created:  1995
Date Modified:  

---------------------------------------------------------------------------- */

/*
 * This capability does not exist outside of MS-WINDOWS
 */
 
{adecomm/_adetool.i} /* flag this as an ADE tool procedure */
{adeshar/cntrapi.i}

/*
 * ControlSetDesignMode
 *
 *   Put the VBX world into eith design or run mode.
 *   1 for DESIGN 0 for RUN
 */

define input  parameter dMode as integer no-undo.
define output parameter s     as integer no-undo initial 0.

/* Should be converted to test for platfrom support of VBX or OCX.
   -jep 01/30/96 */
if opsys <> "MSDOS":u then return.

run CntrSetDesignMode (dMode, output s). 

RETURN.
