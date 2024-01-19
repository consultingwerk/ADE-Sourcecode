/* *************************************************************************************************************************
Copyright (c) 2017, 2023 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : ServiceOptions
    Purpose     : A set of service-level options
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2017-08-22
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Json.JsonPropertyHelper.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
USING OpenEdge.Core.Assert.

class OpenEdge.Web.DataObject.ServiceOptions:

    define public property WriteBI as logical no-undo initial ? get. set.

    define public property RequestEnvelope as logical no-undo initial ? get. set.

    define public property ResponseEnvelope as logical no-undo initial ? get. set.

    constructor public ServiceOptions():
        super().
    end constructor.

    constructor public ServiceOptions(input poOptions as JsonObject):
        super().

        Assert:NotNull(poOptions, 'Options as JSON Object').

        this-object:WriteBI = if JsonPropertyHelper:HasTypedProperty(poOptions, "writeBI", JsonDataType:BOOLEAN)
                              then poOptions:GetLogical("writeBI")
                              else ?.

        this-object:RequestEnvelope = if JsonPropertyHelper:HasTypedProperty(poOptions, "requestEnvelope", JsonDataType:BOOLEAN)
                                      then poOptions:GetLogical("requestEnvelope")
                                      else ?.

        this-object:ResponseEnvelope = if JsonPropertyHelper:HasTypedProperty(poOptions, "responseEnvelope", JsonDataType:BOOLEAN)
                                       then poOptions:GetLogical("responseEnvelope")
                                       else ?.
    end constructor.

end class.