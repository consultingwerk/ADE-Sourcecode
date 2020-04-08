/* *************************************************************************************************************************
Copyright (c) 2016, 2018-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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

using Ccs.Common.Support.IDateArrayHolder.
using Ccs.Common.Support.IDateHolder.
using Ccs.Common.Support.IDateTimeArrayHolder.
using Ccs.Common.Support.IDateTimeHolder.
using Ccs.Common.Support.IDateTimeTzArrayHolder.
using Ccs.Common.Support.IDateTimeTzHolder.
using Ccs.Common.Support.IDecimalArrayHolder.
using Ccs.Common.Support.IDecimalHolder.
using Ccs.Common.Support.IHandleArrayHolder.
using Ccs.Common.Support.IHandleHolder.
using Ccs.Common.Support.IInt64ArrayHolder.
using Ccs.Common.Support.IInt64Holder.
using Ccs.Common.Support.ILogicalArrayHolder.
using Ccs.Common.Support.ILogicalHolder.
using Ccs.Common.Support.ILongcharArrayHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IMemptrArrayHolder.
using Ccs.Common.Support.IMemptrHolder.
using Ccs.Common.Support.IPrimitiveArrayHolder.
using Ccs.Common.Support.IPrimitiveHolder.
using Ccs.Common.Support.IRowidArrayHolder.
using Ccs.Common.Support.IRowidHolder.
using OpenEdge.Core.IObjectArrayHolder.
using OpenEdge.Core.KeyValuePair.
using OpenEdge.Core.String.
using OpenEdge.Logging.Logger.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterBuilder.
using Progress.Lang.ParameterList.
using Progress.Reflect.AccessMode.
using Progress.Reflect.Constructor.
using Progress.Reflect.DataType.
using Progress.Reflect.Property.

class OpenEdge.Web.DataObject.Writer.ObjectValueWriter inherits ArgumentValueWriter:
    /* Default constructor */    
    constructor public ObjectValueWriter ():
        this-object(get-class(Progress.Lang.Object)).
    end constructor. 
    
    /* Constructor
       
       @param Progress.Lang.Class The argument type */
    constructor public ObjectValueWriter(input pArgumentType as class Progress.Lang.Class):
        super(pArgumentType).
    end constructor. 
    
    method override public void Open(): 
        define variable ctor as Constructor no-undo.
        define variable paramList as ParameterList no-undo.
            
           // If nothing's passed in, create an instance of the Argument Type
        if     not valid-object(this-object:Value)
           // we must be able to instantiate this type
           and not this-object:ArgumentType:IsAbstract()
           and not this-object:ArgumentType:IsInterface()
        then
        do:
            // Only objects with a default constructor can be instantiated here
            assign paramList = new ParameterList(0)
                   ctor      = this-object:ArgumentType:GetConstructor(paramList)
                   .
            if valid-object(ctor) then
                this-object:Value = this-object:ArgumentType:New().
        end.
        
        super:Open().
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        case true:
            // unknown values are valid too
            when not valid-object(pData) then
                assign this-object:Value = pData.
            
            when type-of(pData, KeyValuePair) then
                this-object:Write(cast(pData, KeyValuePair)).
            
            otherwise
                assign this-object:Value = pData.
        end case.
    end method.
    
    method protected void Write(input pData as KeyValuePair):   
        define variable fieldProperty as Property  no-undo.
        define variable propertyName as character no-undo.
        define variable propertyType as class Progress.Lang.Class no-undo.
        define variable propValueWriter as ArgumentValueWriter no-undo.
        
        assign propertyName = pData:Key:ToString().
        if String:IsNullOrEmpty(propertyName) then
        do:
            Logger:Warn(substitute('Unable to write to property "&1" of argument type "&2". Using entire entire property value instead.',
                                propertyName, 
                                this-object:ArgumentType:TypeName )).
            this-object:Write(pData:Value).
            return.
        end.
        
        if not valid-object(this-object:Value) then
        do:
            Logger:Warn(substitute('Invalid Write(<KVP>) target of argument type "&1". Using entire entire property value instead.',
                                this-object:ArgumentType:TypeName )).
            this-object:Write(pData:Value).
            return.
        end.
        
        // the property must at least be public and instance
        // If the property cannot be found, the GetProperty() call returns ? and does NOT error (hooray)
        assign fieldProperty = this-object:ArgumentType:GetProperty(propertyName). 
        if not valid-object(fieldProperty)
            or not fieldProperty:CanWrite
            or not fieldProperty:SetterAccessMode eq AccessMode:Public
        then
        do:
            Logger:Warn(substitute('Unable to write to property "&1" of argument type "&2". Using entire entire property value instead.',
                                propertyName, 
                                this-object:ArgumentType:TypeName )).
            this-object:Write(pData:Value).
            return.
        end.
        
        Logger:Debug(substitute('Set property &1[&4] (type:&5) of &2 to "&3"',  
                            propertyName, 
                            this-object:ArgumentType:TypeName,
                            pData:Value:ToString(),
                            fieldProperty:Extent,
                            fieldProperty:DataType:ToString() )).
        
        // read value and objectify it
        case fieldProperty:DataType:
            when DataType:Character or
            when DataType:Longchar  then
                if fieldProperty:Extent eq 0 then
                    assign propertyType = get-class(ILongcharHolder).
                else
                    assign propertyType = get-class(ILongcharArrayHolder).
            
            when DataType:Date then
                if fieldProperty:Extent eq 0 then
                    assign propertyType = get-class(IDateHolder).
                else
                    assign propertyType = get-class(IDateArrayHolder).
            
            when DataType:DateTime then
                if fieldProperty:Extent eq 0 then
                    assign propertyType = get-class(IDateTimeHolder).
                else
                    assign propertyType = get-class(IDateTimeArrayHolder).
            
            when DataType:DateTimeTZ then
                if fieldProperty:Extent eq 0 then
                    assign propertyType = get-class(IDateTimeTzHolder).
                else
                    assign propertyType = get-class(IDateTimeTzArrayHolder).
            
            when DataType:Decimal then
                if fieldProperty:Extent eq 0 then
                    assign propertyType = get-class(IDecimalHolder).
                else
                    assign propertyType = get-class(IDecimalArrayHolder).
            
            when DataType:Handle then
                if fieldProperty:Extent eq 0 then
                    assign propertyType = get-class(IHandleHolder).
                else
                    assign propertyType = get-class(IHandleArrayHolder).
            
            when DataType:Int64   or
            when DataType:Integer then
                if fieldProperty:Extent eq 0 then
                    assign propertyType = get-class(IInt64Holder).
                else
                    assign propertyType = get-class(IInt64ArrayHolder).
            
            when DataType:Logical then
                if fieldProperty:Extent eq 0 then
                    assign propertyType = get-class(ILogicalHolder).
                else
                    assign propertyType = get-class(ILogicalArrayHolder).
            
            when DataType:Memptr or
            when DataType:Raw    then
                if fieldProperty:Extent eq 0 then
                    assign propertyType = get-class(IMemptrHolder).
                else
                    assign propertyType = get-class(IMemptrArrayHolder).
            
            when DataType:Rowid then
                if fieldProperty:Extent eq 0 then
                    assign propertyType = get-class(IRowidHolder).
                else
                    assign propertyType = get-class(IRowidArrayHolder).
            
            when DataType:Object then
                if fieldProperty:Extent eq 0 then
                    assign propertyType = pData:Value:GetClass().
                else
                    assign propertyType = get-class(IObjectArrayHolder).
        end case.   // property data type
        
        // Convert the message element value to the property data-type 
        assign propValueWriter = ArgumentValueWriterBuilder:Build(propertyType)
                                    :Logger(this-object:Logger)
                                    :Writer.
        if valid-object(propValueWriter) then
        do:
            propValueWriter:Open().
            propValueWriter:Write(pData:Value).
            propValueWriter:Close().
            
            assign pData:Value = propValueWriter:Value.
        end.
        
        // All the 'I*Holder' types have a Value property
        if    type-of(pData:Value, IPrimitiveHolder)
           or type-of(pData:Value, IPrimitiveArrayHolder)
           or type-of(pData:Value, IObjectArrayHolder)
        then
        do:
            // what about ? values
            if not valid-object(pData:Value)
                // need to do this because of PSC00365262
                or dynamic-property(pData:Value, 'Value':u) eq ?
            then
                fieldProperty:Set(this-object:Value, ?).
            else
                fieldProperty:Set(this-object:Value, dynamic-property(pData:Value, 'Value':u)).
        end.
        else
        // a scalar/non-array object is just assigned
        if fieldProperty:DataType eq DataType:Object then
            fieldProperty:Set(this-object:Value, pData:Value).
        else
        // we don't know what this is/what to do
        do:
            Logger:Warn(substitute('Unsupported value &3 for property "&2" of type "&1". Using entire value instead.',
                            fieldProperty:DataType:ToString(),
                            propertyName,
                            pData:Value:GetClass():TypeName )).
            this-object:Write(pData:Value).
        end.
    end method.
    
end class.