/************************************************
Copyright (c) 2014-2019 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ClientSocket
    Description : An implementation of a client socket 
    Author(s)   : pjudge
    Created     : Tue Nov 25 09:13:36 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IHandleHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.ServerConnection.IConnectionParameters.
using OpenEdge.Core.ServerConnection.IServerConnection.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.ServerConnection.ClientSocket.
using OpenEdge.Net.ServerConnection.ClientSocketConnectionParameters.
using OpenEdge.Net.ServerConnection.SocketReadEventArgs.
using OpenEdge.Net.URI.
using Progress.Lang.AppError.
using Progress.Lang.Error.
using Progress.Lang.Object.

class OpenEdge.Net.ServerConnection.ClientSocket
        implements IServerConnection, ISupportLogging:
    
    /* Corresponds to the socket's LOCAL-HOST attribute */
    define public property LocalHost as character no-undo get. private set.
    
    /* Corresponds to the socket's LOCAL-PORT attribute*/
    define public property LocalPort as integer no-undo get. private set.
     
    /* Corresponds to the socket's REMOTE-HOST attribute */ 
    define public property RemoteHost as character no-undo get. private set.

    /* Corresponds to the socket's REMOTE-PORT attribute */
    define public property RemotePort as integer no-undo get. private set.
    
    /* Corresponds to the socket's SSL-SERVER-NAME attribute  */
    define public property SslServerName as character no-undo get. private set.
    
    /* A reference to the Logger in use by an implementer */
    define public property Logger as ILogWriter no-undo
        get():
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(get-class(ClientSocket)).
            return this-object:Logger.
        end get.
        set.
    
    /* ease-of-use variable for the socket (as opposed to extracting from the Server property */
    define private variable mhSocket as handle no-undo.
    /* Stateful variable for various reasons */
    define private variable mhHelperProc as handle no-undo.
    define private variable moReadEventArgs as SocketReadEventArgs no-undo.
    define private variable moReadHandlerError as Error no-undo.
    /* debug only */
    define private variable miTotalBytesRead as int64 no-undo.
        
    /** A reference to the actual server. Must be an instance of an Ccs.Common.Support.IHandleHolder */
    define public property Server as Object no-undo
        get.
        private set(input pServer as Progress.Lang.Object):
            Assert:IsType(pServer, get-class(IHandleHolder)).
            
            assign this-object:Server = pServer.
        end set.
    
    /** Parameters for this connection */
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
    define public property KeepAlive as logical initial ? no-undo get. set.
    
    /** Sets the TCP socket option TCP-NODELAY */
    define public property NoDelay as logical initial ? no-undo get. set.
    
    /** Sets the TCP socket option SO-REUSEADDR */
    define public property ReuseAddress as logical initial ? no-undo get. set.
                
    /** Sets the TCP socket option SO-RCVBUF.
        Set arguments to the desired size of the buffer */
    define public property ReceiveBufferSize as integer initial ? no-undo get. set.
    
    /** Sets the TCP socket option SO-SNDBUF.
        Set arguments to the desired size of the buffer */
    define public property SendBufferSize as integer initial ? no-undo get. set.

    /** Sets the TCP socket option SO-RCVTIMEO.
        Sets the timeout lengththat is, the number of seconds the socket waits
        to receive data before timing out. */
    define public property ReceiveTimeout as integer initial ? no-undo get. set.

    /** Sets the TCP socket option SO-LINGER. 
        Returns ? if the SO-LINGER option is not enabled, or if the socket is not
        yet created.
        
        Setting this property to ? disables the SO-LINGER option. */  
    define public property LingerTime as integer initial -1 no-undo
        get.
        set(input piTime as integer):
            /* negative values indicate an 'unset' state */
            if piTime ne ? and piTime lt 0 then
                return error new AssertionFailedError('Linger time cannot be negative', 0).
            
            assign this-object:LingerTime = piTime.
        end set.
    
    /**  Returns true if the server is valid and connected. False otherwise */
    define public property Connected as logical no-undo
        get():
            return IsConnected().
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
        
        Logger:Debug(substitute('Connect: &1':u, this-object:ConnectionParameters:GetConnectionString())).
        
        assign mhSocket           = cast(this-object:Server, IHandleHolder):Value
               mhSocket:sensitive = yes
               .
        if this-object:Connected then
            return.
        
        /* Run this on every socket 'session' to avoid circular references between 
           the .P and this object. */
        run OpenEdge/Net/ServerConnection/sockethelper.p persistent set mhHelperProc
                            (this-object, 'ReadResponseHandler':u).
        
        mhSocket:set-read-response-procedure('ReadResponseHandler':u, mhHelperProc).
        
        assign iStartTime = mtime.
        mhSocket:connect(this-object:ConnectionParameters:GetConnectionString()).
                
        SetSocketOptions(mhSocket).
        
        Logger:Debug(substitute('Connect: TIME(ms)=&1':u, mtime - iStartTime)).
        
        assign this-object:LocalHost     = mhSocket:local-host
               this-object:LocalPort     = mhSocket:local-port
               this-object:RemoteHost    = mhSocket:remote-host
               this-object:RemotePort    = mhSocket:remote-port
               this-object:SslServerName = mhSocket:ssl-server-name
               .
    end method.
    
    /** Disconnect from the server, if connected */    
    method public void Disconnect():
        if this-object:Connected then
            cast(Server, WidgetHandle):Value:disconnect().
        
        delete object mhHelperProc no-error.
        assign mhHelperProc              = ? 
               this-object:LocalHost     = ?
               this-object:LocalPort     = ?
               this-object:RemoteHost    = ?
               this-object:RemotePort    = ?
               this-object:SslServerName = ?
               // reset the error-status:error flag
               no-error. 
        
        if valid-object (this-object:ConnectionParameters) then
            Logger:Debug(substitute('Disconnect: &1', this-object:ConnectionParameters:GetConnectionString())).
        else
            Logger:Debug('Disconnect').
    end method.

    /** Creates a server object (ie this-object:Server). This is separated
        from the Connect/Disconnect pair of methods so that one server can 
        be connected and disconnected multiple time. */
    method public void CreateServer():
        create socket mhSocket.
        
        assign this-object:Server = new WidgetHandle(mhSocket, true /*autodestroy*/ ).
    end method.
    
    /** Destroys the server object (ie this-object:Server). This is separated
        from the Connect/Disconnect pair of methods so that one server can 
        be connected and disconnected multiple time. */
    method public void DestroyServer():
        if this-object:Connected then   
            this-object:Disconnect().
        
        // the socket handle is deleted/destroyed along with the object        
        if valid-object(this-object:Server) then
            delete object this-object:Server.
    end method.
    
    /** Waits for a response from a write event on the socket with a 
        no timeout. Uses the default timeout, which is none/zero */
    method public void WaitForResponse():
        WaitForResponse(this-object:DefaultReadTimeout).
    end method.
    
    /** Waits for a response from a write event on the socket. Polls
        (ie loops) for a response
        
        @param decimal A timeout value for read events in seconds. A zero
                       value means no timeout. */
    method public void WaitForResponse(input pdTimeout as decimal):
        define variable iStartTime as integer no-undo.
        define variable socketTimeout as integer no-undo.
        define variable timeoutLeft as decimal no-undo.
        
        Assert:IsZeroOrPositive(pdTimeout, 'Timeout').
        assign moReadHandlerError = ?
               moReadEventArgs    = new SocketReadEventArgs(pdTimeout)
               iStartTime         = mtime
               mhSocket:sensitive = true
               socketTimeout      = -1
               timeoutLeft        = pdTimeout
               .
        if pdTimeout gt 0 then
            assign socketTimeout = integer(mhSocket:get-socket-option('SO-RCVTIMEO':u)).
        if socketTimeout gt 0 then
            assign timeoutLeft = min(pdTimeout, socketTimeout).
        
        Logger:Debug(substitute('WaitSync: timeout(s)=&1':u, pdTimeout)).
        
        WAIT-LOOP:
        do while not moReadEventArgs:ReadComplete
            on error undo, throw:
            
            if pdTimeout gt 0 then
            do:
                if moReadEventArgs:TimeoutEnd lt now then
                do:
                    assign moReadEventArgs:ReadTimeout = true.
                    leave WAIT-LOOP.
                end.
                
                // convert to seconds (or part thereof)
                assign timeoutLeft = interval(moReadEventArgs:TimeoutEnd, datetime-tz(now), 'milliseconds':u) / 1000.
                if timeoutLeft gt 0 then
                do:
                    // MUST be set as whole seconds 
                    mhSocket:set-socket-option('SO-RCVTIMEO':u, string(integer(timeoutLeft))).
                    Logger:Trace(substitute('Socket timeout set to &1':u, timeoutLeft)).
                end.
            end.
            
            // manunally call the handler instead of from a callback
            ReadResponseHandler().
        end.    //WAIT-LOOP
        
        Logger:Debug(substitute('WaitSync: total time(ms)=&1':u, (mtime - iStartTime ) / 1000)).
        Logger:Debug(substitute('WaitSync: total size(b)=&1':u,  miTotalBytesRead)).
        
        // if we have all the data then we've not timed out 
        if (pdTimeout gt 0 and moReadEventArgs:TimeoutEnd lt now) 
           or moReadEventArgs:ReadTimeout then
        do:
            Logger:Debug('WaitSync: socket timed out':u).
            // we're done here 
            assign moReadEventArgs:ReadComplete = true.
            OnReadTimeout(moReadEventArgs).
        end.
        
        /* 'catch' the errors from the handler after the wait-for.
           issue PSC00322919 logged to avoid this. */
        if valid-object(moReadHandlerError) then
            return error moReadHandlerError.
        
        catch e as Progress.Lang.Error :
            Logger:Trace('WaitSync: read error':u, e).
            return error e.
        end catch.
        finally:
            if pdTimeout gt 0 then
            do:
                // reset even it it's -1
                Logger:Trace(substitute('WaitSync: socket timeout reset to &1':u, socketTimeout)).
                mhSocket:set-socket-option('SO-RCVTIMEO':u, string(socketTimeout)).
            end.
        end finally.
    end method.
    
    /** Waits for a response from a write event on the socket. Uses a WAIT-FOR loop
        to emulate/provide async.
        
        @param decimal A timeout value for read events in seconds. A zero
                       value means no timeout. */
    method public void WaitForResponseAsync(input pdTimeout as decimal):
        define variable iStartTime as integer no-undo.
        
        Assert:IsZeroOrPositive(pdTimeout, 'Timeout').
        assign moReadHandlerError = ?
               moReadEventArgs    = new SocketReadEventArgs(pdTimeout)
               iStartTime         = mtime
               mhSocket:sensitive = true.
        
        Logger:Debug(substitute('WaitAsync: Timeout(s)=&1':u, pdTimeout)).
        
        // PAUSE 0 means don't wait
        if pdTimeout eq 0 then
            wait-for 'U2':u of mhSocket.
        else
            wait-for 'U2':u of mhSocket pause pdTimeout.
        
        Logger:Debug(substitute('WaitAsync: total time(ms)=&1':u, mtime - iStartTime)).
        Logger:Debug(substitute('WaitAsync: total size(b)=&1':u, miTotalBytesRead)).
        
        // if we have all the data then we've not timed out 
        if not moReadEventArgs:ReadComplete or
           moReadEventArgs:ReadTimeout then
        do:
            Logger:Debug('WaitAsync: socket timed out':u).
            // we're done here 
            assign moReadEventArgs:ReadComplete = true.
            OnReadTimeout(moReadEventArgs).
        end.
        
        /* 'catch' the errors from the handler after the wait-for.
           issue PSC00322919 logged to avoid this. */
        if valid-object(moReadHandlerError) then
        do:
            Logger:Trace('WaitAsync: read error':u, moReadHandlerError).
            return error moReadHandlerError.
        end.
    end method.
    
    /** Callback/event procedure fired on the READ-RESPONSE event of the 
        socket. */
    method public void ReadResponseHandler():
        define variable mData as memptr no-undo.
        define variable iBytesAvailable as integer no-undo.
        define variable iStartTime as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable oError as AppError no-undo.
        define variable lReadOk as logical no-undo.
        
        ERROR-CATCHER-BLOCK:
        do on error undo, leave:
            /* this is needed to stop the read trigger from firing whilst processing
               in theory this should not be needed, but after suggestions from Greg Higgins
               and experimentation it seems to be the "chicken soup" solution for sockets that
               READKEY PAUSE 0 is for other areas */
            assign mhSocket:sensitive = no
                   iStartTime         = mtime
                   /* don't want any residual errors. this line is why we love structured-error-handling */
                   error-status:error = false
                   .
            /* Read. If nothing, check and try read. */
            /* now set the proper size */
            set-size(mData) = this-object:ReadBufferSize.
            
            /* read all the available bytes */
            assign lReadOk = mhSocket:read(mData, 1, this-object:ReadBufferSize, read-available)
                   iBytesAvailable = mhSocket:bytes-read
                   no-error.
            Logger:Debug(substitute('ReadHandler: OK? &1':u, lReadOk)).
            Logger:Debug(substitute('ReadHandler: time(ms)=&1':u, mtime - iStartTime)).
            Logger:Debug(substitute('ReadHandler: size(b)=&1':u,  iBytesAvailable)).
            
            // maybe the READ just primed the pump. check and read again, if there are now bytes 
            if iBytesAvailable eq 0 and not error-status:error then
            do:
                assign iStartTime      = mtime
                       iBytesAvailable = mhSocket:get-bytes-available()
                       .
                if iBytesAvailable gt 0 then
                do:
                    Logger:Debug(substitute('ReadHandler: AVAIL(b)=&1':u, iBytesAvailable)).
                    
                    assign lReadOk = mhSocket:read(mData, 1, this-object:ReadBufferSize, read-available)
                           no-error.
                    
                    Logger:Debug(substitute('ReadHandler: OK? &1':u, lReadOk)).
                    Logger:Debug(substitute('ReadHandler: time(ms)=&1':u, mtime - iStartTime)).
                    Logger:Debug(substitute('ReadHandler: size(b)=&1':u,  iBytesAvailable)).
                end.
            end.
            
            /* We can determine whether the socket disconnected thusly:
                - Calling the READ( ) method on the socket object returns an error
                - The value returned by a GET-BYTES-AVAILABLE( ) method invoked on the
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
                                
                /* Read is terminated. We're done here.  */
                assign moReadEventArgs:ReadComplete   = true
                       moReadEventArgs:ReadTerminated = true.
                
                /* throw 'em if you got 'em */
                if valid-object(oError) then
                do:
                    Logger:Error('ReadHandler: ERROR':u, oError).
                    
                    undo, throw oError.
                end.

                OnReadTerminated(moReadEventArgs).
            end.
            else
            do:
                assign moReadEventArgs:BytesRead = mhSocket:bytes-read
                       /* store the available bytes in case there are none. */
                       miTotalBytesRead = miTotalBytesRead + mhSocket:bytes-read
                       no-error.
                if (lReadOk and moReadEventArgs:BytesRead eq 0) then
                    assign moReadEventArgs:ReadTimeout = true.
                else
                do:
                    /* Add this data to the eventargs */
                    assign moReadEventArgs:Data = new Memptr(get-pointer-value(mData),
                                                      get-size(mData))
                           iStartTime           = mtime.                                                      
                    /* tell any listeners that we have new data */
                    OnDataReceived(moReadEventArgs).
                    
                    Logger:Debug(substitute('ReadHandler:OnDataReceived time(ms)=&1':u, mtime - iStartTime)).
                end.    // got data
            end.
            
            /* if we're all out of time  and haven't timed out yet */
            if  moReadEventArgs:ReadTimeout     or 
               (moReadEventArgs:TimeoutEnd ne ? and
                moReadEventArgs:TimeoutEnd le now) then
            do on error undo, throw:
                Logger:Debug('ReadHandler: read timeout':u).
                
                // for the 2nd condition above 
                assign moReadEventArgs:ReadComplete = true
                       moReadEventArgs:ReadTimeout  = true.
                OnReadTimeout(moReadEventArgs).
                /* Swallow any errors and use old-fashioned class-variables to
                   pass the errors onwards & upwards :( */
                catch eError as Error:
                    assign moReadHandlerError = eError.
                end catch.
            end.
            
            /* Swallow any errors and use old-fashioned class-variables to
               pass the errors onwards & upwards :( */
            catch eError as Error:
                assign moReadHandlerError           = eError
                       // We didn't timeout or terminate, but we _are_ all done
                       moReadEventArgs:ReadComplete = true
                       .
            end catch.
            finally:
                /* more chicken soup (see above) */
                assign mhSocket:sensitive = yes.
            end finally.
        end.    /* ERROR-CATCHER-BLOCK */
            
        /** ALL DONE **/
        /* stop listening if we've got all the data, or
           the read is otherwise done (diconnect/no data) */
        if valid-object(moReadHandlerError) or
           moReadEventArgs:ReadComplete then
        do:
            Logger:Debug(substitute('ReadHandler: ReadComplete? &1':u,   moReadEventArgs:ReadComplete)).
            Logger:Debug(substitute('ReadHandler: ReadTimeout? &1':u,    moReadEventArgs:ReadTimeout)).
            Logger:Debug(substitute('ReadHandler: ReadTerminated? &1':u, moReadEventArgs:ReadTerminated)).
            
            if valid-object(moReadHandlerError) then
                if Logger:LogLevel ge LogLevelEnum:DEBUG then
                    Logger:Debug('ReadHandler: ERROR':u, moReadHandlerError).
                else
                    Logger:Error('ReadHandler: ERROR':u, moReadHandlerError).
            
            apply "U2":u to mhSocket.
        end.
        
        finally:
            assign moReadEventArgs:Data = ?
                   moReadEventArgs:BytesRead = 0
                   .
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
        set-size(mData) = 1. /* allocate a new 1-byte memptr */
        set-size(mData) = 0. /* free this 1-byte memptr, which also clears the size */
        set-pointer-value(mData) = poData:GetPointerValue().
        set-size(mData) = iSize.
        
        do while iSize gt 0 :
            assign iStartTime = mtime.
            
            mhSocket:write(mData, iStart, iSize).
            
            Logger:Debug(substitute('Write: time(ms)=&1':u, mtime - iStartTime)).
            Logger:Debug(substitute('Write: size(b)=&1':u, iSize)).
            
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
            if get-size(mData) gt 0 then
                set-size(mData) = 0.
        end.
    end method.
    
    /* Sets the various socket options, per this object's properties.
       
       @param handle The socket on which to set these options */
    method private void SetSocketOptions(input phSocket as handle):
        define variable cLinger as character no-undo.
        
        Assert:IsTrue(valid-handle(phSocket) and phSocket:connected(), 'Socket connected').

        if this-object:KeepAlive ne ? then
        do:
            Logger:Debug(substitute('SO-KEEPALIVE: &1':u, this-object:KeepAlive)).
            phSocket:set-socket-option('SO-KEEPALIVE':u, trim(string(this-object:KeepAlive, 'true/false':u))).
        end.
        
        if this-object:NoDelay ne ? then
        do:
            Logger:Debug(substitute('TCP-NODELAY: &1':u, this-object:NoDelay)).
            phSocket:set-socket-option("TCP-NODELAY":U, trim(string(this-object:NoDelay, 'true/false':u))).
        end.
        
        if this-object:ReuseAddress ne ? then
        do:
            Logger:Debug(substitute('SO-REUSEADDR: &1':u, this-object:ReuseAddress)).
            phSocket:set-socket-option("SO-REUSEADDR":U, trim(string(this-object:ReuseAddress, 'true/false':u))).
        end.
        
        if this-object:ReceiveBufferSize ne ? then
        do:
            Logger:Debug(substitute('SO-RCVBUF: &1':u, this-object:ReceiveBufferSize)).
            phSocket:set-socket-option("SO-RCVBUF":U, string(this-object:ReceiveBufferSize)).
        end.
        
        if this-object:SendBufferSize ne ? then
        do:
            Logger:Debug(substitute('SO-SNDBUF: &1':u, this-object:SendBufferSize)).
            phSocket:set-socket-option("SO-SNDBUF":U, string(this-object:SendBufferSize)).
        end.
        
        if this-object:ReceiveTimeout ne ? then
        do:
            Logger:Debug(substitute('SO-RCVTIMEO: &1':u, this-object:ReceiveTimeout)).
            phSocket:set-socket-option("SO-RCVTIMEO":U, string(this-object:ReceiveTimeout)).
        end.
        
        if this-object:LingerTime ne -1 then
        do:
            if this-object:LingerTime eq ? then
                assign cLinger = 'false':u.
            else
                assign cLinger =  'true,' + string(this-object:LingerTime). 
            
            Logger:Debug(substitute('SO-LINGER: &1':u, cLinger)).            
            phSocket:set-socket-option("SO-LINGER":U, cLinger).
        end.
    end method.
    
    /* Indicated whether we have a connection
    
       @return logical TRUE is the socket is connected; false otherwise */
    method protected logical IsConnected():
        return valid-handle(mhSocket) and mhSocket:connected().
    end method.
    
    /* Starts a new TLS (for insecure connections), or changes (for already-secure)
       connections, the certificates used to decrypt the traffic. Used primarily
       for HTTP proxy tunnelling. 
       
       @param character The certificate subject (host) name */
    method public void StartTls(input pCertificatSubjectName as character):
        define variable optionName as character no-undo.
        
        Assert:NotNullOrEmpty(pCertificatSubjectName, 'Certificate subject name').
        assign optionName = 'TCP-STARTTLS':u.
        
        Logger:Debug(substitute('Subject name for TCP-STARTTLS: &1':u, pCertificatSubjectName)).
        mhSocket:set-socket-option(optionName, pCertificatSubjectName).
    end method.
    
end class.