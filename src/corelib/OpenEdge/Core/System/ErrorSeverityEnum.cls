/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : ErrorSeverityEnum
    Purpose     : Enumeration of error severities 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jun 26 14:23:12 EDT 2009
    Notes       : * Based on the AutoEdge|TheFactory version 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.System.ErrorSeverityEnum.
using OpenEdge.Core.FlagsEnum.

class OpenEdge.Core.System.ErrorSeverityEnum serializable inherits FlagsEnum :
    
    define static public property Default  as ErrorSeverityEnum no-undo get. private set.
    define static public property None     as ErrorSeverityEnum no-undo get. private set.
    define static public property Fatal    as ErrorSeverityEnum no-undo get. private set.
    define static public property Critical as ErrorSeverityEnum no-undo get. private set.
    define static public property Error    as ErrorSeverityEnum no-undo get. private set.
    define static public property Warning  as ErrorSeverityEnum no-undo get. private set.
    define static public property Message  as ErrorSeverityEnum no-undo get. private set.
    define static public property Info     as ErrorSeverityEnum no-undo get. private set.
    define static public property Debug    as ErrorSeverityEnum no-undo get. private set.
    
    constructor static ErrorSeverityEnum():
        ErrorSeverityEnum:None = new ErrorSeverityEnum(1, 'None').
        ErrorSeverityEnum:Fatal = new ErrorSeverityEnum(2, 'Fatal').
        ErrorSeverityEnum:Critical = new ErrorSeverityEnum(4, 'Critical').
        ErrorSeverityEnum:Error = new ErrorSeverityEnum(8, 'Error').
        ErrorSeverityEnum:Warning = new ErrorSeverityEnum(16, 'Warning').
        ErrorSeverityEnum:Message = new ErrorSeverityEnum(32, 'Message').
        ErrorSeverityEnum:Info = new ErrorSeverityEnum(64, 'Info').
        ErrorSeverityEnum:Debug  = new ErrorSeverityEnum(128, 'Debug').
        
        ErrorSeverityEnum:Default = ErrorSeverityEnum:Error.
    end constructor.

    constructor public ErrorSeverityEnum ( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.

end class.
