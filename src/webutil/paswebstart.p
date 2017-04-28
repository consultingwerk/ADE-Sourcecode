/***********************************************************************
* Copyright (c) 2015-2016 by Progress Software Corporation. All rights      *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
************************************************************************/
/*------------------------------------------------------------------------
    Purpose     : Start webspeed for PAS   
                  This is called from the main block in the web-handler 
                  procedure to initiate all WebSpeed utility 
                  super-procedures.
                  This is an override of the standard webstart.p in order 
                  to provide environment variable values for PAS instead 
                  of using OS-GETENV.      
    Description : 

    Author(s)   : hdaniels
    Created     : Sat Apr 11 14:36:39 EDT 2015
    Notes       : The standard webutil/webstart.p is used as an include
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

/* ************************  Function Prototypes ********************** */

function GetDLC returns character 
	(  ) forward.

function GetEnv returns character 
	(pcname as char) forward.
	

/* ************************  Function Implementations ***************** */

function GetDLC returns character 
	(  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/	
    define variable cDLC as character no-undo.
    if opsys = "Win32":U then /* Get DLC from Registry */
        get-key-value section "Startup":U key "DLC":U value cDLC.
    if (cDLC = "" or cDLC = ?) then 
    do:
        cDLC = os-getenv("DLC":U). /* Get DLC from environment */
    end.
    return cDLC.
end function.

function GetEnv returns character 
       (input pcname as character  ):
    define variable cValue as character no-undo.
    case pcname:
        /* PAS does not support state aware (and if binding is to be supported in 
           the future it will not use this mechanism) */
        when "STATE_AWARE_ENABLED":U then
            assign cValue = "no":U.
        /* The batchinterval is not in use in web-handler.p (so this is not really necessary to have here)  */
        when "BATCH_INTERVAL":U then
            assign cValue = "-1":U.
        when "DLC":U then
            assign cValue = GetDLC().
        otherwise
            assign cValue = os-getenv(pcname).
    end case.

    return cValue.      
end function.


&scop EXCLUDE-getEnv
{webutil/webstart.p}
