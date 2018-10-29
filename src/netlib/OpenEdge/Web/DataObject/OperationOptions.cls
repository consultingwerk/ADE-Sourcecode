/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : OperationOptions
    Purpose     : Supported options for a DOH mapped operation
    Author(s)   : pjudge
    Created     : 2017-08-16
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.StringKeyedMap.

class OpenEdge.Web.DataObject.OperationOptions serializable: 
    /* (optional) Whether a dataset that's returned should include before-image details */
    define public property WriteBI as logical no-undo get. set.
    
    /* (optional) The maximimum time (in seconds) allowed for the operation's completion */
    define public property Timeout as integer no-undo get. set.
    
    /* (optional) True if the incoming request has an envelope/wrapper. */
    define public property HasRequestEnvelope as logical no-undo get. set.
    /* (optional) The value of the envelope. Defaults to "request" */
    define public property RequestEnvelope as character no-undo get. set.
    
    /* (optional) True if the outgoing response should have an envelope/wrapper. */
    define public property HasResponseEnvelope as logical no-undo get. set.
    /* (optional) The value of the envelope. Defaults to "response" */
    define public property ResponseEnvelope as character no-undo get. set.
    
    /* (optional) True if an errors returned should have an envelope/wrapper. */
    define public property HasErrorEnvelope as logical no-undo get. set.
    /* (optional) The value of the envelope. Defaults to "error" */
    define public property ErrorEnvelope as character no-undo get. set.
    
    /* A map of table/dataset names and their child schema options. This
       property always has a value, even if empty. */
    define public property SchemaOptions as IStringKeyedMap no-undo get. private set.
    
    /* Default constructor */
    constructor public OperationOptions():
        assign this-object:SchemaOptions = new StringKeyedMap()
               
               this-object:WriteBI             = false
               this-object:Timeout             = 0
               
               this-object:HasRequestEnvelope  = false
               this-object:RequestEnvelope     = 'request':u
               this-object:HasResponseEnvelope = false
               this-object:ResponseEnvelope    = 'response':u
               this-object:HasErrorEnvelope    = false
               this-object:ErrorEnvelope       = 'error':u
               .
    end constructor.
    
    /* Returns a string representation of this object */
    method override public character ToString():
        return substitute('&1_&2: writeBI: &2; timeout: &4; env.req: &5; env.resp: &6; env.err: &7; schemas: &8':u,
                    this-object:GetClass():TypeName,
                    int64(this-object),
                    this-object:WriteBI,
                    this-object:Timeout,
                    substitute('&1 &2':u, this-object:HasRequestEnvelope, this-object:RequestEnvelope),
                    substitute('&1 &2':u, this-object:HasResponseEnvelope, this-object:ResponseEnvelope),
                    substitute('&1 &2':u, this-object:HasErrorEnvelope, this-object:ErrorEnvelope),
                    this-object:SchemaOptions:Size  ).
    end method.
    
end class.