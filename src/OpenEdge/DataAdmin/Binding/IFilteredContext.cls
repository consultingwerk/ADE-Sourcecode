
/*------------------------------------------------------------------------
    File        : IFilteredContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Wed Aug 18 21:04:08 EDT 2010
    Notes       : FilteredContext is unique per instance and filters the 
                  underlying data to match the instance.
                  It should probably inherit IDataAdminContext.  
                  It has an abstract implementation that also implements 
                  IDataAdminContext instead and ensures that the collections
                  and entitites does not need to know the difference  
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.
using Progress.Lang.*.

interface OpenEdge.DataAdmin.Binding.IFilteredContext:  
    define public property Model as IDataAdminModel no-undo  get.
   
    define public property Filter as character  no-undo  get. 
    define public property RequestInfo as IRequestInfo no-undo get. set.
    method public int IndexOf(c as char).
    method public IDataAdminElement FindEntityAtRow(piRow as integer).
   
end interface.
