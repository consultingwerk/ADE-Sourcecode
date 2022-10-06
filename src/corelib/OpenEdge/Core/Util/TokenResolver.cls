/* *************************************************************************************************************************
Copyright (c) 2018-2019, 2021-2022 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : TokenResolver
    Purpose     : Resolves certain known token names into useful values
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Wed Nov 16 13:02:52 EST 2016
    Notes       : * Token substitutions are allowed for file names
                    the token format is ${<token>}, where
                    token = group-name "." arg
                    
                    group-name = session | env | guid | t[ime] | web | ver[sion]
                             cp | req[uest] | name | err
                    
                    If a token cannot be resolved, or resolves to a value of
                    ? (unknown) then the token name is used, unless the token is marked
                    as allowing the unknown value. Tokens indicate this by a leading "?" - so a token of "{?cp.uid}"
                    will resolve to "?" when no user is asserted.
                  
                  * Group args for SESSION
                    - any readable attribute on the session handle may be used
                  
                  * Group args for ENV
                    - any env var available via OE-GETENV() may be used
                    
                  * Group args for VERSION
                    - Correlates to the SESSION:LOCAL-VERSION-INFO
                    - MAJOR, MINOR, MAINT
                    
                  * Group args for GUID
                    - a default-format GUID is used
                  
                  * Group args for UUID
                    - a 22-character UUID is used
                  
                  * Group args for T (T= time).
                    - Values are taken from the time at which the file name is being built.
                    - The args are based on http://en.cppreference.com/w/c/chrono/strftime
                    
                    Can be used together with T.MHS or T.MTIME.
                    Unformatted DATE string using Day, Month, Year values
                    DMY  : Shorthand for "${T.DD}${T.MM}${T.YYYY}"
                    MDY  : Shorthand for "${T.MM}${T.DD}${T.YYYY}"
                    YMD  : Shorthand for "${T.YYYY}${T.MM}${T.DD}"
                    
                    HMS  : Shorthand for "${T.HH}${T.MM}${T.SS}"
                    MTIME: The time since midnight, in milliseconds
                    
                    TODAY: An ISO-DATE formatted DATE value is used
                    NOW  } An ISO-DATE formatted DATETIME-TZ value is used
                    ISO  }
                    HTTP : The datetime formatted as per https://tools.ietf.org/html/rfc7231#section-7.1.1.1
                    YYYY : The current year, incl century
                    YY   : The current year, sans century
                    BB   : The full month name (from the MONTH_LONG property)
                    B    : The shortened month name (from the MONTH_SHORT property)
                    MM   : The integer month value, with leading 0 if needed
                    M    : The integer month value with no leading 0
                    DD   : The integer day value, with leading 0 if needed
                    D    : The integer month value, with no leading 0
                    HH   : The hour value, in 24-hour clock format (ie 18 for 6pm)
                    H    : The hour value, in 12-hour clock format (ie 6 for 6pm)
                    MMM  : The minute value, with leading 0
                    SS   : The second value, with leading 0
                    SSS  : The millisecond value, with leading 0
                    Z    : The timezone (based on the current session), with leading +/-
                    PP   : The AM/PM indicator, as AM or PM
                    P    : The AM/PM indicator, as A or P
                    AA   : The full day of the week, from the WEEKDAY_LONG property
                    A    : The short day of the week, from the WEEKDAY_SHORT property
                    W    : The integer day of the week
                    
                 * Group args for REQ (request).
                   Will return ? if we're not in a request (ie startup event procs). Values
                   are taken from the session:current-request-info
                   TPT      : The adapter type (transport) for this request
                   CCID     : The client context id
                   ID       : The current request id
                   SESSION  : The current session id
                   THREAD   : (PASOE) the current thread id
                 
                 * Group args for WEB are processed in OpenEdge.Web.Logging.WebRequestTokenResolver
                 
                 * Group args for CP (client principal)
                   credential-arg "." db-name
                   credential-arg
                       The current user will be used (from the request info or the security-policy)
                       UID    : The current user id
                       QUID   : The qualified user id (user@domain)
                       DOMAIN : The domain name of the current user
                       PROP "." property-name   : Returns the value of a property in the CP
                        property-name : The name of a property to return
                   db-name
                        An optional logical db name from which to extract the CP. If none is set, use the security-policy
                   
                 * Group args for NAME
                   tokenArg = format-expression "." logger-name
                   - logger-name : a named-hierarchy dotted-name
                   
                   - named-hierarchy
                          something like OpenEdge.Net.DataObject.DataObjectHandler (a logger name) will become
                          O.N.D.DataObjectHandler       (default or .1K)
                          o.n.d.DataObjectHandler       (.1L)
                          OE.N.DO.DataObjectHandler     (.1C)
                          OE.N.DO.DOH                   (.0C)
                   
                   - format-expression
                        keep-expr case-expr
                        keep-expr:
                            number of significant entries to keep (from right)
                            0   : All entries will be trimmed (ie zero kept)
                            1   : Only the last/only will be keep whole (default)
                            2..n: The number of entries (from the right) to keep
                        case-expr
                            U   : trimmed elements are upper-cased
                            L   : trimmed elements are lower-cased
                            K   : trimmed elements are left alone (default)
                            C   : trimmed elements are Camel-cased (caps only written)
                 
                 * Group args for ERROR
                    N          : message number n (defaults to 1 if not an integer or none provided)
                    SEV        : error severity
                    RETVAL     : return value, if an AppError
                    STACK      : the callstack, if enabled
                    TYPE       : the error type (class)
                 
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IDateTimeTzHolder.
using OpenEdge.Core.String.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.TimeStamp.
using OpenEdge.Core.Util.Token.
using OpenEdge.Core.Util.TokenResolver.
using OpenEdge.Core.Util.TokenResolverEventArgs.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Security.Principal.
using Progress.Lang.AppError.

class OpenEdge.Core.Util.TokenResolver:
    /* Event published after a token is resolved by this resolver. Allows a listener to override the value */
    define static public event TokenResolved signature void (input pSender as Progress.Lang.Object,
                                                             input pArgs as TokenResolverEventArgs).
    
    // Long/full names of the month, for use with ${t.BB} tokens
    define static public property MONTH_LONG as character extent 12 no-undo
            initial ['January','February','March','April','May','June','July','August','September','October','November','December']
            get.
            set.
    // Short names of the month, for use with ${t.B} tokens
    define static public property MONTH_SHORT as character extent 12 no-undo
            initial ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
            get.
            set.
    
    // Long names of the week days, for use with ${t.AA} tokens
    define static public property WEEKDAY_LONG as character extent 7 no-undo
            initial ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday']
            get.
            set.
    
    // Long names of the week days, for use with ${t.A} tokens
    define static public property WEEKDAY_SHORT as character extent 7 no-undo
            initial ['Sun','Mon','Tue','Wed','Thu','Fri','Sat']
            get.
            set.
    
    define static private variable mInstanceRoot as character no-undo.
    
    /* Resolves a ERR-based token arg, based on the type/logger name given
       
       @param character  The token argument for ${ERR.*} tokens
       @param Progress.Lang.Error The error/exception to resolve
       @return character The resolved string  */
    method static public character ResolveError(input pTokenArg  as character,
                                                input pError as Progress.Lang.Error):
        define variable tokenVal as character no-undo.
        define variable idx as integer no-undo.
        
        if not valid-object(pError) then
            return ?.
        
        case pTokenArg:
            when ? then
                assign tokenVal = ?.
            
            // type = type of the error
            when 'type':u then
                assign tokenVal = pError:GetClass():TypeName.
            
            // sev = the value of the severity property
            when 'sev':u then
                assign tokenVal = string(pError:Severity).
            
            // stack = the error's callstack
            when 'stack':u then
                assign tokenVal = pError:CallStack.
            
            // retval = the return value if a AppError
            when 'retval':u then
                if type-of(pError, AppError) then
                    assign tokenVal = cast(pError, AppError):ReturnValue.
            
            // <blank>   = err.1
            // <non-int> = err.1
            // <int>     = the message represented by that number
            otherwise
            do:
                // separate ASSIGN statements to make sure that we can reset the ERROR-STATUS:ERROR flag
                assign idx = integer(pTokenArg) no-error.
                
                //set no-error here to stop errors propagating onwards
                assign tokenVal = pError:GetMessage(max(1, idx))
                       no-error.
            end.
        end case.
        
        return tokenVal.
    end method.
    
    /* Resolves a NAME-based token arg, based on the type/logger name given
       
       @param character  The token argument for ${NAME.*} tokens
       @param character  The (type) name to resolve
       @return character The resolved string  */
    method static public character ResolveName(input pTokenArg  as character,
                                               input pName as character):
        define variable tokenValue as character no-undo.
        define variable numKeep as integer no-undo.
        define variable numChars as integer no-undo.
        define variable charLoop as integer no-undo.
        define variable numEntries as integer no-undo.
        define variable entryLoop as integer no-undo.
        define variable singleEntry as character no-undo.
        define variable sensitiveChar as character no-undo case-sensitive.
        define variable delim as character no-undo.
        
        if pName eq ? then
            return ?.
        
        assign numEntries = num-entries (pName, '.':u)
               delim      = '':u
               tokenValue = '':u
               .
        
        if pTokenArg eq '':u then
            assign pTokenArg = '1K':u.
        
        assign numKeep = ?
               numKeep = integer(substring(pTokenArg, 1, 1))
               no-error.
        if numKeep eq ? then
            assign numKeep = 1.
        
        do entryLoop = 1 to numEntries:
            assign singleEntry = entry(entryLoop, pName, '.':u).
            
            if entryLoop gt numEntries - numKeep then
                assign tokenValue = tokenValue
                                  + delim
                                  + singleEntry.
            else
            case substring(pTokenArg, 2, 1):
                when 'U':u then     //Upper
                    assign tokenValue = tokenValue
                                      + delim
                                      + caps(substring(singleEntry, 1, 1)).
                
                when 'L':u then     //Lower
                    assign tokenValue = tokenValue
                                      + delim
                                      + lc(substring(singleEntry, 1, 1)).
                
                when 'C':u then     //camelCase
                do:
                    /* Loop through entire input string */
                    assign numChars   = length(singleEntry)
                           tokenValue = tokenValue
                                      + delim
                                      + substring(singleEntry, 1, 1)
                                      .
                    do charLoop = 2 to numChars:
                        assign sensitiveChar = substring(singleEntry, charLoop, 1).
                        if sensitiveChar eq caps(sensitiveChar) then
                            assign tokenValue = tokenValue + sensitiveChar.
                    end.
                end.    // CamelCase
                
                otherwise           // Keep
                    assign tokenValue = tokenValue
                                      + delim
                                      + substring(singleEntry, 1, 1).
            end case.
            assign delim = '.':u.
        end.

        return tokenValue.
    end method.

    /* Resolves a time-based token arg, based on the timestamp given
       
       @param character   The token argument for ${T.*} tokens
       @param datetime-tz The timestamp to use to resolve the token
       @return character  The resolved string */
    method static public character ResolveTime(input pTokenArg  as character,
                                               input pTimestamp as datetime-tz):
        return ResolveTime(pTokenArg,
                           MONTH_LONG, MONTH_SHORT,
                           WEEKDAY_LONG, WEEKDAY_SHORT,
                           pTimestamp).
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
        define variable tokenValue as character no-undo.
        define variable formatString as character no-undo.
        define variable timeValue as integer no-undo.
        
        if pTimestamp eq ? then
            return ?.
        
        assign formatString = '99':u
               tokenValue   = ?.
        
        if length(pTokenArg) eq 1 then
            assign formatString = '>9':u.
        
        case pTokenArg:
            // predefined
            when 'NOW':u or
            when 'ISO':u then
                assign tokenValue = iso-date(pTimestamp).
            
            // Day/Month/Year combos
            when 'DMY':u then
                assign tokenValue = string(day(pTimestamp), '99':u)
                                  + string(month(pTimestamp), '99':u)
                                  + string(year(pTimestamp)).
            
            when 'MDY':u then
                assign tokenValue = string(month(pTimestamp), '99':u)
                                  + string(day(pTimestamp), '99':u)
                                  + string(year(pTimestamp)).
            
            when 'YMD':u then
                assign tokenValue = string(year(pTimestamp))
                                  + string(month(pTimestamp), '99':u)
                                  + string(day(pTimestamp), '99':u).
            
            when 'HTTP':u then
                assign tokenValue = TimeStamp:ToHttpDateFromABL(pTimestamp).
            
            when 'TODAY':u then
                assign tokenValue = iso-date(date(pTimestamp)).
            
            when 'HMS':u then
                assign tokenValue = string(interval(pTimestamp, date(pTimestamp), 'hour':u),
                                           '99':u)
                                  + string(interval(pTimestamp, date(pTimestamp), 'minutes':u)
                                               - 60  * interval(pTimestamp, date(pTimestamp), 'hours':u),
                                           '99':u)
                                  + string(interval(pTimestamp, date(pTimestamp), 'seconds':u)
                                               - 60  * interval(pTimestamp, date(pTimestamp), 'minutes':u),
                                           '99':u)
                                  .
            
            // milliseconds since midnight
            when 'MTIME':u then
                assign tokenValue = string(mtime(pTimestamp)).
            
            // years
            when 'YYYY':u then
                assign tokenValue = string(year(pTimestamp), '9999':u).
            when 'YY':u then
                assign tokenValue = string(year(pTimestamp) mod 100, '99':u).
            
            // Months
            when 'B':u then
                assign tokenValue = pMonthShort[month(pTimestamp)].
            when 'BB':u then
                assign tokenValue = pMonthLong[month(pTimestamp)].
             
            // Months (M and MM)
            when 'M':u or
            when 'MM':u then
                assign tokenValue = string(month(pTimestamp), formatString).
            
            // Days
            when 'D':u or
            when 'DD':u then
                assign tokenValue = string(day(pTimestamp), formatString).
            
            // Hours
            when 'H':u or
            when 'HH':u then
                assign tokenValue = string(interval(pTimestamp, date(pTimestamp), 'hour':u),
                                         formatString).
            
            // Minutes
            when 'MMM':u then
                    assign tokenValue = string(interval(pTimestamp, date(pTimestamp), 'minutes':u)
                                               - 60  * interval(pTimestamp, date(pTimestamp), 'hours':u),
                                               '99':u).
            
            // Seconds
            when 'SS':u then
                    assign tokenValue = string(interval(pTimestamp, date(pTimestamp), 'seconds':u)
                                               - 60  * interval(pTimestamp, date(pTimestamp), 'minutes':u),
                                               '99':u).
            // Milliseconds
            when 'SSS':u then
                    assign tokenValue = string(interval(pTimestamp, date(pTimestamp), 'milliseconds':u)
                                               - 1000 * interval(pTimestamp, date(pTimestamp), 'seconds':u),
                                               '999':u).
            
            // Timezone
            when 'Z':u then
                assign tokenValue = string(timezone(pTimestamp), '+999':u).
            
            // Weekday
            when 'A':u then
                assign tokenValue = pWeekdayShort[weekday(pTimestamp)].
            when 'AA':u then
                assign tokenValue = pWeekdayLong[weekday(pTimestamp)].
            when 'W':u then
                assign tokenValue = string(weekday(pTimestamp)).
            
            // AM/PM
            when 'P':u or
            when 'PP':u then
            do:
                {&_proparse_ prolint-nowarn(overflow)}
                assign timeValue = interval(pTimestamp, date(pTimestamp), 'hour':u).
                if timeValue ge 12 then
                    assign tokenValue = 'PM':u.
                else
                    assign tokenValue = 'AM'.
                // A -> A or P; AA -> AM or PM
                assign tokenValue = substring(tokenValue, 1, length(pTokenArg)).
            end.
        end case.
        
        return tokenValue.
    end method.
    
    /** Splits a .-delimited token argument into an array
    
        @param character the token argument to return
        @return character[] An array of character. If the input arg is empty/null we return a [1] array */
    method static private character extent SplitTokenArg (input pTokenArg as character):
        define variable args as character extent no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        if    pTokenArg eq '':u
           or pTokenArg eq ?
           then
            assign extent(args) = 1.
        else
        do:
            assign cnt          = num-entries(pTokenArg, '.':u)
                   extent(args) = cnt
                   .
            do loop = 1 to cnt:
                args[loop] = entry(loop, pTokenArg, '.':u).
            end.
        end.
        return args.
    end method.
    
    /* Resolves a CP-based token arg, based on the client-principal.
        
       It is the CALLER's responsibility to clean up the C-P object represented by this handle
       
       @param character The token argument for ${CP.*} tokens
       @param handle     A user represented by a client-principal
       @return character The resolved string  */
    method static public character ResolveUser(input pTokenArg as character,
                                               input pUser as handle):
        define variable tokenValue as character no-undo.
        define variable args as character extent no-undo.
        define variable dynCall as handle no-undo.
        
        if not valid-handle(pUser) then
            return ?.
        
        if not pUser:type eq 'Client-Principal':u then
            return ?.
        
        assign tokenValue = ?
               args       = SplitTokenArg(pTokenArg)
               .
        case args[1]:
            when 'tid':u then
            do:
                if extent(args) eq 1 then
                    assign tokenValue = string(pUser:tenant-id()).
                else
                    assign tokenValue = string(pUser:tenant-id(args[2])).
            end.
            when 'tname':u then
            do:
                if extent(args) eq 1 then
                    assign tokenValue = pUser:tenant-name().
                else
                    assign tokenValue = pUser:tenant-name(args[2]).
            end.    //tenant
            when 'uid':u then
                assign tokenValue = pUser:user-id.
            when 'quid':u then
                assign tokenValue = pUser:qualified-user-id.
            when 'domain':u then
                assign tokenValue = pUser:domain-name.
            when 'prop':u then
                assign tokenValue = pUser:get-property(args[2]).
            otherwise
            do:
                create call dynCall.
                assign dynCall:call-type = get-attr-call-type
                       dynCall:call-name = args[1]
                       dynCall:in-handle = pUser
                       .
                dynCall:invoke() no-error.
                assign tokenValue = dynCall:return-value.
            end.    //other properties
        end case.
        
        return tokenValue.
        finally:
            if valid-object(dynCall) then
                delete object dynCall no-error.
        end finally.
    end method.
    
    /* Resolves a session value: using an attribute of the SESSION handle.
       
       @param character The token argument for ${SESSION.*} tokens
       @param character Context for the session token resolution
       @return character The resolved string  */
    {&_proparse_ prolint-nowarn(varusage)}
    method static public character ResolveSession(input pTokenArg as character,
                                                  input pSessionCtx as character):
        define variable dynCall as handle no-undo.
        define variable args as character extent no-undo.
        define variable tokenVal as character no-undo initial ?.
        define variable cnt as integer no-undo.
        
        if pTokenArg eq ?
        then
            return tokenVal.
        
        assign args = SplitTokenArg(pTokenArg)
               cnt  = extent(args)
               .
        if cnt eq ?
        or args[1] eq '':u
        then
            return tokenVal.
        
        // we can get the rest dynamically.
        if not valid-handle(dynCall) then
            create call dynCall.
        else
            dynCall:clear().
        
        assign dynCall:call-type = get-attr-call-type
               dynCall:call-name = pTokenArg
               dynCall:in-handle = session:handle
               .
        dynCall:invoke() no-error.
        assign tokenVal = substitute('&1':u, dynCall:return-value).
        
        return tokenVal.
        finally:
            if valid-object(dynCall) then
                delete object dynCall no-error.
            
            assign error-status:error = false.
        end finally.
    end method.
    
    /* Resolves a single token into appropriate values, optionally using some input context
       
       @param Token (required) The token
       @param Progress.Lang.Object (optional) Context used to resolve the token. eg a TimeStamp for times */
    method static public void ResolveToken(input pToken as Token,
                                           input pContext as Progress.Lang.Object):
        if valid-object(pToken) then
            assign pToken:Value = ResolveToken(pToken:Group, pToken:Arg, pContext).
    end method.
    
    /* Resolves a single token into appropriate values, optionally using some input context
       
       @param character (required) The token group
       @param character (optional) The token argument
       @param Progress.Lang.Object (optional) Context used to resolve the token. eg a TimeStamp for times
       @return character The token value. Returns the UNKNOWN value if the token cannot be resolved */
    method static public character ResolveToken(input pTokenGroup as character,
                                                input pTokenArg as character,
                                                input pContext as Progress.Lang.Object):
        define variable dotPos as integer no-undo.
        define variable tea as TokenResolverEventArgs no-undo.
        
        assign tea             = new TokenResolverEventArgs(pTokenGroup, pTokenArg)
               tea:SourceValue = pContext
               .
        // see if anyone wants to change this token, or handle tokens we don't know about
        // WEB tokens are resolved via this publish mechanism
        TokenResolver:TokenResolved:Publish(get-class(TokenResolver), tea).
        
        // if the value is still ?, resolve as best we can
        if tea:TokenValue eq ? then
        case pTokenGroup:
            when 'session':u then
                assign tea:TokenValue = ResolveSession(pTokenArg, session:startup-parameters).
            
            when 't':u or
            when 'time':u then
            case true:
                when not valid-object(pContext) then
                    assign tea:TokenValue  = ResolveTime(pTokenArg, now).
                when type-of(pContext, TimeStamp) then
                    assign tea:TokenValue  = ResolveTime(pTokenArg, cast(pContext, TimeStamp):ToDateTimeTz() ).
                when type-of(pContext, IDateTimeTzHolder) then
                    assign tea:TokenValue  = ResolveTime(pTokenArg, cast(pContext, IDateTimeTzHolder):Value ).
            end case.
            
            when 'guid':u then
                assign tea:TokenValue = guid.
            
            when 'uuid':u then
                assign tea:TokenValue = substring(base64-encode(generate-uuid), 1, 22).
            
            when 'env':u then
            case pTokenArg:
                when 'CATALINA_BASE':u then
                do:
                    if mInstanceRoot eq '':u then
                        assign tea:TokenValue = os-getenv(pTokenArg)
                               mInstanceRoot  = tea:TokenValue
                               .
                    else
                        assign tea:TokenValue = mInstanceRoot.
                end.
                otherwise
                    assign tea:TokenValue = os-getenv(pTokenArg).
            end case.   // ENV.<arg>
            
            when 'version':u or
            when 'ver':u then
            case pTokenArg:
                when 'major':u then
                    assign tea:TokenValue = session:local-version-info:OEMajorVersion.
                when 'minor':u then
                    assign tea:TokenValue = session:local-version-info:OEMinorVersion.
                when 'maint':u then
                    assign tea:TokenValue = session:local-version-info:OEMaintVersion.
            end case.    // version
            
            when 'request':u or
            when 'req':u then
            if valid-object(session:current-request-info) then
            case pTokenArg:
                when 'tpt':u then
                    assign tea:TokenValue = string(session:current-request-info:AdapterType).
               when 'ccid':u then
                    assign tea:TokenValue = session:current-request-info:ClientContextId.
                when 'id':u then
                    assign tea:TokenValue = session:current-request-info:RequestId.
                when 'session':u then
                    assign tea:TokenValue = string(session:current-request-info:SessionId).
                when 'thread':u then
                    assign tea:TokenValue = string(session:current-request-info:ThreadId).
                when 'agent':u then
                    assign tea:TokenValue = string(session:current-request-info:AgentId).
                when 'proc':u then
                    assign tea:TokenValue = session:current-request-info:ProcedureName.
            end case.
            
            when 'cp':u then
                if     valid-object(pContext)
                   and type-of(pContext, Principal)
                then
                    assign tea:TokenValue = ResolveUser(pTokenArg, cast(pContext, Principal):Token).
            
            when 'name':u then
                if valid-object(pContext) then
                    //tokenArg = format-expression "." logger-name
                    assign dotPos         = index(pTokenArg, '.':u)
                           tea:TokenValue = ResolveName(substring(pTokenArg, 1, dotPos - 1), string(pContext))
                           .
        end case.   // token-group
        
        return tea:TokenValue.
    end method.
    
    /* Extracts any tokens from a string, and returns them as an array of token objects
       
       @param character The string potentially containing tokens
       @return Token[]  An array of tokens. May be indeterminate in size if there are no tokens. */
    method static public Token extent Parse(input pBaseString as character):
        define variable tokens as Token extent no-undo.
        define variable startPos as integer no-undo.
        define variable endPos as integer no-undo.
        define variable idx as integer no-undo.
        define variable token as character no-undo.
        
        if    pBaseString eq ?
           or pBaseString eq '':u
        then
            return tokens.
        
        assign idx = num-entries(pBaseString, '$':u + StringConstant:CURLY_OPEN).
        if idx eq 1 then
            return tokens.
        
        assign extent(tokens) = idx - 1
               idx            = 1
               startPos       = index(pBaseString, '$':u + StringConstant:CURLY_OPEN)
               .
        do while startPos gt 0:
            assign endPos     = index(pBaseString, StringConstant:CURLY_CLOSE)
                   token      = substring(pBaseString, startPos, endPos - startPos + 1)
                   token      = trim(token, '$':u + StringConstant:CURLY_OPEN)
                   token      = trim(token, StringConstant:CURLY_CLOSE)
                   
                   // chop off the and everything preceeding the first } in the string
                   pBaseString = substring(pBaseString, endPos + 1)
                   // see if there's another token
                   startPos     = index(pBaseString, '$':u + StringConstant:CURLY_OPEN)
                   tokens[idx] = OpenEdge.Core.Util.Token:Parse(token)
                   idx         = idx + 1
                   .
        end.
        
        return tokens.
    end method.
    
    /* Resolves any tokens in the file name into appropriate values
       
       @param character The source string
       @return character The resolved string */
    method static public character Resolve(input pcBaseString as character):
        var Token[] tokens.
        var Progress.Lang.Object tokenCtx.
        var handle currentUser.
        var datetime-tz currentTime.
        var integer strLen, loop, cnt, pos.
        var character tokenStr, logicalDb.
        
        assign /* use a variable to fix the time used in the filename. if we use now or time, we may flip
                  to the next (milli)second during the execution of this loop */
               currentTime    = now
               tokens         = TokenResolver:Parse(pcBaseString)
               cnt            = extent(tokens)
               .
        do loop = 1 to cnt:
            case tokens[loop]:Group:
                when 't':u or
                when 'time':u then
                    assign tokenCtx = new TimeStamp(currentTime).
                
                when 'cp':u then
                do:
                    if num-entries(tokens[loop]:Arg, '.':u) gt 1 then
                    do:
                        assign logicalDb = entry(2, tokens[loop]:Arg, '.':u).
                        if     valid-handle(currentUser)
                           and lookup(logicalDb, currentUser:db-list) eq 0
                        then
                            delete object currentUser no-error.
                        
                        if not valid-handle(currentUser) then
                            assign currentUser = get-db-client(logicalDb) no-error.
                    end.
                    
                    if not valid-handle(currentUser) then
                        assign currentUser = security-policy:get-client().
                    
                    if valid-handle(currentUser) then
                        // the C-P represented by currentUser is manually cleaned up in the Principal object's destructor
                        assign tokenCtx = new Principal(currentUser, true).
                end.    //cp
                
                when 'name':u then
                do:
                    // use the value from the "dots" first.
                    assign pos = index(tokens[loop]:Arg, '.':u).
                    if pos gt 0 then
                        assign tokenCtx = new String(substring(tokens[loop]:Arg, pos + 1)).
                end.
            end case.
            
            // resolve the individual token
            assign tokens[loop]:Value = ResolveToken(tokens[loop]:Group, tokens[loop]:Arg, tokenCtx).
            
            // If there are multiple of the same-named tokens in the string, replace them one-by-one,
            // Actual value
            if not tokens[loop]:Value eq ?
            // unknown value uses "?"
            or tokens[loop]:AllowUnknownValue
            then
                assign tokenStr     = '$':u + StringConstant:CURLY_OPEN + string(tokens[loop]) + StringConstant:CURLY_CLOSE
                       strLen       = length(tokenStr)
                       pos          = index(pcBaseString, tokenStr)
                       pcBaseString = replace(substring(pcBaseString, 1, pos + strLen), tokenStr,
                                              // using SUBSTITUTE() to turn ? into "?"
                                              substitute('&1', tokens[loop]:Value))
                                    + substring(pcBaseString, pos + strLen + 1)
                       .
        end.
        
        return pcBaseString.
    end method.
    
end class.
