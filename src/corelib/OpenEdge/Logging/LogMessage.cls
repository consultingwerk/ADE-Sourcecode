/************************************************
Copyright (c) 2016, 2018-2019, 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LogMessage
    Purpose     : A data container/value object for a message to be logged, including
                  substitution args
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Wed Nov 16 12:01:34 EST 2016
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ILongcharArrayHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.StringKeyedMap.
using OpenEdge.Core.LongcharArrayHolder.

class OpenEdge.Logging.LogMessage serializable:
    /* (mandatory) The group for this log message */
    define public property GroupName as character no-undo get. private set.
    
    /* (mandatory) The base text of the message. May contain substitution parameters like &1 or {} */
    define public property BaseText as character no-undo get. private set.
    
    /* (mutable) The formatted message for writing to the logger target */
    define public property Message as character no-undo get. set.
    
    /* (optional) Context for the message. Could be substitution arguments, could be a Principal, etc.
       The filters decide what to do with the context, and how to apply it to the message. */
    define private variable mContext as IStringKeyedMap no-undo.
    
    /* Substitution arguments context. Separated into its own variable for perf. reasons  */
    define variable mArgsCtx as ILongcharArrayHolder no-undo.
    
    /* Tokens context. Separated into its own variable for perf. reasons. The List contains Token objects */
    define variable mTokensCtx as IList no-undo.
    
    /* Constructor
       
       @param character The message group
       @param character the message text */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessage as character ):
        assign this-object:GroupName = pcGroup
               this-object:BaseText  = pcMessage
               this-object:Message   = pcMessage
               .
    end constructor.
    
    /* Constructor
       
       @param character The message group
       @param character the message base
       @param character[] A set of character arguments (context) */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessageBase as character,
                                  input pcArgs as character extent):
        this-object(pcGroup, pcMessageBase).
        AddContext('args':u, new LongcharArrayHolder(pcArgs)).
    end constructor.
    
    /* Constructor
       
       @param character The message group
       @param character The message base text
       @param character The first argument (context) */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessageBase as character,
                                  input pcArg1 as character     ):
        define variable args as character extent 1 no-undo.
        
        this-object(pcGroup, pcMessageBase).
        
        assign args[1] = pcArg1.
        AddContext('args':u, new LongcharArrayHolder(args)).
    end constructor.
    
    /* Constructor
       
       
       @param character The message group
       @param character The message base text
       @param character The first argument
       @param character The second argument   */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessageBase as character,
                                  input pcArg1 as character,
                                  input pcArg2 as character     ):
        define variable args as character extent 2 no-undo.
        
        this-object(pcGroup, pcMessageBase).
        
        assign args[1] = pcArg1
               args[2] = pcArg2
               .
        AddContext('args':u, new LongcharArrayHolder(args)).
    end constructor.
    
    /* Constructor
       
       @param character The message group
       @param character The message base text
       @param character The first argument
       @param character The second argument
       @param character The third argument   */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessageBase as character,
                                  input pcArg1 as character,
                                  input pcArg2 as character,
                                  input pcArg3 as character     ):
        define variable args as character extent 3 no-undo.
        
        this-object(pcGroup, pcMessageBase).
        
        assign args[1] = pcArg1
               args[2] = pcArg2
               args[3] = pcArg3
               .
        AddContext('args':u, new LongcharArrayHolder(args)).
    end constructor.
    
    /* Constructor
       
       @param character The message group
       @param character The message base text
       @param character The first argument
       @param character The second argument
       @param character The third argument
       @param character The fourth argument  */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessageBase as character,
                                  input pcArg1 as character,
                                  input pcArg2 as character,
                                  input pcArg3 as character,
                                  input pcArg4 as character     ):
        define variable args as character extent 4 no-undo.
        
        this-object(pcGroup, pcMessageBase).
        
        assign args[1] = pcArg1
               args[2] = pcArg2
               args[3] = pcArg3
               args[4] = pcArg4
               .
        AddContext('args':u, new LongcharArrayHolder(args)).
    end constructor.
    
    /* Constructor
       
       @param character The message group
       @param character The message base text
       @param character The first argument
       @param character The second argument
       @param character The third argument
       @param character The fourth argument
       @param character The fifth argument */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessageBase as character,
                                  input pcArg1 as character,
                                  input pcArg2 as character,
                                  input pcArg3 as character,
                                  input pcArg4 as character,
                                  input pcArg5 as character  ):
        define variable args as character extent 5 no-undo.
        
        this-object(pcGroup, pcMessageBase).
        
        assign args[1] = pcArg1
               args[2] = pcArg2
               args[3] = pcArg3
               args[4] = pcArg4
               args[5] = pcArg5
               .
        AddContext('args':u, new LongcharArrayHolder(args)).
    end constructor.
    
    /* Constructor
       
       @param character The message group
       @param character The message base text
       @param character The first argument
       @param character The second argument
       @param character The third argument
       @param character The fourth argument
       @param character The fifth argument
       @param character The sixth argument  */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessageBase as character,
                                  input pcArg1 as character,
                                  input pcArg2 as character,
                                  input pcArg3 as character,
                                  input pcArg4 as character,
                                  input pcArg5 as character,
                                  input pcArg6 as character     ):
        define variable args as character extent 6 no-undo.
        
        this-object(pcGroup, pcMessageBase).
        
        assign args[1] = pcArg1
               args[2] = pcArg2
               args[3] = pcArg3
               args[4] = pcArg4
               args[5] = pcArg5
               args[6] = pcArg6
               .
        AddContext('args':u, new LongcharArrayHolder(args)).
    end constructor.
    
    /* Constructor
       
       @param character The message group
       @param character The message base text
       @param character The first argument
       @param character The second argument
       @param character The third argument
       @param character The fourth argument
       @param character The fifth argument
       @param character The sixth argument
       @param character The seventh argument */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessageBase as character,
                                  input pcArg1 as character,
                                  input pcArg2 as character,
                                  input pcArg3 as character,
                                  input pcArg4 as character,
                                  input pcArg5 as character,
                                  input pcArg6 as character,
                                  input pcArg7 as character       ):
        define variable args as character extent 7 no-undo.
        
        this-object(pcGroup, pcMessageBase).
        
        assign args[1] = pcArg1
               args[2] = pcArg2
               args[3] = pcArg3
               args[4] = pcArg4
               args[5] = pcArg5
               args[6] = pcArg6
               args[7] = pcArg7
               .
        AddContext('args':u, new LongcharArrayHolder(args)).
    end constructor.
    
    /* Constructor
       
       @param character The message group
       @param character The message base text
       @param character The first argument
       @param character The second argument
       @param character The third argument
       @param character The fourth argument
       @param character The fifth argument
       @param character The sixth argument
       @param character The seventh argument
       @param character The eighth argument  */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessageBase as character,
                                  input pcArg1 as character,
                                  input pcArg2 as character,
                                  input pcArg3 as character,
                                  input pcArg4 as character,
                                  input pcArg5 as character,
                                  input pcArg6 as character,
                                  input pcArg7 as character,
                                  input pcArg8 as character     ):
        define variable args as character extent 8 no-undo.
        
        this-object(pcGroup, pcMessageBase).
        
        assign args[1] = pcArg1
               args[2] = pcArg2
               args[3] = pcArg3
               args[4] = pcArg4
               args[5] = pcArg5
               args[6] = pcArg6
               args[7] = pcArg7
               args[8] = pcArg8
               .
        AddContext('args':u, new LongcharArrayHolder(args)).
    end constructor.
    
    /* Constructor
       
       @param character The message group
       @param character The message base text
       @param character The first argument
       @param character The second argument
       @param character The third argument
       @param character The fourth argument
       @param character The fifth argument
       @param character The sixth argument
       @param character The seventh argument
       @param character The eighth argument
       @param character The ninth argument  */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessageBase as character,
                                  input pcArg1 as character,
                                  input pcArg2 as character,
                                  input pcArg3 as character,
                                  input pcArg4 as character,
                                  input pcArg5 as character,
                                  input pcArg6 as character,
                                  input pcArg7 as character,
                                  input pcArg8 as character,
                                  input pcArg9 as character     ):
        define variable args as character extent 9 no-undo.
        
        this-object(pcGroup, pcMessageBase).
        
        assign args[1] = pcArg1
               args[2] = pcArg2
               args[3] = pcArg3
               args[4] = pcArg4
               args[5] = pcArg5
               args[6] = pcArg6
               args[7] = pcArg7
               args[8] = pcArg8
               args[9] = pcArg9
               .
        AddContext('args':u, new LongcharArrayHolder(args)).
    end constructor.
    
    /* Adds context values to this message.
       
       @param character (required) The context key name
       @param P.L.Object A context value    */
    method public void AddContext(input pKey as character,
                                  input pContext as Progress.Lang.Object):
        Assert:NotNullOrEmpty(pKey, 'Context key').
        
        // Contexts are separated into their own variables for perf. reasons
        case pKey:
            when 'args':u then
                if     valid-object(pContext)
                   and type-of(pContext, ILongcharArrayHolder)
                then
                    assign mArgsCtx = cast(pContext, ILongcharArrayHolder).
                else
                    assign mArgsCtx = ?.
            
            when 'tokens':u then
                if     valid-object(pContext)
                   and type-of(pContext, IList)
                then
                    assign mTokensCtx = cast(pContext, IList).
                else
                    assign mTokensCtx = ?.
            
            otherwise
            do:
                if not valid-object(mContext) then
                    assign mContext = new StringKeyedMap().
                
                mContext:Put(pKey, pContext).
            end.
        end case.
    end method.
    
    /* Returns a context value for a given key.
       
       @param character (required) The context key name
       @return P.L.Object A context value. Returns NULL if no context exists */
    method public Progress.Lang.Object GetContext(input pKey as character):
        
        // Contexts are separated into their own variables for perf. reasons
        case pKey:
            when 'args':u then
                return mArgsCtx.
            
            when 'tokens':u then
                return mTokensCtx.
            
            otherwise
                if valid-object(mContext) then
                    return mContext:Get(pKey).
                else
                    return ?.
        end case.
    end method.
    
end class.
