/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LogLevelEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Feb 24 10:00:26 EST 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.Logging.LogLevelEnum:
    define enum     // The highest possible rank and is intended to turn off logging.
                    OFF = 0 

                    // Severe errors that cause premature termination. Expect these to be immediately visible on a status console.
                    FATAL

                    // Other runtime errors or unexpected conditions. Expect these to be immediately visible on a status console.
                    ERROR
                    
                    // Use of deprecated APIs, poor use of API, 'almost' errors, other runtime situations that are undesirable 
                    // or unexpected, but not necessarily "wrong". Expect these to be immediately visible on a status console.
                    WARN   

                    // Interesting runtime events (startup/shutdown). Expect these to be immediately visible on a console, 
                    // so be conservative and keep to a minimum.
                    INFO

                    // Detailed information on the flow through the system. Expect these to be written to logs only.
                    DEBUG

                    // Most detailed information. Expect these to be written to logs only.
                    TRACE
                    
                    DEFAULT = WARN
                .
end enum.
