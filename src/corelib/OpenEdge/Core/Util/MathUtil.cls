/************************************************
Copyright (c) 2014, 2017, 2020 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : MathUtil
    Purpose     : General-purpose math functionality.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu May 15 14:44:19 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.String.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Util.MathUtil.

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
        if truncate(pdVal,0) eq pdVal then
            return integer(pdVal).
        else
            return integer(truncate(pdVal, 0) + 1).
    end method.

    /** Converts hex to integer values 
        
        @param character A hex value
        @return int64 The integer representation of that hex value.   */
    method public static int64 HexToInt(input pcHex as character):
        define variable iResult as int64 no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cHex as character no-undo.
        define variable rHex as raw no-undo.
        
        if pcHex eq ? then
            return 0.
        
        assign cHex = trim(pcHex).
        
        if length( cHex ) modulo 2 eq 1 then
            assign cHex = "0":u + cHex.
        
        assign rHex = hex-decode( cHex )
               iMax = length( rHex, 'raw')
               .
        do iLoop = 1 to iMax.
          assign iResult = iResult * 256
                 iResult = iResult + get-byte(rHex, iLoop)
                 .
       end.
       
       return iResult.
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
    
    /** Converts an integer to a padded hax values 
        
        @param integer An integer value
        @param integer The total length of the hex value. If the integer hex value is larger than this, 
                       use the larger and padd with leading zeros 
        @return character A hex value */
    method static public character IntToHex(input pValue as integer,
                                            input pPadding as integer):
        define variable hexVal as character no-undo.
        define variable rawInt as raw no-undo.
        define variable rawHex as character no-undo.
        define variable strLen as integer no-undo.
        
        if pValue eq 0 then
            return fill('0':u, pPadding).
        
        put-long(rawInt, 1) = pValue.
        
        assign rawHex = right-trim(hex-encode(rawInt), '0':u)
               strLen = max(pPadding, length(rawHex))
               hexVal = fill('0':u, strLen)
               .
        overlay(hexVal, strLen - length(rawHex) + 1) = rawHex.
        
        return hexVal.
    end method.
    
end class.