/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : DateTimeAddIntervalEnum
    Purpose     : Enumeration of intervals for DATETIME and -TZ operations
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 11 11:35:55 EST 2010
    Notes       : * Taken fromA BL documentation
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.DateTimeAddIntervalEnum.
using OpenEdge.Core.EnumMember.

class OpenEdge.Core.DateTimeAddIntervalEnum final inherits EnumMember: 

    define static public property Default as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Years as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Months as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Weeks as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Days as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Hours as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Minutes as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Seconds as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Milliseconds as DateTimeAddIntervalEnum no-undo get. private set.
    
    constructor static DateTimeAddIntervalEnum():        
        assign DateTimeAddIntervalEnum:Years = new DateTimeAddIntervalEnum('Years')
               DateTimeAddIntervalEnum:Months = new DateTimeAddIntervalEnum('Months')
               DateTimeAddIntervalEnum:Weeks = new DateTimeAddIntervalEnum('Weeks')
               DateTimeAddIntervalEnum:Days = new DateTimeAddIntervalEnum('Days')
               DateTimeAddIntervalEnum:Hours = new DateTimeAddIntervalEnum('Hours')
               DateTimeAddIntervalEnum:Minutes = new DateTimeAddIntervalEnum('Minutes')
               DateTimeAddIntervalEnum:Seconds = new DateTimeAddIntervalEnum('Seconds')
               DateTimeAddIntervalEnum:Milliseconds = new DateTimeAddIntervalEnum('Milliseconds')
               
               DateTimeAddIntervalEnum:Default = DateTimeAddIntervalEnum:Milliseconds
               .
    end constructor.
    
    constructor public DateTimeAddIntervalEnum(pcName as character):
        super(pcName).
    end constructor.
    
end class.
