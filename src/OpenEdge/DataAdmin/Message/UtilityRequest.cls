 
 /*------------------------------------------------------------------------
    File        : UtilityRequest.cls
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Sep 30   2010
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Message.DataAdminMessage from propath.
using OpenEdge.DataAdmin.Message.IUtilityRequest from propath.
routine-level on error undo, throw.

class OpenEdge.DataAdmin.Message.UtilityRequest 
                        inherits DataAdminMessage
                        implements IUtilityRequest    : 
     
    /* init true 
       - replace on client - append on server (complex queries)
       - better separation - deep copy from dataaccess (overhead, but small - ?)
       - can be split to run on server (see serviceAdapter) 
      */   
    define public property UseReplaceOnClient as logical init true no-undo get. set.
         
    constructor public UtilityRequest (pname as char,h as handle ):
		super (pname,h). 
	end constructor.
    
end class.