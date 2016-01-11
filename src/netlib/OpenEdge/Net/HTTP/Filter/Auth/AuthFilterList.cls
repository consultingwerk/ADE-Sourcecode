/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : AuthFilterList
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 27 15:36:46 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.Filter.Message.MessageFilterList.
using OpenEdge.Net.HTTP.Filter.Message.MessageFilterNode.
using Progress.Lang.Class.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.Filter.IFilterEvents.

class OpenEdge.Net.HTTP.Filter.Auth.AuthFilterList inherits MessageFilterList:
        
    /** Adds a class as a subscriber to the events from a particular EventProvider.
    
        @param Progress.Lang.Class The type of events the EventProviders is capable of 
                        listening to
        @param Progress.Lang.Object The listening object. Must conform to the type   */
    method public void AddFilterCallback(input poEventListenerType as class Class,
                                         input poListener as Object):
        define variable oNode as MessageFilterNode no-undo.
               
        Assert:IsType(poListener, poEventListenerType). 
        
        oNode = this-object:First.
        do while valid-object(oNode):
               /* The node must provide events */
            if type-of(oNode:Data, IFilterEvents) and
               /*  the events must match the listnener type */
               poEventListenerType:IsA(cast(oNode:Data, IFilterEvents):FilterEventListenerType) then
                cast(oNode:Data, IFilterEvents):SubscribeListener(poListener).
            
            oNode = oNode:Next.
        end.
    end method.

    /** Removes a class as a subscriber to the events from a particular EventProvider.
    
        @param Progress.Lang.Class The type of events the EventProviders is capable of 
                        listening to
        @param Progress.Lang.Object The listening object. Must conform to the type   */
    method public void RemoveFilterCallback(input poEventListenerType as class Class,
                                            input poListener as Object):
        define variable oNode as MessageFilterNode no-undo.
               
        Assert:IsType(poListener, poEventListenerType). 
        
        oNode = this-object:First.
        do while valid-object(oNode):
               /* The node must provide events */
            if type-of(oNode:Data, IFilterEvents) and
               /*  the events must match the listnener type */
               poEventListenerType:IsA(cast(oNode:Data, IFilterEvents):FilterEventListenerType) then
                cast(oNode:Data, IFilterEvents):UnsubscribeListener(poListener).
            
            oNode = oNode:Next.
        end.
    end method.
end class.