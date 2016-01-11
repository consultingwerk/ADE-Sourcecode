 /*************************************************************/
 /* Copyright (c) 2012 by Progress Software Corporation.      */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _selecttables
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sun Feb 12 00:19:17 EST 2012
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using adeuib._ideeventservice.
routine-level on error undo, throw.

class adeuib.ide._selecttables inherits _ideeventservice: 
    define public property MultiSelect       as logical no-undo get. set.
    define public property TempTableInfo     as character no-undo get. set.
    define public property DataBaseName      as character no-undo get. set.
    define public property TableNames        as character no-undo get. set.
    
    method override public void RunEvent():
        run value(ProcedureMethod) in ProcedureHandle 
                   (MultiSelect,
                    TempTableInfo,
                    DataBaseName,
                    TableNames).
    end method.  
    
  

end class.