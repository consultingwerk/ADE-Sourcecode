/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : StringValueWriter
    Purpose     : Writes values to a ILongcharHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-06-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.

class OpenEdge.Web.DataObject.Writer.StringValueWriter inherits ArgumentValueWriter:
    
    constructor public StringValueWriter ():
        super(get-class(ILongcharHolder)).
    end constructor. 
    
    method override public void Write(input pcData as character):
        assign this-object:Value = new OpenEdge.Core.String(pcData).
    end method.

    method override public void Write(input pcData as longchar):
        assign this-object:Value = new OpenEdge.Core.String(pcData).
    end method.
    
    method override public void Write(input pcData as datetime-tz):
        assign this-object:Value = new OpenEdge.Core.String(iso-date(pcData)).
    end method.

    method override public void Write(input pcData as datetime):
        assign this-object:Value = new OpenEdge.Core.String(string(pcData)).
    end method.

    method override public void Write(input pcData as date):
        assign this-object:Value = new OpenEdge.Core.String(string(pcData)).
    end method.

    method override public void Write(input pcData as decimal):
        assign this-object:Value = new OpenEdge.Core.String(string(pcData)).
    end method.

    method override public void Write(input pcData as int64):
        assign this-object:Value = new OpenEdge.Core.String(string(pcData)).
    end method.

    method override public void Write(input pcData as integer):
        assign this-object:Value = new OpenEdge.Core.String(string(pcData)).
    end method.

    method override public void Write(input pcData as memptr):
        assign this-object:Value = new OpenEdge.Core.String(get-string(pcData, 1)).
    end method.        

    method override public void Write(input pcData as rowid):
        assign this-object:Value = new OpenEdge.Core.String(string(pcData)).
    end method.
    
    method override public void Write(input pcData as recid):
        assign this-object:Value = new OpenEdge.Core.String(string(pcData)).
    end method.
        
    method override public void Write(input poData as Progress.Lang.Object):
        case true:
            when not valid-object(poData) then
                this-object:Write(string(?)).
            
            when type-of(poData, Cookie) then
               this-object:Write(cast(poData, Cookie):Value).
            
            when type-of(poData, HttpHeader) then
               this-object:Write(cast(poData, HttpHeader):Value).
            
            when type-of(poData, ILongcharHolder) then
               this-object:Write(cast(poData, ILongcharHolder):Value).

            otherwise 
                this-object:Write(poData:ToString()).
        end case.
    end method.

end class.