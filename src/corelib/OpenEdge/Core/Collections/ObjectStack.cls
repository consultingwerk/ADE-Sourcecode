/************************************************
Copyright (c)  2013, 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ObjectStack
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 05 13:50:43 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.ObjectStack.
using OpenEdge.Core.Collections.Stack.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.ObjectStack serializable inherits Stack:
        
    constructor public ObjectStack (poArray as Object extent):
        super(poArray).
    end constructor.
    
    constructor public ObjectStack (piDepth as integer):
        super(piDepth).
    end constructor.

    constructor public ObjectStack():
        /* Default constructor */
    end constructor.
    
    method public void Push(poValue as Object):
        super:ObjectPush(poValue).
    end method.
    
    method public Object Peek():
        return super:ObjectPeek().
    end method.
    
    method public Object Pop():
        return super:ObjectPop().
    end method.
    
    method public Object extent ToArray():
        return super:ObjectToArray().
    end method.
    
end class.
