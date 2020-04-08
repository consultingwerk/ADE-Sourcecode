/* *************************************************************************************************************************
Copyright (c) 2016-2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OperationParameter
    Purpose     : This is the definition of a single parameter for an operation - not the value
                  (that's the Operation Argument) but the ioMode, the types etc
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu May 19 09:36:26 EDT 2016
    Notes       : * IOModeEnum should only be INPUT, OUTPUT, INPUT-OUTPUT, RETURN
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
using OpenEdge.Core.Assert.
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Core.StringConstant.
using OpenEdge.Web.DataObject.MessageElement.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.OperationParameter:
    /* (mandatory) The IO mode of this parameter */
    define public property IOMode as IOModeEnum no-undo get. private set.
    
    /* (mandatory) The INPUT http/message element type */
    define public property InputElement as MessageElement extent no-undo get. set.
    
    /* (mandatory) The OUTPUT http/message element type */
    define public property OutputElement as MessageElement extent no-undo get. set.
    
    /* (optional) Name of the ABL paramater - usually for info */
    define public property ABLName as character no-undo get. set.
    
    /* (mandatory) Name of the ABL datatype parameter */
    define public property ABLType as character no-undo get. private set.
    
    /* (mandatory) Indication of whether this is a complex/data type */
    define public property HasSchema as logical no-undo get. private set.
    
    /* (mandatory) TRUE if the argument an array (trailing EXTENT) */
    define public property IsArray as logical no-undo get. private set.
    
    /* (mandatory) TRUE if the argument a primtive value (non-CLASS) */
    define public property IsPrimitive as logical no-undo get. private set.
    
    /* (mandatory) The ABL type (CLASS, CHARACTER etc) */
    define public property DataType as character no-undo get. private set.
    
    /* (mandatory) The default argument type into which the value is stored; based on the ABL type. May end up being overridden
       in the argument value (eg a dataset-handle may be stored in JSON form */
    define public property ArgumentType  as class Progress.Lang.Class no-undo get. private set.
    
    /* Constructor
       
       @param IOModeEnum (mandatory) The IO mode of this parameter
       @param character (mandatory) The ABL data type
       @param character (mandatory) The ABL name of the parameter 
       @param integer (mandatory) The index of this parameter in the operation */
    constructor public OperationParameter(input poIOMode as IOModeEnum,
                                          input pcABLType as character,
                                          input pcABLName as character ):
        Assert:NotNull(poIOMode, 'IO Mode').
        Assert:NotNull(pcABLName, 'ABL name').
        Assert:NotNullOrEmpty(pcABLType, 'ABL type').
        
        assign this-object:IOMode         = poIOMode
               this-object:ABLName        = pcABLName
               .
        SetArgumentType(pcABLType).
    end constructor.
    
    /* Sets this argument's type-based properties based on the character representation
       
       @param character The ABL type per the */
    method private void SetArgumentType(input pABLType as character):
        define variable ablTypeToken as character extent no-undo.
        
        Assert:NotNullOrEmpty(pABLType, 'ABL type').
        
        // The datatype of the ABL parameter. Must be 'class<space><full.type.name>' for types; 
        // Add '<space>extent' to indicate an array
        assign this-object:ABLType = pABLType
               ablTypeToken        = OpenEdge.Core.String:Split(pABLType, StringConstant:SPACE)
               .
        Assert:HasDeterminateExtent(ablTypeToken, 'ABL type tokens').
        
        assign this-object:IsPrimitive = not (ablTypeToken[1] eq 'class':u)
               this-object:DataType    = ablTypeToken[1]
               this-object:IsArray     = (ablTypeToken[extent(ablTypeToken)] eq 'extent':u) 
               .
        /* defaults */
        if this-object:IsArray then
        case this-object:DataType:
            when 'character':u or
            when 'longchar':u or
            when 'rowid':u then
                assign this-object:ArgumentType = get-class(ILongcharArrayHolder).
            when 'recid':u or
            when 'integer':u or
            when 'int64':u then
                assign this-object:ArgumentType = get-class(IInt64ArrayHolder).
            when 'decimal':u then
                assign this-object:ArgumentType = get-class(IDecimalArrayHolder).
            when 'logical':u then
                assign this-object:ArgumentType = get-class(ILogicalArrayHolder).
            when 'date':u then
                assign this-object:ArgumentType = get-class(IDateArrayHolder).
            when 'datetime':u then
                assign this-object:ArgumentType = get-class(IDateTimeArrayHolder).
            when 'datetime-tz':u then
                assign this-object:ArgumentType = get-class(IDateTimeTzArrayHolder).
            when 'raw':u or
            when 'memptr':u then
                assign this-object:ArgumentType = get-class(IMemptrArrayHolder).
            when 'handle':u then
                assign this-object:ArgumentType = get-class(IHandleArrayHolder).
            when 'table' or
            when 'table-handle':u or
            when 'dataset' or
            when 'dataset-handle':u then
                assign this-object:ArgumentType = get-class(IHandleArrayHolder)
                       this-object:HasSchema    = true.
            when 'class':u then
                assign this-object:ArgumentType = Progress.Lang.Class:GetClass(ablTypeToken[2]).
            otherwise
                undo, throw new AppError(substitute('Invalid ABL type &1 for operation &2', pABLType), 0).
        end case.
        else
        case this-object:DataType:
            when 'character':u or
            when 'longchar':u then
                assign this-object:ArgumentType = get-class(ILongcharHolder).
            when 'integer':u or
            when 'int64':u then
                assign this-object:ArgumentType = get-class(IInt64Holder).
            when 'decimal':u then
                assign this-object:ArgumentType = get-class(IDecimalHolder).
            when 'logical':u then
                assign this-object:ArgumentType = get-class(ILogicalHolder).
            when 'rowid':u then
                assign this-object:ArgumentType = get-class(ILongcharHolder).
            when 'recid':u then
                assign this-object:ArgumentType = get-class(IInt64Holder).
            when 'date':u then
                assign this-object:ArgumentType = get-class(IDateHolder).
            when 'datetime':u then
                assign this-object:ArgumentType = get-class(IDateTimeHolder).
            when 'datetime-tz':u then
                assign this-object:ArgumentType = get-class(IDateTimeTzHolder).
            when 'raw':u or
            when 'memptr':u then
                assign this-object:ArgumentType = get-class(IMemptrHolder).
            when 'handle':u then
                assign this-object:ArgumentType = get-class(IHandleHolder).
            when 'table' or
            when 'table-handle':u or
            when 'dataset' or
            when 'dataset-handle':u then
            do:
                /* special treatment for datasets & temp-tables. Always use dataset handles */
                assign this-object:ArgumentType = get-class(IHandleHolder)
                       this-object:HasSchema    = true
                       .
                if not this-object:DataType eq ablTypeToken[1] + '-handle':u then
                    assign this-object:DataType = substitute('&1-handle':u, ablTypeToken[1]).
                
                // INPUT and IN-OUT parameters must be BY-REF. RETURN is left alone
                // in OUTPUT mode we don't know what the ABL code is doing - or rather can't control 
                // it particularly well - so we force a deep copy out :(
                case true:
                    // don't touch 'pure' Output 
                    when IOMode eq IOModeEnum:Output or
                    when (IOModeEnum:Return and IOMode) eq IOModeEnum:Return then
                        .       // NO-OP for RETURN
                    
                    // force OUTPUT to be by value
                    when IOMode eq (IOModeEnum:ByReference or IOModeEnum:Output) then
                        assign IOMode = IOModeEnum:Output.
                    
                    // this should be INPUT, OUTPUT without BY-REF
                    when not IOMode:IsFlagSet(IOModeEnum:ByReference) then
                        assign IOMode = IOMode:SetFlag(IOModeEnum:ByReference).
                end case.   // by-reference twiddling
            end.    // table/dataset
            when 'class':u then
                assign this-object:ArgumentType = Progress.Lang.Class:GetClass(ablTypeToken[2]).
            otherwise
                undo, throw new AppError(substitute('Invalid ABL type &1', pABLType), 0).
        end case.
        
        // Validate
        Assert:NotNull(this-object:ArgumentType, 'Argument type').
        if this-object:IsPrimitive then
            if this-object:IsArray then
                Assert:IsType(this-object:ArgumentType, get-class(IPrimitiveArrayHolder)).
            else
                Assert:IsType(this-object:ArgumentType, get-class(IPrimitiveHolder)).
    end method.
    
    method override public character ToString():
        return substitute('abl-name:&1 data-type:&2 io-mode:&7 has-schema:&3 arg-type:&4 is-array:&5 is-primitive:&6 num-elem-in:&8 num-elem-out:&9':u,
                            this-object:ABLName,
                            this-object:DataType,
                            this-object:HasSchema,
                            this-object:ArgumentType:TypeName,
                            this-object:IsArray,
                            this-object:IsPrimitive,
                            this-object:IOMode:ToString(),
                            extent(InputElement),
                            extent(OutputElement) ).
    end method.
    
end class

.