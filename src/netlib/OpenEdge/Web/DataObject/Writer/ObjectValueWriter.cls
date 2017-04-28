/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ObjectValueWriter
    Purpose     : Writes an object value to the holder. Simple/only objects
                  supported, without any transformations.
    Description : 
    Author(s)   : pjudge
    Created     : 2016-06-14
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
 
class OpenEdge.Web.DataObject.Writer.ObjectValueWriter inherits ArgumentValueWriter:
    
    constructor public ObjectValueWriter ():
        super(get-class(Progress.Lang.Object)).
    end constructor. 
    
    method override public void Write(input pData as Progress.Lang.Object):
        Assert:NotNull(pData, 'Input data').
        
        assign this-object:Value = pData.
    end method.
    
end class.