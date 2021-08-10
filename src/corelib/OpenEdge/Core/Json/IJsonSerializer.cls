/************************************************
Copyright (c) 2019 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IJsonSerializer
    Purpose     : Indicates that an object supports serialization to JSON  
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2019-03-21
    Notes       : * Classes implementing this interface MUST have a default
                    public constructor for deserialisation purposes, since the
                    expectation is that the entire object's state is taken from
                    the input argument to the deserialization method
  ----------------------------------------------------------------------*/
using Progress.Json.ObjectModel.JsonConstruct.

interface OpenEdge.Core.Json.IJsonSerializer:
    /* SERIALIZATION METHOD:returns a JsonConstruct (JsonDataType:OBJECT or JsonDataType:ARRAY) representation 
       of this object.
       
       @return JsonConstruct A JSON representation of this object. May be unknown (JsonDataType:NULL). */
    method public JsonConstruct ToJsonConstruct().
    
    /* DESERIALIZATION METHOD: populates this object with data from the JSON representation.
       
       @param JsonConstruct A JSON representation of this object. May be unknown (JsonDataType:NULL). */
    method public void FromJson(input pJson as JsonConstruct).
    
end interface.