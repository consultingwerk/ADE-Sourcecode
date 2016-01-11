/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
