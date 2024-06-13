/************************************************
Copyright (c) 2022,2024 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : UriEncoder
    Purpose     : Performs percent-encoding for a URI, in whole or in part
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2022-01-10
    Notes       : * the grammer for determining valid, non-encoded values is
                    reserved    = gen-delims / sub-delims
                    gen-delims  = ":" / "/" / "?" / "#" / "[" / "]" / "@"
                    sub-delims  = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
                    pchar       = unreserved / pct-encoded / sub-delims / ":" / "@"
                                  ALPHA / DIGIT / "-" / "." / "_" / "~" /
                                    "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "=" /
                                    ":" / "@"
                    unreserved  = ALPHA / DIGIT / "-" / "." / "_" / "~"

                    Default  : unreserved

                    Query    : query         = *( pchar / "/" / "?" )
                                  ALPHA / DIGIT / "-" / "." / "_" / "~" /
                                    "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "=" /
                                    ":" / "@" /
                                    "/" / "?"

                    Scheme   : scheme        = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )

                    Fragment : fragment      = *( pchar / "/" / "?" )

                    Path     : path-abempty  = *( "/" segment )
                               segment       = *pchar

                    UserInfo : userinfo    = *( unreserved / pct-encoded / sub-delims / ":" )

                    Host     : host          = IP-literal / IPv4address / reg-name
                               reg-name      = *( unreserved / pct-encoded / sub-delims )
                               IP-literal    = "[" ( IPv6address / IPvFuture  ) "]"
                               IPv6address   =                                 6( h16 ":" ) ls32
                                                  /                       "::" 5( h16 ":" ) ls32
                                                  / [               h16 ] "::" 4( h16 ":" ) ls32
                                                  / [ *1( h16 ":" ) h16 ] "::" 3( h16 ":" ) ls32
                                                  / [ *2( h16 ":" ) h16 ] "::" 2( h16 ":" ) ls32
                                                  / [ *3( h16 ":" ) h16 ] "::"    h16 ":"   ls32
                                                  / [ *4( h16 ":" ) h16 ] "::"              ls32
                                                  / [ *5( h16 ":" ) h16 ] "::"              h16
                                                  / [ *6( h16 ":" ) h16 ] "::"
                               ls32          = ( h16 ":" h16 ) / IPv4address
                                               ; least-significant 32 bits of address
                               h16           = 1*4HEXDIG
                                               ; 16 bits of address represented in hexadecimal
                               IPv4address   = dec-octet "." dec-octet "." dec-octet "." dec-octet
                               dec-octet     = DIGIT                 ; 0-9
                                             / %x31-39 DIGIT         ; 10-99
                                             / "1" 2DIGIT            ; 100-199
                                             / "2" %x30-34 DIGIT     ; 200-249
                                             / "25" %x30-35          ; 250-255
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.MapEntry.
using OpenEdge.Core.Session.
using OpenEdge.Core.String.
using OpenEdge.Net.PercentEncoder.
using OpenEdge.Net.URI.
using OpenEdge.Net.UriEncodingTypeEnum.
using Progress.Collections.List.

@since(rel='12.5.0').
class OpenEdge.Net.UriEncoder:
    // The flags in the array indicate which ASCII chars to encode: a value of TRUE means the character is encoded
    // Because ABL arrays are 1-based, the first item is asc=0 (ie null). "A" is item 66 (65+1)
    // use logical[128] variables with initial values, because these values are in rcode, and don't need to
    // be calculated even once per session.

    // Default = unreserved    = ALPHA / DIGIT / "-" / "." / "_" / "~"
    var private logical[128] mFlags_Default = [ // NUL SOH STX ETX EOT ENQ ACK BEL
                                                   yes,yes,yes,yes,yes,yes,yes,yes,
                                               // BS  HT  LF  VT  FF  CR  SO  SI
                                                  yes,yes,yes,yes,yes,yes,yes,yes,
                                               // DLE DC1 DC2 DC3 DC4 NAK SYN ETB
                                                  yes,yes,yes,yes,yes,yes,yes,yes,
                                               // CAN EM  SUB ESC FS  GS  RS  US
                                                  yes,yes,yes,yes,yes,yes,yes,yes,
                                               //     !   "   #   $   %   &   '
                                                  yes,yes,yes,yes,yes,yes,yes,yes,
                                               // (   )   *   +   ,   -   .   /
                                                  yes,yes,yes,yes,yes,no ,no ,yes,
                                               // 0   1   2   3   4   5   6   7
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               // 8   9   :   ;   <   =   >   ?
                                                  no ,no ,yes,yes,yes,yes,yes,yes,
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
                                                  no ,no ,no ,yes,yes,yes,no ,yes ].
    // Scheme = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
    var private logical[128] mFlags_Scheme = [ // NUL SOH STX ETX EOT ENQ ACK BEL
                                                  yes,yes,yes,yes,yes,yes,yes,yes,
                                               // BS  HT  LF  VT  FF  CR  SO  SI
                                                  yes,yes,yes,yes,yes,yes,yes,yes,
                                               // DLE DC1 DC2 DC3 DC4 NAK SYN ETB
                                                  yes,yes,yes,yes,yes,yes,yes,yes,
                                               // CAN EM  SUB ESC FS  GS  RS  US
                                                  yes,yes,yes,yes,yes,yes,yes,yes,
                                               //     !   "   #   $   %   &   '
                                                  yes,yes,yes,yes,yes,yes,yes,yes,
                                               // (   )   *   +   ,   -   .   /
                                                  yes,yes,yes,no ,yes,no ,no ,yes,
                                               // 0   1   2   3   4   5   6   7
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               // 8   9   :   ;   <   =   >   ?
                                                  no ,no ,yes,yes,yes,yes,yes,yes,
                                               // @   A   B   C   D   E   F   G
                                                  yes,no ,no ,no ,no ,no ,no ,no ,
                                               // H   I   J   K   L   M   N   O
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               // P   Q   R   S   T   U   V   W
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               // X   Y   Z   [   \   ]   ^   _
                                                  no ,no ,no ,yes,yes,yes,yes,yes,
                                               //  `  a   b   c   d   e   f   g
                                                  yes,no ,no ,no ,no ,no ,no ,no ,
                                               // h   i   j   k   l   m   n   o
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               // p   q   r   s   t   u   v   w
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               // x   y   z   {   |   }   ~   DEL
                                                  no ,no ,no ,yes,yes,yes,yes,yes].
    // UserInfo : userinfo    = *( unreserved / pct-encoded / sub-delims / ":" = 58 )
    var private logical[128] mFlags_Userinfo = [ // NUL SOH STX ETX EOT ENQ ACK BEL
                                                    yes,yes,yes,yes,yes,yes,yes,yes,
                                                 // BS  HT  LF  VT  FF  CR  SO  SI
                                                    yes,yes,yes,yes,yes,yes,yes,yes,
                                                 // DLE DC1 DC2 DC3 DC4 NAK SYN ETB
                                                    yes,yes,yes,yes,yes,yes,yes,yes,
                                                 // CAN EM  SUB ESC FS  GS  RS  US
                                                    yes,yes,yes,yes,yes,yes,yes,yes,
                                                 //     !   "   #   $   %   &   '
                                                    yes,no ,yes,yes,no ,yes,no ,no ,
                                                 // (   )   *   +   ,   -   .   /
                                                    no ,no ,no ,no ,no ,no ,no ,yes,
                                                 // 0   1   2   3   4   5   6   7
                                                    no ,no ,no ,no ,no ,no ,no ,no ,
                                                 // 8   9   :   ;   <   =   >   ?
                                                    no ,no ,no ,no ,yes,no ,yes,yes,
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
                                                    no ,no ,no ,yes,yes,yes,no ,yes].
    // Host = reg-name      = *( unreserved / pct-encoded / sub-delims )
    // Also IP addresses allowed

    // host        = IP-literal / IPv4address / reg-name
    //IPv4address = dec-octet "." dec-octet "." dec-octet "." dec-octet
    //IP-literal = "[" ( IPv6address / IPvFuture  ) "]"
    //IPvFuture  = "v" 1*HEXDIG "." 1*( unreserved / sub-delims / ":" )
    //reg-name    = *( unreserved / pct-encoded / sub-delims )

    var private logical[128] mFlags_Host = [ // NUL SOH STX ETX EOT ENQ ACK BEL
                                                yes,yes,yes,yes,yes,yes,yes,yes,
                                             // BS  HT  LF  VT  FF  CR  SO  SI
                                                yes,yes,yes,yes,yes,yes,yes,yes,
                                             // DLE DC1 DC2 DC3 DC4 NAK SYN ETB
                                                yes,yes,yes,yes,yes,yes,yes,yes,
                                             // CAN EM  SUB ESC FS  GS  RS  US
                                                yes,yes,yes,yes,yes,yes,yes,yes,
                                             //     !   "   #   $   %   &   '
                                                yes,no ,yes,yes,no ,yes,no ,no ,
                                             // (   )   *   +   ,   -   .   /
                                                no ,no ,no ,no ,no ,no ,no ,yes,
                                             // 0   1   2   3   4   5   6   7
                                                no ,no ,no ,no ,no ,no ,no ,no ,
                                             // 8   9   :   ;   <   =   >   ?
                                                no ,no ,yes,no ,yes,no ,yes,yes,
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
                                                no ,no ,no ,yes,yes,yes,no ,yes].
    // Path : path-abempty  = *( "/" segment )
    //        segment       = *pchar
    var private logical[128] mFlags_Path = [ // NUL SOH STX ETX EOT ENQ ACK BEL
                                                yes,yes,yes,yes,yes,yes,yes,yes,
                                             // BS  HT  LF  VT  FF  CR  SO  SI
                                                yes,yes,yes,yes,yes,yes,yes,yes,
                                             // DLE DC1 DC2 DC3 DC4 NAK SYN ETB
                                                yes,yes,yes,yes,yes,yes,yes,yes,
                                             // CAN EM  SUB ESC FS  GS  RS  US
                                                yes,yes,yes,yes,yes,yes,yes,yes,
                                             //     !   "   #   $   %   &   '
                                                yes,no ,yes,yes,no ,yes,no ,no ,
                                             // (   )   *   +   ,   -   .   /
                                                no ,no ,no ,no ,no ,no ,no ,yes,
                                             // 0   1   2   3   4   5   6   7
                                                no ,no ,no ,no ,no ,no ,no ,no ,
                                             // 8   9   :   ;   <   =   >   ?
                                                no ,no ,no ,no ,yes,no ,yes,yes,
                                             // @   A   B   C   D   E   F   G
                                                no ,no ,no ,no ,no ,no ,no ,no ,
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
                                                no ,no ,no ,yes,yes,yes,no ,yes].
    // Query    = *( pchar / "/" / "?" )
    var private logical[128] mFlags_Query = [ // NUL SOH STX ETX EOT ENQ ACK BEL
                                                 yes,yes,yes,yes,yes,yes,yes,yes,
                                              // BS  HT  LF  VT  FF  CR  SO  SI
                                                 yes,yes,yes,yes,yes,yes,yes,yes,
                                              // DLE DC1 DC2 DC3 DC4 NAK SYN ETB
                                                 yes,yes,yes,yes,yes,yes,yes,yes,
                                              // CAN EM  SUB ESC FS  GS  RS  US
                                                 yes,yes,yes,yes,yes,yes,yes,yes,
                                              //     !   "   #   $   %   &   '
                                                 yes,no ,yes,yes,no ,yes,no ,no ,
                                              // (   )   *   +   ,   -   .   /
                                                 no ,no ,no ,no ,no ,no ,no ,no ,
                                              // 0   1   2   3   4   5   6   7
                                                 no ,no ,no ,no ,no ,no ,no ,no ,
                                              // 8   9   :   ;   <   =   >   ?
                                                 no ,no ,no ,no ,yes,no ,yes,no ,
                                              // @   A   B   C   D   E   F   G
                                                 no ,no ,no ,no ,no ,no ,no ,no ,
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
                                                 no ,no ,no ,yes,yes,yes,no ,yes].
    // Fragment = *( pchar / "/" / "?" )
    var private logical[128] mFlags_Fragment = [ // NUL SOH STX ETX EOT ENQ ACK BEL
                                                    yes,yes,yes,yes,yes,yes,yes,yes,
                                                 // BS  HT  LF  VT  FF  CR  SO  SI
                                                    yes,yes,yes,yes,yes,yes,yes,yes,
                                                 // DLE DC1 DC2 DC3 DC4 NAK SYN ETB
                                                    yes,yes,yes,yes,yes,yes,yes,yes,
                                                 // CAN EM  SUB ESC FS  GS  RS  US
                                                    yes,yes,yes,yes,yes,yes,yes,yes,
                                                 //     !   "   #   $   %   &   '
                                                    yes,no ,yes,yes,no ,yes,no ,no ,
                                                 // (   )   *   +   ,   -   .   /
                                                    no ,no ,no ,no ,no ,no ,no ,no ,
                                                 // 0   1   2   3   4   5   6   7
                                                    no ,no ,no ,no ,no ,no ,no ,no ,
                                                 // 8   9   :   ;   <   =   >   ?
                                                    no ,no ,no ,no ,yes,no ,yes,no ,
                                                 // @   A   B   C   D   E   F   G
                                                    no ,no ,no ,no ,no ,no ,no ,no ,
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
                                                    no ,no ,no ,yes,yes,yes,no ,yes].
    // Cookie US-ASCII characters excluding CTLs, whitespace (32) DQUOTE (34), comma (44), semicolon (59), and backslash (92)
    // 0-31 and 127+ are control or non-US-ASCII character; 32 is space
    var private logical[128] mFlags_Cookie = [ // NUL SOH STX ETX EOT ENQ ACK BEL
                                                  yes,yes,yes,yes,yes,yes,yes,yes,
                                               // BS  HT  LF  VT  FF  CR  SO  SI
                                                  yes,yes,yes,yes,yes,yes,yes,yes,
                                               // DLE DC1 DC2 DC3 DC4 NAK SYN ETB
                                                  yes,yes,yes,yes,yes,yes,yes,yes,
                                               // CAN EM  SUB ESC FS  GS  RS  US
                                                  yes,yes,yes,yes,yes,yes,yes,yes,
                                               //     !   "   #   $   %   &   '
                                                  yes,no ,no ,no ,no ,no ,no ,no ,
                                               // (   )   *   +   ,   -   .   /
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               // 0   1   2   3   4   5   6   7
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               // 8   9   :   ;   <   =   >   ?
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               // @   A   B   C   D   E   F   G
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               // H   I   J   K   L   M   N   O
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               // P   Q   R   S   T   U   V   W
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               // X   Y   Z   [   \   ]   ^   _
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               //  `  a   b   c   d   e   f   g
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               // h   i   j   k   l   m   n   o
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               // p   q   r   s   t   u   v   w
                                                  no ,no ,no ,no ,no ,no ,no ,no ,
                                               // x   y   z   {   |   }   ~   DEL
                                                  no ,no ,no ,no ,no ,no ,no ,yes].

    // Instances that can encode various parts of the URI
    var private PercentEncoder mEncoder_Default, mEncoder_Scheme, mEncoder_Userinfo, mEncoder_Host,
                               mEncoder_Path,    mEncoder_Query,  mEncoder_Fragment, mEncoder_Cookie.

    /* Default constructor */
    constructor public UriEncoder():
        // Build the encoder instances
        assign mEncoder_Default  = new PercentEncoder(mFlags_Default)
               mEncoder_Scheme   = new PercentEncoder(mFlags_Scheme)
               mEncoder_Userinfo = new PercentEncoder(mFlags_Userinfo)
               mEncoder_Host     = new PercentEncoder(mFlags_Host)
               mEncoder_Path     = new PercentEncoder(mFlags_Path)
               mEncoder_Query    = new PercentEncoder(mFlags_Query)
               mEncoder_Fragment = new PercentEncoder(mFlags_Fragment)
               mEncoder_Cookie   = new PercentEncoder(mFlags_Cookie)
               .
    end constructor.

    /** Encodes a string for a particular purpose. Usage of Encode<encoding-type> is recommended.
        The method does NOT re-encode % characters.

        @param character The string to encode
        @param EncondingTypeEnum The type of encoding to apply
        @return character the encoded string */
    method public character Encode(input pString as character,
                                   input pEncodingType as UriEncodingTypeEnum):
        return this-object:Encode(pString, pEncodingType, false).
    end method.

    /** Encodes a string for a particular purpose. Usage of Encode<encoding-type> is recommended,
        unless the re-encoding of % characters is desired.

        @param character The string to encode
        @param EncondingTypeEnum The type of encoding to apply
        @param logical TRUE if any percent characters should  be encoded as %25
        @return character the encoded string */
    method public character Encode(input pString as character,
                                   input pEncodingType as UriEncodingTypeEnum,
                                   input pReEncode as logical):
        /* Don't bother with blank or unknown  */
        if length(pString) eq 0 or pString eq ? then
            return '':u.

        /* What kind of encoding should be used? */
        case pEncodingType:
            when UriEncodingTypeEnum:Default  then return mEncoder_Default:Encode(pString, pReEncode).
            when UriEncodingTypeEnum:Scheme   then return mEncoder_Scheme:Encode(pString, pReEncode).
            when UriEncodingTypeEnum:Userinfo then return mEncoder_Userinfo:Encode(pString, pReEncode).
            when UriEncodingTypeEnum:Host     then return mEncoder_Host:Encode(pString, pReEncode).
            when UriEncodingTypeEnum:Path     then return mEncoder_Path:Encode(pString, pReEncode).
            when UriEncodingTypeEnum:Query    then return mEncoder_Query:Encode(pString, pReEncode).
            when UriEncodingTypeEnum:Fragment then return mEncoder_Fragment:Encode(pString, pReEncode).
            when UriEncodingTypeEnum:Cookie   then return mEncoder_Cookie:Encode(pString, pReEncode).
            // This will cover the case where a new enum may be added but isn't dealt with explicitly.
            otherwise                              return mEncoder_Default:Encode(pString, pReEncode).
        end case.
    end method.

    /* Encodes a string per Cookie encoding rules. This method is here for historical reasons.

       Cookie US-ASCII characters excluding CTLs, whitespace (32) DQUOTE (34), comma (44), semicolon (59), and backslash (92)

       @param character A string to encode
       @return character An encoded string */
    method public character EncodeCookie(input pString as character):
        return mEncoder_Cookie:Encode(pString).
    end method.

    /* Encodes a string per Cookie encoding rules. This method is here for historical reasons.

       Cookie US-ASCII characters excluding CTLs, whitespace (32) DQUOTE (34), comma (44), semicolon (59), and backslash (92)

       @param String A string to encode
       @return character An encoded string */
    method public character EncodeCookie(input pString as String):
        return mEncoder_Cookie:Encode(pString:Value, false).
    end method.

    /* Encodes a string per URI Fragment encoding rules

        https://tools.ietf.org/html/rfc3986#page-11

        unreserved    = ALPHA / DIGIT / "-" / "." / "_" / "~"
        sub-delims  = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
        pchar        = unreserved / pct-encoded / sub-delims / ":" / "@"
        Fragment : fragment      = *( pchar / "/" / "?" )

       @param character A string to encode
       @return character An encoded string */
    method public character EncodeFragment(input pcString as character):
        return mEncoder_Fragment:Encode(pcString).
    end method.

    /* Encodes a string per URI Fragment encoding rules

        https://tools.ietf.org/html/rfc3986#page-11

        unreserved    = ALPHA / DIGIT / "-" / "." / "_" / "~"
        sub-delims  = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
        pchar        = unreserved / pct-encoded / sub-delims / ":" / "@"
        Fragment : fragment      = *( pchar / "/" / "?" )

       @param String A string to encode
       @return character An encoded string */
    method public character EncodeFragment(input pString as String):
        return mEncoder_Fragment:Encode(pString:Value, false).
    end method.

    /* Encodes a string per URI Host encoding rules

       https://tools.ietf.org/html/rfc3986#page-11

       sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
       unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
       Host       = *( unreserved / pct-encoded / sub-delims )

       @param character A string to encode
       @return character An encoded string */
    method public character EncodeHost(input pcString as character):
        var longchar inStr = pcString.
        return this-object:EncodeHost(inStr, ?).
    end method.

    /* Encodes a string per URI Host encoding rules

       https://tools.ietf.org/html/rfc3986#page-11

       sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
       unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
       Host       = *( unreserved / pct-encoded / sub-delims )

       @param String A string to encode
       @return character An encoded string */
    method public character EncodeHost(input pString as String):
        return this-object:EncodeHost(pString:Value, false).
    end method.

    /* Encodes a host value. This method knows how to deal with IPv6 hosts.

       @parameter longchar The host name
       @param logical TRUE if any % values should be encoded
       @return character An encoded value. */
    method protected character EncodeHost(input pHost as longchar,
                                          input pReencode as logical):
        var character ipv6Host.

        // if this is an ipv6 host, don't encode - it should be in hex form already.
        // We don't check this - just assume
        if pHost begins '[':u then
        do:
            assign ipv6Host = right-trim(pHost).
            // form is [:]
            if substring(ipv6Host, length(ipv6Host)) eq ']':u
            and index(ipv6Host, ':':u) gt 0
            then
                {&_proparse_ prolint-nowarn(overflow)}
                return string(pHost).
        end.

        // non-ipv6 address
        return mEncoder_Host:Encode(pHost, pReencode).
    end method.

    /* Encodes a string per URI Path encoding rules

       https://tools.ietf.org/html/rfc3986#page-11

       sub-delims  = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
       unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
       Path       = 1*( unreserved / pct-encoded / sub-delims / "@" )

       @param character A string to encode
       @return character An encoded string */
    method public character EncodePath(input pcString as character):
        return mEncoder_Path:Encode(pcString).
    end method.

    /* Encodes a string per URI Path encoding rules

       https://tools.ietf.org/html/rfc3986#page-11

       sub-delims  = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
       unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
       Path       = 1*( unreserved / pct-encoded / sub-delims / "@" )

       @param String A string to encode
       @return character An encoded string */
    method public character EncodePath(input pString as String):
        return mEncoder_Path:Encode(pString:Value, false).
    end method.

    /* Encodes a string per URI Query encoding rules

       https://tools.ietf.org/html/rfc3986#page-11

       sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
       pchar      = unreserved / pct-encoded / sub-delims / ":" / "@"
       Query      = *( pchar / "/" / "?" )

       @param character A string to encode
       @return character An encoded string */
    method public character EncodeQuery(input pcString as character):
        return mEncoder_Query:Encode(pcString).
    end method.

    /* Encodes a string per URI Query encoding rules

       https://tools.ietf.org/html/rfc3986#page-11

       sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
       pchar      = unreserved / pct-encoded / sub-delims / ":" / "@"
       Query      = *( pchar / "/" / "?" )

       @param String A string to encode
       @return character An encoded string */
    method public character EncodeQuery(input pString as String):
        return mEncoder_Query:Encode(pString:Value, false).
    end method.

    /* Encodes a URI's Query string per URI query encoding rules.

       @param IStringStringMap
       @return character An encoded query string */
    method public character EncodeQuery (input pQueryMap as IStringStringMap):
        var character encodedQuery, qryString, qryDelim.
        var IIterator iter.
        var MapEntry me.

        Assert:NotNull(pQueryMap, 'Query map').

        // encode the query strings
        // we use the map values directly, since they're already encoded,
        // and GetQueryValue()/GetQueryValues() decodes any stored values
        assign qryDelim = '?':u
               iter     = pQueryMap:EntrySet:Iterator()
               .
        do while iter:HasNext():
            assign me = cast(iter:Next(), MapEntry).

            if not valid-object(me:Value)
            or string(me:Value) eq ?
            then
                assign qryString = string(me:Key).
            else
                assign qryString = string(me:Key) + '=':u + string(me:Value).

            // Not sure why this Encode() is necessary, since the values are already encoded, but
            // it has been here for a while and seems to do no harm (since encoded values are not re-encoded)
            // this will also encode the query name if needed
            assign encodedQuery += qryDelim + mEncoder_Query:Encode(qryString)
                   qryDelim      = '&':u
                   .
        end.

        return encodedQuery.
    end method.

    /* Encodes a URI's Query string per URI query encoding rules.

       @param IStringKeyedMap
       @return character An encoded query string */
    method public character EncodeQuery (input pQueryMap as IStringKeyedMap):
        var character encodedQuery, qryString, qryDelim.
        var IIterator iter.
        var MapEntry me.
        var List<String> sl.
        var integer iCount, iLoop.
        var character paramVal.

        Assert:NotNull(pQueryMap, 'Query map').

        // encode the query strings, which will be part of a List<String>
        // we use the map values directly, since they're already encoded, and GetQueryValue()
        // decodes any stored values
        assign qryDelim  = '?':u
               iter      = pQueryMap:EntrySet:Iterator()
               qryString = '':u
               .

        do while iter:HasNext():
            assign me = cast(iter:Next(), MapEntry).

            assign sl = cast(me:Value, List<String>).
            assign iCount = sl:count.
            do iLoop = 1 to iCount:
                assign paramVal = string(sl:Get(iLoop)). // Gets string of value (or unknown).

                if paramVal eq ? then // No value, just start a new named parameter in the query string.
                    assign qryString = substitute('&1&2':u, qryDelim, me:Key:ToString()). // eg. "[?|&]key"
                else
                    assign qryString = substitute('&1&2=&3':u, qryDelim, me:Key:ToString(), paramVal). // eg. "[?|&]key=value"

                // Not sure why this Encode() is necessary, since the values are already encoded, but
                // it has been here for a while and seems to do no harm (since encoded values are not re-encoded)
                // this will also encode the query name if needed
                assign encodedQuery += mEncoder_Query:Encode(qryString).
                assign qryDelim = '&':u.
            end. // do iLoop
        end. // do while

        return encodedQuery.
    end method.

    /* Encodes a string per URI Scheme encoding rules

       https://tools.ietf.org/html/rfc3986#page-11

       Scheme = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )

       @param character A string to encode
       @return character An encoded string */
    method public character EncodeScheme(input pcString as character):
        return mEncoder_Scheme:Encode(pcString).
    end method.

    /* Encodes a string per URI Scheme encoding rules

       https://tools.ietf.org/html/rfc3986#page-11

       Scheme = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )

       @param String A string to encode
       @return character An encoded string */
    method public character EncodeScheme(input pString as String):
        return mEncoder_Scheme:Encode(pString:Value, false).
    end method.

    /* Encodes a string per URI Default encoding rules

       https://tools.ietf.org/html/rfc3986#page-11
       Default  = unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"

       @param character A string to encode
       @return character An encoded string */
    method public character EncodeDefault(input pcString as character):
        return mEncoder_Default:Encode(pcString).
    end method.

    /* Encodes a string per URI Default encoding rules

       https://tools.ietf.org/html/rfc3986#page-11
       Default  = unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"

       @param String A string to encode
       @return character An encoded string */
    method public character EncodeDefault(input pString as String):
        return mEncoder_Default:Encode(pString:Value, false).
    end method.

    /* Encodes a string per URI userinfo encoding rules

       https://tools.ietf.org/html/rfc3986#page-11

       sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
       unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
       Host       = *( unreserved / pct-encoded / sub-delims / ":" )

       @param character A string to encode
       @return character An encoded string */
    method public character EncodeUserinfo(input pcString as character):
        return mEncoder_Userinfo:Encode(pcString).
    end method.

    /* Encodes a string per URI userinfo encoding rules

       https://tools.ietf.org/html/rfc3986#page-11

       sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
       unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
       Host       = *( unreserved / pct-encoded / sub-delims / ":" )

       @param String A string to encode
       @return character An encoded string */
    method public character EncodeUserinfo(input pString as String):
        return mEncoder_Userinfo:Encode(pString:Value, false).
    end method.

    /* Encodes this uri's Host per URI Host encoding rules

       @param URI The URI whose info to encode
       @return character An encoded string */
    method public character EncodeUserinfo(input pURI as URI):
        var character authority.

        Assert:NotNull(pURI, 'URI').

        // authority: host, user, pw
        if pURI:User eq ? then
            return '':u.

        assign authority = mEncoder_Host:Encode(pURI:User).
        if pURI:Password ne ? then
            assign authority += ':':u + mEncoder_Host:Encode(pURI:Password).
        return authority.
    end method.

    /* Decodes an encoded string

       Uses OpenEdge.Net.HTTP.PercentEncoder:Decode() to perform the decoding

       @param character An encoded string
       @return character A decoded string    */
    method public character Decode(input pData as character):
        // decoding is all the same, we can use any of the instances
        {&_proparse_ prolint-nowarn(overflow)}
        return string(mEncoder_Default:Decode(pData)).
    end method.

    /** Attempts to decode a previously-encoded string.

        @param  character The string to decode
        @param  character The target codepage to encode into. Defaults to CPINTERNAL
        @return character A decoded URL
        @throws AppError If the encoding is malformed */
    method public character Decode(input pEncodedString as character,
                                   input pTargetCodepage as character):
        // decoding is all the same, we can use any of the instances
        {&_proparse_ prolint-nowarn(overflow)}
        return string(mEncoder_Default:Decode(pEncodedString, pTargetCodepage)).
    end method.
end class.