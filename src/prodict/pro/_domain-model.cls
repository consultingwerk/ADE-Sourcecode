 
 /*------------------------------------------------------------------------
    File        : prodict.pro.domain-model
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Fri Feb 18 2011
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
using Progress.Lang.* from propath.
using prodict.pro._pro-model from propath.

class prodict.pro._domain-model inherits  _pro-model: 
    {daschema/domain.i}
    
    define dataset dsDomain for ttDomain.
      
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
	constructor public _domain-model (  ):
		super ("Domain",dataset dsDomain:handle).		
	end constructor.
  
 
end class.