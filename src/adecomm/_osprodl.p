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

File: _osprodl.p

Description:
   Does an os independant call to prodel.  Functions are just like those
   used by the os executable with the addition of a error return code.
   If the error code is non zero, a problem has occured.  Errors are
   listed below.   Eventually, this code will put up alert boxes for all
   of the errors so that the caller does not have to worry about it.

Input/Output Parameters:
   
   input  p_pname:   physical database name to delete.
   output p_error:   Error return code.

Author: Warren Bare

Date Created: 03/30/92 

----------------------------------------------------------------------------*/
define input parameter p_pname as char no-undo.
define output parameter p_error as int no-undo.

IF LOOKUP(OPSYS, "UNIX,MSDOS,WIN32":u) > 0 THEN
    OS-COMMAND prodel VALUE(p_pname).
