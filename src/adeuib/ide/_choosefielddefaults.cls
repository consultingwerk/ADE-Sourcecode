 /*************************************************************/
 /* Copyright (c) 2013 by Progress Software Corporation.      */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    Purpose     : run _prpobj do-select-defaults
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sun Jun 16 2013
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using adeuib._ideeventservice.
routine-level on error undo, throw.
class adeuib.ide._choosefielddefaults inherits _ideeventservice: 
    define public property MustBeLike   as logical no-undo get. set.
    define public property OldName      as character no-undo get. set.
    define public property ObjectType   as character no-undo get. set.
    
    method override public void RunEvent():
        run value(ProcedureMethod) in ProcedureHandle 
                   (MustBeLike,
                    OldName,
                    ObjectType).
    end method.  
    
  

end class.