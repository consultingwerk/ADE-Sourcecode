/* *************************************************************************************************************************
Copyright (c) 2017-2018, 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ABLSubstituteFormat
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Nov 16 13:03:48 EST 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ILongcharArrayHolder.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.

class OpenEdge.Logging.Format.ABLSubstituteFormat implements ILoggerFilter:
    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter( input poEvent as LogEvent ):
        define variable iSize as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable args as character extent no-undo.
        define variable ctx as Progress.Lang.Object no-undo.
        
        // we expect an array of values for context
        assign ctx = poEvent:Message:GetContext('args':u).
        if    not valid-object(ctx)
           or not type-of(ctx, ILongcharArrayHolder)
        then
            return.
        
        {&_proparse_ prolint-nowarn(overflow)}
        assign args  = cast(ctx, ILongcharArrayHolder):Value
               iSize = extent(args)
               .
        if iSize eq ? then
            return.
        assign poEvent:Message:Message = substitute(poEvent:Message:Message,
                                    (if iSize ge 1 then args[1] else ?),
                                    (if iSize ge 2 then args[2] else ?),
                                    (if iSize ge 3 then args[3] else ?),
                                    (if iSize ge 4 then args[4] else ?),
                                    (if iSize ge 5 then args[5] else ?),
                                    (if iSize ge 6 then args[6] else ?),
                                    (if iSize ge 7 then args[7] else ?),
                                    (if iSize ge 8 then args[8] else ?),
                                    (if iSize ge 9 then args[9] else ?)).
        
        if iSize gt 9 then
        do iLoop = 10 to iSize:
            assign poEvent:Message:Message = substitute(poEvent:Message:Message + '; &1 ':u,
                                                        args[iLoop]).
        end.
    end method.
        
end class.
