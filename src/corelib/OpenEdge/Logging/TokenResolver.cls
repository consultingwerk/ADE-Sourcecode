/* *************************************************************************************************************************
Copyright (c) 2016-2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : TokenResolver
    Purpose     : Resolves certain known token names into useful values.
                  Wraps calls to the OpenEdge.Core.Util.TokenResolver
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Nov 16 13:02:52 EST 2016
    Notes       : 
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.TokenResolverEventArgs.
using OpenEdge.Logging.TokenResolver.

class OpenEdge.Logging.TokenResolver:
    
    /* Event published after a token is resolved by this resolver. Allows a listener to override the value */
    define static public event TokenResolved signature void (input pSender as Progress.Lang.Object,
                                                             input pArgs as TokenResolverEventArgs). 
    
    /* Resolves a NAME-based token arg, based on the type/logger name given
       
       @param character  The token argument for ${NAME.*} tokens
       @param character  The (type) name to resolve
       @return character The resolved string  */
    method static public character ResolveName(input pTokenArg  as character,
                                               input pName as character):
        return OpenEdge.Core.Util.TokenResolver:ResolveName(pTokenArg, pName).
    end method.
    
    /* Resolves a time-based token arg, based on the timestamp given
       
       @param character   The token argument for ${T.*} tokens
       @param datetime-tz The timestamp to use to resolve the token
       @return character  The resolved string */
    method static public character ResolveTime(input pTokenArg  as character,
                                               input pTimestamp as datetime-tz):
        return OpenEdge.Core.Util.TokenResolver:ResolveTime(pTokenArg, pTimestamp).
    end method.
    
    /* Resolves a time-based token arg, based on the timestamp given
       
       @param character     The token argument for ${T.*} tokens
       @param character[12] The long-form month names (ie January)
       @param character[12] The short-form month names (ie Jan)
       @param character[7]  The long-form weekday names (ie Thursday)
       @param character[7]  The short-form weekday names (ie Thurs)
       @param datetime-tz   The timestamp to use to resolve the token
       @return character    The resolved string */
    method static public character ResolveTime(input pTokenArg  as character,
                                               input pMonthLong as character extent 12,
                                               input pMonthShort as character extent 12,
                                               input pWeekdayLong as character extent 7,
                                               input pWeekdayShort as character extent 7,
                                               input pTimestamp as datetime-tz ):
        return OpenEdge.Core.Util.TokenResolver:ResolveTime(pTokenArg,
                                                            pMonthLong,
                                                            pMonthShort,
                                                            pWeekdayLong,
                                                            pWeekdayShort,
                                                            pTimestamp).
    end method.
    
    /* Resolves a CP-based token arg, based on the client-principal.
       
       It is the CALLER's responsibility to clean up the C-P object represented by this handle
       
       @param character The token argument for ${CP.*} tokens
       @param handle     A user represented by a client-principal 
       @return character The resolved string  */
    method static public character ResolveUser(input pTokenArg as character,
                                               input pUser as handle):
        return OpenEdge.Core.Util.TokenResolver:ResolveUser(pTokenArg, pUser).
    end method.
    
    /* Resolves any tokens in the file name into appropriate values
       
       @param character The source string
       @return character The resolved string */
    method static public character Resolve(input pcBaseString as character):
        OpenEdge.Core.Util.TokenResolver:TokenResolved:Subscribe(TokenResolvedHandler).
        
        return OpenEdge.Core.Util.TokenResolver:Resolve(pcBaseString).
        finally:
            OpenEdge.Core.Util.TokenResolver:TokenResolved:Unsubscribe(TokenResolvedHandler).
        end finally.
    end method.
    
    /* Callback to handle token replacement 
       
       @param Object The sender
       @param OpenEdge.Core.Util.TokenResolverEventArgs The token resolution args  */
    method static public void TokenResolvedHandler (input pSender as Progress.Lang.Object,
                                                    input pArgs as OpenEdge.Core.Util.TokenResolverEventArgs):
        define variable loggingArgs as TokenResolverEventArgs no-undo.
        
        assign loggingArgs             = new TokenResolverEventArgs(pArgs:TokenGroup, pArgs:TokenArg, pArgs:TokenValue)
               loggingArgs:SourceValue = pArgs:SourceValue
               .    
        OpenEdge.Logging.TokenResolver:TokenResolved:Publish(get-class(OpenEdge.Logging.TokenResolver), loggingArgs).
        
        // Set the values for the originating event arg 
        assign pArgs:TokenValue  = loggingArgs:TokenValue
               pArgs:SourceValue = loggingArgs:SourceValue
               .
    end method.
    
end class.
