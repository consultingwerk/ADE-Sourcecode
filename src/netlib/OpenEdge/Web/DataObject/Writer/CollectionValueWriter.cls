/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : CollectionValueWriter
    Purpose     : Writes values into an ICollection
    Description : 
    Author(s)   : pjudge
    Created     : 2018-04-19
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.Collection.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.DateHolder.
using OpenEdge.Core.DateTimeHolder.
using OpenEdge.Core.DateTimeTzHolder.
using OpenEdge.Core.LogicalValue.
using OpenEdge.Core.String.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.Integer.
using OpenEdge.Core.Decimal.

class OpenEdge.Web.DataObject.Writer.CollectionValueWriter inherits ArgumentValueWriter:
    constructor public CollectionValueWriter():
        super(get-class(ICollection)).
    end constructor.
    
    method override public void Clear():
        cast(this-object:Value, ICollection):Clear().
    end method.
    
    method override public void Open():
        /* If nothing's passed in, use a Collection of our own. 
           Don't do this in the constructor as a micro-optimisation (yes, I know) */
        if not valid-object(this-object:Value) then
            assign this-object:Value = new Collection().
        
        super:Open().
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object extent):
        cast(this-object:Value, ICollection):AddArray(pData).
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        cast(this-object:Value, ICollection):Add(pData).
    end method.
    
    method override public void Write(input phData as handle):
        cast(this-object:Value, ICollection):Add(new WidgetHandle(phData)).
    end method.
    
    method override public void Write(input pValue as memptr):
        cast(this-object:Value, ICollection):Add(new Memptr(pValue)).
    end method.
    
    method override public void Write(input pValue as longchar):
        cast(this-object:Value, ICollection):Add(new String(pValue)).
    end method.
    
    method override public void Write(input pValue as character):
        cast(this-object:Value, ICollection):Add(new String(pValue)).
    end method.
    
    method override public void Write(input pValue as raw):
        cast(this-object:Value, ICollection):Add(new Memptr(pValue)).
    end method.
    
    method override public void Write(input pValue as int64):
        cast(this-object:Value, ICollection):Add(new Integer(pValue)).    
    end method.
    
    method override public void Write(input pValue as integer):
        cast(this-object:Value, ICollection):Add(new Integer(pValue)).
    end method.
    
    method override public void Write(input pValue as logical):
        cast(this-object:Value, ICollection):Add(new LogicalValue(pValue)).
    end method.
    
    method override public void Write(input pValue as decimal):
        cast(this-object:Value, ICollection):Add(new Decimal(pValue)).
    end method.
    
    method override public void Write(input pValue as date):
        cast(this-object:Value, ICollection):Add(new DateHolder(pValue)).
    end method.
    
    method override public void Write(input pValue as datetime):
        cast(this-object:Value, ICollection):Add(new DateTimeHolder(pValue)).
    end method.
    
    method override public void Write(input pValue as datetime-tz):
        cast(this-object:Value, ICollection):Add(new DateTimeTzHolder(pValue)).
    end method.
    
end class.