/** ------------------------------------------------------------------------
    File        : WidgetHandle
    Purpose     : Primitive class for widget-handle variables    
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 19 09:47:07 EDT 2011
    Notes       : * Initial requirement for collections; having a class for the
                    primitive value means that we don't have to distinguish between
                    primitives and types, which makes the code more readable.
                  * This class based on the AutoEdge|TheFactory version
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.WidgetHandle.

using Progress.Lang.Class.
using Progress.Lang.Object.
 
class OpenEdge.Lang.WidgetHandle : 
    define public property Value as handle no-undo get. private set.
    
    constructor public WidgetHandle():
        this-object(?).
    end constructor.

    constructor public WidgetHandle(input phValue as handle):
        super().
        
        this-object:Value = phValue.
    end constructor.
    
    method override public logical Equals(input p0 as Object):
        if type-of(p0, WidgetHandle) then
            return (this-object:Value eq cast(p0, WidgetHandle):Value).
        else
            return super:Equals(p0).    
    end method.    
            
    method override public character ToString():
        define variable cValue as character no-undo.
        cValue = string(this-object:Value).
        
        return cValue.
    end method.
end class.
