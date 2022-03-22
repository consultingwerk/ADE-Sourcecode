/* *************************************************************************************************************************
Copyright (c) 2016-2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ErrorFormat
    Purpose     : Formats any errors
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2016-11-21
    Notes       : * Written for all events
                    - the error messages and their number
                    - the return value (if an AppError)
                    - any errors contained in a InnerError property of type P.L.Error
                    - any stops contained in an InnerStop property of type P.L.Stop
                  * Written for DEBUG events
                    - the error type name
                  * Written for TRACE events
                    - the error's call stack
                  
                  * This filter sets SESSION:ERROR-STACK-TRACE to TRUE. To prevent writing
                    an error's CallStack, set the WriteCallStack property to FALSE>
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.StringConstant.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.
using OpenEdge.Logging.LogLevelEnum.
using Progress.Lang.AppError.
using Progress.Reflect.DataType.
using Progress.Lang.LockConflict.

class OpenEdge.Logging.Format.ErrorFormat implements ILoggerFilter:
    /* If TRUE then the error being logged's CallStack is written to the message. TRUE by default */
    define public property WriteCallStack as logical no-undo
        get.
        set.
    
    /* Default constructor. */
    constructor public ErrorFormat():
        assign session:error-stack-trace = true
               WriteCallStack            = true
               .
    end constructor.
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter(input poEvent as LogEvent):
        define variable errLoop as integer no-undo.
        define variable errMax as integer no-undo.
        define variable ex as Progress.Lang.Error no-undo.
        define variable stoi as Progress.Lang.Stop no-undo.
        define variable errProp as Progress.Reflect.Property no-undo.
        define variable errHeader as character no-undo.
        
        // only do error stuff
        assign ex        = poEvent:Error
               errHeader = 'Error(s) raised:'
               .
        do while valid-object(ex):
            // only log error type for DEBUG logging
            assign poEvent:Message:Message = poEvent:Message:Message
                                           + StringConstant:LF + StringConstant:TAB
                                           + errHeader.
            if  (     valid-object(poEvent:Logger)
                  and poEvent:Logger:LogLevel ge LogLevelEnum:DEBUG )
               or poEvent:LogLevel ge LogLevelEnum:DEBUG
            then
                assign poEvent:Message:Message = poEvent:Message:Message + StringConstant:TAB + ex:GetClass():TypeName.
                
            assign errMax = ex:NumMessages.
            do errLoop = 1 to errMax:
                assign poEvent:Message:Message = poEvent:Message:Message
                                               + StringConstant:LF + StringConstant:TAB + StringConstant:TAB
                                               + ex:GetMessage(errLoop)
                                               + substitute(' (&1)':u, ex:GetMessageNum(errLoop) ).
            end.
            
            if     type-of(ex, AppError)
               and cast(ex, AppError):ReturnValue ne '':u
            then
                assign poEvent:Message:Message = poEvent:Message:Message
                                               + StringConstant:LF + StringConstant:TAB
                                               + substitute('ReturnValue: &1' , cast(ex, AppError):ReturnValue).
            
            WriteCallStack(ex:CallStack, poEvent).
            
            // Write the InnerStop inline, since there's not a lot of detail available for most.
            assign errProp = ex:GetClass():GetProperty('InnerStop':u).
            if  valid-object(errProp)
            and errProp:DataType eq DataType:Object
            and Progress.Lang.Class:GetClass(errProp:DataTypeName):IsA(get-class(Progress.Lang.Stop))
            then
            do:
                assign stoi = errProp:Get(ex).
                if valid-object(stoi) then
                do:
                    assign poEvent:Message:Message = poEvent:Message:Message + StringConstant:LF
                                                   + StringConstant:TAB + 'Stop condition raised: ' + stoi:GetClass():TypeName.
                    // this is the only Stop type with any meaningful extra info
                    if type-of(stoi, LockConflict) then
                        assign poEvent:Message:Message = poEvent:Message:Message + StringConstant:LF
                                                       + StringConstant:TAB + StringConstant:TAB
                                                       + 'Device: ' + cast(stoi, LockConflict):Device + StringConstant:LF
                                                       + StringConstant:TAB + StringConstant:TAB
                                                       + 'TableName: ' + cast(stoi, LockConflict):TableName + StringConstant:LF
                                                       + StringConstant:TAB + StringConstant:TAB
                                                       + 'User: ' + cast(stoi, LockConflict):User
                                                       .
                    WriteCallStack(stoi:CallStack, poEvent).
                end.    // valid stop
            end.    // InnerStop
            
            assign errProp = ex:GetClass():GetProperty('InnerError':u).
            if     valid-object(errProp)
               and errProp:DataType eq DataType:Object
               and Progress.Lang.Class:GetClass(errProp:DataTypeName):IsA(get-class(Progress.Lang.Error))
            then
                assign errHeader = 'Caused by:'
                       ex        = errProp:Get(ex).
            else
                assign ex = ?.
        end.
    end method.
    
    /* Writes a callstack to the message
       
       @param character The error or stop callstack
       @param LogEvent The current log event  */
    method private void WriteCallStack(input pCallStack as character,
                                       input pEvent as LogEvent):
        var integer errMax, errLoop.
        
        if not this-object:WriteCallStack
        or pCallStack eq ?
        then
            return.
        
        assign errMax = num-entries(pCallStack, StringConstant:LF).
        // Log error stacks for TRACE logging
        if (  (     valid-object(pEvent:Logger)
                and pEvent:Logger:LogLevel ge LogLevelEnum:TRACE )
             or pEvent:LogLevel ge LogLevelEnum:TRACE
             or session:debug-alert                                )
           and errMax gt 0
        then
        do:
            assign pEvent:Message:Message = pEvent:Message:Message + StringConstant:LF
                                          + StringConstant:TAB + 'Call stack:'.
            do errLoop = 1 to errMax:
                assign pEvent:Message:Message = pEvent:Message:Message + StringConstant:LF
                                              + StringConstant:TAB + StringConstant:TAB
                                              + entry(errLoop, pCallStack, StringConstant:LF).
            end.
        end.
    end method.
end class.
