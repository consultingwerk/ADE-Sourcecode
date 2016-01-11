/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ConcreteRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Nov 03 14:06:22 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.URI.

class OpenEdge.Net.HTTP.ConcreteHttpRequest inherits HttpRequest:
    define override public property MessageBody as ByteBucket no-undo
        get.
        set(input poMessageBody as ByteBucket):
            CheckSeal().
            this-object:MessageBody = poMessageBody.
        end method.

	constructor public ConcreteHttpRequest (input poMethod as MethodEnum, input poURI as URI ):
		super (input poMethod, input poURI).
	end constructor.

    /** Returns a hash of the current contents of the memptr. This can be used
        for comparing memptr values quickly.  
        
        @return raw The hashed value of the memptr. */
    method public raw GetMessageBodyDigest():
        PopulateMessageBody().
        return this-object:MessageBody:GetBytes():GetHash().
    end method.

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