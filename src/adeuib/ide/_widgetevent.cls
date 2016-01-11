 /*************************************************************/
 /* Copyright (c) 2012 by Progress Software Corporation.      */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _propertysheet
    Purpose     : pass a context handle to method  
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Feb  2012
    Notes       : Used to call property_sheet with handle from persistent triggers 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using adeuib._ideeventservice.
routine-level on error undo, throw.

class adeuib.ide._widgetevent inherits _ideeventservice: 
    define public property EventHandle       as handle no-undo get. set.
    
    method override public void RunEvent():
        run value(ProcedureMethod) in ProcedureHandle (EventHandle).
    end method.  
end class.