/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
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

class OpenEdge.Core.Util.MathUtil:
     
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
        @return integer The integer representation of that hex value.   */
    method public static integer HexToInt(input pcHex as character):
        define variable iResult as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cHex as character no-undo.
        define variable rHex as raw no-undo.    
       
        assign cHex = trim(pcHex).
        
        if length( cHex ) modulo 2 eq 1 then
            assign cHex = "0":u + cHex.
        
        assign rHex = hex-decode( cHex )
               iMax = length( rHex ).
     
        do iLoop = 1 to iMax.
          assign iResult = iResult * 256
                 iResult = iResult + get-byte(rHex, iLoop)
                 .
       end.
     
        return iResult.  
    end method.
    
end class.