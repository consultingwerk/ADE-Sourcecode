/************************************************
Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
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

class OpenEdge.Logging.LogMessage serializable:
    // (mandatory) The group for this log message 
    define public property GroupName as character no-undo get. private set.
    
    // (mandatory) The base text of the message. May contain substitution parameters like &1 or {}
    define public property BaseText as character no-undo get. private set.
    
    // (optional) An array of values to substitute into the base text
    define public property Arguments as character extent no-undo get. private set.
    
    // (mutable) The formatted message for writing to the logger target
    define public property Message as character no-undo get. set.
    
    /* Constructor
       
       @param character The message group
       @param character the message text */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessage as character):
        assign this-object:GroupName = pcGroup
               this-object:BaseText  = pcMessage
               this-object:Message   = pcMessage
               .
    end constructor.

    /* Constructor
       
       @param character The message group
       @param character the message text */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessageBase as character,
                                  input pcArgs as character extent):
        this-object(pcGroup, pcMessageBase).
        
        assign this-object:Arguments = pcArgs.
    end method.

    /* Constructor
       
       @param character The message group
       @param character The message base text 
       @param character The first argument  */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessageBase as character,
                                  input pcArg1 as character     ):
        this-object(pcGroup, pcMessageBase).
        
        assign extent(this-object:Arguments) = 1
               this-object:Arguments[1] = pcArg1
               .
    end method.
    
    /* Constructor
       
       
       @param character The message group
       @param character The message base text 
       @param character The first argument 
       @param character The second argument   */
    constructor public LogMessage(input pcGroup as character,
                                  input pcMessageBase as character,
                                  input pcArg1 as character,
                                  input pcArg2 as character     ):
        this-object(pcGroup, pcMessageBase).
        
        assign extent(this-object:Arguments) = 2
               this-object:Arguments[1] = pcArg1
               this-object:Arguments[2] = pcArg2
               .
    end method.
    
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
        this-object(pcGroup, pcMessageBase).
        
        assign extent(this-object:Arguments) = 3
               this-object:Arguments[1] = pcArg1
               this-object:Arguments[2] = pcArg2
               this-object:Arguments[3] = pcArg3
               .
    end method.
    
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
        this-object(pcGroup, pcMessageBase).
        
        assign extent(this-object:Arguments) = 4
               this-object:Arguments[1] = pcArg1
               this-object:Arguments[2] = pcArg2
               this-object:Arguments[3] = pcArg3
               this-object:Arguments[4] = pcArg4
               .
    end method.
    
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
        this-object(pcGroup, pcMessageBase).
        
        assign extent(this-object:Arguments) = 5
               this-object:Arguments[1] = pcArg1
               this-object:Arguments[2] = pcArg2
               this-object:Arguments[3] = pcArg3
               this-object:Arguments[4] = pcArg4
               this-object:Arguments[5] = pcArg5
               .
    end method.
    
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
        this-object(pcGroup, pcMessageBase).
        
        assign extent(this-object:Arguments) = 6
               this-object:Arguments[1] = pcArg1
               this-object:Arguments[2] = pcArg2
               this-object:Arguments[3] = pcArg3
               this-object:Arguments[4] = pcArg4
               this-object:Arguments[5] = pcArg5
               this-object:Arguments[6] = pcArg6
               .
    end method.
    
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
        this-object(pcGroup, pcMessageBase).
        
        assign extent(this-object:Arguments) = 7
               this-object:Arguments[1] = pcArg1
               this-object:Arguments[2] = pcArg2
               this-object:Arguments[3] = pcArg3
               this-object:Arguments[4] = pcArg4
               this-object:Arguments[5] = pcArg5
               this-object:Arguments[6] = pcArg6
               this-object:Arguments[7] = pcArg7
               .
    end method.
    
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
        this-object(pcGroup, pcMessageBase).
        
        assign extent(this-object:Arguments) = 8
               this-object:Arguments[1] = pcArg1
               this-object:Arguments[2] = pcArg2
               this-object:Arguments[3] = pcArg3
               this-object:Arguments[4] = pcArg4
               this-object:Arguments[5] = pcArg5
               this-object:Arguments[6] = pcArg6
               this-object:Arguments[7] = pcArg7
               this-object:Arguments[8] = pcArg8
               .
    end method.
    
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
        this-object(pcGroup, pcMessageBase).
        
        assign extent(this-object:Arguments) = 9
               this-object:Arguments[1] = pcArg1
               this-object:Arguments[2] = pcArg2
               this-object:Arguments[3] = pcArg3
               this-object:Arguments[4] = pcArg4
               this-object:Arguments[5] = pcArg5
               this-object:Arguments[6] = pcArg6
               this-object:Arguments[7] = pcArg7
               this-object:Arguments[8] = pcArg8
               this-object:Arguments[9] = pcArg9
               .
    end method.
    
end class.
