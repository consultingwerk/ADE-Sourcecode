/************************************************
Copyright (c)  2013, 2016, 2018, 2021 by Progress Software Corporation. All rights reserved.
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
block-level on error undo, throw.

using Ccs.Common.Support.IDateTimeTzHolder.
using OpenEdge.Core.TimeStamp.
using Progress.Lang.Object.

class OpenEdge.Core.TimeStamp serializable : 
    /* (mandatory) The format of the data as passed into the constructor. One of DATE, DATETIME or DATETIME-TZ */
    define public property Format as character no-undo get. private set.
    
    define private variable mtDate as date no-undo.
    define private variable miTime as integer no-undo.
    define private variable miTZOffset as integer no-undo.
    
    /* Constructor 
       
       @param date A timestamp. Timezone is inferred from the session */
    constructor public TimeStamp(ptTimeStamp as date):
        super().
        
        assign mtDate = ptTimeStamp
               this-object:Format = 'Date'.
    end constructor.
    
    /* Constructor 
       
       @param datetime A timestamp. Timezone is inferred from the session */
    constructor public TimeStamp(ptTimeStamp as datetime):
        super().
        
        assign mtDate = date(ptTimeStamp)
               miTime = mtime(ptTimeStamp)
               this-object:Format = 'DateTime'.
    end constructor.
    
    /* Constructor 
       
       @param datetime-tz A 'complete' timestamp */
    constructor public TimeStamp(ptTimeStamp as datetime-tz):
        super().
        
        assign mtDate = date(ptTimeStamp)
               miTime = mtime(ptTimeStamp)
               miTZOffset = timezone(ptTimeStamp)
               this-object:Format = 'DateTime-TZ'.
    end constructor.

    /* Constructor 
       
       @param character An ISO-DATE representation of a timestamp */
    constructor public TimeStamp(input pcTimeStamp as character):
        define variable tTimeStamp as datetime-tz no-undo.
        
        super().
        
        tTimeStamp = TimeStamp:ToABLDateTimeFromISO(pcTimeStamp).
        
        assign mtDate = date(tTimeStamp)
               miTime = mtime(tTimeStamp)
               miTZOffset = timezone(tTimeStamp)
               this-object:Format = 'DateTime-TZ'.
    end constructor.
    
    /* Default Constructor */
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
    
    /** Converts an ABL datetime into a correct ISO date.
        
        @return character An ISO date.      */
    method public character ToISODate():
        return iso-date(ToDateTimeTz()).
    end method.
    
    /** Converts an ABL datetime into a correct ISO date.
        
        @param date The date value to convert
        @return character An ISO date.      */
    method static public character ToISODateFromABL(input ptValue as date):
        return iso-date(datetime-tz(ptValue)).
    end method.
    
    /** Converts an ABL datetime into a correct ISO date.
        
        @param datetime The date value to convert
        @return character An ISO date.      */
    method static public character ToISODateFromABL(input ptValue as datetime):
        return iso-date(datetime-tz(ptValue)).
    end method.
    
    /** Converts an ABL datetime into a correct ISO date.
        
        @param datetime-tz The date value to convert
        @return character An ISO date.      */
    method static public character ToISODateFromABL(input ptValue as datetime-tz):
        return iso-date(ptValue).
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
    
    /** Converts an HTTP 'sane date' into an ABL DATETIME-TZ. The HTTP date is
        defined at http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3
        
        One of the following formats will be used:
            Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
            Sunday, 06-Nov-94 08:49:37 GMT ; RFC 850, obsoleted by RFC 1036
            Sun Nov  6 08:49:37 1994       ; ANSI C's asctime() format
        
        @param character An ISO date
        @return datetime-tz The date value to convert.      */
    method static public datetime-tz ToABLDateTimeTzFromHttp(input pcValue as character):
        define variable cTime as character no-undo.
        define variable iYear as integer no-undo.
        define variable iMonth as integer no-undo.
        define variable iDay as integer no-undo.        
        /* Always English month names. Use the CSV to convert from name to number */
        define variable cMonthList as character no-undo
            initial 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec'.
        
        /* ANSI C date:
           Sun Nov  6 08:49:37 1994       ; ANSI C's asctime() format */
        if index(pcValue, ',') eq 0 then
            assign iMonth = lookup(entry(2, pcValue, ' '), cMonthList)
                   /* note the double space between Month and Day, so entry 3 is missing */
                   iDay   = integer(entry(4, pcValue, ' '))
                   cTime = entry(5, pcValue, ' ')
                   iYear  = integer(entry(6, pcValue, ' ')).
        else
        /* Sunday, 06-Nov-94 08:49:37 GMT ; RFC 850, obsoleted by RFC 1036 */
        if num-entries(pcValue, ' ') eq 4 then
            assign cTime  = entry(2, pcValue, ' ')  /* lazy/reuse variable */
                   iDay   = integer(entry(1, cTime, '-'))
                   iMonth = lookup(entry(2, cTime, '-'), cMonthList)
                   iYear  = integer(entry(3, cTime, '-'))
                   cTime  = entry(3, pcValue, ' ').
        else
        /* Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123 */
            assign iDay   = integer(entry(2, pcValue, ' '))
                   iMonth = lookup(entry(3, pcValue, ' '), cMonthList)
                   iYear  = integer(entry(4, pcValue, ' '))
                   cTime  = entry(5, pcValue, ' ').
        
        return datetime-tz(iMonth, iDay, iYear,
            integer(entry(1, cTime, ':')),       /* hour */
            integer(entry(2, cTime, ':')),       /* minute */
            integer(entry(3, cTime, ':')),       /* second */
            0,                          /* millisecond */
            0).                         /* timezone (always GMT per spec) */
    end method.
    
    /** Converts an ABL date into an HTTP 'sane date', according to RFC 822, as 
        defined at http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3
        
        One of the following formats will be used:
            Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
        
        @param character An ISO date
        @return datetime-tz The date value to convert.      */
    method static public character ToHttpDateFromABL(input ptValue as datetime-tz):
        /* Always English month names. Use the CSV to convert from name to number */
        define variable cMonthList as character extent 12 no-undo
            initial ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'].
            
        define variable cDayOfWeekList as character extent 7 no-undo
            initial ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'].
        
        define variable tUTCValue as datetime-tz no-undo.
        
        if timezone(ptValue) eq 0 then
            assign tUTCValue = ptValue.
        else    
            assign tUTCValue = datetime-tz(ptValue, 0).
        
        /* Sun, 06 Nov 1994 08:49:37 GMT  */
        return substitute('&1, &2 &3 &4 &5 GMT',
                cDayOfWeekList[weekday(tUTCValue)],
                string(day(tUTCValue), '99'),
                cMonthList[month(tUTCValue)],                
                year(tUTCValue),
                string(integer(mtime(tUTCValue) / 1000), 'HH:MM:SS') ).
    end method.
    
    /** Converts this TimeStamp into an HTTP 'sane date', according to RFC 822, as 
        defined at http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3
        
        One of the following formats will be used:
            Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
        
        @return datetime-tz The date value to convert.      */
    method public character ToHttpDate():
        return TimeStamp:ToHttpDateFromABL(ToDateTimeTz()).
    end method.
    
    /* Converts the current TimeStamp to an ABL datetime-tz value
       
       @return datetime-tz The datetime-tz represented by this TimeStamp */
    method public datetime-tz ToDateTimeTz():
        return datetime-tz(mtDate, miTime, miTZOffset).
    end method.
    
    /* Converts the current TimeStamp to an ABL datetime value
       
       @return datetime The datetime represented by this TimeStamp */
    method public datetime ToDateTime():
        return datetime(mtDate, miTime).
    end method.

    /* Converts the current TimeStamp to an ABL date value
       
       @return date The datetime-tz represented by this TimeStamp */
    method public date ToDate():
        return mtDate.
    end method.

    /* Returns the current TimeStamp's time in milliseconds since midnight.
       
       @return integer The milliseconds represented by this TimeStamp */
    method public integer ToTime():
        return miTime.
    end method.
    

    /* Returns the time interval between unix epoch and this date
            where unix epoch is an ABL date constructed as
                datetime(1,1,1970,0,0,0,0)
       
       @return int64 The seconds since the unix epoch  */
    method public int64 SecondsSinceUnixEpoch():
        var datetime-tz epoch = datetime(1,1,1970,0,0,0,0).
        var datetime-tz thisDate = ToDateTimeTz().
        return interval(thisDate, epoch, "seconds") .
    end method.
    
    
end class.
