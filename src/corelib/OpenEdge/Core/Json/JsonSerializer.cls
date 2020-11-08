/* *************************************************************************************************************************
Copyright (c) 2019-2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OpenEdge.Core.Json.JsonSerializer
    Description : Serilaizes to and from JSON
    Author(s)   : pjudge
    Created     : 2019-11-21
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.MemptrInputStream.
using OpenEdge.Core.MemptrOutputStream.
using Progress.IO.JsonSerializer.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.ParameterList.
using Progress.Reflect.Constructor.

class OpenEdge.Core.Json.JsonSerializer:
    /* Default constructor.
       
       This is private so that this class cannot be instantiated - it's intended to be used with static members only */
    constructor private JsonSerializer():
    end constructor.
    
    /* Serialises an array of objects to JSON.
       
       This method first tries to serialize using OpenEdge.Core.Json.IJsonSerializer and 
       then Progress.IO.JsonSerializer. If the class implements neither then an invalid object
       is returned.
       
       If there are duplicate objects in the array, then the index of the duplicate object is written
       
       @param Progress.Lang.Object[]  The objects to serialize
       @return JsonArray The JSON data. May be invalid/unknown */
    method static public JsonArray Serialize(input pSerialize as Progress.Lang.Object extent):
        define variable ja as JsonArray no-undo.
        define variable serData as JsonObject no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        define variable objRefs as character no-undo.
        define variable idx as integer no-undo.
        define variable ok as logical no-undo.
        define variable delim as character no-undo.
        
        assign cnt = extent(pSerialize). 
        if cnt eq ? then
            return ja.
        
        assign ja    = new JsonArray(cnt)
               delim = '':u
               .
        do loop = 1 to cnt:
            assign idx = lookup(string(int64(pSerialize[loop])), objRefs).
            if idx eq 0 then
                assign serData = Serialize(pSerialize[loop])
                       ok      = ja:Set(loop, serData)
                       objRefs = objRefs + delim + string(int64(pSerialize[loop]))
                       delim   = ',':u
                       .
            else
                ja:Set(loop, idx).
        end.
        
        return ja.
    end method.
    
    /* Serialises an object to JSON.
       
       This method first tries to serialize using OpenEdge.Core.Json.IJsonSerializer and 
       then Progress.IO.JsonSerializer. If the class implements neither then an invalid object
       is returned.
       
       If the class implements IJsonSerializer then the JSON returned has the format
       {
        "serializer": <STRING>          // OOABL type name of the IJsonSerializer interface
        "object": <STRING>              // OOABL type name of the object being serialised
        "data": <NULL|OBJECT|ARRAY>     // the serialized object data
       }
       
       If the class uses the built-in serilisation, then the JSON format is
       {
         "prods:version": <VERISON>,
         "prods:objId", <internal ID of this object)>
         "<STRING>" : {     // the string is the OOABL type name of the class bening serialised
                // serialisation data, per doc
           }
       }
       
       @param Progress.Lang.Object  The object to serialize
       @return JsonObject The JSON data. May be invalid/unknown */
    method static public JsonObject Serialize(input pSerialize as Progress.Lang.Object):
        define variable jsonData as JsonObject no-undo.
        define variable serialisedObj as JsonConstruct no-undo.
        define variable js as JsonSerializer no-undo.
        define variable omp as ObjectModelParser no-undo.
        define variable mos as MemptrOutputStream no-undo.
        
        if not valid-object(pSerialize) then
            return jsonData.
        
        if type-of(pSerialize, IJsonSerializer) then
        do:
            assign jsonData = new JsonObject().
            jsonData:Add('serializer':u, get-class(IJsonSerializer):TypeName).
            // add the type name so that we can deserialise appropriately
            jsonData:Add('object':u, pSerialize:GetClass():TypeName).
            
            // get the object data
            assign serialisedObj = cast(pSerialize, IJsonSerializer):ToJsonConstruct().
            if not valid-object(serialisedObj) then
                jsonData:AddNull('data':u).
            else
            if type-of(serialisedObj, JsonObject) then
                jsonData:Add('data':u, cast(serialisedObj, JsonObject)).
            else
            if type-of(serialisedObj, JsonArray) then
                jsonData:Add('data':u, cast(serialisedObj, JsonArray)).
        end.
        else
        if pSerialize:GetClass():IsSerializable() then
        do:
            assign js  = new JsonSerializer(false)
                   mos = new MemptrOutputStream()
                   omp = new ObjectModelParser()
                   .
            js:Serialize(pSerialize, mos).
            mos:Flush().
            
            assign jsonData = cast(omp:Parse(mos:Data), JsonObject).
        end.
        
        return jsonData.
    end method. 
    
    /* Deserializes an array of object from a JSON array..
       
       Integer values are references to objects in the array - if there are duplicates
       then only one has to be (de)serialised. References must be 'backwards' (ie to an 
       already-deserialised object).
       
       @param JsonArray An array represented as JSON
       @return Progress.Lang.Object[] A deserialised object array */
    method static public Progress.Lang.Object extent Deserialize(input pJson as JsonArray):
        define variable obj as Progress.Lang.Object extent no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        if not valid-object(pJson) then
            return obj.
        
        assign cnt = pJson:Length.
        if cnt gt 0 then
            assign extent(obj) = cnt.
        
        do loop = 1 to cnt:
            case pJson:GetType(loop):
                // each item in the array represents a serialised object
                when JsonDataType:OBJECT then
                    assign obj[loop] =  Deserialize(pJson:GetJsonObject(loop)).
                
                // if there's an integer value, it's a reference to another element in the array
                when JsonDataType:NUMBER then
                    assign obj[loop] = obj[pJson:GetInteger(loop)].
            end case.
        end.
        
        return obj.
    end method.
    
    /* Deserializes this object from JSON.
       
       @param JsonConstruct This object represented as JSON
       @return Progress.Lang.Object A deserialised object */
    method static public Progress.Lang.Object Deserialize(input pJson as JsonObject):
        define variable obj as Progress.Lang.Object no-undo.
        define variable js as JsonSerializer no-undo.
        define variable mJson as memptr no-undo.
        define variable objType as Progress.Lang.Class no-undo.
        define variable objData as JsonConstruct no-undo.
        define variable mis as MemptrInputStream no-undo.
        
        if not valid-object(pJson) then
            return obj.
        
        if     JsonPropertyHelper:HasTypedProperty(pJson, 'serializer':u, JsonDataType:STRING) 
           and pJson:GetCharacter('serializer':u) eq get-class(IJsonSerializer):TypeName
        then
        do:
            assign objType = Progress.Lang.Class:GetClass(pJson:GetCharacter('object':u))
                   obj     = NewSerializableObject(objType)
                   .
            if valid-object(obj) then
            do:    
                case pJson:GetType('data':u):
                    when JsonDataType:OBJECT then assign objData = pJson:GetJsonObject('data':u).
                    when JsonDataType:ARRAY  then assign objData = pJson:GetJsonArray('data':u).  
                    otherwise                     assign objData = ?.
                end case.
                
                cast(obj, IJsonSerializer):FromJson(objData).
            end.
        end.    // IJsonSerializer
        else
        // built-in serialisation
        if JsonPropertyHelper:HasTypedProperty(pJson, 'prods:version':u, JsonDataType:NUMBER) then
        do on error undo, throw:
            // turn JSON into MEMPTR
            pJson:Write(mJson).
            
            assign js  = new JsonSerializer(false)
                   mis = new MemptrInputStream(mJson)
                   obj = js:Deserialize(mis)
                   .
            finally:
                set-size(mJson) = 0.
            end finally.
        end.
        
        // can't deserialise
        return obj.
    end method.
    
    /* Instantiates a new instance of an IJsonSerializable object.
       
       This method attempts to find a service using the CCS Service Manager, using IJsonSerializable as 
       the service name, and the type name as an alias.
       
       If none foudn or returned, then the method requires that the type implement IJsonSerializable, be NEW'able 
       (not abstract and not an interface) and also have a public default constructor.
       
       @param Progress.Lang.Class The type to instantiate
       @return Progress.Lang.Object An object of that type */
    method static private Progress.Lang.Object NewSerializableObject(input pType as Progress.Lang.Class):
        define variable ctor as Constructor no-undo.
        define variable obj as Progress.Lang.Object no-undo.
        
        if not valid-object(pType) then
            return obj.
        
        if valid-object(Ccs.Common.Application:ServiceManager) then
            assign obj = Ccs.Common.Application:ServiceManager
                                    :getService(get-class(IJsonSerializer),
                                                pType:TypeName)
                                no-error.
        // reset the error-status flag before continuing
        assign error-status:error = no.
        
        if valid-object(obj) then
            return obj.
        
        if     pType:IsA(get-class(IJsonSerializer))
           and not pType:IsAbstract()
           and not pType:IsInterface()
        then
        do:
            // Only objects with a default constructor can be instantiated here
            assign ctor = pType:GetConstructor(new ParameterList(0)).
            if not valid-object(ctor) then
                return obj.
            
            obj = pType:New().
        end.
        
        return obj.
    end method.
    
end class.
