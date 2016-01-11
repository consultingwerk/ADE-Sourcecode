
/*------------------------------------------------------------------------
    File        : ITableDataUtility.cls
    Purpose     : wrapper for dump and load of tables tenant data in .d 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Apr 28 00:16:34 EDT 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Internal.Util.IDataUtility.

interface OpenEdge.DataAdmin.Internal.Util.ITableDataUtility inherits IDataUtility:  
    define public property UseDefaultLocation as logical     no-undo get. set.  
    define public property NoLobs             as logical     no-undo get. set.  
    define public property Directory          as character   no-undo get. set.  
    define public property TenantDirectory    as character   no-undo get. set.  
    define public property LobDirectory       as character   no-undo get. set.  
    define public property TenantLobDirectory as character   no-undo get. set. 

end interface.