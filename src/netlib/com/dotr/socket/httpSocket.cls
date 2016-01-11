/* httpSocket.cls

Licenced under The MIT License

Copyright (c) 2010 Julian Lyndon-Smith

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

routine-level on error undo, throw.

using Progress.Lang.*.

class com.dotr.socket.httpSocket inherits com.dotr.socket.BaseSocket: 
  def public event Disconnected signature void (p_Object as com.dotr.socket.httpSocket).
  def public event NewDataChunk signature void (p_Object as com.dotr.socket.httpSocket,p_Data as memptr).
  def public event NewHeader signature void (p_Object as com.dotr.socket.httpSocket,p_Data as longchar).

  def temp-table TTPostData no-undo
      field PostName as char
      field PostData as CLOB
      
      index PostName is primary
        PostName.

  def temp-table TTHeaderData no-undo
      field HeaderName as char
      field HeaderData as CLOB
      
      index HeaderName is primary
        HeaderName.

  def temp-table TTRequestData no-undo
      field HeaderName as char
      field HeaderData as char
      
      index HeaderName is primary
        HeaderName.
 
  /* Unsafe characters that must be encoded in URL's.  See RFC 1738 Sect 2.2. */
  def public property url_unsafe as char no-undo initial " &<>~"%~{}|~\^~~[]`" get . private set .
    
  /* Reserved characters that normally are not encoded in URL's */
  def public property url_reserved as char no-undo initial "~;/?:@=&" get. private set.
    
  def public property Content-Type  as char no-undo get . set .             
  def public property HeaderContent as char no-undo get . set.

  def public property Content-Length as int no-undo get . private set .
    

  define variable BinaryMessageFragment as raw no-undo.  /* binary, instead of the longchar in httpSocket.cs */
  
  def var Terminator as char no-undo init "~r~n~r~n".
  
  def var TerminatorLength as int no-undo.
  def var DataLeft         as int no-undo.

  def var ChunkedMode as logical no-undo.
  
  constructor public httpSocket (  ):
    super ().
    
    assign TerminatorLength = length(Terminator,"RAW").
 
  end constructor.
  
/*  =========================================================================
    Navigate
    ==========================================================================*/ 
 
  method public void Navigate(p_URL as char):
    Navigate(p_URL,80,"GET":U).
  end method.
    
/*  =========================================================================
    Navigate
    ==========================================================================*/ 
 
  method public void Navigate(p_URL as char,p_Port as int):
    Navigate(p_URL,p_Port,"GET":U).
  end method.

/*  =========================================================================
    Navigate
    ==========================================================================*/ 
 
  method public void Navigate(p_URL as char,p_Port as int,p_method as char):
    
    def var lv_URI  as char no-undo.
    def var lv_Host as char no-undo.
    
    if p_URL begins "https" then assign SSL    = yes
                                        lv_URI = left-trim(p_URL,"https://").
    
    else assign lv_URI = left-trim(p_URL,"http://").
    
    assign lv_Host = entry(1,lv_URI,"/").
    
    assign entry(1,lv_URI,"/") = "".
    
    connect(lv_Host,p_Port).

    case p_method:
        when "POST":U then Post(lv_URI).
        otherwise        get (lv_URI).
    end.
    
    return.
  end method.

/*  =========================================================================
    PostData
    ==========================================================================*/ 
 
  method public void PostData(p_PostName as char, p_PostData as longchar):
    find first TTPostData where TTPostData.PostName eq p_PostName no-error.
  
    if not avail TTPostData then create TTPostData.
   
    assign TTPostData.PostName = UrlEncode(string(p_PostName)).
      
    copy-lob from p_PostData to TTPostData.PostData.
 
    return .
  end method.
  

/* =========================================================================
   AddHeader
   ==========================================================================*/ 
 
  method public void AddHeader(p_HeaderName as char, p_HeaderData as longchar):
     
    find first TTHeaderData where TTHeaderData.HeaderName eq p_HeaderName no-error.
  
    if not avail TTHeaderData then 
    do:
      create TTHeaderData.
      assign TTHeaderData.HeaderName = p_HeaderName.
    end.
       
    copy-lob from p_HeaderData to TTHeaderData.HeaderData.
    
    return .
  end method.
  
/* =========================================================================
   Get
   ==========================================================================*/ 
  
  method public void Get(p_URI as char):
    this-object:Post(p_URI,"GET","").
  end method.
  
/* =========================================================================
   Get
   ==========================================================================*/ 
 
  method public void Get(p_URI as char,p_Data as longchar):
    this-object:Post(p_URI,"GET",p_Data).
  end method.

/* =========================================================================
   Post
   ==========================================================================*/ 
 
  method public void Post(p_URI as char):
    Post(p_URI,"POST").
  end method.
 
/* =========================================================================
   Post
   ==========================================================================*/ 
 
  method public void Post(p_URI as char,p_Type as char):
    this-object:Post(p_URI,p_Type,"").
  end method.
 
/* =========================================================================
   Post
   ==========================================================================*/ 
 
  method public void Post(p_URI as char,p_Type as char,p_Data as longchar):
    def var lv_Data       as longchar no-undo.
    def var lv_TempData   as longchar no-undo.
    def var lv_PostData   as longchar no-undo.
    def var lv_HeaderData as longchar no-undo.
   
    def buffer TTPostData for temp-table TTPostData.

    if not p_URI begins "/" and not p_URI begins "http" then assign p_URI = substitute("/&1",p_URI).

    AddHeader("Accept", "*/*").
    AddHeader("Host", Host).

    if p_Data eq "" then
    for each TTPostData no-lock:
      copy-lob from TTPostData.PostData to lv_PostData.
     
      assign lv_Data = lv_Data + "&" + TTPostData.PostName + '=' + lv_PostData.
      delete TTPostData.
    end.

    else assign lv_Data = p_Data.
 
    assign HeaderContent = "".
    
    for each TTHeaderData no-lock:
      copy-lob from TTHeaderData.HeaderData to lv_TempData.
      assign lv_HeaderData = lv_HeaderData + TTHeaderData.HeaderName + ': ' + lv_TempData + "~r~n" .
      delete TTHeaderData.
    end.
    
    assign HeaderContent = ""
           Content-Length   = 0
           DataLeft      = 0
           lv_Data       = trim(lv_Data,"&")
           lv_Data       = substitute("&1 &2 HTTP/1.1~r~nContent-Type: &3~r~n&4&5&6",
                                     p_Type,
                                     p_URI,
                                     this-object:Content-Type,
                                     if length(lv_Data,"RAW") gt 0 then substitute("Content-Length: &1~r~n",length(lv_Data,"RAW"))
                                                                   else "",
                                     if lv_HeaderData eq "" then "~r~n~r~n" else  substitute("&1~r~n",lv_HeaderData),
                                     if lv_Data eq "" then lv_Data else substitute("&1~r~n",lv_Data)).


    this-object:WriteData(lv_Data).
  end method.

/* =========================================================================
   UrlEncode
   ==========================================================================*/ 
  method public character UrlEncode (p_Value as char):
    return UrlEncode(p_Value,"").
  end method.
 
/*  =========================================================================
    UrlEncode
    ==========================================================================*/ 
  method public character UrlEncode (p_Value as char,p_EncType as char):
    def var hx          as char no-undo initial "0123456789ABCDEF":U.
    def var encode-list as char no-undo.
  
    def var i           as int no-undo.
    def var c           as int no-undo.
   
    /* Don't bother with blank or unknown  */
    if length(p_value,"RAW") = 0 or p_value = ? then return "":U.
     
    /* What kind of encoding should be used? */
    case p_enctype:
      when "query":U then              /* QUERY_STRING name=value parts */
        encode-list = url_unsafe + url_reserved + "+":U.
      when "cookie":U then             /* Persistent Cookies */
        encode-list = url_unsafe + " ,~;":U.
      when "default":U or when "" then /* Standard URL encoding */
        encode-list = url_unsafe.
      otherwise
        encode-list = url_unsafe + p_enctype.   /* user specified ... */
    end case.
  
    /* Loop through entire input string */
    assign i = 0.
    do while true:
      assign
        i = i + 1
        /* ASCII value of character using single byte codepage */
        c = asc(substring(p_value, i, 1, "RAW":U), "1252", "1252").
      if c <= 31 or c >= 127 or INDEX(encode-list, chr(c)) > 0 then do:
        /* Replace character with %hh hexidecimal triplet */
        substring(p_value, i, 1, "RAW":U) =
          "%":U +
          SUBSTRING(hx, integer(truncate(c / 16, 0)) + 1, 1, "RAW":U) + /* high */
          SUBSTRING(hx, c modulo 16 + 1, 1, "RAW":U).             /* low digit */
        assign i = i + 2.   /* skip over hex triplet just inserted */
    end.
    
    if i = LENGTH(p_value,"RAW") then leave.
   end.

   return p_value.
 
  end method.
  
/* ==========================================================================
   SocketDisconnected
   ==========================================================================*/ 

  method override void SocketDisconnected ():
    Disconnected:Publish(this-object).
  end method.
  
/* ==========================================================================
   DataReceived
   ==========================================================================*/ 

  method override void DataReceived (p_Data as memptr):

    define variable StringMessageFragment as longchar no-undo.
    def var lv_messageEnd  as int no-undo.
    def var lv_hex as char no-undo.
    def var chunkdata as memptr. 
    def var availablebytes as integer no-undo.
    def var TryAnotherChunk as logical no-undo initial true.
    
    /* we're screwed when p_Data is larger than 32 kbyte, because that's the size limit for a RAW variable */
    put-bytes(BinaryMessageFragment, length(BinaryMessageFragment, "RAW") + 1) = p_Data.
   
    if HeaderContent eq "" then /* need to get header first */
    do:
      StringMessageFragment = get-string(BinaryMessageFragment, 1). /* assume the data is text, at least the first part (=header)  */
      lv_MessageEnd = index(StringMessageFragment,Terminator) - 1.  /* check for a complete message */
      
      if lv_messageEnd le 0 then 
         return. /* wait for more data until you have the complete header */
      
      HeaderContent = substring(StringMessageFragment,1,lv_MessageEnd).
      DeleteFromMessageFragment(lv_MessageEnd + TerminatorLength).
      ParseHeader(HeaderContent).    
      NewHeader(HeaderContent). /* process new header */
    end.  
    
    do while TryAnotherChunk :
        
        /* it's a loop because: 
           suppose the messagesize (p_Data) is larger than the chunksize and there are N chunks. The last p_Data will contain the last part of chunk N-1 and contains also chunk N.
           When NewBinaryChunk is published for chunk N-1, there's still data in the buffer (chunk N). It would be processed on the next invocation of DataReceived, but there is 
           no next DataReceived because the last byte was already received. So you'll have to loop, looking for more chunks in the buffer, until the buffer is completely processed.
        */ 
        TryAnotherChunk = false.
        
        if ChunkedMode and Content-Length eq 0 then /* each chunk begins with a chunksize. Chunksize is written in text, in hexadecimal notation. The chunkdata can be binary */
        do: 
          StringMessageFragment = get-string(BinaryMessageFragment, 1). /* assume the data is text, at least the first part (header)  */
          lv_messageEnd = index(StringMessageFragment,"~r~n", 2).  
          /* Yes, start index at offset=2. Reason:
             A chunk is defined as: content-length with maybe some spaces, CRLF, data, CRLF. Content-length is the size of data. 
             Once you've read the data, the cursor is at the last CRLF. So skip that CRLF when you want to read the content-length of the next chunk */ 
    
          if lv_messageEnd eq 0 then 
             return. /* this should never happen :) unless you're so lucky to have p_Data end in the middle of ~r~n */
          
          assign lv_hex                   = SUBSTR(StringMessageFragment,1,lv_messageEnd - 1)
                 Content-Length           = HexToInt(trim(lv_Hex))  /* trim to remove spaces and carriage returns and linefeeds. They tend to confuse the HexToInt function */
                 DataLeft                 = Content-Length.
          DeleteFromMessageFragment(lv_messageEnd + 1).
    
          if Content-Length eq 0 then
            assign ResponseComplete = true 
                   ChunkedMode = false. /* you've already processed the last chunk. Some more headerdata may follow, nothing else except some whitespace */
                       
        end.
    
        availablebytes = length(BinaryMessageFragment,"RAW").
        if availablebytes > 0 then do: 
            availablebytes = minimum(Content-Length, availablebytes).
            
            if availablebytes gt 0  then do:
                set-size(chunkdata) = availablebytes.
                put-bytes(chunkdata,1) = get-bytes(BinaryMessageFragment, 1, availablebytes).
                       
                DeleteFromMessageFragment(availablebytes).                         
                Content-Length = Content-Length - availablebytes.  /* = how many bytes to expect from now */
                
                NewDataChunk:PUBLISH(this-object,chunkdata).
                set-size(chunkdata)=0.
                if length(BinaryMessageFragment,"RAW") gt 0  then 
                   TryAnotherChunk = true. /* if there is data remaining then there is a chance that it contains a new chunkheader */
                   
                /* We're all done here. Nothing more to see. Move along. */
                if Content-Length eq 0 then
                    ResponseComplete = true. 
            end.
        end.
    end.
  end method.

  method private void DeleteFromMessageFragment (input numbytes as integer):
       define variable restbytes as integer no-undo.
       
       restbytes = length(BinaryMessageFragment, "RAW") - numbytes.
       if restbytes gt 0  then 
           /* move contents from right to left, so numbytes are overwritten */
           PUT-BYTES(BinaryMessageFragment, 1) = get-bytes(BinaryMessageFragment, numbytes + 1, restbytes).
           
       /* cut size */
       length(BinaryMessageFragment)=restbytes.
  end method.    


/* ==========================================================================
   NewHeader
   ==========================================================================*/ 

  method public void NewHeader(p_Message as longchar):
    NewHeader:PUBLISH(this-object,p_Message). /* process new message */
  end method.
  
/* ==========================================================================
   ParseHeader
   ==========================================================================*/ 
  method private void ParseHeader(p_header as char):
    def var lv_i   as int no-undo.
    def var lv_Pos as int no-undo.
    
    def var lv_Data       as char no-undo.
    def var lv_FieldName  as char no-undo.
    def var lv_FieldValue as char no-undo.
    
    assign ChunkedMode = no.
    
    empty temp-table TTRequestData.
    
    do lv_i = 1 to num-entries(p_Header,"~n"):
      assign lv_Data = trim(string(entry(lv_i,p_Header,"~n"))).
      if lv_Data eq "" then next. 
       
      assign lv_pos = index(lv_Data,":").

      if lv_pos eq 0 then next. 
      
      assign lv_FieldName  = trim(SUBSTR(lv_Data,1,lv_pos - 1))
             lv_FieldValue = trim(SUBSTR(lv_data,lv_pos + 1)).
             
      create TTRequestData.
      assign TTRequestData.HeaderData = lv_FieldValue
             TTRequestData.HeaderName = lv_FieldName.              
             
      case lv_FieldName:
        when "Transfer-Encoding" then
          do:
            if lv_FieldValue eq "chunked" then assign ChunkedMode = yes
                                                      Content-Length = 0.
          end.          

        when "Content-Length" then assign Content-Length = INT(lv_FieldValue)
                                          DataLeft    = Content-Length.
                                          
        when "Content-Type"   then assign Content-Type = entry(1,lv_FieldValue,";").

      end case.             
    end.
    
  end method.
  
/* ==========================================================================
   HeaderValue
   ==========================================================================*/ 
  method public char HeaderValue(p_Header as char):
    def buffer TTRequestData for temp-table TTRequestData.
    
    find first TTRequestData where TTRequestData.HeaderName  eq p_Header no-lock no-error.
    
    return if avail TTRequestData then TTRequestData.HeaderData else "".
  end method.

  /** updated this method with code kindly supplied by Stefan Drissen
    */

  method public static int HexToInt(i_chex as char):
    def var iresult   as int no-undo.
    def var ii        as int no-undo.
    
    def var chex      as char no-undo.
    
    def var rhex      as raw no-undo.    
   
    assign chex = trim(i_chex).
    
    if length( chex ) modulo 2 eq 1 then assign chex = "0":u + chex.
    
    assign rhex = hex-decode( chex ).
 
    do ii = 1 to length( rhex ).
      assign
         iresult = iresult * 256
         iresult = iresult + get-byte( rhex, ii )
         .
   end.
 
   return iresult.  
  end method.
 
end class.