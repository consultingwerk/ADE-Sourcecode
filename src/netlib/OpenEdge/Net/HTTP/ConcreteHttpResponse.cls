/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ConcreteHttpResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Nov 03 14:06:42 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ByteBucket.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.HttpResponse.
using OpenEdge.Core.Assert.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.ConcreteHttpResponse inherits HttpResponse:
    define override public property MessageBody as ByteBucket no-undo
        get.
        set(input poMessageBody as ByteBucket):
            CheckSeal().
            this-object:MessageBody = poMessageBody.
        end method.
    
	constructor public ConcreteHttpResponse ( input poRequest as HttpRequest):
		super (input poRequest).
	end constructor.
	
	/** Allows a filter to add an entity to the respose 
	   @param Object The entity to add. */
    method public void AddEntity(input poEntity as Object):
        assign this-object:Entity = poEntity.
    end method.
    
    /** Allows a filter or responsebuilder to add or update a message body */
        method public void AddMessageBody():
        CheckSeal().
        
        if valid-object(this-object:MessageBody) then
            this-object:MessageBody:Clear().
        else
            this-object:MessageBody = ByteBucket:Instance().
    end method.

    method public void AddMessageBody(input piCapacity as int64):
        CheckSeal().
        Assert:IsPositive(piCapacity, 'Capacity').
        
        assign this-object:MessageBody             = ByteBucket:Instance(piCapacity)
               this-object:ContentLength = 0.
    end method.
    
    method public void AddMessageBody(input poBody as ByteBucket):
        CheckSeal().
        Assert:NotNull(poBody, 'Message Body').
        
        assign this-object:MessageBody   = poBody
               this-object:ContentLength = this-object:MessageBody:Size.
    end method.
    
    method public void RemoveMessageBody():
        CheckSeal().
        
        if valid-object(this-object:MessageBody) then
        do:
            this-object:MessageBody:Clear().
            this-object:ContentLength = 0.
        end.
    end method.

end class.