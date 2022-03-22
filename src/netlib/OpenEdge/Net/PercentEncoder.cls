/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : PercentEncoder
    Purpose     : Percent-encodes and -decodes character data
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2022-01-10
    Notes       : * Values outside of the ASCII range are always encoded
                  * If no flags are provided, all of the ASCII characters are encoded
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Progress.Lang.AppError.

@since(rel='12.5.0').
class OpenEdge.Net.PercentEncoder:
    /* An array of flags indicating which ASCII chars to encode or not. Characters to encode must have a value of TRUE */
    define public property EncodingFlags as logical extent 128 no-undo
        get.
        private set.
    
    /* Constructor.
       
       @param logical[128] An array of flags corresponding to the ASCII character set */
    constructor public PercentEncoder(input pFlags as logical extent 128):
        assign this-object:EncodingFlags = pFlags.
    end constructor.
    
    /* Encodes a string per the input flags. Characters in the ASCII range (0-127) are
       encoded per the flags passed in; all other characters are always %-encoded.
       
       @param  longchar    The string to encode. This is longchar since it can handle unicode data even when the session can't.
                           We do not expect this to contain GB's of data.
       @param logical[128] An array of flags indicating which ASCII chars to encode or not. Characters to encode must have
                           a value of TRUE
       @return character   The encoded string. Return value is character since the "bad" characters have been encoded. */
    method public character Encode(input pString as longchar):
        return this-object:Encode(pString, false).
    end method.
    
    /* Encodes a string per the input flags. Characters in the ASCII range (0-127) are
       encoded per the flags passed in; all other characters are always %-encoded.
       
       @param  longchar    The string to encode. This is longchar since it can handle unicode data even when the session can't.
                           We do not expect this to contain GB's of data.
       @param  logical     TRUE if existing % values must be reencoded as %25
       @return character   The encoded string. Return value is character since the "bad" characters have been encoded. */
    method public character Encode(input pString as longchar,
                                   input pReencode as logical):
        define variable chrLoop       as integer   no-undo.
        define variable chrCnt        as integer   no-undo.
        define variable rawChar       as raw       no-undo.
        define variable codepoint     as integer   no-undo.
        define variable chrVal        as character no-undo.
        define variable encodedString as character no-undo.
        define variable byteLoop      as integer   no-undo.
        define variable byteCnt       as integer   no-undo.
        define variable rawByte       as raw       no-undo.
        define variable nextCodepoint as integer extent 2 no-undo.
        define variable encodeChr as logical no-undo.
        var character sourceCodepage = get-codepage(pString).
        var character[2] cpChr.
        
        /* Don't bother with blank or unknown. Keep spaces though, so check for length instead of = "".
           Unknown has no meaning outside of ABL so just no-op it  */
        assign chrCnt = length(pString).
        if chrCnt eq 0
        or pString eq ?
        then
            return '':u.
        
        /* Loop through entire input string */
        do chrLoop = 1 to chrCnt:
            assign chrVal    = substring(pString, chrLoop, 1)
                   // ASCII value of character using single byte codepage
                   codepoint = asc(chrVal)
                   .
            // Does this character need encoding?
            // percent-encoded (dec: 37)
            if codepoint eq 0x25 then
            do:
                // if we've been told to re-encode, then re-encode
                if pReencode then
                    assign encodeChr = yes.
                else
                // Is this a 'loose' % or a %-encoded value?
                if (chrLoop + 2) le chrCnt then
                do:
                    assign cpChr[1]         = substring(pString, chrLoop + 1, 1)
                           nextCodepoint[1] = asc(cpChr[1])
                           cpChr[2]         = substring(pString, chrLoop + 2, 1)
                           nextCodepoint[2] = asc(cpChr[2])
                           .
                    // if the 2 chars following the % character are either 0-9, A-F or a-f then
                    // we assume that there's an already encoded value, and do not encode the %
                    if (
                           (48 le nextCodepoint[1] and nextCodepoint[1] le 57)   // 0 - 9
                        or (65 le nextCodepoint[1] and nextCodepoint[1] le 70)   // A - F
                        or (97 le nextCodepoint[1] and nextCodepoint[1] le 102)  // a - f
                    )
                    and (
                           (48 le nextCodepoint[2] and nextCodepoint[2] le 57)   // 0 - 9
                        or (65 le nextCodepoint[2] and nextCodepoint[2] le 70)   // A - F
                        or (97 le nextCodepoint[2] and nextCodepoint[2] le 102)  // a - f
                    )
                    then
                        assign encodeChr = no
                               chrVal    = substring(pString, chrLoop, 3)
                               chrLoop   = chrLoop + 2
                               .
                    else
                        assign encodeChr = yes.
                end.
                // not enough characters be a %-encoded value
                else
                    assign encodeChr = yes.
            end.    // %
            else
            // outside of US-ASCII range gets pct-encoded
            if codepoint ge 127
            or codepoint le 31
            // or marked as must-encode: this <> FALSE means that TRUE and UNKNOWN results in encoding
            or not this-object:EncodingFlags[codepoint + 1] eq false
            then
                assign encodeChr = yes.
            else
                assign encodeChr = no.
            
            if encodeChr then
            do:
                // Section 2.4 https://tools.ietf.org/html/rfc3986#section-2.4 describes how
                // to deal with unicode
                put-string(rawChar, 1) = codepage-convert(chrVal, 'utf-8':u, sourceCodepage).
                // PUT-STRING() adds a NULL\0x00 byte at the end; we don't want that in our pretty encoding
                assign byteCnt = length(rawChar, 'raw':u) - 1
                       chrVal  = '':u
                       .
                do byteLoop = 1 to byteCnt:
                    put-byte(rawByte, 1) = get-byte(rawChar, byteLoop).
                    /* Replace character with %hh hexidecimal triplet */
                    assign chrVal = chrVal + caps(substitute('%&1':u, hex-encode(rawByte))).
                end.
                // empty/reset this raw, otherwise if we have a unicode character followed by an ASCII,
                // it will have a length of 2 bytes, which will add an unnecessary null (%00) to the
                // encoded string
                assign length(rawChar) = 0.
            end.
            /* add/create a new string because replacing 1 character with 2 messes up our math */
            assign encodedString = encodedString + chrVal.
        end.
        
        return encodedString.
    end method.
    
    /** Attempts to decode a previously percent-encoded string.
        
        @param  longchar The string to decode
        @return longchar A decoded URL
        @throws AppError If the encoding is malformed */
    method public longchar Decode(input pEncodedString as character):
        return this-object:Decode(pEncodedString, ?).
    end method.
    
    /** Attempts to decode a previously percent-encoded string.
        
        @param  longchar The string to decode
        @param  character The target codepage to encode into. Defaults to UTF-8
        @return longchar A decoded string. This is longchar since it may contain non-ASCII or Unicode characters.
        @throws AppError If the encoding is malformed */
    method public longchar Decode(input pEncodedString as character,
                                  input pTargetCodepage as character):
        define variable decodedString as longchar no-undo.
        define variable loop          as integer   no-undo.
        define variable pctPos        as integer   no-undo.
        define variable hexChar       as character no-undo.
        define variable numBytes      as integer   no-undo.
        define variable startAt       as integer   no-undo.
        define variable rawChar       as raw       no-undo.
        define variable decodedChar   as character no-undo.
        define variable codepoint     as integer   no-undo.
        define variable strLen        as integer no-undo.
        
        if pEncodedString eq ?
        or pEncodedString eq '':u
        then
            return pEncodedString.
        
        if pTargetCodepage eq ?
        or pTargetCodepage eq '':u
        then
            assign pTargetCodepage = 'utf-8':u.
        
        fix-codepage(decodedString) = pTargetCodepage.
        
        assign startAt = 1
               pctPos  = index(pEncodedString, '%':u, startAt)
               strLen  = length(pEncodedString)
               .
        STRING-LOOP:
        do while pctPos gt 0:
            assign hexChar = substring(pEncodedString, pctPos + 1, 2)
                   rawChar = hex-decode(hexChar)
                   no-error.
            // If there's a % character that is somehow not a hex-encoded value, then just treat it as a string and try again
            if error-status:error
            // if the % is the last character then of course it can't be encoded
            or pctPos eq strLen
            then
            do:
                assign decodedString = decodedString + substring(pEncodedString, startAt, (pctPos - startAt + 1))
                       startAt       = pctPos + 1
                       pctPos        = index(pEncodedString, '%':u, startAt)
                       // reset the flag
                       error-status:error = false
                       .
                next STRING-LOOP.
            end.
            
            // chop off stuff before the %
            assign decodedString = decodedString + substring(pEncodedString, startAt, (pctPos - startAt))
                   codepoint     = get-byte(rawChar, 1)
                   .
            // US-ASCII, excluding NULL
            // 0 < codepoint < 128
            if (0 lt codepoint and codepoint le 128) then
                assign numBytes    = 1
                       decodedChar = chr(codepoint)
                       startAt     = pctPos + 3
                       .
            else
            // UTF-8 (two byte)
            // 192 <= codepoint < 224
            if (192 le codepoint and codepoint lt 224) then
                assign numBytes = 2.
            else
            // UTF-8 (three byte)
            // 24 <= codepoint < 240
            if (224 le codepoint and codepoint lt 240) then
                assign numBytes = 3.
            else
            // UTF-8 (three byte)
            // 240 <= codepoint < 248
            if (240 le codepoint and codepoint lt 248) then
                assign numBytes = 4.
            else
            // MALFORMED
                assign numBytes = -1.
            
            if numBytes gt 1 then
            do:
                assign length(rawChar) = numBytes
                       // we've got the first byte in codepoint already
                       pctPos          = pctPos + 3
                       .
                put-byte(rawChar, 1) = codepoint.
                do loop = 2 to numBytes:
                    assign hexChar   = substring(pEncodedString, pctPos + 1, 2)
                           codepoint = get-byte(hex-decode(hexChar), 1)
                           pctPos    = pctPos + 3
                           .
                    // 128 <= codepoint < 192
                    if 128 le codepoint and codepoint lt 192 then
                        put-byte(rawChar, loop) = codepoint.
                    else
                        assign numBytes = -1.
                end.
                
                if numBytes gt 0 then
                    assign decodedChar = codepage-convert(get-string(rawChar, 1, numBytes),
                                                          pTargetCodepage,
                                                          'utf-8':u)
                           startAt     = pctPos.
            end.    //UTF-8
            
            // Malformed data
            if numBytes eq -1 then
                return error new AppError(substitute('Cannot decode malformed string &1', pEncodedString), 0).
            else
                assign decodedString = decodedString + decodedChar
                       pctPos        = index(pEncodedString, '%':u, startAt)
                       .
        end.
        
        /* add any characters that appear after the last % */
        return decodedString + substring(pEncodedString, startAt).
    end method.
    
end class.