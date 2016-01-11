 
 /*------------------------------------------------------------------------
    File        : prodict.pro.tenant-model
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Fri Feb 18 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.* from propath.

using OpenEdge.DataAdmin.Binding.ServiceAdapter from propath.
using OpenEdge.DataAdmin.Binding.Connection from propath.

using OpenEdge.DataAdmin.Message.IFetchRequest from propath.


using OpenEdge.DataAdmin.Message.FetchRequest from propath.
using prodict.misc._query from propath.

class prodict.pro._tenant-model inherits prodict.pro._pro-model: 
    {daschema/tenant.i}
    
    define dataset dsTenant for ttTenant.
      
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
	constructor public _tenant-model (  ):
		super ("Tenant",dataset dsTenant:handle).		
	end constructor.
  
   
end class.