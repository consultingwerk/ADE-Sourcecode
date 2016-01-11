 /*************************************************************/
 /* Copyright (c) 2012 by Progress Software Corporation.      */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _choosesmartobject
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
class adeuib.ide._choosesmartobject inherits _ideeventservice: 
     
    define public property Tool         as character no-undo get. set.
    define public property CustomTool   as character no-undo get. set.
    define public property Attributes   as character no-undo get. set.
    define public property Template     as character no-undo get. set.
    define public property Action       as character no-undo get. set.
    
    method override public void RunEvent():
        run value(ProcedureMethod) in ProcedureHandle 
                   (Tool,
                    CustomTool,
                    Attributes,
                    Template,
                    Action).
    end method.  
    
  

end class.