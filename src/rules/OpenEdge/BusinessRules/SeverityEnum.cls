/** ------------------------------------------------------------------------
    File        : SeverityEnum
    Purpose     : Enumeration of rules message severity
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Mar 01 14:30:23 EST 2013
    Notes       : * Based on Corticon Rules Message severity 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.BusinessRules.SeverityEnum.
using OpenEdge.Core.EnumMember.

class OpenEdge.BusinessRules.SeverityEnum final inherits EnumMember: 

    define public static property Info as SeverityEnum no-undo get. private set.
    define public static property Warning as SeverityEnum no-undo get. private set.
    define public static property Violation as SeverityEnum no-undo get. private set.
    
    constructor static SeverityEnum():
        SeverityEnum:Info = new SeverityEnum('Info').
        SeverityEnum:Warning = new SeverityEnum('Warning').
        SeverityEnum:Violation = new SeverityEnum('Violation').
    end constructor.
    
    constructor protected SeverityEnum(input pcName as character):
        super(pcName).
    end constructor.
    
    method public SeverityEnum EnumFromName(input pcName as character):
        case pcName:
            when SeverityEnum:Info:Name then return SeverityEnum:Info.
            when SeverityEnum:Warning:Name then return SeverityEnum:Warning.
            when SeverityEnum:Violation:Name then return SeverityEnum:Violation.
        end.
    end method.
      
end class.