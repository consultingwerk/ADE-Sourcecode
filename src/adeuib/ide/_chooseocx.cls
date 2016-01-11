  /*************************************************************/
 /* Copyright (c) 2012 by Progress Software Corporation.      */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _chooseocx
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : rkamboj
    Created     : Mon Jun 11 12:33:55 IST 2012
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using adeuib._ideeventservice.
routine-level on error undo, throw.


CLASS adeuib.ide._chooseocx inherits _ideeventservice: 
    define public property pHWND         as integer no-undo get. set.
    
    
    method override public void RunEvent():
        run value(ProcedureMethod) in ProcedureHandle 
            (pHWND).
    end method.  

END CLASS.