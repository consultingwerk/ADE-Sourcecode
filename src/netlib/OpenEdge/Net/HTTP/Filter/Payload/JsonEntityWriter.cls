/************************************************
Copyright (c) 2015-2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : JsonEntityWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : - Write() operations are destructive (they replace the existing
                    Entity).
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
using Ccs.Common.Support.ILogicalArrayHolder.
using Ccs.Common.Support.ILogicalHolder.
using Ccs.Common.Support.ILongcharArrayHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IMemptrArrayHolder.
using Ccs.Common.Support.IMemptrHolder.
using Ccs.Common.Support.IPrimitiveArrayHolder.
using Ccs.Common.Support.IRowidArrayHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.IMapEntry.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.IObjectArrayHolder.
using OpenEdge.Core.KeyValuePair.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.StringConstant.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.HttpHeader.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using Progress.Lang.Object.
using Progress.Reflect.DataType.

class OpenEdge.Net.HTTP.Filter.Payload.JsonEntityWriter inherits MessageWriter:
    // we may parse multiple inputs; keep this around
    define private variable moParser as ObjectModelParser no-undo.
    
    /* Default constructor */    
    constructor public JsonEntityWriter():
        super(get-class(JsonConstruct)).
    end constructor. 
    
    /* Opens the writer */
    method override public void Open():       
        super:Open().
        
        assign moParser = new ObjectModelParser().
    end method.
    
    /* Closes the writer */
    method override public void Close():
        super:Close().
        
        assign moParser = ?.
    end method.
    
    /* Writes an HTTP  Cookie into a JSON property & value
       
       @param Cookie THe cookie to write        */
    method private JsonObject Write(input pCookie as Cookie):
        define variable cookie as JsonObject no-undo.
        
        assign cookie = new JsonObject().
        cookie:Add('name':u, pCookie:Name).
        cookie:Add('value':u, pCookie:Value).
        cookie:Add('path':u, pCookie:Path).
        cookie:Add('domain':u, pCookie:Domain).
        cookie:Add('expires':u, pCookie:ExpiresAt).
        cookie:Add('httpOnly':u, pCookie:HttpOnly).
        cookie:Add('secure':u, pCookie:Secure).
        
        return cookie.
    end method.

    /* Writes an HTTP header into a JSON property & value
       
       @param HttpHeader The header to write */
    method private JsonObject Write(input pHeader as HttpHeader):
        define variable hdr as JsonObject no-undo.
        
        assign hdr = new JsonObject().
        hdr:Add('name':u, pHeader:Name).
        hdr:Add('value':u, pHeader:GetBaseValue() + pHeader:GetParameterValues()). 
    end method.
    
    /* Writes a tuple (key-value pair) as a JSON property & value
       
       @param Progress.Lang.Object The key value - property name (required)
       @param Progress.Lang.Object A value to be written for teh proeprty. May be null. */
    method private void WriteTuple(input pKey as Progress.Lang.Object,
                                   input pValue as Progress.Lang.Object):
        define variable jsonData as JsonObject no-undo.
        define variable jsonArray as JsonArray no-undo.
        define variable methodName as character no-undo.
        define variable handleArray as handle extent no-undo.
        define variable memptrArray as memptr extent no-undo.
        define variable objectArray as Progress.Lang.Object extent no-undo.
        define variable cnt as integer no-undo.
        define variable maxCnt as integer no-undo.
        define variable keyValue as OpenEdge.Core.String no-undo.
        define variable intArray as integer extent no-undo.
        define variable i64Array as int64 extent no-undo.
        define variable lcArray as longchar extent no-undo.
        define variable chrArray as character extent no-undo.
        define variable logArray as logical extent no-undo.
        define variable ridArray as rowid extent no-undo.
        define variable dtArray as datetime extent no-undo.
        define variable dtzArray as datetime-tz extent no-undo.
        define variable dayArray as date extent no-undo.
        define variable decArray as decimal extent no-undo.
        
        Assert:NotNull(pKey, 'Tuple key').
        
        if valid-object(this-object:Entity) then
        do:
            if type-of(this-object:Entity, JsonObject) then
                assign jsonData = cast(this-object:Entity, JsonObject).
            else
            // JsonArray
            do:
                assign jsonData = new JsonObject().
                cast(this-object:Entity, JsonArray):Add(jsonData).
            end.
        end.
        else
            assign jsonData           = new JsonObject()
                   this-object:Entity = jsonData.
        
        /* We're going to use reflection because of the mucking about
           with the various data type passing */
        if jsonData:Has(pKey:ToString()) then
            assign methodName = 'Set':u.
        else
            assign methodName = 'Add':u.
        
        case true:
            when not valid-object(pValue) then
                dynamic-invoke(jsonData, methodName + 'Null':u, pKey:ToString()).
            
            /* PRIMITIVE SCALAR */
            when type-of(pValue, ILongcharHolder) then
                dynamic-invoke(jsonData, methodName, pKey:ToString(),
                               cast(pValue, ILongcharHolder):Value).
            
            when type-of(pValue, IInt64Holder) then
                dynamic-invoke(jsonData, methodName, pKey:ToString(),
                               cast(pValue, IInt64Holder):Value).
            
            when type-of(pValue, IDecimalHolder) then
                dynamic-invoke(jsonData, methodName, pKey:ToString(),
                               cast(pValue, IDecimalHolder):Value).
            
            when type-of(pValue, ILogicalHolder) then
                dynamic-invoke(jsonData, methodName, pKey:ToString(),
                               cast(pValue, ILogicalHolder):Value).
            
            when type-of(pValue, IDateTimeTzHolder) then
                dynamic-invoke(jsonData, methodName, pKey:ToString(),
                               cast(pValue, IDateTimeTzHolder):Value).
            
            when type-of(pValue, IDateHolder) then
                dynamic-invoke(jsonData, methodName, pKey:ToString(),
                               cast(pValue, IDateHolder):Value).
            
            when type-of(pValue, IDateTimeHolder) then
                dynamic-invoke(jsonData, methodName, pKey:ToString(),
                               cast(pValue, IDateTimeHolder):Value).
            
            when type-of(pValue, IMemptrHolder) then
                dynamic-invoke(jsonData, methodName, pKey:ToString(),
                               base64-encode(cast(pValue, IMemptrHolder):Value)).
            
            when type-of(pValue, IHandleHolder) then
            do:
                assign extent(handleArray) = ?
                       extent(handleArray) = 1
                       handleArray[1]      = cast(pValue, IHandleHolder):Value
                       .
                if not valid-handle(handleArray[1]) then
                    jsonArray:AddNull().
                else
                    dynamic-invoke(jsonData, methodName, pKey:ToString(),
                                   handleArray[1]).
            end.        // handles 
            
            /* PRIMITIVE ARRAY */
            when type-of(pValue, IIntegerArrayHolder) then
            do:
                assign intArray = cast(pValue, IIntegerArrayHolder):Value.
                 
                if extent(intArray) eq ? then
                    dynamic-invoke(jsonData, methodName + 'Null':u, pKey:ToString()).
                else
                    dynamic-invoke(jsonData, methodName, pKey:ToString(), new JsonArray(intArray)).
            end.
            
            when type-of(pValue, IInt64ArrayHolder) then
            do:
                assign i64Array = cast(pValue, IInt64ArrayHolder):Value.
                 
                if extent(i64Array) eq ? then
                    dynamic-invoke(jsonData, methodName + 'Null':u, pKey:ToString()).
                else
                    dynamic-invoke(jsonData, methodName, pKey:ToString(), new JsonArray(i64Array)).
            end.
            
            when type-of(pValue, ILongcharArrayHolder) then
            do:
                assign lcArray = cast(pValue, ILongcharArrayHolder):Value.
                
                if extent(lcArray) eq ? then
                    dynamic-invoke(jsonData, methodName + 'Null':u, pKey:ToString()).
                else
                    dynamic-invoke(jsonData, methodName, pKey:ToString(), new JsonArray(lcArray)).
            end.
            
            when type-of(pValue, ICharacterArrayHolder) then
            do:
                assign chrArray = cast(pValue, ICharacterArrayHolder):Value.
                
                if extent(chrArray) eq ? then
                    dynamic-invoke(jsonData, methodName + 'Null':u, pKey:ToString()).
                else
                    dynamic-invoke(jsonData, methodName, pKey:ToString(), new JsonArray(chrArray)).
            end.
            
            when type-of(pValue, IDecimalArrayHolder) then
            do:
                assign decArray = cast(pValue, IDecimalArrayHolder):Value.
                
                if extent(decArray) eq ? then
                    dynamic-invoke(jsonData, methodName + 'Null':u, pKey:ToString()).
                else
                    dynamic-invoke(jsonData, methodName, pKey:ToString(), new JsonArray(decArray)).
            end.
            
            when type-of(pValue, ILogicalArrayHolder) then
            do:
                assign logArray = cast(pValue, ILogicalArrayHolder):Value.
                
                if extent(logArray) eq ? then
                    dynamic-invoke(jsonData, methodName + 'Null':u, pKey:ToString()).
                else
                    dynamic-invoke(jsonData, methodName, pKey:ToString(), new JsonArray(logArray)).
            end.
            
            when type-of(pValue, IRowidArrayHolder) then
            do:
                assign ridArray = cast(pValue, IRowidArrayHolder):Value.
                
                if extent(ridArray) eq ? then
                    dynamic-invoke(jsonData, methodName + 'Null':u, pKey:ToString()).
                else
                    dynamic-invoke(jsonData, methodName, pKey:ToString(), new JsonArray(ridArray)).
            end.
            
            when type-of(pValue, IDateArrayHolder) then
            do:
                assign dayArray = cast(pValue, IDateArrayHolder):Value.
                
                if extent(ridArray) eq ? then
                    dynamic-invoke(jsonData, methodName + 'Null':u, pKey:ToString()).
                else
                    dynamic-invoke(jsonData, methodName, pKey:ToString(), new JsonArray(dayArray)).
            end.
            
            when type-of(pValue, IDateTimeArrayHolder) then
            do:
                assign dtArray = cast(pValue, IDateTimeArrayHolder):Value.
                
                if extent(ridArray) eq ? then
                    dynamic-invoke(jsonData, methodName + 'Null':u, pKey:ToString()).
                else
                    dynamic-invoke(jsonData, methodName, pKey:ToString(), new JsonArray(dtArray)).
            end.
            
            when type-of(pValue, IDateTimeTzArrayHolder) then
            do:
                assign dtzArray = cast(pValue, IDateTimeTzArrayHolder):Value.
                
                if extent(ridArray) eq ? then
                    dynamic-invoke(jsonData, methodName + 'Null':u, pKey:ToString()).
                else
                    dynamic-invoke(jsonData, methodName, pKey:ToString(), new JsonArray(dtzArray)).
            end.
            
            when type-of(pValue, IMemptrArrayHolder) then
            do on error undo, throw:
                assign memptrArray = cast(pValue, IMemptrArrayHolder):Value
                       maxCnt      = extent(memptrArray)
                       jsonArray   = new JsonArray().
                do cnt = 1 to maxCnt on error undo, throw:
                    jsonArray:Add(base64-encode(memptrArray[cnt])).
                    finally:
                        set-size(memptrArray[cnt]) = 0.
                    end finally.
                end.
                
                dynamic-invoke(jsonData, methodName, pKey:ToString(), jsonArray).
            end.    // MEMPTR array
            
            when type-of(pValue, IHandleArrayHolder) then
            do:
                assign handleArray = cast(pValue, IHandleArrayHolder):Value
                       maxCnt      = extent(handleArray)
                       jsonArray   = new JsonArray().
                do cnt = 1 to maxCnt:
                    jsonArray:Add(handleArray[cnt]).
                end.
                dynamic-invoke(jsonData, methodName, pKey:ToString(), jsonArray).
            end.    // HANDLE array
            
            /* JSON  */
            when type-of(pValue, JsonObject) then
                dynamic-invoke(jsonData, methodName, pKey:ToString(), cast(pValue, JsonObject)).
            
            when type-of(pValue, JsonArray) then
                dynamic-invoke(jsonData, methodName, pKey:ToString(), cast(pValue, JsonArray)).
            
            /* OTHER OBJECTS */
            when type-of(pValue, IObjectArrayHolder) then
            do:
                assign objectArray = cast(pValue, IObjectArrayHolder):Value
                       maxCnt      = extent(objectArray)
                       jsonArray   = new JsonArray().
                do cnt = 1 to maxCnt:
                    if valid-object(objectArray[cnt]) then
                        jsonArray:Add(objectArray[cnt]:ToString()).
                    else
                        jsonArray:AddNull().
                end.
                dynamic-invoke(jsonData, methodName, pKey:ToString(), jsonArray).
            end.
            
            otherwise
                dynamic-invoke(jsonData, methodName, pKey:ToString(), pValue:ToString()).
        end case.
    end method.
    
    method private void WriteMap(input pValue as IMap):
        define variable jsonData as JsonObject no-undo.
        define variable iterator as IIterator no-undo.
        define variable mapEntry as IMapEntry no-undo.
        
        if     valid-object(this-object:Entity) 
           and type-of(this-object:Entity, JsonObject) then
            assign jsonData = cast(this-object:Entity, JsonObject).
        else
            assign jsonData           = new JsonObject()
                   this-object:Entity = jsonData.
        
        assign iterator   = pValue:EntrySet:Iterator().
        do while iterator:HasNext():
            assign mapEntry = cast(iterator:Next(), IMapEntry).
            
            WriteTuple(mapEntry:Key, mapEntry:Value).
            
            iterator:Next().
        end.
    end method.
    
    method private void WriteError(input poError as Progress.Lang.Error):
        define variable oResponse as JsonObject no-undo.
        define variable oError as JsonObject no-undo.
        define variable oErrorList as JsonArray no-undo.
        define variable iLoop as integer no-undo.
        define variable cRetVal as character no-undo.
        define variable iMax as integer no-undo.
        define variable oProp as Progress.Reflect.Property no-undo.
        define variable oInner as Progress.Lang.Error no-undo.

        Assert:NotNull(poError, 'Error').
        
        /* build the current error */
         assign oResponse  = new JsonObject()
               oErrorList = new JsonArray()
               iMax       = poError:NumMessages
               .
        if type-of(poError, AppError) then
            oResponse:Add('_retVal':u, cast(poError, AppError):ReturnValue).
        
        oResponse:Add('_errors':u, oErrorList).
        do iLoop = 1 to iMax:
            assign oError = new JsonObject().
            oErrorList:Add(oError).
            
            oError:Add('_errorMsg':u, poError:GetMessage(iLoop)).
            oError:Add('_errorNum':u, poError:GetMessageNum(iLoop)).
        end.
        
        case true:
            // single error? add an simple JSON object
            when not valid-object(this-object:Entity) then
                assign this-object:Entity = oResponse.
            
            // if there's already an array, add to it                
            when type-of(this-object:Entity, JsonArray) then
                cast(this-object:Entity, JsonArray):Add(oResponse).
            
            // if there's a single json object, switch to an array
            when type-of(this-object:Entity, JsonObject) then
            do:
                assign oErrorList = new JsonArray().
                oErrorList:Add(cast(this-object:Entity, JsonObject)).
                oErrorList:Add(oResponse).
                
                assign this-object:Entity = oErrorList.
            end.
        end case.
        
        if session:debug-alert then
            oResponse:Add('_type':u, poError:GetClass():TypeName).
            
        if poError:CallStack ne ? then
        do:
            assign oErrorList = new JsonArray()
                   iMax       = num-entries(poError:CallStack, StringConstant:LF)
                   .
            oResponse:Add('_stack':u, oErrorList).
            do iLoop = 1 to iMax:
                oErrorList:Add(entry(iLoop, poError:CallStack, StringConstant:LF)).
            end.
        end.
        
        assign oProp = poError:GetClass():GetProperty('InnerError':u).
        if valid-object(oProp) and
           oProp:DataType eq DataType:Object and
           Progress.Lang.Class:GetClass(oProp:DataTypeName):IsA(get-class(Progress.Lang.Error)) then
        do:           
            assign oInner = oProp:Get(poError).
            if valid-object(oInner) then
                this-object:WriteError(oInner).
        end.
    end method.
    
    /** Write data to/from the message

        @param Progress.Lang.Object Data to write 
        @return int64 The number ofbytes written 
        @throws P.L.AppError if an type is not supported */
    method override public int64 Write(input poData as Object):
        define variable oBody as class Memptr no-undo.
        
        Assert:NotNull(poData).
        
        case true:
            when type-of(poData, Progress.Lang.Error) then
            do:
                WriteError(cast(poData, Progress.Lang.Error)).
                return 0.
            end.
            
            when type-of(poData, Memptr) then
            do:
                assign oBody = cast(poData, Memptr).
                if oBody:Size eq 0 then
                    assign this-object:Entity = new JsonObject().
                else
                    assign this-object:Entity = cast(moParser:Parse(oBody:Value) , JsonConstruct).
                
                return oBody:Size.
            end.
            
            when type-of(poData, JsonConstruct) then
            do:
                assign this-object:Entity = poData.
                return 0.
            end.
            
            when type-of(poData, ByteBucket) then
            do:
                assign oBody = cast(poData, ByteBucket):GetBytes().
                if oBody:Size eq 0 then
                    assign this-object:Entity = new JsonObject().
                else
                    assign this-object:Entity = cast(moParser:Parse(oBody:Value) , JsonConstruct).
                
                return oBody:Size.
            end.
            
            when type-of(poData, IMap) then
            do:
                this-object:WriteMap(cast(poData, IMap)).
                return 0.
            end.
            
            when type-of(poData, IMapEntry) then
            do:
                this-object:WriteTuple(cast(poData, IMapEntry):Key,
                                       cast(poData, IMapEntry):Value).
                return 0.
            end.

            when type-of(poData, KeyValuePair) then
            do:
                this-object:WriteTuple(cast(poData, KeyValuePair):Key,
                                       cast(poData, KeyValuePair):Value).
                return 0.
            end.
            
            when type-of(poData, ILongcharHolder) then
                return this-object:Write(cast(poData, ILongcharHolder):Value).
            
            when type-of(poData, ICharacterHolder) then
                return this-object:Write(cast(poData, ICharacterHolder):Value).
            
            when type-of(poData, IPrimitiveArrayHolder) then
            case true:
                when type-of(poData, ICharacterArrayHolder) then
                    assign this-object:Entity = new JsonArray(cast(poData, ICharacterArrayHolder):Value).
                when type-of(poData, IDateArrayHolder) then
                    assign this-object:Entity = new JsonArray(cast(poData, IDateArrayHolder):Value).
                when type-of(poData, IDateTimeArrayHolder) then
                    assign this-object:Entity = new JsonArray(cast(poData, IDateTimeArrayHolder):Value). 
                when type-of(poData, IDateTimeTzArrayHolder) then
                    assign this-object:Entity = new JsonArray(cast(poData, IDateTimeTzArrayHolder):Value).
                when type-of(poData, IDecimalArrayHolder) then
                    assign this-object:Entity = new JsonArray(cast(poData, IDecimalArrayHolder):Value).
                when type-of(poData, IHandleArrayHolder) then
                    assign this-object:Entity = new JsonArray(cast(poData, IHandleArrayHolder):Value).
                when type-of(poData, IInt64ArrayHolder) then
                    assign this-object:Entity = new JsonArray(cast(poData, IInt64ArrayHolder):Value).
                when type-of(poData, IIntegerArrayHolder) then
                    assign this-object:Entity = new JsonArray(cast(poData, IIntegerArrayHolder):Value).
                when type-of(poData, ILogicalArrayHolder) then
                    assign this-object:Entity = new JsonArray(cast(poData, ILogicalArrayHolder):Value).
                when type-of(poData, ILongcharArrayHolder) then
                    assign this-object:Entity = new JsonArray(cast(poData, ILongcharArrayHolder):Value).
                when type-of(poData, IMemptrArrayHolder) then
                    assign this-object:Entity = new JsonArray(cast(poData, IMemptrArrayHolder):Value).
                when type-of(poData, IRowidArrayHolder) then
                    assign this-object:Entity = new JsonArray(cast(poData, IRowidArrayHolder):Value).
            end case.   // individual primitive array types
                       
            when type-of(poData, IHandleHolder) then
                return this-object:WriteHandle(cast(poData, IHandleHolder):Value).
            
            when type-of(poData, Cookie) then
                return this-object:Write(this-object:Write(cast(poData, Cookie))).

            when type-of(poData, HttpHeader) then
                return this-object:Write(this-object:Write(cast(poData, HttpHeader))).
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                            , 0).
        end case.
        
        return 0.
    end method.
    
    /** Write data to/from the message

        @param longchar Data to write 
        @return int64 The number ofbytes written */
    method override public int64 Write(input pcData as longchar):
        define variable iBytesWritten as integer no-undo.
        
        assign iBytesWritten = length(pcData, 'raw':u).
        
        Assert:IsZeroOrPositive(iBytesWritten, 'Data').
        
        if iBytesWritten eq 0 then
            assign this-object:Entity = new JsonObject().
        else
            assign this-object:Entity = cast(moParser:Parse(pcData), JsonConstruct).
        
        return iBytesWritten.
    end method.

    /** Write data to/from the message

        @param memptr Data to write 
        @return int64 The number ofbytes written */
    method override public int64 Write( input pmData as memptr):
        define variable iBytesWritten as integer no-undo.

        assign iBytesWritten = get-size(pmData).
        Assert:IsZeroOrPositive(iBytesWritten, 'Data size').
        
        if iBytesWritten eq 0 then
            assign this-object:Entity = new JsonObject().
        else
           assign this-object:Entity = cast(moParser:Parse(pmData), JsonConstruct).
        
        return iBytesWritten.
    end method.
    
    /** Write data to/from the message

        @param handle Data to write 
        @return int64 The number ofbytes written */
    method public int64 WriteHandle(input phData as handle):
        return this-object:Write(phData).
    end method.
    
    /** Write data to/from the message

        @param handle Data to write 
        @return int64 The number ofbytes written */
    method override public int64 Write(input phData as handle):
        define variable lOk as logical no-undo.
        define variable oData as JsonObject no-undo.
        
        Assert:NotNull(phData, 'Data').
        
        case phData:type:
            when DataTypeHelper:GetMask(DataTypeEnum:Buffer) or
            when DataTypeHelper:GetMask(DataTypeEnum:TempTable) or
            when DataTypeHelper:GetMask(DataTypeEnum:Dataset) then
                assign oData = new JsonObject()
                       this-object:Entity = oData
                       lOk = oData:Read(phData)
                       .
            
            /* this should cater for WEB-CONTEXT and that only. */
            when 'pseudo-widget':u then            
                if lookup('HTML-CHARSET':u, list-query-attrs(phData)) gt 0 then
                    assign this-object:Entity = cast(moParser:Parse(phData), JsonConstruct).
        end case.
        
        return ?.
    end method.
    
    /** Write data to/from the message

        @param character Data to write 
        @return int64 The number ofbytes written */
    method override public int64 Write(input pcData as character):
        define variable iBytesWritten as integer no-undo.
        
        assign iBytesWritten = length(pcData, 'raw':u).
        
        Assert:IsZeroOrPositive(iBytesWritten, 'Data').

        if iBytesWritten eq 0 then
            assign this-object:Entity = new JsonObject().
        else
            assign this-object:Entity = cast(moParser:Parse(pcData), JsonConstruct).
        
        return iBytesWritten.
    end method.    
    
end class.