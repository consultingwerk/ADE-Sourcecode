/* *************************************************************************************************************************
Copyright (c) 2016, 2018-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
using Ccs.Common.Support.IPrimitiveHolder.
using OpenEdge.Core.StringConstant.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using OpenEdge.Core.String.

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
        assign this-object:Value = new OpenEdge.Core.String(iso-date(pcData)).
    end method.
    
    method override public void Write(input pcData as date):
        assign this-object:Value = new OpenEdge.Core.String(iso-date(pcData)).
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
    
    method override public void Write(input pData as logical):
        assign this-object:Value = new OpenEdge.Core.String(string(pData)).
    end method.
    
    method override public void Write(input pcData as memptr):
        if    get-size(pcData) eq ?
           or get-size(pcData) eq 0
        then
            assign this-object:Value = String:Empty().
        else
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
                assign this-object:Value = new OpenEdge.Core.String(StringConstant:UNKNOWN).
            
            when type-of(poData, Cookie) then
                assign this-object:Value = new OpenEdge.Core.String(cast(poData, Cookie):Value).
            
            when type-of(poData, HttpHeader) then
                assign this-object:Value = new OpenEdge.Core.String(cast(poData, HttpHeader):Value).
            
            when type-of(poData, ILongcharHolder) then
                assign this-object:Value = cast(poData, ILongcharHolder).
            
            when type-of(poData, IPrimitiveHolder) then
               this-object:Write(dynamic-property(poData, 'Value':u)).
            
            when type-of(poData, JsonObject) then
                assign this-object:Value = new OpenEdge.Core.String(cast(poData, JsonObject):GetJsonText()).
            
            when type-of(poData, JsonArray) then
                assign this-object:Value = new OpenEdge.Core.String(cast(poData, JsonArray):GetJsonText()).
            
            otherwise
                this-object:Write(poData:ToString()).
        end case.
    end method.

end class.