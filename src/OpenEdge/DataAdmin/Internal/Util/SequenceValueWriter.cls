 /*************************************************************/
  /* Copyright (c) 2011 by progress Software Corporation.      */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    File        : SequenceValueExport
    Purpose     : wrapper for dataadmin sequence value export
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Apr 28  
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Internal.Util.SequenceExportUtility.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Internal.Util.SequenceValueWriter inherits SequenceExportUtility: 
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	
	constructor public SequenceValueWriter(   ):
        super ("SequenceValueWriter").
	end constructor.
	
  
end class.