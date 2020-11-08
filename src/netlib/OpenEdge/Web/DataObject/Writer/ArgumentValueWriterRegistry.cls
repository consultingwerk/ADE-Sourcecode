/* *************************************************************************************************************************
Copyright (c) 2016, 2018-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ArgumentValueWriterRegistry
    Purpose     : Registry for types that hold operation argument values.
    Description : 
    Author(s)   : pjudge
    Created     : 2016-06-07
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterArrayHolder.
using Ccs.Common.Support.ICharacterHolder.
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
using Ccs.Common.Support.IIntegerArrayHolder.
using Ccs.Common.Support.IIntegerHolder.
using Ccs.Common.Support.ILogicalArrayHolder.
using Ccs.Common.Support.ILogicalHolder.
using Ccs.Common.Support.ILongcharArrayHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IMemptrArrayHolder.
using Ccs.Common.Support.IMemptrHolder.
using Ccs.Common.Support.IRowidArrayHolder.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.IObjectArrayHolder.
using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterRegistry.
using OpenEdge.Web.DataObject.Writer.CollectionValueWriter.
using OpenEdge.Web.DataObject.Writer.DataRequestValueWriter.
using OpenEdge.Web.DataObject.Writer.DateArrayValueWriter.
using OpenEdge.Web.DataObject.Writer.DateTimeArrayValueWriter.
using OpenEdge.Web.DataObject.Writer.DateTimeTzArrayValueWriter.
using OpenEdge.Web.DataObject.Writer.DateTimeTzValueWriter.
using OpenEdge.Web.DataObject.Writer.DateTimeValueWriter.
using OpenEdge.Web.DataObject.Writer.DateValueWriter.
using OpenEdge.Web.DataObject.Writer.DecimalArrayValueWriter.
using OpenEdge.Web.DataObject.Writer.DecimalValueWriter.
using OpenEdge.Web.DataObject.Writer.HandleArrayValueWriter.
using OpenEdge.Web.DataObject.Writer.HandleValueWriter.
using OpenEdge.Web.DataObject.Writer.IntegerArrayValueWriter.
using OpenEdge.Web.DataObject.Writer.IntegerValueWriter.
using OpenEdge.Web.DataObject.Writer.JsonArrayValueWriter.
using OpenEdge.Web.DataObject.Writer.JsonObjectValueWriter.
using OpenEdge.Web.DataObject.Writer.LogicalArrayValueWriter.
using OpenEdge.Web.DataObject.Writer.LogicalValueWriter.
using OpenEdge.Web.DataObject.Writer.LongcharArrayValueWriter.
using OpenEdge.Web.DataObject.Writer.MemptrArrayValueWriter.
using OpenEdge.Web.DataObject.Writer.MemptrValueWriter.
using OpenEdge.Web.DataObject.Writer.ObjectArrayValueWriter.
using OpenEdge.Web.DataObject.Writer.ObjectValueWriter.
using OpenEdge.Web.DataObject.Writer.RowidArrayValueWriter.
using OpenEdge.Web.DataObject.Writer.StringValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Web.DataObject.Writer.ArgumentValueWriterRegistry:

    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(ArgumentValueWriterRegistry:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(ArgumentValueWriter)).
                ArgumentValueWriterRegistry:InitializeRegistry(oRegistry).
                assign ArgumentValueWriterRegistry:Registry = oRegistry.
            end.
            return ArgumentValueWriterRegistry:Registry.
        end get.
        private set.
    
    /** Adds initial values into the registry 
        
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        /* primitive scalars */
        poRegistry:Put(get-class(ILogicalHolder):TypeName,      get-class(LogicalValueWriter)).
        poRegistry:Put(get-class(ILongcharHolder):TypeName,     get-class(StringValueWriter)).
        poRegistry:Put(get-class(ICharacterHolder):TypeName,    get-class(StringValueWriter)).
        poRegistry:Put(get-class(IInt64Holder):TypeName,        get-class(IntegerValueWriter)).
        poRegistry:Put(get-class(IIntegerHolder):TypeName,      get-class(IntegerValueWriter)).
        poRegistry:Put(get-class(IDecimalHolder):TypeName,      get-class(DecimalValueWriter)).
        poRegistry:Put(get-class(IDateHolder):TypeName,         get-class(DateValueWriter)).
        poRegistry:Put(get-class(IDateTimeHolder):TypeName,     get-class(DateTimeValueWriter)).
        poRegistry:Put(get-class(IDateTimeTzHolder):TypeName,   get-class(DateTimeTzValueWriter)).
        poRegistry:Put(get-class(IHandleHolder):TypeName,       get-class(HandleValueWriter)).
        poRegistry:Put(get-class(IMemptrHolder):TypeName,       get-class(MemptrValueWriter)).
        
        /* primitive arrays */
        poRegistry:Put(get-class(IInt64ArrayHolder):TypeName,       get-class(IntegerArrayValueWriter)).
        poRegistry:Put(get-class(IIntegerArrayHolder):TypeName,     get-class(IntegerArrayValueWriter)).
        poRegistry:Put(get-class(ILongcharArrayHolder):TypeName,    get-class(LongcharArrayValueWriter)).
        poRegistry:Put(get-class(ICharacterArrayHolder):TypeName,   get-class(LongcharArrayValueWriter)).
        poRegistry:Put(get-class(IDecimalArrayHolder):TypeName,     get-class(DecimalArrayValueWriter)).
        poRegistry:Put(get-class(ILogicalArrayHolder):TypeName,     get-class(LogicalArrayValueWriter)).
        poRegistry:Put(get-class(IRowidArrayHolder):TypeName,       get-class(RowidArrayValueWriter)).
        poRegistry:Put(get-class(IDateArrayHolder):TypeName,        get-class(DateArrayValueWriter)).
        poRegistry:Put(get-class(IDateTimeArrayHolder):TypeName,    get-class(DateTimeArrayValueWriter)).
        poRegistry:Put(get-class(IDateTimeTzArrayHolder):TypeName,  get-class(DateTimeTzArrayValueWriter)).
        poRegistry:Put(get-class(IMemptrArrayHolder):TypeName,      get-class(MemptrArrayValueWriter)).
        poRegistry:Put(get-class(IHandleArrayHolder):TypeName,      get-class(HandleArrayValueWriter)).
        
        /* objects */
        poRegistry:Put(get-class(Progress.Lang.Object):TypeName,    get-class(ObjectValueWriter)).
        poRegistry:Put(get-class(IObjectArrayHolder):TypeName,      get-class(ObjectArrayValueWriter)).
        poRegistry:Put(get-class(JsonObject):TypeName,              get-class(JsonObjectValueWriter)).
        poRegistry:Put(get-class(JsonArray):TypeName,               get-class(JsonArrayValueWriter)).
        poRegistry:Put(get-class(ICollection):TypeName,             get-class(CollectionValueWriter)).
        
        // external-to-netlib writers or keys (Business Logic or other)
        poRegistry:Put('Ccs.BusinessLogic.IGetDataRequest':u,       get-class(DataRequestValueWriter)).
    end method.
    
end class. 