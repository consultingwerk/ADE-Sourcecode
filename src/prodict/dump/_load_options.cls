 
 /*------------------------------------------------------------------------
    File        : _load_options
    Purpose     : Options for prodict/dump/_load_df.p
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Oct 12 15:49:55 EDT 2010
    Notes       : Known usage 
                    prodict/load_df.p. prodict/load_df_silent.p
  ----------------------------------------------------------------------*/

using Progress.Lang.* from propath.
using prodict.dump._load_logger from propath.
using OpenEdge.DataAdmin.Binding.DataDefinitionOptions from propath.

routine-level on error undo, throw.

class prodict.dump._load_options inherits DataDefinitionOptions: 
     		
	constructor public _load_options (  logger as _load_logger ):
		super (logger).
		/* init ? - important - signal to not touch session:schema-change
		   see notes IDataDefinitionOptions */
		assign
		  AddObjectsOnline = ?
		  SchemaChange = ?.
	end constructor.

	constructor public _load_options (  ):
		this-object(?).	
	end constructor.

end class.