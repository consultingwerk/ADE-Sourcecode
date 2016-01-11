/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : TimeStamp
    Purpose     : Primitive class for date, TimeStamp and TimeStamp-tz values
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Nov 22 14:29:32 EST 2010
    Notes       : * Named 'TimeStamp' because of keyword/namespace conflicts with
                    ABL Primitive DATETIME. There's no built-in class for this.
                  * This version baed on the AutoEdge|TheFactory version
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.TimeStamp.
using Progress.Lang.Object.

class OpenEdge.Lang.TimeStamp:
    define public property Format as character no-undo get. private set.
    
    define private variable mtDate as date no-undo.
    define private variable miTime as integer no-undo.
    define private variable miTZOffset as integer no-undo.
    
    constructor public TimeStamp(piTimeStamp as integer):
        super().
        
        assign miTime = piTimeStamp
               this-object:Format = 'Integer'.
    end constructor.

    constructor public TimeStamp(ptTimeStamp as date):
        super().
        
        assign mtDate = ptTimeStamp
               this-object:Format = 'Date'.
    end constructor.
    
    constructor public TimeStamp(ptTimeStamp as datetime):
        super().
        
        assign mtDate = date(ptTimeStamp)
               miTime = mtime(ptTimeStamp)
               this-object:Format = 'DateTime'.
    end constructor.

    constructor public TimeStamp(ptTimeStamp as datetime-tz):
        super().
        
        assign mtDate = date(ptTimeStamp)
               miTime = mtime(ptTimeStamp)
               miTZOffset = timezone(ptTimeStamp)
               this-object:Format = 'DateTime-TZ'.
    end constructor.

    constructor public TimeStamp(input pcTimeStamp as character):
        define variable tTimeStamp as datetime-tz no-undo.
        
        super().
        
        tTimeStamp = TimeStamp:ToABLDateTimeFromISO(pcTimeStamp).
        
        assign mtDate = date(tTimeStamp)
               miTime = mtime(tTimeStamp)
               miTZOffset = timezone(tTimeStamp)
               this-object:Format = 'DateTime-TZ'.
    end constructor.
    
    constructor public TimeStamp():
        this-object(now).
    end constructor.
    
    method override public logical Equals(input p0 as Object):
        if type-of(p0, TimeStamp) then
        case this-object:Format:
            when 'Integer' then return (ToTime() eq cast(p0, TimeStamp):ToTime()).
            when 'Date' then return (ToDate() eq cast(p0, TimeStamp):ToDate()).
            when 'DateTime' then return (ToDateTime() eq cast(p0, TimeStamp):ToDateTime()).
            when 'DateTime-TZ' then return (ToDateTimeTz() eq cast(p0, TimeStamp):ToDateTimeTz()).
        end case.
        else
            return super:Equals(p0).
    end method.

    /** Converts an ABL datetime into a correct ISO date. The ISO-DATE()
        function requires the session's date format to be YMD before
        performing the conversion; this method wraps that.
        
        @return character An ISO date.      */
    method public character ToISODate():
        define variable cDateFormat as character no-undo.
        
        cDateFormat = session:date-format.
        session:date-format = 'ymd'.
        
        return iso-date(ToDateTimeTz()).
        finally:
            session:date-format = cDateFormat.        
        end finally.
    end method.

    /** Converts an ABL datetime into a correct ISO date. The ISO-DATE()
        function requires the session's date format to be YMD before
        performing the conversion; this method wraps that.
        
        @param date The date value to convert
        @return character An ISO date.      */
    method static public character ToISODateFromABL(input ptValue as date):
        return TimeStamp:ToISODateFromABL(datetime-tz(ptValue)).
    end method.
    
    /** Converts an ABL datetime into a correct ISO date. The ISO-DATE()
        function requires the session's date format to be YMD before
        performing the conversion; this method wraps that.
        
        @param datetime The date value to convert
        @return character An ISO date.      */
    method static public character ToISODateFromABL(input ptValue as datetime):
        return TimeStamp:ToISODateFromABL(datetime-tz(ptValue)).
    end method.
            
    /** Converts an ABL datetime into a correct ISO date. The ISO-DATE()
        function requires the session's date format to be YMD before
        performing the conversion; this method wraps that.
        
        @param datetime-tz The date value to convert
        @return character An ISO date.      */
    method static public character ToISODateFromABL(input ptValue as datetime-tz):
        define variable cDateFormat as character no-undo.
        
        cDateFormat = session:date-format.
        session:date-format = 'ymd'.
        
        return iso-date(ptValue).
        finally:
            session:date-format = cDateFormat.        
        end finally.
    end method.

    /** Converts an ISO date into an ABL DATE. The ISO-DATE()
        requires the session's date format to be YMD before
        performing the conversion; this method wraps that.
        
        @param character An ISO date
        @return datetime-tz The date value to convert.      */
    method static public date ToABLDateFromISO(input pcValue as character):
        return date(TimeStamp:ToABLDateTimeTzFromISO(pcValue)).
    end method.

    /** Converts an ISO date into an ABL DATETIME. The ISO-DATE()
        requires the session's date format to be YMD before
        performing the conversion; this method wraps that.
        
        @param character An ISO date
        @return datetime The date value to convert.      */
    method static public datetime ToABLDateTimeFromISO(input pcValue as character):
        define variable tDateTimeTz as datetime-tz no-undo.
        
        tDateTimeTz = TimeStamp:ToABLDateTimeTzFromISO(pcValue).
        
        return datetime(date(tDateTimeTz), mtime(tDateTimeTz)).
    end method.
            
    /** Converts an ISO date into an ABL DATETIME-TZ. The ISO-DATE()
        requires the session's date format to be YMD before
        performing the conversion; this method wraps that.
        
        @param character An ISO date
        @return datetime-tz The date value to convert.      */
    method static public datetime-tz ToABLDateTimeTzFromISO(input pcValue as character):
        define variable cDateFormat as character no-undo.
        
        cDateFormat = session:date-format.
        session:date-format = 'ymd'.
        
        return datetime-tz(pcValue).
        finally:
            session:date-format = cDateFormat.        
        end finally.
    end method.
    
    method public datetime-tz ToDateTimeTz():
        return datetime-tz(mtDate, miTime, miTZOffset).
    end method.
        
    method public datetime ToDateTime():
        return datetime(mtDate, miTime).
    end method.

    method public date ToDate():
        return mtDate.
    end method.
    
    method public integer ToTime():
        return miTime.
    end method.
    
end class.
