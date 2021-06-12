/* *************************************************************************************************************************
Copyright (c) 2019-2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : JsonConverter
    Description : Helps to convert to and from JSON, for common/standard (Ccs.Common.Support.I*Holder,
                  OpenEdge.Core.Collections.I*) types 
    Author(s)   : pjudge
    Created     : 2019-11-21
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterArrayHolder.
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
using Ccs.Common.Support.IPrimitiveArrayHolder.
using Ccs.Common.Support.IPrimitiveHolder.
using Ccs.Common.Support.IRowidArrayHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.IMapEntry.
using OpenEdge.Core.DateArrayHolder.
using OpenEdge.Core.DateHolder.
using OpenEdge.Core.DateTimeArrayHolder.
using OpenEdge.Core.DateTimeHolder.
using OpenEdge.Core.DateTimeTzArrayHolder.
using OpenEdge.Core.DateTimeTzHolder.
using OpenEdge.Core.DecimalArrayHolder.
using OpenEdge.Core.HandleArrayHolder.
using OpenEdge.Core.IObjectArrayHolder.
using OpenEdge.Core.IntegerArrayHolder.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.KeyValuePair.
using OpenEdge.Core.LogicalArrayHolder.
using OpenEdge.Core.LogicalValue.
using OpenEdge.Core.LongcharArrayHolder.
using OpenEdge.Core.MemptrArrayHolder.
using OpenEdge.Core.ObjectArrayHolder.
using OpenEdge.Core.RowidArrayHolder.
using OpenEdge.Core.String.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.TimeStamp.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Core.Json.JsonConverter:
    /* Default constructor.
       
       This is private so that this class cannot be instantiated - it's intended to be used with static members only */
    constructor private JsonConverter():
    end constructor.
    
    /* Converts an array of objects into into a JSONArray
       
       Invalid inputs, indeterminate arrays, all get a null value
       
       @param IObjectArrayHolder The input array 
       @return JsonArray An array instance      */
    method static public JsonArray ToArray(input pArray as IObjectArrayHolder):
        return ToArray(pArray:Value). 
    end method.
    
    /* Converts an array of objects into into a JSONArray
       Invalid inputs, indeterminate arrays, all get a null value
       
       @param P.L.Object[] The input array 
       @return JsonArray An array instance      */
    method static public JsonArray ToArray(input pArray as Progress.Lang.Object extent):
        define variable ja as JsonArray no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        
        assign cnt = extent(pArray). 
        if cnt eq ? then
            return ja.
            
        assign ja = new JsonArray(cnt).
        
        do loop = 1 to cnt:
            AddToArray(loop, pArray[loop], ja).
        end.
        
        return ja.
    end method.
    
    /* Converts an instance of a collection into a JSONArray
       Invalid inputs, indeterminate arrays, all get a null value
       
       @param ICollection The input collection
       @return JsonArray An array instance      */
    method static public JsonArray ToArray(input pCollection as ICollection):
        define variable jsonData as JsonArray no-undo.
        define variable iterator as IIterator no-undo.
        define variable idx as integer no-undo.
        
        Assert:NotNull(pCollection, 'Collection').
        
        assign jsonData = new JsonArray(pCollection:Size)
               iterator = pCollection:Iterator()
               .
        do while iterator:HasNext():
            assign idx = idx + 1.
            AddToArray(idx, iterator:Next(), jsonData).
        end.
        
        return jsonData.
    end method.
    
    /* Converts an instance of a IPrimitiveArrayHolder into a JSONArray
       Invalid inputs, indeterminate arrays, all get a null value
       
       @param IPrimitiveArrayHolder The input value
       @return JsonArray An array instance      */
    method static public JsonArray ToArray(input pArray as IPrimitiveArrayHolder):
        define variable cah as ICharacterArrayHolder no-undo.
        define variable lcah as ILongcharArrayHolder no-undo.
        define variable daah as IDateArrayHolder no-undo.
        define variable dtah as IDateTimeArrayHolder no-undo.
        define variable dtzah as IDateTimeTzArrayHolder no-undo.
        define variable lah as ILogicalArrayHolder no-undo.
        define variable iah as IIntegerArrayHolder no-undo.
        define variable i64ah as IInt64ArrayHolder no-undo.
        define variable deah as IDecimalArrayHolder no-undo.
        define variable hah as IHandleArrayHolder no-undo.
        define variable rah as IRowidArrayHolder no-undo.
        define variable mah as IMemptrArrayHolder  no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable ja as JsonArray no-undo.
        
        if valid-object(pArray) then
        case true:
            when type-of(pArray, ICharacterArrayHolder) then
            do:
                assign cah = cast(pArray, ICharacterArrayHolder).
                if not extent(cah:Value) eq ? then
                    return new JsonArray(cah:Value).
            end.
            when type-of(pArray, IDateArrayHolder) then
            do:
                assign daah = cast(pArray, IDateArrayHolder). 
                if not extent(daah:Value) eq ? then
                    return new JsonArray(daah:Value).
            end.
            when type-of(pArray, IDateTimeArrayHolder) then
            do:
                assign dtah = cast(pArray, IDateTimeArrayHolder).
                if not extent(dtah:Value) eq ? then
                    return new JsonArray(dtah:Value).
            end.
            when type-of(pArray, IDateTimeTzArrayHolder) then
            do:
                assign dtzah = cast(pArray, IDateTimeTzArrayHolder). 
                if not extent(dtzah:Value) eq ? then
                    return new JsonArray(dtzah:Value).
            end.
            when type-of(pArray, IDecimalArrayHolder) then
            do:
                assign deah = cast(pArray, IDecimalArrayHolder). 
                if not extent(deah:Value) eq ? then
                    return new JsonArray(deah:Value).
            end.
            when type-of(pArray, IHandleArrayHolder) then
            do:
                assign hah = cast(pArray, IHandleArrayHolder)
                       cnt = extent(hah:Value)  
                       . 
                if not cnt eq ? then
                do:
                    assign ja = new JsonArray(cnt).
                    do loop = 1 to cnt:
                        if valid-handle(hah:Value[loop]) then
                            ja:Set(loop, hah:Value[loop]).
                    end.
                    
                    return ja.
                end.
            end.
            when type-of(pArray, IInt64ArrayHolder) then
            do:
                assign i64ah = cast(pArray, IInt64ArrayHolder). 
                if not extent(i64ah:Value) eq ? then
                    return new JsonArray(i64ah:Value).
            end.
            when type-of(pArray, IIntegerArrayHolder) then
            do:
                assign iah = cast(pArray, IIntegerArrayHolder). 
                if not extent(iah:Value) eq ? then
                    return new JsonArray(iah:Value).
            end.
            when type-of(pArray, ILogicalArrayHolder) then
            do:
                assign lah = cast(pArray, ILogicalArrayHolder). 
                if not extent(lah:Value) eq ? then
                    return new JsonArray(lah:Value).
            end.
            when type-of(pArray, ILongcharArrayHolder) then
            do:
                assign lcah = cast(pArray, ILongcharArrayHolder). 
                if not extent(lcah:Value) eq ? then
                    return new JsonArray(lcah:Value).
            end.
            when type-of(pArray, IMemptrArrayHolder) then
            do:
                assign mah = cast(pArray, IMemptrArrayHolder). 
                if not extent(mah:Value) eq ? then
                    // we don't need to clean up the MEMPTR because it appears that the JsonArray()
                    // constructor doesn't leak
                    return new JsonArray(mah:Value).
            end.
            when type-of(pArray, IRowidArrayHolder) then
            do:
                assign rah = cast(pArray, IRowidArrayHolder). 
                if not extent(rah:Value) eq ? then
                    return new JsonArray(rah:Value).
            end.
        end case.   // individual primitive array types
        
        // invalid inputs, indeterminate arrays, all get a null
        return ?.
    end method.
    
    /* Converts an instance of a KeyValuePair into a JSON Object
       Invalid inputs, indeterminate arrays, all get an
       
       @param KeyValuePair A name/value pair
       @return JsonObject A JSON object  */
    method static public JsonObject ToObject(input pTuple as KeyValuePair):
        define variable jsonData as JsonObject no-undo.
        
        if valid-object(pTuple) then
            assign jsonData = ToObject(pTuple:Key, pTuple:Value). 
        
        return jsonData.
    end method.
    
    /* Converts an kay and value into a JSON Object
       
       @param Progress.Lang.Object The key value - property name (required)
       @param Progress.Lang.Object A value to be written for the property. May be null.
       @return JsonObject A JSON object */
    method static public JsonObject ToObject(input pKey as Progress.Lang.Object,
                                             input pValue as Progress.Lang.Object):
        define variable jsonData as JsonObject no-undo.
        
        if valid-object(pKey) then
        do:
            assign jsonData = new JsonObject().
            AddToObject(pKey, pValue, jsonData).
        end.
        
        return jsonData.
    end method.
    
    /* Converts an instance of a KeyValuePair into a JSON Object
       Invalid inputs, indeterminate arrays, all get an
       
       @param IMap A map (collection of name/value pairs)
       @return JsonObject A JSON object  */
    method static public JsonObject ToObject(input pMap as IMap):
        define variable jsonData as JsonObject no-undo.
        define variable iterator as IIterator no-undo.
        define variable mapEntry as IMapEntry no-undo.
        
        Assert:NotNull(pMap, 'Map').
        
        assign jsonData = new JsonObject()
               iterator = pMap:EntrySet:Iterator()
               .
        do while iterator:HasNext():
            assign mapEntry = cast(iterator:Next(), IMapEntry).
            AddToObject(mapEntry:Key, mapEntry:Value, jsonData).
        end.
        
        return jsonData.
    end method.
    
    /* Converts an instance of a Progress.Lang.Error into a JSON Object
       
       @param Progress.Lang.Error An error. Must exist
       @return JsonObject A JSON object representing the Error */
    method static public JsonObject ToObject(input pError as Progress.Lang.Error):
        define variable jsonData as JsonObject no-undo.
        define variable errData as JsonObject no-undo.
        define variable errList as JsonArray no-undo.
        define variable loop as integer no-undo.
        define variable cRetVal as character no-undo.
        define variable cnt as integer no-undo.
        define variable errProp as Progress.Reflect.Property no-undo.
        define variable innerErr as Progress.Lang.Error no-undo.
        
        Assert:NotNull(pError, 'Error').
        
        /* build the current error */
        assign jsonData = new JsonObject()
               errList  = new JsonArray()
               cnt      = pError:NumMessages
               .
        if type-of(pError, AppError) then
            jsonData:Add('_retVal':u, cast(pError, AppError):ReturnValue).
        
        jsonData:Add('_errors':u, errList).
        do loop = 1 to cnt:
            assign errData = new JsonObject().
            errList:Add(errData).
            
            errData:Add('_errorMsg':u, pError:GetMessage(loop)).
            errData:Add('_errorNum':u, pError:GetMessageNum(loop)).
        end.
        
        // only send debug info if we want debug info sent.
        if session:debug-alert then
        do:
            jsonData:Add('_type':u, pError:GetClass():TypeName).
            
            if not pError:CallStack eq ? then
            do:
                assign errList = new JsonArray()
                       cnt     = num-entries(pError:CallStack, StringConstant:LF)
                       .
                jsonData:Add('_stack':u, errList).
                do loop = 1 to cnt:
                    errList:Add(entry(loop, pError:CallStack, StringConstant:LF)).
                end.
            end.
        end.
        
        assign errProp = pError:GetClass():GetProperty('InnerError':u).
        if     valid-object(errProp)
           and errProp:DataType eq Progress.Reflect.DataType:Object
           and Progress.Lang.Class:GetClass(errProp:DataTypeName):IsA(get-class(Progress.Lang.Error))
        then
        do:
            assign innerErr = errProp:Get(pError).
            if valid-object(innerErr) then
                jsonData:Add('_innerError':u, ToObject(innerErr)).
        end.
        
        return jsonData.
    end method.
    
    /* Adds an instance value into a JSON array
       
       @param integer The index at which to add the value. the array may be extended to this value
       @param Progress.Lang.Object A value to be written for the property. May be null.
       @param JsonObject A JSON array. Must exist.  */
    method static public void AddToArray(input pIdx as integer,
                                         input pValue as Progress.Lang.Object,
                                         input pJson as JsonArray ):
        define variable hdlVal as handle no-undo.
        define variable objectArray as Object extent no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        
        Assert:NotNull(pJson, 'Json array').
        Assert:NotNull(pIdx, 'Array index').
        
        if pIdx gt pJson:Length then
            assign pJson:Length = pIdx.
        
        case true:
            when not valid-object(pValue) then
                pJson:SetNull(pIdx).
            
            // first try the object's own serialization, then the hard-coded ones below
            when type-of(pValue, IJsonSerializer) then
                AddToArray(pIdx, cast(pValue, IJsonSerializer):ToJsonConstruct(), pJson).
            
            /* PRIMITIVE SCALAR */
            when type-of(pValue, ILongcharHolder) then
                pJson:Set(pIdx, cast(pValue, ILongcharHolder):Value).
            
            when type-of(pValue, IInt64Holder) then
                pJson:Set(pIdx, cast(pValue, IInt64Holder):Value).
            
            when type-of(pValue, IDecimalHolder) then
                pJson:Set(pIdx, cast(pValue, IDecimalHolder):Value).
            
            when type-of(pValue, ILogicalHolder) then
                pJson:Set(pIdx, cast(pValue, ILogicalHolder):Value).
            
            when type-of(pValue, IDateTimeTzHolder) then
                pJson:Set(pIdx, cast(pValue, IDateTimeTzHolder):Value).
            
            when type-of(pValue, IDateHolder) then
                pJson:Set(pIdx, cast(pValue, IDateHolder):Value).
            
            when type-of(pValue, IDateTimeHolder) then
                pJson:Set(pIdx, cast(pValue, IDateTimeHolder):Value).
            
            when type-of(pValue, IMemptrHolder) then
                pJson:Set(pIdx, base64-encode(cast(pValue, IMemptrHolder):Value)).
            
            when type-of(pValue, IHandleHolder) then
            do:
                assign hdlVal = cast(pValue, IHandleHolder):Value.
                if not valid-handle(hdlVal) then
                    pJson:SetNull(pIdx).
                else
                    pJson:Set(pIdx,  hdlVal).
            end.        // handles 
            
            /* PRIMITIVE ARRAY */
            when type-of(pValue, IPrimitiveArrayHolder) then
                pJson:Set(pIdx, ToArray(cast(pValue, IPrimitiveArrayHolder))).
            
            /* JSON  */
            when type-of(pValue, JsonObject) then
                pJson:Set(pIdx,  cast(pValue, JsonObject)).
            
            when type-of(pValue, JsonArray) then
                pJson:Set(pIdx,  cast(pValue, JsonArray)).
            
            /* OTHER OBJECTS */
            when type-of(pValue, IObjectArrayHolder) then
                pJson:Set(pIdx, ToArray(cast(pValue, IObjectArrayHolder))).
            
            otherwise
                pJson:Set(pIdx,  pValue:ToString()).
        end case.
    end method.
    
    /* Adds a value into a JSON object for a specific key
       
       @param Progress.Lang.Object The key value - property name (required)
       @param Progress.Lang.Object A value to be written for the property. May be null.
       @param JsonObject A JSON object  */
    //method static private void AddToObject(input pKey as Progress.Lang.Object,
    method static public void AddToObject(input pKey as Progress.Lang.Object,
                                          input pValue as Progress.Lang.Object,
                                          input pJson as JsonObject ):
        define variable methodName as character no-undo.
        define variable hdlVal as handle no-undo.
        define variable objectArray as Progress.Lang.Object extent no-undo.
        define variable cnt as integer no-undo.
        define variable maxCnt as integer no-undo.
        define variable keyValue as OpenEdge.Core.String no-undo.
        
        Assert:NotNull(pJson, 'Json object').
        Assert:NotNull(pKey, 'Tuple key').
        
        /* We're going to use reflection because of the mucking about
           with the various data type passing */
        if pJson:Has(pKey:ToString()) then
            assign methodName = 'Set':u.
        else
            assign methodName = 'Add':u.
        
        case true:
            when not valid-object(pValue) then
                dynamic-invoke(pJson, methodName + 'Null':u, pKey:ToString()).
            
            // first try the object's own serialization, then the hard-coded ones below
            when type-of(pValue, IJsonSerializer) then
                AddToObject(pKey, cast(pValue, IJsonSerializer):ToJsonConstruct(), pJson).
            
            /* PRIMITIVE SCALAR */
            when type-of(pValue, ILongcharHolder) then
                dynamic-invoke(pJson, methodName, pKey:ToString(),
                               cast(pValue, ILongcharHolder):Value).
            
            when type-of(pValue, IInt64Holder) then
                dynamic-invoke(pJson, methodName, pKey:ToString(),
                               cast(pValue, IInt64Holder):Value).
            
            when type-of(pValue, IDecimalHolder) then
                dynamic-invoke(pJson, methodName, pKey:ToString(),
                               cast(pValue, IDecimalHolder):Value).
            
            when type-of(pValue, ILogicalHolder) then
                dynamic-invoke(pJson, methodName, pKey:ToString(),
                               cast(pValue, ILogicalHolder):Value).
            
            when type-of(pValue, IDateTimeTzHolder) then
                dynamic-invoke(pJson, methodName, pKey:ToString(),
                               cast(pValue, IDateTimeTzHolder):Value).
            
            when type-of(pValue, IDateHolder) then
                dynamic-invoke(pJson, methodName, pKey:ToString(),
                               cast(pValue, IDateHolder):Value).
            
            when type-of(pValue, IDateTimeHolder) then
                dynamic-invoke(pJson, methodName, pKey:ToString(),
                               cast(pValue, IDateTimeHolder):Value).
            
            when type-of(pValue, IMemptrHolder) then
                dynamic-invoke(pJson, methodName, pKey:ToString(),
                               base64-encode(cast(pValue, IMemptrHolder):Value)).
            
            when type-of(pValue, IHandleHolder) then
            do:
                assign hdlVal = cast(pValue, IHandleHolder):Value.
                if not valid-handle(hdlVal) then
                    pJson:AddNull(pKey:ToString()).
                else
                    dynamic-invoke(pJson, methodName, pKey:ToString(), hdlVal).
            end.        // handles 
            
            /* PRIMITIVE ARRAY */
            when type-of(pValue, IPrimitiveArrayHolder) then
                dynamic-invoke(pJson, methodName, pKey:ToString(),
                               ToArray(cast(pValue, IPrimitiveArrayHolder))).
            
            /* JSON  */
            when type-of(pValue, JsonObject) then
                dynamic-invoke(pJson, methodName, pKey:ToString(), cast(pValue, JsonObject)).
            
            when type-of(pValue, JsonArray) then
                dynamic-invoke(pJson, methodName, pKey:ToString(), cast(pValue, JsonArray)).
            
            /* OTHER OBJECTS */
            when type-of(pValue, IObjectArrayHolder) then
                dynamic-invoke(pJson, methodName, pKey:ToString(),
                               ToArray(cast(pValue, IObjectArrayHolder))).
            
            otherwise
                dynamic-invoke(pJson, methodName, pKey:ToString(), pValue:ToString()).
        end case.
    end method.
    
    /* Merges (combines) two JSON objects.
       
       Properties are copied from the SOURCE into the TARGET.
       If the property exists in the target, it is overwritten by
       the source property if the pOverwriteExisting flag is TRUE.
       
       @param JsonObject The target JSON object. Must exist.
       @param JsonObject The source JSON object. Can be null 
       @param logical TRUE if properties from the SOURCE object should overwrite those in the TARGET */
    method public static void Merge(input pTarget as JsonObject,
                                    input pSource as JsonObject,
                                    input pOverwriteExisting as logical ):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable names as longchar extent no-undo.
        define variable propName as character no-undo.
        define variable methodName as character no-undo.
        
        Assert:NotNull(pTarget, 'Target JSON object').
        
        if not valid-object(pSource) then
            return.
        
        assign names = pSource:GetNames()
               cnt   = extent(names)
               .
        do loop = 1 to cnt:
            assign propName   = string(names[loop])
                   methodName = 'Add':u
                   .
            if pTarget:Has(propName) then
            do:
                if pOverwriteExisting then
                    assign methodName = 'Set':u.
                else
                    next.
            end.
            
            case pSource:GetType(propName):
                when JsonDataType:NULL    then
                    dynamic-invoke(pTarget, methodName + 'Null':u, propName).
                when JsonDataType:BOOLEAN then
                    dynamic-invoke(pTarget, methodName, propName, pSource:GetLogical(propName)).
                when JsonDataType:ARRAY   then
                    dynamic-invoke(pTarget, methodName, propName, pSource:GetJsonArray(propName)).
                when JsonDataType:OBJECT  then
                    dynamic-invoke(pTarget, methodName, propName, pSource:GetJsonObject(propName)).
                when JsonDataType:STRING  then
                    // The Add/Set methods have overloads that accept longchar, so we won't run into the AddNumber issue
                    dynamic-invoke(pTarget, methodName, propName, pSource:GetJsonText(propName)).
                when JsonDataType:NUMBER  then
                    // Because GetJsonText() returns a LONGCHAR, the reflection fails. It is extremely unlikely
                    // that a number would have >2GB's worth of digits, so just STRING() it.
                    dynamic-invoke(pTarget, methodName + 'Number':u, propName, string(pSource:GetJsonText(propName))).
            end case.
        end.
    end method.

    /* This method converts a JSON property to an instance of an IPRimitiveHolder.
    
       If the inputs are invalid, an object represeting the unknown value is returned.
       If the property value cannot be converted, an object represeting the unknown value is returned.
       Thie methods will try to convert JSON Strings into date/time/tz or memptr values before returning a string 
       JSON objects and arrayas are returned as Json text values (ie flattened)
       
       @param JsonObject The object 
       @param character The property name 
       @return IPrimitiveHolder The representative value */
    method static public IPrimitiveHolder ToScalar(input pObject as JsonObject,
                                                   input pName as character):
        define variable strValue as character no-undo.
        define variable pos as integer no-undo.
        define variable cnt as integer no-undo.
        define variable dtzVal as datetime-tz no-undo.
        define variable mData as memptr no-undo.
        
        if    not valid-object(pObject)
           or pName eq '':U
           or pName eq ?
           or not pObject:Has(pName)
        then
            return new String(StringConstant:UNKNOWN).
        
        case pObject:GetType(pName):
            when JsonDataType:NULL    then
                return new String(StringConstant:UNKNOWN).
            when JsonDataType:BOOLEAN then
                return new LogicalValue(pObject:GetLogical(pName)).
            when JsonDataType:NUMBER  then
            do:
                assign strValue = pObject:GetJsonText(pName).
                if index(strValue, '.':u) gt 0 then
                    return new OpenEdge.Core.Decimal(pObject:GetDecimal(pName)).
                else
                    return new OpenEdge.Core.Integer(pObject:GetInt64(pName)).
            end.
            
            when JsonDataType:ARRAY  or
            when JsonDataType:OBJECT then 
                return new String(pObject:GetJsonText(pName)).
            
            otherwise
            do:
                /* This value could be a 
                   - string
                   - iso-date / time / -tz
                   - memptr / base64-encoded value */
                assign strValue = pObject:GetJsonText(pName)
                       cnt      = length(strValue, 'raw':u)
                       pos      = index(strValue, '-':u)
                       .
                // check for potential dates
                if pos eq 5 then
                case cnt:
                    // DATE YYYY-MM-DD
                    when 10 then
                        if index(strValue, '-':u, pos + 1) gt 0 then
                        do:
                            assign dtzVal = datetime-tz(integer(substring(strValue, 6, 2)),
                                                        integer(substring(strValue, 9, 2)),
                                                        integer(substring(strValue, 1, 4)),
                                                        0,
                                                        0 ) 
                                   no-error.
                            if not error-status:error then
                                return new DateHolder(date(dtzVal)).
                            else
                                assign error-status:error = no.
                        end.
                    // DATETIME YYYY-MM-DDTHH:MM:SS.SSS
                    //          12345678901234567890123
                    when 23 then
                        if     index(strValue, '-':u, pos + 1) gt 0 
                           and index(strValue, 'T':u, pos + 1) gt 0
                        then
                        do:
                            assign dtzVal = datetime-tz(integer(substring(strValue, 6, 2)),
                                                        integer(substring(strValue, 9, 2)),
                                                        integer(substring(strValue, 1, 4)),
                                                        integer(substring(strValue, 12, 2)),
                                                        integer(substring(strValue, 15, 2)),
                                                        integer(substring(strValue, 18, 2)),
                                                        integer(substring(strValue, 21, 3)) )
                                   no-error.
                            if not error-status:error then
                                return new DateTimeHolder(datetime(date(dtzVal), mtime(dtzVal))).
                            else
                                assign error-status:error = no.
                        end.
                    // DATETIME-TZ YYYY-MM-DDTHH:MM:SS.SSS+HH:MM
                    when 29 then
                        if     index(strValue, '-':u, pos + 1) gt 0 
                           and index(strValue, 'T':u, pos + 1) gt 0
                        then
                        do:
                            assign dtzVal = TimeStamp:ToABLDateTimeTzFromISO(strValue)
                                   no-error. 
                            if not error-status:error then
                                return new DateTimeTzHolder(dtzVal).
                            else
                                assign error-status:error = no.
                        end.
                end.
                else
                // base64-encoded
                if substring(strValue, cnt - 2) eq '==':u then
                do on error undo, throw:
                    assign mData = base64-decode (strValue)
                           no-error.
                    if not error-status:error then
                        return new OpenEdge.Core.Memptr(mData).
                    
                    finally:
                        set-size(mData) = 0.
                    end finally.
                end.
                else
                    return new String(strValue).
            end.
        end case.
        
        return new String(StringConstant:UNKNOWN).
    end method.
    
    /* This method converts a JSON array element to an instance of an IPrimitiveHolder.
    
       If the inputs are invalid, or the index is not in range, an object represeting the unknown value is returned.
       If the property value cannot be converted, an object represeting the unknown value is returned.
       Thie methods will try to convert JSON Strings into date/time/tz or memptr values before returning a string 
       JSON objects and arrayas are returned as Json text values (ie flattened)
       
       @param JsonArray The object 
       @param integer The element index  
       @return IPrimitiveHolder The representative value */
    method static public IPrimitiveHolder ToScalar(input pArray as JsonArray,
                                                   input pIdx as integer):
        define variable strValue as character no-undo.
        define variable pos as integer no-undo.
        define variable cnt as integer no-undo.
        define variable dtzVal as datetime-tz no-undo.
        define variable mData as memptr no-undo.
        
        if    not valid-object(pArray)
           or pIdx eq ?
           or pArray:Length lt pIdx
        then
            return new String(StringConstant:UNKNOWN).
        
        case pArray:GetType(pIdx):
            when JsonDataType:NULL    then
                return new String(StringConstant:UNKNOWN).
            when JsonDataType:BOOLEAN then
                return new LogicalValue(pArray:GetLogical(pIdx)).
            when JsonDataType:NUMBER  then
            do:
                assign strValue = pArray:GetJsonText(pIdx).
                if index(strValue, '.':u) gt 0 then
                    return new OpenEdge.Core.Decimal(pArray:GetDecimal(pIdx)).
                else
                    return new OpenEdge.Core.Integer(pArray:GetInt64(pIdx)).
            end.
            when JsonDataType:ARRAY or
            when JsonDataType:OBJECT then 
                return new String(pArray:GetJsonText(pIdx)).
            
            otherwise
            do:
                /* This value could be a 
                   - string
                   - iso-date
                   - memptr / base64-encoded value
                */
                
                assign strValue = pArray:GetJsonText(pIdx)
                       cnt      = length(strValue, 'raw':u)
                       pos      = index(strValue, '-':u)
                       .
                // check for potential dates
                if pos eq 5 then
                case cnt:
                    // DATE YYYY-MM-DD
                    when 10 then
                    do:
                        if index(strValue, '-':u, pos + 1) gt 0 then
                        do:
                            assign dtzVal = datetime-tz(integer(substring(strValue, 6, 2)),
                                                        integer(substring(strValue, 9, 2)),
                                                        integer(substring(strValue, 1, 4)),
                                                        0,
                                                        0 ) 
                                   no-error.
                            if not error-status:error then
                                return new DateHolder(date(dtzVal)).
                            else
                                assign error-status:error = no.
                        end.
                    end.
                    // DATETIME YYYY-MM-DDTHH:MM:SS.SSS
                    //          12345678901234567890123
                    when 23 then
                    do:
                        if     index(strValue, '-':u, pos + 1) gt 0 
                           and index(strValue, 'T':u, pos + 1) gt 0
                        then
                        do:
                            assign dtzVal = datetime-tz(integer(substring(strValue, 6, 2)),
                                                        integer(substring(strValue, 9, 2)),
                                                        integer(substring(strValue, 1, 4)),
                                                        integer(substring(strValue, 12, 2)),
                                                        integer(substring(strValue, 15, 2)),
                                                        integer(substring(strValue, 18, 2)),
                                                        integer(substring(strValue, 21, 3)) )
                                   no-error.
                            if not error-status:error then
                                return new DateTimeHolder(datetime(date(dtzVal), mtime(dtzVal))).
                            else
                                assign error-status:error = no.
                        end.
                    end.
                    // DATETIME-TZ YYYY-MM-DDTHH:MM:SS.SSS+HH:MM
                    when 29 then
                    do:
                        if     index(strValue, '-':u, pos + 1) gt 0 
                           and index(strValue, 'T':u, pos + 1) gt 0
                        then
                        do:
                            assign dtzVal = TimeStamp:ToABLDateTimeTzFromISO(strValue) no-error.
                            if not error-status:error then
                                return new DateTimeTzHolder(dtzVal).
                            else
                                assign error-status:error = no.
                        end.
                    end.
                end.
                else
                // base64-encoded
                if substring(strValue, cnt - 2) eq '==':u then
                do on error undo, throw:
                    assign mData = base64-decode (strValue)
                           no-error.
                    if not error-status:error then
                        return new OpenEdge.Core.Memptr(mData).
                    else
                        assign error-status:error = no.
                    finally:
                        set-size(mData) = 0.
                    end finally.
                end.
                else
                    return new String(strValue).
            end.
        end case.
        
        return new String(StringConstant:UNKNOWN).
    end method.

    /* Converts a JSON array to an instance of a IObjectArrayHolder
       
       @param JsonArray A JSON array. May be invalid/null
       @return IObjectArrayHolder The array holder. One is always returned. */
    method static public IObjectArrayHolder ToObjectArray(input pArray as JsonArray):
        return ToObjectArray(pArray, get-class(Progress.Lang.Object)).
    end method.
    
    /* Converts a JSON array to an instance of a IObjectArrayHolder
       
       @param JsonArray A JSON array. May be invalid/null
       @param P.L.Class The type of the elements in the array
       @return IObjectArrayHolder The array holder. One is always returned. */
    method static public IObjectArrayHolder ToObjectArray(input pArray as JsonArray,
                                                          input pElementType as Progress.Lang.Class ):
        define variable oah as ObjectArrayHolder no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        
        Assert:NotNull(pElementType, 'Element type').
        
        assign oah = new ObjectArrayHolder().
        
        if valid-object(pArray) then
            assign cnt               = pArray:Length
                   extent(oah:Value) = cnt
                   .
        do loop = 1 to cnt:
            case pArray:GetType(loop):
                when JsonDataType:NULL then
                    next.
                when JsonDataType:OBJECT then 
                    assign oah:Value[loop] = pArray:GetJsonObject(loop).
                when JsonDataType:ARRAY then
                    assign oah:Value[loop] = pArray:GetJsonArray(loop).
                otherwise
                    assign oah:Value[loop] = ToScalar(pArray, loop).
            end case.
            
            Assert:IsType(oah:Value[loop], pElementType).
        end.
        
        return oah.
    end method. 
    
    /* Converts a JSON array to an instance of a PrimitiveArrayHolder
       
       The first non-null element is used to infer the array's ABL type.
       Objects and Arrays are returned as JSON text.
       
       @param JsonArray A JSON array. May be invalid/null
       @return IPrimitiveArrayHolder The array holder. One is always returned. */
    method static public IPrimitiveArrayHolder ToPrimitiveArray(input pArray as JsonArray):
        define variable lcah as LongcharArrayHolder no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable ph as IPrimitiveHolder no-undo.
        
        if valid-object(pArray) then
            assign cnt = pArray:Length.
        
        do loop = 1 to cnt:
            // ABL Arrays only have a single type, so we infer that from the first non-null value we find
            case pArray:GetType(loop):
                // loop over nulls
                when JsonDataType:NULL    then next. 
                when JsonDataType:BOOLEAN then return new LogicalArrayHolder(pArray:GetLogical(1, cnt)).
                // just stringify non-scalar JSON
                when JsonDataType:OBJECT  or
                when JsonDataType:ARRAY   then return new LongcharArrayHolder(pArray:GetJsonText(1, cnt)).
                
                // could be int/64 or decimal
                when JsonDataType:NUMBER  then
                do:
                    assign ph = ToScalar(pArray, loop).
                    
                    if type-of(ph, IDecimalHolder) then
                        return new DecimalArrayHolder(pArray:GetDecimal(1, cnt)).
                    
                    if    type-of(ph, IInt64Holder) 
                       or type-of(ph, IIntegerHolder)
                    then
                        return new IntegerArrayHolder(pArray:GetInt64(1, cnt)).
                end.
                // could be memptr, date/time/tz or string
                when JsonDataType:STRING  then 
                do:
                    assign ph = ToScalar(pArray, loop).
                    
                    if type-of(ph, IDateHolder) then
                        return new DateArrayHolder(pArray:GetDate(1, cnt)).
                    
                    if type-of(ph, IDateTimeHolder) then
                        return new DateTimeArrayHolder(pArray:GetDateTime(1, cnt)).
                    
                    if type-of(ph, IDateTimeTzHolder) then
                        return new DateTimetzArrayHolder(pArray:GetDatetimeTZ(1, cnt)).
                    
                    if type-of(ph, IMemptrHolder) then
                        return new MemptrArrayHolder(pArray:GetMemptr(1, cnt)).
                    
                    return new LongcharArrayHolder(pArray:GetLongchar(1, cnt)).
                end.
            end case.
        end.    // index loop
        
        // if there are all nulls in the array or an invalid object passed in
        assign lcah = new LongcharArrayHolder().
        if cnt gt 0 then
            assign extent(lcah:Value) = cnt.
        
        return lcah.
    end method.

    /* This method converts a JSON array element to an instance of an P.L.Enum. 
       
       The element value must be either a string or number.
       If the inputs are invalid, or the index is not in range, or the value is of the wrong JSON type, 
       an unknown value is returned.
       
       If the ToObject() call fails, an error is raised. 
       
       @param JsonArray The array 
       @param integer   The element index  
       @param P.L.Class The type of the enum
       @return Progress.Lang.Enum The enum */
    method static public Progress.Lang.Enum ToEnum(input pArray as JsonArray,
                                                   input pIdx as integer,
                                                   input pEnumType as Progress.Lang.Class):
        // Check for a valid enum type
        if    not valid-object(pEnumType)
           or not pEnumType:IsA(get-class(Progress.Lang.Enum))
        then
            return ?.
        
        // Make sure the array and index are good 
        if    not valid-object(pArray)
           or pIdx eq ?
           or pIdx le 0
           or pIdx gt pArray:Length
        then
            return ?.
        
        case pArray:GetType(pidx):
            when JsonDataType:NUMBER then
                return Progress.Lang.Enum:ToObject(pEnumType:TypeName, pArray:GetInt64(pIdx)).
            when JsonDataType:STRING then
                return Progress.Lang.Enum:ToObject(pEnumType:TypeName, pArray:GetCharacter(pIdx)).
        end.
        
        return ?.
    end method.
    
    /* This method converts a JSON property to an instance of an P.L.Enum. 
       
       The property value must be either a string or number.
       If the inputs are invalid, or the property does not exist, or is of the wrong JSON type, 
       enum, an unknown value is returned.
       
       If the ToObject() call fails, an error is raised
       
       @param JsonObject The object 
       @param character The property name  
       @param P.L.Class The type of the enum
       @return Progress.Lang.Enum The enum */
    method static public Progress.Lang.Enum ToEnum(input pObject as JsonObject,
                                                   input pName as character,
                                                   input pEnumType as Progress.Lang.Class):
        // Check for a valid enum type
        if    not valid-object(pEnumType)
           or not pEnumType:IsA(get-class(Progress.Lang.Enum))
        then
            return ?.
        
        // Make sure the object and name are good 
        if    not valid-object(pObject)
           or pName eq ?
           or pName eq '':u
        then
            return ?.
        
        if pObject:Has(pName) then
        case pObject:GetType(pName):
            when JsonDataType:NUMBER then
                return Progress.Lang.Enum:ToObject(pEnumType:TypeName, pObject:GetInt64(pName)). 
            when JsonDataType:STRING then
                return Progress.Lang.Enum:ToObject(pEnumType:TypeName, pObject:GetCharacter(pName)).
        end.
        
        return ?.
    end method.
    
end class.
