/************************************************
Copyright (c) 2018 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : MDC
    Purpose     : Mapped Diagnostic Context object: A set of key/value pairs consumed by logger filters 
    Author(s)   : pjudge
    Created     : 2018-11-19
    Notes       : - The context values can be tokenised via ${mdc.<context-key>} tokens 
                    and are resolved by the OpenEdge.Logging.Format.MDCTokenFormat
                    format filter.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.StringStringMap.

class OpenEdge.Logging.MDC:
    /* (required) The backing store for the MDC */
    define static private variable mContextMap as IStringStringMap no-undo.
    
    /* Static constructor */
    constructor static MDC():
        assign OpenEdge.Logging.MDC:mContextMap = new StringStringMap().
    end constructor.
    
    /* Default constructor.
       PRIVATE since we never want this class instantiated. */
    constructor private MDC():
    end constructor.
    
    /* Adds a context value to the MDC context
       
       @param character A non-empty key name
       @param character A value associated with the key */
    method static public void Put(input pKey as character,
                                  input pValue as character):
        Assert:NotNullOrEmpty(pKey, 'Context key').
        
        OpenEdge.Logging.MDC:mContextMap:Put(pKey, pValue).
    end method.
    
    /* Indicates whether a key exists in the store.
       
       @param character A non-empty key name
       @return logical TRUE if the key is in the context store; FALSE otherwise */
    method static public logical Has(input pKey as character):
        Assert:NotNullOrEmpty(pKey, 'Context key').
        
        return OpenEdge.Logging.MDC:mContextMap:ContainsKey(pKey).
    end method.
    
    /* Get the context identified by the key parameter.
       
       @param character A non-empty key name
       @return character A value associated with the key */
    method static public character Get(input pKey as character):
        define variable val as character no-undo.
        
        Assert:NotNullOrEmpty(pKey, 'Context key').
        
        assign val = OpenEdge.Logging.MDC:mContextMap:Get(pKey).
        return val.
    end method.
    
    /* Remove the context identified by the key parameter.
       
       @param character A non-empty key name */
    method static public void Remove(input pKey as character):
        Assert:NotNullOrEmpty(pKey, 'Context key').
        
        OpenEdge.Logging.MDC:mContextMap:Remove(pKey).
    end method.
    
    /* Clear all entries in the MDC */
    method static public void Clear():
        OpenEdge.Logging.MDC:mContextMap:Clear().
    end method.
    
    /* Indicates whether there is any contest in the store.
       
       @return logical Returns TRUE if there's at least one entry in the store */
    method static public logical IsEmpty():
        return OpenEdge.Logging.MDC:mContextMap:IsEmpty().
    end method.
    
end class.