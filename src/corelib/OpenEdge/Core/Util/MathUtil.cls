/************************************************
Copyright (c) 2014, 2017, 2020-2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : MathUtil
    Purpose     : General-purpose maths functionality.
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Thu May 15 14:44:19 EDT 2014
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.String.
using OpenEdge.Core.Util.MathUtil.
using Progress.Lang.AppError.

class OpenEdge.Core.Util.MathUtil:
    /* Keep the default in a readonly property - it is 10 */
    define static private property DEFAULT_BASE as integer initial 10 no-undo get.
    
    /** Return a ceiling value (a always-round-up value).
            
        So,
            2.1 returns 3
            1.9 returns 2
            5.0 returns 5
    
        @param decimal  The value to adjust
        @return integer The ceiling value   */
    method static public integer Ceiling (input pdVal as decimal):
        var decimal truncVal = truncate(pdVal, 0).
        
        if truncVal eq pdVal then
            {&_proparse_ prolint-nowarn(overflow)}
            return integer(pdVal).
        else
            {&_proparse_ prolint-nowarn(overflow)}
            return integer(truncate(pdVal, 0) + 1).
    end method.
    
    /** Converts hex to integer values
        
        @param character A hex value
        @return int64 The integer representation of that hex value.   */
    method public static int64 HexToInt(input pcHex as character):
        return HexToInt(pcHex, DataTypeEnum:Int64).
    end method.
    
    /** Converts hex to integer values
        
        @param character A hex value
        @return integer The integer representation of that hex value.   */
    method public static integer HexToInt32(input pcHex as character):
        // we can use the INTEGER function because the HexToInt method guarantees
        // us an integer value is returned.
        {&_proparse_ prolint-nowarn(overflow)}
        return integer(HexToInt(pcHex, DataTypeEnum:Integer)).
    end method.
    
    /* Converts a hex string to an integer or int64.
       
       The string cannot be longer than 8 (integer) or 16 (int64) characters. If shorter than that, the string is
       padded with '0'.
       
       @param character A hex string.
       @param DataTypeEnum The type of integer (integer or int64).
       @return int64 The integer return value. May contain an integer value */
    method private static int64 HexToInt(input pHex as character,
                                         input pDataType as DataTypeEnum):
        var integer loop, maxLength, hexLen, numBytes.
        var raw rHex.
        var memptr memInt.
        
        if pHex eq ? then
            return 0.
        
        if pHex eq ? then
            return ?.
        
        if pDataType eq DataTypeEnum:Integer then
            assign numBytes = 4.
        else
        // any type type's not Integer (incl unknown value) becomes INT64
            assign numBytes  = 8
                   pDataType = DataTypeEnum:Int64
                   .
        assign maxLength = numBytes * 2
               pHex      = trim(pHex)
               hexLen    = length(pHex)
               pHex      = fill('0':u, maxLength - hexLen) + pHex
               .
        if length(pHex) gt maxLength then
            return error new AppError(substitute('Length of "&1" is greater than &2 characters', pHex, maxLength), 0).
        
        set-size(memInt) = numBytes.
        set-byte-order(memInt) = big-endian.
        
        do loop = 1 to numBytes:
            assign rHex         = hex-decode(substring(pHex, (2 * loop) - 1, 2))
                   length(rHex) = 1
                   .
            put-byte(memInt, loop) = get-byte(rHex, 1).
        end.
        // If we ask for an integer, we're guaranteed that it'll be an integer ("long")
        if pDataType eq DataTypeEnum:Integer then
            return get-long(memInt, 1).
        // ... and an int64 in all other cases
        else
            return get-int64(memInt, 1).
        finally:
            set-size(memInt) = 0.
        end finally.
    end method.
    
    /** Converts an exponent (123e4) value into a decimal using a exponent
        base of 10.
        
        @param character The exponent value
        @param decimal The converted value  */
    method static public decimal ExponentialToDec(input pExpVal as character):
        return MathUtil:ExponentialToDec(pExpVal, DEFAULT_BASE).
    end method.
    
    /** Converts an exponent (123e4) value into a decimal.
        The format is
             nnn[.nnn]e[-]nnn
             <base>e<exponent>
        The <exponent> is raised as a power of the exponent-base.
        
        @param character The exponent value
        @param integer The exponent base. Must be a positive value (>0)
        @param decimal The converted value  */
    method static public decimal ExponentialToDec(input pExpVal as character,
                                                  input pBase as integer):
        define variable idx as integer no-undo.
        define variable decVal as decimal no-undo initial 0.00.
        define variable coefficient as decimal no-undo.
        define variable exponent as integer no-undo.
        
        if String:IsNullOrEmpty(pExpVal) then
            return decVal.
        Assert:IsPositive(pBase, 'Exponent base').
        
        assign idx = index(pExpVal, 'e':u).
        if idx eq 0 then
            assign decVal = decimal(pExpVal).
        else
            assign coefficient = decimal(substring(pExpVal, 1, idx - 1))
                   exponent    = integer(substring(pExpVal, idx + 1))
                   decVal      = coefficient * exp(pBase, exponent)
                   .
        return decVal.
    end method.
    
    /** Converts an integer to a padded hex value
        
        @param integer An integer value
        @param integer The total length of the hex value. If the length of the hex value is larger than this,
                       use the value as-is. If the length of the hex value is les, pad with leading zeros to make
                       the link. Negative numbers will always be at least 8 characters long, and padded with F's.
        @return character A hex value */
    method static public character IntToHex(input pValue as integer,
                                            input pPadding as integer):
        var character hexVal = IntToHex(pValue, DataTypeEnum:Integer).
        var integer len = length(hexVal).
        
        if pPadding gt len then
        do:
            if pValue ge 0 then
                return fill('0':u, pPadding - len) + hexVal.
            else
            if pValue lt 0 then
                return fill('F':u, pPadding - len) + hexVal.
        end.
        
        return hexVal.
    end method.
    
    /** Converts a 64-bit integer to a padded hax value
        
        @param int64   An integer value
        @param integer The total length of the hex value. If the length of the hex value is larger than this,
                       use the value as-is. If the length of the hex value is les, pad with leading zeros to make
                       the link. Negative numbers will always be at least 8 characters long, and padded with F's.
        @return character A hex value */
    method static public character IntToHex(input pValue as int64,
                                            input pPadding as integer):
        var character hexVal = IntToHex(pValue, DataTypeEnum:Int64).
        var integer len = length(hexVal).
        
        if pPadding gt len then
        do:
            if pValue ge 0 then
                return fill('0':u, pPadding - len) + hexVal.
            else
            if pValue lt 0 then
                return fill('F':u, pPadding - len) + hexVal.
        end.
        
        return hexVal.
    end method.
    
    /** Converts an integer to a hex value.
        
        If the integer value is negative, then the hex value is padded with up to 7 F's, for a
        length of 8 characters. Positive integer values are returned wihtout any padding. Zero is '0'.
        The unknown value returns an empty string.
        
        @param integer An integer value.
        @return character A hex value.  */
    method static public character IntToHex(input pValue as integer):
        return IntToHex(pValue, DataTypeEnum:Integer).
    end method.
    
    /** Converts an integer to a hex value.
        
        If the integer value is negative, then the hex value is padded with up to 7 F's, for a
        length of 8 characters. Positive integer values are returned wihtout any padding. Zero is '0'.
        The unknown value returns an empty string.
        
        @param integer An integer value.
        @return character A hex value.  */
    method static public character IntToHex(input pValue as int64):
        return IntToHex(pValue, DataTypeEnum:Int64).
    end method.
    
    /* Converts an integer value to a hex value
       
       @param int64 The integet value. Can hold an INTEGER or INT64 value.
       @param DataTypeEnum The type of integer (integer or int64).
       @return character The hex-encoded value */
    method static private character IntToHex(input pValue as int64,
                                             input pType as DataTypeEnum):
        var raw rawInt.
        var character hexVal.
        var memptr mInt.
        var integer numBytes.
        
        // default is INT64 value
        if not valid-object(pType)
        or not pType eq DataTypeEnum:Integer
        then
            assign pType = DataTypeEnum:Int64.
        
        if pType eq DataTypeEnum:Integer then
            assign numBytes = 4.
        else
            assign numBytes = 8.
        
        if pValue eq 0 then
            return '0':u.
        
        if pValue eq ? then
            return '':u.
        
        set-size(mInt) = numBytes.
        set-byte-order(mInt) = big-endian.
        
        case pType:
            when DataTypeEnum:Int64   then
                put-int64(mInt, 1) = pValue.
            when DataTypeEnum:Integer then
                // we've been assured that this is an integer ...
                {&_proparse_ prolint-nowarn(overflow)}
                put-long(mInt, 1) = integer(pValue).
        end case.
        
        length(rawInt) = numBytes.
        rawInt = mInt.
        
        assign hexVal = caps(left-trim(hex-encode(rawInt), '0':u)).
        // Pad with F's
        if pValue lt 0 then
            return fill('F':u, (numBytes * 2) - length(hexVal)) + hexVal.
        else
            return hexVal.
        
        finally:
            set-size(mInt) = 0.
        end finally.
    end method.
    
end class.