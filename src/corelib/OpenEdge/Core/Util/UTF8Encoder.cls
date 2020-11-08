/************************************************
Copyright (c) 2020 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : UTF8Encoder
    Purpose     : Encodes UTF-8 strings, characters and values to and from Unicode codepoints
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2020-03-02
    Notes       : * Ranges and algorithms taken from https://en.wikipedia.org/wiki/UTF-8#Description and
                    https://www.cl.cam.ac.uk/~mgk25/unicode.html#utf-8  
                    
                  * Escape sequences default to U+ if none are specified
                  * Escape sequences may contain a single substitution parameter, "&1", which
                    allows for more complex sequences (like Swift's "\u{&1}" )
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Util.MathUtil.

class OpenEdge.Core.Util.UTF8Encoder:
    
    /* Encodes non-ASCII (a UTF8 value of 32 < utf8 < 128) characters into Unicode-codepoints, using
       the escape sequence/mask given.
       
       @param  longchar  The string to encode.
       @param  character The escape sequence, by default U+ but for JSON may need to be \u . 
                         May include &1 for more complex sequences (like Swift's \u{&1} )  
       @return longchar The encoded string */
    method static public longchar Encode(input pString as longchar,
                                         input pEscapeSeq as character):
        define variable chrVal as character no-undo.
        define variable chrLoop as integer no-undo.
        define variable chrCnt as integer no-undo.
        define variable memData as memptr no-undo.
        define variable utf8Codepoint as integer no-undo.
        define variable unicodeCodePt as integer no-undo.
        define variable numBytes as integer no-undo.
        define variable rawCodepoint as raw no-undo.
        define variable byte as integer no-undo.
        define variable encString as longchar no-undo.
        
        if    length(pString) eq 0
           or pString eq ?
        then
            return pString.
        
        if    pEscapeSeq eq ? 
           or pEscapeSeq eq '':u 
        then
            assign pEscapeSeq = 'U+':u. 
        
        if index(pEscapeSeq, '&1':u) eq 0 then
            assign pEscapeSeq = pEscapeSeq + '&1':u.
        
        // UTF-8 is defined as big endian
        set-byte-order(memData) = big-endian.
        // we'll be putting INTEGER values in here
        set-size(memData) = 4.
        
        // loop through the string, character by character, and
        // encode all of the non-ASCII characters
        assign chrCnt = length(pString, 'character':u).
        do chrLoop = 1 to chrCnt:
            assign chrVal        = substring(pString, chrLoop, 1)
                   utf8Codepoint = asc(chrVal, 'utf-8':u)
                   .
            // characters outside of US-ASCII range are encoded
            if     utf8Codepoint ge 127
                or utf8Codepoint le 31
            then
            do:
                assign unicodeCodePt = Utf8ToUnicode(utf8Codepoint).
                put-long(memData, 1) = unicodeCodePt.
                assign rawCodepoint = memData.
                
                // 1048576  -> 4 bytes -> U+100000
                if unicodeCodePt ge 0x100000 then    //1,048,576
                    assign chrVal = caps(substring(hex-encode(rawCodepoint), 3)).
                else
                // 65536 ->  4 bytes  -> U+10000
                if unicodeCodePt ge 0x10000 then     //65,536
                    assign chrVal = caps(substring(hex-encode(rawCodepoint), 4)).
                else
                    // there will be at least 4 leading 0's
                    assign chrVal = caps(substring(hex-encode(rawCodepoint), 5)).
                
                assign length(rawCodepoint) = 0
                       chrVal               = substitute(pEscapeSeq, chrVal)
                       .
            end.
            
            assign encString = encString + chrVal.
        end.
        
        return encString.
        finally:
            set-size(memData) = 0.
        end finally.
    end method.
    
    /** Attempts to decode a previously-encoded string. By default 4-character hex values are
        used, for escape sequences like U+ or \u . If the escape sequence has a terminator - like \U{&1}
        - then the length of the hex value is determined using the mask.
        
        @param longchar The encoded string
        @param character The escape sequence, by default U+ but for JSON may need to be \u . 
                         May include &1 for more complex sequences (like Swift's \u{&1} )  
        @return longchar A decoded UTF-8 string  */
    method static public longchar Decode(input pString as longchar,
                                         input pEscapeSeq as character):
        define variable pos as integer no-undo.
        define variable startAt as integer no-undo.
        define variable hexLen as integer no-undo.
        define variable hexChar as character no-undo.
        define variable decodedString as longchar no-undo.
        define variable utf8 as int64 no-undo.
        define variable escLen as integer no-undo.
        define variable escCloseLen as integer no-undo.
        define variable escCloseChr as character no-undo.
        
        fix-codepage(decodedString) = 'utf-8':u.
        
        assign pos = index(pEscapeSeq, '&1':u).
        if pos eq 0 then
            assign escCloseLen  = 0
                   escCloseChr  = '':u
                   .
        else
            assign escCloseChr = substring(pEscapeSeq, pos + 2)
                   escCloseLen = length(escCloseChr)
                   pEscapeSeq  = substring(pEscapeSeq, 1, pos - 1) 
                   .
        
        assign startAt = 1
               // we default to 4 character hex values
               hexLen  = 4
               escLen  = length(pEscapeSeq, 'character':u)
               pos     = index(pString, pEscapeSeq, startAt)
               .
        do while pos gt 0:
            if not escCloseLen eq 0 then
                assign hexLen  = index(pString, escCloseChr, pos + escLen)
                               - (pos + escLen).
            
            assign hexChar       = substring(pString, pos + escLen, hexLen)
                   utf8          = UnicodeToUtf8(hexChar)
                   decodedString = decodedString 
                                 + substring(pString, startAt, (pos - startAt))
                                 + chr(utf8, 'utf-8':u, 'utf-8':u)
                   startAt       = pos + escLen + hexLen + escCloseLen
                   pos           = index(pString, pEscapeSeq, startAt)
                   .
        end.
        
        /* add anycharacters that appear after the last U+ */
        return decodedString + substring(pString, startAt).
    end method.
    
    /* Converts a Unicode codepoint into a UTF8 value.
       
       For example U+20AC is decided as decimal 8364, which is used as an input
       for the UnicodeToUtf8(int64) method.
       
       @param character The Unicode codepoint as a HEX value
       @return int64 The UTF-8 value. Will be ZERO/0 if the codepoint is unknown or negative. */ 
    method static public int64 UnicodeToUtf8(input pHexValue as character):
        define variable unicode as int64 no-undo.
        
        // use a distinct DO block so that we only treat bad values as 0 
        do on error undo, throw:
            assign unicode = MathUtil:HexToInt(pHexValue).
            catch e as Progress.Lang.Error :
                return 0.
            end catch.
        end.
        
        return UnicodeToUtf8(unicode).
    end method.
    
    /* Converts a Unicode codepoint into a UTF8 value
       
       For example the unicode codepoint 8364 (which is U+20AC) is returned as 
       decimal 14844588 which can then be turned into a character with 
       CHR(<val>, 'utf-8':u, 'utf-8':u)
       
       @param int64 The Unicode codepoint 
       @return int64 The UTF-8 value. Will be ZERO/0 if the codepoint is unknown or negative. */ 
    method static public int64 UnicodeToUtf8(input pUnicode as int64):
        define variable loop as integer no-undo.
        define variable numBytes as integer no-undo.
        define variable utf8 as int64 no-undo.
        
        if pUnicode lt 0 then
            return utf8.
        else
        if pUnicode le 0x007f then
        do:
            // #bitswritten = 7
            put-bits(utf8, 1, 7) = get-bits(pUnicode, 1, 7).
            put-bits(utf8, 8, 1) = 0.
        end.
        else
        if pUnicode le 0x07ff then
        do:
            // #bitswritten = 11
            // first 6 bits in 1-6
            put-bits(utf8, 1, 6) = get-bits(pUnicode, 1, 6).
            put-bits(utf8, 7, 1) = 0.
            put-bits(utf8, 8, 1) = 1.
            
            //last bits in 9-13
            put-bits(utf8, 9, 5) = get-bits(pUnicode, 7, 5).
            put-bits(utf8, 14, 1) = 0.
            put-bits(utf8, 15, 1) = 1.
            put-bits(utf8, 16, 1) = 1.
        end.
        else
        if pUnicode le 0xffff then
        do: 
            // #bitswritten = 16
            // first 6 bits in 1-6
            put-bits(utf8, 1, 6) = get-bits(pUnicode, 1, 6).
            put-bits(utf8, 7, 1) = 0.
            put-bits(utf8, 8, 1) = 1.
            
            // second 6 bits in 9-14
            put-bits(utf8, 9, 6)  = get-bits(pUnicode, 7, 6).
            put-bits(utf8, 15, 1) = 0.
            put-bits(utf8, 16, 1) = 1.
            
            //last bits in 17-19
            put-bits(utf8, 17, 4) = get-bits(pUnicode, 13, 4).
            put-bits(utf8, 21, 1) = 0.
            put-bits(utf8, 22, 1) = 1.
            put-bits(utf8, 23, 1) = 1.
            put-bits(utf8, 24, 1) = 1.
        end.
        else
        if pUnicode le 0x10ffff then
        do: 
            // #bitswritten = 21
            // first 6 bits in 1-6
            put-bits(utf8, 1, 6) = get-bits(pUnicode, 1, 6).
            put-bits(utf8, 7, 1) = 0.
            put-bits(utf8, 8, 1) = 1.
            
            // second 6 bits in 9-14
            put-bits(utf8, 9, 6) = get-bits(pUnicode, 7, 6).
            put-bits(utf8, 15, 1) = 0.
            put-bits(utf8, 16, 1) = 1.
            
            // third 6 bits in 17-22
            put-bits(utf8, 17, 6) = get-bits(pUnicode, 13, 6).
            put-bits(utf8, 23, 1) = 0.
            put-bits(utf8, 24, 1) = 1.
            
            //last bits in 17-19
            put-bits(utf8, 25, 3) = get-bits(pUnicode, 19, 3).
            put-bits(utf8, 28, 1) = 0.
            put-bits(utf8, 29, 1) = 1.
            put-bits(utf8, 30, 1) = 1.
            put-bits(utf8, 31, 1) = 1.
            put-bits(utf8, 32, 1) = 1.
        end.
        
        return utf8.
    end method.
    
    /* Converts a UTF8 character into a unicode codepoint.  
       
       @param  character The UTF-8 character string. Only the first character of the input value is used. 
       @return integer The Unicode codepoint. Will be ZERO/0 if the codepoint is null. */
    method static public integer Utf8ToUnicode(input pUtf8 as character):
        define variable utf8 as int64 no-undo.
        
        // use a distinct DO block so that we can treat bad values as 0
        do on error undo, throw:
            assign utf8 = asc(substring(pUtf8, 1, 1), 'utf-8':u).
            catch e as Progress.Lang.Error:
                return 0.
            end catch.
        end.
        
        return Utf8ToUnicode(utf8).
    end method.
    
    /* Converts a UTF8 values into a unicode codepoint 
       
       @param  int64   The UTF-8 value (from the ASC() function or elsewhere)
       @return integer The Unicode codepoint. Will be ZERO/0 if the codepoint is null. */
    method static public integer Utf8ToUnicode(input pUtf8 as int64):
        define variable unicode as integer no-undo.
        define variable memData as memptr no-undo.
        define variable idx as integer no-undo.
        define variable loop as integer no-undo.
        define variable byte as integer no-undo.
        define variable numBits as integer no-undo.
        
        if pUtf8 eq ?
        or pUtf8 eq 0
        then
            return 0.
        
        // UTF-8 is defined as big-endian
        set-byte-order(memData) = big-endian.
        set-size(memData) = 8.
        put-int64(memData, 1) = pUtf8.
        
        assign idx = 1.
        // only loop through the last 4 bytes; the first 4 others may be 0 or 255 (depending on whether the
        // utf8 value is negative or not).
        do loop = 8 to 5 by -1:
            assign byte = get-byte(memData, loop).
            if byte eq 0
            // From https://en.wikipedia.org/wiki/UTF-8, "FE and FF were never defined for any purpose in UTF-8". 
            or byte eq 0xFE
            or byte eq 0xFF
            then
                leave.
            
            // These bit masks can be seen in UnicodeToUtf8(int64)
            // 1 byte
            if get-bits(byte, 8, 1) eq 0 then
                assign numBits = 7
                       .
            else
            // 2 bytes
            if get-bits(byte, 6, 3) eq 6 then
                assign numBits = 5
                       .
            else
            // 3 bytes
            if get-bits(byte, 5, 4) eq 14 then
                assign numBits = 4
                       .
            else
            // 4 bytes
            if get-bits(byte, 4, 5) eq 30 then
                assign numBits = 3
                       .
            else
            // non-significant
            if get-bits(byte, 7, 2) eq 2 then
                assign numBits = 6.
            
            put-bits(unicode, idx, numbits) = get-bits(byte, 1, numBits).
            assign idx = idx + numBits.
        end.
        
        return unicode.
        finally:
            set-size(memData) = 0.
        end finally.
    end method.
    
end class.