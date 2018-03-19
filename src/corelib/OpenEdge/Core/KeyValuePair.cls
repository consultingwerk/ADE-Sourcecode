/************************************************
Copyright (c) 2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : KeyValuePair
    Purpose     : Holds a key and value tuple/pair
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2017-08-30
    Notes       : * these are untyped values
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.KeyValuePair.
using OpenEdge.Core.String.
 
class OpenEdge.Core.KeyValuePair serializable:
    
    // (mandatory) The key for this tuple  
    define public property Key as Progress.Lang.Object no-undo get. private set.
    
    // The value for this tuple
    define public property Value as Progress.Lang.Object no-undo get. set.
    
    /* Default coonstructor.
       
       Private since we don't want to allow an object without a key */
    constructor private KeyValuePair ():
    end constructor.
    
    /* Constructor
       
       @param P.L.Object A key value */
    constructor public KeyValuePair (input pKey as Progress.Lang.Object):
        Assert:NotNull(pKey, 'Key').
        
        assign this-object:Key = pKey.
    end constructor.
    
    /* Constructor
    
       @param character A String key value
       @param P.L.Object A value associated with the key */
    constructor public KeyValuePair(input pcKey as character,
                                    input pValue as Progress.Lang.Object):
        this-object(new String(pcKey), pValue).
    end constructor.
    
    /* Constructor
    
       @param P.L.Object A key value
       @param P.L.Object A value associated with the key */
    constructor public KeyValuePair(input pKey as Progress.Lang.Object,
                                    input pValue as Progress.Lang.Object):
        this-object(pKey).
        
        assign this-object:Value = pValue.
    end constructor.
    
    /* Compares an input object to this instance
       Objects are equal if
       - they are the same instance, OR
       - they are both of type KeyValuePair AND
            the Key and Value values are equal
       
       @param P.L.Object  An object to compare
       @return logical TRUE if the input object matchs this object */
    method public override logical Equals(o as Progress.Lang.Object):
         define variable kvp as KeyValuePair no-undo.
         
         if o:Equals(this-object) then
             return true.
             
         if type-of(o, KeyValuePair) then
         do: 
             kvp = cast(o, KeyValuePair).
             return this-object:Key:Equals(kvp:Key) 
                    and 
                    this-object:Value:Equals(kvp:Value).
         end.
         
         return false.
    end method.
end class.
