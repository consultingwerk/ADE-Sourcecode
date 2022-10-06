/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : FormEncoder
    Purpose     : Provides encoding and decoding for application/x-www-form-urlencoded content
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2022-01-07
   no tes       : * Encoding taken from RFC1278 section 2.2
                  * Control names and values are escaped. Space characters are replaced by `+', and then reserved characters are escaped as described in [RFC1738],
                    section 2.2:no n-alphanumeric characters are replaced by `%HH', a percent sign and two hexadecimal digits representing the ASCII code of the
                    character. Line breaks are represented as "CR LF" pairs (i.e., `%0D%0A').
                  * The control names/values are listed in the order they appear in the document. The name is separated from the value by `=' and name/value
                    pairs are separated from each other by `&'.
                    
                    
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.StringConstant.
using OpenEdge.Net.PercentEncoder.

@since(rel='12.5.0').
class OpenEdge.Net.FormEncoder
final:
    // The flags in the array indicate which ASCII chars to encode: a value of TRUE means the character is encoded
    // Because ABL arrays are 1-based, the first item is asc=0 (ie null). "A" is item 66 (65+1)
    // use logical[128] variables with initial values, because these values are in rcode, and don't need to
    // be calculated even once per session.
    
    // ALPHA + DIGIT + ! $ ' ( ) * + , ; - . _ ~
    var private logical[128] mEncodingFlags = [ // NUL SOH STX ETX EOT ENQ ACK BEL
                                                   yes,yes,yes,yes,yes,yes,yes,yes,
                                                // BS  HT  LF  VT  FF  CR  SO  SI
                                                   yes,yes,yes,yes,yes,yes,yes,yes,
                                                // DLE DC1 DC2 DC3 DC4 NAK SYN ETB
                                                   yes,yes,yes,yes,yes,yes,yes,yes,
                                                // CAN EM  SUB ESC FS  GS  RS  US
                                                   yes,yes,yes,yes,yes,yes,yes,yes,
                                                //     !   "   #   $   %   &   '
                                                   yes,no ,yes,yes,no ,yes,yes,no ,
                                                // (   )   *   +   ,   -   .   /
                                                   no ,no ,no ,no ,no ,no ,no ,yes,
                                                // 0   1   2   3   4   5   6   7
                                                   no ,no ,no ,no ,no ,no ,no ,no ,
                                                // 8   9   :   ;   <   =   >   ?
                                                   no ,no ,yes,no ,yes,yes,yes,yes,
                                                // @   A   B   C   D   E   F   G
                                                   yes,no ,no ,no ,no ,no ,no ,no ,
                                                // H   I   J   K   L   M   N   O
                                                   no ,no ,no ,no ,no ,no ,no ,no ,
                                                // P   Q   R   S   T   U   V   W
                                                   no ,no ,no ,no ,no ,no ,no ,no ,
                                                // X   Y   Z   [   \   ]   ^   _
                                                   no ,no ,no ,yes,yes,yes,yes,no ,
                                                //  `  a   b   c   d   e   f   g
                                                   yes,no ,no ,no ,no ,no ,no ,no ,
                                                // h   i   j   k   l   m   n   o
                                                   no ,no ,no ,no ,no ,no ,no ,no ,
                                                // p   q   r   s   t   u   v   w
                                                   no ,no ,no ,no ,no ,no ,no ,no ,
                                                // x   y   z   {   |   }   ~   DEL
                                                   no ,no ,no ,yes,yes,yes,no ,yes   ].
    
    /* The encoder 'engine' used to form-encode data */
    var private PercentEncoder encoder.
    
    /* Default constructor. */
    constructor public FormEncoder():
        assign encoder = new PercentEncoder(mEncodingFlags).
    end constructor.
    
    /* Encodes a string using form encoding.
       
       Uses OpenEdge.Net.HTTP.PercentEncoder:Encode() to perform the encoding
       
       @param  longchar    The string to encode. This is longchar since it can handle unicode data even when the session can't.
                           We dono t expect this to contain GB's of data.
       @return character A percent-encoded string */
    method public character Encode(input pData as longchar):
        var integer pos, codePoint.
        var character cpChr.
        
        // Form encoded values use + characters for spaces
        assign pData = replace(pData, StringConstant:SPACE, '+':u)
               pos   = index(pData, StringConstant:CR)
               .
        // All lonesone CRs need a LF suffix
        do while pos gt 0:
            assign cpChr     = substring(pData, pos + 1, 1)
                   codePoint = asc(cpChr)
                   .
            if not codePoint eq 0x0A then
                // needs the 0 to shift-right, otherwise it *overwrites*
                substring(pData, pos + 1, 0) = StringConstant:LF.
            
            assign pos = index(pData, StringConstant:CR, pos + 1).
        end.
        
        // All lonesone LFs need a CR prefix
        assign pos = index(pData, StringConstant:LF).
        if pos eq 1 then
            assign pData = StringConstant:CR + pData
                   pos   = index(pData, StringConstant:LF, 2)
                   .
        do while pos gt 0:
            assign cpChr     = substring(pData, pos - 1, 1)
                   codePoint = asc(cpChr)
                   .
            if not codePoint eq 0x0D then
                // needs the 0 to shift-right, otherwise it *overwrites*
                substring(pData, pos, 0) = StringConstant:CR.
            assign pos = index(pData, StringConstant:LF, pos + 1).
        end.
        
        return encoder:Encode(pData).
    end method.
    
    /* Decodes an encoded string
        
       Uses OpenEdge.Net.HTTP.PercentEncoder:Decode() to perform the decoding
       
       @param character An encoded string
       @return longchar A decoded string    */
    method public longchar Decode(input pData as character):
        return Decode(pData, ?).
    end method.
        
    /** Attempts to decode a previously-encoded string.
        
        Uses OpenEdge.Net.HTTP.PercentEncoder:Decode() to perform the decoding
        
        @param  character The string to decode
        @param  character The target codepage to encode into.
        @return character A decoded URL
        @throws AppError If the encoding is malformed */
    method public longchar Decode(input pData as character,
                                  input pTargetCodepage as character):
        // Form encoded values use + characters for spaces
        assign pData = replace(pData, '+':u, StringConstant:SPACE)
               {&_proparse_ prolint-nowarn(overflow)}
               pData = encoder:Decode(pData, pTargetCodepage)
               // deal with %2B-encodings
               pData = replace(pData, '+':u, StringConstant:SPACE)
               .
        return pData.
    end method.
    
end class.