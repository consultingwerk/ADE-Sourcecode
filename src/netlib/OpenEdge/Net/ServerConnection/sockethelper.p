/*------------------------------------------------------------------------
    File        : sockethelper.p
    Purpose     : Pass-through for socket READ-RESPONSE events 
    Author(s)   : pjudge 
    Created     : Tue Nov 25 09:13:55 EST 2014
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.ServerConnection.ClientSocket.
using OpenEdge.Core.Assert.

/* ***************************  Main Block  *************************** */
define input parameter poSocket as class ClientSocket no-undo.
define input parameter pcCallbackName as character no-undo.

Assert:NotNull(poSocket, 'Client socket').
Assert:NotNullOrEmpty(pcCallbackName, 'Callback name').

procedure ReadResponseHandler:
    /* passthrough */
    dynamic-invoke(poSocket, pcCallbackName).
    return.
end procedure.
/* eof */