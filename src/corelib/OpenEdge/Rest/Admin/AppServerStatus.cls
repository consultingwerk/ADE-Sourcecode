/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : AppServerStatus.cls
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : whenshaw
    Created     : Fri Jan 10 13:57:18 EST 2014
    Notes       : Useful for pinging the AppServer. The REST adapter uses this as part of 
                  responding to a  /rest/_oeping request
                  Default behavior is to return an empty CHARACTER string. The content of
                  that string is irrelevant to the REST adapter ping feature -- it simply
                  passes the string along in its response to its client. The intent is that a 
                  developer, if desired, can customize the return value.
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

block-level on error undo, throw.

class OpenEdge.Rest.Admin.AppServerStatus: 

    method public char ServerStatus( ):
        /* return "A developer can customize this". */
        return "".
    end.    
        
end class.
