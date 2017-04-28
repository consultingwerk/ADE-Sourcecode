/************************************************
Copyright (c) 2014-2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : SocketReadEventArgs
    Purpose     : Arguments for the socket read-response event
    Author(s)   : pjudge
    Created     : Tue Nov 25 09:33:17 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Memptr.

class OpenEdge.Net.ServerConnection.SocketReadEventArgs:
    /** Is the current read complete? */
    define public property ReadComplete as logical no-undo get. set.

    /** Did the read timeout? ? */
    define public property ReadTimeout as logical no-undo get. set.

    /** Did the read terminate? ? */
    define public property ReadTerminated as logical no-undo get. set.

    
    /** Memptr containing the read data */
    define public property Data as class Memptr no-undo get. set.
    
    /** Timeout for this read request */
    define public property TimeoutEnd as datetime-tz no-undo get. private set.

    /** How many bytes are in the Data property (may be < Size) */
    define public property BytesRead as int64 no-undo get. set.
    
    /** Constructor.
        @param decimal The timeout value for this read event. */
    constructor public SocketReadEventArgs(input pdTimeoutOffset as decimal):
        // INT() functions rounds which is a good-enough guess 
        this-object(integer(pdTimeoutOffset)).
    end constructor.
    
    /** Constructor.
        
        @param integer The timeout value for this read event. */
    constructor public SocketReadEventArgs(input piTimeoutOffset as integer):
        this-object().
        
        Assert:IsZeroOrPositive(piTimeoutOffset, 'Timeout').
        
        if piTimeoutOffset gt 0 then
            this-object:TimeoutEnd = add-interval(now, piTimeoutOffset, 'seconds':u).
    end constructor.
    
    /** Constructor.
        
        @param Memptr An existing chunk of data. */
    constructor public SocketReadEventArgs(input poData as class Memptr):
        this-object().
        
        Assert:NotNull(poData, 'data bucket').
        assign this-object:Data       = poData
               this-object:BytesRead  = poData:Size.
    end constructor.
    
    /** Default constructor */
    constructor public SocketReadEventArgs():
        assign this-object:ReadComplete   = false
               this-object:ReadTerminated = false
               this-object:ReadTimeout    = false
               this-object:TimeoutEnd     = ?.
    end constructor.
    
end class.