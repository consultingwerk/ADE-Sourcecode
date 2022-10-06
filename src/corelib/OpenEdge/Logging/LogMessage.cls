/************************************************
Copyright (c) 2016, 2018-2019, 2021-2022 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.StringKeyedMap.
using OpenEdge.Core.LongcharArrayHolder.
using OpenEdge.Core.Util.Token.
using OpenEdge.Core.Util.TokenResolver.
using Progress.Collections.ISet.
using Progress.Collections.SortedSet.

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
    
    /* A set of tokens in the message text. Populated from the constructor.
       A set to avoid any duplication. */
    define public property Tokens as ISet<Token> no-undo
        get():
            // Always return a SortedSet object as the Tokens value.
            if not valid-object(this-object:Tokens) then
                assign this-object:Tokens = new SortedSet<Token>().
        
            return this-object:Tokens.
        end get.
        private set.
    
    /* Constructor
       
       @param character The message group
       @param character the message text */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessage as character ):
        assign this-object:GroupName = pcGroup
               this-object:BaseText  = pcMessage
               this-object:Message   = pcMessage
               .
        AddTokens(TokenResolver:Parse(this-object:Message)).
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
            
            otherwise
                if valid-object(mContext) then
                    return mContext:Get(pKey).
                else
                    return ?.
        end case.
    end method.
    
    /* Adds one or more tokens to the message's set of tokens.
       
       @param Token[] An array of tokens. May be indeterminate
       @return logical Returns TRUE if at least one token was added to the Set; FALSE otherwise */
    method public logical AddTokens(input pTokens as Token extent):
        var integer loop, cnt = extent(pTokens).
        var logical tokenAdded = false.
        
        // if cnt = ? this loop isn't entered
        do loop = 1 to cnt:
            // the Add(Token) method deals with unknown values
            if AddToken(pTokens[loop]) then
                assign tokenAdded = true.
        end.
        
        return tokenAdded.
    end method.
    
    /* Adds a token to the message's set of tokens.
       
       @param Token A Token to add
       @return logical Returns TRUE if the token was added to the Set; FALSE otherwise */
    method public logical AddToken(input pToken as Token):
        if not valid-object(pToken) then
            return false.

        return this-object:Tokens:Add(pToken).
    end method.
    
end class.
