/* *************************************************************************************************************************
Copyright (c) 2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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

using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.

class OpenEdge.Logging.Format.ABLSubstituteFormat implements ILoggerFilter:
    
        /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter( input poEvent as LogEvent ):
        define variable iSize as integer no-undo.
        define variable iLoop as integer no-undo.
        
        if not valid-object(poEvent) then
            return.
        
        assign iSize = extent(poEvent:Message:Arguments).
        if iSize eq ? then
            return.
        assign poEvent:Message:Message = substitute(poEvent:Message:Message,
                                    (if iSize ge 1 then poEvent:Message:Arguments[1] else ?),
                                    (if iSize ge 2 then poEvent:Message:Arguments[2] else ?),
                                    (if iSize ge 3 then poEvent:Message:Arguments[3] else ?),
                                    (if iSize ge 4 then poEvent:Message:Arguments[4] else ?),
                                    (if iSize ge 5 then poEvent:Message:Arguments[5] else ?),
                                    (if iSize ge 6 then poEvent:Message:Arguments[6] else ?),
                                    (if iSize ge 7 then poEvent:Message:Arguments[7] else ?),
                                    (if iSize ge 8 then poEvent:Message:Arguments[8] else ?),
                                    (if iSize ge 9 then poEvent:Message:Arguments[9] else ?)).

        if iSize gt 9 then
        do iLoop = 10 to iSize:
            assign poEvent:Message:Message = substitute(poEvent:Message:Message + '; &1 ':u,
                                                    poEvent:Message:Arguments[iLoop]).
        end.
    end method.
        
end class.
