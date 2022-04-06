/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
