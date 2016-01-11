/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ClientSocket
    Description : An implementation of a client socket 
    Author(s)   : pjudge
    Created     : Tue Nov 25 09:13:36 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.ServerConnection.IConnectionParameters.
using OpenEdge.Core.ServerConnection.IServerConnection.
using OpenEdge.Core.String.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Net.ServerConnection.ClientSocket.
using OpenEdge.Net.ServerConnection.ClientSocketConnectionParameters.
using OpenEdge.Net.ServerConnection.SocketReadEventArgs.
using OpenEdge.Net.URI.
using Progress.Lang.AppError.
using Progress.Lang.Error.
using Progress.Lang.Object.

class OpenEdge.Net.ServerConnection.ClientSocket
        implements IServerConnection:
    
    /* ease-of-use variable for the socket (as opposed to extracting from the Server property */
    define private variable mhSocket as handle no-undo.
    /* Stateful variable for various reasons */
    define private variable mhHelperProc as handle no-undo.
    define private variable moReadEventArgs as SocketReadEventArgs no-undo.
    define private variable moReadHandlerError as Error no-undo.
        
    define public property Server as Object no-undo get. private set.
    define public property ConnectionParameters as IConnectionParameters no-undo get. private set.
    
    /** Event fired when a chunk of data is received from the socket */
    define public event DataReceived signature void (input poSender as ClientSocket,
                                                     input poEventArgs as SocketReadEventArgs).
    
    /** Fired when a read times out (optional based on a timeout) */
    define public event ReadTimeout signature void (input poSender as ClientSocket,
                                                    input poEventArgs as SocketReadEventArgs).
                                                    
    /** Fired when a read is terminated for an reason (socket disconnect, no data etc) */
    define public event ReadTerminated signature void (input poSender as ClientSocket,
                                                       input poEventArgs as SocketReadEventArgs).
    
    /** The size of the data buffer read from the socket on notification, in bytes.
        The socket may have less than this amount available, and will only
        populate what it has. 
        
        Defaults to 8k (per suggestions at 
        http://stackoverflow.com/questions/2811006/what-is-a-good-buffer-size-for-socket-programming) */
    define public property ReadBufferSize as integer no-undo get. set.
    
    /** The default timeout while waiting for the sockets to return reads.
        Defaults to 'never' (zero). */
    define public property DefaultReadTimeout as integer initial 0 no-undo get. set.
    
    /** Sets the TCP socket option SO_KEEPALIVE.
        Set arguments to TRUE to turn this option on or to FALSE to turn it off. */
    define public property KeepAlive as logical no-undo
        get:
            return valid-handle(mhSocket) and
                         logical(mhSocket:get-socket-option("SO-KEEPALIVE":U)).
        end get.
        set(input plKeepAlive as logical):
            if valid-handle(mhSocket) then
                mhSocket:set-socket-option("SO-KEEPALIVE":U, string(plKeepAlive, 'true/false':u)).
        end set.
    
    /** Sets the TCP socket option TCP-NODELAY */
    define public property NoDelay as logical no-undo
        get:
            return valid-handle(mhSocket) and
                         logical(mhSocket:get-socket-option("TCP-NODELAY":U)).
        end get.
        set(input plNoDelay as logical):
            if valid-handle(mhSocket) then
                mhSocket:set-socket-option("TCP-NODELAY":U, string(plNoDelay, 'true/false':u)).
        end set.
    
    /** Sets the TCP socket option SO-REUSEADDR */
    define public property ReuseAddress as logical no-undo
        get:
            return valid-handle(mhSocket) and
                         logical(mhSocket:get-socket-option("SO-REUSEADDR":U)).
        end get.
        set(input plReuseAddress as logical):
            if valid-handle(mhSocket) then
                mhSocket:set-socket-option("SO-REUSEADDR":U, string(plReuseAddress, 'true/false':u)).
        end set.
                
    /** Sets the TCP socket option SO-RCVBUF.
        Set arguments to the desired size of the buffer */
    define public property ReceiveBufferSize as integer no-undo
        get:
            if valid-handle(mhSocket) then
                return integer(mhSocket:get-socket-option("SO-RCVBUF":U)).
            else
                return ?.
        end get.
        set(input piReceiveBufferSize as integer):
            if valid-handle(mhSocket) then
                mhSocket:set-socket-option("SO-RCVBUF":U, string(piReceiveBufferSize)).
        end set.
    
    /** Sets the TCP socket option SO-SNDBUF.
        Set arguments to the desired size of the buffer */
    define public property SendBufferSize as integer no-undo
        get:
            if valid-handle(mhSocket) then
                return integer(mhSocket:get-socket-option("SO-SNDBUF":U)).
            else
                return ?.
        end get.
        set(input piSendBufferSize as integer):
            if valid-handle(mhSocket) then
                mhSocket:set-socket-option("SO-SNDBUF":U, string(SendBufferSize)).
        end set.

    /** Sets the TCP socket option SO-RCVTIMEO.
        Sets the timeout length—that is, the number of seconds the socket waits
        to receive data before timing out. */
    define public property ReceiveTimeout as integer no-undo
        get:
            if valid-handle(mhSocket) then
                return integer(mhSocket:get-socket-option("SO-RCVTIMEO":U)).
            else
                return ?.
        end get.
        set(input piReceiveTimeout as integer):
            if valid-handle(mhSocket) then
                mhSocket:set-socket-option("SO-RCVTIMEO":U, string(ReceiveTimeout)).
        end set.

    /** Sets the TCP socket option SO-LINGER. 
        Returns ? if the SO-LINGER option is not enabled, or if the socket is not
        yet created.
        
        Setting this property to ? disables the SO-LINGER option. */  
    define public property LingerTime as integer no-undo
        get:
            define variable iLingerTime as integer no-undo.
            define variable cLinger as character no-undo.
            
            assign iLingerTime = ?.
            if valid-handle(mhSocket) then
            do:
                assign cLinger = mhSocket:get-socket-option("SO-LINGER":U).
                if logical(entry(1, cLinger)) then
                    assign iLingerTime = integer(entry(2, cLinger)).
            end.

            return iLingerTime.
        end get.
        set(input piLingerTime as integer):
            define variable cLinger as character no-undo.
            
            if valid-handle(mhSocket) then
            do:
                if piLingerTime eq ? then
                    assign cLinger = 'false':u.
                else
                    assign cLinger = 'true':u.                                    
                mhSocket:set-socket-option("SO-LINGER":U, cLinger + ',' + string(piLingerTime)).
            end.
        end set.
    
    /**  Returns true if the server is valid and connected. False otherwise */
    define public property Connected as logical no-undo
        get():
            return valid-handle(mhSocket) and mhSocket:connected().
        end get.
    
    /** Constructor. 
    
        @param ClientSocketConnectionParameters A URI and other parameters that
               this socket will connect to. */
    constructor public ClientSocket(input poConnectionParameters as ClientSocketConnectionParameters):
        this-object().
        
        Assert:NotNull(poConnectionParameters, 'Socket Connection Parameters').  
        assign this-object:ConnectionParameters = poConnectionParameters.
    end constructor.
    
    /** Default constructor. Connection parameters can be specified via the
        Connnect() method. */ 
    constructor public ClientSocket():
        assign this-object:ReadBufferSize = 0x2000. /* 8k, see property comment */
    end constructor.
    
    destructor ClientSocket():
        this-object:DestroyServer().
    end destructor.
    
    /** Connect to the server specified, based on passed-in URI
    
        @param URI Connection information for the connection. */
    method public void Connect(input poURI as URI):
        this-object:ConnectionParameters = new ClientSocketConnectionParameters(poURI).
        this-object:Connect().
    end method.
    
    /** Connect to the server specified, based on passed-in Connection Parameters
        
        @param ClientSocketConnectionParameters Connection information for the connection. */
    method public void Connect(input poParams as ClientSocketConnectionParameters):
        Assert:NotNull(poParams, 'Socket Connection Parameters').
        
        this-object:ConnectionParameters = poParams.
        this-object:Connect().
    end method.

    /** Connect to the server specified, based on existing ConnectionParameters */
    method public void Connect():
        define variable mhSocket as handle no-undo.
        define variable iStartTime as integer no-undo.
        
        if not valid-object(this-object:Server) then
            CreateServer().
        
        Assert:NotNull(this-object:ConnectionParameters, 'Connection parameters').
        
        LogMessage(substitute('CONNECT: &1', this-object:ConnectionParameters:GetConnectionString()), 5).
        
        mhSocket = cast(this-object:Server, WidgetHandle):Value.
        
        mhSocket:sensitive = yes.

        if this-object:Connected then
            return.

        /* Run this on every socket 'session' to avoid circular references between 
           the .P and this object. */
        run OpenEdge/Net/ServerConnection/sockethelper.p persistent set mhHelperProc
                            (this-object, 'ReadResponseHandler':u).
        
        mhSocket:set-read-response-procedure('ReadResponseHandler':u, mhHelperProc).
        
        assign iStartTime = mtime.
        mhSocket:connect(this-object:ConnectionParameters:GetConnectionString()).
        
        LogMessage('CONNECT: TIME(ms)=':u + string(mtime - iStartTime), 5).
    end method.
    
    /** Disconnect from the server, if connected */    
    method public void Disconnect():
        if this-object:Connected then
            cast(Server, WidgetHandle):Value:disconnect().
            
        delete object mhHelperProc no-error.
        assign mhHelperProc = ?. 
    end method.

    /** Creates a server object (ie this-object:Server). This is separated
        from the Connect/Disconnect pair of methods so that one server can 
        be connected and disconnected multiple time. */
    method public void CreateServer():
        create socket mhSocket.
        
        this-object:Server = new WidgetHandle(mhSocket).
    end method.

    /** Destroys the server object (ie this-object:Server). This is separated
        from the Connect/Disconnect pair of methods so that one server can 
        be connected and disconnected multiple time. */
    method public void DestroyServer():
        if this-object:Connected then
            this-object:Disconnect().

        delete object mhSocket no-error.
        this-object:Server = ?.
    end method.
    
    /** Waits for a response from a write event on the socket with a 
        no timeout. Uses the default timeout, which is none/zero */
    method public void WaitForResponse():
        WaitForResponse(this-object:DefaultReadTimeout).
    end method.
    
    /** Waits for a response from a write event on the socket.
        
        @param integer A timeout value for read events in seconds. A zero
                       value means no timeout. */
    method public void WaitForResponse(input piTimeout as integer):
        define variable iStartTime as integer no-undo.
        
        Assert:IsZeroOrPositive(piTimeout, 'Timeout').
        assign moReadHandlerError = ?
               moReadEventArgs = new SocketReadEventArgs(piTimeout)
               iStartTime = mtime
               mhSocket:sensitive = true.
        
        wait-for 'U2':u of mhSocket.
        LogMessage('READ: TOTAL TIME(ms)=':u + string(mtime - iStartTime), 5).
        
        /* 'catch' the errors from the handler after the wait-for.
           issue PSC00322919 logged to avoid this. */
        if valid-object(moReadHandlerError) then
            return error moReadHandlerError.
    end method.
    
    /** Callback/event procedure fired on the READ-RESPONSE event of the 
        socket. */
    method public void ReadResponseHandler():
        define variable mData as memptr no-undo.
        define variable iBytesAvailable as integer no-undo.
        define variable iStartTime as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable oError as AppError no-undo.
        
        ERROR-CATCHER-BLOCK:
        do on error undo, leave:
            /* this is needed to stop the read trigger from firing whilst processing
               in theory this should not be needed, but after suggestions from Greg Higgins
               and experimentation it seems to be the "chicken soup" solution for sockets that
               READKEY PAUSE 0 is for other areas */
            assign mhSocket:sensitive = no
                   /* store the available bytes in case there are none. */
                   iBytesAvailable = mhSocket:get-bytes-available()
                   iStartTime = mtime
                   /* don't want any residual errors. this line is why we love structured-error-handling */
                   error-status:error = false.
            LogMessage('READ: AVAIL(b)=':u + string(iBytesAvailable), 5).
            
            /* now set the proper size */
            set-size(mData) = this-object:ReadBufferSize.
            
            /* read all the available bytes */
            if iBytesAvailable gt 0 then
            do:
                mhSocket:read(mData, 1, this-object:ReadBufferSize, read-available) no-error.
                LogMessage('READ: TIME(ms)=':u + string(mtime - iStartTime), 5).
                LogMessage('READ: SIZE(b)=':u + string(mhSocket:bytes-read), 5).
            end.
            
            /* We can determine whether the socket disconnected thusly:
                - Calling the READ( ) method on the socket object returns an error
                – The value returned by a GET-BYTES-AVAILABLE( ) method invoked on the
                  socket object is zero (0) */
            if error-status:error or
               iBytesAvailable eq 0 then
            do:
                /* Propogate any errors along. Build the error here to avoid contamination
                   from any other errors raised by substribers or others */
                if error-status:error then
                do:
                    assign oError = new AppError(error-status:get-message(1), 0).
                    do iLoop = 2 to error-status:num-messages:
                        oError:AddMessage(error-status:get-message(iLoop), 0).
                    end.
                end.
                
                if iBytesAvailable eq 0 then
                    assign moReadEventArgs:BytesRead = iBytesAvailable
                           moReadEventArgs:Data = ?.
                else
                    assign moReadEventArgs:BytesRead = mhSocket:bytes-read
                           /* Add this data to the eventargs */
                           moReadEventArgs:Data = new Memptr(get-pointer-value(mData),
                                                             get-size(mData)).
                                
                OnReadTerminated(moReadEventArgs).
                
                /* Read is terminated. We're done here.  */
                assign moReadEventArgs:ReadComplete = true.
                
                /* throw 'em if you got 'em */
                if valid-object(oError) then
                    undo, throw oError.
            end.
            else
            do:
                assign moReadEventArgs:BytesRead = mhSocket:bytes-read
                       /* Add this data to the eventargs */
                       moReadEventArgs:Data = new Memptr(get-pointer-value(mData),
                                                         get-size(mData)).
                
                /* tell any listeners that we have new data */
                OnDataReceived(moReadEventArgs).
            end.
                        
            /* Swallow any errors and use old-fashioned class-variables to
               pass the errors onwards & upwards :( */
            catch eError as Error:
                assign moReadHandlerError = eError.
            end catch.
            finally:
                /* more chicken soup (see above) */
                assign mhSocket:sensitive = yes.
            end finally.
        end.    /* ERROR-CATCHER-BLOCK */
            
        /** ALL DONE **/
        
        /* if we're all out of time */
        if (moReadEventArgs:TimeoutEnd ne ? and
            moReadEventArgs:TimeoutEnd le now) then
        do:
            OnReadTimeout(moReadEventArgs).
            assign moReadEventArgs:ReadComplete = true.
        end.
        
        /* stop listening if we've got all the data, or
           the read is otherwise done (diconnect/no data) */
        if valid-object(moReadHandlerError) or
           moReadEventArgs:ReadComplete then
        do:
            LogMessage(substitute('READ: COMPLETE= &1':u, moReadEventArgs:ReadComplete), 5).
            LogMessage(substitute('READ: ERROR= &1':u, string(moReadHandlerError)), 5).
            apply "U2":u to mhSocket.
        end.
        
        finally:
            assign moReadEventArgs:Data = ?.
            
            /* clear memory */
            set-size(mData) = 0.
        end finally.
    end method.
    
    /** Publishes the DataReceived event.
    
        @param SocketReadEventArgs Arguments for this event */
    method protected void OnDataReceived (input poEventArgs as SocketReadEventArgs):
        Assert:NotNull(poEventArgs, 'Socket Read Event Args').
        
        this-object:DataReceived:Publish(this-object, poEventArgs).
    end method.     

    /** Publishes the ReadTerminated event.
    
        @param EventArgs Arguments for this event */
    method protected void OnReadTerminated (input poEventArgs as SocketReadEventArgs):
        Assert:NotNull(poEventArgs, 'Read Terminated Event Args').
        
        this-object:ReadTerminated:Publish(this-object, poEventArgs).
    end method.     

    /** Publishes the ReadTimeout event.
    
        @param EventArgs Arguments for this event */
    method protected void OnReadTimeout (input poEventArgs as SocketReadEventArgs):
        Assert:NotNull(poEventArgs, 'Read Timeout Event Args').
        
        this-object:ReadTimeout:Publish(this-object, poEventArgs).
    end method.     
    
    /** Writes data to the connected server.
    
        @param Memptr The data to be written to the socket. */
    method public void WriteData(input poData as class Memptr):
        define variable iSize    as int64 no-undo. 
        define variable iWritten as int64 no-undo.
        define variable iStart   as int64 no-undo.
        define variable mData    as memptr no-undo.
        define variable iStartTime as integer no-undo.
        
        if not this-object:Connected then
            return error new AppError('Client socket not connected', 0).
        
        /* this is needed to prevent other processes from writing to the socket
           until this write is complete */
        assign mhSocket:sensitive = false
               iSize  = poData:Size
               /* Start writing data from this position */
               iStart = 1.
        
        /* use a local memptr */
        set-size(mData) = iSize.
        set-pointer-value(mData) = poData:GetPointerValue().
        
        do while iSize gt 0 :
            assign iStartTime = mtime.
            
            mhSocket:write(mData, iStart, iSize).
            
            LogMessage('WRITE: TIME(ms)=':u + string(mtime - iStartTime), 5).
            LogMessage('WRITE: SIZE(b)=':u  + string(iSize), 5).
            
            assign iStart = mhSocket:bytes-written. /* check to see how much got sent  */
            
            /* no need to check anything else. All was sent */
            if iStart eq iSize then
                leave.  
            
                   /* calculate new starting position */
            assign iStart = mhSocket:bytes-written + 1
                   /* calculate new size of data to send */
                   iSize  = iSize - iStart + 1.
        end.
        
        finally:
            /* apply chicken soup */
            assign mhSocket:sensitive = true.
            
            /* clean up LOCAL memptr, not the one in the Memptr object. That's for
               the caller to do.
               
               Make sure to FIRST unset the pointer, THEN set the size, else
               we bugger up the Memptr class */
            set-pointer-value(mData) = 0.
            set-size(mData) = 0.
        end.
    end method.
    
    method private void LogMessage(input pcMessage as character,
                                   input piLogLevel as integer):
        if log-manager:logfile-name eq ? then
            return.
        
        if log-manager:logging-level ge piLogLevel then
            log-manager:write-message(pcMessage, 'SOCKET':u).
    end method.
    
end class.