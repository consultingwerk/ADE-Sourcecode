/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : IFilterEvents
    Purpose     : Indicates that a filter publishes events, and provides a method
                  for doing so.
    Author(s)   : pjudge
    Created     : Mon Jul 07 15:02:06 EDT 2014
    Notes       : * Ideally the SubscribeListener() method would take a generic
                    parameter so that we could guarantee type-compliance at the
                    compiler. But we have to do it at runtime instead.
                  * The Filter will describe the events and the FilterEventListenerType
                    the handlers. Clearly these need to be in sync with each other,
                    otherwise we can end up with listeners that are never published 
                    to, and events that have no listeners.
  ----------------------------------------------------------------------*/
using Progress.Lang.Object.

interface OpenEdge.Net.HTTP.Filter.IFilterEvents:
    /** Returns the type(class or interface) that an a potential listener must
        implement or inherit in order to handle events from this filter. */
    define public property FilterEventListenerType as class Progress.Lang.Class no-undo get.
    
    /** Subscribes a listener to events from the implementing filter.
        
        @param Object The prospective listener. */
    method public void SubscribeListener(input poListener as Object).
    
    /** Unsubscribes a listener to events from the implementing filter.
        
        @param Object The prospective listener. */
    method public void UnsubscribeListener(input poListener as Object).
    
end interface.