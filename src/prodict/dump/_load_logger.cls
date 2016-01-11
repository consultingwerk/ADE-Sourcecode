 
 /*------------------------------------------------------------------------
    File        : _load_options
    Purpose     : Options for prodict/dump/_load_df.p
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Oct 12 15:49:55 EDT 2010
    Notes       : implemented to avoid runtime dependencies of OpenEdge.DataAdmin
                  Known usage
                     prodict/load_df_silent.p.
  ----------------------------------------------------------------------*/

using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.Binding.DataDefinitionLoader from propath.
routine-level on error undo, throw.

class prodict.dump._load_logger inherits DataDefinitionLoader: 
 	constructor public _load_logger (  ):
		super ().
		IsReader = false. /* just to make it clear (this is default)*/		
	end constructor.

end class.