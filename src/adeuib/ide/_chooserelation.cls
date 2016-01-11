 /*************************************************************/
 /* Copyright (c) 2012 by Progress Software Corporation.      */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _chooserelation
    Purpose     : Call pick parent table for join in _query (query builder)
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sun Feb 12 00:19:17 EST 2012
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using adeuib._ideeventservice.
routine-level on error undo, throw.
class adeuib.ide._chooserelation inherits _ideeventservice: 
     
    define public property CurrentName  as character no-undo get. set.
    define public property TableName    as character no-undo get. set.
    define public property ParentName   as character no-undo get. set.
    define public property Join         as logical no-undo get. set.
    
    method override public void RunEvent():
        run value(ProcedureMethod) in ProcedureHandle 
                   (CurrentName,
                    TableName,
                    ParentName,
                    this-object:Join).
    end method.  
    
  

end class.