/************************************************
Copyright (c)  2013, 2016, 2018, 2021-2025 by Progress Software Corporation. All rights reserved.
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

using OpenEdge.Core.Assert.
using OpenEdge.Core.TimeStamp.
using OpenEdge.Core.TimeStampConstants.
using Progress.Lang.Object.

class OpenEdge.Core.TimeStamp
serializable
:

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
    constructor public TimeStamp ( ):
        this-object(now).
    end constructor.

    method override public logical Equals (input p0 as Object):
        if type-of(p0, TimeStamp) then
        case this-object:Format:
            when 'Integer' then return (this-object:ToTime() eq cast(p0, TimeStamp):ToTime()).
            when 'Date' then return (this-object:ToDate() eq cast(p0, TimeStamp):ToDate()).
            when 'DateTime' then return (this-object:ToDateTime() eq cast(p0, TimeStamp):ToDateTime()).
            when 'DateTime-TZ' then return (this-object:ToDateTimeTz() eq cast(p0, TimeStamp):ToDateTimeTz()).
        end case.
        else
            return super:Equals(p0).
    end method.

    /** Converts an ABL datetime into a correct ISO date.

        @return character An ISO date.      */
    method public character ToISODate ( ):
        return iso-date(ToDateTimeTz()).
    end method.

    /** Converts an ABL datetime into a correct ISO date.

        @param date The date value to convert
        @return character An ISO date.      */
    method static public character ToISODateFromABL (input ptValue as date):
        return iso-date(datetime-tz(ptValue)).
    end method.

    /** Converts an ABL datetime into a correct ISO date.

        @param datetime The date value to convert
        @return character An ISO date.      */
    method static public character ToISODateFromABL (input ptValue as datetime):
        return iso-date(datetime-tz(ptValue)).
    end method.

    /** Converts an ABL datetime into a correct ISO date.

        @param datetime-tz The date value to convert
        @return character An ISO date.      */
    method static public character ToISODateFromABL (input ptValue as datetime-tz):
        return iso-date(ptValue).
    end method.

    /** Converts an ISO date into an ABL DATE. The ISO-DATE()
        requires the session's date format to be YMD before
        performing the conversion; this method wraps that.

        @param character An ISO date
        @return datetime-tz The date value to convert.      */
    method static public date ToABLDateFromISO (input pcValue as character):
        return date(TimeStamp:ToABLDateTimeTzFromISO(pcValue)).
    end method.

    /** Converts an ISO date into an ABL DATETIME. The ISO-DATE()
        requires the session's date format to be YMD before
        performing the conversion; this method wraps that.

        @param character An ISO date
        @return datetime The date value to convert.      */
    method static public datetime ToABLDateTimeFromISO (input pcValue as character):
        define variable tDateTimeTz as datetime-tz no-undo.

        tDateTimeTz = TimeStamp:ToABLDateTimeTzFromISO(pcValue).

        return datetime(date(tDateTimeTz), mtime(tDateTimeTz)).
    end method.

    /** Converts an ISO date into an ABL DATETIME-TZ. The ISO-DATE()
        requires the session's date format to be YMD before
        performing the conversion; this method wraps that.

        @param character An ISO date
        @return datetime-tz The date value to convert.      */
    method static public datetime-tz ToABLDateTimeTzFromISO (input pcValue as character):
        define variable cDateFormat as character no-undo.

        cDateFormat = session:date-format.
        session:date-format = 'ymd'.

        return datetime-tz(pcValue).
        finally:
            session:date-format = cDateFormat.
        end finally.
    end method.

    /* Attempts to parse a string representing a timestamp into a DATETIME-TZ value

       Strings that can be parsed:
          YY/MM/DD@HH:MM:SS.SSS[timezone]
            in this case the century is assumed to be the current century

          CCYY/MM/DD@HH:MM:SS.SSS[timezone]
          CCYY-MM-DDTHH:MM:SS.SSS[timezone]

          Any single character can be used for date or time separators.

          Timezone values can be
            +NNNN
            -NNNN
            +NN:NN
            -NN:NN
            Z

       @param character The timestamp string
       @return datetime-tz A valid timestamp, or the unknown value if the string cannot be parsed. */
    method static public datetime-tz TryParseTimestamp (input pValue as character):
        define variable dtz as datetime-tz no-undo.
        define variable tz as integer no-undo.

        //123456789012345678901234567890
        //22/02/04@13:47:55.989-0500
        if length(pValue) eq 26
        and index(pValue, '@':u) eq 9
        then
        do:
            assign tz = integer(substring(pValue, 23, 2)) * 60
                      + integer(substring(pValue, 25, 2)).
            if substring(pValue, 22, 1) eq '-':u then
                assign tz = tz * -1.

            assign dtz = datetime-tz(integer(substring(pValue, 4, 2)),      // month
                                     integer(substring(pValue, 7, 2)),      // day
                                     // assume the truncated year is the current century
                                     {&_proparse_ prolint-nowarn(overflow)}
                                     integer(truncate(year(today) / 100, 0) * 100) + integer(substring(pValue, 1, 2)),
                                     integer(substring(pValue, 10, 2)),     // hour
                                     integer(substring(pValue, 13, 2)),     // minute
                                     integer(substring(pValue, 16, 2)),     // second
                                     integer(substring(pValue, 19, 3)),     // millisecond
                                     tz )                                   // timezone
                          no-error.
        end.
        else
        //123456789012345678901234567890
        //2022/02/04@13:47:55.989-05:00
        if length(pValue) eq 29
        and ( index(pValue, '@':u) eq 11
             or index(pValue, 'T':u) eq 11 )
        then
        do:
            assign tz = integer(substring(pValue, 25, 2)) * 60
                      + integer(substring(pValue, 28, 2)).
            if substring(pValue, 24, 1) eq '-':u then
                assign tz = tz * -1.

            assign dtz = datetime-tz(integer(substring(pValue, 6, 2)),      // month
                                     integer(substring(pValue, 9, 2)),      // day
                                     integer(substring(pValue, 1, 4)),      // year
                                     integer(substring(pValue, 12, 2)),     // hour
                                     integer(substring(pValue, 15, 2)),     // minute
                                     integer(substring(pValue, 18, 2)),     // second
                                     integer(substring(pValue, 21, 3)),     // millisecond
                                     tz )                                   // timezone
                          no-error.
        end.
        else
        //123456789012345678901234567890
        //2022/02/04@13:47:55.989-0500
        if length(pValue) eq 28
        and ( index(pValue, '@':u) eq 11
             or index(pValue, 'T':u) eq 11 )
        then
        do:
            assign tz = integer(substring(pValue, 25, 2)) * 60
                      + integer(substring(pValue, 27, 2)).
            if substring(pValue, 24, 1) eq '-':u then
                assign tz = tz * -1.

            assign dtz = datetime-tz(integer(substring(pValue, 6, 2)),      // month
                                     integer(substring(pValue, 9, 2)),      // day
                                     integer(substring(pValue, 1, 4)),      // year
                                     integer(substring(pValue, 12, 2)),     // hour
                                     integer(substring(pValue, 15, 2)),     // minute
                                     integer(substring(pValue, 18, 2)),     // second
                                     integer(substring(pValue, 21, 3)),     // millisecond
                                     tz )                                   // timezone
                          no-error.
        end.
        //123456789012345678901234567890
        //2022/02/04@13:47:55.989Z
        else
        if length(pValue) eq 24
        and index(pValue, 'T':u) eq 11
        and index(pValue, 'Z') eq 24
        then
            assign dtz = datetime-tz(integer(substring(pValue, 6, 2)),      // month
                                     integer(substring(pValue, 9, 2)),      // day
                                     integer(substring(pValue, 1, 4)),      // year
                                     integer(substring(pValue, 12, 2)),     // hour
                                     integer(substring(pValue, 15, 2)),     // minute
                                     integer(substring(pValue, 18, 2)),     // second
                                     integer(substring(pValue, 21, 3)),     // millisecond
                                     0 )                                    // timezone
                          no-error.

        return dtz.
        finally:
            // get rid of any dangling  error status
            assign error-status:error = no
                   no-error.
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
    method static public datetime-tz ToABLDateTimeTzFromHttp (input pcValue as character):
        define variable cTime as character no-undo.
        define variable iYear as integer no-undo.
        define variable iMonth as integer no-undo.
        define variable iDay as integer no-undo.
        /* Always English month names. Use the CSV to convert from name to number */
        define variable cMonthList as character no-undo
            initial 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec'.

        /* ANSI C date:
           Sun Nov  6 08:49:37 1994       ; ANSI C's asctime() format (space-padded) */
        if index(pcValue, ',') eq 0 then do:
            /* A single-digit day will be space-padded, so first collapse double-spaces */
            assign pcValue = replace(pcValue, '  ', ' ').
            assign iMonth = lookup(entry(2, pcValue, ' '), cMonthList)
                   iDay   = integer(entry(3, pcValue, ' '))
                   cTime  = entry(4, pcValue, ' ')
                   iYear  = integer(entry(5, pcValue, ' ')).
        end.
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
    method static public character ToHttpDateFromABL (input ptValue as datetime-tz):
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
    method public character ToHttpDate ( ):
        return TimeStamp:ToHttpDateFromABL(ToDateTimeTz()).
    end method.

    /* Converts the current TimeStamp to an ABL datetime-tz value

       @return datetime-tz The datetime-tz represented by this TimeStamp */
    method public datetime-tz ToDateTimeTz ( ):
        return datetime-tz(mtDate, miTime, miTZOffset).
    end method.

    /* Converts the current TimeStamp to an ABL datetime value

       @return datetime The datetime represented by this TimeStamp */
    method public datetime ToDateTime ( ):
        return datetime(mtDate, miTime).
    end method.

    /* Converts the current TimeStamp to an ABL date value

       @return date The datetime-tz represented by this TimeStamp */
    method public date ToDate ( ):
        return mtDate.
    end method.

    /* Returns the current TimeStamp's time in milliseconds since midnight.

       @return integer The milliseconds represented by this TimeStamp */
    method public integer ToTime ( ):
        return miTime.
    end method.

    /* Returns the time interval in seconds between unix epoch and this date
            where unix epoch is an ABL date constructed as
                datetime(1,1,1970,0,0,0,0)

       @return int64 The seconds since the unix epoch  */
    method public int64 SecondsSinceUnixEpoch ( ):
        define variable thisDate as datetime-tz no-undo.

        assign thisDate = this-object:ToDateTimeTz().
        return interval(thisDate, TimeStampConstants:UnixEpoch, "seconds").
    end method.

    /* Returns the time interval in milliseconds between unix epoch and this date
            where unix epoch is an ABL date constructed as
                datetime(1,1,1970,0,0,0,0)

       @return int64 The number of milliseconds since the unix epoch  */
    method public int64 MillisecondsSinceUnixEpoch ( ):
        define variable thisDate as datetime-tz no-undo.

        assign thisDate = this-object:ToDateTimeTz().
        return interval(thisDate, TimeStampConstants:UnixEpoch, "milliseconds").
    end method.

end class.
