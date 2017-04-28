/************************************************
Copyright (c) 2013, 2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : WebServiceConnection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 28 16:24:59 EST 2013
    Notes       : 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.ServerConnection.IServerConnection.
using OpenEdge.Core.ServerConnection.IConnectionParameters.
using OpenEdge.Core.ServerConnection.WebServiceConnectionParameters.

using OpenEdge.Core.Assert.
using OpenEdge.Core.WidgetHandle.

using Progress.Lang.Object.

class OpenEdge.Core.ServerConnection.WebServiceConnection use-widget-pool 
        implements IServerConnection: 
    /** A reference to the actual server. The type of this property depends on the server type 
        (since AppServers have HANDLEs, BPMServers have IBizLogicAPI and databases none. The Object 
        acts as a wrapper for handle-based servers */
    define public property Server as Object no-undo get. private set.

    /** Parameters for this connection */
    define public property ConnectionParameters as IConnectionParameters no-undo get. private set.

    /**  Returns true if the server is valid and connected. False otherwise */
    define public property Connected as logical no-undo
        get():
            define variable lConnected as logical no-undo.
            define variable hServer as handle no-undo.
            
            lConnected = valid-object(this-object:Server).
            if lConnected then
                assign hServer = cast(Server, WidgetHandle):Value
                       lConnected = valid-handle(hServer).
            if lConnected then
                lConnected = hServer:connected().
            
            return lConnected.
        end get.
    
    define public property ServiceName as character no-undo 
        get():
            if this-object:ServiceName eq '' then
                this-object:ServiceName = cast(ConnectionParameters, WebServiceConnectionParameters):ServiceName.
            return this-object:ServiceName.                 
        end get. 
        private set.

    define public property PortName as character no-undo 
        get():
            if this-object:PortName eq '' then
                this-object:PortName = cast(ConnectionParameters, WebServiceConnectionParameters):PortName.
            return this-object:PortName.                 
        end get. 
        private set.
    
    define public property Operation as character no-undo
        get():
            if this-object:Operation eq '':u then
                this-object:Operation = cast(ConnectionParameters, WebServiceConnectionParameters):Operation.
            return this-object:Operation.                 
        end get. 
        private set.
        
    constructor public WebServiceConnection(input poConnectionParameters as WebServiceConnectionParameters):
        Assert:NotNull(poConnectionParameters, 'Connection Parameters').  
        ConnectionParameters = poConnectionParameters.
    end constructor.
    
    destructor WebServiceConnection():
        this-object:DestroyServer().
    end destructor.
    
    /** Connect to the server specified, based on the ConnectionParameters */
    method public void Connect():
        define variable hServer as handle no-undo.

        if not valid-object(this-object:Server) then
            CreateServer().
        
        hServer = cast(this-object:Server, WidgetHandle):Value.
        
        hServer:connect(this-object:ConnectionParameters:GetConnectionString()).
    end method.
    
    /** Disconnect from the server, if connected */    
    method public void Disconnect():
        if this-object:Connected then
            cast(Server, WidgetHandle):Value:disconnect().
    end method.

    /** Creates a server object (ie this-object:Server). This is separated
        from the Connect/Disconnect pair of methods so that one server can 
        be connected and disconnected multiple time. */
    method public void CreateServer():
        define variable hServer as handle no-undo.
        
        create server hServer.
        assign this-object:Server = new WidgetHandle(hServer, true /*autodestroy*/ ).
    end method.

    /** Destroys the server object (ie this-object:Server). This is separated
        from the Connect/Disconnect pair of methods so that one server can 
        be connected and disconnected multiple time. */
    method public void DestroyServer():
        define variable hServer as handle no-undo.
        
        if this-object:Connected then
            this-object:Disconnect().

        if not valid-object(this-object:Server) then
            return.
        assign this-object:Server = ?.
    end method.    
    
end class.