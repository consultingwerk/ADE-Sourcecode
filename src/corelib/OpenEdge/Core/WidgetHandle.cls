/************************************************
Copyright (c)  2013, 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
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
                  * By default the handle will not be destroyed/deleted. Set 
                    the AutoDestroy property to TRUE to cleanup automatically.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IHandleHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.WidgetHandle.
using Progress.Lang.Object.
 
class OpenEdge.Core.WidgetHandle serializable
        implements IHandleHolder:
             
    define public property Value as handle no-undo get. private set.
    
    /** Indicates whether the handle will be destroyed/cleared when this object
        is destroyed. Default is FALSE. */
    define public property AutoDestroy as logical initial false no-undo get. set.
    
    constructor public WidgetHandle():
        this-object(?).
    end constructor.

    destructor public WidgetHandle():
        if AutoDestroy then
            delete object this-object:Value no-error.
    end destructor.
    
    constructor public WidgetHandle(input phValue as handle):
        this-object(phValue, false).
    end constructor.

    constructor public WidgetHandle(input phValue as handle,
                                    input plAutoDestroy as logical):
        super().
        
        Assert:NotUnknown(plAutoDestroy, 'Auto destroy').
        assign this-object:AutoDestroy = plAutoDestroy
               this-object:Value       = phValue.
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
