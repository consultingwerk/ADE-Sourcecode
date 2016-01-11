/** ------------------------------------------------------------------------
    File        : IServerConnection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 28 15:02:14 EST 2013
    Notes       : * This class based on the AutoEdge|TheFactory version
  ---------------------------------------------------------------------- */
using OpenEdge.Core.ServerConnection.IConnectionParameters.
using Progress.Lang.Object.

interface OpenEdge.Core.ServerConnection.IServerConnection:
    /** A reference to the actual server. The type of this property depends on the server type 
        (since AppServers have HANDLEs, BPMServers have IBizLogicAPI and databases none.The Object 
        acts as a wrapper for handle-based servers */
    define public property Server as Object no-undo get.

    /** Parameters for this connection */
    define public property ConnectionParameters as IConnectionParameters no-undo get.

    /**  Returns true if the server is valid and connected. False otherwise */
    define public property Connected as logical no-undo get.
    
    /** Creates a server object (ie this-object:Server). This is separated
        from the Connect/Disconnect pair of methods so that one server can 
        be connected and disconnected multiple time. */
    method public void CreateServer().

    /** Destroys the server object (ie this-object:Server). This is separated
        from the Connect/Disconnect pair of methods so that one server can 
        be connected and disconnected multiple time. */
    method public void DestroyServer().

    /** Connect to the server specified, based on the ConnectionParameters */
    method public void Connect().
    
    /** Disconnect from the server, if connected */    
    method public void Disconnect().
    
end interface.