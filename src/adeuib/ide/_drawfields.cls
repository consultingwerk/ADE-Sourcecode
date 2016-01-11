 /*************************************************************/
 /* Copyright (c) 2012 by Progress Software Corporation.      */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _drawfields
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

class adeuib.ide._drawfields inherits _ideeventservice: 
     
    define public property TableList         as character no-undo get. set.
    define public property TempTableInfo     as character no-undo get. set.
    define public property Items             as character no-undo get. set.
    define public property Delimiter         as character no-undo get. set.
    define public property ExcludeFieldNames as character no-undo get. set.
    define public property FieldNames        as character no-undo get. set.
    
    method override public void RunEvent():
        run value(ProcedureMethod) in ProcedureHandle 
                   (TableList,
                    TempTableInfo,
                    Items,
                    this-object:Delimiter,
                    ExcludeFieldNames,
                    FieldNames).
    end method.  
    
  

end class.